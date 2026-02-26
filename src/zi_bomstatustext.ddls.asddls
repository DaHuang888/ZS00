@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Status Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOMStatusText
  as select from I_BillOfMaterialStatusText
{
  key BillOfMaterialStatus,
      BillOfMaterialStatusText

}
where
  Language = $session.system_language
