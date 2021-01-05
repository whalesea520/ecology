update DocMould set mouldtype='0' where mouldType is null
/
update DocMouldFile set mouldtype='0' where mouldType is null
/

CREATE or REPLACE PROCEDURE imagefile_DeleteByDoc(
fileid1 	integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS

begin
    update imagefile set imagefileused=imagefileused-1 where imagefileid= fileid1;
    open thecursor for select filerealpath from  ImageFile where imagefileid=fileid1 and imagefileused = 0;
    delete ImageFile where imagefileid=fileid1 and imagefileused = 0;
end;
/
