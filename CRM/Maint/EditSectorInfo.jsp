
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*"%>
<%
boolean canedit = HrmUserVarify.checkUserRight("EditSectorInfo:Edit",user);
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />

<%
	String id = Util.null2String(request.getParameter("id"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String sectors = Util.null2String(request.getParameter("sectors"));
	String parentid = "";
	String parentspan = "";
	if(!isclose.equals("1"))
	{
		RecordSet.executeProc("CRM_SectorInfo_SelectByID",id);
	
		if(RecordSet.getFlag()!=1)
		{
			response.sendRedirect("/CRM/DBError.jsp?type=FindData");
			return;
		}
		if(RecordSet.getCounts()<=0)
		{
			response.sendRedirect("/CRM/DBError.jsp?type=FindData");
			return;
		}
		RecordSet.first();
		parentid = RecordSet.getString("parentid");
		parentspan = SectorInfoComInfo.getSectorFullParentName(id);
		
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'name')){
        weaver.submit();
    }
}

if("<%=isclose%>"=="1"){
	parent.getParentWindow(window).location = "ListSectorInfoInner.jsp?opend=1&parentid=<%=parentid%>&sectors=<%=sectors%>";
	parent.getDialog(window).close();
}

jQuery(function(){
	checkinput("name","nameimage");
});
</script>
</HEAD>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if (canedit)
	titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":&nbsp;"
		+SystemEnv.getHtmlLabelName(575,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
else
	titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":&nbsp;"
		+SystemEnv.getHtmlLabelName(575,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if (canedit){  
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),''} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(575,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<%if (canedit){  %>
				<input class="e8_btn_top middle" onclick="checkSubmit()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name="weaver" action="/CRM/Maint/SectorInfoOperation.jsp" method=post>
<input type="hidden" name="method" value="edit">
<input type="hidden" name="id" value="<%=id%>">

<wea:layout>
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="nameimage">
				<% if(canedit) {%><INPUT class=InputStyle maxLength=150 style="width: 300px;" size=45 name="name" value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>" onchange='checkinput("name","nameimage")' >
				<%}else {%><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%><%}%>
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item>
			<% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=45 name="desc" value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>"><%}else {%><%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%><%}%>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></wea:item>
		<wea:item>
			<% if(canedit) {%>
          		<span>
	        		<brow:browser viewType="0" name="parentid" 
	                	browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp"
	                	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	                	completeUrl="/data.jsp?type=-99995" width='267px'
	                	browserSpanValue='<%=parentspan %>' browserValue='<%=parentid %>' >
	        		</brow:browser>
				</span>
			<%}else {%>
			<%=Util.toScreen(SectorInfoComInfo.getSectorInfoname(RecordSet.getString(4)),user.getLanguage())%>
			<%}%>
		</wea:item>
	</wea:group>
</wea:layout>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</FORM>



<script language="javascript">
function onShowSectorID(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	var childId = "<%=id%>"
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
	if (data.id!="0"){
		if (childId == data.id) {
			showAlert()
		}else{
			Sectorspan.innerHTML = data.name
			weaver.parentid.value=data.id
		}
	}else {
		Sectorspan.innerHtml = ""
		weaver.parentid.value="0"
	}
	}
}
function showAlert() {
	alert("<%=SystemEnv.getHtmlNoteName(62,user.getLanguage())%>");
}

function doDel(){
	if(isdel()){location.href="/CRM/Maint/SectorInfoOperation.jsp?method=delete&id=<%=id%>"}
}
</script>

</BODY>
</HTML>
