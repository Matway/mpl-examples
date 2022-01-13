using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Resources;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

using Microsoft.Build.CPPTasks;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;

namespace Matway.MSBuild
{
  public class MplMultiTaskTool : TrackedVCToolTask
  {
    public MplMultiTaskTool() : base(new ResourceManager("Microsoft.Build.CPPTasks.Strings", typeof(TrackedVCToolTask).Assembly)) { }

    [Required]
    public ITaskItem[] Sources { get; set; }

    [Required]
    public string TrackerLogDirectory { get; set; }

    private string Worker { get { return "MPL"; } }

    public override bool Execute()
    {
      if (YieldDuringToolExecution) BuildEngine3.Yield();

      Initialize();

      var result = true;
      try
      {
        Exception executionErrors = null;
        result = new ParallelExecutor(OutdatedTasks, EndToken).Execute(out executionErrors);
        if (executionErrors is object) throw executionErrors;
      }
      catch (AggregateException e)
      {
        var origin = e.InnerException as OperationCanceledException;

        if (origin is object && result)
        {
          Log.LogWarning("The build task has been canceled.");
        }
        else
        {
          var errors = e.InnerExceptions.Where(a => a as OperationCanceledException == null);
          if (errors.Any())
          {
            foreach (var error in errors) Log.LogErrorFromException(error, true);
          }
          else
          {
            Log.LogErrorFromException(e, false);
          }

          result = false;
        }
      }
      finally
      {
        result = FinishBuild(0) == 0 && result;
      }

      if (YieldDuringToolExecution) BuildEngine3.Reacquire();

      return result;
    }

    private void SetupTask(TrackedVCToolTask a)
    {
      SetProperty(a, "TrackerLogDirectory", TrackerLogDirectory);

      a.EnableExecuteTool = true;
      a.BuildEngine = BuildEngine;
      a.HostObject = HostObject;

      // All the tasks are outdated. So they must be forced to recompile.
      a.MinimalRebuildFromTracking = false;

      // If the tasks will clean up by themselves then they will try to modify the same files concurrently.
      a.PostBuildTrackingCleanup = false;

      a.EnvironmentVariables = new string[] { "TRACKER_ADDPIDTOTOOLCHAIN=1" };
    }

    private void Initialize()
    {
      toolMetadata = new MplCompile();

      if (string.IsNullOrEmpty(ToolExe)) ToolExe = toolMetadata.ToolExe;

      TrackFileAccess = true;
      MinimalRebuildFromTracking = true;

      FindOutOutdetedFiles();
    }

    private void FindOutOutdetedFiles()
    {
      TrackCommandLines = false;
      SkipTaskExecution();

      var previousSources = MapSourcesToCommandLines();
      var outdatedSources = SourcesCompiled.Select(ConstructSource);
      var allSources = Sources.Select(ConstructSource).ToList();
      var allOutdetedSources =
        allSources.Where(a =>
        {
          string cmd;
          return !(previousSources.TryGetValue(a.File, out cmd) && cmd == a.CommandLine);
        }).Union(outdatedSources, new Cmp());

      OutdatedTasks = allOutdetedSources.Select(a => a.Metadata).ToList();
      SourcesCompiled = OutdatedTasks.Select(a => GetWorkItems(a).First()).ToArray();

      foreach (var task in OutdatedTasks) SetupTask(task);

      sourcesToCommandLines = allSources.ToDictionary(a => a.File, a => a.CommandLine);
    }

    private class Cmp : IEqualityComparer<Source>
    {
      public bool Equals(Source x, Source y) { return x.CommandLine == y.CommandLine && x.File == y.File; }
      public int GetHashCode(Source obj) { return obj.CommandLine.GetHashCode() ^ obj.File.GetHashCode(); }
    }

    private Source ConstructSource(ITaskItem a)
    {
      var task = ConstructTask(a);
      var src = ApplyPrecompareCommandFilter(FileTracker.FormatRootingMarker(a));
      var cmd = ApplyPrecompareCommandFilter(task.GenerateCommandLineExceptSwitches(
        new[] { task.SourcesPropertyName },
        CommandLineFormat.ForTracking, EscapeFormat.Default
      )) + " " + src.ToUpperInvariant();

      return new Source()
      {
        CommandLine = cmd,
        File = src,
        Metadata = task
      };
    }

