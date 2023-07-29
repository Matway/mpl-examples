"control.Int64"                              use
"control.Nat64"                              use
"control.drop"                               use
"windows/kernel32.QueryPerformanceCounter"   use
"windows/kernel32.QueryPerformanceFrequency" use

monotonicTimeStamp: [
  tickCount: Nat64;
  @tickCount storageAddress Int64 addressToReference QueryPerformanceCounter drop
  tickCount
];

monotonicTimeStampFrequency: [
  frequency: Int64;
  @frequency QueryPerformanceFrequency drop
  frequency Nat64 cast
];
