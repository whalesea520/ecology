<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog1" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog2" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<%@page import = "weaver.general.TimeUtil"%><!--added by xwj for td2891-->
<%@ page import="weaver.workflow.request.ComparatorUtilBean"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<jsp:useBean id="rsCheckUserCreater" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="NodeOverTimeInfo" class="weaver.workflow.node.NodeOverTimeInfo" scope="page" />
<jsp:useBean id="rssign" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="RequestLogOperateName" class="weaver.workflow.request.RequestLogOperateName" scope="page"/>
<jsp:useBean id="DepartmentComInfoTemp" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%@ page import="java.util.Hashtable" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />
<jsp:useBean id="RequestUseTempletManager" class="weaver.workflow.request.RequestUseTempletManager" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<%--编码问题--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.net.URLEncoder" %>
<%--编码问题--%>
<%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>

<link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">
<script type="text/javascript" src="/js/ecology8/weaverautocomplete/weaverautocomplete_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>

<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowshow_wev8.css" />
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowcop_wev8.css" />

<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />

<%
int usertype_wfvwt = user.getLogintype().equals("1")?0:1;
%>
<jsp:include page="WorkflowViewWT.jsp" flush="true">
	<jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="userid" value="<%=user.getUID()%>" />
	<jsp:param name="usertype" value="<%=usertype_wfvwt%>" />
	<jsp:param name="languageid" value="<%=user.getLanguage()%>" />
</jsp:include>
<%String needconfirm="";
String isFormSignature="0";
String isSignDoc_edit="";
String isSignWorkflow_edit="";
String isannexupload_edit="";
String annexdocCategory_edit="";
String showDocTab_edit="";
String showWorkflowTab_edit="";
String showUploadTab_edit="";
RecordSetLog.execute("select needAffirmance,isSignDoc,isSignWorkflow,isannexupload,annexdocCategory,showDocTab,showWorkflowTab,showUploadTab from workflow_base where id="+workflowid);
if(RecordSetLog.next()){
    needconfirm=Util.null2o(RecordSetLog.getString("needAffirmance"));
    isSignDoc_edit=Util.null2String(RecordSetLog.getString("isSignDoc"));
    isSignWorkflow_edit=Util.null2String(RecordSetLog.getString("isSignWorkflow"));
    isannexupload_edit=Util.null2String(RecordSetLog.getString("isannexupload"));
    annexdocCategory_edit=Util.null2String(RecordSetLog.getString("annexdocCategory"));
    showDocTab_edit=Util.null2String(RecordSetLog.getString("showDocTab"));
    showWorkflowTab_edit=Util.null2String(RecordSetLog.getString("showWorkflowTab"));
    showUploadTab_edit=Util.null2String(RecordSetLog.getString("showUploadTab"));
}
boolean isOldWf_ = false;
RecordSetOld.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSetOld.next()){
	if(RecordSetOld.getString("nodeid") == null || "".equals(RecordSetOld.getString("nodeid")) || "-1".equals(RecordSetOld.getString("nodeid"))){
			isOldWf_ = true;
	}
}

/**流程存为文档是否要签字意见**/
boolean fromworkflowtodoc = Util.null2String((String)session.getAttribute("urlfrom_workflowtodoc_"+requestid)).equals("true");
boolean ReservationSign = false;
RecordSet.executeSql("select * from workflow_base where id = " + workflowid);
if(RecordSet.next()) ReservationSign = (RecordSet.getInt("keepsign")==2);
if(fromworkflowtodoc&&ReservationSign){
	return;
}
/**流程存为文档是否要签字意见**/

int initrequestid = requestid;
ArrayList allrequestid = new ArrayList();
ArrayList allrequestname = new ArrayList();
ArrayList canviewwf = (ArrayList)session.getAttribute("canviewwf");
if(canviewwf == null) canviewwf = new ArrayList();
int mainrequestid = 0;
int mainworkflowid = 0;
String canviewworkflowid = "-1";

rssign.executeSql("select requestname,mainrequestid from workflow_requestbase where requestid = "+ requestid);
if(rssign.next()){
    if(rssign.getInt("mainrequestid") > -1){
      mainrequestid = rssign.getInt("mainrequestid");
      rssign.executeSql("select * from workflow_requestbase where requestid = "+ mainrequestid);
      if(rssign.next()){
          allrequestid.add(mainrequestid + ".main");
          allrequestname.add(rssign.getString("requestname"));
      }
    }
  } 

rssign.executeSql("select * from workflow_requestbase where requestid = "+ mainrequestid);
if(rssign.next()){
     mainworkflowid = rssign.getInt("workflowid");     
  }

rssign.executeSql("select distinct subworkflowid from Workflow_SubwfSet where mainworkflowid in ("+mainworkflowid+","+workflowid+") and isread = 1 ");
while(rssign.next()){
     canviewworkflowid+=","+rssign.getString("subworkflowid");     
  }
/**161014 zzw 添加判断 **/
if(mainrequestid>0&&!"-1".equals(canviewworkflowid)){
rssign.executeSql("select * from workflow_requestbase where mainrequestid = "+ mainrequestid +" and workflowid in ("+canviewworkflowid+")");
while(rssign.next()){
    allrequestid.add(rssign.getString("requestid") + ".parallel");
    allrequestname.add(rssign.getString("requestname"));
    canviewwf.add(rssign.getString("requestid"));
  }
}
if(requestid>0&&!"-1".equals(canviewworkflowid)){
rssign.executeSql("select * from workflow_requestbase where mainrequestid = "+ requestid+" and workflowid in ("+canviewworkflowid+")");
while(rssign.next()){
    allrequestid.add(rssign.getString("requestid") + ".sub");
    allrequestname.add(rssign.getString("requestname"));
    canviewwf.add(rssign.getString("requestid"));
  }
}

int index = allrequestid.indexOf(requestid+".parallel");
if(index>-1){
    allrequestid.remove(index);
    allrequestname.remove(index);
  }

if(mainrequestid > 0){
	index = allrequestid.indexOf(mainrequestid+".main");
    if(index>-1){
		rssign.executeSql("select * from Workflow_SubwfSet where mainworkflowid = "+mainworkflowid+" and subworkflowid = "+workflowid+" and isread = 1");
		if(rssign.getCounts()==0){
		   allrequestid.remove(index);
		   allrequestname.remove(index);
		}
	}
}

session.setAttribute("canviewwf",canviewwf);

String _intervenoruserids="";
String _intervenorusernames="";
int _nodeid=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"nodeid"));
String _nodetype=WFLinkInfo.getNodeType(_nodeid);
int _creater=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"creater"));
int _creatertype=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"creatertype"));
int _isbill=1;
int _billid=Util.getIntValue(request.getParameter("billid"));
int _formid=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"formid"));
String _isremark="-1";
RecordSetOld.executeSql("select isremark from workflow_currentoperator where nodeid="+_nodeid+" and requestid = " + requestid+" and userid="+user.getUID()+" and usertype="+usertype_wfvwt+" order by isremark");
if(RecordSetOld.next()){
    _isremark=RecordSetOld.getString("isremark");
}
String isSignMustInput="0";
RecordSetOld.executeSql("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSetOld.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSetOld.getString("issignmustinput"), 0);
}

int _nextnodeid=_nodeid;
String _creatername=ResourceComInfo.getResourcename(""+_creater);
int _usertype = (user.getLogintype()).equals("1") ? 0 : 1;
if(_isremark.equals("5")){
    boolean _hasnextnodeoperator = false;
    Hashtable _operatorsht = new Hashtable();
    int _operatorsize=0;
    String _billtablename="";

if (_isbill == 1) {
			RecordSet.executeSql("select tablename from workflow_bill where id = " + _formid); // 查询工作流单据表的信息

			if (RecordSet.next())
				_billtablename = RecordSet.getString("tablename");          // 获得单据的主表

}
    //查询节点操作者

    ArrayList nodeinfo=NodeOverTimeInfo.getNodeUserinfo( requestid, _nodeid, _nodetype, workflowid, user.getUID(), _usertype, _creater, _creatertype, _isbill, _billid, _billtablename);
    if(nodeinfo!=null &&nodeinfo.size()>2){
        _intervenoruserids=(String)nodeinfo.get(0);
        _intervenorusernames=(String)nodeinfo.get(1);
        _nextnodeid=Util.getIntValue((String)nodeinfo.get(2),_nodeid);
    }
    needcheck="";

%>
<iframe id="workflownextoperatorfrm" frameborder=0 scrolling=no src=""  style="display:none;"></iframe>
<%}
%>

<div id='_xTable' style='background:#FFFFFF;padding-top:3px;width:100%;display:none' valign='top'>
</div>
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%;display:none' valign='top'>
</div>

<iframe id="showtipsinfoiframe" name="showtipsinfoiframe" frameborder=0 scrolling=no src="javascript:false"  style="display:none"></iframe>
<input type=hidden name="divcontent" value="">
<input type=hidden name="content" value="">

<input type=hidden name="isremark" value="<%=_isremark%>">
<input type=hidden name="RejectNodes" value="">
<input type=hidden name="workflowRequestLogId" value="-1">
<input type=hidden name="RejectToNodeid" value="">




<table width="100%">
<tr>
<td width="50%"  valign="top">


        

