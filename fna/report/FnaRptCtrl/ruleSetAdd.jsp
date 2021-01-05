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

boolean fnaBudgetOAOrg = false;//OA组织机构
boolean fnaBudgetCostCenter = false;//成本中心
rs.executeSql("select * from FnaSystemSet");
if(rs.next()){
	fnaBudgetOAOrg = 1==rs.getInt("fnaBudgetOAOrg");
	fnaBudgetCostCenter = 1==rs.getInt("fnaBudgetCostCenter");
}

DepartmentComInfo dci = new DepartmentComInfo();
SubCompanyComInfo scci=new SubCompanyComInfo();
RolesComInfo rci = new RolesComInfo();

int id = Util.getIntValue(request.getParameter("id"), 0);

String name = "";
String roleid = "0";
String rolename = "";
StringBuffer depids = new StringBuffer();
StringBuffer depnames = new StringBuffer();
int allowZb = 0;
int allowFb = 0;
int allowBm = 0;
int allowFcc = 0;
StringBuffer fbids = new StringBuffer();
StringBuffer fbnames = new StringBuffer();
StringBuffer fccids = new StringBuffer();
StringBuffer fccnames = new StringBuffer();
String allowRptNames = "";

rs.executeSql("select * from fnaRptRuleSet where id = "+id);
if(rs.next()){
	name = Util.null2String(rs.getString("name")).trim();
	roleid = Util.null2String(rs.getString("roleid")).trim();
	rolename = rci.getRolesRemark(roleid);
	allowZb = Util.getIntValue(rs.getString("allowZb"), 0);
	allowFb = Util.getIntValue(rs.getString("allowFb"), 0);
	allowBm = Util.getIntValue(rs.getString("allowBm"), 0);
	allowFcc = Util.getIntValue(rs.getString("allowFcc"), 0);
	allowRptNames = Util.null2String(rs.getString("allowRptNames")).trim();
}

int idx = 0;
rs.executeSql("select * from fnaRptRuleSetDtl where showidtype = 1 and mainid = "+id+" order by id");
while(rs.next()){
	String showid = Util.null2String(rs.getString("showid")).trim();
	if(idx > 0){
		fbids.append(",");
		fbnames.append(",");
	}
	fbids.append(showid);
	fbnames.append(scci.getSubCompanyname(showid+""));
	idx++;
}

idx = 0;
rs.executeSql("select * from fnaRptRuleSetDtl where showidtype = 2 and mainid = "+id+" order by id");
while(rs.next()){
	String showid = Util.null2String(rs.getString("showid")).trim();
	if(idx > 0){
		depids.append(",");
		depnames.append(",");
	}
	depids.append(showid);
	depnames.append(dci.getDepartmentname(showid+""));
	idx++;
}

idx = 0;
rs.executeSql("select a.*, b.name "+
	" from fnaRptRuleSetDtl a "+
	" join FnaCostCenter b on a.showid = b.id "+
	" where a.showidtype = "+FnaCostCenter.ORGANIZATION_TYPE+" and mainid = "+id+" order by b.name");
while(rs.next()){
	String showid = Util.null2String(rs.getString("showid")).trim();
	String fccname = Util.null2String(rs.getString("name")).trim();
	if(idx > 0){
		fccids.append(",");
		fccnames.append(", ");
	}
	fccids.append(showid);
	fccnames.append(fccname);
	idx++;
}

String roleName = "";
String sql1 = "SELECT a.* from HrmRoles a where id = "+roleid;
rs.executeSql(sql1);
if(rs.next()){
	roleName = Util.null2String(rs.getString("rolesmark")).trim();
}

%>

