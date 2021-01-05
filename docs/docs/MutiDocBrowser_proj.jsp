
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String islink = Util.null2String(request.getParameter("islink"));
String searchid = Util.null2String(request.getParameter("searchid"));
String searchmainid = Util.null2String(request.getParameter("searchmainid"));
String searchsubject = Util.null2String(request.getParameter("searchsubject"));
String searchcreater = Util.null2String(request.getParameter("searchcreater"));
String searchdatefrom = Util.null2String(request.getParameter("searchdatefrom"));
String searchdateto = Util.null2String(request.getParameter("searchdateto"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String crmId = Util.null2String(request.getParameter("txtCrmId"));
String sqlwhere = "" ;



String check_per = Util.null2String(request.getParameter("documentids"));
if(check_per.length()>1 && check_per.startsWith(",")){
	check_per = check_per.substring(1);
}
String documentids = "" ;
String documentnames ="";
String doccreatedates = "";
String ownerids = "";

// 2005-04-08 Modify by guosheng for TD1769
if (!check_per.equals("")) {
	String strtmp = "select id,docsubject,ownerid,doccreatedate from DocDetail where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	while(RecordSet.next()){
			documentids +="," + RecordSet.getString("id");
			documentnames += ","+RecordSet.getString("docsubject");
			ownerids += "," + RecordSet.getString("ownerid");
			doccreatedates += "," + RecordSet.getString("doccreatedate");
	}
}

if(!sqlwhere1.equals("")) {
	sqlwhere = sqlwhere1 + " and  (docstatus !='3' and ((doccreaterid !="+user.getUID()+" and docstatus !='0') or doccreaterid ="+user.getUID()+")) ";
}
else {
		sqlwhere = " where  (docstatus !='3' and ((doccreaterid !="+user.getUID()+" and docstatus !='0') or doccreaterid ="+user.getUID()+")) ";
}
    //System.out.println("sqlwhere = " + sqlwhere);


if(!islink.equals("1")) {
    DocSearchComInfo.resetSearchInfo() ;

    if(!searchid.equals("")) DocSearchComInfo.setDocid(searchid) ;
    if(!searchmainid.equals("")) DocSearchComInfo.setMaincategory(searchmainid) ;
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

String tempsqlwhere = DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
String orderclause = DocSearchComInfo.FormatSQLOrder() ;
String orderclause2 = DocSearchComInfo.FormatSQLOrder2() ;

if(!tempsqlwhere.equals("")) sqlwhere += " and " + tempsqlwhere ;

int perpage = 30 ;
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;

%>
</HEAD>

<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MutiDocBrowser_proj.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<button type="button" type="button" class=btnSearch accessKey=S  id=btnsub><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btnReset accessKey=T id=myfun1><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btn accessKey=C id=btnclear><U>C</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>



<table width=100% class=ViewForm>
<TR class=Spacing style="height:1px;">
<TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
<TD width=35% class=field><input class=InputStyle id=searchid name=searchid value="<%=searchid%>" onKeyPress="ItemNum_KeyPress()" onBlur='checkcount1(this)'></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TD>
<TD width=35% class=field>
<select class=InputStyle  name=searchmainid>
<option value=""></option>
<%
while(MainCategoryComInfo.next()){
	String isselected ="";
	if(MainCategoryComInfo.getMainCategoryid().equals(searchmainid))
		isselected=" selected";
%>
<option value="<%=MainCategoryComInfo.getMainCategoryid()%>" <%=isselected%>><%=MainCategoryComInfo.getMainCategoryname()%>
<%}%>
</select>
</TD>
</TR><tr style="height:1px;"><td class=Line colspan=4></td></tr>


<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
<TD width=35% class=field><input  class=InputStyle  name=searchsubject value="<%=searchsubject%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
<TD width=35% class=field>
    <button type="button" class=Calendar id=selectdate1 onClick="getDate(searchdatefromspan,searchdatefrom)"></button>
              <span id=searchdatefromspan ><%=searchdatefrom%></span> -
    <button type="button" class=Calendar id=selectdate2 onClick="getDate(searchdatetospan,searchdateto)"></button>
              <span id=searchdatetospan ><%=searchdateto%></span>

    <input type=hidden id =searchdatefrom name=searchdatefrom maxlength=10 size=10 value="<%=searchdatefrom%>">
    <input type=hidden id =searchdateto name=searchdateto maxlength=10 size=10 value="<%=searchdateto%>">
</td>
</TR>

<tr style="height:1px;"><td class=Line colspan=4></td></tr>

<tr>    
<TD width=15%><%=SystemEnv.getHtmlLabelName(26355,user.getLanguage())%></TD>
	<TD width=35% class=field>
	    <input class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" _displayText=" <%=Util.toScreen(ResourceComInfo.getResourcename(searchcreater),user.getLanguage())%>" type=hidden id=searchcreater name=searchcreater value="<%=searchcreater%>">
	</TD>
    <TD width=15%><%=SystemEnv.getHtmlLabelName(30043,user.getLanguage())%></TD>
         <TD width=35% class=field>
            <input class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" _displayText=" <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmId),user.getLanguage())%>" type=hidden id=txtCrmId name=txtCrmId value="<%=crmId%>">
        </TD>
