
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.MeetingShareUtil"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<%

int deciScope = Util.getIntValue(request.getParameter("deciScope"), 0);
String subjects=Util.null2String(request.getParameter("subjects"));
String hrmid01s=Util.null2String(request.getParameter("hrmid01s"));
String hrmid02s=Util.null2String(request.getParameter("hrmid02s"));
String mtnames=Util.null2String(request.getParameter("mtnames"));
String meetingtypes=Util.null2String(request.getParameter("meetingtypes"));
String callers=Util.null2String(request.getParameter("callers"));
int statuss=Util.getIntValue(request.getParameter("statuss"),0);
String begindate1=Util.null2String(request.getParameter("begindate1"));
String enddate1=Util.null2String(request.getParameter("enddate1"));
String t_name=Util.null2String(request.getParameter("t_name"));
int timeSag = Util.getIntValue(request.getParameter("timeSag"),0);
//if(!"".equals(t_name)){
//	subjects = t_name;
//}
String allUser=MeetingShareUtil.getAllUser(user);
String[] belongs=allUser.split(",");
String sqlwhere = "";
if(deciScope == 0){
	sqlwhere += " AND ( exists ( select 1 from Meeting_Member2 where m.id = Meeting_Member2.meetingid and Meeting_Member2.membertype = 1 and Meeting_Member2.memberid in( "+ allUser +")) or m.caller in ("+ allUser +") or m.contacter in( "+ allUser +") ";
	if(rs.getDBType().equals("oracle")){
		for(int i=0;i<belongs.length;i++){
			if("".equals(belongs[i])) continue;
			sqlwhere+=" or ','|| d.hrmid01|| ',' like '%,"+belongs[i]+",%' ";
		}
	}else{
		for(int i=0;i<belongs.length;i++){
			if("".equals(belongs[i])) continue;
			sqlwhere+=" or ','+d.hrmid01+',' like '%,"+belongs[i]+",%' ";
		}
	}
	sqlwhere += " or d.hrmid02 in (" + allUser + ") ";
	sqlwhere += " or exists (select 1 from Meeting_Member2 , CRM_CustomerInfo c where m.id = Meeting_Member2.meetingid and Meeting_Member2.membertype = 2 and Meeting_Member2.memberid = c.id AND c.manager in( "+ allUser +")) ";
	sqlwhere += " or exists (SELECT 1 FROM workflow_currentoperator wc, Bill_Meeting bm WHERE wc.requestid = bm.requestid AND bm.ApproveID = m.id AND wc.userid in( "+ allUser +")) )";
}else if(deciScope == 1){
	//负责人作为搜索条件不为空的时候
	if(hrmid01s.equals("")){
		hrmid01s = "" + allUser;
	}
}else if(deciScope == 2){
	//检查人作为搜索条件不为空的时候
	if(hrmid02s.equals("")){
		hrmid02s = ""+allUser;
	}
}

if(!"".equals(subjects)) sqlwhere += "and d.subject like '%" +  subjects + "%' ";
if(!"".equals(hrmid01s)) {
	String[] hrmid01sArr = hrmid01s.split(",");
	if(rs.getDBType().equals("oracle")){
		sqlwhere += " and (";
		boolean isfirst=true;
		for(int i=0;i<hrmid01sArr.length;i++){
			if("".equals(hrmid01sArr[i])) continue;
			if(isfirst){
				isfirst=false;
			}else{
				sqlwhere+=" or ";
			}
			sqlwhere+=" ','|| d.hrmid01|| ',' like '%,"+hrmid01sArr[i]+",%' ";
		}
		
		sqlwhere += " ) ";
	}else{
		sqlwhere += " and (";
		boolean isfirst=true;
		for(int i=0;i<hrmid01sArr.length;i++){
			if("".equals(hrmid01sArr[i])) continue;
			if(isfirst){
				isfirst=false;
			}else{
				sqlwhere+=" or ";
			}
			sqlwhere+=" ','+d.hrmid01+',' like '%,"+hrmid01sArr[i]+",%' ";
		}
		sqlwhere += " )";
	}
}
if(!"".equals(hrmid02s)) {
	sqlwhere += " and d.hrmid02 in (" + hrmid02s + ") ";
}

if(!"".equals(mtnames)) sqlwhere += "and m.name like '%" +  mtnames + "%' ";

if(!"".equals(meetingtypes)) {
	sqlwhere += " and m.meetingtype in (" + meetingtypes + ") ";
}

