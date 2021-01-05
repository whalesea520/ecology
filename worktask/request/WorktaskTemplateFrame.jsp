
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*,weaver.file.*" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
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
</style>
<script type="text/javascript">
//按计划内容搜索
function onBtnSearchClick(value){

	 $(document).find("input[name='tcontent']").val(value);
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
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="sysPubRefComInfo" class="weaver.general.SysPubRefComInfo" scope="page" />
<jsp:useBean id="sptmForWorktask" class="weaver.splitepage.transform.SptmForWorktask" scope="page" />
<%
session.setAttribute("relaterequest", "new");
String CurrentUser = ""+user.getUID();
String currentMonth = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).MONTH)+1);
String currentWeek = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).WEEK_OF_YEAR));
String currentDay = TimeUtil.getCurrentDateString();
String objId = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
String type = Util.null2String(request.getParameter("type")); //周期
String type_d = Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d")); //计划所有者类型
String objName = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objName"));
String operationType = Util.null2String(request.getParameter("operationType"));
String taskcontent = Util.null2String(request.getParameter("taskcontent"));
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
int worktaskStatus = Util.getIntValue(request.getParameter("worktaskStatus"), 0);
int wakemode = Util.getIntValue(request.getParameter("wakemode"), -1);

//按计划内容索引
String tcontent = Util.null2String(request.getParameter("tcontent"));

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
	tcontent = Util.null2String(fu.getParameter("tcontent"));
	operationType = Util.null2String(fu.getParameter("operationType"));
	if("search".equals(operationType) || "searchorder".equals(srcType) || "changePage".equals(srcType)){
		type = Util.null2String(fu.getParameter("type")); //周期
		wtid = Util.getIntValue(fu.getParameter("wtid"), 0);
		worktaskStatus = Util.getIntValue(fu.getParameter("worktaskStatus"), 0);
		taskcontent = Util.null2String(fu.getParameter("taskcontent"));
		wtid = Util.getIntValue(fu.getParameter("wtid"), 0);
		wakemode = Util.getIntValue(fu.getParameter("wakemode"), -1);
	}
}
String checkStr = "";
String worktaskName = "";
boolean hasSuchWT = false;
Hashtable worktaskName_hs = new Hashtable();
ArrayList wtidList = new ArrayList();
rs1.execute("select * from worktask_base order by orderid asc");
while(rs1.next()){
	int id_tmp = Util.getIntValue(rs1.getString("id"), 0);
	if(id_tmp == wtid){
		hasSuchWT = true;
	}
	String worktaskName_tmp = Util.null2String(rs1.getString("name"));
	wtidList.add(""+id_tmp);
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

if("searchorder".equals(srcType) || "changePage".equals(srcType)){
	sqlWhere = Util.null2String((String)session.getAttribute("sqlWhereWT_"+user.getUID()));
}
if("search".equals(operationType)){
	if(wtid != 0){
		sqlWhere += " and r.taskid="+wtid+" ";
	}
	if(!"".equals(taskcontent.trim())){
		sqlWhere += " and r.taskcontent like '%"+taskcontent+"%' ";
	}
	if(wakemode != -1){
		sqlWhere += " and r.wakemode="+wakemode+" ";
	}
}
session.setAttribute("sqlWhereWT_"+user.getUID(), sqlWhere);
ArrayList wtsdetailCodeList = sysPubRefComInfo.getDetailCodeList("WorkTaskStatus");//先留着
ArrayList wtsdetailLabelList = sysPubRefComInfo.getDetailLabelList("WorkTaskStatus");

String createPageSql = "";
Hashtable ret_hs_1 = wtSerachManager.getTemplatePageSql();
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
listCount += 1;//创建人
listCount += 1;//一直显示定期类型

//使用自定义查询时，时间限定无作用
if("search".equals(operationType) || (("searchorder".equals(srcType) || "changePage".equals(srcType)) && !"".equals(sqlWhere))){
	createPageSql += sqlWhere;
}

if(!tcontent.equals("")){
   createPageSql+=" and taskcontent like '%"+tcontent+"%' ";

}

//System.out.println("createPageSql = " + createPageSql);
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

BaseBean.writeLog("backFields===>"+backFields);

BaseBean.writeLog("sqlFrom===>"+sqlFrom);

String tableSqlWhere = " ";
String orderby = " ";

String operateString= "<operates width=\"15%\">";
		operateString+=" <popedom transmethod=\"weaver.worktask.worktask.WTTransmethods.getTaskTemplateMenu\"></popedom> ";
		operateString+="     <operate   href=\"javascript:doView();\"  text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\"   index=\"0\"/>";
		operateString+="     <operate   href=\"javascript:delRowOne();\"  text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\"   index=\"1\"/>";		
		operateString+="</operates>";

String tableString =" <table  sqlisdistinct=\"true\" tabletype=\"checkbox\" instanceid=\"readinfo\"  pagesize=\""+pagesize+"\" >"+ 
                 "<browser returncolumn=\"taskid\"/>"+
                "<checkboxpopedom value='10' id='10'  showmethod=\"weaver.worktask.worktask.WTTransmethods.getWorkflowTaskCanDel\"  popedompara=\"column:tstatus+column:tcreater+"+user.getUID()+"\" />"+
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
String titlename = SystemEnv.getHtmlLabelName(16539, user.getLanguage()) + SystemEnv.getHtmlLabelName(64, user.getLanguage());
String imagefilename = "/images/hdHRM_wev8.gif";
%>

<BODY id="worktaskBody">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82, user.getLanguage())+",javaScript:OnNew(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javaScript:delRow(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>	


