
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="WorkFlowUtil" class="weaver.workflow.workflow.WorkFlowUtil" scope="page" />

<%
session.removeAttribute("branchid");
String whereclause="";
String orderclause="";
String orderclause2="";
String userid = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
String logintype = ""+user.getLogintype();
int usertype = 0;

if(userid.equals("")) {
	userid = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}

String tablename="workflow_form";
String isbill="0";
String formID="0";
String workflowid=Util.null2String(request.getParameter("workflowid"));
String workflowidtemp=workflowid;
String customid=Util.null2String(request.getParameter("customid"));
if(!customid.equals("")){
    rs.executeSql("select * from workflow_custom where id="+customid);
    if(rs.next()){
        if(workflowid.equals("")) workflowid=Util.null2String(rs.getString("workflowids"));
        isbill=""+Util.getIntValue(rs.getString("isbill"),0);
        formID=""+Util.getIntValue(rs.getString("formid"),0);
    }
}else{
    isbill=""+Util.getIntValue(WorkflowComInfo.getIsBill(workflowid),0);
    formID=""+Util.getIntValue(WorkflowComInfo.getFormId(workflowid),0);
}
 if(isbill.equals("1"))
        {
        rs.executeSql("select tablename from workflow_bill where id = " + formID); // 查询工作流单据表的信息
			if (rs.next())
				tablename = rs.getString("tablename");          // 获得单据的主表
			
		}
String moudle=Util.null2String(request.getParameter("moudle"));
String method=Util.null2String(request.getParameter("method"));
String overtime=Util.null2String(request.getParameter("overtime"));
String fromPDA = Util.null2String((String)session.getAttribute("loginPAD"));   //从PDA登录
String complete1=Util.null2String(request.getParameter("complete"));

String wftypetemp=Util.null2String(request.getParameter("wftype"));
String issimple=Util.null2String(request.getParameter("issimple"));
String searchtype=Util.null2String(request.getParameter("searchtype"));
SearchClause.setWorkflowId(workflowid);
whereclause = " (t1.deleted=0 or t1.deleted is null) ";
if(method.equals("myreqeustbywfid")){
	 workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid = "+workflowid+" ";
	}
	else {
		whereclause +=" and t1.workflowid = "+workflowid+" ";
	}
	
	whereclause +=" and t1.creater = "+userid+" and t1.creatertype = " + usertype;
	
	if(complete.equals("0")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> '3'  and t2.islasttimes=1";
	}
	else if(complete.equals("1")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
	response.sendRedirect("WFCustomSearchResult.jsp?tablename="+tablename+"&workflowid="+workflowid+"&moudle="+moudle+"&start=1");
	return;
}



