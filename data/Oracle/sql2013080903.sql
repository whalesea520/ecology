CREATE OR REPLACE PROCEDURE ImageFile_Insert_New(imagefileid_1   integer,
                                             imagefilename_2 varchar2,
                                             imagefiletype_3 varchar2,
                                             imagefileused_4 integer,
                                             filerealpath_5  varchar2,
                                             iszip_6         char,
                                             isencrypt_7     char,
                                             fileSize_8      varchar2,
                                             isaesencrypt_9  integer,
                                             aescode_10      varchar2,
                                             flag            out integer,
                                             msg             out varchar2,
                                             thecursor       IN OUT cursor_define.weavercursor) AS
begin
  INSERT INTO ImageFile
    (imagefileid,
     imagefilename,
     imagefiletype,
     imagefileused,
     filerealpath,
     iszip,
     isencrypt,
     fileSize, 
     isaesencrypt, 
     aescode)
  VALUES
    (imagefileid_1,
     imagefilename_2,
     imagefiletype_3,
     imagefileused_4,
     filerealpath_5,
     iszip_6,
     isencrypt_7,
     fileSize_8,
     isaesencrypt_9,
     aescode_10);
end;

/