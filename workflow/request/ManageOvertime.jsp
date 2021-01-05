
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.browserData.BrowserManager"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!--yl qc:67452 start-->
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<!--yl qc:67452 end-->
<%@ include file="/activex/target/ocxVersion.jsp" %>
<object ID="oFile" <%=strWeaverOcxInfo%> STYLE="height:0px;width:0px;overflow:hidden;"></object>

<%	//      check user's right about current request operate

String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
int usertype = 0;
int languagebodyid = user.getLanguage() ;
String newfromdate="a";
String newenddate="b";
int isbill = 1;
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
String  isrequest=Util.null2String(request.getParameter("isrequest"));
String logintype = user.getLogintype();

String requestmark=Util.null2String(request.getParameter("requestmark"));
String workflowtype=Util.null2String(request.getParameter("workflowtype"));
String docfileid=Util.null2String(request.getParameter("docfileid"));
String newdocid=Util.null2String(request.getParameter("newdocid"));
String topage=Util.null2String(request.getParameter("topage"));
    // yl qc:67452 start
    String selectInitJsStr = "";
    String initIframeStr = "";
//yl qc:67452 end
String requestname="";
String requestlevel="";
int workflowid=0;
int formid=0;
int billid=0;
int nodeid=0;
String nodetype="";

int hasright=0;
String status="";
int creater=0;
int deleted=0;
int isremark=0;
int creatertype = 0;

String bclick="";


if(logintype.equals("1"))
	usertype = 0;
if(logintype.equals("2"))
	usertype = 1;
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
char flag=Util.getSeparator() ;

int lastOperator=0;
String lastOperateDate="";
String lastOperateTime="";

lastOperator=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"lastOperator"),0);
lastOperateDate=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateDate"));
lastOperateTime=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateTime"));

RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){	
	workflowid=RecordSet.getInt("workflowid");
	nodeid=RecordSet.getInt("currentnodeid");
	nodetype=RecordSet.getString("currentnodetype");
	requestname=RecordSet.getString("requestname");
	status=RecordSet.getString("status");
	creater=RecordSet.getInt("creater");
	deleted=RecordSet.getInt("deleted");
	creatertype = RecordSet.getInt("creatertype");	
	requestlevel=RecordSet.getString("requestlevel");
}

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+"and usertype = "+usertype+" and isremark='0'");
if(RecordSet.next())	hasright=1;

RecordSet.executeSql("select isremark from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+ usertype + " and isremark in('1','9','7') order by isremark");
if(RecordSet.next()){
	isremark=RecordSet.getInt("isremark");
}

if(hasright==0&&isremark==0){
	response.sendRedirect("/notice/noright.jsp");
    	return;
}
String isSignMustInput="0";
RecordSet.executeSql("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
}
String user_fieldid="";
String isreopen="";
String isreject="";
String isend="";
RecordSet.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
if(RecordSet.next()){
	user_fieldid=RecordSet.getString("userids");
	isreopen=RecordSet.getString("isreopen");
	isreject=RecordSet.getString("isreject");
	isend=RecordSet.getString("isend");
}

//~~~~~~~~~~~~~get submit button title~~~~~~~~~~~~~~~
String submit="";
if(nodetype.equals("0"))	submit=SystemEnv.getHtmlLabelName(615,user.getLanguage());
if(nodetype.equals("1"))	submit=SystemEnv.getHtmlLabelName(142,user.getLanguage());
if(nodetype.equals("2"))	submit=SystemEnv.getHtmlLabelName(725,user.getLanguage());
if(nodetype.equals("3"))	submit=SystemEnv.getHtmlLabelName(251,user.getLanguage());

//~~~~~~~~~~~~~~get billformid & billid~~~~~~~~~~~~~~~~~~~~~
RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
RecordSet.next();
formid=RecordSet.getInt("billformid");
billid=RecordSet.getInt("billid");

String needcheck="requestname";


int rqMessageType=-1;
int wfMessageType=-1;
int rqChatsType=-1; //微信提醒(QC:98106)
int wfChatsType=-1;	//微信提醒(QC:98106)
String docCategory= "";
//微信提醒(QC:98106)
String sqlWfMessage = "select a.messagetype,a.chatstype,b.docCategory,b.MessageType as wfMessageType,b.ChatsType as wfChatsType from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="+requestid ;
RecordSet.executeSql(sqlWfMessage);
if (RecordSet.next()) {
    rqMessageType=RecordSet.getInt("messagetype");
    wfMessageType=RecordSet.getInt("wfMessageType");
    rqChatsType=RecordSet.getInt("chatstype");//微信提醒(QC:98106)
    wfChatsType=RecordSet.getInt("wfChatsType");//微信提醒(QC:98106)
	docCategory= RecordSet.getString("docCategory");
}
 int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
 int maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+secid),5); //从缓存中取

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
 boolean isCanuse = RequestManager.hasUsedType(workflowid);
 if(selectedfieldid.equals("") || selectedfieldid.equals("0")){
 	isCanuse = false;
 }
 
