
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";

int from = Util.getIntValue(request.getParameter("from"), -1);
String callbkfun = Util.null2String(request.getParameter("callbkfun"));
String selectids = Util.null2String(request.getParameter("selectids"));

String name = Util.null2String(request.getParameter("name"));
int feeperiod = Util.getIntValue(request.getParameter("feeperiod"), 0);
String description = Util.null2String(request.getParameter("description"));

%>
<HTML><HEAD>
	<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
</head>
<body scroll="no">
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM id="weaver" NAME="SearchForm" STYLE="margin-bottom:0" action="" onsubmit="return false;" method=post>
	<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
	<input type="hidden" name="pagenum" value=''>
	<input type="hidden" name="from" id="from" value='<%=from%>'>
	<input type="hidden" name="callbkfun" id="callbkfun" value='<%=callbkfun%>'>
	<input type="hidden" name="supsubject" id="supsubject" value="0" />
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'><!-- 搜索条件 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(15409,user.getLanguage())%></wea:item><!-- 科目名称 -->
			<wea:item>
        		<input class="inputstyle" id="name" name="name" value="<%=name%>" />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15388,user.getLanguage())%></wea:item><!-- 预算周期 -->
			<wea:item>
	            <select class="inputstyle" id="feeperiod" name="feeperiod" style="width: 80px;">
					<option value="0" ></option>
					<option value="1" <% if(feeperiod==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></option>
					<option value="2" <% if(feeperiod==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%></option>
					<option value="3" <% if(feeperiod==3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%></option>
					<option value="4" <% if(feeperiod==4) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></option>
	            </select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item><!-- 描述 -->
			<wea:item>
        		<input class="inputstyle" id="description" name="description" value="<%=description%>" />
        	</wea:item>
			<wea:item></wea:item>
			<wea:item>
        	</wea:item>
        </wea:group>
	</wea:layout>
</form>

</body>
<SCRIPT language="javascript">

</script>
</html>
