
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class= "weaver.conn.RecordSet" scope="page" />
 
<%
    String wtid = Util.null2String(request.getParameter("wtid")); 	
%>
<HTML>
<HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
    <BODY>

    <%
    String imagefilename = "/images/hdReport_wev8.gif";

	
    String titlename = "" ;
    String needfav ="1";
    String needhelp ="";
    %> 
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %> 
    <%

		RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAdd(this),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:delPrm(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(21931,user.getLanguage())+",javascript:useSetto(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
    %>
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="160px">
			</td>
			<td class="rightSearchSpan" style="text-align: right; width: 500px !important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doAdd(this);">						
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="delPrm('')">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(21931,user.getLanguage()) %>" class="e8_btn_top middle" onclick="useSetto()"/>
				&nbsp;&nbsp;&nbsp;
				<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<form  name="frmAdd" method="post" action="ShareOperation.jsp">
	<input type="hidden"  name="method">
    <input type="hidden"  name="wtid" value="<%=wtid%>">
                                    
        <%
        int perpage =10;
		//设置好搜索条件
		String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\" >"
		  + "<checkboxpopedom popedompara=\"column:id\" showmethod=\"weaver.worktask.worktask.WTRequestUtil.getCheckbox\"/>"
		  + "<sql backfields=\"id,taskid,seclevel,departmentid,roleid,rolelevel,sharetype,userid,subcompanyid \" sqlform=\" from worktaskcreateshare \" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\"taskid="+wtid+"\" sqlisdistinct=\"false\" />"+
			"       <head>"+
			"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"sharetype\" otherpara=\""+user.getLanguage()+"\"  orderkey=\"sharetype\" transmethod=\"weaver.worktask.worktask.WTRequestUtil.getCreateRightType\" />"+
			"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(106, user.getLanguage())+"\" column=\"sharetype\" otherpara=\"column:subcompanyid+column:departmentid+column:roleid+column:userid+column:rolelevel+"+user.getLanguage()+"\" transmethod=\"weaver.worktask.worktask.WTRequestUtil.getCreateShareTypeInfo\" />"+
			"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" orderkey=\"seclevel\"  />"+
			"       </head>"
	 	+"</table>";			
	 	
		%>
	<TABLE width="100%">
		<TR>
			<TD valign="top">
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"   />
			</TD>
		</TR>
	</TABLE>

</form>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
		</wea:item>
	</wea:group>
	</wea:layout>
</div>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
    </BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
<!--
function doSubmit(obj){
    obj.disabled = true ;

    var dialog =  parent.parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
	dialog.close();
}
function doAdd(obj){ 
	showDialogWin("<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>","/worktask/base/worktaskAddCreateRight.jsp?wtid=<%=wtid%>",500,400)
}
function showDialogWin(title,url,width,height,showMax){
	var Show_dialog = new window.top.Dialog();
	Show_dialog.currentWindow = window;   //传入当前window
 	Show_dialog.Width = width;
 	Show_dialog.Height = height;
 	Show_dialog.maxiumnable=showMax;
 	Show_dialog.Modal = true;
 	Show_dialog.Title = title;
 	Show_dialog.URL = url;
 	Show_dialog.show();
}

function MainCallback(){
	dialog.close();
	window.location.reload();
}


function useSetto(){
	if(typeof dialog === "undefined" || dialog == null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(21931,user.getLanguage()) %>";
    dialog.URL = "/worktask/base/WorktaskList.jsp?wtid=<%=wtid%>&usesettotype=3";
	dialog.Width = 660;
	dialog.Height = 660;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
}

function onCancel(){
		var dialog = parent.getDialog(window);
		dialog.close();
}
function doDel(obj){ 
	if(jQuery("input:checkbox[checked]").length>0){
	    obj.disabled = true ; 
		frmAdd.method.value="delCreator";
		frmAdd.submit();   
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
	}
}
var dlg;
function delPrm(id){	
	if(window.top.Dialog){
		dlg = window.top.Dialog
	} else {
		dlg = Dialog;
	}
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked"))			
				ids = ids +$(this).attr("checkboxId")+",";
		});
	} else {
		ids = id+",";
	}
	if(ids=="") {
		dlg.alert("<%=SystemEnv.getHtmlLabelName(31017,user.getLanguage())%>") ;
	} else {
		dlg.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		doDeletePrm(ids);
		}, function () {}, 300, 90, true, null, null, null, null, null);
	}
}
function doDeletePrm(ids){
	$.post("/worktask/base/ShareOperation.jsp",{method:"delCreator",ids:ids},function(datas){
		document.location.reload();
	});
}
//-->
</SCRIPT>


