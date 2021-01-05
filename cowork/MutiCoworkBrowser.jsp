
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.cowork.CoTypeComInfo"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" /> 
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/cowork/js/cowork_wev8.js"></script>
</HEAD>

<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
int userid=user.getUID();
// 查看类型
String type = Util.null2String(request.getParameter("type"));
//关注的或者直接参与的协作
String viewType = Util.null2String(request.getParameter("viewtype"));
//排序方式
String orderType = Util.null2String(request.getParameter("orderType"),"unread");
//是否是搜索操作
String isSearch = Util.null2String(request.getParameter("isSearch"));
//关键字
String name =URLDecoder.decode( Util.null2String(request.getParameter("name")));
//协作区ID
String typeid = Util.null2String(request.getParameter("typeid"));
//协作状态
String status = Util.null2String(request.getParameter("status"),"1");
//参与类型
String jointype = Util.null2String(request.getParameter("jointype"));
// 创建者
String creater = Util.null2String(request.getParameter("creater"));
//负责人
String principal = Util.null2String(request.getParameter("principal"));
//开始时间
String startdate = Util.null2String(request.getParameter("startdate"));
// 结束时间
String enddate = Util.null2String(request.getParameter("enddate"));

String labelid=Util.null2String(request.getParameter("labelid"));

String check_per = Util.null2String(request.getParameter("resourceids"));

String resourceids ="";
String resourcenames ="";

if (!check_per.equals("")) {
	if(check_per.indexOf(',')==0){
		check_per=check_per.substring(1);
	}
	String strtmp = "select id,name from cowork_items  where id in ("+check_per+")";

	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){
		ht.put( Util.null2String(RecordSet.getString("id")), Util.null2String(RecordSet.getString("name")));
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

String searchStr=" 1=1 ";
if(!name.equals("")){
	searchStr += " and name like '%"+name+"%' "; 
}
if(!typeid.equals("")){
	searchStr += "  and typeid in("+typeid+")  ";
}
if(!status.equals("")){
	searchStr += " and status ="+status+"";
}else
	searchStr += " and status =1";

if(!creater.equals("")){
	searchStr += " and creater='"+creater+"'  ";
}
if(!principal.equals("")){
	searchStr += " and principal='"+principal+"'  "; 
}
if(!startdate.equals("")){
	searchStr +=" and begindate >='"+startdate+"'  ";
}
if(!enddate.equals("")){
	searchStr +=" and enddate <='"+enddate+"'  ";
}

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
//int perpage=Util.getIntValue(request.getParameter("perpage"),0);
int	perpage=30;
//添加判断权限的内容--new


String temptable = "crmtemptable"+ Util.getRandom() ;
String CRM_SearchSql = "";
String temptable1="";
//String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
String leftjointable = CrmShareBase.getTempTableByBrowser(""+user.getUID());


RecordSet.executeSql("select count(*) RecordSetCounts from cowork_items where "+searchStr);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
String sqltemp="";
int iTotal =RecordSetCounts;
int iNextNum = pagenum * perpage;
int ipageset = perpage;
if(iTotal - iNextNum + perpage < perpage) ipageset = iTotal - iNextNum + perpage;
if(iTotal < perpage) ipageset = iTotal;
if ("oracle".equals(RecordSet.getDBType())) {
    sqltemp=  "select t1.id,t1.name,t1.typeid,principal from cowork_items  t1 where "+searchStr+" order by t1.id desc";
	sqltemp = "select t2.*,rownum rn from (" + sqltemp + ") t2 where rownum <= " + iNextNum;
	sqltemp = "select t3.* from (" + sqltemp + ") t3 where rn > " + (iNextNum - perpage);
} else if ("sqlserver".equals(RecordSet.getDBType())) {
    sqltemp="select top "+iNextNum+" t1.id,t1.name,t1.typeid,principal from cowork_items t1 where "+searchStr+" order by t1.id desc";
	sqltemp = "select top " + ipageset +" t2.* from (" + sqltemp + ") t2 order by t2.id asc";
	sqltemp = "select top " + ipageset +" t3.* from (" + sqltemp + ") t3 order by t3.id desc";
} else if ("mysql".equals(RecordSet.getDBType())) {
    sqltemp=  "select t1.id,t1.name,t1.typeid,principal from cowork_items  t1 where "+searchStr+" order by t1.id desc";
	sqltemp = "select t2.* from (" + sqltemp + ") t2 limit " + ((pagenum - 1) * perpage) + "," + perpage;;
}
RecordSet.executeSql(sqltemp);
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MutiCoworkBrowser.jsp" method=post>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	
	<td valign="top">
		<!--########Shadow Table Start########-->
		<TABLE class=Shadow>
		<tr>
		<td valign="top" colspan="2">
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="resourceids" value="">
		<!--##############Right click context menu buttons START####################-->
			<DIV align=right style="display:none">
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=O id=btnok onclick="btnok_onclick(event)"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>

			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=2 id=btnclear onclick="btnclear_onclick(event);"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
			
		<TABLE class=viewform width=100% id=oTable1>
		  <COLGROUP>
		  <COL width="20%">
		  <COL width="30%">
		  <COL width="20%">
		  <COL width="30%">
		  <TBODY>
		    <tr>
		    	<td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
		        <td class=field>
		        	<input class=inputstyle type=text name="name" id="name" value="<%=name%>" style="width:90%" maxlength=25 onkeydown="if(window.event.keyCode==13) return false;">      
		        </td> 
		        <td><%=SystemEnv.getHtmlLabelName(17694,user.getLanguage())%></td>
		        <td class=field>
			        <select name="typeid" size=1 style="width:70%">
			    	<option value="">&nbsp;</option>
			        <%
			            CoTypeComInfo.setTofirstRow();
			            while(CoTypeComInfo.next()){
			                String tmptypeid=CoTypeComInfo.getCoTypeid();
			                String typename=CoTypeComInfo.getCoTypename();
			        %>
			            <option value="<%=tmptypeid%>" <%=tmptypeid.equals(typeid)?"selected":"" %>><%=typename%></option>
			        <%
			            }
			        %>
			        </select>
		        </td>
		    </tr>
		    <TR style="height: 1px;"><TD class=Line colspan=4></TD></TR> 
		    <tr>
		      <td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
		      <td class=field>
			      <select name=status>
			      <option value=""  <%=status.equals("")?"selected":"" %>>&nbsp;</option>
			      <option value="1" <%=status.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
			      <option value="2" <%=status.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
			      </select>
		      </td>
		      <td><%=SystemEnv.getHtmlLabelName(18873,user.getLanguage())%></td>
		      <td class=field>
			      <select name="jointype">
			      <option value=""  <%=jointype.equals("")?"selected":"" %>></option>
			      <option value="1" <%=jointype.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18874,user.getLanguage())%></option>
			      <option value="2" <%=jointype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18875,user.getLanguage())%></option>
			      </select>
		      </td>
		    </tr>
		    <TR style="height: 1px;"><TD class=Line colspan=4></TD></TR> 
		    <tr> 
		      <td><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></td>
			  <td class=field>
			       <BUTTON type="button" class=Browser id=SelectPrincipalID onClick="onShowResourceOnly('principal','principalspan')"></BUTTON> 
			       <span id=principalspan><%=ResourceComInfo.getLastname(principal) %></span> 
			       <INPUT class=saveHistory id=principal type=hidden name=principal value="<%=principal%>">
			  </td>
		      <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
		      <td class=field>
			       <BUTTON type="button" class=Browser id=SelectCreaterID onClick="onShowResourceOnly('creater','createrspan')"></BUTTON> 
			       <span id=createrspan><%=ResourceComInfo.getLastname(creater) %></span> 
			       <INPUT class=saveHistory id=creater type=hidden name=creater value="<%=creater%>">
		      </td>   
			</tr>
			<TR style="height: 1px;"><TD class=Line colspan=4></TD></TR>
		</table>

