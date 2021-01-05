
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="weaver.formmode.interfaces.ModeManageMenu" %>
<%@page import="weaver.formmode.view.ResolveFormMode"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResolveFormMode" class="weaver.formmode.view.ResolveFormMode" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />

<%
if(true){
	int layoutid = Util.getIntValue(request.getParameter("layoutid"),0);
	request.getRequestDispatcher("/formmode/view/AddFormModeIframe.jsp?isPreview=1&layoutid="+layoutid).forward(request, response);
	return;
}
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
int type = Util.getIntValue(request.getParameter("type"),0);
int billid = Util.getIntValue(request.getParameter("billid"),0);
String editData = Util.null2String(request.getParameter("editData"));//不为空表示来自新建或编辑，允许出现编辑按钮
int isfromTab = Util.getIntValue(request.getParameter("isfromTab"),0);
int fromSave = Util.getIntValue(request.getParameter("fromSave"),0);
String iscreate = Util.null2String(request.getParameter("iscreate"));

ModeRightInfo.setModeId(modeId);
ModeRightInfo.setType(type);
ModeRightInfo.setUser(user);
boolean isRight = false;
boolean isEdit = false;		//是否有编辑权限，主要针对右键按钮是否显示
boolean isDel = false;		//是否有删除权限，主要针对右键按钮是否显示
ModeShareManager.setModeId(modeId);

boolean haveTab = false;//需要多tab页
String sql = "";

HashMap parentTabValueMap = new HashMap();
if(formId!=0){
	sql = "select id,fieldname from workflow_billfield where viewtype=0 and billid = " + formId;
	rs.executeSql(sql);
	while(rs.next()){
		String id = Util.null2String(rs.getString("id"));
		String fieldid = "field"+id;
		String fieldname = Util.null2String(rs.getString("fieldname"));
		String fieldvalue = Util.null2String(request.getParameter("field"+id));
		if(!fieldvalue.equals("")){
			
			parentTabValueMap.put(id,fieldvalue);
		}
	}
}


