<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%-----added by lupeng 2004.2.3----------%>
<%-----
boolean canview = HrmUserVarify.checkUserRight("FnaBudget:All" , user) ;

if(!canview) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
------%>
<%-----end----------%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String resourceid = Util.null2String(request.getParameter("resourceid")) ; 
String fnayear = Util.null2String(request.getParameter("fnayear")) ; 

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
    sqlstr =" select id , budgetstatus from FnaBudgetInfo where budgetperiods = (select id from FnaYearsPeriods where fnayear= '" + fnayear + "')  " ; 
	
    RecordSet.executeSql(sqlstr) ; 
    if( RecordSet.next() ) {
        budgetinfoid = Util.null2String( RecordSet.getString(1) ) ; 
        budgetstatus = Util.null2String(RecordSet.getString(2)) ; 
    }
}


Map records = new HashMap();
if( !budgetinfoid.equals("") ) {
	//edit start qc:26420	陆英锴 2011-8-5
	RecordSet.execute("select a.id,b.budgettypeid,b.budgetaccount,b.budgetperiodslist,c.supsubject from  FnaBudgetInfo a,FnaBudgetInfoDetail b,FnaBudgetfeeType c where a.id = b.budgetinfoid and a.budgetorganizationid = "+resourceid+" and c.id=(select c.supsubject from FnaBudgetfeeType c where c.id = b.budgettypeid)");
	//封装records
	while(RecordSet.next()){
		int subject = RecordSet.getInt("supsubject");//取出一级科目的值
		Map record = (Map)records.get(Integer.valueOf(subject));//将一级科目作为键存入records中
		if(null==record){
			record = new HashMap();
		}
		Double count = (Double)record.get(Integer.valueOf(RecordSet.getInt("budgetperiodslist")));//取出期
		if(null == count){
			count = Double.valueOf(0);
		}
		BigDecimal bd = new BigDecimal(count.doubleValue());
		bd = bd.add(new BigDecimal(new Double(RecordSet.getDouble("budgetaccount")).doubleValue()));//该一级科目下可能还有其他科目,将所有的累加,结果为该一级科目下的预算总值
		record.put(Integer.valueOf(RecordSet.getInt("budgetperiodslist")),Double.valueOf(bd.doubleValue()));//将期作为键,总值作为值存入record中
		records.put(Integer.valueOf(subject), record);//将record存入records
	}
	//records封装完毕
	/*
		//records结构{
			//一级科目id:record,
			//.......
		}
		//record结构{
			//期:预算总值,
			//.......
		}
		//records = {
				//一级科目ID:{
							//期:预算总值,
							//期:预算总值,
							//期:预算总值,
							//期:预算总值,
							......
						},
				//一级科目ID:{
							//期:预算总值,
							//期:预算总值,
							//期:预算总值,
							//期:预算总值,
							.......
				}
				......
		}
		//edit by 陆英锴
	*/
	//edit end qc:26420  后面显示逻辑也略有修改.
}

String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(386 , user.getLanguage()) ; 
String needfav ="1" ; 
String needhelp ="" ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
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

