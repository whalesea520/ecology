<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.TimeUtil" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="FieldFormSelect" class="weaver.workflow.field.FieldFormSelect" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>

<!--yl qc:67452 start-->
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<!--yl qc:67452 end-->
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
<%
    // yl qc:67452 start
    String selectInitJsStr = "";
    String initIframeStr = "";
//yl qc:67452 end
int languagebodyid = user.getLanguage() ;
ArrayList uploadfieldids=new ArrayList();    
String newfromdate="a";
String newenddate="b";
String workflowid=Util.null2String(request.getParameter("workflowid"));
String workflowtype=Util.null2String(request.getParameter("workflowtype"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String formid=Util.null2String(request.getParameter("formid"));
//对不同的模块来说,可以定义自己相关的工作流
String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
//......
String topage = Util.null2String(request.getParameter("topage"));
int messageType=Util.getIntValue(request.getParameter("messageType"),0);
int chatsType=Util.getIntValue(request.getParameter("chatsType"),0);//微信提醒(QC:98106)
int defaultName= Util.getIntValue(request.getParameter("defaultName"),0);

String docCategory=Util.null2String(request.getParameter("docCategory"));

int userid=user.getUID();
String logintype = user.getLogintype();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

String resourceid=hrmid;
if(hrmid.equals(""))	resourceid=""+user.getUID();

String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
String needcheck="requestname";
String isSignMustInput="0";
String needcheck10404 = "";
RecordSet.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
	if("1".equals(isSignMustInput)){
		needcheck10404 = ",remarkText10404";
	}
}
//微信提醒(QC:98106)
int chatsisedit=0;
RecordSet.execute("select isedit from workflow_nodeform where fieldid= -5 and nodeid="+nodeid);
if(RecordSet.next()){ 
    chatsisedit=Util.getIntValue(RecordSet.getString("isedit"),0); 
}  
//微信提醒(QC:98106)
String docFlags=(String)session.getAttribute("requestAdd"+user.getUID());
String isbill = "1";
//获得触发字段名


DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();
//ArrayList selfieldsadd=WfLinkageInfo.getSelectField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
//ArrayList changefieldsadd=WfLinkageInfo.getChangeField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
%>

<!--增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<%
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
String keywordismand="0";
String keywordisedit="0";
int titleFieldId=0;
int keywordFieldId=0;
String isSignDoc_add="";
String isSignWorkflow_add="";
String smsAlertsType="";
String chatsAlertType=""; //微信提醒（QC：98106）


RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow,smsAlertsType,chatsAlertType from workflow_base where id="+workflowid);
if(RecordSet.next()){
    titleFieldId=Util.getIntValue(RecordSet.getString("titleFieldId"),0);
	keywordFieldId=Util.getIntValue(RecordSet.getString("keywordFieldId"),0);
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
    smsAlertsType=Util.null2String(RecordSet.getString("smsAlertsType")); 
    chatsAlertType=Util.null2String(RecordSet.getString("chatsAlertType")); //微信提醒（QC：98106）


}
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
ArrayList changefieldsadd=WfLinkageInfo.getChangeField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);

 
  weaver.crm.Maint.CustomerInfoComInfo customerInfoComInfo = new weaver.crm.Maint.CustomerInfoComInfo();
  String usernamenew = "";
 	if(user.getLogintype().equals("1"))
 		usernamenew = user.getLastname();
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

    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=60 >";  
    document.getElementById(objName).outerHTML=outerHTML;       
    document.getElementById(objName).onchange=tempObjonchange;
}

  function addannexRow(accname)
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
          var sHtml = "<input class=InputStyle  type=file size=60 name='"+accname+"_"+document.all(accname+'_num').value+"' onchange='accesoryChanage(this)'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }
</script>

