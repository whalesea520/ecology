
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage());
String needfav ="1";
String needhelp ="";

if(!HrmUserVarify.checkUserRight("SystemTemplate:Edit", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String url="";
HashMap kv = (HashMap)pack.packageParams(request, HashMap.class);
String _fromURL = Util.null2String((String)kv.get("_fromURL"));
String loginview = Util.null2String((String)kv.get("loginview"));
String templateid = Util.null2String((String)kv.get("id"));
String type=  Util.null2String((String)kv.get("type"));
String subCompanyId = Util.null2String((String)kv.get("subCompanyId"));

String tempatename="";
String templateType = "";
String TemplateTitle = "";
String extendtempletid ="";
String ecology7themeid="";

if(type.equals("add")&&templateid.equals("")){
	//templateid = "1";
	templateType="ecology8";
}

rs.executeSql("select * from SystemTemplate where id = "+templateid);
if(rs.next()){
	templateType = rs.getString("templateType");
	TemplateTitle = rs.getString("TemplateTitle");
	tempatename = rs.getString("TemplateName");
	extendtempletid = rs.getString("extendtempletid");
	ecology7themeid = rs.getString("ecology7themeid");
}
if(Util.getIntValue(extendtempletid)>0){
	
}
if(templateType.equals("ecology8")){
	url="/systeminfo/template/PortalTemplateE8Editor.jsp?subCompanyId="+subCompanyId+"&templateid="+templateid+"&e="+new Date().getTime();	
}else if(templateType.equals("ecology7")){
	url="/systeminfo/template/PortalTemplateEditor.jsp?subCompanyId="+subCompanyId+"&templateid="+templateid+"&e="+new Date().getTime();	
}else if(templateType.equals("ecologyBasic")){
	url= "/systeminfo/template/PortalTemplateBasicEditor.jsp?subCompanyId="+subCompanyId+"&init=true&templateid="+templateid;
}

	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script src="/wui/theme/ecology8/jquery/plugin/plupload/js/plupload.full.min_wev8.js"></script>





</head>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="portal"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32460,user.getLanguage())%>"/> 
	</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="dosubmit()">						
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


	
	<div class="zDialog_div_content">
    		
    	
    	<FORM  name="frmAdd" id="frmAdd"  method="post" enctype="multipart/form-data">
        	
    			<wea:layout  type="4col">
    			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
    				<wea:item>
    					<%=SystemEnv.getHtmlLabelName(18151,user.getLanguage()) %>
    				</wea:item>
    				<wea:item>
    					
    					<input type="text" class="inputstyle" name="templatename" id ="templatename" value="<%=tempatename %>" style="width:200px!important" onchange="checkinput('templatename','saveAsNameSpan')">
							<%
								String img="";
								if(tempatename.equals("")){
									img = "<img src='/images/BacoError_wev8.gif' align='absMiddle'>";
								} 
							%>
				          	<span id="saveAsNameSpan" style=''><%=img %></span>
				          	
				          	
    				</wea:item>
    					<wea:item>
    					<%=SystemEnv.getHtmlLabelName(18795,user.getLanguage()) %>
    				</wea:item>
    				<wea:item>
    					
    					<input type="text" class="inputstyle" name="templatetitle" id ="templatetitle" value="<%=TemplateTitle %>" style="width:200px!important" onchange="checkinput('templatetitle','templatetitleSpan')">
							<%
								String img="";
								if(TemplateTitle.equals("")){
									img = "<img src='/images/BacoError_wev8.gif' align='absMiddle'>";
								} 
							%>
				          	<span id="templatetitleSpan" style=''><%=img %></span>
				          	
				          	
    				</wea:item>
    				<%if(type.equals("add")){ %>
    				<wea:item >
    					<%=SystemEnv.getHtmlLabelName(17868,user.getLanguage()) %>:
    				</wea:item>
    				<wea:item attributes="{colspan:3}">
    					<select id="changeSubType" style="float:left;width:90px;" >
    						<option value ="1"><%=SystemEnv.getHtmlLabelName(81649,user.getLanguage()) %></option>
    						<option value ="0"><%=SystemEnv.getHtmlLabelName(32646,user.getLanguage()) %></option>
    					</select>
    					<span id="subCompanySpan" style="float:left;">
							<brow:browser viewType="0" name="subCompanyid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
						</span>
    				</wea:item>
    				<%} %>
    			</wea:group>
    			
    		</wea:layout>
    		</FORM>
		</div>
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
</body>
</html>

<script language="javascript">
function onCancel(){
		var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
		dialog.close();
	}
	

function dosubmit(){
	if(check_form(frmAdd,'templatename,templatetitle,subCompanyid')){
		var templatename = $("#templatename").val();
		var templatetitle = $("#templatetitle").val();
		var subCompanyid = $("#subCompanyid").val();
		//alert(subCompanyid)
		var method ="add";
		if("<%=type%>"=="edit"){
			method = "savebase";
		}
		//alert(method)
		var multitemplatename = $("#__multilangpre_templatename"+$("#templatename").attr("rnd_lang_tag")).val();
		var multitemplatetitle = $("#__multilangpre_templatetitle"+$("#templatetitle").attr("rnd_lang_tag")).val();
		if(multitemplatename){
			templatename = multitemplatename;
		}
		if(multitemplatetitle){
			templatetitle = multitemplatetitle;
		}
		$.post("/systeminfo/template/PortalTemplateOperation.jsp",
			{method:method,id:'<%=templateid%>',templatename:templatename,templatetitle:templatetitle,subCompanyid:subCompanyid},
			function(data){
				data = $.parseJSON($.trim(data));
				if(data&&data.__result__===false){
					top.Dialog.alert(data.__msg__);
				}else{
					parentDialog.currentWindow.location.reload();
					var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
					dialog.close();
				}
			
		});
	}
}
	
jQuery(function(){
    
   $("#changeSubType").bind("change",function(){
   		var type = $(this).val();
   		
   		if(type==0){
   			$("#subCompanySpan").hide();
   			$("#subCompanyid").val("0");
   			$("#subCompanyidspan").text("");
   		}else{
   			$("#subCompanySpan").show();
   		}
   })
});

function refreshTab(){
	var f = window.parent.oTd1.style.display;
	if (f != null) {
		if(f==''){
			window.parent.oTd1.style.display='none';
		}else{ 
			window.parent.oTd1.style.display='';
			window.parent.wfleftFrame.setHeight();
		}
	}
}


function getLoginTemplateName(){
	return $("#templatename").val();
}
</script>

<style>
	.templateType{
		position:absolute;
		height:75px;
		width:125px;
		top:5px;
		text-align:center;
		cursor:pointer;
		padding:3px;
	}
	
	.select{
		background:#2690e3;
	}
	
	#templateTitle{
		cursor:text;
	}
</style>
