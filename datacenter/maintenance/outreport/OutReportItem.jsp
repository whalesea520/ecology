<%@ page import="weaver.general.Util,java.util.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%

int outrepid = Util.getIntValue(request.getParameter("outrepid"),0);
rs.executeProc("T_OutReport_SelectByOutrepid",""+outrepid);
rs.next() ;

String outrepname = Util.toScreenToEdit(rs.getString("outrepname"),user.getLanguage()) ;
int outreprow = Util.getIntValue(rs.getString("outreprow")) ;
int outrepcolumn = Util.getIntValue(rs.getString("outrepcolumn")) ;
String outrepdesc = Util.toScreenToEdit(rs.getString("outrepdesc"),user.getLanguage()) ;
String outrepcategory = Util.null2String(rs.getString("outrepcategory")) ;  /*报表所属 0:固定报表 1：明细报表 2:排序报表 , 只有固定报表和排序报表有报表项定义*/

int columncount = outrepcolumn + 1 ;
ArrayList rowcols = new ArrayList() ;
ArrayList itemdescs = new ArrayList() ;

rs.executeSql("select itemid ,itemrow, itemcolumn , itemdesc from T_OutReportItem where outrepid = " + outrepid) ;
while(rs.next()) {
  String theitemdesc = Util.toScreen(rs.getString("itemdesc"),user.getLanguage()) ;
	String therow = Util.null2String(rs.getString("itemrow")) ;
	String thecol = Util.null2String(rs.getString("itemcolumn")) ;
	rowcols.add(therow+"_"+thecol) ;
  itemdescs.add(theitemdesc) ;
}

ArrayList rows = new ArrayList() ;

rs.executeSql("select itemrow from T_OutReportItemRow where outrepid = " + outrepid) ;
while(rs.next()) {
	String therow = Util.null2String(rs.getString("itemrow")) ;
	rows.add(therow) ;
}


// 刘煜增加，判断是否有定义某一列的所属组
ArrayList rowgroups = new ArrayList() ;
ArrayList rowcrmgroups = new ArrayList() ;

rs.executeSql("select itemrow,rowgroup from T_OutReportItemRowGroup where outrepid = " + outrepid) ;
while(rs.next()) {
  String therow = Util.null2String(rs.getString("itemrow")) ;
  String thecrm = Util.null2String(rs.getString("rowgroup")) ;
  rowgroups.add(therow) ;
  rowcrmgroups.add(thecrm) ;
}


String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(20743,user.getLanguage()) + outrepname ;
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",OutReportItemCopy.jsp?outrepid="+outrepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",OutReportItemDelete.jsp?outrepid="+outrepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",OutReportEdit.jsp?outrepid="+outrepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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



<TABLE class=liststyle cellspacing=1 style="CURSOR: hand" >
  <TBODY>
  <TR class=header>
    <TH colSpan=<%=columncount%>><%=SystemEnv.getHtmlLabelName(20743,user.getLanguage())%>:<%=outrepname%></TH></TR>
  <TR class=Header>
    <TD>&nbsp;</TD>
	<% for(int i= 1; i<=outrepcolumn ; i++) {
		String thechar = Util.getCharString(i) ;
    %>
    <TD><%=i+"("+thechar+")"%></TD>
	<%}%>
  </TR>
    <TR class=line>
    <TH colSpan=<%=columncount%>></TH></TR>
  <% for(int j= 1; j<outreprow+1 ; j++) {  
       int grouprowindex = rowgroups.indexOf(""+j) ;
       String thecrmgroup = "" ;
       if(grouprowindex != -1) thecrmgroup = (String)rowcrmgroups.get(grouprowindex) ;
  %>
  <TR class=datalight>
    <TD class=Header><nobr>
    <a href="javascript:onShowAll('<%=j%>');"><%=j%></a>
    <% if(outrepcategory.equals("0")) { // 只有为固定报表时候显示展开 %>
    <%if(rows.indexOf(""+j)>=0) {%><a href='OutReportItemOperation.jsp?operation=editrow&outrepid=<%=outrepid%>&itemrow=<%=j%>'><IMG SRC="\images\btnDocExpand.gif" BORDER="0" HEIGHT="12px" WIDTH="12px"></a>
    <%}else{%>
    <a href='OutReportItemOperation.jsp?operation=editrow&outrepid=<%=outrepid%>&itemrow=<%=j%>'><IMG SRC="\images\btnDocCollapse.gif" BORDER="0" HEIGHT="12px" WIDTH="12px"></a>
    <%} } %>
    <!-- 刘煜增加显示选择组的按钮 -->
    <button class=Browser id=SelectGroup onClick="onShowCustomer('<%=j%>','<%=thecrmgroup%>')"></button><span name="groupimg<%=j%>" id="groupimg<%=j%>"><%if(grouprowindex != -1) { %><img src="/Images/BacoCheck.gif"><%}%></span>
    </TD>
    <% for(int i= 1; i<=outrepcolumn ; i++) {  
        int rowcolindex = rowcols.indexOf(""+j+"_"+i) ;
    %>
    <TD <%if(rowcolindex != -1) {%> title="<%=itemdescs.get(rowcolindex)%>" <%}%> id= "td<%=j%>_<%=i%>"><button class=Browser id=SelectItem onClick="onShowItem('<%=j%>','<%=i%>')"></button><span name="img<%=j%>_<%=i%>" id="img<%=j%>_<%=i%>"><%if(rowcolindex != -1) { %><img src="/Images/BacoCheck.gif"><%}%></span>
	</TD>
	<%}%>
    
  </TR>
<%
    }
