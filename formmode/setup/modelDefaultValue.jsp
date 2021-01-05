
<%@page import="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo"%>
<%@page import="weaver.hrm.companyvirtual.DepartmentVirtualComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@page import="weaver.formmode.tree.CustomTreeData"%>
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.formmode.service.ModelInfoService"%>
<%@page import="weaver.formmode.tree.CustomTreeUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ModeLayoutUtil" class="weaver.formmode.setup.ModeLayoutUtil" scope="page" />
<jsp:useBean id="ModeSetUtil" class="weaver.formmode.setup.ModeSetUtil" scope="page" />
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<body id="preAddInOperateBody">
<%
ModelInfoService modelInfoService = new ModelInfoService();
int modeId = Util.getIntValue(request.getParameter("id"),0);
if(modeId<=0){
	modeId = Util.getIntValue(request.getParameter("modeId"),0);
}
int formId=Util.getIntValue(request.getParameter("formId"),0);
if(modeId > 0 && formId == 0){
		formId = modelInfoService.getFormInfoIdByModelId(modeId); 
}
ModeLayoutUtil.setUser(user);
ModeLayoutUtil.setFormId(formId);
Map fieldsmap = ModeLayoutUtil.getFormfields(user.getLanguage(),1);
List detailGroupList = (List)fieldsmap.get("detailGroup");			//明细
List mainfields = (List)fieldsmap.get("mainfields");				//主表字段
List detlfields = (List)fieldsmap.get("detlfields");				//子表字段
Map detailMap = new HashMap();
String detailSql = "select * from Workflow_billdetailtable where billid='"+formId+"' order by orderid";
recordSet.executeSql(detailSql);
int dindex = 0;
while(recordSet.next()){
	dindex++;
	String tablename = recordSet.getString("tablename");
	String title = "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+dindex+")";
	detailMap.put(tablename,title);
}

Map indexMap = ModeLayoutUtil.getIndexMap();

String subCompanyIdsql = "select subCompanyId from modeinfo where id="+modeId;
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19206,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(modeId > 0){
	if(operatelevel>0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:onSave(),_self} " ;//添加
		RCMenuHeight += RCMenuHeightStep;
	}
	if(operatelevel>1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteValue(),_self} " ;//删除
		RCMenuHeight += RCMenuHeightStep;
	}
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=defaultForm id=defaultForm STYLE="margin-bottom:0" action="ModeOperation.jsp" method="post">
<input type="hidden" name="modeId" id="modeId" value="<%=modeId%>">
<input type="hidden" name="formId" id="formId" value="<%=formId%>">
<input type="hidden" name="operate" id="operate" value="DefaultValue">
	