//获得触发字段名

DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();

ArrayList selfieldsadd=WfLinkageInfo.getSelectField(workflowid,nodeid,0);
ArrayList changefieldsadd=WfLinkageInfo.getChangeField(workflowid,nodeid,0);
%>

<script language=javascript>
function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        var oFile=document.getElementById("oFile");
        oFile.FilePath=objValue;
        fileLenth= oFile.getFileSize();
    } catch (e){
        //alert("<%=SystemEnv.getHtmlLabelName(20253,user.getLanguage())%>");
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
    outerHTML="<input name="+objName+" class=InputStyle type=file size=50 >";  
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

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");

          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+document.all(accname+'_num').value+"' onchange='accesoryChanage(this)'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
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


<!--增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>

<div align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(WorkflowComInfo.getWorkflowname(""+workflowid),user.getLanguage())%></font>
</div>
<!--增加提示信息  结束-->
<form name="frmmain" method="post" action="OvertimeOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="<%=nodetype%>">
<input type=hidden name="src" value="active">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="isbill" value="1">
<input type=hidden name="billid" value=<%=billid%>>
<input type="hidden" name="htmlfieldids">
<div style="visibility:hidden;">
<%if(isremark==1){%>
<BUTTON class=btnSave accessKey=S type=button onclick="doRemark()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
<%} else {%>
<%if(!isend.equals("1")){%>
<BUTTON class=btn accessKey=B type=button onclick="doSubmit()"><U>B</U>-<%=submit%></button>
<BUTTON class=btn accessKey=M type=button onclick="location.href='Remark.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>'"><U>M</U>-<%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%></button>
<%}}%>

<%if(!isend.equals("1")){%>
<BUTTON class=btnSave accessKey=S type=button onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
<%}%>

<%if(isremark!=1){%>
<%if(isreopen.equals("1") && false){%>
<BUTTON class=btn accessKey=O type=button onclick="doReopen()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%></button>
<%}%>
<%if(isreject.equals("1")){%>
<BUTTON class=btn accessKey=J type=button onclick="doReject()"><U>J</U>-<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></button>
<%}%>
<%if(nodetype.equals("0")){%>
<BUTTON class=btnDelete accessKey=D type=button onclick="doDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
<%}%><%}%>
<BUTTON class=btn accessKey=1 type=button onclick="location.href='RequestView.jsp'"><U>1</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></button>
</div>
  <br>
  <%
boolean isedit_1 = false ;
boolean isedit_2 = false ;
RecordSet.executeSql("SELECT fieldid,isview,isedit FROM workflow_nodeform WHERE nodeid="+nodeid+" AND fieldid in (-1,-2)");
while(RecordSet.next()){
	String _fieldid = RecordSet.getString("fieldid");
	String _isedit = RecordSet.getString("isedit");
	if(_fieldid.equals("-1")&&_isedit.equals("1")){
		isedit_1 = true ;
	}
	if(_fieldid.equals("-2")&&_isedit.equals("1")){
		isedit_2 = true ;
	}
}
%> 
  <table class="viewform">
    <colgroup> <col width="20%"> <col width="80%">
    <tr class="Spacing"> 
      <td class="Line1" colspan=2></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
      <td class=field> 
            <% 
      	if(isedit_1){
      %>
      <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname id=requestname onChange="checkinput('requestname','requestnamespan');" size=60  maxlength=100  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
      <span id=requestnamespan>
      	<%if(requestname.equals("")){ %><img src="/images/BacoError_wev8.gif" align=absmiddle><%} %>
      	</span>
      <%		
      	}else{
      %>
      <%=Util.toScreen(requestname,user.getLanguage())%> 
       <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
       <%} %>
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%if(isedit_2){
    	  %>
    	    <input type=radio value="0" name="requestlevel" <% if(requestlevel.equals("0")){ %>checked <%} %> ><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
	        <input type=radio value="1" name="requestlevel" <% if(requestlevel.equals("1")){ %>checked <%} %>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
	        <input type=radio value="2" name="requestlevel" <% if(requestlevel.equals("2")){ %>checked <%} %>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
    	  <%
      }else{ %>
	      <span>
	      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> <%}%>
	      <%if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%> <%}%>
	      <%if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
	      </span>
      <%} %>
      </td>
    </tr>