if(method.equals("reqeustbywfid")){
	 workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid = "+workflowid+" ";
	}
	else {
		whereclause +=" and t1.workflowid = "+workflowid+" ";
	}
	//complete=0表示待办事宜
	if(complete.equals("0")){
		whereclause +=" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
		//modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直都在待办事宜中显示
        //whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark ='1' and t1.currentnodetype = '3')) and t2.islasttimes=1";
	
	}
    //complete=1表示办结事宜
	else if(complete.equals("1")){
		whereclause += " and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
	}
    //complete=2表示已办事宜
	else if(complete.equals("2")){
		whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
	}
    //complete=3表示待办事宜，红色new标记
	else if(complete.equals("3")){
		whereclause +=" and t2.isremark in( '0','1','5','8','9','7') ";
        whereclause += " and  t2.viewtype=0 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='5' or t2.isremark='8' or t2.isremark='9' or t2.isremark='7') ";
	}
    //complete=4表示待办事宜，灰色new标记
	else if(complete.equals("4")){
		whereclause +=" and t2.isremark in( '0','1','5','8','9','7') ";
        whereclause += " and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='5' or t2.isremark='8' or t2.isremark='9' or t2.isremark='7') ";
	}
    //complete=5表示已办事宜，灰色new标记
	else if(complete.equals("5")){
		whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1";
	}
    //complete=6表示办结事宜，红色new标记
	else if(complete.equals("6")){
        whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=0";
	}
    //complete=7表示办结事宜，灰色new标记
	else if(complete.equals("7")){
        whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1";
	}
    //complete=8表示超时事宜，
	else if(complete.equals("8")){
        whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') ";
        whereclause += " and t1.currentnodetype <> 3 ";
	}
    SearchClause.setWhereClause(whereclause);
    if(complete.equals("0")||complete.equals("3")||complete.equals("4")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")||complete.equals("5")||complete.equals("6")||complete.equals("7")||complete.equals("8")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
   
  if(complete.equals("0"))
	  response.sendRedirect("WFCustomSearchResult.jsp?tablename="+tablename+"&workflowid="+workflowid+"&moudle="+moudle+"&start=1&iswaitdo=1");
  else
    response.sendRedirect("WFCustomSearchResult.jsp?tablename="+tablename+"&workflowid="+workflowid+"&moudle="+moudle+"&start=1");
	return;
}
String createrid=Util.null2String(request.getParameter("createrid"));
String docids=Util.null2String(request.getParameter("docids"));
String crmids=Util.null2String(request.getParameter("crmids"));
String hrmids=Util.null2String(request.getParameter("hrmids"));
String prjids=Util.null2String(request.getParameter("prjids"));
String creatertype=Util.null2String(request.getParameter("creatertype"));

String nodetype=Util.null2String(request.getParameter("nodetype"));
String requeststatus=Util.null2String(request.getParameter("requeststatus"));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String todate=Util.null2String(request.getParameter("todate"));
String lastfromdate=Util.null2String(request.getParameter("lastfromdate"));
String lasttodate=Util.null2String(request.getParameter("lasttodate"));
String requestmark=Util.null2String(request.getParameter("requestmark"));
String branchid=Util.null2String(request.getParameter("branchid"));
if (!branchid.equals("")) session.setAttribute("branchid",branchid);
int during=Util.getIntValue(request.getParameter("during"),0);
int order=Util.getIntValue(request.getParameter("order"),0);
int isdeleted=Util.getIntValue(request.getParameter("isdeleted"),0);
String requestname=Util.fromScreen2(request.getParameter("requestname"),user.getLanguage());
requestname=requestname.trim();
int subday1=Util.getIntValue(request.getParameter("subday1"),0);
int subday2=Util.getIntValue(request.getParameter("subday2"),0);
int maxday=Util.getIntValue(request.getParameter("maxday"),0);
int state=Util.getIntValue(request.getParameter("state"),0);
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
//add by xhheng @20050414 for TD 1545
int iswaitdo= Util.getIntValue(request.getParameter("iswaitdo"),0) ;
String userids="";
String receivefromdate="";
String receivetodate="";

