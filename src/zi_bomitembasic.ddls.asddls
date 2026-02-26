@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Item Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOMItemBasic
  as select from I_BillOfMaterialItemBasic
{
  key cast( BillOfMaterial as abap.char( 8 ) ) as BillOfMaterial,
  key BillOfMaterialComponent,
      IsMaterialProvision,
      BOMItemIsSparePart
}