<tr><td class=Line1 colSpan=2></td></tr>


  <%
        if (wfMessageType==1) {
  %>
                    <TR>
                      <TD > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
                      <td class=field>
                            <span id=messageTypeSpan></span>
                            <input type=radio value="0" name="messageType"   <%if(rqMessageType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
                            <input type=radio value="1" name="messageType"   <%if(rqMessageType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
                            <input type=radio value="2" name="messageType"   <%if(rqMessageType==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
                          </td>
                    </TR>
                    <TR><TD class=Line2 colSpan=2></TD></TR>
        <%}%>  
        <!-- 微信提醒(QC:98106) -->
        <% 
     	if(wfChatsType==1){
			%>
			<TR>
				<TD > <%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%></TD>
				<td class=field>
				  <span id=messageTypeSpan></span>
                            <input type=radio value="0" name="messageType"   <%if(rqChatsType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
                            <input type=radio value="1" name="messageType"   <%if(rqChatsType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>
                  </td> 
	    </TR>
    	<TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
     	<%}%>
    <%
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid+"");
RecordSet.next();
formid=RecordSet.getInt("formid");

ArrayList fieldids=new ArrayList();
ArrayList fieldnames=new ArrayList();
ArrayList fieldvalues=new ArrayList();
ArrayList fieldlabels=new ArrayList();
ArrayList fieldhtmltypes=new ArrayList();
ArrayList fieldtypes=new ArrayList();
ArrayList fieldimgwidths=new ArrayList();
ArrayList fieldimgheights=new ArrayList();
ArrayList fieldimgnums=new ArrayList();
RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	fieldids.add(RecordSet.getString("id"));
	fieldnames.add(RecordSet.getString("fieldname"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
	fieldimgwidths.add(Util.null2String(RecordSet.getString("imgwidth")));
        fieldimgheights.add(Util.null2String(RecordSet.getString("imgheight")));
        fieldimgnums.add(Util.null2String(RecordSet.getString("textheight")));
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

RecordSet.executeProc("Bill_HrmTime_SelectByID",billid+"");
RecordSet.next();
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);	
	fieldvalues.add(RecordSet.getString(fieldname));
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
for(int i=0;i<fieldids.size();i++){
	String fieldid=(String)fieldids.get(i);
	String fieldname=(String)fieldnames.get(i);
	String fieldvalue=(String)fieldvalues.get(i);
	//String isview=(String)isviews.get(i);
	//String isedit=(String)isedits.get(i);
	//String ismand=(String)ismands.get(i);
	String isview="0";
	String isedit="0";
	String ismand="0";
	int fieldimgwidth=0;                            //图片字段宽度
    int fieldimgheight=0;                           //图片字段高度
    int fieldimgnum=0;                              //每行显示图片个数
    fieldimgwidth=Util.getIntValue((String)fieldimgwidths.get(i),0);
		fieldimgheight=Util.getIntValue((String)fieldimgheights.get(i),0);
		fieldimgnum=Util.getIntValue((String)fieldimgnums.get(i),0);
    int isfieldidindex = isfieldids.indexOf(fieldid) ;
    if( isfieldidindex != -1 ) {
        isview=(String)isviews.get(isfieldidindex);    //字段是否显示
	    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
	    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
    }
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	if(fieldname.equals("begindate")) newfromdate="field"+fieldid;
	if(fieldname.equals("enddate")) newenddate="field"+fieldid;
	if(fieldhtmltype.equals("3") && fieldvalue.equals("0")) fieldvalue = "" ;
    if(fieldname.equals("manager")) {
	    String tmpmanagerid = ResourceComInfo.getManagerID(beagenter);
%>
	<input type=hidden name="field<%=fieldid%>" value="<%=tmpmanagerid%>" />
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

   if(isview.equals("1")){
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
			if(isedit.equals("1")&&isremark==0){
				if(ismand.equals("1")) {%>
        <input type=text onblur="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>" class=inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" style="width:50%">
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text onblur="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>" class=inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" style="width:50%" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))">
        <span id="field<%=fieldid%>span"></span>
        <%}
			}else{
		%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
        <%
			}
		}
		else if(fieldtype.equals("2")){
			if(isedit.equals("1")&&isremark==0){
				if(ismand.equals("1")) {%>
        <input type=text class=inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" style="width:50%"
		onKeyPress="ItemCount_KeyPress()" onBlur="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))">
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text class=inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onKeyPress="ItemCount_KeyPress()" onBlur="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" style="width:50%">
        <span id="field<%=fieldid%>span"></span>
        <%}
			}else{
		%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
        <%
			}
		}
		else if(fieldtype.equals("3")){
			if(isedit.equals("1")&&isremark==0){
				if(ismand.equals("1")) {%>
        <input type=text class=inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onKeyPress="ItemNum_KeyPress()" onBlur="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))">
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text class=inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onKeyPress="ItemNum_KeyPress()" onBlur="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))">
        <span id="field<%=fieldid%>span"></span>
        <%}
			}else{
		%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
        <%
			}
		}
            if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	}
	else if(fieldhtmltype.equals("2")){
		if(isedit.equals("1")&&isremark==0){
			%>
			<script>document.getElementById("htmlfieldids").value += "field<%=fieldid%>;<%=Util.toScreen(fieldlable,languagebodyid)%>,";</script>
				<%
			if(ismand.equals("1")) {%>
        <textarea onblur="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>" class=inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))"
		 rows="4" cols="40" style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
				needcheck+=",field"+fieldid;
			}else{%>
        <textarea onblur="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>" class=inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" rows="4" cols="40" style="width:80%" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
        <span id="field<%=fieldid%>span"></span>
        <%}
		}else{
		%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
        <%
			}
            if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	}
	else if(fieldhtmltype.equals("3")){
		String showname="";
		String showid="" ;
		String sql="";
		String url=BrowserComInfo.getBrowserurl(fieldtype);
		String linkurl = Util.null2String(BrowserComInfo.getLinkurl(fieldtype));
		if(fieldtype.equals("2") ||fieldtype.equals("19")  )	showname=fieldvalue;
		else if((!fieldtype.equals("162")&&!fieldtype.equals("161"))&&!fieldvalue.equals("")){
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			sql="select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
				showid = RecordSet.getString(1);
				String tmpname=RecordSet.getString(2);
				if(!linkurl.equals("")){
					showname +="<a href='"+linkurl+showid+"'>"+tmpname+"</a>&nbsp";
				}else{
					showname += tmpname+" ";	
				}
				
			}
			    
		}
		else {
			int intfieldvalue=Util.getIntValue(fieldvalue,0);
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+intfieldvalue;
			RecordSet.executeSql(sql);
			RecordSet.next();
			showname ="<a href='"+linkurl+intfieldvalue+"'>"+RecordSet.getString(1)+"</a>&nbsp";
		}
		%>
        <%if(isedit.equals("1")&&isremark==0){
			bclick="onShowBrowser('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',field"+fieldid+".getAttribute('viewtype'))";
		%>
		<brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=Util.toScreen(fieldvalue,user.getLanguage())%>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="130px" needHidden="false" browserSpanValue='<%=Util.toScreen(showname,user.getLanguage())%>'> </brow:browser>
    <!--    <button class=Browser onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))"></button>-->
        <%}%>
        <input type=hidden onpropertychange="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" value="<%=Util.toScreen(fieldvalue,user.getLanguage())%>">
     <!--   <span id="field<%=fieldid%>span">
        <%=Util.toScreen(showname,user.getLanguage())%>
        <%if(ismand.equals("1")){%>
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        <%	needcheck+=",field"+fieldid;	
			}%></span>-->
        <%
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	}
	else if(fieldhtmltype.equals("4")){%> 
		<%if(isedit.equals("0")||isremark==1){%>
        <input type=checkbox viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" value=1 name="prefield_<%=fieldid%>" DISABLED <%if(fieldvalue.equals("1")){%> checked <%}%>>
        <input type= hidden name="field<%=fieldid%>" value=<%=fieldvalue%>>
        <%} else {%>
        <input type=checkbox onchange="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>" value=1 name="field<%=fieldid%>" <%if(fieldvalue.equals("1")){%> checked <%}%>>
        <%}
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
    }
	else if(fieldhtmltype.equals("5")){%>
		<%if(isedit.equals("0")||isremark==1){%>
        <select class=inputstyle  name="field<%=fieldid%>" DISABLED >
	<%
	rs.executeProc("workflow_selectitembyid_new",""+fieldid+flag+"1");
	while(rs.next()){
		int tmpselectvalue = rs.getInt("selectvalue");
		String tmpselectname = rs.getString("selectname");
	%>
	<option value="<%=tmpselectvalue%>"  <%if(fieldvalue.equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
	<%}%>
	</select>
	<input type= hidden name="field<%=fieldid%>" value=<%=fieldvalue%>>
        <%} else {
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
        <select class=inputstyle viewtype="<%=ismand%>"       <%=onchangeAddStr%>        temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" onBlur="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%if(selfieldsadd.indexOf(fieldid)>=0){%> onChange="changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%} %>" <%}%>>
		<%
		rs.executeProc("workflow_selectitembyid_new",""+fieldid+flag+"1");
            boolean checkempty = true;//xwj for td3313 20051206
            String finalvalue = "";//xwj for td3313 20051206

            //yl 67452   start
            if(hasPfield == false){
		while(rs.next()){
			int tmpselectvalue = rs.getInt("selectvalue");
			String tmpselectname = rs.getString("selectname");
		%>
		<option value="<%=tmpselectvalue%>"  <%if(fieldvalue.equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
		<%}
        } else{
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
        <%}
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }}else if(fieldhtmltype.equals("6")){
			String isaffirmancebody="";
			String reEditbody="";
			String sql=null;

        %>
          <%if( isedit.equals("1") && isremark != 1 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){%>
          <!--modify by xhheng @20050511 for 1803-->
          <table cols=3 id="field<%=fieldid%>_tab">
            <tbody >
            <col width="50%" >
            <col width="25%" >
            <col width="25%">
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
                          <td colspan="2" align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&requestid=<%=requestid%>&fromrequest=1" style="cursor:hand" alt="<%=docImagefilename%>" <%if(fieldimgwidth>0){%>width="<%=fieldimgwidth%>"<%}%> <%if(fieldimgheight>0){%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=ismand%>",oUpload<%=fieldid%>);return false;'>[<span style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>]</a>
                                    <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden"><b><font COLOR="#FF0033">√</font></b><span></td>
                              <%
                                  boolean isLocked=SecCategoryComInfo1.isDefaultLockedDoc(Integer.parseInt(showid));
                                  if (!isLocked) {
                              %>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>');return false;">[<span style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></span>]</a>
                              </td>
                              <%}%>
                      </tr>
                        </table>
                    </td>
              <%}else{ %>

          <tr>
            <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0" >
            <td >
              <%=imgSrc%>

              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a  style="cursor:hand" onclick="addDocReadTag('<%=showid%>');opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp

              <%}%>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
            </td>
            <td >
                <button class=btn accessKey=1  onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=ismand%>",oUpload<%=fieldid%>)'><u><%=linknum%></u>-删除
                  <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden">
                    <b><font COLOR="#FF0033">√</font></b>
                  <span>
                </button>
            </td>
            <%if(accessoryCount==1){%>
            <td >
              <span id = "selectDownload">
                <%
                  boolean isLocked=SecCategoryComInfo1.isDefaultLockedDoc(Integer.parseInt(showid));
                  if(!isLocked){
                %>
                  <button class=btn accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	  (<%=docImagefileSize/1000%>K)
                  </button>
                <%}%>
              </span>
            </td>
            <%}%>
          </tr>
              <%}}
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
           %>
            <script>
          var oUpload<%=fieldid%>;
          function fileupload<%=fieldid%>() {
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>",    // Relative to the SWF file
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
            button_image_url : "/js/swfupload/add_wev8.png",
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
              <td colspan="2" style="background-color:#fff;">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolder<%=fieldid%>"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload<%=fieldid%>.cancelQueue();showmustinput(oUpload<%=fieldid%>);" id="btnCancel<%=fieldid%>">
									<span><img src="/js/swfupload/delete_wev8.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span id="uploadspan">(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                      <span id="field<%=fieldid%>span">
				<%
				 if(ismand.equals("1")&&fieldvalue.equals("")){
				%>
			   <img src='/images/BacoError_wev8.gif' align=absMiddle>
			  <%
					}
			   %>
	     </span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>"  viewtype="<%=ismand%>" value="<%=fieldvalue%>">
              </td>
          </tr>
          <tr>
              <td colspan="2" style="background-color:#fff;">
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
             </td>
          </tr>
      </TABLE>
          <%}else{
          if(!fieldvalue.equals("")) {
            %>
          <table cols=3 id="field<%=fieldid%>_tab">
            <tbody >
            <col width="50%" >
            <col width="25%" >
            <col width="25%">
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
              <tr>
              <td>
              <%=imgSrc%>
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp
              <%}%>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>> <!--xwj for td2893 20051017-->
              </td>
              <%if(accessoryCount==1){%>
              <td >
                <span id = "selectDownload">
                  <button class=btn accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	(<%=docImagefileSize/1000%>K)
                  </button>
                </span>
              </td>
              <%}%>
              <td>&nbsp;</td>
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


%>
      </td>
    </tr><tr><td class=Line2 colSpan=2></td></tr>
    <%
   }else{

        if (fieldhtmltype.equals("6")){   
			if (!fieldvalue.equals("")){
				ArrayList fieldvalueas=Util.TokenizerString(fieldvalue,",");
				int linknum=-1;
				for(int j=0;j<fieldvalueas.size();j++){
					linknum++;
					String showid = Util.null2String(""+fieldvalueas.get(j)) ;
%>
					<input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
<%
				}
%>
					<input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum+1%>>
<%
			}
          }%>
   <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
 <%}%>
 </tr>
<%}  %>
  </table>


