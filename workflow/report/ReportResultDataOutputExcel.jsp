
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
request.setCharacterEncoding("UTF-8");
%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.*,java.math.BigDecimal" %>
<%@ page import="weaver.workflow.report.ReportCompositorOrderBean" %><!--ReportCompositorOrderBean is added by xwj for td2099 on 20050608-->
<%@ page import="weaver.workflow.report.ReportCompositorListBean" %><!--ReportCompositorListBean is added by xwj for td2451 on 20051114-->
 <%@ page import="weaver.workflow.report.ReportUtilComparator" %>
 <%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
 <%@page import="weaver.workflow.workflow.WorkflowVersion"%>
 <%@ page import="weaver.fna.budget.BudgetHandler"%>
<!--added by xwj for td2974 20051026-->
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj for td2974 20051026-->
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj for td2974 20051026-->
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj for td2974 20051026-->
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkFlowTransMethod" class="weaver.general.WorkFlowTransMethod" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page"/>


<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page"/>
<jsp:useBean id="ExpensefeeTypeComInfo" class="weaver.fna.maintenance.ExpensefeeTypeComInfo" scope="page"/>
<jsp:useBean id="MDCompanyNameInfo" class="weaver.workflow.report.ReportShare" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<jsp:useBean id="resourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="WorkflowJspBean" class="weaver.workflow.request.WorkflowJspBean" scope="page"/>	
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<%!
    private String formatData(String inData){
        if(inData==null||inData.equals("")){
            return "";
        }
        try{
            return new BigDecimal(  Util.null2String(inData).equals("")?"0":Util.null2String(inData) ).toString();
        }catch(Exception e){
            return inData;
        }
    }
    private String formatDataTotal(String inData){
        if(inData==null||inData.equals("")){
            return "";
        }
        try{
            return new BigDecimal(  Util.null2String(inData).equals("")?"0":Util.null2String(inData) ).setScale(4,BigDecimal.ROUND_HALF_UP).toString();
        }catch(Exception e){
            return inData;
        }
    }

%>


<%
//报表id
String reportid = Util.null2String(request.getParameter("reportid")) ;

if(reportid.equals("")){
	reportid="0";
}

//模板id
int mouldId = Util.getIntValue(request.getParameter("mouldId"),0);

//是否根据模板id查询  1:根据模板查询  其他：不根据模板查询
String searchByMould = Util.null2String(request.getParameter("searchByMould")) ;

//modify by xhheng @20050126 for TD 1614
int sharelevel_1 = -1 ;    //标记原有共享范围"同部门"、"同分部"、"总部"
int sharelevel_2 = -1 ;    //标记新共享范围"同部门下级部门"
int sharelevel_3 = -1;     //标记新共享范围"多部门"
String mutidepartmentids="";
RecordSet.executeSql("select sharelevel,mutidepartmentid from WorkflowReportShareDetail where userid="+user.getUID()+" and usertype=1 and reportid="+reportid+" order by sharelevel");
while(RecordSet.next()) {
    int sharelevel_tmp = Util.getIntValue(RecordSet.getString("sharelevel"),0) ;
    if(sharelevel_tmp==9){
        sharelevel_3=sharelevel_tmp;
        mutidepartmentids=Util.null2String(RecordSet.getString("mutidepartmentid"));
        if(mutidepartmentids.length()>1) mutidepartmentids=mutidepartmentids.substring(1,mutidepartmentids.length());
    }else{
        if(sharelevel_tmp==3){
            sharelevel_2=sharelevel_tmp;
        }else{
            sharelevel_1=sharelevel_tmp;
        }
    }
}
//System.out.println(sharelevel_1+"|"+sharelevel_2+"|"+sharelevel_3);
if(sharelevel_1 == -1 && sharelevel_2 == -1 && sharelevel_3==-1) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String hasrightdeps = "" ;
if(sharelevel_1 == 0) {
    hasrightdeps = ""+ new Integer(user.getUserDepartment()).toString();
}
if(sharelevel_1 == 1) {
    while(DepartmentComInfo.next()){
        String cursubcompanyid = DepartmentComInfo.getSubcompanyid1();
        if(!(""+user.getUserSubCompany1()).equals(cursubcompanyid)) continue;
        String tempdepartment = ""+DepartmentComInfo.getDepartmentid() ;
        if(hasrightdeps.equals("")) hasrightdeps = tempdepartment ;
        else hasrightdeps += ","+ tempdepartment ;
    }
}
//add by xhheng @20050126 for TD 1614
if(sharelevel_2 == 3) {
    String curdepartmentid=new Integer(user.getUserDepartment()).toString();
    List childdeptlist= MDCompanyNameInfo.GetChildDepartment(curdepartmentid);
    for(int i=0;i<childdeptlist.size();i++){
        String tempdept=(String)childdeptlist.get(i);
        if(Util.getIntValue(tempdept)>0){
        if(hasrightdeps.equals("")) hasrightdeps = tempdept ;
        else {
            String tempdeps=","+hasrightdeps;
            if(tempdeps.indexOf(","+tempdept+",")<0) hasrightdeps+=","+tempdept;
        }
        }
    }
    //hasrightdeps = hasrightdeps.substring(0,hasrightdeps.length()-1);
}
if(sharelevel_3==9){
    if(hasrightdeps.equals("")) hasrightdeps = mutidepartmentids;
    else hasrightdeps+=","+mutidepartmentids;
}
//System.out.println(hasrightdeps);
//String[] checkcons = request.getParameterValues("check_con");//报表条件
String[] checkcons =null;//报表条件
String[] isShowArray = null;//报表列
List isShowList=new ArrayList();//显示的列的字段id

//String formid = Util.null2String(request.getParameter("formid")) ;
//String isbill = Util.null2String(request.getParameter("isbill")) ;
String formid="";
String isbill="";
String reportwfid = "";
rs2.executeSql("select reportname,formId,isBill,reportwfid from workflow_report where id = " + reportid);
String titlename1 = "";
if(rs2.next()){
    titlename1 = rs2.getString("reportname") ;
    formid = rs2.getString("formId") ;
    isbill = rs2.getString("isBill") ;
    reportwfid = rs2.getString("reportwfid") ;
}
boolean isNewBill = false;
if(isbill.equals("1")){
	rs2.executeSql("select id, tablename from workflow_bill where id="+formid);
	if(rs2.next()){
		int tempid = rs2.getInt("id");
		String temptablename = rs2.getString("tablename");
		if(temptablename.equals("formtable_main_"+tempid*(-1)) || temptablename.startsWith("uf_")) isNewBill=true;
	}
}


String sql = "" ;
List fieldids = new ArrayList() ;
List fields = new ArrayList() ;
List fieldnames = new ArrayList() ;

List htmltypes = new ArrayList() ;
List types = new ArrayList() ;
List isstats = new ArrayList() ;
List statvalues = new ArrayList() ;
List tempstatvalues = new ArrayList() ;
List isdetails = new ArrayList() ;//add by wang jinyong
String requestid = ""; //add by wang jinyong
boolean isnew = true; //add by wang jinyong
List isdborders = new ArrayList() ;

ArrayList compositorOrderList = new ArrayList() ;//addsed by xwj for td2099 on 2005-06-08
ArrayList compositorColList = new ArrayList() ;//addsed by xwj for td2451 on 2005-11-14
ArrayList compositorColList2 = new ArrayList() ;//addsed by xwj for td2451 on 2005-11-14

List ids = new ArrayList();
List isMains = new ArrayList();
List isShows = new ArrayList();
List isCheckConds = new ArrayList();
List colnames = new ArrayList();
List htmlTypes = new ArrayList();
List typeTemps = new ArrayList();
List opts = new ArrayList();
List values = new ArrayList();
List names = new ArrayList();
List opt1s = new ArrayList();
List value1s = new ArrayList();


if(searchByMould!=null&&searchByMould.equals("1")){//根据模板id查询时

    RecordSet.execute("select fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond from WorkflowRptCondMouldDetail where mouldId="+mouldId) ;

    while(RecordSet.next()){
	    ids.add(Util.null2String(RecordSet.getString("fieldId")));
	    isMains.add(Util.null2String(RecordSet.getString("isMain")));
	    isShows.add(Util.null2String(RecordSet.getString("isShow")));
	    isCheckConds.add(Util.null2String(RecordSet.getString("isCheckCond")));
	    colnames.add(Util.null2String(RecordSet.getString("colName")));
	    htmlTypes.add(Util.null2String(RecordSet.getString("htmlType")));
	    typeTemps.add(Util.null2String(RecordSet.getString("type")));
	    opts.add(Util.null2String(RecordSet.getString("optionFirst")));
	    values.add(Util.null2String(RecordSet.getString("valueFirst")));
	    names.add(Util.null2String(RecordSet.getString("nameFirst")));
	    opt1s.add(Util.null2String(RecordSet.getString("optionSecond")));
	    value1s.add(Util.null2String(RecordSet.getString("valueSecond")));
    }

    List isCheckCondList=new ArrayList();

    String fieldId="";
	String isShow="";
	String isCheckCond="";

	for(int i=0;i<ids.size();i++){
		fieldId=(String)ids.get(i);
		isShow=(String)isShows.get(i);
		isCheckCond=(String)isCheckConds.get(i);

        if(isShow!=null&&isShow.equals("1")){
			isShowList.add(fieldId);
		}

        if(isCheckCond!=null&&isCheckCond.equals("1")){
			isCheckCondList.add(fieldId);
		}


	}

    int isCheckCondListCount = isCheckCondList.size();
    checkcons = new String[isCheckCondListCount];
    for (int i = 0; i < isCheckCondListCount; i++) {
        checkcons[i] = (String) isCheckCondList.get(i);
    }


}else{

	checkcons = request.getParameterValues("check_con");//报表条件
	isShowArray = request.getParameterValues("isShow");//报表列

    if(isShowArray!=null){
        for(int i=0;i<isShowArray.length;i++){
		    isShowList.add(isShowArray[i]);
	    }
	}

    String requestNameIsShow = request.getParameter("requestNameIsShow");
    String requestLevelIsShow = request.getParameter("requestLevelIsShow");
    
    /**2014add**/
    String createmanIsShow = request.getParameter("createmanIsShow");
    String createdateIsShow = request.getParameter("createdateIsShow");
    String workflowtoIsShow = request.getParameter("workflowtoIsShow");
    String currentnodeIsShow = request.getParameter("currentnodeIsShow");
    String nooperatorIsShow = request.getParameter("nooperatorIsShow");
    String requestStatusIsShow = request.getParameter("requestStatusIsShow");
    String filingdateIsShow = request.getParameter("filingdateIsShow");

    if(requestNameIsShow!=null&&requestNameIsShow.equals("1")){
		isShowList.add("-1");
	}
	if(requestLevelIsShow!=null&&requestLevelIsShow.equals("1")){
		isShowList.add("-2");
	}
	//----add------
	if(createmanIsShow!=null&&createmanIsShow.equals("1")){
		isShowList.add("-10");
	}
	if(createdateIsShow!=null&&createdateIsShow.equals("1")){
		isShowList.add("-11");
	}
	if(workflowtoIsShow!=null&&workflowtoIsShow.equals("1")){
		isShowList.add("-12");
	}
	if(currentnodeIsShow!=null&&currentnodeIsShow.equals("1")){
		isShowList.add("-13");
	}
	if(nooperatorIsShow!=null&&nooperatorIsShow.equals("1")){
		isShowList.add("-14");
	}
	if(requestStatusIsShow!=null&&requestStatusIsShow.equals("1")){
		isShowList.add("-15");
	}
	if(filingdateIsShow!=null&&filingdateIsShow.equals("1")){
		isShowList.add("-16");
	}
}
//传递过来的LIST值
String showListStr = Util.StringReplace(Util.StringReplace(Util.StringReplace(Util.null2String(request.getParameter("isShowList")),"[",","),"]",",")," ","");
isShowList = Util.TokenizerString(showListStr, ",");

