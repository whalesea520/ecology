<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% 
if(!HrmUserVarify.checkUserRight("FnaBudget:Approve",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String departmentid = Util.null2String(request.getParameter("departmentid"));
String fnayear = Util.null2String(request.getParameter("fnayear"));
String budgetinfoid = Util.null2String(request.getParameter("budgetinfoid"));

ArrayList cbudgettypeperiods = new ArrayList() ;
ArrayList cbudgetaccounts = new ArrayList() ;

if( !budgetinfoid.equals("") ) {
    String sqlstr =" select budgettypeid, budgetperiods , sum(budgetaccount) as budgetaccount from FnaBudgetCheckDetail where budgetinfoid="+ budgetinfoid + " group by budgettypeid, budgetperiods " ;

    RecordSet.executeSql(sqlstr);
    while(RecordSet.next()){
        String tempbudgettypeid = Util.null2String(RecordSet.getString(1)) ;
        String tempbudgetperiods = Util.null2String(RecordSet.getString(2)) ;
        String tempaccount = "" + Util.getDoubleValue(RecordSet.getString(3),0) ;

        if(tempaccount.equals("0")) continue ;
            
        cbudgettypeperiods.add(tempbudgettypeid + "_" + tempbudgetperiods ) ;
        cbudgetaccounts.add( tempaccount ) ;
    }
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(386,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if( !budgetinfoid.equals("") && cbudgettypeperiods.size() == 0 ) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(15369,user.getLanguage())+",javascript:onLoad(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onReturn(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<FORM id=frmMain name=frmMain action=FnaBudgetOperation.jsp method=post>
  <input type=hidden name="operation" value="editcheck">
  <input type=hidden name="departmentid" value="<%=departmentid%>">
  <input type=hidden name="fnayear" value="<%=fnayear%>">
  <input type=hidden name="budgetinfoid" value="<%=budgetinfoid%>">
 
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="15%"></COL> <COL width="40%"></COL><COL width="5%"></COL> 
    <COL width="15%"></COL> <COL width="25%"></COL> <THEAD> 
    <TR class=Title> 
    <TH colspan="2"> 
      <P align=left><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>: <%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></P>
    </TH>
    <TH colSpan=3 style="TEXT-ALIGN: right"><nobr>
    <%=SystemEnv.getHtmlLabelName(15365,user.getLanguage())%>: <%=fnayear%>
    </TH>
    </TR>
    <TR><TD class=Line colSpan=6></TD></TR> 
    </THEAD>
    <TBODY> 
    <TR class=Spacing> 
      <TD class=Line1 colSpan=5></TD>
    </TR>
    </TBODY>
  </TABLE>

<br>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP> 
    <col width="10%">
    <col width="6.5%">
    <col width="6.5%">
    <col width="6.5%">
    <col width="6.5%">
    <col width="6.5%">
    <col width="6.5%">
    <col width="6.5%">
    <col width="6.5%">
    <col width="6.5%">
    <col width="6.5%">
    <col width="6.5%">
    <col width="6.5%">
    <col width="8%">
  <THEAD> 
  <TR class=Header> 
    <TH colspan="14"><%=SystemEnv.getHtmlLabelName(15370,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15371,user.getLanguage())%></th>
  <th>1<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>2<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>3<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>4<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>5<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>6<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>7<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>8<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>9<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>10<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>11<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>12<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>        
  </tr>
  <TR class=Line><TD colspan="14" ></TD></TR> 
<%
    boolean isLight = false;
    RecordSet.executeSql(" select id ,name from FnaBudgetfeeType where feeperiod = 1 ");
	while(RecordSet.next())
	{
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        isLight = !isLight ;
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD><%=name%></TD>
<%
        double yearcount = 0 ;
        for( int i=1 ; i<13 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = cbudgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) cbudgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
%>
        <TD><input class=inputstyle type=text id=budgetaccount_<%=id%>_<%=i%> name='budgetaccount_<%=id%>_<%=i%>' style='width:100%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)' maxlength='15' value="<%=tempbudgetaccount%>" onchange="changenumber('<%=id%>', '13')"></TD>
<%      } 
        
        String yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
%>      
   		<TD style="TEXT-ALIGN: right" id='year<%=id%>' name='year<%=id%>'><%=yearcountstr%></TD>        
	</TR>
<%
	}
%>
  </TBODY> 
</TABLE>


<br>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP> 
    <col width="10%">
    <col width="17%">
    <col width="17%">
    <col width="17%">
    <col width="17%">
    <col width="22%">
  <THEAD> 
  <TR class=Header> 
    <TH colspan="6"><%=SystemEnv.getHtmlLabelName(15373,user.getLanguage())%></TH>
  </TR>  
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15371,user.getLanguage())%></th>
  <th>1<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>2<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>3<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>4<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>        
  </tr>
   <TR class=Line><TD colspan="6" ></TD></TR> 
<%
    isLight = false;
    RecordSet.executeSql(" select id ,name from FnaBudgetfeeType where feeperiod = 2 ");
	while(RecordSet.next())
	{
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        isLight = !isLight ;
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD><%=name%></TD>
<%
        double yearcount = 0 ;
        for( int i=1 ; i<5 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = cbudgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) cbudgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
%>
        <TD><input class=inputstyle type=text id=budgetaccount_<%=id%>_<%=i%> name='budgetaccount_<%=id%>_<%=i%>' style='width:100%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)' maxlength='15' value="<%=tempbudgetaccount%>" onchange="changenumber('<%=id%>', '5')"></TD>
<%      } 
        
        String yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
%>      
   		<TD style="TEXT-ALIGN: right" id='year<%=id%>' name='year<%=id%>'><%=yearcountstr%></TD>       
	</TR>
<%
	}
%>
  </TBODY> 
</TABLE>


<br>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP> 
    <col width="10%">
    <col width="27%">
    <col width="27%">
    <col width="36%">
  <THEAD> 
  <TR class=Header> 
    <TH colspan="5"><%=SystemEnv.getHtmlLabelName(15374,user.getLanguage())%></TH>
  </TR>  
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15371,user.getLanguage())%></th>
  <th>1<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>2<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>        
  </tr>
   <TR class=Line><TD colspan="4" ></TD></TR> 