<form name="taskform" method="post" action="WorktaskTemplateFrame.jsp" enctype="multipart/form-data">
<input type="hidden" name="worktaskStatus" value="<%=worktaskStatus%>">
<input type="hidden" name="type" value=<%=type%>>
<input type='hidden' name='functionPage' value='WorktaskTemplateFrame.jsp'>
<input type="hidden" name="operationType">
<input type="hidden" name="planId">
<input type="hidden" name="tcontent">
<input type="hidden" name="importType" value="0" >
<input type="hidden" name="ishidden" value="1" >
<input type="hidden" id="isCreate" name="isCreate" value="1">
<input type="hidden" id="nodesnum" name="nodesnum" value="1">
<input type="hidden" id="indexnum" name="indexnum" value="1">
<input type="hidden" id="needcheck" name="needcheck" value="wtid" >
<input type="hidden" id="delids" name="delids" >
<input type="hidden" id="editids" name="editids" >
<input type="hidden" id="functionPage" name="functionPage" value="WorktaskTemplate.jsp" >
<input type="hidden" id="orderType" name="orderType" value="">
<input type="hidden" id="orderFieldName" name="orderFieldName" value="">
<input type="hidden" id="orderFieldid" name="orderFieldid" value="">
<input type="hidden" id="srcType" name="srcType" value="">
	  <wea:layout attributes="{layoutTableId:topTitle}">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">

					<input class="e8_btn_top"	onclick="OnNew()" type="button"  value="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage()) %>"/>
			
					<input class="e8_btn_top" onclick="delRow()" type="button"  value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
		
					<input type="text" class="searchInput"  id="searchname" name="searchname" value="" />
		
					<span id="advancedSearch" class="advancedSearch "><%=SystemEnv.getHtmlLabelName(347,user.getLanguage()) %></span>
			
			     	<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>

			</wea:item>
		</wea:group>
	 </wea:layout>
	 <div class="advancedSearchDiv" id="advancedSearchDiv">
		<wea:layout type="fourCol">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(22134, user.getLanguage())%></wea:item>
			    <wea:item>
		    	    <input type="text" class="InputStyle" width="90%" name="taskcontent" value="<%=taskcontent%>">
			    </wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(842, user.getLanguage())%></wea:item>
		    	<wea:item>
				<select id="wtid" name="wtid">
				<option value="0"></option>
				  <%
					for(int i=0; i<wtidList.size(); i++){
						int id_tmp = Util.getIntValue((String)wtidList.get(i), 0);
						String name_tmp = Util.null2String((String)worktaskName_hs.get("worktaskname_"+id_tmp));
						String selectStr = "";
						if(id_tmp == wtid){
							selectStr = "selected";
						}
						out.println("<option value=\""+id_tmp+"\" "+selectStr+">"+name_tmp+"</option>");
					}%>
			    </select>
				</wea:item>
				 <wea:item>
		    	    <%=SystemEnv.getHtmlLabelName(18221, user.getLanguage())%>
			    </wea:item>
				 <wea:item>
		    	   <select id="wakemode" name="wakemode">
						<option value="-1"></option>
						<option value="2" <%if(wakemode==2){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222, user.getLanguage())+SystemEnv.getHtmlLabelName(445, user.getLanguage())%></option>
						<option value="4" <%if(wakemode==4){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222, user.getLanguage())+SystemEnv.getHtmlLabelName(18280, user.getLanguage())%></option>
						<option value="1" <%if(wakemode==1){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222, user.getLanguage())+SystemEnv.getHtmlLabelName(6076, user.getLanguage())%></option>
						<option value="0" <%if(wakemode==0){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222, user.getLanguage())+SystemEnv.getHtmlLabelName(1926, user.getLanguage())%></option>
						<option value="3" <%if(wakemode==3){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222, user.getLanguage())+SystemEnv.getHtmlLabelName(1925, user.getLanguage())%></option>
					</select>
			    </wea:item>
			</wea:group>
		    <wea:group context="">
		    	<wea:item type="toolbar">
		    		<input class="e8_btn_submit" type="button"  onclick='onSearch();' name="search" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>"/>
		    		<input class="e8_btn_cancel" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage()) %>"/>
					<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>"/>
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
      

