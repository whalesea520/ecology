<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.CustomSearchService"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.workflow.workflow.BillComInfo"%>
<%@page import="weaver.formmode.service.CommonConstant"%>
<%@page import="weaver.formmode.service.AppInfoService"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)){
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
int iscustom = 1;
int isShowQueryCondition=0; 
String formID = "";	
String formName = "";
String modeid = "";
String modename = "";
String isBill = "1";
String appid=Util.null2String(request.getParameter("appid"));
String searchconditiontype = "1";
String javafilename = "";
String dsporder = "";
String javafileAddress="";
int pagenumber = 10;
String detailtable="";
String isnullFun=CommonConstant.DB_ISNULL_FUN;

CustomSearchService customSearchService=new CustomSearchService();
BillComInfo billComInfo=new BillComInfo();
if(id!=0){
	Map<String,Object> map=customSearchService.getCustomSearchById(id);
	if(map.size()>0){
		customname=Util.toScreen(Util.null2String(map.get("customname")),user.getLanguage());
		customdesc=Util.toScreenToEdit(Util.null2String(map.get("customdesc")),user.getLanguage());
		defaultSql=Util.toScreenToEdit(Util.null2String(map.get("defaultsql")),user.getLanguage());
		disQuickSearch=Util.getIntValue(Util.null2String(map.get("disquicksearch")));
		isShowQueryCondition=Util.getIntValue(Util.null2String(map.get("isShowQueryCondition")));
		opentype=Util.getIntValue(Util.null2String(map.get("opentype")));
		norightlist=Util.null2String(map.get("norightlist"));
		iscustom=Util.getIntValue(Util.null2String(map.get("iscustom")),1);
		formID=Util.null2String(map.get("formid"));
		billComInfo.updateCache(formID);
		formName = Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue(billComInfo.getBillLabel(formID)), user.getLanguage()));
		modeid=Util.null2String(map.get("modeid"));
		if(appid.equals("")||appid.equals("0")){
			appid=Util.null2String(map.get("appid"));
		}
		formName = "<a href=\"#\" onclick=\"toformtab('"+formID+"')\">"+formName+"</a>";
		if ("".equals(appid)) appid=Util.null2String(map.get("appid"));
		searchconditiontype = Util.null2String(map.get("searchconditiontype"));
		searchconditiontype = searchconditiontype.equals("") ? "1" : searchconditiontype;
		javafilename = Util.null2String(map.get("javafilename"));
		javafileAddress= Util.null2String(map.get("javafileAddress"));
		dsporder = Util.null2String(map.get("dsporder"));
		pagenumber = Util.getIntValue(Util.null2String(map.get("pagenumber")),10);
		detailtable=Util.null2String(map.get("detailtable"));
	}
}
if(!"".equals(modeid)){
	rs.executeSql("select modename from modeinfo where id="+modeid+"");
	if(rs.next()){
		modename = rs.getString("modename");
	}
}
int isvirtualform = 0;
if(!StringHelper.isEmpty(formID)) {
	rs.executeQuery("select isvirtualform from ModeFormExtend where formid=?",formID);
	if(rs.next()){
		isvirtualform = rs.getInt("isvirtualform");
	}
}

String titlename=SystemEnv.getHtmlLabelName(82045,user.getLanguage());//查询列表设置

String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_customsearch a,modeTreeField b WHERE a.appid=b.id AND a.id="+id;
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
String oldJavaFileName="";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
if(!"".equals(javafilename)&&"".equals(javafileAddress)){
Map<String, String> sourceCodePackageNameMap = CommonConstant.SOURCECODE_PACKAGENAME_MAP;
String sourceCodePackageName = sourceCodePackageNameMap.get("2");
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


.codeDelFlag{
	position: absolute;
	top: 2px;
	right: 2px;
	width:9px;
	height:9px;
	background:transparent url('/images/messageimages/delete_wev8.gif') no-repeat !important;
	cursor: pointer;	
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
<script>
$(document).ready(function () {
	$(".codeDelFlag").click(function(e){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>",function(){
			$("#javafilename_span").html("");
			$("#javafilename").val("");
			$(".codeDelFlag").hide();
		});
		e.stopPropagation(); 
	});
	formidChange();
});

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
		"type" : "2",
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
      top.location='/weaver/weaver.formmode.data.FileDownload?type=2';
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
//共享
//RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",javascript:doCustomSearchBatchSet(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;

