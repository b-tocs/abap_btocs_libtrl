interface ZIF_BTOCS_LIBTRL_C
  public .


  constants VERSION type STRING value 'V20240111' ##NO_TEXT.
  constants RELEASE type STRING value '0.1.1' ##NO_TEXT.
  constants HOMEPAGE type STRING value 'https://b-tocs.org' ##NO_TEXT.
  constants REPOSITORY type STRING value 'https://github.com/b-tocs/abap_btocs_libtrl' ##NO_TEXT.
  constants AUTHOR type STRING value 'mdjoerg@b-tocs.org' ##NO_TEXT.
  constants DEPENDING type STRING value 'https://github.com/b-tocs/abap_btocs_core' ##NO_TEXT.
  constants:
    BEGIN OF api_path,
               translate TYPE string VALUE '/translate',
               languages TYPE string VALUE '/languages',
               detect    TYPE string VALUE '/detect',
             END OF api_path .
endinterface.
