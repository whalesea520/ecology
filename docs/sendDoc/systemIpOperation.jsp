<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

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

    if(method.equals("add"))
    {
        String name=Util.null2String(request.getParameter("name"));
        String ip=Util.null2String(request.getParameter("ip"));

        ProcPara = "insert into systemIp(name,ip) values('"+name+"','"+ip+"')";
        RecordSet.executeSql(ProcPara);

        response.sendRedirect("systemIp.jsp");
        return;
    }

    if(method.equals("edit"))
    {
        String id=Util.null2String(request.getParameter("id"));
        String name=Util.null2String(request.getParameter("name"));
        String ip=Util.null2String(request.getParameter("ip"));

        ProcPara = "update systemIp set ";
        ProcPara += "name='" + name + "', ";
        ProcPara += "ip='" + ip + "' ";
        ProcPara += " where id = " + id ;
        RecordSet.executeSql(ProcPara);

        response.sendRedirect("systemIp.jsp");
        return;
    }

    String IDs[]=request.getParameterValues("IDs");
    if(method.equals("delete"))
    {
        if(IDs != null)
        {
            for(int i=0;i<IDs.length;i++)
            {
                ProcPara = "delete systemIp where id = " + IDs[i];
                RecordSet.executeSql(ProcPara);

            }
        }

        response.sendRedirect("systemIp.jsp");
        return;
    }
%>
