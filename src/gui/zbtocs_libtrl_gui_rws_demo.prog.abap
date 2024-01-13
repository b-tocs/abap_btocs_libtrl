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
PARAMETERS: p_txt TYPE string LOWER CASE.
PARAMETERS: p_fil TYPE zbtocs_filename LOWER CASE.
SELECTION-SCREEN: ULINE.
PARAMETERS: p_fmt TYPE string LOWER CASE DEFAULT 'Open Source ist eine coole Sache'.
PARAMETERS: p_src TYPE string LOWER CASE DEFAULT 'de'.
PARAMETERS: p_trg TYPE string LOWER CASE DEFAULT 'en'.
PARAMETERS: p_key TYPE string LOWER CASE.

SELECTION-SCREEN: ULINE.
PARAMETERS: p_otl RADIOBUTTON GROUP opti DEFAULT 'X'.   " test translate
PARAMETERS: p_ogl RADIOBUTTON GROUP opti.               " get languages
PARAMETERS: p_otd RADIOBUTTON GROUP opti.               " test detect language
PARAMETERS: p_otf RADIOBUTTON GROUP opti.               " translate file
SELECTION-SCREEN: ULINE.
PARAMETERS: p_trace AS CHECKBOX TYPE zbtocs_flag_display_trace DEFAULT 'X'.


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
* ---------- process options
    DATA lo_response TYPE REF TO zif_btocs_rws_response.
    CASE 'X'.
      WHEN p_otl. " translate
        lo_response = lo_connector->api_translate( VALUE zbtocs_libtrl_s_translate_par(
            q       = p_txt
            source  = p_src
            target  = p_trg
            format  = p_fmt
            api_key = p_key
        ) ).
      WHEN p_otf. " translate file
        lo_response = lo_connector->api_translate_file( is_params =  VALUE zbtocs_libtrl_s_transfile_par(
            filename  = p_fil
            source    = p_src
            target    = p_trg
            api_key   = p_key
        ) ).
      WHEN p_ogl. " languages
        lo_response = lo_connector->api_languages( ).
      WHEN p_otd.
        lo_response = lo_connector->api_detect( VALUE zbtocs_libtrl_s_detect_par(
            q       = p_txt
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
  DATA(lt_msg) = lo_logger->get_messages( ).
  lo_connector->destroy( ).


END-OF-SELECTION.


* ------------ display trace
  IF p_trace = abap_true
    AND lt_msg[] IS NOT INITIAL.
    cl_demo_output=>begin_section( title = |Protocol| ).
    cl_demo_output=>write_data(
      value   = lt_msg
      name    = 'Trace'
    ).
    cl_demo_output=>end_section( ).
  ENDIF.

* ------------ display data
  cl_demo_output=>display( ).
