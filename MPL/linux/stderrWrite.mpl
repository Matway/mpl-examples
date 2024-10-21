"String.String"         use
"String.makeStringView" use
"control.Int32"         use
"control.Intx"          use
"control.Natx"          use
"control.pfunc"         use
"control.when"          use
"conventions.cdecl"     use

{
  fd:    Int32;
  buf:   Natx;
  count: Natx;
} Intx {convention: cdecl;} "write" importFunction

stderrWrite: [
  sourceAddress: sourceSize:;;
  error:            String;
  byteWrittenCount: 0ix;

  sourceSize 0nx > [
    STDERR: [2];
    sourceSize sourceAddress STDERR write !byteWrittenCount
    byteWrittenCount -1ix = ["[write] failed" @error.cat] when # TODO: Include ERRNO to a message
  ] when

  byteWrittenCount error
];

stderrWrite: [makeStringView TRUE] [
  source: makeStringView;
  source.data storageAddress source.size Natx cast stderrWrite
] pfunc;
