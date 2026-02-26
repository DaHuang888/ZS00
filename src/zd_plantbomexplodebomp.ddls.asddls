@EndUserText.label: 'Parameter for ExplodeBOM'
define root abstract entity ZD_PlantBOMExplodeBOMP
  //with parameters parameter_name : parameter_type
{
  Material                   : matnr;
  Plant                      : werks_d;
  BillOfMaterialCategory     : abap.char(1);
  BillOfMaterialVariant      : abap.char(2);
  BillOfMaterialVariantUsage : abap.char(1);
  BOMExplosionApplication    : abap.char( 4 );
  //@Semantics.quantity.unitOfMeasure: 'BOMHeaderBaseUnit'
  RequiredQuantity           : abap.dec( 13,3 );
  //  BOMHeaderBaseUnit             : abap.unit( 3 );
  //  BOMExplosionIsLimited         : abap.char( 1 );
  //  BOMItmQtyIsScrapRelevant      : abap.char( 1 );
  BillOfMaterialItemCategory : abap.char(1);
  //  BOMExplosionAssembly          : matnr;
  BOMExplosionDate           : datuv;
  //  ExplodeBOMLevelValue          : abap.dec( 3 );
  BOMExplosionIsMultilevel      : abap.char( 1 );
  //  MaterialProvisionFltrType     : abap.char( 1 );
  //  SparePartFltrType             : abap.char( 1 );
  //  FinalPriceIndicator           : abap.char( 1 );
  //  BOMExplosionIsAlternatePrio   : abap.char( 1 );
  //  BillOfMaterialSimulationValue : cuobj;

}
