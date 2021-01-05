
<%@ page import="weaver.file.FileUpload" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.docs.docs.DocComInfo" %>
<%@page import="weaver.workflow.request.RequestComInfo" %>
<%@page import="weaver.docs.docs.DocImageManager"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.odoc.workflow.workflow.beans.FormSignatueConfigInfo" %>
<%@ page import="weaver.odoc.workflow.workflow.beans.ShortCutButtonConfigInfo" %>

<jsp:useBean id="FormSignatureConfigUtil" class="weaver.odoc.workflow.workflow.utils.FormSignatureConfigUtil" scope="page" />

<link type="text/css" rel="stylesheet" href="/css/ecology8/WorkflowSignInput_wev8.css">
<script src="/wui/common/jquery/plugin/at/js/jquery.atwho_wev8.js"></script>
<script src="/wui/common/jquery/plugin/at/js/jquery.caret_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/weaverautocomplete/weaverautocomplete_wev8.js"></script>
<script type="text/javascript">
function initSignature(obj){
   jQuery(obj).parent().hide();
   jQuery("#signrighttool").css("display","");
   jQuery(".signaturebyhand").css("display","");
   jQuery("#signtabtoolbar").css("display","");
}
function initRemark(isinit){
    jQuery("#remarkShadowDiv").hide();
    jQuery(".remarkDiv").show();
    if (!!!isinit) {
        remarkfocus();
    }
}
/**
 * 使签字意见获取焦点
 */
function remarkfocus() {
    if (window._isremarkcomp == false) {
        setTimeout(function () {
            remarkfocus();
        }, 200);
        return;
    }
    var _ue = UE.getEditor('remark');
    _ue.focus(true);
    if (!!window.UEDITOR_CONFIG && !isNaN(window.UEDITOR_CONFIG.remarkfontsize)) {
        _ue.execCommand('fontsize', window.UEDITOR_CONFIG.remarkfontsize + "px");
    }
    if (!!window.UEDITOR_CONFIG && !!window.UEDITOR_CONFIG.remarkfontsize) {
        _ue.execCommand('fontfamily', window.UEDITOR_CONFIG.remarkfontfamily );
    }
}
</script>
<style type="text/css">
._signinputphraseblockClass .progressBarInProgress {
	height:5px;
	background:#e33633;
	margin:0!important;
}
._signinputphraseblockClass .progressWrapper {
	height:30px!important;
	width:100%!important;
}
._signinputphraseblockClass .progressContainer  {
	background-color:#FFFFFF!important;
	border:solid 0px!important;
	padding-left:0px!important;
	margin-top:3px!important;
}
._signinputphraseblockClass .progressCancel {
	display:none!important;
}
._signinputphraseblockClass .progressBarStatus {
	display:none!important;
}
._signinputphraseblockClass .edui-for-wfannexbutton{
	cursor:pointer!important;
}
._signinputphraseblockClass .progressName{
	width:140px!important;
	height:18px;
	font-size:12px;
	font-family:微软雅黑;
	font-weight:normal!important;
	white-space:nowrap;
	overflow:hidden;
	text-overflow:ellipsis;
	color:#000;
}
</style>
<%
    int workflowIdNew = 0;
    try {
        workflowIdNew = Util.getIntValue(workflowid+"",0);
    } catch (Exception e) {}
    int requestIdNew = 0;
    try {
        requestIdNew = Util.getIntValue(requestid+"",0);
    } catch (Exception e) {}
    int nodeIdNew = 0;
    try {
        nodeIdNew = Util.getIntValue(nodeid+"",0);
    } catch (Exception e) {}
    RecordSet.writeLog("WorkflowSignInput.jsp requestId="+requestIdNew+",workflowId="+workflowIdNew+",nodeId="+nodeIdNew);
    FormSignatueConfigInfo formSignatueConfig = FormSignatureConfigUtil.getFormSignatureConfig(workflowIdNew,nodeIdNew,user);
    List<ShortCutButtonConfigInfo> shortCutButtonConfigList = formSignatueConfig.getShortCutButtonConfig();
    int formSignatureWidthInt = formSignatueConfig.getFormSignatureWidth();
    int formSignatureHeightInt = formSignatueConfig.getFormSignatureHeight();
%>

<%
if (!"1".equals(isFormSignature)) {
%>
<script type="text/javascript" src="/ueditor/custbtn/appwfPhraseBtn_wev8.js"></script>

<%
}

String remarkLocation = "";

boolean isSystemBill =false;
String ___isbill = (String)session.getAttribute("__isbill");
String ___formid = Util.null2String(session.getAttribute("__formid"));
if(!___formid.equals("")&& Integer.parseInt(___formid)>0 && ___isbill.equals("1")){
	isSystemBill = true;
}
if(!isSystemBill){
%>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/applocation_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/mapOperation.js"></script>
<input type="hidden" name="remarkLocation" id="remarkLocation" value=""></input>
<%}
char flag2 = Util.getSeparator();
int usertype2 = user.getLogintype().equals("1")?0:1;



if(session.getAttribute("__remarkLocation") != null){
    remarkLocation = (String)session.getAttribute("__remarkLocation");
}else{
    RecordSet.executeProc("workflow_RequestLog_SBUser",""+requestid+flag2+""+userid+flag2+""+usertype2+flag2+"1");
    if(RecordSet.next()){
        remarkLocation = Util.null2String(RecordSet.getString("remarkLocation"));
    } 
    
}

if(session.getAttribute("__remarkLocation") != null){
   	session.removeAttribute("__remarkLocation");
}

if(!remarkLocation.equals("") && !isSystemBill){
%>
	<script>
	jQuery(function(){
		jQuery('#remarkLocation').val('<%=remarkLocation %>');
	})


	</script>
<%}
if ("1".equals(isSignWorkflow_edit) || "1".equals(isannexupload_edit) || "1".equals(isSignDoc_edit)) {
    
    if ("1".equals(isSignWorkflow_edit)) {
        %>
        <script type="text/javascript" src="/ueditor/custbtn/appwf_wf_wev8.js"></script>
       	<%
        }
	    if ("1".equals(isSignDoc_edit)) {
	    %>
	    <script type="text/javascript" src="/ueditor/custbtn/appwf_doc_wev8.js"></script>
	   	<% 
	    }
    
    	if ("1".equals(isannexupload_edit)) {
        %>
    	<script type="text/javascript" src="/ueditor/custbtn/appwf_fileupload_wev8.js"></script>		
<script language=javascript>
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>
    	<%
        }
%>
<%
}
%>

<script>
atitems=[];

var phrasesdata = []; 
</script>