String custompage = "";
String modename = "";
String isImportDetail = "";
if(modeId > 0 ){
	rs.executeSql("select * from modeinfo where id="+modeId);
	if(rs.next()){
		if(type==1){
			isImportDetail = Util.null2String(rs.getString("isImportDetail"));
		}
		modename = Util.null2String(rs.getString("modename"));
		custompage = Util.null2String(rs.getString("custompage"));
	}
}
String titles = "";
String status = "";
switch(type){
	case 1:
		status = SystemEnv.getHtmlLabelName(82,user.getLanguage());//新建
		break;
	case 2:
		status = SystemEnv.getHtmlLabelName(93,user.getLanguage());//编辑
		break;
	case 3:
		status = SystemEnv.getHtmlLabelName(665,user.getLanguage());//监控
		break;
}
if (!status.equals("")) {
	titles = modename +": "+status;
} else {
	titles = modename;
	status = SystemEnv.getHtmlLabelName(89,user.getLanguage());//显示
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = titles;
String needfav ="";
String needhelp ="";

String src = type == 1?"submit":"save";
%>
<html>
<head>
<meta>
<title><%=modename %></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/formmode/js/AddMode_wev8.js"></script>
<SCRIPT language="javascript" src="/workflow/request/js/requesthtml_wev8.js"></script>
<!--<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>-->
<!--<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>-->
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorFormmode_wev8.js"></script>

<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type="text/javascript" language="javascript" src="/formmode/js/jquery_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="" name=frmmain id=frmmain>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
 <tr>
  <td height="10" colspan="3"></td>
 </tr>
 <tr>
  <td></td>
   <td valign="top">
	<TABLE class=Shadow>
	 <tr>
	 <td valign="top">
<%
ResolveFormMode.setRequest(request);
ResolveFormMode.setUser(user);
ResolveFormMode.setIscreate(type);
ResolveFormMode.setRelateFieldMap(parentTabValueMap);
Hashtable ret_hs = ResolveFormMode.analyzeLayout();
String hasHtmlMode = (String)ret_hs.get("hasHtmlMode");
if(hasHtmlMode.equals("0")){
%>
<script type="text/javascript">
alert("<%=SystemEnv.getHtmlLabelName(15808,user.getLanguage())%><%=(modename+" "+status)%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%>");//未设置模板！
</script>
<%
}
String formhtml = Util.null2String((String)ret_hs.get("formhtml"));
out.print(formhtml);

StringBuffer jsStr = ResolveFormMode.getJsStr();
StringBuffer htmlHiddenElementsb = ResolveFormMode.getHtmlHiddenElementsb();
out.println(htmlHiddenElementsb.toString());//把hidden的input输出到页面上

String needcheck = ResolveFormMode.getNeedcheck();

int detailsum=0;
%>
<input type=hidden name ="needcheck" id="needcheck" value="<%=needcheck%>">
<input type=hidden name=src id="src" value="<%=src %>">
<input type=hidden name=formid id="formid" value="<%=formId %>">
<input type=hidden name=iscreate id="iscreate" value="<%=type%>">
<input type=hidden name=formmodeid id="formmodeid" value="<%=modeId%>">
<input type=hidden name=billid id="billid" value="<%=billid%>">
<input type=hidden name ="inputcheck" id="inputcheck" value="">
<input type=hidden name=fromImportDetail id="fromImportDetail" value="0">
<input type=hidden name="pageexpandid" id="pageexpandid" value="">

<input type=hidden name=isfromTab id="isfromTab" value="<%=isfromTab%>">

<iframe id="selectChangeDetail" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputformdetail" frameborder=0 scrolling=no src=""  style="display:none" ></iframe>

<!-- 自定义页面 -->
<%
	if(!custompage.equals("")){
%>
		<jsp:include page="<%=custompage%>" flush="true">
			<jsp:param name="type" value="<%=type%>" />
			<jsp:param name="formmodeid" value="<%=modeId%>" />
			<jsp:param name="billid" value="<%=billid%>" />
			<jsp:param name="formid" value="<%=formId%>" />
		</jsp:include>
<%		
	}
%>

	  </td>
  	 </tr>
  	</TABLE>
   </td>
   <td></td>
  </tr>
 </table>
</tr>
</table>
</form>
<script type="text/javascript">
function initFieldValue(fieldid){

}
<%
out.println(jsStr.toString());
%>
function doSqlFieldAjax(obj,fieldids){

}
function doFieldAjax(thisfieldid,fieldidtmp,fieldExt){

}

function doFieldDateAjax(para, fieldidtmp, fieldExt){

}

function doCustomFunction(detailid,issystemflag){

}

function windowOpenOnSelf(detailid,issystemflag){
   
}
//执行接口动作
function doInterfacesAction(detailid,issystemflag){

}

function windowOpenOnNew(detailid,issystemflag){

}

function toDel(detailid,issystemflag){

}
function toEdit(detailid,issystemflag){

}
function doBack(){

}
function doShare(){

}
function doImportDetail() {

}

function returnTrue(o){
	return;
}

function addDocReadTag(docId) {
	
}

function openAccessory(fileId){ 
	
}

function openDocExt(showid,versionid,docImagefileid,isedit){
	
}

function changeChildField(obj, fieldid, childfieldid){

}

function changeChildFieldDetail(obj, fieldid, childfieldid, rownum){

}

function doInitChildSelect(fieldid,pFieldid,finalvalue){

}
function doInitDetailchildSelect(fieldid,pFieldid,rownum,childvalue){

}
function doInitDetailchildSelectAdd(fieldid,pFieldid,rownum,childvalue){

}
function checkModeNumFun() {//必须新增明细

}
/*	
 *	用来给用户自定义检查数据，在流程提交或者保存的时候执行该函数，
 *	如果检查通过返回true，否则返回false
 *	用户在使用html模板的时候，通过重写这个方法，来达到检查特殊数据的需求
 */
function checkCustomize(){

}

function doSubmit(detailid,issystemflag){

}
function onShowBrowser3(id,url,linkurl,type1,ismand) {

}
function onShowBrowser2(id,url,linkurl,type1,ismand, funFlag) {

}
//联动属性
function changeshowattr(fieldid,fieldvalue,rownum,workflowid,nodeid){

}

//设置为只读
function setReadOnly(obj){

}
//设置为只读
function setCanEdit(obj){

}

function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {

}

function onShowResourceConditionBrowser(id, url, linkurl, type1, ismand) {

}

function doTriggerInit(){

}
function datainput(parfield){				//字段联动-主字段

}

function datainputd(parfield){				//明细

}

function hideRightClickMenu1(){	

}
function getNumber(index){

}

function onChangeSharetype(delspan,delid,ismand,Uploadobj){

}
document.body.onclick = hideRightClickMenu1;
</script>
<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>
<script language=javascript src="/js/checkData_wev8.js"></script>

<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
</body>
</html>