</TR>

<tr style="height:1px;"><td class=Line colspan=4></td></tr>

<tr>
            <td colspan="5" height="19">
              <input  type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">
              <%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%></td>
 </tr>

<TR class=Spacing style="height:1px;"><TD class=Line1 colspan=5></TD></TR>
</table>



<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 style="width:100%;">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
	 <TH width=5%></TH>
    <TH width=45%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>
    <TH width=18%><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TH>
    <TH width=14%><%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%></TH>
    <TH width=18%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TH>
    </tr><TR class=Line><TH colSpan=6 style="padding:0;"></TH></TR>
<%
if(!check_per.equals(""))  
		check_per = "," + check_per + "," ;
int i=0;
DocSearchManage.setPagenum(pagenum) ;
DocSearchManage.setPerpage(perpage) ;
DocSearchManage.getSelectResult(sqlwhere,orderclause,orderclause2,user) ;

while(DocSearchManage.next()) {
		String docid = ""+DocSearchManage.getID();
		String mainid = ""+DocSearchManage.getMainCategory();
		String subject = DocSearchManage.getDocSubject();
		String createrid = ""+DocSearchManage.getOwnerId();
		String modifydate = DocSearchManage.getDocLastModDate();
		String usertype=Util.null2String(DocSearchManage.getUsertype());

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

	 <%
	 String ischecked = "";
	 if(check_per.indexOf(","+docid+",")!=-1){
		ischecked = " checked ";
	 }
	 %>
	<TD><input type=checkbox name="check_per" value="<%=docid%>" <%=ischecked%>></TD>
		<TD><%=subject%></TD>
		<TD ><%=MainCategoryComInfo.getMainCategoryname(mainid)%></TD>
		<TD><%if(usertype.equals("1")){%>
				<%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%>
				<%}else{%>
				<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid),user.getLanguage())%>
				<%}%>
		 </TD>
		<TD><%=modifydate%></TD>
</TR>
<%}
%>
<br>
<table width=100% class=Data>
<tr>
<td align=center><%=Util.makeNavbar3(pagenum, DocSearchManage.getRecordersize() , perpage, "MutiDocBrowser_proj.jsp?islink=1")%></td>
</tr>
</table>
<br>
</TABLE>
  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input type="hidden" name="documentids" value="">
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript">
	var documentids = "<%=documentids%>";
	var documentnames = "<%=documentnames%>";
	var docowner = "<%=ownerids%>";
	var doccreatedate = "<%=doccreatedates%>";
</script>

<script language="javascript">
 function onSubmit() {
		$G("SearchForm").submit()
	}
 function onReset() {
	
		$G("SearchForm").reset();
	}
 function onClear() {	
		btnok_onclear();
	}
 