<!--流转意见展示-->
<!--
<table style="width:100%;height:100%" border=0 cellspacing=0 cellpadding=0  scrolling=no >
	  <colgroup>
		<col width="79">
        <%if(showDocTab_edit.equals("1")){%><col width="79"><%}%>
        <%if(showWorkflowTab_edit.equals("1")){%><col width="79"><%}%>
		<%if(showUploadTab_edit.equals("1")){%><col width="79"><%}%>
		<col width="*">
		</colgroup>
  <TBODY>
	  <tr align=left height="20">
	  <td nowrap name="oTDtype_0"  id="oTDtype_0" background="/images/tab.active2_wev8.png" width=79px  align=center onmouseover="style.cursor='hand'" style="font-weight:bold;"  onclick="signtabchange(0)">
	  <%=SystemEnv.getHtmlLabelName(1380,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
	  <%if(showDocTab_edit.equals("1")){%><td nowrap name="oTDtype_1"  id="oTDtype_1" background="url(/images/tab2_wev8.png) no-repeat" width=79px align=center onmouseover="style.cursor='hand'"  onclick='signtabchange(1)'>
	  <%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td><%}%>
      <%if(showWorkflowTab_edit.equals("1")){%><td nowrap name="oTDtype_2"  id="oTDtype_2" background="url(/images/tab2_wev8.png) no-repeat" width=79px  align=center onmouseover="style.cursor='hand'"  onclick="signtabchange(2)">
	  <%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td><%}%>
	  <%if(showUploadTab_edit.equals("1")){%><td nowrap name="oTDtype_3"  id="oTDtype_3" background="url(/images/tab2_wev8.png) no-repeat" width=79px align=center onmouseover="style.cursor='hand'"  onclick='signtabchange(3)'>
	  <%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td><%}%>
      <td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
	  </tr>
  </TBODY>
</table>
-->


	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
	<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css"
		type="text/css" />
	<script type="text/javascript"
		src="/js/ecology8/request/searchInput_wev8.js"></script>

	<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css"
		type="text/css" />
	<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css"
		type="text/css" />
	<link type="text/css" href="/js/tabs/css/e8tabs4_wev8.css" rel="stylesheet" />
	<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
	<script type="text/javascript"
		src="/js/ecology8/request/titleCommon_wev8.js"></script>
	
	<div class="titlePanel" style="margin-top:12px;"></div>
	 <div id="titlePanel">
		 <div class="e8_box demo2" style="width:100%;">
			<ul class="tab_menu">
				<li class="current" id="oTDtype_0">
					<a href="javascript:signtabchanges(0)"><%=SystemEnv.getHtmlLabelName(1380,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></a>
				</li>
				 <%if(showDocTab_edit.equals("1")){%>
				<li id="oTDtype_1">
					<a href="javascript:signtabchanges(1)"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></a>
				</li>
				<%}%>
				<%if(showWorkflowTab_edit.equals("1")){%>
				<li id="oTDtype_2">
					<a href="javascript:signtabchanges(2)"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></a>
				</li>
				<%}%>
				<%if(showUploadTab_edit.equals("1")){%>
				<li id="oTDtype_3">
					<a href="javascript:signtabchanges(3)"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></a>
				</li>
				<%}%>
				<li id="oTDtype_4">
					<a href="javascript:signtabchanges(4)"><%=SystemEnv.getHtmlLabelName(32572,user.getLanguage())%></a>
				</li>
			</ul>
			<div id="rightBox" class="e8_rightBox">
				<table id="topTitle" cellpadding="0" cellspacing="0" style="width:100%">
					<tr>
						<td>
						</td>
						<td class="rightSearchSpan">
						<!--	<input type="text" class="searchInput" value="" name="flowTitle"/>-->
							<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
						
						</td>
					</tr>
				</table>
			</div>
			<div class="tab_box">
			</div>
		</div>

		<div style="position:absolute;display:none;right:4px;border:1px solid #ccc;background-color:#fff;z-index:20;" id="adserch">
			<table class="viewform">
					<colgroup>
						<col width="100px">
						<col width="200px">
						<col width="5px">
						<col width="100px">
						<col width="200px">
						<col width="5px">
						<col width="100px">
						<col width="200px">
					<tbody>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(99, user.getLanguage())%></td>
							<td class=field>
							 <brow:browser viewType="0" name="searchOphrmid" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="120px" browserSpanValue=""> </brow:browser>
							 </td>
							 <td>&nbsp;</td>
							 <td><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></td>
							 <td class=field>
							  <brow:browser viewType="0" name="searchOwnerdepartmentid" browserValue="" browserOnClick="" browserUrl="/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="120px" browserSpanValue=""> </brow:browser>
							 </td>
							 <td>&nbsp;</td>
							 <td><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></td>
							 <td class=field>
							  <brow:browser viewType="0" name="searchCreatersubcompanyid" browserValue="" browserOnClick="" browserUrl="/hrm/company/SubcompanyBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="120px" browserSpanValue=""> </brow:browser>
							 </td>
						</tr>
						<tr style="height:1px;"><td colspan="8" class=Line style="width:100%;border:none;" ></td></tr>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(504, user.getLanguage())%></td>
							<td class=field>
								 <input type="text" name="searchContent" value="" />
							</td>
							<td>&nbsp;</td>
							<td><%=SystemEnv.getHtmlLabelName(15586, user.getLanguage())%></td>
							<td class=field>
								 <input type="text" name="searchNodename" value="" />
							</td>
						</tr>
						<tr style="height:1px;"><td colspan="8" class=Line style="width:100%;border:none;" ></td></tr>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(21663, user.getLanguage())%></td>
							<td class=field colspan="8">
								<span>
								<select name="searchRecievedateselect" id="searchDoccreatedateselect" onchange="changeDate(this,'searchRecievedate');" class=inputstyle size=1 style=width:150>
									<option value="0"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
									<option value="1"><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage())%></option>
									<option value="2"><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage())%></option>
									<option value="3"><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage())%></option>
									<option value="4"><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage())%></option>
									<option value="5"><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage())%></option>
									<option value="6"><%=SystemEnv.getHtmlLabelName(17908, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19467, user.getLanguage())%></option>
								</select>
							 </span>
							 <span id="searchRecievedate" style="display:none;">
								<button type="button" class="calendar" id="SelectDate" onclick="getDate(searchRecievedatefromspan,searchRecievedatefrom)"></button>&nbsp;
								<span id="searchRecievedatefromspan"></span>
								  -&nbsp;&nbsp;<button type="button" class="calendar" id="SelectDate1" onclick="getDate(searchRecievedatetospan,searchRecievedateto)"></button>&nbsp;
								<span id="searchRecievedatetospan"></span>
							 </span>
							 <input type="hidden" name="searchRecievedatefrom" value="">
							 <input type="hidden" name="searchRecievedateto" value="">
							</td>
						</tr>
					</tbody>
					<tbody class="btn">
						<tr>
							<td style="text-align:center;padding:5px;" colspan="8" class="btnTd">
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>" class="e8_btn_submit" onclick="search()"/>
							<!--	<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage())%>" class="e8_btn_cancel" >-->
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" class="e8_btn_cancel" onclick="cancel()"/>
							</td>
						</tr>
					</tbody>
			</table>
		</div>
	</div>
	<input type="hidden" id="isdialog" name="isdialog" value="1"/>
	<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<%if(showDocTab_edit.equals("1")){%>
<div id="SignTabDoc" style="display:none">
    <table class=liststyle cellspacing=1  >
    <colgroup>
          <col width="20%"><col width="60%"> <col width="20%">
          <tbody>
          <tr class=HeaderForXtalbe>
            <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%></th>
          </tr>
          <tr>
              <td colspan="3"><img src="/images/loadingext_wev8.gif" alt=""/><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></td>
          </tr>
        </tbody>
    </table>
</div>
<%}%>
<%if(showWorkflowTab_edit.equals("1")){%>
<div id="SignTabWF" style="display:none">
    <table class=liststyle cellspacing=1  >
    <colgroup>
          <col width="10%"><col width="15%"> <col width="20%"><col width="40%"> <col width="15%">
          <tbody>
          <tr class=HeaderForXtalbe>
            <th><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(23753,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1335,user.getLanguage())%></th>
          </tr>
          <tr>
              <td colspan="5"><img src="/images/loadingext_wev8.gif" alt=""/><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></td>
          </tr>
        </tbody>
    </table>
</div>
<%}%>
<%if(showUploadTab_edit.equals("1")){%>
<div id="SignTabUpload" style="display:none">
    <table class=liststyle cellspacing=1  >
          <tbody>
          <tr class=HeaderForXtalbe>
            <th><%=SystemEnv.getHtmlLabelName(23752,user.getLanguage())%></th>
          </tr>
          <tr>
              <td><img src="/images/loadingext_wev8.gif" alt=""/><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></td>
          </tr>
        </tbody>
    </table>
</div>
<%
    }
%>
<script type="text/javascript">
var tabwfload=1;
var tabdocload=1;
var tabupload=1;
/*
function signtabchange(tabindex){
    if(tabindex==0){
        $GetEle("signid").style.display='';
        $GetEle("oTDtype_0").style.fontWeight="bold";
        $GetEle("oTDtype_0").background="url(/images/tab.active2_wev8.png) no-repeat";
        
        <%if(showDocTab_edit.equals("1")){%>
        $GetEle("SignTabDoc").style.display='none';
        $GetEle("oTDtype_1").style.fontWeight="normal";
        $GetEle("oTDtype_1").background="url(/images/tab2_wev8.png) no-repeat";
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        $GetEle("SignTabWF").style.display='none';
        $GetEle("oTDtype_2").style.fontWeight="normal";
        $GetEle("oTDtype_2").background="url(/images/tab2_wev8.png) no-repeat";
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        $GetEle("SignTabUpload").style.display='none';
        $GetEle("oTDtype_3").style.fontWeight="normal";
        $GetEle("oTDtype_3").background="url(/images/tab2_wev8.png) no-repeat";
        <%}%>
    }else if(tabindex==1){
        $GetEle("signid").style.display='none';
        $GetEle("oTDtype_0").style.fontWeight="normal";
        $GetEle("oTDtype_0").background="url(/images/tab2_wev8.png) no-repeat";
        <%if(showDocTab_edit.equals("1")){%>
        $GetEle("SignTabDoc").style.display='';
        $GetEle("oTDtype_1").style.fontWeight="bold";
        $GetEle("oTDtype_1").background="url(/images/tab.active2_wev8.png) no-repeat";
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        $GetEle("SignTabWF").style.display='none';
        $GetEle("oTDtype_2").style.fontWeight="normal";
        $GetEle("oTDtype_2").background="url(/images/tab2_wev8.png) no-repeat";
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        $GetEle("SignTabUpload").style.display='none';
        $GetEle("oTDtype_3").style.fontWeight="normal";
        $GetEle("oTDtype_3").background="url(/images/tab2_wev8.png) no-repeat";
        <%}%>
        if(tabdocload==1){
            loadsigndoc(<%=initrequestid%>,<%=workflowid%>,<%=user.getUID()%>,<%=user.getLanguage()%>);
        }
    }else if(tabindex==2){
        $GetEle("signid").style.display='none';
        $GetEle("oTDtype_0").style.fontWeight="normal";
        $GetEle("oTDtype_0").background="url(/images/tab2_wev8.png) no-repeat";
        <%if(showDocTab_edit.equals("1")){%>
        $GetEle("SignTabDoc").style.display='none';
        $GetEle("oTDtype_1").style.fontWeight="normal";
        $GetEle("oTDtype_1").background="url(/images/tab2_wev8.png) no-repeat";
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        $GetEle("SignTabWF").style.display='';
        $GetEle("oTDtype_2").style.fontWeight="bold";
        $GetEle("oTDtype_2").background="url(/images/tab.active2_wev8.png) no-repeat";
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        $GetEle("SignTabUpload").style.display='none';
        $GetEle("oTDtype_3").style.fontWeight="normal";
        $GetEle("oTDtype_3").background="url(/images/tab2_wev8.png) no-repeat";
        <%}%>
        if(tabwfload==1){
            loadsignwf(<%=initrequestid%>,<%=workflowid%>,<%=user.getUID()%>,<%=user.getLanguage()%>);
        }
    }else if(tabindex==3){
        $GetEle("signid").style.display='none';
        $GetEle("oTDtype_0").style.fontWeight="normal";
        $GetEle("oTDtype_0").background="url(/images/tab2_wev8.png) no-repeat";
        <%if(showDocTab_edit.equals("1")){%>
        $GetEle("SignTabDoc").style.display='none';
        $GetEle("oTDtype_1").style.fontWeight="normal";
        $GetEle("oTDtype_1").background="url(/images/tab2_wev8.png) no-repeat";
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        $GetEle("SignTabWF").style.display='none';
        $GetEle("oTDtype_2").style.fontWeight="normal";
        $GetEle("oTDtype_2").background="url(/images/tab2_wev8.png) no-repeat";
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        $GetEle("SignTabUpload").style.display='';
        $GetEle("oTDtype_3").style.fontWeight="bold";
        $GetEle("oTDtype_3").background="url(/images/tab.active2_wev8.png) no-repeat";
        <%}%>
        if(tabupload==1){
            loadsignupload(<%=initrequestid%>,<%=workflowid%>,<%=user.getUID()%>,<%=user.getLanguage()%>);
        }
    }
}*/
function signtabchanges(tabindex){
    if(tabindex==0){
        jQuery($GetEle("signall")).css("display", "");
		jQuery("#advancedSearch").css("display","");
        <%if(showDocTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabDoc")).css("display", "none");
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabWF")).css("display", "none");
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabUpload")).css("display", "none");
        <%}%>
		//与我相关
		jQuery("input[name='yuwoxiangguan']").val("");
		//搜索条件
		jQuery("input[name='caozuozhe']").val(jQuery("#searchOphrmid").val());//操作者

		jQuery("input[name='bumen']").val(jQuery("#searchOwnerdepartmentid").val());//部门
		jQuery("input[name='fenbu']").val(jQuery("#searchCreatersubcompanyid").val());//分部
		jQuery("input[name='yijian']").val(jQuery("input[name='searchContent']").val());//意见
		jQuery("input[name='jiedian']").val(jQuery("input[name='searchNodename']").val());//节点名称
		jQuery("input[name='caozuoriqi']").val(jQuery("#searchDoccreatedateselect").val());//操作日期
		jQuery("input[name='kaishishijian']").val(jQuery("input[name='searchRecievedatefrom']").val());	jQuery("input[name='jieshushijian']").val(jQuery("input[name='searchRecievedateto']").val());
		
		jQuery($GetEle("signid")).html("");

		flipOver(-1);
    }else if(tabindex==1){
        jQuery($GetEle("signall")).css("display", "none");
		jQuery("#advancedSearch").css("display","none");
		jQuery("#adserch").css("display","none");
        <%if(showDocTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabDoc")).css("display", "");
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabWF")).css("display", "none");
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabUpload")).css("display", "none");
        <%}%>
        if(tabdocload==1){
            loadsigndoc(<%=initrequestid%>,<%=workflowid%>,<%=user.getUID()%>,<%=user.getLanguage()%>);
        }
    }else if(tabindex==2){
        jQuery($GetEle("signall")).css("display", "none");
		jQuery("#advancedSearch").css("display","none");
		jQuery("#adserch").css("display","none");
        <%if(showDocTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabDoc")).css("display", "none");
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabWF")).css("display", "");
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabUpload")).css("display", "none");
        <%}%>
        if(tabwfload==1){
            loadsignwf(<%=initrequestid%>,<%=workflowid%>,<%=user.getUID()%>,<%=user.getLanguage()%>);
        }
    }else if(tabindex==3){
        jQuery($GetEle("signall")).css("display", "none");
		jQuery("#advancedSearch").css("display","none");
		jQuery("#adserch").css("display","none");
        <%if(showDocTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabDoc")).css("display", "none");
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabWF")).css("display", "none");
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabUpload")).css("display", "");
        <%}%>
        if(tabupload==1){
            loadsignupload(<%=initrequestid%>,<%=workflowid%>,<%=user.getUID()%>,<%=user.getLanguage()%>);
        }
    }else if(tabindex==4){
		jQuery($GetEle("signall")).css("display", "");
		jQuery("#advancedSearch").css("display","none");
		jQuery("#adserch").css("display","none");
        <%if(showDocTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabDoc")).css("display", "none");
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabWF")).css("display", "none");
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabUpload")).css("display", "none");
        <%}%>
		//与我相关
		jQuery("input[name='yuwoxiangguan']").val(<%=user.getUID()%>);
		//搜索条件
		jQuery("input[name='caozuozhe']").val("");//操作者

		jQuery("input[name='bumen']").val("");//部门
		jQuery("input[name='fenbu']").val("");//分部
		jQuery("input[name='yijian']").val("");//意见
		jQuery("input[name='jiedian']").val("");//节点名称
		jQuery("input[name='caozuoriqi']").val("");//操作日期
		jQuery("input[name='kaishishijian']").val("");	
		jQuery("input[name='jieshushijian']").val("");
	
		jQuery($GetEle("signid")).html("");

		flipOver(-1);
	}
}
function loadsigndoc(requestid,workflowid,userid,languageid){
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowSignDocAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    var parpstr="requestid="+requestid+"&workflowid="+workflowid+"&userid="+userid+"&languageid="+languageid;
    ajax.send(parpstr);
    //获取执行状态

    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里

        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                $GetEle("SignTabDoc").innerHTML=ajax.responseText;
                tabdocload=0;
            }catch(e){}
        }
    }
}
function loadsignwf(requestid,workflowid,userid,languageid){
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowSignWFAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    var parpstr="requestid="+requestid+"&workflowid="+workflowid+"&userid="+userid+"&languageid="+languageid;
    ajax.send(parpstr);
    //获取执行状态

    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里

        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                $GetEle("SignTabWF").innerHTML=ajax.responseText;
                tabwfload=0;
            }catch(e){}
        }
    }
}
function loadsignupload(requestid,workflowid,userid,languageid){
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowSignUploadAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    var parpstr="requestid="+requestid+"&workflowid="+workflowid+"&userid="+userid+"&languageid="+languageid;
    ajax.send(parpstr);
    //获取执行状态

    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里

        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                $GetEle("SignTabUpload").innerHTML=ajax.responseText;
                tabupload=0;
            }catch(e){}
        }
    }
}
</script>
<div id="signall">
<div id="signid">
        <table class=liststyle cellspacing=1  valign="top" style="margin:0;padding:0;" >
          <colgroup>
          <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
          <tbody>
  <!--        <tr class=HeaderForXtalbe>
            <th><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></th>
          </tr>
	-->	           <%
