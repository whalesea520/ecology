<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.formmode.service.ExpandInfoService"%>
<%@page import="weaver.formmode.interfaces.InterfaceTransmethod"%>
<%@page import="weaver.interfaces.workflow.action.Action"%>
<%@page import="weaver.formmode.interfaces.dmlaction.commands.bases.DMLActionBase"%>
<%@page import="weaver.formmode.interfaces.action.WSActionManager"%>
<%@page import="weaver.formmode.interfaces.action.SapActionManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<%
int id = Util.getIntValue(request.getParameter("id"), 0);

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
String showcondition = Util.null2String(data.get("showcondition"));
String showconditioncn = Util.null2String(data.get("showconditioncn"));
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

if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

boolean issystemmenu = (issystem==1);//是否为系统菜单
String showconditionspan=showconditioncn;
String hrefname = InterfaceTransmethod.getHrefName(String.valueOf(hrefid), String.valueOf(hreftype));
if(id==0){
	modeid = Util.getIntValue(Util.null2String(request.getParameter("modeid")),0);
}
//当点击完成和新建完成后需要刷新左侧或者顶部数据
String reloadtype = Util.null2String(request.getParameter("reloadtype"));

int istriggerwf = Util.getIntValue(request.getParameter("istriggerwf"),0);
String interfaceaction = Util.null2String(request.getParameter("interfaceaction"));
String sql = "select mainid,interfacetype,interfacevalue from mode_pageexpanddetail where mainid = " + id;
RecordSet rs = new RecordSet();
rs.executeSql(sql);
while(rs.next()){
	String interfacetype = Util.null2String(rs.getString("interfacetype"));
	String interfacevalue = Util.null2String(rs.getString("interfacevalue"));
	if(interfacetype.equals("1")){
		istriggerwf =  Util.getIntValue(interfacevalue,0);
	}else if(interfacetype.equals("2")){
		interfaceaction =  interfacevalue;
	}
}

%>
<html>
<head>
<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style>
*{font: 12px Microsoft YaHei;}
.e8_tblForm{
	width: 100%;
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: top;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 0;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_label_desc{
	color: #aaa;
}
div#divPage{
	display: inline;
}
</style>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">

