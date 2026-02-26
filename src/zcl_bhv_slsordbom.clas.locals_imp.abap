CLASS lhc_ZI_SlsOrdBOM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZSalesOrderBOM RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ZSalesOrderBOM RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities      FOR CREATE ZSalesOrderBOM
                entities_item FOR CREATE ZSalesOrderBOM\_Slsordbomitm.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ZSalesOrderBOM.


    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ZSalesOrderBOM.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZSalesOrderBOM RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ZSalesOrderBOM.

    METHODS rba_Slsordbomitm FOR READ
      IMPORTING keys_rba FOR READ ZSalesOrderBOM\_Slsordbomitm FULL result_requested RESULT result LINK association_links.
    METHODS ExplodeBOM FOR READ
      IMPORTING keys FOR FUNCTION ZSalesOrderBOM~ExplodeBOM RESULT result.

    METHODS CopyBOM FOR MODIFY
      IMPORTING keys FOR ACTION ZSalesOrderBOM~CopyBOM RESULT result .
*    METHODS cba_Slsordbomitm FOR MODIFY
*      IMPORTING entities_cba FOR CREATE ZSalesOrderBOM\_Slsordbomitm.

ENDCLASS.

CLASS lhc_ZI_SlsOrdBOM IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.

* 返回参数mapped/failed/reported，当failed有值即请求失败，则返回reproted，不会继续运行到cl_abap_behavior_saver
* 因标准报文结构只显示一条信息，则按Root->Child顺序显示错误信息
* 成功返回状态码：201
* 失败返回状态码：<> 201，返回报文是标准结构
*{
*    "error": {
*        "code": "BOM/171",
*        "message": "BOM does not exist or has not been loaded"
*    }
*}

    DATA lt_bomitem_delete TYPE TABLE FOR DELETE I_SlsOrdBillOfMaterialItemTP_2.
    DATA lt_bomitemadd_delete TYPE TABLE FOR DELETE zi_materialbomitemaddtp.
    DATA lt_bomitemadd_create TYPE TABLE FOR CREATE zi_materialbomitemaddtp.

    CHECK entities IS NOT INITIAL.

    READ TABLE entities INTO DATA(ls_entity) INDEX 1.

    SELECT SINGLE BillOfMaterial
        FROM I_SalesOrderBOMLink
        WHERE BillOfMaterialCategory = 'K'
          AND BillOfMaterialVariant = @ls_entity-BillOfMaterialVariant
          AND BillOfMaterialVariantUsage = @ls_entity-BillOfMaterialVariantUsage
          AND Material = @ls_entity-Material
          AND Plant = @ls_entity-Plant
          AND SalesOrder = @ls_entity-SalesOrder
          AND SalesOrderItem = @ls_entity-SalesOrderItem
     INTO @DATA(lv_BillOfMaterial).

* 判断是新建还是修改BOM请求：lv_BillOfMaterial，无则是创建，有则是修改
    IF lv_BillOfMaterial IS INITIAL.
* 1 创建BOM Header
      IF entities_item IS INITIAL.
* 1.1 空BOM Item，只需创建BOM Header
        MODIFY ENTITIES OF I_SalesOrderBillOfMaterialTP_2 PRIVILEGED
        ENTITY SalesBillOfMaterial
         CREATE FROM VALUE
              #(  ( %cid = ls_entity-%cid
                    %key-BillOfMaterialCategory = 'K'
                    %key-BillOfMaterialVariant = ls_entity-BillOfMaterialVariant
                    %key-EngineeringChangeDocument = ''"ls_entity-EngineeringChangeDocument
                    %key-Material = ls_entity-Material
                    %key-Plant = ls_entity-Plant
                    %data-BillOfMaterialVariantUsage = ls_entity-BillOfMaterialVariantUsage
                    %data-SalesOrder = ls_entity-SalesOrder
                    %data-SalesOrderItem = ls_entity-SalesOrderItem
                    %data-BillOfMaterialStatus = ls_entity-BillOfMaterialStatus
                    %data-BOMIsToBeDeleted = ls_entity-BOMIsToBeDeleted
                    %data-BOMHeaderQuantityInBaseUnit = ls_entity-BOMHeaderQuantityInBaseUnit
                    %data-BOMHeaderBaseUnit = ls_entity-BOMHeaderBaseUnit
                    %control-BillOfMaterialCategory = if_abap_behv=>mk-on
                    %control-BillOfMaterialVariant = if_abap_behv=>mk-on
                    %control-EngineeringChangeDocument = if_abap_behv=>mk-on
                    %control-Material = if_abap_behv=>mk-on
                    %control-Plant = if_abap_behv=>mk-on
                    %control-BillOfMaterialVariantUsage = if_abap_behv=>mk-on
                    %control-SalesOrder = if_abap_behv=>mk-on
                    %control-SalesOrderItem = if_abap_behv=>mk-on
                    %control-BillOfMaterialStatus = if_abap_behv=>mk-on
                    %control-BOMIsToBeDeleted = if_abap_behv=>mk-on
                    %control-BOMHeaderQuantityInBaseUnit = COND #( WHEN ls_entity-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                          THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                    %control-BOMHeaderBaseUnit = COND #( WHEN ls_entity-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                          THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
               ) )
            MAPPED DATA(ls_bom_h_c_mapped)
            FAILED DATA(ls_bom_h_c_failed)
            REPORTED DATA(ls_bom_h_c_reported).

        IF ls_bom_h_c_failed-salesbillofmaterial IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_h_c_failed-salesbillofmaterial   TO failed-zsalesorderbom   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_h_c_reported-salesbillofmaterial TO reported-zsalesorderbom KEEPING TARGET LINES.
          " 错误发生，即返回
          RETURN.
        ENDIF.

      ELSE.
