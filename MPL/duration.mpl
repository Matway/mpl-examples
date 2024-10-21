"String.String"         use
"String.assembleString" use
"String.toString"       use
"algorithm.each"        use
"control.&&"            use
"control.Nat64"         use
"control.assert"        use
"control.pfunc"         use
"control.when"          use

ns: [Nat64 same] [{
  nanosecondCount: new;

  less:  [.nanosecondCount nanosecondCount <];
  equal: [.nanosecondCount nanosecondCount =];

  add: [
    a: .nanosecondCount;
    result: a nanosecondCount + ns;
    [result.nanosecondCount a < ~] "[Duration.add], overflow" assert
    @result
  ];

  substract: [
    a: .nanosecondCount;
    [a nanosecondCount < ~] "[Duration.substract], invalid argument value" assert
    a nanosecondCount - ns
  ];
}] pfunc;

nanosecondCount: [.nanosecondCount new];

us: [Nat64 same] [ns nanosecondCount 1000n64 * ns] pfunc;
ms: [Nat64 same] [us nanosecondCount 1000n64 * ns] pfunc;
s:  [Nat64 same] [ms nanosecondCount 1000n64 * ns] pfunc;
m:  [Nat64 same] [s  nanosecondCount   60n64 * ns] pfunc;
h:  [Nat64 same] [m  nanosecondCount   60n64 * ns] pfunc;
d:  [Nat64 same] [h  nanosecondCount   24n64 * ns] pfunc;
w:  [Nat64 same] [d  nanosecondCount    7n64 * ns] pfunc;

Duration: [0n64 ns];

toMicroseconds: [Duration same] [nanosecondCount Real64 cast 1n64 us nanosecondCount Real64 cast /] pfunc;
toMilliseconds: [Duration same] [nanosecondCount Real64 cast 1n64 ms nanosecondCount Real64 cast /] pfunc;
toSeconds:      [Duration same] [nanosecondCount Real64 cast 1n64 s  nanosecondCount Real64 cast /] pfunc;
toMinutes:      [Duration same] [nanosecondCount Real64 cast 1n64 m  nanosecondCount Real64 cast /] pfunc;
toHours:        [Duration same] [nanosecondCount Real64 cast 1n64 h  nanosecondCount Real64 cast /] pfunc;
toDays:         [Duration same] [nanosecondCount Real64 cast 1n64 d  nanosecondCount Real64 cast /] pfunc;
toWeeks:        [Duration same] [nanosecondCount Real64 cast 1n64 w  nanosecondCount Real64 cast /] pfunc;

+: [Duration same] [.add]       pfunc;
-: [Duration same] [.substract] pfunc;

toString: [Duration same] [
  extentNanosecondCount: nanosecondCount;
  first?: TRUE;

  go: [
    n:;
    count: extentNanosecondCount n /;
    extentNanosecondCount count n * - !extentNanosecondCount

    first? ~ [" "] [""] if
    count toString

    FALSE !first?
  ];

  extentNanosecondCount 0n64 = ["0ns" toString] [
    (
      (
        [[w ] "w"]
        [[d ] "d"]
        [[h ] "h"]
        [[m ] "m"]
        [[s ] "s"]
        [[ms] "ms"]
        [[us] "us"]
        [[ns] "ns"]
      ) [
        unit: suffix: call;;
        unitNanosecondCount: 1n64 unit nanosecondCount;
        extentNanosecondCount unitNanosecondCount < ~ [unitNanosecondCount go suffix] ["" String ""] if
      ] each
    ) assembleString
  ] if
] pfunc;
