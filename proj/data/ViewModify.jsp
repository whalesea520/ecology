
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%
String ProjID = Util.null2String(request.getParameter("ProjID"));




String log=Util.null2String(request.getParameter("log"));

RecordSetM.executeProc("Prj_Modify_Select",ProjID);

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
String titlename = SystemEnv.getHtmlLabelName(618,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(101,user.getLanguage())+":<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/data/ViewLog.jsp?log=n&ProjID="+ProjID+",_self} " ;
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
	      <th><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
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
<%		}
		strType = RecordSetM.getString("type");
		if(strType.substring(0,1).equals("m"))
		{
			if(strType.substring(1).equals("Member"))
			{
%>
			<td width="25%"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></td>
		  <td width="25%">
	<%if(!user.getLogintype().equals("2")) {%>
		<%if(!RecordSetM.getString("submitertype").equals("2")) {%>		  
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetM.getString("fieldname")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetM.getString("fieldname")),user.getLanguage())%></a>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetM.getString("fieldname")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetM.getString("fieldname")),user.getLanguage())%></a>		
		<%}%>
	<%}else{%>
		<%if(!RecordSetM.getString("submitertype").equals("2")) {%>		  
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetM.getString("fieldname")),user.getLanguage())%>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetM.getString("fieldname")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetM.getString("fieldname")),user.getLanguage())%></a>		
		<%}%>	
	<%}%>
				</td>

<%
			} else {
%>
			<td width="25%"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
			<td width="25%">
			<%
			//TD2464
			//modified by hubo,2006-03-15
			if(RecordSetM.getString("fieldname").equals("name")){out.println(SystemEnv.getHtmlLabelName(195,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("description")){out.println(SystemEnv.getHtmlLabelName(783,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("prjtype")){out.println(SystemEnv.getHtmlLabelName(586,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("proCode")){out.println(SystemEnv.getHtmlLabelName(17852,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("protemplateid")){out.println(SystemEnv.getHtmlLabelName(18375,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("worktype")){out.println(SystemEnv.getHtmlLabelName(432,user.getLanguage()));}
			//else if(RecordSetM.getString("fieldname").equals("securelevel")){out.println(SystemEnv.getHtmlLabelName(586,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("status")){out.println(SystemEnv.getHtmlLabelName(587,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("isblock")){out.println(SystemEnv.getHtmlLabelName(624,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("managerview")){out.println(SystemEnv.getHtmlLabelName(15263,user.getLanguage()));}
			//else if(RecordSetM.getString("fieldname").equals("picid")){out.println(SystemEnv.getHtmlLabelName(586,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("intro")){out.println(SystemEnv.getHtmlLabelName(586,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("parentid")){out.println(SystemEnv.getHtmlLabelName(636,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("envaluedoc")){out.println(SystemEnv.getHtmlLabelName(637,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("confirmdoc")){out.println(SystemEnv.getHtmlLabelName(638,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("proposedoc")){out.println(SystemEnv.getHtmlLabelName(639,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("manager")){out.println(SystemEnv.getHtmlLabelName(144,user.getLanguage()));}
			else if(RecordSetM.getString("fieldname").equals("department")){out.println(SystemEnv.getHtmlLabelName(124,user.getLanguage()));}
			else{out.println(RecordSetM.getString("fieldname")+"("+SystemEnv.getHtmlLabelName(17037,user.getLanguage())+")");}
			%>
			</td>
<%		}	
	}
		else if(strType.substring(0,1).equals("a"))
		{
			if(strType.substring(1).equals("Member"))
			{
%>
			<td width="25%"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></td>
		  <td width="25%">
	<%if(!user.getLogintype().equals("2")) {%>
		<%if(!RecordSetM.getString("submitertype").equals("2")) {%>		  
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetM.getString("fieldname")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetM.getString("fieldname")),user.getLanguage())%></a>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetM.getString("fieldname")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetM.getString("fieldname")),user.getLanguage())%></a>		
		<%}%>
	<%}else{%>
		<%if(!RecordSetM.getString("submitertype").equals("2")) {%>		  
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetM.getString("fieldname")),user.getLanguage())%>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetM.getString("fieldname")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetM.getString("fieldname")),user.getLanguage())%></a>		
		<%}%>	
	<%}%>
				</td>

<%
			}
			else if(strType.substring(1).equals("Customer"))
			{
%>
			<td width="25%"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></td>
			<td width="25%"><A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetM.getString("fieldname")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetM.getString("fieldname")),user.getLanguage())%></A></td>
<%
			}
			else
			{
%>
			<td width="25%"><%=strType%></td>
			<td width="25%"><%=Util.toScreen(RecordSetM.getString("fieldname"),user.getLanguage())%></td>
<%
			}
%>
<%		}
		else if(strType.substring(0,1).equals("d"))
		{
			if(strType.substring(1).equals("Member"))
			{
%>
		  <td width="25%">
	<%if(!user.getLogintype().equals("2")) {%>
		<%if(!RecordSetM.getString("submitertype").equals("2")) {%>		  
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetM.getString("fieldname")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetM.getString("fieldname")),user.getLanguage())%></a>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetM.getString("fieldname")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetM.getString("fieldname")),user.getLanguage())%></a>		
		<%}%>
	<%}else{%>
		<%if(!RecordSetM.getString("submitertype").equals("2")) {%>		  
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetM.getString("fieldname")),user.getLanguage())%>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetM.getString("fieldname")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetM.getString("fieldname")),user.getLanguage())%></a>		
		<%}%>	
	<%}%>
				</td>

<%
			}
			else if(strType.substring(1).equals("Customer"))
			{
%>
			<td width="25%"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></td>
			<td width="25%"><A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetM.getString("fieldname")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetM.getString("fieldname")),user.getLanguage())%></A></td>
<%
			}
			else
			{
%>
			<td width="25%"><%=strType%></td>
			<td width="25%"><%=Util.toScreen(RecordSetM.getString("fieldname"),user.getLanguage())%></td>
<%
			}
%>
<%		}
%>

<%
    /*查看修改成员*/
String Members_ori=RecordSetM.getString("original");
String Members_mod=RecordSetM.getString("modified");
String Memname_o="";
String Memname_m="";

ArrayList Members_01 = Util.TokenizerString(Members_ori,",");
int Membernum_01 = Members_01.size();

for(int i=0;i<Membernum_01;i++){
    Memname_o= Memname_o+""+Util.toScreen(ResourceComInfo.getResourcename(""+Members_01.get(i)),user.getLanguage());
    Memname_o+=" ";
}

ArrayList Members_02 = Util.TokenizerString(Members_mod,",");
int Membernum_02 = Members_02.size();

for(int i=0;i<Membernum_02;i++){
    Memname_m= Memname_m+""+Util.toScreen(ResourceComInfo.getResourcename(""+Members_02.get(i)),user.getLanguage());
    Memname_m+=" ";
}
%>

			<td width="25%">
            <%if((RecordSetM.getString("fieldname")).equals("members")){%><%=Memname_o%><%}else{%>
            <%=Util.toScreen(RecordSetM.getString("original"),user.getLanguage())%><%}%></td>
			<td width="25%">
            <%if((RecordSetM.getString("fieldname")).equals("members")){%><%=Memname_m%><%}else{%>
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
