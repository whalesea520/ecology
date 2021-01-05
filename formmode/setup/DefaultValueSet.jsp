
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ModeLayoutUtil" class="weaver.formmode.setup.ModeLayoutUtil" scope="page" />
<jsp:useBean id="ModeSetUtil" class="weaver.formmode.setup.ModeSetUtil" scope="page" />
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<STYLE TYPE="text/css">
.btn_actionList
{
	BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
} 
</STYLE>
</HEAD>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<body id="preAddInOperateBody">
<%
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int formId=Util.getIntValue(request.getParameter("formId"),0);
if(modeId > 0 && formId == 0){
	RecordSet.executeSql("select formId from modeinfo where id="+modeId);
	if(RecordSet.next()){
		formId = Util.getIntValue(RecordSet.getString("formId"),0);
	}
}
ModeLayoutUtil.setUser(user);
ModeLayoutUtil.setFormId(formId);
Map fieldsmap = ModeLayoutUtil.getFormfields(user.getLanguage(),1);
List detailGroupList = (List)fieldsmap.get("detailGroup");			//明细
List mainfields = (List)fieldsmap.get("mainfields");				//主表字段
List detlfields = (List)fieldsmap.get("detlfields");				//子表字段
Map indexMap = ModeLayoutUtil.getIndexMap();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19206,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(modeId > 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:onSave(),_self} " ;//添加
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteValue(),_self} " ;//删除
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=defaultForm id=defaultForm STYLE="margin-bottom:0" action="ModeOperation.jsp" method="post">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<input type="hidden" name="modeId" id="modeId" value="<%=modeId%>">
<input type="hidden" name="formId" id="formId" value="<%=formId%>">
<input type="hidden" name="operate" id="operate" value="DefaultValue">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
	
<table width=100% class="viewform">
<COLGROUP>
   <COL width="35%">
   <COL width="5%">
   <COL width="60%">
<TR class="Title">
	<TH colSpan=3>
		<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%><!-- 设置 -->
	</TH>
</TR>
<TR class="Spacing" style="height: 1px;"><TD class="Line1" colspan=3 style="padding: 0px;"></TD></TR>

<tr>
	<td><!-- 目标字段 -->
		<select class=inputstyle  style="width:100%" name=fieldid id=fieldid title="<%=SystemEnv.getHtmlLabelName(15620,user.getLanguage())%>" 
			onchange="changefieldid(this.value);changeTitle('fieldid', this.value);">
			<option value=0 ><%=SystemEnv.getHtmlLabelName(15620,user.getLanguage())%></option>
			<%
			 for(int i = 0; i < mainfields.size(); i++){
				 Map maps = (Map)mainfields.get(i);
				 String fieldid = (String)maps.get("fieldid");
				 String fieldlabel = (String)maps.get("fieldlabel");
				 String viewtype = (String)maps.get("viewtype");
				 String fieldhtmltype = (String)maps.get("fieldhtmltype");
				 String type = (String)maps.get("type");
				 String fielddbtype=(String)maps.get("fielddbtype");
				 String optionValue = viewtype+"_"+fieldid+"_"+fieldhtmltype+"_"+type+"_-1"+"#"+fielddbtype;
			 %>
			 	<option value="<%=optionValue%>" nodeType="<%=fieldlabel%>"><%=fieldlabel%></option>
			 <%
			 }
			 for(int j=0; j<detlfields.size(); j++){
				 Map mapdtl = (Map)detlfields.get(j);
				 String fieldid = (String)mapdtl.get("fieldid");
				 String fieldlabel = (String)mapdtl.get("fieldlabel");
				 fieldlabel += "(" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + ")";
				 
				 String viewtype = (String)mapdtl.get("viewtype");
				 String fieldhtmltype = (String)mapdtl.get("fieldhtmltype");
				 String type = (String)mapdtl.get("type");
				 String fielddbtype=(String)mapdtl.get("fielddbtype");
				 
				 String optionValue = viewtype+"_"+fieldid+"_"+fieldhtmltype+"_"+type+"_-1"+"#"+fielddbtype;
			 %>
				<option value="<%=optionValue%>" nodeType="<%=fieldlabel%>"><%=fieldlabel%></option>
			 <%
			 }
			 %>
		</select>
	</td>
	<td align=center>
		<img src="/images/ArrowEqual_wev8.gif" border=0>
	</td>
	<td>
		<input class=inputstyle type=text name=customerValue id =customerValue size=8 style="display:''">
		<BUTTON type='button' class=Browser onclick="showPreDBrowser(urls[curIndex],curIndex)" id = fieldBrowser style="display:none"></BUTTON>
		<span id="unitspan"></span>
	</td>
