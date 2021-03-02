import librabbitmq
import utils

proc amqp_listen(
  host="127.0.0.1",
  port=5672,
  username="guest", 
  password="guest",
  exchange="amq.direct",
  routingKey="test queue"
) =
  # init connection
  let conn = amqp_new_connection()
  if conn.isNil:
    raise newException(ValueError, "cannot create a new connection")

  # init TCP 
  let socket = amqp_tcp_socket_new(conn)
  if socket.isNil:
    raise newException(ValueError, "cannot create a TCP socket")

  # open TCP 
  let status = amqp_socket_open(socket, host, port.cint)
  if status != 0:
    raise newException(ValueError, "cannot open TCP socket")

  # login
  check conn.amqp_login("/", 0, 131072, 0, AMQP_SASL_METHOD_PLAIN, username, password)

  # open channel 1
  discard conn.amqp_channel_open(1)
  check conn.amqp_get_rpc_reply()

  # create or reuse queue
  let r = conn.amqp_queue_declare(1, amqp_empty_bytes, 0, 0, 0, 1, amqp_empty_table)
  echo "queue=", r.queue

  # bind queue
  discard conn.amqp_queue_bind(
    1, 
    r.queue, 
    amqp_cstring_bytes(exchange), 
    amqp_cstring_bytes(routingKey), 
    amqp_empty_table
  )
  check conn.amqp_get_rpc_reply()

  # start consumption
  discard conn.amqp_basic_consume(
    1, 
    r.queue, 
    amqp_empty_bytes, 0, 1, 0, 
    amqp_empty_table
  )
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
    echo envelope.message.body
    amqp_destroy_envelope(envelope.addr)
  
  # close channel
  check conn.amqp_channel_close(1, AMQP_REPLY_SUCCESS)
  
  # close connection
  check conn.amqp_connection_close(AMQP_REPLY_SUCCESS)

  # release resources
  check conn.amqp_destroy_connection()

when isMainModule:
  import cligen
  dispatch(amqp_listen)