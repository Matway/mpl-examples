"Array"     use
"String"    use
"algorithm" use
"control"   use

"ticks" use

"common" use

bubbleSort: [
  data:;

  data.size [
    j: i new;
    data.size i - [
      i data.at j data.at  > [
        i data.at new
        j data.at i @data.at set
        j @data.at set
      ] when
      j 1 + !j
    ] times
  ] times
];

{} {} {} [
  size: [1.0e5 Int32 cast];
  source: RandomLcgIter size [Nat32] headIter dynamic toArray;

  ticks
  @source bubbleSort
  time: since;

  (0 source.at " " size 2 / source.at " " size 1 - source.at LF) printList
  "bubbleSort" time store
] "main" exportFunction
