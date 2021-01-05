
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
   FileUpload fu = new FileUpload(request,"UTF-8",false);
   String ename = Util.null2String(request.getParameter("ename"));
   if("".equals(ename)){
	   ename="imgFile";
   }else{
	   ename="imgFile_"+ename;
   }
   String imagefileid=fu.uploadFiles(ename);
   String docname = fu.getFileName();

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
            Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
            Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
            Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
            Util.add0(today.get(Calendar.SECOND), 2) ;
	int docid = Util.getIntValue(Util.null2String(fu.getParameter("docid")),0);
	rs.executeSql("insert into ImageFileTempPic(imagefileid,docid,createid,createdate,createtime) values("+imagefileid+","+docid+","+user.getUID()+",'"+currentdate+"','"+currenttime+"')");

   JSONObject obj = new JSONObject();
   obj.put("error", new Integer(0));
   obj.put("url", "/weaver/weaver.file.FileDownload?fileid="+imagefileid);
   obj.put("name", docname);
   
   response.setContentType("text/html;charset=UTF-8");
   PrintWriter outer = response.getWriter();
   outer.println(obj.toString());
%>
