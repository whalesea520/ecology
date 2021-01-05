
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Calendar,java.util.Hashtable" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.*,java.util.*" %>
<%@ page import="java.net.*,java.util.*" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<jsp:useBean id="requestPreAddM" class="weaver.workflow.request.RequestPreAddinoperateManager" scope="page" />

<!--TD4262 增加提示信息  开始-->
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo1" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="leaveTypeColorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
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
String comboInitDetailJsStr = "";
String acceptlanguage = request.getHeader("Accept-Language");
User user = HrmUserVarify.getUser (request , response) ;
%>
<!--TD4262 增加提示信息  结束-->

<div style="display:none">
<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
</table>
</div>

<!--TD4262 增加提示信息  开始-->
<div id="divFavContent18978" style="display:none">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>	
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent18979" style="display:none">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>	
			</td>
		</tr>
	</table>
</div>
<div id="divFavContent24272" style="display:none">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(24272,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>
<!--TD4262 增加提示信息  结束-->
<iframe id="checkReportDataForm" frameborder=0 scrolling=no src="javascript:false"  style="display:none"></iframe>
<%
int requestid = Util.getIntValue(request.getParameter("requestid"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
String billid = Util.null2String(request.getParameter("billid"));
String formid = Util.null2String(request.getParameter("formid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String isbill = Util.null2String(request.getParameter("isbill"));
String prjid = Util.null2String(request.getParameter("prjid"));
String reqid = Util.null2String(request.getParameter("reqid"));//TD9145 获得来自页面的requsetid
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
String currentdate = Util.null2String(request.getParameter("currentdate"));
String currenttime = Util.null2String(request.getParameter("currenttime"));
int Languageid = Util.getIntValue(request.getParameter("Languageid"));
String docCategory=Util.null2String(request.getParameter("docCategory"));
String isFormSignature=Util.null2String(request.getParameter("isFormSignature"));
String isSignMustInput=Util.null2String(request.getParameter("isSignMustInput"));

String fieldUrl = Util.null2String(request.getParameter("fieldUrl"));
Map fieldMap = new HashMap();
if(!"".equals(fieldUrl)) {
	String[] fieldUrlArr = fieldUrl.split("&");
	for(int i = 0; i < fieldUrlArr.length; i++) {
		String fieldStr = fieldUrlArr[i];
		String[] fieldArr = fieldStr.split("=");
		if(fieldArr.length != 2) {
			continue;
		}
		fieldMap.put(fieldArr[0], URLDecoder.decode(fieldArr[1]));
	}
}

String tempMessageType = "";
String smsAlertsType = "";
//微信提醒START(QC:98106)
String tempChatsType = "";
String chatsAlertType = "";
int hrmResourceShow = 0;
//rsaddop.executeSql("select messageType,smsAlertsType from workflow_base where id="+workflowid);
rsaddop.executeSql("select messageType,smsAlertsType,chatsType,chatsAlertType,hrmResourceShow from workflow_base where id="+workflowid);
if(rsaddop.next()){
    tempMessageType = Util.null2o(rsaddop.getString("messageType"));
    smsAlertsType = Util.null2o(rsaddop.getString("smsAlertsType"));
    tempChatsType = Util.null2o(rsaddop.getString("chatsType"));
    chatsAlertType = Util.null2o(rsaddop.getString("chatsAlertType")); 
    hrmResourceShow = Util.getIntValue(rsaddop.getString("hrmResourceShow"));
}
//微信提醒END(QC:98106)
/**TD11608 hww**/
String m_fromdateid = "";
String m_enddateid = "";
String m_fromtimeid = "";
String m_endtimeid = "";
if("85".equals(formid)) {
  rsaddop.executeSql("select id from workflow_billfield where billid = 85 and fieldname = 'BeginDate' ");
  if(rsaddop.next()) m_fromdateid = "field"+rsaddop.getString(1);
 
  rsaddop.executeSql("select id from workflow_billfield where billid = 85 and fieldname = 'EndDate' ");
  if(rsaddop.next()) m_enddateid = "field"+rsaddop.getString(1);

  rsaddop.executeSql("select id from workflow_billfield where billid = 85 and fieldname = 'BeginTime' ");
  if(rsaddop.next()) m_fromtimeid = "field"+rsaddop.getString(1);

  rsaddop.executeSql("select id from workflow_billfield where billid = 85 and fieldname = 'EndTime' ");
  if(rsaddop.next()) m_endtimeid = "field"+rsaddop.getString(1);
}
if("163".equals(formid)) {
  rsaddop.executeSql("select id from workflow_billfield where billid = 163 and fieldname = 'startDate' ");
  if(rsaddop.next()) m_fromdateid = "field"+rsaddop.getString(1);
 
  rsaddop.executeSql("select id from workflow_billfield where billid = 163 and fieldname = 'endDate' ");
  if(rsaddop.next()) m_enddateid = "field"+rsaddop.getString(1);

  rsaddop.executeSql("select id from workflow_billfield where billid = 163 and fieldname = 'startTime' ");
  if(rsaddop.next()) m_fromtimeid = "field"+rsaddop.getString(1);

  rsaddop.executeSql("select id from workflow_billfield where billid = 163 and fieldname = 'endTime' ");
  if(rsaddop.next()) m_endtimeid = "field"+rsaddop.getString(1);
}
/**TD11608 hww**/

%>
<input type=hidden name="relatedPrjId" value=<%=prjid%>>
<input type=hidden name="relatedDocId" value=<%=docid%>>
<input type=hidden name="relatedCrmId" value=<%=crmid%>>
<input type=hidden name="isSignMustInput" value=<%=isSignMustInput%>>
<%
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
session.setAttribute("f_weaver_belongto_userid",f_weaver_belongto_userid);
session.setAttribute("f_weaver_belongto_usertype",f_weaver_belongto_usertype);
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid = user.getUID();
int beagenter1=user.getUID();
String beagenter=""+user.getUID();


//获得被代理人
int body_isagent=Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+userid),0);
if(body_isagent==1){
    beagenter1=Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+userid),0);
    beagenter=""+Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+userid),0);
}
int defaultName = Util.getIntValue(request.getParameter("defaultName"));
String logintype = user.getLogintype();
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo1.getCustomerInfoname(""+userid),user.getLanguage());
if(body_isagent==1) {
	username=ResourceComInfo.getLastname(beagenter);
}
weaver.general.DateUtil   DateUtil=new weaver.general.DateUtil();
String txtuseruse=DateUtil.getWFTitleNew(""+workflowid,""+beagenter,""+username,logintype);
String subcompanyidofdefaultuser = ResourceComInfo.getSubCompanyID(""+user.getUID());
String departmentidofdefaultuser = ResourceComInfo.getDepartmentID(""+user.getUID());
String jobtitleidofdefaultuser = ResourceComInfo.getJobTitle(""+user.getUID());
if(body_isagent==1) {
	subcompanyidofdefaultuser = ResourceComInfo.getSubCompanyID(""+beagenter);
	departmentidofdefaultuser = ResourceComInfo.getDepartmentID(""+beagenter);
	jobtitleidofdefaultuser = ResourceComInfo.getJobTitle(""+beagenter);
}
String workflowname = Util.null2String((String)session.getAttribute(userid+"_"+workflowid+"workflowname"));

ArrayList flowDocs=flowDoc.getDocFiled(""+workflowid); //得到流程建文挡的发文号字段


String flowDocField="";
String newTextNodes = "";//判断正文新建是否要选择按钮
if (flowDocs!=null&&flowDocs.size()>1)
{
flowDocField=""+flowDocs.get(1);
newTextNodes = "" +flowDocs.get(5);
}
String docFlags=Util.null2String((String)session.getAttribute("requestAdd"+requestid));
if (docFlags.equals("")) docFlags=Util.null2String((String)session.getAttribute("requestAdd"+user.getUID()));

String bodychangattrstr="";
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
ArrayList seldefieldsadd=WfLinkageInfo.getSelectField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),1);
String stringseldefieldsadd="";
for(int i=0;i<seldefieldsadd.size();i++){
	stringseldefieldsadd+=(String)seldefieldsadd.get(i)+",";
}

ArrayList changefieldsdemanage=WfLinkageInfo.getChangeField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
ArrayList changedefieldsdemanage=WfLinkageInfo.getChangeField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),1);
ArrayList mantablefields=new ArrayList();
ArrayList mantablefieldlables=new ArrayList();
ArrayList manTableChildFields=new ArrayList();
ArrayList detailtablefields=new ArrayList();
ArrayList detailtablefieldlables=new ArrayList();
ArrayList detailTableChildFields=new ArrayList();
ArrayList ManUrlList=new ArrayList();
ArrayList ManUrlLinkList=new ArrayList();
ArrayList DetailUrlList=new ArrayList();
ArrayList DetailUrlLinkList=new ArrayList();
ArrayList DetailDBFieldNames=new ArrayList();

