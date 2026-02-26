@EndUserText.label: 'Result for ExplodeBOM'
define root abstract entity ZD_PlantBOMExplodeBOMR
  //with parameters parameter_name : parameter_type
{
  ExplodeBOMLevelValue       : abap.dec( 2,0 );
  BillOfMaterialItemNumber   : abap.char( 4 );
  Plant                      : abap.char( 4 );
  BillOfMaterialComponent    : abap.char( 40 );
  BillOfMaterialItemQuantity : abap.dec( 13,3 );
  BillOfMaterialItemUnit     : abap.unit( 3 );
  ComponentDescription       : abap.char( 40 );
  Sachnummer                 : abap.char( 14 );
  ErgnzungZurSachnummer      : abap.char( 50 );
  StorageLocation            : abap.char( 4 );
  StandardPrice              : abap.dec( 11,2 );
  ProcurementType            : abap.char( 1 );
  yy1zzsee                   : abap.char( 1 );
  yy1zzbmk                   : abap.char( 18 );
  yy1zzbre                   : abap.char( 2 );
  yy1zzbkz                   : abap.char( 1 );
  yy1zzmkz1                  : abap.char( 1 );
  yy1zzmkz2                  : abap.char( 1 );
  yy1zzsort                  : abap.char( 20 );
  yy1zzeao                   : abap.char( 7 );
  yy1zzfst                   : abap.char( 6 );
  yy1zzseh                   : abap.char( 6 );
  yy1erskz                   : abap.char( 1 );
  yy1zztxt                   : abap.char( 2 );
  yy1zzsic                   : abap.char( 1 );
  yy1zzmkzc                  : abap.char(1);
}
