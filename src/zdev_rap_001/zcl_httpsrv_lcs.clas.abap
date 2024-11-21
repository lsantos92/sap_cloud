CLASS zcl_httpsrv_lcs DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS get_bankdetails_json RETURNING VALUE(rv_output) TYPE string
                                 RAISING
                                           cx_web_http_client_error
                                           cx_http_dest_provider_error.
ENDCLASS.



CLASS zcl_httpsrv_lcs IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    DATA(lt_params) = request->get_form_fields( ).

    CHECK lt_params IS NOT INITIAL.
    DATA(ls_params) = lt_params[ name = 'cmd' ].

    IF line_exists( lt_params[ name = 'cmd' value = 'timestamp' ] ).

      response->set_text( |HTTP Service Application executed by {
                                 cl_abap_context_info=>get_user_technical_name( ) } | &&
                                  | on { cl_abap_context_info=>get_system_date( ) DATE = ENVIRONMENT } | &&
                                  | at { cl_abap_context_info=>get_system_time( ) TIME = ENVIRONMENT } | ).

 elsEIF line_exists( lt_params[ name = 'cmd' value = 'hello' ] ).
      response->set_text( |Hello World| ).


    ELSEIF line_exists( lt_params[ name = 'cmd' value = 'getjson' ] ) .

      response->set_content_type( 'application/json' ).
      TRY.
          response->set_text( get_bankdetails_json(  ) ).
        CATCH cx_root INTO DATA(lo_root).
          DATA(lv_cx) = lo_root->get_text( ).
      ENDTRY.



    ELSE.
      response->set_status( i_code = 400 i_reason = 'Bad request' ).
    ENDIF.



  ENDMETHOD.


  METHOD get_bankdetails_json.
    DATA: lv_url TYPE string VALUE 'https://sandbox.api.sap.com/s4hanacloud/sap/opu/odata/sap/'.
    DATA: lo_http_client TYPE REF TO  if_web_http_client.

    lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
              i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).

    DATA(lo_request) = lo_http_client->get_http_request( ).

    lo_request->set_header_fields( VALUE #(
       (  name = 'Content-Type' value = 'application/json' )
       (  name = 'Accept' value = 'application/json' )
       (  name = 'APIKey' value =  'rVxRYWpRlG8SP3rxvI6grkBxx4XYfY5Z' ) ) ).  "<<-- API KEY!

    lo_request->set_uri_path(
       i_uri_path = lv_url && 'API_BANKDETAIL_SRV/A_BankDetail?$top=25&$format=json'  ).

    TRY.
        DATA(lv_response) = lo_http_client->execute( i_method = if_web_http_client=>get )->get_text(  ).
      CATCH cx_web_http_client_error.
    ENDTRY.

    rv_output = lv_response.

  ENDMETHOD.
ENDCLASS.

