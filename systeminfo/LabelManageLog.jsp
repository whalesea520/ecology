<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.URLDecoder" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="LabelMainManager" class="weaver.systeminfo.label.LabelMainManager" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<% 
	String id = Util.null2String(request.getParameter("relatedid"));
	String operateitem = Util.null2String(request.getParameter("operateitem"));
	String name = "";
	String sql = "";
	if(operateitem.equals("418")){
		sql = "select indexdesc from HtmlLabelIndex where id="+id;
	}else if(operateitem.equals("419")){
		sql = "select indexdesc from HtmlNoteIndex where id="+id;
	}else if(operateitem.equals("420")){
		sql = "select indexdesc from ErrorMsgIndex where id="+id;
	}
	if(!sql.equals("")){
		RecordSet.executeSql(sql);
		if(RecordSet.next()){
			name = Util.null2String(RecordSet.getString(1));
		}
	}
%>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if(!dialog){
	dialog = parent.getDialog(this);
}
try{
	parent.setTabObjName("<%=name+" "+SystemEnv.getHtmlLabelNames("25484,83",user.getLanguage())%>");
}catch(e){}
function onBtnSearchClick(){
	jQuery("#frmmain").submit();
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelNames("25484,83",user.getLanguage());
String needfav ="1";
String needhelp ="";
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
String operatedateselect = Util.null2String(request.getParameter("operatedateselect"));
if(operatedateselect.equals(""))operatedateselect="1";
if(operatedateselect.equals("1")){
	fromdate = TimeUtil.getDateByOption(operatedateselect,"0");
	todate = TimeUtil.getDateByOption(operatedateselect,"1");
}
RecordSet.executeSql("select * from syslanguage  where activable=1");
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClick(),_self}";
	RCMenuHeight += RCMenuHeightStep;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onBtnSearchClick();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
	String sqlWhere = Util.null2String(request.getParameter("sqlwhere"));
	sqlWhere += "relatedid="+id+" and operateitem="+operateitem;
	String languagesql = "";
	while(RecordSet.next()){
		if(languagesql.equals("")){
			languagesql += " (languageid= "+RecordSet.getString("id");
		}else{
			languagesql += " or languageid= "+RecordSet.getString("id");
		}
	}
	if(!languagesql.equals("")){
		languagesql += ")";
		sqlWhere += " and "+ languagesql;
	}
	if(!"".equals(fromdate))
	{
		sqlWhere += " and operateDate >= '" + fromdate + "'";				    
	}
	if(!"".equals(todate))
	{
		sqlWhere += " and operateDate <= '" + todate + "'";
	}
	String sqlfrom = "labelManageLog" ;
	 String tabletype="none";
	String tableString=""+
	   "<table pageId=\""+PageIdConst.SYS_SYSTEM_LABEL_LOG_LIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.SYS_SYSTEM_LABEL_LOG_LIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\""+Util.toHtmlForSplitPage(sqlfrom)+"\" sqlorderby=\"operateDate\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
	   "<head>"+							 
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelNames("176,231",user.getLanguage())+"\" column=\"languageid\" transmethod=\"weaver.systeminfo.language.LanguageComInfo.getLanguagename\"  orderkey=\"languageid\"/>"+
			 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(6056,user.getLanguage())+"\" column=\"oldvalue\"/>"+
			 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(81492,user.getLanguage())+"\" column=\"newvalue\"/>";
			 tableString += "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(99,user.getLanguage())+"\" column=\"operateuserid\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getResourceNameLink\" orderkey=\"operateuserid\"/>";
			 tableString += "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(18008,user.getLanguage())+"\" column=\"operateDate\" otherpara=\"column:operateTime\" transmethod=\"weaver.splitepage.transform.SptmForCowork.combineDateTime\" orderkey=\"operateDate\"/>";
			 tableString += "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("108,110",user.getLanguage())+"\" column=\"clientAddress\"/>";
	   	tableString = tableString + "</head>"+
	   "</table>";
%> 
<form name="frmmain" id="frmmain" method="post" action="LabelManageLog.jsp">
	<input type="hidden" name="sqlwhere" value="<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere"))) %>"/>
		<input type="hidden" name="relatedid" value="<%=id %>"/>
		<input type="hidden" name="operateitem" value="<%=operateitem %>"/>
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(19482,user.getLanguage())%></wea:item>
			    <wea:item>
			    	<span class="wuiDateSpan"  selectId="operatedateselect" selectValue="<%= operatedateselect%>">
					    <input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
					    <input class=wuiDateSel  type="hidden" name="todate" value="<%=todate%>">
					</span>
			    </wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(33046,user.getLanguage())%>'>
				<wea:item attributes="{'isTableList':'true'}">
					<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
				</wea:item>
			</wea:group>
		</wea:layout>
</form>
<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.SYS_SYSTEM_LABEL_LOG_LIST %>"/>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
</HTML>
