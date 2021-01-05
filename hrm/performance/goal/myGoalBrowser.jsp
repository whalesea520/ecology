<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.goal.GoalUtil" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML>
<%
int currentCycle = Util.getIntValue(request.getParameter("cycle"));
int goalType = Util.getIntValue((String)SessionOper.getAttribute(session,"goalType"));
int objId = ((Integer)SessionOper.getAttribute(session,"objId")).intValue();
String goalDate = (String)SessionOper.getAttribute(session,"goalDate");

HashMap orgIdName = GoalUtil.getOrgIdName(goalType,objId);
int parentOrgId = Util.getIntValue((String)orgIdName.get("parentOrgId"));
String parentOrgName = (String)orgIdName.get("parentOrgName");
String objOrgName = (String)orgIdName.get("objOrgName");


String goalName = Util.null2String(request.getParameter("goalName"));
String filterParam = Util.null2String(request.getParameter("filterParam"));
String filterCycle = Util.null2String(request.getParameter("filterCycle"));
String sqlwhere = "";

String isrequest = Util.null2String(request.getParameter("isrequest"));

if (isrequest.equals("")) isrequest = "1";
String userid = ""+user.getUID() ;
String usertype="0";



String check_per = Util.null2String(request.getParameter("resourceids"));

String resourceids = "";
String resourcenames = "";


int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!goalName.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where a.goalName like '%" + Util.fromScreen2(goalName,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and a.goalName like '%" + Util.fromScreen2(goalName,user.getLanguage()) +"%' ";
}

//TD4018
//modified by hubo,2006-03-22
if (sqlwhere.equals("")) sqlwhere = " where a.id<>0 AND a.goaldate LIKE '"+goalDate.substring(0,4)+"%' ";

//param
sqlwhere += " AND a.status='3'";
String objname = "";
if(filterParam.equals("")){
	sqlwhere += " AND (a.objId="+parentOrgId+" OR a.objId="+objId+")";
}else if(filterParam.equals("filterIsParent")){
	sqlwhere += " AND a.objId="+parentOrgId+"";
	objname = parentOrgName;
}else if(filterParam.equals("filterIsSelf")){
	sqlwhere += " AND a.objId="+objId+"";
	objname = objOrgName;
}
if(!filterCycle.equals("")){
	sqlwhere += " AND a.cycle='"+filterCycle+"'";
}

String sqlstr = "" ;
String temptable = "goaltemptable"+ Util.getNumberRandom() ;
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=50;

if(RecordSet.getDBType().equals("oracle")){
		sqlstr = "create table "+temptable+"  as select * from (select a.id ,a.goalName,a.goalCode,a.cycle,a.goalType,a.objId,b.id as targetid,b.targetName  from HrmPerformanceGoal a,  HrmPerformanceTargetType b " + sqlwhere + "  AND a.type_t=b.id order by a.id DESC) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
		sqlstr = "create table "+temptable+"  as (select a.id ,a.goalName,a.goalCode,a.cycle,a.goalType,a.objId,b.id as targetid,b.targetName from HrmPerformanceGoal a,HrmPerformanceTargetType b" + sqlwhere + "  AND a.type_t=b.id order by a.id DESC) definition only ";

        RecordSet.executeSql(sqlstr);

       sqlstr = "insert  into "+temptable+" (select  a.id ,a.goalName,a.goalCode,a.cycle,a.goalType,a.objId,b.id as targetid,b.targetName  from  HrmPerformanceGoal a,HrmPerformanceTargetType b" + sqlwhere + " AND a.type_t=b.id order by a.id DESC fetch  first "+(pagenum*perpage+1)+" rows only )" ;
}else{
		sqlstr = "select top "+(pagenum*perpage+1)+" a.id ,a.goalName,a.goalCode,a.cycle,a.goalType,a.objId,b.id as targetid,b.targetName  into "+temptable+" from HrmPerformanceGoal a,HrmPerformanceTargetType b " + sqlwhere + "  AND a.type_t=b.id ORDER BY a.id DESC" ;
}

//out.println(sqlstr);
RecordSet.executeSql(sqlstr);


RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}

String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by id ) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
    sqltemp="select  * from "+temptable+"  order by id fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only ";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by id ";
}
RecordSet.executeSql(sqltemp);
%>

<HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver.css">
<script type="text/javascript">
window.onload = setOptionSelected;
function setOptionSelected(){
	var a = document.getElementById("filterParam");
	var b = document.getElementById("filterCycle");
	if("<%=filterParam%>"=="filterIsSelf"){
		if(<%=goalType%>=="0"){
			a.options[1].selected = true;
		}else{
			a.options[2].selected = true;
		}
	}
	if("<%=filterParam%>"=="filterIsParent"){
		a.options[1].selected = true;
	}
	switch("<%=filterCycle%>"){
		case "0":
			b.options[4].selected = true;
			break;
		case "1":
			b.options[3].selected = true;
			break;
		case "2":
			b.options[2].selected = true;
			break;
		case "3":
			b.options[1].selected = true;
			break;
	}
}
</script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td></td>
	<td valign="top">
