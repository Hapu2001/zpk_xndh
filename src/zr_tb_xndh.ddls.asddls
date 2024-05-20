@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Model TB XNDH'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZR_TB_XNDH
  as select from I_SalesOrder
  association [1..1] to I_SalesOrderItem as _Item on $projection.SalesOrder = _Item.SalesOrder
  association [1..1] to ztb_pp_xndh_his  as _ztb  on $projection.SalesOrder = _ztb.vbeln
  composition [0..*] of ZR_TB_XNDH_HIS   as _Childrent
{
  key SalesOrder                 as SalesOrder,
      _Item.Product              as Product,
      _Item.SalesOrderItemText   as SalesOrderItemText,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      _Item.OrderQuantity        as OrderQuantity,
      _Item.OrderQuantityUnit    as OrderQuantityUnit,
      CreationDate               as CreationDate,
      RequestedDeliveryDate      as RequestedDeliveryDate,
      _ztb.znbdsx                as StartDate,
      _ztb.znht                  as ConfirmDate,
      _ztb.zslcs                 as SlEdit,
      @Semantics.user.createdBy: true
      _ztb.created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _ztb.created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      _ztb.last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _ztb.last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      _ztb.local_last_changed_at as LocalLastChangedAt,
      _Childrent

}
