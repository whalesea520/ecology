
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*,java.math.BigDecimal" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="mtr" class="weaver.meeting.Maint.MeetingForTypeReport" scope="page"/>
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 

<HTML><HEAD>

<META http-equiv=Content-Type content="text/html; charset=UTF-8" />

</head>
<%!
public String formatText(String str, int len){
	return str.length() > len?str.substring(0,len)+"...":str;
}
%>

<%

int userSub = user.getUserSubCompany1(); 
Calendar calendar = Calendar.getInstance();

boolean isUseMtiManageDetach=ManageDetachComInfo.isUseMtiManageDetach();
int detachable=0;
if(isUseMtiManageDetach){
	detachable=1;
   session.setAttribute("detachable","1");
   session.setAttribute("meetingdetachable","1");
}else{
	detachable=0;
   session.setAttribute("detachable","0");
   session.setAttribute("meetingdetachable","0");
}
    
char flag=2;
String userid=user.getUID()+"" ;

Calendar today = Calendar.getInstance();
int currentyear=today.get(Calendar.YEAR);

String sqlwhere = "";

ArrayList meetingTypeids = new ArrayList() ;
Map meetingTypenames = new HashMap() ;

int year = Util.getIntValue(request.getParameter("year"),currentyear);
String types = Util.null2String(request.getParameter("types"));
if(!"".equals(types)){
	sqlwhere += " and a.id in ("+types+") ";
}

String sql = "select a.id, a.name from Meeting_Type a where 1=1 " + MeetingShareUtil.getTypeShareSql(user) + sqlwhere + " order by id";
RecordSet.executeSql(sql);
while(RecordSet.next()){
    String tmpmeetingroomid=RecordSet.getString(1);
    String tmpmeetingroomname=RecordSet.getString(2);
    meetingTypeids.add(tmpmeetingroomid) ;
    meetingTypenames.put(tmpmeetingroomid, tmpmeetingroomname) ;
}

mtr.setYear(year);

Map dataMap = mtr.getReportDate();

 ExcelSheet es = new ExcelSheet() ;
 ExcelRow er = es.newExcelRow () ;
 
er.addStringValue(SystemEnv.getHtmlLabelName(2104,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(1492,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(1493,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(1494,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(1495,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(1496,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(1497,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(1498,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(1499,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(1800,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(1801,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(1802,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(1803,user.getLanguage()));
es.addExcelRow(er) ;
for(int k=0;k<meetingTypeids.size();k++){
    int tmptypeid=Util.getIntValue(meetingTypeids.get(k)==null?"-1":meetingTypeids.get(k).toString());
    if(tmptypeid == -1) continue;
    er = es.newExcelRow ();
    String tmpname = meetingTypenames.get(String.valueOf(tmptypeid)) == null?" ":meetingTypenames.get(String.valueOf(tmptypeid)).toString();
    er.addStringValue(tmpname); 
    	if (!dataMap.containsKey(tmptypeid) || dataMap.get(tmptypeid) == null) { 
    		for (int p=0 ;p<12;p++) {
    			er.addStringValue("");
    		}
    		es.addExcelRow(er) ;
    		continue;
    	};	
    	Integer[] dataArry = (Integer[])dataMap.get(tmptypeid);
    	for(int i = 0; i < 12; i++){
    		int dt = dataArry[i];
    		if(dt > 0){
    			er.addStringValue(""+dt);	
        	} else {
	        	er.addStringValue("");
        	}
    	}
    es.addExcelRow(er) ;
}

ExcelFile.init() ;
ExcelFile.setFilename(Util.toScreen(SystemEnv.getHtmlLabelName(32592,user.getLanguage()),user.getLanguage())) ;
ExcelFile.addSheet(Util.toScreen(SystemEnv.getHtmlLabelName(32592,user.getLanguage()),user.getLanguage()), es) ;

%>
<BODY>

</body>
</html>
<script type="text/javascript">

setTimeout(function () {
	window.parent.document.getElementById("excelwaitDiv").style.display = "none";	
}, 400);
window.location.href = "/weaver/weaver.file.ExcelOut";

</script>
