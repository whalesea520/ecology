insert into AlbumSubcompany select id,1000000,0 from HrmSubcompany
/
DROP TRIGGER T_UpdatePhotoCount
/

CREATE OR REPLACE procedure AlbumPhotos_U_Size(subcompanyId_1 integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
as 
albumSize_1 integer; albumSizeUsed_1 integer; 
begin 
	  select distinct albumSize into albumSize_1  from AlbumSubcompany where subcompanyId=subcompanyId_1; 
	  select SUM(photoSize) into albumSizeUsed_1 from AlbumPhotos where subcompanyId=subcompanyId_1; 

	if albumSizeUsed_1>albumSize_1 then 
	   update AlbumSubcompany set albumSizeUsed=albumSize_1 WHERE subcompanyId=subcompanyId_1; 
	else 
		 update AlbumSubcompany set albumSizeUsed=albumSizeUsed_1 WHERE subcompanyId=subcompanyId_1; 
	end if; 
end;
/