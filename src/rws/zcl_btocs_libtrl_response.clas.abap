class ZCL_BTOCS_LIBTRL_RESPONSE definition
  public
  inheriting from ZCL_BTOCS_RWS_RESPONSE
  create public .

public section.

  interfaces ZIF_BTOCS_LIBTRL_RESPONSE .

  methods ZIF_BTOCS_RWS_RESPONSE~GET_BINARY_AS_FILE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_LIBTRL_RESPONSE IMPLEMENTATION.


  METHOD zif_btocs_libtrl_response~get_main.
    ro_main ?= me.
  ENDMETHOD.


  METHOD zif_btocs_rws_response~get_binary_as_file.

* ------ call super
    CALL METHOD super->zif_btocs_rws_response~get_binary_as_file
      EXPORTING
        iv_filename        = iv_filename
        iv_short_filename  = iv_short_filename
        iv_detect_mimetype = iv_detect_mimetype
      RECEIVING
        rs_file            = rs_file.

* ------- prepare filename
    DATA(lo_conv_util) = zcl_btocs_factory=>create_convert_util( ).
    IF rs_file-filename IS NOT INITIAL.
      DATA(lv_dots) = lo_conv_util->get_filename_dots_count( rs_file-filename ).
      IF lv_dots > 1.
        SPLIT rs_file-filename
         AT '.'
        INTO DATA(lv_session)
             rs_file-filename.
        get_logger( )->debug( |Session { lv_session } deleted from filename: { rs_file-filename }| ).
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