//批量
//RCMenu += "{"+SystemEnv.getHtmlLabelName(27244,user.getLanguage())+",javascript:doBatchSet(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
if(id>0){
	if(operatelevel>1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&!treelevel.equals("0"))){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(30543,user.getLanguage())+",javascript:newCustomSearch(),_top} " ;//新建查询
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(82046,user.getLanguage())+",javascript:copyCustomSearc(),_top} " ;//复制查询
		RCMenuHeight += RCMenuHeightStep;
	}
	
RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:onPreview(),_self} " ;//预览
RCMenuHeight += RCMenuHeightStep;
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(30247,user.getLanguage())+",javascript:createMenuNew(1),_self} " ;//创建查询菜单
	RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(30248,user.getLanguage())+",javascript:viewmenu(),_self} " ;//查看查询菜单地址
RCMenuHeight += RCMenuHeightStep;
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82852,user.getLanguage())+",javascript:createMenuNew(3),_self} " ;//创建高级查询菜单
	RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(82853,user.getLanguage())+",javascript:viewAdvancedQueryAddress(),_self} " ;//查看高级查询菜单地址
RCMenuHeight += RCMenuHeightStep;
  if(!VirtualFormHandler.isVirtualForm(Util.getIntValue(formID,0))){
	if(operatelevel>0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(30245,user.getLanguage())+",javascript:createMenuNew(2),_self} " ;//创建监控菜单
		RCMenuHeight += RCMenuHeightStep;
	}
	RCMenu += "{"+SystemEnv.getHtmlLabelName(30246,user.getLanguage())+",javascript:viewmenu1(),_self} " ;//查看监控菜单地址
	RCMenuHeight += RCMenuHeightStep;
  }
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<form id="formCustomSearch" name="formCustomSearch" method="post" action="/weaver/weaver.formmode.servelt.CustomSearchAction">
<input type="hidden" name="id" id="id" value="<%=id %>" />
<input type="hidden" name="appid" id="appid" value="<%=appid %>"/>
<input type="hidden" name="action" id="action" value="customedit"/>
<input type="hidden" name="fmdetachable" id="fmdetachable" value="<%=fmdetachable %>"/>
<input type="hidden" name="detailjson" id="detailjson" value=""/>
<table class="e8_tblForm">
<tr>
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td><!-- 名称 -->
	<td class="e8_tblForm_field">
		<input type="text" id="customname" name="customname" style="width:80%;" onchange='checkinput("customname","customnamespan")' value="<%=customname %>"/> 
		<span id="customnamespan">
		    <%if ("".equals(customname)) { %>
				<img src="/images/BacoError_wev8.gif"/>
			<% } %>
		</span>
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
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2" tempTitle="<%=tempTitle %>"
						completeUrl="/data.jsp?type=mdFormBrowser&rightStr=ModeSetting:All" linkUrl=""  width="228px"
						browserDialogWidth="500px"
						browserSpanValue='<%=formName%>'
						onPropertyChange="formidChange()"
						_callback="changeModeId"
						></brow:browser>
	</td>
