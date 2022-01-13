"String"    use
"algebra"   use
"algorithm" use
"control"   use
"memory"    use

find: [
  data: size: number:;;;
  count: 0;

  size [
    i data @ Int32 cast number = [
      count 1 + !count
    ] when
  ] times

  count
];

{} {} {} [
  result: 0i64;
  data: Nat8 4 array;

  256 dynamic [
    i Nat8 cast 0 @data !
    256 dynamic [
      res: data 1 i find;
      res 1 < ~ [
        result 1i64 + !result
      ] when
    ] times
  ] times

  256 dynamic [
    i Nat8 cast 0 @data !
    256 dynamic [
      i Nat8 cast 1 @data !
      256 dynamic [
        res: data 2 i find;
        res 1 < ~ [
          result 1i64 + !result
        ] when
      ] times
    ] times
  ] times

  256 dynamic [
    i Nat8 cast 0 @data !
    256 dynamic [
      i Nat8 cast 1 @data !
      256 dynamic [
        i Nat8 cast 2 @data !
        256 dynamic [
          res: data 3 i find;
          res 1 < ~ [
            result 1i64 + !result
          ] when
        ] times
      ] times
    ] times
  ] times

  256 dynamic [
    i Nat8 cast 0 @data !
    256 dynamic [
      i Nat8 cast 1 @data !
      256 dynamic [
        i Nat8 cast 2 @data !
        256 dynamic [
          i Nat8 cast 3 @data !
          256 dynamic [
            res: data 4 i find;
            res 1 < ~ [
              result 1i64 + !result
            ] when
          ] times
        ] times
      ] times
    ] times
  ] times

  result print LF print
] "main" exportFunction
