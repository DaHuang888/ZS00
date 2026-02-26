@EndUserText.label: 'Result for CopyBOM Action'
define root abstract entity ZD_SLSORDBOMCOPYR
  //with parameters parameter_name : parameter_type
{
  key Material                    : abap.char( 18 );
  key Plant                       : abap.char( 4 );
  //key BillOfMaterial              : abap.char( 8 );
  key BillOfMaterialCategory      : abap.char( 1 );
  key BillOfMaterialVariant       : abap.char( 2 );
  key EngineeringChangeDocument   : abap.char( 12 );
      SalesOrder                  : abap.char( 10 );
      SalesOrderItem              : abap.numc( 6 );
      ProductDescription          : abap.char( 40 );
      ProductType                 : abap.char( 4 );
      ProcurementType             : abap.char( 1 );
      BOMIsToBeDeleted            : abap_boolean;
      BillOfMaterialStatus        : abap.char( 2 );
      Aktiv                       : abap_boolean;
      BillOfMaterialVariantUsage  : abap.char( 1 );
      BOMHeaderQuantityInBaseUnit : abap.dec( 13,3);
      BOMHeaderBaseUnit           : abap.unit( 3 );
      _BOMHeaderToItem            : composition [0..*] of ZD_SLSORDBOMITEMCOPYR;


}