<%
FileUpload fu2 = new FileUpload(request);
String f_weaver_belongto_userid2=fu2.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype2=fu2.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid2, f_weaver_belongto_usertype2) ;//需要增加的代码
userid=user.getUID(); 
String tempbeagenter = "" + userid;
//获得被代理人
RecordSet.executeSql("select agentorbyagentid, agenttype from workflow_currentoperator where usertype=0 and isremark in ('0', '1', '7', '8', '9')  and requestid=" + requestid + " and userid=" + userid+ " order by isremark, id");
if (RecordSet.next()) {
    int beagenter2 = RecordSet.getInt(1);
    int tempagenttype = RecordSet.getInt(2); 
    if (tempagenttype == 2 && beagenter2 > 0)
        tempbeagenter = "" + beagenter2;
}
ResourceComInfo rescominfo = new ResourceComInfo();
DocComInfo doccominfo = new DocComInfo();
String  docnames = doccominfo.getMuliDocName2(signdocids);
docnames = docnames.replaceAll("<br>","&nbsp;&nbsp;").replaceAll("<a","<a style=\"color:#123885;\"");
RequestComInfo wfcominfo = new RequestComInfo();
String workflownames = "";
String annexnames = "";
String[] tempWfArray = Util.TokenizerString2(signworkflowids, ",");
if(null != tempWfArray&&tempWfArray.length>0){
	for (String tempwfid:tempWfArray) {
		workflownames += "<a style=\"color:#123885;\" href='/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype2+"&requestid="+tempwfid+"&isrequest=1' target='_blank'>"+wfcominfo.getRequestname(tempwfid) + "</a>&nbsp;&nbsp;";
	}
}
String fieldannexuploadname = "";
DocImageManager docImageManager = new DocImageManager();
tempWfArray = Util.TokenizerString2(annexdocids, ",");
for (String annexid:tempWfArray) {
	if("".equals(annexid)){
		continue;
	}
    docImageManager.resetParameter();
    docImageManager.setDocid(Integer.parseInt(annexid));
    docImageManager.selectDocImageInfo();  
    if (docImageManager.next()) {
		annexnames += "<a style=\"color:#123885;\"  href='javascript:void(0);' onclick=\"parent.openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=" + annexid + "&isrequest=1&requestid="+requestid+"&desrequestid=0')\">" + docImageManager.getImagefilename() + "</a>&nbsp;&nbsp;";
		annexnames += "<button class=\"wffbtn\" type='button' accesskey=\"1\" onclick=\"addDocReadTag('" + annexid + "');top.location='/weaver/weaver.file.FileDownload?fileid=" + annexid + "&download=1&requestid="+requestid+"&desrequestid=0&fromrequest=1'\" style='color:#123885;border:0px;line-height:20px;font-size:12px;padding:3px;background:rgb(248, 248, 248);'>["+SystemEnv.getHtmlLabelName(258, user.getLanguage()) + docImageManager.getImageFileSize(Integer.parseInt(annexid)) + "KB]</button>&nbsp;&nbsp;<br>";
		if(fieldannexuploadname.equals("")){
			fieldannexuploadname = docImageManager.getImagefilename();
		}else{
			fieldannexuploadname += "////~~weaversplit~~////"+docImageManager.getImagefilename();
		}
    }
}
String tempbeagentername = rescominfo.getResourcename(tempbeagenter);
%>
<!-- added end. -->
<%--added by xwj for td 2104 on 2005-08-1 begin--%>
<div id="_wfsigninputIvt" style="height:20px!important;width:1px!important;">
</div>
<div id="imagesing" style="color: #444; background: #f2f2f2; cursor: pointer; height: 31px; border-top: 1px solid #cccccc; line-height: 31px; display: none; " onclick="showSignInputBlock(false)" title="<%=SystemEnv.getHtmlLabelName(84396,user.getLanguage())%>"> 
    &nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>  
     <%
     if (!tempbeagenter.equals(userid + "")) {
     %>
    <span style="color:#c6c6c6;margin-left:10px;">
        <%=SystemEnv.getHtmlLabelName(84397,user.getLanguage())%><span style="color:#3f91ff;margin:0 2px;"><%=tempbeagentername %></span><%=SystemEnv.getHtmlLabelName(84398,user.getLanguage())%>
    </span>
    <%} %>
    <div style="width: 20px; height: 100%; float: right;margin-right:10px;"> <img src="/wui/theme/ecology8/templates/default/images/1_wev8.png" style="cursor: pointer;"> </div>
