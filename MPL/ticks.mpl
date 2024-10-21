"control.ensure" use
"control.pfunc"  use
"control.swap"   use

"duration.-"               use
"duration.Duration"        use
"duration.nanosecondCount" use
"duration.ns"              use
"duration.s"               use

"monotonicTimeStamp.monotonicTimeStamp"          use
"monotonicTimeStamp.monotonicTimeStampFrequency" use

ticks:
  {
    private frequencyValue: monotonicTimeStampFrequency;
    private multiplier:
      [1n64 s nanosecondCount frequencyValue mod 0n64 =] "[ticks.multiplier], precision lost" ensure
      1n64 s nanosecondCount frequencyValue /
    ;

    private CALL: [monotonicTimeStamp multiplier * ns];

    frequency: [frequencyValue new];
  }
;

since: [Duration same] [ticks swap -] pfunc;