<FORM id=frmMain name=frmMain action=FnaBudgetResourceDetail.jsp method=post>
<input class=inputstyle type=hidden name="operation" value="approve">
<input class=inputstyle id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
<input class=inputstyle id=departmentid type=hidden name=resourceid value="<%=departmentid%>">
<input class=inputstyle id=budgetstatus type=hidden name=budgetstatus value="<%=budgetstatus%>">
<input class=inputstyle id=budgetinfoid type=hidden name=budgetinfoid value="<%=budgetinfoid%>">

 <TABLE class=ViewForm>
 <TR class=Line1><TD colspan="8" ></TD></TR>
    <COLGROUP> <COL width="15%"></COL> <COL width="40%"></COL><COL width="5%"></COL> 
    <COL width="15%"></COL> <COL width="25%"></COL> <THEAD> 
    <TR class=Title> 
    <TH colspan="2"> 
      <P align=left><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%>: <%=Util.toScreen(ResourceComInfo.getResourcename(resourceid) , user.getLanguage())%></P>
    </TH>
    <TH colSpan=3 style="TEXT-ALIGN: right"><nobr>
    <%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%>: <% if( budgetstatus.equals("1") ) {%><%=SystemEnv.getHtmlLabelName(1423,user.getLanguage())%><%} else if( budgetstatus.equals("0") ) { %><%=SystemEnv.getHtmlLabelName(1422,user.getLanguage())%><%}%>
    </TH>
  </TR>
    </THEAD> <TBODY> 
    <TR class=Spacing> 
      <TD class=Line1 colSpan=5></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(15365,user.getLanguage())%></td>
      <td class=Field colSpan=4> 
        <select class=inputstyle name="fnayear" onchange="frmMain.submit()">
          <%
		RecordSet.executeProc("FnaYearsPeriods_Select" , "") ; 
		while(RecordSet.next()) {
			String thefnayear = RecordSet.getString("fnayear") ; 
		%>
          <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayear)) {%>selected<%}%>><%=thefnayear%></option>
          <%}%>
        </select>
      </td>
    </tr>
<TR><TD class=Line colSpan=6></TD></TR> 
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
    <col width="14%">
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
    boolean isLight = false ; 
    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 1 ") ; 
	while(RecordSet.next()) { 
        String id = Util.null2String(RecordSet.getString("id")) ; 
        String name = Util.toScreen(RecordSet.getString("name") , user.getLanguage()) ; 
        String feetype = Util.toScreen(RecordSet.getString("feetype") , user.getLanguage()) ; 
        isLight = !isLight ; 
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
<%
          BigDecimal yearcount = new BigDecimal(0) ;
		Map record = (Map)records.get(Integer.valueOf(id));
    	if(null==record){
    		record = new HashMap();
    	}
        for( int i=1 ; i<13 ; i++ ) { 
             String tempbudgetaccount = "";
    		Double budgetaccount = (Double)record.get(Integer.valueOf(i));
    		if(null!=budgetaccount){
    			tempbudgetaccount = String.valueOf(budgetaccount);
    			yearcount = yearcount.add(BigDecimal.valueOf(budgetaccount.doubleValue()));
    		}
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      
    } 
        
        
%>      
   		<TD style="TEXT-ALIGN: right"><%=yearcount.toString()%></TD>
<%      
    }
%>    
	</TR>
  </TBODY> 
</TABLE>

<br>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP> 
    <col width="10%">
    <col width="17%">
    <col width="17%">
    <col width="17%">
    <col width="17%">
    <col width="22%">
  <THEAD> 
  <TR class=Header> 
    <TH colspan="6"><%=SystemEnv.getHtmlLabelName(15373 , user.getLanguage())%></TH>
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
    isLight = false ; 

    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 2 ") ; 
	while(RecordSet.next()) {
        String id = Util.null2String(RecordSet.getString("id")) ; 
        String name = Util.toScreen(RecordSet.getString("name") , user.getLanguage()) ; 
        String feetype = Util.toScreen(RecordSet.getString("feetype") , user.getLanguage()) ; 
        isLight = !isLight ; 
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
<%
         BigDecimal yearcount = new BigDecimal(0) ;
		Map record = (Map)records.get(Integer.valueOf(id));
    	if(null==record){
    		record = new HashMap();
    	}
        for( int i=1 ; i<5 ; i++ ) { 
            String tempbudgetaccount = "";
    		Double budgetaccount = (Double)record.get(Integer.valueOf(i));
    		if(null!=budgetaccount){
    			tempbudgetaccount = String.valueOf(budgetaccount);
    			yearcount = yearcount.add(BigDecimal.valueOf(budgetaccount.doubleValue()));
    		}
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      } 
        
        
%>      
   			<TD style="TEXT-ALIGN: right"><%=yearcount.toString()%></TD>
<%      
    }
