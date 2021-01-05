
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,java.util.*,weaver.hrm.*,weaver.systeminfo.*" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.workflow.html.FieldAttrManager"%>
<jsp:useBean id="wfNodeFieldManager" class="weaver.workflow.workflow.WFNodeFieldManager" scope="page" />
<jsp:useBean id="wfLayoutToHtml" class="weaver.workflow.html.WFLayoutToHtml" scope="page" />
<jsp:useBean id="rs_html" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RequestLogIdUpdate" class="weaver.workflow.request.RequestLogIdUpdate" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/workflow/request/js/requesthtml_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>

<!-- 新表单设计器 -->
<script type="text/javascript" src="/wui/common/jquery/plugin/Listener_wev8.js"></script>
<!-- onpropertychange事件支持 -->
<script type="text/javascript" src="/js/workflow/VCEventHandle_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/workflow/exceldesign/css/excelHtml_wev8.css" />
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<script type="text/javascript">
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>
<script>
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
</script>

<%
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();   
int languageid = Util.getIntValue(request.getParameter("languageid"), 7);
int usertype = (user.getLogintype()).equals("1") ? 0 : 1;
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int formid = Util.getIntValue(request.getParameter("formid"), 0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
int nodetype = Util.getIntValue(request.getParameter("nodetype"), 0);
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
int isrequest = Util.getIntValue(request.getParameter("isrequest"), 0);
int billid=Util.getIntValue(request.getParameter("billid"),0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int isremark = Util.getIntValue(request.getParameter("isremark"), 0);
String workflowtype = Util.null2String(request.getParameter("workflowtype"));
String topage = Util.null2String(request.getParameter("topage"));
String docFlags = Util.null2String((String)session.getAttribute("requestAdd"+requestid));
int isprint = Util.getIntValue(request.getParameter("isprint"), 0);
int docfileid = Util.getIntValue(request.getParameter("docfileid"));	//新建文档的工作流字段
if(docFlags.equals("")){
	docFlags = Util.null2String((String)session.getAttribute("requestAdd"+userid));
}
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"),0);//父流程ID

String iswfshare = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"iswfshare"));
String ismultiprintmode = Util.null2String(session.getAttribute(userid + "" + requestid+ "ismultiprintmode"));  //批量打印
String isFormSignature=null;
String pdfprint = "";
rs_html.executeSql("select isFormSignature,pdfprint from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(rs_html.next()){
	isFormSignature = Util.null2String(rs_html.getString("isFormSignature"));
	pdfprint = Util.null2String(rs_html.getString("pdfprint"));
}
//add by liaodong for qc76528,73697 in 2013-10-09 start 
Hashtable otherPara_hs = new Hashtable();
boolean isRemarkInnerMode =false;
StringBuffer jsStr = new StringBuffer();
String needcheck = "";
wfLayoutToHtml.setIsPrint(isprint);
wfLayoutToHtml.setRequest(request);
wfLayoutToHtml.setUser(user);
wfLayoutToHtml.setIscreate(0);
wfLayoutToHtml.setIswfshare(iswfshare);
Hashtable ret_hs = wfLayoutToHtml.analyzeLayout();
int wfversion = Util.getIntValue(Util.null2String(ret_hs.get("wfversion")),0);
String wfformhtml = Util.null2String((String)ret_hs.get("wfformhtml"));
String wfcss = Util.null2String(ret_hs.get("wfcss"));
boolean transPdfPrint = (isprint==1 && wfversion==2 && "1".equals(pdfprint) && request.getHeader("USER-AGENT").toLowerCase().indexOf("chrome")==-1);
//新版设计器IE下转PDF打印按钮
if(transPdfPrint && false){	//屏蔽PDF打印
%>
<div style="text-align:right;">
	<input type="button" class="e8_btn_top_first" onclick="transPdfPrint();" value="<%=SystemEnv.getHtmlLabelName(83180, user.getLanguage()) %>"/>
	<div id="tempDiv" style="display:none">
		<textarea name="pdf_html"></textarea>
		<textarea name="pdf_css"><%=wfcss %></textarea>
		<input type="hidden" name="pdf_requestid" value="<%=requestid %>" />
		<input type="hidden" name="pdf_userid" value="<%=user.getUID() %>" />
	</div>
</div>
<%
}
out.println(wfformhtml);
//新表单设计器,添加样式
if(wfversion==2){
	out.println(wfcss);
}
otherPara_hs = wfLayoutToHtml.getOtherPara_hs();
jsStr = wfLayoutToHtml.getJsStr();
needcheck = wfLayoutToHtml.getNeedcheck();
isRemarkInnerMode = wfLayoutToHtml.getIsRemarkInnerMode();
StringBuffer htmlHiddenElementsb = wfLayoutToHtml.getHtmlHiddenElementsb();
out.println(htmlHiddenElementsb.toString());


