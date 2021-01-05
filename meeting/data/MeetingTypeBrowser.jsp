
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("meetingdetachable")),0);
int subid=Util.getIntValue(request.getParameter("subCompanyId"));
if(subid<0){
        subid=user.getUserSubCompany1();
}
ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"MeetingType:Maintenance");
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2104,user.getLanguage());
String needfav ="1";
String needhelp ="";
String roomid = Util.null2String(request.getParameter("roomid"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String starttime = Util.null2String(request.getParameter("starttime"));
String endtime = Util.null2String(request.getParameter("endtime"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
<TBODY>
<%
if(detachable==1){
    String subcompanys=SubCompanyComInfo.getRightSubCompanyStr1(""+subid,subcompanylist);
    for(int i=0; i<subcompanylist.size(); i++){
    	if(!"".equals(subcompanys)){
    		subcompanys += ","+(String)subcompanylist.get(i);
    	}else{
    		subcompanys = (String)subcompanylist.get(i);
    	}
    }
    if(subcompanys.length()>0){
        RecordSet.executeSql("select * from meeting_type where subcompanyid in("+subcompanys+")");
    }else{
    	if(HrmUserVarify.checkUserRight("MeetingType:Maintenance",user)){
	        RecordSet.executeSql("select * from meeting_type where 1=2");
    	}else{
    		RecordSet.executeSql("select * from meeting_type where subcompanyid="+user.getUserSubCompany1());
    	}
    }
}else{
    RecordSet.executeProc("Meeting_Type_SelectAll","");
}
boolean isLight = false;
while(RecordSet.next())
{
	String id = RecordSet.getString("id");
	String name = RecordSet.getString("name");
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
<td><a href="#" onclick="openNewMeeting('<%=id %>','<%=name%>');"><%=name%></a></td>
    </tr>
<%	
	isLight = !isLight;
}%>
</TBODY>
</TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
</body>
	<script type="text/javascript">
		function openNewMeeting(id,name)
		{
			var url = "/systeminfo/BrowserMain.jsp?url=/meeting/data/NewMeetingBrowser.jsp?meetingtype="+id+"&meetingname="+name;
			url+="&roomid=<%=roomid%>&startdate=<%=startdate%>&enddate=<%=enddate%>&starttime=<%=starttime%>&endtime=<%=endtime%>";
			//window.showModalDialog(url,'','dialogWidth:650px;dialogHeight:500px;');
			window.location.href=url;
			window.parent.returnValue = "1";
			//window.close();
		}
	</script>
</html>