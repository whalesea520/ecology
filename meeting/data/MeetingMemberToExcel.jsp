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
ExcelFile.setFilename(meetingname+"_"+SystemEnv.getHtmlLabelNames("2106,34038",user.getLanguage())) ;  //参会人员名单
ExcelFile.addSheet(SystemEnv.getHtmlLabelNames("2106,34038",user.getLanguage()), es) ;

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
	response.setHeader("Content-disposition", "attachment;filename="+new String((meetingname+"_"+SystemEnv.getHtmlLabelNames("2106,34038",user.getLanguage())).getBytes("utf-8"), "ISO8859-1" )+".xls");
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
				<%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(2187,user.getLanguage())%>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(2189,user.getLanguage())%>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(126018,user.getLanguage())%>
			</TD>
		</TR>
		<%
			rs.executeSql("select memberid,isattend,othermember from meeting_member2 where meetingid="+meetingid+" and membertype=1 order by id");
			while(rs.next()){
			String name=ResourceComInfo.getLastname(rs.getString("memberid"));
			if(name.equals("")){
				name=rs.getString("memberid");
			}
			String isattend="";
			if(rs.getString("isattend").equals("1")){
				isattend=SystemEnv.getHtmlLabelName( 163 ,user.getLanguage());
			}
			if(rs.getString("isattend").equals("2")){
				isattend=SystemEnv.getHtmlLabelName( 161 ,user.getLanguage());
			}
			%>
			<TR>
				<TD align="center">
	     	 		<%=name %> 
	     		</TD>
	      		<TD align="center">
	     	 		<%=isattend%> 
	     		</TD>
	     		<TD align="center" style="width=200px">
	     		
	     	 		<%=ResourceComInfo.getLastnames(rs.getString("othermember")) %> 
	     		</TD>
	     		<TD align="center">
	     		</TD>
	     	</TR>
	     	<%
	  		}
			rs.executeSql("select othermembers from meeting where id="+meetingid);
			if(rs.next()){
				String othermembers=rs.getString("othermembers");
				String[] arrs=othermembers.split(",");
				for(int i=0;i<arrs.length;i++){
					if(!arrs[i].equals("")){
						%>
						<TR>
							<TD align="center">
				     	 		<%=arrs[i] %> 
				     		</TD>
				      		<TD align="center">

				     		</TD>
				     		<TD align="center" style="width=200px">
				     		</TD>
				     		<TD align="center">
				     		</TD>
				     	</TR>
				     	<%
					}
				}
		  	}
			
			boolean flag=true;
			rs.executeSql("select id,memberid,isattend from Meeting_Member2 where membertype=2 and meetingid="+meetingid+" order by id");
			while(rs.next()){
				if(flag){
				%>
				<TR>
					<TD align="center">
						<%=SystemEnv.getHtmlLabelName(2167,user.getLanguage())%>
					</TD>
					<TD align="center">
						<%=SystemEnv.getHtmlLabelName(2187,user.getLanguage())%>
					</TD>
					<TD align="center">
						<%=SystemEnv.getHtmlLabelName(2189,user.getLanguage())%>
					</TD>
					<TD align="center">
						<%=SystemEnv.getHtmlLabelName(126018,user.getLanguage())%>
					</TD>
				</TR>	
				<%
				}
				flag=false;
				String name=CustomerInfoComInfo.getCustomerInfoname(rs.getString("memberid"));
				String isattend="";
				String othername="";
				if(name.equals("")){
					name=rs.getString("memberid");
				}
				if(rs.getString("isattend").equals("1")){
					isattend=SystemEnv.getHtmlLabelName( 163 ,user.getLanguage());
				}
				if(rs.getString("isattend").equals("2")){
					isattend=SystemEnv.getHtmlLabelName( 161 ,user.getLanguage());
				}
				rs2.executeSql("select name from meeting_membercrm where memberrecid="+rs.getString("id"));
				
				while(rs2.next()){
					if(!othername.equals("")){
						othername+=",";
					}
					othername+=rs2.getString("name");
				}
				%>
				<TR>
				<TD align="center">
	     	 		<%=name %> 
	     		</TD>
	      		<TD align="center">
	     	 		<%=isattend %> 
	     		</TD>
	     		<TD align="center">
	     	 		<%=othername %> 
	     		</TD>
	     		<TD align="center">
	     		</TD>
	     		</TR>
				<%
			}
			
		%>
	</TBODY>
</table>