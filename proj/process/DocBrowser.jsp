
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
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
</HEAD>


<%
String islink = Util.null2String(request.getParameter("islink"));
String searchid = Util.null2String(request.getParameter("searchid"));
String searchmainid = Util.null2String(request.getParameter("searchmainid"));
String searchsubject = Util.null2String(request.getParameter("searchsubject"));
String searchcreater = Util.null2String(request.getParameter("searchcreater"));
String searchdatefrom = Util.null2String(request.getParameter("searchdatefrom"));
String searchdateto = Util.null2String(request.getParameter("searchdateto"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String initwhere = Util.null2String(request.getParameter("initwhere"));
String crmId = Util.null2String(request.getParameter("txtCrmId"));

String sqlwhere = "" ;




    if(!initwhere.equals("")) {
        if(!sqlwhere1.equals("")) {
            sqlwhere = sqlwhere1 + " and "+initwhere+" and (docstatus !='3' and ((doccreaterid !="+user.getUID()+" and docstatus !='0') or doccreaterid ="+user.getUID()+")) ";
        }
        else {
            sqlwhere = " where "+initwhere+" and  (docstatus !='3' and ((doccreaterid !="+user.getUID()+" and docstatus !='0') or doccreaterid ="+user.getUID()+")) ";
        }
    }else{
        if(!sqlwhere1.equals("")) {
            sqlwhere = sqlwhere1 + " and (docstatus !='3' and ((doccreaterid !="+user.getUID()+" and docstatus !='0') or doccreaterid ="+user.getUID()+")) ";
        }
        else {
            sqlwhere = " where (docstatus !='3' and ((doccreaterid !="+user.getUID()+" and docstatus !='0') or doccreaterid ="+user.getUID()+")) ";
        }
    }
    //System.out.println("sqlwhere = " + sqlwhere);

if(!islink.equals("1")) {
    DocSearchComInfo.resetSearchInfo() ;

    if(!searchid.equals("")) DocSearchComInfo.setDocid(searchid) ; 
    if(!searchmainid.equals("")) DocSearchComInfo.setMaincategory(searchmainid) ;
    if(!searchsubject.equals("")) DocSearchComInfo.setDocsubject(searchsubject) ;
    if(!searchcreater.equals("")) {
        DocSearchComInfo.setOwnerid(searchcreater) ;
        DocSearchComInfo.setUsertype("1");
    }
    if(!crmId.equals("")) {
        DocSearchComInfo.setDoccreaterid(crmId) ;   
         DocSearchComInfo.setUsertype("2");    
    }
    
    if(!searchdatefrom.equals("")) DocSearchComInfo.setDoclastmoddateFrom(searchdatefrom) ;
    if(!searchdateto.equals(""))  DocSearchComInfo.setDoclastmoddateTo(searchdateto) ;

    DocSearchComInfo.setOrderby("4") ;
}

String docstatus[] = new String[]{"1","2","5"};
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

//System.out.println("tempsqlwhere = " + tempsqlwhere);
int perpage = 10 ;
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;

%>


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


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="DocBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<input type=hidden name=initwhere value="<%=xssUtil.put(initwhere)%>">

<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:SearchForm.btnclose.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btn accessKey=1 id="btnclose" onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

<table width=100% class=ViewForm>
<TR class=Spacing style="height:1px"><TD class=Line1 colspan=4></TD></TR>
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
</TR><tr style="height:1px"><td class=Line colspan=4></td></tr>
<TR>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
	<TD width=35% class=field><input class=InputStyle  name=searchsubject value="<%=searchsubject%>"></TD>	
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
<tr style="height:1px"><td class=Line colspan=4></td></tr>
<%if(!user.getLogintype().equals("2")){%>
	<TR>
		<TD width=15%><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></TD>
	    <TD width=35% class=field>
	        <button type="button" class=Browser id=SelectQwnerID onClick="onShowOwnerID(searchcreater,onweridspan)"></BUTTON>
	        <span id=onweridspan> <%=Util.toScreen(ResourceComInfo.getResourcename(searchcreater),user.getLanguage())%></span>
	        <input type=hidden id=searchcreater name=searchcreater value="<%=searchcreater%>">
	    </TD>
        <TD width=15%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD>
         <TD width=35% class=field>
            <button type="button" class=Browser id=SelectCrmId onClick="onShowCustomer('spanCrmId','txtCrmId')"></BUTTON>
            <span id=spanCrmId> <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmId),user.getLanguage())%></span>
            <input type=hidden id=txtCrmId name=txtCrmId value="<%=crmId%>">
        </TD>
	</TR>
    <tr style="height:1px"><td class=Line colspan=4></td></tr>
<%}%>
<TR class=Spacing style="height:1px"><TD class=Line1 colspan=4></TD></TR>
</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 style="width:100%">
<TR class=DataHeader>
<TH width=0% style="display:none"></TH>
<TH width=50%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>
<TH width=18%><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TH>
<TH width=14%><%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%></TH>
<TH width=18%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TH>
</tr><TR class=Line style="height:1px"><TH colSpan=5></TH></TR>
<%

//out.println(sqlwhere);    

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
		<TD width=0% style="display:none"><A HREF=#><%=docid%></A></TD>
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
	<%}%>
</TABLE>
<br>
<table width=100% class=Data>
<tr>
<td align=center><%=Util.makeNavbar2(pagenum, DocSearchManage.getRecordersize() , perpage, "DocBrowser.jsp?islink="+islink+"&searchid="+searchid+"&searchmainid="+searchmainid+"&searchsubject="+searchsubject+"&searchcreater="+searchcreater+"&searchdatefrom="+searchdatefrom+"&searchdateto="+searchdateto+"&sqlwhere="+xssUtil.put(sqlwhere1)+"&initwhere="+xssUtil.put(initwhere)+"&txtCrmId="+crmId)%></td>
</tr>
</table>
<br>
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
</BODY></HTML>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script	language="javascript">
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
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
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;
	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var curTr=jQuery(target).parents("tr")[0];
		window.parent.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
		window.parent.parent.close();
	}
}

function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:""};
	window.parent.parent.close();
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	$("#btnclear").click(btnclear_onclick);
});
</script>
<script type="text/javascript">
	
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
}
function onShowCustomer(spName,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
	if (datas){
	    if(datas.id){
		    $("#"+spName).html(datas.name);
		    $("input[name="+inputename+"]").val(datas.id);
	    }else{
		    $("#"+spName).empty();
		   $("input[name="+inputename+"]").val("");
	    }
	}
}

function onShowOwnerID(inputname,spanname){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(datas){
		if(datas.id){
			$(spanname).html("<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"'>"+datas.name+"</A>");
			$(inputname).val(datas.id);
		}else{
			$(spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$(inputname).val("");
		}
	}
}
</script>