<TABLE class=Shadow>
		<tr>
		<td valign="top" colspan="2">

		<FORM id=weaver name=SearchForm style="margin-bottom:0" action="myGoalBrowser.jsp" method=post>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="resourceids" value="">
		<input type="hidden" name="isrequest" value='<%=isrequest%>'>
		<input type="hidden" name="cycle" value="<%=currentCycle%>">
			<DIV align=right style="display:none">
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>


			<%
			
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:SearchForm.btnok.click(),_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;
			
			%>
			<BUTTON class=btn accessKey=O id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>

			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=2 id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
	<table width=100% class="viewform">
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(18238,user.getLanguage())%></TD>
      <TD width=85% class=field>
        <input name=goalName class=Inputstyle value="<%=goalName%>" style="width:100%">
      </TD>
    </TR>
	 <tr>
		<td colspan="2">
		<table style="width:100%">
			<tr>
			<td width=15%><%=SystemEnv.getHtmlLabelName(18239,user.getLanguage())%></td>
			<td width=34% class=field>
			<select name="filterParam" id="filterParam" style="width:100%">
			<option value="" <%if("".equals(filterParam)) {%> selected <%}%>></option>
			<%if(goalType==0){%>
			<option value="filterIsSelf" <%if(filterParam.equals("filterIsSelf")) {%> selected <%}%>><%=objOrgName%></option>
			<%}else{%>
			<option value="filterIsParent" <%if(filterParam.equals("filterIsParent")) {%> selected <%}%>><%=parentOrgName%></option>
			<option value="filterIsSelf" <%if(filterParam.equals("filterIsSelf")) {%> selected <%}%>><%=objOrgName%></option>
			<%}%>
			</select>
			</td>
			<td width="2%"></td>
			<td width="15%"><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></td>
			<td width="34%" class=field>
			<select name="filterCycle" id="filterCycle" style="width:100%">
				<option value="" <%if("".equals(filterCycle)) {%> selected <%}%>></option>
				<option value="3" <%if("3".equals(filterCycle)) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></option>
				<option value="2" <%if("2".equals(filterCycle)) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18059,user.getLanguage())%></option>
				<option value="1" <%if("1".equals(filterCycle)) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></option>
				<option value="0" <%if("0".equals(filterCycle)) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></option>
			</select>		
			</td>
			</tr>
		</table>
		</td>
	 </tr>
	 <TR class="Spacing">
      <TD class="Line1" colspan=4></TD>
    </TR>
  </table>
<tr width="100%">
<td width="60%">
	<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0" style="width: 100%">
		<TR class=DataHeader>
	  <TH width=50%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
	  <TH width=20%><%=SystemEnv.getHtmlLabelName(18239,user.getLanguage())%></TH>
	  <TH width=10%><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></TH>
		
	  <TR class=Line><Th colspan="5" ></Th></TR>

		<tr>
		<td colspan="5" width="100%">
			<div style="overflow-y:scroll;width:100%;height:350px">
			<table width="100%" id="BrowseTable">
			<COLGROUP>
			<COL width="50%">
			<COL width="20%">
			<COL width="10%">
				<%
				int i=0;
				int totalline=1;
				HashMap orgIdName2 = new HashMap();
				
				if(RecordSet.last()){
					do{
					String requestids = RecordSet.getString("id");
					String requestnames = Util.toScreen(RecordSet.getString("goalName"),user.getLanguage());
					String targetId = RecordSet.getString("targetid");
					String targetName = RecordSet.getString("targetname");
				    String memo= RecordSet.getString("goalCode");
					 String cycle = RecordSet.getString("cycle");
					 String goalType2 = RecordSet.getString("goalType");
					int objId2 = RecordSet.getInt("objId");
					//TD3851
					//modified by hubo,2006-03-21
					if(objId2==objId && Util.getIntValue(cycle)<=currentCycle)	continue;
					orgIdName2 = GoalUtil.getOrgIdName(Util.getIntValue(goalType2),objId2);
					String objname2 = (String)orgIdName2.get("objOrgName");
					if (!"".equals(objname) && !objname.equals(objname2)) continue;
					if ("".equals(objname) && !objname2.equals(parentOrgName) && !objname2.equals(objOrgName)) continue;
					if(i==0){
						i=1;
				%>
					<TR class=DataLight onclick='btnok_click("<%=requestids%>","<%=requestnames%>","<%=targetId%>","<%=targetName%>")'>
					<%
						}else{
							i=0;
					%>
					<TR class=DataDark onclick='btnok_click("<%=requestids%>","<%=requestnames%>","<%=targetId%>","<%=targetName%>")'>
					<%
					}
					%>
					
					<TD><%=requestnames%></TD>
					<td><%=(String)orgIdName2.get("objOrgName")%></td>
					<td align="center"><%=SystemEnv.getHtmlLabelName(GoalUtil.getCycleLabelIdByKey(Util.getIntValue(cycle)),user.getLanguage())%></td>		
				</TR>
				<%
					if(hasNextPage){
						totalline+=1;
						if(totalline>perpage)	break;
					}
				}while(RecordSet.previous());
				}
				RecordSet.executeSql("drop table "+temptable);
				%>
						</table>
						<table align=right style="display:none">
						<tr>
						   <td>
							   <%if(pagenum>1){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
									<button type=submit class=btn accessKey=P id=prepage onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
							   <%}%>
						   </td>
						   <td>
							   <%if(hasNextPage){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
									<button type=submit class=btn accessKey=N  id=nextpage onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
							   <%}%>
						   </td>
						   <td>&nbsp;</td>
						</tr>
						</table>
			</div>
		</td>
	</tr>
	</TABLE>
