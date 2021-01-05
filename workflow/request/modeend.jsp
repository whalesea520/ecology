
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />

<link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">
 
 <script type="text/javascript" src="../../js/weaver_wev8.js"></script>

<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>

<%
int userid = user.getUID();
int usertype = 0;
String username=user.getUsername();
int workflowid=Util.getIntValue(request.getParameter("workflowid"));
int nodeid = Util.getIntValue(request.getParameter("nodeid"));
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
String isFormSignature=Util.null2String(request.getParameter("isFormSignature"));
int formSignatureWidth= Util.getIntValue(request.getParameter("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
int formSignatureHeight= Util.getIntValue(request.getParameter("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
String isSignMustInput=Util.null2String(request.getParameter("isSignMustInput"));
String isHideInput=Util.null2String(request.getParameter("isHideInput"));

String workflowRequestLogId = "";
	String isSignDoc_edit=isSignDoc_add;
	String signdocids = "";
	String signdocname = "";
	String isSignWorkflow_edit = isSignWorkflow_add; 
	String signworkflowids = "";
	String signworkflowname = "";
	
	String isannexupload_edit = (String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
	String annexdocids = "";
	String requestid = "-1";
	
	
	String myremark = "";
	int annexmainId=0;
    int annexsubId=0;
    int annexsecId=0;
    int annexmaxUploadImageSize = 0;
	if("1".equals(isannexupload_edit)){
        
        String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
         if("1".equals(isannexupload_edit) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
            annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
            annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
            annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
          }
         annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
         if(annexmaxUploadImageSize<=0){
            annexmaxUploadImageSize = 5;
         }
     }
	boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+userid);
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
	String logintype = user.getLogintype();
	%>
	<br>
    <%@ include file="/workflow/request/WorkflowSignInput.jsp" %>

<script language="javascript">
function onAddPhrase(phrase){
    if(phrase!=null && phrase!=""){
		$G("remarkSpan").innerHTML = "";
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
function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;
        fileLenth= File.getFileSize();
    } catch (e){
        //alert('<%=SystemEnv.getHtmlLabelName(20253,user.getLanguage())%>');
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
    if (fileLenthByM><%=annexmaxUploadImageSize%>) {
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=annexmaxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=60 >";
    $G(objName).outerHTML=outerHTML;
    $G(objName).onchange=tempObjonchange;
}
function addannexRow(accname,maxsize)
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
          var sHtml = "<input class=InputStyle  type=file size=60 name='"+accname+"_"+document.all(accname+'_num').value+"' onchange='accesoryChanage(this)'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }
</script>                            
