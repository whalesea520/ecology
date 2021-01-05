
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSetTrans" %>
<jsp:useBean id="rsSel" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsxtr" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<%
String selSql = "";
String delSql = "";
String updSql = "";
String altSql = "";
String renSql = "";
String pFix = "_QC92670";
int userid = user.getUID();
boolean isoracle = (rs.getDBType()).equals("oracle") ;
if(userid != 1) {
	out.print(SystemEnv.getHtmlLabelName(129496, user.getLanguage()));
	return;
}
if(!isoracle) {
%>
<Script language=javascript>alert("<%=SystemEnv.getHtmlLabelName(129497, user.getLanguage())%>");</Script>
<%
	out.print(SystemEnv.getHtmlLabelName(129497, user.getLanguage()));
	return;
}
//新表单、单据html类型字段处理
selSql = " select t1.id, t1.fieldname, t2.tablename, 'workflow_billfield' as fieldtable from workflow_billfield t1 left join workflow_bill t2 on t1.billid=t2.id where (t1.fieldhtmltype=2 and t1.viewtype=0 and t1.type = 2 and t1.fielddbtype='varchar2(4000)') " +
			" OR (t1.fieldhtmltype=3 and t1.viewtype=0 and t1.type = 17 AND t1.FIELDDBTYPE NOT LIKE 'clob') ";
selSql += " union ";
selSql += " select id,fieldname,'workflow_form' as tablename, 'workflow_formdict' as fieldtable from workflow_formdict where (fieldhtmltype=2 and type=2 and fielddbtype='varchar2(4000)') " +
			" OR (fieldhtmltype=3 and type=17 and fielddbtype NOT LIKE 'clob') " ;
selSql += " union ";
selSql += " select id,fieldname,'workflow_formdetail' as tablename, 'workflow_formdictdetail' as fieldtable ";
selSql += " from workflow_formdictdetail where  fieldhtmltype=3 and type=17 and fielddbtype NOT LIKE 'clob' ";
//单据自定义字段
selSql += " union ";
selSql += " select t1.id, t1.fieldname, t2.tablename, 'workflow_billfield' as fieldtable from workflow_billfield t1 left join workflow_bill t2 on t1.billid=t2.id where (t1.fieldhtmltype=2 and t1.viewtype=0 and t1.type = 2 and t1.billid > 0 and t1.fieldname like 'field_%' and (t1.fielddbtype='varchar2(4000)' or t1.fielddbtype='varchar2(3000)')) " +
			" OR (t1.fieldhtmltype=3 and t1.viewtype=0 and t1.type = 17 AND t1.FIELDDBTYPE NOT LIKE 'clob' and t1.billid > 0  and t1.fieldname like 'field_%') ";
selSql += " union ";
selSql += " select id, fieldname, detailtable, 'workflow_billfield' as fieldtable FROM workflow_billfield WHERE fieldhtmltype=3 and viewtype=1 and type = 17 AND FIELDDBTYPE NOT LIKE 'clob' ";
rsSel.executeSql(selSql);
int cnt = 0;
RecordSetTrans rst=new RecordSetTrans();
rst.setAutoCommit(false);
java.util.Calendar today = java.util.Calendar.getInstance();
String strDate = Util.add0(today.get(java.util.Calendar.YEAR), 4)  +
                     Util.add0(today.get(java.util.Calendar.MONTH) + 1, 2) +
                     Util.add0(today.get(java.util.Calendar.DAY_OF_MONTH), 2) ;
try {
	while(rsSel.next()) {
		String fieldid = Util.null2String(rsSel.getString("id"));
		String fieldname = Util.null2String(rsSel.getString("fieldname"));
		String tablename = Util.null2String(rsSel.getString("tablename"));
		String fieldtable = Util.null2String(rsSel.getString("fieldtable"));
		String fieldname_new = fieldname + "_%1$S";
		fieldname_new = String.format(fieldname_new, strDate);
		//out.print(fieldname_new + "<br>");
	
		altSql = "alter table " + tablename + " add " + fieldname_new + " clob";
		rst.writeLog(altSql);
		updSql = "update " + tablename + " set " + fieldname_new + " = " + fieldname;
		delSql = "alter table " + tablename + " drop column " + fieldname_new;
		renSql = "alter table " + tablename + " rename column " + fieldname + " to " + fieldname_new + "bak";
		//rs.executeSql(altSql);
		rst.executeSql(altSql);
		
		//rs.executeSql(updSql);
		rst.executeSql(updSql);
		
		//rs.executeSql(renSql);
		rst.executeSql(renSql);
		
		renSql = "alter table " + tablename + " rename column " + fieldname_new + " to " + fieldname;
		//rs.executeSql(renSql);
		rst.executeSql(renSql);
		//rs.executeSql(delSql);
		updSql = "update " + fieldtable + " set fielddbtype='clob' where id=" + fieldid;
		//rs.executeSql(updSql);
		rst.executeSql(updSql);
		
		//rs.executeSql("insert into HTMLFIELDTOCLOBLOG(fieldid,fieldname,tablename,fieldtable) values(" + fieldid + ",'" + fieldname + "','" + tablename + "','" + fieldtable+ "')");
		rst.executeSql("insert into HTMLFIELDTOCLOBLOG(fieldid,fieldname,tablename,fieldtable) values(" + fieldid + ",'" + fieldname + "','" + tablename + "','" + fieldtable+ "')");
		cnt++;
	}
	rst.commit();
} catch (Exception e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
	rst.rollback();
}
String checksql = " SELECT data_type FROM all_tab_cols WHERE table_name = upper('workflow_reqbrowextrainfo') AND column_name = upper('ids') ";
rs.executeSql(checksql);
while(rs.next()) {
	String idsdbtype = Util.null2String(rs.getString("data_type"));
	if(!"CLOB".equals(idsdbtype.toUpperCase())){
		rsxtr.executeProc("backupwf_reqbrowextrainfo","");
		rsxtr.executeSql("alter table workflow_reqbrowextrainfo modify (ids clob)");
	}
}
out.print(Util.StringReplace(SystemEnv.getHtmlLabelName(129498, user.getLanguage()),"${0}",String.valueOf(cnt)));
%>