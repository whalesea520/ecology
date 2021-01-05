<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.docs.docs.*"%>
<jsp:useBean id="deu" class="weaver.docs.docs.DocExtUtil" scope="page"/>
<jsp:useBean id="cd" class="weaver.cowork.CoworkDAO" scope="page"/>
<%
	//协作上传附件
	request.setCharacterEncoding("UTF-8");
	int status = 1;String msg = "";
	FileUpload fu = new FileUpload(request);
	String operation = Util.null2String(fu.getParameter("operation"));
	JSONObject result = new JSONObject();
	try{
		if(operation.equals("coworkfileupload")){
			User user = HrmUserVarify.getUser (request , response) ;
			if(user!=null) {
				String docid = deu.uploadToImagefile(fu,user,"accessorys", "", "", "")+"";
				result.put("docid", docid);
				status = 0;
				//String typeid = Util.null2String(fu.getParameter("typeid"));
				//if(!typeid.equals("")){
				//	Map map = cd.getAccessoryDir(typeid);
				//	int mainId = Util.getIntValue(Util.null2String(map.get("mainId")),0);
				//	int subId = Util.getIntValue(Util.null2String(map.get("subId")),0);
				//	int secId = Util.getIntValue(Util.null2String(map.get("secId")),0);
				//    String fileName = Util.null2String(fu.getParameter("fileName"));
				//    
				//	String docid = deu.uploadDocToImg(fu,user,"accessorys",mainId,subId,secId,fileName,"")+"";
				//	result.put("docid", docid);
				//	status = 0;
				//}else{
				//	msg = "没有获取到协作板块";
				//}
			}else{
				msg = "没有获取到用户信息";
			}
		}
	}catch(Exception e){
		msg = "程序异常:"+e.getMessage();
		e.printStackTrace();
	}
	result.put("status", status);
	result.put("msg", msg);
	out.println(result);
%>