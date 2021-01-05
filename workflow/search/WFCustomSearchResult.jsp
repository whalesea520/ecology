
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><!--added by xwj for td2023 on 2005-05-20-->
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";

String moudle=Util.null2String(request.getParameter("moudle"));
String workflowid = "" ;
String nodetype ="" ;
String fromdate ="" ;
String todate ="" ;
String creatertype ="" ;
String createrid ="" ;
String requestlevel ="" ;
String fromdate2 ="" ;
String todate2 ="" ;
String workcode ="" ;
String tempworkflowids="";
String querys=Util.null2String(request.getParameter("query"));
String fromself =Util.null2String(request.getParameter("fromself"));
String fromselfSql =Util.null2String(request.getParameter("fromselfSql"));
String isfirst =Util.null2String(request.getParameter("isfirst"));
String docids=Util.null2String(request.getParameter("docids"));
String issimple=Util.null2String(request.getParameter("issimple"));
String searchtype=Util.null2String(request.getParameter("searchtype"));
String customid=Util.null2String(request.getParameter("customid"));
String branchid="";
String tablename=Util.null2String(request.getParameter("tablename"));
workflowid = Util.null2String(request.getParameter("workflowid"));
WFManager.setWfid(Util.getIntValue(workflowid,0));
WFManager.getWfInfo();
String multiSubmit=WFManager.getMultiSubmit();
try{
branchid=Util.null2String((String)session.getAttribute("branchid")); 
}
catch (Exception e)
{
branchid="";
}
String isbill="0";
String formID="0";
if(!customid.equals("")){
    RecordSet.execute("select * from workflow_custom where id="+customid);
    if(RecordSet.next()){
        isbill=Util.null2String(RecordSet.getString("isbill"));
        formID=Util.null2String(RecordSet.getString("formid"));
        tempworkflowids=Util.null2String(RecordSet.getString("workflowids"));
        String customname=Util.null2String(RecordSet.getString("customname"));
        titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(20773,user.getLanguage())+"-"+customname;
    }
    if(!workflowid.equals("")){
        tempworkflowids=workflowid;
    }
    if(tempworkflowids.trim().equals("")){
        RecordSet.executeSql("select id from workflow_base where (isvalid='1' or isvalid='3') and formid="+formID+" and isbill='"+isbill+"'");
        while(RecordSet.next()){
            if(tempworkflowids.trim().equals("")){
                tempworkflowids=RecordSet.getString("id");
            }else{
                tempworkflowids+=","+RecordSet.getString("id");
            }
        }
    }
}else{
    isbill=WorkflowComInfo.getIsBill(workflowid);
    formID=WorkflowComInfo.getFormId(workflowid);
    tempworkflowids=workflowid;
}
String workflowname="";
ArrayList tworkflowids=Util.TokenizerString(workflowid,",");
for(int i=0;i<tworkflowids.size();i++){
    if(workflowname.equals("")){
        workflowname=WorkflowComInfo.getWorkflowname((String)tworkflowids.get(i));
    }else{
        workflowname+="，"+WorkflowComInfo.getWorkflowname((String)tworkflowids.get(i));
    }
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//add by xhheng @20050414 for TD 1545
int iswaitdo= Util.getIntValue(request.getParameter("iswaitdo"),0) ;
int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
String isthisWeek = Util.null2String(request.getParameter("isthisWeek"));
String isthisMonth = Util.null2String(request.getParameter("isthisMonth"));
String isthisDep = Util.null2String(request.getParameter("isthisDep"));
String isSelf = Util.null2String(request.getParameter("isSelf"));    
if(fromself.equals("1")) {
  SearchClause.resetClause(); //added by xwj for td2045 on2005-05-26 
	workflowid = Util.null2String(request.getParameter("workflowid"));
	nodetype = Util.null2String(request.getParameter("nodetype"));
	fromdate = Util.null2String(request.getParameter("fromdate"));
	todate = Util.null2String(request.getParameter("todate"));
	creatertype = Util.null2String(request.getParameter("creatertype"));
	createrid = Util.null2String(request.getParameter("createrid"));
	requestlevel = Util.null2String(request.getParameter("requestlevel"));
	fromdate2 = Util.null2String(request.getParameter("fromdate2"));
	todate2 = Util.null2String(request.getParameter("todate2"));
    workcode = Util.null2String(request.getParameter("workcode"));
}
else {

	//workflowid = SearchClause.getWorkflowId();
	nodetype = SearchClause.getNodeType();
	fromdate = SearchClause.getFromDate();
	todate = SearchClause.getToDate();
	creatertype = SearchClause.getCreaterType();
	
	createrid = SearchClause.getCreaterId();	//2012-09-03 ypc 修改
	//2012-08-28 ypc 修改 把createrid初始化的时候赋空

	//createrid="";
	requestlevel = SearchClause.getRequestLevel();
    fromdate2 = SearchClause.getFromDate2();
	todate2 = SearchClause.getToDate2();
}


String newsql="";

if(fromself.equals("1")) {
	if(!workflowid.equals("")){
	newsql+=" and t1.workflowid in("+WorkflowVersion.getAllVersionStringByWFIDs(workflowid)+")" ;
    }else if(!customid.equals("")){
        newsql+=" and t1.workflowid in("+WorkflowVersion.getAllVersionStringByWFIDs(tempworkflowids)+")"; 
    }

	if(!nodetype.equals(""))
		newsql += " and t1.currentnodetype='"+nodetype+"'";


	if(!fromdate.equals(""))
		newsql += " and t1.createdate>='"+fromdate+"'";

	if(!todate.equals(""))
		newsql += " and t1.createdate<='"+todate+"'";

	if(!fromdate2.equals(""))
		newsql += " and t2.receivedate>='"+fromdate2+"'";

	if(!todate2.equals(""))
		newsql += " and t2.receivedate<='"+todate2+"'";

    if(!workcode.equals(""))
		newsql += " and t1.creatertype= '0' and t1.creater in(select id from hrmresource where workcode like '%"+workcode+"%')";
    
    if(!createrid.equals("")){
		newsql += " and t1.creater='"+createrid+"'";
		newsql += " and t1.creatertype= '"+creatertype+"' ";
	}

	if(!requestlevel.equals("")){
		newsql += " and t1.requestlevel="+requestlevel;
  }
//  if (!fromselfSql.equals(""))
//  newsql += " and " + fromselfSql;
if(!querys.equals("1")) {
  if (!fromselfSql.equals(""))
   newsql += " and " + fromselfSql;
}
else
{
if (fromself.equals("1"))
newsql += " and  islasttimes=1 ";
}
}

String CurrentUser = Util.null2String((String)session.getAttribute("RequestViewResource")) ;

String userID = String.valueOf(user.getUID());
String logintype = ""+user.getLogintype();
int usertype = 0;

if(CurrentUser.equals("")) {
	CurrentUser = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}
boolean superior = false;  //是否为被查看者上级或者本身

if(userID.equals(CurrentUser))
{
	superior = true;
}
else
{
	RecordSet.executeSql("SELECT * FROM HrmResource WHERE ID = " + CurrentUser + " AND (managerStr LIKE '%," + userID + ",%' OR managerStr LIKE '" + userID + ",%')");
	
	if(RecordSet.next())
	{
		superior = true;	
	}
}
Calendar now = Calendar.getInstance();
	String today=Util.add0(now.get(Calendar.YEAR), 4) +"-"+Util.add0(now.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(now.get(Calendar.DAY_OF_MONTH), 2) ;
	int year=now.get(Calendar.YEAR);
	int month=now.get(Calendar.MONTH);
	int day=now.get(Calendar.DAY_OF_MONTH);
    if("1".equals(isthisWeek)){
		int days=now.getTime().getDay();
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-days);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		newsql +=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if("1".equals(isthisMonth)){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		newsql +=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if("1".equals(isthisDep)){
		int departmentid = Util.getIntValue(ResourceComInfo.getDepartmentID(CurrentUser), 0);
		newsql += " and t1.creater in (select id from hrmresource where departmentid="+departmentid+" )";
	}
	if("1".equals(isSelf)){
		newsql += " and t1.creater="+CurrentUser+" ";
	}

    //属于人力资源条件也显示该流程。

    String sqlwhere1="";
    if(isbill.equals("1")){
        RecordSet.executeSql("select distinct a.workflowid,b.fieldname from workflow_createdoc a,workflow_billfield b where (b.viewtype is null or b.viewtype !='1') and a.flowdocfield=b.id and a.status='1' and a.workflowid in("+WorkflowVersion.getAllVersionStringByWFIDs(tempworkflowids)+") order by b.fieldname");
    }else{
        RecordSet.executeSql("select distinct c.workflowid,b.fieldname from workflow_createdoc c,workflow_formfield a ,workflow_formdict b where a.fieldid=b.id and (a.isdetail is null or a.isdetail !='1') and c.flowdocfield=a.fieldid and c.status='1' and c.workflowid in("+WorkflowVersion.getAllVersionStringByWFIDs(tempworkflowids)+") order by b.fieldname");
    }
    ArrayList wfids=new ArrayList();
    ArrayList zhenwens=new ArrayList();
    String tempzhenwen="";
    String tempwfids="";
    String zhenwen="";
    while(RecordSet.next()){
        String tmpworkflowid=RecordSet.getString("workflowid");
        zhenwen=Util.null2String(RecordSet.getString("fieldname"));
        if(!tempzhenwen.equals("")&&!tempzhenwen.equals(zhenwen)){
            wfids.add(tempwfids);
            zhenwens.add(zhenwen);
            tempwfids=tmpworkflowid;
        }else{
            if(tempwfids.equals("")){
                tempwfids=tmpworkflowid;
            }else{
                tempwfids+=","+tmpworkflowid;
            }
        }
        tempzhenwen=zhenwen;
    }
    if(!zhenwen.equals("")){
        wfids.add(tempwfids);
        zhenwens.add(zhenwen);
    }
    for(int i=0;i<wfids.size();i++){
        sqlwhere1+=" or ( d."+zhenwens.get(i)+" is not null and t1.workflowid in("+WorkflowVersion.getAllVersionStringByWFIDs(wfids.get(i) + "")+") and not exists(select 1 from workflow_currentoperator where userid="+
                CurrentUser+" and usertype='"+usertype+"' and requestid=t1.requestid) and exists(select 1 from DocShare where docid=d."+zhenwens.get(i)+
                " and ((sharetype=1 and userid="+CurrentUser+") or (sharetype=2 and subcompanyid="+ResourceComInfo.getSubCompanyID(CurrentUser)+" and seclevel<="+ResourceComInfo.getSeclevel(CurrentUser)+") " +
                "or(sharetype=3 and departmentid="+ResourceComInfo.getDepartmentID(CurrentUser)+" and seclevel<="+ResourceComInfo.getSeclevel(CurrentUser)+") " +
                "or(sharetype=4 and exists(select 1 from HrmRoleMembers h where h.resourceid="+CurrentUser+" and h.rolelevel>=DocShare.rolelevel and h.roleid=DocShare.roleid) and seclevel<="+ResourceComInfo.getSeclevel(CurrentUser)+") " +
                "or(sharetype=5 and seclevel<="+ResourceComInfo.getSeclevel(CurrentUser)+")) )) ";
    }

String sqlwhere="";
if(isovertime==1){
    sqlwhere="where t1.requestid = t2.requestid and (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') ";
    int perpage=10;
    RecordSet.executeProc("workflow_RUserDefault_Select",""+user.getUID());
    if(RecordSet.next()){
       perpage= RecordSet.getInt("numperpage");
    }
    if(perpage <2) perpage=10;
    String requestids="0";
    RecordSet.executeSql("select requestids from SysPoppupRemindInfo where type=10 and userid = "+user.getUID());
    if(RecordSet.next()){
        requestids=RecordSet.getString("requestids");
    }
    if(requestids.length()>1){
        requestids=requestids.substring(0,requestids.length()-1);
      	sqlwhere +=" and t2.id in (Select top "+perpage+" max(id) from workflow_currentoperator where requestid in ( "+requestids+") group by requestid order by requestid)";
    }

}
else{
    sqlwhere="where t1.requestid = t2.requestid and t1.requestid =d.requestid and (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') ";
    if(!sqlwhere1.equals("")){
        sqlwhere+=" and ((t2.userid = "+CurrentUser+" and t2.usertype=" + usertype+")"+sqlwhere1+")";
    }else{
        sqlwhere+=" and  t2.userid = "+CurrentUser+" and t2.usertype=" + usertype;
    }
    if(!Util.null2String(SearchClause.getWhereClause()).equals("")){
        sqlwhere += " and "+SearchClause.getWhereClause();
		//out.print("sql***********"+SearchClause.getWhereClause());
    }
}
String orderby = "";
//String orderby2 = "";

//out.print(sqlwhere);

sqlwhere +=" "+newsql ;

//orderby=" t1.createdate,t1.createtime,t1.requestlevel";
orderby=SearchClause.getOrderClause();
if(orderby.equals("")){
    orderby="t2.receivedate ,t2.receivetime";
}
//orderby2=" order by t1.createdate,t1.createtime,t1.requestlevel";

//String tablename = "wrktablename"+ Util.getRandom() ;

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);

int perpage=10;
boolean hascreatetime =true;
boolean hascreater =true;
boolean hasworkflowname =true;
boolean hasrequestlevel =true;
boolean hasrequestname =true;
boolean hasreceivetime =true;
boolean hasstatus =true;
boolean hasreceivedpersons =true;
boolean hascurrentnode =true;
RecordSet.executeProc("workflow_RUserDefault_Select",""+user.getUID());
if(RecordSet.next()){
    if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
    if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
    if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
    if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
    if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
    if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
    if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
    if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
    if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
    perpage= RecordSet.getInt("numperpage");
}else{
    RecordSet.executeProc("workflow_RUserDefault_Select","1");
    if(RecordSet.next()){
        if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
        if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
        if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
        if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
        if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
        if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
        if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
        if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
        if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
        perpage= RecordSet.getInt("numperpage");
    }
}


//update by fanggsh 20060711 for TD4532 begin
boolean hasSubWorkflow =false;

if(workflowid!=null&&!workflowid.equals("")&&workflowid.indexOf(",")==-1){
	RecordSet.executeSql("select id from Workflow_SubWfSet where mainWorkflowId="+workflowid);
	if(RecordSet.next()){
		hasSubWorkflow=true;
	}
}

//update by fanggsh 20060711 for TD4532 end


//RecordSet.executeSql(sqltemp);
//RecordSet.executeSql("drop table "+tablename);



RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",WFCustomSearch.jsp?iswaitdo="+iswaitdo+",_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",WFCustomSearchBySimple.jsp?isresearch=1&workflowid="+workflowid+"&customid="+customid+"&issimple="+issimple+"&searchtype="+searchtype+"&moudle="+moudle+"&iswaitdo="+iswaitdo+",_self}" ;
RCMenuHeight += RCMenuHeightStep ;
if("1".equals(multiSubmit)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(17598,user.getLanguage())+",javascript:OnMultiSubmit(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<FORM id=weaver name=frmmain method=post <%if (!workflowid.equals("")||(!customid.equals(""))) {%>action="WFCustomSearchResult.jsp" <%} else {%>action="WFSearchResult.jsp"<%}%>>
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<input type=hidden name=tablename value="<%=tablename%>">
<input type=hidden name=fromself value="<%=fromself%>">
<input type=hidden name=isfirst value="<%=isfirst%>">
<input type=hidden name=fromselfSql value="<%if(!"1".equals(isfirst)){%><%=SearchClause.getWhereClause()%><%}else{%><%=fromselfSql%><%}%>">
<input name=iswaitdo type=hidden value="<%=iswaitdo%>">
<input type=hidden name=docids value="<%=docids%>">
<input name=query type=hidden value="<%=querys%>">
<input type=hidden name=isovertime value="<%=isovertime%>">
<input name=issimple type=hidden value="<%=issimple%>">
<input name=searchtype type=hidden value="<%=searchtype%>">
<input name=isthisWeek type=hidden value="<%=isthisWeek%>">
<input name=isthisMonth type=hidden value="<%=isthisMonth%>">
<input name=isthisDep type=hidden value="<%=isthisDep%>">
<input name=isSelf type=hidden value="<%=isSelf%>">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">

		<TABLE class=Shadow id="tables" >
		<tr>
		<td valign="top">
<table class="viewform" >
  <tbody>
<TR class="Title" height="20">
    <th><%=SystemEnv.getHtmlLabelName(21832,user.getLanguage())%></th>
    <th class=field align=center><span id="spanisthisWeek" name="spanisthisWeek" style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(isthisWeek)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="javascript:submitDataisthisWeek();">[<%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())+SystemEnv.getHtmlLabelName(125,user.getLanguage())%>]</span></th>
    <th class=field align=center><span id="spanisthisMonth" name="spanisthisMonth" style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(isthisMonth)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="javascript:submitDataisthisMonth();">[<%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())+SystemEnv.getHtmlLabelName(125,user.getLanguage())%>]</span></th>
    <th class=field align=center><span id="spanisthisDep" name="spanisthisDep" style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(isthisDep)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="javascript:submitDataisthisDep();">[<%=SystemEnv.getHtmlLabelName(21837,user.getLanguage())+SystemEnv.getHtmlLabelName(125,user.getLanguage())%>]</span></th>
    <th class=field align=center><span id="spanisSelf" name="spanisSelf" style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(isSelf)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="javascript:submitDataisSelf();">[<%=SystemEnv.getHtmlLabelName(15763,user.getLanguage())+SystemEnv.getHtmlLabelName(125,user.getLanguage())%>]</span></th>
