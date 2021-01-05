<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="java.text.DecimalFormat"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<%@ page import="weaver.fna.budget.BudgetHandler"%>
<%@ page import="java.text.DecimalFormat" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="workPlanSearch" class="weaver.WorkPlan.WorkPlanSearch" scope="session" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RelatedRequestCount" class="weaver.workflow.request.RelatedRequestCount" scope="page"/>
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="PrjTimeAndWorkdayUtil" class="weaver.proj.util.PrjTimeAndWorkdayUtil" scope="page" />
<%
String nameQuery=Util.null2String(request.getParameter("flowTitle"));

%>
<%

DecimalFormat df=new DecimalFormat("##0.00");
String ProjID = Util.null2String(request.getParameter("ProjID"));
String message = Util.null2String(request.getParameter("message"))  ;
/*查看项目成员*/
String sql_mem="select status,members,contractids,accessory from Prj_ProjectInfo where id= "+ProjID ;
RecordSet.executeSql(sql_mem);
RecordSet.next();
String Members=Util.null2String(RecordSet.getString("members"));
String project_accessory = Util.null2String(RecordSet.getString("accessory"));//相关附件
String status_prj=Util.null2String(RecordSet.getString("status"));
String Memname="";
int projidss=1;//为区别项目报表和项目卡片的返回，项目卡片为1

ArrayList Members_proj = Util.TokenizerString(Members,",");
int Membernum = Members_proj.size();

for(int i=0;i<Membernum;i++){
    Memname= Memname+"<a href=\"/hrm/resource/HrmResource.jsp?id="+Members_proj.get(i)+"\">"+Util.toScreen(ResourceComInfo.getResourcename(""+Members_proj.get(i)),user.getLanguage())+"</a>";
    Memname+=" ";
}


/*合同－－项目收入*/
String contractids_prj="";
String sql_conids="select id from CRM_Contract where projid ="+ProjID;
RecordSet.executeSql(sql_conids);
while(RecordSet.next()){
    contractids_prj += ","+ Util.null2String(RecordSet.getString("id"));
}
if(!contractids_prj.equals("")) contractids_prj =contractids_prj.substring(1);



/*项目支出*/
//判断有关项目的费用是否为支出
String projfee = ""; //总支出
String sql_feeid="select * from FnaAccountLog where projectid = "+ProjID;
RecordSet.executeSql(sql_feeid);
String feeids="";
while(RecordSet.next()){
    String prjfeeid = Util.null2String(RecordSet.getString("feetypeid"));
    String sql_check="select feetype from FnaBudgetfeeType where id ="+prjfeeid ;//是否为支出
    rs.executeSql(sql_check);
    rs.next();
    int feetypeid = rs.getInt(1);
    if(feetypeid==1){
        feeids += "," + Util.null2String(RecordSet.getString("id")); //相关项目支出的所有的财务表的id
    }
}
if(!feeids.equals("")){//如果项目有支出的话才算总的支出
    feeids = feeids.substring(1);
    String sql_countfee="select sum(amount) projfee from FnaAccountLog where id in("+feeids+")";
    RecordSet.executeSql(sql_countfee);
    RecordSet.next();
    projfee = Util.null2String(RecordSet.getString(1));//总支出
}
try{
	
	String fnayear = TimeUtil.getCurrentDateString().substring(0,4);
	String fnayearstartdate = "";
	String fnayearenddate = "";
	RecordSet.executeSql("select startdate, enddate , Periodsid from FnaYearsPeriodsList where fnayear= '"+fnayear+"' and ( Periodsid = 1 or Periodsid = 12 ) ");
	while( RecordSet.next() ) {
	    String Periodsid = Util.null2String(RecordSet.getString( "Periodsid" ) ) ;
	    if( Periodsid.equals("1") ){
	    	fnayearstartdate = Util.null2String(RecordSet.getString( "startdate" ) ) ;
	    }
	    if( Periodsid.equals("12") ){
	    	fnayearenddate = Util.null2String(RecordSet.getString( "enddate" ) ) ;
	    }
	}
	double projfee_ext = BudgetHandler.getExpenseRecursion(fnayearstartdate,fnayearenddate,0,0,0,Util.getIntValue(ProjID),0,0).getRealExpense();
	projfee = ""+(projfee_ext + Util.getDoubleValue(projfee, 0));
}catch(Exception e){}


