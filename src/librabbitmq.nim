 {.deadCodeElim: on.}
when defined(windows):
  const
    librabbitmq* = "librabbitmq.dll"
elif defined(macosx):
  const
    librabbitmq* = "librabbitmq.dylib"
else:
  const
    librabbitmq* = "librabbitmq.so"

type
  ssize_t* = clong
  int8_t* = cchar
  int16_t* = cshort
  int32_t* = cint
  int64_t* = clong
  uint8_t* = cuchar
  uint16_t* = cushort
  uint32_t* = cuint
  uint64_t* = culong
  int_least8_t* = cchar
  int_least16_t* = cshort
  int_least32_t* = cint
  int_least64_t* = clong
  uint_least8_t* = cuchar
  uint_least16_t* = cushort
  uint_least32_t* = cuint
  uint_least64_t* = culong
  int_fast8_t* = cchar
  int_fast16_t* = clong
  int_fast32_t* = clong
  int_fast64_t* = clong
  uint_fast8_t* = cuchar
  uint_fast16_t* = culong
  uint_fast32_t* = culong
  uint_fast64_t* = culong
  intptr_t* = clong
  uintptr_t* = culong
  intmax_t* = clong
  uintmax_t* = culong
  timeval* {.bycopy.} = object


proc amqp_version_number*(): uint32_t {.cdecl, importc: "amqp_version_number",
                                     dynlib: librabbitmq.}
proc amqp_version*(): cstring {.cdecl, importc: "amqp_version", dynlib: librabbitmq.}
type
  INNER_C_UNION_amqp_126* {.bycopy.} = object {.union.}
    boolean*: amqp_boolean_t
    i8*: int8_t
    u8*: uint8_t
    i16*: int16_t
    u16*: uint16_t
    i32*: int32_t
    u32*: uint32_t
    i64*: int64_t
    u64*: uint64_t
    f32*: cfloat
    f64*: cdouble
    decimal*: amqp_decimal_t
    bytes*: amqp_bytes_t
    table*: amqp_table_t
    array*: amqp_array_t

  INNER_C_STRUCT_amqp_194* {.bycopy.} = object
    class_id*: uint16_t
    body_size*: uint64_t
    decoded*: pointer
    raw*: amqp_bytes_t

  INNER_C_STRUCT_amqp_201* {.bycopy.} = object
    transport_high*: uint8_t
    transport_low*: uint8_t
    protocol_version_major*: uint8_t
    protocol_version_minor*: uint8_t

  INNER_C_UNION_amqp_192* {.bycopy.} = object {.union.}
    `method`*: amqp_method_t
    properties*: INNER_C_STRUCT_amqp_194
    body_fragment*: amqp_bytes_t
    protocol_header*: INNER_C_STRUCT_amqp_201

  amqp_boolean_t* = cint
  amqp_method_number_t* = uint32_t
  amqp_flags_t* = uint32_t
  amqp_channel_t* = uint16_t
  amqp_bytes_t* {.bycopy.} = object
    len*: csize_t
    bytes*: pointer

  amqp_decimal_t* {.bycopy.} = object
    decimals*: uint8_t
    value*: uint32_t

  amqp_table_t* {.bycopy.} = object
    num_entries*: cint
    entries*: ptr amqp_table_entry_t

  amqp_array_t* {.bycopy.} = object
    num_entries*: cint
    entries*: ptr amqp_field_value_t

  amqp_field_value_t* {.bycopy.} = object
    kind*: uint8_t
    value*: INNER_C_UNION_amqp_126

  amqp_table_entry_t* {.bycopy.} = object
    key*: amqp_bytes_t
    value*: amqp_field_value_t

  amqp_field_value_kind_t* {.size: sizeof(cint).} = enum
    AMQP_FIELD_KIND_ARRAY = 'A', 
    AMQP_FIELD_KIND_U8 = 'B',
    AMQP_FIELD_KIND_DECIMAL = 'D', 
    AMQP_FIELD_KIND_TABLE = 'F', 
    AMQP_FIELD_KIND_I32 = 'I',
    AMQP_FIELD_KIND_U64 = 'L',
    AMQP_FIELD_KIND_UTF8 = 'S',
    AMQP_FIELD_KIND_TIMESTAMP = 'T',
    AMQP_FIELD_KIND_VOID = 'V',
    AMQP_FIELD_KIND_I8 = 'b', 
    AMQP_FIELD_KIND_F64 = 'd',
    AMQP_FIELD_KIND_F32 = 'f', 
    AMQP_FIELD_KIND_U32 = 'i', 
    AMQP_FIELD_KIND_I64 = 'l', 
    AMQP_FIELD_KIND_I16 = 's', 
    AMQP_FIELD_KIND_BOOLEAN = 't', 
    AMQP_FIELD_KIND_U16 = 'u', 
    AMQP_FIELD_KIND_BYTES = 'x'

  amqp_pool_blocklist_t* {.bycopy.} = object
    num_blocks*: cint
    blocklist*: ptr pointer

  amqp_pool_t* {.bycopy.} = object
    pagesize*: csize_t
    pages*: amqp_pool_blocklist_t
    large_blocks*: amqp_pool_blocklist_t
    next_page*: cint
    alloc_block*: cstring
    alloc_used*: csize_t

  amqp_method_t* {.bycopy.} = object
    id*: amqp_method_number_t
    decoded*: pointer

  amqp_frame_t* {.bycopy.} = object
    frame_type*: uint8_t
    channel*: amqp_channel_t
    payload*: INNER_C_UNION_amqp_192

  amqp_response_type_enum* {.size: sizeof(cint).} = enum
    AMQP_RESPONSE_NONE = 0, AMQP_RESPONSE_NORMAL, AMQP_RESPONSE_LIBRARY_EXCEPTION,
    AMQP_RESPONSE_SERVER_EXCEPTION

  amqp_rpc_reply_t* {.bycopy.} = object
    reply_type*: amqp_response_type_enum
    reply*: amqp_method_t
    library_error*: cint

  amqp_sasl_method_enum* {.size: sizeof(cint).} = enum
    AMQP_SASL_METHOD_UNDEFINED = -1, AMQP_SASL_METHOD_PLAIN = 0,
    AMQP_SASL_METHOD_EXTERNAL = 1
    
  amqp_time_t* {.bycopy.} = object
    time_point_ns*: uint64_t

  amqp_connection_state_enum* {.size: sizeof(cint).} = enum
    CONNECTION_STATE_IDLE = 0, CONNECTION_STATE_INITIAL, CONNECTION_STATE_HEADER,
    CONNECTION_STATE_BODY

  amqp_status_private_enum* {.size: sizeof(cint).} = enum
    AMQP_PRIVATE_STATUS_SOCKET_NEEDWRITE = -0x00001302,
    AMQP_PRIVATE_STATUS_SOCKET_NEEDREAD = -0x00001301

  amqp_link_t* {.bycopy.} = object
    next*: ptr amqp_link_t
    data*: pointer

  amqp_pool_table_entry_t* {.bycopy.} = object
    next*: ptr amqp_pool_table_entry_t
    pool*: amqp_pool_t
    channel*: amqp_channel_t

  amqp_connection_state_t_object* {.bycopy.} = object
    pool_table*: array[16, ptr amqp_pool_table_entry_t]
    state*: amqp_connection_state_enum
    channel_max*: cint
    frame_max*: cint
    heartbeat*: cint
    next_recv_heartbeat*: amqp_time_t
    next_send_heartbeat*: amqp_time_t
    header_buffer*: array[7 + 1, char]
    inbound_buffer*: amqp_bytes_t
    inbound_offset*: csize_t
    target_size*: csize_t
    outbound_buffer*: amqp_bytes_t
    socket*: ptr amqp_socket_t
    sock_inbound_buffer*: amqp_bytes_t
    sock_inbound_offset*: csize_t
    sock_inbound_limit*: csize_t
    first_queued_frame*: ptr amqp_link_t
    last_queued_frame*: ptr amqp_link_t
    most_recent_api_result*: amqp_rpc_reply_t
    server_properties*: amqp_table_t
    client_properties*: amqp_table_t
    properties_pool*: amqp_pool_t
    handshake_timeout*: ptr timeval
    internal_handshake_timeout*: timeval
    rpc_timeout*: ptr timeval
    internal_rpc_timeout*: timeval

  amqp_connection_state_t* = ptr amqp_connection_state_t_object

  amqp_socket_t* = object
  
  amqp_status_enum* {.size: sizeof(cint).} = enum
    AMQP_STATUS_SSL_NEXT_VALUE = -0x00000205,
    AMQP_STATUS_SSL_SET_ENGINE_FAILED = -0x00000204,
    AMQP_STATUS_SSL_CONNECTION_FAILED = -0x00000203,
    AMQP_STATUS_SSL_PEER_VERIFY_FAILED = -0x00000202,
    AMQP_STATUS_SSL_HOSTNAME_VERIFY_FAILED = -0x00000201,
    AMQP_STATUS_SSL_ERROR = -0x00000200,
    AMQP_STATUS_TCP_NEXT_VALUE = -0x00000102,
    AMQP_STATUS_TCP_SOCKETLIB_INIT_ERROR = -0x00000101,
    AMQP_STATUS_TCP_ERROR = -0x00000100, 
    AMQP_STATUS_NEXT_VALUE = -0x00000015,
    AMQP_STATUS_UNSUPPORTED = -0x00000014,
    AMQP_STATUS_BROKER_UNSUPPORTED_SASL_METHOD = -0x00000013,
    AMQP_STATUS_SOCKET_INUSE = -0x00000012,
    AMQP_STATUS_SOCKET_CLOSED = -0x00000011,
    AMQP_STATUS_UNEXPECTED_STATE = -0x00000010,
    AMQP_STATUS_HEARTBEAT_TIMEOUT = -0x0000000F,
    AMQP_STATUS_TIMER_FAILURE = -0x0000000E, 
    AMQP_STATUS_TIMEOUT = -0x0000000D,
    AMQP_STATUS_WRONG_METHOD = -0x0000000C,
    AMQP_STATUS_TABLE_TOO_BIG = -0x0000000B,
    AMQP_STATUS_INVALID_PARAMETER = -0x0000000A,
    AMQP_STATUS_SOCKET_ERROR = -0x00000009, 
    AMQP_STATUS_BAD_URL = -0x00000008,
    AMQP_STATUS_CONNECTION_CLOSED = -0x00000007,
    AMQP_STATUS_INCOMPATIBLE_AMQP_VERSION = -0x00000006,
    AMQP_STATUS_HOSTNAME_RESOLUTION_FAILED = -0x00000005,
    AMQP_STATUS_UNKNOWN_METHOD = -0x00000004,
    AMQP_STATUS_UNKNOWN_CLASS = -0x00000003,
    AMQP_STATUS_BAD_AMQP_DATA = -0x00000002, 
    AMQP_STATUS_NO_MEMORY = -0x00000001,
    AMQP_STATUS_OK = 0x00000000
  amqp_delivery_mode_enum* {.size: sizeof(cint).} = enum
    AMQP_DELIVERY_NONPERSISTENT = 1, AMQP_DELIVERY_PERSISTENT = 2






