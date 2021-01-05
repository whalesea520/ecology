<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String resourceid = Util.null2String(request.getParameter("resourceid"));
String fnayear = Util.null2String(request.getParameter("fnayear"));
String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;

//added by lupeng 2004.2.3
    //if the user is himself                                                 ok
    //if the resourceid is the user's follower                  ok
    //if the user have the right of viewing budget          ok
    boolean isManager = false;
    String managerStr = "";
    RecordSet.executeSql(" select managerstr from hrmresource where id = " + resourceid ) ;
    if ( RecordSet.next() ) managerStr = Util.null2String(RecordSet.getString(1)) ;
    if (managerStr.indexOf(String.valueOf(user.getUID())) != -1)
        isManager = true;

    boolean isSameDept = false;
    RecordSet.executeSql(" select departmentid from hrmresource where id = " + resourceid ) ;
    if ( RecordSet.next() && (user.getUserDepartment() == RecordSet.getInt(1)) )
        isSameDept = true;

    if (String.valueOf(user.getUID()).equals(resourceid)) {
        //it's ok.
    } else if (isManager) {
        //it's ok.
    } else if (HrmUserVarify.checkUserRight("FnaBudget:All" , user) && isSameDept) {
        //it's ok.
    } else {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
    }
//end

String budgetinfoid = "" ;
String budgetstatus = "" ;
String status = "" ; 
String revision = ""; 
String sqlstr = "" ; 

if(fnayear.equals("")) {
	//RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear","") ; 
	//if(RecordSet.next()) fnayear = RecordSet.getString("fnayear") ; 
	//else {
		Calendar today = Calendar.getInstance() ; 
		fnayear = Util.add0(today.get(Calendar.YEAR) , 4) ; 
	//}
}

if(budgetinfoid.equals("") ) {
    //sqlstr =" select id , budgetstatus from FnaBudgetInfo where budgetperiods = (select id from FnaYearsPeriods where fnayear= '" + fnayear + "')  " ; 
    sqlstr = "select * from FnaBudgetInfo \n" +
    		" where budgetperiods = (select id from FnaYearsPeriods where fnayear= '"+Util.getIntValue(fnayear)+"') \n" +
    		" and organizationtype = 3 \n" +
    		" and budgetorganizationid = "+Util.getIntValue(resourceid)+" \n" +
    	    " and (status = 1 or status = 3) \n" +//只判断1 生效;3 待审批;
    		" ORDER BY status asc, revision desc ";
	
    RecordSet.executeSql(sqlstr) ; 
    if( RecordSet.next() ) {
        budgetinfoid = Util.null2String( RecordSet.getString("id") ) ; 
        budgetstatus = Util.null2String(RecordSet.getString("budgetstatus")) ; 
        status = Util.null2String(RecordSet.getString("status")) ; 
        revision = Util.null2String(RecordSet.getString("revision")) ; 
    }
}

ArrayList startdates = new ArrayList() ;
ArrayList enddates = new ArrayList() ;
ArrayList feetypeperiods = new ArrayList() ;
ArrayList periodstartdates = new ArrayList() ;
ArrayList periodenddates = new ArrayList() ;

ArrayList budgettypeperiods = new ArrayList() ;
ArrayList budgetaccounts = new ArrayList() ;
ArrayList expensetypeperiods = new ArrayList() ;
ArrayList expenseaccounts = new ArrayList() ;

RecordSet.executeSql("select startdate, enddate from FnaYearsPeriodsList where fnayear= '"+fnayear+"' order by Periodsid ");
while( RecordSet.next() ) {
    startdates.add( Util.null2String(RecordSet.getString( "startdate" ) ) ) ;
    enddates.add( Util.null2String(RecordSet.getString( "enddate" ) ) ) ;
}
    //added by lupeng 2004.2.11
    if (startdates.isEmpty() || enddates.isEmpty() || enddates.size()<12)
        response.sendRedirect("/notice/MissingInfo.jsp") ;
    //end

String fnayearstartdate = (String) startdates.get(0) ;
String fnayearenddate = (String) enddates.get(11) ;