<table class="e8_tblForm">
<tr>
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(82193,user.getLanguage())%><!-- 默认值设置 --></td>
	<td class="e8_tblForm_field"><!-- 目标字段 -->
		<select class=inputstyle  style="" name=fieldid id=fieldid title="<%=SystemEnv.getHtmlLabelName(15620,user.getLanguage())%>" 
			onchange="changefieldid(this.value);changeTitle('fieldid', this.value);">
			<option value=0 ><%=SystemEnv.getHtmlLabelName(15620,user.getLanguage())%></option>
			<%
			 for(int i = 0; i < mainfields.size(); i++){
				 Map maps = (Map)mainfields.get(i);
				 String fieldid = (String)maps.get("fieldid");
				 String fieldlabel = (String)maps.get("fieldlabel");
				 String viewtype = (String)maps.get("viewtype");
				 String fieldhtmltype = (String)maps.get("fieldhtmltype");
				 if("6".equals(fieldhtmltype)){
				 	continue;
				 }
				 String type = (String)maps.get("type");
				 String fielddbtype=(String)maps.get("fielddbtype");
				 String optionValue = viewtype+"_"+fieldid+"_"+fieldhtmltype+"_"+type+"_-1"+"#"+fielddbtype;
			 %>
			 	<option value="<%=optionValue%>"><%=fieldlabel%></option>
			 <%
			 }
			 for(int j=0; j<detlfields.size(); j++){
				 
				 Map mapdtl = (Map)detlfields.get(j);
				 String fieldid = (String)mapdtl.get("fieldid");
				 String fieldlabel = (String)mapdtl.get("fieldlabel");
				 String detailtable = (String)mapdtl.get("detailtable");
				 
				 String tablenameStr = "";
				 if(detailMap.containsKey(detailtable)){
					 tablenameStr = detailMap.get(detailtable)+"";
				 }
				 fieldlabel += tablenameStr;//明细
				 
				 String viewtype = (String)mapdtl.get("viewtype");
				 String fieldhtmltype = (String)mapdtl.get("fieldhtmltype");
				 if("6".equals(fieldhtmltype)){
				 	continue;
				 }
				 String type = (String)mapdtl.get("type");
				 String fielddbtype=(String)mapdtl.get("fielddbtype");
				 
				 String optionValue = viewtype+"_"+fieldid+"_"+fieldhtmltype+"_"+type+"_-1"+"#"+fielddbtype;
			 %>
				<option value="<%=optionValue%>"><%=fieldlabel%></option>
			 <%
			 }
			 %>
		</select>
		<img src="/images/ArrowEqual_wev8.gif" border=0>
		<input class=inputstyle type="text" name="customerValue" id ="customerValue" size=8 style="display:''">
		<BUTTON type='button' class="Browser" onclick="showPreDBrowser(urls[curIndex],curIndex)" id ="fieldBrowser" name="fieldBrowser" style="display:none"></BUTTON>
		<BUTTON type='button' class="calendar" onclick="showPreDBrowser(urls[curIndex],curIndex)" id ="dateBrowser" name="dateBrowser" style="display:none"></BUTTON>
		<BUTTON type='button' class="Clock" onclick="showPreDBrowser(urls[curIndex],curIndex)" id ="timeBrowser" name="timeBrowser" style="display:none"></BUTTON>
		<select class=inputstyle  style="display:none" name="selector_default_value" id="selector_default_value"
			onChange="changeDefaultValueSeletor();">
		</select>
		<span id="unitspan"></span>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(15636,user.getLanguage())%></td><!-- 表达式 -->
	<td class="e8_tblForm_field">
		<table>
		<%
		ModeSetUtil.setModeId(modeId);
		ModeSetUtil.setFormId(formId);
		ModeSetUtil.getDefaultValueSet();
		List defualtList = ModeSetUtil.getDefualtList();
		Map defMap = null;
		Map map = null;
		int id = 0;
		int fieldid = 0;
		String customervalue = "";
		int fieldhtmltype = 0;
		int type = 0;
		String tempdbtype = "";
		String fieldlabel = "";
		String tablename = "";
		String columname = "";
		String keycolumname = "";
		String viewtype = "";
		String detailtable = "";
		for(int i=0;i<defualtList.size();i++){
			defMap = (Map)defualtList.get(i);
			id = Util.getIntValue((String)defMap.get("id"),0);
			fieldid = Util.getIntValue((String)defMap.get("fieldid"),0);
			customervalue = Util.null2String((String)defMap.get("customervalue"));
			fieldhtmltype = Util.getIntValue((String)defMap.get("fieldhtmltype"),0);
			type = Util.getIntValue((String)defMap.get("type"),0);
			tempdbtype = Util.null2String((String)defMap.get("fielddbtype"));
			fieldlabel = Util.null2String((String)defMap.get("fieldlabel"));
			tablename = Util.null2String((String)defMap.get("tablename"));
			columname = Util.null2String((String)defMap.get("columname"));
			keycolumname = Util.null2String((String)defMap.get("keycolumname"));
			viewtype = Util.null2String((String)defMap.get("viewtype"));
			detailtable = Util.null2String((String)defMap.get("detailtable"));
			
			String detailTableName = "";
			if(viewtype.equals("1")&&detailMap.containsKey(detailtable)){
				detailTableName = detailMap.get(detailtable)+"";
			}
			String expression = "";
			if(fieldhtmltype==3&&type!=19 && type!=2&&type!=162&&type!=161&&type!=141&&type!=256&&type!=257){
				String[] tempArray = Util.TokenizerString2(customervalue,",");
		    	for(int j=0;j<tempArray.length;j++){
		    		if((type==4||type==57)&&!"".equals(tempArray[j])){
		    			int tempArrayValue = Util.getIntValue(tempArray[j],-999999);
		    			if(tempArrayValue>0){
		    				DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		    				expression += ","+departmentComInfo.getDepartmentname(tempArray[j]);
		    			}else{
		    				DepartmentVirtualComInfo departmentVirtualComInfo = new DepartmentVirtualComInfo();
		    				expression += ","+departmentVirtualComInfo.getDepartmentname(tempArray[j]);
		    			}
		    		}else if((type==164||type==194)&&!"".equals(tempArray[j])){
		    			int tempArrayValue = Util.getIntValue(tempArray[j],-999999);
		    			if(tempArrayValue>0){
		    				expression += ","+SubCompanyComInfo.getSubCompanyname(tempArray[j]);
		    			}else{
		    				SubCompanyVirtualComInfo subCompanyVirtualComInfo = new SubCompanyVirtualComInfo();
		    				expression += ","+subCompanyVirtualComInfo.getSubCompanyname(tempArray[j]);
		    			}
		    		}else{
		    			String bsql = "select "+columname+" from "+tablename+" where "+keycolumname+" = '"+tempArray[j]+"'";
			            RecordSet.executeSql(bsql);
			            while(RecordSet.next()){
			            	expression += ","+RecordSet.getString(1);
			            }
		    		}
		    		
		    	}
		    	if(!expression.equals(""))  expression = expression.substring(1);
			}else if(fieldhtmltype==3&&type==161){
				try{
		            Browser browser=(Browser)StaticObj.getServiceByFullname(tempdbtype, Browser.class);
		            BrowserBean bb=browser.searchById(customervalue);
					String desc=Util.null2String(bb.getDescription());
					String name=Util.null2String(bb.getName());
					expression=name;
				}catch(Exception e){
				}			
			}else if(fieldhtmltype==3&&type==162){
		    	try{
		            Browser browser=(Browser)StaticObj.getServiceByFullname(tempdbtype, Browser.class);
					List l=Util.TokenizerString(customervalue,",");
		            for(int j=0;j<l.size();j++){
					    String curid=(String)l.get(j);
			            BrowserBean bb=browser.searchById(curid);
						String desc=Util.null2String(bb.getDescription());
						String name=Util.null2String(bb.getName());
					    expression+=","+name;
					}
				}catch(Exception e){
				}        		
				if(!expression.equals("")) expression = expression.substring(1);
		    }else if(fieldhtmltype==3&&(type==256||type==257)){//自定义树形单选
		    	CustomTreeUtil customTreeUtil = new CustomTreeUtil();
		    	expression = customTreeUtil.getTreeFieldShowName(customervalue,tempdbtype);
			}else if(fieldhtmltype==3&&type==141){
		        expression =  ResourceConditionManager.getFormShowName(customervalue,user.getLanguage());
		    }else if(fieldhtmltype == 5 && (type == 0 || type == 1 || type == 2)) {	//选择框 
		    	RecordSet.executeSql("select selectvalue,selectname from workflow_SelectItem where fieldid= " + fieldid + " and selectvalue=" + customervalue);
		    	if(RecordSet.next()) {
		    		expression = RecordSet.getString("selectname");
		    	}
		    }else{
		        expression =  customervalue ;
		    }
		%>
			<tr>
				<td height="30"><input type='checkbox' name='check_mode' value="<%=id%>" ></td><!-- 明细 -->
				<td><%=SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlabel,0),user.getLanguage())%><%=viewtype.equals("1")?detailTableName:"" %> = <%=expression %></td>
			</tr>
		<%}%>
		</table>
	</td>
