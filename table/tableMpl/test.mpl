"String"    use
"algorithm" use
"control"   use

"ticks" use

"common" use

Char: [{
  codepoint: Int32;
}];

REPLACEMENT_CHARACTER: [0xFFFD toChar];

isValidCodepoint: [codepoint:; codepoint 0 0xD7FF between [codepoint 0xE000 0x10FFFF between] ||];

toChar: [Int32 same] [
  codepoint:;
  [codepoint isValidCodepoint] "invalid UTF-8 code point" assert
  char: Char;
  codepoint @char.@codepoint set
  @char
] pfunc;

decodeChar: [
  source:;

  return3: [
    @source.next source.valid ~ [REPLACEMENT_CHARACTER 0] [
      unit2: source.get new; unit2 0xC0n8 and 0x80n8 = ~ [REPLACEMENT_CHARACTER 0] [
        @source.next
        unit0 0n32 cast 0x0Fn32 and 12n32 lshift
        unit1 0n32 cast 0x3Fn32 and  6n32 lshift or
        unit2 0n32 cast 0x3Fn32 and or
        Int32 cast toChar 3
      ] if
    ] if
  ];

  return4: [
    @source.next source.valid ~ [REPLACEMENT_CHARACTER 0] [
      unit2: source.get new; unit2 0xC0n8 and 0x80n8 = ~ [REPLACEMENT_CHARACTER 0] [
        @source.next source.valid ~ [REPLACEMENT_CHARACTER 0] [
          unit3: source.get new; unit3 0xC0n8 and 0x80n8 = ~ [REPLACEMENT_CHARACTER 0] [
            @source.next
            unit0 0n32 cast 0x07n32 and 18n32 lshift
            unit1 0n32 cast 0x3Fn32 and 12n32 lshift or
            unit2 0n32 cast 0x3Fn32 and  6n32 lshift or
            unit3 0n32 cast 0x3Fn32 and or
            Int32 cast toChar 4
          ] if
        ] if
      ] if
    ] if
  ];

  source.valid ~ [REPLACEMENT_CHARACTER 0] [
    unit0: source.get new;
    unit0 (
      [0x80n8 <] [@source.next unit0 Int32 cast toChar 1]
      [0xC2n8 <] [REPLACEMENT_CHARACTER 0]
      [0xF5n8 <] [
        @source.next source.valid ~ [REPLACEMENT_CHARACTER 0] [
          unit1: source.get new;
          unit0 (
            [0xE0n8 <] [
              unit1 0xC0n8 and 0x80n8 = ~ [REPLACEMENT_CHARACTER 0] [
                @source.next
                unit0 0n32 cast 0x1Fn32 and 6n32 lshift
                unit1 0n32 cast 0x3Fn32 and or
                Int32 cast toChar 2
              ] if
            ]
            [0xE0n8 =] [unit1 0xE0n8 and 0xA0n8 =  [return3] [REPLACEMENT_CHARACTER 0] if]
            [0xEDn8 <] [unit1 0xC0n8 and 0x80n8 =  [return3] [REPLACEMENT_CHARACTER 0] if]
            [0xEDn8 =] [unit1 0xE0n8 and 0x80n8 =  [return3] [REPLACEMENT_CHARACTER 0] if]
            [0xF0n8 <] [unit1 0xC0n8 and 0x80n8 =  [return3] [REPLACEMENT_CHARACTER 0] if]
            [0xF0n8 =] [unit1 0x90n8 0xC0n8 within [return4] [REPLACEMENT_CHARACTER 0] if]
            [0xF4n8 <] [unit1 0xC0n8 and 0x80n8 =  [return4] [REPLACEMENT_CHARACTER 0] if]
            [           unit1 0xF0n8 and 0x80n8 =  [return4] [REPLACEMENT_CHARACTER 0] if]
          ) cond
        ] if
      ]
      [REPLACEMENT_CHARACTER 0]
    ) cond
  ] if
];

testDecodeChar: [
  iterationCount: 0i64;
  validCount: 0;
  data: Nat8 4 array;

  validate: [
    size:;
    usedSize: 0;
    iter: {key: 0; DIE: []; get: [key 1 + !usedSize key data @]; next: [key 1 + !key]; valid: [key size = ~];};
    char: parsedSize: @iter decodeChar;;
    usedSize size = [parsedSize 0 >] && [
      validCount 1 + !validCount
    ] when

    iterationCount 1i64 + !iterationCount
  ];

  0x100 dynamic [
    i Nat8 cast 0 @data !
    1 validate
  ] times

  0x100 dynamic [
    i Nat8 cast 0 @data !
    0x100 dynamic [
      i Nat8 cast 1 @data !
      2 validate
    ] times
  ] times

  0x100 dynamic [
    i Nat8 cast 0 @data !
    0x100 dynamic [
      i Nat8 cast 1 @data !
      0x100 dynamic [
        i Nat8 cast 2 @data !
        3 validate
      ] times
    ] times
  ] times

  0x100 dynamic [
    i Nat8 cast 0 @data !
    0x100 dynamic [
      i Nat8 cast 1 @data !
      0x100 dynamic [
        i Nat8 cast 2 @data !
        0x100 dynamic [
          i Nat8 cast 3 @data !
          4 validate
        ] times
      ] times
    ] times
  ] times

  {iterationCount: iterationCount new; validCount: validCount new;}
];

{} {} {} [
  startPoint: ticks;
  counter: testDecodeChar;
  time: startPoint since;

  (
    counter.validCount     LF 1112064 LF
    counter.iterationCount LF 256i64 256i64 sqr + 256i64 dup sqr * + 256i64 sqr sqr + LF
  ) printList
  "table" time store
] "main" exportFunction
