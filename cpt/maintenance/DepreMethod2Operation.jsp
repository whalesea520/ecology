
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepreMethodComInfo" class="weaver.cpt.maintenance.DepreMethodComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String depreid = Util.fromScreen(request.getParameter("depreid"),user.getLanguage());
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
String delids = Util.fromScreen(request.getParameter("delids"),user.getLanguage());
int nodesnum = Util.getIntValue(request.getParameter("nodesnum"),0);

if(operation.equals("addoredit")){
	if(!HrmUserVarify.checkUserRight("CptDepreMethodAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
    char separator = Util.getSeparator() ;
  	String para = "";

	//operations on CptDepreMethod1
	if(depreid.equals("")){
		//add 
		para = name+separator+description+separator+"2"+separator+"0"+separator+"0"+separator+"0"+separator+"";
		RecordSet.executeProc("CptDepreMethod1_Insert",para);
		RecordSet.next();
		depreid = RecordSet.getString(1);
	}
	else{
		para = depreid+separator+name+separator+description+separator+"2"+separator+"0"+separator+"0"+separator+"0"+separator+"";
		RecordSet.executeProc("CptDepreMethod1_Update",para);
		RecordSet.next();
	}

	//delete rows in CptDepreMethod2
	if(!delids.equals("")){
		delids = delids.substring(1);
	  	String del_ids[] =Util.TokenizerString2(delids,",");	  	
	  	for(int i=0;i<del_ids.length;i++){
			RecordSet.executeProc("CptDepreMethod2_Delete",del_ids[i]);
		}
	}
	//add or update in CptDepreMethod2
	for(int i=0;i<=nodesnum;i++){
		String tmptime = Util.null2String(request.getParameter("node_"+i+"_time"));
		String tmpdepreunit = Util.null2String(request.getParameter("node_"+i+"_depreunit"));
		String tmpid = Util.null2String(request.getParameter("node_"+i+"_id"));
		if(!tmptime.equals("")){
			if(!tmpid.equals("")){
				para = tmpid+separator+depreid+separator+tmptime+separator+tmpdepreunit;
				RecordSet.executeProc("CptDepreMethod2_Update",para);
			}
			else{
				para = depreid+separator+tmptime+separator+tmpdepreunit;
				RecordSet.executeProc("CptDepreMethod2_Insert",para);
			}
		}	
	}

	DepreMethodComInfo.removeDepreMethodCache();
	response.sendRedirect("CptDepreMethod.jsp");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("CptDepreMethodEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
	String para = ""+depreid;
	RecordSet.executeProc("CptDepreMethod1_Delete",para);
	RecordSet.executeProc("CptDepreMethod2_DByDepreID",para);
	
    DepreMethodComInfo.removeDepreMethodCache();
 	response.sendRedirect("CptDepreMethod.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">