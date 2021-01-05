<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.contractn.service.ReportService"%>
<%@ page import="java.util.*"%>
<%@ page import="com.alibaba.fastjson.*"%>
<%@ page import="weaver.common.util.string.StringUtil"%>
<%@ page import="weaver.contractn.serviceImpl.ReportServiceImpl"%>
<%@ page import="weaver.contractn.exception.ContractException"%>
<%
    JSONObject jsonObj = new JSONObject();
    //是否处理成功
    boolean flag = false;
    //返回前端信息
    String errorMessage = "";
    String action = request.getParameter("action");
    ReportService reportService = new ReportServiceImpl();
    try{
        if("getReportByType".equals(action)){
            String year = request.getParameter("year");
            String payType = request.getParameter("payType");
            if(StringUtil.isNotNullAndEmpty(year) && StringUtil.isNotNullAndEmpty(payType)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                conditions.put("payType",payType);
                JSONArray reportByType = reportService.getReportByType(conditions);
                jsonObj.put("reportByType",reportByType);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)或者合同性质(payType)为空";
            }
        }else if("getReportByState".equals(action)){
            String year = request.getParameter("year");
            String payType = request.getParameter("payType");
            if(StringUtil.isNotNullAndEmpty(year) && StringUtil.isNotNullAndEmpty(payType)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                conditions.put("payType",payType);
                JSONArray reportByState= reportService.getReportByState(conditions);
                jsonObj.put("reportByState",reportByState);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)或者合同性质(payType)为空";
            }
        }else if("getReportByDepartment".equals(action)){
            String year = request.getParameter("year");
            String payType = request.getParameter("payType");
            String includeChilds = request.getParameter("includeChilds");
            String pageNo = request.getParameter("pageNo");
            String pageSize = request.getParameter("pageSize");
            String orderField = request.getParameter("orderField");
            String orderType = request.getParameter("orderType");
            if(StringUtil.isNotNullAndEmpty(year) && StringUtil.isNotNullAndEmpty(payType) && StringUtil.isNotNullAndEmpty(includeChilds) && StringUtil.isNotNullAndEmpty(pageNo) && StringUtil.isNotNullAndEmpty(pageSize) && StringUtil.isNotNullAndEmpty(orderField) && StringUtil.isNotNullAndEmpty(orderType)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                conditions.put("payType",payType);
                conditions.put("includeChilds",includeChilds);
                conditions.put("pageNo",pageNo);
                conditions.put("pageSize",pageSize);
                conditions.put("orderField",orderField);
                conditions.put("orderType",orderType);
                JSONObject reportByDepartment= reportService.getReportByDepartment(conditions);
                jsonObj.put("reportByDepartment",reportByDepartment);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)或合同性质(payType)或包含下级(includeChilds)或分页编号(pageNo)或分页数量(pageSize)或排序字段(orderField)或排序类型(orderType)为空";
            }
        }else if("getReportByStaff".equals(action)){
            String year = request.getParameter("year");
            String payType = request.getParameter("payType");
            String includeChilds = request.getParameter("includeChilds");
            String pageNo = request.getParameter("pageNo");
            String pageSize = request.getParameter("pageSize");
            String orderField = request.getParameter("orderField");
            String orderType = request.getParameter("orderType");
            if(StringUtil.isNotNullAndEmpty(year) && StringUtil.isNotNullAndEmpty(payType) && StringUtil.isNotNullAndEmpty(includeChilds) && StringUtil.isNotNullAndEmpty(pageNo) && StringUtil.isNotNullAndEmpty(pageSize) && StringUtil.isNotNullAndEmpty(orderField) && StringUtil.isNotNullAndEmpty(orderType)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                conditions.put("payType",payType);
                conditions.put("includeChilds",includeChilds);
                conditions.put("pageNo",pageNo);
                conditions.put("pageSize",pageSize);
                conditions.put("orderField",orderField);
                conditions.put("orderType",orderType);
                JSONObject reportByStaff= reportService.getReportByStaff(conditions);
                jsonObj.put("reportByStaff",reportByStaff);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)或合同性质(payType)或包含下级(includeChilds)或分页编号(pageNo)或分页数量(pageSize)或排序字段(orderField)或排序类型(orderType)为空";
            }
        }else if("getReportByCustomerSector".equals(action)){
            String year = request.getParameter("year");
            String payType = request.getParameter("payType");
            if(StringUtil.isNotNullAndEmpty(year) && StringUtil.isNotNullAndEmpty(payType)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                conditions.put("payType",payType);
                JSONArray reportByCustomerSector= reportService.getReportByCustomerSector(conditions);
                jsonObj.put("reportByCustomerSector",reportByCustomerSector);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)或者合同性质(payType)为空";
            }
        }else if("getReportByCustomerSize".equals(action)){
            String year = request.getParameter("year");
            String payType = request.getParameter("payType");
            if(StringUtil.isNotNullAndEmpty(year) && StringUtil.isNotNullAndEmpty(payType)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                conditions.put("payType",payType);
                JSONArray reportByCustomerSize= reportService.getReportByCustomerSize(conditions);
                jsonObj.put("reportByCustomerSize",reportByCustomerSize);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)或者合同性质(payType)为空";
            }
        }else if("getReportByCustomerRating".equals(action)){
            String year = request.getParameter("year");
            String payType = request.getParameter("payType");
            if(StringUtil.isNotNullAndEmpty(year) && StringUtil.isNotNullAndEmpty(payType)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                conditions.put("payType",payType);
                JSONArray reportByCustomerRating= reportService.getReportByCustomerRating(conditions);
                jsonObj.put("reportByCustomerRating",reportByCustomerRating);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)或者合同性质(payType)为空";
            }
        }else if("getReportTop10ByDepartment".equals(action)){
            String year = request.getParameter("year");
            String payType = request.getParameter("payType");
            String includeChilds = request.getParameter("includeChilds");
            String pageNo = request.getParameter("pageNo");
            String pageSize = request.getParameter("pageSize");
            String orderField = request.getParameter("orderField");
            String orderType = request.getParameter("orderType");
            if(StringUtil.isNotNullAndEmpty(year) && StringUtil.isNotNullAndEmpty(payType) && StringUtil.isNotNullAndEmpty(includeChilds) && StringUtil.isNotNullAndEmpty(pageNo) && StringUtil.isNotNullAndEmpty(pageSize) && StringUtil.isNotNullAndEmpty(orderField) && StringUtil.isNotNullAndEmpty(orderType)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                conditions.put("payType",payType);
                conditions.put("includeChilds",includeChilds);
                conditions.put("pageNo",pageNo);
                conditions.put("pageSize",pageSize);
                conditions.put("orderField",orderField);
                conditions.put("orderType",orderType);
                JSONObject reportByDepartment= reportService.getReportTop10ByDepartment(conditions);
                jsonObj.put("reportByDepartment",reportByDepartment);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)或合同性质(payType)或包含下级(includeChilds)或分页编号(pageNo)或分页数量(pageSize)或排序字段(orderField)或排序类型(orderType)为空";
            }
        }else if("getReportTop10ByStaff".equals(action)){
            String year = request.getParameter("year");
            String payType = request.getParameter("payType");
            String includeChilds = request.getParameter("includeChilds");
            String pageNo = request.getParameter("pageNo");
            String pageSize = request.getParameter("pageSize");
            String orderField = request.getParameter("orderField");
            String orderType = request.getParameter("orderType");
            if(StringUtil.isNotNullAndEmpty(year) && StringUtil.isNotNullAndEmpty(payType) && StringUtil.isNotNullAndEmpty(includeChilds) && StringUtil.isNotNullAndEmpty(pageNo) && StringUtil.isNotNullAndEmpty(pageSize) && StringUtil.isNotNullAndEmpty(orderField) && StringUtil.isNotNullAndEmpty(orderType)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                conditions.put("payType",payType);
                conditions.put("includeChilds",includeChilds);
                conditions.put("pageNo",pageNo);
                conditions.put("pageSize",pageSize);
                conditions.put("orderField",orderField);
                conditions.put("orderType",orderType);
                JSONObject reportByStaff= reportService.getReportTop10ByStaff(conditions);
                jsonObj.put("reportByStaff",reportByStaff);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)或合同性质(payType)或包含下级(includeChilds)或分页编号(pageNo)或分页数量(pageSize)或排序字段(orderField)或排序类型(orderType)为空";
            }
        }else if("getReportTop10ByFocusMost".equals(action)){
            String year = request.getParameter("year");
            String payType = request.getParameter("payType");
            String pageNo = request.getParameter("pageNo");
            String pageSize = request.getParameter("pageSize");
            String orderField = request.getParameter("orderField");
            String orderType = request.getParameter("orderType");
            if(StringUtil.isNotNullAndEmpty(year) && StringUtil.isNotNullAndEmpty(payType) && StringUtil.isNotNullAndEmpty(pageNo) && StringUtil.isNotNullAndEmpty(pageSize) && StringUtil.isNotNullAndEmpty(orderField) && StringUtil.isNotNullAndEmpty(orderType)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                conditions.put("payType",payType);
                conditions.put("pageNo",pageNo);
                conditions.put("pageSize",pageSize);
                conditions.put("orderField",orderField);
                conditions.put("orderType",orderType);
                JSONObject reportByFocusMost= reportService.getReportTop10ByFocusMost(conditions);
                jsonObj.put("reportByFocusMost",reportByFocusMost);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)或者合同性质(payType)或分页编号(pageNo)或分页数量(pageSize)或排序字段(orderField)或排序类型(orderType)为空";
            }
        }else if("getReportTop10ByCustomerSignMost".equals(action)){
            String year = request.getParameter("year");
            String payType = request.getParameter("payType");
            String pageNo = request.getParameter("pageNo");
            String pageSize = request.getParameter("pageSize");
            String orderField = request.getParameter("orderField");
            String orderType = request.getParameter("orderType");
            if(StringUtil.isNotNullAndEmpty(year) && StringUtil.isNotNullAndEmpty(payType) && StringUtil.isNotNullAndEmpty(pageNo) && StringUtil.isNotNullAndEmpty(pageSize) && StringUtil.isNotNullAndEmpty(orderField) && StringUtil.isNotNullAndEmpty(orderType)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                conditions.put("payType",payType);
                conditions.put("pageNo",pageNo);
                conditions.put("pageSize",pageSize);
                conditions.put("orderField",orderField);
                conditions.put("orderType",orderType);
                JSONObject reportByCustomerSignMost = reportService.getReportTop10ByCustomerSignMost(conditions);
                jsonObj.put("reportByCustomerSignMost",reportByCustomerSignMost);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)或者合同性质(payType)或分页编号(pageNo)或分页数量(pageSize)或排序字段(orderField)或排序类型(orderType)为空";
            }
        }else if("getReportByPayPlanYOY".equals(action)){
            String year = request.getParameter("year");
            if(StringUtil.isNotNullAndEmpty(year)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                JSONObject reportByPayPlanYOY = reportService.getReportByPayPlanYOY(conditions);
                jsonObj.put("reportByPayPlanYOY",reportByPayPlanYOY);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)为空";
            }
        }else if("getReportByPayPlan".equals(action)){
            String year = request.getParameter("year");
            if(StringUtil.isNotNullAndEmpty(year)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                JSONObject reportByPayPlan = reportService.getReportByPayPlan(conditions);
                jsonObj.put("reportByPayPlan",reportByPayPlan);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)为空";
            }
        }else if("getReportByRevPlan".equals(action)){
            String year = request.getParameter("year");
            if(StringUtil.isNotNullAndEmpty(year)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                JSONObject reportByRevPlan = reportService.getReportByRevPlan(conditions);
                jsonObj.put("reportByRevPlan",reportByRevPlan);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)为空";
            }
        }else if("getReportByRevdAndPaidYOY".equals(action)){
            String year = request.getParameter("year");
            if(StringUtil.isNotNullAndEmpty(year)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                JSONObject reportByRevdAndPaidYOY = reportService.getReportByRevdAndPaidYOY(conditions);
                jsonObj.put("reportByRevdAndPaidYOY",reportByRevdAndPaidYOY);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)为空";
            }
        }else if("getReportByUnPaidExceed".equals(action)){
            String year = request.getParameter("year");
            String pageNo = request.getParameter("pageNo");
            String pageSize = request.getParameter("pageSize");
            String orderField = request.getParameter("orderField");
            String orderType = request.getParameter("orderType");
            if(StringUtil.isNotNullAndEmpty(year) && StringUtil.isNotNullAndEmpty(pageNo) && StringUtil.isNotNullAndEmpty(pageSize) && StringUtil.isNotNullAndEmpty(orderField) && StringUtil.isNotNullAndEmpty(orderType)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                conditions.put("payType","0");
                conditions.put("pageNo",pageNo);
                conditions.put("pageSize",pageSize);
                conditions.put("orderField",orderField);
                conditions.put("orderType",orderType);
                JSONObject reportByExceed = reportService.getReportByExceed(conditions);
                jsonObj.put("reportByExceed",reportByExceed);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)或分页编号(pageNo)或分页数量(pageSize)或排序字段(orderField)或排序类型(orderType)为空";
            }
        }else if("getReportByUnRevdExceed".equals(action)){
            String year = request.getParameter("year");
            String pageNo = request.getParameter("pageNo");
            String pageSize = request.getParameter("pageSize");
            String orderField = request.getParameter("orderField");
            String orderType = request.getParameter("orderType");
            if(StringUtil.isNotNullAndEmpty(year) && StringUtil.isNotNullAndEmpty(pageNo) && StringUtil.isNotNullAndEmpty(pageSize) && StringUtil.isNotNullAndEmpty(orderField) && StringUtil.isNotNullAndEmpty(orderType)){
                Map<String,String> conditions = new HashMap<String,String>();
                conditions.put("year",year);
                conditions.put("payType","1");
                conditions.put("pageNo",pageNo);
                conditions.put("pageSize",pageSize);
                conditions.put("orderField",orderField);
                conditions.put("orderType",orderType);
                JSONObject reportByExceed = reportService.getReportByExceed(conditions);
                jsonObj.put("reportByExceed",reportByExceed);
                flag = true;
            }else{
                errorMessage = "查询失败，错误信息：年份(year)或分页编号(pageNo)或分页数量(pageSize)或排序字段(orderField)或排序类型(orderType)为空";
            }
        }
    }catch(ContractException e){
        errorMessage = "查询失败，错误信息："+e.getMessage();
    }
    jsonObj.put("flag",flag);
    jsonObj.put("errorMessage",errorMessage);
    out.print(jsonObj.toJSONString());
%>