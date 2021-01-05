
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="weaver.formmode.interfaces.ModeManageMenu" %>
<%@ page import="weaver.formmode.view.ResolveFormMode"%>
<%@ page import="weaver.formmode.datainput.DynamicDataInput"%>
<%@ page import="weaver.formmode.setup.ExpandBaseRightInfo"%>
<jsp:useBean id="expandBaseRightInfo" class="weaver.formmode.setup.ExpandBaseRightInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResolveFormMode" class="weaver.formmode.view.ResolveFormMode" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeViewLog" class="weaver.formmode.view.ModeViewLog" scope="page"/>
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />

<%
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
int type = Util.getIntValue(request.getParameter("type"),0);
int billid = Util.getIntValue(request.getParameter("billid"),0);
String editData = Util.null2String(request.getParameter("editData"));//不为空表示来自新建或编辑，允许出现编辑按钮
int isfromTab = Util.getIntValue(request.getParameter("isfromTab"),0);
int fromSave = Util.getIntValue(request.getParameter("fromSave"),0);
String iscreate = Util.null2String(request.getParameter("iscreate"));

String viewfrom = Util.null2String(request.getParameter("viewfrom"));
int opentype = Util.getIntValue(request.getParameter("opentype"),0);
int customid = Util.getIntValue(request.getParameter("customid"),0);

expandBaseRightInfo.setUser(user);

ModeRightInfo.setModeId(modeId);
ModeRightInfo.setType(type);
ModeRightInfo.setUser(user);
boolean isRight = false;
boolean isEdit = false;		//是否有编辑权限，主要针对右键按钮是否显示
boolean isDel = false;		//是否有删除权限，主要针对右键按钮是否显示
if(type == 1 || type == 3){//新建、监控权限判断
	//isRight = ModeRightInfo.checkUserRight(type);
	FormModeRightInfo.setUser(user);
	isRight = FormModeRightInfo.checkUserRight(customid,4);
	if(!isRight){  //如果自定义查询页面无监控权限，则检查全局监控权限
		ModeRightInfo.setModeId(modeId);
		ModeRightInfo.setType(type);
		ModeRightInfo.setUser(user);
		
		isRight = ModeRightInfo.checkUserRight(type);
	}

}

ModeShareManager.setModeId(modeId);
int MaxShare = 0;
if(type == 0 || type == 2){//查看、编辑权限
	String rightStr = ModeShareManager.getShareDetailTableByUser("formmode",user);
	
	rs.executeSql("select * from "+rightStr+" t where sourceid="+billid);
	if(rs.next()){
		MaxShare = rs.getInt("sharelevel");
		isRight = true;
		if(MaxShare > 1) {
			isEdit = true;		//有编辑或完全控制权限的出现编辑按钮
			if(MaxShare == 3) isDel = true;		//有编辑或者完全控制权限的出现删除按钮
		}
	}
}

boolean haveTab = false;//需要多tab页
String sql = "";
if(modeId>0&&billid>0&&isfromTab!=1){
	sql = "select id,expendname,showtype,opentype,hreftype,hrefid,hreftarget,showorder,issystem from mode_pageexpand where modeid = "+modeId+" and isshow = 1 and showtype = 1 and isbatch in(0,2) order by showorder asc";
	rs.executeSql(sql);
	while(rs.next()){
		String detailid = Util.null2String(rs.getString("id"));
		if(expandBaseRightInfo.checkExpandRight(detailid, Util.null2String(modeId),billid)) {
			continue;
		}
		haveTab = true;
	}
}
if(haveTab){
	String url = "/formmode/view/ViewMode.jsp?"+Util.null2String(request.getQueryString());
	response.sendRedirect(url);
	return;
}
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

//保存操作日志
//只记录查看日志，修改日志在保存的时候记录
if(type == 0){
	String operatetype = "4";//操作的类型： 1：新建 2：修改 3：删除 4：查看
	String clientaddress = request.getRemoteAddr();
	String operatedesc = SystemEnv.getHtmlLabelName(367,user.getLanguage());//查看
	int operateuserid = user.getUID();
	int relatedid = billid;
	String relatedname = "";
	
	ModeViewLog.resetParameter();
	ModeViewLog.setClientaddress(clientaddress);
	ModeViewLog.setModeid(modeId);
	ModeViewLog.setOperatedesc(operatedesc);
	ModeViewLog.setOperatetype(operatetype);
	ModeViewLog.setOperateuserid(operateuserid);
	ModeViewLog.setRelatedid(relatedid);
	ModeViewLog.setRelatedname(relatedname);
	ModeViewLog.setSysLogInfo();
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
<script type="text/javascript" language="javascript" src="/formmode/js/jquery/aop/jquery.aop.min_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/formmode/js/json2_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/formmode/js/FieldPrompt_wev8.js"></script>

<style type="text/css">
td.promptValidateFail{
	background-color: yellow !important;
}
</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//鼠标右键
ModeManageMenu ModeManageMenu = new ModeManageMenu();
ModeManageMenu.setViewfrom(viewfrom);
ModeManageMenu.setOpentype(opentype);
ModeManageMenu.setCustomid(customid);
ModeManageMenu.setBillid(billid);
ModeManageMenu.setDel(isDel);
ModeManageMenu.setEdit(isEdit);
ModeManageMenu.setFormId(formId);
ModeManageMenu.setFromSave(fromSave);
ModeManageMenu.setIscreate(iscreate);
ModeManageMenu.setIsImportDetail(isImportDetail);
ModeManageMenu.setModeId(modeId);
ModeManageMenu.setRCMenuHeightStep(RCMenuHeightStep);
ModeManageMenu.setType(type);
ModeManageMenu.setUser(user);
ModeManageMenu.getMenu();

HashMap urlMap = ModeManageMenu.getUrlMap();
RCMenu += ModeManageMenu.getRCMenu() ;

if(billid > 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:viewLog(),_top} " ;//日志
	RCMenuHeight += RCMenuHeightStep ;
}

