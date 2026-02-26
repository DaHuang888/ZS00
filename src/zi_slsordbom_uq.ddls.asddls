@EndUserText.label: 'Sales Order BOM Unmanaged Query'
define root custom entity ZI_SlsOrdBOM_UQ
 with parameters P_ValidityStartDate : abap.dats 
{

  key Material: abap.char( 18 );
  key Plant : abap.char( 4 );
  key BillOfMaterialVariantUsage: abap.char( 1 );
  key SalesOrder : abap.char( 10 );
  key SalesOrderItem : abap.char( 6 );
  key BillOfMaterialCategory : abap.char( 1 );
  ValidityStartDate: abap.dats ;
  ValidityEndDate: abap.dats ;
  BOMHeaderText: abap.char( 40 );
  BillOfMaterialStatus: abap.char( 2 );
  IsMarkedForDeletion: abap.char( 1 );
  
  //
  
}
