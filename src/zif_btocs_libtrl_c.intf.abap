INTERFACE zif_btocs_libtrl_c
  PUBLIC .

* ============== version information
  CONSTANTS version TYPE string VALUE 'V20240122' ##NO_TEXT.
  CONSTANTS release TYPE string VALUE '0.3.1' ##NO_TEXT.
  CONSTANTS homepage TYPE string VALUE 'https://b-tocs.org' ##NO_TEXT.
  CONSTANTS repository TYPE string VALUE 'https://github.com/b-tocs/abap_btocs_libtrl' ##NO_TEXT.
  CONSTANTS author TYPE string VALUE 'mdjoerg@b-tocs.org' ##NO_TEXT.
  CONSTANTS depending TYPE string VALUE 'https://github.com/b-tocs/abap_btocs_core:0.3.0' ##NO_TEXT.

* ============== api path
  CONSTANTS:
    BEGIN OF api_path,
      translate      TYPE string VALUE '/translate',
      translate_file TYPE string VALUE '/translate_file',
      languages      TYPE string VALUE '/languages',
      detect         TYPE string VALUE '/detect',
    END OF api_path .

* ============== JSON keys
  CONSTANTS:
    BEGIN OF c_json_key,
      translated_text     TYPE string VALUE 'translatedText',
      translated_file_url TYPE string VALUE 'translatedFileUrl',
    END OF c_json_key .
ENDINTERFACE.
