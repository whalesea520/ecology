<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.encrypt.Des"%>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="browserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("CostStandardDimension:Set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

DecimalFormat df = new DecimalFormat("###################################################0.00");

IntegratedSapUtil integratedSapUtil = new IntegratedSapUtil();
String IsOpetype = integratedSapUtil.getIsOpenEcology70Sap();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String sql = "";

double orderNumber = 1;
sql = "select max(orderNumber) maxOrderNumber from FnaCostStandard";
rs.executeSql(sql);
if(rs.next()){
	orderNumber = Util.getDoubleValue(rs.getString("maxOrderNumber"), 0)+1;
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<script type="text/javascript" src="/fna/encrypt/des/des_wev8.js"></script>
<script language="javascript" src="/fna/costStandard/costStandardEdit_wev8.js?r=7"></script>
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
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doSave(false);" 
		    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
		
	<wea:layout type="2col">
		<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
			<wea:item><%=SystemEnv.getHtmlLabelName(125501,user.getLanguage())%></wea:item><!-- 维度名称 -->
			<wea:item>
				<wea:required id="namespan" required="true">
					<input id="name" name="name" value="" onblur="checkinput('name','namespan');" class="inputstyle" />
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(125504,user.getLanguage())%></wea:item><!-- 是否启用 -->
			<wea:item>
    			<input id="enabled" name="enabled" value="1" checked type="checkbox" tzCheckbox="true" />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(125502,user.getLanguage())%></wea:item><!-- 表现形式 -->
			<wea:item>
                <select id="paramtype" name="paramtype" onchange="paramChange();" style="float:left;">
                    <option value="0"><%=SystemEnv.getHtmlLabelName(27903,user.getLanguage()) %></option>
                    <option value="1"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage()) %></option>
                    <option value="2"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage()) %></option>
                    <option value="3"><%=SystemEnv.getHtmlLabelName(32306,user.getLanguage()) %></option>
                </select>
				<span id="browsertypeSpan1" style="display:block;float:left;letter-spacing: 0px;display:none;margin-left: 5px;">
	            	<select id="browsertype" name="browsertype" onchange="paramChange();">
			  			<option value="57"><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></option><!-- 部门 -->
			  			<option value="194"><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></option><!-- 分部 -->
			  			<option value="17"><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%></option><!-- 人力资源 -->
			  			<option value="99902"><%=SystemEnv.getHtmlLabelName(515, user.getLanguage())%></option><!-- 成本中心 -->
			  			<option value="99901"><%=SystemEnv.getHtmlLabelName(585, user.getLanguage())%></option><!-- 科目 -->
			  			<option value="2"><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%></option><!-- 日期 -->
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
					%>
						<option value="<%=_id %>" <%=selected %>><%=FnaCommon.escapeHtml(_labelname) %></option>
					<%
					}
					%>
			        </select>
				</span>
				<div id="div3_2" style="display:none"><!-- 自定义单选/多选 -->
					<brow:browser width="150px" viewType="0" name="fielddbtype1" 
							browserValue='' browserSpanValue=''
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
							hasInput="false" isSingle="true"
							isMustInput="2"></brow:browser>
				</div>
				<div id="div3_7" style="display:none"><!-- 自定义树形单选/多选 -->
					<brow:browser width="150px" viewType="0" name="fielddbtype2" 
							browserValue='' browserSpanValue=''
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/TreeBrowser.jsp"
							hasInput="false" isSingle="true"
							isMustInput="2"></brow:browser>
					
				</div>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(125503,user.getLanguage())%></wea:item><!-- 判断符 -->
			<wea:item>
				<span id="compareSpan1" style="padding-right:2px;">
					<select id="compareoption1" name="compareoption1" style="width: 150px;" >
						<option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage()) %></option>		<!-- 大于 -->
						<option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage()) %></option> 		<!-- 大于或等于 -->
						<option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage()) %></option> 		<!-- 小于 -->
						<option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage()) %></option> 		<!-- 小于或等于 -->
						<option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option> 		<!-- 等于 -->
						<option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option> 		<!-- 不等于 -->
						<option value="7"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option>			<!-- 属于 -->
						<option value="8"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>		<!-- 不属于 -->
						<option value="9"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>			<!-- 包含 -->
						<option value="10"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>		<!-- 不包含 -->
						<option value="11"><%=SystemEnv.getHtmlLabelName(82763,user.getLanguage()) %></option>		<!-- 属于（含下级） -->
						<option value="12"><%=SystemEnv.getHtmlLabelName(82764,user.getLanguage()) %></option>		<!-- 不属于（含下级） -->
					</select>
				</span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item><!-- 顺序 -->
			<wea:item>
    			<input id="orderNumber" name="orderNumber" value="<%=df.format(orderNumber) %>" _noMultiLang="true" />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item><!-- 描述 -->
			<wea:item>
				<textarea class=inputstyle id="description" name="description" style="width: 95%;" rows=3><%=FnaCommon.escapeHtml("")%></textarea>
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
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

