
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@page import="weaver.formmode.tree.CustomTreeUtil"%>
<%@ page import="weaver.meeting.MeetingBrowser"%>
<%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rset" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="requestPreAddM" class="weaver.workflow.request.RequestPreAddinoperateManager" scope="page" />

<!--yl qc:67452 start-->
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<!--yl qc:67452 end-->
<%
int languagebodyid = user.getLanguage() ;
ArrayList uploadfieldids=new ArrayList();    
HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息

String resourceFieldId = "";
String crmFieldId = "";
String resourceNumFieldId = "";
String crmsNumFieldId = "";

String meetingtype="";
String newfromtime="";
String newendtime="";
String Address="";
String remindTypeNew="";
String remindImmediately="";
String remindBeforeStart = "";
String remindBeforeEnd = "";
String remindHoursBeforeStart = "";
String remindTimesBeforeStart = "";
String remindHoursBeforeEnd = "";
String remindTimesBeforeEnd = "";
 
String repeatdays = "";
String repeatweeks = "";
String rptWeekDays = "";
String repeatmonths = "";
String repeatmonthdays = "";

String caller="";
String crmids02 = "";
String hrmids02 = "";

    String selectInitJsStr = "";
    String initIframeStr = "";

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);

String isSignDoc_add="";
String isSignWorkflow_add="";
String smsAlertsType="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow,smsAlertsType from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
	smsAlertsType=Util.null2String(RecordSet.getString("smsAlertsType"));
}
int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
int maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+secid),5);
int uploadType = 0;
String selectedfieldid = "";
String result = RequestManager.getUpLoadTypeForSelect(Util.getIntValue(workflowid,0));
if(!result.equals("")){
	selectedfieldid = result.substring(0,result.indexOf(","));
	uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
}
boolean isCanuse = RequestManager.hasUsedType(Util.getIntValue(workflowid,0));
if(selectedfieldid.equals("") || selectedfieldid.equals("0")){
 	isCanuse = false;
}

RecordSet.executeSql("select * from workflow_base where id="+workflowid);
if(RecordSet.next()){
	messageType=RecordSet.getInt("messageType");
}
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
ArrayList changefieldsadd=WfLinkageInfo.getChangeField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
String needcheck10404 = "";
String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));
%>

<!-- 单独写签字意见Start ecology8.0 -->
    <%
    //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
    //add by cyril on 2008-09-30 for td:9014
		boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+userid);
		String workflowPhrases[] = new String[RecordSet.getCounts()];
		String workflowPhrasesContent[] = new String[RecordSet.getCounts()];
		int m = 0 ;
		if (isSuccess) {
			while (RecordSet.next()){
				workflowPhrases[m] = Util.null2String(RecordSet.getString("phraseShort"));
				workflowPhrasesContent[m] = Util.toHtml(Util.null2String(RecordSet.getString("phrasedesc")));
				m ++ ;
			}
		}
		//end by cyril on 2008-09-30 for td:9014
		
		String isSignMustInput="0";
		String isHideInput = "0";
		String isFormSignature=null;
		int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
		int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
		RecordSet.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight,issignmustinput from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
		if(RecordSet.next()){
			isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
			formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
			formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
			isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
			if("1".equals(isSignMustInput)){
				needcheck10404 = ",remarkText10404";
			}
			isHideInput = ""+Util.getIntValue(RecordSet.getString("ishideinput"), 0);
		}
		int isUseWebRevision_t = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
		if(isUseWebRevision_t != 1){
		isFormSignature = "";
		}
	String workflowRequestLogId = "";
	String isSignDoc_edit=isSignDoc_add;
	String signdocids = "";
	String signdocname = "";
	String isSignWorkflow_edit = isSignWorkflow_add; 
	String signworkflowids = "";
	String signworkflowname = "";
	
	String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
	String isannexupload_edit = isannexupload_add;
	String annexdocids = "";
	String requestid = "-1";
	
	
	String myremark = "";
	int annexmainId=0;
    int annexsubId=0;
    int annexsecId=0;
    int annexmaxUploadImageSize = 0;
	if("1".equals(isannexupload_add)){
        
        String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
         if("1".equals(isannexupload_add) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
            annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
            annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
            annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
          }
         annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
         if(annexmaxUploadImageSize<=0){
            annexmaxUploadImageSize = 5;
         }
     }
	 
	 
	 
  
 weaver.crm.Maint.CustomerInfoComInfo customerInfoComInfo = new weaver.crm.Maint.CustomerInfoComInfo();
 String usernamenew = "";
	if(user.getLogintype().equals("1"))
		usernamenew = user.getLastname();
	if(user.getLogintype().equals("2"))
		usernamenew = customerInfoComInfo.getCustomerInfoname(""+user.getUID());
	
  weaver.general.DateUtil   DateUtil=new weaver.general.DateUtil();
  String 	txtuseruse=DateUtil.getWFTitleNew(""+workflowid,""+user.getUID(),""+usernamenew,user.getLogintype());

  
  
%>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>

