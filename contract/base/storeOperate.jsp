<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="org.json.*"%>
<jsp:useBean id="sto" class="weaver.contractn.entity.StoreEntity" scope="page" />
<jsp:useBean id="store" class="weaver.contractn.serviceImpl.StoreServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%  
    User usr = HrmUserVarify.getUser(request, response);
    int author = usr.getUID();
    int flag = Integer.parseInt(request.getParameter("flag"));
	String type = request.getParameter("type");
    String consid = request.getParameter("consId");
    sto.setUsrId(author);
    sto.setConsid(consid);
    if("focus".equals(type)){
        sto.setType(0);
    }
    String message = "";
    if(flag == 0){
        message = store.delete(sto);
    }else{
        message = store.save(sto);
    }
    out.print(message);   

%>