RecordSet.executeSql("select id, feeperiod , agreegap from FnaBudgetfeeType ");
while( RecordSet.next() ) {
    String tempfeetypeid = Util.null2String(RecordSet.getString( "id" ) ) ;
    int tempfeeperiod = Util.getIntValue(RecordSet.getString( "feeperiod" ) , 1 ) ;

    switch( tempfeeperiod ) {
        case 1 :
            for(int i=1 ; i<13; i++) {
                String tempperiodstartdate = (String) startdates.get(i-1) ;
                String tempperiodenddate = (String) enddates.get(i-1) ;
                feetypeperiods.add(tempfeetypeid+"_"+i) ;
                periodstartdates.add(tempperiodstartdate) ;
                periodenddates.add(tempperiodenddate) ;
            }
            break ;
        case 2 :
            for(int i=1 ; i<5; i++) {
                String tempperiodstartdate = (String) startdates.get((i-1)*3) ;
                String tempperiodenddate = (String) enddates.get(i*3-1) ;
                feetypeperiods.add(tempfeetypeid+"_"+i) ;
                periodstartdates.add(tempperiodstartdate) ;
                periodenddates.add(tempperiodenddate) ;
            }
            break ;
        case 3 :
            for(int i=1 ; i<3; i++) {
                String tempperiodstartdate = (String) startdates.get((i-1)*6) ;
                String tempperiodenddate = (String) enddates.get(i*6-1) ;
                feetypeperiods.add(tempfeetypeid+"_"+i) ;
                periodstartdates.add(tempperiodstartdate) ;
                periodenddates.add(tempperiodenddate) ;
            }
            break ;
        case 4 :
            String tempperiodstartdate = (String) startdates.get(0) ;
            String tempperiodenddate = (String) enddates.get(11) ;
            feetypeperiods.add(tempfeetypeid+"_1") ;
            periodstartdates.add(tempperiodstartdate) ;
            periodenddates.add(tempperiodenddate) ;
            break ;
    }
}

if( !budgetinfoid.equals("") ) {
    String ystypesqlstr = "select a.id,b.budgettypeid from  FnaBudgetInfo a,FnaBudgetInfoDetail b where a.id = b.budgetinfoid and a.budgetorganizationid = "+resourceid;		  
    RecordSet.execute(ystypesqlstr);    
    String typefeeid = "";
    if(RecordSet.next()){
    	 typefeeid = Util.null2String(RecordSet.getString(2));
    }

    String yssqlstr = "select supsubject from FnaBudgetfeeType where id = (select supsubject from FnaBudgetfeeType where id ="+typefeeid+ ")";
    RecordSet.executeSql(yssqlstr); 
    String tempbudgetperiods = "";
    if(RecordSet.next()){
     tempbudgetperiods = Util.null2String(RecordSet.getString(1));
    }

    sqlstr =" select a.budgetperiodslist,sum(a.budgetaccount) budgetaccount,b.id"+
              " from FnaBudgetInfoDetail a,FnaBudgetInfo b"+
			  " where b.budgetorganizationid =" + resourceid + " and a.budgetinfoid = b.id"+ 
		      " and a.budgetperiods = (select id from FnaYearsPeriods where fnayear= '" + fnayear + "')"+ 
			  " group by a.budgetperiodslist,b.id";
    RecordSet.executeSql(sqlstr);
    while(RecordSet.next()){
        String tempbudgettypeid = Util.null2String(RecordSet.getString(1)) ;
        String tempaccount = "" + Util.getDoubleValue(RecordSet.getString(2),0) ;

        if(tempaccount.equals("0")) continue ;

        budgettypeperiods.add(tempbudgettypeid + "_" + tempbudgetperiods ) ;
        budgetaccounts.add( tempaccount ) ;
    }
}