//下面开始自定义查询条件
String[] checkcons = request.getParameterValues("check_con");
String sqlwhere=" ";
ArrayList ids = new ArrayList();
ArrayList colnames = new ArrayList();
ArrayList opts = new ArrayList();
ArrayList values = new ArrayList();
ArrayList names = new ArrayList();
ArrayList opt1s = new ArrayList();
ArrayList value1s = new ArrayList();
ids.clear();
colnames.clear();
opt1s.clear();
names.clear();
value1s.clear();
opts.clear();
values.clear();
Hashtable conht=new Hashtable();
if(checkcons!=null){

for(int i=0;i<checkcons.length;i++){

		String tmpid = ""+checkcons[i];
		String tmpcolname = ""+Util.null2String(request.getParameter("con"+tmpid+"_colname"));
		String htmltype = ""+Util.null2String(request.getParameter("con"+tmpid+"_htmltype"));
		String type = ""+Util.null2String(request.getParameter("con"+tmpid+"_type"));
		String tmpopt = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt"));
		String tmpvalue = ""+Util.null2String(request.getParameter("con"+tmpid+"_value"));
		String tmpname = ""+Util.null2String(request.getParameter("con"+tmpid+"_name"));
		String tmpopt1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt1"));
		String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_value1"));
        conht.put("con_"+tmpid,"1");
        conht.put("con_"+tmpid+"_opt",tmpopt);
        conht.put("con_"+tmpid+"_opt1",tmpopt1);
        conht.put("con_"+tmpid+"_value",tmpvalue);
        conht.put("con_"+tmpid+"_value1",tmpvalue1);
        conht.put("con_"+tmpid+"_name",tmpname);
    if(tmpid.equals("_1")){
        requestname=tmpvalue;
    }else if(tmpid.equals("_2")){
        requestlevel=tmpvalue;
    }else if(tmpid.equals("_3")){
        fromdate=tmpvalue;
        todate=tmpvalue1;
    }else if(tmpid.equals("_4")){
        createrid=tmpvalue;
    }else if(tmpid.equals("_5")){
        workflowid=tmpvalue;
        workflowidtemp=tmpvalue;
    }else if(tmpid.equals("_6")){
        nodetype=tmpvalue;
    }else if(tmpid.equals("_7")){
        receivefromdate=tmpvalue;
        receivetodate=tmpvalue1;
    }else if(tmpid.equals("_8")){
        isdeleted=Util.getIntValue(tmpvalue,0);
    }else if(tmpid.equals("_9")){
        userids=tmpvalue;
    }else if(tmpid.equals("_10")){
    	requeststatus=tmpvalue;
    }else{
    	//是自定义表单
  	  String isnull="nvl";
         if(!rs2.getDBType().equals("oracle")){
      	   isnull="isNull";
         }
     	 if(isbill.equals("1")){
     		 rs2.executeSql("select t.id, t.fieldname, t.detailtable, bdt.id,bil.tablename,"+isnull+"(bil.detailkeyfield,'mainid') detailkeyfield from workflow_billfield t, Workflow_billdetailtable bdt,workflow_bill bil where bil.id = bdt.billid and t.detailtable = bdt.tablename and t.id = "+tmpid+" and viewtype = 1 "); // 查询工作流单据表的信息
     	 }
   	 //是系统表单,查询是否是明细表字段属性
   	 else{
   		rs2.executeSql("select * from workflow_formdictdetail where id= "+tmpid);
   	 } 
   	 //如果是明细表字段,进行下面的处理.
   	if (rs2.next()){ 
   		String tempsql = WorkFlowUtil.getQuerySqlCondition("dt", htmltype,  type,
   				 tmpid,  tmpopt,  tmpopt1,  tmpvalue,
   				 tmpvalue1,  tmpcolname,  isoracle,  isdb2);	
   		//如果是单据,添加明细表的条件!!
   		 if(isbill.equals("1")){
   				//得到明细字段的列名.
   				String fdname = rs2.getString("fieldname");
   				//明细表名
   				String dtname = rs2.getString("detailtable");
   				//主表名
   				String tbname = rs2.getString("tablename");
   				//主表明细表关联属性
   				String dkeyfield = rs2.getString("detailkeyfield"); 
   				sqlwhere+=" and exists( select 1 from "+dtname+" dt where dt."+dkeyfield 

   	+"=d.id "+tempsql+") ";
   		 } 
   		else{
   			//得到系统表单的明细表属性列名
   			String dtfieldname = rs2.getString("fieldname");
   			//系统表单的明细表就是一张表,叫做Workflow_formdetail,主表和明细表是通过requestid关联.
   			sqlwhere+=" and exists( select 1 from Workflow_formdetail dt where dt.requestid=t1.requestid "+tempsql+") ";
   		}
   	}
   	//不是明细表字段进行下面的处理.
   	else{  
   		sqlwhere+=WorkFlowUtil.getQuerySqlCondition("d", htmltype,  type,
   				 tmpid,  tmpopt,  tmpopt1,  tmpvalue,
   				 tmpvalue1,  tmpcolname,  isoracle,  isdb2);
   	}  
   	}
   	}
   	} 