if(!"".equals(callers)) {
	sqlwhere += " and m.caller in (" + callers + ") ";
}
//时间区间
if(timeSag > 0&&timeSag<6){
	String doclastmoddatefrom = TimeUtil.getDateByOption(""+timeSag,"0");
	String doclastmoddateto = TimeUtil.getDateByOption(""+timeSag,"1");
	if(!"".equals(doclastmoddatefrom)) {
		sqlwhere += " and d.enddate >= '" + doclastmoddatefrom + "' ";
	}

	if(!"".equals(doclastmoddateto)) {
		sqlwhere += " and d.begindate <= '" + doclastmoddateto + "' ";
	}		
}else{
	if(timeSag==6){//指定时间
		if(!"".equals(begindate1)) {
			sqlwhere += " and d.enddate >= '" + begindate1 + "' ";
		}

		if(!"".equals(enddate1)) {
			sqlwhere += " and d.begindate <= '" + enddate1 + "' ";
		}		
	}
	
}



String currentTime = TimeUtil.getCurrentDateString() + " " + TimeUtil.getOnlyCurrentTimeString().substring(0,5);
switch(statuss){
	case 1:
		if(rs.getDBType().equals("oracle")){
			sqlwhere += " and d.begindate||' '||decode(d.begintime,'', '00:00',d.begintime) > '" +  currentTime + "' ";
		}else{
			sqlwhere += " and d.begindate+' '+(CASE d.begintime WHEN '' then '00:00' ELSE d.begintime END) > '" +  currentTime + "' ";
		}
		sqlwhere += " and w.status = '0' ";
		break;
	case 2:
		if(rs.getDBType().equals("oracle")){
			sqlwhere += " and d.begindate||' '||decode(d.begintime,'', '00:00',d.begintime) <= '" +  currentTime + "' ";
		}else{
			sqlwhere += " and d.begindate+' '+(CASE d.begintime WHEN '' then '00:00' ELSE d.begintime END) <= '" +  currentTime + "' ";
		}
		if(rs.getDBType().equals("oracle")){
			sqlwhere += " and d.enddate||' '||decode(d.endtime,'', '00:00',d.endtime) >= '" +  currentTime + "' ";
		}else{
			sqlwhere += " and d.enddate+' '+(CASE d.endtime WHEN '' then '00:00' ELSE d.endtime END) >= '" +  currentTime + "' ";
		}
		sqlwhere += " and w.status = '0' ";
		break;
	case 4:
		if(rs.getDBType().equals("oracle")){
			sqlwhere += " and d.enddate||' '||decode(d.endtime,'', '00:00',d.endtime) < '" +  currentTime + "' ";
		}else{
			sqlwhere += " and d.enddate+' '+(CASE d.endtime WHEN '' then '00:00' ELSE d.endtime END) < '" +  currentTime + "' ";
		}
		sqlwhere += " and w.status = '0' ";
		break;
	case 3:
		sqlwhere += " and w.status in ('1', '2') ";
		break;
	case 5:
		sqlwhere += " and w.status = '0' ";
		break;
}


