<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.net.URLEncoder" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<% 
if(!HrmUserVarify.checkUserRight("SendDoc:Manage", user)){
	response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%
    char flag = 2;
    String ProcPara = "";

    String method = Util.null2String(request.getParameter("method"));
	String showOrder = Util.fromScreen(request.getParameter("showOrder"),user.getLanguage());
	if(null == showOrder || "".equals(showOrder.trim())) {
		showOrder = "0.0";
	}
    if(method.equals("add"))
    {
        String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
		String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());

		if(isExistLevel(RecordSet,name,"")) {
			// data cannot be duplicate
			response.sendRedirect("docInstancyLevelAdd.jsp?isclose=0&existFlag=1&name0="+URLEncoder.encode(name,"UTF-8")+"&desc0="+URLEncoder.encode(desc,"UTF-8")+"&showOrder0="+showOrder);
			return;
		}
		ProcPara = "insert into DocInstancyLevel(name,desc_n,showOrder) values('"+name+"','"+desc+"','"+showOrder+"')";
		RecordSet.executeSql(ProcPara);
		RecordSet.executeSql("select max(id) from DocInstancyLevel");
		if(RecordSet.next()){
			log.insSysLogInfo(user, RecordSet.getInt(1), name, ProcPara, "342", "1", 0, request.getRemoteAddr());
		}
		response.sendRedirect("docInstancyLevelAdd.jsp?isclose=1");
		return;
		
    }

    if(method.equals("edit"))
    {
        String id=Util.null2String(request.getParameter("id"));
        String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
		String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
		if(isExistLevel(RecordSet,name,id)) {
			// data cannot be duplicate
			response.sendRedirect("docInstancyLevelAdd.jsp?isclose=0&existFlag=1&id="+id+"&name0="+URLEncoder.encode(name,"UTF-8")+"&desc0="+URLEncoder.encode(desc,"UTF-8")+"&showOrder0="+showOrder);
			return;
		}
        ProcPara = "update DocInstancyLevel set ";
        ProcPara += "name='" + name + "', ";
		ProcPara += "showOrder='" + showOrder + "', ";
        ProcPara += "desc_n='" + desc + "' ";
        ProcPara += " where id = " + id ;
        RecordSet.executeSql(ProcPara);
        log.insSysLogInfo(user, Util.getIntValue(id), name, ProcPara, "342", "2", 0, request.getRemoteAddr());
        response.sendRedirect("docInstancyLevelAdd.jsp?isclose=1");
        return;
    }

    String IDs=Util.null2String(request.getParameter("IDs"));
    if(method.equals("delete"))
    {
        if(!IDs.equals(""))
        {
                ProcPara = "delete DocInstancyLevel where id in( " + IDs + ")";
                RecordSet.executeSql("select id,name from DocInstancyLevel where id in ("+IDs+")");
                while(RecordSet.next()){
                	log.insSysLogInfo(user, RecordSet.getInt(1), RecordSet.getString(2), ProcPara, "342", "3", 0, request.getRemoteAddr());
                }
                RecordSet.executeSql(ProcPara);

        }

        response.sendRedirect("docInstancyLevel.jsp");
        return;
    }
%>

<%!
	private boolean isExistLevel(weaver.conn.RecordSet recordSet,String name,String id) {
		name = Util.null2String(name).trim();
		String sql = "";
		if("".equals(id)) {
			sql = "select id,name from DocInstancyLevel where name='"+name+"'";
		} else {
			sql = "select id,name from DocInstancyLevel where name='"+name+"' and id !='"+id+"'";
		}
		recordSet.executeSql(sql);
		return recordSet.next() ? true : false;
	}
%>
