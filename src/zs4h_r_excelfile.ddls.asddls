@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Excel Files'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZS4H_R_EXCELFILE
  as select from zs4h_excelfile_a as _attach
  composition [1..*] of zs4h_r_prodord as _prodorders
{
  key _attach.attach_id             as AttachId,

      @Semantics.largeObject:
      { mimeType: 'Mimetype',
        fileName: 'Filename',
        contentDispositionPreference: #INLINE
      }
      _attach.attachment            as Attachment,
      @Semantics.mimeType: true
      _attach.mimetype              as Mimetype,
      _attach.filename              as Filename,
      _attach.status                as Status,
      @Semantics.user.createdBy: true
      _attach.created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _attach.created_at            as CreatedAt,
      _attach.local_last_changed_by as LocalLastChangedBy,
      _attach.local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      _attach.last_changed_at       as LastChangedAt,
      //    _association_name // Make association public
      _prodorders
}
