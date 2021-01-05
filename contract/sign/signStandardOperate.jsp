<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.common.util.string.StringUtil"%>
<%@ page import="java.io.*"%>
<%@ page import="weaver.contractn.util.Constant"%>
<%@ page import="weaver.contractn.util.ZipUtils"%>
<%@ page import=" com.qiyuesuo.sdk.signer.AuthLevel"%>
<%@ page import="com.qiyuesuo.sdk.standard.Receiver"%>
<%@ page import="com.qiyuesuo.sdk.sign.Stamper"%>
<%@ page import="weaver.contractn.service.SignStandardService"%>
<%@ page import="weaver.contractn.serviceImpl.SignStandardServiceImpl"%>
<%@page import="com.qiyuesuo.sdk.standard.UserType"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%  
    // User usr = HrmUserVarify.getUser(request, response);
    // int author = usr.getUID();
    boolean flag = false;
    String message = "faild";
    String contractId = request.getParameter("contractId");
    String sealId = request.getParameter("sealId");
    if(StringUtil.isNotNullAndEmpty(contractId)){
		// 印章的页码及坐标
		String sealPageNum = request.getParameter("sealPageNum");
		String sealX = request.getParameter("sealX");
		String sealY = request.getParameter("sealY");
		
		// 查询合同文件路径
        rs.executeSql("select c.filerealpath from "+Constant.INFO_TABLENAME+" a,docimagefile b,ImageFile c where a.file_upload=b.id and b.imagefileid=c.imagefileid and a.id='"+contractId+"'");
        String filerealpath = "";
        if(rs.next()){
            filerealpath = rs.getString("filerealpath");
        }
        if(StringUtil.isNotNullAndEmpty(filerealpath)){
            File file = new File(filerealpath);
            // 去掉后缀名
            String fileName = file.getName().substring(0,file.getName().lastIndexOf("."));
            // 获得应用的绝对跟路径
            String webroot = application.getRealPath("/");
            //System.out.println(filerealpath);
            //System.out.println(fileName);
            //System.out.println(webroot);
            // 解压zip合同文件
            ZipUtils.unZip(filerealpath,webroot+"contract//sign//temp");
            // 解压后文件绝对路径
            String contractFilePath = webroot+"contract//sign//temp//"+fileName;
            
            // 查询客户相关信息
            rs.executeSql("select b.type,b.authlevel,b.name,c.mobilephone from "+Constant.INFO_TABLENAME+" a,crm_customerinfo b,CRM_CustomerContacter c where a.customer=b.id and a.customer=c.customerid and a.id='"+contractId+"'");
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
	        Receiver receiver = new Receiver();
	        // 接收人类型（公司/个人）
	        if(type.equals("11")){
	            receiver.setType(UserType.PERSONAL);    
	        }else{
	            receiver.setType(UserType.COMPANY);
	        }
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
	        
	        SignStandardService signStandardService = new SignStandardServiceImpl();
            File contractFile = new File(contractFilePath);
            String subject = contractFile.getName();
            InputStream inputStream = new FileInputStream(contractFile);
            Long documentId = 0l;
            documentId = signStandardService.create(inputStream, receivers, subject);
            if(documentId != 0l){
                // 合同创建成功
                rs.executeSql("update "+Constant.INFO_TABLENAME+" set documentid='"+documentId+"' where id='"+contractId+"'");
                // 签署合同
                Stamper stamper = new Stamper(sealPageNum, Float.valueOf(sealX), Float.valueOf(sealY));
                flag = signStandardService.sign(documentId,Long.valueOf(sealId),stamper);
            }
        }
    }
    if(flag){
        // 记录甲方已签署
        rs.executeSql("update "+Constant.INFO_TABLENAME+" set signed_jf=1 where id='"+contractId+"'");
        message="success";
    }
    out.print(message);
%>