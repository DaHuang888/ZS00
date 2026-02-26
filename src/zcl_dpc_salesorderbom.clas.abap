CLASS zcl_dpc_salesorderbom DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DPC_SALESORDERBOM IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    CASE io_request->get_entity_id( ).
      WHEN 'ZI_SLSORDBOMINFOBYMATPLT'.

        IF io_request->is_data_requested( ).

          DATA: lt_data_response TYPE STANDARD TABLE OF ZI_SlsOrdBOMInfoByMatPlt.

          " Parameter
          DATA(lt_parameters) = io_request->get_parameters( ).

          " Filter
          DATA(lv_sql_filter) = io_request->get_filter( )->get_as_sql_string( ).

          "lv_sql_filter = replace( val = lv_sql_filter sub = 'TIMESTAMP' with = 'CONCAT( RBKP~CPUDT,RBKP~CPUTM )' occ = 0 case = abap_false ).

          TRY.
              DATA(lt_ranges) = io_request->get_filter( )->get_as_ranges( ).
****filter manipulation
            CATCH cx_rap_query_filter_no_range INTO data(lx_rap_query_filter_no_range)  ##NO_HANDLER.

                clear lx_rap_query_filter_no_range  ##NO_HANDLER.

              ""error handling
          ENDTRY.

          " Search
* DATA(lv_search_string) = io_request->get_search_expression( ).
*
* DATA(lv_search_sql) = |PRODUCTNAME LIKE '%{ cl_abap_dyn_prg=>escape_quotes( replace( val = lv_search_string sub = '"' with = '' occ = 0 ) ) }%'|.
*
* IF lv_sql_filter IS INITIAL.
* lv_sql_filter = lv_search_sql.
* ELSE.
* lv_sql_filter = |( { lv_sql_filter } AND { lv_search_sql } )|.
* ENDIF.
*
* DATA(lv_language) = cl_abap_context_info=>get_user_language_abap_format( ).

          " Paging
          DATA(lv_offset) = io_request->get_paging( )->get_offset( ).
          DATA(lv_page_size) = io_request->get_paging( )->get_page_size( ).
          DATA(lv_max_rows) = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_page_size ).

          " Sorting
          DATA(lt_sort_elements) = io_request->get_sort_elements( ).
          DATA(lt_sort_criteria) = VALUE string_table( FOR ls_sort_elements IN lt_sort_elements
          ( ls_sort_elements-element_name && COND #( WHEN ls_sort_elements-descending = abap_true
          THEN ' descending'
          ELSE ' ascending') ) ).
          DATA(lv_sort_string) = COND #( WHEN lt_sort_criteria IS INITIAL THEN 'primary key'
          ELSE concat_lines_of( table = lt_sort_criteria sep = ', ' ) ).


          " Requested Elements
          DATA(lt_req_elements) = io_request->get_requested_elements( ).
          DATA(lv_req_elements) = concat_lines_of( table = lt_req_elements sep = ', ' ).

          IF lv_sql_filter IS NOT INITIAL.

            SELECT Material, Plant, SalesOrder, SalesOrderItem, BillOfMaterialVariantUsage
              FROM I_SalesOrderBillOfMaterialTP_3
              WHERE (lv_sql_filter)
*          ORDER BY (lv_sort_string)
              INTO TABLE @DATA(lt_table_data).

          ELSE.

            SELECT Material, Plant, SalesOrder, SalesOrderItem, BillOfMaterialVariantUsage
              FROM I_SalesOrderBillOfMaterialTP_3
*          WHERE (lv_sql_filter)
*          ORDER BY (lv_sort_string)
              WHERE Material <> ''
              INTO TABLE @lt_table_data.

*          OFFSET @lv_offset UP TO @lv_max_rows ROWS.

          ENDIF.

          " Count of records
          IF io_request->is_total_numb_of_rec_requested( ).
            io_response->set_total_number_of_records( lines( lt_table_data ) ).
          ENDIF.

          DATA(lv_page_start) = lv_offset + 1.
          DATA(lv_page_end) = lv_offset + lv_max_rows.
          DATA(lv_total_lines) = lines( lt_table_data ).

          IF lv_page_end > lv_total_lines OR lv_max_rows = 0.
            lv_page_end = lv_total_lines.
          ENDIF.

          DATA lt_table_data_each_page LIKE lt_table_data.

          IF lt_table_data IS NOT INITIAL.
            APPEND LINES OF lt_table_data FROM lv_page_start TO lv_page_end TO lt_table_data_each_page.
          ENDIF.

          io_response->set_data( lt_table_data_each_page ).

        ENDIF.

      WHEN OTHERS.
* RAISE cx_rap_query_prov_not_impl.

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