function btnok_onclear(){
	window.parent.parent.returnValue = {id:"",name:"",owner:"",doccreatedates:""};
	window.parent.parent.close()
}
	function btnok_onclick(){
	window.parent.parent.returnValue = {id:documentids,name:documentnames,owner:docowner,doccreatedates:doccreatedate}
	window.parent.parent.close()
}
function CheckAll(checked) {
	len = document.SearchForm.elements.length;
	var i=0;
	for( i=0; i<len; i++) {
		if (document.SearchForm.elements[i].name=='check_per') {
			if(!document.SearchForm.elements[i].checked) {
				documentids = documentids + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(0).innerText;
		   		documentnames = documentnames + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(2).innerText;
		   		docowner = docowner + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(3).innerText;
		   		doccreatedate = doccreatedate + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(4).innerText;
		   	}
		   	document.SearchForm.elements[i].checked=(checked==true?true:false);
		}
 	}
}


//下面的函数由分页栏产生的函数调用
function changePagePre(pageStr){
    changePageSubmit(pageStr);
}
//下面的函数由分页栏产生的函数调用
function changePageTo(pageStr){
    changePageSubmit(pageStr);
}
//下面的函数由分页栏产生的函数调用
function changePageNext(pageStr){
    changePageSubmit(pageStr);
}

function changePageSubmit(pageStr){
    //alert(pageStr+"&documentids="+documentids+"&searchid="+document.all("searchid").value+"&searchmainid="+document.all("searchmainid").value+"&searchsubject="+document.all("searchsubject").value+"&searchcreater="+document.all("searchcreater").value+"&searchdatefrom="+document.all("searchdatefrom").value+"&searchdatefrom="+document.all("searchdatefrom").value);
    location=pageStr+"&documentids="+documentids+"&searchid="+document.all("searchid").value+"&searchmainid="+document.all("searchmainid").value+"&searchsubject="+document.all("searchsubject").value+"&searchcreater="+document.all("searchcreater").value+"&searchdatefrom="+document.all("searchdatefrom").value+"&searchdateto="+document.all("searchdateto").value;
}

//多选
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	var evt = event.srcElement||event.target;
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		//alert(event.target.tagName);
		if($(this)[0].tagName=="TR"&&event.target.tagName!="INPUT"){
			var obj = jQuery(this).find("input[name=check_per]");
		   	if (obj.attr("checked") == true){
		   		obj.attr("checked", false);
		   		documentids = documentids.replace("," + jQuery(this).find("td:eq(0)").text(), "");
		   		documentnames = documentnames.replace("," + jQuery(this).find("td:eq(2)").text(), "");
		   		docowner = docowner.replace("," + jQuery(this).find("td:eq(4)").text(), "");
		   		doccreatedate = doccreatedate.replace("," + jQuery(this).find("td:eq(5)").text(),"");
		   	}else{
		   		obj.attr("checked", true);
		   		documentids = documentids + "," + $.trim(jQuery(this).find("td:eq(0)").text());
		   		documentnames = documentnames + "," + $.trim(jQuery(this).find("td:eq(2)").text());
		   		docowner=docowner+"," + $.trim(jQuery(this).find("td:eq(4)").text());
		   		doccreatedate=doccreatedate+"," + $.trim(jQuery(this).find("td:eq(5)").text());
		   	}

		}
		//点击checkbox框
	    if(event.target.tagName=="INPUT"){
	       var obj = jQuery(this).find("input[name=check_per]");
		   	if (obj.attr("checked") == true){
				
				//obj.attr("checked", false);
		   	   documentids = documentids + "," + $.trim(jQuery(this).find("td:eq(0)").text());
		   		documentnames = documentnames + "," + $.trim(jQuery(this).find("td:eq(2)").text());
		   		docowner=docowner+"," + $.trim(jQuery(this).find("td:eq(4)").text());
		   		doccreatedate=doccreatedate+"," + $.trim(jQuery(this).find("td:eq(5)").text());
		   	}else{
				documentids = documentids.replace("," + jQuery(this).find("td:eq(0)").text(), "");
		   		documentnames = documentnames.replace("," + jQuery(this).find("td:eq(2)").text(), "");
		   		docowner = docowner.replace("," + jQuery(this).find("td:eq(4)").text(), "");
		   		doccreatedate = doccreatedate.replace("," + jQuery(this).find("td:eq(5)").text(),"");
		   	}
	    }
		//window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
		//	window.parent.close()
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})
});
</script>
</BODY>
</HTML>