</tr>
</TABLE>

</FORM>
</body>
</html>

<script type="text/javascript" language="javascript">
$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
	if($("#modeId").val()=='0'){
		if(confirm("<%=SystemEnv.getHtmlLabelName(30776,user.getLanguage())%>")){//请先保存基本信息！
			window.parent.document.getElementById('modeBasicTab').click();
		}else{
			$('.inputstyle').attr('disabled','disabled');
		}
	}
})

var urls = new Array();
var curIndex = 0;
<%
    String browserSql = "select * from workflow_browserurl order by id desc";
    String idStr = "";
    String urlStr = "";
    RecordSet.executeSql(browserSql);
    while(RecordSet.next()){
%>
        urls[<%=Util.getIntValue(RecordSet.getString("id"),0)%>] = "<%=RecordSet.getString("browserurl")%>";
<%
    }
%>

function onSave(){
	if($("#fieldid").val()=="0"){
    	alert("<%=SystemEnv.getHtmlLabelName(15642,user.getLanguage())%>!");//目标字段不能为空
    	return;
	}else {
		defaultForm.submit();
  	}
}

function deleteValue(){
	var check_modes = defaultForm.check_mode;
	var isChecked = false;
	if(check_modes==undefined){
		return false;
	}	
	if(check_modes.length==undefined){
		if(check_modes.checked==true){
			isChecked = true;
		}
	}else{
		for(var i=0;i<check_modes.length;i++){
			if(check_modes[i].checked){
				isChecked = true;
				break;
			} 
		}
	}
	if(isChecked){
		defaultForm.operate.value = 'delDefaultValue';
		defaultForm.submit();
	}
}
var curfieldid = "";
var curisdetail = "";
var fielddbtype="";
var tempbrowsertype="";

