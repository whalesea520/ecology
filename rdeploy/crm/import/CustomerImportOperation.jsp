<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.*"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="org.json.*" %>
<%@ page import="java.io.*"%>
<%@ page import="weaver.file.FileManage"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="crmExcelToDB"
	class="weaver.crm.ExcelToDB.RdeployCrmExcelToDB" scope="page" />
<%
try {
	User user = HrmUserVarify.getUser(request, response);
	if (user == null) {
	    response.sendRedirect("/login/Login.jsp");
	    return;
	}
	
	response.setHeader("cache-control", "no-cache"); 
	response.setHeader("pragma", "no-cache");
	
	int fileid = Integer.parseInt(request.getParameter("fileid"));
	int isCover = Integer.parseInt(request.getParameter("isCover"));
	FileManage fm = new FileManage();

	String excelFilePath="";
	String uploadfilepath="";
    String filename="";
    String filetype = "";
    String sql = "select imagefilename,filerealpath from imagefile where imagefileid = "+fileid;
    RecordSet.executeSql(sql);
    
    if(RecordSet.next()){
        uploadfilepath =  RecordSet.getString("filerealpath");
        filename =  RecordSet.getString("imagefilename");
        filename = filename.substring(0,filename.lastIndexOf("."));
    }
		filetype = uploadfilepath.substring(uploadfilepath.lastIndexOf("."));
		filename += filetype;
 	if(!uploadfilepath.equals("")){
 	    excelFilePath = GCONST.getRootPath()+"rdeploy/crm/import/temp/"+user.getUID()+File.separatorChar+filename ;
        fm.copy(uploadfilepath,excelFilePath);
        
    }
 	
 	crmExcelToDB.setUser(user);
 	crmExcelToDB.setIsCover(isCover);
 	crmExcelToDB.excelToDB(excelFilePath);
	
	int total = crmExcelToDB.getTotal();
	int success = crmExcelToDB.getSuccess();
	int fail = crmExcelToDB.getFail();
	boolean isNoData = crmExcelToDB.isNoData();
	
	JSONObject obj = new JSONObject();
	obj.put("total",total);
	obj.put("success",success);
	obj.put("fail",fail);
	obj.put("isNoData",isNoData);
	obj.put("errorIds",JSONArray.fromObject(crmExcelToDB.getErrorRowIdList()).toString());
	obj.put("errorList",JSONArray.fromObject(crmExcelToDB.getErrorList()).toString());
	obj.put("mustCallList",JSONArray.fromObject(crmExcelToDB.getMustCallList()).toString());
	
	out.println(obj.toString());
	
	
}
catch(Exception e) {

}

%>