<!-- browser 相关 -->
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
<link rel="stylesheet" type="text/css" href="/workflow/exceldesign/css/excelHtml_wev8.css" />
<!--增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<!--增加提示信息  结束-->
<form name="frmmain" method="post" action="BillMeetingOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="0">
<input type=hidden name="src">
<input type=hidden name="iscreate" value="1">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name ="topage" value="<%=topage%>">
<input type=hidden name="f_weaver_belongto_userid" value=<%=f_weaver_belongto_userid%>>
<input type=hidden name ="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>">
<input type="hidden" name="htmlfieldids">
  <div align="center"><br>
    <font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font> <br>
    <br>
  </div>
  <table class="ViewForm">
    <colgroup> <col width="20%"> <col width="80%"> 
    <tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
    <tr> 
      <td class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
      <td class="fieldvalueClass"> 
        <input type=text class=Inputstyle name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>
        value="<%=Util.toScreenToEdit(txtuseruse,user.getLanguage())%>">
        <span id=requestnamespan>
		
 	<%
		 if(txtuseruse.equals("")){
		%>	
		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		 <%}
		%>
		</span> 
        <input type=radio value="0" name="requestlevel" checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio value="1" name="requestlevel"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
        <input type=radio value="2" name="requestlevel"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
      </td>
    </tr>
    <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
	  <%
	if(messageType == 1){
  %>
  <TR>
	<TD class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
	<td class="fieldvalueClass">
		  <span id=messageTypeSpan></span>
	      <input type=radio value="0" name="messageType" <% if(smsAlertsType.equals("0")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
	      <input type=radio value="1" name="messageType" <% if(smsAlertsType.equals("1")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
	      <input type=radio value="2" name="messageType" <% if(smsAlertsType.equals("2")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
		</td>
  </TR>  	   	
  <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
  <%}%>
    <%
ArrayList fieldids=new ArrayList();
ArrayList fieldlabels=new ArrayList();
ArrayList fieldhtmltypes=new ArrayList();
ArrayList fieldtypes=new ArrayList();
ArrayList fieldnames=new ArrayList();
ArrayList isviews=new ArrayList();
ArrayList isedits=new ArrayList();
ArrayList ismands=new ArrayList();
ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
ArrayList  fieldrealtype =  new ArrayList();
RecordSet.executeSql("SELECT distinct b.viewtype,a.isview,a.isedit,a.ismandatory ,b.fielddbtype, b.id,b.fieldlabel,b.fieldhtmltype,b.type,b.fieldname,b.dsporder from workflow_nodeform a,workflow_billfield b where a.fieldid= b.id and  a.nodeid="+nodeid+" order by b.dsporder,b.id");

while(RecordSet.next()){
	fieldids.add(RecordSet.getString("id"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
	fieldnames.add(RecordSet.getString("fieldname"));
	isviews.add(RecordSet.getString("isview"));
	isedits.add(RecordSet.getString("isedit"));
	ismands.add(RecordSet.getString("ismandatory"));
	fieldviewtypes.add(RecordSet.getString("viewtype"));
	fieldrealtype.add(RecordSet.getString("fielddbtype"));
}

int fieldop1id=0;
String strFieldId=null;
String strCustomerValue=null;
String strManagerId=null;
String strUnderlings=null;
String preAdditionalValue = "";
boolean isSetFlag = false;
String docFlags=(String)session.getAttribute("requestAdd"+user.getUID());
ArrayList inoperatefields=new ArrayList();
ArrayList inoperatevalues=new ArrayList();
requestPreAddM.setCreater(userid);
requestPreAddM.setOptor(userid);
requestPreAddM.setWorkflowid(Util.getIntValue(workflowid));
requestPreAddM.setNodeid(Util.getIntValue(nodeid));
Hashtable getPreAddRule_hs = requestPreAddM.getPreAddRule();
inoperatefields = (ArrayList)getPreAddRule_hs.get("inoperatefields");
inoperatevalues = (ArrayList)getPreAddRule_hs.get("inoperatevalues");

String customervalue = "";
int preAdditionalCount1 =1;
int preAdditionalCount2=0;
String bclick="";
String isbrowisMust = "";
for(int i=0;i<fieldids.size();i++){
	
	String fieldname=(String)fieldnames.get(i);
	String fieldid=(String)fieldids.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String viewtype=(String)fieldviewtypes.get(i);
	
	if("1".equals(viewtype)) continue;//明细忽略
	
	isbrowisMust = "";
	if ("1".equals(isedit)) {
        isbrowisMust = "1";
    }
    
    if ("1".equals(ismand)) {
        isbrowisMust = "2";
    }
	
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fielddbtypes =(String)fieldrealtype.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
    if(fieldname.equalsIgnoreCase("begindate")) newfromdate="field"+fieldid;
    if(fieldname.equalsIgnoreCase("begintime")) newfromtime="field"+fieldid;
    if(fieldname.equalsIgnoreCase("enddate")) newenddate="field"+fieldid;
    if(fieldname.equalsIgnoreCase("endtime")) newendtime="field"+fieldid;
    if(fieldname.equalsIgnoreCase("Address")) Address="field"+fieldid;
    
    if(fieldname.equalsIgnoreCase("remindTypeNew")) remindTypeNew="field"+fieldid;
    if(fieldname.equalsIgnoreCase("remindImmediately")) remindImmediately="field"+fieldid;
    if(fieldname.equalsIgnoreCase("remindBeforeStart")) remindBeforeStart="field"+fieldid;
    if(fieldname.equalsIgnoreCase("remindBeforeEnd")) remindBeforeEnd="field"+fieldid;
    if(fieldname.equalsIgnoreCase("remindHoursBeforeStart")) remindHoursBeforeStart="field"+fieldid;
    if(fieldname.equalsIgnoreCase("remindTimesBeforeStart")) remindTimesBeforeStart="field"+fieldid;
    if(fieldname.equalsIgnoreCase("remindHoursBeforeEnd")) remindHoursBeforeEnd="field"+fieldid;
    if(fieldname.equalsIgnoreCase("remindTimesBeforeEnd")) remindTimesBeforeEnd="field"+fieldid;
    
    if(fieldname.equalsIgnoreCase("repeatdays")) repeatdays="field"+fieldid;
    if(fieldname.equalsIgnoreCase("repeatweeks")) repeatweeks="field"+fieldid;
    if(fieldname.equalsIgnoreCase("rptWeekDays")) rptWeekDays="field"+fieldid;
    if(fieldname.equalsIgnoreCase("repeatmonths")) repeatmonths="field"+fieldid;
    if(fieldname.equalsIgnoreCase("repeatmonthdays")) repeatmonthdays="field"+fieldid;
    
    if(fieldname.equalsIgnoreCase("Caller")) caller="field"+fieldid;
    if(fieldname.equalsIgnoreCase("resources")) hrmids02="field"+fieldid;
    if(fieldname.equalsIgnoreCase("crms")) crmids02="field"+fieldid;
    
    if(fieldname.equalsIgnoreCase("MeetingType")) meetingtype="field"+fieldid; 
    
    if(fieldname.equalsIgnoreCase("resources"))
    {
        resourceFieldId = "field" + fieldid;
    }
    if(fieldname.equalsIgnoreCase("crms"))
    {
        crmFieldId = "field" + fieldid;
    }
    if(fieldname.equalsIgnoreCase("resourcenum"))
    {
        resourceNumFieldId = "field" 	+ fieldid;
    }
	if(fieldname.equalsIgnoreCase("crmsNumber"))
    {
        crmsNumFieldId = "field" + fieldid;
    }
	if(ismand.equals("1"))  needcheck+=",field"+fieldid;   //如果必须输入,加入必须输入的检查中


	preAdditionalValue = "";
	isSetFlag = false;
	int inoperateindex=inoperatefields.indexOf(fieldid);
	if(inoperateindex>-1){
		isSetFlag = true;
		preAdditionalValue = (String)inoperatevalues.get(inoperateindex);
	}
    if( ! isview.equals("1") ) { //不显示即进行下一步循环,除了人力资源字段，应该隐藏人力资源字段，因为人力资源字段有可能作为流程下一节点的操作者

        if(fieldhtmltype.equals("3") && (fieldtype.equals("1") ||fieldtype.equals("17")||fieldtype.equals("165")||fieldtype.equals("166")) && !preAdditionalValue.equals("")){           
           out.println("<input type=hidden name=field"+fieldid+" value="+preAdditionalValue+">");
        }        
        continue ;                  
    }
    if(fieldname.equalsIgnoreCase("remindBeforeStart")||fieldname.equalsIgnoreCase("remindBeforeEnd")||fieldname.equalsIgnoreCase("remindTimesBeforeStart")||fieldname.equalsIgnoreCase("remindTimesBeforeEnd")
    		||fieldname.equalsIgnoreCase("remindHoursBeforeStart")||fieldname.equalsIgnoreCase("remindHoursBeforeEnd")||fieldname.equalsIgnoreCase("remindImmediately"))
	{
    	out.println("<input type=hidden name=field"+fieldid+" value='0'>");
    	continue;
	}
	if(fieldname.equalsIgnoreCase("repeatdays")||fieldname.equalsIgnoreCase("repeatweeks")||fieldname.equalsIgnoreCase("rptWeekDays")||fieldname.equalsIgnoreCase("repeatmonths")||fieldname.equalsIgnoreCase("repeatmonthdays"))
	{
    	out.println("<input type=hidden name=field"+fieldid+" value='0'>");
    	continue;
	}
	if (fieldtype.equals("118")) {
		continue;
	}
   if(isview.equals("1")){
%>

    <tr> 
      <%if(fieldhtmltype.equals("2")){%>
      <td class="fieldnameClass" valign=top><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}else{%>
      <td class="fieldnameClass"><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}%>
      <td class="fieldvalueClass"> 
        <%
	if(fieldhtmltype.equals("1")){
		if(fieldtype.equals("1")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" style="width:50%" value="<%=preAdditionalValue%>">
        <span id="field<%=fieldid%>span"><%if(preAdditionalValue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" style="width:50%" value="<%=preAdditionalValue%>" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))">
        <span id="field<%=fieldid%>span"></span>
        <%}
			}
		}
		else if(fieldtype.equals("2")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" style="width:50%"
		onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" value="<%=preAdditionalValue%>">
        <span id="field<%=fieldid%>span"><%if(preAdditionalValue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{
					RecordSet.executeSql("select customervalue from workflow_addinoperate a ,workflow_billfield b where a.fieldid =b.id and  workflowid="+workflowid+" and objid = "+nodeid+" and b.type = 17");
		rset.executeSql("select customervalue from workflow_addinoperate a ,workflow_billfield b where a.fieldid =b.id and  workflowid="+workflowid+" and objid = "+nodeid+" and b.type = 18");
		if(fieldtype.equals("2")){
		RecordSet.executeSql("select customervalue from workflow_addinoperate a ,workflow_billfield b where a.fieldid =b.id and  workflowid="+workflowid+" and objid = "+nodeid+" and b.type = 17");
		rset.executeSql("select customervalue from workflow_addinoperate a ,workflow_billfield b where a.fieldid =b.id and  workflowid="+workflowid+" and objid = "+nodeid+" and b.type = 18");
		if(rset.next()){
			customervalue = rset.getString("customervalue");
			if(customervalue != null && !"".equals(customervalue)){
			String[] customervalueArray = customervalue.split(",");
			for(int j= 0;j<customervalueArray.length;j++){
				if(null != customervalueArray && !"".equals(customervalueArray)){
					preAdditionalCount2++;
				}
			}
			}
		}
		if(RecordSet.next()){
			customervalue = RecordSet.getString("customervalue");
			preAdditionalCount1 = 0;
			if(customervalue != null && !"".equals(customervalue)){
			String[] customervalueArray = customervalue.split(",");
			for(int j= 0;j<customervalueArray.length;j++){
				if(null != customervalueArray && !"".equals(customervalueArray)){
					preAdditionalCount1++;
				}
			}
			}
		}
	}
				if("".equals(preAdditionalValue)){
					preAdditionalValue =String.valueOf(preAdditionalCount1+preAdditionalCount2);
				}
		%>
        <input type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" style="width:50%" value="<%=preAdditionalValue%>">
        <span id="field<%=fieldid%>span"></span>
        <%}
			}
		}
		else if(fieldtype.equals("3")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" style="width:50%"
		onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" value="<%=preAdditionalValue%>">
        <span id="field<%=fieldid%>span"><%if(preAdditionalValue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" style="width:50%" value="<%=preAdditionalValue%>">
        <span id="field<%=fieldid%>span"></span>
        <%}
			}
		}
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	}
	else if(fieldhtmltype.equals("2")){
		if(isedit.equals("1")){
			%>
			<script>$GetEle("htmlfieldids").value += "field<%=fieldid%>;<%=Util.toScreen(fieldlable,languagebodyid)%>;<%=fieldtype%>,";</script>
				<%
			if(ismand.equals("1")) {%>
        <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))"
		rows="4" cols="40" style="width:80%"><%=preAdditionalValue%></textarea>
        <span id="field<%=fieldid%>span"><%if(preAdditionalValue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span> 
        <%
				needcheck+=",field"+fieldid;
			}else{%>
        <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" rows=4 cols=40 style="width:80%" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))"><%=preAdditionalValue%></textarea>
        <span id="field<%=fieldid%>span"></span>
        <%}
		}
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	}
	else if(fieldhtmltype.equals("3")){
		String url=BrowserComInfo.getBrowserurl(fieldtype);
		String linkurl=BrowserComInfo.getLinkurl(fieldtype);
		String showname = "";
		String showid = "";
		int tmpid = 0;

    if (fieldtype.equals("118")) {
    	//showname ="<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>"+SystemEnv.getHtmlLabelName(2193,user.getLanguage())+"</a>" ;
   
        }
        else
        {

            if((fieldtype.equals("8") || fieldtype.equals("135")) && !prjid.equals("")){       //浏览按钮为项目,从前面的参数中获得项目默认值

                showid = "" + Util.getIntValue(prjid,0);
            }else if((fieldtype.equals("9") || fieldtype.equals("37")) && !docid.equals("")){ //浏览按钮为文档,从前面的参数中获得文档默认值

                showid = "" + Util.getIntValue(docid,0);
            }else if((fieldtype.equals("1") ||fieldtype.equals("17")) && !hrmid.equals("")){ //浏览按钮为人,从前面的参数中获得人默认值

                showid = "" + Util.getIntValue(hrmid,0);
            }else if((fieldtype.equals("7") || fieldtype.equals("18")) && !crmid.equals("")){ //浏览按钮为CRM,从前面的参数中获得CRM默认值

                showid = "" + Util.getIntValue(crmid,0);
            }else if((fieldtype.equals("16") || fieldtype.equals("152") || fieldtype.equals("171")) && !reqid.equals("")){ //浏览按钮为REQ,从前面的参数中获得REQ默认值

                showid = "" + Util.getIntValue(reqid,0);
			}else if(fieldtype.equals("4") && !hrmid.equals("")){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
            }else if(fieldtype.equals("24") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getJobTitle(hrmid),0);
            }else if(fieldtype.equals("32") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"),0);
            }else if(fieldtype.equals("164") && !hrmid.equals("")){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getSubCompanyID(hrmid),0);
            }else if(fieldtype.equals("89")){//浏览按钮为会议类型，会议类型只选择审批流程是该审批工作流的类型
                url += "?approver="+workflowid;
            }else if(fieldtype.equals("269")){//会议提醒方式
            	showname=preAdditionalValue;
                showid=preAdditionalValue;
            }
            if(fieldtype.equals("2")){ //added by xwj for td3130 20051124
                 if(!isSetFlag){
                    showname = currentdate;
                    showid = currentdate;
                }else{
                    showname=preAdditionalValue;
                    showid=preAdditionalValue;
                }
            }
				if(fieldtype.equals("19")){ //added by ben 2008-3-14 默认当前时间
                 if(!isSetFlag){
                    showname = currenttime.substring(0,5);
                    showid = currenttime.substring(0,5);
                }else{
                    showname=preAdditionalValue;
                    showid=preAdditionalValue;
                }
            }
            if(showid.equals("0")) showid = "" ;


            if(isSetFlag){
            showid = preAdditionalValue;//added by xwj for td3308 20051213
           }

            if(fieldtype.equals("2") || fieldtype.equals("19")  )	showname=showid; // 日期时间
            else if(!showid.equals("")){       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                ArrayList tempshowidlist=Util.TokenizerString(showid,",");
                if(fieldtype.equals("8") || fieldtype.equals("135")){
                    //项目，多项目
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("1") ||fieldtype.equals("17")){
                    //人员，多人员
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                        	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                          	{
                        		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                          	}
                        	else
                            	showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("7") || fieldtype.equals("18")){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("4") || fieldtype.equals("57")){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("164")){
                    //分部
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("9") || fieldtype.equals("37")){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){
                        if (fieldtype.equals("9")&&docFlags.equals("1"))
                        {
                        //linkurl="WorkflowEditDoc.jsp?docId=";//维护正文
                         String tempDoc=""+tempshowidlist.get(k);
                       showname+="<a href='#' onlick='createDoc("+fieldid+","+tempDoc+")'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }
                        else
                        {
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+" ";
                        }
                        }
                    }
                }else if(fieldtype.equals("23")){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("16") || fieldtype.equals("152") || fieldtype.equals("171")){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("161")||fieldtype.equals("162")){
					Browser browser=(Browser) StaticObj.getServiceByFullname(fielddbtypes, Browser.class);
                    for(int k=0;k<tempshowidlist.size();k++){
						try{
                            BrowserBean bb=browser.searchById((String)tempshowidlist.get(k));
                            String desc=Util.null2String(bb.getDescription());
                            String name=Util.null2String(bb.getName());
                            String href=Util.null2String(bb.getHref());
                            if(href.equals("")){
                            	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
                            }else{
                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
                            }
						}catch (Exception e){
						}
                    }
                }else if(fieldtype.equals("256") ||fieldtype.equals("257")){
					CustomTreeUtil customTreeUtil=new CustomTreeUtil();
					for(int k=0;k<tempshowidlist.size();k++){
						String name = customTreeUtil.getTreeFieldShowName((String)tempshowidlist.get(k),fielddbtypes);
						try {
		                   showname += name;  
		                   if (showname.lastIndexOf("</a>,") != -1 && showname.lastIndexOf("</a>,") == showname.length() - 5) {
		                       showname = showname.substring(0, showname.length()-1);
		                   }
		                } catch (Exception e) {
		                    e.printStackTrace();
		                }
                    }
					
					
		      
           		}else if(fieldtype.equals("269")){
                	showname = Util.toScreen(MeetingBrowser.getRemindNames(showname, user.getLanguage()),user.getLanguage());
                    
                }else{
                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
                    if(!tablename.equals("") && !columname.equals("") && !keycolumname.equals("")){
	                    String sql="";
	                    if(showid.indexOf(",")==-1){
	                        sql="select "+columname+","+keycolumname+" from "+tablename+" where "+keycolumname+"="+showid;
	                    }else{
	                        sql="select "+columname+","+keycolumname+" from "+tablename+" where "+keycolumname+" in("+showid+")";
	                    }
						
	                    RecordSet.executeSql(sql);
	                    while(RecordSet.next()) {
							if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
			            	{
			            		showname += "<a href='javaScript:openhrm(" + RecordSet.getString(2) + ");' onclick='pointerXY(event);'>" + RecordSet.getString(1) + "</a>&nbsp";
			            	}
							else
								showname += "<a target='_new' href='"+linkurl+RecordSet.getString(2)+"'>"+RecordSet.getString(1)+"</a>&nbsp";
	                    }
                    }
                }
                showname=showname.replaceAll("&nbsp;",",").replace("&nbsp",",");
            }

		if(isedit.equals("1")){
			if ("1".equals(ismand)) {
		        needcheck+=",field"+fieldid;
		    }
			
			if(fieldtype.equals("160")){
                rsaddop.execute("select a.level_n, a.level2_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="+fieldid+" and b.nodeid in (select nodeid from workflow_flownode where workflowid="+workflowid+") ");
				String roleid="";
				int rolelevel_tmp = 0;
				if (rsaddop.next())
				{
				roleid=rsaddop.getString(1);
				rolelevel_tmp=Util.getIntValue(rsaddop.getString(2), 0);
				roleid += "a"+rolelevel_tmp;
				}
			bclick = "onShowResourceRole('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'),'"+roleid+"')";
%>
		<brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>'> </brow:browser>
        <!--
		<button type=button  class=Browser  onclick="onShowResourceRole('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'),'<%=roleid%>')" title="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>"></button>
		-->
		<%
			}else{
			String onPropertyChange = "";
			String sqlwhere123="";
			String hasInput="true";
			String linkUrl="" ;
		%>  
		  <%if(fieldtype.equals("89")){
				bclick = "onShowMeetingBrowser('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'))";
				onPropertyChange = "afterChangeMeetingType("+fieldid+");";
				sqlwhere123=workflowid;
			} else if(fieldname.equalsIgnoreCase("Caller")){
				bclick ="onShowCaller('"+fieldid+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'))";
				hasInput="false";
			}else {
				if(fieldtype.equals("87")||fieldtype.equals("184")){
					linkUrl="/meeting/Maint/MeetingRoom_list.jsp?id=";
				}
				if(fieldtype.equals("2")){
					bclick ="onShowFlowDate('"+fieldid+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'))";
				} else if(fieldtype.equals("19")){
					bclick ="onShowMeetingTime(field"+fieldid+"span,field"+fieldid+",field"+fieldid+".getAttribute('viewtype'))";
				} else {
					if(fieldtype.equals("161")||fieldtype.equals("162")){
						 url+="?type="+fielddbtypes;
					}else if(fieldtype.equals("256")||fieldtype.equals("257")){
						url+="?type="+fielddbtypes+"_"+fieldtype;	
					}
					bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'))";
					if("17".equals(fieldtype) || "18".equals(fieldtype)) { 
						onPropertyChange = "countAttend();";
					}
					if("269".equals(fieldtype)){
						onPropertyChange = "showRemindTime()"; 
					}
				}
			}
		  
		  		if(fieldtype.equals("2")){
				%>
						<button type="button"  class="calendar"" onClick="onShowFlowDate('<%=fieldid%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))"></button>
						<span id="field<%=fieldid%>span"> 
			            <%=Util.toScreen(showname,user.getLanguage())%>
			            <%if(ismand.equals("1") && showname.equals("")){%>
			            <img src="/images/BacoError_wev8.gif" align=absmiddle> 
			            <%		
			    			}%>
			            </span>
				<%
						}else if(fieldtype.equals("19")){
				%>
							<button type="button"  class="calendar" onClick="onWorkFlowShowTime(field<%=fieldid%>span,field<%=fieldid%>,field<%=fieldid%>.getAttribute('viewtype'))"></button>
							<span id="field<%=fieldid%>span"> 
				            <%=Util.toScreen(showname,user.getLanguage())%>
				            <%if(ismand.equals("1") && showname.equals("")){%>
				            <img src="/images/BacoError_wev8.gif" align=absmiddle> 
				            <%		
				    			}%>
				            </span>
				<%
						} else {
			 String compurl = "javascript:getajaxurl(" + fieldtype + ",'','"+sqlwhere123+"')";
					%>
		
		<brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput='<%=hasInput%>' isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%=compurl%>' width="230px" needHidden="false" onPropertyChange='<%=onPropertyChange%>' linkUrl='<%=linkUrl %>'> </brow:browser>
					
        <%			}
			}
        }else {
        	out.print(showname.replace(",","&nbsp;&nbsp;"));
		}%>
        <input type=hidden viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>"  id="field<%=fieldid%>"  name="field<%=fieldid%>" value="<%=showid%>">
        
		
		
        <%}
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
        if(fieldtype.equals("87")||fieldtype.equals("184")){
		String showname11 ="<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>"+SystemEnv.getHtmlLabelName(2193,user.getLanguage())+"</a>" ;
		%>
    	<%="&nbsp;&nbsp;&nbsp;"+Util.toScreen(showname11,user.getLanguage()) %>
		<%
	 }
	  
	  if("remindTypeNew".equalsIgnoreCase(fieldname))
	    {
  	%>
  	<!--================ 提醒时间  ================-->
  		<TR name="remindTimetr1" style="display:" class="Spacing" style="height:1px;">
			<TD class="Line2" colSpan="6"></TD>
		</TR>
		<TR name="remindTimetr1" style="display:">
			<TD class="fieldnameClass" ><%=SystemEnv.getHtmlLabelName(81917,user.getLanguage())%></TD>
			<TD class="fieldvalueClass">
				<INPUT id='remindImmediately' type="checkbox" name="remindImmediately" value="0">
		</TD>
		</TR>
  		<TR name="remindTimetr" style="display:" class="Spacing" style="height:1px;">
			<TD class="Line2" colSpan="6"></TD>
		</TR>
		<TR name="remindTimetr" style="display:">
			<TD class="fieldnameClass" ><%=SystemEnv.getHtmlLabelName(785,user.getLanguage())%></TD>
			<TD class="fieldvalueClass">
				<INPUT id='remindBeforeStart' type="checkbox" name="remindBeforeStart" value="0">
					<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
					<INPUT id='remindHoursBeforeStart' class="InputStyle" type="input" name="remindHoursBeforeStart" onchange="checkint('remindHoursBeforeStart')" size=5 value="0">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT id='remindTimesBeforeStart' class="InputStyle" type="input" name="remindTimesBeforeStart" onchange="checkint('remindTimesBeforeStart')" size=5 value="0">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				<br>
				<INPUT id='remindBeforeEnd' type="checkbox" name="remindBeforeEnd" value="0">
					<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
					<INPUT id='remindHoursBeforeEnd' class="InputStyle" type="input" name="remindHoursBeforeEnd" onchange="checkint('remindHoursBeforeEnd')" size=5 value="0">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT id='remindTimesBeforeEnd' class="InputStyle" type="input" name="remindTimesBeforeEnd" onchange="checkint('remindTimesBeforeEnd')"  size=5 value="0">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
		</TD>
		</TR>
			
  	<%
  	}
	  
	}
	else if(fieldhtmltype.equals("4")){
	%>
        <input type=checkbox viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" value=1 <%if(preAdditionalValue.equals("1")){%> checked<%}%> name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> >
        <%
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
        }
    else if(fieldhtmltype.equals("5")){
    
    	
    	String otherEvent= "";
    	
    	if("repeatType".equals(fieldname)){
    		otherEvent = "changeRepeatType(this);";
    	}
    	
    	if("remindType".equals(fieldname))
	    {
    		otherEvent = "showRemindTime(this);";
	    }

	    //yl 67452   start
            String uploadMax = "";
            if(fieldid.equals(selectedfieldid)&&uploadType==1)
            {
                uploadMax = "changeMaxUpload('field"+fieldid+"');reAccesoryChanage();";
            }
            //处理select字段联动
            String onchangeAddStr = "";
            int childfieldid_tmp = 0;
                rs.execute("select childfieldid from workflow_billfield where id="+fieldid);
            if(rs.next()){
                childfieldid_tmp = Util.getIntValue(rs.getString("childfieldid"), 0);
            }
            int firstPfieldid_tmp = 0;
            boolean hasPfield = false;
            rs.execute("select id from workflow_billfield where childfieldid="+fieldid);
            while(rs.next()){
                firstPfieldid_tmp = Util.getIntValue(rs.getString("id"), 0);
                if(fieldids.contains(""+firstPfieldid_tmp)){
                    hasPfield = true;
                    break;
                }
            }
            if(childfieldid_tmp != 0){//如果先出现子字段，则要把子字段下拉选项清空
                onchangeAddStr = " onchange = '" +  "$changeOption(this, "+fieldid+", "+childfieldid_tmp+");'";
            }

            //yl 67452   end

	%>
        <script>
            function funcField<%=fieldid%>(){
                changeshowattr('<%=fieldid%>_0',$GetEle('field<%=fieldid%>').value,-1,'<%=workflowid%>','<%=nodeid%>');
            }
            //window.attachEvent("onload", funcField<%=fieldid%>);
			if (window.addEventListener){
        	    window.addEventListener("load", funcField<%=fieldid%>, false);
        	}else if (window.attachEvent){
        	    window.attachEvent("onload", funcField<%=fieldid%>);
        	}else{
        	    window.onload=funcField<%=fieldid%>;
        	}
        </script>
    <%if("repeatType".equals(fieldname)){ %>
        <select id="repeatType" class=inputstyle viewtype="<%=ismand%>"   <%=onchangeAddStr%>      temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> onBlur="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%if(selfieldsadd.indexOf(fieldid)>=0){ %> onChange="<%=otherEvent %>changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}else{%> onChange="<%=otherEvent %>"<%}%>>
	<%} else if("remindType".equals(fieldname)){ %>
        <select id="remindType" class=inputstyle viewtype="<%=ismand%>"   <%=onchangeAddStr%>      temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> onBlur="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%if(selfieldsadd.indexOf(fieldid)>=0){ %> onChange="<%=otherEvent %>changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}else{%> onChange="<%=otherEvent %>"<%}%>>
	<%} else { %>
		<select id="field<%=fieldid%>" class=inputstyle viewtype="<%=ismand%>"   <%=onchangeAddStr%>      temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> onBlur="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%if(selfieldsadd.indexOf(fieldid)>=0){ %> onChange="<%=otherEvent %>changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}else{%> onChange="<%=otherEvent %>"<%}%>>
	<%}%>
	      <option value=""></option>
	<% 
	char flag=2;
	rs.executeProc("workflow_selectitembyid_new",""+fieldid+flag+"1");
	boolean checkempty = true;
	String nodefaultV="";
	String finalvalue = "";
        //yl 67452   start
    if(hasPfield == false){
	    while(rs.next()){
            String tmpselectvalue = rs.getString("selectvalue");
            String tmpselectname = rs.getString("selectname");
            String isdefault = Util.toScreen(rs.getString("isdefault"),user.getLanguage());
            nodefaultV="".equals(nodefaultV)?tmpselectvalue:nodefaultV;
            if("".equals(preAdditionalValue)){
                if("y".equals(isdefault)){
                    checkempty = false;
                    finalvalue = tmpselectvalue;
                }
            }
            else{
                if(tmpselectvalue.equals(preAdditionalValue)){
                    checkempty = false;
                    finalvalue = tmpselectvalue;
                }
        }

	%>
	<option value="<%=tmpselectvalue%>" <%if("".equals(preAdditionalValue)){if("y".equals(isdefault)){%>selected<%}}else{if(tmpselectvalue.equals(preAdditionalValue)){%>selected<%}}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
	<%
            }
        }else{
        while(rs.next()){
            String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
            String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
            nodefaultV="".equals(nodefaultV)?tmpselectvalue:nodefaultV;
            if(tmpselectvalue.equals(preAdditionalValue)){
                checkempty = false;
                finalvalue = tmpselectvalue;
            }
    %>
            <option value="<%=tmpselectvalue%>" <%if(preAdditionalValue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
            <%
                    }
                    selectInitJsStr += "doInitChildSelect("+fieldid+","+firstPfieldid_tmp+",\""+finalvalue+"\");\n";
                    initIframeStr += "<iframe id=\"iframe_"+firstPfieldid_tmp+"_"+fieldid+"_00\" frameborder=0 scrolling=no src=\"\"  style=\"display:none\"></iframe>";
    }

                //yl 67452   end
    %>

	</select>
	<span id="field<%=fieldid%>span"><%if(ismand.equals("1") && checkempty) {%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%} %></span>
        <%if(isedit.equals("0")){%>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=checkempty?nodefaultV:finalvalue%>" >
        <%}%>
        <%
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
    	if("repeatType".equalsIgnoreCase(fieldname))
	    {
    	%>
    	<!--================ 提醒时间  ================-->
    	</TD>
		</TR>
    	<TR id="repeattr" style="display:none"  class="Spacing" style="height:1px;">
			<TD class="Line2" colSpan="6"></TD>
		</TR>
		<TR id="dayrepeat" style="display:none">
		  <TD class="fieldnameClass"> 
			<!--重复间隔 -->
			<%=SystemEnv.getHtmlLabelName(25898,user.getLanguage())%>
		  </TD>
		  <TD class="fieldvalueClass"> 
			<input class=inputstyle type=text name="repeatdays" id="repeatdays" size=5  value="1" onBlur="checkcount1(this);checkinput('repeatdays','repeatdaysSpan')" />
			<span name="repeatdaysSpan" id="repeatdaysSpan"></span>&nbsp;<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
		  </TD>
		</TR>

		<TR id="weekrepeat" style="display:none">
		  <TD class="fieldnameClass"> 
			<!--重复间隔 -->
			<%=SystemEnv.getHtmlLabelName(25898,user.getLanguage())%>
		  </TD>
		  <TD class="fieldvalueClass"> 
			<%=SystemEnv.getHtmlLabelName(21977,user.getLanguage())%>&nbsp;
			<input class=inputstyle type=text name="repeatweeks" id="repeatweeks" size=5  value="1" onBlur="checkcount1(this);checkinput('repeatweeks','repeatweeksSpan')" />
			<span name="repeatweeksSpan" id="repeatweeksSpan"></span>&nbsp;<%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%><br>
			
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="1">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16100,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="2">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16101,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="3">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16102,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="4">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16103,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="5">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16104,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="6">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16105,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="7">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16106,user.getLanguage())%>
			
		  </TD>
		</TR>
		

		<TR id="monthrepeat"  style="display:none">
		  <TD class="fieldnameClass"> 
			<!--重复间隔 -->
			<%=SystemEnv.getHtmlLabelName(25898,user.getLanguage())%>
		  </TD>
		  <TD class="fieldvalueClass"> 
		    <%=SystemEnv.getHtmlLabelName(21977,user.getLanguage())%>&nbsp;
			<input class=inputstyle type=text name="repeatmonths" id="repeatmonths" size=5  value="1" onBlur="checkcount1(this);checkinput('repeatmonths','repeatmonthsSpan')" />
			<span name="repeatmonthsSpan" id="repeatmonthsSpan"></span>&nbsp;<%=SystemEnv.getHtmlLabelName(25901,user.getLanguage())%>&nbsp;
			<input class=inputstyle type=text name="repeatmonthdays" id="repeatmonthdays" size=5  value="1" onBlur="checkcount1(this);checkinput('repeatmonthdays','repeatmonthdaysSpan')" />
			<span name="repeatmonthdaysSpan" id="repeatmonthdaysSpan"></span>&nbsp;<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
		  
    	<%
    	}
    }
        //add by myq @20080310 for 附件上传
       else if(fieldhtmltype.equals("6")){
            String mainId="";
            String subId="";
            String secId="";
          if(docCategory!=null && !docCategory.equals("")){
            mainId=docCategory.substring(0,docCategory.indexOf(','));
            subId=docCategory.substring(docCategory.indexOf(',')+1,docCategory.lastIndexOf(','));
            secId=docCategory.substring(docCategory.lastIndexOf(',')+1,docCategory.length());
          }
          String picfiletypes="*.*";
          String filetypedesc="All Files";
          if(fieldtype.equals("2")){
              picfiletypes=BaseBean.getPropValue("PicFileTypes","PicFileTypes");
              filetypedesc="Images Files";
          }
          if(isedit.equals("1")){
                boolean canupload=true;
                if(uploadType == 0){if("".equals(mainId) && "".equals(subId) && "".equals(secId)){
                    canupload=false;
            %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}}else if(!isCanuse){
               canupload=false;
           %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}
           if(canupload){
               uploadfieldids.add(fieldid);
           %>
            <script>
          var oUpload<%=fieldid%>;
          function fileupload<%=fieldid%>() {
          var b_i_url_1="/images/ecology8/workflow/fileupload/begin1_wev8.png";
          var b_w_1=104;
          if ("<%=user.getLanguage()%>" == "8"){
		  	b_i_url_1="/images/ecology8/workflow/fileupload/begin1_wev8-2.png";
		  	b_w_1=144;
		  }
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId": "<%=mainId%>",
                "subId":"<%=subId%>",
                "secId":"<%=secId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>",
                "workflowid":"<%=workflowid%>"
            },
            file_size_limit :"<%=maxUploadImageSize%> MB",
            file_types : "<%=picfiletypes%>",
            file_types_description : "<%=filetypedesc%>",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgress<%=fieldid%>",
                cancelButtonId : "btnCancel<%=fieldid%>",
                uploadspan : "field<%=fieldid%>span",
                uploadfiedid : "field<%=fieldid%>"
            },
            debug: false,
            button_image_url : b_i_url_1,
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldid%>",
            button_width: b_w_1,
            button_height: 26,
            
            button_text_top_padding: 0,
            button_text_left_padding: 18,
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,

            // The event handler functions are defined in handlers.js
            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : fileDialogComplete_1,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete    // Queue plugin event
        };


        try {
            oUpload<%=fieldid%>=new SWFUpload(settings);
        } catch(e) {
        	top.Dialog.alert(e)
        }
    }
        	//window.attachEvent("onload", fileupload<%=fieldid%>);
        	if (window.addEventListener) {
       	    	window.addEventListener("load", fileupload<%=fieldid%>, false);
        	} else if (window.attachEvent) {
       	    	window.attachEvent("onload", fileupload<%=fieldid%>);
            } else {
       	    	window.onload=fileupload<%=fieldid%>;
            }
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2">
              		<div>
                   <span id="uploadspan" style="display:inline-block;line-height: 32px;"><%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>
                    </span>
                    <%
					if(ismand.equals("1")){
					%>
					<span id="field<%=fieldid%>span" style='display:inline-block;line-height: 32px;color:red;font-weight:normal;'><%=SystemEnv.getHtmlLabelName(81909,user.getLanguage())%></span>
					<%
					}
				   	%>
                  </div>
                  <div style="height: 30px;">
                  <div style="float:left;">
                  <span>
                     <span id="spanButtonPlaceHolder<%=fieldid%>"></span><!--选取多个文件-->
                     </span>
                  </div>
                
                 <div style="width:10px!important;height:3px;float:left;"></div>
				 <div style="height: 30px;float:left;">
                  <button type="button" id="btnCancel<%=fieldid%>" disabled="disabled" style="height:25px;text-align:center;vertical-align:middle;line-height:23px;background-color: #dfdfdf;color:#999999;padding:0 10px 0 4px;" onclick="clearAllQueue(oUpload<%=fieldid%>);showmustinput(oUpload<%=fieldid%>);" onmouseover="changebuttonon(this)" onmouseout="changebuttonout(this)"><img src='/images/ecology8/workflow/fileupload/clearallenable_wev8.png' style="width:20px;height:20px;" align=absMiddle><%= SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></button>
		                <span id="field<%=fieldid%>spantest" style="display:none;">
						<%
						if(ismand.equals("1")){
						needcheck+=",field"+fieldid;
						%>
					   	<img src='/images/BacoError_wev8.gif' align=absMiddle> 
					  	<%
							}
					   	%>
			    	 	</span>
                  </div>
	              <div style="clear:both;"></div>
	              </div>
                  <input  class=InputStyle  type=hidden size=60 id="field<%=fieldid%>" name="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>"  viewtype="<%=ismand%>">
              </td>
          </tr>
          <tr>
              <td colspan="2">
               <div class="_uploadForClass">
                  <div class="fieldset flash" id="fsUploadProgress<%=fieldid%>">
                  </div>
               </div>
                  <div id="divStatus<%=fieldid%>"></div>
              </td>
          </tr>
      </TABLE>
            <%}%>

    <!-- yl qc:67452 start-->
    <%=initIframeStr%>
    <!-- yl qc:67452 end-->
          <input type=hidden name='mainId' value=<%=mainId%>>
          <input type=hidden name='subId' value=<%=subId%>>
          <input type=hidden name='secId' value=<%=secId%>>
      <%
              }
       }
       else if(fieldhtmltype.equals("7")){//特殊字段
 			out.println(Util.null2String((String)specialfield.get(fieldid+"_1")));
       }
