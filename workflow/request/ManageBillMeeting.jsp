
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@page import="weaver.formmode.tree.CustomTreeUtil"%>
<%@ page import="weaver.meeting.MeetingBrowser"%>
<%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="MeetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for @td2977 20051111-->
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" /><%----- xwj for td3323 20051209  ------%>
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="scci" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog1" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog2" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page" />
<%@page import = "weaver.general.TimeUtil"%><!--added by xwj for td2891-->
<jsp:useBean id="rsCheckUserCreater" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<jsp:useBean id="RequestLogOperateName" class="weaver.workflow.request.RequestLogOperateName" scope="page"/>
<jsp:useBean id="resourceComInfo_mbm" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="departmentComInfo_mbm" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="docinfmeet" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfomeet" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfomeet" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<%
String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));
%>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<!-- browser 相关 -->
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/workflow/exceldesign/css/excelHtml_wev8.css" />
<!--增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<!--增加提示信息  结束-->
<form name="frmmain" method="post" action="BillMeetingOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback"  id="needwfback" value="1"/>
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>
<input type=hidden name="f_weaver_belongto_userid" value=<%=f_weaver_belongto_userid%>>
<input type=hidden name ="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>">
<input type="hidden" name="htmlfieldids">
<!--请求的标题开始 -->
<DIV align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</DIV>
<!--请求的标题结束 -->

<!--yl qc:67452 start-->
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<!--yl qc:67452 end-->
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<BR>
<%----- xwj for td3323 20051209 begin ------%>
<%@ include file="/activex/target/ocxVersion.jsp" %>
<OBJECT ID="oFile" <%=strWeaverOcxInfo%> STYLE="height:0px;width:0px;overflow:hidden;"></OBJECT>
<%
int languagebodyid = user.getLanguage() ;
HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息
String needconfirm="";
String isannexupload_edit="";
String annexdocCategory_edit="";
String isSignDoc_edit="";
String isSignWorkflow_edit="";
String showDocTab_edit="";
String showWorkflowTab_edit="";
String showUploadTab_edit="";
// yl qc:67452 start
String selectInitJsStr = "";
String initIframeStr = "";
String MeetingID = "";
String meetingtype = "";
String meetingtypeEdit = "0";
String bclick="";
String isbrowisMust = "";
//yl qc:67452 end
RecordSetLog.execute("select needAffirmance,isannexupload,annexdocCategory,isSignDoc,isSignWorkflow,showDocTab,showWorkflowTab,showUploadTab from workflow_base where id="+workflowid);
if(RecordSetLog.next()){
    needconfirm=Util.null2o(RecordSetLog.getString("needAffirmance"));
    isannexupload_edit=Util.null2String(RecordSetLog.getString("isannexupload"));
    annexdocCategory_edit=Util.null2String(RecordSetLog.getString("annexdocCategory"));
    isSignDoc_edit=Util.null2String(RecordSetLog.getString("isSignDoc"));
    isSignWorkflow_edit=Util.null2String(RecordSetLog.getString("isSignWorkflow"));
    showDocTab_edit=Util.null2String(RecordSetLog.getString("showDocTab"));
    showWorkflowTab_edit=Util.null2String(RecordSetLog.getString("showWorkflowTab"));
    showUploadTab_edit=Util.null2String(RecordSetLog.getString("showUploadTab"));
}
    String ismode= Util.null2String(request.getParameter("ismode"));


String newfromtime="";
String newendtime="";
String Address="";
 RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid+"");
 String docCategory_ = "";
 if(RecordSet.next()){
	docCategory_ = RecordSet.getString("docCategory");
 }
 int secid = Util.getIntValue(docCategory_.substring(docCategory_.lastIndexOf(",")+1),-1);
 int maxUploadImageSize = DocUtil.getMaxUploadImageSize(secid);
 if(maxUploadImageSize<=0){
 maxUploadImageSize = 5;
 }
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(workflowid,nodeid,0);
ArrayList changefieldsadd=WfLinkageInfo.getChangeField(workflowid,nodeid,0);
String isSignMustInput="0";
String needcheck10404 = "";
RecordSet.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
	if("1".equals(isSignMustInput)){
		needcheck10404 = ",remarkText10404";
	}
}
%>
<script language=javascript>
function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        var oFile=$GetEle("oFile");
        oFile.FilePath=objValue;
        fileLenth= oFile.getFileSize();
    } catch (e){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20253,user.getLanguage())%>");
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1) 
    if (fileLenthByM><%=maxUploadImageSize%>) {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    var  newObj = document.createElement("input");
    newObj.name=objName;
    newObj.className="InputStyle";
    newObj.type="file";
    newObj.size=70;
    newObj.onchange=function(){accesoryChanage(this);};

    var objParentNode = obj.parentNode;
    var objNextNode = obj.nextSibling;
    obj.removeNode();
    objParentNode.insertBefore(newObj,objNextNode);
}
</script>
<%----- xwj for td3323 20051209 end ------%>
<TABLE class="ViewForm">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">

  <%//xwj for td1834 on 2005-05-22
    String isEdit_ = "-1";
    RecordSet.executeSql("select isedit from workflow_nodeform where nodeid = " + String.valueOf(nodeid) + " and fieldid = -1");
    if(RecordSet.next()){
   isEdit_ = Util.null2String(RecordSet.getString("isedit"));
    }

    //获得触发字段名 mackjoe 2005-07-22
    DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
    String trrigerfield=ddi.GetEntryTriggerFieldName();

  %>

  <!--新建的第一行，包括说明和重要性 -->
  <TR class="Spacing" style="height:1px;">
    <TD class="Line1" colSpan=2></TD>
  </TR>
  <TR>
    <TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
    <TD class="fieldvalueClass">

        <%if(!"1".equals(isEdit_)){//xwj for td1834 on 2005-05-22
          if(!"0".equals(nodetype)){%>
       <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
       <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
          <%}
          else{%>
          <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
          <%}
         }
       else{%>
        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%}%>

      <%
      String isEditREQL = "-1";
      if(!"0".equals(nodetype)){
          RecordSet.executeSql("select isedit from workflow_nodeform where nodeid = " + String.valueOf(nodeid) + " and fieldid = -2");
          if(RecordSet.next()) isEditREQL = Util.null2String(RecordSet.getString("isedit"));
      }
      if("0".equals(nodetype)||(!"0".equals(nodetype)&&isEditREQL.equals("1"))){%>
      <input type=radio value="0" name="requestlevel" <%if(requestlevel.equals("0")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <input type=radio value="1" name="requestlevel" <%if(requestlevel.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <input type=radio value="2" name="requestlevel" <%if(requestlevel.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
      <%}else{%>
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
      <%}%>

        </TD></TR>
        <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
      <!--add by xhheng @ 2005/01/25 for 消息提醒 Request06，流转过程中察看短信设置 -->
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%
      String sqlWfMessage = "select messageType,docCategory from workflow_base where id="+workflowid;
      int wfMessageType=0;
      String docCategory="";
      rs.executeSql(sqlWfMessage);
      if (rs.next()) {
        wfMessageType=rs.getInt("messageType");
        docCategory=rs.getString("docCategory");
      }
      if(wfMessageType == 1){
        String sqlRqMessage = "select messageType from workflow_requestbase where requestid="+requestid;
        int rqMessageType=0;
        rs.executeSql(sqlRqMessage);
        if (rs.next()) {
          rqMessageType=rs.getInt("messageType");
        }%>
        <%
        String isEditMSG = "-1";
        if(!"0".equals(nodetype)){
            RecordSet.executeSql("select isedit from workflow_nodeform where nodeid = " + String.valueOf(nodeid) + " and fieldid = -3");
            if(RecordSet.next()) isEditMSG = Util.null2String(RecordSet.getString("isedit"));
        }%>
        <TR>
        <TD class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
        <td class="fieldvalueClass">
        <%if( "0".equals(nodetype) || (!"0".equals(nodetype)&&isEditMSG.equals("1")) ){%>
        <span id=messageTypeSpan></span>
        <input type=radio value="0" name="messageType"   <%if(rqMessageType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
        <input type=radio value="1" name="messageType"   <%if(rqMessageType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
        <input type=radio value="2" name="messageType"   <%if(rqMessageType==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
        <%}else{%>
        <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
        <%} else if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
        <%} else if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%> <%}%>
			<input type="hidden" value="<%=rqMessageType%>" id="messageType" name="messageType">
        <%}%>
        </TD></TR>
        <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
      <%}%>
  <!--第一行结束 -->
  <%
  if(formid==163){%>
  <TR>
  	<TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(19018,user.getLanguage())%></TD>
  	<TD class="fieldvalueClass"><a href="/car/CarUseInfo.jsp" target="_blank"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></a></TD>
  </TR>
  <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
  <%}%>
<%

//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）
String remindTypeNew="";
String remindImmediatelyV="";
String remindImmediately="";
String remindBeforeStart = "";
String remindBeforeEnd = "";
String remindBeforeStartV = "";
String remindBeforeEndV = "";
String remindHoursBeforeStart = "";
String remindTimesBeforeStart = "";
String remindHoursBeforeEnd = "";
String remindTimesBeforeEnd = "";
String meetingtype1="";
String crmsNumFieldId = "";

String repeatdays = "";
String repeatweeks = "";
String rptWeekDays = "";
String repeatmonths = "";
String repeatmonthdays = "";

String repeatdaysVl = "";
String repeatweeksVl = "";
String rptWeekDaysVl = "";
String repeatmonthsVl = "";
String repeatmonthdaysVl = "";

String caller="";
String crmids02 = "";
String hrmids02 = "";

String repeatType = "";

int temmhour=0;
int temptinme=0;
int temmhourend=0;
int temptinmeend=0;
ArrayList fieldids=new ArrayList();             //字段队列
ArrayList fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
ArrayList languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
ArrayList fieldlabels=new ArrayList();          //单据的字段的label队列
ArrayList fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
ArrayList fieldtypes=new ArrayList();           //单据的字段的type队列
ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
ArrayList fieldvalues=new ArrayList();          //字段的值
ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
ArrayList fieldimgwidths=new ArrayList();
ArrayList fieldimgheights=new ArrayList();
ArrayList fieldimgnums=new ArrayList();
ArrayList  fieldrealtype =  new ArrayList();
int detailno=0;
int detailsum=0;
String textheight = "4";//xwj for @td2977 20051111

if(isbill.equals("0")) {
    RecordSet.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formid+"  and t1.langurageid="+user.getLanguage()+" order by t2.fieldorder");

    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("fieldid")));
        fieldorders.add(Util.null2String(RecordSet.getString("fieldorder")));
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet.getString("langurageid")));
    }
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
        fieldimgwidths.add(Util.null2String(RecordSet.getString("imgwidth")));
        fieldimgheights.add(Util.null2String(RecordSet.getString("imgheight")));
        fieldimgnums.add(Util.null2String(RecordSet.getString("textheight")));
        fieldrealtype.add(Util.null2String(RecordSet.getString("fielddbtype")));
          RecordSet_nf1.executeSql("select * from workflow_nodeform where nodeid = "+nodeid+" and fieldid = " + RecordSet.getString("id"));
        if(!RecordSet_nf1.next()){
        RecordSet_nf2.executeSql("insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory) values("+nodeid+","+RecordSet.getString("id")+",'1','1','0')");
        }
    }
}

