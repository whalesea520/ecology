<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

    String dataCenterWorkflowTypeId="";
	RecordSet.executeSql("select currentId from sequenceindex where indexDesc='dataCenterWorkflowTypeId'");
	if(RecordSet.next()){
		dataCenterWorkflowTypeId=Util.null2String(RecordSet.getString("currentId"));
	}

    RecordSet.executeSql("SELECT DISTINCT workflowtype FROM workflow_base");
    StringBuffer sb = new StringBuffer();
    String allRef = "";
    while(RecordSet.next()){
        allRef += "," + RecordSet.getString(1);
    }
    allRef += ",";
	String id = request.getParameter("id");

	RecordSet.executeProc("workflow_wftype_SelectByID",id);


	RecordSet.first();

boolean canedit = HrmUserVarify.checkUserRight("WorkflowManage:All",user);
String dialog = Util.null2String(request.getParameter("dialog"));
String isclose = Util.null2String(request.getParameter("isclose"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = null;
    if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
        titlename = SystemEnv.getHtmlLabelName(16579,user.getLanguage());
    }else{
        titlename = SystemEnv.getHtmlLabelName(16579,user.getLanguage());
    }
String needfav ="1";
String needhelp ="";
%>
<body style="overflow-y:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(HrmUserVarify.checkUserRight("WorkflowManage:All", user) && allRef.indexOf(","+id+",")==-1&&(!dataCenterWorkflowTypeId.equals(id))){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitDel(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if("1".equals(dialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btn_cancle(),_top} " ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onReturn(),_top} " ;
}
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<%}%>
<FORM id=weaver action="WorkTypeOperation.jsp" method=post >
  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="id" value="<%=id%>">
  <input type="hidden" name="dialog" value="<%=dialog%>">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()" />
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" id="zd_btn_cancle"  class="e8_btn_top" onclick="btn_cancle()" />				
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>  
		<wea:layout type="twoCol">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			    <wea:item>
			    	<wea:required id="typeimage" required="true" value='<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>'>
			    		<% if(canedit) {%>
			    			<input class=Inputstyle style="width: 50%;" maxLength=50 size=20 name="type" onchange='checkinput("type","typeimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>">
			    		<%}else {%>
			    			<%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%>  
			    		<%}%>
			    	 </wea:required>			    	
			    </wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		    	<wea:item>
		    		<wea:required id="descimage" required="true" value='<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>'>
			    		<% if(canedit) {%>
			    			<input class=Inputstyle style="width: 50%;" maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>">
			    		<%}else {%> 
			    			<%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%> 
			    		<%}%>
			    	</wea:required>	
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		    	<wea:item>
		    		<% if(canedit) {%>
		    			<input class=Inputstyle style="width: 50%;" maxLength=3 size=20 name="dsporder" value="<%=Util.getIntValue(RecordSet.getString("dsporder"),0)%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
		    		<%}else {%> 
		    			<%=Util.getIntValue(RecordSet.getString("dsporder"),0)%> 
		    		<%}%>
		    	</wea:item>
		    </wea:group>
		</wea:layout>	
</FORM>
<iframe id="checkType" src="" style="display: none"></iframe>
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
if("<%=dialog%>"==1){	
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	function btn_cancle(){
		parentWin.closeDialog();
	}
}

if("<%=isclose%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	parentWin.location="/workflow/workflow/ListWorkTypeTab.jsp";
	parentWin.closeDialog();	
}

function submitData()
{
	if (check_form(weaver,'type,desc')){
	    //通过iframe验证类型名称是否重复
	    //document.getElementById("checkType").src="WorkTypeOperation.jsp?type="+document.all("type").value+"&method=valRepeat&id="+<%=id%>;
	    document.getElementById("checkType").src="WorkTypeOperation.jsp?method=valRepeat&type="+myescapecode(document.all("type").value)+"&id="+<%=id%>;
    }
}

function submitDel()
{
	if(isdel()){
		document.all("method").value="delete" ;
		weaver.submit();
		}
}
function onReturn(){
	location="/workflow/workflow/ListWorkType.jsp";
}
//类型名称已经存在
function typeExist(){
    alert("<%=SystemEnv.getHtmlLabelName(24256,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
    return ;
}

//提交表单
function submitForm(){
    weaver.submit();
}

$("#zd_btn_submit").hover(function(){
	$(this).addClass("zd_btn_submit_hover");
},function(){
	$(this).removeClass("zd_btn_submit_hover");
});

$("#zd_btn_cancle").hover(function(){
	$(this).addClass("zd_btn_cancleHover");
},function(){
	$(this).removeClass("zd_btn_cancleHover");
});	
</script>
</BODY>
</HTML>