String sqlrightwhere = "";
String temOwner = "";


//System.out.println("sqlwhere = " + sqlwhere);
String tablename = "workflow_form" ;
String detailtablename = "" ;
String detailkeyfield = "" ;
int maincount = 0 ;
int detailcount = 0 ;
int ordercount = 0 ;
int statcount = 0 ;
String fieldname = "" ;
String orderbystr = "" ;
ReportCompositorOrderBean reportCompositorOrderBean = new ReportCompositorOrderBean(); //added by xwj for td2099 on 2005-06-08
ReportCompositorListBean rcListBean = new ReportCompositorListBean();//added by xwj for td2451 20051114
ReportCompositorListBean rcColListBean = new ReportCompositorListBean();//added by xwj for td2451 20051114

/*-----  xwj for td2974 20051026   B E G I N  ---*/
 //deleted xwj for td2451 20051114
if(isbill.equals("0")) {


   //只有显示请求说明时才执行下面的操作
  if(isShowList.indexOf("-1")!=-1){     
   
    //deleted xwj for td2451 20051114
    rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -1");
	
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("requestname");//xwj for td2451 20051114
	    rcListBean.setFieldId("-1");//xwj for td2451 20051114
        rcListBean.setHtmlType("-1");
	    rcListBean.setTypes("-1");
	    rcListBean.setIsDetail("0");

	    rcListBean.setColName(SystemEnv.getHtmlLabelName(1334,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("requestname");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
            reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
            reportCompositorOrderBean.setFieldName("requestname");
            reportCompositorOrderBean.setSqlFlag("c");
            compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
  }
   //只有显示紧急程度时才执行下面的操作
  if(isShowList.indexOf("-2")!=-1){   	
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -2");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("requestlevel");//xwj for td2451 20051114
	    rcListBean.setFieldId("-2");//xwj for td2451 20051114
        rcListBean.setHtmlType("-2");
	    rcListBean.setTypes("-2");
	    rcListBean.setIsDetail("0");
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(15534,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("requestlevel");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
            reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
            reportCompositorOrderBean.setFieldName("requestlevel");
            reportCompositorOrderBean.setSqlFlag("c");
            compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
  }
   
  
  //创建人
 if(isShowList.indexOf("-10")!=-1){   
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -10");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("creater");//xwj for td2451 20051114
	    rcListBean.setFieldId("-10");//xwj for td2451 20051114
       rcListBean.setHtmlType("-10");
	    rcListBean.setTypes("-10");
	    rcListBean.setIsDetail("0");
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(882,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("creater");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
           reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
           reportCompositorOrderBean.setFieldName("creater");
           reportCompositorOrderBean.setSqlFlag("c");
           compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
 }
  
 //
if(isShowList.indexOf("-11")!=-1){   
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -11");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("createdate");//xwj for td2451 20051114
	    rcListBean.setFieldId("-11");//xwj for td2451 20051114
      rcListBean.setHtmlType("-11");
	    rcListBean.setTypes("-11");
	    rcListBean.setIsDetail("0");
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(722,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("createdate");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("createdate");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
}
//
if(isShowList.indexOf("-12")!=-1){   
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -12");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("workflowid");//xwj for td2451 20051114
	    rcListBean.setFieldId("-12");//xwj for td2451 20051114
     rcListBean.setHtmlType("-12");
	    rcListBean.setTypes("-12");
	    rcListBean.setIsDetail("0");
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(26361,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("workflowid");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
         reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
         reportCompositorOrderBean.setFieldName("workflowid");
         reportCompositorOrderBean.setSqlFlag("c");
         compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
}
//
if(isShowList.indexOf("-13")!=-1){   
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -13");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("currentnodeid");//xwj for td2451 20051114
	    rcListBean.setFieldId("-13");//xwj for td2451 20051114
     rcListBean.setHtmlType("-13");
	    rcListBean.setTypes("-13");
	    rcListBean.setIsDetail("0");
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(18564,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("currentnodeid");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
         reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
         reportCompositorOrderBean.setFieldName("currentnodeid");
         reportCompositorOrderBean.setSqlFlag("c");
         compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
}

if(isShowList.indexOf("-14")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -14");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("requestid");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-14");//xwj for td2451 20051114
      rcListBean.setHtmlType("-14");
 	    rcListBean.setTypes("-14");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(16354,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("requestid");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("requestid");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }
//-15
 
 if(isShowList.indexOf("-15")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -15");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("currentnodetype");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-15");//xwj for td2451 20051114
      rcListBean.setHtmlType("-15");
 	    rcListBean.setTypes("-15");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(31485,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("currentnodetype");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("currentnodetype");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }
//-16
 
 if(isShowList.indexOf("-16")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -16");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("lastoperatedate");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-16");//xwj for td2451 20051114
      rcListBean.setHtmlType("-16");
 	    rcListBean.setTypes("-16");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(3000,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("lastoperatedate");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("lastoperatedate");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }
   
   
	/*-----  xwj for td2974 20051026   E N D ----*/
    
	//modify by xhheng @ 20041206 for TDID 1426 start
	
	// this sql id modified by xwj for td2099 on 2005-06-08 
 sql = " (select a.fieldname as col1, (select distinct c.fieldlable  from  workflow_fieldlable c  where  c.fieldid = b.fieldid and e.formid = c.formid and c.langurageid = "+user.getLanguage()+") as col2, a.fieldhtmltype as col3, a.type as col4, b.isstat as col5, b.dborder as col6, a.id as col7, b.dsporder as col8, f.isdetail as col9,  b.dbordertype as col10, b.compositororder as col11 ,b.fieldwidth AS col12 from workflow_formdict a, Workflow_ReportDspField b ,  Workflow_Report e , workflow_formfield f " +
          " where a.id=f.fieldid   and e.formid=f.formid and b.fieldid = a.id  and e.id = b.reportid and b.reportid = " + reportid + 
          " and (f.isdetail!='1' or f.isdetail is null) union "+
          " select a.fieldname as col1,(select distinct c.fieldlable  from  workflow_fieldlable c  where  c.fieldid = b.fieldid and e.formid = c.formid and c.langurageid = "+user.getLanguage()+") as col2, a.fieldhtmltype as col3, a.type as col4, b.isstat as col5, b.dborder as col6, a.id as col7, b.dsporder as col8, f.isdetail as col9,  b.dbordertype as col10, b.compositororder as col11 ,b.fieldwidth AS col12 from workflow_formdictdetail a, Workflow_ReportDspField b , Workflow_Report e , workflow_formfield f " +
          " where a.id=f.fieldid  and f.formid=e.formid  and b.fieldid = a.id  and e.id = b.reportid and b.reportid = " + reportid +"   and (f.isdetail='1' )) order by col8" ;
	
     //out.print(sql);
	//by ben 2006-03-27 for td3595
	//out.print(sql) ;
	//modify by xhheng @ 20041206 for TDID 1426 end
    RecordSet.execute(sql) ;
    //out.println("sql2 = " + sql);
    String owner = "";
    while(RecordSet.next()) {
		if(isShowList.indexOf(Util.null2String(RecordSet.getString(7)))==-1){
			continue;
		}

        //modify by xhheng @ 20041210 for TDID 1426 end
        if(RecordSet.getString("col9").equals("1")){
            owner = "d";
            detailcount++;
           
        }else{
            owner = "a";
        }
        /*-----  xwj for td2974 20051026   B E G I N  ---*/
        
        rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
        rcListBean.setCompositorList(RecordSet.getDouble(8));//xwj for td2451 20051114
	      rcListBean.setSqlFlag(owner);//xwj for td2451 20051114
	      rcListBean.setFieldName(Util.null2String(RecordSet.getString(1)));//xwj for td2451 20051114
	      rcListBean.setFieldId(Util.null2String(RecordSet.getString(7)));//xwj for td2451 20051114
	      rcListBean.setColName(Util.toScreen(RecordSet.getString(2),user.getLanguage()));//xwj for td2451 20051114
	      rcListBean.setHtmlType(Util.null2String(RecordSet.getString(3)));
	      //----2014add-----------------
	      rcListBean.setFieldWidth(Util.null2String(RecordSet.getString(12)));
	      rcListBean.setTypes(Util.null2String(RecordSet.getString(4)));
	      rcListBean.setIsDetail(Util.null2String(RecordSet.getString(9)));

          rcListBean.setDbOrder(Util.null2String(RecordSet.getString(6)));
	      rcListBean.setIsstat(Util.null2String(RecordSet.getString(5)));
          compositorColList.add(rcListBean);//xwj for td2451 20051114
        fields.add(Util.null2String(RecordSet.getString(1))) ;
        /*-----  xwj for td2974 20051026   E N D  ---*/
        
        // deleted by xwj for td2974 20051026
        //add by wang jinyong end

        if(Util.null2String(RecordSet.getString(6)).equals("1")) {
            /* ---deleted and added by xwj for td2099 on 2005-06-08      B E G I N ---*/
            //orderbystr = " order by " + Util.null2String(RecordSet.getString(1)) ;  
            reportCompositorOrderBean = new ReportCompositorOrderBean();
            reportCompositorOrderBean.setCompositorOrder(RecordSet.getInt(11));
            reportCompositorOrderBean.setOrderType(Util.null2String(RecordSet.getString(10)));
            reportCompositorOrderBean.setFieldName(Util.null2String(RecordSet.getString(1)));
            reportCompositorOrderBean.setSqlFlag(owner);
            compositorOrderList.add(reportCompositorOrderBean);
             /* ---deleted and added by xwj for td2099 on 2005-06-08      E N D ---*/
           // deleted by xwj for td2974 20051026
        }
        //deleted by xwj for td2974 20051026
        //delete by xhheng @20050127 for TD 1621
    }
    
     /*-----  xwj for td2974 20051026   B E G I N  ---*/
      
      /*-----  xwj for td2451 on 2005-11-14  B E G I N  ---*/
    compositorColList2 = ReportComInfo.getCompositorList(compositorColList); //xwj for td2451 on 2005-11-14
    for(int a = 0; a < compositorColList2.size(); a++){
    rcColListBean = (ReportCompositorListBean)compositorColList2.get(a);
    RecordSet.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = " +rcColListBean.getFieldId());
   // if(RecordSet.next())
    String  tempfieldid = rcColListBean.getFieldId();
    htmltypes.add(rcColListBean.getHtmlType());
    types.add(rcColListBean.getTypes());
    isdetails.add(rcColListBean.getIsDetail());
  //---2014add------------------------------
  //  fieldwidths.add(rcColListBean.getFieldWidth());
     if (Util.null2String(rcColListBean.getDbOrder()).equals("1"))
        {ordercount ++ ;
       isdborders.add("1") ;
        }
        else
       isdborders.add("") ;
    if (Util.null2String(rcColListBean.getIsstat()).equals("1"))
        { statcount ++ ;
          isstats.add("1") ;
        }
        else
        isstats.add("") ;
  
    statvalues.add("") ;
    tempstatvalues.add("") ;
     fieldids.add(tempfieldid);
    }//xwj for td2451 on 2005-11-14 
	  fieldname =  ReportComInfo.getCompositorListByStrs(compositorColList)+",c.requestid"; //xwj for td2451 on 2005-11-14
    orderbystr = ReportComInfo.getCompositorOrderByStrs(compositorOrderList); //added by xwj for td2099 on2005-06-08
    /*-----  xwj for td2974 20051026   E N D  ---*/

}
else {
  //deleted xwj for td2451 20051114
    /*-----  xwj for td2974 20051026   B E G I N  ---*/
//deleted xwj for td2451 20051114
   //只有显示请求说明时才执行下面的操作
  if(isShowList.indexOf("-1")!=-1){   
    rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -1");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("requestname");//xwj for td2451 20051114
	    rcListBean.setFieldId("-1");//xwj for td2451 20051114
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(1334,user.getLanguage()));//xwj for td2451 20051114
    	compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("requestname");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
            reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
            reportCompositorOrderBean.setFieldName("requestname");
            reportCompositorOrderBean.setSqlFlag("c");
            compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
  }

   //只有显示紧急程度时才执行下面的操作
  if(isShowList.indexOf("-2")!=-1){    
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -2");
	if(rs1.next()){
        rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("requestlevel");//xwj for td2451 20051114
	    rcListBean.setFieldId("-2");//xwj for td2451 20051114
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(15534,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("requestlevel");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
            reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
            reportCompositorOrderBean.setFieldName("requestlevel");
            reportCompositorOrderBean.setSqlFlag("c");
            compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
  }
   
  /**2014**/
  //创建人
 if(isShowList.indexOf("-10")!=-1){ 
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -10");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("creater");//xwj for td2451 20051114
	    rcListBean.setFieldId("-10");//xwj for td2451 20051114
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(882,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("creater");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
           reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
           reportCompositorOrderBean.setFieldName("creater");
           reportCompositorOrderBean.setSqlFlag("c");
           compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
 }
  
 //创建日期
if(isShowList.indexOf("-11")!=-1){ 
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -11");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("createdate");//xwj for td2451 20051114
	    rcListBean.setFieldId("-11");//xwj for td2451 20051114
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(722,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("createdate");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("createdate");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
}
 
//工作流
if(isShowList.indexOf("-12")!=-1){ 
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -12");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("workflowid");//xwj for td2451 20051114
	    rcListBean.setFieldId("-12");//xwj for td2451 20051114
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(26361,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("workflowid");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
         reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
         reportCompositorOrderBean.setFieldName("workflowid");
         reportCompositorOrderBean.setSqlFlag("c");
         compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
}

//当前节点
if(isShowList.indexOf("-13")!=-1){ 
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -13");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("currentnodeid");//xwj for td2451 20051114
	    rcListBean.setFieldId("-13");//xwj for td2451 20051114
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(18564,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("currentnodeid");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
         reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
         reportCompositorOrderBean.setFieldName("currentnodeid");
         reportCompositorOrderBean.setSqlFlag("c");
         compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
}

if(isShowList.indexOf("-14")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -14");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("requestid");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-14");//xwj for td2451 20051114
      rcListBean.setHtmlType("-14");
 	    rcListBean.setTypes("-14");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(16354,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("requestid");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("requestid");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }
//-15
 
 if(isShowList.indexOf("-15")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -15");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("currentnodetype");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-15");//xwj for td2451 20051114
      rcListBean.setHtmlType("-15");
 	    rcListBean.setTypes("-15");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(31485,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("currentnodetype");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("currentnodetype");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }
//-16
 
 if(isShowList.indexOf("-16")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -16");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("lastoperatedate");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-16");//xwj for td2451 20051114
      rcListBean.setHtmlType("-16");
 	    rcListBean.setTypes("-16");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(3000,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("lastoperatedate");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("lastoperatedate");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }
   
   
	/*-----  xwj for td2974 20051026   E N D ----*/
    
    /*-----  xwj for td2974 20051026   B E G I N  ---*/
    sql = " select a.fieldname , c.labelname, a.fieldhtmltype, a.type, b.isstat , a.viewtype , b.dborder , a.id , b.dbordertype , b.compositororder, b.dsporder, a.detailtable as detailtable from  workflow_billfield a, Workflow_ReportDspField b , HtmlLabelInfo c " +
          " where a.id = b.fieldid and a.fieldlabel = c.indexid and b.reportid = " + reportid +" and  c.languageid = " + user.getLanguage() + " order by b.dsporder " ;
    /*-----  xwj for td2974 20051026   end  ---*/
    //out.println(sql);
    RecordSet.execute(sql) ;
    while(RecordSet.next()) {

		if(isShowList.indexOf(Util.null2String(RecordSet.getString(8)))==-1){
			continue;
		}

        String viewtype = Util.null2String(RecordSet.getString(6)) ;
        if(viewtype.equals("1")) {
        	if(isNewBill) viewtype = Util.null2String(RecordSet.getString("detailtable")) ;
        	else
            viewtype ="d" ; // "b." --> "b"   xwj for td2131 on 2005-06-20
            detailcount ++ ;
        }
        else {
            viewtype ="a" ; // "a." --> "a"   xwj for td2131 on 2005-06-20
            maincount ++ ;
        }

        /*-----  xwj for td2974 20051026   B E G I N  ---*/
        rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
        rcListBean.setCompositorList(RecordSet.getDouble(11));//xwj for td2451 20051114
        rcListBean.setSqlFlag(viewtype);//xwj for td2451 20051114
        rcListBean.setFieldName(Util.null2String(RecordSet.getString(1)));//xwj for td2451 20051114
        rcListBean.setFieldId(Util.null2String(RecordSet.getString(8)));//xwj for td2451 20051114
        rcListBean.setColName(Util.toScreen(RecordSet.getString(2),user.getLanguage()));//xwj for td2451 20051114
	      compositorColList.add(rcListBean);//xwj for td2451 20051114
        fields.add(Util.null2String(RecordSet.getString(1))) ;
         /*-----  xwj for td2974 20051026   E N D  ---*/
        
         // deleted by xwj for td2974 20051026

        if(Util.null2String(RecordSet.getString(7)).equals("1")) {
            /* ---deleted and added by xwj for td2099 on 2005-06-08      B E G I N ---*/
            //orderbystr = " order by " + viewtype + Util.null2String(RecordSet.getString(1)) ;
            reportCompositorOrderBean = new ReportCompositorOrderBean();
            reportCompositorOrderBean.setCompositorOrder(RecordSet.getInt(10));
            reportCompositorOrderBean.setOrderType(Util.null2String(RecordSet.getString(9)));
            reportCompositorOrderBean.setFieldName(Util.null2String(RecordSet.getString(1)));
            reportCompositorOrderBean.setSqlFlag(viewtype);
            compositorOrderList.add(reportCompositorOrderBean);
             /* ---deleted and added by xwj for td2099 on 2005-06-08      E N D ---*/
             // deleted by xwj for td2974 20051026
        }
        // deleted by xwj for td2974 20051026
        //delete by xhheng @20050127 for TD 1621

    }
    /*-----  xwj for td2974 20051026  B E G I N  ---*/
    
     /*-----  xwj for td2451 on 2005-11-14  B E G I N  ---*/
    compositorColList2 = ReportComInfo.getCompositorList(compositorColList); //xwj for td2451 on 2005-11-14
    for(int a = 0; a < compositorColList2.size(); a++){
    rcColListBean = (ReportCompositorListBean)compositorColList2.get(a);
    RecordSet.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = " +rcColListBean.getFieldId());
    if(RecordSet.next()){
      /*-----  xwj for td2451 on 2005-11-14  E N D  ---*/
    
    String  tempfieldid = RecordSet.getString("fieldid");
    if("-1".equals(tempfieldid) || "-2".equals(tempfieldid) || "-10".equals(tempfieldid) || "-11".equals(tempfieldid) || "-12".equals(tempfieldid) || "-13".equals(tempfieldid) || "-14".equals(tempfieldid) || "-15".equals(tempfieldid) || "-16".equals(tempfieldid) || "-17".equals(tempfieldid)){
    htmltypes.add(tempfieldid);
    types.add(tempfieldid);
    isdetails.add("");
    }
    else{
    rs3.executeSql("select formid from workflow_report b where   b.id = "+ reportid);
    if(rs3.next()){
    rs2.executeSql("select * from workflow_billfield where id = " + tempfieldid + " and billid=" + rs3.getString("formid"));
    if(rs2.next()){
     htmltypes.add(Util.null2String(rs2.getString("fieldhtmltype")));
     types.add(Util.null2String(rs2.getString("type")));
     isdetails.add(Util.null2String(rs2.getString("viewtype")));
/* QC136988 明细表字段判断参数获取修改，系统表单明细字段无detailtable字段值导致问题
     String detailtabletmp = Util.null2String(rs2.getString("detailtable"));
     if(!"".equals(detailtabletmp)){
    	 isdetails.add("1");
     }else{
    	 isdetails.add("");
     }
	 */
    }
    }
    }
    fieldids.add(tempfieldid);
    if(Util.null2String(RecordSet.getString("isstat")).equals("1")) {
            statcount ++ ;
            isstats.add("1") ;
    }
    else{ 
      isstats.add("") ;
    }
    statvalues.add("") ;
    tempstatvalues.add("") ;
     if(Util.null2String(RecordSet.getString("dborder")).equals("1")) {
            ordercount ++ ;
            isdborders.add("1") ;
    }
    else{ 
      isdborders.add("") ;
    }
   }
    } //xwj for td2451 on 2005-11-14 
    fieldname =  ReportComInfo.getCompositorListByStrs(compositorColList)+",c.requestid"; //xwj for td2451 on 2005-11-14
    orderbystr = ReportComInfo.getCompositorOrderByStrs(compositorOrderList); //added by xwj for td2099 on2005-06-08
    /*-----  xwj for td2974 20051026   E N D  ---*/
    
    sql = " select tablename , detailtablename , detailkeyfield from workflow_bill where id = " + formid ;
    RecordSet.execute(sql) ;
    RecordSet.next() ;
    tablename = Util.null2String(RecordSet.getString(1)) ;
    detailtablename = Util.null2String(RecordSet.getString(2)) ;
    detailkeyfield = Util.null2String(RecordSet.getString(3)) ;
    if(isNewBill){//新表单
    	detailtablename = "";
    	RecordSet.executeSql("select tablename from workflow_billdetailtable where billid="+formid);
    	while(RecordSet.next()){
    		detailtablename += RecordSet.getString("tablename")+",";
    	}
    }
}
if (hasrightdeps.equals("")) hasrightdeps="-100";
String otherSqlWhere = "";
if(RecordSet.getDBType().equals("oracle"))
{
	otherSqlWhere += " and nvl(r.currentstatus,-1) = -1 ";
}
else
{
	otherSqlWhere += " and isnull(r.currentstatus,-1) = -1 ";
}
if(isbill.equals("0")) {
    //modify by xhheng @20050322 for Td 1625
    //modify by xhheng @20050127 for TD 1621
    if((sharelevel_1 <2 && sharelevel_1>-1) || (sharelevel_1<2 && (sharelevel_2 ==3 || sharelevel_3==9))) {
		if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
		{
			sql="SELECT "+fieldname+",a.requestid FROM" +
	        " Workflow_Report b INNER JOIN (select deleted,formid,workflowid,id,requestid ,creater,createdate,workflowid,currentnodeid,lastoperatedate,lastoperator,status,workflowid,requestname,requestlevel,currentnodetype,lastoperatedate from workflow_requestbase,workflow_base where (workflow_requestbase.deleted <> 1 or workflow_requestbase.deleted is null or workflow_requestbase.deleted='') and (workflow_base.isvalid='1' or workflow_base.isvalid='3') and workflow_requestbase.workflowid=workflow_base.id "+otherSqlWhere+")  c INNER JOIN hrmresource e INNER JOIN hrmdepartment f " + 
	        " ON e.departmentid=f.id ON c.creater=e.id  ON b.formid = c.formid   and '" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'||to_char(c.id)||',%'" +
	        " INNER JOIN workflow_form a ";
		}
		else
		{
		sql="SELECT "+fieldname+",a.requestid FROM" +
        " Workflow_Report b INNER JOIN (select deleted,formid,workflowid,id,requestid ,creater,createdate,workflowid,currentnodeid,lastoperatedate,lastoperator,status,workflowid,requestname,requestlevel,currentnodetype,lastoperatedate from workflow_requestbase,workflow_base where (workflow_requestbase.deleted <> 1 or workflow_requestbase.deleted is null or workflow_requestbase.deleted='') and (workflow_base.isvalid='1' or workflow_base.isvalid='3') and workflow_requestbase.workflowid=workflow_base.id "+otherSqlWhere+")  c INNER JOIN hrmresource e INNER JOIN hrmdepartment f " + 
        " ON e.departmentid=f.id ON c.creater=e.id  ON b.formid = c.formid   and '" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'+convert(varchar,c.id)+',%'" +
        " INNER JOIN workflow_form a ";
		}
     if(detailcount != 0 ){  
         sql+=  " LEFT JOIN workflow_formdetail d  ON a.requestid = d.requestid " ;
         String tempGroupIds = ",";
         ArrayList fieldnamelist = Util.TokenizerString(fieldname,",");
         for(int tempindex=0;tempindex<fieldnamelist.size();tempindex++){
             String tempfieldname = (String)fieldnamelist.get(tempindex);
             if(tempfieldname.indexOf("d.")==0){
                 tempfieldname = tempfieldname.substring(2);
                 RecordSet.executeSql("select groupId from workflow_formfield where formid="+formid+" and fieldid=(select id from workflow_formdictdetail where fieldname='"+tempfieldname+"')");
                 if(RecordSet.next()){
                     String tempGroupId = RecordSet.getString("groupId");
                     if(tempGroupIds.indexOf(","+tempGroupId+",")<0)
                         tempGroupIds += tempGroupId+",";
                 }
             }
         }
         if(!tempGroupIds.equals(",")){//在多明细查询时，查询需要显示的明细。
             String tempSql = "(";
             ArrayList tempGroupIdslist = Util.TokenizerString(tempGroupIds,",");
             for(int tempindex=0;tempindex<tempGroupIdslist.size();tempindex++){
                 String tempGroupId = (String)tempGroupIdslist.get(tempindex);
                 if(tempSql.equals("(")) tempSql += "d.groupId="+tempGroupId;
                 else tempSql += " or d.groupId="+tempGroupId;
             }
             tempSql += ")";
             if(!tempSql.equals("()")){
                 sql += " and " + tempSql;
             }
         }
     }
       
      sql+= "  ON c.requestid = a.requestid  " +
        " WHERE (b.id = "+reportid+") AND (f.id in("+hasrightdeps+"))";
    }else{
			if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
		{
			 sql = "SELECT "+fieldname+",a.requestid FROM Workflow_Report b " +
              "INNER JOIN (select deleted,formid,workflowid,id,requestid ,creater,createdate,workflowid,currentnodeid,lastoperatedate,lastoperator,status,workflowid,requestname,requestlevel,currentnodetype,lastoperatedate from workflow_requestbase,workflow_base where (workflow_requestbase.deleted <> 1 or workflow_requestbase.deleted is null or workflow_requestbase.deleted='') and (workflow_base.isvalid='1' or workflow_base.isvalid='3') and workflow_requestbase.workflowid=workflow_base.id "+otherSqlWhere+") c " +
              "ON  b.formid = c.formid and '" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'||to_char(c.id)||',%' " +
              "INNER JOIN workflow_form a " ;
			}
			else
		{
		sql = "SELECT "+fieldname+",a.requestid FROM Workflow_Report b " +
              "INNER JOIN (select deleted,formid,workflowid,id,requestid ,creater,createdate,workflowid,currentnodeid,lastoperatedate,lastoperator,status,workflowid,requestname,requestlevel,currentnodetype,lastoperatedate from workflow_requestbase,workflow_base where (workflow_requestbase.deleted <> 1 or workflow_requestbase.deleted is null or workflow_requestbase.deleted='') and (workflow_base.isvalid='1' or workflow_base.isvalid='3') and workflow_requestbase.workflowid=workflow_base.id "+otherSqlWhere+") c " +
              "ON  b.formid = c.formid and '" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'+convert(varchar,c.id)+',%' " +
              "INNER JOIN workflow_form a " ;
		}
     if(detailcount != 0 ) {  
         sql+=  " LEFT JOIN workflow_formdetail d  ON a.requestid = d.requestid " ;
         String tempGroupIds = ",";
         ArrayList fieldnamelist = Util.TokenizerString(fieldname,",");
         for(int tempindex=0;tempindex<fieldnamelist.size();tempindex++){
             String tempfieldname = (String)fieldnamelist.get(tempindex);
             if(tempfieldname.indexOf("d.")==0){
                 tempfieldname = tempfieldname.substring(2);
                 RecordSet.executeSql("select groupId from workflow_formfield where formid="+formid+" and fieldid=(select id from workflow_formdictdetail where fieldname='"+tempfieldname+"')");
                 if(RecordSet.next()){
                     String tempGroupId = RecordSet.getString("groupId");
                     if(tempGroupIds.indexOf(","+tempGroupId+",")<0)
                         tempGroupIds += tempGroupId+",";
                 }
             }
         }
         if(!tempGroupIds.equals(",")){//在多明细查询时，查询需要显示的明细。
             String tempSql = "(";
             ArrayList tempGroupIdslist = Util.TokenizerString(tempGroupIds,",");
             for(int tempindex=0;tempindex<tempGroupIdslist.size();tempindex++){
                 String tempGroupId = (String)tempGroupIdslist.get(tempindex);
                 if(tempSql.equals("(")) tempSql += "d.groupId="+tempGroupId;
                 else tempSql += " or d.groupId="+tempGroupId;
             }
             tempSql += ")";
             if(!tempSql.equals("()")){
                 sql += " and " + tempSql;
             }
         }
     }
             
       sql+= " ON c.requestid = a.requestid " +
              "WHERE (b.id = "+reportid+")";
    }
}
else {
    //modify by xhheng @20050127 for TD 1621
    boolean haswhere = false ;
    //modify by mackjoe at 20070625 for TD6865
    if(detailcount != 0 && ("156".equals(formid) || "157".equals(formid) || "158".equals(formid) || "159".equals(formid))){
        fieldname+=",d.organizationtype";
    }
    sql = " select " + fieldname + " from " ;
    sql += " Workflow_Report b INNER JOIN (select deleted,formid,workflowid,id,requestid ,creater,requestname,requestlevel,currentnodetype,lastoperatedate from workflow_requestbase,workflow_base where (workflow_requestbase.deleted <> 1 or workflow_requestbase.deleted is null or workflow_requestbase.deleted='') and (workflow_base.isvalid='1' or workflow_base.isvalid='3') and workflow_requestbase.workflowid=workflow_base.id "+otherSqlWhere+") c " ;
    if((sharelevel_1 <2 && sharelevel_1>-1) || (sharelevel_1<2 && (sharelevel_2 ==3 || sharelevel_3==9))) {
    	if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
    	{
    		sql += " INNER JOIN hrmresource e INNER JOIN hrmdepartment f ON e.departmentid=f.id ON c.creater=e.id and f.id in("+hasrightdeps+") ON b.formid = c.formid and '" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'|| to_char(c.id) || ',%' ";
		}else{
			sql += " INNER JOIN hrmresource e INNER JOIN hrmdepartment f ON e.departmentid=f.id ON c.creater=e.id and f.id in("+hasrightdeps+") ON b.formid = c.formid and '" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'+convert(varchar,c.id)+',%' ";
    	}
    	
    	//sql += " INNER JOIN hrmresource e INNER JOIN hrmdepartment f ON e.departmentid=f.id ON c.creater=e.id and f.id in("+hasrightdeps+") ON b.formid = c.formid and ','+b.reportwfid+',' like '%,'+convert(varchar,c.id)+',%' ";
    }else{
    	if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
    	{
    		sql += " ON b.formid = c.formid and '" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'||to_char(c.id)||',%'  and b.id="+reportid ;
    	}
    	else
    	{
    		sql += " ON b.formid = c.formid and '" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'+convert(varchar,c.id)+',%'  and b.id="+reportid;
    	}
    }
    sql += " INNER JOIN " + tablename + " a ";
    if(detailcount != 0 ) {
    	if(isNewBill){
    		//String fromSQL = "";
    		//String whereSQL = "";
    		List detailtablenameList = Util.TokenizerString(detailtablename, ",");
    		for(int tempInt=0;tempInt<detailtablenameList.size();tempInt++){
    			String tempdetailtablename = (String)detailtablenameList.get(tempInt);
    			sql += " LEFT JOIN "+tempdetailtablename + " ON a.id="+tempdetailtablename+"."+detailkeyfield;
    			//fromSQL += tempdetailtablename+",";
    			//if(whereSQL.equals("")) whereSQL = " where a.id="+tempdetailtablename+"."+detailkeyfield;
    			//else whereSQL += " and a.id="+tempdetailtablename+"."+detailkeyfield;
    		}
    		//if(!fromSQL.equals("")){
    		//	fromSQL = fromSQL.substring(0,fromSQL.length()-1);
    		//	sql += ", "+fromSQL+whereSQL;
    		//}
    		haswhere = true ;
    	}else{
            sql += " LEFT JOIN " + detailtablename + " d ON a.id = d." +  detailkeyfield ;
            haswhere = true ;
      }
      //sql += " ON c.requestid = a.requestid ";
    }
    sql += " ON c.requestid = a.requestid ";

	//if(formid.equals("180")&&isbill.equals("1")){//请假单据
	//	sql += " ON c.requestid = a.requestid ";
	//}

    //if(haswhere)  {
    //  sql += " and ";
    //}else {
    //  sql += " where ";
    //}
    if((sharelevel_1 <2 && sharelevel_1>-1) || (sharelevel_1<2 && (sharelevel_2 ==3 || sharelevel_3==9))) {
    //  sql += " c.creater=e.id and e.departmentid=f.id and f.id in("+hasrightdeps+") and ";
    //}
	if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
		{
		sql += " and b.formid = c.formid and '" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'||to_char(c.id)||',%'  and b.id="+reportid+" and a.requestid = c.requestid " ;
	}
	else
	{
		sql += " and b.formid = c.formid and '" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'+convert(varchar,c.id)+',%'  and b.id="+reportid+" and a.requestid = c.requestid " ;
	}
	}
}
//    out.println("====================");
sql = request.getParameter("pmSql");
RecordSet.writeLog(sql);
%>

<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
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


<TABLE class=liststyle cellspacing=1  >
  <COLGROUP>
  <TBODY>
  <TR class="header">
  
    <%--  xwj for td2974 20051026   B E G I N  --%>
<%
////移到前面处理  fanggsh 20060828 for TD4875
//rs2.executeSql("select reportname from workflow_report where id = " + reportid);
//String titlename1 = "";
//if(rs2.next()){
//titlename1 = rs2.getString("reportname") ;
//}
%> 
 <th colSpan=<%=fields.size()%>> <p align="center"><%=titlename1%> </p></th>
   <%--xwj for td2974 20051026   E N D  --%>
      
  </TR>
  <TR class=Header>
  <%
  ExcelSheet es = new ExcelSheet() ;
  ExcelRow er = es.newExcelRow () ;
  Map statisticsRowKv = new HashMap();
  List rowNames = new ArrayList();
  
  /*-----  xwj for td2451 20051114  B E G I N   ---*/
   ArrayList colList = ReportComInfo.getCompositorList(compositorColList); //xwj for td2451 on 2005-11-14
   for(int i = 0; i < colList.size(); i++) {
	    rcColListBean = (ReportCompositorListBean) colList.get(i);
	    er.addStringValue(rcColListBean.getColName()) ;
  %>
    <TD><%=rcColListBean.getColName()%></TD>
    <%}
     es.addExcelRow(er) ;
  /*-----  xwj for td2451 20051114   E N D  ---*/
  
    %>
  </TR>
<%
   //alan
   	String useddetailtable = Util.null2String(request.getParameter("useddetailtable"));
    //RecordSet.execute(sql);
    int needchange = 0;
    String tempvalue = ""; //added by xwj for td2132 on 20050701
    String tempdbordervalue = "" ;
    boolean needstat = false ;
    boolean isfirst = true ;
    //System.out.println("sql:= "+sql);
    if(!"".equals(useddetailtable)) useddetailtable = useddetailtable.substring(1);
    detailtablename = useddetailtable;
    ArrayList detailtablenameList = Util.TokenizerString(detailtablename, ",");
    int details = detailtablenameList.size();
    String[] detailids = null;
    if(details>0) detailids = new String[details];
    for(int flag=0;flag<details;flag++){
        detailids[flag] = ",";
    }
    
    if(details>0&&isNewBill){
        String tempsql = "select t1.requestid from ("+sql+") t1 ";
		RecordSet.writeLog(tempsql);
        RecordSet.executeSql(tempsql);
        ArrayList requestids = new ArrayList();
        //requestids.add("30");
        while(RecordSet.next()){
            if (!requestids.contains(RecordSet.getString("requestid"))) {
            	requestids.add(RecordSet.getString("requestid"));
        	}
        }
        for(int rqflag=0;rqflag<requestids.size();rqflag++){
            String thisrequestid = (String)requestids.get(rqflag);
            boolean firstrequest = true;
        for(int indexflag=0;indexflag<details;indexflag++){
            String thisrowflag = (String)detailtablenameList.get(indexflag);
            thisrowflag = thisrowflag.toUpperCase();
            String thisdetailids = ",";
            
            //RecordSet.execute(sql);
            //RecordSet.execute(sql + " where c.requestid=" + thisrequestid);
			RecordSet.execute("select * from (" + sql + ") tbl where tbl.requestid=" + thisrequestid);

        while(RecordSet.next()){
            
            String thisdetailrequestid = RecordSet.getString("requestid");
            if(!thisrequestid.equals(thisdetailrequestid)) continue;
            
            //String thisdetailid = RecordSet.getString("dt"+(indexflag+1));
            String thisdetailid = RecordSet.getString(thisrowflag + "_id_");
            if((RecordSet.getCounts() == 1 && !firstrequest && "".equals(thisdetailid)) || (RecordSet.getCounts() > 1 && thisdetailid.equals("")) || thisdetailids.indexOf(","+thisdetailid+",")>-1) continue;
            firstrequest = false;
            thisdetailids += thisdetailid+",";
        if(ordercount == 1) { //modified by xwj for td2132 on 20050701
            for(int i =0 ; i< fields.size() ; i++) {
                if(((String)isdborders.get(i)).equals("1")) {
                    tempvalue = Util.null2String(RecordSet.getString(i+1));
                    if(!tempvalue.equals(tempdbordervalue)) {
                        needstat = true ;
                        tempdbordervalue = tempvalue ;
                    }
                    else {
                        needstat = false ;
                    }
                }
            }
        }
        
        //added by xwj for td2132 on 20050701
        
        if(ordercount > 1){
            List list  = new ArrayList();
            for(int i =0 ; i< fields.size() ; i++) {
                if(((String)isdborders.get(i)).equals("1")) {
                     tempvalue += Util.null2String(RecordSet.getString(i+1));
                }
           }
          
              if(!tempvalue.equals(tempdbordervalue)) {
                        needstat = true ;
                        tempdbordervalue = tempvalue ;
                    }
                    else {
                        needstat = false ;
                    }
           tempvalue = "";
        } 
  
        if(needstat && statcount != 0 && !isfirst ) {
            er = es.newExcelRow () ;
        %>
        <TR class=TOTAL style="FONT-WEIGHT: bold">
            <% for(int i =0 ; i< tempstatvalues.size() ; i++) {
               er.addValue(formatDataTotal((String)tempstatvalues.get(i))) ;
            %>
            <TD><%=formatDataTotal((String)tempstatvalues.get(i))%></TD>
            <%tempstatvalues.set(i,"") ; }

              es.addExcelRow(er) ;
            %>
        </tr>

        <%
        }

        isfirst = false ;

        er = es.newExcelRow () ;

       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%}%>
  <%
          String temRequestid = RecordSet.getString("requestid");
          //System.out.println("temRequestid = " + temRequestid);

          if(!temRequestid.equals(requestid)){
              isnew = true;
              requestid = temRequestid;
          }else{
              isnew = false;
          }
          //System.out.println("isnew = " + isnew);

  String leavetype = "";
  for(int i =0 ; i< fields.size() ; i++) {
  	    	String result = Util.null2String(RecordSet.getString(i+1)) ;
    //modify by mackjoe at 20070625 for TD6865
    String tcolname= RecordSet.getColumnName(i+1);
    if(tcolname.indexOf("__")>0&&tcolname.toUpperCase().indexOf(thisrowflag)==-1) result = "";
    String htmltype = (String)htmltypes.get(i);
    int type = Util.getIntValue((String)types.get(i)) ;
	if(tcolname.indexOf("__")>0){
       tcolname = tcolname.substring(0,tcolname.indexOf("__"));
    }
	if(tcolname.equalsIgnoreCase("leavetype") && "1".equals(isbill) && "180".equals(formid)){
		leavetype=result;
	}
	if(tcolname.equalsIgnoreCase("otherleavetype") && "1".equals(isbill) && "180".equals(formid)){
		if(!leavetype.equals("4")) result = "";
	}

	if(tcolname.equalsIgnoreCase("organizationid") && "1".equals(isbill) && ("156".equals(formid) || "157".equals(formid) || "158".equals(formid) || "159".equals(formid))){
        int organizationtype=Util.getIntValue(RecordSet.getString("organizationtype"));
        if(organizationtype==1){ //分部
            type=42;
        }else{
        if(organizationtype==2){  //部门
            type=4;
        }
        }
    }
    String results[] = null ;
      //System.out.println("types = " + types.get(i));
      
    /*-----  xwj for td2974 20051026   B E G I N  ---*/
    if(htmltype.equals("-2")) {
       if("0".equals(result)){
         result = SystemEnv.getHtmlLabelName(225,user.getLanguage());
       }
       else if("1".equals(result)){
         result = SystemEnv.getHtmlLabelName(15533,user.getLanguage()); 
       }
       else if("2".equals(result)){
         result = SystemEnv.getHtmlLabelName(2087,user.getLanguage());
       }
       else{}
    }
    
 //-----------------------------
    
    //创建人
	if(htmltype.equals("-10")) {
		result = WorkFlowTransMethod.getWFSearchResultName(result,"0");
	}
    //创建日期
	//if(htmltype.equals("-11")) {
	//	result = WorkFlowTransMethod.getWFSearchResultName(result,"0");
	//}
	//工作流
	if(htmltype.equals("-12")) {
		result = WorkflowComInfo.getWorkflowname(result);
	}
	 //当前节点
    if(htmltype.equals("-13")) {
		result = WorkFlowTransMethod.getCurrentNode(result);
	}
    //未操作者
    if(htmltype.equals("-14")) {
		result = WorkFlowTransMethod.getUnOptInRep(result);
	}
    //流程状态
    if(htmltype.equals("-15")) {
    	if(!"3".equals(result)){
    		result = SystemEnv.getHtmlLabelName(17999,user.getLanguage());
    	}else{
    		result = SystemEnv.getHtmlLabelName(251,user.getLanguage());
    	}
	}
    //归档日期
    if(htmltype.equals("-16")) {
    	//result = SystemEnv.getHtmlLabelName(2087,user.getLanguage());
	}
    //-----------------------------
    
    /*-----  xwj for td2974 20051026   E N D  ---*/
    
    if(htmltype.equals("3")) {
        switch (type) {
            case 1:
                result = Util.toScreen(ResourceComInfo.getResourcename(result),user.getLanguage()) ;
                break ;
            case 23:
                result = Util.toScreen(CapitalComInfo.getCapitalname(result),user.getLanguage()) ;
                break ;
            case 4:
                result = Util.toScreen(DepartmentComInfo.getDepartmentname(result),user.getLanguage()) ;
                break ;
            case 6:
                result = Util.toScreen(CostcenterComInfo.getCostCentername(result),user.getLanguage()) ;
                break ;
            case 7:
                result = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(result),user.getLanguage()) ;
                break ;
            case 8:
                result = Util.toScreen(ProjectInfoComInfo.getProjectInfoname(result),user.getLanguage()) ;
                break ;
            case 9:
                result = Util.toScreen(DocComInfo.getDocname(result),user.getLanguage()) ;
                break ;
            case 12:
                result = Util.toScreen(CurrencyComInfo.getCurrencyname(result),user.getLanguage()) ;
                break ;
            case 25:
                result = Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(result),user.getLanguage()) ;
                break ;
            case 14:
            case 15:
                result = Util.toScreen(LedgerComInfo.getLedgername(result),user.getLanguage()) ;
                break ;
            case 16:
                result = Util.toScreen(RequestComInfo.getRequestname(result),user.getLanguage()) ;
                break ;
            case 17:
                results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = Util.toScreen(ResourceComInfo.getResourcename(results[j]),user.getLanguage()) ;
                        else
                            result += ","+Util.toScreen(ResourceComInfo.getResourcename(results[j]),user.getLanguage()) ;
                    }
                }
                break ;
            case 18:
                results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(results[j]),user.getLanguage()) ;
                        else
                            result += ","+ Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(results[j]),user.getLanguage()) ;
                    }
                }
                break ;
            case 24:
                result = Util.toScreen(JobTitlesComInfo.getJobTitlesname(result),user.getLanguage()) ;
                break ;
            case 37:            // 增加多文档处理
                results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) ;
                        else
                            result += ","+ Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) ;
                    }
                }
                break ;
             case 57:            // 增加多部门处理
                results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = Util.toScreen(DepartmentComInfo.getDepartmentname(results[j]),user.getLanguage()) ;
                        else
                            result += ","+ Util.toScreen(DepartmentComInfo.getDepartmentname(results[j]),user.getLanguage()) ;
                    }
                }
                break ;
            case 2:
                break ;
            case 19:
                break ;
            case 42:      //分部
                result = Util.toScreen(SubCompanyComInfo.getSubCompanyname(result),user.getLanguage()) ;
                break ;
                
            case 65: //多角色处理 added xwj for td2127 on 2005-06-20
                Map roleMap  = new HashMap(); 
                String sql_  = "select ID,RolesName from HrmRoles";
                rs.executeSql(sql_);
                while(rs.next()){
                   roleMap.put(rs.getString("ID"),rs.getString("RolesName"));
                }
                results = Util.TokenizerString2(result,",");
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = (String)roleMap.get(results[j]) ;
                        else
                            result += ","+ (String)roleMap.get(results[j]) ;
                    }
                    //System.out.println(result);
                }
                break ;
             
            case 141:
            //人力资源条件
            	result = resourceConditionManager.getFormShowName(result, user.getLanguage());            
                break;
            case 142:
            //收发文单位
                results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = Util.toScreen(DocReceiveUnitComInfo.getReceiveUnitName(results[j]),user.getLanguage()) ;
                        else
                            result += ","+ Util.toScreen(DocReceiveUnitComInfo.getReceiveUnitName(results[j]),user.getLanguage()) ;
                    }
                }
                break;
            case 143:
            //树状文档
            	results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = Util.toScreen(DocTreeDocFieldComInfo.getTreeDocFieldName(results[j]),user.getLanguage()) ;
                        else
                            result += ","+ Util.toScreen(DocTreeDocFieldComInfo.getTreeDocFieldName(results[j]),user.getLanguage()) ;
                    }
                }
                break;
            case 152:
            //多请求
            	results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                		result = "";
                    for(int j=0 ; j< results.length ; j++) {
                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
                       rs.executeSql(sql2);
		                   while(rs.next()){
		                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
		                   }
                    }
                    if(!result.equals("")) result = result.substring(0,result.length()-1);
                }
                break;
            case 135:
            //多项目
            	results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                		result = "";
                    for(int j=0 ; j< results.length ; j++) {
                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
                       rs.executeSql(sql2);
		                   while(rs.next()){
		                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
		                   }
                    }
                    if(!result.equals("")) result = result.substring(0,result.length()-1);
                }
                break;
            case 161:
			case 162:
            //自定义单选,多选
                if(!result.equals("")) {
				//获取字段的数据库类型
				String tempfid=(String)fieldids.get(i);
				String tempfdbtype="";
				if (isbill.equals("1"))  
					{
					rs1.execute("select fielddbtype from workflow_billfield where id="+tempfid);
                     if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
					}
					else
					{String tempdetal=(String)isdetails.get(i);
					if (!tempdetal.equals("1"))
					  rs1.execute("select fielddbtype from workflow_formdict where id="+tempfid);
					else 
					  rs1.execute("select fielddbtype from workflow_formdictdetail where id="+tempfid);

                     if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
					}
                    result=WorkflowJspBean.getWorkflowBrowserShowName(result,""+type,"","",tempfdbtype);
				}
                if (type==162) 
					{
					if(!result.equals("")) result = result.substring(0,result.length()-1);
					}
                break; 
				 case 224:
             	  break; 
               case 225:
           	  break; 
           	  case 226:
           	  break; 
           	   case 227:
           	  break; 
            default:
				results = Util.TokenizerString2(result,",") ;
				if(results != null) {
						result = "";
                    for(int j=0 ; j< results.length ; j++) {
                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
					   rs.executeSql(sql2);
		                   while(rs.next()){
		                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
		                   }
                    }
					if(!result.equals("")) result = result.substring(0,result.length()-1);
				}
        }
    }
    
    if(htmltype.equals("5"))
    // 选择框字段
    {
        char flag = Util.getSeparator();
        if(!result.equals("")){
        rs.executeProc("workflow_SelectItemSByvalue", (String)fieldids.get(i) + flag + isbill + flag + result);
        
        if(rs.next())
        {
            result = Util.toScreen(rs.getString("selectname"), user.getLanguage());
        }
        else
        {
            result = "";
        }
      }else{
      	 result = "";
      	}
    }
     
        if(htmltype.equals("6")) {  // 增加文件上传 added xwj for td2127 on 2005-06-20
       switch (type) {
        case 1:           
            result = Util.toScreen(DocComInfo.getDocname(result),user.getLanguage());
            break ;
        case 2:           
            result = Util.toScreen(DocComInfo.getDocname(result),user.getLanguage());
            break ;
        default:
        }
    }

	if (!rowNames.contains(RecordSet.getColumnName(i + 1))) {
    	rowNames.add(RecordSet.getColumnName(i + 1));
    }
     
    if(((String)isstats.get(i)).equals("1")) {

        double resultdouble = Util.getDoubleValue((String)statvalues.get(i) , 0) ;
        double tempresultdouble = Util.getDoubleValue((String)tempstatvalues.get(i) , 0) ;

		statisticsRowKv.put(RecordSet.getColumnName(i + 1), Boolean.valueOf(!isdetails.get(i).equals("1")));

        if(!isdetails.get(i).equals("1")){
            if(isnew){
                resultdouble += Util.getDoubleValue(result , 0) ;
                tempresultdouble += Util.getDoubleValue(result , 0) ;
                requestid = temRequestid;
                statvalues.set(i, ""+resultdouble) ;
                tempstatvalues.set(i, ""+tempresultdouble) ;
            }else{
                result = "0";
            }
        }else{
            resultdouble += Util.getDoubleValue(result , 0) ;
            tempresultdouble += Util.getDoubleValue(result , 0) ;
            requestid = temRequestid;
            statvalues.set(i, ""+resultdouble) ;
            tempstatvalues.set(i, ""+tempresultdouble) ;
        }

    }
  %>
    <TD><% if(!((String)isdborders.get(i)).equals("1") || ((String)isdborders.get(i)).equals("1") && (needstat||statcount== 0) ) { if(htmltype.equals("1") && (type==3)) {%> <%=formatData(result)%><%
      er.addValue(formatData(result)) ;
        }else{
    %>
        <%=result%>
    <%
		String tempString = Util.StringReplace(delHtml(StringEscapeUtils.unescapeHtml(result)),"%nbsp;"," ");
	    tempString = Util.StringReplace(tempString,"&dt;&at;"," ");
		tempString = Util.StringReplace(tempString,"&amp;","&");
         if((htmltype.equals("1")&&type==1)||htmltype.equals("2")) er.addStringValue(tempString) ;
         else er.addValue(tempString) ;
      }
    } else {%><%=result%><%
      er.addValue(formatData(result)) ;
    }%></TD>
    <%}

    %>
  </TR>
