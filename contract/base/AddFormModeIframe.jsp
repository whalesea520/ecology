<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.formmode.setup.ModeRightInfoExtend"%>
<%@ page import="weaver.formmode.setup.ModeRightInfo"%>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.formmode.FormModeConfig"%>
<%@ page import="weaver.docs.category.SecCategoryComInfo"%>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="weaver.formmode.interfaces.ModeManageMenu" %>
<%@ page import="weaver.formmode.view.ResolveFormMode"%>
<%@ page import="weaver.formmode.datainput.DynamicDataInput"%>
<%@ page import="weaver.formmode.setup.ExpandBaseRightInfo"%>
<%@page import="weaver.formmode.manager.FieldAttrManager"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResolveFormMode" class="weaver.formmode.view.ResolveFormMode" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeViewLog" class="weaver.formmode.view.ModeViewLog" scope="page"/>
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.formmode.data.FieldInfo" scope="page" />
<jsp:useBean id="modeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="expandBaseRightInfo" class="weaver.formmode.setup.ExpandBaseRightInfo" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
FormModeConfig formModeConfig = new FormModeConfig();
int isNewPlugisBrowser = formModeConfig.getIsNewPlugisBrowser();
int isNewPlugisSelect = formModeConfig.getIsNewPlugisSelect();
int isNewPlugisCheckbox = formModeConfig.getIsNewPlugisCheckbox();
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
int mainid = Util.getIntValue(request.getParameter("mainid"),0);
int type = Util.getIntValue(request.getParameter("type"),0);//0：查看；1：创建；2：编辑；3：监控
//int billid = Util.getIntValue(request.getParameter("billid"),0);
String billid = Util.null2String(request.getParameter("billid"));
String editData = Util.null2String(request.getParameter("editData"));//不为空表示来自新建或编辑，允许出现编辑按钮
int isfromTab = Util.getIntValue(request.getParameter("isfromTab"),0);
int fromSave = Util.getIntValue(request.getParameter("fromSave"),0);
String iscreate = Util.null2String(request.getParameter("iscreate"));
int istabinline = Util.getIntValue(request.getParameter("istabinline"),0);
int tabcount = Util.getIntValue(request.getParameter("tabcount"),0);
int layoutid = Util.getIntValue(request.getParameter("layoutid"),0);//布局ID

//如果布局id不为空，则根据布局id获取modeid、formid、type
if(layoutid>0){
	rs.executeSql("select modeid,formid,type from modehtmllayout where id = "+layoutid);
	if(rs.next()){
		modeId = Util.getIntValue(rs.getString("modeid"));
		formId = Util.getIntValue(rs.getString("formid"));
		type = Util.getIntValue(rs.getString("type"));
	}
}

expandBaseRightInfo.setUser(user);
FieldInfo.setUser(user);
HashMap hm = FieldInfo.getMainTableData(modeId+"",formId+"",billid);
//获得模块的主字段
HashMap modeMainFieldMap = FieldInfo.getModeFieldList(modeId+"");

String addpagesql = "";
if(type== 0){//显示
	addpagesql = "and viewpage=1";
}else if(type == 2){//编辑
	addpagesql = "and managepage=1";
}else if(type == 1){//新建
	addpagesql = "and createpage=1";
}
String countsql = "select id from mode_pageexpand where modeid = "+modeId+" and isshow = 1 "+addpagesql+" and showtype = 1 and tabshowtype=1 and isbatch in(0,2) order by showorder asc";
rs.executeSql(countsql);
int tempcount = 0;
// 增加判断权限
while(rs.next()) {
	if(expandBaseRightInfo.checkExpandRight(Util.null2String(rs.getString("id")), Util.null2String(modeId), billid)) {
		tempcount++;
	}
}
tabcount = tempcount;

String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int templateid = Util.getIntValue(request.getParameter("templateid"),0);

String viewfrom = Util.null2String(request.getParameter("viewfrom"));
int opentype = Util.getIntValue(request.getParameter("opentype"),0);
int customid = Util.getIntValue(request.getParameter("customid"),0);
int isRefreshTree = Util.getIntValue(request.getParameter("isRefreshTree"),0);
boolean isPreview = Util.null2String(request.getParameter("isPreview")).equals("1");

boolean isRight = false;
boolean isEdit = false;		//是否有编辑权限，主要针对右键按钮是否显示
boolean isDel = false;		//是否有删除权限，主要针对右键按钮是否显示
boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formId);
int MaxShare = 0;
List<User> lsUser = new ArrayList<User>();
if(type==1){//新建时只取当前账户
	lsUser.add(user);
}else{
	lsUser = ModeRightInfo.getAllUserCountList(user);
}
boolean isResultRight = false;
if(!isVirtualForm){
	ModeRightInfo modeRightInfo=new ModeRightInfo();
	modeRightInfo.setModeId(modeId);
	for(int i=0;i<lsUser.size();i++){
		User tempUser = lsUser.get(i);
		modeRightInfo.setUser(tempUser);
		if(type==1){//新建：判断是否具有创建权限
			isRight = modeRightInfo.checkUserRight(type);
		}else if(type==3){//监控：首先判断查询列表中是否有监控权限，如果没有则判断全局监控权限
			FormModeRightInfo.setUser(tempUser);
			isRight = FormModeRightInfo.checkUserRight(customid,4);
			if(!isRight){
				isRight = modeRightInfo.checkUserRight(type);
			}
			if(modeRightInfo.checkUserRight(type)){
				isDel = true;
			}
		}else if(type==0 || type == 2){//查看、编辑：判断是否具有查看、编辑、删除权限
			ModeShareManager.setModeId(modeId);
			String rightStr = ModeShareManager.getShareDetailTableByUser("formmode",tempUser);
			rs.executeSql("select sourceid,max(sharelevel) as sharelevel from "+rightStr+" t where sourceid="+billid+" group by sourceid");
			if(rs.next()){
				MaxShare = rs.getInt("sharelevel");
				isRight = true;
				if(MaxShare > 1) {
					isEdit = true;		//有编辑或完全控制权限的出现编辑按钮
					if(MaxShare == 3) isDel = true;		//有完全控制权限的出现删除按钮
				}
			}
		}
		if(isRight){
			isResultRight = true;
			if(isDel){
				break;
			}
		}
	}
	isRight = isResultRight;
}else{//虚拟表单权限
	ModeRightInfoExtend modeRightInfoExtend=new ModeRightInfoExtend();
	modeRightInfoExtend.setModeId(modeId);
	modeRightInfoExtend.setUser(user);
	modeRightInfoExtend.setFormid(formId);
	modeRightInfoExtend.setBillid(billid);
	if(type==1){//新建
		isRight = modeRightInfoExtend.checkUserRight(1);
	}else if(type==0||type==2){//查看、编辑时判断是否显示编辑、删除按钮
		isRight=true;//查看权限
		isDel=modeRightInfoExtend.checkUserRightByRightType(3);//完全控制权限
		if(isDel){
			isEdit=true;
		}else{
			isEdit=modeRightInfoExtend.checkUserRightByRightType(2);//编辑权限
		}
	}else if(type==3){//监控
		isRight=true;
	}
}

//表单建模判断关联授权
String authorizeOpttype  ="";
String authorizeLayoutid  ="";
String authorizeLayoutlevel  ="";
boolean authorizeFlag = false;
//表单建模判断关联授权
String formmodeflag = StringHelper.null2String(request.getParameter("formmode_authorize"));
Map<String,String> formmodeAuthorizeInfo = new HashMap<String,String>();
if(formmodeflag.equals("formmode_authorize")){
	int authorizemodeId = 0;
	int authorizeformmodebillId = 0;
	int authorizefieldid = 0;
	authorizemodeId = Util.getIntValue(request.getParameter("authorizemodeId"),0);
	authorizeformmodebillId = Util.getIntValue(request.getParameter("authorizeformmodebillId"),0);
	authorizefieldid = Util.getIntValue(request.getParameter("authorizefieldid"),0);
	ModeRightInfo modeRightInfo = new ModeRightInfo();
	modeRightInfo.setUser(user);
	formmodeAuthorizeInfo = modeRightInfo.isFormModeAuthorize(formmodeflag, authorizemodeId, 
			authorizeformmodebillId, authorizefieldid, Util.getIntValue(billid));
	if("1".equals(formmodeAuthorizeInfo.get("AuthorizeFlag"))){
		isRight = true;
		authorizeOpttype = formmodeAuthorizeInfo.get("opttype");
		if("2".equals(authorizeOpttype)){
			isEdit = true;
		}
		authorizeLayoutid = formmodeAuthorizeInfo.get("layoutid");
		authorizeLayoutlevel = formmodeAuthorizeInfo.get("layoutlevel");
		authorizeFlag = true;
	}
}




boolean haveTab = false;//需要多tab页
String sql = "";

String addurl = "";
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
			
			addurl += "&"+fieldid+"_set="+fieldvalue;
			parentTabValueMap.put(id,fieldvalue);
		}
	}
}

//保存操作日志
//只记录查看日志，修改日志在保存的时候记录
if(type == 0){
	/**String operatetype = "4";//操作的类型： 1：新2：修3：删4：查
	String clientaddress = request.getRemoteAddr();
	String operatedesc = SystemEnv.getHtmlLabelName(33564, user.getLanguage());
	int operateuserid = user.getUID();
	int relatedid = Util.getIntValue(billid);
	String relatedname = "";
	ModeViewLog.resetParameter();
	ModeViewLog.setClientaddress(clientaddress);
	ModeViewLog.setModeid(modeId);
	ModeViewLog.setOperatedesc(operatedesc);
	ModeViewLog.setOperatetype(operatetype);
	ModeViewLog.setOperateuserid(operateuserid);
	ModeViewLog.setRelatedid(relatedid);
	ModeViewLog.setRelatedname(relatedname);
	ModeViewLog.setSysLogInfo();**/
}


