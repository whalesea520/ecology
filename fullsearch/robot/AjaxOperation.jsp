<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.net.URLEncoder"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String robotid=Util.null2String(request.getParameter("robotid"));
String key=Util.null2String(request.getParameter("key"));
rs.execute("select * from FullSearch_Robot where state=0 and id="+robotid);
if(rs.next()){
	if("1".equals(rs.getString("showDiv"))){
		String div=rs.getString("iframeUrl");
		if(!"".equals(div)){
			int w=Util.getIntValue(rs.getString("width"),600);
			int h=Util.getIntValue(rs.getString("height"),300);
			if(!"".equals(key)){
				if(div.indexOf("?")>-1){
					div+="&key="+URLEncoder.encode(key,"UTF-8");
				}else{
					div+="?key="+URLEncoder.encode(key,"UTF-8");
				}
			}
%>
<div id="<%="ROBOT"+robotid %>"  class="robotDiv">
	<iframe name="<%="ROBOT"+robotid+"Ifrm" %>" id=name="<%="ROBOT"+robotid+"Ifrm" %>" allowtransparency="true"  frameborder="0" <%=w>0?"width='"+w+"'":"style='width:100%'" %> height="<%=h %>" scrolling="no" src="<%=div %>"></iframe>
</div>
<%		}else{
			out.print("0");
			return;
		}	
	}else{//无变化
		out.print("1");
		return;
	}
}else{//
	out.print("0");
	return;
}


%>