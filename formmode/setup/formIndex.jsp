<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int formId = Util.getIntValue(request.getParameter("formId"), 0);
FormInfoService formInfoService = new FormInfoService();
String tablename = formInfoService.getTablenameByFormid(formId);
List<Map<String, Object>> tableIndexList = formInfoService.getFormTableIndexes(formId);

String errorMsg = Util.null2String(request.getParameter("errorMsg"));
errorMsg = xssUtil.get(errorMsg);
errorMsg = errorMsg.replace("<","&lt;").replace(">","&gt;");
String titlename=SystemEnv.getHtmlLabelName(82121,user.getLanguage());//索引设置

String subCompanyIdsql = "select subCompanyId3  from workflow_bill where id="+formId;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId3");
}
String userRightStr = "FORMMODEFORM:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
%>
<html>
<head>
	<title></title>
	<!-- 
	<script type="text/javascript" src="/formmode/js/jquery/jquery-1.10.2.min_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> -->
	<script type="text/javascript" src="/formmode/js/jquery/hoverIntent/jquery.hoverIntent.minified_wev8.js"></script>
	<style type="text/css">
		* {font:12px Microsoft YaHei}
		html,body{
			height: 100%;
			margin: 0px;
			padding: 0px;
		}
		.e8_tblForm{
			width: 100%;
			margin: 0 0;
			border-collapse: collapse;
		}
		.e8_tblForm .e8_tblForm_label{
			vertical-align: middle;
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
		
		.indexColumnEntry{
			margin-right: 5px;
		}
		.indexColumnEntry .labelname{
		
		}
		.indexColumnEntry .fieldname{
			margin-left:3px;
			font-size:11px;
			color:#929393;
		}
		
		.e8_fm_simpletable{
			width: 100%;
			border-collapse: collapse;
			margin-top: 10px;
		}
		.e8_fm_simpletable td{
			border: 1px solid #e6e6e6;
			padding: 5px 3px;
		}
		.e8_fm_simpletable thead td{
			background-color: #f8f8f8;
		}
		.e8_fm_simpletable tbody tr.overit td{
			/*background-color: #DEF0FF;*/
			background-color: #fCfCfC;
		}
		.e8_fm_simpletable a{
			color: #0072c6;
		}
		.e8_fm_simpletable a:HOVER {
			color: #0072c6 !important;
		}
		
		.checkError{
			background: url('/images/BacoCross_wev8.gif') no-repeat;
			padding-left: 16px;
			color: red;
			background-position: left 2px;
		}
	</style>
	<script type="text/javascript">
		
		$(document).ready(function () {
			/*
			$(".e8_fm_simpletable tbody tr").hoverIntent({
				over: function(){
					$(this).addClass("overit");
				},
				out: function(){
					$(this).removeClass("overit");
				},
				interval: 0
			});
			*/
			$(".e8_fm_simpletable tbody tr").mouseover(function(){
				$(this).addClass("overit");
			});
			$(".e8_fm_simpletable tbody tr").mouseout(function(){
				$(this).removeClass("overit");
			});
			
		});
		
		function corGIndexName(){
			setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
				var autoGIndexNameFlag = document.getElementById("autoGIndexNameFlag");
				if(autoGIndexNameFlag.checked){
					$("#indexName").fadeOut(200);
				}else{
					//$("#indexName").animate({width: '50%'}, 200);
					$("#indexName").fadeIn(200, function(){
						this.focus();
					});
				}
			},100);
		}
		
		function onCreate(){
			//验证数据完整性
			var flag = true;
			$(".checkError").removeClass("checkError").html("");
			
			var autoGIndexNameFlag = document.getElementById("autoGIndexNameFlag");
			if(!autoGIndexNameFlag.checked){
				var indexName = document.getElementById("indexName");
				if(indexName.value == ""){
					flag = false;
					$("#indexNameCheckSpan").addClass("checkError");
					$("#indexNameCheckSpan").html("<%=SystemEnv.getHtmlLabelName(82122,user.getLanguage())%>");//请填写索引名称
					indexName.focus();
				}
			}
			var indexColumns = document.getElementById("indexColumns");
			if(indexColumns.value == ""){
				flag = false;
				$("#indexColumnsCheckSpan").addClass("checkError");
				$("#indexColumnsCheckSpan").html("<%=SystemEnv.getHtmlLabelName(82123,user.getLanguage())%>");//请选择索引键列
			}
			rightMenu.style.visibility = "hidden";
			
			if(flag){
				document.getElementById("formIndex").submit();
			}
		}
		
		function onDelete(indexName){
			Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>？",function(){//确认要删除吗？
				var $ALink = $("#A_" + indexName);
				$ALink.html("<%=SystemEnv.getHtmlLabelName(82124,user.getLanguage())%>");//正在删除...
				$ALink.attr("disabled","true");
				var url = "/formmode/setup/formSettingsAction.jsp?action=deleteIndex";
				var paramData = {"indexName":indexName,"tablename":"<%=tablename%>"};
				$.ajax({
				    url: url,
				    data: paramData, 
				    dataType: 'json',
				    type: 'POST',
				    success: function (res) {
				    	if(res == "1"){
							$("#TR_" + indexName).remove();
						}else{
							Dialog.alert("<%=SystemEnv.getHtmlLabelName(20462,user.getLanguage())%>",function(){}, 272, 85, false);//删除失败
							$ALink.html("<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>");//删除
							$ALink.removeAttr("disabled");
						}
				    }
				});
			},function(){});
		}
		
	</script>