String custompage = "";
String modename = "";
String isImportDetail = "";
String isAllowReply = "";
int categorytype = 0;
int selectcategory = 0; 
if(modeId > 0 ){
	rs.executeSql("select * from modeinfo where id="+modeId);
	if(rs.next()){
		if(type==1){
			isImportDetail = Util.null2String(rs.getString("isImportDetail"));
		}
		modename = Util.null2String(rs.getString("modename"));
		custompage = Util.null2String(rs.getString("custompage"));
		isAllowReply = Util.null2String(rs.getString("isAllowReply"));
		categorytype = Util.getIntValue(rs.getString("categorytype"),0);
		selectcategory = Util.getIntValue(rs.getString("selectcategory"),0);
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

<%
//记录树节点id
String tempfield= "";
String lastnodeid = "";
if(billid !=null && !billid.equals("")){
	RecordSet2.executeSql("select * from mode_customtreedetail where sourceid="+modeId+" and mainid="+mainid);
	if(RecordSet2.next()){	
		tempfield = RecordSet2.getString("hrefrelatefield");
		lastnodeid += RecordSet2.getString("id")+"_";
	}
	String tempSql = "select * from workflow_bill where id="+formId;
	RecordSet2.executeSql(tempSql);
	String tablename2 = "";
	if(RecordSet2.next()){
	    tablename2 = RecordSet2.getString("tablename");
	    if(VirtualFormHandler.isVirtualForm(formId)){
	    	tablename2 = VirtualFormHandler.getRealFromName(tablename2);
	    	Map<String, Object> vFormInfo = VirtualFormHandler.getVFormInfo(formId);
	    	String vdatasource = Util.null2String(vFormInfo.get("vdatasource"));
	    	String vprimarykey = Util.null2String(vFormInfo.get("vprimarykey"));
	    	RecordSet2.executeSql("select * from "+tablename2+" where "+vprimarykey+"="+billid, vdatasource);
	    }else{
	    	RecordSet2.executeSql("select * from "+tablename2+" where id="+billid);
	    }
		if(RecordSet2.next()){			
			lastnodeid += RecordSet2.getString(tempfield);
		}else{
			lastnodeid = "";
		}  
	}
}
%>
<html>
<head>
<meta>
<title><%=modename %></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/workflow/request/js/requesthtml_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/AddMode_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>

<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>

<script type="text/javascript" language="javascript" src="/formmode/js/jquery/aop/jquery.aop.min_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/formmode/js/json2_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/formmode/js/FieldPrompt_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script type="text/javascript" src='/formmode/js/ping_wev8.js'></script>
<!-- 新表单设计器，Format_wev8.js -->
<link rel="stylesheet" type="text/css" href="/formmode/exceldesign/css/excelHtml_wev8.css" />
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<!--添加插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwfat_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css" rel="stylesheet"></link>
<!-- ckeditor的一些方法在uk中的实现 -->
<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>

<!-- word转html插件 -->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>

<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>

<script>
//新表单设计器-联动format加载监听器----------此ready需先于calsum行列计算前执行，用于表览字段chrome下合计
var chromeOnPropListener = null;
jQuery(document).ready(function(){
	loadListener();
});

//加载监听器，页面打开调用一次；明细表添加调用一次，重置定时器监听的对象
function loadListener(){
	if(chromeOnPropListener==null){
		chromeOnPropListener = new Listener();
	}else{
		chromeOnPropListener.stop();
	}
	chromeOnPropListener.load("[_listener][_listener!='']");
	chromeOnPropListener.start(500,"_listener");
}
</script>
<script type="text/javascript">
if("<%=isclose%>"=="1" && "<%=isDialog%>"=="1"){
	parent.closeWinAFrsh('<%=templateid%>');	
}
</script>
<script type="text/javascript">
var isNotFunRuning = false;//不让触发事件
function wfbrowvaluechange(obj, fieldid, rowindex) {
	
}

function changeFirstBrowserShow(fid,index){
	var obj = jQuery("#field"+fid+"_"+index);
	var td = obj.closest("td");
	var div = td.find("#firstFielddiv"+fid);
	div.addClass("firstTdBrowserDiv");
	var span = div.find("[name^=detailIndexSpan]");
	span.css("float","left");
}
</script>
<style type="text/css">
td.promptValidateFail{
	background-color: yellow !important;
}
.del_id{
}
.Table_order{
	background-image: url('/formmode/images/tablesorter/bg_wev8.gif');
	background-repeat: no-repeat;
	background-position: center right;
	cursor: pointer;
	float:right;
}
.Table_asc{
	background-image: url('/formmode/images/tablesorter/asc_wev8.gif');
	background-repeat: no-repeat;
	background-position: center right;
	cursor: pointer;
	float:right;
}
.Table_desc{
	background-image: url('/formmode/images/tablesorter/desc_wev8.gif');
	background-repeat: no-repeat;
	background-position: center right;
	cursor: pointer;
	float:right;
}
._uploadForClass .progressBarInProgress {
	height:2px;
	background:#6b94fe;
	margin:0!important;
}
._uploadForClass .progressWrapper {
	height:30px!important;
	width:100%!important;
	border-bottom:1px solid #dadada;
}
._uploadForClass .progressContainer  {
	background-color:#f5f5f5!important;
	border:solid 0px!important;
	padding-top:5px!important;
	padding-left:0px!important;
	padding-right:0px!important;
	padding-bottom:5px!important;
	margin:0px!important;
}
._uploadForClass .progressCancel {
	width:20px!important;
	height:20px!important;
	background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;
}
._uploadForClass .progressBarStatus {
	display:none!important;
}
._uploadForClass .edui-for-wfannexbutton{
	cursor:pointer!important;
}
._uploadForClass .progressName{
	width:350px!important;
	height:18px;
	padding-left:5px;
	font-size:12px;
	font-weight:normal!important;
	white-space:nowrap;
	overflow:hidden;
	text-overflow:ellipsis;
	color:#242424;
}

.firstTdBrowser{
	display: inline;	
}
.firstTdBrowserDiv .jNiceWrapper{
	float: left;
}
.mapimage{
	vertical-align:middle;
	width:16px;
	height:16px;
	cursor:pointer;
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
ModeManageMenu.setBillid(Util.getIntValue(billid));
ModeManageMenu.setV_billid(billid);
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
ModeManageMenu.setVirtualForm(isVirtualForm);
if(!isPreview){ //预览屏蔽菜单
ModeManageMenu.getMenu();
}

HashMap urlMap = ModeManageMenu.getUrlMap();
RCMenu += ModeManageMenu.getRCMenu() ;

List<Map> cornerMenu = ModeManageMenu.getCornerMenu();

RCMenuHeight += ModeManageMenu.getRCMenuHeight() ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<%
		for(int i=0;i<cornerMenu.size();i++){ 
			Map m = (Map)cornerMenu.get(i);
		%>
			<span title="<%=m.get("name") %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="<%=m.get("href") %>" type="button" value="<%=m.get("name") %>"/>
			</span>
		<%} %>
		<%
		    String savename = "";
		    String editname = "";
			String executionMethod = "";
			String executionSaveMethod = "";
			sql = "select id,expendname,issystem,issystemflag from mode_pageexpand where modeid="+modeId+" and issystem=1 and (issystemflag=2 or issystemflag=3) and isshow=1 and showtype=2 and isbatch in(0,2) ";
			rs.executeSql(sql);
			//================
			String billidV;
			String vdatasource = null;	
			String vprimarykey = "id";	
			String v_billid = "";
			Map<String, Object> vFormInfo = new HashMap<String, Object>();
			FormManager fManager = new FormManager();
			if(isVirtualForm){
				billidV = v_billid;
				vFormInfo = VirtualFormHandler.getVFormInfo(formId);
				vdatasource = Util.null2String(vFormInfo.get("vdatasource"));	
				vprimarykey = Util.null2String(vFormInfo.get("vprimarykey"));	
			}else{
				billidV = billid;
			}
			//================
			while(rs.next()){
				String detailid = Util.null2String(rs.getString("id"));
				if(!expandBaseRightInfo.checkExpandRight(detailid, Util.null2String(modeId),billid)) {
					continue;
				}
				int issystem = rs.getInt("issystem");
				int issystemflag = rs.getInt("issystemflag");
				
				if(type == 0 && (iscreate.equals("1") || isEdit) && issystemflag==3){//编辑
					editname = Util.null2String(rs.getString("expendname"));
		   			executionMethod = "javascript:toEdit("+detailid+","+issystemflag+");";
		   		}
				if(type == 2 && issystemflag==2){//编辑保存
					savename = Util.null2String(rs.getString("expendname"));
					executionSaveMethod = "javascript:doSubmit("+detailid+","+issystemflag+");";	
				}
			}
			if(!StringHelper.isEmpty(executionMethod)){//编辑
				editname = "".equals(editname) ? SystemEnv.getHtmlLabelName(93,user.getLanguage()) : editname;
		%>
			<input type="button" value="<%=editname%>" id="zd_btn_edit" class="e8_btn_top" onclick="<%=executionMethod%>">
		<%}
			if(!StringHelper.isEmpty(executionSaveMethod)){//保存
				savename = "".equals(savename) ? SystemEnv.getHtmlLabelName(86,user.getLanguage()) : savename;
		%>
			<input type="button" value="<%=savename%>" id="zd_btn_save" class="e8_btn_top" onclick="<%=executionSaveMethod%>">
		<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
	</td>
	</tr>
</table>

<%if ("1".equals(isDialog)) {%>
<div class="zDialog_div_content">
<%} %>
<form enctype="multipart/form-data" action="/formmode/data/ModeDataOperation.jsp?1=1<%=addurl %>&isRefreshTree=<%=isRefreshTree %>&mainid=<%=mainid %>" name=frmmain id=frmmain method="post">
<input type="hidden" id="isopenbyself" name="isopenbyself" value="">
<input type="hidden" id="isNewPlugisBrowser" name="isNewPlugisBrowser" value="<%=isNewPlugisBrowser %>">
<input type="hidden" id="isNewPlugisSelect" name="isNewPlugisSelect" value="<%=isNewPlugisSelect %>">
<input type="hidden" id="isNewPlugisCheckbox" name="isNewPlugisCheckbox" value="<%=isNewPlugisCheckbox %>">
<input type="hidden" id="isFormMode" name="isFormMode" value="1">
<input type="hidden" id="subTableDocDelIds" name="subTableDocDelIds" value="">
<input type="hidden" id="istabinline" name="istabinline" value="<%=istabinline %>">
<input type="hidden" id="tabcount" name="tabcount" value="<%=tabcount %>">
<input type=hidden name="rand" value="<%=System.currentTimeMillis()%>">

	<TABLE class=Shadow>
	 <tr>
	 <td valign="top">
<%
//从新建文档后，跳转到编辑页面
//String sessionstr = user.getUID()+"_"+billid+"_docfieldid";
//String docfileid = Util.null2String((String)session.getAttribute(user.getUID()+"_"+billid+"_docfieldid"));
//session.removeAttribute(sessionstr);
String docfileid = Util.null2String(request.getParameter("adddocfieldid"));
String newdocid = Util.null2String(request.getParameter("docid")); // 新建文档的工作流字段String 			
Hashtable docmap = new Hashtable();
docmap.put("docfileid", docfileid);
docmap.put("newdocid", newdocid);

ResolveFormMode.setRequest(request);
ResolveFormMode.setUser(user);
ResolveFormMode.setIscreate(type);
ResolveFormMode.setRelateFieldMap(parentTabValueMap);
ResolveFormMode.setOtherPara_hs(docmap);
ResolveFormMode.setCustomid(customid);
ResolveFormMode.setVirtualForm(isVirtualForm);
ResolveFormMode.setAuthorizeOpttype(authorizeOpttype);
ResolveFormMode.setAuthorizeLayoutid(authorizeLayoutid);
ResolveFormMode.setAuthorizeLayoutlevel(authorizeLayoutlevel);
Hashtable ret_hs = ResolveFormMode.analyzeLayout();
layoutid = ResolveFormMode.getLayoutid();
String hasHtmlMode = (String)ret_hs.get("hasHtmlMode");

List uploadfieldids = ResolveFormMode.getUploadfieldids();
String trrigerdetailbuttonfield = ResolveFormMode.getTrrigerdetailbuttonfield();
if(hasHtmlMode.equals("0")){
%>
<script type="text/javascript">
alert("<%=SystemEnv.getHtmlLabelName(15808,user.getLanguage())%> <%=(modename+" "+status)%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%>);//未设置xx模板 
enableAllmenu();
</script>
<%
}
String formhtml = Util.null2String((String)ret_hs.get("formhtml"));
out.print(formhtml);

//新表单设计器,添加样式
int layoutversion=Util.getIntValue(Util.null2String(ret_hs.get("layoutversion")),0);
if(layoutversion==2){
	out.println(ret_hs.get("layoutcss"));
}

StringBuffer jsStr = ResolveFormMode.getJsStr();
StringBuffer htmlHiddenElementsb = ResolveFormMode.getHtmlHiddenElementsb();
out.println(htmlHiddenElementsb.toString());//把hidden的input输出到页面上

String needcheck = ResolveFormMode.getNeedcheck();

String src = type == 1?"submit":"save";
DynamicDataInput ddi = new DynamicDataInput(modeId+"",type,layoutid);

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
<input type=hidden name="isDialog" id="isDialog" value="<%=isDialog %>">
<input type=hidden name="templateid" id="templateid" value="<%=templateid %>">
<input type="hidden" id="currentLayoutId" name="currentLayoutId" value="<%=layoutid %>">
<input type="hidden" id="lastnodeid" name="lastnodeid" value="<%=lastnodeid %>">

<input type=hidden name=viewfrom id="viewfrom" value="<%=viewfrom%>">
<input type=hidden name=opentype id="opentype" value="<%=opentype%>">
<input type=hidden name=customid id="customid" value="<%=customid%>">
<input type=hidden name=isfromTab id="isfromTab" value="<%=isfromTab%>">
<input type="hidden" name="subnew" id="subnew" value="">
<input type=hidden name ="method"> <!--新建文档时method 为docnew-->
<input type=hidden name ="isMultiDoc" value=""><!--多文档新-->

<iframe id="selectChangeDetail" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputformdetail" frameborder=0 scrolling=no src=""  style="display:none" ></iframe>

<!-- 自定义页面-->
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

</form>
<%if ("1".equals(isDialog)) {%>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar"><!-- 关闭 -->
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="closePrtDlgARfsh('<%=templateid %>')">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
	
});
function closePrtDlgARfsh(templateid){
	window.parent.closeWinAFrsh(templateid);
}
</script>
<%} %>
<%
String isEnFormModeReply = "";
RecordSet.executeSql("select * from formEngineSet where isdelete=0");
if(RecordSet.next()){
	isEnFormModeReply = RecordSet.getString("isEnFormModeReply");
}
if("1".equals(isAllowReply) && "1".equals(isEnFormModeReply) && type==0){
%>
 <jsp:include page="/formmode/view/formModeCom.jsp" flush="true">
    <jsp:param name="modeId" value="<%=modeId%>" />
    <jsp:param name="formId" value="<%=formId%>" />
    <jsp:param name="billId" value="<%=billid%>" />
 </jsp:include>
<%}%>
<script type="text/javascript">
function changecancleon(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#f4fcff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","block");
}

function changecancleout(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#ffffff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","none");
}

function clearAllQueue(oUploadcancle){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())+SystemEnv.getHtmlLabelName(21407,user.getLanguage())%>?", function(){
		oUploadcancle.cancelQueue();
	}, function () {}, 320, 90,true);
}

function changebuttonon(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#8d8d8d");
	}
}

function uploadbuttonon(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#52ab2f");
	}
}

function changebuttonout(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#aaaaaa");
	}
}

function uploadbuttonout(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#6bcc44");
	}
}

function changefileaon(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#008aff!important;text-decoration:underline!important;");
}

function changefileaout(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#8b8b8b!important;text-decoration:none!important;");
}

function showProgressCancel(obj){
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-2px 0px!important;");
	if(!jQuery.browser.msie){//解决非ie浏览器时，表单建模附件字段属性联动必填不显示问题
		jQuery(obj).find(".progressCancel").click(function(){
		var fieldid = jQuery(obj).parent().attr("id").substr(16);
		if(jQuery("#needcheck").val().indexOf("field"+fieldid)>-1){
		var isReturn = false;
		var count = 0;
		jQuery("#fsUploadProgress"+fieldid+" .progressBarStatus").each(function(i,obj){
			if(jQuery(obj).text()!='Cancelled'){
				count++;
				return false
			}
		})
		if(count!=0){
			jQuery("#field_"+fieldid+"span").hide();
		}else{
			jQuery("#field_"+fieldid+"span").show();
		}
	}
	});
	}
}

function hideProgressCancel(obj){
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-14px 0px!important;");
	if(!jQuery.browser.msie){//解决非ie浏览器时，表单建模附件字段属性联动必填不显示问题
		jQuery(obj).find(".progressCancel").unbind("click"); 
	}
}
function viewLog(){
	window.open("/formmode/view/ModeLogView.jsp?modeId=<%=modeId%>&relatedId=<%=billid%>&initFlag=1");
	hideRightClickMenu();
}
function createQRCode(){
	<%
		int qrIsuse = 0;//二维码是否启用
		RecordSet2.executeSql("select isuse from ModeQRCode where modeid="+modeId);
		if (RecordSet2.next()) {
			qrIsuse = RecordSet2.getInt("isuse");
		}
	%>
	if(<%=qrIsuse==0%>) {
		alert("<%=SystemEnv.getHtmlLabelName(125710 ,user.getLanguage()) %>"); //二维码功能尚未开启，请在后台开启二维码功能
   	 	return;
	}
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 360;
	diag_vote.Height = 150;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(125511 ,user.getLanguage()) %>";//生成二维码
	diag_vote.maxiumnable = true;
	diag_vote.URL = "/formmode/view/QRCodeView.jsp?modeId=<%=modeId%>&formId=<%=formId%>&customid=<%=customid%>&billid=<%=billid%>";
	diag_vote.show();
	hideRightClickMenu();
}

function createBARCode(){
	<%
		int barIsused = 0;//条形码是否启用
		RecordSet2.executeSql("select isused from mode_barcode where modeid="+modeId);
		if (RecordSet2.next()) {
			barIsused = RecordSet2.getInt("isused");
		}
	%>
	if(<%=barIsused==-1%>) {
		alert("<%=SystemEnv.getHtmlLabelName(127216 ,user.getLanguage()) %>"); //条形码功能尚未开启，请在后台开启条形码功能
   	 	return;
	}
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 360;
	diag_vote.Height = 150;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(126683 ,user.getLanguage()) %>";//生成条形码
	diag_vote.maxiumnable = true;
	diag_vote.URL = "/formmode/view/BARCodeView.jsp?modeId=<%=modeId%>&formId=<%=formId%>&customId=<%=customid%>&billId=<%=billid%>";
	diag_vote.show();
	hideRightClickMenu();
}


<%
Iterator it = urlMap.entrySet().iterator();
while (it.hasNext()) {
	Entry entry = (Entry) it.next();
	String detailid = Util.null2String((String)entry.getKey());
	String hreftarget = Util.null2String((String)entry.getValue());
	hreftarget = hreftarget.replace("\"","\\\"");
	hreftarget = hreftarget.replaceAll("\r\n","");
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
			setFieldValueAjax(msg,fieldid,fieldid,true);//其中个fieldid，只是用来区分当前字段是主字段还是明细字段，所以在这里用fieldid代替
		}
	});
}

//字段属性联动依赖的全局对象
var mode__info = {
	"billid": "<%=billid%>",
	"modeid": "<%=modeId %>",
	"formid": "<%=formId %>",
	"layoutid": "<%=layoutid%>",
	"f_bel_userid": "<%=user.getUID() %>",
	"f_bel_usertype": "0",
	"onlyview": <%=type!=1 && type!=2%>,
	"datassplit": "<%=FieldAttrManager.DATAS_SEPARATOR %>",
	"paramsplit": "<%=FieldAttrManager.PARAM_SEPARATOR %>",
	"valuesplit": "<%=FieldAttrManager.VALUE_SEPARATOR %>"
};
<%
out.println(jsStr.toString());
%>
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
   	var thisWin = window;
   	var parentWin = thisWin.parent;
   	var href = parent.location.href;
   	if(href.indexOf("AddFormMode.jsp")!=-1){
   		thisWin = thisWin.parent;
   		parentWin = thisWin.parent.parent;
   	}
   	if("<%=isfromTab%>"=="1"){
   		parentWin.location.href = url;
	}else{
		thisWin.location.href = url;
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
		async : true,//改为异步
		success: function do4Success(msg){
			if(typeof(callBackFun)=="function"){//当ajax返回后再执行后续动作
				if(param1){
					callBackFun(param1);
				}else{
		        	callBackFun();
				}
	        }
			//返回成功后，如果是dialog页面，则关闭页面
			<%if ("1".equals(isDialog)) {%>
				window.parent.closeWinAFrsh('<%=templateid%>');
			<%} %>
		}
	});
	if(typeof(callBackFun)!="function"){
		return true;
	}
}

function windowOpenOnNew(detailid,issystemflag){
	//执行接口动作
    doInterfacesAction(detailid,issystemflag,windowOpenOnNewCallBack,detailid)
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
	if(typeof(onDelBefore)=='function'){
		try{
			var flag = onDelBefore();
			if(!flag){
				displayAllmenu();
				return false;
			}
		}catch(e){
			displayAllmenu();
			alert('<%=SystemEnv.getHtmlLabelName(30686,user.getLanguage())%>onDelBefore<%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())+SystemEnv.getHtmlLabelName(32104,user.getLanguage())%>:'+e.description);
			return false;
		}
	}
	if(<%=isDel%>){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			frmmain.src.value="del";
			frmmain.submit();
		});
	}
}
function toEdit(detailid,issystemflag){
	//执行接口动作
    doInterfacesAction(detailid,issystemflag,toEditCallBack);
}

function toEditCallBack(){
	var url="/formmode/view/AddFormMode.jsp?isfromTab=0&modeId=<%=modeId%>&formId=<%=formId%>&type=2&billid=<%=billid%>&viewfrom=<%=viewfrom%>&opentype=<%=opentype%>&customid=<%=customid%>&isRefreshTree=<%=isRefreshTree%>&mainid=<%=mainid%>&istabinline=<%=istabinline%>&tabcount=<%=tabcount%>";
	var istabinline = $G("istabinline").value;
	var tabcount = $G("tabcount").value;
	if(istabinline==1){
		if(tabcount==0){
			url="/formmode/view/AddFormModeIframe.jsp?isfromTab=0&modeId=<%=modeId%>&formId=<%=formId%>&type=2&billid=<%=billid%>&viewfrom=<%=viewfrom%>&opentype=<%=opentype%>&customid=<%=customid%>&isRefreshTree=<%=isRefreshTree%>&mainid=<%=mainid%>&istabinline=<%=istabinline%>&tabcount=<%=tabcount%>";
			window.location.href = url;
		}else{
			window.parent.location.href = url;
		}
		return;
	}
	var isfromTab="<%=isfromTab%>";
	if(isfromTab=="1"){
		window.parent.parent.location.href = url;
	}else{
		window.parent.location.href = url;
	}
}

function doprint(){
	openFullWindowHaveBar("/formmode/view/FormModePrint.jsp?isfromTab=<%=isfromTab%>&modeId=<%=modeId%>&formId=<%=formId%>&type=4&billid=<%=billid%>&viewfrom=<%=viewfrom%>&opentype=<%=opentype%>&customid=<%=customid%>");
}

function doBackCustomSearch(){
	var parent = window.parent;
	if(parent.location.href.indexOf("AddFormMode.jsp")!=-1){
		parent.location.href = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=customid%>";
	}else if(parent.location.href==window.location.href){
		window.location.href = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=customid%>";
	}
}