FieldInfo.GetManTableField(Util.getIntValue(formid),Util.getIntValue(isbill),Languageid);
FieldInfo.GetDetailTableField(Util.getIntValue(formid),Util.getIntValue(isbill),Languageid);

int managerid=FieldInfo.getManagerFieldID(Util.getIntValue(formid),Util.getIntValue(isbill));
mantablefields=FieldInfo.getManTableFields();
detailtablefields=FieldInfo.getDetailTableFields();
mantablefieldlables=FieldInfo.getManTableFieldNames();
detailtablefieldlables=FieldInfo.getDetailTableFieldNames();
ManUrlList=FieldInfo.getManUrlList();
ManUrlLinkList=FieldInfo.getManUrlLinkList();
manTableChildFields=FieldInfo.getManTableChildFields();
DetailUrlList=FieldInfo.getDetailUrlList();
DetailUrlLinkList=FieldInfo.getDetailUrlLinkList();
ArrayList detailtablefieldids=FieldInfo.getDetailTableFieldIds();
detailTableChildFields=FieldInfo.getDetailTableChildFields();
ArrayList ManTableFieldFieldNames=FieldInfo.getManTableFieldFieldNames();    
ArrayList manfieldvalues=FieldInfo.getManTableFieldValues();
ArrayList ManTableFieldDBTypes=FieldInfo.getManTableFieldDBTypes();
ArrayList DetailFieldDBTypes=FieldInfo.getDetailFieldDBTypes();
DetailDBFieldNames=FieldInfo.getDetailDBFieldNames();

