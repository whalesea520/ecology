<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.formmode.service.ExpandInfoService"%>
<%@page import="weaver.formmode.interfaces.InterfaceTransmethod"%>
<%@page import="weaver.formmode.service.ModelInfoService"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.formmode.interfaces.action.WSActionManager"%>
<%@page import="weaver.formmode.interfaces.dmlaction.commands.bases.DMLActionBase"%>
<%@page import="weaver.formmode.interfaces.action.SapActionManager"%>
<%@page import="weaver.interfaces.workflow.action.Action"%>
<%@page import="weaver.formmode.setup.ExpandBaseRightInfo"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.formmode.service.CommonConstant"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<jsp:useBean id="ExpandBaseRightInfo" class="weaver.formmode.setup.ExpandBaseRightInfo" scope="page" />
<%
int id = Util.getIntValue(request.getParameter("id"), 0);
int oldid = Util.getIntValue(request.getParameter("oldid"), 0);
ExpandInfoService expandInfoService = new ExpandInfoService();
Map<String, Object> data = expandInfoService.getExpandInfoAndModeById(id);
String expendname = Util.null2String(data.get("expendname"));
String expenddesc = Util.null2String(data.get("expenddesc"));
String modename = Util.null2String(data.get("modename"));
int modeid = Util.getIntValue(Util.null2String(data.get("modeid")),0);
int formid = Util.getIntValue(Util.null2String(data.get("formid")),0);
int showtype = Util.getIntValue(Util.null2String(data.get("showtype")),0);
int opentype = Util.getIntValue(Util.null2String(data.get("opentype")),0);
int hreftype = Util.getIntValue(Util.null2String(data.get("hreftype")),0);
int hrefid = Util.getIntValue(Util.null2String(data.get("hrefid")),0);
String hreftarget = Util.null2String(data.get("hreftarget"));
int isshow = Util.getIntValue(Util.null2String(data.get("isshow")),0);
float showorder = Util.getFloatValue(Util.null2String(data.get("showorder")),0.0f);
int issystem = Util.getIntValue(Util.null2String(data.get("issystem")),0);
int isbatch = Util.getIntValue(Util.null2String(data.get("isbatch")),0);
int issystemflag = Util.getIntValue(Util.null2String(data.get("issystemflag")),0);
int defaultenable = Util.getIntValue(Util.null2String(data.get("defaultenable")),0);
int createpage = Util.getIntValue(Util.null2String(data.get("createpage")),0);
int managepage = Util.getIntValue(Util.null2String(data.get("managepage")),0);
int viewpage = Util.getIntValue(Util.null2String(data.get("viewpage")),0);
int moniterpage = Util.getIntValue(Util.null2String(data.get("moniterpage")),0);
int tabshowtype = Util.getIntValue(Util.null2String(data.get("tabshowtype")),0);//tab显示形式  0:顶部、  1:内嵌 
int isquickbutton = 0;
if(",2,10,3,1,".indexOf(","+issystemflag+",") > -1){
	isquickbutton = Util.getIntValue(Util.null2String(data.get("isquickbutton")),1);
}else{
	isquickbutton = Util.getIntValue(Util.null2String(data.get("isquickbutton")),0);
}
ExpandBaseRightInfo.setUser(user);
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

boolean issystemmenu = (issystem==1);//是否为系统菜单
String hrefname = InterfaceTransmethod.getHrefName(String.valueOf(hrefid), String.valueOf(hreftype));
if(hreftype==4){
	hrefname = "<a href=\""+"javascript:modifyfeild("+hrefid+")\">"+hrefname+"</a>";
}
String operationStr = "edit";
if(id==0){
	operationStr = "add";
	modeid = Util.getIntValue(Util.null2String(request.getParameter("modeid")),0);
	Map<String, Object> modeMap = expandInfoService.getModeinfoById(modeid);
	modename = Util.null2String(modeMap.get("modename"));
	formid =Util.getIntValue(Util.null2String(modeMap.get("formid")),0);
	isshow = 1;
}
int istriggerwf = Util.getIntValue(request.getParameter("istriggerwf"),0);
String interfaceaction = Util.null2String(request.getParameter("interfaceaction"));
String javafilename = "";
String javafileAddress="";
String sql = "select mainid,interfacetype,interfacevalue,javafileAddress from mode_pageexpanddetail where mainid = " + id;
RecordSet rs = new RecordSet();
rs.executeSql(sql);
while(rs.next()){
	String interfacetype = Util.null2String(rs.getString("interfacetype"));
	String interfacevalue = Util.null2String(rs.getString("interfacevalue"));
	if(interfacetype.equals("1")){
		istriggerwf =  Util.getIntValue(interfacevalue,0);
	}else if(interfacetype.equals("2")){
		interfaceaction =  interfacevalue;
	}else if(interfacetype.equals("3")){
		javafilename =  interfacevalue;
	}
    javafileAddress = Util.null2String(rs.getString("javafileAddress"));
    
}
String  oldJavaFileName="";
if(!"".equals(javafilename)&&"".equals(javafileAddress)){
    Map<String, String> sourceCodePackageNameMap = CommonConstant.SOURCECODE_PACKAGENAME_MAP;
    String sourceCodePackageName = sourceCodePackageNameMap.get("5");
    String classFullName = sourceCodePackageName + "." + javafilename.replace(".java","");
    javafileAddress=classFullName;
    oldJavaFileName=javafileAddress;
}
String subCompanyIdsql = "select subCompanyId from modeinfo where id="+modeid;
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

boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formid);
boolean isShowRight = true;
boolean isShowCondition = true;

switch(issystemflag) {
	case 1: // 新建保存
	case 2: // 编辑保存
	case 3: // 查看编辑
	case 4: // 查看共享
	case 5: // 查看删除
	case 6: // 监控删除
	case 8: // 清空条件
	case 10: // 保存并新建
	case 100: // 搜索
	case 101: // 新建
	case 102: // 删除
	case 103: // 批量导入
	case 104: // 批量共享
		isShowRight = false;
		isShowCondition = false;
		break;
	case 12: // 批量生成二维码
	case 105: // 导出
	case 106: // 显示列定制
		isShowCondition = false;
		break;
}

if(isbatch == 1) {
	isShowCondition = false;
}
if(id <= 0) {
	isShowRight = false;
	isShowCondition = false;
}

%>
<html>
<head>
<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<style type="text/css">
.codeEditFlag{
    padding-left:20px;
    padding-right: 3px;
    height: 20px;
    background:transparent url('/formmode/images/code_wev8.png') no-repeat !important;
    cursor: pointer;
    margin-left: 2px;
    margin-top: 2px;
    position: relative;
    display: block;
    float: left;
}

