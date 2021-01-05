<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	if (!HrmUserVarify.checkUserRight("FnaYearsPeriodsAdd:Add", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/fna/js/e8Common_wev8.js?r=9"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
<%
	int msgid = Util.getIntValue(request.getParameter("msgid"), -1);
	Calendar today = Calendar.getInstance();
	String currentyear = Util.add0(today.get(Calendar.YEAR), 4);
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
			+ Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
			+ Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear", "");
	if (RecordSet.next()) {
		String thelastyear = RecordSet.getString("fnayear");
		String thelastdate = RecordSet.getString("enddate");
		currentyear = Util.add0(Util.getIntValue(thelastyear) + 1, 4);
		int tempyear = Util.getIntValue(thelastdate.substring(0, 4));
		int tempmonth = Util.getIntValue(thelastdate.substring(5, 7)) - 1;
		int tempdate = Util.getIntValue(thelastdate.substring(8, 10));
		today.set(tempyear, tempmonth, tempdate);
		today.add(Calendar.DATE, 1);
		currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
				+ Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
				+ Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	}
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(445, user
				.getLanguage())
				+ " : "
				+ SystemEnv.getHtmlLabelName(365, user.getLanguage());
		String needfav = "1";
		String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:onAdd(2),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(32159, user.getLanguage())
			+ ",javascript:onAdd(1),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(18648,user.getLanguage()) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="onAdd(2);">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159, user.getLanguage()) %>" id="zd_btn_submit_0" class="e8_btn_top" onclick="onAdd(1);">
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
		
	<wea:layout type="2Col" >
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(445, user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="namespan" required="true">
						<input class=inputstyle type=hidden name=operation value="addyearperiods" />
						<input class=inputstyle id=fnayear maxlength="4" name=fnayear value="<%=currentyear%>" style="width: 40px;" 
							onmousemove="checkinput('fnayear','namespan')" onKeyPress="ItemCount_KeyPress()" 
							onBlur='checknumber("fnayear");checkinput("fnayear","fnayearimage")' />
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(740, user.getLanguage())%></wea:item>
			<wea:item>
					<BUTTON class=Calendar type="button" id=selectstartdate onclick="onShowDate(startdatespan,startdate)"></BUTTON>
					<SPAN id=startdatespan ><%=currentdate%></SPAN>
					<input class=inputstyle type="hidden" name="startdate" id="startdate" value="<%=currentdate%>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(602, user.getLanguage())%></wea:item>
			<wea:item>
					<%=SystemEnv.getHtmlLabelName(18430,user.getLanguage())%>
				<input name="status" id="status" class="inputstyle" type="hidden" value="0" />				</wea:item>
			</wea:group>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
		    <wea:group context="">
		    	<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage()) %>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="onCancel();">
		    	</wea:item>
		    </wea:group>
		</wea:layout>
</div>
<script type="text/javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

resizeDialog(document);
//页面初始化事件
checkinput("fnayear","namespan");
	
function checkvalue() {
	var fnayear=jQuery("#fnayear").val();
	var startdate=jQuery("#startdatespan").text();
	if(fnayear.trim().length==0||startdate.trim().length==0){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30933, user.getLanguage())%>");
		return false ;
	}
	if(fnayear.length!= 4 ) {
		top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(25, user.getLanguage())%>");
		return false;
	}
	return true ;
}


function onAdd(_type){
	if(checkvalue()){
		var status=jQuery("#status").val();
		var startdate=jQuery("#startdate").val();
		var fnayear=jQuery("#fnayear").val();

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/maintenance/FnaYearsPeriodsOperation.jsp",
			type : "post",
			processData : false,
			data : "operation=addyearperiods&status="+status+"&startdate="+startdate+"&fnayear="+fnayear,
			dataType : "json",
			success: function do4Success(msg){ 
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(msg.flag){
					var parentWin = parent.getParentWindow(window);
					var dialog = parent.getDialog(parentWin);
					if(_type == 1){
						parentWin.openEditPage(msg.fnayearid, null, null, 1, parentWin);
					}else{
						parentWin.onBtnSearchClick();
						onCancel2();
					}
				}else{
					alert(msg.erroInfo);
				}
			}
		});
	}
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

function onCancel2(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

//关闭
function doClose(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}
</script>
	</BODY>
</HTML>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
