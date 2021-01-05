
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,java.util.*,weaver.hrm.*,weaver.systeminfo.*" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.workflow.request.RevisionConstants" %>

<%@ page import="weaver.system.code.CodeBuild" %>
<%@ page import="weaver.system.code.CoderBean" %>
<%@ page import="weaver.workflow.html.WFLayoutToHtml"%>
<%@ page import="weaver.workflow.html.FieldAttrManager"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%>
<jsp:useBean id="wfNodeFieldManager" class="weaver.workflow.workflow.WFNodeFieldManager" scope="page" />
<jsp:useBean id="wfLayoutToHtml" class="weaver.workflow.html.WFLayoutToHtml" scope="page" />
<jsp:useBean id="rs_html" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_zdl" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RequestLogIdUpdate" class="weaver.workflow.request.RequestLogIdUpdate" scope="page" />
<%--
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
 --%>

<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/workflow/request/js/requesthtml_wev8.js"></script>

<!-- 
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
 -->
 
<script type="text/javascript" src="/wui/common/jquery/plugin/Listener_wev8.js"></script>

<!-- browser 相关 -->
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<script type='text/javascript' src="/js/ecology8/request/autoSelect_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<script type="text/javascript">
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>

<!-- onpropertychange事件支持 -->
<script type="text/javascript" src="/js/workflow/VCEventHandle_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/workflow/exceldesign/css/excelHtml_wev8.css" />

<script>
//用来给用户自定义检查数据，在流程提交或者保存的时候执行该函数，检查通过返回true，否则返回false
function checkCustomize(){
	return true;
}

//新表单设计器-联动format加载监听器----------此ready需先于calsum行列计算前执行，用于表览字段chrome下合计
var chromeOnPropListener = null;
jQuery(document).ready(function(){
	loadListener();
});

//加载监听器，页面打开调用一次；明细表添加调用一次，重置定时器监听的对象
function loadListener(){
	if(chromeOnPropListener==null){
		chromeOnPropListener = new Listener();
	}else{
		chromeOnPropListener.stop();
	}
	chromeOnPropListener.load("[_listener][_listener!='']");
	chromeOnPropListener.start(500,"_listener");
}


var allImgFileArray = undefined;
function playImgs(src) {
    var indexNum = 0;
    for(var i = 0; i < allImgFileArray.length ; i ++) {
        if(src == allImgFileArray[i]) {
            break;
        } else {
            indexNum++;
        }
    }
    window.top.IMCarousel.showImgScanner4Pool(true, allImgFileArray, indexNum, null, window.top);
}

</script>
<%
int creater= Util.getIntValue(request.getParameter("creater"),0);
int creatertype=Util.getIntValue(request.getParameter("creatertype"),0);
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
//int userid = Util.getIntValue(request.getParameter("userid"), 0);
int userid=user.getUID();                   //当前用户id 
int usertype = (user.getLogintype()).equals("1") ? 0 : 1;
int languageid = Util.getIntValue(request.getParameter("languageid"), 7);
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int formid = Util.getIntValue(request.getParameter("formid"), 0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
int nodetype = Util.getIntValue(request.getParameter("nodetype"), 0);
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
int billid=Util.getIntValue(request.getParameter("billid"),0);
//int userid = Util.getIntValue(request.getParameter("userid"), 0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"),0);//父流程ID
int isremark = Util.getIntValue(request.getParameter("isremark"), 0);
String workflowtype = Util.null2String(request.getParameter("workflowtype"));
String topage = Util.null2String(request.getParameter("topage"));
String docFlags = Util.null2String((String)session.getAttribute("requestAdd"+requestid));
int docfileid = Util.getIntValue(request.getParameter("docfileid"));	//新建文档的工作流字段
if(docFlags.equals("")){
	docFlags = Util.null2String((String)session.getAttribute("requestAdd"+userid));
}

boolean IsCanModify="true".equals(session.getAttribute(userid+"_"+requestid+"IsCanModify"))?true:false;
boolean onlyview = false;
if((isremark==1&&!IsCanModify) || isremark ==8 || isremark ==9){
    onlyview = true;
}

String iswfshare = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"iswfshare"));
wfLayoutToHtml.setRequest(request);
wfLayoutToHtml.setUser(user);
wfLayoutToHtml.setIscreate(0);
wfLayoutToHtml.setIswfshare(iswfshare);

Hashtable ret_hs = wfLayoutToHtml.analyzeLayout();
boolean hasRemark = wfLayoutToHtml.getHasRemark();
session.setAttribute("req_"+requestid+"_"+nodeid+"_"+userid,hasRemark);
Hashtable otherPara_hs = wfLayoutToHtml.getOtherPara_hs();
String wfformhtml = Util.null2String((String)ret_hs.get("wfformhtml"));
StringBuffer jsStr = wfLayoutToHtml.getJsStr();
String needcheck = wfLayoutToHtml.getNeedcheck();

