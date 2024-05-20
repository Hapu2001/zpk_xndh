@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Model các lần chỉnh sửa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZR_TB_XNDH_HIS
  as select from ztb_pp_xndh
  association [1..1] to I_SalesOrderItem  as _Item       on $projection.SalesOrder = _Item.SalesOrder
  association [1..1] to I_SalesOrder      as _SalesOrder on $projection.SalesOrder = _SalesOrder.SalesOrder
  association        to parent ZR_TB_XNDH as _Header     on $projection.SalesOrder = _Header.SalesOrder
{
  key vbeln                             as SalesOrder,
  key zlcs                              as SoLanChinhSua,
      _Item.Product                     as Product,
      _Item.SalesOrderItemText          as SalesOrderItemText,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      _Item.OrderQuantity               as OrderQuantity,
      _Item.OrderQuantityUnit           as OrderQuantityUnit,
      _SalesOrder.CreationDate          as CreationDate,
      _SalesOrder.RequestedDeliveryDate as RequestedDeliveryDate,
      znbdsx                            as StartDate,
      znht                              as ConfirmDate,
      created_by                        as CreatedBy,
      created_at                        as CreatedAt,
      last_changed_by                   as LastChangedBy,
      last_changed_at                   as LastChangedAt,
      local_last_changed_at             as LocalLastChangedAt,

      _Header
}
