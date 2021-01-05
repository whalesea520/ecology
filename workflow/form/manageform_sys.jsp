<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="FormInfo" class="weaver.workflow.form.FormManager" scope="page" />
<jsp:useBean id="FormMainManager" class="weaver.workflow.form.FormMainManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%FormMainManager.resetParameter();%>
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    if(!ajax.equals("1")){
%>
<!-- add by xhheng @20050204 for TD 1538-->
<script language=javascript src="/js/weaver_wev8.js"></script>
<%
    }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage());
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";
if(!ajax.equals("1")){
%>
<script language="javascript">
function formCheckAll(checked) {
	len = document.fromaddtab.elements.length;
	var i=0;
	for( i=0; i<len; i++) {
		//TD12654
		if (document.fromaddtab.elements[i].name=='delete_form_id'
			||document.fromaddtab.elements[i].name=='delete_newform_id') {
			if(!document.fromaddtab.elements[i].disabled){
			    document.fromaddtab.elements[i].checked=(checked==true?true:false);
			}
		} 
	} 
}


function unselectall()
{
    if(document.fromaddtab.checkall0.checked){
	document.fromaddtab.checkall0.checked =0;
    }
}
function confirmdel() {
	len=document.fromaddtab.elements.length;
	var i=0;
	for(i=0;i<len;i++){
		if (document.fromaddtab.elements[i].name=='delete_form_id'||document.fromaddtab.elements[i].name=='delete_newform_id')
			if(document.fromaddtab.elements[i].checked)
				break;
	}
	if(i==len){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
		return false;
	}
	return Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?") ;
}

</script>
<%}%>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	String formid=""+Util.getIntValue(request.getParameter("formid"),0);
	String formname=Util.null2String(request.getParameter("formname"));
	String formdes=Util.null2String(request.getParameter("formdes"));

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int operatelevel = 0;
	int subCompanyId = -1;
	if(detachable==1){  
	    subCompanyId=Util.getIntValue(Util.null2String(session.getAttribute("managefield_subCompanyId")),-1);
        if(subCompanyId > 0){
	        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FormManage:All",subCompanyId);
        }else{
            int tempsubcompanyid2[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(), "FormManage:All",2);
    		if(null!=tempsubcompanyid2 && tempsubcompanyid2.length > 0){
    		    operatelevel = 2;
    		}else{
    		    tempsubcompanyid2 = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(), "FormManage:All",1);
    		    if(null!=tempsubcompanyid2 && tempsubcompanyid2.length > 0){
    		        operatelevel = 1;    
    		    }
    		}
        }
    }else{
        if(HrmUserVarify.checkUserRight("FormManage:All", user))
            operatelevel=2;
    }   
    
    String formnameForSearch = "";
    String formtypeForSearch = "";
    String formdecForSearch = "";
    //formnameForSearch = Util.null2String(request.getParameter("formnameForSearch"));
    formnameForSearch= Util.toScreenToEdit(request.getParameter("formnameForSearch"),user.getLanguage());
    formdecForSearch= Util.toScreenToEdit(request.getParameter("formdecForSearch"),user.getLanguage());
    formtypeForSearch = Util.null2String(request.getParameter("formtypeForSearch"));

%>
<form name="fromaddtab" method="post">
<input type=hidden name=formid value="<%= formid %>">
<input type=hidden name=formname value="<%= formname %>">
<input type=hidden name=formdes value="<%= formdes %>">
<input type=hidden name="ajax" value="<%=ajax%>">
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_FORM_MANAGEFORM_SYS %>"/>

<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">

			<input type="text" class="searchInput" name="flowTitle" value="<%=Util.toScreenToEdit(formnameForSearch.replace("&","&amp;"),user.getLanguage())%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>


<%
		int flowAll=100;
		int flowNew=101;
		int flowResponse=102;
		int flowOut=103;
