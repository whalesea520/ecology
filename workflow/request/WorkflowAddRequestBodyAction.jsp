
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@page import="weaver.crm.Maint.CustomerInfoComInfo"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.formmode.tree.CustomTreeUtil" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<%@ page import="weaver.meeting.MeetingBrowser"%>
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" /><%----- xwj for td3323 20051209  ------%>
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for @td2977 20051111-->
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for td3130 20051124-->
<jsp:useBean id="rsfgs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />

<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs01" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_item" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="java.util.HashMap,java.util.*" %>
<%@ page import="weaver.system.code.*" %>
<%@ page import="weaver.general.TimeUtil,weaver.general.Util" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="requestPreAddM" class="weaver.workflow.request.RequestPreAddinoperateManager" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="DateUtil" class="weaver.general.DateUtil" scope="page" />
<jsp:useBean id="jobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="leaveTypeColorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<!--请求的标题开始 -->
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<!-- 
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
 -->
 <link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">

<script type="text/javascript" src="../../js/weaver_wev8.js"></script>

<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<!-- browser 相关 -->
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<script type='text/javascript' src="/js/ecology8/request/autoSelect_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<script type="text/javascript">
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>


<%


String selectInitJsStr = "";
//FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
session.setAttribute("f_weaver_belongto_userid",f_weaver_belongto_userid);
session.setAttribute("f_weaver_belongto_usertype",f_weaver_belongto_usertype);
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
int usertype = 0;
int userlanguage=Util.getIntValue(request.getParameter("languageid"),7);
String logintype = Util.null2String(request.getParameter("logintype"));
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());
int formid=Util.getIntValue(request.getParameter("formid"),0);
String isbill = Util.null2String(request.getParameter("isbill"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
String  workflowtype=Util.null2String(request.getParameter("workflowtype"));
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0) ;
String  workflowname=Util.null2String((String)session.getAttribute(userid+"_"+workflowid+"workflowname"));
String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
String  docCategory=Util.null2String(request.getParameter("docCategory"));
String needcheck=Util.null2String(request.getParameter("needcheck"));
String currentdate=Util.null2String(request.getParameter("currentdate"));
String currenttime=Util.null2String(request.getParameter("currenttime"));
String prjid=Util.null2String(request.getParameter("prjid"));
String reqid=Util.null2String(request.getParameter("reqid"));
String docid=Util.null2String(request.getParameter("docid"));
String hrmid=Util.null2String(request.getParameter("hrmid"));
String crmid=Util.null2String(request.getParameter("crmid"));
int messageType=Util.getIntValue(request.getParameter("messageType"),0);
int chatsType=Util.getIntValue(request.getParameter("chatsType"),0); //微信提醒(QC:98106) 
int defaultName=Util.getIntValue(request.getParameter("defaultName"),0);
String smsAlertsType = Util.null2String(request.getParameter("smsAlertsType"));
String chatsAlertType = Util.null2String(request.getParameter("chatsAlertType"));//微信提醒(QC:98106)
String  topage=Util.null2String(request.getParameter("topage"));
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

ArrayList uploadfieldids=new ArrayList();
//开始日期和结束日期比较用






String newfromdate="a";
String newenddate="b";

HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息






CodeBuild cbuild = new CodeBuild(formid);
String  codeFields=Util.null2String(cbuild.haveCode());

// 得到每个字段的信息并在页面显示






String beagenter=""+userid;
//获得被代理人
int body_isagent=Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+userid),0);
if(body_isagent==1){
    beagenter=""+Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+userid),0);
}

String currentyear="";
if(currentdate!=null&&currentdate.indexOf("-")>=0){
	currentyear=currentdate.substring(0,currentdate.indexOf("-"));
}

ArrayList flowDocs=flowDoc.getDocFiled(""+workflowid); //得到流程建文挡的发文号字段






Map secMaxUploads = new HashMap();//封装选择目录的信息






Map secCategorys = new HashMap();
String codeField="";
if (flowDocs!=null&&flowDocs.size()>0)
{
codeField=""+flowDocs.get(0);
}
if (!fromFlowDoc.equals("1")) {%>
<br>
<div align="center" style="margin-bottom:4px;">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,userlanguage)%></font>
</div>
<title><%=Util.toScreen(workflowname,userlanguage)%></title>
<%}%>
<!--请求的标题结束 -->

<!--TD4262 增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;width:100%' valign='top'>
</div>
<!--TD4262 增加提示信息  结束-->
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<%----- xwj for td3323 20051209 begin ------%>
<%
 int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
 int maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+secid),5);
 if(maxUploadImageSize<=0){
 maxUploadImageSize = 5;
 }
 int uploadType = 0;
 String selectedfieldid = "";
 String result = RequestManager.getUpLoadTypeForSelect(workflowid);
 if(!result.equals("")){
 selectedfieldid = result.substring(0,result.indexOf(","));
 uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
 }
 boolean isCanuse = RequestManager.hasUsedType(workflowid); //判断当为选择目录时附件上传目录是否设置完全






 if(selectedfieldid.equals("") || selectedfieldid.equals("0")){
 	isCanuse = false;
 }
 //如果附件存放方式为选择目录，则重置默认值






 if(uploadType==1)
 {
	 maxUploadImageSize = 5;
 }

  if(isCanuse&&uploadType==1){

				rscount.executeSql("select selectvalue,docCategory from workflow_SelectItem where fieldid="+selectedfieldid+" and isbill="+isbill+" and isdefault='y'");
				while(rscount.next()){
					String tmpselectvalue = Util.null2String(rscount.getString("selectvalue"));
					String tdocCategory = Util.null2String(rscount.getString("docCategory"));
					
					int tsecid = Util.getIntValue(tdocCategory.substring(tdocCategory.lastIndexOf(",")+1),-1);
					String tMaxUploadFileSize = ""+Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+tsecid),-1);
                    
					if(!"".equals(tdocCategory)){
						maxUploadImageSize = Util.getIntValue(tMaxUploadFileSize,5);    				
					}
				}
 }

String docFlags=(String)session.getAttribute("requestAdd"+userid);
String newTNflag=(String)session.getAttribute("requestAddNewNodes"+userid);
String flowDocField=(String)session.getAttribute("requestFlowDocField"+userid);

String keywordismand="0";
String keywordisedit="0";
int titleFieldId=0;
int keywordFieldId=0;
String isSignDoc_add="";
String isSignWorkflow_add="";
int hrmResourceShow = 0;
RecordSet_nf1.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow,hrmResourceShow from workflow_base where id="+workflowid);
if(RecordSet_nf1.next()){
	titleFieldId=Util.getIntValue(RecordSet_nf1.getString("titleFieldId"),0);
    hrmResourceShow = Util.getIntValue(RecordSet_nf1.getString("hrmResourceShow"));
	keywordFieldId=Util.getIntValue(RecordSet_nf1.getString("keywordFieldId"),0);
    isSignDoc_add=Util.null2String(RecordSet_nf1.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet_nf1.getString("isSignWorkflow"));
}

String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
String 	txtuseruse=DateUtil.getWFTitleNew(""+workflowid,""+userid,""+username,logintype);
if(body_isagent==1){
	txtuseruse=DateUtil.getWFTitleNew(""+workflowid,""+beagenter,""+username,logintype);
}

//微信提醒START(QC:98106)
int chatsisedit=0;
RecordSet_nf1.execute("select isedit from workflow_nodeform where fieldid= -5 and nodeid="+nodeid);
if(RecordSet_nf1.next()){ 
    chatsisedit=Util.getIntValue(RecordSet_nf1.getString("isedit"),0); 
}
//微信提醒END(QC:98106)


String selectfieldlable = "";
String selectfieldvalue = "";

if(uploadType==1 && !"".equals(selectedfieldid.trim())){
	
	String selectfieldsql = "";
	 if(isbill.equals("1")){
		 selectfieldsql = "SELECT bf.fieldlabel,bf.fieldname,b.tablename FROM workflow_billfield bf,workflow_bill b WHERE b.id=bf.billid AND bf.id="+selectedfieldid;
	 }else{
	 	 selectfieldsql = "select fl.fieldlable,fd.fieldname,'workflow_form' AS tablename  FROM workflow_fieldlable fl,workflow_formdict fd WHERE fl.fieldid=fd.id and fl.fieldid="+selectedfieldid+" AND fl.langurageid="+userlanguage+" AND fl.formid="+formid;
	 }
 	 RecordSet_nf1.executeSql(selectfieldsql);
 	 if(RecordSet_nf1.next()){
 	    String _fieldlabel = RecordSet_nf1.getString(1);
 	    String _fieldname = RecordSet_nf1.getString("fieldname");
 	    String _tablename = RecordSet_nf1.getString("tablename");
 		if(isbill.equals("1")){
 			selectfieldlable = SystemEnv.getHtmlLabelName(Util.getIntValue(_fieldlabel),user.getLanguage());
 		}else{
 			selectfieldlable = _fieldlabel;
 		}
 		
 		String _isdefault = ""; 
 		String _tdocCategory = "";	
        String _selectvalue = "";		
 		RecordSet_nf1.executeSql("SELECT selectvalue,docCategory,isdefault FROM workflow_SelectItem WHERE fieldid="+selectedfieldid+" ORDER BY listorder");
 		while(RecordSet_nf1.next()){
 		  	_tdocCategory = RecordSet_nf1.getString(2).trim();
 		  	_isdefault = Util.null2String(RecordSet_nf1.getString(3));
			_selectvalue = RecordSet_nf1.getString(1).trim();
 		  	if("y".equals(_isdefault)){
 		  		selectfieldvalue = _selectvalue;
 		  	}
			
 		  	if(!"".equals(_tdocCategory)){
 		  		int _tsecid = Util.getIntValue(_tdocCategory.substring(_tdocCategory.lastIndexOf(",")+1),-1);
                String _tMaxUploadFileSize = ""+Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+_tsecid),5);
                secMaxUploads.put(_selectvalue,_tMaxUploadFileSize);
                secCategorys.put(_selectvalue,_tdocCategory);
 		  	}
 		}
 	 }
}

%>
<script language=javascript>


var js_hrmResourceShow = "<%=hrmResourceShow%>";
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
    $G(objName).outerHTML=outerHTML;       
    $G(objName).onchange=tempObjonchange;
}
</script>
<%----- xwj for td3323 20051209 end ------%>

<input type=hidden name="workflowRequestLogId" value="-1" id="workflowRequestLogId">
<input type="hidden" name="htmlfieldids" id="htmlfieldids">

<input type=hidden name ="uploadType" id="uploadType" value="<%=uploadType %>">
<input type=hidden name ="selectfieldvalue" id="selectfieldvalue" value="<%=selectfieldvalue %>">

<table class="ViewForm">
  <colgroup>
  <col width="20%">
  <col width="80%">

  <!--新建的第一行，包括说明和重要性 -->

  <tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
  <tr>
    <td class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,userlanguage)%></td>
    <td class=fieldvalueClass>
	<%if(body_isagent==1) {
		username=ResourceComInfo.getLastname(beagenter);
  }
		%>
      <!--modify by xhheng @20050318 for TD1689-->
      <%if(defaultName==1){%>
       <%--xwj for td1806 on 2005-05-09--%>
        <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,userlanguage)%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit( txtuseruse,userlanguage )%>" >
        <span id=requestnamespan>
		<%
		 if(txtuseruse.equals("")){
		%>	
		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		 <%}
		%>
		</span>
      <%}else{%>
        <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,userlanguage)%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "" >
        <span id=requestnamespan><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
      <%}%>
      <input type=radio value="0" name="requestlevel" checked><%=SystemEnv.getHtmlLabelName(225,userlanguage)%>
      <input type=radio value="1" name="requestlevel"><%=SystemEnv.getHtmlLabelName(15533,userlanguage)%>
      <input type=radio value="2" name="requestlevel"><%=SystemEnv.getHtmlLabelName(2087,userlanguage)%>
    </td>
  </tr>
<tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
  <!--第一行结束 -->
  <!--add by xhheng @ 2005/01/24 for 消息提醒 Request06，短信设置行开始 -->
  <%
    if(messageType == 1){
  %>
  <tr>
    <td class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(17586,userlanguage)%></td>
    <td class=fieldvalueClass>
	      <span id=messageTypeSpan></span>
	      <input type=radio value="0" name="messageType" <% if(smsAlertsType.equals("0")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,userlanguage)%>
	      <input type=radio value="1" name="messageType" <% if(smsAlertsType.equals("1")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,userlanguage)%>
	      <input type=radio value="2" name="messageType" <% if(smsAlertsType.equals("2")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,userlanguage)%>
	    </td>
  </tr>
  <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>

  <%}%>


  <!--短信设置行结束 -->
 <!--微信提醒START(QC:98106) -->
 <!--add by fyg @ 2014/03/20   for 微信提醒 -->
  <%
   if(chatsType == 1){
  if(chatsisedit==1){   
  %>
  <tr>
    <td class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(32812,userlanguage)%></td>
    <td class="fieldvalueClass">
	      <span id=chatsTypeSpan></span>
	      <input type=radio value="0" name="chatsType" <% if(chatsAlertType.equals("0")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,userlanguage)%>
	      <input type=radio value="1" name="chatsType" <% if(chatsAlertType.equals("1")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(26928,userlanguage)%>
	     </td>
  </tr>
  <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>

  <%}else{%>
   <tr>
    <td class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(32812,userlanguage)%></td> 
	      <% if(chatsAlertType.equals("0")) {%> <td class=fieldvalueClass>
	      <span id=chatsTypeSpan></span><%=SystemEnv.getHtmlLabelName(19782,userlanguage)%>  </td> <%}%>
	       <% if(chatsAlertType.equals("1")) {%><td class=fieldvalueClass>
	      <span id=chatsTypeSpan></span><%=SystemEnv.getHtmlLabelName(26928,userlanguage)%>  </td><%}%>
  </tr>
  <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>   <%} }%>
  <!--微信提醒END(QC:98106) -->
<%

//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）

ArrayList fieldids=new ArrayList();             //字段队列
ArrayList fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
ArrayList languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
ArrayList fieldlabels=new ArrayList();          //单据的字段的label队列
ArrayList fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
ArrayList fieldtypes=new ArrayList();           //单据的字段的type队列
ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
ArrayList fieldrealtype=new ArrayList();
int detailno=0;
// 确定字段是否显示，是否可以编辑，是否必须输入
ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();              //字段是否显示队列
ArrayList isedits=new ArrayList();              //字段是否可以编辑队列
ArrayList ismands=new ArrayList();              //字段是否必须输入队列

ArrayList fieldqfws=new ArrayList();

String isbodyview="0" ;    //字段是否显示
String isbodyedit="0" ;    //字段是否可以编辑
String isbodymand="0" ;    //字段是否必须输入
String fieldbodyid="";
String fieldbodyname = "" ;                         //字段数据库表中的字段名






String fieldbodyhtmltype = "" ;                     //字段的页面类型






String fieldbodytype = "" ;                         //字段的类型






String fieldbodylable = "" ;                        //字段显示名






String fielddbtype="";                              //字段数据类型
String bclick="";
String isbrowisMust = "";

int languagebodyid = 0 ;
int detailsum=0;
int qfws=0;
String isdetail = "";//xwj for @td2977 20051111
String textheight = "4";//xwj for @td2977 20051111
int fieldlen=0;  //字段类型长度
//获得触发字段名
String finalvalue = "";





DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(workflowid,nodeid,0);
ArrayList changefieldsadd=WfLinkageInfo.getChangeField(workflowid,nodeid,0);


if(isbill.equals("0")) {
    RecordSet_nf1.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formid+"  and t1.langurageid="+userlanguage+" order by t2.fieldorder");

    while(RecordSet_nf1.next()){
        fieldids.add(Util.null2String(RecordSet_nf1.getString("fieldid")));
        fieldorders.add(Util.null2String(RecordSet_nf1.getString("fieldorder")));
        fieldlabels.add(Util.null2String(RecordSet_nf1.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet_nf1.getString("langurageid")));
    }
}
else {

    RecordSet_nf1.executeProc("workflow_billfield_Select",formid+"");
    while(RecordSet_nf1.next()){
        fieldids.add(Util.null2String(RecordSet_nf1.getString("id")));
        fieldlabels.add(Util.null2String(RecordSet_nf1.getString("fieldlabel")));
        fieldhtmltypes.add(Util.null2String(RecordSet_nf1.getString("fieldhtmltype")));
        fieldtypes.add(Util.null2String(RecordSet_nf1.getString("type")));
        fieldnames.add(Util.null2String(RecordSet_nf1.getString("fieldname")));
        fieldviewtypes.add(Util.null2String(RecordSet_nf1.getString("viewtype")));
		fieldrealtype.add(Util.null2String(RecordSet_nf1.getString("fielddbtype")));
		fieldqfws.add(Util.null2String(RecordSet_nf1.getString("qfws")));
    }
}
//System.out.println("workflow_FieldForm_Select "+nodeid);
RecordSet_nf1.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet_nf1.next()){
    isfieldids.add(Util.null2String(RecordSet_nf1.getString("fieldid")));
    isviews.add(Util.null2String(RecordSet_nf1.getString("isview")));
    isedits.add(Util.null2String(RecordSet_nf1.getString("isedit")));
    ismands.add(Util.null2String(RecordSet_nf1.getString("ismandatory")));
}
//modify by mackjoe at 2006-06-07 td4491 将节点前附加操作移出循环外操作减少数据库访问量






