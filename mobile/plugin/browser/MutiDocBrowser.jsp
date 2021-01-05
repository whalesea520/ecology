
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@page import="java.util.Enumeration"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="MobileInit.jsp"%>

<HTML>
<HEAD>
<base target="_self">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="/mobile/plugin/browser/css/Weaver_wev8.css" rel="stylesheet" type="text/css" >
<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
<%
boolean isinit = false;
/*
Enumeration em = fu.getParameterNames();
while(em.hasMoreElements())
{
	String paramName = (String)em.nextElement();
	if(!paramName.equals("")&&!paramName.equals("splitflag"))
		isinit = false;
	break;
}
*/
int date2during= Util.getIntValue(fu.getParameter("date2during"),0) ;
int olddate2during = 0;
BaseBean baseBean = new BaseBean();
String date2durings = "";
try
{
	date2durings = Util.null2String(baseBean.getPropValue("docdateduring", "date2during"));
}
catch(Exception e)
{}
String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
if(date2duringTokens.length>0)
{
	olddate2during = Util.getIntValue(date2duringTokens[0],0);
}
if(olddate2during<0||olddate2during>36)
{
	olddate2during = 0;
}
if(isinit)
{
	date2during = olddate2during;
}

int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String islink = Util.null2String(fu.getParameter("islink"));
String searchid = Util.null2String(fu.getParameter("searchid"));
//String searchmainid = Util.null2String(request.getParameter("searchmainid"));
String searchsubject = Util.null2String(fu.getParameter("searchsubject"));
String searchcreater = Util.null2String(fu.getParameter("searchcreater"));
String searchdatefrom = Util.null2String(fu.getParameter("searchdatefrom"));
String searchdateto = Util.null2String(fu.getParameter("searchdateto"));
String sqlwhere1 = Util.null2String(fu.getParameter("sqlwhere"));
String crmId = Util.null2String(fu.getParameter("txtCrmId"));
String sqlwhere = "" ;

String secCategory = Util.null2String(fu.getParameter("secCategory"));
String path= Util.null2String(fu.getParameter("path"));
if (!secCategory.equals("")) path = "/"+CategoryUtil.getCategoryPath(Util.getIntValue(secCategory));

String check_per = Util.null2String(fu.getParameter("documentids"));
String documentids = "" ;
String documentnames ="";

String newDocumentids="";

// 2005-04-08 Modify by guosheng for TD1769
if (!check_per.equals("")) {
	documentids=","+check_per;
	String[] tempArray = Util.TokenizerString2(documentids, ",");
	for (int i = 0; i < tempArray.length; i++) {
		String tempDocName=DocComInfo.getDocname(tempArray[i]);
		if(!"".equals(tempDocName)) {
			newDocumentids += ","+tempArray[i];
			documentnames += ","+Util.StringReplace(Util.StringReplace(tempDocName,",","，"),"&quot;","“");
		}
	}
}
documentids=newDocumentids;
/*
if(!sqlwhere1.equals("")) {
	sqlwhere = sqlwhere1 + " and docstatus in ('1','2','5') ";
}
else {
		sqlwhere = " where  docstatus in ('1','2','5') ";
}
    //System.out.println("sqlwhere = " + sqlwhere);
*/
sqlwhere = " 1=1 ";

if(!islink.equals("1")) {
    DocSearchComInfo.resetSearchInfo() ;

    if(!searchid.equals("")) DocSearchComInfo.setDocid(searchid) ;
    //if(!searchmainid.equals("")) DocSearchComInfo.setMaincategory(searchmainid) ;
    if(!secCategory.equals("")) DocSearchComInfo.setSeccategory(secCategory) ;
    if(!searchsubject.equals("")) DocSearchComInfo.setDocsubject(searchsubject) ;    
    if(!searchdatefrom.equals("")) DocSearchComInfo.setDoclastmoddateFrom(searchdatefrom) ;
    if(!searchdateto.equals(""))  DocSearchComInfo.setDoclastmoddateTo(searchdateto) ;
    if(!searchcreater.equals("")) {
        DocSearchComInfo.setOwnerid(searchcreater) ;
        DocSearchComInfo.setUsertype("1");
    }
    if(!crmId.equals("")) {
        DocSearchComInfo.setDoccreaterid(crmId) ;   
        DocSearchComInfo.setUsertype("2");    
    }
    DocSearchComInfo.setOrderby("4") ;
}

