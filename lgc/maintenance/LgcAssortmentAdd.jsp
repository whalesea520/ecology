
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>
<% if(!HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
	String isclose = Util.null2String(request.getParameter("isclose"));
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraid = Util.null2String(request.getParameter("paraid")) ;
String iself = Util.null2String(request.getParameter("iself")) ;
String supassortmentid = "" ;
String supassortmentstr ="" ;
if(paraid.equals("")) {
	supassortmentid="0";
	supassortmentstr = "0|" ;
}
else {
supassortmentid=paraid;
RecordSet.executeProc("LgcAssetAssortment_SSupAssort",supassortmentid);
RecordSet.next();
supassortmentstr = Util.null2String(RecordSet.getString(1))+supassortmentid+"|" ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(178,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";

String aid = Util.null2String(request.getParameter("aid"));
String apid = Util.null2String(request.getParameter("apid"));
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'assortmentname')){
        weaver.submit();
    }
}
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	if("<%=paraid%> " != "")
		parentWin.location = "/lgc/maintenance/LgcAssortment.jsp?assortmentid=<%=paraid%>";
	else
		parentWin.location = "/lgc/maintenance/LgcAssortment.jsp";
		
		
	
	parentWin.refreshTreeMain("<%=aid%>","<%=apid%>",true);
	parentWin.closeDialog();
}
</script>
</head>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32655,user.getLanguage())%>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="checkSubmit()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name=weaver action=LgcAssortmentOperation.jsp method=post enctype="multipart/form-data">
<input type="hidden" name="supassortmentid" value="<%=supassortmentid%>">
<input type="hidden" name="supassortmentstr" value="<%=supassortmentstr%>">
<input type="hidden" name="iself" value="<%=iself%>">
<input type="hidden" name="operation" value="addassortment">
<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage()) %></wea:item>
		<wea:item>
			<wea:required id="assortmentnameimage" required="true">
				<input class=InputStyle  accesskey=Z name=assortmentname size="45" 
					onChange='checkinput("assortmentname","assortmentnameimage")'>
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())+SystemEnv.getHtmlLabelName(178,user.getLanguage()) %></wea:item>
		<wea:item>
			<span>
	          	<brow:browser viewType="0" name="supassortmentid" 
	               	browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp?newtype=assort"
	               	browserValue='<%=supassortmentid %>'
	               	browserSpanValue='<%=Util.toScreen(LgcAssortmentComInfo.getAssortmentFullName(supassortmentid),user.getLanguage()) %>'
	               	isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1' 
	               	completeUrl="/data.jsp?type=-99995" width='267px'>
	       		</brow:browser>
       		</span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage()) %></wea:item>
		<wea:item> 
 			<TEXTAREA class=InputStyle style="WIDTH: 284px" name=Remark rows=4></TEXTAREA>
		</wea:item>
			
        <wea:item><%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %></wea:item>
        <wea:item> 
          	<input class=InputStyle  type="file" name=assortmentimage style='width:284px'>
        </wea:item>
	</wea:group>
</wea:layout>
</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</BODY>
</HTML>
