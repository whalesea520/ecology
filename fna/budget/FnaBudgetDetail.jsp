<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String departmentid = Util.null2String(request.getParameter("departmentid"));
String fnayear = Util.null2String(request.getParameter("fnayear"));

// 具有查看该部门权限的人， 本部门主管和财务管理员
boolean canview = HrmUserVarify.checkUserRight("FnaBudget:All",user,departmentid) ;
boolean canedit =  HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) && (""+user.getUserDepartment()).equals(departmentid) ;
boolean canapprove = HrmUserVarify.checkUserRight("FnaBudget:Approve",user) ;

// 将通过作为单独的权限
boolean canprocess = HrmUserVarify.checkUserRight("FnaBudget:Process",user) ;

if(!canview && !canedit && !canapprove && !canprocess) {
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
String budgetinfoid = "" ;
String budgetstatus = "" ;
String sqlstr = "" ;

if(fnayear.equals("")) {
	RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear","");
	if(RecordSet.next()) fnayear = RecordSet.getString("fnayear") ;
	else {
		Calendar today = Calendar.getInstance();
		fnayear = Util.add0(today.get(Calendar.YEAR), 4) ;
	}
}

if( budgetinfoid.equals("") ) {
    sqlstr =" select id , budgetstatus from FnaBudgetInfo where  budgetyears= '"+ fnayear + "'  and budgetdepartmentid = "+ departmentid ;
    RecordSet.executeSql(sqlstr);
    if( RecordSet.next() ) {
        budgetinfoid = Util.null2String( RecordSet.getString(1) ) ;
        budgetstatus = Util.null2String(RecordSet.getString(2)) ;
    }
}


ArrayList budgettypeperiods = new ArrayList() ;
ArrayList budgetaccounts = new ArrayList() ;
ArrayList cbudgettypeperiods = new ArrayList() ;
ArrayList cbudgetaccounts = new ArrayList() ;

if( !budgetinfoid.equals("") ) {
    sqlstr =" select budgettypeid, budgetperiods , sum(budgetaccount) as budgetaccount from FnaBudgetInfoDetail where budgetinfoid="+ budgetinfoid + " group by budgettypeid, budgetperiods " ;

    RecordSet.executeSql(sqlstr);
    while(RecordSet.next()){
        String tempbudgettypeid = Util.null2String(RecordSet.getString(1)) ;
        String tempbudgetperiods = Util.null2String(RecordSet.getString(2)) ;
        String tempaccount = "" + Util.getDoubleValue(RecordSet.getString(3),0) ;

        if(tempaccount.equals("0")) continue ;
            
        budgettypeperiods.add(tempbudgettypeid + "_" + tempbudgetperiods ) ;
        budgetaccounts.add( tempaccount ) ;
    }

    sqlstr =" select budgettypeid, budgetperiods , sum(budgetaccount) as budgetaccount from FnaBudgetCheckDetail where budgetinfoid="+ budgetinfoid + " group by budgettypeid, budgetperiods " ;

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


boolean canapproveedit = canapprove && !budgetstatus.equals("1") ;
canprocess = canprocess && !budgetinfoid.equals("") && !budgetstatus.equals("1") ;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(386,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canprocess){ 
RCMenu += "{"+SystemEnv.getHtmlLabelName(15376,user.getLanguage())+",javascript:onApprove(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(canapproveedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15377,user.getLanguage())+",javascript:onApproveEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(canapprove){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onReturn(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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

<FORM id=frmMain name=frmMain action=FnaBudgetDetail.jsp method=post>
<input class=iuputstyle type=hidden name="operation" value="approve">
<input class=iuputstyle id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
<input class=iuputstyle id=budgetstatus type=hidden name=budgetstatus value="<%=budgetstatus%>">
<input class=iuputstyle id=budgetinfoid type=hidden name=budgetinfoid value="<%=budgetinfoid%>">

 <TABLE class=Form>
    <COLGROUP> <COL width="15%"></COL> <COL width="40%"></COL><COL width="5%"></COL> 
    <COL width="15%"></COL> <COL width="25%"></COL> <THEAD> 
    <TR class=Title> 
    <TH colspan="2"> 
      <P align=left><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>: <%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></P>
    </TH>
    <TH colSpan=3 style="TEXT-ALIGN: right"><nobr>
    <%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%>: <% if( budgetstatus.equals("1") ) {%><%=SystemEnv.getHtmlLabelName(1423,user.getLanguage())%><%} else if( budgetstatus.equals("0") ) { %><%=SystemEnv.getHtmlLabelName(1422,user.getLanguage())%><%}%>
    </TH>
  </TR>
    </THEAD> <TBODY> 
    <TR class=Spacing> 
      <TD class=Sep1 colSpan=5></TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(15365,user.getLanguage())%></td>
      <td class=Field colSpan=4> 
        <select class= inputstyle name="fnayear" onchange="frmMain.submit()">
          <%
		RecordSet.executeProc("FnaYearsPeriods_Select","");
		while(RecordSet.next()) {
			String thefnayear = RecordSet.getString("fnayear") ;
		%>
          <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayear)) {%>selected<%}%>><%=thefnayear%></option>
          <%}%>
        </select>
      </td>
    </tr>
    </TBODY> 
  </TABLE>
</FORM>
<br>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP> 
    <col width="10%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="8%">
  <THEAD> 
  <TR class=Header> 
    <TH colspan="15"><%=SystemEnv.getHtmlLabelName(15370,user.getLanguage())%></TH>
   </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15371,user.getLanguage())%></th>
  <th>&nbsp;</th>
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
  <TR class=Line><TD colspan="15" ></TD></TR> 
<%
    ArrayList infoaccounts = new ArrayList() ;
    ArrayList checkaccounts = new ArrayList() ;
    double infoyearcount = 0 ;
    boolean canappove = true ;

    boolean isLight = false;
    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 1 ");
	while(RecordSet.next())
	{
        infoaccounts.clear() ;
        checkaccounts.clear() ;
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        String feetype = Util.toScreen(RecordSet.getString("feetype"),user.getLanguage()) ;
        isLight = !isLight ;
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD rowspan=3><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
        <TD><%=SystemEnv.getHtmlLabelName(15366,user.getLanguage())%></TD>
<%
        double yearcount = 0 ;
        for( int i=1 ; i<13 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = budgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
            infoaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      } 
        
        infoyearcount = yearcount ;
        String yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        infoaccounts.add( yearcountstr ) ;
%>      
   		<TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
	</TR>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD><%=SystemEnv.getHtmlLabelName(15367,user.getLanguage())%></TD>
<%
        yearcount = 0 ;
        for( int i=1 ; i<13 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = cbudgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) cbudgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
            checkaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      } 
        
        if( feetype.equals("1") ) {
            if( infoyearcount > yearcount && infoyearcount != 0 ) canappove = false ;
        }
        else if( feetype.equals("2") ) {
            if( infoyearcount < yearcount && yearcount != 0 ) canappove = false ;
        }

        yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        checkaccounts.add( yearcountstr ) ;
%>      
   		<TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>      
	</TR>
    <TR CLASS=Total STYLE="COLOR:RED;FONT-WEIGHT:BOLD">
        <TD><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
<%
        for( int i=0 ; i<13 ; i++ ) {
            String tempbudgetaccount = (String) infoaccounts.get(i) ;
            String tempcbudgetaccount = (String) checkaccounts.get(i) ;
            String tempaccountgap = "" ;
            
            if( !tempbudgetaccount.equals("") && !tempcbudgetaccount.equals("") ) {
                double accountgapdouble =  ( Util.getDoubleValue(tempbudgetaccount)  - Util.getDoubleValue(tempcbudgetaccount) ) * 100 / Util.getDoubleValue(tempcbudgetaccount) ;
                int accountgapint = (new Double( accountgapdouble )).intValue() ;
                if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
                if( accountgapint != 0 ) tempaccountgap = "" + accountgapint + "%" ;
            }
%>
        <TD style="TEXT-ALIGN: right"><%=tempaccountgap%></TD>
<%      } %>      
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
    <col width="6%">
    <col width="16%">
    <col width="16%">
    <col width="16%">
    <col width="16%">
    <col width="20%">
  <THEAD> 
  <TR class=Header> 
    <TH colspan="7"><%=SystemEnv.getHtmlLabelName(15373,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15371,user.getLanguage())%></th>
  <th>&nbsp;</th>
  <th>1<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>2<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>3<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>4<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>        
  </tr>
  <TR class=Line><TD colspan="7" ></TD></TR> 
<%
    isLight = false;

    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 2 ");
	while(RecordSet.next())
	{
        infoaccounts.clear() ;
        checkaccounts.clear() ;
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        String feetype = Util.toScreen(RecordSet.getString("feetype"),user.getLanguage()) ;
        isLight = !isLight ;
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD rowspan=3><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
        <TD><%=SystemEnv.getHtmlLabelName(15366,user.getLanguage())%></TD>
<%
        double yearcount = 0 ;
        for( int i=1 ; i<5 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = budgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
            infoaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      } 
        
        infoyearcount = yearcount ;
        String yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        infoaccounts.add( yearcountstr ) ;
%>      
   		<TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
	</TR>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD><%=SystemEnv.getHtmlLabelName(15367,user.getLanguage())%></TD>
<%
        yearcount = 0 ;
        for( int i=1 ; i<5 ; i++ ) {
            String tempbudgetaccount = "" ; 
            int accountindex = cbudgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) cbudgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
            checkaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      } 
        
        if( feetype.equals("1") ) {
            if( infoyearcount > yearcount && infoyearcount != 0 ) canappove = false ;
        }
        else if( feetype.equals("2") ) {
            if( infoyearcount < yearcount && yearcount != 0 ) canappove = false ;
        }

        yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        checkaccounts.add( yearcountstr ) ;
%>      
   		<TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>       
	</TR>
    <TR CLASS=Total STYLE="COLOR:RED;FONT-WEIGHT:BOLD">
        <TD><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
<%
        for( int i=0 ; i<5 ; i++ ) {
            String tempbudgetaccount = (String) infoaccounts.get(i) ;
            String tempcbudgetaccount = (String) checkaccounts.get(i) ;
            String tempaccountgap = "" ;
            
            if( !tempbudgetaccount.equals("") && !tempcbudgetaccount.equals("") ) {
                double accountgapdouble =  ( Util.getDoubleValue(tempbudgetaccount)  - Util.getDoubleValue(tempcbudgetaccount) ) * 100 / Util.getDoubleValue(tempcbudgetaccount) ;
                int accountgapint = (new Double( accountgapdouble )).intValue() ;
                if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
                if( accountgapint != 0 ) tempaccountgap = "" + accountgapint + "%" ;
            }
%>
        <TD style="TEXT-ALIGN: right"><%=tempaccountgap%></TD>
<%      } %>      
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
    <col width="6%">
    <col width="25%">
    <col width="25%">
    <col width="34%">
  <THEAD> 
  <TR class=Header> 
    <TH colspan="5"><%=SystemEnv.getHtmlLabelName(15374,user.getLanguage())%></TH>
   </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15371,user.getLanguage())%></th>
  <th>&nbsp;</th>
  <th>1<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>2<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>        
  </tr>
  <TR class=Line><TD colspan="5" ></TD></TR> 
<%
    isLight = false;

    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 3 ");
	while(RecordSet.next())
	{
        infoaccounts.clear() ;
        checkaccounts.clear() ;
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        String feetype = Util.toScreen(RecordSet.getString("feetype"),user.getLanguage()) ;
        isLight = !isLight ;
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD rowspan=3><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
        <TD><%=SystemEnv.getHtmlLabelName(15366,user.getLanguage())%></TD>
<%
        double yearcount = 0 ;
        for( int i=1 ; i<3 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = budgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
            infoaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      } 
        
        infoyearcount = yearcount ;
        String yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        infoaccounts.add( yearcountstr ) ;
%>      
   		<TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
	</TR>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD><%=SystemEnv.getHtmlLabelName(15367,user.getLanguage())%></TD>
<%
        yearcount = 0 ;
        for( int i=1 ; i<3 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = cbudgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) cbudgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
            checkaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      } 
        
        if( feetype.equals("1") ) {
            if( infoyearcount > yearcount && infoyearcount != 0 ) canappove = false ;
        }
        else if( feetype.equals("2") ) {
            if( infoyearcount < yearcount && yearcount != 0 ) canappove = false ;
        }

        yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        checkaccounts.add( yearcountstr ) ;
%>      
   		<TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>           
	</TR>
    <TR CLASS=Total STYLE="COLOR:RED;FONT-WEIGHT:BOLD">
        <TD><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
<%
        for( int i=0 ; i<3 ; i++ ) {
            String tempbudgetaccount = (String) infoaccounts.get(i) ;
            String tempcbudgetaccount = (String) checkaccounts.get(i) ;
            String tempaccountgap = "" ;
            
            if( !tempbudgetaccount.equals("") && !tempcbudgetaccount.equals("") ) {
                double accountgapdouble =  ( Util.getDoubleValue(tempbudgetaccount)  - Util.getDoubleValue(tempcbudgetaccount) ) * 100 / Util.getDoubleValue(tempcbudgetaccount) ;
                int accountgapint = (new Double( accountgapdouble )).intValue() ;
                if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
                if( accountgapint != 0 ) tempaccountgap = "" + accountgapint + "%" ;
            }
%>
        <TD style="TEXT-ALIGN: right"><%=tempaccountgap%></TD>
<%      } %>      
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
    <col width="6%">
    <col width="84%">
  <THEAD> 
  <TR class=Header> 
    <TH colspan="3"><%=SystemEnv.getHtmlLabelName(15375,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15371,user.getLanguage())%></th>
  <th>&nbsp;</th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>        
  </tr>
  <TR class=Line><TD colspan="3" ></TD></TR> 
<%
    isLight = false;

    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 4 ");
	while(RecordSet.next())
	{
        infoaccounts.clear() ;
        checkaccounts.clear() ;
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        String feetype = Util.toScreen(RecordSet.getString("feetype"),user.getLanguage()) ;
        isLight = !isLight ;
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD rowspan=3><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
        <TD><%=SystemEnv.getHtmlLabelName(15366,user.getLanguage())%></TD>
<%
        for( int i=1 ; i<2 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = budgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
                infoyearcount = Util.getDoubleValue(tempbudgetaccount,0) ;
            }
            infoaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }%>      
	</TR>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD><%=SystemEnv.getHtmlLabelName(15367,user.getLanguage())%></TD>
<%
        for( int i=1 ; i<2 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = cbudgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) cbudgetaccounts.get(accountindex) ;
            }
            if( feetype.equals("1") ) {
                if( infoyearcount > Util.getDoubleValue(tempbudgetaccount,0)  && infoyearcount != 0 ) canappove = false ;
            }
            else if( feetype.equals("2") ) {
                if( infoyearcount < Util.getDoubleValue(tempbudgetaccount,0) && Util.getDoubleValue(tempbudgetaccount,0) != 0 ) canappove = false ;
            }
            checkaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      } %>      
	</TR>
    <TR CLASS=Total STYLE="COLOR:RED;FONT-WEIGHT:BOLD">
        <TD><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
