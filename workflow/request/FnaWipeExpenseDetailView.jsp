
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.fna.maintenance.*"%>
<%@ page import="weaver.fna.budget.*"%>
<%@ page import="java.util.TreeSet"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj,
                 weaver.general.Util" %>
                 <%@ page import="weaver.hrm.*" %>
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SystemEnv" class="weaver.systeminfo.SystemEnv" scope="page"/>
<jsp:useBean id="tmpRs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>


<%
int requestid=Util.getIntValue(request.getParameter("requestid"));
RecordSet.executeSql("select currentnodetype from workflow_requestbase where requestid = " + requestid);
RecordSet.next();
String currentnodetype=RecordSet.getString(1);
int creater=Util.getIntValue(request.getParameter("creater"));
String billid=Util.null2String(request.getParameter("billid"));
User user = HrmUserVarify.getUser (request , response) ;
RecordSet.executeSql("select organizationid from Bill_FnaWipeApplyDetail where id="+billid+" and organizationtype=3 order by dsporder");
String organizationIdsOfPerson = "";
while(RecordSet.next()){
	organizationIdsOfPerson += RecordSet.getString(1) + ",";
}
//System.out.println("organizationIdsOfPerson="+organizationIdsOfPerson);
RecordSet.executeSql("select organizationid from Bill_FnaWipeApplyDetail where id="+billid+" and organizationtype=2 order by dsporder");
String organizationIdsOfDept = "";
while(RecordSet.next()){
	organizationIdsOfDept += RecordSet.getString(1) + ",";
}
    String deptid=ResourceComInfo.getDepartmentID(""+creater);
    RecordSet.executeSql (" select subject , budgetperiod,relatedprj,relatedcrm from Bill_FnaWipeApplyDetail where organizationtype=3 and organizationid="+creater+" and id = " + billid + " order by subject ") ;
    TreeSet subjects=new TreeSet();
    HashMap prjsubjectmaps=new  HashMap();
    HashMap crmsubjectmaps=new HashMap();
	String currentperiod = "";
    //end
%>

<wea:layout>
	<wea:group attributes="{\"itemAreaDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(15805,user.getLanguage()) %>'>
		<wea:item type="groupHead">
			<select onchange="onChangetype(this.value);">
				<option value="1"><%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(16289,user.getLanguage())%></option>
				<option value="3"><%=SystemEnv.getHtmlLabelName(16290,user.getLanguage())%></option>
				<option value="4"><%=SystemEnv.getHtmlLabelName(20323,user.getLanguage())%></option>
			</select>
		</wea:item>
    </wea:group>
</wea:layout>
<div id=odiv_1>
	<table class=ListStyle cellspacing=1 id="oTable_1">
