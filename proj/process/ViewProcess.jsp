<%@page import="weaver.proj.util.SQLUtil"%>
<%@page import="weaver.proj.util.PropUtil"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.DecimalFormat" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetHrm" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectProcessList" class="weaver.proj.Maint.ProjectProcessList" scope="page" />
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page" />
<jsp:useBean id="KnowledgeTransMethod" class="weaver.general.KnowledgeTransMethod" scope="page"/>
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page"/>
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="PrjTimeAndWorkdayUtil" class="weaver.proj.util.PrjTimeAndWorkdayUtil" scope="page" />


<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
RecordSetV.executeSql("update Prj_TaskProcess set finish=0 where finish is null or finish = '' " );

String pageId=Util.null2String(PropUtil.getPageId("prj_viewprocess"));
%>
<HTML><HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<LINK href="/js/ecology8/base/jquery.ui.all_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/js/ecology8/base/jquery.ui.progressbar_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
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
<style>
.progress-label {
     float: left;
     margin-left: 50%;
     margin-top: 5px;
     font-weight: bold;
     text-shadow: 1px 1px 0 #fff;
}
.ui-progressbar{ 
background : ; 
padding:1px; 
}	
.ui-progressbar-value{ 
background : #A5E994; 
} 
.rowspan{margin-left: 10px;margin-right: 10px;margin-top: 6px;margin-bottom: 6px;}
.rowspan2{margin-left: 25px;margin-right: 10px;margin-top: 6px;margin-bottom: 6px;}
</style>

<script type="text/javascript">
var e;
var rowsNum = 0;
var tbl;
var imgIDs = "";
window.onload = function(){
	tbl = document.getElementById("mytbl");
	if(!tbl) return;
	rowsNum = tbl.rows.length;

	var aImgIDs = imgIDs.split(",");
	for(var i=0; i<aImgIDs.length; i++){
		try{setImgSrc(aImgIDs[i])}catch(e){}
	}
}

function toggleChild(tr, children){
	for(var i=0; i<children.length; i++){
		var child = children[i];
		var childType = getChildType(child);
		var clicked = child.getAttribute("clicked");
		//alert(child+","+childType+","+clicked);
		if(childType=="node" && clicked=="false"){
			toggleChild(child, getChildren(child));
		}
		child.style.display = tr.open=="true" ? "none" : "";
	}
	changeImg(tr);
}

function changeImg(tr){
	var img = document.getElementById("img"+tr.id);
	if(tr.open=="true"){
		img.src = img.src.replace("rank1", "rank2");
	}else{
		img.src = img.src.replace("rank2", "rank1");
	}
	tr.open = tr.open=="true" ? "false" : "true";
}

function getChildType(tr){
	var type;
	var level = tr.getAttribute("level");
	var _level;
	try{
		//_level = tbl.rows(tr.rowIndex+1).getAttribute("level");
		_level = tbl.rows[tr.rowIndex+1].getAttribute("level");
		if(_level==parseInt(level)+1){
			type = "node";
		}else{
			type = "leaf";
		}
	}catch(e){
		type = "leaf";
	}
	return type;
}

function getChildren(tr){
	tbl = document.getElementById("mytbl");
	if(!tbl) return;
	rowsNum = tbl.rows.length;
	
	var children = new Array();
	var level = tr.getAttribute("level");
	var _level = -1;
	for(var i=tr.rowIndex+1; i<rowsNum; i++){
		_level = tbl.rows[i].getAttribute("level");
		if(_level==parseInt(level)+1){
			children.push(tbl.rows[i]);
		}else if(level==_level){
			break;
		}else{
			continue;
		}
	}
	return children;
}

function setImgSrc(trId){
	
	var tr = document.getElementById(trId);
	var o = document.getElementById("img"+trId);
	var trType = getChildType(tr);
	o.src = trType=="leaf" ? o.src.replace("rank2", "rank1") : o.src.replace("rank1", "rank2");
	
	//changeImg(document.getElementById(trId));
}
</script>
</HEAD>
<%

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


Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

char flag = 2;
String ProcPara = "";
int Version=0;
String ProjID = Util.null2String(request.getParameter("ProjID"));
if("".equals(version)){//重生成任务所引,以后再改
	ProjectTransUtil.regenPrjTaskIndexs(ProjID);
}
boolean isDraft=false;//草稿
String prjtypewf=""+ProjectTransUtil.getApproveWorkflowidById(ProjID);//项目审批工作流
isDraft=("0".equals( ProjectInfoComInfo.getProjectInfostatus(ProjID)));



