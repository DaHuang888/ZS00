CLASS lhc_ZI_PlantBOM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZPlantBOM RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ZPlantBOM RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities      FOR CREATE ZPlantBOM
                entities_item FOR CREATE ZPlantBOM\_Plantbomitem.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ZPlantBOM.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ZPlantBOM.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZPlantBOM RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ZPlantBOM.

    METHODS rba_Plantbomitm FOR READ
      IMPORTING keys_rba FOR READ ZPlantBOM\_Plantbomitem FULL result_requested RESULT result LINK association_links.
    METHODS ExplodeBOM FOR READ
      IMPORTING keys FOR FUNCTION ZPlantBOM~ExplodeBOM RESULT result.

*    METHODS cba_Plantbomitm FOR MODIFY
*      IMPORTING entities_cba FOR CREATE ZPlantBOM\_Plantbomitem.

ENDCLASS.

CLASS lhc_ZI_PlantBOM IMPLEMENTATION.

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

    DATA lt_bomitem_delete TYPE TABLE FOR DELETE I_BillOfMaterialItemTP_2.
    DATA lt_bomitemadd_delete TYPE TABLE FOR DELETE zi_materialbomitemaddtp.
    DATA lt_bomitemadd_create TYPE TABLE FOR CREATE zi_materialbomitemaddtp.

    CHECK entities IS NOT INITIAL.

    READ TABLE entities INTO DATA(ls_entity) INDEX 1.

    SELECT SINGLE BillOfMaterial
        FROM I_MaterialBOMLink
        WHERE BillOfMaterialCategory = 'M'"@ls_entity-BillOfMaterialCategory
          AND BillOfMaterialVariant = @ls_entity-BillOfMaterialVariant
          AND BillOfMaterialVariantUsage = @ls_entity-BillOfMaterialVariantUsage
          AND Material = @ls_entity-Material
          AND Plant = @ls_entity-Plant
     INTO @DATA(lv_BillOfMaterial).

* 判断是新建还是修改BOM请求：lv_BillOfMaterial，无则是创建，有则是修改
    IF lv_BillOfMaterial IS INITIAL.
* 1 创建BOM Header
      IF entities_item IS INITIAL.
* 1.1 空BOM Item，只需创建BOM Header
        MODIFY ENTITIES OF I_BillOfMaterialTP_2 PRIVILEGED
        ENTITY BillOfMaterial
         CREATE FROM VALUE
              #(  ( %cid = ls_entity-%cid
                    %key-BillOfMaterialCategory = 'M'"ls_entity-BillOfMaterialCategory
                    %key-BillOfMaterialVariant = ls_entity-BillOfMaterialVariant
                    %key-EngineeringChangeDocument = ''"ls_entity-EngineeringChangeDocument
                    %key-Material = ls_entity-Material
                    %key-Plant = ls_entity-Plant
                    %key-BillOfMaterialVersion = ''
                    %data-BillOfMaterialVariantUsage = ls_entity-BillOfMaterialVariantUsage
                    %data-BillOfMaterialStatus = ls_entity-BillOfMaterialStatus
                    %data-BOMIsToBeDeleted = ls_entity-BOMIsToBeDeleted
                    %data-BOMHeaderQuantityInBaseUnit = ls_entity-BOMHeaderQuantityInBaseUnit
                    %data-BOMHeaderBaseUnit = ls_entity-BOMHeaderBaseUnit
                    %control-BillOfMaterialCategory = if_abap_behv=>mk-on
                    %control-BillOfMaterialVariant = if_abap_behv=>mk-on
                    %control-EngineeringChangeDocument = if_abap_behv=>mk-on
                    %control-Material = if_abap_behv=>mk-on
                    %control-Plant = if_abap_behv=>mk-on
                    %control-BillOfMaterialVersion = if_abap_behv=>mk-on
                    %control-BillOfMaterialVariantUsage = if_abap_behv=>mk-on
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

        IF ls_bom_h_c_failed-billofmaterial IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_h_c_failed-billofmaterial   TO failed-zplantbom   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_h_c_reported-billofmaterial TO reported-zplantbomitem KEEPING TARGET LINES.
          " 错误发生，即返回
          RETURN.
        ENDIF.

      ELSE.