* 1.2 有BOM Item，创建BOM Header和Item
        MODIFY ENTITIES OF I_SalesOrderBillOfMaterialTP_2 PRIVILEGED
        ENTITY SalesBillOfMaterial
         CREATE FROM VALUE
              #(  ( %cid = ls_entity-%cid
                    %key-BillOfMaterialCategory = 'K'"ls_entity-BillOfMaterialCategory
                    %key-BillOfMaterialVariant = ls_entity-BillOfMaterialVariant
                    %key-EngineeringChangeDocument = ''"ls_entity-EngineeringChangeDocument
                    %key-Material = ls_entity-Material
                    %key-Plant = ls_entity-Plant
                    %data-BillOfMaterialVariantUsage = ls_entity-BillOfMaterialVariantUsage
                    %data-SalesOrder = ls_entity-SalesOrder
                    %data-SalesOrderItem = ls_entity-SalesOrderItem
                    %data-BillOfMaterialStatus = ls_entity-BillOfMaterialStatus
                    %data-BOMIsToBeDeleted = ls_entity-BOMIsToBeDeleted
                    %data-BOMHeaderQuantityInBaseUnit = ls_entity-BOMHeaderQuantityInBaseUnit
                    %data-BOMHeaderBaseUnit = ls_entity-BOMHeaderBaseUnit
                    %control-BillOfMaterialCategory = if_abap_behv=>mk-on
                    %control-BillOfMaterialVariant = if_abap_behv=>mk-on
                    %control-EngineeringChangeDocument = if_abap_behv=>mk-on
                    %control-Material = if_abap_behv=>mk-on
                    %control-Plant = if_abap_behv=>mk-on
                    %control-BillOfMaterialVariantUsage = if_abap_behv=>mk-on
                    %control-SalesOrder = if_abap_behv=>mk-on
                    %control-SalesOrderItem = if_abap_behv=>mk-on
                    %control-BillOfMaterialStatus = if_abap_behv=>mk-on
                    %control-BOMIsToBeDeleted = if_abap_behv=>mk-on
                    %control-BOMHeaderQuantityInBaseUnit = COND #( WHEN ls_entity-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                          THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                    %control-BOMHeaderBaseUnit = COND #( WHEN ls_entity-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                          THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
               ) )
         CREATE BY \_BillOfMaterialItem
            FROM VALUE #( ( %cid_ref = ls_entity-%cid
                     %key-BillOfMaterialCategory = 'K'"ls_entity-BillOfMaterialCategory
                     %key-BillOfMaterialVariant = ls_entity-BillOfMaterialVariant
                     %key-EngineeringChangeDocument = ''"ls_entity-EngineeringChangeDocument
                     %key-Material = ls_entity-Material
                     %key-Plant = ls_entity-Plant
                     %target = VALUE #( FOR ls_target_c IN entities_item[ 1 ]-%target
                                        ( %cid = ls_target_c-%cid
                                          %data-BillOfMaterialItemNumber = ls_target_c-BillOfMaterialItemNumber
                                          %data-BillOfMaterialItemCategory = ls_target_c-BillOfMaterialItemCategory
                                          %data-BillOfMaterialComponent = ls_target_c-BillOfMaterialComponent
                                          %data-BillOfMaterialItemQuantity = ls_target_c-BillOfMaterialItemQuantity
                                          %data-BillOfMaterialItemUnit = ls_target_c-BillOfMaterialItemUnit
                                          %data-IsDeleted = ls_target_c-IsDeleted
                                          %data-BOMItemDescription = ls_target_c-BOMItemDescription
                                          %data-BOMItemIsCostingRelevant = ls_target_c-BOMItemIsCostingRelevant
                                          %data-IsEngineeringRelevant = ls_target_c-IsEngineeringRelevant
                                          %data-IsProductionRelevant = ls_target_c-IsProductionRelevant
                                          %data-BOMItemSorter = ls_target_c-BOMItemSorter
                                          %data-BOMItemIsSparePart = ls_target_c-BOMItemIsSparePart
                                          %data-IsMaterialProvision = ls_target_c-IsMaterialProvision
                                          %data-Size1 = ls_target_c-Size1
                                          %data-Size2 = ls_target_c-Size2
                                          %data-Size3 = ls_target_c-Size3
                                          %data-UnitOfMeasureForSize1To3 = ls_target_c-UnitOfMeasureForSize1To3
                                          %data-FormulaKey = ls_target_c-FormulaKey
                                          %data-QuantityVariableSizeItem = ls_target_c-QuantityVariableSizeItem
                                          %control-BillOfMaterialItemNumber = if_abap_behv=>mk-on
                                          %control-BillOfMaterialItemCategory = if_abap_behv=>mk-on
                                          %control-BillOfMaterialComponent = COND #( WHEN ls_target_c-BillOfMaterialItemCategory = 'T' THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                          %control-BillOfMaterialItemQuantity = if_abap_behv=>mk-on
                                          %control-BillOfMaterialItemUnit = if_abap_behv=>mk-on
                                          %control-IsDeleted = if_abap_behv=>mk-on
                                          %control-BOMItemDescription = if_abap_behv=>mk-on
                                          %control-BOMItemIsCostingRelevant = COND #( WHEN ls_target_c-BOMItemIsCostingRelevant IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                          %control-IsEngineeringRelevant = COND #( WHEN ls_target_c-IsEngineeringRelevant IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                          %control-IsProductionRelevant = COND #( WHEN ls_target_c-IsProductionRelevant IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                          %control-BOMItemSorter = COND #( WHEN ls_target_c-BOMItemSorter IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                          %control-BOMItemIsSparePart = COND #( WHEN ls_target_c-BOMItemIsSparePart IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                          %control-IsMaterialProvision = COND #( WHEN ls_target_c-IsMaterialProvision IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                          %control-Size1 = if_abap_behv=>mk-on
                                          %control-Size2 = if_abap_behv=>mk-on
                                          %control-Size3 = if_abap_behv=>mk-on
                                          %control-UnitOfMeasureForSize1To3 = if_abap_behv=>mk-on
                                          %control-FormulaKey = if_abap_behv=>mk-on
                                          %control-QuantityVariableSizeItem = if_abap_behv=>mk-on
                                          ) ) ) )
            MAPPED DATA(ls_bom_hi_c_mapped)
            FAILED DATA(ls_bom_hi_c_failed)
            REPORTED DATA(ls_bom_hi_c_reported).

        IF ls_bom_hi_c_failed-salesbillofmaterial IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_hi_c_failed-salesbillofmaterial   TO failed-zsalesorderbom   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_hi_c_reported-salesbillofmaterial TO reported-zsalesorderbom KEEPING TARGET LINES.
          " 错误发生，即返回
          RETURN.
        ELSEIF ls_bom_hi_c_failed-salesbillofmaterialitem IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_hi_c_failed-salesbillofmaterialitem   TO failed-zsalesorderbomitem   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_hi_c_reported-salesbillofmaterialitem TO reported-zsalesorderbomitem KEEPING TARGET LINES.
          " 错误发生，即返回
          RETURN.
        ENDIF.

      ENDIF.

    ELSE.

* 2 修改BOM Header
      MODIFY ENTITIES OF I_SalesOrderBillOfMaterialTP_2 PRIVILEGED
                ENTITY salesbillofmaterial
        UPDATE SET FIELDS
        WITH VALUE #( ( %key-BillOfMaterialCategory = 'K'"ls_entity-BillOfMaterialCategory
                        %key-BillOfMaterial = lv_BillOfMaterial
                        %key-BillOfMaterialVariant = ls_entity-BillOfMaterialVariant
                        %key-EngineeringChangeDocument = ''"ls_entity-EngineeringChangeDocument
                        %key-Material = ls_entity-Material
                        %key-Plant = ls_entity-Plant
                        %data-BillOfMaterialVariantUsage = ls_entity-BillOfMaterialVariantUsage
                        %data-SalesOrder = ls_entity-SalesOrder
                        %data-SalesOrderItem = ls_entity-SalesOrderItem
                        %data-BillOfMaterialStatus = ls_entity-BillOfMaterialStatus
                        %data-BOMIsToBeDeleted = ls_entity-BOMIsToBeDeleted
                        %data-BOMHeaderQuantityInBaseUnit = ls_entity-BOMHeaderQuantityInBaseUnit
                        %data-BOMHeaderBaseUnit = ls_entity-BOMHeaderBaseUnit
                        %control-BillOfMaterialVariantUsage = if_abap_behv=>mk-on
                        %control-SalesOrder = if_abap_behv=>mk-on
                        %control-SalesOrderItem = if_abap_behv=>mk-on
                        %control-BillOfMaterialStatus = if_abap_behv=>mk-on
                        %control-BOMIsToBeDeleted = if_abap_behv=>mk-on
                        %control-BOMHeaderQuantityInBaseUnit = COND #( WHEN ls_entity-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                        THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                        %control-BOMHeaderBaseUnit = COND #( WHEN ls_entity-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                        THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off ) ) )
          MAPPED DATA(ls_bom_h_u_mapped)
          FAILED DATA(ls_bom_h_u_failed)
          REPORTED DATA(ls_bom_h_u_reported).

      IF ls_bom_h_u_failed-salesbillofmaterial IS NOT INITIAL.
        MOVE-CORRESPONDING ls_bom_h_u_failed-salesbillofmaterial   TO failed-zsalesorderbom   KEEPING TARGET LINES.
        MOVE-CORRESPONDING ls_bom_h_u_reported-salesbillofmaterial TO reported-zsalesorderbom KEEPING TARGET LINES.
        " 错误发生，即返回
        RETURN.
      ENDIF.

