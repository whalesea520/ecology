<%@ page import="weaver.general.Util,java.text.SimpleDateFormat" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@page import="weaver.hrm.common.Tools"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%!
/*Add by Charoes Huang */
private boolean canAddNewTrain(User user){
    boolean canAdd = false;
    String currentDate ="";
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd") ;
    currentDate = format.format(Calendar.getInstance().getTime());
    int userid = user.getUID() ;
     RecordSet rs = new RecordSet();
	 String sql ="SELECT COUNT(*) as COUNT FROM HrmTrainPlan WHERE (','+planorganizer+',' like '%,"+userid+",%' or createrid = "+userid+") and (planenddate>='"+currentDate+"' or planenddate='')";
	
	if(rs.getDBType().equals("oracle")){
		sql = "SELECT COUNT(*) as COUNT FROM HrmTrainPlan WHERE (concat(concat(',',planorganizer),',') like '%,"+userid+",%' or createrid = "+userid+") and (planenddate>='"+currentDate+"' or planenddate is null)";
	}
	
    rs.executeSql(sql);
    if(rs.next()){
        if(rs.getInt("COUNT") > 0 )
            canAdd = true;
    }
    return canAdd;
}
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage());
String needfav ="1";
String needhelp ="";

int perpage=Util.getIntValue(request.getParameter("perpage"),10);
String method = Util.null2String(request.getParameter("method"));

String backFields = "a.id,a.planid,a.name,b.planname,a.advice, a.startdate,a.enddate";
String sqlFrom = " from HrmTrain a,HrmTrainPlan b";
String orderby = " a.startdate ";
String SqlWhere = " a.planid = b.id ";
String type = Util.null2String(request.getParameter("type"));
String qname = Util.null2String(request.getParameter("flowTitle"));
String trainName = Util.null2String(request.getParameter("trainName"));
String trainPlanName = Util.null2String(request.getParameter("trainPlanName"));
String trainAdvice = Util.null2String(request.getParameter("trainAdvice"));
String canView = "false";
if(HrmUserVarify.checkUserRight("HrmTrainEdit:Edit", user)){
  canView = "true";
 }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#weaver").submit();
}
function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		jQuery.post("checkData.jsp?operation=canDelete&id="+id,function(data){
			if(data==1){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126276,user.getLanguage())%>");
				return ;
			}else{
				for(var i=0;i<idArr.length;i++){
					ajaxNum++;
					jQuery.ajax({
						url:"TrainOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
						type:"post",
						async:true,
						complete:function(xhr,status){
							ajaxNum--;
							if(ajaxNum==0){
								_table.reLoad();
							}
						}
					});
				}
			}
		});
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainAdd&isdialog=1";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6136,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainEdit&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(6136,user.getLanguage())%>";
	}
	dialog.Width = 700;
	dialog.Height = 603;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function commonDialog(id,url,title, width, heigth){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	dialog.Title = title;
	dialog.Width = width;
	dialog.Height = heigth;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function addtrainday(id){
	var title = "<%=SystemEnv.getHtmlLabelName(16151,user.getLanguage())%>";
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainDayAdd&isdialog=1&trainid="+id;
	commonDialog(id,url,title, 700, 420);
}

function doinfo(id){	
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"/hrm/train/trainplan/TrainOperation.jsp?isdialog=1&operation=info&id="+id,
			type:"post",
			async:true,
			complete:function(xhr,status){
				if(i==idArr.length-1){
					onBtnSearchClick();
				}
			}
		});
	});
}
  
function addactor(id){
	var title = "<%=SystemEnv.getHtmlLabelName(16148,user.getLanguage())%>";
	var url="/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainActorAdd&trainid="+id;
	commonDialog(id,url,title, 500, 250);
}

function dotest(id){
	var title = "<%=SystemEnv.getHtmlLabelName(16143,user.getLanguage())%>";
	var url="/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainTest&trainid="+id;
	commonDialog(id,url,title, 700, 600);
}

function doassess(id){
	var title = "<%=SystemEnv.getHtmlLabelName(16144,user.getLanguage())%>";
  var url="/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainAssess&trainid="+id;
	commonDialog(id,url,title, 700, 600);
}

function dofinish(id){
	var title = "<%=SystemEnv.getHtmlLabelNames("405,678",user.getLanguage())%>";
  var url="/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainFinish&id="+id;
	commonDialog(id,url,title, 500, 300);
}
  
function dofinish1(id){
	var title = "<%=SystemEnv.getHtmlLabelName(6135,user.getLanguage())%>";
  var url="/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainFinishView&id="+id;
	commonDialog(id,url,title, 700, 600);
}
function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=83 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=83")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canAddNewTrain(user)){
  RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
  RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