.codeDownFlag{
    padding-left:20px;
    padding-right: 10px;
    height: 22px;
    background:transparent url('/formmode/images/codeDown_wev8.png') no-repeat !important;
    cursor: pointer;
    margin-left: 2px;
    position: relative;
    display: block;
    float: left;
}
.codeDelFlag{
	position: absolute;
	top: 2px;
	right: 2px;
	width:9px;
	height:9px;
	background:transparent url('/images/messageimages/delete_wev8.gif') no-repeat !important;
	cursor: pointer;	
}
</style>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function () {
	$(".codeDelFlag").click(function(e){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23271, user.getLanguage())%>？",function(){
			$("#javafilename_span").html("");
			$("#javafilename").val("");
			$(".codeDelFlag").hide();
		});
		e.stopPropagation(); 
	});
	if(jQuery("#hreftype").val()=="4"){
		$("#hreftargetImage").hide();
	}
	
	onShowPrompt();
});
function onShowPrompt(){
	if( "<%=isShowRight%>" == "false"){
		return;
	}
	var isbatch = jQuery("#isbatch").val();
	jQuery(".expandBaseRightIds").each(function(){
		var val = jQuery(this).val();
		var rigthtype = jQuery("#righttype"+val).val();
		var hascondition = jQuery("#hascondition"+val).val();

		if(rigthtype == 6 ) {
			if(isbatch == 1 || isbatch == 2) {
				jQuery("#rightprompt"+val).show();
			} else {
				jQuery("#rightprompt"+val).hide();
			}
		} else if(hascondition == "true"){
			if(isbatch == 1 || isbatch == 2) {
				jQuery("#conditionprompt"+val).show();
			} else {
				jQuery("#conditionprompt"+val).hide();
			}
		}
	});
}
function reloadWin(){
	window.location.href = window.location.href;
}

function getHrefTarget(event,datas,name,_callbackParams){
	if (datas){
  	    if(datas.id!=""){
  		    $("#hrefid").val(datas.id);
 		    $("#hrefidspan").html(datas.name);
 		    $("#hrefidImage").hide();
			$("#hreftargetImage").hide();
  	    }else{
  		    $("#hrefid").val("");
  			$("#hrefidspan").html("");
  			$("#hrefidImage").show();
			$("#hreftargetImage").show();
  		}
  	}	
	var hreftype = jQuery("select[name=hreftype]").val();
	var hrefid = jQuery("input[name=hrefid]").val();
	if(hreftype!=""&&hrefid!=""){
		var url = "/formmode/interfaces/ModePageExpandAjax.jsp?hrefid="+hrefid+"&hreftype="+hreftype;
		jQuery.ajax({
			url : url,
			type : "post",
			processData : false,
			data : "",
			dataType : "text",
			async : true,
			success: function do4Success(msg){
				var returnurl = jQuery.trim(msg);
				jQuery("#hreftarget").val(returnurl);
				if(returnurl==""){
					jQuery("#hreftargetspan").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\"/>");
				}else{
					jQuery("#hreftargetspan").html("");
				}
			}
		});
	}else{
		jQuery("#hreftarget").val("");
		jQuery("#hreftargetspan").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\"/>");
	}
}
function detailSet(){
	if(<%=id%><=0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30183,user.getLanguage())%>");
		return;
	}
	var hreftype = jQuery("select[name=hreftype]").val();
	var hrefid = jQuery("input[name=hrefid]").val();
	var modeid = jQuery("input[name=modeid]").val();
	url = "/formmode/interfaces/ModePageExpandRelatedFieldSet.jsp?modeid="+modeid+"&hreftype="+hreftype+"&hrefid="+hrefid+"&pageexpandid="+<%=id%>;
   	showColDialog1("/systeminfo/BrowserMain.jsp?url="+escape(url));
   	//var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape(url));
   	//if (datas){
   	//    if(datas.id!=""){
   	//	    $(inputName).val(datas.id);
   	//		if ($(inputName).val()==datas.id){
   	//	    	$(spanName).html(datas.name);
   	//		}
   	//    }else{
   	//	    $(inputName).val("");
   	//		$(spanName).html("");
   	//	}
   	//}
}

var dialog = null;
function showColDialog1(url){
   	dialog = new top.Dialog();
   	dialog.currentWindow = window;
   	dialog.okLabel = "<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>";//确定
   	dialog.cancelLabel = "<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";//取消
   	dialog.Drag = true;
   	dialog.Title = "<%=SystemEnv.getHtmlLabelName(82081,user.getLanguage())%>";//设置关联字段
   	dialog.Width = 600;
   	dialog.Height = 600;
   	dialog.callbackfun = function(callbackfunParam, data){
	   	if (datas){
	   	    if(datas.id!=""){
	   		    $(inputName).val(datas.id);
	   			if ($(inputName).val()==datas.id){
	   		    	$(spanName).html(datas.name);
	   			}
	   	    }else{
	   		    $(inputName).val("");
	   			$(spanName).html("");
	   		}
	   	}
    }
   	dialog.URL = url;
	dialog.show();
}

function closeColDialog(){
	dialog.close();
}

function getOnShowConditionUrl(){
	var url = escape("/formmode/interfaces/showcondition.jsp?isbill=1&formid=<%=formid%>&id=<%=id%>");
	url = "/systeminfo/BrowserMain.jsp?url="+url
    return url;
}

function onShowCondition(spanName){
	if(<%=id%><=0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30183,user.getLanguage())%>");
		return;
	}
	var url = escape("/formmode/interfaces/showcondition.jsp?isbill=1&formid=<%=formid%>&id=<%=id%>");
   	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
   	if (typeof(datas)!="undefined"){
   	    if(datas!=""){
  		    	//$(spanName).html("<img src=\"/images/BacoCheck_wev8.gif\" border=\"0\" complete=\"complete\"/>");
   	    	$(spanName).html(datas);
   	    }else{
   			$(spanName).html("");
   		}
   	}
}
function addCondition(rightid,objid,objspan){
	var url = "/formmode/interfaces/ExpandRightCondition.jsp?modeid=<%=modeid%>&rightid="+rightid;
	showDivDiaog(url,800,500,"<%=SystemEnv.getHtmlLabelName(82394,user.getLanguage())%>" );
}
var divdlg;
function showDivDiaog(url, width, height, title){
	divdlg = top.createTopDialog();
    divdlg.currentWindow = window;
	divdlg.Model = true;
	divdlg.Width = width;//定义长度
	divdlg.Height = height;
	divdlg.URL = url;
	divdlg.Title = title;
	divdlg.callback = function(datas){
		
	};
	divdlg.show();
}
function closeDivDialog(){
	divdlg.close();
}
function closeDivDialogAndReload(){
	divdlg.close();
	window.location.reload();
}

function submitData(){
	var javafileAddress =$("#javafileAddress").val();
   var checkAddress=true;
   if(javafileAddress!=""){
       var url = "/formmode/setup/codeEditAction.jsp?action=checkFileAddress&javafileAddress="+javafileAddress;
       $.ajax({
        url: url,
        data: "", 
        dataType: 'json',
        type: 'POST',
        async : false,
        success: function (result) {
           var status = result.status;
           if("0"==status){
             alert("<%=SystemEnv.getHtmlLabelName(382919, user.getLanguage())%>");
             checkAddress=false;
            }
        }
       });
    }
    if("<%=oldJavaFileName%>"!=""&&javafileAddress=="<%=oldJavaFileName%>"){
      $("#javafileAddress").val("");
    }else{
       $("#javafilename").val("");
    }
    if (checkAddress){
	    var action = $("#id").val()==0 ? "create" : "modify";
	    $("#WeaverForm").attr("action", "/ServiceAction/data.servlet.PageExpandAction?action="+action);
        document.getElementById("WeaverForm").submit();
    }
}

