
<%@page import="weaver.workflow.request.WFPathUtil"%><jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog1" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog2" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="rs01" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs02" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="rs03" class="weaver.conn.RecordSet" scope="page" /> 
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
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />
<jsp:useBean id="RequestUseTempletManager" class="weaver.workflow.request.RequestUseTempletManager" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<!-- 
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">
<script type="text/javascript" src="/js/ecology8/weaverautocomplete/weaverautocomplete_wev8.js"></script>
-->
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/workflowshowpaperchange_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowshow_wev8.css" />
<script type="text/javascript" src="/cpt/js/validate_wev8.js"></script>
<!-- 
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowcop_wev8.css" />
 -->
<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />

<%--编码问题--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.net.URLEncoder" %>
<%--编码问题--%>
<%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
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

String _intervenoruserids="";
String _intervenoruseridsType = "";
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
String isHideInput="0";
RecordSetOld.executeSql("select issignmustinput,ishideinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSetOld.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSetOld.getString("issignmustinput"), 0);
	isHideInput = ""+Util.getIntValue(RecordSetOld.getString("ishideinput"), 0);
}

int _nextnodeid=_nodeid;
//String _creatername=ResourceComInfo.getResourcename(""+_creater);
String _creatername= "";
if(_creatertype==1){  
	_creatername=CustomerInfoComInfo.getCustomerInfoname(""+_creater);
}else{
	_creatername=ResourceComInfo.getResourcename(""+_creater);
}
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
    if(nodeinfo!=null &&nodeinfo.size()>3){
        _intervenoruserids=(String)nodeinfo.get(0);
        _intervenorusernames=(String)nodeinfo.get(1);
        _nextnodeid=Util.getIntValue((String)nodeinfo.get(2),_nodeid);
		_intervenoruseridsType=(String)nodeinfo.get(3);
    }
    needcheck="";

%>
<iframe id="workflownextoperatorfrm" frameborder=0 scrolling=no src=""  style="display:none;"></iframe>
<%}
%>
<!-- 
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
-->
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%;display:none' valign='top'>
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
<input type=hidden name="RejectToType" id='RejectToType' value="0">
<input type=hidden name="SubmitToNodeid" value="">
<table width="100%">
<tr>
<td width="50%"  valign="top">

