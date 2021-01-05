
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="scheduleService" class="weaver.mobile.plugin.ecology.service.ScheduleService" scope="page" />

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser(request , response);
if(user == null)  return ;

int detailid = Util.getIntValue((String)request.getParameter("detailid"));
int module = Util.getIntValue((String)request.getParameter("module"));
int scope = Util.getIntValue((String)request.getParameter("scope"));

String titleurl = Util.null2String((String)request.getParameter("title"));
String title = StringEscapeUtils.escapeHtml(URLDecoder.decode(titleurl,"UTF-8"));
titleurl = StringEscapeUtils.escapeHtml(URLEncoder.encode(titleurl, "UTF-8"));

String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));

String month = Util.null2String((String)request.getParameter("month"));
String year = Util.null2String((String)request.getParameter("year"));
String date = Util.null2String((String)request.getParameter("date"));

DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

int dayoffirst = 0;
int dayoflast = 0;

int daycount = 0;
int rowcount = 0;

String today = df.format(new Date());

Calendar firstdate = Calendar.getInstance();
Calendar lastdate = Calendar.getInstance();

Calendar c = Calendar.getInstance();
if(!"".equals(date)) {
	c.setTime(df.parse(date));
} else if(!"".equals(month)&&!"".equals(year)) {
	c.set(Calendar.YEAR, Util.getIntValue(year));
	c.set(Calendar.MONTH, Util.getIntValue(month)-1);
	c.set(Calendar.DAY_OF_MONTH, 1);
}

date = df.format(c.getTime());
month = (c.get(Calendar.MONTH)+1)+"";
year = c.get(Calendar.YEAR)+"";

c.set(Calendar.DAY_OF_MONTH, 1);
dayoffirst = c.get(Calendar.DAY_OF_WEEK);

firstdate.setTime(c.getTime());
firstdate.add(Calendar.DAY_OF_MONTH, -(dayoffirst-1));

daycount += dayoffirst-1;

c.add(Calendar.MONTH, 1);
c.add(Calendar.DAY_OF_MONTH, -1);
dayoflast = c.get(Calendar.DAY_OF_WEEK);

daycount += c.get(Calendar.DAY_OF_MONTH);

lastdate.setTime(c.getTime());
lastdate.add(Calendar.DAY_OF_MONTH,7-dayoflast);

daycount += 7-dayoflast;

rowcount = daycount / 7 + (daycount%7==0?0:1);

Map data = scheduleService.getScheduleCounts(df.format(firstdate.getTime()), df.format(lastdate.getTime()), user);


List conditionList = new ArrayList();

conditionList.add(date);
conditionList.add(date);

Map pages = scheduleService.getScheduleList(conditionList, 1, 10, user);

List list = (List)pages.get("list");

%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><%=title %></title>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
	<style type="text/css">
	.schedule {
		border-top:solid 1px #FFF;
		border-right:solid 1px #FFF;
		border-left:solid 1px #D9D9D9;
		border-bottom:solid 1px #D9D9D9;
		cursor: pointer;
	}
	.selected {
		background:url("/mobile/plugin/5/images/btn_selecteddate_wev8.png") repeat-x;
		border-top:solid 1px #0083CB;
		border-right:solid 1px #0083CB;
		border-left:solid 1px #0083CB;
		border-bottom:solid 1px #0083CB;
	}
	.today {
		background:url("/mobile/plugin/5/images/btn_currentdate_wev8.png") repeat-x;
		border-top:solid 1px #999;
		border-right:solid 1px #999;
		border-left:solid 1px #999;
		border-bottom:solid 1px #999;
	}
	</style>
	<script type="text/javascript">
	function doLeftButton() {
	}
	function doBack() {
		var result = doLeftButton();
		if(result==null||result=="BACK"){
			location = "/home.do";
		}
	}
	</script>
</head>
<body>

