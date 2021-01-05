create or replace procedure Doc_AddSecidToFather(
  secid_1   integer,
  flag      out integer,
  msg       out varchar2,
  thecursor IN OUT cursor_define.weavercursor) as
  fatherid_1  integer;
  fatherid1_1 integer;
  secid_ch_1  varchar2(10);
  secids_1    varchar2(500);
begin
  secid_ch_1 := to_char(secid_1);
  select subcategoryid
    into fatherid_1
    from DocSecCategory
   where id = secid_1;
  if fatherid_1 is null then
    fatherid_1 := -1;
  end if;
  if fatherid_1 = 0 then
    fatherid_1 := -1;
  end if;
  while fatherid_1 <> -1 loop
    select subcategoryid, seccategoryids
      into fatherid1_1, secids_1
      from DocSubCategory
     where id = fatherid_1;
    if secids_1 is null then
      update DocSubCategory
         set seccategoryids = secid_ch_1
       where id = fatherid_1;
    elsif instr(concat(concat(',',secids_1),','), concat(concat(',',secid_ch_1),','), 1, 1) = 0 then
      update DocSubCategory
         set seccategoryids = concat(concat(secids_1, ','), secid_ch_1)
       where id = fatherid_1;
    end if;
    fatherid_1 := fatherid1_1;
  end loop;
end;
/

CREATE OR REPLACE PROCEDURE Doc_DeleteSecidFromFather(
  secid_1   integer,
  flag      out integer,
  msg       out varchar2,
  thecursor IN OUT cursor_define.weavercursor) as
  fatherid_1  integer;
  fatherid1_1 integer;
  secid_ch_1  varchar(10);
  secids_1    varchar(500);
begin
  secid_ch_1 := concat(concat(',', to_char(secid_1)), ',');
  select subcategoryid
    into fatherid_1
    from DocSecCategory
   where id = secid_1;
  if fatherid_1 is null then
    fatherid_1 := -1;
  end if;
  if fatherid_1 = 0 then
    fatherid_1 := -1;
  end if;
  while fatherid_1 <> -1 loop
    select subcategoryid, seccategoryids
      into fatherid1_1, secids_1
      from DocSubCategory
     where id = fatherid_1;
    if secids_1 is not null then
      secids_1 := concat(concat(',', secids_1), ',');
      if instr(secids_1, secid_ch_1) <> 0 then
        secids_1 := replace(secids_1, secid_ch_1, ',');
        if secids_1 = ',' then
          secids_1 := ' ';
        else
          secids_1 := substr(secids_1, 2, length(secids_1) - 2);
        end if;
        update DocSubCategory
           set seccategoryids = secids_1
         where id = fatherid_1;
      end if;
    end if;
    fatherid_1 := fatherid1_1;
  end loop;
end;
/