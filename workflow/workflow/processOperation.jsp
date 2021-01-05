
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="WFDocumentManager" class="weaver.workflow.workflow.WFDocumentManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />

<%
    String src = Util.null2String(request.getParameter("src"));
    String linkType = Util.null2String(request.getParameter("linktype"));
   String label = Util.null2String(request.getParameter("label"));
   String nameSimple = Util.null2String(request.getParameter("nameSimple"));
   String nameEn = Util.null2String(request.getParameter("nameEn"));
   String nameTranditional = Util.null2String(request.getParameter("nameTranditional"));
   String sortorder = Util.null2String(request.getParameter("sortorder"));
   SystemEnv se = new SystemEnv();
   se.setUser(user);
   if(src.equalsIgnoreCase("addProcess")){
   		String labelid = se.getHtmlLabelId(-1,nameSimple,nameEn,nameTranditional);
   		if(labelid.equals("error")){
   			response.sendRedirect("/workflow/workflow/addProcess.jsp?isdialog=1&error=1&linktype="+linkType);
   			return;
   		}else{
	   		String sql = "insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)"+
						" values('"+label+"',0,1,'"+sortorder+"',"+linkType+","+labelid+",0)";
			if(rs.executeSql(sql)){
				rs.executeSql("select max(id) from workflow_processdefine");
				if(rs.next()){
					log.insSysLogInfo(user, rs.getInt(1), label, sql, "345", "1", 0, request.getRemoteAddr());
				}
				response.sendRedirect("/workflow/workflow/addProcess.jsp?isdialog=1&isclose=1&linktype="+linkType);
   				return;
			}else{
				response.sendRedirect("/workflow/workflow/addProcess.jsp?isdialog=1&error=2&linktype="+linkType);
   				return;
			}
		}
   }else if(src.equals("editProcess")){
   		int shownamelabel = Util.getIntValue(request.getParameter("shownamelabel"),-1);
   		String labelid = se.getHtmlLabelId(shownamelabel,nameSimple,nameEn,nameTranditional);
   		String id = Util.null2String(request.getParameter("id"));
   		rs.executeSql("select isSys from workflow_processdefine where id="+id);
   		int isSys = 0;
   		if(rs.next()){
   			isSys = Util.getIntValue(rs.getString("isSys"),0);
   		}
   		if(labelid.equals("error")){
   			response.sendRedirect("/workflow/workflow/editProcess.jsp?isdialog=1&error=1&id="+id);
   			return;
   		}else{
	   		String sql = "";
	   		if(isSys==1){
	   			sql = "update workflow_processdefine set shownamelabel="+labelid+",sortorder="+sortorder+" where id="+id;
	   		}else{
	   			sql = "update workflow_processdefine set label='"+label+"', shownamelabel="+labelid+",sortorder="+sortorder+" where id="+id;
	   		}
			if(rs.executeSql(sql)){
				log.insSysLogInfo(user, Util.getIntValue(id), label, sql, "345", "2", 0, request.getRemoteAddr());
				response.sendRedirect("/workflow/workflow/editProcess.jsp?isdialog=1&isclose=1&id="+id);
   				return;
			}else{
				response.sendRedirect("/workflow/workflow/editProcess.jsp?isdialog=1&error=2&id="+id);
   				return;
			}
		}
   }
%>



