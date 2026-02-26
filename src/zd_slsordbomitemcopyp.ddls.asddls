@EndUserText.label: 'Parameter for CopyBOM Action'
define abstract entity ZD_SLSORDBOMITEMCOPYP
{
  key BillOfMaterial            : abap.char( 8 );
  key BillOfMaterialCategory    : abap.char( 1 );
  key BillOfMaterialVariant     : abap.char( 2 );
  key EngineeringChangeDocument : abap.char( 12 );
  key Material                  : abap.char( 40 );
  key Plant                     : abap.char( 4 );
  key BillOfMaterialItemNumber  : abap.char( 4 );
  key BillOfMaterialComponent   : abap.char( 40 );
  
  _BOMItemToHeader             : association to parent ZD_SLSORDBOMCOPYP on  $projection.Material                  = _BOMItemToHeader.Material
                                                                             and $projection.Plant                     = _BOMItemToHeader.Plant
                                                                            and $projection.BillOfMaterial            = _BOMItemToHeader.BillOfMaterial
                                                                             and $projection.BillOfMaterialCategory    = _BOMItemToHeader.BillOfMaterialCategory
                                                                             and $projection.BillOfMaterialVariant     = _BOMItemToHeader.BillOfMaterialVariant
                                                                             and $projection.EngineeringChangeDocument = _BOMItemToHeader.EngineeringChangeDocument;

}
