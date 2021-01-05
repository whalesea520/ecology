<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<%
int usertype_wfvwt = user.getLogintype().equals("1")?0:1;
%>
<jsp:include page="WorkflowViewWT.jsp" flush="true">
	<jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="userid" value="<%=user.getUID()%>" />
	<jsp:param name="usertype" value="<%=usertype_wfvwt%>" />
	<jsp:param name="languageid" value="<%=user.getLanguage()%>" />
</jsp:include>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
 <jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog1" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog2" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="rssign" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<%@page import = "weaver.general.TimeUtil,java.util.*,weaver.general.Util,weaver.workflow.request.WFWorkflows,weaver.workflow.request.WFWorkflowTypes"%><!--added by xwj for td2891-->
<jsp:useBean id="rsCheckUserCreater" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />

<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<%@ page import="weaver.general.AttachFileUtil" %>
<jsp:useBean id="DocImageManager1" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfoTemp" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="RequestLogOperateName" class="weaver.workflow.request.RequestLogOperateName" scope="page"/>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="requestNodeFlow" class="weaver.workflow.request.RequestNodeFlow" scope="page" />
<%@ page import="weaver.workflow.request.ComparatorUtilBean" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.BaseBean" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<!-- 
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
-->

<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<!--添加插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwfat_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css" rel="stylesheet"></link>
<!-- ckeditor的一些方法在uk中的实现 -->
<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>
<script language=javascript>
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>

<!-- word转html插件 -->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>

<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">
<script type="text/javascript" src="/js/ecology8/weaverautocomplete/weaverautocomplete_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/workflowshowpaperchange_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowshow_wev8.css" />
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowcop_wev8.css" />
<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
<%
boolean isOldWf_ = false;
RecordSetOld.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSetOld.next()){
	if(RecordSetOld.getString("nodeid") == null || "".equals(RecordSetOld.getString("nodeid")) || "-1".equals(RecordSetOld.getString("nodeid"))){
			isOldWf_ = true;
	}
}

