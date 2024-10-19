"String"    use
"algorithm" use
"control"   use

"ticks" use

"common" use

convertToInt: [
  ip: size:;;
  result: 0n32;

  size [
    i (
      0 [i ip @ Nat32 cast 256n32 256n32 256n32 * * * result + !result]
      1 [i ip @ Nat32 cast 256n32 256n32 * *          result + !result]
      2 [i ip @ Nat32 cast 256n32 *                   result + !result]
      3 [i ip @ Nat32 cast                            result + !result]
    ) case
  ] times

  result Nat64 cast
];

{} Int32 {} [
  result: 0n64;
  ip: Nat8 4 array;
  startPoint: ticks;

  256 dynamic [
    i Nat8 cast 0 @ip !
    ip 1 convertToInt result + !result
  ] times

  256 dynamic [
    i Nat8 cast 0 @ip !
    256 dynamic [
      i Nat8 cast 1 @ip !
      ip 2 convertToInt result + !result
    ] times
  ] times

  256 dynamic [
    i Nat8 cast 0 @ip !
    256 dynamic [
      i Nat8 cast 1 @ip !
      256 dynamic [
        i Nat8 cast 2 @ip !
        ip 3 convertToInt result + !result
      ] times
    ] times
  ] times

  256 dynamic [
    i Nat8 cast 0 @ip !
    256 dynamic [
      i Nat8 cast 1 @ip !
      256 dynamic [
        i Nat8 cast 2 @ip !
        256 dynamic [
          i Nat8 cast 3 @ip !
          ip 4 convertToInt result + !result
        ] times
      ] times
    ] times
  ] times

  time: startPoint since;

  result print LF print
  9259542112527974400n64 print LF print
  "ip" time store

  0
] "main" exportFunction
