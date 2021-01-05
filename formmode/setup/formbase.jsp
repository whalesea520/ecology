<%@page import="weaver.servicefiles.DataSourceXML"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/browser" prefix="brow"%>
<%--<%@ include file="/formmode/pub.jsp"%>--%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEFORM:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int formId = Util.getIntValue(request.getParameter("id"), 0);
int isclose = Util.getIntValue(request.getParameter("isclose"), 0);
FormInfoService formInfoService = new FormInfoService();
Map<String, Object> formInfo = formInfoService.getFormInfoById(formId);
String labelname = Util.null2String(formInfo.get("labelname"));
String tablename = Util.null2String(formInfo.get("tablename"));
String formdes = Util.null2String(formInfo.get("formdes"));
String dsporder = Util.null2String(formInfo.get("dsporder"));

int subCompanyId = Util.getIntValue(Util.null2String(formInfo.get("subcompanyid3")),-1);
String userRightStr = "FORMMODEFORM:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
String subCompanyId3 = ""+subCompanyId;

boolean isvirtualform = formInfoService.isVirtualForm(formInfo);

String errorMsg = Util.null2String(request.getParameter("errorMsg"));
String errorcode = Util.null2String(request.getParameter("errorcode"));
if("1".equals(errorcode)){
	errorMsg = SystemEnv.getHtmlLabelName(Util.getIntValue(errorMsg),user.getLanguage());
}
String countSql = "select count(1) as num from modeinfo where formid="+formId;
RecordSet.executeSql(countSql);
int count = 0;
if(RecordSet.next()){//删除主表
	count = RecordSet.getInt("num");
}

if(isvirtualform){
	String vsql = "select count(1) as num from(select formid from mode_report mode_customSearch where formid="+formId+") a full join"+
	              "(select formid from mode_custombrowser where formid="+formId+") m on m.formid = a.formid full join"+
	              "(select formid from mode_customSearch where formid="+formId+") b on b.formid = a.formid full join"+
	              "(select formid from modeinfo where formid="+formId+")c on c.formid = a.formid";	
	RecordSet.executeSql(vsql);
	if(RecordSet.next()){//删除虚拟表
		count = RecordSet.getInt("num");
	}
}


String titlename=SystemEnv.getHtmlLabelName(33655,user.getLanguage());//表单设置

Map<String, String> pkStrategyMap = new HashMap<String, String>();
pkStrategyMap.put("1", SystemEnv.getHtmlLabelName(83174 ,user.getLanguage()));
pkStrategyMap.put("2", SystemEnv.getHtmlLabelName(83175 ,user.getLanguage()));
//pkStrategyMap.put("3", SystemEnv.getHtmlLabelName(83176 ,user.getLanguage()));
Map<String, String> pkTypeIdMap = new TreeMap<String, String>(pkStrategyMap);
%>
<html>
<head>
	<title></title>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
