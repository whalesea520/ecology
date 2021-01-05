
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%

String settype=Util.null2String(request.getParameter("types"));   //个人设置还是系统设置
if (settype.equals("0")) {
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
}


String method = Util.null2String(request.getParameter("method"));
String wtid = Util.null2String(request.getParameter("wtid")); 
char flag=Util.getSeparator();
String ProcPara = "";

   try{
		if("delShare".equals(method)){
			String ids = Util.null2String(request.getParameter("ids"));	
			if(!"".equals(ids))
				rs.executeSql("delete from worktaskshareset where id in("+ids+"0)");
		}else if("addShare".equals(method)){
			String subids = Util.null2String(request.getParameter("subids"));
			String depids = Util.null2String(request.getParameter("departmentid"));
			String roleid = Util.null2String(request.getParameter("roleid"));
			String userids = Util.null2String(request.getParameter("userid")); 
			
			String rolelevel = Util.null2String(request.getParameter("rolelevel"));
			String seclevel = Util.null2String(request.getParameter("seclevel"));
			String sharetype = Util.null2String(request.getParameter("sharetype"));
			
			String ssubids = Util.null2String(request.getParameter("ssubids"));
			String sdepids = Util.null2String(request.getParameter("sdepartmentid"));
			String sroleid = Util.null2String(request.getParameter("sroleid"));
			String suserids = Util.null2String(request.getParameter("suserid")); 
			
			String srolelevel = Util.null2String(request.getParameter("srolelevel"));
			String sseclevel = Util.null2String(request.getParameter("sseclevel"));
			String ssharetype = Util.null2String(request.getParameter("ssharetype"));
		
			String taskstatus= Util.null2String(request.getParameter("taskstatus")); //共享任务类型
			String sharelevel = Util.null2String(request.getParameter("sharelevel")); //共享级别 0：查看 1：反馈
			
			if (!settype.equals("0")){
				ssharetype="1";
				suserids=""+user.getUID();
			}
			
			String foralluser = "";
			String sforalluser = "";
			if("5".equals(sharetype)){
				foralluser  = "1";
			}
			
			if("5".equals(ssharetype)){
				sforalluser  = "1";
			}
			
			if (!taskstatus.equals("-1")){
				//reportid=String.valueOf(i);
				ProcPara=""+wtid+flag;
				ProcPara += taskstatus;
				ProcPara += flag+sharetype;
				ProcPara += flag+seclevel;
				ProcPara += flag+rolelevel;
				ProcPara += flag+sharelevel;
				ProcPara += flag+userids;
				ProcPara += flag+subids;
				ProcPara += flag+depids;
				ProcPara += flag+roleid;
				ProcPara += flag+foralluser;
				ProcPara += flag+ssharetype;
				ProcPara += flag+sseclevel;
				ProcPara += flag+srolelevel;
				ProcPara += flag+suserids;
				ProcPara += flag+ssubids;
				ProcPara += flag+sdepids;
				ProcPara += flag+sroleid;
				ProcPara += flag+sforalluser;
				ProcPara += flag+settype;
				rs.executeProc("WorkTaskShareSet_Insert",ProcPara);
		    }else{
				for(int taskstatusNew=1; taskstatusNew<=2; taskstatusNew++){
					ProcPara=""+wtid+flag;
					ProcPara += taskstatusNew;
					ProcPara += flag+sharetype;
					ProcPara += flag+seclevel;
					ProcPara += flag+rolelevel;
					ProcPara += flag+sharelevel;
					ProcPara += flag+userids;
					ProcPara += flag+subids;
					ProcPara += flag+depids;
					ProcPara += flag+roleid;
					ProcPara += flag+foralluser;
					ProcPara += flag+ssharetype;
					ProcPara += flag+sseclevel;
					ProcPara += flag+srolelevel;
					ProcPara += flag+suserids;
					ProcPara += flag+ssubids;
					ProcPara += flag+sdepids;
					ProcPara += flag+sroleid;
					ProcPara += flag+sforalluser;
					ProcPara += flag+settype;
					rs.executeProc("WorkTaskShareSet_Insert",ProcPara);
				}
			}
		  response.sendRedirect("WorkTaskShareAdd.jsp?isclose=1&wtid="+wtid);
			return;
		}
	}catch(Exception e){
		e.printStackTrace();
	}
  
%>
