
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.general.TimeUtil"%><!--added by xwj for td2891-->
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<jsp:useBean id="rssign" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog1" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog2" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="rsCheckUserCreater" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="RequestLogOperateName" class="weaver.workflow.request.RequestLogOperateName" scope="page"/>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="requestNodeFlow" class="weaver.workflow.request.RequestNodeFlow" scope="page" />
<%@ page import="weaver.workflow.request.ComparatorUtilBean" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.BaseBean" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />

<!-- 
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
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

<script type="text/javascript" src="/js/ecology8/weaverautocomplete/weaverautocomplete_wev8.js"></script>

<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/workflowshowpaperchange_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/ecology8/request_wev8.css" />


<%
/*用户验证*/
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();   
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int languageidfromrequest = Util.getIntValue(request.getParameter("languageid"));

int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int desrequestid=Util.getIntValue(request.getParameter("desrequestid"),0);
int usertype=Util.getIntValue(request.getParameter("usertype"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
boolean isprint = Util.null2String(request.getParameter("isprint")).equalsIgnoreCase("true") ;
String isOldWf=Util.null2String(request.getParameter("isOldWf"));
String isurger=Util.null2String(request.getParameter("isurger"));
String wfmonitor=Util.null2String(request.getParameter("wfmonitor"));
int loga_urger=isurger.trim().equals("true")?1:0;
int loga_monitor=wfmonitor.trim().equals("true")?1:0;
int intervenorright=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"intervenorright"),0);
boolean isOldWf_ = false;
if(isOldWf.trim().equals("true")) isOldWf_=true;
%>
 <jsp:include page="WorkflowViewWT.jsp" flush="true">
	<jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="userid" value="<%=userid%>" />
	<jsp:param name="usertype" value="<%=usertype%>" />
	<jsp:param name="languageid" value="<%=languageidfromrequest%>" />
</jsp:include>
<%

/**流程存为文档是否要签字意见**/
boolean fromworkflowtodoc = Util.null2String((String)session.getAttribute("urlfrom_workflowtodoc_"+requestid)).equals("true");
boolean ReservationSign = false;
RecordSet.executeSql("select * from workflow_base where id = " + workflowid);
if(RecordSet.next()) ReservationSign = (RecordSet.getInt("keepsign")==2);
if(fromworkflowtodoc&&ReservationSign){
	return;
}
/**流程存为文档是否要签字意见**/

String reportid = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"reportid"));
String isfromreport = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isfromreport"));
String isfromflowreport = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isfromflowreport"));
//添加流程共享查看签字意见权限
String iswfshare = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"iswfshare"));

int nodetype = Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"nodetype"),0);
int formid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"formid"),0);
int isbill=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"isbill"),0);
int billid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"billid"),0);
int creater =Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"creater"),0);
int creatertype =Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"creatertype"),0);
String creatername= "";
if(creatertype==1){  
	creatername=CustomerInfoComInfo.getCustomerInfoname(""+creater);
}else{
	creatername=ResourceComInfo.getResourcename(""+creater);
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
        BrancheNodes=WFLinkInfo.getFlowBrancheNodes(requestid,workflowid);
    }
    boolean hasnextnodeoperator = false;
    Hashtable operatorsht = new Hashtable();


    if (isbill == 1) {
			RecordSet.executeSql("select tablename from workflow_bill where id = " + formid); // 查询工作流单据表的信息


			if (RecordSet.next())
				billtablename = RecordSet.getString("tablename");          // 获得单据的主表


    }
