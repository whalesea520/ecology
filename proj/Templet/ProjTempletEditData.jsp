<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%
//User user = HrmUserVarify.getUser (request , response) ;
//if(user == null)  return ;
int templetId = Util.getIntValue(request.getParameter("templetId"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<!DOCTYPE html>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>

<SCRIPT language="javascript"  type='text/javascript' src="/js/ArrayList_wev8.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/ProjTask_wev8.js"></SCRIPT>
<script type="text/javascript" src="/js/projTask/temp/prjTask_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/temp/jquery.z4x_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/temp/ProjectAddTaskI2_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/TaskUtil_wev8.js"></script>

<script src="/proj/js/fancytree/lib/jquery1.11.min_wev8.js" type="text/javascript"></script>
<script src="/proj/js/jquery-migrate-1.2.1.min_wev8.js" type="text/javascript"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/proj/js/fancytree/lib/jquery-ui-1.10/jquery-ui_wev8.css" />
<script src="/proj/js/fancytree/lib/jquery-ui-1.10/jquery-ui.min_wev8.js" type="text/javascript"></script>


<style type="text/css">
	/* custom alignment (set by 'renderColumns'' event) */
	td.alignRight {
	   text-align: right;
	}
	td input[type=input] {
		width: 40px;
	}
	span.fancytree-title{
		width:140px!important;
	}
</style>
<script src="/proj/js/fancytree/lib/jquery-ui-contextmenu/jquery.ui-contextmenu_wev8.js" type="text/javascript"></script>
<link href="/proj/js/fancytree/src/skin-win7/ui.fancytree_wev8.css" rel="stylesheet" type="text/css">
<script src="/proj/js/fancytree/src/jquery.fancytree_wev8.js" type="text/javascript"></script>
<script src="/proj/js/fancytree/src/jquery.fancytree.dnd_wev8.js" type="text/javascript"></script>
<script src="/proj/js/fancytree/src/jquery.fancytree.edit_wev8.js" type="text/javascript"></script>
<script src="/proj/js/fancytree/src/jquery.fancytree.gridnav_wev8.js" type="text/javascript"></script>
<script src="/proj/js/fancytree/src/jquery.fancytree.table_wev8.js" type="text/javascript"></script>


<style type="text/css">
	.ui-menu {
		width: 150px;
		font-size: 63%;
	}
html { overflow-x:hidden; }
</style>

</head>
<body class="example" oncontextmenu="hideRightMenu(event);">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:parent.doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<!------------------任务列表---------------------开始-->
   <input type="hidden" onclick="getXmlDocStr1()" value="GetXmlDocStr">
   <TEXTAREA NAME="areaLinkXml" id="areaLinkXml" ROWS="6" COLS="100" style="display:none"></TEXTAREA> 
   <!--得到隐藏的层,等此form提交的时候不要忘了清除里的的数据-->  
   <div id="divTaskList" style="display:''">
   <TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="tblTask" >
   			<colgroup>
    	  	<col width="3%">
    	  	<col width="5%">
    	  	<col width="20%">
    	  	<col width="5%">
    	  	<col width="12%">
    	  	<col width="12%">
    	  	<col width="15%">
    	  	<col width="8%">
    	  	<col width="10%">
    	  </colgroup>
    	  <thead>
    	  	<TR class="header">
	           <TH	width="3%"><input type="checkbox" class="" id="chkAllObj"></TH>
	           <TH	width="5%" nowrap><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></TH>
	           <TH	width="20%" id="remindHeader"><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%> <span><img class='remindImg' src='/wechat/images/remind_wev8.png'  align='absMiddle' title='' /></span></TH>
	           <TH	width="5%"><%=SystemEnv.getHtmlLabelName(1298,user.getLanguage())%></TH>
	           <TH	width="12%"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TH>     
	           <TH	width="12%"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TH>
	           <TH	width="15%"><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%></TH>
	           <TH	width="8%"><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TH>
	           <TH	width="10%"><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TH>
	       </TR>
    	  </thead>
          <TBODY></TBODY>
    </TABLE>
</div>   

 
 

<div id="remindtbl" style="display:none;z-index:99999;">
<%
if(user.getLanguage()==8){
	%>
Reminder
1, hold down the task name can drag task;
2, the right mouse button click on the task name to pop up the task menu;
3, support for keyboard shortcuts;
4, the mouse click on a line to modify the task name;	
	<%
}else if(user.getLanguage()==9){
	%>
溫馨提示:
1,按住任務名稱可拖動任務;
2,鼠標右鍵單擊任務名稱彈出任務快捷操作菜單;
3,支持鍵盤快捷鍵操作;
4,鼠標雙擊某行修改任務名稱;	
	<%
}else{
	%>
温馨提示:
1,按住任务名称可拖动任务;
2,鼠标右键单击任务名称弹出任务快捷操作菜单;
3,支持键盘快捷键操作;
4,鼠标双击某行修改任务名称;
	<%
}
%>
</div>
<script type="text/javascript" src="/proj/js/commontsk_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>


<script type="text/javascript">
//加载任务
$(function(){
	var taskDataUrl="/proj/task/PrjTaskTreeJSONData.jsp?loadAll=1&src=template&templateId=<%=templetId %>";
	var taskDataLazyUrl="/proj/task/PrjTaskTreeJSONData.jsp?loadAll=0&src=template&templateId=<%=templetId %>";
	loadTaskData("tblTask",taskDataUrl,taskDataLazyUrl,"true","true");
	
});
</script>
</body>
</html>


