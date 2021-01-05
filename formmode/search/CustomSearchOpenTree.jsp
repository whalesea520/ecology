<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.formmode.tree.CustomTreeData" %>
<jsp:useBean id="CustomTreeUtil" class="weaver.formmode.tree.CustomTreeUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.general.Util"%>
<%
	int mainid = Util.getIntValue(Util.null2String(request.getParameter("mainid")),0);
	String pid = Util.null2String(request.getParameter("pid"));
	String pids[] = pid.split(CustomTreeData.Separator);
	String customdetailid = pids[0];
	String supid = pids[1];
	String sql = "select mainid from mode_customtreedetail where id="+customdetailid;
	rs.executeSql(sql);
	while(rs.next()){
		mainid = Util.getIntValue(rs.getString("mainid"),0);
	}
	String href = CustomTreeUtil.getRelateHrefAddress(mainid,customdetailid,supid);
	if(!href.equals("")){
		if(href.indexOf("?")==-1){
			href = href+"?isfromsearchtree=1&mainid="+mainid+"&pid="+pid;
		}else{
			href = href+"&isfromsearchtree=1&mainid="+mainid+"&pid="+pid;
		}
	}else{
		href = "/formmode/tree/nofound.jsp";
	}
	response.sendRedirect(href);
%>