function doBack(){
	window.location.href="/formmode/view/AddFormModeIframe.jsp?isfromTab=<%=isfromTab%>&modeId=<%=modeId%>&formId=<%=formId%>&type=0&billid=<%=billid%>&iscreate=<%=iscreate%>&viewfrom=<%=viewfrom%>&opentype=<%=opentype%>&customid=<%=customid%>&isRefreshTree=<%=isRefreshTree%>&istabinline=<%=istabinline%>&tabcount=<%=tabcount%>";
}
function doViewBack(){
	if("<%=viewfrom%>"=="fromsearchlist"&"<%=opentype%>"=="1"&&<%=isfromTab%>=="1"){
		window.parent.location = "/formmode/search/CustomSearchBySimpleIframe.jsp?customid=<%=customid%>";
	}else{
		window.location = "/formmode/search/CustomSearchBySimpleIframe.jsp?customid=<%=customid%>";
	}
}
function doShare(){
	var url = escape("/formmode/view/ModeShare.jsp?ajax=2&modeId=<%=modeId%>&billid=<%=billid%>&MaxShare=<%=MaxShare%>");

	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%>";//共享
	diag_vote.URL = "/systeminfo/BrowserMain.jsp?url="+url;
	diag_vote.show();
}

//创建文档
function onNewDoc(fieldid) {
	frmmain.action = "/formmode/data/ModeDataOperation.jsp";
	frmmain.method.value = "docnew_"+fieldid;
	frmmain.isMultiDoc.value = fieldid ;
	document.frmmain.src.value = "save";
	//附件上传
	StartUploadAll();
	checkuploadcomplet();
}

function closeDialog(){
	diag_vote.close();
}
function closeDlgARfsh(){
	diag_vote.close();
	doSearchsubmit();
}

function doImportDetail() {
	<%
	if(fromSave != 1){
	%>
	if (confirm("<%=SystemEnv.getHtmlLabelName(28504,user.getLanguage())%>")) {//数据还未保存,现在保存吗？
		frmmain.fromImportDetail.value="1";
		doSubmit();
	}
	<%}else{%>
		var url = escape("/formmode/view/ModeDetailImport.jsp?ajax=1&modeId=<%=modeId%>&billid=<%=billid%>");
		var dialogurl = "/systeminfo/BrowserMain.jsp?url=" + url;
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = dialogurl;
		dialog.callbackfun = function (paramobj, msg) {
			Dialog.alert(msg,function(){
				window.location.reload();
			});
		} ;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
		dialog.Width = 550 ;
		dialog.Height = 600;
		dialog.Drag = true;
		
		if(!checkDataChange()){
	        if(confirm("<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>")){//所做的改动还没保存，如果离开，将会丢失数据，真的要离开吗？
	            dialog.show();
	        }
	    }else{
	        dialog.show();
	    }
	<%}%>
}

function returnTrue(o){
	return;
}

function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);
}

function downloads(docId){
	top.location='/weaver/weaver.file.FileDownload?fileid='+docId+'&download=1&requestid=-1';
}

function downloadsBatch(docIds,requestid){
	top.location="/weaver/weaver.file.FileDownload?fieldvalue="+docIds+"&download=1&downloadBatch=1&requestid="+requestid;
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

function changeChildSelectItemField(obj, fieldid, childfieldid,isinit){
	if(isinit&&isinit==1){//编辑时初始化
		obj = $G("field"+fieldid);
	}
	if(!obj){
		obj = $G("field"+fieldid);
	}
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
    if(isinit&&isinit==1){
    	paraStr = paraStr + "&isinit="+isinit;
    }
    
    $G("selectChange").src = "/formmode/search/SelectItemChange.jsp?"+paraStr;
}

function changeChildSelectItemDetailField(obj, fieldid, childfieldid,rownum,isinit){
	if(isinit&&isinit==1){//编辑时初始化
		obj = $G("field"+fieldid+"_"+rownum);
	}
	if(!obj){
		obj = $G("field"+fieldid+"_"+rownum);
	}
	
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&selectvalue="+obj.value+"&isdetail=1&&rowindex="+rownum;
    if(isinit&&isinit==1){
    	paraStr = paraStr + "&isinit="+isinit;
    }
    var iframe = jQuery("#iframe_"+childfieldid+"_"+fieldid+"_"+rownum);
    if(iframe.length>0){
    	iframe.get(0).src = "/formmode/search/SelectItemChange.jsp?"+paraStr;
    }else{
	    $G("selectChangeDetail").src = "/formmode/search/SelectItemChange.jsp?"+paraStr;
    }
}

function changeChildField(obj, fieldid, childfieldid){
	changeChildFieldAjax(obj, fieldid, childfieldid, '', '');
    //var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
    //$G("selectChange").src = "/workflow/request/SelectChange.jsp?"+paraStr;
}

function changeChildFieldDetail(obj, fieldid, childfieldid, rownum){
	if (isNotFunRuning) return;
	changeChildFieldAjax(obj, fieldid, childfieldid, '1', rownum);
    //var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&selectvalue="+obj.value+"&isdetail=1&&rowindex="+rownum;
    //$G("selectChangeDetail").src = "/workflow/request/SelectChange.jsp?"+paraStr;
}

function changeChildFieldAjax(obj, fieldid, childfieldid, isdetail, rownum){
	var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&selectvalue="+obj.value+"&isdetail=1&&rowindex="+rownum;
	var yz=jQuery.ajax({    
     type:'post',    
     url:'/formmode/view/SelectChangeAjax.jsp?'+paraStr,    
     cache:false,    
     dataType:'json',
     async : false,
     success:function(data){
        if(data){
        	var fieldname = "";//被联动的下拉框字段
        	if(isdetail == 0){
				fieldname = "field"+childfieldid;
			}else{
				fieldname = "field"+childfieldid+"_"+rownum;
			}
			jQuery("#"+fieldname).get(0).options.length = 0;//清空option
			jQuery("#"+fieldname).append("<option></option>");//添加空值
			jQuery(data).each(function(index,val){//循环添加值
			    jQuery("#"+fieldname).append("<option value='"+val.value+"'>"+val.text+"</option>");
			})
			var selectObj = jQuery("#"+fieldname);
			var onchangeStr = selectObj.attr('onchange');
			if(onchangeStr&&onchangeStr!=""){
				var selObj = selectObj.get(0);
				if (selObj.fireEvent){
					selObj.fireEvent('onchange');
				}else{
					selObj.onchange();
				}
			}
        }
      },    
      error:function(){}    
	});   

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
		if (isNotFunRuning) return;
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
		if (isNotFunRuning) return;
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
	try{
	<%
	int checkdetailno = 0;
	rs.execute("select orderid from Workflow_billdetailtable where billid="+formId+" order by orderid");
	while(rs.next()) {
		checkdetailno = rs.getInt("orderid")-1;%>
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
	<%}%>
	}catch(e){}
}


function setTabButtonUsage(flag){
	var btnDiv = parent.jQuery("#tabcontentframe_box");
	var btns = btnDiv.find("input[type=button]");
		for(var i=0;i<btns.length;i++){
		if(flag){
		    jQuery(btns.get(i)).css("color","#ccc");
		}else{
		    jQuery(btns.get(i)).css("color","");
		}
		jQuery(btns.get(i)).attr("disabled",flag);	
	}
}

function doSubmit(detailid,issystemflag){
    setTabButtonUsage(true);
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
   	if(modenum>0) {
   	    setTabButtonUsage(false);		
   		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+modenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");//必须填写xx 个明细表数据，请填写
		displayAllmenu();		
   		return false;
   	}
   	
	if(typeof(checkCustomize)=='function'){
		try{
			var flag = checkCustomize();
			if(!flag){			
				setTabButtonUsage(false);
				displayAllmenu();
				return false;
			}
		}catch(e){
			setTabButtonUsage(false);
			displayAllmenu();
			alert('<%=SystemEnv.getHtmlLabelName(30686,user.getLanguage())%>checkCustomize<%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())+SystemEnv.getHtmlLabelName(32104,user.getLanguage())%>:'+e.description);
			return false;
		}
	}	
	if(ischeckok=="true"){
		StartUploadAll();
		checkuploadcomplet();
	}else{
		displayAllmenu();
		setTabButtonUsage(false);
	}
}

function doSubNew(detailid,issystemflag){
	frmmain.subnew.value="1";
	doSubmit(detailid,issystemflag);
}
function onShowBrowser3(id,url,linkurl,type1,ismand) {
	onShowBrowser2(id, url, linkurl, type1, ismand, 3);
}

function onShowBrowser2_old(id,url,linkurl,type1,ismand, funFlag) {
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
	    if (type1 != 256 && type1 != 257&&type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170 && type1!=194) {
	    	if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
	    		id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
	    	} else {
			    if (type1 == 161||type1 == 224||type1 == 225||type1 == 226||type1 == 227) {
				    id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
				} else {
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
	    	}
		} else {
	        if (type1 == 135) {
				tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170 || type1 == 194) {
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
					id1 = window.showModalDialog(url, "", "dialogWidth=700px;dialogHeight=550px");
				} else {
					url = url + "|" + id + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, window, "dialogWidth=700px;dialogHeight=550px");
				}
			} else if (type1 == 256|| type1==257) {
				tmpids = $GetEle("field"+id).value;
				url = url + "&selectedids=" + tmpids;
				url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
				id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
			}else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
		        index = (id + "").indexOf("_");
		        if (index != -1) {
		        	tmpids=uescape("?isdetail=1&isbill=1&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle("field"+id).value+"&selectedids="+$GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else {
		        	tmpids = uescape("?fieldid=" + id + "&isbill=1&resourceids=" + $GetEle("field" + id).value+"&selectedids="+$GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        }
			} else {
		        tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			}
		}
	    if (id1 != undefined && id1 != null) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170 || type1==194) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = ""
					
					if(resourceids!=""&&resourceids.indexOf(",")==0){
						resourceids = resourceids.substr(1);
					}
					if(resourcename!=""&&resourcename.indexOf(",")==0){
						resourcename = resourcename.substr(1);
					}
					
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
			   if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
	               if (type1 == 162) {
				   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						var href = wuiUtil.getJsonValueByIndex(id1, 3);
						sHtml = ""
						if(ids.indexOf(",") == 0){
							ids = ids.substr(1);
							names = names.substr(1);
							descs = descs.substr(1);
						}
						$GetEle("field"+id).value= ids;
						var idArray = ids.split(",");
						var nameArray = names.split(",");
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
				   if(type==257){
					    var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var sHtml = ""
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							sHtml += curname + "&nbsp";
						}
						$GetEle("field"+id).value= ids;
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return;
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

function onShowBrowser2(id,url,linkurl,type1,ismand, funFlag, _fieldStr) {
	//if(<%=isNewPlugisBrowser!=1%>){// 不适应旧的browser   旧的browser方法在Google下会出现异常 Google新版本不支持window.showModalDialog --mcw 2014-11-3
	if(false){
		onShowBrowser2_old(id,url,linkurl,type1,ismand, funFlag);
	}else{
		var ismast = 1;//2：必须输：可编辑
		if (ismand == 0) {
			ismast = 1;
		}else{
			ismast = 2;
		}
		var dialogurl = url;
		
		if(_fieldStr==null){
			_fieldStr = "field";
		}
	
		var id1 = null;
		
		if (type1 == 23) {
			url += "?billid=<%=formId%>";
		}
		if (type1 == 224||type1 == 225||type1 == 226||type1 == 227) {
			if(url.indexOf("|")==-1){
				url += "|"+id;
			}else{
				var index = url.indexOf("|");
				url = url.substring(0,index);
				url += "|"+id;
			}
			if(url.indexOf("-")==-1){
				if(id.split("_")[1]){
					//zzl-拼接行号
					url += "_"+id.split("_")[1];
				}
			}
			dialogurl = url;
		}
		
		
		if (type1 == 2 || type1 == 19 ) {
		    spanname = _fieldStr + id + "span";
		    inputname = _fieldStr + id;
		    var isMustInput = jQuery("#"+inputname).attr("isMustInput");
		    if(isMustInput){
		    	if(isMustInput=="2"){//必填
		    		ismand = 1;
		    	}else if(isMustInput=="1"){//可编辑
		    		ismand = 0;
		    	}
		    }
			if (type1 == 2) {
				onFlownoShowDate(spanname,inputname,ismand);
			} else {
				onWorkFlowShowTime(spanname, inputname, ismand);
			}
		} else {
		    if (type1 != 256&&type1 != 257&&type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170 && type1!=194) {
		    	if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
		    		//id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
		    	} else {
		    		if (type1 == 161) {
					    //id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
					    dialogurl = url + "|" + id;
		    		}
		    	}
			} else {
	
		        if (type1 == 135) {
					tmpids = $GetEle(_fieldStr+id).value;
					dialogurl = url + "?projectids=" + tmpids;
					//id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        //} else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) { 
		        //type1 = 167 分权单部分部 不应该包含在这里ypc 2012-09-06 修改
		       } else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170 || type1 == 194) {
			        tmpids = $GetEle(_fieldStr+id).value;
			        dialogurl = url + "?selectedids=" + tmpids;
					//id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else if (type1 == 37) {
			        tmpids = $GetEle(_fieldStr+id).value;
			        dialogurl = url + "?documentids=" + tmpids;
					//id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else if (type1 == 142 ) {
			        tmpids = $GetEle(_fieldStr+id).value;
			        dialogurl = url + "?receiveUnitIds=" + tmpids;
					//id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
				} else if (type1 == 162 ) {
					tmpids = $GetEle(_fieldStr+id).value;
	
					if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
						url = url + "&beanids=" + tmpids;
						url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
						dialogurl = url;
						//id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
					} else {
						url = url + "|" + id + "&beanids=" + tmpids;
						url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
						dialogurl = url;
						//id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
					}
				}else if (type1 == 256|| type1 == 257) {
					tmpids = $GetEle(_fieldStr+id).value;
					var url1 = "/formmode/browser/CommonBrowserSqlAjax.jsp";
					var treerootnode = "";
					jQuery.ajax({
						url : url1,
						type : "post",
						processData : false,
						data : "fieldid="+id,
						dataType : "json",
						async : false,//改为同步
						success: function(msg){
							if(msg!=null){
								var fhtm = msg.fieldHtmlTypeMap;
								//sqlwhere = msg.sqlwhere.sql;
								for(var k in fhtm){
									var field_id = k;
									var field_type =fhtm[field_id].split("_")[0];
									var type =fhtm[field_id].split("_")[1];
									var vv = document.getElementById("field"+field_id);
									var _value = "";
									if(vv){
										if(field_type=='2'){//textarea
											_value = vv.innerHTML;
										}else if(field_type=='4'){//checkbox
											if(vv.checked){
												_value = "1";
											}else{
												_value = "0";
											}
										}else if(field_type=='5'){//select
											var _value_index = vv.selectedIndex;
											_value = vv.options[_value_index].value;
										}else if(field_type=='1'&&(type=='2'||type=='3'||type=='4'||type=='5')){
											if(vv.value==''){
												_value = '';
											}else{
												_value = vv.value;
											}
										}else{
											_value = vv.value;
											if(type=='256'||type=='257'){
												var values = _value.split(",");
												var splitValue ="";
												for(var i =0;i<values.length;i++){
													var index = values[i].indexOf("_")+1;
													splitValue+=values[i].substring(index)+",";
												}
												if(splitValue!=null&&splitValue!=''){
													splitValue = splitValue.substring(0,splitValue.length-1);
													_value = splitValue;
												}
											}
										
										}
										/*if(_value!=null&&_value!=''){
											treerootnode +=_value+",";
										}*/
										
									}
								}
							}
						}
						});
					//执行js
					if(typeof(getTreerootNode)=='function'){
						try{
							var json = getTreerootNode();
							var treeNode = json[_fieldStr+id];
							if(treeNode!=undefined){
								treerootnode += treeNode;
							}
							
						}catch(e){
							alert('<%=SystemEnv.getHtmlLabelName(30686,user.getLanguage())%>getTreerootNode<%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())+SystemEnv.getHtmlLabelName(32104,user.getLanguage())%>:'+e.description);
						}
					} else {
						if(treerootnode!=null&&treerootnode!=''){
							treerootnode = treerootnode.substring(0,treerootnode.length-1);
						}
					}
					url = url + "_" + type1 + "&selectedids=" + tmpids+"&treerootnode="+treerootnode;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					dialogurl = url;
					//id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
			        index = (id + "").indexOf("_");
			        if (index != -1) {
			        	tmpids=uescape("?isdetail=1&isbill=1&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle(_fieldStr+id).value+"&selectedids="+$GetEle(_fieldStr+id).value);
			        	dialogurl = url + tmpids;
			        	//id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			        } else {
			        	tmpids = uescape("?fieldid=" + id + "&isbill=1&resourceids=" + $GetEle(_fieldStr + id).value+"&selectedids="+$GetEle(_fieldStr+id).value);
			        	dialogurl = url + tmpids;
			        	//把此行的dialogWidth=550px; 改为600px
			        	//id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=600px;dialogHeight=550px");
			        }
				} else {
			        tmpids = $GetEle(_fieldStr + id).value;
			        dialogurl = url + "?resourceids=" + tmpids;
					//id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
				}
			}
			
			if(type1==161||type1==162){//自定义单选和自定义多选解析sqlwhere和sqlcondition
				var url1 = "/formmode/browser/CommonBrowserSqlAjax.jsp";
				var sqlwhere = "";
				var sqlcondition = "";
				jQuery.ajax({
					url : url1,
					type : "post",
					processData : false,
					data : "fieldid="+id,
					dataType : "json",
					async : false,//改为同步
					success: function(msg){
						var fhtm = msg.fieldHtmlTypeMap;
						if(msg.sqlwhere){
							sqlwhere = msg.sqlwhere.sql;
							for(var k in fhtm){
								var field_id = k;
								var field_type =fhtm[field_id].split("_")[0];
								var type =fhtm[field_id].split("_")[1];
								var vv = document.getElementById("field"+field_id);
								var _value = "";
								if(vv){
									if(field_type=='2'){//textarea
										_value = vv.innerHTML;
									}else if(field_type=='4'){//checkbox
										if(vv.checked){
											_value = "1";
										}else{
											_value = "0";
										}
									}else if(field_type=='5'){//select
										var _value_index = vv.selectedIndex;
										_value = vv.options[_value_index].value;
									}else if(field_type=='1'&&(type=='2'||type=='3'||type=='4'||type=='5')){
										if(vv.value==''){
											_value = '';
										}else{
											_value = vv.value;
										}
									}else{
										_value = vv.value;
									}
									sqlwhere = sqlwhere.replace("$"+field_id+"$",_value);
								}
							}
						}
						if(msg.sqlcondition){
							for(var k in msg.sqlcondition){
								var v = msg.sqlcondition[k];
								var field_id = v;
								if(field_id.indexOf("-")>-1&&field_id.split("-").length==2){
									var field_id1 = field_id.split("-")[0];
									var field_type1 = fhtm[field_id1].split("_")[0];
									var type1 =fhtm[field_id1].split("_")[1];
									var vv1 = document.getElementById("field"+field_id1);
									var field_id2 = field_id.split("-")[1];
									var field_type2 = fhtm[field_id2].split("_")[0];
									var type2 =fhtm[field_id2].split("_")[1];
									var vv2 = document.getElementById("field"+field_id2);
									if(field_type1=='1'&&field_type2=='1'){
										if((type1=='2'||type1=='3'||type1=='4'||type1=='5')
											&&(type1==type2)){
											if(vv1&&vv2){
												var _value1 = vv1.value;
												var _value2 = vv2.value;
												sqlcondition += " {&} "+k+"="+_value1+"-"+_value2;
											}
										}
									}
								}else{
									var field_type = fhtm[field_id].split("_")[0];
									var type =fhtm[field_id].split("_")[1];
									var vv = document.getElementById("field"+field_id);
									if(vv){
										if(field_type=='2'){//textarea
											var _value = vv.innerHTML;
											sqlcondition += " {&} "+k+"="+_value+"";
										}else if(field_type=='4'){//checkbox
											if(vv.checked){
												sqlcondition += " {&} "+k+"=1";
											}else{
												sqlcondition += " {&} "+k+"=";
											}
										}else if(field_type=='5'){//select
											var _value_index = vv.selectedIndex;
											var _value = vv.options[_value_index].value;
											sqlcondition += " {&} "+k+"="+_value;
										}else{
											var _value = vv.value;
											sqlcondition += " {&} "+k+"="+_value;
										}
										i++;
									}
								}
							}
						}
					}
				});
				if(sqlwhere!=""){
					sqlwhere = encodeURIComponent(sqlwhere);
					dialogurl += "&sqlwhere="+sqlwhere;
				}
				if(sqlcondition!=""){
					sqlcondition = encodeURIComponent(sqlcondition);
					dialogurl += "&sqlcondition="+sqlcondition;
				}
			}
			
			 var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			//dialog.callbackfunParam = null;
			dialog.URL = dialogurl;
			dialog.callbackfun = function (paramobj, id1) {
				if (id1 != undefined && id1 != null) {
					if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170 || type1==194) {
						if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
							var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
							var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
							var sHtml = ""
							
							if (resourceids.indexOf(",") == 0) {
								resourceids = resourceids.substr(1);
								resourcename = resourcename.substr(1);
							}
							var resourceIdArray = resourceids.split(",");
							var resourceNameArray = resourcename.split(",");
							for (var _i=0; _i<resourceIdArray.length; _i++) {
								var curid = resourceIdArray[_i];
								var curname = resourceNameArray[_i];
								if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
									sHtml += wrapshowhtml("<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp", curid,ismast);
								} else {
									sHtml += wrapshowhtml("<a href=" + linkurl + curid + " target=_blank>" + curname + "</a>&nbsp", curid,ismast);
								}
								
							}
							jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
							showOrHideBrowserImg(ismand,_fieldStr,id,resourceids);
							$GetEle(_fieldStr + id).value= resourceids;
						} else {
		 					$GetEle(_fieldStr+id).value="";
							jQuery($GetEle(_fieldStr+id+"span")).html("");
							showOrHideBrowserImg(ismand,_fieldStr,id,"");
						}
		
					} else {
					   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
			               if (type1 == 162) {
						   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
								var names = wuiUtil.getJsonValueByIndex(id1, 1);
								var descs = wuiUtil.getJsonValueByIndex(id1, 2);
								var href = wuiUtil.getJsonValueByIndex(id1, 3);
								sHtml = ""
								if(ids.indexOf(",") == 0){
									ids = ids.substr(1);
									names = names.substr(1);
									descs = descs.substr(1);
								}
								$GetEle(_fieldStr+id).value= ids;
								var idArray = ids.split(",");
								var nameArray = names.split(",");
								var descArray = descs.split(",");
								for (var _i=0; _i<idArray.length; _i++) {
									var curid = idArray[_i];
									var curname = nameArray[_i];
									var curdesc = descArray[_i];
									if(curdesc==''||curdesc=='undefined'||curdesc==null){
										curdesc = curname;
									}
									if(curdesc){
										curdesc = curname;
									}
        		                    curname = curname.replace(new RegExp(/(<)/g),"&lt;");
        		                    curname = curname.replace(new RegExp(/(>)/g),"&gt;");
									//sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
									if(href==''){
										sHtml += wrapshowhtml("<a title='" + curdesc + "' >" + curname + "</a>&nbsp", curid,ismast);
									}else{
									    var tempurl = dealChineseOfFieldParams(href + curid);
										sHtml += wrapshowhtml("<a title='" + curdesc + "' href='" + tempurl + "' target='_blank'>" + curname + "</a>&nbsp", curid,ismast);
									}
								}
								
								jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
								showOrHideBrowserImg(ismand,_fieldStr,id,ids);
			               }
						   if (type1 == 161) {
							   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
							   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
								var descs = wuiUtil.getJsonValueByIndex(id1, 2);
								var href = wuiUtil.getJsonValueByIndex(id1, 3);
								$GetEle(_fieldStr+id).value = ids;
								names = names.replace(new RegExp(/(<)/g),"&lt;")
        		                names = names.replace(new RegExp(/(>)/g),"&gt;")
								//sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
								if(href==''){
									sHtml = wrapshowhtml("<a title='" + descs + "'>" + names + "</a>&nbsp", ids,ismast);
								}else{
								    var tempurl = dealChineseOfFieldParams(href + ids);
									sHtml = wrapshowhtml("<a title='" + descs + "' href='" + tempurl + "' target='_blank'>" + names + "</a>&nbsp", ids,ismast);
								}
								jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
								showOrHideBrowserImg(ismand,_fieldStr,id,ids);
						   }
		            	    if (linkurl == "") {
		            	    	if(type1==256||type1==257){
		            	    		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
		            	    		var names = wuiUtil.getJsonValueByIndex(id1, 1);
		            	    		var idArray = ids.split(",");
		            	    		var nameArray = names.split(">,");
		            	    		var sHtml = "";
		            	    		for (var _i=0; _i<idArray.length; _i++) {
										var curid = idArray[_i];
										var curname = (idArray.length-1==_i) ? nameArray[_i] : nameArray[_i] + ">";
										sHtml += wrapshowhtml( curname + "&nbsp", curid,ismast);
									}
						        	jQuery($GetEle(_fieldStr + id + "span")).html(sHtml);
		            	    	}else if(type1==161||type1==162){
						        	jQuery($GetEle(_fieldStr + id + "span")).html(sHtml);
		            	    	}else{
						        	jQuery($GetEle(_fieldStr + id + "span")).html(wrapshowhtml(wuiUtil.getJsonValueByIndex(id1, 1),"",ismast));
		            	    	}
					        } else {
								if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
									jQuery($GetEle(_fieldStr+id+"span")).html(wrapshowhtml("<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp", wuiUtil.getJsonValueByIndex(id1, 0),ismast));
								} else {
									jQuery($GetEle(_fieldStr+id+"span")).html(wrapshowhtml("<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>", wuiUtil.getJsonValueByIndex(id1, 0),ismast));
								}
					        }
			               	if(type1!=161&&type1!=162){
					        	$GetEle(_fieldStr+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
			               		showOrHideBrowserImg(ismand,_fieldStr,id,$GetEle(_fieldStr+id).value);
					        }
					   } else {
							$GetEle(_fieldStr+id).value="";
							jQuery($GetEle(_fieldStr+id+"span")).html("");
							showOrHideBrowserImg(ismand,_fieldStr,id,"");
					   }
					}
				}
				hoverShowNameSpan(".e8_showNameClass");
				try {
					//eval(jQuery("#"+ _fieldStr + id).attr('onpropertychange'));
					eval(jQuery("#"+ _fieldStr + id + "__").attr('onpropertychange'));
				} catch (e) {
				}
			} ;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
			dialog.Width = 550 ;
			if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
				dialog.Width=648; 
			}
			dialog.Height = 600;
			dialog.Drag = true;
			//dialog.maxiumnable = true;
			dialog.show();
			
		    
		}
	}
}



