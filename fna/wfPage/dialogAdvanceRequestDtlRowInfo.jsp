<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

RecordSet rs_fna = new RecordSet();
DecimalFormat df = new DecimalFormat("#################################################0.00");

int requestid = Util.getIntValue(request.getParameter("requestid"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int Yfklc = Util.getIntValue(request.getParameter("Yfklc"));
int _dtlNumber = Util.getIntValue(request.getParameter("_dtlNumber"));


int YfklcFormid = 0;
int YfklcFormidAbs = 0;
int YfklcWfid = 0;
String requestname = "";

String sql = "select b.formid, a.requestname, a.workflowid \n" +
	" from workflow_requestbase a \n" +
	" join workflow_base b on a.workflowid = b.id \n" +
	" where a.requestid = "+Yfklc;
rs_fna.executeSql(sql);
if(rs_fna.next()){
	YfklcFormid = Util.getIntValue(rs_fna.getString("formid"));
	YfklcFormidAbs = Math.abs(YfklcFormid);
	requestname = Util.null2String(rs_fna.getString("requestname")).trim();
	YfklcWfid = Util.getIntValue(rs_fna.getString("workflowid"));
}

String dt1_fieldNameYfkje = "";

sql = "select a.fieldId, a.fieldType, b.fieldname, a.dtlNumber from fnaFeeWfInfoField a \n" +
		" join workflow_billfield b on a.fieldId = b.id \n" +
		" where a.dtlNumber = 1 and a.workflowid = "+YfklcWfid;
rs_fna.executeSql(sql);
while(rs_fna.next()){
	String fieldType = Util.null2String(rs_fna.getString("fieldType"));
	String fieldname = Util.null2String(rs_fna.getString("fieldname")).trim();
	String dtlNumber = Util.null2String(rs_fna.getString("dtlNumber"));
	String fieldId = Util.null2String(rs_fna.getString("fieldId")).trim();

	if(Util.getIntValue(fieldType)==1){
		dt1_fieldNameYfkje = fieldname;
	}
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=Util.toScreenForWorkflow(SystemEnv.getHtmlLabelName(128576,user.getLanguage())) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<span title="<%=SystemEnv.getHtmlLabelNames("83190,83", user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
		
<form action="">
<%
	//设置好搜索条件
	String backFields =" row_number() over(order by dt.id asc) as row_num_dtl, dt.*, ";
	backFields += " (select SUM(fbi.amountAdvance * fbi.advanceDirection) sum_amountAdvance \n" +
			"	from FnaAdvanceInfo fbi \n" +
			"	where fbi.requestid <> "+requestid+" and fbi.advanceRequestIdDtlId = dt.id \n" +
			"		and fbi.advanceRequestId = main.requestId \n" +
			"	GROUP BY fbi.advanceRequestId, fbi.advanceRequestIdDtlId) sum_amountAdvance \n";
	
	String fromSql = " from formtable_main_"+YfklcFormidAbs+"_dt1 dt " +
			" join formtable_main_"+YfklcFormidAbs+" main on main.id=dt.mainid ";
	
	String sqlWhere = " where main.requestId="+Yfklc+" ";

	String orderBy = " dt.id ";
	
	String sqlprimarykey = "dt.id";

	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
       "<table pagesize=\"6\" tabletype=\"none\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" "+
      		" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" />"+
       "<head>"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"row_num_dtl\" "+//序号
					" />"+
			"<col width=\"45%\"  text=\""+SystemEnv.getHtmlLabelName(1043,user.getLanguage())+"\" column=\""+dt1_fieldNameYfkje+"\" "+//借款金额
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\" />"+
			"<col width=\"45%\"  text=\""+SystemEnv.getHtmlLabelName(83288,user.getLanguage())+"\" column=\"sum_amountAdvance\" "+//未还金额
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\" />";
	tableString += "</head>"+
       "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
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
    		<input class="zd_btn_cancle" type="submit" id="btnCancel" onclick="onCancel();" 
    			value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"/><!-- 清除 -->
    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

var currentUid = "<%=user.getUID() %>";

jQuery(document).ready(function(){
	resizeDialog(document);
	//获得页面上所有的tr元素
	var objXtb = jQuery("tr");
	objXtb.live("click", function(){
		var _objTr = jQuery(this);
		var className = _objTr.attr("className");
		//以该className判断是否为分页控件的tr，且该tr被鼠标选中，且是分页控件的下级tr元素
		if(className=="Selected" && getFirstParentTrObj(this, 0)){
			var dtlId = "";
			var dtlRowNumber = "";
			var _childArray = _objTr.children();
			for(var i=0;i<_childArray.length;i++){
				var _childObj = jQuery(_childArray[i]);
				var tagName = _childObj.attr("tagName");
				if(tagName=="TD"){
					if(i==0){
						dtlId = jQuery(_childObj.children()[0]).val();//获得明细行数据库id
					}else if(i==1){
						dtlRowNumber = jQuery.trim(_childObj.text());//获得明细行行号
					}else if(i==4){
						var whje = jQuery.trim(_childObj.text());
						//判断当前借款流程的当前明细是否未还金额<=0,是则不允许选择（为了行号正确不能在sql阶段过滤掉）
						if(fnaRound2(whje, 2) <= 0){
							return;
						}
					}
				}
			}
			var _trunStr = {"id":dtlId,"name":dtlRowNumber,"_dtlNumber":<%=_dtlNumber %>};
			var parentWin = parent.getParentWindow(window);
			parentWin.setAdvanceDnxhValue(_trunStr);
			doClose();
		}
	});
});

//递归判断父元素（上层4级之内）中是否存在className等于ListStyle的元素，如果是则表示是分页控件的下级元素，返回true
function getFirstParentTrObj(_obj, _deep){
	if(_deep > 5){
		return false;
	}
	_deep = _deep+1;
	_obj = jQuery(_obj);
	var className = _obj.attr("className");
	if(className=="ListStyle"){
		return true;
	}else{
		return getFirstParentTrObj(_obj.parent(), _deep);
	}
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

//关闭
function doClose(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

function onCancel(){
	var _trunStr = {"id":"","name":"","_dtlNumber":<%=_dtlNumber %>};
	var parentWin = parent.getParentWindow(window);
	parentWin.setAdvanceDnxhValue(_trunStr);
	
	var dialog = parent.getDialog(window);	
	dialog.close();
}

function onClear() {
	var returnjson = {id:"",name:""};
	if(dialog){
		try{
			dialog.callback(returnjson);
		}catch(e){}
		try{
			dialog.close(returnjson);
		}catch(e){}
	}else{
		window.parent.parent.returnValue = returnjson;
	 	window.parent.parent.close();
	}
}

</script>
</BODY>
</HTML>