* 1.2 有BOM Item，创建BOM Header和Item
        MODIFY ENTITIES OF I_BillOfMaterialTP_2 PRIVILEGED
        ENTITY BillOfMaterial
         CREATE FROM VALUE
              #(  ( %cid = ls_entity-%cid
                    %key-BillOfMaterialCategory = 'M'"ls_entity-BillOfMaterialCategory
                    %key-BillOfMaterialVariant = ls_entity-BillOfMaterialVariant
                    %key-EngineeringChangeDocument = ''"ls_entity-EngineeringChangeDocument
                    %key-Material = ls_entity-Material
                    %key-Plant = ls_entity-Plant
                    %key-BillOfMaterialVersion = ''
                    %data-BillOfMaterialVariantUsage = ls_entity-BillOfMaterialVariantUsage
                    %data-BillOfMaterialStatus = ls_entity-BillOfMaterialStatus
                    %data-BOMIsToBeDeleted = ls_entity-BOMIsToBeDeleted
                    %data-BOMHeaderQuantityInBaseUnit = ls_entity-BOMHeaderQuantityInBaseUnit
                    %data-BOMHeaderBaseUnit = ls_entity-BOMHeaderBaseUnit
                    %control-BillOfMaterialCategory = if_abap_behv=>mk-on
                    %control-BillOfMaterialVariant = if_abap_behv=>mk-on
                    %control-EngineeringChangeDocument = if_abap_behv=>mk-on
                    %control-Material = if_abap_behv=>mk-on
                    %control-Plant = if_abap_behv=>mk-on
                    %control-BillOfMaterialVersion = if_abap_behv=>mk-on
                    %control-BillOfMaterialVariantUsage = if_abap_behv=>mk-on
                    %control-BillOfMaterialStatus = if_abap_behv=>mk-on
                    %control-BOMIsToBeDeleted = if_abap_behv=>mk-on
                    %control-BOMHeaderQuantityInBaseUnit = COND #( WHEN ls_entity-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                          THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                    %control-BOMHeaderBaseUnit = COND #( WHEN ls_entity-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                          THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
               ) )
         CREATE BY \_BillOfMaterialItem
            FROM VALUE #( ( %cid_ref = ls_entity-%cid
                     %key-BillOfMaterialCategory = 'M'"ls_entity-BillOfMaterialCategory
                     %key-BillOfMaterialVariant = ls_entity-BillOfMaterialVariant
                     %key-EngineeringChangeDocument = ''"ls_entity-EngineeringChangeDocument
                     %key-Material = ls_entity-Material
                     %key-Plant = ls_entity-Plant
                     %key-BillOfMaterialVersion = ''
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
                                          ) ) ) )
            MAPPED DATA(ls_bom_hi_c_mapped)
            FAILED DATA(ls_bom_hi_c_failed)
            REPORTED DATA(ls_bom_hi_c_reported).

        IF ls_bom_hi_c_failed-billofmaterial IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_hi_c_failed-billofmaterial   TO failed-zplantbom   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_hi_c_reported-billofmaterial TO reported-zplantbom KEEPING TARGET LINES.
          " 错误发生，即返回
          RETURN.
        ELSEIF ls_bom_hi_c_failed-billofmaterialitem IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_hi_c_failed-billofmaterialitem   TO failed-zplantbomitem   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_hi_c_reported-billofmaterialitem TO reported-zplantbomitem KEEPING TARGET LINES.
          " 错误发生，即返回
          RETURN.
        ENDIF.

      ENDIF.

    ELSE.

