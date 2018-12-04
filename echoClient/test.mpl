"ConnectionManager" useModule
"Thread" useModule

spinlock: Spinlock;
threadCount: 0;
stopped: FALSE;

{context: Natx;} Nat32 {} [
  drop
  [
    lock: @spinlock lockGuard;
    stopped ~
  ] [dispatcher.dispatch] while

  [
    lock: @spinlock lockGuard;
    threadCount 1 - !threadCount
    threadCount 0 = ~
  ] call

  [dispatcher.wakeOne] when
  0n32
] "worker" exportFunction

{context: Natx;} {} {} [
  drop
  lock: @spinlock lockGuard;
  TRUE !stopped
] "onStop" exportFunction

{} Int32 {} [
  connectionManager: ConnectionManager;
  0x7F000001n32 6600n16 0nx @onStop @connectionManager.start ~ [1] [
    threads: Thread Array;
    4 !threadCount
    threadCount [0nx @worker thread @threads.pushBack] times
    @threads [.@value.join drop] each
    "Done" print LF print
    0
  ] if
] "main" exportFunction
