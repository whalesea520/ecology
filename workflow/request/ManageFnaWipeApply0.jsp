 <%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ page import="java.math.*,weaver.general.Util" %>
 <%@ page import="weaver.fna.budget.BudgetHandler"%>
 <%@ page import="weaver.systeminfo.SystemEnv" %>
 <%@ page import="java.util.ArrayList" %>
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>
 <jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
 <jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
 <jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
 <jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
 <jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<%!
     private static Map mapFormatter = null;
	private static String getFormatValue(int decimalPlaces){
		if(mapFormatter == null){
			mapFormatter = new HashMap();
			mapFormatter.put(1, "0.0");
			mapFormatter.put(2, "0.00");
			mapFormatter.put(3, "0.000");
			mapFormatter.put(4, "0.0000");
		}
		
		String formatValue = (String)mapFormatter.get(decimalPlaces);
		formatValue = (formatValue == null) ? "0.000" : formatValue;
		return formatValue;
	}
%>
 <%
 RecordSet rs_11 = new RecordSet();
 boolean fnaBudgetOAOrg = false;//OA组织机构
 boolean fnaBudgetCostCenter = false;//成本中心
 boolean subjectFilter = false;
 rs_11.executeSql("select * from FnaSystemSet");
 if(rs_11.next()){
 	fnaBudgetOAOrg = 1==rs_11.getInt("fnaBudgetOAOrg");
 	fnaBudgetCostCenter = 1==rs_11.getInt("fnaBudgetCostCenter");
	subjectFilter = 1==Util.getIntValue(rs_11.getString("subjectFilter"), 0);
 }
 
 int subjectFieldId = 0;
 int organizationidFieldId = 0;
 RecordSet.executeSql("select * from workflow_billfield where  billid = 158");
 while(RecordSet.next()){
 	String fieldname = Util.null2String(RecordSet.getString("fieldname")).trim();
 	if(fieldname.equals("subject")){
 		subjectFieldId = RecordSet.getInt("id");
 	}else if(fieldname.equals("organizationid")){
 		organizationidFieldId = RecordSet.getInt("id");
 	}
 }
 
ArrayList fieldids = (ArrayList) session.getAttribute(requestid+"_fieldids");             //字段队列
ArrayList fieldorders = (ArrayList) session.getAttribute(requestid+"_fieldorders");        //字段显示顺序队列 (单据文件不需要)
ArrayList languageids = (ArrayList) session.getAttribute(requestid+"_languageids");          //字段显示的语言(单据文件不需要)
ArrayList fieldlabels = (ArrayList) session.getAttribute(requestid+"_fieldlabels");          //单据的字段的label队列
ArrayList fieldhtmltypes = (ArrayList) session.getAttribute(requestid+"_fieldhtmltypes");       //单据的字段的html type队列
ArrayList fieldtypes = (ArrayList) session.getAttribute(requestid+"_fieldtypes");           //单据的字段的type队列
ArrayList fieldnames = (ArrayList) session.getAttribute(requestid+"_fieldnames");           //单据的字段的表字段名队列
ArrayList fieldvalues = (ArrayList) session.getAttribute(requestid+"_fieldvalues");          //字段的值
ArrayList fieldviewtypes = (ArrayList) session.getAttribute(requestid+"_fieldviewtypes");       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
ArrayList isfieldids = (ArrayList) session.getAttribute(requestid+"_isfieldids");              //字段队列
ArrayList isviews = (ArrayList) session.getAttribute(requestid+"_isviews");              //字段是否显示队列
ArrayList isedits = (ArrayList) session.getAttribute(requestid+"_isedits");              //字段是否可以编辑队列
ArrayList ismands = (ArrayList) session.getAttribute(requestid+"_ismands");              //字段是否必须输入队列
String isaffirmancebody=Util.null2String(request.getParameter("isaffirmancebody"));
String reEditbody=Util.null2String(request.getParameter("reEditbody"));

String bclick="";
String conStr="";

    //获取明细表设置
                WFNodeDtlFieldManager.resetParameter();
                WFNodeDtlFieldManager.setNodeid(Util.getIntValue(""+nodeid));
                WFNodeDtlFieldManager.setGroupid(0);
                WFNodeDtlFieldManager.selectWfNodeDtlField();
                String dtladd = WFNodeDtlFieldManager.getIsadd();
                String dtledit = WFNodeDtlFieldManager.getIsedit();
                String dtldelete = WFNodeDtlFieldManager.getIsdelete();
                String dtldefault = WFNodeDtlFieldManager.getIsdefault();
                String dtlneed = WFNodeDtlFieldManager.getIsneed();
                int applyamountdb = 2;
                RecordSet.executeSql(" select fielddbtype from workflow_billfield where  billid = 158 and  fieldname = 'applyamount' ");
                if(RecordSet.next()){
              	  String fieldbtype=RecordSet.getString("fielddbtype");
              	  if(fieldbtype != null && !"".equals(fieldbtype)){
              		  int digitsIndex = fieldbtype.indexOf(",");
    		        	if(digitsIndex > -1){
    		        		applyamountdb = Util.getIntValue(fieldbtype.substring(digitsIndex+1, fieldbtype.length()-1), 2);
    		        	}else{
    		        		applyamountdb = 2;
    		        	}
              		  
              	  }
                }
                int amountdb = 2;
                RecordSet.executeSql(" select fielddbtype from workflow_billfield where  billid = 158 and  fieldname = 'amount' ");
                if(RecordSet.next()){
              	  String fieldbtype=RecordSet.getString("fielddbtype");
              	  if(fieldbtype != null && !"".equals(fieldbtype)){
              		  int digitsIndex = fieldbtype.indexOf(",");
    		        	if(digitsIndex > -1){
    		        		amountdb = Util.getIntValue(fieldbtype.substring(digitsIndex+1, fieldbtype.length()-1), 2);
    		        	}else{
    		        		amountdb = 2;
    		        	}
              		  
              	  }
                }
                
                int totaldb = 2;
                RecordSet.executeSql(" select fielddbtype from workflow_billfield where  billid = 158 and  fieldname = 'total' ");
                if(RecordSet.next()){
              	  String fieldbtype=RecordSet.getString("fielddbtype");
              	  if(fieldbtype != null && !"".equals(fieldbtype)){
              		  int digitsIndex = fieldbtype.indexOf(",");
    		        	if(digitsIndex > -1){
    		        		totaldb = Util.getIntValue(fieldbtype.substring(digitsIndex+1, fieldbtype.length()-1), 2);
    		        	}else{
    		        		totaldb = 2;
    		        	}
              		  
              	  }
                }
    %>
     <script language=javascript>
         fieldorders = new Array() ;
         isedits = new Array() ;
         ismands = new Array() ;
         var organizationidismand=0;
         var organizationidisedit=0;
     </script>
     <style id="balancestyle">
        td.balancehide {
            display:none;
        }
    </style>
	<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
     <script type='text/javascript' src='/dwr/interface/BudgetHandler.js'></script>
     <script type='text/javascript' src='/dwr/engine.js'></script>
     <script type='text/javascript' src='/dwr/util.js'></script>
	<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script type="text/javascript">