<%--	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>--%>
	<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
	<style>
	a:hover{color:#0072C6 important;}
	*{
		font: 12px Microsoft YaHei;
	}
	html,body{
		height: 100%;
		margin: 0px;
		padding: 0px;
		overflow: auto;
	}
	html,body{
		height: 100%;
		margin: 0px;
		padding: 0px;
		overflow: auto;
	}
	textarea{overflow:auto;}
	.e8_tblForm{
		width: 100%;
		margin: 0 0;
		border-collapse: collapse;
	}
	.e8_tblForm .e8_tblForm_label{
		vertical-align: top;
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 2px;
	}
	.e8_tblForm .e8_tblForm_field{
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 7px;
		background-color: #f8f8f8;
	}
	.e8_label_desc{
		color: #aaa;
	}
	#vtablenameSearch,#vpkgentypewrap{
		width:125px; border: 0px;background-color: #fff;background-image: url('/formmode/images/btnSearch_wev8.png');background-repeat: no-repeat;background-position: 108px center;
	}
	#vtablenameTip, #vpkgentypeTip{
		position: absolute;left: 5px;top: 2px;color: #ccc;font: 12px Microsoft YaHei;font-style: italic;
	}
	#vtableName_loading{
		position: absolute;top: 0px;left: 5px;z-index: 10000;
		padding: 3px 10px 3px 20px; 
		vertical-align:middle; 
		background-image: url('/images/messageimages/loading_wev8.gif');
		background-repeat: no-repeat;
		background-position: 0px center;
		color: #aaa;
		display: none;
	}
	#vtablefield_loading{
		position: absolute;top: 0px;left: 0px;z-index: 10000;
		background-image: url('/images/messageimages/loading_wev8.gif');
		background-repeat: no-repeat;
		background-position: 5px center;
		padding: 4px 0px 2px 25px; 
		background-color: #fff;
		color: #aaa;
		width: 175px;
		display: none;
	}
	#vprimaryKey_loading{
		position: absolute;top: 0px;left: 5px;z-index: 10000;
		padding: 3px 10px 3px 20px; 
		vertical-align:middle; 
		background-image: url('/images/messageimages/loading_wev8.gif');
		background-repeat: no-repeat;
		background-position: 0px center;
		color: #aaa;
		display: none;
	}
	#vtablefieldContainer{
		margin: 0px;
		padding: 0px;
		height: 120px;
		overflow: auto;
	}
	#vtablefieldContainer ul{
		margin: 0px;
		padding: 0px;
		list-style: none;
	}
	#vtablefieldContainer ul li{
		padding:1px 0px;
	}
	.listResult{
		position: absolute;
		right: 65px;
		z-index: 100001;
		margin: 0px;
		padding: 3px 5px;
		height: 97px;
		width: 250px;
		overflow: auto;
		background-color: #fff;
		border: 1px solid #e9e9e9;
		display: none;
	}
	.listResult ul{
		margin: 0px;
		padding: 0px;
		list-style: none;
	}
	.listResult ul li{
		border-bottom: #eee 1px dotted;
	}
	.listResult ul li a{
		padding: 2px 0px 2px 2px;
		text-decoration: none;
		color: #333;
		display: block;
	}
	.listResult ul li a:hover{
		background-color: #0072C6;
		color: #fff !important;
	}
	.listResult ul li .tip{
		padding: 2px 0px 2px 2px;
		color: #ccc;
	}
	#vtableNameSrarchResult{
		top: 232px;
	}
	#vpkGenTypeChooseResult{
		top: 265px;
		height: 70px;
	}
	#vpkgentypeEditFlag{
		width: 16px;height: 16px;position: absolute;right: 2px;top: 2px;background:transparent url('/formmode/images/list_edit_wev8.png') no-repeat !important;
		cursor: pointer;
	}
	</style>
	<script type="text/javascript">
	<%if(isclose==1){%>
		parent.parent.refreshFormDel();
	<%}%>
	function deleteform(){
		if(<%=count%>>0){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125644,user.getLanguage())%>");//表单已经在模块中被引用，不能删除！
			return;
		}
	    var formidValue = "<%=formId%>";
	    var oldformids = "";
		var newformids = "";
		if(formidValue > 0){
		   oldformids = formidValue;
		}else{
		   newformids =formidValue;
		}
		if(oldformids=="" && newformids=="") return ;
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){//确定要删除吗?
					formbase.action = "/workflow/form/delforms.jsp?oldformids="+oldformids+"&newformids="+newformids+"&dialog=0";
					formbase.submit();}, function () {}, 320, 90,true);
	}
		
		$(document).ready(function () {
			initVpkGenTypeChoose();
			if($("#vprimarykey").val()==''){
				$("#pkcheck").show();
			}else{
				$("#pkcheck").hide();
			}
			$("#vprimarykey").change(function(){
				if($("#vprimarykey").val()==''){
					$("#pkcheck").show();
				}else{
					$("#pkcheck").hide();
				}
			})
		});
		
		function initVpkGenTypeChoose(){
			var $vpkgentypewrap = $("#vpkgentypewrap");
			var $vpkgentypeTip = $("#vpkgentypeTip");
			var $vpkGenTypeChooseResult = $("#vpkGenTypeChooseResult");
			
			var offset = $vpkgentypewrap.offset();
			var t = offset.top + $vpkgentypewrap.height() + 6;
			var r = $(document.body).width() - (offset.left + $vpkgentypewrap.width()) - 3;
			$vpkGenTypeChooseResult.css({"top": (t+"px"), "right": (r+"px")});
						
			$vpkgentypeTip.click(function(e){
				$vpkGenTypeChooseResult.show();
				e.stopPropagation(); 
			});
			
			$vpkgentypewrap.click(function(e){
				$vpkGenTypeChooseResult.show();
				e.stopPropagation(); 
			});
			
			$(document.body).bind("click", function(){
				$vpkGenTypeChooseResult.hide();
			});
		}
		
		function setVpkGenTypeChoose(theA){
			var $theA = $(theA);
			var v = $theA.attr("vpkGenTypeVal");
			var t = $theA.attr("vpkGenTypeText");
			
			$("#vpkgentypewrap").val(t);
			$("#vpkgentype").val(v);
			
			$("#vpkgentypeTip").hide();
			
			var $vpkgentypeEditFlag = $("#vpkgentypeEditFlag");
			if(v == "3"){
				$vpkgentypeEditFlag.show();
			}else{
				$vpkgentypeEditFlag.hide();
			}
		}
		
		function onSave(){
			var $ = jQuery;
			var formname = $("[name=formname]").val();
			if(formname == ""){
				Dialog.alert("<%=SystemEnv.getHtmlLabelName(82091,user.getLanguage())%>", function(){//请填写表单名称
					$("[name=formname]")[0].focus();
				}, null, null, true);
				return;
			}
			var formname = $("#vprimarykey").val();
			if(formname == ""){
				Dialog.alert("<%=SystemEnv.getHtmlLabelName(82096,user.getLanguage())%>", function(){//请选择主键字段
					$("#vprimarykey")[0].focus();
				}, null, null, true);
				return;
			}
			enableAllmenu();
			rightMenu.style.visibility = "hidden";
			document.getElementById("formbase").submit();
		}
		
		function tocreteformtab(){
			rightMenu.style.visibility = "hidden";
			parent.parent.toformtab();
		}
		
		function createForm(){
			rightMenu.style.visibility = "hidden";
			parent.parent.createForm();
		}
		
		function openCodeEdit(){
			parent.parent.openCodeEdit();
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
		
		function toformtab(formid){
		    if (<%=isvirtualform%> == 1) {
		        top.$(".subMenu").removeClass("subMenuSelected");
				top.$(".subMenu").each(function(i){
					if (i == 2)
						top.$(this).addClass("subMenuSelected");
				});
		    	top.changeFormModuleUrl('/formmode/setup/formSettings.jsp?formid='+formid);
		    } else {
				var parm = "&formid="+formid;
				if(formid=='') 
					parm = '';
				diag_vote = new window.top.Dialog();
				diag_vote.currentWindow = window;	
				diag_vote.Width = 1000;
				diag_vote.Height = 600;
				diag_vote.Modal = true;
				diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82021,user.getLanguage())%>";//新建表单
				diag_vote.URL = "/workflow/form/addDefineForm.jsp?dialog=1&isFromMode=1"+parm;
				diag_vote.isIframe=false;
				diag_vote.show();
			}
		}		
	</script>