    private TrackedVCToolTask ConstructTask(ITaskItem a)
    {
      var task = Activator.CreateInstance(toolMetadata.GetType()) as TrackedVCToolTask;
      SetProperty(task, task.SourcesPropertyName, new[] { a });

      return task;
    }

    private struct Source
    {
      public string CommandLine;
      public string File;
      public TrackedVCToolTask Metadata;
    }

    private static ITaskItem[] GetWorkItems(TrackedVCToolTask task)
    {
      return task.GetType().GetProperty(task.SourcesPropertyName).GetValue(task) as ITaskItem[];
    }

    private static void SetProperty(object instance, string field, object value)
    {
      instance.GetType().GetProperty(field).SetValue(instance, value);
    }

    private int FinishBuild(int exitCode)
    {
      AssumeLogs();

      var result = PostExecuteTool(exitCode);

      if (sourcesToCommandLines is object)
      {
        WriteSourcesToCommandLinesTable(sourcesToCommandLines);
      }

      return result;
    }

    private void AssumeLogs()
    {
      var readingsLog = Path.Combine(TrackerLogDirectory, ReadTLogNames.First().Replace('*', '1'));
      var writingsLog = Path.Combine(TrackerLogDirectory, WriteTLogNames.First().Replace('*', '1'));

      AssumeFile(readingsLog);
      AssumeFile(writingsLog);
    }

    private static void AssumeFile(string file)
    {
      // We want to create a file, but if it will be empty one, then it will be deleted.
      // So we put just something in it.
      if (!File.Exists(file)) File.AppendAllText(file, "#DUMMY\r\n", Encoding.Unicode);
    }

    protected override bool UseMinimalRebuildOptimization { get { return true; } }

    protected override ITaskItem[] TrackedInputFiles { get { return Sources; } }

    protected override string TrackerIntermediateDirectory
    {
      get { return TrackerLogDirectory ?? string.Empty; }
    }

    #region Tracker Logs
    /*
      Each tool will be launched by a tracker, and the tracker will generate logs marked with the process' pid.
      I.e. the logs will looks like this:
        mplc.1984.write.tlog
        mplc.1984.read.tlog
      Doing so, each tracker will write only to its own logs, and not interference with other trackers.
      After compilation, there will be a bunch of logs, and we will merge them to our own logs:
        _MPL.write.tlog
        _MPL.read.tlog
      After that, all tools' logs mplc.*.*.tlog will be deleted.
      After that, we will generate a command log file named _MPL.command.tlog.

      When partial compilation disabled, then tool will be launched by MplCompile, and the logs will be w\o a pid.
      I.e. the logs will looks like this:
        mplc.write.tlog
        mplc.read.tlog
      After tool execution, MplCompile will generate a command log file named mplc.command.tlog.

      Doing so, we can guaranty* that partial and non-partial compilation will not interference with each other.

      * If, by some reason, MultiTaskTool will not be able to merge the mplc.*.*.tlog logs,
        then MplCompile still will be able to merge them to mplc.write\read.tlog logs.
        So, possibly, the logs will be corrupted.
    */

    protected override string[] ReadTLogNames
    {
      get
      {
        var tool = Path.GetFileNameWithoutExtension(ToolExe);
        return new string[]
        {
          "_" + Worker + ".read.*.tlog",
          tool + ".*.read.*.tlog",
          tool + "-*.read.*.tlog",
          tool + ".delete.*.tlog",
          tool + ".*.delete.*.tlog",
          tool + "-*.delete.*.tlog"
        };
      }
    }

    protected override string[] WriteTLogNames
    {
      get
      {
        var tool = Path.GetFileNameWithoutExtension(ToolExe);
        return new string[]
        {
          "_" + Worker + ".write.*.tlog",
          tool + ".*.write.*.tlog",
          tool + "-*.write.*.tlog"
        };
      }
    }

    protected override string[] DeleteTLogNames
    {
      get
      {
        var tool = Path.GetFileNameWithoutExtension(ToolExe);
        return new string[]
        {
          tool + ".*.delete.*.tlog",
          tool + "-*.delete.*.tlog"
        };
      }
    }

    protected override string CommandTLogName { get { return "_" + Worker + ".command.1.tlog"; } }

