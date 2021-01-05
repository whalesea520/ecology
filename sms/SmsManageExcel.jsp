
<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*,weaver.hrm.*,java.util.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SptmForSms" class="weaver.splitepage.transform.SptmForSms" scope="page" />


<% 
response.setContentType("application/vnd.ms-excel;charset=UTF-8;");
response.setHeader("Content-disposition", "attachment;filename=SmsManage.xls");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
if(!HrmUserVarify.checkUserRight("SmsManage:View",user)) 
{
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
String fromdate = Util.fromScreen(request.getParameter("fromdate"), user.getLanguage());
    String enddate = Util.fromScreen(request.getParameter("enddate"), user.getLanguage());
    String messagetype = Util.fromScreen(request.getParameter("messagetype"), user.getLanguage());
    String messagestatus=Util.fromScreen(request.getParameter("messagestatus"),user.getLanguage());
    String deleted=Util.null2String(request.getParameter("deleted"));

    int objType = Util.getIntValue(request.getParameter("objType"), 1);
	String objId = Util.null2String(request.getParameter("objId"));
	String objName = "";

    String sqlwhere = " where 1=1 ";

	if(!deleted.equals("")){
		sqlwhere += " and s.isdelete="+deleted;
	}
    if (!"".equals(objId)) {
    	if(objType == 1){
			sqlwhere += " and h.id=" + objId;
    	}else if(objType == 2){
    		sqlwhere += " and h.departmentid=" + objId;
    	}else if(objType == 3){
    		sqlwhere += " and h.subcompanyid1=" + objId;
    	}
    }
    if (!fromdate.equals("")) {
        sqlwhere += " and s.finishtime>='" + fromdate + " 00:00:00'";
    }
    if (!enddate.equals("")) {
        sqlwhere += " and s.finishtime<='" + enddate + " 23:59:59'";
    }

    if(!messagetype.equals("")){
        sqlwhere+=" and s.messagetype = '"+messagetype+"'";
    }
    if(!messagestatus.equals("")){
        sqlwhere+=" and s.messagestatus = '"+messagestatus+"'";
    }
%>
<style>
<!--
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
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<table class=liststyle cellspacing=0 border=1>
	<TBODY>
		<TR class="header">
			<th colSpan=7>
				<p align="center"><%=SystemEnv.getHtmlLabelName(16891,user.getLanguage())%>
				</p>
			</th>
		</TR>
		<TR class=Header>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(16975,user.getLanguage())%>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(18529,user.getLanguage())%>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(18523,user.getLanguage())%>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(18527,user.getLanguage())%>
			</TD>
			<TD align="center">
				<%=SystemEnv.getHtmlLabelName(18530,user.getLanguage())%>
			</TD>
		</TR>
		<%  
 			String  backfields  =  " s.userid, "+
						 		   " s.messageType, "+
						 		   " s.userType, "+
						 		   " s.sendNumber, "+
						 		   " s.toUserType, "+
						 		   " s.toUserID, "+
						 		   " s.recieveNumber, "+
						 		   " s.message, "+
						 		   " s.isdelete, "+
						 		   " s.messagestatus, "+
						 		   " s.finishtime "; 
 			String  fromSql  = " from SMS_Message s left join hrmresource h on s.userid=h.id "; 
 			String orderby  =  " order by s.id desc ";
 			String sql = "select " + backfields + fromSql + sqlwhere+orderby;
 			//System.out.println("sql : "+sql);
 			int i = 0;
 			RecordSet.executeSql(sql);
 			while(RecordSet.next())
 			{
 				i++;
 				String userid = Util.null2String(RecordSet.getString("userid"));
 				userid = userid.equals("0")?"-1":userid;
 				String messageType = Util.null2String(RecordSet.getString("messageType"));
 				String userType = Util.null2String(RecordSet.getString("userType"));
 				String sendNumber = Util.null2String(RecordSet.getString("sendNumber"));
 				sendNumber = sendNumber.equals("")?" ":sendNumber;
 				String toUserType = Util.null2String(RecordSet.getString("toUserType"));
 				String toUserID = Util.null2String(RecordSet.getString("toUserID"));
 				toUserID = toUserID.equals("0")?"-1":toUserID;
 				String recieveNumber = Util.null2String(RecordSet.getString("recieveNumber"));
 				recieveNumber = recieveNumber.equals("")?" ":recieveNumber;
 				String isdelete = Util.null2String(RecordSet.getString("isdelete"));
 				String smessagestatus = Util.null2String(RecordSet.getString("messagestatus"));
 				
 				String getsender = "&nbsp;"+SptmForSms.getSendExcel(messageType,""+userType+"+"+userid+"+"+sendNumber+"+"+toUserType+"+"+toUserID);
 				String getreciever = "&nbsp;"+SptmForSms.getRecieveExcel(messageType,""+toUserType+"+"+toUserID+"+"+recieveNumber+"+"+userType+"+"+userid);
 				String getmessage = "&nbsp;"+Util.null2String(RecordSet.getString("message"));
 				String getessagestatus = SptmForSms.getPersonalViewMessageStatus(smessagestatus,""+user.getLanguage()+"+"+isdelete);
 				String getMessageType = SptmForSms.getMessageType(messageType,""+user.getLanguage());
 				String getfinishtime = Util.null2String(RecordSet.getString("finishtime"));
 				
 		%>
 		<TR>
 			<TD>
				<%=i%>
			</TD>
			<TD>
				<%=getsender%>
			</TD>
			<TD>
				<%=getreciever%>
			</TD>
			<TD>
				<%=getmessage%>
			</TD>
			<TD>
				<%=getessagestatus%>
			</TD>
			<TD>
				<%=getMessageType%>
			</TD>
			<TD>
				<%=getfinishtime%>
			</TD>
		</tr>
 		<%
 			}
       	%>
	</TBODY>
</table>