function onShowTypeChange(){
	var showtype = jQuery("#showtype").val();
	var hreftype = jQuery("#hreftype").val();
	var isbatch = jQuery("#isbatch").val();
	var isshow = jQuery("#isshow").val();
	if(showtype=="1"){
		jQuery("#opentype").hide();
		jQuery("#opentypetr").hide();
		jQuery("#relatedfieldtr").show();
		jQuery("#tabshowtype_span").show();
		jQuery("#quickbutton").hide();
	}else if(showtype=="2"){
		jQuery("#opentype").hide();
		jQuery("#opentypetr").show();
		if(hreftype=="2"){
			jQuery("#relatedfieldtr").hide();
		}
		jQuery("#tabshowtype_span").hide();
		if(isbatch == 0 || isbatch == 2){	      
	        if(isshow ==  1){
	    		jQuery("#quickbutton").show();
	    	}
	    }
	}
	handShowTypeSpan();
}

function onHrefTypeChange(){
	var hreftype = jQuery("#hreftype").val();
	if(hreftype=="1"){
		jQuery("#hrefidtr").show();
		jQuery("#hrefidlinetr").show();
		jQuery("#relatedfieldtr").show();
		jQuery("#hrefid").val("");
		jQuery("#hrefidspan").html("");
		jQuery("#hreftarget").val("");
		jQuery("#hrefidImage").show();
		jQuery("#batchmodeifyspan").hide();
		jQuery("#hrefTargetTr").show();  //链接目标地址
	}else if(hreftype=="2"){
		jQuery("#hrefidtr").hide();
		jQuery("#hrefidlinetr").hide();
		jQuery("#relatedfieldtr").hide();
		jQuery("#batchmodeifyspan").hide();
		jQuery("#hreftarget").val("");
		jQuery("#hrefTargetTr").show();  //链接目标地址
	}else if(hreftype=="3"){
		jQuery("#relatedfieldtr").show();
		jQuery("#hrefidtr").show();
		jQuery("#hrefidlinetr").show();
		jQuery("#hrefid").val("");
		jQuery("#hrefidspan").html("");
		jQuery("#hreftarget").val("");
		jQuery("#hrefidImage").show();
		jQuery("#batchmodeifyspan").hide();
		jQuery("#hrefTargetTr").show();  //显示链接目标地址
	}else if(hreftype=="4"){
		jQuery("#batchmodeifyspan").show();
		jQuery("#hrefidtr").show();
		jQuery("#hrefid").val("");
		jQuery("#hrefidspan").html("");
		//批量更改字段值时 链接目标地址隐藏zwbo  其他情况要显现		
		jQuery("#hrefTargetTr").hide();
	}
}

function changeIsBatch(obj){
	if(obj.value=='1'){
		jQuery("#pageselect").hide();
		//扩展用途调整时 页面选择的隐藏操作  zwbo
		jQuery("#quickbutton").hide();
		handShowType(true);
	}else{
	    if(obj.value=='0' || obj.value=='2'){
	       var tempisbatch = jQuery("#isbatch");
	       var isshow = jQuery("#isbatch").val();
	       if(tempisbatch == 1 && isshow == 1){
	           jQuery("#quickbutton").show();	
	       }
	    }else{
	    	jQuery("#quickbutton").hide();	
	    }
		jQuery("#pageselect").show();			
		handShowType(false);
	}
	jQuery("#batchmodeifyspan").hide();	
	handbatchmodify();
	onShowTypeChange();
	onShowPrompt();
}

function handShowTypeSpan() {
	var obj = jQuery("#isbatch");
	if(obj.val()=='2') {
		var showtype = jQuery("#showtype").val();
		if(showtype==1){
			jQuery("#showing_type_span").show();
		}else{
			jQuery("#showing_type_span").hide();
		}
	}else {
		jQuery("#showing_type_span").hide();
	}
}

function handShowType(isQueryList) {
	var hasExistTabPage = false;
	jQuery("#showtype").selectbox("detach");//禁用
	jQuery("#showtype option").each(function() {
		if(isQueryList && ($(this).text() == "<%=SystemEnv.getHtmlLabelName(30171,user.getLanguage())%>")) {//Tab页面
			$(this).remove();
		}
		if(!isQueryList && ($(this).text() == "<%=SystemEnv.getHtmlLabelName(30171,user.getLanguage())%>")) {//Tab页面
			hasExistTabPage = true;
		}
	});
	if(!isQueryList && !hasExistTabPage) {
		$("#showtype").prepend("<option value='1' selected><%=SystemEnv.getHtmlLabelName(30171,user.getLanguage())%></option>");//Tab页面
	}
	jQuery("#showtype").selectbox("attach");//启用
}	

function handbatchmodify(){
	var isVirtualForm = jQuery("#isVirtualForm").val();
	var isbatchvalue = jQuery("#isbatch").val();
	jQuery("#hreftype").selectbox("detach");
	if(isbatchvalue==1){
		var isBatchmodify=false;
		jQuery("#hreftype option").each(function() {
			if(jQuery(this).text() == "<%=SystemEnv.getHtmlLabelName(125139,user.getLanguage())%>") {//批量更改字段值
				isBatchmodify = true;
			}
		});
		if(!isBatchmodify){
			jQuery("#hreftype option[value=2]").remove();			
			if(isVirtualForm=="false"){					
				jQuery("#hreftype").append("<option value=4><%=SystemEnv.getHtmlLabelName(125139,user.getLanguage())%></option>");//批量更改字段值
			}
			jQuery("#hreftype").append("<option value=2><%=SystemEnv.getHtmlLabelName(30176,user.getLanguage())%></option>");//手动输入
		}
	}else{
		jQuery("#hreftype option").each(function() {
			if(jQuery(this).text() == "<%=SystemEnv.getHtmlLabelName(125139,user.getLanguage())%>") {//批量更改字段值
				jQuery(this).remove();
			}
		});
	}
	jQuery("#hreftype").selectbox("attach");//启用
}
	
function handbatchmodify1(){
	var isbatchvalue = jQuery("#isbatch").val();
	jQuery("#hreftype").selectbox("detach");
	if(isbatchvalue==1){
		var isBatchmodify=false;
		jQuery("#hreftype option").each(function() {			
			if(jQuery(this).text() == "<%=SystemEnv.getHtmlLabelName(125139,user.getLanguage())%>") {//批量更改字段值				
				isBatchmodify = true;
			}
		});
		if(!isBatchmodify){
			jQuery("#hreftype option[value=2]").remove();
			jQuery("#hreftype").append("<option value=4><%=SystemEnv.getHtmlLabelName(125139,user.getLanguage())%></option>");//批量更改字段值
			jQuery("#hreftype").append("<option value=2><%=SystemEnv.getHtmlLabelName(30176,user.getLanguage())%></option>");//手动输入
		}
	}else{
		jQuery("#hreftype option").each(function() {
			if(jQuery(this).text() == "<%=SystemEnv.getHtmlLabelName(125139,user.getLanguage())%>") {//批量更改字段值
				jQuery(this).remove();
			}
		});
	}
	jQuery("#hreftype").selectbox("attach");//启用
}
	