boolean isLight = false;
int nLogCount=0;

int tempRequestLogId=0;
int tempImageFileId=0;

/*--  xwj for td2104 on 20050802 B E G I N --*/
String viewLogIds = "";
ArrayList canViewIds = new ArrayList();
String viewNodeId = "-1";
String tempNodeId = "-1";
String singleViewLogIds = "-1";
char procflag=Util.getSeparator();
//RecordSetLog.executeSql("select distinct nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+user.getUID());

if(nodeid>0){
viewNodeId = ""+nodeid;
RecordSetLog1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
if(RecordSetLog1.next()){
singleViewLogIds = RecordSetLog1.getString("viewnodeids");
}

if("-1".equals(singleViewLogIds)){//全部查看
RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
while(RecordSetLog2.next()){
tempNodeId = RecordSetLog2.getString("nodeid");
if(!canViewIds.contains(tempNodeId)){
canViewIds.add(tempNodeId);
}
}
}
else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看

}
else{//查看部分
String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
for(int i=0;i<tempidstrs.length;i++){
if(!canViewIds.contains(tempidstrs[i])){
canViewIds.add(tempidstrs[i]);
}
}
}
}
if(canViewIds.size()>0){
for(int a=0;a<canViewIds.size();a++)
{
viewLogIds += (String)canViewIds.get(a) + ",";
}
viewLogIds = viewLogIds.substring(0,viewLogIds.length()-1);
}
else{
viewLogIds = "-1";
}
//RecordSet.executeProc("workflow_RequestLog_SNSave",""+requestid + procflag + "17,18");

/*----added by xwj for td2891 begin-----*/
//工作流id已经从页面获得到了，不需要从数据库中取，屏蔽掉。 mackjoe at 2006-06-12 td4491
/*
String tempWorkflowid = "-1";
String  sqlTemp ="select workflowid from workflow_requestbase where requestid ="+requestid;
RecordSet.executeSql(sqlTemp);
RecordSet.next();
tempWorkflowid = RecordSet.getString("workflowid");
*/
String sqlTemp = "select nodeid from workflow_flownode where workflowid = "+workflowid+" and nodetype = '0'";
RecordSet.executeSql(sqlTemp);
RecordSet.next();
String creatorNodeId = RecordSet.getString("nodeid");
/*----added by xwj for td2891 end-----*/
/*----added by chujun for td8883 start ----*/
WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String orderbytype = Util.null2String(WFManager.getOrderbytype());
String orderby = "desc";
String imgline="<img src=\"/images/xp/L_wev8.png\">";
if("2".equals(orderbytype)){
	orderby = "asc";
    imgline="<img src=\"/images/xp/L1_wev8.png\">";
}

/*----added by chujun for td8883 end ----*/
WFLinkInfo.setRequest(request);
ArrayList log_loglist=new ArrayList();

String lineNTdTwo="";
int log_branchenodeid=0;
String log_tempvalue="";
for(int i=0;i<log_loglist.size();i++)
{
    Hashtable htlog=(Hashtable)log_loglist.get(i);
    int log_isbranche=Util.getIntValue((String)htlog.get("isbranche"),0);
    int log_nodeid=Util.getIntValue((String)htlog.get("nodeid"),0);
    int log_nodeattribute=Util.getIntValue((String)htlog.get("nodeattribute"),0);
    String log_nodename=Util.null2String((String)htlog.get("nodename"));
    int log_destnodeid=Util.getIntValue((String)htlog.get("destnodeid"));
    String log_remark=Util.null2String((String)htlog.get("remark"));
    String log_operatortype=Util.null2String((String)htlog.get("operatortype"));
    String log_operator=Util.null2String((String)htlog.get("operator"));
    String log_agenttype=Util.null2String((String)htlog.get("agenttype"));
    String log_agentorbyagentid=Util.null2String((String)htlog.get("agentorbyagentid"));
    String log_operatedate=Util.null2String((String)htlog.get("operatedate"));
    String log_operatetime=Util.null2String((String)htlog.get("operatetime"));
    String log_logtype=Util.null2String((String)htlog.get("logtype"));
    String log_receivedPersons=Util.null2String((String)htlog.get("receivedPersons"));
    tempRequestLogId=Util.getIntValue((String)htlog.get("logid"),0);
    String log_annexdocids=Util.null2String((String)htlog.get("annexdocids"));
    String log_operatorDept=Util.null2String((String)htlog.get("operatorDept"));
    String log_signdocids=Util.null2String((String)htlog.get("signdocids"));
    String log_signworkflowids=Util.null2String((String)htlog.get("signworkflowids"));

    String log_nodeimg="";
    if(log_tempvalue.equals(log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime)){
        log_branchenodeid=0;
    }else{
        log_tempvalue=log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime;
    }
    if(log_nodeattribute==1&&(log_logtype.equals("0")||log_logtype.equals("2"))&&log_branchenodeid==0){
        log_nodeimg=imgline;
        log_branchenodeid=log_nodeid;
    }
    if(log_isbranche==1){
        log_nodeimg="<img src=\"/images/xp/T_wev8.png\">";
        log_branchenodeid=0;
    }
	nLogCount++;

	tempImageFileId=0;
	if(tempRequestLogId>0){
		RecordSetlog3.executeSql("select imageFileId from Workflow_FormSignRemark where requestLogId="+tempRequestLogId);
		if(RecordSetlog3.next()){
			tempImageFileId=Util.getIntValue(RecordSetlog3.getString("imageFileId"),0);
		}
	}

    if(log_isbranche==0&&"2".equals(orderbytype)) isLight = !isLight;
if (nLogCount==3) {
%>
<!--
</tbody></table>
<div  id=WorkFlowDiv style="display:''"><%--xwj for td2104 on 2005-05-18--%>
    <table class=liststyle cellspacing=1  >
    <colgroup>
     <%--Modefied by xwj for td2104 on 2005-08-01--%>
          <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
    <tbody>
	-->
<%}%>
    <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark <%}%>>
            <td><%=log_nodeimg%><%=Util.toScreen(log_nodename,user.getLanguage())%></td>
            <!--xwj for td2104 20050825 begin 格式更改-->
              <td width=40%>
							<table width=100%>
						    <tr> 
              <td colspan="3">
            	<%if(!log_logtype.equals("t")){%>
<%if(tempRequestLogId>0&&tempImageFileId>0){%>

		<jsp:include page="/workflow/request/WorkflowLoadSignatureRequestLogId.jsp">
			<jsp:param name="tempRequestLogId" value="<%=tempRequestLogId%>" />
		</jsp:include>

<%}else{
								String tempremark = log_remark;
								tempremark = Util.StringReplace(tempremark,"&lt;br&gt;","<br>");
              %>
             <%=Util.StringReplace(tempremark,"&nbsp;"," ")%>
<%}%>
             <%}
            if(!log_annexdocids.equals("")||!log_signdocids.equals("")||!log_signworkflowids.equals("")){
                %>
           <br/>
             <table width="70%">
                 <tr height="1"><td><td style="border:1px dotted #000000;border-top-color:#ffffff;border-left-color:#ffffff;border-right-color:#ffffff;height:1px">&nbsp;</td></tr>
             </table>
          <table>
          <tbody >
           <%
            String signhead="";
            if(!log_signdocids.equals("")){
            RecordSetlog3.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+log_signdocids+") order by id asc");
            int linknum=-1;
            while(RecordSetlog3.next()){
              linknum++;
              if(linknum==0){
                  signhead=SystemEnv.getHtmlLabelName(857,user.getLanguage())+":";
              }else{
                  signhead="&nbsp;";
              }
              String showid = Util.null2String(RecordSetlog3.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSetlog3.getString(2),user.getLanguage()) ;
              %>

          <tr>
            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
            <td >
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp;
            </td>
          </tr><%}
           }
            ArrayList tempwflists=Util.TokenizerString(log_signworkflowids,",");
            int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
            for(int k=0;k<tempwflists.size();k++){
              if(k==0){
                  signhead=SystemEnv.getHtmlLabelName(1044,user.getLanguage())+":";
              }else{
                  signhead="&nbsp;";
              }
                tempnum++;
                session.setAttribute("resrequestid" + tempnum, "" + tempwflists.get(k));
              String temprequestname="<a style=\"cursor:pointer\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+tempwflists.get(k)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)tempwflists.get(k))+"</a>";
              %>

          <tr>
            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
            <td><%=temprequestname%></td>
          </tr>
              <%
            }
            session.setAttribute("slinkwfnum", "" + tempnum);
            session.setAttribute("haslinkworkflow", "1");
            if(!log_annexdocids.equals("")){
            RecordSetlog3.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+log_annexdocids+") order by id asc");
            int linknum=-1;
            while(RecordSetlog3.next()){
              linknum++;
              if(linknum==0){
                  signhead=SystemEnv.getHtmlLabelName(22194,user.getLanguage())+":";
              }else{
                  signhead="&nbsp;";
              }
              String showid = Util.null2String(RecordSetlog3.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSetlog3.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSetlog3.getInt(3);
              String SecCategory=Util.null2String(RecordSetlog3.getString(4));
              DocImageManager.resetParameter();
              DocImageManager.setDocid(Util.getIntValue(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefilename = "";
              String fileExtendName = "";
              String docImagefileid = "";
              int versionId = 0;
              long docImagefileSize = 0;
              if(DocImageManager.next()){
                //DocImageManager会得到doc第一个附件的最新版本

                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }
              String imgSrc= AttachFileUtil.getImgStrbyExtendName(fileExtendName,16);
              boolean nodownload=SecCategoryComInfo1.getNoDownload(SecCategory).equals("1")?true:false;
              %>

          <tr>
            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
            <td >
              <%=imgSrc%>
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp
              <%}
                  if(accessoryCount==1 && ((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){
                %>
              <button type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>'">
                    <U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	(<%=docImagefileSize/1000%>K)
                  </BUTTON>
                <%}%>
            </td>
          </tr>
              <%}}%>
          </tbody>
          </table>
                <%}%>
             </td>
             </tr>
              <tr>
            <td align=right>
               <%-- xwj for td2104 on 20050802 begin--%>
            <%
                BaseBean wfsbean=FieldInfo.getWfsbean();
                int showimg = Util.getIntValue(wfsbean.getPropValue("WFSignatureImg","showimg"),0);
                rssign.execute("select * from DocSignature  where hrmresid=" + log_operator + "order by markid");
                String userimg = "";
                if (showimg == 1 && rssign.next()) {
                    // 获取签章图片并显示

                    String markpath = Util.null2String(rssign.getString("markpath"));
                    if (!markpath.equals("")) {
                        userimg = "/weaver/weaver.file.ImgFileDownload?userid=" + log_operator;
                    }
                }
                if(!userimg.equals("") && "0".equals(log_operatortype)){
			%>
			<img id=markImg src="<%=userimg%>" ></img>
			<%
			}
			else
			 {
                if(isOldWf_)
            {
               if(log_operatortype.equals("0")){%>
			   <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
	            <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'>
              <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>

              <%}else if(log_operatortype.equals("1")){%>
	           <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=log_operator%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),user.getLanguage())%></a>
              <%}else{%>
             <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
             <%}
           }
            else
            {
                  if(log_operatortype.equals("0")){
                if(!log_agenttype.equals("2")){%>
				<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
	               <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                  <%}
                    /*----------added by xwj for td2891 begin----------- */
                else if(log_agenttype.equals("2")){
                   
                   if(!(""+log_nodeid).equals(creatorNodeId) || ((""+log_nodeid).equals(creatorNodeId) && !WFLinkInfo.isCreateOpt(tempRequestLogId,requestid))){//非创建节点log,必须体现代理关系%>
                   <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),user.getLanguage())+SystemEnv.getHtmlLabelName(24214,user.getLanguage())%></a>
                    ->
					<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())+SystemEnv.getHtmlLabelName(24213,user.getLanguage())%></a>
                   
                   <%}
                   else{//创造节点log, 如果设置代理时选中了代理流程创建,同时代理人本身对该流程就具有创建权限,那么该代理人创建节点的log不体现代理关系

                   String agentCheckSql = " select * from workflow_Agent where workflowId="+ workflowid +" and beagenterId=" + log_agentorbyagentid +
													 " and agenttype = '1' " +
													 " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" +
													 " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
													 " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" +
													 " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" +
													 " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
													 " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null)";
                  RecordSetlog3.executeSql(agentCheckSql);
                  if(!RecordSetlog3.next()){%>
				  <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                      <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                  <%}
                  else{
                  String isCreator = RecordSetlog3.getString("isCreateAgenter");
                  
                  if(!isCreator.equals("1")){%>
				  <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                  <%}
                  else{
                   int userLevelUp = -1;
                   int uesrLevelTo = -1;
                   int secLevel = -1;
                   rsCheckUserCreater.executeSql("select seclevel from HrmResource where id= " + log_operator);
                   if(rsCheckUserCreater.next()){
                   secLevel = rsCheckUserCreater.getInt("seclevel");
                   }
                   else{
                   rsCheckUserCreater.executeSql("select seclevel from HrmResourceManager where id= " + log_operator);
                   if(rsCheckUserCreater.next()){
                   secLevel = rsCheckUserCreater.getInt("seclevel");
                   }
                   }
                   
                   //是否有此流程的创建权限

                   boolean haswfcreate = new weaver.share.ShareManager().hasWfCreatePermission(user, workflowid);
                   if(haswfcreate){%>
				   <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                   <%}
                  else{%>
				  <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),user.getLanguage())%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),user.getLanguage())+SystemEnv.getHtmlLabelName(24214,user.getLanguage())%></a>
                    ->
					<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())+SystemEnv.getHtmlLabelName(24213,user.getLanguage())%></a>
                 
                  <%} 
                  }
                  
                  }
                }
                }
                /*----------added by xwj for td2891 end----------- */
                 else{
                 }
            }
                else if(log_operatortype.equals("1")){%>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=log_operator%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),user.getLanguage())%></a>
