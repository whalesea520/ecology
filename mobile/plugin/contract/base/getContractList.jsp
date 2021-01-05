<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.contractn.util.Constant" %>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.contractn.util.ContractUtil" %>
<jsp:useBean id="conVo" class="weaver.contractn.entity.ContractVo" scope="page" />
<jsp:useBean id="conEntity" class="weaver.contractn.entity.ContractEntity" scope="page" />
<jsp:useBean id="conService" class="weaver.contractn.serviceImpl.ContractServiceImpl" scope="page" />
<jsp:useBean id="select" class="weaver.contractn.serviceImpl.SelectItemServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
	User usr = MobileUserInit.getUser(request, response);
    int usrId = usr.getUID();
    String pageIndex = ContractUtil.null2one(request.getParameter("pageIndex"));
    String pageSize = ContractUtil.null2twenty(request.getParameter("pageSize"));
    String consId = request.getParameter("basicId");
    String treeType = request.getParameter("treeType");
    String treeId = request.getParameter("treeId");
    String start_date = request.getParameter("start_date");
    String end_date = request.getParameter("end_date");
    String sign_date = request.getParameter("sign_date");
    String cons_count = request.getParameter("cons_count");
    String cons_name = request.getParameter("cons_name");
    String pay_type = select.querySelectItemInfo(Constant.INFO_TABLENAME,"pay_type").get(request.getParameter("pay_type"));
    String usrStore = request.getParameter("flag");
    String headUsr = request.getParameter("usr");
    String pay_count = request.getParameter("pay_count");
    String status = select.querySelectItemInfo(Constant.INFO_TABLENAME,"status").get(request.getParameter("status"));
    String customer = request.getParameter("customer");
    String employee = request.getParameter("employee");
    String code = request.getParameter("code");
    conEntity.setStart_date(start_date);
    conEntity.setName(cons_name);
    conEntity.setId(consId);
    conEntity.setCons_count(cons_count);
    conEntity.setUsr(headUsr);
    conEntity.setEnd_date(end_date);
    conEntity.setSign_date(sign_date);
    conEntity.setPay_count(pay_count);
    conEntity.setCustomer(customer);
    conEntity.setEmployee(employee);
    conEntity.setStatus(status);
    conEntity.setPay_type(pay_type);
    conEntity.setCode(code);
	conVo.setTreeType(treeType);
	conVo.setTreeId(treeId);
	conVo.setContract(conEntity);
	conVo.setUsrId(usrId);
	conVo.setUserStore(usrStore);
	conVo.setUser(usr);
	conVo.setPageIndex(Integer.parseInt(pageIndex));
	conVo.setPageSize(Integer.parseInt(pageSize));
	out.print(Util.null2String(conService.queryBasicInfo(conVo)));
	
	//System.out.println(conService.queryBasicInfo(conVo));
%>



