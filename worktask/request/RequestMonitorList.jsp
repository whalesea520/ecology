
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*,weaver.file.*" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<STYLE TYPE="text/css">
/*样式名未定义*/
.btn_RequestSubmitList {BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
} 
</STYLE>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetu" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetd" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="sysPubRefComInfo" class="weaver.general.SysPubRefComInfo" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page"/>
<jsp:useBean id="sptmForWorktask" class="weaver.splitepage.transform.SptmForWorktask" scope="page" />
<jsp:useBean id="BrowserManager" class="weaver.general.browserData.BrowserManager" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%

String CurrentUser = ""+user.getUID();
session.setAttribute("relaterequest", "new");
String currentMonth = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).MONTH)+1);
String currentWeek = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).WEEK_OF_YEAR));
String currentDay = TimeUtil.getCurrentDateString();
String currentQuarter="";
String years = Util.null2String(request.getParameter("years"));
String months = Util.null2String(request.getParameter("months"));
String quarters = Util.null2String(request.getParameter("quarters"));
String weeks = Util.null2String(request.getParameter("weeks"));
String days = Util.null2String(request.getParameter("days"));
String objId = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
String type = Util.null2String(request.getParameter("type")); //周期
String type_d = Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d")); //计划所有者类型
String objName = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objName"));
String operationType = Util.null2String(request.getParameter("operationType"));
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
int worktaskStatus = Util.getIntValue(request.getParameter("worktaskStatus"), 0);
int isfromleft = Util.getIntValue(request.getParameter("isfromleft"), 0);
//按计划 名称
String taskname = Util.null2String(request.getParameter("taskname"));



int orderType = 0;
String orderFieldName = "";
int orderFieldid = 0;
String srcType = "";
String sqlWhere = "";

FileUpload fu = new FileUpload(request);
if(fu != null){
	orderType = Util.getIntValue(fu.getParameter("orderType"), 0);
	orderFieldName = Util.null2String(fu.getParameter("orderFieldName"));
	orderFieldid = Util.getIntValue(fu.getParameter("orderFieldid"), 0);
	srcType = Util.null2String(fu.getParameter("srcType"));
	sqlWhere = Util.null2String(fu.getParameter("sqlWhere"));
	operationType = Util.null2String(fu.getParameter("operationType"));
	taskname = Util.null2String(fu.getParameter("taskname"));
	if("search".equals(operationType) || "searchorder".equals(srcType) || "changePage".equals(srcType)){
		years = Util.null2String(fu.getParameter("years"));
	//	System.out.println("this is opyears===>"+years);
		months = Util.null2String(fu.getParameter("months"));
		quarters = Util.null2String(fu.getParameter("quarters"));
		weeks = Util.null2String(fu.getParameter("weeks"));
		days = Util.null2String(fu.getParameter("days"));
		type = Util.null2String(fu.getParameter("type")); //周期
		wtid = Util.getIntValue(fu.getParameter("wtid"), 0);
		worktaskStatus = Util.getIntValue(fu.getParameter("worktaskStatus"), 0);
		isfromleft = Util.getIntValue(fu.getParameter("isfromleft"), 0);
	}
}

//按计划 创建人
String createrid = Util.null2String(fu.getParameter("createrid"));

//按计划 责任人
String liablepersonid = Util.null2String(fu.getParameter("liablepersonid"));


String checkStr = "";

WTSerachManager wtSerachManager = new WTSerachManager(wtid);
wtSerachManager.setLanguageID(user.getLanguage());
wtSerachManager.setType_d(type_d);
wtSerachManager.setObjid(objId);
wtSerachManager.setUserID(user.getUID());
wtSerachManager.setWorktaskStatus(worktaskStatus);
wtSerachManager.setIsfromleft(isfromleft);

if("search".equals(operationType)){
	Hashtable sql_hs = wtSerachManager.getSearchSqlStr(fu);
	sqlWhere = (String)sql_hs.get("sqlWhere");
}
//System.out.println("sqlWhere = " + sqlWhere);

