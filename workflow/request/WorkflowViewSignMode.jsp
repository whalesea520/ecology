
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.general.TimeUtil"%><!--added by xwj for td2891-->
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.workflow.request.ComparatorUtilBean" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />

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
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />
<jsp:useBean id="RequestLogOperateName" class="weaver.workflow.request.RequestLogOperateName" scope="page"/>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="requestNodeFlow" class="weaver.workflow.request.RequestNodeFlow" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />

<script type="text/javascript" src="/js/ecology8/weaverautocomplete/weaverautocomplete_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/workflowshowpaperchange_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/ecology8/WorkflowViewSignMode_wev8.css" />
<%

/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

String isHrm = Util.null2String((String)session.getAttribute("isHrm")); 

int workflowid = Util.getIntValue(request.getParameter("workflowid"));

int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int desrequestid=Util.getIntValue(request.getParameter("desrequestid"),0);
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();   
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
String isOldWf=Util.null2String(request.getParameter("isOldWf"));
boolean isOldWf_ = false;
if(isOldWf.trim().equals("true")) isOldWf_=true;
boolean wfmonitor=false;                //流程监控人
String isremark=Util.null2String(request.getParameter("isremark"));
int logintype=Util.getIntValue(request.getParameter("logintype"),1);
int ismonitor=Util.getIntValue(request.getParameter("ismonitor"),0);
if(ismonitor==1) wfmonitor=WFUrgerManager.getMonitorViewRight(requestid,userid);
/**流程存为文档是否要签字意见**/
boolean fromworkflowtodoc = Util.null2String((String)session.getAttribute("urlfrom_workflowtodoc_"+requestid)).equals("true");
boolean ReservationSign = false;
RecordSet.executeSql("select * from workflow_base where id = " + workflowid);
if(RecordSet.next()) ReservationSign = (RecordSet.getInt("keepsign")==2);
if(fromworkflowtodoc&&ReservationSign){
	return;
}
/**流程存为文档是否要签字意见**/
%>

<% 
//模板模式查看签字意见从ViewmodeValue.jsp迁移到WorkflowViewSignMode.jsp
//boolean isurger=false;                  //督办人可查看
//isurger=WFUrgerManager.UrgerHaveWorkflowViewRight(requestid,userid,logintype);
boolean isurger = Util.null2String(request.getParameter("isurger")).equalsIgnoreCase("true") ;
boolean isprint = Util.null2String(request.getParameter("isprint")).equalsIgnoreCase("true") ;
int intervenorright=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"intervenorright"),0);

String nodeattr = "";
ArrayList BrancheNodes=new ArrayList();
String billid = Util.null2String(request.getParameter("billid"));
String isbill = Util.null2String(request.getParameter("isbill"));
int formid = Util.getIntValue(request.getParameter("formid"),0);
String _nodeid = Util.null2String(request.getParameter("nodeid"));
String nodetype = Util.null2String(request.getParameter("nodetype"));
int usertype = 0;
if(user.getLogintype().equals("1")) usertype = 0;
if(user.getLogintype().equals("2")) usertype = 1;

int creater = Util.getIntValue((String) session.getAttribute(user.getUID() + "_" + requestid + "creater"), 0);
int creatertype = Util.getIntValue((String) session.getAttribute(user.getUID() + "_" + requestid + "creatertype"), 0);
String creatername= "";
if(creatertype==1){  
	creatername=CustomerInfoComInfo.getCustomerInfoname(""+creater);
}else{
	creatername=ResourceComInfo.getResourcename(""+creater);
}

String intervenoruserids = "";
String intervenoruseridsType="";
String intervenorusernames = "";
int nextnodeid = -1;
int Languageid = Util.getIntValue(request.getParameter("Languageid"));

