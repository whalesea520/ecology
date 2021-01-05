<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LedgerCategoryComInfo" class="weaver.fna.maintenance.LedgerCategoryComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String categoryid = Util.null2String(request.getParameter("categoryid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String sqlwhere1 = sqlwhere ;
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!categoryid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where categoryid = " + categoryid ;
	}
	else
		sqlwhere += " and categoryid = " + categoryid ;
}

String sqlstr = "select id,ledgermark,ledgername "+
			    "from FnaLedger " + sqlwhere ;
if(ishead ==0) sqlstr += "where subledgercount = 0 " ;
else sqlstr += " and subledgercount = 0 " ;
sqlstr += " order by ledgermark " ;
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="FnaLedgerBrowser.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
    <TR class=spacing style="height: 1px">
      <TD class=line1 colspan=4></TD>
    </TR>
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=inputstle name="categoryid" onChange="SearchForm.submit()">
		<option value=""> </option>
<%
while(LedgerCategoryComInfo.next()) {
	String tmpcategoryid = Util.null2String(LedgerCategoryComInfo.getLedgerCategoryid());
	String tmpcategoryname = Util.toScreen(LedgerCategoryComInfo.getLedgerCategoryname(),user.getLanguage()) ;
%>
          <option value="<%=tmpcategoryid%>" <% if(tmpcategoryid.equals(categoryid)) {%>selected<%}%>><%=tmpcategoryname%></option>
        <%}%>
		</select>
      </TD>
      <TD width=15%>&nbsp;</TD>
      <TD width=35%>&nbsp; </TD>
    </TR>
    </table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"></TH>
      <TH width=40%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
      <TH width=60%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
    </tr><TR class=Line style="height: 1px"><TH colspan="4" ></TH></TR>

<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String ledgermarks = Util.toScreen(RecordSet.getString("ledgermark"),user.getLanguage());
	String ledgernames = Util.toScreen(RecordSet.getString("ledgername"),user.getLanguage());
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
	<TD width=0% style="display:none"><A HREF=#><%=ids%></A></TD>
	<TD><%=ledgermarks%></TD>
	<TD><%=ledgernames%></TD>
</TR>
<%}
%>

</TABLE>
  <input type="hidden" name="sqlwhere" value="<%=xssUtil.put(sqlwhere1)%>">
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
<script type="text/javascript">

var parentWin = null;
var dialog = null;
var config = null;
try {
    parentWin = parent.parent.getParentWindow(parent);
    dialog = parent.parent.getDialog(parent);
} catch (e) {
}

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
	    //window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(2).innerText,e.parentelement.cells(2).innerText)
	    
	    var returnjson = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().next().text(),other1:$(this).find("td:first").next().next().text()};
        if(dialog){
            try{
                dialog.callback(returnjson);
            }catch(e){}
            try{
                dialog.close(returnjson);
            }catch(e){}
        } else {
        
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().next().text(),other1:$(this).find("td:first").next().next().text()};
			window.parent.close()
			}
		
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})


function submitClear()
{

    var returnjson = {id:"",name:"",other1:""};
    if(dialog){
        try{
            dialog.callback(returnjson);
        }catch(e){}
        try{
            dialog.close(returnjson);
        }catch(e){}
    }else{ 
        window.parent.returnValue = {id:"",name:"",other1:""};
    window.parent.close()
     }
	
}
</script>
</BODY>
</HTML>