</tr>
<tr id="detailtable_tr">
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82047,user.getLanguage())%></td><!-- 子表 -->
	<td class="e8_tblForm_field">
		<div style="position: relative;">
			<select name="detailtable" id="detailtable" style="width: 200px;">
				
			</select>
			<div id="detailtable_loading" style=""><%=SystemEnv.getHtmlLabelName(82048,user.getLanguage())%></div><!-- 数据加载中，请等待... -->
		</div>
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
	<!-- 
		<button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></BUTTON>
		<span id=modeidspan><%=modename%></span>
		<input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
	-->
	<select id="modeid" name="modeid" style="width: 200px;">
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
			modeSql += " order by id ";
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
			<textarea name="defaultsql" style="width:80%;height:50px;"><%=defaultSql %></textarea>			
					<table>
						<tr>
							<td>
								<span title='<%=SystemEnv.getHtmlLabelName(82350,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82351,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82352,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82462,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82463,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82464,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82465,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(382960,user.getLanguage())%>&#10;' id="remind">
									<img align="absMiddle" src="/images/remind_wev8.png">
								</span>
							</td>
							<td style="padding-left: 5px;">
								<%=SystemEnv.getHtmlLabelName(82049,user.getLanguage())%><!-- 表单主表表名的别名为t1，明细表表名的别名为d1，查询条件的格式为: t1.a = '1' and t1.b = '3' and t1.c like '%22%' and d1.a = '1' and d1.b = '3' and d1.c like '%22%' and t1.a='PARM(参数)'。 -->
							</td>
						</tr>
					</table>		
			<%-- <div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82049,user.getLanguage())%></div><!-- 表单主表表名的别名为t1，明细表表名的别名为d1，查询条件的格式为: t1.a = '1' and t1.b = '3' and t1.c like '%22%' and d1.a = '1' and d1.b = '3' and d1.c like '%22%' and t1.a='PARM(参数)'。 --> --%>
		</div>
		<div id="SCT_Div_2" class="sctContent" <%if(!searchconditiontype.equals("2")){%>style="display: none;font-size:0;"<%}%>>
			<input type="text" id="javafileAddress" name="javafileAddress" style="min-width:40%;float: left;" value="<%=javafileAddress%>"/>
            <%if(!"".equals(javafilename)){%>
            <span class="codeEditFlag" onclick="openCodeEdit();">
            </span>
            <input type="hidden" id="javafilename" name="javafilename" value="<%=javafilename %>"/>
			<%}%>
			<span class="codeDownFlag" onclick="downloadMode()" title="<%=SystemEnv.getHtmlLabelName(382920, user
                                .getLanguage())%>"></span>
            <br>
            <br><span style="Letter-spacing:1px;"><%=SystemEnv.getHtmlLabelName(382748, user
                                .getLanguage())%></span>
		</div>
	</td>
</tr>
<tr class=isvirtualformhide style="display: <%=isvirtualform==1?"none":""%>">
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(81367,user.getLanguage())%></td><!-- 隐藏快捷搜索 -->
	<td class="e8_tblForm_field"><input type="checkbox" name="disQuickSearch" value="1" <%if(1==disQuickSearch)out.println("checked='checked'"); %>/></td>
</tr>
<tr class=isvirtualformhide style="display: <%=isvirtualform==1?"none":""%>">
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(81476,user.getLanguage())%></td><!-- 无权限列表 -->
	<td class="e8_tblForm_field"><input type="checkbox" name="norightlist" value="1" <%if("1".equals(norightlist))out.println("checked='checked'"); %>/></td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(129666,user.getLanguage())%></td><!-- 查询条件是否展开 -->
	<td class="e8_tblForm_field"><input type="checkbox" name="isShowQueryCondition" value="1" <%if(1==isShowQueryCondition)out.println("checked='checked'"); %>/></td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(126256,user.getLanguage())%></td><!-- 自定义列宽/每页显示条数 -->
	<td class="e8_tblForm_field"><input type="checkbox" name="iscustom" value="1" <%if(iscustom==1) out.println("checked='checked'"); %>/> <span style="margin-left:10px;"><a href="javascript:void(0);" style="color:#0072C6;" onclick="cleanColWidth();"><%=SystemEnv.getHtmlLabelNames("311,28149",user.getLanguage())%></a></span></td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(30847,user.getLanguage())%><div class="e8_label_desc"></div></td><!-- 数据打开方式 -->
	<td class="e8_tblForm_field">
		<select name="opentype">
		<option value="0" <%if(1!=opentype)out.println("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option><!-- 弹出窗口 -->
		<option value="1" <%if(1==opentype)out.println("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%></option><!-- 默认窗口 -->
		</select>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(17491,user.getLanguage())%></td><!-- 每页显示记录数 -->
	<td class="e8_tblForm_field">
		<input type="text" name="pagenumber" id="pagenumber" onchange="checkPageNumVal()" value="<%=pagenumber%>" style="width:101px;"/>
		<span id="pagenumberspan"/>&nbsp;</span>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%><div class="e8_label_desc"></div></td><!-- 显示顺序 -->
	<td class="e8_tblForm_field"><input type="text" name="dsporder" id="dsporder" onchange="checkVal()" value="<%=dsporder %>" style="width:101px;"/></td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!-- 描述 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82050,user.getLanguage())%><!-- 描述报表用途。 --></div></td>
	<td class="e8_tblForm_field">
		<textarea name="customdesc" style="width:80%;height:50px;"><%=customdesc %></textarea>
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
	if ($("#id").val()==0) {
		document.formCustomSearch.action.value="customadd";
	}
    var checkfields = "customname,formid";
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
        formCustomSearch.submit();
    }
}

