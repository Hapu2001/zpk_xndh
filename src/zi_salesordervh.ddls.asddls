@AbapCatalog.sqlViewName: 'ZISALESORDERVH'
@AbapCatalog.compiler.compareFilter: true

@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.representativeKey: 'SalesOrder'
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_SalesOrderVH'

@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #X
@ObjectModel.usageType.sizeCategory: #S


@Search.searchable: true
@Consumption.ranked: true
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE,#CDS_MODELING_DATA_SOURCE,#CDS_MODELING_ASSOCIATION_TARGET,#LANGUAGE_DEPENDENT_TEXT]

define view ZI_SalesOrderVH
  as select from I_SalesOrder
{
     
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key SalesOrder,
      SalesOrderProcessingType 
}
