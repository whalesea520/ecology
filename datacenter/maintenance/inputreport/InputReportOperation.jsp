<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="InputReportModuleFile" class="weaver.datacenter.InputReportModuleFile" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="InputReportComInfo" class="weaver.datacenter.InputReportComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<%
String operation = Util.null2String(request.getParameter("operation"));
String inprepid = Util.null2String(request.getParameter("inprepid"));
String inprepname = Util.fromScreen(request.getParameter("inprepname"),user.getLanguage());
String inpreptablename = Util.null2String(request.getParameter("inpreptablename"));
String inprepfrequence = Util.null2String(request.getParameter("inprepfrequence"));
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));
String oldinprepbudget = Util.null2String(request.getParameter("oldinprepbudget"));
String inprepforecast = Util.null2String(request.getParameter("inprepforecast"));
String oldinprepforecast = Util.null2String(request.getParameter("oldinprepforecast"));
String crmid = Util.null2String(request.getParameter("crmid"));
String inprepcrmid = Util.null2String(request.getParameter("inprepcrmid"));
String startdate = Util.null2String(request.getParameter("startdate")) ;
String enddate = Util.null2String(request.getParameter("enddate")) ;
String modulefilename = Util.null2String(request.getParameter("modulefilename")); //模板文件名称
String helpdocid = Util.null2String(request.getParameter("helpdocid")); //帮助文档
String hastable = Util.null2String(request.getParameter("hastable")); //是否已经有同名的表
String isInputMultiLine = Util.null2String(request.getParameter("isInputMultiLine")); //是否填报多行
if(!("1".equals(isInputMultiLine))){
	isInputMultiLine="0";
}
int billId = Util.getIntValue(request.getParameter("billId"),0); //单据id


String inprepbugtablename = "" ;
String inprepfortablename = "" ;

if(inprepbudget.equals("1")) inprepbugtablename = inpreptablename + "_buget" ;
else  inprepbudget = "0" ;

if(inprepforecast.equals("1")) inprepfortablename = inpreptablename + "_forecast" ;
else  inprepforecast = "0" ;

RecordSetTrans.setAutoCommit(false);