* 2.1 修改请求时，先删除所有BOM Item
* 2.1.1 读取所有BOM Item
      SELECT BillOfMaterial, BillOfMaterialCategory, BillOfMaterialVariant, BillOfMaterialItemNodeNumber,
             HeaderChangeDocument, Material, Plant
          FROM I_SlsOrdBillOfMaterialItemTP_2
          WHERE BillOfMaterial = @lv_BillOfMaterial
            AND billofmaterialcategory = 'K'"@ls_entity-BillOfMaterialCategory
            AND billOfmaterialvariant = @ls_entity-billOfmaterialvariant
            AND HeaderChangeDocument = ''"@ls_entity-EngineeringChangeDocument
            AND material = @ls_entity-material
            AND plant = @ls_entity-plant
            INTO TABLE @DATA(lt_bomitem_read).

      lt_bomitem_delete = CORRESPONDING #( lt_bomitem_read ).

* 2.2.2 删除所有BOM Item
      IF lt_bomitem_delete IS NOT INITIAL.

        MODIFY ENTITIES OF I_SalesOrderBillOfMaterialTP_2 PRIVILEGED
            ENTITY salesbillofmaterialitem
            DELETE FROM lt_bomitem_delete
        MAPPED DATA(ls_bom_i_d_mapped)
        FAILED DATA(ls_bom_i_d_failed)
        REPORTED DATA(ls_bom_i_d_reported).

        IF ls_bom_i_d_failed-salesbillofmaterial IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_i_d_failed-salesbillofmaterial   TO failed-zsalesorderbom   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_i_d_reported-salesbillofmaterial TO reported-zsalesorderbom KEEPING TARGET LINES.
          " 错误发生，即返回
          RETURN.
        ELSEIF ls_bom_i_d_failed-salesbillofmaterialitem IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_i_d_failed-salesbillofmaterialitem   TO failed-zsalesorderbomitem   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_i_d_reported-salesbillofmaterialitem TO reported-zsalesorderbomitem KEEPING TARGET LINES.
          " 错误发生，即返回
          RETURN.
        ENDIF.

      ENDIF.

* 2.2 修改请求，创建BOM Item
      IF entities_item IS NOT INITIAL.

        MODIFY ENTITIES OF I_SalesOrderBillOfMaterialTP_2 PRIVILEGED
         ENTITY SalesBillOfMaterial
         CREATE BY \_BillOfMaterialItem
         FROM VALUE #( ( %key-BillOfMaterial = lv_BillOfMaterial
                         %key-BillOfMaterialCategory = 'K'"ls_entity-BillOfMaterialCategory
                         %key-BillOfMaterialVariant = ls_entity-BillOfMaterialVariant
                         %key-EngineeringChangeDocument = ''"ls_entity-EngineeringChangeDocument
                         %key-Material = ls_entity-Material
                         %key-Plant = ls_entity-Plant
                         %target = VALUE #( FOR ls_target IN entities_item[ 1 ]-%target
                                            ( %cid = ls_target-%cid
                                              %data-BillOfMaterialItemNumber = ls_target-BillOfMaterialItemNumber
                                              %data-BillOfMaterialItemCategory = ls_target-BillOfMaterialItemCategory
                                              %data-BillOfMaterialComponent = ls_target-BillOfMaterialComponent
                                              %data-BillOfMaterialItemQuantity = ls_target-BillOfMaterialItemQuantity
                                              %data-BillOfMaterialItemUnit = ls_target-BillOfMaterialItemUnit
                                              %data-IsDeleted = ls_target-IsDeleted
                                              %data-BOMItemDescription = ls_target-BOMItemDescription
                                              %data-BOMItemIsCostingRelevant = ls_target-BOMItemIsCostingRelevant
                                              %data-IsEngineeringRelevant = ls_target-IsEngineeringRelevant
                                              %data-IsProductionRelevant = ls_target-IsProductionRelevant
                                              %data-BOMItemSorter = ls_target-BOMItemSorter
                                              %data-BOMItemIsSparePart = ls_target-BOMItemIsSparePart
                                              %data-IsMaterialProvision = ls_target-IsMaterialProvision
                                              %data-Size1 = ls_target-Size1
                                              %data-Size2 = ls_target-Size2
                                              %data-Size3 = ls_target-Size3
                                              %data-UnitOfMeasureForSize1To3 = ls_target-UnitOfMeasureForSize1To3
                                              %data-FormulaKey = ls_target-FormulaKey
                                              %data-QuantityVariableSizeItem = ls_target-QuantityVariableSizeItem
                                              %control-BillOfMaterialItemNumber = if_abap_behv=>mk-on
                                              %control-BillOfMaterialItemCategory = if_abap_behv=>mk-on
                                              %control-BillOfMaterialComponent = COND #( WHEN ls_target-BillOfMaterialItemCategory = 'T' THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                              %control-BillOfMaterialItemQuantity = if_abap_behv=>mk-on
                                              %control-BillOfMaterialItemUnit = if_abap_behv=>mk-on
                                              %control-IsDeleted = if_abap_behv=>mk-on
                                              %control-BOMItemDescription = if_abap_behv=>mk-on
                                              %control-BOMItemIsCostingRelevant = COND #( WHEN ls_target-BOMItemIsCostingRelevant IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                              %control-IsEngineeringRelevant = COND #( WHEN ls_target-IsEngineeringRelevant IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                              %control-IsProductionRelevant = COND #( WHEN ls_target-IsProductionRelevant IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                              %control-BOMItemSorter = COND #( WHEN ls_target-BOMItemSorter IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                              %control-BOMItemIsSparePart = COND #( WHEN ls_target-BOMItemIsSparePart IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                              %control-IsMaterialProvision = COND #( WHEN ls_target-IsMaterialProvision IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                              %control-Size1 = if_abap_behv=>mk-on
                                              %control-Size2 = if_abap_behv=>mk-on
                                              %control-Size3 = if_abap_behv=>mk-on
                                              %control-UnitOfMeasureForSize1To3 = if_abap_behv=>mk-on
                                              %control-FormulaKey = if_abap_behv=>mk-on
                                              %control-QuantityVariableSizeItem = if_abap_behv=>mk-on
                                              ) ) ) )
          MAPPED DATA(ls_bom_i_c_mapped)
          FAILED DATA(ls_bom_i_c_failed)
          REPORTED DATA(ls_bom_i_c_reported).

        IF ls_bom_i_c_failed-salesbillofmaterial IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_i_c_failed-salesbillofmaterial   TO failed-zsalesorderbom   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_i_c_reported-salesbillofmaterial TO reported-zsalesorderbom KEEPING TARGET LINES.
          " 错误发生，即返回
          RETURN.
        ELSEIF ls_bom_i_c_failed-salesbillofmaterialitem IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_i_c_failed-salesbillofmaterialitem   TO failed-zsalesorderbomitem   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_i_c_reported-salesbillofmaterialitem TO reported-zsalesorderbomitem KEEPING TARGET LINES.
          " 错误发生，即返回
          RETURN.
        ENDIF.

      ENDIF.

    ENDIF.

