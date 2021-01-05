<%@page import="org.json.JSONObject"%>
<%@page import="weaver.fna.budget.BudgetYear"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("CostStandardProcedure:edit", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>

<!-- 自定义设置tab页 -->
<%
int id = Util.getIntValue(request.getParameter("id"));
int tabId = Util.getIntValue(request.getParameter("tabId"), 0);
String thisGuid = Util.null2String(request.getParameter("thisGuid"));

String tabId1Class = "";
String tabId2Class = "";
String tabId3Class = "";
String tabId4Class = "";



String sql = "";
int formid = 0;
RecordSet rs = new RecordSet();
sql = "select b.formid from fnaFeeWfInfoCostStandard a join workflow_base b on a.workflowid = b.id where a.id = " + id;
rs.executeSql(sql);
if(rs.next()){
	formid = Util.getIntValue(rs.getString("formid"), 0);
}

int hasMainTable = 0;
List<String> tabIndexList = new ArrayList<String>();
sql = "select detailtable from workflow_billfield where billid="+formid+" group by detailtable order by detailtable";
rs.executeSql(sql);
while(rs.next()){
	String detailtable = Util.null2String(rs.getString("detailtable"));
	if("".equals(detailtable)){
		hasMainTable = 1;
	}else{
		String dtNumber = detailtable.replaceAll("formtable_main_"+Math.abs(formid)+"_dt", "");
		tabIndexList.add(dtNumber);
	}
}

String FnaWfSetEditPageFieldSetUrl = "/fna/costStandard/wfset/costStandardWfSetEditPageFieldSet.jsp?thisGuid="+thisGuid+"&id="+id;

String ysxxUrl = "";
if(hasMainTable == 1){
	ysxxUrl = FnaWfSetEditPageFieldSetUrl + "&tabIndex=0";
}else if(hasMainTable == 0){
	if(tabIndexList.size() > 0){
		ysxxUrl = FnaWfSetEditPageFieldSetUrl + "&tabIndex="+tabIndexList.get(0);
	}else{
		ysxxUrl = FnaWfSetEditPageFieldSetUrl;
	}
	
	if(tabId == 0){
		if(tabIndexList.size() > 0){
			tabId = Util.getIntValue(tabIndexList.get(0));
		}
	}
}

%>
</head>			        
<BODY>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="generateFieldPropertySQL();" 
		    			value="<%=SystemEnv.getHtmlLabelName(132224,user.getLanguage())%>"/><!-- 生成字段属性SQL  -->
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doSaveIframe(false);" 
		    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
	<div class="e8_box demo2">
		<div class="">
				<div>
					<ul class="tab_menu" style="margin-top:-10px;">
					<%
						if(hasMainTable == 1){
							tabIndexList.add(0, "0");
						}
					
						for(int i = 0; i < tabIndexList.size(); i++){
							int tabIndex = Util.getIntValue(tabIndexList.get(i), 0);
					%>
							<li class="<%=(tabId==tabIndex)?"current" : "" %>">
					        	<a id="tabId<%=tabIndex %>" href="<%=FnaWfSetEditPageFieldSetUrl+"&tabIndex="+tabIndex %>" onclick="doSave();" target="tabcontentframe2">
					        		<%=(tabIndex==0)?SystemEnv.getHtmlLabelNames("21778",user.getLanguage()):SystemEnv.getHtmlLabelNames("19325",user.getLanguage())+(tabIndex) %>
					        	</a>
					        </li>
					<%
							
						}
						
					%>
				    </ul>
				</div>
		</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=ysxxUrl %>" onload="update();" id="tabcontentframe2" name="tabcontentframe2" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>
<script type="text/javascript">
function generateFieldPropertySQL(){
	var key_generateFieldPropertySQL_full = null2String(jQuery(window.frames["tabcontentframe2"].document).find("#key_generateFieldPropertySQL_full").val());
	if(key_generateFieldPropertySQL_full!=null&&key_generateFieldPropertySQL_full!=""){
		var _w = 780;
		var _h = 450;
		//生成字段属性SQL
		_fnaOpenDialog("/fna/costStandard/wfset/costStandardWfFieldSql.jsp?key_generateFieldPropertySQL_full="+key_generateFieldPropertySQL_full, 
				"<%=SystemEnv.getHtmlLabelName(132224, user.getLanguage())%>", 
				_w, _h);
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(132238, user.getLanguage())%>");//请先保存费用标准维度字段对应关系！
	}
}
function doSaveIframe(){
	doSave1(true);
}
function doSave(){
	doSave1(false);
}
function doSave1(saveDbFlag){
	var mainId = null2String(jQuery(window.frames["tabcontentframe2"].document).find("#mainId").val());
	var workflowid = null2String(jQuery(window.frames["tabcontentframe2"].document).find("#workflowid").val());
	var formid = null2String(jQuery(window.frames["tabcontentframe2"].document).find("#formid").val());
	var csAmount = null2String(jQuery(window.frames["tabcontentframe2"].document).find("#csAmount").val());
	var costStandardC = null2String(jQuery(window.frames["tabcontentframe2"].document).find("#costStandardC").val());
	
	//var tabIndex = jQuery("li.current").find("a").attr("id").replace("tabId","");
	var tabIndex = null2String(jQuery(window.frames["tabcontentframe2"].document).find("#tabIndex").val());
	
	var _postStr = "&thisGuid=<%=thisGuid%>&mainId="+mainId+"&workflowid="+workflowid+"&formid="+formid+
		"&csAmount="+csAmount+"&costStandardC="+costStandardC+"&tabIndex="+tabIndex;
		
	var selectObjsArray1 = jQuery(window.frames["tabcontentframe2"].document).find("select[id^='s_']");
	for(var i=0;i<selectObjsArray1.length;i++){
		var _obj = jQuery(selectObjsArray1[i]);
		var _objId = _obj.attr("id");
		if(_objId!=""){
			_postStr += "&"+_objId+"="+_obj.val();
		}
	}

	var selectObjsArray2 = jQuery(window.frames["tabcontentframe2"].document).find("select[id^='vSel_']");
	for(var i=0;i<selectObjsArray2.length;i++){
		var _obj = jQuery(selectObjsArray2[i]);
		var _objId = _obj.attr("id");
		if(_objId!=""){
			_postStr += "&"+_objId+"="+_obj.val();
		}
	}

	var inputObjsArray = jQuery(window.frames["tabcontentframe2"].document).find("input[id^='vIpt_']");
	for(var i=0;i<inputObjsArray.length;i++){
		var _obj = jQuery(inputObjsArray[i]);
		var _objId = _obj.attr("id");
		if(_objId!=""){
			_postStr += "&"+_objId+"="+_obj.val();
		}
	}

	var inputObjsArray3 = jQuery(window.frames["tabcontentframe2"].document).find("select[id^='vWfSys_']");
	for(var i=0;i<inputObjsArray3.length;i++){
		var _obj = jQuery(inputObjsArray3[i]);
		var _objId = _obj.attr("id");
		if(_objId!=""){
			_postStr += "&"+_objId+"="+_obj.val();
		}
	}
	
	jQuery.ajax({
		url : "/fna/costStandard/wfset/costStandardWfSetEditSaveFnaAjax.jsp",
		type : "post",
		cache : false,
		processData : false,
		async:false,
		data : "postStr="+_postStr,
		dataType : "html",
		success: function do4Success(_json){
			if(saveDbFlag){
				window.frames["tabcontentframe2"].doSave2();
			}
		}
	});
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

jQuery('.e8_box').Tabs({
	getLine:1,
	iframe:"tabcontentframe2",
    mouldID:"<%=MouldIDConst.getID("fna") %>",
    objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(125597, user.getLanguage())) %>,
	staticOnLoad:true
});
</script>
</body>
</html>