if(operation.equals("add")){
  try{
	//获取显示名的标签id
	int nameLabelId=0;
	String sql="select id from HtmlLabelIndex where indexdesc='"+inprepname+"'";
	RecordSetTrans.executeSql(sql);
	if(RecordSetTrans.next()){
		nameLabelId = Util.getIntValue(RecordSetTrans.getString("id"),0);
	}else{
		sql="select min(id) as id from HtmlLabelIndex";
		RecordSetTrans.executeSql(sql);
		if(RecordSetTrans.next()){
			nameLabelId = Util.getIntValue(RecordSetTrans.getString("id"),0);
		}
		if(nameLabelId>0){
			nameLabelId = -1;
		}
		nameLabelId-=1;		    	
		sql="INSERT INTO HtmlLabelIndex values("+nameLabelId+",'"+inprepname+"')"; 
		RecordSetTrans.executeSql(sql);
		sql="INSERT INTO HtmlLabelInfo VALUES("+nameLabelId+",'"+inprepname+"',7)";
		RecordSetTrans.executeSql(sql);		
	}

	sql="select min(id) as id from workflow_bill";
	RecordSetTrans.executeSql(sql);
	if(RecordSetTrans.next()){
		billId = Util.getIntValue(RecordSetTrans.getString("id"),0);
	}
	if(billId>0){
		billId = -1;
	}
	billId-=1;	
	
	if("1".equals(isInputMultiLine)){
		RecordSetTrans.executeSql("INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage,hasFileUp) VALUES("+billId+","+nameLabelId+",'"+inpreptablename+"_main','AddBillDataCenter.jsp','ManageBillDataCenter.jsp','','"+inpreptablename+"','mainId','BillDataCenterOperation.jsp','1')");
		RecordSetTrans.executeSql("INSERT INTO workflow_billdetailtable (billid,tablename,orderid) values("+billId+",'"+inpreptablename+"',1)");

	}else{
		RecordSetTrans.executeSql("INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage,hasFileUp) VALUES("+billId+","+nameLabelId+",'"+inpreptablename+"','AddBillDataCenter.jsp','ManageBillDataCenter.jsp','','','','BillDataCenterOperation.jsp','1') ");

	}
	BillComInfo.removeBillCache();
	RecordSetTrans.executeSql("INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES ("+billId+",'reportUserId',20715,'int',3,1,-3,0,'')");
	RecordSetTrans.executeSql("INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES ("+billId+",'inprepDspDate',20716,'varchar(80)',1,1,-2,0,'')");
	RecordSetTrans.executeSql("INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES ("+billId+",'crmId',16902,'int',3,7,-1,0,'')");


    char separator = Util.getSeparator() ;
	String para = inprepname + separator + inpreptablename	+ separator + inprepbugtablename + separator + inprepfrequence + separator + inprepbudget + separator + inprepforecast  + separator + startdate + separator + enddate + separator + modulefilename + separator + helpdocid + separator + isInputMultiLine  + separator + billId  ;


	RecordSetTrans.executeProc("T_InputReport_Insert",para);

    if(!hastable.equals("1")) {
		String createSequence = "";
		String createTrigger = "";
		String createtable = "";
        RecordSetTrans.setChecksql(false);
		if("1".equals(isInputMultiLine)){
			if("oracle".equals(RecordSet.getDBType())){
			   createtable=" create table " + inpreptablename +"_main" +
                             " (id  integer , " +
                             " requestId  integer ," +
                             " crmId  integer ," +
                             " reportDate char(10) ," +
                             " inprepDspDate varchar2(80) ," +
                             " inputDate char(10) ," +
                             " inputStatus char(1) default '0', " +
                             " reportUserid integer , " +
                             " confirmUserId integer , " +
                             " modType char(1) default '0') " ;
			    createSequence = "create sequence "+inpreptablename+"_main_Id" +
                                  " start with 1 increment by 1  nomaxvalue  nocycle";
				createTrigger = "CREATE OR REPLACE TRIGGER "+inpreptablename+"_mainIDT" +
                                  " before insert on " +inpreptablename +"_main" +
	                              " for each row begin select "+inpreptablename+"_main_Id.nextval into :new.id from dual; end;";

				RecordSetTrans.executeSql(createtable);
                RecordSetTrans.executeSql(createSequence);
				RecordSetTrans.executeSql(createTrigger);

				createtable     =" create table " + inpreptablename +
								 " (inputid  integer , " +
								 " mainId  integer ," +
								 " crmId  integer ," +
								 " reportDate char(10) ," +
								 " inprepDspDate varchar2(80) ," +
								 " inputDate char(10) ," +
								 " inputStatus char(1) default '0', " +
								 " reportUserid integer , " +
								 " confirmUserId integer , " +
								 " modType char(1) default '0') " ;
				createSequence = "create sequence "+inpreptablename+"_Id " +
                                  " start with 1 increment by 1  nomaxvalue  nocycle";
				createTrigger = "CREATE OR REPLACE TRIGGER "+inpreptablename+"_IdT" +
                                  " before insert on " +inpreptablename +
	                              " for each row begin select "+inpreptablename+"_Id.nextval into :new.inputid from dual; end;";
				RecordSetTrans.executeSql(createtable);
				RecordSetTrans.executeSql(createSequence);
				RecordSetTrans.executeSql(createTrigger);
			}else{
				createtable=" create table " + inpreptablename +"_main" +
								 " (id  int IDENTITY(1,1) primary key CLUSTERED, " +
								 " requestId  int ," +
								 " crmId  int ," +
								 " reportDate char(10) ," +
								 " inprepDspDate varchar(80) ," +
								 " inputDate char(10) ," +
								 " inputStatus char(1) default '0', " +
								 " reportUserid int , " +
								 " confirmUserId int , " +
								 " modType char(1) default '0') " ;
				RecordSetTrans.executeSql(createtable);
				createtable     =" create table " + inpreptablename + 
								 " (inputid  int IDENTITY(1,1) primary key CLUSTERED, " +
								 " mainId  int ," +
								 " crmId  int ," +
								 " reportDate char(10) ," +
								 " inprepDspDate varchar(80) ," +
								 " inputDate char(10) ," +
								 " inputStatus char(1) default '0', " +
								 " reportUserid int , " +
								 " confirmUserId int , " +
								 " modType char(1) default '0') " ;
				RecordSetTrans.executeSql(createtable);
		    }
		}else{
			if("oracle".equals(RecordSet.getDBType())){
			  createtable=" create table " + inpreptablename + 
                             " (id  integer , " +
                             " inputId  integer ," +
                             " requestId  integer ," +
                             " crmId  integer ," +
                             " reportDate char(10) ," +
                             " inprepDspDate varchar2(80) ," +
                             " inputDate char(10) ," +
                             " inputStatus char(1) default '0', " +
                             " reportUserid integer , " +
                             " confirmUserId integer , " +
                             " modType char(1) default '0') " ;
			  createSequence = "create sequence "+inpreptablename+"_Id"+
                                  " start with 1 increment by 1  nomaxvalue  nocycle";
              createTrigger = "CREATE OR REPLACE TRIGGER "+inpreptablename+"_IdT"+
                                  " before insert on " +inpreptablename+
	                              " for each row begin select "+inpreptablename+"_Id.nextval into :new.id from dual; end;";
              RecordSetTrans.executeSql(createtable);
			  RecordSetTrans.executeSql(createSequence);
			  RecordSetTrans.executeSql(createTrigger);
			}else{
				createtable=" create table " + inpreptablename + 
								 " (id  int IDENTITY(1,1) primary key CLUSTERED, " +
								 " inputId  int ," +
								 " requestId  int ," +
								 " crmId  int ," +
								 " reportDate char(10) ," +
								 " inprepDspDate varchar(80) ," +
								 " inputDate char(10) ," +
								 " inputStatus char(1) default '0', " +
								 " reportUserid int , " +
								 " confirmUserId int , " +
								 " modType char(1) default '0') " ;
				RecordSetTrans.executeSql(createtable);
			}
		}
    }
    
	InputReportComInfo.removeConditionCache();
	RecordSetTrans.commit();
	LabelComInfo.addLabeInfoCache(String.valueOf(nameLabelId));
  }catch(Exception exception){
	  RecordSetTrans.rollback();
  }
 	response.sendRedirect("InputReport.jsp");
 }
 
