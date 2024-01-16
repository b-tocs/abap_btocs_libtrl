*&---------------------------------------------------------------------*
*& Report ZBTOCS_LIBTRL_GUI_RWS_DEMO
*&---------------------------------------------------------------------*
*& demo how to use the LibreTranslate Connector
*& Repository & Docs: https://github.com/b-tocs/abap_btocs_libtrl
*&---------------------------------------------------------------------*
REPORT zbtocs_libtrl_gui_rws_demo.

"https://answers.sap.com/questions/7174658/index.html

* ------- interface
PARAMETERS: p_rfc TYPE rfcdest OBLIGATORY.
PARAMETERS: p_prf TYPE zbtocs_rws_profile.
SELECTION-SCREEN: ULINE.
PARAMETERS: p_txt TYPE zbtocs_longtext LOWER CASE.
PARAMETERS: p_fil TYPE zbtocs_filename LOWER CASE.
SELECTION-SCREEN: ULINE.
PARAMETERS: p_fmt TYPE string LOWER CASE DEFAULT 'text'.
PARAMETERS: p_src TYPE zbtocs_language_target DEFAULT 'de'.
PARAMETERS: p_trg TYPE zbtocs_language_target DEFAULT 'en'.
PARAMETERS: p_key TYPE zbtocs_api_key LOWER CASE.

SELECTION-SCREEN: ULINE.
PARAMETERS: p_otl RADIOBUTTON GROUP opti DEFAULT 'X'.   " test translate
PARAMETERS: p_otf RADIOBUTTON GROUP opti.               " translate file
PARAMETERS: p_otd RADIOBUTTON GROUP opti.               " test detect language
PARAMETERS: p_ogl RADIOBUTTON GROUP opti.               " get languages
SELECTION-SCREEN: ULINE.
PARAMETERS: p_clipb AS CHECKBOX TYPE zbtocs_flag_clipboard_input  DEFAULT 'X'. " get the input from clipboard
PARAMETERS: p_downl AS CHECKBOX TYPE zbtocs_flag_download         DEFAULT 'X'. " download translated file
PARAMETERS: p_proto AS CHECKBOX TYPE zbtocs_flag_protocol         DEFAULT 'X'. " show protocol
PARAMETERS: p_trace AS CHECKBOX TYPE zbtocs_flag_display_trace    DEFAULT ' '. " show protocol with trace


INITIALIZATION.

  DATA(lo_gui_utils) = zcl_btocs_factory=>create_gui_util( ).
  DATA(lo_logger)    = lo_gui_utils->get_logger( ).

* --------- init client
  DATA(lo_connector) = zcl_btocs_libtrl_connector=>create( ).
  lo_connector->set_logger( lo_logger ).


* --------------------- F4 Help
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fil.
  lo_gui_utils->f4_get_filename_open(
    CHANGING
      cv_filename     = p_fil
  ).


START-OF-SELECTION.


* ---------- set endpoint
  IF lo_connector->set_endpoint(
    iv_rfc     = p_rfc
    iv_profile = p_prf
  ) EQ abap_true.
* --------- get input
* ---------- user input?
    DATA(lv_txt) = lo_gui_utils->get_input_with_clipboard(
        iv_current   = p_txt
        iv_clipboard = abap_true
        iv_longtext  = abap_true
    ).


