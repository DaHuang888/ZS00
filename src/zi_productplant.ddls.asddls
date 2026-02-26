@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Plant Info'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_productplant
  as select from I_ProductPlantBasic as _ProductPlantBasic
{
  key _ProductPlantBasic.Product,
  key _ProductPlantBasic.Plant,
      _ProductPlantBasic.ProcurementType,
      _ProductPlantBasic.ProductionInvtryManagedLoc,
      _ProductPlantBasic.ProfileCode
}