var browserUtl_subject = "<%=new BrowserComInfo().getBrowserurl("22") %>";
var browserUtl_hrm = "<%=new BrowserComInfo().getBrowserurl("1") %>%3Fshow_virtual_org=-1";
var browserUtl_dep = "<%=new BrowserComInfo().getBrowserurl("4") %>%3Fshow_virtual_org=-1";
var browserUtl_sub = "<%=new BrowserComInfo().getBrowserurl("164") %>%3Fshow_virtual_org=-1";
var browserUtl_prj = "<%=new BrowserComInfo().getBrowserurl("8") %>";
var browserUtl_crm = "<%=new BrowserComInfo().getBrowserurl("7") %>";
var browserUtl_fcc = "<%=new BrowserComInfo().getBrowserurl("251") %>";
var _FnaBillRequestJsFlag = 1;
</script>

            <%
                String uid=""+creater;

                String uname = ResourceComInfo.getLastname(uid);
                String udept = ""+Util.getIntValue(ResourceComInfo.getDepartmentID(uid));
                String udeptname = DepartmentComInfo.getDepartmentname(udept);
                String usubcom = ""+Util.getIntValue(DepartmentComInfo.getSubcompanyid1(udept));
                weaver.hrm.company.SubCompanyComInfo scci = new weaver.hrm.company.SubCompanyComInfo();
                String usubcomname = scci.getSubCompanyname(usubcom);
                RecordSet.executeSql("select sum(amount) from fnaloaninfo where organizationtype=3 and organizationid="+uid);
                RecordSet.next();
                double applicantloanamount=Util.getDoubleValue(RecordSet.getString(1),0);
             int colcount = 0 ;
             int colwidth = 0 ;
             fieldids.clear() ;
             fieldlabels.clear() ;
             fieldhtmltypes.clear() ;
             fieldtypes.clear() ;
             fieldnames.clear() ;
             fieldviewtypes.clear() ;
             String temporganizationidisview="0";
             String temporganizationidisedit="0";
             String temporganizationidismandatory="0";
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

             // 确定字段是否显示，是否可以编辑，是否必须输入
             isfieldids.clear() ;              //字段队列
             isviews.clear() ;              //字段是否显示队列
             isedits.clear() ;              //字段是否可以编辑队列
             ismands.clear() ;              //字段是否必须输入队列

             RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
             while(RecordSet.next()){
                 String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
                 int thefieldidindex = fieldids.indexOf( thefieldid ) ;
                 if( thefieldidindex == -1 ) continue ;
                 String theisview = Util.null2String(RecordSet.getString("isview")) ;
                 String theisedit = Util.null2String(RecordSet.getString("isedit"));
                 String theismandatory = Util.null2String(RecordSet.getString("ismandatory"));
                 String thefieldname=(String)fieldnames.get(thefieldidindex);
//                 if(nodetype.equals("0")){
//                     if(thefieldname.equals("organizationtype")||thefieldname.equals("organizationid")||thefieldname.equals("budgetperiod")||thefieldname.equals("subject")){
//                        theisview="1";
//                        theisedit="1";
//                        theismandatory="1";
//                    }
//                 }
                 if(thefieldname.equals("organizationid")){
                     temporganizationidisview=theisview;
                     temporganizationidisedit=theisedit;
                     temporganizationidismandatory=theismandatory;
                 }
                 if(thefieldname.equals("organizationtype")) temprogtypeisview=theisview;
                 if( theisview.equals("1") ) colcount ++ ;
                 isfieldids.add(thefieldid);
                 isviews.add(theisview);
                 isedits.add(theisedit);
                 ismands.add(theismandatory);
             }
             if(temporganizationidisview.equals("1")&&temprogtypeisview.equals("0")) colcount++;
             if( colcount != 0 ) colwidth = 95/colcount ;

             ArrayList viewfieldnames = new ArrayList() ;

             // 得到每个字段的信息并在页面显示
             int detailfieldcount = -1 ;
             String needcheckdtl="";
             

             BigDecimal amountsum = new BigDecimal("0") ;
             BigDecimal applyamountsum = new BigDecimal("0") ;
             int attachcountsum = 0 ;
             boolean isttLight = false;
             int recorderindex = 0 ;
    %>
<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(27575,user.getLanguage()) %>'>
		<wea:item type="groupHead">
			&nbsp;
        <% if((!isaffirmancebody.equals("1")|| reEditbody.equals("1"))
			 ) { %>
            <%if(dtladd.equals("1")){%>
            <input type=button  Class="addbtn" type=button accessKey=A onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
            <%}
            if(dtladd.equals("1") || dtldelete.equals("1")){%>
            <input type=button  Class="delbtn" type=button accessKey=E onclick="deleteRow1();" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></input>
            <%}%>
        <%  } %>
		</wea:item>
		<wea:item attributes="{\"isTableList\":\"true\"}">
             <table class=ListStyle cellspacing=1   id="oTable">
               <COLGROUP>
               <tr class=header>
               <td width="5%">&nbsp;</td>
   <%
             for(int i=0;i<fieldids.size();i++){         // 循环开始

                 String fieldid=(String)fieldids.get(i);  //字段id
                 String isview="0" ;    //字段是否显示
                 String isedit="0" ;    //字段是否可以编辑
                 String ismand="0" ;    //字段是否必须输入

                 int isfieldidindex = isfieldids.indexOf(fieldid) ;
                 if( isfieldidindex != -1 ) {
                     isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                     isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
                     ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
                 }
                 String fieldname = "" ;                         //字段数据库表中的字段名
                 String fieldlable = "" ;                        //字段显示名
                 int languageid = 0 ;

                 fieldname=(String)fieldnames.get(i);
                 if(! isview.equals("1") &&fieldname.equals("organizationtype")){
                    isview=temporganizationidisview;
                    isedit=temporganizationidisedit;
                    ismand=temporganizationidismandatory;
                 }
                 if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环


                 languageid = user.getLanguage() ;
                 fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),languageid );

                 viewfieldnames.add(fieldname) ;
%>
                 <td width="<%=colwidth%>%" <%if (fieldname.equals("loanbalance")) {%> class=balancehide<%}%>><%=fieldlable%></td>
                 <script language=javascript>
                    <% if (fieldname.equals("organizationid")) { detailfieldcount++ ;
                       if(ismand.equals("1")) needcheckdtl += ",organizationid_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 1 ;
                     organizationidismand=<%=ismand%>;
                     organizationidisedit=<%=isedit%>;
                    <% } else if (fieldname.equals("subject")) { detailfieldcount++ ;
                       if(ismand.equals("1")) needcheckdtl += ",subject_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 2 ;
                    <% } else if (fieldname.equals("budgetperiod")) { detailfieldcount++ ;
                       if(ismand.equals("1")) needcheckdtl += ",budgetperiod_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 3 ;
                    <% } else if (fieldname.equals("attachcount")) { detailfieldcount++ ;
                       if(ismand.equals("1")) needcheckdtl += ",attachcount_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 4 ;
                    <% }else if (fieldname.equals("hrmremain")) { detailfieldcount++ ;
                       if(ismand.equals("1")) needcheckdtl += ",hrmremain_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 5 ;
                    <% } else if (fieldname.equals("deptremain")) { detailfieldcount++ ;
                       if(ismand.equals("1")) needcheckdtl += ",deptremain_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 6 ;
                    <% } else if (fieldname.equals("subcomremain")) { detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",subcomremain_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 7 ;
                    <% } else if (fieldname.equals("loanbalance")) { detailfieldcount++ ;
                       if(ismand.equals("1")) needcheckdtl += ",loanbalance_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 8 ;
                    <% } else if (fieldname.equals("relatedprj")) { detailfieldcount++ ;
                       if(ismand.equals("1")) needcheckdtl += ",relatedprj_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 9 ;
                    <% } else if (fieldname.equals("relatedcrm")) { detailfieldcount++ ;
                       if(ismand.equals("1")) needcheckdtl += ",relatedcrm_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 10 ;
                    <% } else if (fieldname.equals("description")) { detailfieldcount++ ;
                       if(ismand.equals("1")) needcheckdtl += ",description_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 11 ;
                    <% } else if (fieldname.equals("applyamount")) { detailfieldcount++ ;
                        if(ismand.equals("1")) needcheckdtl += ",applyamount_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 12 ;
                    <% } else if (fieldname.equals("amount")) { detailfieldcount++ ;
                         if(ismand.equals("1")) needcheckdtl += ",amount_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 13 ;
                    <% } else if (fieldname.equals("organizationtype")) { detailfieldcount++ ;
                         if(ismand.equals("1")) needcheckdtl += ",organizationtype_\"+insertindex+\"";
                    %>
                     fieldorders[<%=detailfieldcount%>] = 14 ;
                    <% } else if (fieldname.equals("fccremain")) { detailfieldcount++ ;
                     	 if(ismand.equals("1")) needcheckdtl += ",fccremain_\"+insertindex+\"";
	                %>
	                 fieldorders[<%=detailfieldcount%>] = 999 ;
                    <% } %>
                     isedits[<%=detailfieldcount%>] = <%=isedit%> ;
                     ismands[<%=detailfieldcount%>] = <%=ismand%> ;
                 </script>
