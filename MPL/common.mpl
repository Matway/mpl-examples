"Array"     use
"String"    use
"algorithm" use
"ascii"     use
"control"   use

"stderrWrite" use

"duration" use

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
  name: time: toString; makeStringView;

  placeholder: [
    name:;
    len: [19];

    {next: [ascii.minus Nat8 cast TRUE];} name.size len < [len name.size -] [1] if [Nat8] headIter toArray
  ];

  indent: name placeholder .span .stringView;

  (name " " indent time LF) assembleString stderrWrite drop drop
];

# For C++ and so

"conventions" use

"ticks" use

()(){convention: cdecl;} [] "startUp"  exportFunction
()(){convention: cdecl;} [] "tearDown" exportFunction

{
  nameAddress: Natx;
  nameLength:  Int32;
  time:        Duration;
} () {convention: cdecl;} [
  time: nameSize: nameAddress:;;;
  (nameAddress Nat8 Cref addressToReference nameSize new) toStringView time store
] "storeCase" exportFunction

(                    ) Duration {convention: cdecl;} [ticks] "tickCount"      exportFunction
{timepoint: Duration;} Duration {convention: cdecl;} [since] "sinceTimepoint" exportFunction