/*项目状态*/
String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID;
RecordSet.executeSql(sql_tatus);
RecordSet.next();
String isactived=Util.null2String(RecordSet.getString("isactived"));

// added by lupeng 2004-08-26.
RecordSet.executeSql("SELECT SUM(realManDays) FROM Prj_TaskProcess WHERE prjid = " + ProjID);
RecordSet.next();
float totalWorkTime = Util.getFloatValue(RecordSet.getString(1), 0);
// end.

//计算工期和实际总工期

String passnoworktime1 ="";
int manager1 =-1;
rs2.executeSql("select * from Prj_ProjectInfo where id ="+ProjID);
rs2.next();
passnoworktime1=rs2.getString("passnoworktime");
manager1 = Util.getIntValue(rs2.getString("manager"));
rs2.executeProc("Prj_TaskProcess_Sum",ProjID);
rs2.next();
//计算总工时
String totalbegindate = rs2.getString("begindate");
String totalenddate = rs2.getString("endDate");
String totalactualbegindate = rs2.getString("actualBeginDate");
String totalactualenddate = rs2.getString("actualEndDate");
String totalworkday1 = "";
String totalworkday2 = "";
Map<String,String> result = PrjTimeAndWorkdayUtil.getTimeForProj(totalbegindate,totalenddate,totalactualbegindate,totalactualenddate,ProjID,"");
totalworkday1 = result.get("totalworkday1");
totalworkday2 = result.get("totalworkday2");



if(status_prj.equals("1")||status_prj.equals("2")||status_prj.equals("3")||status_prj.equals("4")||status_prj.equals("5")) isactived="2";
//status_prj=5&&isactived=2,立项批准
//status_prj=1,正常
//status_prj=2,延期
//status_prj=3,完成
//status_prj=4,冻结

String ProcPara = "";
int userid = user.getUID();
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;

char flag=Util.getSeparator() ;

//get doc count
DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.addDocstatus("1");
DocSearchComInfo.addDocstatus("2");
DocSearchComInfo.addDocstatus("5");
DocSearchComInfo.setProjectid(ProjID);
String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
DocSearchManage.getSelectResultCount(whereclause,user) ;
String doccount=""+DocSearchManage.getRecordersize();

//get cowork count
int allCount = CoworkDAO.getAllCoworkCountByProjectId(ProjID);
//get request count
int tempid=Util.getIntValue(ProjID,0);
RelatedRequestCount.resetParameter();
RelatedRequestCount.setUserid(userid);
RelatedRequestCount.setUsertype(usertype);
RelatedRequestCount.setRelatedid(tempid);
RelatedRequestCount.setRelatedtype("proj");
RelatedRequestCount.selectRelatedCount();

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

//get crm count
CRMSearchComInfo.resetSearchInfo();
CRMSearchComInfo.setPrjID(ProjID);
String CRM_SearchSql="";
String crmcount="0";
if(logintype.equals("1")){
	CRM_SearchSql = "select count(distinct t1.id) from CRM_CustomerInfo  t1,"+leftjointable+" t2 "+ CRMSearchComInfo.FormatSQLSearch(user.getLanguage())+" and t1.id = t2.relateditemid";
}else{
	CRM_SearchSql = "select count(*) from CRM_CustomerInfo  t1 "+ CRMSearchComInfo.FormatSQLSearch(user.getLanguage())+" and t1.agent="+user.getUID();
}
RecordSet.executeSql(CRM_SearchSql);
if(RecordSet.next()){
	crmcount = ""+RecordSet.getInt(1);
}


RecordSet.executeProc("PRJ_Find_LastModifier",ProjID);
RecordSet.first();
String Modifier = Util.null2String(RecordSet.getString(1));
String ModifyDate = Util.null2String(RecordSet.getString(2));


RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/proj/DBError.jsp?type=FindData_VP");
RecordSet.first();

String Creater = Util.null2String(RecordSet.getString("creater"));
String CreateDate = Util.null2String(RecordSet.getString("createdate"));
String projTypeId=Util.null2String(RecordSet.getString("prjtype"));

/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";




