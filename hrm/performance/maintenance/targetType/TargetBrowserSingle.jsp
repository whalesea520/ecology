<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver.css"></HEAD>

<%
String targetName = Util.null2String(request.getParameter("targetName"));
String targetTypeId = Util.null2String(request.getParameter("targetTypeId"));
String cycle = Util.null2String(request.getParameter("cycle"));
String type_l = Util.null2String(request.getParameter("type_l"));

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
if(!targetName.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where a.targetName like '%" + Util.fromScreen2(targetName,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and a.targetName like '%" + Util.fromScreen2(targetName,user.getLanguage()) +"%' ";
}
if(!targetTypeId.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where a.targetid=" + Util.getIntValue(targetTypeId) +" ";
	}
	else
		sqlwhere += " and a.targetid=" + targetTypeId +" ";
}
if(!cycle.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where a.cycle='" + cycle +"' ";
	}
	else
		sqlwhere += " and a.cycle='" + cycle +"' ";
}
if(!type_l.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where a.type_l='" + type_l +"' ";
	}
	else
		sqlwhere += " and a.type_l='" + type_l +"' ";
}


if (sqlwhere.equals("")) sqlwhere = " where a.id <> 0 " ;

String sqlstr = "" ;
String temptable = "wftemptable"+ Util.getNumberRandom() ;
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=50;

if(RecordSet.getDBType().equals("oracle")){
		sqlstr = "create table "+temptable+"  as select * from (select a.id ,a.targetName,a.type_l,a.cycle,a.memo,b.targetname AS targetTypeName  from HrmPerformanceTargetDetail a,HrmPerformanceTargetType b " + sqlwhere + " AND a.targetid=b.id order by a.id DESC) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
		sqlstr = "create table "+temptable+"  as (select a.id ,a.targetName,a.type_l,a.cycle,a.memo,b.targetname AS targetTypeName from HrmPerformanceTargetDetail ) definition only ";

        RecordSet.executeSql(sqlstr);

       sqlstr = "insert  into "+temptable+" (select a.id ,a.targetName,a.type_l,a.cycle,a.memo,b.targetname AS targetTypeName " + sqlwhere + " AND a.targetid=b.id order by a.id DESC fetch  first "+(pagenum*perpage+1)+" rows only )" ;
}else{
		sqlstr = "select  top "+(pagenum*perpage+1)+" a.id ,a.targetName,a.type_l,a.cycle,a.memo,b.targetName AS targetTypeName into "+temptable+" from HrmPerformanceTargetDetail a,HrmPerformanceTargetType b " + sqlwhere + " AND a.targetid=b.id order by a.id DESC" ;
}


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
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<!--########Shadow Table Start########-->
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

		<FORM id=weaver name=SearchForm style="margin-bottom:0" action="TargetBrowserSingle.jsp" method=post>
		<input type="hidden" name="sqlwhere" value="<%=xssUtil.put(sqlwhere)%>">
		<input type="hidden" name="pagenum" id="pagenum" value="">
		<input type="hidden" name="resourceids" value="">
		<input type="hidden" name="isrequest" value='<%=isrequest%>'>
		<!--##############Right click context menu buttons START####################-->
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
		<!--##############Right click context menu buttons END//####################-->
		<!--######## Search Table Start########-->
		<table width=100% class="viewform">
		<col width="15%">
		<col width="34%">
		<col width="2%">
		<col width="15%">
		<col width="34%">
		
		 <TR>
			<TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
			<TD width=35% class=field>
			  <input name=targetName class=Inputstyle value="<%=targetName%>">
			</TD>
			<td></td>
			<td><%=SystemEnv.getHtmlLabelName(18085,user.getLanguage())%></td>
			<td class=field>
				<select style="width:100%" name="targetTypeId">	
				<option></option>
				<%
				String sqlTargetType = "SELECT * FROM HrmPerformanceTargetType ORDER BY id ASC";
				rs.executeSql(sqlTargetType);
				while(rs.next()){
					out.println("<option value='"+rs.getInt("id")+"' ");
					if(rs.getInt("id")==Util.getIntValue(targetTypeId))	out.println(" selected");
					out.println(">");
					out.println(rs.getString("targetName"));
					out.println("</option>");
				}
				%>
				</select>
			</td>
		 </TR>
		 <tr><td colspan="5" class="line"></td></tr>
		 <tr>
			<td><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></td>
			<td class=field><select class=inputStyle id=cycle 
              name=cycle>
                <option></option>
                <option value="3" <%if(cycle.equals("3"))out.println("selected");%>><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></option>
                <option value="2" <%if(cycle.equals("2"))out.println("selected");%>><%=SystemEnv.getHtmlLabelName(18059,user.getLanguage())%></option>
                <option value="1" <%if(cycle.equals("1"))out.println("selected");%>><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></option>
                <option value="0" <%if(cycle.equals("0"))out.println("selected");%>><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></option>
             </select></td>
			<td></td>
			<td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
			<td class=field><select class=inputStyle id=type_l 
              name=type_l>
                <option></option>
                <option value="0" <%if(type_l.equals("0"))out.println("selected");%>><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></option>
                <option value="1" <%if(type_l.equals("1"))out.println("selected");%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                <option value="2" <%if(type_l.equals("2"))out.println("selected");%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                <option value="3" <%if(type_l.equals("3"))out.println("selected");%>><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>
             </select></td>
		 </tr>
		 <TR class="Spacing">
			<TD class="Line1" colspan=5></TD>
		 </TR>
	  </table>
	<!--#################Search Table END//######################-->