function changefieldid(objvalue){
	var objvalueArr=objvalue.split("#");
	objvalue=objvalueArr[0];
    fielddbtype=objvalueArr[1];
	var _objvalue = objvalue.substring(0,objvalue.lastIndexOf("_"));
	curisdetail=objvalue.split("_")[0];
    curfieldid=objvalue.split("_")[1];
	try{
		tempbrowsertype = eval("urlvalue._"+_objvalue);
	}catch(e){
		tempbrowsertype = "";
	}
	$("#unitspan").html("");
	$("#customerValue").val("");
	
	$("#selector_default_value").html("");
	$("#selector_default_value").hide();
	
	if(objvalue.indexOf("_3_19_")!=-1||objvalue.indexOf("_3_2_")!=-1){
		temp = objvalue.substring(0,objvalue.lastIndexOf("_"));
        curIndex = (temp.substring(temp.lastIndexOf("_")+1,temp.length))*1;
        tempbrowsertype=fielddbtype;
        $("#fieldBrowser").hide();
        if(objvalue.indexOf("_3_19_")!=-1){
       		$("#dateBrowser").hide();
        	$("#timeBrowser").show();
        }else{
       		$("#dateBrowser").show();
        	$("#timeBrowser").hide();
        }
		$("#customerValue").hide();
	}else if((objvalue!="0") && objvalue.indexOf("_3_")!=-1 && objvalue.indexOf("_1_3")==-1){
        temp = objvalue.substring(0,objvalue.lastIndexOf("_"));
        curIndex = (temp.substring(temp.lastIndexOf("_")+1,temp.length))*1;
        tempbrowsertype=fielddbtype;
        $("#fieldBrowser").show();
        $("#dateBrowser").hide();
        $("#timeBrowser").hide();
		$("#customerValue").hide();
    }else if(objvalue.indexOf("_3_256")!=-1||objvalue.indexOf("_3_257")!=-1){
        temp = objvalue.substring(0,objvalue.lastIndexOf("_"));
        curIndex = (temp.substring(temp.lastIndexOf("_")+1,temp.length))*1;
        tempbrowsertype=fielddbtype;
        $("#fieldBrowser").show();
        $("#dateBrowser").hide();
        $("#timeBrowser").hide();
		$("#customerValue").hide();
    }else if(objvalue.indexOf("_1_2") >= 0) {
    	$("#fieldBrowser").hide();
        $("#dateBrowser").hide();
        $("#timeBrowser").hide();
        $("#customerValue").show();
        $("#customerValue").unbind("blur");
        $("#customerValue").blur(function(){
        	if(!(/^-?\d+$/.test($("#customerValue").val()))){	//整数验证
        		$("#customerValue").val("");
        	}
        });
    }else if(objvalue.indexOf("_1_3") >= 0 || objvalue.indexOf("_1_4") >= 0 || objvalue.indexOf("_1_5") >= 0 ) {
    	$("#fieldBrowser").hide();
        $("#dateBrowser").hide();
        $("#timeBrowser").hide();
        $("#customerValue").show();
        $("#customerValue").unbind("blur");
        $("#customerValue").blur(function(){
        	if(!(/^(-?\d+)(\.\d+)?$/.test($("#customerValue").val()))){		//浮点数验证
        		$("#customerValue").val("");
        	}
        });
    }else if(objvalue.indexOf("_5_0_") >= 0 || objvalue.indexOf("_5_1_") >= 0 || objvalue.indexOf("_5_2_") >= 0 ){	//获取选择框内容
    	$("#fieldBrowser").hide();
        $("#dateBrowser").hide();
        $("#timeBrowser").hide();
        $("#customerValue").hide();
    	$("#selector_default_value option").remove();
    	$.ajax({
    		type: "post",
    		url: "/formmode/setup/SelectorAjaxData.jsp",
    		data: "&fieldid=" + curfieldid,
    		dataType: "text",
    		async: false,
    		success: function(data) {
				var options = $.parseJSON(data).result;
				var htmlContent ="<option></option>";
				for(var i = 0; i < options.length; i++) {
					htmlContent += "<option value='"+ options[i].selectvalue +"'>"+ options[i].selectname +"</option>";
				}
				$("#selector_default_value").html(htmlContent);
    		}
    	});
    	$("#selector_default_value").show();
    }else{
        $("#fieldBrowser").hide();
        $("#dateBrowser").hide();
        $("#timeBrowser").hide();
        $("#customerValue").show();
    }
}

