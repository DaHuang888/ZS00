@EndUserText.label: 'Sales Order BOM Info by Material + Plant'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_DPC_SALESORDERBOM'
define custom entity ZI_SlsOrdBOMInfoByMatPlt
 //with parameters parameter_name : parameter_type
{
  key Material : matnr;
  key Plant : abap.char( 4 );
  SalesOrder: abap.char( 10 );
  SalesOrderItem: abap.char( 6 );
  BillOfMaterialVariantUsage: abap.char( 1 );
 
}
