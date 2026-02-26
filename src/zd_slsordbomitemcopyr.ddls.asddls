@EndUserText.label: 'Result for CopyBOM Action'
define abstract entity ZD_SLSORDBOMITEMCOPYR
  //with parameters parameter_name : parameter_type
{
  key Material                     : abap.char( 18 );
  key Plant                        : abap.char( 4 );
  //key BillOfMaterial               : abap.char( 8 );
  key BillOfMaterialCategory       : abap.char( 1 );
  key BillOfMaterialVariant        : abap.char( 2 );
  key EngineeringChangeDocument    : abap.char( 12 );
  key BillOfMaterialItemNodeNumber : abap.char( 8 );
      BillOfMaterialItemNumber     : abap.char( 4 );
      BillOfMaterialItemCategory   : abap.char( 1 );
      BillOfMaterialVariantUsage   : abap.char( 1 );
      SalesOrder                   : abap.char( 10 );
      SalesOrderItem               : abap.numc( 6 );
      BillOfMaterialItemQuantity   : abap.dec( 13,3 );
      BillOfMaterialItemUnit       : abap.unit( 3 );
      BillOfMaterialComponent      : abap.char( 18 );
      ComponentDescription         : abap.char( 40 );
      ComponentAddIno              : abap.char( 40 );
      AssemblyIndicator            : abap.char( 1 );
      ProductType                  : abap.char( 4 );
      ProductionInvtryManagedLoc   : abap.char( 4 );
      MRPType                      : abap.char( 2 );
      ProcurementType              : abap.char( 1 );
      StandardPrice                : abap.dec( 12,2 );
      BillOfMaterialStatus         : abap.char( 2 );
      ProfileCode                  : abap.char( 2 );
      IsDeleted                    : abap_boolean;
      IndustryStandardName         : abap.char( 18 );
      BOMItemDescription           : abap.char( 40 );
      BOMItemIsCostingRelevant     : abap.char( 1 );
      IsEngineeringRelevant        : abap_boolean;
      IsProductionRelevant         : abap_boolean;
      BOMItemSorter                : abap.char( 2 );
      BOMItemIsSparePart           : abap.char( 1 );
      Aktiv                        : abap_boolean;
      Yy1zzerc                     : abap.char( 50 );
      Yy1zzsee                     : abap.char( 1 );
      Yy1zzbmk                     : abap.char( 18 );
      Yy1zzbre                     : abap.char( 2 );
      Yy1zzbkz                     : abap.char( 1 );
      Yy1zzmkz1                    : abap.char( 1 );
      Yy1zzmkz2                    : abap.char( 1 );
      Yy1zzsort                    : abap.char( 20 );
      Yy1zzeao                     : abap.char( 7 );
      Yy1zzfst                     : abap.char( 6 );
      Yy1zzseh                     : abap.char( 6 );
      Yy1erskz                     : abap.char( 1 );
      Yy1zztxt                     : abap.char( 2 );
      Yy1zzsic                     : abap.char( 1 );
      _BOMItemToHeader             : association to parent ZD_SLSORDBOMCOPYR on  $projection.Material                  = _BOMItemToHeader.Material
                                                                             and $projection.Plant                     = _BOMItemToHeader.Plant
                                                                             //and $projection.BillOfMaterial            = _BOMItemToHeader.BillOfMaterial
                                                                             and $projection.BillOfMaterialCategory    = _BOMItemToHeader.BillOfMaterialCategory
                                                                             and $projection.BillOfMaterialVariant     = _BOMItemToHeader.BillOfMaterialVariant
                                                                             and $projection.EngineeringChangeDocument = _BOMItemToHeader.EngineeringChangeDocument;
}
