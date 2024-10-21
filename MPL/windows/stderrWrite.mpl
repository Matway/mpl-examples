"String.String"         use
"String.addTerminator"  use
"String.makeStringView" use
"control.Int32"         use
"control.Intx"          use
"control.Nat32"         use
"control.Natx"          use
"control.pfunc"         use
"control.when"          use
"conventions.cdecl"     use

{
  index: Nat32;
} Natx {convention: cdecl;} "__acrt_iob_func" importFunction

{
  format:         Natx;
  fileDescriptor: Natx;
} Int32 {convention: cdecl; variadic: TRUE;} "fprintf" importFunction

stderrWrite: [makeStringView TRUE] [
  source: makeStringView;
  byteWrittenCount: 0;
  error: String;

  source.size 0 > [
    STDERR: [2n32];
    source addTerminator (.data) "%s\00" storageAddress STDERR __acrt_iob_func fprintf !byteWrittenCount
    byteWrittenCount 0 < ["[fprintf] failed" @error.cat] when
  ] when

  byteWrittenCount Intx cast error
] pfunc;
