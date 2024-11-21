CLASS zcl_httpsrv_lcs DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS get_bankdetails EXPORTING et_bank TYPE zcl_srv_odata_lcs=>tyt_a_bank_detail_type.
    METHODS get_bankdetails_json RETURNING VALUE(rv_output) TYPE string
                                 RAISING
                                           cx_web_http_client_error
                                           cx_http_dest_provider_error.
ENDCLASS.



CLASS zcl_httpsrv_lcs IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.
    DATA: lt_bank TYPE zcl_srv_odata_lcs=>tyt_a_bank_detail_type.

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

  METHOD get_bankdetails.



    DATA:
      lt_business_data TYPE TABLE OF zcl_srv_odata_lcs=>tys_a_bank_detail_type,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA:
      lo_filter_factory         TYPE REF TO /iwbep/if_cp_filter_factory,
      lo_filter_node_1          TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_2          TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_root       TYPE REF TO /iwbep/if_cp_filter_node,
*      lt_range_BANK_COUNTRY TYPE RANGE OF .
      lt_range_BANK_INTERNAL_ID TYPE RANGE OF bankk.



    TRY.
        " Create http client
*DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                             comm_scenario  = '<Comm Scenario>'
*                                             comm_system_id = '<Comm System Id>'
*                                             service_id     = '<Service Id>' ).
*lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZSRV_ODATA_LCS'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   =  '/sap/bc/http/sap/ZHTTPSRV_LCS' ).

        ASSERT lo_http_client IS BOUND.


        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'A_BANK_DETAIL' )->create_request_for_read( ).

        " Create the filter tree
*lo_filter_factory = lo_request->create_filter_factory( ).
*
*lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'BANK_COUNTRY'
*                                                        it_range             = lt_range_BANK_COUNTRY ).
        lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'BANK_INTERNAL_ID'
                                                                it_range             = lt_range_BANK_INTERNAL_ID ).

*lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).
*lo_request->set_filter( lo_filter_node_root ).

        lo_request->set_top( 50 )->set_skip( 0 ).

        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.


    ENDTRY.

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
  METHOD if_oo_adt_classrun~main.

    TRY.
        DATA(lv_output) = get_bankdetails(  ).
        out->write( lv_output ).
      CATCH cx_root INTO DATA(lo_cx).
        out->write( lo_cx->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.

  ENDMETHOD.

ENDCLASS.