</div>
<div class='flowsign' style='z-index: 10;'>
    <!-- 
    <div class='signstatus' style='position: absolute; right: 15px; top: 15px; cursor: pointer; display: none;'> <img class='signspread' src='/images/wf/spread_wev8.png'> </div>
     -->
    <!--上传进度区域(非签章)-->
    <div class="fieldset flash" id="fsUploadProgressannexuploadSimple" style='position: absolute; left: 10px; width: 300px; opacity: 1;'> </div>
    <%
    //手写签章
    %>
    	<table cellspacing="0" cellpadding="0" width="100%" border="0">
                        <COLGROUP>
                        <%
						//手写签章
					    if ("1".equals(isFormSignature)) {
					    %>
                        <COL width="<%=formSignatureWidthInt %>">
                        <%}%>
                        <COL width="*">
                        </COLGROUP>
						<%
						//手写签章
					    if ("1".equals(isFormSignature)&&!"1".equals(isHideInput)){
					    %>
					    <tr id = "signtabtoolbar" style="display: none;">
					    <td colspan="2">
					     <table id="tooltab" height="30px" width="100%" cellspacing="0" cellpadding="0" align="center" style="background:rgb(240, 240, 238);">
				          <tbody >

				          <tr  height='30px'>
				            <td style="vertical-align: middle;">
                                <span style="vertical-align: middle;margin-right:40px;margin-left:15px;cursor:default" title="" >
                                    <%=SystemEnv.getHtmlLabelName( 17614 ,user.getLanguage())%>
                                </span>
                            <% 
                            for(ShortCutButtonConfigInfo btnConfig : shortCutButtonConfigList) {
                                if(!btnConfig.isOpen()) {
                                    continue;
                                }
                                if(btnConfig.getId() == 1) {
                            %>
                                <img src="/images/sign/opensign_wev8.png" style="vertical-align: middle;" onClick="if (!Consult.OpenSignature()){alert(Consult.Status);}">
                                <a title="" onClick="if (!Consult.OpenSignature()){alert(Consult.Status);}" style="vertical-align: middle;">
                                    <%=SystemEnv.getHtmlLabelName(21431,user.getLanguage())%>
                                </a>
                            <% 
                                } else if(btnConfig.getId() == 2) {
                            %>
                                    <img src="/images/sign/filesign_wev8.png" style="vertical-align: middle;" onclick="if (Consult.EditType==0){Consult.EditType=1;}else{Consult.EditType=0;};">
                                    <a onclick="if (Consult.EditType==0){Consult.EditType=1;}else{Consult.EditType=0;};" style="vertical-align: middle;">
                                        <%=SystemEnv.getHtmlLabelName(21441,user.getLanguage())%>
                                    </a>
                            <%         
                                } else if(btnConfig.getId() == 3) {
                            %>
                                    <img src="/images/sign/signlist_wev8.png" style="vertical-align: middle;" onClick="Consult.ShowSignature();">
                                    <a title="" onClick="Consult.ShowSignature();" style="vertical-align: middle;">
                                        <%=SystemEnv.getHtmlLabelName(21432,user.getLanguage())%>
                                    </a>
                            <%         
                                } else if(btnConfig.getId() == 4) {
                            %>
                                    <img src="/images/sign/cancel_wev8.png" style="vertical-align: middle;" onclick="Consult.Clear();">
                                    <a onclick="Consult.Clear();" style="vertical-align: middle;">
                                        <%=SystemEnv.getHtmlLabelName(21433,user.getLanguage())%>
                                    </a>
                            <%        
                                } else if(btnConfig.getId() == 5) {
                            %>
                                    <img src="/images/sign/cancelbox_wev8.png" style="vertical-align: middle;" onclick="Consult.ClearAll();">
                                    <a onclick="Consult.ClearAll();" style="vertical-align: middle;">
                                        <%=SystemEnv.getHtmlLabelName(21434,user.getLanguage())%>
                                    </a>
                            <%         
                                } else if(btnConfig.getId() == 6) {
                            %>
                                    <img src="/images/sign/trigger_wev8.png" style="vertical-align: middle;" onclick="chgReadSignatureType();">
                                    <a onclick="chgReadSignatureType();" style="vertical-align: middle;">
                                        <%=SystemEnv.getHtmlLabelName(21435,user.getLanguage())%>
                                    </a>
                            <% 
                                } else if(btnConfig.getId() == 7) {
                            %>
                                    <img src="/images/sign/trigger_wev8.png" style="vertical-align: middle;" onclick="Consult.ShowZoomInHandWrite();">
                                    <a onclick="Consult.ShowZoomInHandWrite();" style="vertical-align: middle;">
                                        <%=SystemEnv.getHtmlLabelName(131881,user.getLanguage())%>
                                    </a>
                            <%         
                                }    
                            } 
                            %>
				            </td>
				          </tr>
				          </tbody>
				          </table>
					    </td>
					    </tr>
			    		<tr>       
			              <td>     
			                <div id="remarkShadowDiv" style="display:inline-block;width:100%;border: 1px solid #cccccc;">
                                	<div id="remarkShadowDiv1" style="margin:10px 10px;height:30px;border:1px solid #d6d6d6;background:#fff;color:#a2a2a2;cursor:pointer;<%=isSignMustInput.equals("1") ? "border-left:2px solid #fe4e4c;" : ""%>" onclick="initSignature(this)" title="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%> ">
	                                	<span style="margin:0 5px;"><img style="vertical-align:middle;" src="/images/sign/sign_wev8.png"></img></span>
	                                	<span style="line-height:30px;">
	                                	<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%> 
	                                	
	                                	<%
	                                	if (!tempbeagenter.equals(userid + "")) {
                                        %>
                                          	 （<%=SystemEnv.getHtmlLabelName(84397,user.getLanguage())%> <%=tempbeagentername %><%=SystemEnv.getHtmlLabelName(84398,user.getLanguage())%> ）


                                        <%}
	                                	%>
	                                	</span>
                                	</div>
                           		</div>
			                <div class='signaturebyhand' style="display: none">
			                    <jsp:include page="/workflow/request/WorkflowLoadSignature.jsp">
			                    <jsp:param name="workflowRequestLogId" value="<%=workflowRequestLogId%>" />
			                    <jsp:param name="isSignMustInput" value="<%=isSignMustInput%>" />
			                    <jsp:param name="formSignatureWidth" value="<%=formSignatureWidthInt %>" />
			                    <jsp:param name="formSignatureHeight" value="<%=formSignatureHeightInt %>" />
			                    <jsp:param name="signworkflowids" value="<%=signworkflowids%>" />
			                    <jsp:param name="isSignWorkflow_edit" value="<%=isSignWorkflow_edit %>"/>
			                    <jsp:param name="isFromHtmlModel" value="0" />
                                <jsp:param name="requestId" value="<%=requestIdNew %>" />
                                <jsp:param name="workflowId" value="<%=workflowIdNew %>" />
                                <jsp:param name="nodeId" value="<%=nodeIdNew %>" />
			                    </jsp:include>
			                </div>
			               </td>
					     <%
					     } else {
					     //非手写签章


					     %>
                         <tr <%if ("1".equals(isHideInput)) {%>style="display:none;"<%}%>>
                            <td style="border: 1px solid #cccccc;border-right:1px solid #cccccc!important;">
                                <input type="hidden" id="remarkText10404" name="remarkText10404" temptitle="<%=SystemEnv.getHtmlLabelName(17614, user.getLanguage())%>" value="">
                                
                                <div id="remarkShadowDiv" name="remarkShadowDiv" style="display:inline-block;width:100%;">
                                	<div id="remarkShadowDivInnerDiv" style="margin:10px 10px;height:30px;border:1px solid #d6d6d6;background:#fff;color:#a2a2a2;cursor:pointer;<%=isSignMustInput.equals("1") ? "border-left:2px solid #fe4e4c;" : ""%>" onclick="initRemark()" title="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>">
	                                	<span style="margin:0 5px;"><img style="vertical-align:middle;" src="/images/sign/sign_wev8.png"></img></span>
	                                	<span style="line-height:30px;">
	                                	<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%> 
	                                	
	                                	<%
	                                	if (!tempbeagenter.equals(userid + "")) {
                                        %>
                                          	 （<%=SystemEnv.getHtmlLabelName(84397,user.getLanguage())%> <%=tempbeagentername %><%=SystemEnv.getHtmlLabelName(84398,user.getLanguage())%> ）


                                        <%}
	                                	%>
	                                	</span>
                                	</div>
                                	
                           		</div>
                                <div style="display:none;" class="remarkDiv">
                                	<textarea name=remark id=remark style="width:100%;height:140px;margin:0;resize: none;color:#a2a2a2;overflow: hidden;color:#c7c7c7;" <%=isSignMustInput.equals("1") ? "viewtype='1'" : ""  %> temptitle="<%=SystemEnv.getHtmlLabelName(17614, user.getLanguage())%>" <%if(isSignMustInput.equals("1")){%> onChange="checkinput('remark','remarkSpan')" <%}%>><%=Util.toHtmltextarea(Util.encodeAnd(myremark))%></textarea>
                           		</div>
                            </td>
			    		 <%
						 }
						 %>
                            <td id="signrighttool" style="position: relative; background-color: #fff;display:none;" valign="top">
                            	<div style="width: 100%; height: 0px;background:#f0f0ee;border-top: 1px solid #cccccc;border-bottom: 1px solid #cccccc;border-right: 1px solid #cccccc; ">
								
                                <div style="float: left;padding-top:2px;">
                                    <select class=inputstyle notBeauty=true id="phraseselect" beautySelect="true" name=phraseselect style="width: 150px!important;" onChange='onAddPhrase(this.value)' onmousewheel="return false;">
                                        <option value=""> －－<%=SystemEnv.getHtmlLabelName(22409, user.getLanguage())%>－－ </option>
                                        <%
										//开启表单签章时不显示常用语
		                               if (workflowPhrases.length > 0&&!"1".equals(isFormSignature)) {
		                               //常用提示语


                                            for (int i = 0; i < workflowPhrases.length; i++) {
                                                        String workflowPhrase = workflowPhrases[i];
                                        %>
                                        <option value="<%=workflowPhrasesContent[i]%>"><%=workflowPhrase%></option>
                                        <%
                                            }
                                        
		                                }
		                                %>
                                    </select>
                                </div>
                                <div style="float: left;padding-left:5px;padding-top:4px;">
                                    <button type="button" class="addbtn"  accesskey="A" onclick="addPhraseNew()" title="<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage())%>"></button>
                                </div>
                                
                                <!--  
                                <div style="width: 20px; height: 8px; float: right; margin-top: 5px; margin-right: 10px;"> <img src="/wui/theme/ecology8/templates/default/images/2_wev8.png"
                                            style="cursor: pointer; height: 8px; width: 12px;"
                                            onclick="showSignInputBlock(true)"  title="点击收缩">
                                </div>
                                -->
                                <!-- 附加信息 -->
                                <div class="signotherblock" style="position: absolute; left: 0; top: 0px;bottom:0px;right:-1px; height:<%=formSignatureHeightInt %>px; background:#f8f8f8;border:1px solid #cccccc;border-top:0px solid #ccc;overflow-y:auto;overflow-x:hidden;">
                                     <%
                                     if (tempbeagenter.equals(userid + "") && !"1".equals(isSignWorkflow_edit) && !"1".equals(isannexupload_edit) && !"1".equals(isannexupload_edit)) {
                                        %>
                                      <div style="margin:5px 10px 5px 10px;font-size:13px;color:#c6c6c6;">
                                       		 <%=SystemEnv.getHtmlLabelNames("26161,83273",user.getLanguage())%> 
                                      </div>
                                     <%
                                     }
                                     if (!tempbeagenter.equals(userid + "")) {
                                     %>
                                     <div style="margin:5px 10px 5px 15px;font-size:13px;color:#c6c6c6;">
                                       	 <%=SystemEnv.getHtmlLabelName(84397,user.getLanguage())%><span style="color:#3f91ff;margin:0 2px;"><%=tempbeagentername %></span><%=SystemEnv.getHtmlLabelName(84398,user.getLanguage())%> 
                                     </div>
                                     <%}
                                     if ("1".equals(isSignWorkflow_edit) || "1".equals(isannexupload_edit) || "1".equals(isannexupload_edit)) {
                                     %>
                                     
                                     <div class='signbottommenu' style="left: 0px;width: 100%">
                                        <%
                                        //相关附件
                                        if ("1".equals(isannexupload_edit)) {                  
                                        %>        
                                                             
                                        <div id="signAnnexupload" style="">
                                            <%
                                                if (annexsecId < 1) {
                                            %>
                                            <%=SystemEnv.getHtmlLabelName(21418, user.getLanguage()) + SystemEnv.getHtmlLabelName(15808, user.getLanguage())%>!</font>
	                            		</div>             
                                        <%
                                        } else {
                                        %>
                                        <script type="text/javascript">
                                        var signannexParam = {
                                                      annexmainId :"<%=annexmainId%>",
                                                      annexsubId : "<%=annexsubId%>",
                                                      annexsecId : "<%=annexsecId%>",
                                                      userid : "<%=userid%>",
                                                      logintype : "<%=logintype%>",
                                                      annexmaxUploadImageSize : <%=annexmaxUploadImageSize%>,
                                                      userlanguage:"<%=user.getLanguage()%>",
                                                      field_annexupload: '<%=annexdocids %>'
                                         };
                                         </script>
                                         <span class="signResourceBlockClass" style="margin-left:15px;margin-right:15px;">
	                                         <span class="signAnnexupload" onclick="showSignResourceCenter('signAnnexuploadCount');"
	                                                title="<%=SystemEnv.getHtmlLabelName(22194, user.getLanguage())%>">
	                                         </span> 
	                                         <div class="signAnnexupload_span" id="signAnnexuploadCount" style="word-break: break-all;word-wrap: break-word;margin-left:40px;">
	                                         	<%=annexnames %>
	                                         </div>
                                         <!--
                                         <span class="signcountblockclass" id="signAnnexuploadCount">                                                   
                                         <table cellpadding="0" cellspacing="0" border="0" style="background:none!important;height:20px!important;">
                                                <tr style="height: 20px;">
                                                    <td class="signcountClass_left">&nbsp;</td>
                                                    <td width="*" class="signcountClass_center" id="annexuploadcountTD"></td>
                                                    <td class="signcountClass_right">&nbsp;</td>
                                                </tr>
                                         </table>
                                         </span>
                                         -->
                                         </span>
                                         <input class=InputStyle type=hidden size=60 id="field-annexupload" name="field-annexupload" value="<%=annexdocids%>">
                                         <input type=hidden id="field_annexupload_del_id" value="">
                                         <input type="hidden" name="field-annexupload-name" id="field-annexupload-name" value="<%=fieldannexuploadname%>">
                                         <input type="hidden" name="field-annexupload-count" id="field-annexupload-count" value="">
                                         <input type="hidden" name="field-annexupload-request" id="field-annexupload-request" value="<%=requestid%>">
                                         <input type="hidden" name="field-cancle" id="field-cancle" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>">
                                         <input type="hidden" name="field-add-name" id="field-add-name" value="<%=SystemEnv.getHtmlLabelName(18890, user.getLanguage()) + SystemEnv.getHtmlLabelName(19812, user.getLanguage())%>">
                                         <input type=hidden name='annexmainId' id='annexmainId' value=<%=annexmainId%>>
                                         <input type=hidden name='annexsubId' id='annexsubId' value=<%=annexsubId%>>
                                         <input type=hidden name='annexsecId' id='annexsecId' value=<%=annexsecId%>>
                                         <input type=hidden name='fileuserid' id='fileuserid' value=<%=userid%>>
                                         <input type=hidden name='fileloginyype' id='fileloginyype' value=<%=logintype%>>
                                         <input type=hidden name='annexmaxUploadImageSize' id='annexmaxUploadImageSize' value=<%=annexmaxUploadImageSize%>>
                                         
                                        <%
                                            }
                                        %>
                                        </div>
                           
                                        <%
                                        }
                                        //相关文档
                                        if ("1".equals(isSignDoc_edit)) {
                                        %>
                                        <div id="signDoc" style="left: 0px;width: 100%">
                                            <input type="hidden" id="signdocids" name="signdocids"
                                                value="<%=signdocids%>">
                                            <span class="signResourceBlockClass" style="margin-left:15px;margin-right:15px;"> <span
                                                class="signDoc"
                                                onclick="onShowSignBrowser4signinput('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37, 'signDocCount')"
                                                title="<%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%>">
                                             </span>
                                             <div class="signDoc_span" id="signDocCount" style="word-break: break-all;word-wrap: break-word;margin-left:40px;">
	                                            <%=docnames%>
	                                         </div> 
                                            <!--
                                            <span class="signcountblockclass" id="signDocCount">
                                            <table cellpadding="0" cellspacing="0" border="0" style="background:none!important;height:20px!important;">
                                                <tr style="height: 20px;">
                                                    <td class="signcountClass_left">&nbsp;</td>
                                                    <td width="*" class="signcountClass_center" id="signdocidsTD"> 5 </td>
                                                    <td class="signcountClass_right">&nbsp;</td>
                                                </tr>
                                            </table>
                                            </span> 
                                            -->
                                            </span>
                                            <span id="signdocspan"></span> </div>
                                        <%
                                            }
                                        %>
                                        <%
                                            //相关流程
                                                    if ("1".equals(isSignWorkflow_edit)) {
                                        %>
                                        <div id="signWorkflow" style="left: 0px;width:100%">
                                            <input type="hidden" id="signworkflowids"
                                                name="signworkflowids" value="<%=signworkflowids%>">
                                            <span class="signResourceBlockClass" style="margin-left:15px;margin-right:15px;"> <span
                                                class="signWorkflow"
                                                onclick="onShowSignBrowser4signinput('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152, 'signWorkflowCount')"
                                                title="<%=SystemEnv.getHtmlLabelName(1044, user.getLanguage())%>">
                                            </span> 
                                            <div class="signWorkflow_span" id="signWorkflowCount" style="word-break: break-all;word-wrap: break-word;margin-left:40px;">
	                                        		<%=workflownames%>
	                                        </div>
                                            <!--
                                            <span class="signcountblockclass" id="signWorkflowCount">
                                            <table cellpadding="0" cellspacing="0" border="0" style="background:none!important;height:20px!important;">
                                                <tr style="height: 20px;">
                                                    <td class="signcountClass_left">&nbsp;</td>
                                                    <td width="*" class="signcountClass_center" id="signworkflowidsTD"><%=signworkflowids.split(",").length%></td>
                                                    <td class="signcountClass_right">&nbsp;</td>
                                                </tr>
                                            </table>
                                            </span>
                                            -->
                                            </span>
                                            <!-- 
                <button type=button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044, user.getLanguage())%>"></button>
                 -->
                                            <span id="signworkflowspan"></span> 
                                          </div>
                                        <%
                                            }
                                        %>
                                    </div>
                                    <%
                                        }
                                    
                                    %>
                                    <div style="position:absolute;bottom:40px;left:5px;">
                                    <span id="remarkSpan">
                                    <%
				                    if (isSignMustInput.equals("1") && "".equals(myremark)&&!"1".equals(isFormSignature)) {
				                    %>
				                    	<!-- 普通模式处理和HTML模板的处理配合使用 -->
				                    	<!--
				                    	<img src="/images/BacoError_wev8.gif" align=absmiddle>
				                    	-->
				                    <%
				                    }
				                    %>
				                    </span>
				                    </div>
                                </div>
                             </td>
                        </tr>
                    </table>