<div align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</div>
<!--增加提示信息  结束-->
<form name="frmmain" method="post" action="OvertimeOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="workflowtype" value=<%=workflowtype%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="0">
<input type=hidden name="src">
<input type=hidden name="iscreate" value="1">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="isbill" value="1">
<input type=hidden name ="topage" value="<%=topage%>">
<input type=hidden name ="messageType" value="<%=messageType%>">
<input type=hidden name ="chatsType" value="<%=chatsType%>"><!-- 微信提醒（QC:98106） -->
<input type="hidden" name="htmlfieldids">
  <div style="visibility:hidden;">
    <BUTTON class=btn accessKey=B type=button onclick="doSubmit()"><U>B</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button> 
    <BUTTON class=btnSave accessKey=S type=button onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button> 
  </div>
  <br>
  <table class="viewform">
    <colgroup> <col width="20%"> <col width="80%">
    <tr class="Spacing"> 
      <td class="Line1" colspan=2></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
      <td class=field> 
      <%if(defaultName==1){%>
       <%--xwj for td1806 on 2005-05-09--%>
        <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=60  maxlength=100  value = "<%=Util.toScreenToEdit(txtuseruse,user.getLanguage() )%>" >
        <span id=requestnamespan>
		
 	<%
		 if(txtuseruse.equals("")){
		%>	
		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		 <%}
		%>
		</span>
      <%}else{%>
        <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=60  maxlength=100  value = "" >
        <span id=requestnamespan><img src="/images/BacoError.gif" align=absmiddle></span>
      <%}%>
        <input type=radio value="0" name="requestlevel" checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio value="1" name="requestlevel"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
        <input type=radio value="2" name="requestlevel"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
      </td>
     </tr>