// 查询每一个字段的值
if( !isbill.equals("1")) {
    RecordSet.executeProc("workflow_FieldValue_Select",requestid+"");       // 从workflow_form表中查
    RecordSet.next();
    for(int i=0;i<fieldids.size();i++){
        String fieldname=FieldComInfo.getFieldname((String)fieldids.get(i));
        fieldvalues.add(Util.null2String(RecordSet.getString(fieldname)));
    }
}
else {
    RecordSet.executeSql("select tablename from workflow_bill where id = " + formid) ; // 查询工作流单据表的信息
    RecordSet.next();
    String tablename = RecordSet.getString("tablename") ;
    RecordSet.executeSql("select * from " + tablename + " where id = " + billid) ; // 对于默认的单据表,必须以id作为自增长的Primary key, billid的值就是id. 如果不是,则需要改写这个部分. 另外,默认的单据表必须有 requestid 的字段

    RecordSet.next();
	
	MeetingID = RecordSet.getString("approveid");
	meetingtype = RecordSet.getString("MeetingType");
    for(int i=0;i<fieldids.size();i++){
        String fieldname=(String)fieldnames.get(i);
        String tfieldvalue = Util.null2String(RecordSet.getString(fieldname));	
        fieldvalues.add(tfieldvalue);      
        if("remindImmediately".equals(fieldname))
        {
        	remindImmediatelyV = tfieldvalue;
        }
        if("remindBeforeStart".equals(fieldname))
        {
        	remindBeforeStartV = tfieldvalue;
        }
        if("remindBeforeEnd".equals(fieldname))
        {
        	remindBeforeEndV = tfieldvalue;
        }
        if("remindHoursBeforeStart".equals(fieldname))
        {
        	temmhour=Util.getIntValue(tfieldvalue,0);
        }
        if("remindTimesBeforeStart".equals(fieldname))
        {
    		temptinme=Util.getIntValue(tfieldvalue,0);
        }
        if("remindHoursBeforeEnd".equals(fieldname))
        {
    		temmhourend=Util.getIntValue(tfieldvalue,0);
        }
        if("remindTimesBeforeEnd".equals(fieldname))
        {
    		temptinmeend=Util.getIntValue(tfieldvalue,0);
        }
		if(fieldname.equalsIgnoreCase("repeatdays")) repeatdaysVl=tfieldvalue;
		if(fieldname.equalsIgnoreCase("repeatweeks")) repeatweeksVl=tfieldvalue;
		if(fieldname.equalsIgnoreCase("rptWeekDays")) rptWeekDaysVl=tfieldvalue;
		if(fieldname.equalsIgnoreCase("repeatmonths")) repeatmonthsVl=tfieldvalue;
		if(fieldname.equalsIgnoreCase("repeatmonthdays")) repeatmonthdaysVl=tfieldvalue;
		
    }
}

// 确定字段是否显示，是否可以编辑，是否必须输入
String resourceFieldId = "";
String crmFieldId = "";
String resourceNumFieldId = "";
ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();              //字段是否显示队列
ArrayList isedits=new ArrayList();              //字段是否可以编辑队列
ArrayList ismands=new ArrayList();              //字段是否必须输入队列

RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
    isviews.add(Util.null2String(RecordSet.getString("isview")));
    isedits.add(Util.null2String(RecordSet.getString("isedit")));
    ismands.add(Util.null2String(RecordSet.getString("ismandatory")));
}


// 得到每个字段的信息并在页面显示

