<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.net.*"%>
<jsp:useBean id="sto" class="weaver.contractn.entity.DynamicEntity" scope="page" />
<jsp:useBean id="dynamic" class="weaver.contractn.serviceImpl.DynamicServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%  
    User usr = HrmUserVarify.getUser(request, response);
    int author = usr.getUID();
    String userName = usr.getLastname();
    String content = URLDecoder.decode(request.getParameter("content"), "UTF-8");//内容 
    String remaind_usr = request.getParameter("remaind_usr[]");   
    String moduleid = request.getParameter("moduleid");   
    String dataid = request.getParameter("dataid");   
    String type = request.getParameter("type");
    String operate_type = request.getParameter("operate_type");
    sto.setUsrId(author);
    sto.setCreateUser(userName);
    sto.setContent(content);
    sto.setRemaindUsr(remaind_usr);
    sto.setModule(moduleid);
    sto.setDataid(dataid);
    sto.setOperateType(operate_type);
    sto.setType(type);
    dynamic.sava(sto);

%>



