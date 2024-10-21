"control.Nat64"use
"control.drop" use

"linux/posix.CLOCK_MONOTONIC" use
"linux/posix.clock_gettime"   use
"linux/posix.timespec"        use

private NS_PER_SECOND: [1.0e9 Nat64 cast];

monotonicTimeStamp: [
  time: timespec;
  @time CLOCK_MONOTONIC clock_gettime drop # FIXME: Use CLOCK_BOOTTIME instead of CLOCK_MONOTONIC

  time.tv_sec Nat64 cast NS_PER_SECOND * time.tv_nsec Nat64 cast +
];

monotonicTimeStampFrequency: [NS_PER_SECOND];