//if (!sqlwhere.equals(""))
//sqlwhere =" and exists (select 1 from "+tablename+"  where 1=1 "+sqlwhere+" )" ;
session.setAttribute("requestmark_"+userid,requestmark);
session.setAttribute("isdeleted_"+userid,""+isdeleted);
session.setAttribute("nodetype_"+userid,nodetype);
session.setAttribute("requeststatus_"+userid,requeststatus);
session.setAttribute("fromdate_"+userid,fromdate);
session.setAttribute("todate_"+userid,todate);
session.setAttribute("during_"+userid,""+during);
session.setAttribute("createrid_"+userid,createrid);
session.setAttribute("docids_"+userid,docids);
session.setAttribute("crmids_"+userid,crmids);
session.setAttribute("prjids_"+userid,prjids);
session.setAttribute("hrmids_"+userid,hrmids);
session.setAttribute("requestname_"+userid,requestname);
session.setAttribute("requestlevel_"+userid,requestlevel);
session.setAttribute("conhashtable_"+userid,conht);    
//自定义结束
Calendar now = Calendar.getInstance();
String today=Util.add0(now.get(Calendar.YEAR), 4) +"-"+
	Util.add0(now.get(Calendar.MONTH) + 1, 2) +"-"+
        Util.add0(now.get(Calendar.DAY_OF_MONTH), 2) ;
int year=now.get(Calendar.YEAR);
int month=now.get(Calendar.MONTH);
int day=now.get(Calendar.DAY_OF_MONTH);

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);


if(!createrid.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.creater='"+createrid+"'";}
	else {whereclause+=" and t1.creater='"+createrid+"'";}
	if(!creatertype.equals("")){
		if(whereclause.equals("")) {whereclause+=" t1.creatertype='"+creatertype+"'";}
		else {whereclause+=" and t1.creatertype='"+creatertype+"'";}
	}
}

//添加附件上传文档的查询
if(!docids.equals("")){
    RecordSet.executeSql("select fieldname from workflow_formdict where fieldhtmltype=6 ");
}

