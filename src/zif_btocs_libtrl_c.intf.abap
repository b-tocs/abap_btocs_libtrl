interface ZIF_BTOCS_LIBTRL_C
  public .


  constants VERSION type STRING value 'V20240122' ##NO_TEXT.
  constants RELEASE type STRING value '0.3.1' ##NO_TEXT.
  constants HOMEPAGE type STRING value 'https://b-tocs.org' ##NO_TEXT.
  constants REPOSITORY type STRING value 'https://github.com/b-tocs/abap_btocs_libtrl' ##NO_TEXT.
  constants AUTHOR type STRING value 'mdjoerg@b-tocs.org' ##NO_TEXT.
  constants DEPENDING type STRING value 'https://github.com/b-tocs/abap_btocs_core:0.3.0' ##NO_TEXT.
  constants:
    BEGIN OF api_path,
      translate      TYPE string VALUE '/translate',
      translate_file TYPE string VALUE '/translate_file',
      languages      TYPE string VALUE '/languages',
      detect         TYPE string VALUE '/detect',
    END OF api_path .
endinterface.
