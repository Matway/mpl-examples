"Connection" module
"Spinlock" includeModule
"TcpConnection" includeModule
"lockGuard" includeModule

Connection: [{
  OnStop: [{context: Natx; id: Int32; count: Nat64;} {} {} codeRef] func;

  INIT: [
  ];

  DIE: [
  ];

  start: [
    address: port: id0: stopContext0: onStop0:;;;;;
    lock: @spinlock lockGuard;
    result: address port self storageAddress onConnectEventWrapper @connection.connect;
    result "" = ~ [
      ("Connection.start: " result LF) assembleString print
      TRUE !stopping
      FALSE
    ] [
      TRUE !connecting
      FALSE !reading
      FALSE !writing
      FALSE !stopping
      0n64 !count
      id0 copy !id
      @onStop0 !onStop
      stopContext0 copy !stopContext
      TRUE
    ] if
  ] func;

  stop: [
    lock: @spinlock lockGuard;
    stopping ~ [
      connecting [@connection.cancelConnect drop] when
      reading [@connection.cancelRead drop] when
      writing [@connection.cancelWrite drop] when
      TRUE !stopping
    ] when
  ] func;

  spinlock: Spinlock;
  connection: TcpConnection;
  connecting: Cond;
  reading: Cond;
  writing: Cond;
  stopping: Cond;
  data: Nat8 4096 array;
  dataSize: Int32;
  count: Nat64;
  id: Int32;
  onStop: OnStop;
  stopContext: Natx;

  onConnectEvent: [
    result:;
    [
      lock: @spinlock lockGuard;
      [connecting [reading ~] && [writing ~] &&] "Connection.onConnectEvent: invalid state" assert
      FALSE !connecting
      result "" = ~ [
        ("Connection.onConnectEvent: " result LF) assembleString print
        TRUE !stopping
        TRUE
      ] [
        stopping ~ [startWrite] when
        stopping [@connection.disconnect TRUE] [FALSE] if
      ] if
    ] call

    [count id copy stopContext copy onStop] when
  ] func;

  onReadEvent: [
    size: result:;;
    [
      lock: @spinlock lockGuard;
      [connecting ~ [reading copy] && [writing ~] &&] "Connection.onReadEvent: invalid state" assert
      FALSE !reading
      result "" = ~ [
        ("Connection.onReadEvent: " result LF) assembleString print
        TRUE !stopping
      ] [
        size 0 = [
          TRUE !stopping
        ] [
          dataSize size + !dataSize
          dataSize data fieldCount = [
            count data fieldCount Nat32 cast Nat64 cast + !count
            count 8388608n64 < ~ [TRUE !stopping] when
            stopping ~ [startWrite] when
          ] [
            stopping ~ [
              result: data storageAddress dataSize Nat32 cast Natx cast + data fieldCount dataSize - self storageAddress @connectionOnReadEventRef @connection.read;
              result "" = ~ [("Connection.onWriteEvent: " result LF) assembleString print TRUE !stopping] [TRUE !reading] if
            ] when
          ] if
        ] if
      ] if

      stopping [@connection.disconnect TRUE] [FALSE] if
    ] call

    [count id copy stopContext copy onStop] when
  ] func;

  onWriteEvent: [
    result:;
    [
      lock: @spinlock lockGuard;
      [connecting ~ [reading ~] && [writing copy] &&] "Connection.onWriteEvent: invalid state" assert
      FALSE !writing
      result "" = ~ [
        ("Connection.onWriteEvent: " result LF) assembleString print
        TRUE !stopping
      ] [
        stopping ~ [
          0 !dataSize
          result: data storageAddress data fieldCount self storageAddress @connectionOnReadEventRef @connection.read;
          result "" = ~ [("Connection.onWriteEvent: " result LF) assembleString print TRUE !stopping] [TRUE !reading] if
        ] when
      ] if

      stopping [@connection.disconnect TRUE] [FALSE] if
    ] call

    [count id copy stopContext copy onStop] when
  ] func;

  startWrite: [
    [connecting ~ [reading ~] && [writing ~] && [stopping ~] &&] "Connection.startWrite: invalid state" assert

    value: id Nat32 cast Nat8 cast count Nat8 cast xor;
    index: 0 dynamic; [index data fieldCount <] [
      value copy index @data !
      value 1n8 + !value
      index 1 + !index
    ] while

    result: data storageAddress data fieldCount self storageAddress @connectionOnWriteEventRef @connection.write;
    result "" = ~ [("Connection.startWrite: " result LF) assembleString print TRUE !stopping] [TRUE !writing] if
  ] func;

  onConnectEventWrapper: [Connection addressToReference .onConnectEvent];
}] func;

connectionOnReadEventRef:    TcpConnection.OnRead   ;
connectionOnWriteEventRef:   TcpConnection.OnWrite  ;
{context: Natx; result: String Ref; size: Int32;} {} {} [Connection addressToReference .onReadEvent   ] "connectionOnReadEvent"    exportFunction
{context: Natx; result: String Ref;             } {} {} [Connection addressToReference .onWriteEvent  ] "connectionOnWriteEvent"   exportFunction
@connectionOnReadEvent  !connectionOnReadEventRef
@connectionOnWriteEvent !connectionOnWriteEventRef