<%
        for( int i=0 ; i<1 ; i++ ) {
            String tempbudgetaccount = (String) infoaccounts.get(i) ;
            String tempcbudgetaccount = (String) checkaccounts.get(i) ;
            String tempaccountgap = "" ;
            
            if( !tempbudgetaccount.equals("") && !tempcbudgetaccount.equals("") ) {
                double accountgapdouble =  ( Util.getDoubleValue(tempbudgetaccount)  - Util.getDoubleValue(tempcbudgetaccount) ) * 100 / Util.getDoubleValue(tempcbudgetaccount) ;
                int accountgapint = (new Double( accountgapdouble )).intValue() ;
                if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
                if( accountgapint != 0 ) tempaccountgap = "" + accountgapint + "%" ;
            }
%>
        <TD style="TEXT-ALIGN: right"><%=tempaccountgap%></TD>
<%      } %>      
	</TR>
<%
	}
%>
  </TBODY> 
</TABLE>
<form name="detail" action=FnaBudgetTypeDetail.jsp method=post>
  <input class=inputstyle id=budgettypeid type=hidden name=budgettypeid >
  <input class=inputstyle id=fnayear type=hidden name=fnayear value="<%=fnayear%>">
  <input class=inputstyle id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
  <input class=inputstyle id=budgetstatus type=hidden name=budgetstatus value="<%=budgetstatus%>">
  <input class=inputstyle id=budgetinfoid type=hidden name=budgetinfoid value="<%=budgetinfoid%>">
  
