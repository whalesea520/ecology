
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%	
	if(!HrmUserVarify.checkUserRight("newstype:maint", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	
	String type = Util.forHtml(Util.null2String(request.getParameter("type")));
	boolean editable="edit".equals(type)?true:false;
	String id = Util.null2String(request.getParameter("id"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String Delname = "";
	String typename="";
	String typedesc="";
	String navName = SystemEnv.getHtmlLabelName(19789,user.getLanguage());;
	if(editable) {
		if(rs.executeSql("select * from newstype where id="+id)){
			rs.next();
			Delname = rs.getString("typename");
			typename=Util.null2String(rs.getString("typename"));
			typedesc=Util.null2String(rs.getString("typedesc"));
		}
	}
	if(!typename.equals("")){
		navName = typename;
	}
	
	String msg = Util.null2String(request.getParameter("msg"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19859,user.getLanguage());
String needfav ="1";
String needhelp ="";
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%if(!isDialog.equals("1")){ %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doAdd(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	if(editable){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/news/type/newstypeList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doAdd(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
} %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="doAdd()" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<form name="frmAdd" method="post" action="newstypeOperation.jsp">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<%if(editable) {%>
	<input type="hidden" name="txtMethod" value="edit">
	<input type="hidden" name="id" value="<%=id%>">
<%} else {%>
	<input type="hidden" name="txtMethod" value="add">
<%}%>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="spanName" required='<%=!(editable && ! Util.null2String(rs.getString("typename")).equals(""))%>'>
				<input temptitle="<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>" type="text" class="inputstyle" name="txtName" <%if(editable) %> value="<%=Util.forHtml(typename)%>") onChange="checkinput('txtName','spanName')" >
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item><input type="text" class="inputstyle"  <%if(editable) %> value='<%=Util.forHtml(typedesc) %>'  name="txtDesc"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		<wea:item>
			<input style="width:30px;" type="text" class="inputstyle" <%if(editable) out.println("value='"+Util.null2String(rs.getString("dspnum"))+"'");%>  name="txtDspNum" value="0" size="4" onKeyPress="ItemCount_KeyPress()">
		</wea:item>
	</wea:group>
</wea:layout>

 </form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
<!--

var dialog = parent.parent.getDialog(parent); 
var parentWin = parent.parent.getParentWindow(parent);

try{
	parent.setTabObjName("<%= navName %>");
}catch(e){}

function btn_cancle(){
	parentWin.closeDialog();
}
if("<%=isclose%>"=="1"){
	//parentWin.location="/docs/news/type/newstypeList.jsp";
	parentWin._table.reLoad();
	parentWin.closeDialog();	
}

function doAdd(){
	if(check_form(frmAdd,'txtName'))	frmAdd.submit();
}
function doDel(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")) {
		window.location="newstypeOperation.jsp?isdialog=<%=isDialog%>&txtMethod=del&id=<%=id%>&DocTypeName=<%=Util.forHtml(Delname)%>"
	}
}
//-->
</SCRIPT>
