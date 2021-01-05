<%@page import="weaver.splitepage.transform.SptmForHR"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("AppDetach:All", user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(33071,user.getLanguage());
String needfav ="1";
String needhelp ="";


Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
		Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
		Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
		Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
		Util.add0(today.get(Calendar.SECOND), 2);

String currentYear = Util.add0(today.get(Calendar.YEAR), 4);

String sql = "";


int id = Util.getIntValue(request.getParameter("id"), 0);
int mainId = Util.getIntValue(request.getParameter("mainId"), 0);
String operator = ">=";
String seclevel = "";
String seclevelto = "";
String type1 = "1";
String content = "";
String rolelevel = "0";
String iscontains = "1";//默认包含下级

sql = "select * from SysDetachDetail a where a.id = "+id;
rs.executeSql(sql);
while(rs.next()){
	operator = Util.null2String(rs.getString("operator")).trim();
	seclevel = Util.null2String(rs.getString("seclevel")).trim();
	seclevelto = Util.null2String(rs.getString("seclevelto")).trim();
	type1 = Util.null2String(rs.getString("type1")).trim();
	content = Util.null2String(rs.getString("content")).trim();
	rolelevel = Util.null2String(rs.getString("rolelevel")).trim();
	iscontains = Util.null2String(rs.getString("iscontains")).trim();
}


SptmForHR sptmForHR = new SptmForHR();

String subId = "";
String depId = "";
String hrmId = "";
String roleId = "";

String shownameHrm = "";
String shownameDep = "";
String shownameSub = "";
String shownameRole = "";

if ("1".equals(type1)) {
	shownameHrm = sptmForHR.getContent(content, type1);
	hrmId = content;
} else if ("2".equals(type1)) {
	shownameSub = sptmForHR.getContent(content, type1);
	subId = content;
} else if ("3".equals(type1)) {
	shownameDep = sptmForHR.getContent(content, type1);
	depId = content;
} else if ("4".equals(type1)) {
	shownameRole = sptmForHR.getContent(content, type1);
	roleId = content;
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript" src="/js/ecology8/hrm/e8Common_wev8.js?r=2"></script>
</head>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:doSave(false),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doSave(false);" 
    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>


<input id="id" name="id" value="<%=id %>" type="hidden" />
<input id="mainId" name="mainId" value="<%=mainId %>" type="hidden" />
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="resource"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("106,68",user.getLanguage())%>'/>
</jsp:include>
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item><!-- 共享类型 -->
			<wea:item>
				<%
				String hrmSel = "";
				String subSel = "";
				String depSel = "";
				String roleSel = "";
				String hrmDisplay = "none";
				String subDisplay = "none";
				String depDisplay = "none";
				String roleDisplay = "none";
				if(type1.equals("1")){//人力资源
					hrmSel = "selected";
					hrmDisplay = "block";
				}else if(type1.equals("2")){//分部
					subSel = "selected";
					subDisplay = "block";
				}else if(type1.equals("3")){//部门
					depSel = "selected";
					depDisplay = "block";
				}else if(type1.equals("4")){//角色
					roleSel = "selected";
					roleDisplay = "block";
				}
				%>
				<select id='type1' name='type1' onchange='type1_onchange();' style="width: 40px;float: left;">
	                <option value=1 <%=hrmSel%>><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>
	                <option value=2 <%=subSel%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
	                <option value=3 <%=depSel%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
	                <option value=4 <%=roleSel%>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
				</select>
				
	            <span id="spanHrmId" style="display: <%=hrmDisplay %>;">
			        <brow:browser viewType="0" name="hrmId" browserValue='<%=hrmId %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?show_virtual_org=-1&selectedids="
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="2"
			                completeUrl="/data.jsp?show_virtual_org=-1&type=17"  temptitle='<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>'
			                browserSpanValue='<%=(shownameHrm) %>' width="60%" >
			        </brow:browser>
			    </span>
	            <span id="spanSubId" style="display: <%=subDisplay %>;">
			        <brow:browser viewType="0" name="subId" browserValue='<%=subId %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="2"
			                completeUrl="/data.jsp?show_virtual_org=-1&type=194"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
			                browserSpanValue='<%=(shownameSub) %>' width="60%" >
			        </brow:browser>
			        <span style="display: none">
			        <input id="subiscontains" name="subiscontains" type="checkbox" value="1" <%=iscontains.equals("1")?"checked":"" %>>包含下级
			        </span>
			    </span>
	            <span id="spanDepId" style="display: <%=depDisplay %>;">
			        <brow:browser viewType="0" name="depId" browserValue='<%=depId %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByOrder.jsp?show_virtual_org=-1&selectedids="
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="2"
			                completeUrl="/data.jsp?show_virtual_org=-1&type=57"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
			                browserSpanValue='<%=(shownameDep) %>' width="60%" >
			        </brow:browser>
			        <span style="display: none">
			        <input id="depiscontains" name="depiscontains" type="checkbox" value="1" <%=iscontains.equals("1")?"checked":"" %>>包含下级
			        </span>
			    </span>
	            <span id="spanRoleId" style="display: <%=roleDisplay %>;">
			        <brow:browser viewType="0" name="roleId" browserValue='<%=roleId %>' 
			                browserUrl='<%=new BrowserComInfo().getBrowserurl("65") %>'
			                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
			                completeUrl="/data.jsp?type=65"  temptitle='<%= SystemEnv.getHtmlLabelName(122,user.getLanguage())%>'
			                browserSpanValue='<%=(shownameRole) %>' width="60%" >
			        </brow:browser>
			    </span>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item><!-- 安全级别 -->
			<wea:item>
			<%--
				<select id='operator' name='operator' style="width: 40px;float: left;">
	                <option value="&gt;" <%=">".equals(operator)?" selected=\"selected\" ":"" %>>&gt;</option>
	                <option value="&gt;=" <%=">=".equals(operator)?"  selected=\"selected\" ":"" %>>&gt;=</option>
	                <option value="=" <%="=".equals(operator)?" selected=\"selected\" ":"" %>>=</option>
	                <option value="&lt;=" <%="<=".equals(operator)?" selected=\"selected\" ":"" %>>&lt;=</option>
	                <option value="&lt;" <%="<".equals(operator)?" selected=\"selected\" ":"" %>>&lt;</option>
				</select>
				--%>
				<input id="operator" name="operator"  value="<%=">=" %>" type="hidden"/><!-- 安全级别 固定为 大于等于 -->
				<wea:required id="seclevelspan" required="true" value="<%=seclevel %>">
					<input id="seclevel" name="seclevel" value="<%=seclevel %>" type="text" class="inputstyle" style="width: 40px;" onchange='checkinput("seclevel","seclevelspan")'/>
				</wea:required>-
				<wea:required id="secleveltospan" required="true" value="<%=seclevelto %>">
					<input id="seclevelto" name="seclevelto" value="<%=seclevelto %>" type="text" class="inputstyle" style="width: 40px;" onchange='checkinput("seclevelto","secleveltospan")'/>
				</wea:required>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></wea:item><!-- 共享级别 -->
			<wea:item>
				<select id='rolelevel' name='rolelevel' style="width: 40px;">
	                <option value="0" <%="0".equals(rolelevel)?" selected=\"selected\" ":"" %>><%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
	                <option value="1" <%="1".equals(rolelevel)?"  selected=\"selected\" ":"" %>><%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
	                <option value="2" <%="2".equals(rolelevel)?" selected=\"selected\" ":"" %>><%= SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
				</select>
			</wea:item>
		</wea:group>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script language=javascript>
jQuery(document).ready(function(){
	resizeDialog(document);
	controlNumberCheck_jQuery("seclevel", false, 0, true, 3);
	controlNumberCheck_jQuery("seclevelto", false, 0, true, 3);
	type1_onchange();
});

function workflowid_callback(){
	
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

//关闭
function doClose(){
	var dialog = parent.parent.getDialog(window);	
	dialog.closeByHand();
}

//关闭
function doClose2(){
	var parentWin = parent.parent.getParentWindow(window);
	parentWin.closeDialog();
}

function type1_onchange(){
	var _type1 = jQuery("#type1");
	jQuery("#spanHrmId").hide();
	jQuery("#spanSubId").hide();
	jQuery("#spanDepId").hide();
	jQuery("#spanRoleId").hide();

	_type1.parent().parent().next().hide();
	_type1.parent().parent().next().next().hide();

	_type1.parent().parent().next().next().next().hide();
	_type1.parent().parent().next().next().next().next().hide();
	
	var type1 = _type1.val();
	if(type1=="1"){
		jQuery("#spanHrmId").show();
	}else if(type1=="2"){
		jQuery("#spanSubId").show();
		_type1.parent().parent().next().show();
		_type1.parent().parent().next().next().show();
	}else if(type1=="3"){
		jQuery("#spanDepId").show();
		_type1.parent().parent().next().show();
		_type1.parent().parent().next().next().show();
	}else if(type1=="4"){
		jQuery("#spanRoleId").show();
		_type1.parent().parent().next().show();
		_type1.parent().parent().next().next().show();
		_type1.parent().parent().next().next().next().show();
		_type1.parent().parent().next().next().next().next().show();
	}
}

//保存
function doSave(_openEditPage){
	var mainId = null2String(jQuery("#mainId").val());
	var id = null2String(jQuery("#id").val());

	var type1 = null2String(jQuery("#type1").val());
	var hrmId = null2String(jQuery("#hrmId").val());
	var subId = null2String(jQuery("#subId").val());
	var depId = null2String(jQuery("#depId").val());
	var roleId = null2String(jQuery("#roleId").val());
	var operator = null2String(jQuery("#operator").val());
	var seclevel = null2String(jQuery("#seclevel").val());
	var seclevelto = null2String(jQuery("#seclevelto").val());
	var rolelevel = null2String(jQuery("#rolelevel").val());
	var subiscontains = "0";
	var depiscontains = "0";
	if(jQuery("#subiscontains").attr("checked"))subiscontains="1";
	if(jQuery("#depiscontains").attr("checked"))depiscontains="1";
	
	var _m = "";
	if((type1=="1" && hrmId=="") || (type1=="2" && subId=="") || (type1=="3" && depId=="") || (type1=="4" && roleId=="")){
		_m = "<%=SystemEnv.getHtmlLabelNames("18133,18019",user.getLanguage())%>";
	}
	if(type1!="1" && (seclevel == "" || seclevelto == "")){
		_m += "<br/><%=SystemEnv.getHtmlLabelNames("683,18019",user.getLanguage())%>";
	}
	if(_m!=""){
		top.Dialog.alert(_m);
		return;
	}
	try{
		var _data = "operation=saveMembers&mainId="+mainId+"&id="+id+
			"&type1="+URLencode(type1)+"&hrmId="+URLencode(hrmId)+"&subId="+URLencode(subId)+
			"&depId="+URLencode(depId)+"&roleId="+URLencode(roleId)+"&operator="+URLencode(operator)+
			"&seclevel="+URLencode(seclevel)+"&seclevelto="+URLencode(seclevelto)+"&rolelevel="+URLencode(rolelevel)+
			"&subiscontains="+URLencode(subiscontains)+"&depiscontains="+URLencode(depiscontains);;
		jQuery.ajax({
			url : "/system/sysdetach/AppDetachOperation.jsp",
			type : "post",
			async : true,
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
					if(_json.flag){
						var parentWin = parent.parent.getParentWindow(window);
						//parentWin._table.reLoad();
						parentWin.onBtnSearchClick();
						doClose2();
					}else{
						top.Dialog.alert(_json.msg);
					}

			    }catch(e1){
			    }
			}
		});	
	}catch(e1){
	}
}

</script>
</BODY>
</HTML>
