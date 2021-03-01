import librabbitmq
import utils

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

  amqp_bytes_free(queueName)
  check conn.amqp_channel_close(1, AMQP_REPLY_SUCCESS)
  check conn.amqp_connection_close(AMQP_REPLY_SUCCESS)
  check conn.amqp_destroy_connection()

when isMainModule:
  main()