</div>
<%
	if (!"1".equals(isFormSignature)) {
%>


<script type="text/javascript">	


	<%
	if ("1".equals(isSignWorkflow_edit) || "1".equals(isannexupload_edit) || "1".equals(isSignDoc_edit)) {
	%>
	window.__haswfresource = true;
	<%
	}
	%>
	
	if (window.addEventListener){
	    window.addEventListener("load", initremarkueditor, false);
	}else if (window.attachEvent){
	    window.attachEvent("onload", initremarkueditor);
	}else{
	    window.onload=initremarkueditor;
	}
	
	var __bsV = 99;
	var __isIE = false;
	
	window._isremarkcomp = false;
	try {
		__bsV = jQuery.client.browserVersion.version; 
		__isIE = jQuery.client.browser=="Explorer"?"true":"false";
	} catch (e) {
	}
	
	function initremarkueditor() {
		if (__isIE && __bsV <= 9) {
			setTimeout(function () {
				initremarkueditor2();
			}, 200);
		} else {
			initremarkueditor2();
		}
	}

	function initremarkueditor2() {
		if (__isIE && __bsV <= 9) {
			if (window.__ueditready != undefined && window.__ueditready > 0) {
				setTimeout(function () {
					initremarkueditor();
				}, 500); 
				return;
			} 
		}
		var _ue = UEUtil.initRemark('remark', (__isIE && __bsV < 9));
       	bindRemark(_ue);
       	<%
        if (!"".equals(myremark)) {
        %>
        initRemark(true);
        <%
        }
        %>
        if (window.__isremarkPage == true) {
        	initRemark();
        	jQuery("#_wfsigninputIvt").hide();
        }
        _ue.addListener('click', function(){
        	//if(_ue.getContentTxt().replace(/\s+/g,"")=="请输入签字意见"){
        	//	_ue.setContent("",false);
        	//}
		});
        jQuery(".edui-for-wfannexbutton").css("cursor","pointer");
        try {
   			var _targetobj = jQuery(".edui-for-wfannexbutton").children("div").children("div").children("div").children(".edui-metro");
        	if (document.getElementById("field-annexupload").value != '') {
        		_targetobj.addClass("wfres_1_slt");
        		_targetobj.removeClass("wfres_1");
        	} else {
        		_targetobj.addClass("wfres_1");
        		_targetobj.removeClass("wfres_1_slt");
        	}
        } catch (e) {}
	}

	
	


        
        
	
	function autoscroll4remark() {
		try {
			var remarkscrolltop = jQuery("#remark").offset().top;
			jQuery(document.body).animate({scrollTop : remarkscrolltop + "px"}, 500);
		} catch(e) {}
	}

	function initRemark2(){
		//签字意见未填写,自动跳转到签字意见框处


		jQuery("#remarkShadowDiv").hide();
        jQuery(".remarkDiv").show();
        jQuery("#signtabtoolbar").css("display","");
        jQuery("#signrighttool").css("display","");
	    jQuery(".signaturebyhand").css("display","");
		window.location.hash = "#fsUploadProgressannexuploadSimple";
		//重置锚点,否则,下次将不能定位


		window.location.hash = null;
		var ue_temp = UE.getEditor('remark');
		if(!!ue_temp){
			ue_temp.setContent("<span alt='true' style='color:#aaa;'><%=SystemEnv.getHtmlLabelName(129385, user.getLanguage())%></span>",false);
		}
	}
	
	function triggerMouseupHandle(e) {
		//转发页面不隐藏


		if (window.__isremarkPage == true) {
			return;
		}
		var _uEditor = UE.getEditor("remark");
		var _remarkTxt = _uEditor.getContentTxt();
		var _remarkHtmlstr = _uEditor.getContent().replace(/<p><\/p>/g, "");
       	if(_remarkHtmlstr == ""){
       		//_uEditor.destroy();
       		//change2NormalStyle();
       		//jQuery("html").unbind('mouseup', remarkHide);
       		jQuery(".remarkDiv").hide();
       		jQuery("#remarkShadowDiv").show();
       	}	
	}	
	
	//对编辑器添加焦点监听,增加按钮，并使编辑器获得焦点
	function bindRemark(_uEditor){
		var remarkHide = function (e) {
			
			//转发页面不隐藏


			if (window.__isremarkPage == true) {
				return;
			}
			var banfold = jQuery("#fsUploadProgressfileuploaddiv").attr("banfold");
			if (e.which == 1 && jQuery(e.target).parents('.remarkDiv,.edui-popup,.edui-dialog,.filtercontainer, ._signinputphraseblockClass').length <= 0 && banfold != "1") {
				var _remarkTxt = _uEditor.getContentTxt();
				var _remarkHtmlstr = _uEditor.getContent().replace(/<p><\/p>/g, "");
				
	        	if((_remarkTxt == "" && _remarkHtmlstr.indexOf('<img src=') < 0) || _remarkHtmlstr == ""){
	        		//_uEditor.destroy();
	        		//change2NormalStyle();
	        		//jQuery("html").unbind('mouseup', remarkHide);
	        		jQuery(".remarkDiv").hide();
	        		jQuery("#remarkShadowDiv").show();
	        	}
				e.stopPropagation();
			}
			
			
		};
		jQuery("html").live('mousedown', remarkHide);
		_uEditor.ready(function(){
			/*
			jQuery("#remarkShadowDiv").hide();
	        jQuery(".remarkDiv").show();
	        _uEditor.focus(true);
	        */
	        jQuery(".edui-for-wfannexbutton").children("div").children("div").children("div").children(".edui-metro").addClass("wfres_1");
			jQuery(".edui-for-wfdocbutton").children("div").children("div").children("div").children(".edui-metro").addClass("wfres_2");
			jQuery(".edui-for-wfwfbutton").children("div").children("div").children("div").children(".edui-metro").addClass("wfres_3");
			<%if(!isSystemBill){%>
			if(jQuery('#remarkLocation').val() !="" && jQuery('#remarkLocation').val() != null && jQuery('#remarkLocation').val() != "null"){
				jQuery(".edui-for-wflocatebutton").children("div").children("div").children("div").children(".edui-box").removeClass("edui-metro").removeClass("wflocate1").addClass("wflocate2");
			}
			<%}%>
		});
	}
</script>
<%} %>
<script>
//动态显示,控制滚动条的高度 
/*
function setHeight() {
    if (jQuery(".signaturebyhand").find("table:eq(1)").height() > 0 && jQuery(".flowsign").outerHeight() > 0) {
        var height = jQuery(".flowsign").outerHeight();
        var tempdiv = jQuery("<div  class='flowsignhelper' style='width:100%;display:none;'></div>") tempdiv.css("height", height + "px");
        tempdiv.attr("flowheight", height + "px");
        tempdiv.attr("titleheight", jQuery(".flowsign .title").outerHeight() + "px");
        jQuery(document.body).append(tempdiv);
    } else setTimeout(setHeight, 1000);

}
setHeight();
*/
</script>