//TD10029
ArrayList inoperatefields = new ArrayList();
ArrayList inoperatevalues = new ArrayList();
int fieldop1id=0;
requestPreAddM.setCreater(userid);
requestPreAddM.setOptor(userid);
requestPreAddM.setWorkflowid(workflowid);
requestPreAddM.setNodeid(nodeid);
Hashtable getPreAddRule_hs = requestPreAddM.getPreAddRule();
inoperatefields = (ArrayList)getPreAddRule_hs.get("inoperatefields");
inoperatevalues = (ArrayList)getPreAddRule_hs.get("inoperatevalues");


String preAdditionalValue = "";
boolean isSetFlag = false;//xwj for td3308 20051124
for(int i=0;i<fieldids.size();i++){         // 循环开始







    //数据初始化






	isbodyview="0";
	isbodyedit="0";
	isbodymand="0";

  int tmpindex = i ;
    if(isbill.equals("0")) tmpindex = fieldorders.indexOf(""+i);     // 如果是表单, 得到表单顺序对应的 i

	if(tmpindex == -1)
    	continue;
    	
	fieldbodyid=(String)fieldids.get(tmpindex);  //字段id
    if( isbill.equals("1")) {
        String viewtype = (String)fieldviewtypes.get(tmpindex) ;   // 如果是单据的从表字段,不显示






        if( viewtype.equals("1") ) continue ;
    }

 /*---xwj for td3130 20051124 begin ---*/
  preAdditionalValue = "";
  isSetFlag = false;//added by xwj for td3359 20051222
  //将节点前附加操作移出循环外操作减少数据库访问量






  //rsaddop.executeSql("select customervalue from workflow_addinoperate where workflowid=" + workflowid + " and ispreadd='1' and isnode = 1 and objid = "+nodeid+" and fieldid = " + fieldbodyid);
  int inoperateindex=inoperatefields.indexOf(fieldbodyid);
  if(inoperateindex>-1){
  isSetFlag = true;
  preAdditionalValue = (String)inoperatevalues.get(inoperateindex);
  }
  /*---xwj for td3130 20051124 end ---*/
  
  // TD86150 begin
  String fieldValue = (String) fieldMap.get("field" + fieldbodyid);
  if(!"".equals(fieldValue) && fieldValue != null) {
	  preAdditionalValue = fieldValue;
	  isSetFlag = true;
  }
  // TD86150 end

    int isfieldidindex = isfieldids.indexOf(fieldbodyid) ;
    if( isfieldidindex != -1 ) {
        isbodyview=(String)isviews.get(isfieldidindex);    //字段是否显示
	    isbodyedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
	    isbodymand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
    }
    
    if ("1".equals(isbodyedit)) {
        isbrowisMust = "1";
    }
    
    if ("1".equals(isbodymand)) {
        isbrowisMust = "2";
    }


    if(isbill.equals("0")) {
        languagebodyid= Util.getIntValue( (String)languageids.get(tmpindex), 0 ) ;    //需要更新






        fieldbodyhtmltype=FieldComInfo.getFieldhtmltype(fieldbodyid);
        fieldbodytype=FieldComInfo.getFieldType(fieldbodyid);
        fieldbodylable=(String)fieldlabels.get(tmpindex);
        fieldbodyname=FieldComInfo.getFieldname(fieldbodyid);
		fielddbtype=FieldComInfo.getFielddbtype(fieldbodyid);

    }
    else {
        languagebodyid = userlanguage ;
        fieldbodyname=(String)fieldnames.get(tmpindex);
        fieldbodyhtmltype=(String)fieldhtmltypes.get(tmpindex);
        fieldbodytype=(String)fieldtypes.get(tmpindex);
		fielddbtype=(String)fieldrealtype.get(tmpindex);
        fieldbodylable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(tmpindex),0),languagebodyid );
        qfws=Util.getIntValue(""+fieldqfws.get(tmpindex));
    }
	 fieldlen=0;
    if ((fielddbtype.toLowerCase()).indexOf("varchar")>-1)
	{
	   fieldlen=Util.getIntValue(fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.length()-1));

	}
    if(fieldbodyname.equals("manager")) {
        //QC169123
        //判断是否客户门户
	    //String tmpmanagerid = ResourceComInfo.getManagerID(beagenter);
        String tmpmanagerid;
        if(user.getLogintype().equals("2")){
            CustomerInfoComInfo customerInfoComInfo = new CustomerInfoComInfo();
            tmpmanagerid = customerInfoComInfo.getCustomerInfomanager(beagenter);
        }else{
            tmpmanagerid = ResourceComInfo.getManagerID(beagenter);
        }
%>
	<input type=hidden name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" value="<%=tmpmanagerid%>" />
<%
    if(isbodyview.equals("1")){
%> <tr>
      <td class="fieldnameClass" <%if(fieldbodyhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldbodylable,languagebodyid)%> </td>
      <td class=fieldvalueClass><%=ResourceComInfo.getLastname(tmpmanagerid)%></td>
   </tr><tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
<%
    }
	    continue;
	}
    if( ! isbodyview.equals("1") ) { //不显示即进行下一步循环,除了人力资源字段，应该隐藏人力资源字段，因为人力资源字段有可能作为流程下一节点的操作者






        if(fieldbodyhtmltype.equals("3") && (fieldbodytype.equals("1") ||fieldbodytype.equals("17")||fieldbodytype.equals("165")||fieldbodytype.equals("166")) && !preAdditionalValue.equals("")){           
           out.println("<input type=hidden name=field"+fieldbodyid+" id=field"+fieldbodyid+" value="+preAdditionalValue+">");
        }else if(!preAdditionalValue.equals("")){
        	out.println("<input type=hidden name=field"+fieldbodyid+" id=field"+fieldbodyid+" value="+preAdditionalValue+">");
        }        
        continue ;                  
    }
	if(fieldbodyname.equals("begindate")) newfromdate="field"+fieldbodyid;      //开始日期,主要为开始日期不大于结束日期进行比较
	if(fieldbodyname.equals("enddate")) newenddate="field"+fieldbodyid;     //结束日期,主要为开始日期不大于结束日期进行比较
	if((""+keywordFieldId).equals(fieldbodyid)) keywordismand=Util.null2o(isbodymand);     
	if((""+keywordFieldId).equals(fieldbodyid)) keywordisedit=Util.null2o(isbodyedit);     

    if(isbodymand.equals("1")&&!fieldbodyid.equals(codeField)&&!fieldbodyid.equals(codeField))  needcheck+=",field"+fieldbodyid;   //如果必须输入,加入必须输入的检查中(如果是发问号字段，不必输入检查，程序自动生成)

    // 下面开始逐行显示字段
