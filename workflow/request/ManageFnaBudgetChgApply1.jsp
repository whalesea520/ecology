<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,java.util.*,weaver.conn.*" %>
<%@ page import="java.math.*" %>
 <%@ page import="weaver.fna.budget.BudgetHandler"%>
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>
 <jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
 <jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
 <jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
 <jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
 <jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
 <jsp:useBean id="WorkflowJspBean" class="weaver.workflow.request.WorkflowJspBean" scope="page"/>
<%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<%
DecimalFormat df = new DecimalFormat("0.00");
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

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
boolean fnaBudgetOAOrg = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetOAOrg());
boolean fnaBudgetCostCenter = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetCostCenter());

int subjectFieldId = 0;
RecordSet.executeSql("select * from workflow_billfield where billid = 159  and   fieldname='subject' ");
if(RecordSet.next()){
	subjectFieldId = RecordSet.getInt("id");
}

RecordSet rs_11 = new RecordSet();


WorkflowJspBean.setBillid(billid);
WorkflowJspBean.setFormid(formid);
WorkflowJspBean.setIsbill(isbill);
WorkflowJspBean.setNodeid(nodeid);
WorkflowJspBean.setRequestid(requestid);
WorkflowJspBean.setUser(user);
WorkflowJspBean.setWorkflowid(workflowid);
WorkflowJspBean.getWorkflowFieldInfo();
ArrayList fieldids=WorkflowJspBean.getFieldids();             //字段队列
ArrayList fieldorders = WorkflowJspBean.getFieldorders();        //字段显示顺序队列 (单据文件不需要)
ArrayList languageids=WorkflowJspBean.getLanguageids();          //字段显示的语言(单据文件不需要)
ArrayList fieldlabels=WorkflowJspBean.getFieldlabels();          //单据的字段的label队列
ArrayList fieldhtmltypes=WorkflowJspBean.getFieldhtmltypes();       //单据的字段的html type队列
ArrayList fieldtypes=WorkflowJspBean.getFieldtypes();           //单据的字段的type队列
ArrayList fieldnames=WorkflowJspBean.getFieldnames();           //单据的字段的表字段名队列
ArrayList fieldvalues=WorkflowJspBean.getFieldvalues();          //字段的值
ArrayList fieldviewtypes=WorkflowJspBean.getFieldviewtypes();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
ArrayList fieldimgwidths=WorkflowJspBean.getImgwidths();
ArrayList fieldimgheights=WorkflowJspBean.getImgheights();
ArrayList fieldimgnums=WorkflowJspBean.getImgnumprerows();
int fieldlen=0;  //字段类型长度
ArrayList fieldrealtype=WorkflowJspBean.getFieldrealtype();
String fielddbtype="";                              //字段数据类型
String textheight = "4";//xwj for @td2977 20051111
WorkflowJspBean.getWorkflowFieldViewAttr();


// 确定字段是否显示，是否可以编辑，是否必须输入
ArrayList isfieldids=WorkflowJspBean.getIsfieldids();              //字段队列
ArrayList isviews=WorkflowJspBean.getIsviews();              //字段是否显示队列
ArrayList isedits=WorkflowJspBean.getIsedits();              //字段是否可以编辑队列
ArrayList ismands=WorkflowJspBean.getIsmands();              //字段是否必须输入队列

String uid = "" + creater;

String uname = ResourceComInfo.getLastname(uid);
String udept = ResourceComInfo.getDepartmentID(uid);
String udeptname = DepartmentComInfo.getDepartmentname(udept);
String usubcom = DepartmentComInfo.getSubcompanyid1(udept);
weaver.hrm.company.SubCompanyComInfo scci = new weaver.hrm.company.SubCompanyComInfo();
String usubcomname = scci.getSubCompanyname(usubcom);

String temporganizationidisview="0";
String temporganizationidisedit="0";
String temporganizationidismandatory="0";
String temprogtypeisview="0";
boolean wfmonitor="true".equals(session.getAttribute(userid+"_"+requestid+"wfmonitor"))?true:false;                //流程监控人

BigDecimal amountsum = new BigDecimal("0") ;
double amount=0;
BigDecimal applyamountsum = new BigDecimal("0") ;
int quantitysum = 0 ;
boolean isttLight = false;
int recorderindex = 0 ;
sql="select *  from Bill_FnaBudgetChgApplyDetail where id="+billid+" order by dsporder";

