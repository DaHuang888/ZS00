@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Item Category Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BomItemCategoryText
  as select from I_BomItemCategoryText
{
  key BillOfMaterialItemCategory,
      BillOfMaterialItemCategoryDesc
}
where
  Language = $session.system_language
