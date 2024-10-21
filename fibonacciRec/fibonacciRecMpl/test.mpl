"String"  use
"control" use

"ticks" use

"common" use

fibonacci: [
  n:;
  n 2 < [n new] [n 1 - fibonacci n 2 - fibonacci +] if
];

{} Int32 {} [
  startPoint: ticks;
  i32FibMax: [46];
  checksum: 0n32 i32FibMax 1 + [i fibonacci Nat32 cast xor] times;
  time: startPoint since;

  checksum print LF print
  "fibonacciRec" time store

  0
] "main" exportFunction