<tr width="100%">
<td width="60%">
	<!--############Browser Table START################-->
	<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0">
		<TR class=DataHeader>
	  <TH width=40%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
	  <TH width=20%><%=SystemEnv.getHtmlLabelName(18085,user.getLanguage())%></TH>
		<TH width=10%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TH>
		<TH width=10%><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></TH>
	  <TR class=Line><Th colspan="4" ></Th></TR>

		<tr>
		<td colspan="4" width="100%" valign="top">
			<div style="overflow-y:scroll;width:100%;height:358px">
			<table width="100%" id="BrowseTable">
			<COLGROUP>
			<COL width="40%">
			<COL width="20%">
			<COL width="10%">
			<COL width="10%">
				<%
				int i=0;
				int totalline=1;
				if(RecordSet.last()){
					do{
					String requestids = RecordSet.getString("id");
					String requestnames = Util.toScreen(RecordSet.getString("targetName"),user.getLanguage());
				    String memo= RecordSet.getString("targetTypeName");
					//int num = RecordSet.getInt("num");
					if(i==0){
						i=1;
				%>
					<TR class=DataLight onclick="javascript:btnok_click(<%=requestids%>,'<%=requestnames%>')">
					<%
						}else{
							i=0;
					%>
					<TR class=DataDark onclick="javascript:btnok_click(<%=requestids%>,'<%=requestnames%>')">
					<%
					}
					%>
					
		            <TD><%=requestnames%></TD>
						<TD><%=memo%></TD>
						<td align="center">
						 <%//0：公司，1：分部，2：部门 3：个人
						 if ((Util.null2String(RecordSet.getString("type_l"))).equals("0"))
						 { 
						 out.print(SystemEnv.getHtmlLabelName(1851,user.getLanguage()));
						 }
						 else if ((Util.null2String(RecordSet.getString("type_l"))).equals("1"))
						  {out.print(SystemEnv.getHtmlLabelName(141,user.getLanguage()));
						 }
						  else if ((Util.null2String(RecordSet.getString("type_l"))).equals("2"))
						  {out.print(SystemEnv.getHtmlLabelName(124,user.getLanguage()));
						 }
						  else if ((Util.null2String(RecordSet.getString("type_l"))).equals("3"))
						  {
						  out.print(SystemEnv.getHtmlLabelName(6087,user.getLanguage()));
						 }
						 %>
						</td>
						<td align="center">
						<%
						//0：月，1：极度，2：年中 3：年
						if ((Util.null2String(RecordSet.getString("cycle"))).equals("3"))
						 { 
						 out.print(SystemEnv.getHtmlLabelName(445,user.getLanguage()));
						 }
						 else if ((Util.null2String(RecordSet.getString("cycle"))).equals("2"))
						 {
						  out.print(SystemEnv.getHtmlLabelName(18059,user.getLanguage()));
						 }
						  else if ((Util.null2String(RecordSet.getString("cycle"))).equals("1"))
						  {out.print(SystemEnv.getHtmlLabelName(17495,user.getLanguage()));
						 }
						  else if ((Util.null2String(RecordSet.getString("cycle"))).equals("0"))
						  {out.print(SystemEnv.getHtmlLabelName(6076,user.getLanguage()));
						 }
						 %>
						</td>
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
		<!--##############Shadow Table END//######################-->
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="4"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>

<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>

	<script language="javascript" for="BrowseTable" event="onclick">
	var e =  window.event.srcElement ;
	if(e.tagName == "TD" || e.tagName == "A"){
		var newEntry = e.parentElement.cells(0).innerText+"~"+e.parentElement.cells(1).innerText ;
		//alert(newEntry);
		if(!isExistEntry(newEntry,resourceArray)){
			addObjectToSelect(document.all("srcList"),newEntry);
			reloadResourceArray();
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
var resourceids = "<%=resourceids%>"
var resourcenames = "<%=resourcenames%>"

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

function btnok_click(a,b){
	 window.parent.returnValue =new Array(a,b);
     window.parent.close();
}
</SCRIPT>