String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
userid=user.getUID();
boolean log_isurger=false;                  //是督办人
int log_urger=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"urger"),0);
if(log_urger==1){
WFUrgerManager.setLogintype(Util.getIntValue(user.getLogintype(),1));
WFUrgerManager.setUserid(user.getUID());
WFUrgerManager.setSqlwhere(" EXISTS (select 1 from workflow_requestbase t where a.workflowid=t.workflowid and t.requestid="+requestid+")");
WFUrgerManager.setResultsqlwhere(" c.requestid="+requestid);
ArrayList log_wftypes=WFUrgerManager.getWrokflowTree();
if(log_wftypes.size()>0) log_isurger=true;
}
boolean log_ismonitor=false;                  //是监控人
int log_monitor=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"ismonitor"),0);
if(log_monitor==1){
log_ismonitor=WFUrgerManager.getMonitorViewRight(requestid,user.getUID()); 
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

int log_userid=user.getUID();                   //当前用户id
String log_logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int languageidfromrequest = user.getLanguage();
int log_usertype = 0;
if(log_logintype.equals("1")) log_usertype = 0;
if(log_logintype.equals("2")) log_usertype = 1;
int intervenorright=Util.getIntValue((String)session.getAttribute(log_userid+"_"+requestid+"intervenorright"),0);
int log_formid=Util.getIntValue((String)session.getAttribute(log_userid+"_"+requestid+"formid"),0);
int log_isbill=Util.getIntValue((String)session.getAttribute(log_userid+"_"+requestid+"isbill"),0);
int log_billid=Util.getIntValue((String)session.getAttribute(log_userid+"_"+requestid+"billid"),0);
int log_creater =Util.getIntValue((String)session.getAttribute(log_userid+"_"+requestid+"creater"),0);
int log_creatertype =Util.getIntValue((String)session.getAttribute(log_userid+"_"+requestid+"creatertype"),0);
int log_nodetype = Util.getIntValue((String)session.getAttribute(log_userid+"_"+requestid+"nodetype"),0);
//String creatername=ResourceComInfo.getResourcename(""+log_creater);
String creatername= "";
if(log_creatertype==1){  
	creatername=CustomerInfoComInfo.getCustomerInfoname(""+log_creater);
}else{
	creatername=ResourceComInfo.getResourcename(""+log_creater);
}
String intervenoruserids="";
String intervenoruseridsType="";
String intervenorusernames="";
int nextnodeid=-1;
String nodeattr="";
ArrayList BrancheNodes=new ArrayList();
if(intervenorright>0){
    String billtablename = "";
    int operatorsize = 0;

    WFNodeMainManager.setWfid(workflowid);
    WFNodeMainManager.selectWfNode();
    while(WFNodeMainManager.next()){
        if(WFNodeMainManager.getNodeid()==nodeid) nodeattr=WFNodeMainManager.getNodeattribute();
    }
    if(nodeattr.equals("2")){
        //BrancheNodes=WFLinkInfo.getFlowBrancheNodes(requestid,workflowid);
        BrancheNodes = WFLinkInfo.getFlowBrancheNodes(requestid,workflowid,nodeid);
    }
    boolean hasnextnodeoperator = false;
    Hashtable operatorsht = new Hashtable();


    if (log_isbill == 1) {
			RecordSet.executeSql("select tablename from workflow_bill where id = " + log_formid); // 查询工作流单据表的信息

			if (RecordSet.next())
				billtablename = RecordSet.getString("tablename");          // 获得单据的主表

    }
//查询节点操作者

        requestNodeFlow.setRequestid(requestid);
		requestNodeFlow.setNodeid(nodeid);
		requestNodeFlow.setNodetype(""+log_nodetype);
		requestNodeFlow.setWorkflowid(workflowid);
		requestNodeFlow.setUserid(log_userid);
		requestNodeFlow.setUsertype(log_usertype);
		requestNodeFlow.setCreaterid(log_creater);
		requestNodeFlow.setCreatertype(log_creatertype);
		requestNodeFlow.setIsbill(log_isbill);
		requestNodeFlow.setBillid(log_billid);
		requestNodeFlow.setBilltablename(billtablename);
		requestNodeFlow.setRecordSet(RecordSet);
		hasnextnodeoperator = requestNodeFlow.getNextNodeOperator();

		if(hasnextnodeoperator){
			operatorsht = requestNodeFlow.getOperators();
            nextnodeid=requestNodeFlow.getNextNodeid();
            operatorsize = operatorsht.size();
            if(operatorsize > 0){

                TreeMap map = new TreeMap(new ComparatorUtilBean());
				Enumeration tempKeys = operatorsht.keys();
				try{
				while (tempKeys.hasMoreElements()) {
					String tempKey = (String) tempKeys.nextElement();
					ArrayList tempoperators = (ArrayList) operatorsht.get(tempKey);
					map.put(tempKey,tempoperators);
				}
				}catch(Exception e){}
				Iterator iterator = map.keySet().iterator();
				while(iterator.hasNext()) {
				String operatorgroup = (String) iterator.next();
				ArrayList operators = (ArrayList) operatorsht.get(operatorgroup);
				for (int i = 0; i < operators.size(); i++) {
				    String operatorandtype = (String) operators.get(i);
						String[] operatorandtypes = Util.TokenizerString2(operatorandtype, "_");
						String opertor = operatorandtypes[0];
						String opertortype = operatorandtypes[1];
						String opertorsigntype = operatorandtypes[3];
						if(opertorsigntype.equals("-3")||opertorsigntype.equals("-4")) continue;
                        intervenoruserids+=opertor+",";
						intervenoruseridsType +=opertortype+",";
                        if("0".equals(opertortype)){
						intervenorusernames += "<A href='javaScript:openhrm("+opertor+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename(opertor)+"</A>&nbsp;";
						}else{
						intervenorusernames += CustomerInfoComInfo.getCustomerInfoname(opertor)+" ";
						}

				}
                }
        }
        }
    if(intervenoruserids.length()>1){
        intervenoruserids=intervenoruserids.substring(0,intervenoruserids.length()-1);
		intervenoruseridsType=intervenoruseridsType.substring(0,intervenoruseridsType.length()-1);
    }
%>
<iframe id="workflownextoperatorfrm" frameborder=0 scrolling=no src=""  style="display:none;"></iframe>
<%}
%>

<%
String wfid1 = String.valueOf(workflowid);
String ndid1 = String.valueOf(nodeid);
String isSignMustInput = "0";
RecordSet.executeSql("select issignmustinput from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
}
String isannexupload_edit="";
String annexdocCategory_edit="";
String isSignDoc_edit="";
String isSignWorkflow_edit="";
String showDocTab_edit="";
String showWorkflowTab_edit="";
String showUploadTab_edit="";
RecordSetLog.execute("select isannexupload,annexdocCategory,isSignDoc,isSignWorkflow,showDocTab,showWorkflowTab,showUploadTab from workflow_base where id="+workflowid);
if(RecordSetLog.next()){
    isannexupload_edit=Util.null2String(RecordSetLog.getString("isannexupload"));
    annexdocCategory_edit=Util.null2String(RecordSetLog.getString("annexdocCategory"));
    isSignDoc_edit=Util.null2String(RecordSetLog.getString("isSignDoc"));
    isSignWorkflow_edit=Util.null2String(RecordSetLog.getString("isSignWorkflow"));
    showDocTab_edit=Util.null2String(RecordSetLog.getString("showDocTab"));
    showWorkflowTab_edit=Util.null2String(RecordSetLog.getString("showWorkflowTab"));
    showUploadTab_edit=Util.null2String(RecordSetLog.getString("showUploadTab"));
}
%>
<!-- added end. -->
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<% if(!isprint&&(log_isurger||intervenorright>0||log_ismonitor)){ %>
         <%if(intervenorright>0){ %>
         <wea:layout>
     	<wea:group context='<%=SystemEnv.getHtmlLabelName(18913,user.getLanguage())%>'>
     		<wea:item><%=SystemEnv.getHtmlLabelName(18914,user.getLanguage())%></wea:item>
     		<wea:item>
     			<select class=inputstyle  id="submitNodeId" name=submitNodeId  onChange='nodechange(this.value)'  temptitle="<%=SystemEnv.getHtmlLabelName(18914,user.getLanguage())%>"  notBeauty="true">
                      <option value="" ></option>
                      <%
                      WFNodeMainManager.setWfid(workflowid);
                      WFNodeMainManager.selectWfNode();
                      boolean hasnodeid=false;    
                      String nodeattribute = "0";
                      while(WFNodeMainManager.next()){
                         int tmpid = WFNodeMainManager.getNodeid();
                         //if(tmpid==nodeid) continue;
                         String tmpname = WFNodeMainManager.getNodename();
                         String tmptype = WFNodeMainManager.getNodetype();
                         String tempnodeattr=WFNodeMainManager.getNodeattribute();
                         if(tmpid==nodeid) {
                            nodeattribute = tempnodeattr ;
                        }
                        if(tempnodeattr.equals("2")){//25428
                            tmpname += "("+SystemEnv.getHtmlLabelName(21395,languageidfromrequest)+")";
                        }
                         
                         if(nodeattr.equals("2")){
                             if(!tempnodeattr.equals("2")){
                                 if(tmpid==nextnodeid){
                                     intervenoruserids="";
     								intervenoruseridsType = "";
                                     intervenorusernames="";
                                 }
                                 //continue;
                             }else if(BrancheNodes.indexOf(""+tmpid)==-1){
                                 continue;
                             }
                         }else{
                             if(tempnodeattr.equals("2")){
                                 if(tmpid==nextnodeid){
                                     intervenoruserids="";
     								intervenoruseridsType = "";
                                     intervenorusernames="";
                                 }
                                 continue;
                             }
                         }
                         
                      %>
                      <option value="<%=tmpid%>_<%=tmptype%>_<%=tempnodeattr%>" <%if(nextnodeid==tmpid){hasnodeid=true;%>selected<%}%>><%=tmpname%></option>
                      <%}%>
                      </select>
                      <input type="hidden" id="currentnodeattr" name="currentnodeattr" value="<%=nodeattribute %>" />
                      <input type="hidden" id="tonodeattr" name="tonodeattr" value="0" />
                      <span id="submitNodeIdspan"><%if(!hasnodeid){%><img src='/images/BacoError_wev8.gif' align=absmiddle><%}%></span>
     		</wea:item>
     		
     		<wea:item><%=SystemEnv.getHtmlLabelName(32598,user.getLanguage())%></wea:item>
     		<wea:item>
     			<select class=inputstyle  id="enableIntervenor" name=enableIntervenor>
                      <option value="0" ><%=SystemEnv.getHtmlLabelName(25105,user.getLanguage())%></option>
                      <option value="1" selected="selected"><%=SystemEnv.getHtmlLabelName(25104,user.getLanguage())%></option>
                  </select>
                  <span style="color: red;"><%=SystemEnv.getHtmlLabelName(31483,user.getLanguage())%></span>
     		</wea:item>
     		
     		<wea:item><%=SystemEnv.getHtmlLabelName(21790,user.getLanguage())%></wea:item>
     		<wea:item>
     			<select class=inputstyle  id="SignType" name=SignType>
                      <option value="0" ><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%></option>
                      <option value="1" ><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%></option>
                      <option value="2" ><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%></option>    
                      </select>
     		</wea:item>
     		
     		<wea:item><%=SystemEnv.getHtmlLabelName(18915,user.getLanguage())%></wea:item>
     		<wea:item>
     			 <span id="Intervenorspan">
                          
     <brow:browser name="Intervenorid" viewType="0" hasBrowser="true"  hasAdd="false"  
     	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" width="150px"
         isMustInput="2"  browserSpanValue='<%=intervenorusernames%>'  hasInput="true"
         browserValue='<%=intervenoruserids%>'  
         isSingle="true" />
         
                          <%--
                          <BUTTON type=button  class=Browser onclick="onShowMutiHrm('Intervenorspan','Intervenorid')" ></button><%=intervenorusernames%><%if(intervenorusernames.equals("")){%><img src='/images/BacoError_wev8.gif' align=absmiddle><%}%></span>
                           --%>
                           </span>
     					 <input type=hidden name="IntervenoridType" value="<%=intervenoruseridsType%>">
     					  <%--
                      <input type=hidden name="Intervenorid" value="<%=intervenoruserids%>" temptitle="<%=SystemEnv.getHtmlLabelName(18915,user.getLanguage())%>">
                        --%>
     		</wea:item>
     	</wea:group>
     </wea:layout>
     <script type="text/javascript">
<!--
jQuery(function(){  
    nodechange(jQuery("#submitNodeId").val());
});
//-->
</script>
     <% }
%>

<table width="100%">
<tr>
<td width="50%"  valign="top">
  <table class="viewform">
        <!-- modify by xhheng @20050308 for TD 1692 -->
         <COLGROUP>
         <COL width="20%">
         <COL width="80%">

<%
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
         RecordSet.executeProc("workflow_RequestLog_SBUser",""+requestid+flag1+""+user.getUID()+flag1+""+(Util.getIntValue(user.getLogintype(),1)-1)+flag1+"1");
         String myremark = "" ;
         String annexdocids = "" ;
         String signdocids="";
         String signworkflowids="";
         if(RecordSet.next())
         {
            myremark = Util.null2String(RecordSet.getString("remark")) ;
            annexdocids=Util.null2String(RecordSet.getString("annexdocids"));
            signdocids=Util.null2String(RecordSet.getString("signdocids"));
			signworkflowids=Util.null2String(RecordSet.getString("signworkflowids"));
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
            signworkflowname+="<a style=\"cursor:hand\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&isrequest=1&requestid="+templist.get(i)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)templist.get(i))+"</a> ";
        }
        session.setAttribute("slinkwfnum", "" + tempnum);
        session.setAttribute("haslinkworkflow", "1");
         //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+user.getUID());
         //add by cyril on 2008-09-30 for td:9014
         boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+user.getUID()); 
         String workflowPhrases[] = new String[RecordSet.getCounts()];
         String workflowPhrasesContent[] = new String[RecordSet.getCounts()];
         int x = 0 ;
         if (isSuccess) {
         	while (RecordSet.next()){
         		workflowPhrases[x] = Util.null2String(RecordSet.getString("phraseShort"));
         		workflowPhrasesContent[x] = Util.toHtml(Util.null2String(RecordSet.getString("phrasedesc")));
         		x ++ ;
         	}
         }
         //end by cyril on 2008-09-30 for td:9014
         /*----------xwj for td3034 20051118 begin ------*/
         %>
         <tr class="Title">
                  <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
                </tr>
            <tr>
              <td><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></td>
              <td class=field>
              <%
         if(workflowPhrases.length>0){
         %>
                <select class=inputstyle  id="phraseselect" name=phraseselect style="width:80%" onChange='onAddPhrase(this.value)' onmousewheel="return false;">
                <option value=""><%=SystemEnv.getHtmlLabelName(27024,user.getLanguage())%></option>
                <%
                  for (int i= 0 ; i <workflowPhrases.length;i++) {
                    String workflowPhrase = workflowPhrases[i] ;  %>
                    <option value="<%=workflowPhrasesContent[i]%>"><%=workflowPhrase%></option>
                <%}%>
                </select>
              <%}%>
				<input type="hidden" id="remarkText10404" name="remarkText10404" temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>" value="">
              <textarea  class=Inputstyle name=remark id=remark rows=4 cols=40 style="width:80%"  temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"   <%if(isSignMustInput.equals("1")){%>onChange="checkinput('remark','remarkSpan')"<%}%>><%=myremark%></textarea>
	  		   	<script defer>
	  		   	function funcremark_log(){
					FCKEditorExt.initEditor("frmmain","remark",<%=user.getLanguage()%>,FCKEditorExt.NO_IMAGE, 200);
				<%if(isSignMustInput.equals("1")){%>
					FCKEditorExt.checkText("remarkSpan","remark");
				<%}%>
					FCKEditorExt.toolbarExpand(false,"remark");
				}
				
				if (window.addEventListener){
	  			    window.addEventListener("load", funcremark_log, false);
	  			}else if (window.attachEvent){
	  			    if(ieVersion>=8) window.attachEvent("onload", funcremark_log());
	  		  		else window.attachEvent("onload", funcremark_log);
	  			}else{
	  			    window.onload=funcremark_log;
	  			}	
				
	  		  	
				</script>
              <span id="remarkSpan">