<%          }
%>
               </tr>
<%
             sql="select *  from Bill_FnaWipeApplyDetail where id="+billid +" order by dsporder";
             RecordSet.executeSql(sql);
             while(RecordSet.next()) {
                     int organizationtype = RecordSet.getInt("organizationtype");
                    int organizationid = RecordSet.getInt("organizationid");
                    String budgetperiod = RecordSet.getString("budgetperiod");
                    int subject = RecordSet.getInt("subject");
                    double tempappamount=Util.getDoubleValue(RecordSet.getString("applyamount"),0);
                    BudgetHandler bp = new BudgetHandler();

                     double loanamount = bp.getLoanAmount(organizationtype, organizationid);
                     String kpi = bp.getBudgetKPI(budgetperiod,organizationtype,organizationid,subject,true);
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
                     String span3 = "<span><span style='white-space :nowrap'>" + SystemEnv.getHtmlLabelName(18768, user.getLanguage()) + ":" + Util.round(kpi31,2) + "</span><br><span style='white-space :nowrap;color:red'>" + SystemEnv.getHtmlLabelName(18503, user.getLanguage()) + ":" + Util.round(kpi32,2) + "</span><br><span style='white-space :nowrap;color:green'>" + SystemEnv.getHtmlLabelName(18769, user.getLanguage()) + ":" + Util.round(kpi33,2) + "</span></span>";

                     String[] kpi4 = kpiArray[3].split(",");
                     String kpi41 = kpi4[0];
                     String kpi42 = kpi4[1];
                     String kpi43 = kpi4[2];
                     String span4 = "<span><span style='white-space :nowrap'>" + SystemEnv.getHtmlLabelName(18768, user.getLanguage()) + ":" + Util.round(kpi41, 2) + "</span><br><span style='white-space :nowrap;color:red'>" + SystemEnv.getHtmlLabelName(18503, user.getLanguage()) + ":" + Util.round(kpi42, 2) + "</span><br><span style='white-space :nowrap;color:green'>" + SystemEnv.getHtmlLabelName(18769, user.getLanguage()) + ":" + Util.round(kpi43, 2) + "</span></span>";

                 isttLight = !isttLight ;
%>
               <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
                 <td width="5%"><% if((!isaffirmancebody.equals("1")|| reEditbody.equals("1")) ) { %><input type='checkbox' name='check_node' value='<%=recorderindex%>' <%if(!dtldelete.equals("1")){%>disabled<%}%>><% } else { %>&nbsp;<% } %></td>
<%
                 for(int i=0;i<fieldids.size();i++){         // 循环开始

                     String fieldid=(String)fieldids.get(i);  //字段id
                     String isview="0" ;    //字段是否显示
                     String isedit="0" ;    //字段是否可以编辑
                     String ismand="0" ;    //字段是否必须输入

                     int isfieldidindex = isfieldids.indexOf(fieldid) ;
                     if( isfieldidindex != -1 ) {
                         isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                         isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
                         ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
                     }
                     if(!"1".equals(dtledit)){
                        isedit="0";
				    }
                     String fieldname = (String)fieldnames.get(i);   //字段数据库表中的字段名
                     String fieldvalue =  Util.null2String(RecordSet.getString(fieldname)) ;
					 if(fieldname.equals("total") && !"".equals(fieldvalue)){
						  fieldvalue = new java.text.DecimalFormat(getFormatValue(totaldb)).format(Double.parseDouble(fieldvalue));
					 }
					 if(fieldname.equals("applyamount")&& !"".equals(fieldvalue)){
						 fieldvalue = new java.text.DecimalFormat(getFormatValue(applyamountdb)).format(Double.parseDouble(fieldvalue));

					 }
					 if(fieldname.equals("amount")&& !"".equals(fieldvalue)){
                        fieldvalue = new java.text.DecimalFormat(getFormatValue(amountdb )).format(Double.parseDouble(fieldvalue));
					 }
					 String fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage() );
                     if(! isview.equals("1") &&fieldname.equals("organizationtype")){
                        isview=temporganizationidisview;
                        isedit=temporganizationidisedit;
                        ismand=temporganizationidismandatory;
                     }
                     if( ! isview.equals("1") ) {
%>
                     <input type=hidden name="<%=fieldname%>_<%=recorderindex%>" id="<%=fieldname%>_<%=recorderindex%>" value="<%=fieldvalue%>" />
<%
                     }
                     else {
                         if(ismand.equals("1"))  needcheck+= ","+fieldname+"_"+recorderindex;
                         //如果必须输入,加入必须输入的检查中
%>                  <td <%if (fieldname.equals("loanbalance")) {%> class=balancehide<%}%>>
<%
						String showname = "" ;
						if( fieldname.equals("organizationtype"))  {
							String orgtype= RecordSet.getString("organizationtype");
							if(orgtype.equals("3")){
								showname = SystemEnv.getHtmlLabelName(6087,user.getLanguage());
							}else if(orgtype.equals("2")){
								showname = SystemEnv.getHtmlLabelName(124,user.getLanguage());
							}else if(orgtype.equals("1")){
								showname = SystemEnv.getHtmlLabelName(141,user.getLanguage());
							}else if(orgtype.equals((FnaCostCenter.ORGANIZATION_TYPE+""))){
	                            showname = SystemEnv.getHtmlLabelName(515,user.getLanguage());
	                        }
							if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1")) ){
%>
					<select id="organizationtype_<%=recorderindex%>" name="organizationtype_<%=recorderindex%>" onchange="clearSpan(<%=recorderindex%>)">
                    <%if(fnaBudgetOAOrg){ %>
						<option value=3 <%if(RecordSet.getString("organizationtype").equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>
						<option value=2  <%if(RecordSet.getString("organizationtype").equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
						<option value=1 <%if(RecordSet.getString("organizationtype").equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                    <%} %>
                    <%if(fnaBudgetCostCenter){ %>
						<option value='<%=FnaCostCenter.ORGANIZATION_TYPE+"" %>' <%if(RecordSet.getString("organizationtype").equals(FnaCostCenter.ORGANIZATION_TYPE+"")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></option>
					<%} %>
					</select>
<%
							}else{
%>
					<input type=hidden id="organizationtype_<%=recorderindex%>" name="organizationtype_<%=recorderindex%>"  value="<%=RecordSet.getString("organizationtype")%>">
					<%=showname%>
<%
							}
						}else if( fieldname.equals("organizationid"))  {
							showname = "";
                            String orgtype= RecordSet.getString("organizationtype");
                            if(orgtype.equals("3")){
                            	showname = "<A href='/hrm/resource/HrmResource.jsp?id="+fieldvalue+"'>"+Util.toScreen(ResourceComInfo.getLastname(fieldvalue),user.getLanguage()) +"</A>";
                            }else if(orgtype.equals("2")){
                            	showname = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id="+fieldvalue+"'>"+Util.toScreen(DepartmentComInfo.getDepartmentname(fieldvalue),user.getLanguage()) +"</A>";
                            }else if(orgtype.equals("1")){
                            	showname = "<A href='/hrm/company/HrmSubCompanyDsp.jsp?id="+fieldvalue+"'>"+Util.toScreen(SubCompanyComInfo.getSubCompanyname(fieldvalue),user.getLanguage())+"</A>";
                            }else if(orgtype.equals((FnaCostCenter.ORGANIZATION_TYPE+""))){
                            	showname = "";
                            	rs_11.executeSql("select name from FnaCostCenter where id = "+Util.getIntValue(fieldvalue));
                            	if(rs_11.next()){
                            		showname = Util.null2String(rs_11.getString("name")).trim();
                            	}
                            }
							if( fieldvalue.equals("0") ) {
								fieldvalue = "" ;
							}
							if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1")) ){
%>
					<span id='organizationid_<%=recorderindex %>wrapspan'></span>
					<!-- 
					<input type=hidden viewtype="<%=ismand %>" id="organizationid_<%=recorderindex%>" name="organizationid_<%=recorderindex%>" value="<%=fieldvalue%>" />
					 -->
					<script type="text/javascript">
						jQuery(document).ready(function(){
			                <%if(fnaBudgetOAOrg){ %>
			                onShowOrganizationBtn(<%=ismand %>, <%=recorderindex %>, "<%=fieldvalue %>", "<%=showname %>");
			                <%}else if(fnaBudgetCostCenter){ %>
			                onShowOrganizationBtn(<%=ismand %>, <%=recorderindex %>, "", "");
			                <%} %>
						});
					</script>
<%
							}else{
%>
                <%if(fnaBudgetOAOrg){ %>
					<input type=hidden viewtype="<%=ismand %>" id="organizationid_<%=recorderindex%>" name="organizationid_<%=recorderindex%>" value="<%=fieldvalue%>" />
					<%=showname %>
			    <%} %>
<%							
							}
						}
						else if( fieldname.equals("subject")) {
							showname = Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(fieldvalue),user.getLanguage()) ;
							//查询父级科目
							if(!fieldvalue.equals("0")){
								String sqlSet = "select enableDispalyAll,separator from FnaSystemSet";//查询
								rs.executeSql(sqlSet);
								int enableDispalyAll=0;
								String separator ="";
								while(rs.next()){
									enableDispalyAll = rs.getInt("enableDispalyAll");
									separator = Util.null2String(rs.getString("separator"));
								}
								if(enableDispalyAll==1){
 									showname = BudgetfeeTypeComInfo.getSubjectFullName(fieldvalue, separator);;
								}
							}
							if( fieldvalue.equals("0") ) fieldvalue = "" ;
							if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1")) ){
								String isMustInput = "1";
								if("1".equals(ismand)){
									isMustInput = "2";
								}
%>
					<span id='subject_<%=recorderindex %>wrapspan'></span>
					<!-- 
					<input type="hidden" viewtype="<%=ismand %>" temptitle="" name="subject_<%=recorderindex%>" id="subject_<%=recorderindex%>" value="<%=fieldvalue%>" />
					 -->
					<script type="text/javascript">
						jQuery(document).ready(function(){
							var detailbrowclick = "onShowBrowser2_fna('subject_<%=recorderindex %>','"+browserUtl_subject+"','','22','<%=ismand %>')";
							onShowSubjectBtn("subject_<%=recorderindex %>", <%=recorderindex %>, <%=ismand %>, "<%=fieldvalue%>", "<%=showname%>", detailbrowclick, "/data.jsp?type=22" );
							//initE8Browser("subject_<%=recorderindex %>", <%=recorderindex %>, <%=ismand %>, "<%=fieldvalue%>", "<%=showname%>", detailbrowclick, "/data.jsp?type=22");
						});
					</script>
<%
							}else{
%>
					<input type="hidden" viewtype="<%=ismand %>" temptitle="" name="subject_<%=recorderindex%>" id="subject_<%=recorderindex%>" value="<%=fieldvalue%>" />
					<%=showname %>
<%		
							}
						}
						else if( fieldname.equals("budgetperiod")) {
							if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1")) ){
%>
					<span id='budgetperiod_<%=recorderindex %>wrapspan'></span>
					<!-- 
					<input type="hidden" viewtype="<%=ismand %>" temptitle="" name="budgetperiod_<%=recorderindex%>" id="budgetperiod_<%=recorderindex%>" value="<%=fieldvalue%>" />
					 -->
					<script type="text/javascript">
						jQuery(document).ready(function(){
							var detailbrowclick = "onShowBrowser2_fna('budgetperiod_<%=recorderindex %>','','','2','<%=ismand %>')";
							initE8Browser("budgetperiod_<%=recorderindex %>", <%=recorderindex %>, <%=ismand %>, "<%=fieldvalue%>", "<%=fieldvalue%>", detailbrowclick, "");
						});
					</script>
<%
							}else{
%>
					<input type="hidden" viewtype="<%=ismand %>" temptitle="" name="budgetperiod_<%=recorderindex%>" id="budgetperiod_<%=recorderindex%>" value="<%=fieldvalue%>" />
					<%=fieldvalue %>
<%		
							}
						}
						else if( fieldname.equals("attachcount")) {
							if( Util.getDoubleValue(fieldvalue,0) == 0 ) {
								fieldvalue="0" ;
							}else{
								attachcountsum = attachcountsum+Util.getIntValue(fieldvalue,0) ;
							}
							if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1")) ){
								if(ismand.equals("1")) {
%>
					<input type=text class=inputstyle  maxlength=10 name="attachcount_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('attachcount_<%=recorderindex%>','attachcountspan_<%=recorderindex%>');changecount();">
					<span id="attachcountspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
								}else{
%>
					<input type=text class=inputstyle  maxlength=10 name="attachcount_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this);changecount();'>
<%                               
								}
							}else{
%>
					<%=fieldvalue%><input type=hidden name="attachcount_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
							}
						}
						else if( fieldname.equals("hrmremain"))  {
%>
					<span id='hrmremainspan_<%=recorderindex%>'><%=span1%></span>
<%
						}
						else if( fieldname.equals("deptremain")) {
%>
					<span id='deptremainspan_<%=recorderindex%>'><%=span2%></span>
<%
						}
						else if( fieldname.equals("subcomremain"))  {
%>
					<span id='subcomremainspan_<%=recorderindex%>'><%=span3%></span>
<%
						}
						else if( fieldname.equals("fccremain"))  {
%>
					<span id='fccremainspan_<%=recorderindex%>'><%=span4%></span>
<%
						}
						else if( fieldname.equals("loanbalance"))  {
%>
					<span id='loanbalancespan_<%=recorderindex%>'><%=loanamount%></span>
<%
						}
						else if( fieldname.equals("relatedprj"))  {
							showname = Util.toScreen(ProjectInfoComInfo.getProjectInfoname(fieldvalue),user.getLanguage()) ;
							if( fieldvalue.equals("0") ) fieldvalue = "" ;
							if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1")) ){
%>
					<span id='relatedprj_<%=recorderindex %>wrapspan'></span>
					<!-- 
					<input type="hidden" viewtype="<%=ismand %>" temptitle="" name="relatedprj_<%=recorderindex%>" id="relatedprj_<%=recorderindex%>" value="<%=fieldvalue%>" />
					 -->
					<script type="text/javascript">
						jQuery(document).ready(function(){
							var detailbrowclick = "onShowBrowser2_fna('relatedprj_<%=recorderindex %>','"+browserUtl_prj+"','','8','<%=ismand %>')";
							initE8Browser("relatedprj_<%=recorderindex %>", <%=recorderindex %>, <%=ismand %>, "<%=fieldvalue%>", "<%=showname%>", detailbrowclick, "/data.jsp?type=8");
						});
					</script>
<%
							}else{
%>
					<input type="hidden" viewtype="<%=ismand %>" temptitle="" name="relatedprj_<%=recorderindex%>" id="relatedprj_<%=recorderindex%>" value="<%=fieldvalue%>" />
					<%=showname %>
<%		
							}
						}
						else if( fieldname.equals("relatedcrm")) {
							showname = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(fieldvalue),user.getLanguage()) ;
							if( fieldvalue.equals("0") ) fieldvalue = "" ;
							if(isedit.equals("1") && isremark==0  && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){
%>
					<span id='relatedcrm_<%=recorderindex %>wrapspan'></span>
					<!-- 
					<input type="hidden" viewtype="<%=ismand %>" temptitle="" name="relatedcrm_<%=recorderindex%>" id="relatedcrm_<%=recorderindex%>" value="<%=fieldvalue%>" />
					 -->
					<script type="text/javascript">
						jQuery(document).ready(function(){
							var detailbrowclick = "onShowBrowser2_fna('relatedcrm_<%=recorderindex %>','"+browserUtl_crm+"','','7','<%=ismand %>')";
							initE8Browser("relatedcrm_<%=recorderindex %>", <%=recorderindex %>, <%=ismand %>, "<%=fieldvalue%>", "<%=showname%>", detailbrowclick, "/data.jsp?type=7");
						});
					</script>
<%
							}else{
%>
					<input type="hidden" viewtype="<%=ismand %>" temptitle="" name="relatedcrm_<%=recorderindex%>" id="relatedcrm_<%=recorderindex%>" value="<%=fieldvalue%>" />
					<%=showname %>
<%		
							}
						}                                          // customerid 按钮条件结束
						else if( fieldname.equals("description")) {
							if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1")) ){
								if(ismand.equals("1")) {
%>
					<input type=text class=inputstyle  name="description_<%=recorderindex%>" style="width:85%" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" onBlur="checkLength('description_<%=recorderindex%>',500,'<%=fieldlable%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" onChange="checkinput('description_<%=recorderindex%>','descriptionspan_<%=recorderindex%>')">
					<span id="descriptionspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
								}else{
%>
					<input type=text class=inputstyle  name="description_<%=recorderindex%>" onBlur="checkLength('description_<%=recorderindex%>',500,'<%=fieldlable%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" style="width:85%">
<%
								}
							} else {
%>
					<%=Util.toScreen(fieldvalue,user.getLanguage())%>
					<input type=hidden name="description_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
<%
							}
						}
						else if( fieldname.equals("applyamount")) {
							if( Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue="" ;
							else
								applyamountsum = applyamountsum.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
							if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1")) ){
								if(ismand.equals("1")) {
%>
					<input type=text class=inputstyle  name="applyamount_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('applyamount_<%=recorderindex%>','applyamountspan_<%=recorderindex%>');changeapplynumber(this);">
					<span id="applyamountspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
								}else{
%>
					<input type=text class=inputstyle  name="applyamount_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this);changeapplynumber(this);'>
<%
								}
							} else {
%>
					<%=fieldvalue%><input type=hidden name="applyamount_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
							}
						}
						else if( fieldname.equals("amount")) {
							if( Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue="" ;
							else
								amountsum = amountsum.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
							if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1")) ){
								if( Util.getDoubleValue(fieldvalue,0) == 0 ){
									fieldvalue=Util.round(""+tempappamount, 3) ;
									amountsum = amountsum.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
								}
								if(ismand.equals("1")) {
%>
					<input type=text class=inputstyle  name="amount_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('amount_<%=recorderindex%>','amountspan_<%=recorderindex%>');changenumber();">
					<span id="amountspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
								}else{
%>
					<input type=text class=inputstyle  name="amount_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this);changenumber();'>
<%
								}
							} else {
%>
					<%=fieldvalue%><input type=hidden name="amount_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
							}
						}