<%}else{%>
<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
<%}
            
            }}%>


        <%-- xwj for td2104 on 20050802 end--%>
            
            </td>
            </tr>
            <tr>
            <td align=right><%=Util.toScreen(log_operatedate,user.getLanguage())%>
              &nbsp<%=Util.toScreen(log_operatetime,user.getLanguage())%></td>
                  </tr>
            </table>
<!--xwj for td2104 20050825-->
            <td>
              <%
	String logtype = log_logtype;
	String operationname = RequestLogOperateName.getOperateName(""+workflowid,""+requestid,""+log_nodeid,logtype,log_operator,user.getLanguage(),log_operatedate,log_operatetime);
	%>
	<%=operationname%>
<%
lineNTdTwo="line"+String.valueOf(nLogCount)+"TdTwo"+Util.getRandom();
%>
            </td>

                  <%--added by xwj for td2104 on 2005-8-1--%>
          <td id="<%=lineNTdTwo%>">
              <%
                String tempStr ="";
                if(log_receivedPersons.length()>0) tempStr = Util.toScreen(log_receivedPersons.substring(0,log_receivedPersons.length()-1),user.getLanguage());
				  String showoperators="";
				try
				{
				showoperators=RequestDefaultComInfo.getShowoperator(""+user.getUID());
				}
				catch (Exception eshows)
				{}
                if (!showoperators.equals("1")) {
                if(!"".equals(tempStr) && tempStr != null){
                	tempStr = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick=showallreceivedforsign('"+requestid+"','"+log_nodeid+"','"+log_operator+"','"+log_operatedate+
                                "','"+log_operatetime+"','"+lineNTdTwo+"','"+logtype+"',"+log_destnodeid+") >"+SystemEnv.getHtmlLabelName(89, user.getLanguage())+"</span>";
                }
				}
              %>
              <%=tempStr%>
          </td>
          
          
          </tr>

        <%-- 该段代码已被屏蔽，现删除 --%>


          <%
	if(log_isbranche==0&&!"2".equals(orderbytype)) isLight = !isLight;
}
%>
</tbody>
	</table>
<div style="width:100%;margin:0;padding:0;" id="requestlogappednDiv">
</div>
<div id='WorkFlowLoddingDiv_<%=requestid %>' style="display:none;text-align:center;width:100%;height:18px;overflow:hidden;">
	<img src="/images/loading2_wev8.gif" style="vertical-align: middle;">&nbsp;<span style="vertical-align: middle;line-height:100%;"><%=SystemEnv.getHtmlLabelName(19205, user.getLanguage())%></span>
</div>

<%
//-----------------------------------
// 预留流程签字意见每次加载条数 START
//-----------------------------------
int wfsignlddtcnt = 14;
//-----------------------------------
// 预留流程签字意见每次加载条数 END
//-----------------------------------
%>

<input type="hidden" id="requestLogDataIsEnd<%=requestid %>" value="0">
<input type="hidden" id="requestLogDataMaxRquestLogId" value="0">

<script language="javascript">
	var pgnumber = 2;
	var sucNm = true;
	var currentPageCnt = <%=wfsignlddtcnt%>;
	var requestLogDataMaxRquestLogId = "0";
	
	function primaryWfLogLoadding() {
	/**	if (pgnumber != -1 && sucNm && jQuery("#requestLogDataIsEnd<%=requestid %>").val() != "1" && currentPageCnt >= <%=wfsignlddtcnt%>) {
			sucNm = false;
			showAllSignLog2('<%=workflowid %>','<%=requestid %>','<%=viewLogIds %>','<%=orderby %>', pgnumber, "signTbl", "requestLogDataIsEnd<%=requestid %>", "WorkFlowLoddingDiv_<%=requestid %>", requestLogDataMaxRquestLogId);
			
			if (jQuery("#requestLogDataIsEnd<%=requestid %>").val() != "1") {
				pgnumber++;
			} else {
				sucNm = false
				pgnumber = -1;
			}
		}**/
		flipOver(-1);
	}
	//高级搜索提交
	function search(){
				
		jQuery("input[name='caozuozhe']").val(jQuery("#searchOphrmid").val());//操作者

		jQuery("input[name='bumen']").val(jQuery("#searchOwnerdepartmentid").val());//部门
		jQuery("input[name='fenbu']").val(jQuery("#searchCreatersubcompanyid").val());//分部
		jQuery("input[name='yijian']").val(jQuery("input[name='searchContent']").val());//意见
		jQuery("input[name='jiedian']").val(jQuery("input[name='searchNodename']").val());//节点名称
		jQuery("input[name='caozuoriqi']").val(jQuery("#searchDoccreatedateselect").val());//操作日期
		jQuery("input[name='kaishishijian']").val(jQuery("input[name='searchRecievedatefrom']").val());	jQuery("input[name='jieshushijian']").val(jQuery("input[name='searchRecievedateto']").val());

		var prePage=1;
		requestLogDataMaxRquestLogId=0;

		showAllSignLog3('<%=workflowid %>','<%=requestid %>','<%=viewLogIds %>','<%=orderby %>', prePage, "signTbl", "requestLogDataIsEnd<%=requestid %>", "WorkFlowLoddingDiv_<%=requestid %>", requestLogDataMaxRquestLogId);
		
	}
	function flipOver(sign){
		//console.log("requestLogDataMaxRquestLogId:"+requestLogDataMaxRquestLogId);
		var prePage=jQuery("#prePage").val();
		var allPages=jQuery("#allPages").val();
		if (sign==-1){
			//初始加载
			prePage=1;
			requestLogDataMaxRquestLogId=0;
		}else if(sign==0){
			//首页
			if(prePage<=1){
				return;
			}else{
				prePage=1;
				requestLogDataMaxRquestLogId=0;
			}
		}else if(sign==1){
			//上一页

			if(prePage<=1){
				return;
			}else{
				prePage--;
				requestLogDataMaxRquestLogId=jQuery("#pageMaxRquestLogId").val();
			}
		}else if(sign==2){
			//下一页

			if(prePage>=allPages||allPages<=1){
				return;
			}else{
				prePage++;
				jQuery("#pageMaxRquestLogId").val(requestLogDataMaxRquestLogId);
			}
		}else if(sign==3){
			//尾页
			if(prePage>=allPages||allPages<=1){
				return;
			}else{
				prePage=allPages;
			}
		}else if(sign==4){
			//跳转
			var page=jQuery("input[name='jump']").val();
			if(page==""||page.length==0){
				return;
			}else if(isNaN(page)){	
				return;
			}else if(page<0||page>allPages){
				return ;	
			}else {
				prePage=page;
			}
		}

		showAllSignLog3('<%=workflowid %>','<%=requestid %>','<%=viewLogIds %>','<%=orderby %>', prePage, "signTbl", "requestLogDataIsEnd<%=requestid %>", "WorkFlowLoddingDiv_<%=requestid %>");
	}
</script>
</div>
<!-- signid 结束-->
<%	
	//获取流转意见的总信息条数

	int totalCount=WFLinkInfo.getRequestLogTotalCount(requestid,workflowid,viewLogIds,"");
	int currentPageCount=wfsignlddtcnt;//每页展示条数
	int totalPages=(totalCount+currentPageCount-1)/currentPageCount;//总共页数
	if(totalPages==0){
		totalPages=1;
	}
	int currentPageSize=1;//当前页码
%>
<script language="javascript">
	//与我相关的记录条数

	jQuery("#oTDtype_4").append("("+<%=WFLinkInfo.getRequestLogTotalCount(requestid,workflowid,viewLogIds," and t1.remark like '%atsome=\"@"+user.getUID()+"\"%'")%>+")");
</script>
<input type="hidden" id="allItems" value="<%=totalCount%>"><!--总信息数-->
<input type="hidden" id="perItem" value="<%=currentPageCount%>"><!--每页条数-->
<input type="hidden" id="allPages" value="<%=totalPages%>"><!--总共页数-->
<input type="hidden" id="prePage" value="<%=currentPageSize%>"><!--当前页码-->
<input type="hidden" id="pageMaxRquestLogId" value="0"><!--日志预留最大id值-->

<!--提交的高级搜素条件-->
<input type="hidden" name="caozuozhe"/>
<input type="hidden" name="bumen"/>
<input type="hidden" name="fenbu"/>
<input type="hidden" name="yijian"/>
<input type="hidden" name="jiedian"/>
<input type="hidden" name="caozuoriqi"/>
<input type="hidden" name="kaishishijian"/>
<input type="hidden" name="jieshushijian"/>
<!--@me-->
<input type="hidden" name="yuwoxiangguan"/>


