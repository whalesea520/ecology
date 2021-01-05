
/* 一下是对应的 oracle 语句 */

ALTER TABLE ImageFile 
	Add fileSize varchar2(20) DEFAULT '0' /*文件大小，bytes*/
/


ALTER TABLE ImageFile 
	Add downloads integer DEFAULT 0 NOT NULL/* 下载次数*/
/



CREATE OR REPLACE PROCEDURE ImageFile_Insert
	(imagefileid_1 	integer,
	 imagefilename_2 	varchar2,
	 imagefiletype_3 	varchar2,
	 imagefileused_4 	integer,
	 filerealpath_5 	varchar2,
     iszip_6 char ,
	 isencrypt_7 	char ,
	 fileSize_8  varchar2 ,
     flag	out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO ImageFile 
	 ( imagefileid,
	 imagefilename,
	 imagefiletype,
	 imagefileused,
	 filerealpath,
     iszip,
	 isencrypt,
	 fileSize) 
 
VALUES 
	( imagefileid_1,
	 imagefilename_2,
	 imagefiletype_3,
	 imagefileused_4,
	 filerealpath_5,
     iszip_6,
	 isencrypt_7,
	 fileSize_8);
end;
/