//查询节点操作者


        requestNodeFlow.setRequestid(requestid);
		requestNodeFlow.setNodeid(nodeid);
		requestNodeFlow.setNodetype(""+nodetype);
		requestNodeFlow.setWorkflowid(workflowid);
		requestNodeFlow.setUserid(userid);
		requestNodeFlow.setUsertype(usertype);
		requestNodeFlow.setCreaterid(creater);
		requestNodeFlow.setCreatertype(creatertype);
		requestNodeFlow.setIsbill(isbill);
		requestNodeFlow.setBillid(billid);
		requestNodeFlow.setBilltablename(billtablename);
		requestNodeFlow.setRecordSet(RecordSet);
		requestNodeFlow.setIsintervenor("1");
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
User user2 = HrmUserVarify.getUser (request , response) ;
if(user2 == null)  return ;
String wfid1 = String.valueOf(workflowid);
String ndid1 = String.valueOf(nodeid);
String isSignMustInput = "0";
String isHideInput="0";
RecordSet.executeSql("select issignmustinput,ishideinput from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
	isHideInput = ""+Util.getIntValue(RecordSet.getString("ishideinput"), 0);
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
<style type="text/css">
TABLE.ListStyle tbody tr td {
	padding: 4 5 0 5!important;
}
</style>
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%;display:none' valign='top'>
</div>
<% if(!isprint&&(isurger.trim().equals("true")||intervenorright>0)){ %>

<%if(intervenorright>0){ %>
<wea:layout>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(18913,languageidfromrequest)%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(18914,languageidfromrequest)%></wea:item>
		<wea:item>
			<select class=inputstyle  id="submitNodeId" name=submitNodeId  onChange='nodechange(this.value)'  temptitle="<%=SystemEnv.getHtmlLabelName(18914,languageidfromrequest)%>">
                 <option value="" ></option>
                 <%
                 WFNodeMainManager.setWfid(workflowid);
                 WFNodeMainManager.selectWfNode();
                 boolean hasnodeid=false;    
                 while(WFNodeMainManager.next()){
                    int tmpid = WFNodeMainManager.getNodeid();
                    //if(tmpid==nodeid) continue;
                    String tmpname = WFNodeMainManager.getNodename();
                    String tmptype = WFNodeMainManager.getNodetype();
                    String tempnodeattr=WFNodeMainManager.getNodeattribute();
                    if(nodeattr.equals("2")){
                        if(!tempnodeattr.equals("2")){
                            if(tmpid==nextnodeid){
                                intervenoruserids="";
								intervenoruseridsType = "";
                                intervenorusernames="";
                            }
                            continue;
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
                 <option value="<%=tmpid%>_<%=tmptype%>" <%if(nextnodeid==tmpid){hasnodeid=true;%>selected<%}%>><%=tmpname%></option>
                 <%}%>
                 </select>
                 <span id="submitNodeIdspan"><%if(!hasnodeid){%><img src='/images/BacoError_wev8.gif' align=absmiddle><%}%></span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(32598,languageidfromrequest)%></wea:item>
		<wea:item>
			<select class=inputstyle  id="enableIntervenor" name=enableIntervenor>
                 <option value="0" ><%=SystemEnv.getHtmlLabelName(25105,languageidfromrequest)%></option>
                 <option value="1" selected="selected"><%=SystemEnv.getHtmlLabelName(25104,languageidfromrequest)%></option>
             </select>
             <span style="color: red;"><%=SystemEnv.getHtmlLabelName(31483,languageidfromrequest)%></span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(21790,languageidfromrequest)%></wea:item>
		<wea:item>
			<select class=inputstyle  id="SignType" name=SignType>
                 <option value="0" ><%=SystemEnv.getHtmlLabelName(15556,languageidfromrequest)%></option>
                 <option value="1" ><%=SystemEnv.getHtmlLabelName(15557,languageidfromrequest)%></option>
                 <option value="2" ><%=SystemEnv.getHtmlLabelName(15558,languageidfromrequest)%></option>    
                 </select>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(18915,languageidfromrequest)%></wea:item>
		<wea:item>
			 <span id="Intervenorspan">
                     
<brow:browser name="Intervenorid" viewType="0" hasBrowser="true"  hasAdd="false"  
	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" width="auto"
    isMustInput="2"  browserSpanValue="<%=intervenorusernames%>"  hasInput="true"
    browserValue="<%=intervenoruserids%>"  completeUrl="/data.jsp"
    isSingle="false" />
    
                     <%--
                     <BUTTON type=button  class=Browser onclick="onShowMutiHrm('Intervenorspan','Intervenorid')" ></button><%=intervenorusernames%><%if(intervenorusernames.equals("")){%><img src='/images/BacoError_wev8.gif' align=absmiddle><%}%></span>
                      --%>
                      </span>
					 <input type=hidden name="IntervenoridType" value="<%=intervenoruseridsType%>">
					  <%--
                 <input type=hidden name="Intervenorid" value="<%=intervenoruserids%>" temptitle="<%=SystemEnv.getHtmlLabelName(18915,languageidfromrequest)%>">
                   --%>
		</wea:item>
	</wea:group>
</wea:layout>
<% } %>

         
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
         RecordSet.executeProc("workflow_RequestLog_SBUser",""+requestid+flag1+""+userid+flag1+""+usertype+flag1+"1");
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
            signworkflowname+="<a style=\"cursor:pointer\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&isrequest=1&requestid="+templist.get(i)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)templist.get(i))+"</a> ";
        }
        session.setAttribute("slinkwfnum", "" + tempnum);
        session.setAttribute("haslinkworkflow", "1");
         //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
         //add by cyril on 2008-09-30 for td:9014
         boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+userid); 
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
         //表单签章
         String isFormSignature = "0";
         String formSignatureWidth = "";
         String formSignatureHeight = "";
         String logintype = "";
         String workflowRequestLogId = "";
         //end by cyril on 2008-09-30 for td:9014
         /*----------xwj for td3034 20051118 begin ------*/
         %>
        <%@ include file="/workflow/request/WorkflowSignInput.jsp" %>