//联动属性
function changeshowattr(fieldid,fieldvalue,rownum,workflowid,nodeid){
    len = document.forms[0].elements.length;
    var ajax=ajaxinit();
    ajax.open("POST", "/formmode/view/FormModeChanegAttrAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("modeId=<%=modeId%>&type=<%=ResolveFormMode.getLayoutid()%>&fieldid="+fieldid+"&fieldvalue="+fieldvalue);
    // 获取执行状态
    ajax.onreadystatechange = function() {
        // 如果执行状态成功，那么就把返回信息写到指定的层
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
				    if(fieldattr==4){ // 没有设置联动，恢复原值和恢复原显示属性
                       for(i=0;i<len;i++){
                          for(j=0;j<fieldidarray.length;j++){
                              var tfieldidarray=fieldidarray[j].split("_");
                              if (tfieldidarray[1]==isdetail){
                               if(rownum>-1){ 
                                               if($GetEle('field'+tfieldidarray[0]+rownum+'span')!=null){
                                                  jQuery('#field'+tfieldidarray[0]+rownum+'span').css('display','none');
                                               }
                                               if($GetEle('field'+tfieldidarray[0]+"_"+rownum+'_browserbtn')!=null){
                                                    jQuery('#field'+tfieldidarray[0]+"_"+rownum+'_browserbtn').css('display','none');
													if($GetEle('field'+tfieldidarray[0]+"_"+rownum+'wrapspan')!=null){
													  jQuery('#field'+tfieldidarray[0]+"_"+rownum+'wrapspan').css('display','none');
													}
                                                }
                                            	if($GetEle('field'+tfieldidarray[0]+'_'+rownum)!=null){
                                                    jQuery('#field'+tfieldidarray[0]+'_'+rownum).css('display','none');        	
                                                }
												if($GetEle('field_lable'+tfieldidarray[0]+'span_'+rownum)!=null){
												   jQuery('#field_lable'+tfieldidarray[0]+'span_'+rownum).css('display','none'); 
												}
												if($GetEle('field_lable'+tfieldidarray[0]+'_'+rownum)!=null){
												   jQuery('#field_lable'+tfieldidarray[0]+'_'+rownum).css('display','none'); 
												}if($GetEle('field_chinglish'+tfieldidarray[0]+'span_'+rownum)!=null){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'span_'+rownum).css('display','none'); 
												}
												if($GetEle('field_chinglish'+tfieldidarray[0]+'_'+rownum)!=null){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'_'+rownum).css('display','none'); 
												}
                                            	//判断附件字段
                                                if($GetEle("fsUploadProgress"+tfieldidarray[0]+'_'+rownum)){
                                                	jQuery("#field_"+tfieldidarray[0]+"span_"+rownum).css('display','none');    
                                                }
												
												else{
											      if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
                                                   }
                                             }
                                   }else{     // 主字段
                                             if($GetEle('field'+tfieldidarray[0]+"span")!=null){
                                                  jQuery('#field'+tfieldidarray[0]+"span").css('display','none');
                                               }
                                               if($GetEle('field'+tfieldidarray[0]+"_browserbtn")!=null){
											        if(jQuery('#field'+tfieldidarray[0]+'_browserbtn').closest('.e8_os').css('display')!='none'){
													   jQuery('#field'+tfieldidarray[0]+'_browserbtn').closest('.e8_os').css('display','none');
													}
                                                }
                                            	if($GetEle('field'+tfieldidarray[0])!=null){
                                                    jQuery('#field'+tfieldidarray[0]).css('display','none');        	
                                                }
												if($GetEle('field_lable'+tfieldidarray[0]+'span')!=null){
												   jQuery('#field_lable'+tfieldidarray[0]+'span').css('display','none'); 
												}
												if($GetEle('field_lable'+tfieldidarray[0])!=null){
												   jQuery('#field_lable'+tfieldidarray[0]).css('display','none'); 
												}if($GetEle('field_chinglish'+tfieldidarray[0]+'span')!=null){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'span').css('display','none'); 
												}
												if($GetEle('field_chinglish'+tfieldidarray[0])!=null){
												   jQuery('#field_chinglish'+tfieldidarray[0]).css('display','none'); 
												}
                                            	
                                        }
                                    }
                                }
                            }
                        }
                    if(fieldattr==-1){ // 没有设置联动，恢复原值和恢复原显示属性
                        for(i=0;i<len;i++){
                            for(j=0;j<fieldidarray.length;j++){
                                var tfieldidarray=fieldidarray[j].split("_");
								//影藏 明细
								               if(jQuery('#field'+tfieldidarray[0]+rownum+'span').css('display')=='none'){
                                                  jQuery('#field'+tfieldidarray[0]+rownum+'span').css('display','');
                                               }
                                               if(jQuery('#field'+tfieldidarray[0]+"_"+rownum+'wrapspan').css('display')=='none'){
                                                    jQuery('#field'+tfieldidarray[0]+"_"+rownum+'_browserbtn').css('display','');
													 jQuery('#field'+tfieldidarray[0]+"_"+rownum+'wrapspan').css('display','');
                                                }
                                            	if(jQuery('#field'+tfieldidarray[0]+'_'+rownum).css('display')=='none'){
                                                    jQuery('#field'+tfieldidarray[0]+'_'+rownum).css('display','');        	
                                                }
												if(jQuery('#field_lable'+tfieldidarray[0]+'span_'+rownum).css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]+'span_'+rownum).css('display',''); 
												}
												if(jQuery('#field_lable'+tfieldidarray[0]+'_'+rownum).css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]+'_'+rownum).css('display',''); 
												}if(jQuery('#field_chinglish'+tfieldidarray[0]+'span_'+rownum).css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'span_'+rownum).css('display',''); 
												}
												if(jQuery('#field_chinglish'+tfieldidarray[0]+'_'+rownum).css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'_'+rownum).css('display',''); 
												}
                                            	//判断附件字段
                                                if(jQuery("#field_"+tfieldidarray[0]+"span_"+rownum).css('display')=='none'){
                                                	jQuery("#field_"+tfieldidarray[0]+"span_"+rownum).css('display','');    
                                                }
												else{
											      if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
                                                   }
                                             }
											 //主表
								              if(jQuery('#field'+tfieldidarray[0]+"span").css('display')=='none'){
                                                  jQuery('#field'+tfieldidarray[0]+"span").css('display','');
                                               }
                                               if(jQuery('#field'+tfieldidarray[0]+'_browserbtn').closest('.e8_os').css('display')=='none'){
													   jQuery('#field'+tfieldidarray[0]+'_browserbtn').closest('.e8_os').css('display','block');
												}
                                            	if(jQuery('#field'+tfieldidarray[0]).css('display')=='none'){
                                                    jQuery('#field'+tfieldidarray[0]).css('display','');        	
                                                }
												if(jQuery('#field_lable'+tfieldidarray[0]+'span').css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]+'span').css('display',''); 
												}
												if(jQuery('#field_lable'+tfieldidarray[0]).css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]).css('display',''); 
												}if(jQuery('#field_chinglish'+tfieldidarray[0]+'span').css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'span').css('display',''); 
												}
												if(jQuery('#field_chinglish'+tfieldidarray[0]).css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]).css('display',''); 
												}
								//
                                if (tfieldidarray[1]==isdetail){
                                    if(rownum>-1){  // 明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum)){
                                            isedit=$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum).value;
                                            if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")||$GetEle('field_'+tfieldidarray[0]+"_"+rownum+"span")){
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                if(isedit==3){
                                                	jQuery('#field'+tfieldidarray[0]+"_"+rownum).attr("isMustInput","2");
                                                	document.forms[0].elements[i].setAttribute('viewtype','1');
                                                	var imgObj = jQuery('#field'+tfieldidarray[0]+"_"+rownum+"spanimg");
	                                                if(imgObj.length==0){
	                                                	imgObj = jQuery('#field'+tfieldidarray[0]+"_"+rownum+"span")
	                                                }
	                                                var objVal = jQuery('#field'+tfieldidarray[0]+"_"+rownum);
	                                                if(objVal.val()==""){
		                                                imgObj.html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	                                                }
	                                                
	                                                //子表判断附件字段
                                                if($GetEle("fsUploadProgress"+tfieldidarray[0]+"_"+rownum)){
                                                	imgObj.html("<%=SystemEnv.getHtmlLabelName(81909,user.getLanguage()) %>");
                                                	var isReturn = false;
                                            		jQuery("#fsUploadProgress"+tfieldidarray[0]+"_"+rownum+" .progressBarStatus").each(function(i,obj){
                                            			if(jQuery(obj).text()!='Cancelled'){
                                            				isReturn = true;
                                            				return false
                                            			}
                                            		})
                                            		if(isReturn){
                                            			jQuery("#field_"+tfieldidarray[0]+"_"+rownum+"span").hide();
                                            		}else{
                                            			if(jQuery("#field"+tfieldidarray[0]+"_"+rownum).val()==''
                                            					||jQuery("#field"+tfieldidarray[0]+"_"+rownum).val()=='NULL'
                                            					||jQuery("#field"+tfieldidarray[0]+"_"+rownum).val()=='null'){
                                            				jQuery("#field_"+tfieldidarray[0]+"_"+rownum+"span").show();
															jQuery("#field"+tfieldidarray[0]+"_"+rownum).val("");
                                            			}else{
                                            				jQuery("#field_"+tfieldidarray[0]+"_"+rownum+"span").hide();
                                            			}
                                            		}
                                            		
                                                	//jQuery("#spanButtonPlaceHolderDis"+tfieldidarray[0]).show();
                                                	attachmentDisd(tfieldidarray[0]+"_"+rownum,false);
                                                }
	                                                
                                                    //if(document.forms[0].elements[i].value==""&&$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")<=0) $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
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
                                                	jQuery('#field'+tfieldidarray[0]+"_"+rownum).attr("isMustInput","1");
                                                	document.forms[0].elements[i].setAttribute('viewtype','0');
                                                	var imgObj = jQuery('#field'+tfieldidarray[0]+"_"+rownum+"spanimg");
	                                                if(imgObj.length==0){
	                                                	imgObj = jQuery('#field'+tfieldidarray[0]+"_"+rownum+"span")
	                                                }
	                                                if(imgObj.length>0&&imgObj.html().indexOf("/images/BacoError_wev8.gif")>-1){
	                                                	imgObj.html("");
	                                                }
	                                                
	                                                //子表判断附件字段
                                                if($GetEle("fsUploadProgress"+tfieldidarray[0]+"_"+rownum)){
                                                	var isReturn = false;
                                            		jQuery("#fsUploadProgress"+tfieldidarray[0]+"_"+rownum+" .progressBarStatus").each(function(i,obj){
                                            			if(jQuery(obj).text()!='Cancelled'){
                                            				isReturn = true;
                                            				return false
                                            			}
                                            		})
                                           			jQuery("#field_"+tfieldidarray[0]+"_"+rownum+"span").hide();
                                                	attachmentDisd(tfieldidarray[0]+"_"+rownum,false);
                                                }
	                                                
                                                    //if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
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
                                            }else{
                                            	if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
                                                    	setCanEdit($GetEle('field'+tfieldidarray[0]+"_"+rownum));
                                                    }
                                            }
                                        }
                                    }else{     // 主字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$GetEle('oldfieldview'+tfieldidarray[0])){
                                            isedit=$GetEle('oldfieldview'+tfieldidarray[0]).value;
                                            if($GetEle('field'+tfieldidarray[0]+"span")){
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                if(isedit==3) {
                                                	jQuery('#field'+tfieldidarray[0]).attr("isMustInput","2");
                                                	document.forms[0].elements[i].setAttribute('viewtype','1');
                                                    if(document.forms[0].elements[i].value=="") {
                                                    	var imgObj = jQuery('#field'+tfieldidarray[0]+"spanimg");
		                                                if(imgObj.length==0){
		                                                	imgObj = jQuery('#field'+tfieldidarray[0]+"span")
		                                                }
		                                                if(imgObj.length>0){
		                                                	imgObj.html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		                                                }
                                                    	//$GetEle('field'+tfieldidarray[0]+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                    }
                                                    //判断附件字段
	                                                if($GetEle("fsUploadProgress"+tfieldidarray[0])){
	                                                	//jQuery("#field"+tfieldidarray[0]).prev().show();
	                                                	var isReturn = false;
	                                            		jQuery("#fsUploadProgress"+tfieldidarray[0]+" .progressBarStatus").each(function(i,obj){
	                                            			if(jQuery(obj).text()!='Cancelled'){
	                                            				isReturn = true;
	                                            				return false
	                                            			}
	                                            		})
	                                            		if(isReturn){
	                                            			jQuery("#field_"+tfieldidarray[0]+"span").hide();
	                                            		}else{
	                                            			if(jQuery("#field"+tfieldidarray[0]).val()==''
	                                            					||jQuery("#field"+tfieldidarray[0]).val()=='NULL'
	                                            					||jQuery("#field"+tfieldidarray[0]).val()=='null'){
	                                            				jQuery("#field_"+tfieldidarray[0]+"span").show();
																jQuery("#field"+tfieldidarray[0]).val("");
	                                            			}else{
	                                            				jQuery("#field_"+tfieldidarray[0]+"span").hide();
	                                            			}
	                                            		}
	                                                	//jQuery("[uploadprompt='uploadprompt_"+tfieldidarray[0]+"span'").show();
	                                                	//jQuery("#spanButtonPlaceHolderDis"+tfieldidarray[0]).show();
	                                                	attachmentDisd(tfieldidarray[0],false);
	                                                }
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
                                                	jQuery('#field'+tfieldidarray[0]).attr("isMustInput","1");
                                                	document.forms[0].elements[i].setAttribute('viewtype','0');
                                                	var imgObj = jQuery('#field'+tfieldidarray[0]+"spanimg");
	                                                if(imgObj.length==0){
	                                                	imgObj = jQuery('#field'+tfieldidarray[0]+"span")
	                                                }
	                                                if(imgObj.length>0&&imgObj.html().indexOf("/images/BacoError_wev8.gif")>-1){
	                                                	imgObj.html("");
	                                                }
	                                                //判断附件字段
	                                                if($GetEle("fsUploadProgress"+tfieldidarray[0])){
	                                                	//jQuery("#field"+tfieldidarray[0]).prev().show();
	                                                	jQuery("#field_"+tfieldidarray[0]+"span").hide();
	                                                	//jQuery("[uploadprompt='uploadprompt_"+tfieldidarray[0]+"span'").show();
	                                                	//jQuery("#spanButtonPlaceHolderDis"+tfieldidarray[0]).show();
	                                                	attachmentDisd(tfieldidarray[0],false);
	                                                }
                                                    //if($GetEle('field'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
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
                                            }else{
                                            	if($GetEle('field'+tfieldidarray[0])!=null){
                                                    	$GetEle('field'+tfieldidarray[0]).disabled=false;
                                                    	setCanEdit($GetEle('field'+tfieldidarray[0]));
                                                    }
                                            	//判断附件字段
                                                if($GetEle("fsUploadProgress"+tfieldidarray[0])){
                                                	//jQuery("#field"+tfieldidarray[0]).prev().show();
                                                	jQuery("#field_"+tfieldidarray[0]+"span").hide();
                                                	//jQuery("[uploadprompt='uploadprompt_"+tfieldidarray[0]+"span'").show();
                                                	//jQuery("#spanButtonPlaceHolderDis"+tfieldidarray[0]).show();
                                                	attachmentDisd(tfieldidarray[0],false);
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
									//影藏
									 if(jQuery('#field'+tfieldidarray[0]+rownum+'span').css('display')=='none'){
                                                  jQuery('#field'+tfieldidarray[0]+rownum+'span').css('display','');
                                               }
                                               if(jQuery('#field'+tfieldidarray[0]+"_"+rownum+'wrapspan').css('display')=='none'){
                                                    jQuery('#field'+tfieldidarray[0]+"_"+rownum+'_browserbtn').css('display','');
													 jQuery('#field'+tfieldidarray[0]+"_"+rownum+'wrapspan').css('display','');
                                                }
                                            	if(jQuery('#field'+tfieldidarray[0]+'_'+rownum).css('display')=='none'){
                                                    jQuery('#field'+tfieldidarray[0]+'_'+rownum).css('display','');        	
                                                }
												if(jQuery('#field_lable'+tfieldidarray[0]+'span_'+rownum).css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]+'span_'+rownum).css('display',''); 
												}
												if(jQuery('#field_lable'+tfieldidarray[0]+'_'+rownum).css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]+'_'+rownum).css('display',''); 
												}if(jQuery('#field_chinglish'+tfieldidarray[0]+'span_'+rownum).css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'span_'+rownum).css('display',''); 
												}
												if(jQuery('#field_chinglish'+tfieldidarray[0]+'_'+rownum).css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'_'+rownum).css('display',''); 
												}
                                            	//判断附件字段
                                                if(jQuery("#field_"+tfieldidarray[0]+"span_"+rownum).css('display')=='none'){
                                                	jQuery("#field_"+tfieldidarray[0]+"span_"+rownum).css('display','');    
                                                }
												else{
											      if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
                                                   }
                                             }
								   if(jQuery('#field'+tfieldidarray[0]+"span").css('display')=='none'){
                                                  jQuery('#field'+tfieldidarray[0]+"span").css('display','');
                                               }
                                               if(jQuery('#field'+tfieldidarray[0]+'_browserbtn').closest('.e8_os').css('display')=='none'){
													   jQuery('#field'+tfieldidarray[0]+'_browserbtn').closest('.e8_os').css('display','block');
												}
                                            	if(jQuery('#field'+tfieldidarray[0]).css('display')=='none'){
                                                    jQuery('#field'+tfieldidarray[0]).css('display','');        	
                                                }
												if(jQuery('#field_lable'+tfieldidarray[0]+'span').css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]+'span').css('display',''); 
												}
												if(jQuery('#field_lable'+tfieldidarray[0]).css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]).css('display',''); 
												}if(jQuery('#field_chinglish'+tfieldidarray[0]+'span').css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'span').css('display',''); 
												}
												if(jQuery('#field_chinglish'+tfieldidarray[0]).css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]).css('display',''); 
												}
								//
                                if (tfieldidarray[1]==isdetail){
                                    if(rownum>-1){  // 明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum)){
                                            isedit=$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum).value;
                                            if(isedit>1&&($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")||$GetEle('field_'+tfieldidarray[0]+"_"+rownum+"span"))){
                                            	jQuery('#field'+tfieldidarray[0]+"_"+rownum).attr("isMustInput","1");
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                var imgObj = jQuery('#field'+tfieldidarray[0]+"_"+rownum+"spanimg");
                                                if(imgObj.length==0){
                                                	imgObj = jQuery('#field'+tfieldidarray[0]+"_"+rownum+"span")
                                                }
                                                if(imgObj.length>0&&imgObj.html().indexOf("/images/BacoError_wev8.gif")>-1){
                                                	imgObj.html("");
                                                }
                                                
                                                //子表判断附件字段
                                                if($GetEle("fsUploadProgress"+tfieldidarray[0]+"_"+rownum)){
                                                	var isReturn = false;
                                            		jQuery("#fsUploadProgress"+tfieldidarray[0]+"_"+rownum+" .progressBarStatus").each(function(i,obj){
                                            			if(jQuery(obj).text()!='Cancelled'){
                                            				isReturn = true;
                                            				return false
                                            			}
                                            		})
                                            		jQuery("#field_"+tfieldidarray[0]+"_"+rownum+"span").hide();
                                                	attachmentDisd(tfieldidarray[0]+"_"+rownum,false);
                                                }
                                                //if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
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
                                            }else {
                                            	 if(isedit>1){
                                            		 if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
                                                		setCanEdit($GetEle('field'+tfieldidarray[0]+"_"+rownum));
                                                	}
                                            	 }
                                            }
                                        }
                                    }else{     // 主字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$GetEle('oldfieldview'+tfieldidarray[0])){
                                            isedit=$GetEle('oldfieldview'+tfieldidarray[0]).value;
                                            if(isedit>1&&$GetEle('field'+tfieldidarray[0]+"span")){
                                            	jQuery('#field'+tfieldidarray[0]).attr("isMustInput","1");
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                //if($GetEle('field'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
                                                var imgObj = jQuery('#field'+tfieldidarray[0]+"spanimg");
                                                if(imgObj.length==0){
                                                	imgObj = jQuery('#field'+tfieldidarray[0]+"span")
                                                }
                                                if(imgObj.length>0&&imgObj.html().indexOf("/images/BacoError_wev8.gif")>-1){
                                                	imgObj.html("");
                                                }
                                                 //判断附件字段
                                                if($GetEle("fsUploadProgress"+tfieldidarray[0])){
                                                	//jQuery("#field"+tfieldidarray[0]).prev().show();
                                                	jQuery("#field_"+tfieldidarray[0]+"span").hide();
                                                	//jQuery("#spanButtonPlaceHolderDis"+tfieldidarray[0]).show();
                                                	attachmentDisd(tfieldidarray[0],false);
                                                }
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
                                            }else{
                                            	 if(isedit>1){
	                                            	if($GetEle('field'+tfieldidarray[0])!=null){
	                                                	setCanEdit($GetEle('field'+tfieldidarray[0]));
	                                                }
                                            	 }
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
									//影藏
									 if(jQuery('#field'+tfieldidarray[0]+rownum+'span').css('display')=='none'){
                                                  jQuery('#field'+tfieldidarray[0]+rownum+'span').css('display','');
                                               }
                                               if(jQuery('#field'+tfieldidarray[0]+"_"+rownum+'wrapspan').css('display')=='none'){
                                                    jQuery('#field'+tfieldidarray[0]+"_"+rownum+'_browserbtn').css('display','');
													 jQuery('#field'+tfieldidarray[0]+"_"+rownum+'wrapspan').css('display','');
                                                }
                                            	if(jQuery('#field'+tfieldidarray[0]+'_'+rownum).css('display')=='none'){
                                                    jQuery('#field'+tfieldidarray[0]+'_'+rownum).css('display','');        	
                                                }
												if(jQuery('#field_lable'+tfieldidarray[0]+'span_'+rownum).css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]+'span_'+rownum).css('display',''); 
												}
												if(jQuery('#field_lable'+tfieldidarray[0]+'_'+rownum).css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]+'_'+rownum).css('display',''); 
												}if(jQuery('#field_chinglish'+tfieldidarray[0]+'span_'+rownum).css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'span_'+rownum).css('display',''); 
												}
												if(jQuery('#field_chinglish'+tfieldidarray[0]+'_'+rownum).css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'_'+rownum).css('display',''); 
												}
                                            	//判断附件字段
                                                if(jQuery("#field_"+tfieldidarray[0]+"span_"+rownum).css('display')=='none'){
                                                	jQuery("#field_"+tfieldidarray[0]+"span_"+rownum).css('display','');    
                                                }
												else{
											      if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
                                                   }
                                             }
								              if(jQuery('#field'+tfieldidarray[0]+"span").css('display')=='none'){
                                                  jQuery('#field'+tfieldidarray[0]+"span").css('display','');
                                               }
                                              if(jQuery('#field'+tfieldidarray[0]+'_browserbtn').closest('.e8_os').css('display')=='none'){
													   jQuery('#field'+tfieldidarray[0]+'_browserbtn').closest('.e8_os').css('display','block');
												}
                                            	if(jQuery('#field'+tfieldidarray[0]).css('display')=='none'){
                                                    jQuery('#field'+tfieldidarray[0]).css('display','');        	
                                                }
												if(jQuery('#field_lable'+tfieldidarray[0]+'span').css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]+'span').css('display',''); 
												}
												if(jQuery('#field_lable'+tfieldidarray[0]).css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]).css('display',''); 
												}if(jQuery('#field_chinglish'+tfieldidarray[0]+'span').css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'span').css('display',''); 
												}
												if(jQuery('#field_chinglish'+tfieldidarray[0]).css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]).css('display',''); 
												}
								//
                                if (tfieldidarray[1]==isdetail){
                                    if(rownum>-1){  // 明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum)){
                                            isedit=$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum).value;
                                            if(isedit>1&&($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")||$GetEle('field_'+tfieldidarray[0]+"_"+rownum+"span"))){
                                            	var  nameStr = 'field'+tfieldidarray[0]+"_"+rownum;
                                            	var spanNameStr = nameStr+"span";
                                            	if(jQuery('#field_'+tfieldidarray[0]+"_"+rownum+"span").length>0){
                                            		spanNameStr = 'field_'+tfieldidarray[0]+"_"+rownum+"span";
                                            	}
                                                //if(document.forms[0].elements[i].value==""&&$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")<=0) $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                jQuery('#'+nameStr).attr("isMustInput","2");//2：必须输：可编辑
                                                var imgObj = jQuery('#'+nameStr+"spanimg");
                                                if(imgObj.length==0){
                                                	imgObj = jQuery('#'+spanNameStr)
                                                }
                                                var objVal = jQuery('#'+nameStr);
                                                if(objVal.val()==""){
	                                                imgObj.html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
                                                }
                                                
                                                 //子表判断附件字段
                                                if($GetEle("fsUploadProgress"+tfieldidarray[0]+"_"+rownum)){
                                                	 imgObj.html("<%=SystemEnv.getHtmlLabelName(81909,user.getLanguage()) %>");
                                                	var isReturn = false;
                                            		jQuery("#fsUploadProgress"+tfieldidarray[0]+"_"+rownum+" .progressBarStatus").each(function(i,obj){
                                            			if(jQuery(obj).text()!='Cancelled'){
                                            				isReturn = true;
                                            				return false
                                            			}
                                            		})
                                            		if(isReturn){
                                            			jQuery("#field_"+tfieldidarray[0]+"_"+rownum+"span").hide();
                                            		}else{
                                            			if(jQuery("#field"+tfieldidarray[0]+"_"+rownum).val()==''
                                            					||jQuery("#field"+tfieldidarray[0]+"_"+rownum).val()=='NULL'
                                            					||jQuery("#field"+tfieldidarray[0]+"_"+rownum).val()=='null'){
                                            				jQuery("#field_"+tfieldidarray[0]+"_"+rownum+"span").show();
															jQuery("#field"+tfieldidarray[0]+"_"+rownum).val("");
                                            			}else{
                                            				jQuery("#field_"+tfieldidarray[0]+"_"+rownum+"span").hide();
                                            			}
                                            		}
                                            		
                                                	//jQuery("#spanButtonPlaceHolderDis"+tfieldidarray[0]).show();
                                                	attachmentDisd(tfieldidarray[0]+"_"+rownum,false);
                                                }
                                                 
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
                                            }else{
                                            	if(isedit>1){
	                                            	if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
	                                                	setCanEdit($GetEle('field'+tfieldidarray[0]+"_"+rownum));
	                                                }
                                            	}
                                            }
                                        }
                                    }else{     // 主字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$GetEle('oldfieldview'+tfieldidarray[0])){
                                            isedit=$GetEle('oldfieldview'+tfieldidarray[0]).value;
                                            if(isedit>1&&$GetEle('field'+tfieldidarray[0]+"span")){
                                            	jQuery('#field'+tfieldidarray[0]).attr("isMustInput","2");//2：必须输：可编辑
                                                if(document.forms[0].elements[i].value==""){
                                                		var imgObj = jQuery('#field'+tfieldidarray[0]+"spanimg");
		                                                if(imgObj.length==0){
		                                                	imgObj = jQuery('#field'+tfieldidarray[0]+"span")
		                                                }
		                                                if(imgObj.length>0){
		                                                	imgObj.html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		                                                }
                                                	//$GetEle('field'+tfieldidarray[0]+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                }
                                                //判断附件字段
                                                if($GetEle("fsUploadProgress"+tfieldidarray[0])){
                                                	var isReturn = false;
                                            		jQuery("#fsUploadProgress"+tfieldidarray[0]+" .progressBarStatus").each(function(i,obj){
                                            			if(jQuery(obj).text()!='Cancelled'){
                                            				isReturn = true;
                                            				return false
                                            			}
                                            		})
                                            		if(isReturn){
                                            			jQuery("#field_"+tfieldidarray[0]+"span").hide();
                                            		}else{
                                            			if(jQuery("#field"+tfieldidarray[0]).val()==''
                                            					||jQuery("#field"+tfieldidarray[0]).val()=='NULL'
                                            					||jQuery("#field"+tfieldidarray[0]).val()=='null'){
                                            				jQuery("#field_"+tfieldidarray[0]+"span").show();
															jQuery("#field"+tfieldidarray[0]).val("");
                                            			}else{
                                            				jQuery("#field_"+tfieldidarray[0]+"span").hide();
                                            			}
                                            		}
                                            		
                                                	//jQuery("#spanButtonPlaceHolderDis"+tfieldidarray[0]).show();
                                                	attachmentDisd(tfieldidarray[0],false);
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
                                            }else{
                                            	if($GetEle('field'+tfieldidarray[0])!=null){
                                                	setCanEdit($GetEle('field'+tfieldidarray[0]));
                                                }
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
									//影藏
									 if(jQuery('#field'+tfieldidarray[0]+rownum+'span').css('display')=='none'){
                                                  jQuery('#field'+tfieldidarray[0]+rownum+'span').css('display','');
                                               }
                                               if(jQuery('#field'+tfieldidarray[0]+"_"+rownum+'wrapspan').css('display')=='none'){
                                                    jQuery('#field'+tfieldidarray[0]+"_"+rownum+'_browserbtn').css('display','');
													 jQuery('#field'+tfieldidarray[0]+"_"+rownum+'wrapspan').css('display','');
                                                }
                                            	if(jQuery('#field'+tfieldidarray[0]+'_'+rownum).css('display')=='none'){
                                                    jQuery('#field'+tfieldidarray[0]+'_'+rownum).css('display','');        	
                                                }
												if(jQuery('#field_lable'+tfieldidarray[0]+'span_'+rownum).css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]+'span_'+rownum).css('display',''); 
												}
												if(jQuery('#field_lable'+tfieldidarray[0]+'_'+rownum).css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]+'_'+rownum).css('display',''); 
												}if(jQuery('#field_chinglish'+tfieldidarray[0]+'span_'+rownum).css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'span_'+rownum).css('display',''); 
												}
												if(jQuery('#field_chinglish'+tfieldidarray[0]+'_'+rownum).css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'_'+rownum).css('display',''); 
												}
                                            	//判断附件字段
                                                if(jQuery("#field_"+tfieldidarray[0]+"span_"+rownum).css('display')=='none'){
                                                	jQuery("#field_"+tfieldidarray[0]+"span_"+rownum).css('display','');    
                                                }
												else{
											      if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
                                                   }
                                             }
								            if(jQuery('#field'+tfieldidarray[0]+"span").css('display')=='none'){
                                                  jQuery('#field'+tfieldidarray[0]+"span").css('display','');
                                               }
                                              if(jQuery('#field'+tfieldidarray[0]+'_browserbtn').closest('.e8_os').css('display')=='none'){
													   jQuery('#field'+tfieldidarray[0]+'_browserbtn').closest('.e8_os').css('display','block');
												}
                                            	if(jQuery('#field'+tfieldidarray[0]).css('display')=='none'){
                                                    jQuery('#field'+tfieldidarray[0]).css('display','');        	
                                                }
												if(jQuery('#field_lable'+tfieldidarray[0]+'span').css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]+'span').css('display',''); 
												}
												if(jQuery('#field_lable'+tfieldidarray[0]).css('display')=='none'){
												   jQuery('#field_lable'+tfieldidarray[0]).css('display',''); 
												}if(jQuery('#field_chinglish'+tfieldidarray[0]+'span').css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]+'span').css('display',''); 
												}
												if(jQuery('#field_chinglish'+tfieldidarray[0]).css('display')=='none'){
												   jQuery('#field_chinglish'+tfieldidarray[0]).css('display',''); 
												}
								//
                                if (tfieldidarray[1]==isdetail){
                                    if(rownum>-1){  //明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&document.all('oldfieldview'+tfieldidarray[0]+"_"+rownum)){
                                            if(($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")||$GetEle('field_'+tfieldidarray[0]+"_"+rownum+"span"))){
                                            	jQuery('#field'+tfieldidarray[0]+"_"+rownum).attr("isMustInput","1");
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                //提前替换，否则触发checkFileRequired事件时，会判断出错
                                                $GetEle("needcheck").value=checkstr_.replace("field"+tfieldidarray[0]+"_"+rownum+",","");
                                                var imgObj = jQuery('#field'+tfieldidarray[0]+"_"+rownum+"spanimg");
                                                if(imgObj.length==0){
                                                	imgObj = jQuery('#field'+tfieldidarray[0]+"_"+rownum+"span")
                                                }
                                                
                                                var objVal = jQuery('#field'+tfieldidarray[0]+"_"+rownum);
                                                if(objVal.val()==""){
	                                                imgObj.html("");
                                                }
                                                
                                                //子表判断附件字段
                                                if($GetEle("fsUploadProgress"+tfieldidarray[0]+"_"+rownum)){
                                                	var isReturn = false;
                                            		jQuery("#fsUploadProgress"+tfieldidarray[0]+"_"+rownum+" .progressBarStatus").each(function(i,obj){
                                            			if(jQuery(obj).text()!='Cancelled'){
                                            				isReturn = true;
                                            				return false
                                            			}
                                            		})
                                            		jQuery("#field_"+tfieldidarray[0]+"_"+rownum+"span").hide();
                                                	attachmentDisd(tfieldidarray[0]+"_"+rownum,true);
                                                }
	                                                
                                                //if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")){
												//	if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
												//		$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
												//	}
                                                	//$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                                //}
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
                                                document.forms[0].elements[i].setAttribute('viewtype','0');
                                            }else{
                                            	if($GetEle('field'+tfieldidarray[0]+"_"+rownum)!=null){
                                                	setReadOnly($GetEle('field'+tfieldidarray[0]+"_"+rownum));
                                                }
                                            }
                                        }
                                    }else{     //主字段
                                    	if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$GetEle('oldfieldview'+tfieldidarray[0])){
                                            if($GetEle('field'+tfieldidarray[0]+"span")){
                                            	jQuery('#field'+tfieldidarray[0]).attr("isMustInput","1");
                                                var checkstr_=$GetEle("needcheck").value+",";
                                                //提前替换，否则触发checkFileRequired事件时，会判断出错
                                                $GetEle("needcheck").value=checkstr_.replace("field"+tfieldidarray[0]+",","");
                                                var imgObj = jQuery('#field'+tfieldidarray[0]+"spanimg");
                                                if(imgObj.length==0){
                                                	imgObj = jQuery('#field'+tfieldidarray[0]+"span")
                                                }
                                                if(imgObj.length>0&&imgObj.html().indexOf("/images/BacoError_wev8.gif")>-1){
                                                	imgObj.html("");
                                                }
                                                
                                                //if($GetEle('field'+tfieldidarray[0]+"span")){
                                                	//$GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
												//	if($GetEle('field'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
												//		$GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
												//	}
                                               // }
                                                 //判断附件字段
                                                if($GetEle("fsUploadProgress"+tfieldidarray[0])){
                                                	//jQuery("#field"+tfieldidarray[0]).prev().hide();
                                                	jQuery("#field_"+tfieldidarray[0]+"span").hide();
                                                	//jQuery("#spanButtonPlaceHolderDis"+tfieldidarray[0]).hide();
                                                	/**
                                                	*附件不可编辑
                                                	**/
                                                	attachmentDisd(tfieldidarray[0],true);
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
                                                document.forms[0].elements[i].setAttribute('viewtype','0');
                                            }else{
                                            	if($GetEle('field'+tfieldidarray[0])!=null){
                                                	setReadOnly($GetEle('field'+tfieldidarray[0]));
                                                }
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

function changeCheckBox(group){
	jQuery('body').jNice();
}

function changeSelect(group){
	beautySelect();
}

//设置为只读
function setReadOnly(obj){
	var objid = obj.id;
	var field_lable;
	var parentEle ;
	if(objid&&objid!=""){
		 parentEle = jQuery("#"+obj.id).parent();
		 field_lable = obj.id.replace("field","field_lable");
	}else{
		parentEle = jQuery(jQuery("[name="+obj.name+"]").get(0)).parent();
		field_lable = obj.name.replace("field","field_lable");
	}
	
	if(jQuery("#"+field_lable).length>0){
		 jQuery("#"+field_lable).attr("disabled",true);
	}
	
	if(parentEle.find("#"+obj.id+"_browserbtn").length>0){
		parentEle.find("#"+obj.id+"_browserbtn").attr("disabled","disabled");
		parentEle.find(".e8_delClass").hide();
		jQuery("#"+obj.id+"__").attr("disabled","disabled");
	}else if(parentEle.find(".jNiceHidden").length>0){
		disOrEnableCheckbox(obj,true);
	}else if(parentEle.find(".sbSelector").length>0){
		jQuery("#"+obj.id).selectbox("disable");
	}else if(obj.type == "checkbox"){
		jQuery("#"+obj.id).attr("disabled","disabled");
	}else if(obj.tagName == "SELECT"){
		jQuery("#"+obj.id).attr("disabled","disabled");
	}
	
	
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
//设置为可编辑
function setCanEdit(obj){
	
	var objid = obj.id;
	var field_lable;
	var parentEle ;
	if(objid&&objid!=""){
		 parentEle = jQuery("#"+obj.id).parent();
		 field_lable = obj.id.replace("field","field_lable");
	}else{
		parentEle = jQuery(jQuery("[name="+obj.name+"]").get(0)).parent();
		field_lable = obj.name.replace("field","field_lable");
	}
	
	if(jQuery("#"+field_lable).length>0){
		 jQuery("#"+field_lable).attr("disabled",false);
	}
	
	if(parentEle.find("#"+obj.id+"_browserbtn").length>0){
		parentEle.find("#"+obj.id+"_browserbtn").attr("disabled",false);
		parentEle.find(".e8_delClass").show();
		jQuery("#"+obj.id+"__").attr("disabled",false);
	}else if(parentEle.find(".jNiceHidden").length>0){
		disOrEnableCheckbox(obj,false);
	}else if(parentEle.find(".sbSelector").length>0){
		jQuery("#"+obj.id).selectbox("enable");
	}else if(obj.type == "checkbox"){
		jQuery("#"+obj.id).attr("disabled",false);
	}else if(obj.tagName == "SELECT"){
		jQuery("#"+obj.id).attr("disabled",false);
	}
	//alert("设置为可编辑:"+obj.type);
	if(obj.type == "text"){//单行文本
		obj.readOnly = false;
	}else if(obj.type == "textarea"){//多行文本
		obj.readOnly = false;
	}else if(obj.type == "select-one"){//下拉字段
		//obj.onmouseover = null;   
		//obj.onmouseout = null;   
		obj.onfocus = null;
		//obj.onchange = null;
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
							+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage())%>";//的所有人员
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

<%if(type !=0 && type !=2 && type !=3){%>
setTimeout("doTriggerInit()",1000);
<%}%>
function doTriggerInit(){
 	var tempS = "<%=trrigerfield%>";
 	var triggerFieldArr = tempS.split(",");
 	var noEmptyTriggerFields = "";
 	for(var i=0;i<triggerFieldArr.length;i++){
 		var triggerField = triggerFieldArr[i];
 		if(triggerField == "") continue;
 		var triggerFieldValue =  $GetEle(triggerField).value;
		if(triggerFieldValue == "") continue;
		if(noEmptyTriggerFields != ""){
			noEmptyTriggerFields += ",";
		}
		noEmptyTriggerFields += triggerField;
 	}
 	datainput(noEmptyTriggerFields);
}

function datainput(parfield){                <!--数据导入-->
	try{
		if(event.propertyName && event.propertyName.toLowerCase() != "value"){
			return;
		}
		var src = event.srcElement || event.target; 
		if(src.tagName.toLowerCase() == 'button'){
			return ;
		}
	}catch(e){}
    var tempParfieldArr = parfield.split(",");
    var tempdata = "";
    var temprand = $GetEle("rand").value ;
    var StrData="modeId=<%=modeId%>&formId=<%=formId%>&type=<%=type%>&layoutid=<%=layoutid%>&detailsum=<%=detailsum%>&trg="+parfield;
    for(var i=0;i<tempParfieldArr.length;i++){
    	var tempParfield = tempParfieldArr[i];
    	if (tempParfield != "") {
    		tempdata += $GetEle(tempParfield).value+"," ;
    	}
	    <%
	    if(!trrigerfield.trim().equals("")){
	        ArrayList Linfieldname=ddi.GetInFieldName();
	        for(int i=0;i<Linfieldname.size();i++){
	            String temp=(String)Linfieldname.get(i);
	    %>
	        if($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+escape($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>").value);
	    <%
	        }
	    }
	    %>
    }
    StrData += "&trgv="+tempdata+"&rand="+temprand+"&tempflag="+Math.random();
    if($GetEle("datainput_"+parfield)){
	  	$GetEle("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	}else{
		createIframe("datainput_"+parfield);
		$GetEle("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	}
}

//var isfrist = true;
//var detailfieldids = "";
var trrigerdetailbuttonfield='<%=trrigerdetailbuttonfield%>';
function datainputd(parfield,isAutoTrigger){				//明细
	if(<%=type%>==2&&jQuery.browser.msie){
		if(trrigerdetailbuttonfield.indexOf(parfield+"")>-1&&parfield.indexOf(",")==-1){
			trrigerdetailbuttonfield=trrigerdetailbuttonfield.replace(parfield,"");
			return;
		}
	}
	if(isNotFunRuning){//防止复制的时候触发事件，导致不能复制值
		return;
	}
	if(isAutoTrigger){
		var triggerFieldArr = parfield.split(",");
	 	var noEmptyTriggerFields = "";
	 	for(var i=0;i<triggerFieldArr.length;i++){
	 		var triggerField = triggerFieldArr[i];
	 		if(triggerField == "") continue;
	 		var triggerFieldValue =  $GetEle(triggerField).value;
			if(triggerFieldValue == "") continue;
			if(noEmptyTriggerFields != ""){
				noEmptyTriggerFields += ",";
			}
			noEmptyTriggerFields += triggerField;
	 	}
		parfield = noEmptyTriggerFields;
	}
	var tempParfieldArr = parfield.split(",");
	var StrData="modeId=<%=modeId%>&formId=<%=formId%>&type=<%=type%>&layoutid=<%=layoutid%>&detailsum=<%=detailsum%>&trg="+parfield;
	for(var i=0;i<tempParfieldArr.length;i++){
     	var tempParfield = tempParfieldArr[i];
     	var indexid=tempParfield.substr(tempParfield.indexOf("_")+1);

 		<%
		if(!trrigerdetailfield.trim().equals("")){
			ArrayList Linfieldname=ddi.GetInFieldName();
			for(int i=0;i<Linfieldname.size();i++){
				String temp=(String)Linfieldname.get(i);
				%>
				if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)!=null) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value);
				<%
			}
		}%>
	}
	if(datainputiframecount<30){
		var flag = datainputCreateIframeNew(parfield,"datainputformdetail_");
		$G("datainputformdetail_"+parfield).src="DataInputFromDetail.jsp?iframename=datainputformdetail_"+parfield+"&"+StrData;
	}else{
		$G("datainputformdetail").src="DataInputFromDetail.jsp?"+StrData;
	}
}

var datainputiframecount = 0;
 function datainputCreateIframeNew(fieldid,befname){
	  var flag = true;
	  if(jQuery("#"+befname+fieldid).length>0){
		  flag = false;
	  }else{
		  var iframe_datainputd = document.createElement("iframe");
		  iframe_datainputd.id = befname+fieldid;
		  iframe_datainputd.name = befname+fieldid;
		  iframe_datainputd.src = "";
		  iframe_datainputd.frameborder = "0";
		  iframe_datainputd.height = "0";
		  iframe_datainputd.scrolling = "no";
		  iframe_datainputd.style.display = "none";
		  document.body.appendChild(iframe_datainputd);
		  datainputiframecount++;
	  }
	  return flag;
}

function getNumber(index){
  	$G("field_lable"+index).value = $G("field"+index).value;
}
function onChangeSharetypeNew(obj,delspan,delid,showid,names,ismand,Uploadobj){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84051, user.getLanguage()) %>"+names+"<%=SystemEnv.getHtmlLabelName(84498, user.getLanguage()) %>", function(){
	    jQuery(obj).parent().parent().parent().parent().css("display","none");
		var fieldid=delid.substr(0,delid.indexOf("_"));
	    var linknum=delid.substr(delid.lastIndexOf("_")+1);
		var fieldidnum=fieldid+"_idnum_1";
		var fieldidspan=fieldid+"span";
	    var delfieldid=fieldid+"_id_"+linknum;
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
		if (ismand=="1"){
			if ($GetEle(fieldidnum).value=="0"){
			    $GetEle(fieldid).value="";
			    var swfuploadid=fieldid.replace("field","");
			    var linkrequired=$GetEle("oUpload_"+swfuploadid+"_linkrequired");
			    $GetEle(fieldidspan).innerHTML="";
		        if(Uploadobj.getStats().files_queued==0){
				$GetEle(fieldidspan).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		        }
		        if(linkrequired && linkrequired.value=="false"){
		        	$GetEle(fieldidspan).innerHTML="";
		        }
		  	}else{
			 $GetEle(fieldidspan).innerHTML="";
		  	}
		}else{//add by td78113
		  	//displaySWFUploadError(fieldid);
		}
		
		////
		var leaveNum = jQuery("#"+fieldid).val();
		if(leaveNum == "" || leaveNum == null){
			var upid = fieldid.substr(5);
			jQuery("#field_upload_"+upid).attr("disabled","disabled");
		}
	}, function () {}, 320, 90,true);
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

window.onload = function(){
	
	if(parent.location.href.indexOf("AddFormMode.jsp")!=-1){
		var isopenbyself = parent.document.getElementById("isopenbyself").value;
		document.getElementById("isopenbyself").value = isopenbyself;
		if(<%=type==0%>){
			var customid = parent.document.getElementById("customid").value;
			if(isopenbyself=="1"&&customid!=""){
				addReturnMenu();
			}
		}
	}
}

//编辑的时候排序功
function orderTabByEdit(sTableId,iCol ,sDataType,fieldid,tableIndex){
	var oTable = document.getElementById(sTableId);//获得
    var oTBody = oTable.tBodies[0];
    var colRows = oTBody.rows;//获得tbody里所有的tr 
    var aTRs = new Array();//声明一个数
    for(var i = 1; i < colRows .length; i++)
    {
       aTRs[i] = colRows[i];//将tr依次放入数组 
    }
    if(jQuery("#desc_"+fieldid)!=null&&jQuery("#desc_"+fieldid).size()>0){
    	if(jQuery("#desc_"+fieldid).attr("class")=="xTable_order xTable_order_desc"){
    		aTRs.sort(getSortFunctionByEditDesc(iCol, sDataType,fieldid,tableIndex));//排序,并且传入一个获得到的比较函 
    	}else{
    		aTRs.sort(getSortFunctionByEdit(iCol, sDataType,fieldid,tableIndex));//排序,并且传入一个获得到的比较函 
    	}
    }else{
    	aTRs.sort(getSortFunctionByEdit(iCol, sDataType,fieldid,tableIndex));//排序,并且传入一个获得到的比较函 
    }
    var oFragement = document.createDocumentFragment();//创建文档碎片,用来存放排好的tr 
    for(var i = 1; i < aTRs.length; i++)
    {
    	if(aTRs[i]){
    		oFragement.appendChild(aTRs[i]);//将tr绑定到碎片上. 
    	}
    }
    oTBody.appendChild(oFragement);//将碎片绑定在表格上
    oTable.sortCol = iCol;//记住当前这个可以用来判断是对数组进行反向排序还是重新按列
    if(jQuery("#desc_"+fieldid)!=null&&jQuery("#desc_"+fieldid).size()>0){
    	if(jQuery("#desc_"+fieldid).attr("class")=="xTable_order xTable_order_desc"){
    		jQuery("#desc_"+fieldid).attr("class","xTable_order xTable_order_asc");
    		jQuery("#desc_"+fieldid).html("5");
    	}else{
    		jQuery("#desc_"+fieldid).attr("class","xTable_order xTable_order_desc");
    		jQuery("#desc_"+fieldid).html("6");
    	}
    }else{
    	jQuery("#span_"+fieldid).append("<span id='desc_"+fieldid+"' class='xTable_order xTable_order_desc'>6</span>");
    }
}

function getSortFunctionByEditDesc(iCol, sDataType,fieldid,tableIndex) 
{
    return function compareTRs(oTR1, oTR2){ 
       var vValue1, vValue2;
       var index = convert(jQuery(oTR1).find("span[name='detailIndexSpan"+tableIndex+"']").text(),'int')-1;
       var index2 = convert(jQuery(oTR2).find("span[name='detailIndexSpan"+tableIndex+"']").text(),'int')-1;
       if(sDataType=='check'){
    	   vValue1 = "0";
    	   vValue2 = "0";
    	   if (jQuery("#field"+fieldid+"_"+index).attr('checked')) {
    		   vValue1 = "1";
		   }
    	   if (jQuery("#field"+fieldid+"_"+index2).attr('checked')) {
    		   vValue2 = "1";
		   }
       }else{
	       vValue1 = convert(jQuery("#field"+fieldid+"_"+index).val(), sDataType);
	       vValue2 = convert(jQuery("#field"+fieldid+"_"+index2).val(), sDataType);
	   }
       if(vValue1 < vValue2)
       {
            return -1; 
       } 
       else if(vValue1 > vValue2) 
       {
            return 1; 
       } 
       else 
       { 
            return 0; 
       }
    }
}

function getSortFunctionByEdit(iCol, sDataType,fieldid,tableIndex) 
{
    return function compareTRs(oTR1, oTR2){ 
       var vValue1, vValue2;
       var index = convert(jQuery(oTR1).find("span[name='detailIndexSpan"+tableIndex+"']").text(),'int')-1;
       var index2 = convert(jQuery(oTR2).find("span[name='detailIndexSpan"+tableIndex+"']").text(),'int')-1;
       if(sDataType=='check'){
    	   vValue1 = "0";
    	   vValue2 = "0";
    	   if (jQuery("#field"+fieldid+"_"+index).attr('checked')) {
    		   vValue1 = "1";
		   }
    	   if (jQuery("#field"+fieldid+"_"+index2).attr('checked')) {
    		   vValue2 = "1";
		   }
       }else{
    	   vValue1 = convert(jQuery("#field"+fieldid+"_"+index).val(), sDataType);
           vValue2 = convert(jQuery("#field"+fieldid+"_"+index2).val(), sDataType);
       }
       if(vValue1 < vValue2)
       {
            return 1; 
       } 
       else if(vValue1 > vValue2) 
       {
            return -1; 
       } 
       else 
       { 
            return 0; 
       }
    }
}

function orderTab(sTableId,iCol ,sDataType,fieldid){
    var oTable = document.getElementById(sTableId);//获得
    var oTBody = oTable.tBodies[0];
    var colRows = oTBody.rows;//获得tbody里所有的tr 
    var aTRs = new Array();//声明一个数
    for(var i = 1; i < colRows .length; i++)
    {
       aTRs[i] = colRows[i];//将tr依次放入数组 
    }
    
    if(jQuery("#desc_"+fieldid)!=null&&jQuery("#desc_"+fieldid).size()>0){
    	if(jQuery("#desc_"+fieldid).attr("class")=="Table_asc"){
	    		aTRs.sort(getSortFunctionByDesc(iCol, sDataType,fieldid));//排序,并且传入一个获得到的比较函 
	    }else{
	    		aTRs.sort(getSortFunction(iCol, sDataType,fieldid));//排序,并且传入一个获得到的比较函 
	    }
    }else{
    	aTRs.sort(getSortFunction(iCol, sDataType,fieldid));//排序,并且传入一个获得到的比较函 
    }
    var oFragement = document.createDocumentFragment();//创建文档碎片,用来存放排好的tr 
    for(var i = 1; i < aTRs.length; i++)
    {
    	if(aTRs[i]){
    		oFragement.appendChild(aTRs[i]);//将tr绑定到碎片上. 
    	}
    }
    oTBody.appendChild(oFragement);//将碎片绑定在表格
    oTable.sortCol = iCol;//记住当前这个可以用来判断是对数组进行反向排序还是重新按列
    if(jQuery("#desc_"+fieldid)!=null&&jQuery("#desc_"+fieldid).size()>0){
    	if(jQuery("#desc_"+fieldid).attr("class")=="Table_asc"){
    		jQuery("#desc_"+fieldid).attr("class","Table_desc");
    	}else{
    		jQuery("#desc_"+fieldid).attr("class","Table_asc");
    	}
    }else{
    	//jQuery("#span_"+fieldid).append("<span id='desc_"+fieldid+"' class='Table_asc'>6</span>");
    }
}
function getSortFunctionByDesc(iCol, sDataType,fieldid) 
{
    return function compareTRs(oTR1, oTR2){ 
       var vValue1, vValue2;
       var index = jQuery(oTR1).find("input.del_id").attr("rowindex");
       vValue1 = convert(jQuery("#field"+fieldid+"_"+index).val(), sDataType);
       var index2 = jQuery(oTR2).find("input.del_id").attr("rowindex");
       vValue2 = convert(jQuery("#field"+fieldid+"_"+index2).val(), sDataType);
       if(vValue1 < vValue2) 
       {
            return -1; 
       } 
       else if(vValue1 > vValue2) 
       {
            return 1; 
       } 
       else 
       { 
            return 0; 
       }
    }
}
function getSortFunction(iCol, sDataType,fieldid) 
{
    return function compareTRs(oTR1, oTR2){ 
       var vValue1, vValue2;
       var index = jQuery(oTR1).find("input.del_id").attr("rowindex");
       vValue1 = convert(jQuery("#field"+fieldid+"_"+index).val(), sDataType);
       var index2 = jQuery(oTR2).find("input.del_id").attr("rowindex");
       vValue2 = convert(jQuery("#field"+fieldid+"_"+index2).val(), sDataType);
       if(vValue1 < vValue2) 
       {
            return 1; 
       } 
       else if(vValue1 > vValue2) 
       {
            return -1; 
       } 
       else 
       { 
            return 0; 
       }
    }
}
function convert(sValue, sDataType) 
{
	if(sValue==null){
		sValue = '';
	}
	if(sValue==''&&(sDataType=='int' || sDataType=='float')){
		sValue = '0';
	}
	if(sValue==''&&sDataType=='date'){
		sValue = '1900-01-01';
	}
	if(sDataType=="date"&&sValue!=null){
		while(sValue.indexOf( "-" ) != -1 ) {
                sValue = sValue.replace("-","/"); 
        }
	}
    switch(sDataType) 
    { 
          case "int": 
             return parseInt(sValue); 
          case "float": 
             return parseFloat(sValue); 
          case "date":
             return new Date(Date.parse(sValue)); 
          default:
             return sValue; 
    }
}

function addReturnMenu(){
	var returnStr = "<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>";//返回
	var rightMenuIframe = document.getElementById("rightMenuIframe");
	var menuTable = rightMenuIframe.contentWindow.document.getElementById("menuTable");
	var btnItems = $(menuTable).find(".b-m-item");
	
	var sHTML = "<div class='b-m-item' id='menuItemDivId"+btnItems.length+"' onmouseover=\"this.className='b-m-ifocus'\" onmouseout=\"this.className='b-m-item'\" unselectable='on'>";  
	sHTML += "<div class='b-m-ibody' unselectable='on'>";  
	sHTML += "<nobr unselectable='on'>";  
	sHTML += "<img width='16' align='absmiddle' src='/wui/theme/ecology8/skins/default/contextmenu/CM_icon7_wev8.png'>";  
	sHTML += "<button title='"+returnStr+"' style='width: 120px;' onclick='javascript:parent.doBackCustomSearch()'>"+returnStr+"</button>";  
	sHTML += "</nobr></div></div>";  
	var index = 2;
	if(index>btnItems.length-1){
		index = btnItems.length-1;
	}
	$(btnItems.get(index)).after(sHTML);
	
	$("#rightMenuIframe").css("height",(btnItems.length+1)*22);
}

var ModeListener = null;
jQuery(document).ready(function(){
	ModeListener = new Listener();
	ModeListener.load("input[onpropertychange!='']");
	ModeListener.start(500,"onpropertychange");
	loadListener();
	<%
	if(type==2){
	%>
	__browserNamespace__.hoverShowNameSpan(".e8_showNameClass");
	<%}%>
});

function checkFileRequired(fieldid){
	if(jQuery("#needcheck").val().indexOf("field"+fieldid)>-1){
		var isReturn = false;
		jQuery("#fsUploadProgress"+fieldid+" .progressBarStatus").each(function(i,obj){
			if(jQuery(obj).text()!='Cancelled'){
				isReturn = true;
				return false
			}
		})
		if(isReturn){
			jQuery("#field_"+fieldid+"span").hide();
		}else{
			if(jQuery("#field"+fieldid).val()==''
					||jQuery("#field"+fieldid).val()=='NULL'
					||jQuery("#field"+fieldid).val()=='null'){
				jQuery("#field_"+fieldid+"span").show();
			}else{
				jQuery("#field_"+fieldid+"span").hide();
			}
		}
	}
}

var msgWarningJinEConvert = "<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage())%>";//金额转换长度限制提示信息
</script>
<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>
<script language=javascript src="/js/checkData_wev8.js"></script>
<script language=javascript src="/wui/common/jquery/plugin/Listener_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
<!-- browser 相关 -->
<script type="text/javascript" src="/formmode/js/modebrow_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script>
chromeOnPropListener = null;
//加载监听器
function loadListener(){
	if(chromeOnPropListener==null){
		chromeOnPropListener = new Listener();
	}else{
		chromeOnPropListener.stop();
	}
	chromeOnPropListener.load("[_listener][_listener!='']");
	chromeOnPropListener.start(500,"_listener");
}
</script>
<script type="text/javascript">

function openHrefWithChinese(url){
    url = dealChineseOfFieldParams(url);
    window.open(url);
}

//encodeURIComponent
function dealChineseOfFieldParams(url){
	if(url.indexOf("/workflow/request/AddRequest.jsp")==-1 && url.indexOf("/formmode/view/AddFormMode.jsp") != 0) {
		return url;
	}
	var params = "";
	var path = url.substring(0,url.indexOf("?")+1);
	var filedparams = url.substring(url.indexOf("?")+1);
	var fieldparam = filedparams.split("&");
	 for(var i=0;i<fieldparam.length;i++) {
		var tmpindex = fieldparam[i].indexOf("=");
		if(tmpindex != -1) {
			var key = fieldparam[i].substring(0, tmpindex);
			var value = encodeURIComponent(fieldparam[i].substring(tmpindex+1));
			params+="&"+key+"="+value
		}
	} 
	return path+params.substring(1);
}

function changecancleon(obj){
	var del = jQuery(obj).find("[name*=_del_]");
	if(del.length>0){
		var arr = del.get(0).id.split("_del_");
		if(arr.length>0){
			var objid =arr[0];
			 var readOnly = jQuery("#"+objid).attr("readonly");
			 if(readOnly&&readOnly==true){
				 return;
			 }
		}
	}
	jQuery(obj).find(".fieldClassChange").css("background-color","#f4fcff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","block");
}

function changecancleout(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#ffffff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","none");
}

function changecancleonnew(obj){
	var del = jQuery(obj).find("[name*=_del_]");
	if(del.length>0){
		var arr = del.get(0).id.split("_del_");
		if(arr.length>0){
			var objid =arr[0];
			 var readOnly = jQuery("#"+objid).attr("readonly");
			 if(readOnly&&readOnly==true){
				 jQuery(obj).find("#fielddownloadChange").find("span").css("display","block");
				 return;
			 }
		}
	}
	
	jQuery(obj).find(".fieldClassChange").css("background-color","#f4fcff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","block");
	jQuery(obj).find("#fielddownloadChange").find("span").css("display","block");
}

function changecancleoutnew(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#ffffff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","none");
	jQuery(obj).find("#fielddownloadChange").find("span").css("display","none");
}
function setFieldElementDisd(fieldid,flag){
		jQuery("#field"+fieldid).attr("readonly",flag);
}

function onChangeSharetypeNew2(obj,delspan,delid,showid,names,ismand,Uploadobj){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84051, user.getLanguage()) %>"+names+"<%=SystemEnv.getHtmlLabelName(84498, user.getLanguage()) %>", function(){
	    jQuery(obj).parent().parent().parent().parent().css("display","none");
		var subTableDocDelIds = jQuery("#subTableDocDelIds");//要删除的附件的id
		var docDelids = subTableDocDelIds.val()+","+showid;
		subTableDocDelIds.val(docDelids);
		
	    var fields = delid.split("_");
		var fieldid=fields[0]+"_"+fields[1];
	    var linknum=delid.substr(delid.lastIndexOf("_")+1);
		var fieldidnum=fieldid+"_idnum_1";
		var fieldidspan=fieldid+"span";
	    var delfieldid=fieldid+"_id_"+linknum;
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
	  	var isMustInput = jQuery("#"+fieldid).attr("isMustInput");
	    if(isMustInput){
	    	if(isMustInput=="2"){//必填
	    		ismand = "1";
	    	}else if(isMustInput=="1"){//可编辑
	    		ismand = "0";
	    	}
	    }
		if (ismand=="1"){
			if ($GetEle(fieldidnum).value=="0"){
			    $GetEle(fieldid).value="";
			    var swfuploadid=fieldid.replace("field","");
			    var fieldidnew = "field"+swfuploadid;
			    var fieldidspannew = "field_"+swfuploadid+"span";
			    var linkrequired=$GetEle("oUpload_"+swfuploadid+"_linkrequired");
			    $GetEle(fieldidspannew).innerHTML="";
	        	jQuery("#"+fieldidspannew).show();
		        if(Uploadobj.getStats().files_queued==0){
					$GetEle(fieldidspannew).innerHTML="<%=SystemEnv.getHtmlLabelName(81909,user.getLanguage()) %>";
					var checkstr_=$GetEle("needcheck").value+",";
					if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
		        }
		        if(linkrequired && linkrequired.value=="false"){
		        	$GetEle(fieldidspannew).innerHTML="";
		        }
		  	}else{
		  	 var swfuploadid=fieldid.replace("field","");
		     var fieldidspannew = "field_"+swfuploadid+"span";
			 $GetEle(fieldidspannew).innerHTML="";
		  	}
		}else{//add by td78113
			var swfuploadid=fieldid.replace("field","");
		    var fieldidnew = "field"+swfuploadid;
		    var fieldidspannew = "field_"+swfuploadid+"span";
			if(jQuery("#"+fieldidnew).attr("viewtype")=="1"){
				if(Uploadobj.getStats().files_queued==0){
					$GetEle(fieldidspannew).innerHTML="<%=SystemEnv.getHtmlLabelName(81909,user.getLanguage()) %>";
					var checkstr_=$GetEle("needcheck").value+",";
					if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
			    }
			}
		    
			try{
				displaySWFUploadError(fieldid);
			}catch(e){}
		}
		////
		var leaveNum = jQuery("#"+fieldid).val();
		if(leaveNum == "" || leaveNum == null){
			var upid = fieldid.substr(5);
			jQuery("#field_upload_"+upid).attr("disabled","disabled");
		}
	}, function () {}, 320, 90,true);
}
<%
String selectfieldlable="";
rs.executeSql("select * from workflow_billfield where id="+selectcategory);
if(rs.next()){
	String _fieldlabel = Util.null2String(rs.getString("fieldlabel"));
	selectfieldlable = SystemEnv.getHtmlLabelName(Util.getIntValue(_fieldlabel),user.getLanguage());
}
String selectfieldvalue = "";
String _isdefault = ""; 
String _tdocCategory = "";	
String _selectvalue = "";	
SecCategoryComInfo SecCategoryComInfo1 = new SecCategoryComInfo();
Map<String,String> secMaxUploads = new HashMap<String,String>();
Map<String,String> secCategorys = new HashMap<String,String>();
rs.executeSql("SELECT selectvalue,docCategory,isdefault FROM workflow_SelectItem WHERE fieldid="+selectcategory+" ORDER BY listorder");
while(rs.next()){
  	_tdocCategory = rs.getString(2).trim();
  	_isdefault = Util.null2String(rs.getString(3));
	_selectvalue = rs.getString(1).trim();
  	if("y".equals(_isdefault)){
  		selectfieldvalue = _selectvalue;
  	}
  	if(!"".equals(_tdocCategory)){
  		int _tsecid = Util.getIntValue(_tdocCategory.substring(_tdocCategory.lastIndexOf(",")+1),-1);
             String _tMaxUploadFileSize = ""+Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+_tsecid),5);
             secMaxUploads.put(_selectvalue,_tMaxUploadFileSize);
             secCategorys.put(_selectvalue,_tdocCategory);
  	}
}
if(!"".equals( ResolveFormMode.getSelectfieldvalue()))
	selectfieldvalue = ResolveFormMode.getSelectfieldvalue();
%>

//var oUploadArray = new Array();
var oUploadfieldidArray = new Array();
<%
if(uploadfieldids!=null){
	
   	for(int i=0;i<uploadfieldids.size();i++){
   %>
//oUploadArray.push(oUpload<%=uploadfieldids.get(i)%>);
oUploadfieldidArray.push("<%=uploadfieldids.get(i)%>");
<%
	}
}
%>
var selectValues = new Array();
var maxUploads = new Array();
var uploadCategorys=new Array();
function setMaxUploadInfo()
{
<%
if(secMaxUploads!=null&&secMaxUploads.size()>0)
{
	Set selectValues = secMaxUploads.keySet();

	for(Iterator i = selectValues.iterator();i.hasNext();)
	{
		String value = (String)i.next();
		String maxUpload = (String)secMaxUploads.get(value);
		String uplCategory=(String)secCategorys.get(value);
%>
		selectValues.push('<%=value%>');
		maxUploads.push('<%=maxUpload%>');
        uploadCategorys.push('<%=uplCategory%>');
<%
	}
}
%>
}
setMaxUploadInfo();

function reAccesoryChanage(){
	<%
    for(int i=0;i<uploadfieldids.size();i++){
    	String uploadfieldidtmp = Util.null2String(uploadfieldids.get(i));
    	if(uploadfieldidtmp.indexOf("_")>-1){
    		continue;
    	}
    %>
    checkfilesize(oUpload<%=uploadfieldids.get(i)%>,maxUploadImageSize,uploaddocCategory);
    showmustinput(oUpload<%=uploadfieldids.get(i)%>);
    <%}%>
	
	checkfilesize2();
}

function changeMaxUpload2(fieldid,derecorderindex){

   var uploadMaxFieldisedit = jQuery("#uploadMaxField").attr("isedit");
   
   if(!!uploadMaxFieldisedit && uploadMaxFieldisedit=="1"){
	    var selectfieldv = jQuery("#"+fieldid).val();
		for(var i = 0;i<selectValues.length;i++)
		{
			var value = selectValues[i];
			if(value == selectfieldv)
			{
				maxUploadImageSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		jQuery("#selectfieldvalue").val(selectfieldv);
		if(selectfieldv=="")
		{
			maxUploadImageSize = 0;
			uploaddocCategory=null;
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
		}else{
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>");
			});
		}
	}else{
   
    <%
	if(categorytype==1){
	    if((selectcategory+"").equals("")){
	%>
			maxUploadImageSize = 0;
			uploaddocCategory = null;
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
	<%  }else{%>
	        for(var i = 0;i<selectValues.length;i++)
			{
				var value = selectValues[i];
				if(value == "<%=selectfieldvalue%>")
				{
					maxUploadImageSize = parseFloat(maxUploads[i]);
	                uploaddocCategory=uploadCategorys[i];
				}
			}
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>");
			});
	<%
		}
	}
	%>
	}
}


