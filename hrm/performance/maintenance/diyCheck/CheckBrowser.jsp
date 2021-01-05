<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />

<HTML><HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver.css"></HEAD>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

<%
String ruleName = Util.null2String(request.getParameter("ruleName"));

String sqlwhere = "";

String isrequest = Util.null2String(request.getParameter("isrequest"));
if (isrequest.equals("")) isrequest = "1";
String userid = ""+user.getUID() ;
String usertype="0";



String check_per = Util.null2String(request.getParameter("resourceids"));

String resourceids = "";
String resourcenames = "";

if (!check_per.equals("")) {
	String strtmp = "select id,ruleName,memo from HrmPerformanceCheckRule  where status='0' and id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while (RecordSet.next()) {
		ht.put( Util.null2String(RecordSet.getString("id")), Util.null2String(RecordSet.getString("ruleName")));
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("ruleName");
		}
		*/
	}
	try{
		StringTokenizer st = new StringTokenizer(check_per,",");

		while(st.hasMoreTokens()){
			String s = st.nextToken();
			if(ht.containsKey(s)){//如果check_per中的已选的流程此时不存在会出错
				resourceids +=","+s;
				resourcenames += ","+ht.get(s).toString();
			}
		}
	}catch(Exception e){
		resourceids ="";
		resourcenames ="";
	}
}

int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!ruleName.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where ruleName like '%" + Util.fromScreen2(ruleName,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and ruleName like '%" + Util.fromScreen2(ruleName,user.getLanguage()) +"%' ";
}





if (sqlwhere.equals("")) sqlwhere = " where HrmPerformanceCheckRule.id <> 0 and status='0'  " ;

String sqlstr = "" ;
String temptable = "wftemptable"+ Util.getNumberRandom() ;
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=50;

if(RecordSet.getDBType().equals("oracle")){
		sqlstr = "create table "+temptable+"  as select * from (select distinct HrmPerformanceCheckRule.id ,ruleName,memo  from HrmPerformanceCheckRule" + sqlwhere + "  order by id) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
		sqlstr = "create table "+temptable+"  as (select distinct HrmPerformanceCheckRule.id ,ruleName,memo from HrmPerformanceCheckRule ) definition only ";

        RecordSet.executeSql(sqlstr);

       sqlstr = "insert  into "+temptable+" (select  HrmPerformanceCheckRule.id ,ruleName,memo  from  HrmPerformanceCheckRule " + sqlwhere + "order by id   fetch  first "+(pagenum*perpage+1)+" rows only )" ;
}else{
		sqlstr = "select distinct top "+(pagenum*perpage+1)+" HrmPerformanceCheckRule.id ,ruleName,memo into "+temptable+" from HrmPerformanceCheckRule  " + sqlwhere + " order by id " ;
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
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td width="3%"></td>
	<td valign="top">
		<!--########Shadow Table Start########-->
<TABLE class=Shadow>
		<tr>
		<td valign="top" colspan="2">

		<FORM id=weaver name=SearchForm style="margin-bottom:0" action="CheckBrowser.jsp" method=post>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
		<input type="hidden" name="pagenum" value=''>
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
		<!--##############Right click context menu buttons END//####################-->
		<!--######## Search Table Start########-->
	<table width=100% class="viewform">
    <TR>
      <TD width=10%><%=SystemEnv.getHtmlLabelName(18094,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <input name=ruleName class=Inputstyle value="<%=ruleName%>">
      </TD>
    </TR>
    <TR class="Spacing">
      <TD class="Line1" colspan=4></TD>
    </TR>
  </table>
<!--#################Search Table END//######################-->
<tr width="100%">
<td width="60%">
	<!--############Browser Table START################-->
	<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0">
		<TR class=DataHeader>
	  <TH width=1%></th>
	  <TH width=50%><%=SystemEnv.getHtmlLabelName(18094,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
	  <TH width=40%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
   
	  <TR class=Line><Th colspan="3" ></Th></TR>

		<tr>
		<td colspan="3" width="100%">
			<div style="overflow-y:scroll;width:100%;height:350px">
			<table width="100%" id="BrowseTable">
			<COLGROUP>
			<COL width="40%">
			<COL width="30%">
			<COL width="30%">
				<%
				int i=0;
				int totalline=1;
				if(RecordSet.last()){
					do{
					String requestids = RecordSet.getString("id");
					String requestnames = Util.toScreen(RecordSet.getString("ruleName"),user.getLanguage());
				    String memo=Util.toScreen(RecordSet.getString("memo"),user.getLanguage());
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
					<TD style="display:none"><A HREF=#><%=requestids%></A></TD>
		            <TD><%=requestnames%></TD>
                    <TD><%=memo%></TD>
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
									<button type=submit class=btn accessKey=P id=prepage onclick="setResourceStr();document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
							   <%}%>
						   </td>
						   <td>
							   <%if(hasNextPage){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
									<button type=submit class=btn accessKey=N  id=nextpage onclick="setResourceStr();document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
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
<!--##########Browser Table END//#############-->
<!-- td width="40%" valign="top"-->
	<!--########Select Table Start########-->
	<!-- table  cellspacing="1" align="left" width="100%">
		<tr>
			<td align="center" valign="top" width="30%">
				<img src="/images/arrow_u.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
				<br><br>
					<img src="/images/arrow_all.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="/images/arrow_out.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="/images/arrow_all_out.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList();">
				<br><br>
				<img src="/images/arrow_d.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
			</td>
			<td align="center" valign="top" width="70%">
				<select size="15" name="srcList" multiple="true" style="width:100%;word-wrap:break-word" >
				</select>
			</td>
		</tr>
		
	</table-->
	<!--########//Select Table End########-->

<!-- /td-->
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
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>

<script>
function btnok_click(a,b){
	 setResourceStr();
	 window.parent.returnValue ={id:a,name:b};
     window.parent.close();
}

function btnclear_onclick(){
     window.parent.returnValue ={id:"",name:""};
     window.parent.close();
}
</script>

<SCRIPT LANGUAGE=VBS>
resourceids = "<%=resourceids%>"
resourcenames = "<%=resourcenames%>"
Sub btnclear_onclick2()
	alert(11)
     window.parent.returnvalue = convertStr(Array("",""))
     window.parent.close
End Sub


Sub btnok_click1(a,b)
	 setResourceStr()
	 window.parent.returnvalue = Array(a,b)
     window.parent.close
End Sub

Sub btnsub_onclick()
    setResourceStr()
    document.all("resourceids").value = resourceids
    document.SearchForm.submit
End Sub

sub onShowManagerID(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

sub getTheDate(inputname,spanname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub
</SCRIPT>
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
    enablemenu();
}
</SCRIPT>