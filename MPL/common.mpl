"String"    use
"algorithm" use
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

  bar: [
    text:;
    placeholder: "-------------------" makeStringView;
    length:      placeholder.size text.size - 1 max new;

    placeholder length head
  ];

  indent: name bar;

  (name " " indent " " time LF) assembleString stderrWrite drop drop
];
