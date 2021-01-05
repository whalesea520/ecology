CREATE OR REPLACE PROCEDURE HrmJobTitlesTemplet_Update(id_1                integer,
                                                       jobtitlemark_2      varchar2,
                                                       jobtitlename_3      varchar2,
                                                       jobactivityid_5     integer,
                                                       jobresponsibility_6 varchar2,
                                                       jobcompetency_7     varchar2,
                                                       jobtitleremark_8    varchar2,
                                                       flag                out integer,
                                                       msg                 out varchar2,
                                                       thecursor           IN OUT cursor_define.weavercursor) AS
begin
  UPDATE HrmJobTitlesTemplet
     SET jobtitlemark      = jobtitlemark_2,
         jobtitlename      = jobtitlename_3,
         jobactivityid     = jobactivityid_5,
         jobresponsibility = jobresponsibility_6,
         jobcompetency     = jobcompetency_7,
         jobtitleremark    = jobtitleremark_8
   WHERE (id = id_1);
end;
/