%>
    <tr>
      <td class="fieldnameClass" <%if(fieldbodyhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldbodylable,languagebodyid)%> </td>
      <td class=fieldvalueClass style="word-wrap:break-word;word-break:break-all;">
      <%
        if(fieldbodyhtmltype.equals("1")){                          // 单行文本框






            if(fieldbodytype.equals("1")){                          // 单行文本框中的文本






                if(isbodyview.equals("1")){

                if(isbodyedit.equals("1")&&!fieldbodyid.equals(codeField)&&!fieldbodyid.equals(codeFields)){
					if(keywordFieldId>0&&(""+keywordFieldId).equals(fieldbodyid)){
%>
<button  id="field<%=fieldbodyid%>browser" name="field<%=fieldbodyid%>browser" type=button class=Browser  onclick="onShowKeyword(field<%=fieldbodyid%>.viewtype)" title="<%=SystemEnv.getHtmlLabelName(21517,userlanguage)%>"></button>
<%
					}
                    if(isbodymand.equals("1")) {
      %>
        <input datatype="text" viewtype="<%=isbodymand%>" type=text class=Inputstyle temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" size=50 onChange="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype);checkLength('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,userlanguage)%>','<%=SystemEnv.getHtmlLabelName(20247,userlanguage)%>')<%if(titleFieldId>0&&keywordFieldId>0&&(""+titleFieldId).equals(fieldbodyid)){%>;changeKeyword()<%}%>"<%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>');" <%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
      <%

		}else{%>
		<!-- 单行文本-文本 -->	
        <input datatype="text" viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" type=text class=Inputstyle name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" size=50 onChange="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype);checkLength('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,userlanguage)%>','<%=SystemEnv.getHtmlLabelName(20247,userlanguage)%>')<%if(titleFieldId>0&&keywordFieldId>0&&(""+titleFieldId).equals(fieldbodyid)){%>;changeKeyword()<%}%>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>')" <%}%> value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
		<!-- 单行文本-文本 -->	
        <span id="field<%=fieldbodyid%>span"></span>
      <%            }
		    }else{ %>
        <!--input  type=text class=Inputstyle name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>"  size=50 readonly-->
            <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
            <input  type=hidden class=Inputstyle name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>"  size=50 value="<%=preAdditionalValue%>" onpropertychange="datainput('field<%=fieldbodyid%>');"><!--modified by xwj for td3130 20051124-->
      <%          }
            }
            }
		    else if(fieldbodytype.equals("2")){                     // 单行文本框中的整型






                if(isbodyview.equals("1")){
			    if(isbodyedit.equals("1")){
				    if(isbodymand.equals("1")) {
      %>
        <input  datatype="int" viewtype="<%=isbodymand%>" type=text class=Inputstyle temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" size=20
		onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,userlanguage).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype);datainput('field<%=fieldbodyid%>');" <%}else{%> onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,userlanguage).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype);" <%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
       <%

		}else{%>
		<!-- 单行文本-整数  再此行添加 onkeyup onafterpaste style="ime-mode:disabled" ypc  2012-09-04 添加 -->
        <input  datatype="int" viewtype="<%=isbodymand%>"  onafterpaste="if(isNaN(value))execCommand('undo')"  style="ime-mode:disabled"  temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" type=text class=Inputstyle name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" size=20  onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,userlanguage).replace("12","9")%>',-999999999,999999999);datainput('field<%=fieldbodyid%>');checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype);" <%}else{%> onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,userlanguage).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype)" <%}%> value="<%=preAdditionalValue%>"> <!--modified by xwj for td3130 20051124-->
		<!-- 单行文本-整数 -->
        <span id="field<%=fieldbodyid%>span"></span>
       <%           }
			    }else{  %>
         <!--input datatype="int" type=text class=Inputstyle name="field<%=fieldbodyid%>" size=20 readonly-->
         <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
         <input datatype="int" type=hidden class=Inputstyle name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <%        }
            }
            }
		    else if(fieldbodytype.equals("3")||fieldbodytype.equals("5")){                     // 单行文本框中的浮点型
		    	int decimaldigits_t = 2;
		    	if(fieldbodytype.equals("3")){
		    		int digitsIndex = fielddbtype.indexOf(",");
		        	if(digitsIndex > -1){
		        		decimaldigits_t = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
		        	}else{
		        		decimaldigits_t = 2;
		        	}
		    	}
		    	String datavaluetype = "";
		    	if(fieldbodytype.equals("5")){
		    		  if(isbill.equals("0")){
		    		    //System.out.println("select * from workflow_formdict where id = " + fieldbodyid);
				          RecordSet_nf2.executeSql("select * from workflow_formdict where id = " + fieldbodyid);
							 if(RecordSet_nf2.next()){
							   qfws = Util.getIntValue(RecordSet_nf2.getString("qfws"),2);
							 }
							 decimaldigits_t=qfws; 
						}else{
							if(qfws == -1){
								 decimaldigits_t=2;
							}else{
								 decimaldigits_t=qfws;
							}
						}
		    		 datavaluetype ="datavaluetype='5'";
		    	}

				//update  by liaodong for  qc75759 in 2013年10月23日 start
		         datavaluetype +="datalength='"+decimaldigits_t+"'";
		        //end 
                if(isbodyview.equals("1")){
			    if(isbodyedit.equals("1")){
				    if(isbodymand.equals("1")) {
       %>
       <!-- 单行文本-浮点数 和金额千分位  style="ime-mode:disabled" onkeyup  onafterpaste ypc 2012-09-04 添加  start-->
       <!-- QC46731 新建页面的浮点数未实现必填验证及字段联动 -->
        <input datatype="float" <%=datavaluetype%> style="ime-mode:disabled" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"   viewtype="<%=isbodymand%>" type=text class=Inputstyle temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" size=20
		onKeyPress="ItemDecimal_KeyPress('field<%=fieldbodyid%>',15,<%=decimaldigits_t%>)" <%if(fieldbodytype.equals("5")){%>onfocus="changeToNormalFormat('field<%=fieldbodyid%>')"<%}%><%if (trrigerfield.indexOf("field" + fieldbodyid) >= 0) {%>  onBlur="checkFloat(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype);datainput('field<%=fieldbodyid%>');<%if (fieldbodytype.equals("5")) {%>changeToThousands2('field<%=fieldbodyid%>','<%=decimaldigits_t %>')<%}%>" <%} else {%> onBlur="checkFloat(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype);<%if (fieldbodytype.equals("5")) {%>changeToThousands2('field<%=fieldbodyid%>','<%=decimaldigits_t %>')<%}%>" <%}%>  value="<%=preAdditionalValue%>"> 
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
       <%}else{%>
        <input datatype="float" <%=datavaluetype%> style="ime-mode:disabled"  onafterpaste="if(isNaN(value))execCommand('undo')" 
       onKeyPress="ItemDecimal_KeyPress('field<%=fieldbodyid%>',15,<%=decimaldigits_t%>)"
       viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" type=text class=Inputstyle name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" size=20 <%if(fieldbodytype.equals("5")){%> onfocus="changeToNormalFormat('field<%=fieldbodyid%>')"<%}%> <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="checkFloat(this);datainput('field<%=fieldbodyid%>'); checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype); <%if(fieldbodytype.equals("5")){%>changeToThousands2('field<%=fieldbodyid%>','<%=decimaldigits_t %>')<%}%> " <%}else{%> onBlur="checkFloat(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype); <%if(fieldbodytype.equals("5")){%>changeToThousands2('field<%=fieldbodyid%>','<%=decimaldigits_t %>')<%}%> "<%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"></span>
       <%}
      }else{%>
         <!--input datatype="float" type=text class=Inputstyle name="field<%=fieldbodyid%>"  size=20 readonly-->
         <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
         <input datatype="float" <%=datavaluetype%> type=hidden class=Inputstyle name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <!-- 单行文本-浮点数 和金额千分位 end-->
        <%}
		 }
	    }
          
	     /*-----------xwj for td3131 20051115 begin  ----------*/
	    else if(fieldbodytype.equals("4")){
			   int decimaldigits_t = 2;
		    	if(fieldbodytype.equals("4")){
		    		int digitsIndex = fielddbtype.indexOf(",");
		        	if(digitsIndex > -1){
		        		decimaldigits_t = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
		        	}else{
		        		decimaldigits_t = 2;
		        	}
		    	}
		%>
            <table cols=2 id="field<%=fieldbodyid%>_tab">
           
            <tr><td>
                <%if(isbodyview.equals("1")){
                    if(isbodyedit.equals("1")){%>
                    	<!-- ypc 2012-09-04 添加 onkeydown  style="ime-mode:disabled" onkeyup onaferpaste-->
                        <input datatype="float" viewtype="<%=isbodymand%>" type=text class=Inputstyle id="field_lable<%=fieldbodyid%>" name="field_lable<%=fieldbodyid%>" size=60
                            onfocus="FormatToNumber('<%=fieldbodyid%>')"
                            onKeyPress="ItemDecimal_KeyPress('field_lable<%=fieldbodyid%>',15,<%=decimaldigits_t %>)"
                            style="ime-mode:disabled;"  onafterpaste="if(isNaN(value))execCommand('undo')"
                            <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldbodyid%>');datainput('field_lable<%=fieldbodyid%>');checkinput2('field_lable<%=fieldbodyid%>','field_lable<%=fieldbodyid%>span',field<%=fieldbodyid%>.viewtype)"
                            <%}else{%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldbodyid%>');checkinput2('field_lable<%=fieldbodyid%>','field_lable<%=fieldbodyid%>span',field<%=fieldbodyid%>.viewtype)"
                            <%}%>
                        >
                        <span id="field_lable<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)&&isbodymand.equals("1")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
                        <span id="field<%=fieldbodyid%>span"></span>
                          <!-- add by liaodong for qc82290 in 2013-10-17  datalength="2"  filedtype="4"-->
                        <input datatype="float" datalength="2" filedtype="4" viewtype="<%=isbodymand%>" type=hidden class=Inputstyle temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" value="">
                    <%}else{%>
                        <span id="field<%=fieldbodyid%>span"></span>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldbodyid%>" id="field_lable<%=fieldbodyid%>" disabled="true">
						<!-- add by liaodong for qc82290 in 2013-10-17  datalength="2"  filedtype="4"-->
                        <input datatype="float" datalength="2" filedtype="4"  type=hidden class=Inputstyle name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" value="">
                    <%}
                }
                if(!"".equals(preAdditionalValue)){%>
                    <script language="javascript">
                    	$GetEle("field_lable"+<%=fieldbodyid%>).value  = numberChangeToChinese(<%=preAdditionalValue%>);
                    	$GetEle("field"+<%=fieldbodyid%>).value  = <%=preAdditionalValue%>;
                    </script>
                <%}%>
            </td></tr>
            <tr><td>
                <input type=text class=Inputstyle size=60 name="field_chinglish<%=fieldbodyid%>" readOnly="true">
            </td></tr>
            </table>
	    <%}
	    /*-----------xwj for td3131 20051115 end ----------*/
        if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
        }// 单行文本框条件结束






	    else if(fieldbodyhtmltype.equals("2")){                     // 多行文本框






	    	
	     /*-----xwj for @td2977 20051111 begin-----*/
	     if(isbill.equals("0")){
			 rscount.executeSql("select * from workflow_formdict where id = " + fieldbodyid);
			 if(rscount.next()){
			 textheight = rscount.getString("textheight");
			 }
		}else{
			rscount.executeSql("select * from workflow_billfield where viewtype=0 and id = " + fieldbodyid+" and billid="+formid);
			if(rscount.next()){
				textheight = ""+Util.getIntValue(rscount.getString("textheight"), 4);
			}
		}
			    /*-----xwj for @td2977 20051111 begin-----*/
            if(isbodyview.equals("1")){
		    if(isbodyedit.equals("1")){
			    if(isbodymand.equals("1")) {
       %>
        <textarea class=Inputstyle viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>');" <%}%> onChange="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype);checkLengthfortext('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,userlanguage)%>','<%=SystemEnv.getHtmlLabelName(20247,userlanguage)%>')"
		rows="<%=textheight%>" cols="40" style="width:80%" class=Inputstyle ><%=preAdditionalValue%></textarea><!--xwj for @td2977 20051111-->
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->

       <%
			    }else{
       %>
        <textarea class=Inputstyle viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" onchange="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype);checkLengthfortext('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,userlanguage)%>','<%=SystemEnv.getHtmlLabelName(20247,userlanguage)%>')" name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype);datainput('field<%=fieldbodyid%>');" <%}%> rows="<%=textheight%>" cols="40" style="width:80%"><%=Util.encodeAnd(preAdditionalValue)%></textarea><!--xwj for @td2977 20051111--><!--modified by xwj for td3130 20051124-->
        <span id="field<%=fieldbodyid%>span"></span>
       <%       }%>
       <script>$G("htmlfieldids").value += "field<%=fieldbodyid%>;<%=Util.toScreen(fieldbodylable,languagebodyid)%>;<%=fieldbodytype%>,";</script>
       <%if (fieldbodytype.equals("2")) {%>
		   	<script>function funcField<%=fieldbodyid%>(){
			   	
		   		CkeditorExt.initEditor('frmmain','field<%=fieldbodyid%>','<%=userlanguage%>',CkeditorExt.NO_IMAGE,200)
				//FCKEditorExt.initEditor('frmmain','field<%=fieldbodyid%>',<%=userlanguage%>,FCKEditorExt.NO_IMAGE);
				<%if(isbodyedit.equals("1"))out.println("CkeditorExt.checkText('field"+fieldbodyid+"span','field"+fieldbodyid+"');");%>
				CkeditorExt.toolbarExpand(false,"field<%=fieldbodyid%>");
				}
				if (window.addEventListener){
				    window.addEventListener("load", funcField<%=fieldbodyid%>, false);
				}else if (window.attachEvent){
				    window.attachEvent("onload", funcField<%=fieldbodyid%>);
				}else{
				    window.onload=funcField<%=fieldbodyid%>;
				}
			</script>
		<%} }else{  %>
                <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
                <input type=hidden class=Inputstyle name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" value='<%=preAdditionalValue%>'><!--modified by xwj for td3130 20051124-->
         <!--textarea  class=Inputstyle name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" rows="4" cols="40" style="width:80%"  readonly></textarea-->
        <%        }
	    }
        if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
        }// 多行文本框条件结束






	    else if(fieldbodyhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
		    String url=BrowserComInfo.getBrowserurl(fieldbodytype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldbodytype);    // 浏览值点击的时候链接的url


		
		    if("23".equals( fieldbodytype)){
		    	if(url.indexOf("CapitalBrowser.jsp?")>-1){
		    		url+="&billid="+formid;
		    	}else{
		    		url+="?billid="+formid;
		    	}
		    }


		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值







            if((fieldbodytype.equals("8") || fieldbodytype.equals("135")) && !prjid.equals("")){       //浏览按钮为项目,从前面的参数中获得项目默认值






                showid = "" + Util.getIntValue(prjid,0);
            }else if((fieldbodytype.equals("9") || fieldbodytype.equals("37")) && !docid.equals("")){ //浏览按钮为文档,从前面的参数中获得文档默认值






                showid = "" + Util.getIntValue(docid,0);
            }else if((fieldbodytype.equals("1") ||fieldbodytype.equals("17")||fieldbodytype.equals("165")||fieldbodytype.equals("166")) && !hrmid.equals("")&& body_isagent!=1){ //浏览按钮为人,从前面的参数中获得人默认值






                showid = "" + Util.getIntValue(hrmid,0);
            }else if((fieldbodytype.equals("1") ||fieldbodytype.equals("17")||fieldbodytype.equals("165")||fieldbodytype.equals("166")) && !hrmid.equals("")&& body_isagent==1){ //浏览按钮为人,从前面的参数中获得人默认值






                showid = "" + Util.getIntValue(beagenter,0);
            }else if((fieldbodytype.equals("7") || fieldbodytype.equals("18")) && !crmid.equals("")){ //浏览按钮为CRM,从前面的参数中获得CRM默认值






                showid = "" + Util.getIntValue(crmid,0);
            }else if((fieldbodytype.equals("16") || fieldbodytype.equals("152") || fieldbodytype.equals("171")) && !reqid.equals("")){ //浏览按钮为REQ,从前面的参数中获得REQ默认值






                showid = "" + Util.getIntValue(reqid,0);
			}else if((fieldbodytype.equals("4") || fieldbodytype.equals("57") || fieldbodytype.equals("167") || fieldbodytype.equals("168")) && !hrmid.equals("") && body_isagent!=1){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
            }else if((fieldbodytype.equals("4") || fieldbodytype.equals("57") || fieldbodytype.equals("167") || fieldbodytype.equals("168")) && !hrmid.equals("")&& body_isagent==1){ //代理，浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(beagenter),0);
            }else if((fieldbodytype.equals("24") || fieldbodytype.equals("278")) && !hrmid.equals("")&& body_isagent==1){ //代理,浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getJobTitle(beagenter),0);
            }else if((fieldbodytype.equals("24") || fieldbodytype.equals("278")) && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getJobTitle(hrmid),0);
            }else if(fieldbodytype.equals("32") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"),0);
            }else if((fieldbodytype.equals("164") || fieldbodytype.equals("169") || fieldbodytype.equals("170") || fieldbodytype.equals("194")) && !hrmid.equals("")&& body_isagent!=1){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getSubCompanyID(hrmid),0);
            }else if((fieldbodytype.equals("164") || fieldbodytype.equals("169") || fieldbodytype.equals("170") || fieldbodytype.equals("194")) && !hrmid.equals("")&& body_isagent==1){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getSubCompanyID(beagenter),0);
            }else if(fieldbodytype.equals("224")||fieldbodytype.equals("225")||fieldbodytype.equals("226")||fieldbodytype.equals("227")){
					//zzl普通模板解析主表字段的"集成浏览按钮"
					//拼接?type=browser.267|11266
					url+="?type="+fielddbtype+"|"+fieldbodyid;	
			}else if(fieldbodytype.equals("256")||fieldbodytype.equals("257")){
					url+="?type="+fielddbtype+"_"+fieldbodytype;	
			}

            if(fieldbodytype.equals("2")){ //added by xwj for td3130 20051124
                 if(!isSetFlag){
                    showname = currentdate;
                    showid = currentdate;
                }else{
                    showname=preAdditionalValue;
                    showid=preAdditionalValue;
                }
            }

            if(fieldbodytype.equals("178")){ 
                 if(!isSetFlag){
                    showname = currentyear;
                    showid = currentyear;
                }else{
                    showname=preAdditionalValue;
                    showid=preAdditionalValue;
                }
            }
            if(fieldbodytype.equals("269")){ 
                showname=preAdditionalValue;
                showid=preAdditionalValue;
            }

				if(fieldbodytype.equals("19")){ //added by ben 2008-3-14 默认当前时间
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
            if(fieldbodytype.equals("2") || fieldbodytype.equals("19")  || fieldbodytype.equals("178"))	showname=showid; // 日期时间
            else if(!showid.equals("")){       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                ArrayList tempshowidlist=Util.TokenizerString(showid,",");
                if(fieldbodytype.equals("8") || fieldbodytype.equals("135")){
                    //项目，多项目
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k) + "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("1") ||fieldbodytype.equals("17")||fieldbodytype.equals("165")||fieldbodytype.equals("166")){
                    //人员，多人员
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                        	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl)||"/hrm/hrmTab.jsp?_fromURL=HrmResource&id=".equals(linkurl))
                          	{
                        		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                          	}
                        	else
                            	showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("7") || fieldbodytype.equals("18")){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("4") || fieldbodytype.equals("57")){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("164") || fieldbodytype.equals("194")){
                    //分部
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("278")){
                	for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+jobTitlesComInfo.getJobTitlesname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        	showname+=jobTitlesComInfo.getJobTitlesname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("9") || fieldbodytype.equals("37")){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){
                        if (fieldbodytype.equals("9")&&docFlags.equals("1"))
                        {
                        //linkurl="WorkflowEditDoc.jsp?docId=";//维护正文
                         String tempDoc=""+tempshowidlist.get(k);
                       showname+="<a href='#' onlick='createDoc("+fieldbodyid+","+tempDoc+")'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }
                        else
                        {
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+" ";
                        }
                        }
                    }
                }else if(fieldbodytype.equals("23")){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("16") || fieldbodytype.equals("152") || fieldbodytype.equals("171")){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("161")||fieldbodytype.equals("162")){
                    
					Browser browser=(Browser) StaticObj.getServiceByFullname(fielddbtype, Browser.class);
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
                }else if(fieldbodytype.equals("141")){
                    //人力资源条件
                    ResourceConditionManager.setWorkflowid(workflowid);
					showname+=ResourceConditionManager.getFormShowName(preAdditionalValue,languagebodyid);                    
                }else if(fieldbodytype.equals("256") || fieldbodytype.equals("257")){
                    //自定义树形浏览按钮


                    CustomTreeUtil customTreeUtil = new CustomTreeUtil();
                    //customTreeUtil.getTreeFieldShowName(preAdditionalValue,fielddbtype);
					showname+=customTreeUtil.getTreeFieldShowName(preAdditionalValue,fielddbtype); 
					//System.out.println("showname = "+showname);
                }else if(fieldbodytype.equals("224")||fieldbodytype.equals("225")||fieldbodytype.equals("226")||fieldbodytype.equals("227")){
                    //zzl--集成字段新建的时候赋予默认值






					showname+=preAdditionalValue;    
                }else if(fieldbodytype.equals("269")){
                	
                	showname = Util.toScreen(MeetingBrowser.getRemindNames(showname, user.getLanguage()),user.getLanguage());
                    
                }
                else{
					
					
                    String tablename=BrowserComInfo.getBrowsertablename(fieldbodytype);
                    String columname=BrowserComInfo.getBrowsercolumname(fieldbodytype);
					/*因为应聘库中(HrmCareerApply)的人员的firstname在新增时都为空，此处列名直接取上面查出来的(lastname+firstname)
					会导致流程提交后应聘人不显示，所以此处做下特殊处理，只取应聘人的lastname	参考TD24866*/
					if(columname.equals("(lastname+firstname)"))
						columname = "lastname";
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldbodytype);
                    if(!tablename.equals("") && !columname.equals("") && !keycolumname.equals("")){
	                    String sql="";
	                    if(showid.indexOf(",")==-1){
	                        sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+showid;
	                    }else{
	                        sql="select "+columname+" from "+tablename+" where "+keycolumname+" in("+showid+")";
	                    }

	                    RecordSet_nf1.executeSql(sql);
	                    while(RecordSet_nf1.next()) {
							if(fieldbodytype.equals("263")){
								  showname +=RecordSet_nf1.getString(1) ;
							}else{
								  if(!linkurl.equals(""))
	                                showname += "<a href='"+linkurl+showid+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+RecordSet_nf1.getString(1)+"</a>&nbsp";
	                            else
	                                showname +=RecordSet_nf1.getString(1) ;
							}
	                       
	                    }
                    }
                }
            }

           //deleted by xwj for td3130 20051124

		    if(isbodyedit.equals("1")){
		        
		        try {
			    	 if(fieldbodytype.equals("161") || fieldbodytype.equals("162")){
			               showname = showname.replaceAll("</a>&nbsp", "</a>~~WEAVERSplitFlag~~");   
			    	 }else{
			               showname = showname.replaceAll("</a>&nbsp", "</a>,"); 
			    	 }
			    } catch (Exception e) {
			        e.printStackTrace();
			    }
//add  by ben delweath rolepersone

				
if("16".equals(fieldbodytype)){   //请求
			if(url.indexOf("RequestBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("ViewRequest.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

	/*if("152".equals(fieldbodytype) || "171".equals(fieldbodytype)){   //多请求






			if(url.indexOf("MultiRequestBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("ViewRequest.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
		}		 */

		if("7".equals(fieldbodytype)){   //客户
			if(url.indexOf("CustomerBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("ViewCustomer.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

			if("9".equals(fieldbodytype)){   //文档
			if(url.indexOf("DocBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("DocDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

			if("37".equals(fieldbodytype)){   //多文档






			if(url.indexOf("MutiDocBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("DocDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

			if("1".equals( fieldbodytype)){   //单人力






			if(url.indexOf("ResourceBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmResource.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		

		/*if("17".equals( fieldbodytype)){   ////多人力






			if(url.indexOf("MultiResourceBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("hrmTab.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}

		}*/

		if("165".equals( fieldbodytype)){   //分权单人力






			if(url.indexOf("ResourceBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmResource.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		

		if("166".equals( fieldbodytype)){   ////分权多人力






			if(url.indexOf("MultiResourceBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("hrmTab.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("167".equals( fieldbodytype)){   ////分权单部门






			if(url.indexOf("DepartmentBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmDepartmentDsp.jsp?")>-1){
					//System.out.println("--linkurl---");
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
					//System.out.println("--linkurl---"+linkurl);
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}


		if("168".equals( fieldbodytype)){   ////分权多部门






			if(url.indexOf("MultiDepartmentBrowserByDecOrder.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmDepartmentDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("169".equals( fieldbodytype)){   ////分权单分部






			if(url.indexOf("SubcompanyBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmSubCompanyDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("170".equals( fieldbodytype)){   ////分权多分部






			if(url.indexOf("MultiSubcompanyBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmSubCompanyDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

              if(fieldbodytype.equals("160")){
                rsaddop.execute("select a.level_n, a.level2_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="+fieldbodyid+" and b.nodeid in (select nodeid from workflow_flownode where workflowid="+workflowid+" ) ");
				String roleid="";
				int rolelevel_tmp = 0;
				if (rsaddop.next())
				{
				roleid=rsaddop.getString(1);
				rolelevel_tmp=Util.getIntValue(rsaddop.getString(2), 0);
				roleid += "a"+rolelevel_tmp;
				}
		bclick="onShowResourceRole('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+
			"',jQuery($GetEle('field"+fieldbodyid+"')).attr('viewtype'),'"+roleid+"')";
			String tempURL="javascript:getajaxurl(" + fieldbodytype +",'','','"+fieldbodyid+"','"+roleid+"')";
%>
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%=tempURL%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldbodytype%>'> </brow:browser>
<!--
        <button type=button class=Browser  onclick="onShowResourceRole('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',jQuery($GetEle('field<%=fieldbodyid%>')).attr('viewtype'),'<%=roleid%>')" title="<%=SystemEnv.getHtmlLabelName(20570,userlanguage)%>"></button>
	-->
<%
			  }else if(fieldbodytype.equals("278")){
					if(trrigerfield.indexOf("field"+fieldbodyid)>=0){
						bclick="onShowBrowser3('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+
								fieldbodytype+"','"+isbodymand+"');datainput('field"+fieldbodyid+"');";
					}else{
						bclick="onShowBrowser3('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+
								fieldbodytype+"','"+isbodymand+"')";
					}
					
				%>
				<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser="true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(24)"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldbodytype%>'> </brow:browser>
			   <%
		        }else if(fieldbodytype.equals("161")||fieldbodytype.equals("162")){
              url+="?type="+fielddbtype;
			bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+
				"',jQuery($GetEle('field"+fieldbodyid+"')).attr('viewtype'));";
				String compurl = "javascript:getajaxurl(" + fieldbodytype + ",'"+fielddbtype+"','','"+fieldbodyid+"')";
%>		
							   <%if(fieldbodytype.equals("161")||fieldbodytype.equals("162")){%>
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' nameSplitFlag='~~WEAVERSplitFlag~~'
	browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>'  completeUrl='<%=compurl%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldbodytype%>'> </brow:browser>
							   <%}else{%>
							   	   
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>'  completeUrl='<%=compurl%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldbodytype%>'> </brow:browser>
							   <%}%>
<!--
       <button type=button class=Browser  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',jQuery($GetEle('field<%=fieldbodyid%>')).attr('viewtype'));<%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>datainput('field<%=fieldbodyid%>',jQuery($GetEle('field<%=fieldbodyid%>')).attr('viewtype'));<%}%>"></button>
-->
<%
			  }
              else if(fieldbodytype.equals("141")){
		bclick="onShowResourceConditionBrowser('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+
			fieldbodytype+"',jQuery($GetEle('field"+fieldbodyid+"')).attr('viewtype'))";
%>
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldbodytype%>'> </brow:browser>
<!--
        <button type=button class=Browser  onclick="onShowResourceConditionBrowser('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',jQuery($GetEle('field<%=fieldbodyid%>')).attr('viewtype'))" title="<%=SystemEnv.getHtmlLabelName(172,userlanguage)%>"></button>
	-->
<%
			  }	else if(fieldbodytype.equals("34")){//added by wcd 2015-08-18
			%>
				<select class="inputstyle" size="1" viewtype="<%=isbodymand%>" name="newLeaveType" id="<%="field"+fieldbodyid%>" onchange="setLeaveTypeValue(this.value);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype);">
					<option value=''></option>
				<%
					List leaveTypeList = leaveTypeColorManager.find("[map]field002:1");
					int leaveTypeSize = leaveTypeList == null ? 0 : leaveTypeList.size();
					HrmLeaveTypeColor leaveTypeBean = null;
					for(int leaveTypeIndex=0; leaveTypeIndex<leaveTypeSize; leaveTypeIndex++) {
						leaveTypeBean = (HrmLeaveTypeColor)leaveTypeList.get(leaveTypeIndex);
				%>
						<option value='<%=leaveTypeBean.getField004()%>' <%=showid.equals(String.valueOf(leaveTypeBean.getField004())) ? "selected" : ""%>><%=leaveTypeBean.getTitle(user.getLanguage())%></option>
				<%	}
				%>
				</select>
				<span id="field<%=fieldbodyid%>span"><%if(isbodymand.equals("1")) out.println("<img src='/images/BacoError_wev8.gif' align=absMiddle>");%></span>
			   <script>
				jQuery(document).ready(function(){
					var newLeaveType = $GetEle("newLeaveType");
					$(newLeaveType).selectbox('hide');
					jQuery(newLeaveType).autoSelect({showAll: 'true'});
				});
				function setLeaveTypeValue(vl) {
					jQuery("input[name=<%="field"+fieldbodyid%>]").val(vl);
					try{showVacationInfo();}catch(e){}
				}
			   </script>
			<%
			  } else
//add by fanggsh 20060621 for TD4528 end
                if(!fieldbodytype.equals("37")&&!fieldbodytype.equals("9")) {
					session.setAttribute("relaterequest","new");
		if(fieldbodytype.equals("2") || fieldbodytype.equals("19")){
		%>
		   <button type=button class="<%=fieldbodytype.equals("19")?"Clock":"calendar"%>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
			  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',jQuery($GetEle('field<%=fieldbodyid%>')).attr('viewtype'));datainput('field<%=fieldbodyid%>');"
		   <%}else{%>
			  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',jQuery($GetEle('field<%=fieldbodyid%>')).attr('viewtype'))"
		   <%}%> 
			  title="<%=SystemEnv.getHtmlLabelName(172,userlanguage)%>">
		   </button>
	<%
		}else if(fieldbodytype.equals("178")){
	%>
			<button type=button class=Browser <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
			  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',jQuery($GetEle('field<%=fieldbodyid%>')).attr('viewtype'));datainput('field<%=fieldbodyid%>');"
		   <%}else{%>
			  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',jQuery($GetEle('field<%=fieldbodyid%>')).attr('viewtype'))"
		   <%}%> 
			  title="<%=SystemEnv.getHtmlLabelName(172,userlanguage)%>">
		   </button>
	<%
		}else if (fieldbodytype.equals("256")
				|| fieldbodytype.equals("257")) {
			bclick = "onShowBrowser2('" + fieldbodyid + "','"+url+"','"+linkurl+"','"+fieldbodytype+"',$G('field"+fieldbodyid+"').getAttribute('viewtype'));";
	%>
	<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid %>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldbodytype%>'> </brow:browser>
	<%
    }else if(fieldbodytype.equals("58")){   //城市
		 String showcityname=Util.formatMultiLang(showname);
        %>
        <div areaType="city" areaName="<%="field"+fieldbodyid%>" areaValue="<%=showid%>" 
        areaSpanValue="<%=showcityname%>"  areaMustInput="<%=isbrowisMust %>"  areaCallback="browAreaSelectCallback"  class="_areaselect" id="_areaselect_<%="field"+fieldbodyid%>"></div>
        <script type="text/javascript">
         areromancedivbyid("_areaselect_<%="field"+fieldbodyid%>",-1);
        </script>
        <% 
    }else if(fieldbodytype.equals("263")){    //区县
			String showcitytwoname=Util.formatMultiLang(showname);
        %>
        <div areaType="citytwo" areaName="<%="field"+fieldbodyid%>" areaValue="<%=showid%>" 
        areaSpanValue="<%=showcitytwoname %>"  areaMustInput="<%=isbrowisMust %>"  areaCallback="browAreaSelectCallback"  class="_areaselect" id="_areaselect_<%="field"+fieldbodyid%>"></div>
        <script type="text/javascript">
         areromancedivbyid("_areaselect_<%="field"+fieldbodyid%>",-1);
        </script>
        <% 
	}else{
					//  多文档特殊处理






		if(trrigerfield.indexOf("field"+fieldbodyid)>=0){
			bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+
				"',jQuery($GetEle('field"+fieldbodyid+"')).attr('viewtype'));";
		}else{
			bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+
				"',jQuery($GetEle('field"+fieldbodyid+"')).attr('viewtype'))";
		}
		String hasInputStr = "true";
		//if(fieldbodytype.equals("256")||fieldbodytype.equals("257")){
		//	hasInputStr = "false";
		//}
	   %>
		
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput='<%=hasInputStr %>' isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'
		hasAdd='<%=fieldbodytype.equals("17") + "" %>' addBtnClass="resAddGroupClass" addOnClick='<%="showrescommongroup(this, " + fieldbodyid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldbodytype%>'> </brow:browser>
		<!--
       <button type=button class=Browser <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
	      onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',jQuery($GetEle('field<%=fieldbodyid%>')).attr('viewtype'));datainput('field<%=fieldbodyid%>');"
	   <%}else{%>
		  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',jQuery($GetEle('field<%=fieldbodyid%>')).attr('viewtype'))"
	   <%}%> 
		  title="<%=SystemEnv.getHtmlLabelName(172,userlanguage)%>">
	   </button>
	   -->
        <%  }
		}else if(fieldbodytype.equals("37")){                         // 如果是多文档字段,加入新建文档按钮
			bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+
				"',jQuery($GetEle('field"+fieldbodyid+"')).attr('viewtype'))";
       %>
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'
		hasAdd="true" addOnClick='<%="onNewDoc(" + fieldbodyid + ")"%>' linkUrl='<%=linkurl%>' type='<%=fieldbodytype%>'> </brow:browser>
<!--
        <button type=button class=AddDocFlow onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',jQuery($GetEle('field<%=fieldbodyid%>')).attr('viewtype'))" > <%=SystemEnv.getHtmlLabelName(611,userlanguage)%></button>
        &nbsp;&nbsp<button type=button class=AddDocFlow onclick="onNewDoc(<%=fieldbodyid%>)" title="<%=SystemEnv.getHtmlLabelName(82,userlanguage)%>"><%=SystemEnv.getHtmlLabelName(82,userlanguage)%></button>
		-->
		
       <%}else if(fieldbodytype.equals("9") && fieldbodyid.equals(flowDocField)&&docFlags.equals("1")){       // 如果是单文档正文字段,加入新建文档按钮
	        if(!"1".equals(newTNflag)){
				if(trrigerfield.indexOf("field"+fieldbodyid)>=0){
					bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+
						fieldbodytype+"',jQuery($GetEle('field"+fieldbodyid+
						"')).attr('viewtype'));";
				}else{
					bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+
						fieldbodytype+"',jQuery($GetEle('field"+fieldbodyid+
						"')).attr('viewtype'))";
				}
	   %>
	   
	   <%
	   boolean iscreatenewdoc = false;
	   String createnewdocfun = "";
		if(fieldbodytype.equals("9")&&docFlags.equals("1") && fieldbodyid.equals(flowDocField))  ///是否有流程建文档s
		{
		    iscreatenewdoc = true;
		    createnewdocfun = "createDoc('" + fieldbodyid + "','')";
        }
		%>
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'
		hasAdd='<%=iscreatenewdoc + "" %>' addOnClick='<%=createnewdocfun %>'  addBtnID="createdoc" linkUrl='<%=linkurl%>' type='<%=fieldbodytype%>'
		> </brow:browser>
       <%}else{
	   boolean iscreatenewdoc = false;
	   String createnewdocfun = "";
		if(fieldbodytype.equals("9")&&docFlags.equals("1") && fieldbodyid.equals(flowDocField))  ///是否有流程建文档s
		{
		    iscreatenewdoc = true;
		    createnewdocfun = "createDoc('" + fieldbodyid + "','')";
        }
%>
		<brow:browser viewType="0" browBtnDisabled="none" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="false" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'
		hasAdd='<%=iscreatenewdoc + "" %>' addOnClick='<%=createnewdocfun %>'  addBtnID="createdoc" linkUrl='<%=linkurl%>' type='<%=fieldbodytype%>'
		> </brow:browser>
<%
	        }
        }else{
			if(trrigerfield.indexOf("field"+fieldbodyid)>=0){
				bclick="onShowBrowser3('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+
						fieldbodytype+"','"+isbodymand+"');datainput('field"+fieldbodyid+"');";
			}else{
				bclick="onShowBrowser3('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+
						fieldbodytype+"','"+isbodymand+"')";
			}
			
		%>
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser="true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldbodytype%>'> </brow:browser>
		<!--
	    <button type=button class=Browser <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
	      onclick="onShowBrowser3('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>','<%=isbodymand%>');datainput('field<%=fieldbodyid%>');"
	   <%}else{%>
		  onclick="onShowBrowser3('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>','<%=isbodymand%>')"
	   <%}%> 
		  title="<%=SystemEnv.getHtmlLabelName(172,userlanguage)%>">
	    </button>
		-->
	   <%}

           if(fieldbodytype.equals("9")&&docFlags.equals("1") && fieldbodyid.equals(flowDocField))  ///是否有流程建文档s
           {%>
           <!-- 
           <span id="CreateNewDoc"><button type=button id="createdoc" class=AddDocFlow onclick="createDoc('<%=fieldbodyid%>','')" title="<%=SystemEnv.getHtmlLabelName(82,userlanguage)%>"><%=SystemEnv.getHtmlLabelName(82,userlanguage)%></button>
           </span>
            -->
           <%}
        }
	   if(fieldbodytype.equals("161")||fieldbodytype.equals("162")){%>
	   <input type=hidden viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" value="<%=showid%>" onpropertychange="<%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>datainput('field<%=fieldbodyid%>');<%}%>">
       <%}
       else if (fieldbodytype.equals("9")&&docFlags.equals("1")) {%>
		<input type=hidden viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" value="<%=showid%>"  <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onpropertychange="datainput('field<%=fieldbodyid%>');" <%}%>>
      <%} else {%>
        <input type=hidden viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" value="<%=showid%>" onpropertychange="checkLengthbrow('field<%=fieldbodyid%>','field<%=fieldbodyid%>span','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,userlanguage)%>','<%=SystemEnv.getHtmlLabelName(20247,userlanguage)%>',field<%=fieldbodyid%>.viewtype);<%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>datainput('field<%=fieldbodyid%>');<%}%>" >
		<%}%>
		<%if(!isbodyedit.equals("1") || fieldbodytype.equals("2") || fieldbodytype.equals("19")  || fieldbodytype.equals("178")){ %>
		
        <span id="field<%=fieldbodyid%>span"><%=Util.toScreen(showname,userlanguage)%>
       <%   if(isbodymand.equals("1") && showname.equals("")) {
       %>
           <img src="/images/BacoError_wev8.gif" align=absmiddle>
       <%
            }
       %>
        </span>
        &nbsp;&nbsp;
		<%}%>
        <%if(fieldbodytype.equals("87")||fieldbodytype.equals("184")){%>
        &nbsp;&nbsp;<A href="/meeting/report/MeetingRoomPlan.jsp" target="blank"><%=SystemEnv.getHtmlLabelName(2193,userlanguage)%></A>
        <%}%>
       <%
        if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
        }                                                       // 浏览按钮条件结束
	    else if(fieldbodyhtmltype.equals("4")) {                  // check框






	   %>
        <input type=checkbox viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" value=1<%if(preAdditionalValue.equals("1")){%> checked<%}%>  name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" <%if(isbodyedit.equals("0")){%> DISABLED <%}%> <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onChange="datainput('field<%=fieldbodyid%>');" <%}%>><!--modified by xwj for td3130 20051124-->
       <%
        if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
        }                                                       // check框条件结束






        else if(fieldbodyhtmltype.equals("5")){                     // 选择框   select
        	//添加事件信息
        	String uploadMax = "";
        	if(fieldbodyid.equals(selectedfieldid)&&uploadType==1)
        	{
        		uploadMax = "changeMaxUpload('field"+fieldbodyid+"');reAccesoryChanage();";
        	}
        	//处理select字段联动
         	String onchangeAddStr = "";
        	int childfieldid_tmp = 0;
        	if("0".equals(isbill)){
        		rs_item.execute("select childfieldid from workflow_formdict where id="+fieldbodyid);
        	}else{
        		rs_item.execute("select childfieldid from workflow_billfield where id="+fieldbodyid);
        	}
        	if(rs_item.next()){
	       		childfieldid_tmp = Util.getIntValue(rs_item.getString("childfieldid"), 0);
        	}
        	int firstPfieldid_tmp = 0;
        	boolean hasPfield = false;
        	if("0".equals(isbill)){
        		rs_item.execute("select id from workflow_formdict where childfieldid="+fieldbodyid);
        	}else{
        		rs_item.execute("select id from workflow_billfield where childfieldid="+fieldbodyid);
        	}
        	while(rs_item.next()){
        		firstPfieldid_tmp = Util.getIntValue(rs_item.getString("id"), 0);
        		if(fieldids.contains(""+firstPfieldid_tmp)){
        			hasPfield = true;
        			break;
        		}
        	}
        	if(childfieldid_tmp != 0){//如果先出现子字段，则要把子字段下拉选项清空
				onchangeAddStr = "changeChildField(this, "+fieldbodyid+", "+childfieldid_tmp+")";
			}
        	%>
        <script>
        	function funcField<%=fieldbodyid%>(){
        	    changeshowattr('<%=fieldbodyid%>_0',$G('field<%=fieldbodyid%>').value,-1,'<%=workflowid%>','<%=nodeid%>');
        	}
        	//window.attachEvent("onload", funcField<%=fieldbodyid%>);
        	if (window.addEventListener){
			    window.addEventListener("load", funcField<%=fieldbodyid%>, false);
			}else if (window.attachEvent){
			    window.attachEvent("onload", funcField<%=fieldbodyid%>);
			}else{
			    window.onload=funcField<%=fieldbodyid%>;
			}
        </script>
         <%
        if(!uploadMax.equals("")){
        %>
		<input type="hidden" id="uploadMaxField" name="uploadMaxField" isedit="<%=isbodyedit %>" value="<%=fieldbodyid%>" />
		<%
		}
		%>
        <select class=inputstyle notBeauty=true viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" <%if(isbodyedit.equals("0")){%> name="disfield<%=fieldbodyid%>" DISABLED <%}else{%>name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>"<%}%> onBlur="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.viewtype);" onChange="<%=uploadMax %>;<%if(trrigerfield.indexOf("field"+fieldbodyid)>=0 && !isbodyedit.equals("0")){%>setTimeout(function() {datainput('field<%=fieldbodyid%>')},500);<%}if(selfieldsadd.indexOf(fieldbodyid)>=0){%>changeshowattr('<%=fieldbodyid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);<%}%><%=onchangeAddStr%>" ><!--added by xwj for td3313 20051206 -->
	    <option value=""></option><!--added by xwj for td3297 20051130 -->
	   <%
            // 查询选择框的所有可以选择的值






	   boolean checkempty = true;//xwj for td3313 20051206
	   //xwj for td3313 20051206
	   String isAccordToSubCom="";
	   if(hasPfield==false || isbodyedit.equals("0")){
            char flag= Util.getSeparator() ;
            RecordSet_nf2.executeProc("workflow_selectitembyid_new",""+fieldbodyid+flag+isbill);
            while(RecordSet_nf2.next()){
				isAccordToSubCom = Util.null2String(RecordSet_nf2.getString("isAccordToSubCom"));
                String tmpselectvalue = Util.null2String(RecordSet_nf2.getString("selectvalue"));
                String tmpselectname = Util.toScreen(RecordSet_nf2.getString("selectname"),userlanguage);
                String isdefault = Util.toScreen(RecordSet_nf2.getString("isdefault"),userlanguage);//xwj for td2977 20051107
                //获取选择目录的附件大小信息
          





                String tdocCategory = Util.toScreen(RecordSet_nf2.getString("docCategory"),userlanguage);
              if(isAccordToSubCom.equals("1")){	    		    	
		    	int subCompanyIdfgs=0;
		    	try{
		    		subCompanyIdfgs=Util.getIntValue(ResourceComInfo.getSubCompanyID(""+user.getUID()),0);
		    	}catch(Exception ex){
		    		
		    	}
			    	
			    rsfgs2.executeSql("SELECT docCategory FROM Workflow_SelectitemObj where fieldid="+fieldbodyid+" and selectvalue="+tmpselectvalue+" and  isBill="+isbill+" and objType='1' and objId= "+subCompanyIdfgs);		  
				while (rsfgs2.next()){
			    	 tdocCategory=Util.null2String(rsfgs2.getString("docCategory"));
					 
				   }

			   }	    
				


                if(!"".equals(tdocCategory)&&fieldbodyid.equals(selectedfieldid)&&uploadType==1)
                {
                	int tsecid = Util.getIntValue(tdocCategory.substring(tdocCategory.lastIndexOf(",")+1),-1);
                	String tMaxUploadFileSize = ""+Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+tsecid),5);
                	secMaxUploads.put(tmpselectvalue,tMaxUploadFileSize);
                    secCategorys.put(tmpselectvalue,tdocCategory);
                	if("y".equals(isdefault)||tmpselectvalue.equals(preAdditionalValue)){
				          maxUploadImageSize = Util.getIntValue(tMaxUploadFileSize,5);
                          docCategory=tdocCategory;
				    }
                }
				         /* -------- xwj for td3313 20051206 begin -*/
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
				         /* -------- xwj for td3313 20051206 end -*/
	   %>
	    <option value="<%=tmpselectvalue%>"  <%if("".equals(preAdditionalValue)){if("y".equals(isdefault)){%>selected<%}}else{if(tmpselectvalue.equals(preAdditionalValue)){%>selected<%}}//xwj for td2977 20051107%> ><%=tmpselectname%></option><!--modified by xwj for td3130 20051124-->
	   <%
            }
       }else{
           char flag= Util.getSeparator();
           RecordSet_nf2.executeProc("workflow_selectitembyid_new",""+fieldbodyid+flag+isbill);
           while(RecordSet_nf2.next()){
			   isAccordToSubCom = Util.null2String(RecordSet_nf2.getString("isAccordToSubCom"));
               String tmpselectvalue = Util.null2String(RecordSet_nf2.getString("selectvalue"));
               String tmpselectname = Util.toScreen(RecordSet_nf2.getString("selectname"),userlanguage);
               String isdefault = Util.toScreen(RecordSet_nf2.getString("isdefault"),userlanguage);//xwj for td2977 20051107
                //获取选择目录的附件大小信息






                String tdocCategory = Util.toScreen(RecordSet_nf2.getString("docCategory"),userlanguage);


				 if(isAccordToSubCom.equals("1")){	    		    	
		    	int subCompanyIdfgs=0;
		    	try{
		    		subCompanyIdfgs=Util.getIntValue(ResourceComInfo.getSubCompanyID(""+user.getUID()),0);
		    	}catch(Exception ex){
		    		
		    	}
			    	
			    rsfgs2.executeSql("SELECT docCategory FROM Workflow_SelectitemObj where fieldid="+fieldbodyid+" and selectvalue="+tmpselectvalue+" and  isBill="+isbill+" and objType='1' and objId= "+subCompanyIdfgs);		  
				while (rsfgs2.next()){
			    	 tdocCategory=Util.null2String(rsfgs2.getString("docCategory"));
					 
				   }

			   }	    
                if(!"".equals(tdocCategory)&&fieldbodyid.equals(selectedfieldid)&&uploadType==1)
                {
                	int tsecid = Util.getIntValue(tdocCategory.substring(tdocCategory.lastIndexOf(",")+1),-1);
                	String tMaxUploadFileSize = ""+Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+tsecid),5);
                	secMaxUploads.put(tmpselectvalue,tMaxUploadFileSize);
                    secCategorys.put(tmpselectvalue,tdocCategory);
                	if("y".equals(isdefault)||tmpselectvalue.equals(preAdditionalValue)){
				          maxUploadImageSize = Util.getIntValue(tMaxUploadFileSize,5);
                          docCategory=tdocCategory;
				    }
                }
				if("".equals(preAdditionalValue)){
					if("y".equals(isdefault)){
				    	checkempty = false;
				        finalvalue = tmpselectvalue;
				    }
				}else{
				    if(tmpselectvalue.equals(preAdditionalValue)){
				    	checkempty = false;
				        finalvalue = tmpselectvalue;
				    }
				}
           }
       	selectInitJsStr += "doInitChildSelect("+fieldbodyid+","+firstPfieldid_tmp+",\""+finalvalue+"\");\n";
       }
       %>
	    </select>
	    <!--xwj for td3313 20051206 begin-->
	    <span id="field<%=fieldbodyid%>span">
	    <%
	     if(isbodymand.equals("1") && checkempty){
	    %>
       <img src='/images/BacoError_wev8.gif' align=absMiddle>
      <%
            }
       %>
	     </span>
	    <%if(isbodyedit.equals("0")){%>
        <input type=hidden class=Inputstyle name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" value="<%=finalvalue%>"
            onpropertychange="datainput('field<%=fieldbodyid%>');"
         >
      <%}%>
	    <!--xwj for td3313 20051206 end-->
       <%
        if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
        }                                                       // 选择框   select结束
       //add by xhheng @20050310 for 附件上传
       else if(fieldbodyhtmltype.equals("6")){

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
          if(fieldbodytype.equals("2")){
              picfiletypes=BaseBean.getPropValue("PicFileTypes","PicFileTypes");
              filetypedesc="Images Files";
          }

      %>
            <%if(isbodyedit.equals("1")){
                boolean canupload=true;
                if(uploadType == 0){if("".equals(mainId) && "".equals(subId) && "".equals(secId)){
                    canupload=false;
            %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,userlanguage)+SystemEnv.getHtmlLabelName(92,userlanguage)+SystemEnv.getHtmlLabelName(15808,userlanguage)%>!</font>
           <%}}else if(!isCanuse){
               canupload=false;
           %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,userlanguage)+SystemEnv.getHtmlLabelName(92,userlanguage)+SystemEnv.getHtmlLabelName(15808,userlanguage)%>!</font>
           <%}
           if(canupload){
               uploadfieldids.add(fieldbodyid);
           %>
            <script>
          var oUpload<%=fieldbodyid%>;
          function fileupload<%=fieldbodyid%>() {
			  var language =  <%=userlanguage%> ;
			  //alert("===language===="+language);
			  var settings;
			  if (language == 8)
			  {
				  settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId": "<%=mainId%>",
                "subId":"<%=subId%>",
                "secId":"<%=secId%>",
                "userid":"<%=userid%>",
                "logintype":"<%=logintype%>",
                "workflowid":"<%=workflowid%>"
            },
            file_size_limit :"<%=maxUploadImageSize%> MB",
            file_types : "<%=picfiletypes%>",
            file_types_description : "<%=filetypedesc%>",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgress<%=fieldbodyid%>",
                cancelButtonId : "btnCancel<%=fieldbodyid%>",
                uploadspan : "field_<%=fieldbodyid%>span",
                uploadfiedid : "field<%=fieldbodyid%>"
            },
            debug: false,


            // Button settings

            button_image_url : "/images/ecology8/workflow/fileupload/begin1_wev8-2.png",    // Relative to the SWF file
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldbodyid%>",

            button_width: 144,
            button_height: 26,
            //button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,userlanguage)%></span>',
            //button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
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
			  }	else{
         settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId": "<%=mainId%>",
                "subId":"<%=subId%>",
                "secId":"<%=secId%>",
                "userid":"<%=userid%>",
                "logintype":"<%=logintype%>",
                "workflowid":"<%=workflowid%>"
            },
            file_size_limit :"<%=maxUploadImageSize%> MB",
            file_types : "<%=picfiletypes%>",
            file_types_description : "<%=filetypedesc%>",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgress<%=fieldbodyid%>",
                cancelButtonId : "btnCancel<%=fieldbodyid%>",
                uploadspan : "field_<%=fieldbodyid%>span",
                uploadfiedid : "field<%=fieldbodyid%>"
            },
            debug: false,


            // Button settings

            button_image_url : "/images/ecology8/workflow/fileupload/begin1_wev8-0.png",    // Relative to the SWF file
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldbodyid%>",

            button_width: 104,
            button_height: 26,
            button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,userlanguage)%></span>',
            //button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
            button_text_style : '.button { font-family: Microsoft YaHei; font-size: 12px;color:#ffffff;} .buttonSmall { font-size: 10px; }',
			button_text_top_padding: 2,
			button_text_left_padding: 22,

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
			  }

        try {
            oUpload<%=fieldbodyid%>=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	//window.attachEvent("onload", fileupload<%=fieldbodyid%>);
          	if (window.addEventListener){
			    window.addEventListener("load", fileupload<%=fieldbodyid%>, false);
			}else if (window.attachEvent){
			    window.attachEvent("onload", fileupload<%=fieldbodyid%>);
			}else{
			    window.onload=fileupload<%=fieldbodyid%>;
			}
        </script>
      <TABLE class="ViewForm" style="width:400px;">
          <tr>
              <td colspan="2" style="background-color:#ffffff;">
                     <div>
                      <span id="uploadspan" style="display:inline-block;line-height: 32px;"><%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>
	                  </span>
	                  <%
						if(isbodymand.equals("1")){
						%>
						<span id="field_<%=fieldbodyid%>span" style='display:inline-block;line-height: 32px;color:red;font-weight:normal;'><%=SystemEnv.getHtmlLabelName(81909,user.getLanguage())%></span>
						<%
							}else{
					   	%>
					   	<span id="field_<%=fieldbodyid%>span" style='display:inline-block;line-height: 32px;color:red;font-weight:normal;'></span>
					   	<%
							}
					   	%>
					</div>
	                  <div style="height: 30px;">
	                  <div style="float:left;">
	                  <span>
	                  	<span id="spanButtonPlaceHolder<%=fieldbodyid%>"></span><!--选取多个文件-->
	                  </span>
	                  </div>
                      
                      <div style="width:10px!important;height:3px;float:left;"></div>
				
						<div style="height: 30px;float:left;">
						<%--
						<span disabled style="display:inline-block;height:25px;cursor:pointer;text-align:center;vertical-align:middle;line-height:23px;background-color: #dfdfdf;color:#999999;padding:0 20px 0 14px;" onclick="clearAllQueue(oUpload<%=fieldbodyid%>);showmustinput(oUpload<%=fieldbodyid%>);"><img src='/images/ecology8/workflow/fileupload/clearallenable_wev8.png' style="width:20px;height:20px;" align=absMiddle><%= SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></span>
		                 --%>
						
						<button type="button" id="btnCancel<%=fieldbodyid%>" disabled="disabled" style="height:25px;text-align:center;vertical-align:middle;line-height:23px;background-color: #dfdfdf;color:#999999;padding:0 10px 0 4px;" onclick="clearAllQueue(oUpload<%=fieldbodyid%>);showmustinput(oUpload<%=fieldbodyid%>);" onmouseover="changebuttonon(this)" onmouseout="changebuttonout(this)"><img src='/images/ecology8/workflow/fileupload/clearallenable_wev8.png' style="width:20px;height:20px;" align=absMiddle><%= SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></button>
		                <span id="field_<%=fieldbodyid%>spantest" style="display:none;">
						<%
						if(isbodymand.equals("1")){
						needcheck+=",field"+fieldbodyid;
						%>
					   	<img src='/images/BacoError_wev8.gif' align=absMiddle> 
					  	<%
							}
					   	%>
			    	 	</span>
					<%--<span style="color:gray;cursor:pointer;TEXT-DECORATION:none" disabled onclick="oUpload<%=fieldbodyid%>.cancelQueue();showmustinput(oUpload<%=fieldbodyid%>);" id="btnCancel<%=fieldbodyid%>">
						<span><img src="/js/swfupload/delete_wev8.gif" border="0"></span>
						<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,userlanguage)%></font><!--清除所有选择--></span>
                      <span id="field<%=fieldbodyid%>span">
						 --%>
					</div>
              <div style="clear:both;"></div>
              </div>
                  <input  class=InputStyle  type=hidden size=60 name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>"  viewtype="<%=isbodymand%>">
              </td>
          </tr>
          <tr>
              <td colspan="2" style="background-color:#ffffff;">
              	  <div class="_uploadForClass">
	                  <div class="fieldset flash" id="fsUploadProgress<%=fieldbodyid%>">
	                  </div>
					</div>
                  <div id="divStatus<%=fieldbodyid%>"></div>
              </td>
          </tr>
      </TABLE>
            <%}%>
          <input type=hidden name='mainId' value=<%=mainId%>>
          <input type=hidden name='subId' value=<%=subId%>>
          <input type=hidden name='secId' value=<%=secId%>>
      <%
              }
            if(changefieldsadd.indexOf(fieldbodyid)>=0){
        		%>
        				<input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
        		<%
        			}
       }                                          // 选择框条件结束 所有条件判定结束






       else if(fieldbodyhtmltype.equals("7")){//特殊字段
           if(isbill.equals("0")) out.println(Util.null2String((String)specialfield.get(fieldbodyid+"_0")));
           else out.println(Util.null2String((String)specialfield.get(fieldbodyid+"_1")));
       }
       else if(fieldbodyhtmltype.equals("9")){ // 位置字段
           out.println("<span>"+SystemEnv.getHtmlLabelName(126181, user.getLanguage())+"</span>");    //暂无位置信息
       }
       %>
      </td>
    </tr>
	 <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
<%
    }       // 循环结束
%>
<input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">
<%
//add by mackjoe at 2006-06-07 td4491 有明细时才加载






boolean  hasdetailb=false;
if(!(isbill.equals("1")&&(formid==7||formid==156||formid==157||formid==158||formid==159))){
if(isbill.equals("0")) {
    RecordSet_nf1.executeSql("select count(*) from workflow_formfield  where isdetail='1' and formid="+formid);
}else{
    RecordSet_nf1.executeSql("select count(*) from workflow_billfield  where viewtype=1 and billid="+formid);
}
if(RecordSet_nf1.next()){
    if(RecordSet_nf1.getInt(1)>0) hasdetailb=true;
}
}
if(hasdetailb){
	if(!"".equals(fieldUrl)) {
		fieldUrl = URLEncoder.encode(fieldUrl);
	}
%>
  </table>
  <jsp:include page="WorkflowAddRequestDetailBody.jsp" flush="true">
		<jsp:param name="workflowid" value="<%=workflowid%>" />
		<jsp:param name="nodeid" value="<%=nodeid%>" />
		<jsp:param name="formid" value="<%=formid%>" />
        <jsp:param name="detailsum" value="<%=detailsum%>"/>
        <jsp:param name="isbill" value="<%=isbill%>"/>
        <jsp:param name="currentdate" value="<%=currentdate%>" />
		<jsp:param name="currenttime" value="<%=currenttime%>" />
        <jsp:param name="needcheck" value="<%=needcheck%>" />
		<jsp:param name="prjid" value="<%=prjid%>" />
		<jsp:param name="reqid" value="<%=reqid%>" />
		<jsp:param name="docid" value="<%=docid%>" />
		<jsp:param name="hrmid" value="<%=hrmid%>" />
		<jsp:param name="crmid" value="<%=crmid%>" />
		<jsp:param name="fieldUrl" value="<%=fieldUrl %>" />
  </jsp:include>

<%}%>

    </table>
    
    
    <%
  //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
    //add by cyril on 2008-09-30 for td:9014
		boolean isSuccess  = RecordSet_nf1.executeProc("sysPhrase_selectByHrmId",""+userid);
		String workflowPhrases[] = new String[RecordSet_nf1.getCounts()];
		String workflowPhrasesContent[] = new String[RecordSet_nf1.getCounts()];
		int m = 0 ;
		if (isSuccess) {
			while (RecordSet_nf1.next()){
				workflowPhrases[m] = Util.null2String(RecordSet_nf1.getString("phraseShort"));
				workflowPhrasesContent[m] = Util.toHtml(Util.null2String(RecordSet_nf1.getString("phrasedesc")));
				m ++ ;
			}
		}
		//end by cyril on 2008-09-30 for td:9014
		
		String isSignMustInput="0";
		String isHideInput="0";
		String isFormSignature=null;
		int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
		int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
		RecordSet_nf1.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight,issignmustinput,ishideinput from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
		if(RecordSet_nf1.next()){
		isFormSignature = Util.null2String(RecordSet_nf1.getString("isFormSignature"));
		formSignatureWidth= Util.getIntValue(RecordSet_nf1.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
		formSignatureHeight= Util.getIntValue(RecordSet_nf1.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
		isSignMustInput = ""+Util.getIntValue(RecordSet_nf1.getString("issignmustinput"), 0);
		isHideInput = ""+Util.getIntValue(RecordSet_nf1.getString("ishideinput"), 0);
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
	%>
	
     <%@ include file="/workflow/request/WorkflowSignInput.jsp" %>


<input type=hidden name="workflowid" value="<%=workflowid%>">       <!--工作流id-->
<input type=hidden name="workflowtype" value="<%=workflowtype%>">   <!--工作流类型-->
<input type=hidden name="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" value="0">                     <!--当前节点类型-->
<input type=hidden name="src">                                    <!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" value="1">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="topage" value="<%=topage%>">            <!--创建结束后返回的页面-->
<input type=hidden name ="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name ="method">                                <!--新建文档时候 method 为docnew-->

<input type=hidden name ="isremark" value="-1">
<input type=hidden name ="isMultiDoc" value=""><!--多文档新建-->

<input type=hidden name ="requestid" value="-1">
<input type=hidden name="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" value="">
<iframe name="delzw" width=0 height=0 style="border:none"></iframe>

<script language=javascript>


jQuery(document).ready(function(){
	try{
  	  <%if(!"".equals(finalvalue.trim())){%>
  		  jQuery("#selectfieldvalue").val("<%=finalvalue%>");
  	  <%}%>
  	}catch(e){}
});

//单行文本-整数
function ItemCount_Keydown(obj){
		obj.value=obj.value.replace(/[^\d]/g,"");
}
function ItemCount_Onpaste(obj){
	obj.value=obj.value.replace(/[^ -~]/g,"");
}
//单行文本-整数

	//2012-08-22 ypc 添加此js函数处理金额转换
	
	//function clearNoNum(obj)
		//{
			//先把非数字的都替换掉，除了数字和.
			//obj.value = obj.value.replace(/[^\d.]/g,"");
			//必须保证第一个为数字而不是.
			//obj.value = obj.value.replace(/^\./g,"");
			//保证只有出现一个.而没有多个.
			//obj.value = obj.value.replace(/\.{2,}/g,".");
			//保证.只出现一次，而不能出现两次以上






			//obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
		//}
	//2012-08-22 ypc 添加此js函数处理金额转换
//默认大小
var maxUploadImageSize = <%=maxUploadImageSize%>;
var uploaddocCategory="<%=docCategory%>";
//增加maxUpload参数，如果为0，表明为实时检测






function accesoryChanage(obj,maxUpload)
{
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;
        fileLenth= File.getFileSize();
    } catch (e){
        //alert('<%=SystemEnv.getHtmlLabelName(20253,userlanguage)%>');
		if(e.message=="<%=SystemEnv.getHtmlLabelName(83411,user.getLanguage())%>"||e.message=="<%=SystemEnv.getHtmlLabelName(83411,user.getLanguage())%>"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,userlanguage)%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,userlanguage)%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1);
    if(parseFloat(maxUpload)<=0)
    {
    	maxUpload = maxUploadImageSize;
    }
    if (fileLenthByM>maxUpload) {
        alert("<%=SystemEnv.getHtmlLabelName(20254,userlanguage)%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,userlanguage)%>"+maxUpload+"M<%=SystemEnv.getHtmlLabelName(20256 ,userlanguage)%>");
        createAndRemoveObj(obj);
    }
}
//填充选择目录的附件大小信息






var selectValues = new Array();
var maxUploads = new Array();
var uploadCategorys=new Array();
function setMaxUploadInfo()
{
<%
if(secMaxUploads!=null&&secMaxUploads.size()>0)
{
	Set selectValues = secMaxUploads.keySet();

	for(Iterator i = selectValues.iterator();i.hasNext();)
	{
		String value = (String)i.next();
		String maxUpload = (String)secMaxUploads.get(value);
		String uplCategory=(String)secCategorys.get(value);
%>
		selectValues.push('<%=value%>');
		maxUploads.push('<%=maxUpload%>');
        uploadCategorys.push('<%=uplCategory%>');
<%
	}
}
%>
}
setMaxUploadInfo();
//目录发生变化时，重新检测文件大小



<%
if(uploadType==1 && !selectedfieldid.equals("")){
    int _selectfieldindex = inoperatefields.indexOf(selectedfieldid);
	if(_selectfieldindex>-1){
		selectfieldvalue = (String)inoperatevalues.get(_selectfieldindex);
	}
}

%>



function reAccesoryChanage()
{
    <%
    for(int i=0;i<uploadfieldids.size();i++){
    %>
    checkfilesize(oUpload<%=uploadfieldids.get(i)%>,maxUploadImageSize,uploaddocCategory);
    showmustinput(oUpload<%=uploadfieldids.get(i)%>);
    <%}%>
	checkfilesize2();
}


function changeMaxUpload2(fieldid,derecorderindex){

   var uploadMaxFieldisedit = jQuery("#uploadMaxField").attr("isedit");
   
   if(!!uploadMaxFieldisedit && uploadMaxFieldisedit=="1"){
	    var selectfieldv = jQuery("#"+fieldid).val();
		for(var i = 0;i<selectValues.length;i++)
		{
			var value = selectValues[i];
			if(value == selectfieldv)
			{
				maxUploadImageSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		jQuery("#selectfieldvalue").val(selectfieldv);	
		if(selectfieldv=="")
		{
			maxUploadImageSize = 5;
			uploaddocCategory="";
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
		}else{
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
			});
		}
	}else{
   
    <%
	if(uploadType==1){
	    if(selectfieldvalue.equals("")){
	%>
			maxUploadImageSize = 5;
			uploaddocCategory = "";
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
	<%  }else{%>
	        for(var i = 0;i<selectValues.length;i++)
			{
				var value = selectValues[i];
				if(value == "<%=selectfieldvalue%>")
				{
					maxUploadImageSize = parseFloat(maxUploads[i]);
	                uploaddocCategory=uploadCategorys[i];
				}
			}
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
			});
	<%
		}
	}
	%>
	
	}
}





//选择目录时，改变对应信息
function changeMaxUpload(fieldid)
{
	var efieldid = $GetEle(fieldid);
	if(efieldid)
	{
		var tselectValue = efieldid.value;
		for(var i = 0;i<selectValues.length;i++)
		{
			var value = selectValues[i];
			if(value == tselectValue)
			{
				maxUploadImageSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		
		var oUploadArray = new Array();
		var oUploadfieldidArray = new Array();
		<%
		if(uploadfieldids!=null){
		   	for(int i=0;i<uploadfieldids.size();i++){
		   %>
		oUploadArray.push(oUpload<%=uploadfieldids.get(i)%>);
		oUploadfieldidArray.push("<%=uploadfieldids.get(i)%>");
		<%
			}
		}
		%>
		jQuery("#selectfieldvalue").val(tselectValue);
		if(tselectValue=="")
		{
			maxUploadImageSize = 5;
			uploaddocCategory = "";
			attachmentDisabled(oUploadArray,true,oUploadfieldidArray);
			
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,userlanguage)%> \""+fieldlable+"\"");
			});
		}else{
			jQuery("span[id^='uploadspan']").each(function(){
				var viewtype = jQuery(this).attr("viewtype");
				if(viewtype == 1){
				    jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,userlanguage)%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(83528,userlanguage)%>");
				}else{
					jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,userlanguage)%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(83528,userlanguage)%>");
				}
			});
			attachmentDisabled(oUploadArray,false,oUploadfieldidArray);
		}
	}
}


<%
if(uploadType==1){
%>

function initUploadMax(){
	try{
    	<%
    	if(selectfieldvalue.equals("")){
    	%>
		setTimeout(function(){
				var oUploadArray = new Array();
				var oUploadfieldidArray = new Array();
				<%
				if(uploadfieldids!=null){
				   	for(int i=0;i<uploadfieldids.size();i++){
				   %>
				   try{
					oUploadArray.push(oUpload<%=uploadfieldids.get(i)%>);
					oUploadfieldidArray.push("<%=uploadfieldids.get(i)%>");
				   }catch(e){}
				<%
					}
				}
				%>
				maxUploadImageSize = 5;
				uploaddocCategory = "";
				attachmentDisabled(oUploadArray,true,oUploadfieldidArray);
				
				var fieldlable = "<%=selectfieldlable%>";
				jQuery("span[id^='uploadspan']").each(function(){
					jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
				});
			},2000);
		
		<%}else{%>
		
			for(var i = 0;i<selectValues.length;i++)
			{
				var value = selectValues[i];
				if(value == "<%=selectfieldvalue%>")
				{
					maxUploadImageSize = parseFloat(maxUploads[i]);
                	uploaddocCategory=uploadCategorys[i];
				}
			}
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
			});
		<%}%>
    	
    }catch(e){}
}

initUploadMax();
<%}%>
/*
function funcClsDateTime(){
	var onlstr = new clsDateTime();
}                
if (window.addEventListener){
    window.addEventListener("load", funcClsDateTime, false);
}else if (window.attachEvent){
    window.attachEvent("onload", funcClsDateTime);
}else{
    window.onload=funcClsDateTime;
}*/


function createDoc(fieldbodyid,docVlaue) //创建文档
{
	try{
		var requestid=-1;
		if($G("requestid")!=null) requestid=$G("requestid").value;
		if(parseInt(requestid)>0){
			$G("iscreate").value="0";
		}
	}catch(e){
	}
	var _isagent = "";
    var _beagenter = "";
	if($GetEle("_isagent")!=null) _isagent=$GetEle("_isagent").value;
    if($GetEle("_beagenter")!=null) _beagenter=$GetEle("_beagenter").value;
  	frmmain.action = "RequestOperation.jsp?isagent="+_isagent+"&beagenter="+_beagenter+"&docView=1&docValue="+docVlaue;
    frmmain.method.value = "crenew_"+fieldbodyid ;
    frmmain.target="delzw";
    parent.delsave();
	if(check_form(document.frmmain,'requestname')){
		if($G("needoutprint")) $G("needoutprint").value = "1";//标识点正文






        document.frmmain.src.value='save';

//保存签章数据
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
	                    try{  
					        if(typeof(eval("SaveSignature_save"))=="function"){
					              if(SaveSignature_save()){
			                            //附件上传
			                            StartUploadAll();
			                            checkuploadcompletBydoc();
			                        }else{
										if(isDocEmpty==1){
											alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,userlanguage)%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,userlanguage)%>");
											isDocEmpty=0;
										}else{
											alert("<%=SystemEnv.getHtmlLabelName(21442,userlanguage)%>");
										}
										
										return ;
									}
					        }
					    }catch(e){
					        StartUploadAll();
			                checkuploadcompletBydoc(); 
					    }
	                   
<%}else{%>
                        //附件上传
                        StartUploadAll();
                        checkuploadcompletBydoc();
<%}%>
$G("isremark").value = "0";
    }
}
function onNewDoc(fieldbodyid) {

    frmmain.action = "RequestOperation.jsp" ;
    frmmain.method.value = "docnew_"+fieldbodyid ;
    frmmain.isMultiDoc.value = fieldbodyid ;
    if(check_form(document.frmmain,'requestname')){
        //附件上传
        StartUploadAll();
        document.frmmain.src.value='save';
        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
        checkuploadcomplet();
    }
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


    function checktimeok(){         <!-- 结束日期不能小于开始日期 -->
        if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != "")
        {
            YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
            MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
            DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
            YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
            MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
            DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
            if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
                window.alert("<%=SystemEnv.getHtmlLabelName(15273,userlanguage)%>");
                return false;
            }
        }
        //qc 66179 by yl
        else{
           <%
            if( formid==181 && isbill.equals("1")){
            	
              RecordSet rsss = new RecordSet();
              String fromdateid ="";
              String sql11="Select id from workflow_billfield where billid= 181 and fieldname='fromDate' ";
              rsss.executeSql(sql11);
              if(rsss.next()){
                 fromdateid=rsss.getString("id");
              }
              String todateid="";
              String sql22="Select id from workflow_billfield where billid= 181 and fieldname='toDate' ";
              rsss.executeSql(sql22);
              if(rsss.next()){
                 todateid=rsss.getString("id");
              }            
              String fromtimeid ="";
              String sql33="Select id from workflow_billfield where billid= 181 and fieldname='fromTime' ";
              rsss.executeSql(sql33);
              if(rsss.next()){
                 fromtimeid=rsss.getString("id");
              }  
              String totimeid ="";
              String sql44="Select id from workflow_billfield where billid= 181 and fieldname='toTime' ";
              rsss.executeSql(sql44);
              if(rsss.next()){
                 totimeid=rsss.getString("id");
              } 
              
                      String dbType =   rsss.getDBType();
                      String fromdate =  "field"+fromdateid;
                      String todate     = "field"+todateid;
                      String fromtime   = "field"+fromtimeid;
                      String totime     = "field"+totimeid;                     
                      /*
                      String dbType =   rsss.getDBType();
                      String fromdate =  dbType=="sqlserver"?"field686":"field767";
                      String todate     =          dbType=="sqlserver"?"field688":"field769";
                      String fromtime   =     dbType=="sqlserver"?"field687":"field768";
                      String totime        =dbType=="sqlserver"?"field689":"field770";
                      */            	
              %>   
            YearFrom=document.frmmain.<%=fromdate%>.value.substring(0,4);
            MonthFrom=document.frmmain.<%=fromdate%>.value.substring(5,7);
            DayFrom=document.frmmain.<%=fromdate%>.value.substring(8,10);
            YearTo=document.frmmain.<%=todate%>.value.substring(0,4);
            MonthTo=document.frmmain.<%=todate%>.value.substring(5,7);
            DayTo=document.frmmain.<%=todate%>.value.substring(8,10);
            HourFrom=document.frmmain.<%=fromtime%>.value.substring(0,2);
            MinFrom = document.frmmain.<%=fromtime%>.value.substring(3,5);
            HourTo=document.frmmain.<%=totime%>.value.substring(0,2);
            MinTo = document.frmmain.<%=totime%>.value.substring(3,5);
            if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
                window.alert("<%=SystemEnv.getHtmlLabelName(17362,userlanguage)%>");
                return false;
            }
            if(document.frmmain.<%=fromdate%>.value==document.frmmain.<%=todate%>.value){
                if (!DateCompare(YearFrom, HourFrom, MinFrom,YearTo, HourTo,MinTo )){
                    window.alert("<%=SystemEnv.getHtmlLabelName(15273,userlanguage)%>");
                    return false;
                }else{
                    if(HourFrom==HourTo && MinFrom == MinTo){
                        window.alert("<%=SystemEnv.getHtmlLabelName(24981,userlanguage)%>"  +"<%=SystemEnv.getHtmlLabelName(26315,userlanguage)%>"+"<%=SystemEnv.getHtmlLabelName(17690,userlanguage)%>");
                        return false;
                    }
                }
            }
            <%
            }
             %>
        }

        return true;
    }
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
			if(formid==7||formid==156 || formid==157 || formid==158 || formid==159)
			{
				%>
			   	var rowneed = $G('rowneed').value;
			   	var nodesnum = $G('nodesnum').value;
			   	nodesnum = nodesnum*1;
			   	if(rowneed=="1")
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
        try{
	   	var rowneed = $G('rowneed<%=checkdetailno%>').value;
	   	var nodesnum = $G('nodesnum<%=checkdetailno%>').value;
	   	nodesnum = nodesnum*1;
	   	if(rowneed=="1")
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
        }catch(e2){}
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
		    	//System.out.println("checkGroupId : "+checkGroupId);
		    	%>
		    	try{
		       	var rowneed = $G('rowneed<%=checkGroupId%>').value;
		       	var nodesnum = $G('nodesnum<%=checkGroupId%>').value;
		       	nodesnum = nodesnum*1;
		       	if(rowneed=="1")
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
			   	}catch(e1){}
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
    function doSave(){              <!-- 点击保存按钮 -->
    	//var nodenum = checkNodesNum();
    	var nodenum = 0;
    	if(nodenum>0)
    	{
    		alert("<%=SystemEnv.getHtmlLabelName(24827,userlanguage)%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,userlanguage)%>!");
    		return false;
    	}
        var ischeckok="";

        try{
		if(check_form(document.frmmain, "requestname"))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
            if(check_form(document.frmmain,'<%=needcheck%>'))
                ischeckok="true";
        }

<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
                //保存时不验证签字意见必填
			    //if(!check_form(document.frmmain,'remarkText10404')){
				//    ischeckok="false";
			    //}
		    }
<%
		}
	}