String logintype = Util.null2String(request.getParameter("logintype"));
String username = Util.null2String((String)session.getAttribute(userid+"_"+logintype+"username"));
String docCategory=Util.null2String((String)otherPara_hs.get("docCategory"));
Map secMaxUploads = (HashMap)otherPara_hs.get("secMaxUploads");//封装选择目录的信息

int annexmaxUploadImageSize = 0;
int annexsecId=0;
String isannexupload="";
String annexdocCategory="";
int hrmResourceShow = 0;
rs_html.executeSql("select isannexUpload , annexdoccategory, hrmResourceShow from workflow_base where id = " + workflowid);
if(rs_html.next()){
	isannexupload=Util.null2String(rs_html.getString("isannexUpload"));
	annexdocCategory=Util.null2String(rs_html.getString("annexdoccategory"));
	hrmResourceShow = Util.getIntValue(rs_html.getString("hrmResourceShow"));
	if("1".equals(isannexupload) && annexdocCategory!=null && !annexdocCategory.equals("")){
		annexsecId=Util.getIntValue(annexdocCategory.substring(annexdocCategory.lastIndexOf(',')+1));
	}
	annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
	if(annexmaxUploadImageSize<=0){
    	annexmaxUploadImageSize = 5;
    }
}

Map secCategorys = (HashMap)otherPara_hs.get("secCategorys");
ArrayList uploadfieldids=(ArrayList)otherPara_hs.get("uploadfieldids");    
int maxUploadImageSize_Para = Util.getIntValue((String)otherPara_hs.get("maxUploadImageSize"), -1);
int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
int maxUploadImageSize = -1;
if(maxUploadImageSize_Para > 0){
	maxUploadImageSize = maxUploadImageSize_Para;
}else{
	maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+secid),5);
}
if(maxUploadImageSize<=0){
	maxUploadImageSize = 5;
}

/*
 int uploadType = 0;
 String selectedfieldid = "";
 String result = RequestManager.getUpLoadTypeForSelect(workflowid);
 if(!result.equals("")){
 selectedfieldid = result.substring(0,result.indexOf(","));
 uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
 }
 */
 
 WorkflowComInfo workflowCominfo = new WorkflowComInfo();
 String selectedfieldid = String.valueOf(workflowCominfo.getSelectedCateLog(String.valueOf(workflowid)));
 int uploadType = workflowCominfo.getCatelogType(String.valueOf(workflowid));
 String selectfieldlable = "";
 String selectfieldvalue = "";
 
 if(uploadType==1 && !"".equals(selectedfieldid.trim())){
 	 String selectfieldsql = "";
	 if(isbill==1){
		 selectfieldsql = "SELECT bf.fieldlabel,bf.fieldname,b.tablename FROM workflow_billfield bf,workflow_bill b WHERE b.id=bf.billid AND bf.id="+selectedfieldid;
	 }else{
	 	 selectfieldsql = "select fl.fieldlable,fd.fieldname,'workflow_form' AS tablename  FROM workflow_fieldlable fl,workflow_formdict fd WHERE fl.fieldid=fd.id and fl.fieldid="+selectedfieldid+" AND fl.langurageid="+user.getLanguage()+" AND fl.formid="+formid;
	 }
 	 rs_html.executeSql(selectfieldsql);
 	 if(rs_html.next()){
 	    String _fieldlabel = rs_html.getString(1);
 	    String _fieldname = rs_html.getString("fieldname");
 	    String _tablename = rs_html.getString("tablename");
 		if(isbill==1){
 			selectfieldlable = SystemEnv.getHtmlLabelName(Util.getIntValue(_fieldlabel),user.getLanguage());
 		}else{
 			selectfieldlable = _fieldlabel;
 		}
 		rs_html.executeSql("select "+_fieldname+" from "+_tablename+" where requestid="+requestid);
 		if(rs_html.next()){
 		  	selectfieldvalue = rs_html.getString(1).trim();
 		}
 	 }
 }
   




//获得触发字段名


//导入明细跳转
String requestimport = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestimport"));

DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();
String trrigerdetailfield=ddi.GetEntryTriggerDetailFieldName();
String newStr = trrigerdetailfield;
if(!"".equals(trrigerdetailfield)){
	String[] array = trrigerdetailfield.split(",");
	StringBuilder sb = new StringBuilder();
	for (String str1 : array) {
		if(sb.indexOf(str1) != -1){
			continue;
		}
		sb.append(str1).append(",");
	}
		newStr = sb.toString().substring(0,sb.length()-1);
}
trrigerdetailfield = newStr;
int detailsum=0;
String isFormSignature=null;
int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
rs_html.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight  from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(rs_html.next()){
	isFormSignature = Util.null2String(rs_html.getString("isFormSignature"));
	formSignatureWidth= Util.getIntValue(rs_html.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
	formSignatureHeight= Util.getIntValue(rs_html.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
}

CodeBuild cbuild = new CodeBuild(formid,String.valueOf(isbill),workflowid,creater,creatertype);
CoderBean cb = cbuild.getFlowCBuild();
String fieldCode=Util.null2String(cb.getCodeFieldId());

rs_html.execute("select isview from workflow_nodeform where fieldid=-4 and nodeid=" + nodeid);
int isview_ = 0;
if(rs_html.next()){
	isview_ = Util.getIntValue(rs_html.getString("isview"), 0);
}

int formsignatureIndex = wfformhtml.indexOf(wfLayoutToHtml.HTML_FORMSIGNATURE_PLACEHOLDER);
if ("1".equals(isFormSignature) && formsignatureIndex != -1 && isview_ == 1){
	out.println(wfformhtml.substring(0, formsignatureIndex));
	String formsignatureafter = wfformhtml.substring(formsignatureIndex + wfLayoutToHtml.HTML_FORMSIGNATURE_PLACEHOLDER.length());
	

	String isSignMustInput="0";
	rs_html.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
	if(rs_html.next()){
		isSignMustInput = ""+Util.getIntValue(rs_html.getString("issignmustinput"), 0);
	}

	
	char flag1 = Util.getSeparator();
	rs_html.executeProc("workflow_RequestLog_SBUser",""+requestid+flag1+""+userid+flag1+""+usertype+flag1+"1");
	int workflowRequestLogId=-1;
	if(rs_html.next()){
		workflowRequestLogId=Util.getIntValue(rs_html.getString("requestLogId"),-1);
	}
%>
		<jsp:include page="/workflow/request/WorkflowLoadSignature.jsp">
			<jsp:param name="workflowRequestLogId" value="<%=workflowRequestLogId%>" />
			<jsp:param name="isSignMustInput" value="<%=isSignMustInput%>" />
			<jsp:param name="formSignatureWidth" value="<%=formSignatureWidth%>" />
			<jsp:param name="formSignatureHeight" value="<%=formSignatureHeight%>" />
            <jsp:param name="requestId" value="<%=requestid %>" />
            <jsp:param name="workflowId" value="<%=workflowid %>" />
            <jsp:param name="nodeId" value="<%=nodeid %>" />
		</jsp:include>

<%
	out.println(formsignatureafter);
} else {
	out.println(wfformhtml); //把模板解析后的文本输出到页面上




}
//新表单设计器,添加样式
int wfversion=Util.getIntValue(Util.null2String(ret_hs.get("wfversion")),0);
if(wfversion==2){
	out.println(ret_hs.get("wfcss"));
}

StringBuffer htmlHiddenElementsb = wfLayoutToHtml.getHtmlHiddenElementsb();
out.println(htmlHiddenElementsb.toString());
%>
<!-- ypc 2012-09-14 在这个地方 添加了 id="workflowid" id="isbill" id="formid"  -->
<iframe id="selectChangeDetail" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputformdetail" frameborder=0 scrolling=no src=""  style="display:none" ></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<input type=hidden name="workflowid" id="workflowid" value="<%=workflowid%>">	   <!--工作流id-->
<input type=hidden name="workflowtype" value="<%=workflowtype%>">   <!--工作流类型-->
<input type=hidden name="nodeid" value="<%=nodeid%>">			   <!--当前节点id-->
<input type=hidden name="nodetype" value="<%=nodetype%>">					 <!--当前节点类型-->
<input type=hidden name="src">									<!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" value="0">					 <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" id="formid" value="<%=formid%>">			   <!--表单的id-->
<input type=hidden name ="topage" value="<%=topage%>">			<!--创建结束后返回的页面-->
<input type=hidden name ="isbill" id="isbill" value="<%=isbill%>">			<!--是否单据 0:否 1:是-->
<input type=hidden name="billid" value="<%=billid%>">			 <!--单据id-->
<input type=hidden name ="method">								<!--新建文档时候 method 为docnew-->
<input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">

<input type=hidden name ="uploadType" id="uploadType" value="<%=uploadType %>">
<input type=hidden name ="selectfieldvalue" id="selectfieldvalue" value="<%=selectfieldvalue %>">


<input type=hidden name ="isMultiDoc" value=""><!--多文档新建-->

<input type="hidden" id="requestid" name ="requestid" value="<%=requestid%>">
<input type="hidden" id="rand" name="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" value="">
<input type="hidden" name="htmlfieldids" id="htmlfieldids">
<input type=hidden name='annexmaxUploadImageSize' id='annexmaxUploadImageSize' value=<%=annexmaxUploadImageSize%>>
<iframe name="delzw" width=0 height=0 style="border:none"></iframe>

<SCRIPT language="javascript">
var splitchar = "<%=WFLayoutToHtml.HTML_FIELDATTRSQL_SEPARATOR %>";

var js_hrmResourceShow = "<%=hrmResourceShow%>";
//字段属性联动依赖的全局对象
var wf__info = {
	"requestid": "<%=requestid %>",
	"workflowid": "<%=workflowid %>",
	"nodeid": "<%=nodeid %>",
	"formid": "<%=formid %>",
	"isbill": "<%=isbill %>",
	"onlyview": <%=onlyview %>,
	"f_bel_userid": "<%=userid %>",
	"f_bel_usertype": "<%=usertype %>",
	"datassplit": "<%=FieldAttrManager.DATAS_SEPARATOR %>",
	"paramsplit": "<%=FieldAttrManager.PARAM_SEPARATOR %>",
	"valuesplit": "<%=FieldAttrManager.VALUE_SEPARATOR %>"
};
</script>
<SCRIPT language="javascript">
//默认大小
var uploadImageMaxSize = <%=maxUploadImageSize%>;
var uploaddocCategory="<%=docCategory%>";
//填充选择目录的附件大小信息




var selectValues = new Array();
var maxUploads = new Array();
var uploadCategorys=new Array();
function setMaxUploadInfo(){
	<%
	if(secCategorys!=null&&secMaxUploads!=null&&secMaxUploads.size()>0){
		Set selectValues = secMaxUploads.keySet();
	
		for(Iterator i = selectValues.iterator();i.hasNext();){
			String value = (String)i.next();
			String maxUpload = (String)secMaxUploads.get(value);
			String uplCategory=(String)secCategorys.get(value);
	%>
	selectValues.push('<%=value%>');
	maxUploads.push('<%=maxUpload%>');
    uploadCategorys.push('<%=uplCategory%>');
	<%
		}
	}
	%>
}
setMaxUploadInfo();
//目录发生变化时，重新检测文件大小




function reAccesoryChanage(){
	<%
	if(uploadfieldids!=null){
    for(int i=0;i<uploadfieldids.size();i++){
    %>
    checkfilesize(oUpload<%=uploadfieldids.get(i)%>,uploadImageMaxSize,uploaddocCategory);
    showmustinput(oUpload<%=uploadfieldids.get(i)%>);
    <%}}%>
	
	checkfilesize2();
}

function changeMaxUpload2(fieldid,derecorderindex){

   var uploadMaxFieldisedit = jQuery("#uploadMaxField").attr("isedit");
   
   if(!!uploadMaxFieldisedit && uploadMaxFieldisedit=="1"){
	    var selectfieldv = jQuery("#"+fieldid).val();
		for(var i = 0;i<selectValues.length;i++)
		{
			var value = selectValues[i];
			if(value == selectfieldv)
			{
				uploadImageMaxSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		if(selectfieldv=="")
		{
			uploadImageMaxSize = 5;
			maxUploadImageSize = 5;
			uploaddocCategory="";
		    jQuery("#selectfieldvalue").val(selectfieldv);	
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
		}else{
			maxUploadImageSize = uploadImageMaxSize;
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
			});
		}
	}else{
   
    <%
	if(uploadType==1){
	    if(selectfieldvalue.equals("")){
	%>
			uploadImageMaxSize = 5;
			uploaddocCategory = "";
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
	<%  }else{%>
	        for(var i = 0;i<selectValues.length;i++)
			{
				var value = selectValues[i];
				if(value == "<%=selectfieldvalue%>")
				{
					uploadImageMaxSize = parseFloat(maxUploads[i]);
	                uploaddocCategory=uploadCategorys[i];
				}
			}
			maxUploadImageSize = uploadImageMaxSize;
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
			});
	<%
		}
	}
	%>
	
	
	
	}
}