* ---------- process options
    DATA lo_response TYPE REF TO zif_btocs_rws_response.
    CASE 'X'.
      WHEN p_otl. " translate
        DATA(lv_translated_text) = ||.
        lo_response = lo_connector->api_translate(
          EXPORTING
            is_params = VALUE zbtocs_libtrl_s_translate_par(
              q             = lv_txt
              source        = p_src
              target        = p_trg
              input_format  = p_fmt
              api_key       = p_key
          )
          iv_parse = abap_true
          IMPORTING
            ev_translated_text = lv_translated_text
        ).

        IF lv_translated_text IS NOT INITIAL.
          cl_demo_output=>begin_section( title = |Result| ).
          cl_demo_output=>write_text( text = |Translated Text: { lv_translated_text }| ).
          cl_demo_output=>end_section( ).
        ENDIF.

      WHEN p_otf. " translate file
        DATA(ls_par_file) = VALUE zbtocs_libtrl_s_transfile_par(
            source    = p_src
            target    = p_trg
            api_key   = p_key
        ).

        IF lo_gui_utils->get_upload(
          EXPORTING
            iv_filename     = p_fil
          IMPORTING
            ev_filename     = ls_par_file-filename
            ev_content_type = ls_par_file-mimetype
            ev_binary       = ls_par_file-binary
        ) EQ abap_false.
          lo_logger->error( |file missing| ).
        ELSE.
          DATA(lv_file_url) = ||.
          DATA(ls_file_data) = VALUE zbtocs_s_file_data( ).

          lo_response = lo_connector->api_translate_file(
            EXPORTING
              is_params = ls_par_file
              iv_parse  = abap_true
              iv_download = abap_true
            IMPORTING
              ev_file_url = lv_file_url
              es_file_data = ls_file_data
           ).

          IF lv_file_url IS NOT INITIAL.
            cl_demo_output=>begin_section( title = |Result| ).
            cl_demo_output=>write_text( text = |Translated File is available: { lv_file_url }| ).

            IF p_downl EQ abap_true
              AND ls_file_data IS NOT INITIAL.
              DATA(lv_local_file) = ||.
              IF lo_gui_utils->gui_execute_file_locally(
                EXPORTING
                  is_file_data       = ls_file_data                 " data of an file
                  iv_wait_and_delete = abap_true
                  iv_workdir         = abap_false
                  iv_maximized       = abap_false
                IMPORTING
                  ev_filename        = lv_local_file
              ) EQ abap_true.
                cl_demo_output=>write_text( text = |Local Filename: { lv_local_file }| ).
                cl_demo_output=>write_text( text = |Local Mimetype: { ls_file_data-mimetype }| ).
              ELSE.
                cl_demo_output=>write_text( text = |Error opening filename: { ls_file_data-filename }| ).
              ENDIF.
              cl_demo_output=>end_section( ).

            ENDIF.

          ENDIF.
        ENDIF.
      WHEN p_ogl. " languages
        lo_response = lo_connector->api_languages( ).
      WHEN p_otd.
        lo_response = lo_connector->api_detect( VALUE zbtocs_libtrl_s_detect_par(
            q       = lv_txt
            api_key = p_key
        ) ).
      WHEN OTHERS.
        lo_logger->error( |invalid option or not implemented yet| ).
    ENDCASE.

* ------------ check response
    IF lo_response IS INITIAL.
      lo_logger->error( |invalid response detected| ).
    ELSE.
* ------------ create status results
      DATA(lv_status) = lo_response->get_status_code( ).
      DATA(lv_reason) = lo_response->get_reason( ).

      cl_demo_output=>begin_section( title = |HTTP Request Result| ).
      cl_demo_output=>write_text( text = |HTTP Status Code: { lv_status }| ).
      cl_demo_output=>write_text( text = |HTTP Reason Text: { lv_reason }| ).
      cl_demo_output=>end_section( ).

* ------------ create content results
      DATA(lv_response) = lo_response->get_content( ).
      DATA(lv_conttype) = lo_response->get_content_type( ).

      cl_demo_output=>begin_section( title = |Response| ).
      cl_demo_output=>write_text( text = |Content-Type: { lv_conttype }| ).
      cl_demo_output=>write_html( lv_response ).
      cl_demo_output=>end_section( ).

    ENDIF.
  ENDIF.

* ------------ cleanup
  DATA(lt_msg) = lo_logger->get_messages(
                   iv_no_trace      = COND #( WHEN p_trace EQ abap_true
                                              THEN abap_false
                                              ELSE abap_true )
                 ).
  lo_connector->destroy( ).


END-OF-SELECTION.


* ------------ display trace
  IF p_proto = abap_true
    AND lt_msg[] IS NOT INITIAL.
    cl_demo_output=>begin_section( title = |Protocol| ).
    cl_demo_output=>write_data(
      value   = lt_msg
      name    = 'Messages'
    ).
    cl_demo_output=>end_section( ).
  ENDIF.

* ------------ display data
  cl_demo_output=>display( ).
