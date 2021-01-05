<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
</HEAD>
<body scroll="no">
<%
    String subcompanyid = "5" ;
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="blog"/>
   <jsp:param name="navName" value="这里是弹出框打开的页面" />
</jsp:include>
<wea:layout type="fourCol">
     <wea:group context="常用条件">
      <wea:item>流程</wea:item>
      <wea:item>
        <brow:browser name="workflowid" viewType="0" hasBrowser="true" hasAdd="false"
        					browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isTemplate=0&iswfec=1"
        					isMustInput="1" isSingle="true" hasInput="true"
         					completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0"
         					width="300px" browserValue="" browserSpanValue="" />
      </wea:item>
      <wea:item>人员</wea:item>
      <wea:item>
        <brow:browser name="userid" viewType="0" hasBrowser="true" hasAdd="false"
                          browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" %>'
                          isMustInput="2"
                          isSingle="false"
                          hasInput="true"
                          completeUrl="/data.jsp?type=1"  width="300px"
                          browserValue=''
                          browserSpanValue=''
                          />
      </wea:item>
     </wea:group>
</wea:layout>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(725,user.getLanguage()) %>" id="zd_btn_submit" class="zd_btn_submit" onclick="javascript:doSave(this)">
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="clostWin();">
	    </td></tr>
	</table>
</div>


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td class="rightSearchSpan" style="text-align:right;" >
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(725,user.getLanguage()) %>" class="e8_btn_top" onclick="javascript:doSave(this)">
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu" id="rightclickcornerMenu">
			</span>
		</td>
	</tr>
</table>

<script type="text/javascript">
var pdialog = parent.getDialog(window);//获取窗口对象；
var parentWin = parent.getParentWindow(window);//获取父对象；
function clostWin(){
	pdialog.close();
}

function doSave(){
    alert("保存数据");//假设数据保存成功，刷新父窗口，关闭弹窗
    parentWin.location.reload();
    pdialog.close();
}
</script>
 </body>
</html>
