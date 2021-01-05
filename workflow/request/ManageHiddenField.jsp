<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.conn.RecordSet"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.Maint.CustomerInfoComInfo"%> 
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
	<jsp:useBean id="CustomerInfoComInfo1" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="deptVirComInfo1" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="subCompVirComInfo1" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="urlcominfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="docReceiveUnitComInfo_mhf" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="requestPreAddM" class="weaver.workflow.request.RequestPreAddinoperateManager" scope="page" />
<jsp:useBean id="leaveTypeColorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<%@ page import="java.util.Calendar,java.util.Hashtable" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.fna.budget.BudgetHandler" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<div style="display:none">
<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
</table>
</div>
<%
RecordSet rs_11 = new RecordSet();

boolean fnaBudgetOAOrg = false;//OA组织机构
boolean fnaBudgetCostCenter = false;//成本中心
rs_11.executeSql("select * from FnaSystemSet");
if(rs_11.next()){
	fnaBudgetOAOrg = 1==rs_11.getInt("fnaBudgetOAOrg");
	fnaBudgetCostCenter = 1==rs_11.getInt("fnaBudgetCostCenter");
}

String comboInitJsStr = "";
String comboInitDetailJsStrAll = "";
String comboInitDetailJsStr = "";
String acceptlanguage = request.getHeader("Accept-Language");
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
session.setAttribute("f_weaver_belongto_userid",f_weaver_belongto_userid);
session.setAttribute("f_weaver_belongto_usertype",f_weaver_belongto_usertype);
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
int requestid = Util.getIntValue(request.getParameter("requestid"));

int creater = Util.getIntValue(request.getParameter("creater"),0);              //请求的创建人
int creatertype = Util.getIntValue(request.getParameter("creatertype"),0);        //创建人类型 0: 内部用户 1: 外部用户

int workflowid = Util.getIntValue(request.getParameter("workflowid"));
String paranodeid = Util.null2String(request.getParameter("nodeid"));
int formid = Util.getIntValue(request.getParameter("formid"),0);
String billid = Util.null2String(request.getParameter("billid"));    
String isbill = Util.null2String(request.getParameter("isbill"));
int Languageid = Util.getIntValue(request.getParameter("Languageid"));

int isaffirmance = Util.getIntValue(request.getParameter("isaffirmance"));//是否需要提交确认




int reEdit = Util.getIntValue(request.getParameter("reEdit"));

String currentdate = Util.null2String(request.getParameter("currentdate"));
String currenttime = Util.null2String(request.getParameter("currenttime"));

String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
String newdocid = Util.null2String(request.getParameter("newdocid"));        // 新建的文档




int isremark=Util.getIntValue(request.getParameter("isremark"));
boolean IsCanModify="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsCanModify"))?true:false;
boolean editbodymodeflag=false;
if(isremark==0||IsCanModify) editbodymodeflag=true;
String organizationtype="";
String budgetperiod="";
String organizationid="";
String subject="";
String hrmremain="";
String deptremain="";
String subcomremain="";
String fccremain="";
String loanbalance="";
String oldamount="";

String m_fromdateid = "";
String m_enddateid = "";
String m_fromtimeid = "";
String m_endtimeid = "";

if(85 == formid) {
  rsaddop.executeSql("select id from workflow_billfield where billid = 85 and fieldname = 'BeginDate' ");
  if(rsaddop.next()) m_fromdateid = "field"+rsaddop.getString(1);
 
  rsaddop.executeSql("select id from workflow_billfield where billid = 85 and fieldname = 'EndDate' ");
  if(rsaddop.next()) m_enddateid = "field"+rsaddop.getString(1);

  rsaddop.executeSql("select id from workflow_billfield where billid = 85 and fieldname = 'BeginTime' ");
  if(rsaddop.next()) m_fromtimeid = "field"+rsaddop.getString(1);

  rsaddop.executeSql("select id from workflow_billfield where billid = 85 and fieldname = 'EndTime' ");
  if(rsaddop.next()) m_endtimeid = "field"+rsaddop.getString(1);
} 
if(163 == formid) {
  RecordSet.executeSql("select id from workflow_billfield where billid = 163 and fieldname = 'startDate' ");
  if(RecordSet.next()) m_fromdateid = "field"+RecordSet.getString(1);
 
  RecordSet.executeSql("select id from workflow_billfield where billid = 163 and fieldname = 'endDate' ");
  if(RecordSet.next()) m_enddateid = "field"+RecordSet.getString(1);

  RecordSet.executeSql("select id from workflow_billfield where billid = 163 and fieldname = 'startTime' ");
  if(RecordSet.next()) m_fromtimeid = "field"+RecordSet.getString(1);

  RecordSet.executeSql("select id from workflow_billfield where billid = 163 and fieldname = 'endTime' ");
  if(RecordSet.next()) m_endtimeid = "field"+RecordSet.getString(1);
}

if(isbill.equals("1")&&(formid==156 ||formid==157 ||formid==158 ||formid==159)){
    RecordSet.executeSql("select fieldname,id from workflow_billfield where viewtype=1 and billid="+formid);
    while(RecordSet.next()){
        if("budgetperiod".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        budgetperiod="field"+RecordSet.getString("id");
        if("organizationtype".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        organizationtype="field"+RecordSet.getString("id");
        if("organizationid".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        organizationid="field"+RecordSet.getString("id");
        if("subject".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        subject="field"+RecordSet.getString("id");
        if("hrmremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            hrmremain="field"+RecordSet.getString("id");
        }
        if("deptremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            deptremain="field"+RecordSet.getString("id");
        }
        if("subcomremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            subcomremain="field"+RecordSet.getString("id");
        }
        if("fccremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
        	fccremain="field"+RecordSet.getString("id");
        }
        if("loanbalance".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            loanbalance="field"+RecordSet.getString("id");
        }
        if("oldamount".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            oldamount="field"+RecordSet.getString("id");
        }
    }
}
BudgetHandler bp = new BudgetHandler();

ArrayList flowDocs=flowDoc.getDocFiled(""+workflowid); //得到流程建文挡的发文号字段




String codeField="";
String flowDocField="";
String flowCat="";
String newTextNodes = "";//判断正文新建是否要选择按钮
if (flowDocs!=null&&flowDocs.size()>1)
{
codeField=""+flowDocs.get(0);
flowDocField=""+flowDocs.get(1);
flowCat=""+flowDocs.get(3);
newTextNodes = "" +flowDocs.get(5);
}
String docFlags=Util.null2String((String)session.getAttribute("requestAdd"+requestid));
if (docFlags.equals("")) docFlags=Util.null2String((String)session.getAttribute("requestAdd"+user.getUID()));

String isannexupload_edit="";
String annexdocCategory_edit="";
String isSignMustInput="0";
int hrmResourceShow = 0;
RecordSet.executeSql("select isannexupload,annexdocCategory,hrmResourceShow  from workflow_base where id="+workflowid);
if (RecordSet.next()) {
	isannexupload_edit=Util.null2String(RecordSet.getString(1));
	annexdocCategory_edit=Util.null2String(RecordSet.getString(2));
    hrmResourceShow = Util.getIntValue(RecordSet.getString("hrmResourceShow"));
}
RecordSet.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+paranodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
}

session.setAttribute(user.getUID()+"_"+workflowid+"isannexupload",isannexupload_edit);
session.setAttribute(user.getUID()+"_"+workflowid+"annexdocCategory",annexdocCategory_edit);
String bodychangattrstr="";
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(workflowid,Util.getIntValue(paranodeid),0);
ArrayList seldefieldsadd=WfLinkageInfo.getSelectField(workflowid,Util.getIntValue(paranodeid),1);
String stringseldefieldsadd="";
for(int i=0;i<seldefieldsadd.size();i++){
	stringseldefieldsadd+=(String)seldefieldsadd.get(i)+",";
}

String iswfshare = Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"iswfshare"));

ArrayList changefieldsdemanage=WfLinkageInfo.getChangeField(workflowid,Util.getIntValue(paranodeid),0);
ArrayList changedefieldsmanage=WfLinkageInfo.getChangeField(workflowid,Util.getIntValue(paranodeid),1);
FieldInfo.setRequestid(requestid);
FieldInfo.setUser(user);
FieldInfo.setIswfshare(iswfshare);
FieldInfo.GetManTableField(formid,Util.getIntValue(isbill),Languageid);
FieldInfo.GetDetailTableField(formid,Util.getIntValue(isbill),Languageid);
FieldInfo.GetWorkflowNode(workflowid);

int managerid=FieldInfo.getManagerFieldID(formid,Util.getIntValue(isbill));
ArrayList mantablefields=FieldInfo.getManTableFields();
ArrayList ManTableFieldFieldNames=FieldInfo.getManTableFieldFieldNames();    
ArrayList manfieldvalues=FieldInfo.getManTableFieldValues();
ArrayList manfielddbtypes=FieldInfo.getManTableFieldDBTypes();
ArrayList manTableChildFields=FieldInfo.getManTableChildFields();
ArrayList detailtablefields=FieldInfo.getDetailTableFields();
ArrayList DetailTableIds=FieldInfo.getDetailTableIds();
ArrayList detailfieldvalues=FieldInfo.getDetailTableFieldValues();
ArrayList detailtablefieldids=FieldInfo.getDetailTableFieldIds();
ArrayList ManUrlList=FieldInfo.getManUrlList();
ArrayList ManUrlLinkList=FieldInfo.getManUrlLinkList();
ArrayList DetailUrlList=FieldInfo.getDetailUrlList();
ArrayList DetailUrlLinkList=FieldInfo.getDetailUrlLinkList();
ArrayList NodeList=FieldInfo.getNodes();
ArrayList DetailFieldIsViews=FieldInfo.getDetailFieldIsViews();
ArrayList DetailFieldDBTypes=FieldInfo.getDetailFieldDBTypes();
ArrayList detailTableChildFields=FieldInfo.getDetailTableChildFields();
ArrayList DetailDBFieldNames=FieldInfo.getDetailDBFieldNames();
ArrayList mantablefieldlables=new ArrayList();
ArrayList detailtablefieldlables=new ArrayList();
mantablefieldlables=FieldInfo.getManTableFieldNames();
detailtablefieldlables=FieldInfo.getDetailTableFieldNames();

//节点前附加操作




//TD10029 节点前附加操作




ArrayList inoperatefields = new ArrayList();
ArrayList inoperatevalues = new ArrayList();
int fieldop1id=0;
requestPreAddM.setCreater(user.getUID());
requestPreAddM.setOptor(user.getUID());
requestPreAddM.setWorkflowid(workflowid);
requestPreAddM.setNodeid(Util.getIntValue(paranodeid));
requestPreAddM.setRequestid(requestid);
Hashtable getPreAddRule_hs = requestPreAddM.getPreAddRule();
inoperatefields = (ArrayList)getPreAddRule_hs.get("inoperatefields");
inoperatevalues = (ArrayList)getPreAddRule_hs.get("inoperatevalues");
//System.out.print("select fieldid,customervalue from workflow_addinoperate where workflowid=" + workflowid + " and ispreadd='1' and isnode = 1 and objid = "+paranodeid);

String isFormSignature=null;
RecordSet.executeSql("select isFormSignature from workflow_flownode where workflowId="+workflowid+" and nodeId="+paranodeid);
if(RecordSet.next()){
	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
}
%>
<input type=hidden name='stringseldefieldsadd' value=<%=stringseldefieldsadd%>>
<input type=hidden name='formid' value=<%=formid%>>
<input type=hidden name='isbill' value=<%=isbill%>>
<input type=hidden name="requestid" id="requestid" value="<%=requestid%>">
<input type=hidden name="workflowid" id="workflowid" value="<%=workflowid%>">
<input type=hidden name="hrmResourceShow" id="hrmResourceShow" value="<%=hrmResourceShow%>">
<input type=hidden name="isSignMustInput" id="isSignMustInput" value="<%=isSignMustInput%>">
<input type=hidden name="calfields" id="calfields" value="">
<input type=hidden name="caldetfields" id="caldetfields" value="">
<input type=hidden name="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" value="">
<iframe name="delzw" width=0 height=0 style="border:none;"></iframe>
<%
    int inprepIdTemp=0;
    String inprepfrequenceTemp="";
    String isInputMultiLine="";
    String inprepTableName="";
	String reportDate="";
    RecordSet.executeSql("select inprepId,inprepfrequence,isInputMultiLine,inprepTableName  from T_InputReport where billId="+formid);
    if(RecordSet.next()){
		inprepIdTemp=Util.getIntValue(RecordSet.getString("inprepId"),0);
		inprepfrequenceTemp=Util.null2String(RecordSet.getString("inprepfrequence"));
		isInputMultiLine=Util.null2String(RecordSet.getString("isInputMultiLine"));
		inprepTableName=Util.null2String(RecordSet.getString("inprepTableName"));
        String sqlTemp=null;
        if(!inprepTableName.equals("")){
        if(isInputMultiLine.equals("1")){
            sqlTemp="select reportDate from "+inprepTableName+"_main"+" where requestId="+requestid;
        }else{
            sqlTemp="select reportDate from "+inprepTableName+" where requestId="+requestid;
        }
        RecordSet.executeSql(sqlTemp);
        if(RecordSet.next()){
            reportDate=Util.null2String(RecordSet.getString("reportDate"));
        }
        }
    }
%>
<input type=hidden name='inprepIdTemp' value="<%=inprepIdTemp%>">
<input type=hidden name='inprepfrequenceTemp' value="<%=inprepfrequenceTemp%>">

<%
    Calendar todayTemp = Calendar.getInstance();
    todayTemp.add(Calendar.DATE, -1) ;
    String currentYearTemp = Util.add0(todayTemp.get(Calendar.YEAR), 4) ;
    String yearTemp = "";
    String monthTemp = "";
    String dayTemp =  "";
    String dateTemp = reportDate;
    ArrayList  reportDateList =Util.TokenizerString(reportDate,"-");
    if(reportDateList.size()==3){
    	yearTemp=(String)reportDateList.get(0);
    	monthTemp=(String)reportDateList.get(1);
    	dayTemp=(String)reportDateList.get(2);
    }

%>
<input type=hidden name='year' value="<%=yearTemp%>">
<input type=hidden name='month' value="<%=monthTemp%>">
<input type=hidden name='day' value="<%=dayTemp%>">
<input type=hidden name='date' value="<%=dateTemp%>">
<input type=hidden name='currentYearTemp' value="<%=currentYearTemp%>">

<%
String managerStr = "";
String beagenter=""+user.getUID();
int beagenter1=user.getUID();
//获得被代理人
RecordSet.executeSql("select agentorbyagentid from workflow_currentoperator where usertype=0 and isremark='0' and requestid="+requestid+" and userid="+beagenter+" and nodeid="+paranodeid+" order by id desc");
if(RecordSet.next()){
	int tembeagenter = RecordSet.getInt(1);
	if(tembeagenter>0){
		beagenter=""+tembeagenter;
		beagenter1=tembeagenter;
	}
}
int body_isagent=Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()),0);
session.removeAttribute("beagenter_"+user.getUID());
session.setAttribute("beagenter_"+user.getUID(), beagenter);
if(managerid>0){
    //QC169123
    //判断是否客户门户
    if(user.getLogintype().equals("2")){
        CustomerInfoComInfo customerInfoComInfo = new CustomerInfoComInfo();
        managerStr = customerInfoComInfo.getCustomerInfomanager(beagenter);
    }else{
        managerStr = ResourceComInfo.getManagerID(beagenter);
    }
%>
<input type='hidden' id='field<%=managerid%>' name='field<%=managerid%>' temptitle='' value='<%=managerStr%>'>
<%
}
String subcompanyidofdefaultuser = ResourceComInfo.getSubCompanyID(""+user.getUID());
String departmentidofdefaultuser = ResourceComInfo.getDepartmentID(""+user.getUID());
String jobtitleidofdefaultuser = ResourceComInfo.getJobTitle(""+user.getUID());
if(body_isagent==1) {
	subcompanyidofdefaultuser = ResourceComInfo.getSubCompanyID(""+beagenter);
	departmentidofdefaultuser = ResourceComInfo.getDepartmentID(""+beagenter);
	jobtitleidofdefaultuser = ResourceComInfo.getJobTitle(""+beagenter);
	}
