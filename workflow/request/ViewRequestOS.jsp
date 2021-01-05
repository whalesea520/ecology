<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.conn.RecordSet" %>
<%@ page import="weaver.hrm.*" %>
<%
        /**
         * 这个页面只打开其他系统的页面。其他页面误入直接跳转到ViewRequest.jsp
         */
	User user = HrmUserVarify.getUser (request , response) ;
    int requestid = Util.getIntValue(request.getParameter("requestid"));
    int workflowid = Util.getIntValue(request.getParameter("workflowid"));
    int sysid = Util.getIntValue(request.getParameter("sysid"));
    if(requestid>0){//OA的流程
        response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid);
    }else{//打开统一待办的流程
        RecordSet rs = new RecordSet();
        //查询打开的前缀和url
        String pcprefixurl = "";
        String pcurl = "" ;
        rs.executeSql("select s.Pcprefixurl,d.pcurl from ofs_sysinfo s ,ofs_todo_data d where d.sysid=s.sysid and d.requestid="+requestid+" and s.sysid="+sysid+" and userid="+user.getUID()+" and islasttimes=1 and d.workflowid="+workflowid);
        if(rs.next()){
            pcprefixurl = Util.null2String(rs.getString(1));
            pcurl = Util.null2String(rs.getString(2));
        }
        /*
        try{
	        rs.executeSql("update ofs_todo_data set viewtype=1 where requestid="+requestid+" and workflowid="+workflowid+" and sysid="+sysid);
	    }catch(Exception e){
		    
	    }
	    */
        //System.out.println("--->"+pcprefixurl+pcurl);
        response.sendRedirect(pcprefixurl+pcurl);
    }
%>
