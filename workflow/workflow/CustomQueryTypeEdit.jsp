<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
 if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String dialog = Util.null2String(request.getParameter("dialog"));
String isclose = Util.null2String(request.getParameter("isclose"));

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23799,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String id = Util.null2String(request.getParameter("id"));
RecordSet.executeSql("SELECT * FROM workflow_customQuerytype where id="+id);
RecordSet.next();
String typename = Util.toScreen(RecordSet.getString("typename"),user.getLanguage()) ;
String typenamemark = Util.toScreenToEdit(RecordSet.getString("typenamemark"),user.getLanguage()) ;
String showorder = Util.null2String(RecordSet.getString("showorder"));
//判断是否有该类型的自定义查询，如果有则不允许删除
RecordSet.executeSql("SELECT count(*) FROM Workflow_Custom where Querytypeid="+id);
int typecount=0;
if(RecordSet.next()){
    typecount= RecordSet.getInt(1);
}
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!"1".equals(dialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:donewQueryType(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	if(typecount==0){
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
	  RCMenuHeight += RCMenuHeightStep;
	}
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<%}%>
<FORM id=weaver name=frmMain action="CustomQueryTypeOperation.jsp" method=post >

<%
if(msgid!=-1){
%>
  <DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage()) %>" id="zd_btn_cancle"  class="e8_btn_top" onclick="btn_cancle()">				
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<wea:required id="typenameimage" required="true" value='<%=typename%>'>
	    		<input type=text style="width:60%;" size=30 class=Inputstyle name="typename" onchange='checkinput("typename","typenameimage")' value="<%=typename%>">
	    	</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item><textarea rows="4" cols="60" name="typenamemark" class=Inputstyle style="resize:none;margin-top: 2px;margin-bottom: 2px;"><%=typenamemark%></textarea></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		<wea:item><input type="text" style="width:60%;"  class=Inputstyle name="showorder" size="7" value='<%=showorder%>' onKeyPress="ItemNum_KeyPress('showorder')" onBlur="checknumber1(this);"></wea:item>
    </wea:group>
</wea:layout>

<input type="hidden" name=operation value=querytypeedit>
<input type="hidden" name=id value=<%=id%>>
<input type="hidden" name="dialog" value="<%=dialog%>">
 </form>
<%if("1".equals(dialog)){ %>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%} %>
<script language="javascript">
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);
function btn_cancle(){
	parentWin.closeDialog();
}

if("<%=isclose%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	parentWin.location="/workflow/workflow/CustomQueryTypeTab.jsp";
	parentWin.closeDialog();	
}
function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
            enableAllmenu();
			document.frmMain.operation.value="querytypedelete";
			document.frmMain.submit();
		}
}

function submitData()
{
	if (check_form(weaver,'typename')){
        enableAllmenu();
		weaver.submit();
    }
}
function donewQueryType(){
        enableAllmenu();
        location.href="/workflow/workflow/CustomQueryTypeAdd.jsp";
    }
function doback(){
    enableAllmenu();
    location.href="/workflow/workflow/CustomQueryType.jsp";
}
</script>
</BODY></HTML>
