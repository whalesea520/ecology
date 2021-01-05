
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="log" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@page import="org.json.JSONObject"%>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String docid = Util.null2String(request.getParameter("docid"));
String istop = Util.null2String(request.getParameter("istop"));
String topstartdate = Util.null2String(request.getParameter("topstartdate"));
String topenddate = Util.null2String(request.getParameter("topenddate"));
String operation = Util.null2String(request.getParameter("operation"));
if(operation.equals("top"))
{
	  String reistop = "";
	  Date newdate = new Date() ;
	  long datetime = newdate.getTime() ;
	  Timestamp timestamp = new Timestamp(datetime) ;
	  String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
	  String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16)+ ":" + (timestamp.toString()).substring(17,19);
	  if(!docid.equals(""))
	  {
		  String sql = "";
		  if(istop.equals("1"))
		  {
			  if(CurrentDate.compareTo(topstartdate)>=0&&((CurrentDate.compareTo(topenddate)<=0&&!topenddate.equals(""))||topenddate.equals("")))
			  {
			  	sql = "update docdetail set istop=1,topdate='"+CurrentDate+"',toptime='"+CurrentTime+"',topstartdate='"+topstartdate+"',topenddate='"+topenddate+"' where id = "+docid;
			  	reistop = "1";
			  }
			  else
			  {
				  sql = "update docdetail set istop=0, topdate='"+CurrentDate+"',toptime='"+CurrentTime+"',topstartdate='"+topstartdate+"',topenddate='"+topenddate+"' where id = "+docid;
				  if(CurrentDate.compareTo(topenddate)>0&&!topenddate.equals(""))
				  {
					reistop = "0";
				  }
				  else
				  	reistop = "1";
			  }
		  }
		  else
		  {
			  sql = "update docdetail set istop=0,topdate=null,toptime=null,topstartdate=null,topenddate='' where id = "+docid;
			  reistop = "0";
		  }
		  RecordSet.executeSql(sql);
		  
	  }
	  JSONObject jsonObj = new JSONObject();
	  jsonObj.put("reistop",reistop);
	  out.print(jsonObj.toString());
}
else if(operation.equals("notop"))
{
	  if(!docid.equals(""))
	  {
		  RecordSet.executeSql("update docdetail set istop=0,topdate=null,toptime=null,topstartdate=null,topenddate='' where id = "+docid);
	  }
}
else
{
	session.removeAttribute("docnoreadName_"+docid);
	session.removeAttribute("docallreadName_"+docid);
	session.removeAttribute("docprintName_"+docid);
	session.removeAttribute("docdlName_"+docid);
	 
	String islogcontrol = "0";
	RecordSet.executeSql("select islogcontrol from DocSecCategory where id = (select seccategory from docdetail where id = "+docid+")");
	if(RecordSet.next()){
	   String logcontrolTemp = RecordSet.getString("islogcontrol");
	   if("1".equals(logcontrolTemp)){
	      islogcontrol = "1";
	   }
	}
	out.print(islogcontrol);
}
%>