%>
			
		<div id="tabDiv" >
			<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span onclick="location='manageform.jsp'"><%=SystemEnv.getHtmlLabelName(699,user.getLanguage())%></span>
			<span style="margin-left:-4px;" onmouseover="spanOver(this)" onmouseout="spanOut(this)" onclick="location='manageform_test.jsp'"><%=SystemEnv.getHtmlLabelName(125026, user.getLanguage())%></span>
			<span style="margin-left:-8px;" class="selectedTitle"><%=SystemEnv.getHtmlLabelName(125027, user.getLanguage())%></span>
			</span>
		</div>
		
		<!-- bpf start 2013-10-29 -->
		<div class="advancedSearchDiv" id="advancedSearchDiv">
        <%if(!ajax.equals("1")){%>
        <wea:layout type="fourCol">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage()) %>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></wea:item>
			    <wea:item><input type=text name=formnameForSearch class=Inputstyle value='<%=Util.toScreenToEdit(formnameForSearch.replace("&","&amp;"),user.getLanguage())%>'></wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></wea:item>
		    	<wea:item><input type=text name=formdecForSearch class=Inputstyle value='<%=Util.toScreenToEdit(formdecForSearch.replace("&","&amp;"),user.getLanguage())%>'></wea:item>
		    </wea:group>
		    <wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="doSearchForm();"/>
					<span class="e8_sep_line">|</span>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<span class="e8_sep_line">|</span>
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		    	</wea:item>
		    </wea:group>
		</wea:layout>
        <%}%>
</div>		
<%
RecordSet.executeSql("SELECT DISTINCT formid FROM workflow_base where isbill='0' ");
StringBuffer sb = new StringBuffer();
String allRef = "";
while(RecordSet.next()){
    allRef += "," + RecordSet.getString(1);
}
if(!"".equals(allRef)) allRef +=",";

String sqlWhere = " where isoldornew = 1 and id >0 ";

if(detachable==1){  
	if (subCompanyId > 0) {
	    sqlWhere += " and subcompanyid = " + subCompanyId + " ";
	}
    if(user.getUID() != 1){
        String hasRightSub=subCompanyComInfo.getRightSubCompany(user.getUID(),"FormManage:All",-1);
        if(StringUtils.isNotBlank(hasRightSub)){
	        sqlWhere += " and  subcompanyid in (" + hasRightSub + ") ";
        }else{
            sqlWhere += " and 1 = 2";
        }
    }
}
if(!"".equals(formnameForSearch)){
	sqlWhere+=" and formname like '%"+formnameForSearch+"%' ";
}

if(!"".equals(formdecForSearch)){
	sqlWhere+=" and formdesc like '%"+formdecForSearch+"%' ";
}
 
String orderby =" formname,isoldornew,id ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,formname,formdesc,subcompanyid,isoldornew ";
String fromSql  = " view_workflowForm_selectAll "; //这个是视图不是表
if("".equals(allRef))	allRef="-1";
String para1 = "column:id+column:isoldornew+"+allRef +"+column:subcompanyid+"+user.getUID()+"+"+detachable;
if("".equals(ajax))ajax="-1";//如果为空分页组件解析会有错误
String para2 = "column:id+column:isoldornew+"+ajax;
String para3 = "column:isoldornew+"+user.getLanguage();
String para4 = operatelevel+"+0+"+user.getLanguage();
String para5 = operatelevel+"+1+"+user.getLanguage();
tableString =   " <table instanceid=\"workflowFormListTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_FORM_MANAGEFORM_SYS,user.getUID())+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\""+para1+"\" showmethod=\"weaver.workflow.form.FormMainManager.getWfFormCheck\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"false\" />"+
                "       <head>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15451,user.getLanguage())+"\" column=\"formname\" otherpara=\""+para2+"\" orderkey=\"formname\" transmethod=\"weaver.workflow.form.FormMainManager.getWFFormNameLink\"/>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(18411,user.getLanguage())+"\" column=\"id\" otherpara=\""+para3+"\" transmethod=\"weaver.workflow.form.FormMainManager.getFormType\"/>"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16450,user.getLanguage())+"\" column=\"id\" otherpara=\""+para4+"\"  transmethod=\"weaver.workflow.form.FormMainManager.getshowModuleOrPrintLink\"/>"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage())+"\" column=\"id\"  otherpara=\""+para5+"\"  transmethod=\"weaver.workflow.form.FormMainManager.getshowModuleOrPrintLink\"/>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15452,user.getLanguage())+"\" column=\"formdesc\" orderkey=\"formdesc\"/>";
                if(detachable==1){
                    tableString += "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />";
                    }
                tableString+="       </head>"+ 
                "		<operates>"+                
                "		<popedom column=\"id\"  otherpara=\""+para1+"\" transmethod=\"weaver.workflow.form.FormMainManager.getEditAndDel\"></popedom> "+
                "		<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		</operates>"+                               
                " </table>";
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
<%
if(!ajax.equals("1")){
%>
   <script language="javascript">
function submitData()
{
	var oldformids = "";
	var newformids = "";
	$("input[name='chkInTableTag']").each(function(){
	if($(this).attr("checked"))		
		if($(this).attr("checkboxId")>0){
			oldformids = oldformids +$(this).attr("checkboxId")+",";
		}else{
			newformids = newformids +$(this).attr("checkboxId")+",";
		}	
		
	});
	if(oldformids=="" && newformids=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
				fromaddtab.action = "/workflow/form/delforms.jsp?oldformids="+oldformids+"&newformids="+newformids;
				fromaddtab.submit();
				}, function () {}, 320, 90,true);	
}

