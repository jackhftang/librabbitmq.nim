import librabbitmq
import utils

proc main(
  host="127.0.0.1",
  port=5672,
  username="guest",
  password="guest",
  exchange="amq.direct",
  routingKey="test queue",
  queue: string
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
  let status = socket.amqp_socket_open(host, port.cint)
  if status != 0:
    raise newException(ValueError, "cannot open TCP socket")

  # login 
  check conn.amqp_login(
    AMQP_DEFAULT_VHOST,
    AMQP_DEFAULT_MAX_CHANNELS,
    AMQP_DEFAULT_FRAME_SIZE,
    AMQP_DEFAULT_HEARTBEAT, 
    AMQP_SASL_METHOD_PLAIN, 
    username, 
    password
  )

  # open channel 1
  discard conn.amqp_channel_open(1)
  check conn.amqp_get_rpc_reply()

  # bind queue
  discard conn.amqp_queue_bind(
    1, 
    amqp_cstring_bytes(queue), 
    amqp_cstring_bytes(exchange), 
    amqp_cstring_bytes(routingKey), 
    amqp_empty_table
  )
  check conn.amqp_get_rpc_reply()

  # close channel 1
  check conn.amqp_channel_close(1, AMQP_REPLY_SUCCESS)

  # close connection
  check conn.amqp_connection_close(AMQP_REPLY_SUCCESS)

  # release resources
  check conn.amqp_destroy_connection()


when isMainModule:
  import cligen
  dispatch(main)