<%@page import="weaver.conn.RecordSetDataSource"%>
<%@page import="weaver.common.util.string.StringUtil"%>
<%@page import="java.util.Map"%>
<%@page import="weaver.general.*"%>
<%@page import="weaver.systeminfo.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean   id="xssUtil" class="weaver.filter.XssUtil" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String groupid=Util.null2String(request.getParameter("groupid"));
String customid=Util.null2String(request.getParameter("customid"));
String url=Util.null2String(request.getParameter("url"));
String customDesc=Util.null2String(request.getParameter("customDesc"));
String groupname=Util.null2String(request.getParameter("groupname"));
String fieldhtmltype=Util.null2String(request.getParameter("fieldhtmltype"));
boolean isVirtualForm=Util.str2bool(request.getParameter("isVirtualForm"));
String vdatasource = Util.null2String(request.getParameter("vdatasource"));
int selectitemid=Util.getIntValue(request.getParameter("selectitemid"),0);
int level=selectitemid=Util.getIntValue(request.getParameter("level"),1);
Map groupmap = new HashMap();
String groupsql = session.getAttribute("groupsql_"+customid).toString();
int sumvalue = 0;
if(isVirtualForm){
	RecordSetDataSource rsd = new RecordSetDataSource(vdatasource);
	rsd.executeSql(groupsql);
	while(rsd.next()){
		String key = Util.null2String(rsd.getString(groupname));
		int value = Util.getIntValue(rsd.getString("count"),0);
		groupmap.put(key, value);
		sumvalue +=value;
	}
	groupmap.put("sum", sumvalue);
}else{
	rs.executeSql(groupsql);
	while(rs.next()){
		String key = Util.null2String(rs.getString(groupname));
		int value = Util.getIntValue(rs.getString("count"),0);
		groupmap.put(key, value);
		sumvalue +=value;
	}
	groupmap.put("sum", sumvalue);
}
%>



<%if("0".equals(groupid)) {%>
<li class="current">
	<a href="<%=url %>" target="tabcontentframe" class="a_tabcontentframe">
	<%if(!"".equals(customDesc)){%>
		<%=StringUtil.Html2Text(customDesc).length()>60?StringUtil.Html2Text(customDesc).substring(0, 60) + "...":StringUtil.Html2Text(customDesc)%>
	<%}else{ %>
		<!-- <%=SystemEnv.getHtmlLabelName(81984,user.getLanguage())%> --><!-- 自定义查询列表 -->
	<%}%>
	</a>
</li>
<%}else {%>
	 <li class="current">
		<a href="<%=url %>" target="tabcontentframe">
		<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%><!-- 全部 -->(<%=groupmap.get("sum").toString()%>)
		</a>
	</li>
	<%	
		String sql = "";
		if(fieldhtmltype.equals("5")){
			sql = "select * from workflow_SelectItem where fieldid="+groupid+" and (cancel<>1 or cancel is null) order by listorder";
		}else{
			 sql = "select name as selectname,id as selectvalue from mode_selectitempagedetail where mainid="+selectitemid+" and statelev="+level+" and (cancel=0 or cancel is null) order by disorder asc,id asc";
		}
		rs.executeSql(sql);
		while(rs.next()){
			String selname = Util.null2String(rs.getString("selectname"));
			String selvalue = Util.null2String(rs.getString("selectvalue"));
			String tempurl = url+"&groupby="+xssUtil.put(groupname+"$"+selvalue);			
			String selsumvalue = "0";
			if(groupmap.get(selvalue)!=null){
				selsumvalue = groupmap.get(selvalue).toString();
			}
		%>
		<li>
			<a href="<%=tempurl%>" target="tabcontentframe">
				<%=selname%>(<%=selsumvalue%>)
			</a>
		</li>
	<%}if(groupmap.get("")!=null){%>
	<li>
		<a href="<%=url+"&groupby="+xssUtil.put(groupname+"$-1") %>" target="tabcontentframe">
		<%=SystemEnv.getHtmlLabelName(81985,user.getLanguage())%><!-- 空值 -->(<%=groupmap.get("").toString()%>)
		</a>
	</li>
	<%}
}%>