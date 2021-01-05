update mode_CustomDspField set isorder=1,ordertype='a',ordernum=to_number(RTRIM(priorder)) where isorderfield=1
/
update mode_CustomDspField set isorder=1,ordertype='d',ordernum=to_number(RTRIM(priorder)) where isorderfield=2
/
update mode_CustomDspField set isorder=1,ordertype='n' where isorderfield=3
/
update mode_CustombrowserDspField set isorder=1,ordertype='a',ordernum=to_number(RTRIM(priorder)) where isorderfield=1
/
update mode_CustombrowserDspField set isorder=1,ordertype='d',ordernum=to_number(RTRIM(priorder)) where isorderfield=2
/
update mode_CustombrowserDspField set isorder=1,ordertype='n' where isorderfield=3
/