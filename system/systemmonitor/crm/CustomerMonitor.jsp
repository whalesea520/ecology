
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%
if(!HrmUserVarify.checkUserRight("EditCustomer:Delete",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
//end by mackjoe

String name = Util.null2String(request.getParameter("name"));
String engname = Util.null2String(request.getParameter("engname"));
String type = Util.null2String(request.getParameter("type"));
String city = Util.null2String(request.getParameter("City"));
String country1 = Util.null2String(request.getParameter("country1"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String crmManager = Util.null2String(request.getParameter("Manager"));
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
}
if(!engname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where engname like '%" + Util.fromScreen2(engname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and engname like '%" + Util.fromScreen2(engname,user.getLanguage()) +"%' ";
}
if(!type.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where type = "+ type ;
	}
	else
		sqlwhere += " and type = "+ type;
}
if(!city.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where city = " + city ;
	}
	else
		sqlwhere += " and city = " + city ;
}
if(!country1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where country = "+ country1 ;
	}
	else
		sqlwhere += " and country = "+ country1;
}
if(!departmentid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where department =" + departmentid +" " ;
	}
	else
		sqlwhere += " and department =" + departmentid +" " ;
}
if(!crmManager.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where manager =" + crmManager +" " ;
	}
	else
		sqlwhere += " and manager =" + crmManager +" " ;
}

String sqlstr = "";
if(ishead==0){
		ishead = 1;
		sqlwhere += " where id != 0 " ;
}

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);

int	perpage=50;

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17648,user.getLanguage());
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

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="CustomerMonitor.jsp" method=post>
<input type=hidden name=operation>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteCrm(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+xssUtil.put("where operateitem=99")+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;    
%>

<table width=100% class=ViewForm>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TD>
<TD width=35% class=field><input class=InputStyle  name=name value="<%=name%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=InputStyle id=type name=type>
        <option value=""></option>
<%if(!Util.null2String(request.getParameter("sqlwhere")).equals("where type in (3,4)")){%>
       	<%
       	while(CustomerTypeComInfo.next()){
       	%>
          <option value="<%=CustomerTypeComInfo.getCustomerTypeid()%>" <%if(type.equalsIgnoreCase(CustomerTypeComInfo.getCustomerTypeid())) {%>selected<%}%>><%=CustomerTypeComInfo.getCustomerTypename()%></option>
        <%}%>
<%}else{%>
       	<%
       	while(CustomerTypeComInfo.next()){
		if(CustomerTypeComInfo.getCustomerTypeid().equals("3") || CustomerTypeComInfo.getCustomerTypeid().equals("4")){
       	%>
          <option value="<%=CustomerTypeComInfo.getCustomerTypeid()%>" <%if(type.equalsIgnoreCase(CustomerTypeComInfo.getCustomerTypeid())) {%>selected<%}%>><%=CustomerTypeComInfo.getCustomerTypename()%></option>
        <%}}%>
<%}%>
        </select>

      </TD>
</TR><tr style="height:1px "><td class=Line colspan=4></td></tr>
<TR>

 <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
          <TD class=Field>
             <INPUT class=wuiBrowser 
             _displayText="&nbsp;<a href='/hrm/resource/HrmResource.jsp?id=<%=crmManager%>'><%=Util.toScreen(ResourceComInfo.getResourcename(crmManager),user.getLanguage())%></a>" 
             _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" 
             _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
             type=hidden name=Manager value=<%=crmManager%>></TD>

<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=InputStyle id=departmentid name=departmentid>
		<option value=""></option>
		<% while(DepartmentComInfo.next()) {
			String tmpdepartmentid = DepartmentComInfo.getDepartmentid() ;
			String canceled = DepartmentComInfo.getDeparmentcanceled();
			if("0".equals(canceled) || "".equals(canceled)){
		%>
          <option value=<%=tmpdepartmentid%> <% if(tmpdepartmentid.equals(departmentid)) {%>selected<%}%>>
		  <%=Util.toScreen(DepartmentComInfo.getDepartmentname(),user.getLanguage())%></option>
		<% }} %>
        </select>
      </TD>


</TR><tr style="height:1px "><td class=Line colspan=4></td></tr>

<TR class=Spacing style="height:1px "><TD class=Line1 colspan=6></TD></TR>
</table>

<TABLE width="100%">
	<tr>
		<td valign="top">
              <%


            String backfields = "id, name, type, city, country,manager,(select departmentid from hrmresource t2 where t2.id =t1.manager) as department";
            String fromSql  = " from CRM_CustomerInfo t1";
            String sqlWhere = "";
            if(user.getLogintype().equals("1")){
            	sqlWhere = sqlwhere +" and (deleted=0 or deleted is null)  ";
            }else{
            	sqlWhere = sqlwhere +" and (deleted=0 or deleted is null)  ";
            }
			//out.print("select  "+backfields + "from " +fromSql + "where " +sqlWhere);
            String orderby = "id" ;
            String tableString = "";
            tableString =" <table instanceid=\"cptcapitalDetailTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
                                     "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
                                     "			<head>"+
                                     "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(136,user.getLanguage())+"ID"+"\" column=\"id\" orderkey=\"id\" />"+
                                     "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(460,user.getLanguage())+"\" column=\"name\"  orderkey=\"name\" />"+
                                   	 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"type\" orderkey=\"type\"  transmethod=\"weaver.crm.Maint.CustomerTypeComInfo.getCustomerTypename\" />"+
                                   	 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(1278,user.getLanguage())+"\" column=\"manager\"  orderkey=\"manager\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
                      				 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"department\"  orderkey=\"department\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" />"+
                                     "			</head>"+
                                     "</table>";
         %>
         <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
		</td>
	</tr>
</TABLE>
</FORM>
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
</BODY></HTML>


<SCRIPT LANGUAGE=VBS>
sub onShowManagerID()
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id1)) then
	if id1(0)<> "" then
	manageridspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id1(0)&"'>"&id1(1)&"</A>"
	weaver.Manager.value=id1(0)
	else
	manageridspan.innerHtml = ""
	weaver.Manager.value=""
	end if
	end if
end sub
</SCRIPT>
<script language="javascript">
function deleteCrm(){
	//alert(_xtable_CheckedCheckboxId());
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.SearchForm.operation.value='deletecrm';
        document.SearchForm.action='/system/systemmonitor/MonitorOperation.jsp?deletecrmid='+_xtable_CheckedCheckboxId();
        document.SearchForm.submit();
	}
}
</script>