</TR>
  <TR style="height:1px;" class=Separartor><TD class="Line1" COLSPAN=5></TD></TR>
</tbody>
</table>
<table class="viewform">
  <colgroup>
  <col width="10%">
  <col width="20%">
  <col width="5">
  <col width="10%">
  <col width="20%">
  <col width="5%">
  <col width="10%">
  <col width="20">
  <tbody>
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></td>
    <td class=field>
     <%if (!moudle.equals("1")) {%><button type=button  class=browser <%if(customid.equals("")){%>onClick="onShowWorkFlowSerach('workflowid','workflowspan')" <%}else{%>onclick="onShowFormWorkFlow('workflowid','workflowspan')"<%}%>></button><%}%>
	<span id=workflowspan>
	<%=workflowname%>
	</span>
	<input name=workflowid type=hidden value="<%=workflowid%>">
    <input name=customid type=hidden value="<%=customid%>">
    </td>

    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></td>
    <td class=field>
     <select class=inputstyle  size=1 name=nodetype style=width:150>
     <option value="">&nbsp;</option>
     <option value="0" <% if(nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
     	<option value="1" <% if(nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
     	<option value="2" <% if(nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
     	<option value="3" <% if(nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
     </select>
    </td>
    <td>&nbsp;</td>
    <td ><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></td>
	<td class=field>
	<select class=inputstyle  name=requestlevel style=width:140 size=1>
	  <option value=""> </option>
	  <option value="0" <% if(requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
	  <option value="1" <% if(requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
	  <option value="2" <% if(requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
	</select>
	</td>
  </tr>
  <TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>
 <tr>

    <td><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
    <td class=field><button type=button  class=calendar id=SelectDate  onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>
      <SPAN id=fromdatespan ><%=fromdate%></SPAN>
      -&nbsp;&nbsp;<button type=button  class=calendar id=SelectDate2 onclick="gettheDate(todate,todatespan)"></BUTTON>
      <SPAN id=todatespan ><%=todate%></SPAN>
	  <input type="hidden" name="fromdate" value="<%=fromdate%>"><input type="hidden" name="todate" value="<%=todate%>">
    </td>
      <td>&nbsp;</td>
      <td ><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
	  <td class=field>
	  <select class=inputstyle  name=creatertype>
<%if(!user.getLogintype().equals("2")){%>
	  <option value="0"<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
<%}%>
	  <option value="1"<% if(creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
	  </select>
	  &nbsp
	  <button type=button  class=browser onClick="onShowResource()"></button>
	<!-- 不要此出的条件判断直接取值 2012-08-28 ypc 修改 初始化为空 所以 浏览按钮初始化的时候就应该是空的-->
	  <span id=resourcespan>
	  <% if(creatertype.equals("1")){%><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid),user.getLanguage())%><%}else{%><%=ResourceComInfo.getResourcename(createrid)%><%}%></span>
    </span>
	<input name=createrid type=hidden value="<%=createrid%>"></td>
	<td>&nbsp;</td>

    <td><%=SystemEnv.getHtmlLabelName(17994,user.getLanguage())%></td>
    <td class=field><button type=button  class=calendar id=SelectDate3  onclick="gettheDate(fromdate2,fromdatespan2)"></BUTTON>
      <SPAN id=fromdatespan2 ><%=fromdate2%></SPAN>
      -&nbsp;&nbsp;<button type=button  class=calendar id=SelectDate4 onclick="gettheDate(todate2,todatespan2)"></BUTTON>
      <SPAN id=todatespan2 ><%=todate2%></SPAN>
	  <input type="hidden" name="fromdate2" value="<%=fromdate2%>"><input type="hidden" name="todate2" value="<%=todate2%>">
    </td>
  </tr> <TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>
  <tr>

    <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
    <td class=field>
	  <input type="text" name="workcode" value="<%=workcode%>">
    </td>

      <td>&nbsp;</td>
      <td ></td>
	  <td >
	  </td>
	<td>&nbsp;</td>

    <td></td>
    <td>
    </td>
  </tr> <TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>
  </tbody>
</table>

<input name=start type=hidden value="<%=start%>">
</form>



<!--   added by xwj for td2023 on 2005-05-20  begin  -->
<FORM id=weaver1 name=frmmain1 method=post action="/workflow/request/RequestListOperation.jsp">
<input type=hidden name=multiSubIds value="">
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_SEARCH_WFCUSTOMSEARCHRESULT%>"/>
</form>

 <TABLE id="tb1" width="100%">
 
                 
                   
                    <tr>
                     
                      <td valign="top">                                                                                    
                          <%
                           String tableString = "";
                          
                            if(perpage <2) perpage=10;                                 

                            String backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status as t1_status,t1.requestlevel,t1.currentnodeid,t2.viewtype,t2.receivedate,t2.receivetime,t2.isremark ";
							//加上自定以字段


							String sqls="";
							String showfield="";
                            if(customid.equals("")){
							if(isbill.equals("0")){
							sqls = "select Workflow_CustomDspField.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fielddbtype as dbtype, workflow_formdict.fieldhtmltype as httype,workflow_formdict.type as type,min(Workflow_CustomDspField.showorder) as showorder" +
                                    " from Workflow_CustomDspField,Workflow_Custom, workflow_formdict,workflow_fieldlable where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+
                                    " and Workflow_Custom.isbill='0'  and Workflow_CustomDspField.ifshow='1' and workflow_fieldlable.formid = Workflow_Custom.formid and workflow_fieldlable.isdefault = 1" +
                                    " and workflow_fieldlable.fieldid =Workflow_CustomDspField.fieldid and workflow_formdict.id = Workflow_CustomDspField.fieldid " +
                                    " group by Workflow_CustomDspField.fieldid,fieldname,workflow_fieldlable.fieldlable,workflow_formdict.fielddbtype, workflow_formdict.fieldhtmltype,workflow_formdict.type" +
                                    " union select Workflow_CustomDspField.fieldid as id,'1' as name,'2' as label,'3' as dbtype, '4' as httype,5 as type ,min(Workflow_CustomDspField.showorder) as showorder" +
                                    " from Workflow_CustomDspField ,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+
                                    " and Workflow_Custom.isbill='0'  and Workflow_CustomDspField.ifshow='1'  and Workflow_CustomDspField.fieldid<0" +
                                    " group by Workflow_CustomDspField.fieldid order by showorder ";

							}else if(isbill.equals("1")){
								sqls = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type,min(Workflow_CustomDspField.showorder) as showorder" +
                                        " from workflow_billfield,Workflow_CustomDspField,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+
                                        " and Workflow_Custom.isbill='1'  and Workflow_CustomDspField.ifshow='1' and workflow_billfield.billid="+formID+"  and   workflow_billfield.id=Workflow_CustomDspField.fieldid" +
                                        " group by workflow_billfield.id,workflow_billfield.fieldname,workflow_billfield.fieldlabel,workflow_billfield.fielddbtype, workflow_billfield.fieldhtmltype,workflow_billfield.type" +
                                        " union select Workflow_CustomDspField.fieldid as id,'1' as name,2 as label,'3' as dbtype, '4' as httype,5 as type ,min(Workflow_CustomDspField.showorder) as showorder" +
                                        " from Workflow_CustomDspField ,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+
                                        " and Workflow_Custom.isbill='1'  and Workflow_CustomDspField.ifshow='1'  and Workflow_CustomDspField.fieldid<0" +
                                        " group by Workflow_CustomDspField.fieldid order by showorder";
							}
                            }else{
                            if(isbill.equals("0")){
							sqls = "select Workflow_CustomDspField.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fielddbtype as dbtype, workflow_formdict.fieldhtmltype as httype,workflow_formdict.type as type,Workflow_CustomDspField.showorder" +
                                    " from Workflow_CustomDspField,Workflow_Custom, workflow_formdict,workflow_fieldlable where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.id="+customid+
                                    " and Workflow_Custom.isbill='0'  and Workflow_CustomDspField.ifshow='1' and workflow_fieldlable.formid = Workflow_Custom.formid and workflow_fieldlable.isdefault = 1" +
                                    " and workflow_fieldlable.fieldid =Workflow_CustomDspField.fieldid and workflow_formdict.id = Workflow_CustomDspField.fieldid " +
                                    " union select Workflow_CustomDspField.fieldid as id,'1' as name,'2' as label,'3' as dbtype, '4' as httype,5 as type ,Workflow_CustomDspField.showorder" +
                                    " from Workflow_CustomDspField ,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.id="+customid+
                                    " and Workflow_Custom.isbill='0'  and Workflow_CustomDspField.ifshow='1'  and Workflow_CustomDspField.fieldid<0" +
                                    " order by showorder ";

							}else if(isbill.equals("1")){
								sqls = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type,Workflow_CustomDspField.showorder" +
                                        " from workflow_billfield,Workflow_CustomDspField,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.id="+customid+
                                        " and Workflow_Custom.isbill='1'  and Workflow_CustomDspField.ifshow='1' and workflow_billfield.billid=Workflow_Custom.formid  and   workflow_billfield.id=Workflow_CustomDspField.fieldid" +
                                        " union select Workflow_CustomDspField.fieldid as id,'1' as name,2 as label,'3' as dbtype, '4' as httype,5 as type ,Workflow_CustomDspField.showorder" +
                                        " from Workflow_CustomDspField ,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.id="+customid+
                                        " and Workflow_Custom.isbill='1'  and Workflow_CustomDspField.ifshow='1'  and Workflow_CustomDspField.fieldid<0" +
                                        " order by showorder";
							}
                            }
                            //out.print(sqls);
							RecordSet.execute(sqls);
                            while (RecordSet.next())
							{
							if (RecordSet.getInt(1)>0){
                                String tempname=Util.null2String(RecordSet.getString("name"));
                                String dbtype=Util.null2String(RecordSet.getString("dbtype"));
                                if(dbtype.toLowerCase().equals("text")){
                                    if(RecordSet.getDBType().equals("oracle")){
                                        showfield=showfield+","+"to_char(d."+tempname+") as "+tempname;
                                    }else{
                                        showfield=showfield+","+"convert(varchar(4000),d."+tempname+") as "+tempname;
                                    }
                                }else{
                                    showfield=showfield+","+"d."+tempname;
                                }
                            }
							
							}
							RecordSet.beforFirst();
							backfields=backfields+showfield;
                            String fromSql  = " from workflow_requestbase t1,workflow_currentoperator t2 ,"+tablename+" d ";
                            //sqlwhere+=" and t2.id in(select max(t2.id) "+fromSql+" "+sqlwhere+" group by t1.requestid)";
                            String sqlWhere = sqlwhere;
                            if(RecordSet.getDBType().equals("oracle"))
                            {
                            	sqlWhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
                            }
                            else
                            {
                            	sqlWhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
                            }
                            String para2="column:requestid+column:workflowid+column:viewtype+"+isovertime+"+"+user.getLanguage();
							String para4=user.getLanguage()+"+"+user.getUID();
                            if(!docids.equals("")){
                                fromSql  = fromSql+",workflow_form t4 ";
                                sqlWhere = sqlWhere+" and t1.requestid=t4.requestid ";
                            }
                            
                            
                            if(!superior)
                        	{
                            	sqlWhere += " AND EXISTS (SELECT 1 FROM workFlow_CurrentOperator workFlowCurrentOperator WHERE t2.workflowid = workFlowCurrentOperator.workflowid AND t2.requestid = workFlowCurrentOperator.requestid AND workFlowCurrentOperator.userid=" + userID + " and workFlowCurrentOperator.usertype = " + usertype +") ";
                        	}
                            
                           if (!branchid.equals(""))
						   {
						   sqlWhere += " AND t1.creater in (select id from hrmresource where subcompanyid1="+branchid+")  ";
						   }
                          //out.println("select "+backfields+fromSql+sqlWhere);

						String tabletype="1".equals(multiSubmit)?"checkbox":"none";//是否批量提交
						tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_SEARCH_WFCUSTOMSEARCHRESULT,user.getUID())+"\" >"+
						" <checkboxpopedom    popedompara=\"column:requestid+"+user.getUID()+"\" showmethod=\"weaver.general.WorkFlowTransMethod.getOpUserResultCheckBox\" />"+                        
						"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\"  />"+
                                                 "			<head>";
						while (RecordSet.next()) {
                          if(RecordSet.getString("id").equals("-3")) 
                                    tableString+="				<col   text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                          else if(RecordSet.getString("id").equals("-4")) //-4
                                    tableString+="				<col  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
                         else if(RecordSet.getString("id").equals("-5")) //-5
                                    tableString+="				<col   text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
                         else if(RecordSet.getString("id").equals("-2")) //-2
                                    tableString+="				<col    text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""+user.getLanguage()+"\"/>";
                        else  if(RecordSet.getString("id").equals("-1")) //-1
                                    tableString+="				<col  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLink\"  otherpara=\""+para2+"\"/>";
                        else  if(RecordSet.getString("id").equals("-6")) //-6
                        			tableString+="				<col  text=\""+SystemEnv.getHtmlLabelName(18564,user.getLanguage())+"\" column=\"currentnodeid\" orderkey=\"t1.currentnodeid\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
                        else  if(RecordSet.getString("id").equals("-7")) //-7
                                    tableString+="			    <col  text=\""+SystemEnv.getHtmlLabelName(17994,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"t2.receivedate,t2.receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                       else   if(RecordSet.getString("id").equals("-8")) //-8
                                    tableString+="			    <col  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"t1_status\" orderkey=\"t1_status\" />";
                       else   if(RecordSet.getString("id").equals("-9")) //-9
                    	   			tableString+="			    <col   text=\""+SystemEnv.getHtmlLabelName(16354,user.getLanguage())+"\" column=\"requestid\" orderkey=\"t1.requestid\" otherpara=\""+para4+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
                          else
						  {String tempfield=RecordSet.getString("id");
						  
						   String name = RecordSet.getString("name");
						   String label = RecordSet.getString("label");
						   String htmltype = RecordSet.getString("httype");
						   String type = RecordSet.getString("type");
						   String id = RecordSet.getString("id");
                           String dbtype=RecordSet.getString("dbtype");
						   String para3="column:requestid+"+id+"+"+htmltype+"+"+type+"+"+user.getLanguage()+"+"+isbill+"+"+dbtype;
							if(isbill.equals("1"))
								label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());

							tableString+="			    <col  text=\""+label+"\"  column=\""+name+"\" orderkey=\""+name+"\"  otherpara=\""+para3+"\"  transmethod=\"weaver.general.WorkFlowTransMethod.getOthers\"/>";
						   }
						  }

						  if (RecordSet.getCounts()==0)
						  {
						  
						  
						  if(hascreatetime)
                                    tableString+="				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                          if(hascreater)
                                    tableString+="				<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
                          if(hasworkflowname)
                                    tableString+="				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
                          if(hasrequestlevel)
                                    tableString+="				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""+user.getLanguage()+"\"/>";
                          if(hasrequestname)
                                    tableString+="				<col width=\"19%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLink\"  otherpara=\""+para2+"\"/>";
                          if(hascurrentnode)
                        	  		tableString+="				<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18564,user.getLanguage())+"\" column=\"currentnodeid\" orderkey=\"t1.currentnodeid\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
                          if(hasreceivetime)
                                    tableString+="			    <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17994,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"t2.receivedate,t2.receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                          if(hasstatus)
                                    tableString+="			    <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"t1_status\" orderkey=\"t1_status\" />";
                          if(hasreceivedpersons)
                        	  		tableString+="			    <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(16354,user.getLanguage())+"\" column=\"requestid\" orderkey=\"t1.requestid\" otherpara=\""+para4+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
						  }
						  if(hasSubWorkflow) 
                                    tableString+="				<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(19363,user.getLanguage())+"\" column=\"requestid\" orderkey=\"t1.requestid\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_self\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFLink\"  otherpara=\""+user.getLanguage()+"\"/>";
									
									

                                    tableString+="			</head>"+   			
                                                 "</table>";
                         
						  
                     
                          %>
                         
                          <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
                      </td>
                    </tr>
                  </TABLE>


<!--   added by xwj for td2023 on 2005-05-20  end  -->
     
<table align=right>
   <tr>
   <td>
   <%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;

	// RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.toString(),_self}" ;
    //RCMenuHeight += RCMenuHeightStep ;
   %>
   </tr>

</TABLE>
	  
</td>
</tr>
</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<script>
//tables.width=1800;
//tb1.width=1800;
</script>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
<script type="text/javascript">


function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0);
			var names = wuiUtil.getJsonValueByIndex(id, 1);
			
			if (ids.indexOf(",") == 0) {
				ids = ids.substr(1);
				names = names.substr(1);
			}
			
			$G(inputname).value = ids;
			var sHtml = "";
			
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");
			
			for ( var i = 0; i < ridArray.length; i++) {

				var curid = ridArray[i];
				var curname = rNameArray[i];
				if (i != ridArray.length - 1) sHtml += curname + "，"; 
				else sHtml += curname;
			}
			
			$G(spanname).innerHTML = sHtml;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}

function onShowFormWorkFlow(inputname, spanname) {
	var tmpids = $G(inputname).value;
	var url = uescape("?customid=<%=customid%>&value=<%=isbill%>_<%=formID%>_"
			+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
			+ url;

	disModalDialogRtnM(url, inputname, spanname);
}


function onShowWorkFlowSerach(inputname, spanname) {

	retValue = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp");
	temp = $G(inputname).value;
	if(retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0") {
			$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}


function onShowResource() {
	var url = "";
	var tmpval = $G("creatertype").value;
	
	if (tmpval == "0") {
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	} else {
		url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	}
	disModalDialog(url, $G("resourcespan"), $G("createrid"), false);
}

</script>

<SCRIPT language="javascript">

function OnChangePage(start){
        document.frmmain.start.value = start;
		document.frmmain.submit();
}

function OnSearch(){
        onClearSwift();
        document.frmmain.fromself.value="1";
        document.frmmain.isfirst.value="1";
		if (document.frmmain.workflowid.value==""&&document.frmmain.customid.value=="")  document.frmmain.action="WFSearchResult.jsp";
		document.frmmain.submit();
}

function OnMultiSubmit(){

    document.frmmain1.multiSubIds.value = _xtable_CheckedCheckboxId();
    //alert (document.frmmain1.multiSubIds.value);
    if(document.frmmain1.multiSubIds.value==""){
    	alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
    	return ;
    }
    document.frmmain1.submit();
}
function CheckAll(haschecked) {

    len = document.weaver1.elements.length;
    var i=0;
    for( i=0; i<len; i++) {
        if (document.weaver1.elements[i].name.substring(0,13)=='multi_submit_') {
            document.weaver1.elements[i].checked=(haschecked==true?true:false);
        }
    }


}


var showTableDiv  = document.getElementById('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("<div>");
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);
     var message_Div1  = document.getElementById("message_Div");
     message_Div1.style.display="inline";
     message_Div1.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_Div1.style.position="absolute"
     message_Div1.style.posTop=pTop;
     message_Div1.style.posLeft=pLeft;

     message_Div1.style.zIndex=1002;

     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_Div1.style.zIndex - 1;
     oIframe.style.width = parseInt(message_Div1.offsetWidth);
     oIframe.style.height = parseInt(message_Div1.offsetHeight);
     oIframe.style.display = 'block';
}
function displaydiv_1()
{
	if(WorkFlowDiv.style.display == ""){
		WorkFlowDiv.style.display = "none";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
	}
	else{
		WorkFlowDiv.style.display = "";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";

	}
}

function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showallreceived(requestid,returntdid){
	//2012-08-09 ypc 修改 屏蔽掉此函数的调用就可以OK啦 对其他功能目前没有发现有影响
    //showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
    var ajax=ajaxinit();
	
    ajax.open("POST", "WorkflowUnoperatorPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&returntdid="+returntdid);
    //获取执行状态

    //alert(ajax.readyState);
	//alert(ajax.status);
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里

        if (ajax.readyState==4&&ajax.status == 200) {
            try{
            document.all(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            showTableDiv.style.display='none';
            oIframe.style.display='none';
        } 
    } 
}
function submitDataisthisWeek(){
	onClearSwift();
	document.frmmain.isthisWeek.value="1";
	document.getElementById("spanisthisWeek").style.color = "#0000FF";
	document.frmmain.fromself.value="1";
    document.frmmain.isfirst.value = "1";
    document.frmmain.submit();
}
function submitDataisthisMonth(){
	onClearSwift();
	document.frmmain.isthisMonth.value="1";
	document.getElementById("spanisthisMonth").style.color = "#0000FF";
	document.frmmain.fromself.value="1";
    document.frmmain.isfirst.value = "1";
    document.frmmain.submit();
}
function submitDataisthisDep(){
	onClearSwift();
	document.frmmain.isthisDep.value="1";
	document.getElementById("spanisthisDep").style.color = "#0000FF";
	document.frmmain.fromself.value="1";
    document.frmmain.isfirst.value = "1";
    document.frmmain.submit();
}
function submitDataisSelf(){
	onClearSwift();
	document.frmmain.isSelf.value="1";
	document.getElementById("spanisSelf").style.color = "#0000FF";
	document.frmmain.fromself.value="1";
    document.frmmain.isfirst.value = "1";
    document.frmmain.submit();
}
function onClearSwift(){
	document.frmmain.isthisWeek.value="0";
	document.frmmain.isthisMonth.value="0";
	document.frmmain.isthisDep.value="0";
	document.frmmain.isSelf.value="0";
	document.getElementById("spanisthisWeek").style.color = "#6A9EE6";
	document.getElementById("spanisthisMonth").style.color = "#6A9EE6";
	document.getElementById("spanisthisDep").style.color = "#6A9EE6";
	document.getElementById("spanisSelf").style.color = "#6A9EE6";
}
function uescape(url){
    return escape(url);
}    
</script>
<script language=vbs src="/js/browser/WorkFlowBrowser.vbs"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