RCMenuHeight += ModeManageMenu.getRCMenuHeight() ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="/formmode/data/ModeDataOperation.jsp" name=frmmain id=frmmain method="post">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">

 <tr>
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
alert("<%=SystemEnv.getHtmlLabelName(15808,user.getLanguage())%> <%=(modename+" "+status)%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%>！");//未设置xx模板 
enableAllmenu();
</script>
<%
}
String formhtml = Util.null2String((String)ret_hs.get("formhtml"));
out.print(formhtml);

StringBuffer jsStr = ResolveFormMode.getJsStr();
StringBuffer htmlHiddenElementsb = ResolveFormMode.getHtmlHiddenElementsb();
out.println("<div class='formtablehiddenarea'>"+htmlHiddenElementsb.toString()+"</div>");//把hidden的input输出到页面上

String needcheck = ResolveFormMode.getNeedcheck();

DynamicDataInput ddi = new DynamicDataInput(modeId+"");
ddi.setType(type);
String src = type == 1?"submit":"save";
String trrigerfield = ddi.GetEntryTriggerFieldName();
String trrigerdetailfield = ddi.GetEntryTriggerDetailFieldName();

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

<input type=hidden name=viewfrom id="viewfrom" value="<%=viewfrom%>">
<input type=hidden name=opentype id="opentype" value="<%=opentype%>">
<input type=hidden name=customid id="customid" value="<%=customid%>">
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
			<jsp:param name="url" value="<%=Util.null2String(request.getQueryString())%>" />
		</jsp:include>
<%		
	}
%>

	  </td>
  	 </tr>
  	</TABLE>
   </td>
  </tr>
 </table>
</tr>
</table>
</form>
<script type="text/javascript">
function viewLog(){
	window.open("/formmode/view/ModeLogView.jsp?modeId=<%=modeId%>&relatedId=<%=billid%>&initFlag=1");
	rightMenu.style.visibility = "hidden";
}
<%
Iterator it = urlMap.entrySet().iterator();
while (it.hasNext()) {
	Entry entry = (Entry) it.next();
	String detailid = Util.null2String((String)entry.getKey());
	String hreftarget = Util.null2String((String)entry.getValue());
	hreftarget = hreftarget.replace("\"","\\\"");
	out.println("var url_id_"+detailid + " = \"" +hreftarget+"\";");
}
%>
function initFieldValue(fieldid){
	var fieldid4Sql = fieldid;
	var fieldExt = "";
	if(fieldid.indexOf("_") > -1){
		fieldExt = fieldid.substr(fieldid.indexOf("_"), fieldid.length);
		fieldid4Sql = fieldid.substr(0, fieldid.indexOf("_"));
	}
	var sqlcontent = "";
	try{
		sqlcontent = $G("fieldsql"+fieldid4Sql).value;
		sqlcontent = sqlcontent.replace(/\+/g, "%2B");
		sqlcontent = sqlcontent.replace(/\&/g, "%26");

	}catch(e){}
	var sql = "";
	var index = sqlcontent.indexOf("$");
	while(index > -1){
		try{
			sql += sqlcontent.substr(0, index);
			sqlcontent = sqlcontent.substr(index+1, sqlcontent.length);
			var tailindex = sqlcontent.indexOf("$");
			var sourceFieldid = sqlcontent.substr(0, tailindex);
			var sourceFieldValue = "";
			try{
				if(sourceFieldid.toLowerCase() == "id"){
					sourceFieldValue = "<%=billid%>";
				}else{
					sourceFieldValue = $G("field"+sourceFieldid+fieldExt).value;
				}
			}catch(e){}
			sql += sourceFieldValue;
			sqlcontent = sqlcontent.substr(tailindex+1, sqlcontent.length);
		}catch(e){}
		index = sqlcontent.indexOf("$");
	}
	sql += sqlcontent;
	sql = sql.replace(new RegExp("%","gm"), "%25");
	sql = escape(sql);
	jQuery.ajax({
		url : "/formmode/view/FieldAttrAjax.jsp",
		type : "post",
		processData : false,
		data : "sql="+sql+"&fieldid="+fieldid,
		dataType : "xml",
		success: function do4Success(msg){
			setFieldValueAjax(msg,fieldid,fieldid,true);//其中第2个fieldid，只是用来区分当前字段是主字段还是明细字段，所以在这里用fieldid代替
		}
	});
}
<%
out.println(jsStr.toString());

%>
function doSqlFieldAjax(obj,fieldids){
	
	var thisfieldid = "";
	try{
		if(obj.id.indexOf("field") > -1){//普通字段
			thisfieldid = obj.id.substring(5);
		}
	}catch(e){}
	if(thisfieldid == ""){
		return;
	}
	var fieldExt = "";
	if(thisfieldid.indexOf("_") > -1){
		fieldExt = thisfieldid.substr(thisfieldid.indexOf("_"), thisfieldid.length);
	}
	var fieldidsz = fieldids.split(",");
	for(var i=0; i<fieldidsz.length; i++){
		var fieldidtmp = fieldidsz[i];
		if(fieldidtmp==null || fieldidtmp==""){
			continue;
		}
		doFieldAjax(thisfieldid,fieldidtmp,fieldExt);
	}
}
function doFieldAjax(thisfieldid,fieldidtmp,fieldExt){
	var sql = "";
	var sqlcontent = "";
	try{
		sqlcontent = $G("fieldsql"+fieldidtmp).value;
		sqlcontent = sqlcontent.replace(/\+/g, "%2B");
		sqlcontent = sqlcontent.replace(/\&/g, "%26");
	}catch(e){}
	var index = sqlcontent.indexOf("$");
	while(index > -1){
		try{
			sql += sqlcontent.substr(0, index);
			sqlcontent = sqlcontent.substr(index+1, sqlcontent.length);
			var tailindex = sqlcontent.indexOf("$");
			var sourceFieldid = sqlcontent.substr(0, tailindex);
			var sourceFieldValue = "";
			try{
				if(sourceFieldid.toLowerCase() == "id"){
					sourceFieldValue = "<%=billid%>";
				}else{
					sourceFieldValue = $G("field"+sourceFieldid+fieldExt).value;
				}
			}catch(e){}
			sql += sourceFieldValue;
			sqlcontent = sqlcontent.substr(tailindex+1, sqlcontent.length);
		}catch(e){}
		index = sqlcontent.indexOf("$");
	}
	sql += sqlcontent;
	sql = sql.replace(new RegExp("%","gm"), "%25");
	sql = escape(sql);
	jQuery.ajax({
		url : "/formmode/view/FieldAttrAjax.jsp",
		type : "post",
		processData : false,
		data : "sql="+sql+"&fieldid="+fieldidtmp,
		dataType : "xml",
		success: function do4Success(msg){
			setFieldValueAjax(msg,thisfieldid,fieldidtmp,false);
		}
	});
}