function changeDefaultValueSeletor() {
	$("#customerValue").val($("#selector_default_value").val());
}

function showPreDBrowser(url,objtype){
   if(objtype == 2 ){
    WdatePicker({el:'unitspan',onpicked:function(dp){
			$dp.$('customerValue').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('customerValue').value = ''}});
   }else if(objtype == 19){
		onWorkFlowShowTime("unitspan", "customerValue", 0);
   }else{
     if(objtype=="161"||objtype=="162")
		url = url + "?type="+tempbrowsertype;
     if(objtype=="256"||objtype=="257")
		url = url + "?type="+tempbrowsertype+"_"+objtype;
	 if(objtype=="141"){
	 	onShowResourceConditionBrowser();
	 }else{
     	onShowBrowser(url,objtype);
	 }
   }
}

function onShowBrowserCustomNew(id, url, type1) {
	url+="&iscustom=1";
	if (type1 == 256|| type1==257) {
		tmpids = $GetEle(id).value;
		url = url + "&selectedids=" + tmpids;
	}else{
		tmpids = $GetEle(id).value;
		url = url + "|" + id + "&beanids=" + tmpids;
		url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
	}
	var dialogurl = url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.callbackfun = function (paramobj, myid) {
		if (myid != null) {
            if (wuiUtil.getJsonValueByIndex(myid,0) != "") {
            	var ids = wuiUtil.getJsonValueByIndex(myid,0);
				var names = wuiUtil.getJsonValueByIndex(myid, 1);
				
				if(type1==161){
	            	var href = "";
					if(myid.href&&myid.href!=""){
						href = myid.href+ids;
					}else{
						href = "javascript:void(0);";
					}
					var sHtml = "<a href='"+href+"' target='_blank' title='" + names + "'>" + names + "</a>";
					
                    $G("customerValue").value = ids;
                    unitspan.innerHTML = sHtml;
				}else{
	                if (wuiUtil.getJsonValueByIndex(myid,0).substr(0,1)==",") {
	                    $G("customerValue").value =wuiUtil.getJsonValueByIndex(myid,0).substr(1);
	                    var names = wuiUtil.getJsonValueByIndex(myid,1).substr(1);
	                    names = names.replace(/~~WEAVERSplitFlag~~/g,",")
	                    unitspan.innerHTML =names;
	                }else{
	                    $G("customerValue").value = wuiUtil.getJsonValueByIndex(myid,0);
	                    var names = wuiUtil.getJsonValueByIndex(myid,1);
	                    names = names.replace(/~~WEAVERSplitFlag~~/g,",")
	                    unitspan.innerHTML =names;
	                }
				}
				
            }else{
                unitspan.innerHTML = ""
                $G("customerValue").value = ""
            }
	}
		
	   
	};
	
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
	dialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
		dialog.Width=648; 
	}
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();

}


function onShowBrowser(url,objtype){
	if (objtype=="161" || objtype=="162"||objtype=="256" || objtype=="257") {
		onShowBrowserCustomNew("customerValue", url, objtype);
		return;
	}
	if (objtype!="161" && objtype!="162") {
		url= url+"&selectedids="+$G("customerValue").value;
	}
	if (objtype!="256" && objtype!="257") {
		url= url+"&selectedids="+$G("customerValue").value;
	}
    if (objtype==165 || objtype==166 || objtype==167 || objtype==168) {
        temp=escape("&fieldid="+curfieldid+"&isdetail="+curisdetail);
        url = url + temp;
    }
    
    var dialogurl = url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.callbackfun = function (paramobj, myid) {
		if (myid != null) {
            if (wuiUtil.getJsonValueByIndex(myid,0) != "") {
                unitspan.innerHTML =wuiUtil.getJsonValueByIndex(myid,1);
                if (wuiUtil.getJsonValueByIndex(myid,0).substr(0,1)==",") {
                    $G("customerValue").value =wuiUtil.getJsonValueByIndex(myid,0).substr(1);
                    unitspan.innerHTML =wuiUtil.getJsonValueByIndex(myid,1).substr(1);
                }else{
                    $G("customerValue").value = wuiUtil.getJsonValueByIndex(myid,0);
                    unitspan.innerHTML = wuiUtil.getJsonValueByIndex(myid,1);
                }
            }else{
                unitspan.innerHTML = "";
                $G("customerValue").value = "";
            }
		}
	};
	
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
	dialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){
		dialog.Width=648; 
	}
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();
}

