
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=UTF-8");
	
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	
	FileUpload fu = new FileUpload(request,"utf-8");
	String method = Util.null2String(fu.getParameter("method"));
	
	//添加页面
	if("add".equals(method)){
		int docid = Util.getIntValue(fu.uploadFiles("Filedata"), 0);
		out.println(docid);
		return;
	}
	String usetable = Util.null2String(fu.getParameter("usetable"));
	String fieldName = Util.null2String(fu.getParameter("fieldName"));
	String primaryKeyId = Util.null2String(fu.getParameter("primaryKeyId"));
	if("edit".equals(method)){
		int docid = Util.getIntValue(fu.uploadFiles("Filedata"), 0);
		rs.execute("select "+fieldName +" from "+usetable+" where id = "+primaryKeyId);
		rs.next();
		String fieldValue = Util.null2String(rs.getString(1));
		
		fieldValue = fieldValue.equals("")?docid+"":fieldValue+","+docid;
		rs.execute("update "+usetable+" set "+fieldName+" = '"+fieldValue+"' where id = "+primaryKeyId);
		//byte[] tmpbyte = sb.toString().getBytes();
		out.println(docid);
		return;
	}
	
	
%>