<%} else{%>
<input type="hidden" name="remark" value="">
<input type="hidden" id="signdocids" name="signdocids" value="">
<input type="hidden" id="signworkflowids" name="signworkflowids" value="">
<%}%>

<%
		int printmodeid=0;
		int modeprintdes=0;
		RecordSet.executeSql("select printdes from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
		if(RecordSet.next()){
			modeprintdes=Util.getIntValue(Util.null2String(RecordSet.getString("printdes")),0);
		}
		if(  modeprintdes!=1){
		    RecordSet.executeSql("select id from workflow_nodemode where isprint='1' and workflowid="+workflowid+" and nodeid="+nodeid);
		    if(RecordSet.next()){
		    	printmodeid=RecordSet.getInt("id");
		    }else{
		        RecordSet.executeSql("select id from workflow_formmode where formid="+formid+" and isbill='"+isbill+"' order by isprint desc");
		        while(RecordSet.next()){
		            if(printmodeid<1){
		            	printmodeid=RecordSet.getInt("id");
		            }
		        }
		    }
		}
		%>
		<!-- 点击打印按钮 存在打印模板时使用以此隐藏打印时的主窗口 -->
		<iframe style="display: none;visibility: hidden;" id="loadprintmodeFrame" src="" onload="jQuery('#loading',parent.document).hide();" onreadystatechange="jQuery('#loading',parent.document).hide();">
		</iframe>

<script language="javascript">
function openSignPrint() {
  var redirectUrl = "PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&urger=<%=loga_urger%>&ismonitor=<%=loga_monitor%>" ;
  <%//解决相关流程打印权限问题
  String wflinkno = Util.null2String((String) session.getAttribute(requestid+"wflinkno"));
  if(!wflinkno.equals("")){
  %>
  redirectUrl = "PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&isrequest=1&wflinkno=<%=wflinkno%>&urger=<%=loga_urger%>&ismonitor=<%=loga_monitor%>";
  <%}%>
//解决报表相关流程打印权限问题
  <%
  if(isfromreport.equals("1") &&  requestid != 0){
  %>
  redirectUrl = "PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&urger=<%=loga_urger%>&ismonitor=<%=loga_monitor%>&isfromreport=1&reportid=<%=reportid%>";
  <%
  }else if(isfromflowreport.equals("1") && requestid != 0){
  %>
  redirectUrl = "PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&urger=<%=loga_urger%>&ismonitor=<%=loga_monitor%>&isfromflowreport=1&reportid=<%=reportid%>";
  <%
  }else if(iswfshare.equals("1")){
  %>
  redirectUrl = "PrintRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&urger=<%=loga_urger%>&ismonitor=<%=loga_monitor%>&iswfshare=1";
  <%
  }
  %>
  var printmodeid="<%=printmodeid%>";
  if(parseInt(printmodeid)>0){
  	printModePreview("loadprintmodeFrame",redirectUrl);
  	return ;
  }
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
function showallreceivedforsign(requestid,viewLogIds,operator,operatedate,operatetime,returntdid,logtype,destnodeid){
    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,languageidfromrequest)%>");
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
        //WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,languageidfromrequest)%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,languageidfromrequest)%></span>";
    }
    else{
        WorkFlowDiv.style.display = "";
        //WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,languageidfromrequest)%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,languageidfromrequest)%></span>";
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
		if(e.message=="Type mismatch"||e.message=="类型不匹配"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,languageidfromrequest)%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,languageidfromrequest)%> ");
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
     	alert("<%=SystemEnv.getHtmlLabelName(20254,languageidfromrequest)%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,languageidfromrequest)%>"+maxUploadImageSize+"M<%=SystemEnv.getHtmlLabelName(20256 ,languageidfromrequest)%>");
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
          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+$GetEle(accname+'_num').value+"' onchange='accesoryChanage(this,"+maxsize+")'> (<%=SystemEnv.getHtmlLabelName(18976,languageidfromrequest)%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,languageidfromrequest)%>) ";
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

function nodechange(value){
    if(value==""){
        _writeBackData('Intervenorid', 2, {id:'',name:''});
    }else{
        var nodeids=value.split("_");
        var selnodeid=nodeids[0];
        var selnodetype=nodeids[1];
        if (selnodetype==0) {
			$GetEle("IntervenoridType").value="<%=creatertype%>";
			_writeBackData('Intervenorid', 2, {id:"<%=creater%>",name:"<a href='#<%=creater%>' onclick='pointerXY(event);javaScript:openhrm(<%=creater%>);'><%=creatername%></a>"},{isSingle:false,hasInput:true,replace:true});
        }else{
        rightMenu.style.display="none";
        $GetEle("workflownextoperatorfrm").src="/workflow/request/WorkflowNextOperator.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&intervenorright=<%=intervenorright%>&workflowid=<%=workflowid%>"+
                "&formid=<%=formid%>&isbill=<%=isbill%>&billid=<%=billid%>&creater=<%=creater%>&creatertype=<%=creatertype%>&nodeid="+selnodeid+"&nodetype="+selnodetype;
        }
        $GetEle("submitNodeIdspan").innerHTML="";
    }
}
</script>

<script type="text/javascript">

function onShowMutiHrm(spanname,inputename) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" + $GetEle(inputename).value);
    if (id) {
        if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
            resourceids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
            resourcename = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
            sHtml = "";
            $G(inputename).value = resourceids;
            
            var idArray = resourceids.split(",");
            var nameArray = resourcename.split(",");
            for (var i=0; i<idArray.length; i++ ) {
	            var curid = idArray[i];
	            var curname = nameArray[i];
	            sHtml = sHtml + "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
            }
            sHtml = "<BUTTON type=button  class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button>" + sHtml;
            $G(spanname).innerHTML = sHtml;
        } else {
            $G(spanname).innerHTML ="<BUTTON type=button  class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button><img src='/images/BacoError_wev8.gif' align=absmiddle>";
            $G(inputename).value = "";
        }
    }
}

