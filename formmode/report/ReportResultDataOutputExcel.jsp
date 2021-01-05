
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.tree.CustomTreeData"%>
<%@page import="weaver.formmode.tree.CustomTreeUtil"%>
<%@page import="java.text.DecimalFormat"%>
<%
request.setCharacterEncoding("UTF-8");
%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.*,java.math.BigDecimal" %>
<%@ page import="weaver.workflow.report.ReportCompositorOrderBean" %><!--ReportCompositorOrderBean is added by xwj for td2099 on 20050608-->
<%@ page import="weaver.workflow.report.ReportCompositorListBean" %><!--ReportCompositorListBean is added by xwj for td2451 on 20051114-->
 <%@ page import="weaver.workflow.report.ReportUtilComparator" %>
<!--added by xwj for td2974 20051026-->
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj for td2974 20051026-->
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj for td2974 20051026-->
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj for td2974 20051026-->
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

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
<%
	//报表id
	String reportid = Util.null2String(request.getParameter("reportid")) ;
	if(reportid.equals("")){
		reportid="0";
	}

	String[] checkcons =null;//报表条件
	String[] isShowArray = null;//报表列
	List isShowList=new ArrayList();//显示的列的字段id

	String formid = "0";
	String reportname = "";
	String modeid = "0";
	String isbill = "1";
	String sql = "select a.reportname,b.formid,b.id from mode_Report a,modeinfo b where a.modeid = b.id and a.id = "+reportid;
	RecordSet.execute(sql) ;
	while(RecordSet.next()){
		formid = Util.null2String(RecordSet.getString("formId"));
		reportname = Util.null2String(RecordSet.getString("reportname"));
		modeid = Util.null2String(RecordSet.getString("id"));
	}

	List fieldids = new ArrayList() ;
	List fields = new ArrayList() ;
	List fieldnames = new ArrayList() ;
	
	List htmltypes = new ArrayList() ;
	List types = new ArrayList() ;
	List dbtypes = new ArrayList() ;
	List qfwses = new ArrayList() ;
	List isstats = new ArrayList() ;
	List statvalues = new ArrayList() ;
	List tempstatvalues = new ArrayList() ;
	List isdetails = new ArrayList() ;//add by wang jinyong
	String requestid = ""; //add by wang jinyong
	boolean isnew = true; //add by wang jinyong
	List isdborders = new ArrayList() ;

	ArrayList compositorOrderList = new ArrayList();
	ArrayList compositorColList = new ArrayList();
	ArrayList compositorColList2 = new ArrayList();
	
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

	//传递过来的LIST值
	String showListStr = Util.StringReplace(Util.StringReplace(Util.StringReplace(Util.null2String(request.getParameter("isShowList")),"[",","),"]",",")," ","");
	isShowList = Util.TokenizerString(showListStr, ",");

	String sqlrightwhere = "";
	String temOwner = "";


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

	if(isShowList.indexOf("-1")!=-1){
		rs1.executeSql("select * from mode_ReportDspField where reportid = " + reportid + " and fieldid = -1");
		if(rs1.next()){
			qfwses.add("0");
			dbtypes.add("");
		    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
		    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
		    rcListBean.setSqlFlag("a");//xwj for td2451 20051114
		    rcListBean.setFieldName("modedatacreatedate");//xwj for td2451 20051114
		    rcListBean.setFieldId("-1");//xwj for td2451 20051114
		    rcListBean.setColName(SystemEnv.getHtmlLabelName(722,user.getLanguage()));//创建日期 //xwj for td2451 20051114
			compositorColList.add(rcListBean);//xwj for td2451 20051114
		    fields.add("modedatacreatedate");
		    if(!"n".equals(rs1.getString("dbordertype"))){
		        reportCompositorOrderBean = new ReportCompositorOrderBean();
		        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
				reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
				reportCompositorOrderBean.setFieldName("modedatacreatedate");
				reportCompositorOrderBean.setSqlFlag("a");
				compositorOrderList.add(reportCompositorOrderBean);
		    }
		}
	}

	 //只有显示紧急程度时才执行下面的操作
	if(isShowList.indexOf("-2")!=-1){    
		rs1.executeSql("select * from mode_ReportDspField where reportid = " + reportid + " and fieldid = -2");
		if(rs1.next()){
			qfwses.add("0");
			dbtypes.add("");
	      	rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
		    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
		    rcListBean.setSqlFlag("a");//xwj for td2451 20051114
		    rcListBean.setFieldName("modedatacreater");//xwj for td2451 20051114
		    rcListBean.setFieldId("-2");//xwj for td2451 20051114
		    rcListBean.setColName(SystemEnv.getHtmlLabelName(882,user.getLanguage()));//创建人
		    compositorColList.add(rcListBean);//xwj for td2451 20051114
		    fields.add("modedatacreater");
		    if(!"n".equals(rs1.getString("dbordertype"))){
		        reportCompositorOrderBean = new ReportCompositorOrderBean();
		        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
				reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
				reportCompositorOrderBean.setFieldName("modedatacreater");
				reportCompositorOrderBean.setSqlFlag("a");
				compositorOrderList.add(reportCompositorOrderBean);
		    }
		}
	}
	sql = " select a.fieldname , c.labelname, a.fieldhtmltype, a.type, b.isstat , a.viewtype , b.dborder , a.id , b.dbordertype , b.compositororder, b.dsporder, a.detailtable as detailtable from  workflow_billfield a, mode_ReportDspField b , HtmlLabelInfo c " +
        " where a.id = b.fieldid and a.fieldlabel = c.indexid and b.reportid = " + reportid +" and  c.languageid = " + user.getLanguage() + " order by b.dsporder,b.id asc " ;
	RecordSet.execute(sql) ;
	while(RecordSet.next()) {
		String viewtype = Util.null2String(RecordSet.getString(6)) ;
		if(viewtype.equals("1")) {
			viewtype = Util.null2String(RecordSet.getString("detailtable")) ;
			detailcount ++ ;
		} else {
			viewtype ="a" ;
			maincount ++ ;
		}
		if(!Util.null2String(RecordSet.getString("dbordertype")).equals("n")) {
			reportCompositorOrderBean = new ReportCompositorOrderBean();
			reportCompositorOrderBean.setCompositorOrder(RecordSet.getInt(10));
			reportCompositorOrderBean.setOrderType(Util.null2String(RecordSet.getString(9)));
			reportCompositorOrderBean.setFieldName(Util.null2String(RecordSet.getString(1)));
			reportCompositorOrderBean.setSqlFlag(viewtype);
			compositorOrderList.add(reportCompositorOrderBean);
		}
		
		if(isShowList.indexOf(Util.null2String(RecordSet.getString(8)))==-1){
			continue;
		}

		rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
		rcListBean.setCompositorList(RecordSet.getDouble(11));//xwj for td2451 20051114
		rcListBean.setSqlFlag(viewtype);//xwj for td2451 20051114
		rcListBean.setFieldName(Util.null2String(RecordSet.getString(1)));//xwj for td2451 20051114
		rcListBean.setFieldId(Util.null2String(RecordSet.getString(8)));//xwj for td2451 20051114
		rcListBean.setColName(Util.toScreen(RecordSet.getString(2),user.getLanguage()));//xwj for td2451 20051114
		compositorColList.add(rcListBean);//xwj for td2451 20051114
		fields.add(Util.null2String(RecordSet.getString(1))) ;
	}
	compositorColList2 = ReportComInfo.getCompositorList(compositorColList);
	for(int a = 0; a < compositorColList2.size(); a++){
		rcColListBean = (ReportCompositorListBean)compositorColList2.get(a);
		RecordSet.executeSql("select * from mode_ReportDspField where reportid = " + reportid + " and fieldid = " +rcColListBean.getFieldId());
		if(RecordSet.next()){
			String  tempfieldid = RecordSet.getString("fieldid");
			if("-1".equals(tempfieldid) || "-2".equals(tempfieldid)){
				htmltypes.add(tempfieldid);
				types.add(tempfieldid);
				isdetails.add("");
			} else {
				rs3.executeSql("select formid from mode_report b where   b.id = "+ reportid);
				if(rs3.next()){
					rs2.executeSql("select * from workflow_billfield where id = " + tempfieldid + " and billid=" + rs3.getString("formid"));
					if(rs2.next()){
						htmltypes.add(Util.null2String(rs2.getString("fieldhtmltype")));
						types.add(Util.null2String(rs2.getString("type")));
						qfwses.add(Util.null2String(rs2.getString("qfws")));
						dbtypes.add(Util.null2String(rs2.getString("fielddbtype")));
						String detailtabletmp = Util.null2String(rs2.getString("detailtable"));
						if(!"".equals(detailtabletmp)){
							isdetails.add("1");
						}else{
							isdetails.add("");
						}
					}
				}
			}
			fieldids.add(tempfieldid);
			if(Util.null2String(RecordSet.getString("isstat")).equals("1")) {
				statcount ++ ;
				isstats.add("1") ;
			} else { 
				isstats.add("") ;
			}
			statvalues.add("") ;
			tempstatvalues.add("") ;
			if(Util.null2String(RecordSet.getString("dborder")).equals("1")) {
				ordercount ++ ;
				isdborders.add("1") ;
			} else { 
				isdborders.add("") ;
			}
		}
	}
	sql = request.getParameter("pmSql");
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
					<TBODY>
				  	<TR class="header">
						<th colSpan=<%=fields.size()%>> <p align="center"><%=reportname%> </p></th>
				  	</TR>
				  	<TR class=Header>
					<%
						ExcelSheet es = new ExcelSheet() ;
						ExcelRow er = es.newExcelRow () ;
	  
						ArrayList colList = ReportComInfo.getCompositorList(compositorColList);
						for(int i = 0; i < colList.size(); i++) {
							rcColListBean = (ReportCompositorListBean) colList.get(i);
							er.addStringValue(rcColListBean.getColName()) ;
  					%>
    						<TD><%=rcColListBean.getColName()%></TD>
    				<%
    					}
						es.addExcelRow(er) ;
					%>
					</TR>
					<%
						String useddetailtable = Util.null2String(request.getParameter("useddetailtable"));
					    int needchange = 0;
					    String tempvalue = "";
					    String tempdbordervalue = "" ;
					    boolean needstat = false ;
					    boolean isfirst = true ;
					    if(!"".equals(useddetailtable)) useddetailtable = useddetailtable.substring(1);
					    detailtablename = useddetailtable;
					    ArrayList detailtablenameList = Util.TokenizerString(detailtablename, ",");
					    int details = detailtablenameList.size();
					    String[] detailids = null;
					    if(details>0) detailids = new String[details];
					    for(int flag=0;flag<details;flag++){
					        detailids[flag] = ",";
					    }
					    if(details>0){
					    	//排序问题，报表中，sql为select * from ("+sql+" order by a.id) t1，排序字段在括号内，如果无其他排序字段，是没有问题，
					    	//如果有，就相当于(select ... order by a.c1,a.c2,a.id)，导出这边为(select ... order by a.c1,a.c2) order by a.id，完全两种结果
					        //String tempsql = "select * from ("+sql+") t1 order by t1.id";
					    	String orderSql = " order by a.id ";
					    	if(compositorOrderList.size()>0){//排序字段列表
					    		orderSql = " ,a.id ";
					    	}
					    	String tempsql = "select * from ("+sql+orderSql+") t1";
					        RecordSet.executeSql(tempsql);
					        ArrayList requestids = new ArrayList();
					        while(RecordSet.next()){
					            requestids.add(RecordSet.getString("id"));
											String thisdetailrequestid = RecordSet.getString("id");
											//if(!thisrequestid.equals(thisdetailrequestid)) continue;
					            			//String thisdetailid = RecordSet.getString(thisrowflag + "_id_");
											//if((RecordSet.getCounts() == 1 && !firstrequest && "".equals(thisdetailid)) || (RecordSet.getCounts() > 1 && thisdetailid.equals("")) || thisdetailids.indexOf(","+thisdetailid+",")>-1) continue;
											//firstrequest = false;
											//thisdetailids += thisdetailid+",";
											
											if(ordercount == 1) {
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
					                    		} else {
					                        		needstat = false ;
												}
												tempvalue = "";
											}
  
											if(needstat && statcount != 0 && !isfirst ) {
												er = es.newExcelRow () ;
        			%>
										        <TR class=TOTAL style="FONT-WEIGHT: bold">
					<%
												for(int i =0 ; i< tempstatvalues.size() ; i++) {
													er.addValue(formatData((String)tempstatvalues.get(i))) ;
					%>
										            <TD><%=formatData((String)tempstatvalues.get(i))%></TD>
					<%
										            tempstatvalues.set(i,"") ; 
												}
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
					%>
												<TR class=datadark>
					<%
											}
											
											String temRequestid = RecordSet.getString("id");
											if(!temRequestid.equals(requestid)){
											    isnew = true;
											    requestid = temRequestid;
											}else{
											    isnew = false;
											}

											String leavetype = "";
											//er = es.newExcelRow () ;
											for(int i =0 ; i< fields.size() ; i++) {
												String result = Util.null2String(RecordSet.getString(i+1)) ;
											    String tcolname= RecordSet.getColumnName(i+1);
											    //if(tcolname.indexOf("__")>0&&tcolname.toUpperCase().indexOf(thisrowflag)==-1) result = "";
											    String htmltype = (String)htmltypes.get(i);
											    int type = Util.getIntValue((String)types.get(i)) ;
											
											    String results[] = null ;
											      
											    if(htmltype.equals("-2")) {
											    	result = Util.toScreen(ResourceComInfo.getResourcename(result),user.getLanguage()) ;
											    }
    
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
																rs1.execute("select fielddbtype from workflow_billfield where id="+tempfid);
											                     if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
											                    result=WorkflowJspBean.getWorkflowBrowserShowName(result,""+type,"","",tempfdbtype);
															}
											                if (type==162) 
																{
																if(!result.equals("")) result = result.substring(0,result.length()-1);
																}
											                break;
														case 256:
														case 257:
											                String showname = "";
															String showid = result;
															if(!result.equals("")&&!result.equals("NULL")){
																//获取字段的数据库类型
																String tempfid=(String)fieldids.get(i);
																String tempfdbtype="";
																	rs1.execute("select fielddbtype from workflow_billfield where id="+tempfid);
												                     if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
												                     
																Map<String,Map<String,String>> nodeTableMap = new HashMap<String,Map<String,String>>();
																String[] browserValArray =  showid.split(",");
																for(int m=0;m<browserValArray.length;m++){
																	String treenodeid = browserValArray[m];
																	String keyid = treenodeid.split("_")[0];
																	String valid = treenodeid.split("_")[1];
																	String tablenameStr = "";//表名
																	String tablekey = "";//主字段
																	String showfield = "";//显示名称
																	String datacondition = "";//数据显示条件 
																	
																	if(nodeTableMap.containsKey(keyid)){
																		Map<String,String> tempMap = nodeTableMap.get(keyid);
																		tablenameStr = tempMap.get("tablename");//表名
																		tablekey = tempMap.get("tablekey");//主字段
																		showfield = tempMap.get("showfield");//显示名称
																		datacondition = tempMap.get("datacondition");//数据显示条件 
																	}else{
																		String sqlStr = "select b.tablename,b.tablekey,b.showfield from mode_customtree a,mode_customtreedetail b where a.id=b.mainid and a.id="+tempfdbtype+"  and b.id="+keyid;
																		recordSet.executeSql(sqlStr);
																		if(recordSet.next()){
																			tablenameStr = recordSet.getString("tablename");//表名
																			tablekey = recordSet.getString("tablekey");//主字段
																			showfield = recordSet.getString("showfield");//显示名称
																			datacondition = recordSet.getString("datacondition").trim();//数据显示条件
																			Map<String,String> tempMap = new HashMap<String,String>();
																			tempMap.put("tablename", tablenameStr);
																			tempMap.put("tablekey", tablekey);
																			tempMap.put("showfield", showfield);
																			tempMap.put("datacondition", datacondition);
																			nodeTableMap.put(keyid, tempMap);
																		}
																	}
																	String shownamesql = "select "+showfield.toLowerCase()+" from "+tablenameStr+" where "+tablekey+" in ("+valid+")";
																	/*if(!datacondition.equals("")){
																		CustomTreeData customTreeData = new CustomTreeData();
																		customTreeData.setUser(user);
																	    datacondition = customTreeData.replaceParam(datacondition);
																		shownamesql += " and "+datacondition;
																	}*/
																	recordSet.executeSql(shownamesql);
																	if(recordSet.next()){
																		String showStr = recordSet.getString(showfield.toLowerCase());
																		showname+=","+showStr;
																	}
																}
																if(!showname.equals("")){
																	showname = showname.substring(1);
																}
															}
															result = showname;
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
											    
											    if(htmltype.equals("8")){// 公共选择项
											        char flag = Util.getSeparator();
											        if(!result.equals("")){
											        	rs1.execute("select id,name from mode_selectitempagedetail where id="+result);
									                    if (rs1.next()){
									                    	result=rs1.getString("name");
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
											        	default:
											        }
												}
     
        										//hj20141211 有子表导出，统计时，连续统计，和报表数据保持一致，连接查询，主表数据多次查询是相同的，
											    if(((String)isstats.get(i)).equals("1")) {
											        double resultdouble = Util.getDoubleValue((String)statvalues.get(i) , 0) ;
											        double tempresultdouble = Util.getDoubleValue((String)tempstatvalues.get(i) , 0) ;
											        /**if(!isdetails.get(i).equals("1")){
											            if(isnew){
											                resultdouble += Util.getDoubleValue(result , 0) ;
											                tempresultdouble += Util.getDoubleValue(result , 0) ;
											                requestid = temRequestid;
											                statvalues.set(i, ""+resultdouble) ;
											                tempstatvalues.set(i, ""+tempresultdouble) ;
											            }else{
											                result = "0";
											            }
											        }else{*/
											        	BigDecimal b1 = new BigDecimal(resultdouble+"");
											        	BigDecimal b2 = new BigDecimal(Util.getDoubleValue(result , 0)+"");
											        	resultdouble = b1.add(b2).doubleValue();
											        	//resultdouble = Double.parseDouble(df.format(resultdouble));
											            //resultdouble += Util.getDoubleValue(result , 0) ;
											            
											            BigDecimal b3 = new BigDecimal(tempresultdouble+"");
											            tempresultdouble = b3.add(b2).doubleValue();
											            //tempresultdouble = Double.parseDouble(df.format(tempresultdouble));
											            //tempresultdouble += Util.getDoubleValue(result , 0) ;
											            requestid = temRequestid;
											            
											            if(type==2){
											            	resultdouble = (int)resultdouble;
											            	tempresultdouble = (int)tempresultdouble;
											            	statvalues.set(i, ((int)resultdouble)+"") ;
												            tempstatvalues.set(i, ((int)tempresultdouble)+"") ;
											            }else if(type==3 || type==4){
											            	String dbtype = Util.null2String(dbtypes.get(i));
											            	int _length = Util.getIntValue(dbtype.substring(dbtype.indexOf(",")+1,dbtype.indexOf(")")));
												        	String _str = "#";
												        	for(int l=0; l<_length; l++){
												        		if(l==0){
												        			_str+=".";
												        		}
												        		_str+="0";
												        	}
												        	DecimalFormat df=new DecimalFormat(_str);
												        	resultdouble = Double.parseDouble(df.format(resultdouble));
											            	tempresultdouble = Double.parseDouble(df.format(tempresultdouble));
											            	
											            	statvalues.set(i, df.format(resultdouble)) ;
												            tempstatvalues.set(i, df.format(tempresultdouble)) ;
											            }else if(type==5){
											            	int _length = Util.getIntValue((String)qfwses.get(i)) ;
												        	String _str = "#";
												        	for(int l=0; l<_length; l++){
												        		if(l==0){
												        			_str+=".";
												        		}
												        		_str+="0";
												        	}
												        	DecimalFormat df=new DecimalFormat(_str);
												        	
												        	resultdouble = Double.parseDouble(df.format(resultdouble));
											            	tempresultdouble = Double.parseDouble(df.format(tempresultdouble));
											            	
											            	statvalues.set(i, df.format(resultdouble)) ;
												            tempstatvalues.set(i, df.format(tempresultdouble)) ;
											            }else{
												            statvalues.set(i, ""+resultdouble) ;
												            tempstatvalues.set(i, ""+tempresultdouble) ;
											            }
											        //}
											    }
					%>
						    					<TD>
					<% 
												if(!((String)isdborders.get(i)).equals("1") || ((String)isdborders.get(i)).equals("1") && (needstat||statcount== 0) ) {
													if(htmltype.equals("1") && (type==3)) {
					%> 
														<%=formatData(result)%>
					<%
											      		er.addStringValue(formatData(result)) ;
										        	}else{
					%>
						        							<%=result%>
					<%
															String tempString = Util.StringReplace(delHtml(result),"%nbsp;"," ");
													    	tempString = Util.StringReplace(tempString,"&dt;&at;"," ");
															tempString = Util.StringReplace(tempString,"&amp;","&");
												         	if((htmltype.equals("1")&&type==1)||htmltype.equals("2")) er.addStringValue(tempString) ;
												         	else er.addValue(tempString) ;
										      		}
				    							} else {
					%>
													<%=result%>
					<%
													er.addStringValue(formatData(result)) ;
					    						}
					%>
						    					</TD>
					<%
											}
   					%>
  										</TR>
					<%
											es.addExcelRow(er) ;
										}
									//}
								//}
							}else{
							    RecordSet.execute(sql);
							   
								while(RecordSet.next()){
								if(ordercount == 1) { //modified by xwj for td2132 on 20050701
									for(int i =0 ; i< fields.size() ; i++) {
										if(((String)isdborders.get(i)).equals("1")) {
											tempvalue = Util.null2String(RecordSet.getString(i+1));
											if(!tempvalue.equals(tempdbordervalue)) {
												needstat = true ;
												tempdbordervalue = tempvalue ;
											} else {
												needstat = false ;
											}
						                }
						            }
						        }
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
									} else {
				                        needstat = false ;
				                    }
				        			tempvalue = "";
								} 
						        if(needstat && statcount != 0 && !isfirst ) {
						            er = es.newExcelRow () ;
       				%>
							        <TR class=TOTAL style="FONT-WEIGHT: bold">
					<% 
									for(int i =0 ; i< tempstatvalues.size() ; i++) {
										er.addStringValue(formatData((String)tempstatvalues.get(i))) ;
					%>
							            <TD><%=formatData((String)tempstatvalues.get(i))%></TD>
					<%
										tempstatvalues.set(i,"") ; }
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
					%>
									<TR class=datadark>
					<%
								}
								String temRequestid = RecordSet.getString("id");

								if(!temRequestid.equals(requestid)){
									isnew = true;
									requestid = temRequestid;
								}else{
									isnew = false;
								}
								String leavetype = "";
								for(int i =0 ; i< fields.size() ; i++) {
								  	String result = Util.null2String(RecordSet.getString(i+1)) ;  	
								    String tcolname= RecordSet.getColumnName(i+1);
								    String htmltype = (String)htmltypes.get(i);
								    int type = Util.getIntValue((String)types.get(i)) ;

									if(tcolname.equalsIgnoreCase("requestname"))  //处理超长的数字会成为科学计数法
									{
								   		result=result+"　";
									}

								    String results[] = null ;
								    if(htmltype.equals("-2")) {
								    	result = Util.toScreen(ResourceComInfo.getResourcename(result),user.getLanguage()) ;
								    }
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
													rs1.execute("select fielddbtype from workflow_billfield where id="+tempfid);
								                     if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
								                    result=WorkflowJspBean.getWorkflowBrowserShowName(result,""+type,"","",tempfdbtype);
												}
								                if (type==162) 
													{
													if(!result.equals("")) result = result.substring(0,result.length()-1);
													}
								                break;  
											case 256:
											case 257:
												String showname = "";
												String showid = result;
												if(!result.equals("")&&!result.equals("NULL")){
													//获取字段的数据库类型
													String tempfid=(String)fieldids.get(i);
													String tempfdbtype="";
														rs1.execute("select fielddbtype from workflow_billfield where id="+tempfid);
									                     if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
									                     
									                     CustomTreeUtil customTreeUtil = new CustomTreeUtil();
									 					 showname = customTreeUtil.getTreeFieldShowName(result,tempfdbtype);
												}
												result = showname;
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
								    
								    if(htmltype.equals("8")){// 公共选择项
								        char flag = Util.getSeparator();
								        if(!result.equals("")){
								        	rs1.execute("select id,name from mode_selectitempagedetail where id="+result);
						                    if (rs1.next()){
						                    	result=rs1.getString("name");
						                    }
								      	}else{
								      	 	result = "";
								      	}
								    }
     
									if(htmltype.equals("6")) {  // 增加文件上传 added xwj for td2127 on 2005-06-20
										switch (type) {
								        	case 1:           
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
								        	default:
								        }
									}
									if(htmltype.equals("1")) {   //处理超长的数字会成为科学计数法(如文本，电话号码)
										if (type==1) 
										{ 
									     	result=result+"　";
									   	}
									}
								    if(((String)isstats.get(i)).equals("1")) {
								        double resultdouble = Util.getDoubleValue((String)statvalues.get(i) , 0) ;
								        double tempresultdouble = Util.getDoubleValue((String)tempstatvalues.get(i) , 0) ;
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
    						<TD>
					<%
									if(!((String)isdborders.get(i)).equals("1") || ((String)isdborders.get(i)).equals("1") && (needstat||statcount== 0) ) { 
										if(htmltype.equals("1") && (type==3)) {
					%> 
											<%=formatData(result)%>
					<%
						
											er.addStringValue(formatData(result)) ;
										}else{
					%>
											<%=result%>
    				<%
											String tempString = Util.StringReplace(delHtml(result),"%nbsp;"," ");
										    tempString = Util.StringReplace(tempString,"&dt;&at;"," ");
											tempString = Util.StringReplace(tempString,"&amp;","&");
	         								if((htmltype.equals("1")&&type==1)||htmltype.equals("2")) er.addStringValue(tempString) ;
	       									else er.addValue(tempString) ;
										}
									} else {
					%>
										<%=result%>
					<%
										er.addStringValue(formatData(result)) ;
									}
    				%>
    						</TD>
    				<%
    							}

					%>
						</TR>
					<%
								es.addExcelRow(er) ;
							}
						}
						if(statcount != 0 && !isfirst ) {
						    er = es.newExcelRow () ;
        			%>
				        <TR class=TOTAL style="FONT-WEIGHT: bold">
				            <% for(int i =0 ; i< tempstatvalues.size() ; i++) {
				                er.addValue(formatData((String)tempstatvalues.get(i))) ;
				            %>
				            <TD><%=formatData((String)tempstatvalues.get(i))%></TD>
				            <%tempstatvalues.set(i,"") ; }%>
				        </tr>
					<%
							es.addExcelRow(er) ;
						}
    					er = es.newExcelRow () ;
					%>
						<TR class=TOTAL style="FONT-WEIGHT: bold">
            		<% 
            			for(int i =0 ; i< statvalues.size() ; i++) {
                			er.addValue(formatData((String)statvalues.get(i))) ;
            		%>
							<TD><%=formatData((String)statvalues.get(i))%></TD>
					<%
							statvalues.set(i,"") ; 
						}
					%>
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
    }
    
    return Util.HTMLtoTxt(textStr).trim();// 返回文本字符串
}

    private String formatData(String inData){
        if(inData==null||inData.equals("")){
            return "";
        }
        try{
        	return inData;
            //return new BigDecimal(  Util.null2String(inData).equals("")?"0":Util.null2String(inData) ).setScale(2,BigDecimal.ROUND_HALF_UP).toString();
        }catch(Exception e){
            return inData;
        }
    }

%>
<%
	ExcelFile.init() ;
	ExcelFile.setFilename(reportname) ;
	ExcelFile.addSheet(reportname, es) ;
%>
</BODY></HTML>

<script type="text/javascript">
<!--
//setTimeout(function () {
	//window.parent.document.getElementById("excelwaitDiv").style.display = "none";	
//}, 1000);
window.location.href = "/weaver/weaver.file.ExcelOut";
//-->
</script>
