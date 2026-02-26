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
define view entity ZI_PlantBOMItem
  as select from    I_MaterialBOMLink           as _PlantBOML
    left outer join I_BillOfMaterialItemDEX_3   as _PlantBOMI        on  _PlantBOMI.BillOfMaterialCategory = _PlantBOML.BillOfMaterialCategory
                                                                     and _PlantBOMI.BillOfMaterial         = _PlantBOML.BillOfMaterial
                                                                     and _PlantBOMI.BillOfMaterialVariant  = _PlantBOML.BillOfMaterialVariant
    left outer join I_BillOfMaterialHeaderDEX_2 as _PlantBOMH        on  _PlantBOMH.BillOfMaterialCategory = _PlantBOML.BillOfMaterialCategory
                                                                     and _PlantBOMH.BillOfMaterial         = _PlantBOML.BillOfMaterial
                                                                     and _PlantBOMH.BillOfMaterialVariant  = _PlantBOML.BillOfMaterialVariant
  //left outer join I_ProductDescription as _ProductDesc on _ProductDesc.Product = _SlsOrdBOMI.BillOfMaterialComponent
    left outer join I_Product                   as _Product          on _Product.Product = _PlantBOMI.BillOfMaterialComponent
    left outer join I_ProductPlantBasic         as _ProductPlant     on  _ProductPlant.Product = _PlantBOMI.BillOfMaterialComponent
                                                                     and _ProductPlant.Plant   = _PlantBOML.Plant
    left outer join I_ProductValuationBasic     as _ProductValuation on  _ProductValuation.Product       = _PlantBOMI.BillOfMaterialComponent
                                                                     and _ProductValuation.ValuationArea = _PlantBOML.Plant
    left outer join ZR_MTART_BOM                as _MtartBOM         on  _MtartBOM.Werk = _PlantBOML.Plant
                                                                     and _MtartBOM.Mart = _Product.ProductType
    left outer join ZI_MaterialBOMItemAdd       as _BOMItemAdd       on  _BOMItemAdd.Material                     = _PlantBOML.Material
                                                                     and _BOMItemAdd.Plant                        = _PlantBOML.Plant
                                                                     and _BOMItemAdd.BillOfMaterial               = _PlantBOML.BillOfMaterial
                                                                     and _BOMItemAdd.BillOfMaterialCategory       = _PlantBOML.BillOfMaterialCategory
                                                                     and _BOMItemAdd.BillOfMaterialVariant        = _PlantBOML.BillOfMaterialVariant
                                                                     and _BOMItemAdd.HeaderChangeDocument         = _PlantBOMH.HeaderEngineeringChgNmbrDoc
                                                                     and _BOMItemAdd.BillOfMaterialItemNodeNumber = _PlantBOMI.BillOfMaterialItemNodeNumber
                                                                     and _BOMItemAdd.BillOfMaterialVersion        = ''
  association to parent ZI_PlantBOM as _PlantBOM on  $projection.Material                   = _PlantBOM.Material
                                                 and $projection.Plant                      = _PlantBOM.Plant
                                                 and $projection.BillOfMaterialVariantUsage = _PlantBOM.BillOfMaterialVariantUsage
  //and $projection.BillOfMaterial            = _SlsOrdBOM.BillOfMaterial
  //and $projection.EngineeringChangeDocument = _PlantBOM.EngineeringChangeDocument
  //and $projection.BillOfMaterialCategory    = _PlantBOM.BillOfMaterialCategory
                                                 and $projection.BillOfMaterialVariant      = _PlantBOM.BillOfMaterialVariant
{


  key _PlantBOML.Material,
  key _PlantBOML.Plant,
      //key cast( _SlsOrdBOML.BillOfMaterial as abap.char( 8 ) )               as BillOfMaterial,
      //key _PlantBOML.BillOfMaterialCategory,
  key _PlantBOML.BillOfMaterialVariant,
  key _PlantBOML.BillOfMaterialVariantUsage,
      //key _PlantBOMH.HeaderEngineeringChgNmbrDoc                            as EngineeringChangeDocument,
  key _PlantBOMI.BillOfMaterialItemNodeNumber,
      _PlantBOMI.BillOfMaterialItemNumber,
      _PlantBOMI.BillOfMaterialItemCategory,
      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      _PlantBOMI.BillOfMaterialItemQuantity,
      _PlantBOMI.BillOfMaterialItemUnit,
      _PlantBOMI.BillOfMaterialComponent,
      _Product._Text[1:Language = $session.system_language].ProductName as ComponentDescription,
      cast( ''  as abap.char( 40 ) )                                    as ComponentAddIno,
      cast( ''  as abap.char( 1 ) )                                     as AssemblyIndicator,
      _Product.ProductType,
      _ProductPlant.ProductionInvtryManagedLoc,
      _ProductPlant.MRPType,
      _ProductPlant.ProcurementType,
      cast( _ProductValuation.StandardPrice as abap.dec(12,2))          as StandardPrice,
      _PlantBOMH.BillOfMaterialStatus,
      _ProductPlant.ProfileCode,
      _PlantBOMI.IsDeleted,
      _Product.IndustryStandardName,
      _PlantBOMI.BOMItemDescription,
      _MtartBOM.Aktiv,
      _PlantBOMI.BOMItemIsCostingRelevant,
      _PlantBOMI.IsEngineeringRelevant,
      _PlantBOMI.IsProductionRelevant,
      _PlantBOMI.BOMItemSorter,
      _PlantBOMI.BOMItemIsSparePart,
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
      // Associations
      _PlantBOM
}
