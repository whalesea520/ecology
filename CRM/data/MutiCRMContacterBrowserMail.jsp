
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
int crmId = Util.getIntValue(request.getParameter("crmId"));
String name = Util.null2String(request.getParameter("name"));
String engname = Util.null2String(request.getParameter("engname"));
String type = Util.null2String(request.getParameter("type"));
String city = Util.null2String(request.getParameter("City"));
String country1 = Util.null2String(request.getParameter("country1"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("resourceids"));
String crmManager = Util.null2String(request.getParameter("crmManager"));


String resourceids ="";
String resourcenames ="";

if (!check_per.equals("")) {
	String strtmp = "select id,fullname,email from CRM_CustomerContacter  where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){
		ht.put( Util.null2String(RecordSet.getString("id")), Util.null2String(RecordSet.getString("fullname"))+"<"+RecordSet.getString("email")+">");
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}
	try{
		StringTokenizer st = new StringTokenizer(check_per,",");

		while(st.hasMoreTokens()){
			String s = st.nextToken();
			if(ht.containsKey(s)){//如果check_per中的已选的客户此时不存在会出错TD1612
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
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t3.fullname like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and t3.fullname like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
}

if(crmId>0){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t3.customerid="+crmId+" ";
	}
	else 
		sqlwhere += " and t3.customerid="+crmId+" ";
}

String sqlstr = "";
if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.id != 0 " ;
}
/*
String userID = ""+user.getUID();
String userDepartmentID = ""+user.getUserDepartment();
String userSeclevel = ""+user.getSeclevel();
String userSubcompanyid1 = ""+user.getUserSubCompany1();

sqlstr = "select t1.id, t1.name, t1.type, t1.city, t1.country  from CRM_CustomerInfo as t1,  CRM_ShareInfo as t2,  HrmRoleMembers as t3 "+ sqlwhere;

sqlstr += " and  ((t1.id=t2.relateditemid) and ( (t2.foralluser=1 and t2.seclevel<="+userSeclevel+" and t2.seclevelMax >= "+userSeclevel+") or ( t2.userid="+userID+" ) or (t2.departmentid="+userDepartmentID+" and t2.seclevel<="+userSeclevel+" and t2.seclevelMax >= "+userSeclevel+") or (t3.resourceid="+userID+" and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and ( (t2.rolelevel=0 and t1.department="+userDepartmentID+") or (t2.rolelevel=1 and t1.subcompanyid1="+userSubcompanyid1+")  or (t3.rolelevel=2) ) ) ) ) ";

sqlstr += " UNION ";

sqlstr += " select t1.id, t1.name, t1.type, t1.city, t1.country  from CRM_CustomerInfo as t1,  HrmRoleMembers as t3,  HrmResource as t4 "+ sqlwhere;

sqlstr += " and (t1.manager="+userID+" or t1.agent="+userID+"  or  (t4.managerid="+userID+" and t4.id=t1.manager)  or 		(t3.resourceid="+userID+" and t3.roleid=8 and ( (t3.rolelevel=0 and t1.department="+userDepartmentID+") or (t3.rolelevel=1 and t1.subcompanyid1="+userSubcompanyid1+") or (t3.rolelevel=2))))" ;
*/
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
//int perpage=Util.getIntValue(request.getParameter("perpage"),0);
int	perpage=50;
//添加判断权限的内容--new


String temptable = "crmtemptable"+ Util.getNumberRandom() ;
String CRM_SearchSql = "";
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
		CRM_SearchSql = "create table "+temptable+"  as select * from (select distinct t3.id AS cid,t3.fullname,t3.email,t1.id,t1.name from CRM_CustomerInfo  t1,"+leftjointable+" t2, CRM_CustomerContacter t3  "+ sqlwhere +" and t1.id=t3.customerid and t1.deleted<>1 and t1.id = t2.relateditemid order by t1.id desc) where rownum<"+ (pagenum*perpage+2);
	}else{
		CRM_SearchSql = "create table "+temptable+"  as select * from (select distinct  t1.* from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 and t1.agent="+user.getUID() + " order by t1.id  desc) where rownum<"+ (pagenum*perpage+2);
	}
}else if(RecordSet.getDBType().equals("db2")){
	if(user.getLogintype().equals("1")){
		CRM_SearchSql = "create table "+temptable+"  as (select distinct  t1.* from CRM_CustomerInfo  t1,"+leftjointable+"  t2 ) definition only";
        RecordSet.executeSql(CRM_SearchSql);
        CRM_SearchSql = "insert into "+temptable+" (select distinct  t1.* from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 and t1.agent="+user.getUID() + " order by t1.id  desc fetch first "+(pagenum*perpage+1)+"  rows only)";
    }else{
		CRM_SearchSql = "create table "+temptable+"  as (select distinct  t1.* from CRM_CustomerInfo  t1) definition only";
        RecordSet.executeSql(CRM_SearchSql);
        CRM_SearchSql = "insert into "+temptable+" (select distinct  t1.* from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 and t1.agent="+user.getUID() + " order by t1.id  desc fetch first "+(pagenum*perpage+1)+"  rows only)";
    }
}else{
	if(user.getLogintype().equals("1")){
		CRM_SearchSql = "select distinct top "+(pagenum*perpage+1)+" t3.id AS cid,t3.fullname,t3.email,t1.id,t1.name into "+temptable+" from CRM_CustomerInfo  t1,"+leftjointable+" t2, CRM_CustomerContacter t3  "+ sqlwhere +" and t1.id=t3.customerid and t1.deleted<>1 and t1.id = t2.relateditemid order by t1.id desc";  
	}else{
		CRM_SearchSql = "select distinct top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 and t1.agent="+user.getUID() + " order by t1.id desc";  
	}
}
//添加判断权限的内容--new*/
RecordSet.executeSql(CRM_SearchSql);
RecordSet.executeSql("Select count(cid) RecordSetCounts from "+temptable);
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
	sqltemp="select * from (select * from  "+temptable+" order by id) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
	sqltemp="select * from (select * from  "+temptable+" order by id fetch first  "+(RecordSetCounts-(pagenum-1)*perpage+1)+"  rows only";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by id";
}
RecordSet.executeSql(sqltemp);