<div style="float:right;margin-right:15px;margin-top:10px;"> <!--<%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><font class="allItems"><%=totalCount%></font><%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(264,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=currentPageCount%><%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>-->
<%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><font class="allPages"><%=totalPages%></font><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><font class="prePage"><%=currentPageSize%></font><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%> <a <%if(currentPageSize>1){%> class="signpage"<%}%> href="javascript:flipOver(0)" name="shouye" ><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%></a> <a <%if(currentPageSize>1){%> class="signpage" <%}%> href="javascript:flipOver(1)" name="shangyiye"><%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></a> <a <%if(currentPageSize<totalPages){%> class="signpage" <%}%> href="javascript:flipOver(2)" name="xiayiye" ><%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></a> <a <%if(currentPageSize<totalPages){%> class="signpage" <%}%> href="javascript:flipOver(3)" name="weiye" ><%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%></a> <a class="signpage"  href="javascript:flipOver(4)"><%=SystemEnv.getHtmlLabelName(23162,user.getLanguage())%></a><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><input type="text" name="jump" style="width:30px;height:20px;"/><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%></div>

</div>

<%
  
  for(int i=0;i<allrequestid.size();i++)  
  {              
        int languageidfromrequest = user.getLanguage();
        String temp = allrequestid.get(i).toString();
        int tempindex = temp.indexOf(".");
        requestid = Util.getIntValue(temp.substring(0,tempindex),0);        
        temp = temp.substring(tempindex);        
        String workflow_name = "";
        if(temp.equals(".main")){
            workflow_name = SystemEnv.getHtmlLabelName(21254,languageidfromrequest);
            workflow_name +=" "+allrequestname.get(i).toString();
            workflow_name +=" "+SystemEnv.getHtmlLabelName(504,languageidfromrequest)+":";
        }else if(temp.equals(".sub")){
        	workflow_name = SystemEnv.getHtmlLabelName(19344,languageidfromrequest);
        	workflow_name +=" "+allrequestname.get(i).toString();
            workflow_name +=" "+SystemEnv.getHtmlLabelName(504,languageidfromrequest)+":";
            workflow_name +=" "+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&isovertime=0')>"+SystemEnv.getHtmlLabelName(367,languageidfromrequest)+SystemEnv.getHtmlLabelName(19344,languageidfromrequest);
            workflow_name +=" "+allrequestname.get(i).toString()+"</a>";
        }else if(temp.equals(".parallel")){ 
        	workflow_name = SystemEnv.getHtmlLabelName(21255,languageidfromrequest);
            workflow_name +=" "+allrequestname.get(i).toString();
            workflow_name +=" "+SystemEnv.getHtmlLabelName(504,languageidfromrequest)+":";
            workflow_name +=" "+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&isovertime=0')>"+SystemEnv.getHtmlLabelName(367,languageidfromrequest)+SystemEnv.getHtmlLabelName(21255,languageidfromrequest);
            workflow_name +=" "+allrequestname.get(i).toString()+"</a>";
        }

        viewLogIds = "";
        rssign.executeSql("select nodeid from workflow_requestlog where requestid = "+requestid);
        while(rssign.next()){
          viewLogIds += rssign.getString("nodeid")+",";
        }
        viewLogIds +="-1";
        int tempworkflowid=0;
        rssign.executeSql("select * from workflow_requestbase where requestid = "+ requestid);
        if(rssign.next()){
             tempworkflowid = rssign.getInt("workflowid");
          }
        log_loglist=WFLinkInfo.getRequestLog(requestid,tempworkflowid,viewLogIds,orderby);
%>
<div id=WorkFlowDiv style="display:''">
    <table class=liststyle cellspacing=1   id="mainWFHead">
    	<colgroup>
        <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
    	<tbody id="WorkFlowDiv_TBL">
          <tr class="header">           
             <th colspan = 4><%=workflow_name%></th>
   		    </tr>
          <tr class=Header id="headTitle">			
            <th><%=SystemEnv.getHtmlLabelName(15586,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(504,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(104,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(15525,languageidfromrequest)%></th>
          </tr>

<%
for(int j=0;j<log_loglist.size();j++)
{
    Hashtable htlog=(Hashtable)log_loglist.get(j);
    int log_isbranche=Util.getIntValue((String)htlog.get("isbranche"),0);
    int log_nodeid=Util.getIntValue((String)htlog.get("nodeid"),0);
    int log_nodeattribute=Util.getIntValue((String)htlog.get("nodeattribute"),0);
    String log_nodename=Util.null2String((String)htlog.get("nodename"));
    int log_destnodeid=Util.getIntValue((String)htlog.get("destnodeid"));
    String log_remark=Util.null2String((String)htlog.get("remark"));
    String log_operatortype=Util.null2String((String)htlog.get("operatortype"));
    String log_operator=Util.null2String((String)htlog.get("operator"));
    String log_agenttype=Util.null2String((String)htlog.get("agenttype"));
    String log_agentorbyagentid=Util.null2String((String)htlog.get("agentorbyagentid"));
    String log_operatedate=Util.null2String((String)htlog.get("operatedate"));
    String log_operatetime=Util.null2String((String)htlog.get("operatetime"));
    String log_logtype=Util.null2String((String)htlog.get("logtype"));
    String log_receivedPersons=Util.null2String((String)htlog.get("receivedPersons"));
    tempRequestLogId=Util.getIntValue((String)htlog.get("logid"),0);
    String log_annexdocids=Util.null2String((String)htlog.get("annexdocids"));
    String log_operatorDept=Util.null2String((String)htlog.get("operatorDept"));
    String log_signdocids=Util.null2String((String)htlog.get("signdocids"));
    String log_signworkflowids=Util.null2String((String)htlog.get("signworkflowids"));

    String log_nodeimg="";
    if(log_tempvalue.equals(log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime)){
        log_branchenodeid=0;
    }else{
        log_tempvalue=log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime;
    }
    if(log_nodeattribute==1&&(log_logtype.equals("0")||log_logtype.equals("2"))&&log_branchenodeid==0){
        log_branchenodeid=log_nodeid;
        log_nodeimg=imgline;
    }
    if(log_isbranche==1){
        log_nodeimg="<img src=\"/images/xp/T_wev8.png\">";
        log_branchenodeid=0;
    }
	nLogCount++;

	tempImageFileId=0;
	if(tempRequestLogId>0){
		RecordSetlog3.executeSql("select imageFileId from Workflow_FormSignRemark where requestLogId="+tempRequestLogId);
		if(RecordSetlog3.next()){
			tempImageFileId=Util.getIntValue(RecordSetlog3.getString("imageFileId"),0);
		}
	}

    if(log_isbranche==0&&"2".equals(orderbytype)) isLight = !isLight;
if (nLogCount==3) {
%>
<!--
</tbody></table>
<div  id=WorkFlowDiv style="display:''"><%--xwj for td2104 on 2005-05-18--%>
    <table class=liststyle cellspacing=1  >
    <colgroup>
          <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
    <tbody>
	-->
<%}%>
    <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark <%}%>>
            <td><%=log_nodeimg%><%=Util.toScreen(log_nodename,languageidfromrequest)%></td>
            <!--xwj for td2104 20050825 begin 格式更改-->
              <td width=40%>
							<table width=100%>
						    <tr> 
              <td colspan="3">
<%if(tempRequestLogId>0&&tempImageFileId>0){%>

		<jsp:include page="/workflow/request/WorkflowLoadSignatureRequestLogId.jsp">
			<jsp:param name="tempRequestLogId" value="<%=tempRequestLogId%>" />
		</jsp:include>

<%}else{
								String tempremark = log_remark;
								tempremark = Util.StringReplace(tempremark,"&lt;br&gt;","<br>");
              %>
             <%=Util.StringReplace(tempremark,"&nbsp;"," ")%>
<%}%>
             <%
            if(!log_annexdocids.equals("")||!log_signdocids.equals("")||!log_signworkflowids.equals("")){
             %>   <br/>
             <table width="70%">
                 <tr height="1"><td><td style="border:1px dotted #000000;border-top-color:#ffffff;border-left-color:#ffffff;border-right-color:#ffffff;height:1px">&nbsp;</td></tr>
             </table>
             <table>
          <tbody >
           <%
            String signhead="";
            if(!log_signdocids.equals("")){
            RecordSetlog3.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+log_signdocids+") order by id asc");
            int linknum=-1;
            while(RecordSetlog3.next()){
              linknum++;
              if(linknum==0){
                  signhead=SystemEnv.getHtmlLabelName(857,user.getLanguage())+":";
              }else{
                  signhead="&nbsp;";
              }
              String showid = Util.null2String(RecordSetlog3.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSetlog3.getString(2),user.getLanguage()) ;
              %>

          <tr>
            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
            <td >
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp;
            </td>
          </tr><%}
           }
           int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
            ArrayList tempwflists=Util.TokenizerString(log_signworkflowids,",");
            for(int k=0;k<tempwflists.size();k++){
              if(k==0){
                  signhead=SystemEnv.getHtmlLabelName(1044,user.getLanguage())+":";
              }else{
                  signhead="&nbsp;";
              }
                tempnum++;
                session.setAttribute("resrequestid" + tempnum, "" + tempwflists.get(k));
              String temprequestname="<a style=\"cursor:pointer\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+tempwflists.get(k)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)tempwflists.get(k))+"</a>";
              %>

          <tr>
            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
            <td><%=temprequestname%></td>
          </tr>
              <%
            }
            session.setAttribute("slinkwfnum", "" + tempnum);
            session.setAttribute("haslinkworkflow", "1");
            if(!log_annexdocids.equals("")){
            RecordSetlog3.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+log_annexdocids+") order by id asc");
            int linknum=-1;
            while(RecordSetlog3.next()){
              linknum++;
              if(linknum==0){
                  signhead=SystemEnv.getHtmlLabelName(22194,user.getLanguage())+":";
              }else{
                  signhead="&nbsp;";
              }
              String showid = Util.null2String(RecordSetlog3.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSetlog3.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSetlog3.getInt(3);
              String SecCategory=Util.null2String(RecordSetlog3.getString(4));
              DocImageManager.resetParameter();
              DocImageManager.setDocid(Util.getIntValue(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefilename = "";
              String fileExtendName = "";
              String docImagefileid = "";
              int versionId = 0;
              long docImagefileSize = 0;
              if(DocImageManager.next()){
                //DocImageManager会得到doc第一个附件的最新版本

                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));  
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }
              String imgSrc= AttachFileUtil.getImgStrbyExtendName(fileExtendName,16);
              boolean nodownload=SecCategoryComInfo1.getNoDownload(SecCategory).equals("1")?true:false;
              %>

          <tr>
            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
            <td >
              <%=imgSrc%>
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp
              <%}
              if(accessoryCount==1 && ((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){
              %>
              <button type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>'">
                    <U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	(<%=docImagefileSize/1000%>K)
                  </BUTTON>
              <%}%>
            </td>
          </tr><%}}%>
          </tbody>
          </table><%}%>
             </td>
             </tr>
              <tr>
            <td align=right>
               <%-- xwj for td2104 on 20050802 begin--%>
            <%
                BaseBean wfsbean=FieldInfo.getWfsbean();
                int showimg = Util.getIntValue(wfsbean.getPropValue("WFSignatureImg","showimg"),0);
                rssign.execute("select * from DocSignature  where hrmresid=" + log_operator + "order by markid");
                String userimg = "";
                if (showimg == 1 && rssign.next()) {
                    // 获取签章图片并显示

                    String markpath = Util.null2String(rssign.getString("markpath"));
                    if (!markpath.equals("")) {
                        userimg = "/weaver/weaver.file.ImgFileDownload?userid=" + log_operator;
                    }
                }
                if(!userimg.equals("") && "0".equals(log_operatortype)){
			%>
			<img id=markImg src="<%=userimg%>" ></img>
			<%
			}
			else
			 {
                if(isOldWf_)
            {
               if(log_operatortype.equals("0")){%>
			   <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
	            <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'>
              <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>

              <%}else if(log_operatortype.equals("1")){%>
	           <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=log_operator%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),user.getLanguage())%></a>
              <%}else{%>
             <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
             <%}
           }
            else
            {
                  if(log_operatortype.equals("0")){
                if(!log_agenttype.equals("2")){%>
				<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
	               <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                  <%}
                    /*----------added by xwj for td2891 begin----------- */
                else if(log_agenttype.equals("2")){
                   
                   if(!(""+log_nodeid).equals(creatorNodeId) || ((""+log_nodeid).equals(creatorNodeId) && !WFLinkInfo.isCreateOpt(tempRequestLogId,requestid))){//非创建节点log,必须体现代理关系%>
                   <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),user.getLanguage())+SystemEnv.getHtmlLabelName(24214,user.getLanguage())%></a>
                    -> 
					<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())+SystemEnv.getHtmlLabelName(24213,user.getLanguage())%></a>
                   
                   <%}
                   else{//创造节点log, 如果设置代理时选中了代理流程创建,同时代理人本身对该流程就具有创建权限,那么该代理人创建节点的log不体现代理关系

                   String agentCheckSql = " select * from workflow_Agent where workflowId="+ tempworkflowid +" and beagenterId=" + log_agentorbyagentid +
													 " and agenttype = '1' " +
													 " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" +
													 " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
													 " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" +
													 " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" +
													 " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
													 " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null)";
                  RecordSetlog3.executeSql(agentCheckSql);
                  if(!RecordSetlog3.next()){%>
				  <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                      <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                  <%}
                  else{
                  String isCreator = RecordSetlog3.getString("isCreateAgenter");
                  
                  if(!isCreator.equals("1")){%>
				  <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                  <%}
                  else{
                   int userLevelUp = -1;
                   int uesrLevelTo = -1;
                   int secLevel = -1;
                   rsCheckUserCreater.executeSql("select seclevel from HrmResource where id= " + log_operator);
                   if(rsCheckUserCreater.next()){
                   secLevel = rsCheckUserCreater.getInt("seclevel");
                   }
                   else{
                   rsCheckUserCreater.executeSql("select seclevel from HrmResourceManager where id= " + log_operator);
                   if(rsCheckUserCreater.next()){
                   secLevel = rsCheckUserCreater.getInt("seclevel");
                   }
                   }
                   
                 //是否有此流程的创建权限

                   boolean haswfcreate = new weaver.share.ShareManager().hasWfCreatePermission(user, workflowid);
                   if(haswfcreate){%>
                    <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                   <%}
                 else{%>
                    <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),user.getLanguage())%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),user.getLanguage())+SystemEnv.getHtmlLabelName(24214,user.getLanguage())%></a>
                    -> 
                    <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfoTemp.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())+SystemEnv.getHtmlLabelName(24213,user.getLanguage())%></a>
                 
                  <%} 
                  }
                  
                  }
                }
                }
                /*----------added by xwj for td2891 end----------- */
                 else{
                 }
            }
                else if(log_operatortype.equals("1")){%>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=log_operator%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),user.getLanguage())%></a>