function onShowResourceConditionBrowser() {
	var tmpids = $G("customerValue").value;
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceConditionBrowser.jsp?resourceCondition=" + tmpids;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = url;
	dialog.callbackfun = function (paramobj, dialogId) {
		if (dialogId) {
			if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
				var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
				var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
				var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
				var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
				var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
				var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
				var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
				var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);
	
				var sHtml = "";
				var fileIdValue = "";
				shareTypeValues = shareTypeValues.substr(1);
				shareTypeTexts = shareTypeTexts.substr(1);
				relatedShareIdses = relatedShareIdses.substr(1);
				relatedShareNameses = relatedShareNameses.substr(1);
				rolelevelValues = rolelevelValues.substr(1);
				rolelevelTexts = rolelevelTexts.substr(1);
				secLevelValues = secLevelValues.substr(1);
				secLevelTexts = secLevelTexts.substr(1);
	
				var shareTypeValueArray = shareTypeValues.split("~");
				var shareTypeTextArray = shareTypeTexts.split("~");
				var relatedShareIdseArray = relatedShareIdses.split("~");
				var relatedShareNameseArray = relatedShareNameses.split("~");
				var rolelevelValueArray = rolelevelValues.split("~");
				var rolelevelTextArray = rolelevelTexts.split("~");
				var secLevelValueArray = secLevelValues.split("~");
				var secLevelTextArray = secLevelTexts.split("~");
				for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {
	
					var shareTypeValue = shareTypeValueArray[_i];
					var shareTypeText = shareTypeTextArray[_i];
					var relatedShareIds = relatedShareIdseArray[_i];
					var relatedShareNames = relatedShareNameseArray[_i];
					var rolelevelValue = rolelevelValueArray[_i];
					var rolelevelText = rolelevelTextArray[_i];
					var secLevelValue = secLevelValueArray[_i];
					var secLevelText = secLevelTextArray[_i];
	
					fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
							+ relatedShareIds + "_" + rolelevelValue + "_"
							+ secLevelValue;
	
					if (shareTypeValue == "1") {
						sHtml = sHtml + "," + shareTypeText + "("
								+ relatedShareNames + ")";
					} else if (shareTypeValue == "2") {
						sHtml = sHtml
								+ ","
								+ shareTypeText
								+ "("
								+ relatedShareNames
								+ ")"
								+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="//安全级别
								+ secLevelValue
								+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>";//的分部成员
					} else if (shareTypeValue == "3") {
						sHtml = sHtml
								+ ","
								+ shareTypeText
								+ "("
								+ relatedShareNames
								+ ")"
								+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="//安全级别
								+ secLevelValue
								+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";//的分部成员
					} else if (shareTypeValue == "4") {
						sHtml = sHtml
								+ ","
								+ shareTypeText
								+ "("
								+ relatedShareNames
								+ ")"
								+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>="//共享级别
								+ rolelevelText
								+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="//安全级别
								+ secLevelValue
								+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";//的角色成员
					} else {
						sHtml = sHtml
								+ ","
								+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="//安全级别
								+ secLevelValue
								+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage())%>";//的所有人
					}
	
				}
	
				sHtml = sHtml.substr(1);
				fileIdValue = fileIdValue.substr(1);
				unitspan.innerHTML = sHtml;
				$G("customerValue").value = fileIdValue;
			}else {
				unitspan.innerHTML = "";
				$G("customerValue").value.value = "";
			}
		}
	}; 
	dialog.Title = "请选择";
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.Drag = true;
	//dialog.maxiumnable = true;
	dialog.show();
}

function addRow(){
	var addurl = "/systeminfo/BrowserMain.jsp?url=/workflow/dmlaction/DMLActionSettingAdd.jsp?";
	id = window.showModalDialog(addurl,window,"dialogWidth:1000px;dialogHeight:800px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(800))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(1000))/2 + "px" + ";")
}
function changeTitle(id, title){
	var s = document.getElementById(id);
	var isStr = s.options[s.selectedIndex].innerText;
	s.title = isStr;
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>