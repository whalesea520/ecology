
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />
<%
 if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>
<%
String operation = Util.null2String(request.getParameter("operation"));
String dialog = Util.null2String(request.getParameter("dialog"));
char separator = Util.getSeparator() ;

if(operation.equals("reportadd"))
{
    String reportName = Util.fromScreen(request.getParameter("reportName"), user.getLanguage());
    String reportType = "" + Util.getIntValue(request.getParameter("reportType"), 0);
    int subcompanyid=Util.getIntValue(request.getParameter("subcompanyid"),0);
    String isBill = "" + Util.getIntValue(request.getParameter("isBill"), 0);
    String formID = "" + Util.getIntValue(request.getParameter("formID"), 0);
    String workFlowID = request.getParameter("workflowID");
     	if(workFlowID.equals("0")){	
		RecordSet.executeSql("SELECT * FROM WorkFlow_Base WHERE formID = " + formID + " AND isBill = '" + isBill + "' AND isValid = '1'");
		workFlowID="";
		while(RecordSet.next()){
			workFlowID+=RecordSet.getString("ID")+",";
		}
	}
	String isShowOnReportOutput = Util.null2String(request.getParameter("isShowOnReportOutput"));
	RecordSet.execute("INSERT INTO Workflow_Report(reportName, reportType, reportWFID, formID, isBill, isShowOnReportOutput,subCompanyId) VALUES ('" + reportName + "', " + reportType + ", '" + workFlowID + "', " + formID + ", '" + isBill + "', '" + isShowOnReportOutput + "',"+subcompanyid+")");

    ReportComInfo.removeReportTypeCache() ;
    RecordSet.executeSql("select max(id) as id from Workflow_Report");
    RecordSet.next();
    String reportid = RecordSet.getString("id");
    
    int fieldcount = 0;//统计字段数目
	fieldcount++;
	String fieldid = "-1";
    String dsporder = ""+fieldcount;
    String isstat = "0";
    String dborder = "0";
    String dbordertype = "n";
    String compositororder = "0";
    String para = reportid + separator + fieldid + separator + dsporder + separator + isstat + separator + dborder + separator + dbordertype + separator + compositororder;
    RecordSet.executeProc("Workflow_ReportDspField_Insert",para);
    
    //requestlevel
    fieldcount++;
	fieldid = "-2";
    dsporder = ""+fieldcount;
    isstat = "0";
    dborder = "0";
    dbordertype = "n";
    compositororder = "0";
    para = reportid + separator + fieldid + separator + dsporder + separator + isstat + separator + dborder + separator + dbordertype + separator + compositororder;
    RecordSet.executeProc("Workflow_ReportDspField_Insert",para);
    
	String sql="";
	if(isBill.equals("0")){
	  /*
	  1、workflow_formdict,workflow_formdictdetail 两张表的分开，是极糟糕的设计！使得必须使用union操作；
	  2、由于workflow_formfield.fieldorder 字段针对头和明细分别记录顺序，使得在union之后对fieldorder使用order by 失去意义；
	  3、针对问题2，对 workflow_formfield.fieldorder 作 +100 的操作，以便union后排序，100能够满足绝对多数单据对头字段的要求；
	  4、检索字段实际存储类型，屏蔽不能排序字段的排序操作；
	  5、添加(明细)标记时要区分sql与oracle的操作差异
	  */
		StringBuffer sqlSB = new StringBuffer();
		sqlSB.append("  select workflow_formfield.fieldid      as id,                                         \n");
		sqlSB.append("         fieldname                       as name,                                       \n");
		sqlSB.append("         workflow_fieldlable.fieldlable  as label,                                      \n");
		sqlSB.append("         workflow_formfield.fieldorder as fieldorder,                                   \n");
		sqlSB.append("         workflow_formdict.fielddbtype   as dbtype,                                     \n");
		sqlSB.append("         workflow_formdict.fieldhtmltype as httype,                                     \n");
		sqlSB.append("         workflow_formdict.type as type                                                 \n");
		sqlSB.append("    from workflow_formfield, workflow_formdict, workflow_fieldlable                     \n");
		sqlSB.append("   where workflow_fieldlable.formid = workflow_formfield.formid                         \n");
		sqlSB.append("     and workflow_fieldlable.isdefault = 1                                              \n");
		sqlSB.append("     and workflow_fieldlable.fieldid = workflow_formfield.fieldid                       \n");
		sqlSB.append("     and workflow_formdict.id = workflow_formfield.fieldid                              \n");
		sqlSB.append("     and workflow_formfield.formid = " + formID + "                                     \n");
		sqlSB.append("     and (workflow_formfield.isdetail <> '1' or workflow_formfield.isdetail is null)    \n");
		sqlSB.append("  Order by workflow_formfield.fieldorder                                                \n");
	    sql = sqlSB.toString();
	}else if(isBill.equals("1")){
		StringBuffer sqlSB = new StringBuffer();
		sqlSB.append("  select * from                                                     \n");
		sqlSB.append("   (select wfbf.id            as id,                                \n");
		sqlSB.append("           wfbf.fieldname     as name,                              \n");
		sqlSB.append("           wfbf.fieldlabel    as label,                             \n");
		sqlSB.append("           wfbf.fielddbtype   as dbtype,                            \n");
		sqlSB.append("           wfbf.fieldhtmltype as httype,                            \n");
		sqlSB.append("           wfbf.type          as type,                              \n");
		sqlSB.append("           wfbf.dsporder      as dsporder,                          \n");
		sqlSB.append("           wfbf.viewtype      as viewtype,                          \n");
		sqlSB.append("           wfbf.detailtable   as detailtable                        \n");
		sqlSB.append("      from workflow_billfield wfbf                                  \n");
		sqlSB.append("     where wfbf.billid = " + formID + " AND wfbf.viewtype = 0       \n");
		sqlSB.append("    Union                                                           \n");
		sqlSB.append("    select wfbf.id            as id,                                \n");
		sqlSB.append("           wfbf.fieldname     as name,                              \n");
		sqlSB.append("           wfbf.fieldlabel    as label,                             \n");
		sqlSB.append("           wfbf.fielddbtype   as dbtype,                            \n");
		sqlSB.append("           wfbf.fieldhtmltype as httype,                            \n");
		sqlSB.append("           wfbf.type          as type,                              \n");
		sqlSB.append("  	       wfbf.dsporder+100  as dsporder,                        \n");
		sqlSB.append("  	       wfbf.viewtype      as viewtype,                        \n");
		sqlSB.append("           wfbf.detailtable   as detailtable                        \n");
		sqlSB.append("  	  from workflow_billfield wfbf                                \n");
		sqlSB.append("  	 where wfbf.billid = " + formID + " AND wfbf.viewtype = 1) a  \n");
		sqlSB.append("  order by a.viewType, a.detailtable, a.dsporder                    \n");
		sql = sqlSB.toString();
	}
	rs.executeSql(sql);
	while(rs.next()){
		fieldcount++;
		fieldid = rs.getString("id"); 
	    dsporder = ""+fieldcount;
	    isstat = "0";
	    dborder = "0";
	    dbordertype = "n";
	    compositororder = "0";
	    para = reportid + separator + fieldid + separator + dsporder + separator + isstat + separator + dborder + separator + dbordertype + separator + compositororder;
	    RecordSet.executeProc("Workflow_ReportDspField_Insert",para);
	}
	
	//老表单的明细单独处理
	if(isBill.equals("0")){
		StringBuffer sqlSB = new StringBuffer();
		sqlSB.append("  select workflow_formfield.fieldid as id,                                                 \n");
		sqlSB.append("         fieldname as name,                                                                \n");
		if(rs.getDBType().equals("oracle")){
			sqlSB.append("         concat(workflow_fieldlable.fieldlable,' ("+SystemEnv.getHtmlLabelName(17463, user.getLanguage())+")') as label,                    \n");
		}else if(rs.getDBType().equals("db2")){
			sqlSB.append("         concat(workflow_fieldlable.fieldlable,' ("+SystemEnv.getHtmlLabelName(17463, user.getLanguage())+")') as label,                    \n");
		}else{
			sqlSB.append("         workflow_fieldlable.fieldlable + ' ("+SystemEnv.getHtmlLabelName(17463, user.getLanguage())+")' as label,                          \n");
		}
		sqlSB.append("         workflow_formfield.fieldorder + 100 as fieldorder,                                \n");
		sqlSB.append("         workflow_formdictdetail.fielddbtype as dbtype,                                    \n");
		sqlSB.append("         workflow_formdictdetail.fieldhtmltype as httype,                                  \n");
		sqlSB.append("         workflow_formdictdetail.type as type                                              \n");
		sqlSB.append("    from workflow_formfield, workflow_formdictdetail, workflow_fieldlable                  \n");
		sqlSB.append("   where workflow_fieldlable.formid = workflow_formfield.formid                            \n");
		sqlSB.append("     and workflow_fieldlable.isdefault = 1                                                 \n");
		sqlSB.append("     and workflow_fieldlable.fieldid = workflow_formfield.fieldid                          \n");
		sqlSB.append("     and workflow_formdictdetail.id = workflow_formfield.fieldid                           \n");
		sqlSB.append("     and workflow_formfield.formid = " + formID + "                                        \n");
		sqlSB.append("     and (workflow_formfield.isdetail = '1' or workflow_formfield.isdetail is not null)    \n");
		sqlSB.append("   order by groupid, fieldorder                                                            \n");
		sql = sqlSB.toString();
		rs.executeSql(sql);
		
		while(rs.next()){
			fieldcount++;
			fieldid = rs.getString("id"); 
		    dsporder = ""+fieldcount;
		    isstat = "0";
		    dborder = "0";
		    dbordertype = "n";
		    compositororder = "0";
		    para = reportid + separator + fieldid + separator + dsporder + separator + isstat + separator + dborder + separator + dbordertype + separator + compositororder;
		    RecordSet.executeProc("Workflow_ReportDspField_Insert",para);
		}
	}
	if("1".equals(dialog)){
		response.sendRedirect("ReportAdd.jsp?isclose=1&id="+reportid);
	}else if("2".equals(dialog)){
		response.sendRedirect("ReportAdd.jsp?isclose=1&dialog=2&reportType="+reportType);
	}else if("3".equals(dialog)){
		response.sendRedirect("ReportAdd.jsp?isclose=1&dialog=3&wfid="+workFlowID+"&formid="+formID+"&isbill="+isBill);
	}else{
		response.sendRedirect("ReportEdit.jsp?id="+reportid);
	}
	
}
else if(operation.equals("reportedit"))
{
  	int ID = Util.getIntValue(request.getParameter("id"));
	String reportName = "" + Util.null2String(request.getParameter("reportName"));
	String reportType = "" + Util.getIntValue(request.getParameter("reportType"), 0);
	String isShowOnReportOutput = "" + Util.null2String(request.getParameter("isShowOnReportOutput"));
	int subcompanyid=Util.getIntValue(request.getParameter("subcompanyid"),0);
	RecordSet.execute("UPDATE Workflow_Report SET reportName = '" + reportName + "', reportType = " + reportType + ",isShowOnReportOutput = '" + isShowOnReportOutput + "' ,subcompanyid="+subcompanyid+" WHERE ID = " + ID);
	ReportComInfo.removeReportTypeCache();
 	response.sendRedirect("ReportEdit.jsp?id="+ID);
}
else if(operation.equals("reportdelete"))
{
	String isbill = "" + Util.getIntValue(request.getParameter("isbill"), 0);
    String formid = "" + Util.getIntValue(request.getParameter("formid"), 0);
    String wfid = request.getParameter("wfid");
  	int otype = Util.getIntValue(Util.null2String(request.getParameter("otype")),0);
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
    RecordSet.executeProc("Workflow_Report_Delete",para);    
    ReportComInfo.removeReportTypeCache() ;		
    response.sendRedirect("/workflow/workflow/ListFormByWorkflow.jsp?ajax=1&wfid="+wfid+"&formid="+formid+"&isbill="+isbill);
}
else if(operation.equals("reportdeletes"))
{
	String isbill = "" + Util.getIntValue(request.getParameter("isbill"), 0);
    String formid = "" + Util.getIntValue(request.getParameter("formid"), 0);
    String wfid = request.getParameter("wfid");
  	int otype = Util.getIntValue(Util.null2String(request.getParameter("otype")),0);
  	String typeids = Util.null2String(request.getParameter("typeids"));
  	String sql = "delete from Workflow_Report where id in("+typeids.substring(0,typeids.length()-1)+")";
	RecordSet.executeSql(sql);    
    ReportComInfo.removeReportTypeCache() ;
    response.sendRedirect("/workflow/workflow/ListFormByWorkflow.jsp?ajax=1&wfid="+wfid+"&formid="+formid+"&isbill="+isbill);
}
else if(operation.equals("reportManagedelete"))
{
  	int otype = Util.getIntValue(Util.null2String(request.getParameter("otype")),0);
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
    RecordSet.executeProc("Workflow_Report_Delete",para);    
    ReportComInfo.removeReportTypeCache() ;		
    response.sendRedirect("ReportManage.jsp?otype="+otype);
}
else if(operation.equals("reportManagedeletes"))
{
  	int otype = Util.getIntValue(Util.null2String(request.getParameter("otype")),0);
  	String typeids = Util.null2String(request.getParameter("typeids"));
  	String sql = "delete from Workflow_Report where id in("+typeids.substring(0,typeids.length()-1)+")";
	RecordSet.executeSql(sql);    
    ReportComInfo.removeReportTypeCache() ;
    response.sendRedirect("ReportManage.jsp?otype="+otype);
}
else if(operation.equals("formfieldadd"))
{
	 //System.out.println("进入保存逻辑");
    int tmpcount=Util.getIntValue(request.getParameter("tmpcount"), 0);
    String reportid = Util.null2String(request.getParameter("reportid"));
    RecordSet.executeSql("delete from Workflow_ReportDspField where reportid="+reportid);
    //System.out.println("tmpcount:"+tmpcount+" reportid:"+reportid);
    for(int i=1;i<=tmpcount;i++)
    {
    	String isshow = "" + Util.getIntValue(request.getParameter("isshow_"+i),0);
    	if(isshow.equals("1"))
    	{
      		String fieldid = "" + Util.getIntValue(request.getParameter("fieldid_"+i),0);
		    String dsporder = Util.null2String(request.getParameter("dsporder_"+i)); //xwj for td2974 20051026
		    String isstat = Util.null2String(request.getParameter("isstat_"+i));
		    String reportcondition = Util.null2String(request.getParameter("reportcondition_"+i));
		    String fieldwidth = Util.null2String(request.getParameter("fieldwidth_"+i));
		    String dborder = Util.null2String(request.getParameter("dborder_"+i));
		    String dbordertype = Util.null2String(request.getParameter("dbordertype_"+i));//added by xwj for td2099 for 2005-06-06
		    String compositororder = Util.null2String(request.getParameter("compositororder_"+i));//added by xwj for td2099 for 2005-06-06
            String defaultval = Util.null2String(request.getParameter("default_"+i));
		    String htdetailtype = Util.null2String(request.getParameter("type_"+i));
		    String httype = Util.null2String(request.getParameter("httype_"+i));
		    String valueone = "";
		    String valuetwo = "";
		    String valuethree = "";
		    String valuefour = "";
		    if(!defaultval.equals("")){
		    	  String[] arr=defaultval.split("~");
		    	  valueone = arr[0];
		    	if(arr.length>1)
		    	  valuetwo = arr[1];
		    	if(arr.length>2)
		    	  valuethree = arr[2];
		    	if(arr.length>3)
			      valuefour = arr[3];
		    }
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
       			dbordertype = "n";//added by xwj for td2099 for 2005-06-06
       		}
       		if(compositororder.equals(""))
       		{
       			compositororder = "0";//added by xwj for td2099 for 2005-06-06
       		}
       		if(reportcondition.equals("")) 
      		{
       			reportcondition = "0" ;
      		}
       		if(fieldwidth.equals("")) 
      		{
       			fieldwidth = "0" ;
      		}
        	if(dsporder.equals(""))
        	{
        		dsporder = "0";//added by xwj for td2099 for 2005-06-06
        	}

      		//String para = reportid + separator + fieldid + separator + dsporder + separator + isstat + separator + dborder + separator + dbordertype + separator + compositororder;//modefied by xwj for td2099 for 2005-06-06
      		//String para = reportid + separator + fieldid + separator + dsporder + separator + isstat + separator + dborder + separator + dbordertype + separator + compositororder + separator + reportcondition + separator + fieldwidth;//modefied by xwj for td2099 for 2005-06-06
      		//String para = reportid + separator + fieldid + separator
      		//+ dsporder + separator + isstat + separator
      		//+ dborder + separator + dbordertype + separator
      		//+ compositororder + separator + reportcondition + separator
      		//+ fieldwidth+separator+valueone+separator
      		//+ valuetwo+separator+valuethree+separator
      		//+ valuefour+separator+httype+separator
      		//+htdetailtype;
      		String para = reportid + separator + fieldid + separator
      				+ dsporder + separator + isstat + separator
      				+ dborder + separator + dbordertype + separator + compositororder;
      		//System.out.println("para = "+para);
      		RecordSet.executeProc("Workflow_ReportDspField_Insert",para);
			RecordSet.executeSql("update Workflow_ReportDspField set fieldwidth="+fieldwidth+"  where fieldid = "+fieldid+" and reportid="+reportid);
   		}else{
      		String fieldid = "" + Util.getIntValue(request.getParameter("fieldid_"+i),0);
		    String dsporder = Util.null2String(request.getParameter("dsporder_"+i)); //xwj for td2974 20051026
		    String isstat = Util.null2String(request.getParameter("isstat_"+i));
		    String dborder = Util.null2String(request.getParameter("dborder_"+i));
		    String reportcondition = Util.null2String(request.getParameter("reportcondition_"+i));
		    String fieldwidth = Util.null2String(request.getParameter("fieldwidth_"+i));
		    String dbordertype = Util.null2String(request.getParameter("dbordertype_"+i));//added by xwj for td2099 for 2005-06-06
		    String compositororder = Util.null2String(request.getParameter("compositororder_"+i));//added by xwj for td2099 for 2005-06-06

		    String defaultval = Util.null2String(request.getParameter("default_"+i));
		    String htdetailtype = Util.null2String(request.getParameter("type_"+i));
		    String httype = Util.null2String(request.getParameter("httype_"+i));
		    String valueone = "";
		    String valuetwo = "";
		    String valuethree = "";
		    String valuefour = "";
		    if(!defaultval.equals("")){
		    	  String[] arr=defaultval.split("~");
		    	  valueone = arr[0];
		    	if(arr.length>1)
		    	  valuetwo = arr[1];
		    	if(arr.length>2)
		    	  valuethree = arr[2];
		    	if(arr.length>3)
			      valuefour = arr[3];
		    }
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
       			dbordertype = "n";//added by xwj for td2099 for 2005-06-06
       		}
       		if(compositororder.equals(""))
       		{
       			compositororder = "0";//added by xwj for td2099 for 2005-06-06
       		}
       		if(reportcondition.equals("")) 
      		{
       			reportcondition = "0" ;
      		}
       		if(fieldwidth.equals("")) 
      		{
       			fieldwidth = "0" ;
      		}
        	if(dsporder.equals(""))
        	{
        		dsporder = "0";//added by xwj for td2099 for 2005-06-06
        	}
      		String para = reportid + separator + dsporder + separator
      		+ isstat + separator + dborder + separator
      		+ dbordertype + separator + compositororder + separator
      		+ fieldid + separator + reportcondition + separator
      		+ fieldwidth+separator+valueone+separator
      		+ valuetwo+separator+valuethree+separator
      		+ valuefour+separator+httype+separator
      		+ htdetailtype;
      		RecordSet.executeProc("Workflow_RepDspFld_Insert_New",para);
   		}
    	
    }
    
	response.sendRedirect("/workflow/report/ReportFieldAdd.jsp?id="+reportid+"&dbordercount=0&isclose=1");
}
else if(operation.equals("deletefield"))
{
  	String reportID = Util.null2String(request.getParameter("id"));
	String fieldID = "" + Util.getIntValue(request.getParameter("theid"), 0);
	String sql = "Update Workflow_ReportDspField set FieldidBak = FieldId, FieldId = null Where id = %1$s";
	sql = String.format(sql, fieldID);
	RecordSet.executeSql(sql);
	response.sendRedirect("ReportEdit.jsp?id=" + reportID);
}
%>