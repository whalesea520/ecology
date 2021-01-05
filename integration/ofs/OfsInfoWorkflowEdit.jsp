<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.ofs.service.*" %>
<%@ page import="weaver.ofs.bean.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
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
if(!HrmUserVarify.checkUserRight("ofs:ofssetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
String backto = Util.null2String(request.getParameter("backto"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelNames("16579,127023",user.getLanguage());//流程类型注册信息
String needfav ="1";
String needhelp ="";

String sysid = Util.null2String(request.getParameter("sysid"));
int sysreceivewfdata = 1;
RecordSet.execute("select receivewfdata from Ofs_sysinfo where sysid='"+sysid+"'");
if(RecordSet.next()){
    sysreceivewfdata = RecordSet.getInt(1);
}

int worklfowid = Util.getIntValue(request.getParameter("id"),0);
OfsWorkflowService services = new OfsWorkflowService();
OfsWorkflow wf = services.getOneBean(worklfowid);
String workflowname = wf.getWorkflowname();
String receivewfdata = wf.getReceivewfdata();
String edittype = Util.null2String(request.getParameter("edittype"));
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
if(HrmUserVarify.checkUserRight("ofs:ofssetting", user) && edittype.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(HrmUserVarify.checkUserRight("ofs:ofssetting", user) && edittype.equals("1")){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
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
<FORM id=weaver name=frmMain action="OfsInfoWorkflowOperation.jsp?isdialog=1" method=post  >
<input class=inputstyle type=hidden name="backto" value="<%=backto%>">
<input class=inputstyle type=hidden name="sysid" value="<%=sysid%>">
<input class=inputstyle type=hidden name="id" value="<%=worklfowid%>">
<input class=inputstyle type="hidden" id='operation' name=operation value="edit">
<wea:layout><!-- 基本信息 -->
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361 ,user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(31694 ,user.getLanguage())%></wea:item><!--异构系统 -->
		<wea:item attributes="{'id':'syscode_td'}">
  			 <%=new weaver.ofs.util.OfsDataParse().getOfsInfoName(sysid)%>
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(16579 ,user.getLanguage())%></wea:item><!--流程类型 -->
		<wea:item>
		<%if(edittype.equals("1")){ %>
            <wea:required id="workflownameimage" required="true" value='<%=workflowname%>'>
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100"  id="workflowname" _noMultiLang='true'  name="workflowname"  value='<%=workflowname%>' onchange='checkinput("workflowname","workflownameimage");checkvalues(this.name);'>
            </wea:required>
        <%}else{ %>
            <%=workflowname%>
        <%} %>
		</wea:item>	
		<wea:item><%=SystemEnv.getHtmlLabelNames("18526,18015" ,user.getLanguage())%></wea:item><!--接收流程-->
		<wea:item>
			   <input class="inputstyle" type="checkbox" <%if(!edittype.equals("1") || sysreceivewfdata == 0){ %>disabled<%} %> tzCheckbox='true' id="receivewfdata" name="receivewfdata" value="1" <% if("1".equals(receivewfdata) && sysreceivewfdata == 1)out.println("checked");%>>
		</wea:item>	
	</wea:group>
</wea:layout>
<br>
 </form>

<script language=javascript>
function checkvalues(obj) {
	var values = jQuery("#"+obj).val();
	var id = '<%=worklfowid%>';
	var params = "operation=checkinputwf&id="+id+"&values="+values+"&field="+obj+"&systemid=<%=sysid%>";
	jQuery.ajax({
			type : "post",
			cache : false,
			processData : false,
	        url: "/integration/ofs/OfsInfoDetailCheckInputAjax.jsp",
	        data: params,
	        success: function(msg){
	        	if(msg != ''){
	        		top.Dialog.alert(msg);
	        		jQuery("#"+obj).val("");
	        		jQuery("#"+obj+"image").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\">");
	        	}
		}
	});
}
function submitData() {
	var checkvalue = "workflowname";
    if(check_form(frmMain,checkvalue)){
        frmMain.submit();
    }else{
  
    }
}

function onBack(){
	parentWin.closeDialog();
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