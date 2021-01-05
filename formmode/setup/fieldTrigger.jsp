
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ page import="weaver.system.code.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<%
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<html>
<%
	String ajax=Util.null2String(request.getParameter("ajax"));
int modeId = Util.getIntValue(request.getParameter("id"),0);
if(modeId<=0){
	modeId = Util.getIntValue(request.getParameter("modeId"),0);
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

	String message=Util.null2String(request.getParameter("message"));
	if(message.equals("reset")) message = SystemEnv.getHtmlLabelName(22428,user.getLanguage());//触发字段和被触发字段不属于同一明细
	
	
	String ischecked = "";
	int triggerNum = 0;
	RecordSet.executeSql("select * from modeDataInputentry where modeid="+modeId);
	while(RecordSet.next()){
		triggerNum++;
		ischecked = " checked ";
	}
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(21848,user.getLanguage());//字段联动
String needfav ="";
String needhelp ="";
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body style="height:400px;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

	//if(!ajax.equals("1")){
    //    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
    //}else{
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:flowTriggerSave(this),_self} " ;
    //}
	RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id="frmTrigger" name="frmTrigger" method=post action="triggerOperation.jsp" >
	<input type="hidden" id="triggerNum" name="triggerNum" value="<%=triggerNum%>">
	<input type="hidden" id="modeId" name="modeId" value="<%=modeId%>">
	<div style="display:none">
	<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
	</table>
	</div>
	<div id=setting>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("21683,320",user.getLanguage())%>'>
			<wea:item type="groupHead">
				<input type=button class=addbtn onclick="addFieldTrigger()" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
	  			<input type=button class=delbtn onclick="deleteFieldTrigger()"title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></input>
			</wea:item>
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_FIELDTRIGGER %>"/>
			<wea:item attributes="{'isTableList':'true'}">
				<% 
					String  operateString= "";
					operateString = "<operates width=\"20%\">";
					operateString+=" <popedom isalwaysshow=\"true\"></popedom> ";
		 	        operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:addFieldTrigger();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" index=\"0\"/>";
		 	        operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:deleteFieldTrigger()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
		 	        operateString+="</operates>";	
					String tabletype="checkbox";
					String sqlWhere = " modeid = "+ modeId;
					String tableString=""+
					   "<table  needPage=\"false\" instanceid=\"chooseSubWorkflow\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_FIELDTRIGGER,user.getUID())+"\" tabletype=\""+tabletype+"\">"+
					    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getMailCheckbox\" />"+
					   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"modeDataInputentry\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
					   operateString+
					   "<head>"+							 
							 "<col width=\"40%\" transmethod=\"weaver.general.KnowledgeTransMethod.getTriggerEditLink\"  otherpara=\"column:id+column:triggerFieldName+column:type+column:WorkflowID+"+user.getLanguage()+"\" text=\""+SystemEnv.getHtmlLabelNames("21805,22009",user.getLanguage())+"\" column=\"triggerName\"/>"+
							 "<col width=\"30%\" transmethod=\"weaver.general.KnowledgeTransMethod.getTriggerFieldNameByMode\" otherpara=\"column:type+column:WorkflowID+"+user.getLanguage()+"\" column=\"triggerFieldName\" text=\""+SystemEnv.getHtmlLabelNames("21805,261",user.getLanguage())+"\"/>"+
							 "<col width=\"30%\" transmethod=\"weaver.general.KnowledgeTransMethod.getTriggetTableTypeNew\" otherpara=\"column:triggerFieldName+column:WorkflowID+"+user.getLanguage()+"\" column=\"type\" text=\""+SystemEnv.getHtmlLabelNames("33507",user.getLanguage())+"\"/>"+
					   "</head>"+
					   "</table>";
				%>
				<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

</form>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
})
var iTop=(window.screen.height-580)/2;
var iLeft=(window.screen.width-900)/2;

function addFieldTrigger(entryID){
	/*id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/setup/fieldTriggerEntry.jsp?modeId=<%=modeId%>",window,"dialogWidth:900px;dialogHeight:580px;dialogTop: "+iTop+"; dialogLeft: "+iLeft)
	if(id == undefined || id =='undefined')
		window.location.reload();*/
	var title = "<%=SystemEnv.getHtmlLabelNames("21848,33508",user.getLanguage())%>";
	var url="/formmode/setup/fieldTriggerPopup.jsp?modeId=<%=modeId%>&entryID="+entryID+"&ajax=1";
	
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}

function showRowOfFieldTriggerPop(entryID){
	urls = escape("/formmode/setup/fieldTriggerEntry.jsp?modeId=<%=modeId%>&entryID="+entryID);
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+urls,window,"dialogWidth:900px;dialogHeight:580px;dialogTop: "+iTop+"; dialogLeft: "+iLeft)
	if(id == undefined || id =='undefined')
		window.location.reload();
}

function deleteRowOfFieldTrigger(){
    var oTable=$G('LinkageTable');
    curindex=0;
    len = document.frmTrigger.elements.length;
    var i=0;
    var rowsum1 = 0;
    var delsum=0;
    for(i=len-1; i >= 0;i--) {
        if (document.frmTrigger.elements[i].name=='checkbox_TriggerField'){
            rowsum1 += 1;
            if(document.frmTrigger.elements[i].checked==true) delsum+=1;
        }
    }
    if(delsum<1){
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
    }else{
        window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
			for(i=len-1; i >= 0;i--) {
                if (document.frmTrigger.elements[i].name=='checkbox_TriggerField'){
                    if(document.frmTrigger.elements[i].checked==true) {
                        oTable.deleteRow(rowsum1-1);
                        curindex--;
                    }
                    rowsum1 -=1;
                }

            }
		});
    }
    frmTrigger.submit();
}

function deleteFieldTrigger(id){
		if(!id){
			id = _xtable_CheckedCheckboxId();
		}
		if(!id){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
			return;
		}
		if(id.match(/,$/)){
			id = id.substring(0,id.length-1);
		}
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
			jQuery.ajax({
				url:"triggerOperation.jsp",
				type:"post",
				data:{
					entryId:id,
					srcfrom:"deleteTriggerEntry",
					modeId:"<%=modeId%>"
				},
				beforeSend:function(xhr){
					try{
						e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84024, user.getLanguage()) %>",true);
					}catch(e){}
				},
				complete:function(xhr){
					e8showAjaxTips("",false);
				},
				success:function(data){
					_table.reLoad();
				}
			});
		});
}
function flowTriggerSave(obj){
	var triggerNum = $G("triggerNum").value;
	for(var tempTriggerIndex=0;tempTriggerIndex<triggerNum;tempTriggerIndex++){
		if($G("triggerField"+tempTriggerIndex)){
			var triggerfield = $G("triggerField"+tempTriggerIndex).value;
			if(triggerfield==""){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
				return;
			}
		}
	}
	obj.disabled=true;
	doPost(frmTrigger,tab000002);
}
</script>
</body>
</html>
