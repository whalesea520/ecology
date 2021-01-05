
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.worktask.worktask.*" %>
<%@ page import="java.text.*,weaver.file.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="sysPubRefComInfo" class="weaver.general.SysPubRefComInfo" scope="page" />
<jsp:useBean id="sptmForWorktask" class="weaver.splitepage.transform.SptmForWorktask" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="BrowserManager" class="weaver.general.browserData.BrowserManager" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML>
<head>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
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

	 $(document).find("input[name='taskcontent']").val(value);
	 $("form[name='taskform']").submit();

}
jQuery(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
</script>

<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16400,user.getLanguage());
String needfav ="1";
String needhelp ="";
int canCreateHistoryWorktask = Util.getIntValue(BaseBean.getPropValue("worktask", "canCreateHistoryWorktask"), 1);
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
	operationType = Util.null2String(fu.getParameter("operationType"));
	taskcontent = Util.null2String(fu.getParameter("taskcontent"));
	if("search".equals(operationType) || "searchorder".equals(srcType) || "changePage".equals(srcType)){
		years = Util.null2String(fu.getParameter("years"));
		months = Util.null2String(fu.getParameter("months"));
		quarters = Util.null2String(fu.getParameter("quarters"));
		weeks = Util.null2String(fu.getParameter("weeks"));
		days = Util.null2String(fu.getParameter("days"));
		type = Util.null2String(fu.getParameter("type")); //周期
		wtid = Util.getIntValue(fu.getParameter("wtid"), 0);
		worktaskStatus = Util.getIntValue(fu.getParameter("worktaskStatus"), 0);
	}
}

String checkStr = "";
String worktaskName = "";
String worktaskStatusName = "";
boolean hasSuchWT = false;
Hashtable worktaskName_hs = new Hashtable();
rs1.execute("select * from worktask_base");
while(rs1.next()){
	int id_tmp = Util.getIntValue(rs1.getString("id"), 0);
	if(id_tmp == wtid){
		hasSuchWT = true;
	}
	String worktaskName_tmp = Util.null2String(rs1.getString("name"));
	worktaskName_hs.put("worktaskname_"+id_tmp, worktaskName_tmp);
}
if(hasSuchWT == true){
	worktaskName = Util.null2String((String)worktaskName_hs.get("worktaskname_"+wtid));
}else{
	wtid = 0;
}


WTSerachManager wtSerachManager = new WTSerachManager(wtid);
wtSerachManager.setLanguageID(user.getLanguage());
wtSerachManager.setType_d(type_d);
wtSerachManager.setObjid(objId);
wtSerachManager.setUserID(user.getUID());
wtSerachManager.setWorktaskStatus(worktaskStatus);

if("search".equals(operationType)){
	Hashtable sql_hs = wtSerachManager.getSearchSqlStr(fu);
	sqlWhere = (String)sql_hs.get("sqlWhere");
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
Hashtable ret_hs_1 = wtSerachManager.getCreatePageSql();
createPageSql = (String)ret_hs_1.get("createPageSql");
ArrayList textheightList = (ArrayList)ret_hs_1.get("textheightList");
ArrayList idList = (ArrayList)ret_hs_1.get("idList");
ArrayList<String> fieldnameList = (ArrayList<String>)ret_hs_1.get("fieldnameList");
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
	pName1 = days.substring(0, 4)+SystemEnv.getHtmlLabelName(445,user.getLanguage())+days.substring(5, 7)+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+days.substring(8, 10)+SystemEnv.getHtmlLabelName(390, user.getLanguage());
}
pName1 += (worktaskStatusName + worktaskName);
String pName = objName+pName1;

int perpage = wtSerachManager.getUserDefaultPerpage(false);


//构建显示列
StringBuilder sbBackfields=new StringBuilder();
StringBuilder sbColumns=new StringBuilder();

sbBackfields.append("name,detailName,creater as tcreater,status as tstatus,taskid,");

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
		operateString+=" <popedom otherpara=\"column:tstatus\" column=\"requestid\" transmethod=\"weaver.worktask.worktask.WTTransmethods.getTaskSubmitMenu\"   ></popedom> ";
		operateString+="     <operate   href=\"javascript:doView();\"  text=\""+SystemEnv.getHtmlLabelName(33564,user.getLanguage())+"\"   index=\"0\"/>";
		operateString+="     <operate   href=\"javascript:doDelete();\"  text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\"   index=\"1\"/>";
		operateString+="</operates>";