function onDel(id){
	$("#_xTable_"+id).attr("checked",true);
	submitData();
}

function submitClear()
{
	btnclear_onclick();
}
function openFullWindowHaveBar(url){
	if (url.indexOf("/workflow/mode/index.jsp") != -1) {
		if (<%=isIE %> != true) {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129065, user.getLanguage())%>");
			return false;
		}
	}   
  var redirectUrl = url ;
  var width = screen.availWidth-10 ;
  var height = screen.availHeight-50 ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
   var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes,toolbar=no,location=no," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function doSearchForm(){
    fromaddtab.action = "/workflow/form/manageform_sys.jsp";
    fromaddtab.submit();
}
</script>
<%
    }
%>
</body>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">

jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});

function getnewDialogLink(url){
  diag_vote = new window.top.Dialog();
  diag_vote.currentWindow = window;	
  diag_vote.Width = 1020;
  diag_vote.Height = 580;
  diag_vote.Modal = true;
  diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82022, user.getLanguage())%>";
  diag_vote.URL = url+"&dialog=1"
  diag_vote.isIframe=false;
  diag_vote.show();
}

function newDialog(){
	if("<%=ajax%>"!=1){
	      diag_vote = new window.top.Dialog();
	      diag_vote.currentWindow = window;	
	      diag_vote.Width = 1020;
		  diag_vote.Height = 380;
		  diag_vote.Modal = true;
		  diag_vote.Title = "SystemEnv.getHtmlLabelName(82021, user.getLanguage())";
		  diag_vote.URL = "/workflow/form/addDefineForm.jsp?dialog=1";
		  diag_vote.isIframe=false;
		  diag_vote.show();
		 //window.location="addDefineForm.jsp";	
	}else{
		formaddtab();
	}
}

function onEdit(id){
   //var link = $("#"+id).parent().parent().children().eq(1).children().eq(0).attr("href");
   //if(!link){
   //    link = $("#_xTable_"+id).parent().parent().parent().children().eq(1).children().eq(0).attr("href");
   //}
   var link = "/workflow/form/addDefineSysForm.jsp?formid="+id;
   //window.location=link;	
    diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;	
	diag_vote.Width = 1020;
	diag_vote.Height = 580;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82022,user.getLanguage())%>";
	diag_vote.URL = link+"&dialog=1";
	diag_vote.isIframe=false;
	diag_vote.show();		
}	

function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']",parent.document).val();
	//$("input[name='formnameForSearch']").val(typename);
	window.location="/workflow/form/manageform_sys.jsp?formnameForSearch="+typename;
}

function spanOver(obj){
    $(obj).addClass("rightMenuHover");
}

function spanOut(obj){
    $(obj).removeClass("rightMenuHover");
}
</script>
</html>
