
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<%@ page import = "weaver.general.Util,weaver.file.*,java.util.*" %>
<%@ page import = "" %>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "DepartmentComInfo" class = "weaver.hrm.company.DepartmentComInfo" scope = "page"/>
<jsp:useBean id = "ResourceComInfo" class = "weaver.hrm.resource.ResourceComInfo" scope = "page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<HTML><HEAD>
<LINK href = "/css/Weaver_wev8.css" type = text/css rel = STYLESHEET>
<SCRIPT language = "javascript" src = "/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16888,user.getLanguage()); 
String needfav = "1" ; 
String needhelp = "" ; 

String fromdate = Util.fromScreen(request.getParameter("fromdate") , user.getLanguage()) ; //排班日期从
String enddate = Util.fromScreen(request.getParameter("enddate") , user.getLanguage()) ; //排班日期到

String isself = Util.null2String(request.getParameter("isself"));

Calendar thedate = Calendar.getInstance() ; //

// 如果用户选择的开始日期或者结束日期为空，则默认为当月的时间 //上周一到下周日
if( fromdate.equals("") || enddate.equals("")) {
//    while( thedate.get(Calendar.DAY_OF_WEEK) != 2 ) thedate.add(Calendar.DATE, 1) ; 
    thedate.set( thedate.get(Calendar.YEAR),thedate.get(Calendar.MONTH),1) ;
    fromdate = Util.add0(thedate.get(Calendar.YEAR), 4) + "-" + 
               Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
               Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
    thedate.add(Calendar.MONTH , 1) ; 
    thedate.add(Calendar.DATE , -1) ; 
    enddate = Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
              Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
              Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
} 



String sql = " select * from HrmValidateCardInfo where carddate >= '" + fromdate + "' and carddate <= '"+ enddate + "' order by carddate desc " ; 

%>
<BODY>
<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15846,user.getLanguage())+",javascript:doRecreate(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id = frmmain name = frmmain method = post action="HrmRpValidateTimecard.jsp">
<input type="hidden" name="operation" value=recreate>
<input type="hidden" name="isself" value="1">

<table class = viewform>
<tbody>
<TR CLASS = spacing><TD colspan = 2 class = sep2></TD></TR>
<tr>
    <td width=10%><%=SystemEnv.getHtmlLabelName(16703,user.getLanguage())%></td>
    <td class = field>
    <BUTTON type=button class = calendar id = SelectDate onclick = getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
    <SPAN id = fromdatespan><%=fromdate%></SPAN>
    <input type = "hidden" name = "fromdate" value=<%=fromdate%>>
    －<BUTTON type=button class = calendar id = SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=enddate%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
</tr>
</tbody>
</table>

<% if(isself.equals("1")) { %>
<TABLE class = ListStyle cellspacing=1 >
  <colgroup>
<col width="25%">
<col width="20%">
<col width="15%">
<col width="15%">
<col width="15%">
  <TBODY>
  <TR class = Section>
    <TH colspan=5><%=SystemEnv.getHtmlLabelName(16888,user.getLanguage())%></TH>
  </TR>
  <TR class=Line><TD colspan=5 ></TD></TR> 
  <TR class = Header>
    <TH><%=SystemEnv.getHtmlLabelName(18948,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(16703,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(18949,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(18950,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(18951,user.getLanguage())%></TH>
    </TR>
    <TR class=Line><TD colspan=5 ></TD></TR> 
  <%
    boolean isLight = false ; 
    RecordSet.executeSql(sql) ; 
    while(RecordSet.next()) { 	
        
        String Cardid = Util.null2String(RecordSet.getString("Cardid")) ; 
        String carddate = Util.null2String(RecordSet.getString("carddate")) ; 
        String cardtime = Util.null2String(RecordSet.getString("cardtime")) ; 
        String stationid = Util.null2String(RecordSet.getString("stationid")) ; 
        String workshift = Util.null2String(RecordSet.getString("workshift")) ; 
        isLight = !isLight ;
        
  %> 
       <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
        <TD><%=Cardid%></TD>
        <TD><%=carddate%></TD>
        <TD><%=cardtime%></TD>
        <TD><%=stationid%></TD>
        <TD><%=workshift%></TD>
  <% } %>
     </TR> 
  </TBODY>
 </TABLE>
 <%}%>
 </form>
 <BR>

<script language = vbs>  
sub onShowDepartment(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputname.value)
	if Not isempty(id) then
	if id(0)<> 0 then
        spanname.innerHtml = id(1)
        inputname.value=id(0)
	else
        spanname.innerHtml = ""
        inputname.value=""
	end if
	end if
end sub
</script>

<script language=javascript>  
function doRecreate() {
 frmmain.action= "/hrm/schedule/HrmValidateTimecardOperation.jsp";
 frmmain.submit();
}

function doSearch(){
 jQuery("#frmmain").submit();
}

</script>

</body> 
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