%>
<% if(body_isagent==1) {%>
<input type=hidden name='userid' value=<%=beagenter1%>>
<% }else{ %>
<input type=hidden name='userid' value=<%=user.getUID()%>>
<% } %>
<input type=hidden name='subcompanyidofuser' value=<%=subcompanyidofdefaultuser%>>
<input type=hidden name='departmentidofuser' value=<%=departmentidofdefaultuser%>>
<input type=hidden name='jobtitleidofdefaultuser' value=<%=jobtitleidofdefaultuser%>>
<%
String fieldid="";
String fieldName="";    
String filedname="";
String fieldvalue="";
String url="";
String urllink="";
/*装载表头*/
for(int i=0; i<mantablefields.size();i++){
    int htmltype=1;
    int type=1;
    int indx=-1;
    fieldid=(String)mantablefields.get(i);
    filedname=(String)mantablefieldlables.get(i);
    fieldvalue=(String)manfieldvalues.get(i);
    url=(String)ManUrlList.get(i);
	String urls = "/systeminfo/Calendar_mode.jsp";
	if(url.indexOf("systeminfo/Calendar.jsp")>0){  //模板模式 单独处理日期控件
	   url= url.replace(url,urls);
	}
    urllink=(String)ManUrlLinkList.get(i);
    indx=fieldid.lastIndexOf("_");
    int childfieldid_tmp = Util.getIntValue((String)manTableChildFields.get(i), 0);
    if(indx>0){
        htmltype=Util.getIntValue(fieldid.substring(indx+1),1);
        fieldid=fieldid.substring(0,indx);            
    }
    indx=fieldid.lastIndexOf("_");
    if(indx>0){
        type=Util.getIntValue(fieldid.substring(indx+1),1);
        fieldid=fieldid.substring(0,indx);    
    }
    if(htmltype==6){
        ArrayList filenum=new ArrayList();
        if(!fieldvalue.equals("")){
            filenum=Util.TokenizerString(fieldvalue,",");
        }
        for(int n=0;n<filenum.size();n++){
%>   
    <input type=hidden name="<%=fieldid%>_id_<%=n%>" value="<%=filenum.get(n)%>">
    <input type=hidden name="<%=fieldid%>_del_<%=n%>" value="0">
<%
        }
%>   
    <input type=hidden id="<%=fieldid%>_num" name='<%=fieldid%>_num' value="0"> 
    <input type=hidden name="<%=fieldid%>_idnum" value="<%=filenum.size()%>">
    <input type=hidden temptitle="<%=filedname%>" name="<%=fieldid%>" value="<%=fieldvalue%>">
<%
    }else{
        if(htmltype==3){
		if(managerid>0 && fieldid.equals("field"+managerid)){
%>


<script language="javascript">
var js_hrmResourceShow = "<%=hrmResourceShow%>";
	$G("field<%=managerid%>").temptitle="<%=filedname%>";
</script>
<%}else{%>
	<input type="hidden" temptitle="<%=filedname%>" id="<%=fieldid%>" name="<%=fieldid%>" value="<%=fieldvalue%>">
<%}%>
    <input type="hidden" id="<%=fieldid%>_url" name="<%=fieldid%>_url" value="<%=url%>">
    <input type="hidden" id="<%=fieldid%>_urllink" name="<%=fieldid%>_urllink" value="<%=urllink%>">
    <input type="hidden" id="<%=fieldid%>_linkno" name="<%=fieldid%>_linkno" value="">
<%
            if(type==160){
%>
                <input type="hidden" temptitle="<%=filedname%>" id="resourceRoleId<%=fieldid%>" name="resourceRoleId<%=fieldid%>" value="-1">
<%
            }
        }else if(htmltype == 7 && type==1){
%>
    <input type="hidden" temptitle="<%=filedname%>" name="<%=fieldid%>" value="<%=fieldvalue%>">
    <input type="hidden" name="<%=fieldid%>_url" value="<%=url%>">
    <input type="hidden" name="<%=fieldid%>_urllink" value="<%=urllink%>">
    <input type="hidden" name="<%=fieldid%>_linkno" value="">         
<%           
        }else if(htmltype ==9){
          %>  <input type="hidden" temptitle="<%=filedname%>" name="<%=fieldid%>" value=""><% 
        }else{
        	int pfieldid_tmp = 0;
        	if(manTableChildFields.contains(fieldid.substring(5))){
        		String pfieldStr_tmp = (String)mantablefields.get(manTableChildFields.indexOf(fieldid.substring(5)));
        		pfieldStr_tmp = pfieldStr_tmp.substring(5, pfieldStr_tmp.indexOf("_"));
        		pfieldid_tmp = Util.getIntValue(pfieldStr_tmp, 0);
			}
%>
        	<input type="hidden" id="childField<%=fieldid%>" name="childField<%=fieldid%>" value="<%=childfieldid_tmp%>">
        	<input type="hidden" id="pField<%=fieldid%>" name="pField<%=fieldid%>" value="<%=pfieldid_tmp%>">
<%
     if(htmltype==2&&type==2) {%>
	 <textarea style="display:none" temptitle="<%=filedname%>" name="<%=fieldid%>"><%=FieldInfo.toScreen(fieldvalue)%></textarea>	
	<%}
	else {
		String ffieldvalue = FieldInfo.toScreen(Util.StringReplace(fieldvalue,"\"","&quot;"));
    	if(htmltype == 2 && type == 1) {
    		ffieldvalue = Util.StringReplace(ffieldvalue, "<", "&lt;");
    		ffieldvalue = Util.StringReplace(ffieldvalue, ">", "&gt;");
    	}
%>
    <input type="hidden" temptitle="<%=filedname%>" name="<%=fieldid%>" value="<%=ffieldvalue%>">
<%
        if(fieldid.equals("field"+flowCat)){
%>
	<input type=hidden name="old<%=fieldid%>" id="old<%=fieldid%>" value="<%=ffieldvalue%>">
<%
		}

	}   }
    }
    String tempfieldid=fieldid;
    if(tempfieldid.length()>5) tempfieldid=tempfieldid.substring(5);
    //if(selfieldsadd.indexOf(tempfieldid)>=0) bodychangattrstr+="changeshowattrBymode('"+tempfieldid+"_0','"+fieldvalue+"',-1,"+workflowid+","+paranodeid+");";
    fieldName=Util.null2String((String)ManTableFieldFieldNames.get(i));
	if(fieldName.equals("reportUserId")&&"1".equals(isbill)&&(formid<0)){
%>
    <input type="hidden" name="reportUserIdInputName" value="<%=fieldid%>">
<%
	}
	if(fieldName.equals("crmId")&&"1".equals(isbill)&&(formid<0)){
%>
    <input type="hidden" name="crmIdInputName" value="<%=fieldid%>">
<%
	}
	if(fieldName.equals("inprepDspDate")&&"1".equals(isbill)&&(formid<0)){
%>
    <input type="hidden" name="inprepDspDateInputName" value="<%=fieldid%>">
<%
	}
    if(fieldid.length()>5&&changefieldsdemanage.indexOf(fieldid.substring(5))>=0){
%>
    <input type="hidden" id="oldfield<%=fieldid.substring(5)%>" name="oldfield<%=fieldid.substring(5)%>" value="0|0|<%=mantablefields.get(i)%>">
<%
	}
}

//标题,紧急程度，是否短信提醒
String requestname = Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"requestname"));
String requestlevel = Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"requestlevel"));
String sqlWfMessage = "select a.messagetype from workflow_requestbase a,workflow_base b where a.workflowid=b.id and b.messagetype='1' and a.requestid="+requestid ;
RecordSet.executeSql(sqlWfMessage);
int rqMessageType=0;
if(RecordSet.next()){
	rqMessageType=RecordSet.getInt("messagetype");
}
//微信提醒START(QC:98106)
String sqlWfChat = "select a.chatstype from workflow_requestbase a,workflow_base b where a.workflowid=b.id and b.chatstype='1' and a.requestid="+requestid ;
RecordSet.executeSql(sqlWfChat);
int rqChatsType=0;
if(RecordSet.next()){
	rqChatsType=RecordSet.getInt("chatstype");
}
//微信提醒END(QC:98106)
String tempMessageType = "";//流程是否开启短信提醒




//rsaddop.executeSql("select messageType from workflow_base where id="+workflowid);
//微信提醒START(QC:98106)
String tempChatsType = "";//流程是否开启微信提醒




rsaddop.executeSql("select messageType,chatsType from workflow_base where id="+workflowid);
if(rsaddop.next()){
	tempChatsType = Util.null2o(rsaddop.getString("chatsType"));
	//微信提醒END(QC:98106)
    tempMessageType = Util.null2o(rsaddop.getString("messageType"));
}

char flag1 = Util.getSeparator();
int usertype = (user.getLogintype()).equals("1") ? 0 : 1;
String annexdocids="";
String annexdocnames = "";
String myremark="";
String myhiddenremark="";
String signdocids="";
String signworkflowids="";
int workflowRequestLogId=-1;
RecordSet.executeProc("workflow_RequestLog_SBUser",""+requestid+flag1+""+user.getUID()+flag1+""+usertype+flag1+"1");
if(RecordSet.next()){
	annexdocids=Util.null2String(RecordSet.getString("annexdocids"));
	if(!annexdocids.equals("")){
		//rsaddop.executeSql("select docsubject from docdetail where id in("+annexdocids+")");
		rsaddop.executeSql("select imageFileName as docsubject from DocImageFile where docId in("+annexdocids+")");
		while(rsaddop.next()){
			if(annexdocnames.equals("")){
				annexdocnames = Util.StringReplace(Util.null2String(rsaddop.getString(1)),",","，") ;
			}else{
				annexdocnames += "," + Util.StringReplace(Util.null2String(rsaddop.getString(1)),",","，") ;
			}
		}
	}
	myhiddenremark = Util.null2String(RecordSet.getString("remark"));
    signdocids = Util.null2String(RecordSet.getString("signdocids"));
    signworkflowids = Util.null2String(RecordSet.getString("signworkflowids"));
	myhiddenremark = Util.StringReplace(myhiddenremark,"&lt;br&gt;","<br>");
	myremark = FieldInfo.toExcel(myhiddenremark);
	workflowRequestLogId = Util.getIntValue(RecordSet.getString("requestLogId"),-1);
}
%>
<%
    boolean hasrequestname=false;
    boolean hasrequestlevel=false;
    boolean hasmessageType=false;
    boolean hasremark=false;
    //rsaddop.executeSql("select fieldid from workflow_modeview where formid="+formid+" and nodeid="+paranodeid+" and fieldid in(-1,-2,-3,-4)");
    //微信提醒START(QC:98106)
    boolean haschatsType=false;   
    rsaddop.executeSql("select fieldid from workflow_modeview where formid="+formid+" and nodeid="+paranodeid+" and fieldid in(-1,-2,-3,-4,-5)");
  //微信提醒END(QC:98106)
    while(rsaddop.next()){//如果在模板中设置了标题，下面的隐含字段作为标题对象保存数据




        int tmpfieldid=rsaddop.getInt("fieldid");
        if(tmpfieldid==-1){
            hasrequestname=true;
        }else if(tmpfieldid==-2){
            hasrequestlevel=true;
        }else if(tmpfieldid==-3){
            hasmessageType=true;
        }else if(tmpfieldid==-4){
            hasremark=true;
        }else if(tmpfieldid==-5){
            haschatsType=true;//微信提醒START(QC:98106)
        }
    }
    if(hasrequestname){
%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>" name="requestname" value="<%=FieldInfo.toScreen(Util.StringReplace(requestname,"\"","&quot;"))%>">
<%}%>
<%
if(hasrequestlevel){//如果在模板中设置了紧急程度，下面的隐含字段作为紧急程度对象保存数据




%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>" name="requestlevel" value="<%=requestlevel%>">
<%}%>
<%
if(hasmessageType){//如果在模板中设置了是否短信提醒，下面的隐含字段作为是否短信提醒保存数据




%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%>" name="messageType" value="<%=rqMessageType%>">
<%}%>
<!-- 微信提醒START(QC:98106) -->
<%
if(haschatsType){//如果在模板中设置了是否微信提醒，下面的隐含字段作为是否微信提醒保存数据




%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%>" name="chatsType" value="<%=rqChatsType%>">
<%}%>
<!-- 微信提醒END(QC:98106) -->
<%
if(hasremark){//如果在模板中设置了签字，下面的隐含字段作为签字对象保存数据




%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>" name="qianzi" value="<%=annexdocids%>">
<input type=hidden temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>" name="remark" value="<%=myhiddenremark%>">
<input type=hidden name="signdocids" value="<%=signdocids%>">
<input type=hidden name='signworkflowids' value="<%=signworkflowids%>">
<input type=hidden name="workflowRequestLogId" value="<%=workflowRequestLogId%>">
<input type=hidden name='field-annexupload_num' value="0">
<input type=hidden name='annexmainId' value="0">
<input type=hidden name='annexsubId' value="0">
<input type=hidden name='annexsecId' value="0">
<%}%>
<%
/*装载表明细*/
//明细表循环