<%
if(!"".equals(organizationIdsOfPerson)){
	ArrayList organizationIds = Util.TokenizerString(organizationIdsOfPerson, ",");
	String temp = "";
	for(int k=0;k<organizationIds.size();k++){
		String organizationId = (String)organizationIds.get(k);
		if(temp.indexOf(organizationId) >= 0) continue;
		RecordSet.executeSql("select sum(amount) from fnaloaninfo where organizationtype=3 and organizationid="+organizationId);
    RecordSet.next();
    String loanamount = RecordSet.getString(1);
    String username= ResourceComInfo.getLastname(organizationId);
%>
        <tr class=datalight >
            <td><b><%=username%><%=SystemEnv.getHtmlLabelName(18672,user.getLanguage())%></b></td>
            <td colspan=3><%=loanamount%></td>
        </tr>
        <%
RecordSet.executeSql (" select subject , budgetperiod,relatedprj,relatedcrm from Bill_FnaWipeApplyDetail where organizationtype=3 and organizationid="+organizationId+" and id = " + billid + " order by subject ") ;
subjects=new TreeSet();
prjsubjectmaps=new  HashMap();
crmsubjectmaps=new HashMap();
while(RecordSet.next()){
int tempsubj= RecordSet.getInt(1)  ;
String tempbudgetperiod= Util.null2String( RecordSet.getString(2) ) ;
int relatedprj=RecordSet.getInt(3);
int relatedcrm=RecordSet.getInt(4);
if(tempsubj==0) continue;
BudgetPeriod bp=BudgetHandler.getBudgetPeriod(tempbudgetperiod,tempsubj);
if(bp==null)
break;
SubjectPeriod s=new SubjectPeriod();
s.setSubject(tempsubj);
s.setPeriod(bp.getPeriod());
s.setStartdate(bp.getStartdate());
s.setEnddate(bp.getEnddate());
s.setPeriodlist(bp.getPeriodlist());
s.setType(bp.getType());
subjects.add(s);
if(relatedprj!=0){
if(prjsubjectmaps.get(""+relatedprj)==null)
prjsubjectmaps.put(""+relatedprj,new TreeSet());
((TreeSet)prjsubjectmaps.get(""+relatedprj)).add(s);
}
if(relatedcrm!=0){
if(crmsubjectmaps.get(""+relatedcrm)==null)
crmsubjectmaps.put(""+relatedcrm,new TreeSet());
((TreeSet)crmsubjectmaps.get(""+relatedcrm)).add(s);
}
}
            for( Iterator i=subjects.iterator() ;i.hasNext(); ) {
                SubjectPeriod sp=(SubjectPeriod)i.next();
                String tempfeetypeid =""+sp.getSubject() ;
                String tempfeetypename = BudgetfeeTypeComInfo.getBudgetfeeTypename(tempfeetypeid) ;
                currentperiod = ""+sp.getPeriodlist() ;
                BudgetYear by=BudgetHandler.getBudgetYear(sp.getStartdate());
				if(by == null){continue;}
                Expense cur_exp= BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),3,Util.getIntValue(organizationId),sp.getSubject(),0,0,0);
                Expense cur_exp1=BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),3,Util.getIntValue(organizationId),sp.getSubject(),0,0,requestid);

                Expense before_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),3,Util.getIntValue(organizationId),sp.getSubject(),0,0,0);
                Expense before_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),3,Util.getIntValue(organizationId),sp.getSubject(),0,0,requestid);

                Expense year_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),3,Util.getIntValue(organizationId),sp.getSubject(),0,0,0);
                Expense year_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),3,Util.getIntValue(organizationId),sp.getSubject(),0,0,requestid);
                double resourcecurrentbudget = BudgetHandler.getBudget(3,Util.getIntValue(organizationId),sp.getPeriod(),sp.getPeriodlist(),sp.getSubject(),0,0);
                double resourcebeforebudget = 0 ;
                for(int p=1;p<=sp.getPeriodlist();p++){
                  resourcebeforebudget+= BudgetHandler.getBudget(3,Util.getIntValue(organizationId),sp.getPeriod(),p,sp.getSubject(),0,0);
                }
                double resourceyearbudget = 0;
                int lastperiodlist=0;
                switch(sp.getType()){
                    case 1:
                        lastperiodlist =12;
                        break;
                    case 2:
                        lastperiodlist=4;
                        break;
                    case 3:
                        lastperiodlist=2;
                        break;
                   case 4:
                       lastperiodlist=1;
                       break;

                }
                //System.out.println("lastperiodlist"+lastperiodlist);
                for(int p=1;p<=lastperiodlist;p++){
                  resourceyearbudget+= BudgetHandler.getBudget(3,Util.getIntValue(organizationId),sp.getPeriod(),p,sp.getSubject(),0,0);
                }
                double resourcecurrentexpense = 0;
                double resourcebeforeexpense = 0;
                double resourceyearexpense = 0;
                if(currentnodetype.equals("3")){
	                resourcecurrentexpense = cur_exp.getRealExpense();
	                //double resourcebeforeexpense = before_exp.getRealExpense();
	                resourceyearexpense = year_exp.getRealExpense();
	                resourcebeforeexpense = resourceyearexpense - resourcecurrentexpense;
                }else{
                	resourcecurrentexpense = cur_exp.getRealExpense()+cur_exp1.getRealExpense()+cur_exp1.getPendingExpense();
	                resourceyearexpense = year_exp.getRealExpense()+year_exp1.getRealExpense()+year_exp1.getPendingExpense();
	                resourcebeforeexpense = resourceyearexpense - resourcecurrentexpense;
                }
                String resourcecurrentbudgetstr = "0" ;
                String resourcebeforebudgetstr = "0" ;
                String resourceyearbudgetstr = "0" ;
                String resourcecurrentexpensestr = "0" ;
                String resourcebeforeexpensestr = "0" ;
                String resourceyearexpensestr = "0" ;
                if( resourcecurrentbudget != 0 ) resourcecurrentbudgetstr = ""+resourcecurrentbudget ;
                if( resourcebeforebudget != 0 ) resourcebeforebudgetstr = ""+resourcebeforebudget ;
                if( resourceyearbudget != 0 ) resourceyearbudgetstr = ""+resourceyearbudget ;
                if( resourcecurrentexpense != 0) resourcecurrentexpensestr =""+resourcecurrentexpense ;
                if( resourcebeforeexpense != 0 ) resourcebeforeexpensestr = ""+resourcebeforeexpense ;
                if( resourceyearexpense != 0 ) resourceyearexpensestr = ""+resourceyearexpense ;

        %>
        <!--
        <TR class="Title">
    	  <TH colSpan=4></TH>
        </TR>
        -->
        <tr class=header >
            <th class="Title"><%=tempfeetypename%></th>
            <th><%=SystemEnv.getHtmlLabelName(16291,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></td>
            <td><%=Util.round(resourcecurrentbudgetstr,2)%></td>
            <td><%=Util.round(resourcebeforebudgetstr,2)%></td>
            <td><%=Util.round(resourceyearbudgetstr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16292,user.getLanguage())%></td>
            <td><%=Util.round(resourcecurrentexpensestr,2)%></td>
            <td><%=Util.round(resourcebeforeexpensestr,2)%></td>
            <td><%=Util.round(resourceyearexpensestr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(resourcecurrentexpense>resourcecurrentbudget){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(resourcebeforeexpense>resourcebeforebudget){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(resourceyearexpense>resourceyearbudget){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <%  temp += organizationId + ",";} } }  %>
      </table>
    </div>
<div id=odiv_2 style="display:none">
	<table class=ListStyle cellspacing=1 id="oTable_2">
<%
if(!"".equals(organizationIdsOfDept)){
	ArrayList organizationIds = Util.TokenizerString(organizationIdsOfDept, ",");
	String temp = "";
	for(int k=0;k<organizationIds.size();k++){
		String organizationId = (String)organizationIds.get(k);
		if(temp.indexOf(organizationId) >= 0) continue;
		RecordSet.executeSql("select sum(amount) from fnaloaninfo where organizationtype=2 and organizationid="+organizationId);
    RecordSet.next();
    String loanamountOfDept = RecordSet.getString(1);
    String udeptname= DepartmentComInfo.getDepartmentname(organizationId);
%>
        <tr class=datalight >
            <td><b><%=udeptname%><%=SystemEnv.getHtmlLabelName(18672,user.getLanguage())%>:</b></td>
            <td colspan=3><%=loanamountOfDept%></td>
        </tr>
        <% 
RecordSet.executeSql (" select subject , budgetperiod,relatedprj,relatedcrm from Bill_FnaWipeApplyDetail where organizationtype=2 and organizationid="+organizationId+" and id = " + billid + " order by subject ") ;
subjects=new TreeSet();
prjsubjectmaps=new  HashMap();
crmsubjectmaps=new HashMap();
while(RecordSet.next()){
int tempsubj= RecordSet.getInt(1)  ;
String tempbudgetperiod= Util.null2String( RecordSet.getString(2) ) ;
int relatedprj=RecordSet.getInt(3);
int relatedcrm=RecordSet.getInt(4);
if(tempsubj==0) continue;
BudgetPeriod bp=BudgetHandler.getBudgetPeriod(tempbudgetperiod,tempsubj);
if(bp==null)
break;
SubjectPeriod s=new SubjectPeriod();
s.setSubject(tempsubj);
s.setPeriod(bp.getPeriod());
s.setStartdate(bp.getStartdate());
s.setEnddate(bp.getEnddate());
s.setPeriodlist(bp.getPeriodlist());
s.setType(bp.getType());
subjects.add(s);
if(relatedprj!=0){
if(prjsubjectmaps.get(""+relatedprj)==null)
prjsubjectmaps.put(""+relatedprj,new TreeSet());
((TreeSet)prjsubjectmaps.get(""+relatedprj)).add(s);
}
if(relatedcrm!=0){
if(crmsubjectmaps.get(""+relatedcrm)==null)
crmsubjectmaps.put(""+relatedcrm,new TreeSet());
((TreeSet)crmsubjectmaps.get(""+relatedcrm)).add(s);
}
}          
            for( Iterator i=subjects.iterator() ;i.hasNext(); ) {
                SubjectPeriod sp=(SubjectPeriod)i.next();
                String tempfeetypeid =""+sp.getSubject() ;
                String tempfeetypename = BudgetfeeTypeComInfo.getBudgetfeeTypename(tempfeetypeid) ;
                currentperiod = ""+sp.getPeriodlist() ;
                BudgetYear by=BudgetHandler.getBudgetYear(sp.getStartdate());
				if(by == null){continue;}
                Expense cur_exp= BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),2,Util.getIntValue(organizationId),sp.getSubject(),0,0,0);
                Expense cur_exp1=BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),2,Util.getIntValue(organizationId),sp.getSubject(),0,0,requestid);

                Expense before_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),2,Util.getIntValue(organizationId),sp.getSubject(),0,0,0);
                Expense before_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),2,Util.getIntValue(organizationId),sp.getSubject(),0,0,requestid);

                Expense year_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),2,Util.getIntValue(organizationId),sp.getSubject(),0,0,0);
                Expense year_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),2,Util.getIntValue(organizationId),sp.getSubject(),0,0,requestid);
                double departmentcurrentbudget = BudgetHandler.getBudget(2,Util.getIntValue(organizationId),sp.getPeriod(),sp.getPeriodlist(),sp.getSubject(),0,0);

                double departmentbeforebudget = 0 ;
                for(int p=1;p<=sp.getPeriodlist();p++){
                  departmentbeforebudget+= BudgetHandler.getBudget(2,Util.getIntValue(organizationId),sp.getPeriod(),p,sp.getSubject(),0,0);
                }
                double departmentyearbudget = 0;
                int lastperiodlist=0;
                switch(sp.getType()){
                    case 1:
                        lastperiodlist =12;
                        break;
                    case 2:
                        lastperiodlist=4;
                        break;
                    case 3:
                        lastperiodlist=2;
                        break;
                   case 4:
                       lastperiodlist=1;
                       break;

                }
                //System.out.println("lastperiodlist"+lastperiodlist);
                for(int p=1;p<=lastperiodlist;p++){
                  departmentyearbudget+= BudgetHandler.getBudget(2,Util.getIntValue(organizationId),sp.getPeriod(),p,sp.getSubject(),0,0);
                }
                double departmentcurrentexpense = 0;
                double departmentbeforeexpense = 0;
                double departmentyearexpense = 0;
                if(currentnodetype.equals("3")){
	                departmentcurrentexpense = cur_exp.getRealExpense();
	                //double departmentbeforeexpense = before_exp.getRealExpense();
	                departmentyearexpense = year_exp.getRealExpense();
	                departmentbeforeexpense = departmentyearexpense - departmentcurrentexpense;
                }else{
	                departmentcurrentexpense = cur_exp.getRealExpense()+cur_exp1.getRealExpense()+cur_exp1.getPendingExpense();
	                departmentyearexpense = year_exp.getRealExpense()+year_exp1.getRealExpense()+year_exp1.getPendingExpense();
	                departmentbeforeexpense = departmentyearexpense - departmentcurrentexpense;
                }
                String departmentcurrentbudgetstr = "0" ;
                String departmentbeforebudgetstr = "0" ;
                String departmentyearbudgetstr = "0" ;
                String departmentcurrentexpensestr = "0" ;
                String departmentbeforeexpensestr = "0" ;
                String departmentyearexpensestr = "0" ;
                //end

                if( departmentcurrentbudget != 0 ) departmentcurrentbudgetstr = ""+departmentcurrentbudget ;
                if( departmentbeforebudget != 0 ) departmentbeforebudgetstr = ""+departmentbeforebudget ;
                if( departmentyearbudget != 0 ) departmentyearbudgetstr = ""+departmentyearbudget ;
                if( departmentcurrentexpense != 0) departmentcurrentexpensestr =""+departmentcurrentexpense ;
                if( departmentbeforeexpense != 0 ) departmentbeforeexpensestr = ""+departmentbeforeexpense ;
                if( departmentyearexpense != 0 ) departmentyearexpensestr = ""+departmentyearexpense ;
        %>
        <!--
        <TR class="Title">
    	  <TH colSpan=4></TH>
        </TR>
        -->
        <tr class=header >
            <th class="Title"><%=tempfeetypename%></th>
            <th><%=SystemEnv.getHtmlLabelName(16291,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></td>
            <td><%=Util.round(departmentcurrentbudgetstr,2)%></td>
            <td><%=Util.round(departmentbeforebudgetstr,2)%></td>
            <td><%=Util.round(departmentyearbudgetstr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16292,user.getLanguage())%></td>
            <td><%=Util.round(departmentcurrentexpensestr,2)%></td>
            <td><%=Util.round(departmentbeforeexpensestr,2)%></td>
            <td><%=Util.round(departmentyearexpensestr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(departmentcurrentexpense>departmentcurrentbudget){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(departmentbeforeexpense>departmentbeforebudget){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(departmentyearexpense>departmentyearbudget){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <%  temp += organizationId + ",";}  } }%>
      </table>
    </div>
<div id=odiv_3 style="display:none">
	<table class=ListStyle cellspacing=1 id="oTable_3">
        <%

      for(Iterator i0=prjsubjectmaps.keySet().iterator();i0.hasNext();){
          String projectid_str=(String)i0.next();
          int projectid=Util.getIntValue(projectid_str,0);
          subjects=(TreeSet)prjsubjectmaps.get(projectid_str);
          //System.out.println("prjid"+projectid);
          //System.out.println("subject size"+subjects.size());
          Expense total_exp= BudgetHandler.getExpenseRecursion("1900-01-01","2100-01-01",0,0,0,projectid,0,0);
          Expense total_exp1=BudgetHandler.getExpenseRecursion("1900-01-01","2100-01-01",0,0,0,projectid,0,requestid);
          double projectcountexpense =total_exp.getRealExpense()+total_exp.getPendingExpense();
          String projectcountexpensestr = "0" ;
          if( projectcountexpense != 0) projectcountexpensestr ="" + projectcountexpense ;
          %>
        <TR class="Title">
    	  <TH colSpan=4 height=8></TH>
        </TR>
	    <TR class="Title">
    	  <TH colSpan=4><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%>：<%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid_str),user.getLanguage())%></TH>
        </TR>
        <tr class=datalight >
            <td><b><%=SystemEnv.getHtmlLabelName(16295,user.getLanguage())%></b></td>
            <td colspan=3><%=projectcountexpensestr%></td>
        </tr>
        <%
          for( Iterator i=subjects.iterator() ;i.hasNext(); ) {
                SubjectPeriod sp=(SubjectPeriod)i.next();
                String tempfeetypeid =""+sp.getSubject() ;
                String tempfeetypename = BudgetfeeTypeComInfo.getBudgetfeeTypename(tempfeetypeid) ;
                currentperiod = ""+sp.getPeriodlist() ;
                BudgetYear by=BudgetHandler.getBudgetYear(sp.getStartdate());
				if(by == null){continue;}
                Expense res_cur_exp= BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),3,creater,sp.getSubject(),projectid,0,0);
                Expense res_cur_exp1=BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),3,creater,sp.getSubject(),projectid,0,requestid);

                Expense res_before_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),3,creater,sp.getSubject(),projectid,0,0);
                Expense res_before_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),3,creater,sp.getSubject(),projectid,0,requestid);

                Expense res_year_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),3,creater,sp.getSubject(),projectid,0,0);
                Expense res_year_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),3,creater,sp.getSubject(),projectid,0,requestid);

                Expense dep_cur_exp= BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),2,Util.getIntValue(deptid),sp.getSubject(),projectid,0,0);
                Expense dep_cur_exp1=BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),2,Util.getIntValue(deptid),sp.getSubject(),projectid,0,requestid);

                Expense dep_before_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),2,Util.getIntValue(deptid),sp.getSubject(),projectid,0,0);
                Expense dep_before_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),2,Util.getIntValue(deptid),sp.getSubject(),projectid,0,requestid);

                Expense dep_year_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),2,Util.getIntValue(deptid),sp.getSubject(),projectid,0,0);
                Expense dep_year_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),2,Util.getIntValue(deptid),sp.getSubject(),projectid,0,requestid);

                Expense all_cur_exp= BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),0,0,sp.getSubject(),projectid,0,0);
                Expense all_cur_exp1=BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),0,0,sp.getSubject(),projectid,0,requestid);

                Expense all_before_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),0,0,sp.getSubject(),projectid,0,0);
                Expense all_before_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),0,0,sp.getSubject(),projectid,0,requestid);

                Expense all_year_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),0,0,sp.getSubject(),projectid,0,0);
                Expense all_year_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),0,0,sp.getSubject(),projectid,0,requestid);



                double project_res_currentbudget = BudgetHandler.getBudget(3,creater,sp.getPeriod(),sp.getPeriodlist(),sp.getSubject(),projectid,0);
                double project_dep_currentbudget=BudgetHandler.getBudget(2,Util.getIntValue(deptid),sp.getPeriod(),sp.getPeriodlist(),sp.getSubject(),projectid,0);
                double project_all_currentbudget=BudgetHandler.getBudget(0,0,sp.getPeriod(),sp.getPeriodlist(),sp.getSubject(),projectid,0);
                double project_res_beforebudget = 0 ;
                double project_dep_beforebudget = 0 ;
                double project_all_beforebudget = 0 ;
                for(int p=1;p<=sp.getPeriodlist();p++){
                  project_res_beforebudget+= BudgetHandler.getBudget(3,creater,sp.getPeriod(),p,sp.getSubject(),projectid,0);
                  project_dep_beforebudget+= BudgetHandler.getBudget(2,Util.getIntValue(deptid),sp.getPeriod(),p,sp.getSubject(),projectid,0);
                  project_all_beforebudget+= BudgetHandler.getBudget(0,0,sp.getPeriod(),p,sp.getSubject(),projectid,0);
                }
                double project_res_yearbudget = 0 ;
                double project_dep_yearbudget = 0 ;
                double project_all_yearbudget = 0 ;
                int lastperiodlist=0;
                switch(sp.getType()){
                    case 1:
                        lastperiodlist =12;
                        break;
                    case 2:
                        lastperiodlist=4;
                        break;
                    case 3:
                        lastperiodlist=2;
                        break;
                   case 4:
                       lastperiodlist=1;
                       break;

                }
                //System.out.println("lastperiodlist"+lastperiodlist);
                for(int p=1;p<=lastperiodlist;p++){
                  project_res_yearbudget+= BudgetHandler.getBudget(3,creater,sp.getPeriod(),p,sp.getSubject(),projectid,0);
                  project_dep_yearbudget+= BudgetHandler.getBudget(2,Util.getIntValue(deptid),sp.getPeriod(),p,sp.getSubject(),projectid,0);
                  project_all_yearbudget+= BudgetHandler.getBudget(0,0,sp.getPeriod(),p,sp.getSubject(),projectid,0);
                }
                double project_res_currentexpense = res_cur_exp.getRealExpense()+res_cur_exp.getPendingExpense();
                double project_res_beforeexpense = res_before_exp.getRealExpense()+res_before_exp.getPendingExpense();
                double project_res_yearexpense = res_year_exp.getRealExpense()+res_year_exp.getPendingExpense();
                double project_dep_currentexpense = dep_cur_exp.getRealExpense()+dep_cur_exp.getPendingExpense();
                double project_dep_beforeexpense = dep_before_exp.getRealExpense()+dep_before_exp.getPendingExpense();
                double project_dep_yearexpense = dep_year_exp.getRealExpense()+dep_year_exp.getPendingExpense();
                double project_all_currentexpense = all_cur_exp.getRealExpense()+all_cur_exp.getPendingExpense();
                double project_all_beforeexpense = all_before_exp.getRealExpense()+all_before_exp.getPendingExpense();
                double project_all_yearexpense = all_year_exp.getRealExpense()+all_year_exp.getPendingExpense();

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

            //end



            //double projectcountbudget = fem.getProjectcountbudget() ;





            if( project_res_currentbudget != 0 ) project_res_currentbudgetstr = "" + project_res_currentbudget ;
            if( project_dep_currentbudget != 0 ) project_dep_currentbudgetstr = "" + project_dep_currentbudget ;
            if( project_all_currentbudget != 0 ) project_all_currentbudgetstr = "" + project_all_currentbudget ;
            if( project_res_beforebudget != 0) project_res_beforebudgetstr ="" + project_res_beforebudget ;
            if( project_dep_beforebudget != 0 ) project_dep_beforebudgetstr = "" + project_dep_beforebudget ;
            if( project_all_beforebudget != 0 ) project_all_beforebudgetstr = "" + project_all_beforebudget ;
            if( project_res_yearbudget != 0 ) project_res_yearbudgetstr = "" + project_res_yearbudget ;
            if( project_dep_yearbudget != 0 ) project_dep_yearbudgetstr = "" + project_dep_yearbudget ;
            if( project_all_yearbudget != 0 ) project_all_yearbudgetstr = "" + project_all_yearbudget ;
           // if( projectcountbudget != 0) projectcountbudgetstr ="" + projectcountbudget ;

            if( project_res_currentexpense != 0 ) project_res_currentexpensestr = "" + project_res_currentexpense ;
            if( project_dep_currentexpense != 0 ) project_dep_currentexpensestr = "" + project_dep_currentexpense ;
            if( project_all_currentexpense != 0 ) project_all_currentexpensestr = "" + project_all_currentexpense ;
            if( project_res_beforeexpense != 0) project_res_beforeexpensestr ="" + project_res_beforeexpense ;
            if( project_dep_beforeexpense != 0 ) project_dep_beforeexpensestr = "" + project_dep_beforeexpense ;
            if( project_all_beforeexpense != 0 ) project_all_beforeexpensestr = "" + project_all_beforeexpense ;
            if( project_res_yearexpense != 0 ) project_res_yearexpensestr = "" + project_res_yearexpense ;
            if( project_dep_yearexpense != 0 ) project_dep_yearexpensestr = "" + project_dep_yearexpense ;
            if( project_all_yearexpense != 0 ) project_all_yearexpensestr = "" + project_all_yearexpense ;

        %>


        <!---
        <TR class="Title">

        </TR>
        -->
        <tr class=header >
            <th class="Title"><%=tempfeetypename%></th>
            <th><%=SystemEnv.getHtmlLabelName(16291,user.getLanguage())%></th>
            <th>1~<%=currentperiod%><%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16296,user.getLanguage())%></td>
            <td><%=Util.round(project_res_currentbudgetstr,2)%></td>
            <td><%=Util.round(project_res_beforebudgetstr,2)%></td>
            <td><%=Util.round(project_res_yearbudgetstr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16297,user.getLanguage())%></td>
            <td><%=Util.round(project_res_currentexpensestr,2)%></td>
            <td><%=Util.round(project_res_beforeexpensestr,2)%></td>
            <td><%=Util.round(project_res_yearexpensestr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(project_res_currentexpense>project_res_currentbudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(project_res_beforeexpense>project_res_beforebudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(project_res_yearexpense>project_res_yearbudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16298,user.getLanguage())%></td>
            <td><%=Util.round(project_dep_currentbudgetstr,2)%></td>
            <td><%=Util.round(project_dep_beforebudgetstr,2)%></td>
            <td><%=Util.round(project_dep_yearbudgetstr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16299,user.getLanguage())%></td>
            <td><%=Util.round(project_dep_currentexpensestr,2)%></td>
            <td><%=Util.round(project_dep_beforeexpensestr,2)%></td>
            <td><%=Util.round(project_dep_yearexpensestr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(project_dep_currentexpense>project_dep_currentbudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(project_dep_beforeexpense>project_dep_beforebudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(project_dep_yearexpense>project_dep_yearbudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16300,user.getLanguage())%></td>
            <td><%=Util.round(project_all_currentbudgetstr,2)%></td>
            <td><%=Util.round(project_all_beforebudgetstr,2)%></td>
            <td><%=Util.round(project_all_yearbudgetstr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16301,user.getLanguage())%></td>
            <td><%=Util.round(project_all_currentexpensestr,2)%></td>
            <td><%=Util.round(project_all_beforeexpensestr,2)%></td>
            <td><%=Util.round(project_all_yearexpensestr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(project_all_currentexpense>project_all_currentbudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(project_all_beforeexpense>project_all_beforebudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(project_all_yearexpense>project_all_yearbudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <% }  }  %>
      </table>
</div>
<div id=odiv_4 style="display:none">
	<table class=ListStyle cellspacing=1 id="oTable_4">
        <%

      for(Iterator i0=crmsubjectmaps.keySet().iterator();i0.hasNext();){
          String crmid_str=(String)i0.next();
          int customerid=Util.getIntValue(crmid_str,0);
          subjects=(TreeSet)crmsubjectmaps.get(crmid_str);
          //System.out.println("prjid"+crmid);
          //System.out.println("subject size"+subjects.size());
          Expense total_exp= BudgetHandler.getExpenseRecursion("1900-01-01","2100-01-01",0,0,0,0,customerid,0);
          Expense total_exp1=BudgetHandler.getExpenseRecursion("1900-01-01","2100-01-01",0,0,0,0,customerid,requestid);
          double crmcountexpense =total_exp.getRealExpense()+total_exp.getPendingExpense();
          String crmcountexpensestr = "0" ;
          if( crmcountexpense != 0) crmcountexpensestr ="" + crmcountexpense ;
          %>
        <TR class="Title">
    	  <TH colSpan=4 height=8></TH>
        </TR>
	    <TR class="Title">
    	  <TH colSpan=4>CRM：<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid_str),user.getLanguage())%></TH>
        </TR>
        <tr class=datalight >
            <td><b>CRM<%=SystemEnv.getHtmlLabelName(16302,user.getLanguage())%>)</b></td>
            <td colspan=3><%=crmcountexpensestr%></td>
        </tr>
        <%
          for( Iterator i=subjects.iterator() ;i.hasNext(); ) {
                SubjectPeriod sp=(SubjectPeriod)i.next();
                String tempfeetypeid =""+sp.getSubject() ;
                String tempfeetypename = BudgetfeeTypeComInfo.getBudgetfeeTypename(tempfeetypeid) ;
                currentperiod = ""+sp.getPeriodlist() ;
                BudgetYear by=BudgetHandler.getBudgetYear(sp.getStartdate());
				if(by == null){continue;}
                Expense res_cur_exp= BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),3,creater,sp.getSubject(),0,customerid,0);
                Expense res_cur_exp1=BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),3,creater,sp.getSubject(),0,customerid,requestid);

                Expense res_before_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),3,creater,sp.getSubject(),0,customerid,0);
                Expense res_before_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),3,creater,sp.getSubject(),0,customerid,requestid);

                Expense res_year_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),3,creater,sp.getSubject(),0,customerid,0);
                Expense res_year_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),3,creater,sp.getSubject(),0,customerid,requestid);

                Expense dep_cur_exp= BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),2,Util.getIntValue(deptid),sp.getSubject(),0,customerid,0);
                Expense dep_cur_exp1=BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),2,Util.getIntValue(deptid),sp.getSubject(),0,customerid,requestid);

                Expense dep_before_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),2,Util.getIntValue(deptid),sp.getSubject(),0,customerid,0);
                Expense dep_before_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),2,Util.getIntValue(deptid),sp.getSubject(),0,customerid,requestid);

                Expense dep_year_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),2,Util.getIntValue(deptid),sp.getSubject(),0,customerid,0);
                Expense dep_year_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),2,Util.getIntValue(deptid),sp.getSubject(),0,customerid,requestid);

                Expense all_cur_exp= BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),0,0,sp.getSubject(),0,customerid,0);
                Expense all_cur_exp1=BudgetHandler.getExpenseRecursion(sp.getStartdate(),sp.getEnddate(),0,0,sp.getSubject(),0,customerid,requestid);

                Expense all_before_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),0,0,sp.getSubject(),0,customerid,0);
                Expense all_before_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),sp.getEnddate(),0,0,sp.getSubject(),0,customerid,requestid);

                Expense all_year_exp= BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),0,0,sp.getSubject(),0,customerid,0);
                Expense all_year_exp1=BudgetHandler.getExpenseRecursion(by.getStartdate(),by.getEnddate(),0,0,sp.getSubject(),0,customerid,requestid);



                double crm_res_currentbudget = BudgetHandler.getBudget(3,creater,sp.getPeriod(),sp.getPeriodlist(),sp.getSubject(),0,customerid);
                double crm_dep_currentbudget=BudgetHandler.getBudget(2,Util.getIntValue(deptid),sp.getPeriod(),sp.getPeriodlist(),sp.getSubject(),0,customerid);
                double crm_all_currentbudget=BudgetHandler.getBudget(0,0,sp.getPeriod(),sp.getPeriodlist(),sp.getSubject(),0,customerid);
                double crm_res_beforebudget = 0 ;
                double crm_dep_beforebudget = 0 ;
                double crm_all_beforebudget = 0 ;
                for(int p=1;p<=sp.getPeriodlist();p++){
                  crm_res_beforebudget+= BudgetHandler.getBudget(3,creater,sp.getPeriod(),p,sp.getSubject(),0,customerid);
                  crm_dep_beforebudget+= BudgetHandler.getBudget(2,Util.getIntValue(deptid),sp.getPeriod(),p,sp.getSubject(),0,customerid);
                  crm_all_beforebudget+= BudgetHandler.getBudget(0,0,sp.getPeriod(),p,sp.getSubject(),0,customerid);
                }
                double crm_res_yearbudget = 0 ;
                double crm_dep_yearbudget = 0 ;
                double crm_all_yearbudget = 0 ;
                int lastperiodlist=0;
                switch(sp.getType()){
                    case 1:
                        lastperiodlist =12;
                        break;
                    case 2:
                        lastperiodlist=4;
                        break;
                    case 3:
                        lastperiodlist=2;
                        break;
                   case 4:
                       lastperiodlist=1;
                       break;

                }
                //System.out.println("lastperiodlist"+lastperiodlist);
                for(int p=1;p<=lastperiodlist;p++){
                  crm_res_yearbudget+= BudgetHandler.getBudget(3,creater,sp.getPeriod(),p,sp.getSubject(),0,customerid);
                  crm_dep_yearbudget+= BudgetHandler.getBudget(2,Util.getIntValue(deptid),sp.getPeriod(),p,sp.getSubject(),0,customerid);
                  crm_all_yearbudget+= BudgetHandler.getBudget(0,0,sp.getPeriod(),p,sp.getSubject(),0,customerid);
                }
                double crm_res_currentexpense = res_cur_exp.getRealExpense()+res_cur_exp.getPendingExpense();
                double crm_res_beforeexpense = res_before_exp.getRealExpense()+res_before_exp.getPendingExpense();
                double crm_res_yearexpense = res_year_exp.getRealExpense()+res_year_exp.getPendingExpense();
                double crm_dep_currentexpense = dep_cur_exp.getRealExpense()+dep_cur_exp.getPendingExpense();
                double crm_dep_beforeexpense = dep_before_exp.getRealExpense()+dep_before_exp.getPendingExpense();
                double crm_dep_yearexpense = dep_year_exp.getRealExpense()+dep_year_exp.getPendingExpense();
                double crm_all_currentexpense = all_cur_exp.getRealExpense()+all_cur_exp.getPendingExpense();
                double crm_all_beforeexpense = all_before_exp.getRealExpense()+all_before_exp.getPendingExpense();
                double crm_all_yearexpense = all_year_exp.getRealExpense()+all_year_exp.getPendingExpense();

            String crm_res_currentbudgetstr = "0" ;
		    String crm_dep_currentbudgetstr = "0" ;
		    String crm_all_currentbudgetstr = "0" ;
		    String crm_res_beforebudgetstr = "0" ;
		    String crm_dep_beforebudgetstr = "0" ;
		    String crm_all_beforebudgetstr = "0" ;
		    String crm_res_yearbudgetstr = "0" ;
		    String crm_dep_yearbudgetstr = "0" ;
		    String crm_all_yearbudgetstr = "0" ;
		    String crmcountbudgetstr = "0" ;

		    String crm_res_currentexpensestr = "0" ;
		    String crm_dep_currentexpensestr = "0" ;
		    String crm_all_currentexpensestr = "0" ;
		    String crm_res_beforeexpensestr = "0;" ;
		    String crm_dep_beforeexpensestr = "0" ;
		    String crm_all_beforeexpensestr = "0" ;
		    String crm_res_yearexpensestr = "0" ;
		    String crm_dep_yearexpensestr = "0" ;
		    String crm_all_yearexpensestr = "0" ;

            //end



            //double crmcountbudget = fem.getProjectcountbudget() ;





            if( crm_res_currentbudget != 0 ) crm_res_currentbudgetstr = "" + crm_res_currentbudget ;
            if( crm_dep_currentbudget != 0 ) crm_dep_currentbudgetstr = "" + crm_dep_currentbudget ;
            if( crm_all_currentbudget != 0 ) crm_all_currentbudgetstr = "" + crm_all_currentbudget ;
            if( crm_res_beforebudget != 0) crm_res_beforebudgetstr ="" + crm_res_beforebudget ;
            if( crm_dep_beforebudget != 0 ) crm_dep_beforebudgetstr = "" + crm_dep_beforebudget ;
            if( crm_all_beforebudget != 0 ) crm_all_beforebudgetstr = "" + crm_all_beforebudget ;
            if( crm_res_yearbudget != 0 ) crm_res_yearbudgetstr = "" + crm_res_yearbudget ;
            if( crm_dep_yearbudget != 0 ) crm_dep_yearbudgetstr = "" + crm_dep_yearbudget ;
            if( crm_all_yearbudget != 0 ) crm_all_yearbudgetstr = "" + crm_all_yearbudget ;
           // if( crmcountbudget != 0) crmcountbudgetstr ="" + crmcountbudget ;

            if( crm_res_currentexpense != 0 ) crm_res_currentexpensestr = "" + crm_res_currentexpense ;
            if( crm_dep_currentexpense != 0 ) crm_dep_currentexpensestr = "" + crm_dep_currentexpense ;
            if( crm_all_currentexpense != 0 ) crm_all_currentexpensestr = "" + crm_all_currentexpense ;
            if( crm_res_beforeexpense != 0) crm_res_beforeexpensestr ="" + crm_res_beforeexpense ;
            if( crm_dep_beforeexpense != 0 ) crm_dep_beforeexpensestr = "" + crm_dep_beforeexpense ;
            if( crm_all_beforeexpense != 0 ) crm_all_beforeexpensestr = "" + crm_all_beforeexpense ;
            if( crm_res_yearexpense != 0 ) crm_res_yearexpensestr = "" + crm_res_yearexpense ;
            if( crm_dep_yearexpense != 0 ) crm_dep_yearexpensestr = "" + crm_dep_yearexpense ;
            if( crm_all_yearexpense != 0 ) crm_all_yearexpensestr = "" + crm_all_yearexpense ;

        %>
                <tr class=header >
            <th class="Title"><%=tempfeetypename%></th>
            <th><%=SystemEnv.getHtmlLabelName(16291,user.getLanguage())%></th>
            <th>1~<%=currentperiod%><%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16303,user.getLanguage())%></td>
            <td><%=Util.round(crm_res_currentbudgetstr,2)%></td>
            <td><%=Util.round(crm_res_beforebudgetstr,2)%></td>
            <td><%=Util.round(crm_res_yearbudgetstr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16304,user.getLanguage())%></td>
            <td><%=Util.round(crm_res_currentexpensestr,2)%></td>
            <td><%=Util.round(crm_res_beforeexpensestr,2)%></td>
            <td><%=Util.round(crm_res_yearexpensestr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(crm_res_currentexpense>crm_res_currentbudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(crm_res_beforeexpense>crm_res_beforebudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(crm_res_yearexpense>crm_res_yearbudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16305,user.getLanguage())%></td>
            <td><%=Util.round(crm_dep_currentbudgetstr,2)%></td>
            <td><%=Util.round(crm_dep_beforebudgetstr,2)%></td>
            <td><%=Util.round(crm_dep_yearbudgetstr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16306,user.getLanguage())%></td>
            <td><%=Util.round(crm_dep_currentexpensestr,2)%></td>
            <td><%=Util.round(crm_dep_beforeexpensestr,2)%></td>
            <td><%=Util.round(crm_dep_yearexpensestr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(crm_dep_currentexpense>crm_dep_currentbudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(crm_dep_beforeexpense>crm_dep_beforebudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(crm_dep_yearexpense>crm_dep_yearbudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16307,user.getLanguage())%></td>
            <td><%=Util.round(crm_all_currentbudgetstr,2)%></td>
            <td><%=Util.round(crm_all_beforebudgetstr,2)%></td>
            <td><%=Util.round(crm_all_yearbudgetstr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16308,user.getLanguage())%></td>
            <td><%=Util.round(crm_all_currentexpensestr,2)%></td>
            <td><%=Util.round(crm_all_beforeexpensestr,2)%></td>
            <td><%=Util.round(crm_all_yearexpensestr,2)%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(crm_all_currentexpense>crm_all_currentbudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(crm_all_beforeexpense>crm_all_beforebudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(crm_all_yearexpense>crm_all_yearbudget) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <% }  }  %>
      </table>
</div>
<script type="text/javascript">
function dspfna(objval) {
	if (objval == 1) {
		jQuery(alldetail)[0].style.display="";
		jQuery(distd)[0].innerHTML = "<a href='#' onclick='dspfna(0);'><%=SystemEnv.getHtmlLabelName(16309,user.getLanguage())%></a>";
	} else {
		jQuery(alldetail)[0].style.display="none";
		jQuery(distd)[0].innerHTML = "<a href='#this' onclick='dspfna(1);'><%=SystemEnv.getHtmlLabelName(16285,user.getLanguage())%></a>";
	}
}

function onChangetype(objval) {
	if (objval == 1) {
		jQuery(odiv_1)[0].style.display="";
		jQuery(odiv_2)[0].style.display="none";
		jQuery(odiv_3)[0].style.display="none";
		jQuery(odiv_4)[0].style.display="none";
	}
	if (objval == 2) {
		jQuery(odiv_1)[0].style.display="none";
		jQuery(odiv_2)[0].style.display="";
		jQuery(odiv_3)[0].style.display="none";
		jQuery(odiv_4)[0].style.display="none";
	}
	if (objval == 3) {
		jQuery(odiv_1)[0].style.display="none";
		jQuery(odiv_2)[0].style.display="none";
		jQuery(odiv_3)[0].style.display="";
		jQuery(odiv_4)[0].style.display="none";
	}
	if (objval == 4) {
		jQuery(odiv_1)[0].style.display="none";
		jQuery(odiv_2)[0].style.display="none";
		jQuery(odiv_3)[0].style.display="none";
		jQuery(odiv_4)[0].style.display="";
	}
}
</script>
