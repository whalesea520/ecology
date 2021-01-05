<%@page import="weaver.fna.encrypt.Des"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<%@page import="weaver.fna.fnaVoucher.FnaCreateXml"%><HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<script type="text/javascript" src="/fna/encrypt/des/des_wev8.js"></script>
<style>
.vis1{visibility:visible;}
.vis2{visibility:hidden;}
.vis3{display:inline;}
.vis4{display:none;}
table.setbutton td{padding-top:10px;}
#tdIdListparams{padding-left: 5px !important;}
</style>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:financesetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32198,user.getLanguage());//财务凭证集成


int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"), 0);
if(fnaVoucherXmlId <= 0){
	fnaVoucherXmlId = Util.getIntValue(request.getParameter("id"), 0);
}

String sql = "";


String xmlName = "";
int workflowid = 0;
String typename = "";
String datasourceid = "";
String interfacesAddress = "";
String xmlEncoding = "";
sql = "select * from fnaVoucherXml a where (typename = 'K3' or typename = 'NC' or typename = 'EAS' or typename = 'U8' or a.typename = 'NC5' ) and a.id = "+fnaVoucherXmlId;
rs.executeSql(sql);
if(rs.next()){
	xmlName = Util.null2String(rs.getString("xmlName")).trim();
	workflowid = Util.getIntValue(rs.getString("workflowid"), 0);
	typename = Util.null2String(rs.getString("typename")).trim();
	datasourceid = Util.null2String(rs.getString("datasourceid")).trim();
	interfacesAddress = Util.null2String(rs.getString("interfacesAddress")).trim();
	xmlEncoding = Util.null2String(rs.getString("xmlEncoding")).trim();
	int profession = Util.getIntValue(rs.getString("profession"), 0);
	if(profession==1){
		response.sendRedirect("/fna/fnaVoucher/fnaVoucherXml.jsp?fnaVoucherXmlId="+fnaVoucherXmlId) ;
		return ;
	}
}else{
	typename = "NC";
}

String workflowname = "";
if(workflowid > 0){
	sql = "select a.workflowname from workflow_base a where a.id = "+workflowid;
	rs.executeSql(sql);
	if(rs.next()){
		workflowname = Util.null2String(rs.getString("workflowname")).trim();
	}
}

String alertSpan_info_1_U8 = SystemEnv.getHtmlLabelName(126459,user.getLanguage())+"：V10、V11、V12";//支持版本：V10、V11、V12
String alertSpan_info_1_K3 = SystemEnv.getHtmlLabelName(126459,user.getLanguage())+"：V10.2；"+SystemEnv.getHtmlLabelName(126460,user.getLanguage());//支持版本：V10.2；不支持辅助核算
String alertSpan_info_1_NC = SystemEnv.getHtmlLabelName(126461,user.getLanguage());//支持Servlet XML接口
String alertSpan_info_1_NC5 = SystemEnv.getHtmlLabelName(126461,user.getLanguage());//支持Servlet XML接口

String alertSpan_typename_1 = "display: none;";
String alertSpan_info_1 = "";
if("U8".equals(typename)){
	alertSpan_typename_1 = "";
	alertSpan_info_1 = alertSpan_info_1_U8;
}else if("K3".equals(typename)){
	alertSpan_typename_1 = "";
	alertSpan_info_1 = alertSpan_info_1_K3;
}else if("NC".equals(typename)){
	alertSpan_typename_1 = "";
	alertSpan_info_1 = alertSpan_info_1_NC;
}else if("NC5".equals(typename)){
	alertSpan_typename_1 = "";
	alertSpan_info_1 = alertSpan_info_1_NC5;
}

String divFnaVoucherInfo_display = "";
if(fnaVoucherXmlId <= 0){
	divFnaVoucherInfo_display = "display: none;";
}
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content" style="">
<%
String _MouldIDConstId = MouldIDConst.getID("integration");
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="<%=_MouldIDConstId %>"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32265,user.getLanguage()) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
	    		<input class="e8_btn_top" type="button" id="btnSave" onclick="onSubmit();" 
	    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