for(int i=0; i<detailtablefields.size();i++){
String fieldlable="";
    ArrayList detaillist=(ArrayList)detailtablefields.get(i);
    ArrayList detaillablelist=(ArrayList)detailtablefieldlables.get(i);
    ArrayList detailurls=(ArrayList)DetailUrlList.get(i);
    ArrayList detailurllinks=(ArrayList)DetailUrlLinkList.get(i);
    ArrayList detailvalues=(ArrayList)detailfieldvalues.get(i);
    ArrayList detailfieldids=(ArrayList)detailtablefieldids.get(i);
    ArrayList detailisviews=(ArrayList)DetailFieldIsViews.get(i);
    ArrayList detailchildfieldList = (ArrayList)detailTableChildFields.get(i);
    int htmltype=1;
    int type=1;
    int indx=-1;
    int row=0;    
    //明细列循环




    for(int j=0;j<detailfieldids.size();j++){
        ArrayList fieldids=(ArrayList)detailfieldids.get(j);
        ArrayList fieldvalues=(ArrayList)detailvalues.get(j);
        String isview=(String)detailisviews.get(j);
        url=(String)detailurls.get(j);
		String urls = "/systeminfo/Calendar_mode.jsp";
	if(url.indexOf("systeminfo/Calendar.jsp")>0){  //模板模式 单独处理日期控件
	   url= url.replace(url,urls);
	}
        urllink=(String)detailurllinks.get(j);
        String fieldname=(String)detaillist.get(j);
        String tempfieldname=fieldname.substring(0,fieldname.indexOf("_"));
        fieldlable=(String)detaillablelist.get(j);
        int dChildField_tmp = Util.getIntValue((String)detailchildfieldList.get(j), 0);
        if(Util.getIntValue(fieldname.substring(fieldname.lastIndexOf("_")+1),1)==3){
 %>
    <input type="hidden" name="<%=tempfieldname%>_url" value="<%=url%>">
    <input type="hidden" name="<%=tempfieldname%>_urllink" value="<%=urllink%>">
    <input type="hidden" name="<%=tempfieldname%>_linkno" value="">
<%
        }
        row=fieldids.size();
        for(int k=0;k<fieldids.size();k++){
            fieldid=(String)fieldids.get(k);
            fieldvalue=(String)fieldvalues.get(k);
            indx=fieldid.lastIndexOf("_");
            if(indx>0){
                htmltype=Util.getIntValue(fieldid.substring(indx+1),1);
                fieldid=fieldid.substring(0,indx);            
            }
            indx=fieldid.lastIndexOf("_");
            if(indx>0){
                type=Util.getIntValue(fieldid.substring(indx+1),1);
                fieldid=fieldid.substring(0,indx);    
            }
            if(htmltype==3 && (type==16 || type==152 || type==171) || htmltype==9){ %>
                <input type="hidden"  temptitle="<%=fieldlable%>" name="<%=fieldid%>_linkno" value="">
            <%}
            //不显示的列，直接装载隐藏数据
            if(!isview.equals("1")){%>
                <input type="hidden"   temptitle="<%=fieldlable%>" name="<%=fieldid%>" value="<%=fieldvalue%>">
            <%}
            String tempfieldid=fieldid;
            if(tempfieldid.length()>5) tempfieldid=tempfieldid.substring(5,tempfieldid.indexOf("_"));
            if(seldefieldsadd.indexOf(tempfieldid)>=0){
                int detailindex = Util.getIntValue(fieldid.substring(fieldid.indexOf("_")+1),0);
                bodychangattrstr+="changeshowattrBymode('"+tempfieldid+"_1','"+fieldvalue+"',"+detailindex+","+workflowid+","+paranodeid+");";
            }
  		}
        int pfieldid_tmp = 0;
	  	if(detailchildfieldList.contains(fieldname.substring(5))){
			String pfieldStr_tmp = (String)fieldids.get(detailchildfieldList.indexOf(fieldname.substring(5)));
			pfieldStr_tmp = pfieldStr_tmp.substring(5, pfieldStr_tmp.indexOf("_"));
			pfieldid_tmp = Util.getIntValue(pfieldStr_tmp, 0);
		}
        %>
	<input type="hidden" id="childField<%=tempfieldname%>" name="childField<%=tempfieldname%>" value="<%=dChildField_tmp+"_"+i%>">
	<input type="hidden" id="pField<%=tempfieldname%>" name="pField<%=tempfieldname%>" value="<%=pfieldid_tmp+"_"+i%>">
            <input type="hidden"  value="<%=fieldlable%>" name="temp_<%=tempfieldname%>">
            <%	
    }
%>
    <input type=hidden name="indexnum<%=i%>" id="indexnum<%=i%>" value="0">
    <input type=hidden name="nodesnum<%=i%>" id="nodesnum<%=i%>" value="0">
    <input type=hidden name="totalrow<%=i%>" id="totalrow<%=i%>" value="0">
    <input type=hidden name="submitdtlid<%=i%>" id="submitdtlid<%=i%>" value="">
    <input type=hidden name="deldtlid<%=i%>" id="deldtlid<%=i%>" value="">
    <input type=hidden name="tempdetail<%=i%>" id="tempdetail<%=i%>" value="<%=row%>">
<%
}
%>

<span  id=createDocButtonSpan><button id='createdoc' style='display:none' class=AddDoc onclick="createDocForNewTab('','0');return false;"></button></span>
<input type="hidden" name="flowDocField" value="<%=flowDocField%>">
<input type="hidden" name="newTextNodes" value="<%=newTextNodes%>">

<script language=javascript>

var inoperatefields = "<%=inoperatefields%>";
var inoperatevalues = "<%=inoperatevalues%>";

var inoperatefieldArray=new Array();
var inoperatevalueArray=new Array();

<%
    for(int i=0; i<inoperatefields.size();i++){
%>
        inoperatefieldArray[<%=i%>]="<%=Util.null2String((String)inoperatefields.get(i))%>";
        inoperatevalueArray[<%=i%>]="<%=Util.null2String((String)inoperatevalues.get(i))%>";
<%
    }
%>

var rowgroup=new Array();
function getRowGroup(){
<%
    for(int i=0; i<detailtablefields.size();i++){
%>
        var headrow=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=i%>_head");
        var endrow=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=i%>_end");
        if(headrow==null || headrow=="" || endrow==null || endrow=="" || endrow-headrow-1<1){
            rowgroup[<%=i%>]=0;
        }else{
            rowgroup[<%=i%>]=(endrow-headrow-1);
        }
<%
    }
%>
}
/*装载表头数据*/
function setmantable(){
    var wcell=frmmain.ChinaExcel;
    try{
    	//标题
    	var temprow1=wcell.GetCellUserStringValueRow("requestname");
    	var tempcol1=wcell.GetCellUserStringValueCol("requestname");
    	if(temprow1>0){
	    	$G("needcheck").value=$G("needcheck").value+",requestname";
		    wcell.SetCellVal(temprow1,tempcol1,getChangeField('<%=FieldInfo.toExcel(Util.encodeJS(requestname))%>'));
		    imgshoworhide(temprow1,tempcol1);
            <%
                if(!editbodymodeflag){
            %>
                wcell.SetCellProtect(temprow1,tempcol1,temprow1,tempcol1,true);
            <%
                }
            %>
		  }
	    
	    //紧急程度




    	var temprow2=wcell.GetCellUserStringValueRow("requestlevel");
    	var tempcol2=wcell.GetCellUserStringValueCol("requestlevel");
    	if(temprow2>0){
		   	wcell.SetCellComboType1(temprow2,tempcol2,false,true,false,"<%=SystemEnv.getHtmlLabelName(225,Languageid)%>;<%=SystemEnv.getHtmlLabelName(15533,Languageid)%>;<%=SystemEnv.getHtmlLabelName(2087,Languageid)%>","0;1;2");      
	      if("<%=requestlevel%>"=="0") wcell.SetCellVal(temprow2,tempcol2,getChangeField("<%=SystemEnv.getHtmlLabelName(225,Languageid)%>")); 
	      if("<%=requestlevel%>"=="1") wcell.SetCellVal(temprow2,tempcol2,getChangeField("<%=SystemEnv.getHtmlLabelName(15533,Languageid)%>")); 
	      if("<%=requestlevel%>"=="2") wcell.SetCellVal(temprow2,tempcol2,getChangeField("<%=SystemEnv.getHtmlLabelName(2087,Languageid)%>")); 
	      $G("requestlevel").value="<%=requestlevel%>";
		  	imgshoworhide(temprow2,tempcol2);
            <%
                if(!editbodymodeflag){
            %>
                wcell.SetCellProtect(temprow2,tempcol2,temprow2,tempcol2,true);
            <%
                }
            %>
		  }
	    
	    //是否短信提醒
    	var temprow3=wcell.GetCellUserStringValueRow("messageType");
    	var tempcol3=wcell.GetCellUserStringValueCol("messageType");
    	if(temprow3>0){
    	  if(<%=tempMessageType%>==1){
		   	wcell.SetCellComboType1(temprow3,tempcol3,false,true,false,"<%=SystemEnv.getHtmlLabelName(17583,Languageid)%>;<%=SystemEnv.getHtmlLabelName(17584,Languageid)%>;<%=SystemEnv.getHtmlLabelName(17585,Languageid)%>","0;1;2");
	      if("<%=rqMessageType%>"=="0") wcell.SetCellVal(temprow3,tempcol3,getChangeField("<%=SystemEnv.getHtmlLabelName(17583,Languageid)%>")); 
	      if("<%=rqMessageType%>"=="1") wcell.SetCellVal(temprow3,tempcol3,getChangeField("<%=SystemEnv.getHtmlLabelName(17584,Languageid)%>")); 
	      if("<%=rqMessageType%>"=="2") wcell.SetCellVal(temprow3,tempcol3,getChangeField("<%=SystemEnv.getHtmlLabelName(17585,Languageid)%>")); 
	      $G("messageType").value="<%=rqMessageType%>";
		    imgshoworhide(temprow3,tempcol3);
		    }else{
		        wcell.SetCellProtect(temprow3,tempcol3,temprow3,tempcol3,true);
		    }
            <%
                if(!editbodymodeflag){
            %>
                wcell.SetCellProtect(temprow3,tempcol3,temprow3,tempcol3,true);
            <%
                }
            %>
		  }
	    //微信提醒START(QC:98106)
	    //是否短信提醒
    	var temprow5=wcell.GetCellUserStringValueRow("chatsType");
    	var tempcol5=wcell.GetCellUserStringValueCol("chatsType");
    	if(temprow5>0){
    	  if(<%=tempChatsType%>==1){
		   	wcell.SetCellComboType1(temprow5,tempcol5,false,true,false,"<%=SystemEnv.getHtmlLabelName(19782,Languageid)%>;<%=SystemEnv.getHtmlLabelName(26928,Languageid)%>","0;1");
	        if("<%=rqChatsType%>"=="0") wcell.SetCellVal(temprow5,tempcol5,getChangeField("<%=SystemEnv.getHtmlLabelName(19782,Languageid)%>")); 
	        if("<%=rqChatsType%>"=="1") wcell.SetCellVal(temprow5,tempcol5,getChangeField("<%=SystemEnv.getHtmlLabelName(26928,Languageid)%>")); 
	        $G("chatsType").value="<%=rqChatsType%>";
		    imgshoworhide(temprow5,tempcol5);
		  }else{
		    wcell.SetCellProtect(temprow5,tempcol5,temprow5,tempcol5,true);
		  }
          <%
            if(!editbodymodeflag){
          %>
                wcell.SetCellProtect(temprow5,tempcol5,temprow5,tempcol5,true);
          <%
            }
          %>
	    }
		//微信提醒END(QC:98106)
	    //签字
    	var temprow4=wcell.GetCellUserStringValueRow("qianzi");
    	var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
    	if(temprow4>0){
<%
boolean IsBeForwardCanSubmitOpinion="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsBeForwardCanSubmitOpinion"))?true:false;
String isannexUpload=null;
rsaddop.executeSql("select isannexUpload from workflow_base where id="+workflowid);
if(rsaddop.next()){
	isannexUpload = Util.null2String(rsaddop.getString("isannexUpload"));
}
//签字意见，在没有附件和电子签章的情况下不要有浏览框显示在那里。




if(!"1".equals(isFormSignature)&&!"1".equals(isannexUpload)){%>
    		wcell.DeleteCellImage(temprow4,tempcol4,temprow4,tempcol4);
<%}%>

<%if(!"".equals(myhiddenremark)){%>
    		wcell.DeleteCellImage(temprow4,tempcol4,temprow4,tempcol4);
<%}%>

<%if("1".equals(isSignMustInput)&&"".equals(myhiddenremark)){%>
           <%
      if(isFormSignature.equals("1")){%>
        <%if(!annexdocnames.equals("")||workflowRequestLogId!=-1){
        %>
        <%}else{%>
            wcell.DeleteCellImage(temprow4,tempcol4,temprow4,tempcol4);
	    	wcell.ReadHttpImageFile("/images/BacoError_wev8.gif",temprow4,tempcol4,true,true);
        <%}%>
    <%}else{%>
        	wcell.DeleteCellImage(temprow4,tempcol4,temprow4,tempcol4);
	    	wcell.ReadHttpImageFile("/images/BacoError_wev8.gif",temprow4,tempcol4,true,true);
    <%}
    %>		
    
            //wcell.DeleteCellImage(temprow4,tempcol4,temprow4,tempcol4);
	    	//wcell.ReadHttpImageFile("/images/BacoError_wev8.gif",temprow4,tempcol4,true,true);
<%}%>
	    	<%
	    	if(isFormSignature.equals("1")){
	    		if(!annexdocnames.equals("")||workflowRequestLogId!=-1){
	    	%>
		    		<%if(annexdocnames.equals("")){%>
		    			wcell.SetCellVal(temprow4,tempcol4,getChangeField("  <%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(18890,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18695,user.getLanguage())%>"));  
		  			<%}else if(workflowRequestLogId==-1){%>
		  				wcell.SetCellVal(temprow4,tempcol4,getChangeField("  <%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>:<%=annexdocnames%>"));  
		  			<%}else{%>
			    		wcell.SetCellVal(temprow4,tempcol4,getChangeField("  <%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>:<%=annexdocnames%>"+"&at;<%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(18890,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18695,user.getLanguage())%>"));  
			    	<%}%>
	    	<%}else{%>
	    		wcell.SetCellVal(temprow4,tempcol4,""); 
	    	<%}
	    	}else{
	    	%>
            var myremark = '<%=FieldInfo.dropScript(myremark)%>';
	    	myremark = getFckText(myremark);
            <%
	    		if("1".equals(isSignMustInput)){
	    			%>
	    			var checkfield=$G("needcheck").value;
	    			$G("needcheck").value=checkfield+",remark";
	    			<%}
	    		if(!annexdocnames.equals("")||!myremark.equals("")){%>
	    			<%if(annexdocnames.equals("")){%>
	    				wcell.SetCellVal(temprow4,tempcol4,getChangeField(myremark));
	    			<%}else if(myremark.equals("")){%>
	    				wcell.SetCellVal(temprow4,tempcol4,getChangeField("<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>:<%=annexdocnames%>")); 
	    			<%}else{%>	
		    		    wcell.SetCellVal(temprow4,tempcol4,getChangeField("<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>:<%=annexdocnames%>"+"&at;<%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%>:"+myremark));
		    		<%}%>
	    		<%}else{%>
	    			wcell.SetCellVal(temprow4,tempcol4,""); 
	    	<%}}%>
		   	$G("qianzi").value="<%=annexdocids%>";
		    imgshoworhide(temprow4,temprow4);
            <%
                if(!IsBeForwardCanSubmitOpinion){
            %>
                wcell.SetCellProtect(temprow4,tempcol4,temprow4,tempcol4,true);
            <%
                }
            %>
            wcell.RefreshViewSize();
		  }
  	}catch(e){}