<tr><td class=Line1 colSpan=2></td></tr>

  <!--短信设置行开始 -->
  <%
    if(messageType == 1){
  %>
  <tr>
    <td > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></td>
    <td class=field>
	      <span id=messageTypeSpan></span>
	      <input type=radio value="0" name="messageType" <% if(smsAlertsType.equals("0")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
	      <input type=radio value="1" name="messageType" <% if(smsAlertsType.equals("1")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
	      <input type=radio value="2" name="messageType" <% if(smsAlertsType.equals("2")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
	    </td>
  </tr>
  <tr><td class=Line2 colSpan=2></td></tr>

  <%}%>
  <!--短信设置行结束 -->
  <!-- 微信提醒（QC:98106） -->
  <%
   if(chatsType == 1){
  if(chatsisedit==1){   
  %>
  <tr>
    <td class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%></td>
    <td class="fieldvalueClass">
	      <span id=chatsTypeSpan></span>
	      <input type=radio value="0" name="chatsType" <% if(chatsAlertType.equals("0")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
	      <input type=radio value="1" name="chatsType" <% if(chatsAlertType.equals("1")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>
	     </td>
  </tr>
  <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>

  <%}else{%>
   <tr>
    <td class="fieldvalueClass"> <%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%></td> 
	      <% if(chatsAlertType.equals("0")) {%> <td class=field>
	      <span id=chatsTypeSpan></span><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>  </td> <%}%>
	       <% if(chatsAlertType.equals("1")) {%><td class=field>
	      <span id=chatsTypeSpan></span><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>  </td><%}%>
  </tr>
  <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>   <%} }%> 
  <!-- 微信提醒（QC:98106） -->
     <tr>     
      <td><%=SystemEnv.getHtmlLabelName(850,user.getLanguage())%></td>
      <td  class=field>
      	<span id=resourceidspan><a href="javaScript:openhrm(<%=resourceid%>);" onclick='pointerXY(event);'>
      	<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a>
      	</span>
        <INPUT class=Inputstyle type=hidden name="resourceid" value="<%=resourceid%>">
      </td>
    </tr>
  <tr><td class=Line2 colSpan=2></td></tr>
<%
ArrayList fieldids=new ArrayList();
ArrayList fieldlabels=new ArrayList();
ArrayList fieldhtmltypes=new ArrayList();
ArrayList fieldtypes=new ArrayList();
ArrayList fieldnames=new ArrayList();
ArrayList fielddbtypes = new ArrayList();
RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	fieldids.add(RecordSet.getString("id"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
	fieldnames.add(RecordSet.getString("fieldname"));
	fielddbtypes.add(RecordSet.getString("fielddbtype"));
}

ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();
ArrayList isedits=new ArrayList();
ArrayList ismands=new ArrayList();
RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
	isviews.add(RecordSet.getString("isview"));
	isedits.add(RecordSet.getString("isedit"));
	ismands.add(RecordSet.getString("ismandatory"));
}

// 得到每个字段的信息并在页面显示


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

for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);
	//if(fieldname.equals("resourceid")) continue ;
	String fieldid=(String)fieldids.get(i);
	//String isview=(String)isviews.get(i);
	//String isedit=(String)isedits.get(i);
	//String ismand=(String)ismands.get(i);
	String isview="0";
	String isedit="0";
	String ismand="0";
    int isfieldidindex = isfieldids.indexOf(fieldid) ;
    if( isfieldidindex != -1 ) {
        isview=(String)isviews.get(isfieldidindex);    //字段是否显示
	    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
	    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
    }
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fielddbtype = (String) fielddbtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
   	if(fieldname.equals("begindate")) newfromdate="field"+fieldid;
	if(fieldname.equals("enddate")) newenddate="field"+fieldid;
	if(fieldname.equals("resourceid")){ 
%>
	    <input type=hidden name="field<%=fieldid%>" value="<%=resourceid%>">
<%
		continue ;
	}   

 /*---xwj for td3130 20051124 begin ---*/
  preAdditionalValue = "";
  isSetFlag = false;//added by xwj for td3359 20051222
    //将节点前附加操作移出循环外操作减少数据库访问量


  //rsaddop.executeSql("select customervalue from workflow_addinoperate where workflowid=" + workflowid + " and ispreadd='1' and isnode = 1 and objid = "+nodeid+" and fieldid = " + fieldbodyid);
  int inoperateindex=inoperatefields.indexOf(fieldid);
  if(inoperateindex>-1){
  isSetFlag = true;
  preAdditionalValue = (String)inoperatevalues.get(inoperateindex);
  }
  /*---xwj for td3130 20051124 end ---*/

    if(fieldname.equals("manager")) {
	    String tmpmanagerid = ResourceComInfo.getManagerID(beagenter);
%>
	<input type=hidden name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=tmpmanagerid%>" />
<%
        if(isview.equals("1")){
%> <tr>
      <td <%if(fieldhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldlable,user.getLanguage())%> </td>
      <td class=field>
      	<a href="javaScript:openhrm(<%=tmpmanagerid%>);" onclick='pointerXY(event);'><%=ResourceComInfo.getLastname(tmpmanagerid)%></a>
      </td>
   </tr><tr><td class=Line2 colSpan=2></td></tr>
<%
        }
	    continue;
	}

    if( ! isview.equals("1") ) { //不显示即进行下一步循环,除了人力资源字段，应该隐藏人力资源字段，因为人力资源字段有可能作为流程下一节点的操作者


        if(fieldhtmltype.equals("3") && (fieldtype.equals("1") ||fieldtype.equals("17")||fieldtype.equals("165")||fieldtype.equals("166")) && !preAdditionalValue.equals("")){           
           out.println("<input type=hidden name=field"+fieldid+" value="+preAdditionalValue+">");
        }        
        continue ;                  
    }
%>
    <tr> 
      <%if(fieldhtmltype.equals("2")){%>
      <td valign=top><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}else{%>
      <td><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}%>
      <td class=field> 
        <%
	if(fieldhtmltype.equals("1")){
		if(fieldtype.equals("1")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text  class=Inputstyle  viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')" style="width:50%" value="<%=preAdditionalValue%>">
        <span id="field<%=fieldid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text  class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> name="field<%=fieldid%>" style="width:50%" value="<%=preAdditionalValue%>" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))">
        <span id="field<%=fieldid%>span"></span>
        <%}
			}else{ %>
            <span id="field<%=fieldid%>span"><%=preAdditionalValue%></span>
            <input  type=hidden class=Inputstyle name="field<%=fieldid%>"  size=50 value="<%=preAdditionalValue%>">
      <%          }
		}
		else if(fieldtype.equals("2")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text  class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" style="width:50%"
		onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>">
        <span id="field<%=fieldid%>span"><img src="/images/BacoError.gif" align=absmiddle></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text  class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>" style="width:50%">
        <span id="field<%=fieldid%>span"></span>
        <%}
			}
		}
		else if(fieldtype.equals("3")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text  class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" style="width:50%"
		onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>">
        <span id="field<%=fieldid%>span"><img src="/images/BacoError.gif" align=absmiddle></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text  class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>" style="width:50%">
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
			<script>document.getElementById("htmlfieldids").value += "field<%=fieldid%>;<%=Util.toScreen(fieldlable,languagebodyid)%>;<%=fieldtype%>,";</script>
				<%
			if(ismand.equals("1")) {%>
        <textarea  class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))"
		rows="4" cols="40" style="width:80%" onblur="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>"></textarea>
        <span id="field<%=fieldid%>span"><img src="/images/BacoError.gif" align=absmiddle></span> 
        <%
				needcheck+=",field"+fieldid;
			}else{%>
        <textarea onblur="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>"  class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" rows=4 cols=40 style="width:80%" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))"></textarea>
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
		    String showid = "";                                     // 新建时候默认值




		if(fieldtype.equals("8") && !prjid.equals("")){
			showid ="" + Util.getIntValue(prjid,0);
		}else if(fieldtype.equals("9") && !docid.equals("")){
			showid ="" +Util.getIntValue(docid,0);
		}else if(fieldtype.equals("1") && !hrmid.equals("")){
			showid ="" + Util.getIntValue(hrmid,0);
		}else if(fieldtype.equals("7") && !crmid.equals("")){
			showid ="" + Util.getIntValue(crmid,0);
		}else if((fieldtype.equals("4") || fieldtype.equals("57") || fieldtype.equals("167") || fieldtype.equals("168")) && !hrmid.equals("")){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
            showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
		}else if((fieldtype.equals("164") || fieldtype.equals("169") || fieldtype.equals("170") || fieldtype.equals("194")) && !hrmid.equals("")){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
            showid = "" + Util.getIntValue(ResourceComInfo.getSubCompanyID(hrmid),0);
        }
            if(showid.equals("0")) showid = "" ;
            
            
            if(isSetFlag){
            showid = preAdditionalValue;//added by xwj for td3308 20051213
           }

           if(fieldtype.equals("2") || fieldtype.equals("19")  )	showname=showid; // 日期时间
            else if(! showid.equals("")){       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
                String sql="";
                if(showid.indexOf(",")==-1){
                    sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+showid;
                }else{
                    sql="select "+columname+" from "+tablename+" where "+keycolumname+" in("+showid+")";
                }
                //System.out.println("showid:"+showid);
				//System.out.println("sql:"+sql);
                RecordSet.executeSql(sql);
                while(RecordSet.next()) {
                	 if (!linkurl.equals(""))
                     {
                     	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                     	{
                     		showname += "<a href='javaScript:openhrm(" + showid + ");' onclick='pointerXY(event);'>" + RecordSet.getString(1) + "</a>&nbsp";
                     	}
                     	else
                         	showname += "<a href='" + linkurl + showid + "'>" + RecordSet.getString(1) + "</a>&nbsp";
                     }
                    else
                        showname +=RecordSet.getString(1) ;
                }
                //System.out.println("showname:"+showname);
            }
            if(fieldtype.equals("161")||fieldtype.equals("162")){
              url+="?type="+fielddbtype;
            }
		    if(isedit.equals("1")){
		%>
        <button class=Browser 
		<%if(fieldtype.equals("2")){%>
		  onClick="onShowFlowDate('<%=fieldid%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))"
		<%}if(fieldtype.equals("19")){%>
		  onClick="onShowFlowTime(field<%=fieldid%>span,field<%=fieldid%>,field<%=fieldid%>.getAttribute('viewtype'))"
		<%}else{%>
          onClick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))"
		<%}%>
		></button>