//4E8 项目权限等级(默认共享的值设置:项目成员0.5,项目经理2.5,项目经理上级3,项目管理员4;手动共享值设置:查看1,编辑2)
double ptype=Util.getDoubleValue( CommonShareManager.getPrjPermissionType(""+ProjID, user),0 );
if(ptype==2.5||ptype==2){
	canview=true;
	canedit=true;
	ismanager=true;
}else if (ptype==3){
	canview=true;
	canedit=true;
	ismanagers=true;
}else if (ptype==4){
	canview=true;
	canedit=true;
	isrole=true;
}else if (ptype==0.5){
	canview=true;
	ismember=true;
}else if (ptype==1){
	canview=true;
	isshare=true;
}

int requestid = Util.getIntValue(request.getParameter("requestid"),0);
boolean onlyview=false;
if(!canview){
    if(!WFUrgerManager.UrgerHavePrjViewRight(requestid,userid,Util.getIntValue(logintype),ProjID) && !WFUrgerManager.getMonitorViewObjRight(requestid,userid,""+ProjID,"2")
		&&!CoworkDAO.haveRightToViewPrj(Integer.toString(user.getUID()),ProjID)
		){
        response.sendRedirect("/notice/noright.jsp") ;
        return;
    }else{
        onlyview=true;
    }
}
/*权限－end*/

//写viewlog表
String needlog = Util.null2String(request.getParameter("log"));
if(!needlog.equals("n"))
{


String clientip=request.getRemoteAddr();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
RecordSetLog.executeProc("Prj_ViewLog1_Insert",ProjID+""+flag+userid+""+flag+user.getLogintype()+""+flag+CurrentDate+flag+CurrentTime+flag+clientip);
}

//added by lupeng 2004-07-08
String[] params = new String[] {String.valueOf(userid), ProjID};
ArrayList results = new ArrayList();
int resultCount = workPlanSearch.getProjAssociatedCount(params);
//end



%>

<%
String workday03 = "";
String begindate03 = "";
String enddate03 = "";
String finish = "0";
String fixedcode="0";
float finish_1=0;
int finish_2 =0;

ProcPara = ProjID;
RecordSet2.executeProc("Prj_TaskProcess_Sum",ProcPara);
if(RecordSet2.next()){
    if (!Util.null2String(RecordSet2.getString("workday")).equals("")){
    	workday03 = Util.null2String(RecordSet2.getString("workday"));
    	if(!Util.null2String(RecordSet2.getString("begindate")).equals("x"))
             begindate03 = Util.null2String(RecordSet2.getString("begindate"));
    	if(!Util.null2String(RecordSet2.getString("enddate")).equals("-")) 
            enddate03 = Util.null2String(RecordSet2.getString("enddate"));
    
    	finish_1=0;
        finish_1 = Util.getFloatValue(RecordSet2.getString("finish"),0);
        finish_2 = (int) finish_1;
        
        fixedcode = Util.null2String(RecordSet2.getString("fixedcost"));
    }
}

String conStr="";
String countprj ="";
String prjincome ="";
String prjconsum ="";
if(!contractids_prj.equals("")){
    /*项目实际收入*/
    conStr="select sum(t1.amount) from FnaAccountLog t1,FnaBudgetfeeType t2  where t1.releatedid in("+contractids_prj+") and t1.iscontractid='1' and  t2.id=t1.feetypeid and t2.feetype='2' and t1.projectid ="+ ProjID;
    RecordSetC.executeSql(conStr);
    RecordSetC.next();
    prjincome = RecordSetC.getString(1);
    /*项目金额＝合同金额的累加*/
    countprj ="select sum(price) from CRM_Contract where id in ("+contractids_prj+")";
    RecordSetC.executeSql(countprj);
    RecordSetC.next();
    prjconsum = RecordSetC.getString(1);
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript"  type='text/javascript' src="/js/weaver_wev8.js"></SCRIPT>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#topTitle").topMenuTitle();
	jQuery("#hoverBtnSpan").hoverBtn();
});
</script>
</HEAD>
<%


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(610,user.getLanguage())+" - "+Util.null2String(RecordSet.getString("name"));
String newtitlename = titlename;
titlename += " <B>" + SystemEnv.getHtmlLabelName(401,user.getLanguage()) + ":</B>"+CreateDate ;
titlename += " <B>" + SystemEnv.getHtmlLabelName(623,user.getLanguage()) + ":</B>";
if(user.getLogintype().equals("1"))
	titlename += " <A href=/hrm/resource/HrmResource.jsp?id=" + Creater + ">" + Util.null2String(ResourceComInfo.getResourcename(Creater)) + "</a>";