%>
        if(ischeckok=="true"){
			CkeditorExt.updateContent();
            if(checktimeok()) {
                    document.frmmain.src.value='save';
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

//保存签章数据
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
                        try{  
					        if(typeof(eval("SaveSignature_save"))=="function"){
					              //保存时不验证签字意见必填
			                    if(SaveSignature_save()||!SaveSignature_save()){
		                            //TD4262 增加提示信息  开始






		                            var content="<%=SystemEnv.getHtmlLabelName(18979,userlanguage)%>";
		                            showPrompt(content);
		                            //TD4262 增加提示信息  结束
		                            //附件上传
		                            StartUploadAll();
		                            checkuploadcomplet();
		                        }else{
		
									if(isDocEmpty==1){
										alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,userlanguage)%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,userlanguage)%>");
										isDocEmpty=0;
									}else{
									    alert("<%=SystemEnv.getHtmlLabelName(21442,userlanguage)%>");
									}
									return ;
								}
					        }
					    }catch(e){
					        var content="<%=SystemEnv.getHtmlLabelName(18979,userlanguage)%>";
		                            showPrompt(content);
		                            //TD4262 增加提示信息  结束
		                            //附件上传
		                            StartUploadAll();
		                            checkuploadcomplet();
					    }
                        
<%}else{%>
						//TD4262 增加提示信息  开始






						var content="<%=SystemEnv.getHtmlLabelName(18979,userlanguage)%>";
						showPrompt(content);
						//TD4262 增加提示信息  结束
						//附件上传
						StartUploadAll();
						checkuploadcomplet();
<%}%>
                }
            }
    }
	
	function checkCustomize(){return true;}

    function doSubmit(obj){            <!-- 点击提交 -->
    	var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
    		alert("<%=SystemEnv.getHtmlLabelName(24827,userlanguage)%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,userlanguage)%>!");
    		return false;
    	}
      //modify by xhheng @20050328 for TD 1703
      //明细部必填check，通过try $GetEle("needcheck")来检查,避免对原有无明细单据的修改







        var ischeckok="";
        try{
            
        if(check_form(document.frmmain,$GetEle("needcheck").value+$GetEle("inputcheck").value))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
          if(check_form(document.frmmain,'<%=needcheck%>'))
            ischeckok="true";
        }