function doFieldDateAjax(para, fieldidtmp, fieldExt){
	var sql = para;
	var thisfieldid = "0"+fieldExt;
	jQuery.ajax({
		url : "/formmode/view/FieldDateAjax.jsp",
		type : "post",
		processData : false,
		data : sql+"&fieldid="+fieldidtmp,
		dataType : "xml",
		success: function do4Success(msg){
			setFieldValueAjax(msg,thisfieldid,fieldidtmp,false);
		}
	});
}

function doCustomFunction(detailid,issystemflag){
	//执行接口动作
    doInterfacesAction(detailid,issystemflag,doCustomFunctionCallBack,detailid);
}

function doCustomFunctionCallBack(detailid){
	eval(eval("url_id_"+detailid));
}

function windowOpenOnSelf(detailid,issystemflag){
	//执行接口动作
    doInterfacesAction(detailid,issystemflag,windowOpenOnSelfCallBack,detailid);   
}

function windowOpenOnSelfCallBack(detailid){
	var url = eval("url_id_"+detailid);
   	if("<%=isfromTab%>"=="1"){
   		window.parent.location.href = url;
	}else{
		window.location.href = url;
	}
}

//执行接口动作
function doInterfacesAction(detailid,issystemflag,callBackFun,param1){
	frmmain.pageexpandid.value = detailid;
	var url = "/formmode/data/ModeDataInterfaceAjax.jsp";
	jQuery.ajax({
		url : url,
		type : "post",
		processData : false,
		data : "pageexpandid="+detailid+"&modeid=<%=modeId%>&formid=<%=formId%>&billid=<%=billid%>",
		dataType : "text",
		async : true,//异步
		success: function do4Success(msg){
			if(typeof(callBackFun)=="function"){//当ajax返回后再执行后续动作
				if(param1){
					callBackFun(param1);
				}else{
		        	callBackFun();
				}
	        }
		}
	});
	if(typeof(callBackFun)!="function"){
		return true;
	}
}

function windowOpenOnNew(detailid,issystemflag){
	//执行接口动作
    doInterfacesAction(detailid,issystemflag,windowOpenOnNewCallBack,detailid);
}

function windowOpenOnNewCallBack(detailid){
	var redirectUrl = eval("url_id_"+detailid);
    var width = screen.availWidth-10 ;
    var height = screen.availHeight-50 ;
    var szFeatures = "top=0," ;
	   	szFeatures +="left=0," ;
    szFeatures +="width="+width+"," ;
    szFeatures +="height="+height+"," ;
    szFeatures +="directories=no," ;
    szFeatures +="status=yes,toolbar=no,location=no," ;
    szFeatures +="menubar=no," ;
    szFeatures +="scrollbars=yes," ;
    szFeatures +="resizable=yes" ; //channelmode
    window.open(redirectUrl,"",szFeatures) ;
}

function toDel(detailid,issystemflag){
	frmmain.pageexpandid.value = detailid;
	if(<%=isDel%>){
		if(isdel()){
			frmmain.src.value="del";
			frmmain.submit();
		}
	}
}
function toEdit(detailid,issystemflag){
	//执行接口动作
    doInterfacesAction(detailid,issystemflag,toEditCallBack);
}

function toEditCallBack(){
	window.location.href = "/formmode/view/AddFormMode.jsp?isfromTab=<%=isfromTab%>&modeId=<%=modeId%>&formId=<%=formId%>&type=2&billid=<%=billid%>&viewfrom=<%=viewfrom%>&opentype=<%=opentype%>&customid=<%=customid%>";
}

function doprint(){

	openFullWindowHaveBar("/formmode/view/FormModePrint.jsp?isfromTab=<%=isfromTab%>&modeId=<%=modeId%>&formId=<%=formId%>&type=4&billid=<%=billid%>&viewfrom=<%=viewfrom%>&opentype=<%=opentype%>&customid=<%=customid%>");
}
function doBack(){
	window.location.href="/formmode/view/AddFormMode.jsp?isfromTab=<%=isfromTab%>&modeId=<%=modeId%>&formId=<%=formId%>&type=0&billid=<%=billid%>&iscreate=<%=iscreate%>&viewfrom=<%=viewfrom%>&opentype=<%=opentype%>&customid=<%=customid%>";
}
function doViewBack(){
	if("<%=viewfrom%>"=="fromsearchlist"&"<%=opentype%>"=="1"&&<%=isfromTab%>=="1"){
		window.parent.location = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=customid%>";
	}else{
		window.location = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=customid%>";
	}
}
function doShare(){
	var url = escape("/formmode/view/ModeShare.jsp?ajax=2&modeId=<%=modeId%>&billid=<%=billid%>&MaxShare=<%=MaxShare%>");
	window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
}
function doImportDetail() {
	<%
	if(fromSave != 1){
	%>
	if (confirm("<%=SystemEnv.getHtmlLabelName(28504,user.getLanguage())%>")) {
		frmmain.fromImportDetail.value="1";
		doSubmit();
	}
	<%}else{%>
		var url = escape("/formmode/view/ModeDetailImport.jsp?ajax=1&modeId=<%=modeId%>&billid=<%=billid%>");
		if(!checkDataChange()){
	        if(confirm("<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>")){//所做的改动还没保存，如果离开，将会丢失数据，真的要离开吗？
	            window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,window);
	        }
	    }else{
	        window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,window);
	    }
	    window.location.reload();
	<%}%>
}

function returnTrue(o){
	return;
}

function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);
}

function openAccessory(fileId){ 
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId);
}

function openDocExt(showid,versionid,docImagefileid,isedit){
	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true");
	}
}

