
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("DocMainCategoryAdd:add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String isEntryDetail = Util.null2String(request.getParameter("isentrydetail"));
String id = Util.null2String(request.getParameter("id"));
if(isEntryDetail.equals(""))isEntryDetail = "0";
int subcompanyid = 0;
int operatelevel=0;
int detachable = Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
if(detachable==1){
	subcompanyid = Util.getIntValue(String.valueOf(session.getAttribute("maincategory_subcompanyid")),Util.getIntValue(String.valueOf(session.getAttribute("docdftsubcomid"))));
	operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocMainCategoryAdd:Add",subcompanyid);
}else{
    if(HrmUserVarify.checkUserRight("DocMainCategoryAdd:Add", user))
        operatelevel=2;
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
			//parentWin.onBtnSearchClick();
			try{
				parentWin._table.reLoad();
			}catch(e){}
		<%}else{%>
			//parentWin.location.href="/docs/category/DocMainCategoryBaseInfoEdit.jsp?refresh=1&id=<%=id%>";
			parentWin.parent.location.href="/docs/category/DocCategoryTab.jsp?_fromURL=1&refresh=1&id=<%=id%>";
		<%}%>
		dialog.close();	
	}
function checkSubmit(){
    if(check_form(weaver,'categoryname')){
    	<%if(detachable==1){ %>
    		if(check_form(weaver,'subcompanyid')){
    	<%}%>
        	weaver.submit();
        <%if(detachable==1){ %>
        }
        <%}%>
    }
}


function onSave(isEnterDetail){
	jQuery('#isentrydetail').val(isEnterDetail);
	checkSubmit();
}

</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(65,user.getLanguage());
String needfav ="1";
String needhelp ="";

int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!"1".equals(isDialog)){
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

<FORM id=weaver action="UploadFile.jsp" method=post enctype="multipart/form-data" onSubmit="return check_form(this,'categoryname')">
<div>
	<%if(errorcode == 10){%>
    	<font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage())%></font>
    <%}%>  
</div>
	<wea:layout>
		<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(33439,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<wea:required id="categorynamespan" required="true" value="">
					<INPUT class=InputStyle maxLength=100 size=60 name="categoryname" temptitle="<%=SystemEnv.getHtmlLabelName(33439,user.getLanguage())%>" 
	          onChange="checkinput('categoryname','categorynamespan')">
           		</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(19387,user.getLanguage())%></wea:item>
			<wea:item><INPUT maxLength=50 size=30 class=InputStyle name="coder" value=""></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
			<wea:item><INPUT class=InputStyle onKeyPress="ItemNum_KeyPress()" onBlur='check_number("categoryorder")' maxLength=5 size=13 name="categoryorder"></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(19449,user.getLanguage())%></wea:item>
			<wea:item><INPUT type="checkbox" tzCheckbox="true"  class=InputStyle name="norepeatedname" value="1"></wea:item>
			<%if(detachable==1){ %>
			<wea:item><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
			<wea:item>
				<span>
			        <brow:browser viewType="0" name="subcompanyid" browserValue='<%= ""+subcompanyid %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
			                hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput='<%=operatelevel>0?"2":"0" %>'
			                completeUrl="/data.jsp?type=164"  temptitle='<%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>'
			                browserSpanValue='<%=subcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid+""),user.getLanguage()):""%>'>
			        </brow:browser>
			    </span>
			</wea:item>
			<%} %>
		</wea:group>
	</wea:layout>

			<input type="hidden" name="isdialog" value="<%=isDialog%>">
		<input type="hidden" id = "isentrydetail" name="isentrydetail" value="">
          <input type=hidden value="add" name="operation">
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
			    	<span class="e8_sep_line">|</span> --%>
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</BODY></HTML>


<script language=javascript >
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
