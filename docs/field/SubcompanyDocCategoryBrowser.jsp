
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.workflow.field.SubcompanyDocCategoryUtil" %>

<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubcompanyDocCategoryManager" class="weaver.workflow.field.SubcompanyDocCategoryManager" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19207,user.getLanguage());
String needfav ="1";
String needhelp ="";
 
%>

<%
if(!HrmUserVarify.checkUserRight("FieldManage:All", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

int fieldId = Util.getIntValue(request.getParameter("fieldId"),0);
int isBill = Util.getIntValue(request.getParameter("isBill"),0);
int selectValue = Util.getIntValue(request.getParameter("selectValue"),-1);

String companyIcon = "/images/treeimages/global_wev8.gif";
String docPath = SubcompanyDocCategoryUtil.getDocPath(fieldId,isBill,selectValue,0,"0");
%>

<HTML>
<HEAD>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
<link type="text/css" rel="stylesheet" href="/js/xloadtree/xtree_wev8.css">
<style>
TABLE.Shadow A {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:hover {
	COLOR: #333; TEXT-DECORATION: none
}

TABLE.Shadow A:link {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:visited {
	TEXT-DECORATION: none
}
</style>
<script type="text/javascript" src="/js/xloadtree/xtree4SubcompanyDocCategory_wev8.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree4SubcompanyDocCategory_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>

<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("22878,92",user.getLanguage())%>");
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

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" onclick="onClose()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'2','cws':'50%,50%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(25332,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19360,user.getLanguage())%></wea:item>
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
	var tree = new WebFXTree('<%=CompanyComInfo.getCompanyname("1")%>','0|0|<%=docPath%>','','<%=companyIcon%>','<%=companyIcon%>');
	<%out.println(SubcompanyDocCategoryManager.getSubCompanyTreeJSByComp(fieldId,isBill,selectValue));%>
	document.write(tree);
	//rti.expand();
	</script>
		</wea:item>
	</wea:group>
</wea:layout>

<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0px!important;">
<div style="padding:5px 0px;">
<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
		<wea:item type="toolbar">
	        <input type="button" class=zd_btn_cancle accessKey=T  id=btncancel onclick="onClose()" value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
</div>
</body>
</html>


<script type="text/javascript">

function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.close();
		}
	}
function onShowCatalog(flowType,obj){
	if(flowType=="0"){
		var result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
	}else if(flowType=="1"){
		var result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
	}
	if(result==null) return false;
	
	var vary0 = wuiUtil.getJsonValueByIndex(result, 0);
	var vary1 = wuiUtil.getJsonValueByIndex(result, 1);
	var vary2 = wuiUtil.getJsonValueByIndex(result, 2);
	var vary3 = wuiUtil.getJsonValueByIndex(result, 3);
	var vary4 = wuiUtil.getJsonValueByIndex(result, 4);
	
	var docPath=vary2;
	var docCategory=vary3+","+vary4+","+vary1;

	if(typeof(vary2)=="undefined"){
		docPath="";
	}
	if(typeof(vary3)=="undefined"){
		docCategory="";
	}
	var arrayObj = obj.split("|");
	if(arrayObj[1]=="3"){
		location.href = "SubcompanyDocCategoryOperation.jsp?fieldId=<%=fieldId%>&isBill=<%=isBill%>&selectValue=<%=selectValue%>&syc=y&flowType="+flowType+"&objId="+arrayObj[0]+"&objType="+arrayObj[1]+"&docCategory="+docCategory+"&docPath="+docPath;
	}else{
		//if(confirm("<%=SystemEnv.getHtmlLabelName(18260,user.getLanguage())%>?")){
		//	location.href = "SubcompanyDocCategoryOperation.jsp?fieldId=<%=fieldId%>&isBill=<%=isBill%>&selectValue=<%=selectValue%>&syc=y&flowType="+flowType+"&objId="+arrayObj[0]+"&objType="+arrayObj[1]+"&docCategory="+docCategory+"&docPath="+docPath;
		//}else{
		//	location.href = "SubcompanyDocCategoryOperation.jsp?fieldId=<%=fieldId%>&isBill=<%=isBill%>&selectValue=<%=selectValue%>&syc=n&flowType="+flowType+"&objId="+arrayObj[0]+"&objType="+arrayObj[1]+"&docCategory="+docCategory+"&docPath="+docPath;
		//}
		var strurl = "SubcompanyDocCategoryOperation.jsp?fieldId=<%=fieldId%>&isBill=<%=isBill%>&selectValue=<%=selectValue%>&syc=n&flowType="+flowType+"&objId="+arrayObj[0]+"&objType="+arrayObj[1]+"&docCategory="+docCategory+"&docPath="+docPath;
		if(confirm("<%=SystemEnv.getHtmlLabelName(18260,user.getLanguage())%>?")){
			strurl = "SubcompanyDocCategoryOperation.jsp?fieldId=<%=fieldId%>&isBill=<%=isBill%>&selectValue=<%=selectValue%>&syc=y&flowType="+flowType+"&objId="+arrayObj[0]+"&objType="+arrayObj[1]+"&docCategory="+docCategory+"&docPath="+docPath;
		}
		location.href = strurl;
	}
}

</script>