<%
			}
%>			
        <input type=hidden onpropertychange="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" value="<%=showid%>">
        <span id="field<%=fieldid%>span"> 
        <%=Util.toScreen(showname,user.getLanguage())%>
        <%if(ismand.equals("1") && showname.equals("")){%>
        <img src="/images/BacoError.gif" align=absmiddle> 
        <%	needcheck+=",field"+fieldid;	
			}%>
        </span> 
        <%
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	}
	else if(fieldhtmltype.equals("4")){
	%>
        <input type=checkbox onchange="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" value=1 name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> >
        <%
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
        }
        else if(fieldhtmltype.equals("5")){
        //yl 67452   start
        String uploadMax = "";
        if(fieldid.equals(selectedfieldid)&&uploadType==1)
        {
            uploadMax = "changeMaxUpload('field"+fieldid+"');reAccesoryChanage();";
        }
        //处理select字段联动
        String onchangeAddStr = "";
        int childfieldid_tmp = 0;
        if("0".equals(isbill)){
            rs.execute("select childfieldid from workflow_formdict where id="+fieldid);
        }else{
            rs.execute("select childfieldid from workflow_billfield where id="+fieldid);
        }
        if(rs.next()){
            childfieldid_tmp = Util.getIntValue(rs.getString("childfieldid"), 0);
        }
        int firstPfieldid_tmp = 0;
        boolean hasPfield = false;
        if("0".equals(isbill)){
            rs.execute("select id from workflow_formdict where childfieldid="+fieldid);
        }else{
            rs.execute("select id from workflow_billfield where childfieldid="+fieldid);
        }
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




	%><select class=inputstyle viewtype="<%=ismand%>"        <%=onchangeAddStr%>        temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> onBlur="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%if(selfieldsadd.indexOf(fieldid)>=0){%> onChange="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}%>>
	<%
	char flag=2;
        boolean checkempty = true;
        String finalvalue = "";
	rs.executeProc("workflow_selectitembyid_new",""+fieldid+flag+"1");
        //yl 67452   start
        if(hasPfield == false){
	while(rs.next()) {
		int tmpselectvalue = rs.getInt("selectvalue");
		String tmpselectname = rs.getString("selectname");
	%>
	<option value="<%=tmpselectvalue%>"><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
	<%}
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
                        selectInitJsStr += "doInitChildSelect("+fieldid+","+firstPfieldid_tmp+",\""+finalvalue+"\");\n";
                        initIframeStr += "<iframe id=\"iframe_"+firstPfieldid_tmp+"_"+fieldid+"_00\" frameborder=0 scrolling=no src=\"\"  style=\"display:none\"></iframe>";

                    //yl 67452   end


    }%>
	</select>
        <%
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
        }else if(fieldhtmltype.equals("6")){

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
            button_image_url : "/js/swfupload/add.png",
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldid%>",
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
            oUpload<%=fieldid%>=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	window.attachEvent("onload", fileupload<%=fieldid%>);
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolder<%=fieldid%>"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload<%=fieldid%>.cancelQueue();showmustinput(oUpload<%=fieldid%>);" id="btnCancel<%=fieldid%>">
									<span><img src="/js/swfupload/delete.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span id="uploadspan">(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                      <span id="field<%=fieldid%>span">
				<%
				 if(ismand.equals("1")){
				needcheck+=",field"+fieldid;
				%>
			   <img src='/images/BacoError.gif' align=absMiddle>
			  <%
					}
			   %>
	     </span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>"  viewtype="<%=ismand%>">
              </td>
          </tr>
          <tr>
              <td colspan="2">
                  <div class="fieldset flash" id="fsUploadProgress<%=fieldid%>">
                  </div>
                  <div id="divStatus<%=fieldid%>"></div>
              </td>
          </tr>
      </TABLE>
            <%}%>
          <input type=hidden name='mainId' value=<%=mainId%>>
          <input type=hidden name='subId' value=<%=subId%>>
          <input type=hidden name='secId' value=<%=secId%>>
      <%
              }
       }

