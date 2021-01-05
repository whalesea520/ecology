<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.alibaba.fastjson.*"%>
<%@page import="weaver.contractn.util.Constant"%>
<jsp:useBean id="fileService"
	class="weaver.contractn.serviceImpl.FileServiceImpl" scope="page" />
<jsp:useBean id="sealEntity" class="weaver.contractn.entity.SealEntity"
	scope="page" />
<jsp:useBean id="seal"
	class="weaver.contractn.serviceImpl.SealServiceImpl" scope="page" />
<jsp:useBean id="fileHandle" class="weaver.contractn.util.FileHandle"
	scope="page" />
<jsp:useBean id="selectItem"
	class="weaver.contractn.serviceImpl.SelectItemServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>

<%
    int username = user.getUID();
	String action = request.getParameter("action");
	String type = request.getParameter("type");
    if ("query".equals(action)) {
        sealEntity.setCustomer(username);
        sealEntity.setType(selectItem.querySelectItemInfo(Constant.SEAL_TABLENAME, "type").get(request.getParameter("type")));
        out.print(seal.querySealInfo(sealEntity));
        
    } else if ("modify".equals(action)) {
        if (Constant.SIGNET_TYPE_SEAL_SELECTITEM.equals(type)) {
            String status = request.getParameter("status");
            String id = request.getParameter("id");
            sealEntity.setStatus(status);
            sealEntity.setType(type);
            sealEntity.setId(id);
            out.print(seal.update(sealEntity));
        } else {
            String is_default = request.getParameter("is_default");
            String id = request.getParameter("id");
            sealEntity.setIsDefault(is_default);
            sealEntity.setId(id);
            sealEntity.setType(type);
            out.print(seal.update(sealEntity));
        }
    } else if ("del".equals(action)) {
        String id = request.getParameter("id");
        out.print(seal.delete(id));
    } else {
    	JSONObject formObj = fileHandle.uploadFile(request);
    	type = formObj.get("type").toString();
        if (Constant.SIGNET_TYPE_SEAL_SELECTITEM.equals(type)) {//印章
            sealEntity.setStatus(selectItem.querySelectItemInfo(Constant.SEAL_TABLENAME, "status").get(Constant.INVALID_STATUS_SEAL_SELECTITEM));//默认停用
        } else {//签名
            //type = selectItem.querySelectItemInfo(Constant.SEAL_TABLENAME, "type").get(request.getParameter("type"));
            sealEntity.setIsDefault(selectItem.querySelectItemInfo(Constant.SEAL_TABLENAME, "is_default").get(Constant.ISNOTDEFAULT));
        }
        sealEntity.setType(type);
        sealEntity.setCustomer(username);
        String sealid = seal.sava(sealEntity);
        if (null != sealid) {
            out.print(fileService.save((JSONArray)formObj.get("fileItem"),"seal",sealid,0));
        } else {
            out.print(Constant.FAILURE);
        }

    }
%>

