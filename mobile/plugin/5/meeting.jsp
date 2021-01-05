
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@page import="weaver.systeminfo.SystemEnv"%>

<jsp:useBean id="meetingService" class="weaver.mobile.plugin.ecology.service.MeetingService" scope="page" />

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

String[] weekStr = new String[]{SystemEnv.getHtmlLabelName(398, user.getLanguage()),SystemEnv.getHtmlLabelName(392, user.getLanguage()),SystemEnv.getHtmlLabelName(393, user.getLanguage()),SystemEnv.getHtmlLabelName(394, user.getLanguage())
		,SystemEnv.getHtmlLabelName(395, user.getLanguage()),SystemEnv.getHtmlLabelName(396, user.getLanguage()),SystemEnv.getHtmlLabelName(397, user.getLanguage())};//{"日","一","二","三","四","五","六"};

Calendar today = Calendar.getInstance();
int todayYear = today.get(Calendar.YEAR);
int todayMonth = today.get(Calendar.MONTH);
int todayDay = today.get(Calendar.DAY_OF_MONTH);

Calendar selectCalendar = null;
try {
	if(StringUtils.isNotBlank(date)) {
		Date selectDate = df.parse(date);
		selectCalendar = Calendar.getInstance();
		selectCalendar.setTime(selectDate);
	}
} catch (Exception e) {
	selectCalendar = null;
}

if(selectCalendar == null) {
	selectCalendar = today;
	date = df.format(selectCalendar.getTime());
}

int selectYear = selectCalendar.get(Calendar.YEAR);
int selectMonth = selectCalendar.get(Calendar.MONTH);
int selectDay = selectCalendar.get(Calendar.DAY_OF_MONTH);

Calendar firstdate = Calendar.getInstance();
firstdate.setTime(selectCalendar.getTime());
firstdate.set(Calendar.DAY_OF_MONTH, 1);
int week = firstdate.get(Calendar.DAY_OF_WEEK);
firstdate.add(Calendar.DAY_OF_MONTH, 1-week);

/*
Calendar lastdate = Calendar.getInstance();
lastdate.setTime(selectCalendar.getTime());
lastdate.add(Calendar.MONTH, 1);
lastdate.set(Calendar.DAY_OF_MONTH, 1);
week = lastdate.get(Calendar.DAY_OF_WEEK);
if(week == 1) lastdate.add(Calendar.DAY_OF_MONTH, -1);
else lastdate.add(Calendar.DAY_OF_MONTH, 7-week);
*/
Calendar lastdate = Calendar.getInstance();
lastdate.setTime(firstdate.getTime());
lastdate.add(Calendar.DAY_OF_MONTH, 41);

Calendar preMonth = Calendar.getInstance();
preMonth.setTime(selectCalendar.getTime());
preMonth.add(Calendar.MONTH, -1);
preMonth.set(Calendar.DAY_OF_MONTH, 1);

Calendar nextMonth = Calendar.getInstance();
nextMonth.setTime(selectCalendar.getTime());
nextMonth.add(Calendar.MONTH, 1);
nextMonth.set(Calendar.DAY_OF_MONTH, 1);

Map data = meetingService.getMeetingCounts(df.format(firstdate.getTime()), df.format(lastdate.getTime()), user);


List conditionList = new ArrayList();
String conditions = "(meeting.begindate >= '" + date + "' and meeting.begindate <= '" + date + "') "
	+" or (meeting.enddate >= '" + date + "' and meeting.enddate <= '" + date + "')"
	+" or (meeting.begindate <= '" + date + "' and meeting.enddate >= '" + date + "')"
	+" or ((meeting.enddate is null or meeting.enddate = '') and meeting.begindate <= '" + date + "')";

if(StringUtils.isNotEmpty(conditions)) conditionList.add("("+conditions+")");

