@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material BOM Item Additional Info TP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZR_MATERIALBOMITEMADDTP as select from ZI_MaterialBOMItemAdd
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
    @Semantics.user.createdBy: true
    CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    CreatedAt,
    @Semantics.user.lastChangedBy: true
    LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    LastChangedAt,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    LocalLastChangedAt
}
