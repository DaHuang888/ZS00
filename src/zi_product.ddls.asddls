@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Info'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_product
  as select from I_Product as _product
{
  key _product.Product,
      _product._Text[1: Language=$session.system_language ].ProductName as ProductDescription,
      _product.ProductType,
      _product.IndustryStandardName,
      _product.BaseUnit
}