String logintype = Util.null2String(request.getParameter("logintype"));
String username = Util.null2String((String)session.getAttribute(userid+"_"+logintype+"username"));
String docCategory=Util.null2String(request.getParameter("docCategory"));
Map secMaxUploads = (HashMap)otherPara_hs.get("secMaxUploads");//封装选择目录的信息




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
//获得触发字段名




DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();
String trrigerdetailfield=ddi.GetEntryTriggerDetailFieldName();
int detailsum=0;
int printflowcomment = 0;
int ishidearea = 0;
rs.execute("select * from workflow_flownode where nodeid="+nodeid+" and workflowid="+workflowid);
if(rs.next()){
    printflowcomment = Util.getIntValue(rs.getString("printflowcomment"), 1);
    ishidearea = Util.getIntValue(rs.getString("ishidearea"), 0);
}
//printflowcomment 0 始终不打印流转意见 1 流转意见放入模板时不打印 2 始终打印流转意见
if (isprint == 1 && (printflowcomment == 2 ||( printflowcomment == 1 && !isRemarkInnerMode  ))) {
	boolean isOldWf = "true".equals(Util.null2String(request.getParameter("isOldWf"))) ? true : false;
	boolean isurger = "true".equals(Util.null2String(request.getParameter("isurger"))) ? true : false;
	boolean wfmonitor = "true".equals(Util.null2String(request.getParameter("wfmonitor"))) ? true : false;
%>
	<jsp:include page="WorkflowViewSignAction.jsp" flush="true">
		<jsp:param name="workflowid" value="<%=workflowid%>" />
		<jsp:param name="languageid" value="<%=user.getLanguage()%>" />
		<jsp:param name="requestid" value="<%=requestid%>" />
		<jsp:param name="userid" value="<%=userid%>" />
		<jsp:param name="usertype" value="<%=Integer.parseInt(user.getLogintype()) - 1 %>" />
		<jsp:param name="isprint" value="<%=isprint == 1%>" />
		<jsp:param name="nodeid" value="<%=nodeid%>" />
		<jsp:param name="isOldWf" value="<%=isOldWf%>" />
		<jsp:param name="desrequestid" value="<%=desrequestid%>" />
		<jsp:param name="isurger" value="<%=isurger%>" />
		<jsp:param name="wfmonitor" value="<%=wfmonitor%>" />	
	</jsp:include>
<%
} 
%>

<%if(isprint == 1 && (printflowcomment==0 || (printflowcomment == 1 && isRemarkInnerMode) || ishidearea == 1) &&  !"1".equals(ismultiprintmode) ){
%>
<script type="text/javascript">
jQuery(function () {
	judgeBrowserPrint();  //弹出预览
});
</script>
<%}%>
<iframe id="fileDownload" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputformdetail" frameborder=0 scrolling=no src=""  style="display:none" ></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<input type=hidden name="workflowid" value="<%=workflowid%>">	   <!--工作流id-->
<input type=hidden name="workflowtype" value="<%=workflowtype%>">   <!--工作流类型-->
<input type=hidden name="nodeid" value="<%=nodeid%>">			   <!--当前节点id-->
<input type=hidden name="nodetype" value="<%=nodetype%>">					 <!--当前节点类型-->
<input type=hidden name="src">									<!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" value="0">					 <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">			   <!--表单的id-->
<input type=hidden name ="topage" value="<%=topage%>">			<!--创建结束后返回的页面-->
<input type=hidden name ="isbill" value="<%=isbill%>">			<!--是否单据 0:否 1:是-->
<input type=hidden name="billid" value="<%=billid%>">			 <!--单据id-->
<input type=hidden name ="method">								<!--新建文档时候 method 为docnew-->
<input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">

<input type=hidden name ="isMultiDoc" value=""><!--多文档新建-->

<input type="hidden" id="requestid" name ="requestid" value="<%=requestid%>">
<input type="hidden" id="rand" name="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" value="">
<input type="hidden" id="desrequestid" name ="desrequestid" value="<%=desrequestid%>">
<iframe name="delzw" width=0 height=0 style="border:none"></iframe>
<style type="text/css">
<%
if (isprint == 1) {
%>
.liststyle {
	*table-layout:auto!important;
}
<%
}
%>
</style>
<SCRIPT language="javascript">
//字段属性联动依赖的全局对象
var wf__info = {
	"requestid": "<%=requestid %>",
	"workflowid": "<%=workflowid %>",
	"nodeid": "<%=nodeid %>",
	"formid": "<%=formid %>",
	"isbill": "<%=isbill %>",
	"f_bel_userid": "<%=userid %>",
	"f_bel_usertype": "<%=usertype %>",
	"onlyview": true,
	"datassplit": "<%=FieldAttrManager.DATAS_SEPARATOR %>",
	"paramsplit": "<%=FieldAttrManager.PARAM_SEPARATOR %>",
	"valuesplit": "<%=FieldAttrManager.VALUE_SEPARATOR %>"
};