<%
    for(int i=0; i<mantablefields.size();i++){
        String fid=(String)mantablefields.get(i);
        String fvalue=(String)manfieldvalues.get(i);
		String dbtype=(String)manfielddbtypes.get(i);
%>
    var nrow=wcell.GetCellUserStringValueRow("<%=fid%>");
    if(nrow>0){
     var ncol=wcell.GetCellUserStringValueCol("<%=fid%>");
<%
        int htmltype=1;
        int ftype=0;
        String tmpfid=fid;
        int indx=tmpfid.lastIndexOf("_");
        if(indx>0){
           htmltype=Util.getIntValue(tmpfid.substring(indx+1),1);
           tmpfid=tmpfid.substring(0,indx);
           indx=tmpfid.lastIndexOf("_");
           if(indx>0){
              ftype=Util.getIntValue(tmpfid.substring(indx+1),1);
              tmpfid=tmpfid.substring(0,indx);
           }
        }
%>
        var ismand=wcell.GetCellUserValue(nrow,ncol);
<%
        if(tmpfid.length()>5&&changefieldsdemanage.indexOf(tmpfid.substring(5))>=0){
%>
        if($G("oldfield<%=tmpfid.substring(5)%>")) $G("oldfield<%=tmpfid.substring(5)%>").value="0|"+ismand+"|<%=fid%>";
<%
	}
%>
  
        //if(ismand==2){
        //    var checkfield=$G("needcheck").value;
        //    $G("needcheck").value=checkfield+",<%=tmpfid%>";
        //}

		var isedit=0;
		if(ismand>=1){
			isedit=1;
		}

<%
        if(!tmpfid.equals(codeField)){
%>
            if(ismand==2){
                var checkfield=$G("needcheck").value;
                $G("needcheck").value=checkfield+",<%=tmpfid%>";
            }
<%
        }
%>

<%
        if(htmltype==5){
        	boolean hasPfield = false;
        	String pField = "";
        	for(int cx_tmp=0; cx_tmp<manTableChildFields.size(); cx_tmp++){
        		String cField_tmp = Util.null2String((String)manTableChildFields.get(cx_tmp));
        		if(cField_tmp.equals(tmpfid.substring(5))){
        			pField = Util.null2String((String)mantablefields.get(cx_tmp));
        			hasPfield = true;
        			break;
        		}
        	}
            FieldInfo.getSelectItem(fid,isbill);
            ArrayList  SelectItems=FieldInfo.getSelectItems();
            ArrayList SelectItemValues=FieldInfo.getSelectItemValues();
            ArrayList SelectCancels=FieldInfo.getSelectCancelValues();
            String Combostr="";
            String svalue="";
            fvalue="";
			RecordSet rsIsViewRS = new RecordSet();
			String isviewTemp = "";
			String iseditTemp = "";
			String ismandatoryTemp = "";
			if(fid.indexOf('_') > 5 ){
            String fieldidTemp = fid.substring(5,fid.indexOf('_'));
			rsIsViewRS.executeSql("select isview,isedit,ismandatory from workflow_modeview where nodeid = " +paranodeid + " and formid = " + formid + " and fieldid = " + fieldidTemp);
			if(rsIsViewRS.next()){
				isviewTemp = Util.null2String(rsIsViewRS.getString("isview"));
				iseditTemp = Util.null2String(rsIsViewRS.getString("isedit"));
				ismandatoryTemp = Util.null2String(rsIsViewRS.getString("ismandatory"));
			}
			}
            if(hasPfield==false || (isaffirmance==1 && reEdit==0)){
              for(int j=0;j<SelectItems.size();j++){
                String selectname=(String)SelectItems.get(j);
                String selectvalue=(String)SelectItemValues.get(j);
                String cancel=(String)SelectCancels.get(j);
                if(iseditTemp.equals("1") || ismandatoryTemp.equals("1")){
                    if(cancel.equals("1")){
                	    continue;
            	    }
				}
                Combostr+=";"+selectname;
                svalue+=";"+selectvalue;
%>
                var fieldvalue=$G("<%=tmpfid%>").value;
                var selvalue="<%=selectvalue%>";
                if(fieldvalue==selvalue){
                    wcell.SetCellVal(nrow,ncol,getChangeField("<%=FieldInfo.toExcel(Util.encodeJS(selectname))%>")); 
                }
<%
            }
%>
        wcell.SetCellComboType1(nrow,ncol,false,true,false,getChangeField("<%=Util.encodeJS(Combostr)%>"),"<%=svalue%>");
<%
            }else{
            	%>
            	        		wcell.SetCellComboType1(nrow,ncol,false,true,false,";;",";;");
            	        		wcell.SetCellVal(nrow,ncol,"");
            	<%
            					fvalue = Util.null2String((String)manfieldvalues.get(i));
            					comboInitJsStr += "doInitChildCombo(\""+fid+"\",\""+pField+"\",\""+fvalue+"\");\n";
            				}
        }
   	if(htmltype==9){
    %>			wcell.SetCellVal(nrow,ncol,'<%=SystemEnv.getHtmlLabelName(126136,user.getLanguage()) %>');    
            	wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);	
    <%}
        if(htmltype==4){
%>
        wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
        wcell.SetCellCheckBoxType(nrow,ncol);        
<%        
            if(fvalue.equals("1")){
%>
        wcell.SetCellCheckBoxValue(nrow,ncol,true);
<%
            }
%>
        wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%
        }
        if(htmltype==3){
            if(ftype==16 || ftype==152 || ftype==171){
                ArrayList tempshowidlist=Util.TokenizerString(fvalue,",");
                String linknums="";
                for(int t=0;t<tempshowidlist.size();t++){
                    int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                    tempnum++;
                    session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(t));
                    session.setAttribute("slinkwfnum",""+tempnum);
                    session.setAttribute("haslinkworkflow","1");
                    linknums+=tempnum+",";
                }
                if(linknums.length()>0) linknums=linknums.substring(0,linknums.length()-1);
%>
                $G("<%=tmpfid%>_linkno").value="<%=linknums%>";
<%
            }

            // 如果是多文档, 需要判定是否有新加入的文档,如果有,需要加在原来的后面
            if( (ftype==37||(ftype==9&&docFlags.equals("1"))) && tmpfid.equals("field"+docfileid) && !newdocid.equals("")) {
				if( ! fieldvalue.equals("")){
					fvalue += "," ;
				}
				if (ftype==9&&docFlags.equals("1")){
					fvalue=newdocid ;
				}else{
					fvalue += newdocid ;
				}
%>
	         $G("<%=tmpfid%>").value="<%=fvalue%>";
<%

            }
            if( ftype==9&&docFlags.equals("1") && tmpfid.equals("field"+flowDocField) ) {
%>

            createDocButtonSpan.innerHTML="<button id='createdoc' style='display:none' class=AddDoc onclick=\"createDocForNewTab('<%=tmpfid%>',"+isedit+");return false;\"></button>"
<%
            }

            if( ftype==160) {
				//String resourceRoleId="";
				String resourceRoleId="-1";
				int rolelevel_tmp = 0;
				rsaddop.executeSql("select a.level_n,a.level2_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="+tmpfid.substring(5)+" and b.nodeid in (select nodeid from workflow_flownode where workflowid="+workflowid+" ) ");
				if (rsaddop.next()){
					resourceRoleId=rsaddop.getString(1);
					rolelevel_tmp=Util.getIntValue(rsaddop.getString(2), 0);
					resourceRoleId += "a"+rolelevel_tmp+"b"+beagenter;
				}
%>
				$G("resourceRoleId<%=tmpfid%>").value="<%=resourceRoleId%>";
<%
            }
            if(managerid>0 && tmpfid.equals("field"+managerid)){
             if(isremark!=1&&isremark!=8&&isremark!=9){
            	fvalue = managerStr;
            	}
            }
            fvalue=FieldInfo.getFieldName(fvalue,ftype,dbtype,workflowid);
			if(ftype == 34) {//added by wcd 2015-08-26
				List leaveTypeList = leaveTypeColorManager.find("[map]field002:1");
				int leaveTypeSize = leaveTypeList == null ? 0 : leaveTypeList.size();
				HrmLeaveTypeColor leaveTypeBean = null;
				StringBuffer _names = new StringBuffer("");
				StringBuffer _values = new StringBuffer("");
				String _name = "", _defaultName = "";
				for(int leaveTypeIndex=0; leaveTypeIndex<leaveTypeSize; leaveTypeIndex++) {
					leaveTypeBean = (HrmLeaveTypeColor)leaveTypeList.get(leaveTypeIndex);
					_name = leaveTypeBean.getTitle(user.getLanguage());
					_names.append(";").append(_name);
					_values.append(";").append(leaveTypeBean.getField004());
					if(fvalue.equals(String.valueOf(leaveTypeBean.getField004()))) _defaultName = _name;
				}
	%>
			wcell.SetCellComboType1(nrow,ncol,false,true,false,"<%=_names.toString()%>","<%=_values.toString()%>");
			wcell.SetCellVal(nrow,ncol,getChangeField("<%=_defaultName%>")); 
	<%
			} else {
%>
            wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%
			}
        }
        if(htmltype==6){
			if("-2".equals(fvalue)){
				fvalue = Util.null2String(SystemEnv.getHtmlLabelName(21710, user.getLanguage()));
%>
		var color_red = wcell.GetRGBValue(255, 0, 0);
		wcell.SetCellTextColor(nrow, ncol, nrow, ncol, color_red);
<%
			}else{
				fvalue=FieldInfo.getFileName(fvalue);
				fvalue=Util.StringReplace(fvalue,",","<br>");
			}
        }else if(htmltype==9){
            fvalue=SystemEnv.getHtmlLabelName(126136,user.getLanguage());
        }
        if(htmltype!=4 && htmltype!=5){
			String ffvalue = Util.encodeJS(FieldInfo.toExcel(FieldInfo.dropScript(fvalue)));
			if(htmltype==1 && ftype==5) ffvalue = Util.StringReplace(ffvalue,",","");
        	if(htmltype == 2 && ftype == 1) {
        		ffvalue = Util.StringReplace(ffvalue, "<", "&lt;");
        		ffvalue = Util.StringReplace(ffvalue, ">", "&gt;");
        	}
%>
        var Formula=wcell.GetCellFormula(nrow,ncol);
        if(Formula==null || Formula==""){
            var strtxt = '<%=ffvalue%>';
<%
        if(htmltype==2&&ftype==2){
%>
    	strtxt = getFckText(strtxt);
<%
        }
%>
            wcell.SetCellVal(nrow,ncol,getChangeField(strtxt));
        }
<%
        }
%>
<%    	if(htmltype==9){
%>			wcell.SetCellVal(nrow,ncol,'<%=SystemEnv.getHtmlLabelName(126136,user.getLanguage()) %>');    
        	wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);	
      	<%}%>
    imgshoworhide(nrow,ncol);
	var isProtect=frmmain.ChinaExcel.IsCellProtect(nrow,ncol);
	 if(isProtect){
	     frmmain.ChinaExcel.SetCellProtect(nrow,ncol,nrow,ncol,false);
	 }
	 var remark = "<%=isremark%>";
	 var htmltype = "<%=htmltype%>";
	if(remark==9){
		wcell.DeleteCellImage(nrow,ncol,nrow,ncol);
		if(htmltype==3){ // 抄送下没有可编辑权限，无需设置此编辑图片。




			//wcell.ReadHttpImageFile("/images/BacoBrowser_wev8.gif",nrow,ncol,true,true);
		}
	}
	if(isProtect){
	    frmmain.ChinaExcel.SetCellProtect(nrow,ncol,nrow,ncol,true);
	}
    <%
    if(!editbodymodeflag){
    %>
        wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
    <%
        }
    %>    
    }