Map pages = meetingService.getMeetingList(conditionList, 1, 10, user);

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
	<style type="text/css">
	html, body {
		font-size: 14px;
		margin: 0;
		padding: 0;
		height: 100%;
		font-family: "微软雅黑", Arial, Helvetica, sans-serif;
	}
	
	#view_header {
		width: 100%;
		height:40px;
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',endColorstr='#ececec' );
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),to(#ECECEC) );
		background: -moz-linear-gradient(top, white, #ECECEC);
		border-bottom: #CCC solid 1px;
		font-size:9pt;
		position:relative;
	}
	
	#view_title {
		color: #336699;
		font-size: 20px;
		font-weight: bold;
		text-align: center;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}
	.preMonth, .nextMonth {
		color: #D0D0D0;
	}

	table {
		font-size: 16px;
		text-align: center;
		width: 100%;
		padding: 0 5px;
		color: #6B6C6C;
		font-family: HelveticaNeue-Light;
	}

	.listdate {
		margin: 3px;
	}

	.listitem {
		position: relative;
		margin-left: 10px;
		padding: 10px 0 10px 10px;
		border-left: 1px solid #BCB8B9;
	}

	.head {
		position: fixed;
		background-color: #FFFFFF;
		width: 100%;
		z-index: 9999;
	}

	.list {
		padding: 235px 8px 0 8px;
		background-color: #EDEDED;
		height: 100%;
	}

	.today {
		border: 1px solid #287EFF;
		border-radius: 15px;
	}

	td div{
		display: inline-block;
		width: 25px;
		height: 22px;
		padding-top: 3px;
		position: relative;
	}

	.selectday {
		color: #FFFFFF;
		background-color: #287EFF;
		border-radius: 15px;
	}

	.listitem img {
		height: 16px;
		margin-left: 20px;
		margin-bottom: -2px;
	}

	.itemContent {
		background-color: #FFFFFF;
		margin-left: 16px;
		padding: 5px;
	}
	
	.itemEmpty {
		background-color: #FFFFFF;
		margin-left: 16px;
		padding: 15px;
		height: 15px;
	}

	.status {
		position: absolute;
		top: 23px;
		left: -10px;
		height: 18px;
		width: 18px;
		background-color: #BCB8B9;
		border-radius: 10px;
	}

	.sharp {
		float: left;
		width: 20px;
		height: 20px;
		margin-top: 13px;
		background-image: url("/mobile/plugin/5/images/sharp_wev8.png");
		background-repeat: no-repeat;
	}

	.alarm {
		margin-top: 5px;
		background-image: url("/mobile/plugin/5/images/alarm_wev8.png");
		background-repeat: no-repeat;
		background-size: contain;
		background-position: 20px 50%;
		padding-left: 45px;
	}

	.point {
		font-size: 25px;
		position: absolute;
		top: -5px;
		left: 0px;
		color: #287EFF;
	}

	.selectday .point {
		color: #FFFFFF !important;
	}
	
	.sTitle{
		white-space: nowrap;
		overflow: hidden;
		<%=user.getLanguage()==7||user.getLanguage()==9?"width: 100%":"" %>
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
	
	$(document).ready(function() {
		$( "#loading" ).hide();
		$( "#loadingmask" ).hide();
		
		$("#head td>div").click(function() {
			var date = $(this).attr("cal");
			location = "/mobile/plugin/5/meeting.jsp?module=<%=module%>&scope=<%=scope%>&detailid=<%=detailid%>&title=<%=titleurl%>"+"&date="+date;
		});
		
		$(".itemContent").click(function() {
			var meetingid = $(this).attr("meetingid");
			location = "/mobile/plugin/5/detail.jsp?&module=<%=module%>&scope=<%=scope %>&title=<%=titleurl%>&id="+meetingid+"&date=";
		});
		
		var startClientX = deltaSlide = 0;

		$("#head").bind('touchstart', function(event) {
			if (event.originalEvent.touches) event = event.originalEvent.touches[0];
			startClientX = event.clientX;
		});

		$("#head").bind('touchmove', function(event) {
			event.preventDefault();
			if (event.originalEvent.touches) event = event.originalEvent.touches[0];
			deltaSlide = event.clientX - startClientX;
		});

		$("#head").bind('touchend', function(event) {
			if(deltaSlide == 0) return;
			var date = "";
			if(deltaSlide > 0) date = "<%=df.format(preMonth.getTime())%>";
			if(deltaSlide < 0) date = "<%=df.format(nextMonth.getTime())%>";
			location = "/mobile/plugin/5/meeting.jsp?module=<%=module%>&scope=<%=scope%>&detailid=<%=detailid%>&title=<%=titleurl%>&date="+date;
			deltaSlide = 0;
		});
		
		if($(".head").height()>235){
			$(".list").css("padding-top",$(".head").height());
		}
	});
	</script>
</head>
<body>
	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<a href="javascript:doBack();">
			<div style="position:absolute;left:5px;top:6px;width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
			<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>
			</div>
		</a>
		<div id="view_title" style="position:absolute;left:65px;top:6px;right:65px;"><%=title %></div>
	</div>
	
	<div id="head" class="head">
		<div style="color:#287EFF;padding: 5px 0 0 10px;font-size: 15px;"><%=selectYear %>.<%=selectMonth+1 %></div>
		<table>
			<tr style="font-size: 12px;">
				<td width="14%"><div class="sTitle"><%=SystemEnv.getHtmlLabelName(398, user.getLanguage())%></div></td>
				<td width="14%"><div class="sTitle"><%=SystemEnv.getHtmlLabelName(392, user.getLanguage())%></div></td>
				<td width="14%"><div class="sTitle"><%=SystemEnv.getHtmlLabelName(393, user.getLanguage())%></div></td>
				<td width="14%"><div class="sTitle"><%=SystemEnv.getHtmlLabelName(394, user.getLanguage())%></div></td>
				<td width="14%"><div class="sTitle"><%=SystemEnv.getHtmlLabelName(395, user.getLanguage())%></div></td>
				<td width="14%"><div class="sTitle"><%=SystemEnv.getHtmlLabelName(396, user.getLanguage())%></div></td>
				<td width="14%"><div class="sTitle"><%=SystemEnv.getHtmlLabelName(397, user.getLanguage())%></div></td>
			</tr>
			<%
			Calendar curDate = firstdate;
			while(curDate.compareTo(lastdate) <= 0) {
				int curYear = curDate.get(Calendar.YEAR);
				int curMonth = curDate.get(Calendar.MONTH);
				int curDay = curDate.get(Calendar.DAY_OF_MONTH);
				int curWeek = curDate.get(Calendar.DAY_OF_WEEK);
				
				String classStr = "";
				if(selectYear==curYear && selectMonth==curMonth && selectDay==curDay) classStr += " selectday";
				if(curYear==todayYear && curMonth == todayMonth && curDay == todayDay) classStr += " today";
				if(curYear < selectYear || curMonth < selectMonth) classStr += " preMonth";
				if(curYear > selectYear || curMonth > selectMonth) classStr += " nextMonth";
				
				String curDateStr = df.format(curDate.getTime());
				Integer ci = (data==null) ? null : (Integer) data.get(curDateStr);
				int count = (ci==null) ? 0 : ci.intValue();
				
				if(curWeek == 1) {
					%><tr><%
				}
				
				%><td>
					<div class="<%=classStr%>" cal="<%=curDateStr %>"><%=curDay%>
					<%if(count > 0){%><div class="point">.</div><%}%>
					</div>
				</td><%
				
				if(curWeek == 7) {
					%></tr><%
				}
				
				curDate.add(Calendar.DAY_OF_MONTH, 1);
			}
			%>
		</table>
	</div>
	<div id="list" class="list">
		<div class="listdate"><%=selectCalendar.get(Calendar.MONTH)+1 %><%=user.getLanguage()==7||user.getLanguage()==9?"月":"-"%><%=selectCalendar.get(Calendar.DAY_OF_MONTH) %><%=user.getLanguage()==7||user.getLanguage()==9?"日":""%>  <%=weekStr[selectCalendar.get(Calendar.DAY_OF_WEEK)-1] %></div>
		<%
		if(list!=null&&list.size()>0) {
			for(int i=0;i<list.size();i++) {
				Map meeting = (Map)list.get(i);
				%>
				<div class="listitem">
					<div class="status"></div>
					<div class="sharp"></div>
					<div class="itemContent" meetingid="<%=meeting.get("id")%>">
						<div><%=meeting.get("name")%></div>
						<div class="alarm"><%=meeting.get("begintime")%></div>
					</div>
				</div>
				<%
			}
		} else {
			%>
			<div class="listitem">
				<div class="status"></div>
				<div class="sharp"></div>
				<div class="itemEmpty">
					<%=SystemEnv.getHtmlLabelName(125652, user.getLanguage())%>
				</div>
			</div>
			<%
		}
		%>
	</div>

	<div id="loading"><%=SystemEnv.getHtmlLabelName(81558, user.getLanguage())%></div>
	<div id="loadingmask" class="ui-widget-overlay"></div>
</body>
</html>