%>
<BODY scroll="no">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MutiCRMContacterBrowserMail.jsp" method=post>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="resourceids" value="">
		<input type="hidden" name="crmManager" value="<%=crmManager%>">
		<!--##############Right click context menu buttons START####################-->
			<DIV align=right style="display:none">
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=O id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>

			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" >
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
<tr>
<td valign="top">
	<table width=100% class=ViewForm valign="top">
	<TR class=Spacing style="height:2px"><TD class=Line1 colspan=4></TD></TR>
	<TR>
		<TD width=15%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
		<TD width=35% class=field><input class=InputStyle  name=name value="<%=name%>"></TD>
		<TD width=15%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD>
		<TD width=35% class=field>	 
            <input class="wuiBrowser" type=hidden name="crmId" value="<%=crmId%>"
			_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
			_displayText="<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+crmId),user.getLanguage())%>"></TD>
		</TD>
	</TR>
	<TR class=Spacing style="height:2px"><TD class=Line1 colspan=4></TD></TR>
</table>
</td>
</tr>
<tr>
<td width="100%" height="100%">
<table width=100% border="0" cellspacing="0" cellpadding="0" height="80%" style="margin-top:50px;">
<tr>
  <td align="center" valign="top" width="45%" >
<TABLE class=BroswerStyle cellspacing="0" cellpadding="0" width="100%;"  >
		<TR class=DataHeader>
			<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
			<TH width="50%"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>      
			<!-- <TH width="30%"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%></TH> -->
			<TH width="50%"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TH>
			  <!--<TH><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TH>-->
		</tr>

		<tr>
		<td colspan="4" width="100%">
			<div style="overflow-y:scroll;width:100%;height:320px">
			<table width="100%" id="BrowseTable">
				<%

				int i=0;
				int totalline=1;
				if(RecordSet.last()){
					do{
					String ids = RecordSet.getString("cid");
					String fullname = RecordSet.getString("fullname");
					String email = RecordSet.getString("email");
					String crmname = RecordSet.getString("name");
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
					<TD style="display:none"><A HREF=#><%=ids%></A></TD>
					
				<td width="50%" style="word-break:break-all">
					<%
					if(!email.equals("")){
						out.print(fullname+"&lt;"+email+"&gt;");
					}else{
						out.print(fullname);
					}%>
				</TD>
				<TD width="50%"><%=crmname%></TD>
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
						   <td>&nbsp;</td>
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
<td align="center" width="10%">
				<img src="/images/arrow_u_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
				<br><br>
					<img src="/images/arrow_left_all_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="/images/arrow_right_wev8.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="/images/arrow_right_all_wev8.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList();">
				<br><br>
				<img src="/images/arrow_d_wev8.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">

</td>

<td align="center" valign="top" width="45%">
		<select size="15" name="srcList" multiple="true" style="width:100%;height:85%;word-wrap:break-word" >
	</select>
</td>
</FORM>
</table>
</td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>

<SCRIPT LANGUAGE="JavaScript">
var resourceids = "<%=resourceids%>";
var resourcenames = "<%=resourcenames%>";
function btnclear_onclick(){
     window.parent.parent.returnValue = {id:"",name:""};
     window.parent.parent.close();
}

function btncancel_onclick(){
     window.parent.parent.returnValue = {id:"",name:""};
     window.parent.parent.close();
}


function btnok_onclick(){
	  setResourceStr();
	 window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
     window.parent.parent.close();
}

function btnsub_onclick(){
     setResourceStr();
    jQuery("input[name=resourceids]").val(resourceids);
    document.SearchForm.submit();
}

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		var newEntry = jQuery(this).find("td:first").text()+"~"+jQuery(this).find("td:first").next().text();
		//alert(newEntry);
		if(!isExistEntry(newEntry,resourceArray)){
			addObjectToSelect("srcList",newEntry);
			reloadResourceArray();
		}
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			jQuery(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			jQuery(this).removeClass("Selected")
		})

})
</SCRIPT>
<!--
<SCRIPT LANGUAGE=VBS>
resourceids = "<%=resourceids%>"
resourcenames = "<%=resourcenames%>"
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub


