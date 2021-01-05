<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.service.CustomSearchService"%>
<%@page import="org.apache.lucene.util.StringHelper"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.workflow.workflow.BillComInfo"%>
<%@page import="weaver.formmode.service.CommonConstant"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%
int id = Util.getIntValue(request.getParameter("id"), 0);
int success = Util.getIntValue(request.getParameter("success"), 0);
String searchconditiontype = "1";
String defaultSql = "";
String javafilename = "";
int disQuickSearch = 0;
int opentype = 0;
int isvirtualform = 0;
String titlename=SystemEnv.getHtmlLabelName(82165,user.getLanguage());//布局明细表查询条件设置
String type = Util.null2String(request.getParameter("type"));
String modeId = Util.null2String(request.getParameter("modeId"));
String formId = Util.null2String(request.getParameter("formId"));
String layoutid = Util.null2String(request.getParameter("layoutid"));
String[] searchConditionTypeArr = request.getParameterValues("searchConditionType");
String defaultsql = "" + Util.fromScreen6(request.getParameter("defaultsql"),user.getLanguage());
if(searchConditionTypeArr != null && searchConditionTypeArr.length > 0){
	searchconditiontype = searchConditionTypeArr[0];
}

if("".equals(modeId)||"0".equals(modeId)){
	//只需要传递layoutid，其他字段信息可以获取
	rs.executeSql("select modeid,formid,type from modehtmllayout a where a.id="+layoutid);
	if(rs.next()){
		modeId = Util.null2String(rs.getString("modeid"));
		formId = Util.null2String(rs.getString("formId"));
	}
}
String javafileAddress="";
String sql = "";
if(id>0){
	sql = "select * from mode_layout_querySql where id = '"+id+"'";
	rs.executeSql(sql);
	if(rs.next()){
		defaultSql = Util.null2String(rs.getString("sqlConetent"));
		javafilename = Util.null2String(rs.getString("javaFileName"));
		searchconditiontype  = Util.null2String(rs.getString("queryType"));
		javafileAddress = Util.null2String(rs.getString("javafileAddress"));
	}
}else if(id<1){
	sql = "select * from mode_layout_querySql where layoutid ='"+layoutid+"' and detailtype='"+type+"'";
	rs.executeSql(sql);
	if(rs.next()){
		defaultSql = Util.null2String(rs.getString("sqlConetent"));
		javafilename = Util.null2String(rs.getString("javaFileName"));
		searchconditiontype  = Util.null2String(rs.getString("queryType"));
		id = Util.getIntValue(rs.getString("id"), 0);
		javafileAddress = Util.null2String(rs.getString("javafileAddress"));
	}
}
String oldJavaFileName="";
if(!"".equals(javafilename)&&"".equals(javafileAddress)){
    Map<String, String> sourceCodePackageNameMap = CommonConstant.SOURCECODE_PACKAGENAME_MAP;
    String sourceCodePackageName = sourceCodePackageNameMap.get("8");
    String classFullName = sourceCodePackageName + "." + javafilename.replace(".java","");
    javafileAddress=classFullName;
    oldJavaFileName=javafileAddress;
}
%>
<html>
<head>
	<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> 