</head>
  
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(operatelevel>0){
	if(!VirtualFormHandler.isVirtualForm(formId)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(125,user.getLanguage())+",javascript:onCreate(),_top} " ;//创建
		RCMenuHeight += RCMenuHeightStep ;
	}
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%if(!errorMsg.equals("")){
	String errorTitle = SystemEnv.getHtmlLabelName(82125,user.getLanguage());//创建索引时发生如下错误：
%>
	<%@ include file="/formmode/setup/errorMsg.jsp" %>
<%}%>


<form id="formIndex" name="formIndex" method="post" action="/formmode/setup/formSettingsAction.jsp?action=createIndex">
<input type="hidden" name="formId" value="<%=formId %>"/>
<input type="hidden" name="tablename" value="<%=tablename %>"/>
<table class="e8_tblForm">

<tr>
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(82126,user.getLanguage())%><!-- 索引名称 --></td>
	<td class="e8_tblForm_field" style="height:38px; vertical-align: middle;">
		<input type="text" style="width:40%; display: none;" id="indexName" name="indexName"/>
		<input type="checkbox" id="autoGIndexNameFlag" name="autoGIndexNameFlag" value="1" checked="checked" onclick="javascript:corGIndexName();"/><span class="e8_label_desc" style="margin-left: 3px;"><%=SystemEnv.getHtmlLabelName(82127,user.getLanguage())%><!-- 名称自动生成 --></span>
		<span id="indexNameCheckSpan" style="margin-left: 5px;"></span>
	</td>
</tr>
<tr style="display: none;">
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82128,user.getLanguage())%><!-- 唯一 --></td>
	<td class="e8_tblForm_field"><input type="checkbox" name="uniqueFlag" value="1"/></td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82129,user.getLanguage())%><!-- 索引键列 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82130,user.getLanguage())%><!-- 要添加到索引键的表列 --></div></td>
	<td class="e8_tblForm_field">
		<span id="indexColumnsCheckSpan" style="margin-left: 5px;"></span>
		<brow:browser viewType="0" id="indexColumns" name="indexColumns" 
			browserValue="" 
	 		browserUrl="'+getBrowserURL()+'"
			hasInput="false" isSingle="false" hasBrowser = "true" isMustInput="1"
			completeUrl="/data.jsp" linkUrl=""  width="228px"
			browserDialogWidth="510px"
			browserSpanValue=""
			></brow:browser>
			
	</td>
</tr>
</table>
<table class="e8_fm_simpletable">
	<colgroup>
		<col width="40%"/>
		<col width="50%"/>
		<col width="10%" align="center"/>
	</colgroup>
	<thead>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(82126,user.getLanguage())%><!-- 索引名称 --></td>
			<td><%=SystemEnv.getHtmlLabelName(82129,user.getLanguage())%><!-- 索引键列 --></td>
			<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><!-- 操作 --></td>
		</tr>
	</thead>
	<tbody>
		<%
			for(int i = 0; i < tableIndexList.size(); i++){
				Map<String, Object> tableIndexMap = tableIndexList.get(i);
				String indexname = Util.null2String(tableIndexMap.get("indexname"));
				String indexstatus = Util.null2String(tableIndexMap.get("indexstatus"));
				String indextype = Util.null2String(tableIndexMap.get("indextype"));
				
				String col1Html = indexname + "&nbsp;("+ (indexstatus.equals("") ? "" : indexstatus+"，") + indextype + ")";
				
				String col2Html = "";
				List<Map<String, Object>> fieldList = (List<Map<String, Object>>)tableIndexMap.get("fieldList");
				boolean idOrFormmodeid=false;
				for(int j = 0; j < fieldList.size(); j++){
					Map<String, Object> fieldMap = fieldList.get(j);
					String indexfieldlabel = Util.null2String(fieldMap.get("indexfieldlabel"));
					String indexfieldname = Util.null2String(fieldMap.get("indexfieldname"));
					if(indexfieldlabel.equals("")){
						indexfieldlabel = indexfieldname;
						indexfieldname = "";
					}
					if(indexfieldlabel.equalsIgnoreCase("id") || indexfieldlabel.equalsIgnoreCase("formmodeid")){
						idOrFormmodeid=true;
					}
					col2Html += "<span class='indexColumnEntry'>";
					col2Html += "<span class='labelname'>"+indexfieldlabel+"</span>";
					if(!indexfieldname.equals("")){
						col2Html += "<span class='fieldname'>("+indexfieldname+")</span>";
					}
					if(j != (fieldList.size() - 1)){
						col2Html += "，";
					}
					col2Html += "</span>";
				}
				
				String indextablename = Util.null2String(tableIndexMap.get("indextablename"));
				boolean canNotDelete = indextype.equals(SystemEnv.getHtmlLabelName(82131,user.getLanguage()));//聚集
				canNotDelete = canNotDelete || idOrFormmodeid;
		%>
				<tr id="TR_<%=indexname %>">
					<td><%=col1Html %></td>
					<td>
						<%=col2Html %>
					</td>
					<td>
						<%if(!canNotDelete){%>
							<a id="A_<%=indexname %>" href='javascript:onDelete("<%=indexname %>");'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><!-- 删除 --></a>
						<%}%>
					</td>
				</tr>
		<%
			}
		%>
		
	</tbody>
</table>
<script type="text/javascript">
	function getBrowserURL(){
		return "/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormFieldBrowser.jsp?formId=<%=formId %>";
	}
</script>
</form>
</body>
</html>