//选择目录时，改变对应信息
function changeMaxUpload(fieldid)
{
	var efieldid = $GetEle(fieldid);
	if(efieldid){
		var tselectValue = efieldid.value;
		for(var i = 0;i<selectValues.length;i++){
			var value = selectValues[i];
			if(value == tselectValue){
				maxUploadImageSize = parseFloat(maxUploads[i]);
				if(maxUploadImageSize<=0){
					maxUploadImageSize = 5;
				}
                uploaddocCategory=uploadCategorys[i];
			}
		}
// 		jQuery("#selectfieldvalue").val(tselectValue);
		if(tselectValue==""){
			maxUploadImageSize = 0;
			uploaddocCategory = null;
// 			attachmentDisabled(oUploadArray,true,oUploadfieldidArray);
			attachmentArrayDisd(oUploadfieldidArray,true);
			var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
		}else{
			jQuery("span[id^='uploadspan']").each(function(){
				var viewtype = jQuery(this).attr("viewtype");
				if(viewtype == 1){
				    jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>");
				}else{
					jQuery(this).html("<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>");
				}
			});
// 			attachmentDisabled(oUploadArray,false,oUploadfieldidArray);
			attachmentArrayDisd(oUploadfieldidArray,false);
		}
	}
}


<%
if(categorytype==1){
%>
function addRowCheckMaxUpload(){
setTimeout(function(){
	changeMaxUpload('field<%=selectcategory%>');},1000)
}
function initUploadMax(){
	try{
    	<%
    	if(selectfieldvalue.equals("")){
    	%>
		setTimeout(function(){
				maxUploadImageSize = 0;
				uploaddocCategory = null;
// 				attachmentDisabled(oUploadArray,false,oUploadfieldidArray);
				attachmentArrayDisd(oUploadfieldidArray,true);
				
				var fieldlable = "<%=selectfieldlable%>";
				jQuery("span[id^='uploadspan']").each(function(){
					jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
				});
			},2000);
		<%}else{%>
			for(var i = 0;i<selectValues.length;i++){
				var value = selectValues[i];
				if(value == "<%=selectfieldvalue%>"){
					maxUploadImageSize = parseFloat(maxUploads[i]);
                	uploaddocCategory=uploadCategorys[i];
				}
			}
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>");
			});
		<%}%>
    	
    }catch(e){}
}

