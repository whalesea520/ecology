<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.getParentWindow(window);
}


if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

int id = Util.getIntValue(request.getParameter("id"),0);
 rs.executeProc("CptCapitalType_SelectById",""+id);

	String name = "";
	String description = "";
	String typecode = "";
 if(rs.next()){
	name = Util.toScreenToEdit(rs.getString("name"),user.getLanguage());
	description = Util.toScreenToEdit(rs.getString("description"),user.getLanguage());
	typecode = Util.null2String(rs.getString("typecode"));
	}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage()) 
				+ ":&nbsp;" + SystemEnv.getHtmlLabelName(703,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="assest"/>
   <jsp:param name="navName" value='<%=CapitalTypeComInfo.getCapitalTypename(""+id) %>'/>
</jsp:include>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("CptCapitalTypeEdit:Edit", user)){
canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("CptCapitalTypeAdd:Add", user)){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",CptCapitalTypeAdd.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("CptCapitalTypeEdit:Delete", user)){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//if(HrmUserVarify.checkUserRight("CptCapitalType:Log", user)){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=75 and relatedid="+id+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
<%
if(HrmUserVarify.checkUserRight("CptCapitalTypeEdit:Edit", user)){
	%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
	<%
}
%>		
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=frmMain name=frmMain action="CapitalTypeOperation.jsp" method=post>
<%
if (msgid!=-1) {
%>
<DIV>
<FONT color="red" size="2">
<%=SystemEnv.getErrorMsgName(msgid, user.getLanguage())%>
</FONT>
</DIV>
<%}%>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="" >
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(canEdit){%><INPUT type=text size=30 name="name"  value="<%=name%>" onchange='checkinput("name","nameimage")' class="InputStyle">
				  <SPAN id=nameimage></SPAN><%}else{%><%=name%><%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(canEdit){%><INPUT type=text size=60 name="description"   value="<%=description%>" onchange='' class="InputStyle">
				  <%}else{%><%=description%><%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21942,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(canEdit){%><INPUT type=text size=60 maxlength=100 name="typecode"   value="<%=typecode%>" class="InputStyle">
				  <%}else{%><%=description%><%}%>
		</wea:item>
	</wea:group>
</wea:layout>
	
	
			<!-- 对话框底下的按钮 -->
<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
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
	

 
 <input type=hidden name=operation>
 <input type=hidden name=id value="<%=id%>">
 </form>

 <script language=javascript>
 function onSave(){
	if(check_form(document.getElementsByName("frmMain")[0],'name')){
		document.getElementsByName("operation")[0].value="edit";
		//document.getElementsByName("frmMain")[0].submit();
		var form=jQuery("#frmMain");
		var form_data=form.serialize();
		var form_url=form.attr("action");
		jQuery.ajax({
			url : form_url,
			type : "post",
			async : true,
			data : form_data,
			dataType : "json",
			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
			success: function do4Success(msg){
				if(msg&&msg.msgid){
					if(msg.msgid==11){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83676",user.getLanguage())%>");
					}else if(msg.msgid==12){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83677",user.getLanguage())%>");
					}else{
						parentWin.closeDialog();
						parentWin._table.reLoad();
					}
				}else{
					parentWin.closeDialog();
					parentWin._table.reLoad();
				}
			}
		});
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.getElementsByName("operation")[0].value="delete";
			document.getElementsByName("frmMain")[0].submit();
		}
}
function goBack(){
	location.href = "/cpt/maintenance/CptCapitalType.jsp";
}
 </script>
 <%if("1".equals(isDialog)){ %>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
});


function onBtnSearchClick(){
	jQuery("input[name=submit]").trigger('click');
}
$(".searchImg").bind("click",function(){
    onBtnSearchClick();
});
</script>
<%} %>
</BODY></HTML>