//选择目录时，改变对应信息
function changeMaxUpload(fieldid){
	var efieldid = $G(fieldid);
	if(efieldid){
		var tselectValue = efieldid.value;
		for(var i = 0;i<selectValues.length;i++){
			var value = selectValues[i];
			if(value == tselectValue){
				uploadImageMaxSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		var oUploadArray = new Array();
		var oUploadfieldidArray = new Array();
		<%
		if(uploadfieldids!=null){
		   	for(int i=0;i<uploadfieldids.size();i++){
		   %>
		   try{
		oUploadArray.push(oUpload<%=uploadfieldids.get(i)%>);
		oUploadfieldidArray.push("<%=uploadfieldids.get(i)%>");
		}catch(e){}
		<%
			}
		}
		%>
		jQuery("#selectfieldvalue").val(tselectValue);	
		if(tselectValue=="")
		{
			uploadImageMaxSize = 5;
			uploaddocCategory = "";
			attachmentDisabled(oUploadArray,true,oUploadfieldidArray);
			
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
		}else{
			jQuery("span[id^='uploadspan']").each(function(){
				var viewtype = jQuery(this).attr("viewtype");
				if(viewtype == 1){
				    jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
				    maxUploadImageSize = uploadImageMaxSize;
				}else{
					jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
				}
			});
			attachmentDisabled(oUploadArray,false,oUploadfieldidArray);
		}
	}
}

<%
if(uploadType==1){
%>

function initUploadMax(){
	try{
    	<%
    	if(selectfieldvalue.equals("")){
    	%>
		setTimeout(function(){
				var oUploadArray = new Array();
				var oUploadfieldidArray = new Array();
				<%
				if(uploadfieldids!=null){
				   	for(int i=0;i<uploadfieldids.size();i++){
				   %>
				   try{
					oUploadArray.push(oUpload<%=uploadfieldids.get(i)%>);
					oUploadfieldidArray.push("<%=uploadfieldids.get(i)%>");
				   }catch(e){}
				<%
					}
				}
				%>
				uploadImageMaxSize = 5;
				uploaddocCategory = "";
				attachmentDisabled(oUploadArray,true,oUploadfieldidArray);
				
				var fieldlable = "<%=selectfieldlable%>";
				jQuery("span[id^='uploadspan']").each(function(){
					jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
				});
			},2000);
		
		<%}%>
    	
    }catch(e){}
}

initUploadMax();
<%}%>
/*
function funcClsDateTime(){
	var onlstr = new clsDateTime();
}				

if (window.addEventListener){
    window.addEventListener("load", funcClsDateTime, false);
}else if (window.attachEvent){
    window.attachEvent("onload", funcClsDateTime);
}else{
    window.onload=funcClsDateTime;
}*/

function createDoc(fieldbodyid,docVlaue,isedit)
{
	
	/*
   for(i=0;i<=1;i++){
  		parent.$G("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.$G("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$G("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.$G("oTDtype_1").className="cycleTDCurrent";
	*/
  	if("<%=isremark%>"=="9"||"<%=isremark%>"=="1"){
  		frmmain.action = "RequestDocView.jsp?requestid=<%=requestid%>&docValue="+docVlaue;
  	}else{
  	frmmain.action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docVlaue+"&isFromEditDocument=true";
  	}
	frmmain.method.value = "crenew_"+fieldbodyid ;
	frmmain.target="delzw";
	parent.delsave();
	if(check_form(document.frmmain,'requestname')){
		if($G("needoutprint")) $G("needoutprint").value = "1";//标识点正文




		document.frmmain.src.value='save';
		document.frmmain.isremark.value='0';
//保存签章数据
<%if("1".equals(isFormSignature)){%>
						try{  
					        if(typeof(eval("SaveSignature_save"))=="function"){
					              if(SaveSignature_save()){
									//附件上传
							        StartUploadAll();
							        checkuploadcompletBydoc();
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
					        StartUploadAll();
							        checkuploadcompletBydoc(); 
					    }
						
<%}else{%>
						//附件上传
        StartUploadAll();
        checkuploadcompletBydoc();
<%}%>
	}

}
function openDocExt(showid,versionid,docImagefileid,isedit){
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	
	// isAppendTypeField参数标识  当前字段类型是附件上传类型，不论该附件所在文档内容是否为空、或者存在最新版本，在该链接打开页面永远打开该附件内容、不显示该附件所在文档内容。




	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&isAppendTypeField=1");
	}
}

function openAccessory(fileId){ 
    var evt = getEvent();
    var targetObj = evt.srcElement||evt.target;
    var isImgFile = isImageFile(targetObj);
    if (isImgFile || jQuery(targetObj).is('img')) {

        if (!allImgFileArray) {
            allImgFileArray = new Array();
            var allfiles = jQuery(document.body).find('a[_fileid], img[_fileid]');
            for (var i=0; i<allfiles.length; i++) {
                if (jQuery(allfiles[i]).is('img') || isImageFile(allfiles[i])) {
                    allImgFileArray.push("/weaver/weaver.file.FileDownload?fileid="+ jQuery(allfiles[i]).attr('_fileid') +"&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>")
                }
            }
        }
        var playImageSrc = "/weaver/weaver.file.FileDownload?fileid="+ jQuery(targetObj).attr('_fileid') +"&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>";
        playImgs(playImageSrc);
        return ;
    }
    
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&fromrequest=1");
}
function onNewDoc(fieldid) {
	frmmain.action = "RequestOperation.jsp" ;
	frmmain.method.value = "docnew_"+fieldid ;
	frmmain.isMultiDoc.value = fieldid ;
	document.frmmain.src.value='save';
	//附件上传
        StartUploadAll();
        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
        checkuploadcomplet();
}

function isImageFile(targetObj) {
    var filePath = jQuery(targetObj).text();
    var fileFix = '';
    if (filePath.indexOf('.') != -1) {
        fileFix = filePath.substr(filePath.lastIndexOf('.') + 1).toLowerCase();
    }
    if (!!fileFix && (fileFix == 'jpg' || fileFix == 'png' || fileFix == 'gif' || fileFix == 'jpeg' || fileFix == 'bmp')) {
        return true;
    }
    return false;
}

<%
	RecordSet_zdl.execute("select * from workflow_nodefieldattr where nodeid="+ nodeid);
	while (RecordSet_zdl.next()) {
	
		int fieldid_tmp = Util.getIntValue(RecordSet_zdl.getString("fieldid"), 0);
%>
	if("<%=requestimport%>"=="1"){
		  setTimeout("doTriggerInit_doMathField()",500);
		  function doTriggerInit_doMathField(){
			 
			  doMathFieldAttr<%=fieldid_tmp%>();
		  }
	}
<%
	}
%>

function datainput(parfield){				<!--数据导入-->
	try{
		if(event.propertyName && event.propertyName.toLowerCase() != "value"){
			return;
		}
		var src = event.srcElement || event.target; 
		if(src.tagName.toLowerCase() == 'button'){
			return ;
		}
	}catch(e){}  
	//var xmlhttp=XmlHttp.create();
	var detailsum="0";
	try{
		detailsum=$G("detailsum").value;
	}catch(e){ detailsum="0";}
	var tempdata = "";
    var temprand = $GetEle("rand").value ;
	var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum="+detailsum+"&trg="+parfield;
	<%
	if(!trrigerfield.trim().equals("")){
		ArrayList Linfieldname=ddi.GetInFieldName();
		ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
		for(int i=0;i<Linfieldname.size();i++){
			String temp=(String)Linfieldname.get(i);
	%>
		if($G("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>").value);
	<%
		}
		for(int i=0;i<Lcondetionfieldname.size();i++){
			String temp=(String)Lcondetionfieldname.get(i);
	%>
		if($G("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>").value);
	<%
		}
	}
	%>
	var tempParfieldArr = parfield.split(",");
	for(var i=0;i<tempParfieldArr.length;i++){
	  	var tempParfield = tempParfieldArr[i];
		try{
	  	tempdata += $G(tempParfield).value+"," ;
		}catch(e){}
	}
	StrData += "&trgv="+tempdata+"&rand="+temprand+"&tempflag="+Math.random();
	StrData = StrData.replace(/\+/g,"%2B");
	if($G("datainput_"+parfield)){
		  	$G("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	}else{
	  		createIframe("datainput_"+parfield);
	  		$G("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	}
	//$G("datainputform").src="DataInputFrom.jsp?"+StrData;
	//xmlhttp.open("POST", "DataInputFrom.jsp", false);
	//xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	//xmlhttp.send(StrData);
}
function getWFLinknum(wffiledname){
	if($G(wffiledname) != null){
		return $G(wffiledname).value;
	}else{
		return 0;
	}
}
var defaultrows = 0;
var iframenameid = 0;
var temptime = 1;
var existArray = new Array();

function datainputdCreateIframe(iframenameid,StrData){
	  var iframe_datainputd = document.createElement("iframe");
      iframe_datainputd.id = "iframe_"+iframenameid;
	  iframe_datainputd.src = "";
	  iframe_datainputd.frameborder = "0";
	  iframe_datainputd.height = "0";
	  iframe_datainputd.scrolling = "no";
	  iframe_datainputd.style.display = "none";
	  document.body.appendChild(iframe_datainputd);
	  $GetEle("iframe_"+iframenameid).src="DataInputFromDetail.jsp?"+StrData;
}

Array.prototype.contains = function(obj){
  	var i = this.length;
  	while(i--){
  		if(this[i]===obj){
  			return true;
  		}
  	}
  	return false;
}
function datainputd(parfield){				<!--数据导入-->
    
	try{
		if(event.propertyName && event.propertyName.toLowerCase() != "value"){
			return;
		}
		
	}catch(e){}  
	if(parfield.indexOf("_")<0)return;
	//var xmlhttp=XmlHttp.create();
    var tempParfieldArr = parfield.split(",");
	var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;
	
	for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
      	var indexid=tempParfield.substr(tempParfield.indexOf("_")+1);
	<%
	if(!trrigerdetailfield.trim().equals("")){
		ArrayList Linfieldname=ddi.GetInFieldName();
		ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
		for(int i=0;i<Linfieldname.size();i++){
			String temp=(String)Linfieldname.get(i);
			
	%>
		if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value);
		
	<%
		}
	    for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
        if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value);
      <%
          }
		}
	%>
	}
	
	iframenameid++;
	StrData = StrData.replace(/\+/g,"%2B");
      //$GetEle("datainputformdetail").src="DataInputFromDetail.jsp?"+StrData;
	  if(existArray.contains(parfield)){ //延时执行
	        if(temptime>defaultrows){
	        	temptime = 1;
	        }else{
	        	//temptime++;
	        }  
	    	window.setTimeout(function(){ 
			    datainputdCreateIframe(iframenameid,StrData); 
			},100*temptime); 
	  }else{
	  	existArray.push(parfield);
	  	datainputdCreateIframe(iframenameid,StrData)
	  } 
	//xmlhttp.open("POST", "DataInputFrom.jsp", false); 
	//xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	//xmlhttp.send(StrData);
}

function changeChildField(obj, fieldid, childfieldid){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=<%=isbill%>&selectedfieldid=<%=selectedfieldid%>&uploadType=<%=uploadType%>&isdetail=0&selectvalue="+obj.value;
    $G("selectChange").src = "SelectChange.jsp?"+paraStr;
    //alert($G("selectChange").src);
}
function doInitChildSelect(fieldid,pFieldid,finalvalue, cnt){
	try{
		var pField = $G("field"+pFieldid);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				if (cnt == null || cnt == "") {
					cnt = 0;
				}
				var _callbackfc = function() {
			        doInitChildSelect(fieldid, pFieldid, finalvalue, cnt + 1);
			    };
			    if (cnt < 10) {
					window.setTimeout(_callbackfc , 500);
				}
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var field = $G("field"+fieldid);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectedfieldid=<%=selectedfieldid%>&uploadType=<%=uploadType%>&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_00";
				frm.style.display = "none";
			    document.body.appendChild(frm);
				$G("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
function doInitDetailchildSelectAdd(fieldid,pFieldid,rownum,childvalue){
	try{
		var pField = $G("field"+pFieldid+"_"+rownum);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_"+rownum;
				frm.style.display = "none";
			    document.body.appendChild(frm);
				
				var field = $G("field"+fieldid+"_"+rownum);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectvalue="+pFieldValue+"&isdetail=1&&rowindex="+rownum+"&childvalue="+childvalue;
				$G("iframe_"+pFieldid+"_"+fieldid+"_"+rownum).src = "SelectChange.jsp?"+paraStr;
				//$G("iframe_"+pFieldid+"_"+fieldid).src = "SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
function changeChildFieldDetail(obj, fieldid, childfieldid, rownum){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=<%=isbill%>&selectvalue="+obj.value+"&isdetail=1&&rowindex="+rownum;
    $G("selectChangeDetail").src = "SelectChange.jsp?"+paraStr;
    //alert($G("selectChange").src);
}
function doInitDetailchildSelect(fieldid,pFieldid,rownum,childvalue,cnt){
	try{
		var pField = $G("field"+pFieldid+"_"+rownum);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				if (cnt == null || cnt == "") {
					cnt = 0;
				}
				var _callbackfc = function() {
			        doInitChildSelect(fieldid, pFieldid, finalvalue, cnt + 1);
			    };
			    if (cnt < 10) {
					window.setTimeout(_callbackfc , 400);
				}
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var field = $G("field"+fieldid+"_"+rownum);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectvalue="+pFieldValue+"&isdetail=1&&rowindex="+rownum+"&childvalue="+childvalue;
				$G("iframe_"+pFieldid+"_"+fieldid+"_"+rownum).src = "SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
</script>
<script language="javascript">
function getNumber(index){
	 if($GetEle("field"+index).value != ""){
  	    $G("field_lable"+index).value = floatFormat($G("field"+index).value);
     }
	try{
		var elm = $GetEle("field_lable"+index);
		var n = getLocation(elm);
		setLocation(elm,n);
	}catch(e){}
}
function getNumber2(index) {
	if($G("field"+index).value != "") {
		$G("field_lable"+index).value = floatFormat($G("field"+index).value);
	}
}
//明细表中金额转换字段调用
function numberToChinese(index){
	if($G("field_lable"+index).value != ""){
		var floatNum = floatFormat($G("field_lable"+index).value);
		var val = numberChangeToChinese(floatNum);
		if(val == ""){
			alert("<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage())%>");
			$G("field_lable"+index).value = "";
			$G("field"+index).value = "";
		}else{
			$G("field_lable"+index).value = val;
			$G("field"+index).value = floatNum;
		}
	} else {
		$G("field"+index).value = "";
	}
}
var tableformatted = false;
var needformatted = true;
function formatTables(){
	if(needformatted){
		jQuery("table[name^='oTable']").each(function(i,n){
			tableformatted = true;
			formatTable(n);
		});
		jQuery("table[name^='oTable']").bind("resize",function(){
			formatTable(this);
		});
	}
}
jQuery(document).ready(function(){
	try{
		createTags();
	}catch(e){}
	<% String useNew = Util.null2String(new weaver.general.BaseBean().getPropValue("workflow_htmlNew","useNew"));
		String fixHeight = Util.null2String(new weaver.general.BaseBean().getPropValue("workflow_htmlNew","fixHeight"));
		if(fixHeight.equals("") || fixHeight.equals("0"))fixHeight = "49";
		if("1".equals(useNew)){
	%>
	formatTableNewInit();
	window.setTimeout(function(){
		startFormatTableNew();
	},100);
	<%}else{%>
		formatTables();	
	<%}%>
	
	var key =  "<%=userid%>"+"_"+"<%=requestid%>"+"requestimport"
	var requestimport = getCookie(key);
	var tempS = "<%=trrigerdetailfield%>";
		var temp_numps= new Array();
	temp_numps = tempS.split(",");
	if(requestimport=="1") {
		<%
			if(trrigerdetailfield!=null && !trrigerdetailfield.trim().equals("")) {
       %>	
		if(window.confirm('是否触发字段联动? ')) {
		for (var kk=0;kk<temp_numps.length ;kk++ ){ 
				jQuery('input[id^="'+temp_numps[kk]+'_"').each(function () {
					
					datainputd(this.id);
				});
			}
		}
		<%
			}
       %>	
	}
	setCookie(key,"0",1);
});
function setCookie(cname,cvalue,exdays)
{
  var d = new Date();
  d.setTime(d.getTime()+(exdays*24*60*60*1000));
  var expires = "expires="+d.toGMTString();
  document.cookie = cname + "=" + cvalue + "; " + expires;
}
 
function getCookie(cname)
{
  var name = cname + "=";
  var ca = document.cookie.split(';');
  for(var i=0; i<ca.length; i++) 
  {
    var c = ca[i].trim();
    if (c.indexOf(name)==0) return c.substring(name.length,c.length);
  }
  return "";
}

<%out.println(jsStr.toString());%>

if (window.addEventListener){
	window.addEventListener("load", showfieldpop, false);
}else if (window.attachEvent){
	window.attachEvent("onload", showfieldpop);
}else{
	window.onload=showfieldpop;
}
//发文字号初始值取得(TD20002)
	var hasinitfieldvalue=false
	var initfieldValue = -1;
	if($G("field<%=fieldCode%>")!=null&&$G("field<%=fieldCode%>span")!=null){
		if(!hasinitfieldvalue) {
			initfieldvalue = $G("field<%=fieldCode%>").value;
			hasinitfieldvalue = true;
		}
	}
function onChangeCode(ismand){
	if($G("field<%=fieldCode%>")!=null&&$G("field<%=fieldCode%>span")!=null){
		initDataForWorkflowCode();
		if($G("field<%=fieldCode%>").value == "" || $G("field<%=fieldCode%>").value == initfieldvalue) {
			return;
		} else {
        	$G("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?operation=ChangeCode&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&ismand="+ismand+"&returnCodeStr="+escape($G("field<%=fieldCode%>").value) +"&oldCodeStr="+initfieldvalue;
        }
	}
}

var msgWarningJinEConvert = "<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage())%>";
</script>
<script type="text/javascript" language="javascript" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/js/selectDateTime_wev8.js"></script>
<%
	if("1".equals(useNew)){
%>
<style type="text/css">
	Table.ListStyle  TBODY  TR TD{
		padding-top:1px !important;
		padding-bottom:1px !important;
	}
</style>
<%}else{%>
	<style type="text/css">
	Table.ListStyle  TBODY  TR TD.detailfield{
		height: <%=fixHeight+"px"%>;
	}
</style>
<%}%>