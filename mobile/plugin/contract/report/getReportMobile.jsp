<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.contractn.service.ReportServiceMobile"%>
<%@ page import="com.alibaba.fastjson.*"%>
<%@ page import="weaver.contractn.serviceImpl.ReportServiceMobileImpl"%>
<%@ page import="weaver.contractn.exception.ContractException"%>
<%@ page import="weaver.common.util.string.StringUtil"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%

    User user = MobileUserInit.getUser(request, response);
    JSONObject jsonObj = new JSONObject();
    //是否处理成功
    boolean flag = false;
    //返回前端信息
    String errorMessage = "";
    String action = request.getParameter("action");
    ReportServiceMobile reportService = new ReportServiceMobileImpl();
    try{
        if("getReportByContractToday".equals(action)){
            JSONObject reportByContractToday= reportService.getReportByContractToday();
            jsonObj.put("reportByContractToday",reportByContractToday);
            flag = true;
        }else if("getReportByContractAmountYOY".equals(action)){
            JSONObject reportByContractAmountYOY= reportService.getReportByContractAmountYOY();
            jsonObj.put("reportByContractAmountYOY",reportByContractAmountYOY);
            flag = true;
        }else if("getReportByContractDynamic".equals(action)){
            String pageNo = request.getParameter("pageNo");
            String pageSize = request.getParameter("pageSize");
            if(StringUtil.isNotNullAndEmpty(pageNo) && StringUtil.isNotNullAndEmpty(pageSize)){
                JSONArray reportByContractDynamic = reportService.getReportByContractDynamic(user,Integer.parseInt(pageNo),Integer.parseInt(pageSize));
                jsonObj.put("reportByContractDynamic",reportByContractDynamic);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：分页编号(pageNo)或分页数量(pageSize)为空";
            }
        }else if("getReportByStaff".equals(action)){
            String type = request.getParameter("type");
            if(StringUtil.isNotNullAndEmpty(type)){
                JSONArray reportByStaff = reportService.getReportByStaff(type);
                jsonObj.put("reportByStaff",reportByStaff);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：日期类型(type)为空";
            }
        }else if("getReportByMine".equals(action)){
	        if(user != null){
	            String userid = user.getUID() + "";
	            JSONObject reportByMine = reportService.getReportByMine(userid);
	            jsonObj.put("reportByMine",reportByMine);
	            flag = true;    
	        }else{
                errorMessage = "查询失败，错误信息：请先登录";
            }
        }else if("getReportBySubordinate".equals(action)){
            if(user != null){
                String userid = user.getUID() + "";
                JSONArray reportBySubordinate = reportService.getReportBySubordinate(userid);
                jsonObj.put("reportBySubordinate",reportBySubordinate);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：请先登录";
            }
        }
    }catch(ContractException e){
        errorMessage = "查询失败，错误信息："+e.getMessage();
    }
    jsonObj.put("flag",flag);
    jsonObj.put("errorMessage",errorMessage);
    out.print(jsonObj.toJSONString());
%>