
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cs" class="weaver.conn.ConnStatement" scope="page" />
<%

String method = Util.null2String(request.getParameter("method"));
//需要删除的人员维护信息id
String delids = Util.null2String(request.getParameter("delids"));
String matrixid = Util.null2String(request.getParameter("matrixid"));
//新添加的人员维护信息ids
String newids = Util.null2String(request.getParameter("relatedshareid")); 
//类型：包括 角色 和 人力资源
String type = Util.null2String(request.getParameter("type")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));

String userid = "0" ;
String roleid = "0" ;

if(!HrmUserVarify.checkUserRight("Matrix:Maint", user)){
	response.sendRedirect("/notice/noright.jsp");
	return  ;
}


boolean isOracle = RecordSet.getDBType().equals("oracle");
int maxid = 0;
if(method.equals("add"))
{
	ArrayList objnames = Util.TokenizerString(newids,",");
   	if(objnames!=null){
   		for(int i=0;i<objnames.size();i++){
   			String tmpid = ""+objnames.get(i);
   			
   			userid = "0";
   			roleid = "0";
   			if(type.equals("1")){
   				userid = tmpid;
   				seclevel = "0";
   			}
   			if(type.equals("4")) roleid = newids ;
            if(isOracle) {
            	
            	cs.setStatementSql("select max(id) as id from MatrixMaintInfo");
    		    cs.executeQuery();
    		    while(cs.next()) {
    		    	maxid = Util.getIntValue(cs.getString("id"),0) ;
    		    }
    		    maxid ++;
        		RecordSet.executeSql("insert into MatrixMaintInfo (id,matrixid,type,resourceid,subcompanyid,departmentid,roleid,seclevel,rolelevel,foralluser)"+ 
        		" values ("+maxid+","+matrixid+","+type+","+userid+",0,0,"+roleid+","+seclevel+","+rolelevel+",0)");
        	}else{
        		RecordSet.executeSql("insert into MatrixMaintInfo (matrixid,type,resourceid,subcompanyid,departmentid,roleid,seclevel,rolelevel,foralluser)"+ 
                		" values ("+matrixid+","+type+","+userid+",0,0,"+roleid+","+seclevel+","+rolelevel+",0)");
        	}
   		}
	}
}

if(method.equals("delete") && !"".equals(delids)){
	String votingshareids[]=delids.split(",");
	for(int i=0;i<votingshareids.length;i++) {
		if(votingshareids[i] !=null && !"".equals(votingshareids[i])){
			RecordSet.executeSql("delete from MatrixMaintInfo where id="+votingshareids[i]);
		}
	}
}
%>

<% out.println("<script>parent.getParentWindow(window).MainCallback();</script>"); %>
