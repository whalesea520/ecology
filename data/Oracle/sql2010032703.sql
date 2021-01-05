alter table Meeting_Type add(catalogpath varchar2(255))
/
alter table meeting add(accessorys varchar2(2000))
/

CREATE OR REPLACE PROCEDURE Meeting_Type_Insert(name_1         varchar2,
                                                approver_2     integer,
                                                desc_n_3       varchar2,
                                                subcompanyid_4 integer,
												catalogpath_5  varchar2,
                                                flag           out integer,
                                                msg            out varchar2,
                                                thecursor      IN OUT cursor_define.weavercursor) AS
begin
  INSERT INTO Meeting_Type
    (name, approver, desc_n, subcompanyid,catalogpath)
  VALUES
    (name_1, approver_2, desc_n_3, subcompanyid_4,catalogpath_5);
end;
/

CREATE OR REPLACE PROCEDURE Meeting_Type_Update(id_1           integer,
                                                name_2         varchar2,
                                                approver_3     integer,
                                                desc_n_4       varchar2,
                                                subcompanyid_5 integer,
												catalogpath_6  varchar2,
                                                flag           out integer,
                                                msg            out varchar2,
                                                thecursor      IN OUT cursor_define.weavercursor) AS
begin
  update Meeting_Type
     set name         = name_2,
         approver     = approver_3,
         desc_n       = desc_n_4,
         subcompanyid = subcompanyid_5,
		 catalogpath = catalogpath_6
   where id = id_1;
end;
/
