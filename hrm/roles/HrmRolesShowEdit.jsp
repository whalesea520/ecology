
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:hand;text-align:center;padding:0 2px 0 2px;color:#333;text-decoration:underline}
.cycleTD{background-image:url(/images/tab2_wev8.png);cursor:hand;text-align:center;border-bottom:1px solid #879293;}
.cycleTDCurrent{padding-top:2px;background-image:url(/images/tab.active2_wev8.png);cursor:hand;text-align:center;}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
</style>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16527,user.getLanguage());
String needfav ="1";
String needhelp ="";

int id = Util.getIntValue(request.getParameter("id"),0);
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
int reftree = Util.getIntValue(request.getParameter("reftree"),0);
int tab = Util.getIntValue(request.getParameter("tab"),0);
String typeid = Util.null2String(request.getParameter("type"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
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
	<col width="*"></col>
	</colgroup>
	<TBODY>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr align=left height="22">
	<%if(hrmdetachable==1){%>
		<td class="cycleTDCurrent" name="oTDtype_0"  id="oTDtype_0" background="/images/tab.active2_wev8.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(0)" ><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></td>
		<td class="cycleTD" name="oTDtype_1"  id="oTDtype_1" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1)" ><%=SystemEnv.getHtmlLabelName(17864,user.getLanguage())%></td>
		
		<td class="cycleTD" name="oTDtype_2"  id="oTDtype_2" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2)" ><%=SystemEnv.getHtmlLabelName(17865,user.getLanguage())%></td>
		<td class="cycleTD" name="oTDtype_3"  id="oTDtype_3" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='hand'" onclick="resetbanner(3)" ><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></td>
		<td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
		<%}else{%>
		<td class="cycleTDCurrent" name="oTDtype_0"  id="oTDtype_0" background="/images/tab.active2_wev8.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(0)" ><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></td>
		<td class="cycleTD" name="oTDtype_1"  id="oTDtype_1" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1)" ><%=SystemEnv.getHtmlLabelName(17864,user.getLanguage())%></td>
		<td class="cycleTD" name="oTDtype_2"  id="oTDtype_2" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2)" ><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></td>
		<td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
		<%}%>
	</tr>
	<tr>
		<td colspan="6" style="padding:0;">
		<iframe src="HrmRolesEdit.jsp?id=<%=id%><%=(errorcode>0?"&errorcode="+errorcode:"")%><%=(messageid>0?"&message="+messageid:"")%>" ID="iframeAlert" name="iframeAlert" frameborder="0" style="width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0" scrolling="auto"></iframe>
		</td>
	</tr>
	</TBODY>
