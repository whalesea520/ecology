<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.api.workflow.service.DocNoticeService"%>
<%@page import="weaver.general.Util,java.util.List,java.util.ArrayList,java.util.Map,java.util.HashMap" %>


    <%
    DocNoticeService docNoticeService = new DocNoticeService();
    String folderIds = request.getParameter("folderIds");
    int pageCount = Util.getIntValue(request.getParameter("pageCount"),0);
    int pageNum = Util.getIntValue(request.getParameter("pageNum"),0);
    String returnFields = request.getParameter("returnFields");
    
    List<String> fields = new ArrayList<String>();
    if(returnFields != null){
        for(String field : returnFields.split(",")){
            fields.add(field);
        }
    }
    
    Map<String,String> params = new HashMap<String,String>();
    
    String docTitle = Util.null2String(request.getParameter("docTitle"));
    String gtCreateDate = Util.null2String(request.getParameter("gtCreateDate"));
    String ltCreateDate = Util.null2String(request.getParameter("ltCreateDate"));
    String gtUpdateDate = Util.null2String(request.getParameter("gtUpdateDate"));
    String ltUpdateDate = Util.null2String(request.getParameter("ltUpdateDate"));
    
    params.put("docTitle",docTitle);
    params.put("gtCreateDate",gtCreateDate);
    params.put("ltCreateDate",ltCreateDate);
    params.put("gtUpdateDate",gtUpdateDate);
    params.put("ltUpdateDate",ltUpdateDate);
    
    String rData = docNoticeService.getDocListForFolderIds(folderIds,pageCount,pageNum,fields,params);
    
    out.println(rData);    
    %>