Sub btnok_onclick()
	  setResourceStr()
	 window.parent.returnvalue = Array(resourceids,resourcenames)
     window.parent.close
End Sub

Sub btnsub_onclick()
     setResourceStr()
    document.all("resourceids").value = resourceids
    document.SearchForm.submit
End Sub

sub onShowCityID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	cityidspan.innerHtml = id(1)
	SearchForm.City.value=id(0)
	else 
	cityidspan.innerHtml = ""
	SearchForm.City.value=""
	end if
	end if
end sub

sub onShowCRM()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	//crmSpan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	crmSpan.innerHtml = id(1)
	weaver.crmId.value=id(0)
	else 
	crmSpan.innerHtml = ""
	weaver.crmId.value=""
	end if
	end if
end sub
</SCRIPT>
-->
	<script language="javascript" for="BrowseTable" event="onclick">
	var e =  window.event.srcElement ;
	if(e.tagName == "TD" || e.tagName == "A"){
		var newEntry = e.parentElement.cells(0).innerText+"~"+e.parentElement.cells(1).innerText ;
		//alert(newEntry);
		if(!isExistEntry(newEntry,resourceArray)){
			addObjectToSelect("srcList",newEntry);
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
	//var selectObj = jQuery("select[name=srcList]")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect("srcList",resourceArray[i]);
	}
	
}
/**
加入一个object 到Select List
 格式object ="1~董芳"
*/
function addObjectToSelect(obj,str){
	//alert(jQuery("select[name="+obj+"]")[0].tagName+"-"+str);
	obj = jQuery("select[name=srcList]")[0];
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	jQuery(oOption).val(str.split("~")[0]);
	jQuery(oOption).text(str.split("~")[1]);
	
	
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
	var destList  = jQuery("select[name=srcList]")[0];
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
	var table = jQuery("#BrowseTable")[0];
	//alert(table.rows.length);
	for(var i=1;i<table.rows.length;i++){
		var str = jQuery(table).find("tr:nth-child("+i+")").find("td:first").text()+"~"+jQuery(table).find("tr:nth-child("+i+")").find("td:nth-child(2)").text();
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect("srcList",str);
	}
	reloadResourceArray();
}

function deleteFromList(){
	var destList  = jQuery("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = jQuery("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = jQuery("select[name=srcList]")[0];
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
	var destList = jQuery("select[name=srcList]")[0];
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
	jQuery("input[name=resourceids]").val(resourceids.substring(1));
}

function doSearch()
{
	setResourceStr();
    jQuery("input[name=resourceids]").val(resourceids.substring(1));
    document.SearchForm.submit();
}
</script>
