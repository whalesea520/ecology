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
String titlename = SystemEnv.getHtmlLabelName(332,user.getLanguage());//全部
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

int id = Util.getIntValue(request.getParameter("id"),0);
int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"),0);
int fnaVoucherXmlContentId = Util.getIntValue(request.getParameter("fnaVoucherXmlContentId"),0);

int fnaDataSetId = 0;
String dSetAlias = "";
String parameter = "";
String dsetMemo = "";
double orderId = 0.00;
int initTiming = 0;

String sql = "select * from fnaVoucherXmlContentDset a where a.id = "+id;
rs.executeSql(sql);
if(rs.next()){
	fnaVoucherXmlContentId = Util.getIntValue(rs.getString("fnaVoucherXmlContentId"), 0);
	fnaDataSetId = Util.getIntValue(rs.getString("fnaDataSetId"), 0);
	dSetAlias = Util.null2String(rs.getString("dSetAlias")).trim();
	parameter = Util.null2String(rs.getString("parameter")).trim();
	dsetMemo = Util.null2String(rs.getString("dsetMemo")).trim();
	orderId = Util.getDoubleValue(rs.getString("orderId"), 0.00);
	initTiming = Util.getIntValue(rs.getString("initTiming"), 0);
}else{
	sql = "select max(orderId) max_orderId from fnaVoucherXmlContentDset a "+
		" where a.fnaVoucherXmlContentId = "+fnaVoucherXmlContentId;
	rs.executeSql(sql);
	if(rs.next()){
		orderId = Util.getDoubleValue(df.format(Util.getDoubleValue(rs.getString("max_orderId"), 0.00)+1));
	}
}