for(int i=0;i<fieldids.size();i++){         // 循环开始
	int tmpindex = i ;
    if(isbill.equals("0")) tmpindex = fieldorders.indexOf(""+i);     // 如果是表单, 得到表单顺序对应的 i

	String fieldid=(String)fieldids.get(tmpindex);  //字段id

    if( isbill.equals("1")) {
        String viewtype = (String)fieldviewtypes.get(tmpindex) ;   // 如果是单据的从表字段,不显示
        if( viewtype.equals("1") ) continue ;
    }

    String isview="0" ;    //字段是否显示
	String isedit="0" ;    //字段是否可以编辑
	String ismand="0" ;    //字段是否必须输入

    int isfieldidindex = isfieldids.indexOf(fieldid) ;
    if( isfieldidindex != -1 ) {
        isview=(String)isviews.get(isfieldidindex);    //字段是否显示
	    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
	    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
		isbrowisMust = "";
		if ("1".equals(isedit)) {
			isbrowisMust = "1";
		}
		
		if ("1".equals(ismand)) {
			isbrowisMust = "2";
		}
    }

    String fieldname = "" ;                         //字段数据库表中的字段名
    String fieldhtmltype = "" ;                     //字段的页面类型
    String fieldtype = "" ;                         //字段的类型
    String fieldlable = "" ;                        //字段显示名
    String fielddbtype = "";
    int languageid = 0 ;
    int fieldimgwidth=0;                            //图片字段宽度
    int fieldimgheight=0;                           //图片字段高度
    int fieldimgnum=0;                              //每行显示图片个数

    if(isbill.equals("0")) {
        languageid= Util.getIntValue( (String)languageids.get(tmpindex), 0 ) ;    //需要更新
        fieldhtmltype=FieldComInfo.getFieldhtmltype(fieldid);
        fieldtype=FieldComInfo.getFieldType(fieldid);
        fieldlable=(String)fieldlabels.get(tmpindex);
        fieldname=FieldComInfo.getFieldname(fieldid);
        fieldimgwidth=FieldComInfo.getImgWidth(fieldid);
		fieldimgheight=FieldComInfo.getImgHeight(fieldid);
		fieldimgnum=FieldComInfo.getImgNumPreRow(fieldid);
    }
    else {
        languageid = user.getLanguage() ;
        fieldname=(String)fieldnames.get(tmpindex);
        fieldhtmltype=(String)fieldhtmltypes.get(tmpindex);
        fieldtype=(String)fieldtypes.get(tmpindex);
        fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(tmpindex),0),languageid );
        fieldimgwidth=Util.getIntValue((String)fieldimgwidths.get(tmpindex),0);
		fieldimgheight=Util.getIntValue((String)fieldimgheights.get(tmpindex),0);
		fieldimgnum=Util.getIntValue((String)fieldimgnums.get(tmpindex),0);
		fielddbtype = (String)fieldrealtype.get(tmpindex);
    }
    String fieldvalue=(String)fieldvalues.get(tmpindex);

    if(fieldname.equals("manager")) {
	    String tmpmanagerid = ResourceComInfo.getManagerID(""+userid);
%>
	<input type=hidden name="field<%=fieldid%>" value="<%=tmpmanagerid%>">
<%
	    continue;
	}

	if(fieldname.equalsIgnoreCase("begindate")) newfromdate="field"+fieldid;      //开始日期,主要为开始日期不大于结束日期进行比较
	if(fieldname.equalsIgnoreCase("enddate")) newenddate="field"+fieldid;     //结束日期,主要为开始日期不大于结束日期进行比较
    if(fieldname.equalsIgnoreCase("begintime")) newfromtime="field"+fieldid;
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
	
	if(fieldname.equalsIgnoreCase("crmsNumber")) crmsNumFieldId = "field" + fieldid;
	
	if(fieldname.equalsIgnoreCase("repeatType")) repeatType = "field" + fieldid;
	if(fieldname.equalsIgnoreCase("MeetingType")) meetingtype1="field"+fieldid; 
	
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
        resourceNumFieldId = "field" + fieldid;
    }
    if(fieldname.equalsIgnoreCase("MeetingType")){
		meetingtypeEdit = isedit;
	}
    
    if(fieldhtmltype.equals("3") && fieldvalue.equals("0")) fieldvalue = "" ;
    if(fieldhtmltype.equals("1") && (fieldtype.equals("2") || fieldtype.equals("3")) && Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue = "" ;

    if(ismand.equals("1"))  needcheck+=",field"+fieldid;   //如果必须输入,加入必须输入的检查中

    // 下面开始逐行显示字段
	if(fieldname.equalsIgnoreCase("remindImmediately")||fieldname.equalsIgnoreCase("remindHoursBeforeStart")||fieldname.equalsIgnoreCase("remindHoursBeforeEnd")||
			fieldname.equalsIgnoreCase("remindBeforeStart")||fieldname.equalsIgnoreCase("remindBeforeEnd")||fieldname.equalsIgnoreCase("remindTimesBeforeStart")||fieldname.equalsIgnoreCase("remindTimesBeforeEnd"))
	{	
		if("".equals(fieldvalue)) fieldvalue="0";
    	out.println("<input type=hidden name=field"+fieldid+" value='"+fieldvalue+"'>");
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
    if(isview.equals("1")){         // 字段需要显示
%>
    <tr>
      <td class="fieldnameClass" <%if(fieldhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldlable,languageid)%></td>
      <td class="fieldvalueClass" style="TEXT-VALIGN: center">
      <%
        if(fieldhtmltype.equals("1")){                          // 单行文本框
        	
            if(fieldtype.equals("1")){                          // 单行文本框中的文本
                if(isedit.equals("1") && isremark==0 ){
                    if(ismand.equals("1")) {
      %>
        <input datatype="text" type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>" size=50 value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))">
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <%

				    }else{%>
        <input datatype="text" type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" size=50 onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))">
      <span id="field<%=fieldid%>span"></span>
      <%            }
			    }
                else {
      %>
        <span id="field<%=fieldid%>span"><%=Util.toScreen(fieldvalue,user.getLanguage())%></span>
         <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
      <%
                }
		    }
		    else if(fieldtype.equals("2")){                     // 单行文本框中的整型
			    if(isedit.equals("1") && isremark==0 ){
				    if(ismand.equals("1")) {
      %>
        <input datatype="int" type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>"
		onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldid%>')" <%}else{%> onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" <%}%>>
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%

				    }else{%>
        <input datatype="int" type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemCount_KeyPress()"  <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldid%>')" <%}else{%> onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" <%}%>>
      <span id="field<%=fieldid%>span"></span>
       <%           }
			    }
                else {
      %>
        <span id="field<%=fieldid%>span"><%=fieldvalue%></span>
         <input datatype="int" type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
      <%
                }
		    }
		    else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
			    if(isedit.equals("1") && isremark==0 ){
				    if(ismand.equals("1")) {
       %>
        <input datatype="float" type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>"
       onKeyPress="ItemNum_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldid%>')" <%}else{%> onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" <%}%>>
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%
    				}else{%>
        <input datatype="float" type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemNum_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldid%>')" <%}else{%> onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" <%}%>>
      <span id="field<%=fieldid%>span"></span>
       <%           }
			    }
                else {
      %>
        <span id="field<%=fieldid%>span"><%=fieldvalue%></span>
         <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
      <%
                }
		    }
		    /*------------- xwj for td3131 20051116 begin----------*/
    else if(fieldtype.equals("4")){     // 单行文本框中的金额转换%>
            <TABLE cols=2 id="field<%=fieldid%>_tab">
                <tr><td>
                <%if(isedit.equals("1") && isremark==0 ){
                    if(ismand.equals("1")) {%>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>" size=60
                            onfocus="FormatToNumber('<%=fieldid%>')"
                            onKeyPress="ItemNum_KeyPress('field_lable<%=fieldid%>')"
                            <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>
                                onBlur="numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',field<%=fieldid%>.getAttribute('viewtype'));
                                datainput('field_lable<%=fieldid%>')"
                            <%}else{%>
                                onBlur="numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',field<%=fieldid%>.getAttribute('viewtype'))"
                            <%}%>
                        >
                    <span id="field_lable<%=fieldid%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
                    <%}else{%>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>" size=60
                            onKeyPress="ItemNum_KeyPress('field_lable<%=fieldid%>')"
                            onfocus="FormatToNumber('<%=fieldid%>')"
                            <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>
                                onBlur="numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',field<%=fieldid%>.getAttribute('viewtype'));
                                datainput('field_lable<%=fieldid%>')"
                            <%}else{%>
                                onBlur="numberToFormat('<%=fieldid%>');checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',field<%=fieldid%>.getAttribute('viewtype'))"
                            <%}%>
                        >
                    <%}%>
                    <span id="field<%=fieldid%>span"></span>
                    <input datatype="float" type=hidden class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%}else{%>
                    <span id="field<%=fieldid%>span"></span>
                    <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>"  disabled="true" size=60>
                    <input datatype="float" type=hidden class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%}%>
                </td></tr>
                <tr><td>
                    <input type=text class=Inputstyle size=60 name="field_chinglish<%=fieldid%>" readOnly="true">
                </td></tr>
                <script language="javascript">
                    $GetEle("field_lable"+<%=fieldid%>).value  = milfloatFormat(floatFormat(<%=fieldvalue%>));
                    $GetEle("field_chinglish"+<%=fieldid%>).value = numberChangeToChinese(<%=fieldvalue%>);
                </script>
            </table>
	    <%}
		    /*------------- xwj for td3131 20051116 end ----------*/
           if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
		  }                                                       // 单行文本框条件结束
	    else if(fieldhtmltype.equals("2")){                     // 多行文本框
	    /*-----xwj for @td2977 20051111 begin-----*/
	    if(isbill.equals("0")){
			 rscount.executeSql("select * from workflow_formdict where id = " + fieldid);
			 if(rscount.next()){
			 textheight = rscount.getString("textheight");
			 }
			 }
			    /*-----xwj for @td2977 20051111 begin-----*/
		    if(isedit.equals("1") && isremark==0 ){
		    	%>
				<script>$GetEle("htmlfieldids").value += "field<%=fieldid%>;<%=Util.toScreen(fieldlable,languagebodyid)%>;<%=fieldtype%>,";</script>
					<%
			    if(ismand.equals("1")) {
       %>
        <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>"  <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))"
		rows="<%=textheight%>" cols="40" style="width:80%" ><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%
			    }else{
       %>
        <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>" rows="<%=textheight%>" cols="40" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> style="width:80%" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
      <span id="field<%=fieldid%>span"></span>
       <%       }
		    }
            else {
      %>
        <span id="field<%=fieldid%>span"><%=Util.toScreen(fieldvalue,user.getLanguage())%></span>
         <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
      <%
            }
            if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	    }                                                           // 多行文本框条件结束
	    else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl =BrowserComInfo.getLinkurl(fieldtype);   // 浏览值点击的时候链接的url
            String showname = "";                                                   // 值显示的名称
            String showid = "";                                                     // 值
            
             String tablename=""; //浏览框对应的表,比如人力资源表
             String columname=""; //浏览框对应的表名称字段
             String keycolumname="";   //浏览框对应的表值字段

             //add by dongping
             //永乐要求在审批会议的流程中增加会议室报表链接，点击后在新窗口显示会议室报表
             if (fieldtype.equals("118")) {
             	//showname ="<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>查看会议室使用情况</a>" ;
       
             }
             else
             {
            // 如果是多文档, 需要判定是否有新加入的文档,如果有,需要加在原来的后面
            if( fieldtype.equals("37") && fieldid.equals(docfileid) && !newdocid.equals("")) {
                if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                fieldvalue += newdocid ;
            }else if (fieldtype.equals("161")) {//自定义单选
					showname = ""; // 新建时候默认值显示的名称
						String showdesc = "";
						showid = fieldvalue; // 新建时候默认值
						try {
							Browser browser = (Browser) StaticObj
									.getServiceByFullname(fielddbtype,
											Browser.class);
							BrowserBean bb = browser.searchById(requestid+"^~^"+showid);
							String desc = Util.null2String(bb
									.getDescription());
							String name = Util
									.null2String(bb.getName());
                        String href=Util.null2String(bb.getHref());
                        if(href.equals("")){
                        	showname+="<a title='"+desc+"'>"+name+"</a>,";
                        }else{
                        	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>,";
                        }
						} catch (Exception e) {
						}
					} else if (fieldtype.equals("162")) {//自定义多选
						showname = ""; // 新建时候默认值显示的名称
						showid = fieldvalue; // 新建时候默认值
						try {
							Browser browser = (Browser) StaticObj
									.getServiceByFullname(fielddbtype,
											Browser.class);
							List l = Util.TokenizerString(showid, ",");
							for (int j = 0; j < l.size(); j++) {
								String curid = (String) l.get(j);
								BrowserBean bb = browser
										.searchById(requestid+"^~^"+curid);
								String name = Util.null2String(bb
										.getName());
								//System.out.println("showname:"+showname);
								String desc = Util.null2String(bb
										.getDescription());
	                            String href=Util.null2String(bb.getHref());
	                            if(href.equals("")){
	                            	showname+="<a title='"+desc+"'>"+name+"</a>,";
	                            }else{
	                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>,";
	                            }
							}
						} catch (Exception e) {
						}
					}else if(fieldtype.equals("256") ||fieldtype.equals("257")){
						CustomTreeUtil customTreeUtil=new CustomTreeUtil();
						showname = customTreeUtil.getTreeFieldShowName(fieldvalue,fielddbtype);
						try {
		                   showname = showname.replaceAll("</a>&nbsp", "</a>,");  
		                   if (showname.lastIndexOf("</a>,") != -1 && showname.lastIndexOf("</a>,") == showname.length() - 5) {
		                       showname = showname.substring(0, showname.length()-1);
		                   }
		                } catch (Exception e) {
		                    e.printStackTrace();
		                }
			      
               		}



            if(fieldtype.equals("2") ||fieldtype.equals("19")  )	showname=fieldvalue; // 日期时间
            else if(fieldtype.equals("269")){
            	showname = Util.toScreen(MeetingBrowser.getRemindNames(fieldvalue, user.getLanguage()),user.getLanguage()); // 提醒类型
            }else if(!fieldvalue.equals("")) {
                 tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                 columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                 keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段

                //add by wang jinyong
                HashMap temRes = new HashMap();
                if(fieldtype.equals("1") || fieldtype.equals("17") ||fieldtype.equals("160")||fieldtype.equals("165")||fieldtype.equals("166")){
                    //人员，多人员
                    ArrayList tempshowidlist=Util.TokenizerString(fieldvalue,",");
                    for(int k=0;k<tempshowidlist.size();k++){
                       	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                        	{
                      		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>,";
                        	}
                       	else
                           	showname+="<a target='_new' href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>,";
                        
                    }
                }else{
                   	if(!tablename.equals("") && !columname.equals("") && !keycolumname.equals("")){
		                if(fieldtype.equals("135")||fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("160")) {    // 多人力资源,多客户,多会议，多文档
		                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
		                }
		                else {
		                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
		                }
		                 
		                RecordSet.executeSql(sql);
		                while(RecordSet.next()){
		                    showid = Util.null2String(RecordSet.getString(1)) ;
		                    String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
		                    if(!linkurl.equals("")){
		                        if(fieldtype.equals("16")){
		                              int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
		                              tempnum++;
		                              session.setAttribute("resrequestid"+tempnum,""+showid);
		                              session.setAttribute("slinkwfnum",""+tempnum);
		                              temRes.put(String.valueOf(showid),"<a target='_new' href='"+linkurl+showid+"&wflinkno="+tempnum+"'>"+tempshowname+"</a> " );
		                              session.setAttribute("haslinkworkflow","1");
		                          }else{
		                              temRes.put(String.valueOf(showid),"<a target='_new' href='"+linkurl+showid+"'>"+tempshowname+"</a> " );
		                          }
		                    }else{
		                        //showname += tempshowname ;
		                        temRes.put(String.valueOf(showid),tempshowname);
		                    }
		                }
		                StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
		                String temstkvalue = "";
		                while(temstk.hasMoreTokens()){
		                    temstkvalue = temstk.nextToken();
		
		                    if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
		                        showname += temRes.get(temstkvalue)+",";
		                    }
		                }
                	}
                }
            }

			 /*初始化*/
            //String url=BrowserComInfo.getBrowserurl(fieldbodytype);     // 浏览按钮弹出页面的url
		    //String linkurl=BrowserComInfo.getLinkurl(fieldbodytype);    // 浏览值点击的时候链接的url
		    //String showname = "";                                   // 新建时候默认值显示的名称
		    //String showid = "";                                     // 新建时候默认值
			if(fieldtype.equals("89")){//浏览按钮为会议类型，会议类型只选择审批流程是该审批工作流的类型
                url += "?approver="+workflowid;
            }
            if (nodetype.equals("0")&&fieldvalue.equals("")&&false)
			{
            if((fieldtype.equals("1") ||fieldtype.equals("17")) && !(""+creater).equals("")){ //浏览按钮为人,从前面的参数中获得人默认值
                showid = "" + Util.getIntValue(""+creater,0);
            }else if(fieldtype.equals("4") && !(""+creater).equals("")){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(""+creater),0);
            }else if(fieldtype.equals("24") && !(""+creater).equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getJobTitle(""+creater),0);
            }else if(fieldtype.equals("32") && !(""+creater).equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"),0);
            }

            if(fieldtype.equals("2")){
                showname = currentdate;
                showid = currentdate;
            }

            if(showid.equals("0")) showid = "" ;
            
            if(! showid.equals("")){       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                 tablename=BrowserComInfo.getBrowsertablename(fieldtype);
                 columname=BrowserComInfo.getBrowsercolumname(fieldtype);
                 keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
                 sql="";
                if(showid.indexOf(",")==-1){
                    sql="select "+columname+","+keycolumname+" from "+tablename+" where "+keycolumname+"="+showid;
                }else{
                    sql="select "+columname+","+keycolumname+" from "+tablename+" where "+keycolumname+" in("+showid+")";
                }
                RecordSet.executeSql(sql);
                while(RecordSet.next()) {
                    if(!linkurl.equals(""))
                    {
        				if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                    	{
                    		showname += "<a href='javaScript:openhrm(" + RecordSet.getString(2) + ");' onclick='pointerXY(event);'>" + RecordSet.getString(1) + "</a>,";
                    	}
        				else
        					showname += "<a target='_blank' href='"+linkurl+RecordSet.getString(2)+"'>"+RecordSet.getString(1)+"</a>,";
        			}
                    else
                        showname +=RecordSet.getString(1) ;
                }
            }
			fieldvalue=showid;
			}
			/*初始化结束*/

            if(isedit.equals("1") && isremark==0 ){
                if(!fieldtype.equals("37") && !fieldtype.equals("160")) {    //  多文档特殊处理
	   %>
					<%
					String onPropertyChange = "";
					String sqlwhere123="";
					String hasInput="true";
					String linkUrl="" ;
					if(fieldtype.equals("89")){
						bclick = "onShowMeetingBrowser('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'))";
						onPropertyChange = "afterChangeMeetingType("+fieldid+");";
						sqlwhere123=""+workflowid;
					} else if(fieldname.equalsIgnoreCase("Caller")){
						bclick ="onShowCaller('"+fieldid+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'))";
						hasInput="false";
					}else {
						if(trrigerfield.indexOf("field"+fieldid)>=0){
							if(fieldtype.equals("161")||fieldtype.equals("162")){
								 url+="?type="+fielddbtype;
							}else if(fieldtype.equals("256")||fieldtype.equals("257")){
								url+="?type="+fielddbtype+"_"+fieldtype;	
							}
							bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'));datainput('field"+fieldid+"');";
						}else{
							if(fieldtype.equals("87")||fieldtype.equals("184")){
								linkUrl="/meeting/Maint/MeetingRoom_list.jsp?id=";
							}
							if(fieldtype.equals("2")){
								bclick ="onShowFlowDate('"+fieldid+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'))";
							} else if(fieldtype.equals("19")){
								bclick ="onShowMeetingTime(field"+fieldid+"span,field"+fieldid+",field"+fieldid+".getAttribute('viewtype'))";
							}else {
								if(fieldtype.equals("161")||fieldtype.equals("162")){
									 url+="?type="+fielddbtype;
								}else if(fieldtype.equals("256")||fieldtype.equals("257")){
									url+="?type="+fielddbtype+"_"+fieldtype;	
								}
								bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'));";
								if("17".equals(fieldtype) || "18".equals(fieldtype)) { 
									onPropertyChange = "countAttend();";
								}
								if("269".equals(fieldtype)){
									onPropertyChange = "showRemindTime()"; 
								}
							}
						}
					}
				%>
		<%
		if(fieldtype.equals("2")){%>
		<button type="button"  class="calendar"" onClick="onShowFlowDate('<%=fieldid%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))"></button>
		<%} else if(fieldtype.equals("19")){%>
		<button type="button"  class="calendar" onClick="onWorkFlowShowTime(field<%=fieldid%>span,field<%=fieldid%>,field<%=fieldid%>.getAttribute('viewtype'))"></button>
		<%} else {
			String cpurl = "javascript:getajaxurl(" + fieldtype + ",'','"+sqlwhere123+"')";
		%>
		<brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput='<%=hasInput %>' isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%=cpurl%>' width="230px" needHidden="false" onPropertyChange='<%=onPropertyChange %>' linkUrl='<%=linkUrl %>'> </brow:browser>
		
       <% }
       }else if(fieldtype.equals("160")){
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
			  }else {                         // 如果是多文档字段,加入新建文档按钮
       %>
        <button type=button  class=AddDoc onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp;<button type=button  class=AddDoc onclick="onNewDoc(<%=fieldid%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
       <%       }
                
                
         if(fieldtype.equals("2") || fieldtype.equals("19")){%>
                <span id="field<%=fieldid%>span"><%=showname%>
               <%
                    if( ismand.equals("1") && fieldvalue.equals("")){
               %>
                <img src="/images/BacoError_wev8.gif" align=absmiddle>
               <%
                    }
               %>
                </span> 
        <%} 
                
                
            } else {
            	out.print(showname.replace(",","&nbsp;&nbsp;"));
			}
       %>
	  
		<input type=hidden viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" id="field<%=fieldid%>" name="field<%=fieldid%>" value="<%=fieldvalue%>">
       <% }
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
			String remindTypeStatus = "";
	       	if(isedit.equals("0") || isremark==1 )
	       	{
	       		remindTypeStatus = "disabled";
	       	}
	       %>
				</TD>
		   </TR>
		   <TR name="remindTimetr1" <% if("".equals(fieldvalue)) {%> style="display:none" <% } %> class="Spacing" style="height:1px;">
			<TD class="Line2" colSpan="2"></TD>
			</TR>
			<TR name="remindTimetr1" <% if("".equals(fieldvalue)) {%> style="display:none" <% } %>>
				<TD class="fieldnameClass" ><%=SystemEnv.getHtmlLabelName(81917,user.getLanguage())%></TD>
				<TD class="fieldvalueClass">
					<INPUT id='remindImmediately' <%=remindTypeStatus %> type="checkbox" name="remindImmediately" value=<%=remindImmediatelyV %> <% if("1".equals(remindImmediatelyV)) { %>checked<% } %>>
			</TD>
	       <TR style="height:1px;" name="remindTimetr" <% if("".equals(fieldvalue)) {%> style="display:none" <% } %>  style="height:1px;">
				<TD class="Line2" colSpan="2"></TD>
		   </TR>
	       <TR name="remindTimetr" <% if("".equals(fieldvalue)) {%> style="display:none" <% } %>>
				<TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(785,user.getLanguage())%></TD>
				<TD class="fieldvalueClass">
					<INPUT id='remindBeforeStart' <%=remindTypeStatus %> type="checkbox" name="remindBeforeStart" value=<%=remindBeforeStartV %> <% if("1".equals(remindBeforeStartV)) { %>checked<% } %>>
						<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
						<INPUT id='remindHoursBeforeStart' <%=remindTypeStatus %> class="InputStyle" type="input" name="remindHoursBeforeEnd" onchange="checkint('remindDateBeforeStart')" size=5 value="<%= temmhour %> ">
						<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
						<INPUT id='remindTimesBeforeStart' <%=remindTypeStatus %> class="InputStyle" type="input" name="remindTimesBeforeStart" onchange="checkint('remindTimesBeforeStart')" size=5 value="<%= temptinme %>">
						<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
					<br>
					<INPUT id='remindBeforeEnd' <%=remindTypeStatus %> type="checkbox" name="remindBeforeEnd" value=<%=remindBeforeEndV %> <% if("1".equals(remindBeforeEndV)) { %>checked<% } %>>

						<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
						<INPUT id='remindHoursBeforeEnd' <%=remindTypeStatus %> class="InputStyle" type="input" name="remindHoursBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size=5 value="<%= temmhourend%>">
						<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
						<INPUT id='remindTimesBeforeEnd' <%=remindTypeStatus %> class="InputStyle" type="input" name="remindTimeBeforeEnd"  onchange="checkint('remindTimesBeforeEnd')" size=5 value="<%= temptinmeend %>">
						<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
		<%
		}
	
	
	    }                                                    // 浏览按钮条件结束
	    else if(fieldhtmltype.equals("4")) {                    // check框
	   %>
        <input type=checkbox viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" value=1 name="field<%=fieldid%>" <%if(isedit.equals("0") || isremark==1 ){%> DISABLED <%}%> <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onChange="datainput('field<%=fieldid%>');" <%}%> <%if(fieldvalue.equals("1")){%> checked <%}%> >
        <%if(isedit.equals("0") || isremark==1 ){%>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
        <%}%>
       <%
            if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
        }                                                       // check框条件结束
        else if(fieldhtmltype.equals("5")){                     // 选择框   select
        	String otherEvent= "";
        	if("remindType".equals(fieldname))
    	    {
        		otherEvent = "showRemindTime(this);";
    	    }
			
			if("repeatType".equals(fieldname)){
				otherEvent = "changeRepeatType(this);";
			}

    	    //yl 67452   start
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



	   %>
        <select class=inputstyle viewtype="<%=ismand%>"        <%=onchangeAddStr%>      temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>" <%if(ismand.equals("1")){%>onBlur="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));"<%}%> <%if(isedit.equals("0") || isremark==1 ){%> DISABLED <%}%> <%if(trrigerfield.indexOf("field"+fieldid)>=0&&selfieldsadd.indexOf(fieldid)>=0){%> onChange="<%=otherEvent %>datainput('field<%=fieldid%>');changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}else if(selfieldsadd.indexOf(fieldid)>=0){ %> onChange="<%=otherEvent %>changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}else{%> onChange="<%=otherEvent %>" <%}%>><!--added by xwj for td3313 20051206 -->
	    <option value=""></option><!--added by xwj for td3297 20051130 -->
	   <%
            // 查询选择框的所有可以选择的值
            rs.executeProc("workflow_selectitembyid_new",""+fieldid+flag+isbill);
             boolean checkempty = true;//xwj for td3313 20051206
			      String finalvalue = "";//xwj for td3313 20051206


           if(hasPfield == false){
            while(rs.next()){
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
                 /* -------- xwj for td3313 20051206 begin -*/
                 if(tmpselectvalue.equals(fieldvalue)){
				          checkempty = false;
				          finalvalue = tmpselectvalue;
				         }
				         /* -------- xwj for td3313 20051206 end -*/
	   %>
	    <option value="<%=tmpselectvalue%>" <%if(fieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
	   <%
            }
           }else{
           while(rs.next()){
               String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
               String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
               if(tmpselectvalue.equals(fieldvalue)){
                   checkempty = false;
                   finalvalue = tmpselectvalue;
               }
       %>
            <option value="<%=tmpselectvalue%>" <%if(fieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
            <%
                    }
                    selectInitJsStr += "doInitChildSelect("+fieldid+","+firstPfieldid_tmp+",\""+finalvalue+"\");\n";
                    initIframeStr += "<iframe id=\"iframe_"+firstPfieldid_tmp+"_"+fieldid+"_00\" frameborder=0 scrolling=no src=\"\"  style=\"display:none\"></iframe>";
                }

                //yl 67452   end
       %>
	    </select>

	    <!--xwj for td3313 20051206 begin-->
	    <span id="field<%=fieldid%>span">
	    <%
	     if(ismand.equals("1") && checkempty){
	    %>
       <IMG src='/images/BacoError_wev8.gif' align=absMiddle>
      <%
            }
       %>
	     </span>
	    <!--xwj for td3313 20051206 end-->

        <%if(isedit.equals("0") || isremark==1 ){%>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=finalvalue%>" >
        <%}%>
       <%
            if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	   
		if("repeatType".equalsIgnoreCase(fieldname))
	    {
			String remindTypeStatus = "";
			if(isedit.equals("0") || isremark==1 )
			{
				remindTypeStatus = "disabled";
			}
    	%>
    	</TD>
		</TR>
    	<TR id="repeattr" <% if(!"1".equals(fieldvalue) && !"2".equals(fieldvalue) && !"3".equals(fieldvalue)) {%> style="display:none" <% } %>  class="Spacing" style="height:1px;">
			<TD class="Line2" colSpan="6"></TD>
		</TR>
		<TR id="dayrepeat" <% if(!"1".equals(fieldvalue) ) {%> style="display:none" <% } %>>
		  <TD class="fieldnameClass"> 
			<!--重复间隔 -->
			<%=SystemEnv.getHtmlLabelName(25898,user.getLanguage())%>
		  </TD>
		  <TD class="fieldvalueClass"> 
			<input class=inputstyle type=text name="repeatdays" id="repeatdays" size=5  value="<%=repeatdaysVl%>" onBlur="checkcount1(this);checkinput('repeatdays','repeatdaysSpan')" <%=remindTypeStatus %> />
			<span name="repeatdaysSpan" id="repeatdaysSpan"></span>&nbsp;<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
		  </TD>
		</TR>

		<TR id="weekrepeat" <% if(!"2".equals(fieldvalue) ) {%> style="display:none" <% } %>>
		  <TD class="fieldnameClass"> 
			<!--重复间隔 -->
			<%=SystemEnv.getHtmlLabelName(25898,user.getLanguage())%>
		  </TD>
		  <TD class="fieldvalueClass"> 
			<%=SystemEnv.getHtmlLabelName(21977,user.getLanguage())%>&nbsp;
			<input class=inputstyle type=text name="repeatweeks" id="repeatweeks" size=5  value="<%=repeatweeksVl%>" onBlur="checkcount1(this);checkinput('repeatweeks','repeatweeksSpan')" />
			<span name="repeatweeksSpan" id="repeatweeksSpan"></span>&nbsp;<%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%><br>
			<% rptWeekDaysVl = ","+rptWeekDaysVl+",";%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="1" <%if(rptWeekDaysVl.indexOf(",1,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16100,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="2" <%if(rptWeekDaysVl.indexOf(",2,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16101,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="3" <%if(rptWeekDaysVl.indexOf(",3,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16102,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="4" <%if(rptWeekDaysVl.indexOf(",4,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16103,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="5" <%if(rptWeekDaysVl.indexOf(",5,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16104,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="6" <%if(rptWeekDaysVl.indexOf(",6,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16105,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="7" <%if(rptWeekDaysVl.indexOf(",7,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16106,user.getLanguage())%>
			
		  </TD>
		</TR>
		

		<TR id="monthrepeat"  <% if(!"3".equals(fieldvalue) ) {%> style="display:none" <% } %>>
		  <TD class="fieldnameClass"> 
			<!--重复间隔 -->
			<%=SystemEnv.getHtmlLabelName(25898,user.getLanguage())%>
		  </TD>
		  <TD class="fieldvalueClass"> 
		    <%=SystemEnv.getHtmlLabelName(21977,user.getLanguage())%>&nbsp;
			<input class=inputstyle type=text name="repeatmonths" id="repeatmonths" size=5  value="<%=repeatmonthsVl%>" onBlur="checkcount1(this);checkinput('repeatmonths','repeatmonthsSpan')" <%=remindTypeStatus %> />
			<span name="repeatmonthsSpan" id="repeatmonthsSpan"></span>&nbsp;<%=SystemEnv.getHtmlLabelName(25901,user.getLanguage())%>&nbsp;
			<input class=inputstyle type=text name="repeatmonthdays" id="repeatmonthdays" size=5  value="<%=repeatmonthdaysVl%>" onBlur="checkcount1(this);checkinput('repeatmonthdays','repeatmonthdaysSpan')" <%=remindTypeStatus %> />
			<span name="repeatmonthdaysSpan" id="repeatmonthdaysSpan"></span>&nbsp;<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
		  
    	<%
    	}
        //add by xhheng @20050310 for 附件上传
        }else if(fieldhtmltype.equals("6")){
        %>
          <%if( isedit.equals("1")){
          int linknumnew=-1;
          %>
          <!--modify by xhheng @20050511 for 1803-->
          <TABLE cols=3 id="field<%=fieldid%>_tab">
            <TBODY >
            <COL width="50%" >
            <COL width="25%" >
            <COL width="25%">
          <%
          if(!fieldvalue.equals("")) {
            sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
            RecordSet.executeSql(sql);
            int linknum=-1;
            int imgnum=fieldimgnum;
              boolean isfrist=false;
            while(RecordSet.next()){
                isfrist=false;
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSet.getInt(3);

              DocImageManager.resetParameter();
              DocImageManager.setDocid(Integer.parseInt(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(DocImageManager.next()){
                //DocImageManager会得到doc第一个附件的最新版本
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }

              String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              if(fieldtype.equals("2")){
              if(linknum==0){
              isfrist=true;
              %>
            <tr>
                <td colSpan=3>
                    <table cellspacing="0" cellpadding="0">
                        <tr>
              <%}
                  if(imgnum>0&&linknum>=imgnum){
                      imgnum+=fieldimgnum;
                      isfrist=true;
              %>
              </tr>
              <tr>
              <%
                  }
              %>
                  <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0">
                  <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
                  <td <%if(!isfrist){%>style="padding-left:15"<%}%>>
                     <table>
                      <tr>
                          <td colspan="2" align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&requestid=<%=requestid%>" style="cursor:hand" alt="<%=docImagefilename%>" <%if(fieldimgwidth>0){%>width="<%=fieldimgwidth%>"<%}%> <%if(fieldimgheight>0){%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=ismand%>",oUpload<%=fieldid%>);return false;'>[<span style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>]</a>
                                    <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden"><b><font COLOR="#FF0033">√</font></b><span></td>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>');return false;">[<span style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></span>]</a>
                              </td>
                      </tr>
                        </table>
                    </td>
              <%}else{%>
			<tr onmouseover="changecancleon(this)" onmouseout="changecancleout(this)" style="border-bottom:1px solid #e6e6e6;height: 40px;">
            <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0" >
            <td class="fieldvalueClass" valign="middle" colSpan=3 style="word-break:normal;word-wrap:normal;">
             <div style="float:left;height:40px; line-height:40px;width:320px;" class="fieldClassChange">
              <div style="float:left;width:20px;height:40px; line-height:40px;">
              <span style="display:inline-block;vertical-align: middle;padding-top:6px;">
              <%=imgSrc%>
				</span>
              </div>
              <div style="float:left;padding-left:5px;">
              <span style="display:inline-block;width:285px;height:30px;padding-bottom:10px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;vertical-align: middle;">
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a  style="cursor:pointer;color:#8b8b8b!important;" onmouseover="changefileaon(this)" onmouseout="changefileaout(this)" onclick="addDocReadTag('<%=showid%>');openDocExt('<%=showid%>','<%=versionId%>','<%=docImagefileid%>',1)" title="<%=docImagefilename%>"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:pointer;color:#8b8b8b!important;" onmouseover="changefileaon(this)" onmouseout="changefileaout(this)" onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')" title="<%=docImagefilename%>"><%=docImagefilename%></a>&nbsp

              <%}%>
              </span>
              </div>
              </div>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
            
             <%
            	if (accessoryCount == 1) {
            %>
              <div style="float:left;height:40px; line-height:40px;width:70px;padding-left:10px;" class="fieldClassChange">
              <span id = "selectDownload">
              	<nobr>
                  <span style="width:45px;display:inline-block;color:#898989;margin-top:1px;"><%=docImagefileSize / 1000%>K</span>
				  <a style="display:inline-block;cursor:pointer;vertical-align:middle;width:20px;height:20px;margin-bottom:5px;background-image:url('/images/ecology8/workflow/fileupload/upload_wev8.png');" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')" title="<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage())%>"></a>
                </nobr>
              </span>
              </div>
            <%
            	}
            %>
            	<div class="fieldClassChange" id="fieldCancleChange" style="float:left;width:50px;height:40px; line-height: 40px;text-align:center;">
	                <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="display:none;">
	                	<a style="display:inline-block;cursor:pointer;vertical-align:middle;width:20px;height:20px;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png');background-repeat :no-repeat;" type=button onclick='onChangeSharetypeNew(this,"span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=showid%>","<%=docImagefilename%>","<%=ismand%>",oUpload<%=fieldid%>)' title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></a>
	                </span>
                </div>
            
            
          </tr>
         
              <%}}
            linknumnew = linknum;
            if(fieldtype.equals("2")&&linknum>-1){%>
            </tr></table></td></tr>
            <%}%>
            <input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum+1%>>
            <input type=hidden name="field<%=fieldid%>_idnum_1" value=<%=linknum+1%>>
          <%}%>
          <tr>
            <td >
             <%
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
          boolean canupload=true;
          if("".equals(mainId) && "".equals(subId) && "".equals(secId)){
                    canupload=false;
            %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}else{
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
                uploadspan : "field_<%=fieldid%>span",
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
              <td colspan="2" style="background-color:#ffffff;">
                  <div>
                   <span id="uploadspan" style="display:inline-block;line-height: 32px;"><%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>
                    </span>
                    <%
					if(ismand.equals("1")){
					%>
					<span id="field_<%=fieldid%>span" style='display:inline-block;line-height: 32px;color:red;font-weight:normal;'><%=!fieldvalue.equals("")?"":SystemEnv.getHtmlLabelName(81909,user.getLanguage())%></span>
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
			    <%if(linknumnew>0){ %>
		         <button type="button" id="field_upload_<%=fieldid%>" onclick="downloadsBatch('<%=fieldvalue%>','<%=requestid%>')" style="display:inline-block;height:25px;cursor:pointer;text-align:center;vertical-align:middle;line-height:25px;background-color: #6bcc44;color:#ffffff;padding:0 10px 0 4px;" onmouseover="uploadbuttonon(this)" onmouseout="uploadbuttonout(this)"><img src='/images/ecology8/workflow/fileupload/uploadall_wev8.png' style="width:20px;height:20px;padding-bottom:2px;" align=absMiddle><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%></button>
		         <%} %>
		         
                  </div>
	              <div style="clear:both;"></div>
	              </div>
                  <input  class=InputStyle  type=hidden size=60 id="field<%=fieldid%>" name="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>"  viewtype="<%=ismand%>" value="<%=fieldvalue%>">
              </td>
          </tr>
          <tr>
              <td colspan="2" style="background-color:#ffffff;">
              	<div class="_uploadForClass">	
                  <div class="fieldset flash" id="fsUploadProgress<%=fieldid%>">
                  </div>
                </div>
                  <div id="divStatus<%=fieldid%>"></div>
              </td>
          </tr>
      </TABLE>


            <%}%>



                <!--yl qc:67452 start-->
                <%=initIframeStr%>
                <!--yl qc:67452   end-->
          <input type=hidden name='mainId' value=<%=mainId%>>
          <input type=hidden name='subId' value=<%=subId%>>
          <input type=hidden name='secId' value=<%=secId%>>
          </td>
          </tr>
      </TABLE>
          <%}else{
          if(!fieldvalue.equals("")) {
        	  int linknumnew1= -1;
            %>
          <TABLE cols=3 id="field<%=fieldid%>_tab">
            <TBODY >
            <COL width="50%" >
            <COL width="25%" >
            <COL width="25%">
            <%
            sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
            int linknum=-1;
            RecordSet.executeSql(sql);
            while(RecordSet.next()){
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSet.getInt(3);

              DocImageManager.resetParameter();
              DocImageManager.setDocid(Integer.parseInt(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(DocImageManager.next()){
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }
              String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              %>
              <tr style="border-bottom:1px solid #e6e6e6;height: 40px;">
                <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0">
                <td class="fieldvalueClass" colspan=3 valign="middle" style="word-break:normal;word-wrap:normal;">
                <div style="float:left;height:40px; line-height:40px;width:320px;" class="fieldClassChange">
              <div style="float:left;width:20px;height:40px; line-height:40px;">
              <span style="display:inline-block;vertical-align: middle;padding-top:6px;">
              <%=imgSrc%>
              </span>
              </div>
              <div style="float:left;padding-left:5px;">
              <span style="display:inline-block;width:285px;height:30px;padding-bottom:10px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;vertical-align: middle;">
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:pointer;color:#8b8b8b!important;" onmouseover="changefileaon(this)" onmouseout="changefileaout(this)" onclick="addDocReadTag('<%=showid%>');openDocExt('<%=showid%>','<%=versionId%>','<%=docImagefileid%>',0)" title="<%=docImagefilename%>"><%=docImagefilename%></a>&nbsp;

              <%}else{%>
                <a style="cursor:pointer;color:#8b8b8b!important;" onmouseover="changefileaon(this)" onmouseout="changefileaout(this)" onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')" title="<%=docImagefilename%>"><%=docImagefilename%></a>&nbsp;
              <%}%>
              </span>
              </div>
              </div>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>> <!--xwj for td2893 20051017-->
               <div style="float:left;height:40px; line-height:40px;width:70px;padding-left:10px;padding-right:10px;" class="fieldClassChange">
               <span id = "selectDownload">
                 <span style="width:45px;display:inline-block;color:#898989;margin-top:1px;"><%=docImagefileSize / 1000%>K</span>
			  <a style="display:inline-block;cursor:pointer;vertical-align:middle;width:20px;height:20px;margin-bottom:5px;background-image:url('/images/ecology8/workflow/fileupload/upload_wev8.png');" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')" title="<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage())%>"></a>
               </span>
               </div>
              </td>
          </tr>
          
              <%}
            	linknumnew1 = linknum;
                if(linknumnew1>0){
                 %>
              <tr>
            	<td class="fieldvalueClass" valign="middle" colSpan=3> 
                 <span onclick="downloadsBatch('<%=fieldvalue%>','<%=requestid%>')" style="display:inline-block;height:25px;cursor:pointer;text-align:center;vertical-align:middle;line-height:25px;background-color: #6bcc44;color:#ffffff;padding:0 20px 0 14px;" onmouseover="uploadbuttonon(this)" onmouseout="uploadbuttonout(this)"><img src='/images/ecology8/workflow/fileupload/uploadall_wev8.png' style="width:20px;height:20px;padding-bottom:2px;" align=absMiddle><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%></span>
	         	</td>
              </tr>
              <%}%>
              <input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum+1%>><!--xwj for td2893 20051017-->
              <input type=hidden name="field<%=fieldid%>" value=<%=fieldvalue%>>
              </tbody>
              </table>
              <%
            }
          }
        }     // 选择框条件结束 所有条件判定结束
       else if(fieldhtmltype.equals("7")){//特殊字段
 			out.println(Util.null2String((String)specialfield.get(fieldid+"_1")));
       }
       %>
      </td>
    </tr><TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>

<%
    }else {                              // 不显示的作为 hidden 保存信息
%>
    <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
<%
    }%>

	<%
}       // 循环结束
%>

</table>
<div id="otherdata" style="display:none;">
	<% 	
	//生成召集人的where子句
	String whereclause="";
	int ishead=0 ;
	int isset=0;//是否有设置召集人标识，0没有，1有
	if(!meetingtype.equals("")) {
		RecordSet.executeProc("MeetingCaller_SByMeeting",meetingtype) ;
		
		while(RecordSet.next()){
		    String callertype=RecordSet.getString("callertype") ;
		    int seclevel=Util.getIntValue(RecordSet.getString("seclevel"), 0) ;
		    String rolelevel=RecordSet.getString("rolelevel") ;
		    String thisuserid=RecordSet.getString("userid") ;
		    String departmentid=RecordSet.getString("departmentid") ;
		    String roleid=RecordSet.getString("roleid") ;
		    String foralluser=RecordSet.getString("foralluser") ;
		    String subcompanyid=RecordSet.getString("subcompanyid") ;
		    int seclevelMax=Util.getIntValue(RecordSet.getString("seclevelMax"), 0) ;
		    isset=1;
		
		    if(callertype.equals("1")){
		        if(ishead==0)
		            whereclause+=" t1.id="+thisuserid ;
		        if(ishead==1)
		            whereclause+=" or t1.id="+thisuserid ;
		    }
		    if(callertype.equals("2")){
		        if(ishead==0)
		            whereclause+=" t1.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" and seclevelMax <= "+seclevelMax+" )" ;
		        if(ishead==1)
		            whereclause+=" or t1.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" and seclevelMax <= "+seclevelMax+" )" ;
		    }
		    if(callertype.equals("3")){
				if(ishead==0){
					whereclause+=" t1.id in (select resourceid from hrmrolemembers join hrmresource on  hrmrolemembers.resourceid=hrmresource.id where roleid="+roleid+" and rolelevel >="+rolelevel+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+")" ;
				}
				if(ishead==1){
					whereclause+=" or t1.id in (select resourceid from hrmrolemembers join hrmresource on  hrmrolemembers.resourceid=hrmresource.id where roleid="+roleid+" and rolelevel >="+rolelevel+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+")" ;
				}
			}
		    if(callertype.equals("4")){
		        if(ishead==0)
		            whereclause+=" t1.id in (select id from hrmresource where seclevel >="+seclevel+" and seclevelMax <= "+seclevelMax+" )" ;
		        if(ishead==1)
		            whereclause+=" or t1.id in (select id from hrmresource where seclevel >="+seclevel+" and seclevelMax <= "+seclevelMax+" )" ;
		    }
		    if(callertype.equals("5")){
		        if(ishead==0)
		            whereclause+=" t1.id in (select id from hrmresource where subcompanyid1="+subcompanyid+" and seclevel >="+seclevel+" and seclevelMax <= "+seclevelMax+" )" ;
		        if(ishead==1)
		            whereclause+=" or t1.id in (select id from hrmresource where subcompanyid1="+subcompanyid+" and seclevel >="+seclevel+" and seclevelMax <= "+seclevelMax+" )" ;
		    }
		    if(ishead==0)   ishead=1;
		}
	}
	if(!whereclause.equals("")) {
		whereclause="where ( " +  whereclause ;
		whereclause+=" )" ;
		%>
		<input type=hidden class="whereclauses" value='<%=whereclause %>'>
		<%
	}

	%>
</div>
<!--#######明细表 Start#######-->
<jsp:include page="WorkflowManageRequestDetailBodyBill.jsp" flush="true">
		<jsp:param name="workflowid" value="<%=workflowid%>" />
		<jsp:param name="nodeid" value="<%=nodeid%>" />
		<jsp:param name="formid" value="<%=formid%>" />
        <jsp:param name="detailsum" value="<%=0%>"/>
        <jsp:param name="isbill" value="<%=isbill%>"/>
        <jsp:param name="currentdate" value="<%=currentdate%>" />
		<jsp:param name="currenttime" value="<%=currenttime%>" />
        <jsp:param name="needcheck" value="<%=needcheck%>" />
		<jsp:param name="fieldUrl" value='<%="" %>' />
  </jsp:include>
  
<%//@ include file="/workflow/request/WorkflowManageRequestDetailBody.jsp" %>
<!--#######明细表 END#########-->
<input type=hidden name="requestid" value=<%=requestid%>>           <!--请求id-->
<input type=hidden name="workflowid" value="<%=workflowid%>">       <!--工作流id-->
<input type=hidden name="workflowtype" value="<%=workflowtype%>">       <!--工作流类型-->
<input type=hidden name="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" value="<%=nodetype%>">                     <!--当前节点类型-->
<input type=hidden name="src">                                <!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" value="0">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name="billid" value="<%=billid%>">             <!--单据id-->
<input type=hidden name=isremark>
<input type=hidden name ="method">                                <!--新建文档时候 method 为docnew-->
<input type=hidden name ="topage" value="<%=topage%>">				<!--返回的页面-->
<input type=hidden name ="needcheck" value="<%=needcheck+needcheck10404%>">
<input type=hidden name ="inputcheck" value="">

<script language="javascript">

function onNewDoc(fieldid) {
    frmmain.action = "RequestOperation.jsp" ;
    frmmain.method.value = "docnew_"+fieldid ;
    $GetEle("frmmain").src.value='save';
    setRemindData();
	setRepeatdata();
    //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
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

//会议室冲突check
var checkroom = 0;
 

//会议人员冲突check
function submitChkMbr(obj){
	 if(<%=meetingSetInfo.getMemberConflictChk()%> == 1 ){
		var hrmids02 = $GetEle("<%=hrmids02%>") ? $GetEle("<%=hrmids02%>").value:"";
		var crmids02 = $GetEle("<%=crmids02%>") ? $GetEle("<%=crmids02%>").value:"";
  		jQuery.post("/meeting/data/AjaxMeetingOperation.jsp?method=chkMember",{hrmids:hrmids02,crmids:crmids02,begindate:$GetEle("frmmain").<%=newfromdate%>.value,begintime:$GetEle("frmmain").<%=newfromtime%>.value,enddate:$GetEle("frmmain").<%=newenddate%>.value,endtime:$GetEle("frmmain").<%=newendtime%>.value,meetingid:'<%=MeetingID%>',requestid:'<%=requestid%>'},function(datas){
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
	$GetEle("frmmain").src.value='submit';
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231   
						  
//增加提示信息  开始 meiYQ 2007.10.19 start
	var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
	showPrompt(content);
//增加提示信息  结束 meiYQ 2007.10.19 end
	setRemindData();
	setRepeatdata();
	//附件上传
	StartUploadAll();
	checkuploadcomplet();
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
          ArrayList Linfieldname=ddi.GetInFieldName();
          ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          StrData+="&<%=temp%>="+$GetEle("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          StrData+="&<%=temp%>="+$GetEle("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
      %>
      //alert(StrData);
      $GetEle("datainputform").src="DataInputFrom.jsp?"+StrData;
      //xmlhttp.open("POST", "DataInputFrom.jsp", false);
      //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      //xmlhttp.send(StrData);
  }
  function addannexRow(accname)
  {
    $GetEle(accname+'_num').value=parseInt($GetEle(accname+'_num').value)+1;
    ncol = $GetEle(accname+'_tab').cols;
    oRow = $GetEle(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1);

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");
          <%----- Modified by xwj for td3323 20051209  ------%>
          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+$GetEle(accname+'_num').value+"' onchange='accesoryChanage(this)'> (此目录下最大只能上传<%=maxUploadImageSize%>M/个的附件) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
        case 1:
          var oDiv = document.createElement("div");
          var sHtml = "&nbsp;";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
        case 2:
          var oDiv = document.createElement("div");
          var sHtml = "&nbsp;";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }


</script>


<%
boolean isOldWf_ = false;
RecordSetOld.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSetOld.next()){
	if(RecordSetOld.getString("nodeid") == null || "".equals(RecordSetOld.getString("nodeid")) || "-1".equals(RecordSetOld.getString("nodeid"))){
			isOldWf_ = true;
	}
}

%>
<%@ include file="WorkflowManageSign.jsp" %>



<script language="javascript">
	
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
	
function showRemindTime()
{
	var repeatType=$GetEle("<%=repeatType%>").value;
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
	
    function displaydiv_1()
	{
		if(WorkFlowDiv.style.display == ""){
			WorkFlowDiv.style.display = "none";
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1() target=_self>全部</a>";
		}
		else{
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1() target=_self>部分</a>";
			WorkFlowDiv.style.display = "";
		}
	}

    function doRemark(){        <!-- 点击被转发的提交按钮 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoRemark").click();
        }catch(e){
            $GetEle("frmmain").isremark.value='1';
            $GetEle("frmmain").src.value='save';
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231   
                                      
            //增加提示信息  开始 meiYQ 2007.10.19 start
		       	var content="<%=SystemEnv.getHtmlLabelName(18981,user.getLanguage())%>";
		       	showPrompt(content);
            //增加提示信息  结束 meiYQ 2007.10.19 end
            setRemindData();
			setRepeatdata();
            //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
	}

    function doRemark_n(obj){        <!-- 点击被转发的提交按钮 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoRemark").click();
        }catch(e){
            $GetEle("frmmain").isremark.value='1';
            $GetEle("frmmain").src.value='save';
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

            //增加提示信息  开始 meiYQ 2007.10.19 start
		       	var content="<%=SystemEnv.getHtmlLabelName(18981,user.getLanguage())%>";
		       	showPrompt(content);
            //增加提示信息  结束 meiYQ 2007.10.19 end
            try{obj.disabled=true;}catch(e1){}
            setRemindData();
			setRepeatdata();
            //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
	}

    function doSave(){          <!-- 点击保存按钮 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        }catch(e){
            var ischeckok="";
            try{
             if(check_form($GetEle("frmmain"),$GetEle("needcheck").value+$GetEle("inputcheck").value))
              ischeckok="true";
            }catch(e){
              ischeckok="false";
            }
            if(ischeckok=="false"){
                if(check_form($GetEle("frmmain"),'<%=needcheck%>'))
                    ischeckok="true";
            }
            if(ischeckok=="true"){
                if(checktimeok()) {
                        $GetEle("frmmain").src.value='save';
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
                                                              
            //增加提示信息  开始 meiYQ 2007.10.19 start
		       	var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
		       	showPrompt(content);
            //增加提示信息  结束 meiYQ 2007.10.19 end
            			setRemindData();
						setRepeatdata();
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                    }
             }
        }
	}
    function doSave_n(obj){          <!-- 点击保存按钮 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        }catch(e){
            var ischeckok="";
            try{
             if(check_form($GetEle("frmmain"),$GetEle("needcheck").value+$GetEle("inputcheck").value))
              ischeckok="true";
            }catch(e){
              ischeckok="false";
            }
            if(ischeckok=="false"){
                if(check_form($GetEle("frmmain"),'<%=needcheck%>'))
                    ischeckok="true";
            }
            if(ischeckok=="true"){
                if(checktimeok()) {
                        $GetEle("frmmain").src.value='save';
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
                                                                                      
            //增加提示信息  开始 meiYQ 2007.10.19 start
		       	var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
		       	showPrompt(content);
            //增加提示信息  结束 meiYQ 2007.10.19 end
            			setRemindData();
						setRepeatdata();
                        try{obj.disabled=true;}catch(e1){}
                    //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                    }
             }
        }
	}

    function doRemark_n(obj){   <!-- 点击被转发的提交按钮 -->
		var ischeckok="";
        try{
        if(check_form($GetEle("frmmain"),$GetEle("needcheck").value+$GetEle("inputcheck").value))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
          if(check_form($GetEle("frmmain"),'<%=needcheck%>'))
            ischeckok="true";
        }
	    if (ischeckok=="false" || ischeckok=="") {
	    	return;
	    }
		
		if ("<%=needconfirm%>"=="1")
		{
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(19990,user.getLanguage())%>", function (){
				try
				{
					//为了对《工作安排》流程作特殊的处理，请参考MR1010
					$GetEle("planDoRemark").click();
				}
				catch(e)
				{                
					if(checktimeok()) 
					{
						$GetEle("frmmain").isremark.value='1';
						$GetEle("frmmain").src.value='save';
						
						
						jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

					//TD4262 增加提示信息  开始
					<%
						if(ismode.equals("1"))
						{
					%>
						
						contentBox = $GetEle("divFavContent18978");
						showObjectPopup(contentBox)
					<%
						
						}
						else
						{
					%>
					   
							var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
							showPrompt(content);
							
					<%
						}
					%>
						//TD4262 增加提示信息  结束
						setRemindData();
						setRepeatdata();
						 try{obj.disabled=true;}catch(e1){}
						//附件上传
								StartUploadAll();
								checkuploadcomplet();
					}
				}
			}, function () {}, 320, 90,true);
		} else {
			try
			{
				//为了对《工作安排》流程作特殊的处理，请参考MR1010
				$GetEle("planDoRemark").click();
			}
			catch(e)
			{                
				if(checktimeok()) 
				{
					$GetEle("frmmain").isremark.value='1';
					$GetEle("frmmain").src.value='save';
					
					
					jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

				//TD4262 增加提示信息  开始
				<%
					if(ismode.equals("1"))
					{
				%>
					
					contentBox = $GetEle("divFavContent18978");
					showObjectPopup(contentBox)
				<%
					
					}
					else
					{
				%>
				   
						var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
						showPrompt(content);
						
				<%
					}
				%>
					//TD4262 增加提示信息  结束
					setRemindData();
					setRepeatdata();
					 try{obj.disabled=true;}catch(e1){}
					//附件上传
							StartUploadAll();
							checkuploadcomplet();
				}
			}
		}
	}

</script>
<script language="javascript">
    function doSubmit(obj){        <!-- 点击提交 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSubmit").click();
        }catch(e){
      //modify by xhheng @20050328 for TD 1703
      //明细部必填check，通过try $GetEle("needcheck")来检查,避免对原有无明细单据的修改
        var ischeckok="";
        try{
			getRemarkText_log();
        if(check_form($GetEle("frmmain"),$GetEle("needcheck").value+$GetEle("inputcheck").value))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
          if(check_form($GetEle("frmmain"),'<%=needcheck%>'))
            ischeckok="true";
        }
        if(ischeckok=="true"){
            if(checktimeok()){
				obj.disabled=true;
			    if($GetEle("<%=repeatType%>") && $GetEle("<%=repeatType%>").value != 0 ){
					window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("33277,24355",user.getLanguage())%>", function (){
						submitact();
					},function(){obj.disabled=false;});
				}else{
					jQuery.ajax({
						type: 'POST',
						url: "/meeting/data/AjaxMeetingOperation.jsp?method=chkRoom",
						data: {address:$GetEle("frmmain").<%=Address%>.value,begindate:$GetEle("frmmain").<%=newfromdate%>.value,begintime:$GetEle("frmmain").<%=newfromtime%>.value,enddate:$GetEle("frmmain").<%=newenddate%>.value,endtime:$GetEle("frmmain").<%=newendtime%>.value,meetingid:'<%=MeetingID%>',requestid:'<%=requestid%>'},
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
							} else{
								submitChkMbr(obj);
							}
						}
					  });
				}
            }
        }
        }
	}

	function doReject(){        <!-- 点击退回 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoReject").click();
        }catch(e){
            $GetEle("frmmain").src.value='reject';
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231   
            if(onSetRejectNode()){
            //增加提示信息  开始 meiYQ 2007.10.19 start
		       	var content="<%=SystemEnv.getHtmlLabelName(18980,user.getLanguage())%>";
		       	showPrompt(content);
            //增加提示信息  结束 meiYQ 2007.10.19 end
            setRemindData();
			setRepeatdata();
            //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
            }
        }
    }

	function doReopen(){        <!-- 点击重新激活 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoReopen").click();
        }catch(e){
            $GetEle("frmmain").src.value='reopen';
            $GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
            jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
            setRemindData();
			setRepeatdata();
            //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
	}

	function doDelete(){        <!-- 点击删除 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoDelete").click();
        }catch(e){
        	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16667,user.getLanguage())%>", function (){
        		 $GetEle("frmmain").src.value='delete';
                 $GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
                 jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
                 setRemindData();
 				 setRepeatdata();
                 //附件上传
                 StartUploadAll();
                 checkuploadcomplet();
				}, function () {}, 320, 90,true);
        }
    }