function changeChildField(obj, fieldid, childfieldid){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
    $G("selectChange").src = "/workflow/request/SelectChange.jsp?"+paraStr;
}

function changeChildFieldDetail(obj, fieldid, childfieldid, rownum){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&selectvalue="+obj.value+"&isdetail=1&&rowindex="+rownum;
    $G("selectChangeDetail").src = "/workflow/request/SelectChange.jsp?"+paraStr;
}

function doInitChildSelect(fieldid,pFieldid,finalvalue){
	try{
		var pField = $G("field"+pFieldid);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var field = $G("field"+fieldid);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=1&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_00";
				frm.style.display = "none";
			    document.body.appendChild(frm);
				$G("iframe_"+pFieldid+"_"+fieldid+"_00").src = "/workflow/request/SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
function doInitDetailchildSelect(fieldid,pFieldid,rownum,childvalue){
	try{
		var pField = $G("field"+pFieldid+"_"+rownum);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var field = $G("field"+fieldid+"_"+rownum);
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_"+rownum;
				frm.style.display = "none";
			    document.body.appendChild(frm);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=1&selectvalue="+pFieldValue+"&isdetail=1&&rowindex="+rownum+"&childvalue="+childvalue;
				$G("iframe_"+pFieldid+"_"+fieldid+"_"+rownum).src = "/workflow/request/SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
function doInitDetailchildSelectAdd(fieldid,pFieldid,rownum,childvalue){
	try{
		var pField = $G("field"+pFieldid+"_"+rownum);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var field = $G("field"+fieldid+"_"+rownum);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=1&selectvalue="+pFieldValue+"&isdetail=1&&rowindex="+rownum+"&childvalue="+childvalue;
				$G("iframe_"+pFieldid+"_"+fieldid).src = "SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
function checkModeNumFun() {//必须新增明细
	var modenum = 0;
<%
int checkdetailno = 0;
rs.execute("select tablename,title from Workflow_billdetailtable where billid="+formId+" order by orderid");
while(rs.next()) {
%>
	var rowneed = $G('rowneed<%=checkdetailno%>').value;
	var modesnum = $G('modesnum<%=checkdetailno%>').value;
	modesnum = modesnum*1;
	if(rowneed == "1") {
		if(modesnum>0) {
			nodenum = 0;
		} else {
			nodenum = '<%=checkdetailno+1%>';
		}
	} else {
		nodenum = 0;
	}
	if(nodenum>0)
   	{
   		return nodenum;
   	}
<%
	checkdetailno ++;
}%>
}
/*	
 *	用来给用户自定义检查数据，在流程提交或者保存的时候执行该函数，
 *	如果检查通过返回true，否则返回false
 *	用户在使用html模板的时候，通过重写这个方法，来达到检查特殊数据的需求
 */
function checkCustomize(){
	return true;
}

function doSubmit(detailid,issystemflag){
	enableAllmenu();
	frmmain.pageexpandid.value = detailid;
	var ischeckok="false";
	try{
		if(check_form(document.frmmain,$G("needcheck").value+$G("inputcheck").value))
		  	ischeckok="true";
	}catch(e){
	  ischeckok="exception";
	}
	if(ischeckok=="exception"){
		if(check_form(document.frmmain,'<%=needcheck%>'))
			ischeckok="true";
	}

	var modenum = checkModeNumFun();
   	if(modenum>0) {//必须填写第xx个明细表数据，请填写
   		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+modenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
		displayAllmenu();
   		return false;
   	}
   	
	if(!checkCustomize()){
		displayAllmenu();
		return false;
	}
	if(ischeckok=="true"){
		StartUploadAll();
		return checkuploadcomplet();
	}else{
		displayAllmenu();
	}
}
function onShowBrowser3(id,url,linkurl,type1,ismand) {
	onShowBrowser2(id, url, linkurl, type1, ismand, 3);
}
function onShowBrowser2(id,url,linkurl,type1,ismand, funFlag) {
	var id1 = null;
	
    if (type1 == 9 && false) {
        if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
        	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
        } else {
	    	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp";
        }
	}
	if (type1 == 23) {
		url += "?billid=<%=formId%>";
	}
	if (type1 == 2 || type1 == 19 ) {
	    spanname = "field" + id + "span";
	    inputname = "field" + id;
	    
		if (type1 == 2) {
			onFlownoShowDate(spanname,inputname,ismand);
		} else {
			onWorkFlowShowTime(spanname, inputname, ismand);
		}
	} else {
	    if (type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170) {
	    	if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
	    		id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
	    	} else {
			    if (type1 == 161||type1 == 224||type1 == 225) {
				    id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
				} else {
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
	    	}
		} else {
	        if (type1 == 135) {
				tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 37) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 142 ) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			} else if (type1 == 162 ) {
				tmpids = $GetEle("field"+id).value;

				if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
					url = url + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
				} else {
					url = url + "|" + id + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
			} else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
		        index = (id + "").indexOf("_");
		        if (index != -1) {
		        	tmpids=uescape("?isdetail=1&isbill=1&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else {
		        	tmpids = uescape("?fieldid=" + id + "&isbill=1&resourceids=" + $GetEle("field" + id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        }
			} else {
		        tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			}
		}
	    if (id1 != undefined && id1 != null) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = ""

					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
					
					var resourceIdArray = resourceids.split(",");
					var resourceNameArray = resourcename.split(",");
					for (var _i=0; _i<resourceIdArray.length; _i++) {
						var curid = resourceIdArray[_i];
						var curname = resourceNameArray[_i];
						if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml += "<a href=" + linkurl + curid + " target=_blank>" + curname + "</a>&nbsp";
						}
					}
					$GetEle("field" + id + "span").innerHTML = sHtml;
					$GetEle("field" + id).value= resourceids;
				} else {
 					if (ismand == 0) {
 						$GetEle("field"+id+"span").innerHTML = "";
 					} else {
 						$GetEle("field"+id+"span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
 					}
 					$GetEle("field"+id).value = "";
				}

			} else {
			   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
	               if (type1 == 162) {
				   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						var href = wuiUtil.getJsonValueByIndex(id1, 3);
						sHtml = ""
						ids = ids.substr(1);
						$GetEle("field"+id).value= ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split("~~WEAVERSplitFlag~~");
						if(nameArray.length < idArray.length){
							nameArray = names.split(",");
						}
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							//sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
							if(href==''){
								sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
							}else{
								sHtml += "<a title='" + curdesc + "' href='" + href + curid + "' target='_blank'>" + curname + "</a>&nbsp";
							}
						}
						
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return;
	               }
				   if (type1 == 161) {
					   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
					   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						var href = wuiUtil.getJsonValueByIndex(id1, 3);
						$GetEle("field"+id).value = ids;
						//sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						if(href==''){
							sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						}else{
							sHtml = "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp";
						}
						$GetEle("field" + id + "span").innerHTML = sHtml
						return ;
				   }
	               if (type1 == 9 && false) {
		                tempid = wuiUtil.getJsonValueByIndex(id1, 0);
		                $GetEle("field" + id + "span").innerHTML = "<a href='#' onclick='createDoc(" + id + ", " + tempid + ", 1)'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a><button type=button id='createdoc' style='display:none' class=AddDocFlow onclick=createDoc(" + id + ", " + tempid + ",1)></button>";
	               } else {
	            	    if (linkurl == "") {
				        	$GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1);
				        } else {
							if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
								$GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
							} else {
								$GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
							}
				        }
	               }
	               $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
	                if (type1 == 9 && false) {
	                	$GetEle("CreateNewDoc").innerHTML="";
	                }
			   } else {
					if (ismand == 0) {
						$GetEle("field"+id+"span").innerHTML = "";
					} else {
						$GetEle("field"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					}
					$GetEle("field"+id).value="";
					if (type1 == 9 && false){
						$GetEle("createNewDoc").innerHTML = "<button type=button id='createdoc' class=AddDocFlow onclick=createDoc(" + id + ",'','1') title='<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%></button>";
					}
			   }
			}
		}
	}
}
//联动属性
function changeshowattr(fieldid,fieldvalue,rownum,workflowid,nodeid){
    len = document.forms[0].elements.length;
    var ajax=ajaxinit();
    ajax.open("POST", "/formmode/view/FormModeChanegAttrAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("modeId=<%=modeId%>&type=<%=type%>&fieldid="+fieldid+"&fieldvalue="+fieldvalue);
    // 获取执行状态
    ajax.onreadystatechange = function() {
        // 如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            var returnvalues=ajax.responseText;
            if(returnvalues!=""){
                var tfieldid=fieldid.split("_");
                var isdetail=tfieldid[1];
                var fieldarray=returnvalues.split("&");
                for(n=0;n<fieldarray.length;n++){
                    var fieldattrs=fieldarray[n].split("$");
                    var fieldids=fieldattrs[0];
                    var fieldattr=fieldattrs[1];
                    var fieldidarray=fieldids.split(",");
                    if(fieldattr==-1){ // 没有设置联动，恢复原值和恢复原显示属性
                        for(i=0;i<len;i++){
                            for(j=0;j<fieldidarray.length;j++){
                                var tfieldidarray=fieldidarray[j].split("_");
                                if (tfieldidarray[1]==isdetail){
                                    if(rownum>-1){  // 明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum)){
                                            isedit=$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum).value;
                                            if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")){
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                if(isedit==3){
                                                	document.forms[0].elements[i].setAttribute('viewtype','1');
                                                    if(document.forms[0].elements[i].value==""&&$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")<=0) $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                    if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
                                                    	//document.all('field'+tfieldidarray[0]+"_"+rownum).disabled=false;
                                                    	setCanEdit($GetEle('field'+tfieldidarray[0]+"_"+rownum));
                                                    }
                                                    if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"browser")!=null){
                                                    	$GetEle('field'+tfieldidarray[0]+"_"+rownum+"browser").disabled=false;
                                                    }
                                                    try{
														if(document.forms[0].elements[i].value==""&&$GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")<=0){
															$GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
															$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
														}
													}catch(e){}
                                                    if(checkstr_.indexOf("field"+tfieldidarray[0]+"_"+rownum+",")<0) $GetEle("needcheck").value=checkstr_+"field"+tfieldidarray[0]+"_"+rownum;
                                                }
                                                if(isedit==2){
                                                	document.forms[0].elements[i].setAttribute('viewtype','0');
                                                    if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                                    if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
                                                    	//document.all('field'+tfieldidarray[0]+"_"+rownum).disabled=false;
                                                    	setCanEdit($GetEle('field'+tfieldidarray[0]+"_"+rownum));
                                                    }
                                                    if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"browser")!=null){
                                                    	$GetEle('field'+tfieldidarray[0]+"_"+rownum+"browser").disabled=false;
                                                    }
                                                    try{
														if($GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
															$GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
														}
													}catch(e){}
													$GetEle("needcheck").value=checkstr_.replace("field"+tfieldidarray[0]+"_"+rownum+",","");
                                                }
                                            }
                                        }
                                    }else{     // 主字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$GetEle('oldfieldview'+tfieldidarray[0])){
                                            isedit=$GetEle('oldfieldview'+tfieldidarray[0]).value;
                                            if($GetEle('field'+tfieldidarray[0]+"span")){
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                if(isedit==3) {
                                                	document.forms[0].elements[i].setAttribute('viewtype','1');
                                                    if(document.forms[0].elements[i].value=="") $GetEle('field'+tfieldidarray[0]+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                    if($GetEle('field'+tfieldidarray[0])!=null){
                                                    	$GetEle('field'+tfieldidarray[0]).disabled=false;
                                                    	setCanEdit($GetEle('field'+tfieldidarray[0]));
                                                    }
                                                    if($GetEle('field'+tfieldidarray[0]+"browser")!=null){
                                                    	$GetEle('field'+tfieldidarray[0]+"browser").disabled=false;
                                                    }
                                                    try{
														if(document.forms[0].elements[i].value==""){
															$GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
															$GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
														}
													}catch(e){}
                                                    if(checkstr_.indexOf("field"+tfieldidarray[0]+",")<0) $GetEle("needcheck").value=checkstr_+"field"+tfieldidarray[0];
                                                }
                                                if(isedit==2) {
                                                	document.forms[0].elements[i].setAttribute('viewtype','0');
                                                    if($GetEle('field'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
                                                    if($GetEle('field'+tfieldidarray[0])!=null){
                                                    	//document.all('field'+tfieldidarray[0]).disabled=false;
                                                    	setCanEdit($GetEle('field'+tfieldidarray[0]));
                                                    }
                                                    if($GetEle('field'+tfieldidarray[0]+"browser")!=null){
                                                    	$GetEle('field'+tfieldidarray[0]+"browser").disabled=false;
                                                    }
                                                    try{
														if($GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
															$GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML="";
														}
													}catch(e){}
													$GetEle("needcheck").value=checkstr_.replace("field"+tfieldidarray[0]+",","");
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(fieldattr==1){// 为编辑，显示属性设为编辑
                        for(i=0;i<len;i++){
                            for(j=0;j<fieldidarray.length;j++){
                                var tfieldidarray=fieldidarray[j].split("_");
                                if (tfieldidarray[1]==isdetail){
                                    if(rownum>-1){  // 明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum)){
                                            isedit=$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum).value;
                                            if(isedit>1&&$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")){
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                                if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
                                                	//document.all('field'+tfieldidarray[0]+"_"+rownum).disabled=false;
                                                	setCanEdit($GetEle('field'+tfieldidarray[0]+"_"+rownum));
                                                }
                                                if($GetEle('field'+tfieldidarray[0]+"_"+rownum+'browser')!=null){
                                                	$GetEle('field'+tfieldidarray[0]+"_"+rownum+'browser').disabled=false;
                                                }
                                                try{
													if($GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
														$GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
													}
												}catch(e){}
                                                $GetEle("needcheck").value=checkstr_.replace("field"+tfieldidarray[0]+"_"+rownum+",","");
                                                document.forms[0].elements[i].setAttribute('viewtype','0');
                                            }
                                        }
                                    }else{     // 主字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$GetEle('oldfieldview'+tfieldidarray[0])){
                                            isedit=$GetEle('oldfieldview'+tfieldidarray[0]).value;
                                            if(isedit>1&&$GetEle('field'+tfieldidarray[0]+"span")){
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                if($GetEle('field'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
                                                if($GetEle('field'+tfieldidarray[0])!=null){
                                                	//document.all('field'+tfieldidarray[0]).disabled=false;
                                                	setCanEdit($GetEle('field'+tfieldidarray[0]));
                                                }
                                                if($GetEle('field'+tfieldidarray[0]+'browser')!=null){
                                                	$GetEle('field'+tfieldidarray[0]+'browser').disabled=false;
                                                }
                                                try{
													if($GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
														$GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML="";
													}
												}catch(e){}
                                                $GetEle("needcheck").value=checkstr_.replace("field"+tfieldidarray[0]+",","");
                                                document.forms[0].elements[i].setAttribute('viewtype','0');
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(fieldattr==2){// 为必填，显示属性设为编辑
                        for(i=0;i<len;i++){
                            for(j=0;j<fieldidarray.length;j++){
                                var tfieldidarray=fieldidarray[j].split("_");
                                if (tfieldidarray[1]==isdetail){
                                    if(rownum>-1){  // 明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum)){
                                            isedit=$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum).value;
                                            if(isedit>1&&$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")){
                                                if(document.forms[0].elements[i].value==""&&$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")<=0) $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                try{
													if(document.forms[0].elements[i].value==""&&$GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")<=0){
														$GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
														$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
													}
												}catch(e){}
                                                if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
                                                	//document.all('field'+tfieldidarray[0]+"_"+rownum).disabled=false;
                                                	setCanEdit($GetEle('field'+tfieldidarray[0]+"_"+rownum));
                                                }
                                                if($GetEle('field'+tfieldidarray[0]+"_"+rownum+'browser')!=null){
                                                	$GetEle('field'+tfieldidarray[0]+"_"+rownum+'browser').disabled=false;
                                                }
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                if(checkstr_.indexOf("field"+tfieldidarray[0]+"_"+rownum+",")<0) $GetEle("needcheck").value=checkstr_+"field"+tfieldidarray[0]+"_"+rownum;
                                                document.forms[0].elements[i].setAttribute('viewtype','1');
                                            }
                                        }
                                    }else{     // 主字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$GetEle('oldfieldview'+tfieldidarray[0])){
                                            isedit=$GetEle('oldfieldview'+tfieldidarray[0]).value;
                                            if(isedit>1&&$GetEle('field'+tfieldidarray[0]+"span")){
                                                if(document.forms[0].elements[i].value=="") $GetEle('field'+tfieldidarray[0]+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                //判断附件字段
                                                if($GetEle("fsUploadProgress"+tfieldidarray[0])){
                                                	if($GetEle("fsUploadProgress"+tfieldidarray[0]).children.length>0){
                                                		$GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
                                                	}
                                                }
                                                try{
													if(document.forms[0].elements[i].value==""){
														$GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
														$GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
													}
												}catch(e){}
												if($GetEle('field'+tfieldidarray[0])!=null){
                                                	//document.all('field'+tfieldidarray[0]).disabled=false;
                                                	setCanEdit($GetEle('field'+tfieldidarray[0]));
                                                }
                                                if($GetEle('field'+tfieldidarray[0]+'browser')!=null){
                                                	$GetEle('field'+tfieldidarray[0]+'browser').disabled=false;
                                                }
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                if(checkstr_.indexOf("field"+tfieldidarray[0]+",")<0) $GetEle("needcheck").value=checkstr_+"field"+tfieldidarray[0];
                                                document.forms[0].elements[i].setAttribute('viewtype','1');
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(fieldattr==3){//为只读，显示属性设为编辑
                        for(i=0;i<len;i++){
                            for(j=0;j<fieldidarray.length;j++){
                                var tfieldidarray=fieldidarray[j].split("_");
                                if (tfieldidarray[1]==isdetail){
                                    if(rownum>-1){  //明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&document.all('oldfieldview'+tfieldidarray[0]+"_"+rownum)){
                                            if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")){
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")){
													if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
														$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
													}
                                                	//$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                                }
                                                if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
                                                	//$GetEle('field'+tfieldidarray[0]+"_"+rownum).value="";
                                                	//$GetEle('field'+tfieldidarray[0]+"_"+rownum).disabled=true;
                                                	setReadOnly($GetEle('field'+tfieldidarray[0]+"_"+rownum));
                                                }
                                                if($GetEle('field'+tfieldidarray[0]+"_"+rownum+'browser')!=null){
                                                	$GetEle('field'+tfieldidarray[0]+"_"+rownum+'browser').disabled=true;
                                                }
                                                try{
													if($GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
														$GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
													}
												}catch(e){}
                                                $GetEle("needcheck").value=checkstr_.replace("field"+tfieldidarray[0]+"_"+rownum+",","");
                                                document.forms[0].elements[i].viewtype="0";
                                            }
                                        }
                                    }else{     //主字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$GetEle('oldfieldview'+tfieldidarray[0])){
                                            if($GetEle('field'+tfieldidarray[0]+"span")){
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                if($GetEle('field'+tfieldidarray[0]+"span")){
                                                	//$GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
													if($GetEle('field'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
														$GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
													}
                                                }
                                                if($GetEle('field'+tfieldidarray[0])!=null){
                                                	//$GetEle('field'+tfieldidarray[0]).value="";
                                                	//$GetEle('field'+tfieldidarray[0]).disabled=true;
                                                	//$GetEle('field'+tfieldidarray[0]).readOnly=true;
                                                	setReadOnly($GetEle('field'+tfieldidarray[0]));
                                                }
                                                if($GetEle('field'+tfieldidarray[0]+"browser")!=null){
                                                	$GetEle('field'+tfieldidarray[0]+"browser").disabled=true;
                                                }
                                                try{
													if($GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
														$GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML="";
													}
												}catch(e){}
                                                $GetEle("needcheck").value=checkstr_.replace("field"+tfieldidarray[0]+",","");
                                                document.forms[0].elements[i].viewtype="0";
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            }catch(e){}
        }
    }
}

//设置为只读
function setReadOnly(obj){
	//alert("设置为只读:"+obj.type);
	if(obj.type == "text"){//单行文本
		obj.readOnly = true;
	}else if(obj.type == "textarea"){//多行文本
		obj.readOnly = true;
	}else if(obj.type == "select-one"){//下拉字段
		//obj.onmouseover = function(){this.setCapture();};   
		//obj.onmouseout = function(){this.releaseCapture();};   
		//obj.onbeforeactivate = function(){return false;};  
        //obj.onfocus = function(){obj.blur();};  
        //obj.onmouseover = function(){obj.setCapture();};  
        //obj.onmouseout = function(){obj.releaseCapture();};

		/****/
		obj.onfocus = function() {
			var index = this.selectedIndex; 
			this.onchange = function() { 
				this.selectedIndex = index; 
			};
		}
		/****/
		
	}
}
//设置为只读
function setCanEdit(obj){
	//alert("设置为可编辑:"+obj.type);
	if(obj.type == "text"){//单行文本
		obj.readOnly = false;
	}else if(obj.type == "textarea"){//多行文本
		obj.readOnly = false;
	}else if(obj.type == "select-one"){//下拉字段
		//obj.onmouseover = null;   
		//obj.onmouseout = null;   
		obj.onfocus = null;
		obj.onchange = null;
	}
}

function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {
	var tmpids = $GetEle("field" + id).value;
	url = url + roleid + "_" + tmpids;
	id1 = window.showModalDialog(url);
	if (id1) {

		if (wuiUtil.getJsonValueByIndex(id1, 0) != ""
				&& wuiUtil.getJsonValueByIndex(id1, 0) != "0") {

			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";

			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);

			$GetEle("field" + id).value = resourceids;

			var idArray = resourceids.split(",");
			var nameArray = resourcename.split(",");
			for ( var _i = 0; _i < idArray.length; _i++) {
				var curid = idArray[_i];
				var curname = nameArray[_i];

				sHtml = sHtml + "<a href=" + linkurl + curid
						+ " target='_new'>" + curname + "</a>&nbsp";
			}

			$GetEle("field" + id + "span").innerHTML = sHtml;

		} else {
			if (ismand == 0) {
				$GetEle("field" + id + "span").innerHTML = "";
			} else {
				$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			}
			$GetEle("field" + id).value = "";
		}
	}
}

function onShowResourceConditionBrowser(id, url, linkurl, type1, ismand) {

	var tmpids = $GetEle("field" + id).value;
	var dialogId = window.showModalDialog(url + "?resourceCondition=" + tmpids);
	if ((dialogId)) {
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
				if (shareTypeValue == "") {
					continue;
				}
				fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
						+ relatedShareIds + "_" + rolelevelValue + "_"
						+ secLevelValue;
				
				if (shareTypeValue == "1") {
					sHtml = sHtml + "," + shareTypeText + "("
							+ relatedShareNames + ")";
				} else if (shareTypeValue == "2") {//安全级别的分部成员
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>=" 
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>"; 
				} else if (shareTypeValue == "3") {//安全级别的部门成员
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>=" 
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>"; 
				} else if (shareTypeValue == "4") {//共享级别安全级别的角色成员
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>=" 
							+ rolelevelText
							+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>=" 
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";
				} else {//安全级别的所有人
					sHtml = sHtml
							+ ","
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage())%>";
				}

			}
			
			sHtml = sHtml.substr(1);
			fileIdValue = fileIdValue.substr(1);

			$GetEle("field" + id).value = fileIdValue;
			$GetEle("field" + id + "span").innerHTML = sHtml;
		} else {
			if (ismand == 0) {
				$GetEle("field" + id + "span").innerHTML = "";
			} else {
				$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			}
			$GetEle("field" + id).value = "";
	    }
	} 
}

<%if(type !=0 && type !=3){%>
setTimeout("doTriggerInit()",1000);
<%}%>
function doTriggerInit(){
 	var tempS = "<%=trrigerfield%>";
 	datainput(tempS);
}
function datainput(parfield){				//字段联动-主字段
	var tempParfieldArr = parfield.split(",");
	var StrData="modeId=<%=modeId%>&formId=<%=formId%>&type=<%=type%>&detailsum=<%=detailsum%>&trg="+parfield;
	var mm=StrData;
	for(var i=0;i<tempParfieldArr.length;i++){
		var tempParfield = tempParfieldArr[i];
	<%
	if(!trrigerfield.trim().equals("")){
 		ArrayList Linfieldname=ddi.GetInFieldName();
 		for(int i=0;i<Linfieldname.size();i++){
  			String temp=(String)Linfieldname.get(i);
	%>
		if($G("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+$G("<%=temp.substring(temp.indexOf("|")+1)%>").value;
	<%
 		}
	}
	%>
	}
	$G("datainputform").src="/formmode/view/DataInputFrom.jsp?"+StrData;
}

function datainputd(parfield){				//明细

  //var xmlhttp=XmlHttp.create();
  var tempParfieldArr = parfield.split(",");
	var StrData="modeId=<%=modeId%>&formId=<%=formId%>&type=<%=type%>&detailsum=<%=detailsum%>&trg="+parfield;

	for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
      	var indexid=tempParfield.substr(tempParfield.indexOf("_")+1);

  <%
  	if(!trrigerdetailfield.trim().equals("")){
		ArrayList Linfieldname=ddi.GetInFieldName();
		for(int i=0;i<Linfieldname.size();i++){
			String temp=(String)Linfieldname.get(i);
  %>
		if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)!=null) StrData+="&<%=temp%>="+$G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value;

  <%
		}
	}
  %>
  }
	$G("datainputformdetail").src="DataInputFromDetail.jsp?"+StrData;
}

function hideRightClickMenu1(){	
	rightMenu.style.visibility="hidden";
}
function getNumber(index){
  	$G("field_lable"+index).value = $G("field"+index).value;
}

function onChangeSharetype(delspan,delid,ismand,Uploadobj){
	fieldid=delid.substr(0,delid.indexOf("_"));
    linknum=delid.substr(delid.lastIndexOf("_")+1);
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
    delfieldid=fieldid+"_id_"+linknum;
    if($GetEle(delspan).style.visibility=='visible'){
      $GetEle(delspan).style.visibility='hidden';
      $GetEle(delid).value='0';
	  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
        var tempvalue=$GetEle(fieldid).value;
          if(tempvalue==""){
              tempvalue=$GetEle(delfieldid).value;
          }else{
              tempvalue+=","+$GetEle(delfieldid).value;
          }
	     $GetEle(fieldid).value=tempvalue;
    }else{
      $GetEle(delspan).style.visibility='visible';
      $GetEle(delid).value='1';
	  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
        var tempvalue=$GetEle(fieldid).value;
        var tempdelvalue=","+$GetEle(delfieldid).value+",";
          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
	     $GetEle(fieldid).value=tempvalue;
    }
	//alert($GetEle(fieldidnum).value);
	if (ismand=="1"){
		if ($GetEle(fieldidnum).value=="0"){
		    $GetEle(fieldid).value="";
	        if(Uploadobj.getStats().files_queued==0){
				$GetEle(fieldidspan).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	        }
		}else{
			 $GetEle(fieldidspan).innerHTML="";
		}
	}
 }

function addrowplus(groupid,rowindex){
	resetFreeWfFormHeight();
}

function delrowplus(groupid){
	resetFreeWfFormHeight();
}
</script>

<script language=javascript src="/js/checkData_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>

<script>

jQuery(".reqname").parent().addClass("reqformtitle");


//右键菜单
function showRightClickMenuForFreeWf(e){
	
	    var offset=jQuery(parent.document).find("#freeformwin").offset();
	    
	    focus_e = document.activeElement;
        var evt = e?e:(window.event?window.event:null);
		var rightedge=document.body.clientWidth-evt.clientX;
		var bottomedge=document.body.clientHeight-evt.clientY;
	
		var rightMenu=parent.rightMenu;

		if(rightedge>evt.clientX){
			
			rightMenu.style.left=document.body.clientWidth-rightedge;
			
		}else{
			rightMenu.style.left=evt.clientX-rightMenu.offsetWidth;
		}
		if(bottomedge>evt.clientY){
			rightMenu.style.top=evt.clientY+document.body.scrollTop+offset.top;
		}else{
			rightMenu.style.top=document.body.clientHeight+document.body.scrollTop-bottomedge+offset.top;
		}
		if(rightMenu.offsetHeight>bottomedge){
			    rightMenu.style.top=document.body.clientHeight+document.body.scrollTop-rightMenu.offsetHeight+offset.top;
		}


		rightMenu.style.visibility="visible"	
		rightMenu.style.display="";	
		//evt.stopPropagation();
		evt.cancelBubble = true
		evt.returnValue = false; 
		return false;
}

function hideRightClickMenuForFreeWf(){
  
    var rightMenu=parent.rightMenu;

	if(jQuery(rightMenu).is(":visible"))
	{
	  jQuery(rightMenu).hide();
	}		
	
}



document.oncontextmenu=showRightClickMenuForFreeWf;

document.body.onclick = hideRightClickMenuForFreeWf;


function checkuploadcomplet(){
	if(upfilesnum>0){
		setTimeout("checkuploadcomplet()",1000);
	}else{
		if(!checkUploadeErr()) {
			hiddenPrompt();
			displayAllmenu();
		}
		return true;
		//document.frmmain.submit();
		//enableAllmenu();
		//frmmain.target = nowtarget;
		//frmmain.action = nowaction;
	}
}
//点击重置表单高度
function   resetFreeWfFormHeight(){
	jQuery(parent.document).find("#freeformwin").css("height",jQuery("#frmmain").height()+"px");
}

jQuery(parent.document).find("#freeformwin").css("height",jQuery("#frmmain").height()+"px");


</script>

<%
if(type==1)
{
%>
<link href="/css/ecology8/freewfaddwithformmode_wev8.css" rel="stylesheet" type="text/css" />
<%} else {%>
<link href="/css/ecology8/freewfopwithformmode_wev8.css" rel="stylesheet" type="text/css" />
<%
}
%>


</body>
</html>