</form>

<form name="frmMainApprove" action=FnaBudgetApproveEdit.jsp method=post>
  <input class=inputstyle id=fnayear type=hidden name=fnayear value="<%=fnayear%>">
  <input class=inputstyle id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
  <input class=inputstyle id=budgetinfoid type=hidden name="budgetinfoid" value="<%=budgetinfoid%>">
</form>

<form id=frmMainReturn name=frmMainReturn method=post action=FnaBudget.jsp>
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
function submitBudget(thevalue) {
    detail.budgettypeid.value=thevalue ;
    detail.submit() ;
    return false;
}

function onApproveEdit() {
    document.frmMainApprove.submit();
}

function onReturn() {
    document.frmMainReturn.submit();
}

function onApprove() {
    if(confirm("<%=SystemEnv.getHtmlLabelName(15379,user.getLanguage())%>\n" +
               "<%=SystemEnv.getHtmlLabelName(15380,user.getLanguage())%>\n" +
               "<%=SystemEnv.getHtmlLabelName(15381,user.getLanguage())%>\n" +
               "<%=SystemEnv.getHtmlLabelName(15382,user.getLanguage())%>") ) {
        if(!<%=canappove%>) {
            alert("<%=SystemEnv.getHtmlLabelName(15383,user.getLanguage())%>") ;
        }
        else {
            document.frmMain.action="FnaBudgetOperation.jsp" ;
            document.frmMain.submit();
        }
    }
}
</script>
</BODY>
</HTML>