
<%@ page language="java" contentType="text/xml; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.conn.RecordSet"%>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@page import="org.json.JSONObject"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String subject= Util.null2String(request.getParameter("subject"));
subject=Util.toHtml(subject);
//String subject = java.net.URLDecoder.decode(Util.null2String(request.getParameter("subject")));
String secid = Util.null2String(request.getParameter("secid"));
String docid = Util.null2String(request.getParameter("docid"));

String sql = "";
boolean secNoRepeatedName = false;

secNoRepeatedName = SecCategoryComInfo.isNoRepeatedName(Util.getIntValue(secid));
JSONObject jsonObj = new JSONObject();
if(secNoRepeatedName){
    //sql = " select count(0) from DocDetail d where docsubject = '" + subject + "' ";
    sql = " select count(0) from DocDetail d where docsubject = '" + subject + "'   and (ishistory is null or ishistory = 0) ";
    if(secNoRepeatedName) sql += " and seccategory = " + secid;
    if(!"".equals(docid))
        sql += " and id not in " +
        	   " ( " +
        	   " select id from DocDetail " +
        	   " where id = " + docid +
        	   " or doceditionid in " + 
        	   " ( " +
        	   " select doceditionid from DocDetail " +
        	   " where id = " + docid +
        	   " and doceditionid > 0 " +
        	   " and (doceditionid is not null) " +
        	   " ) " +
        	   " ) ";
    
    RecordSet.executeSql(sql);
    
    if(RecordSet.next()){
    	jsonObj.put("num",RecordSet.getString(1));
    } else {
    	jsonObj.put("num",0);
    }
} else {
	jsonObj.put("num",0);
}
out.println(jsonObj);
%>