* 2 修改BOM Header
      MODIFY ENTITIES OF I_BillOfMaterialTP_2 PRIVILEGED
                ENTITY BillOfMaterial
        UPDATE SET FIELDS
        WITH VALUE #( ( %key-BillOfMaterialCategory = 'M'"ls_entity-BillOfMaterialCategory
                        %key-BillOfMaterial = lv_BillOfMaterial
                        %key-BillOfMaterialVariant = ls_entity-BillOfMaterialVariant
                        %key-EngineeringChangeDocument = ''"ls_entity-EngineeringChangeDocument
                        %key-Material = ls_entity-Material
                        %key-Plant = ls_entity-Plant
                        %key-BillOfMaterialVersion = ''
                        %data-BillOfMaterialVariantUsage = ls_entity-BillOfMaterialVariantUsage
                        %data-BillOfMaterialStatus = ls_entity-BillOfMaterialStatus
                        %data-BOMIsToBeDeleted = ls_entity-BOMIsToBeDeleted
                        %data-BOMHeaderQuantityInBaseUnit = ls_entity-BOMHeaderQuantityInBaseUnit
                        %data-BOMHeaderBaseUnit = ls_entity-BOMHeaderBaseUnit
                        %control-BillOfMaterialVariantUsage = if_abap_behv=>mk-on
                        %control-BillOfMaterialStatus = if_abap_behv=>mk-on
                        %control-BOMIsToBeDeleted = if_abap_behv=>mk-on
                        %control-BOMHeaderQuantityInBaseUnit = COND #( WHEN ls_entity-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                        THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                        %control-BOMHeaderBaseUnit = COND #( WHEN ls_entity-BOMHeaderQuantityInBaseUnit IS NOT INITIAL
                                                        THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off ) ) )
          MAPPED DATA(ls_bom_h_u_mapped)
          FAILED DATA(ls_bom_h_u_failed)
          REPORTED DATA(ls_bom_h_u_reported).

      IF ls_bom_h_u_failed-billofmaterial IS NOT INITIAL.
        MOVE-CORRESPONDING ls_bom_h_u_failed-billofmaterial   TO failed-zplantbom   KEEPING TARGET LINES.
        MOVE-CORRESPONDING ls_bom_h_u_reported-billofmaterial TO reported-zplantbom KEEPING TARGET LINES.
        " 错误发生，即返回
        RETURN.
      ENDIF.

* 2.1 修改请求时，先删除所有BOM Item
* 2.1.1 读取所有BOM Item
      SELECT BillOfMaterial, BillOfMaterialCategory, BillOfMaterialVariant, BillOfMaterialItemNodeNumber,
             HeaderChangeDocument, Material, Plant, BillOfMaterialVersion
          FROM I_BillOfMaterialItemTP_2
          WHERE BillOfMaterial = @lv_BillOfMaterial
            AND billofmaterialcategory = 'M'"@ls_entity-BillOfMaterialCategory
            AND billOfmaterialvariant = @ls_entity-billOfmaterialvariant
            AND HeaderChangeDocument = ''"@ls_entity-EngineeringChangeDocument
            AND material = @ls_entity-material
            AND plant = @ls_entity-plant
            AND BillOfMaterialVersion = ''
            INTO TABLE @DATA(lt_bomitem_read).

      lt_bomitem_delete = CORRESPONDING #( lt_bomitem_read ).

* 2.2.2 删除所有BOM Item
      IF lt_bomitem_delete IS NOT INITIAL.

        MODIFY ENTITIES OF I_BillOfMaterialTP_2 PRIVILEGED
            ENTITY BillOfMaterialItem
            DELETE FROM lt_bomitem_delete
        MAPPED DATA(ls_bom_i_d_mapped)
        FAILED DATA(ls_bom_i_d_failed)
        REPORTED DATA(ls_bom_i_d_reported).

        IF ls_bom_i_d_failed-billofmaterial IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_i_d_failed-billofmaterial   TO failed-zplantbom   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_i_d_reported-billofmaterial TO reported-zplantbom KEEPING TARGET LINES.
          " 错误发生，即返回
          RETURN.
        ELSEIF ls_bom_i_d_failed-billofmaterialitem IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_i_d_failed-billofmaterialitem   TO failed-zplantbomitem   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_i_d_reported-billofmaterialitem TO reported-zplantbomitem KEEPING TARGET LINES.
          " 错误发生，即返回
          RETURN.
        ENDIF.

      ENDIF.