proc amqp_constant_name*(constantNumber: cint): cstring {.cdecl,
    importc: "amqp_constant_name", dynlib: librabbitmq.}
proc amqp_constant_is_hard_error*(constantNumber: cint): amqp_boolean_t {.cdecl,
    importc: "amqp_constant_is_hard_error", dynlib: librabbitmq.}
proc amqp_method_name*(methodNumber: amqp_method_number_t): cstring {.cdecl,
    importc: "amqp_method_name", dynlib: librabbitmq.}
proc amqp_method_has_content*(methodNumber: amqp_method_number_t): amqp_boolean_t {.
    cdecl, importc: "amqp_method_has_content", dynlib: librabbitmq.}
proc amqp_decode_method*(methodNumber: amqp_method_number_t; pool: ptr amqp_pool_t;
                        encoded: amqp_bytes_t; decoded: ptr pointer): cint {.cdecl,
    importc: "amqp_decode_method", dynlib: librabbitmq.}
proc amqp_decode_properties*(class_id: uint16_t; pool: ptr amqp_pool_t;
                            encoded: amqp_bytes_t; decoded: ptr pointer): cint {.
    cdecl, importc: "amqp_decode_properties", dynlib: librabbitmq.}
proc amqp_encode_method*(methodNumber: amqp_method_number_t; decoded: pointer;
                        encoded: amqp_bytes_t): cint {.cdecl,
    importc: "amqp_encode_method", dynlib: librabbitmq.}
proc amqp_encode_properties*(class_id: uint16_t; decoded: pointer;
                            encoded: amqp_bytes_t): cint {.cdecl,
    importc: "amqp_encode_properties", dynlib: librabbitmq.}