<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
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
		try{if(!checkCustomize()) return false;}catch(e){}//added by wcd 2015-06-25 custompage支持
		
		try{if(!checkCarSubmit()) return false;}catch(e){}//QC209437 added by 2016-08-15

        if(ischeckok=="true"){
			CkeditorExt.updateContent();
            if(checktimeok()) {
                document.frmmain.src.value='submit';
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

    	if("<%=formid%>"==201&&"<%=isbill%>"==1){//资产报废单据明细中的资产报废数量大于库存数量，不能提交。






            try{
	    	nodesnum = $GetEle("nodesnum").value;
	    	for(var tempindex1=0;tempindex1<nodesnum;tempindex1++){
	    		try{
		    		var capitalcount = $GetEle("node_"+tempindex1+"_capitalcount").value*1;
		    		var fetchingnumber=$GetEle("node_"+tempindex1+"_number").value*1;
		    		if(fetchingnumber<=capitalcount){
			    		for(var tempindex2=0;tempindex2<nodesnum;tempindex2++){
			    			try{
				    			if(tempindex2!=tempindex1&&$GetEle("node_"+tempindex1+"_capitalid").value==$GetEle("node_"+tempindex2+"_capitalid").value){
				    				fetchingnumber = fetchingnumber*1 + $GetEle("node_"+tempindex2+"_number").value*1;
				    			}
			    			}catch(e){
						    	continue;
						    }
			    		}
		    		}
		    		if(fetchingnumber>capitalcount){
		    			alert("<%=SystemEnv.getHtmlLabelName(17273,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1418,user.getLanguage())%>");
		    			return;
		    		}
	    		}catch(e){
			    	continue;
			    }
	    	}
            }catch(e){}
    	}

//保存签章数据
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
	                    try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					              if(SaveSignature()){
										//TD4262 增加提示信息  开始






										var content="<%=SystemEnv.getHtmlLabelName(18978,userlanguage)%>";
										showPrompt(content);
										//TD4262 增加提示信息  结束
										obj.disabled=true;
										//附件上传
										StartUploadAll();
										checkuploadcomplet();
			                        }else{
										if(isDocEmpty==1){
											alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,userlanguage)%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,userlanguage)%>");
											//自动跳到签字意见锚点
											window.location.hash = "#fsUploadProgressannexuploadSimple";//重置锚点,否则,下次将不能定位






											window.location.hash = null;
											jQuery("#remarkShadowDiv").hide();
											jQuery("#signtabtoolbar").css("display","");
											jQuery("#signrighttool").css("display","");
											jQuery(".signaturebyhand").css("display","");
											isDocEmpty=0;
										}else{
											alert("<%=SystemEnv.getHtmlLabelName(21442,userlanguage)%>");
										}
										return ;
									}
					        }
					    }catch(e){
					        //TD4262 增加提示信息  开始






										var content="<%=SystemEnv.getHtmlLabelName(18978,userlanguage)%>";
										showPrompt(content);
										//TD4262 增加提示信息  结束
										obj.disabled=true;
										//附件上传
										StartUploadAll();
										checkuploadcomplet(); 
					    }
	                    
	                 
