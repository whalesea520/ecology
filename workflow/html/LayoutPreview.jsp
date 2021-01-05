
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*,java.util.*,weaver.hrm.*,weaver.systeminfo.*" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
<LINK href="/js/jquery/jquery_dialog_wev8.css" type=text/css rel=STYLESHEET>
<link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/green/wui_wev8.css'/>
<link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF">
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>
<script language=javascript src="/js/jquery/jquery_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/workflow/request/js/requesthtml_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/workflow/exceldesign/css/excelHtml_wev8.css" />
</HEAD>
<body>
<jsp:useBean id="wfLayoutToHtml" class="weaver.workflow.html.WFLayoutToHtml" scope="page" />
<jsp:useBean id="rs_html" class="weaver.conn.RecordSet" scope="page" />
<form id="frmmain" name="frmmain" target="self" action="" method="post">
<div id="rightMenu" name="rightMenu"  style="Z-INDEX:1000;height:0px;width:0px">
<iframe id="rightMenuIframe" name="rightMenuIframe"  frameborder=0 marginheight=0 marginwidth=0 hspace=0 vspace=0 scrolling=no width="0px" height="0px" >
</iframe>
</div>
<%

int modeid = Util.getIntValue(request.getParameter("modeid"), 0);
wfLayoutToHtml.setRequest(request);
wfLayoutToHtml.setUser(user);
wfLayoutToHtml.setIscreate(1);
Hashtable ret_hs = wfLayoutToHtml.analyzeLayout();
String wfformhtml = Util.null2String((String)ret_hs.get("wfformhtml"));
out.println(wfformhtml);
StringBuffer jsStr = wfLayoutToHtml.getJsStr();
%>

</form>
</body>
</HTML>
<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>
<SCRIPT language="javascript">
<%out.println(jsStr.toString());%>
function initFieldValue(fieldid){

}

function doSqlFieldAjax(obj,fieldids){

}

function doFieldAjax(thisfieldid,fieldidtmp,fieldExt){

}

</script>
<SCRIPT language="javascript">

function setMaxUploadInfo(){

}
setMaxUploadInfo();
//目录发生变化时，重新检测文件大小
function reAccesoryChanage(){

}
//选择目录时，改变对应信息
function changeMaxUpload(fieldid){

}
function funcClsDateTime(){

}				

function createDoc(fieldbodyid,docVlaue,isedit){

}
function openDocExt(showid,versionid,docImagefileid,isedit){

}

function openAccessory(fileId){ 

}
function onNewDoc(fieldid) {

}

function datainput(parfield){

}
function getWFLinknum(wffiledname){

}
function datainputd(parfield){

}

function changeChildField(obj, fieldid, childfieldid){

}
function doInitChildSelect(fieldid,pFieldid,finalvalue){

}
function doInitDetailchildSelectAdd(fieldid,pFieldid,rownum,childvalue){

}
function changeChildFieldDetail(obj, fieldid, childfieldid, rownum){

}
function doInitDetailchildSelect(fieldid,pFieldid,rownum,childvalue){

}
</script>
<script type="text/javascript">
function onShowBrowser3(id,url,linkurl,type1,ismand) {

}

function onShowBrowser2(id,url,linkurl,type1,ismand, funFlag) {

}

function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {

}

function onShowResourceConditionBrowser(id, url, linkurl, type1, ismand) {

}
function doFieldDateAjax(para, fieldidtmp, fieldExt){
}
</script>
<script language="javascript">
function getNumber(index){

}
function numberToChinese(index){

}
var tableformatted = false;
var needformatted = true;
function formatTables(){

}
function doDisableAll_s(){
	jQuery("*").removeAttr("onchange");
	jQuery("*").removeAttr("onclick");
	jQuery("*").removeAttr("onBlur");
	jQuery("*").removeAttr("onKeyPress");
	jQuery("*").removeAttr("onpropertychange");
	jQuery("*").removeAttr("onfocus");
	//jQuery("*").removeAttr("onblur");
}
jQuery(document).ready(function(){
	try{
		createTags();
	}catch(e){}
	formatTables();
	doDisableAll_s();
});


function onChangeCode(ismand){

}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>