@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Production Orders'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZS4H_C_PRODORD
  as projection on zs4h_r_prodord
{
      key Id,
      AttachId,
      ManuOrderType,
      Material,
      ProdPlant,
      MrpController,
      OrderPlannedStartdate,
      OrderPlannedStarttime,
      OrderPlannedEnddate,
      OrderPlannedEndtime,
      TotalQnty,
      Supervisor,
      ProdUnit,
      _attach.LastChangedAt,
      /* Associations */
      _attach : redirected to parent ZS4H_C_EXCELFILE
}