<%--added by xwj for td 2104 on 2005-08-1 begin--%>
  <table class="viewform">
        <!-- modify by xhheng @20050308 for TD 1692 -->
         <COLGROUP>
         <COL width="20%">
         <COL width="80%">
         <%if(_isremark.equals("5")){%>
         <tr><td colspan="2"><b><%=SystemEnv.getHtmlLabelName(18913,user.getLanguage())%></b></td></tr>
         <TR class=spacing style="height:1px;">
            <TD class=line1 colSpan=2></TD>
        </TR>
         <tr>
             <td><%=SystemEnv.getHtmlLabelName(18914,user.getLanguage())%></td>
             <td class=field>
                 <select class=inputstyle  id="submitNodeId" name=submitNodeId  onChange='nodechange(this.value)'>
                 <%
                 WFNodeMainManager.setWfid(workflowid);
                 WFNodeMainManager.selectWfNode();
                 while(WFNodeMainManager.next()){
                    int tmpid = WFNodeMainManager.getNodeid();
                    if(tmpid==_nodeid) continue;
                    String tmpname = WFNodeMainManager.getNodename();
                    String tmptype = WFNodeMainManager.getNodetype();
                 %>
                 <option value="<%=tmpid%>_<%=tmptype%>" <%if(_nextnodeid==tmpid){%>selected<%}%>><%=tmpname%></option>
                 <%}%>
                 </select>
             </td>
         </tr>
	<TR class=spacing  style="height:1px;">
            <TD class=line2 colSpan=2></TD>
        </TR>
         <tr>
             <td><%=SystemEnv.getHtmlLabelName(18915,user.getLanguage())%></td>
             <td class=field>
                 <span id="Intervenorspan">
                     <%if(_intervenoruserids.equals("")){%>
                     <button type=button  class=Browser onclick="onShowMutiHrm('Intervenorspan','Intervenorid')" ></button>
                     <%}%><%=_intervenorusernames%><%if(_intervenorusernames.equals("")){%><img src='/images/BacoError_wev8.gif' align=absmiddle><%}%></span>
					 <input type=hidden name="IntervenoridType" value="<%=_intervenoruseridsType%>">
                 <input type=hidden name="Intervenorid" value="<%=_intervenoruserids%>">
             </td>
         </tr>
	<TR class=spacing style="height:1px;">
            <TD class=line2 colSpan=2></TD>
        </TR>
         <%
         }
         %>
         
         </table>
         </td>
         </tr>
         </table>
         <%
         boolean IsBeForwardCanSubmitOpinion="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsBeForwardCanSubmitOpinion"))?true:false;
         if(IsBeForwardCanSubmitOpinion){
        int annexmainId=0;
         int annexsubId=0;
         int annexsecId=0;

         if("1".equals(isannexupload_edit) && annexdocCategory_edit!=null && !annexdocCategory_edit.equals("")){
            annexmainId=Util.getIntValue(annexdocCategory_edit.substring(0,annexdocCategory_edit.indexOf(',')));
            annexsubId=Util.getIntValue(annexdocCategory_edit.substring(annexdocCategory_edit.indexOf(',')+1,annexdocCategory_edit.lastIndexOf(',')));
            annexsecId=Util.getIntValue(annexdocCategory_edit.substring(annexdocCategory_edit.lastIndexOf(',')+1));
          }
         int annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
         if(annexmaxUploadImageSize<=0){
            annexmaxUploadImageSize = 5;
         }
         char flag1 = Util.getSeparator();
         RecordSet.executeProc("workflow_RequestLog_SBUser",""+requestid+flag1+""+user.getUID()+flag1+""+_usertype+flag1+"1");
         String myremark = "" ;
         String annexdocids = "" ;
         String signdocids="";
         String signworkflowids="";
		 int workflowRequestLogId=-1;
         if(RecordSet.next())
         {
            myremark = Util.null2String(RecordSet.getString("remark"));
            annexdocids=Util.null2String(RecordSet.getString("annexdocids"));
            signdocids=Util.null2String(RecordSet.getString("signdocids"));
			signworkflowids=Util.null2String(RecordSet.getString("signworkflowids"));
			workflowRequestLogId=Util.getIntValue(RecordSet.getString("requestLogId"),-1);
         }
         String signdocname="";
        String signworkflowname="";
        ArrayList templist=Util.TokenizerString(signdocids,",");
        for(int i=0;i<templist.size();i++){
            signdocname+="<a href='/docs/docs/DocDsp.jsp?isrequest=1&id="+templist.get(i)+"' target='_blank'>"+docinf.getDocname((String)templist.get(i))+"</a> ";
        }
        templist=Util.TokenizerString(signworkflowids,",");
        int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
        for(int i=0;i<templist.size();i++){
                tempnum++;
                session.setAttribute("resrequestid" + tempnum, "" + templist.get(i));
            signworkflowname+="<a style=\"cursor:pointer\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=" + request.getParameter("f_weaver_belongto_userid") + "&f_weaver_belongto_usertype=" + request.getParameter("f_weaver_belongto_usertype")+"&isrequest=1&requestid="+templist.get(i)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)templist.get(i))+"</a> ";
        }
        session.setAttribute("slinkwfnum", "" + tempnum);
        session.setAttribute("haslinkworkflow", "1");
         //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+user.getUID());
        //add by cyril on 2008-09-30 for td:9014
  		boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+user.getUID()); 
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
  		int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
        int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
        RecordSet.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight  from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
        if(RecordSet.next()){
        	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
        	formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
        	formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
        }
         %>
         
         <%@ include file="/workflow/request/WorkflowSignInput.jsp" %>
 