$(document).ready(function(){//onload事件
	onShowTypeChange();
	if(<%=hreftype%>==2){
		jQuery("#hrefidtr").hide();
		jQuery("#hrefidlinetr").hide();
		jQuery("#relatedfieldtr").hide();
	}
	if (jQuery("#isbatch").val() == 1) {
		jQuery("#pageselect").hide();
	} 
	//onHrefTypeChange();
	handShowTypeSpan();
	handbatchmodify1();
})




function checkFieldValue(ids){
	var idsArr = ids.split(",");
	for(var i=0;i<idsArr.length;i++){
		var obj = document.getElementById(idsArr[i]);
		if(obj&&obj.value==""){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
			return false;
		}
	}
	return true;
}

function doAdd(){
	enableAllmenu();
    location.href="/formmode/setup/expandBase.jsp?modeid=<%=modeid%>&oldid="+$("#id").val();
}

function doBack(){
	enableAllmenu();
	window.location.href = "/formmode/setup/expandList.jsp?modeid=<%=modeid%>";
}

function doSubmit(){
   var javafileAddress =$("#javafileAddress").val();
   var checkAddress=true;
   if(javafileAddress!=""){
       var url = "/formmode/setup/codeEditAction.jsp?action=checkFileAddress&javafileAddress="+javafileAddress;
       $.ajax({
        url: url,
        data: "", 
        dataType: 'json',
        type: 'POST',
        async : false,
        success: function (result) {
           var status = result.status;
           if("0"==status){
             alert("<%=SystemEnv.getHtmlLabelName(382919, user.getLanguage())%>");
             checkAddress=false;
            }
        }
       });
    }
    if("<%=oldJavaFileName%>"!=""&&javafileAddress=="<%=oldJavaFileName%>"){
      $("#javafileAddress").val("");
    }else{
       $("#javafilename").val("");
    }
    if(checkAddress){
	    enableAllmenu();
	    var checkfieldids="modeid,expendname,hreftarget";
	    if(jQuery("#hreftype").val()=="4"){
	        checkfieldids="modeid,expendname,hrefid";
	    }
	    if((<%=issystem%>==1||checkFieldValue(checkfieldids))&&checkAddress){
	        document.getElementById("operation").value="<%=operationStr%>";
	        document.WeaverForm.action="/formmode/setup/expandSettingsActing.jsp";          
	        document.WeaverForm.submit();           
	    }
    }
}
function checkHref(){
	if(($("#hreftype").val()=="1" || $("#hreftype").val()=="3" || $("#hreftype").val()=="4") && $("#hrefid").val()==0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
		return false;
	}else{
		return true;
	}
}
function doDelete(){
   	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		enableAllmenu();
       	document.getElementById("operation").value="del";
       	document.WeaverForm.action="/formmode/setup/expandSettingsActing.jsp";		
       	document.WeaverForm.submit();
	});
}

    function onShowModeSelect(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }
    
    function editAction(actionid, actiontype_){
		var addurl = "";
		if(actiontype_ == 0){
			addurl = "/formmode/interfaces/dmlaction/DMLActionSettingEdit.jsp?actionid="+actionid+"&modeid=<%=modeid%>&expandid=<%=id%>";
			//addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/dmlaction/DMLActionSettingEdit.jsp?actionid="+actionid+"&modeid=<%=modeid%>&expandid=<%=id%>");
		}else if(actiontype_ == 1){
			addurl = "/formmode/interfaces/action/WsActionEditSet.jsp?actionid="+actionid+"&modeid=<%=modeid%>&expandid=<%=id%>";
			//addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/action/WsActionEditSet.jsp?actionid="+actionid+"&modeid=<%=modeid%>&expandid=<%=id%>");
		}else if(actiontype_ == 2){
			addurl = "/formmode/interfaces/action/SapActionEditSet.jsp?actionid="+actionid+"&&modeid=<%=modeid%>&expandid=<%=id%>";
			//addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/action/SapActionEditSet.jsp?actionid="+actionid+"&&modeid=<%=modeid%>&expandid=<%=id%>");
		}
		//var id_t = window.showModalDialog(addurl,window,"dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
		//window.location.reload();
		
		openDialog(addurl);
	}
    
    function openDialog(addurl){
    	dialog = new window.top.Dialog();
    	dialog.currentWindow = window;
    	//dialog.okLabel = "<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>";//确定
    	//dialog.cancelLabel = "<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";//取消
        //dialog.Drag = true;
    	dialog.Title = "DML" + "<%=SystemEnv.getHtmlLabelName(19665, user.getLanguage()) %>";
    	dialog.Width = 1000;
    	dialog.Height = 800;
    	dialog.CancelEvent=function(){window.location.reload();dialog.close();};
    	dialog.URL = addurl;
    	dialog.show();
    }
    function closeDialog(){
    	window.location.reload();
    	dialog.close();
    }
    function addRow(){
    	if(<%=id%><=0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30183,user.getLanguage())%>");//请先保存页面数据，再进行该设置
			return;
		}
		var addurl = "";
		var actionlist_t = document.getElementById("actionlist").value;
		if(actionlist_t == 1){
			addurl="/formmode/interfaces/dmlaction/DMLActionSettingAdd.jsp?modeid=<%=modeid%>&expandid=<%=id%>";
			//addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/dmlaction/DMLActionSettingAdd.jsp?modeid=<%=modeid%>&expandid=<%=id%>");
		}else if(actionlist_t == 2){
			//addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/action/WsActionEditSet.jsp?operate=addws&modeid=<%=modeid%>&expandid=<%=id%>");
			addurl = "/formmode/interfaces/action/WsActionEditSet.jsp?operate=addws&modeid=<%=modeid%>&expandid=<%=id%>";
		}else if(actionlist_t == 3){
			addurl = "/formmode/interfaces/action/SapActionEditSet.jsp?operate=adsap&modeid=<%=modeid%>&expandid=<%=id%>";
		//	addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/action/SapActionEditSet.jsp?operate=adsap&modeid=<%=modeid%>&expandid=<%=id%>");
		}
		//var id_t = window.showModalDialog(addurl,window,"dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
	//	window.location.reload();
		openDialog(addurl);
	}

function delRow()
	{
		var hasselected = false;
		var dmlids = document.getElementsByName("dmlid");
		if(dmlids&&dmlids.length>0)
		{
			for(var i = 0;i<dmlids.length;i++)
			{
				var dmlid = dmlids[i];
				if(dmlid.checked)
				{
					hasselected = true;
					break;
				}
			}
		}
		if(!hasselected)
		{
			//请先选择需要删除的数据
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage())%>");
			return;
		}
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
			$G("operation").value="deletedmlaction";
	        enableAllmenu();
	        document.WeaverForm.submit();
		});
	}
    
