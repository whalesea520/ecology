<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit",user)){
	response.sendRedirect("/notice/noright.jsp");
	return ;
}

UserDefinedBrowserTypeComInfo userDefinedBrowserTypeComInfo = new UserDefinedBrowserTypeComInfo();

int id = Util.getIntValue(request.getParameter("id"), 0);

String name = "";
String type = "";
String fielddbtype = "";
double displayOrder = 0.0;
if(id > 0){
	rs.executeSql("select * from fnaFccDimension where id = "+id);
	if(rs.next()){
		name = Util.null2String(rs.getString("name")).trim();
		type = Util.null2String(rs.getString("type")).trim();
		fielddbtype = Util.null2String(rs.getString("fielddbtype")).trim();
		displayOrder = Util.getDoubleValue(rs.getString("displayOrder"), 0.0);
	}
}else{
	rs.executeSql("select max(displayOrder) max_displayOrder from fnaFccDimension");
	if(rs.next()){
		displayOrder = Util.getDoubleValue(rs.getString("max_displayOrder"), 0.0)+1;
	}
}
String fielddbtype1 = "";
String fielddbtype2 = "";
String treename = "";
if("161".equals(type)||"162".equals(type)){
	fielddbtype1 = fielddbtype;
}else if("256".equals(type)||"257".equals(type)){
	fielddbtype2 = fielddbtype;
	String treeSql = "select a.id,a.treename from mode_customtree a where a.id="+Util.getIntValue(fielddbtype);
	rs.executeSql(treeSql);
	if(rs.next()){
		treename = Util.null2String(rs.getString("treename")).trim();
	}
}

%>

<%@page import="weaver.workflow.field.UserDefinedBrowserTypeComInfo"%><HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:doEdit(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	if(id > 0){
		RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage())
				+ ",javascript:doDel(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
	}
	RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage())
			+ ",javascript:doClose(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(129723,user.getLanguage()) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doEdit();" 
		    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
		    		<%
		    		if(id > 0){
		    		%>
		    		<input class="e8_btn_top" type="button" id="btnDel" onclick="doDel();" 
		    			value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"/><!-- 删除 -->
		    		<%
		    		}
		    		%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
		
<form id="form2" name="form2" method="post" action="/fna/costCenter/fccDimensionSet/fccDimensionSetAdd.jsp">
<input type="hidden" id="id" name="id" value="<%=id %>" />
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'><!-- 基本信息 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(129735,user.getLanguage())%></wea:item><!-- 维度显示名 -->
		<wea:item>
   			<input id="name" name="name" value="<%=FnaCommon.escapeHtml(name) %>" type="text" class="inputstyle" style="width: 80%;" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></wea:item><!-- 表现形式 -->
		<wea:item>
			<div style="display:block;float:left;height:auto;width:152px;">
				<select id="type" name="type" onchange="type_onchange();">
				<%
				rs.executeSql("select a.id, b.labelname \n" +
						" from workflow_browserurl a \n" +
						" join HtmlLabelInfo b on a.labelid = b.indexid \n" +
						" where b.languageid = "+user.getLanguage()+" \n" +
						" and a.id in (162, 257) \n" +
						" order by a.id ");
				while(rs.next()){
					int _id = rs.getInt("id");
					String _labelname = Util.null2String(rs.getString("labelname")).trim();
					String selected = "";
					if((_id+"").equals(type)){
						selected = "selected";
					}
				%>
					<option value="<%=_id %>" <%=selected %>><%=FnaCommon.escapeHtml(_labelname) %></option>
				<%
				}
				%>
				</select>
			</div>
			
			<div id="div3_2" <%if("161".equals(type)||"162".equals(type)){%>style="display:inline"<%}else{%>style="display:none"<%}%>><!-- 自定义单选/多选 -->
				<brow:browser width="150px" viewType="0" name="fielddbtype1" 
						browserValue='<%=fielddbtype1 %>' browserSpanValue='<%=FnaCommon.escapeHtml(userDefinedBrowserTypeComInfo.getName(fielddbtype)) %>'
					    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
						hasInput="false" isSingle="true"
						isMustInput="2"></brow:browser>
			</div>
			<div id="div3_7" <%if("256".equals(type)||"257".equals(type)){%>style="display:inline"<%}else{%>style="display:none"<%}%>><!-- 自定义树形单选/多选 -->
				<brow:browser width="150px" viewType="0" name="fielddbtype2" 
						browserValue='<%=fielddbtype2 %>' browserSpanValue='<%=FnaCommon.escapeHtml(treename) %>'
					    browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/TreeBrowser.jsp"
						hasInput="false" isSingle="true"
						isMustInput="2"></brow:browser>
				
			</div>
			
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item><!-- 显示顺序 -->
		<wea:item>
   			<input id="displayOrder" name="displayOrder" value="<%=displayOrder %>" type="text" style="width: 88px;"/>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<Script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

//页面初始化事件
jQuery(document).ready(function(){
	resizeDialog(document);
	type_onchange();
	controlNumberCheck_jQuery("displayOrder", true, 3, true, 3);
});

function type_onchange(){
	var type = jQuery("#type").val();
	jQuery("#div3_2").hide();
	jQuery("#div3_7").hide();
	if(type=="161"||type=="162"){
		jQuery("#div3_2").show();
	}else if(type=="256"||type=="257"){
		jQuery("#div3_7").show();
	}
}

function onBtnSearchClick(){}

function allowBtn_onclick(btnId,spanId){
	var btnIdChecked = jQuery("#"+btnId).attr("checked")?true:false;
	if(btnIdChecked){
		jQuery("#"+spanId).show();
	}else{
		jQuery("#"+spanId).hide();
	}
}

//关闭
function doClose(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

//删除
function doDel(){
	//确定要删除吗?
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			doDel2();
		}, function(){}
	);
}

function doDel2(){
	hideRightMenuIframe();
	try{
		var id = null2String(jQuery("#id").val());
	
		var _data = "op=del&id="+id;

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/costCenter/fccDimensionSet/fccDimensionSetOp.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					if(_json.flag){
						var parentWin = parent.parent.getParentWindow(window);
						parentWin._table.reLoad();
						parentWin.closeDialog();
					}else{
						top.Dialog.alert(_json.msg);
					}
			    	showRightMenuIframe();
			    }catch(e1){
			    	showRightMenuIframe();
			    }
			}
		});	
	}catch(e1){
		showRightMenuIframe();
	}
}

//保存
function doEdit(){
	hideRightMenuIframe();
	try{
		var name = null2String(jQuery("#name").val());
		var type = null2String(jQuery("#type").val());
		var fielddbtype1 = null2String(jQuery("#fielddbtype1").val());
		var fielddbtype2 = null2String(jQuery("#fielddbtype2").val());
		
		if(name=="" || type==""){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");//必填信息不完整
			return;
		}

		if((type=="161"||type=="162") && fielddbtype1==""){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");//必填信息不完整
			return;
		}else if((type=="256"||type=="257") && fielddbtype2==""){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");//必填信息不完整
			return;
		}
		
		var _data = "op=save"+getPostDataByForm("form2");

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/costCenter/fccDimensionSet/fccDimensionSetOp.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					if(_json.flag){
						var parentWin = parent.getParentWindow(window);
						parentWin._table.reLoad();
						parentWin.closeDialog();
					}else{
						top.Dialog.alert(_json.msg);
					}
			    	showRightMenuIframe();
			    }catch(e1){
			    	showRightMenuIframe();
			    }
			}
		});	
	}catch(e1){
		showRightMenuIframe();
	}
}

</script>
</BODY>
</HTML>