<%}%>



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
						try{  
					        if(typeof(eval("SaveSignature"))=="function"){
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
					        }
					    }catch(e){
					        //附件上传
					                    StartUploadAll();
					                    checkuploadcomplet(); 
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
			 if(check_form($GetEle("frmmain"), "requestname"))
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
	            //保存时不验证签字意见必填
			    //if(!check_form($GetEle("frmmain"),'remarkText10404')){
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
                	$GetEle("src").value='save';
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
//保存签章数据
<%if("1".equals(isFormSignature)){%>
						try{  
					        if(typeof(eval("SaveSignature"))=="function"){
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
					        }
					    }catch(e){
					        //附件上传
					                    StartUploadAll();
					                    checkuploadcomplet(); 
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
						try{  
					        if(typeof(eval("SaveSignature"))=="function"){
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
					        }
					    }catch(e){
					        //附件上传
					                    StartUploadAll();
					                    checkuploadcomplet();
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
			 if(check_form($GetEle("frmmain"), "requestname"))
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
    	if("<%=formid%>"==19&&"<%=isbill%>"==1){//资产领用单据明细中的资产领用数量大于库存数量，不能提交。

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

                        obj.disabled=true;
                        $GetEle("src").value='save';
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

//保存签章数据
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
						try{  
					        if(typeof(eval("SaveSignature_save"))=="function"){
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
										return ;
									}
					        }
					    }catch(e){
					        //附件上传
					                    StartUploadAll();
					                    checkuploadcomplet(); 
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
                        var isSubmitDirect = "";
                        if($G("SubmitToNodeid")) {
                            if($G("SubmitToNodeid").value != "") {
                            	isSubmitDirect = "1";
                            }
                     	}
                        $GetEle("topage").value="ViewRequest.jsp?isaffirmance=1&reEdit=0&fromFlowDoc=<%=fromFlowDoc%>&isSubmitDirect=" + isSubmitDirect;
//保存签章数据
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
						try{  
					        if(typeof(eval("SaveSignature"))=="function"){
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
					        }
					    }catch(e){
					        //附件上传
					                    StartUploadAll();
					                    checkuploadcomplet();
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
        if(!checkCarSubmit()){
            ischeckok=="false";
            return;
        }
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

  		//add 2014-10-10 验证资产领用的数量

		if("<%=formid%>"==19&&"<%=isbill%>"==1){ 
			try{
			var nodesum = $GetEle("nodesnum").value;
			var poststr="";
			var returnval="";
			for(var i=0;i<nodesum;i++){
				if($GetEle("node_"+i+"_capitalid")== null){
					continue;
				}else{
					 poststr += "|"+$GetEle("node_"+i+"_capitalid").value*1+","+$GetEle("node_"+i+"_number").value*1+",<%=requestid%>";
				}
			}
			//alert(poststr);
			<%
			rs03.executeSql("SELECT currentnodetype FROM workflow_requestbase WHERE requestid = "+requestid);
			if(rs03.next()){
				String notype = rs03.getString("currentnodetype");
				if("1".equals(notype) || "2".equals(notype)){
			%>		//alert("a");
			if(poststr.length){
				checkformanager(poststr,'<%=formid %>','<%=requestid%>',function(){
					cptcallback(obj);
				});
				return;
			}
			<%}else if("0".equals(notype)){%>
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
			//alert("b");
			
			<%
				}
			}
			%>
			}catch(e){}
		}
		
		//验证资产报废的数量

		if("<%=formid%>"==201&&"<%=isbill%>"==1){
			try{
			var nodesum = $GetEle("nodesnum").value;
			var poststr="";
			var returnval="";
			for(var i=0;i<nodesum;i++){
				if($GetEle("node_"+i+"_capitalid")== null){
						continue;
					}else{
						 poststr += "|"+$GetEle("node_"+i+"_capitalid").value*1+","+$GetEle("node_"+i+"_number").value*1+",<%=requestid%>";
					}
			}
			<%
			rs03.executeSql("SELECT currentnodetype FROM workflow_requestbase WHERE requestid = "+requestid);
			if(rs03.next()){
				String notype = rs03.getString("currentnodetype");
				if("1".equals(notype) || "2".equals(notype)){
			%>		
					if(poststr.length){
						checkformanager(poststr,'<%=formid %>','<%=requestid%>',function(){
							cptcallback(obj);
						});
						return;
					}
			<%}else if("0".equals(notype)){%>
					
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
			<%
				}
			}
			%>
			if(returnval==true){
				return;
			}
			}catch(e){}
		}
		//验证资产调拨的数量

		if("<%=formid%>"==18&&"<%=isbill%>"==1){
			try{
			var nodesum = $GetEle("nodesnum").value;
			var poststr="";
			var returnval="";
			for(var i=0;i<nodesum;i++){
				if($GetEle("node_"+i+"_capitalid")== null){
					continue;
				}else{
					 poststr += "|"+$GetEle("node_"+i+"_capitalid").value*1+","+$GetEle("node_"+i+"_number").value*1+",<%=requestid%>";
				 }
			}
			<%
			rs03.executeSql("SELECT currentnodetype FROM workflow_requestbase WHERE requestid = "+requestid);
			if(rs03.next()){
				String notype = rs03.getString("currentnodetype");
				if("1".equals(notype) || "2".equals(notype)){
			%>		
			if(poststr.length){
					checkformanager(poststr,'<%=formid %>','<%=requestid%>',function(){
						cptcallback(obj);
					});
					return;
			}
					
			<%}else if("0".equals(notype)){%>
			for(var tempindex1=0;tempindex1<nodesnum;tempindex1++){
	    		try{
		    		var fetchingnumber=$GetEle("node_"+tempindex1+"_number").value*1;
			    		for(var tempindex2=0;tempindex2<nodesnum;tempindex2++){
			    			try{
				    			if(tempindex2!=tempindex1&&$GetEle("node_"+tempindex1+"_capitalid").value==$GetEle("node_"+tempindex2+"_capitalid").value){
				    				fetchingnumber = fetchingnumber*1 + $GetEle("node_"+tempindex2+"_number").value*1;
				    			}
			    			}catch(e){
						    	continue;
						    }
			    		}
		    		if(fetchingnumber>1){
		    			alert("<%=SystemEnv.getHtmlLabelName(1437,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1418,user.getLanguage())%>");
		    			return;
		    		}
	    		}catch(e){
			    	continue;
			    }
	    	}
			<%
				}
			}
			%>
			}catch(e){}
		}
		
		
		//验证资产减损的数量

		if("<%=formid%>"==221){
		<%
			rs01.executeSql("select id from workflow_billfield where billid = 221 and fieldname = 'lossCpt'");
			String cptid="";
			if(rs01.next()){
				cptid = rs01.getString("id");
			}
			rs02.executeSql("select id from workflow_billfield where billid = 221 and fieldname = 'losscount'");
			String cptcount="";
			if(rs02.next()){
				cptcount = rs02.getString("id");
			}
		%>
			var poststr = "|"+jQuery("input[name=field<%=cptid%>]").val()*1+","+jQuery("input[name=field<%=cptcount%>]").val()*1+",<%=requestid%>";
			//alert(poststr);
			<%
			rs03.executeSql("SELECT currentnodetype FROM workflow_requestbase WHERE requestid = "+requestid);
			if(rs03.next()){
				String notype = rs03.getString("currentnodetype");
				if("1".equals(notype) || "2".equals(notype)){
			%>		
			if(poststr.length){
				checkformanager(poststr,'<%=formid %>','<%=requestid%>',function(){
					cptcallback(obj);
				});
				return;
			}
			<%}else if("0".equals(notype)){%>
					
			if(poststr.length){
				checkcapitalnum(poststr,function(){
					cptcallback(obj);
				});
				return;
			}
			<%
				}
			}
			%>
		}    
/**		
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
**/
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

function cptcallback(obj){
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
    
    
	function doReject(){        <!-- 点击退回 -->
		$G('SubmitToNodeid').value = '';
<%
	if(isSignMustInput.equals("1") || isSignMustInput.equals("2")){
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
				CkeditorExt.setHtml(remarkHtml+phrase,"remark");
			}
		}catch(e){}
	}
	$G("phraseselect").options[0].selected = true;
}
  function nodechange(value){
    var nodeids=value.split("_");
    var selnodeid=nodeids[0];
    var selnodetype=nodeids[1];
    if(selnodetype==0){
        $GetEle("Intervenorid").value="<%=_creater%>";
		$GetEle("IntervenoridType").value="<%=_creatertype%>";
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
	    var swfuploadid=fieldid.replace("field","");
	    var linkrequired=$GetEle("oUpload_"+swfuploadid+"_linkrequired");
	    $GetEle(fieldidspan).innerHTML="";
        if(Uploadobj.getStats().files_queued==0){
		$GetEle(fieldidspan).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
        }
        if(linkrequired && linkrequired.value=="false"){
        	$GetEle(fieldidspan).innerHTML="";
        }
	  }
	  else
	  {
		 $GetEle(fieldidspan).innerHTML="";
	  }
	  }else{//add by td78113
	  	displaySWFUploadError(fieldid);
	  }
  }
function getWFLinknum(wffiledname){
    if($GetEle(wffiledname) != null){
        return $GetEle(wffiledname).value;
    }else{
        return 0;
    }
}

function onChangeSharetypeNew(obj,delspan,delid,showid,names,ismand,Uploadobj){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84051,user.getLanguage())%>"+names+"<%=SystemEnv.getHtmlLabelName(84498,user.getLanguage())%>", function(){
		/*fieldid=delid.substr(0,delid.indexOf("_"));
	    linknum=delid.substr(delid.lastIndexOf("_")+1);
		fieldidnum=fieldid+"_idnum_1";
		fieldidspan=fieldid+"span";
	    delfieldid=fieldid+"_id_"+linknum;
	    */
	    jQuery(obj).parent().parent().parent().parent().css("display","none");
		
	    /*var deleteid = jQuery("#"+fieldid).val();
		deleteid = deleteid.replace(showid,"");
		deleteid = deleteid.replace(",,",",");
		if(deleteid.indexOf(",") == 0){
			deleteid = deleteid.substr(1);
		}
		if (deleteid.lastIndexOf(",") == deleteid.length - 1) {
			deleteid = deleteid.substring(0, deleteid.length - 1);
		}
		jQuery("#"+fieldid).val(deleteid);
		var leaveNum = jQuery("#"+fieldid).val();
		if(leaveNum == "" || leaveNum == null){
			var upid = fieldid.substr(5);
			jQuery("#field_upload_"+upid).attr("disabled","disabled");
			if (ismand=="1"){
				var needcheck = jQuery("#needcheck").val();
				jQuery("#"+fieldid).val(needcheck+","+fieldid);
				jQuery("#needcheck").attr("viewtype","1");
			}	
		}*/
		
		////
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
					$GetEle(fieldidspannew).innerHTML="（<%=SystemEnv.getHtmlLabelName(18019, user.getLanguage())%>）";
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
					$GetEle(fieldidspannew).innerHTML="（<%=SystemEnv.getHtmlLabelName(18019, user.getLanguage())%>）";
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
	    var swfuploadid=fieldid.replace("field","");
	  //alert("swfuploadid = "+swfuploadid);
	    var fieldidspannew = "field_"+swfuploadid+"span";
	    var fieldidnew = "field"+swfuploadid;
	    var linkrequired=$GetEle("oUpload_"+swfuploadid+"_linkrequired");
	    $GetEle(fieldidspannew).innerHTML="";
        if(Uploadobj.getStats().files_queued==0){
        	$GetEle(fieldidspannew).innerHTML="（<%=SystemEnv.getHtmlLabelName(18019, user.getLanguage())%>）";
			var checkstr_=$GetEle("needcheck").value+",";
			if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
        }
        if(linkrequired && linkrequired.value=="false"){
        	$GetEle(fieldidspannew).innerHTML="";
        }
	  }
	  else
	  {
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
					$GetEle(fieldidspannew).innerHTML="（<%=SystemEnv.getHtmlLabelName(18019, user.getLanguage())%>）";
					var checkstr_=$GetEle("needcheck").value+",";
					if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
			    }
			}
	  	displaySWFUploadError(fieldid);
	  }
  }

