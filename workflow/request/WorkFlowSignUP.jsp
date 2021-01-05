
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import = "weaver.general.Util"%>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="RequestLogIdUpdate" class="weaver.workflow.request.RequestLogIdUpdate" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"> </script>
<!-- word转html插件 -->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>

<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<BODY id="flowbody">
<%
//FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();   
int userlanguage=Util.getIntValue(request.getParameter("languageid"),7);
String fieldvalue=Util.null2String(request.getParameter("fieldvalue"));
String remark=Util.null2String(request.getParameter("remark"));
String signdocids=Util.null2String(request.getParameter("signdocids"));
String signworkflowids=Util.null2String(request.getParameter("signworkflowids"));
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
//System.out.println("remark=="+remark);
remark = Util.StringReplace(remark,"\n","<br>");
remark = Util.StringReplace(remark,"<br>","\n");
String fieldname=Util.null2String(request.getParameter("fieldname"));
String fieldid=Util.null2String(request.getParameter("fieldid"));
String workflowid=Util.null2String(request.getParameter("workflowid"));
int isedit=Util.getIntValue(request.getParameter("isedit"), 0);
int requestid = Util.getIntValue(request.getParameter("requestid"));
int urger=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"urger"),0);
int ismonitor=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"ismonitor"),0);

//int userid = user.getUID();
//String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
//add by cyril on 2008-09-30 for td:9014
boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+userid); 
String workflowPhrases[] = new String[RecordSet.getCounts()];
String workflowPhrasesContent[] = new String[RecordSet.getCounts()];
int x = 0 ;
if (isSuccess) {
	while (RecordSet.next()){
		workflowPhrases[x] = Util.null2String(RecordSet.getString("phraseShort"));
		workflowPhrasesContent[x] = Util.toHtmlA(Util.null2String(RecordSet.getString("phrasedesc")));
		x ++ ;
	}
}
//end by cyril on 2008-09-30 for td:9014
String username=user.getUsername();
String isFormSignature=Util.null2String(request.getParameter("isFormSignature"));
int formSignatureWidth= Util.getIntValue(request.getParameter("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
int formSignatureHeight= Util.getIntValue(request.getParameter("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);

int workflowRequestLogId=-1;
if(isFormSignature.equals("1")){
	workflowRequestLogId=Util.getIntValue(request.getParameter("workflowRequestLogId"));
}
int currentnodeid=Util.getIntValue(request.getParameter("nodeid"),0);
String isSignMustInput="0";
RecordSet.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+currentnodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"));
}
String isSignDoc_signup="";
String isSignWorkflow_signup="";
RecordSet.execute("select isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
	isSignDoc_signup=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_signup=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
int annexmainId=0;
int annexsubId=0;
int annexsecId=0;
String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
if("1".equals(isannexupload_add) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
	annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
	annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
	annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
%>
<script language="javascript">
opener.document.all("annexmainId").value="<%=annexmainId%>";
opener.document.all("annexsubId").value="<%=annexsubId%>";
opener.document.all("annexsecId").value="<%=annexsecId%>";
</script>
<%
}
int annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
if(annexmaxUploadImageSize<=0){
	annexmaxUploadImageSize = 5;
}
%>
<form name="frmmain" method="post" action="WorkFlowSignUPOption.jsp" enctype="multipart/form-data" onsubmit="return false">
	<input type="hidden" name="tempannexmainId" value="<%=annexmainId%>">
	<input type="hidden" name="tempannexsubId" value="<%=annexsubId%>">
	<input type="hidden" name="tempannexsecId" value="<%=annexsecId%>">
	<input type="hidden" name="isFormSignature" value="<%=isFormSignature%>">
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  <%
 		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:dosubmit(this),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
   %>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table  class=ViewForm cellspacing=1>
<tbody>
<COL width="10%" >
<COL width="90%" >
<tr class="Title">
          <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT:bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
        </tr>
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></td>
		<td valign="top" class=field>
		<%if("1".equals(isFormSignature)){

%>
		<jsp:include page="/workflow/request/WorkflowLoadSignature.jsp">
			<jsp:param name="workflowRequestLogId" value="<%=workflowRequestLogId%>" />
			<jsp:param name="isSignMustInput" value="<%=isSignMustInput%>" />
			<jsp:param name="formSignatureWidth" value="<%=formSignatureWidth%>" />
			<jsp:param name="formSignatureHeight" value="<%=formSignatureHeight%>" />
			<jsp:param name="isFromWorkFlowSignUP" value="1" />
            <jsp:param name="requestId" value="<%=requestid %>" />
            <jsp:param name="workflowId" value="<%=workflowid %>" />
            <jsp:param name="nodeId" value="<%=currentnodeid %>" />
		</jsp:include>
<%
}else{
		if(workflowPhrases.length>0){%>
      <select class=inputstyle  id="phraseselect" name=phraseselect style="width:80%" onChange='onAddPhrase(this.value)'>
      <option value="">－－<%=SystemEnv.getHtmlLabelName(22409,user.getLanguage())%>－－</option>
      <%for (int i= 0 ; i <workflowPhrases.length;i++) {
         String workflowPhrase = workflowPhrases[i] ;  %>
      <option value="<%=workflowPhrasesContent[i]%>"><%=workflowPhrase%></option>
      <%}%>
      </select><br>
		<%}%>
			<input type="hidden" id="remarkText10404" name="remarkText10404" temptitle="<%=SystemEnv.getHtmlLabelName(17614,userlanguage)%>" value="">
			<textarea class=Inputstyle name=remark id="remark" rows=4 cols=40 style="width:90%;margin:5px 0px;z-index:-1;" class=Inputstyle temptitle="<%=SystemEnv.getHtmlLabelName(17614,userlanguage)%>"  <%if(isSignMustInput.equals("1")){%>onChange="checkinput('remark','remarkSpan')"<%}%>></textarea>
              <span id="remarkSpan">
              </span>
              
	  		   	<script defer>
	  		   	function funcremark_log(){		  		   	
	  		   //	$GetEle("remark").value = opener.document.getElementById("remark").value;
	  		   //	CkeditorExt.initEditor('frmmain','remark','<%=userlanguage%>',CkeditorExt.NO_IMAGE,200)
			   		   UEUtil.initRemark('remark');
			   <%if(isSignMustInput.equals("1")){%>
			   //		CkeditorExt.checkText("remarkSpan","remark");
				<%}%>
			   //		CkeditorExt.toolbarExpand(false,"remark");
			   	}
	  		 	if(ieVersion>=8) {
		  		 	if (window.addEventListener){
					    window.addEventListener("load", funcremark_log(), false);
					}else if (window.attachEvent){
					    window.attachEvent("onload", funcremark_log());
					}else{
					    window.onload=funcremark_log();
					}
	  		 	} else {
		  		 	if (window.addEventListener){
					    window.addEventListener("load", funcremark_log, false);
					}else if (window.attachEvent){
					    window.attachEvent("onload", funcremark_log);
					}else{
					    window.onload=funcremark_log;
					}
	  		 	}
				</script>
              
<%}%>
</td>
</tr>
<tr><td class=Line2 colSpan=2></td></tr>
<%
         if("1".equals(isSignDoc_signup)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids" value="<%=signdocids%>">
                <button class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"><%=signdocname%></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_signup)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids" value="<%=signworkflowids%>">
                <button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"><%=signworkflowname%></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
<%
boolean flag = true;
if(!fieldvalue.trim().equals("")||(isedit>0&&annexsecId!=0)){
%>
<tr>
<td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
<td class=field>
<table cols=3 id="<%=fieldid%>_tab">
<TBODY >
<COL width="80%" >
<COL width="10%" >
<%
if(!fieldvalue.trim().equals("")){
    String sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
    int linknum=-1;
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
    		flag = false;
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

        String imgSrc=AttachFileUtil.getImgSrcByDocId(showid,"20");

        if(DocImageManager.next()){
            docImagefileid = DocImageManager.getImagefileid();
            docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
            docImagefilename = DocImageManager.getImagefilename();
            fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1);
            versionId = DocImageManager.getVersionId();
        }
%>
        <tr>
            <INPUT type=hidden name="<%=fieldid%>_del_<%=linknum%>" value="0" >
            <td valign="top">
              <%=imgSrc%>

              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a href="javascript:addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id=<%=showid%>&versionId=<%=versionId%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a href="javascript:addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=docImagefilename%></a>&nbsp

              <%}%>
              <input type=hidden name="<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
            </td>
            <td align="left">
                <%if(isedit>0){%>
                <BUTTON class=AddDocFlow accessKey=1  onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","<%=fieldid%>_del_<%=linknum%>")'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden"><B><FONT COLOR="#FF0033">√</FONT></B><span></BUTTON>
                <%}%>
            </td>
          </tr>
<%
    }
%>
    <input type=hidden name="<%=fieldid%>_idnum" value=<%=linknum+1%>>
<%
}
if(isedit>0&&annexsecId!=0){
%>
    <tr>
            <td valign="top" colspan="3">
            <%
          if(annexsecId<1){
            %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}else {
           %>
            <script>
            var oUpload<%=fieldid%>;
          function fileupload<%=fieldid%>() {
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId": "<%=annexmainId%>",
                "subId":"<%=annexsubId%>",
                "secId":"<%=annexsecId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>",
                "workflowid":"<%=workflowid%>"
            },
            file_size_limit :"<%=annexmaxUploadImageSize%> MB",
            file_types : "*.*",
            file_types_description : "All Files",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgress<%=fieldid%>",
                cancelButtonId : "btnCancel<%=fieldid%>",
                SubmitButtonId : "btnSubmit<%=fieldid%>",
                uploadspan : "<%=fieldid%>span",
                uploadfiedid : "<%=fieldid%>"
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
            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : fileDialogComplete_1,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete
        };
        try {
            oUpload<%=fieldid%>=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	//window.attachEvent("onload", fileupload<%=fieldid%>);
        	if (window.addEventListener){
  			    window.addEventListener("load", fileupload<%=fieldid%>, false);
  			}else if (window.attachEvent){
  			    window.attachEvent("onload", fileupload<%=fieldid%>);
  			}else{
  			    window.onload=fileupload<%=fieldid%>;
  			}	
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolder<%=fieldid%>"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload<%=fieldid%>.cancelQueue();" id="btnCancel<%=fieldid%>">
									<span><img src="/js/swfupload/delete_wev8.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span id="uploadspan">(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=annexmaxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                      <span id="<%=fieldid%>span"></span>
                  </div>
                  <input  class=InputStyle  type=hidden name="<%=fieldid%>" viewtype="0" value="<%=fieldvalue%>">
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
    </td>
          </tr>
<%}%>
</tbody>
</table>
</td>
</tr>
<tr><td class=Line2 colSpan=2></td></tr>
<%}%>
<input type=hidden name='<%=fieldid%>_num' value="1">
<input type=hidden name="fieldname" value="<%=fieldname%>">
<input type=hidden name="fieldid" value="<%=fieldid%>">
</tbody>
</table>
</form>
 </body>
</html>

<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>
<script language=javascript>
function onAddPhrase(phrase){
    if(phrase!=null && phrase!=""){
		try{
			var ue_temp = UE.getEditor('remark');
			if(!!ue_temp){
				ue_temp.setContent(phrase,true);
			}
		}catch(e){alert(e)}
	}
}
function dosubmit(obj){

    var ischeckok="true";
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			   /*  if(!check_form(document.frmmain,'remark')){
				    ischeckok="false";
			    } */
		    }
<%
		}
	}
%>
    if(ischeckok=="true"){

<%
	    if("1".equals(isFormSignature)){
%>
		    if(SaveSignature_save()){
                obj.disabled=true;
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
		    }
<%
	    }else{
%>
	        //附件上传
	        StartUploadAll();
	        checkuploadcomplet();
<%
	    }
%>
    }
}


  function onChangeSharetype(delspan,delid){
	fieldid=delid.substr(0,delid.indexOf("_"));
    linknum=delid.substr(delid.lastIndexOf("_")+1);
	fieldidspan=fieldid+"span";
    delfieldid=fieldid+"_id_"+linknum;
    if($GetEle(delspan).style.visibility=='visible'){
    	$GetEle(delspan).style.visibility='hidden';
    	$GetEle(delid).value='0';
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
        var tempvalue=$GetEle(fieldid).value;
        var tempdelvalue=","+$GetEle(delfieldid).value+",";
          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
          $GetEle(fieldid).value=tempvalue;
    }
  }