if((isurger||intervenorright>0) && !isprint){
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


    if (Util.getIntValue(isbill,0) == 1) {
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
		requestNodeFlow.setIsbill(Util.getIntValue(isbill,0));
		requestNodeFlow.setBillid(Util.getIntValue(billid,0));
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
String isannexupload_edit="";
String annexdocCategory_edit="";
String isSignDoc_edit="";
String isSignWorkflow_edit="";
RecordSet.execute("select isannexupload,annexdocCategory,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isannexupload_edit=Util.null2String(RecordSet.getString("isannexupload"));
    annexdocCategory_edit=Util.null2String(RecordSet.getString("annexdocCategory"));
    isSignDoc_edit=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_edit=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
%>

<%if(intervenorright>0){ %>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18913,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18914,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  id="submitNodeId" name=submitNodeId  onChange='nodechange(this.value)'  temptitle="<%=SystemEnv.getHtmlLabelName(18914,user.getLanguage())%>" notBeauty="true">
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
                        tmpname += "("+SystemEnv.getHtmlLabelName(21395,user.getLanguage())+")";
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
			 <span id="Intervenoridspan">
                     
<brow:browser name="Intervenorid" viewType="0" hasBrowser="true"  hasAdd="false"  
	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" width="150px"
    isMustInput="2"  browserSpanValue='<%=intervenorusernames%>'  hasInput="true"
    browserValue='<%=intervenoruserids%>'  
    isSingle="true" />
    
                     <%--
                     <BUTTON type=button  class=Browser onclick="onShowMutiHrm('Intervenoridspan','Intervenorid')" ></button><%=intervenorusernames%><%if(intervenorusernames.equals("")){%><img src='/images/BacoError_wev8.gif' align=absmiddle><%}%></span>
                      --%>
                      </span>
					 <input type=hidden name="IntervenoridType" value="<%=intervenoruseridsType%>">
					  <input type=hidden name="Intervenorid" id="Intervenorid" value="<%=intervenoruserids%>">
					  
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
<% }%>
         
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
         RecordSet.executeProc("workflow_RequestLog_SBUser",""+requestid+flag1+""+user.getUID()+flag1+""+(Util.getIntValue(user.getLogintype())-1)+flag1+"1");
         String myremark = "" ;
         String annexdocids = "" ;
         String signdocids="";
         String signworkflowids="";
         int workflowRequestLogId=-1;
         if(RecordSet.next()){
            myremark = Util.toScreenToEdit(RecordSet.getString("remarkText"),Languageid) ;
            annexdocids=Util.null2String(RecordSet.getString("annexdocids"));
            workflowRequestLogId=Util.getIntValue(RecordSet.getString("requestLogId"),-1);
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
        int vtempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
        for(int i=0;i<templist.size();i++){
                vtempnum++;
                session.setAttribute("resrequestid" + vtempnum, "" + templist.get(i));
            signworkflowname+="<a style=\"cursor:hand\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&isrequest=1&requestid="+templist.get(i)+"&wflinkno="+vtempnum+"')\">"+wfrequestcominfo.getRequestName((String)templist.get(i))+"</a> ";
        }
        session.setAttribute("slinkwfnum", "" + vtempnum);
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
         
         
         String isFormSignature=null;
         int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
         int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
         RecordSet.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight  from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
         if(RecordSet.next()){
         	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
         	formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
         	formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
         }
         int isUseWebRevision_t = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
         if(isUseWebRevision_t != 1){
         	isFormSignature = "";
         }
         String isSignMustInput="0";
         String isHideInput="0";
         RecordSetLog.execute("select issignmustinput,ishideinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
         if(RecordSetLog.next()){
         	isSignMustInput = ""+Util.getIntValue(RecordSetLog.getString("issignmustinput"), 0);
         	isHideInput = ""+Util.getIntValue(RecordSetLog.getString("ishideinput"), 0);
         }
    %>
    <%@ include file="/workflow/request/WorkflowSignInput.jsp" %>
<%}else{%>
<input type="hidden" name="remark" value="">
<input type=hidden name="signdocids" value="">
<input type=hidden name='signworkflowids' value="">
<%}%>

<SCRIPT language="javascript">

function nodechange(value){
	if(value==""){
        _writeBackData('Intervenorid', 2, {id:'',name:''});
    }else{
        var nodeids=value.split("_");
        var selnodeid=nodeids[0];
        var selnodetype=nodeids[1];
        jQuery("#tonodeattr").val(nodeids[2]); 
        if (selnodetype==0) {
			$GetEle("IntervenoridType").value="<%=creatertype%>";
			_writeBackData('Intervenorid', 2, {id:"<%=creater%>",name:"<a href='#<%=creater%>' onclick='pointerXY(event);javaScript:openhrm(<%=creater%>);'><%=creatername%></a>"},{isSingle:false,hasInput:true,replace:true});
        }else{
	        rightMenu.style.display="none";
	        $G("workflownextoperatorfrm").src="/workflow/request/WorkflowNextOperator.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&intervenorright=<%=intervenorright%>&workflowid=<%=workflowid%>&isremark=<%=isremark%>"+
                "&formid=<%=formid%>&isbill=<%=isbill%>&billid=<%=billid%>&creater=<%=creater%>&creatertype=<%=creatertype%>&nodeid="+selnodeid+"&nodetype="+selnodetype;
        }
        $G("submitNodeIdspan").innerHTML="";
    }
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
    //showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,Languageid)%>");
    var ajax=ajaxinit();
    ajax.open("POST", "/workflow/request/WorkflowReceiviedPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&viewnodeIds="+viewLogIds+"&operator="+operator+"&operatedate="+operatedate+"&operatetime="+operatetime+"&returntdid="+returntdid+"&logtype="+logtype+"&destnodeid="+destnodeid);
    //获取执行状态

    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里

        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            document.getElementById(returntdid).innerHTML = ajax.responseText;
            //showTableDiv.style.display='none';
            oIframe.style.display='none';
            }catch(e){}
        }
    }
}
</script>
<script language="VBScript">
sub onShowMutiHrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<A href='javaScript:openhrm("&curid&");' onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
					wend
					sHtml = "<button class=Browser onclick=onShowMutiHrm('Intervenoridspan','Intervenorid') ></button>"&sHtml&"<A href='javaScript:openhrm("&resourceids&");' onclick='pointerXY(event);'>"&resourcename&"</a>"
					document.all(spanname).innerHtml = sHtml

				else
					document.all(spanname).innerHtml ="<button class=Browser onclick=onShowMutiHrm('Intervenoridspan','Intervenorid') ></button><img src='/images/BacoError_wev8.gif' align=absmiddle>"
					document.all(inputename).value=""
				end if
			end if
end sub
</script>
<script type="text/vbscript">
sub onShowSignBrowser(url,linkurl,inputname,spanname,type1)
    tmpids = document.all(inputname).value
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
					document.all(inputname).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_blank'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_blank'>"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml

		else
				    document.all(spanname).innerHtml = empty
					document.all(inputname).value=""
        end if
      end if
end sub
</script>
<style type="text/css">
TABLE.ListStyle tbody tr td {
	padding: 4 5 0 5!important;
}
</style>


<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/js/wfsp_wev8.js"></script>

<%@ include file="/workflow/request/WorkflowViewSignShow.jsp" %>