String worktaskName = "";
String worktaskStatusName = "";
Hashtable worktaskName_hs = new Hashtable();
rs1.execute("select * from worktask_base");
while(rs1.next()){
	String id_tmp = Util.null2String(rs1.getString("id"));
	String worktaskName_tmp = Util.null2String(rs1.getString("name"));
	worktaskName_hs.put("worktaskname_"+id_tmp, worktaskName_tmp);
}
if(wtid > 0){
	worktaskName = Util.null2String((String)worktaskName_hs.get("worktaskname_"+wtid));
}
ArrayList wtsdetailCodeList = sysPubRefComInfo.getDetailCodeList("WorkTaskStatus");
ArrayList wtsdetailLabelList = sysPubRefComInfo.getDetailLabelList("WorkTaskStatus");
if(wtsdetailCodeList.contains(""+worktaskStatus)){
	worktaskStatusName = SystemEnv.getHtmlLabelName(Util.getIntValue((String)wtsdetailLabelList.get(wtsdetailCodeList.indexOf(""+worktaskStatus))), user.getLanguage());
}

String planDate="";

String strStatus = "";

if (objId.equals("")) {
	objId=CurrentUser;
	type = "0";
	type_d = "3";
}

if(weeks.equals("")){
	weeks = currentWeek;
}
if(months.equals("")){
	months = currentMonth;
}
if(days.equals("")){
	days = currentDay;
}
if (1<=Integer.parseInt(months)&& Integer.parseInt(months)<=3){
	currentQuarter="1";
}else if (4<=Integer.parseInt(months)&& Integer.parseInt(months)<=6){
	currentQuarter="2";
}else if (7<=Integer.parseInt(months)&& Integer.parseInt(months)<=9){
	currentQuarter="3";
}else if (10<=Integer.parseInt(months)&& Integer.parseInt(months)<=12){
	currentQuarter="4";
}
if (quarters.equals("")){
	quarters = currentQuarter;
}
//System.out.println("type===============>"+type);
if (type.equals("0")){
	planDate = years;
}else if (type.equals("2")){
	planDate=years+months;
}else if (type.equals("1")){
	planDate = years+quarters;
}else if (type.equals("3")){
	planDate = years+weeks;
}else if(type.equals("4")){
	planDate = days;
}

String createPageSql = "";
Hashtable ret_hs_1 = wtSerachManager.getMonitorPageSql();
createPageSql = (String)ret_hs_1.get("createPageSql");
ArrayList idList = (ArrayList)ret_hs_1.get("idList");
ArrayList fieldnameList = (ArrayList)ret_hs_1.get("fieldnameList");
ArrayList crmnameList = (ArrayList)ret_hs_1.get("crmnameList");
ArrayList ismandList = (ArrayList)ret_hs_1.get("ismandList");
ArrayList fieldhtmltypeList = (ArrayList)ret_hs_1.get("fieldhtmltypeList");
ArrayList typeList = (ArrayList)ret_hs_1.get("typeList");
ArrayList iseditList = (ArrayList)ret_hs_1.get("iseditList");
ArrayList defaultvalueList = (ArrayList)ret_hs_1.get("defaultvalueList");
ArrayList defaultvaluecnList = (ArrayList)ret_hs_1.get("defaultvaluecnList");
ArrayList fieldlenList = (ArrayList)ret_hs_1.get("fieldlenList");
ArrayList widthList = (ArrayList)ret_hs_1.get("widthList");
ArrayList needorderList = (ArrayList)ret_hs_1.get("needorderList");
ArrayList descriptionList = (ArrayList)ret_hs_1.get("descriptionList");
int listCount = Util.getIntValue(((String)ret_hs_1.get("listCount")), 0);
if(wtid == 0){//页面上沿计划任务类型选择框，如果选择所有类型，则必须多加一列“任务类型”
	listCount += 1;
}
listCount += 1;//一直显示任务状态


//使用自定义查询时，时间限定无作用
if("search".equals(operationType)){
	sqlWhere = wtSerachManager.getDateSql(type, years, quarters, months, weeks, days);
	createPageSql += sqlWhere;
}else{
	if(("searchorder".equals(srcType) || "changePage".equals(srcType)) && !"".equals(sqlWhere)){
		createPageSql += sqlWhere;
	}else{
		sqlWhere = wtSerachManager.getDateSql(type, years, quarters, months, weeks, days);
		createPageSql += sqlWhere;
	}
}
//System.out.println("createPageSql = " + createPageSql);


if(!taskname.equals("")){
   createPageSql+=" and taskname like '%"+taskname+"%' ";
}
if(!"".equals(createrid)){
	   createPageSql+=" and creater in ("+createrid+")";
}
if(!"".equals(liablepersonid)){
	   createPageSql+=" and liableperson like '%"+liablepersonid+"%' ";
}

