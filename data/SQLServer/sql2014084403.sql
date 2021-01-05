update mode_customsearch set formid = modeinfo.formid,appid=modeinfo.modetype from mode_customsearch,modeinfo where mode_customsearch.modeid=modeinfo.id and mode_customsearch.formid is null;
GO
update mode_report set appid = modeinfo.modetype from mode_report,modeinfo where mode_report.modeid=modeinfo.id and mode_report.appid is null
GO
update mode_ReportDspField set isshow=1 where isshow is null
GO
update mode_custombrowser set formid = modeinfo.formid,appid=modeinfo.modetype from mode_custombrowser,modeinfo where mode_custombrowser.modeid=modeinfo.id and mode_custombrowser.formid is null;
GO