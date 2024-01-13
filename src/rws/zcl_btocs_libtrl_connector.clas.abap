CLASS zcl_btocs_libtrl_connector DEFINITION
  PUBLIC
  INHERITING FROM zcl_btocs_rws_connector
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_btocs_libtrl_c .
    INTERFACES zif_btocs_libtrl_connector .

    CLASS-METHODS create
      RETURNING
        VALUE(ro_instance) TYPE REF TO zif_btocs_libtrl_connector .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BTOCS_LIBTRL_CONNECTOR IMPLEMENTATION.


  METHOD create.
    ro_instance ?= zcl_btocs_factory=>create_instance( 'ZIF_BTOCS_LIBTRL_CONNECTOR' ).
  ENDMETHOD.


  METHOD zif_btocs_libtrl_connector~api_languages.

* ============ execute via api path
    DATA(lo_response) = zif_btocs_libtrl_connector~new_response( ).
    ro_response ?= zif_btocs_libtrl_connector~execute(
     iv_api_path = zif_btocs_libtrl_c=>api_path-languages
     io_response = lo_response
     iv_method   = 'GET'
    ).

  ENDMETHOD.


  METHOD zif_btocs_libtrl_connector~api_translate.

* ========== init
    DATA(ls_params) = is_params.
    ro_response     = zcl_btocs_factory=>create_web_service_response( ).
    ro_response->set_logger( get_logger( ) ).


* =========== checks and preparations
    IF zif_btocs_libtrl_connector~is_initialized( ) EQ abap_false.
      ro_response->set_reason( |connector is not initialized| ).
      RETURN.
    ENDIF.

    IF ls_params-q IS INITIAL.
      ro_response->set_reason( |text to translate is missing| ).
      RETURN.
    ENDIF.

    IF ls_params-target IS INITIAL.
      ro_response->set_reason( |target language is missing| ).
      RETURN.
    ENDIF.

    IF ls_params-source IS INITIAL.
      ls_params-source = 'auto'.
      get_logger( )->warning( |source language is missing. try auto detect mode| ).
    ENDIF.


* =========== get client and prepare call

    DATA(lv_api_key) = COND #( WHEN ls_params-api_key IS NOT INITIAL
                               THEN ls_params-api_key
                               ELSE zif_btocs_libtrl_connector~get_client( )->get_api_key( ) ).


* =========== fill form based params
    DATA(lo_request) = zif_btocs_libtrl_connector~new_request( ). " from current client
    lo_request->set_form_type_urlencoded( ).

    lo_request->add_form_field(
      iv_name = 'q'
      iv_value = ls_params-q
    ).

    lo_request->add_form_field(
      iv_name = 'source'
      iv_value = ls_params-source
    ).

    lo_request->add_form_field(
      iv_name = 'target'
      iv_value = ls_params-target
    ).

    lo_request->add_form_field(
      iv_name = 'format'
      iv_value = ls_params-format
    ).

    IF lv_api_key IS NOT INITIAL.
      lo_request->add_form_field(
        iv_name = 'api_key'
        iv_value = lv_api_key
      ).
    ENDIF.

* ============ execute via api path
    DATA(lo_response) = zif_btocs_libtrl_connector~new_response( ).
    ro_response ?= zif_btocs_libtrl_connector~execute(
     iv_api_path = zif_btocs_libtrl_c=>api_path-translate
     io_response = lo_response
    ).

  ENDMETHOD.


  METHOD zif_btocs_libtrl_connector~new_response.
    ro_response ?= zcl_btocs_factory=>create_instance( 'ZIF_BTOCS_LIBTRL_RESPONSE' ).
    ro_response->get_main( )->set_logger( get_logger( ) ).
  ENDMETHOD.


  METHOD zif_btocs_libtrl_connector~api_detect.

* ========== init
    DATA(ls_params) = is_params.
    ro_response     = zcl_btocs_factory=>create_web_service_response( ).
    ro_response->set_logger( get_logger( ) ).


* =========== checks and preparations
    IF zif_btocs_libtrl_connector~is_initialized( ) EQ abap_false.
      ro_response->set_reason( |connector is not initialized| ).
      RETURN.
    ENDIF.

    IF ls_params-q IS INITIAL.
      ro_response->set_reason( |text to translate is missing| ).
      RETURN.
    ENDIF.

* =========== get client and prepare call
    DATA(lv_api_key) = COND #( WHEN ls_params-api_key IS NOT INITIAL
                               THEN ls_params-api_key
                               ELSE zif_btocs_libtrl_connector~get_client( )->get_api_key( ) ).