String pName1="";
pName1 = years+SystemEnv.getHtmlLabelName(445,user.getLanguage());
if(type.equals("1")){
	 pName1 += quarters+SystemEnv.getHtmlLabelName(17495,user.getLanguage());
}else if(type.equals("2")){
	pName1 += months+SystemEnv.getHtmlLabelName(6076,user.getLanguage());
}else if(type.equals("3")){
	pName1+=weeks+SystemEnv.getHtmlLabelName(1926,user.getLanguage());
}else if(type.equals("4")){
	pName1 = days.substring(0, 4)+SystemEnv.getHtmlLabelName(445,user.getLanguage())+days.substring(5, 7)+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+days.substring(8, 10)+SystemEnv.getHtmlLabelName(390, user.getLanguage());
}
pName1 += (worktaskStatusName + worktaskName);
String pName = objName+pName1;

int perpage = wtSerachManager.getUserDefaultPerpage(false);

//构建显示列
StringBuilder sbBackfields=new StringBuilder();
StringBuilder sbColumns=new StringBuilder();

sbBackfields.append("taskname,name,detailName,creater,status as tstatus,taskid,planenddate,liableperson,");
sbColumns.append("<col width=\"25%\"     text=\""+SystemEnv.getHtmlLabelName(82755,user.getLanguage())+"\" column=\"taskname\" "+" />");
sbColumns.append("<col width=\"10%\"  transmethod=\"weaver.worktask.worktask.WTTransmethods.getMonitorUserName\"     text=\""+SystemEnv.getHtmlLabelName(16936,user.getLanguage())+"\" column=\"liableperson\" "+" />");
sbColumns.append("<col width=\"15%\"     text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"planenddate\" "+" />");
sbColumns.append("<col width=\"10%\"  transmethod=\"weaver.worktask.worktask.WTTransmethods.getMonitorUserName\"     text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" "+" />");


for(int i=0;i<fieldnameList.size();i++){
	//System.out.println();
	//sbBackfields.append(fieldnameList.get(i)).append(",");
	//sbColumns.append("<col width=\"20%\" otherpara=\""+Util.null2String((String)fieldhtmltypeList.get(i))+"+"+Util.null2String((String)typeList.get(i))+"+"+Util.null2String((String)idList.get(i))+"\"  transmethod=\"weaver.worktask.worktask.WTTransmethods.getInfo\"  text=\""+ descriptionList.get(i) +"\" column=\""+fieldnameList.get(i)+"\" "+
			//" />");
}

sbColumns.append("<col width=\"20%\"    text=\""+SystemEnv.getHtmlLabelName(22256,user.getLanguage())+"\" column=\"name\" "+
" />");
sbColumns.append("<col width=\"10%\"     text=\""+SystemEnv.getHtmlLabelName(81513,user.getLanguage())+"\" column=\"detailName\" "+
" />");

%>
<%
int pagesize=10;
String backFields = "requestid,"+sbBackfields.substring(0,sbBackfields.length()-1);
String sqlFrom = Util.toHtmlForSplitPage("(select *  from ("+createPageSql+")a inner join (select id,name  from worktask_base) b on a.taskid=b.id inner join (select detailName,detailCode from SysPubRef where flag=1 and masterCode='WorkTaskStatus')c on a.status=c.detailCode)b ");



String tableSqlWhere = " ";
String orderby = " ";

//System.out.println("(select *  from ("+createPageSql+")a inner join (select id,name  from worktask_base) b on a.taskid=b.id inner join (select detailName,detailCode from SysPubRef where flag=1 and masterCode='WorkTaskStatus')c on a.status=c.detailCode)b ");

String operateString= "<operates width=\"15%\">";
		operateString+=" <popedom transmethod=\"weaver.worktask.worktask.WTTransmethods.getMonitorTaskOpMenu\" otherpara=\"column:tstatus+column:tcreater+"+user.getUID()+"\"></popedom> ";
		operateString+="     <operate   href=\"javascript:doView();\" otherpara=\"column:tstatus+column:taskid+"+"\"  text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\"   index=\"0\"/>";
		operateString+="     <operate   href=\"javascript:OnCancelOne();\"  text=\""+SystemEnv.getHtmlLabelName(201,user.getLanguage())+"\"   index=\"1\"/>";
		operateString+="     <operate   href=\"javascript:OnDelOne();\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"   index=\"2\"/>";
		operateString+="</operates>";

String tableString =" <table  sqlisdistinct=\"true\" tabletype=\"checkbox\" instanceid=\"readinfo\"  pagesize=\""+pagesize+"\" >"+ 
                 "<browser returncolumn=\"taskid\"/>"+
          //      "<checkboxpopedom value='10' id='10'  showmethod=\"weaver.worktask.worktask.WTTransmethods.getWorkflowTaskCanDel\"  popedompara=\"column:tstatus+column:tcreater+"+user.getUID()+"\" />"+
                "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(tableSqlWhere)+"\"    sqlprimarykey=\"requestid\" sqlsortway=\"Desc\"/>"+
                "<head>"+sbColumns.toString()+
				"</head>"+ operateString + 			
				"</table>";

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style>
   #meizzDateLayer2{
    z-index:1000000 !important;
   }
   .bwraper{
    display:inline-block;vertical-align: middle;width:60%;
   }
