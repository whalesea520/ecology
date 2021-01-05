
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" /><%----- xwj for td3323 20051209  ------%>
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for @td2977 20051111-->
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for td3130 20051124-->
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs01" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs02" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>

<%@ page import="java.util.HashMap" %>
<%@ page import="weaver.system.code.*" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>

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
<jsp:useBean id="RequestLogIdUpdate" class="weaver.workflow.request.RequestLogIdUpdate" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<!--请求的标题开始 -->
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
 <link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">
 
 <script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
<script type="text/javascript" src="/cpt/js/validate_wev8.js"></script>
<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
<!-- browser 相关 -->
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<form name="frmmain" method="post" action="BillCptLossOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="htmlfieldids">
<%

String smsAlertsType = Util.null2String(request.getParameter("smsAlertsType")) ;
ArrayList uploadfieldids=new ArrayList();    
HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息

CodeBuild cbuild = new CodeBuild(Util.getIntValue(formid));
String  codeFields=Util.null2String(cbuild.haveCode());
ArrayList flowDocs=flowDoc.getDocFiled(""+workflowid); //得到流程建文挡的发文号字段

String codeField="";
if (flowDocs!=null&&flowDocs.size()>0)
{
codeField=""+flowDocs.get(0);
}

if (!fromFlowDoc.equals("1")) {%>
<br>

<div align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</div>
<title><%=Util.toScreen(workflowname,user.getLanguage())%></title>
<%}%>
<!--请求的标题结束 -->

<!--TD4262 增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;padding-top:3px;width:100%' valign='top'>
</div>
<!--TD4262 增加提示信息  结束-->

<!--yl qc:67452 start-->
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<%----- xwj for td3323 20051209 begin ------%>
<%
    //yl qc:67452 start
String selectInitJsStr = "";
String initIframeStr = "";
//yl qc:67452 end
 int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
 int maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+secid),5);
 if(maxUploadImageSize<=0){
 maxUploadImageSize = 5;
 }
 int wfid = Util.getIntValue(workflowid, 0);
 int uploadType = 0;
 String selectedfieldid = "";
 String result = RequestManager.getUpLoadTypeForSelect(wfid);
 if(!result.equals("")){
 selectedfieldid = result.substring(0,result.indexOf(","));
 uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
 }
 boolean isCanuse = RequestManager.hasUsedType(wfid);
 if(selectedfieldid.equals("") || selectedfieldid.equals("0")){
 	isCanuse = false;
 }
 String docFlags=(String)session.getAttribute("requestAdd"+user.getUID());
String newTNflag=(String)session.getAttribute("requestAddNewNodes"+user.getUID());
String flowDocField=(String)session.getAttribute("requestFlowDocField"+user.getUID());

String keywordismand="0";
String keywordisedit="0";
int titleFieldId=0;
int keywordFieldId=0;
String isSignMustInput="0";
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
	titleFieldId=Util.getIntValue(RecordSet.getString("titleFieldId"),0);
	keywordFieldId=Util.getIntValue(RecordSet.getString("keywordFieldId"),0);
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
RecordSet.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
}

weaver.crm.Maint.CustomerInfoComInfo customerInfoComInfo = new weaver.crm.Maint.CustomerInfoComInfo();
String usernamenew = "";
	if(user.getLogintype().equals("1"))
		usernamenew = ResourceComInfo.getResourcename(""+user.getUID());
	if(user.getLogintype().equals("2"))
		usernamenew = customerInfoComInfo.getCustomerInfoname(""+user.getUID());
	
 weaver.general.DateUtil   DateUtil=new weaver.general.DateUtil();
 String 	txtuseruse=DateUtil.getWFTitleNew(""+workflowid,""+user.getUID(),""+usernamenew,user.getLogintype());

 
%>
<script language=javascript>

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
			alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
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
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
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
    document.getElementById(objName).outerHTML=outerHTML;       
    document.getElementById(objName).onchange=tempObjonchange;
}
</script>
<%----- xwj for td3323 20051209 end ------%>
<input type=hidden name="workflowRequestLogId" value="-1">

<table class="ViewForm" >
  <colgroup>
  <col width="20%">
  <col width="80%">

  <!--新建的第一行，包括说明和重要性 -->

  <tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
  <tr>
    <td class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
    <td class="fieldvalueClass">
      <!--modify by xhheng @20050318 for TD1689-->
      <%if(defaultName==1){%>
       <%--xwj for td1806 on 2005-05-09--%>
        <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit( txtuseruse,user.getLanguage() )%>" >
        <span id=requestnamespan>
		
 	  <%
		 if(txtuseruse.equals("")){
		%>	
		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		 <%}
		%>
		</span>
      <%}else{%>
        <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "" >
        <span id=requestnamespan><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
      <%}%>
      <input type=radio value="0" name="requestlevel" checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <input type=radio value="1" name="requestlevel"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <input type=radio value="2" name="requestlevel"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
    </td>
  </tr>
<tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
  <!--第一行结束 -->
  <!--add by xhheng @ 2005/01/24 for 消息提醒 Request06，短信设置行开始 -->
  <%
    if(messageType == 1){
  %>
  <tr>
    <td class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></td>
    <td class="fieldvalueClass">
	      <span id=messageTypeSpan></span>
	      <input type=radio value="0" name="messageType" <% if(smsAlertsType.equals("0")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
	      <input type=radio value="1" name="messageType" <% if(smsAlertsType.equals("1")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
	      <input type=radio value="2" name="messageType" <% if(smsAlertsType.equals("2")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
	    </td>
  </tr>
  <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>

  <%}%>


  <!--短信设置行结束 -->

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

String isbodyview="0" ;    //字段是否显示
String isbodyedit="0" ;    //字段是否可以编辑
String isbodymand="0" ;    //字段是否必须输入
String fieldbodyid="";
String fieldbodyname = "" ;                         //字段数据库表中的字段名

String fieldbodyhtmltype = "" ;                     //字段的页面类型

String fieldbodytype = "" ;                         //字段的类型

String fieldbodylable = "" ;                        //字段显示名

String fielddbtype="";                              //字段数据类型
int languagebodyid = 0 ;
int detailsum=0;
String isdetail = "";//xwj for @td2977 20051111
String textheight = "4";//xwj for @td2977 20051111
int fieldlen=0;  //字段类型长度
String losscountid="";

String bclick="";
String isbrowisMust = "";

//获得触发字段名

DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
ArrayList changefieldsadd=WfLinkageInfo.getChangeField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
if(isbill.equals("0")) {
    RecordSet.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formid+"  and t1.langurageid="+user.getLanguage()+" order by t2.fieldorder");

    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("fieldid")));
        fieldorders.add(Util.null2String(RecordSet.getString("fieldorder")));
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet.getString("langurageid")));
    }
    /*
    RecordSet.executeProc("workflow_FieldID_Select",formid+"");

    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString(1)));
        fieldorders.add(Util.null2String(RecordSet.getString(2)));
    }

    RecordSet.executeProc("workflow_FieldLabel_Select",formid+"");
    while(RecordSet.next()){
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet.getString("languageid")));
		//out.println("<b>LANGUAGE:"+Util.null2String(RecordSet.getString("languageid"))+"</b>");
    }
    */
}
else {

    RecordSet.executeProc("workflow_billfield_Select",formid+"");
    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("id")));
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
        fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
        fieldtypes.add(Util.null2String(RecordSet.getString("type")));
        fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
        fieldviewtypes.add(Util.null2String(RecordSet.getString("viewtype")));
		fieldrealtype.add(Util.null2String(RecordSet.getString("fielddbtype")));

        if (RecordSet.getString("fieldname").equals("losscount"))  losscountid=RecordSet.getString("id");
        //字段显示不应该在这里处理，这样很消耗性能，屏蔽掉   mackjoe at 2006-06-07
        /*
            RecordSet_nf1.executeSql("select * from workflow_nodeform where nodeid = "+nodeid+" and fieldid = " + RecordSet.getString("id"));
        if(!RecordSet_nf1.next()){
        RecordSet_nf2.executeSql("insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory) values("+nodeid+","+RecordSet.getString("id")+",'1','1','0')");
        }
        */
    }
}

RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
    isviews.add(Util.null2String(RecordSet.getString("isview")));
    isedits.add(Util.null2String(RecordSet.getString("isedit")));
    ismands.add(Util.null2String(RecordSet.getString("ismandatory")));
}
//modify by mackjoe at 2006-06-07 td4491 将节点前附加操作移出循环外操作减少数据库访问量

int fieldop1id=0;
String strFieldId=null;
String strCustomerValue=null;
String strManagerId=null;
String strUnderlings=null;
ArrayList inoperatefields=new ArrayList();
ArrayList inoperatevalues=new ArrayList();
//rsaddop.executeSql("select fieldid,customervalue from workflow_addinoperate where workflowid=" + workflowid + " and ispreadd='1' and isnode = 1 and objid = "+nodeid);
rsaddop.executeSql("select fieldid,customervalue,fieldop1id from workflow_addinoperate where workflowid=" + workflowid + " and ispreadd='1' and isnode = 1 and objid = "+nodeid);
while(rsaddop.next()){
    //inoperatefields.add(rsaddop.getString("fieldid"));
    //inoperatevalues.add(rsaddop.getString("customervalue"));
	strFieldId=Util.null2String(rsaddop.getString("fieldid"));
	strCustomerValue=Util.null2String(rsaddop.getString("customervalue"));
	fieldop1id=Util.getIntValue(rsaddop.getString("fieldop1id"),0);
	if(fieldop1id==-3){
		strManagerId="";
		rscount.executeSql("select managerId from HrmResource where id="+userid);
		if(rscount.next()){
			strManagerId=Util.null2String(rscount.getString("managerId"));
		}
		inoperatefields.add(strFieldId);
		inoperatevalues.add(strManagerId);
	}else if(fieldop1id==-4){
		strUnderlings="";
		rscount.executeSql("select id from HrmResource where managerId="+userid+" and status in(0,1,2,3)");
		while(rscount.next()){
			strUnderlings+=","+Util.null2String(rscount.getString("id"));
		}
		if(!strUnderlings.equals("")){
			strUnderlings=strUnderlings.substring(1);
		}
		inoperatefields.add(strFieldId);
		inoperatevalues.add(strUnderlings);
	}else{
		inoperatefields.add(strFieldId);
		inoperatevalues.add(strCustomerValue);
	}
}

// 得到每个字段的信息并在页面显示

String beagenter=""+userid;
//获得被代理人
int body_isagent=Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()),0);
if(body_isagent==1){
    rsaddop.executeSql("select bagentuid from workflow_agentConditionSet where workflowId="+ workflowid +" and agentuid=" + userid +
				 " and agenttype = '1' " +
				 " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" +
				 " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
				 " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" +
				 " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" +
				 " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
				 " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null)  order by agentbatch asc  ,id asc ");
    if(rsaddop.next())  beagenter=rsaddop.getString(1);
}
String preAdditionalValue = "";
boolean isSetFlag = false;//xwj for td3308 20051124
for(int i=0;i<fieldids.size();i++){         // 循环开始


    //数据初始化

	isbodyview="0";
	isbodyedit="0";
	isbodymand="0";

  int tmpindex = i ;
    if(isbill.equals("0")) tmpindex = fieldorders.indexOf(""+i);     // 如果是表单, 得到表单顺序对应的 i

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
        languagebodyid = user.getLanguage() ;
        fieldbodyname=(String)fieldnames.get(tmpindex);
        fieldbodyhtmltype=(String)fieldhtmltypes.get(tmpindex);
        fieldbodytype=(String)fieldtypes.get(tmpindex);
		fielddbtype=(String)fieldrealtype.get(tmpindex);
        fieldbodylable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(tmpindex),0),languagebodyid );
    }
	 fieldlen=0;
    if ((fielddbtype.toLowerCase()).indexOf("varchar")>-1)
	{
	   fieldlen=Util.getIntValue(fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.length()-1));

	}
    if(fieldbodyname.equals("manager")) {
	    String tmpmanagerid = ResourceComInfo.getManagerID(beagenter);
%>
	<input type=hidden name="field<%=fieldbodyid%>" value="<%=tmpmanagerid%>" />
<%
    if(isbodyview.equals("1")){
%> <tr>
      <td class="fieldnameClass" <%if(fieldbodyhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldbodylable,languagebodyid)%> </td>
      <td class="fieldvalueClass"><%=ResourceComInfo.getLastname(tmpmanagerid)%></td>
   </tr><tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
<%
    }
	    continue;
	}
    if( ! isbodyview.equals("1") ) { //不显示即进行下一步循环,除了人力资源字段，应该隐藏人力资源字段，因为人力资源字段有可能作为流程下一节点的操作者

        if(fieldbodyhtmltype.equals("3") && (fieldbodytype.equals("1") ||fieldbodytype.equals("17")||fieldbodytype.equals("165")||fieldbodytype.equals("166")) && !preAdditionalValue.equals("")){           
           out.println("<input type=hidden name=field"+fieldbodyid+" value="+preAdditionalValue+">");
        }        
        continue ;                  
    }
	if(fieldbodyname.equals("begindate")) newfromdate="field"+fieldbodyid;      //开始日期,主要为开始日期不大于结束日期进行比较
	if(fieldbodyname.equals("enddate")) newenddate="field"+fieldbodyid;     //结束日期,主要为开始日期不大于结束日期进行比较
	if((""+keywordFieldId).equals(fieldbodyid)) keywordismand=isbodymand;     
	if((""+keywordFieldId).equals(fieldbodyid)) keywordisedit=isbodyedit;     

    if(isbodymand.equals("1")&&!fieldbodyid.equals(codeField)&&!fieldbodyid.equals(codeField))  needcheck+=",field"+fieldbodyid;   //如果必须输入,加入必须输入的检查中(如果是发问号字段，不必输入检查，程序自动生成)

    // 下面开始逐行显示字段