%>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(780,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow: hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
		
			<input type="text" class="searchInput" id="t_name" name="t_name" value=""  />
			
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span class="toggleLeft" id="toggleLeft" onclick="toggleLeft()" title="<%=SystemEnv.getHtmlLabelName(18890,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(19652,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(17871,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(26505,user.getLanguage()) %></span>
		<span id="hoverBtnSpan" class="hoverBtnSpan">
			
	</span>
</div>

<div class="advancedSearchDiv" id="advancedSearchDiv">


<FORM id=weaverA name=weaverA action="MeetingDecision.jsp" method=post  >
<input type="hidden" value="0" name="deciScope" id="deciScope">
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
			<!-- 任务标题 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(32865, user.getLanguage())%></wea:item>
			<wea:item>
				<input type="text" class=inputstyle id="subjects" name="subjects"  style="width:60%" value="<%if(!subjects.equals("")){%><%=Util.forHtml(subjects)%><%}%>">
			</wea:item>
			<!-- 负责人 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(2097, user.getLanguage())%></wea:item>
            <wea:item>
				<%
				String hrmid01span = "";
				if(!hrmid01s.equals("")){
				
					hrmid01span +="<a href=\'javascript:openhrm("+ hrmid01s+")\' onclick=\'pointerXY(event)\'>"+ResourceComInfo.getResourcename(""+hrmid01s)+"</a>&nbsp";
				}%>
                <brow:browser viewType="0" name="hrmid01s" browserValue='<%=hrmid01s%>' 
                browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"%>'
                hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' width="200px"
                completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
                browserSpanValue='<%=ResourceComInfo.getResourcename(""+hrmid01s)%>'></brow:browser>
			</wea:item>
			<!-- 检查人 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(2173, user.getLanguage())%></wea:item>
            <wea:item>
          	<%
          	   String hrmid02span = "";
          	   if(!hrmid02s.equals("")){
				ArrayList hrmid02sa = Util.TokenizerString(hrmid02s,",");
				for(int i=0;i<hrmid02sa.size();i++){

				//hrmid02span +="<a href=\'javascript:openhrm("+ hrmid02sa.get(i)+")\' onclick=\'pointerXY(event)\'>"+ResourceComInfo.getResourcename(""+hrmid02sa.get(i))+"</a>&nbsp";
                hrmid02span += ResourceComInfo.getResourcename(""+hrmid02sa.get(i))+",";
                }}%>
				<brow:browser viewType="0" name="hrmid02s" browserValue='<%=hrmid02s%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="200px"
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
				browserSpanValue='<%= hrmid02span %>'></brow:browser>

			</wea:item>
			<!-- 相关会议 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(926, user.getLanguage())%></wea:item>
			<wea:item>
				<input type="text" class=inputstyle id="mtnames" name="mtnames"  style="width:60%" value="<%if(!mtnames.equals("")){%><%=Util.forHtml(mtnames)%><%}%>">
			</wea:item>
		  
			<!-- 会议类型 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("1")), user.getLanguage())%></wea:item>
			<wea:item>
			<%String meetingTypename = "";
		    if(!"".equals(meetingtypes)){
		    	rs.executeSql("select name from Meeting_Type where id in ("+meetingtypes+")");
		    	while(rs.next()){
		    		meetingTypename += Util.null2String(rs.getString("name"))+",";
		    	}
		    }
			%>
			<brow:browser viewType="0" name="meetingtypes" browserValue='<%= ""+meetingtypes %>' 
                browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MutiMeetingTypeBrowser.jsp?forall=1"
                isSingle="true" hasBrowser = "true" isMustInput='1' 
                completeUrl="/data.jsp?type=89&forall=1" width="200px" 
				hasInput='true'
                browserSpanValue='<%=meetingTypename %>' >
        		</brow:browser>

			</wea:item>
		  
			<!-- 会议召集人 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("3")), user.getLanguage())%></wea:item>
			<wea:item>
          	<%
          	   String callerspan = "";
          	   if(!callers.equals("")){
				ArrayList callersa = Util.TokenizerString(callers,",");
				for(int i=0;i<callersa.size();i++){

				//callerspan +="<a href=\'javascript:openhrm("+ callersa.get(i)+")\' onclick=\'pointerXY(event)\'>"+ResourceComInfo.getResourcename(""+callersa.get(i))+"</a>&nbsp";
                callerspan += ResourceComInfo.getResourcename(""+callersa.get(i))+",";
                }}%>
				<brow:browser viewType="0" name="callers" browserValue='<%=callers%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="200px"
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
				browserSpanValue='<%= callerspan %>'></brow:browser>

			</wea:item>
			<!-- 任务状态 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(22074, user.getLanguage())%></wea:item>
			<wea:item>
				<select class=inputstyle size="1" name="statuss" id="statuss" style="width:100px">
					<option value="0" <%=(statuss==0||"".equals(statuss))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
					<option value="1" <%=(statuss==1)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1979, user.getLanguage())%></option>
					<option value="2" <%=(statuss==2)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1960, user.getLanguage())%></option>
					<option value="3" <%=(statuss==3)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1961, user.getLanguage())%></option>
					<option value="4" <%=(statuss==4)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32556, user.getLanguage())%></option>
					<option value="5" <%=(statuss==5)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(16349, user.getLanguage())%></option>
				</select>
			</wea:item>
			<!-- 任务时间 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())+(user.getLanguage() == 8?" ":"")+SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
			<wea:item>
                <span>
					<select name="timeSag" id="timeSag" onchange="changeDate(this,'decisionDate');" style="width:100px;">
						<option value="0" <%=(timeSag==0||"".equals(timeSag))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						<option value="1" <%=timeSag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
						<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
						<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
						<option value="4" <%=timeSag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
						<option value="5" <%=timeSag==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
						<option value="6" <%=timeSag==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
					</select>
				</span>
				<span id="decisionDate"  style="<%=timeSag==6?"":"display:none;" %>">
					<button type="button" class=calendar id=SelectDate onClick="getDate(begindate1span,begindate1)"></button>&nbsp;
					<span id=begindate1span><%=begindate1 %></span>
					-&nbsp;&nbsp;
					<button type="button" class=calendar id=SelectDate2 onClick="getDate(enddate1span,enddate1)"></button>&nbsp;
					<span id="enddate1span" ><%=enddate1%></span>
					<input type="hidden" name="begindate1" id="begindate1" value="<%=begindate1 %>">
					<input type="hidden" name="enddate1" id="enddate1" value="<%=enddate1%>"> 
				</span>
			</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</FORM>
</div>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.MT_MeetingDecision%>"/>
<%String orderby =" w.status,d.enddate desc, d.endtime desc,d.id  ";
String tableString = "";
int perpage=10;
                  