</style>
<script type="text/javascript">
//按计划内容搜索
function onBtnSearchClick(value){

	 $(document).find("input[name='taskname']").val(value);
	 $("form[name='taskform']").submit();

}
jQuery(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
</script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:hand;text-align:left;padding:0 2px 0 2px;color:#333}
.cycleTD{font-family:MS Shell Dlg,Arial;background-image:url(/images/tab2_wev8.png);cursor:hand;font-weight:bold;text-align:center;color:#666;border-bottom:1px solid #879293;}
.cycleTDCurrent{font-family:MS Shell Dlg,Arial;padding-top:2px;background-image:url(/images/tab.active2_wev8.png);cursor:hand;font-weight:bold;text-align:center;color:#666}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
</style>
</HEAD>
<%
String needfav ="1";
String needhelp ="";
String titlename = pName;
String imagefilename = "/images/hdHRM_wev8.gif";
%>

<BODY id="worktaskBody">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javaScript:OnDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201, user.getLanguage())+",javaScript:OnCancel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>	

<form name="taskform" method="post" action="RequestMonitorList.jsp" enctype="multipart/form-data">
<input type="hidden" name="wtid" value="<%=wtid%>">
<input type="hidden" name="worktaskStatus" value="<%=worktaskStatus%>">
<input type="hidden" name="type" value=<%=type%>>
<input type="hidden" name="operationType">
<input type="hidden" name="planId">
<input type="hidden" name="taskname">
<input type="hidden" name="importType" value="0" >
<input type="hidden" name="planDate" value=<%=planDate%>>
<input type="hidden" name="pName1" value=<%=pName1%>>
<input type="hidden" name="ishidden" value="1" >
<input type="hidden" name="years" value="<%=years%>">
<input type="hidden" name="months" value="<%=months%>">
<input type="hidden" name="quarters" value="<%=quarters%>">
<input type="hidden" name="weeks" value="<%=weeks%>">
<input type="hidden" name="days" value="<%=days%>">
<input type="hidden" id="isCreate" name="isCreate" value="0">
<input type="hidden" id="nodesnum" name="nodesnum" value="1">
<input type="hidden" id="indexnum" name="indexnum" value="1">
<input type="hidden" id="needcheck" name="needcheck" value="wtid" >
<input type="hidden" id="editids" name="editids" value="">
<input type="hidden" id="isfromleft" name="isfromleft" value="<%=isfromleft%>">
<input type="hidden" id="functionPage" name="functionPage" value="RequestMonitorList.jsp" >
<input type="hidden" id="orderType" name="orderType" value="">
<input type="hidden" id="orderFieldName" name="orderFieldName" value="">
<input type="hidden" id="orderFieldid" name="orderFieldid" value="">
<input type="hidden" id="srcType" name="srcType" value="">
<input type="hidden" id="sqlWhere" name="sqlWhere" value="<%=xssUtil.put(sqlWhere)%>">
  <wea:layout attributes="{layoutTableId:topTitle}">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">

					<input class="e8_btn_top"	onclick="OnCancel()" type="button"  value="<%=SystemEnv.getHtmlLabelName(20839,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>"/>
			
					<input class="e8_btn_top" onclick="OnDel()" type="button"  value="<%=SystemEnv.getHtmlLabelName(20839,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"/>

					<input class="e8_btn_top" style="display:none" onclick="showMonitorLog()" type="button"  value="<%=SystemEnv.getHtmlLabelName(24622,user.getLanguage()) %>"/>
		
					<input type="text" class="searchInput"  id="searchname" name="searchname" value="" />
		
					<span id="advancedSearch" class="advancedSearch "><%=SystemEnv.getHtmlLabelName(347,user.getLanguage()) %></span>
			
			     	<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>

			</wea:item>
		</wea:group>
	 </wea:layout>

 <div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >	

				<input type="hidden" name="destination" value="no">
				<input type="hidden" name="searchtype" value="advanced">
				<input type="hidden" name="actionKey" value="common"> 
				<input name="FirstNameDesc" type="hidden" value="2">
				<input name="LastNameDesc" type="hidden" value="2">
				
				<wea:layout type="4Col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
						
						<wea:item ><%=SystemEnv.getHtmlLabelName(16936, user.getLanguage())%></wea:item>
				    	<wea:item >
						   
					   	   <span id="liablepersonidselspan">
			                   <brow:browser viewType="0" name="liablepersonid" browserValue='<%= liablepersonid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectids=&resourceid=" hasInput="true"  width="60%" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(liablepersonid),user.getLanguage())%>'> 
							   </brow:browser> 
			
			                </span>
				    	</wea:item>		
						     
				        <wea:item ><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
				    	<wea:item >
					   	   <span id="createridselspan">
			                   <brow:browser viewType="0" name="createrid" browserValue='<%= createrid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectids=&resourceid=" hasInput="true"  width="60%" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%>'> 
							   </brow:browser> 
			                </span>
				    	</wea:item>			
					</wea:group>
						
					<wea:group context="" attributes="{'display':'none'}">
						<wea:item type="toolbar">
							<input type="button" onclick='onSearch();' class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" id="searchBtn"/>
							<span class="e8_sep_line">|</span>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>			
	 </div>

  </form>
   <wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="true" />
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
	<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
<script>
 //切换美化checkbox是否选中
function changeCheckboxStatus4tzCheckBox(obj, checked) {
	//jQuery(obj).attr("checked", checked);
	if (obj.checked) {
		jQuery(obj).next("span.tzCheckBox").addClass("checked");
		jQuery(obj).next("span.jNiceCheckbox").addClass("jNiceChecked");
	} else {
		jQuery(obj).next("span.tzCheckBox").removeClass("checked");
		jQuery(obj).next("span.jNiceCheckbox").removeClass("jNiceChecked");
	}
}


function changelevel(tmpindex){
	//document.taskform.check_con(tmpindex*1).checked = true;
	document.all("check_con")[tmpindex*1].checked = true;
	var item=document.getElementsByName("check_con")[tmpindex*1-1];
	item.checked = true;
	changeCheckboxStatus4tzCheckBox(item, item.checked);
}

function getajaxurl(type) {
var tmpval = type;
var url = "";	
if (tmpval == "0") {
	url = "/data.jsp";
}else {
	url = "/data.jsp?type="+type;
}	
return url;
}
   

function browseTable_onmouseover(){
	var e = window.event.srcElement;
	while(e.tagName != "TR"){
		e = e.parentElement;
	}
	e.className = "Selected";
}
function browseTable_onmouseout(){
	var e = window.event.srcElement;
	while(e.tagName != "TR"){
		e = e.parentElement;
	}
	if(e.rowIndex%2==0){
		e.className = "DataDark";
	}else{
		e.className = "DataLight";
	}
}
function onChooseAll(obj){
	var check = obj.checked;
	var chks = document.getElementsByName("taskcheck");
	try{
		for(var i=0; i<chks.length; i++){
			chks[i].checked = check;
		}
	}catch(e){}
	var chks2 = document.getElementsByName("checktask2");
	try{
		for(var i=0; i<chks2.length; i++){
			chks2[i].checked = check;
		}
	}catch(e){}
}
function changeDays(objspan, objinput){
	WdatePicker_changeDays(objspan, objinput);
}

function onShowadvanceQuery(obj){
	var check = obj.checked;
	if(check == false){
		document.all("showadvanceQuery").style.display = "none";
	}else{
		document.all("showadvanceQuery").style.display = "";
	}
}
function showorhiddenprop(obj){
	var ishidden = document.taskform.ishidden.value;
	if(ishidden == "1"){
		document.taskform.ishidden.value = "0";
		document.all("showhidden").innerHTML = "<%=SystemEnv.getHtmlLabelName(21992, user.getLanguage())%>";
		document.all("showquery").style.display = "";
	}else{
		document.taskform.ishidden.value = "1";
		document.all("showhidden").innerHTML = "<%=SystemEnv.getHtmlLabelName(21991, user.getLanguage())%>";
		document.all("showquery").style.display = "none";
		document.all("check_showadvanceQuery").checked = false;
		onShowadvanceQuery(document.all("check_showadvanceQuery"));
	}
}
function onSearch(){
	document.taskform.operationType.value="search";
	document.taskform.submit();
	enableAllmenu();
}
function checkChoose(){
	var flag = false;
	var ary = eval("document.taskform.checktask2");
	try{
		if(ary.length==null){
			if(ary.checked == true){
				flag = true;
				return flag;
			}
		}else{
			for(var i=0; i<ary.length; i++){
				if(ary[i].checked == true){
					flag = true;
					return flag;
				}
			}
		}
	}catch(e){
		return flag;
	}
	return flag;
}

//删除一条记录
function OnDelOne(id){
    
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage()) %>?',function(){
  	     
		   $("form[name='taskform']").prepend("<input type='hidden'  name='checktask2' value='"+id+"'>"); 
			document.taskform.action = "RequestOperation.jsp";
			document.taskform.operationType.value="multidelete";
			document.taskform.submit();
			enableAllmenu();
	});

}


