
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="session" />
<jsp:useBean id="HrmCareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="session" />
<jsp:useBean id="CareerInviteComInfo" class="weaver.hrm.career.CareerInviteComInfo" scope="page"/>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<%
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);//页数
int perpage=10;                                                //每页记录数
String backFields = "",sqlFrom = "",sqlWhere = "",tableString = "";

if(HrmUserVarify.checkUserRight("HrmCareerApplyAdd:Add", user)){
	backFields = "*";
	sqlFrom = " from HrmCareerApply";
	sqlWhere = HrmCareerApplyComInfo.FormatSQLSearch(user.getLanguage());
	tableString=""+
		"<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
			"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
			"<head>"+                             
				"<col width=\"24%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" linkkey=\"applyid\" linkvaluecolumn=\"id\" href=\"HrmCareerApplyEdit.jsp\" target=\"_self\"/>"+
				"<col width=\"16%\"  text=\""+SystemEnv.getHtmlLabelName(416,user.getLanguage())+"\" column=\"sex\" orderkey=\"sex\" transmethod=\"weaver.hrm.career.HrmCareerApplyComInfo.getSex\" otherpara=\""+user.getLanguage()+"\"/>"+
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15671,user.getLanguage())+"\" column=\"jobtitle\" orderkey=\"jobtitle\" transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesname\"/>"+
				"<col width=\"17%\"  text=\""+SystemEnv.getHtmlLabelName(1855,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\"/>"+
				"<col width=\"17%\"  text=\""+SystemEnv.getHtmlLabelName(464,user.getLanguage())+"\" column=\"birthday\" orderkey=\"birthday\"/>"+
				"<col width=\"26%\"  text=\""+SystemEnv.getHtmlLabelName(818,user.getLanguage())+"\"  column=\"educationlevel\" orderkey=\"status\" transmethod=\"weaver.hrm.job.EducationLevelComInfo.getEducationLevelname\"/>"+ 
			"</head>"+
		"</table>";
}else{
	backFields = "HrmCareerApply.*";
	sqlFrom = " from HrmCareerApply,HrmShare";
	if((HrmCareerApplyComInfo.FormatSQLSearch(user.getLanguage())).equals("")) 
		sqlWhere = " where HrmShare.hrmid="+user.getUID()+" and  HrmCareerApply.id=HrmShare.applyid" ;
    else 
		sqlWhere = HrmCareerApplyComInfo.FormatSQLSearch(user.getLanguage()) + " and HrmShare.hrmid="+user.getUID()+" and  HrmCareerApply.id=HrmShare.applyid" ;
	tableString=""+
		"<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
			"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+sqlWhere+"\"/>"+
			"<head>"+                             
				"<col width=\"24%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" linkkey=\"applyid\" linkvaluecolumn=\"id\" href=\"HrmCareerApplyEdit.jsp\" target=\"_self\"/>"+
				"<col width=\"16%\"  text=\""+SystemEnv.getHtmlLabelName(416,user.getLanguage())+"\" column=\"sex\" orderkey=\"sex\" transmethod=\"weaver.hrm.career.HrmCareerApplyComInfo.getSex\" otherpara=\""+user.getLanguage()+"\"/>"+
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15671,user.getLanguage())+"\" column=\"jobtitle\" orderkey=\"jobtitle\" transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesname\"/>"+
				"<col width=\"17%\"  text=\""+SystemEnv.getHtmlLabelName(1855,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\"/>"+
				"<col width=\"17%\"  text=\""+SystemEnv.getHtmlLabelName(464,user.getLanguage())+"\" column=\"birthday\" orderkey=\"birthday\"/>"+
				"<col width=\"26%\"  text=\""+SystemEnv.getHtmlLabelName(818,user.getLanguage())+"\"  column=\"educationlevel\" orderkey=\"status\" transmethod=\"weaver.hrm.job.EducationLevelComInfo.getEducationLevelname\" otherpara=\""+user.getLanguage()+"\"/>"+ 
			"</head>"+
		"</table>";
}
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(773,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",/hrm/career/HrmCareerApply.jsp?method=ConfResearch,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<FORM NAME=frmain action="" method=post>
<TABLE class=Shadow>
	<TR class=Header>
    	<TH valign="top"><%=SystemEnv.getHtmlLabelName(773,user.getLanguage())%></TH>
	</TR>
	<tr>
		<td valign="top"><wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/></td>
	</tr>
</TABLE>
</FORM>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>

</BODY>
</HTML>