<div id="view_page">

	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<a href="javascript:doBack();">
			<div style="position:absolute;left:5px;top:6px;width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
			<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>
			</div>
		</a>
		<div id="view_title" style="position:absolute;left:65px;top:6px;right:65px;"><%=title %></div>
		
	</div>

	<div style="width:100%;height:65px;background:url(/mobile/plugin/5/images/bg_title_wev8.png);">
	
		<div style="width:100%;height:40px;">
			<table style="width:100%;height:40px;">
				<tr>
					<td width="12%" align="center" valign="middle">
					<a href="javascript:goYear(-1)">
					<img alt="" src="/mobile/plugin/5/images/btn_yearsleft_wev8.png" style="padding-top:5px;">
					</a>
					</td>
					<td width="12%" align="center" valign="middle">
					<a href="javascript:goMonth(-1)">
					<img alt="" src="/mobile/plugin/5/images/btn_monthleft_wev8.png" style="padding-top:5px;">
					</a>
					</td>
					<td align="center" valign="middle">
					<div style="color:#FFF;font-size:18pt;font-weight:bold;">
					<%=year%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=month %><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
					</div>
					</td>
					<td width="12%" align="center" valign="middle">
					<a href="javascript:goMonth(1)">
					<img alt="" src="/mobile/plugin/5/images/btn_monthright_wev8.png" style="padding-top:5px;">
					</a>
					</td>
					<td width="12%" align="center" valign="middle">
					<a href="javascript:goYear(1)">
					<img alt="" src="/mobile/plugin/5/images/btn_yearsright_wev8.png" style="padding-top:5px;">
					</a>
					</td>
				</tr>
			</table>
		</div>
		
		<div style="width:100%;height:25px;color:#FFF;line-height:25px;">
			<table style="width:100%;height:25px;">
				<tr>
					<td align="center"><%=SystemEnv.getHtmlLabelName(16106,user.getLanguage())%></td>
					<td align="center"><%=SystemEnv.getHtmlLabelName(16100,user.getLanguage())%></td>
					<td align="center"><%=SystemEnv.getHtmlLabelName(16101,user.getLanguage())%></td>
					<td align="center"><%=SystemEnv.getHtmlLabelName(16102,user.getLanguage())%></td>
					<td align="center"><%=SystemEnv.getHtmlLabelName(16103,user.getLanguage())%></td>
					<td align="center"><%=SystemEnv.getHtmlLabelName(16104,user.getLanguage())%></td>
					<td align="center"><%=SystemEnv.getHtmlLabelName(16105,user.getLanguage())%></td>
				</tr>
			</table>
		</div>
	</div>

	<div style="box-shadow:0 3px 5px #000;">
	
		<%
		for(int i=1;i<=rowcount;i++) {
		%>
	
		<table style="width:100%;height:51px;background-color:#F7F7F7;font-size:16pt;">
			<tr>
				
				<%
				for(int j=1;j<=7;j++) {
					c.setTime(firstdate.getTime());
					c.add(Calendar.DAY_OF_MONTH, (i-1)*7+(j-1));
					
					boolean isToday = false;
					boolean isSelected = false;
					boolean isCurrMonth = false;
					
					if(date.equals(df.format(c.getTime()))) isSelected = true;
					else if(today.equals(df.format(c.getTime()))) isToday = true;
					if(Util.getIntValue(month)==(c.get(Calendar.MONTH)+1)) isCurrMonth = true;
					else isCurrMonth = false;
					
					Integer ci = null;
					if(data!=null) ci = (Integer) data.get(df.format(c.getTime()));
					String count = (ci==null)?"0":ci.intValue()+"";
				%>
				<td id="td_<%=df.format(c.getTime()) %>" width="14%" align="center" class="schedule <%if(isSelected){%>selected<%}%> <%if(isToday){%>today<%}%>" onclick="javascript:goDate('<%=df.format(c.getTime()) %>');">
				
				<div id="div_<%=df.format(c.getTime()) %>" style="width:100%;height:100%;padding-top:8px;position:relative;color:<%if(isSelected||isToday){%>#FFF<%}else{%><%if(isCurrMonth){%>#000;<%}else{%>#CCC<%}%><%}%>">
				<%=c.get(Calendar.DAY_OF_MONTH)%>
				<div id="num_<%=df.format(c.getTime()) %>" style="position:absolute;bottom:-2px;right:-2px;width:30px;background:<%if(isSelected){%>#2876A0<%}else{%>#B2B2B2<%}%>;height:16px;color:#FFF;font-size:10pt;">
				<%=count %>
				</div>
				</div>
				
				</td>
				<%
				}
				%>
	
			</tr>
		</table>
	
		<%
		}
		%>
	</div>

	<a href="javascript:goList();">
	<div style="height:150px;background:#FFF url(/mobile/plugin/5/images/bg_homelist_wev8.png) repeat-x;padding:15px;overflow:auto;">
	<%
	if(list!=null&&list.size()>0) {
		for(int i=0;i<list.size();i++) {
			Map schedule = (Map)list.get(i);
	%>
		<table style="width:100%;padding:5px;">
			<tr>
				<td width="20px"><img alt="" src="/mobile/plugin/5/images/icon_liststyle_wev8.png"></td>
				<td width="50px"><%=schedule.get("begintime") %></td>
				<td><%=schedule.get("name") %></td>
			</tr>
		</table>
	<%
		}
	}
	%>
	</div>
	</a>

	<div style="height:40px;background:#B2C0D7 url(/mobile/plugin/5/images/bg_tabbg_wev8.png) repeat-x;">
	<table style="width:100%;height:40px;">
		<tr>
			<td width="10px"></td>
			<td width="53px" align="center" valign="middle">
			<a href="javascript:goToday();">
			<div style="width:53px;height:30px;line-height:30px;background:url(/mobile/plugin/5/images/btn_tab_today_wev8.png) no-repeat;color:#000;"><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></div>
			</a>
			</td>
			<td width="70%" align="center" valign="middle">
			<div style="width:138px;height:30px;">
				<a href="javascript:goList();">
				<div style="float:left;width:69px;height:30px;line-height:30px;background:url(/mobile/plugin/5/images/btn_tab_date_wev8.png) no-repeat;color:#000;"><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></div>
				</a>
				<a href="javascript:goSelect();">
				<div style="float:right;width:69px;height:30px;line-height:30px;background:url(/mobile/plugin/5/images/btn_tab_month_wev8.png) no-repeat;color:#000;"><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></div>
				</a>		
			</div>
			</td>
			<td width="53px">&nbsp;</td>
			<td width="10px"></td>
		</tr>
	</table>
	</div>