<form id="frmMain">
<input id="fnaVoucherXmlId" name="fnaVoucherXmlId" value="<%=fnaVoucherXmlId %>" type="hidden" />
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	<%if(fnaVoucherXmlId > 0){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(32265,user.getLanguage())%>ID</wea:item><!-- 财务凭证ID -->
		<wea:item>
			<%=fnaVoucherXmlId %>
		</wea:item>
	<%} %>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item><!-- 名称 -->
		<wea:item>
			<wea:required id="xmlNameimage" required="true" value='<%=xmlName %>'>
				<input class="inputstyle" type="text" id="xmlName" name="xmlName" style='width:280px!important;' 
					value="<%=FnaCommon.escapeHtml(xmlName) %>" size="50" maxLength="30" onchange='checkinput("xmlName","xmlNameimage")' />
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(32201,user.getLanguage())%></wea:item><!-- 财务系统 -->
		<wea:item>
			<select id="typename" name="typename" style='width:160px!important;' onchange="typename_onchange();">
				<option value="NC5" <%if("NC5".equals(typename)) out.print("selected"); %>>NC5</option>
				<option value="NC" <%if("NC".equals(typename)) out.print("selected"); %>>NC6</option>
				<option value="U8" <%if("U8".equals(typename)) out.print("selected"); %>>U8</option>
				<option value="K3" <%if("K3".equals(typename)) out.print("selected"); %>>K3</option>
				<!-- 
				<option value="EAS" <%if("EAS".equals(typename)) out.print("selected"); %>>EAS</option>
				 -->
			</select>
			<span id="alertSpan_typename_1" style="color: red;font-weight: bolder;margin-left: 5px;<%=alertSpan_typename_1 %>"><%=FnaCommon.escapeHtml(alertSpan_info_1) %></span>
		</wea:item>
		<wea:item attributes="{'samePair':'interfacesAddress1'}"><%=SystemEnv.getHtmlLabelNames("32363,83578",user.getLanguage())%></wea:item><!-- 接口地址 -->
		<wea:item attributes="{'samePair':'interfacesAddress1'}">
			<wea:required id="interfacesAddressimage" required="true" value='<%=interfacesAddress %>'>
				<input class="inputstyle" type="text" id="interfacesAddress" name="interfacesAddress" style='width:600px!important;' 
					value="<%=FnaCommon.escapeHtml(interfacesAddress) %>" maxLength="2000" onchange='checkinput("interfacesAddress","interfacesAddressimage")' />
			</wea:required>
		</wea:item>
		<wea:item attributes="{'samePair':'interfacesAddress1'}"><%=SystemEnv.getHtmlLabelNames("1321",user.getLanguage())%></wea:item><!-- 编码 -->
		<wea:item attributes="{'samePair':'interfacesAddress1'}">
			<select id="xmlEncoding" name="xmlEncoding">
				<option value="UTF-8" <%="UTF-8".equalsIgnoreCase(xmlEncoding)?"selected=\"selected\"":"" %>>UTF-8</option>
				<option value="GB2312" <%="GB2312".equalsIgnoreCase(xmlEncoding)?"selected=\"selected\"":"" %>>GB2312</option>
				<option value="GBK" <%="GBK".equalsIgnoreCase(xmlEncoding)?"selected=\"selected\"":"" %>>GBK</option>
			</select>
		</wea:item>
		<wea:item attributes="{'samePair':'datasource1'}"><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item><!-- 数据源 -->
		<wea:item attributes="{'samePair':'datasource1'}">
			<wea:required id="datasourceidspan" required="true" value='<%=datasourceid %>'>
				<select id="datasourceid" name="datasourceid" style='width:160px!important;' onchange="datasourceid_onchange();">
					<option></option>
					<%
					List pointArrayList = DataSourceXML.getPointArrayList();
					for(int i=0;i<pointArrayList.size();i++){
						String pointid = (String)pointArrayList.get(i);
						String isselected = "";
						if(datasourceid.equals(pointid)){
							isselected = "selected";
						}
					%>
					<option value="<%=FnaCommon.escapeHtml(pointid) %>" <%=isselected%>><%=FnaCommon.escapeHtml(pointid) %></option>
					<%    
					}
					%>
				</select>
			</wea:required>
		</wea:item>
		<wea:item attributes="{'samePair':'workflow'}"><%=SystemEnv.getHtmlLabelName(31025,user.getLanguage())%></wea:item><!-- 选择流程 -->
		<wea:item attributes="{'samePair':'workflow'}">
			<brow:browser viewType="0" name="workflowid" browserValue='<%=workflowid+"" %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkflowBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0" linkUrl=""
				browserSpanValue='<%=FnaCommon.escapeHtml(workflowname) %>' width='280px' 
				_callBack="workflowid_callBack">
			</brow:browser>
		</wea:item>
	</wea:group>
