CLASS lcl_local_event_matbomitmadd DEFINITION INHERITING FROM cl_abap_behavior_event_handler.

  PRIVATE SECTION.

    METHODS consume_created FOR ENTITY EVENT created_instances FOR ZMaterialBOMItemAdd~created.

ENDCLASS.

CLASS lcl_local_event_matbomitmadd IMPLEMENTATION.

  METHOD consume_created.


    CHECK 1 = 2.

    MODIFY ENTITIES OF zi_materialbomitemaddtp
          ENTITY ZMaterialBOMItemAdd
    DELETE FROM VALUE #( ( BillOfMaterial = created_instances[ 1 ]-%key-BillOfMaterial
                           BillOfMaterialCategory = created_instances[ 1 ]-%key-BillOfMaterialCategory
                           BillOfMaterialVariant = created_instances[ 1 ]-%key-BillOfMaterialVariant
                           BillOfMaterialVersion = created_instances[ 1 ]-%key-BillOfMaterialVersion
                           BillOfMaterialItemNodeNumber = created_instances[ 1 ]-%key-BillOfMaterialItemNodeNumber
                           HeaderChangeDocument = created_instances[ 1 ]-%key-HeaderChangeDocument
                           Material = created_instances[ 1 ]-%key-Material
                           Plant = created_instances[ 1 ]-%key-Plant ) )
        MAPPED DATA(ls_mapped)
        FAILED DATA(ls_failed)
        REPORTED DATA(ls_reported).

*    COMMIT ENTITIES BEGIN RESPONSE OF zi_materialbomitemaddtp.
*
*    LOOP AT ls_mapped-zmaterialbomitemadd ASSIGNING FIELD-SYMBOL(<fs_zmaterialbomitemadd>).
*
*      CONVERT KEY OF zi_materialbomitemaddtp FROM <fs_zmaterialbomitemadd>-%pid TO FINAL(lv_root_key).
*
*    ENDLOOP.
*
*    COMMIT ENTITIES END.

    MODIFY ENTITIES OF I_SalesOrderBillOfMaterialTP_2 PRIVILEGED
      ENTITY salesbillofmaterial
      UPDATE SET FIELDS
      WITH VALUE #( ( %key-BillOfMaterialCategory = 'K'"ls_entity-BillOfMaterialCategory
                      %key-BillOfMaterial = '00000259'
                      %key-BillOfMaterialVariant = '01'
                      %key-EngineeringChangeDocument = ''"ls_entity-EngineeringChangeDocument
                      %key-Material = 'SD45E01019'
                      %key-Plant = '8520'
                      %data-BOMIsToBeDeleted = 'X'
                      %data-BOMHeaderQuantityInBaseUnit = '10'
                      %control-BOMIsToBeDeleted = if_abap_behv=>mk-on
                      %control-BOMHeaderQuantityInBaseUnit = if_abap_behv=>mk-on  ) )
        MAPPED DATA(ls_bom_h_u_mapped)
        FAILED DATA(ls_bom_h_u_failed)
        REPORTED DATA(ls_bom_h_u_reported).


* 由于草稿实例锁定等临时问题，本地事件可能无法立即执行成功。自定义异常继承CX_RAP_EVENT_HDLR_ERROR_RETRY实现自动重试（最多三次），可指定尝试的延迟
    RAISE EXCEPTION TYPE zcx_rap_event_hdlr_error_retry
      EXPORTING
        textid     = VALUE #( msgid = if_t100_message=>default_textid-msgid
                              msgno = if_t100_message=>default_textid-msgno
                              attr1 = 'Instance is locked'
                              attr2 = ''
                              attr3 = ''
                              attr4 = '' )
        delay_time = '3'.

  ENDMETHOD.

ENDCLASS.
