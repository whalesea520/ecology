<%@page import="weaver.fna.fnaVoucher.FnaCreateXml"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.encrypt.Des"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

DecimalFormat df = new DecimalFormat("##############################0.00");
BaseBean bb = new BaseBean();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//全部
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

int id = Util.getIntValue(request.getParameter("id"),0);
int hiddenBtnBar = Util.getIntValue(request.getParameter("hiddenBtnBar"),0);
int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"),0);

String dSetName = "";
String dataSourceName = "";
String dsMemo = "";
String dSetType = "";
String dSetStr = "";
String dSetStr1 = "";
String dSetStr2 = "";
String dSetStr3 = "";

String sql = "select * from fnaDataSet a where a.id = "+id;
rs.executeSql(sql);
if(rs.next()){
	dSetName = Util.null2String(rs.getString("dSetName")).trim();
	dataSourceName = Util.null2String(rs.getString("dataSourceName")).trim();
	dsMemo = Util.null2String(rs.getString("dsMemo")).trim();
	dSetType = Util.null2String(rs.getString("dSetType")).trim();
	dSetStr = Util.null2String(rs.getString("dSetStr")).trim();
}
if("1".equals(dSetType)){
	dSetStr2 = dSetStr;
}else if("2".equals(dSetType)){
	dSetStr3 = dSetStr;
}else{
	dSetStr1 = dSetStr;
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<script type="text/javascript" src="/fna/encrypt/des/des_wev8.js"></script>
</head>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doEdit(),_TOP} ";//保存
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(84712,user.getLanguage()) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
	    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doEdit();" 
	    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