type
  amqp_connection_start_t* {.bycopy.} = object
    version_major*: uint8_t
    version_minor*: uint8_t
    server_properties*: amqp_table_t
    mechanisms*: amqp_bytes_t
    locales*: amqp_bytes_t

  amqp_connection_start_ok_t* {.bycopy.} = object
    client_properties*: amqp_table_t
    mechanism*: amqp_bytes_t
    response*: amqp_bytes_t
    locale*: amqp_bytes_t

  amqp_connection_secure_t* {.bycopy.} = object
    challenge*: amqp_bytes_t

  amqp_connection_secure_ok_t* {.bycopy.} = object
    response*: amqp_bytes_t

  amqp_connection_tune_t* {.bycopy.} = object
    channel_max*: uint16_t
    frame_max*: uint32_t
    heartbeat*: uint16_t

  amqp_connection_tune_ok_t* {.bycopy.} = object
    channel_max*: uint16_t
    frame_max*: uint32_t
    heartbeat*: uint16_t

  amqp_connection_open_t* {.bycopy.} = object
    virtual_host*: amqp_bytes_t
    capabilities*: amqp_bytes_t
    insist*: amqp_boolean_t

  amqp_connection_open_ok_t* {.bycopy.} = object
    known_hosts*: amqp_bytes_t

  amqp_connection_close_t* {.bycopy.} = object
    reply_code*: uint16_t
    reply_text*: amqp_bytes_t
    class_id*: uint16_t
    method_id*: uint16_t

  amqp_connection_close_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_connection_blocked_t* {.bycopy.} = object
    reason*: amqp_bytes_t

  amqp_connection_unblocked_t* {.bycopy.} = object
    dummy*: char

  amqp_channel_open_t* {.bycopy.} = object
    out_of_band*: amqp_bytes_t

  amqp_channel_open_ok_t* {.bycopy.} = object
    channel_id*: amqp_bytes_t

  amqp_channel_flow_t* {.bycopy.} = object
    active*: amqp_boolean_t

  amqp_channel_flow_ok_t* {.bycopy.} = object
    active*: amqp_boolean_t

  amqp_channel_close_t* {.bycopy.} = object
    reply_code*: uint16_t
    reply_text*: amqp_bytes_t
    class_id*: uint16_t
    method_id*: uint16_t

  amqp_channel_close_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_access_request_t* {.bycopy.} = object
    realm*: amqp_bytes_t
    exclusive*: amqp_boolean_t
    passive*: amqp_boolean_t
    active*: amqp_boolean_t
    write*: amqp_boolean_t
    read*: amqp_boolean_t

  amqp_access_request_ok_t* {.bycopy.} = object
    ticket*: uint16_t

  amqp_exchange_declare_t* {.bycopy.} = object
    ticket*: uint16_t
    exchange*: amqp_bytes_t
    `type`*: amqp_bytes_t
    passive*: amqp_boolean_t
    durable*: amqp_boolean_t
    auto_delete*: amqp_boolean_t
    internal*: amqp_boolean_t
    nowait*: amqp_boolean_t
    arguments*: amqp_table_t

  amqp_exchange_declare_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_exchange_delete_t* {.bycopy.} = object
    ticket*: uint16_t
    exchange*: amqp_bytes_t
    if_unused*: amqp_boolean_t
    nowait*: amqp_boolean_t

  amqp_exchange_delete_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_exchange_bind_t* {.bycopy.} = object
    ticket*: uint16_t
    destination*: amqp_bytes_t
    source*: amqp_bytes_t
    routing_key*: amqp_bytes_t
    nowait*: amqp_boolean_t
    arguments*: amqp_table_t

  amqp_exchange_bind_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_exchange_unbind_t* {.bycopy.} = object
    ticket*: uint16_t
    destination*: amqp_bytes_t
    source*: amqp_bytes_t
    routing_key*: amqp_bytes_t
    nowait*: amqp_boolean_t
    arguments*: amqp_table_t

  amqp_exchange_unbind_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_queue_declare_t* {.bycopy.} = object
    ticket*: uint16_t
    queue*: amqp_bytes_t
    passive*: amqp_boolean_t
    durable*: amqp_boolean_t
    exclusive*: amqp_boolean_t
    auto_delete*: amqp_boolean_t
    nowait*: amqp_boolean_t
    arguments*: amqp_table_t

  amqp_queue_declare_ok_t* {.bycopy.} = object
    queue*: amqp_bytes_t
    message_count*: uint32_t
    consumer_count*: uint32_t

  amqp_queue_bind_t* {.bycopy.} = object
    ticket*: uint16_t
    queue*: amqp_bytes_t
    exchange*: amqp_bytes_t
    routing_key*: amqp_bytes_t
    nowait*: amqp_boolean_t
    arguments*: amqp_table_t

  amqp_queue_bind_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_queue_purge_t* {.bycopy.} = object
    ticket*: uint16_t
    queue*: amqp_bytes_t
    nowait*: amqp_boolean_t

  amqp_queue_purge_ok_t* {.bycopy.} = object
    message_count*: uint32_t

  amqp_queue_delete_t* {.bycopy.} = object
    ticket*: uint16_t
    queue*: amqp_bytes_t
    if_unused*: amqp_boolean_t
    if_empty*: amqp_boolean_t
    nowait*: amqp_boolean_t

  amqp_queue_delete_ok_t* {.bycopy.} = object
    message_count*: uint32_t

  amqp_queue_unbind_t* {.bycopy.} = object
    ticket*: uint16_t
    queue*: amqp_bytes_t
    exchange*: amqp_bytes_t
    routing_key*: amqp_bytes_t
    arguments*: amqp_table_t

  amqp_queue_unbind_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_basic_qos_t* {.bycopy.} = object
    prefetch_size*: uint32_t
    prefetch_count*: uint16_t
    global*: amqp_boolean_t

  amqp_basic_qos_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_basic_consume_t* {.bycopy.} = object
    ticket*: uint16_t
    queue*: amqp_bytes_t
    consumer_tag*: amqp_bytes_t
    no_local*: amqp_boolean_t
    no_ack*: amqp_boolean_t
    exclusive*: amqp_boolean_t
    nowait*: amqp_boolean_t
    arguments*: amqp_table_t

  amqp_basic_consume_ok_t* {.bycopy.} = object
    consumer_tag*: amqp_bytes_t

  amqp_basic_cancel_t* {.bycopy.} = object
    consumer_tag*: amqp_bytes_t
    nowait*: amqp_boolean_t

  amqp_basic_cancel_ok_t* {.bycopy.} = object
    consumer_tag*: amqp_bytes_t

  amqp_basic_publish_t* {.bycopy.} = object
    ticket*: uint16_t
    exchange*: amqp_bytes_t
    routing_key*: amqp_bytes_t
    mandatory*: amqp_boolean_t
    immediate*: amqp_boolean_t

  amqp_basic_return_t* {.bycopy.} = object
    reply_code*: uint16_t
    reply_text*: amqp_bytes_t
    exchange*: amqp_bytes_t
    routing_key*: amqp_bytes_t

  amqp_basic_deliver_t* {.bycopy.} = object
    consumer_tag*: amqp_bytes_t
    delivery_tag*: uint64_t
    redelivered*: amqp_boolean_t
    exchange*: amqp_bytes_t
    routing_key*: amqp_bytes_t

  amqp_basic_get_t* {.bycopy.} = object
    ticket*: uint16_t
    queue*: amqp_bytes_t
    no_ack*: amqp_boolean_t

  amqp_basic_get_ok_t* {.bycopy.} = object
    delivery_tag*: uint64_t
    redelivered*: amqp_boolean_t
    exchange*: amqp_bytes_t
    routing_key*: amqp_bytes_t
    message_count*: uint32_t

  amqp_basic_get_empty_t* {.bycopy.} = object
    cluster_id*: amqp_bytes_t

  amqp_basic_ack_t* {.bycopy.} = object
    delivery_tag*: uint64_t
    multiple*: amqp_boolean_t

  amqp_basic_reject_t* {.bycopy.} = object
    delivery_tag*: uint64_t
    requeue*: amqp_boolean_t

  amqp_basic_recover_async_t* {.bycopy.} = object
    requeue*: amqp_boolean_t

  amqp_basic_recover_t* {.bycopy.} = object
    requeue*: amqp_boolean_t

  amqp_basic_recover_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_basic_nack_t* {.bycopy.} = object
    delivery_tag*: uint64_t
    multiple*: amqp_boolean_t
    requeue*: amqp_boolean_t

  amqp_tx_select_t* {.bycopy.} = object
    dummy*: char

  amqp_tx_select_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_tx_commit_t* {.bycopy.} = object
    dummy*: char

  amqp_tx_commit_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_tx_rollback_t* {.bycopy.} = object
    dummy*: char

  amqp_tx_rollback_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_confirm_select_t* {.bycopy.} = object
    nowait*: amqp_boolean_t

  amqp_confirm_select_ok_t* {.bycopy.} = object
    dummy*: char

  amqp_connection_properties_t* {.bycopy.} = object
    flags*: amqp_flags_t
    dummy*: char

  amqp_channel_properties_t* {.bycopy.} = object
    flags*: amqp_flags_t
    dummy*: char

  amqp_access_properties_t* {.bycopy.} = object
    flags*: amqp_flags_t
    dummy*: char

  amqp_exchange_properties_t* {.bycopy.} = object
    flags*: amqp_flags_t
    dummy*: char

  amqp_queue_properties_t* {.bycopy.} = object
    flags*: amqp_flags_t
    dummy*: char

  amqp_basic_properties_t* {.bycopy.} = object
    flags*: amqp_flags_t
    content_type*: amqp_bytes_t
    content_encoding*: amqp_bytes_t
    headers*: amqp_table_t
    delivery_mode*: uint8_t
    priority*: uint8_t
    correlation_id*: amqp_bytes_t
    reply_to*: amqp_bytes_t
    expiration*: amqp_bytes_t
    message_id*: amqp_bytes_t
    timestamp*: uint64_t
    `type`*: amqp_bytes_t
    user_id*: amqp_bytes_t
    app_id*: amqp_bytes_t
    cluster_id*: amqp_bytes_t

  amqp_tx_properties_t* {.bycopy.} = object
    flags*: amqp_flags_t
    dummy*: char

  amqp_confirm_properties_t* {.bycopy.} = object
    flags*: amqp_flags_t
    dummy*: char