%>
    <tr>
      <td class="fieldnameClass" <%if(fieldbodyhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldbodylable,languagebodyid)%> </td>
      <td class="fieldvalueClass" style="word-wrap:break-word;word-break:break-all;">
      <%
        if(fieldbodyhtmltype.equals("1")){                          // 单行文本框

            if(fieldbodytype.equals("1")){                          // 单行文本框中的文本

                if(isbodyview.equals("1")){

                if(isbodyedit.equals("1")&&!fieldbodyid.equals(codeField)&&!fieldbodyid.equals(codeFields)){
					if(keywordFieldId>0&&(""+keywordFieldId).equals(fieldbodyid)){
%>
<button id="field<%=fieldbodyid%>browser" name="field<%=fieldbodyid%>browser" type=button class=Browser  onclick="onShowKeyword(field<%=fieldbodyid%>.getAttribute('viewtype'))" title="<%=SystemEnv.getHtmlLabelName(21517,user.getLanguage())%>"></button>
<%
					}
                    if(isbodymand.equals("1")) {
      %>
        <input datatype="text" viewtype="<%=isbodymand%>" type=text class=Inputstyle temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" size=50 onChange="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));checkLength('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')<%if(titleFieldId>0&&keywordFieldId>0&&(""+titleFieldId).equals(fieldbodyid)){%>;changeKeyword()<%}%>"<%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>');" <%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
      <%

				    }else{%>
        <input datatype="text" viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" type=text class=Inputstyle name="field<%=fieldbodyid%>" size=50 onChange="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));checkLength('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')<%if(titleFieldId>0&&keywordFieldId>0&&(""+titleFieldId).equals(fieldbodyid)){%>;changeKeyword()<%}%>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>')" <%}%> value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <span id="field<%=fieldbodyid%>span"></span>
      <%            }
		    }else{ %>
        <!--input  type=text class=Inputstyle name="field<%=fieldbodyid%>"  size=50 readonly-->
            <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
            <input  type=hidden class=Inputstyle name="field<%=fieldbodyid%>"  size=50 value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
      <%          }
            }
            }
		    else if(fieldbodytype.equals("2")){                     // 单行文本框中的整型

                if(isbodyview.equals("1")){
			    if(isbodyedit.equals("1")){
				    if(isbodymand.equals("1")) {
      %>
        <input  datatype="int" viewtype="<%=isbodymand%>" type=text class=Inputstyle temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" size=20
		onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkcount1(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldbodyid%>')" <%}else{%> onBlur="checkcount1(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
       <%

				    }else{%>
        <input  datatype="int" viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" type=text class=Inputstyle name="field<%=fieldbodyid%>" size=20 onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkcount1(this);datainput('field<%=fieldbodyid%>');checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%}else{%> onBlur="checkcount1(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%}%> value="<%=preAdditionalValue%>"> <!--modified by xwj for td3130 20051124-->
        <span id="field<%=fieldbodyid%>span"></span>
       <%           }
			    }else{  %>
         <!--input datatype="int" type=text class=Inputstyle name="field<%=fieldbodyid%>" size=20 readonly-->
         <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
         <input datatype="int" type=hidden class=Inputstyle name="field<%=fieldbodyid%>" value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <%        }
            }
            }
		    else if(fieldbodytype.equals("3")||fieldbodytype.equals("5")){                     // 单行文本框中的浮点型
                if(isbodyview.equals("1")){
			    if(isbodyedit.equals("1")){
				    if(isbodymand.equals("1")) {
       %>
        <input datatype="float" viewtype="<%=isbodymand%>" type=text class=Inputstyle temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" size=20
		onKeyPress="ItemNum_KeyPress('field<%=fieldbodyid%>')" <%if(fieldbodytype.equals("5")){%>onfocus="changeToNormalFormat('field<%=fieldbodyid%>')"<%}%> <%if(fieldbodyname.equals("losscount")){%>onBlur="checknumber1(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));checkCountCpt('field<%=fieldbodyid%>','capitalcount');<%if(fieldbodytype.equals("5")){%>changeToThousands('field<%=fieldbodyid%>')<%}%>"<%}else{%> onBlur="checknumber1(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));<%if(fieldbodytype.equals("5")){%>changeToThousands('field<%=fieldbodyid%>')<%}%>"<%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
       <%
    				}else{%>
        <input datatype="float" viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" type=text class=Inputstyle name="field<%=fieldbodyid%>" size=20 onKeyPress="ItemNum_KeyPress('field<%=fieldbodyid%>')" <%if(fieldbodytype.equals("5")){%>onfocus="changeToNormalFormat('field<%=fieldbodyid%>')"<%}%> <%if(fieldbodyname.equals("losscount")){%>onBlur="checknumber1(this);checkCountCpt('field<%=fieldbodyid%>','capitalcount');checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype')); <%if(fieldbodytype.equals("5")){%>changeToThousands('field<%=fieldbodyid%>')<%}%> " <%}else{%> onBlur="checknumber1(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype')); <%if(fieldbodytype.equals("5")){%>changeToThousands('field<%=fieldbodyid%>')<%}%> "<%}%> value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <span id="field<%=fieldbodyid%>span"></span>
       <%           }
               }else{  %>
         <!--input datatype="float" type=text class=Inputstyle name="field<%=fieldbodyid%>"  size=20 readonly-->
         <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
         <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldbodyid%>" value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <%        }
		    }
	    }
	     /*-----------xwj for td3131 20051115 begin ----------*/
	    else if(fieldbodytype.equals("4")){%>
            <table cols=2 id="field<%=fieldbodyid%>_tab" class="ViewForm">
            <tr><td class="fieldnameClass" >
                <%if(isbodyview.equals("1")){
                    if(isbodyedit.equals("1")){%>
                        <input datatype="float" viewtype="<%=isbodymand%>" type=text class=Inputstyle name="field_lable<%=fieldbodyid%>" size=60
                            onfocus="FormatToNumber('<%=fieldbodyid%>')"
                            onKeyPress="ItemNum_KeyPress('field_lable<%=fieldbodyid%>')"
                            <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
                                onBlur="numberToFormat('<%=fieldbodyid%>');datainput('field_lable<%=fieldbodyid%>');checkinput2('field_lable<%=fieldbodyid%>','field_lable<%=fieldbodyid%>span',field<%=fieldbodyid%>.getAttribute('viewtype'))"
                            <%}else{%>
                                onBlur="numberToFormat('<%=fieldbodyid%>');checkinput2('field_lable<%=fieldbodyid%>','field_lable<%=fieldbodyid%>span',field<%=fieldbodyid%>.getAttribute('viewtype'))"
                            <%}%>
                        >
                        <span id="field_lable<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)&&isbodymand.equals("1")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
                        <span id="field<%=fieldbodyid%>span"></span>
                        <input datatype="float" viewtype="<%=isbodymand%>" type=hidden class=Inputstyle temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" value="">
                    <%}else{%>
                        <span id="field<%=fieldbodyid%>span"></span>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldbodyid%>" disabled="true">
                        <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldbodyid%>" value="">
                    <%}
                }
                if(!"".equals(preAdditionalValue)){%>
                    <script language="javascript">
                        window.document.all("field_lable"+<%=fieldbodyid%>).value  = numberChangeToChinese(<%=preAdditionalValue%>);
                        window.document.all("field"+<%=fieldbodyid%>).value  = <%=preAdditionalValue%>;
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
			 }
			    /*-----xwj for @td2977 20051111 begin-----*/
            if(isbodyview.equals("1")){
		    if(isbodyedit.equals("1")){
			    if(isbodymand.equals("1")) {
       %>
        <textarea class=Inputstyle viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>');" <%}%> onChange="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));checkLengthfortext('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"
		rows="<%=textheight%>" cols="40" style="width:80%" class=Inputstyle ><%=preAdditionalValue%></textarea><!--xwj for @td2977 20051111-->
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->

       <%
			    }else{
       %>
        <textarea class=Inputstyle viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" onchange="checkLengthfortext('field<%=fieldbodyid%>','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" name="field<%=fieldbodyid%>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldbodyid%>');" <%}%> rows="<%=textheight%>" cols="40" style="width:80%"><%=Util.encodeAnd(preAdditionalValue)%></textarea><!--xwj for @td2977 20051111--><!--modified by xwj for td3130 20051124-->
        <span id="field<%=fieldbodyid%>span"></span>
       <%       }%>
	  <script>$GetEle("htmlfieldids").value += "field<%=fieldbodyid%>;<%=Util.toScreen(fieldbodylable,languagebodyid)%>;<%=fieldbodytype%>,";</script>
       <%  if (fieldbodytype.equals("2")) {%>
		   	<script>function funcField<%=fieldbodyid%>(){
				CkeditorExt.initEditor('frmmain','field<%=fieldbodyid%>',<%=user.getLanguage()%>,CkeditorExt.NO_IMAGE,200);
				<%if(isbodyedit.equals("1"))out.println("CkeditorExt.checkText('field"+fieldbodyid+"span','field"+fieldbodyid+"');");%>
				CkeditorExt.toolbarExpand(false,"field<%=fieldbodyid%>");
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
		<%} }else{  %>
                <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
                <input type=hidden class=Inputstyle name="field<%=fieldbodyid%>" value='<%=preAdditionalValue%>'><!--modified by xwj for td3130 20051124-->
         <!--textarea  class=Inputstyle name="field<%=fieldbodyid%>" rows="4" cols="40" style="width:80%"  readonly></textarea-->
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
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值


            if((fieldbodytype.equals("8") || fieldbodytype.equals("135")) && !prjid.equals("")){       //浏览按钮为项目,从前面的参数中获得项目默认值

                showid = "" + Util.getIntValue(prjid,0);
            }else if((fieldbodytype.equals("9") || fieldbodytype.equals("37")) && !docid.equals("")){ //浏览按钮为文档,从前面的参数中获得文档默认值

                showid = "" + Util.getIntValue(docid,0);
            }else if((fieldbodytype.equals("1") ||fieldbodytype.equals("17")) && !hrmid.equals("")){ //浏览按钮为人,从前面的参数中获得人默认值

                showid = "" + Util.getIntValue(hrmid,0);
            }else if((fieldbodytype.equals("7") || fieldbodytype.equals("18")) && !crmid.equals("")){ //浏览按钮为CRM,从前面的参数中获得CRM默认值

                showid = "" + Util.getIntValue(crmid,0);
            }else if((fieldbodytype.equals("16") || fieldbodytype.equals("152") || fieldbodytype.equals("171")) && !reqid.equals("")){ //浏览按钮为REQ,从前面的参数中获得REQ默认值

                showid = "" + Util.getIntValue(reqid,0);
			}else if(fieldbodytype.equals("4") && !hrmid.equals("")){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
            }else if(fieldbodytype.equals("24") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getJobTitle(hrmid),0);
            }else if(fieldbodytype.equals("32") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"),0);
            }else if(fieldbodytype.equals("164") && !hrmid.equals("")){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getSubCompanyID(hrmid),0);
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

            if(fieldbodytype.equals("2") || fieldbodytype.equals("19")  )	showname=showid; // 日期时间
            else if(!showid.equals("")){       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                ArrayList tempshowidlist=Util.TokenizerString(showid,",");
                if(fieldbodytype.equals("8") || fieldbodytype.equals("135")){
                    //项目，多项目
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("1") ||fieldbodytype.equals("17")){
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
                }else if(fieldbodytype.equals("7") || fieldbodytype.equals("18")){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("4") || fieldbodytype.equals("57")){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("164")){
                    //分部
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+" ";
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
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+" ";
                        }
                        }
                    }
                }else if(fieldbodytype.equals("23")){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("16") || fieldbodytype.equals("152") || fieldbodytype.equals("171")){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("161")||fieldbodytype.equals("162")){
                    
					Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
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
                }else{
                    String tablename=BrowserComInfo.getBrowsertablename(fieldbodytype);
                    String columname=BrowserComInfo.getBrowsercolumname(fieldbodytype);
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldbodytype);
                    if(!tablename.equals("") && !columname.equals("") && !keycolumname.equals("")){
	                    String sql="";
	                    if(showid.indexOf(",")==-1){
	                        sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+showid;
	                    }else{
	                        sql="select "+columname+" from "+tablename+" where "+keycolumname+" in("+showid+")";
	                    }

	                    RecordSet.executeSql(sql);
	                    while(RecordSet.next()) {
	                        if(!linkurl.equals(""))
	                            showname += "<a href='"+linkurl+showid+"' target='_new'>"+RecordSet.getString(1)+"</a>&nbsp";
	                        else
	                            showname +=RecordSet.getString(1) ;
	                    }
                    }
                }
            }

           //deleted by xwj for td3130 20051124

		    if(isbodyedit.equals("1")){
//add  by ben delweath rolepersone

              if(fieldbodytype.equals("160")){
                rsaddop.execute("select a.level_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="+fieldbodyid+" and b.nodeid in (select nodeid from workflow_flownode where workflowid="+workflowid+" ) ");
                String roleid="";
  				int rolelevel_tmp = 0;
  				if (rsaddop.next())
  				{
  				roleid=rsaddop.getString(1);
  				rolelevel_tmp=Util.getIntValue(rsaddop.getString(2), 0);
  				roleid += "a"+rolelevel_tmp;
  				}
				bclick = "onShowResourceRole('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".getAttribute('viewtype'),'"+roleid+"')";
%>
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
		
        <!-- button class=Browser  onclick="onShowResourceRole('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'),'<%=roleid%>')" title="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>"></button -->
<%
			  }
              else if(fieldbodytype.equals("161")||fieldbodytype.equals("162")){
              url+="?type="+fielddbtype;
              bclick = "onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".viewtype);";
              if(trrigerfield.indexOf("field"+fieldbodyid)>=0){
                  bclick += "datainput('field"+fieldbodyid+"',field"+fieldbodyid+".viewtype);";
              }
