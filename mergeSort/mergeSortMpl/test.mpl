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

mergeSortedIntervals: [
  arr: left: middle: right:;;;;

  temp: Nat32 Array;
  right left - Int32 cast 1 + @temp.setReserve

  i: left new;
  j: middle 1 +;

  [i middle > ~ [j right > ~] &&] [
    i arr @ j arr @ > ~ [
      i arr @ new @temp.append
      i 1 + !i
    ] [
      j arr @ new @temp.append
      j 1 + !j
    ] if
  ] while

  [i middle > ~] [
    i arr @ new @temp.append
    i 1 + !i
  ] while

  [j right > ~] [
    j arr @ new @temp.append
    j 1 + !j
  ] while

  [i: left new;] [i right > ~] [i 1 + !i] [
    i left - temp @ new i @arr !
  ] for
];

mergeSort: [
  recursive
  arr: left: right:;;;

  left right < [
    middle: left right + 2 /;
    @arr left middle mergeSort
    @arr middle 1 + right mergeSort
    @arr left middle right mergeSortedIntervals
  ] when
];

{} {} {} [
  size: 50000000;
  data: Nat32 Array;
  size @data.resize

  rand: RandomLCG;

  size dynamic [
    @rand.nextSeed i @data !
  ] times

  @data 0 size 1 - mergeSort

  (
    0        data @ " "
    size 2 / data @ " "
    size 1 - data @ " " LF
  ) printList
] "main" exportFunction