<%}else{%>
<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
<%}
            
            }}%>


        <%-- xwj for td2104 on 20050802 end--%>
            
            </td>
            </tr>
            <tr>
            <td align=right><%=Util.toScreen(log_operatedate,user.getLanguage())%>
              &nbsp<%=Util.toScreen(log_operatetime,user.getLanguage())%></td>
                  </tr>
            </table>
<!--xwj for td2104 20050825-->
            <td>
              <%
	String logtype = log_logtype;
	String operationname = RequestLogOperateName.getOperateName(""+tempworkflowid,""+requestid,""+log_nodeid,logtype,log_operator,user.getLanguage(),log_operatedate,log_operatetime);
	%>
	<%=operationname%>
<%
lineNTdTwo="line"+String.valueOf(nLogCount)+"TdTwo"+Util.getRandom();
%>
            </td>

                  <%--added by xwj for td2104 on 2005-8-1--%>
          <td id="<%=lineNTdTwo%>">
              <%
                String tempStr ="";
                if(log_receivedPersons.length()>0) tempStr = Util.toScreen(log_receivedPersons.substring(0,log_receivedPersons.length()-1),user.getLanguage());
				String showoperator="";
				try
				{
				showoperator=RequestDefaultComInfo.getShowoperator(""+user.getUID());
				}
				catch (Exception eshow)
				{}
                if (!showoperator.equals("1")) {
                if(!"".equals(tempStr) && tempStr != null){
                	tempStr = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick=showallreceivedforsign('"+requestid+"','"+log_nodeid+"','"+log_operator+"','"+log_operatedate+
                                "','"+log_operatetime+"','"+lineNTdTwo+"','"+logtype+"',"+log_destnodeid+") >"+SystemEnv.getHtmlLabelName(89, user.getLanguage())+"</span>";
                }
				}
              %>
              <%=tempStr%>
          </td>
          
          
          </tr>

        <%-- 该段代码已被屏蔽，现删除 --%>


          <%
	if(log_isbranche==0&&!"2".equals(orderbytype)) isLight = !isLight;
}}requestid = initrequestid;
%>

</tbody></table>
</div>


  <script language="javascript">