* 2.2 修改请求，创建BOM Item
      IF entities_item IS NOT INITIAL.

        MODIFY ENTITIES OF I_BillOfMaterialTP_2 PRIVILEGED
         ENTITY BillOfMaterial
         CREATE BY \_BillOfMaterialItem
         FROM VALUE #( ( %key-BillOfMaterial = lv_BillOfMaterial
                         %key-BillOfMaterialCategory = 'M'"ls_entity-BillOfMaterialCategory
                         %key-BillOfMaterialVariant = ls_entity-BillOfMaterialVariant
                         %key-EngineeringChangeDocument = ''"ls_entity-EngineeringChangeDocument
                         %key-Material = ls_entity-Material
                         %key-Plant = ls_entity-Plant
                         %key-BillOfMaterialVersion = ''
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
                                              ) ) ) )
          MAPPED DATA(ls_bom_i_c_mapped)
          FAILED DATA(ls_bom_i_c_failed)
          REPORTED DATA(ls_bom_i_c_reported).

        IF ls_bom_i_c_failed-billofmaterial IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_i_c_failed-billofmaterial   TO failed-zplantbom   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_i_c_reported-billofmaterial TO reported-zplantbom KEEPING TARGET LINES.
          " 错误发生，即返回
          RETURN.
        ELSEIF ls_bom_i_c_failed-billofmaterialitem IS NOT INITIAL.
          MOVE-CORRESPONDING ls_bom_i_c_failed-billofmaterialitem   TO failed-zplantbomitem   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_bom_i_c_reported-billofmaterialitem TO reported-zplantbomitem KEEPING TARGET LINES.
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
          AND billofmaterialcategory = 'M'"@ls_entity-BillOfMaterialCategory
          AND billOfmaterialvariant = @ls_entity-billOfmaterialvariant
          AND HeaderChangeDocument = ''"@ls_entity-EngineeringChangeDocument
          AND material = @ls_entity-material
          AND plant = @ls_entity-plant
          AND BillOfMaterialVersion = ''
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
        MOVE-CORRESPONDING ls_add_d_failed-zmaterialbomitemadd   TO failed-zplantbomitem   KEEPING TARGET LINES.
        MOVE-CORRESPONDING ls_add_d_reported-zmaterialbomitemadd TO reported-zplantbomitem KEEPING TARGET LINES.

        "错误发生则返回
        RETURN.
      ENDIF.

    ENDIF.

* 3.1.3 创建自定义表 Item
    CHECK ls_bom_i_c_mapped IS NOT INITIAL OR ls_bom_hi_c_mapped IS NOT INITIAL.

    IF ls_bom_i_c_mapped IS NOT INITIAL.

      lt_bomitemadd_create = CORRESPONDING #( ls_bom_i_c_mapped-billofmaterialitem ).

    ELSE.

      lt_bomitemadd_create = CORRESPONDING #( ls_bom_hi_c_mapped-billofmaterialitem ).

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
        <fs_bomitemadd_create>-Yy1zzmkzc = ls_item-Yy1zzmkzc.
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
      MOVE-CORRESPONDING ls_add_c_failed-zmaterialbomitemadd   TO failed-zplantbomitem   KEEPING TARGET LINES.
      MOVE-CORRESPONDING ls_add_c_reported-zmaterialbomitemadd TO reported-zplantbomitem KEEPING TARGET LINES.
      " 错误发生，即返回
      RETURN.
    ENDIF.


  ENDMETHOD.

  METHOD update.
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
        FROM I_MaterialBOMLink
        WHERE BillOfMaterialCategory = 'M'"ls_key-BillOfMaterialCategory
          AND BillOfMaterialVariant = @ls_key-BillOfMaterialVariant
          AND BillOfMaterialVariantUsage = @ls_key-BillOfMaterialVariantUsage
          AND Material = @ls_key-Material
          AND Plant = @ls_key-Plant
     INTO @DATA(lv_BillOfMaterial).

    MODIFY ENTITIES OF I_BillOfMaterialTP_2 PRIVILEGED
       ENTITY BillOfMaterial
       DELETE FROM VALUE #( ( %key-billofmaterial = lv_BillOfMaterial
                              %key-billofmaterialcategory = 'M'"ls_key-BillOfMaterialCategory
                              %key-billOfmaterialvariant = ls_key-billOfmaterialvariant
                              %key-engineeringchangedocument = ''"ls_key-engineeringchangedocument
                              %key-material = ls_key-material
                              %key-plant = ls_key-plant
                              %key-BillOfMaterialVersion = '' ) )
        MAPPED DATA(ls_bom_d_mapped)
        FAILED DATA(ls_bom_d_failed)
        REPORTED DATA(ls_bom_d_reported).

    IF ls_bom_d_failed-billofmaterial IS NOT INITIAL.
      MOVE-CORRESPONDING ls_bom_d_failed-billofmaterial   TO failed-zplantbom   KEEPING TARGET LINES.
      MOVE-CORRESPONDING ls_bom_d_reported-billofmaterial TO reported-zplantbom KEEPING TARGET LINES.
    ELSEIF ls_bom_d_failed-billofmaterialitem IS NOT INITIAL.
      MOVE-CORRESPONDING ls_bom_d_failed-billofmaterialitem   TO failed-zplantbomitem   KEEPING TARGET LINES.
      MOVE-CORRESPONDING ls_bom_d_reported-billofmaterialitem TO reported-zplantbomitem KEEPING TARGET LINES.
    ENDIF.

