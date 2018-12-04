"ConnectionManager" module
"Array" includeModule
"Connection" includeModule
"runningTime" includeModule

ConnectionManager: [{
  OnStop: [{context: Natx;} {} {} codeRef] func;

  INIT: [
  ];

  DIE: [
  ];

  start: [
    address: port: stopContext0: onStop0:;;;;
    lock: @spinlock lockGuard;
    @runningTime.get !startTime
    128 @connections.resize
    0 !connectionCount

    index: 0; [index connections.getSize <] [
      address port index self storageAddress onStopEventWrapper index @connections @ .start [connectionCount 1 + !connectionCount] when
      index 1 + !index
    ] while

    0n64 !totalCount
    @onStop0 !onStop
    stopContext0 copy !stopContext
    connectionCount 0 = ~
  ] func;

  stop: [
    lock: @spinlock lockGuard;
    index: 0; [index connections.getSize <] [
      entry: index @connections @;
      entry.assigned [entry.get.stop] when
      index 1 + !index
    ] while
  ] func;

  spinlock: Spinlock;
  startTime: Real64;
  connections: Connection Array;
  connectionCount: Int32;
  totalCount: Nat64;
  onStop: OnStop;
  stopContext: Natx;

  onStopEvent: [
    count: id:;;
    [
      lock: @spinlock lockGuard;
      ("connection disconnected, id=" id ", count=" count LF) assembleString print
      connectionCount 1 - !connectionCount
      totalCount count + !totalCount
      connectionCount 0 = ~
    ] call

    ~ [
      duration: @runningTime.get startTime -;
      ("Exiting, total bytes transferred: " totalCount ", duration: " duration ", speed: " totalCount Real64 cast 1.0e6 / duration / " MB/s" LF) assembleString print
      stopContext copy onStop
    ] when
  ] func;

  onStopEventWrapper: [ConnectionManager addressToReference .onStopEvent];
}] func;
