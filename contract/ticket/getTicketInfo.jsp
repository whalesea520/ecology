<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.contractn.util.ContractUtil" %>
<jsp:useBean id="ticketVo" class="weaver.contractn.entity.TicketVo" scope="page" />
<jsp:useBean id="ticketService" class="weaver.contractn.serviceImpl.TicketServiceImpl" scope="page" />
<jsp:useBean id="ticketEntity" class="weaver.contractn.entity.TicketEntity" scope="page" />
<%@page import="weaver.general.Util"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
	String action = request.getParameter("action");
	String pageIndex = ContractUtil.null2one(request.getParameter("pageIndex"));
	String pageSize = ContractUtil.null2twenty(request.getParameter("pageSize"));
	String ticket_date = Util.null2s(request.getParameter("ticket_date"),"");
	String ticket_count = Util.null2s(request.getParameter("total"),"");
	String cons_name = Util.null2s(request.getParameter("cons_name"),"");
	String cons_code = Util.null2s(request.getParameter("cons_code"),"");
	String cons_count = Util.null2s(request.getParameter("cons_count"),"");
	String treeId = Util.null2s(request.getParameter("treeId"),"");
	String treeType = Util.null2s(request.getParameter("treeType"),"");
	
	ticketEntity.setTicket_date(ticket_date);
	ticketEntity.setTicket_count(ticket_count);
	ticketVo.setTicket(ticketEntity);
	ticketVo.setConsName(cons_name);
	ticketVo.setConsCode(cons_code);
	ticketVo.setConsCount(cons_count);
	ticketVo.setTreeId(treeId);
	ticketVo.setTreeType(treeType);
	ticketVo.setUser(user);
	ticketVo.setPageIndex(Integer.parseInt(pageIndex));
	ticketVo.setPageSize(Integer.parseInt(pageSize));
	if("chart".equals(action)){
		out.print(Util.null2String(ticketService.queryTicketListSum(ticketVo)));
	}else{
		out.print(Util.null2String(ticketService.queryTicketList(ticketVo)));
	}
	
%>