<!--yl qc:67452 start-->
<%=initIframeStr%>
<!--yl qc:67452   end-->
<input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">
  <br>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
<script language=vbs>
sub onShowResourceID(ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.resourceid.value=id(0)
	else 
		if ismand=1 then
			resourceidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		else
			resourceidspan.innerHtml = ""
		end if
	frmmain.resourceid.value="0"
	end if
	end if
end sub

sub getBDate(ismand)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("begindatespan").innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else
		document.all("begindatespan").innerHtml= returndate
	end if
	document.all("begindate").value=returndate
end sub
sub getEDate(ismand)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("enddatespan").innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else	
		document.all("enddatespan").innerHtml= returndate
	end if
	document.all("enddate").value=returndate
end sub

sub getBTIme(ismand)
	returndate = window.showModalDialog("/systeminfo/Clock.jsp",,"dialogHeight:360px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("begintimespan").innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else
		document.all("begintimespan").innerHtml= returndate
	end if
	document.all("begintime").value=returndate
end sub
sub getETime(ismand)
	returndate = window.showModalDialog("/systeminfo/Clock.jsp",,"dialogHeight:360px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("endtimespan").innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else	
		document.all("endtimespan").innerHtml= returndate
	end if
	document.all("endtime").value=returndate
end sub
</script>  

<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
</form>
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

	function doRemark(){
		document.frmmain.isremark.value='1';
		document.frmmain.src.value='save';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	
	function doSave(){
		if(check_form(document.frmmain,document.all("needcheck").value+document.all("inputcheck").value)){
			document.frmmain.src.value='save';
//			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			if(checktimeok()){
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
            }
		}
	}

    function doSubmit(obj){            <!-- 点击提交 -->	   
    	getRemarkText_log();
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
        <%if(isSignMustInput.equals("1")){%>
        if(ischeckok=="true"){
		    if(!check_form(document.frmmain,'remarkText10404')){
			    ischeckok="false";
		    }
        }
		<%}%>
		
        if(ischeckok=="true"){
            if(checktimeok()) {
                document.frmmain.src.value='submit';
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

               //增加提示信息  开始

		       		  var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
		       		  showPrompt(content);
               //增加提示信息  结束

                obj.disabled=true;
                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
            }
        }
    }
	function doReject_old(obj){
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
        <%if(isSignMustInput.equals("1")){%>
        if(ischeckok=="true"){
		    if(!check_form(document.frmmain,'remarkText10404')){
			    ischeckok="false";
		    }
        }
		<%}%>
        if(ischeckok=="true"){
            if(checktimeok()) {
						document.frmmain.src.value='reject';
						jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
            if(onSetRejectNode()){
            //增加提示信息  开始

		       	var content="<%=SystemEnv.getHtmlLabelName(18980,user.getLanguage())%>";
		       	showPrompt(content);
            //增加提示信息  结束
                obj.disabled=true;
                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
            }
            }
        }
		}
	function doReopen(){
			document.frmmain.src.value='reopen';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	function doDelete(){
			document.frmmain.src.value='delete';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
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
function openAccessory(fileId){
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&fromrequest=1");
}

//yl qc:67452 start
function $changeOption(obj, fieldid, childfieldid){

    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
    $GetEle("selectChange").src = "SelectChange.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&"+paraStr;
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
                $GetEle("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&"+paraStr;
            }
        }
    }catch(e){}
}
<%=selectInitJsStr%>
//yl qc:67452 end

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
      document.all("datainputform").src="DataInputFrom.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&"+StrData;
  }
</script>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
</body>
</html>
