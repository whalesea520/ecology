<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />	
</HEAD>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String isBill = Util.null2String(request.getParameter("isBill"));
String formID = Util.null2String(request.getParameter("formID"));
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1442,user.getLanguage())+
"-"+SystemEnv.getHtmlLabelName(119,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel = 0;
if(detachable == 1){
    RecordSet.executeProc("Workflow_Report_SelectByID",id+"");
    RecordSet.next();
    String subcompanyid= Util.null2String(RecordSet.getString("subcompanyid"));
	operatelevel = checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowReportManage:All", Util.getIntValue(subcompanyid,0));
}else{
    operatelevel = 2;
}
if(operatelevel < 0){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel > 0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:newDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:removeRows(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",ReportManage.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep;*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=weaver action="ReportShareOperation.jsp" method=post onsubmit='return check_form(this,"")'>
<input type="hidden" name="method" value="add">
<input type="hidden" name="reportid" value="<%=id%>">
<input type="hidden" name="isBill" value="<%=isBill%>">
<input type="hidden" name="formID" value="<%=formID%>">
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_REPORT_REPORTSHARE %>"/>
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<%if(operatelevel > 0){ %>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" class="e8_btn_top" onclick="newDialog()"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="removeRows()"/>
					<%} %>
					<!--<input type="text" class="searchInput" name="flowTitle"/>-->
					&nbsp;&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>						
	  <TABLE class="viewform" style="display:none!important;">
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR>
          <TD class=field>
			  <select class=inputstyle  name=sharetype onchange="onChangeSharetype()" >
				  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				  <!-- option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/option -->
				  <option value="3" selected="selected"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
				  <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
				  <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
 			  </SELECT>
		  </TD>
          <TD class=field >
			
			 <INPUT type="hidden" class="wuiBrowser" name="relatedshareid" id="relatedshareid" value="" _url="" _required="yes">
			 
			<span id=showrolelevel name=showrolelevel style="visibility:hidden">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
			<select class=inputstyle  name=rolelevel  >
			  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
			</SELECT>
			</span>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<span id=showseclevel name=showseclevel>
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
			<INPUT type=text class="InputStyle" name=seclevel size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' >
			</span>
			<SPAN id=seclevelimage></SPAN>
		  </TD>		
		</TR>
		<TR style="height:1px;"><Td colSpan=2 class="Line1"></Td></TR>
		<TR>
          <TD class=field>
			<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<select class=inputstyle  name=sharelevel onchange="onChangeShareLevel(event)">
			  <option value="4"><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>
			  <option value="0" selected><%=SystemEnv.getHtmlLabelName(18511,user.getLanguage())%></option>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(18512,user.getLanguage())%></option>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
              <!--add by xhheng @20050126 for TD 1614-->
              <option value="3"><%=SystemEnv.getHtmlLabelName(18513,user.getLanguage())%></option>
              <option value="9"><%=SystemEnv.getHtmlLabelName(17006,user.getLanguage())%></option>
			</SELECT>
            &nbsp;&nbsp;
           <INPUT type=hidden name="departmentids" id="departmentids" value="" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" _required="yes" _initEnd="onChangeShareLevel">
             </TD>
		</TR>
		<TR style="height:1px;"><Td colSpan=2 class="Line1"></Td></TR>
		</TBODY>
	  </TABLE>
	
<%

String sqlWhere =" where reportid="+id;

String orderby =" reportid ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,reportid,sharetype,seclevel,seclevel2,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,mutidepartmentid,allowlook";
String fromSql  = " WorkflowReportShare ";
//System.out.println(backfields+fromSql+sqlWhere+orderby);
String para1 = "column:userid+column:subcompanyid+column:departmentid+column:roleid+column:rolelevel+"+user.getLanguage()+"+column:seclevel";
tableString =   " <table instanceid=\"workflowTypeListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REPORT_REPORTSHARE,user.getUID())+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(33234,user.getLanguage())+"\" column=\"sharetype\" orderkey=\"sharetype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.report.ReportShare.getShareTypeName\"/>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\" column=\"sharetype\" orderkey=\"sharetype\" otherpara=\""+para1+"\" transmethod=\"weaver.workflow.report.ReportShare.getShareObj\"/>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\"  orderkey=\"seclevel\" otherpara=\"column:seclevel2+column:sharetype\" transmethod=\"weaver.workflow.report.ReportShare.getSeclevel\"/>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(3005,user.getLanguage())+"\" column=\"sharelevel\" orderkey=\"sharelevel\" otherpara=\"column:mutidepartmentid+"+user.getLanguage()+"\" transmethod=\"weaver.workflow.report.ReportShare.getShareLevel\"/>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(21225,user.getLanguage())+"\" column=\"allowlook\" orderkey=\"allowlook\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.report.ReportShare.getAllowLook\"/>"+
                "       </head>";
                if(operatelevel > 0){
                    tableString += "<operates><operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\" index=\"1\"/></operates>";
                }
                tableString += " </table>";
%>

<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>

</td>
		</tr>
		</TABLE>
		</form>  
<script language=javascript>
function doSave(obj) {
thisvalue=document.weaver.sharetype.value;
levelsvalue=document.weaver.sharelevel.value;
var checkstr="";
if (thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4){
        if(levelsvalue==9){
           checkstr="relatedshareid,departmentids";
        }else{
            checkstr="relatedshareid";
        }
}

if(check_form(document.weaver,checkstr)){
document.weaver.submit();
obj.disabled=true;
}
}
</script>

<script language=javascript>
$(function(){

	onChangeSharetype();
});
function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
		document.weaver.relatedshareid.value="";
		$("#relatedshareidSpan").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\">");
		document.all("showseclevel").style.display='';
	if(thisvalue==1){
		document.all("showseclevel").style.display='none';
		$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
		//TD33012 当安全级别为空时，选择人力资源，赋予安全级别默认值10，否则无法提交保存

		seclevelimage.innerHTML = ""
		if(document.all("seclevel").value==""){
			document.all("seclevel").value=10;
		}
		//End TD33012
	}
	if(thisvalue==2){
		document.weaver.seclevel.value=10;
		$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
		
	}
	else{
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==3){
		document.weaver.seclevel.value=10;
		$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
	}
	else{
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==4){
		document.all("showrolelevel").style.visibility='visible';
		$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
		document.weaver.seclevel.value=10;
	}
	else{
		document.all("showrolelevel").style.visibility='hidden';
		document.weaver.seclevel.value=10;
  	}
	if(thisvalue==5){
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=10;
		$("#relatedshareidBtn").hide();
		$("#relatedshareidSpan").hide();
	}else{
		$("#relatedshareidBtn").show();
		$("#relatedshareidSpan").show();
	}
	if(thisvalue<0){
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=0;
	}
}

function onChangeShareLevel(e){
	thisvalue=document.weaver.sharelevel.value;
	document.weaver.departmentids.value="";
	if(thisvalue==9){
        $("#departmentids").prev().show();
        $("#departmentids").next().show();
    }
	else{
		$("#departmentids").next().hide();
        $("#departmentids").prev().hide();
    }
}
</script>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'PrjName,PrjType,WorkType,hrmids02,SecuLevel,PrjManager,PrjDept'))
		weaver.submit();
}
</script>
</BODY>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
var diag_vote;
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});
function newDialog(){
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 500;
	diag_vote.Height = 350;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelNames("611,81597",user.getLanguage())%>";   81597
	diag_vote.URL = "/workflow/report/ReportShareAdd.jsp?dialog=1&isBill=<%=isBill%>&formID=<%=formID%>&id=<%=id%>";
	diag_vote.isIframe=false;
	diag_vote.show();
}

