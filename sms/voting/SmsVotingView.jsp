
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.math.*,java.text.*" %>
<jsp:useBean id="rs_smsvotingdetail" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_smsvoting" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="sptmForSmsVoting" class="weaver.splitepage.transform.SptmForSmsVoting" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="../../js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="../../js/selectDateTime_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script src="/js/tabs/jquery.tabs_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22304, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(367, user.getLanguage())+"&nbsp;";
String needfav = "1";
String needhelp = "";

if(!HrmUserVarify.checkUserRight("SmsVoting:Manager", user)){
	response.sendRedirect("/notice/noright.jsp");
	return ;
}
int smsvotingid = Util.getIntValue(request.getParameter("id"), 0);
if(smsvotingid == 0){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String subject = "";
String senddate = "";
String sendtime = "";
String enddate = "";
String endtime = "";
int isseeresult = 0;//0，投票人可查看；1，不可查看
String smscontent = "";
String remark = "";
String hrmids = "";
String hrmidsStr = "";
int status = -1;
String statusStr = "";
int votingcount = 0;
int vaildvotingcount = 0;
int creater = 0;
String sql = "select * from smsvoting where id="+smsvotingid;
rs_smsvoting.execute(sql);
if(!rs_smsvoting.next()){
	response.sendRedirect("/notice/noright.jsp");
	return;
}else{
	creater = Util.getIntValue(rs_smsvoting.getString("creater"), 0);
	status = Util.getIntValue(rs_smsvoting.getString("status"), 0);
	subject = Util.null2String(rs_smsvoting.getString("subject"));
	senddate = Util.null2String(rs_smsvoting.getString("senddate"));
	sendtime = Util.null2String(rs_smsvoting.getString("sendtime"));
	enddate = Util.null2String(rs_smsvoting.getString("enddate"));
	endtime = Util.null2String(rs_smsvoting.getString("endtime"));
	isseeresult = Util.getIntValue(rs_smsvoting.getString("isseeresult"), 0);
	smscontent = Util.null2String(rs_smsvoting.getString("smscontent"));
	remark = Util.null2String(rs_smsvoting.getString("remark"));
	hrmids = Util.null2String(rs_smsvoting.getString("hrmids"));
	votingcount = Util.getIntValue(rs_smsvoting.getString("votingcount"), 0);
	vaildvotingcount = Util.getIntValue(rs_smsvoting.getString("vaildvotingcount"), 0);
	String[] hrmid_sz = Util.TokenizerString2(hrmids, ",");
	if(hrmid_sz!=null && hrmid_sz.length>0){
		for(int i=0; i<hrmid_sz.length; i++){
			int hrmid = Util.getIntValue(hrmid_sz[i], 0);
			if(hrmid == 0){
				continue;
			}
			hrmidsStr += ("<a href=\"/hrm/resource/HrmResource.jsp?id="+hrmid+"\">"+resourceComInfo.getLastname(""+hrmid)+"</a>&nbsp;");
		}
	}
	statusStr = sptmForSmsVoting.getSmsVotingStatus(""+status, ""+user.getLanguage());
}
titlename += "<B>" + SystemEnv.getHtmlLabelName(602, user.getLanguage()) + ":&nbsp;</B>" + statusStr;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(creater == user.getUID()){
	if(status==0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(93, user.getLanguage())+",javascript:onEdit(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javascript:onDel(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

	if(status == 1){
		//RCMenu += "{"+SystemEnv.getHtmlLabelName(405, user.getLanguage())+",javascript:onEnd(),_top} " ;
		//RCMenuHeight += RCMenuHeightStep ;
	}else if(status == 2){
		//RCMenu += "{"+SystemEnv.getHtmlLabelName(244, user.getLanguage())+",javascript:onReopen(),_top} " ;
		//RCMenuHeight += RCMenuHeightStep ;
	}

}

RCMenu += "{"+SystemEnv.getHtmlLabelName(201, user.getLanguage())+",javascript:btn_cancle(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="box tabs" id="basicset">
	<ul class="tab_menu">
	    <li class="current">
	    	<a  id="baseli" href="#" onclick="return false;">
	    		<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>
	    	</a>
	    </li>
	    <li >
	    	<a  id="contentli" href="#" onclick="return false;" >
	    		<%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%>
	    	</a>
	    </li>
	</ul>
<div class="tab_box">

<div class="zDialog_div_content" style="overflow:auto;">
<TABLE width=100% height=95% border="0" cellspacing="0">
	<colgroup>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td></td>
		<td valign="top"  colspan="3">
		<TABLE class=Shadow>
			<tr>
			<td valign="top">
			<form name=frmmain action="SmsVotingOperation.jsp" method=post >
			<input type=hidden name=method value="end">
			<input type=hidden name=id value="<%=smsvotingid%>">
			<input type=hidden name=status value="<%=status%>">
			<div id="basediv">
			<table class="ViewForm">
			<colgroup>
			<col width=15%>
			<col width=35%>
			<col width=15%>
			<col width=35%>
			<TR style="height:1px"><TD class=line1 colSpan=4></TD></TR>  
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></td>
				<td class=field>
					<span id="subjectspan"><%=subject%></span>
				</td>
				<td><%=SystemEnv.getHtmlLabelName(21723, user.getLanguage())%></td>
				<td class=field>
					<input type=checkbox class="inputStyle" name="isseeresult" value="1" <%if(isseeresult==1){out.print("checked");}%> disabled>
				</td>
			</tr>
			<TR style="height:1px"><TD class=line colSpan=4></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(18961, user.getLanguage())%></td>
				<td class=field colspan="3">
					<SPAN id="senddatespan"><%=senddate%></SPAN>&nbsp;
					<%
					try{
						sendtime = sendtime.substring(0, 5);
					}catch(Exception e){}
					if("".equals(senddate.trim())){
						sendtime = "";
					}
					out.print(sendtime);
					%>
				</td>
			</tr>
			<TR style="height:1px"><TD class=line colSpan=4></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(743, user.getLanguage())%></td>
				<td class=field colspan="3">
					<SPAN id=EndDatespan><%=enddate%></SPAN>&nbsp;
					<%
					try{
						endtime = endtime.substring(0, 5);
					}catch(Exception e){}
					if("".equals(enddate.trim())){
						endtime = "";
					}
					out.println(endtime);
					%>
				</td>
			</tr>
			<TR style="height:1px"><TD class=line colSpan=4></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(16284, user.getLanguage())%></td>
				<td class=field colspan="3"><%=remark%></td>
			</tr>
			<TR style="height:1px"><TD class=line colSpan=4></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(15525, user.getLanguage())%></td>
				<td class=field colspan="3">
					<span id="hrmidsspan"><%=hrmidsStr%></span>
				</td>
			</tr>
			<TR style="height:1px"><TD class=line colSpan=4></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(18529, user.getLanguage())%></td>
				<td class=field colspan="3">
					<%=smscontent%>
				</td>
			</tr>
			<TR style="height:1px"><TD class=line colSpan=4></TD></TR>
			<%
				int colSpan = 2;
				if(status != 0){
					colSpan = 4;
			%>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(22367, user.getLanguage())%></td>
				<td class="field">
					<%=votingcount%>
				</td>
				<td><%=SystemEnv.getHtmlLabelName(22368, user.getLanguage())%></td>
				<td class="field">
					<%=vaildvotingcount%>
				</td>
			</tr>
			<TR style="height:1px"><TD class=line colSpan=4></TD></TR>
			<%
				}
			%>
			</table>
			</div>
			<div id="contentdiv" style="display:none">
			<table class="listStyle" id="oTable" name="oTable">
			<%if(status == 0){%>
				<col width="12%">
				<col width="80%">
			<%}else{%>
				<col width="15%">
				<col width="65%">
				<col width="10%">
				<col width="10%">
			<%}%>
			<tr class=header>
				<td><%=SystemEnv.getHtmlLabelName(1025, user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%></td>
				<%if(status != 0){%>
				<td><%=SystemEnv.getHtmlLabelName(22368, user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(336, user.getLanguage())%></td>
				<%}%>
			</tr>
			<%
				int rowindex = 1;
				String classStr = " class=\"DataLight\" ";
				boolean isLight = true;
				DecimalFormat dFormat = new DecimalFormat("#0.00");
				sql = "select * from smsvotingdetail where smsvotingid="+smsvotingid+" order by id asc";
				rs_smsvotingdetail.execute(sql);
				while(rs_smsvotingdetail.next()){
					String regcontent_tmp = Util.null2String(rs_smsvotingdetail.getString("regcontent"));
					String remark_tmp = Util.null2String(rs_smsvotingdetail.getString("remark"));
					int count_tmp = Util.getIntValue(rs_smsvotingdetail.getString("count"), 0);
					out.println("<tr "+classStr+">");
					out.println("<td>&nbsp;"+regcontent_tmp+"</td>");
					out.println("<td>"+remark_tmp+"</td>");
					if(status != 0){
						out.println("<td>"+count_tmp+"&nbsp;"+SystemEnv.getHtmlLabelName(18607, user.getLanguage())+"</td>");
						float tmp_f;
						String rat = "0.00";
						if(vaildvotingcount > 0){
							tmp_f = (count_tmp * 10000) / vaildvotingcount;
							tmp_f = tmp_f / 100;
							rat = dFormat.format(tmp_f);
						}
						out.println("<td>"+rat+"%</td>");
					}
					out.println("</tr>");
					rowindex++;
					if(isLight == true){
						isLight = false;
						classStr = " class=\"DataDark\" ";
					}else{
						isLight = true;
						classStr = " class=\"DataLight\" ";
					}
				}
			%>
			</table>
			</div>
			</form>
			</td>
			</tr>
		</TABLE>
		</td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
</table>
</div>
</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
		<tr>
			<td style="text-align: center;border-top:0px;border-bottom:0px;">
				<%if(creater == user.getUID()){
					if(status==0){
						%>
						<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"
						class="e8_btn_submit" onclick="onEdit()" />
						<%
					}
					%>
					<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"
					class="e8_btn_submit" onclick="onDel()" />
					<%
				}%>
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>"
					id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
			</td>
		</tr>
	</table>
</div>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">

function onEdit(){
	//window.location = "SmsVotingEdit.jsp?id=<%=smsvotingid%>";
	var parentWin = parent.getParentWindow(window);
	parentWin.showDlg("<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22304,user.getLanguage())%>", "/sms/voting/SmsVotingEditTab.jsp?id=<%=smsvotingid%>",parentWin.diag_vote,parentWin);
}
function onReopen(){
	window.location = "SmsVotingEdit.jsp?id=<%=smsvotingid%>&isreopen=1";
}
function onDel(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		document.frmmain.action = "/sms/voting/SmsVotingOperation.jsp";
		document.frmmain.method.value = "delete";
		document.frmmain.submit();
		enableAllmenu();
    });
}
function onEnd(){
	document.frmmain.action = "SmsVotingOperation.jsp";
	document.frmmain.method.value = "end";
	document.frmmain.submit();
	enableAllmenu();
}

$(function(){
    $(".tabs").Tabs({
        event:"click",
        callback:null,
        getLine:1,
        topHeight:40
    });
   
}); 

jQuery(document).ready(function(){
	jQuery("#baseli").bind("click",function(){
		jQuery("#basediv").css("display","");
		jQuery("#contentdiv").css("display","none");
	});
	
	jQuery("#contentli").bind("click",function(){
		jQuery("#basediv").css("display","none");
		jQuery("#contentdiv").css("display","");
	});
	resizeDialog(document);
	setTimeout(function(){
		var h = jQuery(".tab_box").height() - 1;
	jQuery(".tab_box").height(h);},10);
});

function btn_cancle(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}
</SCRIPT>