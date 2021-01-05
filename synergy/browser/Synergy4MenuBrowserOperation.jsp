
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.multidocupload.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
StringBuffer sb=new  StringBuffer();
sb.append("[");
String id=Util.null2String(request.getParameter("id"));
String stype = Util.null2String(request.getParameter("stype"));
int userLanguage = Util.getIntValue(request.getParameter("language"));
if(stype.equals("wf"))stype="workflow";
if(!id.equals("")){
	id=(String)id.split("_")[1];
}
 //System.out.println("============id:"+id);
String wherestr=" where frommodule='"+stype+"' and wfid =0 ";
if(id.equals("")){
	sb.append("{name:\"全部\", id:\"q_0\", isParent:true ,open:true}");
	rs.executeSql("select id,modulename from synergy_base   "+wherestr+"   order by orderkey");
	while(rs.next()){
		String typeId=Util.null2String(rs.getString("id"));
		String typeName=SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("modulename")),userLanguage);	
		   if(sb.toString().indexOf(",")>1){
			  sb.append(",{ id:\"q_"+typeId+"\", pId:\"q_0\", name:\""+typeName+"\",isParent:false}");
			}else{
				sb.append("{ id:\"q_"+typeId+"\", pId:\"q_0\", name:\""+typeName+"\",isParent:false}");
			}
	}
}
sb.append("] ");

//System.out.println("============:"+sb.toString());
out.println(sb.toString());
%>