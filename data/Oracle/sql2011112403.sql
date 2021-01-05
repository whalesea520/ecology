CREATE or REPLACE PROCEDURE HrmPubHoliday_Copy(fromyear_1  varchar2,
                                               toyear_1    char,
                                               countryid_1 varchar2,
                                               flag        out integer,
                                               msg         out varchar2,
                                               thecursor   IN OUT cursor_define.weavercursor) AS
  tempdate_1 char(10);
  tempname_1 varchar(255);
  temptype_1 char(1);
begin
  delete from hrmpubholiday
   where substr(holidaydate, 1, 4) = toyear_1
     and countryid = countryid_1;
  FOR all_cursor in (select substr(holidaydate, 5, 6) tempdate, holidayname,changetype
                       from hrmpubholiday
                      where substr(holidaydate, 1, 4) = fromyear_1
                        and countryid = countryid_1) loop
    tempdate_1 := all_cursor.tempdate;
    tempname_1 := all_cursor.holidayname;
    temptype_1 := all_cursor.changetype;
    insert into hrmpubholiday
      (countryid, holidaydate, holidayname,changetype)
    values
      (to_number(countryid_1), replace(concat(toyear_1, tempdate_1),' ',''), tempname_1, to_number(temptype_1));
  end loop;
end;
/
