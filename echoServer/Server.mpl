"Server" module
"Owner" includeModule
"Pool" includeModule
"ServerConnection" includeModule
"TcpAcceptor" includeModule

Server: [{
  OnStop: [{context: Natx;} {} {} codeRef] func;

  INIT: [
  ];

  DIE: [
  ];

  start: [
    address: port: stopContext0: onStop0:;;;;
    lock: @spinlock lockGuard;
    result: address port @acceptor.startListening;
    result "" = ~ [
      ("Server.start: " result LF) assembleString print
      FALSE
    ] [
      self storageAddress @serverOnAcceptEvent @acceptor.accept !result
      result "" = ~ [
        ("Server.start: " result LF) assembleString print
        @acceptor.stopListening
        FALSE
      ] [
        TRUE !accepting
        FALSE !stopping
        0 !connectionCount
        @onStop0 !onStop
        stopContext0 copy !stopContext
        TRUE
      ] if
    ] if
  ] func;

  stop: [
    lock: @spinlock lockGuard;
    stopping ~ [startStop] when
  ] func;

  spinlock: Spinlock;
  acceptor: TcpAcceptor;
  accepting: Cond;
  stopping: Cond;
  connections: ServerConnection Owner Pool;
  connectionCount: Int32;
  onStop: OnStop;
  stopContext: Natx;

  onAcceptEvent: [
    connection: result:;;
    [
      lock: @spinlock lockGuard;
      [accepting] "Server.onAcceptEvent: invalid state" assert
      FALSE !accepting
      result "" = ~ [
        ("Server.onAcceptEvent: " result LF) assembleString print
      ] [
        ("client connected, connection=" connection.connection LF) assembleString print
        stopping ~ [
          result: self storageAddress @serverOnAcceptEventRef @acceptor.accept;
          result "" = ~ [
            ("Server.onAcceptEvent: " result LF) assembleString print
          ] [
            TRUE !accepting
          ] if
        ] when

        accepting ~ [
          @connection.disconnect
        ] [
          id: ServerConnection owner @connections.insert;
          @connection id self storageAddress @onStopEventWrapper id @connections @ .get.start ~ [
            id @connections.erase
          ] [
            ("id: " id LF) assembleString print
            connectionCount 1 + !connectionCount
          ] if
        ] if
      ] if

      accepting ~ [
        @acceptor.stopListening
        stopping ~ [startStop] when
        connectionCount 0 = ~
      ] [
        TRUE
      ] if
    ] call

    ~ [stopContext copy onStop] when
  ] func;

  onStopEvent: [
    id:;
    [
      lock: @spinlock lockGuard;
      ("client disconnected, id=" id LF) assembleString print
      id @connections.erase
      connectionCount 1 - !connectionCount
      stopping ~ [accepting [connectionCount 0 = ~] ||] ||
    ] call

    ~ [stopContext copy onStop] when
  ] func;

  startStop: [
    [stopping ~] "Server.startStop: invalid state" assert
    accepting [@acceptor.cancel drop] when
    index: connections.firstValid; [index connections.getSize <] [
      index @connections @ .get.stop
      index connections.nextValid !index
    ] while

    TRUE !stopping
  ] func;

  onStopEventWrapper: [Server addressToReference .onStopEvent];
}] func;

serverOnAcceptEventRef: TcpAcceptor.OnAccept;
{context: Natx; result: String Ref; connection: TcpConnection Ref;} {} {} [Server addressToReference .onAcceptEvent] "serverOnAcceptEvent" exportFunction
@serverOnAcceptEvent !serverOnAcceptEventRef
