<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.general.Util"%>
<jsp:useBean id="rs" id="payPlan"
	class="weaver.contractn.serviceImpl.PayPlanServiceImpl" scope="page" />
<jsp:useBean id="rs" id="payVo"
    class="weaver.contractn.entity.PayPlanVo" scope="page" />
<jsp:useBean id="rs" id="payEntity"
    class="weaver.contractn.entity.PayPlanEntity" scope="page" />
<%//应收、应付的收付款明细和开票明细
        int detail_type = Util.getIntValue(request.getParameter("d_type"),1);//收入类型1 支出类型0
        int page_type = Util.getIntValue(request.getParameter("p_type"),1);//收付款明细1 开票开票明细0
        String cid = Util.null2s(request.getParameter("cid"),"0");//合同id
        
		out.print(payPlan.queryPayPlanDetailInfo(cid,detail_type,page_type));      

%>

                

   
                                                         