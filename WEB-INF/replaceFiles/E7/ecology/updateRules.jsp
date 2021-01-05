
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util,java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"></jsp:useBean>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"></jsp:useBean>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<%if(user!=null && "sysadmin".equals(user.getLoginid()) && "viewForbiddenDetail".equals(request.getParameter("cmd"))){%>
<script type="text/javascript">
	function allow(ip){
		if(confirm("该IP由于存在疑似攻击系统的行为而被禁止访问系统. 你确定要解封吗？")){
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
<title>xmltable-dongping </title>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<body>
<div style="height:30px;width:100%;">
	<table style="width:100%;">
		<tbody>
			<tr>
				<td>
					<div style="float:left;margin:0 10px;"><a href="/updateRules.jsp">更新缓存</a></div>
					<div style="float:left;margin:0 10px;"><a href="/updateRules.jsp?cmd=viewForbiddenDetail">查看IP封锁详情</a></div>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<%if(user!=null && "sysadmin".equals(user.getLoginid()) && "viewForbiddenDetail".equals(request.getParameter("cmd"))){%>
<form action="/updateRules.jsp?cmd=<%=xssUtil.null2String(request.getParameter("cmd"))%>" id="updateRulesForm" name="updateRulesForm" style="display:none;" method="post">
	<input type="hidden" name="cmd" id="cmd" value="<%=xssUtil.null2String(request.getParameter("cmd"))%>"/>
	<input type="hidden" name = "ip" id="ip"/>
	<input type="hidden" name = "src" id="src" value="allow"/>
</form>
<%}%>
<%
	if(user!=null && "sysadmin".equals(user.getLoginid()) && !"".equals(request.getParameter("ip"))){
		if("allow".equals(request.getParameter("src"))){
			try{
				xssUtil.getTmpForbiddenIpMap().remove(request.getParameter("ip"));
			}catch(Exception e){}
		}else if("forbidden".equals(request.getParameter("src"))){
			try{
				Map<String,String> forbiddenIp = (Map<String,String>)xssUtil.getTmpForbiddenIpMap().get(request.getParameter("ip"));
				forbiddenIp.put("status","true");
				forbiddenIp.put("type","Manager manual join");
			}catch(Exception e){}
		}
	}
	if("viewForbiddenDetail".equals(request.getParameter("cmd"))){
		if( user!=null && "sysadmin".equals(user.getLoginid())){
			Map<String,Map<String,String>> map = xssUtil.getTmpForbiddenIpMap();
			if(map==null || map.size()==0){
				out.println("No Data!");
			}else{
%>
<table border=1 style="width:100%;border-collapse:collapse;">
	<colgroup>
		<col width=10%/>
		<col width=20%/>
		<col width=10%/>
		<col width=10%/>
		<col width=20%/>
		<col width=20%/>
		<col width=10%/>
	</colgroup>
	<thead>
		<th>攻击源IP</th>
		<th>攻击对象</th>
		<th>攻击类型</th>
		<th>攻击次数</th>
		<th>攻击时间</th>
		<th>使用账号</th>
		<th>操作</th>
	</thead>
	<tbody>
<%
				java.util.Iterator it = map.entrySet().iterator();
				while(it.hasNext()){
					java.util.Map.Entry entry = (java.util.Map.Entry)it.next();
					Map<String,String> ipMap = (Map<String,String>)entry.getValue();
					String time = "";
					try{
						time = xssUtil.getTimeString(new Date(Long.parseLong(ipMap.get("interceptTime"))));
					}catch(Exception e){}
%>
		<tr>
			<td style="text-align:center;"><%=ipMap.get("ip")%></td>
			<td style="text-align:center;"><%=ipMap.get("path")%></td>
			<td style="text-align:center;"><%=ipMap.get("type")%></td>
			<td style="text-align:center;"><div style="<%=xssUtil.getIntValue(ipMap.get("count"),0)>=xssUtil.getForbiddenCount()?"color:red;":"color:#000;"%>"><%=ipMap.get("count")%></div></td>
			<td style="text-align:center;"><%=time%></td>
			<td style="text-align:center;"><%=ipMap.get("lastname")%></td>
			<%if("true".equals(ipMap.get("status"))){%>
				<td style="text-align:center;"><div style="cursor:pointer;background-color:red;" onclick="allow('<%=ipMap.get("ip")%>');">解封</div></td>
			<%}else{%>
				<td style="text-align:center;"><div style="cursor:pointer;background-color:green;" onclick="forbidden('<%=ipMap.get("ip")%>');">禁止</div></td>
			<%}%>
		</tr>
<%
				}
			}
%>
	</tbody>
</table>
<%
		}else{
			out.println("You have no right to view.");
		}
		return;
	}

	
	if("detail".equals(request.getParameter("cmd"))){
		try{
			out.println(xssUtil.getIsParamKeyCheck());
			out.println(xssUtil.getParamKeyRule());
		}catch(Exception e){}
		try{
			out.println("paramsCache size::"+xssUtil.getParamsMap().toString().length());
		}catch(Exception e){}
		out.println("<br/><br/>paramsMap::<br/>");
		try{
			out.println(xssUtil.getParamsMap().toString());
		}catch(Exception e){}
		out.println("<br/><br/>forbiddenUrlList::<br/>");
		try{
			out.println(xssUtil.getForbiddenUrlList().toString());
		}catch(Exception e){}
		out.println("<br/><br/>encList:<br/>");
		try{
			out.println(xssUtil.getEncList().toString());
		}catch(Exception e){}
		out.println("<br/><br/>refList:<br/>");
		try{
			out.println(xssUtil.getRefList().toString());
		}catch(Exception e){}
		out.println("<br/><br/>enable webservice check:<br/>");
		try{
			out.println(xssUtil.getEnableWebserviceCheck());
		}catch(Exception e){}
		out.println("<br/><br/>webserviceList:<br/>");
		try{
			out.println(xssUtil.getWebserviceList().toString());
		}catch(Exception e){}
		out.println("<br/><br/>webserviceIpList:<br/>");
		try{
			out.println(xssUtil.getWebserviceIpList().toString());
		}catch(Exception e){}
		out.println("<br/><br/>isSkipHost::"+xssUtil.getIsSkipHost()+"---->hostList:<br/>");
		try{
			out.println(xssUtil.getHostList().toString());
		}catch(Exception e){}
		out.println("<br/><br/>exceptList:<br/>");
		try{
			out.println(xssUtil.getExceptList().toString());
		}catch(Exception e){}
		out.println("<br/><br/>mustXss:<br/>");
		out.println(xssUtil.getMustXss());
		out.println("<br/><br/>xssList:<br/>");
		try{
			out.println(xssUtil.getXssList().toString());
		}catch(Exception e){}
		out.println("<br/><br/>isSkipRule::"+xssUtil.getIsSkipRule()+"---->rules:<br/>");
		try{
			out.println(xssUtil.getRule().toString());
		}catch(Exception e){}
	}else{
		xssUtil.initRules(true);
	}
	out.println("complete...");
%>
</body>
</html>
