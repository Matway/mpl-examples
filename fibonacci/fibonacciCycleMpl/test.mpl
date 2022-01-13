"String"  use
"control" use

fibonacci: [
  number:;

  number 1n64 > ~ [
    number new
  ] [
    fib1: 0n64;
    fib2: 1n64;
    result: 0n64;
    number [
      fib2 new     !fib1
      i Nat64 cast !fib2
      result fib1 fib2 + + !result
    ] times

    result new
  ] if
];

{} {} {} [
  result: 0n64;

  10000000 dynamic [
    45 dynamic [
      result i Nat64 cast fibonacci 2n64 mod + !result
    ] times
  ] times

  result print LF print
] "main" exportFunction