function browseTable_onmouseover(obj){
	/*
	var e = window.event.srcElement;
	while(e.tagName != "TR"){
		e = e.parentElement;
	}
	*/
	obj.className = "Selected";
}
function browseTable_onmouseout(obj){
	/*
	var e = window.event.srcElement;
	while(e.tagName != "TR"){
		e = e.parentElement;
	}
	*/
	if(obj.rowIndex%2==0){
		obj.className = "DataDark";
	}else{
		obj.className = "DataLight";
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

function onSearch(){
	document.taskform.operationType.value="search";
	document.taskform.submit();
	enableAllmenu();
}

//删除一条记录
function delRowOne(id){

	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage()) %>?',function(){
  	     
		   $("form[name='taskform']").prepend("<input type='hidden'  name='checktask2' value='"+id+"'>"); 
			document.taskform.action = "RequestOperation.jsp";
			document.taskform.operationType.value="multideletetemplate";
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
	 if(option==='multideletetemplate')
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
function delRow(){
    handOp("multideletetemplate");
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

 //打开任务模板窗口
 function doView(requestid){
	openFullWindowHaveBar('/worktask/request/ViewWorktaskTemplate.jsp?requestid='+requestid);
 }

function OnNew(){
	var wtid = document.taskform.wtid.value;
	openFullWindowForXtable("/worktask/request/AddWorktaskTemplateFrame.jsp?wtid="+wtid);
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

<script language="vbs">
sub changelevel(tmpindex)
 	document.taskform.check_con(tmpindex*1).checked = true
end sub

sub onShowBrowser2(id,url,type1)
    
          if type1=8 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=9 then
            tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
			elseif type1=1 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			elseif type1=4 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			elseif type1=16 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			else type1=7 
			tmpids =document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
           end if
	//id1 = window.showModalDialog(url)
		if NOT isempty(id1) then
			resourceids = id1(0)
			resourcename = id1(1)
			resourceids = Mid(resourceids,2,len(resourceids))
			resourcename = Mid(resourcename,2,len(resourcename))	
			document.all("con"+id+"_valuespan").innerHtml =resourcename 
			document.all("con"+id+"_value").value=resourceids
			document.all("con"+id+"_name").value=resourcename
			else
			document.all("con"+id+"_valuespan").innerHtml = empty
			document.all("con"+id+"_value").value=""
			document.all("con"+id+"_name").value=""
		 end if
		
end sub

sub onShowBrowser(id,url)

		id1 = window.showModalDialog(url)
		if NOT isempty(id1) then
		        if id1(0)<> "" then
				document.all("con"+id+"_valuespan").innerHtml = id1(1)
				document.all("con"+id+"_value").value=id1(0)
				document.all("con"+id+"_name").value=id1(1)
			else
				document.all("con"+id+"_valuespan").innerHtml = empty
				document.all("con"+id+"_value").value=""
				document.all("con"+id+"_name").value=""
			end if
		end if
end sub

sub onShowBrowser3(id,url,linkurl,type1,ismand)

	if type1= 2 or type1 = 19 then
	    spanname = "field"+id+"span"
	    inputname = "field"+id
		if type1 = 2 then
		  onFlownoShowDate spanname,inputname,ismand
        else
	      onWorkFlowShowTime spanname,inputname,ismand
		end if
	else
		if  type1 <> 152 and type1 <> 142 and type1 <> 135 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>165 and type1<>166 and type1<>167 and type1<>168 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		else
            if type1=135 then
			tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
			elseif type1=37 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
            elseif type1=142 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?receiveUnitIds="&tmpids)
            elseif type1=165 or type1=166 or type1=167 or type1=168 then
            index=InStr(id,"_")
            if index>0 then
            tmpids=uescape("?isdetail=1&fieldid="& Mid(id,1,index-1)&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            else
            tmpids=uescape("?fieldid="&id&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            end if
            else
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
            end if
		end if
		if NOT isempty(id1) then
			if  type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 then
				if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceidss = Mid(resourceids,2,len(resourceids))
					resourceids = Mid(resourceids,2,len(resourceids))

					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					document.all("field"+id).value= resourceidss
				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if

			else
			   if  id1(0)<>""  and id1(0)<> "0"  then
                   if type1=162 then
				     ids = id1(0)
					names = id1(1)
					descs = id1(2)
					sHtml = ""
					ids = Mid(ids,2,len(ids))
					document.all("field"+id).value= ids
					names = Mid(names,2,len(names))
					descs = Mid(descs,2,len(descs))
					while InStr(ids,",") <> 0
						curid = Mid(ids,1,InStr(ids,","))
						curname = Mid(names,1,InStr(names,",")-1)
						curdesc = Mid(descs,1,InStr(descs,",")-1)
						ids = Mid(ids,InStr(ids,",")+1,Len(ids))
						names = Mid(names,InStr(names,",")+1,Len(names))
						descs = Mid(descs,InStr(descs,",")+1,Len(descs))
						sHtml = sHtml&"<a title='"&curdesc&"' >"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a title='"&descs&"'>"&names&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
				   if type1=161 then
				     name = id1(1)
					desc = id1(2)
				    document.all("field"+id).value=id1(0)
					sHtml = "<a title='"&desc&"'>"&name&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
			        if linkurl = "" then
						document.all("field"+id+"span").innerHtml = id1(1)
					else
						document.all("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&" target='_new'>"&id1(1)&"</a>"
					end if
					document.all("field"+id).value=id1(0)

				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if
			end if
		end if
	end if
end sub

</script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