<%
    es.addExcelRow(er) ;
}
}
}
  }else{
    RecordSet.execute(sql);
    //System.out.println("outsql:= "+sql);
      while(RecordSet.next()){
        if(ordercount == 1) { //modified by xwj for td2132 on 20050701
            for(int i =0 ; i< fields.size() ; i++) {
                if(((String)isdborders.get(i)).equals("1")) {
                    tempvalue = Util.null2String(RecordSet.getString(i+1));
                    if(!tempvalue.equals(tempdbordervalue)) {
                        needstat = true ;
                        tempdbordervalue = tempvalue ;
                    }
                    else {
                        needstat = false ;
                    }
                }
            }
        }
        
        //added by xwj for td2132 on 20050701
        
        if(ordercount > 1){
            List list  = new ArrayList();
            for(int i =0 ; i< fields.size() ; i++) {
                if(((String)isdborders.get(i)).equals("1")) {
                     tempvalue += Util.null2String(RecordSet.getString(i+1));
                }
           }
          
              if(!tempvalue.equals(tempdbordervalue)) {
                        needstat = true ;
                        tempdbordervalue = tempvalue ;
                    }
                    else {
                        needstat = false ;
                    }
           tempvalue = "";
        } 
  
        if(needstat && statcount != 0 && !isfirst ) {
            er = es.newExcelRow () ;
        %>
        <TR class=TOTAL style="FONT-WEIGHT: bold">
            <% for(int i =0 ; i< tempstatvalues.size() ; i++) {
               er.addValue(formatDataTotal((String)tempstatvalues.get(i))) ;
            %>
            <TD><%=formatDataTotal((String)tempstatvalues.get(i))%></TD>
            <%tempstatvalues.set(i,"") ; }

              es.addExcelRow(er) ;
            %>
        </tr>

        <%
        }

        isfirst = false ;

        er = es.newExcelRow () ;

       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%}%>
  <%
          String temRequestid = RecordSet.getString("requestid");
          //System.out.println("temRequestid = " + temRequestid);

          if(!temRequestid.equals(requestid)){
              isnew = true;
              requestid = temRequestid;
          }else{
              isnew = false;
          }
          //System.out.println("isnew = " + isnew);
  String leavetype = "";
  for(int i =0 ; i< fields.size() ; i++) {
  	String result = Util.null2String(RecordSet.getString(i+1)) ;  	
    //modify by mackjoe at 20070625 for TD6865
    String tcolname= RecordSet.getColumnName(i+1);
    String htmltype = (String)htmltypes.get(i);
    int type = Util.getIntValue((String)types.get(i)) ;
	if(tcolname.indexOf("__")>0){
       tcolname = tcolname.substring(0,tcolname.indexOf("__"));
    }
	if(tcolname.equalsIgnoreCase("leavetype") && "1".equals(isbill) && "180".equals(formid)){
		leavetype=result;
	}
	if(tcolname.equalsIgnoreCase("otherleavetype") && "1".equals(isbill) && "180".equals(formid)){
		if(!leavetype.equals("4")) result = "";
	}

   if(tcolname.equalsIgnoreCase("requestname"))  //处理超长的数字会成为科学计数法
   {
   result=result;
   }
    if(tcolname.equalsIgnoreCase("organizationid") && "1".equals(isbill) && ("156".equals(formid) || "157".equals(formid) || "158".equals(formid) || "159".equals(formid))){
        int organizationtype=Util.getIntValue(RecordSet.getString("organizationtype"));
        if(organizationtype==1){ //分部
            type=42;
        }else{
        if(organizationtype==2){  //部门
            type=4;
        }
		if(organizationtype==3){  //个人  需要把个人的也加上
	            type=1;
	        }
        }
    }
    String results[] = null ;
      //System.out.println("types = " + types.get(i));
      
    /*-----  xwj for td2974 20051026   B E G I N  ---*/
    if(htmltype.equals("-2")) {
       if("0".equals(result)){
         result = SystemEnv.getHtmlLabelName(225,user.getLanguage());
       }
       else if("1".equals(result)){
         result = SystemEnv.getHtmlLabelName(15533,user.getLanguage()); 
       }
       else if("2".equals(result)){
         result = SystemEnv.getHtmlLabelName(2087,user.getLanguage());
       }
       else{}
    }
    //------------------------------
    //创建人
	if(htmltype.equals("-10")) {
		result = WorkFlowTransMethod.getWFSearchResultName(result,"0");
	}
    //创建日期
	//if(htmltype.equals("-11")) {
	//	result = WorkFlowTransMethod.getWFSearchResultName(result,"0");
	//}
	//工作流
	if(htmltype.equals("-12")) {
		result = WorkflowComInfo.getWorkflowname(result);
	}
	 //当前节点
    if(htmltype.equals("-13")) {
		result = WorkFlowTransMethod.getCurrentNode(result);
	}
    //未操作者
    if(htmltype.equals("-14")) {
    	result = WorkFlowTransMethod.getUnOptInRep(result);
	}
    //流程状态
    if(htmltype.equals("-15")) {
    	if(!"3".equals(result)){
    		result = SystemEnv.getHtmlLabelName(17999,user.getLanguage());
    	}else{
    		result = SystemEnv.getHtmlLabelName(251,user.getLanguage());
    	}
	}
    //归档日期
    if(htmltype.equals("-16")) {
    	//result = SystemEnv.getHtmlLabelName(2087,user.getLanguage());
	}
    
    //------------------------------
    
    /*-----  xwj for td2974 20051026   E N D  ---*/
    
    if(htmltype.equals("3")) {
        switch (type) {
            case 1:
                result = Util.toScreen(ResourceComInfo.getResourcename(result),user.getLanguage()) ;
                break ;
            case 23:
                result = Util.toScreen(CapitalComInfo.getCapitalname(result),user.getLanguage()) ;
                break ;
            case 4:
                result = Util.toScreen(DepartmentComInfo.getDepartmentname(result),user.getLanguage()) ;
                break ;
            case 6:
                result = Util.toScreen(CostcenterComInfo.getCostCentername(result),user.getLanguage()) ;
                break ;
            case 7:
                result = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(result),user.getLanguage()) ;
                break ;
            case 8:
                result = Util.toScreen(ProjectInfoComInfo.getProjectInfoname(result),user.getLanguage()) ;
                break ;
            case 9:
                result = Util.toScreen(DocComInfo.getDocname(result),user.getLanguage()) ;
                break ;
            case 12:
                result = Util.toScreen(CurrencyComInfo.getCurrencyname(result),user.getLanguage()) ;
                break ;
            case 25:
                result = Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(result),user.getLanguage()) ;
                break ;
            case 14:
            case 15:
                result = Util.toScreen(LedgerComInfo.getLedgername(result),user.getLanguage()) ;
                break ;
            case 16:
                result = Util.toScreen(RequestComInfo.getRequestname(result),user.getLanguage()) ;
                break ;
            case 17:
                results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = Util.toScreen(ResourceComInfo.getResourcename(results[j]),user.getLanguage()) ;
                        else
                            result += ","+Util.toScreen(ResourceComInfo.getResourcename(results[j]),user.getLanguage()) ;
                    }
                }
                break ;
            case 18:
                results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(results[j]),user.getLanguage()) ;
                        else
                            result += ","+ Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(results[j]),user.getLanguage()) ;
                    }
                }
                break ;
            case 24:
                result = Util.toScreen(JobTitlesComInfo.getJobTitlesname(result),user.getLanguage()) ;
                break ;
            case 37:            // 增加多文档处理
                results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) ;
                        else
                            result += ","+ Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) ;
                    }
                }
                break ;
             case 57:            // 增加多部门处理
                results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = Util.toScreen(DepartmentComInfo.getDepartmentname(results[j]),user.getLanguage()) ;
                        else
                            result += ","+ Util.toScreen(DepartmentComInfo.getDepartmentname(results[j]),user.getLanguage()) ;
                    }
                }
                break ;
            case 2:
                break ;
            case 19:
                break ;
            case 42:      //分部
                result = Util.toScreen(SubCompanyComInfo.getSubCompanyname(result),user.getLanguage()) ;
                break ;
                
            case 65: //多角色处理 added xwj for td2127 on 2005-06-20
                Map roleMap  = new HashMap(); 
                String sql_  = "select ID,RolesName from HrmRoles";
                rs.executeSql(sql_);
                while(rs.next()){
                   roleMap.put(rs.getString("ID"),rs.getString("RolesName"));
                }
                results = Util.TokenizerString2(result,",");
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = (String)roleMap.get(results[j]) ;
                        else
                            result += ","+ (String)roleMap.get(results[j]) ;
                    }
                    //System.out.println(result);
                }
                break ;
             
            case 141:
            //人力资源条件
            	result = resourceConditionManager.getFormShowName(result, user.getLanguage());            
                break;
            case 142:
            //收发文单位
                results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = Util.toScreen(DocReceiveUnitComInfo.getReceiveUnitName(results[j]),user.getLanguage()) ;
                        else
                            result += ","+ Util.toScreen(DocReceiveUnitComInfo.getReceiveUnitName(results[j]),user.getLanguage()) ;
                    }
                }
                break;
            case 143:
            //树状文档
            	results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                            result = Util.toScreen(DocTreeDocFieldComInfo.getTreeDocFieldName(results[j]),user.getLanguage()) ;
                        else
                            result += ","+ Util.toScreen(DocTreeDocFieldComInfo.getTreeDocFieldName(results[j]),user.getLanguage()) ;
                    }
                }
                break;
            case 152:
            //多请求
            	results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                		result = "";
                    for(int j=0 ; j< results.length ; j++) {
                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
                       rs.executeSql(sql2);
		                   while(rs.next()){
		                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
		                   }
                    }
                    if(!result.equals("")) result = result.substring(0,result.length()-1);
                }
                break;
            case 135:
            //多项目
            	results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                		result = "";
                    for(int j=0 ; j< results.length ; j++) {
                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
                       rs.executeSql(sql2);
		                   while(rs.next()){
		                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
		                   }
                    }
                    if(!result.equals("")) result = result.substring(0,result.length()-1);
                }
                break;
            case 161:
			case 162:
            //自定义单选,多选
                if(!result.equals("")) {
				//获取字段的数据库类型
				String tempfid=(String)fieldids.get(i);
				String tempfdbtype="";
				if (isbill.equals("1"))  
					{
					rs1.execute("select fielddbtype from workflow_billfield where id="+tempfid);
                     if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
					}
					else
					{String tempdetal=(String)isdetails.get(i);
					if (!tempdetal.equals("1"))
					  rs1.execute("select fielddbtype from workflow_formdict where id="+tempfid);
					else 
					  rs1.execute("select fielddbtype from workflow_formdictdetail where id="+tempfid);

                     if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
					}
                    result=WorkflowJspBean.getWorkflowBrowserShowName(result,""+type,"","",tempfdbtype);
				}
                if (type==162) 
					{
					if(!result.equals("")) result = result.substring(0,result.length()-1);
					}
                break;  
			 case 224:
             	  break; 
               case 225:
           	  break; 
           	  case 226:
           	  break; 
           	   case 227:
           	  break; 
            default:
                //System.out.println("result = " + result);
                results = Util.TokenizerString2(result,",") ;
				if(results != null) {
						result = "";
                    for(int j=0 ; j< results.length ; j++) {
                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
					   rs.executeSql(sql2);
		                   while(rs.next()){
		                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
		                   }
                    }
					if(!result.equals("")) result = result.substring(0,result.length()-1);
				}
        }
    }
    
    if(htmltype.equals("5"))
    // 选择框字段
    {
        char flag = Util.getSeparator();
        if(!result.equals("")){
        rs.executeProc("workflow_SelectItemSByvalue", (String)fieldids.get(i) + flag + isbill + flag + result);
        
        if(rs.next())
        {
            result = Util.toScreen(rs.getString("selectname"), user.getLanguage());
        }
        else
        {
            result = "";
        }
      }else{
      	 result = "";
      	}
    }
     
        if(htmltype.equals("6")) {  // 增加文件上传 added xwj for td2127 on 2005-06-20
       switch (type) {
        case 1:           
            //result = Util.toScreen(DocComInfo.getDocname(result),user.getLanguage());
			results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                           result =  " <a href=\"javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+results[j]+"')\">"+Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) +"</a> ";
                        else
                            result += "<br>"+  " <a href=\"javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+results[j]+"')\">"+Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) +"</a> ";
                    }
                }
            break ;
		case 2:           
            //result = Util.toScreen(DocComInfo.getDocname(result),user.getLanguage());
			results = Util.TokenizerString2(result,",") ;
                if(results != null) {
                    for(int j=0 ; j< results.length ; j++) {
                        if(j==0)
                           result =  " <a href=\"javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+results[j]+"')\">"+Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) +"</a> ";
                        else
                            result += "<br>"+  " <a href=\"javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+results[j]+"')\">"+Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) +"</a> ";
                    }
                }
            break;
        default:
        }
    }
     if(htmltype.equals("1")) {   //处理超长的数字会成为科学计数法(如文本，电话号码)
        if(type==1){ 
  	       result=result+"　";
  	   }else if(type==3&&("156".equals(formid)||"158".equals(formid))){
  		   int organizationtype = RecordSet.getInt("organizationtype");
             int organizationid = RecordSet.getInt("organizationid");
             String budgetperiod = RecordSet.getString("budgetperiod");
             int subject = RecordSet.getInt("subject");
             BudgetHandler bp = new BudgetHandler();
             String kpi = bp.getBudgetKPI(budgetperiod, organizationtype, organizationid, subject);
             String[] kpiArray = kpi.split("\\|");
			 String[] kpi1 = kpiArray[0].split(",");
			 String kpi11 = kpi1[0];
			 String kpi12 = kpi1[1];
			 String kpi13 = kpi1[2];
			 String span1 = "<span><span style='white-space :nowrap'>" + SystemEnv.getHtmlLabelName(18768, user.getLanguage()) + ":" + Util.round(kpi11,2) + "</span><br><span style='white-space :nowrap;color:red'>" + SystemEnv.getHtmlLabelName(18503, user.getLanguage()) + ":" + Util.round(kpi12,2) + "</span><br><span style='white-space :nowrap;color:green'> " + SystemEnv.getHtmlLabelName(18769, user.getLanguage()) + ":" + Util.round(kpi13,2) + "</span></span>";

			 String[] kpi2 = kpiArray[1].split(",");
			 String kpi21 = kpi2[0];
			 String kpi22 = kpi2[1];
			 String kpi23 = kpi2[2];
			 String span2 = "<span><span style='white-space :nowrap'>" + SystemEnv.getHtmlLabelName(18768, user.getLanguage()) + ":" + Util.round(kpi21,2) + "</span><br><span style='white-space :nowrap;color:red'>" + SystemEnv.getHtmlLabelName(18503, user.getLanguage()) + ":" + Util.round(kpi22,2) + "</span><br><span style='white-space :nowrap;color:green'>" + SystemEnv.getHtmlLabelName(18769, user.getLanguage()) + ":" + Util.round(kpi23,2) + "</span></span>";

			 String[] kpi3 = kpiArray[2].split(",");
			 String kpi31 = kpi3[0];
			 String kpi32 = kpi3[1];
			 String kpi33 = kpi3[2];
             String span3 = "<span><span style='white-space :nowrap'>" + SystemEnv.getHtmlLabelName(18768, user.getLanguage()) + ":" + kpi31 + "</span><br><span style='white-space :nowrap;color:red'>" + SystemEnv.getHtmlLabelName(18503, user.getLanguage()) + ":" + kpi32 + "</span><br><span style='white-space :nowrap;color:green'>" + SystemEnv.getHtmlLabelName(18769, user.getLanguage()) + ":" + kpi33 + "</span></span>";
         
  		   if(tcolname.equals("hrmremain")){
  			   result = ""+delHtml(span1) ;
  		   }else if(tcolname.equals("deptremain")){
  			   result = ""+delHtml(span2) ;
  		   }else if(tcolname.equals("subcomremain")){
  			   result = ""+delHtml(span3) ;
  		   }else{
  			   result=result+"　";
  		   }
  	   }
    }

	if (!rowNames.contains(RecordSet.getColumnName(i + 1))) {
    	rowNames.add(RecordSet.getColumnName(i + 1));
    }

    if(((String)isstats.get(i)).equals("1")) {
        double resultdouble = Util.getDoubleValue((String)statvalues.get(i) , 0) ;
        double tempresultdouble = Util.getDoubleValue((String)tempstatvalues.get(i) , 0) ;

		statisticsRowKv.put(RecordSet.getColumnName(i + 1), Boolean.valueOf(!isdetails.get(i).equals("1")));

        if(!isdetails.get(i).equals("1")){
            if(isnew){
                resultdouble += Util.getDoubleValue(result , 0) ;
                tempresultdouble += Util.getDoubleValue(result , 0) ;
                requestid = temRequestid;
                statvalues.set(i, ""+resultdouble) ;
                tempstatvalues.set(i, ""+tempresultdouble) ;
            }else{
                result = "0";
            }
        }else{
            resultdouble += Util.getDoubleValue(result , 0) ;
            tempresultdouble += Util.getDoubleValue(result , 0) ;
            requestid = temRequestid;
            statvalues.set(i, ""+resultdouble) ;
            tempstatvalues.set(i, ""+tempresultdouble) ;
        }

    }
  %>
    <TD><% if(!((String)isdborders.get(i)).equals("1") || ((String)isdborders.get(i)).equals("1") && (needstat||statcount== 0) ) { if(htmltype.equals("1") && (type==3)) {%> <%=formatData(result)%><%
      er.addValue(formatData(result)) ;
        }else{
    %>
        <%=result%>
    <%
		String tempString = Util.StringReplace(delHtml(StringEscapeUtils.unescapeHtml(result)),"%nbsp;"," ");
	    tempString = Util.StringReplace(tempString,"&dt;&at;"," ");
		tempString = Util.StringReplace(tempString,"&amp;","&");
         if((htmltype.equals("1")&&type==1)||htmltype.equals("2")) er.addStringValue(tempString) ;
         else er.addValue(tempString) ;
      }
    } else {%><%=result%><%
    	er.addValue(formatData(result)) ;
    }%></TD>
    <%}

    %>
  </TR>
