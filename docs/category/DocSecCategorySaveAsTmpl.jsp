
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script src="/js/prototype_wev8.js" type="text/javascript"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(86,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(64,user.getLanguage());
String needfav ="1";
String needhelp ="";

int id = Util.getIntValue(request.getParameter("id"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),0);
String name = Util.null2String(request.getParameter("name"));
String fromSubId = Util.null2String(request.getParameter("curSubId"));
String from = Util.null2String(request.getParameter("from"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int subcompanyid = 0;
int operatelevel=0;
int detachable = Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
    if(isUseDocManageDetach){
      detachable=1;
    }
if(detachable==1){
	subcompanyid = Util.getIntValue(String.valueOf(session.getAttribute("maincategory_subcompanyid")),Util.getIntValue(String.valueOf(session.getAttribute("docdftsubcomid"))));
	operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryEdit:Edit",subcompanyid);
}else{
    if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user))
        operatelevel=2;
}
%>

<script language=javascript >
try{
	parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(18418,user.getLanguage())%>");
}catch(e){}
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

if("<%=isclose%>"=="1"){
	<%if(from.equals("")){%>
		parentWin.location.href="/docs/category/DocSecCategoryTmplList.jsp";
	<%}else if(from.equals("subedit")){%>
		//parentWin.location.href="DocSubCategoryBaseInfoEdit.jsp?id=<%=id%>";
	<%}else{%>
		//parentWin.location.href="/docs/category/DocSecCategoryBaseInfoEdit.jsp?id=<%=id%>";
	<%}%>
	parentWin.closeDialog();	
}
jQuery(document).ready(function(){
	resizeDialog(document);
});

</script>

<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!"1".equals(isDialog)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onBack(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="onSave(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

		
			<%
			if(msgid>0){
			%>
			<font color=red><%=SystemEnv.getHtmlLabelName(msgid,user.getLanguage()) %></font>
			<%} %>
		
			<FORM id=weaver name=weaver action="DocSecCategorySaveAsTmplOperation.jsp" method=post>
			<input type=hidden name="method" value="saveastmpl">
			<input type=hidden name="secCategoryId" value="<%=id%>">
			<input type="hidden" name="isdialog" value="<%=isDialog%>">
			<input type="hidden" name="from" id="from" value="<%=from%>">
			<input type="hidden" name="fromSubId" id="fromSubId" value="<%=fromSubId%>">

			<wea:layout>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(19853,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="true" value='<%=name%>'>
							<INPUT class=InputStyle maxLength=30 size=30 name=name onChange="checkinput('name','namespan')" value="<%=name%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(19996,user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT type=hidden name="fromdir" value="<%=id%>">
						<%=SecCategoryComInfo.getSecCategoryname(id+"")%>
					</wea:item>
					<%if(detachable==1){ %>
						<wea:item><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="subcompanyid" browserValue='<%= ""+subcompanyid %>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
										hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput='<%=operatelevel>0?"2":"0" %>'
										completeUrl="/data.jsp?type=164" width="80%" temptitle='<%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>'
										browserSpanValue='<%=subcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid+""),user.getLanguage()):""%>'>
								</brow:browser>
							</span>
						</wea:item>
					<%}%>
				</wea:group>
			</wea:layout>
		</FORM>

<script type="text/javascript">
function onSave(obj){
	//obj.disabled = true;
	if(check_form(document.weaver,'name')){
		<%if(detachable==1){ %>
    		if(check_form(document.weaver,'subcompanyid')){
    	<%}%>
		document.weaver.submit();
		<%if(detachable==1){ %>
        }
        <%}%>
	}
}
function onBack(obj){
	history.back();
}
</script>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
	
<%} %>
</BODY>
</HTML>
