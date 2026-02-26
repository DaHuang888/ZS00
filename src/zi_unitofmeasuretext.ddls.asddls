@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unit Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_UnitOfMeasureText
  as select from I_UnitOfMeasureText
{
  key UnitOfMeasure,
      UnitOfMeasureName
}
where
  Language = $session.system_language
