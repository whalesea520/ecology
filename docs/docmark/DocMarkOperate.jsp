
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocMark" class="weaver.docs.docmark.DocMark" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
    char flag = 2 ;
    String ProcPara = "";  

    String operate = Util.null2String(request.getParameter("operate"));
    
    String secId = (String)session.getValue("secId");
    String docId = Util.null2String(request.getParameter("docId"));
    String rdoMark = Util.null2String(request.getParameter("rdoMark"));
    String remark = Util.fromScreen(Util.null2String(request.getParameter("remark")),7);       
    
    String currentDateStr = DocMark.getCurrentDayStr();

    String fromUrl = Util.null2String(request.getParameter("fromUrl"));
    if ("add".equals(operate)){
        String marker = ""+user.getUID();            
        String markId = DocMark.getMarkId(user,docId);
         if ("".equals(markId)) {
             ProcPara = docId;
             ProcPara += flag  + ""+user.getLogintype() ;
             ProcPara += flag  + ""+marker;
             ProcPara += flag  + ""+rdoMark ;
             ProcPara += flag  + ""+remark ;
             ProcPara += flag  + ""+currentDateStr ;

             rs.executeProc("DocMark_Insert",ProcPara);
         } else {
         
             ProcPara = markId ;
             ProcPara += flag  + ""+docId ;
             ProcPara += flag  + ""+user.getLogintype() ;
             ProcPara += flag  + ""+marker ;
             ProcPara += flag  + ""+rdoMark ;
             ProcPara += flag  + ""+remark ;
             ProcPara += flag  + ""+currentDateStr ;

              rs.executeProc("DocMark_update",ProcPara);         
         }
         //out.println(ProcPara);
         response.sendRedirect(fromUrl);
    }
    
%>