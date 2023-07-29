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

  add: [Duration same] [a: .nanosecondCount;
    result: a nanosecondCount + ns;
    [result.nanosecondCount a < ~] "[Duration.add], overflow" assert
    @result
  ] pfunc;

  substract: [Duration same] [a: .nanosecondCount;
    [a nanosecondCount < ~] "[Duration.substract], invalid argument value" assert
    a nanosecondCount - ns
  ] pfunc;
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

toString: [Duration same] [() format] pfunc;

# FIXME: Make it simple.
# FIXME: Make fast.
format: [a: b:;; @b isCombined () @b same or [@a Duration same] &&] [a: b:;;
  stable?: @b "stable?" has [@b.stable?] [FALSE] if;

  extentNanosecondCount: a nanosecondCount;
  first?: TRUE;

  padding: [
    {
      level: new;
      size:  [level new];
      at:    [drop "0"];
    } assembleString
  ];

  go: [
    n: stable? [alignment:;] [] uif;
    count: extentNanosecondCount n /;
    extentNanosecondCount count n * - !extentNanosecondCount

    stable? [suffix "w" = [""] [" "] if] [first? [""] [" "] if] uif

    resultNumber: count toString;

    stable? [alignment resultNumber.size - padding] when

    @resultNumber

    FALSE !first?
  ];

  extentNanosecondCount 0n64 = [stable? ["00000w 0d 00h 00m 00s 000ms 000us 000ns"] ["0ns"] if toString] [
    (
      (
        [[w ] "w"  5]
        [[d ] "d"  1]
        [[h ] "h"  2]
        [[m ] "m"  2]
        [[s ] "s"  2]
        [[ms] "ms" 3]
        [[us] "us" 3]
        [[ns] "ns" 3]
      ) [
        unit: suffix: alignment: call;;;
        unitNanosecondCount: 1n64 unit nanosecondCount;
        extentNanosecondCount unitNanosecondCount < ~ [unitNanosecondCount stable? [alignment] when go suffix] [
          stable? [suffix "w" = [""] [" "] if alignment padding String suffix] ["" String ""] if
        ] if
      ] each
    ) assembleString
  ] if
] pfunc;
