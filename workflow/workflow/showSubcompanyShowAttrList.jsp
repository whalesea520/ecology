
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.workflow.workflow.SubcompanyShowAttrUtil" %>

<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubcompanyShowAttrManager" class="weaver.workflow.workflow.SubcompanyShowAttrManager" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
//TD3935
//modified by hubo,2006-03-16
String titlename = SystemEnv.getHtmlLabelName(18043,user.getLanguage());
String needfav ="1";
String needhelp ="";
 
%>

<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
int isBill = Util.getIntValue(request.getParameter("isBill"),0);
int fieldId = Util.getIntValue(request.getParameter("fieldId"),0);
int selectValue = Util.getIntValue(request.getParameter("selectValue"),-1);
String companyIcon = "/images/treeimages/global_wev8.gif";
String objPara = SubcompanyShowAttrUtil.getObjPara(workflowId,formId,isBill,fieldId,selectValue,0,"0");
%>

<HTML>
<HEAD>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
<link type="text/css" rel="stylesheet" href="/js/xloadtree/xtree_wev8.css">
<script type="text/javascript" src="/js/xloadtree/xtree4SubcompanyShowAttr_wev8.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree4SubcompanyShowAttr_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("22878,33405",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
</head>
<body>
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;"><span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'3','cws':'40%,40%,20%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(25332,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19360,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("33197,30747",user.getLanguage())%></wea:item>
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<script type="text/javascript">
				webFXTreeConfig.blankIcon		= "/images/xp_none/blank_wev8.png";
	            webFXTreeConfig.lMinusIcon		= "/images/xp_none/Lminus_wev8.png";
	            webFXTreeConfig.lPlusIcon		= "/images/xp_none/Lplus_wev8.png";
	            webFXTreeConfig.tMinusIcon		= "/images/xp_none/Tminus_wev8.png";
	            webFXTreeConfig.tPlusIcon		= "/images/xp_none/Tplus_wev8.png";
	            webFXTreeConfig.iIcon			= "/images/xp_none/I_wev8.png";
	            webFXTreeConfig.lIcon			= "/images/xp_none/L_wev8.png";
	            webFXTreeConfig.tIcon			= "/images/xp_none/T_wev8.png";
		
			var rti;
			var tree = new WebFXTree('<%=CompanyComInfo.getCompanyname("1")%>','0|0|<%=objPara%>','','<%=companyIcon%>','<%=companyIcon%>');
			<%out.println(SubcompanyShowAttrManager.getSubCompanyTreeJSByComp(workflowId,formId,isBill,fieldId,selectValue));%>
			document.write(tree);
			//rti.expand();
			</script>
		</wea:item>
	</wea:group>
</wea:layout>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</body>
</html>


<script type="text/javascript">

//obj: objId|objType|详细设置信息|文档属性页设置_docPropId_secCategoryId
function onShowAttr(flowType,obj){
	if(flowType=="0"){
		
	}else if(flowType=="1"){

		var workflowId="<%=workflowId%>";
		var selectItemId="<%=selectValue%>";
		var docPropId=0;
		var pathCategory="";
		var secCategoryId=0;

	    var arrayObj = obj.split("|");
		var docProp=arrayObj[3];
	    var arrayDocProp = docProp.split("_");
		docPropId=arrayDocProp[1];
		secCategoryId=arrayDocProp[2];

		if(secCategoryId==0){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129502, user.getLanguage())%>");
			return;
		}

		//url=encode('/workflow/workflow/WorkflowDocPropDetail.jsp?docPropId=' + docPropId + '&workflowId=' + workflowId+ '&selectItemId=' + selectItemId + '&pathCategory=' + pathCategory + '&secCategoryId=' + secCategoryId+"&objId="+arrayObj[0]+"&objType="+arrayObj[1]);

		//var con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
		mouldDialog = new top.Dialog();
		mouldDialog.currentWindow = window;
		mouldDialog.URL="/docs/tabs/DocCommonTab.jsp?selectItemId="+selectItemId+"&isWorkflowDoc=1&_fromURL=53&isdialog=1&docPropId="+docPropId+"&type=1&workflowId="+workflowId+"&secCategoryId="+secCategoryId+"&objId="+arrayObj[0]+"&objType="+arrayObj[1];
		mouldDialog.Title = "<%=SystemEnv.getHtmlLabelNames("33197,30747",user.getLanguage())%>";
		mouldDialog.Width = 600;
		mouldDialog.Height = 500;
		mouldDialog.maxiumnable = true;
		mouldDialog.show();
	}
}

function encode(str){
    return escape(str);
}
</script>