else if(operation.equals("edit")){
  try{
    char separator = Util.getSeparator() ;

    String para = ""+inprepid + separator + inprepname + separator + inpreptablename + separator + inprepbugtablename + separator + inprepfrequence + separator + inprepbudget  + separator + inprepforecast + separator + startdate + separator + enddate + separator + modulefilename + separator + helpdocid + separator + isInputMultiLine  + separator + billId  ;

	RecordSetTrans.executeProc("T_InputReport_Update",para);
	int nameLabelId=0;
	String sql="select id from HtmlLabelIndex where indexdesc='"+inprepname+"'";
	RecordSetTrans.executeSql(sql);
	if(RecordSetTrans.next()){
		nameLabelId = Util.getIntValue(RecordSetTrans.getString("id"),0);
	}else{
		sql="select min(id) as id from HtmlLabelIndex";
		RecordSetTrans.executeSql(sql);
		if(RecordSetTrans.next()){
			nameLabelId = Util.getIntValue(RecordSetTrans.getString("id"),0);
		}
		if(nameLabelId>0){
			nameLabelId = -1;
		}
		nameLabelId-=1;		    	
		sql="INSERT INTO HtmlLabelIndex values("+nameLabelId+",'"+inprepname+"')"; 
		RecordSetTrans.executeSql(sql);
		sql="INSERT INTO HtmlLabelInfo VALUES("+nameLabelId+",'"+inprepname+"',7)";
		RecordSetTrans.executeSql(sql);		
	}
	RecordSetTrans.executeSql("update workflow_bill set nameLabel="+nameLabelId+" where id="+billId);
	InputReportComInfo.removeConditionCache();
	BillComInfo.removeBillCache();
	RecordSetTrans.commit();
	LabelComInfo.addLabeInfoCache(String.valueOf(nameLabelId));
  }catch(Exception exception){
	  RecordSetTrans.rollback();
  }	
 	response.sendRedirect("InputReport.jsp");
 }
 else if(operation.equals("delete")){
  try{
	RecordSetTrans.executeSql("update workflow_base set isValid='0'  where formId="+billId+" and isBill='1'");
	WorkflowComInfo.removeWorkflowCache();
	RecordSetTrans.executeSql("update workflow_bill set inValid=1 where id="+billId);
	RecordSetTrans.executeSql("update T_inputReport set deleted=1 where inprepId="+inprepid);
	
	InputReportComInfo.removeConditionCache();
	RecordSetTrans.commit();
  }catch(Exception exception){
	  RecordSetTrans.rollback();
  }	
 	response.sendRedirect("InputReport.jsp");
 }

 else if(operation.equals("addcrm")){
    char separator = Util.getSeparator() ;
	String para = ""+inprepid + separator + crmid ;
	RecordSet.executeProc("T_InputReportCrm_Insert",para);

 	response.sendRedirect("InputReportEdit.jsp?inprepid="+inprepid);
 }

 else if(operation.equals("deletecrm")){
    char separator = Util.getSeparator() ;
	String para = ""+inprepcrmid;
	RecordSet.executeProc("T_InputReportCrm_Delete",para);

 	response.sendRedirect("InputReportEdit.jsp?inprepid="+inprepid);
 }

 else if(operation.equals("close")){
    
	RecordSet.executeSql("update T_InputReport set inprepbudgetstatus = '2' where inprepid="+inprepid);

 	response.sendRedirect("InputReportEdit.jsp?inprepid="+inprepid);
 }

