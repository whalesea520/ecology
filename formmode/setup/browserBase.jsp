<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.BrowserInfoService"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.workflow.workflow.BillComInfo"%>
<%@page import="weaver.formmode.service.CommonConstant"%>
<%@page import="weaver.formmode.service.AppInfoService"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%
int id = Util.getIntValue(request.getParameter("id"), 0);
String customname = "";
String customdesc = "";
String defaultSql = "";
int disQuickSearch = 0;
int opentype = 0;
String norightlist = "";
String formID = "";	
String formName = "";
String modeid = "";
String modename = "";
String isBill = "1";
String appid=Util.null2String(request.getParameter("appid"));
String dsporder = "";
int pagenumber = 10;
String searchconditiontype = "1";
String javafilename = "";
String isnullFun=CommonConstant.DB_ISNULL_FUN;
String javafileAddress="";


String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_custombrowser a,modeTreeField b WHERE a.appid=b.id AND a.id="+id;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
AppInfoService appInfoService = new AppInfoService();
Map<String, Object> appInfo = appInfoService.getAppInfoById(Util.getIntValue(appid));
String treelevel = Util.null2String(appInfo.get("treelevel"));
if(subCompanyId==-1){
	subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subcompanyid")),-1);
}
String userRightStr = "FORMMODEAPP:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);


BrowserInfoService browserInfoService=new BrowserInfoService();
BillComInfo billComInfo=new BillComInfo();
if(id!=0){
	Map<String,Object> map=browserInfoService.getBrowserInfoById(id);
	if(map.size()>0){
		customname=Util.toScreen(Util.null2String(map.get("customname")),user.getLanguage());
		customdesc=Util.toScreenToEdit(Util.null2String(map.get("customdesc")),user.getLanguage());
		defaultSql=Util.toScreenToEdit(Util.null2String(map.get("defaultsql")),user.getLanguage());
		formID=Util.null2String(map.get("formid"));
		//formName=formComInfo.getFormname(formID);
		formName = Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue(billComInfo.getBillLabel(formID)), user.getLanguage()));
		formName = "<a href=\"#\" onclick=\"toformtab('"+formID+"')\">"+formName+"</a>";
		modeid=Util.null2String(map.get("modeid"));
		searchconditiontype = Util.null2String(map.get("searchconditiontype"));
		searchconditiontype = searchconditiontype.equals("") ? "1" : searchconditiontype;
		javafilename = Util.null2String(map.get("javafilename"));
		if ("".equals(appid)) appid=Util.null2String(map.get("appid"));
		modeid = Util.null2String(map.get("modeid"));
		dsporder = Util.null2String(map.get("dsporder"));
		pagenumber = Util.getIntValue(Util.null2String(map.get("pagenumber")),10);
		norightlist = Util.null2String(map.get("norightlist"));
		javafileAddress = Util.null2String(map.get("javafileAddress"));
	}
}
String oldJavaFileName="";
if(!"".equals(javafilename)&&"".equals(javafileAddress)){
    Map<String, String> sourceCodePackageNameMap = CommonConstant.SOURCECODE_PACKAGENAME_MAP;
    String sourceCodePackageName = sourceCodePackageNameMap.get("3");
    String classFullName = sourceCodePackageName + "." + javafilename.replace(".java","");
    javafileAddress=classFullName;
    oldJavaFileName=javafileAddress;
    }
if(!"".equals(modeid)){
	rs.executeSql("select modename from modeinfo where id="+modeid+"");
	if(rs.next()){
		modename = rs.getString("modename");
	}
}
boolean hasTitleField = false;
if(id!=0){
	String sql = "select b.fieldname from mode_CustomBrowserDspField a,workflow_billfield b where a.fieldid = b.id and a.customid = "+id+" and a.istitle = '1'";
	rs.executeSql(sql);
	if(rs.next()){
		hasTitleField = true;
	}
}
int isvirtualform = 0;
if(!StringHelper.isEmpty(formID)) {
	rs.executeQuery("select isvirtualform from ModeFormExtend where formid=?",formID);
	if(rs.next()){
		isvirtualform = rs.getInt("isvirtualform");
	}
}

