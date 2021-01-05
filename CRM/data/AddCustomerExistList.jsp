
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String type = Util.null2String(request.getParameter("type"));
String name = Util.null2String(request.getParameter("name"));
String CRM_CustomerInfo_SelectName = "select * from CRM_CustomerInfo where name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%'" ;
RecordSet.executeSql(CRM_CustomerInfo_SelectName);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


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

<FORM id=weaver name= weaver action="/CRM/data/AddCustomer.jsp" method=post >
<input type=hidden name="name" value="<%=name%>">
<input type=hidden name="type" value="<%=type%>">
	  <TABLE class=ViewForm width=250>
        <COLGROUP>
		<COL width="50">
  		<COL width="200">
        <TBODY>
        <tr><td class=Line1 colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          
          <td class=Field id=txtLocation>
			<%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(type),user.getLanguage())%>
          </TD>
        </TR><tr><td class=Line colspan=2></td></tr>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
			<%=Util.toScreenToEdit(name,user.getLanguage())%>
		  </TD>
        </TR><tr><td class=Line colspan=2></td></tr>

		<TR>
		  <TD COLSPAN=2>
			<DIV style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
			<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location='/CRM/data/AddCustomerExist.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
			<BUTTON class=btn accessKey=1 onclick="location='/CRM/data/AddCustomerExist.jsp'"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
			</DIV>	
		  </TD>
	  </TR><tr><td class=Line colspan=2></td></tr>
	  </TBODY>
	 </TABLE>
</FORM>

<TABLE class=ListStyle cellspacing=1>
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></th>

  </tr>
<TR class=Line><TD colSpan=5></TD></TR>
<%
boolean isLight = false;
	while(RecordSet.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
		<TD><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString(1)%>"><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("type")),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(RecordSet.getString("typebegin"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(RecordSet.getString("city"),user.getLanguage())%></TD>
		<TD><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></a></TD>
	</TR>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 </TABLE>


</BODY>
 

</HTML>