<%
    }
%>
<%=comboInitJsStr%>
}
/*装载表明细数据*/
function setdetailtable(){
    var wcell=frmmain.ChinaExcel;
    var changefields="";
<%
    String fid="";
    String fvalue="";
	String dfielddbtype="";
    for(int j=0;j<changedefieldsmanage.size();j++){
    %>
    changefields+=",<%=changedefieldsmanage.get(j)%>";
    <%
    }
    for(int i=0; i<detailtablefieldids.size();i++){
%>
    initrow0();
    var totalrow=parseInt($G("tempdetail<%=i%>").value);
    for(var row=0;row<totalrow;row++){
    rowIns("<%=i%>",1,1,changefields,"1");
    }
    var selcol=wcell.GetCellUserStringValueCol("detail<%=i%>_sel");
    var nInsertAfterRow=wcell.GetCellUserStringValueRow("detail<%=i%>_end"); 
    var nInsertRows=rowgroup[<%=i%>];
    if(selcol>0 && nInsertAfterRow>0){
        if("<%=(i+1)%>"=="<%=detailtablefieldids.size()%>")
        wcell.SetCellCheckBoxValue(nInsertAfterRow-nInsertRows,selcol,false);
    }
    var nrow=0;
    var ncol=0;
<%
		ArrayList dfs=(ArrayList)detailtablefields.get(i);
		ArrayList dcfids=(ArrayList)detailTableChildFields.get(i);
        ArrayList dfids=(ArrayList)detailtablefieldids.get(i);
        ArrayList dfvalues=(ArrayList)detailfieldvalues.get(i);
		ArrayList dfielddbtypes=(ArrayList)DetailFieldDBTypes.get(i);
        ArrayList torgtypevalues=new ArrayList();
        ArrayList tbudgetperiodvalues=new ArrayList();
        ArrayList torgidvalues=new ArrayList();
        ArrayList tsubjectvalues=new ArrayList();
        for(int j=0;j<dfids.size();j++){
            ArrayList fids=(ArrayList)dfids.get(j);
            ArrayList fvalues=(ArrayList)dfvalues.get(j);
			dfielddbtype=(String)dfielddbtypes.get(j);
            for(int k=0;k<fids.size();k++){
                fid=(String)fids.get(k);
                fvalue=(String)fvalues.get(k);				
                if(fid.indexOf(budgetperiod+"_")==0){
                    tbudgetperiodvalues.add(fvalue);
                }else if(fid.indexOf(organizationtype+"_")==0){
                    torgtypevalues.add(fvalue);
                }else if(fid.indexOf(organizationid+"_")==0){
                    torgidvalues.add(fvalue);
                }else if(fid.indexOf(subject+"_")==0){
                    tsubjectvalues.add(fvalue);
                }
%>
                nrow=wcell.GetCellUserStringValueRow("<%=fid%>");
                if(nrow>0){
                    ncol=wcell.GetCellUserStringValueCol("<%=fid%>");
<%
                if(k==0){
%>  
                nrow=nrow+nInsertRows;
<%
                }
                int htmltype=1;
                int ftype=0;
                String tmpfid=fid;
                int indx=tmpfid.lastIndexOf("_");
                if(indx>0){
                   htmltype=Util.getIntValue(tmpfid.substring(indx+1),1);
                   tmpfid=tmpfid.substring(0,indx); 
                   indx=tmpfid.lastIndexOf("_");
                   if(indx>0){
                      ftype=Util.getIntValue(tmpfid.substring(indx+1),1); 
                      tmpfid=tmpfid.substring(0,indx); 
                   }
                }
                int tmprow=Util.getIntValue(tmpfid.substring(tmpfid.indexOf("_")+1));

%>
                $G("<%=tmpfid%>").value='<%=FieldInfo.toScreen(Util.encodeJS(fvalue))%>';
<%
                if(htmltype==5){
                	boolean hasPfield = false;
                	String pField = "";
                	String pFieldValue = "";
                	for(int cx_tmp=0; cx_tmp<dcfids.size(); cx_tmp++){
                		String cField_tmp = Util.null2String((String)dcfids.get(cx_tmp));
                		if(cField_tmp.equals(tmpfid.substring(5, tmpfid.indexOf("_")))){
                			pField = Util.null2String((String)dfs.get(cx_tmp));
                			pFieldValue = Util.null2String((String)((ArrayList)dfvalues.get(cx_tmp)).get(k));
                			hasPfield = true;
                			break;
                		}
                	}
                    FieldInfo.getSelectItem(fid,isbill);
                    ArrayList  SelectItems=FieldInfo.getSelectItems();
                    ArrayList SelectItemValues=FieldInfo.getSelectItemValues();
                    ArrayList SelectCancels=FieldInfo.getSelectCancelValues();
                    String Combostr="";
                    String svalue="";
                    fvalue="";
					RecordSet rsIsViewRS1 = new RecordSet();
					String isviewTemp = "";
					String iseditTemp = "";
					String ismandatoryTemp = "";
					if(fid.indexOf('_') > 5 ){
					String fieldidTemp1 = fid.substring(5,fid.indexOf('_'));
					String sqlForIsview = "select isview,isedit,ismandatory from workflow_modeview where nodeid = " +paranodeid + " and formid = " + formid + " and fieldid = " + fieldidTemp1;
					rsIsViewRS1.executeSql(sqlForIsview);
					if(rsIsViewRS1.next()){
						isviewTemp = Util.null2String(rsIsViewRS1.getString("isview"));
						iseditTemp = Util.null2String(rsIsViewRS1.getString("isedit"));
						ismandatoryTemp = Util.null2String(rsIsViewRS1.getString("ismandatory"));
				    }
					}
                    if(hasPfield==false || (isaffirmance==1 && reEdit==0)){
                      for(int n=0;n<SelectItems.size();n++){
                        String selectname=(String)SelectItems.get(n);
                        String selectvalue=(String)SelectItemValues.get(n);
                         String cancel=(String)SelectCancels.get(n);
						 if(iseditTemp.equals("1") || ismandatoryTemp.equals("1")){
                	         if(cancel.equals("1")){
                    		     continue;
                		  }
						 }
                	    if(cancel.equals("1")){
                    		continue;
                		}
                        Combostr+=";"+selectname;
                        svalue+=";"+selectvalue;
%>
                        var fieldvalue=$G("<%=tmpfid%>").value;
                        var selvalue="<%=selectvalue%>";
                        if(fieldvalue==selvalue){
                            wcell.SetCellVal(nrow,ncol,getChangeField("<%=FieldInfo.toExcel(Util.encodeJS(selectname))%>")); 
                        }
<%
                    }
%>
                wcell.SetCellComboType1(nrow,ncol,false,true,false,getChangeField("<%=Util.encodeJS(Combostr)%>"),"<%=svalue%>");
<%
                    }else{
                    	%>
                		wcell.SetCellComboType1(nrow,ncol,false,true,false,";;",";;");
                		wcell.SetCellVal(nrow,ncol,"");
        <%
        				fvalue = Util.null2String((String)fvalues.get(k));
        				comboInitDetailJsStrAll += "doInitDetailChildComboAll(\""+(fid.substring(0, fid.indexOf("_"))+"_"+i)+"\",\""+(pField.substring(0, pField.indexOf("_"))+"_"+i)+"\",\""+fvalue+"\",\""+pFieldValue+"\","+k+");\n";

                    }
                }

	if(htmltype==9){
%>			wcell.SetCellVal(nrow,ncol,'<%=SystemEnv.getHtmlLabelName(126136,user.getLanguage()) %>');    
	            	wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);	
	<%}
                if(htmltype==4){
%>
                    wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
                    wcell.SetCellCheckBoxType(nrow,ncol);
<%
                    if(fvalue.equals("1")){
%>
                    wcell.SetCellCheckBoxValue(nrow,ncol,true);
<%
                    }
%>
                wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%
                }
                if(htmltype==3){
                    if(ftype==16 || ftype==152 || ftype==171){
                        ArrayList tempshowidlist=Util.TokenizerString(fvalue,",");
                        String linknums="";
                        for(int t=0;t<tempshowidlist.size();t++){
                            int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                            tempnum++;
                            session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(t));
                            session.setAttribute("slinkwfnum",""+tempnum);
                            session.setAttribute("haslinkworkflow","1");
                            linknums+=tempnum+",";
                        }
                        if(linknums.length()>0) linknums=linknums.substring(0,linknums.length()-1);
%>
                        $G("<%=tmpfid%>_linkno").value="<%=linknums%>";
<%
                    }
                    if(tmpfid.indexOf(organizationid+"_")==0){
                        if(torgtypevalues.size()>=tmprow){
                            int orgtype=Util.getIntValue((String)torgtypevalues.get(tmprow),3);
                            if(orgtype==1){
                                ftype=164;
                            }else if(orgtype==2){
                                ftype=4;
                            }else if(orgtype==3){
                                ftype=1;
                            }else if(orgtype==FnaCostCenter.ORGANIZATION_TYPE){//成本中心
                				ftype=251;
                			}else{
                				if(fnaBudgetOAOrg && fnaBudgetCostCenter){
                					ftype=4;
                				}else if(fnaBudgetOAOrg){
                					ftype=4;
                				}else if(fnaBudgetCostCenter){
                					ftype=251;
                				}
                			}
                        }
%>
                    var temporgtype=3;
                    if($G("<%=organizationtype%>_<%=tmprow%>")) temporgtype=$G("<%=organizationtype%>_<%=tmprow%>").value;
                    wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
                    var tfieldid="<%=organizationid%>_<%=tmprow%>";
                    var turl="";
                    var turllink="";
                    if (temporgtype == 1) {
                        tfieldid += "_164_3";
                        turl = '<%=urlcominfo.getBrowserurl("164")%>';
                        turllink = '<%=urlcominfo.getLinkurl("164")%>';
                    } else if (temporgtype == 2) {
                        tfieldid += "_4_3";
                        turl = '<%=urlcominfo.getBrowserurl("4")%>';
                        turllink = '<%=urlcominfo.getLinkurl("4")%>';
                    } else if(temporgtype == <%=FnaCostCenter.ORGANIZATION_TYPE %>){
                    	tfieldid += "_251_3";
                    	turl = '<%=urlcominfo.getBrowserurl("251")%>';
                    	turllink = '<%=urlcominfo.getLinkurl("251")%>';
                    } else {
                        tfieldid += "_1_3";
                        turl = '<%=urlcominfo.getBrowserurl("1")%>';
                        turllink = '<%=urlcominfo.getLinkurl("1")%>';
                    }
                    wcell.SetCellUserStringValue(nrow, ncol, nrow, ncol, tfieldid);
                    if ($G("<%=organizationid%>_<%=tmprow%>_url")) {
                        $G("<%=organizationid%>_<%=tmprow%>_url").value = turl;
                    }
                    if ($G("<%=organizationid%>_<%=tmprow%>_urllink")) {
                        $G("<%=organizationid%>_<%=tmprow%>_urllink").value = turllink;
                    }
<%
                    }
                    if(ftype!=161 && ftype!=162){//非自定义浏览框
						fvalue=FieldInfo.getFieldName(fvalue,ftype,dfielddbtype,workflowid);
					}else{//自定义浏览框的特殊处理
						fvalue=FieldInfo.getFieldName(fvalue+"^~^"+tmprow,ftype,dfielddbtype);
					}
%>
                    wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%
                }
                if(htmltype==6){
					if("-2".equals(fvalue)){
						fvalue = Util.null2String(SystemEnv.getHtmlLabelName(21710, user.getLanguage()));
		%>
				var color_red = wcell.GetRGBValue(255, 0, 0);
				wcell.SetCellTextColor(nrow, ncol, nrow, ncol, color_red);
		<%
					}else{
						fvalue=FieldInfo.getFileName(fvalue);
						fvalue=Util.StringReplace(fvalue,",","<br>");
					}
		        }else if(htmltype==9){
		            fvalue=SystemEnv.getHtmlLabelName(126136,user.getLanguage());
		        }
                if(htmltype!=4 && htmltype!=5){
					if(htmltype==1 && ftype==5) fvalue = Util.StringReplace(fvalue,",","");
%>
                var Formula=wcell.GetCellFormula(nrow,ncol);   
                if(Formula==null || Formula==""){
                    var strtxt = '<%=Util.encodeJS(FieldInfo.toExcel(FieldInfo.dropScript(fvalue)))%>';
<%
        if(htmltype==2&&ftype==2){
%>
    	strtxt = getFckText(strtxt);
<%
        }
%>
            wcell.SetCellVal(nrow,ncol,getChangeField(strtxt));
                
                }
<%
                }
                if(fid.indexOf(hrmremain+"_")==0||fid.indexOf(deptremain+"_")==0||fid.indexOf(subcomremain+"_")==0||fid.indexOf(fccremain+"_")==0){
                    if(torgtypevalues.size()>=tmprow&&tbudgetperiodvalues.size()>=tmprow&&torgidvalues.size()>=tmprow&&tsubjectvalues.size()>=tmprow){
                        String kpi=bp.getBudgetKPI(""+tbudgetperiodvalues.get(tmprow),Util.getIntValue(""+torgtypevalues.get(tmprow)),Util.getIntValue(""+torgidvalues.get(tmprow)),Util.getIntValue(""+tsubjectvalues.get(tmprow)));

%>
                    callback("<%=kpi%>","<%=tmprow%>",nrow);
<%
                    }
                }else if(fid.indexOf(loanbalance+"_")==0){
                    if(torgtypevalues.size()>=tmprow&&tbudgetperiodvalues.size()>=tmprow&&torgidvalues.size()>=tmprow&&tsubjectvalues.size()>=tmprow){
                        double loanamount=bp.getLoanAmount(Util.getIntValue(""+torgtypevalues.get(tmprow)),Util.getIntValue(""+torgidvalues.get(tmprow)));
%>
                    //callback1("<%=loanamount%>",<%=tmprow%>,nrow);
<%
                    }
                }else if(fid.indexOf(oldamount+"_")==0){
                    if(torgtypevalues.size()>=tmprow&&tbudgetperiodvalues.size()>=tmprow&&torgidvalues.size()>=tmprow&&tsubjectvalues.size()>=tmprow){
                        double toldamount=bp.getBudgetByDate(""+tbudgetperiodvalues.get(tmprow),Util.getIntValue(""+torgtypevalues.get(tmprow)),Util.getIntValue(""+torgidvalues.get(tmprow)),Util.getIntValue(""+tsubjectvalues.get(tmprow)));
%>
                    callback2("<%=toldamount%>",<%=tmprow%>,nrow);
<%
                    }
                }
%>
    imgshoworhide(nrow,ncol);
	var isProtect=frmmain.ChinaExcel.IsCellProtect(nrow,ncol);
	 if(isProtect){
	     frmmain.ChinaExcel.SetCellProtect(nrow,ncol,nrow,ncol,false);
	 }
	 var remark = "<%=isremark%>";
	 var htmltype = "<%=htmltype%>";
	if(remark==9){
		wcell.DeleteCellImage(nrow,ncol,nrow,ncol);
		if(htmltype==3){
			//wcell.ReadHttpImageFile("/images/BacoBrowser.gif",nrow,ncol,true,true);
		}
	}
	if(isProtect){
	    frmmain.ChinaExcel.SetCellProtect(nrow,ncol,nrow,ncol,true);
	}
    <%
    if(!editbodymodeflag){
    %>
        wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
    <%
        }
    %>
    }
<%
            }
        }
