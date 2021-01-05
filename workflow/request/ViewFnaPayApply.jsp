<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@ page import="java.math.*" %>
<%@ page import="weaver.fna.budget.BudgetHandler"%>
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.fna.budget.BudgetHandler"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<form name="frmmain" method="post" action="FnaPayApplyOperation.jsp" enctype="multipart/form-data">
	   <jsp:include page="WorkflowViewRequestBodyAction.jsp" flush="true">
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="languageid" value="<%=languageidtemp%>" />
               
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="requestlevel" value="<%=requestlevel%>" />
                <jsp:param name="isbill" value="1" />
                <jsp:param name="billid" value="<%=billid%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="isprint" value="<%=isprint%>" />
                <jsp:param name="logintype" value="<%=logintype%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="nodetype" value="<%=nodetype%>" />
                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="isrequest" value="<%=isrequest%>" />
                <jsp:param name="isurger" value="<%=isurger%>" />
                <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />
            </jsp:include>
            <%
            RecordSet rs_11 = new RecordSet();

			ArrayList fieldids=new ArrayList();             //字段队列
			ArrayList fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
			ArrayList languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
			ArrayList fieldlabels=new ArrayList();          //单据的字段的label队列
			ArrayList fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
			ArrayList fieldtypes=new ArrayList();           //单据的字段的type队列
			ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
			ArrayList fieldvalues=new ArrayList();          //字段的值
			ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)

             String uid=""+creater;
             String uname=ResourceComInfo.getLastname(uid);
             String udept=ResourceComInfo.getDepartmentID(uid);
             String udeptname= DepartmentComInfo.getDepartmentname(udept);
             String usubcom=DepartmentComInfo.getSubcompanyid1(udept);
             weaver.hrm.company.SubCompanyComInfo scci=new weaver.hrm.company.SubCompanyComInfo();
             String usubcomname=scci.getSubCompanyname(usubcom);


            int colcount = 0 ;
            int colwidth = 0 ;
            fieldids.clear() ;
            fieldlabels.clear() ;
            fieldhtmltypes.clear() ;
            fieldtypes.clear() ;
            fieldnames.clear() ;
            fieldviewtypes.clear() ;
            String temporganizationidisview="0";
            String temprogtypeisview="0";

            RecordSet.executeProc("workflow_billfield_Select",formid+"");
            while(RecordSet.next()){
                String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
                if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示

                fieldids.add(Util.null2String(RecordSet.getString("id")));
                fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
                fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
                fieldtypes.add(Util.null2String(RecordSet.getString("type")));
                fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
                fieldviewtypes.add(theviewtype);
            }
			// 确定字段是否显示
			ArrayList isfieldids=new ArrayList();              //字段队列
			ArrayList isviews=new ArrayList();              //字段是否显示队列
            // 确定字段是否显示，是否可以编辑，是否必须输入
            isfieldids.clear() ;              //字段队列
            isviews.clear() ;              //字段是否显示队列

            RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
            while(RecordSet.next()){
                String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
                int thefieldidindex = fieldids.indexOf( thefieldid ) ;
                if( thefieldidindex == -1 ) continue ;
                String theisview = Util.null2String(RecordSet.getString("isview")) ;
                String thefieldname=(String)fieldnames.get(thefieldidindex);
                if(thefieldname.equals("organizationid")) temporganizationidisview=theisview;
                if(thefieldname.equals("organizationtype")) temprogtypeisview=theisview;
                if( theisview.equals("1") ) colcount ++ ;
                isfieldids.add(thefieldid);
                isviews.add(theisview);
            }
            if(temporganizationidisview.equals("1")&&temprogtypeisview.equals("0")) colcount++;
            if( colcount != 0 ) colwidth = 95/colcount ;

            ArrayList viewfieldnames = new ArrayList() ;

            BigDecimal amountsum = new BigDecimal("0") ;
            BigDecimal applyamountsum = new BigDecimal("0") ;
            int quantitysum = 0 ;
            boolean isttLight = false;
    %>