function onShowHrefTarget(inputName, spanName){
	var url = "/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp";
	var hreftype = jQuery("select[name=hreftype]").val();
	var hrefid = jQuery("input[name=hrefid]").val();
	if(hreftype=="1"){//模块
		url = "/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp";
	}else if(hreftype=="3"){//模块查询列表
		url = "/systeminfo/BrowserMain.jsp?url=/formmode/search/CustomSearchBrowser.jsp";
	} 
  	var datas = window.showModalDialog(url);
  	if (datas){
  	    if(datas.id!=""){
  		    $(inputName).val(datas.id);
 		    	$(spanName).html(datas.name);
  	    }else{
  		    $(inputName).val("");
  			$(spanName).html("");
  		}
  	    getHrefTarget();
  	} 
}
function getHrefTarget(){
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
	var hreftype = jQuery("select[name=hreftype]").val();
	var hrefid = jQuery("input[name=hrefid]").val();
	var modeid = jQuery("input[name=modeid]").val();
	url = "/formmode/interfaces/ModePageExpandRelatedFieldSet.jsp?modeid="+modeid+"&hreftype="+hreftype+"&hrefid="+hrefid;
   	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape(url));
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
function onShowCondition(spanName){
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
function submitData(){
	var action = $("#id").val()==0 ? "create" : "modify";
	$("#WeaverForm").attr("action", "/ServiceAction/data.servlet.PageExpandAction?action="+action);
	document.getElementById("WeaverForm").submit();
}

function onShowTypeChange(){
	var showtype = jQuery("#showtype").val();
	var hreftype = jQuery("#hreftype").val();
	if(showtype=="1"){
		jQuery("#opentype").hide();
		jQuery("#opentypetr").hide();
		jQuery("#relatedfieldtr").show();
	}else if(showtype=="2"){
		jQuery("#opentype").show();
		jQuery("#opentypetr").show();
		if(hreftype=="2"){
			jQuery("#relatedfieldtr").hide();
		}
	}
}

function onHrefTypeChange(){
	var hreftype = jQuery("#hreftype").val();
	if(hreftype=="1"){
		jQuery("#hrefidtr").show();
		jQuery("#hrefidlinetr").show();
		jQuery("#relatedfieldtr").show();
	}else if(hreftype=="2"){
		jQuery("#hrefidtr").hide();
		jQuery("#hrefidlinetr").hide();
		jQuery("#hrefid").val("");
		jQuery("#hrefidspan").html("");
		jQuery("#relatedfieldtr").hide();
	}else if(hreftype=="3"){
		jQuery("#relatedfieldtr").show();
		jQuery("#hrefidtr").show();
		jQuery("#hrefidlinetr").show();
	}
}

function changeIsBatch(obj){
	if(obj.value=='1'){
		jQuery("#pageselect").hide();
		jQuery("#createpage").attr("checked",false);
		jQuery("#managepage").attr("checked",false);
		jQuery("#viewpage").attr("checked",false);
	}else{
		jQuery("#pageselect").show();
	}
}
	
	
$(document).ready(function(){//onload事件
	<%if(reloadtype.equals("add")||reloadtype.equals("edit")||reloadtype.equals("del")){%>
		if(typeof(parent.parent.reloadDataWithChange)=="function"){
			parent.parent.reloadDataWithChange("<%=id%>","<%=reloadtype%>");
		}
	<%}%>
	<%if(id==0){%>
		jQuery("#createpage").attr("checked",true);	
		jQuery("#managepage").attr("checked",true);	
		jQuery("#viewpage").attr("checked",true);	
	<%}%>
	onShowTypeChange();
	onHrefTypeChange();
})




function checkFieldValue(ids){
	var idsArr = ids.split(",");
	for(var i=0;i<idsArr.length;i++){
		var obj = document.getElementById(idsArr[i]);
		if(obj&&obj.value==""){
			alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");//必要信息不完整！
			return false;
		}
	}
	return true;
}


function doSubmit(){
	if(checkFieldValue("modeid,expendname")){
        enableAllmenu();
        document.getElementById("operation").value="saveinterface";
        document.WeaverForm.action="/formmode/setup/expandSettingsActing.jsp";			
        document.WeaverForm.submit();			
	}
}
function editAction(actionid, actiontype_){
		var addurl = "";
		if(actiontype_ == 0){
			addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/dmlaction/DMLActionSettingEdit.jsp?actionid="+actionid+"&modeid=<%=modeid%>&expandid=<%=id%>");
		}else if(actiontype_ == 1){
			addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/action/WsActionEditSet.jsp?actionid="+actionid+"&modeid=<%=modeid%>&expandid=<%=id%>");
		}else if(actiontype_ == 2){
			addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/action/SapActionEditSet.jsp?actionid="+actionid+"&&modeid=<%=modeid%>&expandid=<%=id%>");
		}
		var id_t = window.showModalDialog(addurl,window,"dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
		window.location.reload();
	}

function addRow(){
		var addurl = "";
		var actionlist_t = document.getElementById("actionlist").value;
		if(actionlist_t == 1){
			addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/dmlaction/DMLActionSettingAdd.jsp?modeid=<%=modeid%>&expandid=<%=id%>");
		}else if(actionlist_t == 2){
			addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/action/WsActionEditSet.jsp?operate=addws&modeid=<%=modeid%>&expandid=<%=id%>");
		}else if(actionlist_t == 3){
			addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/action/SapActionEditSet.jsp?operate=adsap&modeid=<%=modeid%>&expandid=<%=id%>");
		}
		var id_t = window.showModalDialog(addurl,window,"dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
		window.location.reload();
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
			alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage())%>!");
			return;
		}
		if (isdel())
		{
			$G("operation").value="deletedmlaction";
	        enableAllmenu();
	        document.WeaverForm.submit();
		}
	}

</script>

</head>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSubmit(),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<form id="WeaverForm" name="WeaverForm" action="/formmode/setup/expandSettingsActing.jsp" method="post">
<input type="hidden" name="id" id="id" value="<%=id %>" />
<input type="hidden" name="operation" id="operation" value="edit" />
<input type="hidden" name="issystem" id="issystem" value="<%=issystem %>" />
<table class="e8_tblForm">
<tr>
	<td class="e8_tblForm_label">
		<%=SystemEnv.getHtmlLabelName(81457,user.getLanguage())%><!-- 是否触发审批工作流  -->
	</td>
	<td class="e8_tblForm_field">
		<input class="inputstyle" type="checkbox" id="istriggerwf" name="istriggerwf" value="1" <%if(istriggerwf==1)out.println("checked"); %>>
	</td>
</tr>

<tr>
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

<tr><td colspan="3">
	<table width="100%" class="liststyle" cellspacing="1"  >
		<COLGROUP>
		<COL width="5%">
		<COL width="35%">
		<COL width="35%">
		<COL width="25%">
		<TR class="Spacing" style="height: 1px;"><TD class="Line1" colspan=5 style="padding: 0px;"></TD></TR>
		<TR>
		<td colSpan="3" width="65%">
			<%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%>：<!-- 其他接口动作 -->
			<select id="actionlist" name="actionlist">
				<option value="1">DML<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option><!-- 接口动作 -->
				<!-- 
					<option value="2">WebService<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
					<option value="3">SAP<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
				 -->
			</select>
		</td>
		<TD align="right" width="35%">
		
			<DIV align=right>
			<BUTTON type='button' class=btn_actionList onclick=addRow();><SPAN id=addrowspan><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%></SPAN></BUTTON><!-- 增加 -->
				&nbsp;&nbsp;
			<BUTTON type='button' class=btn_actionList onclick=delRow();><SPAN id=delrowspan><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></SPAN></BUTTON><!-- 删除 -->
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