<script><!--
//页面载入时显示相关附件数量


var dialognum = 1;
//页面载入时显示相关附件数量


var lendoc = "<%=annexdocids%>".split(",").length;
var lenwd = "<%=signdocids%>".split(",").length;
var lenwf = "<%=signworkflowids%>".split(",").length;
String.prototype.trim = function () {
	return this.replace(/^\s+|\s+|\n+|\r+$/g,'');
};
if(lenwd>1||(lenwd ==1&&!"<%=signdocids%>".trim()=="")){
	jQuery("#signdocidsTD").html("<%=signdocids%>".split(",").length);
	jQuery("#signdocidsTD").parent().parent().parent().parent().show();
}
if(lenwf>1||(lenwf ==1&&!"<%=signworkflowids%>".trim()=="")){
	jQuery("#signworkflowidsTD").html("<%=signworkflowids%>".split(",").length);
	jQuery("#signworkflowidsTD").parent().parent().parent().parent().show();
}
if(lendoc>1||(lendoc ==1&&!"<%=annexdocids%>".trim()=="")){
	jQuery("#annexuploadcountTD").html("<%=annexdocids%>".split(",").length);
	jQuery("#annexuploadcountTD").parent().parent().parent().parent().show();
}
function showSignInputBlock(flag) {
    if (flag) {
        jQuery(".flowsign").hide();
        jQuery("#imagesing").show();
    } else {
        jQuery(".flowsign").show();
        jQuery("#imagesing").hide();
    }
}
/*
jQuery("#imagesing").click(function(){

    jQuery(".flowsign").show();
    jQuery("#imagesing").hide();
    jQuery(".div_pagerhider").hide();
    jQuery(".flowsignhelper").show();

 });
*/

