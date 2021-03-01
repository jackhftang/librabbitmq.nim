import librabbitmq

proc check(rep: amqp_rpc_reply_t) =
  case rep.reply_type:
  of AMQP_RESPONSE_NORMAL: return
  of AMQP_RESPONSE_NONE:
    stderr.writeLine("Missing RPC reply type")
    return
  of AMQP_RESPONSE_LIBRARY_EXCEPTION:
    let s = amqp_error_string2(rep.library_error)
    stderr.writeLine(s)
    return
  of AMQP_RESPONSE_SERVER_EXCEPTION:
    stderr.writeLine("server error")
    return

proc read(length: csize_t, bytes: pointer): string =
  for i in 0 ..< length:
    let b = cast[ptr char](cast[ByteAddress](bytes) +% i.int)
    result &= b[]

proc `$`(b: amqp_bytes_t): string =
  read(b.len, b.bytes)

proc main() =
  let conn = amqp_new_connection()
  if conn.isNil:
    raise newException(ValueError, "cannot create is connection")

  let socket = amqp_tcp_socket_new(conn)
  if socket.isNil:
    raise newException(ValueError, "cannot create TCP socket")

  let status = amqp_socket_open(socket, "127.0.0.1", 5672)
  if status != 0:
    raise newException(ValueError, "cannot open TCP socket")

  check conn.amqp_login("/", 0, 131072, 0, AMQP_SASL_METHOD_PLAIN, "guest", "guest")

  discard conn.amqp_channel_open(1)
  check conn.amqp_get_rpc_reply()


  let r = conn.amqp_queue_declare(1, amqp_empty_bytes, 0, 0, 0, 1, amqp_empty_table)
  let queueName = r.queue.amqp_bytes_malloc_dup();
  if queueName.bytes.isNil:
    raise newException(ValueError, "out of memory")
    
  let exchange = "amq.direct"
  let bindingKey = "test queue"
  discard conn.amqp_queue_bind(1, queueName, amqp_cstring_bytes(exchange), amqp_cstring_bytes(bindingKey), amqp_empty_table)
  check conn.amqp_get_rpc_reply()

  discard conn.amqp_basic_consume(1, queueName, amqp_empty_bytes, 0, 1, 0, amqp_empty_table)
  check conn.amqp_get_rpc_reply()

  while true:
    var envelope: amqp_envelope_t
    conn.amqp_maybe_release_buffers()
    let res = amqp_consume_message(conn, envelope.addr, nil, 0);
    if res.reply_type != AMQP_RESPONSE_NORMAL:
      break
    
    let deliveryTag = envelope.delivery_tag
    let exchange = $envelope.exchange
    let routingKey = $envelope.routing_key
    echo "delieveryTag=", deliveryTag, " exchange=", exchange, " routingKey=", routingKey
    # echo envelope.message.body
    amqp_destroy_envelope(envelope.addr)

when isMainModule:
  main()