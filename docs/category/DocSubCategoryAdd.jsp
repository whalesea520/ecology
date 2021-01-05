
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String isEntryDetail = Util.null2String(request.getParameter("isentrydetail"));
	String id = Util.null2String(request.getParameter("id"));
	String from = Util.null2String(request.getParameter("from"));
	String fromSubId = Util.null2String(request.getParameter("curSubId"));
	if(isEntryDetail.equals(""))isEntryDetail = "0";
	String optype = Util.null2String(request.getParameter("optype"));
	if(optype.equals("")){
		optype = "1";
	}
	if(isEntryDetail.equals("1")){
		optype="0";
	}
 %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	<%if(id.equals("")){%>
		//parentWin.location.href="DocMainCategoryList.jsp";
		parentWin.parent.parent.refreshTreeMain(0,"undefined");
		parentWin.onBtnSearchClick();
	<%}else if(from.equals("edit")){%>
		parentWin.parent.parent.refreshTreeMain(<%=id%>,<%=id%>);
		//parentWin.location.href="DocMainCategoryBaseInfoEdit.jsp?optype=<%=optype%>&id=<%=id%>";
		parentWin._table.reLoad();
	<%}else{%>
		//parentWin.location.href="/docs/category/DocSubCategoryBaseInfoEdit.jsp?optype=<%=optype%>&refresh=1&id=<%=id%>";
		parentWin.parent.location.href="/docs/category/DocCategoryTab.jsp?_fromURL=2&optype=0&refresh=1&id=<%=id%>";
	<%}%>
	parentWin.closeDialog();	
}

function onSave(isEnterDetail){
	jQuery('#isentrydetail').val(isEnterDetail);
	checkSubmit();
}

function checkSubmit(){
    if(check_form(weaver,'categoryname')){
        weaver.submit();
    }
}


</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(66,user.getLanguage());
String needfav ="1";
String needhelp ="";
CategoryManager cm = new CategoryManager();
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
int mainid = Util.getIntValue(request.getParameter("id"),0);
/* 上级分目录id */
int subid = Util.getIntValue(request.getParameter("subid"), -1);

int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);

int noRepeatedName=0;//默认不选上
RecordSet.executeSql(" select norepeatedname from DocMainCategory where id = " + mainid);
if(RecordSet.next()){
    if(Util.getIntValue(RecordSet.getString("norepeatedname"),0)==1){
        noRepeatedName = 11;
	}
}



AclManager am = new AclManager();
if (subid < 0) {
    if(!HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user) && !am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR)){
        		response.sendRedirect("/notice/noright.jsp");
        		return;
    }
} else {
    if(!HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user) && !am.hasPermission(subid, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR)){
        		response.sendRedirect("/notice/noright.jsp");
        		return;
    }
}
%>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!"1".equals(isDialog)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave("+isEntryDetail+"),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:onSave(1),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<iframe id="DocFTPConfigInfoGetter" name="DocFTPConfigInfoGetter" style="width:100%;height:200;display:none"></iframe>
 <%if(errorcode == 10){%>
 	<div><font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage()) %></font></div>
 <%}%>
 <table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(<%= isEntryDetail%>);">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(1);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver action="SubCategoryOperation.jsp" method=post >
	<input type="hidden" name="fromSubId" value="<%=fromSubId %>"/>
	<wea:layout>
		<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></wea:item>
			<wea:item><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%><INPUT type=hidden value='<%=mainid%>' name="maincategoryid"></wea:item>
			<%if (subid >= 0) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())+SystemEnv.getHtmlLabelName(66,user.getLanguage())%></wea:item>
				<wea:item><%=SubCategoryComInfo.getSubCategoryname(""+subid)%><INPUT type=hidden value='<%=subid%>' name="subcategoryid"></wea:item>
			<%} %>
			<wea:item><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="categorynamespan" required="true">
					<INPUT class=InputStyle maxLength=100 size=60 name="categoryname" temptitle="<%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%>" onChange="checkinput('categoryname','categorynamespan')">
		          	<INPUT type=hidden size=60 name="srccategoryname" >
	          	</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(19388,user.getLanguage())%></wea:item>
			<wea:item><INPUT maxLength=50 size=30 class=InputStyle name="coder" value=""></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
			<wea:item><INPUT maxLength=5 size=5 class=InputStyle name="suborder" onKeyPress="ItemNum_KeyPress()" onBlur='check_number("suborder")'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(19449,user.getLanguage())%></wea:item>
			<wea:item>
			    <INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(noRepeatedName==1){%>checked<%}%> <%if(noRepeatedName==11){%>checked disabled<%}%> value=1 name="noRepeatedName" >
			</wea:item>
		</wea:group>
	</wea:layout>
          <input type=hidden value="add" name="operation">
          	<input type="hidden" name="isdialog" value="<%=isDialog%>">
          	<input type="hidden" name="optype" value="<%=optype%>">
          	<input type="hidden" name="from" id="from" value="<%=from%>">
		<input type="hidden" id = "isentrydetail" name="isentrydetail" value="<%=isEntryDetail %>">
</FORM>

<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('1');checkSubmit();">
		    	<span class="e8_sep_line">|</span>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('<%= isEntryDetail%>');checkSubmit();">
		    	<span class="e8_sep_line">|</span>--%>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
    		</wea:item>
		</wea:group>
	</wea:layout>
</div>
	
<%} %>

</BODY></HTML>


<script language=javascript >

jQuery(document).ready(function(){
	resizeDialog(document);
	
});

function showFTPConfig(){
    if(document.getElementById("isUseFTP").checked){
        document.getElementById("FTPConfigDiv").style.display = "block";
    }else{
    	document.getElementById("FTPConfigDiv").style.display = "none";
    }
}


function loadDocFTPConfigInfo(obj){
	document.getElementById("DocFTPConfigInfoGetter").src="DocFTPConfigIframe.jsp?operation=loadDocFTPConfigInfo&FTPConfigId="+obj.value;
}


function returnDocFTPConfigInfo(FTPConfigName,FTPConfigDesc,serverIP,serverPort,userName,userPassword,defaultRootDir,maxConnCount,showOrder){
	FTPConfigNameSpan.innerHTML=FTPConfigName;
	FTPConfigDescSpan.innerHTML=FTPConfigDesc;
	serverIPSpan.innerHTML=serverIP;
	serverPortSpan.innerHTML=serverPort;
	userNameSpan.innerHTML=userName;
	userPasswordSpan.innerHTML=userPassword;
	defaultRootDirSpan.innerHTML=defaultRootDir;
	maxConnCountSpan.innerHTML=maxConnCount;
	showOrderSpan.innerHTML=showOrder;
}
</script>
