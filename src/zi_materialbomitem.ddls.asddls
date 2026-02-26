@EndUserText.label: 'Material BOM Item'
define custom entity ZI_MaterialBOMItem
  //with parameters parameter_name : parameter_type
{
  key BillOfMaterial               : abap.char( 8 );
  key BillOfMaterialCategory       : abap.char( 1 );
  key BillOfMaterialVariant        : abap.char( 2 );
  key BillOfMaterialVersion        : abap.char( 4 );
  key BillOfMaterialItemNodeNumber : abap.numc( 8 );
  key HeaderChangeDocument         : abap.char( 12 );
  key Material                     : abap.char( 40 );
  key Plant                        : abap.char( 4 );
      BillOfMaterialComponent      : abap.char( 40 );
      BillOfMaterialItemCategory   : abap.char( 1 );
      BillOfMaterialItemNumber     : abap.char( 4 );
      BillOfMaterialItemUnit       : abap.unit( 3 );
      BillOfMaterialItemQuantity   : abap.dec( 13,3 );
      ComponentDescription         : abap.char( 4 );
      IsDeleted                    : abap.char( 40 );
      BOMItemDescription           : abap.char( 40 );
      ComponentAddIno              : abap.char( 40 );
      AssemblyIndicator            : abap.char( 40 );
      ProductType                  : abap.char( 4 );
      IndustryStandardName         : abap.char( 18 );
      ProductionInvtryManagedLoc   : abap.char( 4 );
      MRPType                      : abap.char( 2 );
      ProcurementType              : abap.char( 1 );
      BillOfMaterialStatus         : abap.numc( 2 );
      StandardPrice                : abap.dec( 11,2 );
      YY1_ZZSEE_1                  : abap.char( 1 );
      YY1_ZZBMK                    : abap.char( 18 );
      YY1_ZZBRE_1                  : abap.char( 2 );
      YY1_ZZBKZ_1                  : abap.char( 1 );
      YY1_ZZMKZ1                   : abap.char( 1 );
      YY1_ZZMKZ2                   : abap.char( 1 );
      YY1_ZZSORT                   : abap.char( 20 );
      YY1_ZZEAO                    : abap.char( 7 );
      YY1_ZZFST                    : abap.char( 6 );
      YY1_ZZSEH                    : abap.char( 6 );
      YY1_ERSKZ                    : abap.char( 1 );
      YY1_ZZTXT                    : abap.char( 2 );
      YY1_ZZSIC_1                  : abap.char( 1 );
}
