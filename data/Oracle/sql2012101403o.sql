drop trigger modehtmllayout_Tri
/
create or replace trigger modehtmllayout_Tri
before insert on modehtmllayout
for each row
begin
select modehtmllayout_id.nextval into :new.id from dual;
end;
/
create or replace trigger modeinfo_Tri
before insert on modeinfo
for each row
begin
select modeinfo_id.nextval into :new.id from dual;
end;
/
create or replace PROCEDURE mode_CustomDspField_Init(reportid_1 integer,
                                                     flag       out integer,
                                                     msg        out varchar2) AS
begin
  INSERT INTO mode_CustomDspField
    (customid, fieldid, isquery, isshow, showorder, queryorder, istitle)
  VALUES
    (reportid_1, -2, '1', '1', 2, 2, 0);
  INSERT INTO mode_CustomDspField
    (customid, fieldid, isquery, isshow, showorder, queryorder, istitle)
  VALUES
    (reportid_1, -1, '1', '1', 1, 1, 0);
end;
/

create or replace PROCEDURE mode_CustomDspField_Insert(reportid_1      integer,
                                                       fieldid_2       integer,
                                                       dborder_3       char,
                                                       shows           char,
                                                       compositororder varchar2,
                                                       queryorder      integer,
                                                       istitle         integer,
                                                       flag            out integer,
                                                       msg             out varchar2) AS
begin
  INSERT INTO mode_CustomDspField
    (customid, fieldid, isquery, isshow, showorder, queryorder, istitle)
  VALUES
    (reportid_1,
     fieldid_2,
     dborder_3,
     shows,
     compositororder,
     queryorder,
     istitle);
end;
/

create or replace PROCEDURE mode_C_BrowserDspField_Init(reportid_1 integer,
                                                        flag       out integer,
                                                        msg        out varchar2) AS
begin
  INSERT INTO mode_CustomBrowserDspField
    (customid, fieldid, isquery, isshow, showorder, queryorder, istitle)
  VALUES
    (reportid_1, -2, '1', '1', 2, 2, 0);
  INSERT INTO mode_CustomBrowserDspField
    (customid, fieldid, isquery, isshow, showorder, queryorder, istitle)
  VALUES
    (reportid_1, -1, '1', '1', 1, 1, 0);
end;
/

create or replace PROCEDURE mode_C_BrowserDspField_Insert(reportid_1      integer,
                                                          fieldid_2       integer,
                                                          dborder_3       char,
                                                          shows           char,
                                                          compositororder varchar2,
                                                          queryorder      integer,
                                                          istitle         integer,
                                                          flag            out integer,
                                                          msg             out varchar2) AS
begin
  INSERT INTO mode_CustomBrowserDspField
    (customid, fieldid, isquery, isshow, showorder, queryorder, istitle)
  VALUES
    (reportid_1,
     fieldid_2,
     dborder_3,
     shows,
     compositororder,
     queryorder,
     istitle);
end;
/
alter table DefaultValue add formid int
/
alter table mode_pageexpand add mainid int
/