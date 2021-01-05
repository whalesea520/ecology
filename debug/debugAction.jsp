<%@ include file="init.jsp" %>

<%
    
    Object debugData = session.getAttribute(debugDataKey);
    Class dataClass = Class.forName("com.weaver.onlinedebug.data.DebugData");

    Class util = Class.forName("com.weaver.onlinedebug.util.Util");
    
%>
<%
    String action = request.getParameter("action");

    if ("addvardata".equals(action)) {
        String className = request.getParameter("classname");
        String line = request.getParameter("line");
        
        if(className.trim().length()>0 && line.trim().length()>0){
            if(className.endsWith(".jsp")){
                className = jspPath2Class(className);
            }
            util.getMethod("addVarLineData",new Class[]{dataClass, String.class, int.class})
                .invoke(null, new Object[]{debugData,className,Integer.valueOf(line)});
        }
        
        response.sendRedirect("varDataList.jsp");
    } else if ("editvardata".equals(action)) {
        String className = request.getParameter("classname");
        String oldLine = request.getParameter("oldline");
        String newLine = request.getParameter("newline");
        String info = request.getParameter("info");
        info = info.replaceAll("\r\n",";").replaceAll("\n",";");
        
        session.setAttribute(debugCurrentLineKey, newLine);
        
        util.getMethod("editVarLineData",new Class[]{dataClass, String.class, int.class, int.class, String.class})
            .invoke(null,new Object[]{debugData,className,Integer.valueOf(oldLine),Integer.valueOf(newLine),info});
        
        response.sendRedirect("varDataList.jsp");
    } else if ("deletecurrent".equals(action)) {
        String className = request.getParameter("classname");
        String line = request.getParameter("line");
        
        util.getMethod("deleteVarLineData",new Class[]{dataClass, String.class, int.class})
            .invoke(null,new Object[]{debugData,className,Integer.valueOf(line)});
       
        response.sendRedirect("varDataList.jsp");
    } else if ("deleteall".equals(action)) {
        util.getMethod("deleteAllVarLineData",new Class[]{dataClass}) 
            .invoke(null,new Object[]{debugData});
       
        response.sendRedirect("varDataList.jsp");
    } else if ("setenable".equals(action)){
        String className = request.getParameter("classname");
        String line = request.getParameter("line");
        String enable = request.getParameter("enable");
        
        
        util.getMethod("setEnableVarLineData",new Class[]{dataClass, String.class, int.class, boolean.class})
            .invoke(null,new Object[]{debugData,className,Integer.valueOf(line),Boolean.valueOf(enable)});
        
        response.sendRedirect("varDataList.jsp");
    } else if ("setcurrent".equals(action)){
        String className = request.getParameter("classname");
        String line = request.getParameter("line");
        
        session.setAttribute(debugCurrentClassKey,className);
        session.setAttribute(debugCurrentLineKey,line);
        
        response.sendRedirect("varDataEdit.jsp");
    } else if ("updatestatus".equals(action)){
        String trackType = request.getParameter("tracktype");
        String trackSeq = request.getParameter("trackseq");
        
         util.getMethod("updateStatus",new Class[]{dataClass, String.class, String.class})
            .invoke(null,new Object[]{debugData,trackType,trackSeq});
        
    }
%>
<%!
    public static String jspPath2Class(String jspPath) throws Exception {
        if(!jspPath.startsWith("/")){
            jspPath = "/" + jspPath;
        }
        String jspClass = (String)Class.forName("com.weaver.onlinedebug.util.Util").getDeclaredMethod("jspPath2Class",new Class[]{String.class}).invoke(null,new Object[]{jspPath});
        return jspClass;
    }
%>