</head>
  
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;//保存
	RCMenuHeight += RCMenuHeightStep ;
}
if(operatelevel>1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteform(),_self}" ;//删除
	    RCMenuHeight += RCMenuHeightStep ;
}

if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82021,user.getLanguage())+",javascript:tocreteformtab(),_top} " ;//新建表单
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82106,user.getLanguage())+",javascript:createForm(),_top} " ;//新建虚拟表单
	RCMenuHeight += RCMenuHeightStep ;
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%if(!errorMsg.equals("")){
	String errorTitle = SystemEnv.getHtmlLabelName(82087,user.getLanguage());//表单保存时发生如下错误：
%>
	<%@ include file="/formmode/setup/errorMsg.jsp" %>
<%}%>

<form id="formbase" name="formbase" method="post" action="/formmode/setup/formSettingsAction.jsp?action=eidtform">
<input type="hidden" name="isfromformbase" value="1"/>
<input type="hidden" name="formid" value="<%=formId %>"/>
<input type="hidden" name="isvirtualform" value="<%=isvirtualform %>"/>
<table class="e8_tblForm">
<tr>
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%><!-- 表单名称 --></td>
	<td class="e8_tblForm_field">
		<input type="text" style="width:80%;" name="formname" value="<%=labelname %>"/>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(18411,user.getLanguage())%><!-- 表单类型 --></td>
	<td class="e8_tblForm_field"><%=isvirtualform ? SystemEnv.getHtmlLabelName(33885,user.getLanguage()) : SystemEnv.getHtmlLabelName(33886,user.getLanguage()) %></td><!-- 虚拟表单:实际表单 -->
