
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSetTrans" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rset" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsSel" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsSel1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<%
int userid = user.getUID();
boolean isoracle = (rs.getDBType()).equals("oracle") ;
if(userid != 1) {
	out.print("此功能只有系统管理员才能执行，请联系系统管理员!");
	return;
}


String setsql = "";
String selectSql = "";
String selectSql1 = "";

   RecordSetTrans rst=new RecordSetTrans();
   rst.setAutoCommit(false);
   try {
   	rst.executeSql("delete from Workflow_VersionInfo");//先删后加
   	//Statement stmt =conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY); 
   	selectSql = " SELECT id FROM workflow_base a WHERE  ACTiveversionid is null  "+
   				" AND NOT EXISTS (SELECT 1 FROM workflow_base b WHERE istemplate = '1' AND a.id=b.id) ";
   	rsSel.executeSql(selectSql);
   	String wfid = "";
   	String wfversionid = "";
   	while(rsSel.next()) {
   		wfid = rsSel.getString("id");
   		wfversionid = wfid;
   		rst.executeSql(" insert into Workflow_VersionInfo(wfid,wfversionid) values("+wfid+","+wfversionid+")");
   	}
   	
   	selectSql1 = " SELECT activeversionid,count(activeversionid) FROM WORKFLOW_BASE a "+
   				" WHERE activeversionid is NOT null  "+
   				" AND NOT EXISTS (SELECT 1 FROM workflow_base b WHERE istemplate = '1' AND a.id=b.id) "+
   				" GROUP BY activeversionid HAVING count(activeversionid)>0 "+
   				" ORDER BY activeversionid ";
   	rsSel.executeSql(selectSql1);
   	String activeversionid = "";
   	List<String> wfidlist = new ArrayList<String>();
   	List<String> wfversionidlist = new ArrayList<String>();
   	while(rsSel.next()) {
   		activeversionid = rsSel.getString("activeversionid");
   		rsSel1.executeSql(" select id from workflow_base where activeversionid = "+activeversionid);
   		while(rsSel1.next()) {
       		wfid = rsSel1.getString("id");
       		wfversionid = wfid;
       		wfidlist.add(wfid);
       		wfversionidlist.add(wfversionid);
   		}
   		for(int i =0;i<wfidlist.size();i++){
   			for(int j =0;j<wfidlist.size();j++){
   				rst.executeSql(" insert into Workflow_VersionInfo(wfid,wfversionid) values("+wfidlist.get(i)+","+wfversionidlist.get(j)+")");
   			}
   		}
   		wfidlist.clear();
   		wfversionidlist.clear();
   	}
   	rst.commit();
   }catch (Exception e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
	rst.rollback();
   }
out.print("workflowversion 执行成功！");
%>