function changebuttonon(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#8d8d8d");
	}
}

function uploadbuttonon(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#52ab2f");
	}
}

function changebuttonout(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#aaaaaa");
	}
}

function uploadbuttonout(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#6bcc44");
	}
}

function changefileaon(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#008aff!important;text-decoration:underline!important;");
}

function changefileaout(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#8b8b8b!important;text-decoration:none!important;");
}

function showProgressCancel(obj){
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-2px 0px!important;display:block;float:right;");
}

function hideProgressCancel(obj){
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-14px 0px!important;display:none;float:right;");
}

/*
jQuery(".title").click(function() {

    jQuery(".flowsign").hide();
    jQuery("#imagesing").show();
    jQuery(".div_pagerhider").show();
    jQuery(".flowsignhelper").hide();

});


jQuery(".signstatus").click(function() {
    var classname = jQuery(this).find("img").attr("class");
    var signtr;
    var height = 220;
    if (classname === 'signshrink') {

        signtr = jQuery(this).parent().find(".viewform  tbody").find("tr").eq(1);

        jQuery(signtr).show();

        jQuery(".flowsign .cke_editor").show();

        if (jQuery(".signaturebyhand").length) {
            jQuery(".signaturebyhand").show();
        }

        if (jQuery(".relateitems").length > 0) {
            jQuery(".relateitems").show();
        }

        jQuery(this).find("img").attr("class", "signspread");
        jQuery(this).find("img").attr("src", "/images/wf/spread_wev8.png");

        height = jQuery(this).parent().height();

        if (jQuery(".flowsignhelper").length > 0) {
            jQuery(".flowsignhelper").css("height", jQuery(".flowsignhelper").attr("flowheight"));
        }

    } else {

        signtr = jQuery(this).parent().find(".viewform  tbody").find("tr").eq(1);
        height = jQuery(this).parent().find(".Title").height();
        jQuery(signtr).hide();
        jQuery(".flowsign .cke_editor").hide();

        if (jQuery(".flowsignhelper").length > 0) {
            jQuery(".flowsignhelper").css("height", jQuery(".flowsignhelper").attr("titleheight"));
        }

        if (jQuery(".signaturebyhand").length) {
            jQuery(".signaturebyhand").hide();
        }

        if (jQuery(".relateitems").length > 0) {
            jQuery(".relateitems").hide();
        }

        jQuery(this).find("img").attr("src", "/images/wf/shrink_wev8.png");
        jQuery(this).find("img").attr("class", "signshrink");

    }

});
*/

function addPhraseNew(){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/request/UserPhraseEdit.jsp?addfrom=1"
	var title = "<%=SystemEnv.getHtmlLabelNames("22409,83476",user.getLanguage())%> ";
	dialog.Title = title;
	dialog.Width = 1050;
	dialog.Height = 520;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callbackfun = function (paramobj, ids) {
        if (ids) {
        	var bid = ids.id;
        	var bname = ids.name;
        	jQuery("<option value='"+bname+"'>"+bid+"</option>").appendTo("#phraseselect"); 
        }
    } ;
	dialog.show();
}

