
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@page import="weaver.mobile.webservices.common.BrowserAction"%>
<%
String method = Util.null2String(request.getParameter("method"));
int browserTypeId = Util.getIntValue(request.getParameter("browserTypeId"), 0);
String customBrowType = Util.null2String(request.getParameter("customBrowType"));
int hrmOrder = Util.getIntValue(request.getParameter("_hrmorder_"), 0);
String linkhref =  Util.null2String(request.getParameter("linkhref"));
String joinFieldParams= Util.null2String(request.getParameter("joinFieldParams"));
int pageNo = Util.getIntValue(request.getParameter("pageno"), 1);
int pageSize = Util.getIntValue(request.getParameter("pageSize"), 10);
String keyword = Util.null2String(request.getParameter("keyword"));
//qc273075	[1703补丁包测试]流程展现集成-解决手机端输入+作为查询条件失效的问题 start
boolean replace=false;
if(keyword.indexOf("+")>=0){
	 replace=true;
	 }else{
		 replace=false;
	 }

keyword = java.net.URLDecoder.decode(keyword, "UTF-8");
if(replace){
	 keyword=keyword.replace(" ","+");
} 
//qc273075	[1703补丁包测试]流程展现集成-解决手机端输入+作为查询条件失效的问题 end
int fnaworkflowid = Util.getIntValue(request.getParameter("fnaworkflowid"), -1);
String fnafieldid = Util.null2String(request.getParameter("fnafieldid"));

boolean isDis = "1".equals(Util.null2String(request.getParameter("isDis"))) ? true : false;
if (!isDis) {
	request.getRequestDispatcher("/mobile/plugin/dialog.jsp").forward(request, response);
	return;
}

//User user = HrmUserVarify.getUser (request , response);
String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));//需要增加的代码
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));//需要增加的代码
User user  = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码

BrowserAction braction = new BrowserAction(user, browserTypeId, pageNo, pageSize);
braction.setKeyword(keyword);
if("listFnaBudgetFeeType".equals(method)){//是科目浏览按钮：财务 QC141205 科目应用范围过滤
	boolean _flag = Util.getIntValue(request.getParameter("isFnaSubmitRequest4Mobile"), -1)==1;
	if(_flag){
		int orgtype = Util.getIntValue(request.getParameter("orgtype"), -1);
		int orgid = Util.getIntValue(request.getParameter("orgid"), -1);
		int orgtype2 = Util.getIntValue(request.getParameter("orgtype2"), -1);
		int orgid2 = Util.getIntValue(request.getParameter("orgid2"), -1);
		braction.setFnaSubmitRequest4Mobile(_flag);
		braction.setOrgtype(orgtype);
		braction.setOrgid(orgid);
		braction.setOrgtype2(orgtype2);
		braction.setOrgid2(orgid2);
	}
}else if("listWorkflowRequest".equals(method)){//单请求浏览按钮：财务 QC141220
	boolean _flag = false;
	if(!_flag){
		//还款（报销）流程的明细表（冲账明细）的字段：借款流程
		_flag = Util.getIntValue(request.getParameter("isFnaRepayRequest4Mobile"), -1)==1;
		if(_flag){
			int fnaWfRequestid = Util.getIntValue(request.getParameter("fnaWfRequestid"), 0);
			int main_fieldIdSqr_controlBorrowingWf = Util.getIntValue(request.getParameter("main_fieldIdSqr_controlBorrowingWf"), 0);
			int main_fieldIdSqr_val = Util.getIntValue(request.getParameter("main_fieldIdSqr_val"), 0);
			braction.setFnaRepayRequest4Mobile(true);
			braction.setFnaWfRequestid(fnaWfRequestid);
			braction.setMain_fieldIdSqr_controlBorrowingWf(main_fieldIdSqr_controlBorrowingWf);
			braction.setMain_fieldIdSqr_val(main_fieldIdSqr_val);
		}
	}
	if(!_flag){
		//是报销流程的主表的字段：费用申请流程
		_flag = Util.getIntValue(request.getParameter("isFnaRequestApplication4Mobile"), -1)==1;
		if(_flag){
			int fnaWfRequestid = Util.getIntValue(request.getParameter("fnaWfRequestid"), 0);
			braction.setFnaRequestApplication4Mobile(true);
			braction.setFnaWfRequestid(fnaWfRequestid);
		}
	}
}
braction.setMethod(method);
braction.setHrmOrder(hrmOrder);
//分权用
braction.setCustomBrowType(customBrowType);
braction.setJoinFieldParams(joinFieldParams);
braction.setLinkhref(linkhref);
braction.setFnafieldid(fnafieldid);
braction.setFnaworkflowid(fnaworkflowid);
String result = braction.getBrowserData();
response.getOutputStream().write(result.getBytes("UTF-8"));
response.getOutputStream().flush();
%>
