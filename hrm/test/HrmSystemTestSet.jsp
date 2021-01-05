<%@page import="java.text.DecimalFormat"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ActionXML" class="weaver.servicefiles.ActionXML" scope="page" />
<%@ page import="weaver.systeminfo.label.LabelComInfo"%>

<%

String cversion = "";
rs.executeSql("select * from license");
if(rs.next()){
	cversion = Util.null2String(rs.getString("cversion")).trim();
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//通用设置
String needfav ="1";
String needhelp ="";

String param = request.getParameter("param");
	
Map<String,String> mapProps = new HashMap<String,String>();
Properties props = Prop.loadTemplateProp("hrmGlobalSet");
Object[] propsArray = new Object[props.size()];
for(Map.Entry me : props.entrySet()){
	mapProps = new HashMap<String,String>();
	String globalSetValue = Util.null2String(me.getValue());
	String globalSetKey = Util.null2String(me.getKey());
	String[] globalSetKeys = globalSetKey.split("-");
	mapProps.put(globalSetKeys[1],globalSetValue);
	propsArray[Util.getIntValue(globalSetKeys[0])] = mapProps; 
}


%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<style type="text/css">
.noteinfo{
	margin-left: 15px;
	color:olive;
	font-size: 13px !important;
}
</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{重新检查,javascript:doRefresh(),_self}";
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{使用说明,javascript:doHelp1(),_self}";
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post" action="">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="重新检查" 
				class="e8_btn_top" onclick="doRefresh();"/>
			<input type="button" value="使用说明" 
				class="e8_btn_top" onclick="doHelp1();"/>
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
<%
for(int i = 0 ; i < propsArray.length ;i++){
	Map<String,String> tmpMap = (Map)propsArray[i];
	for(Map.Entry me : tmpMap.entrySet()){
	String tmpUrl = (String)me.getValue();
%>	
   	<jsp:include page="<%=tmpUrl %>" >
   		<jsp:param value="<%=param %>" name="param"/>
   	</jsp:include>
<%
break;
}
}
 %>
</form>


<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

function onBtnSearchClick(){}

function doHelp1(){
	window.location.href="/hrm/test/人力资源配置检查.docx";
}

function doRefresh(a){
	window.location.href="/hrm/test/HrmSystemTestSet.jsp?param="+a;
}

function gotoSet_onclick(_url){
	window.open(_url);
}
function goNew(_url){
	window.open(_url);
}
</script>
</body>
</html>



















































