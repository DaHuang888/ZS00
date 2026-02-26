@EndUserText.label: 'Parameters for Order BOM Explosion'
define abstract entity ZD_SLSORDBOMExplodeBOMP
  //with parameters parameter_name : parameter_type
{
  SalesOrder              : vbeln;
  SalesOrderItem          : abap.numc( 6 );
  BOMExplosionApplication : abap.char( 4 );
  RequiredQuantity        : abap.dec( 13,3 );
  BOMHeaderBaseUnit       : abap.unit( 3 );

}