RecordSet.executeSql(sql);
while(RecordSet.next()) {
	BigDecimal applyamount = new BigDecimal("0.000");//TD12002
	isttLight = !isttLight ;
%>
               <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
               <td width="5%"><input type='checkbox' name='check_node' value='<%=recorderindex%>' <%if(dtldelete.equals("0")){%>disabled<%}%>></td>
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

		String fieldname = (String)fieldnames.get(i);   //字段数据库表中的字段名
		String fieldvalue =  Util.null2String(RecordSet.getString(fieldname)) ;
		int organizationtype = RecordSet.getInt("organizationtype");
		int organizationid = RecordSet.getInt("organizationid");
		String budgetperiod = RecordSet.getString("budgetperiod");
		int subject = RecordSet.getInt("subject");
		BudgetHandler bp = new BudgetHandler();
		double oldbudget = bp.getBudgetByDate(budgetperiod, organizationtype, organizationid, subject);
		/**TD12002*/
		BigDecimal dOldbudget = new BigDecimal(String.valueOf(oldbudget)) ;
		if(! isview.equals("1") &&fieldname.equals("organizationtype")){
			isview=temporganizationidisview;
			isedit=temporganizationidisedit;
			ismand=temporganizationidismandatory;
		}
		if("0".equals(dtledit)){
			isedit="0" ;    //字段是否可以编辑
			ismand="0" ;    //字段是否必须输入
		}
		if( ! isview.equals("1") ) {
%>
                     <input type=hidden name="<%=fieldname%>_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
		}else {
			if(ismand.equals("1"))  needcheck+= ","+fieldname+"_"+recorderindex;
			if("organizationtype,organizationid,subject,budgetperiod,relatedprj,relatedcrm,description,oldamount,amount,applyamount,changeamount".indexOf(fieldname)>-1){
                         //如果必须输入,加入必须输入的检查中
%>                  <td >
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
				if(isedit.equals("1") && isremark==0 ){
%>
                     <select id="organizationtype_<%=recorderindex%>" name="organizationtype_<%=recorderindex%>" onchange="clearSpan(<%=recorderindex%>)">
                     <%if(fnaBudgetOAOrg){ %>
                     	<option value=3 <%if(orgtype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>
                     	<option value=2  <%if(orgtype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                     	<option value=1 <%if(orgtype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                     <%} %>
                     <%if(fnaBudgetCostCenter){ %>
                     	<option value='<%=FnaCostCenter.ORGANIZATION_TYPE+"" %>' <%if(orgtype.equals((FnaCostCenter.ORGANIZATION_TYPE+""))){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></option>
                     <%} %>
                     </select>
<%
				}else{
%>
                     <input type=hidden id="organizationtype_<%=recorderindex%>" name="organizationtype_<%=recorderindex%>"  value="<%=orgtype%>"><%=showname%>
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
				if(isedit.equals("1") && isremark==0){
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
			}else if( fieldname.equals("subject")) {
				showname = Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(fieldvalue),user.getLanguage()) ;
				//查询父级科目
				if(!fieldvalue.equals("0")){
					int enableDispalyAll = Util.getIntValue(fnaSystemSetComInfo.get_enableDispalyAll());
					String separator = Util.null2String(fnaSystemSetComInfo.get_separator());
					
					if(enableDispalyAll==1){
						showname = BudgetfeeTypeComInfo.getSubjectFullName(fieldvalue, separator);;
					}
				}
				if( fieldvalue.equals("0") ) fieldvalue = "" ;
				if(isedit.equals("1") && isremark==0){
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
				initE8Browser("subject_<%=recorderindex %>", <%=recorderindex %>, <%=ismand %>, "<%=fieldvalue%>", "<%=showname%>", detailbrowclick, "/data.jsp?type=22&bdf_wfid=<%=workflowid%>&bdf_fieldid=<%=subjectFieldId%>");
			});
		</script>
<%
				}else{
%>
		<input type="hidden" viewtype="<%=ismand %>" temptitle="" name="subject_<%=recorderindex%>" id="subject_<%=recorderindex%>" value="<%=fieldvalue%>" />
		<%=showname %>
<%		
				}
			}else if( fieldname.equals("budgetperiod")) {
				if(isedit.equals("1") && isremark==0){
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
			}else if( fieldname.equals("relatedprj"))  {
				showname = Util.toScreen(ProjectInfoComInfo.getProjectInfoname(fieldvalue),user.getLanguage()) ;
				if( fieldvalue.equals("0") ) fieldvalue = "" ;
				if(isedit.equals("1") && isremark==0){
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
			}else if( fieldname.equals("relatedcrm")) {
				showname = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(fieldvalue),user.getLanguage()) ;
				if( fieldvalue.equals("0") ) fieldvalue = "" ;
				if(isedit.equals("1") && isremark==0){
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
				if(isedit.equals("1") && isremark==0 ){
					if(ismand.equals("1")) {
%>
                     <input type=text class=inputstyle  name="description_<%=recorderindex%>" style="width:85%" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" onChange="checkinput('description_<%=recorderindex%>','descriptionspan_<%=recorderindex%>')">
                     <span id="descriptionspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
					}else{
%>
                     <input type=text class=inputstyle  name="description_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" style="width:85%">
<%                            
				}
				}else {
%>
                    <%=Util.toScreen(fieldvalue,user.getLanguage())%>
                     <input type=hidden name="description_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
<%
				}
			}else if( fieldname.equals("oldamount"))  {

%>
<!-- td12002 -->
                     <span id='oldamountspan_<%=recorderindex%>'><%=dOldbudget.toPlainString()%></span>
					 <input type=hidden id='oldamount_<%=recorderindex%>' name='oldamount_<%=recorderindex%>' value="<%=fieldvalue%>">

<%
			}else if( fieldname.equals("applyamount")) {
				applyamount=applyamount.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0)));//TD12002
				if( Util.getDoubleValue(fieldvalue,0) == 0 ){
					fieldvalue="" ;
				}else{
					applyamountsum = applyamountsum.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
				}
				if(isedit.equals("1") && isremark==0 ){
					if(ismand.equals("1")) {
%>
                                                 <input type=text class=inputstyle  name="applyamount_<%=recorderindex%>" style="width:99%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('applyamount_<%=recorderindex%>','applyamountspan_<%=recorderindex%>');changeapplynumber(<%=recorderindex%>);">
                                                 <span id="applyamountspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
					}else{
%>
                                                 <input type=text class=inputstyle  name="applyamount_<%=recorderindex%>" style="width:99%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this);changeapplynumber(<%=recorderindex%>);'>
<%
					}
				}else {
%>
                    <%=fieldvalue%><input type=hidden name="applyamount_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
				}
			}else if( fieldname.equals("amount")) {
				amount=Util.getDoubleValue(fieldvalue,0) ;
				//if( Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue="" ;
				if( Util.getDoubleValue(fieldvalue,0) == 0 ) {
					fieldvalue="" ;
				}else{
					amountsum = amountsum.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
				}
				if(isedit.equals("1") && isremark==0 ){
					if(ismand.equals("1")) {
%>
                                                 <input type=text class=inputstyle  name="amount_<%=recorderindex%>" style="width:99%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('amount_<%=recorderindex%>','amountspan_<%=recorderindex%>');changenumber(<%=recorderindex%>);">
                                                 <span id="amountspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
					}else{
%>
                                                 <input type=text class=inputstyle  name="amount_<%=recorderindex%>" style="width:99%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this);changenumber(<%=recorderindex%>);'>
<%
					}
                                                        
				} else {
%>
                    <%=fieldvalue%><input type=hidden name="amount_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
				}
			} else if( fieldname.equals("changeamount"))  {
				//TD12002 不使用科学计数法显示(且审批预算为空时以新预算计算差额)
				BigDecimal changeamount = (new BigDecimal(oldbudget)).negate();				
				if (amount > 0) {
					changeamount = changeamount.add(new BigDecimal(amount));
				} else {
					changeamount = changeamount.add(applyamount);
				}
				
				//BigDecimal changeamount = new BigDecimal(amount-oldbudget);
				changeamount = changeamount.divide ( new BigDecimal ( 1 ), 3, BigDecimal.ROUND_HALF_UP );
%>
<!-- TD12002 不使用科学计数法显示 -->
                     <span id='changeamountspan_<%=recorderindex%>'><%=df.format(changeamount)%></span>
<%
			}

%>
                     </td>
<%
		}
		}
	}
	recorderindex ++ ;
%>
               </tr>
<%          
}   
%>
 <script language=javascript>
 try{document.all("needcheck").value+=",<%=needcheck%>";}catch(ex1){}
 </script>