%>
    initrow1();
<%        
    }
%>
<%
    //装载原有明细的id值




    for(int i=0; i<detailtablefields.size();i++){
        ArrayList detailids=(ArrayList)DetailTableIds.get(i);
        for(int k=0; k<detailids.size(); k++){
%>
	        if($G("dtl_id_<%=i%>_<%=k%>")!=null){
			    $G("dtl_id_<%=i%>_<%=k%>").value="<%=detailids.get(k)%>";
	        }
<%
        }
    }
%>
	/**added by cyril on 2008-06-10 for TD:8828**/
	try {
		createTags();
	}
	catch(e) {
	}
	/**end by cyril on 2008-06-10 for TD:8828**/
    <%=bodychangattrstr%>
    <%=comboInitDetailJsStrAll%>
}


function initrow0(){
var wcell=frmmain.ChinaExcel;
var nrow=0;
var ncol=0;
<%
    String tfid="";
	dfielddbtype="";
    for(int i=0; i<detailtablefields.size();i++){
        ArrayList dfids=(ArrayList)detailtablefields.get(i);
		ArrayList dfielddbtypes=(ArrayList)DetailFieldDBTypes.get(i);
		ArrayList dcfids=(ArrayList)detailTableChildFields.get(i);
        for(int j=0;j<dfids.size();j++){
            tfid=(String)dfids.get(j);
			dfielddbtype=(String)dfielddbtypes.get(j);
%>
            nrow=wcell.GetCellUserStringValueRow("<%=tfid%>");
            if(nrow>0){
                ncol=wcell.GetCellUserStringValueCol("<%=tfid%>");
<%
                int htmltype=1;
                int ftype=0;
                String tmpfid=tfid;
                int indx=tmpfid.lastIndexOf("_");
                if(indx>0){
                   htmltype=Util.getIntValue(tmpfid.substring(indx+1),1);
                   tmpfid=tmpfid.substring(0,indx);
                   indx=tmpfid.lastIndexOf("_");
                   if(indx>0){
                      ftype=Util.getIntValue(tmpfid.substring(indx+1),1);
                      tmpfid=tmpfid.substring(0,indx);
                   }
                }
        String preAdditionalValue = "";
        boolean haspreAdditional=false;
        int inoperateindex=inoperatefields.indexOf(tfid.substring(5,tfid.indexOf("_")));
        if(inoperateindex>-1){
        		haspreAdditional=true;
            preAdditionalValue = Util.null2String((String)inoperatevalues.get(inoperateindex));
        }
        		//选择框类型




                if(htmltype==5){
                	boolean hasPfield = false;
                	String pField = "";
                	for(int cx_tmp=0; cx_tmp<dcfids.size(); cx_tmp++){
                		String cField_tmp = Util.null2String((String)dcfids.get(cx_tmp));
                		//用于判断当前选择框 有没关联子字段




                		if(cField_tmp.equals(tmpfid.substring(5, tmpfid.indexOf("_")))){
                			pField = Util.null2String((String)dfids.get(cx_tmp));
                			hasPfield = true;
                			break;
                		}
                	}
                    FieldInfo.getSelectItem(tfid,isbill);
                    ArrayList  SelectItems=FieldInfo.getSelectItems();
                    ArrayList SelectItemValues=FieldInfo.getSelectItemValues();
                    ArrayList SelectDefaults=FieldInfo.getSelectDefaults();
                    ArrayList SelectCancels=FieldInfo.getSelectCancelValues();
                    String selectname="";
                    String Combostr="";
                    String selvalue="";
					RecordSet rsIsViewRS2 = new RecordSet();
					String isviewTemp = "";
					String iseditTemp = "";
					String ismandatoryTemp = "";
					if(fid.indexOf('_') > 5 ){
					String fieldidTemp2 = fid.substring(5,fid.indexOf('_'));
					String sqlForIsview = "select isview,isedit,ismandatory from workflow_modeview where nodeid = " +paranodeid + " and formid = " + formid + " and fieldid = " + fieldidTemp2;
					rsIsViewRS2.executeSql(sqlForIsview);
					if(rsIsViewRS2.next()){
						isviewTemp = Util.null2String(rsIsViewRS2.getString("isview"));
						iseditTemp = Util.null2String(rsIsViewRS2.getString("isedit"));
						ismandatoryTemp = Util.null2String(rsIsViewRS2.getString("ismandatory"));
				    }
					}
                    for(int n=0;n<SelectItems.size();n++){
                        String tmpname=(String)SelectItems.get(n);
                        String selectvalue=(String)SelectItemValues.get(n);
                        String isdefault=(String)SelectDefaults.get(n);
                        String cancel=(String)SelectCancels.get(n);
						 if(iseditTemp.equals("1") || ismandatoryTemp.equals("1")){
                	        if(cancel.equals("1")){
                    		    continue;
                		  }
						 }
                        Combostr+=";"+tmpname;
                        selvalue+=";"+selectvalue;
                        if("".equals(preAdditionalValue)){
			                    if("y".equals(isdefault)){
			                        fvalue=selectvalue;
			                        selectname=tmpname;
			                    }
				                }else{
				                    if(selectvalue.equals(preAdditionalValue)){
				                        fvalue=selectvalue;
				                        selectname=tmpname;
				                    }
				                }
                    }
              if(hasPfield == false){
%>
                wcell.SetCellComboType1(nrow,ncol,false,true,false,getChangeField("<%=Util.encodeJS(Combostr)%>"),"<%=selvalue%>");
                wcell.SetCellVal(nrow,ncol,getChangeField("<%=FieldInfo.toExcel(Util.encodeJS(selectname))%>"));
<%
              }else{
              	comboInitDetailJsStr += "doInitDetailChildCombo(\""+fid+"\",\""+pField+"\",\""+fvalue+"\");\n";
              	%>
              					wcell.SetCellComboType1(nrow,ncol,false,true,false,";;",";;");
              					wcell.SetCellVal(nrow,ncol,"");
              	<%
              }
             }

    	if(htmltype==9){
%>			wcell.SetCellVal(nrow,ncol,'<%=SystemEnv.getHtmlLabelName(126136,user.getLanguage()) %>');    
        	wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);	
<%}
        				if(htmltype==4&&preAdditionalValue.equals("1")){
%>
									wcell.SetCellCheckBoxValue(nrow,ncol,true);
<%							}
				if(htmltype==3){
            String showname="";
            fvalue="";
            if(!haspreAdditional&&preAdditionalValue.equals("")){
            	if((ftype==1 ||ftype==17 ||ftype==165 ||ftype==166) &&  body_isagent!=1) fvalue=""+user.getUID();
				if((ftype==1 ||ftype==17 ||ftype==165 ||ftype==166) &&  body_isagent==1) fvalue=""+beagenter;
            	if(ftype==2) {
            		fvalue=""+currentdate;
            		showname=""+currentdate;
            	}
            	if(ftype==19){
                    fvalue=currenttime.substring(0,5);
                    showname=currenttime.substring(0,5);
                }
            	if((ftype==164 || ftype==169 || ftype==170) &&  body_isagent!=1){ //浏览按钮为分部,取当前操作者为默认值(由人力资源的分部得到分部默认值)
                fvalue = ResourceComInfo.getSubCompanyID(""+user.getUID());
              }
			  if((ftype==164 || ftype==169 || ftype==170) &&  body_isagent==1){ //代理，浏览按钮为分部,取当前操作者为默认值(由人力资源的分部得到分部默认值)
                fvalue = ResourceComInfo.getSubCompanyID(""+beagenter);
              }
              if((ftype==4 ||ftype==57 ||ftype==167 ||ftype==168) &&  body_isagent!=1){ //浏览按钮为部门或多部门,取当前操作者为默认值(由人力资源的分部得到分部默认值)
                fvalue = ResourceComInfo.getDepartmentID(""+user.getUID());
              }
			  if((ftype==4 ||ftype==57 ||ftype==167 ||ftype==168) &&  body_isagent==1){ //浏览按钮为部门或多部门,取当前操作者为默认值(由人力资源的分部得到分部默认值)
                fvalue = ResourceComInfo.getDepartmentID(""+beagenter);
              }
              if(ftype==24 || ftype==278 &&  body_isagent!=1){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                  fvalue = ResourceComInfo.getJobTitle(""+user.getUID());
              }
              if(ftype==24 || ftype==278 &&  body_isagent==1){ //代理，浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                  fvalue = ResourceComInfo.getJobTitle(""+beagenter);
              }
            }else{
                fvalue=preAdditionalValue;
            }
            if(!fvalue.equals("")){
                ArrayList tempshowidlist=Util.TokenizerString(fvalue,",");
                if(ftype==2 || ftype==19){
                    //日期,时间
                    showname+=preAdditionalValue;
                }else if(ftype==8 || ftype==135){
                    //项目，多项目
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=Util.StringReplace(ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k)),",","，")+",";
                    }
                }else if(ftype==1 ||ftype==17 ||ftype==165 ||ftype==166){
                    //人员，多人员
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+",";
                    }
                }
                else if(ftype==160){
                    //角色人员
                    for(int k=0;k<tempshowidlist.size();k++){
                    	showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+",";
                    }
				}else if(ftype==142){
                    //收发文单位




                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=Util.StringReplace(docReceiveUnitComInfo_mhf.getReceiveUnitName((String)tempshowidlist.get(k)),",","，")+",";
                    }
                }
                else if(ftype==7 || ftype==18){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=Util.StringReplace(CustomerInfoComInfo1.getCustomerInfoname((String)tempshowidlist.get(k)),",","，")+",";
                    }
                }else if(ftype==4 ||ftype==57 ||ftype==167 ||ftype==168){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                    	String showdeptname = "";
   						String showdeptid = (String) tempshowidlist.get(k);
   						if(!"".equals(showdeptid)){
   							if(Integer.parseInt(showdeptid) < -1){
   								showdeptname = deptVirComInfo1.getDepartmentname(showdeptid);
   								
   							}else{
   								showdeptname = DepartmentComInfo1.getDepartmentname(showdeptid);
   							}
   						}
                        showname+=Util.StringReplace(showdeptname,",","，")+",";
                    }
                }else if(ftype==164 || ftype==169 || ftype==170 || ftype==194){
                    //分部
                    for(int k=0;k<tempshowidlist.size();k++){
                    	String showsubcompname = "";
						String showsubcompid = (String) tempshowidlist.get(k);
						if(!"".equals(showsubcompid)){
							if(Integer.parseInt(showsubcompid) < -1){
								showsubcompname = subCompVirComInfo1.getSubCompanyname(showsubcompid);
							}else{
								showsubcompname = SubCompanyComInfo1.getSubCompanyname(showsubcompid);
							}
						}
                        showname+=Util.StringReplace(showsubcompname,",","，")+",";
                    }
                }else if(ftype==9 || ftype==37){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=Util.StringReplace(DocComInfo1.getDocname((String)tempshowidlist.get(k)),",","，")+",";
                    }
                }else if(ftype==23){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=Util.StringReplace(CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k)),",","，")+",";
                    }
                }else if(ftype==16 || ftype==152 || ftype==171){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=Util.StringReplace(WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k)),",","，")+",";
                    }
                }else if(ftype==161 || ftype==162){                    
					//自定义字段




					Browser browser=(Browser)StaticObj.getServiceByFullname(dfielddbtype, Browser.class);
                    for(int k=0;k<tempshowidlist.size();k++){
						try{
                            BrowserBean bb=browser.searchById((String)tempshowidlist.get(k));
                            String desc=Util.null2String(bb.getDescription());
                            String name=Util.null2String(bb.getName());
                            showname+=Util.StringReplace(name,",","，")+",";
						}catch (Exception e){
						}
                    }
                }
                //added by alan for td:10814
				else if(ftype==142) {
					//收发文单位




					 for(int k=0;k<tempshowidlist.size();k++){
						 try {
						 	showname += Util.StringReplace(DocReceiveUnitComInfo.getReceiveUnitName(""+tempshowidlist.get(k)),",","，")+" ";
						 } catch(Exception e) {}
					 }
				}
                //end by alan for td:10814 
                else {
                    String tablename=BrowserComInfo.getBrowsertablename(""+ftype);
                    String columname=BrowserComInfo.getBrowsercolumname(""+ftype);
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(""+ftype);
                    String sql="select "+columname+" from "+tablename+" where "+keycolumname+" in("+fvalue+")";
                    rsaddop.executeSql(sql);
                    while(rsaddop.next()) {
                        showname +=Util.StringReplace(rsaddop.getString(1),",","，")+"," ;
                    }
               }
               if(showname.endsWith(",")){
                    showname=showname.substring(0,showname.length()-1);
               }
            }   
			
            if( ftype==9&&docFlags.equals("1") && tmpfid.equals("field"+flowDocField) ) {
%>

            createDocButtonSpan.innerHTML="<button id='createdoc' style='display:none' class=AddDoc onclick=createDocForNewTab('<%=tmpfid%>',"+isedit+")></button>"
<%
            }