titlename += " <B>" + SystemEnv.getHtmlLabelName(103,user.getLanguage()) + ":</B>"+ModifyDate ;
titlename += " <B>" + SystemEnv.getHtmlLabelName(623,user.getLanguage()) + ":</B>";
if(user.getLogintype().equals("1"))
	titlename += " <A href=/hrm/resource/HrmResource.jsp?id=" + Modifier + ">" + Util.null2String(ResourceComInfo.getResourcename(Modifier)) + "</a>";

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
	session.setAttribute("fav_pagename" , newtitlename ) ;	
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("563,352",user.getLanguage())%>'>
<%if(!user.getLogintype().equals("2")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(428,user.getLanguage())%></wea:item>
		<wea:item><a href="javascript:openFullWindowForXtable('/fna/report/expense/Rpt1FnaBudgetViewInner.jsp?projectid=<%=ProjID%>&projidss=1')" ><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a></wea:item>
<%}%>		
		<wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></wea:item>
		<wea:item><a href="javascript:openFullWindowForXtable('/CRM/search/SearchOperation.jsp?PrjID=<%=ProjID%>')"><%=crmcount%></a></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></wea:item>
		<wea:item><a href="javascript:openFullWindowForXtable('/docs/search/DocSearchTemp.jsp?projectid=<%=ProjID%>&docstatus=6')"><%=doccount%></a></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></wea:item>
		<wea:item><a href="javascript:openFullWindowForXtable('/cowork/coworkview.jsp?projectid=<%=ProjID%>&type=all')"><%=allCount%></a></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%>)</wea:item>
		<wea:item><a href="javascript:openFullWindowForXtable('/workflow/search/WFSearchTemp.jsp?prjids=<%=ProjID%>&nodetype=0')"><%=RelatedRequestCount.getCount0()%></A></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>)</wea:item>
		<wea:item><a href="javascript:openFullWindowForXtable('/workflow/search/WFSearchTemp.jsp?prjids=<%=ProjID%>&nodetype=1')"><%=RelatedRequestCount.getCount1()%></A></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%>)</wea:item>
		<wea:item><a href="javascript:openFullWindowForXtable('/workflow/search/WFSearchTemp.jsp?prjids=<%=ProjID%>&nodetype=2')"><%=RelatedRequestCount.getCount2()%></A></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(553,user.getLanguage())%>)</wea:item>
		<wea:item><a href="javascript:openFullWindowForXtable('/workflow/search/WFSearchTemp.jsp?prjids=<%=ProjID%>&nodetype=3')"><%=RelatedRequestCount.getCount3()%></A></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>)</wea:item>
		<wea:item><a href="javascript:openFullWindowForXtable('/workflow/search/WFSearchTemp.jsp?prjids=<%=ProjID%>')"><%=RelatedRequestCount.getTotalcount()%></a></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16652,user.getLanguage())%></wea:item>
		<wea:item><a href="javascript:openFullWindowForXtable('/workplan/search/WorkPlanSearchResult.jsp?prjids=<%=ProjID%>&from=1&isFirst=0')"><%=resultCount%></a></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></wea:item>
		<wea:item><%=begindate03%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></wea:item>
		<wea:item><%=enddate03%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1298,user.getLanguage())%></wea:item>
		<wea:item><%=totalworkday1%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17544,user.getLanguage())%></wea:item>
		<wea:item><%=totalworkday2%></wea:item>
<%if(!user.getLogintype().equals("2")){%>		
		<wea:item><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></wea:item>
		<wea:item><%=fixedcode%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15264,user.getLanguage())%></wea:item>
		<wea:item><%=projfee%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(6146,user.getLanguage())%></wea:item>
		<wea:item><%=prjconsum%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15265,user.getLanguage())%></wea:item>
		<wea:item><%=prjincome%></wea:item>
<%}%>		
	</wea:group>
</wea:layout>


</body>
</html>