function clearAllQueue(oUploadcancle){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())+SystemEnv.getHtmlLabelName(21407,user.getLanguage())%>?", function(){
		//jQuery("#fsUploadProgress"+oUploadId).empty();
		//var oUploadcancle = "oUpload"+oUploadId;
		oUploadcancle.cancelQueue();
	}, function () {}, 320, 90,true);
}

function showtipsinfo(requestid,workflowid,nodeid,isbill,isreject,billid,obj,src){
		var nowtarget = frmmain.target;
		var nowaction = frmmain.action;
        $GetEle("divcontent").value="";
        $GetEle("content").value="";
        $GetEle("src").value=src;
        <%
        //当前为节点操作者 & 下一节点出口包含出口提示信息时
        if ("0".equals(isremark) && WFPathUtil.hasNodeLinkTips(workflowid + "", nodeid + "")) {
        %>
		frmmain.target = "showtipsinfoiframe";
		frmmain.action = "/workflow/request/WorkflowTipsinfo.jsp";
		frmmain.submit();

		frmmain.target = nowtarget;
		frmmain.action = nowaction;
		<%
        } else {
        %>
        showtipsinfoReturn("", src, "", "", "", "");
        <%
        }
        %>
		
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
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
						try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					              if(SaveSignature(src)){
									    //附件上传
					                    StartUploadAll();
					                    checkuploadcomplet();
									}else{
										if(isDocEmpty==1){
											alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
											//自动跳到签字意见锚点
													window.location.hash = "#fsUploadProgressannexuploadSimple";//重置锚点,否则,下次将不能定位

													window.location.hash = null;
													jQuery("#remarkShadowDiv").hide();
													jQuery("#signtabtoolbar").css("display","");
													jQuery("#signrighttool").css("display","");
													jQuery(".signaturebyhand").css("display","");
													isDocEmpty=0;
										}else{
											alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
										}
										return ;
									}
					        }
					    }catch(e){
					        //附件上传
					                    StartUploadAll();
					                    checkuploadcomplet();
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
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
						try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					              if(SaveSignature(src)){
									    //附件上传
					                    StartUploadAll();
					                    checkuploadcomplet();
									}else{
										if(isDocEmpty==1){
											alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
											//自动跳到签字意见锚点
													window.location.hash = "#fsUploadProgressannexuploadSimple";//重置锚点,否则,下次将不能定位

													window.location.hash = null;
													jQuery("#remarkShadowDiv").hide();
													jQuery("#signtabtoolbar").css("display","");
													jQuery("#signrighttool").css("display","");
													jQuery(".signaturebyhand").css("display","");
													isDocEmpty=0;
										}else{
											alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
										}
										return ;
									}
					        }
					    }catch(e){
					        //附件上传
					                    StartUploadAll();
					                    checkuploadcomplet();
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

function checkCarSubmit(){
	var flag = false;
	jQuery.ajax({
	    type:"post",
		url: "/cpt/car/CarSetDataOperation.jsp?action=getDataSys",
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
						data: {field627:field627,field634:field634,field635:field635,field636:field636,field637:field637,workflowid:'<%=workflowid%>',requestid:'<%=requestid%>'},
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



<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/js/wfsp_wev8.js"></script>
<%
String isOldWf=Util.null2String(request.getParameter("isOldWf"));
%>
<%@ include file="/workflow/request/WorkflowViewSignShow.jsp" %>
