INTERFACE zif_btocs_libtrl_c
  PUBLIC .

  CONSTANTS version     TYPE string VALUE 'V20240111' ##NO_TEXT.
  CONSTANTS release     TYPE string VALUE '0.1.0' ##NO_TEXT.
  CONSTANTS homepage    TYPE string VALUE 'https://b-tocs.org' ##NO_TEXT.
  CONSTANTS repository  TYPE string VALUE 'https://github.com/b-tocs/abap_btocs_libtrl' ##NO_TEXT.
  CONSTANTS author      TYPE string VALUE 'mdjoerg@b-tocs.org' ##NO_TEXT.
  CONSTANTS depending   TYPE string VALUE 'https://github.com/b-tocs/abap_btocs_core' ##NO_TEXT.

  CONSTANTS: BEGIN OF api_path,
               translate TYPE string VALUE '/translate',
               languages TYPE string VALUE '/languages',
             END OF api_path.

ENDINTERFACE.
