
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" /> 
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

int languageId=user.getLanguage();
int seccategory = Util.getIntValue(request.getParameter("seccategory"));
RecordSet.executeProc("Doc_SecCategory_SelectByID",seccategory+"");
RecordSet.next();

String hashrmres = Util.toScreen(RecordSet.getString("hashrmres"),languageId);
String hrmreslabel = Util.toScreenToEdit(RecordSet.getString("hrmreslabel"),languageId);
int hrmresid=Util.getIntValue(request.getParameter("hrmresid"));

String hasasset=Util.toScreen(RecordSet.getString("hasasset"),languageId);
String assetlabel=Util.toScreen(RecordSet.getString("assetlabel"),languageId);
int assetid=Util.getIntValue(request.getParameter("assetid"));

String hascrm =Util.toScreen(RecordSet.getString("hascrm"),languageId);
String crmlabel =Util.toScreenToEdit(RecordSet.getString("crmlabel"),languageId);
int crmid=Util.getIntValue(request.getParameter("crmid"));

String hasitems =Util.toScreen(RecordSet.getString("hasitems"),languageId);
String itemlabel =Util.toScreenToEdit(RecordSet.getString("itemlabel"),languageId);
int itemid=Util.getIntValue(request.getParameter("itemid"));

String hasproject =Util.toScreen(RecordSet.getString("hasproject"),languageId);
String projectlabel =Util.toScreenToEdit(RecordSet.getString("projectlabel"),languageId);
int projectid=Util.getIntValue(request.getParameter("projectid"));

String hasfinance =Util.toScreen(RecordSet.getString("hasfinance"),languageId);
String financelabel =Util.toScreenToEdit(RecordSet.getString("financelabel"),languageId);
int financeid=Util.getIntValue(request.getParameter("financeid"));
%>
	<%
	String sepStr="<TR><TD class=Line colSpan=4></TD></TR>";
	int needtr=0;
	if(!hashrmres.trim().equals("0")&&!hashrmres.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(179,languageId);
		if(!hrmreslabel.trim().equals("")) curlabel = hrmreslabel;
		%>
		<% if(needtr==0){ out.println("<tr height=\"18\">");}%>
		<td><%=curlabel%></td>
		<td class=field>
		<%if(!user.getLogintype().equals("2")){%>
			<%if(hrmresid!=0){%>
				<A href="javaScript:openhrm(<%=hrmresid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(""+hrmresid),languageId)%></A>
			<%}%>
		<%}%>
		</td>
		<%
		if(needtr==1){
			out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}
	%>
	
	<%
	if(!hasasset.trim().equals("0")&&!hasasset.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(535,languageId);
		if(!assetlabel.trim().equals("")) curlabel = assetlabel;
		%>
		<% if(needtr==0){ out.println("<tr height=\"18\">");}%>
		<td><%=curlabel%></td>
		<td class=field>
		<%if(!user.getLogintype().equals("2")){%>
			<%if(assetid!=0){%>
				<a href="/cpt/capital/CptCapital.jsp?id=<%=assetid%>"><%=Util.toScreen(CapitalComInfo.getCapitalname(assetid+""),languageId)%></a>
			<%}%>
		<%}%>
		</td>
		<%
		if(needtr==1){
			out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}
	%>

	<%
	if(!hascrm.trim().equals("0")&&!hascrm.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(147,languageId);
		if(!crmlabel.trim().equals("")) curlabel = crmlabel;
		%>
		<% if(needtr==0){ out.println("<tr height=\"18\">");}%>
		<td><%=curlabel%></td>
		<td class=field>
		<%if(crmid!=0){%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=crmid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+crmid),languageId)%></a>
		<%}%>
		</td>
		<%
		if(needtr==1){
			out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}
	%>
	
	<%
	if(!hasitems.trim().equals("0")&&!hasitems.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(145,languageId);
		if(!itemlabel.trim().equals("")) curlabel = itemlabel;
		%>
		<% if(needtr==0){ out.println("<tr height=\"18\">");}%>
		<td><%=curlabel%></td>
		<td class=field>
		<%if(itemid!=0){%>
			<A href='/lgc/asset/LgcAsset.jsp?paraid=<%=itemid%>'><%=AssetComInfo.getAssetName(""+itemid)%></a>
		<%}%>
		</td>
		<%
		if(needtr==1){
			out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}
	%>
	
	<%
	if(!hasproject.trim().equals("0")&&!hasproject.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(101,languageId);
		if(!projectlabel.trim().equals("")) curlabel = projectlabel;
		%>
		<% if(needtr==0){ out.println("<tr height=\"18\">");}%>
		<td><%=curlabel%></td>
		<td class=field>
		<%if(projectid!=0){%>
			<A href="/proj/data/ViewProject.jsp?ProjID=<%=projectid%>"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(""+projectid),languageId)%></a>
		<%}%>
		</td>
		<%
		if(needtr==1){
			out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}
	%>
	
	<%
	if(!hasfinance.trim().equals("0")&&!hasfinance.trim().equals("")){
		String curlabel = SystemEnv.getHtmlLabelName(189,languageId);
		if(!financelabel.trim().equals("")) curlabel = financelabel;
		%>
		<% if(needtr==0){ out.println("<tr height=\"18\">");}%>
		<td><%=curlabel%></td>
		<td class=field>
		<%if(financeid!=0) {%><%=financeid%><%}%>
		</td>
		<%
		if(needtr==1){
			out.print("</tr>"+sepStr+"<tr>");
			needtr=0;
		} else needtr++;
	}
	%>