String fnaDataSetName = "";
if(fnaDataSetId > 0){
	sql = "select dSetName from fnaDataSet a where a.id = "+fnaDataSetId;
	rs.executeSql(sql);
	if(rs.next()){
		fnaDataSetName = Util.null2String(rs.getString("dSetName")).trim();
	}
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
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(84720,user.getLanguage()) %>"/>
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
<input type="hidden" id="fnaVoucherXmlId" name="fnaVoucherXmlId" value="<%=fnaVoucherXmlId %>" />
<input type="hidden" id="fnaVoucherXmlContentId" name="fnaVoucherXmlContentId" value="<%=fnaVoucherXmlContentId %>" />
	<wea:layout type="2col">
		<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>"><!-- 基本信息 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(84743,user.getLanguage())%></wea:item><!-- 别名 -->
			<wea:item>
				<wea:required id="dSetAliasSpan" required="true">
        			<input class="inputstyle" id="dSetAlias" name="dSetAlias" maxlength="50" style="width: 200px;" 
        				onchange='checkinput("dSetAlias","dSetAliasSpan");' value="<%=FnaCommon.escapeHtml(dSetAlias)%>" />
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(84712,user.getLanguage())%></wea:item><!-- 数据集 -->
			<wea:item>
				<%
				String fnaDataSetId_str = fnaDataSetId+"";
				String _browserUrl = "/systeminfo/BrowserMain.jsp?url=/fna/browser/dataSet/dataSetBrowser.jsp%3FfnaVoucherXmlId="+fnaVoucherXmlId;
				%>
		        <brow:browser viewType="0" name="fnaDataSetId" browserValue="<%=fnaDataSetId_str %>" 
		                browserUrl="<%=_browserUrl %>"
		                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
		                completeUrl="/data.jsp?type=dataSetBrowser" temptitle=""
		                browserSpanValue="<%=FnaCommon.escapeHtml(fnaDataSetName) %>" width="70%" 
		                linkUrl="/fna/fnaVoucher/dataSetEdit.jsp?hiddenBtnBar=1&id=" 
		                _callback="" >
		        </brow:browser>
		        <button class="e8_browserAdd" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" id="field751_addbtn" type="button" onclick="doAddDset();"></button>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(84770,user.getLanguage())%></wea:item><!-- 初始化时机 -->
			<wea:item>
				<select id="initTiming" name="initTiming" >
					<option value="0" <%=(initTiming==0?"selected=\"selected\"":"") %>><%=SystemEnv.getHtmlLabelName(31706,user.getLanguage())%></option><!-- 节点前 -->
					<option value="1" <%=(initTiming==1?"selected=\"selected\"":"") %>><%=SystemEnv.getHtmlLabelName(31705,user.getLanguage())%></option><!-- 节点后 -->
				</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(32312,user.getLanguage())%></wea:item><!-- 传入参数 -->
			<wea:item>
       			<input class="inputstyle" id="parameter" name="parameter" style="width: 95%;" 
       				value="<%=parameter%>" /><br />
	            <font color="red" style="font: bold;">
					<span id="parameter1">
						<%=SystemEnv.getHtmlLabelName(84735,user.getLanguage())%><br />
						<%=SystemEnv.getHtmlLabelName(84736,user.getLanguage())%><br />
						<%=SystemEnv.getHtmlLabelName(84737,user.getLanguage())%><br />
						<%=SystemEnv.getHtmlLabelName(84738,user.getLanguage())%><br />
						
						<%=SystemEnv.getHtmlLabelName(84717,user.getLanguage())%><br />
						<%=SystemEnv.getHtmlLabelName(84729,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>requestids<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84730,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>userid<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84731,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>loginname<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84732,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>username<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84733,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>workcode<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84734,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>language<%=FnaCreateXml.FLAG_CHAR %><br />
						<%=SystemEnv.getHtmlLabelName(84806,user.getLanguage())%>：<%=FnaCreateXml.FLAG_CHAR %>guid<%=FnaCreateXml.FLAG_CHAR %>
					</span><!-- 
						//传入参数格式：
						//“#”加上“数据集别名”加上“.”加上“数据集中值的名称（SQL中为查询结果列名、类中为方法名、配置文件为配置项名称、默认变量为变量名）”加上“#”
						//可填写多个，如果是作为类的参数请按照类的参数的顺序依次填写
						//如：#数据集别名.数据集值名称##数据集别名.另一个数据集值名称##另一个数据集别名.另一个数据集值名称#.....
					 -->
				</font>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(84822,user.getLanguage())%></wea:item><!-- 加载顺序 -->
			<wea:item>
				<wea:required id="orderIdSpan" required="true">
	       			<input class="inputstyle" id="orderId" name="orderId" maxlength="10" style="width: 50px;" 
	       				onchange='checkinput("orderId","orderIdSpan");' value="<%=df.format(orderId)%>" />
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item><!-- 描述 -->
			<wea:item>
				<textarea class=inputstyle id="dsetMemo" name="dsetMemo" style="width: 95%;" rows=4><%=FnaCommon.escapeHtml(dsetMemo)%></textarea>
        	</wea:item>
		</wea:group>
</wea:layout>
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

<Script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

jQuery(document).ready(function(){
	resizeDialog(document);
	try{
		checkinput("dSetAlias","dSetAliasSpan");
	}catch(e1){}
	try{
		checkinput("orderId","orderIdSpan");
	}catch(e1){}
	try{
		controlNumberCheck_jQuery("orderId", true, 2, false, 2);
	}catch(e1){}
});

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

//新建
function doAddDset(){
	var _h = 340;
	_fnaOpenDialog("/fna/fnaVoucher/dataSetEdit.jsp?fnaVoucherXmlId=<%=fnaVoucherXmlId %>", 
			"<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(84712,user.getLanguage()) %>", 
			660, 550);
}

//保存
function doEdit(){
  try{
		var id = null2String(jQuery("#id").val());
		var fnaVoucherXmlId = null2String(jQuery("#fnaVoucherXmlId").val());
		var fnaVoucherXmlContentId = null2String(jQuery("#fnaVoucherXmlContentId").val());
		var fnaDataSetId = null2String(jQuery("#fnaDataSetId").val());
		var dSetAlias = null2String(jQuery("#dSetAlias").val());
		var parameter = null2String(jQuery("#parameter").val());
		var dsetMemo = null2String(jQuery("#dsetMemo").val());
		var orderId = null2String(jQuery("#orderId").val());
		var initTiming = null2String(jQuery("#initTiming").val());

		if(fnaDataSetId==""||fnaDataSetId=="0"){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("84712,18019",user.getLanguage())%>");
			return;
		}

		if(dSetAlias==""){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("84743,18019",user.getLanguage())%>");
			return;
		}

		var _key1 = "<%=Des.KEY1 %>";
		var _key2 = "<%=Des.KEY2 %>";
		var _key3 = "<%=Des.KEY3 %>";
		parameter = strEnc(parameter,_key1,_key2,_key3);
	
		var _data = "operation=edit&id="+id+"&fnaVoucherXmlId="+fnaVoucherXmlId+"&fnaVoucherXmlContentId="+fnaVoucherXmlContentId+"&dSetAlias="+encodeURI(dSetAlias)+
			"&fnaDataSetId="+(fnaDataSetId)+"&parameter="+encodeURI(parameter)+
			"&dsetMemo="+encodeURI(dsetMemo)+"&orderId="+(orderId)+"&initTiming="+initTiming+
			"";

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/fnaVoucher/fnaVoucherXmlContentDsetOperation.jsp",
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