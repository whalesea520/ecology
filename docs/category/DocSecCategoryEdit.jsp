
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:pointer;text-align:center;padding:0 2px 0 2px;color:#333;text-decoration:underline}
.cycleTD{background-image:url(/images/tab2_wev8.png);cursor:pointer;text-align:center;border-bottom:1px solid #879293;}
.cycleTDCurrent{padding-top:2px;background-image:url(/images/tab.active2_wev8.png);cursor:pointer;text-align:center;}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
</style>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(67,user.getLanguage());
String needfav ="1";
String needhelp ="";

int id = Util.getIntValue(request.getParameter("id"),0);
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
int reftree = Util.getIntValue(request.getParameter("reftree"),0);
int tab = Util.getIntValue(request.getParameter("tab"),0);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0" id="tabPane">
<input type="hidden" name="id" value="<%=id%>">
	<colgroup>
	<col width="79"></col>
	<col width="79"></col>
	<col width="79"></col>
	<col width="79"></col>
	<col width="79"></col>
	<col width="79"></col>
	<col width="79"></col>
	<col width="79"></col>
	<col width="*"></col>
	</colgroup>
	<TBODY>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr align=left height="22">
		<td class="cycleTDCurrent" name="oTDtype_0"  id="oTDtype_0" background="/images/tab.active2_wev8.png" width=79px  align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(0)" title="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;float:left;width:79px;"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></span></td>
		<td class="cycleTD" name="oTDtype_1" id="oTDtype_1" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(1)" title="<%=SystemEnv.getHtmlLabelName(19174,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;float:left;width:79px;"><%=SystemEnv.getHtmlLabelName(19174,user.getLanguage())%></span></td>
		<td class="cycleTD" name="oTDtype_2" id="oTDtype_2" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(2)" title="<%=SystemEnv.getHtmlLabelName(19450,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;float:left;width:79px;"><%=SystemEnv.getHtmlLabelName(19450,user.getLanguage())%></span></td>
		<td class="cycleTD" name="oTDtype_3" id="oTDtype_3" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(3)" title="<%=SystemEnv.getHtmlLabelName(19381,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;float:left;width:79px;"><%=SystemEnv.getHtmlLabelName(19381,user.getLanguage())%></span></td>
		<td class="cycleTD" name="oTDtype_4" id="oTDtype_4" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(4)" title="<%=SystemEnv.getHtmlLabelName(16448,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;float:left;width:79px;"><%=SystemEnv.getHtmlLabelName(16448,user.getLanguage())%></span></td>
		<td class="cycleTD" name="oTDtype_5" id="oTDtype_5" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(5)" title="<%=SystemEnv.getHtmlLabelName(19451,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;float:left;width:79px;"><%=SystemEnv.getHtmlLabelName(19451,user.getLanguage())%></span></td>
		<td class="cycleTD" name="oTDtype_6" id="oTDtype_6" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(6)" title="<%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;float:left;width:79px;"><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></span></td>
		<td class="cycleTD" name="oTDtype_7" id="oTDtype_7" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(7)" title="<%=SystemEnv.getHtmlLabelName(20237,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;float:left;width:79px;"><%=SystemEnv.getHtmlLabelName(20237,user.getLanguage())%></span></td>
		<td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="9" style="padding:0;">
		<iframe src="DocSecCategoryBaseInfoEdit.jsp?id=<%=id%><%=(errorcode>0?"&errorcode="+errorcode:"")%><%=(messageid>0?"&message="+messageid:"")%>" ID="iframeAlert" name="iframeAlert" frameborder="0" style="width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0" scrolling="auto"></iframe>
		</td>
	</tr>
	</TBODY>
</table>
<SCRIPT language="javascript">
function resetbanner(objid){
	//alert(1)
	for(i=0;i<8;i++){
		document.all("oTDtype_"+i).background="/images/tab2_wev8.png";
		document.all("oTDtype_"+i).className="cycleTD";
	}
	//jQuery("#oTDtype_"+objid).css("background","/images/tab.active2_wev8.png");
	//jQuery("#oTDtype_"+objid).addClass("cycleTDCurrent");
	document.all("oTDtype_"+objid).background="/images/tab.active2_wev8.png";
	document.all("oTDtype_"+objid).className="cycleTDCurrent";
	//var o = document.frames[1].document;
	
	var o = document.getElementById("iframeAlert");
	if(objid==0){
		o.src="DocSecCategoryBaseInfoEdit.jsp?id=<%=id%><%=(errorcode>0?"&errorcode="+errorcode:"")%><%=(messageid>0?"&message="+messageid:"")%>";
	}else if(objid==1){
		o.src="DocSecCategoryRightEdit.jsp?id=<%=id%>";
	}else if(objid==2){
		o.src="DocSecCategoryEditionEdit.jsp?id=<%=id%>";
	}else if(objid==3){
		o.src="DocSecCategoryCodeRuleEdit.jsp?id=<%=id%>";
	}else if(objid==4){
		o.src="DocSecCategoryTempletEdit.jsp?id=<%=id%>";
	}else if(objid==5){
		o.src="DocSecCategoryDocPropertiesEdit.jsp?id=<%=id%>";
	}else if(objid==6){
		o.src="DocSecCategoryApproveWfEdit.jsp?id=<%=id%>";
	}else if(objid==7){
		o.src="DocSecCategoryCustomSearchEdit.jsp?id=<%=id%>";
	}
}
if("<%=reftree%>"=="1") window.parent.frames["leftframe"].document.location.reload();
if("<%=tab%>"!="0") resetbanner(<%=tab%>);
</script>
</BODY>
</HTML>