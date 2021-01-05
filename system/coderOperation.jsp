<%@page import="weaver.conn.RecordSetTrans"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<%
  String method=  Util.null2String(request.getParameter("method"));
  String codemainid=  Util.null2String(request.getParameter("codemainid"));
  String postValue=  Util.null2String(request.getParameter("postValue"));
  int txtUserUse=  Util.getIntValue(request.getParameter("txtUserUse"),0);
  if ("update".equals(method)) {
	//tagtag改用事务
	RecordSetTrans rs=new RecordSetTrans();
	rs.setAutoCommit(false);
	try{
		synchronized(this){
			rs.executeSql("update codemain set isuse="+txtUserUse);
		    rs.executeSql("delete codedetail where codemainid="+codemainid);
		    String[] members = Util.TokenizerString2(postValue,"\u0007");
		    for (int i=0;i<members.length;i++){
		      String member = members[i];
		      String memberAttibutes[] = Util.TokenizerString2(member,"\u001b");
		      String text = memberAttibutes[0];
		      String value = memberAttibutes[1];
		      if ("[(*_*)]".equals(value)){value="";}
		      String type = memberAttibutes[2];

		      String insertStr = "insert into codedetail (codemainid,showname,showtype,value,codeorder) values ("+codemainid+",'"+text+"','"+type+"','"+value+"',"+i+")";   
		      rs.executeSql(insertStr);          
		    }
			
			rs.commit();
		}
		
	}catch(Exception e){
		rs.rollback();
	}
    
    response.sendRedirect("codeMaint.jsp?codemainid="+codemainid);
  }
%>


