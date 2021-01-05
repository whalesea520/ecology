<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%

if (!HrmUserVarify.checkUserRight("WORKFLOWPUBLICCHOICE:VIEW", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

    String id=""+Util.getIntValue(request.getParameter("id"),0);
	String formname=Util.null2String(request.getParameter("formname"));
	String formdes=Util.null2String(request.getParameter("formdes"));
	
	String formnameForSearch = "";
    String formtypeForSearch = "";
    String formdecForSearch = "";
    //formnameForSearch = Util.null2String(request.getParameter("formnameForSearch"));
    formnameForSearch= Util.toScreenToEdit(request.getParameter("formnameForSearch"),user.getLanguage());
    formdecForSearch= Util.toScreenToEdit(request.getParameter("formdecForSearch"),user.getLanguage());
    formtypeForSearch = Util.null2String(request.getParameter("formtypeForSearch"));
    
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124876,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body style="">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClick(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<form name="frmSearch" method="post" id="frmSearch" action="selectItemReferences.jsp">
    <input name="id" id="id" type="hidden" value="<%=id %>"/>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">				
				
				<input type="text" class="searchInput" name="flowTitle" value="<%=Util.toScreenToEdit(formnameForSearch.replace("&","&amp;"),user.getLanguage()) %>" />
				&nbsp;&nbsp;&nbsp;
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>		
	<!-- bpf start 2013-10-29 -->
	<div class="advancedSearchDiv" id="advancedSearchDiv">
		<wea:layout type="fourCol">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></wea:item>
			    <wea:item><input type=text name=formnameForSearch id="formnameForSearch" class=Inputstyle value='<%=Util.toScreenToEdit(formnameForSearch.replace("&","&amp;"),user.getLanguage())%>'></wea:item>
			    
			    <wea:item><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></wea:item>
			    <wea:item><input type=text name=formdecForSearch id="formdecForSearch" class=Inputstyle value='<%=Util.toScreenToEdit(formdecForSearch.replace("&","&amp;"),user.getLanguage())%>'></wea:item>
		    	
		    	<wea:item><%=SystemEnv.getHtmlLabelName(18411,user.getLanguage())%></wea:item>
		    	<wea:item>
			    	<select id="formtypeForSearch" name="formtypeForSearch">
	                    <option value="" ></option>
	                    <option value=0 <%if(formtypeForSearch.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
	                    <option value=1 <%if(formtypeForSearch.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
	                </select>
		    	</wea:item>
		    </wea:group>
		    <wea:group context="">
		    	<wea:item type="toolbar">
		    		<input class="e8_btn_submit" type="submit" name="submit2" value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/>
		    		<input class="e8_btn_cancel" type="button"  name="reset"  onclick="resetCondtion()" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/>
		    		<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/>
		    	</wea:item>
		    </wea:group>
		</wea:layout>
	</div>
</form>		
<%
int pageSize = 15;
String sqlWhere = " where 1=1 ";

if(!"".equals(formnameForSearch)){
	if("".equals(sqlWhere)){
		sqlWhere = " where formname like '%"+formnameForSearch+"%' ";
	}else{
		sqlWhere+=" and formname like '%"+formnameForSearch+"%' ";
	}
}

if(!"".equals(formdecForSearch)){
	if("".equals(sqlWhere)){
		sqlWhere = " where formdesc like '%"+formdecForSearch+"%' ";
	}else{
		sqlWhere+=" and formdesc like '%"+formdecForSearch+"%' ";
	}
}

if(!"".equals(formtypeForSearch)){
	if("0".equals(formtypeForSearch)){
		if("".equals(sqlWhere)){
			sqlWhere = " where id <0 ";
		}else{
			sqlWhere+=" and id <0 ";
		}
	}else if("1".equals(formtypeForSearch)){
		if("".equals(sqlWhere)){
			sqlWhere = " where isoldornew = 1 and id >0 ";
		}else{
			sqlWhere+=" and isoldornew = 1 and id >0 ";
		}
	}
}else{//屏蔽掉老表单
	if("".equals(sqlWhere)){
		sqlWhere = " where isoldornew = 1 ";
	}else{
		sqlWhere+=" and isoldornew = 1 ";
	}
}

/*
String formids = "0";
RecordSet.executeSql("SELECT formids FROM mode_selectitempage s WHERE s.id ="+id);
if(RecordSet.next()){
	formids = Util.null2String(RecordSet.getString(1));
	
	ArrayList<String> list = Util.TokenizerString(formids,",");
	formids = "";
	for(int i=0;i<list.size();i++){
		String _id = list.get(i)+"";
		if(_id.equals("")){
			continue;
		}
		if(formids.equals("")){
			formids = _id;
		}else{
			formids += ","+_id;
		}
	}
}
 
 //sqlWhere += " and EXISTS (SELECT 1 FROM mode_selectitempage s WHERE s.id ="+id+" AND f.id IN (s.formids)) ";
 sqlWhere += " and f.id in ("+formids+") ";   
 
*/ 

sqlWhere += " and exists (SELECT billid FROM workflow_billfield b WHERE f.id=b.billid and b.selectItemType = '1' and b.pubchoiceId = "+id+" )";
                
 
String orderby =" formname,isoldornew,id ";
String tableString = "";
String backfields = " id,formname,formdesc,subcompanyid,isoldornew ";
String fromSql  = " view_workflowForm_selectAll f "; //这个是视图不是表


//System.out.println("select "+backfields+" from "+fromSql+" "+sqlWhere+" order by "+orderby);

String para2 = "column:id+column:isoldornew+0";
String para3 = "column:isoldornew+"+user.getLanguage();
tableString =   " <table instanceid=\"workflowFormListTable\" tabletype=\"none\" pagesize=\""+pageSize+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"false\" />"+
                "       <head>"+
                "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(15451,user.getLanguage())+"\" column=\"formname\" otherpara=\""+para2+"\" orderkey=\"formname\" transmethod=\"weaver.workflow.form.FormMainManager.getWFFormNameLink\"/>"+
                "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(15452,user.getLanguage())+"\" column=\"formdesc\" orderkey=\"formdesc\"/>"+
                "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(18411,user.getLanguage())+"\" column=\"id\" otherpara=\""+para3+"\" transmethod=\"weaver.workflow.form.FormMainManager.getFormType\"/>"+
                "       </head>"+ 
                " </table>";
                
                //System.out.println("---tableString---"+tableString);
%>

<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />	
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
</wea:layout>
</div>

</BODY>

<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}

	function btn_cancle(){
		dialog.closeByHand();
	}
</script>

<script type="text/javascript">
var diag_vote;
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});

function onBtnSearchClick(){
	var flowTitle=$("input[name='flowTitle']",parent.document).val();
	$("input[name='formnameForSearch']").val(flowTitle);
	$("#frmSearch").submit();
}

function resetConditiontmp(){

	jQuery("#formtypeForSearch").selectbox("reset");
	jQuery("#formtypeForSearch").val("");
	
	resetCondtion();
}


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




</script>
</HTML>
