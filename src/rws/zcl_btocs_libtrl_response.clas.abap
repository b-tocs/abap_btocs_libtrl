class ZCL_BTOCS_LIBTRL_RESPONSE definition
  public
  inheriting from ZCL_BTOCS_RWS_RESPONSE
  create public .

public section.

  interfaces ZIF_BTOCS_LIBTRL_RESPONSE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_LIBTRL_RESPONSE IMPLEMENTATION.


  METHOD zif_btocs_libtrl_response~get_main.
    ro_main ?= me.
  ENDMETHOD.
ENDCLASS.