* 3 创建或者修改请求，创建自定义表字段
* 3.1 修改请求时，先删除自定义表字段
* 3.1.1 读取自定义表 Item
    SELECT BillOfMaterial, BillOfMaterialCategory, BillOfMaterialVariant, BillOfMaterialItemNodeNumber, BillOfMaterialVersion,
           HeaderChangeDocument, Material, Plant
        FROM zi_materialbomitemaddtp
        WHERE BillOfMaterial = @lv_BillOfMaterial
          AND billofmaterialcategory = 'K'"@ls_entity-BillOfMaterialCategory
          AND billOfmaterialvariant = @ls_entity-billOfmaterialvariant
          AND HeaderChangeDocument = ''"@ls_entity-EngineeringChangeDocument
          AND material = @ls_entity-material
          AND plant = @ls_entity-plant
          INTO TABLE @DATA(lt_bomitemadd_read).

    lt_bomitemadd_delete = CORRESPONDING #( lt_bomitemadd_read ).

* 3.1.2 删除所有自定义表 Item
    IF lt_bomitemadd_delete IS NOT INITIAL.

      MODIFY ENTITIES OF zi_materialbomitemaddtp
          ENTITY ZMaterialBOMItemAdd
          DELETE FROM lt_bomitemadd_delete
      MAPPED DATA(ls_add_d_mapped)
      FAILED DATA(ls_add_d_failed)
      REPORTED DATA(ls_add_d_reported).

      IF ls_add_d_failed IS NOT INITIAL.
        MOVE-CORRESPONDING ls_add_d_failed-zmaterialbomitemadd   TO failed-zsalesorderbomitem   KEEPING TARGET LINES.
        MOVE-CORRESPONDING ls_add_d_reported-zmaterialbomitemadd TO reported-zsalesorderbomitem KEEPING TARGET LINES.

        "错误发生则返回
        RETURN.
      ENDIF.

    ENDIF.

* 3.1.3 创建自定义表 Item
    CHECK ls_bom_i_c_mapped IS NOT INITIAL OR ls_bom_hi_c_mapped IS NOT INITIAL.

    IF ls_bom_i_c_mapped IS NOT INITIAL.

      lt_bomitemadd_create = CORRESPONDING #( ls_bom_i_c_mapped-salesbillofmaterialitem ).

    ELSE.

      lt_bomitemadd_create = CORRESPONDING #( ls_bom_hi_c_mapped-salesbillofmaterialitem ).

    ENDIF.

* 映射自定义字段按BillOfMaterialItemNodeNumber升序1,2,3...匹配mapped<->%target
    LOOP AT lt_bomitemadd_create ASSIGNING FIELD-SYMBOL(<fs_bomitemadd_create>).

      READ TABLE entities_item[ 1 ]-%target INTO DATA(ls_item) INDEX sy-tabix."<fs_bomitemadd_create>-BillOfMaterialItemNodeNumber.
      IF sy-subrc = 0.
        <fs_bomitemadd_create>-yy1zzsee = ls_item-yy1zzsee.
        <fs_bomitemadd_create>-Yy1zzbmk = ls_item-Yy1zzbmk.
        <fs_bomitemadd_create>-Yy1zzbre = ls_item-Yy1zzbre.
        <fs_bomitemadd_create>-Yy1zzbkz = ls_item-Yy1zzbkz.
        <fs_bomitemadd_create>-Yy1zzmkz1 = ls_item-Yy1zzmkz1.
        <fs_bomitemadd_create>-Yy1zzmkz2 = ls_item-Yy1zzmkz2.
        <fs_bomitemadd_create>-Yy1zzsort = ls_item-Yy1zzsort.
        <fs_bomitemadd_create>-Yy1zzfst = ls_item-Yy1zzfst.
        <fs_bomitemadd_create>-Yy1zzseh = ls_item-Yy1zzseh.
        <fs_bomitemadd_create>-Yy1erskz = ls_item-Yy1erskz.
        <fs_bomitemadd_create>-Yy1zztxt = ls_item-Yy1zztxt.
        <fs_bomitemadd_create>-Yy1zzsic = ls_item-Yy1zzsic.
        <fs_bomitemadd_create>-yy1zzmkzc = ls_item-yy1zzmkzc.
      ENDIF.

    ENDLOOP.

    MODIFY ENTITIES OF zi_materialbomitemaddtp
        ENTITY ZMaterialBOMItemAdd
        CREATE AUTO FILL CID FIELDS ( BillOfMaterial BillOfMaterialCategory BillOfMaterialItemNodeNumber BillOfMaterialVariant BillOfMaterialVersion HeaderChangeDocument
                                      Material Plant yy1zzsee Yy1zzbmk Yy1zzbre Yy1zzbkz Yy1zzmkz1 Yy1zzmkz2 Yy1zzsort
                                      Yy1zzfst Yy1zzseh Yy1erskz Yy1zztxt Yy1zzsic ) WITH lt_bomitemadd_create
    MAPPED DATA(ls_add_c_mapped)
    FAILED DATA(ls_add_c_failed)
    REPORTED DATA(ls_add_c_reported).

    IF ls_add_c_failed IS NOT INITIAL.
      MOVE-CORRESPONDING ls_add_c_failed-zmaterialbomitemadd   TO failed-zsalesorderbomitem   KEEPING TARGET LINES.
      MOVE-CORRESPONDING ls_add_c_reported-zmaterialbomitemadd TO reported-zsalesorderbomitem KEEPING TARGET LINES.
      " 错误发生，即返回
      RETURN.
    ENDIF.

*    mapped-zsalesorderbom = CORRESPONDING #( entities ).
*    mapped-zsalesorderbom[ 1 ]-BillOfMaterial  = cond #( when ls_entity-BillOfMaterial is not INITIAL then ls_entity-BillOfMaterial else ls_bom_h_c_mapped-salesbillofmaterial[ 1 ]-BillOfMaterial ).
*    mapped-zsalesorderbom = CORRESPONDING #( ls_bom_i_c_mapped-salesbillofmaterialitem ).

  ENDMETHOD.

  METHOD update.
