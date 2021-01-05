<%@page import="weaver.hrm.User"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="PrjShareUtil" class="weaver.proj.util.PrjShareUtil" scope="page" />

<%
char flag = 2 ;
String ProcPara = "";
String method = Util.null2String(request.getParameter("method"));
String ProjID=Util.null2String(request.getParameter("ProjID"));
String taskid=Util.null2String(request.getParameter("taskid"));
String docid=Util.null2String(request.getParameter("docid"));
String type=Util.null2String(request.getParameter("type"));

if (method.equals("add"))
{
	String tempsql="";
	tempsql="select * from Prj_Doc where prjid='"+ProjID+"' and taskid='"+taskid+"' and docid='"+docid+"'";
	RecordSet.executeSql(tempsql);
	if(!RecordSet.next()){
		ProcPara = ProjID ;
		ProcPara += flag  + taskid ;
		ProcPara += flag  + docid ;
		ProcPara += flag  + DocComInfo.getDocSecId(docid) ;

		RecordSet.executeProc("Prj_Doc_Insert",ProcPara);
		
		//赋查看权限
		PrjShareUtil.addDocShare(docid, ProjID, taskid, user.getUID());
	    
		tempsql="update docdetail set projectid="+ProjID+" where id="+docid;
		RecordSet.executeSql(tempsql);
	}
	
	/**if(type.equals("1"))
		response.sendRedirect("/proj/plan/ViewTask.jsp?log=n&taskrecordid="+taskid);
	else if(type.equals("2"))
		response.sendRedirect("/proj/process/ViewTask.jsp?log=n&taskrecordid="+taskid);
	**/
	//response.sendRedirect("/proj/process/DspTaskReference.jsp?ProjID="+ProjID+"&taskrecordid="+taskid+"&src=doc");
	response.sendRedirect("/proj/process/PrjTaskTab.jsp?taskid="+taskid+"&type=doc");
}

if (method.equals("del"))
{

	String ids = Util.null2String(request.getParameter("id"));
	String ProjID1="";
	String taskid1="";
	String[]idarr=ids.split(",");
	for(int i=0;i<idarr.length;i++){
		String id=idarr[i];
		String tempsql="select prjid,docid,taskid from Prj_Doc where id="+id;
		RecordSet.executeSql(tempsql);
		RecordSet.next();
		String deldocid = RecordSet.getString("docid");
		String tempprjid = RecordSet.getString("prjid");
		String temptaskid = RecordSet.getString("taskid");
		ProjID1=tempprjid;
		taskid1=temptaskid;
		tempsql="delete Prj_Doc  where id="+id;
		RecordSet.executeSql(tempsql);
		
		tempsql = "select count(*) from Prj_Doc where docid="+deldocid+" and prjid="+tempprjid;
		RecordSet.executeSql(tempsql);
		RecordSet.next();
		if(RecordSet.getInt(1)<=0){
		    tempsql = "update docdetail set projectid='' where id="+deldocid;
		    RecordSet.executeSql(tempsql);
		}
	}
	
	/**if(type.equals("1"))
		response.sendRedirect("/proj/plan/ViewTask.jsp?log=n&taskrecordid="+taskid);
	else if(type.equals("2"))
		response.sendRedirect("/proj/process/ViewTask.jsp?log=n&taskrecordid="+taskid);
	**/
	response.sendRedirect("/proj/process/DspTaskReference.jsp?ProjID="+ProjID+"&taskrecordid="+taskid+"&src=doc");

}

%>