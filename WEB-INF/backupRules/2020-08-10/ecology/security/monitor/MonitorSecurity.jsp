
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,weaver.hrm.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"></jsp:useBean>
<jsp:useBean id="sc" class="weaver.security.core.SecurityCore"></jsp:useBean>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<style type="text/css">
		*{
			font-family: 微软雅黑; 
			mso-hansi-font-family: 微软雅黑
		}
		.listTable{
			width:100%;
			border:1px solid #dcdcdc;
			border-collapse:collapse;
		}
		.listTable th{
			height:40px;
			background-color:#f0f3f4;
		}
		.listTable th, .listTable td{
			border:1px solid #dcdcdc;
			font-size:12px;
			color:#384049;
		}
		.listTable td{
			height:50px;
			text-align:center;
		}
	</style>
<%
	User user = HrmUserVarify.getUser (request , response) ;
		if(user == null)  {
			response.sendRedirect("/login/Login.jsp");
			return;
		} ;
	int UID = xssUtil.getIntValue(""+xssUtil.getRule().get("userID"),1);
		if (user.getUID()!=UID)
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
%>
<%
	if(user!=null && user.getUID()==UID && "viewForbiddenDetail".equals(request.getParameter("cmd"))){
%>
<script type="text/javascript">
	function allow(ip){
		if(confirm("该IP由于存在疑似可疑系统的行为而被禁止访问系统. 你确定要解封吗？")){
			document.getElementById("ip").value=ip;
			document.getElementById("src").value="allow";
			document.getElementById("updateRulesForm").submit();
		}
	}

	function forbidden(ip){
		if(confirm("禁止后，该IP将无法访问系统。你确定要加入禁止该IP吗？")){
			document.getElementById("ip").value=ip;
			document.getElementById("src").value="forbidden";
			document.getElementById("updateRulesForm").submit();
		}
	}
</script>
<%}%>
<title>安全监控</title>
<script type="text/javascript">
	function checkDone(obj){
		location.href="MonitorSecurity.jsp?cmd=viewForbiddenDetail";
	}
</script>
</head>

<body>
<div style="margin-left:auto;margin-right:auto;width:80%;margin-top:36px;min-height:400px;text-align:center;">
	<div style="height:52px;border-bottom:1px solid #dcdcdc;">
		<span onclick="javacript:checkDone(this);" style="display:inline-block;height:32px;width:82px;cursor:pointer;background-color:#52be7f;color:white;line-height:32px;">刷新</span>
	</div>
	<%if(user!=null && "viewForbiddenDetail".equals(request.getParameter("cmd"))){%>
	<form action="MonitorSecurity.jsp?cmd=<%=xssUtil.null2String(request.getParameter("cmd"))%>" id="updateRulesForm" name="updateRulesForm" style="display:none;" method="post">
		<input type="hidden" name="cmd" id="cmd" value="<%=xssUtil.null2String(request.getParameter("cmd"))%>"/>
		<input type="hidden" name = "ip" id="ip"/>
		<input type="hidden" name = "src" id="src" value="allow"/>
	</form>
	<%}%>
	<%
		if(user!=null && !"".equals(request.getParameter("ip"))){
			if("allow".equals(request.getParameter("src"))){
				try{
					//xssUtil.getTmpForbiddenIpMap().remove(request.getParameter("ip"));
					Map forbiddenIp = (Map)xssUtil.getTmpForbiddenIpMap().get(request.getParameter("ip"));
					forbiddenIp.put("status","false");
					forbiddenIp.put("type","Manager manual allow");
				}catch(Exception e){}
			}else if("forbidden".equals(request.getParameter("src"))){
				try{
					Map forbiddenIp = (Map)xssUtil.getTmpForbiddenIpMap().get(request.getParameter("ip"));
					forbiddenIp.put("status","true");
					forbiddenIp.put("type","Manager manual join");
				}catch(Exception e){}
			}
		}
		if("viewForbiddenDetail".equals(request.getParameter("cmd"))){
			if( user!=null ){
				Map map = xssUtil.getTmpForbiddenIpMap();
				if(map==null || map.size()==0){
					out.println("<div style='line-height:400px;color:#384049'>未监测到可疑信息!</div>");
				}else{
	%>
	<div style="margin-top:20px;max-height:600px;overflow:auto;">
		<table class="listTable">
			<colgroup>
				<col width=20%/>
				<!--<col width=20%/>
				<col width=10%/>-->
				<col width=10%/>
				<col width=30%/>
				<col width=20%/>
				<col width=20%/>
			</colgroup>
			<thead>
				<th>可疑源IP</th>
				<!--<th>可疑对象</th>
				<th>可疑类型</th>-->
				<th>可疑次数</th>
				<th>可疑时间</th>
				<th>使用账号</th>
				<th>操作</th>
			</thead>
			<tbody>
		<%
						java.util.Iterator it = map.entrySet().iterator();
						while(it.hasNext()){
							java.util.Map.Entry entry = (java.util.Map.Entry)it.next();
							Map ipMap = (Map)entry.getValue();
							String time = "";
							try{
								time = xssUtil.getTimeString(new Date(Long.parseLong(""+ipMap.get("interceptTime"))));
							}catch(Exception e){}
		%>
				<tr>
					<td style="text-align:center;"><span style="padding-left:2px;padding-right:2px;padding-top:1px;padding-bottom:1px;<%="true".equals(ipMap.get("status"))?"background-color:#f05757;color:white;":""%>"><%=ipMap.get("ip")%></span></td>
					<!--<td style="text-align:center;"><%=ipMap.get("path")%></td>
					<td style="text-align:center;"><%=ipMap.get("type")%></td>-->
					<td style="text-align:center;"><div style="text-align:center;<%=xssUtil.getIntValue(""+ipMap.get("count"),0)>=xssUtil.getForbiddenCount()?"color:#f25f1e;":""%>"><%=ipMap.get("count")%></div></td>
					<td style="text-align:center;"><%=time%></td>
					<td style="text-align:center;"><%=ipMap.get("lastname")%></td>
					<%if("true".equals(""+ipMap.get("status"))){%>
						<td style="text-align:center;"><div style="margin-left:auto;margin-right:auto;text-align:center;cursor:pointer;color:#f25f1e;width:54px;height:26px;line-height:26px;border:1px solid #d6d6d6;" onclick="allow('<%=ipMap.get("ip")%>');">解封</div></td>
					<%}else{%>
						<td style="text-align:center;"><div style="margin-left:auto;margin-right:auto;text-align:center;cursor:pointer;border:1px solid #d6d6d6;color:#2c91e6;width:54px;height:26px;line-height:26px;" onclick="forbidden('<%=ipMap.get("ip")%>');">禁止</div></td>
					<%}%>
				</tr>
		<%
						}
					}
		%>
			</tbody>
		</table>
	</div>
	<%
			}else{
				response.sendRedirect("/notice/noright.jsp");
			}
			return;
		}
	%>
</div>
</body>
</html>
