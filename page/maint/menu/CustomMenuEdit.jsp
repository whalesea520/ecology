
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="scc" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<HTML>
 <HEAD>
	<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
 </HEAD>
 <%
 String menuid =Util.null2String(request.getParameter("menuid"));	
 String menutype= Util.null2String(request.getParameter("menutype"));
 String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
 String operate =Util.null2String(request.getParameter("operate"));
 String closeDialog= Util.null2String(request.getParameter("closeDialog"));
 String titlename = "";
 %>
 <BODY>
 	<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33497,user.getLanguage())%>"/> 
		</jsp:include>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onAdd(),_self} " ;
RCMenuHeight += RCMenuHeightStep ; 
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 
 <table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="saveAndEdit();">
						
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top"
							onclick="onAdd()" />
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
	<div id="zDialog_div_content">
		<form id="menuForm" name="menuForm" method="post" action="CustomMenuOprate.jsp">
		<input type="hidden" id="method" name="operate" value="<%=operate %>"/>
		<input type="hidden" id="pageUrl" name="pageUrl" value="list"/>
		<input type="hidden" name="menuid" value="<%=menuid%>">
		<%if("saveNew".equals(operate)){ %>
		<input type="hidden" name="subCompanyId" value="<%=subCompanyId %>">
		<input type="hidden" name="menutype" value="<%=menutype %>" >
		<%} %>
<wea:layout type="2Col">
     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
      <wea:item><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%></wea:item>
      <wea:item>
        <wea:required id="menunamespan" required="true">
         <input type="text" class="inputstyle" id="menuname" name="menuname" onchange="checkinput('menuname','menunamespan');"/>
         </wea:required>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(33524,user.getLanguage())%></wea:item>
      <wea:item>
         <input type="text" class="inputstyle" id="menudesc" name="menudesc"/>
      </wea:item>
      <%if("addMenu".equals(operate)){ %>
      <wea:item><%=SystemEnv.getHtmlLabelName(19054,user.getLanguage())%></wea:item>
      <wea:item>
        <select id="menutype" name="menutype" onchange="changeMenutype(this.value);">
			<option value="1" <%="1".equals(menutype)?"selected":""%>><%=SystemEnv.getHtmlLabelName(23021,user.getLanguage())%></option>
			<option value="2" <%="2".equals(menutype)?"selected":""%>><%=SystemEnv.getHtmlLabelName(23022,user.getLanguage())%></option>
		</select>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
      <wea:item>
        <select id="subType" style="float:left;width:90px;" onchange="changeSubType(this.value);">
			<option value="1"><%=SystemEnv.getHtmlLabelName(81649,user.getLanguage())%></option>
			<option value="0"><%=SystemEnv.getHtmlLabelName(32646,user.getLanguage())%></option>
		</select>
		<span id="subCompanySpan" style="float:left;">
		 
		<brow:browser viewType="0" name="subCompanyId" browserValue='<%=subCompanyId%>' 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
							browserSpanValue='<%=scc.getSubCompanyname(subCompanyId)%>'></brow:browser>
		</wea:item>
	  </span>
      <%} %>
     </wea:group>
</wea:layout>
		
	</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
	 	</wea:item>
	</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
 </BODY>
</HTML>
<link href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" rel=STYLESHEET>
<script type="text/javascript">
var checkField = "menuname";
	$(document).ready(function(){
		if(<%="1".equals(menutype)%>)jQuery("#outsubCompanyIddiv").parents("TR:first").hide();
		resizeDialog(document);
		var closeDialog = "<%=closeDialog%>";
		if(closeDialog=="close"){
			if("<%=operate%>"=="saveNew")
				onEdit("<%=menuid%>");
			var parentWin = parent.getParentWindow(window);
			parentWin.location.reload();
			onCancel();
		}
		if(closeDialog=="closeAndEdit"){
			onEdit("<%=menuid%>");
			var parentWin = parent.getParentWindow(window); 
			parentWin.location.reload();
			onCancel();
		}
		if($("#subType").val() ==1){
			checkField = "menuname,subCompanyId";
		}
	})
	
	function changeSubType(value){
		if(value=="0"){
			checkField = "menuname";
			jQuery("#subCompanyId").val("0");
	        jQuery("#subcompanyid_span").html("");
			jQuery("#subCompanySpan").hide();
		}else if(value=="1"){
			checkField="menuname,subCompanyId";
			jQuery("#subCompanySpan").show();
		}
	}
	
	function changeMenutype(value){
		if(value=="1"){
			checkField = "menuname";
			jQuery("#subCompanyId").val("-1");
	        jQuery("#subcompanyid_span").html("");
			jQuery("#outsubCompanyIddiv").parents("TR:first").hide();
		}else if(value=="2"){
			checkField="menuname,subCompanyId";
			jQuery("#outsubCompanyIddiv").parents("TR:first").show();
		}
	}
	
	function onEdit(menuid){
		url = "/page/maint/menu/MenuEdit.jsp?id="+menuid+"&menutype=<%=menutype%>&subCompanyId=<%=subCompanyId%>";
		var title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>";
		showDialog(title,url,800,600,true);
	}
	
	function onCancel(){
		var dialog = parent.getDialog(window);	
		dialog.close();
	}
	
	function showDialog(title,url,width,height,showMax){
		var Show_dialog = new window.top.Dialog();
		Show_dialog.currentWindow = parent.getDialog(window).currentWindow;   //传入当前window
	 	Show_dialog.Width = width;
	 	Show_dialog.Height = height;
	 	Show_dialog.maxiumnable=showMax;
	 	Show_dialog.Modal = true;
	 	Show_dialog.Title = title;
	 	Show_dialog.URL = url;
	 	Show_dialog.show();
	}
	
	function onAdd(){
		if(check_form(document.menuForm,checkField)){
			menuForm.submit();
		}	
	}

	function saveAndEdit(){
		if(check_form(document.menuForm,checkField)){
			jQuery("#pageUrl").val("edit");				
			menuForm.submit();
		}
	}
	
	function onShowSubcompany(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+currentids);
	   	if(id1){
	          var sHtml = "<a href='javascript:void(0)' onclick=openFullWindowForXtable('/hrm/company/HrmSubCompanyDsp.jsp?id="+id1.id+"')>"+id1.name+"</a>&nbsp;";
	          jQuery("#"+inputid).val(id1.id);
	          jQuery("#"+spanid).html(sHtml);
	          jQuery("#subcompanyidespan").hide();
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	          jQuery("#subcompanyidespan").show();
	       }
	}
</script>