function closeDialog(){
	diag_vote.close();
}

function onDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function(){
						window.location="/workflow/report/ReportShareOperation.jsp?method=delete&isBill=<%=isBill%>&formID=<%=formID%>&reportid=<%=id%>&id="+id+"";
				}, function () {}, 320, 90,true);
}	

function spanOver(obj){
    $(obj).addClass("rightMenuHover");
}

function spanOut(obj){
    $(obj).removeClass("rightMenuHover");
}
		
function mnToggleleft(){
	var f = window.parent.document.getElementById("oTd1").style.display;

	if (f != null) {
		if (f==''){
			window.parent.document.getElementById("oTd1").style.display='none'; 			
		}else{ 
			window.parent.document.getElementById("oTd1").style.display=''; 
		}
	}
}
function onBtnSearchClick(obj){

}
function removeRows(){
	var ids = "";
	if(!ids){
		ids = _xtable_CheckedCheckboxId();
	}
	if(ids.match(/,$/)){
		ids = ids.substring(0,ids.length-1);
	}
	if(ids=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function(){
						window.location="/workflow/report/ReportShareOperation.jsp?method=deleteAll&isBill=<%=isBill%>&formID=<%=formID%>&reportid=<%=id%>&id="+ids+"";
				}, function () {}, 320, 90,true);	
}
</script>
</HTML>