//处理取消,删除操作
function handOp(option){
     var reqidstr=_xtable_CheckedCheckboxIdForCP();
	 if(reqidstr===''){
		 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000, user.getLanguage())%>");
		  return;
	 }
	 var msg="";
	 if(option==='multidelete')
		  msg='<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>';
	 else if(option==='multiCancel')
           msg='<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>';
	 window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(28296,user.getLanguage()) %>'+msg+'?',function(){
	    
		var reqids=_xtable_CheckedCheckboxIdForCP().split(",");
		var hiddenarray=[];
		for(var i=0;i<reqids.length-1;i++){
			  hiddenarray.push("<input type='hidden'  name='checktask2' value='"+reqids[i]+"'>");		
		}
		//添加隐藏域
		$("form[name='taskform']").prepend(hiddenarray.join("")); 
		document.taskform.action = "RequestOperation.jsp";
		document.taskform.operationType.value=option;
		document.taskform.submit();
		enableAllmenu();	 
	 
	 });
	

}
//监控日志
function showMonitorLog(){
	    // openFullWindowHaveBar("/worktask/request/MonitorLogList.jsp");
	    var dlg=new window.top.Dialog();//定义Dialog对象
		// dialog.currentWindow = window;
	　　dlg.Model=false;
	　　dlg.Width=1000;//定义长度
	　　dlg.Height=550;
	　　dlg.URL="/worktask/request/MonitorLogList.jsp";
	　　dlg.Title='<%=SystemEnv.getHtmlLabelName(24622, user.getLanguage())%>';
		dlg.maxiumnable=false;
	　　dlg.show();
}