String titlename=SystemEnv.getHtmlLabelName(82016,user.getLanguage());//浏览框设置
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
.codeDelFlag{
	position: absolute;
	top: 4px;
	right: 2px;
	width:9px;
	height:9px;
	background:transparent url('/images/messageimages/delete_wev8.gif') no-repeat !important;
	cursor: pointer;	
}
</style>
<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
<script>
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
	},100);
}

function openCodeEdit(){
	top.openCodeEdit({
		"type" : "3",
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
function delJavaCode(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>",function(){
		if(<%=id%>!=0){
			jQuery.ajax({
			   type: "POST",
			   url: "/weaver/weaver.formmode.servelt.BrowserAction?action=delJavaCode&id=<%=id%>",
			   data: "",
			   success: function(data){}
			});
		}
		$("#javafilename").val("");
		$("#javafilename_span").html("");
		$(".codeDelFlag").hide();
	});
}
function checkVal(){
				var valid=false;
				var checkrule='^(-?\\d+)(\\.\\d+)?$';
				var dsporder=document.getElementById("dsporder").value;
				eval("valid=/"+checkrule+"/.test(\""+dsporder+"\");");
				if (dsporder!=''&&!valid){
					alert('<%=SystemEnv.getHtmlLabelName(82018,user.getLanguage())%>');//显示顺序中请输入数字!
					document.getElementById("dsporder").value='';
				}
}
function checkPageNumVal(){
	var pagenumber=document.getElementById("pagenumber").value;
	if(!/^\+?[1-9][0-9]*$/.test(pagenumber)){
		document.getElementById("pagenumber").value='';
		document.getElementById("pagenumberspan").innerHTML="<font color='red'><%=SystemEnv.getHtmlLabelName(82019,user.getLanguage())%></font>";//输入值不符合正整数!
	}else{
		document.getElementById("pagenumberspan").innerHTML="";
	}
}

function downloadMode(){
      top.location='/weaver/weaver.formmode.data.FileDownload?type=3';
}

</script>
</head>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&treelevel.equals("0")&&id!=0)||fmdetachable.equals("1")&&!treelevel.equals("0")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;//保存
	RCMenuHeight += RCMenuHeightStep ;
}
if(id!=0){
	if(operatelevel>1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;//删除
		RCMenuHeight += RCMenuHeightStep;
	}
	RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javaScript:doPreview(),_self} " ;//预览
	RCMenuHeight += RCMenuHeightStep;
	if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&!treelevel.equals("0"))){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(33416,user.getLanguage())+",javascript:newBrowser(),_top} " ;//新建浏览框
		RCMenuHeight += RCMenuHeightStep ;
		
		//创建浏览按钮
		RCMenu += "{"+SystemEnv.getHtmlLabelName(28625,user.getLanguage())+",javascript:parent.createbrowser(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<form id="weaver" name="frmMain" method="post" action="/weaver/weaver.formmode.servelt.BrowserAction">
<input type="hidden" name="id" id="id" value="<%=id %>" />
<input type="hidden" name="appid" id="appid" value="<%=appid %>"/>
<input type="hidden" name="action" id="action" value="customedit"/>
<input type="hidden" name="fmdetachable" id="fmdetachable" value="<%=fmdetachable %>"/>
<input type="hidden" name="detailjson" id="detailjson" value=""/>
<table class="e8_tblForm">
<tr>
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(82014,user.getLanguage())%></td><!-- 自定义浏览框名称 -->
	<td class="e8_tblForm_field">
		<input type="text" name="customname" id="customname"  style="width:80%;" onchange='checkinput("customname","customnamespan")' value="<%=customname %>"/> 
		<SPAN id=customnamespan>
			<%if ("".equals(customname)) { %>
				<img src="/images/BacoError_wev8.gif"/>
			<% } %>
		</SPAN>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></td><!-- 表单名称 -->
	<td class="e8_tblForm_field">
		<%if(isvirtualform==1){ formName = formName + "<div class=\"e8_data_virtualform\" title=\""+SystemEnv.getHtmlLabelName(33885,user.getLanguage())+"\">V</div>";} %><!-- 虚拟表单 -->
		<%
			String tempTitle = SystemEnv.getHtmlLabelNames("18214,31923",user.getLanguage());
		%>
		<brow:browser viewType="0" name="formid" browserValue='<%=formID%>' 
 		browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormBrowser.jsp"
		hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
		completeUrl="/data.jsp?type=mdFormBrowser&rightStr=ModeSetting:All" linkUrl=""  width="228px"
		browserDialogWidth="500px" tempTitle="<%=tempTitle %>"
		browserSpanValue='<%=formName %>'
		_callback="changeModeId"
		></brow:browser>
	</td>
</tr>
<%
String _style = "display:none;";
if (!"".equals(formID)) { 
	_style = "";
}%>
<tr id="modetr" style="<%=_style%>">
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%></td><!-- 模块名称 -->
	<td class="e8_tblForm_field">
		
		<select id="modeid" name="modeid" onchange='checkinput("modeid","modespan")' style="width: 200px;">
			<option></option>
			<%if(!formID.isEmpty()){
				String modeSql = "select id,modename from modeinfo where formid="+formID+" and "+isnullFun+"(isdelete,0)!=1 ";
				if(fmdetachable.equals("1")){
	              	CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
		  			int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"ModeSetting:All",0);
		  			String subCompanyIds = "";
		  			for(int i=0;i<mSubCom.length;i++){
		  				if(i==0){
		  					subCompanyIds += ""+mSubCom[i];
		  				}else{
		  					subCompanyIds += ","+mSubCom[i];
		  				}
		  			}
		  			if(subCompanyIds.equals("")){
		  				modeSql+= " and 1=2 ";
		  			}else{
		  				modeSql+= " and subCompanyId in ("+subCompanyIds+") ";
		  			}
	          	}
				modeSql+="order by id";
				rs.executeSql(modeSql);
				boolean isInSubCompany = false;
				while(rs.next()){
					String mid = rs.getString("id");
					String mname = rs.getString("modename");
					if(mid.equals(modeid)){
						isInSubCompany = true;
					}
			%>
					<option <%if(mid.equals(modeid)){%>selected="selected"<%} %> value="<%=mid %>"><%=mname %></option>
			<%}
				if(!isInSubCompany){
					modeSql = "select id,modename from modeinfo where id="+modeid;
					rs.executeSql(modeSql);
					if(rs.next()){
						String mname = rs.getString("modename");
				%>
					<option  selected="selected"  value="<%=modeid %>"><%=mname %></option>
				<% } }	
			} %>
		</select>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(81366,user.getLanguage())%><!-- 固定查询条件 -->
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
			<textarea name="defaultsql" style="width:80%;height:50px;overflow:auto;"><%=defaultSql %></textarea>			
				<table>
					<tr>
						<td><span
							title='<%=SystemEnv.getHtmlLabelName(82350, user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82351, user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82352, user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82462, user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82463, user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82464, user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82465, user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(382960,user.getLanguage())%>&#10;'
							id="remind"> <img align="absMiddle" src="/images/remind_wev8.png">
							</span>
						</td>
					    <td style="padding-left: 5px;"><%=SystemEnv.getHtmlLabelName(81388,user.getLanguage())%><!-- 表单主表表名的别名为t1，明细表表名的别名为d1，查询条件的格式为: t1.a = '1' and t1.b = '3' and t1.c like '%22%' and d1.a = '1' and d1.b = '3' and d1.c like '%22%'。 -->
						</td>
					</tr>
				</table>	
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
                                .getLanguage())%>weaver.formmode.customjavacode.browser.XXX。</span>
		</div>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(17491,user.getLanguage())%><!-- 每页显示记录数 --></td>
	<td class="e8_tblForm_field">
		<input type="text" name="pagenumber" id="pagenumber" onchange="checkPageNumVal()" value="<%=pagenumber%>" />
		<span id="pagenumberspan"/>&nbsp;</span>
	</td>
