<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.common.util.string.StringUtil"%>
<%@ page import="java.io.*"%>
<%@ page import="com.alibaba.fastjson.*"%>
<%@ page import="weaver.contractn.util.Constant"%>
<%@ page import="weaver.contractn.service.SignLocalService"%>
<%@ page import="weaver.contractn.serviceImpl.SignLocalServiceImpl"%>
<%@ page import="weaver.contractn.util.ZipUtils"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.contractn.exception.ContractException"%>
<%@ page import="com.qiyuesuo.sdk.signer.Company"%>
<%@ page import="com.qiyuesuo.sdk.signer.Person"%>
<%@ page import="weaver.contractn.util.FileHandle"%>
<%@page import="weaver.contractn.util.WorkFlowConfig"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="selectItem" class="weaver.contractn.serviceImpl.SelectItemServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%  
    JSONObject jsonObj = new JSONObject();
    // User usr = HrmUserVarify.getUser(request, response);
    // int author = usr.getUID();
    // 是否处理成功
    boolean flag = false;
    // 返回前端信息
    String errorMessage = "";
    // 合同ID
    String contractId = request.getParameter("contractId");
    String sealId = request.getParameter("sealId");
    
    /*获取流程信息*/
    String workflowid = request.getParameter("workflowid");
    String formid = request.getParameter("formid");
    String requestid = request.getParameter("requestid");
    JSONObject formObj = new WorkFlowConfig().queryWrokFlowFormInfo(workflowid,formid,requestid);
    
    // 签章或签名ID
    if(StringUtil.isNotNullAndEmpty(contractId) &&  StringUtil.isNotNullAndEmpty(sealId)){
        String fileRealPath = "";
        String isOutSide = "";
        rs.executeSql("select c.is_outside, f.filerealpath from  DocDetail d left join DocImageFile di ON d.id = di.docid left join ImageFile f ON f.imagefileid = di.imagefileid left join "+formObj.getString("tablename")+" c on d.id in(cast(c.file_upload as varchar(200))) where c.requestid="+formObj.getString("requestid"));
            if(rs.next()){
                fileRealPath = rs.getString("filerealpath");
                isOutSide = rs.getString("is_outside");
            }
        //}
        if(StringUtil.isNotNullAndEmpty(fileRealPath)){
	            // 印章的页码及坐标
	            String sealPageNum = request.getParameter("sealPageNum");
	            String sealX = request.getParameter("sealX");
	            String sealY = request.getParameter("sealY");
	            if(StringUtil.isNotNullAndEmpty(sealPageNum)&&StringUtil.isNotNullAndEmpty(sealX)&&StringUtil.isNotNullAndEmpty(sealY)){
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
	                // 签署的合同文件路径
	                String contractFileSignedPath = webRoot+"contract//sign//temp//SignedPath"+fileName;
	                File contractFileSignedFile = new File(contractFileSignedPath);
	                // 调用契约锁SDK进行盖章并替换原文件
	                SignLocalService localSignService = new SignLocalServiceImpl();
	                InputStream cfInputStream = new FileInputStream(contractFile); 
	                OutputStream cfOutputStream = new FileOutputStream(contractFileSignedPath);
	                // 客户名称
	                String name = "";
	                // 联系电话
	                String mobile = "";
	                
	                if(Constant.EMPLOYEE_ISOUTSIDE_INFO_SELECTITEM.equals(selectItem.querySelectItemInfoKeyValue(Constant.INFO_TABLENAME,"is_outside").get(isOutSide))){
	                	 // 查询员工相关信息
	                    rs.executeSql("select b.lastname as name,b.mobile as mobilephone from "+formObj.getString("tablename")+" a,hrmresource b where a.employee=b.id and a.requestId= "+formObj.getString("requestid"));
	                    if(rs.next()){
	                        name = rs.getString("name");
	                        mobile = rs.getString("mobilephone");
	                    }
	                }else{
	                	 // 查询客户相关信息
	                	 
	                    rs.executeSql("select b.name,c.mobilephone from "+formObj.getString("tablename")+" a,crm_customerinfo b,CRM_CustomerContacter c where a.customer=b.id and a.customer=c.customerid and a.requestId= "+formObj.getString("requestid"));
	                    if(rs.next()){
	                        name = rs.getString("name");
	                        mobile = rs.getString("mobilephone");
	                	}
	                }	
	                
	                if(StringUtil.isNotNullAndEmpty(name) && StringUtil.isNotNullAndEmpty(mobile)){
	                    rs.executeSql("select f.path_file,real_name from "+Constant.FILE_TABLENAME+" f left join "+Constant.SEAL_TABLENAME+" s on f.data_id = s.id where s.id ="+sealId);
	                    if(rs.next()){
	                    	String path_file = rs.getString("path_file");
	                        String real_name = rs.getString("real_name");
	                        String pngFilePath = path_file +"/"+ real_name;
	                        String sealData = FileHandle.getImageFile(pngFilePath);
	                        
	                        if(Constant.EMPLOYEE_ISOUTSIDE_INFO_SELECTITEM.equals(selectItem.querySelectItemInfoKeyValue(Constant.INFO_TABLENAME,"is_outside").get(isOutSide))){
	                            // 如果是个人签
	                            Person person = new Person(name);
	                            person.setMobile(mobile);
	                            try{
	                                flag = localSignService.signByPerson(cfInputStream,cfOutputStream,person, Integer.parseInt(sealPageNum),Float.parseFloat(sealX),Float.parseFloat(sealY),sealData);
	                            }catch(ContractException e){
	                                errorMessage = "签署失败，个人签，错误信息："+e.getMessage()+"";
	                            }
	                        }else{
	                            // 如果是公司签
	                            Company company = new Company(name);
	                            company.setTelephone(mobile);
	                            try{
	                                flag = localSignService.signByCompany(cfInputStream,cfOutputStream,company, Integer.parseInt(sealPageNum),Float.parseFloat(sealX),Float.parseFloat(sealY),sealData);
	                            }catch(ContractException e){
	                                errorMessage = "签署失败，公司签，错误信息："+e.getMessage()+"";
	                            }
	                        }
	                        // 删除解压后的原始合同文件
	                        contractFile.delete();
	                        if(flag){
	                            // 记录乙方已签署
	                            rs.executeSql("update "+formObj.getString("tablename")+" set signed_state=2 where requestId="+formObj.getString("requestid"));
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
	                        errorMessage = "签署失败，错误信息：根据(sealId)没有找到签章或签名图片文件";
	                    }
	                }else{
	                    errorMessage = "签署失败，错误信息：签署人的名称或手机号为空";
	                }
	            }else{
	                errorMessage = "签署失败，错误信息：页码(sealPageNum)或者坐标(sealX，sealY)为空";
	            }
        }else{
            errorMessage = "签署失败，错误信息：没有找到合同文件";
        }
    }else{
        errorMessage = "签署失败，错误信息：合同ID(contractId)或者印章ID(sealId)";
    }
    jsonObj.put("flag",flag);
    jsonObj.put("errorMessage",errorMessage);
    out.print(jsonObj.toJSONString());
%>