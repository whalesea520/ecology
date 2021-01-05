
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*,weaver.file.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<STYLE TYPE="text/css">
/*样式名未定义*/
.btn_RequestSubmitList {BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
}
 #meizzDateLayer2{
   z-index:1000000 !important;
 }
 .bwraper{
    display:inline-block;vertical-align: middle;width:60%;
 }
</STYLE>
<script type="text/javascript">
//按计划内容搜索
function onBtnSearchClick(value){

	 $(document).find("input[name='taskcontent']").val(value);
	 $("form[name='taskform']").submit();

}
jQuery(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
</script>

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
<jsp:useBean id="sptmForWorktask" class="weaver.splitepage.transform.SptmForWorktask" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page"/>
<jsp:useBean id="BrowserManager" class="weaver.general.browserData.BrowserManager" scope="page"/>
<%
session.setAttribute("relaterequest", "new");
String CurrentUser = ""+user.getUID();
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

//按计划内容索引
String taskcontent = Util.null2String(request.getParameter("taskcontent"));

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
	taskcontent = Util.null2String(fu.getParameter("taskcontent"));
	operationType = Util.null2String(fu.getParameter("operationType"));
	if("search".equals(operationType) || "searchorder".equals(srcType) || "changePage".equals(srcType)){
		years = Util.null2String(fu.getParameter("years"));
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
Hashtable ret_hs_1 = wtSerachManager.getApprovePageSql();
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
ArrayList<String> descriptionList = (ArrayList<String>)ret_hs_1.get("descriptionList");
int listCount = Util.getIntValue(((String)ret_hs_1.get("listCount")), 0);
if(wtid == 0){//页面上沿计划任务类型选择框，如果选择所有类型，则必须多加一列“任务类型”
	listCount += 1;
}
listCount += 1;//一直显示任务状态

//使用自定义查询时，时间限定无作用
if("search".equals(operationType)){
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

if(!taskcontent.equals("")){
   createPageSql+=" and taskcontent like '%"+taskcontent+"%' ";

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
	String[] tmpdays=days.split("-");
	pName1 = tmpdays[0]+SystemEnv.getHtmlLabelName(445,user.getLanguage())+tmpdays[1]+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+tmpdays[2]+SystemEnv.getHtmlLabelName(390, user.getLanguage());

}
pName1 += (worktaskStatusName + worktaskName);
String pName = objName+pName1;

int perpage = wtSerachManager.getUserDefaultPerpage(false);


//构建显示列
StringBuilder sbBackfields=new StringBuilder();
StringBuilder sbColumns=new StringBuilder();

sbBackfields.append("name,detailName,creater as tcreater,status as tstatus,taskid,approverequest,");

sbColumns.append("<col width=\"20%\"  hide=\"true\"  text=\"\" otherpara=\"column:requestid\" column=\"approverequest\"  transmethod=\"weaver.worktask.worktask.WTTransmethods.getHiddenApproveReq\"  "+
		" />");
sbColumns.append("<col width=\"20%\"    text=\""+SystemEnv.getHtmlLabelName(22256,user.getLanguage())+"\" column=\"name\" "+
		" />");
sbColumns.append("<col width=\"20%\"     text=\""+SystemEnv.getHtmlLabelName(81513,user.getLanguage())+"\" column=\"detailName\" "+
		" />");

for(int i=0;i<fieldnameList.size();i++){
	sbBackfields.append(fieldnameList.get(i)).append(",");
	sbColumns.append("<col width=\"20%\" otherpara=\""+Util.null2String((String)fieldhtmltypeList.get(i))+"+"+Util.null2String((String)typeList.get(i))+"+"+Util.null2String((String)idList.get(i))+"\"  transmethod=\"weaver.worktask.worktask.WTTransmethods.getInfo\"  text=\""+ descriptionList.get(i) +"\" column=\""+fieldnameList.get(i)+"\" "+
			" />");
}

%>

<%
int pagesize=10;
String backFields = "requestid,"+sbBackfields.substring(0,sbBackfields.length()-1);
String sqlFrom = Util.toHtmlForSplitPage("(select *  from ("+createPageSql+")a inner join (select id,name  from worktask_base) b on a.taskid=b.id inner join (select detailName,detailCode from SysPubRef where flag=1 and masterCode='WorkTaskStatus')c on a.status=c.detailCode)b ");

String tableSqlWhere = " ";
String orderby = " ";

String operateString= "<operates width=\"15%\">";
		operateString+=" <popedom transmethod=\"weaver.worktask.worktask.WTTransmethods.getApproveTaskOpMenu\"></popedom> ";
		operateString+="     <operate   href=\"javascript:OnApproveOne();\"  text=\""+SystemEnv.getHtmlLabelName(142,user.getLanguage())+"\"   index=\"0\"/>";
		operateString+="     <operate   href=\"javascript:OnRejectOne();\"  text=\""+SystemEnv.getHtmlLabelName(236,user.getLanguage())+"\"   index=\"1\"/>";
		operateString+="     <operate   href=\"javascript:doView();\"  text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\"   index=\"2\"/>";
		operateString+="     <operate   href=\"javascript:OnCancelOne();\"  text=\""+SystemEnv.getHtmlLabelName(201,user.getLanguage())+"\"   index=\"3\"/>";
		operateString+="</operates>";


String tableString =" <table  sqlisdistinct=\"true\" tabletype=\"checkbox\" instanceid=\"readinfo\"  pagesize=\""+pagesize+"\" >"+ 
                 "<browser returncolumn=\"taskid\"/>"+
              //  "<checkboxpopedom value='10' id='10'  showmethod=\"weaver.worktask.worktask.WTTransmethods.getWorkflowTaskCanDel\"  popedompara=\"column:tstatus+column:tcreater+"+user.getUID()+"\" />"+
                "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(tableSqlWhere)+"\"    sqlprimarykey=\"requestid\" sqlsortway=\"Desc\"/>"+
                "<head>"+sbColumns.toString()+
				"</head>"+ operateString + 			
				"</table>";

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(142, user.getLanguage())+",javaScript:OnApprove(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(236, user.getLanguage())+",javaScript:OnReject(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201, user.getLanguage())+",javaScript:OnCancel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;


%>	

<form name="taskform" method="post" action="RequestApproveList.jsp" enctype="multipart/form-data">
<input type="hidden" name="wtid" value="<%=wtid%>">
<input type="hidden" name="worktaskStatus" value="<%=worktaskStatus%>">
<input type="hidden" name="type" value=<%=type%>>
<input type="hidden" name="operationType">
<input type="hidden" name="planId">
<input type="hidden" name="taskcontent">
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
<input type="hidden" id="editids" name="editids" >
<input type="hidden" id="isfromleft" name="isfromleft" value="<%=isfromleft%>">
<input type="hidden" id="functionPage" name="functionPage" value="RequestApproveList.jsp" >
<input type="hidden" id="orderType" name="orderType" value="">
<input type="hidden" id="orderFieldName" name="orderFieldName" value="">
<input type="hidden" id="orderFieldid" name="orderFieldid" value="">
<input type="hidden" id="srcType" name="srcType" value="">
<input type="hidden" id="sqlWhere" name="sqlWhere" value="<%=xssUtil.put(sqlWhere)%>">

 <wea:layout attributes="{layoutTableId:topTitle}">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">

					<input class="e8_btn_top"	onclick="OnApprove()" type="button"  value="<%=SystemEnv.getHtmlLabelName(142,user.getLanguage()) %>"/>
			
					<input class="e8_btn_top" onclick="OnReject()" type="button"  value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage()) %>"/>

					<input class="e8_btn_top" onclick="OnCancel()" type="button"  value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>"/>

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
						<!-- 类型 -->
						<% 

						String searchOpSql = "select id, fieldname, description, crmname, fieldhtmltype, type, isadvancedquery from worktask_fielddict f left join worktask_taskfield t on f.id=t.fieldid and t.taskid="+wtid+" left join worktask_tasklist l on f.id=l.fieldid and l.taskid="+wtid+" where wttype=1 and l.isquery=1 order by isadvancedquery asc, orderidlist asc, id asc";
						rs1.execute(searchOpSql);
						int languageID=user.getLanguage();
						int count = 0;
						int a_count = 0;
						int tmpcount = 0;
                        while(rs1.next()) {
								String htmltype = Util.null2String(rs1.getString("fieldhtmltype"));
								String stype = Util.null2String(rs1.getString("type"));
								String crmname = Util.null2String(rs1.getString("crmname"));
								String description = Util.null2String(rs1.getString("description"));
								String fieldname = Util.null2String(rs1.getString("fieldname"));
								int id = Util.getIntValue(rs1.getString("id"), 0);
								int isadvancedquery = Util.getIntValue(rs1.getString("isadvancedquery"), 0);
								StringBuffer oneQueryStr = new StringBuffer();
								StringBuffer qStrLable = new StringBuffer();
								qStrLable.append("<input type=\"checkbox\" name=\"check_con\" title=\""+SystemEnv.getHtmlLabelName(20778, user.getLanguage())+"\" value=\""+id+"\">"+description+"");
		                        oneQueryStr.append("<input type=\"hidden\" name=\"con"+id+"_htmltype\" value=\""+htmltype+"\">\n");
								oneQueryStr.append("<input type=\"hidden\" name=\"con"+id+"_type\" value=\""+type+"\">\n");
								oneQueryStr.append("<input type=\"hidden\" name=\"con"+id+"_colname\" value=\""+fieldname+"\">\n");
								if(isadvancedquery == 0){
									tmpcount = count + 1;
									count++;
								}else{
									tmpcount = count + a_count + 1;
									a_count++;
								}
							%>
						   <wea:item>
						        <%=qStrLable.toString()%>
							</wea:item>
							<%
							   if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){		//文本输入框
										oneQueryStr.append("<select class=\"inputstyle\" name=\"con"+id+"_opt\" style=\"width:50%\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
										if(!htmltype.equals("2")){//TD9319 屏蔽掉多行文本框的“等于”和“不等于”操作，text数据库类型不支持该判断
											oneQueryStr.append("<option value=\"1\" >"+SystemEnv.getHtmlLabelName(327, languageID)+"</option>\n");//等于
											oneQueryStr.append("<option value=\"2\" >"+SystemEnv.getHtmlLabelName(15506, languageID)+"</option>\n");//不等于
										}
										oneQueryStr.append("<option value=\"3\" >"+SystemEnv.getHtmlLabelName(346, languageID)+"</option>\n");//包含
										oneQueryStr.append("<option value=\"4\" >"+SystemEnv.getHtmlLabelName(15507, languageID)+"</option>\n");//不包含
										oneQueryStr.append("</select>");
										oneQueryStr.append("<input type=\"text\" class=InputStyle style='vertical-align:middle;width:60%' size=\"12\" name=\"con"+id+"_value\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
									}else if(htmltype.equals("1")&& !type.equals("1")){		//数字输入框	大于,大于或等于,小于,小于或等于,等于,不等于
										oneQueryStr.append("<select class=\"inputstyle\" name=\"con"+id+"_opt\" style=\"width:20%\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
										oneQueryStr.append("<option value=\"1\" >"+SystemEnv.getHtmlLabelName(15508, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"2\" >"+SystemEnv.getHtmlLabelName(325, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"3\" >"+SystemEnv.getHtmlLabelName(15509, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"4\" >"+SystemEnv.getHtmlLabelName(326, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"5\" >"+SystemEnv.getHtmlLabelName(327, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"6\" >"+SystemEnv.getHtmlLabelName(15506, languageID)+"</option>\n");
										oneQueryStr.append("</select>\n");
										oneQueryStr.append("<input type=text class=\"InputStyle\" style='vertical-align:middle;width:60%' size=\"10\" name=\"con"+id+"_value\" onblur=\"checknumber('con"+id+"_value')\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
										oneQueryStr.append("<select class=\"inputstyle\" name=\"con"+id+"_opt1\" style=\"width:20%\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
										oneQueryStr.append("<option value=\"1\" >"+SystemEnv.getHtmlLabelName(15508, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"2\" >"+SystemEnv.getHtmlLabelName(325, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"3\" >"+SystemEnv.getHtmlLabelName(15509, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"4\" >"+SystemEnv.getHtmlLabelName(326, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"5\" >"+SystemEnv.getHtmlLabelName(327, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"6\" >"+SystemEnv.getHtmlLabelName(15506, languageID)+"</option>\n");
										oneQueryStr.append("</select>\n");
										oneQueryStr.append("<input type=\"text\" class=\"InputStyle\" style='vertical-align:middle;width:60%' size=\"10\" name=\"con"+id+"_value1\" onblur=\"checknumber('con"+id+"_value1')\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
									}else if(htmltype.equals("4")){		//check类型
										oneQueryStr.append("<input type=\"checkbox\" value=\"1\" name=\"con"+id+"_value\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
									}else if(htmltype.equals("5")){		//选择框
										oneQueryStr.append("<select class=\"inputstyle\" name=\"con"+id+"_opt\" style=\"width:50%\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
										oneQueryStr.append("<option value=\"1\" >"+SystemEnv.getHtmlLabelName(327, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"2\" >"+SystemEnv.getHtmlLabelName(15506, languageID)+"</option>\n");
										oneQueryStr.append("</select>\n");
										oneQueryStr.append("<select class=\"inputstyle\" name=\"con"+id+"_value\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
										oneQueryStr.append("<option value=\"\" ></option>\n");
										rs2.execute("select * from worktask_selectItem where fieldid="+id+" order by orderid");
										while(rs2.next()){
											String selectvalue = Util.null2String(rs2.getString("selectvalue"));
											String selectname = Util.null2String(rs2.getString("selectname"));
											oneQueryStr.append("<option value=\""+selectvalue+"\" >"+selectname+"</option>\n");
										}
										oneQueryStr.append("</select>\n");
									}else if(htmltype.equals("6")){
										oneQueryStr.append("<select class=\"inputstyle\" name=\"con"+id+"_opt\" style=\"width:50%\"  onfocus=\"changelevel('"+tmpcount+"')\" >\n");
										oneQueryStr.append("<option value=\"1\" >"+SystemEnv.getHtmlLabelName(346, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"2\" >"+SystemEnv.getHtmlLabelName(15507, languageID)+"</option>\n");
										oneQueryStr.append("</select>\n");
										oneQueryStr.append("<button  type='button' class=\"Browser\" onfocus=\"changelevel('"+tmpcount+"')\"  onclick=\"onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1')\"></button>\n");
										oneQueryStr.append("<input type=\"hidden\" name=\"con"+id+"_value\" >\n");
										oneQueryStr.append("<input type=\"hidden\" name=\"con"+id+"_name\" >\n");
										oneQueryStr.append("<span name=\"con"+id+"_valuespan\" id=\"con"+id+"_valuespan\"></span>\n");
									}
                                    if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2") || (htmltype.equals("1")&& !type.equals("1")) || htmltype.equals("4") || htmltype.equals("5") || htmltype.equals("6")){
							  %>
                                           <wea:item>
											   <%=oneQueryStr.toString()%>
										  </wea:item>
                              <%}else if(htmltype.equals("3")){ 
							          //浏览框单人力资源  条件为多人力
									 if(stype.equals("1")){		 
							  %> 
							     <wea:item>
								      <select class=\"inputstyle\" name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >
									  <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
									  <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
									  </select>
                                     <div class='bwraper' >  
									  <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
										browserValue='<%=request.getParameter("con"+id+"_value")%>' 
										browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
										hasInput="true" 
										isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
										hasBrowser = "true" isMustInput='1' 
										completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
										> 
									  </brow:browser>
									  </div>
									  
								 </wea:item>
							  <%
									 } else if(stype.equals("9")){
										
								%>
								     <wea:item>
								          <select class=\"inputstyle\"  name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >
										  <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
										  <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
										  </select>
										   <div class='bwraper' >  
										   <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
											browserValue='<%=request.getParameter("con"+id+"_value")%>' 
											browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
											browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="
											hasInput="true" 
											isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
											hasBrowser = "true" isMustInput='1' 
											completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
											> 
										  </brow:browser>
										  </div>
								   </wea:item>
								<%		
									}else if(stype.equals("4")){
								 %>
								 <wea:item>
								          <select class=\"inputstyle\" name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >
										  <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
										  <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
										  </select>
										  <div class='bwraper' >  
										  <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
											browserValue='<%=request.getParameter("con"+id+"_value")%>' 
											browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
											browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
											hasInput="true" 
											isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
											hasBrowser = "true" isMustInput='1' 
											completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
											> 
										  </brow:browser>
										  </div>
								    </wea:item>
								 <%
							     }else if(stype.equals("7")){
								%>
								<wea:item>
								      <select class=\"inputstyle\" name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >
									  <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
									  <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
									  </select>
									   <div class='bwraper' >  
									  <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
										browserValue='<%=request.getParameter("con"+id+"_value")%>' 
										browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="
										hasInput="true" 
										isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
										hasBrowser = "true" isMustInput='1' 
										completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
										> 
									  </brow:browser>
									  </div>
								  </wea:item>
								<%			
								 }else if(stype.equals("8")){
								%>		
								   <wea:item>
								      <select class=\"inputstyle\"  name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >
									   <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
									  <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
									  </select>
									   <div class='bwraper' >  
									   <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
										browserValue='<%=request.getParameter("con"+id+"_value")%>' 
										browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids="
										hasInput="true" 
										isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
										hasBrowser = "true" isMustInput='1' 
										completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
										> 
									  </brow:browser>
									  </div>
								  </wea:item>
								<%		
								 }else if(stype.equals("16")){
								%>
								   <wea:item>
								       <select class=\"inputstyle\"  name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >
									  <option value="1"><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
									  <option value="2"><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
									  </select>
									   <div class='bwraper' >  
									   <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
										browserValue='<%=request.getParameter("con"+id+"_value")%>' 
										browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="
										hasInput="true" 
										isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
										hasBrowser = "true" isMustInput='1' 
										completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
										> 
									  </brow:browser>
									  </div>
								  </wea:item>
								<%		
								 }else if(stype.equals("24")){
									    oneQueryStr.append("<select class=\"inputstyle\" name=\"con"+id+"_opt\" style=\"width:20%\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
										oneQueryStr.append("<option value=\"1\" >"+SystemEnv.getHtmlLabelName(15508, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"2\" >"+SystemEnv.getHtmlLabelName(325, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"3\" >"+SystemEnv.getHtmlLabelName(15509, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"4\" >"+SystemEnv.getHtmlLabelName(326, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"5\" >"+SystemEnv.getHtmlLabelName(327, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"6\" >"+SystemEnv.getHtmlLabelName(15506, languageID)+"</option>\n");
										oneQueryStr.append("</select>\n");
										oneQueryStr.append("<input type=\"text\" class=\"InputStyle\" style='vertical-align:middle;width:60%' size=\"10\" name=\"con"+id+"_value\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
										oneQueryStr.append("<select class=\"inputstyle\" name=\"con"+id+"_opt1\" style=\"width:20%\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
										oneQueryStr.append("<option value=\"1\" >"+SystemEnv.getHtmlLabelName(15508, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"2\" >"+SystemEnv.getHtmlLabelName(325, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"3\" >"+SystemEnv.getHtmlLabelName(15509, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"4\" >"+SystemEnv.getHtmlLabelName(326, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"5\" >"+SystemEnv.getHtmlLabelName(327, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"6\" >"+SystemEnv.getHtmlLabelName(15506, languageID)+"</option>\n");
										oneQueryStr.append("</select>\n");
										oneQueryStr.append("<input type=\"text\" class=\"InputStyle\" style='vertical-align:middle;width:60%' size=\"10\" name=\"con"+id+"_value1\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");

								%>
								 <wea:item>
								       <%=oneQueryStr.toString()%>
								  </wea:item>
								<%
								}else if(stype.equals("2") || stype.equals("19")){ //日期
									oneQueryStr.append("<select class=\"inputstyle\" name=\"con"+id+"_opt\" style=\"width:20%\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
									oneQueryStr.append("<option value=\"1\" >"+SystemEnv.getHtmlLabelName(15508, languageID)+"</option>\n");
									oneQueryStr.append("<option value=\"2\" >"+SystemEnv.getHtmlLabelName(325, languageID)+"</option>\n");
									oneQueryStr.append("<option value=\"3\" >"+SystemEnv.getHtmlLabelName(15509, languageID)+"</option>\n");
									oneQueryStr.append("<option value=\"4\" >"+SystemEnv.getHtmlLabelName(326, languageID)+"</option>\n");
									oneQueryStr.append("<option value=\"5\" >"+SystemEnv.getHtmlLabelName(327, languageID)+"</option>\n");
									oneQueryStr.append("<option value=\"6\" >"+SystemEnv.getHtmlLabelName(15506, languageID)+"</option>\n");
									oneQueryStr.append("</select>\n");
									oneQueryStr.append("<button  type='button' class=\"Calendar\" onfocus=\"changelevel('"+tmpcount+"')\" ");
									if(stype.equals("2")){
										oneQueryStr.append(" onclick=\"onSearchWFDate(con"+id+"_valuespan,con"+id+"_value)\" ");
									}else{
										oneQueryStr.append(" onclick=\"onSearchWFTime(con"+id+"_valuespan,con"+id+"_value)\" ");
									}
									oneQueryStr.append(" ></button> \n");
									oneQueryStr.append("<input type=hidden name=\"con"+id+"_value\" >\n");
									oneQueryStr.append("<span name=\"con"+id+"_valuespan\" id=\"con"+id+"_valuespan\"></span>\n");
									oneQueryStr.append("<select class=\"inputstyle\" name=\"con"+id+"_opt1\" style=\"width:20%\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
									oneQueryStr.append("<option value=\"1\" >"+SystemEnv.getHtmlLabelName(15508, languageID)+"</option>\n");
									oneQueryStr.append("<option value=\"2\" >"+SystemEnv.getHtmlLabelName(325, languageID)+"</option>\n");
									oneQueryStr.append("<option value=\"3\" >"+SystemEnv.getHtmlLabelName(15509, languageID)+"</option>\n");
									oneQueryStr.append("<option value=\"4\" >"+SystemEnv.getHtmlLabelName(326, languageID)+"</option>\n");
									oneQueryStr.append("<option value=\"5\" >"+SystemEnv.getHtmlLabelName(327, languageID)+"</option>\n");
									oneQueryStr.append("<option value=\"6\" >"+SystemEnv.getHtmlLabelName(15506, languageID)+"</option>\n");
									oneQueryStr.append("</select>\n");
									oneQueryStr.append("<button  type='button' class=\"Calendar\" onfocus=\"changelevel('"+tmpcount+"')\" ");
									if(type.equals("2")){
										oneQueryStr.append(" onclick=\"onSearchWFDate(con"+id+"_value1span,con"+id+"_value1)\" ");
									}else{
										oneQueryStr.append(" onclick=\"onSearchWFTime(con"+id+"_value1span,con"+id+"_value1)\" ");
									}
									oneQueryStr.append(" ></button>\n");
									oneQueryStr.append("<input type=hidden name=\"con"+id+"_value1\" >\n");
									oneQueryStr.append("<span name=\"con"+id+"_value1span\" id=\"con"+id+"_value1span\"></span>\n");
								%>
								  <wea:item>
								       <%=oneQueryStr.toString()%>
								  </wea:item>
								
								<%
								}else if(stype.equals("17")){
								%>
								   <wea:item>
										  <select class=\"inputstyle\"  name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >
										  <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
										  <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
										  </select>
										   <div class='bwraper' >  
										  <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
											browserValue='<%=request.getParameter("con"+id+"_value")%>' 
											browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
											browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
											hasInput="true" 
											isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
											hasBrowser = "true" isMustInput='1' 
											completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
											>  
										  </brow:browser>
										  </div>
									</wea:item>
								
								<%
								}else if(stype.equals("37")){
								%>
								   <wea:item>
									   <select class=\"inputstyle\"  name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >         
									  <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
									  <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
									  </select>
									   <div class='bwraper' >  
									 <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
										browserValue='<%=request.getParameter("con"+id+"_value")%>' 
										browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
										hasInput="true" 
										isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
										hasBrowser = "true" isMustInput='1' 
										completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
										> 
									  </brow:browser>
									  </div>
									</wea:item>
								
								<%
								}else if(stype.equals("57")){
								%>
								      <wea:item>
										  <select class=\"inputstyle\"  name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >    
										  <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
										  <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
										  </select>
										   <div class='bwraper' >  
										 <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
											browserValue='<%=request.getParameter("con"+id+"_value")%>' 
											browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
											browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
											hasInput="true" 
											isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
											hasBrowser = "true" isMustInput='1' 
											completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
											> 
											 </brow:browser>
											 </div>
										  </wea:item>
							  <%
								}else if(stype.equals("135")){
								%>			
									 <wea:item>
										 <select class=\"inputstyle\"  name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >  
										  <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
										  <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
										  </select>
										   <div class='bwraper' >  
										  <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
											browserValue='<%=request.getParameter("con"+id+"_value")%>' 
											browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
											browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
											hasInput="true" 
											isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
											hasBrowser = "true" isMustInput='1' 
											completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
											> 
											 </brow:browser>
											 </div>
									 </wea:item>	
								<%			
								 }else if(stype.equals("152")){
								%>
								     <wea:item>
									  <select class=\"inputstyle\"  name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >  
									  <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
									  <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
									  </select>
									   <div class='bwraper' >  
									  <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
										browserValue='<%=request.getParameter("con"+id+"_value")%>' 
										browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp"
										hasInput="true" 
										isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
										hasBrowser = "true" isMustInput='1' 
										completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
										> 
										 </brow:browser>
										 </div>
									  </wea:item>								
								<%			
								 }else if(stype.equals("18")){
								%>		
								     <wea:item>
										 <select class=\"inputstyle\"  name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >  
										  <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
										  <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
										  </select>
										   <div class='bwraper' >  
										  <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
											browserValue='<%=request.getParameter("con"+id+"_value")%>' 
											browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
											browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
											hasInput="true" 
											isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
											hasBrowser = "true" isMustInput='1' 
											completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
											> 
											 </brow:browser>
											 </div>
									</wea:item>
								<%
							    }else if(stype.equals("160")){
								%>
								    <wea:item>
										  <select class=\"inputstyle\"  name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" > 
										  <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
										  <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
										  </select>
										   <div class='bwraper' >  
										 <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
											browserValue='<%=request.getParameter("con"+id+"_value")%>' 
											browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
											browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
											hasInput="true" 
											isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
											hasBrowser = "true" isMustInput='1' 
											completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
											> 
											 </brow:browser>
											 </div>
								   </wea:item>
								<%			
								}else if(stype.equals("142")){
								%>			
								    <wea:item>
									  <select class=\"inputstyle\"  name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >
									  <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
									  <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
									  </select>
									   <div class='bwraper' >  
									  <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
										browserValue='<%=request.getParameter("con"+id+"_value")%>' 
										browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp"
										hasInput="true" 
										isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
										hasBrowser = "true" isMustInput='1' 
										completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
										> 
										 </brow:browser>
										 </div>
									  </wea:item>

								<%			
								 }else if(stype.equals("141")||stype.equals("56")||stype.equals("27")||stype.equals("118")||stype.equals("65")||stype.equals("64")||stype.equals("137")){
								%>
								  <wea:item>
									  <select class=\"inputstyle\"  name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >
									  <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
									  <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
									  </select>
									   <div class='bwraper' >  
									  <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
										browserValue='<%=request.getParameter("con"+id+"_value")%>' 
										browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
										browserUrl='<%=BrowserComInfo.getBrowserurl(stype)%>'
										hasInput="true" 
										isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
										hasBrowser = "true" isMustInput='1' 
										completeUrl='<%="javascript:getajaxurl(" + stype+ ")"%>'
										>
										 </brow:browser>
										 </div>
									  </wea:item>								
								<%
								}else{
								%>
								     <wea:item>
									  <select class=\"inputstyle\"  name=\"con<%=id%>_opt\" style=\"width:50%\" onfocus=\"changelevel('<%=tmpcount%>')\" >
									  <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
									  <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
									  </select>
									   <div class='bwraper' >  
									  <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
										browserValue='<%=request.getParameter("con"+id+"_value")%>' 
										browserSpanValue='<%=FieldInfo.getFieldName(request.getParameter("con"+id+"_value"),Util.getIntValue(stype),BrowserComInfo.getBrowserdbtype(stype))%>' 
										browserUrl='<%=BrowserComInfo.getBrowserurl(stype)%>'
										hasInput="true" 
										isSingle='<%=BrowserManager.browIsSingle(stype)%>' 
										hasBrowser = "true" isMustInput='1' 
										completeUrl='<%="javascript:getajaxurl(" + stype+ ")"%>'
										>
										 </brow:browser>
										 </div>
									  </wea:item>							
								<%
							    }
							   } 
							  %>
                        <%}%>

                       
					
					</wea:group>
						
					<wea:group context="" attributes="{'display':'none'}">
						<wea:item type="toolbar">
							<input type="button" onclick='onSearch();' class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage()) %>" id="searchBtn"/>
							<span class="e8_sep_line">|</span>
							<!--
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage()) %>" class="e8_btn_cancel"/>
							<span class="e8_sep_line">|</span>
							-->
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>			
	 </div>

</form>

 <wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="true" />
 <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

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
	var e =$.event.fix(getEvent()).target;
	while(e.tagName != "TR"){
		e = $(e).parent()[0];
	}
	e.className = "Selected";
}
function browseTable_onmouseout(e){
	var e =$.event.fix(getEvent()).target;
	while(e.nodeName != "TR"){
		e = $(e).parent()[0];;
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
function WdatePicker_changeDays(objspan, objinput){
	WdatePicker(
		{
			el:
				objspan,
				onpicked:function(dp){
					var returnvalue = dp.cal.getDateStr();
					$dp.$(objinput).value = returnvalue;
					location.href="/worktask/request/RequestApproveList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&isfromleft=<%=isfromleft%>&worktaskStatus=<%=worktaskStatus%>&days="+objinput.value;
				},
				oncleared:function(dp){
					$dp.$(objinput).value = "<%=currentDay%>";
					$dp.$(objspan).innerHTML = "<%=currentDay%>";
					location.href="/worktask/request/RequestApproveList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&isfromleft=<%=isfromleft%>&worktaskStatus=<%=worktaskStatus%>&days=<%=currentDay%>";
				}
			}
		);
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

//批准一条记录
function OnApproveOne(id){
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(83706,user.getLanguage()) %>',function(){
	
	  var checkbox=$("input[checkboxid='"+id+"']");
	  var taskid=checkbox.attr("value");
	  var hiddenarray=[];
	  var approverequest=$("input[name='apprequest_"+id+"']").val();
	  hiddenarray.push("<input type='hidden'  name='checktask2' value='"+id+"'>");		
	  hiddenarray.push("<input type='hidden' name='approverequest_"+id+"' value='"+approverequest+"'>");	
	  hiddenarray.push("<input type='hidden' name='taskid_"+id+"' value='"+taskid+"'>");	
	  //添加隐藏域
	  $("form[name='taskform']").prepend(hiddenarray.join("")); 
	  document.taskform.action = "RequestOperation.jsp";
	  document.taskform.operationType.value="multiApprove";
	  document.taskform.submit();
	  enableAllmenu();
	
		
	});
 
}

//处理批准,退回,取消操作
function handOp(option){
     var reqidstr=_xtable_CheckedCheckboxIdForCP();
	 if(reqidstr===''){
		 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000, user.getLanguage())%>");
		  return;
	 }
    
	 var msg="";
	 if(option==='multiApprove')
		  msg='<%=SystemEnv.getHtmlLabelName(142,user.getLanguage()) %>';
	 else if(option==='multiBack')
           msg='<%=SystemEnv.getHtmlLabelName(236,user.getLanguage()) %>';
	 else if(option==='multiCancel')
           msg='<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>';
	 
	 window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(28296,user.getLanguage()) %>'+msg+'?',function(){
	 
	    var approverequestitem;
		var reqids=_xtable_CheckedCheckboxIdForCP().split(",");
		var taskids=_xtable_CheckedCheckboxValueForCP().split(",");
		var hiddenarray=[];
		for(var i=0;i<reqids.length-1;i++){
			  approverequestitem=$("input[name='apprequest_"+reqids[i]+"']").val();
			  hiddenarray.push("<input type='hidden'  name='checktask2' value='"+reqids[i]+"'>");		
			  hiddenarray.push("<input type='hidden' name='approverequest_"+reqids[i]+"' value='"+approverequestitem+"'>");	
			  hiddenarray.push("<input type='hidden' name='taskid_"+reqids[i]+"' value='"+taskids[i]+"'>");	
		}
		//添加隐藏域
		$("form[name='taskform']").prepend(hiddenarray.join("")); 

		document.taskform.action = "RequestOperation.jsp";
		document.taskform.operationType.value=option;
		document.taskform.submit();
		enableAllmenu();
	 	 
	 });


}


function OnApprove(){
	 handOp("multiApprove");	 
}

//退回一条记录
function OnRejectOne(id){
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("28296,236",user.getLanguage()) %>?',function(){
	  
	  var checkbox=$("input[checkboxid='"+id+"']");
	  var taskid=checkbox.attr("value");
	  var hiddenarray=[];
	  var approverequest=$("input[name='apprequest_"+id+"']").val();
	  hiddenarray.push("<input type='hidden'  name='checktask2' value='"+id+"'>");		
	  hiddenarray.push("<input type='hidden' name='approverequest_"+id+"' value='"+approverequest+"'>");	
	  hiddenarray.push("<input type='hidden' name='taskid_"+id+"' value='"+taskid+"'>");	
	  //添加隐藏域
	  $("form[name='taskform']").prepend(hiddenarray.join("")); 
	  document.taskform.action = "RequestOperation.jsp";
	  document.taskform.operationType.value="multiBack";
	  document.taskform.submit();
	  enableAllmenu();
	
	});
	  
}

 //打开任务窗口
 function doView(requestid){
	openFullWindowHaveBar("/worktask/request/ViewWorktask.jsp?requestid="+requestid+"");	 
 }

function OnReject(){
	 handOp("multiBack");	
}

//取消一条记录
function OnCancelOne(id){
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("28296,201",user.getLanguage()) %>?',function(){
	   var checkbox=$("input[checkboxid='"+id+"']");
	  var taskid=checkbox.attr("value");
	  var hiddenarray=[];
	  var approverequest=$("input[name='apprequest_"+id+"']").val();
	  hiddenarray.push("<input type='hidden'  name='checktask2' value='"+id+"'>");		
	  hiddenarray.push("<input type='hidden' name='approverequest_"+id+"' value='"+approverequest+"'>");	
	  hiddenarray.push("<input type='hidden' name='taskid_"+id+"' value='"+taskid+"'>");	
	  //添加隐藏域
	  $("form[name='taskform']").prepend(hiddenarray.join("")); 
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
		//alert(flag);
		var editids = document.taskform.editids.value;
		if(flag == true){
			location.href = "RequestEditList.jsp?wtid=<%=wtid%>&worktaskStatus=<%=worktaskStatus%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&weeks=<%=weeks%>&months=<%=months%>&quarters=<%=quarters%>&days=<%=days%>&functionPage=RequestApproveList.jsp&isfromleft=<%=isfromleft%>&editids="+editids;
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




     function changelevel(tmpindex){
			//document.taskform.check_con(tmpindex*1).checked = true;
			document.all("check_con")[tmpindex*1].checked = true;
			var item=document.getElementsByName("check_con")[tmpindex*1-1];
			item.checked = true;
			changeCheckboxStatus4tzCheckBox(item, item.checked);
	 }


function onShowBrowser(id,url){
		datas = window.showModalDialog(url);
		if(datas){
		     if(datas.id!=""){
				$("#con"+id+"_valuespan").html(datas.name);
				$("input[name=con"+id+"_value]").val(datas.id);
				$("input[name=con"+id+"_name]").val(datas.name);
		     }else{
		    	$("#con"+id+"_valuespan").html("");
				$("input[name=con"+id+"_value]").val("");
				$("input[name=con"+id+"_name]").val("");
		     }
		}
}

function onShowBrowser2(id,url,type1){
	if(type1==8){
 		tmpids = document.all("con"+id+"_value").value
		datas = window.showModalDialog(url+"?projectids="+tmpids)
	}else if(type1==9){
	  tmpids = document.all("con"+id+"_value").value
	  datas = window.showModalDialog(url+"?documentids="+tmpids)
	}else if(type1==1){
		tmpids = document.all("con"+id+"_value").value
		datas = window.showModalDialog(url+"?resourceids="+tmpids)
	}else if(type1==4){
		tmpids = document.all("con"+id+"_value").value
		datas = window.showModalDialog(url+"?resourceids="+tmpids)
	}else if(type1==16){
		tmpids = document.all("con"+id+"_value").value
		datas = window.showModalDialog(url+"?resourceids="+tmpids)
	}else{
		 type1=7 
		tmpids =document.all("con"+id+"_value").value
		datas = window.showModalDialog(url+"?resourceids="+tmpids)
	}
	if(datas){
		if(datas.id){
			resourceids = datas.id
			resourcename = datas.name
			resourceids = resourceids.substr("1");
			resourcename = resourcename.substr("1");
			$("#con"+id+"_valuespan").html(resourcename); 
			$("input[name=con"+id+"_value]").val(resourceids);
			$("input[name=con"+id+"_name]").val(resourcename);
		}else{
			$("#con"+id+"_valuespan").html(""); 
			$("input[name=con"+id+"_value]").val("");
			$("input[name=con"+id+"_name]").val("");
		}
	}
	
}
</script>
</HTML>

<script language="vbs">



</script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()></script>