function onShowSignBrowser4signinput(url, linkurl, inputname, spanname, type1, countEleID) {
    //关闭表单签章显示,防止某些IE版本下,表单签章显示白色和弹窗冲突


    if(top.Dialog._Array.length == 0){
    	jQuery("[id^=Consult]").hide();
    }
    var tmpids = jQuery("#" + inputname).val();
    var url;
     if (type1 === 37) {
				       // url = "/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1)%>&url=" + url + "?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1)%>&documentids=" + tmpids;
					   url = "/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1)%>&url=" + url + "?documentids=" + tmpids + uescape("&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1)%>");
				    } else {
				        url = "/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1) %>&url=" + url + "?resourceids=" + tmpids + uescape("&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1)%>");
				    }
					//alert(url);
    var dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    dialog.callbackfunParam = null;
    dialog.URL = url;
    dialog.callbackfun = function (paramobj, id1) {
        if (id1) {
            if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
                var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
                var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
                var sHtml = "";
                resourceids = resourceids.substr(0);
                resourcename = resourcename.substr(0);
                jQuery("#" + inputname).val(resourceids);
                var resourceidArray = resourceids.split(",");
                var resourcenameArray = resourcename.split(",");
                
                if ( !! countEleID) {
                    //jQuery("#" + countEleID).children("Table").find("TD[class=signcountClass_center]").html(resourceidArray.length);
                    //resourcename = resourcename.replace(/\,/g,",  ");
                    //jQuery("#" + countEleID).html("");
                    //jQuery("#" + countEleID).show();
                }
	
	            for (var _i = 0; _i < resourceidArray.length; _i++) {
	                var curid = resourceidArray[_i];
	                var curname = resourcenameArray[_i];
	                //unselectable=\"off\" contenteditable=\"false\"
	                if (type1 === 37) {
	                	//sHtml = sHtml + "<a href='javascript:void 0' onclick=\"parent.addDocReadTag('" + curid + "');parent.openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=" + curid + "&isrequest=1&requestid=<%="-1".equals(requestid) ? "{#[currentRequestid]#}" : requestid %>')\" title='" + curname + "'>" + curname + "</a>";
	                    sHtml = sHtml + "<a href='/docs/docs/DocDsp.jsp?id=" + curid + "&isrequest=1&requestid=<%=Util.getIntValue(requestid+"",0) <= 0 ? "{#[currentRequestid]#}" : requestid %>'  target='_blank' title='" + curname + "' style=\"color:#123885;\" >" + curname + "</a>&nbsp;&nbsp;";
	                    //sHtml += "<a href='/docs/docs/DocDsp.jsp?id="+curid+"&requestid=<%=requestid%>' target='_blank' style=\"color:#123885;\">"+curname+ "</a>&nbsp;&nbsp;"; 
	                } else {
	                	//sHtml = sHtml + "<a href=" + linkurl + curid + " target='_blank'>" + curname + "</a> &nbsp; ";                	  
	                	sHtml += "<a href='/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype2%>&requestid="+curid+"&isrequest=1' target='_blank' style=\"color:#123885;\">"+curname+ "</a>&nbsp;&nbsp;";
	                }
	            }
	            jQuery("#" + countEleID).html(sHtml);
	            var editorid = "remark"; 
	            try{
	            	UE.getEditor(editorid).setContent(" &nbsp;" + sHtml, true);
	            }catch(e){}
	            try {
	            	var _targetobj;
					var _targetobjimg = "";
					var _targetobjClass = "";
            		if (type1 == 152) { //相关流程
            			_targetobj = jQuery(".edui-for-wfwfbutton").children("div").children("div").children("div").children(".edui-metro");
            			_targetobjClass = "wfres_3";
            		} else {
            			_targetobj = jQuery(".edui-for-wfdocbutton").children("div").children("div").children("div").children(".edui-metro");
            			_targetobjClass = "wfres_2";
            		}
            		//alert(_targetobj.css("background"));
	            	if (resourceidArray.length != 0) {
	            		_targetobj.addClass(_targetobjClass + "_slt");
	            		_targetobj.removeClass(_targetobjClass);
	            	} else {
	            		_targetobj.addClass(_targetobjClass);
	            		_targetobj.removeClass(_targetobjClass + "_slt");
	            	}
	            } catch (e) {}
            } else {
                jQuery("#" + inputname).val("");
                if (!! countEleID) {
                    jQuery("#" + countEleID).children("Table").find("TD[class=signcountClass_center]").html("0");
                    jQuery("#" + countEleID).hide();
                }
                
                try {
	            	var _targetobj;
					var _targetobjimg = "";
					var _targetobjClass = "";
            		if (type1 == 152) { //相关流程
            			_targetobj = jQuery(".edui-for-wfwfbutton").children("div").children("div").children("div").children(".edui-metro");
            			_targetobjClass = "wfres_3";
            		} else {
            			_targetobj = jQuery(".edui-for-wfdocbutton").children("div").children("div").children("div").children(".edui-metro");
            			_targetobjClass = "wfres_2";
            		}
            		//alert(_targetobj.css("background"));
            		_targetobj.addClass(_targetobjClass);
	                _targetobj.removeClass(_targetobjClass + "_slt");
	            } catch (e) {}
            }
        }
    } ;
    dialog.Height = 620 ;
    if (type1 === 37) {
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>";
    }else{
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>";
	    if(jQuery.browser.msie){
			dialog.Height = 570;
		}else{
			dialog.Height = 570;
		}
    }
    
    dialog.Drag = true;
    //dialog.maxiumnable = true;
    dialog.show();
    <%
	//手写签章
	if ("1".equals(isFormSignature)) {
	%>
	//当有弹窗时关闭表单签章,否则显示白色底色和弹窗冲突


		if(top.Dialog._Array.length == 1){
			var consTimer = window.setInterval(function(){
				  if(top.Dialog._Array.length < dialognum){   
				        jQuery("[id^=Consult]").show();
				        clearInterval(this);
				  }else{
				      	jQuery("[id^=Consult]").hide();
				  }
			},300);
	    }
	<%
	}
	%>
}

//弹出浏览框时,关闭表单签章显示,防止某些IE版本下,表单签章显示白色和弹窗冲突


jQuery(".e8_browflow").bind('click',function(){
	if(top.Dialog._Array.length == 0){
    	jQuery("[id^=Consult]").hide();
    }
	<%
	//手写签章
	if ("1".equals(isFormSignature)) {
	%>
	//当有弹窗时关闭表单签章,否则显示白色底色和弹窗冲突


		if(top.Dialog._Array.length == 1){
			var consTimer = window.setInterval(function(){
				  if(top.Dialog._Array.length < dialognum){   
				        jQuery("[id^=Consult]").show();
				        clearInterval(this);
				  }else{
				      	jQuery("[id^=Consult]").hide();
				  }
			},300);
	    }
	<%
	}
	%>
});