String tableString =" <table  sqlisdistinct=\"true\" tabletype=\"checkbox\" instanceid=\"readinfo\"  pagesize=\""+pagesize+"\" >"+ 
                 "<browser returncolumn=\"taskid\"/>"+
                "<checkboxpopedom value='10' id='10'  showmethod=\"weaver.worktask.worktask.WTTransmethods.getWorkflowTaskCanDel\"  popedompara=\"column:tstatus+column:tcreater+"+user.getUID()+"\" />"+
                "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(tableSqlWhere)+"\"    sqlprimarykey=\"requestid\" sqlsortway=\"Desc\"/>"+
                "<head>"+sbColumns.toString()+
				"</head>"+ operateString + 			
				"</table>";

%>
</head>




  <body>
      
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(82, user.getLanguage())+",javaScript:addNew(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(15143, user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			   
	%>

<form name="taskform" method="post" action="RequestSubmitList.jsp"  enctype="multipart/form-data" >
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
	<input type="hidden" id="isCreate" name="isCreate" value="1">
	<input type="hidden" id="nodesnum" name="nodesnum" value="1">
	<input type="hidden" id="indexnum" name="indexnum" value="1">
	<input type="hidden" id="needcheck" name="needcheck" value="wtid" >
	<input type="hidden" id="delids" name="delids" >
	<input type="hidden" id="editids" name="editids" >
	<input type="hidden" id="functionPage" name="functionPage" value="RequestSubmitList.jsp" >
	<input type="hidden" id="orderType" name="orderType" value="">
	<input type="hidden" id="orderFieldName" name="orderFieldName" value="">
	<input type="hidden" id="orderFieldid" name="orderFieldid" value="">
	<input type="hidden" id="srcType" name="srcType" value="">
	<input type="hidden" id="sqlWhere" name="sqlWhere" value="<%=xssUtil.put(sqlWhere)%>">

	   <wea:layout attributes="{layoutTableId:topTitle}">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">

					<input class="e8_btn_top"	onclick="addNew()" type="button"  value="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage()) %>"/>
			
					<input class="e8_btn_top" onclick="OnSubmit()" type="button"  value="<%=SystemEnv.getHtmlLabelName(15143,user.getLanguage()) %>"/>

					<input class="e8_btn_top" onclick="doDeleteBatch()" type="button"  value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
		
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
										oneQueryStr.append("<input type=\"text\" class=InputStyle style=\"width:50%\" style='vertical-align:middle;width:60%' size=\"12\" name=\"con"+id+"_value\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
									}else if(htmltype.equals("1")&& !type.equals("1")){		//数字输入框	大于,大于或等于,小于,小于或等于,等于,不等于
										oneQueryStr.append("<select class=\"inputstyle\" name=\"con"+id+"_opt\" style=\"width:20%\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
										oneQueryStr.append("<option value=\"1\" >"+SystemEnv.getHtmlLabelName(15508, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"2\" >"+SystemEnv.getHtmlLabelName(325, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"3\" >"+SystemEnv.getHtmlLabelName(15509, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"4\" >"+SystemEnv.getHtmlLabelName(326, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"5\" >"+SystemEnv.getHtmlLabelName(327, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"6\" >"+SystemEnv.getHtmlLabelName(15506, languageID)+"</option>\n");
										oneQueryStr.append("</select>\n");
										oneQueryStr.append("<input type=text class=\"InputStyle\" style='vertical-align:middle;width:60%'  name=\"con"+id+"_value\" onblur=\"checknumber('con"+id+"_value')\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
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
										oneQueryStr.append("<button  type='button' class=Browser onfocus=\"changelevel('"+tmpcount+"')\"  onclick=\"onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1')\"></button>\n");
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
								      <select class=inputstyle name='con<%=id%>_opt' style='width:50%' onfocus='changelevel('<%=tmpcount%>')' >
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
										_callback="checklevel"
										completeUrl='<%="javascript:getajaxurl(" + stype + ")"%>'
										> 
									  </brow:browser>
									  </div>
									  
								 </wea:item>
							  <%
									 } else if(stype.equals("9")){
										
								%>
								     <wea:item>
								          <select class='inputstyle'  name='con<%=id%>_opt' style='width:50%' onfocus='changelevel('<%=tmpcount%>')' >
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
								          <select class="inputstyle" name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >
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
								      <select class="inputstyle" name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >
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
								      <select class="inputstyle"  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >
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
								       <select class="inputstyle"  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >
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
										oneQueryStr.append("<input type=\"text\" class=\"InputStyle\" style=\"width:50%\" style='vertical-align:middle;width:60%' size=\"10\" name=\"con"+id+"_value\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
										oneQueryStr.append("<select class=\"inputstyle\" name=\"con"+id+"_opt1\" style=\"width:20%\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");
										oneQueryStr.append("<option value=\"1\" >"+SystemEnv.getHtmlLabelName(15508, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"2\" >"+SystemEnv.getHtmlLabelName(325, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"3\" >"+SystemEnv.getHtmlLabelName(15509, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"4\" >"+SystemEnv.getHtmlLabelName(326, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"5\" >"+SystemEnv.getHtmlLabelName(327, languageID)+"</option>\n");
										oneQueryStr.append("<option value=\"6\" >"+SystemEnv.getHtmlLabelName(15506, languageID)+"</option>\n");
										oneQueryStr.append("</select>\n");
										oneQueryStr.append("<input type=\"text\" class=\"InputStyle\" style=\"width:50%\" style='vertical-align:middle;width:60%' size=\"10\" name=\"con"+id+"_value1\" onfocus=\"changelevel('"+tmpcount+"')\" >\n");

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
									oneQueryStr.append("<button  type='button' class=Calendar onfocus=\"changelevel('"+tmpcount+"')\" ");
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
									oneQueryStr.append("<button  type='button' class=Calendar onfocus=\"changelevel('"+tmpcount+"')\" ");
									if(stype.equals("2")){
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
										  <select class="inputstyle"  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >
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
									   <select class="inputstyle"  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >         
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
										  <select class="inputstyle"  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >    
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
										 <select class="inputstyle"  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >  
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
									  <select class="inputstyle"  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >  
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
										 <select class="inputstyle"  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >  
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
										  <select class="inputstyle"  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" > 
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
									  <select class="inputstyle"  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >
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
									  <select class="inputstyle"  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >
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
									  <select class="inputstyle"  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >
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
   
	 function OnSubmit(){
		 var reqidstr=_xtable_CheckedCheckboxIdForCP();
		 if(reqidstr===''){
		  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
		  return;
		 }
		if(check_form(document.taskform, document.all("needcheck").value)){
            var reqids=_xtable_CheckedCheckboxIdForCP().split(",");
            var taskids=_xtable_CheckedCheckboxValueForCP().split(",");
            var hiddenarray=[];
			for(var i=0;i<reqids.length-1;i++){
              	hiddenarray.push("<input type='hidden'  name='checktask2' value='"+reqids[i]+"'>");		
			    hiddenarray.push("<input type='hidden' name='requestid_add' value='"+reqids[i]+"'>");	
				hiddenarray.push("<input type='hidden' name='taskid_"+reqids[i]+"' value='"+taskids[i]+"'>");	
			}
			//添加隐藏域
            $("form[name='taskform']").prepend(hiddenarray.join("")); 

			document.taskform.action = "RequestOperation.jsp";
			document.taskform.operationType.value="multiSubmit";
			document.taskform.submit();
			enableAllmenu();
		}
     }

	 function onSearch(){
		//document.taskform.operationType.value="search";
		$("input[name='operationType']").val("search");
		document.taskform.submit();
		enableAllmenu();
     }
     
	 function OnNew(){
	     var wtid = document.taskform.wtid.value;
		openFullWindowForXtable("/worktask/request/AddWorktaskFrame.jsp?wtid="+wtid);
	 }
	 
	 
	 var dialog = null;
	 function addNew(){
			if(dialog==null){
				dialog = new window.top.Dialog();
			}
			var wtid = document.taskform.wtid.value;
			dialog.currentWindow = window;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(82, user.getLanguage()) + SystemEnv.getHtmlLabelName(16539, user.getLanguage())%>";
		    dialog.URL = "/worktask/request/AddWorktaskFrame.jsp?wtid="+wtid;
			dialog.Width = 560;
			dialog.Height = 460;
			dialog.Drag = true;
			dialog.textAlign = "center";
			dialog.show();
	 }

	 //打开任务窗口
     function doView(requestid){
	    openFullWindowHaveBar("/worktask/request/ViewWorktask.jsp?requestid="+requestid+"");	 
	 }
   
    function doDelete(id){

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

	//批量删除
	function doDeleteBatch(){
	   handOp("multidelete");
	} 
    
    function checklevel(e){
	//	$(e.target).closest("td").prev().find()
	 // alert('checke');
	  //console.dir(arguments);
	}

	</script>
  </body>
  
  
</html>
