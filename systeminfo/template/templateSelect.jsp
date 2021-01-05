
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18167,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean hasDefault = false;
boolean isManager = false;
String sql = "";
int userId=0, subCompanyId=0, userTemplateId=0;
userId = user.getUID();

sql = "SELECT id FROM HrmResourceManager WHERE id="+userId;
rs.executeSql(sql);
if(rs.next())	isManager=true;

if(request.getParameter("subCompanyId")!=null){
	subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
}else{
	subCompanyId = user.getUserSubCompany1();
}

sql = "SELECT templateId FROM SystemTemplateUser WHERE userid="+userId;
rs.executeSql(sql);
if(rs.next()){
	userTemplateId = rs.getInt("templateId");
}

if(isManager){
	sql= "SELECT * FROM SystemTemplate WHERE (companyId=0 OR companyId="+subCompanyId+")";
}else{
	sql = "SELECT templateId FROM SystemTemplateSubComp WHERE subcompanyid="+subCompanyId+"";
	rs.executeSql(sql);
	if(rs.next()){
		if(rs.getInt("templateId")==-1){
			sql= "SELECT * FROM SystemTemplate WHERE (companyId=0 OR companyId="+subCompanyId+") AND isOpen='1'";	
		}else{
			sql= "SELECT * FROM SystemTemplate WHERE id="+rs.getInt("templateId")+"";
			hasDefault = true;
		}
	}
}
rs.executeSql(sql);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;	
		
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="frmMain" method="post" action="templateOperation.jsp">
<input type="hidden" name="operationType" value="selectTemplate"/>
<input type="hidden" name="subCompanyId" value="<%=subCompanyId%>"/>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class="Shadow">
<tr>
<td valign="top">
		
<!--=================================-->
<TABLE class=ListStyle cellspacing=1>
<TR class=Header>
	<th width="40">ID</th>
	<TH><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></TH>
	<th width="150"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></th>
	<th width="60"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></th>
</TR>
<TR class=Line>
	<TD colSpan=4></TD>
</TR>
<%while(rs.next()){
	 String extendtempletUrl="";
	 int extendtempletid=Util.getIntValue(rs.getString("extendtempletid"),0);
	 if(extendtempletid>0){
		 rsExtend.executeSql("select extendurl from extendHomepage where id="+extendtempletid);
		 if(rsExtend.next()) extendtempletUrl=Util.null2String(rsExtend.getString(1));			
	 }
%>
<TR>
	<TD><%=rs.getInt("id")%></TD>
	<td><%=rs.getString("templateName")%></td>
	<td><a href="javascript:void(0);" onclick="preview(<%=rs.getInt("id")%>,'<%=extendtempletUrl%>','<%=extendtempletid%>')"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></a></td>
	<td>
	<%if(hasDefault){%>
		<input type="radio" name="templateId" value="<%=rs.getInt("id")%>" <%if(rs.getInt("id")==userTemplateId){out.println("checked");}%>>
		<span style='color:red;font-weight:bold'><%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())%></span>
	<%}else{%>
		<input type="radio" name="templateId" value="<%=rs.getInt("id")%>" <%if(rs.getInt("id")==userTemplateId){out.println("checked");}%>>
	<%}%>
	</td>
</TR>
<%}%>
</TABLE>
<!--=================================-->

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

</form>
</body>
</html>

<script language="javascript">
function checkSubmit(){
	document.frmMain.submit();
	window.frames["rightMenuIframe"].event.srcElement.disabled = true;
}
function preview(id){
	window.open('templatePreview.jsp?id='+id,'','');
}

function preview(id,url,extendtempletid){	
	if(url!=""){
		//alert(url+"/index.jsp?from=preview&userSubcompanyId=<%=subCompanyId%>&templateId="+id+"&extendtempletid="+extendtempletid)
		openFullWindowForXtable(url+"/index.jsp?from=preview&userSubcompanyId=<%=subCompanyId%>&templateId="+id+"&extendtempletid="+extendtempletid);
	} else  {
		openFullWindowForXtable('templatePreview.jsp?id='+id);
	}
	
}
</script>