<%
	if(isSignMustInput.equals("1")&&"".equals(myremark)){
%>
			  <img src="/images/BacoError_wev8.gif" align=absmiddle>
<%
	}
%>
              </span>
          </td> </tr>
         <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
  <%
         if("1".equals(isSignDoc_edit)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids" value="<%=signdocids%>">
                <button class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"><%=signdocname%></span>
            </td>
          </tr>
          <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_edit)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids" value="<%=signworkflowids%>">
                <button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"><%=signworkflowname%></span>
            </td>
          </tr>
          <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isannexupload_edit)){
         %>
        <tr>
            <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
            <td class=field>
          <table cols=3 id="field-annexupload_tab">
          <tbody ><col width="50%" >
            <col width="25%" >
            <col width="25%">
           <%
            int linknum=-1;
            if(!annexdocids.equals("")){
            RecordSet.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+annexdocids+") order by id asc");
            while(RecordSet.next()){
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSet.getInt(3);
              String SecCategory=Util.null2String(RecordSet.getString(4));
              DocImageManager1.resetParameter();
              DocImageManager1.setDocid(Util.getIntValue(showid));
              DocImageManager1.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(DocImageManager1.next()){
                //DocImageManager会得到doc第一个附件的最新版本

                docImagefileid = DocImageManager1.getImagefileid();
                docImagefileSize = DocImageManager1.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = DocImageManager1.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = DocImageManager1.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }
              boolean nodownload=SecCategoryComInfo1.getNoDownload(SecCategory).equals("1")?true:false;
              String imgSrc= AttachFileUtil.getImgStrbyExtendName(fileExtendName,16);
              %>

          <tr>
            <input type=hidden name="field-annexupload_del_<%=linknum%>" value="0" >
            <td >
              <%=imgSrc%>
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id=<%=showid%>&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=tempshowname%></a>&nbsp
              <%}%>
              <input type=hidden name="field-annexupload_id_<%=linknum%>" value=<%=showid%>>
            </td>
            <td >
                <button class=btnFlow accessKey=1  onclick='onChangeSharetype("span-annexupload_id_<%=linknum%>","field-annexupload_del_<%=linknum%>","0",oUploadannexupload)'><u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
                </button><span id="span-annexupload_id_<%=linknum%>" name="span-annexupload_id_<%=linknum%>" style="visibility:hidden">
                    <b><font COLOR="#FF0033">√</font></b>
                  <span>
            </td>
            <%if(accessoryCount==1&&!isprint){%>
            <td >
              <span id = "selectDownload">
                <%
                  if((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload){
                %>
                  <button class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	  (<%=docImagefileSize/1000%>K)
                  </button>
                <%}%>
              </span>
            </td>
            <%}%>
          </tr>
              <%}}%>
            <input type=hidden name="field-annexupload_idnum" value=<%=linknum+1%>>
            <input type=hidden name="field-annexupload_idnum_1" value=<%=linknum+1%>>
          <tr>
            <td colspan=3>
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

            button_image_url : "/js/swfupload/add_wev8.png",    // Relative to the SWF file
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
        	//window.attachEvent("onload", fileuploadannexupload);
        	if (window.addEventListener){
  			    window.addEventListener("load", fileuploadannexupload, false);
  			}else if (window.attachEvent){
  			    window.attachEvent("onload", fileuploadannexupload);
  			}else{
  			    window.onload = fileuploadannexupload;
  			}	
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
									<span><img src="/js/swfupload/delete_wev8.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span>(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=annexmaxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                      <span id="field-annexuploadspan"></span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field-annexupload" id="field-annexupload" value="<%=annexdocids%>">
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
           <%}%>
            <input type=hidden name='annexmainId' value=<%=annexmainId%>>
          <input type=hidden name='annexsubId' value=<%=annexsubId%>>
          <input type=hidden name='annexsecId' value=<%=annexsecId%>>
            </td>
          </tr>
          </tbody>
          </table>
        </td>
          </tr>
          <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}%>
        </table>
    </td> </tr>
