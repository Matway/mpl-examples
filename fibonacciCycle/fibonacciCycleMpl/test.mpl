"String"  use
"control" use

"ticks" use

"common" use

fibonacci: [
  result: 0;
  last:   1;

  [
    result new
    last result + !result
    !last
  ] times

  result
];

{} Int32 {} [
  checksum: 0;

  startPoint: ticks;
  1.0e7 Int32 cast dynamic [
    i32FibMax: [46];
    i32FibMax 1 + [checksum i fibonacci 2 mod + !checksum] times
  ] times
  time: startPoint since;

  checksum print LF print
  "fibonacciCycle" time store

  0
] "main" exportFunction