</tr>
<tr class=isvirtualformhide style="display: <%=isvirtualform==1?"none":""%>">
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(81476,user.getLanguage())%></td><!-- 无权限列表 -->
	<td class="e8_tblForm_field"><input type="checkbox" name="norightlist" value="1" <%if("1".equals(norightlist))out.println("checked='checked'"); %>/></td>
</tr>
<tr>
    <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%><!-- 显示顺序 --></TD>
    <td class="e8_tblForm_field">
         <input type="text" name="dsporder" id="dsporder" onchange="checkVal()" value="<%=dsporder %>"/>
    </TD>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!-- 描述 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82015,user.getLanguage())%><!-- 描述自定义浏览框的用途。 --></div></td>
	<td class="e8_tblForm_field">
		<textarea name="customdesc" style="width:80%;height:50px;overflow:auto;"><%=customdesc %></textarea>
	</td>
</tr>
</table>
</form>

<script type="text/javascript">
function changeModeSel(){
	var modeid = document.getElementById("modeid");
	//删除所有的选择项
	for (var i = modeid.options.length-1; i >0; i--) {        
	        modeid.options.remove(i);        
	}
	var formid = $("#formid").val();
	if(formid!=""){
		jQuery.ajax({
		   type: "POST",
		   dataType:"json",
		   url: "/weaver/weaver.formmode.servelt.CustomSearchAction?action=getModeDataByFormId",
		   data: "formid="+formid,
		   success: function(data){
				if(data&&data.length>0){
					for(var i=0;i<data.length;i++){
						var varItem = new Option(data[i].modename, data[i].id);      
        				modeid.options.add(varItem); 
        				if(i==0){
        					modeid.value = data[i].id;
        				}
					}
				}
		   }
		});
	}
	
}

