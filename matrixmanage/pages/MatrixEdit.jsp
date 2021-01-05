
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

String name = "";
String descr = "";

String id = Util.null2String(request.getParameter("id"));
if (!id.equals("")) {
	RecordSet.executeSql("select * from Matrixinfo where id ="+id);
	if (RecordSet.next()) {
		name = Util.null2String(RecordSet.getString("name"));
		descr = Util.null2String(RecordSet.getString("descr"));
	}
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/jquery/jquery_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33926, user.getLanguage());
String needfav = "1";
String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:doSubmit(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="resource"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33926,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSubmit()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name=frmMain action="MatrixOperation.jsp" method=post>
<input type=hidden name=method value="edit">
<input type=hidden name=matrixid value="<%=id%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' >
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><nobr> 
			<wea:required id="nameimage" required="true">
				<INPUT class=inputstyle type=text maxLength=20 value="<%=name %>" size=25 name=name id=name onchange='checkinput("name","nameimage")'>
			</wea:required>
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item><nobr> 
	        <textarea name="descr" class=inputstyle rows="5" cols="12" maxLength="50"><%=descr %></textarea>	
		</wea:item>
		
	</wea:group>
</wea:layout>

</FORM>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script language=javascript>
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);	
function doSubmit() {
	var name = $("#name").val();
  if(check_form(frmMain,"name")){
	$.ajax({
		 data:{"nameStr":name,"method":"edit","matrixid":"<%=id%>"},
		 type: "post",
		 cache:false,
		 url:"checkdatas.jsp",
		 dataType: 'json',
		 success:function(data){
			 if(data.success == "0"){
				   $("#dosubmit").attr('disabled',"true");
				   frmMain.submit();
			 }else{
			 	 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84607,user.getLanguage())%>!");
			 }
		}	
   });
 }
}


checkinput("name","nameimage");
</script>




</BODY></HTML>

