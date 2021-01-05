
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rset" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String mailid = Util.null2String(request.getParameter("mailId"),"");
String taget = Util.null2String(request.getParameter("taget"),"");
String waitdeal = Util.null2String(request.getParameter("waitdeal"),"");
String waitdealtime = Util.null2String(request.getParameter("waitdealtime"),"");
String waitdealnote = Util.null2String(request.getParameter("waitdealnote"),"");
String waitdealway = Util.null2String(request.getParameter("waitdealway"),"");
String wdremindtime = Util.null2String(request.getParameter("wdremindtime"),"");
User user = HrmUserVarify.getUser (request , response) ;
	rs.execute(" select waitdeal, waitdealtime, waitdealnote, waitdealway, wdremindtime from MailResource where id = " + mailid);
	while(rs.next()) {
		waitdeal = rs.getString("waitdeal");
		waitdealtime = rs.getString("waitdealtime");
		waitdealnote = rs.getString("waitdealnote");
		waitdealway = rs.getString("waitdealway");
		wdremindtime = rs.getString("wdremindtime");
	}

%>

<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<style>
.imgClass{
	background-color: white;
	margin-left: 0px;
}
</style>

<script type="text/javascript">

	function saveInfo(){
		 $('#waitdealid').val('0');
		 $('#mailid').val('<%=mailid %>');
		 $.post("/email/MailWaitdealOperation.jsp",$("form").serialize(),function(){
		 		$('.nameInfo').qtip('hide');
		 		$('#nameInfo<%=mailid %>').hide();
		 		mailUnreadUpdate();    //更新未读数
		 		if("mailview" != '<%=taget%>')
		 			completeDeal();
		 });	
	}
	
	function completeDeal() {
		    loadMailListContent($("index").val());
	}
	
	function updateWaitDeal(type) {
		var title="<%=SystemEnv.getHtmlLabelName(83114,user.getLanguage())%>";
	    diag=getMailWaitDealDialog(title,400,500);
		diag.URL = "/email/new/MailWaitDeal.jsp?mailids="+<%=mailid %>+"&type="+type;
		diag.show();
		if("mailview" != '<%=taget%>')
			loadMailListContent($("index").val());
		else {
			$('.nameInfo').qtip("destroy");
			initwaitdeal();
		}
		$('.nameInfo').qtip('hide');
		
	}
	
	function refreshLoad(waitdealtime, waitdealway, waitdealnote, wdremindtime) {
		$('.nameInfo').qtip('hide');
		if(diag){
			diag.close();
		}
		return;
		
		
		var waitdealarr = ["短信","微信","推送到手机","message"];
	
		$('#wdtimespan').html(waitdealtime);
		if(waitdealnote != "" && waitdealnote != null) {
			var waitdealhtml = "已添加：";
			var arr = waitdealway.split(',');
			for(var i=0; i<arr.length; i++) {
				waitdealhtml += arr[i] + ',';
			}
			waitdealhtml.substring(0, arr.length -1);
			waitdealhtml += ', '+ wdremindtime + ' 处理';
			$('#waitdealdiv').html(waitdealhtml);
		}else {
			$('#waitdealdiv').html("<a href='javascript:updateWaitDeal(1)' style='color:#FF8000'>添加提醒</a>");
		}
		if(waitdealway != "" && waitdealway != null) {
			$('#waitdealdiv').html(waitdealnote+"&nbsp&nbsp&nbsp<a href='javascript:updateWaitDeal(2)' style='color:#FF8000'>修改备注</a>");
		}else {
			$('#waitdealdiv').html("<a href='javascript:updateWaitDeal(2)' style='color:#FF8000'>添加备注</a>");
		}
		
	}
	
</script>
</head>



<%
%>
<body>
<form method="post" action="/email/MailWaitdealOperation.jsp" name="weaver">
<input type="hidden" id="Operation" name="Operation" value="update">
<input type="hidden" id="waitdealid" name="waitdealid" value="<%=waitdeal%>">
<input type="hidden" id="iswaitdealway" name="iswaitdealway" value="1">
<input type="hidden" id="iswaitdealnote" name="iswaitdealnote" value="1">
<input type="hidden" id="mailid" name="mailid" value="<%=mailid %>">
<table>
	<tr style="height:30px">
		<td style="width: 60px;" ><img style="margin-left: 20px;" src='/email/images/mail_wait_deal_wev8.png'     /></td>
		<td style="width:320px">
			<div style="float:left;display:inline-block;margin-top:4px">
				<%=SystemEnv.getHtmlLabelName(83134,user.getLanguage())%>，<span id='wdtimespan'><%=waitdealtime %></span><%=SystemEnv.getHtmlLabelName(553,user.getLanguage())%><a href="javascript:updateWaitDeal(0)" style="color:#FF8000;margin-left: 20px;"><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%></a>
		     	<input class="e8_btn_top middle" onclick="saveInfo()" style="margin-left: 40px;" type="button" value="<%=SystemEnv.getHtmlLabelName(83112,user.getLanguage())%>"/>
		 	</div>
		 </td>
	</tr>
	<tr style="height:30px">
		<td></td>
		<td>
			<div id='waitdealdiv' style="width:350px;word-break:break-all">
			<%if("".equals(wdremindtime)) {%>
				<a href="javascript:updateWaitDeal(1)" style="color:#FF8000"><%=SystemEnv.getHtmlLabelName(83135,user.getLanguage())%></a>
			<%} else{ 
				rs2.execute(" select id, name, content,labelid from MailReceiveRemind where enable = 1 ");
				Map<String, String> map = new HashMap<String, String>();
				while(rs2.next()) {
					map.put(rs2.getString("id"), SystemEnv.getHtmlLabelName(rs2.getInt("labelid"),user.getLanguage()));
				}
				
				String[] wayarr = waitdealway.split(",");
				String outremind = SystemEnv.getHtmlLabelName(33974,user.getLanguage())+"：";
				for(int i=0; i<wayarr.length; i++) {
					outremind += map.get(wayarr[i]) + ",";
				}
				outremind = outremind.substring(0, outremind.length()-1);
				outremind += SystemEnv.getHtmlLabelName(15148,user.getLanguage())+"，&nbsp"+wdremindtime+"&nbsp"+SystemEnv.getHtmlLabelName(553,user.getLanguage());
				out.print(outremind);
			}%>
			</div>
		</td>
	</tr>
	<tr style="height:30px">
		<td></td>
		<td>
			<div id='waitnotediv' style="width:350px;word-break:break-all">
			<%if("".equals(waitdealnote)) {%>
				<a href="javascript:updateWaitDeal(2)" style="color:#FF8000"><%=SystemEnv.getHtmlLabelName(83136,user.getLanguage()) %></a>
			<% }else {%>
			   <%=waitdealnote %>&nbsp&nbsp&nbsp<a href="javascript:updateWaitDeal(2)" style="color:#FF8000"><%=SystemEnv.getHtmlLabelName(83137,user.getLanguage()) %></a>
			<%}%>
			</div>
		</td>
	</tr>
</table>
</form>
</body>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>