if(canAddNewTrain(user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>  
<FORM id="weaver" name="weaver" action="HrmTrain.jsp" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canAddNewTrain(user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>

				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
						<%}%>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	<input type=hidden name='method' value="search">
	<input type=hidden name='type' value="<%=type %>">
	<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(15678,user.getLanguage())%></wea:item>
				<wea:item><INPUT type=text name="trainName" class=InputStyle size=20 value='<%=trainName%>' ></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></wea:item>
				<wea:item><INPUT type=text name="trainPlanName" class=InputStyle size=20 value='<%=trainPlanName%>' ></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(15728,user.getLanguage())%></wea:item>
				<wea:item><INPUT type=text name="trainAdvice" class=InputStyle size=20 value='<%=trainAdvice%>' ></wea:item>
			</wea:group>
			<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
		</wea:layout>
	</div>
</FORM>
<%
//只能选择未结束的，当前用户为操作者或者创建者的培训计划
int userid = user.getUID();
String currentDate ="";
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd") ;
currentDate = format.format(Calendar.getInstance().getTime());
//SqlWhere += " and  (','+planorganizer+',' like '%,"+userid+",%' or b.createrid = "+userid+") and (planenddate>='"+currentDate+"' or b.planenddate='') ";

    
if(!"".equals(qname)) {
	SqlWhere += "and a.name like '%" + qname + "%' ";
}

if(!"".equals(trainName)) {
	SqlWhere += "and a.name like '%" + trainName + "%' ";
}
if(!"".equals(trainPlanName)) {
	SqlWhere += "and b.planname like '%" + trainPlanName + "%' ";
}
if(!"".equals(trainAdvice)) {
	SqlWhere += "and a.advice like '%" + trainAdvice + "%' ";
}


 
if(type.equals("1")){
	//未结束
	SqlWhere += "and (summarizer is null or summarizer <=0) ";
}else if(type.equals("2")){
	//已结束
	SqlWhere += "and summarizer is not null and summarizer >0 ";
}


//操作字符串
int idx =0;
String  operateString= "";
operateString = "<operates width=\"20%\">"; 
operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getHrmTrainOperate\" otherpara=\""+canView+"\" otherpara2=\""+user.getUID()+":"+HrmUserVarify.checkUserRight("HrmTrain:Log", user)+"\"></popedom> ";
operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\""+(idx++)+"\" />";
operateString+="     <operate href=\"javascript:addactor()\" text=\""+SystemEnv.getHtmlLabelName(16148,user.getLanguage())+"\" index=\""+(idx++)+"\" />";
operateString+="     <operate href=\"javascript:addtrainday()\" text=\""+SystemEnv.getHtmlLabelName(16151,user.getLanguage())+"\" index=\""+(idx++)+"\"/>";
operateString+="     <operate href=\"javascript:dotest()\" text=\""+SystemEnv.getHtmlLabelName(16143,user.getLanguage())+"\" index=\""+(idx++)+"\"/>";
operateString+="     <operate href=\"javascript:doassess()\" text=\""+SystemEnv.getHtmlLabelName(16144,user.getLanguage())+"\" index=\""+(idx++)+"\"/>";
operateString+="     <operate href=\"javascript:dofinish()\" text=\""+SystemEnv.getHtmlLabelNames("405,678",user.getLanguage())+"\" index=\""+(idx++)+"\"/>";
operateString+="     <operate href=\"javascript:dofinish1()\" text=\""+SystemEnv.getHtmlLabelNames("6135",user.getLanguage())+"\" index=\""+(idx++)+"\"/>";
//operateString+="     <operate href=\"javascript:doinfo()\" text=\""+SystemEnv.getHtmlLabelName(16149,user.getLanguage())+"\" index=\"7\"/>";
operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\""+(idx++)+"\" />";
operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\""+(idx++)+"\" />";
operateString+="</operates>";	
 
String tableString = "" + 
	"<table pageId=\""+PageIdConst.HRM_Train+"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_Train,user.getUID(),PageIdConst.HRM)+"\">" +
	"<checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getHrmTrainCheckbox\" id=\"checkbox\"  popedompara=\"column:id+"+user.getUID()+"\" />"+	
	"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"a.id\" sqlsortway=\"desc\" sqldistinct=\"true\" />"+
		"<head>"+
			"<col width=\"33%\" text=\""+SystemEnv.getHtmlLabelName(15678,user.getLanguage()) +"\" column=\"name\" orderkey=\"name\"/>"+
			"<col width=\"33%\" text=\""+SystemEnv.getHtmlLabelName(6156,user.getLanguage())+"\" column=\"planname\" orderkey=\"planname\"/>";
			if(type.equals("0") || type.equals("1")){
				tableString+="<col width=\"33%\" text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\" column=\"startdate\" orderkey=\"startdate\"/>"
									  +"<col width=\"33%\" text=\""+SystemEnv.getHtmlLabelName(741,user.getLanguage())+"\" column=\"enddate\" orderkey=\"enddate\"/>";;
			}else if(type.equals("2")){
				tableString+="<col width=\"33%\" text=\""+SystemEnv.getHtmlLabelName(15728,user.getLanguage())+"\" column=\"advice\" orderkey=\"advice\"/>";
			}
			tableString+="</head>"+operateString+"</table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_Train %>"/>
<wea:SplitPageTag tableString='<%=tableString%>' mode="run" isShowTopInfo="false"/>
</BODY>
</HTML>