%>
        <!-- button class=Browser  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'))"></button -->
        <brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
<%
			  }
	else if (fieldbodytype.equals("23"))  //资产
				{
				//bclick="onShowCptCapital('"+fieldbodyid+"','"+losscountid+"','capitalcount',field"+fieldbodyid+".getAttribute('viewtype'));";
		if(trrigerfield.indexOf("field"+fieldbodyid)>=0){
	  	      bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"','"+isbodymand+"');datainput('field"+fieldbodyid+"');";
	  	   }else{
	  		  bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"','"+isbodymand+"')";
	  	   }
				%>
				<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
				<!-- 
		        <button class=Browser  onclick="onShowCptCapital('<%=fieldbodyid%>','<%=losscountid%>','capitalcount',field<%=fieldbodyid%>.getAttribute('viewtype'))"></button>
		         -->
				<input type='hidden' name='capitalcount' id='capitalcount' >	
				<%}
              else if(fieldbodytype.equals("141")){
				bclick = "onShowResourceConditionBrowser('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".viewtype)";
%>
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
        <!-- button class=Browser  onclick="onShowResourceConditionBrowser('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'))" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button -->
<%
			  } else
//add by fanggsh 20060621 for TD4528 end
                if(!fieldbodytype.equals("37")&&!fieldbodytype.equals("9")) {
					session.setAttribute("relaterequest","new");
					//  多文档特殊处理

					if(trrigerfield.indexOf("field"+fieldbodyid)>=0){
					    bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".getAttribute('viewtype'));datainput('field"+fieldbodyid+"');";
					}else{
					    bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".getAttribute('viewtype'))";
				    }
	   %>
       <!-- button class=Browser <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
	      onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'));datainput('field<%=fieldbodyid%>',field<%=fieldbodyid%>.getAttribute('viewtype'));"
	   <%}else{%>
		  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'))"
	   <%}%> 
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>">
	   </button -->
	   <brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
	   
        <%}else if(fieldbodytype.equals("37")){                         // 如果是多文档字段,加入新建文档按钮
        	bclick = "onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".viewtype)";
       %>
        <brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
        <!-- button class=AddDocFlow onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'))" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp<button class=AddDocFlow onclick="onNewDoc(<%=fieldbodyid%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button -->
       <%}else if(fieldbodytype.equals("9") && fieldbodyid.equals(flowDocField)){       // 如果是多文档字段,加入新建文档按钮
	        if(!"1".equals(newTNflag)){
	        	if(trrigerfield.indexOf("field"+fieldbodyid)>=0){
	               	bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".getAttribute('viewtype'));datainput('field"+fieldbodyid+"');";
		  	   	}else{
		  		  	bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".getAttribute('viewtype'))";
		  	   	}
	   %>
       <!-- button class=Browser <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
	      onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'));datainput('field<%=fieldbodyid%>',field<%=fieldbodyid%>.getAttribute('viewtype'));"
	   <%}else{%>
		  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'))"
	   <%}%> 
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>">
	   </button -->
	   <brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
       <%}
        }else{
        	  if(trrigerfield.indexOf("field"+fieldbodyid)>=0){
		  	      bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"','"+isbodymand+"');datainput('field"+fieldbodyid+"');";
		  	   }else{
		  		  bclick="onShowBrowser2('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"','"+isbodymand+"')";
		  	   }
        %>
        <brow:browser viewType="0" name='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldbodytype + ")"%>' width="230px" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + fieldbodyid + ")" %>'> </brow:browser>
	    <!-- button class=Browser <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
	      onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>','<%=isbodymand%>');datainput('field<%=fieldbodyid%>','<%=isbodymand%>');"
	   <%}else{%>
		  onclick="onShowBrowser2('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>','<%=isbodymand%>')"
	   <%}%> 
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>">
	    </button -->
	   <%}
           if(fieldbodytype.equals("9")&&docFlags.equals("1") && fieldbodyid.equals(flowDocField))  ///是否有流程建文档s
           {%>
           <span id="CreateNewDoc"><button id="createdoc" class=AddDocFlow onclick="createDoc('<%=fieldbodyid%>','')" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
           </span>
           <%}
        }
	   if(fieldbodytype.equals("161")||fieldbodytype.equals("162")){%>
	   <input type=hidden viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" value="<%=showid%>" >
       <%}
       else if (fieldbodytype.equals("9")&&docFlags.equals("1")) {%>
		<input type=hidden viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" value="<%=showid%>"  <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onChange="datainput('field<%=fieldbodyid%>');" <%}%>>
      <%} else {%>
        <input type=hidden viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" value="<%=showid%>" onpropertychange="checkLengthbrow('field<%=fieldbodyid%>','field<%=fieldbodyid%>span','<%=fieldlen%>','<%=Util.toScreen(fieldbodylable,languagebodyid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>',field<%=fieldbodyid%>.getAttribute('viewtype'))"  <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onChange="datainput('field<%=fieldbodyid%>');" <%}%>>
		<%}%>
		<!-- 
        <span id="field<%=fieldbodyid%>span"><%=Util.toScreen(showname,user.getLanguage())%>
       <%   if(isbodymand.equals("1") && showname.equals("")) {
       %>
           <img src="/images/BacoError_wev8.gif" align=absmiddle>
       <%
            }
       %>
        </span>
        &nbsp;&nbsp;
        -->
        <%if(fieldbodytype.equals("87")){%>
        <A href="/meeting/report/MeetingRoomPlan.jsp" target="blank"><%=SystemEnv.getHtmlLabelName(2193,user.getLanguage())%></A>
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
        <input type=checkbox viewtype="<%=isbodymand%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" value=1<%if(preAdditionalValue.equals("1")){%> checked<%}%>  name="field<%=fieldbodyid%>" <%if(isbodyedit.equals("0")){%> DISABLED <%}%> <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onChange="datainput('field<%=fieldbodyid%>');" <%}%>><!--modified by xwj for td3130 20051124-->
       <%
        if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
        }                                                       // check框条件结束

        else if(fieldbodyhtmltype.equals("5")){                     // 选择框   select
        //yl 67452   start
        //处理select字段联动
        String onchangeAddStr = "";
        int childfieldid_tmp = 0;
        rs.execute("select childfieldid from workflow_billfield where id="+fieldbodyid);
        if(rs.next()){
            childfieldid_tmp = Util.getIntValue(rs.getString("childfieldid"), 0);
        }
        int firstPfieldid_tmp = 0;
        boolean hasPfield = false;
        rs.execute("select id from workflow_billfield where childfieldid="+fieldbodyid);
        while(rs.next()){
            firstPfieldid_tmp = Util.getIntValue(rs.getString("id"), 0);
            if(fieldids.contains(""+firstPfieldid_tmp)){
                hasPfield = true;
                break;
            }
        }
        if(childfieldid_tmp != 0){//如果先出现子字段，则要把子字段下拉选项清空
            onchangeAddStr = " onchange = '" +  "$changeOption(this, "+fieldbodyid+", "+childfieldid_tmp+");'";
        }

        //yl 67452   end

%>
      <script>
          function funcField<%=fieldbodyid%>(){
              changeshowattr('<%=fieldbodyid%>_0',document.getElementById('field<%=fieldbodyid%>').value,-1,'<%=workflowid%>','<%=nodeid%>');
          }
          window.attachEvent("onload", funcField<%=fieldbodyid%>);
      </script>


        <select class=inputstyle viewtype="<%=isbodymand%>"   <%=onchangeAddStr%>    temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>" name="field<%=fieldbodyid%>" <%if(isbodyedit.equals("0")){%> DISABLED <%}%> onBlur="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0&&selfieldsadd.indexOf(fieldbodyid)>=0){%> onChange="datainput('field<%=fieldbodyid%>');changeshowattr('<%=fieldbodyid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}else if(selfieldsadd.indexOf(fieldbodyid)>=0){%> onChange="changeshowattr('<%=fieldbodyid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}%>><!--added by xwj for td3313 20051206 -->
	    <option value=""></option><!--added by xwj for td3297 20051130 -->
	   <%
            // 查询选择框的所有可以选择的值

            char flag= Util.getSeparator() ;
            rs.executeProc("workflow_selectitembyid_new",""+fieldbodyid+flag+isbill);
			      boolean checkempty = true;//xwj for td3313 20051206
			      String finalvalue = "";//xwj for td3313 20051206
           if(hasPfield == false){
            while(rs.next()){
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
                String isdefault = Util.toScreen(rs.getString("isdefault"),user.getLanguage());//xwj for td2977 20051107
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
                while(rs.next()){
                    String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                    String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
                    if(tmpselectvalue.equals(preAdditionalValue)){
                        checkempty = false;
                        finalvalue = tmpselectvalue;
                    }
       %>
            <option value="<%=tmpselectvalue%>" <%if(preAdditionalValue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
            <%
                    }
                    selectInitJsStr += "doInitChildSelect("+fieldbodyid+","+firstPfieldid_tmp+",\""+finalvalue+"\");\n";
                    initIframeStr += "<iframe id=\"iframe_"+firstPfieldid_tmp+"_"+fieldbodyid+"_00\" frameborder=0 scrolling=no src=\"\"  style=\"display:none\"></iframe>";

                    //yl 67452   end
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
        <input type=hidden class=Inputstyle name="field<%=fieldbodyid%>" value="<%=finalvalue%>" >
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
          if(isbodyedit.equals("1")){
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
               uploadfieldids.add(fieldbodyid);
           %>
            <script>
          var oUpload<%=fieldbodyid%>;
          function fileupload<%=fieldbodyid%>() {
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
                progressTarget : "fsUploadProgress<%=fieldbodyid%>",
                cancelButtonId : "btnCancel<%=fieldbodyid%>",
                uploadspan : "field<%=fieldbodyid%>span",
                uploadfiedid : "field<%=fieldbodyid%>"
            },
            debug: false,
            button_image_url : "/js/swfupload/add_wev8.png",
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldbodyid%>",
            button_width: 100,
            button_height: 18,
            button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
            button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
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
            oUpload<%=fieldbodyid%>=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	window.attachEvent("onload", fileupload<%=fieldbodyid%>);
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td class="fieldvalueClass" colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolder<%=fieldbodyid%>"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload<%=fieldbodyid%>.cancelQueue();showmustinput(oUpload<%=fieldbodyid%>);" id="btnCancel<%=fieldbodyid%>">
									<span><img src="/js/swfupload/delete_wev8.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span id="uploadspan">(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                      <span id="field<%=fieldbodyid%>span">
				<%
				 if(isbodymand.equals("1")){
				needcheck+=",field"+fieldbodyid;
				%>
			   <img src='/images/BacoError_wev8.gif' align=absMiddle>
			  <%
					}
			   %>
	     </span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field<%=fieldbodyid%>" temptitle="<%=Util.toScreen(fieldbodylable,languagebodyid)%>"  viewtype="<%=isbodymand%>">
              </td>
          </tr>
          <tr>
              <td class="fieldvalueClass" colspan="2">
                  <div class="fieldset flash" id="fsUploadProgress<%=fieldbodyid%>">
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
       }                                          // 选择框条件结束 所有条件判定结束

       else if(fieldbodyhtmltype.equals("7")){//特殊字段
           if(isbill.equals("0")) out.println(Util.null2String((String)specialfield.get(fieldbodyid+"_0")));
           else out.println(Util.null2String((String)specialfield.get(fieldbodyid+"_1")));
       }     
       %>
      </td>
    </tr>
	 <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
<%
    }       // 循环结束
%>
</table>
<%
//add by mackjoe at 2006-06-07 td4491 有明细时才加载

boolean  hasdetailb=false;
if(isbill.equals("0")) {
    RecordSet.executeSql("select count(*) from workflow_formfield  where isdetail='1' and formid="+formid);
}else{
    RecordSet.executeSql("select count(*) from workflow_billfield  where viewtype=1 and billid="+formid);
}
if(RecordSet.next()){
    if(RecordSet.getInt(1)>0) hasdetailb=true;
}
if(hasdetailb){
%>
  

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
  </jsp:include>
<%}%>
<!-- 单独写签字意见Start ecology8.0 -->
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
		
		//String isSignMustInput="0";
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
    %>
	<%@ include file="/workflow/request/WorkflowSignInput.jsp" %>
<!-- 单独写签字意见End ecology8.0 -->

<!-- yl qc:67452 start-->
<%=initIframeStr%>
<!-- yl qc:67452 end-->


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
<input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">

<input type=hidden name ="isMultiDoc" value=""><!--多文档新建-->
 <input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
</form>
<script language=javascript>
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
}
*/



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
function createDoc(fieldbodyid,docVlaue)
{

	/*
   for(i=0;i<=1;i++){
  		parent.document.all("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.document.all("oTDtype_"+i).className="cycleTD";
  	}
  	parent.document.all("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.document.all("oTDtype_1").className="cycleTDCurrent";
	*/
	var _isagent = "";
	if(document.all("_isagent")!=null) _isagent=document.all("_isagent").value;
  	frmmain.action = "RequestOperation.jsp?isagent="+_isagent+"&docView=1&docValue="+docVlaue;
    frmmain.method.value = "crenew_"+fieldbodyid ;
    if(check_form(document.frmmain,'requestname')){

        document.frmmain.src.value='save';
        //document.frmmain.submit();
//保存签章数据
<%if("1".equals(isFormSignature)){%>
	                    if(SaveSignature()){
                            //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                        }else{
							alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							return ;
						}
<%}else{%>
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>

    }


}
function onAddPhrase(phrase){            <!-- 添加常用短语 -->
    if(phrase!=null && phrase!=""){
    	$GetEle("remarkSpan").innerHTML = "";
		try{
			var remarkHtml = CkeditorExt.getHtml("remark");
			var remarkText = CkeditorExt.getText("remark");
			if(remarkText==null || remarkText==""){
				CkeditorExt.setHtml(phrase,"remark");
			}else{
				CkeditorExt.setHtml(remarkHtml+phrase,"remark");
			}
		}catch(e){}
    }
}
function onNewDoc(fieldbodyid) {

    frmmain.action = "RequestOperation.jsp" ;
    frmmain.method.value = "docnew_"+fieldbodyid ;
    frmmain.isMultiDoc.value = fieldbodyid ;
    if(check_form(document.frmmain,'requestname')){

        document.frmmain.src.value='save';
        //附件上传
                        StartUploadAll();
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
                window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
                return false;
            }
        }
        return true;
    }

    function doSave(){              //点击保存按钮
        var ischeckok="";

        try{
        if(check_form(document.frmmain,document.all("needcheck").value+document.all("inputcheck").value))
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
			    if(!check_form(document.frmmain,'remarktext10404')){
				    ischeckok="false";
			    }
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

                   //TD4262 增加提示信息  开始

		           var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
		           //showPrompt(content);
                   //TD4262 增加提示信息  结束

//保存签章数据
<%if("1".equals(isFormSignature)){%>
	                    if(SaveSignature()){
                            //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                        }else{
							alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							return ;
						}
<%}else{%>
						//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>
                }
            }
    }

    function doSubmit(obj){            <!-- 点击提交 -->
      //modify by xhheng @20050328 for TD 1703
      //明细部必填check，通过try document.all("needcheck")来检查,避免对原有无明细单据的修改


        var ischeckok="";
        try{
        if(check_form(document.frmmain,document.all("needcheck").value+document.all("inputcheck").value))
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
			    if(!check_form(document.frmmain,'remarktext10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>

        if(ischeckok=="true"){
			CkeditorExt.updateContent();
            if(checktimeok()) {
                document.frmmain.src.value='submit';
                // xwj for td2104 on 20050802
                //document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201
           
           
        //验证资产减损的数量

		if("<%=formid%>"==221){
		<%
			rs01.execute("select id from workflow_billfield where billid = 221 and fieldname = 'lossCpt'");
			String cptid="";
			if(rs01.next()){
				cptid = rs01.getString("id");
			}
			rs02.execute("select id from workflow_billfield where billid = 221 and fieldname = 'losscount'");
			String cptcount="";
			if(rs02.next()){
				cptcount = rs02.getString("id");
			}
		%>
			var poststr = "|"+jQuery("input[name=field<%=cptid%>]").val()*1+","+jQuery("input[name=field<%=cptcount%>]").val()*1;
			//alert(poststr);
			checkcapitalnum(poststr,function(){
				dosubmit_callback(obj);
			});
			
		}     
		
	/**	
    	if("<%=formid%>"==201){//资产报废单据明细中的资产报废数量大于库存数量，不能提交。

	    	nodesnum = document.all("nodesnum").value;
	    	for(var tempindex1=0;tempindex1<nodesnum;tempindex1++){
	    		var capitalcount = document.all("node_"+tempindex1+"_capitalcount").value*1;
	    		var fetchingnumber=document.all("node_"+tempindex1+"_number").value*1;
	    		for(var tempindex2=0;tempindex2<nodesnum;tempindex2++){
	    			if(tempindex2!=tempindex1&&document.all("node_"+tempindex1+"_capitalid").value==document.all("node_"+tempindex2+"_capitalid").value){
	    				fetchingnumber = fetchingnumber*1 + document.all("node_"+tempindex2+"_number").value*1;
	    			}
	    		}
	    		if(fetchingnumber>capitalcount){
	    			alert("<%=SystemEnv.getHtmlLabelName(15313,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%>");
	    			return;
	    		}
	    	}
    	}
    **/

            }
        }
    }
    
    
   
function dosubmit_callback(obj){
	//TD4262 增加提示信息  开始

	var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
	showPrompt(content);
	//TD4262 增加提示信息  结束
	obj.disabled=true;
	var isFormSignature='<%=isFormSignature %>';
	if(isFormSignature=="1"){
		if(SaveSignature()){
            //附件上传
            StartUploadAll();
            checkuploadcomplet();
	     }else{
			alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
			return ;
		}
	}else{
		 StartUploadAll();
	     checkuploadcomplet();
	}
}  

<%-----------xwj for td3131 20051115 begin -----%>
function numberToFormat(index){
    if(document.all("field_lable"+index).value != ""){
        document.all("field"+index).value = floatFormat(document.all("field_lable"+index).value);
        document.all("field_lable"+index).value = milfloatFormat(document.all("field"+index).value);
        document.all("field_chinglish"+index).value = numberChangeToChinese(document.all("field"+index).value);
    }else{
        document.all("field"+index).value = "";
        document.all("field_chinglish"+index).value = "";
    }
}
function FormatToNumber(index){
    if(document.all("field_lable"+index).value != ""){
        document.all("field_lable"+index).value = document.all("field"+index).value;
    }else{
        document.all("field"+index).value = "";
        document.all("field_chinglish"+index).value = "";
    }
}
<%-----------xwj for td3131 20051115 end -----%>
function numberToChinese(index){
if(document.all("field_lable"+index).value != ""){
document.all("field"+index).value = document.all("field_lable"+index).value;
document.all("field_lable"+index).value = numberChangeToChinese(document.all("field_lable"+index).value);
}
else{
document.all("field"+index).value = "";
}
}
function ChineseToNumber(index){
if(document.all("field_lable"+index).value != ""){
document.all("field_lable"+index).value = chineseChangeToNumber(document.all("field_lable"+index).value);
document.all("field"+index).value = document.all("field_lable"+index).value;
}
else{
document.all("field"+index).value = "";
}
}

  setTimeout("doTriggerInit()",1000);
  function doTriggerInit(){
      var tempS = "<%=trrigerfield%>";
      var tempA = tempS.split(",");
      for(var i=0;i<tempA.length;i++){
          datainput(tempA[i]);
      }
  }
  function datainput(parfield){                <!--数据导入-->
      //var xmlhttp=XmlHttp.create();
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;
      <%
      if(!trrigerfield.trim().equals("")){
          ArrayList Linfieldname=ddi.GetInFieldName();
          ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          if(parfield=="<%=temp.substring(temp.indexOf("|")+1)%>") StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          }
      %>
      //alert(StrData);
      document.all("datainputform").src="DataInputFrom.jsp?"+StrData;
      //xmlhttp.open("POST", "DataInputFrom.jsp", false);
      //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      //xmlhttp.send(StrData);
  }
  function addannexRow(accname,maxsize)
  {
    document.all(accname+'_num').value=parseInt(document.all(accname+'_num').value)+1;
    ncol = document.all(accname+'_tab').cols;
    oRow = document.all(accname+'_tab').insertRow(-1);
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
          var sHtml = "<input class=InputStyle  type=file size=60 name='"+accname+"_"+document.all(accname+'_num').value+"' onchange='accesoryChanage(this)'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
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
    pTop= document.body.offsetHeight/2 - (parent.document.body.offsetHeight/2 - document.body.offsetHeight/2) - 55;
    var showTableDiv  = $G('_xTable');
    var message_table_Div = document.createElement("div")
    message_table_Div.id="message_table_Div";
    message_table_Div.className="xTable_message";
    showTableDiv.appendChild(message_table_Div);
    var message_table_Div  = $G("message_table_Div");
    message_table_Div.style.display="inline";
    message_table_Div.innerHTML=content;
    var pLeft= document.body.offsetWidth/2-55;
    jQuery(message_table_Div).css("z-index", 1002);

    var top = pTop;
    var left = pLeft;
    $("#_xTable").css( { position : 'fixed', 'top' : top, 'left' : left } ).show();
}
//TD4262 增加提示信息  结束

function changeKeyword(){
<%
	if(titleFieldId>0&&keywordFieldId>0){
%>
	    var titleObj=document.getElementById("field<%=titleFieldId%>");
	    var keywordObj=document.getElementById("field<%=keywordFieldId%>");

        if(titleObj!=null&&keywordObj!=null){

		    document.getElementById("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?operation=UpdateKeywordData&docTitle="+titleObj.value;
	    }
<%
    }else if(titleFieldId==-3&&keywordFieldId>0){
%>
	    var titleObj=document.getElementById("requestname");
	    var keywordObj=document.getElementById("field<%=keywordFieldId%>");

        if(titleObj!=null&&keywordObj!=null){

		    document.getElementById("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?operation=UpdateKeywordData&docTitle="+titleObj.value;
	    }
<%
   }
%>
}

function updateKeywordData(strKeyword){
<%
	if(keywordFieldId>0){
%>
	var keywordObj=document.getElementById("field<%=keywordFieldId%>");

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
%>
	var keywordObj=document.getElementById("field<%=keywordFieldId%>");
	if(keywordObj!=null){
		strKeyword=keywordObj.value;
        tempUrl=escape("/docs/sendDoc/WorkflowKeywordBrowserMulti.jsp?strKeyword="+strKeyword);
		tempUrl=tempUrl.replace(/%A0/g,'%20');
        returnKeyword=window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+tempUrl);

		if(typeof(returnKeyword)!="undefined"){
			keywordObj.value=returnKeyword;
			if(isbodymand==1){
				checkinput('field<%=keywordFieldId%>','field<%=keywordFieldId%>span');
			}
		}
	}
<%
    }
%>
}

function uescape(url){
    return escape(url);
}


function checkCountCpt(a,b){
	
    var stockamount = document.all(b).value;
    var useamount = document.all(a).value;
    if(eval(useamount)>eval(stockamount)){
        alert("<%=SystemEnv.getHtmlLabelName(6054,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%>");
        document.all(a).value = stockamount;
    }
}

function showfieldpop(){
<%if(fieldids.size()<1){%>
alert("<%=SystemEnv.getHtmlLabelName(22577,user.getLanguage())%>");
<%}%>
}
if (window.addEventListener)
window.addEventListener("load", showfieldpop, false);
else if (window.attachEvent)
window.attachEvent("onload", showfieldpop);
else
window.onload=showfieldpop;
</script>
<script LANGUAGE="VBS">

sub onShowResourceRole(id,url,linkurl,type1,ismand,roleid)
tmpids = document.all("field"+id).value
url=url&roleid&"_"+tmpids
//url=url&"&resourceids="&tmpids

id1 = window.showModalDialog(url)
        if NOT isempty(id1) then

		   if id1(0)<> ""  and id1(0)<> "0"  then

					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all("field"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if
        end if
end sub



sub onShowBrowser2(id,url,linkurl,type1,ismand)
    if type1=9  and <%=docFlags%>="1" then
    url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp"
    end if
	if type1= 2 or type1 = 19 then
	    spanname = "field"+id+"span"
	    inputname = "field"+id
		if type1 = 2 then
		  onFlownoShowDate spanname,inputname,ismand
        else
	      onWorkFlowShowTime spanname,inputname,ismand
		end if
	else
		if  type1 <> 171 and type1 <> 152 and type1 <> 142 and type1 <> 135 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>165 and type1<>166 and type1<>167 and type1<>168 then
			id1 = window.showModalDialog(url)
		else
            if type1=135 then
			tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=37 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
            elseif type1=142 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?receiveUnitIds="&tmpids)
            elseif type1=165 or type1=166 or type1=167 or type1=168 then
            index=InStr(id,"_")
            if index>0 then
            tmpids=uescape("?isdetail=1&fieldid="& Mid(id,1,index-1)&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            else
            tmpids=uescape("?fieldid="&id&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            end if
            else
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
            end if
		end if
		if NOT isempty(id1) then
			if  type1 = 171 or type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 then
				if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceidss = Mid(resourceids,2,len(resourceids))
					resourceids = Mid(resourceids,2,len(resourceids))

					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
					if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							sHtml = sHtml&"<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
						else
							sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
					end if
					wend
					if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
						sHtml = sHtml&"<a href=javaScript:openhrm("&resourceids&"); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
					else
						sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					end if
					document.all("field"+id+"span").innerHtml = sHtml
					document.all("field"+id).value= resourceidss
				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if

			else
			   if  id1(0)<>""  and id1(0)<> "0"  then
                   if type1=162 then
				     ids = id1(0)
					names = id1(1)
					descs = id1(2)
					sHtml = ""
					ids = Mid(ids,1,len(ids))
					document.all("field"+id).value= ids
					names = Mid(names,1,len(names))
					descs = Mid(descs,1,len(descs))
					while InStr(ids,",") <> 0
						curid = Mid(ids,1,InStr(ids,","))
						curname = Mid(names,1,InStr(names,",")-1)
						curdesc = Mid(descs,1,InStr(descs,",")-1)
						ids = Mid(ids,InStr(ids,",")+1,Len(ids))
						names = Mid(names,InStr(names,",")+1,Len(names))
						descs = Mid(descs,InStr(descs,",")+1,Len(descs))
						sHtml = sHtml&"<a title='"&curdesc&"' >"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a title='"&descs&"'>"&names&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
				   if type1=161 then
				     name = id1(1)
					desc = id1(2)
				    document.all("field"+id).value=id1(0)
					sHtml = "<a title='"&desc&"'>"&name&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
                   if type1=9 and <%=docFlags%>="1" then
                    tempid=id1(0)
                    document.all("field"+id+"span").innerHtml = "<a href='#' onclick='createDoc("+id+","+tempid+",1)'>"&id1(1)&"</a><button id='createdoc' style='display:none' class=AddDocFlow onclick=createDoc("+id+","+tempid+",1)></button>"
                    else
			        if linkurl = "" then
						document.all("field"+id+"span").innerHtml = id1(1)
					else
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							document.all("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&id1(0)&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							document.all("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&" target='_new'>"&id1(1)&"</a>"
						end if
						
                    end if
                    end if
					document.all("field"+id).value=id1(0)
                    if (type1=9 and <%=docFlags%>="1") then
                    document.all("CreateNewDoc").innerHtml=""
                    end if

				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
  					if (type1=9 and <%=docFlags%>="1") then
                    document.all("createNewDoc").innerHtml="<button id='createdoc' class=AddDocFlow onclick=createDoc("+id+",'','1') title='<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>"
                    end if
				end if
			end if
		end if
	end if
end sub


sub onShowResourceConditionBrowser(id,url,linkurl,type1,ismand)

	tmpids = document.all("field"+id).value
	dialogId = window.showModalDialog(url&"?resourceCondition="&tmpids)
	if (Not IsEmpty(dialogId)) then
	if dialogId(0)<> "" then
	    shareTypeValues = dialogId(0)
		shareTypeTexts = dialogId(1)
		relatedShareIdses = dialogId(2)
		relatedShareNameses = dialogId(3)
		rolelevelValues = dialogId(4)
		rolelevelTexts = dialogId(5)
		secLevelValues = dialogId(6)
		secLevelTexts = dialogId(7)

		sHtml = ""
		fileIdValue=""
		shareTypeValues = Mid(shareTypeValues,2,len(shareTypeValues))
		shareTypeTexts = Mid(shareTypeTexts,2,len(shareTypeTexts))
		relatedShareIdses = Mid(relatedShareIdses,2,len(relatedShareIdses))
		relatedShareNameses = Mid(relatedShareNameses,2,len(relatedShareNameses))
		rolelevelValues = Mid(rolelevelValues,2,len(rolelevelValues))
		rolelevelTexts = Mid(rolelevelTexts,2,len(rolelevelTexts))
		secLevelValues = Mid(secLevelValues,2,len(secLevelValues))
		secLevelTexts = Mid(secLevelTexts,2,len(secLevelTexts))


		while InStr(shareTypeValues,"~") <> 0

			shareTypeValue = Mid(shareTypeValues,1,InStr(shareTypeValues,"~")-1)
			shareTypeText = Mid(shareTypeTexts,1,InStr(shareTypeTexts,"~")-1)
			relatedShareIds = Mid(relatedShareIdses,1,InStr(relatedShareIdses,"~")-1)
			relatedShareNames = Mid(relatedShareNameses,1,InStr(relatedShareNameses,"~")-1)
			rolelevelValue = Mid(rolelevelValues,1,InStr(rolelevelValues,"~")-1)
			rolelevelText = Mid(rolelevelTexts,1,InStr(rolelevelTexts,"~")-1)
			secLevelValue = Mid(secLevelValues,1,InStr(secLevelValues,"~")-1)
			secLevelText = Mid(secLevelTexts,1,InStr(secLevelTexts,"~")-1)

			shareTypeValues = Mid(shareTypeValues,InStr(shareTypeValues,"~")+1,Len(shareTypeValues))
			shareTypeTexts = Mid(shareTypeTexts,InStr(shareTypeTexts,"~")+1,Len(shareTypeTexts))
			relatedShareIdses = Mid(relatedShareIdses,InStr(relatedShareIdses,"~")+1,Len(relatedShareIdses))
			relatedShareNameses = Mid(relatedShareNameses,InStr(relatedShareNameses,"~")+1,Len(relatedShareNameses))
			rolelevelValues = Mid(rolelevelValues,InStr(rolelevelValues,"~")+1,Len(rolelevelValues))
			rolelevelTexts = Mid(rolelevelTexts,InStr(rolelevelTexts,"~")+1,Len(rolelevelTexts))
			secLevelValues = Mid(secLevelValues,InStr(secLevelValues,"~")+1,Len(secLevelValues))
			secLevelTexts = Mid(secLevelTexts,InStr(secLevelTexts,"~")+1,Len(secLevelTexts))

            fileIdValue=fileIdValue&"~"&shareTypeValue&"_"&relatedShareIds&"_"&rolelevelValue&"_"&secLevelValue

	        if shareTypeValue= "1" then
			    sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"
	        else	if  shareTypeValue= "2" then
			             sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18941,user.getLanguage())%>"
			        else   if shareTypeValue= "3" then
			                   sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18942,user.getLanguage())%>"
					       else  if shareTypeValue= "4" then
			                         sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"&"<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>="&rolelevelText&"  <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18945,user.getLanguage())%>"
						         else
			                         sHtml = sHtml&","&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18943,user.getLanguage())%>"
								 end if
						   end if
					end if
	        end if
		wend

            fileIdValue=fileIdValue&"~"&shareTypeValues&"_"&relatedShareIdses&"_"&rolelevelValues&"_"&secLevelValues


	        if shareTypeValues= "1" then
			    sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"
	        else	if  shareTypeValues= "2" then
			             sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18941,user.getLanguage())%>"
			        else   if shareTypeValues= "3" then
			                   sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18942,user.getLanguage())%>"
					       else  if shareTypeValues= "4" then
			                         sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"&"<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>="&rolelevelTexts&"  <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18945,user.getLanguage())%>"
						         else
			                         sHtml = sHtml&","&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18943,user.getLanguage())%>"
								 end if
						   end if
					end if
	        end if

		sHtml = Mid(sHtml,2,len(sHtml))
		fileIdValue=Mid(fileIdValue,2,len(fileIdValue))

		document.all("field"+id).value= fileIdValue
		document.all("field"+id+"span").innerHtml = sHtml
	else
        if ismand=0 then
                document.all("field"+id+"span").innerHtml = empty
        else
                document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
        end if
        document.all("field"+id).value=""
	end if
	end if

end sub





</script>
<script type="text/javascript">
function onShowCptCapital(inputnames,inputnumbers,inputcount,ismand){
	var spanname="field"+inputnames+"span";
	var inputname="field"+inputnames;
	var inputnumber="field"+inputnumbers;
	var inputnumberspan="field"+inputnumbers+"span";
	var data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp&inculdeNumZero=0");
	if(data){
		if(data.id!=""&&data.id!="0"){
			document.all(spanname).innerHtml = data.name;
			document.all(inputname).value=data.id;
		    //document.all(inputnumber).value=id(7)
		    //document.all(inputcount).value=id(7)
		    document.all(inputnumberspan).innerHtml =  "";
		}else{
			if(ismand==1){
				//document.all(spanname).innerHtml =  "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			}else{
				document.all(spanname).innerHtml =  ""
			}
			document.all(inputname).value="";
		}
	}
	
}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