</wea:layout>
<ul class="tab_menu" id="tabs" style="border-bottom: 1px solid #7FB4E9 !important; width: 100% !important;<%=divFnaVoucherInfo_display%>">
	<li style='padding-left:0px!important;'><a href="#"><%=SystemEnv.getHtmlLabelName(125880,user.getLanguage())%></a></li><!-- 凭证主表信息设置 -->
	<li><a href="#"><%=SystemEnv.getHtmlLabelName(32207,user.getLanguage())%></a></li><!-- 凭证借方信息设置 -->
	<li><a href="#"><%=SystemEnv.getHtmlLabelName(32208,user.getLanguage())%></a></li><!-- 凭证贷方信息设置 -->
	<li><a href="#"><%=SystemEnv.getHtmlLabelName(83778,user.getLanguage())%></a></li><!-- 设置说明 -->
</ul>
<!-- listparams1：凭证主表信息设置 -->
<%
String _h = "395px";
if(fnaVoucherXmlId > 0){
	_h = "360px";
} %>
<div id="divFnaVoucherInfo" style="height: <%=_h %>;width: 100%;overflow: auto;<%=divFnaVoucherInfo_display%>">
	<span id="financesettingAjaxListparams1" style="display: none;height: 420px;"></span>
	<span id="financesettingAjaxListparams2" style="display: none;height: 420px;"></span>
	<span id="financesettingAjaxListparams3" style="display: none;height: 420px;"></span>
	<span id="financesettingAjaxListparams4" style="display: none;height: 420px;">
		<!-- 1、自定义SQL：以SQL查询语句的形式进行数据转换 -->
		<span style="font-weight: bold;">1、<%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%>：</span><%=SystemEnv.getHtmlLabelName(126463,user.getLanguage())%><br />
		<!-- 格式： -->
		<span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(126464,user.getLanguage())%>：</span>
		<!-- select somefield as newvalue from table_name where somefield=#主表.流程主表的数据库字段名# -->
		<span style="color: blue;">select somefield as newvalue from table_name where somefield=#<%=FnaCreateXml.WORKFLOW_MAIN_DATA_SET_ALIAS_NAME1 %>.<%=SystemEnv.getHtmlLabelName(126465,user.getLanguage())%>#</span><br />
		<!-- 默认带入值：#主表.流程主表的数据库字段名# -->
		<span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(126467,user.getLanguage())%>：</span>
		<span style="color: blue;">#<%=FnaCreateXml.WORKFLOW_MAIN_DATA_SET_ALIAS_NAME1 %>.<%=SystemEnv.getHtmlLabelName(126465,user.getLanguage())%>#</span>&nbsp;&nbsp;
		<!-- #明细表N.流程明细表N的数据库字段名#  N表示第几张明细表如：明细表1、明细表2... -->
		<span style="color: blue;">#<%=FnaCreateXml.WORKFLOW_DETAIL_DATA_SET_ALIAS_NAME1 %>N.<%=SystemEnv.getHtmlLabelName(126469,user.getLanguage())%>#</span>&nbsp;&nbsp;
		<%=SystemEnv.getHtmlLabelName(126470,user.getLanguage())%>...<br />
		<!-- 转换结果只识别查询SQL中查询结果列名（别名）为：newvalue -->
		<span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(126471,user.getLanguage())%>：</span><span style="color: blue;">newvalue</span><br />
		<br />
		<!-- 2、生成凭证的流程接口动作注册 -->
		<span style="font-weight: bold;">2、<%=SystemEnv.getHtmlLabelName(126472,user.getLanguage())%></span><br />
		<!-- 入口 -->
		<span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(126473,user.getLanguage())%>：</span>
		<!-- 集成中心 > 流程流转集成 > 注册自定义接口 -->
		<a href="/integration/icontent.jsp?showtype=10" target="_blank"><%=FnaCommon.escapeHtml(SystemEnv.getHtmlLabelName(126474,user.getLanguage())) %></a>&nbsp;&nbsp;
		<!-- 配置以下action： -->
		<%=SystemEnv.getHtmlLabelName(126475,user.getLanguage())%>：<br />
		<!-- 接口动作名称：自行填写 -->
		<span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(126476,user.getLanguage())%>：</span><%=SystemEnv.getHtmlLabelName(126477,user.getLanguage())%><br />
		<!-- 接口动作标识：自行填写 -->
		<span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(126478,user.getLanguage())%>：</span><%=SystemEnv.getHtmlLabelName(126477,user.getLanguage())%><br />
		<!-- 接口动作类文件：weaver.interfaces.workflow.action.WorkflowToFinanceRunXml -->
		<span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(126479,user.getLanguage())%>：</span><span style="color: blue;">weaver.interfaces.workflow.action.WorkflowToFinanceRunXml</span><br />
		<!-- 添加参数：参数名称：voucherXmlId； -->
		<span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(126480,user.getLanguage())%>：</span><%=SystemEnv.getHtmlLabelName(126481,user.getLanguage())%>：<span style="color: blue;">voucherXmlId</span>；
		<!-- 参数值：当前财务凭证ID -->
		<%=SystemEnv.getHtmlLabelName(126482,user.getLanguage())%>：<span style="color: blue;"><%=SystemEnv.getHtmlLabelName(126483,user.getLanguage())%></span>；<br />
		<!-- 在流程合适的节点附加动作或出口中配置该接口动作即可生成凭证 -->
		<span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(126484,user.getLanguage())%></span><br />
		<br />
		<!-- 3、凭证信息配置注意事项 -->
		<span style="font-weight: bold;">3、<%=SystemEnv.getHtmlLabelName(126485,user.getLanguage())%></span><br />
		<!-- 凭证借方信息设置、凭证贷方信息设置 -->
		<span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(126486,user.getLanguage())%>：</span>
		<!-- 当选择表单字段时，只能选择主表或者相同明细表的字段！ -->
		<%=SystemEnv.getHtmlLabelName(126487,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(126488,user.getLanguage())%>！<br />
	</span>
</div>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="doClose();" 
	    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
	    	</wea:item>
	    </wea:group>
</wea:layout>
</div>
</body>
<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

var fnaVoucherXmlId = "<%=fnaVoucherXmlId %>";

function onSubmit(){
	var _key1 = "<%=Des.KEY1 %>";
	var _key2 = "<%=Des.KEY2 %>";
	var _key3 = "<%=Des.KEY3 %>";
	
	var frmMain = document.getElementById("frmMain");

	var typename = jQuery("#typename").val();
	if((typename=="NC") && !check_form(frmMain,"xmlName,typename,interfacesAddress,workflowid")){
		return;
	}
	if((typename=="U8"||typename=="K3") && !check_form(frmMain,"xmlName,typename,datasourceid,workflowid")){
		return;
	}
	if((typename=="NC5") && !check_form(frmMain,"xmlName,typename,interfacesAddress,workflowid")){
		return;
	}
	
	
	if(true){
		var _postStr = "operator=save";

		var _inputName_inputVal = "&_inputName_inputVal=";

		var inputArray0 = jQuery("input");
		var inputArray0len = inputArray0.length;
		for(var i=0;i<inputArray0len;i++){
			var _iptId = jQuery(inputArray0[i]).attr("id");
			if(_iptId!=""){
				var valStrEnc = strEnc(jQuery(inputArray0[i]).val(),_key1,_key2,_key3);
				_inputName_inputVal += ","+_iptId+"="+valStrEnc;
			}
		}

		var inputArray1 = jQuery("select");
		var inputArray1len = inputArray1.length;
		for(var i=0;i<inputArray1len;i++){
			var _iptId = jQuery(inputArray1[i]).attr("id");
			if(_iptId!=""){
				_inputName_inputVal += ","+_iptId+"="+jQuery(inputArray1[i]).val();
			}
		}

		var inputArray2 = jQuery("textarea");
		var inputArray2len = inputArray2.length;
		for(var i=0;i<inputArray2len;i++){
			var _iptId = jQuery(inputArray2[i]).attr("id");
			if(_iptId!=""){
				var valStrEnc = strEnc(jQuery(inputArray2[i]).val(),_key1,_key2,_key3);
				_inputName_inputVal += ","+_iptId+"="+valStrEnc;
			}
		}
		
		_postStr += _inputName_inputVal;
		
		openNewDiv_FnaBudgetViewInner1(_Label33574);
		var _data = _postStr;
		jQuery.ajax({
			url : "/integration/financesettingOperation.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
			    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					var parentWin = parent.getParentWindow(window);
					try{parentWin._table.reLoad();}catch(ex1){}
					top.Dialog.alert(_json.msg);
					if(_json.flag){
						window.location.href = "/integration/financesetting.jsp?fnaVoucherXmlId="+_json.fnaVoucherXmlId; 
					}
			    }catch(e1){
			    }
			}
		});
	}
}

