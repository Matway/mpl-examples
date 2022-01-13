"Array"   use
"String"  use
"control" use

RandomLCG: [{
  seed: 0n32;
  nextSeed: [
    seed 0x8088405n32 * 1n32 + @seed set
    seed new
  ];
}];

bubbleSort: [
  data:;

  data.getSize [
    j: i new;
    size i - [
      i data @ j data @ > [
        tmp: i data @ new;
        j data @ new i @data !
        tmp new j @data !
      ] when
      j 1 + !j
    ] times
  ] times
];

{} {} {} [
  size: 100000;
  data: Nat32 Array;
  size @data.resize

  rand: RandomLCG;

  size dynamic [
    @rand.nextSeed i @data !
  ] times

  @data bubbleSort

  (
    0        data @ " "
    size 2 / data @ " "
    size 1 - data @ " " LF
  ) printList
] "main" exportFunction