function OnDel(){
	handOp("multidelete");
}

//取消一条记录
function OnCancelOne(id){
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("28296,201",user.getLanguage()) %>?',function(){
  	     
		   $("form[name='taskform']").prepend("<input type='hidden'  name='checktask2' value='"+id+"'>"); 
			document.taskform.action = "RequestOperation.jsp";
			document.taskform.operationType.value="multiCancel";
			document.taskform.submit();
			enableAllmenu();
	});
}

function OnCancel(){
	handOp("multiCancel");
}
function iscancel(){
	if(!confirm("<%=SystemEnv.getHtmlLabelName(22059, user.getLanguage())%>")){
		return false;
	}
	return true;
}

function doEdit(){
	try{
		var flag = false;
		var ary = eval("document.taskform.checktask2");
		if(ary.length==null){
			if(ary.checked == true){
				flag = true;
				document.taskform.editids.value = ary.value+",";
			}
		}else{
			for(var i=0; i<ary.length; i++){
				if(ary[i].checked == true){
					flag = true;
					document.taskform.editids.value += (ary[i].value+",");
				}
			}
		}
		//alert(document.taskform.editids.value);
		var editids = document.taskform.editids.value;
		if(flag == true){
			location.href = "RequestEditList.jsp?wtid=<%=wtid%>&worktaskStatus=<%=worktaskStatus%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&weeks=<%=weeks%>&months=<%=months%>&quarters=<%=quarters%>&days=<%=days%>&functionPage=RequestMonitorList.jsp&isfromleft=<%=isfromleft%>&editids="+editids;
			enableAllmenu();
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(22000, user.getLanguage())%>");
		}
	}catch(e){
		alert("<%=SystemEnv.getHtmlLabelName(22000, user.getLanguage())%>");
	}
}
function changeOrder(obj, orderType, fieldname, fieldid){
	document.taskform.srcType.value="searchorder";
	document.getElementById("orderType").value = orderType;
	document.getElementById("orderFieldName").value = fieldname;
	document.getElementById("orderFieldid").value = fieldid;
	document.taskform.submit();
	enableAllmenu();
}


