import librabbitmq

proc check*(rep: amqp_rpc_reply_t) =
  case rep.reply_type:
  of AMQP_RESPONSE_NORMAL: 
    return
  of AMQP_RESPONSE_NONE:
    stderr.writeLine("Missing RPC reply type")
    quit 1
  of AMQP_RESPONSE_LIBRARY_EXCEPTION:
    let s = amqp_error_string2(rep.library_error)
    stderr.writeLine(s)
    quit 1
  of AMQP_RESPONSE_SERVER_EXCEPTION:
    stderr.writeLine("server error")
    quit 1

proc check*(x: cint) =
  if x < 0:
    echo amqp_error_string2(x)
    quit 1

proc read(length: csize_t, bytes: pointer): string =
  for i in 0 ..< length:
    let b = cast[ptr char](cast[ByteAddress](bytes) +% i.int)
    result &= b[]

proc `$`*(b: amqp_bytes_t): string =
  read(b.len, b.bytes)
