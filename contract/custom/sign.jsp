<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.alibaba.fastjson.*"%>
<%@page import="weaver.contractn.util.Constant"%>
<jsp:useBean id="fileService" class="weaver.contractn.serviceImpl.FileServiceImpl" scope="page" />
<jsp:useBean id="sealEntity" class="weaver.contractn.entity.SealEntity" scope="page" />
<jsp:useBean id="seal" class="weaver.contractn.serviceImpl.SealServiceImpl" scope="page" />
<jsp:useBean id="fileHandle" class="weaver.contractn.util.FileHandle" scope="page" />
<jsp:useBean id="selectItem" class="weaver.contractn.serviceImpl.SelectItemServiceImpl" scope="page" />

<%
    int username = Integer.parseInt(request.getParameter("user"));
    sealEntity.setType(Constant.CHARACTER_TYPE_SEAL_SELECTITEM);
    sealEntity.setCustomer(username);
    sealEntity.setIsDefault(selectItem.querySelectItemInfo(Constant.SEAL_TABLENAME,"is_default").get(Constant.ISNOTDEFAULT));
    sealEntity.setStatus(selectItem.querySelectItemInfo(Constant.SEAL_TABLENAME,"status").get(Constant.INVALID_STATUS_SEAL_SELECTITEM));
    String sealid = seal.sava(sealEntity);
    if(null != sealid){
        JSONArray array = fileHandle.uploadFile(request).getJSONArray("fileItem");
        out.print(fileService.save(array,"seal",sealid,0));
    }else{
        out.print(Constant.FAILURE);
    }
    



    
%>