proc amqp_channel_open*(state: amqp_connection_state_t; channel: amqp_channel_t): ptr amqp_channel_open_ok_t {.
    cdecl, importc: "amqp_channel_open", dynlib: librabbitmq.}
proc amqp_channel_flow*(state: amqp_connection_state_t; channel: amqp_channel_t;
                       active: amqp_boolean_t): ptr amqp_channel_flow_ok_t {.cdecl,
    importc: "amqp_channel_flow", dynlib: librabbitmq.}
proc amqp_exchange_declare*(state: amqp_connection_state_t;
                           channel: amqp_channel_t; exchange: amqp_bytes_t;
                           `type`: amqp_bytes_t; passive: amqp_boolean_t;
                           durable: amqp_boolean_t; auto_delete: amqp_boolean_t;
                           internal: amqp_boolean_t; arguments: amqp_table_t): ptr amqp_exchange_declare_ok_t {.
    cdecl, importc: "amqp_exchange_declare", dynlib: librabbitmq.}
proc amqp_exchange_delete*(state: amqp_connection_state_t; channel: amqp_channel_t;
                          exchange: amqp_bytes_t; if_unused: amqp_boolean_t): ptr amqp_exchange_delete_ok_t {.
    cdecl, importc: "amqp_exchange_delete", dynlib: librabbitmq.}
proc amqp_exchange_bind*(state: amqp_connection_state_t; channel: amqp_channel_t;
                        destination: amqp_bytes_t; source: amqp_bytes_t;
                        routing_key: amqp_bytes_t; arguments: amqp_table_t): ptr amqp_exchange_bind_ok_t {.
    cdecl, importc: "amqp_exchange_bind", dynlib: librabbitmq.}
proc amqp_exchange_unbind*(state: amqp_connection_state_t; channel: amqp_channel_t;
                          destination: amqp_bytes_t; source: amqp_bytes_t;
                          routing_key: amqp_bytes_t; arguments: amqp_table_t): ptr amqp_exchange_unbind_ok_t {.
    cdecl, importc: "amqp_exchange_unbind", dynlib: librabbitmq.}
proc amqp_queue_declare*(state: amqp_connection_state_t; channel: amqp_channel_t;
                        queue: amqp_bytes_t; passive: amqp_boolean_t;
                        durable: amqp_boolean_t; exclusive: amqp_boolean_t;
                        auto_delete: amqp_boolean_t; arguments: amqp_table_t): ptr amqp_queue_declare_ok_t {.
    cdecl, importc: "amqp_queue_declare", dynlib: librabbitmq.}
proc amqp_queue_bind*(state: amqp_connection_state_t; channel: amqp_channel_t;
                     queue: amqp_bytes_t; exchange: amqp_bytes_t;
                     routing_key: amqp_bytes_t; arguments: amqp_table_t): ptr amqp_queue_bind_ok_t {.
    cdecl, importc: "amqp_queue_bind", dynlib: librabbitmq.}
proc amqp_queue_purge*(state: amqp_connection_state_t; channel: amqp_channel_t;
                      queue: amqp_bytes_t): ptr amqp_queue_purge_ok_t {.cdecl,
    importc: "amqp_queue_purge", dynlib: librabbitmq.}
proc amqp_queue_delete*(state: amqp_connection_state_t; channel: amqp_channel_t;
                       queue: amqp_bytes_t; if_unused: amqp_boolean_t;
                       if_empty: amqp_boolean_t): ptr amqp_queue_delete_ok_t {.
    cdecl, importc: "amqp_queue_delete", dynlib: librabbitmq.}
proc amqp_queue_unbind*(state: amqp_connection_state_t; channel: amqp_channel_t;
                       queue: amqp_bytes_t; exchange: amqp_bytes_t;
                       routing_key: amqp_bytes_t; arguments: amqp_table_t): ptr amqp_queue_unbind_ok_t {.
    cdecl, importc: "amqp_queue_unbind", dynlib: librabbitmq.}
proc amqp_basic_qos*(state: amqp_connection_state_t; channel: amqp_channel_t;
                    prefetch_size: uint32_t; prefetch_count: uint16_t;
                    global: amqp_boolean_t): ptr amqp_basic_qos_ok_t {.cdecl,
    importc: "amqp_basic_qos", dynlib: librabbitmq.}
proc amqp_basic_consume*(state: amqp_connection_state_t; channel: amqp_channel_t;
                        queue: amqp_bytes_t; consumer_tag: amqp_bytes_t;
                        no_local: amqp_boolean_t; no_ack: amqp_boolean_t;
                        exclusive: amqp_boolean_t; arguments: amqp_table_t): ptr amqp_basic_consume_ok_t {.
    cdecl, importc: "amqp_basic_consume", dynlib: librabbitmq.}
proc amqp_basic_cancel*(state: amqp_connection_state_t; channel: amqp_channel_t;
                       consumer_tag: amqp_bytes_t): ptr amqp_basic_cancel_ok_t {.
    cdecl, importc: "amqp_basic_cancel", dynlib: librabbitmq.}
proc amqp_basic_recover*(state: amqp_connection_state_t; channel: amqp_channel_t;
                        requeue: amqp_boolean_t): ptr amqp_basic_recover_ok_t {.
    cdecl, importc: "amqp_basic_recover", dynlib: librabbitmq.}
proc amqp_tx_select*(state: amqp_connection_state_t; channel: amqp_channel_t): ptr amqp_tx_select_ok_t {.
    cdecl, importc: "amqp_tx_select", dynlib: librabbitmq.}
proc amqp_tx_commit*(state: amqp_connection_state_t; channel: amqp_channel_t): ptr amqp_tx_commit_ok_t {.
    cdecl, importc: "amqp_tx_commit", dynlib: librabbitmq.}
proc amqp_tx_rollback*(state: amqp_connection_state_t; channel: amqp_channel_t): ptr amqp_tx_rollback_ok_t {.
    cdecl, importc: "amqp_tx_rollback", dynlib: librabbitmq.}
proc amqp_confirm_select*(state: amqp_connection_state_t; channel: amqp_channel_t): ptr amqp_confirm_select_ok_t {.
    cdecl, importc: "amqp_confirm_select", dynlib: librabbitmq.}
var amqp_empty_bytes* {.importc: "amqp_empty_bytes", dynlib: librabbitmq.}: amqp_bytes_t

var amqp_empty_table* {.importc: "amqp_empty_table", dynlib: librabbitmq.}: amqp_table_t

var amqp_empty_array* {.importc: "amqp_empty_array", dynlib: librabbitmq.}: amqp_array_t

proc init_amqp_pool*(pool: ptr amqp_pool_t; pagesize: csize_t) {.cdecl,
    importc: "init_amqp_pool", dynlib: librabbitmq.}
proc recycle_amqp_pool*(pool: ptr amqp_pool_t) {.cdecl, importc: "recycle_amqp_pool",
    dynlib: librabbitmq.}
proc empty_amqp_pool*(pool: ptr amqp_pool_t) {.cdecl, importc: "empty_amqp_pool",
    dynlib: librabbitmq.}