</tr>
</table>

<br>
<table width=100% class=liststyle cellspacing=1  >
<COLGROUP>
   <COL width="10%">
   <COL width="90%">
	<TR class="Header">
		<TH colSpan=2><%=SystemEnv.getHtmlLabelName(15635,user.getLanguage())%></TH></TR><!-- 运算法则 -->
 	<TR class=header>
 		<th></th>
    	<TH><%=SystemEnv.getHtmlLabelName(15636,user.getLanguage())%></TH><!-- 表达式 -->
	</TR>
 	<tr class="Line"><th colspan="2"></th></tr>
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
	String expression = "";
	if(fieldhtmltype==3&&type!=19 && type!=2&&type!=162&&type!=161&&type!=141){
		String[] tempArray = Util.TokenizerString2(customervalue,",");
    	for(int j=0;j<tempArray.length;j++){
    		String bsql = "select "+columname+" from "+tablename+" where "+keycolumname+" = '"+tempArray[j]+"'";
            RecordSet.executeSql(bsql);
            while(RecordSet.next()){
            	expression += ","+RecordSet.getString(1);
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
		expression = expression.substring(1);
    }else if(fieldhtmltype==3&&type==141){
        expression =  ResourceConditionManager.getFormShowName(customervalue,user.getLanguage());
    }else{
        expression =  customervalue ;
    }
%>
	<tr>
		<td><input type='checkbox' name='check_mode' value="<%=id%>" ></td>
		<td><%=SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlabel,0),user.getLanguage())%> = <%=expression %></td>
	</tr>
<%}%>
</TABLE>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
</table>
</FORM>
</body>
</html>

<script type="text/javascript">

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
	$("#customerValue").attr("style","display=''");
	if((objvalue!="0") && objvalue.indexOf("_3_")!=-1 && (objvalue.indexOf("_3_19")==-1 || objvalue.indexOf("_3_194")!=-1) && objvalue.indexOf("_1_3")==-1){
        temp = objvalue.substring(0,objvalue.lastIndexOf("_"));
        curIndex = (temp.substring(temp.lastIndexOf("_")+1,temp.length))*1;
        tempbrowsertype=fielddbtype;
        
        $("#fieldBrowser").attr("style","display=''");
		$("#customerValue").attr("style","display='none'");
    }else{
        $("#fieldBrowser").attr("style","display='none'");
    }
}
function showPreDBrowser(url,objtype){
   if(objtype == 2 || objtype == 19){
    WdatePicker({el:'unitspan',onpicked:function(dp){
			$dp.$('customerValue').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('customerValue').value = ''}});
   }else{
     if(objtype=="161"||objtype=="162")
		url = url + "?type="+tempbrowsertype;
	 if(objtype=="141"){
	 	onShowResourceConditionBrowser();
	 }else{
     	onShowBrowser(url,objtype);
	 }
   }
}


function onShowBrowser(url,objtype){
	if (objtype!="161" && objtype!="162") {
		url= url+"?selectedids="+$G("customerValue").value;
	}
    if (objtype==165 || objtype==166 || objtype==167 || objtype==168) {
        temp=escape("&fieldid="+curfieldid+"&isdetail="+curisdetail);
        myid = window.showModalDialog(url+temp);
        if (myid) {
            if (wuiUtil.getJsonValueByIndex(myid,0) != ""){
                unitspan.innerHTML = wuiUtil.getJsonValueByIndex(myid,1);
                if (wuiUtil.getJsonValueByIndex(myid,1).substr(0,1)==",") {
                    $G("customerValue").value =wuiUtil.getJsonValueByIndex(myid,0).substr(1);
                    unitspan.innerHTML =wuiUtil.getJsonValueByIndex(myid,1).substr(1);
                }else{
                    $G("customerValue").value =wuiUtil.getJsonValueByIndex(myid,0);
                    unitspan.innerHTML = wuiUtil.getJsonValueByIndex(myid,1);
                }
            }else{
                unitspan.innerHTML = ""
                $G("customerValue").value = ""
            }
        }
    }else{
        myid = window.showModalDialog(url);
        if (myid) {
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
                unitspan.innerHTML = ""
                $G("customerValue").value = ""
            }
        }
    }
}

function onShowResourceConditionBrowser() {
	var tempIds = $G("customerValue").value;
	var dialogId = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceConditionBrowser.jsp?resourceCondition=" + tempIds);
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
							+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";//的部门成员
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