%>    
	</TR>
  </TBODY> 
</TABLE>
<br>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP> 
    <col width="10%">
    <col width="27%">
    <col width="27%">
    <col width="36%">
  <THEAD> 
  <TR class=Header> 
    <TH colspan="4"><%=SystemEnv.getHtmlLabelName(15374 , user.getLanguage())%></TH>
  </TR>
   <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15371 , user.getLanguage())%></th>
  <th>1<%=SystemEnv.getHtmlLabelName(15372 , user.getLanguage())%></th>
  <th>2<%=SystemEnv.getHtmlLabelName(15372 , user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013 , user.getLanguage())%></th>        
  </tr>
  <TR class=Line><TD colspan="4" ></TD></TR>
<%
    isLight = false ; 

    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 3 ") ; 
	while(RecordSet.next()) {
        String id = Util.null2String(RecordSet.getString("id")) ; 
        String name = Util.toScreen(RecordSet.getString("name") , user.getLanguage()) ; 
        String feetype = Util.toScreen(RecordSet.getString("feetype"),user.getLanguage()) ; 
        isLight = !isLight ; 
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
<%
         BigDecimal yearcount = new BigDecimal(0) ;
		Map record = (Map)records.get(Integer.valueOf(id));
    	if(null==record){
    		record = new HashMap();
    	}
        for( int i=1 ; i<3 ; i++ ) { 
             String tempbudgetaccount = "";
    		Double budgetaccount = (Double)record.get(Integer.valueOf(i));
    		if(null!=budgetaccount){
    			tempbudgetaccount = String.valueOf(budgetaccount);
    			yearcount = yearcount.add(BigDecimal.valueOf(budgetaccount.doubleValue()));
    		}
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      } 
        
        
%>      
   		<TD style="TEXT-ALIGN: right"><%=yearcount.toString()%></TD>
<%      
    }
%>      
	</TR>
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
  <th><%=SystemEnv.getHtmlLabelName(15371 , user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013 , user.getLanguage())%></th>        
  </tr>
  <TR class=Line><TD colspan="2" ></TD></TR>
<%
    isLight = false ; 

    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 4 ") ; 
	while(RecordSet.next()) {
        String id = Util.null2String(RecordSet.getString("id")) ; 
        String name = Util.toScreen(RecordSet.getString("name") , user.getLanguage()) ; 
        String feetype = Util.toScreen(RecordSet.getString("feetype") , user.getLanguage()) ; 
        isLight = !isLight ; 
%>
	<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
<%
        Map record = (Map)records.get(Integer.valueOf(id));
    	if(null==record){
    		record = new HashMap();
    	}
        for( int i=1 ; i<2 ; i++ ) { 
        	String tempbudgetaccount = "";
    		Double budgetaccount = (Double)record.get(Integer.valueOf(i));
    		if(null!=budgetaccount){
    			tempbudgetaccount = String.valueOf(budgetaccount);
    		}
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }
    }
%>      
	</TR>
  </TBODY> 
</TABLE>

<form name="detail" action=FnaBudgetTypeResourceDetail.jsp method=post>
  <input class=inputstyle id=budgettypeid type=hidden name=budgettypeid >
  <input class=inputstyle id=fnayear type=hidden name=fnayear value="<%=fnayear%>">
  <input class=inputstyle id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
  <input class=inputstyle id=departmentid type=hidden name=resourceid value="<%=departmentid%>">
  <input class=inputstyle id=budgetstatus type=hidden name=budgetstatus value="<%=budgetstatus%>">
  <input class=inputstyle id=budgetinfoid type=hidden name=budgetinfoid value="<%=budgetinfoid%>">
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
    detail.submit(); 
    return false ; 
}
</script>
</BODY>
</HTML>