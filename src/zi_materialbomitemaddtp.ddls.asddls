@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material BOM Item Additional Info TP'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_MATERIALBOMITEMADDTP
  provider contract transactional_interface
  as projection on ZR_MATERIALBOMITEMADDTP
{
  key BillOfMaterial,
  key BillOfMaterialCategory,
  key BillOfMaterialVariant,
  key BillOfMaterialVersion,
  key BillOfMaterialItemNodeNumber,
  key HeaderChangeDocument,
  key Material,
  key Plant,
      Yy1zzsee,
      Yy1zzbmk,
      Yy1zzbre,
      Yy1zzbkz,
      Yy1zzmkz1,
      Yy1zzmkz2,
      Yy1zzsort,
      Yy1zzeao,
      Yy1zzfst,
      Yy1zzseh,
      Yy1erskz,
      Yy1zztxt,
      Yy1zzsic,
      Yy1zzmkzc,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