<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(27575,user.getLanguage()) %>'>
		<wea:item type="groupHead">
			&nbsp;
		</wea:item>
		<wea:item attributes="{\"isTableList\":\"true\"}">
            <table class="ListStyle" cellspacing=1   id="oTable">
              <COLGROUP>
              <tr class=header>
              <td width="5%">&nbsp;</td>
   <%

            // 得到每个字段的信息并在页面显示

            for(int i=0;i<fieldids.size();i++){         // 循环开始

                String fieldid=(String)fieldids.get(i);  //字段id
                String isview="0" ;    //字段是否显示

                int isfieldidindex = isfieldids.indexOf(fieldid) ;
                if( isfieldidindex != -1 ) {
                    isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                }
                String fieldname = "" ;                         //字段数据库表中的字段名
                String fieldlable = "" ;                        //字段显示名
                int languageid = 0 ;

                fieldname=(String)fieldnames.get(i);
                if(! isview.equals("1") &&fieldname.equals("organizationtype")) isview=temporganizationidisview;
                if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环


                languageid = user.getLanguage() ;
                fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),languageid );

                viewfieldnames.add(fieldname) ;
%>
                <td width="<%=colwidth%>%"><%=fieldlable%></td>
<%          }
%>
			  </tr>
<%
            sql="select *  from Bill_FnaPayApplyDetail where id="+billid+" order by dsporder";
            RecordSet.executeSql(sql);
            while(RecordSet.next()) {
										int organizationtype = RecordSet.getInt("organizationtype");
                    int organizationid = RecordSet.getInt("organizationid");
                    String budgetperiod = RecordSet.getString("budgetperiod");
                    int subject = RecordSet.getInt("subject");
                    BudgetHandler bp = new BudgetHandler();
                    String kpi = bp.getBudgetKPI(budgetperiod, organizationtype, organizationid, subject,true);
                    String[] kpiArray = kpi.split("\\|");
                    String[] kpi1 = kpiArray[0].split(",");
                    String kpi11 = kpi1[0];
                    String kpi12 = kpi1[1];
                    String kpi13 = kpi1[2];
                     String span1 = "<span><span style='white-space :nowrap'>" + SystemEnv.getHtmlLabelName(18768, user.getLanguage()) + ":" + Util.round(kpi11, 2) + "</span><br><span style='white-space :nowrap;color:red'>" + SystemEnv.getHtmlLabelName(18503, user.getLanguage()) + ":" + Util.round(kpi12, 2) + "</span><br><span style='white-space :nowrap;color:green'> " + SystemEnv.getHtmlLabelName(18769, user.getLanguage()) + ":" + Util.round(kpi13, 2) + "</span></span>";

                     String[] kpi2 = kpiArray[1].split(",");
                     String kpi21 = kpi2[0];
                     String kpi22 = kpi2[1];
                     String kpi23 = kpi2[2];
                    String span2 = "<span><span style='white-space :nowrap'>" + SystemEnv.getHtmlLabelName(18768, user.getLanguage()) + ":" + Util.round(kpi21, 2) + "</span><br><span style='white-space :nowrap;color:red'>" + SystemEnv.getHtmlLabelName(18503, user.getLanguage()) + ":" + Util.round(kpi22, 2) + "</span><br><span style='white-space :nowrap;color:green'>" + SystemEnv.getHtmlLabelName(18769, user.getLanguage()) + ":" + Util.round(kpi23, 2) + "</span></span>";

                    String[] kpi3 = kpiArray[2].split(",");
                    String kpi31 = kpi3[0];
                    String kpi32 = kpi3[1];
                    String kpi33 = kpi3[2];
                    String span3 = "<span><span style='white-space :nowrap'>" + SystemEnv.getHtmlLabelName(18768, user.getLanguage()) + ":" + Util.round(kpi31, 2) + "</span><br><span style='white-space :nowrap;color:red'>" + SystemEnv.getHtmlLabelName(18503, user.getLanguage()) + ":" + Util.round(kpi32, 2) + "</span><br><span style='white-space :nowrap;color:green'>" + SystemEnv.getHtmlLabelName(18769, user.getLanguage()) + ":" + Util.round(kpi33, 2) + "</span></span>";

                    String[] kpi4 = kpiArray[3].split(",");
                    String kpi41 = kpi4[0];
                    String kpi42 = kpi4[1];
                    String kpi43 = kpi4[2];
                    String span4 = "<span><span style='white-space :nowrap'>" + SystemEnv.getHtmlLabelName(18768, user.getLanguage()) + ":" + Util.round(kpi41, 2) + "</span><br><span style='white-space :nowrap;color:red'>" + SystemEnv.getHtmlLabelName(18503, user.getLanguage()) + ":" + Util.round(kpi42, 2) + "</span><br><span style='white-space :nowrap;color:green'>" + SystemEnv.getHtmlLabelName(18769, user.getLanguage()) + ":" + Util.round(kpi43, 2) + "</span></span>";

                isttLight = !isttLight ;
%>
              <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
                <td width="5%">&nbsp;</td>
<%
                for(int i=0;i<fieldids.size();i++){         // 循环开始

                    String fieldid=(String)fieldids.get(i);  //字段id
                    String isview="0" ;    //字段是否显示

                    int isfieldidindex = isfieldids.indexOf(fieldid) ;
                    if( isfieldidindex != -1 ) {
                        isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                    }

                    String fieldname = (String)fieldnames.get(i);   //字段数据库表中的字段名
                    if(! isview.equals("1") &&fieldname.equals("organizationtype")) isview=temporganizationidisview;
                    if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环
                    String fieldvalue =  Util.null2String(RecordSet.getString(fieldname)) ;

                    if( fieldname.equals("organizationtype")){
                        String orgtype=Util.null2String(RecordSet.getString("organizationtype"));
                        if(orgtype.equals("3")){
                        fieldvalue=SystemEnv.getHtmlLabelName(6087,user.getLanguage());
                        }else if(orgtype.equals("2")){
                        fieldvalue=SystemEnv.getHtmlLabelName(124,user.getLanguage());
                        }else if(orgtype.equals("1")){
                        fieldvalue=SystemEnv.getHtmlLabelName(141,user.getLanguage());
                        }else if(orgtype.equals((FnaCostCenter.ORGANIZATION_TYPE+""))){
                        	fieldvalue = SystemEnv.getHtmlLabelName(515,user.getLanguage());
                        }

                    }else if( fieldname.equals("organizationid")){
                        String orgtype=Util.null2String(RecordSet.getString("organizationtype"));
                        String orgid=Util.null2String(RecordSet.getString("organizationid"));
                        if(orgtype.equals("3")){
                        fieldvalue="<A href='javaScript:openhrm("+fieldvalue+");' onclick='pointerXY(event);'>"+Util.toScreen(ResourceComInfo.getLastname(fieldvalue),user.getLanguage()) +"</A>";
                        if(!orgid.equals(uid)) fieldvalue="<div style='background:#ff9999'>"+fieldvalue+"</div>";
                        }else if(orgtype.equals("2")){
                        fieldvalue="<A href='/hrm/company/HrmDepartmentDsp.jsp?id="+fieldvalue+"'>"+Util.toScreen(DepartmentComInfo.getDepartmentname(fieldvalue),user.getLanguage()) +"</A>";
                        if(!orgid.equals(udept)) fieldvalue="<div style='background:#ff9999'>"+fieldvalue+"</div>";
                        }else if(orgtype.equals("1")){
                        fieldvalue="<A href='/hrm/company/HrmSubCompanyDsp.jsp?id="+fieldvalue+"'>"+Util.toScreen(SubCompanyComInfo.getSubCompanyname(fieldvalue),user.getLanguage())+"</A>";
                        if(!orgid.equals(usubcom)) fieldvalue="<div style='background:#ff9999'>"+fieldvalue+"</div>";
                        }else if(orgtype.equals((FnaCostCenter.ORGANIZATION_TYPE+""))){
                        	rs_11.executeSql("select name from FnaCostCenter where id = "+Util.getIntValue(fieldvalue));
                        	fieldvalue = "";
                        	if(rs_11.next()){
                        		fieldvalue = Util.null2String(rs_11.getString("name")).trim();
                        	}
                        }

                        }else if( fieldname.equals("relatedprj"))
                        fieldvalue = "<A href='/proj/data/ViewProject.jsp?isrequest=1&ProjID="+fieldvalue+"'>"+Util.toScreen(ProjectInfoComInfo.getProjectInfoname(fieldvalue),user.getLanguage()) +"</A>";
                    else if( fieldname.equals("relatedcrm"))
                        fieldvalue = "<A href='/CRM/data/ViewCustomer.jsp?isrequest=1&CustomerID="+fieldvalue+"'>"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(fieldvalue),user.getLanguage()) +"</A>";
                    else if( fieldname.equals("subject")){
                    	String key = fieldvalue;
                        fieldvalue = Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(fieldvalue),user.getLanguage()) ;
                        if(!"".equals(fieldvalue)){
                        	//查询父级科目
    						String sqlSet = "select enableDispalyAll,separator from FnaSystemSet";//查询
    						rs.executeSql(sqlSet);
    						int enableDispalyAll=0;
    						String separator ="";
    						while(rs.next()){
    							enableDispalyAll = rs.getInt("enableDispalyAll");
    							separator = Util.null2String(rs.getString("separator"));
    						}
    						if(enableDispalyAll==1){
    							fieldvalue = BudgetfeeTypeComInfo.getSubjectFullName(key, separator);;
    						}
                        }
	                  	
                    }
                    else if( fieldname.equals("hrmremain"))
                        fieldvalue = span1 ;
                    else if( fieldname.equals("deptremain"))
                        fieldvalue = span2 ;
                    else if( fieldname.equals("subcomremain"))
                        fieldvalue = span3 ;
                    else if( fieldname.equals("fccremain"))
                        fieldvalue = span4 ;
                    else if( fieldname.equals("amount")) {
                        if( Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue="" ;
                        else
                            amountsum = amountsum.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
                    }else if( fieldname.equals("applyamount")) {
                        if( Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue="" ;
                        else
                            applyamountsum = applyamountsum.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
                    }



%>
                <td><%=fieldvalue%></td>
<%              }   %>
              </tr>
<%          }   %>
              <tr class="header" style="FONT-WEIGHT: bold; COLOR: red">
                <td><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></td>
<%          for(int i=0;i<viewfieldnames.size();i++){
                String thefieldname = (String)viewfieldnames.get(i) ;

%>
                <td><%  if(thefieldname.equals("amount")) {

                        amountsum = amountsum.divide ( new BigDecimal ( 1 ), 3, BigDecimal.ROUND_HALF_UP ) ;
                        String amountsumstr = "" ;
                        if( amountsum.doubleValue() != 0 ) amountsumstr = ""+amountsum.doubleValue() ;
                    %><%=amountsum%>
                    <% }  else { %>&nbsp;<%}%>
                    <%  if(thefieldname.equals("applyamount")) {
                    applyamountsum = applyamountsum.divide ( new BigDecimal ( 1 ), 3, BigDecimal.ROUND_HALF_UP ) ;
                        String applyamountsumstr = "" ;
                        if( applyamountsum.doubleValue() != 0 ) applyamountsumstr = ""+applyamountsum.doubleValue() ;
                    %><%=applyamountsum%>
                     <% }  else { %>&nbsp;<%}%>
                </td>
<%          }
%>
              </tr>
            </table>
		</wea:item>
	</wea:group>
</wea:layout>

    <br>
    <%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
</form>