jQuery(document).ready(function(){
	try{
		jQuery('#tabbox').Tabs({
	    	getLine:1,
        	staticOnLoad:false,
        	needInitBoxHeight:false,
	    	container:"#tabbox"
	    });
    }catch(e){}
	jQuery.jqtab = function(tabtit,tab_conbox,shijian){
		showEle(tab_conbox);
		jQuery(tabtit).find("li:first").addClass("current").show();
		jQuery(tabtit).find("li").bind(shijian,function(){
			jQuery(this).addClass("current").siblings("li").removeClass("current"); 
			var activeindex = jQuery(tabtit).find("li").index(this)+1;
			jQuery("#financesettingAjaxListparams1").hide();
			jQuery("#financesettingAjaxListparams2").hide();
			jQuery("#financesettingAjaxListparams3").hide();
			jQuery("#financesettingAjaxListparams4").hide();
			jQuery("#financesettingAjaxListparams"+activeindex).show();
			return false;
		});
	
	};
	jQuery.jqtab("#tabs","listparams1","click");
	jQuery("#tabs").find("li:first").click();

	typename_onchange();

	resizeDialog(document);
});
function workflowfield_onchange(_obj){
	_obj = jQuery(_obj);
	var id = _obj.attr("id");
	var val = _obj.val();
	var iptObj = jQuery("#"+id+"_ipt");
	var selObj = jQuery("#"+id+"_sel");
	var sqlObj = jQuery("#"+id+"_sql");
	var spanObj = jQuery("#"+id+"_span");
	var spanIptObj = jQuery("#"+id+"_spanIpt");
	
	var _spanBacoError_wev8 = _obj.parent().find(".spanBacoError_wev8");
	
	if(val=="1"){
		iptObj.hide();
		selObj.show();
		spanObj.hide();
		spanIptObj.hide();
		if(selObj.val()==null || selObj.val()==""){
			_spanBacoError_wev8.show();
		}else{
			_spanBacoError_wev8.hide();
		}
	}else if(val=="3"){
		iptObj.show();
		selObj.hide();
		spanObj.hide();
		spanIptObj.show();
		if(iptObj.val()==null || iptObj.val()==""){
			_spanBacoError_wev8.show();
		}else{
			_spanBacoError_wev8.hide();
		}
	}else if(val=="7"){
		iptObj.hide();
		selObj.hide();
		spanObj.show();
		spanIptObj.hide();
		if(sqlObj.val()==null || sqlObj.val()==""){
			_spanBacoError_wev8.show();
		}else{
			_spanBacoError_wev8.hide();
		}
	}else{
		iptObj.hide();
		selObj.hide();
		spanObj.hide();
		spanIptObj.hide();
		_spanBacoError_wev8.hide();
	}
}
function workflowfieldValue_onchange(_obj){
	_obj = jQuery(_obj);
	var _spanBacoError_wev8 = _obj.parent().find(".spanBacoError_wev8");
	if(_spanBacoError_wev8.length==0){
		_spanBacoError_wev8 = _obj.parent().parent().find(".spanBacoError_wev8");
	}
	if(_obj.val()==null || _obj.val()==""){
		_spanBacoError_wev8.show();
	}else{
		_spanBacoError_wev8.hide();
	}
}
function financesettingAjaxListparams1(){
	var typename = jQuery("#typename").val();
	var workflowid = jQuery("#workflowid").val();

    jQuery("#financesettingAjaxListparams1").html("");
    jQuery("#financesettingAjaxListparams2").html("");
    jQuery("#financesettingAjaxListparams3").html("");
    
	var _data = "typename="+typename+"&workflowid="+workflowid+"&fnaVoucherXmlId="+fnaVoucherXmlId;
	
	jQuery.ajax({
		url : "/integration/financesettingAjaxListparams1.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "html",
		success: function do4Success(_html){
		    jQuery("#financesettingAjaxListparams1").html(_html);
		}
	});
	
	jQuery.ajax({
		url : "/integration/financesettingAjaxListparams2.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "html",
		success: function do4Success(_html){
		    jQuery("#financesettingAjaxListparams2").html(_html);
		}
	});
	
	jQuery.ajax({
		url : "/integration/financesettingAjaxListparams3.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "html",
		success: function do4Success(_html){
		    jQuery("#financesettingAjaxListparams3").html(_html);
		}
	});
}
function workflowid_callBack(){
	financesettingAjaxListparams1();
}
function typename_onchange(){
	var typename = jQuery("#typename").val();
	var _obj = jQuery("#alertSpan_typename_1");
	showEle("datasource1");
	hideEle("interfacesAddress1");
	if(typename=="U8"){
		_obj.text("<%=FnaCommon.escapeHtml(alertSpan_info_1_U8) %>");
		_obj.show();
	}else if(typename=="K3"){
		_obj.text("<%=FnaCommon.escapeHtml(alertSpan_info_1_K3) %>");
		_obj.show();
	}else if(typename=="NC"){
		_obj.text("<%=FnaCommon.escapeHtml(alertSpan_info_1_NC) %>");
		_obj.show();
		showEle("interfacesAddress1");
		hideEle("datasource1");
	}else if(typename=="NC5"){
		_obj.text("<%=FnaCommon.escapeHtml(alertSpan_info_1_NC5) %>");
		_obj.show();
		showEle("interfacesAddress1");
		hideEle("datasource1");
	}else{
		_obj.hide();
	}
	financesettingAjaxListparams1();
}
function datasourceid_onchange(){
	var datasourceid = jQuery("#datasourceid").val();
    if(datasourceid==""){
    	jQuery("#datasourceidspan").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
    }else{
    	jQuery("#datasourceidspan").html("");
    }
}
//关闭
function doClose(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}


</script>
</HTML>
