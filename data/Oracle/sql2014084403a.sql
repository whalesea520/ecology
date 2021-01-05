update mode_customsearch set (formid,appid)=(select formid,modetype from modeinfo where mode_customsearch.modeid=modeinfo.id) where formid is null
/
update mode_report set (appid)=(select modetype from modeinfo where mode_report.modeid=modeinfo.id) where appid is null
/
update mode_ReportDspField set isshow=1 where isshow is null
/
update mode_custombrowser set (formid,appid)=(select formid,modetype from modeinfo where mode_custombrowser.modeid=modeinfo.id) where formid is null
/