initUploadMax();
<%if(selectcategory>0){%>
jQuery(document).ready(function(){
	setTimeout(function(){changeMaxUpload('field<%=selectcategory%>');reAccesoryChanage();},1000);
})
<%}%>
<%}%>

function attachmentArrayDisd(oUploadfieldidArray,disd){
	for(var i=0;i<oUploadfieldidArray.length;i++){
		if(oUploadfieldidArray[i].indexOf("_")>-1){
			jQuery("input[name^='field"+oUploadfieldidArray[i]+"']").each(function(i,val){
				var tempname = jQuery(val).attr("name");
				if(tempname.indexOf("_del")>-1||tempname.indexOf("_id")>-1){
					return true;
				}
				if(tempname!=null&&tempname.length>0){
					tempfieldid = tempname.substring(5);
					attachmentDisd(tempfieldid,disd);
					setFieldElementDisd(tempfieldid,false);
				}
			})
		}else{
			attachmentDisd(oUploadfieldidArray[i],disd);
			setFieldElementDisd(oUploadfieldidArray[i],false);
		}
	}
}
jQuery(document).ready(function(){
//ping外网 百度地图
<%if(ResolveFormMode.isMapLayout()){%>
	pingmap();
<%}%>

	jQuery(".samllmapdisplay").each(function(i,val){
		try{
		jQuery(val).click(function(){
			showMapDialog(jQuery(val).attr("fieldid").replace("field",""),"D");
		})
		var mapid = jQuery(val).attr("id");
		var map = new BMap.Map(mapid,{enableMapClick:false});//初始化地图      
		map.addControl(new BMap.OverviewMapControl());  
		var point=new BMap.Point(116.404, 39.915);
		map.centerAndZoom(point, 15);
		map.enableScrollWheelZoom();//启动鼠标滚轮缩放地图
		var searchaddress = jQuery(val).attr("fieldvalue");
		var marker ; //初始化地图标记
		var gc = new BMap.Geocoder();//地址解析类
		var geolocation = new BMap.Geolocation();
		gc.getPoint(searchaddress, function(point){
			if (point) {
				if(marker){
					map.removeOverlay(marker);
				}
				marker = new BMap.Marker(point);
				map.addOverlay(marker);
				map.panTo(point);
			}else{
			}
		}, "");
		}catch(e){}
	})

})

