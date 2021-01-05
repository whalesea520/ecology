<%@page import="weaver.proj.util.SQLUtil"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="java.io.File"%>
<%@page import="weaver.pmp.chart.FusionchartsGantt"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.teechart.TeeChart" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetHrm" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectProcessList" class="weaver.proj.Maint.ProjectProcessList" scope="page" />
<jsp:useBean id="FusionchartsGantt" class="weaver.pmp.chart.FusionchartsGantt" scope="page" />

<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page" />
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page"/>
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
	.e8ToolBar{
		position:relative!important;
	}
	.e8ToolBar td.btnTd{
		border:none;
	}
.rowspan{margin-left: 5px;margin-right: 10px;margin-top: 6px;margin-bottom: 6px;}
.rowspan2{margin-left: 15px;margin-right: 10px;margin-top: 6px;margin-bottom: 6px;}
</style>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
<script language="JavaScript" src="FusionCharts_wev8.js"></script>
<script language="JavaScript" src="FusionChartsExportComponent_wev8.js"></script>

<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript">
var parentWin;
var parentDialog;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	parentDialog = parent.parent.getDialog(parent);
}
if("<%=isclose%>"=="1"){
	try{
		
		parentWin = parent.parent.getParentWindow(parent);
		parentDialog = parent.parent.getDialog(parent);
		parentDialog.close();
		parentWin._table.reLoad();
	}catch(e){}
		
}
</script>

</HEAD>
<%
String init = Util.null2String(request.getParameter("init"));
boolean showplan ="1".equals( Util.null2String(request.getParameter("showplan")));
if("".equals(init)){
	showplan=PrjSettingsComInfo.getPrj_gnt_showplan_();
}

String nameQuery1 = Util.null2String(request.getParameter("flowTitle"));
String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String taskname = Util.null2String(request.getParameter("taskname"));
String planbegindate = Util.null2String(request.getParameter("planbegindate"));
String planbegindate1 = Util.null2String(request.getParameter("planbegindate1"));
String planenddate = Util.null2String(request.getParameter("planenddate"));
String planenddate1 = Util.null2String(request.getParameter("planenddate1"));
String actualbegindate = Util.null2String(request.getParameter("actualbegindate"));
String actualbegindate1 = Util.null2String(request.getParameter("actualbegindate1"));
String actualenddate = Util.null2String(request.getParameter("actualenddate"));
String actualenddate1 = Util.null2String(request.getParameter("actualenddate1"));
String finish = Util.null2String(request.getParameter("finish"));
String finish1 = Util.null2String(request.getParameter("finish1"));
String taskstatus = Util.null2String(request.getParameter("taskstatus"));
String prjname = Util.null2String(request.getParameter("prjname"));
String manager = Util.null2String(request.getParameter("manager"));
String managerdept = Util.null2String(request.getParameter("managerdept"));
String islandmark = Util.null2String(request.getParameter("islandmark"));
String taskgroup = Util.null2String(request.getParameter("taskgroup"));
String version = Util.null2String(request.getParameter("version"));
int timelineType=Util.getIntValue(request.getParameter("timelineType"),2);

boolean isHistory=!"".equals(version);


Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

char flag = 2;
String ProcPara = "";
int Version=0;
String ProjID = Util.null2String(request.getParameter("ProjID"));
RecordSet.executeProc("Prj_TaskInfo_SelectMaxVersion",ProjID);
if(false&& !RecordSet.next()){
	response.sendRedirect("/proj/plan/NewPlan.jsp?log=n&ProjID="+ProjID) ;
}

/*项目状态*/
String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID+"order by id";
RecordSet.executeSql(sql_tatus);
RecordSet.next();
String isCurrentActived=RecordSet.getString("isactived");
//isactived=0,为计划
//isactived=1,为提交计划
//isactived=2,为批准计划

String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
RecordSet.executeSql(sql_prjstatus);
RecordSet.next();
String status_prj=RecordSet.getString("status");
    String prjtypewf=""+ProjectTransUtil.getApproveWorkflowidById(ProjID);//项目审批工作流
//status_prj=5&&isactived=2,立项批准
//status_prj=1,正常
//status_prj=2,延期
//status_prj=3,终止
//status_prj=4,冻结

String taskrecordid="";

String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false; //能否查看
boolean canedit=false; //能否编辑
boolean iscreater=false; //是否是创建者
boolean ismanager=false; //是否是项目经理
boolean ismanagers=false; //是否是项目经理的经理
boolean ismember=false; //是否是成员
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