</script>
</HTML>



<script type="text/javascript">
//<!--
function changelevel(tmpindex) {
 	document.getElementsByName("check_con")[tmpindex*1].checked = true;
}

function onShowBrowser2(id,url,type1) {
	var tmpids = null;
	var id1 = null;
    if (type1 == 8) {
	    tmpids = $G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?projectids=" + tmpids);
    } else if ( type1 == 9) {
	  	tmpids = $G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?documentids=" + tmpids);
	} else if ( type1 == 1 ) {
		tmpids = $G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if ( type1 == 4 ) {
		tmpids = $G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if ( type1 == 16 ) {
		tmpids = $G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if( type1 == 7) { 
		tmpids = $G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	}
	//id1 = window.showModalDialog(url)
	
	if (id1 != null && id1 != undefined) {

		var rid = wuiUtil.getJsonValueByIndex(id1, 0);
		var rname = wuiUtil.getJsonValueByIndex(id1, 1);

		if (rid != "") {
			resourceids = rid.substr(1);
			resourcename = rname.substr(1);
			
			$G("con"+id+"_valuespan").innerHTML =resourcename; 
			$G("con"+id+"_value").value = resourceids;
			$G("con"+id+"_name").value = resourcename;
		} else {
			$G("con"+id+"_valuespan").innerHTML = "";
			$G("con"+id+"_value").value = "";
			$G("con"+id+"_name").value = "";
		}
	} 
}

function onShowBrowser(id,url) {
	var id1 = window.showModalDialog(url)
	if (id1 != null) {
	    var rid = wuiUtil.getJsonValueByIndex(id1, 0);
	    var rname = wuiUtil.getJsonValueByIndex(id1, 1);
	    if (rid != "") {
	    	$G("con"+id+"_valuespan").innerHTML = rname;
			$G("con"+id+"_value").value = rid;
			$G("con"+id+"_name").value = rname;
	    } else {
	    	$G("con"+id+"_valuespan").innerHTML = "";
	    	$G("con"+id+"_value").value = "";
	    	$G("con"+id+"_name").value = "";
	    }
	}
}

function onShowBrowser3(id,url,linkurl,type1,ismand){
	if(type1==2||type1 ==19){
	    spanname = "field"+id+"span";
	    inputname = "field"+id;
		if(type1 ==2)
		  onFlownoShowDate(spanname,inputname,ismand);
        else
	      onWorkFlowShowTime(spanname,inputname,ismand);
	}else{
		if(type1!=152 && type1 !=142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170)
		{
			id1 = window.showModalDialog(url);
		}else{
            if(type1==135){
			    tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?projectids="+tmpids)
			}else if(type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
                tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?selectedids="+tmpids);
			}else if(type1==37) {
            tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?documentids="+tmpids);
            }else if (type1==142){
            tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?receiveUnitIds="+tmpids);
            }else if( type1==165 || type1==166 || type1==167 || type1==168){
                //index=InStr(id,"_");
                index=id.indexOf("_");
	            if (index!=-1){
		            //Mid(id,1,index-1)
		            tmpids=uescape("?isdetail=1&fieldid="+substr(id,0,index-1)+"&resourceids="+document.all("field"+id).value)
		            id1 = window.showModalDialog(url+tmpids);
	            }else{
		            tmpids=uescape("?fieldid="+id+"&resourceids="+document.all("field"+id).value);
		            id1 = window.showModalDialog(url+tmpids);
	            }
            }else{
               tmpids = document.all("field"+id).value;
			   id1 = window.showModalDialog(url+"?resourceids="+tmpids);
			}
           }
		
		if(id1){
			if  (type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170) 
			{
				if (id1.id!==""  && id1.id!=="0"){
					resourceids = id1.id;
					resourcename = id1.name;
					sHtml = "";
					resourceidss =resourceids.substr(1);
					resourceids = resourceids.substr(1);

					resourcename =resourcename.substr(1);
					
					ids=resourceids.split(",");
					names=resourcename.split(",");
					for(var i=0;i<ids.length;i++){
					   if(ids[i]!="")
					      sHtml = sHtml+"<a href="+linkurl+ids[i]+" target='_blank'>"+names[i]+"</a>&nbsp";
					}
					//$GetEle("field"+id+"span").innerHTML = sHtml;
					document.all("field"+id+"span").innerHTML = sHtml;
					document.all("field"+id).value= resourceidss;
				}else{
					if (ismand==0)
						document.all("field"+id+"span").innerHTML ="";
					else
						document.all("field"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					document.all("field"+id).value="";
				}
			}else{
			   if  (id1.id!=""  && id1.id!="0"){
                   if (type1==162){
				     ids = id1.id;
					names = id1.name;
					descs = wuiUtil.getJsonValueByIndex(id1,2);
					sHtml = "";
					ids =ids.substr(1);
					document.all("field"+id).value= ids;
					names =names.substr(1).split(",");
					descs =descs.substr(1).split(",");
					for(var i=0;i<names.length;i++){
					   sHtml = sHtml+"<a title='"+descs[i]+"' >"+names[i]+"</a>&nbsp";
					}
					document.all("field"+id+"span").innerHTML = sHtml;
					return;
				   }
				   if (type1==161){
				     name =wuiUtil.getJsonValueByIndex(id1,1);
					 desc = wuiUtil.getJsonValueByIndex(id1,2);
				     document.all("field"+id).value=wuiUtil.getJsonValueByIndex(id1,0);
					 sHtml = "<a title='"+desc+"'>"+name+"</a>&nbsp";
					 document.all("field"+id+"span").innerHTML = sHtml;
					 return;
				   }
			        if (linkurl == "") 
						document.all("field"+id+"span").innerHTML =wuiUtil.getJsonValueByIndex(id1,1);
					else
						document.all("field"+id+"span").innerHTML = "<a href="+linkurl+id1.id+" target='_blank'>"+id1.name+"</a>";
					document.all("field"+id).value=id1.id;

				}else{
					if (ismand==0)
						document.all("field"+id+"span").innerHTML ="";
					else
						document.all("field"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					
					document.all("field"+id).value=""
				}
              }  			
		}
	 }	
}
//-->
 //新建  /worktask/pages/worktask.jsp?wtid=**
//更新  /worktask/pages/worktask.jsp?wtid=**&requestid=**
//其它操作 /worktask/pages/worktaskoperate.jsp?wtid=**&requestid=**
 function doView(wtrequestid,params){
	var param = params.split("+");
	var wtstatus = param[0];
	var wttaskid = param[1];
	
	var taskpage = "";
	if(wtstatus == '1' || wtstatus == '3'){//未提交 被退回
	   taskpage = "/worktask/pages/worktask.jsp?wtid="+wttaskid+"&requestid="+wtrequestid;
	}else if(wtstatus == '5,6,7' || wtstatus > 2){
	   taskpage = "/worktask/pages/worktaskoperate.jsp?wtid="+wttaskid+"&requestid="+wtrequestid;
	}else{
	   taskpage = "/worktask/pages/worktask.jsp?wtid=0";
	}
	
	//全部只能查看
	taskpage = "/worktask/pages/worktaskoperate.jsp?istaskview=1&wtid="+wttaskid+"&requestid="+wtrequestid;

	$("#worktaskdetailpage").attr("src",taskpage);

	 // openFullWindowHaveBar("/worktask/request/MonitorLogList.jsp");
	var dlg=new window.top.Dialog();//定义Dialog对象
	// dialog.currentWindow = window;
　　dlg.Model=false;
　　dlg.Width=644;//定义长度
　　dlg.Height=700;
　　dlg.URL=taskpage;
　　dlg.Title='<%=SystemEnv.getHtmlLabelNames("1332,367",user.getLanguage()) %>';
	dlg.maxiumnable=false;
　　dlg.show();
 }

</script>


<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()></script>