</table>
<SCRIPT language="javascript">
if(<%=hrmdetachable%>==1){
if(<%=typeid%>==0){
	for(i=0;i<4;i++){
		$GetEle("oTDtype_"+i).background="/images/tab2_wev8.png";
		$GetEle("oTDtype_"+i).className="cycleTD";
	}
	$GetEle("oTDtype_0").background="/images/tab.active2_wev8.png";
	$GetEle("oTDtype_0").className="cycleTDCurrent";
	iframeAlert.document.location="HrmRolesEdit.jsp?id=<%=id%>";
		}
	else if(<%=typeid%>==1){
	for(i=0;i<4;i++){
		$GetEle("oTDtype_"+i).background="/images/tab2_wev8.png";
		$GetEle("oTDtype_"+i).className="cycleTD";
	}
	$GetEle("oTDtype_1").background="/images/tab.active2_wev8.png";
	$GetEle("oTDtype_1").className="cycleTDCurrent";
	$GetEle("iframeAlert").contentWindow.document.location="HrmRolesFucRightSet.jsp?id=<%=id%>";
		}
	else if(<%=typeid%>==2){
	for(i=0;i<4;i++){
		$GetEle("oTDtype_"+i).background="/images/tab2_wev8.png";
		$GetEle("oTDtype_"+i).className="cycleTD";
	}
	$GetEle("oTDtype_2").background="/images/tab.active2_wev8.png";
	$GetEle("oTDtype_2").className="cycleTDCurrent";
	$GetEle("iframeAlert").contentWindow.document.location="HrmRolesStrRightSet.jsp?id=<%=id%>";
		}
	else if(<%=typeid%>==3){
	for(i=0;i<4;i++){
		$GetEle("oTDtype_"+i).background="/images/tab2_wev8.png";
		$GetEle("oTDtype_"+i).className="cycleTD";
	}
	$GetEle("oTDtype_3").background="/images/tab.active2_wev8.png";
	$GetEle("oTDtype_3").className="cycleTDCurrent";
	$GetEle("iframeAlert").contentWindow.document.location="HrmRolesMembers.jsp?id=<%=id%>";
		}
}else{
	if(<%=typeid%>==0){
	for(i=0;i<3;i++){
		$GetEle("oTDtype_"+i).background="/images/tab2_wev8.png";
		$GetEle("oTDtype_"+i).className="cycleTD";
	}
	$GetEle("oTDtype_0").background="/images/tab.active2_wev8.png";
	$GetEle("oTDtype_0").className="cycleTDCurrent";
	$GetEle("iframeAlert").contentWindow.document.location="HrmRolesEdit.jsp?id=<%=id%>";
		}
	else if(<%=typeid%>==1){
	for(i=0;i<3;i++){
		$GetEle("oTDtype_"+i).background="/images/tab2_wev8.png";
		$GetEle("oTDtype_"+i).className="cycleTD";
	}
	$GetEle("oTDtype_1").background="/images/tab.active2_wev8.png";
	$GetEle("oTDtype_1").className="cycleTDCurrent";
	$GetEle("iframeAlert").contentWindow.document.location="HrmRolesFucRightSet.jsp?id=<%=id%>";
		}
	else if(<%=typeid%>==3){
	for(i=0;i<3;i++){
		$GetEle("oTDtype_"+i).background="/images/tab2_wev8.png";
		$GetEle("oTDtype_"+i).className="cycleTD";
	}
	$GetEle("oTDtype_2").background="/images/tab.active2_wev8.png";
	$GetEle("oTDtype_2").className="cycleTDCurrent";
	$GetEle("iframeAlert").contentWindow.document.location="HrmRolesMembers.jsp?id=<%=id%>";
		}

}
function resetbanner(objid){
	if(<%=hrmdetachable%>==1){
	for(i=0;i<4;i++){
		$GetEle("oTDtype_"+i).background="/images/tab2_wev8.png";
		$GetEle("oTDtype_"+i).className="cycleTD";
	}
	$GetEle("oTDtype_"+objid).background="/images/tab.active2_wev8.png";
	$GetEle("oTDtype_"+objid).className="cycleTDCurrent";
	var o = $GetEle("iframeAlert").contentWindow.document;
	if(objid==0){
		o.location="HrmRolesEdit.jsp?id=<%=id%><%=(errorcode>0?"&errorcode="+errorcode:"")%><%=(messageid>0?"&message="+messageid:"")%>";
	}
	else if(objid==1){
		o.location="HrmRolesFucRightSet.jsp?id=<%=id%>";
	}else if(objid==2){
		o.location="HrmRolesStrRightSet.jsp?id=<%=id%>";
	}else if(objid==3){
		o.location="HrmRolesMembers.jsp?id=<%=id%>";
	}
	}else{
	for(i=0;i<3;i++){
		$GetEle("oTDtype_"+i).background="/images/tab2_wev8.png";
		$GetEle("oTDtype_"+i).className="cycleTD";
	}
	$GetEle("oTDtype_"+objid).background="/images/tab.active2_wev8.png";
	$GetEle("oTDtype_"+objid).className="cycleTDCurrent";
	var o = $GetEle("iframeAlert").contentWindow.document;
	if(objid==0){
		o.location="HrmRolesEdit.jsp?id=<%=id%><%=(errorcode>0?"&errorcode="+errorcode:"")%><%=(messageid>0?"&message="+messageid:"")%>";
	}
	else if(objid==1){
		o.location="HrmRolesFucRightSet.jsp?id=<%=id%>";
	}else if(objid==2){
		o.location="HrmRolesMembers.jsp?id=<%=id%>";
	}
	}
}
if("<%=reftree%>"==1) window.parent.iframeAlert("leftframe").window.document.location.reload();
if("<%=tab%>"!="0") resetbanner(<%=tab%>);

//添加或者删除角色成员时刷新父页面列表
function refreshWindow(){
   try{
      opener.location.href=opener.location.href;
   }catch(e){}
}

</script>
</BODY>
</HTML>