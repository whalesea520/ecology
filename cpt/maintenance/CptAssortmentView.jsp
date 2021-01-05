<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String paraid = Util.null2String(request.getParameter("paraid")) ;
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String assortmentid = paraid;

RecordSet.executeProc("CptCapitalAssortment_SByID",assortmentid);
RecordSet.next();

String assortmentname = RecordSet.getString("assortmentname");
String assortmentmark = RecordSet.getString("assortmentmark");
String supassortmentid = RecordSet.getString("supassortmentid");
String supassortmentstr = RecordSet.getString("supassortmentstr");
String assortmentremark= RecordSet.getString("assortmentremark");
String subassortmentcount= RecordSet.getString("subassortmentcount");
String roleid= RecordSet.getString("roleid");
int capitalcount= Util.getIntValue(RecordSet.getString("capitalcount"),0);

boolean canedit = HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Edit", user) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(831,user.getLanguage())+" : "+ Util.toScreen(assortmentname,user.getLanguage());
if(msgid!=-1){
titlename += "<font color=red size=2>" + SystemEnv.getErrorMsgName(msgid,user.getLanguage()) +"</font>" ;
}
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<% if(canedit) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",CptAssortmentEdit.jsp?paraid="+assortmentid+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18422,user.getLanguage())+",CptAssortmentAdd.jsp?paraid="+supassortmentid+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
    if(capitalcount==0){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(18423,user.getLanguage())+",CptAssortmentAdd.jsp?paraid="+assortmentid+",_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
}
if(HrmUserVarify.checkUserRight("CptAssortment:Log", user)){
	if(RecordSet.getDBType().equals("db2")){
   RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem) = 43 and relatedid="+assortmentid+",_self} " ;
   }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem = 43 and relatedid="+assortmentid+",_self} " ;
  
  }
	
	RCMenuHeight += RCMenuHeightStep ;
}
if(capitalcount>0){
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1509,user.getLanguage())+",/cpt/search/SearchOperation.jsp?isdata=1&capitalgroupid="+assortmentid+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(535,user.getLanguage())+",/cpt/search/SearchOperation.jsp?isdata=2&capitalgroupid="+assortmentid+",_self} " ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM id=frmain name=frmain action=CptAssortmentOperation.jsp method=post>
<input type="hidden" name="assortmentid" value="<%=assortmentid%>">
<input type="hidden" name="supassortmentid" value="<%=supassortmentid%>">
<input type="hidden" name="supassortmentstr" value="<%=supassortmentstr%>">
<input type="hidden" name="operation" value="addassortment">

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

		<TABLE class=ViewForm>
		  <TBODY>
		  <TR>
			<TD vAlign=top><!-- General -->
				<TABLE class=ViewForm>
				  <COLGROUP> <COL width=130> <TBODY> 
				  <TR class=Title> 
					<TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
				  </TR>
				  <TR class=Spacing style="height:2px"> 
					<TD class=Line1 colSpan=2></TD>
				  </TR>
				 <TR> 
					<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
					<td class=FIELD><%=Util.toScreen(assortmentname,user.getLanguage())%></td>
				  </TR>
				  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				 <TR> 
					<td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
					<td class=FIELD><%=Util.toScreen(assortmentmark,user.getLanguage())%></td>
				  </TR>
				  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				  </TBODY> 
				</TABLE>
			  </TD>
			</TR></TBODY></TABLE>
		  <TABLE class=ViewForm>
			<TR class=Title> 
			  <TH><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
			</TR>
			<TR class=Spacing style="height:2px"> 
			  <TD class=Line1></TD>
			</TR>
			<TR> 
			  <TD vAlign=top><%=Util.toScreen(assortmentremark,user.getLanguage())%></TD>
			</TR>
			<%if (supassortmentid.equals("0") && canedit){%>
			<tr>
			  <td>
				<table class=Form>
				  <colgroup> <col width="30%"> <col width="60%"> <col width="10%"> <tbody> 
				  <tr class=Title> 
					<th ><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></th>
					<td align=right colspan=2 > <a href="/cpt/maintenance/CptAssortmentAddShare.jsp?assortmentid=<%=assortmentid%>&assortname=<%=Util.toScreen(assortmentremark,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a> 
					</td>
				  </tr>
				  <tr class=Spacing style="height:2px"> 
					<td class=Line1 colspan=3></td>
				  </tr>
			   <%
			   RecordSetShare.executeSql("select * from CptAssortmentShare where assortmentid="+assortmentid);
			   while(RecordSetShare.next()){
			if(RecordSetShare.getInt("sharetype")==1)	{
		%>
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
				  <td class=Field> <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetShare.getString("userid")%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetShare.getString("userid")),user.getLanguage())%></a>/
					<% if(RecordSetShare.getInt("sharelevel")==1){%>
					<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
					<%}%>
					<% if(RecordSetShare.getInt("sharelevel")==2){%>
					<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
					<%}%> </td>
				  <td class=Field> 
					<%if(RecordSetShare.getInt("sharelevel")==1){%>
					<a href="/cpt/maintenance/AssortShareOperation.jsp?forward=view&method=delete&id=<%=RecordSetShare.getString("id")%>&assortid=<%=assortmentid%>&assortname=<%=assortmentname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
					<%} else if((RecordSetShare.getInt("sharelevel")==2)&&canedit){%>
					<a href="/cpt/maintenance/AssortShareOperation.jsp?forward=view&method=delete&id=<%=RecordSetShare.getString("id")%>&assortid=<%=assortmentid%>&assortname=<%=assortmentname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
				<%}else if(RecordSetShare.getInt("sharetype")==2)	{%>
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
				  <td class=Field> <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSetShare.getString("departmentid")%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSetShare.getString("departmentid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/
					<% if(RecordSetShare.getInt("sharelevel")==1){%>
					<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%> 
					<%}%>
					<% if(RecordSetShare.getInt("sharelevel")==2){%>
					<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
					<%}%> </td>
				 <td class=Field> 
					<%if(RecordSetShare.getInt("sharelevel")==1){%>
					<a href="/cpt/maintenance/AssortShareOperation.jsp?forward=view&method=delete&id=<%=RecordSetShare.getString("id")%>&assortid=<%=assortmentid%>&assortname=<%=assortmentname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
					<%} else if((RecordSetShare.getInt("sharelevel")==2)&&canedit){%>
					<a href="/cpt/maintenance/AssortShareOperation.jsp?forward=view&method=delete&id=<%=RecordSetShare.getString("id")%>&assortid=<%=assortmentid%>&assortname=<%=assortmentname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
				<%}else if(RecordSetShare.getInt("sharetype")==3)	{%>
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
				  <td class=Field> <%=Util.toScreen(RolesComInfo.getRolesRemark(RecordSetShare.getString("roleid")),user.getLanguage())%>/
					<% if(RecordSetShare.getInt("rolelevel")==0) {%>
					<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> 
					<%} if(RecordSetShare.getInt("rolelevel")==1) {%>
					<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%> 
					<%} if(RecordSetShare.getInt("rolelevel")==2) {%>
					<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><%}%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/
					<% if(RecordSetShare.getInt("sharelevel")==1){%>
					<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%> 
					<%}%>
					<% if(RecordSetShare.getInt("sharelevel")==2){%>
					<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%> 
					<%}%></td>
				  <td class=Field> 
					<%if(RecordSetShare.getInt("sharelevel")==1){%>
					<a href="/cpt/maintenance/AssortShareOperation.jsp?forward=view&method=delete&id=<%=RecordSetShare.getString("id")%>&assortid=<%=assortmentid%>&assortname=<%=assortmentname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
					<%} else if((RecordSetShare.getInt("sharelevel")==2)&&canedit){%>
					<a href="/cpt/maintenance/AssortShareOperation.jsp?forward=view&method=delete&id=<%=RecordSetShare.getString("id")%>&assortid=<%=assortmentid%>&assortname=<%=assortmentname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
				<%}else if(RecordSetShare.getInt("sharetype")==4)	{%>
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></td>
				  <td class=Field> <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/
					<% if(RecordSetShare.getInt("sharelevel")==1){%>
					<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%> 
					<%}%>
					<% if(RecordSetShare.getInt("sharelevel")==2){%>
					<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
					<%}%> </td>
				  <td class=Field> 
					<%if(RecordSetShare.getInt("sharelevel")==1){%>
					<a href="/cpt/maintenance/AssortShareOperation.jsp?forward=view&method=delete&id=<%=RecordSetShare.getString("id")%>&assortid=<%=assortmentid%>&assortname=<%=assortmentname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
					<%} else if((RecordSetShare.getInt("sharelevel")==2)&&canedit){%>
					<a href="/cpt/maintenance/AssortShareOperation.jsp?forward=view&method=delete&id=<%=RecordSetShare.getString("id")%>&assortid=<%=assortmentid%>&assortname=<%=assortmentname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>	
				<%}%>
				<%}%>
				  </tbody> 
				</table>
				<%}%>
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
<SCRIPT language="JavaScript">
function goBack() {
	document.location.href = "CptAssortment.jsp";
}
function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmain.operation.value="deleteassortment";
			document.frmain.submit();
		}
}
</SCRIPT>
</FORM>
</BODY></HTML>