function returnTrue(o){
	return;
}

function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);

}

var dialognum = 1;
function onShowSignBrowser(url,linkurl,inputname,spanname,type1) {
    //关闭表单签章显示,防止某些IE版本下,表单签章显示白色和弹窗冲突

    var curWin = window;
    if(curWin.Dialog._Array.length == 0){
    	jQuery("[id^=Consult]").hide();
    }
    var tmpids = jQuery("#" + inputname).val();
    var url;
    if (type1 === 37) {
        url = "/systeminfo/BrowserMain.jsp?url=" + url + "?documentids=" + tmpids;
    } else {
        url = "/systeminfo/BrowserMain.jsp?url=" + url + "?resourceids=" + tmpids;
    }
    var dialog = new curWin.Dialog();
    dialog.currentWindow = curWin;
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
	            for (var _i = 0; _i < resourceidArray.length; _i++) {
	                var curid = resourceidArray[_i];
	                var curname = resourcenameArray[_i];
	                //unselectable=\"off\" contenteditable=\"false\"
	                if (type1 === 37) {	            
	                    sHtml += "<a href='/docs/docs/DocDsp.jsp?id="+curid+"' target='_blank'>"+curname+ "</a>&nbsp;"; 
	                } else {
						sHtml += "<a href='/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid="+curid+"' target='_blank'>"+curname+ "</a>&nbsp;";
	                }
	            }
	            $G(spanname).innerHTML = sHtml;
	            var editorid = "remark"; 
	            UE.getEditor(editorid).setContent(" &nbsp;" + sHtml, true);
            } else {
                jQuery("#" + inputname).val("");
                $G(spanname).innerHTML = "";
            }
        }
    } ;
    dialog.Height = 620 ;
    if (type1 === 37) {
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>";
    }else{
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(22105,user.getLanguage())%>";
    }
    dialog.show();
    <%
	//手写签章
	if ("1".equals(isFormSignature)) {
	%>
	//当有弹窗时关闭表单签章,否则显示白色底色和弹窗冲突

		if(curWin.Dialog._Array.length == 1){
			var consTimer = window.setInterval(function(){
				  if(curWin.Dialog._Array.length < dialognum){   
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
</script>
