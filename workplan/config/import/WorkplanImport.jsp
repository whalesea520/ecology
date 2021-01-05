
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkPlanSetInfo"	class="weaver.WorkPlan.WorkPlanSetInfo" scope="page" />
<script language="javascript" src="/js/checkinput_wev8.js"></script>
<html>
<head>
<script language="javascript" src="/js/weaver_wev8.js"></script>

</head>
<%
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(2211,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	String remindType=""+WorkPlanSetInfo.getDefaultRemider();
%>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

	RCMenu += "{"+SystemEnv.getHtmlLabelName(18596, user.getLanguage())+",javaScript:dosubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="schedule"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<input type=button class="e8_btn_top" onClick="dosubmit(this)" value="<%=SystemEnv.getHtmlLabelName(18596, user.getLanguage())%>"/>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<FORM id=frmMain name=frmMain action="WorkplanImportProcess.jsp" method=post enctype="multipart/form-data">
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(16094, user.getLanguage())%></wea:item>
      		<wea:item>
		        <select name="keyField" id="keyField" style="width: 80px;">
		            <%
		             RecordSet.executeSql("select * from workplantype where workplantypeid =0 or workplantypeid >6 and available=1 order by displayOrder");
		                while (RecordSet.next()){
		                      %>
		            <option value="<%=RecordSet.getString("workplantypeid")%>"><%=RecordSet.getString("workplantypename")%></option>
		                        <%
		                }
		            %>
		
		        </select>
		        <input type='hidden' id="importType" name="importType" value="add">
		    </wea:item>
		    <%if(WorkPlanSetInfo.getShowRemider()==1){ %>
		<!--================ 日程提醒方式  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(19781,user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT type="radio" value="1" name="remindType" onclick=showRemindTime(this) <%if (!"2".equals(remindType)&& !"3".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
				<INPUT type="radio" value="2" name="remindType" onclick=showRemindTime(this) <%if ("2".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
				<INPUT type="radio" value="3" name="remindType" onclick=showRemindTime(this) <%if ("3".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			</wea:item>
			<%}else{%>
			<!-- 不开启提醒,默认不提醒 -->
				<wea:item attributes="{'display':'none','samePair':'ShowRemider'}"><%=SystemEnv.getHtmlLabelName(19781,user.getLanguage())%></wea:item>
				<wea:item attributes="{'display':'none','samePair':'ShowRemider'}">
					<INPUT type="radio" value="1" name="remindType" onclick=showRemindTime(this) checked><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
					<INPUT type="radio" value="2" name="remindType" onclick=showRemindTime(this)><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
					<INPUT type="radio" value="3" name="remindType" onclick=showRemindTime(this)><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
				</wea:item>	
				
			<%} %>
			
		    <wea:item  attributes="{'samePair':'remindTime','display':'none'}"><%=SystemEnv.getHtmlLabelName(19783,user.getLanguage())%></wea:item>
		    <wea:item attributes="{'samePair':'remindTime','display':'none'}">
		          <INPUT type="checkbox" id="remindBeforeStart" name="remindBeforeStart" value="1" >
	            <%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
	            <INPUT class="InputStyle" type="input" id="remindDateBeforeStart" name="remindDateBeforeStart"  onchange="checkint('remindDateBeforeStart')" size=5 value="" style="width:40px;">
	            <%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
	            <INPUT class="InputStyle" type="input" id="remindTimeBeforeStart" name="remindTimeBeforeStart" onchange="checkint('remindTimeBeforeStart')" size=5 value="" style="width:40px;">
	            <%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
	            <br>
	            <INPUT type="checkbox" id="remindBeforeEnd" name="remindBeforeEnd" value="1" >
	            <%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
	            <INPUT class="InputStyle" type="input" id="remindDateBeforeEnd" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size=5 value="" style="width:40px;">
	            <%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
	            <INPUT class="InputStyle" type="input" id="remindTimeBeforeEnd" name="remindTimeBeforeEnd" onchange="checkint('remindTimeBeforeEnd')"  size=5 value="" style="width:40px;">
	            <%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
        
		    </wea:item>
		     <wea:item ><%=SystemEnv.getHtmlLabelName(24638,user.getLanguage())%></wea:item>
		    <wea:item>
				<select name="validateType" id="validateType" style="width: 80px;">
		            <option value="lastname"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></option>
		            <option value="id"><%=SystemEnv.getHtmlLabelName(130168,user.getLanguage())%></option>
		            <option value="loginid"><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
		            <option value="workcode"><%=SystemEnv.getHtmlLabelName(19401,user.getLanguage())%></option>
		        </select>
		    </wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(16699, user.getLanguage())%></wea:item>
		    <wea:item>
		        <input class=inputstyle style="width: 360px" type="file" name="excelfile" onchange='checkinput("excelfile","excelfilespan");this.value=trim(this.value)'>
		        <SPAN id=excelfilespan>
		         <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
		        </SPAN>
		    </wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(19971, user.getLanguage())%></wea:item>
		    <wea:item><a href="javascript:downloadExcel()" style="color: blue"><%=SystemEnv.getHtmlLabelName(28576, user.getLanguage())%></a>&nbsp;<%=SystemEnv.getHtmlLabelName(20211, user.getLanguage())%></wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>'>
			<wea:item>
			<br>
			1.<%=SystemEnv.getHtmlLabelName(33964, user.getLanguage())%><br><br>
			2.<%=SystemEnv.getHtmlLabelName(33965, user.getLanguage())%><br><br>
			3.<%=SystemEnv.getHtmlLabelName(130167, user.getLanguage())%> <br><br>	
			</wea:item>
		</wea:group>
	</wea:layout>  
</form>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<iframe id="iframeExcelOut" style="display: none"></iframe>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>   
<script language=javascript>

jQuery(document).ready(function(){
	if("0"=="<%=WorkPlanSetInfo.getShowRemider()%>"){
		hideEle("ShowRemider", true);
	}

	var remindType=$("input[name='remindType']:checked").val();
	if("2" != remindType && "3" != remindType)
	{
		hideEle("remindTime", true);
	}
	else
	{
		showEle("remindTime");
	}
	resizeDialog(document);
});

function downloadExcel(){
document.getElementById("iframeExcelOut").src = "/workplan/config/import/workplanexcel.xls";
}

function btn_cancle(){
	parent.closeDlgAndRfsh();
}
releasePage();
	     
/*提交请求，通过隐藏iframe提交*/
function dosubmit(obj) {
	$("#result").html("");
    if(check_form(document.frmMain,'excelfile')) {
       forbiddenPage();
       document.frmMain.submit() ;
    }
}

function showRemindTime(obj)
{	
	if("2" != obj.value && "3" != obj.value)
	{
		hideEle("remindTime", true);
	}
	else
	{
		showEle("remindTime");
	}
}
   
function forbiddenPage(){
	$("<div class=\"datagrid-mask\" style=\"position:fixed;z-index:2;opacity:0.4;filter:alpha(opacity=40);BACKGROUND-COLOR:#fff;\"></div>").css({display:"block",width:"100%",height:"100%",top:0,left:0}).appendTo("body");   
    $("<div class=\"datagrid-mask-msg\" style=\"background:#fff;position:fixed;z-index:3;padding: 10px;padding-top: 6px;padding-bottom: 6px;border: 1px solid;\"></div>").html("<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%>").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});  
}  

function releasePage(){  
    $(".datagrid-mask,.datagrid-mask-msg").hide();  
}


</script>

</BODY>
</HTML>