</table>  
<%}else{%>
<input type="hidden" name="remark" value="">
<input type="hidden" id="signdocids" name="signdocids" value="">
<input type="hidden" id="signworkflowids" name="signworkflowids" value="">
<%}%>
<%
boolean isOldWf = isOldWf_;
%>
<%@ include file="/workflow/request/WorkflowViewSignShow.jsp" %>

<script language="JavaScript">
function nodechange(value){
	if(value==""){
        _writeBackData('Intervenorid', 2, {id:'',name:''});
    }else{
        var nodeids=value.split("_");
        var selnodeid=nodeids[0];
        var selnodetype=nodeids[1];
        jQuery("#tonodeattr").val(nodeids[2]); 
        if (selnodetype==0) {
			$GetEle("IntervenoridType").value="<%=log_creatertype%>";
			_writeBackData('Intervenorid', 2, {id:"<%=log_creater%>",name:"<a href='#<%=log_creater%>' onclick='pointerXY(event);javaScript:openhrm(<%=creater%>);'><%=creatername%></a>"},{isSingle:false,hasInput:true,replace:true});
        }else{
        	rightMenu.style.display="none";
        	document.getElementById("workflownextoperatorfrm").src="/workflow/request/WorkflowNextOperator.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&intervenorright=<%=intervenorright%>&workflowid=<%=workflowid%>"+
                "&formid=<%=formid%>&isbill=<%=isbill%>&billid=<%=billid%>&creater=<%=creater%>&creatertype=<%=creatertype%>&nodeid="+selnodeid+"&nodetype="+selnodetype;
        }
        document.getElementById("submitNodeIdspan").innerHTML="";
    }
}

