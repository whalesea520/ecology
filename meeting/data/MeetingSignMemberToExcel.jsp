<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.*" %>
<%@page import="java.util.List"%>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);
	String meetingid=Util.null2String(request.getParameter("meetingid"));

	String address="";
	String meetingname="";
	String begintime="";
	String endtime="";
	rs.executeSql("select * from meeting where id="+meetingid);
	if(rs.next()){
		meetingname = rs.getString("name");

		if(rs.getString("address").equals("")){
			address = rs.getString("customizeAddress");
		}else{
			address=rs.getString("address");
			address=MeetingRoomComInfo.getMeetingRoomInfoname(address);
		}
		
		begintime=rs.getString("begindate")+" "+rs.getString("begintime");
		endtime=rs.getString("enddate")+" "+rs.getString("endtime");

	}
ExcelSheet es = new ExcelSheet() ;


ExcelFile.init() ;
ExcelFile.setFilename(meetingname+"_"+SystemEnv.getHtmlLabelNames("20032,1867,34038",user.getLanguage())) ;  //签到人员名单
ExcelFile.addSheet(SystemEnv.getHtmlLabelNames("20032,1867,34038",user.getLanguage()), es) ;

ExcelStyle estyle=new ExcelStyle();
estyle.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor1);
ExcelFile.addStyle("head",estyle);
 
response.reset();
String agent = request.getHeader("USER-AGENT"); 

	//websphere环境下如果设置application/vnd.ms-excel;charset=UTF-8;的时候导出为空,所以修改成以下的形式
	response.setContentType("application/vnd.ms-excel;");
	response.setCharacterEncoding("utf-8");
if(agent.indexOf("Trident")>-1||agent.indexOf("MSIE")>-1){
	response.setHeader("Content-disposition", "attachment;filename="+ExcelFile.getFilename());
}else{
	response.setHeader("Content-disposition", "attachment;filename="+new String((meetingname+"_"+SystemEnv.getHtmlLabelNames("20032,1867,34038",user.getLanguage())).getBytes("utf-8"), "ISO8859-1" )+".xls");
}
%>
<style>
td {
	font: 12px
}

.trTitle td {
	font: bold
}

.title {
	font-weight: bold;
	font-size: 20px;
	text-align: center;
	margin: 10px 0 10px 0
}

br {
	mso-data-placement: same-cell;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<table  class="ListStyle" cellspacing=0 border=1>
	<TBODY>
		<TR class="header">
			<td>
				<p align="left"><%=SystemEnv.getHtmlLabelName(2151,user.getLanguage())%></p>
			</td>
			<td colSpan=3>
				<p align="left"><%=meetingname%></p>
			</td>
		</TR>
		<TR class="header">
			<td>
				<p align="left"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></p>
			</td>
			<td colSpan=3>
				<p align="left"><%=begintime%></p>
			</td>
		</TR>
		<TR class="header">
			<td>
				<p align="left"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></p>
			</td>
			<td colSpan=3>
				<p align="left"><%=endtime%></p>
			</td>
		</TR>

		<TR>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(125530,user.getLanguage())%>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(20035,user.getLanguage())%>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(128301,user.getLanguage())%>
			</TD>
		</TR>
		<%
			rs.executeSql("select userid,attendType,signTime,signReson from meeting_sign where meetingid="+meetingid+"  order by signTime desc");
			while(rs.next()){
			String name=ResourceComInfo.getLastname(rs.getString("userid"));
			String signTime = (rs.getString("signTime")).equals("")?SystemEnv.getHtmlLabelName( 129648 ,user.getLanguage()):rs.getString("signTime");
			String signReason = "";
			if(name.equals("")){
				name=rs.getString("userid");
			}
			String attendType="";
			if(rs.getString("attendType").equals("1")){
				attendType=SystemEnv.getHtmlLabelName( 163 ,user.getLanguage());
			}
			if(rs.getString("attendType").equals("0")){
				attendType=SystemEnv.getHtmlLabelName( 161 ,user.getLanguage());
			}
			signReason = Util.null2String(rs.getString("signReson"));
			%>
			<TR>
				<TD align="center">
	     	 		<%=name %> 
	     		</TD>
	      		<TD align="center">
	     	 		<%=attendType%> 
	     		</TD>
	     		<TD align="center" style="width=200px">
	     	 		<%=signTime %> 
	     		</TD>
	     		<TD align="center">
	     			<%=signReason %> 
	     		</TD>
	     	</TR>
	     	<%
	  		}
		%>
	</TBODY>
</table>