* 返回参数mapped/failed/reported，当failed有值则返回reproted，不会继续运行到cl_abap_behavior_saver
* 因标准报文结构只显示一条信息，则按Root->Child顺序显示错误信息
* 成功返回状态码：200
* 失败返回状态码：<> 200，返回报文是标准结构
*{
*    "error": {
*        "code": "BOM/171",
*        "message": "BOM does not exist or has not been loaded"
*    }
*}
  ENDMETHOD.

  METHOD delete.

* 返回参数mapped/failed/reported，当failed有值则返回reproted，不会继续运行到cl_abap_behavior_saver
* 因标准报文结构只显示一条信息，则按Root->Child顺序显示错误信息
* 成功返回状态码：204
* 失败返回状态码：<> 204，返回报文是标准结构
*{
*    "error": {
*        "code": "BOM/171",
*        "message": "BOM does not exist or has not been loaded"
*    }
*}

    CHECK keys IS NOT INITIAL.

    READ TABLE keys INTO DATA(ls_key) INDEX 1.

    SELECT SINGLE BillOfMaterial
        FROM I_SalesOrderBOMLink
        WHERE BillOfMaterialCategory = 'K'
          AND BillOfMaterialVariant = @ls_key-BillOfMaterialVariant
          AND BillOfMaterialVariantUsage = @ls_key-BillOfMaterialVariantUsage
          AND Material = @ls_key-Material
          AND Plant = @ls_key-Plant
          AND SalesOrder = @ls_key-SalesOrder
          AND SalesOrderItem = @ls_key-SalesOrderItem
     INTO @DATA(lv_BillOfMaterial).

    MODIFY ENTITIES OF I_SalesOrderBillOfMaterialTP_2 PRIVILEGED
       ENTITY salesbillofmaterial
       DELETE FROM VALUE #( ( %key-billofmaterial = lv_BillOfMaterial
                              %key-billofmaterialcategory = 'K'"ls_key-BillOfMaterialCategory
                              %key-billOfmaterialvariant = ls_key-billOfmaterialvariant
                              %key-engineeringchangedocument = ''"ls_key-engineeringchangedocument
                              %key-material = ls_key-material
                              %key-plant = ls_key-plant ) )
        MAPPED DATA(ls_bom_d_mapped)
        FAILED DATA(ls_bom_d_failed)
        REPORTED DATA(ls_bom_d_reported).

    IF ls_bom_d_failed-salesbillofmaterial IS NOT INITIAL.
      MOVE-CORRESPONDING ls_bom_d_failed-salesbillofmaterial   TO failed-zsalesorderbom   KEEPING TARGET LINES.
      MOVE-CORRESPONDING ls_bom_d_reported-salesbillofmaterial TO reported-zsalesorderbom KEEPING TARGET LINES.
    ELSEIF ls_bom_d_failed-salesbillofmaterialitem IS NOT INITIAL.
      MOVE-CORRESPONDING ls_bom_d_failed-salesbillofmaterialitem   TO failed-zsalesorderbomitem   KEEPING TARGET LINES.
      MOVE-CORRESPONDING ls_bom_d_reported-salesbillofmaterialitem TO reported-zsalesorderbomitem KEEPING TARGET LINES.
    ENDIF.

* 更新自定义表字段
    DATA lt_bomitemadd_delete TYPE TABLE FOR DELETE zi_materialbomitemaddtp.

    IF ls_bom_d_failed IS INITIAL.

* 读取所有自定义表 Item
      SELECT BillOfMaterial, BillOfMaterialCategory, BillOfMaterialVariant, BillOfMaterialItemNodeNumber, BillOfMaterialVersion,
             HeaderChangeDocument, Material, Plant
          FROM zi_materialbomitemaddtp
          WHERE BillOfMaterial = @lv_BillOfMaterial
            AND billofmaterialcategory = 'K'"@ls_key-BillOfMaterialCategory
            AND billOfmaterialvariant = @ls_key-billOfmaterialvariant
            AND HeaderChangeDocument = ''"@ls_key-EngineeringChangeDocument
            AND material = @ls_key-material
            AND plant = @ls_key-plant
            INTO TABLE @DATA(lt_bomitemadd_read).

      lt_bomitemadd_delete = CORRESPONDING #( lt_bomitemadd_read ).

* 删除所有自定义表 Item
      IF lt_bomitemadd_delete IS NOT INITIAL.

        MODIFY ENTITIES OF zi_materialbomitemaddtp
            ENTITY ZMaterialBOMItemAdd
            DELETE FROM lt_bomitemadd_delete
        MAPPED DATA(ls_add_d_mapped)
        FAILED DATA(ls_add_d_failed)
        REPORTED DATA(ls_add_d_reported).

        IF ls_add_d_failed IS NOT INITIAL.
          MOVE-CORRESPONDING ls_add_d_failed-zmaterialbomitemadd   TO failed-zsalesorderbomitem   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_add_d_reported-zmaterialbomitemadd TO reported-zsalesorderbomitem KEEPING TARGET LINES.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Slsordbomitm.
  ENDMETHOD.

*  METHOD cba_Slsordbomitm.

*  ENDMETHOD.

  METHOD ExplodeBOM.

    CHECK keys IS NOT INITIAL.

    READ TABLE keys INTO DATA(ls_key) INDEX 1.

    SELECT SINGLE BillOfMaterial
        FROM I_SalesOrderBOMLink
        WHERE BillOfMaterialCategory = 'K'
          AND BillOfMaterialVariant = @ls_key-BillOfMaterialVariant
          AND BillOfMaterialVariantUsage = @ls_key-BillOfMaterialVariantUsage
          AND Material = @ls_key-Material
          AND Plant = @ls_key-Plant
          AND SalesOrder = @ls_key-SalesOrder
          AND SalesOrderItem = @ls_key-SalesOrderItem
     INTO @DATA(lv_BillOfMaterial).

    READ ENTITIES OF I_SalesOrderBillOfMaterialTP_2 PRIVILEGED
        ENTITY SalesBillOfMaterial
        EXECUTE ExplodeBOM
          FROM VALUE #(
            (
              billofmaterial = lv_BillOfMaterial
              plant          = keys[ 1 ]-plant
              material       = keys[ 1 ]-material
              EngineeringChangeDocument = ''"keys[ 1 ]-EngineeringChangeDocument
              billofmaterialcategory = 'K'"keys[ 1 ]-billofmaterialcategory
              billofmaterialvariant = keys[ 1 ]-billofmaterialvariant
              %param-SalesOrder = keys[ 1 ]-%param-SalesOrder
              %param-SalesOrderItem = keys[ 1 ]-%param-SalesOrderItem
              %param-BOMExplosionApplication = keys[ 1 ]-%param-BOMExplosionApplication
              %param-RequiredQuantity = keys[ 1 ]-%param-RequiredQuantity
              %param-BOMHeaderBaseUnit = keys[ 1 ]-%param-BOMHeaderBaseUnit
*              %param-BOMExplosionIsLimited = keys[ 1 ]-%param-BOMExplosionIsLimited
*              %param-BOMItmQtyIsScrapRelevant = keys[ 1 ]-%param-BOMItmQtyIsScrapRelevant
*              %param-BillOfMaterialItemCategory = keys[ 1 ]-%param-BillOfMaterialItemCategory
*              %param-BOMExplosionAssembly = keys[ 1 ]-%param-BOMExplosionAssembly
*              %param-BOMExplosionDate = keys[ 1 ]-%param-BOMExplosionDate
*              %param-ExplodeBOMLevelValue = keys[ 1 ]-%param-ExplodeBOMLevelValue
*              %param-BOMExplosionIsMultilevel = keys[ 1 ]-%param-BOMExplosionIsMultilevel
*              %param-MaterialProvisionFltrType = keys[ 1 ]-%param-MaterialProvisionFltrType
*              %param-SparePartFltrType = keys[ 1 ]-%param-SparePartFltrType
*              %param-FinalPriceIndicator = keys[ 1 ]-%param-FinalPriceIndicator
*              %param-BOMExplosionIsAlternatePrio = keys[ 1 ]-%param-BOMExplosionIsAlternatePrio
*              %param-BillOfMaterialSimulationValue = keys[ 1 ]-%param-BillOfMaterialSimulationValue
            )
          )
          RESULT DATA(lt_ExplodeBOM_result)
          FAILED DATA(ls_ExplodeBOM_failed)
          REPORTED DATA(ls_ExplodeBOM_reported).

    result = CORRESPONDING #( lt_ExplodeBOM_result ).

    IF ls_ExplodeBOM_failed IS NOT INITIAL.
      MOVE-CORRESPONDING ls_ExplodeBOM_failed  TO failed   KEEPING TARGET LINES.
      MOVE-CORRESPONDING ls_ExplodeBOM_reported TO reported KEEPING TARGET LINES.
    ENDIF.

  ENDMETHOD.

  METHOD CopyBOM.

    DATA ls_result LIKE LINE OF result.

    CHECK keys IS NOT INITIAL.

    READ TABLE keys INTO DATA(ls_key) INDEX 1.

    TRY.
        DATA(lv_Language) = cl_abap_context_info=>get_user_language_abap_format( ).

      CATCH cx_abap_context_info_error INTO DATA(lx_abap_context_info_error).

        clear lx_abap_context_info_error.

    ENDTRY.