* =========== fill form based params
    DATA(lo_request) = zif_btocs_libtrl_connector~new_request( ). " from current client
    lo_request->set_form_type_urlencoded( ).

    lo_request->add_form_field(
      iv_name = 'q'
      iv_value = ls_params-q
    ).

    IF lv_api_key IS NOT INITIAL.
      lo_request->add_form_field(
        iv_name = 'api_key'
        iv_value = lv_api_key
      ).
    ENDIF.

* ============ execute via api path
    DATA(lo_response) = zif_btocs_libtrl_connector~new_response( ).
    ro_response ?= zif_btocs_libtrl_connector~execute(
     iv_api_path = zif_btocs_libtrl_c=>api_path-detect
     io_response = lo_response
    ).
  ENDMETHOD.


  METHOD zif_btocs_libtrl_connector~api_translate_file.


* ========== init
    DATA(ls_params) = is_params.
    ro_response     = zcl_btocs_factory=>create_web_service_response( ).
    ro_response->set_logger( get_logger( ) ).

    DATA(lo_gui_util) = zcl_btocs_factory=>create_gui_util( ).
    lo_gui_util->set_logger( get_logger( ) ).

    DATA(lo_conv_util) = zcl_btocs_factory=>create_convert_util( ).
    lo_conv_util->set_logger( get_logger( ) ).


* =========== get file data
    IF ls_params-binary IS INITIAL.
*   check input
      IF ls_params-filename IS INITIAL.
        ro_response->set_reason( |no content - binary or filename| ).
        RETURN.
      ENDIF.

*   get file from
      ls_params-binary = lo_gui_util->gui_upload_bin(
        EXPORTING
          iv_filename  = ls_params-filename
        IMPORTING
          ev_filename  = ls_params-filename
      ).

*   check
      IF ls_params-binary IS INITIAL.
        ro_response->set_reason( |upload from gui client failed: { is_params-filename }| ).
        RETURN.
      ENDIF.

*   mimetype
      IF ls_params-mimetype IS INITIAL.
        ls_params-mimetype = lo_gui_util->get_mimetype_from_filename( ls_params-filename ).
      ENDIF.

    ENDIF.

** ----- final check
*    DATA(lv_base64) = lo_conv_util->convert_xstring_to_base64(
*      iv_binary   = ls_params-binary
*      iv_filename = ls_params-filename
*      iv_mimetype = ls_params-mimetype
*    ).


* =========== checks and preparations
    IF zif_btocs_libtrl_connector~is_initialized( ) EQ abap_false.
      ro_response->set_reason( |connector is not initialized| ).
      RETURN.
    ENDIF.

    IF ls_params-binary IS INITIAL.
      ro_response->set_reason( |file to translate is missing| ).
      RETURN.
    ENDIF.

    IF ls_params-target IS INITIAL.
      ro_response->set_reason( |target language is missing| ).
      RETURN.
    ENDIF.

    IF ls_params-source IS INITIAL.
      ls_params-source = 'auto'.
      get_logger( )->warning( |source language is missing. try auto detect mode| ).
    ENDIF.


* =========== get client and prepare call
    DATA(lv_api_key) = COND #( WHEN ls_params-api_key IS NOT INITIAL
                               THEN ls_params-api_key
                               ELSE zif_btocs_libtrl_connector~get_client( )->get_api_key( ) ).


* =========== fill form based params
    DATA(lo_request) = zif_btocs_libtrl_connector~new_request( ). " from current client

    lo_request->set_form_type_multipart( ).

    lo_request->add_form_field_file(
      iv_name = 'file'
      iv_binary = ls_params-binary
      iv_filename = ls_params-filename
      iv_content_type = ls_params-mimetype
    ).

    lo_request->add_form_field(
      iv_name = 'source'
      iv_value = ls_params-source
    ).

    lo_request->add_form_field(
      iv_name = 'target'
      iv_value = ls_params-target
    ).


    IF lv_api_key IS NOT INITIAL.
      lo_request->add_form_field(
        iv_name = 'api_key'
        iv_value = lv_api_key
      ).
    ENDIF.

* ============ execute via api path
    DATA(lo_response) = zif_btocs_libtrl_connector~new_response( ).
    ro_response ?= zif_btocs_libtrl_connector~execute(
     iv_api_path = zif_btocs_libtrl_c=>api_path-translate_file
     io_response = lo_response
    ).


  ENDMETHOD.
ENDCLASS.
