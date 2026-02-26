@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Valuation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ProductValuation
  as select from I_ProductValuationBasic
{
  key Product,
  key ValuationArea                          as Plant,
      cast( StandardPrice as abap.dec(12,2)) as StandardPrice
}
