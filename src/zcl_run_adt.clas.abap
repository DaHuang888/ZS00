CLASS zcl_run_adt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RUN_ADT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*      READ ENTITIES OF I_SalesOrderBillOfMaterialTP_2
*        ENTITY SalesBillOfMaterial
**        FIELDS ( BillOfMaterialCategory BillOfMaterial BillOfMaterialVariant Material Plant EngineeringChangeDocument
**                 SalesOrder SalesOrderItem BillOfMaterialStatus BOMIsToBeDeleted BillOfMaterialVariantUsage )
*        ALL FIELDS WITH VALUE #( ( %key-BillOfMaterial = '00000129'
*                                   %key-BillOfMaterialCategory = 'K'
*                                   %key-BillOfMaterialVariant = '01'
*                                   %key-EngineeringChangeDocument = ''
*                                   %key-Material = 'R8000000'
*                                   %key-Plant = '8520'
*                                   ) )
*        RESULT DATA(lt_bom_h_r_result)
*        FAILED DATA(ls_bom_h_r_failed)
*        REPORTED DATA(ls_bom_h_r_reported).
*
*
*        select * FROM I_SalesOrderBillOfMaterialTP_2
*        where BillOfMaterial = '00000129'
*                                 and BillOfMaterialCategory = 'K'
*                                   and BillOfMaterialVariant = '01'
*                                   and EngineeringChangeDocument = ''
*                                   and Material = 'R8000000'
*                                   and Plant = '8520'
*                                   into TABLE @data(lt_tab).