<%}else{%>
						//TD4262 增加提示信息  开始






						var content="<%=SystemEnv.getHtmlLabelName(18978,userlanguage)%>";
						showPrompt(content);
						//TD4262 增加提示信息  结束
						obj.disabled=true;
						//附件上传
						StartUploadAll();
						checkuploadcomplet();
<%}%>
            }
        }
    }
	function onAddPhrase(phrase){            <!-- 添加常用短语 -->
    if(phrase!=null && phrase!=""){
			$G("remarkSpan").innerHTML = "";
			try{
				var remarkHtml = CkeditorExt.getHtml("remark");
				//var remarkText = CkeditorExt.getText("remark");
				CkeditorExt.setHtml(remarkHtml+phrase,"remark");
				
			}catch(e){alert(e)}
    }
    $G("phraseselect").options[0].selected = true;
    }
<%-----------xwj for td3131 20051115 begin -----%>
function numberToFormat(index){
    if($GetEle("field_lable"+index).value != ""){
		var floatNum = floatFormat($GetEle("field_lable"+index).value);
       	var val = numberChangeToChinese(floatNum)
       	if(val == ""){
       		alert("<%=SystemEnv.getHtmlLabelName(31181, userlanguage)%>");
            $GetEle("field"+index).value = "";
            $GetEle("field_lable"+index).value = "";
            $GetEle("field_chinglish"+index).value = "";
       	} else {
	        $GetEle("field"+index).value = floatNum;
	        $GetEle("field_lable"+index).value = milfloatFormat(floatNum);
       		$GetEle("field_chinglish"+index).value = val;
       	}
    }else{
    	$GetEle("field"+index).value = "";
    	$GetEle("field_chinglish"+index).value = "";
    }
}
function FormatToNumber(index){
	var elm = $GetEle("field_lable"+index);
	var n = getLocation(elm);
    if($GetEle("field_lable"+index).value != ""){
    	$GetEle("field_lable"+index).value = $GetEle("field"+index).value;
    }else{
    	$GetEle("field"+index).value = "";
    	$GetEle("field_chinglish"+index).value = "";
    }
	setLocation(elm,n);
}
<%-----------xwj for td3131 20051115 end -----%>
//明细表中金额转换字段调用
function numberToChinese(index){
	if($G("field_lable"+index).value != ""){
		var floatNum = floatFormat($G("field_lable"+index).value);
		var val = numberChangeToChinese(floatNum);
		if(val == ""){
			alert("<%=SystemEnv.getHtmlLabelName(31181,userlanguage)%>");
			$G("field_lable"+index).value = "";
			$G("field"+index).value = "";
		}else{
			$G("field_lable"+index).value = val;
			$G("field"+index).value = floatNum;
		}
	} else {
		$G("field"+index).value = "";
	}
}
function ChineseToNumber(index){
if($GetEle("field_lable"+index).value != ""){
	$GetEle("field_lable"+index).value = chineseChangeToNumber($GetEle("field_lable"+index).value);
	$GetEle("field"+index).value = $GetEle("field_lable"+index).value;
}
else{
	$GetEle("field"+index).value = "";
}
}
  setTimeout("doTriggerInit()",1000);
  function doTriggerInit(){
      var tempS = "<%=trrigerfield%>";
      datainput(tempS);
      //var tempA = tempS.split(",");
      //var tempInitJS = "";
      //for(var i=0;i<tempA.length;i++){
          //datainput(tempA[i]);
          //tempInitJS += "setTimeout(\"datainput('"+tempA[i]+"')\","+(i+1)*500+");";
      //}
      //eval(tempInitJS)
  }
  function datainput(parfield){                <!--数据导入-->
      //var xmlhttp=XmlHttp.create();
		try{
		if(event.propertyName && event.propertyName.toLowerCase() != "value"){
			return;
		}
		var src = event.srcElement || event.target; 
		if(src.tagName.toLowerCase() == 'button'){
			return ;
		}
	}catch(e){}
      var tempParfieldArr = parfield.split(",");
      var tempdata = "";
      var temprand = $GetEle("rand").value ;
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;
      
      for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
      	if (tempParfield != "") {
      		tempdata += $GetEle(tempParfield).value+"," ;
      	}
      <%
      if(!trrigerfield.trim().equals("")){
          ArrayList Linfieldname=ddi.GetInFieldName();
          ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          if($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+escape($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>").value);
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          if($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+escape($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>").value);
      <%
          }
          }
      %>
      }
      //alert(StrData);
      StrData += "&trgv="+tempdata+"&rand="+temprand+"&tempflag="+Math.random();
      StrData = StrData.replace(/\+/g,"%2B");
      //$GetEle("datainputform").src="DataInputFrom.jsp?"+StrData;
      if($GetEle("datainput_"+parfield)){
		  	$GetEle("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	  }else{
	  		createIframe("datainput_"+parfield);
	  		$GetEle("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	  }
      //xmlhttp.open("POST", "DataInputFrom.jsp", false);
      //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      //xmlhttp.send(StrData);
  }
  function addannexRow(accname,maxsize)
  {
  	//区分两种添加方式
  	var uploadspan = "";
  	var checkMaxUpload = 0;
  	if(accname!="field-annexupload")
  	{
  		maxsize = maxUploadImageSize;
  		uploadspan = "uploadspan";
  	}
  	else
  	{
  		checkMaxUpload = maxsize;
  	}
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
          var sHtml = "<input class=InputStyle  type=file size=60 name='"+accname+"_"+$GetEle(accname+'_num').value+"' onchange='accesoryChanage(this,"+checkMaxUpload+")'><span id='"+uploadspan+"'>(<%=SystemEnv.getHtmlLabelName(18976,userlanguage)%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,userlanguage)%>)</span> ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }

//TD4262 增加提示信息  开始






//提示窗口
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
     
     /*
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
     */
     
     var top = pTop;   
     var left = pLeft;   
     jQuery("#_xTable").css( { position : 'fixed', 'top' : top, 'left' : left } ).show();
}
//TD4262 增加提示信息  结束

function changeKeyword(){
<%
	if(titleFieldId>0&&keywordFieldId>0){
%>
	    var titleObj=$G("field<%=titleFieldId%>");
	    var keywordObj=$G("field<%=keywordFieldId%>");

        if(titleObj!=null&&keywordObj!=null){

		    $G("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&operation=UpdateKeywordData&docTitle="+titleObj.value+"&docKeyword="+keywordObj.value;
	    }
<%
    }else if(titleFieldId==-3&&keywordFieldId>0){
%>
	    var titleObj=$G("requestname");
	    var keywordObj=$G("field<%=keywordFieldId%>");

        if(titleObj!=null&&keywordObj!=null){

		    $G("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&operation=UpdateKeywordData&docTitle="+titleObj.value+"&docKeyword="+keywordObj.value;
	    }
<%
   }
%>
}

function updateKeywordData(strKeyword){
<%
	if(keywordFieldId>0){
%>
	var keywordObj=$G("field<%=keywordFieldId%>");

    var keywordismand=<%=keywordismand%>;
    var keywordisedit=<%=keywordisedit%>;

	if(keywordObj!=null){
		if(keywordisedit==1){
			keywordObj.value=strKeyword;
			if(keywordismand==1){
				checkinput('field<%=keywordFieldId%>','field<%=keywordFieldId%>span');
			}
		}else{
			keywordObj.value=strKeyword;
			field<%=keywordFieldId%>span.innerHTML=strKeyword;
		}

	}
<%
    }
%>
}

<%
    if(titleFieldId==-3&&keywordFieldId>0){
%>
	    changeKeyword();
<%
   }
%>



function onShowKeyword(isbodymand){
<%
	if(keywordFieldId>0){
	char setSeparator = Util.getSeparator();
	char setSeparator_temp = Util.getSeparator_temp();
%>
	var keywordObj=$G("field<%=keywordFieldId%>");
	var getSeparator = "<%=setSeparator%>";
	var getSeparator_temp = "<%=setSeparator_temp%>";
	if(keywordObj!=null){
		strKeyword=keywordObj.value;
		strKeyword=strKeyword.replace(/%/g,getSeparator);  //因为%作为特殊字符，%也作为转码的字符，如果通过url传参就出现不可解析出现乱码;此处替换后，待显示再替换回来。






		strKeyword=strKeyword.replace(/"/g,getSeparator_temp);
        tempUrl="/docs/sendDoc/WorkflowKeywordBrowserMulti.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&strKeyword="+jQuery(keywordObj).data("keywordid");
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("21517",user.getLanguage())%>";
		dialog.Height = 600;
		dialog.Width = 500;
		dialog.Drag = true;
		dialog.URL = tempUrl;
		dialog.callbackfun = function(params,data){
			if(data){
				keywordObj.value=data.name?data.name.replace(/,/g," "):"";
				jQuery(keywordObj).data("keywordid",data.id);
				if(isbodymand==1){
					checkinput('field<%=keywordFieldId%>','field<%=keywordFieldId%>span');
				}
			}
		}
		dialog.show();
	}
<%
    }
%>
}

function uescape(url){
    return escape(url);
}
function showfieldpop(){
<%if(fieldids.size()<1){%>
alert("<%=SystemEnv.getHtmlLabelName(22577,userlanguage)%>");
<%}%>
}
if (window.addEventListener)
window.addEventListener("load", showfieldpop, false);
else if (window.attachEvent)
window.attachEvent("onload", showfieldpop);
else
window.onload=showfieldpop;

function changeChildField(obj, fieldid, childfieldid){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=<%=isbill%>&selectedfieldid=<%=selectedfieldid%>&uploadType=<%=uploadType%>&isdetail=0&selectvalue="+obj.value;
    $GetEle("selectChange").src = "SelectChange.jsp?"+paraStr;
    //alert($GetEle("selectChange").src);
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
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectedfieldid=<%=selectedfieldid%>&uploadType=<%=uploadType%>&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_00";
				frm.style.display = "none";
			    document.body.appendChild(frm);
			    $GetEle("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
<%=selectInitJsStr%>

</script>
<%-- 
<script type="text/javascript">
//<!--
function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {
	var tmpids = $GetEle("field" + id).value;
	url = url + roleid + "_" + tmpids;

	id1 = window.showModalDialog(url);
	if (id1) {

		if (wuiUtil.getJsonValueByIndex(id1, 0) != ""
				&& wuiUtil.getJsonValueByIndex(id1, 0) != "0") {

			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";

			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);

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

function onShowResourceConditionBrowser(id, url, linkurl, type1, ismand) {

	var tmpids = $GetEle("field" + id).value;
	var dialogId = window.showModalDialog(url + "?resourceCondition=" + tmpids);
	if ((dialogId)) {
		if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
			var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
			var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
			var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
			var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
			var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
			var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
			var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
			var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);

			var sHtml = "";
			var fileIdValue = "";
			var shareTypeValueArray = shareTypeValues.split("~");
			var shareTypeTextArray = shareTypeTexts.split("~");
			var relatedShareIdseArray = relatedShareIdses.split("~");
			var relatedShareNameseArray = relatedShareNameses.split("~");
			var rolelevelValueArray = rolelevelValues.split("~");
			var rolelevelTextArray = rolelevelTexts.split("~");
			var secLevelValueArray = secLevelValues.split("~");
			var secLevelTextArray = secLevelTexts.split("~");
			for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {

				var shareTypeValue = shareTypeValueArray[_i];
				var shareTypeText = shareTypeTextArray[_i];
				var relatedShareIds = relatedShareIdseArray[_i];
				var relatedShareNames = relatedShareNameseArray[_i];
				var rolelevelValue = rolelevelValueArray[_i];
				var rolelevelText = rolelevelTextArray[_i];
				var secLevelValue = secLevelValueArray[_i];
				var secLevelText = secLevelTextArray[_i];
				if (shareTypeValue == "") {
					continue;
				}
				fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
						+ relatedShareIds + "_" + rolelevelValue + "_"
						+ secLevelValue;
				
				if (shareTypeValue == "1") {
					sHtml = sHtml + "," + shareTypeText + "("
							+ relatedShareNames + ")";
				} else if (shareTypeValue == "2") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, userlanguage)%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18941, userlanguage)%>";
				} else if (shareTypeValue == "3") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, userlanguage)%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18942, userlanguage)%>";
				} else if (shareTypeValue == "4") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(3005, userlanguage)%>="
							+ rolelevelText
							+ "  <%=SystemEnv.getHtmlLabelName(683, userlanguage)%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18945, userlanguage)%>";
				} else {
					sHtml = sHtml
							+ ","
							+ "<%=SystemEnv.getHtmlLabelName(683, userlanguage)%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18943, userlanguage)%>";
				}

			}
			
			sHtml = sHtml.substr(1);
			fileIdValue = fileIdValue.substr(1);

			$GetEle("field" + id).value = fileIdValue;
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
//-->
</script>
--%>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>

<script type="text/javascript">
function checkCarSubmit(){
	var flag = false;
	jQuery.ajax({
	    type:"post",
		url: "/cpt/car/CarSetDataOperation.jsp?action=getData",
		data: {workflowid:'<%=workflowid%>'},
		async: false, 
		dataType: "json",
		success: function(returndata){
			if(returndata&&returndata.length>0){
				var iscontinue = returndata[0].iscontinue;
				var remindtype = returndata[0].remindtype; 
				if(iscontinue=='yes'){
					var field627 = returndata[0].field627; //车辆
					var field628 = returndata[0].field628; //司机
					var field629 = returndata[0].field629; //用车人
					var field634 = returndata[0].field634; //开始日期
					var field635 = returndata[0].field635; //开始时间
					var field636 = returndata[0].field636; //结束日期
					var field637 = returndata[0].field637; //结束时间
					var field638 = returndata[0].field638; //撤销
					
					field627 = jQuery("#field"+field627).val();
					field634 = jQuery("#field"+field634).val();
					field635 = jQuery("#field"+field635).val();
					field636 = jQuery("#field"+field636).val();
					field637 = jQuery("#field"+field637).val();
					jQuery.ajax({
					    type:"post",
						url: "/cpt/car/CarSetDataOperation.jsp?action=checkData",
						data: {field627:field627,field634:field634,field635:field635,field636:field636,field637:field637,workflowid:'<%=workflowid%>'},
						async: false, 
						dataType: "json",
						success: function(returnjson){
							if(returnjson&&returnjson.length>0){
								iscontinue = returnjson[0].iscontinue;
								if(iscontinue=="no"){
									if(remindtype=="0"){ //提醒不做处理
									    if(confirm("<%=SystemEnv.getHtmlLabelName(128307,user.getLanguage())%>")==true){
									        flag = true;
									    }else{
									        flag = false;
									    }
									}else{//禁止提交
										alert("<%=SystemEnv.getHtmlLabelName(128308,user.getLanguage())%>");
										flag = false;
									}
								}else{
									flag = true;
								}
							}
						}
					});
				}else{
					flag = true;
				}
			}
		}
	});
	return flag;
}
</script>
