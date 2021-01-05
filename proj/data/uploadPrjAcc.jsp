<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="deu" class="weaver.docs.docs.DocExtUtil" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	
	String currentDate = TimeUtil.getCurrentDateString();
	String currentTime = TimeUtil.getOnlyCurrentTimeString();
	
	FileUpload fu = new FileUpload(request,"utf-8");
	String method=Util.null2String(fu.getParameter("method"));
	int secId=Util.getIntValue(fu.getParameter("secid"),0);
	
	rs.executeSql("select t1.id,t1.subcategoryid,t2.maincategoryid, t1.maxUploadFileSize from DocSecCategory t1,DocSubCategory t2 where t1.subcategoryid=t2.id and t1.id="+secId);
	rs.next();
	int mainId=Util.getIntValue(rs.getString("maincategoryid"),0);
	int subId=Util.getIntValue(rs.getString("subcategoryid"),0);

	StringBuffer restr = new StringBuffer();
	int docid=0;
	if(secId>0){
		docid=deu.uploadDocToImg (fu,user, "Filedata",mainId,subId,secId,"","");
	}
	
	
	//返回值
	restr.append("{");
	restr.append("newDocId:\""+docid+"\"");
	restr.append("}");
	
	//System.out.println("restr="+restr);
	
	out.println(restr.toString());
%>