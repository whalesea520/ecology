<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.alibaba.fastjson.*"%>
<%@ page import="weaver.contractn.service.SealOfQService"%>
<%@ page import="weaver.contractn.serviceImpl.SealOfQServiceImpl"%>
<%@ page import="weaver.contractn.entity.SealOfQEntity"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="weaver.contractn.exception.ContractException"%>
<%@page import="weaver.general.BaseBean"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
    User usr = HrmUserVarify.getUser(request, response);
    int usrId = usr.getUID();
    String action = request.getParameter("action");
    List<JSONObject> array = new ArrayList<JSONObject>();
    JSONObject resultObj = new JSONObject();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String msgcode = "";
    String status = "";
    if(action.equals("getSealByJF")){
    	try{
    		SealOfQService sealOfQService = new SealOfQServiceImpl();
    		 List<SealOfQEntity> list = sealOfQService.getSeals();
    		 for(SealOfQEntity entity : list){
    	            JSONObject jsonObj = new JSONObject();
    	            jsonObj.put("id",String.valueOf(entity.getId()));
    	            jsonObj.put("name",entity.getName());
    	            jsonObj.put("createTime",sdf.format(entity.getCreateTime()));
    	            jsonObj.put("imagePath","/"+sealOfQService.getSealImage(entity.getId()));
    	            array.add(jsonObj);
    	        } 
 			status = "success";
    		}catch(ContractException e){
    			new BaseBean().writeLog("获取印章失败："+e.getMessage());
    			msgcode = "您未配置或开启正确的电子签署服务，请在后台进行配置并启用！";
    			status = "interfaceException";
    	}
    		resultObj.put("status",status);
    		resultObj.put("msgcode",msgcode);
    		resultObj.put("datas",array);
    		out.print(resultObj.toString());
          
    }else if(action.equals("getSealByYF")){
        rs.executeSql("select a.png_file,a.type as signType,a.is_default as isDefault,b.imagefileid from uf_t_cons_seal a,docimagefile b where a.customer='"+usrId+"' and cast(a.png_file as varchar)=b.docid");
        while(rs.next()){
            String id = rs.getString("png_file");
            String signType = rs.getString("type");
            String isDefault = rs.getString("is_default");
            String imageFileId = rs.getString("imagefileid");
            String imagePath = "/weaver/weaver.file.FileDownload?fileid="+imageFileId+"&download=1&requestid=-1";
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("id",id);
            jsonObj.put("signType",signType);
            jsonObj.put("isDefault",isDefault);
            jsonObj.put("imagePath",imagePath);
            array.add(jsonObj);
        }
        out.print(array.toString());
    }
    
%>