function getModeBrowserUrl(){
	var hreftype = jQuery("select[name=hreftype]").val();
	if(hreftype=="1"){//模块
		url = "/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp?titleid=2";
	}else if(hreftype=="3"){//模块查询列表
		url = "/systeminfo/BrowserMain.jsp?url=/formmode/search/CustomSearchBrowser.jsp";
	}else if(hreftype=="4"){//批量修改
		url="/systeminfo/BrowserMain.jsp?url=/formmode/setup/batchmodifyBrowser.jsp?modeid=<%=modeid%>&action=create&formid=<%=formid%>";
		//url = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/addbatchmodify.jsp?modeid=<%=modeid%>&action=create";
	}
	return url;
}
function addRowPerms(){
	if(<%=id%><=0){
		alert("<%=SystemEnv.getHtmlLabelName(30183,user.getLanguage())%>");//请先保存页面数据，再进行该设置
		return; 
	}
	var addurl = "/formmode/setup/expandBasePermsAdd.jsp?modeid=<%=modeid%>&expandid=<%=id%>";
	addurl= "/systeminfo/BrowserMain.jsp?url="+escape(addurl);
	showDivDiaog(addurl,1000,650,"<%=SystemEnv.getHtmlLabelName(126564,user.getLanguage())%>" );
}
function delRowPerms(){
		var hasselected = false;
		var expandBaseRightids = document.getElementsByName("expandBaseRightIds");
		if(expandBaseRightids&&expandBaseRightids.length>0){
			for(var i = 0;i<expandBaseRightids.length;i++){
				var expandBaseRightid = expandBaseRightids[i];
				if(expandBaseRightid.checked){
					hasselected = true;
					break;
				}
			}
		}
		if(!hasselected){
			//请先选择需要删除的数据
			alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage())%>!");
			return;
		}
		if (isdel()){
			$G("operation").value="deleteExpandBaseRight";
	        enableAllmenu();
	        document.WeaverForm.submit();
		}
	}
function openCodeEdit(){
	top.openCodeEdit({
		"type" : "5",
		"filename" : $("#javafilename").val()
	}, function(result){
		if(result){
			var fName = result["fileName"];
			$("#javafilename_span").html(fName);
			$("#javafilename").val(fName);
			$(".codeDelFlag").show();
		}
	});
}

function chkAllClick(obj){
    var chks = document.getElementsByName("expandBaseRightIds");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        changeCheckboxStatus(chk, obj.checked);
    }
}

function modifyfeild(strid){
	__browserNamespace__.showModalDialogForBrowser(event,''+"/systeminfo/BrowserMain.jsp?url=/formmode/setup/addbatchmodify.jsp?modeid=<%=modeid%>&action=modify&id="+strid+'','#','hrefid',true,1,'',
{name:'hrefid',hasInput:false,zDialog:true,needHidden:true,dialogTitle:'',dialogWidth:900,arguments:'dialogWidth=900px',
_callback:getHrefTarget});
}
function addfeild(){
	__browserNamespace__.showModalDialogForBrowser(event,''+"/systeminfo/BrowserMain.jsp?url=/formmode/setup/addbatchmodify.jsp?modeid=<%=modeid%>&action=create"+'','#','hrefid',true,1,'',
{name:'hrefid',hasInput:false,zDialog:true,needHidden:true,dialogTitle:'',dialogWidth:900,arguments:'dialogWidth=900x',
_callback:getHrefTarget});
}

function openbox(obj){
    var name = obj.name;
	if(obj.checked){
		jQuery(obj).parent().find("input").val(1);
	}else{
		jQuery(obj).parent().find("input").val(0);
	}
	if(name == "isshow"){
        if(obj.value == 1){
           var isbatch = $("#isbatch").val();
           var showtype = $("#showtype").val();
           if(showtype == 2 && (isbatch == 0 || isbatch==2)){
               $("#quickbutton").show();
           }           
        }else{
           $("#quickbutton").hide();
        }
        
    }
}

function downloadMode(){
      top.location='/weaver/weaver.formmode.data.FileDownload?type=5';
}
</script>

</head>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){//保存
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:doBack(),_self} " ;//返回
RCMenuHeight += RCMenuHeightStep ;
if(id!=0){
	if(issystem!=1){
		if(operatelevel>1){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDelete(),_self} " ;//删除
			RCMenuHeight += RCMenuHeightStep ;
		}
	}
}
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<form id="WeaverForm" name="WeaverForm" action="/formmode/setup/expandSettingsActing.jsp" method="post">
<input type="hidden" name="id" id="id" value="<%=id %>" />
<input type="hidden" name="operation" id="operation" value="edit" />
<input type="hidden" name="issystem" id="issystem" value="<%=issystem %>" />
<input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
<input type="hidden" name="isVirtualForm" id="isVirtualForm" value="<%=isVirtualForm%>">
<table class="e8_tblForm">
<!-- 
 <tr >
	<td class="e8_tblForm_label" width="20%">
		<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%>
	</td>
	<td class="e8_tblForm_field">
	  		 <span id=modeidspan><%=modename%></span>
	  		 
	</td>
</tr>
 -->
<tr>
	<td class="e8_tblForm_label" width="20%">
		<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%><!-- 名称 -->
	</td>
	<td class="e8_tblForm_field">
		<input type="text" name="expendname" id="expendname" style="width:80%;" value="<%=expendname %>"  onchange="checkinput('expendname','expendnameImage')"/>
		<%if("".equals(expendname)){%>
		<span id="expendnameImage"> 
			<img src="/images/BacoError_wev8.gif"/>
		</span>
		<%}%>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label">
		<!-- 扩展类型 -->
		<%=SystemEnv.getHtmlLabelName(81468,user.getLanguage())%>
	</td>
	<td class="e8_tblForm_field">
		<%
			if(issystem==1){
		%>
				<%=SystemEnv.getHtmlLabelName(28119,user.getLanguage())%><!-- 系统默认 -->
		<%
			}else{
		%>
				<%=SystemEnv.getHtmlLabelName(73,user.getLanguage())%><!-- 用户自定义 -->
		<%
			}
		%>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label">
		<!-- 扩展用途 -->
		<%=SystemEnv.getHtmlLabelName(81469,user.getLanguage())%>
	</td>
	<td class="e8_tblForm_field">
		<%
			if(issystem==1){
				if(isbatch==0){
		%>
					<%=SystemEnv.getHtmlLabelName(81470,user.getLanguage())%><!-- 卡片页面 -->
		<%			
				}else if(isbatch==1){
		%>
					<%=SystemEnv.getHtmlLabelName(81471,user.getLanguage())%><!-- 查询列表(批量操作) -->
		<%
				}else if(isbatch==2){
		%>
					<%=SystemEnv.getHtmlLabelName(81510,user.getLanguage())%><!-- 卡片页面和查询列表 -->
		<%
				}
		%>
				<input type="hidden" id="isbatch" name="isbatch" value="<%=isbatch%>">
		<%
			}else{
		%>
				<select id="isbatch" name="isbatch" onchange="changeIsBatch(this)" style="width:150px;">
					<option value="0" <%if(isbatch==0)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(81470,user.getLanguage())%></option><!-- 卡片页面 -->
					<option value="1" <%if(isbatch==1)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(81471,user.getLanguage())%></option><!-- 查询列表(批量操作) -->
					<option value="2" <%if(isbatch==2)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(81510,user.getLanguage())%></option><!-- 卡片页面和查询列表 -->
				</select>
		<%
			}
		%>
		<%
			if(issystem!=1){
		%>
				<span id="pageselect">
					<%if(id==0){%>
						<input class="inputstyle" type="checkbox" id="createpage" name="createpage" value="1" checked="checked"><%=SystemEnv.getHtmlLabelName(31134,user.getLanguage())%><!-- 新建页面 -->
						<input class="inputstyle" type="checkbox" id="managepage" name="managepage" value="1" checked="checked"><%=SystemEnv.getHtmlLabelName(31135,user.getLanguage())%><!-- 编辑页面 -->
						<input class="inputstyle" type="checkbox" id="viewpage" name="viewpage" value="1" checked="checked"><%=SystemEnv.getHtmlLabelName(31136,user.getLanguage())%><!-- 查看页面 -->
					<%}else{ %>
						<input class="inputstyle" type="checkbox" id="createpage" name="createpage" value="1" <%if(createpage==1)out.println("checked"); %>><%=SystemEnv.getHtmlLabelName(31134,user.getLanguage())%><!-- 新建页面 -->
						<input class="inputstyle" type="checkbox" id="managepage" name="managepage" value="1" <%if(managepage==1)out.println("checked"); %>><%=SystemEnv.getHtmlLabelName(31135,user.getLanguage())%><!-- 编辑页面 -->
						<input class="inputstyle" type="checkbox" id="viewpage" name="viewpage" value="1" <%if(viewpage==1)out.println("checked"); %>><%=SystemEnv.getHtmlLabelName(31136,user.getLanguage())%><!-- 查看页面 -->
					<%}%>
				</span>

		<%
			}
		%>
	</td>