String mainId="";
String subId="";
String secId="";
if(docCategory!=null && !docCategory.equals("")){
   mainId=docCategory.substring(0,docCategory.indexOf(','));
   subId=docCategory.substring(docCategory.indexOf(',')+1,docCategory.lastIndexOf(','));
   secId=docCategory.substring(docCategory.lastIndexOf(',')+1,docCategory.length());
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
<input type=hidden name='stringseldefieldsadd' value=<%=stringseldefieldsadd%>>
<input type=hidden name='mainId' value=<%=mainId%>>
<input type=hidden name='subId' value=<%=subId%>>
<input type=hidden name='secId' value=<%=secId%>>
<input type=hidden id="formid" name='formid' value=<%=formid%>>
<input type=hidden name='isbill' value=<%=isbill%>>
<input type=hidden name="hrmResourceShow" id="hrmResourceShow" value="<%=hrmResourceShow%>">
<%
    int inprepIdTemp=0;
    String inprepfrequenceTemp="";
    rsaddop.executeSql("select inprepId,inprepfrequence  from T_InputReport where billId="+formid);
    if(rsaddop.next()){
		inprepIdTemp=Util.getIntValue(rsaddop.getString("inprepId"),0);
		inprepfrequenceTemp=Util.null2String(rsaddop.getString("inprepfrequence"));
    }
%>
<input type=hidden name='inprepIdTemp' value="<%=inprepIdTemp%>">
<input type=hidden name='inprepfrequenceTemp' value="<%=inprepfrequenceTemp%>">

<%
    Calendar todayTemp = Calendar.getInstance();
    todayTemp.add(Calendar.DATE, -1) ;
    String yearTemp = Util.add0(todayTemp.get(Calendar.YEAR), 4) ;
    String monthTemp = Util.add0(todayTemp.get(Calendar.MONTH) + 1, 2) ;
    String dayTemp = Util.add0(todayTemp.get(Calendar.DAY_OF_MONTH), 2) ;
    String dateTemp = yearTemp + "-" + monthTemp + "-" + dayTemp ;
%>
<input type=hidden name='year' value="<%=yearTemp%>">
<input type=hidden name='month' value="<%=monthTemp%>">
<input type=hidden name='day' value="<%=dayTemp%>">
<input type=hidden name='date' value="<%=dateTemp%>">
<input type=hidden name='currentYearTemp' value="<%=yearTemp%>">
<%

//QC169123
//String managerStr = ResourceComInfo.getManagerID(beagenter);
String managerStr;
//判断是否客户门户
if(user.getLogintype().equals("2")){
    managerStr = CustomerInfoComInfo1.getCustomerInfomanager(beagenter);
}else{
    managerStr = ResourceComInfo.getManagerID(beagenter);
}
if(managerid>0){
%>
<input type='hidden' id='field<%=managerid%>' name='field<%=managerid%>' temptitle='' value='<%=managerStr%>'>
<%
}
//modify by mackjoe at 2006-06-14 td4491 将节点前附加操作移出循环外操作减少数据库访问量



int fieldop1id=0;
ArrayList inoperatefields = new ArrayList();
ArrayList inoperatevalues = new ArrayList();
requestPreAddM.setCreater(user.getUID());
requestPreAddM.setOptor(user.getUID());
requestPreAddM.setWorkflowid(Util.getIntValue(workflowid));
requestPreAddM.setNodeid(Util.getIntValue(nodeid));
Hashtable getPreAddRule_hs = requestPreAddM.getPreAddRule();
inoperatefields = (ArrayList)getPreAddRule_hs.get("inoperatefields");
inoperatevalues = (ArrayList)getPreAddRule_hs.get("inoperatevalues");

String filedid="";
String fieldName="";    
String filedname="";
String url="";
String urllink="";
String fieldvalue="";
String fielddbtype="";
for(int i=0; i<mantablefields.size();i++){
    int htmltype=1;
    int type=1;
    int indx=-1;
    filedid=(String)mantablefields.get(i);
    filedname=(String)mantablefieldlables.get(i);
    fieldvalue=(String)manfieldvalues.get(i);
    int childfieldid_tmp = Util.getIntValue((String)manTableChildFields.get(i), 0);
    url=(String)ManUrlList.get(i);
	String urls = "/systeminfo/Calendar_mode.jsp";
	if(url.indexOf("systeminfo/Calendar.jsp")>0){  //模板模式 单独处理日期控件
	   url= url.replace(url,urls);
	}
    urllink=(String)ManUrlLinkList.get(i);
    indx=filedid.lastIndexOf("_");
    if(indx>0){
        htmltype=Util.getIntValue(filedid.substring(indx+1),1);
        filedid=filedid.substring(0,indx);            
    }
    indx=filedid.lastIndexOf("_");
    if(indx>0){
        type=Util.getIntValue(filedid.substring(indx+1),1);
        filedid=filedid.substring(0,indx);    
    }
    if(htmltype==6){
%>   
    <input type=hidden id="<%=filedid%>_num" name='<%=filedid%>_num' value="0"> 
    <input type=hidden name="<%=filedid%>_idnum" value="0">
    <input type=hidden temptitle="<%=filedname%>" name="<%=filedid%>" value="">
<%
    }else{
        if(htmltype==3){
            if(type==160){
%>
                <input type="hidden" id="resourceRoleId<%=filedid%>" name="resourceRoleId<%=filedid%>" value="-1">
<%
            }
            if(managerid>0 && filedid.equals("field"+managerid)){
%>
<script language="javascript">
	$G("field<%=managerid%>").temptitle="<%=filedname%>";
</script>
<%}else{%>
	<input type="hidden" temptitle="<%=filedname%>" name="<%=filedid%>" value="">
<%}%>
    <input type="hidden" name="<%=filedid%>_url" value="<%=url%>">
    <input type="hidden" name="<%=filedid%>_urllink" value="<%=urllink%>">
<%
       }else if(htmltype==7){
%>
    <input type="hidden" temptitle="<%=filedname%>" name="<%=filedid%>" value="<%=fieldvalue%>">
    <input type="hidden" name="<%=filedid%>_url" value="<%=url%>">
    <input type="hidden" name="<%=filedid%>_urllink" value="<%=urllink%>">
<%
        }else{
        	int pfieldid_tmp = 0;
        	if(manTableChildFields.contains(filedid.substring(5))){
        		String pfieldStr_tmp = (String)mantablefields.get(manTableChildFields.indexOf(filedid.substring(5)));
        		pfieldStr_tmp = pfieldStr_tmp.substring(5, pfieldStr_tmp.indexOf("_"));
        		pfieldid_tmp = Util.getIntValue(pfieldStr_tmp, 0);
			}
%>
	<input type="hidden" id="childField<%=filedid%>" name="childField<%=filedid%>" value="<%=childfieldid_tmp%>">
	<input type="hidden" id="pField<%=filedid%>" name="pField<%=filedid%>" value="<%=pfieldid_tmp%>">
    <input type="hidden" temptitle="<%=filedname%>" name="<%=filedid%>" value="">
<%
        }
    }
    
    String tempfieldid=filedid;
    if(tempfieldid.length()>5) tempfieldid=tempfieldid.substring(5);
    if(selfieldsadd.indexOf(tempfieldid)>=0){
        char flag= Util.getSeparator() ;
        rsaddop.executeSql("select selectvalue from workflow_SelectItem where isdefault = 'y' and fieldid="+tempfieldid);
        if(rsaddop.next()){//默认值 
            fieldvalue = rsaddop.getString("selectvalue");
        }
        int inoperateindex=inoperatefields.indexOf(tempfieldid);
        if(inoperateindex>-1){//如果有节点前附加操作，覆盖原有值。



            fieldvalue = Util.null2String((String)inoperatevalues.get(inoperateindex));
        }
        //bodychangattrstr+="changeshowattrBymode('"+tempfieldid+"_0','"+fieldvalue+"',-1,"+workflowid+","+nodeid+");";
    }
    
 	// TD86150 begin
    String fieldValue = (String) fieldMap.get("field" + tempfieldid);
    if(!"".equals(fieldValue) && fieldValue != null) {
    	fieldvalue = fieldValue;
    }
    // TD86150 end
    
    fieldName=Util.null2String((String)ManTableFieldFieldNames.get(i));
	fielddbtype=Util.null2String((String)ManTableFieldDBTypes.get(i));
	if(fieldName.equals("reportUserId")&&"1".equals(isbill)&&(Util.getIntValue(formid,0)<0)){
%>
    <input type="hidden" name="reportUserIdInputName" value="<%=filedid%>">
<%
	}
	if(fieldName.equals("crmId")&&"1".equals(isbill)&&(Util.getIntValue(formid,0)<0)){
%>
    <input type="hidden" name="crmIdInputName" value="<%=filedid%>">
<%
	}
	if(fieldName.equals("inprepDspDate")&&"1".equals(isbill)&&(Util.getIntValue(formid,0)<0)){
%>
    <input type="hidden" name="inprepDspDateInputName" value="<%=filedid%>">
<%
	}
    if(filedid.length()>5&&changefieldsdemanage.indexOf(filedid.substring(5))>=0){
%>
    <input type="hidden" id="oldfield<%=filedid.substring(5)%>" name="oldfield<%=filedid.substring(5)%>" value="0|0|<%=mantablefields.get(i)%>">
<%
	}
}
%>
<%rsaddop.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-1");
if(rsaddop.next()){//如果在模板中设置了标题，下面的隐含字段作为标题对象保存数据



%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>" name="requestname" id="requestname" value="">
<%}%>
<%rsaddop.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-2");
if(rsaddop.next()){//如果在模板中设置了紧急程度，下面的隐含字段作为紧急程度对象保存数据



%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>" name="requestlevel" id="requestlevel" value="0">
<%}%>
<%rsaddop.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-3");
if(rsaddop.next()){//如果在模板中设置了是否短信提醒，下面的隐含字段作为是否短信提醒保存数据



%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%>" name="messageType" id="messageType" value="0">
<%}%>
<!-- 微信提醒START(QC:98106) -->
<%rsaddop.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-5");
if(rsaddop.next()){//如果在模板中设置了是否微信提醒，下面的隐含字段作为是否短信提醒保存数据



%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%>" name="chatsType" id="chatsType" value="0">
<%}%>
<!-- 微信提醒END(QC:98106) -->
<%rsaddop.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-4");
String hasSign = "0";
if(rsaddop.next()){//如果在模板中设置了签字，下面的隐含字段作为签字对象保存数据



hasSign = "1";
%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>" name="qianzi" id="qianzi" value="">
<input type=hidden temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"  name="remark" id="remark" value="" >
<input type=hidden name="signdocids" value="">
<input type=hidden name='signworkflowids' value="">
<input type=hidden name='field-annexupload_num' value="0">
<input type=hidden name='annexmainId' value="0">
<input type=hidden name='annexsubId' value="0">
<input type=hidden name='annexsecId' value="0">
<%}%>
<input type=hidden name="workflowRequestLogId" value="-1">
<%
for(int i=0; i<detailtablefields.size();i++){
    ArrayList detaillist=new ArrayList();
    ArrayList detaillablelist=new ArrayList();
    ArrayList detailurls=new ArrayList();
    ArrayList detailurllinks=new ArrayList();
    ArrayList detailchildfieldList = new ArrayList();
    int htmltype=1;
    int type=1;
    int indx=-1;
    detaillist=(ArrayList)detailtablefields.get(i);
    detaillablelist=(ArrayList)detailtablefieldlables.get(i);
    detailurls=(ArrayList)DetailUrlList.get(i);
    detailurllinks=(ArrayList)DetailUrlLinkList.get(i);
    detailchildfieldList=(ArrayList)detailTableChildFields.get(i);
%>
    <input type=hidden name="indexnum<%=i%>" id="indexnum<%=i%>" value=0>
    <input type=hidden name="nodesnum<%=i%>" id="nodesnum<%=i%>" value=0>
    <input type=hidden name="totalrow<%=i%>" id="totalrow<%=i%>" value=0>
    <input type=hidden name="submitdtlid<%=i%>" id="submitdtlid<%=i%>" value="">
<%
    for(int j=0;j<detaillist.size();j++){
        filedid=(String)detaillist.get(j);
    		filedname=(String)detaillablelist.get(j);
        url=(String)detailurls.get(j);
		String urls = "/systeminfo/Calendar_mode.jsp";
	if(url.indexOf("systeminfo/Calendar.jsp")>0){  //模板模式 单独处理日期控件
	   url= url.replace(url,urls);
	}
        urllink=(String)detailurllinks.get(j);
        indx=filedid.lastIndexOf("_");
        int dChildField_tmp = Util.getIntValue((String)detailchildfieldList.get(j), 0);
        if(indx>0){
            htmltype=Util.getIntValue(filedid.substring(indx+1),1);
            filedid=filedid.substring(0,indx);            
        }
        indx=filedid.lastIndexOf("_");
        if(indx>0){
            type=Util.getIntValue(filedid.substring(indx+1),1);
            filedid=filedid.substring(0,indx);
            indx=filedid.lastIndexOf("_");
            if(indx>0){
                filedid=filedid.substring(0,indx);
            }
        }
        if(htmltype==6){
%>   
    <input type=hidden id="<%=filedid%>_num" name='<%=filedid%>_num' value="0"> 
    <input type=hidden name="<%=filedid%>_idnum" value="0">
    <input type=hidden temptitle="<%=filedname%>" name="<%=filedid%>" value="">
<%
    }else{
        if(htmltype==3){
%>
    <input type="hidden" temptitle="<%=filedname%>" name="<%=filedid%>" value="">
    <input type="hidden" name="<%=filedid%>_url" value="<%=url%>">
    <input type="hidden" name="<%=filedid%>_urllink" value="<%=urllink%>">
<%
        }else{
        	int pfieldid_tmp = 0;
        	if(detailchildfieldList.contains(filedid.substring(5))){
        		String pfieldStr_tmp = (String)detaillist.get(detailchildfieldList.indexOf(filedid.substring(5)));
        		pfieldStr_tmp = pfieldStr_tmp.substring(5, pfieldStr_tmp.indexOf("_"));
        		pfieldid_tmp = Util.getIntValue(pfieldStr_tmp, 0);
        	}
%>
    <input type="hidden" temptitle="<%=filedname%>" name="<%=filedid%>" value="">
	<input type="hidden" id="childField<%=filedid%>" name="childField<%=filedid%>" value="<%=dChildField_tmp+"_"+i%>">
	<input type="hidden" id="pField<%=filedid%>" name="pField<%=filedid%>" value="<%=pfieldid_tmp+"_"+i%>">
<%
        }
    }
    
    String tempfieldid=filedid;
    if(tempfieldid.length()>5) tempfieldid=tempfieldid.substring(5);
    if(seldefieldsadd.indexOf(tempfieldid)>=0){
        char flag= Util.getSeparator() ;
        rsaddop.executeSql("select selectvalue from workflow_SelectItem where isdefault = 'y' and fieldid="+tempfieldid);
        if(rsaddop.next()){//默认值 
            fieldvalue = rsaddop.getString("selectvalue");
        }
        int inoperateindex=inoperatefields.indexOf(tempfieldid);
        if(inoperateindex>-1){//如果有节点前附加操作，覆盖原有值。



            fieldvalue = Util.null2String((String)inoperatevalues.get(inoperateindex));
        }
        //bodychangattrstr+="changeshowattrBymode('"+tempfieldid+"_"+i+"','',"+i+","+workflowid+","+nodeid+");";
    }
    
 	// TD86150 begin
    String fieldValue = (String) fieldMap.get("field" + tempfieldid);
    if(!"".equals(fieldValue) && fieldValue != null) {
    	fieldvalue = fieldValue;
    }
    // TD86150 end
%>
<input type="hidden" name="temp_<%=filedid%>" value="<%=filedname%>">
<%
    }
}
%>

<span  id=createDocButtonSpan><button id='createdoc' style='display:none' class=AddDoc onclick="createDocForNewTab('','0');return false;"></button></span>

<input type="hidden" name="flowDocField" value="<%=flowDocField%>">
<input type="hidden" name="newTextNodes" value="<%=newTextNodes%>">

<script language=javascript>

//TD4262 增加提示信息  开始



var oPopup = window.createPopup();
//TD4262 增加提示信息  结束

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
            rowgroup[<%=i%>]=endrow-headrow-1;
        }
