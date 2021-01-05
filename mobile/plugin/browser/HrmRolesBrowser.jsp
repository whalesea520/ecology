<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%> 
<%@page import="weaver.file.FileUpload"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="MobileInit.jsp"%>
<HTML>
<HEAD>
<base target="_self">
<link href="css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</HEAD>
<%
String rolesname = Util.null2String(fu.getParameter("rolesname"));
String rolesmark = Util.null2String(fu.getParameter("rolesmark"));
String sqlwhere = Util.null2String(fu.getParameter("sqlwhere"));
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!rolesname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where rolesname like '%" + Util.fromScreen2(rolesname,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and rolesname like '%" + Util.fromScreen2(rolesname,user.getLanguage()) +"%' ";
}
if(!rolesmark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where rolesmark like '%" + Util.fromScreen2(rolesmark,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and rolesmark like '%" + Util.fromScreen2(rolesmark,user.getLanguage()) +"%' ";
}
String sqlstr = "select * from HrmRoles " + sqlwhere+" order by rolesmark" ;
%>
<BODY style="overflow-y: hidden;">
<FORM NAME=SearchForm id="SearchForm"  STYLE="margin-bottom:0"  method=post>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow style="width: 100%">
<tr>
<td valign="top">
<table width=100% class=ViewForm>
    <TR class=Spacing style="height: 1px;"> 
      <TD class=line1 colspan=4></TD>
    </TR>
    <TR> 
      <TD width=15%><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TD>
      <TD width=35% class=field> 
        <input class=inputstyle name=rolesmark id="rolesmark" value="<%=rolesmark%>">
      </TD>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
      <TD width=35% class=field> 
        <input class=inputstyle name=rolesname id="rolesname" value="<%=rolesname%>">
      </TD>
    </TR>
    <TR class=spacing style="height: 1px;"> 
      <TD class=line1 colspan=4></TD>
    </TR>
  </table>
  
<div style="height: 450px;overflow: auto;width: 100%">  
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TH>      
	  <TH width=40%><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TH>      
	  <TH width=65%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
      </tr><TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String rolesmarks = Util.toScreen(RecordSet.getString("rolesmark"),user.getLanguage());
	String rolesnames = Util.toScreen(RecordSet.getString("rolesname"),user.getLanguage());
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<TD style="display:none"><A HREF=#><%=ids%></A></TD>
	<TD><%=rolesmarks%></TD>
	<TD><%=rolesnames%></TD>
</TR>
<%}
%>

</TABLE>
</div>
<div align="center" style="background:rgb(246, 246, 246);vertical-align: middle;padding-top: 8px;border-top:#dadee5 solid 1px;">
    <BUTTON class=btnSearch onclick="doSearch();" accessKey=S  id="searchBtn"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>&nbsp;&nbsp;
	<BUTTON class=btn accessKey=R  id="resetBtn" onclick="resetForm();"><U>R</U>-重置</BUTTON>&nbsp;&nbsp;
	<BUTTON class=btn accessKey=2  id="clearBtn" onclick="doClear();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>&nbsp;&nbsp;
    <BUTTON class=btnReset accessKey=T  id="cancelBtn" onclick="window.parent.close();";><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
</div>
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

</FORM>
</BODY>
</HTML>

<script	language="javascript">
function resetForm(){
	jQuery("#rolesmark").val("");
	jQuery("#rolesname").val("");
}
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
}

function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;
	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var curTr=jQuery(target).parents("tr")[0];
		window.parent.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
		window.parent.parent.close();
	}
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
});

function doSearch(){
/*
    var  searchStr="&rolesmark="+jQuery("#rolesmark").val()+"&rolesname="+jQuery("#rolesname").val();
    searchStr = decodeURIComponent(searchStr,true);
    jQuery("#SearchForm").attr("action","/manager/getPage.do?pluginCode=1&page=HrmRolesBrowser"+searchStr);
*/    
    document.SearchForm.submit();
}

function doClear(){
   window.parent.parent.returnValue = {id:"",name:""};
   window.parent.parent.close();
}
</script>
