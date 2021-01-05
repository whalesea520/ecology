
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class= "weaver.conn.RecordSet" scope="page" />
 
<%
    String wtid = Util.null2String(request.getParameter("wtid")); 	
	int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
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
    %>

    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    
    <jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="worktask"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(119,user.getLanguage()) %>"/>
	</jsp:include>

	<wea:layout attributes="{layoutTableId:topTitle}">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doAdd(this);">						
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="delPrm('')">
				<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
			</wea:item>
		</wea:group>
	</wea:layout>
    
	<form  name="frmAdd" method="post" action="ShareOperation.jsp">
	<input type="hidden"  name="method">
    <input type="hidden"  name="wtid" value="<%=wtid%>">
                                    
        <%
        int perpage =10;
		//设置好搜索条件
		String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\" >"
		  + "<checkboxpopedom popedompara=\"column:id\" showmethod=\"weaver.worktask.worktask.WTRequestUtil.getCheckbox\"/>"
		  + "<sql backfields=\"*\" sqlform=\" from requestshareset \" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\"taskid="+wtid+"and requestid="+requestid+"\" sqlisdistinct=\"false\" />"+
			"       <head>"+
			"    <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19117,user.getLanguage())+"\" column=\"sharetype\" otherpara=\""+user.getLanguage()+"\"  orderkey=\"sharetype\" transmethod=\"weaver.worktask.worktask.WTRequestUtil.getWTShareTypes\" />"+
			
			"    <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(106, user.getLanguage())+"\" column=\"sharetype\" otherpara=\"column:objid+column:rolelevel+"+user.getLanguage()+"\" transmethod=\"weaver.worktask.worktask.WTRequestUtil.getShareType\" />"+
			"    <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" orderkey=\"seclevel\" otherpara=\"column:sharetype"+"\" transmethod=\"weaver.worktask.worktask.WTRequestUtil.getShareSeclevel\"   />"+
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
	showDialogWin("<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>","/worktask/request/RequestShareSet.jsp?wtid=<%=wtid%>&requestid=<%=requestid%>",600,400)
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
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>")
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
	var idarr = ids.split(",");
	for(var i=0;i<idarr.length;i++){
		$.post("RequestShareOperation.jsp?requestid=<%=requestid%>&wtid=<%=wtid%>&types=0&method=delete&id="+idarr[i],{},function(datas){
			
		});
	}
	document.location.reload();
}
//-->
</SCRIPT>


