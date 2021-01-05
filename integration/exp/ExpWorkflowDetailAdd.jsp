<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.expdoc.ExpUtil"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
String backto = Util.null2String(request.getParameter("backto"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelNames("33925,31691,87",user.getLanguage());//归档流程注册信息
String needfav ="1";
String needhelp ="";

ExpUtil eu=new ExpUtil();



%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:doSaveAndNext(),_TOP} " ;//保存并进入详细设置
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" class="e8_btn_top" onclick="doSaveAndNext()"/>
			<%}%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM id=weaver name=frmMain action="ExpWorkflowDetailOperation.jsp?isdialog=1" method=post  >
<input class=inputstyle type=hidden name="backto" value="<%=backto%>">
<input class=inputstyle type="hidden" id='operation' name=operation value="add">
<wea:layout><!-- 基本信息 -->
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361 ,user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(34067,user.getLanguage())%></wea:item><!-- 流程路径 -->
		<wea:item attributes="{'id':'workflow_td'}">
  			<brow:browser name="workflowid" viewType="0" hasBrowser="true" hasAdd="false" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp" isMustInput="2" isSingle="true" hasInput="true"
 					completeUrl="/data.jsp?type=workflowBrowser" width="300px"/>   
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(83270,user.getLanguage())%></wea:item><!-- 归档方案 -->
		<wea:item>
            <wea:required id="expidimage" required="true">
            <select id="expid" style='width:120px!important;' name="expid" onchange='checkinput("expid","expidimage");changeProValue();'>
			 <%out.print(eu.getPropTypeOptions());%>
			</select>
            </wea:required>
		</wea:item>	
		<wea:item><%=SystemEnv.getHtmlLabelName(83272,user.getLanguage())%></wea:item><!-- 归档方案类型 -->
		<wea:item>
        	 <span id="proTypeSpan"><%=SystemEnv.getHtmlLabelName(83272,user.getLanguage())%></span><!-- 归档方案类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18493,86,599",user.getLanguage())%></wea:item><!-- 文件保存方式 -->
		<wea:item>
         	 <span id="proFileSaveTypeSpan"><%=SystemEnv.getHtmlLabelNames("18493,86,599",user.getLanguage())%></span><!-- 文件保存方式 -->
		</wea:item>
		
	</wea:group>
</wea:layout>
<br>
 </form>

<script language=javascript>
function submitData() {
	var checkvalue = "workflowid,expid";
    if(check_form(frmMain,checkvalue)){
        
        frmMain.submit();
    }else{
  
    }
}

function onBack(){
	parentWin.closeDialog();
}

function changeProValue()
{
var expProType="";
var fileSaveType="";

var temp=jQuery("#expid").val();
   $.ajax({ 
        	type:"POST",
            url: "/integration/exp/ExpGetProInf.jsp?"+Math.random(),
             data:{Proid:temp},
            cache: false,
  			async: false,
            success: function(data){
            data=data.replace(/(^\s+)|(\s+$)/g,"");
            var datas=data.split("#");
            if(datas.length>1){
             expProType=datas[0];
             fileSaveType=datas[1];
            
             }
             }
         });
     jQuery("#proTypeSpan").html(expProType);    
     jQuery("#proFileSaveTypeSpan").html(fileSaveType);    
 
}

function doSaveAndNext() {
    jQuery("#operation").val("addAndNext"); 
   var checkvalue = "workflowid,expid";
    if(check_form(frmMain,checkvalue)){
        frmMain.submit();
    }else{
  
    }
   

}
</script>
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
</BODY>
</HTML>