
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;
String sql = "";

if(operation.equals("reportadd"))
{
    String reportname = Util.fromScreen(request.getParameter("reportname"), user.getLanguage());
    String reportdesc = Util.fromScreen(request.getParameter("reportdesc"), user.getLanguage());
    int reportnumperpage = Util.getIntValue(request.getParameter("reportnumperpage"),0); 
    String formID = "0";
    String modeid = Util.null2String(request.getParameter("modeid"));
    sql = "select formid from modeinfo where id = " + modeid;
	rs.executeSql(sql);
	while(rs.next()){
		formID = rs.getString("formid");
	}
	RecordSet.executeSql("INSERT INTO mode_Report(reportName,formID,modeid,reportdesc,reportnumperpage) VALUES ('" + reportname + "', '" + formID + "', '" + modeid + "','"+reportdesc+"','"+reportnumperpage+"')");
    RecordSet.executeSql("select max(id) as id from mode_Report where modeid = '"+modeid+"' and reportName = '"+reportname+"' and formID = " + formID);
    RecordSet.next();
    String reportid = RecordSet.getString("id");
	
    int fieldcount = 0;//统计字段数目
	String fieldid = "0";
    String dsporder = "0";
    String isstat = "0";
    String dborder = "0";
    String dbordertype = "n";
    String compositororder = "0";
    
	fieldcount++;
	fieldid = "-1"; 
    dsporder = ""+fieldcount;
    isstat = "0";
    dborder = "0";
    dbordertype = "n";
    compositororder = "0";
    sql = "insert into mode_ReportDspField(reportid,fieldid,dsporder,isstat,dborder,dbordertype,compositororder) values("+
    	"'"+reportid+"','"+fieldid+"','"+dsporder+"','"+isstat+"','"+dborder+"','"+dbordertype+"','"+compositororder+"'"+	
    ")";
    RecordSet.executeSql(sql);
    
	fieldcount++;
	fieldid = "-2"; 
    dsporder = ""+fieldcount;
    isstat = "0";
    dborder = "0";
    dbordertype = "n";
    compositororder = "0";
    sql = "insert into mode_ReportDspField(reportid,fieldid,dsporder,isstat,dborder,dbordertype,compositororder) values("+
    	"'"+reportid+"','"+fieldid+"','"+dsporder+"','"+isstat+"','"+dborder+"','"+dbordertype+"','"+compositororder+"'"+	
    	")";
    RecordSet.executeSql(sql);
    
    sql = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type from workflow_billfield where workflow_billfield.billid="+formID+" order by dsporder";

	rs.executeSql(sql);
	while(rs.next()){
		fieldcount++;
		fieldid = rs.getString("id"); 
	    dsporder = ""+fieldcount;
	    isstat = "0";
	    dborder = "0";
	    dbordertype = "n";
	    compositororder = "0";
	    sql = "insert into mode_ReportDspField(reportid,fieldid,dsporder,isstat,dborder,dbordertype,compositororder) values("+
	    	"'"+reportid+"','"+fieldid+"','"+dsporder+"','"+isstat+"','"+dborder+"','"+dbordertype+"','"+compositororder+"'"+	
	    ")";
	    RecordSet.executeSql(sql);
	}
	response.sendRedirect("/formmode/report/ReportEdit.jsp?id="+reportid);
}
else if(operation.equals("reportedit"))
{
  	int id = Util.getIntValue(request.getParameter("id"));
	String reportname = "" + Util.null2String(request.getParameter("reportname"));
	String reportdesc = "" + Util.null2String(request.getParameter("reportdesc"));
	String defaultsql = "" + Util.fromScreen(request.getParameter("defaultsql"),user.getLanguage());
	int reportnumperpage = Util.getIntValue(request.getParameter("reportnumperpage"),0); 
	RecordSet.execute("UPDATE mode_Report SET reportname = '" + reportname + "',defaultsql='"+defaultsql+"', reportdesc = '" + reportdesc + "',reportnumperpage="+reportnumperpage+" WHERE ID = " + id);
 	response.sendRedirect("/formmode/report/ReportEdit.jsp?id="+id);
}
else if(operation.equals("reportdelete"))
{
	String modeid = Util.null2String(request.getParameter("modeid"));
  	int id = Util.getIntValue(request.getParameter("id"));
	sql = "delete from mode_report where id = " + id;	
    rs.executeSql(sql);
    response.sendRedirect("/formmode/report/ReportManage.jsp?modeid="+modeid);
}
else if(operation.equals("formfieldadd"))
{
    int tmpcount=Util.getIntValue(request.getParameter("tmpcount"), 0);
    String reportid = Util.null2String(request.getParameter("reportid"));
    RecordSet.executeSql("delete from mode_ReportDspField where reportid="+reportid);
  
    for(int i=0;i<=tmpcount;i++)
    {
    	String isshow = "" + Util.getIntValue(request.getParameter("isshow_"+i),0);
    	if(isshow.equals("1"))
    	{
      		String fieldid = "" + Util.getIntValue(request.getParameter("fieldid_"+i),0);
		    String dsporder = Util.null2String(request.getParameter("dsporder_"+i)); //xwj for td2974 20051026
		    String isstat = Util.null2String(request.getParameter("isstat_"+i));
		    String dborder = Util.null2String(request.getParameter("dborder_"+i));
		    String dbordertype = Util.null2String(request.getParameter("dbordertype_"+i));//added by xwj for td2099 for 2005-06-06
		    String compositororder = Util.null2String(request.getParameter("compositororder_"+i));//added by xwj for td2099 for 2005-06-06

      		if(isstat.equals("")) 
      		{
      			isstat = "0" ;
      		}
      		if(dborder.equals("")) 
      		{
      			dborder = "0" ;
      		}
       		if(dbordertype.equals(""))
       		{
       			dbordertype = "n";
       		}
       		if(compositororder.equals(""))
       		{
       			compositororder = "0";
       		}
        	if(dsporder.equals(""))
        	{
        		dsporder = "0";
        	}
        	
    	    sql = "insert into mode_ReportDspField(reportid,fieldid,dsporder,isstat,dborder,dbordertype,compositororder) values("+
	    		  "'"+reportid+"','"+fieldid+"','"+dsporder+"','"+isstat+"','"+dborder+"','"+dbordertype+"','"+compositororder+"'"+	
				  ")";
	    	RecordSet.executeSql(sql);
   		}
    }
	response.sendRedirect("/formmode/report/ReportEdit.jsp?id="+reportid);
}
else if(operation.equals("deletefield"))
{
  	String reportID = Util.null2String(request.getParameter("id"));
	String theid = "" + Util.getIntValue(request.getParameter("theid"), 0);
	sql = "delete from mode_ReportDspField where id = " + theid ;
	RecordSet.executeSql(sql);
	response.sendRedirect("/formmode/report/ReportEdit.jsp?id=" + reportID);
}

%>