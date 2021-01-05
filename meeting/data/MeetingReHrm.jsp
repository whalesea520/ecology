<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
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
String method=Util.null2String(request.getParameter("method"));
if(method.equals("empty"))
{
	 isattend="";
	 bookroom = "";
	 roomstander = "";
	 bookticket = "";
	 ticketstander = "";
	 othermember = "";
	 begindate = "";
	 begintime = "";
	 enddate = "";
	 endtime = "";
	 recRemark="";
}
%>

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/ecology8/request/seachBody_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2108,user.getLanguage());
String needfav ="1";
String needhelp ="";

int topicrows=0;
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:submit(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:onClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
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
				class="e8_btn_top middle" onclick="submit()">
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
<FORM id=weaver name=weaver action="/meeting/data/MeetingReHrmOperation.jsp" method=post >
<input type="hidden" name="method" value="edit">
<input type="hidden" name="meetingid" value="<%=meetingid%>">
<input type="hidden" name="recorderid" value="<%=recorderid%>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>' >
        <wea:item><%=SystemEnv.getHtmlLabelName(2187,user.getLanguage())%></wea:item>
        <wea:item>
	        <INPUT type=radio name="isattend" value="1" <%if(isattend.equals("1") || isattend.equals("") ){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	        <INPUT type=radio name="isattend" value="2" <%if(isattend.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	        <%if(isattend.equals("3")){ %>
	        <INPUT type=radio name="isattend" value="3" style="display:none" checked>
	        <%} %>
	        
        </wea:item>
        <%if(meetingSetInfo.getRecArrive()==1){ %>
        <wea:item><%=SystemEnv.getHtmlLabelName(2186,user.getLanguage())%></wea:item>
		<wea:item>
			<button type='button' class=Calendar onclick="getDate(BeginDatespan,begindate)"></BUTTON> 
			<SPAN id=BeginDatespan ><%=begindate%></SPAN> 
			&nbsp;-&nbsp;
			<button type='button' class=Clock onclick="onshowMeetingTime(BeginTimespan,begintime)"></button>
			<span id="BeginTimespan"><%=begintime%></span>
			<input type="hidden" name="begindate" value="<%=begindate%>">
			<INPUT type=hidden name="begintime" value="<%=begintime%>">
		</wea:item>
		<%}if(meetingSetInfo.getRecBook()==1){ %>
        <wea:item><%=SystemEnv.getHtmlLabelName(2185,user.getLanguage())%></wea:item>
        <wea:item>
	        <INPUT type=radio name="bookroom" value="1" <%if(bookroom.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	        <INPUT type=radio name="bookroom" value="2" <%if(bookroom.equals("2") || bookroom.equals("")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	        &nbsp;<INPUT class=Inputstyle size=10 name="roomstander" value="<%=roomstander%>">
        </wea:item>
        <%}if(meetingSetInfo.getRecReturn()==1){ %>
        <wea:item><%=SystemEnv.getHtmlLabelName(2184,user.getLanguage())%></wea:item>
        <wea:item>
	        <INPUT type=radio name="bookticket" value="1" <%if(bookticket.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	        <INPUT type=radio name="bookticket" value="2" <%if(bookticket.equals("2") || bookticket.equals("")){%>checked<%}%> onclick="cancelTicket(this)"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
        </wea:item>
        <wea:item><%=SystemEnv.getHtmlLabelName(2183,user.getLanguage())%></wea:item>
        <wea:item>
	        <button type='button' class=Calendar onclick="getDate(EndDatespan,enddate)"></BUTTON> 
	        <SPAN id=EndDatespan ><%=enddate%></SPAN>
	        &nbsp;-&nbsp;
	        <button type='button' class=Clock onclick="onshowMeetingTime(EndTimespan,endtime)"></button>
	        <span id="EndTimespan"><%=endtime%></span>
	        <input type="hidden" name="enddate" value="<%=enddate%>">
	        <INPUT type=hidden name="endtime" value="<%=endtime%>">
        </wea:item>
        <wea:item><%=SystemEnv.getHtmlLabelName(2182,user.getLanguage())%></wea:item>
        <wea:item>
		  <%=SystemEnv.getHtmlLabelName(2180,user.getLanguage())%>&nbsp;&nbsp;
		  <INPUT type=radio name="ticketstander" value="1" <%if(ticketstander.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2174,user.getLanguage())%>
		  <INPUT type=radio name="ticketstander" value="2" <%if(ticketstander.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2175,user.getLanguage())%>
		  <INPUT type=radio name="ticketstander" value="3" <%if(ticketstander.equals("3")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2176,user.getLanguage())%>
		  <br>
		  <%=SystemEnv.getHtmlLabelName(2181,user.getLanguage())%>&nbsp;&nbsp;
		  <INPUT type=radio name="ticketstander" value="4" <%if(ticketstander.equals("4")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2177,user.getLanguage())%>
		  <INPUT type=radio name="ticketstander" value="5" <%if(ticketstander.equals("5")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2178,user.getLanguage())%>
		  <INPUT type=radio name="ticketstander" value="6" <%if(ticketstander.equals("6")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2179,user.getLanguage())%>
		</wea:item>
		<%}if(meetingSetInfo.getRecRemark()==1){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(22265,user.getLanguage())%></wea:item>
        <wea:item>
	       <INPUT class=Inputstyle name="recRemark" value="<%=recRemark%>">
        </wea:item>
        <%} %>
    </wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(2189,user.getLanguage())%>' >
		<wea:item>
            <%
	            ArrayList arrayothermember = Util.TokenizerString(othermember,",");
	            String othermemberNames="";
	        	for(int i=0;i<arrayothermember.size();i++){
	        		othermemberNames=othermemberNames+","+ResourceComInfo.getResourcename(""+arrayothermember.get(i));
	        	}
                if(othermemberNames.length()>0)
                	othermemberNames=othermemberNames.substring(1);
            %>
			<brow:browser viewType="0" name="othermember" browserValue='<%=othermember%>' 
			browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
			hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="250px"
			completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
			browserSpanValue='<%=othermemberNames%>'></brow:browser>
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
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script language=javascript>
rowindex = "<%=topicrows%>";
var submitFlag=true;
function addRow()
{
	ncol = oTable.cols;
	
	oRow = oTable.insertRow();
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' style=width:99%  name='topicsubject_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button type='button' class=Browser onClick=onShowHrm('topichrm_"+rowindex+"span','topichrm_"+rowindex+"','0')></button> " + 
        					"<span class=inputstyle id=topichrm_"+rowindex+"span></span> "+
        					"<input type='hidden' name='topichrm_"+rowindex+"' id='topichrm_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;

			case 3: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='topicopen_"+rowindex+"' value='1'><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
	
		}
	}
	rowindex = rowindex*1 +1;
	
}

function submit(){
	if(submitFlag){//防止连续多次提交
	submitFlag=false;
	weaver.submit();
	}
	
}

function deleteRow1()
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
				oTable.deleteRow(rowsum1-1);	
			}
			rowsum1 -=1;
		}
	
	}	
}	

function onClear(){
	document.weaver.method.value="empty";
	weaver.action="MeetingReHrm.jsp"
	weaver.submit();
}
function btn_cancle(){
	 var parentWin = parent.parent.getParentWindow(window.parent);
     parentWin.diag_vote.close();
}

function cancelTicket(obj){
	if($(obj).val()==2){
		var o=$('INPUT[name="ticketstander"]:checked');
		if(o&&o.length>0){
			changeRadioStatus(o,false);
		}
	}
}

jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</html>
