"Array"       use
"String"      use
"algorithm"   use
"ascii"       use
"control"     use
"conventions" use

"duration" use

(Natx Natx) Int32 {convention: cdecl; variadic: TRUE;} "fprintf" importFunction
(Nat32) Natx {convention: cdecl;} "__acrt_iob_func" importFunction

RandomLcg: [{
  private seed: 0n32;
  next: [
    seed 0x8088405n32 * 1n32 + @seed set
    seed new
  ];
}];

RandomLcgIter: [{
  private gen: RandomLcg;
  next: [@gen.next TRUE];
}];

store: [
  name: time: toString addTerminator.chars.data storageAddress; makeStringView;
  stderr: [2n32];
  fdo: [stderr __acrt_iob_func];

  placeholder: [
    name:;
    len: [19];

    {next: [ascii.minus Nat8 cast TRUE];} name.size len < [len name.size -] [1] if [Nat8] headIter toArray
  ];

  indent: name placeholder .span .stringView;

  (time new) (name " " indent " %s\n\00") assembleString.data storageAddress fdo fprintf [2 >] "[C99.fprintf] filed" ensure
];

# For C++ and so

"ticks" use

()(){convention: cdecl;} [] "startUp"  exportFunction
()(){convention: cdecl;} [] "tearDown" exportFunction

(Natx Int32 Duration) () {convention: cdecl;} [
  time: nameSize: nameAddress:;;;
  (nameAddress Nat8 Cref addressToReference nameSize new) toStringView time store
] "storeCase" exportFunction

()         Duration {convention: cdecl;} [ticks] "tickCount"      exportFunction
(Duration) Duration {convention: cdecl;} [since] "sinceTimePoint" exportFunction