String backfields = " d.id,d.meetingid meetingid,d.subject,d.hrmid01,d.hrmid02,d.begindate+' '+d.begintime as begint,d.enddate+' '+d.endtime as endt, d.enddate, d.endtime, m.name name,w.status,w.createrid ";
if(rs.getDBType().equals("oracle")){
	backfields = " d.id,d.meetingid meetingid,d.subject,d.hrmid01,d.hrmid02,d.begindate||' '||d.begintime as begint,d.enddate||' '||d.endtime as endt, d.enddate, d.endtime, m.name name,w.status,w.createrid ";
}
String fromSql  = " Meeting_Decision d, WorkPlan w, Meeting m ";
String whereSql = " WHERE d.meetingid = m.id AND w.meetingid = convert(VARCHAR(100), m.id) AND d.subject = w.name AND d.hrmid01 = w.resourceid " + sqlwhere;
String para1 = "column:begint+column:endt+"+user.getLanguage()+"+"+currentTime;
if(rs.getDBType().equals("oracle")){
	whereSql = " WHERE d.meetingid = m.id AND w.meetingid = to_char(m.id) AND d.subject = w.name AND d.hrmid01 = w.resourceid " + sqlwhere;
}
tableString =   " <table instanceid=\"\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.MT_MeetingDecision,user.getUID())+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlwhere=\""+Util.toHtmlForSplitPage(whereSql)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"d.id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
                "       <head>" +
                "           <col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(32865, user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\" />"+
                "           <col width=\"10%\"  text=\""+ SystemEnv.getHtmlLabelName(2097, user.getLanguage())+"\" column=\"hrmid01\" orderkey=\"hrmid01\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingMultResource\" />"+
                "           <col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(2173, user.getLanguage())+"\" column=\"hrmid02\" orderkey=\"hrmid02\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
                "           <col width=\"14%\"  text=\""+ SystemEnv.getHtmlLabelName(742, user.getLanguage())+"\" column=\"begint\" orderkey=\"begint\"  />"+
                "			<col width=\"18%\"  text=\""+ SystemEnv.getHtmlLabelName(743, user.getLanguage())+"\" column=\"endt\" orderkey=\"endt\" />"+
                "			<col width=\"10%\"  text=\""+ SystemEnv.getHtmlLabelName(926, user.getLanguage())+"\" column=\"meetingid\" orderkey=\"name\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingName\" />"+
                "			<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(25005,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" otherpara=\""+para1+"\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDecisionStatus\" />"+
                "       </head>"+
			    "		<operates>"+
                "		<popedom column=\"id\" otherpara=\"column:hrmid01+column:hrmid02+column:createrid+column:status+"+allUser+"\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.checkMeetingDecisionOpt\"></popedom> "+
                "		<operate otherpara=\"column:createrid+column:meetingid+column:hrmid02\" href=\"javascript:done();\" text=\""+SystemEnv.getHtmlLabelName(555, user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		</operates>"+              
                " </table>";
%>
	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />

</body>
</html>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript">
var diag_vote;

function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	doSearchsubmit();
}

function clickTab(obj){
	jQuery("#statuss").val(jQuery(obj).attr("val"));
	jQuery("#statuss").trigger("change");
	doSearchsubmit();
}

function doSearchsubmit(){
	$('#weaverA').submit();
}


function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}


//$(".searchImg").bind("click",function(){
//     onBtnSearchClick();
//});

function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("input[name='subjects']").val(name);
	doSearchsubmit();
}

function done(id,para){
	var allUser = '<%=allUser%>';
	var allUserArr = allUser.split(",");
	var paraArr = para.split("\+")
	var createrid = paraArr[0];
	var meetingid = paraArr[1];
	var hrmid02 = paraArr[2];
	var isBelongs = false;
	var msg = '';
	for(var i=0;i<allUserArr.length;i++){
		if(allUserArr[i]!='' && allUserArr[i] == createrid){
			isBelongs = true;
			break;
		}
	}
	if(allUser==createrid || isBelongs){
		$.post("/meeting/data/MeetingDecisionOperation.jsp",{method:"overCalendarItem",id:id,meetingid:meetingid},function(datas){
			doSearchsubmit();
		});
	}else{
		hrmid02 = hrmid02.replace(/(^\s*)|(\s*$)/g, "");
		if(hrmid02 == ''){
			msg = '<%=SystemEnv.getHtmlLabelName(131724,user.getLanguage())%>'
		}else{
			msg = '<%=SystemEnv.getHtmlLabelName(131713,user.getLanguage())%>'
		}
		Dialog.confirm(msg, function (){
				$.post("/meeting/data/MeetingDecisionOperation.jsp",{method:"overCalendarItem",id:id,meetingid:meetingid},function(datas){
					doSearchsubmit();
				});
			}, function(){}, 320, 90,false);
	}
	
}
</script>
