<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="OfsTodoDataService" class="weaver.ofs.service.OfsTodoDataService" scope="page" />
<jsp:useBean id="OfsDataParse" class="weaver.ofs.util.OfsDataParse" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("ofs:ofssetting", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>


<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />


<STYLE>
	.vis1	{ visibility:visible }
	.vis2	{ visibility:hidden }
	.vis3   { display:inline}
	.vis4   { display:none }
	
	table.setbutton td
	{
		padding-top:10px; 
	}
	table ul#tabs
	{
		width:85%!important;
	}
</STYLE>
</head>
<%


String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
String needfav ="1";
String needhelp ="";
String tiptitle = "";
//String typename = Util.null2String(request.getParameter("typename"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String isDialog = Util.null2String(request.getParameter("isdialog"));
int id = Util.getIntValue(request.getParameter("id"),0);
weaver.ofs.bean.OfsTodoData tododata= OfsTodoDataService.getOneBean(id);
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

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<script language=javascript>
<%
if(msgid!=-1){
%>
top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(msgid,user.getLanguage())%>!');
<%}%>
</script>
<FORM id=weaver name=frmMain action="OfsToDodataView.jsp" method=post >

<input class=inputstyle type=hidden name="backto" value="">
<input class=inputstyle type="hidden" name=operation value="add">
 <wea:layout><!-- 基本信息 -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(31694,user.getLanguage())%></wea:item><!--异构系统-->
		<wea:item>
             <%=OfsDataParse.getOfsInfoName(tododata.getSysid())%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></wea:item><!-- 流程类型 -->
		<wea:item>
		 	 <%=tododata.getWorkflowname()%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%>ID</wea:item><!-- 流程ID -->
		<wea:item>
           <%=tododata.getFlowid()%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%>GUID</wea:item><!-- 流程GUID -->
		<wea:item>
            <%=tododata.getFlowguid()%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item><!-- 标题 -->
		<wea:item>
            <%=tododata.getRequestname()%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(126645,user.getLanguage())%></wea:item><!-- 处理状态 -->
		<wea:item>
            <%=OfsDataParse.getIsremark(tododata.getIsremark(),user.getLanguage()+"")%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("367,602",user.getLanguage())%></wea:item><!-- 查看状态 -->
		<wea:item>
            <%=OfsDataParse.getViewType(tododata.getViewtype(),user.getLanguage()+"")%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15694,user.getLanguage())%></wea:item><!-- 步骤名称 -->
		<wea:item>
           <%=tododata.getNodename()%>
		</wea:item>
		<wea:item>PC<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></wea:item><!-- PC地址 -->
		<wea:item>
			 <%=OfsDataParse.getUrl(tododata.getSysid(),tododata.getPcurl(),"")%>
		</wea:item>
		<wea:item>APP<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></wea:item><!-- APP地址 -->
		<wea:item>
			 <%=OfsDataParse.getUrl(tododata.getSysid(),tododata.getAppurl(),"1")%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item><!-- 创建人 -->
		<wea:item>
            <%=new weaver.splitepage.transform.SptmForPlanMode().getResourceName(tododata.getCreatorid())%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(6056,user.getLanguage())%>)</wea:item><!-- 创建人（原值） -->
		<wea:item>
           <%=tododata.getCreator()%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></wea:item><!-- 创建时间 -->
		<wea:item>
           <%out.println(tododata.getCreatedate()+" "+tododata.getCreatetime());%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%></wea:item><!-- 接收人-->
		<wea:item>
          <%=new weaver.splitepage.transform.SptmForPlanMode().getResourceName(tododata.getUserid())%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(6056,user.getLanguage())%>)</wea:item><!--接收人（原值） -->
		<wea:item>
           <%=tododata.getReceiver()%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18002,user.getLanguage())%></wea:item><!-- 接收时间 -->
		<wea:item>
           <%out.println(tododata.getReceivedate()+" "+tododata.getReceivetime());%>
		</wea:item>
		
	</wea:group>
	
</wea:layout>
<br>
 <%if("1".equals(isDialog)){ %>
 <input type="hidden" name="isdialog" value="<%=isDialog%>">
 <%} %>
 </form>

<script language="javascript">
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