//添加常用短语
function onAddPhrase(phrase){
	if(phrase!=null && phrase!=""){
		try{
			var remarkHtml = FCKEditorExt.getHtml("remark");
			var remarkText = FCKEditorExt.getText("remark");
			if(remarkText==null || remarkText==""){
				FCKEditorExt.setHtml(phrase,"remark");
			}else{
				FCKEditorExt.setHtml(remarkHtml+"<p>"+phrase+"</p>","remark");
			}
		}catch(e){}
	}
}

	function showPrompt(content)
{

     var showTableDiv  = $GetEle('_xTable');
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = $GetEle("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     message_table_Div.style.top=pTop;
     message_table_Div.style.left=pLeft;

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

function openAccessory(fileId){
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&requestid=<%=requestid%>");
}
function showfieldpop(){
<%if(fieldids.size()<1){%>
top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22577,user.getLanguage())%>");
<%}%>
}
if (window.addEventListener)
window.addEventListener("load", showfieldpop, false);
else if (window.attachEvent)
window.attachEvent("onload", showfieldpop);
else
window.onload=showfieldpop; 
</script>

<script type="text/javascript">
 function setRemindData()
	{
		try{
		if(jQuery("#<%=remindTypeNew%>").length==0){
		return ;
		}
	
	if("<%=remindTypeNew%>"==""){
		return true;
	}	
		
		//有提醒, 才进行相关计算
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


function countAttend()
{
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
                var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
                $GetEle("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
            }
        }
    }catch(e){}
}

function changeRepeatType(){
	var thisvalue=$GetEle("<%=repeatType%>").value;
	jQuery("#repeattr").css("display", "");
	if(thisvalue == 0){
		//$("#startDateH").html("<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>");
		//$("#endDateH").html("<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%>");
		jQuery("#dayrepeat").css("display", "none");
		jQuery("#weekrepeat").css("display", "none");
		jQuery("#monthrepeat").css("display", "none");
		jQuery("#repeattr").css("display", "none");
	} else {
		//$("#startDateH").html("<%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>");
		//$("#endDateH").html("<%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%>");
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
var mtypeold="<%=meetingtype%>";
function meetingTypeChange(fieldid,url,linkurl,fieldtype,viewtype){
	var mtypeold = $GetEle("field" + fieldid).value;
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
			jQuery($GetEle("<%=caller%>spanimg")).html("");
		}
		
	}
	
	var hrmids02s = jQuery(".hrmids02s");
	if($GetEle("<%=hrmids02%>")&& hrmids02s && hrmids02s.length > 0  && hrmids02s.val() !="" && $GetEle("<%=hrmids02%>").value == ""){
		$GetEle("<%=hrmids02%>").value = hrmids02s.val();
		$GetEle("<%=resourceNumFieldId%>").value = jQuery(".hrmCnts").val();
		var idArray = hrmids02s.val().split(",");
		var nameArray = jQuery(".hrmids02spans").val().split(",");
		var sHtml = "";
		for ( var _i = 0; _i < idArray.length; _i++) {
			var curid = idArray[_i];
			var curname = nameArray[_i];
    
			sHtml += wrapshowhtml(0,"<A href='/hrm/resource/HrmResource.jsp?id="+curid+"' target=_blank>"+curname+"</A>&nbsp",curid);
		}
    
		$GetEle("<%=hrmids02%>span").innerHTML = sHtml;
		
		if($GetEle("<%=hrmids02%>").getAttribute("viewtype") == "1" && $GetEle("<%=hrmids02%>").value == ""){
			jQuery($GetEle("<%=hrmids02%>spanimg")).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
		} else {
			jQuery($GetEle("<%=hrmids02%>spanimg")).html("");
		}
	}
	
	var crmids02s = jQuery(".crmids02s");
	if($GetEle("<%=crmids02%>")&& crmids02s && crmids02s.length > 0  && crmids02s.val() !="" && $GetEle("<%=crmids02%>").value == ""){
		$GetEle("<%=crmids02%>").value = crmids02s.val();
		$GetEle("<%=crmsNumFieldId%>").value = jQuery(".crmCnts").val();
		var idArray = crmids02s.val().split(",");
		var nameArray = jQuery(".crmids02spans").val().split(",");
		var sHtml = "";
		for ( var _i = 0; _i < idArray.length; _i++) {
			var curid = idArray[_i];
			var curname = nameArray[_i];
    
			sHtml = sHtml+wrapshowhtml(0,"<a target='_new' href='/CRM/data/ViewCustomer.jsp?CustomerID="+curid+"'  >"+curname+"</a>&nbsp;",curid);
		}
    
		$GetEle("<%=crmids02%>span").innerHTML = sHtml;
		
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
		var whereclauses =jQuery(".whereclauses").val();
		url = "/systeminfo/BrowserMain.jsp?url=/meeting/data/CallerBrowser.jsp?meetingtype="+jQuery('#<%=meetingtype1%>').val();	
	}else{
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
		
	}
	
	onShowBrowser2(fieldid,url,linkurl,fieldtype,viewtype);
	
} 
jQuery(document).ready(function(){
	changeRepeatType();
	//countAttend();
});

<%=selectInitJsStr%>
//yl qc:67452 end

function openDocExt(showid,versionid,docImagefileid,isedit){
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
    
	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>");
	}
}