String docstatus[] = new String[]{"1","2","5","7"};
for(int i = 0;i<docstatus.length;i++){
   	DocSearchComInfo.addDocstatus(docstatus[i]);
}

String tempsqlwhere = DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
String orderclause = DocSearchComInfo.FormatSQLOrder() ;
String orderclause2 = DocSearchComInfo.FormatSQLOrder2() ;

if(!tempsqlwhere.equals("")) sqlwhere += " and " + tempsqlwhere ;

/* added by wdl 2007-03-16 不显示历史版本 */
sqlwhere+=" and (ishistory is null or ishistory = 0) ";
/* added end */
sqlwhere += dm.getDateDuringSql(date2during);

//int perpage = 30 ;
int perpage = 10 ;
int pagenum = Util.getIntValue(fu.getParameter("pagenum") , 1) ;
boolean hasNextPage=false;

DocSearchManage.getSelectResultCount(sqlwhere,user);
int RecordSetCounts = DocSearchManage.getRecordersize();
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
%>
<script type="text/javascript">
	documentids = "<%=documentids%>"
	documentnames = "<%=documentnames%>"
	function btnclear_onclick(){
	     window.parent.returnValue = {id:"",name:""};
	     window.parent.close();
	}

	function btnok_onclick(){
		setResourceStr();
		window.parent.returnValue = {id:documentids,name:documentnames};
		window.parent.close();
	}
	
	function setResourceStr(){
	
		documentids ="";
		documentnames = "";
		for(var i=0;i<resourceArray.length;i++){
			documentids += "," +resourceArray[i].split("~")[0];
			documentnames += "," +replaceToHtml(resourceArray[i].split("~")[1]);
		}
		document.all("documentids").value = documentids.substring(1)
	}

	function btnsub_onclick(){
		doSearch();
	}
	
	function BrowseTable_onclick(e){
		var target =  e.srcElement||e.target ;
		try{
		if(target.nodeName == "TD" || target.nodeName == "A"){
			var newEntry = jQuery(jQuery(target).parents("tr")[0].cells[0]).text()+"~"+jQuery(jQuery(target).parents("tr")[0].cells[1]).text() ;
			if(!isExistEntry(newEntry,resourceArray)){
				addObjectToSelect(document.all("srcList"),newEntry);
				reloadResourceArray();
			}
		}
		}catch (en) {
			alert(en.message);
		}
	}
	function BrowseTable_onmouseover(e){
		e=e||event;
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
	
	jQuery(document).ready(function(){
		jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
		jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
		jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
		loadToList();
	})	
	
</script>
<script type="text/javascript">

//Load
var resourceArray = new Array();
for(var i =1;i<documentids.split(",").length;i++){
	if(documentnames.split(",")[i]!=null&&documentnames.split(",")[i]!=""){
	resourceArray[i-1] = documentids.split(",")[i]+"~"+documentnames.split(",")[i];
	}
}

function loadToList(){
	var selectObj = document.all("srcList");
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}
/**
加入一个object 到Select List
 格式object ="1~董芳"
*/
function addObjectToSelect(obj,str){
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	jQuery(oOption).val(str.split("~")[0]);
	jQuery(oOption).text(str.split("~")[1])  ;
	
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
	var table =jQuery("#BrowseTable");
	jQuery("#BrowseTable").find("tr").each(function(){
		var str=jQuery(jQuery(this)[0].cells[0]).text()+"~"+jQuery(jQuery(this)[0].cells[1]).text();
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect(document.all("srcList"),str);
	});
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
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = document.all("srcList");
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
	}
}

function doSearch()
{
	setResourceStr();
	document.all("documentids").value = documentids.substring(1) ;
	document.SearchForm.submit();
}

function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
        re = re.replace("&quot;","“");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1||re.indexOf(",")!=-1||re.indexOf("&quot;")!=-1)
	return re;
}


</SCRIPT>
</HEAD>

<BODY style="overflow-y: hidden;">
<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="/mobile/plugin/browser/MutiDocBrowser.jsp" method=post>
<input type="hidden" name="pagenum" id="pagenum" value=''>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td ></td>
	<td valign="top">
	 <div style="height:435px;overflow: auto;">
		<TABLE class=Shadow style="width: 100%">
		<tr>
		<td valign="top" colspan="2">
         <table width=100% class=ViewForm>
			<TR>
			<TD width=30%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
			<TD width=70% class=field><input  class=InputStyle  name=searchsubject value="<%=searchsubject%>"></TD>
			</TR>
			<tr style="height:1px;"><td class=Line colspan=2></td></tr>
		 </table>