*    data: lt_create type TABLE FOR CREATE zi_materialbomitemaddtp.
*
*    lt_create = value  #( ( %cid = 'test01'
*                               %key-BillOfMaterial = '00008007'
*                               %key-BillOfMaterialCategory = '1'
*                               %key-BillOfMaterialVariant = '1'
*                               %key-BillOfMaterialVersion = ''
*                               %key-BillOfMaterialItemNodeNumber = '1'
*                               %key-HeaderChangeDocument = ''
*                               %key-Material = 'tes881'
*                               %key-Plant = '0001'
*                               %data-Yy1erskz = '1'
*                               %control-BillOfMaterial = if_abap_behv=>mk-on
*                               %control-BillOfMaterialCategory = if_abap_behv=>mk-on
*                               %control-BillOfMaterialVariant = if_abap_behv=>mk-on
*                               %control-BillOfMaterialVersion = if_abap_behv=>mk-on
*                               %control-BillOfMaterialItemNodeNumber = if_abap_behv=>mk-on
*                               %control-HeaderChangeDocument = if_abap_behv=>mk-on
*                               %control-Material = if_abap_behv=>mk-on
*                               %control-Plant = if_abap_behv=>mk-on
*                               %control-Yy1erskz = if_abap_behv=>mk-on )
*                               ( %cid = 'test02'
*                               %key-BillOfMaterial = '00008007'
*                               %key-BillOfMaterialCategory = '1'
*                               %key-BillOfMaterialVariant = '1'
*                               %key-BillOfMaterialVersion = ''
*                               %key-BillOfMaterialItemNodeNumber = '1'
*                               %key-HeaderChangeDocument = ''
*                               %key-Material = 'test882'
*                               %key-Plant = '0001'
*                               %data-Yy1erskz = '2'
*                               %control-BillOfMaterial = if_abap_behv=>mk-on
*                               %control-BillOfMaterialCategory = if_abap_behv=>mk-on
*                               %control-BillOfMaterialVariant = if_abap_behv=>mk-on
*                               %control-BillOfMaterialVersion = if_abap_behv=>mk-on
*                               %control-BillOfMaterialItemNodeNumber = if_abap_behv=>mk-on
*                               %control-HeaderChangeDocument = if_abap_behv=>mk-on
*                               %control-Material = if_abap_behv=>mk-on
*                               %control-Plant = if_abap_behv=>mk-on
*                               %control-Yy1erskz = if_abap_behv=>mk-on ) ).
*
*    MODIFY ENTITIES OF zi_materialbomitemaddtp
*        ENTITY ZMaterialBOMItemAdd
*        CREATE FROM lt_create
*        MAPPED DATA(ls_mapped)
*        FAILED DATA(ls_failed)
*        REPORTED DATA(ls_reported).
*
*   if ls_failed is INITIAL.
*    COMMIT ENTITIES.
*   ENDIF.

    data: lt_update type TABLE FOR UPDATE zi_materialbomitemaddtp.

    lt_update = value  #( (
                               %key-BillOfMaterial = '00008007'
                               %key-BillOfMaterialCategory = '1'
                               %key-BillOfMaterialVariant = '1'
                               %key-BillOfMaterialVersion = ''
                               %key-BillOfMaterialItemNodeNumber = '1'
                               %key-HeaderChangeDocument = ''
                               %key-Material = 'tes881'
                               %key-Plant = '0001'
                               %data-Yy1erskz = '6'
                               %control-BillOfMaterial = if_abap_behv=>mk-on
                               %control-BillOfMaterialCategory = if_abap_behv=>mk-on
                               %control-BillOfMaterialVariant = if_abap_behv=>mk-on
                               %control-BillOfMaterialVersion = if_abap_behv=>mk-on
                               %control-BillOfMaterialItemNodeNumber = if_abap_behv=>mk-on
                               %control-HeaderChangeDocument = if_abap_behv=>mk-on
                               %control-Material = if_abap_behv=>mk-on
                               %control-Plant = if_abap_behv=>mk-on
                               %control-Yy1erskz = if_abap_behv=>mk-on )
                               (
                               %key-BillOfMaterial = '00008007'
                               %key-BillOfMaterialCategory = '1'
                               %key-BillOfMaterialVariant = '1'
                               %key-BillOfMaterialVersion = ''
                               %key-BillOfMaterialItemNodeNumber = '1'
                               %key-HeaderChangeDocument = ''
                               %key-Material = 'test882'
                               %key-Plant = '0001'
                               %data-Yy1erskz = '5'
                               %control-BillOfMaterial = if_abap_behv=>mk-on
                               %control-BillOfMaterialCategory = if_abap_behv=>mk-on
                               %control-BillOfMaterialVariant = if_abap_behv=>mk-on
                               %control-BillOfMaterialVersion = if_abap_behv=>mk-on
                               %control-BillOfMaterialItemNodeNumber = if_abap_behv=>mk-on
                               %control-HeaderChangeDocument = if_abap_behv=>mk-on
                               %control-Material = if_abap_behv=>mk-on
                               %control-Plant = if_abap_behv=>mk-on
                               %control-Yy1erskz = if_abap_behv=>mk-on ) ).

    MODIFY ENTITIES OF zi_materialbomitemaddtp
        ENTITY ZMaterialBOMItemAdd
        UPDATE from lt_update
        MAPPED DATA(ls_mapped_c)
        FAILED DATA(ls_failed_c)
        REPORTED DATA(ls_reported_c).

        IF ls_failed_c IS INITIAL.
          COMMIT ENTITIES.
        ELSE.
          out->write( |Update of BOM items failed, no commit executed.| ).
        ENDIF.