%>  
 </TBODY></TABLE>
 
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

<FORM id=frmMain name=frmMain action="OutReportItemOperation.jsp" method=post>
<input type="hidden" name=operation>
<input type=hidden name=outrepid value="<%=outrepid%>">
<input type=hidden name=itemrow value="">
<input type=hidden name=crmgroup value="">
</FORM>

<script language=javascript>
function onShowItem(row , column) {
    url = "/systeminfo/BrowserMain.jsp?url=/datacenter/maintenance/outreport/OutReportItemDetail.jsp?allid=<%=outrepid%>_"+row+"_"+column+"_<%=outrepcategory%>" ;
    returnvalue = window.showModalDialog(url,'','dialogHeight:600px;dialogwidth:750px');
    if( returnvalue != null ) {
        if (returnvalue != "") {
	        document.all("img"+row+"_"+column).innerHTML = "<img src='/images/BacoCheck.gif'></img>" ;
            document.all("td"+row+"_"+column).title = returnvalue ;
        }
        else {
            document.all("img"+row+"_"+column).innerHTML = "" ;
            document.all("td"+row+"_"+column).title = "" ;
        } 
    }
}

function onShowGroup(row) {
    url = "/systeminfo/BrowserMain.jsp?url=/datacenter/maintenance/outreport/OutReportItemGroup.jsp?allid=<%=outrepid%>_"+row ;
    returnvalue = window.showModalDialog(url,'','dialogHeight:500px;dialogwidth:600px');
    if( returnvalue != null ) {
        if (returnvalue != "") {
            document.all("groupimg"+row).innerHTML = "<img src='/Images/BacoCheck.gif'></img>" ;
        }
        else {
            document.all("groupimg"+row).innerHTML = "" ;
        } 
    }
}
function onShowAll(row){
    url = "/systeminfo/BrowserMain.jsp?url=/datacenter/maintenance/outreport/OutReportRowItems.jsp?allid=<%=outrepid%>_"+row ;
    returnvalue = window.showModalDialog(url,'','dialogHeight:600px;dialogwidth:750px');
    if( returnvalue != null ) {
        var values=returnvalue.split(",");
        for(var i=0;i<values.length;i++){
            var col=values[i].split("_");
            if(col[2]==1){
                document.all("img"+row+"_"+col[0]).innerHTML = "<img src='/images/BacoCheck.gif'></img>" ;
                document.all("td"+row+"_"+col[0]).title = col[1] ;
            }else{
                document.all("img"+row+"_"+col[0]).innerHTML = "" ;
                document.all("td"+row+"_"+col[0]).title = col[1] ;
            }
        }
    }
}
</script>


<script language=vbs>
sub onShowCustomer(row,thevalue)
  id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="&thevalue)
  if NOT isempty(id) then
    if id(0)<> "" then
      document.frmMain.crmgroup.value= right(id(0),len(id(0))-1)     
    else
	  document.frmMain.crmgroup.value=""
	end if
	document.frmMain.operation.value="editcrmgroup" 
	document.frmMain.itemrow.value= row 
	document.frmMain.submit()
  end if
end sub

</script>

 
</BODY></HTML>