%>
      </td>
    </tr>
    <tr class="Spacing" style="height:1px;">
      <td class="Line2" colspan=2></td>
    </tr>
    <%
   }
}
%>    	  
	</table>
	<jsp:include page="WorkflowAddRequestDetailBody.jsp" flush="true">
		<jsp:param name="workflowid" value="<%=workflowid%>" />
		<jsp:param name="nodeid" value="<%=nodeid%>" />
		<jsp:param name="formid" value="<%=formid%>" />
        <jsp:param name="detailsum" value="<%=0%>"/>
        <jsp:param name="isbill" value="<%=isbill%>"/>
        <jsp:param name="currentdate" value="<%=currentdate%>" />
		<jsp:param name="currenttime" value="<%=currenttime%>" />
        <jsp:param name="needcheck" value="<%=needcheck%>" />
		<jsp:param name="prjid" value="<%=prjid%>" />
		<jsp:param name="reqid" value="<%=reqid%>" />
		<jsp:param name="docid" value="<%=docid%>" />
		<jsp:param name="hrmid" value="<%=hrmid%>" />
		<jsp:param name="crmid" value="<%=crmid%>" />
		<jsp:param name="fieldUrl" value='<%="" %>' />
  </jsp:include>
	 <div id="otherdata" style="display:none;">
  	</div>
  

 
  <input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">
	<%@ include file="/workflow/request/WorkflowSignInput.jsp" %>
	<!-- 单独写签字意见End ecology8.0 -->
