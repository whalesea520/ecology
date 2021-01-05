update mode_CustomDspField set isorder=1,ordertype='a',ordernum=priorder where isorderfield=1
GO
update mode_CustomDspField set isorder=1,ordertype='d',ordernum=priorder where isorderfield=2
GO
update mode_CustomDspField set isorder=1,ordertype='n' where isorderfield=3
GO
update mode_CustombrowserDspField set isorder=1,ordertype='a',ordernum=priorder where isorderfield=1
GO
update mode_CustombrowserDspField set isorder=1,ordertype='d',ordernum=priorder where isorderfield=2
GO
update mode_CustombrowserDspField set isorder=1,ordertype='n' where isorderfield=3
GO