if(ismanager){
    if((""+user.getUID()).equals(""+user.getManagerid())){
        ismanagers=true;
    }
}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
if(isHistory){
	canedit=false;
}
/*权限－end*/



String log = Util.null2String(request.getParameter("log"));
String level = Util.null2String(request.getParameter("level"));
String subject= Util.fromScreen2(request.getParameter("subject"),user.getLanguage());
String begindate01= Util.null2String(request.getParameter("begindate01"));
String begindate02= Util.null2String(request.getParameter("begindate02"));
String enddate01= Util.null2String(request.getParameter("enddate01"));
String enddate02= Util.null2String(request.getParameter("enddate02"));
String hrmid = Util.null2String(request.getParameter("hrmid"));

if(level.equals("")){
	level = "10" ;
}
RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();
String members=RecordSet.getString("members"); 


prjname=RecordSet.getString("name");
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1338,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+ProjID+"'>"+Util.toScreen(prjname,user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";

String sqlwhere="";
sqlwhere=" where prjid = "+ProjID+" and  level_n <= 10 and isdelete<>'1' ";
if(!"".equals(nameQuery1)){
	sqlwhere+=" and subject like '%"+nameQuery1+"%'";
}else if(!"".equals(nameQuery)){
	sqlwhere+=" and subject like '%"+nameQuery+"%'";
}
if(!"".equals(taskname)){
	sqlwhere+=" and subject like '%"+taskname+"%'";
}
if(!begindate01.equals("")){
	sqlwhere+=" and begindate>='"+begindate01+"'";
}
if(!begindate02.equals("")){
	sqlwhere+=" and begindate<='"+begindate02+"'";
}
if(!enddate01.equals("")){
	sqlwhere+=" and enddate>='"+enddate01+"'";
}
if(!enddate02.equals("")){
	sqlwhere+=" and enddate<='"+enddate02+"'";
}
if(!hrmid.equals("")){
	sqlwhere+=" and (hrmid like '%,"+hrmid+",%' or hrmid like '"+hrmid+",%' or hrmid like '%,"+hrmid+"' or hrmid = '"+hrmid+"')";
}
if(!version.equals("")){
	sqlwhere+=" and version='"+version+"' ";
}
    sqlwhere+=" and level_n<="+level;
    
if(!"".equals(islandmark)){
	sqlwhere+=" and islandmark='"+islandmark+"' ";
}   

if(!"".equals(finish)){
	sqlwhere+=" and finish >='"+finish+"' ";
}
if(!"".equals(finish1)){
	sqlwhere+=" and finish <='"+finish1+"' ";
}

String tablename=" Prj_TaskProcess ";
if(!"".equals(version)){
	tablename=" prj_taskinfo ";
}
  
    
    
String sqlstr = " SELECT * FROM "+tablename+" " +sqlwhere+ " order by taskindex,parentid ";
//out.println("sqlstr :"+sqlstr);
//ProjectProcessList.getProcessList(sqlstr) ;
boolean hasTask=false;
RecordSet.executeSql(sqlstr);
if(RecordSet.getCounts()>0){
	hasTask=true;
}
//gantt chart
FusionchartsGantt.setTimelineType(timelineType);
FusionchartsGantt.setShowPlan(showplan);
FusionchartsGantt.setWarningDays(Util.getIntValue( PrjSettingsComInfo.getPrj_gnt_warningday(),3));
String xmlStr= FusionchartsGantt.generateChartStr(sqlstr, ProjID, begindate01, enddate01,user);
//FusionchartsGantt.bulidFusionChartDateFile(sqlstr, ProjID, begindate01, enddate01,new File("C:\\Users\\Administrator\\Desktop\\source\\Data\\test.xml"),user);

String CurrentUser = ""+user.getUID();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;

ArrayList requesttaskids=new ArrayList();
ArrayList requesttaskcounts=new ArrayList();
ArrayList doctaskids=new ArrayList();
ArrayList doctaskcounts=new ArrayList();

ProcPara = ProjID + flag + "0" ;
RecordSetHrm.executeProc("Prj_Member_SumProcess",ProcPara);
%>
<BODY onload="" onresize="refreshGantt();">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
String sql="select version from prj_taskinfo  where prjid='"+ProjID+"' group by version order by version desc";
RecordSet3.executeSql(sql);
int vCount=RecordSet3.getCounts();
boolean editTaskOk=!isHistory && canedit&&!status_prj.equals("3")&&!status_prj.equals("4")&&!status_prj.equals("6");
String submitMenuname=SystemEnv.getHtmlLabelNames("15143",user.getLanguage());
if(editTaskOk){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1342,user.getLanguage())+",javascript:onAddTask("+ProjID+")"+",_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("93",user.getLanguage())+",javascript:onEdit("+ProjID+")"+",_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(20521,user.getLanguage())+", javascript:expTask(), ExcelOut} " ;
    //RCMenuHeight += RCMenuHeightStep;
	if(ismanager && !isHistory&&isCurrentActived.equals("2")){
		RCMenu += "{"+SystemEnv.getHtmlLabelNames("83906",user.getLanguage())+",javascript:saveasplan("+ProjID+"),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	
	if(ismanager && !isCurrentActived.equals("2") && hasTask  && (status_prj.equals("0")||status_prj.equals("")||"7".equals(status_prj) )){//提交批准
		
		if(Util.getIntValue( prjtypewf,0)<=0){
			submitMenuname=SystemEnv.getHtmlLabelNames("83909",user.getLanguage());
		}
		RCMenu += "{"+submitMenuname+",javascript:submitPlan("+prjtypewf+"),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	if(vCount>0){	
		RCMenu += "{"+SystemEnv.getHtmlLabelNames("18552",user.getLanguage())+", javascript:onHistory("+ProjID+"), _self} " ;
	    RCMenuHeight += RCMenuHeightStep;
	}
}
%>




<%if(hasTask && canedit){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1348,user.getLanguage())+",javascript:noticeMember("+ProjID+"),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%}%>
<%if(hasTask){%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+",javascript:onRequest("+ProjID+")"+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+",javascript:onDoc("+ProjID+")"+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelNames("83911",user.getLanguage())+",javascript:onCowork("+ProjID+")"+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%}%>




<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog("+ProjID+")"+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>



<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

  

<form name=weaver id=weaver method=post action="">
  <input type="hidden" name="ProjID" value="<%=ProjID%>">
  <input type="hidden" name="version" value="<%=version %>">
  <input type="hidden" name="init" value="1">
  <input type="hidden" name="isdialog" value="<%=isDialog %>">
  
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
<%
if(editTaskOk){
	%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("1342",user.getLanguage())%>" class="e8_btn_top"  onclick="onAddTask(<%=ProjID %>)"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("93",user.getLanguage())%>" class="e8_btn_top"  onclick="onEdit(<%=ProjID %>)"/>
	
	<%
	if(ismanager && !isCurrentActived.equals("2") && hasTask  && (status_prj.equals("0")||status_prj.equals("")||"7".equals(status_prj) )){//提交批准,提交执行
		%>
			<input type="button" value="<%=submitMenuname %>" class="e8_btn_top"  onclick="submitPlan(<%=prjtypewf %>)"/>
		<%
	}
}
%>		
		
			<input type="text" class="searchInput" name="flowTitle" value="<%=nameQuery1 %>" />
			<span id="advancedSearch" class="advancedSearch" style=""><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("1352",user.getLanguage())%></wea:item>
		<wea:item><input class="InputStyle" name="taskname" id="taskname" value='<%=taskname %>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("83796",user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="planbegindate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="planbegindate" value="<%=planbegindate%>">
				  <input class=wuiDateSel  type="hidden" name="planbegindate1" value="<%=planbegindate1%>">
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("22170",user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="planendate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="planenddate" value="<%=planenddate%>">
				  <input class=wuiDateSel  type="hidden" name="planenddate1" value="<%=planenddate1%>">
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("33351",user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="actualbegindate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="actualbegindate" value="<%=actualbegindate%>">
				  <input class=wuiDateSel  type="hidden" name="actualbegindate1" value="<%=actualbegindate1%>">
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("24697",user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="actualenddate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="actualenddate" value="<%=actualenddate%>">
				  <input class=wuiDateSel  type="hidden" name="actualenddate1" value="<%=actualenddate1%>">
			</span>
		</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
    		<input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
    	</wea:item>
    </wea:group>
    
</wea:layout>
</div>


<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
<div>
	<span class="rowspan"><%=SystemEnv.getHtmlLabelName(2099,user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("15836",user.getLanguage())%></span>
	<span class="rowspan">
		<select  name=level size=1 class=InputStyle   onchange="weaver.submit();">
		 <%for(int i=1;i<=10;i++){%>
			 <option value="<%=i%>" <%if(level.equals(""+i)){%>selected<%}%>><%=i%></option>
		 <%}%>
		 </select>
	</span>
	<span class="rowspan2"><%=SystemEnv.getHtmlLabelNames("1332",user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></span>
	<span class="rowspan">
		<select   name=hrmid size=1 class=InputStyle   onchange="weaver.submit()">
			<option value="" ><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
		 <%String hrmidmore ="";
		 while(RecordSetHrm.next()){
		 	 hrmidmore += RecordSetHrm.getString("hrmid")+",";
		 	 }
		 String[] managers111=hrmidmore.split(",");
		  List<String> list = new ArrayList<String>();
		  for (int i = 0; i < managers111.length; i++) {
			   if(!"".equals(managers111[i])&&!list.contains(managers111[i])){
				   list.add(managers111[i]); 
			   }
		  }
		  if(list.size()>0){
			   for(int m=0;m<list.size();m++){
		 	 %>
			 <option value="<%=list.get(m)%>" <%if(list.get(m).equals(""+hrmid)){%>selected<%}%>><%=ResourceComInfo.getResourcename(list.get(m))%></option>
		 <%}}%>
		 </select>
	</span>
	<span class="rowspan2"><%=SystemEnv.getHtmlLabelNames("83913",user.getLanguage())%></span>
	<span class="rowspan">
		<select  name=islandmark  class=InputStyle   onChange="weaver.submit()">
		 	<option value=""><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
		 	<option value="1" <%="1".equals(islandmark)?"selected":"" %>><%=SystemEnv.getHtmlLabelNames("2232",user.getLanguage())%></option>
		</select>
	</span>
	<span class="rowspan2"><%=SystemEnv.getHtmlLabelNames("83929",user.getLanguage())%></span>
	<span class="rowspan">
		<select  name=timelineType size=1 class=InputStyle   onChange="weaver.submit()">
			 <option value="1" <%=timelineType==1?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("445",user.getLanguage())%></option>
			 <option value="2" <%=timelineType==2?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("33452",user.getLanguage())%></option>
			 <!-- option value="3" <%=timelineType==3?"selected":"" %> >周</option-->
			 <option value="4" <%=timelineType==4?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("390",user.getLanguage())%></option>
		 </select>
	</span>
	<span class="rowspan2"><%=SystemEnv.getHtmlLabelNames("33166",user.getLanguage())%></span>
	<span class="rowspan">
		<input type="checkbox" tzCheckbox="true" name="showplan" id="showplan" value="1" <%=showplan?"checked":"" %> onchange="switchshowplan(this)"/>
	</span>
	<span class="rowspan2">
		<input type="button" value="<%=SystemEnv.getHtmlLabelNames("82532",user.getLanguage())%>" class="e8_btn_top"  onclick="onShowGantt()"/>
	</span>
</div>
		
		</wea:item>
		
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
		
		
<div class="e8_box" id="basicset" style="background-color:#F8F8F8!important;">
    <ul class="tab_menu" style="background:#F8F8F8;margin-left:10px!important;">
        <li class="<%="".equals(version)?"current":"" %>" version='' onclick="getVersion(this)"><%=SystemEnv.getHtmlLabelNames("524",user.getLanguage())%></li>
        <%
        while(RecordSet3.next()){
        	String v=Util.null2String( RecordSet3.getString("version"));
        	%>
        <li class="<%=v.equals(version)?"current":"" %>" version='<%=v %>' onclick="<%=v.equals(version)?"":"getVersion(this)" %>">V<%=v %></li>	
        	<%
        }
        %>
    </ul>
    <div id="rightBox" class="e8_rightBox">
    </div>
    <div class="tab_box" style="display:none;">
        <div>
        </div>
    </div>
</div>
<table class=ViewForm cellspacing=0 >
  <tr class="Spacing" style="height:1px!important;">
      <td colspan="9" class="paddingLeft0Table">
        <div class="intervalDivClass"></div>
      </td>
    </tr>
</table>				
		
		</wea:item>
		
	</wea:group>
</wea:layout>


  
  
  


</form>


<div id="chart1div" align="center" ><%=SystemEnv.getHtmlLabelNames("18820",user.getLanguage())%></div>
 <script type="text/javascript">
 	var width=document.body.clientWidth;
	var chart1 = new FusionCharts("Gantt.swf", "myChartId", width, "<%=FusionchartsGantt.getFusionChartHeigth() %>", "0", "1");
	chart1.setDataXML("<%=xmlStr %>");
	chart1.render("chart1div");
 </script>

<%--
<div id="fcexpDiv" align="center">FusionCharts Export Handler Component</div>
<script type="text/javascript">
var myExportComponent = new FusionChartsExportObject("fcExpGantt1", "FCExporter.swf");    
myExportComponent.Render("fcexpDiv");
</script>
 --%>





<script language=javascript >


function submitPic(){
    weaver.action="ViewProcess.jsp";
    weaver.submit();
}


function refreshGantt(){
}

function link2Task(taskid){
	window.open("/proj/process/ViewTask.jsp?taskrecordid="+taskid);
}
</script>

<script type="text/javascript">
function switchshowplan(obj){
	
	if($(obj).next("span").hasClass("checked")){
		$("#showplan").attr("checked",true);
	}else{
		$("#showplan").attr("checked",false);
	}
	weaver.submit();
}


function onShowGantt(){
	weaver.action="/proj/process/ViewProcess.jsp?ProjID=<%=ProjID %>";
	weaver.submit();
}
function getVersion(obj){
	$("input[name=version]").val( $(obj).attr("version"));
	weaver.submit();
}
function expTask(){
	/**jQuery.ajax({
		url : "/proj/data/ViewProjectData.jsp?ProjID=<%=ProjID%>&isExpTask=1",
		type : "post",
		async : true,
		processData : false,
		data : "",
		dataType : "html",
		success: function do4Success(msg){
			document.getElementById("ExcelOut").src="/weaver/weaver.file.ExcelOut";
		}
	});	**/
	_xtable_getAllExcel('prj_viewprocess');
	
}
function onAddTask(id){
	if(id){
		var url="/proj/process/AddTask.jsp?ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("15266",user.getLanguage())%>";
		openDialog(url,title,800,550,true);
	}
}

function onEdit(id){
	if(id){
		var url="/proj/data/EditProjectTask.jsp?ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("15284",user.getLanguage())%>";
		openDialog(url,title,1000,720,true,true);
	}
}

function onLog(id){
	if(id){
		var url="/proj/data/ViewTaskLog.jsp?ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("83926",user.getLanguage())%>";
		openDialog(url,title,1000,720,true);
	}
}


function onHistory(id){
	if(id){
		var url="/proj/data/ViewTaskLog.jsp?ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("18552",user.getLanguage())%>";
		openDialog(url,title,1000,720,true);
	}
}
function onRequest(id){
	if(id){
		var url="/proj/process/DspRequest.jsp?ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("1044",user.getLanguage())%>";
		openDialog(url,title,1000,720,true);
	}
}
function onDoc(id){
	if(id){
		var url="/proj/process/DspDoc.jsp?ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("857",user.getLanguage())%>";
		openDialog(url,title,1000,720,true);
	}
}
function onCowork(id){
	if(id){
		var url="/proj/process/DspCowork.jsp?ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("83911",user.getLanguage())%>";
		openDialog(url,title,1000,720,true);
	}
}


function saveasplan(id){
	if(id){
		var url="/proj/plan/PlanOperation.jsp";
		jQuery.post(
			url,
			{"method":"saveasplan","ProjID":id},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>",function(){
					weaver.submit();
				});
			}
		);
	}
}

function onBtnSearchClick(){
	weaver.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
jQuery(document).ready(function(){
	jQuery('.e8_box').Tabs({
    	getLine:1,
    	image:false,
    	needLine:false,
    	needTopTitle:false,
    	staticHeight:true,
    	height:"30px"
    });
});

function submitPlan(obj,wfid){
	var message="<%=SystemEnv.getHtmlLabelNames("83919",user.getLanguage())%>";
	var message2="<%=SystemEnv.getHtmlLabelNames("83920",user.getLanguage())%>";
	if(wfid&&wfid>0){
		message="<%=SystemEnv.getHtmlLabelNames("83921",user.getLanguage())%>";
		message2="<%=SystemEnv.getHtmlLabelNames("83922",user.getLanguage())%>";
	}
	window.top.Dialog.confirm(message,function(){
		//提示
		var diag_tooltip = new window.top.Dialog();
		diag_tooltip.ShowCloseButton=false;
		diag_tooltip.ShowMessageRow=false;
		diag_tooltip.normalDialog=false;
		//diag_tooltip.hideDraghandle = true;
		diag_tooltip.Width = 300;
		diag_tooltip.Height = 50;
		diag_tooltip.InnerHtml="<div style=\"font-size:12px;\" >"+message2+"<br><img style='margin-top:-20px;' src='/images/ecology8/loadingSearch_wev8.gif' /></div>";
		diag_tooltip.show();
		
		jQuery.ajax({
			url : "/proj/plan/PlanOperation.jsp?ProjID=<%=ProjID%>&method=submitplan&wfid="+wfid,
			type : "post",
			async : true,
			data : "",
			dataType : "html",
			success: function do4Success(msg){
				diag_tooltip.close();
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83923",user.getLanguage())%>");
				window.location.reload();
			}
		});
	});
}
</script>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentDialog.close();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