</tr>
<%if(isvirtualform){
	String vdatasource = Util.null2String(formInfo.get("vdatasource"));
	String virtualformtype = Util.null2String(formInfo.get("virtualformtype"));
	String vprimarykey = Util.null2String(formInfo.get("vprimarykey"));
	String vpkgentype = Util.null2String(formInfo.get("vpkgentype"));
%>
	<tr>
		<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%><!-- 数据源 --></td>
		<td class="e8_tblForm_field">
		<input type="hidden" name="datasource" id="datasource" value="<%=vdatasource%>">
		<%if(!DataSourceXML.SYS_LOCAL_POOLNAME.equals(vdatasource)){ %>
		<span style="cursor: pointer;" onclick="window.open('/servicesetting/datasourcesetting.jsp?urlType=3&dataname=<%=vdatasource %>');">
		<%=DataSourceXML.SYS_LOCAL_POOLNAME.equals(vdatasource)?"local":vdatasource %></span></td>
		<%}else{ %>
		<%=DataSourceXML.SYS_LOCAL_POOLNAME.equals(vdatasource)?"local":vdatasource %></td>
		<%} %>
	</tr>
	<tr>
		<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82101,user.getLanguage())%><!-- 表(视图)名 --></td>
		<td class="e8_tblForm_field"><%=VirtualFormHandler.getRealFromName(tablename) %>
			<input type="hidden" name="tablename" id="tablename" value="<%=tablename%>">
			<span style="color: #aaa;margin-left: 2px;font-size: 11px;">[<%=virtualformtype.equals("0") ? SystemEnv.getHtmlLabelName(31902,user.getLanguage()) : SystemEnv.getHtmlLabelName(32559,user.getLanguage()) %>]</span><!-- 表:视图 -->
		</td>
	</tr>
	<tr>
		<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82103,user.getLanguage())%><!-- 主键字段 --></td>
		<td class="e8_tblForm_field">
			<input type="hidden" name="vprimarykeyValue" value="<%=vprimarykey%>" id="vprimarykeyValue">
			<div style="position: relative;">
				<select name="vprimarykey" id="vprimarykey" style="width: 200px;">
				<option value="" ></option>
				<%
				List<Map<String, Object>> dataList = formInfoService.getFieldsByTable(vdatasource, VirtualFormHandler.getRealFromName(tablename));
				
					for(int i=0;i<dataList.size();i++){
						Map map = (Map)dataList.get(i);
						String columnName = Util.null2String(map.get("column_name"));
						%>
						<option value="<%=columnName %>" 
						<%=columnName.equalsIgnoreCase(vprimarykey)?"selected":"" %>>
						<%=columnName %>
						</option>
						<%
					}
				%>
					
				</select> <span id="pkcheck"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
				<span style="margin-left: 15px; position: relative;padding-right: 25px;">
					<%
						String VpkTypeText = "";
						VpkTypeText = pkTypeIdMap.get(vpkgentype);
					%>
					<INPUT id="vpkgentypewrap" type="text" readonly="readonly" style="cursor: pointer;color: #666;" value="<%=VpkTypeText%>"/>
					<INPUT id="vpkgentype" name="vpkgentype" type="hidden" value="<%=vpkgentype%>"/>							
					<div id="vpkgentypeTip">
						
					</div>
					
					<div id="vpkgentypeEditFlag" style="display: <%=vpkgentype.equals("3")?"":"none" %>" onclick="openCodeEdit();"></div>
				</span>
				
				<div id="vprimaryKey_loading"><%=SystemEnv.getHtmlLabelName(82048,user.getLanguage())%><!-- 加载中，请等待... --></div>
			</div>
			</td>
		</tr>
