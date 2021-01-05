 <%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.fna.maintenance.*"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>

<jsp:useBean id="tmpRs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>

<%
	/*用户验证*/
	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null) {
	    response.sendRedirect("/login/Login.jsp");
	    return;
	}
    int creater = Util.getIntValue(request.getParameter("creater"));
    int billid = Util.getIntValue(request.getParameter("billid"));
    
    RecordSet.executeSql(" select occurdate from bill_HrmFinance where id = " + billid);
    RecordSet.next();
    String thecurrentdate = Util.null2String(RecordSet.getString(1));

    //if(thecurrentdate.length() < 10 ) return ;
if(thecurrentdate.length()>=10){
    //RecordSet.executeProc("bill_HrmFinance_SelectLoan",""+creater);
    //RecordSet.next();
    //String loanamount = RecordSet.getString(1);
    RecordSet.executeSql("select sum(amount) from fnaloaninfo where organizationtype=3 and organizationid="+creater);
    RecordSet.next();
    double loanamount=Util.getDoubleValue(RecordSet.getString(1),0);

    FnaExpenseManage fem = new FnaExpenseManage(thecurrentdate) ;
    fem.setResourceid ( ""+creater ) ;
    fem.setDepartmentid ( ""+ResourceComInfo.getDepartmentID(""+creater) ) ;
    String budgethasapprove = fem.budgetHasApprove() ;

    ArrayList feetypeids = new ArrayList() ;
    ArrayList feetypenames = new ArrayList() ;
    ArrayList expenseamounts = new ArrayList() ;

    //added by lupeng 2004.2.20
    RecordSet.executeSql (" select feetypeid , sum(feesum) sum_feesum, sum(realfeesum) sum_realfeesum from Bill_ExpenseDetail where expenseid = " + billid + " group by feetypeid ") ;
    while( RecordSet.next() ) {
        String tempfeetypeid = Util.null2String( RecordSet.getString(1) ) ;
        String tempexpenseamount = Util.null2String( RecordSet.getString(2) ) ;
        String tempexpenseamountReal = Util.null2String( RecordSet.getString(3) ) ;
        if(!"".equals(tempexpenseamountReal)){
        	tempexpenseamount = tempexpenseamountReal;
        }

        String tempAmount = "";
        String tmpSql = "select a.amount from FnaAccountLog a, bill_HrmFinance b where a.releatedid=b.requestid and a.feetypeid=" + tempfeetypeid + " and b.billid="+ billid;
        tmpRs.executeSql(tmpSql);
        if (tmpRs.next())
            tempAmount = Util.null2String(tmpRs.getString(1));

        if (!tempAmount.equals(""))
            tempexpenseamount = "";

        feetypeids.add( tempfeetypeid ) ;
        feetypenames.add( Util.toScreen( BudgetfeeTypeComInfo.getBudgetfeeTypename(tempfeetypeid),user.getLanguage() ) ) ;
        expenseamounts.add( tempexpenseamount ) ;
    }
    //end
%>
<wea:layout>
	<wea:group attributes="{\"itemAreaDisplay\":\"none\",\"id\":\"xxx\"}" context='<%=SystemEnv.getHtmlLabelName(15805,user.getLanguage()) %>'>
		<wea:item type="groupHead">
			<span class="noHide">
				<input id="ipt_onChangetype_1" value="1" type="checkbox" /><span id="spanonChangetype_1"><%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%>&nbsp;&nbsp;</span>
				<input id="ipt_onChangetype_2" value="2" type="checkbox" /><span id="spanonChangetype_2"><%=SystemEnv.getHtmlLabelName(16289,user.getLanguage())%>&nbsp;&nbsp;</span>
				<input id="ipt_onChangetype_3" value="3" type="checkbox" /><span id="spanonChangetype_3"><%=SystemEnv.getHtmlLabelName(16290,user.getLanguage())%>&nbsp;&nbsp;</span>
				<input id="ipt_onChangetype_4" value="4" type="checkbox" /><span id="spanonChangetype_4"><%=SystemEnv.getHtmlLabelName(20323,user.getLanguage())%>&nbsp;&nbsp;</span>
			</span>
		</wea:item>
		<wea:item attributes="{\"isTableList\":\"true\"}">

    <div id=odiv_1>
	<table class=ListStyle cellspacing=1 id="oTable_1">
        <tr class=datalight>
            <td width="20%"><b><%=SystemEnv.getHtmlLabelName(16271,user.getLanguage())%></b></td>
            <td colspan=3><%=loanamount%></td>
        </tr>
        <%

            for( int i=0 ; i< feetypeids.size() ; i++ ) {
                String tempfeetypeid = (String)feetypeids.get(i) ;
                String tempfeetypename = (String)feetypenames.get(i) ;
                double expenseamount = Util.getDoubleValue((String)expenseamounts.get(i),0) ;
                fem.setFeetypeid( tempfeetypeid ) ;
                fem.getResourceInfo() ;

                String currentperiod = fem.getCurrentperiod() ;
                /*commented by lupeng 2004.2.20
                String resourcecurrentbudgetstr = "&nbsp;" ;
                String resourcebeforebudgetstr = "&nbsp;" ;
                String resourceyearbudgetstr = "&nbsp;" ;
                String resourcecurrentexpensestr = "&nbsp;" ;
                String resourcebeforeexpensestr = "&nbsp;" ;
                String resourceyearexpensestr = "&nbsp;" ;
                */

                //added by lupeng2004.2.20
                String resourcecurrentbudgetstr = "0" ;
                String resourcebeforebudgetstr = "0" ;
                String resourceyearbudgetstr = "0" ;
                String resourcecurrentexpensestr = "0" ;
                String resourcebeforeexpensestr = "0" ;
                String resourceyearexpensestr = "0" ;
                //end

                double resourcecurrentbudget = fem.getResourcecurrentbudget() ;
                double resourcebeforebudget = fem.getResourcebeforebudget() ;
                double resourceyearbudget = fem.getResourceyearbudget() ;

                double resourcecurrentexpense = fem.getSumValue(fem.getResourcecurrentexpense(),expenseamount,3) ;
                double resourcebeforeexpense = fem.getSumValue(fem.getResourcebeforeexpense(),expenseamount,3) ;
                double resourceyearexpense = fem.getSumValue(fem.getResourceyearexpense(),expenseamount,3) ;

                if( resourcecurrentbudget != 0 ) resourcecurrentbudgetstr = ""+resourcecurrentbudget ;
                if( resourcebeforebudget != 0 ) resourcebeforebudgetstr = ""+resourcebeforebudget ;
                if( resourceyearbudget != 0 ) resourceyearbudgetstr = ""+resourceyearbudget ;
                if( resourcecurrentexpense != 0) resourcecurrentexpensestr =""+resourcecurrentexpense ;
                if( resourcebeforeexpense != 0 ) resourcebeforeexpensestr = ""+resourcebeforeexpense ;
                if( resourceyearexpense != 0 ) resourceyearexpensestr = ""+resourceyearexpense ;
        %>
        <tr class=header >
            <th class="Title" style="text-align: left;"><%=tempfeetypename%></th>
            <th><%=SystemEnv.getHtmlLabelName(16291,user.getLanguage())%></th>
            <th>1~<%=currentperiod%><%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></td>
            <td><%=resourcecurrentbudgetstr%></td>
            <td><%=resourcebeforebudgetstr%></td>
            <td><%=resourceyearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16292,user.getLanguage())%></td>
            <td><%=resourcecurrentexpensestr%></td>
            <td><%=resourcebeforeexpensestr%></td>
            <td><%=resourceyearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(resourcecurrentbudget,resourcecurrentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(resourcebeforebudget,resourcebeforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(resourceyearbudget,resourceyearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <%  }   %>
      </table>
    </div>

    <div id=odiv_2 style="display:none">
	<table class=ListStyle cellspacing=1 id="oTable_2">
        <%

            for( int i=0 ; i< feetypeids.size() ; i++ ) {
                String tempfeetypeid = (String)feetypeids.get(i) ;
                String tempfeetypename = (String)feetypenames.get(i) ;
                double expenseamount = Util.getDoubleValue((String)expenseamounts.get(i),0) ;
                fem.setFeetypeid( tempfeetypeid ) ;
                fem.getDepartmentInfo() ;

                String currentperiod = fem.getCurrentperiod() ;
                /*commented by lupeng 2004.2.20
                String departmentcurrentbudgetstr = "&nbsp;" ;
                String departmentbeforebudgetstr = "&nbsp;" ;
                String departmentyearbudgetstr = "&nbsp;" ;
                String departmentcurrentexpensestr = "&nbsp;" ;
                String departmentbeforeexpensestr = "&nbsp;" ;
                String departmentyearexpensestr = "&nbsp;" ;
                */

                //added by lupeng 2004.2.20
                String departmentcurrentbudgetstr = "0" ;
                String departmentbeforebudgetstr = "0" ;
                String departmentyearbudgetstr = "0" ;
                String departmentcurrentexpensestr = "0" ;
                String departmentbeforeexpensestr = "0" ;
                String departmentyearexpensestr = "0" ;
                //end

                double departmentcurrentbudget = fem.getDepartmentcurrentbudget() ;
                double departmentbeforebudget = fem.getDepartmentbeforebudget() ;
                double departmentyearbudget = fem.getDepartmentyearbudget() ;

                double departmentcurrentexpense = fem.getSumValue(fem.getDepartmentcurrentexpense(),expenseamount,3) ;
                double departmentbeforeexpense = fem.getSumValue(fem.getDepartmentbeforeexpense(),expenseamount,3) ;
                double departmentyearexpense = fem.getSumValue(fem.getDepartmentyearexpense(),expenseamount,3) ;

                if( departmentcurrentbudget != 0 ) departmentcurrentbudgetstr = ""+departmentcurrentbudget ;
                if( departmentbeforebudget != 0 ) departmentbeforebudgetstr = ""+departmentbeforebudget ;
                if( departmentyearbudget != 0 ) departmentyearbudgetstr = ""+departmentyearbudget ;
                if( departmentcurrentexpense != 0) departmentcurrentexpensestr =""+departmentcurrentexpense ;
                if( departmentbeforeexpense != 0 ) departmentbeforeexpensestr = ""+departmentbeforeexpense ;
                if( departmentyearexpense != 0 ) departmentyearexpensestr = ""+departmentyearexpense ;
        %>
        <tr class=header >
            <th class="Title" style="text-align: left;"><%=tempfeetypename%></th>
            <th><%=SystemEnv.getHtmlLabelName(16291,user.getLanguage())%></th>
            <th>1~<%=currentperiod%><%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></td>
            <td><%=departmentcurrentbudgetstr%></td>
            <td><%=departmentbeforebudgetstr%></td>
            <td><%=departmentyearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16292,user.getLanguage())%></td>
            <td><%=departmentcurrentexpensestr%></td>
            <td><%=departmentbeforeexpensestr%></td>
            <td><%=departmentyearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(departmentcurrentbudget,departmentcurrentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(departmentbeforebudget,departmentbeforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(departmentyearbudget,departmentyearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <%  }   %>
      </table>
    </div>

    <div id=odiv_3 style="display:none">
	<table class=ListStyle cellspacing=1 id="oTable_3">
        <COLGROUP>
        <%

        String theprojectid = "" ;
        ArrayList projectids = new ArrayList() ;
        expenseamounts.clear() ;

        RecordSet.executeSql (" select relatedproject , sum(feesum) sum_feesum, sum(realfeesum) sum_realfeesum from Bill_ExpenseDetail where expenseid = " + billid + " group by relatedproject ") ;

        while( RecordSet.next() ) {
            String tempprojectid = Util.null2String( RecordSet.getString(1) ) ;
            String tempexpenseamount = Util.null2String( RecordSet.getString(2) ) ;
            String tempexpenseamountReal = Util.null2String( RecordSet.getString(3) ) ;
            if(!"".equals(tempexpenseamountReal)){
            	tempexpenseamount = tempexpenseamountReal;
            }
            
            if( tempprojectid.equals("") || tempprojectid.equals("0") ) continue ;
            projectids.add( tempprojectid ) ;
            expenseamounts.add( tempexpenseamount ) ;
        }

        int _prjIdx = 0;
        RecordSet.executeSql (" select relatedproject , feetypeid , sum(feesum) sum_feesum, sum(realfeesum) sum_realfeesum from Bill_ExpenseDetail where expenseid = " + billid + " group by relatedproject, feetypeid ") ;
        while( RecordSet.next() ) {
            String tempprojectid = Util.null2String( RecordSet.getString(1) ) ;
            if( tempprojectid.equals("") || tempprojectid.equals("0") ) continue ;

            String tempfeetypeid = Util.null2String( RecordSet.getString(2) ) ;
            String tempfeetypename = Util.toScreen( BudgetfeeTypeComInfo.getBudgetfeeTypename(tempfeetypeid),user.getLanguage() ) ;
            double expenseamount = Util.getDoubleValue( RecordSet.getString(3), 0 ) ;
            double expenseamountReal = Util.getDoubleValue( RecordSet.getString(4), 0 ) ;
            if(!"".equals(Util.null2String(RecordSet.getString(4)).trim())){
            	expenseamount = expenseamountReal;
            }

		    if( !theprojectid.equals( tempprojectid ) ) fem.setProjectid( tempprojectid ) ;

            fem.setFeetypeid( tempfeetypeid ) ;
            fem.getProjectInfo() ;

            String currentperiod = fem.getCurrentperiod() ;
            /*commented by lupeng 2004.2.20
		    String project_res_currentbudgetstr = "&nbsp;" ;
		    String project_dep_currentbudgetstr = "&nbsp;" ;
		    String project_all_currentbudgetstr = "&nbsp;" ;
		    String project_res_beforebudgetstr = "&nbsp;" ;
		    String project_dep_beforebudgetstr = "&nbsp;" ;
		    String project_all_beforebudgetstr = "&nbsp;" ;
		    String project_res_yearbudgetstr = "&nbsp;" ;
		    String project_dep_yearbudgetstr = "&nbsp;" ;
		    String project_all_yearbudgetstr = "&nbsp;" ;
		    String projectcountbudgetstr = "&nbsp;" ;

		    String project_res_currentexpensestr = "&nbsp;" ;
		    String project_dep_currentexpensestr = "&nbsp;" ;
		    String project_all_currentexpensestr = "&nbsp;" ;
		    String project_res_beforeexpensestr = "&nbsp;" ;
		    String project_dep_beforeexpensestr = "&nbsp;" ;
		    String project_all_beforeexpensestr = "&nbsp;" ;
		    String project_res_yearexpensestr = "&nbsp;" ;
		    String project_dep_yearexpensestr = "&nbsp;" ;
		    String project_all_yearexpensestr = "&nbsp;" ;
		    String projectcountexpensestr = "&nbsp;" ;
            */

            //added by lupeng 2004.2.20
            String project_res_currentbudgetstr = "0" ;
		    String project_dep_currentbudgetstr = "0" ;
		    String project_all_currentbudgetstr = "0" ;
		    String project_res_beforebudgetstr = "0" ;
		    String project_dep_beforebudgetstr = "0" ;
		    String project_all_beforebudgetstr = "0" ;
		    String project_res_yearbudgetstr = "0" ;
		    String project_dep_yearbudgetstr = "0" ;
		    String project_all_yearbudgetstr = "0" ;
		    String projectcountbudgetstr = "0" ;

		    String project_res_currentexpensestr = "0" ;
		    String project_dep_currentexpensestr = "0" ;
		    String project_all_currentexpensestr = "0" ;
		    String project_res_beforeexpensestr = "0;" ;
		    String project_dep_beforeexpensestr = "0" ;
		    String project_all_beforeexpensestr = "0" ;
		    String project_res_yearexpensestr = "0" ;
		    String project_dep_yearexpensestr = "0" ;
		    String project_all_yearexpensestr = "0" ;
		    String projectcountexpensestr = "0" ;
            //end

            double project_res_currentbudget = fem.getProject_res_currentbudget() ;
            double project_dep_currentbudget = fem.getProject_dep_currentbudget() ;
            double project_all_currentbudget = fem.getProject_all_currentbudget() ;
            double project_res_beforebudget = fem.getProject_res_beforebudget() ;
            double project_dep_beforebudget = fem.getProject_dep_beforebudget() ;
            double project_all_beforebudget = fem.getProject_all_beforebudget() ;
            double project_res_yearbudget = fem.getProject_res_yearbudget() ;
            double project_dep_yearbudget = fem.getProject_dep_yearbudget() ;
            double project_all_yearbudget = fem.getProject_all_yearbudget() ;
            double projectcountbudget = fem.getProjectcountbudget() ;

            double project_res_currentexpense = fem.getSumValue(fem.getProject_res_currentexpense(),expenseamount,3) ;
            double project_dep_currentexpense = fem.getSumValue(fem.getProject_dep_currentexpense(),expenseamount,3) ;
            double project_all_currentexpense = fem.getSumValue(fem.getProject_all_currentexpense(),expenseamount,3) ;
            double project_res_beforeexpense = fem.getSumValue(fem.getProject_res_beforeexpense(),expenseamount,3) ;
            double project_dep_beforeexpense = fem.getSumValue(fem.getProject_dep_beforeexpense(),expenseamount,3) ;
            double project_all_beforeexpense = fem.getSumValue(fem.getProject_all_beforeexpense(),expenseamount,3) ;
            double project_res_yearexpense = fem.getSumValue(fem.getProject_res_yearexpense(),expenseamount,3) ;
            double project_dep_yearexpense = fem.getSumValue(fem.getProject_dep_yearexpense(),expenseamount,3) ;
            double project_all_yearexpense = fem.getSumValue(fem.getProject_all_yearexpense(),expenseamount,3) ;

            if( project_res_currentbudget != 0 ) project_res_currentbudgetstr = "" + project_res_currentbudget ;
            if( project_dep_currentbudget != 0 ) project_dep_currentbudgetstr = "" + project_dep_currentbudget ;
            if( project_all_currentbudget != 0 ) project_all_currentbudgetstr = "" + project_all_currentbudget ;
            if( project_res_beforebudget != 0) project_res_beforebudgetstr ="" + project_res_beforebudget ;
            if( project_dep_beforebudget != 0 ) project_dep_beforebudgetstr = "" + project_dep_beforebudget ;
            if( project_all_beforebudget != 0 ) project_all_beforebudgetstr = "" + project_all_beforebudget ;
            if( project_res_yearbudget != 0 ) project_res_yearbudgetstr = "" + project_res_yearbudget ;
            if( project_dep_yearbudget != 0 ) project_dep_yearbudgetstr = "" + project_dep_yearbudget ;
            if( project_all_yearbudget != 0 ) project_all_yearbudgetstr = "" + project_all_yearbudget ;
            if( projectcountbudget != 0) projectcountbudgetstr ="" + projectcountbudget ;

            if( project_res_currentexpense != 0 ) project_res_currentexpensestr = "" + project_res_currentexpense ;
            if( project_dep_currentexpense != 0 ) project_dep_currentexpensestr = "" + project_dep_currentexpense ;
            if( project_all_currentexpense != 0 ) project_all_currentexpensestr = "" + project_all_currentexpense ;
            if( project_res_beforeexpense != 0) project_res_beforeexpensestr ="" + project_res_beforeexpense ;
            if( project_dep_beforeexpense != 0 ) project_dep_beforeexpensestr = "" + project_dep_beforeexpense ;
            if( project_all_beforeexpense != 0 ) project_all_beforeexpensestr = "" + project_all_beforeexpense ;
            if( project_res_yearexpense != 0 ) project_res_yearexpensestr = "" + project_res_yearexpense ;
            if( project_dep_yearexpense != 0 ) project_dep_yearexpensestr = "" + project_dep_yearexpense ;
            if( project_all_yearexpense != 0 ) project_all_yearexpensestr = "" + project_all_yearexpense ;

            if( !theprojectid.equals( tempprojectid ) ) {
                theprojectid = tempprojectid ;
                int projectindex = projectids.indexOf( theprojectid ) ;
                double tempexpenseamount = Util.getDoubleValue((String)expenseamounts.get( projectindex ), 0 ) ;
                double projectcountexpense = fem.getSumValue(fem.getProjectcountexpense(),tempexpenseamount,3) ;
                if( projectcountexpense != 0) projectcountexpensestr ="" + projectcountexpense ;
        %>
        <%if(_prjIdx > 0){ %>
        <TR class="Title">
    	  <TH colSpan=4 height=8></TH>
        </TR>
        <%} %>
	    <TR class="Title" style="text-align: left;">
    	  <TH colSpan=4 style="text-align: left;"><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(theprojectid),user.getLanguage())%></TH>
        </TR>
        <tr class=datalight >
            <td><b><%=SystemEnv.getHtmlLabelName(16294,user.getLanguage())%></b></td>
            <td colspan=3><%=projectcountbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><b><%=SystemEnv.getHtmlLabelName(16295,user.getLanguage())%></b></td>
            <td colspan=3><%=projectcountexpensestr%></td>
        </tr>
        <%      }   %>
        <tr class=header >
            <th class="Title" style="text-align: left;"><%=tempfeetypename%></th>
            <th><%=SystemEnv.getHtmlLabelName(16291,user.getLanguage())%></th>
            <th>1~<%=currentperiod%><%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16296,user.getLanguage())%></td>
            <td><%=project_res_currentbudgetstr%></td>
            <td><%=project_res_beforebudgetstr%></td>
            <td><%=project_res_yearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16297,user.getLanguage())%></td>
            <td><%=project_res_currentexpensestr%></td>
            <td><%=project_res_beforeexpensestr%></td>
            <td><%=project_res_yearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(project_res_currentbudget,project_res_currentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(project_res_beforebudget,project_res_beforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(project_res_yearbudget,project_res_yearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16298,user.getLanguage())%></td>
            <td><%=project_dep_currentbudgetstr%></td>
            <td><%=project_dep_beforebudgetstr%></td>
            <td><%=project_dep_yearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16299,user.getLanguage())%></td>
            <td><%=project_dep_currentexpensestr%></td>
            <td><%=project_dep_beforeexpensestr%></td>
            <td><%=project_dep_yearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(project_dep_currentbudget,project_dep_currentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(project_dep_beforebudget,project_dep_beforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(project_dep_yearbudget,project_dep_yearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16300,user.getLanguage())%></td>
            <td><%=project_all_currentbudgetstr%></td>
            <td><%=project_all_beforebudgetstr%></td>
            <td><%=project_all_yearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16301,user.getLanguage())%></td>
            <td><%=project_all_currentexpensestr%></td>
            <td><%=project_all_beforeexpensestr%></td>
            <td><%=project_all_yearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(project_all_currentbudget,project_all_currentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(project_all_beforebudget,project_all_beforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(project_all_yearbudget,project_all_yearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <%  
        	_prjIdx++;
        }   %>
      </table>
    </div>

    <div id=odiv_4 style="display:none">
	<table class=ListStyle cellspacing=1 id="oTable_4">
        <COLGROUP>
        <COL width="25%">
        <COL width="25%">
        <COL width="25%">
        <COL width="25%">
        <%

        String thecrmid = "" ;
        ArrayList crmids = new ArrayList() ;
        expenseamounts.clear() ;

        RecordSet.executeSql (" select relatedcrm , sum(feesum) sum_feesum, sum(realfeesum) sum_realfeesum from Bill_ExpenseDetail where expenseid = " + billid + " group by relatedcrm ") ;

        while( RecordSet.next() ) {
            String tempcrmid = Util.null2String( RecordSet.getString(1) ) ;
            String tempexpenseamount = Util.null2String( RecordSet.getString(2) ) ;
            String tempexpenseamountReal = Util.null2String( RecordSet.getString(3) ) ;
            if(!"".equals(tempexpenseamountReal)){
            	tempexpenseamount = tempexpenseamountReal;
            }
            
            if( tempcrmid.equals("") || tempcrmid.equals("0") ) continue ;
            crmids.add( tempcrmid ) ;
            expenseamounts.add( tempexpenseamount ) ;
        }

        int _crmIdx = 0;
        RecordSet.executeSql (" select relatedcrm , feetypeid , sum(feesum) sum_feesum, sum(realfeesum) sum_realfeesum from Bill_ExpenseDetail where expenseid = " + billid + " group by relatedcrm, feetypeid ") ;
        while( RecordSet.next() ) {
            String tempcrmid = Util.null2String( RecordSet.getString(1) ) ;
            if( tempcrmid.equals("") || tempcrmid.equals("0") ) continue ;

            String tempfeetypeid = Util.null2String( RecordSet.getString(2) ) ;
            String tempfeetypename = Util.toScreen( BudgetfeeTypeComInfo.getBudgetfeeTypename(tempfeetypeid),user.getLanguage() ) ;
            double expenseamount = Util.getDoubleValue( RecordSet.getString(3), 0 ) ;
            double expenseamountReal = Util.getDoubleValue( RecordSet.getString(4), 0 ) ;
            if(!"".equals(Util.null2String(RecordSet.getString(4)).trim())){
            	expenseamount = expenseamountReal;
            }

		    if( !thecrmid.equals( tempcrmid ) ) fem.setCrmid( tempcrmid ) ;

            fem.setFeetypeid( tempfeetypeid ) ;
            fem.getCrmInfo() ;

            String currentperiod = fem.getCurrentperiod() ;
            /*commented by lupeng 2004.2.20
		    String crm_res_currentbudgetstr = "&nbsp;" ;
		    String crm_dep_currentbudgetstr = "&nbsp;" ;
		    String crm_all_currentbudgetstr = "&nbsp;" ;
		    String crm_res_beforebudgetstr = "&nbsp;" ;
		    String crm_dep_beforebudgetstr = "&nbsp;" ;
		    String crm_all_beforebudgetstr = "&nbsp;" ;
		    String crm_res_yearbudgetstr = "&nbsp;" ;
		    String crm_dep_yearbudgetstr = "&nbsp;" ;
		    String crm_all_yearbudgetstr = "&nbsp;" ;

		    String crm_res_currentexpensestr = "&nbsp;" ;
		    String crm_dep_currentexpensestr = "&nbsp;" ;
		    String crm_all_currentexpensestr = "&nbsp;" ;
		    String crm_res_beforeexpensestr = "&nbsp;" ;
		    String crm_dep_beforeexpensestr = "&nbsp;" ;
		    String crm_all_beforeexpensestr = "&nbsp;" ;
		    String crm_res_yearexpensestr = "&nbsp;" ;
		    String crm_dep_yearexpensestr = "&nbsp;" ;
		    String crm_all_yearexpensestr = "&nbsp;" ;
		    String crmcountexpensestr = "&nbsp;" ;
            */

            //added by lupeng 2004.2.20
            String crm_res_currentbudgetstr = "0" ;
		    String crm_dep_currentbudgetstr = "0" ;
		    String crm_all_currentbudgetstr = "0" ;
		    String crm_res_beforebudgetstr = "0" ;
		    String crm_dep_beforebudgetstr = "0" ;
		    String crm_all_beforebudgetstr = "0" ;
		    String crm_res_yearbudgetstr = "0" ;
		    String crm_dep_yearbudgetstr = "0" ;
		    String crm_all_yearbudgetstr = "0" ;

		    String crm_res_currentexpensestr = "0" ;
		    String crm_dep_currentexpensestr = "0" ;
		    String crm_all_currentexpensestr = "0" ;
		    String crm_res_beforeexpensestr = "0" ;
		    String crm_dep_beforeexpensestr = "0" ;
		    String crm_all_beforeexpensestr = "0" ;
		    String crm_res_yearexpensestr = "0" ;
		    String crm_dep_yearexpensestr = "0" ;
		    String crm_all_yearexpensestr = "0" ;
		    String crmcountexpensestr = "0" ;
            //end

            double crm_res_currentbudget = fem.getCrm_res_currentbudget() ;
            double crm_dep_currentbudget = fem.getCrm_dep_currentbudget() ;
            double crm_all_currentbudget = fem.getCrm_all_currentbudget() ;
            double crm_res_beforebudget = fem.getCrm_res_beforebudget() ;
            double crm_dep_beforebudget = fem.getCrm_dep_beforebudget() ;
            double crm_all_beforebudget = fem.getCrm_all_beforebudget() ;
            double crm_res_yearbudget = fem.getCrm_res_yearbudget() ;
            double crm_dep_yearbudget = fem.getCrm_dep_yearbudget() ;
            double crm_all_yearbudget = fem.getCrm_all_yearbudget() ;

            double crm_res_currentexpense = fem.getSumValue(fem.getCrm_res_currentexpense(),expenseamount,3) ;
            double crm_dep_currentexpense = fem.getSumValue(fem.getCrm_dep_currentexpense(),expenseamount,3) ;
            double crm_all_currentexpense = fem.getSumValue(fem.getCrm_all_currentexpense(),expenseamount,3) ;
            double crm_res_beforeexpense = fem.getSumValue(fem.getCrm_res_beforeexpense(),expenseamount,3) ;
            double crm_dep_beforeexpense = fem.getSumValue(fem.getCrm_dep_beforeexpense(),expenseamount,3) ;
            double crm_all_beforeexpense = fem.getSumValue(fem.getCrm_all_beforeexpense(),expenseamount,3) ;
            double crm_res_yearexpense = fem.getSumValue(fem.getCrm_res_yearexpense(),expenseamount,3) ;
            double crm_dep_yearexpense = fem.getSumValue(fem.getCrm_dep_yearexpense(),expenseamount,3) ;
            double crm_all_yearexpense = fem.getSumValue(fem.getCrm_all_yearexpense(),expenseamount,3) ;


            if( crm_res_currentbudget != 0 ) crm_res_currentbudgetstr = "" + crm_res_currentbudget ;
            if( crm_dep_currentbudget != 0 ) crm_dep_currentbudgetstr = "" + crm_dep_currentbudget ;
            if( crm_all_currentbudget != 0 ) crm_all_currentbudgetstr = "" + crm_all_currentbudget ;
            if( crm_res_beforebudget != 0) crm_res_beforebudgetstr ="" + crm_res_beforebudget ;
            if( crm_dep_beforebudget != 0 ) crm_dep_beforebudgetstr = "" + crm_dep_beforebudget ;
            if( crm_all_beforebudget != 0 ) crm_all_beforebudgetstr = "" + crm_all_beforebudget ;
            if( crm_res_yearbudget != 0 ) crm_res_yearbudgetstr = "" + crm_res_yearbudget ;
            if( crm_dep_yearbudget != 0 ) crm_dep_yearbudgetstr = "" + crm_dep_yearbudget ;
            if( crm_all_yearbudget != 0 ) crm_all_yearbudgetstr = "" + crm_all_yearbudget ;

            if( crm_res_currentexpense != 0 ) crm_res_currentexpensestr = "" + crm_res_currentexpense ;
            if( crm_dep_currentexpense != 0 ) crm_dep_currentexpensestr = "" + crm_dep_currentexpense ;
            if( crm_all_currentexpense != 0 ) crm_all_currentexpensestr = "" + crm_all_currentexpense ;
            if( crm_res_beforeexpense != 0) crm_res_beforeexpensestr ="" + crm_res_beforeexpense ;
            if( crm_dep_beforeexpense != 0 ) crm_dep_beforeexpensestr = "" + crm_dep_beforeexpense ;
            if( crm_all_beforeexpense != 0 ) crm_all_beforeexpensestr = "" + crm_all_beforeexpense ;
            if( crm_res_yearexpense != 0 ) crm_res_yearexpensestr = "" + crm_res_yearexpense ;
            if( crm_dep_yearexpense != 0 ) crm_dep_yearexpensestr = "" + crm_dep_yearexpense ;
            if( crm_all_yearexpense != 0 ) crm_all_yearexpensestr = "" + crm_all_yearexpense ;

            if( !thecrmid.equals( tempcrmid ) ) {
                thecrmid = tempcrmid ;
                int projectindex = crmids.indexOf( thecrmid ) ;
                double tempexpenseamount = Util.getDoubleValue((String)expenseamounts.get( projectindex ), 0 ) ;
                double crmcountexpense = fem.getSumValue(fem.getCrmcountexpense(),tempexpenseamount,3) ;
                if( crmcountexpense != 0) crmcountexpensestr ="" + crmcountexpense ;
        %>
        <%if(_crmIdx > 0){ %>
        <TR class="Title">
    	  <TH colSpan=4 height=8></TH>
        </TR>
        <%} %>
	    <TR class="Title" style="text-align: left;">
    	  <TH colSpan=4 style="text-align: left;">CRM<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(thecrmid),user.getLanguage())%></TH>
        </TR>
        <tr class=datalight >
            <td><b>CRM<%=SystemEnv.getHtmlLabelName(16302,user.getLanguage())%>)</b></td>
            <td colspan=3><%=crmcountexpensestr%></td>
        </tr>
        <%      }   %>
        <tr class=header >
            <th class="Title" style="text-align: left;"><%=tempfeetypename%></th>
            <th><%=SystemEnv.getHtmlLabelName(16291,user.getLanguage())%></th>
            <th>1~<%=currentperiod%><%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16303,user.getLanguage())%></td>
            <td><%=crm_res_currentbudgetstr%></td>
            <td><%=crm_res_beforebudgetstr%></td>
            <td><%=crm_res_yearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16304,user.getLanguage())%></td>
            <td><%=crm_res_currentexpensestr%></td>
            <td><%=crm_res_beforeexpensestr%></td>
            <td><%=crm_res_yearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(crm_res_currentbudget,crm_res_currentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(crm_res_beforebudget,crm_res_beforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(crm_res_yearbudget,crm_res_yearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16305,user.getLanguage())%></td>
            <td><%=crm_dep_currentbudgetstr%></td>
            <td><%=crm_dep_beforebudgetstr%></td>
            <td><%=crm_dep_yearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16306,user.getLanguage())%></td>
            <td><%=crm_dep_currentexpensestr%></td>
            <td><%=crm_dep_beforeexpensestr%></td>
            <td><%=crm_dep_yearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(crm_dep_currentbudget,crm_dep_currentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(crm_dep_beforebudget,crm_dep_beforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(crm_dep_yearbudget,crm_dep_yearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16307,user.getLanguage())%></td>
            <td><%=crm_all_currentbudgetstr%></td>
            <td><%=crm_all_beforebudgetstr%></td>
            <td><%=crm_all_yearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16308,user.getLanguage())%></td>
            <td><%=crm_all_currentexpensestr%></td>
            <td><%=crm_all_beforeexpensestr%></td>
            <td><%=crm_all_yearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(crm_all_currentbudget,crm_all_currentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(crm_all_beforebudget,crm_all_beforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(crm_all_yearbudget,crm_all_yearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <%  
        	_crmIdx++;
        }   %>
      </table>
    </div>

    	</wea:item>
    </wea:group>
</wea:layout>

<script type="text/javascript">
function dspfna(objval) {
	if (objval == 1) {
	    $GetEle("alldetail").style.display="";
	    $GetEle("distd").innerHTML = "<a href='#' onclick='dspfna(0);'><%=SystemEnv.getHtmlLabelName(16309,user.getLanguage())%></a>";
	} else {
		$GetEle("alldetail").style.display="none";
		$GetEle("distd").innerHTML = "<a href='#this' onclick='dspfna(1);'><%=SystemEnv.getHtmlLabelName(16285,user.getLanguage())%></a>";
	}
}

jQuery("#ipt_onChangetype_1").click(function(event){
	onChangetype(1);
});
jQuery("#ipt_onChangetype_2").click(function(event){
	onChangetype(2);
});
jQuery("#ipt_onChangetype_3").click(function(event){
	onChangetype(3);
});
jQuery("#ipt_onChangetype_4").click(function(event){
	onChangetype(4);
});

jQuery("#spanonChangetype_1").mousedown(function(event){
	onChangetype(1);
});
jQuery("#spanonChangetype_2").mousedown(function(event){
	onChangetype(2);
});
jQuery("#spanonChangetype_3").mousedown(function(event){
	onChangetype(3);
});
jQuery("#spanonChangetype_4").mousedown(function(event){
	onChangetype(4);
});


function onChangetype(objval){
	jQuery("#ipt_onChangetype_1").next("span.jNiceCheckbox").removeClass("jNiceChecked");
	jQuery("#ipt_onChangetype_2").next("span.jNiceCheckbox").removeClass("jNiceChecked");
	jQuery("#ipt_onChangetype_3").next("span.jNiceCheckbox").removeClass("jNiceChecked");
	jQuery("#ipt_onChangetype_4").next("span.jNiceCheckbox").removeClass("jNiceChecked");
	
	if (objval == 1) {
		jQuery("#ipt_onChangetype_1").next("span.jNiceCheckbox").addClass("jNiceChecked");
		$GetEle("odiv_1").style.display="";
		$GetEle("odiv_2").style.display="none";
		$GetEle("odiv_3").style.display="none";
		$GetEle("odiv_4").style.display="none";
	}
	if (objval == 2) {
		jQuery("#ipt_onChangetype_2").next("span.jNiceCheckbox").addClass("jNiceChecked");
		$GetEle("odiv_1").style.display="none";
		$GetEle("odiv_2").style.display="";
		$GetEle("odiv_3").style.display="none";
		$GetEle("odiv_4").style.display="none";
	}
	if (objval == 3) {
		jQuery("#ipt_onChangetype_3").next("span.jNiceCheckbox").addClass("jNiceChecked");
		$GetEle("odiv_1").style.display="none";
		$GetEle("odiv_2").style.display="none";
		$GetEle("odiv_3").style.display="";
		$GetEle("odiv_4").style.display="none";
	}
	if (objval == 4) {
		jQuery("#ipt_onChangetype_4").next("span.jNiceCheckbox").addClass("jNiceChecked");
		$GetEle("odiv_1").style.display="none";
		$GetEle("odiv_2").style.display="none";
		$GetEle("odiv_3").style.display="none";
		$GetEle("odiv_4").style.display="";
	}
	
}
</script>
<%
}
%>