<%
    es.addExcelRow(er) ;
}
  }
 // 统计
    //---------------------------------------
    List newTempStatValues = new ArrayList();
    for (Iterator it = rowNames.iterator();it.hasNext();) {
    	String rowName = (String) it.next();
    	Object obj = statisticsRowKv.get(rowName);
    	String tval = "";
    	if (obj != null) {
    		StringBuffer totalSql = new StringBuffer();
    		Boolean blnobj = (Boolean)obj;
    		boolean isTotal = blnobj.booleanValue(); 
    		
    		if (isTotal) {
    			totalSql.append("select sum(t2.rowsum) as rowsum from ( select Avg(tbl." + rowName + ") as rowsum from ( ");
    			totalSql.append(sql);
    			totalSql.append(" ) tbl group by tbl.requestid) t2");
    		} else {
    			if (isNewBill) {
	    			totalSql.append("select sum(t2.rowsum) as rowsum from ( select Avg(tbl." + rowName + ") as rowsum from ( ");
	    			totalSql.append(sql);
	    			totalSql.append(" ) tbl group by tbl." + rowName.substring(0, rowName.lastIndexOf("__") + 1) + "id_) t2");
    			} else {
    				totalSql.append("select sum(t2.rowsum) as rowsum from ( select Avg(tbl." + rowName + ") as rowsum from ( ");
	    			totalSql.append(sql);
	    			totalSql.append(" ) tbl group by tbl." + rowName + ") t2");
    			}
    		}
    		RecordSet.execute(totalSql.toString());
    		if (RecordSet.next()) {
    			tval = String.valueOf(Util.getDoubleValue(Util.null2String(RecordSet.getString("rowsum")), 0));
    		} else {
    			tval = "0.00";
    		}
    	}else {
    		tval = "";
    	}
    	newTempStatValues.add(tval);
    }
    //----------------------------------------
    // end