var _key1 = "<%=Des.KEY1 %>";
var _key2 = "<%=Des.KEY2 %>";
var _key3 = "<%=Des.KEY3 %>";

var compareoption1_327 = "<%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %>";
var compareoption1_15506 = "<%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %>";
var compareoption1_346 = "<%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %>";
var compareoption1_15507 = "<%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %>";
var compareoption1_15508 = "<%=SystemEnv.getHtmlLabelName(15508,user.getLanguage()) %>";
var compareoption1_325 = "<%=SystemEnv.getHtmlLabelName(325,user.getLanguage()) %>";
var compareoption1_15509 = "<%=SystemEnv.getHtmlLabelName(15509,user.getLanguage()) %>";
var compareoption1_326 = "<%=SystemEnv.getHtmlLabelName(326,user.getLanguage()) %>";
var compareoption1_353 = "<%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %>";
var compareoption1_21473 = "<%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %>";
var compareoption1_82763 = "<%=SystemEnv.getHtmlLabelName(82763,user.getLanguage()) %>";
var compareoption1_82764 = "<%=SystemEnv.getHtmlLabelName(82764,user.getLanguage()) %>";

jQuery(document).ready(function(){
	resizeDialog(document);
	checkinput("name","namespan");
	paramChange();
	
	controlNumberCheck_jQuery("orderNumber", true, 2, false, 5);
});


function workflowid_callback(){
	
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

//关闭
function doClose(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

function doClose2(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

//保存
function doSave(){
	var name = null2String(jQuery("#name").val());
	var enabled = jQuery("#enabled").attr("checked")?1:0;
	var paramtype = null2String(jQuery("#paramtype").val());
	var browsertype = null2String(jQuery("#browsertype").val());
	var compareoption1 = null2String(jQuery("#compareoption1").val());
	var description = null2String(jQuery("#description").val());
	var orderNumber = null2String(jQuery("#orderNumber").val());
	var definebroswerType = null2String(jQuery("#definebroswerType").val());

	var fielddbtype1 = null2String(jQuery("#fielddbtype1").val());
	var fielddbtype2 = null2String(jQuery("#fielddbtype2").val());
	
	if(name==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>");//必填信息不完整
		return;
	}

	if((browsertype=="161"||browsertype=="162") && fielddbtype1==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");//必填信息不完整
		return;
	}else if((browsertype=="256"||browsertype=="257") && fielddbtype2==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");//必填信息不完整
		return;
	}
	
	var multiname=null2String(jQuery("#__multilangpre_"+jQuery("#name").attr("name")+jQuery("#name").attr("rnd_lang_tag")).val());

	openNewDiv_FnaBudgetViewInner1(_Label33574);
	hideRightMenuIframe();
	try{
		description = strEnc(description,_key1,_key2,_key3);
		
		var _data = "operation=add&name="+name+"&__multilangpre_name="+multiname+"&enabled="+enabled+"&paramtype="+paramtype+"&browsertype="+browsertype+
			"&compareoption1="+compareoption1+"&description="+description+"&orderNumber="+orderNumber+
			"&definebroswerType="+definebroswerType+"&fielddbtype1="+fielddbtype1+"&fielddbtype2="+fielddbtype2;
		
		jQuery.ajax({
			url : "/fna/costStandard/costStandardInnerOp.jsp",
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
						parentWin.onBtnSearchClick();
						onCancel();
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

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

</script>
</BODY>
</HTML>