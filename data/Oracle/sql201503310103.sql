ALTER TABLE HrmUserSetting ADD belongtoshow int
/
UPDATE MainMenuInfo SET linkAddress='/hrm/jobtitlestemplet/index.jsp'  WHERE id=62
/
create table HrmJobTitlesTemplet as select * from HrmJobTitles
/
ALTER TABLE HrmJobTitlesTemplet DROP COLUMN jobdepartmentid 
/
INSERT INTO SystemLogItem(itemid,lableid,itemdesc,typeid)VALUES(157,82662,'¸ÚÎ»Ä£°å',2)
/
CREATE OR REPLACE PROCEDURE HrmJobTitlesTemplet_Select (flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as begin open thecursor for select * from HrmJobTitlesTemplet; end;
/
CREATE OR REPLACE PROCEDURE HrmJobTitlesTemplet_Insert (jobtitlemark_1 varchar2, jobtitlename_2 varchar2, jobactivityid_4 integer, jobresponsibility_5 	varchar2, jobcompetency_6 	varchar2, jobtitleremark_7 varchar2, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin INSERT INTO HrmJobTitlesTemplet ( jobtitlemark, jobtitlename, jobactivityid, jobresponsibility, jobcompetency, jobtitleremark) VALUES ( jobtitlemark_1, jobtitlename_2, jobactivityid_4, jobresponsibility_5, jobcompetency_6, jobtitleremark_7); open thecursor for select max(id) from  HrmJobTitles ; end;
/
CREATE OR REPLACE PROCEDURE HrmJobTitlesTemplet_Update (id_1 integer, jobtitlemark_2 	varchar2, jobtitlename_3 	varchar2, jobdepartmentid_4 	integer, jobactivityid_5 integer, jobresponsibility_6	varchar2, jobcompetency_7 varchar2, jobtitleremark_8 varchar2, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin UPDATE HrmJobTitlesTemplet  SET jobtitlemark = jobtitlemark_2, jobtitlename = jobtitlename_3, jobactivityid	 = jobactivityid_5, jobresponsibility = jobresponsibility_6, jobcompetency = jobcompetency_7, jobtitleremark	 = jobtitleremark_8 WHERE ( id	 = id_1); end;
/
CREATE OR REPLACE PROCEDURE HrmJobTitlesTemplet_Delete (id_1 	integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as begin delete HrmJobTitlesTemplet  WHERE ( id=id_1); end;
/