%>
				</td>
<%
					}
				}
				recorderindex ++ ;
%>
				</tr>
<%          }   %>
               <tr class="header" style="FONT-WEIGHT: bold; COLOR: red">
                 <td><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></td>
<%          for(int i=0;i<viewfieldnames.size();i++){
                 String thefieldname = (String)viewfieldnames.get(i) ;
%>
                 <td <% if(thefieldname.equals("amount")) {%> id=amountsum
                    <% } %>
                     <% if(thefieldname.equals("applyamount")) {%> id=applyamountsum
                    <% } %>
                    <% if(thefieldname.equals("attachcount")) {%> id=attachcountsum
                    <% }if(thefieldname.equals("loanbalance")) {%> class=balancehide
                    <% } %>
                         >
                    <% if(thefieldname.equals("amount")) {
                    	amountsum = amountsum.divide ( new BigDecimal ( 1 ),amountdb, BigDecimal.ROUND_HALF_UP ) ;
                         String amountsumstr = "&nbsp;" ;
                         if( amountsum.doubleValue() != 0 ) amountsumstr = amountsum.toPlainString();
                    %><%=amountsum%>
                    <% } else if(thefieldname.equals("applyamount")) {
                    	applyamountsum = applyamountsum.divide ( new BigDecimal ( 1 ), applyamountdb, BigDecimal.ROUND_HALF_UP ) ;
                         String applyamountsumstr = "&nbsp;" ;
                         if( applyamountsum.doubleValue() != 0 ) applyamountsumstr = applyamountsum.toPlainString();
                    %><%=applyamountsum%>
                    <% } else if(thefieldname.equals("attachcount")) {
                         String attachcountsumstr = "&nbsp;" ;
                         if( attachcountsum != 0 ) attachcountsumstr = ""+attachcountsum;
                    %><%=attachcountsumstr%>
                    <% } else {%>
                    	<%="&nbsp;"%>
                    <%}%>
                 </td>
<%          }
%>
               </tr>
             </table>
		</wea:item>
	</wea:group>