%>
      </td>
    </tr>
	<tr><td class=Line2 colSpan=2></td></tr>
    <%
}
%>
    <tr class="Title">
      <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></td>
      <td class=field>
		<input type="hidden" id="remarkText10404" name="remarkText10404" value="" temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>">
        <textarea  class=Inputstyle  name=remark rows=4 cols=40 style="width=80%;display:none" temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"  <%if(isSignMustInput.equals("1")){%>onChange="checkinput('remark','remarkSpan')"<%}%> ></textarea>
<script defer>
function funcremark_log(){
	CkeditorExt.initEditor("frmmain","remark",<%=user.getLanguage()%>,CkeditorExt.NO_IMAGE, 200);
	<%if(isSignMustInput.equals("1")){%>
	CkeditorExt.checkText("remarkSpan","remark");
	<%}%>
	CkeditorExt.toolbarExpand(false,"remark");
}
if(ieVersion>=8) window.attachEvent("onload", funcremark_log());
else window.attachEvent("onload", funcremark_log);
</script>
<span id="remarkSpan">
<%
	if(isSignMustInput.equals("1")){
%>
			  <img src="/images/BacoError.gif" align=absmiddle>
<%
	}
%>
              </span>
      </td>
    </tr>
    <tr><td class=Line2 colSpan=2></td></tr>
  <%
         if("1".equals(isSignDoc_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids">
                <button class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids">
                <button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
         if("1".equals(isannexupload_add)){
            int annexmainId=0;
             int annexsubId=0;
             int annexsecId=0;
             String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
             if("1".equals(isannexupload_add) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
                annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
                annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
                annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
              }
             int annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
             if(annexmaxUploadImageSize<=0){
                annexmaxUploadImageSize = 5;
             }
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
            <td class=field>
          <%if(annexsecId<1){%>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(21418,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}else{%>
            <script>
          var oUploadannexupload;
          function fileuploadannexupload() {
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId":"<%=annexmainId%>",
                "subId":"<%=annexsubId%>",
                "secId":"<%=annexsecId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>"
            },
            file_size_limit :"<%=annexmaxUploadImageSize%> MB",
            file_types : "*.*",
            file_types_description : "All Files",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgressannexupload",
                cancelButtonId : "btnCancelannexupload",
                uploadfiedid:"field-annexupload"
            },
            debug: false,


            // Button settings

            button_image_url : "/js/swfupload/add.png",    // Relative to the SWF file
            button_placeholder_id : "spanButtonPlaceHolderannexupload",

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
            file_dialog_complete_handler : fileDialogComplete_2,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete    // Queue plugin event
        };


        try {
            oUploadannexupload=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	window.attachEvent("onload", fileuploadannexupload);
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolderannexupload"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUploadannexupload.cancelQueue();" id="btnCancelannexupload">
									<span><img src="/js/swfupload/delete.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span>(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=annexmaxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field-annexupload" >
              </td>
          </tr>
          <tr>
              <td colspan="2">
                  <div class="fieldset flash" id="fsUploadProgressannexupload">
                  </div>
                  <div id="divStatusannexupload"></div>
              </td>
          </tr>
      </TABLE>
              <input type=hidden name='annexmainId' value=<%=annexmainId%>>
              <input type=hidden name='annexsubId' value=<%=annexsubId%>>
              <input type=hidden name='annexsecId' value=<%=annexsecId%>>
          </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}}%>
  </table>

<!-- yl qc:67452 start-->
<%=initIframeStr%>
<!-- yl qc:67452 end-->
  <input type=hidden name ="needcheck" value="<%=needcheck+needcheck10404%>">
<input type=hidden name ="inputcheck" value="">
</form> 
<script language=vbs>
sub onShowResourceID(ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
	frmmain.resourceid.value=id(0)
	else 
		if ismand=1 then
			resourceidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		else
			resourceidspan.innerHtml = ""
		end if
	frmmain.resourceid.value="0"
	end if
	end if
end sub
</script> 
<script language=javascript>

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
if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != ""){
			YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
			MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
			DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
			YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
			MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
			DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
			// window.alert(YearFrom+MonthFrom+DayFrom);
                   if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
        window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
         return false;
  			 }
  }
     return true; 
}

    function doSave(){              <!-- 点击保存按钮 -->
        var ischeckok="";
         
        try{
        //if(check_form(document.frmmain,document.all("needcheck").value+document.all("inputcheck").value))
        if(check_form(document.frmmain, "name"))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
            //if(check_form(document.frmmain,'<%=needcheck+needcheck10404%>'))
            if(check_form(document.frmmain, "name"))
                ischeckok="true";
        }
        if(ischeckok=="true"){
            if(checktimeok()) {
                    document.frmmain.src.value='save';
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

                   //增加提示信息  开始


		           			var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
		           			showPrompt(content);
                   //增加提示信息  结束

                    //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                }
            }
    }
    function doSubmit(obj){            <!-- 点击提交 -->	   
        var ischeckok="";
        try{
        if(check_form(document.frmmain,document.all("needcheck").value+document.all("inputcheck").value))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
          if(check_form(document.frmmain,'<%=needcheck+needcheck10404%>'))
            ischeckok="true";
        }
        if(ischeckok=="true"){
            if(checktimeok()) {
                document.frmmain.src.value='submit';
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

               //增加提示信息  开始


		       		  var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
		       		  showPrompt(content);
               //增加提示信息  结束

                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
            }
        }
    }
	function showPrompt(content)
{

     var showTableDiv  = document.getElementById('_xTable');
     var message_table_Div = document.createElement("<div>")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = document.getElementById("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     message_table_Div.style.posTop=pTop;
     message_table_Div.style.posLeft=pLeft;

     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
}
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
	    var titleObj=document.getElementById("name");
	    var keywordObj=document.getElementById("field<%=keywordFieldId%>");

        if(titleObj!=null&&keywordObj!=null){

		    document.getElementById("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?operation=UpdateKeywordData&docTitle="+titleObj.value;
	    }
<%
   }
%>
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
                var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
                $GetEle("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
            }
        }
    }catch(e){}
}
<%=selectInitJsStr%>
//yl qc:67452 end




  setTimeout("doTriggerInit()",1000);
  function doTriggerInit(){
      var tempS = "<%=trrigerfield%>";
      datainput(tempS);
  }
  function datainput(parfield){                <!--数据导入-->
      var tempParfieldArr = parfield.split(",");
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%="1"%>&node=<%=nodeid%>&detailsum=<%="0"%>&trg="+parfield;
      for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
      <%
      if(!trrigerfield.trim().equals("")){
          ArrayList Linfieldname=ddi.GetInFieldName();
          ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          if(document.all("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          if(document.all("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          }
      %>
      }
      //alert(parfield);
      //alert(StrData);
      document.all("datainputform").src="DataInputFrom.jsp?"+StrData;
  }
</script> 
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
<script type="text/javascript" src="/js/selectDateTime.js"></script>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>