proc amqp_pool_alloc*(pool: ptr amqp_pool_t; amount: csize_t): pointer {.cdecl,
    importc: "amqp_pool_alloc", dynlib: librabbitmq.}
proc amqp_pool_alloc_bytes*(pool: ptr amqp_pool_t; amount: csize_t;
                           output: ptr amqp_bytes_t) {.cdecl,
    importc: "amqp_pool_alloc_bytes", dynlib: librabbitmq.}
proc amqp_cstring_bytes*(cstr: cstring): amqp_bytes_t {.cdecl,
    importc: "amqp_cstring_bytes", dynlib: librabbitmq.}
proc amqp_bytes_malloc_dup*(src: amqp_bytes_t): amqp_bytes_t {.cdecl,
    importc: "amqp_bytes_malloc_dup", dynlib: librabbitmq.}
proc amqp_bytes_malloc*(amount: csize_t): amqp_bytes_t {.cdecl,
    importc: "amqp_bytes_malloc", dynlib: librabbitmq.}
proc amqp_bytes_free*(bytes: amqp_bytes_t) {.cdecl, importc: "amqp_bytes_free",
    dynlib: librabbitmq.}
proc amqp_new_connection*(): amqp_connection_state_t {.cdecl,
    importc: "amqp_new_connection", dynlib: librabbitmq.}
proc amqp_get_sockfd*(state: amqp_connection_state_t): cint {.cdecl,
    importc: "amqp_get_sockfd", dynlib: librabbitmq.}
proc amqp_tune_connection*(state: amqp_connection_state_t; channel_max: cint;
                          frame_max: cint; heartbeat: cint): cint {.cdecl,
    importc: "amqp_tune_connection", dynlib: librabbitmq.}
proc amqp_get_channel_max*(state: amqp_connection_state_t): cint {.cdecl,
    importc: "amqp_get_channel_max", dynlib: librabbitmq.}
proc amqp_get_frame_max*(state: amqp_connection_state_t): cint {.cdecl,
    importc: "amqp_get_frame_max", dynlib: librabbitmq.}
proc amqp_get_heartbeat*(state: amqp_connection_state_t): cint {.cdecl,
    importc: "amqp_get_heartbeat", dynlib: librabbitmq.}
proc amqp_destroy_connection*(state: amqp_connection_state_t): cint {.cdecl,
    importc: "amqp_destroy_connection", dynlib: librabbitmq.}
proc amqp_handle_input*(state: amqp_connection_state_t;
                       received_data: amqp_bytes_t;
                       decoded_frame: ptr amqp_frame_t): cint {.cdecl,
    importc: "amqp_handle_input", dynlib: librabbitmq.}
proc amqp_release_buffers_ok*(state: amqp_connection_state_t): amqp_boolean_t {.
    cdecl, importc: "amqp_release_buffers_ok", dynlib: librabbitmq.}
proc amqp_release_buffers*(state: amqp_connection_state_t) {.cdecl,
    importc: "amqp_release_buffers", dynlib: librabbitmq.}
proc amqp_maybe_release_buffers*(state: amqp_connection_state_t) {.cdecl,
    importc: "amqp_maybe_release_buffers", dynlib: librabbitmq.}
proc amqp_maybe_release_buffers_on_channel*(state: amqp_connection_state_t;
    channel: amqp_channel_t) {.cdecl,
                             importc: "amqp_maybe_release_buffers_on_channel",
                             dynlib: librabbitmq.}
proc amqp_send_frame*(state: amqp_connection_state_t; frame: ptr amqp_frame_t): cint {.
    cdecl, importc: "amqp_send_frame", dynlib: librabbitmq.}
proc amqp_table_entry_cmp*(entry1: pointer; entry2: pointer): cint {.cdecl,
    importc: "amqp_table_entry_cmp", dynlib: librabbitmq.}
proc amqp_open_socket*(hostname: cstring; portnumber: cint): cint {.cdecl,
    importc: "amqp_open_socket", dynlib: librabbitmq.}
proc amqp_send_header*(state: amqp_connection_state_t): cint {.cdecl,
    importc: "amqp_send_header", dynlib: librabbitmq.}
proc amqp_frames_enqueued*(state: amqp_connection_state_t): amqp_boolean_t {.cdecl,
    importc: "amqp_frames_enqueued", dynlib: librabbitmq.}
proc amqp_simple_wait_frame*(state: amqp_connection_state_t;
                            decoded_frame: ptr amqp_frame_t): cint {.cdecl,
    importc: "amqp_simple_wait_frame", dynlib: librabbitmq.}
proc amqp_simple_wait_frame_noblock*(state: amqp_connection_state_t;
                                    decoded_frame: ptr amqp_frame_t;
                                    tv: ptr timeval): cint {.cdecl,
    importc: "amqp_simple_wait_frame_noblock", dynlib: librabbitmq.}
proc amqp_simple_wait_method*(state: amqp_connection_state_t;
                             expected_channel: amqp_channel_t;
                             expected_method: amqp_method_number_t;
                             output: ptr amqp_method_t): cint {.cdecl,
    importc: "amqp_simple_wait_method", dynlib: librabbitmq.}
proc amqp_send_method*(state: amqp_connection_state_t; channel: amqp_channel_t;
                      id: amqp_method_number_t; decoded: pointer): cint {.cdecl,
    importc: "amqp_send_method", dynlib: librabbitmq.}
proc amqp_simple_rpc*(state: amqp_connection_state_t; channel: amqp_channel_t;
                     request_id: amqp_method_number_t;
                     expected_reply_ids: ptr amqp_method_number_t;
                     decoded_request_method: pointer): amqp_rpc_reply_t {.cdecl,
    importc: "amqp_simple_rpc", dynlib: librabbitmq.}
proc amqp_simple_rpc_decoded*(state: amqp_connection_state_t;
                             channel: amqp_channel_t;
                             request_id: amqp_method_number_t;
                             reply_id: amqp_method_number_t;
                             decoded_request_method: pointer): pointer {.cdecl,
    importc: "amqp_simple_rpc_decoded", dynlib: librabbitmq.}
proc amqp_get_rpc_reply*(state: amqp_connection_state_t): amqp_rpc_reply_t {.cdecl,
    importc: "amqp_get_rpc_reply", dynlib: librabbitmq.}
proc amqp_login*(state: amqp_connection_state_t; vhost: cstring; channel_max: cint;
                frame_max: cint; heartbeat: cint; sasl_method: amqp_sasl_method_enum): amqp_rpc_reply_t {.
    varargs, cdecl, importc: "amqp_login", dynlib: librabbitmq.}
proc amqp_login_with_properties*(state: amqp_connection_state_t; vhost: cstring;
                                channel_max: cint; frame_max: cint; heartbeat: cint;
                                properties: ptr amqp_table_t;
                                sasl_method: amqp_sasl_method_enum): amqp_rpc_reply_t {.
    varargs, cdecl, importc: "amqp_login_with_properties", dynlib: librabbitmq.}

proc amqp_basic_publish*(state: amqp_connection_state_t; channel: amqp_channel_t;
                        exchange: amqp_bytes_t; routing_key: amqp_bytes_t;
                        mandatory: amqp_boolean_t; immediate: amqp_boolean_t;
                        properties: ptr amqp_basic_properties_t;
                        body: amqp_bytes_t): cint {.cdecl,
    importc: "amqp_basic_publish", dynlib: librabbitmq.}