function submitData(){
    rightMenu.style.visibility = "hidden";
	if (<%=id==0%>) {
		$("#action").val("customadd");
	}
	var checkfields = "formid,customname";
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
	if (checkFieldValue(checkfields)&&checkAddress){
        enableAllmenu();
		frmMain.submit();
    }
}

function newBrowser(){
	parent.document.location.href = "browserInfo.jsp?appid=<%=appid%>";
}

function checkFieldValue(ids){
	var idsArr = ids.split(",");
	for(var i=0;i<idsArr.length;i++){
		var obj = document.getElementById(idsArr[i]);
		if(obj&&obj.value==""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
			return false;
		}
	}
	return true;
}

function doback(){
	enableAllmenu();
	location.href="/formmode/browser/CustomBrowser.jsp?appid=<%=appid%>";
}
function onDelete(){
    jQuery.ajax({
		type: "POST",
		dataType:"json",
		url: "/formmode/setup/BorwserOperation.jsp",
		data: "action=deleteBrowser&customid=<%=id%>",
		success: function(data){
			if(data.isref) {
            	top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(127325, user.getLanguage())%>');//被引用不允许删除
            } else {
            	rightMenu.style.visibility = "hidden";
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
					jQuery("#action").val("customdelete");
					//document.weaver.action.value="customdelete";
					enableAllmenu();
					frmMain.submit();
				});
            }
		}
	});
}

function onShowModeSelect(inputName, spanName){
	var formid_ = $("#formid").val();
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp?formid="+formid_);
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

function doCustomSearchBatchSet(){
    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(31851,user.getLanguage())%>",function(){
		location.href="/formmode/search/CustomSearchShare.jsp?id=<%=id%>";
	});
}

function doBatchSet(){
    enableAllmenu();
    location.href="/formmode/batchoperate/ModeBatchSet.jsp?id=<%=id%>";
}

