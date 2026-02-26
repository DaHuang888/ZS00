@EndUserText.label: 'Material BOM'
define custom entity ZI_MATERIALBOM_UQ
  //with parameters parameter_name : parameter_type
{
  key BillOfMaterial             : abap.char( 8 );
  key BillOfMaterialCategory     : abap.char( 1 );
  key BillOfMaterialVariant      : abap.char( 2 );
  key BillOfMaterialVersion      : abap.char( 4 );
  key EngineeringChangeDocument  : abap.char( 12 );
  key Material                   : abap.char( 40 );
  key Plant                      : abap.char( 4 );
      ProductType                : abap.char( 4 );
      ProductDescription         : abap.char( 40 );
      ProcurementType            : abap.char( 1 );
      BillOfMaterialStatus       : abap.char( 2 );
      BillOfMaterialVariantUsage : abap.char( 1 );
      BOMIsToBeDeleted           : abap.char( 1 );

}