    #endregion

    protected override string ToolName { get { return null; } }

    public override void Cancel() { EndToken.Cancel(true); }

    private readonly CancellationTokenSource EndToken = new CancellationTokenSource();
    private TrackedVCToolTask toolMetadata;
    private IDictionary<string, string> sourcesToCommandLines;
    private List<TrackedVCToolTask> OutdatedTasks { get; set; }
  }

  internal class ParallelExecutor
  {
    private bool Result = true;
    private readonly CancellationTokenSource EndToken;
    private readonly ConcurrentQueue<TrackedVCToolTask> Tasks;
    private readonly System.Threading.Tasks.Task[] Threads;

    public ParallelExecutor(IEnumerable<TrackedVCToolTask> tasks, CancellationTokenSource endToken, int desiredParallelism = 0)
    {
      Tasks = new ConcurrentQueue<TrackedVCToolTask>(tasks);
      EndToken = endToken;

      var parallelism = Math.Min(desiredParallelism < 1 ? Environment.ProcessorCount : desiredParallelism, Tasks.Count);
      Threads = Enumerable.Range(0, parallelism).Select(a => new System.Threading.Tasks.Task(Worker, TaskCreationOptions.LongRunning)).ToArray();
    }

    public bool Execute(out Exception exceptions)
    {
      exceptions = null;

      if (Tasks.Count() == 0) return true;

      foreach (var thread in Threads) thread.Start();

      try { System.Threading.Tasks.Task.WaitAll(Threads); }
      catch (Exception e) { exceptions = e; }

      return Result;
    }

    private void Worker()
    {
      while (!Tasks.IsEmpty)
      {
        if (EndToken.IsCancellationRequested) throw new OperationCanceledException(EndToken.Token);

        TrackedVCToolTask currentTask;
        if (!Tasks.TryDequeue(out currentTask)) continue;

        var success = false;
        try
        {
          success = currentTask.Execute();
        }
        finally
        {
          if (!success && Result)
          {
            Result = false;
            EndToken.Cancel();
          }
        }
      }
    }
  }

  public class MplCompile : TrackedVCToolTask
  {
    protected override ArrayList SwitchOrderList { get { return switchOrderList; } }
    protected override string ToolName { get { return "mplc"; } }
    protected override ITaskItem[] TrackedInputFiles { get { return InputFiles; } }
    protected override string TrackerIntermediateDirectory { get { return trackerLogsFolder; } }

    private static readonly ArrayList switchOrderList = new ArrayList
    {
      "PointerSize",
      "Definitions",
      "IncludeFolders",
      "CallTrace",
      "ShowMemoryUsage",
      "AdditionalDependencies",
      "DisableDebugInfo",
      "OutputFile",
      "PartialCompilation",
      "RecursionDepthLimit",
      "StaticLoopLimit",
      "AdditionalOptions",
      "InputFiles"
    };

    private String trackerLogsFolder;

    [Required]
    public ITaskItem[] InputFiles
    {
      get { return ActiveToolSwitches["InputFiles"].TaskItemArray; }
      set { ActiveToolSwitches["InputFiles"] = new ToolSwitch(ToolSwitchType.ITaskItemArray) { TaskItemArray = value }; }
    }

    [Required]
    public string TrackerLogsFolder { set { trackerLogsFolder = value; } }

    public string TrackerLogDirectory { set { trackerLogsFolder = value; } }

    public override string SourcesPropertyName { get { return "InputFiles"; } }

    public MplCompile() : base(new ResourceManager("Microsoft.Build.CPPTasks.Strings", typeof(TrackedVCToolTask).Assembly))
    {
      MinimalRebuildFromTracking = true;
      TrackFileAccess = true;
    }

    protected override bool ComputeOutOfDateSources()
    {
      if (InputFiles[0].GetMetadata("PartialCompilation") != "true")
      {
        AssignDefaultTLogPaths();
        SourceOutputs = new CanonicalTrackedOutputFiles(this, TLogWriteFiles);
        foreach (ITaskItem file in InputFiles)
        {
          SourceOutputs.AddComputedOutputForSourceRoot(FileTracker.FormatRootingMarker(file), file.GetMetadata("OutputFile"));
        }

        SourceOutputs.SaveTlog();
      }

      return base.ComputeOutOfDateSources();
    }

