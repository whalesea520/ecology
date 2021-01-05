<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.contractn.util.Constant" %>
<jsp:useBean id="rs" id="ticket"
    class="weaver.contractn.serviceImpl.TicketServiceImpl" scope="page" />
<jsp:useBean id="sto" class="weaver.contractn.entity.DynamicEntity" scope="page" />
<jsp:useBean id="dynamic" class="weaver.contractn.serviceImpl.DynamicServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>      
<%

		User usr = HrmUserVarify.getUser(request, response);
		int author = usr.getUID();
		String userName = usr.getLastname();

        int conId = Integer.parseInt("".equals(request.getParameter("basicId")) ? "0":request.getParameter("basicId"));
        String ticketList = ticket.queryTicketListByConId(conId);
        
        //添加查看日志
        sto.setType(Constant.TICKET_TYPE_DYNAMIC_SELECTITEMVALUE);
        sto.setModule("cons_info");
        sto.setDataid(conId+"");
        sto.setOperateType(Constant.VIEW_OPERATETYPE_DYNAMIC_SELECTITEMVALUE);
        sto.setUsrId(author);
        sto.setCreateUser(userName);
        dynamic.sava(sto);
        out.print(ticketList);

%>