proc amqp_channel_close*(state: amqp_connection_state_t; channel: amqp_channel_t;
                        code: cint): amqp_rpc_reply_t {.cdecl,
    importc: "amqp_channel_close", dynlib: librabbitmq.}
proc amqp_connection_close*(state: amqp_connection_state_t; code: cint): amqp_rpc_reply_t {.
    cdecl, importc: "amqp_connection_close", dynlib: librabbitmq.}
proc amqp_basic_ack*(state: amqp_connection_state_t; channel: amqp_channel_t;
                    delivery_tag: uint64_t; multiple: amqp_boolean_t): cint {.cdecl,
    importc: "amqp_basic_ack", dynlib: librabbitmq.}
proc amqp_basic_get*(state: amqp_connection_state_t; channel: amqp_channel_t;
                    queue: amqp_bytes_t; no_ack: amqp_boolean_t): amqp_rpc_reply_t {.
    cdecl, importc: "amqp_basic_get", dynlib: librabbitmq.}
proc amqp_basic_reject*(state: amqp_connection_state_t; channel: amqp_channel_t;
                       delivery_tag: uint64_t; requeue: amqp_boolean_t): cint {.
    cdecl, importc: "amqp_basic_reject", dynlib: librabbitmq.}
proc amqp_basic_nack*(state: amqp_connection_state_t; channel: amqp_channel_t;
                     delivery_tag: uint64_t; multiple: amqp_boolean_t;
                     requeue: amqp_boolean_t): cint {.cdecl,
    importc: "amqp_basic_nack", dynlib: librabbitmq.}
proc amqp_data_in_buffer*(state: amqp_connection_state_t): amqp_boolean_t {.cdecl,
    importc: "amqp_data_in_buffer", dynlib: librabbitmq.}
proc amqp_error_string2*(err: cint): cstring {.cdecl, importc: "amqp_error_string2",
    dynlib: librabbitmq.}
proc amqp_decode_table*(encoded: amqp_bytes_t; pool: ptr amqp_pool_t;
                       output: ptr amqp_table_t; offset: ptr csize_t): cint {.cdecl,
    importc: "amqp_decode_table", dynlib: librabbitmq.}
proc amqp_encode_table*(encoded: amqp_bytes_t; input: ptr amqp_table_t;
                       offset: ptr csize_t): cint {.cdecl,
    importc: "amqp_encode_table", dynlib: librabbitmq.}
proc amqp_table_clone*(original: ptr amqp_table_t; clone: ptr amqp_table_t;
                      pool: ptr amqp_pool_t): cint {.cdecl,
    importc: "amqp_table_clone", dynlib: librabbitmq.}
type
  amqp_message_t* {.bycopy.} = object
    properties*: amqp_basic_properties_t
    body*: amqp_bytes_t
    pool*: amqp_pool_t


proc amqp_read_message*(state: amqp_connection_state_t; channel: amqp_channel_t;
                       message: ptr amqp_message_t; flags: cint): amqp_rpc_reply_t {.
    cdecl, importc: "amqp_read_message", dynlib: librabbitmq.}
proc amqp_destroy_message*(message: ptr amqp_message_t) {.cdecl,
    importc: "amqp_destroy_message", dynlib: librabbitmq.}
type
  amqp_envelope_t* {.bycopy.} = object
    channel*: amqp_channel_t
    consumer_tag*: amqp_bytes_t
    delivery_tag*: uint64_t
    redelivered*: amqp_boolean_t
    exchange*: amqp_bytes_t
    routing_key*: amqp_bytes_t
    message*: amqp_message_t


proc amqp_consume_message*(state: amqp_connection_state_t;
                          envelope: ptr amqp_envelope_t; timeout: ptr timeval;
                          flags: cint): amqp_rpc_reply_t {.cdecl,
    importc: "amqp_consume_message", dynlib: librabbitmq.}
proc amqp_destroy_envelope*(envelope: ptr amqp_envelope_t) {.cdecl,
    importc: "amqp_destroy_envelope", dynlib: librabbitmq.}
type
  amqp_connection_info* {.bycopy.} = object
    user*: cstring
    password*: cstring
    host*: cstring
    vhost*: cstring
    port*: cint
    ssl*: amqp_boolean_t


proc amqp_default_connection_info*(parsed: ptr amqp_connection_info) {.cdecl,
    importc: "amqp_default_connection_info", dynlib: librabbitmq.}
proc amqp_parse_url*(url: cstring; parsed: ptr amqp_connection_info): cint {.cdecl,
    importc: "amqp_parse_url", dynlib: librabbitmq.}
proc amqp_socket_open*(self: ptr amqp_socket_t; host: cstring; port: cint): cint {.cdecl,
    importc: "amqp_socket_open", dynlib: librabbitmq.}
proc amqp_socket_open_noblock*(self: ptr amqp_socket_t; host: cstring; port: cint;
                              timeout: ptr timeval): cint {.cdecl,
    importc: "amqp_socket_open_noblock", dynlib: librabbitmq.}
proc amqp_socket_get_sockfd*(self: ptr amqp_socket_t): cint {.cdecl,
    importc: "amqp_socket_get_sockfd", dynlib: librabbitmq.}
proc amqp_get_socket*(state: amqp_connection_state_t): ptr amqp_socket_t {.cdecl,
    importc: "amqp_get_socket", dynlib: librabbitmq.}
proc amqp_get_server_properties*(state: amqp_connection_state_t): ptr amqp_table_t {.
    cdecl, importc: "amqp_get_server_properties", dynlib: librabbitmq.}
proc amqp_get_client_properties*(state: amqp_connection_state_t): ptr amqp_table_t {.
    cdecl, importc: "amqp_get_client_properties", dynlib: librabbitmq.}
proc amqp_get_handshake_timeout*(state: amqp_connection_state_t): ptr timeval {.
    cdecl, importc: "amqp_get_handshake_timeout", dynlib: librabbitmq.}
proc amqp_set_handshake_timeout*(state: amqp_connection_state_t;
                                timeout: ptr timeval): cint {.cdecl,
    importc: "amqp_set_handshake_timeout", dynlib: librabbitmq.}
proc amqp_get_rpc_timeout*(state: amqp_connection_state_t): ptr timeval {.cdecl,
    importc: "amqp_get_rpc_timeout", dynlib: librabbitmq.}
proc amqp_set_rpc_timeout*(state: amqp_connection_state_t; timeout: ptr timeval): cint {.
    cdecl, importc: "amqp_set_rpc_timeout", dynlib: librabbitmq.}


proc amqp_tcp_socket_new*(state: amqp_connection_state_t): ptr amqp_socket_t {.
    cdecl, importc: "amqp_tcp_socket_new", dynlib: librabbitmq.}

proc amqp_tcp_socket_set_sockfd*(self: ptr amqp_socket_t; sockfd: cint){.
    cdecl, importc: "amqp_tcp_socket_set_sockfd", dynlib: librabbitmq .}




proc amqp_get_monotonic_timestamp*(): uint64_t {.cdecl,
    importc: "amqp_get_monotonic_timestamp", dynlib: librabbitmq.}
proc amqp_time_from_now*(time: ptr amqp_time_t; timeout: ptr timeval): cint {.cdecl,
    importc: "amqp_time_from_now", dynlib: librabbitmq.}
proc amqp_time_s_from_now*(time: ptr amqp_time_t; seconds: cint): cint {.cdecl,
    importc: "amqp_time_s_from_now", dynlib: librabbitmq.}
proc amqp_time_infinite*(): amqp_time_t {.cdecl, importc: "amqp_time_infinite",
                                       dynlib: librabbitmq.}
proc amqp_time_ms_until*(time: amqp_time_t): cint {.cdecl,
    importc: "amqp_time_ms_until", dynlib: librabbitmq.}
