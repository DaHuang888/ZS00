@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material BOM Item Additional Info'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MaterialBOMItemAdd
  as select from ztmatbomitemadd
{
  key billofmaterial               as BillOfMaterial,
  key billofmaterialcategory       as BillOfMaterialCategory,
  key billofmaterialvariant        as BillOfMaterialVariant,
  key billofmaterialversion        as BillOfMaterialVersion,
  key billofmaterialitemnodenumber as BillOfMaterialItemNodeNumber,
  key headerchangedocument         as HeaderChangeDocument,
  key material                     as Material,
  key plant                        as Plant,
      yy1zzsee                     as Yy1zzsee,
      yy1zzbmk                     as Yy1zzbmk,
      yy1zzbre                     as Yy1zzbre,
      yy1zzbkz                     as Yy1zzbkz,
      yy1zzmkz1                    as Yy1zzmkz1,
      yy1zzmkz2                    as Yy1zzmkz2,
      yy1zzsort                    as Yy1zzsort,
      yy1zzeao                     as Yy1zzeao,
      yy1zzfst                     as Yy1zzfst,
      yy1zzseh                     as Yy1zzseh,
      yy1erskz                     as Yy1erskz,
      yy1zztxt                     as Yy1zztxt,
      yy1zzsic                     as Yy1zzsic,
      yy1zzmkzc                    as Yy1zzmkzc,
      @Semantics.user.createdBy: true
      createdby                    as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      createdat                    as CreatedAt,
      @Semantics.user.lastChangedBy: true
      lastchangedby                as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat                as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat           as LocalLastChangedAt
}
