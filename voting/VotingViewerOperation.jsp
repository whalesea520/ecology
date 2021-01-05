
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsVirtual" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsVirtual2" class="weaver.conn.RecordSet" scope="page" />

<%
String method = Util.null2String(request.getParameter("method"));
String shareid = Util.null2String(request.getParameter("shareid"));
String votingid = Util.null2String(request.getParameter("votingid"));
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));
String seclevelmax = request.getParameter("seclevelmax");
if(Util.getIntValue(seclevelmax,-1024)==-1024) seclevelmax=null;

String userid = "0" ;
String departmentid = "0" ;
String subcompanyid="0";
String roleid = "0" ;
String foralluser = "0" ;
String jobtitles="0";
String jobdepartment=Util.null2String(request.getParameter("jobdepartment"));
String jobsubcompany=Util.null2String(request.getParameter("jobsubcompany"));
if(jobdepartment.equals("")){
jobdepartment="0";
}
if(jobsubcompany.equals("")){
jobsubcompany="0";
}
String joblevel=Util.null2String(request.getParameter("joblevel"));

if(sharetype.equals("1")) userid = relatedshareid ;
if(sharetype.equals("2")) subcompanyid = relatedshareid ;
if(sharetype.equals("3")) departmentid = relatedshareid ;
if(sharetype.equals("4")) roleid = relatedshareid ;
if(sharetype.equals("5")) foralluser = "1" ;
if(sharetype.equals("6")) jobtitles = relatedshareid ;


if(method.equals("add")&& (sharetype.equals("1")||sharetype.equals("2")||sharetype.equals("3")||sharetype.equals("6")))
{
	if(sharetype.equals("6")){
	        seclevel="0";
	}else{
	  joblevel="0";
	  jobdepartment="0";
	  jobsubcompany="0";
	
	}
	ArrayList objnames = Util.TokenizerString(relatedshareid,",");
   	if(objnames!=null){
   		for(int i=0;i<objnames.size();i++){
   			String tmpid = ""+objnames.get(i);
   			
   			userid = "0";
   			departmentid = "0" ;
   			subcompanyid="0";
   			if(sharetype.equals("1")) userid = tmpid;
   			if(sharetype.equals("2")) subcompanyid = tmpid;
   			if(sharetype.equals("3")) departmentid = tmpid;
   			 if(sharetype.equals("6")) jobtitles = tmpid ;
   		 	 if(joblevel.equals("1")){
				 String[] jobsubcompanyids = jobsubcompany.split(",");
		 	    for(String jobsubcompanyid : jobsubcompanyids)
		 	    {					
					 RecordSet.executeSql(
   		 	    " insert into votingviewer(votingid,sharetype,resourceid,subcompanyid,departmentid,roleid,seclevel,seclevelmax,rolelevel,foralluser,jobtitles,joblevel,jobsubcompany,jobdepartment) " +
        		" values("+votingid+","+sharetype+","+userid+","+subcompanyid+","+departmentid+","+roleid+","+seclevel+","+seclevelmax+","+rolelevel+","+foralluser+","+jobtitles+","+joblevel+","+jobsubcompanyid+","+jobdepartment+") "
             	);
		 	   }
		 	}
		 	else if(joblevel.equals("2"))
		 	{
		 	   String[] jobdepartmentids = jobdepartment.split(",");
			    for(String jobdepartmentid : jobdepartmentids)
		 	    {
					RecordSet.executeSql(
   		 	    " insert into votingviewer(votingid,sharetype,resourceid,subcompanyid,departmentid,roleid,seclevel,seclevelmax,rolelevel,foralluser,jobtitles,joblevel,jobsubcompany,jobdepartment) " +
        		" values("+votingid+","+sharetype+","+userid+","+subcompanyid+","+departmentid+","+roleid+","+seclevel+","+seclevelmax+","+rolelevel+","+foralluser+","+jobtitles+","+joblevel+","+jobsubcompany+","+jobdepartmentid+") "
             	);
		 	   }
			}
		  else{
			   RecordSet.executeSql(
   		 	    " insert into votingviewer(votingid,sharetype,resourceid,subcompanyid,departmentid,roleid,seclevel,seclevelmax,rolelevel,foralluser,jobtitles,joblevel,jobsubcompany,jobdepartment) " +
        		" values("+votingid+","+sharetype+","+userid+","+subcompanyid+","+departmentid+","+roleid+","+seclevel+","+seclevelmax+","+rolelevel+","+foralluser+","+jobtitles+","+joblevel+","+jobsubcompany+","+jobdepartment+") "
        	   );
			}
   		}
	}
}
else if(method.equals("add")&& !(sharetype.equals("1")||sharetype.equals("2")||sharetype.equals("3")||sharetype.equals("6")))
{
	RecordSet.executeSql(
		" insert into votingviewer(votingid,sharetype,resourceid,subcompanyid,departmentid,roleid,seclevel,seclevelmax,rolelevel,foralluser) " +
    	" values("+votingid+","+sharetype+","+userid+","+subcompanyid+","+departmentid+","+roleid+","+seclevel+","+seclevelmax+","+rolelevel+","+foralluser+") "
    );
}

if(method.equals("delete")){
		if(shareid.startsWith(",")) shareid=shareid.substring(1);
		if(shareid.endsWith(",")) shareid=shareid.substring(0,shareid.length()-1);
		
    RecordSet.executeSql(" delete from votingviewer where id in( " + shareid+")");
    response.sendRedirect("VotingView.jsp?votingid="+votingid);
    return;
}
%>

<% out.println("<script>parent.getParentWindow(window).MainCallback();</script>"); %>