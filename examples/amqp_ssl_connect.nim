import librabbitmq
import utils

proc amqp_ssl_connect(
  host="127.0.0.1",
  port=5671,
  username="guest",
  password="guest",
) =
  # init connection
  let conn = amqp_new_connection()
  if conn.isNil:
    raise newException(ValueError, "cannot create a new connection")

  # init SSL socket
  let socket = amqp_ssl_socket_new(conn)
  if socket.isNil:
    raise newException(ValueError, "cannot create a TCP socket")
  socket.amqp_ssl_socket_set_verify_peer(0)
  socket.amqp_ssl_socket_set_verify_hostname(0)
  # check socket.amqp_ssl_socket_set_cacert(certPath)

  var tv: timeval
  tv.tv_sec = 1
  tv.tv_usec = 0
  check socket.amqp_socket_open_noblock(host, port.cint, tv.addr)

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

  # close connection
  check conn.amqp_connection_close(AMQP_REPLY_SUCCESS)
  
  # release resources 
  check conn.amqp_destroy_connection()
  check amqp_uninitialize_ssl_library()

when isMainModule:
  import cligen
  dispatch(amqp_ssl_connect)