<%
    }
%>
}
function setmantable(){
    var wcell=frmmain.ChinaExcel;
    try{
    	//标题
    	var temprow1=wcell.GetCellUserStringValueRow("requestname");
    	var tempcol1=wcell.GetCellUserStringValueCol("requestname");
    	if(temprow1>0){
	    	$G("needcheck").value=$G("needcheck").value+",requestname";
	    	if("<%=defaultName%>"=="1"){
		    	wcell.SetCellVal(temprow1,tempcol1,getChangeField("<%=txtuseruse%>"));
	      	    $G("requestname").value="<%=txtuseruse%>";
		    }else{
		    	wcell.SetCellVal(temprow1,tempcol1,"");
	      	$G("requestname").value="";
		    }
		    imgshoworhide(temprow1,tempcol1);
		  }
	    
	    //紧急程度



    	var temprow2=wcell.GetCellUserStringValueRow("requestlevel");
    	var tempcol2=wcell.GetCellUserStringValueCol("requestlevel");
    	if(temprow2>0){
		   	wcell.SetCellComboType1(temprow2,tempcol2,false,true,false,"<%=SystemEnv.getHtmlLabelName(225,Languageid)%>;<%=SystemEnv.getHtmlLabelName(15533,Languageid)%>;<%=SystemEnv.getHtmlLabelName(2087,Languageid)%>","0;1;2");
	      wcell.SetCellVal(temprow2,tempcol2,getChangeField("<%=SystemEnv.getHtmlLabelName(225,Languageid)%>")); 
	      $G("requestlevel").value="0";
		    imgshoworhide(temprow2,tempcol2);
		  }
	    
	    //是否短信提醒
    	var temprow3=wcell.GetCellUserStringValueRow("messageType");
    	var tempcol3=wcell.GetCellUserStringValueCol("messageType");
    	if(temprow3>0){
    		if(<%=tempMessageType%>==1){
		   	wcell.SetCellComboType1(temprow3,tempcol3,false,true,false,"<%=SystemEnv.getHtmlLabelName(17583,Languageid)%>;<%=SystemEnv.getHtmlLabelName(17584,Languageid)%>;<%=SystemEnv.getHtmlLabelName(17585,Languageid)%>","0;1;2");
	        if(<%=smsAlertsType%>==0){
	         wcell.SetCellVal(temprow3,tempcol3,getChangeField("<%=SystemEnv.getHtmlLabelName(17583,Languageid)%>")); 
	         $G("messageType").value="0";
	        }else if(<%=smsAlertsType%>==1){
	         wcell.SetCellVal(temprow3,tempcol3,getChangeField("<%=SystemEnv.getHtmlLabelName(17584,Languageid)%>")); 
	          $G("messageType").value="1";
	        }else if(<%=smsAlertsType%>==2){
	         wcell.SetCellVal(temprow3,tempcol3,getChangeField("<%=SystemEnv.getHtmlLabelName(17585,Languageid)%>")); 
	         $G("messageType").value="2";
	        }
		    imgshoworhide(temprow3,tempcol3);
		    }else{
		        wcell.SetCellProtect(temprow3,tempcol3,temprow3,tempcol3,true);
		    }
		  }
	    //微信提醒START(QC:98106) 
	    //是否微信提醒
    	var temprow5=wcell.GetCellUserStringValueRow("chatsType");
    	var tempcol5=wcell.GetCellUserStringValueCol("chatsType");
    	if(temprow5>0){
    		if(<%=tempChatsType%>==1){
		   	wcell.SetCellComboType1(temprow5,tempcol5,false,true,false,"<%=SystemEnv.getHtmlLabelName(19782,Languageid)%>;<%=SystemEnv.getHtmlLabelName(26928,Languageid)%>","0;1");
	        if(<%=chatsAlertType%>==0){
	         wcell.SetCellVal(temprow5,tempcol5,getChangeField("<%=SystemEnv.getHtmlLabelName(19782,Languageid)%>")); 
	         document.getElementById("chatsType").value="0";
	        }else if(<%=chatsAlertType%>==1){
	         wcell.SetCellVal(temprow5,tempcol5,getChangeField("<%=SystemEnv.getHtmlLabelName(26928,Languageid)%>")); 
	          document.getElementById("chatsType").value="1";
	        } 
		    imgshoworhide(temprow5,tempcol5);
		    }else{
		        wcell.SetCellProtect(temprow5,tempcol5,temprow5,tempcol5,true);
		    }
		  }
		//微信提醒END(QC:98106) 
	    //签字
    	var temprow4=wcell.GetCellUserStringValueRow("qianzi");
    	var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
    	if(temprow4>0){
<%
String isannexUpload=null;
rsaddop.executeSql("select isannexUpload from workflow_base where id="+workflowid);
if(rsaddop.next()){
	isannexUpload = Util.null2String(rsaddop.getString("isannexUpload"));
}
//签字意见，在没有附件和电子签章的情况下不要有浏览框显示在那里。



if(!"1".equals(isFormSignature)&&!"1".equals(isannexUpload)){%>
    		wcell.DeleteCellImage(temprow4,tempcol4,temprow4,tempcol4);
<%
    if("1".equals(isSignMustInput)){	
%>
        wcell.ReadHttpImageFile("/images/BacoError_wev8.gif",temprow4,tempcol4,true,true);
<%
    }
%>
<%}
		if(!"1".equals(isFormSignature)&&"1".equals(isSignMustInput)){
		%>
		var checkfield=$G("needcheck").value;
		$G("needcheck").value=checkfield+",remark";
		<%}%>
		   	$G("qianzi").value="";
		    //imgshoworhide(temprow4,temprow4);
		    imgshoworhide(temprow4,tempcol4);
		  }

		//重新生成编号
    	var temprow5=wcell.GetCellUserStringValueRow("main_createCodeAgain");
    	var tempcol5=wcell.GetCellUserStringValueCol("main_createCodeAgain");
    	if(temprow5>0){
			imghide(temprow5,tempcol5);
    	}
  	}catch(e){}
<%

    for(int i=0; i<mantablefields.size();i++){
        String fid=(String)mantablefields.get(i);
        fieldvalue=(String)manfieldvalues.get(i);
        fielddbtype=Util.null2String((String)ManTableFieldDBTypes.get(i));
        String fvalue="";
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
        String preAdditionalValue = "";
        boolean haspreAdditional=false;
        int inoperateindex=inoperatefields.indexOf(tmpfid.substring(5));
        if(inoperateindex>-1){
            preAdditionalValue = Util.null2String((String)inoperatevalues.get(inoperateindex));
            haspreAdditional=true;
        }
        /*rsaddop.executeSql("select customervalue from workflow_addinoperate where workflowid=" + workflowid + " and ispreadd='1' and isnode = 1 and objid = "+nodeid+" and fieldid = " + tmpfid.substring(5));
        if(rsaddop.next()){
            preAdditionalValue = Util.null2String(rsaddop.getString("customervalue"));
            haspreAdditional=true;
        }*/
        
     	// TD86150 begin
        String fieldValue = (String) fieldMap.get("field" + tmpfid.substring(5));
        if(!"".equals(fieldValue) && fieldValue != null) {
      	  	preAdditionalValue = fieldValue;
      		haspreAdditional = true;
        }
        // TD86150 end
        
%>
        var ismand=wcell.GetCellUserValue(nrow,ncol);
        if(ismand==2){
            var checkfield=$G("needcheck").value;
            $G("needcheck").value=checkfield+",<%=tmpfid%>";
        }
<%
        if(tmpfid.length()>5&&changefieldsdemanage.indexOf(tmpfid.substring(5))>=0){
%>
        if($G("oldfield<%=tmpfid.substring(5)%>")) $G("oldfield<%=tmpfid.substring(5)%>").value="0|"+ismand+"|<%=fid%>";
<%
	}
%>

		var isedit=0;
		if(ismand>=1){
			isedit=1;
		}
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
            ArrayList SelectDefaults=FieldInfo.getSelectDefaults();
             ArrayList SelectCancels=FieldInfo.getSelectCancelValues();
            String Combostr="";
            String selectname="";
            String selvalue="";
            if(hasPfield == false){
	            for(int j=0;j<SelectItems.size();j++){
	                String tmpname=(String)SelectItems.get(j);
	                String selectvalue=(String)SelectItemValues.get(j);
	                String isdefault=(String)SelectDefaults.get(j);
	                  String cancel=(String)SelectCancels.get(j);
	                if(cancel.equals("1")){
	                    continue;
	                }
	                Combostr+=";"+tmpname;
	                selvalue+=";"+selectvalue;
	                if(!haspreAdditional && "".equals(preAdditionalValue)){
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
            }else{
           	%>
           			wcell.SetCellComboType1(nrow,ncol,false,true,false,";;",";;");
           			wcell.SetCellVal(nrow,ncol,"");
           	<%
       					for(int j=0;j<SelectItems.size();j++){
       					    String tmpname=(String)SelectItems.get(j);
       					    String selectvalue=(String)SelectItemValues.get(j);
       					    String isdefault=(String)SelectDefaults.get(j);
       					    if(!haspreAdditional && "".equals(preAdditionalValue)){
       					        if("y".equals(isdefault)){
       					            fvalue=selectvalue;
       					        }
       					    }else{
       					        if(selectvalue.equals(preAdditionalValue)){
       					            fvalue=selectvalue;
       					        }
       					    }
       					}
       					comboInitJsStr += "doInitChildCombo(\""+fid+"\",\""+pField+"\",\""+fvalue+"\");\n";
       	            }
%>
        wcell.SetCellComboType1(nrow,ncol,false,true,false,getChangeField("<%=Util.encodeJS(Combostr)%>"),"<%=selvalue%>");
        wcell.SetCellVal(nrow,ncol,getChangeField("<%=FieldInfo.toExcel(Util.encodeJS(selectname))%>")); 
        $G("<%=tmpfid%>").value="<%=fvalue%>";
<%
        }
        if(htmltype==4){
%>
            wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
            wcell.SetCellCheckBoxType(nrow,ncol);        
<%
            if(preAdditionalValue.equals("1")){
                fvalue="1";
%>
        wcell.SetCellCheckBoxValue(nrow,ncol,true);
        $G("<%=tmpfid%>").value="<%=fvalue%>";
<%
            }
%>
        wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%
        }
        if(htmltype==3){
            String showname="";
            if(!("field"+managerid).equals(tmpfid)){
            if(!haspreAdditional && preAdditionalValue.equals("")){
                if((ftype==8 || ftype==135) && !prjid.equals("")){
                    fvalue=prjid;
                }
                if((ftype==9 || ftype==37) && !docid.equals("")){ //浏览按钮为文档,从前面的参数中获得文档默认值



                    fvalue = docid;
                }
				if((ftype==1 ||ftype==17 ||ftype==165 ||ftype==166) && !hrmid.equals("") &&  body_isagent!=1){ //浏览按钮为人,从前面的参数中获得人默认值



                    fvalue =hrmid;
                }
                if((ftype==1 ||ftype==17 ||ftype==165 ||ftype==166) && !hrmid.equals("") &&  body_isagent==1){ //代理的情况下，浏览按钮为人,从前面的参数中获得人默认值



                    fvalue =beagenter;
                }
                if((ftype==7 || ftype==18) && !crmid.equals("") ){ //浏览按钮为CRM,从前面的参数中获得CRM默认值



                    fvalue = crmid;
                }
				if((ftype==16 || ftype==152 || ftype==171) && !reqid.equals("")){ //浏览按钮为REQ,从前面的参数中获得REQ默认值



                    fvalue = reqid;
                }
                if((ftype==4 ||ftype==57 ||ftype==167 ||ftype==168) && !hrmid.equals("") && body_isagent!=1){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                    fvalue = ResourceComInfo.getDepartmentID(hrmid);
                }
				if((ftype==4 ||ftype==57 ||ftype==167 ||ftype==168) && !hrmid.equals("") && body_isagent==1){ //代理的情况下，浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                    fvalue = ResourceComInfo.getDepartmentID(beagenter);
                }
                if((ftype==164 || ftype==169 || ftype==170 || ftype==194) && !hrmid.equals("") && body_isagent!=1){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
                    fvalue = ResourceComInfo.getSubCompanyID(hrmid);
                }
				if((ftype==164 || ftype==169 || ftype==170 || ftype==194) && !hrmid.equals("") && body_isagent==1){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
                    fvalue = ResourceComInfo.getSubCompanyID(beagenter);
                }
                if((ftype==24 || ftype==278) && !hrmid.equals("")&& body_isagent!=1){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                    fvalue = ResourceComInfo.getJobTitle(hrmid);
                }
                if((ftype==24 || ftype==278) && !hrmid.equals("")&& body_isagent==1){ //代理的情况下，浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                    fvalue = ResourceComInfo.getJobTitle(beagenter);
                }
                if(ftype==32 && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                    fvalue = Util.null2String(request.getParameter("TrainPlanId"));
                }
                if(ftype==2){
                    fvalue=currentdate;
                    showname=currentdate;
                }
				if(ftype==19){
                    fvalue=currenttime.substring(0,5);
                    showname=currenttime.substring(0,5);
                }
            }else{
                fvalue=preAdditionalValue;
                //showname=preAdditionalValue;
            }
        }else{
        	fvalue = managerStr;
        }
            if(!fvalue.equals("")){
                ArrayList tempshowidlist=Util.TokenizerString(fvalue,",");
                if(ftype==2 || ftype==19){
                    //日期,时间
                    showname+=preAdditionalValue;
                }else if(ftype==8 || ftype==135){
                    //项目，多项目
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==1 ||ftype==17 ||ftype==165 ||ftype==166){
                    //人员，多人员
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+",";
                    }
				}else if(ftype==160){
                    //角色人员
                    for(int k=0;k<tempshowidlist.size();k++){
                    	showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==7 || ftype==18){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=CustomerInfoComInfo1.getCustomerInfoname((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==4 || ftype==57){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==164 || ftype==194){
                    //分部，多分部
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==9 || ftype==37){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==23){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==16 || ftype==152 || ftype==171){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==161 || ftype==162){
					//ManTableFieldDBTypes
					Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
                    for(int k=0;k<tempshowidlist.size();k++){
						try{
                            BrowserBean bb=browser.searchById((String)tempshowidlist.get(k));
                            String desc=Util.null2String(bb.getDescription());
                            String name=Util.null2String(bb.getName());							showname+=name+",";
						}catch (Exception e){
						}
                    }                    
                }else{
                    String tablename=BrowserComInfo.getBrowsertablename(""+ftype);
                    String columname=BrowserComInfo.getBrowsercolumname(""+ftype);
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(""+ftype);
                    String sql="select "+columname+" from "+tablename+" where "+keycolumname+" in("+fvalue+")";
                    rsaddop.executeSql(sql);
                    while(rsaddop.next()) {
                        showname +=rsaddop.getString(1)+"," ;
                    }
               }
               if(showname.endsWith(",")){
                    showname=showname.substring(0,showname.length()-1);
               }
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
				rsaddop.executeSql("select a.level_n,a.level2_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="+tmpfid.substring(5)+" and b.nodeid in (select nodeid from workflow_flownode where workflowid="+workflowid+"  ) ");
				if (rsaddop.next()){
					resourceRoleId=rsaddop.getString(1);
					rolelevel_tmp=Util.getIntValue(rsaddop.getString(2), 0);
					resourceRoleId += "a"+rolelevel_tmp;
				}
%>
				$G("resourceRoleId<%=tmpfid%>").value="<%=resourceRoleId%>";
<%
            }
		if(ftype == 34) {//added by wcd 2015-08-24
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
        $G("<%=tmpfid%>").value="<%=fvalue%>";
<%
		} else {
%>
		wcell.SetCellVal(nrow,ncol,getChangeField("<%=FieldInfo.toExcel(Util.encodeJS(showname))%>")); 
        $G("<%=tmpfid%>").value="<%=fvalue%>";
        wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%			
		}
        }
        if(htmltype==7){
%>
        wcell.SetCellVal(nrow,ncol,getChangeField("<%=FieldInfo.toExcel(Util.encodeJS(fieldvalue))%>"));    
        wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%		}		
        if(htmltype == 9){
%>			wcell.SetCellVal(nrow,ncol,'<%=SystemEnv.getHtmlLabelName(126136,user.getLanguage()) %>');    
        	wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);	
<%      }
        if(htmltype!=3 && htmltype!=4 && htmltype!=5 && !preAdditionalValue.equals("")){
%>
        wcell.SetCellVal(nrow,ncol,getChangeField("<%=FieldInfo.toExcel(Util.encodeJS(preAdditionalValue))%>"));
        $G("<%=tmpfid%>").value="<%=preAdditionalValue%>";
<%
        }
%>    
    imgshoworhide(nrow,ncol);
    }else{
<%
        if(htmltype==3 && (ftype==1 ||ftype==17||ftype==165||ftype==166) && !preAdditionalValue.equals("")){
%>    
           $G("<%=tmpfid%>").value="<%=preAdditionalValue%>";
<%
        }	
%>
	}
<%
    }
%>
	try {
		createTags();
	}
	catch(e) {
	}
	<%=comboInitJsStr%>
}

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

	//TD86150 begin
	Set keySet = fieldMap.keySet();
	Iterator it = keySet.iterator();
	int size = inoperatefields.size();
	int maxIndex = size;
	while(it.hasNext()) {
		String key = Util.null2String((String) it.next());
		String valueArr = (String) fieldMap.get(key);
		if(!"".equals(valueArr) && valueArr != null) {
			boolean isExist = false;
	    	for(int j = 0; j < size; j++) {
	    		String fieldid = "field" + Util.null2String((String) inoperatefields.get(j));
	    		if(fieldid.equals(key)) {
%>
					inoperatevalueArray[<%=j%>] = "<%=valueArr %>";
<%
	    			isExist = true;
					break;
	    		}
	    	}
	    	if(!isExist) {
%>
				inoperatefieldArray[<%=maxIndex%>] = "<%=key.substring(5) %>";
				inoperatevalueArray[<%=maxIndex%>] = "<%=valueArr %>";
<%
				maxIndex++;
	    	}
	    }
	}
	// TD86150 end
%>

function setdetailtable(){
	var wcell=frmmain.ChinaExcel;    
<%
    String fid="";
    String fvalue="";
	String dfielddbtype="";
	String fdbname = "";
	String organizationtype = "";
	String organizationid = "";
	String organizationidurl = "";
	String organizationidurllink = "";
    for(int i=0; i<detailtablefields.size();i++){
        ArrayList dfids=(ArrayList)detailtablefields.get(i);
		ArrayList dfielddbtypes=(ArrayList)DetailFieldDBTypes.get(i);
		ArrayList dcfids=(ArrayList)detailTableChildFields.get(i);
		ArrayList ddbfnames =  (ArrayList)DetailDBFieldNames.get(i);

        for(int j=0;j<dfids.size();j++){
            fid=(String)dfids.get(j);
            fvalue = "";
			dfielddbtype = (String)dfielddbtypes.get(j);
			fdbname = (String)ddbfnames.get(j);
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
        String preAdditionalValue = "";
        boolean haspreAdditional=false;
        int inoperateindex=inoperatefields.indexOf(fid.substring(5,fid.indexOf("_")));
        if(inoperateindex>-1){
        		haspreAdditional=true;
            preAdditionalValue = Util.null2String((String)inoperatevalues.get(inoperateindex));
        }
        
        // TD86150 begin
        String fieldValue = (String) fieldMap.get("field" + fid.substring(5,fid.indexOf("_")));
        if(!"".equals(fieldValue) && fieldValue != null) {
        	preAdditionalValue = fieldValue;
      		haspreAdditional = true;
        }
        // TD86150 end
        
		if(fdbname.equals("organizationtype")&&isbill.equals("1")&&(formid.equals("156") ||formid.equals("157") ||formid.equals("158") ||formid.equals("159"))){
			organizationtype = preAdditionalValue;
		}	
		if(fdbname.equals("organizationid")&&isbill.equals("1")&&(formid.equals("156") ||formid.equals("157") ||formid.equals("158") ||formid.equals("159"))){
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
			$G("<%=organizationid%>_url").value = "<%=organizationidurl%>";
			$G("<%=organizationid%>_urllink").value= "<%=organizationidurllink%>";
			var organizationidcol=frmmain.ChinaExcel.GetCellUserStringValueCol("<%=fid%>");
			var organizationidrow=frmmain.ChinaExcel.GetCellUserStringValueRow("<%=fid%>");
		    frmmain.ChinaExcel.SetCellProtect(organizationidrow,organizationidcol,organizationidrow,organizationidcol,false);
		    frmmain.ChinaExcel.SetCellUserStringValue(organizationidrow,organizationidcol,organizationidrow,organizationidcol,"<%=organizationidfid%>");
		    frmmain.ChinaExcel.SetCellVal(organizationidrow,organizationidcol,"");
		    imgshoworhide(organizationidrow,organizationidcol);
		    frmmain.ChinaExcel.SetCellProtect(organizationidrow,organizationidcol,organizationidrow,organizationidcol,true);
		<%
		} 
                if(htmltype==5){
                	boolean hasPfield = false;
                	String pField = "";
                	for(int cx_tmp=0; cx_tmp<dcfids.size(); cx_tmp++){
                		String cField_tmp = Util.null2String((String)dcfids.get(cx_tmp));
                		if(cField_tmp.equals(tmpfid.substring(5, tmpfid.indexOf("_")))){
                			pField = Util.null2String((String)dfids.get(cx_tmp));
                			hasPfield = true;
                			break;
                		}
                	}
                    FieldInfo.getSelectItem(fid,isbill);
                    ArrayList  SelectItems=FieldInfo.getSelectItems();
                    ArrayList SelectItemValues=FieldInfo.getSelectItemValues();
                    ArrayList SelectDefaults=FieldInfo.getSelectDefaults();
                     ArrayList SelectCancels=FieldInfo.getSelectCancelValues();
                    String selectname="";
                    String Combostr="";
                    String selvalue="";
                    for(int n=0;n<SelectItems.size();n++){
                        String tmpname=(String)SelectItems.get(n);
                        String selectvalue=(String)SelectItemValues.get(n);
                        String isdefault=(String)SelectDefaults.get(n);
                        String cancel=(String)SelectCancels.get(n);
                		if(cancel.equals("1")){
                    		continue;
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
                    }//end if(hasPfield == false) else
                }//end if(htmltype==5){
                if(htmltype==4&&preAdditionalValue.equals("1")){
%>
									wcell.SetCellCheckBoxValue(nrow,ncol,true);
<%							}
				if(htmltype==3){
            String showname="";
            if(!haspreAdditional && preAdditionalValue.equals("")){
            	if((ftype==8 || ftype==135) && !prjid.equals("")){
                    fvalue=prjid;
                }
                if((ftype==9 || ftype==37) && !docid.equals("")){ //浏览按钮为文档,从前面的参数中获得文档默认值



                    fvalue = docid;
                }
                if((ftype==1 ||ftype==17 ||ftype==165 ||ftype==166) && !hrmid.equals("") && body_isagent!=1){ //浏览按钮为人,从前面的参数中获得人默认值



                    fvalue =hrmid;
                }
				if((ftype==1 ||ftype==17 ||ftype==165 ||ftype==166) && !hrmid.equals("") && body_isagent==1){ //代理情况下，浏览按钮为人,从前面的参数中获得人默认值



                    fvalue =beagenter;
                }
                if((ftype==7 || ftype==18) && !crmid.equals("")){ //浏览按钮为CRM,从前面的参数中获得CRM默认值



                    fvalue = crmid;
                }
				if((ftype==16 || ftype==152 || ftype==171) && !reqid.equals("")){ //浏览按钮为REQ,从前面的参数中获得REQ默认值



                    fvalue = reqid;
                }
                if((ftype==4 ||ftype==57 ||ftype==167 ||ftype==168) && !hrmid.equals("") && body_isagent!=1){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                    fvalue = ResourceComInfo.getDepartmentID(hrmid);
                }
				if((ftype==4 ||ftype==57 ||ftype==167 ||ftype==168) && !hrmid.equals("") && body_isagent==1){ //代理情况下，浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                    fvalue = ResourceComInfo.getDepartmentID(beagenter);
                }
                if((ftype==164 || ftype==169 || ftype==170 || ftype==194) && !hrmid.equals("") && body_isagent!=1){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
                    fvalue = ResourceComInfo.getSubCompanyID(hrmid);
                }
				 if((ftype==164 || ftype==169 || ftype==170 || ftype==194) && !hrmid.equals("") && body_isagent==1){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
                    fvalue = ResourceComInfo.getSubCompanyID(beagenter);
                }
                if((ftype==24||ftype==278) && !hrmid.equals("") && body_isagent==1){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                    fvalue = ResourceComInfo.getJobTitle(beagenter);
                }
                if((ftype==24||ftype==278) && !hrmid.equals("") && body_isagent!=1){ //代理情况下，浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                    fvalue = ResourceComInfo.getJobTitle(hrmid);
                }
                if(ftype==32 && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                    fvalue = Util.null2String(request.getParameter("TrainPlanId"));
                }
                if(ftype==2){
                    fvalue=currentdate;
                    showname=currentdate;
                }
				if(ftype==19){
                    fvalue=currenttime.substring(0,5);
                    showname=currenttime.substring(0,5);
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
                        showname+=ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==1 ||ftype==17 ||ftype==165 ||ftype==166){
                    //人员，多人员
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==160){
                    //角色人员
                    for(int k=0;k<tempshowidlist.size();k++){
                    	showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+",";
                    }
                }
                else if(ftype==160){
                    //角色人员
                    for(int k=0;k<tempshowidlist.size();k++){
                    	showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+",";
                    }
                }
                else if(ftype==7 || ftype==18){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=CustomerInfoComInfo1.getCustomerInfoname((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==4 || ftype==57){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==164 || ftype==194){
                    //分部
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==9 || ftype==37){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==23){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==16 || ftype==152 || ftype==171){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+",";
                    }
                }else if(ftype==161 || ftype==162){
					//自定义字段



					Browser browser=(Browser)StaticObj.getServiceByFullname(dfielddbtype, Browser.class);
                    for(int k=0;k<tempshowidlist.size();k++){
						try{
                            BrowserBean bb=browser.searchById((String)tempshowidlist.get(k));
                            String desc=Util.null2String(bb.getDescription());
                            String name=Util.null2String(bb.getName());							showname+=name+",";
						}catch (Exception e){
						}
                    }                    
                }
              	//added by alan for td:10814
				else if(ftype==142) {
					//收发文单位



					 for(int k=0;k<tempshowidlist.size();k++){
						 try {
						 	showname += DocReceiveUnitComInfo.getReceiveUnitName(""+tempshowidlist.get(k))+" ";
						 } catch(Exception e) {
							 
						 }
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
                        showname +=rsaddop.getString(1)+"," ;
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
								wcell.SetCellVal(nrow,ncol,getChangeField("<%=FieldInfo.toExcel(Util.encodeJS(preAdditionalValue))%>"));
<%}%>
        imgshoworhide(nrow,ncol);
        }
<%
        }
    }
%>
    
    <%=comboInitDetailJsStr%>
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
            if(!cellvaule.match(/[^0-9\.\-]/)){ //加了一句判断，非数值不需要转换，数值才需要做运算　TD27082
				var tmphead = "";//TD9107 支持负数的运算



				if(cellvaule != null && cellvaule.length >0 && cellvaule.substring(0, 1) == "-"){
					tmphead = "-";
				}
	            //cellvaule=tmphead+cellvaule.replace(/[^0-9\.]/,"");
				cellvaule=cellvaule;
            }
<%
            String tmpfid=cfid;
            int indx=tmpfid.indexOf("_");
            if(indx>0){
                tmpfid=tmpfid.substring(0,indx);
            }
%>
            $G("<%=tmpfid%>").value=cellvaule;
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
<%        ArrayList dfids=(ArrayList)detailtablefields.get(i);
        for(int j=0;j<dfids.size();j++){
             String tmpfid=(String)dfids.get(j);
                String cdfid=tmpfid.substring(0,tmpfid.indexOf("_"));
                int indx=tmpfid.lastIndexOf("_");
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
                        if(!cellvaule.match(/[^0-9\.\-]/)){ //加了一句判断，非数值不需要转换，数值才需要做运算　TD27082
							var tmphead = "";//TD9107 支持负数的运算



							if(cellvaule != null && cellvaule.length >0 && cellvaule.substring(0, 1) == "-"){
								tmphead = "-";
							}
							//cellvaule=tmphead+cellvaule.replace(/[^0-9\.]/,"");
							cellvaule=cellvaule;
						}
                        $G("<%=cdfid%>_"+k).value=cellvaule;
                    }
                }
                }
<%
        }
  }
%>
}


objSubmit="";

    function checkReportData(src){
		var reportUserId="";
		var crmId="";
		var year="";
		var month="";
		var day="";
		var date="";
        if($G("reportUserIdInputName")!=null){
			var reportUserIdInputName=$G("reportUserIdInputName").value;
            reportUserId=$G(reportUserIdInputName).value;
        }
        if($G("crmIdInputName")!=null){
			var crmIdInputName=$G("crmIdInputName").value
		    crmId=$G(crmIdInputName).value;
		}
        if($G("year")!=null){
			year=$G("year").value;
		}
		if($G("month")!=null){
			month=$G("month").value;
		}
		if($G("day")!=null){
			day=$G("day").value;
		}
		if($G("date")!=null){
			date=$G("date").value;
		}
        if(reportUserId=="" || crmId==""){
            checkReportDataReturn(0,"","",src);
        }else{
            StrData="formid=<%=formid%>&reportUserId="+reportUserId+"&crmId="+crmId+"&year="+year+"&month="+month+"&day="+day+"&date="+date+"&src="+src;
            $G("checkReportDataForm").src="checkReportDataForm.jsp?"+StrData;
        }
	}

    function checkReportDataReturn(ret,thedate,dspdate,src){

		if(ret==1||ret==2){
			alert(dspdate+" "+"<%=SystemEnv.getHtmlLabelName(20775,user.getLanguage())%>");
			return false;
		}
		if(src=="save"){
			document.frmmain.src.value='save';
			jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

			contentBox = $G("divFavContent18979");
			showObjectPopup(contentBox)

			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}else if(src=="submit"){
			document.frmmain.src.value='submit';
			jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

			contentBox = $G("divFavContent18978");
			showObjectPopup(contentBox)

			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
			if(objSubmit!=""){
				objSubmit.disabled=true;
			}
		}else if(src=="Affirmance"){
                document.frmmain.src.value='save';
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
				contentBox = $G("divFavContent18979");
				showObjectPopup(contentBox);
                document.frmmain.topage.value="ViewRequest.jsp?isaffirmance=1&reEdit=0&fromFlowDoc=1";
                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                if(objSubmit!=""){
					objSubmit.disabled=true;
				}
		}
	}

	//检测在图形化下会议申请单据开始时间不能大于结束时间start TD11608
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
	//检测在图形化下会议申请单据开始时间不能大于结束时间end
	function checkNodesNum()
	{
		var nodenum = 0;
		try
		{
		<%
		int checkdetailno = 0;
		//
		if(isbill.equals("1"))
		{
			if(formid.equals("7")||formid.equals("156") || formid.equals("157") || formid.equals("158") || formid.equals("159"))
			{
				%>
				
				var rowneed=frmmain.ChinaExcel.GetCellUserStringValueRow("detail0_isneed");
				var head=frmmain.ChinaExcel.GetCellUserStringValueRow("detail0_head");
				var end=frmmain.ChinaExcel.GetCellUserStringValueRow("detail0_end");
			   	var nodesnum = end-head-2;
			   	nodesnum = nodesnum*1;
			   	if(rowneed>0)
			   	{
			   		if(nodesnum>0)
			   		{
			   			nodenum = 0;
			   		}
			   		else
			   		{
			   			nodenum = 1;
			   		}
			   	}
			   	else
			   	{
			   		nodenum = 0;
			   	}
			   	<%
			}
			else
			{
			    //单据
			    rscount.execute("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
			    //System.out.println("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
			    while(rscount.next())
			    {
	   	%>
	   	var rowneed=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=checkdetailno%>_isneed");
		var head=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=checkdetailno%>_head");
		var end=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=checkdetailno%>_end");
	   	var nodesnum = end-head-2;
	   	nodesnum = nodesnum*1;
	   	rowneed = rowneed*1;
	   	if(rowneed>0)
	   	{
	   		if(nodesnum>0)
	   		{
	   			nodenum = 0;
	   		}
	   		else
	   		{
	   			nodenum = '<%=checkdetailno+1%>';
	   		}
	   	}
	   	else
	   	{
	   		nodenum = 0;
	   	}
	   	if(nodenum>0)
	   	{
	   		return nodenum;
	   	}
	   	<%
			   		checkdetailno ++;
			    }
			}
		}
		else
		{
		 	int checkGroupId=0;
		    rscount.execute("select distinct groupId from Workflow_formfield where formid="+formid+" and isdetail='1' order by groupid");
		    while (rscount.next())
		    {
		    	checkGroupId=rscount.getInt(1);
		    	%>
		       	var rowneed=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=checkGroupId%>_isneed");
				var head=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=checkGroupId%>_head");
				var end=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=checkGroupId%>_end");
				var nodesnum = end-head-2;
		       	nodesnum = nodesnum*1;
		       	if(rowneed>0)
		       	{
		       		if(nodesnum>0)
		       		{
		       			nodenum = 0;
		       		}
		       		else
		       		{
		       			nodenum = <%=checkGroupId+1%>;
		       		}
		       	}
		       	else
		       	{
		       		nodenum = 0;
		       	}
		       	if(nodenum>0)
			   	{
			   		return nodenum;
			   	}
		       	<%
		    }
	    }
	    //多明细循环结束



		%>
		}
		catch(e)
		{
			nodenum = 0;
		}
		return nodenum;
	}
    function doSave(){          <!-- 点击保存按钮 -->
    	enableAllmenu();
    	//var nodenum = checkNodesNum();
    	var nodenum = 0;
    	if(nodenum>0)
    	{
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
			displayAllmenu();
    		return false;
    	}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $G("planDoSave").click();
        }catch(e){
            try{
            frmmain.ChinaExcel.EndCellEdit(true);
            }catch(e1){}
            var ischeckok="";
            try{
				if(check_form(document.frmmain, "requestname")){
					if(("<%=formid%>"=="85" || "<%=formid%>"=="163") && "<%=isbill%>"=="1"){
					  if(!checkmeetingtimeok()){
						  ischeckok = "false";
					  } else {
						  ischeckok="true";
					  }	  
					}else{
						ischeckok="true";
					}
				}       
			}catch(e){
			  ischeckok="false";
			}

<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
			 if("1".equals(hasSign)){
	    %>
	     if(ischeckok=="true"){
	        var wcell = frmmain.ChinaExcel;
	        var temprow4=wcell.GetCellUserStringValueRow("qianzi");
       	    var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
       	    <%-- if(wcell.GetCellValue(temprow4,tempcol4) == ""){
       	         alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
       	         ischeckok="false";
       	    } --%>
		  }
	    <%
	      }
		}else{
%>
            if(ischeckok=="true"){
		    }
<%
		}
	}
%>

            if(ischeckok=="true"){
                if(checktimeok()) {
                <%if(isbill.equals("1")&&Util.getIntValue(formid,0)<0){%>
//保存签章数据
<%if("1".equals(isFormSignature)&&"0".equals(hasSign)){%>
	                    if(SaveSignature_save()){
                            checkReportData("save");
	                    }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
							    alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							displayAllmenu();
							return ;
	                    }
<%}else{%>
                        checkReportData("save");
<%}%>
                <%}else{%>
                        document.frmmain.src.value='save';
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

                       //TD4262 增加提示信息  开始



	                   contentBox = $G("divFavContent18979");
                       showObjectPopup(contentBox)
                       //TD4262 增加提示信息  结束

//保存签章数据
<%if("1".equals(isFormSignature)&&"0".equals(hasSign)){%>
	                    if(SaveSignature_save()){
                            //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
							    alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							displayAllmenu();
							return ;
						}
<%}else{%>
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}}%>
                    }
             } else {
             	 displayAllmenu();
             	 return;
             }
        }
	}

	function doSubmit(obj){        <!-- 点击提交 -->
		enableAllmenu();
		var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		displayAllmenu();
    		return false;
    	}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $G("planDoSubmit").click();
        }catch(e){
        try{
            frmmain.ChinaExcel.EndCellEdit(true);
            }catch(e1){}
      //modify by xhheng @20050328 for TD 1703
      //明细部必填check，通过try $G("needcheck")来检查,避免对原有无明细单据的修改



        var ischeckok="";
        try{ 
			if(check_form(document.frmmain,$G("needcheck").value+$G("inputcheck").value)){
				if(("<%=formid%>"=="85" || "<%=formid%>"=="163") && "<%=isbill%>"=="1"){
				  if(!checkmeetingtimeok()){
					  ischeckok = "false";
				  } else {
					  ischeckok="true";
				  }	  
				} else {
					ischeckok="true";
				}
			}       
		}catch(e){
		  ischeckok="false";
		}

<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
			 if("1".equals(hasSign)){
	    %>
	     if(ischeckok=="true"){
	        var wcell = frmmain.ChinaExcel;
	        var temprow4=wcell.GetCellUserStringValueRow("qianzi");
       	    var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
       	    if(wcell.GetCellValue(temprow4,tempcol4) == ""){
       	         alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
       	         ischeckok="false";
       	    }
		  }
	    <%
	      }
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form(document.frmmain,'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>

        if(ischeckok=="true"){
            if(checktimeok()) {
                <%if(isbill.equals("1")&&Util.getIntValue(formid,0)<0){%>
						objSubmit=obj;
<%if("1".equals(isFormSignature)&&"0".equals(hasSign)){%>
	                    if(SaveSignature()){
                            checkReportData("submit");
	                    }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
							    alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							displayAllmenu();
							return ;
	                    }
<%}else{%>
                        checkReportData("submit");
<%}%>

                <%}else{%>
                document.frmmain.src.value='submit';
                     <%--added by xwj for td2104 on 2005-8-1--%>
                <%--$G("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;--%>
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

               //TD4262 增加提示信息  开始



	           contentBox = $G("divFavContent18978");
               showObjectPopup(contentBox)
               //TD4262 增加提示信息  结束

//保存签章数据
<%if("1".equals(isFormSignature)&&"0".equals(hasSign)){%>
	                    if(SaveSignature()){
	                    obj.disabled=true;    
                            //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
							    alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							displayAllmenu();
							return ;
						}
<%}else{%>
						obj.disabled=true;
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}}%>
            }
        } else {
        	displayAllmenu();
        	return;
        }
        }
	}