/*
function onShowSignBrowser(url,linkurl,inputname,spanname,type1) {
	var tmpids = $G(inputname).value;
	var id = null;
    if (type1 == 37) {
    	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url + "?documentids=" + tmpids);
    } else {
    	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url + "?resourceids=" + tmpids);
    }

    if (id) {
        if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
            resourceids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
            resourcename = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
            sHtml = "";
            $G(inputename).value = resourceids;
            
            var idArray = resourceids.split(",");
            var nameArray = resourcename.split(",");
            for (var i=0; i<idArray.length; i++ ) {
	            var curid = idArray[i];
	            var curname = nameArray[i];
	            sHtml = sHtml + "<a href="+ linkurl + curid + " target='_blank'>" + curname + "</a>+nbsp";
            }
            $G(spanname).innerHTML = sHtml;
        } else {
            $G(spanname).innerHTML ="";
            $G(inputname).value = "";
        }
    }
}
*/
</script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/js/wfsp_wev8.js"></script>
<%
String viewLogIds = "";
RecordSetLog.executeSql("SELECT nodeid FROM workflow_flownode WHERE workflowid= "+workflowid+" AND EXISTS(SELECT 1 FROM workflow_nodebase WHERE id=workflow_flownode.nodeid AND (requestid IS NULL OR requestid="+ requestid + "))");
while (RecordSetLog.next()) {
	viewLogIds += "," + RecordSetLog.getString("nodeid");
}
if(!"".equals(viewLogIds) && viewLogIds.length()>1){
	if(viewLogIds.startsWith(",")){
		viewLogIds = viewLogIds.substring(1,viewLogIds.length());
	}
}
%>

<jsp:include page="WorkflowViewSignMore.jsp" flush="true">
     <jsp:param name="workflowid" value="<%=workflowid%>" />
     <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
     <jsp:param name="requestid" value="<%=requestid%>" />
     <jsp:param name="userid" value="<%=userid%>" />
     <jsp:param name="usertype" value="<%=usertype%>" />
     <jsp:param name="isprint" value="<%=isprint%>" />
     <jsp:param name="nodeid" value="<%=nodeid%>" />
     <jsp:param name="isOldWf" value="<%=isOldWf%>" />
     <jsp:param name="desrequestid" value="<%=desrequestid%>" />
     
     <jsp:param name="pgnumber" value="1" />
     <jsp:param name="viewLogIds" value="<%=viewLogIds%>" />
     <jsp:param name="wfsignlddtcnt" value="10000" />
 </jsp:include>
            