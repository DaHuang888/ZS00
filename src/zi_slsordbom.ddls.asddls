@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order BOM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      //#LANGUAGE_DEPENDENT_TEXT,
                                      #SEARCHABLE_ENTITY
]
define root view entity ZI_SlsOrdBOM
  as select from    I_SalesOrderBOMLink      as _SlsOrdBOML
    left outer join I_SalesOrderBOMHeaderDEX as _SlsOrdBOMH   on  _SlsOrdBOMH.BillOfMaterialCategory = _SlsOrdBOML.BillOfMaterialCategory
                                                              and _SlsOrdBOMH.BillOfMaterial         = _SlsOrdBOML.BillOfMaterial
                                                              and _SlsOrdBOMH.BillOfMaterialVariant  = _SlsOrdBOML.BillOfMaterialVariant
    left outer join I_Product                as _Product      on _Product.Product = _SlsOrdBOML.Material
    left outer join I_ProductPlantBasic      as _ProductPlant on  _ProductPlant.Product = _SlsOrdBOML.Material
                                                              and _ProductPlant.Plant   = _SlsOrdBOML.Plant
    left outer join ZR_MTART_BOM             as _MtartBOM     on  _MtartBOM.Werk = _SlsOrdBOML.Plant
                                                              and _MtartBOM.Mart = _Product.ProductType
  composition [0..*] of ZI_SlsOrdBOMItem as _SlsOrdBOMItm
{

  key _SlsOrdBOML.Material,
  key _SlsOrdBOML.Plant,
  //key cast( _SlsOrdBOML.BillOfMaterial as abap.char( 8 ) )                as BillOfMaterial,
  key _SlsOrdBOML.BillOfMaterialVariantUsage,
  key _SlsOrdBOMH.BillOfMaterialVariant,
  //key _SlsOrdBOMH.HeaderEngineeringChgNmbrDoc                             as EngineeringChangeDocument,
  key _SlsOrdBOML.SalesOrder,
  key _SlsOrdBOML.SalesOrderItem,
      _SlsOrdBOML.BillOfMaterialCategory,
      _Product._Text[1:Language = $session.system_language ].ProductName  as ProductDescription,
      _Product.ProductType,
      _ProductPlant.ProcurementType,
      _SlsOrdBOMH.BillOfMaterialStatus,
      _SlsOrdBOMH.DeletionIndicator                                       as BOMIsToBeDeleted,
      _MtartBOM.Aktiv,
      cast( _SlsOrdBOMH.BOMHeaderQuantityInBaseUnit as abap.dec( 13,3 ) ) as BOMHeaderQuantityInBaseUnit,
      _SlsOrdBOMH.BOMHeaderBaseUnit,
      // Associations
      _SlsOrdBOMItm

}