function newCustomSearch(){
	parent.document.location.href = "customSearchInfo.jsp?appid=<%=appid%>";
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

function onDelete(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){		
		document.formCustomSearch.action.value="customdelete";		
		enableAllmenu();
		document.formCustomSearch.submit();		
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
function onPreview(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>";
	window.open(url);
}
function createmenu(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewmenu(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);//查看菜单地址
}

function createAdvancedQueryMenu(){
	var url = "/formmode/search/CustomSearchByAdvanced.jsp?customid=<%=id%>";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewAdvancedQueryAddress(){
	var url = "/formmode/search/CustomSearchByAdvanced.jsp?customid=<%=id%>";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);//查看菜单地址
}

function createmenu1(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>&viewtype=3";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewmenu1(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>&viewtype=3";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);//查看菜单地址
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

function copyCustomSearc(){
	$('#rightMenu').css('visibility','hidden');
	parent.copyCustomSearcSetting();
}


function customDialogCallBack(isvirtualform){
	if(isvirtualform==1){//虚拟表单
		$(".isvirtualformhide").hide();
		$(".isvirtualformhide input").each(function(i,obj){
		     changeCheckboxStatus(obj, false);
		});
	}else{
		$(".isvirtualformhide").show();
	}
}

function formidChange(){
	var $detailtable=jQuery("#detailtable");
	var $detailtableTR=jQuery("#detailtable_tr");
	$detailtable.find("option").remove();
	$detailtable.append("<option></option>");
	var formid=jQuery("#formid").val();
	if(formid=="")return;
	$detailtable.attr("disabled","true");
	var $detailtable_loading=jQuery("#detailtable_loading");
	$detailtable_loading.show();
	var url = "/formmode/setup/formSettingsAction.jsp?action=getDetailTables&formid="+formid;
	FormmodeUtil.doAjaxDataLoad(url, function(result){
		var status = result.status;
		if(status == "1"){
			$detailtable.find("option").remove();
			$detailtable.append("<option></option>");
			var data = result.data;
			if(data.length==0){
				$detailtableTR.hide();
			}else{
				var table_name_prefix="<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%>";//明细表
				for(var i = 0; i < data.length; i++){
					var table_name = data[i]["tablename"];
					var show_name=table_name_prefix+(i+1)+" "+table_name;
					var selected="";
					if(table_name=="<%=detailtable%>"){
						selected="selected";
					}
					var optionHtml = "<option value=\""+table_name+"\" "+selected+">"+show_name+"</option>";
					$detailtable.append(optionHtml);
				}
				$detailtableTR.show();
			}
		}
		$detailtable.removeAttr("disabled");
		$detailtable_loading.hide();
		$detailtable.selectbox("detach");
        beautySelect($detailtable);
	});
}
function clickTopSubMenu(menuIndex){
	var tDoc = top.document;
	var $submenusUL = $("#submenu", tDoc);
	$(".menuitem:eq("+menuIndex+")", $submenusUL).click();
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
function createMenuNew(type){
	var url;
	if(type == "1"){
		url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>";
	}else if(type == "2"){
		url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>&viewtype=3";
	}else if(type == "3"){
		url = "/formmode/search/CustomSearchByAdvanced.jsp?customid=<%=id%>";
	}else{return;}
	var parmes = escape(url);
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;	
	diag_vote.Width = 350;
	diag_vote.Height = 180;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(23033,user.getLanguage())%>";
	diag_vote.URL = "/formmode/setup/modelMenuAdd.jsp?dialog=1&isFromMode=1&parmes="+parmes;
	diag_vote.isIframe=false;
	diag_vote.show();
}
function cleanColWidth(){
	var customid = <%=id%>;
	if(customid<=0){
		alert("<%=SystemEnv.getHtmlLabelName(82470,user.getLanguage())%>");
	}else{
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(127925,user.getLanguage())%>"+"？",function(){
			jQuery.ajax({
				type: "POST",
				dataType:"json",
				url: "/formmode/setup/customSearchAction.jsp",
				data: "action=cleanColWidth&customid=<%=id%>",
				success: function(data){
					if(data.status==1){
						alert("<%=SystemEnv.getHtmlLabelName(28222,user.getLanguage())%>");
					}
				}
			});
		});
	}
}
</script>
</body>
</html>