</tr>
<%
	if(!issystemmenu){
%>
		<tr>
			<td class="e8_tblForm_label" width="20%">
				<!-- 显示样式 -->
				<%=SystemEnv.getHtmlLabelName(23724,user.getLanguage())%>
			</td>
			<td class="e8_tblForm_field">
				<select id="showtype" name="showtype" onchange="onShowTypeChange(this)" style="width:150px;">
					<option value="1" <%if(showtype==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(30171,user.getLanguage())%></option><!-- Tab页面 -->
					<option value="2" <%if(showtype==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(30172,user.getLanguage())%></option><!-- 鼠标右键 -->
				</select>
				
				<span id="tabshowtype_span">
				<select id="tabshowtype" name="tabshowtype"  style="width:120px;">
					<option value="0" <%if(tabshowtype==0) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(22432,user.getLanguage())%></option><!-- 顶部 -->
					<option value="1" <%if(tabshowtype==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(126080,user.getLanguage())%></option><!-- 内嵌 -->
				</select>
				</span>
				<span style="cursor:pointer;color:#F00;" id="showing_type_span">
					&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(82082,user.getLanguage())%><!-- 查询列表不支持tab页显示 -->
				</span>
			</td>
		</tr>
		
		<tr id="opentypetr">
			<td class="e8_tblForm_label" width="20%">
				<!-- 打开方式-->
				<%=SystemEnv.getHtmlLabelName(30173,user.getLanguage())%>
			</td>
			<td class="e8_tblForm_field">
				<select id="opentype" name="opentype" style="width:150px;">
					<option value="1" <%if(opentype==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%></option><!-- 默认窗口-->
					<option value="2" <%if(opentype==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option><!-- 弹出窗口-->
					<option value="3" <%if(opentype==3) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option><!-- 其它-->
				</select>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%">
				<!-- 链接目标来源-->
				<%=SystemEnv.getHtmlLabelName(30174,user.getLanguage())%>
			</td>
			<td class="e8_tblForm_field">
				<select id="hreftype" name="hreftype" onchange="onHrefTypeChange(this)" style="width:150px;">
					<option value="1" <%if(hreftype==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%></option><!-- 模块-->
					<option value="3" <%if(hreftype==3) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(30175,user.getLanguage())%></option><!-- 模块查询列表-->
					<option value="4" <%if(hreftype==4) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(125139,user.getLanguage())%></option><!-- 批量更改字段值 -->
					<option value="2" <%if(hreftype==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(30176,user.getLanguage())%></option><!-- 手动输入-->
				</select>
			</td>
		</tr>

		<tr id="hrefidtr">
			<td class="e8_tblForm_label" width="20%">
				<!-- 选择链接目标-->
				<%=SystemEnv.getHtmlLabelName(30177,user.getLanguage())%>
			</td>
			<td class="e8_tblForm_field">
			<%
				String tempTitle = SystemEnv.getHtmlLabelNames("18214,30181",user.getLanguage());
			%>
				<brow:browser viewType="0" id="hrefid" name="hrefid" browserValue='<%= ""+hrefid %>' 
  		 				browserUrl="'+getModeBrowserUrl()+'" tempTitle="<%=tempTitle %>"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="510px"
						browserSpanValue='<%=hrefname %>'
						_callback="getHrefTarget"
						></brow:browser>
						<%
							String batchmodeifyDisplay="none";
							if(isbatch==1&&hreftype==4){
								batchmodeifyDisplay = "";
							}
						 %>&nbsp;&nbsp;&nbsp;
						<span id="batchmodeifyspan" style="color:red; display: <%=batchmodeifyDisplay%>;">
							<%
								String addstr = SystemEnv.getHtmlLabelName(125390,user.getLanguage());
								if(addstr.indexOf(SystemEnv.getHtmlLabelName(128166, user.getLanguage())) > -1){
									addstr = addstr.replace(SystemEnv.getHtmlLabelName(128166, user.getLanguage()), "<a href=\"javascript:addfeild();\">"+SystemEnv.getHtmlLabelName(128166, user.getLanguage())+"</a>");
								}else if(addstr.indexOf(SystemEnv.getHtmlLabelName(128166, user.getLanguage())) > -1){
									addstr = addstr.replace(SystemEnv.getHtmlLabelName(128166, user.getLanguage()), "<a href=\"javascript:addfeild();\">"+SystemEnv.getHtmlLabelName(128166, user.getLanguage())+"</a>");
								}else if(addstr.indexOf("here")>-1){
									addstr = addstr.replace("here", "<a href=\"javascript:addfeild();\">"+SystemEnv.getHtmlLabelName(128166, user.getLanguage())+"</a>");
								}
							%>
							<%=addstr%>
						</span>
						<!-- 可点击此处新增 -->
			</td>
		</tr>

		<!--批量更改字段值时 链接目标地址隐藏zwbo-->
		 <%
			 if(hreftype==4)
				out.println("<tr id=\"hrefTargetTr\" style=\"display:none \">");
			else
				out.println("<tr  id=\"hrefTargetTr\" >");
		 %>

			<td class="e8_tblForm_label" width="20%">
				<!-- 链接目标地址-->
				<%=SystemEnv.getHtmlLabelName(30178,user.getLanguage())%>
			</td>
			<td class="e8_tblForm_field" valign="top">
				<textarea id="hreftarget" name="hreftarget" class="inputstyle" rows="3" style="width:80%" onchange="checkinput('hreftarget','hreftargetImage')"><%=hreftarget%></textarea>
				<%if("".equals(hreftarget)){%>
				<span id="hreftargetImage"> 
					<img src="/images/BacoError_wev8.gif"/>
				</span>
				<%}%>

				<SPAN style="CURSOR:pointer;" id=remind><IMG id=ext-gen124  title="<%=SystemEnv.getHtmlLabelName(82358,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82359,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82360,user.getLanguage())%>#10;<%=SystemEnv.getHtmlLabelName(82361,user.getLanguage())%>" align=absMiddle src="/images/remind_wev8.png"></SPAN>
				<br>
				<!-- 如果链接目标地址不是手动输入地址，请勿随意修改这个字地址-->
				<%=SystemEnv.getHtmlLabelName(30179,user.getLanguage())%>
			</td>
		</tr>
		
		<tr id="relatedfieldtr">
			<td class="e8_tblForm_label" width="20%">
				<!-- 关联字段 -->
				<%=SystemEnv.getHtmlLabelName(30180,user.getLanguage())%>
			</td>
			<td class="e8_tblForm_field">
				<span id="relatedfield">
					<a href="javascript:detailSet()"><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%><!-- 设置 --></a>
				</span>
			</td>
		</tr>
<%
	}else{
%>
		<tr style="display:none">
			<td>
				<!-- 显示样式 -->
				<input type="hidden" id="showtype" name="showtype" value="<%=showtype%>">
				<!-- 打开方式-->
				<input type="hidden" id="opentype" name="opentype" value="<%=opentype%>">
				<!-- 链接目标来源-->
				<input type="hidden" id="hreftype" name="hreftype" value="<%=hreftype%>">
				<!-- 选择链接目标-->
				<input type="hidden" id="hrefid" name="hrefid" value="<%=hrefid%>">
				<!-- 链接目标地址-->
				<textarea id="hreftarget" name="hreftarget" class="inputstyle" rows="10" style="width:70%"><%=hreftarget%></textarea>
			</td>
		</tr>
<%
	}
%>
	
<tr>
	<td class="e8_tblForm_label">
		<!-- 是否显示	-->
		<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%>
	</td>
	<td class="e8_tblForm_field">
		<input type="checkbox" id="isshow" name="isshow" value="<%=isshow %>" onclick="openbox(this)" tzCheckbox="true"  <%if(isshow==1) out.println("checked");%>>
	</td>
</tr>
<%
String sdisplay = "display:none;";
if(issystem==1){
	if(isbatch==0){		
		if(isshow == 0){
			sdisplay = "display:none;";
		}	
    }
}else{
	if(isbatch==0 && showtype==2 ){
		sdisplay = "";
	}
	if(isshow == 0){
		sdisplay = "display:none;";
	}	
} %>
<tr id="quickbutton" style="<%=sdisplay%>">
		   <td class="e8_tblForm_label">快捷按钮</td>
		   <td class="e8_tblForm_field">
		       <input type="checkbox" name=isquickbutton value="<%=isquickbutton %>" onclick="openbox(this)" tzCheckbox="true" <%if(isquickbutton==1) out.println("checked");%> >
		   </td>
		</tr>
<% if(isShowRight) { %>
<TR class="e8_tblForm_field" style="height: 30px;">
	<TD style="font-weight: bold;background-color:#fff;">
			<!-- 扩展权限-->
			<%=SystemEnv.getHtmlLabelName(126564,user.getLanguage())%>
	</TD>
	<td class="e8_tblForm_field" align=right style="background-color:#fff;">
		<button type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" 
	      	class="addbtn2" onClick="javaScript:addRowPerms();">
	    </button><!-- 添加 -->
	    <button type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"
	      	class="deletebtn2" onclick="javaScript:delRowPerms();">
	    </button><!-- 删除 -->
	</td>
</TR>
<%
	List<ExpandBaseRightInfo> expandBaseRightInfoList = ExpandBaseRightInfo.getExpandBaseRightList(id, modeid);
	for(ExpandBaseRightInfo expandBaseRightInfo :expandBaseRightInfoList){
		int rightid = expandBaseRightInfo.getId();
		String conditiondesc = expandBaseRightInfo.getConditiondesc();
		int righttype = expandBaseRightInfo.getRighttype();
%>
<tr>
	<td class="e8_tblForm_label">
		<input type="checkbox" class="expandBaseRightIds" name="expandBaseRightIds" value="<%=expandBaseRightInfo.getId()%>">
	</td>
	<td class="e8_tblForm_field">
		<div style="float:left;padding-top: 5px;"><%=expandBaseRightInfo.getRelatedidValue()%></div>
		<%if(isShowCondition) { %>
		<div id="defConditionDiv_<%=rightid %>"  style="float:left;margin-left:15px;"  >  
			<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%><!-- 条件 -->
			<button class="addbtn2" title="<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>"  style="color:#018efb;"  onclick="addCondition('<%=rightid %>')" type="button"></button>
			<input type="hidden" name="defCondition_<%=rightid %>" id="defCondition_<%=rightid %>">
			<%if(!StringHelper.isEmpty(conditiondesc)){ %>
				<a href='javascript:void(0);'  style="color:#018efb;"  onclick="addCondition('<%=rightid %>')">
				  	<%=SystemEnv.getHtmlLabelName(15809,user.getLanguage())%><!-- 已设置条件 -->
				</a>
			<%} %>
		</div>
		<%} %>
		<input id="righttype<%=expandBaseRightInfo.getId() %>" type="hidden" value="<%=righttype %>">
		<input id="hascondition<%=expandBaseRightInfo.getId() %>" type="hidden" value="<%=!StringHelper.isEmpty(conditiondesc) %>">
		<div style="padding-top:5px;">
		<span id="conditionprompt<%=expandBaseRightInfo.getId() %>" style="display:none; cursor:pointer;color:#F00;">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(126450,user.getLanguage())%></span><!-- 扩展用途为查询列表条件不生效。 -->
		<span id="rightprompt<%=expandBaseRightInfo.getId() %>" style="display:none;cursor:pointer;color:#F00;">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(126574,user.getLanguage())%></span><!-- 扩展用途为查询列表继承建模编辑权限不生效。 -->
		</div>
	</td>	
</tr>
<%
	}
}
%>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(81710,user.getLanguage())%><!-- 描述 --><div class="e8_label_desc"></div></td>
	<td class="e8_tblForm_field">
		<textarea name="expenddesc" style="width:80%;"><%=expenddesc %></textarea>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label">
		<!-- 显示顺序-->
		<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%>
	</td>
	<td class="e8_tblForm_field">
		<input class="inputstyle" type="text" name="showorder" id="showorder" value="<%=showorder%>" size="5" onkeypress="ItemDecimal_KeyPress('showorder',15,2)" onblur="checknumber1(this);">
	</td>
</tr>
<!-- ------------------------------ -->
<TR class="e8_tblForm_field" style="height: 30px;">
	<TD colSpan=2 style="font-weight: bold;background-color:#fff;">
			<!-- 接口动作-->
			<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%>						
	</TD>
</TR>
<%
	if(!isVirtualForm){
%>
<tr>
	<td class="e8_tblForm_label">
		<%=SystemEnv.getHtmlLabelName(81457,user.getLanguage())%><!-- 是否触发审批工作流  -->
	</td>
	<td class="e8_tblForm_field">
		<input type="checkbox" id="istriggerwf" name="istriggerwf" value="<%=istriggerwf %>" onclick="openbox(this)" tzCheckbox="true"  <%if(istriggerwf==1)out.println("checked"); %>>
	</td>
</tr>
<%}%>
<tr <%if(interfaceaction.equals("")){%>style="display: none;"<%}%>>
	<td class="e8_tblForm_label">
		<%=SystemEnv.getHtmlLabelName(81456,user.getLanguage())%><!-- 外部接口动作 -->
	</td>
	<td class="e8_tblForm_field">
		<select id="interfaceaction" name="interfaceaction">
			<option value="" selected></option>
		<%
			String customeraction = "";
		    List l=StaticObj.getServiceIds(Action.class);
			if(!interfaceaction.equals("")){
		%>
			<option value='<%=interfaceaction%>' selected><%=interfaceaction%></option>
		<%
			}
			for(int i=0;i<l.size();i++){
		      	if(l.get(i).equals(interfaceaction)){
					continue;
				}
		%>
				<option value='<%=l.get(i)%>'><%=l.get(i)%></option>
		<%
			}
		%>
		</select>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label">
		<%=SystemEnv.getHtmlLabelName(82084,user.getLanguage())%><!-- 自定义java接口  -->
	</td>
	<td class="e8_tblForm_field">
			<input type="text" id="javafileAddress" name="javafileAddress" style="min-width:40%;float: left;" value="<%=javafileAddress%>"/>
            <%if(!"".equals(javafilename)){%>
            <span class="codeEditFlag" onclick="openCodeEdit();">
            </span>
            <input type="hidden" id="javafilename" name="javafilename" value="<%=javafilename %>"/>
            <%}%>
            <span class="codeDownFlag" onclick="downloadMode()" title="<%=SystemEnv.getHtmlLabelName(382920, user
                                .getLanguage())%>"></span>
            <br/><br/><span style="Letter-spacing:1px;"><%=SystemEnv.getHtmlLabelName(384524, user
                                .getLanguage())%>weaver.formmode.customjavacode.modeexpand.XXX。</span>
	</td>
</tr>

<tr><td colspan="3">
	<table width="100%" class="liststyle" cellspacing="1"  >
		<COLGROUP>
		<COL width="5%">
		<COL width="35%">
		<COL width="35%">
		<COL width="25%">
		<TR class="Spacing" style="height: 1px;"><TD class="Line1" colspan=5 style="padding: 0px;"></TD></TR>
		<TR>
		<td colSpan="3" width="65%"><!-- 其他接口动作 -->
			<%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%>：
			<select id="actionlist" name="actionlist"><!-- 接口动作 -->
				<option value="1">DML<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
				<!-- 
					<option value="2">WebService<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
					<option value="3">SAP<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
				 -->
			</select>
		</td>
		<TD align="right" width="35%">
		
			<DIV align=right style="margin-top: 3px;margin-right: 3px;">
			<BUTTON type='button' class=btn_actionList onclick=addRow();><SPAN style="padding: 5px 10px;background-image: none;"><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%></SPAN></BUTTON><!-- 增加 -->
				&nbsp;&nbsp;
			<BUTTON type='button' class=btn_actionList onclick=delRow();><SPAN style="padding: 5px 10px;background-image: none;"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></SPAN></BUTTON><!-- 删除 -->
			</DIV>
		</TD>
	</TR>
	<TR class="Spacing" style="height: 1px;"><TD class="Line1" colspan=5 style="padding: 0px;"></TD></TR>
	<%
	DMLActionBase dmlActionBase = new DMLActionBase();
	List actionList = dmlActionBase.getDMLActionByNodeOrLinkId(id,modeid);
	boolean islight = false;
	for(int i =0;i<actionList.size();i++)
	{
		List dmlList = (List)actionList.get(i);
		if(dmlList==null||dmlList.size()<3)
		{
			continue;
		}
		String dmlid = (String)dmlList.get(0);
		String dmlactionname = (String)dmlList.get(1);
		String dmltype = (String)dmlList.get(2);
	%>
	<tr class="<%if(islight){ %>datalight<%}else{%>datadark<%} %>">
		<td>
			<input type="checkbox" id="dmlid" name="dmlid" value="<%=dmlid%>">
			<input type="hidden" id="actiontype<%=dmlid%>" name="actiontype<%=dmlid%>" value="0">
		</td>
		<td nowrap>
			<a href="#" onclick="editAction('<%=dmlid %>', 0);"><%=dmlactionname %></a>
		</td>
		<td nowrap>
			DML<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><!-- 接口动作 -->
		</td>
		<td>
			<%=dmltype %><%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%><!-- 操作 -->
		</td>
	</tr>
	<%
		islight = islight?false:true;
	}
	//webservice action 列表
	WSActionManager wsActionManager = new WSActionManager();
	wsActionManager.setActionid(0);
	ArrayList wsActionList = wsActionManager.doSelectWsAction(id,modeid);
	for(int i =0;i<wsActionList.size();i++){
		ArrayList wsAction = (ArrayList)wsActionList.get(i);
		int actionid_t = Util.getIntValue((String)wsAction.get(0));
		String actionname_t = Util.null2String((String)wsAction.get(1));
	%>
		<tr class="<%if(islight){ %>datalight<%}else{%>datadark<%} %>">
			<td>
				<input type="checkbox" id="dmlid" name="dmlid" value="<%=actionid_t%>">
				<input type="hidden" id="actiontype<%=actionid_t%>" name="actiontype<%=actionid_t%>" value="1">
			</td>
			<td nowrap>
				<a href="#" onclick="editAction('<%=actionid_t%>', 1);"><%=actionname_t%></a>
			</td>
			<td colspan="2" nowrap>
				WebService<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><!-- 接口动作 -->
			</td>
		</tr>
	<%
		islight = islight?false:true;
	}
	//sap action 列表
	SapActionManager sapActionManager = new SapActionManager();
	ArrayList sapActionList = sapActionManager.getSapActionSetList(id,modeid);
	for(int i =0;i<sapActionList.size();i++){
		ArrayList sapAction = (ArrayList)sapActionList.get(i);
		int actionid_t = Util.getIntValue((String)sapAction.get(0));
		String actionname_t = Util.null2String((String)sapAction.get(1));
	%>
	
	<tr class="<%if(islight){ %>datalight<%}else{%>datadark<%} %>">
		<td>
			<input type="checkbox" id="dmlid" name="dmlid" value="<%=actionid_t%>">
			<input type="hidden" id="actiontype<%=actionid_t%>" name="actiontype<%=actionid_t%>" value="2">
		</td>
		<td nowrap>
			<a href="#" onclick="editAction('<%=actionid_t%>', 2);"><%=actionname_t%></a>
		</td>
		<td colspan="2" nowrap>
			Sap<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><!-- 接口动作 -->
		</td>
	</tr>
	<%
		islight = islight?false:true;
	}
	%>
	</table>
	</td>
</tr>	
</table>
</form>
</body>
</html>
