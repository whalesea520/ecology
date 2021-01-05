<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.common.util.string.StringUtil"%>
<%@ page import="java.io.*"%>
<%@ page import="com.alibaba.fastjson.*"%>
<%@ page import="weaver.contractn.service.SignLocalService"%>
<%@ page import="weaver.contractn.serviceImpl.SignLocalServiceImpl"%>
<%@ page import="weaver.contractn.util.ZipUtils"%>
<%@ page import="weaver.general.GCONST"%>
<%@page import="weaver.contractn.util.WorkFlowConfig"%>
<%@ page import="weaver.contractn.exception.ContractException"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%  
    // User usr = HrmUserVarify.getUser(request, response);
    // int author = usr.getUID();
    // 是否处理成功
    boolean flag = false;
    // 返回前端信息
    String errorMessage = "";
    // 合同ID
    String contractId = request.getParameter("contractId");
    /*获取流程信息*/
    String workflowid = request.getParameter("workflowid");
    String formid = request.getParameter("formid");
    String requestid = request.getParameter("requestid");
    JSONObject formObj = new WorkFlowConfig().queryWrokFlowFormInfo(workflowid,formid,requestid);
    if(StringUtil.isNotNullAndEmpty(contractId)){
        String fileRealPath = "";
        rs.executeSql("select c.is_outside, f.filerealpath from  DocDetail d left join DocImageFile di ON d.id = di.docid left join ImageFile f ON f.imagefileid = di.imagefileid left join "+formObj.getString("tablename")+" c on d.id in(cast(c.file_upload as varchar(200))) where c.requestId= "+formObj.getString("requestid"));
        if(rs.next()){
            fileRealPath = rs.getString("filerealpath");
        }
        if(StringUtil.isNotNullAndEmpty(fileRealPath)){
            File file = new File(fileRealPath);
            // 去掉后缀名.zip
            String fileName = file.getName().substring(0,file.getName().lastIndexOf("."));
            // 获得应用的绝对跟路径
            String webRoot = GCONST.getRootPath();
            // 解压zip合同文件
            ZipUtils.unZip(fileRealPath,webRoot+"contract//sign//temp");
            // 解压后文件绝对路径
            String contractFilePath = webRoot+"contract//sign//temp//"+fileName;
            File contractFile = new File(contractFilePath);
            // 处理的合同文件路径
            String contractFileSignedPath = webRoot+"contract//sign//temp//SignByComplete"+fileName;
            File contractFileSignedFile = new File(contractFileSignedPath);
            // 调用契约锁SDK进行盖章并替换原文件
            SignLocalService localSignService = new SignLocalServiceImpl();
            InputStream cfInputStream = new FileInputStream(contractFile); 
            OutputStream cfOutputStream = new FileOutputStream(contractFileSignedPath);
            try{
                flag = localSignService.complete(cfInputStream,cfOutputStream);
            }catch(ContractException e){
            	rs.execute("select signed_state from "+formObj.getString("tablename") + " where requestid = "+requestid);
            	rs.next();
            	if("3".equals(rs.getString("signed_state"))){
            		errorMessage = "已经签署完毕，请审批流程";
            		flag = false;
            	}else{
            		errorMessage = "签署失败，错误信息："+e.getMessage()+"";
            	}
                
            }
            // 删除解压后的原始合同文件
            contractFile.delete();
            if(flag){
                // 记录已完成签署
                rs.executeSql("update "+formObj.getString("tablename")+" set signed_state=3 where requestId= "+formObj.getString("requestid"));
                // 将签署后的合同文件重命名为原始合同文件的名称
                File contractFileSignedFileRenamed = new File(contractFilePath); 
                contractFileSignedFile.renameTo(contractFileSignedFileRenamed);
                // 压缩新的合同文件并替换原来无契约锁处理的zip文件
                ZipUtils.zip(contractFilePath,fileRealPath);
                contractFileSignedFileRenamed.delete();
            }else{
                contractFileSignedFile.delete();
            }
        }else{
            errorMessage = "签署失败，错误信息：没有找到合同文件";
        }
    }else{
        errorMessage = "签署失败，错误信息：合同ID(contractId)为空";
    }
    JSONObject jsonObj = new JSONObject();
    jsonObj.put("flag",flag);
    jsonObj.put("errorMessage",errorMessage);
    out.print(jsonObj.toJSONString());
%>