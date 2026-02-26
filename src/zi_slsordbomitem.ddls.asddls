@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order BOM Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      //#LANGUAGE_DEPENDENT_TEXT,
                                      #SEARCHABLE_ENTITY
]
define view entity ZI_SlsOrdBOMItem
  as select from    I_SalesOrderBOMLink      as _SlsOrdBOML
    left outer join I_SalesOrderBOMItemDEX   as _SlsOrdBOMI       on  _SlsOrdBOMI.BillOfMaterialCategory = _SlsOrdBOML.BillOfMaterialCategory
                                                                  and _SlsOrdBOMI.BillOfMaterial         = _SlsOrdBOML.BillOfMaterial
                                                                  and _SlsOrdBOMI.BillOfMaterialVariant  = _SlsOrdBOML.BillOfMaterialVariant
    left outer join I_SalesOrderBOMHeaderDEX as _SlsOrdBOMH       on  _SlsOrdBOMH.BillOfMaterialCategory = _SlsOrdBOML.BillOfMaterialCategory
                                                                  and _SlsOrdBOMH.BillOfMaterial         = _SlsOrdBOML.BillOfMaterial
                                                                  and _SlsOrdBOMH.BillOfMaterialVariant  = _SlsOrdBOML.BillOfMaterialVariant
  //left outer join I_ProductDescription as _ProductDesc on _ProductDesc.Product = _SlsOrdBOMI.BillOfMaterialComponent
    left outer join I_Product                as _Product          on _Product.Product = _SlsOrdBOMI.BillOfMaterialComponent
    left outer join I_ProductPlantBasic      as _ProductPlant     on  _ProductPlant.Product = _SlsOrdBOMI.BillOfMaterialComponent
                                                                  and _ProductPlant.Plant   = _SlsOrdBOML.Plant
    left outer join I_ProductValuationBasic  as _ProductValuation on  _ProductValuation.Product       = _SlsOrdBOMI.BillOfMaterialComponent
                                                                  and _ProductValuation.ValuationArea = _SlsOrdBOML.Plant
    left outer join ZR_MTART_BOM             as _MtartBOM         on  _MtartBOM.Werk = _SlsOrdBOML.Plant
                                                                  and _MtartBOM.Mart = _Product.ProductType
    left outer join ZI_MaterialBOMItemAdd    as _BOMItemAdd       on  _BOMItemAdd.Material                     = _SlsOrdBOML.Material
                                                                  and _BOMItemAdd.Plant                        = _SlsOrdBOML.Plant
                                                                  and _BOMItemAdd.BillOfMaterial               = _SlsOrdBOML.BillOfMaterial
                                                                  and _BOMItemAdd.BillOfMaterialCategory       = _SlsOrdBOML.BillOfMaterialCategory
                                                                  and _BOMItemAdd.BillOfMaterialVariant        = _SlsOrdBOML.BillOfMaterialVariant
                                                                  and _BOMItemAdd.HeaderChangeDocument         = _SlsOrdBOMH.HeaderEngineeringChgNmbrDoc
                                                                  and _BOMItemAdd.BillOfMaterialItemNodeNumber = _SlsOrdBOMI.BillOfMaterialItemNodeNumber
                                                                  and _BOMItemAdd.BillOfMaterialVersion        = ''
    association [0..1] to I_MaterialBOMLink                  as _AssemblyPlantBOM  on  $projection.BillOfMaterialComponent = _AssemblyPlantBOM.Material
                                                                          and $projection.Plant                   = _AssemblyPlantBOM.Plant
    association [0..1] to I_SalesOrderBOMLink                  as _AssemblySalesOrderBOM on  $projection.BillOfMaterialComponent = _AssemblySalesOrderBOM.Material
                                                                          and $projection.Plant          = _AssemblySalesOrderBOM.Plant 
                                                                          and $projection.SalesOrder     = _AssemblySalesOrderBOM.SalesOrder
                                                                          and $projection.SalesOrderItem = _AssemblySalesOrderBOM.SalesOrderItem    
  association to parent ZI_SlsOrdBOM as _SlsOrdBOM on  $projection.Material                   = _SlsOrdBOM.Material
                                                   and $projection.Plant                      = _SlsOrdBOM.Plant
                                                   and $projection.BillOfMaterialVariantUsage = _SlsOrdBOM.BillOfMaterialVariantUsage
                                                   and $projection.SalesOrder                 = _SlsOrdBOM.SalesOrder
                                                   and $projection.SalesOrderItem             = _SlsOrdBOM.SalesOrderItem
  //and $projection.BillOfMaterial            = _SlsOrdBOM.BillOfMaterial
  //and $projection.EngineeringChangeDocument = _SlsOrdBOM.EngineeringChangeDocument
  //and $projection.BillOfMaterialCategory    = _SlsOrdBOM.BillOfMaterialCategory
                                                   and $projection.BillOfMaterialVariant      = _SlsOrdBOM.BillOfMaterialVariant
{


  key _SlsOrdBOML.Material,
  key _SlsOrdBOML.Plant,
      //key cast( _SlsOrdBOML.BillOfMaterial as abap.char( 8 ) )               as BillOfMaterial,
      //key _SlsOrdBOML.BillOfMaterialCategory,
  key _SlsOrdBOML.BillOfMaterialVariantUsage,
  key _SlsOrdBOML.BillOfMaterialVariant,
      //key _SlsOrdBOMH.HeaderEngineeringChgNmbrDoc                            as EngineeringChangeDocument,
  key _SlsOrdBOML.SalesOrder,
  key _SlsOrdBOML.SalesOrderItem,
  key _SlsOrdBOMI.BillOfMaterialItemNodeNumber,
      _SlsOrdBOMI.BillOfMaterialItemNumber,
      _SlsOrdBOMI.BillOfMaterialItemCategory,

      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      _SlsOrdBOMI.BillOfMaterialItemQuantity,
      _SlsOrdBOMI.BillOfMaterialItemUnit,
      _SlsOrdBOMI.BillOfMaterialComponent,
      _Product._Text[1:Language = $session.system_language].ProductName as ComponentDescription,
      cast( ''  as abap.char( 40 ) )                                    as ComponentAddIno,
      cast( ''  as abap.char( 1 ) )                                     as AssemblyIndicator,
      _Product.ProductType,
      _ProductPlant.ProductionInvtryManagedLoc,
      _ProductPlant.MRPType,
      _ProductPlant.ProcurementType,
      cast( _ProductValuation.StandardPrice as abap.dec(12,2))          as StandardPrice,
      _SlsOrdBOMH.BillOfMaterialStatus,
      _ProductPlant.ProfileCode,
      _SlsOrdBOMI.IsDeleted,
      _Product.IndustryStandardName,
      _SlsOrdBOMI.BOMItemDescription,
      _MtartBOM.Aktiv,
      _SlsOrdBOMI.BOMItemIsCostingRelevant,
      _SlsOrdBOMI.IsEngineeringRelevant,
      _SlsOrdBOMI.IsProductionRelevant,
      _SlsOrdBOMI.BOMItemSorter,
      //_SlsOrdBOMI.BOMItemIsSparePart,
      _Product.YY1_ZZERC_PRD                                            as Yy1zzerc,
      _BOMItemAdd.Yy1zzsee,
      _BOMItemAdd.Yy1zzbmk,
      _BOMItemAdd.Yy1zzbre,
      _BOMItemAdd.Yy1zzbkz,
      _BOMItemAdd.Yy1zzmkz1,
      _BOMItemAdd.Yy1zzmkz2,
      _BOMItemAdd.Yy1zzsort,
      _BOMItemAdd.Yy1zzeao,
      _BOMItemAdd.Yy1zzfst,
      _BOMItemAdd.Yy1zzseh,
      _BOMItemAdd.Yy1erskz,
      _BOMItemAdd.Yy1zztxt,
      _BOMItemAdd.Yy1zzsic,
      _BOMItemAdd.Yy1zzmkzc,
       _SlsOrdBOMI.IsMaterialProvision,
       _SlsOrdBOMI.BOMItemIsSparePart,
       @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
       _SlsOrdBOMI.Size1,
       @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
       _SlsOrdBOMI.Size2,
       @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
       _SlsOrdBOMI.Size3,
       _SlsOrdBOMI.UnitOfMeasureForSize1To3,
       _SlsOrdBOMI.FormulaKey,
       @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
       _SlsOrdBOMI.QuantityVariableSizeItem,
       case 
         when ( _AssemblySalesOrderBOM.Material is not null or _AssemblySalesOrderBOM.Material !='' )
         then cast('X' as char1)
         else cast(' ' as char1) 
       end as IsAssemblySalesOrder,// 若为X则可以调用销售BOM查询服务
       
       case 
         when ( _AssemblyPlantBOM.Material is not null or _AssemblyPlantBOM.Material !='' )
         then cast('X' as char1)
         else cast(' ' as char1) 
       end as IsAssemblyPlant, // 若为X则可以调用工厂BOM查询服务

      // Associations
      _SlsOrdBOM
}