if( isoracle ) {
    if(!docids.equals("")){
        if(whereclause.equals("")) {whereclause+=" ((concat(concat(',' , To_char(t1.docids)) , ',') LIKE '%,"+docids+",%') ";}
        else {whereclause+=" and ((concat(concat(',' , To_char(t1.docids)) , ',') LIKE '%,"+docids+",%') ";}
        while(RecordSet.next()){
            String fieldname=RecordSet.getString("fieldname");
            whereclause+=" or (concat(concat(',' , To_char(t4."+fieldname+")) , ',') LIKE '%,"+docids+",%') ";
        }
        whereclause+=") ";
    }
    if(!crmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , To_char(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , To_char(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";}
    }
    if(!hrmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , To_char(t1.hrmids)) , ',') LIKE '%,"+hrmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , To_char(t1.hrmids)) , ',') LIKE '%,"+hrmids+",%') ";}
    }
    if(!prjids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , To_char(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , To_char(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";}
    }
}else if( isdb2 ) {
    if(!docids.equals("")){
        if(whereclause.equals("")) {whereclause+=" ((concat(concat(',' , varchar(t1.docids)) , ',') LIKE '%,"+docids+",%') ";}
        else {whereclause+=" and ((concat(concat(',' , varchar(t1.docids)) , ',') LIKE '%,"+docids+",%') ";}
        while(RecordSet.next()){
            String fieldname=RecordSet.getString("fieldname");
            whereclause+=" or (concat(concat(',' , varchar(t4."+fieldname+")) , ',') LIKE '%,"+docids+",%') ";
        }
        whereclause+=") ";
    }
    if(!crmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , varchar(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , varchar(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";}
    }
    if(!hrmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , varchar(t1.hrmids)) , ',') LIKE '%,"+hrmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , varchar(t1.hrmids)) , ',') LIKE '%,"+hrmids+",%') ";}
    }
    if(!prjids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , varchar(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , varchar(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";}
    }
}
else {
    if(!docids.equals("")){
        if(whereclause.equals("")) {whereclause+=" ((',' + CONVERT(varchar,t1.docids) + ',' LIKE '%,"+docids+",%') ";}
        else {whereclause+=" and ((',' + CONVERT(varchar,t1.docids) + ',' LIKE '%,"+docids+",%') ";}
        while(RecordSet.next()){
            String fieldname=RecordSet.getString("fieldname");
            whereclause+=" or (',' + CONVERT(varchar,t4."+fieldname+") + ',' LIKE '%,"+docids+",%') ";
        }
        whereclause+=") ";
    }
    if(!crmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";}
        else {whereclause+=" and (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";}
    }
    if(!hrmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (',' + CONVERT(varchar,t1.hrmids) + ',' LIKE '%,"+hrmids+",%') ";}
        else {whereclause+=" and (',' + CONVERT(varchar,t1.hrmids) + ',' LIKE '%,"+hrmids+",%') ";}
    }
    if(!prjids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";}
        else {whereclause+=" and (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";}
    }
}
if(!workflowid.equals("")){
	if(whereclause.equals("")){
		whereclause +=" t1.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') and id in ("+WorkflowVersion.getAllVersionStringByWFIDs(workflowid) +")) ";
	}else{
		whereclause = " t1.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') and id in ("+WorkflowVersion.getAllVersionStringByWFIDs(workflowid) + ")) and " + whereclause; 
	}
}else if(!customid.equals("")){
    if(whereclause.equals(""))
	{whereclause+=" t1.workflowid in(select id from workflow_base where formid="+formID+" and isbill='"+isbill+"' and (isvalid='1' or isvalid='3'))";}
	else
	{
	 whereclause = " t1.workflowid in(select id from workflow_base where formid="+formID+" and isbill='"+isbill+"' and (isvalid='1' or isvalid='3')) and " + whereclause;
	}
}
if(!requeststatus.equals("")){
	if(!whereclause.equals(""))
		whereclause+=" and ";
	if(requeststatus.equals("0")){ //代办
		whereclause +="  t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1 ";
	}
    //requeststatus=1 表示已办事宜
	else if(requeststatus.equals("1")){ 
		whereclause += "  t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
	}
    //requeststatus=2 表示办结事宜
	else if(requeststatus.equals("2")){
		whereclause += "  t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1 ";
	}
	//抄送
	else if(requeststatus.equals("3")){
		whereclause += "  t2.isremark in ('8', '9','7') ";
	}
	//超时
	else if(requeststatus.equals("4")){
		whereclause += "  ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and t1.currentnodetype <> 3 ";
	}//反馈
	else if(requeststatus.equals("5")){
		whereclause += "  (( t2.isremark in( '0','1','8','9','7') and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='7')) or ";
		whereclause += " (t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1) or ";
		whereclause += " (t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1))";
	}
}

if(!requestname.equals("")){
    if(whereclause.equals("")) {whereclause+=" (t1.requestname";}
	else {whereclause+=" and (t1.requestname";}
    ArrayList tempvalues=Util.TokenizerString(Util.StringReplace(requestname,"　"," ")," ");
    for(int k=0;k<tempvalues.size();k++){
        if(k>0) whereclause += " or t1.requestname";
        String tmpvalue=Util.StringReplace(Util.StringReplace((String)tempvalues.get(k),"+","%"),"＋","%");
        if(!isoracle&&!isdb2){
            int indx=tmpvalue.indexOf("[");
            if(indx<0) indx=tmpvalue.indexOf("]");
            if(indx<0){
                whereclause += " like '%"+tmpvalue+"%' ";
            }else{
                whereclause += " like '%"+Util.StringReplace(Util.StringReplace(Util.StringReplace(tmpvalue,"/","//"),"[","/["),"]","/]")+"%' ESCAPE '/' ";
            }
        }else{
            whereclause += " like '%"+tmpvalue+"%' ";
        }
    }
	whereclause+=")";
}
if(!nodetype.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype='"+nodetype+"'";}
	else {whereclause+=" and t1.currentnodetype='"+nodetype+"'";}
}
if(!requestmark.equals("")){
    if(whereclause.equals("")) {whereclause+=" (t1.requestmark";}
	else {whereclause+=" and (t1.requestmark";}
    ArrayList tempvalues=Util.TokenizerString(Util.StringReplace(requestmark,"　"," ")," ");
    for(int k=0;k<tempvalues.size();k++){
        if(k>0) whereclause += " or t1.requestmark";
        String tmpvalue=Util.StringReplace(Util.StringReplace((String)tempvalues.get(k),"+","%"),"＋","%");
        if(!isoracle&&!isdb2){
            int indx=tmpvalue.indexOf("[");
            if(indx<0) indx=tmpvalue.indexOf("]");
            if(indx<0){
                whereclause += " like '%"+tmpvalue+"%' ";
            }else{
                whereclause += " like '%"+Util.StringReplace(Util.StringReplace(Util.StringReplace(tmpvalue,"/","//"),"[","/["),"]","/]")+"%' ESCAPE '/' ";
            }
        }else{
            whereclause += " like '%"+tmpvalue+"%' ";
        }
    }
	whereclause+=")";
}

if(!lastfromdate.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.lastoperatedate>='"+lastfromdate+"'";}
	else {whereclause+=" and t1.lastoperatedate>='"+lastfromdate+"'";}
}
if(!lasttodate.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.lastoperatedate<='"+lasttodate+"'";}
	else {whereclause+=" and t1.lastoperatedate<='"+lasttodate+"'";}
}
if(during==0){
	if(!fromdate.equals("")){
		if(whereclause.equals("")){whereclause+=" t1.createdate>='"+fromdate+"'";}
		else {whereclause+=" and t1.createdate>='"+fromdate+"'";}
	}
	if(!todate.equals("")){
		if(whereclause.equals("")){whereclause+=" t1.createdate<='"+todate+"'";}
		else {whereclause+=" and t1.createdate<='"+todate+"'";}
	}
}
else{
	if(during==1){
		if(whereclause.equals(""))	whereclause+=" t1.createdate='"+today+"'";
		else  whereclause+=" and t1.createdate='"+today+"'";
	}
	if(during==2){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        /* 刘煜 2004－05－08 修改，原来or 之间没有括号，造成系统死机 */
		if(whereclause.equals(""))	
			whereclause+=" ((t1.createdate='"+today+"' and t1.createtime<='"+CurrentTime+"')"+
			 " or (t1.createdate='"+lastday+"' and t1.createtime>='"+CurrentTime+"')) ";
		else  
			whereclause+=" and ((t1.createdate='"+today+"' and t1.createtime<='"+CurrentTime+"')"+
			 " or (t1.createdate='"+lastday+"' and t1.createtime>='"+CurrentTime+"')) ";
	}
	if(during==3){
		int days=now.getTime().getDay();
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-days);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==4){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-7);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==5){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==6){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-30);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==7){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,0,1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==8){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-365);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
		
}

if( isoracle ) {
    if(subday1!=0){
        if(whereclause.equals(""))	
            whereclause+="  (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
        else
            whereclause+=" and (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
    }

    if(subday2!=0){
        if(whereclause.equals(""))	
            whereclause+="  (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
        else
            whereclause+=" and (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
    }

    if(maxday!=0){
        if(whereclause.equals(""))	
            whereclause+="  (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))="+maxday;
        else
            whereclause+=" and (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))="+maxday;
    }
}else if( isdb2 ) {
    if(subday1!=0){
        if(whereclause.equals(""))	
            whereclause+="  (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
        else
            whereclause+=" and (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
    }

    if(subday2!=0){
        if(whereclause.equals(""))	
            whereclause+="  (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
        else
            whereclause+=" and (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
    }

    if(maxday!=0){
        if(whereclause.equals(""))	
            whereclause+="  (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))="+maxday;
        else
            whereclause+=" and (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))="+maxday;
    }
}
else {
    if(subday1!=0){
        if(whereclause.equals(""))	
            whereclause+="  (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))>"+subday1;
        else
            whereclause+=" and (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))>"+subday1;
    }

    if(subday2!=0){
        if(whereclause.equals(""))	
            whereclause+="  (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))<="+subday2;
        else
            whereclause+=" and (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))<="+subday2;
    }

    if(maxday!=0){
        if(whereclause.equals(""))	
            whereclause+=" (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))="+maxday;
        else
            whereclause+=" and (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))="+maxday;
    }
}

if(state==1){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype='3'";}
	else {whereclause+=" and t1.currentnodetype='3'";}
}
if(state==2){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype<>'3'";}
	else {whereclause+=" and t1.currentnodetype<>'3'";}
}

if(isdeleted!=2){
	if(whereclause.equals(""))	{
        if(isdeleted == 0) whereclause+=" (t1.deleted = 0 or t1.deleted is null ) ";
        else whereclause += " t1.deleted = "+isdeleted;
    }
	else {
        if(isdeleted == 0) whereclause+=" and (t1.deleted = 0 or t1.deleted is null ) ";
        else whereclause+=" and t1.deleted="+isdeleted;
    }
}

if(!requestlevel.equals("")){
	if(whereclause.equals(""))	whereclause+=" t1.requestlevel="+requestlevel;
	else	whereclause+=" and t1.requestlevel="+requestlevel;
}
if(!userids.equals("")){
	//if(whereclause.equals(""))	whereclause+=" t2.userid in("+userids+") and t2.usertype='0' and isremark in('0','1','5','8','9','7') ";
	//else	whereclause+=" and t2.userid in("+userids+") and t2.usertype='0' and isremark in('0','1','5','8','9','7') ";

    //yl qc:62946
    if(whereclause.equals(""))	whereclause+=" t2.requestid in(select distinct t3.requestid from workflow_currentoperator t3 where t3.userid in("+userids+") and t3.usertype='0' and t3.isremark in('0','1','5','8','9','7')) ";
    else	whereclause+=" and t2.requestid in(select distinct t3.requestid from workflow_currentoperator t3 where t3.userid in("+userids+") and t3.usertype='0' and t3.isremark in('0','1','5','8','9','7')) ";


}
if(!receivefromdate.equals("")){
	if(whereclause.equals(""))	whereclause+=" t2.receivedate>='"+receivefromdate+"' ";
	else	whereclause+=" and t2.receivedate>='"+receivefromdate+"' ";
}
if(!receivetodate.equals("")){
	if(whereclause.equals(""))	whereclause+=" t2.receivedate<='"+receivetodate+"' ";
	else	whereclause+=" and t2.receivedate<='"+receivetodate+"' ";
}

if(whereclause.equals("")) whereclause+="  islasttimes=1 ";
else whereclause+=" and islasttimes=1 ";

whereclause+=sqlwhere;//加上自定义条件

orderclause="t2.receivedate ,t2.receivetime";
orderclause2="t2.receivedate ,t2.receivetime";

SearchClause.setOrderClause(orderclause);
SearchClause.setOrderClause2(orderclause2);
SearchClause.setWhereClause(whereclause);

SearchClause.setWorkflowId(workflowid);
SearchClause.setNodeType(nodetype);
SearchClause.setFromDate(fromdate);
SearchClause.setToDate(todate);
SearchClause.setCreaterType(creatertype);
SearchClause.setCreaterId(createrid);
SearchClause.setRequestLevel(requestlevel);
SearchClause.setFromDate2(receivefromdate);
SearchClause.setToDate2(receivetodate);
response.sendRedirect("WFCustomSearchResult.jsp?query=1&moudle="+moudle+"&workflowid="+workflowidtemp+"&pagenum=1&iswaitdo="+iswaitdo+"&docids="+docids+"&tablename="+tablename+"&issimple="+issimple+"&customid="+customid+"&searchtype="+searchtype);


%>