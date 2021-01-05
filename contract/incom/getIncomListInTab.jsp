<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.contractn.util.Constant" %>
<jsp:useBean id="rs" id="incom"
    class="weaver.contractn.serviceImpl.IncomServiceImpl" scope="page" />
<jsp:useBean id="sto" class="weaver.contractn.entity.DynamicEntity" scope="page" />
<jsp:useBean id="dynamic" class="weaver.contractn.serviceImpl.DynamicServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>    
    
<%
		User usr = HrmUserVarify.getUser(request, response);
		int author = usr.getUID();
		String userName = usr.getLastname();
		
        String conId = Util.null2o(request.getParameter("basicId"));
        String incomList = Util.null2String(incom.queryIncomInfoByConsId(conId));
        
		//添加查看日志
		if(incomList.contains(Constant.INCOM_PAYTYPE_INFO_SELECTITEMVALUE)){
		    sto.setType(Constant.INCOM_TYPE_DYNAMIC_SELECTITEMVALUE);
		}else{
		    sto.setType(Constant.PAY_TYPE_DYNAMIC_SELECTITEMVALUE);
		}
		sto.setModule("cons_info");
		sto.setDataid(conId+"");
		sto.setOperateType(Constant.VIEW_OPERATETYPE_DYNAMIC_SELECTITEMVALUE);
		sto.setUsrId(author);
		sto.setCreateUser(userName);
		dynamic.sava(sto);
		
		
        out.print(incomList);
       

%>

                

   
                                                         