function showSignResourceCenter(sgid) {
    //关闭表单签章显示,防止某些IE版本下,表单签章显示白色和弹窗冲突


    if(top.Dialog._Array.length == 0){
    	jQuery("[id^=Consult]").hide();
    }
    if ( !! typeof(signannexParam)) {
        var param = "annexmainId=" + signannexParam.annexmainId + "&annexsubId=" + signannexParam.annexsubId + "&annexsecId=" + signannexParam.annexsecId + "&userid=" + signannexParam.userid + "&logintype=" + signannexParam.logintype + "&annexmaxUploadImageSize=" + signannexParam.annexmaxUploadImageSize + "&userlanguage=" + signannexParam.userlanguage + "&field_annexupload=" + jQuery("#field-annexupload").val() + "&field_annexupload_del_id=" + jQuery("#field_annexupload_del_id").val();
        var url = "/workflow/request/workflowSignAnnexUpload.jsp?" + param;
        dialog = new window.top.Dialog();
        dialog.currentWindow = window;
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%>";
        dialog.Width = 500;
        dialog.Height = 300;
        dialog.URL = url;
        dialog.callbackfun = function (paramobj, id1) {
        	if (id1) {
	           if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
	                var ids = jQuery.trim(wuiUtil.getJsonValueByIndex(id1, 0));
	                var names = jQuery.trim(wuiUtil.getJsonValueByIndex(id1, 1));
					var siezes = jQuery.trim(wuiUtil.getJsonValueByIndex(id1, 2));
					var splitchar = "////~~weaversplit~~////";
					var idArray = ids.split(splitchar);
		            var nameArray = names.split(splitchar);
		            var sizeArray = siezes.split(splitchar);
		            var sHtml = "";
		            var sHtml2 = "";
		            for (var _i = 0; _i < idArray.length; _i++) {
		                var curid = jQuery.trim(idArray[_i]);
		                var curname = jQuery.trim(nameArray[_i]);
		                var cursize = jQuery.trim(sizeArray[_i])
		                //unselectable=\"off\" contenteditable=\"false\" 
		          		sHtml += "<a href='javascript:void(0);' onclick=\"parent.openFullWindowHaveBar('/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype2%>&id=" + curid + "&isrequest=1&requestid=<%=requestid %>&desrequestid=0')\" style=\"color:#123885;\">" + curname + "</a>&nbsp;&nbsp;";
						//sHtml += "<button class=\"btnFlowd\" accesskey=\"1\" onclick=\"addDocReadTag('" + curid + "');top.location='/weaver/weaver.file.FileDownload?fileid=" + curid + "&download=1&requestid=<%=requestid %>&desrequestid=0'\">下载[" + cursize + "KB]</button>&nbsp;&nbsp;";
		                sHtml2 += "<a href='javascript:void(0);' onclick=\"parent.openFullWindowHaveBar('/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype2%>&id=" + curid + "&isrequest=1&requestid=<%=requestid %>&desrequestid=0')\" style=\"color:#123885;\">" + curname + "</a>&nbsp;&nbsp;<br>";
		                //sHtml2 += "<button type='button' class='wffbtn' accesskey='1' onclick=\"top.location='/docs/docs/DocAcc.jsp?canDownload=true&language=7&bacthDownloadFlag=0&docid="+curid+"&mode=view&pagename=docdsp&isFromWf=false&operation=getDivAcc&maxUploadImageSize=0&isrequest=1&requestid=-1&desrequestid=0#'\" style='color:#123885;border:0px;line-height:20px;font-size:12px;padding:3px;background:rgb(248, 248, 248);'>[下载" + parseInt(cursize/1024) + "KB]</a>&nbsp;&nbsp;<br>";
		            }
					var editorid = "remark"; 
					try{
						UE.getEditor(editorid).setContent("&nbsp;" + sHtml, true);			
					}catch(e){
						jQuery("#signAnnexuploadCount").html(sHtml2);
					}
	            }
	            try {
           			var _targetobj = jQuery(".edui-for-wfannexbutton").children("div").children("div").children("div").children(".edui-metro");
	            	if (document.getElementById("field-annexupload").value != '') {
	            		_targetobj.addClass("wfres_1_slt");
	            		_targetobj.removeClass("wfres_1");
	            	} else {
	            		_targetobj.addClass("wfres_1");
	            		_targetobj.removeClass("wfres_1_slt");
	            	}
	            } catch (e) {}
	            
	        }
        };
        dialog.show();
        
		<%
		//手写签章
		if ("1".equals(isFormSignature)) {
		%>
		//当有弹窗时关闭表单签章,否则显示白色底色和弹窗冲突


		if(top.Dialog._Array.length == 1){
			var consTimer = window.setInterval(function(){
				  if(top.Dialog._Array.length < dialognum){   
				        jQuery("[id^=Consult]").show();
				        clearInterval(this);
				  }else{
				      	jQuery("[id^=Consult]").hide();
				  }
			},300);
	    }
		<%
		}
		%>
    }

}


function remarkContentFilter(editorid){
	   //var _ueue = UE.getEditor(editorid);
	   // if( _ueue.getContentTxt().replace(/\s+|\s+/g,"")=="请输入签字意见"){
	   //    		_ueue.setContent("",false);
	   // }
}

if (window.__isremarkPage == true) {
    <%
	//手写签章
	if ("1".equals(isFormSignature)) {
	%>
		jQuery("#remarkShadowDiv1").trigger("click");
	<%}%>
}

<%if(!signdocids.equals("")||!signworkflowids.equals("")||!annexdocids.equals("")){%>
	jQuery("#remarkShadowDiv1").trigger("click");
<%}%>

jQuery(function () {
	
	jQuery("#remarkShadowDivInnerDiv").hover(function () {
		jQuery(this).css("border", "1px solid #7FBBF2");
		<%
		if (isSignMustInput.equals("1") ) {
		%>
			jQuery(this).css("border-left", "2px solid #7FBBF2");
		<%
		}
		%>
	}, function () {
		jQuery(this).css("border", "1px solid #d6d6d6");
		<%
		if (isSignMustInput.equals("1") ) {
		%>
			jQuery(this).css("border-left", "2px solid #fe4e4c");
		<%
		}
		%>
	});
	
	 {
		
	}
});

/*
function onShowSignBrowserFormSignature(url, linkurl, inputname, spanname, type1) {
    var tmpids = $GetEle(inputname).value;
    if (type1 === 37) {
        id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url + "?documentids=" + tmpids);
    } else {
        id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url + "?resourceids=" + tmpids);
    }
    if (id1) {
        if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
            var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
            var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
            var sHtml = "";
            resourceids = resourceids.substr(1);
            resourcename = resourcename.substr(1);
            $GetEle(inputname).value = resourceids;

            var resourceidArray = resourceids.split(",");
            var resourcenameArray = resourcename.split(",");

            for (var _i = 0; _i < resourceidArray.length; _i++) {
                var curid = resourceidArray[_i];
                var curname = resourcenameArray[_i];

                sHtml = sHtml + "<a href=" + linkurl + curid + " target='_blank'>" + curname + "</a>&nbsp";
            }
            $GetEle(spanname).innerHTML = sHtml;

        } else {
            $GetEle(spanname).innerHTML = "";
            $GetEle(inputname).value = "";
        }
    }
}
*/
    
--></script>