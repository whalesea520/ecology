
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.hrm.appdetach.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<%
	String subid = Util.null2String(request.getParameter("subid"));
	String departid = Util.null2String(request.getParameter("departid"));
	String keyword = Util.null2String(request.getParameter("keyword"));
	String sqlStr ="";
	String whereSql = "where status in (0,1,2,3)";
	if(!subid.equals("")){
		whereSql += " and subcompanyid1='"+subid+"'";
	}
	if(!departid.equals("")){
		whereSql += " and departmentid='"+departid+"'";
	}
	
	if(!keyword.equals("")){
		keyword = keyword.toLowerCase();
		whereSql +=" and (lastname like '%"+keyword+"%' or pinyinlastname like '%"+keyword+"%')" ;
	}
	
	sqlStr = "select * from hrmresource "+whereSql;
	
	AppDetachComInfo adci = new AppDetachComInfo();
      String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"");
      String tempstr= (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
      sqlStr=sqlStr+tempstr;
      
	if(rs.getDBType().equals("oracle")){
		//sqlStr = "select * from hrmresource "+whereSql+" order by substr(pinyinlastname,1,1),lastname";
		sqlStr = sqlStr+" order by substr(pinyinlastname,1,1),lastname";
	}else{
		//sqlStr = "select * from hrmresource "+whereSql+" order by SUBSTRING(pinyinlastname,1,1),lastname";
		sqlStr = sqlStr+" order by SUBSTRING(pinyinlastname,1,1),lastname";
	}
	
	rs.execute(sqlStr);
	
	String flag = "";
	
%>

<% while(rs.next()){
	
	String tmp = rs.getString("pinyinlastname");
	if(!tmp.equals("")){
		tmp = rs.getString("pinyinlastname").substring(0,1);
	}else{
    tmp =" ";
  }
	if(flag.equals(tmp)){
		%>
		<li id="li_<%=rs.getString("id") %>" style="height:auto;"><a href="javascript:loadHrmInfo('<%=rs.getString("id") %>','<%=flag.toUpperCase() %>')" style='position:relative'><em class="cBlue2"><%=rs.getString("lastname") %></em>(<%=SubCompanyComInfo.getSubCompanyname(rs.getString("subcompanyid1")) %>-<%=DepartmentComInfo.getDepartmentname(rs.getString("departmentid")) %>)</a></li>
		<%
	}else{
		if(!flag.equals("")){
			%>
			</ul>
			</div>
			<%
		}
		flag = tmp;
		%>
		
		<div class="ContactsBox2" id="ContactsBox_<%=flag.toUpperCase()%>">
		<span style="font-family: Arial !important;" class="cBlack3 FB"><%=flag.toUpperCase() %></span>
		<ul>
		<li id="li_<%=rs.getString("id") %>" style="height:auto;"><a href="javascript:loadHrmInfo('<%=rs.getString("id") %>','<%=flag.toUpperCase() %>')"><em class="cBlue2"><%=rs.getString("lastname") %></em>(<%=SubCompanyComInfo.getSubCompanyname(rs.getString("subcompanyid1")) %>-<%=DepartmentComInfo.getDepartmentname(rs.getString("departmentid")) %>)</a></li>
		<%
		
	}
	
	%>
<%} %>
<%if(rs.getCounts()>0){ %>
</ul>
</div>
<%}%>

