CREATE OR REPLACE PROCEDURE FnaYearsPeriodsList_Update(id_1        integer,
                                                       startdate_2 varchar2,
                                                       enddate_3   varchar2,
                                                       fnayearid_4 integer,
                                                       isactive_5  varchar2,
                                                       flag        out integer,
                                                       msg         out varchar2,
                                                       thecursor   IN OUT cursor_define.weavercursor) AS
  minfromdate_1 varchar2(4000);
  maxenddate_1  varchar2(4000);
begin
  UPDATE FnaYearsPeriodsList
     SET startdate = startdate_2,
         enddate   = enddate_3,
         isactive  = isactive_5
   WHERE (id = id_1);
  select min(startdate)
    into minfromdate_1
    from FnaYearsPeriodsList
   where fnayearid = fnayearid_4
     and (startdate is not null);
  select max(enddate)
    into maxenddate_1
    from FnaYearsPeriodsList
   where fnayearid = fnayearid_4
     and (enddate is not null);
  update FnaYearsPeriods
     set startdate = minfromdate_1, enddate = maxenddate_1
   where id = fnayearid_4;
end;
/