<%@page import="weaver.fna.maintenance.FnaCostCenter"%><HTML><HEAD>
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
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(128646,user.getLanguage()) %>"/>
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
		
		
<form name="form2" method="post" action="/fna/report/FnaRptCtrl/ruleSetAdd.jsp">
<input type="hidden" id="id" name="id" value="<%=id %>" />
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'><!-- 角色权限 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item><!-- 角色 -->
		<wea:item>
	        <brow:browser viewType="0" name="field6599" browserValue='<%=roleid %>' 
	                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectedids=#id#"
	                hasInput="true" isSingle="true" hasBrowser="true" isMustInput="2"
	                completeUrl="/data.jsp?type=65"  temptitle='<%= SystemEnv.getHtmlLabelName(34190,user.getLanguage())%>' 
					linkUrl="/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesEdit&isdialog=1&showpage=1&id="
	                browserSpanValue='<%=FnaCommon.escapeHtml(roleName) %>' width="80%" >
	        </brow:browser>
	    	<INPUT id=oldroleid type=hidden name=oldroleid value="<%=roleid %>" /> 
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(128675,user.getLanguage())%></wea:item><!-- 权限适用报表 -->
		<wea:item>
   			<input id="fanRptTotalBudget" name="fanRptTotalBudget" value="fanRptTotalBudget" type="checkbox" <%=((allowRptNames).indexOf(",fanRptTotalBudget,")>=0)?"checked":"" %> />
   			<%=SystemEnv.getHtmlLabelName(82502,user.getLanguage())%><!-- 预算总额表 -->
   			<input id="fnaRptImplementation" name="fnaRptImplementation" value="fnaRptImplementation" type="checkbox" <%=((allowRptNames).indexOf(",fnaRptImplementation,")>=0)?"checked":"" %> />
   			<%=SystemEnv.getHtmlLabelName(82612,user.getLanguage())%><!-- 预算执行情况表 -->
   			<input id="costSummary" name="costSummary" value="costSummary" type="checkbox" <%=((allowRptNames).indexOf(",costSummary,")>=0)?"checked":"" %> />
   			<%=SystemEnv.getHtmlLabelName(82617,user.getLanguage())%><!-- 费用汇总表 -->
   			<input id="budgetDetailed" name="budgetDetailed" value="budgetDetailed" type="checkbox" <%=((allowRptNames).indexOf(",budgetDetailed,")>=0)?"checked":"" %> />
   			<%=SystemEnv.getHtmlLabelName(82629,user.getLanguage())%><!-- 费用预算细化表 -->
   			<input id="fanRptCost" name="fanRptCost" value="fanRptCost" type="checkbox" <%=((allowRptNames).indexOf(",fanRptCost,")>=0)?"checked":"" %> />
   			<%=SystemEnv.getHtmlLabelName(82605,user.getLanguage())%><!-- 费用查询统计表 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item><!-- 说明 -->
		<wea:item>
   			<input id="name" name="name" value="<%=FnaCommon.escapeHtml(name) %>" type="text" class="inputstyle" style="width: 80%;" />
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(128645,user.getLanguage())%>' attributes="{'itemAreaDisplay':'display'}"><!-- 可查询机构范围 -->
	<%if(fnaBudgetOAOrg){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></wea:item><!-- 总部 -->
		<wea:item>
   			<select id="allowZb" name="allowZb">
   				<option value="0" <%=allowZb==0?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129765,user.getLanguage())%></option><!-- 不允许 -->
   				<option value="1" <%=allowZb==1?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129766,user.getLanguage())%></option><!-- 允许 -->
   			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item><!-- 分部 -->
		<wea:item>
   			<span style="float: left;">
	   			<select id="allowFb" name="allowFb" onchange="allowBtn_onclick('allowFb','allowFbSpan');">
	   				<option value="0" <%=allowFb==0?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129765,user.getLanguage())%></option><!-- 不允许 -->
	   				<option value="1" <%=allowFb==1?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129767,user.getLanguage())%></option><!-- 允许全部 -->
	   				<option value="5" <%=allowFb==5?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129770,user.getLanguage())%></option><!-- 允许所属分部 -->
	   				<option value="6" <%=allowFb==6?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelNames("129770,129771",user.getLanguage())%></option><!-- 允许所属分部（含部门） -->
	   				<option value="2" <%=allowFb==2?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129769,user.getLanguage())%></option><!-- 允许下级 -->
	   				<option value="3" <%=allowFb==3?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelNames("129769,129771",user.getLanguage())%></option><!-- 允许下级（含部门） -->
	   				<option value="4" <%=allowFb==4?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129768,user.getLanguage())%></option><!-- 允许指定 -->
	   			</select>
			</span>
   			<span id="allowFbSpan" style="<%=allowFb==4?"":"display: none;" %>">
		        <brow:browser viewType="0" name="field6341" browserValue='<%=fbids.toString() %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("194")+"%3Fshow_virtual_org=-1%26selectedids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=194"  
		                browserSpanValue='<%=FnaCommon.escapeHtml(fbnames.toString()) %>' width="80%" >
		        </brow:browser>
		    </span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item><!-- 部门 -->
		<wea:item>
   			<span style="float: left;">
	   			<select id="allowBm" name="allowBm" onchange="allowBtn_onclick('allowBm','allowBmSpan');">
	   				<option value="0" <%=allowBm==0?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129765,user.getLanguage())%></option><!-- 不允许 -->
	   				<option value="1" <%=allowBm==1?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129767,user.getLanguage())%></option><!-- 允许全部 -->
	   				<option value="5" <%=allowBm==5?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129772,user.getLanguage())%></option><!-- 允许所属部门 -->
	   				<option value="2" <%=allowBm==2?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129769,user.getLanguage())%></option><!-- 允许下级 -->
	   				<option value="4" <%=allowBm==4?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129768,user.getLanguage())%></option><!-- 允许指定 -->
	   			</select>
			</span>
   			<span id="allowBmSpan" style="<%=allowBm==4?"":"display: none;" %>">
		        <brow:browser viewType="0" name="field6855" browserValue='<%=depids.toString() %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("57")+"%3Fshow_virtual_org=-1%26resourceids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=57"  
		                browserSpanValue='<%=FnaCommon.escapeHtml(depnames.toString()) %>' width="80%" >
		        </brow:browser>
		    </span>
		</wea:item>
	<%} %>
	<%if(fnaBudgetCostCenter){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></wea:item><!-- 部成本中心 -->
		<wea:item>
   			<span style="float: left;">
	   			<select id="allowFcc" name="allowFcc" onchange="allowBtn_onclick('allowFcc','allowFccSpan');">
	   				<option value="0" <%=allowFcc==0?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129765,user.getLanguage())%></option><!-- 不允许 -->
	   				<option value="1" <%=allowFcc==1?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129767,user.getLanguage())%></option><!-- 允许全部 -->
	   				<option value="4" <%=allowFcc==4?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(129768,user.getLanguage())%></option><!-- 允许指定 -->
	   			</select>
			</span>
   			<span id="allowFccSpan" style="<%=allowFcc==4?"":"display: none;" %>">
		        <brow:browser viewType="0" name="fccids" browserValue='<%=fccids.toString() %>' 
		                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/FccBrowserMulti.jsp%3Fselectids=#id#"
		                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
		                completeUrl="/data.jsp?type=FnaCostCenter"  
		                browserSpanValue='<%=FnaCommon.escapeHtml(fccnames.toString()) %>' width="80%" >
		        </brow:browser>
	        </span>
		</wea:item>
	<%} %>
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
});