* 单位转换：
    SELECT SINGLE UnitOfMeasure
    FROM I_UnitOfMeasureText
    WHERE Language = @lv_Language
      AND UnitOfMeasure_E = @ls_key-%param-BOMHeaderBaseUnit
      INTO @ls_key-%param-BOMHeaderBaseUnit.

    LOOP AT ls_key-%param-_bomheadertoitem ASSIGNING FIELD-SYMBOL(<fs_item_unit>).

      SELECT SINGLE UnitOfMeasure
          FROM I_UnitOfMeasureText
          WHERE Language = @lv_Language
              AND UnitOfMeasure_E = @<fs_item_unit>-BillOfMaterialItemUnit
          INTO @<fs_item_unit>-BillOfMaterialItemUnit.
    ENDLOOP.

* 1. 创建BOM
* 1.1 无BOM Item，只需创建BOM Header
    IF ls_key-%param-_bomheadertoitem IS INITIAL.
      MODIFY ENTITIES OF I_SalesOrderBillOfMaterialTP_2 PRIVILEGED
      ENTITY SalesBillOfMaterial
      CREATE FROM VALUE
            #(  ( %cid = ls_key-%cid
                  %key-BillOfMaterialCategory = ls_key-%param-BillOfMaterialCategory
                  %key-BillOfMaterialVariant = |{ ls_key-%param-BillOfMaterialVariant ALPHA = IN }|
                  %key-EngineeringChangeDocument = ls_key-%param-EngineeringChangeDocument
                  %key-Material = |{ ls_key-%param-Material ALPHA = IN }|
                  %key-Plant = ls_key-%param-Plant
                  %data-BillOfMaterialVariantUsage = ls_key-%param-BillOfMaterialVariantUsage
                  %data-SalesOrder = |{ ls_key-%param-SalesOrder ALPHA = IN }|
                  %data-SalesOrderItem = ls_key-%param-SalesOrderItem
                  %data-BillOfMaterialStatus = |{ ls_key-%param-BillOfMaterialStatus ALPHA = IN }|
                  %data-BOMIsToBeDeleted = ls_key-%param-BOMIsToBeDeleted
                  %data-BOMHeaderQuantityInBaseUnit = ls_key-%param-BOMHeaderQuantityInBaseUnit
                  %data-BOMHeaderBaseUnit = ls_key-%param-BOMHeaderBaseUnit
                  %control-BillOfMaterialCategory = if_abap_behv=>mk-on
                  %control-BillOfMaterialVariant = if_abap_behv=>mk-on
                  %control-EngineeringChangeDocument = if_abap_behv=>mk-on
                  %control-Material = if_abap_behv=>mk-on
                  %control-Plant = if_abap_behv=>mk-on
                  %control-BillOfMaterialVariantUsage = if_abap_behv=>mk-on
                  %control-SalesOrder = if_abap_behv=>mk-on
                  %control-SalesOrderItem = if_abap_behv=>mk-on
                  %control-BillOfMaterialStatus = if_abap_behv=>mk-on
                  %control-BOMIsToBeDeleted = if_abap_behv=>mk-on
                  %control-BOMHeaderQuantityInBaseUnit = COND #( WHEN ls_key-%param-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                          THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                  %control-BOMHeaderBaseUnit = COND #( WHEN ls_key-%param-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                          THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off ) ) )
          MAPPED DATA(ls_bom_h_c_mapped)
          FAILED DATA(ls_bom_h_c_failed)
          REPORTED DATA(ls_bom_h_c_reported).

      IF ls_bom_h_c_failed-salesbillofmaterial IS NOT INITIAL.
        MOVE-CORRESPONDING ls_bom_h_c_failed-salesbillofmaterial   TO failed-zsalesorderbom   KEEPING TARGET LINES.
        MOVE-CORRESPONDING ls_bom_h_c_reported-salesbillofmaterial TO reported-zsalesorderbom KEEPING TARGET LINES.
        " 错误发生，即返回
        RETURN.
      ENDIF.

    ELSE.