</wea:layout>
     <br>
        <jsp:include page="/workflow/request/FnaWipeExpenseDetail.jsp" >
        <jsp:param name="billid" value="<%=billid%>" />
        <jsp:param name="requestid" value="<%=requestid%>" />
        <jsp:param name="creater" value="<%=creater%>" />
         </jsp:include>
    <br>
     <input type='hidden' id=nodesnum name=nodesnum value="<%=recorderindex%>">
     <input type='hidden' id="indexnum" name="indexnum" value="<%=recorderindex%>">
     <input type='hidden' id=rowneed name=rowneed value="<%=dtlneed %>">
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">

    <jsp:include page="WorkflowManageSign1.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
    <jsp:param name="requestmark" value="<%=requestmark%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
	<jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="isreopen" value="<%=isreopen%>" />
    <jsp:param name="isreject" value="<%=isreject%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="currenttime" value="<%=currenttime%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
    <jsp:param name="topage" value="<%=topage%>" />
    </jsp:include>

 <%
   String totallabel="";
   String wipetypelabel="";
   RecordSet.executeProc("workflow_billfield_Select",formid+"");
    while(RecordSet.next()){
        if(Util.null2String(RecordSet.getString("fieldname")).equals("total"))
          totallabel=Util.null2String(RecordSet.getString("id"));
        if(Util.null2String(RecordSet.getString("fieldname")).equals("wipetype"))
        wipetypelabel=Util.null2String(RecordSet.getString("id"));
    }

 %>
 <script language=javascript>
  $GetEle("needcheck").value+=",<%=needcheck%>";
 rowindex = <%=recorderindex%> ;
 insertindex=<%=recorderindex%>;
 deleteindex=0;
 deletearray = new Array() ;
 thedeletelength=0;

 function addRow()
 {
	 var rowColor = getRowClassName();
     oRow = oTable.insertRow(rowindex+1);
     curindex=parseInt( $GetEle('nodesnum').value);

     for(j=0; j < fieldorders.length+1; j++) {
         oCell = oRow.insertCell(-1);
         oCell.style.height=24;
         //oCell.style.background= "#D2D1F1";
         oCell.className = rowColor;
         if( j == 0 ) {
             var oDiv = document.createElement("div");
             var sHtml = "<input type='checkbox' name='check_node' value='"+insertindex+"'>";
             oDiv.innerHTML = sHtml;
             oCell.appendChild(oDiv);
         } else {
             dsporder = fieldorders[j-1] ;
             isedit = isedits[j-1] ;
             ismand = ismands[j-1] ;

             if( isedit != 1 ) {
                 switch (dsporder) {
                     case 1 :
                         var oDiv = document.createElement("div");
                         <%if(fnaBudgetOAOrg){ %>
                        var sHtml = "<span id='organizationspan_"+insertindex+"'>" ;
                         sHtml += "<a href='/hrm/company/HrmDepartmentDsp.jsp?id=<%=udept%>'><%=udeptname%></a>"; sHtml += "</span><input type=hidden id='organizationid_"+insertindex+"' name='organizationid_"+insertindex+"' value='<%=udept%>'>" ;
                         <%}else{ %>
                         var sHtml = "";
                         <%} %>
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                     case 5 :
                         var oDiv = document.createElement("div");
                         sHtml = "<span id='hrmremainspan_" + insertindex + "'></span>";
                         oDiv.innerHTML = sHtml;
                         oCell.appendChild(oDiv);
                         break;
                     case 6 :
                         var oDiv = document.createElement("div");
                         sHtml = "<span id='deptremainspan_" + insertindex + "'></span>";
                         oDiv.innerHTML = sHtml;
                         oCell.appendChild(oDiv);
                         break;
                     case 7 :
                         var oDiv = document.createElement("div");
                         sHtml = "<span id='subcomremainspan_" + insertindex + "'></span>";
                         oDiv.innerHTML = sHtml;
                         oCell.appendChild(oDiv);
                         break;
                     case 8 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='loanbalancespan_"+insertindex+"'><%=applicantloanamount%></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        if( $GetEle("balancestyle").disabled){
                                 $GetEle("balancestyle").disabled=false;
                                oCell.className = "balancehide";
                                 $GetEle("balancestyle").disabled=true;
                            } else
                                oCell.className = "balancehide";
                        break ;
                    case 14 :
                        var oDiv = document.createElement("div");
                         <%if(fnaBudgetOAOrg){ %>
                        var sHtml = "<input type=hidden id='organizationtype_"+insertindex+"' name='organizationtype_"+insertindex+"' value=2><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>" ;
                        <%}else{ %>
                        var sHtml = "";
                        <%} %>
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 999 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='fccremainspan_"+insertindex+"'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                     default:
                         var oDiv = document.createElement("div");
                         var sHtml = "&nbsp;";
                         oDiv.innerHTML = sHtml;
                         oCell.appendChild(oDiv);
                 }
             } else {
                 switch (dsporder)  {
                     case 1 :
						var oDiv = document.createElement("div");
						oDiv.innerHTML = "<span id='organizationid_"+insertindex+"wrapspan'></span>"+
							//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"organizationid_"+insertindex+"\" id=\"organizationid_"+insertindex+"\" value=\"\">"+
							"";
						oCell.appendChild(oDiv);

                        <%if(fnaBudgetOAOrg){ %>
                        onShowOrganizationBtn(ismand, insertindex, "<%=udept %>", "<%=udeptname %>");
                        <%}else if(fnaBudgetCostCenter){ %>
                        onShowOrganizationBtn(ismand, insertindex, "", "");
                        <%} %>
						
                        break ;
                     case 2 :
						var oDiv = document.createElement("div");
						var detailbrowclick = "onShowBrowser2_fna('subject_"+insertindex+"','"+browserUtl_subject+"','','22','"+ismand+"')";
						oDiv.innerHTML = "<span id='subject_"+insertindex+"wrapspan'></span>"+
							//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"subject_"+insertindex+"\" id=\"subject_"+insertindex+"\" value=\"\">"+
							"";
						oCell.appendChild(oDiv);
						
						onShowSubjectBtn("subject_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=22" );
						//initE8Browser("subject_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=22");
						
						break ;
                     case 3 :
                         var oDiv = document.createElement("div");
                         var detailbrowclick = "onShowBrowser2_fna('budgetperiod_"+insertindex+"','','','2','"+ismand+"')";
                         oDiv.innerHTML = "<span id='budgetperiod_"+insertindex+"wrapspan'></span>"+
                         	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"budgetperiod_"+insertindex+"\" id=\"budgetperiod_"+insertindex+"\" value=\"\">"+
                         	"";
                         oCell.appendChild(oDiv);

                         initE8Browser("budgetperiod_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "");
                         
                         break ;
                     case 4 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85%  maxlength=10 id='attachcount_"+insertindex+"' name='attachcount_"+insertindex+"' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(attachcount_"+ insertindex+",attachcountspan_"+insertindex+");" ;
                        sHtml += "changecount();'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='attachcountspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                     case 5 :
                         var oDiv = document.createElement("div");
                         sHtml = "<span id='hrmremainspan_"+insertindex+"'></span>";
                         oDiv.innerHTML = sHtml;
                         oCell.appendChild(oDiv);
                         break ;
                     case 6 :
                         var oDiv = document.createElement("div");
                         sHtml = "<span id='deptremainspan_"+insertindex+"'></span>";
                         oDiv.innerHTML = sHtml;
                         oCell.appendChild(oDiv);
                         break ;
                     case 7 :
                         var oDiv = document.createElement("div");
                         sHtml = "<span id='subcomremainspan_"+insertindex+"'></span>";
                         oDiv.innerHTML = sHtml;
                         oCell.appendChild(oDiv);
                         break ;
                     case 8 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='loanbalancespan_"+insertindex+"'><%=applicantloanamount%></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        if( $GetEle("balancestyle").disabled){
                                 $GetEle("balancestyle").disabled=false;
                                oCell.className = "balancehide";
                                 $GetEle("balancestyle").disabled=true;
                            } else
                                oCell.className = "balancehide";
                        break ;
                     case 9 :
						var oDiv = document.createElement("div");
						var detailbrowclick = "onShowBrowser2_fna('relatedprj_"+insertindex+"','"+browserUtl_prj+"','','8','"+ismand+"')";
						oDiv.innerHTML = "<span id='relatedprj_"+insertindex+"wrapspan'></span>"+
                         	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"relatedprj_"+insertindex+"\" id=\"relatedprj_"+insertindex+"\" value=\"\">"+
                         	"";
						oCell.appendChild(oDiv);
                         
 						initE8Browser("relatedprj_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=8");
                         
						break ;
                     case 10 :
						var oDiv = document.createElement("div");
						var detailbrowclick = "onShowBrowser2_fna('relatedcrm_"+insertindex+"','"+browserUtl_crm+"','','7','"+ismand+"')";
						oDiv.innerHTML = "<span id='relatedcrm_"+insertindex+"wrapspan'></span>"+
                         	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"relatedcrm_"+insertindex+"\" id=\"relatedcrm_"+insertindex+"\" value=\"\">"+
                         	"";
						oCell.appendChild(oDiv);

 						initE8Browser("relatedcrm_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=7");
                         
						break ;
                     case 11 :
                         var oDiv = document.createElement("div");
						 var sfield="<%=user.getLanguage()%>";
                         var sHtml = "<nobr><input type='text' class=inputstyle style=width:85%  id='description_"+insertindex+"' title='<%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%>' name='description_"+insertindex+"'  onBlur='" ;
						 sHtml+="checkLength1(description_"+insertindex+",500,this.title,"+sfield+");";
                         if(ismand == 1)
                             sHtml += "checkinput1(description_"+ insertindex+",descriptionspan_"+insertindex+");" ;
                         sHtml += "'>" ;
                         if(ismand == 1)
                             sHtml += "<span id='descriptionspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                         oDiv.innerHTML = sHtml;
                         oCell.appendChild(oDiv);
                         break ;
                     case 12 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85%  id='applyamount_"+insertindex+"' name='applyamount_"+insertindex+"' onKeyPress='ItemDecimal_KeyPress(this.name,15,3)' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(applyamount_"+ insertindex+",applyamountspan_"+insertindex+");" ;
                        sHtml += "changeapplynumber(this);'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='applyamountspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                     case 13 :
                         var oDiv = document.createElement("div");
                         var sHtml = "<nobr><input type='text' class=inputstyle style=width:85%  id='amount_"+insertindex+"' name='amount_"+insertindex+"' onKeyPress='ItemDecimal_KeyPress(this.name,15,3)' onBlur='checknumber1(this);" ;
                         if(ismand == 1)
                             sHtml += "checkinput1(amount_"+ insertindex+",amountspan_"+insertindex+");" ;
                         sHtml += "changenumber();'>" ;
                         if(ismand == 1)
                             sHtml += "<span id='amountspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                         oDiv.innerHTML = sHtml;
                         oCell.appendChild(oDiv);
                         break ;
                    case 14 :
                         var oDiv = document.createElement("div");
                        var sHtml = "<select id='organizationtype_"+insertindex+"' name='organizationtype_"+insertindex+"' onchange='clearSpan("+insertindex+")'>"+
                        <%if(fnaBudgetOAOrg){ %>
                        	"<option value=2 default><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>"+
                        	"<option value=1><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>"+
                        	"<option value=3><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>"+
                        <%} %>
                        <%if(fnaBudgetCostCenter){ %>
                        	"<option value='<%=FnaCostCenter.ORGANIZATION_TYPE %>'><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></option>"+
                        <%} %>
                        	"</select>" ;  
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 999 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='fccremainspan_"+insertindex+"'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                 }
             }
         }
     }
     if ("<%=needcheckdtl%>" != ""){
         $GetEle("needcheck").value += "<%=needcheckdtl%>";
    }
     insertindex = insertindex*1 +1;
     rowindex = curindex*1 +1;
     $GetEle("nodesnum").value = rowindex;
     $GetEle("indexnum").value = insertindex;

     try{jQuery('body').jNice();}catch(ex1){}
     try{beautySelect();}catch(ex1){}
 }
 
 <%
 if(dtldefault.equals("1") && recorderindex == 0)
 {
 %>
 addRow();
 <%
 RecordSet.executeSql(" select defaultrows from workflow_NodeFormGroup where nodeid=" + nodeid + " and groupid=0");
 RecordSet.next();
 int defaultrows = Util.getIntValue(RecordSet.getString("defaultrows"),0);
 %>
 var defaultrows = <%=defaultrows %>;
 for(var k = 0; k < parseInt(defaultrows)-1; k++) {
 addRow();						
 }
 <%	
 }
 %>
 
 function changecount() {
    count = 0 ;
    try{
    for(j=0;j<insertindex;j++) {
        hasdelete = false ;
        for(k=0;k<deletearray.length;k++){
            if(j==deletearray[k])
            hasdelete=true;
        }
        if(hasdelete) continue ;
        count += eval(toInt( $GetEle("attachcount_"+j).value,0)) ;
    }
    attachcountsum.innerHTML = count ;
    }catch(e){}
}
 function changenumber(obj){

     count = 0 ;
     try{
     for(j=0;j<insertindex;j++) {
         hasdelete = false ;
         for(k=0;k<deletearray.length;k++){
             if(j==deletearray[k])
             hasdelete=true;
         }
         if(hasdelete) continue ;
         count+= eval(toFloat( $GetEle("amount_"+j).value,0)) ;
     }
     var hasedit=false;
     try{
		if(!isNaN(parseFloat(obj.value))){
			 obj.value = parseFloat(obj.value).toFixed(<%=amountdb%>);
		}
	}catch(e){}
     amountsum.innerHTML = count.toFixed(<%=amountdb%>);
     if( $GetEle("field<%=totallabel%>")!=null){
		   var totalCount =Math.round(count * Math.pow(10, <%=amountdb%>)) / Math.pow(10, <%=amountdb%>);
          $GetEle("field<%=totallabel%>").value =  totalCount.toFixed(<%=totaldb%>);
         if( $GetEle("field<%=totallabel%>").type!="hidden") hasedit=true;
     }
     if(!hasedit&& $GetEle("field<%=totallabel%>span")!=null){
		  var totalCount =Math.round(count * Math.pow(10, <%=amountdb%>)) / Math.pow(10, <%=amountdb%>);
          $GetEle("field<%=totallabel%>span").innerHTML =  totalCount.toFixed(<%=totaldb%>);
	 }
    }catch(e){}
 }

function changeapplynumber(obj){

    count = 0 ;
    try{
    for(j=0;j<insertindex;j++) {
        hasdelete = false ;
        for(k=0;k<deletearray.length;k++){
            if(j==deletearray[k])
            hasdelete=true;
        }
        if(hasdelete) continue ;
        count+= eval(toFloat( $GetEle("applyamount_"+j).value,0)) ;
    }
    var hasedit=false;
    try{
		if(!isNaN(parseFloat(obj.value))){
			 obj.value = parseFloat(obj.value).toFixed(<%=applyamountdb%>);
		}
	}catch(e){}
    applyamountsum.innerHTML = count.toFixed(<%=applyamountdb%>);
    if( $GetEle("field<%=totallabel%>")!=null){
		var totalCount =Math.round(count * Math.pow(10, <%=applyamountdb%>)) / Math.pow(10, <%=applyamountdb%>);
         $GetEle("field<%=totallabel%>").value =  totalCount.toFixed(<%=totaldb%>);
        if( $GetEle("field<%=totallabel%>").type!="hidden") hasedit=true;
    }
     if(!hasedit&& $GetEle("field<%=totallabel%>span")!=null){
		 var totalCount =Math.round(count * Math.pow(10, <%=applyamountdb%>)) / Math.pow(10, <%=applyamountdb%>);
        $GetEle("field<%=totallabel%>span").innerHTML =  totalCount.toFixed(<%=totaldb%>);
	 }
    }catch(e){}
}

 function toFloat(str , def) {
     if(isNaN(parseFloat(str))) return def ;
     else return str ;
 }

 function toInt(str , def) {
     if(isNaN(parseInt(str))) return def ;
     else return str ;
 }

 function deleteRow1()
 {
     var flag = false;
	var ids = document.getElementsByName('check_node');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		if(isdel()){
             len = document.forms[0].elements.length;
             var i=0;
             var therowindex = 0 ;
             var rowsum1 = 0;
             rowindex=parseInt( $GetEle("nodesnum").value);
             for(i=len-1; i >= 0;i--) {
                 if (document.forms[0].elements[i].name=='check_node')
                     rowsum1 += 1;
             }
             for(i=len-1; i >= 0;i--) {
                 if (document.forms[0].elements[i].name=='check_node'){
                     if(document.forms[0].elements[i].checked==true) {
                         therowindex = document.forms[0].elements[i].value ;
                         deletearray[thedeletelength] = therowindex ;
                         thedeletelength ++ ;
                         oTable.deleteRow(rowsum1);
                         rowindex--;
                     }
                     rowsum1 -=1;
                 }
             }
             changeapplynumber() ;
             changenumber() ;
             changecount();
             $GetEle("nodesnum").value = rowindex ;
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
 }

 function clearBtnById(index){
<%if(subjectFilter){ %>
 	var _objIdWrapspan = jQuery("#subject_"+index+"wrapspan");
 	if(_objIdWrapspan.length==1){
 		var _objId = jQuery("#subject_"+index);
 		var _objSpan = jQuery("#subject_"+index+"span");
 		_objId.val("");
 		_objSpan.html("");
 	}else{
 		jQuery("#subject_"+index+"span").html("");
 	}
<%} %>
 }

function wfbrowvaluechange(obj, fieldid, index) {
	//alert("obj="+obj+";fieldid="+fieldid+";index="+index);
	if("organizationid_"+index==fieldid){
		clearBtnById(index);
	}
	
	var organizationtypeval = jQuery("#organizationtype_" + index).val();
	var organizationidval = jQuery("#organizationid_" + index).val();
	var subjid = jQuery("#subject_" + index).val();

	getBudgetKpi(index, organizationtypeval, organizationidval, subjid);
	getLoan(index, organizationtypeval, organizationidval);
}

function clearSpan(index) {
	if(jQuery("#organizationid_"+index+"span").length>0&&organizationidisedit==1){
		if(organizationidismand==1){
			jQuery("#organizationid_"+index+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
		}else{
			jQuery("#organizationid_"+index+"span").html("");
		}
		jQuery("#organizationid_"+index+"span")[0].parentElement.parentElement.style.background=jQuery("#organizationtype_"+index)[0].parentElement.parentElement.style.background;
		if (jQuery("#organizationid_" + index).length>0){
			jQuery("#organizationid_"+index).val("");
		}
		if (jQuery("#hrmremainspan_" + index).length>0) {
			jQuery("#hrmremainspan_" + index).html("");
		}
		if (jQuery("#deptremainspan_" + index).length>0) {
			jQuery("#deptremainspan_" + index).html("");
		}
		if (jQuery("#subcomremainspan_" + index).length>0) {
			jQuery("#subcomremainspan_" + index).html("");
		}
		if (jQuery("#fccremainspan_" + index).length>0) {
			jQuery("#fccremainspan_" + index).html("");
		}
	}

	clearBtnById(index);
	onShowOrganizationBtn(organizationidismand, index, "", "");
    
}
function onShowOrganizationBtn(organizationidismand, insertindex, _browserId, _browserName) {
	jQuery("#organizationid_"+insertindex).val("");
    jQuery("#organizationid_"+insertindex+"wrapspan").html("");
    
	var orgType = jQuery("#organizationtype_"+insertindex).val();
	
	var btnType = "4";//部门
	var browserUtl = browserUtl_dep;
    if (orgType == "3"){//个人
    	btnType = "1";
    	browserUtl = browserUtl_hrm;
    }else if (orgType == "2"){//部门
    	btnType = "4";
    	browserUtl = browserUtl_dep;
    }else if (orgType == "1"){//分部
    	btnType = "164";
    	browserUtl = browserUtl_sub;
    }else if (orgType == "<%=FnaCostCenter.ORGANIZATION_TYPE+"" %>"){//成本中心
    	btnType = "251";
    	browserUtl = browserUtl_fcc;
    }

    var detailbrowclick = "onShowBrowser2_fna('organizationid_"+insertindex+"','"+browserUtl+"','','"+btnType+"','"+organizationidismand+"')";
    
	var isMustInput = "1";
	if(organizationidismand==1){
		isMustInput = "2";
	}
	initE8Browser("organizationid_"+insertindex, insertindex, organizationidismand, _browserId, _browserName, detailbrowclick, "/data.jsp?show_virtual_org=-1&type="+btnType+"&bdf_wfid=<%=workflowid%>&bdf_fieldid=<%=organizationidFieldId%>");
}

function onShowSubjectBtn(fieldId, insertindex, ismand, fieldvalue, showname, detailbrowclick, url ){
	initE8Browser(fieldId, insertindex, ismand, fieldvalue, showname, detailbrowclick, "javascript:getSubjectId_completeUrl('"+fieldId+"','"+insertindex+"')");
}

function getSubjectId_completeUrl(fieldId, insertindex){
	var __orgType = jQuery("#organizationtype_"+insertindex).val();
	var __orgId = jQuery("#organizationid_"+insertindex).val();
	return "/data.jsp?type=22&orgType="+__orgType+"&orgId="+__orgId+"&fromFnaRequest=1&bdf_wfid=<%=workflowid%>&bdf_fieldid=<%=subjectFieldId%>";
}

function callback(o, index) {
	if(o==null||o==""){
		jQuery("#hrmremainspan_" + index).html("");
		jQuery("#deptremainspan_" + index).html("");
		jQuery("#subcomremainspan_" + index).html("");
		jQuery("#fccremainspan_" + index).html("");
	}else{
	    val = o.split("|");
	    if (jQuery("#hrmremainspan_" + index).length>0) {
	        if (val[0] != "") {
	            v = val[0].split(",");
	            jQuery("#hrmremainspan_" + index).html("<span ><span style='white-space :nowrap'><%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "</span><br><span style='white-space :nowrap;color:red' ><%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "</span><br><span style='white-space :nowrap;color:green' ><%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2] + "</span></span>");
	        }
	    }
	    if (jQuery("#deptremainspan_" + index).length>0) {
	        if (val[1] != "") {
	            v = val[1].split(",");
	            jQuery("#deptremainspan_" + index).html("<span ><span style='white-space :nowrap'><%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "</span><br><span style='white-space :nowrap;color:red' ><%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "</span><br><span style='white-space :nowrap;color:green' ><%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2] + "</span></span>");
	        }
	    }
	    if (jQuery("#subcomremainspan_" + index).length>0) {
	        if (val[2] != "") {
	            v = val[2].split(",");
	            jQuery("#subcomremainspan_" + index).html("<span ><span style='white-space :nowrap'><%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "</span><br><span style='white-space :nowrap;color:red' ><%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "</span><br><span style='white-space :nowrap;color:green' ><%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2] + "</span></span>");
	        }
	    }
	    if (jQuery("#fccremainspan_" + index).length>0) {
	        if (val[3] != "") {
	            v = val[3].split(",");
	            jQuery("#fccremainspan_" + index).html("<span ><span style='white-space :nowrap'><%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "</span><br><span style='white-space :nowrap;color:red' ><%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "</span><br><span style='white-space :nowrap;color:green' ><%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2] + "</span></span>");
	        }
	    }
	}
}
function getBudgetKpi(index, organizationtype, organizationid, subjid) {
	var budgetperiod = jQuery("#budgetperiod_"+index).val();
	if(subjid!=""&&organizationtype!=""&&organizationid!=""&&budgetperiod!=""){
		var _data = "budgetfeetype="+subjid+"&orgtype="+organizationtype+"&orgid="+organizationid+"&applydate="+budgetperiod;
		jQuery.ajax({
			url : "/workflow/request/BudgetHandlerGetBudgetKPI.jsp",
			type : "post",
			processData : false,
			data : _data,
			dataType : "html",
			success: function do4Success(msg){
				callback(msg, index);
			}
		});	
	}else{
		callback("", index);
	}
}

function callback1(o, index) {
    jQuery("#loanbalancespan_"+index).html(o);
}
function getLoan(index, organizationtype, organizationid) {
	if(organizationtype!=""&&organizationid!=""){
		var _data = "orgtype="+organizationtype+"&orgid="+organizationid;
		jQuery.ajax({
			url : "/workflow/request/BudgetHandlerLoanAmount.jsp",
			type : "post",
			processData : false,
			data : _data,
			dataType : "html",
			success: function do4Success(msg){
				callback1(msg, index);
			}
		});	
	}else{
		callback1("", index);
	}
}

function balancestyleShow(){
    if(jQuery("#field<%=wipetypelabel%>").length>0 && jQuery("#balancestyle").length>0){
       if (jQuery("#field<%=wipetypelabel%>").val() == "4") {
        	jQuery("#balancestyle")[0].disabled=true;
        }else{
        	jQuery("#balancestyle")[0].disabled=false;
        }
    }
}

function checknumber1(objectname)
{
	valuechar = objectname.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=".") isnumber = true ;}
	if(isnumber) objectname.value = "" ;
}
function checkcount1(objectname)
{
	valuechar = objectname.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)) isnumber = true ;}
	if(isnumber) objectname.value = "" ;
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