%>
        wcell.SetCellVal(nrow,ncol,getChangeField("<%=FieldInfo.toExcel(Util.encodeJS(showname))%>"));    
        wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%
        }
                if(htmltype!=3 && htmltype!=4 && htmltype!=5 && !preAdditionalValue.equals("")){
%>
								wcell.SetCellVal(nrow,ncol,getChangeField('<%=FieldInfo.toExcel(Util.encodeJS(preAdditionalValue))%>'));
<%}%>
				imgshoworhide(nrow,ncol);
        }
<%
        }
    }
%>
<%=comboInitDetailJsStr%>
}

function initrow1() {
    var wcell = frmmain.ChinaExcel;
<%
    String fdbname = "";
	String organizationidurl = "";
	String organizationidurllink = "";
	if(isbill.equals("1")&&(formid==156 ||formid==157 ||formid==158 ||formid==159)){
  for(int i=0; i<detailtablefields.size();i++){
        ArrayList dfids=(ArrayList)detailtablefields.get(i);
		ArrayList dfielddbtypes=(ArrayList)DetailFieldDBTypes.get(i);
		ArrayList ddbfnames =  (ArrayList)DetailDBFieldNames.get(i);
		for(int j=0;j<dfids.size();j++){
            fid=(String)dfids.get(j);
            fvalue = "";
			dfielddbtype = (String)dfielddbtypes.get(j);
			fdbname = (String)ddbfnames.get(j);
%>
    var nrow = wcell.GetCellUserStringValueRow("<%=fid%>");
    if (nrow > 0) {
        var ncol = wcell.GetCellUserStringValueCol("<%=fid%>");
    <%
                 int htmltype=1;
                 int ftype=0;
                 String tmpfid=fid;
                 int indx=tmpfid.lastIndexOf("_");
                 if(indx>0){
                    htmltype=Util.getIntValue(tmpfid.substring(indx+1),1);
                    tmpfid=tmpfid.substring(0,indx);
                    indx=tmpfid.lastIndexOf("_");
                    if(indx>0){
                       ftype=Util.getIntValue(tmpfid.substring(indx+1),1);
                       tmpfid=tmpfid.substring(0,indx);
                    }
                 }
         String preAdditionalValue = "";
         int inoperateindex=inoperatefields.indexOf(fid.substring(5,fid.indexOf("_")));
         if(inoperateindex>-1){
             preAdditionalValue = Util.null2String((String)inoperatevalues.get(inoperateindex));
         }

         if(fdbname.equals("organizationtype")){
             organizationtype = preAdditionalValue;
         }
         if(fdbname.equals("organizationid")){
             if(organizationtype.equals("1")){//分部
                 ftype = 164;
             }else if(organizationtype.equals("2")){//部门
                 ftype = 4;
             }else if(organizationtype.equals("3")){//个人
                 ftype = 1;
             }else if(organizationtype.equals(FnaCostCenter.ORGANIZATION_TYPE+"")){//成本中心
                 ftype = 251;
             }else{
				if(fnaBudgetOAOrg && fnaBudgetCostCenter){
					ftype = 4;
				}else if(fnaBudgetOAOrg){
					ftype = 4;
				}else if(fnaBudgetCostCenter){
					ftype = 251;
				}
             }
             if(!fid.equals("")){
                 organizationid = fid.substring(0,fid.indexOf("_"));
             }
             String organizationidfid = Util.StringReplace(fid,"_1_","_"+ftype+"_");
             organizationidurl = BrowserComInfo.getBrowserurl(ftype+"");
             organizationidurllink = BrowserComInfo.getLinkurl(ftype+"");
         %>
        try {
            $G("<%=organizationid%>_url").value = "<%=organizationidurl%>";
            $G("<%=organizationid%>_urllink").value = "<%=organizationidurllink%>";
            var organizationidcol = wcell.GetCellUserStringValueCol("<%=fid%>");
            var organizationidrow = wcell.GetCellUserStringValueRow("<%=fid%>");
            wcell.SetCellProtect(organizationidrow, organizationidcol, organizationidrow, organizationidcol, false);
            wcell.SetCellUserStringValue(organizationidrow, organizationidcol, organizationidrow, organizationidcol, "<%=organizationidfid%>");
            wcell.SetCellVal(organizationidrow,organizationidcol,"");
		    imgshoworhide(organizationidrow,organizationidcol);
            wcell.SetCellProtect(organizationidrow, organizationidcol, organizationidrow, organizationidcol, true);
        } catch(e) {
        }
    <%
            }
    %>
    }
<%
		}
		}
		}
%>
}

function setnodevalue(){
    var wcell=frmmain.ChinaExcel;
    var nrow=0;
    var ncol=0;
	//先解析模板中相同行节点意见位置




	var node_row = new Array();
	var node_ids = new Array();
	var node_addrows = new Array();
	var border_row = new Array();
	var SetRowSize_row = new Array();
	var SetRowSize_size = new Array();
	<%
	for(int i=0;i<NodeList.size();i++){
	    String nodestr=(String)NodeList.get(i);
	    int nodeid = 0;
	    int indx = nodestr.lastIndexOf("_");
	    if(indx>0){
	        nodeid=Util.getIntValue(nodestr.substring(indx+1));
	    }
	%>
		
	    var nrow=wcell.GetCellUserStringValueRow("<%=nodestr%>");
	    if(nrow>0){
	    	var idx = node_row.indexOf(nrow);
	    	if(idx > -1) {
	    		var tmpnode_ids = node_ids[idx];
	    		//alert(tmpnode_ids);
	    		node_ids[idx].push('<%=nodeid%>');
	    	} else {
	    		node_row.push(nrow);
	    		node_ids.push(new Array('<%=nodeid%>'));
	    		node_addrows.push(0);
	    	}
	    }
	<%
	}
	%>
<%
for(int i=0;i<NodeList.size();i++){
    String nodestr=(String)NodeList.get(i);
    int nodeid=0;
    int indx=nodestr.lastIndexOf("_");
    if(indx>0){
        nodeid=Util.getIntValue(nodestr.substring(indx+1));
    }
    //增加自由流转节点
    String nodemark="";
    if(nodeid == 999999999){
    	nodemark = FieldInfo.GetfreeNodeRemark(workflowid,Util.getIntValue(paranodeid),1);
    }else{
    	nodemark = FieldInfo.GetNodeRemark(workflowid,nodeid,Util.getIntValue(paranodeid));
    }
    nodemark = nodemark.replaceAll("&ldquo;","“");
    nodemark = nodemark.replaceAll("&rdquo;","”");
%>
    nrow=wcell.GetCellUserStringValueRow("<%=nodestr%>");
    if(nrow>0){
        ncol=wcell.GetCellUserStringValueCol("<%=nodestr%>");    
		var idx = 0;
		var rowCnt = 0;
		for(var h = 0; h < node_ids.length; h++) {
			if(node_ids[h].indexOf('<%=nodeid%>') > -1) {
	    		idx = h;
	    		break;
			}
		}
		
		if(idx > -1) {
			rowCnt = node_addrows[idx];
		}
<%
if(nodemark.indexOf("/weaver/weaver.file.FileDownload?fileid=")>=0
   ||nodemark.indexOf("/weaver/weaver.file.ImgFileDownload?userid=")>=0
   ||nodemark.indexOf("/weaver/weaver.file.SignatureDownLoad?markId=")>=0){
%>
	        wcell.SetCanRefresh(false);
<%
			List nodeRemarkListOfBeenSplited=FieldInfo.getNodeRemarkList(nodemark);
			Map nodeRemarkOfBeenSplitedMap=null;
			String imageNodeRemark=null;
			String strNodeRemark=null;
			int n=0;
			for(int j=0;j<nodeRemarkListOfBeenSplited.size();j++){
			    nodeRemarkOfBeenSplitedMap=(Map)nodeRemarkListOfBeenSplited.get(j);
			    imageNodeRemark=(String)nodeRemarkOfBeenSplitedMap.get("imageNodeRemark");
			    strNodeRemark=(String)nodeRemarkOfBeenSplitedMap.get("strNodeRemark");
				if(imageNodeRemark != null){
					imageNodeRemark = imageNodeRemark.replaceAll("\r\n", "<br>");
					imageNodeRemark = imageNodeRemark.replaceAll("\n", "<br>");
					imageNodeRemark = imageNodeRemark.replaceAll("\"", "\\\\\"");
					imageNodeRemark = imageNodeRemark.replaceAll("\'", "\\\\\'");
				}
			    strNodeRemark=(String)nodeRemarkOfBeenSplitedMap.get("strNodeRemark");
				if(strNodeRemark != null){
					strNodeRemark = strNodeRemark.replaceAll("\r\n", "<br>");
					strNodeRemark = strNodeRemark.replaceAll("\n", "<br>");
					strNodeRemark = strNodeRemark.replaceAll("\"", "\\\\\"");
					strNodeRemark = strNodeRemark.replaceAll("\'", "\\\\\'");
				}
				if(j>0){
					n++;
%>
				if(<%=n%> > rowCnt) {
					wcell.InsertOnlyFormatRows(nrow+<%=n%>-1, 1,nrow,nrow);
					for(k=0; k < border_row.length; k++){
						if(border_row[k] > nrow+<%=n%>) {
							border_row[k] = border_row[k] + 1;
						}
					}
					for(k=0; k < SetRowSize_row.length; k++){
						if(SetRowSize_row[k] > nrow+<%=n%>) {
							SetRowSize_row[k] = SetRowSize_row[k] + 1;
						}
					}
					if(border_row.indexOf(nrow+<%=n%>) == -1) {
						border_row.push(nrow+<%=n%>);//记录添加的行，清除上边框使用
					}
					//新加的行清除图片
					for(k=0; k<=wcell.GetMaxCol(); k++){
						isProtect=wcell.IsCellProtect(nrow+<%=n%>,k);
						if(isProtect){
							wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,false);
							wcell.DeleteCellImage(nrow+<%=n%>,k,nrow+<%=n%>,k);
							wcell.SizeRowToFontSizeHeight(nrow+<%=n%>,nrow+<%=n%>,k, false);
						}
						if(isProtect){
							wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,true);
						}
					}
					node_addrows[idx] = '<%=n%>';
				}
<%
				}
%>
			    isProtect=wcell.IsCellProtect(nrow+<%=n%>,ncol);
			    if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,false);
			    }
<%
	BaseBean wfsbean=FieldInfo.getWfsbean();
	int rowheight=Util.getIntValue(wfsbean.getPropValue("WFSignatureImg","imgheight"),0);
	int imgshowtpe=Util.getIntValue(wfsbean.getPropValue("WFSignatureImg","imgshowtpe"),2);
	if(imageNodeRemark.indexOf("/weaver/weaver.file.ImgFileDownload?userid=")>=0){
%>
<%
                    if(rowheight>0){
%>
						if(SetRowSize_row.indexOf(nrow+<%=n%>) == -1) {
							SetRowSize_row.push(nrow+<%=n%>);
							SetRowSize_size.push(<%=rowheight%>);
						}
<%
                    }
%>
			        wcell.ReadHttpImageFile("<%=imageNodeRemark%>",nrow+<%=n%>,ncol,true,<%=(imgshowtpe==1)?true:false%>);
                    wcell.SetCellImageSize(nrow+<%=n%>,ncol,<%=imgshowtpe%>);
<%
	}else if(imageNodeRemark.indexOf("/weaver/weaver.file.FileDownload?fileid=")>=0){
%>
			    wcell.ReadHttpImageFile("<%=imageNodeRemark%>",nrow+<%=n%>,ncol,true,false);
				wcell.SetCellImageSize(nrow+<%=n%>,ncol,<%=imgshowtpe%>);
				if(SetRowSize_row.indexOf(nrow+<%=n%>) == -1) {
					SetRowSize_row.push(nrow+<%=n%>);
					SetRowSize_size.push(<%=rowheight%>);
				}
<%
	}else if(imageNodeRemark.indexOf("/weaver/weaver.file.SignatureDownLoad?markId=")>=0){
%>
	    wcell.ReadHttpImageFile("<%=imageNodeRemark%>",nrow+<%=n%>,ncol,true,false);
		wcell.SetCellImageSize(nrow+<%=n%>,ncol,<%=imgshowtpe%>);
		if(SetRowSize_row.indexOf(nrow+<%=n%>) == -1) {
			SetRowSize_row.push(nrow+<%=n%>);
			SetRowSize_size.push(<%=rowheight%>);
		}
<%
	}
				
	//TD47194，用于解决签字意见中插入图片之后再模板模式下不显示签字意见的问题。




	if(strNodeRemark==null)strNodeRemark="";
	String txtImageNodeRemark = imageNodeRemark;
	if(imageNodeRemark.startsWith("/weaver/weaver.file.FileDownload?fileid=")
			||imageNodeRemark.startsWith("/weaver/weaver.file.ImgFileDownload?userid=")
			||imageNodeRemark.startsWith("/weaver/weaver.file.SignatureDownLoad?markId=")){
		txtImageNodeRemark="";
	}
%>
			    var strNodeRemark = '<%out.print(Util.encodeJS(FieldInfo.toExcel(FieldInfo.dropScript(strNodeRemark+txtImageNodeRemark))));%>';
    			strNodeRemark = getFckText(strNodeRemark);

<%
	if(imageNodeRemark.indexOf("/weaver/weaver.file.ImgFileDownload?userid=")>=0&&!strNodeRemark.equals("")){
%>
			    if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,true);
			    }
<%
        n++;	
