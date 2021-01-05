<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<%
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

char flag=Util.getSeparator() ;
String ProcPara = "";

String meetingid = Util.null2String(request.getParameter("meetingid"));
String recorderid = Util.null2String(request.getParameter("recorderid"));

RecordSet.executeProc("Meeting_Member2_SelectByID",recorderid);
RecordSet.next();
String isattend=Util.null2String(RecordSet.getString("isattend"));
String bookroom=Util.null2String(RecordSet.getString("bookroom"));
String roomstander=Util.null2String(RecordSet.getString("roomstander"));
String bookticket=Util.null2String(RecordSet.getString("bookticket"));

String ticketstander=Util.null2String(RecordSet.getString("ticketstander"));
String othermember=Util.null2String(RecordSet.getString("othermember"));
String begindate=Util.null2String(RecordSet.getString("begindate"));
String begintime=Util.null2String(RecordSet.getString("begintime"));

String enddate=Util.null2String(RecordSet.getString("enddate"));
String endtime=Util.null2String(RecordSet.getString("endtime"));
String recRemark=Util.null2String(RecordSet.getString("recRemark"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/ecology8/request/seachBody_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2108,user.getLanguage());
String needfav ="1";
String needhelp ="";

String needcheck="";
int membercrmrows=0;
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button"
				value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"
				class="e8_btn_top middle" onclick="doSave()">
			<input type="button"
				value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage())%>"
				class="e8_btn_top middle" onclick="onClear()">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<div class="zDialog_div_content">