/*项目状态*/
String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID+"order by id";
RecordSet.executeSql(sql_tatus);
RecordSet.next();
String isCurrentActived=RecordSet.getString("isactived");
//isactived=0,为计划
//isactived=1,为提交计划
//isactived=2,为批准计划
String status_prj="";
String prjfinish="";
String prjfinishfunc="dbo.getPrjFinish(id)";
if(!"".equals(version)){
	prjfinishfunc="dbo.getPrjTaskInfoFinish(id,'"+version+"')";
}
String sql_prjstatus=SQLUtil.filteSql(RecordSet.getDBType(),  "select status,"+prjfinishfunc+" as prjfinish from Prj_ProjectInfo where id = "+ProjID);
RecordSet.executeSql(sql_prjstatus);
if( RecordSet.next()){
	status_prj=RecordSet.getString("status");
	prjfinish=RecordSet.getString("prjfinish");
}
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

/*权限－end*/
boolean isHistory=!"".equals(version);
if(isHistory){
	canedit=false;
}


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
if(RecordSet.getCounts()<=0){
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();
String members=RecordSet.getString("members"); 



String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1338,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+ProjID+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";



String userid=""+user.getUID();
String sqlwhere=" where t1.prjid = "+ProjID+" and  t1.level_n <= 10  ";
if(!"".equals(nameQuery1)){
	sqlwhere+=" and t1.subject like '%"+nameQuery1+"%'";
}else if(!"".equals(nameQuery)){
	sqlwhere+=" and t1.subject like '%"+nameQuery+"%'";
}
if(!"".equals(taskname)){
	sqlwhere+=" and t1.subject like '%"+taskname+"%'";
}
if(!subject.equals("")){
	sqlwhere+=" and t1.subject like '%"+subject+"%' ";
}
if(!begindate01.equals("")){
	sqlwhere+=" and t1.actualBeginDate>='"+begindate01+"'";
}
if(!begindate02.equals("")){
	sqlwhere+=" and t1.actualBeginDate<='"+begindate02+"'";
}
if(!enddate01.equals("")){
	sqlwhere+=" and t1.actualEndDate>='"+enddate01+"'";
}
if(!enddate02.equals("")){
	sqlwhere+=" and t1.actualEndDate<='"+enddate02+"'";
}
if(!hrmid.equals("")){
	sqlwhere+=" and (t1.hrmid like '%,"+hrmid+",%' or t1.hrmid like '"+hrmid+",%' or t1.hrmid like '%,"+hrmid+"' or t1.hrmid = '"+hrmid+"')";
}
if(!level.equals("")){
	sqlwhere+=" and t1.level_n<='"+level+"' ";
}
if(!islandmark.equals("")){
	sqlwhere+=" and t1.islandmark='"+islandmark+"' ";
}
if(!"".equals(finish)){
	sqlwhere+=" and t1.finish >='"+finish+"' ";
}
if(!"".equals(finish1)){
	sqlwhere+=" and t1.finish <='"+finish1+"' ";
}

//添加选择当前最大的显示顺序的取得(根据parentid) 
String sqlstr = "" ;
ArrayList theparentmaxdsporder = null ;
if(!islandmark.equals("1")) {
 theparentmaxdsporder = new ArrayList() ;
 String sqlmaxorderstr = " select max(dsporder) , parentid from Prj_TaskProcess t1 " + sqlwhere + 
                         " group by parentid " ;
 RecordSet.executeSql(sqlmaxorderstr);
 while( RecordSet.next() ) {
     String maxdsporder = ""+Util.getIntValue(RecordSet.getString(1),0) ;
     String theparentid = Util.null2String(RecordSet.getString(2)) ;
     theparentmaxdsporder.add(theparentid+"_"+maxdsporder) ;
 }
 sqlstr = " SELECT * FROM Prj_TaskProcess t1 " +sqlwhere+ " order by t1.taskindex,t1.parentid , t1.dsporder";
}
else {
 sqlstr = " SELECT * FROM Prj_TaskProcess  t1" +sqlwhere+ " and t1.islandmark='1' order by t1.taskindex,t1.parentid, t1.dsporder ";
}
//System.out.println("sqlstr :"+sqlstr);
//ProjectProcessList.getProcessList(sqlstr) ;
boolean hasTask=false;
RecordSet.executeSql(sqlstr);
if(RecordSet.getCounts()>0){
	hasTask=true;
}


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
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
//版本数量
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
if("".equals(version)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20521,user.getLanguage())+", javascript:expTask(), ExcelOut} " ;
    RCMenuHeight += RCMenuHeightStep;
}
	if(ismanager && !isHistory&&isCurrentActived.equals("2")&&!status_prj.equals("6")){
		RCMenu += "{"+SystemEnv.getHtmlLabelNames("83906",user.getLanguage())+",javascript:saveasplan("+ProjID+"),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}


	
	
	
if(ismanager && !isCurrentActived.equals("2") && hasTask  && (status_prj.equals("0")||status_prj.equals("")||"7".equals(status_prj) )){//提交批准,提交执行
	
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
  <input type="hidden" name="isdialog" value="<%=isDialog %>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
<%
if( editTaskOk){
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
			<span id="advancedSearch" class="advancedSearch" style="display:'';"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" >
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("1352",user.getLanguage())%></wea:item>
		<wea:item><input class="InputStyle" name="taskname" id="taskname" value='<%=taskname %>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("847",user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle style="width:60px!important;" maxlength=2 size=5 value="<%=finish%>" name="finish" onkeypress="return event.keyCode>=4&&event.keyCode<=57">
			-<input class=InputStyle style="width:60px!important;" maxlength=2 size=5 value="<%=finish1%>" name="finish1" onkeypress="return event.keyCode>=4&&event.keyCode<=57">
			%
		</wea:item>
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
	
	<wea:group context="">
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
		<select   name=hrmid size=20 class=InputStyle   onchange="weaver.submit()">
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
	<span class="rowspan2"><%=SystemEnv.getHtmlLabelNames("83915",user.getLanguage())%></span>
	<span class="rowspan">
		<select name=taskgroup  class=InputStyle   onChange="weaver.submit()">
		 	<option value="bytask" ><%=SystemEnv.getHtmlLabelNames("83917",user.getLanguage())%></option>
		 	<option value="byhrm" <%="byhrm".equals(taskgroup)?"selected":"" %>><%=SystemEnv.getHtmlLabelNames("83918",user.getLanguage())%></option>
		</select>
	</span>
	<span class="rowspan2"><input type="button" value="<%=SystemEnv.getHtmlLabelNames("18820",user.getLanguage())%>" class="e8_btn_top"  onclick="onShowGantt()"/></span>
</div>

		
		</wea:item>
		
		
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
		
<div class="e8_box" style="background-color:#F8F8F8!important;" id="basicset" >
    <ul class="tab_menu" style="background:#F8F8F8;margin-left:10px!important;">
        <li class="<%="".equals(version)?"current":"" %>" version='' onclick="getVersion(this)">
        <a href='#' onclick="return false;"><%=SystemEnv.getHtmlLabelNames("524",user.getLanguage())%></a></li>
        <%
        //版本历史
        while(RecordSet3.next()){
        	String v=Util.null2String( RecordSet3.getString("version"));
        	%>
        <li class="<%=v.equals(version)?"current":"" %>" version='<%=v %>' onclick="<%=v.equals(version)?"":"getVersion(this)" %>">
        	<a href='#' onclick="return false;">V<%=v %></a>
        </li>	
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


<%
String popedomOtherpara="";

//操作列参数
JSONObject operatorInfo=new JSONObject();
operatorInfo.put("userid", user.getUID());
operatorInfo.put("usertype", user.getLogintype());
operatorInfo.put("languageid", user.getLanguage());
operatorInfo.put("operatortype", "prj_prjcardtasklist");//操作项类型
operatorInfo.put("operator_num", 8);//操作项数量
operatorInfo.put("operator_val", popedomOtherpara);



int perpage=16;                                 
String backfields = " t1.parentids,t1.hrmid,t1.id,t1.subject,t1.prjid,t1.begindate,t1.enddate,t1.begintime,t1.endtime,t1.actualbegintime,t1.actualendtime,t1.actualbegindate,t1.actualenddate,t1.finish,t1.islandmark,t1.workday,t1.realManDays,t1.status,t1.level_n ";
String fromSql  = " Prj_TaskProcess t1 ";
String orderby ="  t1.taskindex,t1.parentids ";
if("byhrm".equalsIgnoreCase(taskgroup)){
	orderby=" t1.parentids,t1.hrmid ";
}

if(!"".equals(version)){
	fromSql=" Prj_TaskInfo t1 ";
	sqlwhere+=" and t1.version='"+version+"' ";
}

//out.println("sql:==\n"+" select "+backfields+" from "+fromSql+" "+sqlwhere+" order by "+orderby+" desc ");

int totalCount=0;
String sqlV="select count(t1.id) as totalcount from "+fromSql+" "+sqlwhere;
RecordSetV.executeSql(sqlV);
if(RecordSetV.next()){
	totalCount=RecordSetV.getInt(1);
}

String tableString=""+
        "<table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\"  tabletype=\"none\" firstAddRow=\""+(totalCount>0)+"\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"prj")+"\"  >"+
        //" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjTask' />"+
        "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlprimarykey=\"t1.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
        "<head>"+                             
              "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(1352,user.getLanguage())+"\" column=\"id\" orderkey=\"subject\" otherpara=\"column:status+"+user.getLanguage()+"+"+level+"+"+version+"\"  transmethod='weaver.proj.util.ProjectTransUtil.getPrjTaskNameByLevel' target='_fullwindow' />"+
              "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15285,user.getLanguage())+"\" column=\"hrmid\" orderkey=\"hrmid\" transmethod='weaver.cpt.util.CommonTransUtil.getHrmNamesWithCard' />"+
              "<col width=\"13%\"  text=\""+SystemEnv.getHtmlLabelName(1298,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(84364,user.getLanguage())+")\" column=\"workday\" orderkey=\"workday\" otherpara='column:realManDays' transmethod='weaver.proj.util.ProjectTransUtil.getPrjTask2Days' />"+
              "<col width=\"26%\"  text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(84364,user.getLanguage())+")\" column=\"begindate\" orderkey=\"begindate\" otherpara='column:begintime+column:actualbegindate+column:actualbegintime+\"\"' transmethod='weaver.proj.util.ProjectTransUtil.getPrjTask2Date' />"+
              "<col width=\"26%\"  text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(84364,user.getLanguage())+")\" column=\"enddate\" orderkey=\"enddate\" otherpara='column:endtime+column:actualenddate+column:actualendtime+\"\"' transmethod='weaver.proj.util.ProjectTransUtil.getPrjTask2Date' />"+
              "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(847,user.getLanguage())+"\" column=\"finish\" orderkey=\"finish\" otherpara='column:enddate' showaspercent=\"true\" transmethod='weaver.proj.util.ProjectTransUtil.getPrjTaskProgressbar' />"+                             
        "</head>";
if("".equals(version)){
        tableString+=      
        "<operates width=\"5%\">"+
         "   <popedom column='id' otherpara='"+operatorInfo.toString() +"' transmethod='weaver.proj.util.ProjectTransUtil.getOperates'  ></popedom>"+
        "    <operate href=\"javascript:onAddSubTask()\" text=\""+SystemEnv.getHtmlLabelNames("83902",user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
        "    <operate href=\"javascript:onNewCowork()\" text=\""+SystemEnv.getHtmlLabelName(18034,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
        "    <operate href=\"javascript:onNewWorkplan()\" text=\""+SystemEnv.getHtmlLabelName(18481,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
        "    <operate href=\"javascript:onEditTask()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"+
        "    <operate href=\"javascript:onDel()\" text=\""+SystemEnv.getHtmlLabelName( 91 ,user.getLanguage())+"\" target=\"_self\" index=\"4\"/>"+
        "    <operate href=\"javascript:onShare()\" text=\""+SystemEnv.getHtmlLabelName(2112,user.getLanguage())+"\" target=\"_self\" index=\"5\"/>"+
        "    <operate href=\"javascript:onDiscuss()\" text=\""+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+"\" target=\"_self\" index=\"6\"/>"+
        "</operates>";
}
        
        tableString+=
        "</table>"; 
%>
<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />

<%

String passnoworktime1 ="";
int manager1 =-1;
rs2.executeSql("select * from Prj_ProjectInfo where id ="+ProjID);
rs2.next();
passnoworktime1=rs2.getString("passnoworktime");
manager1 = Util.getIntValue(rs2.getString("manager"));

rs2.executeSql("update Prj_TaskProcess set begindate = null  where ltrim(begindate) = '' or ltrim(begindate) is null ");
rs2.executeSql("update Prj_TaskProcess set enddate = null  where ltrim(enddate) = '' or ltrim(enddate) is null ");
rs2.executeSql("update Prj_TaskProcess set begintime = null  where ltrim(begintime) = '' or ltrim(begintime) is null ");
rs2.executeSql("update Prj_TaskProcess set endtime = null  where ltrim(endtime) = '' or ltrim(endtime) is null ");
rs2.executeSql("update Prj_TaskProcess set actualBeginDate = null  where ltrim(actualBeginDate) = '' or ltrim(actualBeginDate) is null ");
rs2.executeSql("update Prj_TaskProcess set actualEndDate = null  where ltrim(actualEndDate) = '' or ltrim(actualEndDate) is null ");
rs2.executeSql("update Prj_TaskProcess set actualbegintime = null  where ltrim(actualbegintime) = '' or ltrim(actualbegintime) is null ");
rs2.executeSql("update Prj_TaskProcess set actualendtime = null  where ltrim(actualendtime) = '' or ltrim(actualendtime) is null ");

rs2.executeSql("update Prj_TaskInfo set begindate = null  where ltrim(begindate) = '' or ltrim(begindate) is null ");
rs2.executeSql("update Prj_TaskInfo set enddate = null  where ltrim(enddate) = '' or ltrim(enddate) is null ");
rs2.executeSql("update Prj_TaskInfo set begintime = null  where ltrim(begintime) = '' or ltrim(begintime) is null ");
rs2.executeSql("update Prj_TaskInfo set endtime = null  where ltrim(endtime) = '' or ltrim(endtime) is null ");
rs2.executeSql("update Prj_TaskInfo set actualBeginDate = null  where ltrim(actualBeginDate) = '' or ltrim(actualBeginDate) is null ");
rs2.executeSql("update Prj_TaskInfo set actualEndDate = null  where ltrim(actualEndDate) = '' or ltrim(actualEndDate) is null ");
rs2.executeSql("update Prj_TaskInfo set actualbegintime = null  where ltrim(actualbegintime) = '' or ltrim(actualbegintime) is null ");
rs2.executeSql("update Prj_TaskInfo set actualendtime = null  where ltrim(actualendtime) = '' or ltrim(actualendtime) is null ");

//全部行
if(!"".equals(version)){
	RecordSet2.executeProc("Prj_TaskInfo_Sum",ProjID+flag+version);
	
}else{
	RecordSet2.executeProc("Prj_TaskProcess_Sum",ProjID);
}
RecordSet2.next();
//计算总工时
String totalbegindate = RecordSet2.getString("begindate");
String totalbegintime = "";
String totalenddate = RecordSet2.getString("endDate");
String totalendtime = "";
String totalactualbegindate = RecordSet2.getString("actualBeginDate");
String totalactualbegintime = "";
String totalactualenddate = RecordSet2.getString("actualEndDate");
String totalactualendtime = "";
String totalworkday = "";
String totalworkday1 = "";
String totalworkday2 = "";
Map<String,String> result = PrjTimeAndWorkdayUtil.getTimeNotWorkdayForProj(totalbegindate,totalenddate,totalactualbegindate,totalactualenddate,ProjID,version);
//Map<String,String> result = new HashMap<String,String>();
totalbegintime = result.get("totalbegintime");
totalendtime = result.get("totalendtime");
totalactualbegintime = result.get("totalactualbegintime");
totalactualendtime = result.get("totalactualendtime");
String showtotalb = ProjectTransUtil.getPrjTask2Date(totalbegindate, totalbegintime+"+"+totalactualbegindate+" + "+totalactualbegintime+" + ");
String showtotale = ProjectTransUtil.getPrjTask2Date(totalenddate, totalendtime+"+"+totalactualenddate+" + "+totalactualendtime+" + ") ;
String showworkd = KnowledgeTransMethod.getPercent(prjfinish, ProjectTransUtil.getPrjTaskProgressbar(prjfinish , ("".equals(totalenddate)?"1970-01-01":totalenddate) ));
//totalworkday1 = result.get("totalworkday1");
//totalworkday2 = result.get("totalworkday2");
//totalworkday = totalworkday1+"/"+totalworkday2;
%>
<TABLE style="display:none;" cellspacing=0  id="mytbl">
    <TR CLASS=DataLight id="total_tr" style="margin-left:50px!important;">
      <td><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></td>
	  <td nowrap>&nbsp;</td>
	  <td nowrap><%=totalworkday%></td>
	 <%-- 
	  <td nowrap><%if(!RecordSet2.getString("actualBeginDate").equals("x")){%><%=RecordSet2.getString("actualBeginDate")%><%}%></td>
	  <td nowrap><%if(!RecordSet2.getString("actualEndDate").equals("-")){%><%=RecordSet2.getString("actualEndDate")%>		  <%}%></td> 
	  --%>
	 <td nowrap><%=showtotalb%></td>
	  <td nowrap><%=showtotale%></td>
	  <td nowrap><%=showworkd %></td>
	  <td>&nbsp;</td>
    </TR>
</TABLE>	    

<script language=javascript >

function submitPic(){
    weaver.action="ViewProcessByPic.jsp";
    weaver.submit();
}

function submitPlan(wfid){
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

<script type="text/javascript">
function onShowGantt(){
	weaver.action="/proj/process/ViewProcessByPic.jsp?ProjID=<%=ProjID %>";
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
function onAddSubTask(id){
	if(id){
		var url="/proj/process/AddTask.jsp?ProjID=<%=ProjID %>&parentid="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("83924",user.getLanguage())%>";
		openDialog(url,title,800,550,true);
	}
}

function onNewCowork(id){
	if(id){
		var hiddenpara_span=$("#"+"hiddenpara_"+id);
		var begindate="";
		var enddate="";
		var prjid="";
		if(hiddenpara_span){
			begindate=hiddenpara_span.attr("begindate");
			enddate=hiddenpara_span.attr("enddate");
			prjid=hiddenpara_span.attr("prjid");
		}
		var url="/cowork/AddCoWork.jsp?taskrecordid="+id+"&begindate="+begindate+"&enddate="+enddate+"&projectid="+prjid+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("18034",user.getLanguage())%>";
		openDialog(url,title,1000,720);
	}
}
function onNewWorkplan(id){
	if(id){
		var hiddenpara_span=$("#"+"hiddenpara_"+id);
		var begindate="";
		var enddate="";
		var prjid="";
		if(hiddenpara_span){
			begindate=hiddenpara_span.attr("begindate");
			enddate=hiddenpara_span.attr("enddate");
			prjid=hiddenpara_span.attr("prjid");
		}
		var url="/workplan/data/WorkPlanAdd.jsp?taskrecordid="+id+"&begindate="+begindate+"&enddate="+enddate+"&projectid="+prjid+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("18481",user.getLanguage())%>";
		openDialog(url,title,1000,720);
	}
}
function onEditTask(id){
	if(id){
		var hiddenpara_span=$("#"+"hiddenpara_"+id);
		var begindate="";
		var enddate="";
		var prjid="";
		if(hiddenpara_span){
			begindate=hiddenpara_span.attr("begindate");
			enddate=hiddenpara_span.attr("enddate");
			prjid=hiddenpara_span.attr("prjid");
		}
		var url="/proj/process/EditTask.jsp?taskrecordid="+id+"&ProjID="+prjid+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("15284",user.getLanguage())%>";
		openDialog(url,title,1000,720,true);
	}
}

function onDel(id){
	if(id){
		var hiddenpara_span=$("#"+"hiddenpara_"+id);
		var begindate="";
		var enddate="";
		var prjid="";
		if(hiddenpara_span){
			begindate=hiddenpara_span.attr("begindate");
			enddate=hiddenpara_span.attr("enddate");
			prjid=hiddenpara_span.attr("prjid");
		}
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83925",user.getLanguage())%>',function(){
			jQuery.post(
				"/proj/process/TaskOperation.jsp",
				{"method":"del","taskrecordid":id,"ProjID":prjid},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
						//_table.reLoad();
						reloadPage();
					});
				}
			);
			
		});
	}
}
function reloadPage(){
	//window.location.href=window.location.href;
	window.location.reload();
}

function onShare(id){
	if(id){
		//var url="/proj/task/PrjTaskAddShare.jsp?isdialog=1&taskrecordid="+id;
		var url="/proj/task/PrjTaskShareDsp.jsp?isdialog=1&capitalid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83799",user.getLanguage())%>";
		openDialog(url,title,680,500,false,true);
	}
}
function onDiscuss(id){
	if(id){
		var url="/proj/process/ViewPrjDiscuss.jsp?types=PT&isdialog=1&sortid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83800",user.getLanguage())%>";
		openDialog(url,title,800,550,true,true);
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
		var url="/proj/process/ViewTaskVersion.jsp?ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("18552",user.getLanguage())%>";
		openDialog(url,title,800,550,true,true);
	}
}
function onRequest(id){
	if(id){
		var url="/proj/process/DspRequest.jsp?ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("1044",user.getLanguage())%>";
		openDialog(url,title,1000,720,true,true);
	}
}
function onDoc(id){
	if(id){
		var url="/proj/process/DspDoc.jsp?ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("857",user.getLanguage())%>";
		openDialog(url,title,1000,720,true,true);
	}
}
function onCowork(id){
	if(id){
		var url="/proj/process/DspCowork.jsp?ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("83911",user.getLanguage())%>";
		openDialog(url,title,1000,720,true,true);
	}
}
function noticeMember(id){
	if(id){
		var url="/proj/process/ProjNotice.jsp?ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("1348",user.getLanguage())%>";
		openDialog(url,title,600,400,true);
	}
}


function saveasplan(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83928",user.getLanguage())%>',function(){
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
		});
	}
}