%>
			if(<%=n%> > rowCnt) {
			    wcell.InsertOnlyFormatRows(nrow+<%=n%>-1, 1,nrow,nrow);
				for(k=0; k < border_row.length; k++){
					if(border_row[k] > nrow+<%=n%>) {
						border_row[k] = border_row[k] + 1;
					}
				}
				for(k=0; k < SetRowSize_row.length; k++){
					if(SetRowSize_row[k] > nrow+<%=n%>) {
						SetRowSize_row[k] = SetRowSize_row[k] + 1;
					}
				}
				if(border_row.indexOf(nrow+<%=n%>) == -1) {
					border_row.push(nrow+<%=n%>);//记录添加的行，清除上边框使用
				}
				//新加的行清除图片
				for(k=0; k<=wcell.GetMaxCol(); k++){
					isProtect=wcell.IsCellProtect(nrow+<%=n%>,k);
					if(isProtect){
						wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,false);
						wcell.DeleteCellImage(nrow+<%=n%>,k,nrow+<%=n%>,k);
						wcell.SizeRowToFontSizeHeight(nrow+<%=n%>,nrow+<%=n%>,k, false);
					}
					if(isProtect){
						wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,true);
					}
				}
				node_addrows[idx] = '<%=n%>';
			}
			    isProtect=wcell.IsCellProtect(nrow+<%=n%>,ncol);
			    if(!isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,true);
			    }
                wcell.SetCellVal(nrow+<%=n%>,ncol,getChangeField(strNodeRemark));
                wcell.SetCellHorzTextAlign(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,1);
                wcell.SetCellVertTextAlign(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,3);

			    if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,true);
			    }
<%
	}else{
%>
	if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,true);
			    }
<%
if("".equals(txtImageNodeRemark)) {
	//n++;
}else{
%>

				if(<%=n%> > rowCnt) {
				    wcell.InsertOnlyFormatRows(nrow+<%=n%>-1, 1,nrow,nrow);
					for(k=0; k < border_row.length; k++){
						if(border_row[k] > nrow+<%=n%>) {
							border_row[k] = border_row[k] + 1;
						}
					}
					for(k=0; k < SetRowSize_row.length; k++){
						if(SetRowSize_row[k] > nrow+<%=n%>) {
							SetRowSize_row[k] = SetRowSize_row[k] + 1;
						}
					}
					if(border_row.indexOf(nrow+<%=n%>) == -1) {
						border_row.push(nrow+<%=n%>);//记录添加的行，清除上边框使用
					}
					//新加的行清除图片
					for(k=0; k<=wcell.GetMaxCol(); k++){
						isProtect=wcell.IsCellProtect(nrow+<%=n%>,k);
						if(isProtect){
							wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,false);
							wcell.DeleteCellImage(nrow+<%=n%>,k,nrow+<%=n%>,k);
							wcell.SizeRowToFontSizeHeight(nrow+<%=n%>,nrow+<%=n%>,k, false);
						}
						if(isProtect){
							wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,true);
						}
					}
					node_addrows[idx] = '<%=n%>';
				}
		<%}%>
                wcell.SetCellVal(nrow+<%=n%>,ncol,getChangeField(strNodeRemark));
                wcell.SetCellHorzTextAlign(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,1);
                wcell.SetCellVertTextAlign(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,3);
			    if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,true);
			    }
<%
	}
			}
%>
	        wcell.SetCanRefresh(true);
	        wcell.RefreshViewSize();
	        wcell.ReCalculate();
<%
		}else{
			 //去掉每条签字意见内容之后所添加的分隔符。




			nodemark = nodemark.replace(String.valueOf(FieldInfo.getNodeSeparator()), "").replace(String.valueOf(Util.getSeparator()),""); 
%>
			var nodemark = '<%out.print(Util.encodeJS(FieldInfo.toExcel(FieldInfo.dropScript(nodemark))));%>';
			nodemark = getFckText(nodemark);
            wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
            wcell.SetCellAutoWrap(nrow,ncol,nrow,ncol,true);
            wcell.SetCellVal(nrow,ncol,getChangeField(nodemark));
            imghide(nrow,ncol);
            wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%
		}
%>
		for(k=0; k<=wcell.GetMaxRow(); k++){
			var idx = SetRowSize_row.indexOf(k);
			//wcell.AutoSizeRow(k, k, true);
			if(idx > -1) {
				var iRow = SetRowSize_row[idx];
				var iRowSize = SetRowSize_size[idx];
				if(wcell.GetRowSize(iRow, 0) < iRowSize) {
					wcell.SetRowSize(iRow, iRow, iRowSize, 1);
				}
			}
		}
		SetRowSize_size = new Array();
		SetRowSize_row = new Array();
    }
<%
}   
%>
	//新添加的行清除上边框的操作移到下面处理，提高效率
	if(border_row.length > 0) {
		for(var h = 0; h < border_row.length; h++) {
			for(k=0;k<=wcell.GetMaxCol();k++){
				isProtect=wcell.IsCellProtect(border_row[h],k);
				if(isProtect){
					wcell.SetCellProtect(border_row[h],k,border_row[h],k,false);
				}
			    wcell.ClearCellBorder(border_row[h],k, border_row[h], k, 2);
				if(isProtect){
					wcell.SetCellProtect(border_row[h],k,border_row[h],k,true);
				}
			}
		}
	
		wcell.SetCanRefresh(true);
		wcell.RefreshViewSize();
		wcell.ReCalculate();
	}
}

function MainCalculate(){
  var wcell=frmmain.ChinaExcel;  
<%
  for(int i=0; i<mantablefields.size();i++){
    String cfid=(String)mantablefields.get(i);
%>
    var nrow=wcell.GetCellUserStringValueRow("<%=cfid%>");
    if(nrow>0){
        var ncol=wcell.GetCellUserStringValueCol("<%=cfid%>");
        var Formula=wcell.GetCellFormula(nrow,ncol);
        if(Formula!=null && Formula!=""){
            var cellvaule=wcell.GetCellValue(nrow,ncol);
			var tmphead = "";//TD9107 支持负数的运算




			if(cellvaule != null && cellvaule.length >0 && cellvaule.substring(0, 1) == "-"){
				tmphead = "-";
			}
			//cellvaule=tmphead+cellvaule.replace(/[^0-9\.]/,"");
			cellvaule=cellvaule;
<%
            String tmpfid=cfid;
            String calfid="0";
            int indx=tmpfid.indexOf("_");
            if(indx>0){
                tmpfid=tmpfid.substring(0,indx);
            }
            if(tmpfid.length()>5) calfid=tmpfid.substring(5);
%>
            $G("<%=tmpfid%>").value=cellvaule;
            var tcalfields=$G("calfields").value;
            if((","+tcalfields+",").indexOf(",<%=calfid%>,")<0){
                tcalfields+=",<%=calfid%>";
                $G("calfields").value=tcalfields;
            }
        }
    }
<%
  }
%>
}

function DetailCalculate(){
  var wcell=frmmain.ChinaExcel;
<%
  for(int i=0; i<detailtablefields.size();i++){
%>
    var rows=parseInt($G("indexnum<%=i%>").value);
<%
        ArrayList dfids=(ArrayList)detailtablefields.get(i);
        for(int j=0;j<dfids.size();j++){
             String tmpfid=(String)dfids.get(j);
                String cdfid=tmpfid.substring(0,tmpfid.indexOf("_"));
                int indx=tmpfid.lastIndexOf("_");
                String calfid="0";
                String tmptype="";
                String tmphtmltype="";
                if(indx>0){
                    tmphtmltype=tmpfid.substring(indx+1);
                    tmpfid=tmpfid.substring(0,indx);
                    indx=tmpfid.lastIndexOf("_");
                    if(indx>0){
                        tmptype=tmpfid.substring(indx+1);
                        tmpfid=tmpfid.substring(0,indx);
                    }
                 }
                 indx=tmpfid.indexOf("_");
                 if(indx>0) calfid=tmpfid.substring(0,indx);
                 if(calfid.length()>5){
                    calfid=calfid.substring(5);
                 }else{
                    calfid="0";
                 }
%>
                for(k=0;k<rows;k++){
                var fieldstr="<%=cdfid%>_"+k+"_<%=tmptype%>_<%=tmphtmltype%>";

                var nrow=wcell.GetCellUserStringValueRow(fieldstr);
                if(k==0) nrow=nrow+rowgroup[<%=i%>];
                if(nrow>0){
                    var ncol=wcell.GetCellUserStringValueCol(fieldstr);
                    var Formula=wcell.GetCellFormula(nrow,ncol);
                    if(Formula!=null && Formula!=""){
                        var cellvaule=wcell.GetCellValue(nrow,ncol);
						var tmphead = "";//TD9107 支持负数的运算




						if(cellvaule != null && cellvaule.length >0 && cellvaule.substring(0, 1) == "-"){
							tmphead = "-";
						}
						//cellvaule=tmphead+cellvaule.replace(/[^0-9\.]/,"");
						cellvaule=cellvaule;
                        $G("<%=cdfid%>_"+k).value=cellvaule;
                    }
                }
                }
               try{
                        var caldetfields=$G("caldetfields").value;
                        if((","+caldetfields+",").indexOf(",<%=calfid%>,")<0){
                            caldetfields+=",<%=calfid%>";
                            $G("caldetfields").value=caldetfields;
                        }
               }catch(e){}
<%
            }
        }
%>
}


function createDocForNewTab(tmpfid,isedit){
  
   if(tmpfid==null||tmpfid==""){
	   return ;
   }

   var fieldbodyid="0";

   if(tmpfid.length>5){
	   fieldbodyid=tmpfid.substring(5);
   }
	/*
   for(i=0;i<=1;i++){
  		parent.$G("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.$G("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$G("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.$G("oTDtype_1").className="cycleTDCurrent";
  	*/
	var docValue=$G(tmpfid).value;

  	//frmmain.action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docValue;
  	if("<%=isremark%>"==9||<%=!editbodymodeflag%>||"<%=isremark%>"==5||"<%=isremark%>"==8){
  		frmmain.action = "RequestDocView.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&docValue="+docValue;
  	}else{
  	//frmmain.action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docValue;
  	    frmmain.action = $G("oldaction").value+"?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&docView="+isedit+"&docValue="+docValue+"&isFromEditDocument=true";
  	}
    frmmain.method.value = "crenew_"+fieldbodyid ;
	frmmain.target="delzw";
	parent.delsave();
	if(check_form(document.frmmain,'requestname')){
      	if($G("needoutprint")) $G("needoutprint").value = "1";//标识点正文




        document.frmmain.src.value='save';
        document.frmmain.isremark.value='0';

        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
                        //附件上传
                        StartUploadAll();
                        checkuploadcompletBydoc();                        
    }
}
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
function doInitChildCombo(field,pField,fvalue){
	try{
		var wcell = $G("ChinaExcel");
	    var fieldid = pField.substring(5, pField.indexOf("_"));
		var selvalue = $G("field"+fieldid).value;
		if(selvalue==null || selvalue==""){
			return;
		}
	    var childfield = field.substring(5, field.indexOf("_"));
		var paraStr = "init=1&fieldid="+fieldid+"&childfield="+childfield+"&isbill=<%=isbill%>&selectvalue="+selvalue+"&rownum=0&childfieldValue="+fvalue;
		var frm = document.createElement("iframe");
		frm.id = "iframe_"+pField+"_"+field;
		frm.style.display = "none";
	    document.body.appendChild(frm);
		$G("iframe_"+pField+"_"+field).src = "ComboChange.jsp?"+paraStr;
	}catch(e){}
}
function doInitDetailChildComboAll(field,pField,fvalue,pFieldValue,rownum){
	try{

		var selvalue = pFieldValue;
		if(selvalue==null || selvalue==""){
			return;
		}
	    var fieldid = pField.substring(5, pField.indexOf("_"));
	    var childfield = field.substring(5, field.length);
		var paraStr = "init=1&ismanager=1&fieldid="+fieldid+"&childfield="+childfield+"&isbill=<%=isbill%>&selectvalue="+selvalue+"&rownum="+rownum+"&childfieldValue="+fvalue;
		var frm = document.createElement("iframe");
		frm.id = "iframe_"+pField+"_"+field+"_"+rownum;
		frm.style.display = "none";
	    document.body.appendChild(frm);
		$G("iframe_"+pField+"_"+field+"_"+rownum).src = "ComboChange.jsp?"+paraStr;
	}catch(e){}
}
function doInitDetailChildCombo(field,pField,fvalue,pFieldValue,rownum){
	try{

		var selvalue = pFieldValue;
		//alert(selvalue);
		//alert();
		if(selvalue==null || selvalue==""){
			return;
		}
	    var fieldid = pField.substring(5, pField.indexOf("_"));
	    var childfield = field;
		var paraStr = "init=1&ismanager=1&fieldid="+fieldid+"&childfield="+childfield+"&isbill=<%=isbill%>&selectvalue="+selvalue+"&rownum="+rownum+"&childfieldValue="+fvalue;
		var frm = document.createElement("iframe");
		frm.id = "iframe_"+pField+"_"+field+"_"+rownum;
		frm.style.display = "none";
	    document.body.appendChild(frm);
		$G("iframe_"+pField+"_"+field+"_"+rownum).src = "ComboChange.jsp?"+paraStr;
	}catch(e){}
}

function DateMeetingCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo) {  
		YearFrom  = parseInt(YearFrom,10);
		MonthFrom = parseInt(MonthFrom,10);
		DayFrom = parseInt(DayFrom,10);
		YearTo    = parseInt(YearTo,10);
		MonthTo   = parseInt(MonthTo,10);
		DayTo = parseInt(DayTo,10);
		if(YearTo<YearFrom)
			return false;
		else {
			if(YearTo==YearFrom) {
				if(MonthTo<MonthFrom)
				return false;
				else{
					if(MonthTo==MonthFrom){
						if(DayTo<DayFrom)
						return false;
						else
						return true;
					}
					else 
					return true;
				}
			}
			else
			 return true;
		}
	}
	function checkmeetingtimeok() {
	    fromdate = $G("<%=m_fromdateid%>").value;	
	    enddate = $G("<%=m_enddateid%>").value;
	    fromtime = $G("<%=m_fromtimeid%>").value;
	    endtime = $G("<%=m_endtimeid%>").value;
	    if (fromdate!="b" && fromdate!="a" && enddate != ""){
			YearFrom = fromdate.substring(0,4);
			MonthFrom = fromdate.substring(5,7);
			DayFrom = fromdate.substring(8,10);
			YearTo = enddate.substring(0,4);
			MonthTo = enddate.substring(5,7);
			DayTo = enddate.substring(8,10);
			if (!DateMeetingCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )) {
				alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
				return false;
			 } else {
				if(enddate ==fromdate && endtime < fromtime) {
					alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
					return false;
				}
			}
	    }
	    return true; 
	}
</script>
<script language=javascript src="/js/characterConv_wev8.js"></script>
<script language=vbs src="/workflow/mode/loadmode.vbs"></script>