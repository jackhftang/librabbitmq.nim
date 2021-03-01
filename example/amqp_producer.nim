import librabbitmq
import utils
import strformat
import os

proc sendBatch(conn: amqp_connection_state_t, queue: string, rateLimit, messageCount: int) = 
  for i in 1..messageCount:
    check amqp_basic_publish(conn, 1,
      amqp_cstring_bytes("amq.direct"),
      amqp_cstring_bytes(queue),
      0, 0, nil,
      amqp_cstring_bytes(fmt"hello world {i}")
    )
    sleep 1000

proc main() =
  # init connection
  let conn = amqp_new_connection()
  if conn.isNil:
    raise newException(ValueError, "cannot create a new connection")

  # init TCP 
  let socket = amqp_tcp_socket_new(conn)
  if socket.isNil:
    raise newException(ValueError, "cannot create a TCP socket")

  # open TCP 
  let status = socket.amqp_socket_open("127.0.0.1", 5672)
  if status != 0:
    raise newException(ValueError, "cannot open TCP socket")

  # login 
  check conn.amqp_login("/", 0, 131072, 0, AMQP_SASL_METHOD_PLAIN, "guest", "guest")

  # open channel 1
  discard conn.amqp_channel_open(1)
  check conn.amqp_get_rpc_reply()

  conn.sendBatch("test queue", 1, 1000)

  # close channel 1
  check conn.amqp_channel_close(1, AMQP_REPLY_SUCCESS)

  # close connection
  check conn.amqp_connection_close(AMQP_REPLY_SUCCESS)

  # release resources
  check conn.amqp_destroy_connection()

  



when isMainModule:
  main()