proc amqp_time_tv_until*(time: amqp_time_t; `in`: ptr timeval; `out`: ptr ptr timeval): cint {.
    cdecl, importc: "amqp_time_tv_until", dynlib: librabbitmq.}
proc amqp_time_has_past*(time: amqp_time_t): cint {.cdecl,
    importc: "amqp_time_has_past", dynlib: librabbitmq.}
proc amqp_time_first*(l: amqp_time_t; r: amqp_time_t): amqp_time_t {.cdecl,
    importc: "amqp_time_first", dynlib: librabbitmq.}
proc amqp_time_equal*(l: amqp_time_t; r: amqp_time_t): cint {.cdecl,
    importc: "amqp_time_equal", dynlib: librabbitmq.}

proc amqp_get_or_create_channel_pool*(connection: amqp_connection_state_t;
                                     channel: amqp_channel_t): ptr amqp_pool_t {.
    cdecl, importc: "amqp_get_or_create_channel_pool", dynlib: librabbitmq.}
proc amqp_get_channel_pool*(state: amqp_connection_state_t; channel: amqp_channel_t): ptr amqp_pool_t {.
    cdecl, importc: "amqp_get_channel_pool", dynlib: librabbitmq.}
proc amqp_heartbeat_send*(state: amqp_connection_state_t): cint {.inline, cdecl.} =
  return state.heartbeat

proc amqp_heartbeat_recv*(state: amqp_connection_state_t): cint {.inline, cdecl.} =
  return 2 * state.heartbeat

proc amqp_try_recv*(state: amqp_connection_state_t): cint {.cdecl,
    importc: "amqp_try_recv", dynlib: librabbitmq.}

# proc amqp_offset*(data: pointer; offset: csize_t): pointer {.inline, cdecl.} =
#   return cast[pointer](cast[ByteAddress](data) + offset.int)

# proc is_bigendian*(): cint {.inline, cdecl.} =
#   var bint: tuple[i: uint32_t, c: array[4, char]]
#   return bint.c[0] == 1

# proc amqp_e8*(val: uint8_t; data: pointer) {.inline, cdecl.} =
#   memcpy(data, addr(val), sizeof((val)))

# proc amqp_d8*(data: pointer): uint8_t {.inline, cdecl.} =
#   var val: uint8_t
#   memcpy(addr(val), data, sizeof((val)))
#   return val

# proc amqp_e16*(val: uint16_t; data: pointer) {.inline, cdecl.} =
#   if not is_bigendian():
#     val = ((val and 0x0000FF00) shr 8) or ((val and 0x000000FF) shl 8)
#   memcpy(data, addr(val), sizeof((val)))

# proc amqp_d16*(data: pointer): uint16_t {.inline, cdecl.} =
#   var val: uint16_t
#   memcpy(addr(val), data, sizeof((val)))
#   if not is_bigendian():
#     val = ((val and 0x0000FF00) shr 8) or ((val and 0x000000FF) shl 8)
#   return val

# proc amqp_e32*(val: uint32_t; data: pointer) {.inline, cdecl.} =
#   if not is_bigendian():
#     val = ((val and 0xFF000000) shr 24) or ((val and 0x00FF0000) shr 8) or
#         ((val and 0x0000FF00) shl 8) or ((val and 0x000000FF) shl 24)
#   memcpy(data, addr(val), sizeof((val)))

# proc amqp_d32*(data: pointer): uint32_t {.inline, cdecl.} =
#   var val: uint32_t
#   memcpy(addr(val), data, sizeof((val)))
#   if not is_bigendian():
#     val = ((val and 0xFF000000) shr 24) or ((val and 0x00FF0000) shr 8) or
#         ((val and 0x0000FF00) shl 8) or ((val and 0x000000FF) shl 24)
#   return val

# proc amqp_e64*(val: uint64_t; data: pointer) {.inline, cdecl.} =
#   if not is_bigendian():
#     val = ((val and 0x0000000000000000'i64) shr 56) or
#         ((val and 0x0000000000000000'i64) shr 40) or
#         ((val and 0x0000000000000000'i64) shr 24) or
#         ((val and 0x0000000000000000'i64) shr 8) or
#         ((val and 0x0000000000000000'i64) shl 8) or
#         ((val and 0x0000000000000000'i64) shl 24) or
#         ((val and 0x0000000000000000'i64) shl 40) or
#         ((val and 0x0000000000000000'i64) shl 56)
#   memcpy(data, addr(val), sizeof((val)))

# proc amqp_d64*(data: pointer): uint64_t {.inline, cdecl.} =
#   var val: uint64_t
#   memcpy(addr(val), data, sizeof((val)))
#   if not is_bigendian():
#     val = ((val and 0x0000000000000000'i64) shr 56) or
#         ((val and 0x0000000000000000'i64) shr 40) or
#         ((val and 0x0000000000000000'i64) shr 24) or
#         ((val and 0x0000000000000000'i64) shr 8) or
#         ((val and 0x0000000000000000'i64) shl 8) or
#         ((val and 0x0000000000000000'i64) shl 24) or
#         ((val and 0x0000000000000000'i64) shl 40) or
#         ((val and 0x0000000000000000'i64) shl 56)
#   return val

# proc amqp_encode_8*(encoded: amqp_bytes_t; offset: ptr csize_t; input: uint8_t): cint {.
#     inline, cdecl.} =
#   var o: csize_t
#   if (offset[] = o + 8 div 8) <= encoded.len:
#     amqp_e8(input, amqp_offset(encoded.bytes, o))
#     return 1
#   return 0

# proc amqp_decode_8*(encoded: amqp_bytes_t; offset: ptr csize_t; output: ptr uint8_t): cint {.
#     inline, cdecl.} =
#   var o: csize_t
#   if (offset[] = o + 8 div 8) <= encoded.len:
#     output[] = amqp_d8(amqp_offset(encoded.bytes, o))
#     return 1
#   return 0

# proc amqp_encode_16*(encoded: amqp_bytes_t; offset: ptr csize_t; input: uint16_t): cint {.
#     inline, cdecl.} =
#   var o: csize_t
#   if (offset[] = o + 16 div 8) <= encoded.len:
#     amqp_e16(input, amqp_offset(encoded.bytes, o))
#     return 1
#   return 0

# proc amqp_decode_16*(encoded: amqp_bytes_t; offset: ptr csize_t; output: ptr uint16_t): cint {.
#     inline, cdecl.} =
#   var o: csize_t
#   if (offset[] = o + 16 div 8) <= encoded.len:
#     output[] = amqp_d16(amqp_offset(encoded.bytes, o))
#     return 1
#   return 0

# proc amqp_encode_32*(encoded: amqp_bytes_t; offset: ptr csize_t; input: uint32_t): cint {.
#     inline, cdecl.} =
#   var o: csize_t
#   if (offset[] = o + 32 div 8) <= encoded.len:
#     amqp_e32(input, amqp_offset(encoded.bytes, o))
#     return 1
#   return 0

# proc amqp_decode_32*(encoded: amqp_bytes_t; offset: ptr csize_t; output: ptr uint32_t): cint {.
#     inline, cdecl.} =
#   var o: csize_t
#   if (offset[] = o + 32 div 8) <= encoded.len:
#     output[] = amqp_d32(amqp_offset(encoded.bytes, o))
#     return 1
#   return 0

# proc amqp_encode_64*(encoded: amqp_bytes_t; offset: ptr csize_t; input: uint64_t): cint {.
#     inline, cdecl.} =
#   var o: csize_t
#   if (offset[] = o + 64 div 8) <= encoded.len:
#     amqp_e64(input, amqp_offset(encoded.bytes, o))
#     return 1
#   return 0

