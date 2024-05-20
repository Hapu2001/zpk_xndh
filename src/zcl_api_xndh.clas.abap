CLASS ZCL_API_XNDH DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
      METHOD_POST TYPE STRING VALUE 'POST',
      METHOD_GET  TYPE STRING VALUE 'GET',
      GC_FAIL     TYPE STRING  VALUE '1',
      GC_SUCCESS  TYPE STRING  VALUE '0'.

    INTERFACES  IF_HTTP_SERVICE_EXTENSION.
  PROTECTED SECTION.
  PRIVATE SECTION.
*TYPES
    TYPES: BEGIN OF GTY_REQUEST,
             VBELN           TYPE STRING,
             PRODUCT         TYPE STRING,
             ARKTX           TYPE STRING,
             KWMENG          TYPE STRING,
             VRKME           TYPE STRING,
             ERDAT           TYPE STRING,
             VDATU           TYPE STRING,
             ZNBDSX          TYPE STRING,
             ZNHT            TYPE STRING,
             ZLCS            TYPE STRING,
             LAST_CHANGED_BY TYPE STRING,
             LAST_CHANGED_AT TYPE STRING,
           END OF GTY_REQUEST.

    DATA: REQUEST_METHOD TYPE STRING,
          REQUEST_BODY   TYPE STRING,
          REQUEST_DATA   TYPE GTY_REQUEST.
*TABLE
    DATA: GT_REQUEST TYPE TABLE OF GTY_REQUEST.
*STRUCTURE
    DATA: GS_RETURN TYPE ZST_XNDH_RESPONSE.
    METHODS CHECK_DATA.
    METHODS PROCESS_DATA.

ENDCLASS.



CLASS ZCL_API_XNDH IMPLEMENTATION.


  METHOD CHECK_DATA.

  ENDMETHOD.


  METHOD IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.
    REQUEST_BODY   = REQUEST->GET_TEXT(  ).
    REQUEST_METHOD = REQUEST->GET_METHOD(  ).
    CASE REQUEST_METHOD.
      WHEN METHOD_POST.
        TRY.
            XCO_CP_JSON=>DATA->FROM_STRING( REQUEST_BODY )->APPLY( IT_TRANSFORMATIONS =
        VALUE #( ( XCO_CP_JSON=>TRANSFORMATION->CAMEL_CASE_TO_UNDERSCORE )
                 ( XCO_CP_JSON=>TRANSFORMATION->BOOLEAN_TO_ABAP_BOOL ) )
        )->WRITE_TO( REF #( REQUEST_DATA ) ).
            APPEND REQUEST_DATA TO  GT_REQUEST.

            CHECK_DATA( ) .
            IF GS_RETURN-RESULT <> GC_FAIL.
              PROCESS_DATA(  ).
            ENDIF.

            DATA(LV_JSON_STRING) = XCO_CP_JSON=>DATA->FROM_ABAP( GS_RETURN )->APPLY( VALUE #(
                    ( XCO_CP_JSON=>TRANSFORMATION->UNDERSCORE_TO_PASCAL_CASE ) ) )->TO_STRING( ).

            RESPONSE->SET_TEXT(  I_TEXT = LV_JSON_STRING ).
          CATCH CX_ROOT INTO DATA(LX_ROOT).
            RESPONSE->SET_TEXT( 'Error' ).
        ENDTRY.
    ENDCASE.
  ENDMETHOD.


  METHOD PROCESS_DATA.
    DATA: LS_UPDATE TYPE ZTB_PP_XNDH,
          LT_UPDATE TYPE TABLE OF  ZTB_PP_XNDH.

    LOOP AT GT_REQUEST INTO DATA(LS_REQUEST).
      LS_UPDATE-VBELN           = LS_REQUEST-VBELN.
      LS_UPDATE-ZNBDSX          = LS_REQUEST-ZNBDSX.
      LS_UPDATE-ZNHT            = LS_REQUEST-ZNBDSX.
      LS_UPDATE-ZLCS            = LS_REQUEST-ZNBDSX.
      LS_UPDATE-LAST_CHANGED_BY = LS_REQUEST-LAST_CHANGED_BY.
      LS_UPDATE-LAST_CHANGED_BY = CL_ABAP_CONTEXT_INFO=>GET_SYSTEM_TIME(  ).
      APPEND LS_UPDATE TO LT_UPDATE.
    ENDLOOP.

    MODIFY ZTB_PP_XNDH FROM TABLE @LT_UPDATE.
    IF SY-SUBRC = 0.
      COMMIT WORK AND WAIT.
      APPEND |Update ZTB_PP_XNDH thành công| TO GS_RETURN-MESSAGE.
      GS_RETURN-RESULT = GC_SUCCESS.
    ELSE.
      GS_RETURN-RESULT = GC_FAIL.
      APPEND |No error| TO GS_RETURN-MESSAGE.
    ENDIF.

  ENDMETHOD.
ENDCLASS.