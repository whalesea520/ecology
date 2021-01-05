<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowSubwfSetManager" class="weaver.workflow.workflow.WorkflowSubwfSetManager" scope="page"/>

<%
	String mainWorkflowId = Util.null2String(request.getParameter("wfid"));
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(Util.getIntValue(mainWorkflowId), 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(19343, user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(19344, user.getLanguage())+"）";
    String needfav = "";
    String needhelp = "";
%>

<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
<html>
<HEAD> 
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
    <script type='text/javascript' src='/dwr/interface/WorkflowSubwfSetUtil.js'></script>
	<script type='text/javascript' src='/dwr/engine.js'></script>
	<script type='text/javascript' src='/dwr/util.js'></script>	
</HEAD>

<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<% 
int mainWorkflowFormId=0;
String mainWorkflowIsBill="";
String isTriDiffWorkflow="0";
RecordSet.executeSql("select formId,isBill,isTriDiffWorkflow from workflow_base where id="+mainWorkflowId);
if(RecordSet.next()){
	mainWorkflowFormId=Util.getIntValue(RecordSet.getString("formId"),0);
	mainWorkflowIsBill=Util.null2String(RecordSet.getString("isBill"));
	isTriDiffWorkflow=Util.null2String(RecordSet.getString("isTriDiffWorkflow"),"0");
}
if(isTriDiffWorkflow.equals("")){
	isTriDiffWorkflow="0";
	RecordSet.executeSql("update workflow_base set isTriDiffWorkflow='"+isTriDiffWorkflow+"' where id= "+mainWorkflowId);
}
%>
<form name="formWorkflowSubwfSet" method="post">     
<INPUT type="hidden" Name="mainWorkflowId" value="<%=mainWorkflowId%>">
<%
	String attributes1 = "{'groupOperDisplay':'none','samePair':'subwfSetContentDivSame','groupDisplay':'','itemAreaDisplay':''}"; 
	String attributes2 = "{'groupOperDisplay':'none','samePair':'subwfSetContentDivDiff','groupDisplay':'none','itemAreaDisplay':'none'}"; 
	if("1".equals(isTriDiffWorkflow)){
		attributes1 = "{'groupOperDisplay':'none','samePair':'subwfSetContentDivSame','groupDisplay':'none','itemAreaDisplay':'none'}"; 
		attributes2 = "{'groupOperDisplay':'none','samePair':'subwfSetContentDivDiff','groupDisplay':'','itemAreaDisplay':''}";
	}
 %>
<wea:layout type="twoCol" attributes="{'expandAllGroup':'true'}">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(31767,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(21579,user.getLanguage())%></wea:item>
	    <wea:item><input type="radio" name="isTriDiffWorkflow" value="0" <%if (!"1".equals(isTriDiffWorkflow)) out.println("checked");%>  onclick="showSubwfSetContent(0)"></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(21580,user.getLanguage())%></wea:item>
    	<wea:item><input type="radio" name="isTriDiffWorkflow" value="1" <%if ("1".equals(isTriDiffWorkflow)) out.println("checked");%>  onclick="showSubwfSetContent(1)"></wea:item>
    </wea:group>
    
    <%if(isTriDiffWorkflow.equals("0")){ %>
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(31769,user.getLanguage())%>' attributes="<%=attributes1 %>">
			<wea:item type="groupHead"> 
				<input type=button class=addbtn style="margin-top:7px;" onclick="addSubWf('0')" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
	  			<input type=button class=delbtn style="margin-top:7px;" onclick="removeValue()"title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></input>   
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<wea:layout needImportDefaultJsAndCss="false" attributes="{'formTableId':'oTable'}">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item  attributes="{'isTableList':'true'}">
							<!-- 分页列表 -->
							<% 
								String  operateString= "";
								operateString = "<operates width=\"20%\">";
								 	       operateString+=" <popedom isalwaysshow=\"true\"></popedom> ";
								 	       operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(33503,user.getLanguage())+"\" index=\"0\"/>";
								 	       operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:goWorkflowSubwfSetDetail()\" otherpara=\"column:subWorkflowId\" text=\""+SystemEnv.getHtmlLabelName(19342,user.getLanguage())+"\" index=\"1\"/>";
								 	       operateString+="     <operate isalwaysshow=\"true\" href=\"javascript:removeValue()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"2\"/>";
								 	       operateString+="</operates>";	
								 String tabletype="checkbox";
								String tableString=""+
								   "<table  datasource=\"weaver.workflow.workflow.WorkflowSubwfSetManager.getSubwfSetList\" sourceparams=\"mainWorkflowId:"+mainWorkflowId+"\" needPage=\"false\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_WORKFLOWSUBWFSET,user.getUID())+"\" tabletype=\""+tabletype+"\">"+
								    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getMailCheckbox\" />"+
								   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
								   operateString+
								   "<head>"+							 
										 "<col width=\"10%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"index\"/>"+
										 "<col width=\"10%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(22050,user.getLanguage())+"\" column=\"triggerTypeText\"/>"+
										 "<col width=\"10%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" column=\"triggerNodeNameText\" text=\""+SystemEnv.getHtmlLabelName(19346,user.getLanguage())+"\"/>"+
										 "<col width=\"10%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(19347,user.getLanguage())+"\" column=\"triggerTimeText\"/>"+
										 "<col width=\"10%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(22053,user.getLanguage())+"\" column=\"triggerOperationText\"/>"+
										 "<col width=\"30%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(19351,user.getLanguage())+"\" column=\"subWorkflowNameText\"/>"+
										 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(27156,user.getLanguage())+"\" column=\"triggerSource\"/>"+
										 "<col width=\"10%\"  transmethod=\"weaver.workflow.workflow.WorkflowSubwfSetUtil.transferEnable\" text=\""+SystemEnv.getHtmlLabelName(18095, user.getLanguage())+"\" column=\"enable\" otherpara='column:id'/>"+
								   "</head>"+
								   "</table>";
							%>
							<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</wea:item>    
	    </wea:group>
	<%}else{ %>
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(31769,user.getLanguage())%>' attributes="<%=attributes2 %>">
	    	<wea:item type="groupHead"> 
				<input type=button class=addbtn style="margin-top:7px;" onclick="addSubWf('1')" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
	  			<input type=button class=delbtn style="margin-top:7px;" onclick="removeValueDiff()" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></input>     	
	    	</wea:item>
	    	
			<wea:item attributes="{'isTableList':'true'}">
				<wea:layout needImportDefaultJsAndCss="false" attributes="{'formTableId':'oTableDiff'}">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item  attributes="{'isTableList':'true'}">
							<!-- 分页列表 -->
							<% 
								String  operateString= "";
								operateString = "<operates width=\"20%\">";
								 	       operateString+=" <popedom isalwaysshow=\"true\"></popedom> ";
								 	       operateString+="     <operate isalwaysshow=\"true\" href=\"javascript:goWorkflowTriDiffWfSubWf()\" text=\""+SystemEnv.getHtmlLabelName(19342,user.getLanguage())+"\" index=\"0\"/>";
								 	       operateString+="     <operate isalwaysshow=\"true\" href=\"javascript:removeValueDiff()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
								 	       operateString+="</operates>";	
								 String tabletype="checkbox";
								String tableString=""+
								   "<table  datasource=\"weaver.workflow.workflow.WorkflowSubwfSetManager.getSubwfSetDiffList\" sourceparams=\"mainWorkflowId:"+mainWorkflowId+"\" needPage=\"false\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_WORKFLOWSUBWFSET,user.getUID())+"\" tabletype=\""+tabletype+"\">"+
								    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getMailCheckbox\" />"+
								   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
								   operateString+
								   "<head>"+							 
										 "<col width=\"10%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"index\"/>"+
										 "<col width=\"10%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(22050,user.getLanguage())+"\" column=\"triggerTypeText\"/>"+
										 "<col width=\"10%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" column=\"triggerNodeNameText\" text=\""+SystemEnv.getHtmlLabelName(19346,user.getLanguage())+"\"/>"+
										 "<col width=\"10%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(19347,user.getLanguage())+"\" column=\"triggerTimeText\"/>"+
										 "<col width=\"10%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(22053,user.getLanguage())+"\" column=\"triggerOperationText\"/>"+
										 "<col width=\"30%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(21582,user.getLanguage())+"\" column=\"fieldNameText\"/>"+
										 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(27156,user.getLanguage())+"\" column=\"triggerSource\"/>"+
										 "<col width=\"10%\"  transmethod=\"weaver.workflow.workflow.WorkflowSubwfSetUtil.transferEnableDiff\" text=\""+SystemEnv.getHtmlLabelName(18095, user.getLanguage())+"\" column=\"enable\" otherpara='column:id'/>"+
								   "</head>"+
								   "</table>";
							%>
							<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</wea:item>   
	    </wea:group>
	<%} %>
</wea:layout>
</body>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#oTable").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
	jQuery("#oTableDiff").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
});

var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
function addSubWf(type){
	//diag_vote = new Dialog();
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelNames("611,31768",user.getLanguage())%>";
	url="/docs/tabs/DocCommonTab.jsp?dialog=1&_fromURL=62&wfid=<%=mainWorkflowId %>&isTriDiff="+type;
	
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	if(type==1){
		diag_vote.Height = 400;
	}else{
		diag_vote.Height = 400;
	}
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}

function openDialog(id){
	//diag_vote = new Dialog();
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelNames("33503",user.getLanguage())%>";
	url="/docs/tabs/DocCommonTab.jsp?dialog=1&_fromURL=63&id="+id+"&wfid=<%=mainWorkflowId %>";
	
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 250;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}

function closeDialog(){
	diag_vote.close();
}
function enableSetting(id){
	jQuery.ajax({
		url:"WorkflowSubwfSetOperation.jsp",
		type:"post",
		data:{
			settingId : id,
			operation : "enableSetting"
		},
		beforeSend:function(xhr){
			try{
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(129514, user.getLanguage())%>",true);
			}catch(e){}
		},
		complete:function(xhr){
			e8showAjaxTips("",false);
		},
		success:function(data){
			_table.reLoad();
		}
	});
}
function disableSetting(id){
	jQuery.ajax({
		url:"WorkflowSubwfSetOperation.jsp",
		type:"post",
		data:{
			settingId : id,
			operation : "disableSetting"
		},
		beforeSend:function(xhr){
			try{
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(129514, user.getLanguage())%>",true);
			}catch(e){}
		},
		complete:function(xhr){
			e8showAjaxTips("",false);
		},
		success:function(data){
			_table.reLoad();
		}
	});
}

function enableSettingDiff(id){
	jQuery.ajax({
		url:"WorkflowSubwfSetOperation.jsp",
		type:"post",
		data:{
			settingId : id,
			operation : "enableSettingDiff"
		},
		beforeSend:function(xhr){
			try{
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(129514, user.getLanguage())%>",true);
			}catch(e){}
		},
		complete:function(xhr){
			e8showAjaxTips("",false);
		},
		success:function(data){
			_table.reLoad();
		}
	});
}
function disableSettingDiff(id){
	jQuery.ajax({
		url:"WorkflowSubwfSetOperation.jsp",
		type:"post",
		data:{
			settingId : id,
			operation : "disableSettingDiff"
		},
		beforeSend:function(xhr){
			try{
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(129514, user.getLanguage())%>",true);
			}catch(e){}
		},
		complete:function(xhr){
			e8showAjaxTips("",false);
		},
		success:function(data){
			_table.reLoad();
		}
	});
}


function showSubwfSetContent(objId){
   var mainWorkflowId=<%=mainWorkflowId%>;
	jQuery.ajax({
		url:"officalwf_operation.jsp",
		type:"get",
		dataType:"json",
		data:{
			wfid:mainWorkflowId,
			isTriDiffWorkflow:objId,
			operation:"updateIsTriDiffWorkflow",
			random : Math.random() * 10000
		},
		beforeSend:function(xhr){
			try{
				e8showAjaxTips("正在更新数据，请稍候...",true);
			}catch(e){}
		},
		complete:function(xhr){
			e8showAjaxTips("",false);
		},
		success:function(data){
			window.location.reload();
		}
	});
	
}

function returnTrueDiff(o){
	return true;
}

function returnTrue(o){
	return true;
}

function onShowWorkFlowNeededValid(inputname, spanname){
	var url=encode("/workflow/workflow/WorkflowBrowser.jsp?isValid=1")	
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;")
	if(datas){
		if(datas.id!=""){
			jQuery("#"+spanname).html(datas.name);
			jQuery("input[name="+inputname+"]").val(datas.id);
		}else {
			jQuery("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name="+inputname+"]").val("");
		}
		
	}
}

function encode(str){
    return escape(str);
}

function addValue(){
    var isread = $G("isread").value;
    var subWorkflowIdValue=$G("subWorkflowId").value;
    if(jQuery("#subWorkflowIdspan").children().length>0){
    	var subWorkflowNameText=jQuery("#subWorkflowIdspan").children().children().html();
    }else{
    	var subWorkflowNameText=$G("subWorkflowIdspan").innerHTML;
    }
        

	if(subWorkflowIdValue==""||subWorkflowIdValue=="0"){
		alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		return;
	}

   var mainWorkflowId=<%=mainWorkflowId%>;

   var triggerTypeValue=$G("triggerType").value;
   var triggerTypeText = jQuery($G("triggerType").options.item($G("triggerType").selectedIndex)).text();

   var triggerNodeIdValue=$G("triggerNodeId").value;
   triggerNodeIdValue=triggerNodeIdValue.substr(triggerNodeIdValue.lastIndexOf("_")+1);
   var triggerNodeNameText = jQuery($G("triggerNodeId").options.item($G("triggerNodeId").selectedIndex)).text();

   var triggerTimeValue=$G("triggerTime").value;
   var triggerTimeText = jQuery($G("triggerTime").options.item($G("triggerTime").selectedIndex)).text();

   var triggerOperationText ="";
   var triggerOperationValue=$G("trTriggerOperationHidden").value;
   //var triggerOperationText = $G("triggerOperation").options.item($G("trTriggerOperationHidden").selectedIndex).innerText;
   
   if(triggerOperationValue!="" && triggerOperationValue==1){
   		triggerOperationText='<%=SystemEnv.getHtmlLabelName(25361,user.getLanguage())%>';
   }else if(triggerOperationValue!="" && triggerOperationValue==2){
   		triggerOperationText='<%=SystemEnv.getHtmlLabelName(25362,user.getLanguage())%>';
   }else if(triggerOperationValue!="" && triggerOperationValue==3){
   		triggerOperationText='<%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>';
   }else if(triggerOperationValue!="" && triggerOperationValue==4){
   		triggerOperationText='<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>';
   }else{
   		triggerOperationText="&nbsp;";
   }
   if(triggerTypeValue==2){
	   triggerTimeValue="";
	   triggerTimeText="";
	   triggerOperationValue="";
	   triggerOperationText="&nbsp;";
   }
   
   var oRow = oTable.insertRow(-1);
   var oRowIndex = jQuery("#oTable").find("tr").length;
   for (var i =1; i <=8; i++) {   //生成一行中的每一列



      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1)
		  oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkSubWorkflowSet' value='0'>";
      else  if (i==2) oDiv.innerHTML=triggerTypeText+"<input type='hidden' name='triggerTypeValue' value='"+triggerTypeValue+"'><input type='hidden' name='triggerTypeText' value='"+triggerTypeText+"'>";
      else  if (i==3) oDiv.innerHTML=triggerNodeNameText+"<input type='hidden' name='triggerNodeIdValue' value='"+triggerNodeIdValue+"'><input type='hidden' name='triggerNodeNameText' value='"+triggerNodeNameText+"'>";
      else  if (i==4) oDiv.innerHTML=triggerTimeText+"<input type='hidden' name='triggerTimeValue' value='"+triggerTimeValue+"'><input type='hidden' name='triggerTimeText' value='"+triggerTimeText+"'>";
      else  if (i==5) oDiv.innerHTML=triggerOperationText+"<input type='hidden' name='triggerOperationValue' value='"+triggerOperationValue+"'><input type='hidden' name='triggerOperationText' value='"+triggerOperationText+"'>";
      else  if (i==6) oDiv.innerHTML=subWorkflowNameText+"<input type='hidden' name='subWorkflowIdValue' value='"+subWorkflowIdValue+"'><input type='hidden' name='subWorkflowNameText' value='"+subWorkflowNameText+"'>";
      else  if (i==7) if(isread==0)oDiv.innerHTML="<select class='inputStyle' name=isreaddetail onchange=isreadonchange(this)><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option></select>";
                      else oDiv.innerHTML="<select class='inputStyle' name=isreaddetail onchange=isreadonchange(this)><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><option value=1 selected><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option></select>";                      
      else  if (i==8) oDiv.innerHTML="<span id=detailLinkSpan><a href='#'><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a></span>";

      jQuery(oCell).append(oDiv);
   }
    WorkflowSubwfSetUtil.addWorkflowSubwfSet(mainWorkflowId,subWorkflowIdValue,triggerNodeIdValue,triggerTypeValue,triggerTimeValue,triggerOperationValue,oRowIndex,isread+"",returnWorkflowSubwfSetId);
	jQuery("body").jNice();
	reflash();
}

