"String"  use
"control" use

fibonacci: [
  n:;
  n 2 < [n new] [n 1 - fibonacci n 2 - fibonacci +] if
];

{} {} {} [
  i32FibMax: [46];
  0n32 i32FibMax 1 + [i fibonacci Nat32 cast xor] times print LF print
] "main" exportFunction
