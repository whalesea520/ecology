
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/docs/common.jsp" %>
<%
 String operation =  Util.null2String(request.getParameter("operation"));
String displayUsage=Util.null2String(request.getParameter("displayUsage"));
 if ("signReaded".equals(operation)){
     char flag=Util.getSeparator() ;
     int userId = user.getUID();
     String loginType = user.getLogintype();
     String signReadedIds = Util.null2String(request.getParameter("signValus"));
     if (!"".equals(signReadedIds)){
    	if(signReadedIds.endsWith(",")){ 
        	signReadedIds = signReadedIds.substring(0,signReadedIds.length()-1);
    	}
        //System.out.println(signReadedIds);
        //rs.executeSql("select id,docsubject,doccreaterid,usertype from docdetail where id in("+signReadedIds+")");
		rs.executeSql("select id,docsubject,doccreaterid,usertype from docdetail where id in("+signReadedIds+") and  not  EXISTS (select 1 from docreadtag where docreadtag.docid=docdetail.id and usertype="+loginType+" and userid="+userId+")");
        while (rs.next()){
           int docId = Util.getIntValue(rs.getString("id"));
           String docsubject = Util.null2String(rs.getString("docsubject"));
           String doccreaterid = Util.null2String(rs.getString("doccreaterid"));
           String usertype = Util.null2String(rs.getString("usertype"));
       
           if( userId != Util.getIntValue(doccreaterid)|| !usertype.equals(loginType) ) {
                rs1.executeProc("docReadTag_AddByUser",""+docId+flag+""+userId+flag+loginType); 
                DocDetailLog.resetParameter();
                DocDetailLog.setDocId(docId);
                DocDetailLog.setDocSubject(docsubject);
                DocDetailLog.setOperateType("0");
                DocDetailLog.setOperateUserid(userId);
                DocDetailLog.setUsertype(loginType);
                DocDetailLog.setClientAddress(request.getRemoteAddr());
                DocDetailLog.setDocCreater(Util.getIntValue(doccreaterid));
                DocDetailLog.setDocLogInfo();
            }
        }
     }     
     //response.sendRedirect("/docs/search/DocSearchTemp.jsp?list=all&isNew=yes&loginType=1&&containreply=1&displayUsage="+displayUsage); 
     request.getRequestDispatcher("/docs/search/DocCommonContent.jsp").forward(request,response);   
} else  if ("signReadBetween".equals(operation)){
     char flag=Util.getSeparator() ;
     int userId = user.getUID();
     String loginType = user.getLogintype();
     String beginId = Util.null2String(request.getParameter("beginId"));
     String endId = Util.null2String(request.getParameter("endId"));
     if (!"".equals(beginId) && !"".equals(endId)){
       	//System.out.println("select id,docsubject,doccreaterid,usertype from docdetail t1, "+tables+" t2  where t1.id=t2.sourceid and t1.id between "+beginId+" and "+endId);
     
       	rs.executeSql("select id,docsubject,doccreaterid,usertype from docdetail t1, "+tables+" t2  where t1.id=t2.sourceid and t1.id between "+beginId+" and "+endId);
        
        while (rs.next()){ 
           int docId = Util.getIntValue(rs.getString("id"));
           String docsubject = Util.null2String(rs.getString("docsubject"));
           String doccreaterid = Util.null2String(rs.getString("doccreaterid"));
           String usertype = Util.null2String(rs.getString("usertype"));
       
           if( userId != Util.getIntValue(doccreaterid)|| !usertype.equals(loginType) ) {
                rs1.executeProc("docReadTag_AddByUser",""+docId+flag+""+userId+flag+loginType); 
                DocDetailLog.resetParameter();
                DocDetailLog.setDocId(docId);
                DocDetailLog.setDocSubject(docsubject);
                DocDetailLog.setOperateType("0");
                DocDetailLog.setOperateUserid(userId);
                DocDetailLog.setUsertype(loginType);
                DocDetailLog.setClientAddress(request.getRemoteAddr());
                DocDetailLog.setDocCreater(Util.getIntValue(doccreaterid));
                DocDetailLog.setDocLogInfo();
            }
       
     	}   
     }
     response.sendRedirect("/docs/search/DocSearchTemp.jsp?list=all&isNew=yes&loginType=1&&containreply=1&displayUsage="+displayUsage);        
}
%>