<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@ page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
</head>
<%
	if (!HrmUserVarify.checkUserRight("FnaYearsPeriodsAdd:Add", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(446, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String id="";
%>
<BODY>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
RCMenu += "{"+SystemEnv.getHtmlLabelName(365, user.getLanguage())+",javascript:newFnaYearsPeriod(),_self}";
RCMenuHeight += RCMenuHeightStep;
if(false && HrmUserVarify.checkUserRight("FnaYearsPeriods:Log",user)) {
	if(RecordSet.getDBType().equals("db2")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem) =37 and relatedid="+user.getLoginid()+",_self} " ;   
	}else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =37 and relatedid="+user.getLoginid()+",_self} " ;
	}
	RCMenuHeight += RCMenuHeightStep ;	
}
%>


<script type="text/javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

	//关闭
	function doClose1(){
		window.closeDialog();
	}

	function onBtnSearchClick(){
		document.getElementById("frmmain").submit();
	}

	function newFnaYearsPeriod(){
		_fnaOpenDialog("/fna/maintenance/FnaYearsPeriodsAdd.jsp", 
				"<%=SystemEnv.getHtmlLabelName(33017,user.getLanguage()) %>", 
				410, 230);
	}

	function openEditPage(id, para2, para3, _type, parentWin){
		if(_type==null){
			_type = 0;
		}
		if(parentWin!=null){
			doClose1();
			onBtnSearchClick();
		}
		_fnaOpenDialog("/fna/maintenance/FnaYearsPeriodsEdit.jsp?operationType=edit&id="+id+"&_type="+_type, 
				"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(18648,user.getLanguage()) %>", 
				600, 635);
	}

	function doEffect(id){
		doEffect2(false, id);
	}

	function doEffect2(_flag, id){
		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/maintenance/FnaYearsPeriodsOperation.jsp",
			type : "post",
			processData : false,
			data : "operation=takeeffectyearperiods&id="+id+"&_flag="+_flag,
			dataType : "json",
			success: function do4Success(msg){ 
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(msg.flag){
					onBtnSearchClick();
				}else{
					alert(msg.erroInfo);
				}
			}
		});
	}
		
	function doDel(id){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
			function(){
				openNewDiv_FnaBudgetViewInner1(_Label33574);
				jQuery.ajax({
					url : "/fna/maintenance/FnaYearsPeriodsOperation.jsp",
					type : "post",
					processData : false,
					data : "operation=deleteyearperiods&id="+id,
					dataType : "json",
					success: function do4Success(msg){ 
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(msg.flag){
							onBtnSearchClick();
						}else{
							alert(msg.erroInfo);
						}
					}
				});
			}, function(){}
		);
	}

	function doClose(id){
		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/maintenance/FnaYearsPeriodsOperation.jsp",
			type : "post",
			processData : false,
			data : "operation=closedownyearperiods&id="+id,
			dataType : "json",
			success: function do4Success(msg){ 
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(msg.flag){
					onBtnSearchClick();
				}else{
					alert(msg.erroInfo);
				}
			}
		});
	}

	function  doReopen(id){
		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/maintenance/FnaYearsPeriodsOperation.jsp",
			type : "post",
			processData : false,
			data : "operation=reopenDD&id="+id,
			dataType : "json",
			success: function do4Success(msg){ 
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(msg.flag){
					onBtnSearchClick();
				}else{
					alert(msg.erroInfo);
				}
			}
		});
	}
</script>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<form class=ViewForm id="frmmain" action="/fna/maintenance/FnaYearsPeriods.jsp" method="post">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="text" class="searchInput" name="flowTitle" value="<%=qname%>" />
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>" 
						class="e8_btn_top" onclick="newFnaYearsPeriod();"/><!-- 新建 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
<%
	String backfields = "*";
	String sqlWhere = " ";
	String fromSql = " from FnaYearsPeriods";
	String orderby = "fnayear";
	String tableString = "";

	if (!"".equals(qname)) {
		sqlWhere += " where fnayear like '%" + StringEscapeUtils.escapeSql(qname) + "%'";
	}

	tableString = " <table instanceid=\"FNA_YEARS_PERIODS_LIST\" pageId=\""+PageIdConst.FNA_YEARS_PERIODS_LIST+"\" "+
				" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_YEARS_PERIODS_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"none\" >"
			+ "	   <sql backfields=\"" + Util.toHtmlForSplitPage(backfields) + "\" sqlform=\"" + Util.toHtmlForSplitPage(fromSql) + "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) + "\" "+
					" sqlorderby=\"" + Util.toHtmlForSplitPage(orderby) + "\" sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"
			+ "			<head>"
			+ "				<col width=\"25%\" labelid=\"445\" text=\"" + SystemEnv.getHtmlLabelName(445, user.getLanguage()) + "\" column=\"fnayear\"  orderkey=\"fnayear\" "+
							" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"openEditPage+column:id\"/>"
			+ "				<col width=\"25%\" labelid=\"740\" text=\""	+ SystemEnv.getHtmlLabelName(740, user.getLanguage()) + "\" column=\"startdate\"  orderkey=\"startdate\"  />"
			+ "				<col width=\"25%\" labelid=\"741\" text=\"" + SystemEnv.getHtmlLabelName(741, user.getLanguage()) + "\" column=\"enddate\" orderkey=\"enddate\"    />"
			+ "				<col width=\"25%\" labelid=\"602\" text=\""	+ SystemEnv.getHtmlLabelName(602, user.getLanguage()) + "\" column=\"status\" "+
							" transmethod=\"weaver.general.FnaTransMethod.getStatus\"  otherpara=\""+user.getLanguage()+"\"/>"+
			"			</head>" + 
			"		<operates>"+
			"			<popedom transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFnaYearsPeriods_popedom\" otherpara=\"column:status\" ></popedom> "+
			"			<operate href=\"javascript:openEditPage();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"0\"/>"+
			"			<operate href=\"javascript:doEffect();\" text=\""+SystemEnv.getHtmlLabelName(18431, user.getLanguage())+"\" index=\"1\"/>"+
			"			<operate href=\"javascript:doClose();\" text=\""+SystemEnv.getHtmlLabelName(309, user.getLanguage())+"\" index=\"2\"/>"+
			"			<operate href=\"javascript:doReopen();\" text=\""+SystemEnv.getHtmlLabelName(244, user.getLanguage())+"\" index=\"3\"/>"+
			"			<operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"4\"/>"+
			"		</operates>"+
			" </table>";
%>
			<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_YEARS_PERIODS_LIST %>" />
			<wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
		</form>
	</BODY>
</HTML>