if(statcount != 0 && !isfirst ) {
    er = es.newExcelRow () ;
        %>
        <TR class=TOTAL style="FONT-WEIGHT: bold">
            <% for(int i =0 ; i< tempstatvalues.size() ; i++) {
                er.addValue(formatDataTotal((String)tempstatvalues.get(i))) ;
            %>
            <TD><%=formatDataTotal((String)tempstatvalues.get(i))%></TD>
            <%tempstatvalues.set(i,"") ; }%>
        </tr>
<%
es.addExcelRow(er) ;
}
%>
<%
    er = es.newExcelRow () ;
%>
<TR class=TOTAL style="FONT-WEIGHT: bold">
            <% for(int i =0 ; i< newTempStatValues.size() ; i++) {
                er.addValue(formatDataTotal((String)newTempStatValues.get(i))) ;
            %>
            <TD><%=formatDataTotal((String)newTempStatValues.get(i))%></TD>
            <%newTempStatValues.set(i,"") ; }%>
            </tr>
<%
    es.addExcelRow(er) ;
    
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


<%!

private String delHtml(final String inputString) {

    String htmlStr = new weaver.workflow.mode.FieldInfo().toExcel(inputString); // 含html标签的字符串
    htmlStr = Util.StringReplace(htmlStr, "<script>initFlashVideo();</script>", "");
    String textStr = "";
    java.util.regex.Pattern p_script;
    java.util.regex.Matcher m_script;
    java.util.regex.Pattern p_html;
    java.util.regex.Matcher m_html;

    try {
        String regEx_html = "<[^>]+>"; // 定义HTML标签的正则表达式

        String regEx_script = "<[/s]*?script[^>]*?>[/s/S]*?<[/s]*?//[/s]*?script[/s]*?>"; // 定义script的正则表达式{或<script[^>]*?>[/s/S]*?<//script>

        p_script = java.util.regex.Pattern.compile(regEx_script, java.util.regex.Pattern.CASE_INSENSITIVE);
        m_script = p_script.matcher(htmlStr);
        htmlStr = m_script.replaceAll(""); // 过滤script标签

        p_html = java.util.regex.Pattern.compile(regEx_html, java.util.regex.Pattern.CASE_INSENSITIVE);
        m_html = p_html.matcher(htmlStr);
        htmlStr = m_html.replaceAll(""); // 过滤html标签

        textStr = htmlStr;

    } catch (Exception e) {
        //System.err.println("Html2Text: " + e.getMessage());
    }
    
    return Util.HTMLtoTxt(textStr).trim();// 返回文本字符串
}
%>

 <%
ExcelFile.init() ;
ExcelFile.setFilename(Util.toScreen(ReportComInfo.getReportname(reportid),user.getLanguage())) ;
ExcelFile.addSheet(Util.toScreen(ReportComInfo.getReportname(reportid),user.getLanguage()), es) ;
 %>
</BODY></HTML>

<script type="text/javascript">
<!--
setTimeout(function () {
	window.parent.document.getElementById("excelwaitDiv").style.display = "none";	
}, 1000);
window.location.href = "/weaver/weaver.file.ExcelOut";
//-->
</script>