    protected override int ExecuteTool(string pathToTool, string responseFileCommands, string commandLineCommands)
    {
      foreach (ITaskItem file in InputFiles) Log.LogMessage(MessageImportance.High, file.ItemSpec);
      return base.ExecuteTool(pathToTool, responseFileCommands, commandLineCommands);
    }

    protected override string GenerateCommandLineCommands()
    {
      return base.GenerateResponseFileCommands();
    }

    protected override string GenerateResponseFileCommands()
    {
      return string.Empty;
    }

    protected override void PostProcessSwitchList()
    {
      var firstFile = InputFiles.First();
      ToolExe = firstFile.GetMetadata("CompilerPath");

      ToolSwitch argument;

      argument = new ToolSwitch(ToolSwitchType.String) { MultipleValues = true };
      if (firstFile.GetMetadata("PointerSize") == "32") argument.SwitchValue = "-32bits";
      else if (firstFile.GetMetadata("PointerSize") == "64") argument.SwitchValue = "-64bits";
      ActiveToolSwitches["PointerSize"] = argument;

      ActiveToolSwitches["Definitions"] = new ToolSwitch(ToolSwitchType.StringArray) { StringList = firstFile.GetMetadata("Definitions").Split(';'), SwitchValue = "-D " };
      ActiveToolSwitches["IncludeFolders"] = new ToolSwitch(ToolSwitchType.StringPathArray) { StringList = firstFile.GetMetadata("IncludeFolders").Split(';'), SwitchValue = "-I " };

      argument = new ToolSwitch(ToolSwitchType.String) { MultipleValues = true };
      if (firstFile.GetMetadata("CallTrace") == "SingleThreaded") argument.SwitchValue = "-call_trace 1";
      else if (firstFile.GetMetadata("CallTrace") == "MSVC") argument.SwitchValue = "-call_trace 2";
      ActiveToolSwitches["CallTrace"] = argument;

      if (firstFile.GetMetadata("ShowMemoryUsage") != "true") ActiveToolSwitches.Remove("ShowMemoryUsage");
      else ActiveToolSwitches["ShowMemoryUsage"] = new ToolSwitch(ToolSwitchType.String) { MultipleValues = true, SwitchValue = "-debug_memory" };

      ActiveToolSwitches["AdditionalDependencies"] = new ToolSwitch(ToolSwitchType.StringArray) { StringList = firstFile.GetMetadata("AdditionalDependencies").Split(';'), SwitchValue = "-linker_option /DEFAULTLIB:" };

      if (firstFile.GetMetadata("DisableDebugInfo") != "true") ActiveToolSwitches.Remove("DisableDebugInfo");
      else ActiveToolSwitches["DisableDebugInfo"] = new ToolSwitch(ToolSwitchType.String) { MultipleValues = true, SwitchValue = "-ndebug" };

      ActiveToolSwitches["OutputFile"] = new ToolSwitch(ToolSwitchType.File) { SwitchValue = "-o ", Value = firstFile.GetMetadata("OutputFile") };

      if (firstFile.GetMetadata("PartialCompilation") != "true") ActiveToolSwitches.Remove("PartialCompilation");
      else ActiveToolSwitches["PartialCompilation"] = new ToolSwitch(ToolSwitchType.String) { MultipleValues = true, SwitchValue = "-part" };

      if (firstFile.GetMetadata("RecursionDepthLimit") == "") ActiveToolSwitches.Remove("RecursionDepthLimit");
      else ActiveToolSwitches["RecursionDepthLimit"] = new ToolSwitch(ToolSwitchType.Integer) { IsValid = true, Number = int.Parse(firstFile.GetMetadata("RecursionDepthLimit")), SwitchValue = "-recursion_depth_limit " };

      if (firstFile.GetMetadata("StaticLoopLimit") == "") ActiveToolSwitches.Remove("StaticLoopLimit");
      else ActiveToolSwitches["StaticLoopLimit"] = new ToolSwitch(ToolSwitchType.Integer) { IsValid = true, Number = int.Parse(firstFile.GetMetadata("StaticLoopLimit")), SwitchValue = "-static_loop_length_limit " };

      AdditionalOptions = firstFile.GetMetadata("AdditionalOptions");
    }
  }
}
