@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Excel Files'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZS4H_C_EXCELFILE
  provider contract transactional_query
  as projection on ZS4H_R_EXCELFILE
{
  

  key AttachId,
      Attachment,
      Mimetype,
      Filename,
      Status,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      /* Associations */
      _prodorders : redirected to composition child ZS4H_C_PRODORD

}
