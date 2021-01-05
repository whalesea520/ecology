
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/docs/common.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	String hasTab = Util.null2String(request.getParameter("hasTab"));
	if(hasTab.equals("")){
		response.sendRedirect("/docs/search/DocSearchTab.jsp?_fromURL=2&"+request.getQueryString());
		return;
	}
    int doccreaterid = Util.getIntValue(request.getParameter("doccreaterid"),0);
    String usertype = Util.null2String(request.getParameter("usertype"));
    if(doccreaterid==0){
        doccreaterid = user.getUID();
        usertype = "1";
    }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/docs/docSearchExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script type="text/javascript">

function onBtnSearchClick(){
}
</script>
</HEAD>
<%
    String imagefilename = "/images/hdDOC_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(16396,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td >
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form name=docshare action="" method="post">
<input type="hidden" name="usertype" value="<%=usertype%>">

<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></wea:item>
		<wea:item>
			<span>
               <brow:browser viewType="0" name="doccreaterid" browserValue='<%= ""+doccreaterid %>' 
                browserOnClick="onShowResource('doccreateridspan','doccreaterid')"
                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
                completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="150px"
                browserSpanValue='<%= (doccreaterid!=0 && !usertype.equals("2"))?Util.toScreen(ResourceComInfo.getResourcename(doccreaterid+""),user.getLanguage()):"" %>'></brow:browser>
        	</span>
		</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="toolbar">
			<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>

</form>
</div>

<%
String tableString=""+
	   "<table datasource=\"weaver.docs.docs.DocDataSource.getDocShareView\" pagesize=\"10\" sourceparams=\"doccreaterid:"+doccreaterid+"+usertype:"+usertype+"\" tabletype=\"none\">"+
	   "<sql backfields=\"*\" sqlform=\"tmpTable\" sqlsortway=\"asc\" sqlorderby=\"id\" sqlprimarykey=\"id\" />"+
	   "<head>";
	   	tableString+=	 "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"name\" />";
	   	tableString += "<col width=\"70%\" text=\""+SystemEnv.getHtmlLabelName(363,user.getLanguage())+"\" column=\"count\" /></head></table>";
%>

 <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="javascript">

function onShowResource(tdname,inputename){
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(id){
        clearData();
	    if (id.id!= ""){
            $("#"+tdname).text(id.name);
            $("input[name="+inputename+"]").val(id.id);
            $("input[name=usertype").val("1");
		}else{
              $("#"+tdname).text("");
            $("input[name="+inputename+"]").val("");
            $("input[name=usertype").val("");
		}
	}
}

function clearData(){
	$("#doccreateridspan").text("");
	$("input[name=doccreaterid]").val("");
	$("input[name=usertype").val("0");
}
function onShowParent(tdname,inputename){
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if(id){
        clearData();
	    if (id.id!= ""){
            $("#"+tdname).text(id.name);
            $("input[name="+inputename+"]").val(id.id);
            $("input[name=usertype").val("1");
		}else{
              $("#"+tdname).text("");
            $("input[name="+inputename+"]").val("");
            $("input[name=usertype").val("");
		}
	}
}

</script>
</body>
</html>