<input type="hidden" id="id" name="id" value="<%=id %>" />
	<wea:layout type="2col">
		<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>"><!-- 基本信息 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item><!-- 名称 -->
			<wea:item>
				<wea:required id="dSetNameSpan" required="true">
        			<input class="inputstyle" id="dSetName" name="dSetName" maxlength="30" style="width: 200px;" 
        				onchange='checkinput("dSetName","dSetNameSpan");' value="<%=FnaCommon.escapeHtml(dSetName)%>" />
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item><!-- 类型 -->
			<wea:item>
	            <select class="inputstyle" id="dSetType" name="dSetType" style="width: 200px;" onchange="dSetType_onchange();">
	              <option value="1" <% if("1".equals(dSetType)) {%>selected<%}%>>SQL</option><!-- 1：sql; -->
	              <option value="3" <% if("3".equals(dSetType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84715,user.getLanguage())%></option><!-- 3：动态类； -->
	              <option value="2" <% if("2".equals(dSetType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84723,user.getLanguage())%></option><!-- 2；系统默认类； -->
	              <option value="4" <% if("4".equals(dSetType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84716,user.getLanguage())%></option><!-- 4：配置文件； -->
	              <option value="5" <% if("5".equals(dSetType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84717,user.getLanguage())%></option><!-- 5：默认变量； -->
	            </select>
	            <br />
				<wea:required id="dSetStr1Span" required="true">
       				<input class="inputstyle" id="dSetStr1" name="dSetStr1" style="width: 95%;display: none;" 
       					onchange='checkinput("dSetStr1","dSetStr1Span");' value="<%=FnaCommon.escapeHtml(dSetStr1)%>" />
				</wea:required>
				<wea:required id="dSetStr2Span" required="true">
       				<textarea id="dSetStr2" name="dSetStr2" rows="7" style="width: 95%;display: none;" 
       				 	onblur='checkinput("dSetStr2","dSetStr2Span");' ><%=FnaCommon.escapeHtml(dSetStr2)%></textarea>
				</wea:required>
				<span id="span_dSetStr3">
	            <select class="inputstyle" id="dSetStr3" name="dSetStr3" style="width: 95%;">
	              <option value="weaver.fna.fnaVoucher.impl.FmtInt" 
	              		<% if("weaver.fna.fnaVoucher.impl.FmtInt".equals(dSetStr3)) {%>selected<%}%>>
	              <%=SystemEnv.getHtmlLabelName(84798,user.getLanguage())%></option>
	              <option value="weaver.fna.fnaVoucher.impl.FmtFloat" 
	              		<% if("weaver.fna.fnaVoucher.impl.FmtFloat".equals(dSetStr3)) {%>selected<%}%>>
	              <%=SystemEnv.getHtmlLabelName(84799,user.getLanguage())%></option>
	              <option value="weaver.fna.fnaVoucher.impl.EscapeSqlStrMulti" 
	              		<% if("weaver.fna.fnaVoucher.impl.EscapeSqlStrMulti".equals(dSetStr3)) {%>selected<%}%>>
	              <%=SystemEnv.getHtmlLabelName(84800,user.getLanguage())%></option>
	              <option value="weaver.fna.fnaVoucher.impl.NotEscapeSql" 
	              		<% if("weaver.fna.fnaVoucher.impl.NotEscapeSql".equals(dSetStr3)) {%>selected<%}%>>
	              <%=SystemEnv.getHtmlLabelName(84801,user.getLanguage())%></option>
	              <option value="weaver.fna.fnaVoucher.impl.DataSetResultCopyParamValue" 
	              		<% if("weaver.fna.fnaVoucher.impl.DataSetResultCopyParamValue".equals(dSetStr3)) {%>selected<%}%>>
	              <%=SystemEnv.getHtmlLabelName(84802,user.getLanguage())%></option>
	              <option value="weaver.fna.fnaVoucher.impl.Increment" 
	              		<% if("weaver.fna.fnaVoucher.impl.Increment".equals(dSetStr3)) {%>selected<%}%>>
	              <%=SystemEnv.getHtmlLabelName(84803,user.getLanguage())%></option>
	            </select>
	            </span>
	            <br />
	            <font color="red" style="font: bold;">
					<span id="parameter1" style="display: none;">
						<%=SystemEnv.getHtmlLabelName(84724,user.getLanguage())%><br />
						
						<%=SystemEnv.getHtmlLabelName(84717,user.getLanguage())%><br />
						<%=SystemEnv.getHtmlLabelName(84729,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>requestids<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84730,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>userid<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84731,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>loginname<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84732,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>username<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84733,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>workcode<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84734,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>language<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84806,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>guid<%=FnaCreateXml.FLAG_CHAR %>
					</span><!-- 填写：SQL语句 -->
					<span id="parameter3" style="display: none;">
						<%=SystemEnv.getHtmlLabelName(84725,user.getLanguage())%>
					</span><!-- 填写：JAVA类名（包名加类名） -->
					<span id="parameter2" style="display: none;">
						<%=SystemEnv.getHtmlLabelName(84726,user.getLanguage())%>
						<br />
						<%=SystemEnv.getHtmlLabelName(84798,user.getLanguage())%>
						<span class="xTable_algorithmdesc" 
							 title="<%=SystemEnv.getHtmlLabelName(84781,user.getLanguage())%>&#13;<%=SystemEnv.getHtmlLabelName(124792,user.getLanguage())%>&#13;<%=SystemEnv.getHtmlLabelName(84813 ,user.getLanguage())%>">
							 <img src="/images/tooltip_wev8.png" align="Middle" style="vertical-align:top;">
						</span>
						<br />
						<%=SystemEnv.getHtmlLabelName(84799,user.getLanguage())%>
						<span class="xTable_algorithmdesc" 
							 title="<%=SystemEnv.getHtmlLabelName(84781,user.getLanguage())%>&#13;<%=SystemEnv.getHtmlLabelName(84783,user.getLanguage())%>&#13;<%=SystemEnv.getHtmlLabelName(84813 ,user.getLanguage())%>">
							 <img src="/images/tooltip_wev8.png" align="Middle" style="vertical-align:top;">
						</span>
						<br />
						<%=SystemEnv.getHtmlLabelName(84800,user.getLanguage())%>
						<span class="xTable_algorithmdesc" 
							 title="<%=SystemEnv.getHtmlLabelName(84781,user.getLanguage())%>&#13;<%=SystemEnv.getHtmlLabelName(84784,user.getLanguage())%>&#13;<%=SystemEnv.getHtmlLabelName(84813 ,user.getLanguage())%>">
							 <img src="/images/tooltip_wev8.png" align="Middle" style="vertical-align:top;">
						</span>
						<br />
						<%=SystemEnv.getHtmlLabelName(84801,user.getLanguage())%>
						<span class="xTable_algorithmdesc" 
							 title="<%=SystemEnv.getHtmlLabelName(84781,user.getLanguage())%>&#13;<%=SystemEnv.getHtmlLabelName(84785,user.getLanguage())%>&#13;<%=SystemEnv.getHtmlLabelName(84813 ,user.getLanguage())%>">
							 <img src="/images/tooltip_wev8.png" align="Middle" style="vertical-align:top;">
						</span>
						<br />
						<%=SystemEnv.getHtmlLabelName(84802,user.getLanguage())%>
						<span class="xTable_algorithmdesc" 
							 title="<%=SystemEnv.getHtmlLabelName(84781,user.getLanguage())%>&#13;<%=SystemEnv.getHtmlLabelName(84814,user.getLanguage())%>">
							 <img src="/images/tooltip_wev8.png" align="Middle" style="vertical-align:top;">
						</span>
						<br />
						<%=SystemEnv.getHtmlLabelName(84803,user.getLanguage())%>
						<span class="xTable_algorithmdesc" 
							 title="<%=SystemEnv.getHtmlLabelName(84781,user.getLanguage())%>&#13;<%=SystemEnv.getHtmlLabelName(84805,user.getLanguage())%>&#13;<%=SystemEnv.getHtmlLabelName(84812,user.getLanguage())%>">
							 <img src="/images/tooltip_wev8.png" align="Middle" style="vertical-align:top;">
						</span>
					</span><!-- 
						//可选值：
						//复制数据类：
						//格式化整数类：
						//格式化浮点数类：
						//SQL特殊字符转义类：
						//不进行SQL特殊字符转义类：
						//序号自增类：
					 -->
					<span id="parameter4" style="display: none;"><%=SystemEnv.getHtmlLabelName(84728,user.getLanguage())%></span><!-- 
						//填写：配置文件名称
					 -->
					<span id="parameter5" style="display: none;">
						<%=SystemEnv.getHtmlLabelName(84717,user.getLanguage())%><br />
						<%=SystemEnv.getHtmlLabelName(84729,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>requestids<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84730,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>userid<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84731,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>loginname<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84732,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>username<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84733,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>workcode<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84734,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>language<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84806,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>guid<%=FnaCreateXml.FLAG_CHAR %>
					</span>
				</font>
			</wea:item>
			<wea:item attributes="{'id':'tr1_dataSourceName'}"><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item><!-- 数据源 -->
			<wea:item attributes="{'id':'tr2_dataSourceName'}">
	            <select class="inputstyle" id="dataSourceName" name="dataSourceName" style="width: 200px;">
	              <option value="" <% if("".equals(dataSourceName)) {%>selected<%}%>></option>
				<%
				ArrayList pointArrayList = DataSourceXML.getPointArrayList();
				for(int i=0;i<pointArrayList.size();i++){
				    String pointid = Util.null2String((String)pointArrayList.get(i)).trim();
				    String isselected = "";
				    if(pointid.equals(dataSourceName)){
				        isselected = "selected";
				    }
				%>
				  <option value="<%=pointid%>" <%=isselected%>><%=pointid%></option>
				<%    
				}
				%>
	            </select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item><!-- 描述 -->
			<wea:item>
				<textarea class=inputstyle id="dsMemo" name="dsMemo" style="width: 95%;" rows=3><%=FnaCommon.escapeHtml(dsMemo)%></textarea>
        	</wea:item>
		</wea:group>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<%if(hiddenBtnBar!=1){ %>
<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="doClose();" 
	    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
	    	</wea:item>
	    </wea:group>
</wea:layout>
<%} %>
</div>

<Script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

jQuery(document).ready(function(){
	resizeDialog(document);
	try{
		checkinput("dSetName","dSetNameSpan");
	}catch(e1){}
	try{
		checkinput("dSetStr1","dSetStr1Span");
	}catch(e1){}
	try{
		checkinput("dSetStr2","dSetStr2Span");
	}catch(e1){}
	init_tr_dataSourceName();
});

function init_tr_dataSourceName(){
	var _dSetType = jQuery("#dSetType").val();
	if(_dSetType=="1"){
		jQuery("#tr1_dataSourceName").parent().show();
	}else{
		jQuery("#tr1_dataSourceName").parent().hide();
	}

	jQuery("#dSetStr1").hide();
	jQuery("#dSetStr1Span").hide();
	jQuery("#dSetStr2").hide();
	jQuery("#dSetStr2Span").hide();
	jQuery("#span_dSetStr3").hide();
	if(_dSetType=="1"){
		jQuery("#dSetStr2").show();
		jQuery("#dSetStr2Span").show();
	}else if(_dSetType=="2"){
		jQuery("#span_dSetStr3").show();
	}else{
		jQuery("#dSetStr1").show();
		jQuery("#dSetStr1Span").show();
	}

	//alert("_dSetType="+_dSetType+";"+jQuery("#parameter"+_dSetType).length);
	jQuery("#parameter1").hide();
	jQuery("#parameter2").hide();
	jQuery("#parameter3").hide();
	jQuery("#parameter4").hide();
	jQuery("#parameter5").hide();
	jQuery("#parameter"+_dSetType).show();
}

//关闭
function doClose(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

//关闭
function doClose2(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

function dSetType_onchange(){
	jQuery("#dSetStr1").val("");
	jQuery("#dSetStr2").val("");
	try{checkinput("dSetStr1","dSetStr1Span");}catch(ex1){}
	try{checkinput("dSetStr2","dSetStr2Span");}catch(ex1){}
	init_tr_dataSourceName();
}

//保存
function doEdit(){
	if(jQuery("#dSetName").val()==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("195,81909",user.getLanguage())%>");
		return;
	}
	
	try{
		var id = null2String(jQuery("#id").val());
		var dSetName = null2String(jQuery("#dSetName").val());
		var dataSourceName = null2String(jQuery("#dataSourceName").val());
		var dsMemo = null2String(jQuery("#dsMemo").val());
		var dSetType = null2String(jQuery("#dSetType").val());
		var dSetStr1 = null2String(jQuery("#dSetStr1").val());
		var dSetStr2 = null2String(jQuery("#dSetStr2").val());
		var dSetStr3 = null2String(jQuery("#dSetStr3").val());
		var dSetStr = "";
		if(dSetType=="1"){
			dSetStr = dSetStr2;
		}else if(dSetType=="2"){
			dSetStr = dSetStr3;
		}else{
			dSetStr = dSetStr1;
		}
		if(dSetStr==""){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("63,81909",user.getLanguage())%>");
			return;
		}

		var _key1 = "<%=Des.KEY1 %>";
		var _key2 = "<%=Des.KEY2 %>";
		var _key3 = "<%=Des.KEY3 %>";
		dSetStr = strEnc(dSetStr,_key1,_key2,_key3);
	
		var _data = "operation=doSave&id="+id+
			"&dSetName="+encodeURI(dSetName)+"&dataSourceName="+encodeURI(dataSourceName)+"&dsMemo="+encodeURI(dsMemo)+
			"&dSetType="+(dSetType)+"&dSetStr="+encodeURI(dSetStr)+
			"&fnaVoucherXmlId=<%=fnaVoucherXmlId %>"+
			"";

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/fnaVoucher/dataSetOperation.jsp",
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
				    	
						try{parentWin._table.reLoad();}catch(ex1){}
						try{parentWin.closeDialog();}catch(ex1){}
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
	}
}

</script>
</BODY>
</HTML>