<script language=javascript src="/js/weaver_wev8.js"></script>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<style>
a:hover{color:#0072C6 !important;}
.e8_data_virtualform{
	background: url(/formmode/images/circleBgGold_wev8.png) no-repeat 1px 1px;
	width: 16px;
	display:inline;
	color: #fff;
	font-size: 9px;
	font-style: italic;
	top: 5px;
	padding-left: 3px;
	padding-right: 6px;
	padding-top: 2px;
}
</style>
<style>
.cbboxContainer{
	margin: 3px 0px 0px -2px;
}
.cbboxEntry{
	display: inline-block;position: relative;padding-right: 20px;
}
.cbboxLabel{
	color: #999;font-size: 11px;position: absolute;top:2px;left:18px;
}
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
#detailtable_loading{
	position: absolute;top: 0px;left: 5px;z-index: 10000;
	padding: 3px 10px 3px 20px; 
	vertical-align:middle; 
	background-image: url('/images/messageimages/loading_wev8.gif');
	background-repeat: no-repeat;
	background-position: 0px center;
	color: #aaa;
	display: none;
}
#detailtable_tr{
	display:none;
}
</style>
<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
<script type="text/javascript">
var success = <%=success %>;
$(document).ready(function () {
	if(success==1){
		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>！');//保存成功
	}
	$(".codeDelFlag").click(function(e){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23271, user.getLanguage())%>？",function(){
			$("#javafilename_span").html("");
			$("#javafilename").val("");
			$(".codeDelFlag").hide();
		});
		e.stopPropagation(); 
	});
});
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
        rightMenu.style.visibility = "hidden";
	    enableAllmenu();
	    formCustomSearch.submit();
    }
}
function submitDataAndClose(){
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
		rightMenu.style.visibility = "hidden";
		document.getElementById("close").value = "1";
		enableAllmenu();
		formCustomSearch.submit();
	}
}
function clearData(){
	rightMenu.style.visibility = "hidden";
	document.getElementById("action").value = "clear";
	enableAllmenu();
	formCustomSearch.submit();
}
function changeSCT(cbObj){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			jQuery("input[type='checkbox'][name='searchConditionType']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		
		jQuery(".sctContent").hide();
		jQuery("#SCT_Div_"+objV).show();
	},100);;
}
function openCodeEdit(){
	openCodeEditReal({
		"type" : "8",
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
var codeDlg;
function openCodeEditReal(param, hookFn){
		var url = "/formmode/setup/codeEdit.jsp?1=1";
		if(param){
			for(var key in param){
				url += "&" + key + "=" + param[key];
			}
		}
		codeDlg = new Dialog();//获取Dialog对象
		codeDlg.Model = true;
		codeDlg.Width = 900;//定义长度
		codeDlg.Height = 548;
		codeDlg.URL = url;
		codeDlg.Title = "<%=SystemEnv.getHtmlLabelName(82032,user.getLanguage())%>";//代码编辑
		codeDlg.show();
		codeDlg.hookFn = hookFn;
}
function callCodeDlgHookFn(result){
		if(codeDlg && typeof(codeDlg.hookFn) == "function"){
			codeDlg.hookFn(result);
		}
}
	
function closeCodeEdit(){
	if(codeDlg){
		if(typeof(codeDlg.onCloseCallbackFn) == "function"){
			codeDlg.onCloseCallbackFn(result);
		}
		codeDlg.close();
		codeDlg = null;
	}
}
function downloadMode(){
      top.location='/weaver/weaver.formmode.data.FileDownload?type=8';
}
</script>
</head>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;//保存
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82036,user.getLanguage())+",javascript:submitDataAndClose(),_top} " ;//保存并关闭
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:clearData(),_self} " ;//清除
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<form id="formCustomSearch" name="formCustomSearch" method="post" action=LayoutDtlQuerySetOperation.jsp>
<input type="hidden" name="id" id="id" value="<%=id %>" />
<input type="hidden" name="action" id="action" value="save"/>
<input type="hidden" name="modeId" id="modeId" value="<%=modeId %>" />
<input type="hidden" name="formId" id="formId" value="<%=formId %>" />
<input type="hidden" name="type" id="type" value="<%=type %>" />
<input type="hidden" name="layoutid" id="layoutid" value="<%=layoutid %>" />
<input type="hidden" name="close" id="close" value="0" />
<table class="e8_tblForm">
<tr>
	<td class="e8_tblForm_label" style="width:15%; "><%=SystemEnv.getHtmlLabelName(81366,user.getLanguage())%><!-- 固定查询条件 -->
		<div class="cbboxContainer">
			<span class="cbboxEntry">
				<input type="checkbox" name="searchConditionType" value="1" <%if(searchconditiontype.equals("1")){%>checked="checked"<%}%> onclick="changeSCT(this);"/><span class="cbboxLabel">sql</span>
			</span>
			<span class="cbboxEntry">
				<input type="checkbox" name="searchConditionType" value="2" <%if(searchconditiontype.equals("2")){%>checked="checked"<%}%> onclick="changeSCT(this);"/><span class="cbboxLabel">java</span>
			</span>
		</div>
	</td>
	<td class="e8_tblForm_field" style="height:30px; vertical-align: top;">
		<div id="SCT_Div_1" class="sctContent" <%if(!searchconditiontype.equals("1")){%>style="display: none;"<%}%>>
			<textarea name="defaultsql" style="width:80%;height:50px;"><%=defaultSql %></textarea>

			<span title="<%=SystemEnv.getHtmlLabelName(82151,user.getLanguage())%>$UserId$
			<%=SystemEnv.getHtmlLabelName(16727,user.getLanguage())%>$UserCode$
<%=SystemEnv.getHtmlLabelName(82166,user.getLanguage())%>$DepartmentId$
<%=SystemEnv.getHtmlLabelName(82167,user.getLanguage())%>$AllDepartmentId$
<%=SystemEnv.getHtmlLabelName(82168,user.getLanguage())%>$SubcompanyId$
<%=SystemEnv.getHtmlLabelName(82169,user.getLanguage())%>$AllSubcompanyId$
<%=SystemEnv.getHtmlLabelName(15625,user.getLanguage())%>$date$ 
<%=SystemEnv.getHtmlLabelName(15626,user.getLanguage())%>$time$" id="remind">
				<img align="absMiddle" src="/images/remind_wev8.png">
			</span>
			<div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82170,user.getLanguage())%><!-- 条件格式为: b.a = '3' and b.c like '%22%' and b.d='PARM(参数)' and b.e='$date$'。 --></div>
		</div>
		<div id="SCT_Div_2" class="sctContent" <%if(!searchconditiontype.equals("2")){%>style="display: none;"<%}%>>
			<input type="text" id="javafileAddress" name="javafileAddress" style="min-width:40%;float: left;" value="<%=javafileAddress%>"/>
            <%if(!"".equals(javafilename)){%>
            <span class="codeEditFlag" onclick="openCodeEdit();">
            </span>
            <input type="hidden" id="javafilename" name="javafilename" value="<%=javafilename %>"/>
            <%}%>
            <span class="codeDownFlag" onclick="downloadMode()" title="<%=SystemEnv.getHtmlLabelName(382920, user
                                .getLanguage())%>"></span>
            <br>
            <br><span style="Letter-spacing:1px;"><%=SystemEnv.getHtmlLabelName(384524, user
                                .getLanguage())%>weaver.formmode.customjavacode.formlayout.XXX。</span>
		</div>
		
	</td>
</tr>
</table>
</form>
</body>
</html>