* 更新自定义表字段
    DATA lt_bomitemadd_delete TYPE TABLE FOR DELETE zi_materialbomitemaddtp.

    IF ls_bom_d_failed IS INITIAL.

* 读取所有自定义表 Item
      SELECT BillOfMaterial, BillOfMaterialCategory, BillOfMaterialVariant, BillOfMaterialItemNodeNumber, BillOfMaterialVersion,
             HeaderChangeDocument, Material, Plant
          FROM zi_materialbomitemaddtp
          WHERE BillOfMaterial = @lv_BillOfMaterial
            AND billofmaterialcategory = 'M'"@ls_key-BillOfMaterialCategory
            AND billOfmaterialvariant = @ls_key-billOfmaterialvariant
            AND HeaderChangeDocument = ''"@ls_key-EngineeringChangeDocument
            AND material = @ls_key-material
            AND plant = @ls_key-plant
            AND BillOfMaterialVersion = ''
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
          MOVE-CORRESPONDING ls_add_d_failed-zmaterialbomitemadd   TO failed-zplantbomitem   KEEPING TARGET LINES.
          MOVE-CORRESPONDING ls_add_d_reported-zmaterialbomitemadd TO reported-zplantbomitem KEEPING TARGET LINES.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Plantbomitm.
  ENDMETHOD.

*  METHOD cba_Plantbomitm.
*  ENDMETHOD.

  METHOD ExplodeBOM.

    DATA: lt_PlantBOMExplodeBOMR TYPE TABLE OF ZD_PlantBOMExplodeBOMR.

    CHECK keys IS NOT INITIAL.

    READ TABLE keys INTO DATA(ls_key) INDEX 1.

* 初始化展BOM参数
    ls_key-%param-BillOfMaterialCategory = COND #( WHEN ls_key-%param-BillOfMaterialCategory IS INITIAL THEN 'M' ELSE ls_key-%param-BillOfMaterialCategory ).
    ls_key-%param-BillOfMaterialVariant = COND #( WHEN ls_key-%param-BillOfMaterialVariant IS INITIAL THEN '01' ELSE ls_key-%param-BillOfMaterialVariant ).
    ls_key-%param-BillOfMaterialVariantUsage = COND #( WHEN ls_key-%param-BillOfMaterialVariantUsage IS INITIAL THEN '1' ELSE ls_key-%param-BillOfMaterialVariantUsage ).
    ls_key-%param-BOMExplosionDate = COND #( WHEN ls_key-%param-BOMExplosionDate IS INITIAL THEN cl_abap_context_info=>get_system_date( ) ELSE ls_key-%param-BOMExplosionDate ).
    ls_key-%param-BOMExplosionApplication = COND #( WHEN ls_key-%param-BOMExplosionApplication IS INITIAL THEN 'PP01' ELSE ls_key-%param-BOMExplosionApplication ).
    ls_key-%param-RequiredQuantity = COND #( WHEN ls_key-%param-RequiredQuantity IS INITIAL THEN 1 ELSE ls_key-%param-RequiredQuantity ).

    ls_key-%param-billofmaterialvariant = |{ ls_key-%param-billofmaterialvariant ALPHA = IN }|.

* 获取BOM的ID
    SELECT SINGLE BillOfMaterial
        FROM I_MaterialBOMLink
        WHERE BillOfMaterialCategory = @ls_key-%param-BillOfMaterialCategory
          AND BillOfMaterialVariant = @ls_key-%param-BillOfMaterialVariant
          AND BillOfMaterialVariantUsage = @ls_key-%param-BillOfMaterialVariantUsage
          AND Material = @ls_key-%param-Material
          AND Plant = @ls_key-%param-Plant
     INTO @DATA(lv_BillOfMaterial).

