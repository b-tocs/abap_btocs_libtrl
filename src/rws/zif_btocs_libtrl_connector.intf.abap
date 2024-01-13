interface ZIF_BTOCS_LIBTRL_CONNECTOR
  public .


  interfaces ZIF_BTOCS_RWS_CONNECTOR .
  interfaces ZIF_BTOCS_UTIL_BASE .

  aliases DESTROY
    for ZIF_BTOCS_RWS_CONNECTOR~DESTROY .
  aliases EXECUTE
    for ZIF_BTOCS_RWS_CONNECTOR~EXECUTE .
  aliases GET_CLIENT
    for ZIF_BTOCS_RWS_CONNECTOR~GET_CLIENT .
  aliases GET_LOGGER
    for ZIF_BTOCS_RWS_CONNECTOR~GET_LOGGER .
  aliases IS_INITIALIZED
    for ZIF_BTOCS_RWS_CONNECTOR~IS_INITIALIZED .
  aliases IS_LOGGER_EXTERNAL
    for ZIF_BTOCS_RWS_CONNECTOR~IS_LOGGER_EXTERNAL .
  aliases NEW_REQUEST
    for ZIF_BTOCS_RWS_CONNECTOR~NEW_REQUEST .
  aliases SET_ENDPOINT
    for ZIF_BTOCS_RWS_CONNECTOR~SET_ENDPOINT .
  aliases SET_LOGGER
    for ZIF_BTOCS_RWS_CONNECTOR~SET_LOGGER .

  methods NEW_RESPONSE
    returning
      value(RO_RESPONSE) type ref to ZIF_BTOCS_LIBTRL_RESPONSE .
  methods API_TRANSLATE
    importing
      !IS_PARAMS type ZBTOCS_LIBTRL_S_TRANSLATE_PAR
    returning
      value(RO_RESPONSE) type ref to ZIF_BTOCS_RWS_RESPONSE .
  methods API_DETECT
    importing
      !IS_PARAMS type ZBTOCS_LIBTRL_S_DETECT_PAR
    returning
      value(RO_RESPONSE) type ref to ZIF_BTOCS_RWS_RESPONSE .
  methods API_LANGUAGES
    returning
      value(RO_RESPONSE) type ref to ZIF_BTOCS_RWS_RESPONSE .
  methods API_TRANSLATE_FILE
    importing
      !IS_PARAMS type ZBTOCS_LIBTRL_S_TRANSFILE_PAR
    returning
      value(RO_RESPONSE) type ref to ZIF_BTOCS_RWS_RESPONSE .
endinterface.
