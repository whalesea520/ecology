
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.DesUtil"%>	
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
DesUtil desUtilitem = new DesUtil();
String udesid=desUtilitem.encrypt(user.getUID()+"");
String utype=user.getLogintype();
%>

<script>
   window.top.udesid='<%=udesid%>';
   window.top.utype='<%=utype%>';
   window.top.imguploadurl="/docs/docs/DocImgUploadOnly.jsp?userid="+window.top.udesid+"&usertype="+window.top.utype;
</script>

<!--
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
-->
<!--swfupload相关-->
<script type="text/javascript" src="/js/page/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/handlers_wev8.js"></script>
<link href="/js/page/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>

<link type="text/css" href="/ueditor/ueditorextend_wev8.css" rel="stylesheet"></link>
<!--图片上传插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>

<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>


<%@ page import="java.io.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="pm" class="weaver.page.PageManager" scope="page" />
<%
//把权限判断放到最上面，不影响下面的初始化对象、参数
if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
}
String titlename = "";
String newstempid = Util.null2String(request.getParameter("newstempid"));
String newstype = Util.null2String(request.getParameter("newstemptype"));
String operation = Util.null2String(request.getParameter("operation"));
String isCreate = Util.null2String(request.getParameter("isCreate"));
String newstempname = "";
String newstempdesc = "";
String templatedir = "";
StringBuffer htmlStr = new StringBuffer();
if(!"".equals(newstempid)){
	rs.executeSql("select templatename,templatedesc,templatetype,templatedir from pagenewstemplate where id ="+newstempid);
	String newstempPath = pc.getConfig().getString("news.path");
	if(rs.next()){
		newstempname = rs.getString("templatename");
		newstempdesc = rs.getString("templatedesc");
		templatedir = rs.getString("templatedir");
	}
	File file = new File(pm.getRealPath(newstempPath+templatedir+"index.htm"));
	BufferedReader reader = null;
	try {
		FileInputStream in = new FileInputStream(file);
	    reader = new BufferedReader(new InputStreamReader(in,"UTF-8"));
	    String tempString = null;
	    int line = 1;
	    // 一次读入一行，直到读入null为文件结束
	    while ((tempString = reader.readLine()) != null) {
	        // 显示行号
	        htmlStr.append(tempString);
	        line++;
	    }
	    reader.close();
	} catch (IOException e) {
	    e.printStackTrace();
	} finally {
	    if (reader != null) {
	        try {
	            reader.close();
	        } catch (IOException e1) {
	        }
	    }
	}
}
%>

<HTML>
<TITLE></TITLE>
<HEAD>
<link href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<link href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script type="text/javascript" language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/jquery/jquery_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>

<style  id="thisStyle">
input.smallInput{
border:0 solid #fff;
FONT-SIZE: 9pt; 
FONT-STYLE: normal; 
FONT-VARIANT: normal; 
FONT-WEIGHT: normal; 
HEIGHT: 28px;
WIDTH:50; 
BACKGROUND-COLOR:#fff;
LINE-HEIGHT: normal;
}
</style>

<%
String layoutname = "";
String closeDialog = Util.null2String(request.getParameter("closeDialog"));
int layouttype = 0;
int modeid = 0;
%>

</HEAD>