</div>

<input type="hidden" id="date" name="date" value="<%=date%>">
<input type="hidden" id="year" name="year" value="<%=year%>">
<input type="hidden" id="month" name="month" value="<%=month%>">
<input type="hidden" id="today" name="today" value="<%=today%>">

<div id="loading"><%=SystemEnv.getHtmlLabelName(81558,user.getLanguage())%></div>
<div id="loadingmask" class="ui-widget-overlay"></div>

<script type="text/javascript">
$(document).ready(function() {
	
	$( "#loading" ).hide();
	$( "#loadingmask" ).hide();
	
});

function goToday() {
	var date = $("#today").val();
	
	location = "/mobile/plugin/4/select.jsp?module=<%=module%>&scope=<%=scope%>&detailid=<%=detailid%>&title=<%=titleurl%>&month="+"&year="+"&date="+date;
}

function goMonth(d) {
	var date = $("#date").val();
	var year = $("#year").val();
	var month = $("#month").val();
	
	month = parseInt(month)+d;
	year = parseInt(year);
	if(month>12){
		month = month-12;
		year = year+1;
	}
	if(month<1) {
		month = 12;
		year = year-1;
	}
	location = "/mobile/plugin/4/select.jsp?module=<%=module%>&scope=<%=scope%>&detailid=<%=detailid%>&title=<%=titleurl%>&month="+month+"&year="+year+"&date=";
}

function goYear(d) {
	var date = $("#date").val();
	var year = $("#year").val();
	var month = $("#month").val();
	
	month = parseInt(month);
	year = parseInt(year) + d;
	
	location = "/mobile/plugin/4/select.jsp?module=<%=module%>&scope=<%=scope%>&detailid=<%=detailid%>&title=<%=titleurl%>&month="+month+"&year="+year+"&date=";
}

function goDate(d) {
	location = "/mobile/plugin/4/select.jsp?module=<%=module%>&scope=<%=scope%>&detailid=<%=detailid%>&title=<%=titleurl%>&month=&year=&date="+d;
}

function goSelect() {
	var date = $("#date").val();
	location = "/mobile/plugin/4/select.jsp?module=<%=module%>&scope=<%=scope%>&detailid=<%=detailid%>&title=<%=titleurl%>&month=&year=&date="+date;
}

function goList() {
	var date = $("#date").val();
	location = "/mobile/plugin/4/list.jsp?module=<%=module%>&scope=<%=scope%>&detailid=<%=detailid%>&title=<%=titleurl%>&month=&year=&date="+date;
}
</script>

</body>
</html>