<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(!user.getLogintype().equals("1")){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(119,user.getLanguage())+SystemEnv.getHtmlLabelName(622,user.getLanguage());
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
<%
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
if(perpage<=1 )	perpage=10;
int CustomerDepartment=Util.getIntValue(request.getParameter("CustomerDepartment"),0);
int AccountManager=Util.getIntValue(request.getParameter("AccountManager"),0);
String CustomerName=Util.fromScreen(request.getParameter("CustomerName"),user.getLanguage());
String CustomerName2=Util.fromScreen2(request.getParameter("CustomerName"),user.getLanguage());

String sqlwhere="";
if(CustomerDepartment!=0){
	if(sqlwhere.equals(""))	sqlwhere+=" where t3.department="+CustomerDepartment;
	else	sqlwhere+=" and t3.department="+CustomerDepartment;
}
if(AccountManager!=0){
	if(sqlwhere.equals(""))	sqlwhere+=" where t3.manager="+AccountManager;
	else	sqlwhere+=" and t3.manager="+AccountManager;
}
if(!CustomerName.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t3.name like '%"+CustomerName2+"%'";
	else 	sqlwhere+=" and t3.name like '%"+CustomerName2+"%'";
}
if(sqlwhere.equals("")){
		sqlwhere += " where t1.id != 0 " ;
}
String sqlstr = "";
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
String temptable = "temptable"+ Util.getNumberRandom() ;
if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
		sqlstr = "create table "+temptable+"  as select * from (select distinct t1.*,t3.manager as manager,t3.department as department from CRM_ShareInfo  t1,"+leftjointable+"  t2, CRM_CustomerInfo  t3  "+ sqlwhere +" and t1.relateditemid = t3.id and t1.relateditemid = t2.relateditemid and (t3.deleted =0 or t3.deleted is null)  order by t1.relateditemid desc,t1.userid desc,t1.departmentid desc,t1.roleid desc) where rownum<"+ (pagenum*perpage+2);
	}else{
		sqlstr = "create table "+temptable+"  as select * from (select t1.*,t3.manager as manager,t3.department as department from CRM_ShareInfo  t1,CRM_CustomerInfo  t3 "+ sqlwhere +" and t1.relateditemid = t3.id and t3.agent="+user.getUID() + " and (t3.deleted =0 or t3.deleted is null)   order by t1.relateditemid desc,t1.userid desc,t1.departmentid desc,t1.roleid desc) where rownum<"+ (pagenum*perpage+2);
	}
}else if(RecordSet.getDBType().equals("db2")){
	if(user.getLogintype().equals("1")){
		sqlstr = "create table "+temptable+"  as (select distinct t1.*,t3.manager as manager,t3.department as department from CRM_ShareInfo  t1,"+leftjointable+"  t2, CRM_CustomerInfo  t3  ) definition only";
        RecordSet.executeSql(sqlstr);
        sqlstr = "insert into "+temptable+" (select distinct t1.*,t3.manager as manager,t3.department as department from CRM_ShareInfo  t1,"+leftjointable+"  t2, CRM_CustomerInfo  t3  "+ sqlwhere +" and t1.relateditemid = t3.id and t1.relateditemid = t2.relateditemid order by t1.relateditemid desc,t1.userid desc,t1.departmentid desc,t1.roleid desc fetch first "+(pagenum*perpage+1)+"  rows only)";
    }else{
		sqlstr = "create table "+temptable+"  as (select t1.*,t3.manager as manager,t3.department as department from CRM_ShareInfo  t1,CRM_CustomerInfo  t3) definition only";
        RecordSet.executeSql(sqlstr);
        sqlstr = "insert into "+temptable+" (select t1.*,t3.manager as manager,t3.department as department from CRM_ShareInfo  t1,CRM_CustomerInfo  t3 "+ sqlwhere +" and t1.relateditemid = t3.id and t3.agent="+user.getUID() + "  order by t1.relateditemid desc,t1.userid desc,t1.departmentid desc,t1.roleid desc fetch first "+(pagenum*perpage+1)+"  rows only)";
    }
}else{
	if(user.getLogintype().equals("1")){
		sqlstr = "select distinct top "+(pagenum*perpage+1)+" t1.*,t3.manager as manager,t3.department as department into "+temptable+" from CRM_ShareInfo  t1,"+leftjointable+"  t2, CRM_CustomerInfo  t3  "+ sqlwhere +" and t1.relateditemid = t3.id and t1.relateditemid = t2.relateditemid and (t3.deleted =0 or t3.deleted is null)  order by t1.relateditemid desc,t1.userid desc,t1.departmentid desc,t1.roleid desc";
	}else{
		sqlstr = "select top "+(pagenum*perpage+1)+" t1.*,t3.manager as manager,t3.department as department into "+temptable+" from CRM_ShareInfo  t1,CRM_CustomerInfo  t3 "+ sqlwhere +" and t1.relateditemid = t3.id and t3.agent="+user.getUID() + " and (t3.deleted =0 or t3.deleted is null)   order by t1.relateditemid desc,t1.userid desc,t1.departmentid desc,t1.roleid desc";
	}

}