* 1.2 有BOM Item，需创建BOM Header和Item
      MODIFY ENTITIES OF I_SalesOrderBillOfMaterialTP_2 PRIVILEGED
      ENTITY SalesBillOfMaterial
      CREATE FROM VALUE
            #( ( %cid = ls_key-%cid
                  %key-BillOfMaterialCategory = ls_key-%param-BillOfMaterialCategory
                  %key-BillOfMaterialVariant = |{ ls_key-%param-BillOfMaterialVariant ALPHA = IN }|
                  %key-EngineeringChangeDocument = ls_key-%param-EngineeringChangeDocument
                  %key-Material = ls_key-%param-Material
                  %key-Plant = ls_key-%param-Plant
                  %data-BillOfMaterialVariantUsage = ls_key-%param-BillOfMaterialVariantUsage
                  %data-SalesOrder = |{ ls_key-%param-SalesOrder ALPHA = IN }|
                  %data-SalesOrderItem = ls_key-%param-SalesOrderItem
                  %data-BillOfMaterialStatus = |{ ls_key-%param-BillOfMaterialStatus ALPHA = IN }|
                  %data-BOMIsToBeDeleted = ls_key-%param-BOMIsToBeDeleted
                  %data-BOMHeaderQuantityInBaseUnit = ls_key-%param-BOMHeaderQuantityInBaseUnit
                  %data-BOMHeaderBaseUnit = ls_key-%param-BOMHeaderBaseUnit
                  %control-BillOfMaterialCategory = if_abap_behv=>mk-on
                  %control-BillOfMaterialVariant = if_abap_behv=>mk-on
                  %control-EngineeringChangeDocument = if_abap_behv=>mk-on
                  %control-Material = if_abap_behv=>mk-on
                  %control-Plant = if_abap_behv=>mk-on
                  %control-BillOfMaterialVariantUsage = if_abap_behv=>mk-on
                  %control-SalesOrder = if_abap_behv=>mk-on
                  %control-SalesOrderItem = if_abap_behv=>mk-on
                  %control-BillOfMaterialStatus = if_abap_behv=>mk-on
                  %control-BOMIsToBeDeleted = if_abap_behv=>mk-on
                  %control-BOMHeaderQuantityInBaseUnit = COND #( WHEN ls_key-%param-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                          THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                  %control-BOMHeaderBaseUnit = COND #( WHEN ls_key-%param-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                          THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off ) ) )
         CREATE BY \_BillOfMaterialItem
         FROM VALUE #( ( %cid_ref = ls_key-%cid
                         %key-BillOfMaterialCategory = ls_key-%param-BillOfMaterialCategory
                         %key-BillOfMaterialVariant = |{ ls_key-%param-BillOfMaterialVariant ALPHA = IN }|
                         %key-EngineeringChangeDocument = ls_key-%param-EngineeringChangeDocument
                         %key-Material = ls_key-%param-Material
                         %key-Plant = ls_key-%param-Plant
                         %target = VALUE #( FOR ls_target IN ls_key-%param-_bomheadertoitem
                                            ( %cid = ls_target-BillOfMaterialItemNumber
                                              %data-BillOfMaterialItemNumber = ls_target-BillOfMaterialItemNumber
                                              %data-BillOfMaterialItemCategory = ls_target-BillOfMaterialItemCategory
                                              %data-BillOfMaterialComponent = ls_target-BillOfMaterialComponent
                                              %data-BillOfMaterialItemQuantity = ls_target-BillOfMaterialItemQuantity
                                              %data-BillOfMaterialItemUnit = ls_target-BillOfMaterialItemUnit
                                              %data-IsDeleted = ls_target-IsDeleted
                                              %data-BOMItemDescription = ls_target-BOMItemDescription
                                              %data-BOMItemIsCostingRelevant = ls_target-BOMItemIsCostingRelevant
                                              %data-IsEngineeringRelevant = ls_target-IsEngineeringRelevant
                                              %data-IsProductionRelevant = ls_target-IsProductionRelevant
                                              %data-BOMItemSorter = ls_target-BOMItemSorter
                                              %data-BOMItemIsSparePart = ls_target-BOMItemIsSparePart
                                              %control-BillOfMaterialItemNumber = if_abap_behv=>mk-on
                                              %control-BillOfMaterialItemCategory = if_abap_behv=>mk-on
                                              %control-BillOfMaterialComponent = COND #( WHEN ls_target-BillOfMaterialItemCategory = 'T' THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                              %control-BillOfMaterialItemQuantity = if_abap_behv=>mk-on
                                              %control-BillOfMaterialItemUnit = if_abap_behv=>mk-on
                                              %control-IsDeleted = if_abap_behv=>mk-on
                                              %control-BOMItemDescription = if_abap_behv=>mk-on
                                              %control-BOMItemIsCostingRelevant = COND #( WHEN ls_target-BOMItemIsCostingRelevant IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                              %control-IsEngineeringRelevant = COND #( WHEN ls_target-IsEngineeringRelevant IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                              %control-IsProductionRelevant = COND #( WHEN ls_target-IsProductionRelevant IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                              %control-BOMItemSorter = COND #( WHEN ls_target-BOMItemSorter IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on )
                                              %control-BOMItemIsSparePart = COND #( WHEN ls_target-BOMItemIsSparePart IS NOT INITIAL THEN if_abap_behv=>mk-off ELSE if_abap_behv=>mk-on ) ) ) ) )
          MAPPED DATA(ls_bom_hi_c_mapped)
          FAILED DATA(ls_bom_hi_c_failed)
          REPORTED DATA(ls_bom_hi_c_reported).

      IF ls_bom_hi_c_failed-salesbillofmaterial IS NOT INITIAL.
        MOVE-CORRESPONDING ls_bom_hi_c_failed-salesbillofmaterial   TO failed-zsalesorderbom   KEEPING TARGET LINES.
        MOVE-CORRESPONDING ls_bom_hi_c_reported-salesbillofmaterial TO reported-zsalesorderbom KEEPING TARGET LINES.
        " 错误发生，即返回
        RETURN.
      ELSEIF ls_bom_hi_c_failed-salesbillofmaterialitem IS NOT INITIAL.
        MOVE-CORRESPONDING ls_bom_hi_c_failed-salesbillofmaterialitem   TO failed-zsalesorderbomitem   KEEPING TARGET LINES.
        MOVE-CORRESPONDING ls_bom_hi_c_reported-salesbillofmaterialitem TO reported-zsalesorderbomitem KEEPING TARGET LINES.
        " 错误发生，即返回
        RETURN.
      ENDIF.

    ENDIF.

* 2.更新自定义表
* 2.1 读取自定义表字段
*    SELECT _materialbomitemaddtp~BillOfMaterial, _materialbomitemaddtp~BillOfMaterialCategory, _materialbomitemaddtp~BillOfMaterialVariant,
*           _materialbomitemaddtp~BillOfMaterialVersion, _materialbomitemaddtp~BillOfMaterialItemNodeNumber, _materialbomitemaddtp~HeaderChangeDocument,
*           _materialbomitemaddtp~Material, _materialbomitemaddtp~Plant, _materialbomitemaddtp~Yy1zzsee,
*           _materialbomitemaddtp~Yy1zzbmk, _materialbomitemaddtp~Yy1zzbre, _materialbomitemaddtp~Yy1zzbkz,
*           _materialbomitemaddtp~Yy1zzmkz1, _materialbomitemaddtp~Yy1zzmkz2, _materialbomitemaddtp~Yy1zzsort,
*           _materialbomitemaddtp~Yy1zzeao, _materialbomitemaddtp~Yy1zzfst, _materialbomitemaddtp~Yy1zzseh,
*           _materialbomitemaddtp~Yy1erskz, _materialbomitemaddtp~Yy1zztxt, _materialbomitemaddtp~Yy1zzsic
*        FROM zi_materialbomitemaddtp AS _materialbomitemaddtp INNER JOIN @ls_key-%param-_bomheadertoitem AS _bom_i_r_result
*                                          ON _bom_i_r_result~BillOfMaterial = _materialbomitemaddtp~BillOfMaterial
*                                          AND _bom_i_r_result~BillOfMaterialCategory = _materialbomitemaddtp~BillOfMaterialCategory
*                                          AND _bom_i_r_result~BillOfMaterialVariant = _materialbomitemaddtp~BillOfMaterialVariant
*                                          AND  _materialbomitemaddtp~BillOfMaterialVersion = ''
*                                          AND _bom_i_r_result~BillOfMaterialItemNodeNumber = _materialbomitemaddtp~BillOfMaterialItemNodeNumber
*                                          AND _bom_i_r_result~EngineeringChangeDocument = _materialbomitemaddtp~HeaderChangeDocument
*                                          AND _bom_i_r_result~Material = _materialbomitemaddtp~Material
*                                          AND _bom_i_r_result~Plant = _materialbomitemaddtp~Plant
*       INTO TABLE @DATA(lt_materialbomitemadd).
*
*    SORT lt_materialbomitemadd BY BillOfMaterialItemNodeNumber.
*    SORT ls_key-%param-_bomheadertoitem BY BillOfMaterialItemNodeNumber.

* 2.2 创建自定义表字段
    DATA lt_bomitemadd_create TYPE TABLE FOR CREATE zi_materialbomitemaddtp.

    lt_bomitemadd_create = CORRESPONDING #( ls_bom_hi_c_mapped-salesbillofmaterialitem ).

* 映射自定义字段按BillOfMaterialItemNodeNumber升序1,2,3...匹配mapped<->%target
    LOOP AT lt_bomitemadd_create ASSIGNING FIELD-SYMBOL(<fs_bomitemadd_create>).

      READ TABLE ls_key-%param-_bomheadertoitem  INTO DATA(ls_bomheadertoitem) INDEX sy-tabix."INDEX <fs_bomitemadd_create>-BillOfMaterialItemNodeNumber.
      IF sy-subrc = 0.
        <fs_bomitemadd_create>-yy1zzsee = ls_bomheadertoitem-yy1zzsee.
        <fs_bomitemadd_create>-Yy1zzbmk = ls_bomheadertoitem-Yy1zzbmk.
        <fs_bomitemadd_create>-Yy1zzbre = ls_bomheadertoitem-Yy1zzbre.
        <fs_bomitemadd_create>-Yy1zzbkz = ls_bomheadertoitem-Yy1zzbkz.
        <fs_bomitemadd_create>-Yy1zzmkz1 = ls_bomheadertoitem-Yy1zzmkz1.
        <fs_bomitemadd_create>-Yy1zzmkz2 = ls_bomheadertoitem-Yy1zzmkz2.
        <fs_bomitemadd_create>-Yy1zzsort = ls_bomheadertoitem-Yy1zzsort.
        <fs_bomitemadd_create>-Yy1zzfst = ls_bomheadertoitem-Yy1zzfst.
        <fs_bomitemadd_create>-Yy1zzseh = ls_bomheadertoitem-Yy1zzseh.
        <fs_bomitemadd_create>-Yy1erskz = ls_bomheadertoitem-Yy1erskz.
        <fs_bomitemadd_create>-Yy1zztxt = ls_bomheadertoitem-Yy1zztxt.
        <fs_bomitemadd_create>-Yy1zzsic = ls_bomheadertoitem-Yy1zzsic.
        "<fs_bomitemadd_create>-yy1zzmkzc = ls_bomheadertoitem-yy1zzmkzc.

      ENDIF.

    ENDLOOP.

    MODIFY ENTITIES OF zi_materialbomitemaddtp
        ENTITY ZMaterialBOMItemAdd
        CREATE AUTO FILL CID FIELDS ( BillOfMaterial BillOfMaterialCategory BillOfMaterialItemNodeNumber BillOfMaterialVariant BillOfMaterialVersion HeaderChangeDocument
                                      Material Plant yy1zzsee Yy1zzbmk Yy1zzbre Yy1zzbkz Yy1zzmkz1 Yy1zzmkz2 Yy1zzsort
                                      Yy1zzfst Yy1zzseh Yy1erskz Yy1zztxt Yy1zzsic ) WITH lt_bomitemadd_create
    MAPPED DATA(ls_add_c_mapped)
    FAILED DATA(ls_add_c_failed)
    REPORTED DATA(ls_add_c_reported).

    IF ls_add_c_failed IS NOT INITIAL.
      MOVE-CORRESPONDING ls_add_c_failed-zmaterialbomitemadd   TO failed-zsalesorderbomitem   KEEPING TARGET LINES.
      MOVE-CORRESPONDING ls_add_c_reported-zmaterialbomitemadd TO reported-zsalesorderbomitem KEEPING TARGET LINES.
      " 错误发生，即返回
      RETURN.
    ENDIF.

* 5 返回result
    APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).

    <fs_result> = CORRESPONDING #( ls_key ).