<tr width="100%">
<td width="60%" valign="top" style="padding-top: 10px;">
<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0" width="100%">
		<COLGROUP>
		<COL width="40%">
		<COL width="40%">
		<COL width="20%">
		<col width="10px;">
		<TR class=DataHeader>
		    <TH ><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>
		    <TH ><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TH>
		    <TH ><%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%></TH>
		    <th><div style="width:8px;"></div></th>
		</TR>
		<TR class=Line><TH colspan="4"></TH></TR>

		<TR>
		<td colspan="4" width="100%">
			<div style="overflow:scroll;height:320px" >
			<table    width="100%" id="BrowseTable" >
			<COLGROUP>
			<COL width="40%">
			<COL width="40%">
			<COL width="20%">
			</COLGROUP>
			<%
			//if(!check_per.equals(""))  
			//		check_per = "," + check_per + "," ;
			String docid=null;
			String mainid=null;
			String subject=null;
			String createrid=null;
			String usertype=null;

			int i=0;
			DocSearchManage.setPagenum(pagenum) ;
			DocSearchManage.setPerpage(perpage) ;
			DocSearchManage.getSelectResult(sqlwhere,orderclause,orderclause2,user) ;
			while(DocSearchManage.next()) {
				docid = ""+DocSearchManage.getID();
				mainid = ""+DocSearchManage.getMainCategory();
				subject = DocSearchManage.getDocSubject();
				createrid = ""+DocSearchManage.getOwnerId();
				//String modifydate = DocSearchManage.getDocLastModDate();
				usertype=Util.null2String(DocSearchManage.getUsertype());
			
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
					<TD style="display:none"><A HREF=#><%=docid%></A></TD>
					<TD style="word-break:break-all"><%=subject%></TD>
					<TD style="word-break:break-all"><%=MainCategoryComInfo.getMainCategoryname(mainid)%></TD>
					<TD style="word-break:break-all"><%if(usertype.equals("1")){%>
							<%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%>
							<%}else{%>
							<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid),user.getLanguage())%>
							<%}%>
					 </TD>
				</TR>
				<%}%>
				</table>
			</div>
		</td>
	</tr>
	</TABLE>
</td>
<!--##########Browser Table END//#############-->
<td width="40%" valign="top" style="padding-top: 10px;">
	<!--########Select Table Start########-->
	<table  cellspacing="1" align="left" style="width: 100%;height:350px">
		<tr>
			<td align="center" valign="top" width="30%">
				<img src="images/arrow_u_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
				<br><br>
					<img src="images/arrow_left_all_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="images/arrow_right_wev8.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="images/arrow_right_all_wev8.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList();">
				<br><br>
				<img src="images/arrow_d_wev8.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
			</td>
			<td align="center" valign="top" width="70%">
				<select name="srcList" multiple="true" style="width:100%;height: 344px;word-wrap:break-word" >
					
				</select>
			</td>
		</tr>
		
	</table>
	<!--########//Select Table End########-->
		</td>
		</tr>
		</TABLE>
		</div>
		<div align="center" style="background:rgb(246, 246, 246);vertical-align: middle;padding-top: 8px;border-top:#dadee5 solid 1px;">     
		 <BUTTON class=btnSearch onclick="btnsub_onclick();" accessKey=S  id="searchBtn"><u>S</u>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>&nbsp;&nbsp;
		 <BUTTON class=btn accessKey=O  id="resetBtn" onclick="btnok_onclick();"><u>O</u>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>&nbsp;&nbsp;
		 <BUTTON class=btn accessKey=2  id="clearBtn" onclick="btnclear_onclick();"><u>2</u>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>&nbsp;&nbsp;
		 <BUTTON class=btnReset accessKey=T  id="cancelBtn" onclick="window.parent.close();"><u>T</u>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	     <%if(pagenum>1){%>
	          <input type="submit" value="上一页" id="prepage" onclick="setResourceStr();document.getElementById('pagenum').value=<%=pagenum-1%>;">
	     <%} %>
	     <%if(hasNextPage){%>
	          <input type="submit" value="下一页" id="nextpage" onclick="setResourceStr();document.getElementById('pagenum').value=<%=pagenum+1%>;">
	     <%} %>
       </div>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(fu.getParameter("sqlwhere")))%>'>
  <input type="hidden" name="documentids" value="">
</FORM>

</BODY>
</HTML>