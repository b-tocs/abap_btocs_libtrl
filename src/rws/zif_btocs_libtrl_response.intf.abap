interface ZIF_BTOCS_LIBTRL_RESPONSE
  public .


  interfaces ZIF_BTOCS_RWS_RESPONSE .
  interfaces ZIF_BTOCS_UTIL_BASE .

  methods GET_MAIN
    returning
      value(RO_MAIN) type ref to ZIF_BTOCS_RWS_RESPONSE .
endinterface.