<%out.println(jsStr.toString());%>

jQuery(document).ready(function () {
	var jeEles = jQuery("input[_printflag=1]");
	jeEles.each(function () {
		var jeEle = jQuery(this);
		var jeEleVal = jeEle.val();
		jeEle.hide();
		jeEle.after("<span>" + jeEleVal + "</span>");
		
	});
	
	jeEles = jQuery("select[_printflag=1]");
	jeEles.each(function () {
		var jeEle = jQuery(this);
		var jeOption = jeEle.children("[selected]")
		var jeEleVal = jeOption.text();
		jeEle.hide();
		jeEle.after("<span>" + jeEleVal + "</span>");
		
	});
	<%
	if (isprint == 1) { 
	%>
	jQuery("a[name=MeetingRoomPlanLink]").hide();
	<%
	}
	%>
	
	
	
});
</script>
<SCRIPT language="javascript">
function createDoc(fieldbodyid,docVlaue,tempdocview){
	
  	frmmain.action = "RequestDocView.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&docValue="+docVlaue;
    frmmain.method.value = "crenew_"+fieldbodyid ;
    frmmain.target="delzw";
    parent.delsave();
	if(check_form(document.frmmain,'requestname')){
      	if(document.getElementById("needoutprint")) document.getElementById("needoutprint").value = "1";//标识点正文




        document.frmmain.src.value='save';
        //附件上传
        StartUploadAll();
        checkuploadcomplet();
		parent.clicktext();//切换当前tab页到正文页面
		if(document.getElementById("needoutprint")) document.getElementById("needoutprint").value = "";//标识点正文




    }
	//frmmain.submit();
}
function downloads(files){
	document.location.href="/weaver/weaver.file.FileDownload?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&fileid="+files+"&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&fromrequest=1";
}
function openDocExt(showid,versionid,docImagefileid,isedit){
	// isAppendTypeField参数标识  当前字段类型是附件上传类型，不论该附件所在文档内容是否为空、或者存在最新版本，在该链接打开页面永远打开该附件内容、不显示该附件所在文档内容。




	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=<%=isrequest%>&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=<%=isrequest%>&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&isAppendTypeField=1");
	}
}
function openAccessory(fileId){ 
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&fileid="+fileId+"&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&fromrequest=1");
}

function uploadbuttonon(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#52ab2f");
	}
}

function uploadbuttonout(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#6bcc44");
	}
}

function changefileaon(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#008aff!important;text-decoration:underline!important;margin-top:1px;");
}

function changefileaout(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#8b8b8b!important;text-decoration:none!important;margin-top:1px;");
}
</script>
<script language="javascript">
function downloadsBatch(fieldvalue,requestid)
{ 
jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
$G("fileDownload").src="/weaver/weaver.file.FileDownload?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&fieldvalue="+fieldvalue+"&download=1&downloadBatch=1&desrequestid=<%=desrequestid%>&requestid="+requestid;
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
	<%if(isprint == 1){%>
	try{
		createTags();
	}catch(e){}
	<%}%>
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
	//模板含签字意见的自动弹打印

	//<%if(isRemarkInnerMode && isprint == 1 && !"1".equals(ismultiprintmode)){ %>
	//	judgeBrowserPrint();
	//<%}%>
});

function transPdfPrint(){
	var excelTempDiv = jQuery("div.excelTempDiv").clone();
	excelTempDiv.find("input[type='hidden']").remove();
	excelTempDiv.find("a").removeAttr("onmouseover").removeAttr("onclick");
	jQuery("div#tempDiv textarea[name='pdf_html']").text(excelTempDiv.html());
	jQuery("[name='frmmain']").attr("action", "/workflow/request/WorkflowViewRequestExcelPrint.jsp").attr("target", "_blank");
	document.frmmain.submit();
}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
<%
	if("1".equals(useNew)){
%>

<%}else{%>
	<style type="text/css">
	Table.ListStyle  TBODY  TR TD.detailfield{
		height: <%=fixHeight+"px"%>;
		color:#000000;
	}
</style>
<%}%>