else if(operation.equals("open")){
    
	RecordSet.executeSql("update T_InputReport set inprepbudgetstatus = '1' where inprepid="+inprepid);

 	response.sendRedirect("InputReportEdit.jsp?inprepid="+inprepid);
 }
 else if(operation.equals("editcontactright")){
	RecordSet.executeSql("delete T_InputReportCrmContacter where inprepcrmid="+inprepcrmid);
    String contacterids[] = request.getParameterValues("contacterid") ;
    if( contacterids != null ) {
        for(int i=0 ; i<contacterids.length ; i++) {
            RecordSet.executeSql("insert into T_InputReportCrmContacter( inprepcrmid, contacterid ) values("+inprepcrmid +" , " + contacterids[i]+" ) ");
        }
    }

    RecordSet.executeSql("delete T_InputReportCrmModer where inprepcrmid="+inprepcrmid);
    String contactmoderids[] = request.getParameterValues("contactmoderid") ;
    if( contactmoderids != null ) {
        for(int i=0 ; i<contactmoderids.length ; i++) {
            RecordSet.executeSql("insert into T_InputReportCrmModer( inprepcrmid, contacterid ) values("+inprepcrmid +" , " + contactmoderids[i]+" ) ");
        }
    }

    RecordSet.executeSql("delete T_InputReportCrmSel where inprepcrmid="+inprepcrmid);
    String contactselcrms[] = request.getParameterValues("contactselcrm") ;
    if( contactselcrms != null ) {
        for(int i=0 ; i<contactselcrms.length ; i++) {
            String contactselcrmid = Util.null2String(request.getParameter("crmid_"+contactselcrms[i]));
            RecordSet.executeSql("insert into T_InputReportCrmSel( inprepcrmid, contacterid , selcrm) values("+inprepcrmid +" , " + contactselcrms[i]+" , '" + contactselcrmid + "' ) ");
        }
    }
 	response.sendRedirect("InputReportEdit.jsp?inprepid="+inprepid);
 }
%>
