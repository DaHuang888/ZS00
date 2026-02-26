@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bill Of Material Usage Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.supportedCapabilities: [ #VALUE_HELP_PROVIDER ]
@Analytics.technicalName: 'IBOMUSAGE_VH'
@ObjectModel.representativeKey: 'BillOfMaterialVariantUsage'
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOMUsageVH
  as select from I_BillOfMaterialUsageStdVH
{
      @ObjectModel.text.element: ['BillOfMaterialVariantUsageDesc']
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.8
  key BillOfMaterialVariantUsage,
      //   @Semantics.language: true
      //   @UI.hidden: true
      //  key Language,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      BillOfMaterialVariantUsageDesc
}
