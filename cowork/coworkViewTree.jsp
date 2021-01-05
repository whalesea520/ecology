
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	CoworkDAO coworkdao=new CoworkDAO();
	
	String menuType = Util.null2String(request.getParameter("menuType"));
	
	String main = "main";
	String sub = "sub";
	if("themeApproval".equals(menuType)){
		main = "themeApprovalMain";
		sub = "themeApprovalSub";
	}
	
	if("contentApproval".equals(menuType)){
		main = "contentApproveMain";
		sub = "contentApproveSub";
	}
	if("themeMonitor".equals(menuType)){
		main = "nameMonitorMain";
		sub = "nameMonitorSub";
	}
	if("contentMonitor".equals(menuType)){
		main = "discussMonitorMain";
		sub = "discussMonitorSub";
	}
	
	Map mainTotal=coworkdao.getCoworkCount(user,main);
	Map subTotal=coworkdao.getCoworkCount(user,sub);
	String leftMenus="";
	String sql="select * from cowork_maintypes ORDER BY id asc";
	RecordSet.execute(sql);
	while(RecordSet.next()){
		String mainTypeId=RecordSet.getString("id");
		String mainTypeName=RecordSet.getString("typename");
		String mainflowAll=mainTotal.containsKey(mainTypeId)?(String)mainTotal.get(mainTypeId):"0";
		
		String submenus="";           
		sql="SELECT * from cowork_types where departmentid="+mainTypeId+" ORDER BY id asc";
		rs.execute(sql);
		while(rs.next()){
			String subTypeId=rs.getString("id");
			String subTypeName=rs.getString("typename");
			String subflowAll=subTotal.containsKey(subTypeId)?(String)subTotal.get(subTypeId):"0";
			submenus+=",{name:'"+subTypeName+"',"+
						 "attr:{subTypeId:'"+subTypeId+"',parentid:'"+mainTypeId+"'},"+
						 "numbers:{flowAll:"+subflowAll+"}"+
           				"}";
		}
		submenus=submenus.length()>0?submenus.substring(1):submenus;
		submenus="["+submenus+"]";
		String info = rs.getCounts()!=0?"":"hasChildren:false,";
		leftMenus+=",{"+
					 "name:'"+mainTypeName+"',"+info+
					 "attr:{mainTypeId:'"+mainTypeId+"'},"+
					 "numbers:{flowAll:"+mainflowAll+"},"+
					 "submenus:"+submenus+
		 		   "}";
	}
	leftMenus=leftMenus.length()>0?leftMenus.substring(1):leftMenus;
	leftMenus="["+leftMenus+"]";
	out.print(leftMenus);
%>