"String"  use
"control" use

fibonacciRec: [
  recursive
  number:;

  number 1i64 > ~ [
    number new
  ] [
    number 1i64 - fibonacciRec number 2i64 - fibonacciRec + 
  ] if
];

{} {} {} [
  result: 0i64;

  45 [
    result i Int64 cast fibonacciRec + !result
  ] times

  result print LF print
] "main" exportFunction