function openAccessory(fileId){ 
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>");
}

function changecancleon(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#f4fcff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","block");
}

function changecancleout(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#ffffff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","none");
}

function clearAllQueue(oUploadcancle){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())+SystemEnv.getHtmlLabelName(21407,user.getLanguage())%>?", function(){
		//jQuery("#fsUploadProgress"+oUploadId).empty();
		//var oUploadcancle = "oUpload"+oUploadId;
		oUploadcancle.cancelQueue();
	}, function () {}, 320, 90,true);
}

function onChangeSharetypeNew(obj,delspan,delid,showid,names,ismand,Uploadobj){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84051,user.getLanguage())%>"+names+"<%=SystemEnv.getHtmlLabelName(82179,user.getLanguage())%>", function(){
	    jQuery(obj).parent().parent().parent().parent().css("display","none");
	    
		var fieldid=delid.substr(0,delid.indexOf("_"));
	    var linknum=delid.substr(delid.lastIndexOf("_")+1);
		var fieldidnum=fieldid+"_idnum_1";
		var fieldidspan=fieldid+"span";
	    var delfieldid=fieldid+"_id_"+linknum;
	    if($GetEle(delspan).style.visibility=='visible'){
	      $GetEle(delspan).style.visibility='hidden';
	      $GetEle(delid).value='0';
		  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
	        var tempvalue=$GetEle(fieldid).value;
	          if(tempvalue==""){
	              tempvalue=$GetEle(delfieldid).value;
	          }else{
	              tempvalue+=","+$GetEle(delfieldid).value;
	          }
		     $GetEle(fieldid).value=tempvalue;
	    }else{
	      $GetEle(delspan).style.visibility='visible';
	      $GetEle(delid).value='1';
		  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
	        var tempvalue=$GetEle(fieldid).value;
	        var tempdelvalue=","+$GetEle(delfieldid).value+",";
	          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
	          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
	          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
	          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
	          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
		     $GetEle(fieldid).value=tempvalue;
	    }
		if (ismand=="1"){
			if ($GetEle(fieldidnum).value=="0"){
			    $GetEle(fieldid).value="";
			    var swfuploadid=fieldid.replace("field","");
			    //alert("swfuploadid = "+swfuploadid);
			    var fieldidnew = "field"+swfuploadid;
			    var fieldidspannew = "field_"+swfuploadid+"span";
			    //alert("fieldidspannew = "+fieldidspannew);
			    var linkrequired=$GetEle("oUpload_"+swfuploadid+"_linkrequired");
			    $GetEle(fieldidspannew).innerHTML="";
		        if(Uploadobj.getStats().files_queued==0){
					$GetEle(fieldidspannew).innerHTML="<%=SystemEnv.getHtmlLabelName(81909,user.getLanguage())%>";
					var checkstr_=$GetEle("needcheck").value+",";
					if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
		        }
		        if(linkrequired && linkrequired.value=="false"){
		        	$GetEle(fieldidspannew).innerHTML="";
		        }
		  	}else{
		  	 var swfuploadid=fieldid.replace("field","");
		  	 //alert("swfuploadid = "+swfuploadid);
		     var fieldidspannew = "field_"+swfuploadid+"span";
			 $GetEle(fieldidspannew).innerHTML="";
		  	}
		}else{//add by td78113
			var swfuploadid=fieldid.replace("field","");
		    var fieldidnew = "field"+swfuploadid;
		    var fieldidspannew = "field_"+swfuploadid+"span";
			if(jQuery("#"+fieldidnew).attr("viewtype")=="1"){
				if(Uploadobj.getStats().files_queued==0){
					$GetEle(fieldidspannew).innerHTML="<%=SystemEnv.getHtmlLabelName(81909,user.getLanguage())%>";
					var checkstr_=$GetEle("needcheck").value+",";
					if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
			    }
			}
		    
		  	displaySWFUploadError(fieldid);
		}
		
		////
		var leaveNum = jQuery("#"+fieldid).val();
		if(leaveNum == "" || leaveNum == null){
			var upid = fieldid.substr(5);
			jQuery("#field_upload_"+upid).attr("disabled","disabled");
		}
	}, function () {}, 320, 90,true);
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
	showBrwDlg(url, "fromwf=1&selectedids="+$('#'+inputname).val(), 500,570,spanname,inputname,"addressChgCbk");
}

//会议室回写处理
function addressChgCbk(datas){
		if(datas){
		if (datas!=""){
             var ids = datas.id;
             var names = datas.name;
             arrid=ids.split(",");
             arrname=names.split(",");
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
	}
	//addressCallBack();
}
</script>

</form>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>

