"String"  use
"control" use

"ticks" use

"common" use

fibonacci: [
  n:;
  n 2 < [n new] [
    result: 1;

    acc: 0;
    n 1 - [
      result new [acc + !result] keep new !acc
    ] times

    result
  ] if
];

{} {} {} [
  checksum: 0;

  startPoint: ticks;
  1.0e7 Int32 cast dynamic [
    i32FibMax: [46];
    i32FibMax 1 + [checksum i fibonacci 2 mod + !checksum] times
  ] times
  time: startPoint since;

  checksum print LF print
  "fibonacciCycle" time store
] "main" exportFunction