sqlstr =" select feetypeid , amount , occurdate from FnaAccountLog where occurdate >= '"+ fnayearstartdate + "' and occurdate <= '"+ fnayearenddate +"' and resourceid = " + resourceid ;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
    String tempfeetypeid = Util.null2String(RecordSet.getString(1)) ;
	double tempaccount = Util.getDoubleValue(RecordSet.getString(2),0) ;
	String tempoccurdate = Util.null2String(RecordSet.getString(3)) ;

	if( tempaccount == 0 ) continue ;

    for( int i= 0 ; i < periodstartdates.size() ; i++ ) {
        String tempperiodstartdate = (String) periodstartdates.get(i) ;
        String tempperiodenddate = (String) periodenddates.get(i) ;

        if ( tempoccurdate.compareTo(tempperiodstartdate) >=0 && tempoccurdate.compareTo(tempperiodenddate) <=0 ) {
            String feetypeperiod = (String)feetypeperiods.get(i) ;
            if( feetypeperiod.indexOf( tempfeetypeid + "_" ) != 0 ) continue ;

            String currentperiod = Util.StringReplace(feetypeperiod,tempfeetypeid + "_", "") ;
            int expensetypeperiodindex = expensetypeperiods.indexOf(tempfeetypeid + "_" + currentperiod ) ;
            if( expensetypeperiodindex == -1 ) {
                expensetypeperiods.add( tempfeetypeid + "_" + currentperiod ) ;
                expenseaccounts.add( "" + tempaccount ) ;
            }
            else {
                double tempperaccount = Util.getDoubleValue( (String)expenseaccounts.get(expensetypeperiodindex) , 0 ) ;
                tempaccount += tempperaccount ;
                expenseaccounts.set( expensetypeperiodindex , "" + tempaccount ) ;
            }
            break ;
        }
    }
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(428,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(2121,user.getLanguage())+",javascript:submitBudget(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/fna/report/expense/FnaExpenseResource.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<style>
.hjTd{
	height: 30px; vertical-align: middle; color: rgb(120, 119, 117); white-space: nowrap; text-overflow: ellipsis; overflow: hidden;
}
</style>

<FORM class=inputstyle id=frmMain name=frmMain action=FnaExpenseResourceDetailInner.jsp method=post>
<input class=inputstyle type=hidden name="operation" value="approve">
<input class=inputstyle id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
<input class=inputstyle id=departmentid type=hidden name=resourceid value="<%=departmentid%>">
<input class=inputstyle id=budgetstatus type=hidden name=budgetstatus value="<%=budgetstatus%>">
<input class=inputstyle id=budgetinfoid type=hidden name=budgetinfoid value="<%=budgetinfoid%>">

<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'><!-- 查询条件 -->
		<wea:item attributes="{\"isTableList\":\"true\"}">
<table Class="ListStyle" id="oTable">
    <COLGROUP> <COL width="15%"></COL> <COL width="55%"></COL> <COL width="30%"></COL>
    <tr class=header> 
      <td><%=SystemEnv.getHtmlLabelName(15365,user.getLanguage())%></td>
      <td class=Field colSpan=4>
        <select class=inputstyle name="fnayear" onchange="frmMain.submit()">
          <%
		RecordSet.executeProc("FnaYearsPeriods_Select","");
		while(RecordSet.next()) {
			String thefnayear = RecordSet.getString("fnayear") ;
		%>
          <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayear)) {%>selected<%}%>><%=thefnayear%></option>
          <%}%>
        </select>
      </td>
      <td style="text-align: right;">
	    <%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>: 
	    <% if( budgetstatus.equals("1") ) {%>
	    	<%=SystemEnv.getHtmlLabelName(1423,user.getLanguage())%>
	    	<% if( status.equals("1") ) {%>
	    		（<%=SystemEnv.getHtmlLabelName(18431,user.getLanguage())%>）
	    	<%} else if( status.equals("3") ) {%>
	    		（<%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%>）
		    <%}%>
	    <%} else if( budgetstatus.equals("0") ) { %>
	    	<% if( status.equals("1") ) {%>
	    		<%=SystemEnv.getHtmlLabelName(18431,user.getLanguage())%>
	    	<%} else if( status.equals("3") ) {%>
	    		<%=SystemEnv.getHtmlLabelName(1422,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%>）
		    <%}%>
	    <%}%>
      </td>
    </tr>
  </TABLE>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>

<%
boolean isLight = false ; 
ArrayList thebudgetaccounts = new ArrayList() ;
ArrayList theexpenseaccounts = new ArrayList() ;
double budgetyearcount = 0 ;
%>
<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(15428,user.getLanguage())%>'><!-- 月度收支 -->
		<wea:item attributes="{\"isTableList\":\"true\"}">
<table Class="ListStyle" id="oTable">
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

  <TR class=header>
  <th><%=SystemEnv.getHtmlLabelName(15385,user.getLanguage())%></th>
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
<%
    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 1 ");
	while(RecordSet.next())
	{
        thebudgetaccounts.clear() ;
        theexpenseaccounts.clear() ;
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        String feetype = Util.toScreen(RecordSet.getString("feetype"),user.getLanguage()) ;
        isLight = !isLight ;
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD rowspan=3><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
        <TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
<%
        double yearcount = 0 ;
        for( int i=1 ; i<13 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = budgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
            thebudgetaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }

        budgetyearcount = yearcount ;
        String yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        thebudgetaccounts.add( yearcountstr ) ;
%>
   		<TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
	</TR>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%></TD>
<%
        yearcount = 0 ;
        for( int i=1 ; i<13 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = expensetypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                double tempexpense = Util.getDoubleValue((String) expenseaccounts.get(accountindex),0) ;
                tempexpense = (new BigDecimal(tempexpense)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
                if(tempexpense != 0 ) tempbudgetaccount = ""+tempexpense ;
                yearcount += tempexpense ;
            }
            theexpenseaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }

        yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        theexpenseaccounts.add( yearcountstr ) ;
%>
   		<TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
	</TR>
    <TR STYLE="COLOR:RED;FONT-WEIGHT:BOLD">
        <TD class="hjTd"><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
<%
        for( int i=0 ; i<13 ; i++ ) {
            String tempbudgetaccount = (String) thebudgetaccounts.get(i) ;
            String tempexpenseaccount = (String) theexpenseaccounts.get(i) ;
            String tempaccountgap = "" ;

            if( !tempbudgetaccount.equals("") && !tempexpenseaccount.equals("") ) {
                double accountgapdouble =  ( Util.getDoubleValue(tempexpenseaccount) - Util.getDoubleValue(tempbudgetaccount) ) * 100 / Util.getDoubleValue(tempbudgetaccount) ;
                int accountgapint = (new Double( accountgapdouble )).intValue() ;
 //               if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
                if( accountgapint != 0 ) tempaccountgap = "" + accountgapint + "%" ;
            }
%>
        <TD style="TEXT-ALIGN: right"><%=tempaccountgap%></TD>
<%      } %>
	</TR>
	<tr class="Spacing e8TotalCountSpacingClass" style="height:1px!important;"><td colspan="15" class="paddingLeft0Table"></td></tr>
<%
	}
%>
  </TBODY>
</TABLE>
		</wea:item>
	</wea:group>
</wea:layout>

<br>
<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(15429,user.getLanguage())%>'><!-- 季度收支 -->
		<wea:item attributes="{\"isTableList\":\"true\"}">
<table Class="ListStyle" id="oTable">
  <COLGROUP>
    <col width="10%">
    <col width="6%">
    <col width="16%">
    <col width="16%">
    <col width="16%">
    <col width="16%">
    <col width="20%">
  <THEAD>
  <TR class=header>
  <th><%=SystemEnv.getHtmlLabelName(15385,user.getLanguage())%></th>
  <th>&nbsp;</th>
  <th>1<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>2<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>3<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>4<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
  </tr>
<%
    isLight = false;

    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 2 ");
	while(RecordSet.next())
	{
        thebudgetaccounts.clear() ;
        theexpenseaccounts.clear() ;
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        String feetype = Util.toScreen(RecordSet.getString("feetype"),user.getLanguage()) ;
        isLight = !isLight ;
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD rowspan=3><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
        <TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
<%
        double yearcount = 0 ;
        for( int i=1 ; i<5 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = budgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
            thebudgetaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }

        budgetyearcount = yearcount ;
        String yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        thebudgetaccounts.add( yearcountstr ) ;
%>
   		<TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
	</TR>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%></TD>
<%
        yearcount = 0 ;
        for( int i=1 ; i<5 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = expensetypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                double tempexpense = Util.getDoubleValue((String) expenseaccounts.get(accountindex),0) ;
                tempexpense = (new BigDecimal(tempexpense)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
                if(tempexpense != 0 ) tempbudgetaccount = ""+tempexpense ;
                yearcount += tempexpense ;
            }
            theexpenseaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }

        yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        theexpenseaccounts.add( yearcountstr ) ;
%>
   		<TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
	</TR>
    <TR STYLE="COLOR:RED;FONT-WEIGHT:BOLD">
        <TD class="hjTd"><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
<%
        for( int i=0 ; i<5 ; i++ ) {
            String tempbudgetaccount = (String) thebudgetaccounts.get(i) ;
            String tempexpenseaccount = (String) theexpenseaccounts.get(i) ;
            String tempaccountgap = "" ;

            if( !tempbudgetaccount.equals("") && !tempexpenseaccount.equals("") ) {
                double accountgapdouble =  ( Util.getDoubleValue(tempexpenseaccount) - Util.getDoubleValue(tempbudgetaccount) ) * 100 / Util.getDoubleValue(tempbudgetaccount) ;
                int accountgapint = (new Double( accountgapdouble )).intValue() ;
 //               if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
                if( accountgapint != 0 ) tempaccountgap = "" + accountgapint + "%" ;
            }
%>
        <TD style="TEXT-ALIGN: right"><%=tempaccountgap%></TD>
<%      } %>
	</TR>
	<tr class="Spacing e8TotalCountSpacingClass" style="height:1px!important;"><td colspan="7" class="paddingLeft0Table"></td></tr>
<%
	}
%>
  </TBODY>
</TABLE>
		</wea:item>
	</wea:group>
</wea:layout>

<br>
<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(15430,user.getLanguage())%>'><!-- 半年收支 -->
		<wea:item attributes="{\"isTableList\":\"true\"}">
<table Class="ListStyle" id="oTable">
  <COLGROUP>
    <col width="10%">
    <col width="6%">
    <col width="25%">
    <col width="25%">
    <col width="34%">
  <THEAD>
  <TR class=header>
  <th><%=SystemEnv.getHtmlLabelName(15385,user.getLanguage())%></th>
  <th>&nbsp;</th>
  <th>1<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>2<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
  </tr>
<%
    isLight = false;

    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 3 ");
	while(RecordSet.next())
	{
        thebudgetaccounts.clear() ;
        theexpenseaccounts.clear() ;
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        String feetype = Util.toScreen(RecordSet.getString("feetype"),user.getLanguage()) ;
        isLight = !isLight ;
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD rowspan=3><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
        <TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
<%
        double yearcount = 0 ;
        for( int i=1 ; i<3 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = budgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
            thebudgetaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }

        budgetyearcount = yearcount ;
        String yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        thebudgetaccounts.add( yearcountstr ) ;
%>
   		<TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
	</TR>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%></TD>
<%
        yearcount = 0 ;
        for( int i=1 ; i<3 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = expensetypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                double tempexpense = Util.getDoubleValue((String) expenseaccounts.get(accountindex),0) ;
                tempexpense = (new BigDecimal(tempexpense)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
                if(tempexpense != 0 ) tempbudgetaccount = ""+tempexpense ;
                yearcount += tempexpense ;
            }
            theexpenseaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }

        yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        theexpenseaccounts.add( yearcountstr ) ;
%>
   		<TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
	</TR>
    <TR STYLE="COLOR:RED;FONT-WEIGHT:BOLD">
        <TD class="hjTd"><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
<%
        for( int i=0 ; i<3 ; i++ ) {
            String tempbudgetaccount = (String) thebudgetaccounts.get(i) ;
            String tempexpenseaccount = (String) theexpenseaccounts.get(i) ;
            String tempaccountgap = "" ;

            if( !tempbudgetaccount.equals("") && !tempexpenseaccount.equals("") ) {
                double accountgapdouble =  ( Util.getDoubleValue(tempexpenseaccount) - Util.getDoubleValue(tempbudgetaccount) ) * 100 / Util.getDoubleValue(tempbudgetaccount) ;
                int accountgapint = (new Double( accountgapdouble )).intValue() ;
 //               if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
                if( accountgapint != 0 ) tempaccountgap = "" + accountgapint + "%" ;
            }
%>
        <TD style="TEXT-ALIGN: right"><%=tempaccountgap%></TD>
<%      } %>
	</TR>
	<tr class="Spacing e8TotalCountSpacingClass" style="height:1px!important;"><td colspan="5" class="paddingLeft0Table"></td></tr>
<%
	}
%>
  </TBODY>
</TABLE>
		</wea:item>
	</wea:group>
</wea:layout>

<form name="detail" action=FnaExpenseTypeResourceDetail.jsp method=post>
  <input id=feetypeid type=hidden name=feetypeid >
  <input id=fnayear type=hidden name=fnayear value="<%=fnayear%>">
  <input id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
  <input id=departmentid type=hidden name=resourceid value="<%=departmentid%>">
  <input id=budgetstatus type=hidden name=budgetstatus value="<%=budgetstatus%>">
  <input id=budgetinfoid type=hidden name=budgetinfoid value="<%=budgetinfoid%>">
</form>
<script language=javascript>
function submitBudget(thevalue) {
    detail.feetypeid.value=thevalue ;
    detail.submit() ;
    return false;
}
</script>
</BODY>
</HTML>