function showallreceivedforsign(requestid,viewLogIds,operator,operatedate,operatetime,returntdid,logtype,destnodeid){
    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,languageidfromrequest)%>");
    var ajax=ajaxinit();
    ajax.open("POST", "/workflow/request/WorkflowReceiviedPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&viewnodeIds="+viewLogIds+"&operator="+operator+"&operatedate="+operatedate+"&operatetime="+operatetime+"&returntdid="+returntdid+"&logtype="+logtype+"&destnodeid="+destnodeid);
    
    ajax.onreadystatechange = function() {
        
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            document.all(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            showTableDiv.style.display='none';
            oIframe.style.display='none';
        }
    }
}
</script>
<script language="VBScript">
sub onShowMutiHrm(spanname,inputename)
		tmpids = document.getElementById(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.getElementById(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<A href='javaScript:openhrm("&curid&");' onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
					wend
					sHtml = "<button class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button>"&sHtml&"<A href='javaScript:openhrm("&resourceids&");' onclick='pointerXY(event);'>"&resourcename&"</a>"
					document.getElementById(spanname).innerHtml = sHtml

				else
					document.getElementById(spanname).innerHtml ="<button class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button><img src='/images/BacoError_wev8.gif' align=absmiddle>"
					document.getElementById(inputename).value=""
				end if
			end if
end sub
sub onShowSignBrowser(url,linkurl,inputname,spanname,type1)
    tmpids = document.getElementById(inputname).value
    if type1=37 then
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url&"?documentids="&tmpids)
    else
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url&"?resourceids="&tmpids)
    end if
        if NOT isempty(id1) then
		   if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.getElementById(inputname).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_blank'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_blank'>"&resourcename&"</a>&nbsp"
					document.getElementById(spanname).innerHtml = sHtml

		else
				    document.getElementById(spanname).innerHtml = empty
					document.getElementById(inputname).value=""
        end if
      end if