<FORM id=weaver name=weaver action="/meeting/data/MeetingReCrmOperation.jsp" method=post >
<input type="hidden" name="method" value="edit">
<input type="hidden" name="meetingid" value="<%=meetingid%>">
<input type="hidden" name="recorderid" value="<%=recorderid%>">
<input type="hidden" name="membercrmrows" value="0">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>' >
        <wea:item><%=SystemEnv.getHtmlLabelName(2187,user.getLanguage())%></wea:item>
        <wea:item>
			<input type=radio name="isattend" value="1" <%if(isattend.equals("1") || isattend.equals("") ){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
			<input type=radio name="isattend" value="2" <%if(isattend.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
			<%if(isattend.equals("3")){ %>
	        <INPUT type=radio name="isattend" value="3" style="display:none" checked>
	        <%} %>
		</wea:item>
		<%if(meetingSetInfo.getRecArrive()==1){ %>
        <wea:item><%=SystemEnv.getHtmlLabelName(2186,user.getLanguage())%></wea:item>
        <wea:item>
		   <BUTTON class="Calendar" type='button' onclick="getDate(BeginDatespan,begindate)"></BUTTON> 
		   <SPAN id=BeginDatespan ><%=begindate%></SPAN> 
			&nbsp;-&nbsp;
          <button class="Clock" type='button' onclick="onshowMeetingTime(BeginTimespan,begintime)"></button>
		  <span id="BeginTimespan"><%=begintime%></span>
		  <input class="inputstyle" type="hidden" name="begindate" value="<%=begindate%>">
		  <input class="inputstyle" type=hidden name="begintime" value="<%=begintime%>">
		</wea:item>
		<%}if(meetingSetInfo.getRecBook()==1){ %>
        <wea:item><%=SystemEnv.getHtmlLabelName(2185,user.getLanguage())%></wea:item>
        <wea:item>
			<input type=radio name="bookroom" value="1" <%if(bookroom.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
			<input type=radio name="bookroom" value="2" <%if(bookroom.equals("2") || bookroom.equals("")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
			&nbsp;<input class=Inputstyle size=10 name="roomstander" value="<%=roomstander%>">
		</wea:item>
		<%}if(meetingSetInfo.getRecReturn()==1){ %>
        <wea:item><%=SystemEnv.getHtmlLabelName(2184,user.getLanguage())%></wea:item>
        <wea:item><input type=radio name="bookticket" value="1" <%if(bookticket.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
			<input type=radio name="bookticket" value="2" <%if(bookticket.equals("2") || bookticket.equals("")){%>checked<%}%>  onclick="cancelTicket(this)"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
		</wea:item>
        <wea:item><%=SystemEnv.getHtmlLabelName(2183,user.getLanguage())%></wea:item>
        <wea:item>
        <BUTTON class="Calendar" type='button' onclick="getDate(EndDatespan,enddate)"></BUTTON> 
        <SPAN id=EndDatespan ><%=enddate%></SPAN>
          &nbsp;-&nbsp;
          <button class="Clock" type='button' onclick="onshowMeetingTime(EndTimespan,endtime)"></button>
          <span id="EndTimespan"><%=endtime%></span>
          <input class="inputstyle" type="hidden" name="enddate" value="<%=enddate%>">
          <input class="inputstyle" type=hidden name="endtime" value="<%=endtime%>">
		</wea:item>
        <wea:item><%=SystemEnv.getHtmlLabelName(2182,user.getLanguage())%></wea:item>
        <wea:item>
		  <%=SystemEnv.getHtmlLabelName(2180,user.getLanguage())%>&nbsp;&nbsp;
		  <input type=radio name="ticketstander" value="1" <%if(ticketstander.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2174,user.getLanguage())%>
		  <input type=radio name="ticketstander" value="2" <%if(ticketstander.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2175,user.getLanguage())%>
		  <input type=radio name="ticketstander" value="3" <%if(ticketstander.equals("3")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2176,user.getLanguage())%>
		  <br>
		  <%=SystemEnv.getHtmlLabelName(2181,user.getLanguage())%>&nbsp;&nbsp;
		  <input type=radio name="ticketstander" value="4" <%if(ticketstander.equals("4")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2177,user.getLanguage())%>
		  <input type=radio name="ticketstander" value="5" <%if(ticketstander.equals("5")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2178,user.getLanguage())%>
		  <input type=radio name="ticketstander" value="6" <%if(ticketstander.equals("6")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2179,user.getLanguage())%>
		</wea:item>
		<%}if(meetingSetInfo.getRecRemark()==1){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(22265,user.getLanguage())%></wea:item>
        <wea:item>
	       <INPUT class=Inputstyle name="recRemark" value="<%=recRemark%>">
        </wea:item>
        <%} %>
	   </wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%>' >
		<wea:item type="groupHead">
			<input class="addbtn" accesskey="A" onclick="addRow();" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" type="button">
			<input class="delbtn" accesskey="E" onclick="deleteRow1();" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" type="button">
		</wea:item>
		<wea:item attributes="{\"isTableList\":true}">
			<TABLE class="ListStyle LayoutTable" cellspacing=1 cellpadding=1  cols=7 id="oTable">
				<TBODY>
				<tr class="header">
					<th width=4%>&nbsp;</th>
					<th><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(1916,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></th>
				</tr>
			<%
			RecordSet.executeProc("Meeting_MemberCrm_SelectAll",recorderid);
			while(RecordSet.next()){
			%>
				<tr class='DataDark'>
					<td class="Field"><input type='checkbox' name='check_node' value='0'></td>
					<td class="Field">
						<input type='input' style=width:99%  name='name_<%=membercrmrows%>' value="<%=RecordSet.getString("name")%>">
					</td>
					<td class="Field">
						<select name='sex_<%=membercrmrows%>' style="width:80px;">
						  <option value="1" <%if(RecordSet.getString("sex").equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%>
						  <option value="2" <%if(RecordSet.getString("sex").equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%>
						</SELECT>
					</td>
					<td class="Field">
						<input type='input' style=width:99%  name='occupation_<%=membercrmrows%>' value="<%=RecordSet.getString("occupation")%>">
					</td>
					<td class="Field">
						<input type='input' style=width:99%  name='tel_<%=membercrmrows%>' value="<%=RecordSet.getString("tel")%>">
					</td>
					<td class="Field">
						<input  type='input' style=width:99%  name='handset_<%=membercrmrows%>' value="<%=RecordSet.getString("handset")%>">
					</td>
					<td class="Field">
						<input  type='input' style=width:99%  name='desc_<%=membercrmrows%>' value="<%=RecordSet.getString("desc_n")%>">
					</td>
				</tr>
			<%
			membercrmrows = membercrmrows +1;
			}
			%>
			</TBODY>
		  </TABLE>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >   
</script>  
<script language=javascript>  
rowindex = "<%=membercrmrows%>";
var rowColor="" ;
function addRow()
{
	rowColor = getRowBg();
	
	var htmlstr="";
	htmlstr=htmlstr+"<tr class='DataDark'>";
	htmlstr=htmlstr+"<td class=field ><input class='inputstyle' type='checkbox' name='check_node' value='0'></td>";
	htmlstr=htmlstr+"<td class=field ><input class='inputstyle' type='input' style=width:99%  name='name_"+rowindex+"'></td>";
	htmlstr=htmlstr+"<td class=field ><select name='sex_"+rowindex+"' style='width:80px;'><option value='1'><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%> <option value='2'><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%>	</SELECT></td>";
	htmlstr=htmlstr+"<td class=field ><input class='inputstyle' type='input' style=width:99%  name='occupation_"+rowindex+"'></td>";
	htmlstr=htmlstr+"<td class=field ><input class='inputstyle' type='input' style=width:99%  name='tel_"+rowindex+"'></td>";
	htmlstr=htmlstr+"<td class=field ><input class='inputstyle' type='input' style=width:99%  name='handset_"+rowindex+"'></td>";
	htmlstr=htmlstr+"<td class=field ><input class='inputstyle' type='input' style=width:99%  name='desc_"+rowindex+"'></td>";
	htmlstr=htmlstr+"</tr>";
	
	jQuery("#oTable tbody").append(htmlstr);
	rowindex = rowindex*1 +1;
	jQuery("body").jNice();
	beautySelect();
	var tr = jQuery("table.LayoutTable tr[class!=intervalTR]");
	tr.each(function(){
		if(!jQuery(this).hasClass("intervalTR")){
			jQuery(this).hover(function(){
				jQuery(this).addClass("Selected");
				//jQuery(this).next("tr.Spacing").find("div").addClass("intervalHoverClass");		
			},function(){
				jQuery(this).removeClass("Selected");	
				//jQuery(this).next("tr.Spacing").find("div").removeClass("intervalHoverClass");	
			});
		}
	});
}
function deleteRow1()
{
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344, user.getLanguage())%>", function (){
		dodeleteRow1();	
	}, function () {}, 320, 90,false);
}


function dodeleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1);	
			}
			rowsum1 -=1;
		}
	
	}	
}	

function onClear(){
	document.weaver.method.value="empty";
	weaver.action="MeetingReCrm.jsp"
	weaver.submit();
}
function btn_cancle(){
	 var parentWin = parent.parent.getParentWindow(window.parent);
     parentWin.diag_vote.close();
}
jQuery(document).ready(function(){
	resizeDialog(document);
});

function cancelTicket(obj){
	if($(obj).val()==2){
		var o=$('INPUT[name="ticketstander"]:checked');
		if(o&&o.length>0){
			changeRadioStatus(o,false);
		}
	}
}

function doSave(){
	if(check_form(document.weaver,'<%=needcheck%>')){
		document.weaver.membercrmrows.value=rowindex;
		document.weaver.submit();
	}
}
</script>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
</html>
