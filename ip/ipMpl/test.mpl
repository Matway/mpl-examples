"String"    use
"algebra"   use
"algorithm" use
"control"   use
"memory"    use

convertToInt: [
  ip: size:;;

  result: 0n32;
  size [
    i (
      0 [
        i ip @ Nat32 cast 256n32 256n32 256n32 * * * result + !result
      ]
      1 [
        i ip @ Nat32 cast 256n32 256n32 * * result + !result
      ]
      2 [
        i ip @ Nat32 cast 256n32 * result + !result
      ]
      3 [
        i ip @ Nat32 cast result + !result
      ]
    ) case
  ] times

  result Nat64 cast
];

{} {} {} [
  result: 0n64;
  ip: Nat8 4 array;

  256 dynamic [
    i Nat8 cast 0 @ip !
    res: ip 1 convertToInt;
    result res + !result
  ] times

  256 dynamic [
    i Nat8 cast 0 @ip !
    256 dynamic [
      i Nat8 cast 1 @ip !
      res: ip 2 convertToInt;
      result res + !result
    ] times
  ] times

  256 dynamic [
    i Nat8 cast 0 @ip !
    256 dynamic [
      i Nat8 cast 1 @ip !
      256 dynamic [
        i Nat8 cast 2 @ip !
        res: ip 3 convertToInt;
        result res + !result
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
          res: ip 4 convertToInt;
          result res + !result
        ] times
      ] times
    ] times
  ] times

  result print LF print
  9259542112527974400n64 print LF print
] "main" exportFunction