* 展BOM
    READ ENTITIES OF I_BillOfMaterialTP_2 PRIVILEGED
        ENTITY BillOfMaterial
        EXECUTE ExplodeBOM
          FROM VALUE #(
            (
              billofmaterial = lv_BillOfMaterial
              plant          = ls_key-%param-plant
              material       = ls_key-%param-material
              EngineeringChangeDocument = ''
              BillOfMaterialVersion = ''
              billofmaterialcategory = ls_key-%param-BillOfMaterialCategory
              billofmaterialvariant = ls_key-%param-billofmaterialvariant
              %param = CORRESPONDING #( ls_key-%param )
            )
          )
          RESULT DATA(lt_ExplodeBOM_result)
          FAILED DATA(ls_ExplodeBOM_failed)
          REPORTED DATA(ls_ExplodeBOM_reported).


    IF ls_ExplodeBOM_failed IS NOT INITIAL.

      MOVE-CORRESPONDING ls_ExplodeBOM_failed  TO failed   KEEPING TARGET LINES.
      MOVE-CORRESPONDING ls_ExplodeBOM_reported TO reported KEEPING TARGET LINES.

    ELSE.

* 根据展BOM结果集生成输出列表
      LOOP AT lt_ExplodeBOM_result INTO DATA(ls_ExplodeBOM_result).

* 根据配置表：勾选激活的物料类型即可输出
        SELECT SINGLE @abap_true
            FROM zr_mtart_bom
            WHERE werk = @ls_ExplodeBOM_result-%param-plant
              AND mart = @ls_ExplodeBOM_result-%param-MaterialType
              AND aktiv = 'X'
              INTO @DATA(lv_exist).

        IF lv_exist IS INITIAL and 1 = 2.
          CONTINUE.
        ENDIF.

        CLEAR lv_exist.

        APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).

        <fs_result>-%cid = ls_key-%cid.
        <fs_result>-%param = CORRESPONDING #( ls_ExplodeBOM_result-%param ).

* 获取自定表字段数据
        SELECT SINGLE yy1_zzsac_prd, yy1_zzergg_prd
            FROM I_Product
            WHERE Product = @ls_ExplodeBOM_result-%param-BillOfMaterialComponent
            INTO (  @<fs_result>-%param-Sachnummer, @<fs_result>-%param-ErgnzungZurSachnummer ).


        SELECT SINGLE Yy1zzsee, Yy1zzbmk, Yy1zzbre, Yy1zzbkz, Yy1zzmkz1, Yy1zzmkz2,
                      Yy1zzsort, Yy1zzeao, Yy1zzfst, Yy1zzseh, Yy1erskz, Yy1zztxt, Yy1zzsic, Yy1zzmkzc
          FROM ZI_MaterialBOMItemAdd
          WHERE BillOfMaterial = @ls_ExplodeBOM_result-BillOfMaterial
            AND billofmaterialcategory = @ls_ExplodeBOM_result-billofmaterialcategory
            AND billofmaterialvariant = @ls_ExplodeBOM_result-billofmaterialvariant
            AND billofmaterialversion = @ls_ExplodeBOM_result-billofmaterialversion
            AND billofmaterialitemnodenumber = @ls_ExplodeBOM_result-%param-billofmaterialitemnodenumber
            AND headerchangedocument = @ls_ExplodeBOM_result-EngineeringChangeDocument
            AND material = @ls_ExplodeBOM_result-material
            AND plant = @ls_ExplodeBOM_result-plant
            INTO ( @<fs_result>-%param-yy1zzsee,
                   @<fs_result>-%param-Yy1zzbmk,
                   @<fs_result>-%param-Yy1zzbre,
                   @<fs_result>-%param-Yy1zzbkz,
                   @<fs_result>-%param-Yy1zzmkz1,
                   @<fs_result>-%param-Yy1zzmkz2,
                   @<fs_result>-%param-Yy1zzsort,
                   @<fs_result>-%param-Yy1zzeao,
                   @<fs_result>-%param-Yy1zzfst,
                   @<fs_result>-%param-Yy1zzseh,
                   @<fs_result>-%param-Yy1erskz,
                   @<fs_result>-%param-Yy1zztxt,
                   @<fs_result>-%param-Yy1zzsic,
                   @<fs_result>-%param-Yy1zzmkzc ) .

      ENDLOOP.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_PlantBOMItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ZPlantBOMItem.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ZPlantBOMItem.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZPlantBOMItem RESULT result.

    METHODS rba_Slsordbom FOR READ
      IMPORTING keys_rba FOR READ ZPlantBOMItem\_PlantBOM FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_ZI_PlantBOMItem IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Slsordbom.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_PLANTBOM DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_PLANTBOM IMPLEMENTATION.

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
