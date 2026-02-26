@EndUserText.label: 'Parameter for CopyBOM Action'
define root abstract entity ZD_SLSORDBOMCOPYP
  //with parameters parameter_name : parameter_type
{
  key BillOfMaterial            : abap.char( 8 );
  key BillOfMaterialCategory    : abap.char( 1 );
  key BillOfMaterialVariant     : abap.char( 2 );
  key EngineeringChangeDocument : abap.char( 12 );
  key Material                  : abap.char( 40 );
  key Plant                     : abap.char( 4 );
      SalesOrder                : abap.char( 10 );
      SalesOrderItem            : abap.numc( 6 );
//      BillOfMaterialItemNumber  : abap.char( 4 );
//      BillOfMaterialComponent   : abap.char( 40 );
      CopyFromItemNumber        : abap.char( 4 );
      QuantityFactor            : abap.numc( 4 );
      MitFMenge                 : abap.char( 1 );
      WidthOfItemNumber         : abap.numc( 4 );
       _BOMHeaderToItem           : composition [0..*] of ZD_SLSORDBOMITEMCOPYP;
}