RecordSet.executeSql(sqlstr);
RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by relateditemid,userid,departmentid,roleid) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
	sqltemp="select  * from "+temptable+"  order by relateditemid,userid,departmentid,roleid fetch first "+(RecordSetCounts-(pagenum-1)*perpage+1)+"  rows only";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by relateditemid,userid,departmentid,roleid";
}

RecordSet.executeSql(sqltemp);
%>
<form name=weaver id="weaver" method=post action="CRMShareLogRp.jsp">
  <input type="hidden" name="pagenum" value=''>
<div style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<BUTTON class=btnRefresh type="submit" accesskey="R"><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON>
</div>
<table class=ViewForm>
  <tbody>
  </TR ><tr style="height:2px" ><td class=Line1 colspan=9></td></tr>
  <tr>
	<td align=right><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
	<td class=field>
	   <input class=wuiBrowser id=CustomerDepartment type=hidden name="CustomerDepartment" value="<%=CustomerDepartment%>"
	   _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	   _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+CustomerDepartment),user.getLanguage())%>"
	   >
	</td>
	<td align=right><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></td>
	<td class=field>	  
	  <INPUT class=wuiBrowser class=InputStyle type=hidden name="AccountManager" value="<%=AccountManager%>"
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	  _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}' target='_blank' >#b{name}</A>"
	  _displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(""+AccountManager),user.getLanguage())%>"
	  >
	</td>
	<td align=right><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	<td class=field>
	  <INPUT    class=InputStyle maxLength=50 size=30 name="CustomerName" value="<%=CustomerName%>">
	</td>
  </TR><tr style="height:2px" ><td class=Line colspan=9></td></tr>
</tbody>
</table>
<table class=ListStyle cellspacing=1>
<colgroup>

  <tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1279,user.getLanguage())%></td>
  </tr>
<TR class=Line><TD colSpan=4></TD></TR>
<%
boolean islight=false;
int totalline=1;
String CustomerID="";
boolean isshowCustomerName=true;
if(RecordSet.last()){
	do{
		if(RecordSet.getString("relateditemid").equals(CustomerID)){
			isshowCustomerName=false;
		}else{
			isshowCustomerName=true;	
			islight=!islight;
			CustomerID=RecordSet.getString("relateditemid");			
		}
%>
<tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
	<td><%if(isshowCustomerName){%><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("relateditemid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("relateditemid")),user.getLanguage())%></a><%}%></td>
	<td><%if(isshowCustomerName){%><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></a><%}%></td>
	<td><%if(isshowCustomerName){%><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSet.getString("department")%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("department")),user.getLanguage())%></a><%}%></td>
	<td>
	<table>
	<%if(RecordSet.getInt("sharetype")==1)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
        </TR>
	<%}else if(RecordSet.getInt("sharetype")==2)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
        </TR>
	<%}else if(RecordSet.getInt("sharetype")==3)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(RolesComInfo.getRolesname(RecordSet.getString("roleid")),user.getLanguage())%>/<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
        </TR>
	<%}else if(RecordSet.getInt("sharetype")==4)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
        </TR>
	<%}%>
	
	</table>
	</td>
</tr>

<%
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
}while(RecordSet.previous());
}
RecordSet.executeSql("drop table "+temptable);
%>
</table>
<table align=right>
<tr style="display:none">
   <td>&nbsp;</td>
   <td>
	   <%if(pagenum>1){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%> 
			<button type=submit class=btn accessKey=P id=prepage  onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
	   <%}%>
   </td>
   <td>
	   <%if(hasNextPage){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%> 
			<button type=submit class=btn accessKey=N id=nextpage  onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
	   <%}%>
   </td>
   <td>&nbsp;</td>
</tr>
</table>

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
</form>
<script type="text/javascript">
  function doSearch(){
    jQuery("#weaver").submit();
  }
</script>
<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&weaver.CustomerDepartment.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	weaver.CustomerDepartment.value=id(0)
	else
	departmentspan.innerHtml = ""
	weaver.CustomerDepartment.value="0"
	end if
	end if
end sub

sub onShowAccountManager()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	AccountManagerspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.AccountManager.value=id(0)
	else 
	AccountManagerspan.innerHtml = ""
	weaver.AccountManager.value="0"
	end if
	end if
end sub
</script>
</body>
</html>