//列表数据刷新后触发
function afterDoWhenLoaded(){
	var totalCount='<%=totalCount %>';
	if(totalCount>0){
		var totaltr= $("#mytbl").find("tr").first();
		var firsttr=$("table.ListStyle").first().find("tbody").first().find("tr").first();
		firsttr.css({"background-color":"#e9f3fb!important;"});
		firsttr.find("td").eq(1).html("<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>")
		.next().html("")
		.next().html("<IMG src='/images/loading2_wev8.gif'>")
		.next().html("<%=showtotalb%>")
		.next().html("<%=showtotale%>")
		.next().html("<%=showworkd %>")
		;
		//异步获得总工期
		var URL = "/proj/process/GetAllWorkDays.jsp?ProjID=<%=ProjID%>&version=<%=version%>"+
		"&totalbegindate=<%=totalbegindate%>&totalenddate=<%=totalenddate%>"+
		"&totalactualbegindate=<%=totalactualbegindate%>&totalactualenddate=<%=totalactualenddate%>&time="+new Date();
	    jQuery.ajax({
        url: URL,
        type: "post",
        async: true,
        success: function(data){
	    	returnValue = jQuery.trim(data);
           	firsttr.find("td").eq(1).next().next().html(returnValue);
        	}
	    });
	}
	//initProgressbar();
}
function initProgressbar(){
	$(".progressbar").each(function(i){
		var rate=parseInt($(this).attr("rate"));
		var status=parseInt($(this).attr("status"));
		$(this).find("div.progress-label").text(rate+"%");
		$(this).progressbar({value:rate});
		if(status===1){//overtime task
			$(this).find( ".ui-progressbar-value" ).css({'background':'#F9A9AA'});
		}
		
	});
}

function toggleSubtask(obj){
	if(obj){
		var taskid= $(obj).attr("taskid");
		var parentids=$(obj).attr("parentids");
		var img=$(obj).find("img").first();
		var curtb=$(obj).parents("table.ListStyle").first();
		if(img.attr("src")=="/images/project_rank1_wev8.gif"){//折叠
			img.attr("src","/images/project_rank2_wev8.gif");
			$(obj).parents("tr").first().nextAll("tr:has(span[parentids*=',"+taskid+",'])").hide().next("tr").hide();
			
		}else{//展开
			img.attr("src","/images/project_rank1_wev8.gif");
			$(obj).parents("tr").first().nextAll("tr:has(span[parentids*=',"+taskid+",'])").show().next("tr").show();
		}
		
	}
}
function onBtnSearchClick(){
	weaver.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$("#hoverBtnSpan").hoverBtn();
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
