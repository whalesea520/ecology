<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.common.util.string.StringUtil"%>
<%@ page import="java.io.*"%>
<%@ page import="weaver.general.BaseBean"%>
<%@ page import="com.alibaba.fastjson.*"%>
<%@ page import="weaver.contractn.util.Constant"%>
<%@ page import="weaver.contractn.service.SignLocalService"%>
<%@ page import="weaver.contractn.serviceImpl.SignLocalServiceImpl"%>
<%@ page import="weaver.contractn.util.ZipUtils"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.contractn.exception.ContractException"%>
<%@page import="weaver.contractn.util.WorkFlowConfig"%>
<%@ page import="weaver.contractn.service.SignStandardService"%>
<%@ page import="weaver.contractn.serviceImpl.SignStandardServiceImpl"%>
<%@ page import=" com.qiyuesuo.sdk.signer.AuthLevel"%>
<%@ page import="com.qiyuesuo.sdk.standard.Receiver"%>
<%@ page import="com.qiyuesuo.sdk.sign.Stamper"%>
<%@page import="com.qiyuesuo.sdk.standard.UserType"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SeleteItem" class="weaver.contractn.serviceImpl.SelectItemServiceImpl" scope="page" />
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
    // 印章ID
    String sealId = request.getParameter("sealId");
    /*获取流程信息*/
    String workflowid = request.getParameter("workflowid");
    String formid = request.getParameter("formid");
    String requestid = request.getParameter("requestid");
    JSONObject formObj = new WorkFlowConfig().queryWrokFlowFormInfo(workflowid,formid,requestid);
    
    String signedState = "";
    String sign_mode = "";
    if(StringUtil.isNotNullAndEmpty(contractId) || StringUtil.isNotNullAndEmpty(sealId)){
        rs.execute("select signed_state ,sign_mode from "+formObj.getString("tablename")+" where requestid='"+requestid+"'");
        if(rs.next()){
            signedState = rs.getString("signed_state");
            sign_mode = rs.getString("sign_mode");
        }
        if(!signedState.equals("1") || !signedState.equals("2")&&!signedState.equals("3")){
            String fileRealPath = "";
            String contractName = "";
           	String sql = "select f.filerealpath, c.name from  DocDetail d left join DocImageFile di ON d.id = di.docid left join ImageFile f ON f.imagefileid = di.imagefileid left join "+formObj.getString("tablename")+" c on d.id in(cast(c.file_upload as varchar(200))) where c.requestid="+formObj.getString("requestid");
            rs.execute(sql);
            if(rs.next()){
                fileRealPath = rs.getString("filerealpath");
                contractName = rs.getString("name");
            }
            if(StringUtil.isNotNullAndEmpty(fileRealPath)){
                // 印章的页码及坐标
                int sealPageNum = Integer.parseInt(request.getParameter("sealPageNum"));
                String sealX = request.getParameter("sealX");
                String sealY = request.getParameter("sealY");
                if(StringUtil.isNotNullAndEmpty(sealX)&&StringUtil.isNotNullAndEmpty(sealY)){
                    File file = new File(fileRealPath);
                    // 去掉后缀名.zip
                    String fileName = file.getName();
                    if(fileName.contains(".zip")){
                    	fileName = file.getName().substring(0,file.getName().lastIndexOf("."));
                    }
                    // 获得应用的绝对跟路径
                    String webRoot = GCONST.getRootPath();
                    // 解压zip合同文件
                    ZipUtils.unZip(fileRealPath,webRoot+"contract\\sign\\temp");
                    // 解压后文件绝对路径
                    String contractFilePath = webRoot+"contract\\sign\\temp\\"+fileName;
                    File contractFile = new File(contractFilePath);
                 	// 签署的合同文件路径
                    String contractFileSignByPlatformPath = webRoot+"contract//sign//temp//SignByPlatformPath"+fileName;
                    File contractFileSignedFile = new File(contractFileSignByPlatformPath);
                    // 输入文件路径
                    InputStream inputStream = new FileInputStream(contractFile); 
                    //签署后文件存放的路径
                    OutputStream outputStream = new FileOutputStream(contractFileSignByPlatformPath);
                    if("1".equals(sign_mode)){/*如果是远程签 update by zl*/
                    	// 查询客户相关信息
                        rs.executeSql("select b.type,p.authlevel,b.name,c.mobilephone from "+formObj.getString("tablename")+" a,crm_customerinfo b,CRM_CustomerContacter c ,"+Constant.TYPE_TABLENAME+" p where a.type = p.id and a.customer=b.id and a.customer=c.customerid and a.requestid='"+requestid+"'");
                        // 接收人类型
                        String type = "";
                        // 客户认证级别
                        String authlevel = "";
                        // 客户名称
                        String name = "";
                        // 联系电话
                        String mobilephone = "";
                        if(rs.next()){
                            type = rs.getString("type");
                            authlevel = rs.getString("authlevel");
                            name = rs.getString("name");
                            mobilephone = rs.getString("mobilephone");
                        }
                        
                        // 创建合同
            	        Receiver receiverSender = new Receiver();
            	        // 接收人类型（公司/个人）
            	        receiverSender.setType(UserType.PLATFORM);
            	        /*发起方签署位置第一位*/
            	        receiverSender.setOrdinal(1);
            	        Receiver receiver = new Receiver();
            	        receiver.setType(UserType.COMPANY);
            	        receiver.setOrdinal(2);
            	        // 认证级别（BASIC["基本认证"],FULL["完全认证"]）
            	        if(authlevel.equals("0")){
            	            receiver.setAuthLevel(AuthLevel.BASIC);    
            	        }else{
            	            receiver.setAuthLevel(AuthLevel.FULL);
            	        }
            	        // 接收人名称（公司名称/用户姓名）
            	        receiver.setName(name);
            	        // 接收人手机号（公司经办人手机号/用户手机号）
            	        receiver.setMobile(mobilephone);
            	        List<Receiver> receivers = new ArrayList<Receiver>();
            	        receivers.add(receiver);
            	        receivers.add(receiverSender);
            	        SignStandardService signStandardService = new SignStandardServiceImpl();
                        String subject = contractName;
                        Long documentId = 0l;
                    	 // 合同创建成功
                        documentId = signStandardService.create(inputStream, receivers, subject);
                        if(documentId != 0l){
                            rs.execute("update "+formObj.getString("tablename")+" set documentid='"+documentId+"' where requestid='"+requestid+"'");
                            // 签署合同
                            Stamper stamper = new Stamper(sealPageNum, Float.valueOf(sealX), Float.valueOf(sealY));
                            flag = signStandardService.sign(documentId,Long.valueOf(sealId),stamper);
                            if(flag){
                            	signStandardService.downloadDoc(documentId,outputStream);
                            }
                        }
                    }else{
	                    try{// 调用平台签接口
	                    	SignLocalService localSignService = new SignLocalServiceImpl();
	                        flag = localSignService.signByPlatform(inputStream,outputStream, sealPageNum,Float.parseFloat(sealX),Float.parseFloat(sealY),Long.parseLong(sealId));
	                    }catch(ContractException e){
	                        errorMessage = "签署失败，错误信息："+e.getMessage()+"";
	                    }
                   }
                    // 删除解压后的原始合同文件
                    contractFile.delete();
                    if(flag){
                        // 记录甲方已签署
                        rs.execute("update "+formObj.getString("tablename")+" set signed_state=1 where requestId="+formObj.getString("requestid"));
                        // 将签署后的合同文件重命名为原始合同文件的名称
                        File contractFileSignedFileRenamed = new File(contractFilePath); 
                        contractFileSignedFile.renameTo(contractFileSignedFileRenamed);
                        new BaseBean().writeLog("tablename =="+formObj.getString("tablename")+"+++contractFilePath=="+contractFilePath+"+++fileRealPath"+fileRealPath);
                        // 压缩新的合同文件并替换原来无契约锁处理的zip文件
                        ZipUtils.zip(contractFilePath,fileRealPath);
                        contractFileSignedFileRenamed.delete();
                    }
                        contractFileSignedFile.delete();
                    
                }else{
                    errorMessage = "签署失败，错误信息：页码(sealPageNum)或者坐标(sealX，sealY)为空";
                }
            }else{
                errorMessage = "签署失败，错误信息：没有找到合同文件";
            }
        }else{
            errorMessage = "签署失败，错误信息：合同已经签署或者未配置signed_state字段";
        }
    }else{
        errorMessage = "签署失败，错误信息：此合同已经签署，签署状态(signed_state="+signedState+")";
    }
    JSONObject jsonObj = new JSONObject();
    jsonObj.put("flag",flag);
    jsonObj.put("errorMessage",errorMessage);
    out.print(jsonObj.toJSONString());
%>