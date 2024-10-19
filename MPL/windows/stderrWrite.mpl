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
  STDERR: [2n32];
  count: source addTerminator (.chars.data) STDERR __acrt_iob_func "%s\00" fprintf;
  error: String;
  count 0 < ["[fprintf] failed" @error.cat] when

  count Intx cast error
] pfunc;