<%
    isLight = false;

    RecordSet.executeSql(" select id ,name from FnaBudgetfeeType where feeperiod = 3 ");
	while(RecordSet.next())
	{
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        isLight = !isLight ;
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD><%=name%></TD>
<%
        double yearcount = 0 ;
        for( int i=1 ; i<3 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = cbudgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) cbudgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
%>
        <TD><input class=inputstyle type=text id=budgetaccount_<%=id%>_<%=i%> name='budgetaccount_<%=id%>_<%=i%>' style='width:100%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)' maxlength='15' value="<%=tempbudgetaccount%>" onchange="changenumber('<%=id%>', '3')"></TD>
<%      } 
        
        String yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
%>      
   		<TD style="TEXT-ALIGN: right" id='year<%=id%>' name='year<%=id%>'><%=yearcountstr%></TD>      
	</TR>
<%
	}
%>
  </TBODY> 
</TABLE>

<br>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP> 
    <col width="10%">
    <col width="90%">
  <THEAD> 
  <TR class=Header> 
    <TH colspan="2"><%=SystemEnv.getHtmlLabelName(15375,user.getLanguage())%></TH>
   </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15371,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>        
  </tr>
   <TR class=Line><TD colspan="2" ></TD></TR> 
<%
    isLight = false;

    RecordSet.executeSql(" select id ,name from FnaBudgetfeeType where feeperiod = 4 ");
	while(RecordSet.next())
	{
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        isLight = !isLight ;
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD><%=name%></TD>
<%
        for( int i=1 ; i<2 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = cbudgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) cbudgetaccounts.get(accountindex) ;
            }
%>
        <TD><input class=inputstyle type=text id=budgetaccount_<%=id%>_<%=i%> name='budgetaccount_<%=id%>_<%=i%>' style='width:100%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)' maxlength='15' value="<%=tempbudgetaccount%>"></TD>
<%      } %>      
	</TR>
<%
	}
%>
  </TBODY> 
</TABLE>
</FORM>
</FORM>
<form id=frmMainReturn name=frmMainReturn method=post action=FnaBudgetDetail.jsp>
  <input class=inputstyle type=hidden name="departmentid" value="<%=departmentid%>">
  <input class=inputstyle type=hidden name="fnayear" value="<%=fnayear%>">
</form>
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
<script language=javascript>
function onReturn() {
    document.frmMainReturn.submit();
}

function onLoad() {
    document.frmMain.operation.value="loadbudget" ;
    document.frmMain.submit();
}

function changenumber(rowval, rowcount){
	count_detail = 0 ;
    count_year = 0;

    for( i= 1 ; i< toInt( rowcount ) ; i++ ) {
        count_detail = eval(toFloat(document.all("budgetaccount_"+rowval+"_"+i).value,0));
        count_year += count_detail ;
    }
	document.all("year"+rowval).innerHTML = toFloat(count_year) ; 
}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}
function toInt(str , def) {
	if(isNaN(parseInt(str))) return def ;
	else return str ;
}
function submitData() {
 frmMain.submit();
}
</script>
</BODY>
</HTML>