function removeValue(id){
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
			url:"officalwf_operation.jsp",
			type:"post",
			data:{
				workflowSubwfSetId:id,
				operation:"deleteSubWfSet",
				wfid:"<%=mainWorkflowId%>"
			},
			beforeSend:function(xhr){
				try{
					e8showAjaxTips("正在删除数据，请稍候...",true);
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

function returnWorkflowSubwfSetId(o){
    var oRowIndex = o.split('_')[0];
	var workflowSubwfSetId = o.split('_')[1];

	var mainWorkflowId = $G("mainWorkflowId").value;
    if(oRowIndex==2){
		$G("chkSubWorkflowSet").value=workflowSubwfSetId;
		subWorkflowId=$G("subWorkflowIdValue").value;

		$G("detailLinkSpan").innerHTML="<A HREF='#' onClick='goWorkflowSubwfSetDetail("+workflowSubwfSetId+", "+mainWorkflowId+", "+subWorkflowId+")'"+"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></A>";
    } else if(oRowIndex>2){
    	jQuery("input[name=chkSubWorkflowSet]")[oRowIndex-2].value = workflowSubwfSetId;
		subWorkflowId=jQuery("input[name=subWorkflowIdValue]")[oRowIndex-2].value;

		jQuery("span[id=detailLinkSpan]")[oRowIndex-2].innerHTML="<A HREF='#' onClick='goWorkflowSubwfSetDetail("+workflowSubwfSetId+", "+mainWorkflowId+", "+subWorkflowId+")'"+"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></A>";		
	}
    var size = jQuery("select[name=isreaddetail]").length;   
    jQuery("select[name=isreaddetail]")[size-1].name=workflowSubwfSetId;
}

function isreadonchange(obj){
   WorkflowSubwfSetUtil.updateWorkflowSubwfSet(obj.name,obj.value,returnTrue) ;
}

function goWorkflowSubwfSetDetail(workflowSubwfSetId, subWorkflowId)
{
	//window.location = "/workflow/workflow/WorkflowSubwfSetDetail.jsp?ajax=1&workflowSubwfSetId="+workflowSubwfSetId+"&mainWorkflowId="+mainWorkflowId+"&subWorkflowId="+subWorkflowId;
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelNames("33504",user.getLanguage())%>";
	url="/docs/tabs/DocCommonTab.jsp?dialog=1&_fromURL=64&ajax=1&workflowSubwfSetId="+workflowSubwfSetId+"&mainWorkflowId=<%=mainWorkflowId %>&subWorkflowId="+subWorkflowId;
	
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.maxiumnable = true;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();

}

function addValueDiff(){
  
   var mainWorkflowId=<%=mainWorkflowId%>;


   var triggerTypeDiffValue=jQuery("select[name=triggerTypeDiff]").val();
   var triggerTypeDiffText = jQuery(jQuery("select[name=triggerTypeDiff]")[0].options.item(jQuery("select[name=triggerTypeDiff]")[0].selectedIndex)).text();

   var triggerNodeIdDiffValue=jQuery("select[name=triggerNodeIdDiff]").val();
   triggerNodeIdDiffValue=triggerNodeIdDiffValue.substr(triggerNodeIdDiffValue.lastIndexOf("_")+1);

   var triggerNodeNameDiffText =jQuery(jQuery("select[name=triggerNodeIdDiff]")[0].options.item(jQuery("select[name=triggerNodeIdDiff]")[0].selectedIndex)).text();

	var triggerTimeDiffObject=document.getElementsByName("triggerTimeDiff")[0];
   var triggerTimeDiffValue=jQuery(triggerTimeDiffObject).val();
   var triggerTimeDiffText = jQuery(triggerTimeDiffObject.options.item(triggerTimeDiffObject.selectedIndex)).html();

   var triggerOperationDiffText ="";
   var triggerOperationDiffValue=jQuery("input[name=trTriggerOperationDiffHidden]").val();
   //var triggerOperationDiffText = $GetEle("triggerOperationDiff").options.item($GetEle("triggerOperationDiff").selectedIndex).innerText;

   if(triggerOperationDiffValue!="" && triggerOperationDiffValue==1){
   		triggerOperationDiffText='<%=SystemEnv.getHtmlLabelName(25361, user.getLanguage())%>';
   }else if(triggerOperationDiffValue!="" && triggerOperationDiffValue==2){
   		triggerOperationDiffText='<%=SystemEnv.getHtmlLabelName(25362, user.getLanguage())%>';
   }else if(triggerOperationDiffValue!="" && triggerOperationDiffValue==3){
   		triggerOperationDiffText='<%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%>';
   }else if(triggerOperationDiffValue!="" && triggerOperationDiffValue==4){
   		triggerOperationDiffText='<%=SystemEnv.getHtmlLabelName(236, user.getLanguage())%>';
   }else{
   		triggerOperationDiffText="";
   }
   
   

   var fieldIdDiffObj=jQuery("select[name=fieldIdDiff]")[0];
   var fieldIdDiffValue=jQuery(fieldIdDiffObj).val();

   if(fieldIdDiffValue=="" || fieldIdDiffValue==null){
	   alert("<%=SystemEnv.getHtmlLabelName(25166, user.getLanguage())%>");
	   return;
   }


   var fieldNameDiffText = jQuery(fieldIdDiffObj.options.item(fieldIdDiffObj.selectedIndex)).text();

   if(triggerTypeDiffValue==2){
	   triggerTimeDiffValue="";
	   triggerTimeDiffText="";
	   triggerOperationDiffValue="";
	   triggerOperationDiffText="";
   }
   
   var oRow = oTableDiff.insertRow(-1);
   var oRowIndex = jQuery("#oTableDiff").find("tr").length;
   if(triggerOperationDiffText=="")triggerOperationDiffText="&nbsp;";

   for (var i =1; i <=7; i++) {   //生成一行中的每一列



      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1)
		  oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkSubWorkflowSetDiff' value='0'>";
      else  if (i==2) oDiv.innerHTML=triggerTypeDiffText+"<input type='hidden' name='triggerTypeDiffValue' value='"+triggerTypeDiffValue+"'><input type='hidden' name='triggerTypeDiffText' value='"+triggerTypeDiffText+"'>";
      else  if (i==3) oDiv.innerHTML=triggerNodeNameDiffText+"<input type='hidden' name='triggerNodeIdDiffValue' value='"+triggerNodeIdDiffValue+"'><input type='hidden' name='triggerNodeNameDiffText' value='"+triggerNodeNameDiffText+"'>";
      else  if (i==4) oDiv.innerHTML=triggerTimeDiffText+"<input type='hidden' name='triggerTimeDiffValue' value='"+triggerTimeDiffValue+"'><input type='hidden' name='triggerTimeDiffText' value='"+triggerTimeDiffText+"'>";
      else  if (i==5) oDiv.innerHTML=triggerOperationDiffText+"<input type='hidden' name='triggerOperationDiffValue' value='"+triggerOperationDiffValue+"'><input type='hidden' name='triggerOperationDiffText' value='"+triggerOperationDiffText+"'>";
      else  if (i==6) oDiv.innerHTML=fieldNameDiffText+"<input type='hidden' name='fieldIdDiffValue' value='"+fieldIdDiffValue+"'><input type='hidden' name='fieldNameDiffText' value='"+fieldNameDiffText+"'>"; 
      else  if (i==7) oDiv.innerHTML="<span id=detailLinkDiffSpan><a href='#'><%=SystemEnv.getHtmlLabelName(19342, user.getLanguage())%></a></span>";
      jQuery(oCell).append(oDiv);
   }
    WorkflowSubwfSetUtil.addWorkflowSubwfSetDiff(mainWorkflowId,triggerNodeIdDiffValue,triggerTypeDiffValue,triggerTimeDiffValue,triggerOperationDiffValue,fieldIdDiffValue,oRowIndex,returnWorkflowTriDiffWfDiffFieldId);
	jQuery("body").jNice();
	reflash();
}

function removeValueDiff(id){
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
			url:"officalwf_operation.jsp",
			type:"post",
			data:{
				workflowSubwfSetId:id,
				operation:"deleteSubWfSetDiff",
				wfid:"<%=mainWorkflowId%>"
			},
			beforeSend:function(xhr){
				try{
					e8showAjaxTips("正在删除数据，请稍候...",true);
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

function returnWorkflowTriDiffWfDiffFieldId(o){

    var oRowIndex=o.split('_')[0];
	var triDiffWfDiffFieldId=o.split('_')[1];

    if(oRowIndex==2){
		$GetEle("chkSubWorkflowSetDiff").value=triDiffWfDiffFieldId;

		$GetEle("detailLinkDiffSpan").innerHTML="<A HREF='#' onClick='goWorkflowTriDiffWfSubWf("+triDiffWfDiffFieldId+")'"+"><%=SystemEnv.getHtmlLabelName(19342, user.getLanguage())%></A>";
    }
    else if(oRowIndex>2){
		document.getElementsByName("chkSubWorkflowSetDiff")[oRowIndex-2].value=triDiffWfDiffFieldId;

		document.getElementsByName("detailLinkDiffSpan")[oRowIndex-2].innerHTML="<A HREF='#' onClick='goWorkflowTriDiffWfSubWf("+triDiffWfDiffFieldId+")'"+"><%=SystemEnv.getHtmlLabelName(19342, user.getLanguage())%></A>";		
	}
}

function goWorkflowTriDiffWfSubWf(triDiffWfDiffFieldId){
	//window.location =  "/workflow/workflow/WorkflowTriDiffWfSubWf.jsp?ajax=1&triDiffWfDiffFieldId="+triDiffWfDiffFieldId;
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelNames("31829",user.getLanguage())%>";
	url="/docs/tabs/DocCommonTab.jsp?dialog=1&_fromURL=65&ajax=1&triDiffWfDiffFieldId="+triDiffWfDiffFieldId+"&mainWorkflowId=<%=mainWorkflowId%>";
	
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.maxiumnable = true;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}

function chkAllClick(obj){
    var chks = document.getElementsByName("chkSubWorkflowSet");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
        if(obj.checked){
        	jQuery(chk).next().addClass("jNiceChecked");
        }else{
        	jQuery(chk).next().removeClass("jNiceChecked");
        }
    }
}

function chkAllDiffClick(obj){
    var chks = document.getElementsByName("chkSubWorkflowSetDiff");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
        if(obj.checked){
        	jQuery(chk).next().addClass("jNiceChecked");
        }else{
        	jQuery(chk).next().removeClass("jNiceChecked");
        }        
    }
}
</script>
</html>
