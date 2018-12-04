"ServerConnection" module
"Spinlock" includeModule
"TcpConnection" includeModule
"lockGuard" includeModule

ServerConnection: [{
  OnStop: [{context: Natx; id: Int32;} {} {} codeRef] func;

  INIT: [
  ];

  DIE: [
  ];

  start: [
    connection0: id0: stopContext0: onStop0:;;;;
    lock: @spinlock lockGuard;
    @connection0 move copy !connection
    result: data storageAddress data fieldCount self storageAddress @serverConnectionOnReadEventRef @connection.read;
    result "" = ~ [
      ("ServerConnection.start: " result LF) assembleString print
      @connection.disconnect
      FALSE
    ] [
      TRUE !reading
      FALSE !writing
      FALSE !stopping
      id0 copy !id
      @onStop0 !onStop
      stopContext0 copy !stopContext
      TRUE
    ] if
  ] func;

  stop: [
    lock: @spinlock lockGuard;
    stopping ~ [
      reading [@connection.cancelRead drop] when
      writing [@connection.cancelWrite drop] when
      TRUE !stopping
    ] when
  ] func;

  spinlock: Spinlock;
  connection: TcpConnection;
  reading: Cond;
  writing: Cond;
  stopping: Cond;
  data: Nat8 4096 array;
  id: Int32;
  onStop: OnStop;
  stopContext: Natx;

  onReadEvent: [
    size: result:;;
    [
      lock: @spinlock lockGuard;
      [reading [writing ~] &&] "ServerConnection.onReadEvent: invalid state" assert
      FALSE !reading
      result "" = ~ [
        ("ServerConnection.onReadEvent: " result LF) assembleString print
        TRUE !stopping
      ] [
        #("data read, size=" size LF) assembleString print
        stopping ~ [
          size 0 = [
            TRUE !stopping
          ] [
            result: data storageAddress size self storageAddress @serverConnectionOnWriteEventRef @connection.write;
            result "" = ~ [
              ("ServerConnection.onReadEvent: " result LF) assembleString print
              TRUE !stopping
            ] [
              TRUE !writing
            ] if
          ] if
        ] when
      ] if
    ] call

    stopping [
      @connection.disconnect
      id copy stopContext copy onStop
    ] when
  ] func;

  onWriteEvent: [
    result:;
    [
      lock: @spinlock lockGuard;
      [reading ~ [writing copy] &&] "ServerConnection.onWriteEvent: invalid state" assert
      FALSE !writing
      result "" = ~ [
        ("ServerConnection.onWriteEvent: " result LF) assembleString print
        TRUE !stopping
      ] [
        stopping ~ [
          result: data storageAddress data fieldCount self storageAddress @serverConnectionOnReadEventRef @connection.read;
          result "" = ~ [
            ("ServerConnection.onWriteEvent: " result LF) assembleString print
            TRUE !stopping
          ] [
            TRUE !reading
          ] if
        ] when
      ] if
    ] call

    stopping [
      @connection.disconnect
      id copy stopContext copy onStop
    ] when
  ] func;
}] func;

serverConnectionOnReadEventRef:  TcpConnection.OnRead ;
serverConnectionOnWriteEventRef: TcpConnection.OnWrite;
{context: Natx; result: String Ref; size: Int32;} {} {} [ServerConnection addressToReference .onReadEvent ] "serverConnectionOnReadEvent"  exportFunction
{context: Natx; result: String Ref;             } {} {} [ServerConnection addressToReference .onWriteEvent] "serverConnectionOnWriteEvent" exportFunction
@serverConnectionOnReadEvent  !serverConnectionOnReadEventRef
@serverConnectionOnWriteEvent !serverConnectionOnWriteEventRef