end sub
</script>

<style type="text/css">
TABLE.ListStyle tbody tr td {
	padding: 4 5 0 5!important;
}
</style>



<script language="javascript">
function openSignPrint() {
  var redirectUrl = "PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&urger=<%=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"urger"),0) %>&ismonitor=<%=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"ismonitor"),0) %>" ;
  <%//解决相关流程打印权限问题
  String wflinkno = Util.null2String((String) session.getAttribute(requestid+"wflinkno"));
  if(!wflinkno.equals("")){
  %>
  redirectUrl = "PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&isrequest=1&wflinkno=<%=wflinkno%>&urger=<%=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"urger"),0)%>&ismonitor=<%=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"ismonitor"),0)%>";
  <%}%>
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
szFeatures +="toolbar=yes," ;
  szFeatures +="scrollbars=yes," ;

  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}
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
function showallreceived(requestid,viewLogIds,operator,operatedate,operatetime,returntdid,logtype,destnodeid){
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
        //WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
    }
    else{
        WorkFlowDiv.style.display = "";
        //WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";
    }
}
//屏蔽掉原来接收人显示部分功能  mackjoe at 2006-06-13 td4491
function accesoryChanage(obj,maxUploadImageSize){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        var oFile=$GetEle("oFile");
        oFile.FilePath=objValue;
        fileLenth= oFile.getFileSize();
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
</script>

<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/js/wfsp_wev8.js"></script>
