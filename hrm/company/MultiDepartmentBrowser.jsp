
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css"></HEAD>

<%
String requestname = Util.null2String(request.getParameter("requestname"));
String isrequest = Util.null2String(request.getParameter("isrequest"));
String sqlwhere = "";
if (isrequest.equals("")) isrequest = "1";

String userid = ""+user.getUID() ;
String usertype="0";

if(user.getLogintype().equals("2")) usertype="1";

String  check_per= Util.null2String(request.getParameter("resourceids"));

String resourceids = "";
String resourcenames = "";

if (!check_per.equals("")) {
	String strtmp = "select id,departmentname from hrmDepartment  where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while (RecordSet.next()) {
		ht.put( Util.null2String(RecordSet.getString("id")), Util.null2String(RecordSet.getString("departmentname")));
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("departmentname");
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

if(!requestname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where departmentname like '%" + Util.fromScreen2(requestname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and departmentname like '%" + Util.fromScreen2(requestname,user.getLanguage()) +"%' ";
}

if (sqlwhere.equals("")) sqlwhere = " where id <> 0 " ;
String sqlstr = "" ;
String temptable = "wftemptable"+ Util.getNumberRandom() ;
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=60;

sqlwhere +=" and  canceled is null";
if(RecordSet.getDBType().equals("oracle")){
		sqlstr = "create table "+temptable+"  as select * from (select distinct id ,departmentname from hrmDepartment " + sqlwhere + "  order by id) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
		sqlstr = "create table "+temptable+"  as (select distinct id ,departmentname from hrmDepartment ) definition only ";

        RecordSet.executeSql(sqlstr);

       sqlstr = "insert  into "+temptable+" (select id ,departmentname from hrmDepartment " + sqlwhere + " order by id    fetch  first "+(pagenum*perpage+1)+" rows only )" ;
}else{
		sqlstr = "select distinct top "+(pagenum*perpage+1)+" id ,departmentname  into "+temptable+" from hrmDepartment " + sqlwhere + " order by id" ;
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
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+" order by id ";
}
RecordSet.executeSql(sqltemp);
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	
	<td valign="top" style="height:100%">
		<!--########Shadow Table Start########-->
<TABLE class=Shadow style="height:100%;">
		<tr style="height:1px;">
		<td valign="top" colspan="2">

		<FORM id=weaver name=SearchForm style="margin-bottom:0;" action="MultiDepartmentBrowser.jsp" method=post>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="resourceids" value="">
		<input type="hidden" name="isrequest" value='<%=isrequest%>'>
		<!--##############Right click context menu buttons START####################-->
			<DIV align=right style="display:none">
			<%
			BaseBean baseBean_self = new BaseBean();
		    int userightmenu_self = 1;
		    try{
		    	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
		    }catch(Exception e){}
		    if(userightmenu_self == 1){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
		    }
			%>
			<button type="button" class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
			<button type="button" class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
			<button type="button" class=btn accessKey=T onclick="btncancel_onclick()" ><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
			<button type="button" class=btn accessKey=2 id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
		<!--##############Right click context menu buttons END//####################-->
		<!--######## Search Table Start########-->
	<table width=100% class="viewform" style="height:1px">
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <input name=requestname class=Inputstyle value="<%=requestname%>">
      </TD>
    </TR><TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
    
  </table>
<!--#################Search Table END//######################-->
<tr width="100%">
<td width="50%" valign="top">
	<!--############Browser Table START################-->
	<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0" style="width:100%;height:100%;">
		<TR class=DataHeader>
	  <TH width=10% style=""></TH>
	  <TH width=90%><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></TH>
    	</TR>
	  <TR class=Line style="height:1px;"><Th colspan="3" ></Th></TR>

		<tr>
		<td colspan="3" width="100%" valign="top">
			<div style="overflow-y:scroll;width:100%;height:100%">
			<table width="100%" id="BrowseTable" style="width:100%;height:100%;">
			<COLGROUP>
			<COL width="10%">
			<COL width="90%">
			
				<%
				int i=0;
				int totalline=1;
				if(RecordSet.last()){
					do{
					String requestids = RecordSet.getString("id");
					String requestnames = Util.toScreen(RecordSet.getString("departmentname"),user.getLanguage());
				
					if(i==0){
						i=1;
				%>
					<TR class=DataLight>
					<%
						}else{
							i=0;
					%>
					<TR class=DataDark>
					<%
					}
					%>
					<TD style="display:none"><A HREF=#><%=requestids%></A></TD>
		             <TD colspan="2"> <%=requestnames%></TD>
		             
		
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
<td width="50%" valign="top" style="height:100%;">
	<!--########Select Table Start########-->
	<table  cellspacing="1" align="left" width="100%" height="100%">
		<tr>
			<td align="center" valign="top" width="30%">
				<img src="/images/arrow_u_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
				<br><br>
					<img src="/images/arrow_all_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="/images/arrow_out_wev8.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="/images/arrow_all_out_wev8.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList();">
				<br><br>
				<img src="/images/arrow_d_wev8.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
			</td>
			<td align="center" valign="top" width="70%">
				<select size="15" name="srcList" multiple="true" style="width:100%;word-wrap:break-word;height:100%;" >
				</select>
			</td>
		</tr>
		
	</table>
	<!--########//Select Table End########-->

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
<tr style="height:1px;">
	<td height="10" colspan="3"></td>
</tr>
<tr width=100% style="height:1px;">
     <td align="center" valign="bottom" colspan=3>
     
        <button type="button" class=btnSearch accessKey=S  id=btnsub onclick="btnsub_onclick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
     
	<button type="button" class=btn accessKey=O  id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=2  id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <button type="button" class=btn accessKey=T  id=btncancel onclick="btncancel_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
     </td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>



<script type="text/javascript">
<!--
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
	}catch(e){}

	resourceids = "<%=resourceids%>";
	resourcenames = "<%=resourcenames%>";
	function btnclear_onclick(){
	    var returnjson = {id:"",name:""};
		if(dialog){
			try{
				dialog.callback(returnjson);
			}catch(e){}
			try{
				dialog.close(returnjson);
			}catch(e){}
		}else{
			window.parent.returnValue = returnjson;
			window.parent.close();
		}
	}


function btnok_onclick(){
	setResourceStr();
	var returnjson = {id:resourceids,name:resourcenames};
	if(dialog){
		try{
			dialog.callback(returnjson);
		}catch(e){}
		try{
			dialog.close(returnjson);
		}catch(e){}
	}else{
		window.parent.returnValue = returnjson;
		window.parent.close();
	}
}

function btnsub_onclick(){
    setResourceStr();
   $("#resourceids").val(resourceids);
   document.SearchForm.submit();
}

function btncancel_onclick(){
	if(dialog){
		try{
			dialog.close();
		}catch(e){}
	}else{
		window.parent.close();
	}
}
	
$("#BrowseTable").bind("click",function(e){
	var target =  e.srcElement||e.target ;
	try{
		if(target.nodeName == "TD" || target.nodeName == "A"){
			var newEntry = $($(target).parents("tr")[0].cells[0]).text()+"~"+jQuery.trim($($(target).parents("tr")[0].cells[1]).text()) ;
			if(!isExistEntry(newEntry,resourceArray)){
				addObjectToSelect($("select[name=srcList]")[0],newEntry);
				reloadResourceArray();
			}
		}
	}catch (en) {
		window.top.Dialog.alert(en.message);
	}
})
$("#BrowseTable").bind("mouseover",function(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
});
$("#BrowseTable").bind("mouseout",function(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark";
      }else{
         p.className = "DataLight";
      }
   }
});
//-->
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
	var selectObj = $("select[name=srcList]")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}
/**
加入一个object 到Select List
 格式object ="1~董芳"
*/
function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str);
	
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	oOption.value = str.split("~")[0];
	$(oOption).text(str.split("~")[1]);
	
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
	var destList  = $("select[name=srcList]")[0];
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
	var table =$("#BrowseTable");
	$("#BrowseTable").find("tr").each(function(){
		var str=$($(this)[0].cells[0]).text()+"~"+$($(this)[0].cells[1]).text();
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect($("select[name=srcList]")[0],str);
	});
	reloadResourceArray();
}

function deleteFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = $("select[name=srcList]")[0];
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
	var destList =$("select[name=srcList]")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+jQuery.trim(destList.options[i].text) ;
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
	$("input[name=resourceids]").val( resourceids.substring(1));
}

function doSearch()
{
	setResourceStr();
    $("resourceids").val(resourceids.substring(1)) ;
    document.SearchForm.submit();
}
</script>