# proc amqp_decode_64*(encoded: amqp_bytes_t; offset: ptr csize_t; output: ptr uint64_t): cint {.
#     inline, cdecl.} =
#   var o: csize_t
#   if (offset[] = o + 64 div 8) <= encoded.len:
#     output[] = amqp_d64(amqp_offset(encoded.bytes, o))
#     return 1
#   return 0

# proc amqp_encode_bytes*(encoded: amqp_bytes_t; offset: ptr csize_t;
#                        input: amqp_bytes_t): cint {.inline, cdecl.} =
#   var o: csize_t
#   if input.len == 0:
#     return 1
#   if (offset[] = o + input.len) <= encoded.len:
#     memcpy(amqp_offset(encoded.bytes, o), input.bytes, input.len)
#     return 1
#   else:
#     return 0

# proc amqp_decode_bytes*(encoded: amqp_bytes_t; offset: ptr csize_t;
#                        output: ptr amqp_bytes_t; len: csize_t): cint {.inline, cdecl.} =
#   var o: csize_t
#   if (offset[] = o + len) <= encoded.len:
#     output.bytes = amqp_offset(encoded.bytes, o)
#     output.len = len
#     return 1
#   else:
#     return 0

proc amqp_abort*(fmt: cstring) {.varargs, cdecl, importc: "amqp_abort",
                              dynlib: librabbitmq.}
proc amqp_bytes_equal*(r: amqp_bytes_t; l: amqp_bytes_t): cint {.cdecl,
    importc: "amqp_bytes_equal", dynlib: librabbitmq.}
proc amqp_rpc_reply_error*(status: amqp_status_enum): amqp_rpc_reply_t {.inline,
    cdecl.} =
  var reply: amqp_rpc_reply_t
  reply.reply_type = AMQP_RESPONSE_LIBRARY_EXCEPTION
  reply.library_error = cint(status)
  return reply

proc amqp_send_frame_inner*(state: amqp_connection_state_t;
                           frame: ptr amqp_frame_t; flags: cint;
                           deadline: amqp_time_t): cint {.cdecl,
    importc: "amqp_send_frame_inner", dynlib: librabbitmq.}
type
  amqp_socket_flag_enum* {.size: sizeof(cint).} = enum
    AMQP_SF_NONE = 0, AMQP_SF_MORE = 1, AMQP_SF_POLLIN = 2, AMQP_SF_POLLOUT = 4,
    AMQP_SF_POLLERR = 8
  amqp_socket_close_enum* {.size: sizeof(cint).} = enum
    AMQP_SC_NONE = 0, AMQP_SC_FORCE = 1



proc amqp_os_socket_error*(): cint {.cdecl, importc: "amqp_os_socket_error",
                                  dynlib: librabbitmq.}
proc amqp_os_socket_close*(sockfd: cint): cint {.cdecl,
    importc: "amqp_os_socket_close", dynlib: librabbitmq.}
type
  amqp_socket_send_fn* = proc (a1: pointer; a2: pointer; a3: csize_t; a4: cint): ssize_t {.
      cdecl.}
  amqp_socket_recv_fn* = proc (a1: pointer; a2: pointer; a3: csize_t; a4: cint): ssize_t {.
      cdecl.}
  amqp_socket_open_fn* = proc (a1: pointer; a2: cstring; a3: cint; a4: ptr timeval): cint {.
      cdecl.}
  amqp_socket_close_fn* = proc (a1: pointer; a2: amqp_socket_close_enum): cint {.cdecl.}
  amqp_socket_get_sockfd_fn* = proc (a1: pointer): cint {.cdecl.}
  amqp_socket_delete_fn* = proc (a1: pointer) {.cdecl.}
  amqp_socket_class_t* {.bycopy.} = object
    send*: amqp_socket_send_fn
    recv*: amqp_socket_recv_fn
    open*: amqp_socket_open_fn
    close*: amqp_socket_close_fn
    get_sockfd*: amqp_socket_get_sockfd_fn
    delete*: amqp_socket_delete_fn

  # amqp_socket_t_* {.bycopy.} = object
  #   klass*: ptr amqp_socket_class_t


proc amqp_set_socket*(state: amqp_connection_state_t; socket: ptr amqp_socket_t) {.
    cdecl, importc: "amqp_set_socket", dynlib: librabbitmq.}
proc amqp_socket_send*(self: ptr amqp_socket_t; buf: pointer; len: csize_t; flags: cint): ssize_t {.
    cdecl, importc: "amqp_socket_send", dynlib: librabbitmq.}
proc amqp_try_send*(state: amqp_connection_state_t; buf: pointer; len: csize_t;
                   deadline: amqp_time_t; flags: cint): ssize_t {.cdecl,
    importc: "amqp_try_send", dynlib: librabbitmq.}
proc amqp_socket_recv*(self: ptr amqp_socket_t; buf: pointer; len: csize_t; flags: cint): ssize_t {.
    cdecl, importc: "amqp_socket_recv", dynlib: librabbitmq.}
proc amqp_socket_close*(self: ptr amqp_socket_t; force: amqp_socket_close_enum): cint {.
    cdecl, importc: "amqp_socket_close", dynlib: librabbitmq.}
proc amqp_socket_delete*(self: ptr amqp_socket_t) {.cdecl,
    importc: "amqp_socket_delete", dynlib: librabbitmq.}
proc amqp_open_socket_noblock*(hostname: cstring; portnumber: cint;
                              timeout: ptr timeval): cint {.cdecl,
    importc: "amqp_open_socket_noblock", dynlib: librabbitmq.}
proc amqp_open_socket_inner*(hostname: cstring; portnumber: cint;
                            deadline: amqp_time_t): cint {.cdecl,
    importc: "amqp_open_socket_inner", dynlib: librabbitmq.}
proc amqp_poll*(fd: cint; event: cint; deadline: amqp_time_t): cint {.cdecl,
    importc: "amqp_poll", dynlib: librabbitmq.}
proc amqp_send_method_inner*(state: amqp_connection_state_t;
                            channel: amqp_channel_t; id: amqp_method_number_t;
                            decoded: pointer; flags: cint; deadline: amqp_time_t): cint {.
    cdecl, importc: "amqp_send_method_inner", dynlib: librabbitmq.}
proc amqp_queue_frame*(state: amqp_connection_state_t; frame: ptr amqp_frame_t): cint {.
    cdecl, importc: "amqp_queue_frame", dynlib: librabbitmq.}
proc amqp_put_back_frame*(state: amqp_connection_state_t; frame: ptr amqp_frame_t): cint {.
    cdecl, importc: "amqp_put_back_frame", dynlib: librabbitmq.}
proc amqp_simple_wait_frame_on_channel*(state: amqp_connection_state_t;
                                       channel: amqp_channel_t;
                                       decoded_frame: ptr amqp_frame_t): cint {.
    cdecl, importc: "amqp_simple_wait_frame_on_channel", dynlib: librabbitmq.}
proc sasl_mechanism_in_list*(mechanisms: amqp_bytes_t;
                            `method`: amqp_sasl_method_enum): cint {.cdecl,
    importc: "sasl_mechanism_in_list", dynlib: librabbitmq.}
proc amqp_merge_capabilities*(base: ptr amqp_table_t; add: ptr amqp_table_t;
                             result: ptr amqp_table_t; pool: ptr amqp_pool_t): cint {.
    cdecl, importc: "amqp_merge_capabilities", dynlib: librabbitmq.}