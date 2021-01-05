
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.formmode.service.ModelInfoService" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<HTML>
<HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style>
*, textarea{
	font: 12px Microsoft YaHei;
}
a{

}
.e8_tblForm{
	width: 100%;
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: top;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 2px;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_label_desc{
	color: #aaa;
}
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
.versioninfo{
	color:#FF0000;
}
</style>
</head>
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(30185,user.getLanguage());//流程数据转模块数据
String needfav ="1";
String needhelp ="";
ModelInfoService modelInfoService = new ModelInfoService();
int modeId = Util.getIntValue(request.getParameter("id"),0);
if(modeId<=0){
	modeId = Util.getIntValue(request.getParameter("modeId"),0);
}
if(modeId<=0){
	modeId = Util.getIntValue(request.getParameter("modeid"),0);
}

String subCompanyIdsql = "select subCompanyId from modeinfo where id="+modeId;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
String customname = Util.null2String(request.getParameter("customname"));
String modename = modelInfoService.getModelInfoNameByModelInfoId(modeId);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javaScript:doAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="frmSearch" method="post" action="/formmode/interfaces/WorkflowToModeList.jsp">
<input type="hidden" name="modeid" id="modeid" value="<%=modeId%>">
<table class="e8_tblForm">
<tr>
	<td class="e8_tblForm_label" width="20%">
		<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%><!-- 流程类型 -->
	</td>
	<td class="e8_tblForm_field" width="80%">
		<brow:browser viewType="0" name="workflowid" browserValue='<%=workflowid==0?"":(String.valueOf(workflowid))%>' 
		 	browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+xssUtil.put("where isbill=1 and formid<0") %>'
			hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
			completeUrl="/data.jsp" linkUrl=""  width="228px" onPropertyChange="updateBrowserSpan()"
			browserDialogWidth="510px"
			browserSpanValue='<%=WorkflowComInfo.getWorkflowname(String.valueOf(workflowid))%>'>
		</brow:browser>
	</td>
	
	<!-- 
	<td>
		<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%>
	</td>
	<td class="Field">
  		 <button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></BUTTON>
  		 <span id=modeidspan><%=modename%></span>
  		 <input type="hidden" name="modeid" id="modeid" value="<%=modeId%>">
	</td>
	 -->
</tr>
</table>
</form>
<br/>

<%
String SqlWhere = " where a.modeid = b.id";
if(workflowid>0){
	SqlWhere += " and a.workflowid = "+workflowid+" ";
}
if(modeId>0){
	SqlWhere += " and a.modeid = '"+modeId+"'";
}

String perpage = "10";
String backFields = "a.id,a.modeid,a.workflowid,a.modecreater,a.modecreaterfieldid,a.triggerNodeId,a.triggerType,a.isenable,b.modename,'"+SystemEnv.getHtmlLabelName(19342,user.getLanguage())+"' detail";
String sqlFrom = " from mode_workflowtomodeset a,modeinfo b";
//out.println("select " + backFields + "	"+sqlFrom + "	"+ SqlWhere);
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
				  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
				  "<head>"+                    
				  		  //流程类型
						  "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(16579,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"workflowid\" transmethod=\"weaver.formmode.interfaces.WfToModeTransmethod.getWorkflowName\" otherpara=\""+user.getLanguage()+"\"/>"+
						  //模块名称
						  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(28485,user.getLanguage())+"\" column=\"modename\" orderkey=\"modename\"/>"+
						  //是否启用 
						  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18624,user.getLanguage())+"\" column=\"isenable\" orderkey=\"isenable\" transmethod=\"weaver.formmode.interfaces.WfToModeTransmethod.getIsEnable\" otherpara=\""+user.getLanguage()+"\"/>"+
						  //触发节点
						  //"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19346,user.getLanguage())+"\" column=\"triggerNodeId\" orderkey=\"triggerNodeId\" transmethod=\"weaver.formmode.interfaces.WfToModeTransmethod.getTriggerNodeId\"/>"+
						  //触发时间
						  //"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19347,user.getLanguage())+"\" column=\"triggerType\" orderkey=\"triggerType\" transmethod=\"weaver.formmode.interfaces.WfToModeTransmethod.getTriggerType\" otherpara=\""+user.getLanguage()+"\"/>"+
						  //详细设置
						  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(19342,user.getLanguage())+"\" column=\"detail\" orderkey=\"detail\"  target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"/formmode/interfaces/WorkflowToModeSet.jsp?initmodeid="+modeId+"&amp;initworkflowid="+workflowid+"\"/>"+
				  "</head>"+
			  "</table>";


%>

<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>

<script type="text/javascript">
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})

    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    function doAdd(){
		enableAllmenu();
        location.href="/formmode/interfaces/WorkflowToModeSet.jsp?isadd=1&initmodeid=<%=modeId%>&initworkflowid=<%=workflowid%>";
    }
    function onShowModeSelect(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }
    
    function openURL(){
      var url = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=where isbill=1 and formid<0";
      var result = showModalDialog(url);
      if(result){
         $G("workflowspan").innerHTML = result.name;
         $G("workflowid").value=result.id;
      }else{
     	 $G("workflowspan").innerHTML = "";
         $G("workflowid").value="";
      }
    }
	function updateBrowserSpan(){
		if(event.propertyName=='value'){
			var title = $("#workflowidspan").find("a").text();
			$("#workflowidspan").html("<span class=\"e8_showNameClass\">"+title+"</span>");
		}
	}
</script>

</BODY>
</HTML>