</td>

</tr>

	</FORM>

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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>

<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<script language="javascript">

var resourceids = "<%=resourceids%>";
var resourcenames = "<%=resourcenames%>";

function btnok_click(a,b,c,d){
	 window.parent.returnValue ={"id":a,"name":b,"targetId":c,"targetName":d};
     window.parent.close();
}

function btnclear_onclick(){
     window.parent.returnValue ={"requestids":"","requestnames":"","targetId":"","targetName":""};
     window.parent.close();
}

function btnsub_onclick(){
    setResourceStr();
    document.all("resourceids").value = resourceids;
    $G("SearchForm").submit();
}
</script>
	<script language="javascript" for="BrowseTable" event="onclick">
	var e =  window.event.srcElement ;
	if(e.tagName == "TD" || e.tagName == "A"){
		var newEntry = e.parentElement.cells(0).innerText+"~"+e.parentElement.cells(1).innerText ;
		//alert(newEntry);
		if(!isExistEntry(newEntry,resourceArray)){
			//addObjectToSelect(document.all("srcList"),newEntry);
			//reloadResourceArray();
		}
	}
</script>

<script language="javascript" for="BrowseTable" event="onmouseover">
	var eventObj = window.event.srcElement ;
	if(eventObj.tagName =='TD'){
		var trObj = eventObj.parentElement ;
		trObj.className ="Selected";
	}else if (eventObj.tagName == 'A'){
		var trObj = eventObj.parentElement.parentElement;
		trObj.className = "Selected";
	}
</script>

<script language="javascript" for="BrowseTable" event="onmouseout">
	var eventObj = window.event.srcElement ;
	if(eventObj.tagName =='TD'){
		var trObj = eventObj.parentElement ;
		if(trObj.rowIndex%2 == 0)
			trObj.className ="DataLight";
		else
			trObj.className ="DataDark";
	}else if (eventObj.tagName == 'A'){
		var trObj = eventObj.parentElement.parentElement;
		if(trObj%2 == 0)
			trObj.className ="DataLight";
		else
			trObj.className ="DataDark";
	}
</script>
<script language="javascript">
//var resourceids = "<%=resourceids%>"
//var resourcenames = "<%=resourcenames%>"

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = document.all("srcList");
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}
/**
加入一个object 到Select List

*/
function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str);
	
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	oOption.value = str.split("~")[0];
	oOption.innerText = str.split("~")[1];
	
}

function isExistEntry(entry,arrayObj){
	for(var i=0;i<arrayObj.length;i++){
		if(entry == arrayObj[i].toString()){
			return true;
		}
	}
	return false;
}

function upFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
function addAllToList(){
	var table =document.all("BrowseTable");
	//alert(table.rows.length);
	for(var i=0;i<table.rows.length;i++){
		var str = table.rows(i).cells(0).innerText+"~"+table.rows(i).cells(1).innerText ;
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect(document.all("srcList"),str);
	}
	reloadResourceArray();
}

function deleteFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = document.all("srcList");
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
	}
	//alert(resourceArray.length);
}

function setResourceStr(){
	
	resourceids ="";
	resourcenames = "";
	for(var i=0;i<resourceArray.length;i++){
		resourceids += ","+resourceArray[i].split("~")[0] ;
		resourcenames += ","+resourceArray[i].split("~")[1] ;
	}
	//alert(resourceids+"--"+resourcenames);
	document.all("resourceids").value = resourceids.substring(1)
}

function doSearch()
{
	setResourceStr();
    document.all("resourceids").value = resourceids.substring(1) ;
    document.SearchForm.submit();
}
</SCRIPT>