//TD4262 增加提示信息  开始



//提示窗口
function showObjectPopup(contentBox){

    var iX=document.body.offsetWidth/2-50;
	var iY=document.body.offsetHeight/2+document.body.scrollTop-50; 

	var oPopBody = oPopup.document.body;
    oPopBody.style.border = "1px solid #8888AA";
    oPopBody.style.backgroundColor = "white";
    oPopBody.style.position = "absolute";
    oPopBody.style.padding = "0px";
    oPopBody.style.zindex = 150;

    oPopBody.innerHTML = contentBox.innerHTML;

    oPopup.show(iX, iY, 180, 22, document.body);

}
//TD4262 增加提示信息  结束

function createDocForNewTab(tmpfid,isedit){
  
   if(tmpfid==null||tmpfid==""){
	   return ;
   }

   var fieldbodyid="0";

   if(tmpfid.length>5){
	   fieldbodyid=tmpfid.substring(5);
   }
	var docValue=$G(tmpfid).value;

  	//frmmain.action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docValue;
  	frmmain.action = frmmain.action+"?docView="+isedit+"&docValue="+docValue+"&isFromEditDocument=true";
    frmmain.method.value = "crenew_"+fieldbodyid ;
	frmmain.target="delzw";
	parent.delsave();
	if(check_form(document.frmmain,'requestname')){
      	if($G("needoutprint")) $G("needoutprint").value = "1";//标识点正文



        document.frmmain.src.value='save';
//保存签章数据
<%if("1".equals(isFormSignature)&&"0".equals(hasSign)){%>
	                    if(SaveSignature()){
	                        try{
								jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
							}catch(e){}
                            //附件上传
                        StartUploadAll();
                        checkuploadcompletBydoc();
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
							    alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							return ;
						}
<%}else{%>
                        try{
                            jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
                        }catch(e){}
                        //附件上传
                        StartUploadAll();
                        checkuploadcompletBydoc();
<%}%>
    }
}
function openWindowNoRequestid(urlLink){

  	window.open(urlLink);

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
function doInitDetailChildCombo(field,pField,fvalue){
	try{
		var wcell = $G("ChinaExcel");
		var nrowPar = wcell.GetCellUserStringValueRow(pField);
		var ncolPar = wcell.GetCellUserStringValueCol(pField);
		var selvalue = wcell.GetCellComboSelectedActualValue(nrowPar,ncolPar);
		if(selvalue==null || selvalue==""){
			return;
		}
	    var fieldid = pField.substring(5, pField.indexOf("_"));
	    var childfield = field.substring(5, field.length-4);
		var paraStr = "init=1&fieldid="+fieldid+"&childfield="+childfield+"&isbill=<%=isbill%>&selectvalue="+selvalue+"&rownum=-1&childfieldValue="+fvalue;
		var frm = document.createElement("iframe");
		frm.id = "iframe_"+pField+"_"+field;
		frm.style.display = "none";
	    document.body.appendChild(frm);
		$G("iframe_"+pField+"_"+field).src = "ComboChange.jsp?"+paraStr;
	}catch(e){}
}

</script>
<script language=javascript src="/js/characterConv_wev8.js"></script>
<script language=vbs src="/workflow/mode/loadmode.vbs"></script>