//
function onBtnSearchClick(){}

function allowBtn_onclick(btnId,spanId){
	var allowBtn_val = jQuery("#"+btnId).val();
	if(allowBtn_val=="4"){
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
			url : "/fna/report/FnaRptCtrl/ruleSetOp.jsp",
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
		var id = null2String(jQuery("#id").val());
		var oldroleid = null2String(jQuery("#oldroleid").val());
		var field6599 = null2String(jQuery("#field6599").val());
		var name = null2String(jQuery("#name").val());
		var allowZb = jQuery("#allowZb").val();
		var allowFb = jQuery("#allowFb").val();
		var allowBm = jQuery("#allowBm").val();
		var allowFcc = jQuery("#allowFcc").val();
		var field6341 = null2String(jQuery("#field6341").val());
		var field6855 = null2String(jQuery("#field6855").val());
		var fccids = null2String(jQuery("#fccids").val());
		var fanRptTotalBudget = jQuery("#fanRptTotalBudget").attr("checked")?"fanRptTotalBudget":"";
		var fnaRptImplementation = jQuery("#fnaRptImplementation").attr("checked")?"fnaRptImplementation":"";
		var costSummary = jQuery("#costSummary").attr("checked")?"costSummary":"";
		var budgetDetailed = jQuery("#budgetDetailed").attr("checked")?"budgetDetailed":"";
		var fanRptCost = jQuery("#fanRptCost").attr("checked")?"fanRptCost":"";
		
		if(field6599=="" || field6599=="0"){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");//必填信息不完整
			return;
		}
		
		if(oldroleid=="0"){
			oldroleid = id;
		}
		
		var _data = "op=add&field6599="+field6599+"&id="+id+
			"&name="+name+"&oldroleid="+oldroleid+
			"&allowZb="+allowZb+"&allowFb="+allowFb+"&allowBm="+allowBm+"&allowFcc="+allowFcc+
			"&field6341="+field6341+"&field6855="+field6855+"&fccids="+fccids+
			"&fanRptTotalBudget="+fanRptTotalBudget+"&fnaRptImplementation="+fnaRptImplementation+
			"&costSummary="+costSummary+"&budgetDetailed="+budgetDetailed+"&fanRptCost="+fanRptCost;

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/report/FnaRptCtrl/ruleSetOp.jsp",
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
