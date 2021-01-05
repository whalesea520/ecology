
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

char flag=Util.getSeparator();
String sql = "";
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String wtid = Util.null2String(request.getParameter("wtid")); 

if("delCreator".equals(method)){
	String ids = Util.null2String(request.getParameter("ids"));	
	if(!"".equals(ids))
		rs.executeSql("delete from worktaskcreateshare where id in("+ids+"0)");
	    //System.out.println("delete from worktaskcreateshare where id in("+ids+"0)");
        //out.print("SUCCESS");
}else if("addCreator".equals(method)){
	String subids = Util.null2String(request.getParameter("subids"));
	String depids = Util.null2String(request.getParameter("departmentid"));
	String roleid = Util.null2String(request.getParameter("roleid"));
	String userids = Util.null2String(request.getParameter("userid")); 
	
	String rolelevel = Util.null2String(request.getParameter("rolelevel"));
	String seclevel = Util.null2String(request.getParameter("seclevel"));
	String sharetype = Util.null2String(request.getParameter("sharetype"));
	//System.out.println("sharetype======================"+sharetype);
	if("2".equals(sharetype)){//分部 
		String[] ids = Util.TokenizerStringNew(subids,",");
		for (int i=0;i<ids.length;i++){
			rs.executeSql("select 1 from worktaskcreateshare where sharetype=2 and taskid="+wtid+" and subcompanyid="+ids[i]);
			if(rs.next()){
				rs.executeSql("update worktaskcreateshare set subcompanyid="+ids[i]+",seclevel="+seclevel+" where sharetype=2 and taskid="+wtid+" and subcompanyid="+ids[i]);
			}else{
				rs.executeSql("insert into worktaskcreateshare(taskid,subcompanyid,seclevel,sharetype)"+ 
				" values("+wtid+","+ids[i]+","+seclevel+",2)");
			}
		}
	}else if("3".equals(sharetype)){//部门 3
		String[] ids = Util.TokenizerStringNew(depids,",");
		for (int i=0;i<ids.length;i++){
			rs.executeSql("select 1 from worktaskcreateshare where sharetype=3 and taskid="+wtid+" and departmentid="+ids[i]);
			if(rs.next()){
				rs.executeSql("update worktaskcreateshare set seclevel="+seclevel+" where sharetype=3 and taskid="+wtid+" and departmentid="+ids[i]);
			}else{
				rs.executeSql("insert into worktaskcreateshare(taskid,departmentid,seclevel,sharetype)"+ 
				" values("+wtid+","+ids[i]+","+seclevel+",3)");
			}
		}
	}else if("4".equals(sharetype)){//角色 4
		rs.executeSql("select 1 from worktaskcreateshare where sharetype=4 and taskid="+wtid+" and roleid="+roleid);
		if(rs.next()){
			rs.executeSql("update worktaskcreateshare set rolelevel="+rolelevel+",seclevel="+seclevel+" where sharetype=4 and taskid="+wtid+" and roleid="+roleid);
		}else{
			rs.executeSql("insert into worktaskcreateshare(taskid,roleid,rolelevel,seclevel,sharetype)"+ 
			" values("+wtid+","+roleid+","+rolelevel+","+seclevel+",4)");
		}
	}else if("5".equals(sharetype)){//安全级别 3
		rs.executeSql("select 1 from worktaskcreateshare where sharetype=5 and foralluser=1 and taskid="+wtid);
		if(rs.next()){
			rs.executeSql("update worktaskcreateshare set seclevel="+seclevel+" where sharetype=5 and taskid="+wtid);
		}else{
			rs.executeSql("insert into worktaskcreateshare(taskid,seclevel,sharetype,foralluser)"+ 
			" values("+wtid+","+seclevel+",5,1)");
		}
	}else if ("1".equals(sharetype)) {//人员 5       
		String[] ids = Util.TokenizerStringNew(userids,",");
		for (int i=0;i<ids.length;i++){
			rs.executeSql("select 1 from worktaskcreateshare where sharetype=1 and taskid="+wtid+" and userid="+ids[i]);
			if(!rs.next()){
				rs.executeSql("insert into worktaskcreateshare(taskid,userid,sharetype)"+ 
				" values("+wtid+","+ids[i]+",1)");
			}
		}	        
    }
    response.sendRedirect("worktaskAddCreateRight.jsp?isclose=1&wtid="+wtid);
	return;
}
%>