<%--	<tr>--%>
<%--		<td class="e8_tblForm_label">主键字段</td>--%>
<%--		<td class="e8_tblForm_field"><%=vprimarykey %>--%>
<%--			<span style="color: #aaa;margin-left: 2px;font-size: 11px;position: relative;padding-right: 20px;">[<%=VirtualFormHandler.getPKTypeText(vpkgentype)%>]--%>
<%--				<%if(vpkgentype.equals("3")){%>--%>
<%--					<div id="vpkgentypeEditFlag" onclick="openCodeEdit();"></div>--%>
<%--				<%}%>--%>
<%--			</span>--%>
<%--		</td>--%>
<%--	</tr>--%>
<%}else{%>
	<tr>
		<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%><!-- 数据库表名 --></td>
		<td class="e8_tblForm_field"><a href="javascript:toformtab('<%=formId %>')" style="text-decoration:none"><%=tablename %></a></td>
	</tr>
<%}%>

<%if(fmdetachable.equals("1")){%>
<tr >
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%><!-- 所属分部 --></td>
	<td class="e8_tblForm_field">
	<brow:browser name="subCompanyId3" viewType="0" hasBrowser="true" hasAdd="false" 
        browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=FORMMODEFORM:ALL" isMustInput="2" isSingle="true" hasInput="true"
        completeUrl="/data.jsp?type=164_1&rightStr=FORMMODEFORM:ALL"  width="260px" browserValue='<%=subCompanyId3%>' browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subCompanyId3)%>' />
	</td>
</tr>
<%}else{%>
	<input type="hidden" name="subCompanyId3" id="subCompanyId3" value="<%=subCompanyId3 %>" />
<%} %>

<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%><!-- 显示顺序 --></td>
	<td class="e8_tblForm_field">
		<input type="text" name="dsporder" onchange="checkVal()" id="dsporder" value="<%=dsporder %>"/>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%><!-- 表单描述 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82100,user.getLanguage())%><!-- 描述表单的基本功能 --></div></td>
	<td class="e8_tblForm_field">
		<textarea name="formdes" style="width:80%;height:80px;"><%=formdes %></textarea>
	</td>
</tr>
</table>
</form>
<div id="vpkGenTypeChooseResult" class="listResult">
	<ul>
		<li style="border-bottom-color:#ccc;color: #ccc;padding: 2px;"><%=SystemEnv.getHtmlLabelName(82099,user.getLanguage())%><!-- 请根据表情况在以下策略中选择一种 --></li>
		<%
			Set<Map.Entry<String, String>> entrySet = pkTypeIdMap.entrySet();
			Iterator<Map.Entry<String, String>> it = entrySet.iterator();
			while(it.hasNext()) {
				Map.Entry<String, String> entry = it.next();
				String pkTypeId = entry.getKey();
				String pkTypeText = entry.getValue();
		%>
			<li><a href="javascript:void(0);" onclick="javascript:setVpkGenTypeChoose(this);" vpkGenTypeVal="<%=pkTypeId %>" vpkGenTypeText="<%=pkTypeText %>"><%=pkTypeId %>. <%=pkTypeText %></a></li>
		<%  } %>
</ul>
<div id="vtableNameSrarchResult" class="listResult">
	<ul>
	</ul>
</div>
</body>
</html>