var showTableDiv  = $GetEle('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("div");
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);
     var message_Div1  = $GetEle("message_Div");
     message_Div1.style.display="inline";
     message_Div1.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_Div1.style.position="absolute"
     message_Div1.style.top=pTop;
     message_Div1.style.left=pLeft;

     message_Div1.style.zIndex=1002;

     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_Div1.style.zIndex - 1;
     oIframe.style.width = parseInt(message_Div1.offsetWidth);
     oIframe.style.height = parseInt(message_Div1.offsetHeight);
     oIframe.style.display = 'block';
}
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showallreceivedforsign(requestid,viewLogIds,operator,operatedate,operatetime,returntdid,logtype,destnodeid){
    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
    var ajax=ajaxinit();
    ajax.open("POST", "/workflow/request/WorkflowReceiviedPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&viewnodeIds="+viewLogIds+"&operator="+operator+"&operatedate="+operatedate+"&operatetime="+operatetime+"&returntdid="+returntdid+"&logtype="+logtype+"&destnodeid="+destnodeid);
    //获取执行状态

    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里

        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            $GetEle(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            showTableDiv.style.display='none';
            oIframe.style.display='none';
        }
    }
}
    function displaydiv_1()
	{
		if(WorkFlowDiv.style.display == ""){
			WorkFlowDiv.style.display = "none";
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></a>";
		}
		else{
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154, user.getLanguage())%></a>";
			WorkFlowDiv.style.display = "";
		}
	}

    function doRemark(){        <!-- 点击被转发的提交按钮 -->
var ischeckok="true";
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>
if(ischeckok=="true"){
	if ("<%=needconfirm%>"=="1")
	{
	if (!confirm("<%=SystemEnv.getHtmlLabelName(19990,user.getLanguage())%>"))
    return false; 
	}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoRemark").click();
            obj.disabled=true;
        }catch(e){
        	$GetEle("isremark").value='1';
        	$GetEle("src").value='save';
           <%--added by xwj for td2104 on 2005-08-01--%>
                <%--$GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;--%>
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
//保存签章数据
<%if("1".equals(isFormSignature)){%>
				if(SaveSignature()){
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
	function checkNodesNum()
	{
		var nodenum = 0;
		try
		{
		<%
		int checkdetailno = 0;
		//
		if(_isbill>0)
		{
			if(_formid==7||_formid==156 || _formid==157 || _formid==158 || _formid==159)
			{
				%>
			   	var rowneed = $GetEle('rowneed').value;
			   	var nodesnum = $GetEle('nodesnum').value;
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
			    RecordSet.execute("select tablename,title from Workflow_billdetailtable where billid="+_formid+" order by orderid");
			    //System.out.println("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
			    while(RecordSet.next())
			    {
	   	%>
	   	var rowneed = $GetEle('rowneed<%=checkdetailno%>').value;
	   	var nodesnum = $GetEle('nodesnum<%=checkdetailno%>').value;
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
	   	<%
			   		checkdetailno ++;
			    }
			}
		}
		else
		{
		 	int checkGroupId=0;
		    RecordSet formrs=new RecordSet();
			formrs.execute("select distinct groupId from Workflow_formfield where formid="+_formid+" and isdetail='1' order by groupid");
		    while (formrs.next())
		    {
		    	checkGroupId=formrs.getInt(1);
		    	%>
		       	var rowneed = $GetEle('rowneed<%=checkGroupId%>').value;
		       	var nodesnum = $GetEle('nodesnum<%=checkGroupId%>').value;
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
		       	<%
		    }
	    }
	    //多明细循环结束

		%>
		}
		catch(e)
		{
			nodenum = 0
		}
		return nodenum;
	}
    function doSave(){          <!-- 点击保存按钮 -->
    	var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
            obj.disabled=true;
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
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
	            getRemarkText_log();
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
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
                	$GetEle("src").value='save';
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
//保存签章数据
<%if("1".equals(isFormSignature)){%>
				if(SaveSignature()){
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
	}
function doRemark_n(obj){        <!-- 点击被转发的提交按钮,点击抄送的人员提交 -->
var ischeckok="true";
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>
if(ischeckok=="true"){
	if ("<%=needconfirm%>"=="1")
	{
 if (!confirm("<%=SystemEnv.getHtmlLabelName(19990,user.getLanguage())%>"))
    return false; 
	}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoRemark").click();
            //obj.disabled=true;
        }catch(e){
        	$GetEle("isremark").value='<%=isremark%>';
        	$GetEle("src").value='save';
           <%--added by xwj for td2104 on 2005-08-01--%>
                <%--$GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;--%>
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
$GetEle("frmmain").action="RequestRemarkOperation.jsp";
			 //obj.disabled=true;
//保存签章数据
<%if("1".equals(isFormSignature)){%>
				if(SaveSignature()){
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

    function doSave_n(obj){          <!-- 点击保存按钮 -->
    	var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            if($GetEle("planDoSave").length == undefined){
               $GetEle("planDoSave").click();
            }else{
               var l = $GetEle("planDoSave").length;
               for(var i = 0; i < l;i++){
               if(i>0) $GetEle("flowbody").onbeforeunload=null;	
               $GetEle("planDoSave")[i].click();  	
               }
            }
            //obj.disabled=true;
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
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
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
    	if("<%=formid%>"==19&&"<%=isbill%>"==1){//资产领用单据明细中的资产领用数量大于库存数量，不能提交。

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
		    			alert("<%=SystemEnv.getHtmlLabelName(15313,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%>");
		    			return;
		    		}
	    		}catch(e){
			    	continue;
			    }
	    	}
	    	}catch(e){}
    	}

                        obj.disabled=true;
                        $GetEle("src").value='save';
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

//保存签章数据
<%if("1".equals(isFormSignature)){%>
				if(SaveSignature()){
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
	}
    function doAffirmance(obj){          <!-- 提交确认 -->
    	var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
		
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
            obj.disabled=true;
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
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
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
                	$GetEle("src").value='save';
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
                        obj.disabled=true;
                        $GetEle("topage").value="ViewRequest.jsp?isaffirmance=1&reEdit=0&fromFlowDoc=<%=fromFlowDoc%>";
//保存签章数据
<%if("1".equals(isFormSignature)){%>
				if(SaveSignature()){
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
	}

    function doSubmit(obj){        <!-- 点击提交 -->
			$G('RejectToNodeid').value = '';
    	var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
        try{
      //modify by xhheng @20050328 for TD 1703
      //明细部必填check，通过try $GetEle("needcheck")来检查,避免对原有无明细单据的修改

        var ischeckok="";
        try{
        var checkstr=$GetEle("needcheck").value+$GetEle("inputcheck").value;
        if(<%=_isremark%>==5){
            checkstr="";
        }
        if(check_form($GetEle("frmmain"),checkstr))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
          if(check_form($GetEle("frmmain"),'<%=needcheck%>'))
            ischeckok="true";
        }
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
	            getRemarkText_log();
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>
        if(ischeckok=="true"){
    		if (("<%=needconfirm%>"=="1")&&("<%=nodetype%>"!="0"))
    		{
    		if (!confirm("<%=SystemEnv.getHtmlLabelName(19990,user.getLanguage())%>"))
            return false; 
    		}

			<%
			if("1".equals(fromFlowDoc)){
				boolean hasUseTempletSucceed=RequestUseTempletManager.ifHasUseTempletSucceed(requestid);
				if(!hasUseTempletSucceed){
			%>
			if($GetEle("createdoc")){
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(21252,user.getLanguage())%>")){
			   $GetEle("createdoc").click();
			   return false;
			}else{
			   return false;
			}
			}
			<%
				}
			}
			%>

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
    	if("<%=formid%>"==19&&"<%=isbill%>"==1){//资产领用单据明细中的资产领用数量大于库存数量，不能提交。

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
		    			alert("<%=SystemEnv.getHtmlLabelName(15313,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%>");
		    			return;
		    		}
	    		}catch(e){
			    	continue;
			    }
	    	}
	    	}catch(e){}
    	}

    		CkeditorExt.updateContent();
            if(checktimeok()) {
            	if("<%=formid%>"==19){//资产领用单据
            		if("<%=nextnodetype%>"==3){//如果提交的下一个节点为归档节点，检查库存是否足够，不足不允许提交到下一个节点。

            			try{
            			nodesnum = $GetEle("nodesnum").value;
						    	for(var tempindex1=0;tempindex1<nodesnum;tempindex1++){
						    		var capitalcount = $GetEle("node_"+tempindex1+"_capitalcount").value*1;
						    		var fetchingnumber=$GetEle("node_"+tempindex1+"_number").value*1;
						    		for(var tempindex2=0;tempindex2<nodesnum;tempindex2++){
						    			if(tempindex2!=tempindex1&&$GetEle("node_"+tempindex1+"_capitalid").value==$GetEle("node_"+tempindex2+"_capitalid").value){
						    				fetchingnumber = fetchingnumber*1 + $GetEle("node_"+tempindex2+"_number").value*1;
						    			}
						    		}
						    		if(fetchingnumber>capitalcount){
						    			alert("<%=SystemEnv.getHtmlLabelName(15313,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%>");
						    			return;
						    		}
						    	}
						    	}catch(e){}
            		}
            	}
                showtipsinfo(<%=requestid%>,<%=workflowid%>,<%=_nodeid%>,<%=_isbill%>,0,<%=_billid%>,obj,"submit");
            }
        }
      }catch(e){}
	}

	function doReject(){        <!-- 点击退回 -->
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
	            getRemarkText_log();
			    if(!check_form(document.frmmain,'remarkText10404')){
				    return false;
			    }
<%
		}
	}
%>
		if ("<%=needconfirm%>"=="1")
		{
		if (!confirm("<%=SystemEnv.getHtmlLabelName(19991,user.getLanguage())%>"))
        return false; 
		}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoReject").click();
        }catch(e){
            if(onSetRejectNode())
            showtipsinfo(<%=requestid%>,<%=workflowid%>,<%=_nodeid%>,<%=_isbill%>,1,<%=_billid%>,"","reject");
        }
    }

	function doReopen(){        <!-- 点击重新激活 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoReopen").click();
        }catch(e){
        	$GetEle("src").value='reopen';
            $GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
            jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
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
            if(confirm("<%=SystemEnv.getHtmlLabelName(16667,user.getLanguage())%>")) {
            	$GetEle("src").value='delete';
                $GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
            }
        }
    }
//加常用短语

function onAddPhrase(phrase){
	if(phrase!=null && phrase!=""){
		$GetEle("remarkSpan").innerHTML = "";
		try{
			var remarkHtml = CkeditorExt.getHtml("remark");
			var remarkText = CkeditorExt.getText("remark");
			if(remarkText==null || remarkText==""){
				CkeditorExt.setHtml(phrase,"remark");
			}else{
				CkeditorExt.setHtml(remarkHtml+"<p>"+phrase+"</p>","remark");
			}
		}catch(e){}
	}
}
  function nodechange(value){
    var nodeids=value.split("_");
    var selnodeid=nodeids[0];
    var selnodetype=nodeids[1];
    if(selnodetype==0){
        $GetEle("Intervenorid").value="<%=_creater%>";
        $GetEle("Intervenorspan").innerHTML="<A href='javaScript:openhrm(<%=_creater%>);' onclick='pointerXY(event);'><%=_creatername%></a>";
    }else{
    rightMenu.style.display="none";
    $GetEle("workflownextoperatorfrm").src="/workflow/request/WorkflowNextOperator.jsp?requestid=<%=requestid%>&isremark=<%=_isremark%>&workflowid=<%=workflowid%>"+
            "&formid=<%=_formid%>&isbill=<%=_isbill%>&billid=<%=_billid%>&creater=<%=_creater%>&creatertype=<%=_creatertype%>&nodeid="+selnodeid+"&nodetype="+selnodetype;
    }
}
function accesoryChanage(obj,maxUploadImageSize){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        var oFile=$GetEle("oFile");
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
    if (fileLenthByM>maxUploadImageSize) {
     	alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%>"+maxUploadImageSize+"M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=50 >";
    $GetEle(objName).outerHTML=outerHTML;
    $GetEle(objName).onchange=tempObjonchange;
}
function addannexRow(accname,maxsize)
  {
    $GetEle(accname+'_num').value=parseInt($GetEle(accname+'_num').value)+1;
    ncol = $GetEle(accname+'_tab').cols;
    oRow = $GetEle(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1);

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");
          oCell.colSpan=3;
          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+$GetEle(accname+'_num').value+"' onchange='accesoryChanage(this,"+maxsize+")'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }

  function onChangeSharetype(delspan,delid,ismand,Uploadobj){
	fieldid=delid.substr(0,delid.indexOf("_"));
    linknum=delid.substr(delid.lastIndexOf("_")+1);
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
    delfieldid=fieldid+"_id_"+linknum;
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
	//alert($GetEle(fieldidnum).value);
	if (ismand=="1")
	  {
	if ($GetEle(fieldidnum).value=="0")
	  {
	    $GetEle(fieldid).value="";
        if(Uploadobj.getStats().files_queued==0){
		$GetEle(fieldidspan).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
        }
	  }
	  else
	  {
		 $GetEle(fieldidspan).innerHTML="";
	  }
	  }
  }
function getWFLinknum(wffiledname){
    if($GetEle(wffiledname) != null){
        return $GetEle(wffiledname).value;
    }else{
        return 0;
    }
}

function showtipsinfo(requestid,workflowid,nodeid,isbill,isreject,billid,obj,src){
		var nowtarget = frmmain.target;
		var nowaction = frmmain.action;

		$GetEle("divcontent").value="";
		$GetEle("content").value="";
		$GetEle("src").value=src;
		frmmain.target = "showtipsinfoiframe";
		frmmain.action = "/workflow/request/WorkflowTipsinfo.jsp";
		frmmain.submit();

		frmmain.target = nowtarget;
		frmmain.action = nowaction;
}
function showtipsinfoReturn(returnvalue,src,ismode,divcontent,content,messageLabelName){

	obj="";
            try{
                if(messageLabelName!=""){
					alert(messageLabelName);
					return ;
				}
            }catch(e){}
           try{
                tipsinfo=returnvalue;
                if(tipsinfo!=""){
                    if(confirm(tipsinfo)){
                    	$GetEle("src").value=src;
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
                        if(obj!=""){
					        obj.disabled=true;
				        }
//保存签章数据
<%if("1".equals(isFormSignature)){%>
				if(SaveSignature()){
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
					return ;
				}
<%}else{%>
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>
                    }
                }else{
                	$GetEle("src").value=src;
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
                    if(obj!=""){
					    obj.disabled=true;
				    }
//保存签章数据
<%if("1".equals(isFormSignature)){%>
				if(SaveSignature()){
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
					return ;
				}
<%}else{%>
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>
                }
            }catch(e){}

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
function uescape(url){
    return escape(url);
}
function doStop(obj){
	//您确定要暂停当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26156,user.getLanguage())%>?")){
		jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		enableAllmenu();
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?flag=stop&requestid=<%=requestid%>" //xwj for td3665 20060224
	}
	else
	{
		displayAllmenu();
		return false;
	}
}
function doCancel(obj){
	//您确定要撤销当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26157,user.getLanguage())%>?")){
		jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		enableAllmenu();
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?flag=cancel&requestid=<%=requestid%>" //xwj for td3665 20060224
	}
	else
	{
		displayAllmenu();
		return false;
	}
}
function doRestart(obj)
{
	//您确定要启用当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26158,user.getLanguage())%>?")){
		jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		enableAllmenu();
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?flag=restart&requestid=<%=requestid%>" //xwj for td3665 20060224
	}
	else
	{
		displayAllmenu();
		return false;
	}
}
</script>
<script type="text/javascript">

function onShowBrowser(id,url,linkurl,type1,ismand) {
	var funFlag = "";
	var id1 = null;
	
    spanname = "field" + id + "span";
    inputname = "field" + id;
	if (type1 == 2 || type1 == 19 ) {
		if (type1 == 2) {
			onWorkFlowShowDate(spanname,inputname,0);
		} else {
			onWorkFlowShowTime(spanname, inputname, 0);
		}
	} else {
	    if (type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170) {
			id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
		} else {
	        if (type1 == 135) {
				tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 37) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 142 ) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			} else if (type1 == 162 ) {
				tmpids = $GetEle("field"+id).value;

				if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
					url = url + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
				} else {
					url = url + "|" + id + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
			} else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
		        index = (id + "").indexOf("_");
		        if (index != -1) {
		        	tmpids=uescape("?isdetail=1&isbill=<%=isbill%>&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else {
		        	tmpids = uescape("?fieldid=" + id + "&isbill=<%=isbill%>&resourceids=" + $GetEle("field" + id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        }
			} else {
		        tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			}
		}
		
	    if (id1 != undefined && id1 != null) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = ""

					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);

					$GetEle("field"+id).value= resourceids
					
					var tlinkurl = linkurl;
					var resourceIdArray = resourceids.split(",");
					var resourceNameArray = resourcename.split(",");
					for (var _i=0; _i<resourceIdArray.length; _i++) {
						var curid = resourceIdArray[_i];
						var curname = resourceNameArray[_i];

						if (tlinkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml += "<a href=" + tlinkurl + curid + " target=_new>" + curname + "</a>&nbsp";
						}
					}
					
					$GetEle("field"+id+"span").innerHTML = sHtml;
					$GetEle("field"+id).value= resourceids;
				} else {
 					if (ismand == 0) {
 						$GetEle("field"+id+"span").innerHTML = "";
 					} else {
 						$GetEle("field"+id+"span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
 					}
 					$GetEle("field"+id).value = "";
				}

			} else {
			   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
	               if (type1 == 162) {
				   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						sHtml = ""
						ids = ids.substr(1);
						$GetEle("field"+id).value= ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return;
	               }
				   if (type1 == 161) {
					   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
					   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						$GetEle("field"+id).value = ids;
						sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return ;
				   }

				   if (type1 == 16) {
					   curid = wuiUtil.getJsonValueByIndex(id1, 0);
                   	   linkno = getWFLinknum("slink" + id + "_rq" + curid);
	                   if (linkno>0) {
	                       curid = curid + "&wflinkno=" + linkno;
	                   } else {
	                       linkurl = linkurl.substring(0, linkurl.indexOf("?") + 1) + "requestid=";
	                   }
	                   $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
					   if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
						   $GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(e);'>" + wuiUtil.getJsonValueByIndex(id1, 1)+ "</a>&nbsp";
					   } else {
	                       $GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + curid + " target='_new'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
					   }
	                   return;
				   }
				   
	         
            	    if (linkurl == "") {
			        	$GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1);
			        } else {
						if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
							$GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
						} else {
							$GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
						}
			        }
	               $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
	               
			   } else {
					if (ismand == 0) {
						$GetEle("field"+id+"span").innerHTML = "";
					} else {
						$GetEle("field"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					}
					$GetEle("field"+id).value="";
			   }
			}
		}
	}
}

function onShowBrowser2(id,url,linkurl,type1,ismand, funFlag) {
	var id1 = null;
	
    
	
	if (type1 == 23) {
		url += "?billid=<%=formid%>";
	}
	
	if (type1 == 2 || type1 == 19 ) {
	    spanname = "field" + id + "span";
	    inputname = "field" + id;
	    
		if (type1 == 2) {
			onWorkFlowShowDate(spanname,inputname,ismand);
		} else {
			onWorkFlowShowTime(spanname, inputname, ismand);
		}
	} else {
	    if (type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170) {
	    	if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
	    		id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
	    	} else {
			    if (type1 == 161) {
				    id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
				} else {
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
	    	}
		} else {
	        if (type1 == 135) {
				tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        //} else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) {
	        //type1 = 167 是:分权单部门-分部 不应该包含在这里面 ypc 2012-09-06 修改
	        }else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 37) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 142 ) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			} else if (type1 == 162 ) {
				tmpids = $GetEle("field"+id).value;

				if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
					url = url + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
				} else {
					url = url + "|" + id + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
			} else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
		        index = (id + "").indexOf("_");
		        if (index != -1) {
		        	tmpids=uescape("?isdetail=1&isbill=<%=isbill%>&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle("field"+id).value+"&selectedids="+$GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else {
		        	tmpids = uescape("?fieldid=" + id + "&isbill=<%=isbill%>&resourceids=" + $GetEle("field" + id).value+"&selectedids="+$GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        }
			} else {
		        tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			}
		}
		
	    if (id1 != undefined && id1 != null) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = ""

					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
					
					var resourceIdArray = resourceids.split(",");
					var resourceNameArray = resourcename.split(",");
					for (var _i=0; _i<resourceIdArray.length; _i++) {
						var curid = resourceIdArray[_i];
						var curname = resourceNameArray[_i];
						if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml += "<a href=" + linkurl + curid + " target=_blank>" + curname + "</a>&nbsp";
						}
					}
					
					$GetEle("field"+id+"span").innerHTML = sHtml;
					$GetEle("field"+id).value= resourceids;
				} else {
 					if (ismand == 0) {
 						$GetEle("field"+id+"span").innerHTML = "";
 					} else {
 						$GetEle("field"+id+"span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
 					}
 					$GetEle("field"+id).value = "";
				}

			} else {
			   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
	               if (type1 == 162) {
				   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						sHtml = ""
						ids = ids.substr(1);
						$GetEle("field"+id).value= ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return;
	               }
				   if (type1 == 161) {
					   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
					   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						$GetEle("field"+id).value = ids;
						sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						$GetEle("field" + id + "span").innerHTML = sHtml
						return ;
				   }
	               
            	    if (linkurl == "") {
			        	$GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1);
			        } else {
						if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
							$GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
						} else {
							$GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
						}
			        }
	               $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
	               
			   } else {
					if (ismand == 0) {
						$GetEle("field"+id+"span").innerHTML = "";
					} else {
						$GetEle("field"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					}
					$GetEle("field"+id).value="";
			   }
			}
		}
	}
}