function createbrowser_bak(){
	if(<%=hasTitleField%>){
		var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/CreateBrowser.jsp?customid=<%=id%>");
	}else{
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(82020,user.getLanguage())%>");//请先为浏览框设置标题字段！
	}
}

function onShowFormSelect(inputName, spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
			$("#modetr").css("display","");
	    }else{
		    $(inputName).val("");
			$(spanName).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$("#modeid").val("");
			$("#modetr").css("display","none");
		}
	    changeModeSel();
	} 
}

function toformtabFormChoosed(data){
	var dataArr=data.split("_");
	var formid=dataArr[0];
	var isvirtualform=dataArr[1];
	toformtab(formid,isvirtualform);
}

function toformtab(formid,isvirtualform){
    if (<%=isvirtualform%> == 1||isvirtualform==1) {
        FormmodeUtil.writeCookie(FormModeConstant._CURRENT_FORM, formid);
    	clickTopSubMenu(2);
    } else {
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;	
		var parm = "&formid="+formid;
		if(formid=='') {
			parm = '';
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82021,user.getLanguage())%>";//新建表单
		}else{
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82022,user.getLanguage())%>";//编辑表单
		}
		diag_vote.Width = 1000;
		diag_vote.Height = 600;
		diag_vote.Modal = true;
		
		diag_vote.URL = "/workflow/form/addDefineForm.jsp?dialog=1&isFromMode=1"+parm;
		diag_vote.isIframe=false;
		diag_vote.show();
	}
}

function clickTopSubMenu(menuIndex){
	var tDoc = top.document;
	var $submenusUL = $("#submenu", tDoc);
	$(".menuitem:eq("+menuIndex+")", $submenusUL).click();
}

function doPreview(){
	$("#rightMenu").css("visibility","hidden");
	var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			dialog.Width = 260 ;
			dialog.Height = 120;
			dialog.normalDialog = false;
			dialog.URL = "/formmode/setup/CustomTypeBrowser.jsp";
			dialog.callbackfun = function (paramobj, id1) {
				doPreviewBrowser(id1.id);
			} ;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%>";//提示信息
			dialog.Drag = true;
			dialog.show();
}

function doPreviewBrowser(type){
	var previewType = type;
	if(previewType==1){
		url = "/formmode/browser/CommonSingleBrowser.jsp?customid=<%=id%>&isview=1";
	}else{
		url = "/formmode/browser/CommonMultiBrowser.jsp?customid=<%=id%>&isview=1";
	}
	var dialogUrl = url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogUrl;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();
}

function changeModeId(e,json){
	if(<%=id%><=0){
		return;
	}
	if(json){
		var id = json.id;
		if(id==""){
			resetSelect("modeid",false);
		}else{
			$.ajax({
			   type: "POST",
			   dataType:"json",
			   url: "/weaver/weaver.formmode.servelt.CustomSearchAction",
			   data: "action=getModeDataByFormIdDetach&formid="+id+"&fmdetachable=<%=fmdetachable%>",
			   success: function(data){
			     resetSelect("modeid",true,data,true);
			   }
			});
		}
	}
}

/**
 * 
 * @param {Object} objid  要改变的select对象的id
 * @param {Object} flag  是否需要添加新数据
 * @param {Object} data  数据
 * @param {Object} isFirstSel  是否默认选中第一项
 */
function resetSelect(objid,flag,data,isFirstSel){
	var obj = jQuery("#"+objid);
	obj.selectbox("detach");
	obj.get(0).options.length = 0;
	obj.append("<option></option>");
	if(flag){
		for(var i=0;i<data.length;i++){
			if(i==0&&isFirstSel){//默认选中第一项
				obj.append("<option value='"+data[i].id+"' selected='selected' >"+data[i].name+"</option>");
			}else{
				obj.append("<option value='"+data[i].id+"' >"+data[i].name+"</option>");
			}
		}
	}
    obj.selectbox("attach");
}
</script>
</body>
</html>