<table style="width:100%;margin-top: 10px;">
<tr width="100%">
<td width="60%" valign="top">
	<!--############Browser Table START################-->
	<TABLE class=BroswerStyle cellspacing="0" cellpadding="0" style="width:100%;">
		<TR class=DataHeader>
			<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
			<TH width="47%"><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TH>      
			<TH width="28%"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
			<TH width="27%"><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TH>
			
			  <!--<TH><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TH>-->
		</tr>

		<tr>
		<td colspan="4" width="100%" height="260px">
			<div style="overflow-y:scroll;width:100%;height:260px">
			<table width="100%" id="BrowseTable"  style="width:100%;">
				<%

				int i=0;
				int totalline=1;
				while(RecordSet.next()){
					String ids = RecordSet.getString("id");
					String names = Util.toScreen(RecordSet.getString("name"),user.getLanguage());
					String coworkTypeid = Util.toScreen(RecordSet.getString("typeid"),user.getLanguage());
					String coworkPrincipal = RecordSet.getString("principal");
					
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
					
				<td width="50%" style="word-break:break-all"> <%=names%></TD>
				<TD width="30%" style="word-break:break-all"><%=coworkTypeid%>
				</TD>
				<TD width="25%" style="word-break:break-all"><%=coworkPrincipal%></TD>
				</TR>
				<%
					if(hasNextPage){
						totalline+=1;
						if(totalline>perpage)	break;
					}
				}
				//RecordSet.executeSql("drop table "+temptable);
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
									<button type=submit class=btn accessKey=P id=prepage onclick="setResourceStr();$('input[name=pagenum]').val(<%=pagenum-1%>);"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
							   <%}%>
						   </td>
						   <td>
							   <%if(hasNextPage){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
									<button type=submit class=btn accessKey=N  id=nextpage onclick="setResourceStr();$('input[name=pagenum]').val(<%=pagenum+1%>);"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
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
<td width="40%" valign="top">
	<!--########Select Table Start########-->
	<table  cellspacing="1" align="left" width="100%">
		<tr>
			<td align="center" valign="top" width="30%">
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
			<td align="center" valign="top" width="70%">
				<select size="15" name="srcList" multiple="true" style="width:100%;word-wrap:break-word;height:100%" >
					
					
				</select>
			</td>
		</tr>
		
	</table>
</td>
</tr>
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
</FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>





<script type="text/javascript">
<!--
	resourceids = "<%=resourceids%>";
	resourcenames = "<%=resourcenames%>";
	function btnclear_onclick(){
	    window.parent.parent.returnValue = {id:"",name:""};
	    window.parent.parent.close();
	}


jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})


function btnok_onclick(){
	  setResourceStr();
	 window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
    window.parent.parent.close();
}

function btnsub_onclick(){
    setResourceStr();
   $("#resourceids").val(resourceids);
   document.SearchForm.submit();
}
	
function BrowseTable_onclick(e){
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
		alert(en.message);
	}
}
function BrowseTable_onmouseover(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
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
}
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
		var str=jQuery.trim($($(this)[0].cells[0]).text()+"~"+$($(this)[0].cells[1]).text());
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
	$("input[name=resourceids]").val(resourceids.substring(1)) ;
    document.SearchForm.submit();
}
</script>
