
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%
String ProjID = Util.null2String(request.getParameter("ProjID"));

String log=Util.null2String(request.getParameter("log"));

RecordSetM.executeProc("Task_Modify_Select",ProjID);

RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(103,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())+SystemEnv.getHtmlLabelName(264,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(101,user.getLanguage())+":<a href='/proj/process/ViewProcess.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/data/ViewTaskLog.jsp?ProjID="+ProjID+",_self} " ;
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<%
if(RecordSetM.getCounts()<=0)
{%>
<p><%=SystemEnv.getHtmlNoteName(30,user.getLanguage())%></p>
<%}
else
{%>



  <TABLE class=liststyle cellspacing=1 >
        <COLGROUP>
		<COL width="25%">
  		<COL width="25%">
  		<COL width="25%">
		<COL width="25%">
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(613,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(563,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(563,user.getLanguage())%></th>
	    </TR>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(424,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%> IP</th>
	    </TR>
<%
	String strType = "";
	boolean isLight = false;
	while(RecordSetM.next())
	{
		if(isLight)
		{%>	
		<TR CLASS=DataDark>
<%		}else{%>
		<TR CLASS=DataLight>
<%		} %>
<%
    String taskid= RecordSetM.getString("taskid");
    String sql_task="select subject from Prj_TaskProcess where id ="+ taskid;
    RecordSetT.executeSql(sql_task);
    RecordSetT.next();
    String taskname=RecordSetT.getString("subject");
    String fieldname=RecordSetM.getString("fieldname");
%>
        <td width="25%"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>:<%=taskname%></td>
        <td width="25%">
        <%if(fieldname.equals("subject")){%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%><%}%>
        <%if(fieldname.equals("hrmid")){%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%><%}%>
        <%if(fieldname.equals("begindate")){%><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%><%}%>
        <%if(fieldname.equals("enddate")){%><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%><%}%>
        <%if(fieldname.equals("workday")){%><%=SystemEnv.getHtmlLabelName(1298,user.getLanguage())%><%}%>
        <%if(fieldname.equals("finish")){%><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(622,user.getLanguage())%><%}%>
        <%if(fieldname.equals("islandmark")){%><%=SystemEnv.getHtmlLabelName(2232,user.getLanguage())%><%}%>
        <%if(fieldname.equals("content")){%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%><%}%>
        <%if(fieldname.equals("fixedcost")){%><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%><%}%>
        <%if(fieldname.equals("pretask")){%><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%><%}%>
        </td>
	
<%
    /*查看修改成员*/
String Members_ori=RecordSetM.getString("original");
String Members_mod=RecordSetM.getString("modified");
String Memname_o="";
String Memname_m="";
Memname_o= Util.toScreen(ResourceComInfo.getResourcename(Members_ori),user.getLanguage());
Memname_m= Util.toScreen(ResourceComInfo.getResourcename(Members_mod),user.getLanguage());

%>

        <td width="25%">
        <%if((RecordSetM.getString("fieldname")).equals("hrmid")){%><%=Memname_o%>
            <%}else if(fieldname.equals("islandmark")){
                    if(RecordSetM.getString("original").equals("0")){%>
                        <%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
                    <%}
                    else{%>
                        <%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
                    <%}
              }else{%>
        <%=Util.toScreen(RecordSetM.getString("original"),user.getLanguage())%><%}%></td>
        <td width="25%">
        <%if((RecordSetM.getString("fieldname")).equals("hrmid")){%><%=Memname_m%>            
            <%}else if(fieldname.equals("islandmark")){
                    if(RecordSetM.getString("modified").equals("0")){%>
                        <%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
                    <%}
                    else{%>
                        <%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
                    <%}
              }else{%>
        <%=Util.toScreen(RecordSetM.getString("modified"),user.getLanguage())%><%}%></td>
        </TR>
<%		if(isLight)
		{%>	
		<TR CLASS=DataDark>
<%		}else{%>
		<TR CLASS=DataLight>
<%		}%>
			<td width="25%"><%=RecordSetM.getString("modifydate")%></td>
			<td width="25%"><%=RecordSetM.getString("modifytime")%></td>
		  <td width="25%">
	<%if(!user.getLogintype().equals("2")) {%>
		<%if(!RecordSetM.getString("submitertype").equals("2")) {%>		  
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetM.getString("modifier")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetM.getString("modifier")),user.getLanguage())%></a>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetM.getString("modifier")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetM.getString("modifier")),user.getLanguage())%></a>		
		<%}%>
	<%}else{%>
		<%if(!RecordSetM.getString("submitertype").equals("2")) {%>		  
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetM.getString("modifier")),user.getLanguage())%>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetM.getString("modifier")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetM.getString("modifier")),user.getLanguage())%></a>		
		<%}%>	
	<%}%>
				</td>

			<td width="25%"><%=RecordSetM.getString("clientip")%></td>
        </TR>
<%
		isLight = !isLight;
	}%>
	  </TBODY>
	  </TABLE>
	
<%
}
%>
  </td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</body>
</html>