<BODY style="MARGIN: 0px;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(23088,user.getLanguage())%>"/> 
		</jsp:include>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if(!"1".equals(isCreate)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+",javascript:saveNew(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if(layouttype == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20873,user.getLanguage())+SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage())+",javascript:onPrepPrintMode(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
//RCMenu += "{"+SystmEnv.getHtmlLabelName(64,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:onImportLayout(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;//导入
if(modeid > 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(64,user.getLanguage())+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+",javascript:onExportLayout(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;//导出
	RCMenu += "{"+SystemEnv.getHtmlLabelName(64,user.getLanguage())+SystemEnv.getHtmlLabelName(23690,user.getLanguage())+",javascript:onPreviewLayout(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;//预览
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="onSave();">
						<%if(!"1".equals(isCreate)){%>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="saveNew();">
						<%}%>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="onDel();">
						
						<%
						if(layouttype == 1){
							%>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="onPrepPrintMode()">
					
							<%
						}
						%>
						
						<%
						if(modeid > 0){
							%>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(64,user.getLanguage())+SystemEnv.getHtmlLabelName(17416,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="onExportLayout()">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(64,user.getLanguage())+SystemEnv.getHtmlLabelName(23690,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="onPreviewLayout()">
							<%
						}
						%>
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
<form id="newstempForm" name="newstempForm" action="NewsTemplateoperate.jsp" target="_self" method="post">
<input id="operation" name="operation" type="hidden" value="<%=operation %>" />
<input id="pageUrl" name="pageUrl" type="hidden" value="edit" />
<input id="templatedir" name="templatedir" type="hidden" value="<%=templatedir %>" />
<input id="newstempid" name="newstempid" type="hidden" value="<%=newstempid %>" />
<wea:layout type="4Col">
     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
      <wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
      <wea:item>
        <wea:required id="newstempnamespan" required="true" value='<%=newstempname%>'>
         <input type="text" id="newstempname" name="newstempname" onchange="checkinput('newstempname','newstempnamespan');" value="<%=newstempname%>"/>
         </wea:required>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(18627,user.getLanguage())%></wea:item>
      <wea:item>
         <input type="text" id="newstempdesc" name="newstempdesc" value="<%=newstempdesc%>"/>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(19789,user.getLanguage())%></wea:item>
      <wea:item>
        <select id="newstemptype" name="newstemptype" >
			<option value="0" <%="0".equals(newstype)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(33532,user.getLanguage())%></option>
			<option value="1" <%="1".equals(newstype)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(33533,user.getLanguage())%></option>
		</select>
      </wea:item>
      <wea:item>&nbsp;</wea:item>
      <wea:item>&nbsp;</wea:item>
     </wea:group>
</wea:layout>
<%
String display = "none";
if(!"saveNew".equals(operation)){ 
	display = "";
%>
<wea:layout type="2Col" attributes="{'cw1':\"*\",'cw2':\"180\"}">
     <wea:group context="" attributes="{'groupDisplay':\"none\"}">
      <wea:item>
      		
			<textarea name="newstemptext" id="newstemptext" style="width:100%;height:100%"><%=Util.encodeAnd(htmlStr.toString())%></textarea>
		
	  </wea:item>
      <wea:item>
         <B><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></B>
         <select id="labellist_1" name="labellist_1" class="labellist" size="15" notBeauty="true" ondblclick="javascript:cool_webcontrollabel(this);" style="height:335px;width:160px;display:''">
			<option value="newsTitle" >$<%=SystemEnv.getHtmlLabelName(32184,user.getLanguage())%></option>
			<option value="newsContent" >$<%=SystemEnv.getHtmlLabelName(32185,user.getLanguage())%></option>
			<option value="newsCreateDate" >$<%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></option>
			<option value="newsAuthor" >$<%=SystemEnv.getHtmlLabelName(32187,user.getLanguage())%></option>
			<option value="newsReadCount" >$<%=SystemEnv.getHtmlLabelName(19584,user.getLanguage())%></option>
			<option value="newsAccessories" >$<%=SystemEnv.getHtmlLabelName(32186,user.getLanguage())%></option>
			<!-- <option value="newsOperation" nodeType="1">其它操作</option> -->
		</select>
		<div id="htmllayoutdiv" name="htmllayoutdiv" style="height:0px;width:0px;visibility:hidden"></div>
      </wea:item>
     </wea:group>
</wea:layout>
<%} %>
</form>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
	 	</wea:item>
	</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</BODY>
<script language="javascript">
var ue ;

$(document).ready(function(){
	initFckEdit();
})

function initFckEdit(){
	
	ue = UE.getEditor('newstemptext',{
	  toolbars: window.UEDITOR_CONFIG.newstemplatetoolbars,
	  initialFrameHeight:380
	});
	
	//FCKEditorExt.initEditor("newstempForm","newstemptext",<%=user.getLanguage()%>,FCKEditorExt.HtmlLayout_IMAGE);
}
//往左边Fck编辑框里加一个字段显示名
function cool_webcontrollabel(obj){
	//var fckHtml = FCKEditorExt.getHtml("newstemptext");
	var fckHtml = ue.getContent();
	var htmlStr = obj.options.item(obj.selectedIndex).text;
	var html = replaceTag(htmlStr);
	if(html!=""&&fckHtml.indexOf(html) != -1){
		obj.options.item(obj.selectedIndex).style.color="#bfbfbf";
		return;
	}
	var labelhtml = html;
	 ue.execCommand('inserthtml', labelhtml); 
	//alert(obj);
}

function replaceTag(htmlStr){
	//for(int i=0;i<7;i++){
		if(htmlStr.indexOf("$"+"<%=SystemEnv.getHtmlLabelName(32184,user.getLanguage())%>")!=-1){
			htmlStr = htmlStr.replace("$"+"<%=SystemEnv.getHtmlLabelName(32184,user.getLanguage())%>","$"+"{newsTitle}");
		}else if(htmlStr.indexOf("$"+"<%=SystemEnv.getHtmlLabelName(32185,user.getLanguage())%>")!=-1){
			htmlStr = htmlStr.replace("$"+"<%=SystemEnv.getHtmlLabelName(32185,user.getLanguage())%>","$"+"{newsContent}");
		}else if(htmlStr.indexOf("$"+"<%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%>")!=-1){
			htmlStr = htmlStr.replace("$"+"<%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%>","$"+"{newsCreateDate}");
		}else if(htmlStr.indexOf("$"+"<%=SystemEnv.getHtmlLabelName(32187,user.getLanguage())%>")!=-1){
			htmlStr = htmlStr.replace("$"+"<%=SystemEnv.getHtmlLabelName(32187,user.getLanguage())%>","$"+"{newsAuthor}");
		}else if(htmlStr.indexOf("$"+"<%=SystemEnv.getHtmlLabelName(19584,user.getLanguage())%>")!=-1){
			htmlStr = htmlStr.replace("$"+"<%=SystemEnv.getHtmlLabelName(19584,user.getLanguage())%>","$"+"{newsReadCount}");
		}else if(htmlStr.indexOf("$"+"<%=SystemEnv.getHtmlLabelName(32186,user.getLanguage())%>")!=-1){
			htmlStr = htmlStr.replace("$"+"<%=SystemEnv.getHtmlLabelName(32186,user.getLanguage())%>","$"+"{newsAccessories}");
		}
	//}
	return htmlStr;
}

function onSave(){
    
	//FCKEditorExt.updateContent();
	var editor_data = ue.getContent();
	jQuery("#newstemptext").val(editor_data);
		
	if(check_form(newstempForm,"newstempname")){
		newstempForm.submit();
		enableAllmenu();
	}
}

function onDel(){
	if(jQuery("#newstempid").val()!=""){
		newstempForm.operation.value="delTemplate";
		newstempForm.submit();
		enableAllmenu();
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(84159,user.getLanguage())%>");
	}
}

function saveNew(){
	if(check_form(newstempForm,"newstempname")){
		newstempForm.operation.value="saveNew";
		newstempForm.submit();
		enableAllmenu();
	}
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

jQuery(document).ready(function (){
	resizeDialog(document);
	var closeDialog = "<%=closeDialog%>";
	if(closeDialog=="close"){
		var parentWin = parent.getParentWindow(window); 
		parentWin.location.reload();
		onCancel();
	}
})
</script>
</HTML>