</form>
	
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script language="JavaScript" src="/js/workflow/wfbrow_wev8.js" ></script>
<script language=javascript>
	function addannexRow(accname)
  {
    $GetEle(accname+'_num').value=parseInt($GetEle(accname+'_num').value)+1;
    ncol = $GetEle(accname+'_tab').cols;
    oRow = $GetEle(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1);
      oCell.style.height=24;
      switch(j) {
        case 1:
          var oDiv = document.createElement("div");
          var sHtml = "";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
        case 0:
          var oDiv = document.createElement("div");
          <%----- Modified by xwj for td3323 20051209  ------%>
          var sHtml = "<input class=InputStyle  type=file size=60 name='"+accname+"_"+$GetEle(accname+'_num').value+"' onchange='accesoryChanage(this)'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }
	function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;
        fileLenth= File.getFileSize();
    } catch (e){
        //alert('<%=SystemEnv.getHtmlLabelName(20253,user.getLanguage())%>');
		if(e.message=="<%=SystemEnv.getHtmlLabelName(83411,user.getLanguage())%>"||e.message=="<%=SystemEnv.getHtmlLabelName(83411,user.getLanguage())%>"){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
		}else{
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if (fileLenthByM><%=maxUploadImageSize%>) {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    //var  newObj = document.createElement("input");
    //newObj.name=objName;
    //newObj.className="InputStyle";
    //newObj.type="file";
    //newObj.size=70;
    //newObj.onchange=function(){accesoryChanage(this);};

    //var objParentNode = obj.parentNode;
    //var objNextNode = obj.nextSibling;
    //obj.removeNode();
    //objParentNode.insertBefore(newObj,objNextNode);
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=60 >";  
    $GetEle(objName).outerHTML=outerHTML;       
    $GetEle(objName).onchange=tempObjonchange;
}

function countAttend()
{
	try{
		var count = 0;	
		
		if("" != $GetEle("<%= resourceFieldId %>").value)
		{
			countArray = $GetEle("<%= resourceFieldId %>").value.split(",");
			for(var i = 0; i < countArray.length; i++)
			{
				count++;
			}
		}

		if($GetEle("<%= resourceNumFieldId %>span") != undefined)
		{
			$GetEle("<%= resourceNumFieldId %>span").innerHTML = "";
		}
		if($GetEle("<%= resourceNumFieldId %>") != undefined)
		{
			$GetEle("<%= resourceNumFieldId %>").value = count;
		}
		
		var countCrm = 0;	
		
		if("" != $GetEle("<%= crmFieldId %>").value)
		{
			countArray = $GetEle("<%= crmFieldId %>").value.split(",");
			for(var i = 0; i < countArray.length; i++)
			{
					countCrm++;
			}
		}
		
		if($GetEle("<%= crmsNumFieldId %>span") != undefined)
		{
			$GetEle("<%= crmsNumFieldId %>span").innerHTML = "";
		}
		if($GetEle("<%= crmsNumFieldId %>") != undefined)
		{
			$GetEle("<%= crmsNumFieldId %>").value = countCrm;
		}
	}catch(e){};
}

function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{  
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
    return false;
    else{
        if(YearTo==YearFrom){
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


function checktimeok(){
   if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && $GetEle("frmmain").<%=newenddate%>.value != ""){
			YearFrom=$GetEle("frmmain").<%=newfromdate%>.value.substring(0,4);
			MonthFrom=$GetEle("frmmain").<%=newfromdate%>.value.substring(5,7);
			DayFrom=$GetEle("frmmain").<%=newfromdate%>.value.substring(8,10);
			YearTo=$GetEle("frmmain").<%=newenddate%>.value.substring(0,4);
			MonthTo=$GetEle("frmmain").<%=newenddate%>.value.substring(5,7);
			DayTo=$GetEle("frmmain").<%=newenddate%>.value.substring(8,10);
			// window.alert(YearFrom+MonthFrom+DayFrom);
            if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
                return false;
  			 }else{
                if($GetEle("frmmain").<%=newenddate%>.value==$GetEle("frmmain").<%=newfromdate%>.value && $GetEle("frmmain").<%=newendtime%>.value<$GetEle("frmmain").<%=newfromtime%>.value){
                	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
                    return false;
                }
            }
  }
     return true; 
}

var checkroom = 0;
 

function submitChkMbr(obj){
	 if(<%=meetingSetInfo.getMemberConflictChk()%> == 1 ){
		var hrmids02 = $GetEle("<%=hrmids02%>") ? $GetEle("<%=hrmids02%>").value:"";
		var crmids02 = $GetEle("<%=crmids02%>") ? $GetEle("<%=crmids02%>").value:"";
  		jQuery.post("/meeting/data/AjaxMeetingOperation.jsp?method=chkMember",{hrmids:hrmids02,crmids:crmids02,begindate:$GetEle("frmmain").<%=newfromdate%>.value,begintime:$GetEle("frmmain").<%=newfromtime%>.value,enddate:$GetEle("frmmain").<%=newenddate%>.value,endtime:$GetEle("frmmain").<%=newendtime%>.value},function(datas){
				var dataObj=null;
				if(datas != ''){
					dataObj=eval("("+datas+")");
				}
				if(wuiUtil.getJsonValueByIndex(dataObj, 0) == "0"){
					submitact();
				} else {
					<%if(meetingSetInfo.getMemberConflict() == 1){ %>
			            Dialog.confirm(wuiUtil.getJsonValueByIndex(dataObj, 1)+"<%=SystemEnv.getHtmlLabelName(32873,user.getLanguage())%>?", function (){
			                submitact();
			            }, function () {obj.disabled=false;}, 400, 150 ,false);
		            <%} else if(meetingSetInfo.getMemberConflict() == 2) {%>
		            	Dialog.alert(wuiUtil.getJsonValueByIndex(dataObj, 1)+"<%=SystemEnv.getHtmlLabelName(32874,user.getLanguage())%>" ,null ,400 ,150);
		            	obj.disabled=false;
						return;
		            <%}%>
				} 
			});
       } else {
       		submitact();
       }
}

function submitact(){
	 jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
            
	//增加提示信息  开始 meiYQ 2007.10.19 start
		var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
		showPrompt(content);
	//增加提示信息  结束 meiYQ 2007.10.19 end
	setRemindData();
	setRepeatdata()
	//附件上传
	StartUploadAll();
	checkuploadcomplet();
}

function setRemindData()
{
	try{
	//有提醒, 才进行相关计算
	if(jQuery("#<%=remindTypeNew%>").length==0){
		return ;
	}
	
	var remindType = jQuery("#<%=remindTypeNew%>").val();
	if(remindType ==''){
		return true;
	}
	var remindImmediately = $GetEle("remindImmediately");
	var remindBeforeStart = $GetEle("remindBeforeStart");
	var remindHoursBeforeStart = $GetEle("remindHoursBeforeStart");
	var remindTimesBeforeStart = $GetEle("remindTimesBeforeStart");
	var remindBeforeEnd = $GetEle("remindBeforeEnd");
	var remindHoursBeforeEnd = $GetEle("remindHoursBeforeEnd");
	var remindTimesBeforeEnd = $GetEle("remindTimesBeforeEnd");
	//判断"立即提醒" 是否勾选

	if(remindImmediately && remindImmediately.checked) {
		remindImmediately.value = 1;
	} else if(remindImmediately&&!remindImmediately.checked) {
		remindImmediately.value = 0;
	}
	//判断"开始前(提醒)" 是否勾选

	if(remindBeforeStart && remindBeforeStart.checked) {
		remindBeforeStart.value = 1;
	} else if(remindBeforeStart&&!remindBeforeStart.checked) {
		remindBeforeStart.value = 0;
		//如果"开始前(提醒)" 不勾选, 则将 开始前小时和分钟值将无意义, 故都置为0
		if(remindHoursBeforeStart) {
			remindHoursBeforeStart.value=0;
		}
		if(remindTimesBeforeStart) {
			remindTimesBeforeStart.value=0;
		}
	}
	//判断"结束前(提醒)" 是否勾选

	if(remindBeforeEnd && remindBeforeEnd.checked) {
		remindBeforeEnd.value = 1;
	} else if(remindBeforeEnd && !remindBeforeEnd.checked) {
		remindBeforeEnd.value = 0;
		//如果"结束前(提醒)" 不勾选, 则将 结束前小时和分钟值将无意义, 故都置为0
		if(remindHoursBeforeEnd) {
			remindHoursBeforeEnd.value=0;
		}
		if(remindTimesBeforeEnd) {
			remindTimesBeforeEnd.value=0;
		}
	}
<% if(!remindImmediately.equals("")){%>
if ($GetEle("<%=remindImmediately%>") && remindImmediately) $GetEle("<%=remindImmediately%>").value = remindImmediately.value;
<%}%>
<% if(!remindBeforeStart.equals("")){%>
if ($GetEle("<%=remindBeforeStart%>") && remindBeforeStart) $GetEle("<%=remindBeforeStart%>").value = remindBeforeStart.value;
<%}%>
<% if(!remindBeforeEnd.equals("")){%>
if ($GetEle("<%=remindBeforeEnd%>") && remindBeforeEnd) $GetEle("<%=remindBeforeEnd%>").value = remindBeforeEnd.value;
<%}%>
<% if(!remindTimesBeforeStart.equals("")){%>
if ($GetEle("<%=remindTimesBeforeStart%>")) $GetEle("<%=remindTimesBeforeStart%>").value =remindTimesBeforeStart.value;
<%}%>
<% if(!remindTimesBeforeEnd.equals("")){%>
if ($GetEle("<%=remindTimesBeforeEnd%>")) $GetEle("<%=remindTimesBeforeEnd%>").value = remindTimesBeforeEnd.value;
<%}%>
<% if(!remindHoursBeforeStart.equals("")){%>
if ($GetEle("<%=remindHoursBeforeStart%>")) $GetEle("<%=remindHoursBeforeStart%>").value = remindHoursBeforeStart.value;
<%}%>
<% if(!remindTimesBeforeEnd.equals("")){%>
if ($GetEle("<%=remindHoursBeforeEnd%>")) $GetEle("<%=remindHoursBeforeEnd%>").value = remindHoursBeforeEnd.value;
<%}%>
}catch(e){}
}

//会议重复设值

function setRepeatdata(){
	var repeatdays = $GetEle("repeatdays");
	var repeatweeks = $GetEle("repeatweeks");
	var rptWeekDay = $GetEle("rptWeekDay");
	var repeatmonths = $GetEle("repeatmonths");
	var repeatmonthdays = $GetEle("repeatmonthdays");
	
	<% if(!repeatdays.equals("")){%>
	if ($GetEle("<%=repeatdays%>") && repeatdays ) $GetEle("<%=repeatdays%>").value = repeatdays.value;
	<%}%>
	<% if(!repeatweeks.equals("")){%>
	if ($GetEle("<%=repeatweeks%>") && repeatweeks ) $GetEle("<%=repeatweeks%>").value = repeatweeks.value;
	<%}%>
	<% if(!rptWeekDays.equals("")){%>
	if ($GetEle("<%=rptWeekDays%>") && rptWeekDay ) {
		var chk_value ="";  
		jQuery('input[name="rptWeekDay"]:checked').each(function(){  
		   chk_value += jQuery(this).val()+',';
		});
		$GetEle("<%=rptWeekDays%>").value = chk_value;
	}
	<%}%>
	<% if(!repeatmonths.equals("")){%>
	if ($GetEle("<%=repeatmonths%>") && repeatmonths ) $GetEle("<%=repeatmonths%>").value = repeatmonths.value;
	<%}%>
	<% if(!repeatmonthdays.equals("")){%>
	if ($GetEle("<%=repeatmonthdays%>") && repeatmonthdays ) $GetEle("<%=repeatmonthdays%>").value = repeatmonthdays.value;
	<%}%>
}

function doSave(){
	
	parastr = $GetEle("needcheck").value+$GetEle("inputcheck").value+"<%=needcheck10404%>" ;
	if(check_form($GetEle("frmmain"),parastr)){
		$GetEle("frmmain").src.value='save';
		if(checktimeok()){
				jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
                            
                //增加提示信息  开始 meiYQ 2007.10.19 start
		       		  var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
		       		  showPrompt(content);
               //增加提示信息  结束 meiYQ 2007.10.19 end
            setRemindData(); 
            setRepeatdata()  
            //附件上传
            StartUploadAll();
            checkuploadcomplet();
        }
    }
}
function doSubmit(obj){
	obj.disabled=true;
	parastr = $GetEle("needcheck").value+$GetEle("inputcheck").value+"<%=needcheck10404%>";
	if(check_form($GetEle("frmmain"),parastr)){
		$GetEle("frmmain").src.value='submit';
		if(checktimeok()){
			if($GetEle("repeatType") && $GetEle("repeatType").value != 0 ){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("33277,24355",user.getLanguage())%>", function (){
					submitact();
				},function(){obj.disabled=false;});
			}else{

			jQuery.ajax({
				type: 'POST',
				url: "/meeting/data/AjaxMeetingOperation.jsp?method=chkRoom",
				data: {address:$GetEle("frmmain").<%=Address%>.value,begindate:$GetEle("frmmain").<%=newfromdate%>.value,begintime:$GetEle("frmmain").<%=newfromtime%>.value,enddate:$GetEle("frmmain").<%=newenddate%>.value,endtime:$GetEle("frmmain").<%=newendtime%>.value},
				success: function(datas){
					if(datas != 0){
						<%if(meetingSetInfo.getRoomConflict() == 1){ %>
							window.top.Dialog.confirm(datas.trim()+"</br><%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>", function (){
								submitChkMbr(obj);
								
							}, function () {obj.disabled=false;}, 320, 90,false);
						<%} else if(meetingSetInfo.getRoomConflict() == 2) {%>
							window.top.Dialog.alert(datas.trim()+"</br><%=SystemEnv.getHtmlLabelName(32875,user.getLanguage())%>。");
							obj.disabled=false;
							return;
						<%}%>
					} else {
						submitChkMbr(obj);
					}
				}
			  });
		   }
        } else {
			obj.disabled=false;
		}
    } else {
		obj.disabled=false;
	}
}  

	function showPrompt(content)
{

     var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串

	 var isOpera = userAgent.indexOf("Opera") > -1;
	 var pTop=0;
	 //if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera){
		pTop= document.body.offsetHeight/2 - (parent.document.body.offsetHeight/2 - document.body.offsetHeight/2) - 55;
	 //}else{
		//pTop= document.body.offsetHeight/2+jQuery(document).scrollTop()-50;
	 //}
     var showTableDiv  = $G('_xTable');
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = $G("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     //var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-55;
     //jQuery(message_table_Div).css("position", "absolute");
	 //jQuery(message_table_Div).css("top", pTop);
     //jQuery(message_table_Div).css("left", pLeft);

     //message_table_Div.style.zIndex=1002;
     jQuery(message_table_Div).css("z-index", 1002);
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     jQuery(oIframe).css("position", "absolute");
	 jQuery(oIframe).css("top", pTop);
     jQuery(oIframe).css("left", pLeft);
     jQuery(oIframe).css("z-index", parseInt(jQuery(message_table_Div).css("z-index")) - 1);
     
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
     
     var top = pTop;   
     var left = pLeft;   
     jQuery("#_xTable").css( { position : 'fixed', 'top' : top, 'left' : left } ).show();
}
//提醒方式选择 
function showRemindTime()
{	
	var repeatType=jQuery('#repeatType').val();
	if(jQuery("#<%=remindTypeNew%>").val()=='')
	{	
		jQuery('tr[name="remindTimetr"]').hide();
		jQuery('tr[name="remindTimetr1"]').hide();
	}
	else
	{
		jQuery('tr[name="remindTimetr"]').show();
		if(repeatType==0||repeatType==undefined||repeatType=="undefined"||repeatType==''){
			jQuery('tr[name="remindTimetr1"]').show();
		}else{
			jQuery('tr[name="remindTimetr1"]').hide();
		}
	}
	
	
}

function onShowResourceRole1(id, url, linkurl, type1, ismand, roleid) {
	var tmpids = $GetEle("field" + id).value;
	url = url + roleid + "_" + tmpids;

	id1 = window.showModalDialog(url);
	if (id1) {

		if (wuiUtil.getJsonValueByIndex(id1, 0) != ""
				&& wuiUtil.getJsonValueByIndex(id1, 0) != "0") {

			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";
			if(resourceids.indexOf(",")==0){
				resourceids = resourceids.substr(1);
			}
			if(resourcename.indexOf(",")==0){
				resourcename = resourcename.substr(1);
			}

			$GetEle("field" + id).value = resourceids;

			var idArray = resourceids.split(",");
			var nameArray = resourcename.split(",");
			for ( var _i = 0; _i < idArray.length; _i++) {
				var curid = idArray[_i];
				var curname = nameArray[_i];

				sHtml = sHtml + "<a href=" + linkurl + curid
						+ " target='_new'>" + curname + "</a>&nbsp";
			}

			$GetEle("field" + id + "span").innerHTML = sHtml;

		} else {
			if (ismand == 0) {
				$GetEle("field" + id + "span").innerHTML = "";
			} else {
				$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			}
			$GetEle("field" + id).value = "";
		}
	}
}
    //yl qc:67452 start
    function $changeOption(obj, fieldid, childfieldid){

        var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
        $GetEle("selectChange").src = "SelectChange.jsp?"+paraStr;
    }
    function doInitChildSelect(fieldid,pFieldid,finalvalue){
        try{
            var pField = $GetEle("field"+pFieldid);
            if(pField != null){
                var pFieldValue = pField.value;
                if(pFieldValue==null || pFieldValue==""){
                    return;
                }
                if(pFieldValue!=null && pFieldValue!=""){
                    var field = $GetEle("field"+fieldid);
                    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=1&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
                    $GetEle("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
                }
            }
        }catch(e){}
    }
    <%=selectInitJsStr%>
    //yl qc:67452 end

function changeRepeatType(){
	var thisvalue=jQuery("#repeatType").val();
	jQuery("#repeattr").css("display", "");
	if(thisvalue == 0){
		jQuery("#dayrepeat").css("display", "none");
		jQuery("#weekrepeat").css("display", "none");
		jQuery("#monthrepeat").css("display", "none");
		jQuery("#repeattr").css("display", "none");
	} else {
		if(thisvalue == 1){
			jQuery("#dayrepeat").css("display", "");
			jQuery("#weekrepeat").css("display", "none");
			jQuery("#monthrepeat").css("display", "none");
		} else if(thisvalue == 2){
			jQuery("#dayrepeat").css("display", "none");
			jQuery("#weekrepeat").css("display", "");
			jQuery("#monthrepeat").css("display", "none");
		} else if(thisvalue == 3){
			jQuery("#dayrepeat").css("display", "none");
			jQuery("#weekrepeat").css("display", "none");
			jQuery("#monthrepeat").css("display", "");
		}
		
	}
	showRemindTime();
}

function onShowMeetingBrowser(fieldid,url,linkurl,fieldtype,viewtype){
	var meetingtype = $GetEle("field" + fieldid).value;
	//if(meetingtype != "" && meetingtype != null){
	//	top.Dialog.confirm("修改会议类型会更新召集人、参会者和会议服务信息，已填写的相关信息会丢失，是否确认继续？", function (){
	//				meetingTypeChange(fieldid,url,linkurl,fieldtype,viewtype);
	//	}, function () {}, 320, 90,true);
	//	
	//} else {
	//	meetingTypeChange(fieldid,url,linkurl,fieldtype,viewtype);
	//}
	
	meetingTypeChange(fieldid,url,linkurl,fieldtype,viewtype);
}
var mtypeold;
function meetingTypeChange(fieldid,url,linkurl,fieldtype,viewtype){
	mtypeold = $GetEle("field" + fieldid).value;
	onShowBrowser2(fieldid,url,linkurl,fieldtype,viewtype);
	
}

function afterChangeMeetingType(fieldid){
	var newv = $GetEle("field" + fieldid).value;
	if(mtypeold != newv){
		mtypeold=newv;
		if(newv==''){
			try{
				jQuery(".whereclauses").val("");
			}catch(e){}
			try{
			jQuery(".hrmids02s").val("");
			}catch(e){}
			try{
			jQuery(".crmids02s").val("");
			}catch(e){}
		}else{
			jQuery.post("/meeting/data/AjaxMeetingOperation.jsp?method=chgMeetingType",{meetingType:newv},function(data){
		      if(jQuery.trim(data)!=""){
		        jQuery("#otherdata").html("");
			    jQuery("#otherdata").append(data);
			    setTimeout("setMeetingTypedata()", 100);
			   } else {
				   try{
						jQuery(".whereclauses").val("");
					}catch(e){}
					try{
					jQuery(".hrmids02s").val("");
					}catch(e){}
					try{
					jQuery(".crmids02s").val("");
					}catch(e){}
			   }
		   });
		}
	}
}

function setMeetingTypedata(){
	var whereclauses = jQuery(".whereclauses");
	if($GetEle("<%=caller%>")&& whereclauses && whereclauses.length > 0 && whereclauses.val() !=""){
		$GetEle("<%=caller%>").value="";
		$GetEle("<%=caller%>span").innerHTML = "";
		if($GetEle("<%=caller%>").getAttribute("viewtype") == "1" ){
			//$GetEle("<%=caller%>spanimg").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			jQuery($GetEle("<%=caller%>spanimg")).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
		} else {
			//$GetEle("<%=caller%>spanimg").innerHTML = "";
			jQuery($GetEle("<%=caller%>spanimg")).html("");
		}
		
	}
	var hrmids02s = jQuery(".hrmids02s");
	if($GetEle("<%=hrmids02%>")&& hrmids02s && hrmids02s.length > 0  && hrmids02s.val() !=""){
		var existsId=","+$GetEle("<%=hrmids02%>").value+",";
		var idArray = jQuery(".hrmids02s").val().split(",");
		var nameArray = jQuery(".hrmids02spans").val().split(",");
		var sHtml = "";
		var sVal="";
		var sCount=0;
		for ( var _i = 0; _i < idArray.length; _i++) {
			var curid = idArray[_i];
			var curname = nameArray[_i];
			if(existsId.indexOf(","+curid+",")>-1) continue;
			existsId+=(curid+",");
			sVal+=","+curid;
			sCount++;
			sHtml += wrapshowhtml(0,"<A href='/hrm/resource/HrmResource.jsp?id="+curid+"' target=_blank>"+curname+"</A>&nbsp", curid);
		}

		$GetEle("<%=hrmids02%>span").innerHTML = $GetEle("<%=hrmids02%>span").innerHTML + sHtml;
		$GetEle("<%=hrmids02%>").value = $GetEle("<%=hrmids02%>").value + sVal;
		try{
			$GetEle("<%=resourceNumFieldId%>").value = sCount + parseInt($GetEle("<%=resourceNumFieldId%>").value, 10);
		}catch(e){
			countAttend();
		}
		
		if($GetEle("<%=hrmids02%>").getAttribute("viewtype") == "1" && $GetEle("<%=hrmids02%>").value == ""){
			jQuery($GetEle("<%=hrmids02%>spanimg")).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
		} else {
			jQuery($GetEle("<%=hrmids02%>spanimg")).html("");
		}
	}
	
	var crmids02s = jQuery(".crmids02s");
	if($GetEle("<%=crmids02%>")&& crmids02s && crmids02s.length > 0  && crmids02s.val() !="" ){
		if($GetEle("<%=crmids02%>").value == ""){
			$GetEle("<%=crmids02%>").value = crmids02s.val();
		} else {
			$GetEle("<%=crmids02%>").value = $GetEle("<%=crmids02%>").value + "," + crmids02s.val();
		}
		
		var idArray = crmids02s.val().split(",");
		var nameArray = jQuery(".crmids02spans").val().split(",");
		var sHtml = $GetEle("<%=crmids02%>span").innerHTML;
		for ( var _i = 0; _i < idArray.length; _i++) {
			var curid = idArray[_i];
			var curname = nameArray[_i];

			sHtml = sHtml+wrapshowhtml(0,"<a target='_new' href='/CRM/data/ViewCustomer.jsp?CustomerID="+curid+"'  >"+curname+"</a>&nbsp;",curid);
		}

		$GetEle("<%=crmids02%>span").innerHTML = sHtml;
		try{
			$GetEle("<%=crmsNumFieldId%>").value = parseInt(jQuery(".crmCnts").val(), 10) + parseInt($GetEle("<%=crmsNumFieldId%>").value, 10);
		}catch(e){
			countAttend();
		}
		if($GetEle("<%=crmids02%>").getAttribute("viewtype") == "1" && $GetEle("<%=crmids02%>").value == "" ){
			jQuery($GetEle("<%=crmids02%>spanimg")).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
		} else {
			jQuery($GetEle("<%=crmids02%>spanimg")).html("");
		}
	}
	hoverShowNameSpan(".e8_showNameClass");
	jQuery("body").jNice();
}

function onShowCaller(fieldid,linkurl,fieldtype,viewtype){
	var url = "";
	if(jQuery(".whereclauses")&&jQuery(".whereclauses").length > 0  && jQuery(".whereclauses").val() != ""){
		var whereclauses = jQuery(".whereclauses").val();
		url = "/systeminfo/BrowserMain.jsp?url=/meeting/data/CallerBrowser.jsp?meetingtype="+jQuery('#<%=meetingtype%>').val();
	}else{
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
		
	}
	
	onShowBrowser2(fieldid,url,linkurl,fieldtype,viewtype);
	
} 
var inputstr="";
var spanstr="";
var tmpismand=0;
//打开会议室选择框
function onShowAddress(inputname,spanname,ismand){
	inputstr=inputname;
	spanstr=spanname;
	tmpismand=ismand;
	var url = "/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MutilMeetingRoomBrowser.jsp";
	showBrwDlg(url, "fromwf=1&selectedids="+$('#'+inputname).val(), 680,570,spanname,inputname,"addressChgCbk");
}

//会议室回写处理
function addressChgCbk(datas){
		if(datas){
		if (datas!=""){
             arrid=datas.id;
             arrname=datas.name;
             var html="";
             for(var i=0;i<arrid.length;i++){
                html += "<a href='/meeting/Maint/MeetingRoom_list.jsp?id="+arrid[i]+"' target='_new' >"+arrname[i]+"</A>" + ",";
             }
             html = html.substr(0,html.length-1);
             $("#"+spanstr).html(html);
             $("#"+inputstr).val(ids);
		}else{
			if(ismand==1){
				$("#"+spanstr).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			 }else{
				$("#"+spanstr).html("");
			 }
            $("#"+inputstr).val('');
		}
		 _writeBackData(inputstr,2,{id:jQuery("#"+inputstr).val(),name:jQuery("#"+spanstr).html()},{
			hasInput:true,
			replace:true,
			isedit:true
		});
	}
	//addressCallBack();
}
jQuery(document).ready(function(){
	changeRepeatType();
	countAttend();
});
</script>

<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
