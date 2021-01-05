<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
    <link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
	<script language="javascript" src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
    <script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</HEAD>
    <BODY>
 
    <%
    if(!HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
    	  response.sendRedirect("/notice/noright.jsp");
    	  return;
    }

    String sysid = Util.null2String(request.getParameter("id")); 	
    if(sysid.equals("")) {
		sysid="-1";
	}
	sysid=URLDecoder.decode(sysid,"utf-8");
    //System.out.println("sysid==="+sysid);
    String titlename ="" ;
    String needfav ="1";
    String needhelp ="";
    %> 
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %> 
    <%
      
		RCMenu += "{"+SystemEnv.getHtmlLabelName(18645,user.getLanguage())+",javascript:doAdd(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:delPrm(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
    %>
    <table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doAdd()">						
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="delPrm('')">
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<form  name="frmAdd" method="post" action="OutterSysShareOperation.jsp">
	<input type="hidden"  name="method">
    <input type="hidden"  name="sysid" value="<%=sysid%>">
												
	<%		
	

		int perpage =10;
		//设置好搜索条件
		String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\" >"
		  + "<checkboxpopedom popedompara=\"column:id\" showmethod=\"weaver.splitepage.transform.SptmForMenuShare.getCheckbox\"/>"
		  + "<sql backfields=\" id,type,content,seclevel,seclevelmax,sharelevel,jobtitlelevel,jobtitlesharevalue \" sqlform=\" from shareoutter \" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\"sysid='"+sysid+"'\" sqlisdistinct=\"false\" />"+
			"       <head>"+
			"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"type\" otherpara=\""+user.getLanguage()+"\"  orderkey=\"type\" transmethod=\"weaver.outter.OutterDisplayHelper.getMenuShareType\" />"+
			"           <col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(106, user.getLanguage())+"\" column=\"content\" otherpara=\"column:type+column:sharelevel+"+user.getLanguage()+"+column:jobtitlelevel+column:jobtitlesharevalue\" orderkey=\"sharevalue\" transmethod=\"weaver.outter.OutterDisplayHelper.getMenuShareValue\" />"+
			"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" otherpara=\"column:type+column:seclevelmax"+"\"  transmethod=\"weaver.outter.OutterDisplayHelper.getSeclevel\" />"+
			"       </head>"
	 	+"</table>";			
	 	
		%>
	<TABLE width="100%">
		<TR>
			<TD valign="top">
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
				
			</TD>
		</TR>
	</TABLE>                             
</form>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{'groupDisplay':'none'}">
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

function doSubmit(obj){
    obj.disabled = true ;
    
    var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
	dialog.close();
}
function doAdd(){ 
    
    showDialogWin("<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>","/interface/outter/OutterSysShareAddBrowser.jsp?id=<%=sysid%>",500,400); 
	
}
function onCancel(){
		var dialog = parent.parent.getParentWindow(parent);
		dialog.closeDialog();
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
	$.post("/interface/outter/OutterSysShareOperation.jsp",{method:"delShare",ids:ids},function(datas){
		document.location.reload();
	});
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

</SCRIPT>


