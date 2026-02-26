@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant BOM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      //#LANGUAGE_DEPENDENT_TEXT,
                                      #SEARCHABLE_ENTITY
]

define root view entity ZI_PlantBOM
  as select from    I_MaterialBOMLink           as _PlantBOML
    left outer join I_BillOfMaterialHeaderDEX_2 as _PlantBOMH    on  _PlantBOMH.BillOfMaterialCategory = _PlantBOML.BillOfMaterialCategory
                                                                 and _PlantBOMH.BillOfMaterial         = _PlantBOML.BillOfMaterial
                                                                 and _PlantBOMH.BillOfMaterialVariant  = _PlantBOML.BillOfMaterialVariant
    left outer join I_Product                   as _Product      on _Product.Product = _PlantBOML.Material
    left outer join I_ProductPlantBasic         as _ProductPlant on  _ProductPlant.Product = _PlantBOML.Material
                                                                 and _ProductPlant.Plant   = _PlantBOML.Plant
    left outer join ZR_MTART_BOM                as _MtartBOM     on  _MtartBOM.Werk = _PlantBOML.Plant
                                                                 and _MtartBOM.Mart = _Product.ProductType
  composition [0..*] of ZI_PlantBOMItem as _PlantBOMItem
{

  key _PlantBOML.Material,
  key _PlantBOML.Plant,
      //key cast( _PlantBOML.BillOfMaterial as abap.char( 8 ) )                as BillOfMaterial,
  key _PlantBOML.BillOfMaterialVariantUsage,
  key _PlantBOMH.BillOfMaterialVariant,
      //key _PlantBOMH.HeaderEngineeringChgNmbrDoc                             as EngineeringChangeDocument,
      _PlantBOML.BillOfMaterialCategory,
      _Product._Text[1:Language = $session.system_language ].ProductName as ProductDescription,
      _Product.ProductType,
      _ProductPlant.ProcurementType,
      _PlantBOMH.BillOfMaterialStatus,
      _PlantBOMH.DeletionIndicator                                       as BOMIsToBeDeleted,
      _MtartBOM.Aktiv,
      cast( _PlantBOMH.BOMHeaderQuantityInBaseUnit as abap.dec( 13,3 ) ) as BOMHeaderQuantityInBaseUnit,
      _PlantBOMH.BOMHeaderBaseUnit,
      // Associations
      _PlantBOMItem

}