var ispingmap = 1;//0没有ping -1 ping不通   1 ping通
function pingmap(){
  	var p = new Ping();
  	var pingnum = 0;
	p.ping("http://map.baidu.com", function(data) {
        pingnum = data;
        if(pingnum>0){
	     	if(pingnum>1000){
	     		//ispingmap = -1;
	     		jQuery(".samllmapdisplay").each(function(i,val){
	     			jQuery(val).html("无法链接到互联网!<br/>1.请检查网线是否接好<br/>2.请检查网络是否可以链接互联网");
	     		})
	     	}else{
	     		//ispingmap = 1;
	     	}
	    }
     },1500);
}
function mapdisabled(){
	jQuery(".mapimage").attr("src","/formmode/images/mapunuse.png");
	jQuery(".mapimage").attr("title","<%=SystemEnv.getHtmlLabelName(127295 , user.getLanguage()) %>");
}
function showFormModeMap(fieldid,maptype){
	if(ispingmap==1){
		showMapDialog(fieldid,maptype);
	}else if(ispingmap = 0){
		pingmap(fieldid);
	}else if(ispingmap = -1){
		return;//ping不通外网则不弹出地图
	}
}
function showMapDialog(fieldid,maptype){
	var dialogurl ="";
	if(maptype&&maptype=='D'){
		var mapvalue = jQuery("#field"+fieldid).val();
		dialogurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/view/FormModeMap.jsp?fieldid="+fieldid+"&maptype="+maptype+"&fieldvalue="+mapvalue); 
	}else{
		var mapvalue = jQuery("#field"+fieldid).val();
		dialogurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/view/FormModeMap.jsp?fieldid="+fieldid+"&maptype="+maptype+"&fieldvalue="+mapvalue);
	}
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.callbackfun = function(data){
		var addressinfo = wuiUtil.getJsonValueByIndex(data, 0);
		var typestr = wuiUtil.getJsonValueByIndex(data, 1);
		if(typestr==2){
			jQuery("#field"+fieldid).val(addressinfo);
			if(jQuery("#field"+fieldid+"span")){
				if(jQuery("#field"+fieldid+"span").attr("isedit")!=1){
					jQuery("#field"+fieldid+"span").html(addressinfo);
				}
			}
		}else{
			var temp = jQuery("#field"+fieldid).val();
			jQuery("#field"+fieldid).val(temp+addressinfo);
			if(jQuery("#field"+fieldid+"span")){
				if(jQuery("#field"+fieldid+"span").attr("isedit")!=1){
					jQuery("#field"+fieldid+"span").html(temp+addressinfo);
				}
			}
		}
	}
	dialog.URL = dialogurl;
	dialog.Width = 800 ;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();
}
</script>
<%if(ResolveFormMode.isMapLayout()){%>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=<%=Prop.getPropValue("map", "baidumapversion") %>&ak=<%=Prop.getPropValue("map", "baidumapak")%>"></script>
<%} %></body>
</html>