function onShowMutiHrm(spanname, inputename) {
	tmpids = $GetEle(inputename).value;
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
					+ tmpids);
	if (id1) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			
			$GetEle(inputename).value = resourceids;
			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");
			for (var _i=0; _i<resourceidArray.length; _i++) {
				var curid = resourceidArray[_i];
				var curname = resourcenameArray[_i];
				
				sHtml = sHtml + "<A href='javaScript:openhrm(" + curid
						+ ");' onclick='pointerXY(e);'>" + curname
						+ "</a>&nbsp";
			}
			
			$GetEle(spanname).innerHTML = sHtml;

		} else {
			$GetEle(spanname).innerHTML = "<button type=button  class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button><img src='/images/BacoError_wev8.gif' align=absmiddle>";
			$GetEle(inputename).value = "";
		}
	}
}
</script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<style type="text/css">
TABLE.ListStyle tbody tr td {
	padding: 4 5 0 5!important;
}
</style>


<script type="text/javascript">
var hasHead = false;

var forward=<%=Util.getIntValue(Util.null2String(request.getParameter("forward")), 0)%>;
var submit=<%=Util.getIntValue(Util.null2String(request.getParameter("submit")), 0)%>;

function  showAllSignLog3(workflowid,requestid,viewLogIds,orderby, pageNumber, targetEle, requestLogDataIsEnd, WorkFlowLoddingDiv, maxRequestLogId) {
	//获取搜索数据
	var operatorid=encodeURI(encodeURI(jQuery("input[name='caozuozhe']").val()));//操作者

	var deptid=encodeURI(encodeURI(jQuery("input[name='bumen']").val()));//部门
	var subcomid=encodeURI(encodeURI(jQuery("input[name='fenbu']").val()));//分部
	var content=encodeURI(encodeURI(jQuery("input[name='yijian']").val()));//意见
	var nodename=encodeURI(encodeURI(jQuery("input[name='jiedian']").val()));//节点名称
	var createdateselect=encodeURI(encodeURI(jQuery("input[name='caozuoriqi']").val()));//操作日期
	var createdatefrom=encodeURI(encodeURI(jQuery("input[name='kaishishijian']").val()));
	var createdateto=encodeURI(encodeURI(jQuery("input[name='jieshushijian']").val()));
	var atmet=encodeURI(encodeURI(jQuery("input[name='yuwoxiangguan']").val()));//与我相关
	
	jQuery("#" + WorkFlowLoddingDiv).show();
	var crurrentPageNumber = pageNumber;
    var ajax=ajaxinit();
    ajax.open("POST", "/workflow/request/WorkflowViewSignMore.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	ajax.send("workflowid="+workflowid+"&requestid="+requestid+"&languageid=<%=user.getLanguage()%>&desrequestid=<%=0%>&userid=<%=userid%>&isprint=<%=false%>&isOldWf=<%=isOldWf_%>&viewLogIds="+viewLogIds+"&orderbytype=<%=orderbytype%>&creatorNodeId=<%=creatorNodeId%>&orderby="+orderby + "&pgnumber=" + crurrentPageNumber + "&maxrequestlogid=" + maxRequestLogId + "&wflog" + new Date().getTime() + "=" + "&wfsignlddtcnt=<%=wfsignlddtcnt%>"+
	"&forward="+forward+"&submit="+submit+
	"&operatorid="+operatorid+"&deptid="+deptid+"&subcomid="+subcomid+"&content="+content+"&nodename="+nodename+"&createdateselect="+createdateselect+"&createdatefrom="+createdatefrom+"&createdateto="+createdateto+"&atmet="+atmet);

	//获取执行状态

    ajax.onreadystatechange = function() {
		 try {

       			var $targetEle = jQuery("#" + targetEle);

            	saslrtn = ajax.responseText.replace(/(^\s*)|(\s*$)/g, "").indexOf("<requestlognodata>");
				if (saslrtn == -1) {
					var headStr = "";
					 if(!hasHead){
						headStr = jQuery("#headTitle").html();
						if(headStr==null)headStr="";
						hasHead = true;
					 }
					 var tableStr="<table class='liststyle liststyle1' cellspacing=1 style=\"margin:0;margin-top:-1;\">"+
    				 "<colgroup>"+
    				 "<col width='10%'><col width='50%'> <col width='10%'>  <col width='30%'>"+
    				 "</colgroup>"+headStr+jQuery.trim(ajax.responseText)+
    				 "</table>";
    				 
					//jQuery("#requestlogappednDiv").append(tableStr);
					jQuery("#signid").html(tableStr);
					jQuery("#requestlogappednDiv table tbody tr:first").addClass("HeaderForXtalbe");
					jQuery("#mainWFHead").css("display", "none");
            		sucNm = true;
					
					var allPages=jQuery("input[name='allPages" + crurrentPageNumber + "']").val();

					jQuery("#prePage").val(pageNumber);
					jQuery(".prePage").text(pageNumber);

					jQuery("#signall").find("a[name='shouye']").removeClass("signpage");
					jQuery("#signall").find("a[name='shangyiye']").removeClass("signpage");
					if(pageNumber>1){
						jQuery("#signall").find("a[name='shouye']").addClass("signpage");
						jQuery("#signall").find("a[name='shangyiye']").addClass("signpage");
					}
					jQuery("#signall").find("a[name='xiayiye']").removeClass("signpage");
					jQuery("#signall").find("a[name='weiye']").removeClass("signpage");
					if(pageNumber<allPages){
						jQuery("#signall").find("a[name='xiayiye']").addClass("signpage");
						jQuery("#signall").find("a[name='weiye']").addClass("signpage");
					}

					jQuery("#allItems").val(jQuery("input[name='allItems" + crurrentPageNumber + "']").val());
					jQuery(".allItems").text(jQuery("input[name='allItems" + crurrentPageNumber + "']").val());
					
					jQuery("#allPages").val(allPages);
					jQuery(".allPages").text(allPages);
            	}else{
					jQuery("#signid").html("");
					
					jQuery("#prePage").val(1);
					jQuery(".prePage").text(1);
					
					jQuery("#allItems").val(0);
					jQuery(".allItems").text(0);

					jQuery("#allPages").val(1);
					jQuery(".allPages").text(1);

					jQuery("#signall").find("a[name='shouye']").removeClass("signpage");
					jQuery("#signall").find("a[name='shangyiye']").removeClass("signpage");
					jQuery("#signall").find("a[name='xiayiye']").removeClass("signpage");
					jQuery("#signall").find("a[name='weiye']").removeClass("signpage");



				}				
				requestLogDataMaxRquestLogId = jQuery("input[name='maxrequestlogid" + crurrentPageNumber + "']").val();
				jQuery("#adserch").css("display","none");
				
				//引用
				if(jQuery(".quote").length>0){
					jQuery(".quote").click(function(){
					 
						var  sHtml=jQuery(this).parent().parent().parent().next().find("iframe").contents().find("body").html();
						
						var container=jQuery("<div contentEditable='false' style='background:#f9fcff;border:1px solid #ddeaf6;padding:10px;margin-left: 20px;'></div>");

						var table=jQuery(sHtml);
						table.css("border-collapse","collapse");
						table.css("border","0px solid white");

						jQuery(this).parent().prev().find("span:eq(0)").find("a").css("text-decoration","none");
						jQuery(this).parent().prev().find("span:eq(0)").find("a").css("color","#000000");

						var detailitem="<div ><span style='color:#6b6b6b'><%=SystemEnv.getHtmlLabelName(19422,user.getLanguage())%>&nbsp;</span>"+jQuery(this).parent().prev().find("span:eq(0)").html()+""+jQuery(this).parent().prev().find("span:eq(1)").html()+"</div>";

						container.append(detailitem).append(table);

						sHtml=jQuery("<div></div>").append(container).html();
						
						var oEditor = CKEDITOR.instances['remark'];		
					
						oEditor.insertElement( CKEDITOR.dom.element.createFromHtml( "<div><span>&nbsp;</span></div>"));
						oEditor.insertElement( CKEDITOR.dom.element.createFromHtml( sHtml));
						

						//	FCKEditorExt.insertHtml("<span>&nbsp;</span>","remark");

					 });
				}
                //转发操作
                if(jQuery(".transto").length>0)
				{
				     jQuery(".transto").click(function(){
					 
                        var resid=jQuery(this).find("span:eq(0)").html();
                        doReview(resid);

					 })
                        
				
				}

            }
            catch(e) {
            	alert(e);
            }
            oIframe.style.display='none';
            jQuery("#" + WorkFlowLoddingDiv).hide();
	}
}

/**
function  showAllSignLog2(workflowid,requestid,viewLogIds,orderby, pageNumber, targetEle, requestLogDataIsEnd, WorkFlowLoddingDiv, maxRequestLogId) {
	var saslrtn = 0;
	jQuery("#" + WorkFlowLoddingDiv).show();
	var crurrentPageNumber = pageNumber;
    var ajax=ajaxinit();
    ajax.open("POST", "/workflow/request/WorkflowViewSignMore.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("workflowid="+workflowid+"&requestid="+requestid+"&languageid=<%=user.getLanguage()%>&desrequestid=<%=0%>&userid=<%=userid%>&isprint=<%=false%>&isOldWf=<%=isOldWf_%>&viewLogIds="+viewLogIds+"&orderbytype=<%=orderbytype%>&creatorNodeId=<%=creatorNodeId%>&orderby="+orderby + "&pgnumber=" + crurrentPageNumber + "&maxrequestlogid=" + maxRequestLogId + "&wflog" + new Date().getTime() + "=" + "&wfsignlddtcnt=<%=wfsignlddtcnt%>");
    //获取执行状态

    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里

        if (ajax.readyState == 4 && ajax.status == 200) {
            try {
       			var $targetEle = jQuery("#" + targetEle);

            	saslrtn = ajax.responseText.replace(/(^\s*)|(\s*$)/g, "").indexOf("<requestlognodata>");
				if (saslrtn == -1) {
					 var headStr = "";
					 if(!hasHead){
						headStr = jQuery("#headTitle").html();
						if(headStr==null)headStr="";
						hasHead = true;
					 }
					 var tableStr="<table class=liststyle cellspacing=1 style=\"margin:0;margin-top:-1;\">"+
    				 "<colgroup>"+
    				 "<col width='10%'><col width='50%'> <col width='10%'>  <col width='30%'>"+
    				 "</colgroup>"+headStr+jQuery.trim(ajax.responseText)+
    				 "</table>"
    				 
					jQuery("#requestlogappednDiv").append(tableStr);
					jQuery("#requestlogappednDiv table tbody tr:first").addClass("HeaderForXtalbe");
					jQuery("#mainWFHead").css("display", "none");
            		sucNm = true;
            	} else {
            		jQuery(requestLogDataIsEnd).val(1);
            		sucNm = false;
            	}
            	currentPageCnt = jQuery("input[name='currentPageCnt" + pageNumber + "']").val();
            	requestLogDataMaxRquestLogId = jQuery("input[name='maxrequestlogid" + crurrentPageNumber + "']").val();
            }
            catch(e) {
            	alert(e);
            }
            oIframe.style.display='none';
            jQuery("#" + WorkFlowLoddingDiv).hide();
        }
    }
}**/
</script>

<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/js/wfsp_wev8.js"></script>
<script language="javascript">
initrequestid = "<%=initrequestid%>";
viewLogIds = "<%=viewLogIds%>";
primaryWfLogLoadding();

jQuery(document).ready(function () {
	primaryWfLogLoadding();
});
</script>
<SCRIPT language="javascript" src="/js/ecology8/workflowcop_wev8.js"></script>