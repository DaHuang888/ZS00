@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order BOM by Material + Plant'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//define view entity ZI_SlsOrdBOMByMatPlt as select from I_SalesOrderBOMLink
//{
//    key Material,
//    key Plant,
//    key BillOfMaterialVariantUsage,
//    key SalesOrder,
//    key SalesOrderItem,
//    BillOfMaterialCategory
//}

define view entity ZI_SlsOrdBOMByMatPlt
  as select from I_SalesOrderItem
{
  key SalesOrder,
  key SalesOrderItem,
      Material,
      Plant
}
