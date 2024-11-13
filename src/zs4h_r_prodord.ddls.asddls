@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Model View for Production Orders'
@Metadata.ignorePropagatedAnnotations: true
define view entity zs4h_r_prodord as select from zs4h_prodord_a as _prodorder
association to parent ZS4H_R_EXCELFILE as _attach
    on $projection.AttachId = _attach.AttachId
{
    key _prodorder.id as Id,
    _prodorder.attach_id as AttachId,
    _prodorder.manu_order_type as ManuOrderType,
    _prodorder.material as Material,
    _prodorder.prod_plant as ProdPlant,
    _prodorder.mrp_controller as MrpController,
    _prodorder.order_planned_startdate as OrderPlannedStartdate,
    _prodorder.order_planned_starttime as OrderPlannedStarttime,
    _prodorder.order_planned_enddate as OrderPlannedEnddate,
    _prodorder.order_planned_endtime as OrderPlannedEndtime,
    _prodorder.total_qnty as TotalQnty,
    _prodorder.supervisor as Supervisor,
    _prodorder.prod_unit as ProdUnit,
    _attach.LastChangedAt,
    _attach // Make association public
}