*    <fs_result>-%cid = ls_key-%cid.
*    <fs_result>-%param = CORRESPONDING #( ls_key-%param ).

*    <fs_result>-%param = CORRESPONDING #( cond #( WHEN ls_bom_h_c_mapped-salesbillofmaterial IS NOT INITIAL
*                                                    THEN ls_bom_h_c_mapped-salesbillofmaterial[ 1 ]
*                                                    ELSE ls_bom_hi_c_mapped-salesbillofmaterial[ 1 ] ) ).
*
*    LOOP AT ls_bom_hi_c_mapped-salesbillofmaterialitem INTO DATA(ls_salesbillofmaterialitem) .
*
*      APPEND INITIAL LINE TO <fs_result>-%param-_bomheadertoitem ASSIGNING FIELD-SYMBOL(<fs_bomheadertoitem>).
*
*      MOVE-CORRESPONDING ls_salesbillofmaterialitem TO <fs_bomheadertoitem>.
*
*      READ TABLE lt_bomitemadd_create INTO DATA(ls_zmaterialbomitemadd)
*          WITH KEY BillOfMaterial = ls_salesbillofmaterialitem-BillOfMaterial
*                   BillOfMaterialCategory = ls_salesbillofmaterialitem-BillOfMaterialCategory
*                   BillOfMaterialVariant = ls_salesbillofmaterialitem-BillOfMaterialVariant
*                   BillOfMaterialVersion = ''
*                   BillOfMaterialItemNodeNumber = ls_salesbillofmaterialitem-BillOfMaterialItemNodeNumber
*                   HeaderChangeDocument = ls_salesbillofmaterialitem-HeaderChangeDocument
*                   Material = ls_salesbillofmaterialitem-Material
*                   Plant = ls_salesbillofmaterialitem-Plant.
*      IF sy-subrc = 0.
*        MOVE-CORRESPONDING ls_zmaterialbomitemadd TO <fs_bomheadertoitem>.
*      ENDIF.
*
*    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_SlsOrdBOMItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE ZI_SlsOrdBOMItem.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ZI_SlsOrdBOMItem.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZI_SlsOrdBOMItem RESULT result.

    METHODS rba_Slsordbom FOR READ
      IMPORTING keys_rba FOR READ ZI_SlsOrdBOMItem\_Slsordbom FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_ZI_SlsOrdBOMItem IMPLEMENTATION.

*  METHOD update.
*
*  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Slsordbom.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_SLSORDBOM DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_SLSORDBOM IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