*    MODIFY ENTITIES OF I_ProjectDemandTP_2   PRIVILEGED
*                     ENTITY projectdemand
*                       CREATE FROM VALUE #( ( %cid      =  'CID_DEMAND111'
**                  projectdemanduuid              = lv_uuid_x16
*                    ReferencedObjectUUID           =  'FA163EE86DFC1FE0ABE1E0EC2A16E686' "ls_header-wbselementexternalid
**                  projectdemand                  = ls_header-projectdemand
*                      projectdemandcategory          = '01' "ls_header-projectdemandcategory
*                      projectdemandtype              =  'S101' "ls_header-projectdemandtype
**                 projectdemandstatus            = '00000' "ls_header-projectdemandstatus
*                    projdmndrequestedquantity      = '10' "ls_header-projdmndrequestedquantity
*                    projdmndrequestedquantityunit  = '10' "ls_header-projdmndrequestedquantityunit
*                    projectdemanddatemaintenance   = '00' "ls_header-projectdemanddatemaintenance
**                  projectdemandstartdate         = '20251129' "ls_header-projectdemandstartdate
**                  projectdemandenddate           = '20251229' "ls_header-projectdemandenddate
*                    plant                          = '8520' "ls_header-plant
*                    purchasinggroup                = '300' "ls_header-purchasinggroup
*                    projectdemandname              = '新命令Test项目需求名称1' "ls_header-projectdemandname
*                    projectdemanddescription       = '新命令Test项目需求描述1' "ls_header-projectdemanddescription
*                    %control-ReferencedObjectUUID = if_abap_behv=>mk-on
*                    %control-projectdemandcategory = if_abap_behv=>mk-on
*                    %control-projdmndrequestedquantity = if_abap_behv=>mk-on
*                    %control-projdmndrequestedquantityunit = if_abap_behv=>mk-on
*                    %control-projectdemanddatemaintenance = if_abap_behv=>mk-on
*                    %control-plant = if_abap_behv=>mk-on
*                    %control-purchasinggroup = if_abap_behv=>mk-on
*                    %control-projectdemandname = if_abap_behv=>mk-on
*                    %control-projectdemanddescription = if_abap_behv=>mk-on
*                     ) )
*    ENTITY projectdemand
*     CREATE BY \_Service
*        FROM VALUE #( ( %cid_ref = 'CID_DEMAND111'
*            %target = VALUE #( ( %cid  = 'CID_MATERIAL111'
*                        materialgroup = '002' ) ) ) )
*
*              MAPPED DATA(ls_mapped)
*              FAILED DATA(ls_failed)
*              REPORTED DATA(ls_reported).
*
*
*   if ls_failed is INITIAL.
*
*    out->write( ls_mapped-projectdemand[ 1 ]-ProjectDemandUUID ).
*    COMMIT ENTITIES.
*   ENDIF.


*    MODIFY ENTITIES OF i_billofmaterialtp_2
*           ENTITY BillOfMaterialItem
*             UPDATE
*               SET FIELDS WITH VALUE
*                 #( (
*                      %key-billofmaterial               = '00057791'
*                      %key-billofmaterialcategory       = 'M'
*                      %key-material                     = 'TRI_HEADER_MAT'
*                      %key-billofmaterialvariant        = '01'
*                      %key-plant                        = '0001'
*                      %key-headerchangedocument         = ''
*                      %key-billofmaterialversion        = ''
*                      %key-billofmaterialitemnodenumber = '1'
*
*                      BillOfMaterialItemQuantity = 5
*                      yy1_erskz_bmi = '1'
*
*                  ) )
*
*               MAPPED DATA(ls_mapped)
*               FAILED DATA(ls_failed).
*
*
*    SELECT billofmaterial, yy1_erskz_bmi
*      FROM I_BillOfMaterialItemTP_2
*      INTO TABLE @DATA(lt_tab).

*    MODIFY ENTITIES OF i_billofmaterialtp_2
*           ENTITY BillOfMaterialItem
*             UPDATE
*               SET FIELDS WITH VALUE
*                 #( (
*                      %key-billofmaterial               = '00000032'
*                      %key-billofmaterialcategory       = 'M'
*                      %key-material                     = 'VE45E87303'
*                      %key-billofmaterialvariant        = '01'
*                      %key-plant                        = '8530'
*                      %key-headerchangedocument         = ''
*                      %key-billofmaterialversion        = ''
*                      %key-billofmaterialitemnodenumber = '00000007'
*
*                      BillOfMaterialItemQuantity = 10
*
*                  ) )
*
*               MAPPED DATA(ls_mapped)
*               FAILED DATA(ls_failed)
*               REPORTED DATA(ls_reported).
*
*
*    COMMIT ENTITIES BEGIN
*      RESPONSE OF i_billofmaterialtp_2
*        FAILED   DATA(ls_save_failed)
*        REPORTED DATA(ls_save_reported).
*    COMMIT ENTITIES END.

  ENDMETHOD.
ENDCLASS.
