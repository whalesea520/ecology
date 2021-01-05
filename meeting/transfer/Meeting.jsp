
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- added by wcd 2014-09-12 [下属] -->
<%@ include file="/hrm/header.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="MeetingSearchComInfo" class="weaver.meeting.search.SearchComInfo" scope="page" />
<jsp:setProperty name="MeetingSearchComInfo" property="name" param="names"/>
<jsp:setProperty name="MeetingSearchComInfo" property="timeSag" param="timeSag"/>
<jsp:setProperty name="MeetingSearchComInfo" property="meetingStartdatefrom" param="meetingStartdatefrom"/>
<jsp:setProperty name="MeetingSearchComInfo" property="meetingStartdateto" param="meetingStartdateto"/>
<jsp:useBean id="authorityManager" class="weaver.hrm.authority.manager.AuthorityManager" scope="page"/>
<%
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(442,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	boolean isHidden="true".equalsIgnoreCase(Util.null2String(request.getParameter("isHidden"))); 
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String fromid=Util.null2String(request.getParameter("fromid"));
	String toid=Util.null2String(request.getParameter("toid"));
	String _type = Util.null2String(request.getParameter("type"));
	String selectedstrs = Util.null2String(request.getParameter("idStr"));
	String isAll = Util.null2String(request.getParameter("isAll"));
	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
	String oldJson = jsonSql;
	jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");
	
	int timeSag = Util.getIntValue(request.getParameter("timeSag"),0);
	MeetingSearchComInfo.setTimeSag(timeSag);
	
	Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
    
    //构建where语句
    String SqlWhere1 = MeetingSearchComInfo.FormatSQLSearch(user.getLanguage())  ;  
  	
    if("".equals(SqlWhere1)){
    	SqlWhere1+=" where 1=1 ";
    }
  	//正常会议 
    SqlWhere1 +=" and t1.meetingstatus=2 and enddate>='"+CurrentDate+"' and isdecision<>2 ";

%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);


			function doCloseDialog() {
				dialog.close();
			}
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(!isHidden){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",javascript:selectDone(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())+",javascript:selectAll(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="Meeting.jsp" name="searchfrm" id="searchfrm">
			<input type=hidden name="isdialog" value="<%=isDialog%>">
			<input type=hidden name="cmd" value="closeDialog">
			<input type=hidden name="fromid" value="<%=fromid%>">
			<input type=hidden name="toid" value="<%=toid%>">
			<input type=hidden name="type" value="<%=_type%>">
			<input type=hidden name="idStr" value="<%=selectedstrs%>">
			<input type=hidden name="jsonSql" value="<%=Tools.getURLEncode(oldJson)%>">
			<input type=hidden name="isDelType" value="0">
			<input type=hidden name="selectAllSql" value="">
			<input type=hidden name="needExecuteSql" value="0">
			<input type=hidden name="isHidden" value="<%=isHidden %>">
			
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%if(!isHidden){ %>
						<input type=button class="e8_btn_top" onclick="selectDone();" value="<%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%>"></input>
						<input type=button class="e8_btn_top" onclick="selectAll();" value="<%=SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())%>"></input>
						<%} %>
						<input type="text" class="searchInput" name="qname" value="<%=Util.forHtml(MeetingSearchComInfo.getname())%>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<!-- 会议名称 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(2151,user.getLanguage())%></wea:item>
						<wea:item attributes="{'colspan':'full'}">
							<input type="text" class="InputStyle" id="names" name="names"  style="width:60%" value="<%=Util.forHtml(MeetingSearchComInfo.getname())%>">
						</wea:item>
 
						<!-- 会议时间 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())+(user.getLanguage() == 8?" ":"")+SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
						<wea:item attributes="{'colspan':'full'}">
							<span>
								<select name="timeSag" id="timeSag" onchange="changeDate(this,'meetingStartdate');" style="width:100px;">
									<option value="0" <%=timeSag==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
									<option value="1" <%=timeSag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
									<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
									<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
									<option value="4" <%=timeSag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
									<option value="5" <%=timeSag==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
									<option value="6" <%=timeSag==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
								</select>
							</span>
							<span id="meetingStartdate"  style="<%=timeSag==6?"":"display:none;" %>">
								<button type="button" class=calendar id=SelectDate onClick="getDate(meetingStartdatefromspan,meetingStartdatefrom)"></button>&nbsp;
								<span id=meetingStartdatefromspan><%=MeetingSearchComInfo.getMeetingStartdatefrom() %></span>
								-&nbsp;&nbsp;
								<button type="button" class=calendar id=SelectDate2 onClick="getDate(meetingStartdatetospan,meetingStartdateto)"></button>&nbsp;
								<span id="meetingStartdatetospan" ><%=MeetingSearchComInfo.getMeetingStartdateto() %></span>
								<input type="hidden" name="meetingStartdatefrom" id="meetingStartdatefrom" value="<%=MeetingSearchComInfo.getMeetingStartdatefrom() %>">
								<input type="hidden" name="meetingStartdateto" id="meetingStartdateto" value="<%=MeetingSearchComInfo.getMeetingStartdateto() %>"> 
							</span>
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="doSubmit()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion1();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<%
			String backfields = " t1.id,t1.name,t1.meetingstatus,t1.begindate,t1.begintime,t1.enddate,t1.endtime"; 
			String fromSql  = " from meeting t1 ";
			String sqlWhere = " t1.caller = "+fromid+" ";
			//System.out.println(_type);
			if("C151IdStr".equalsIgnoreCase(_type)||"T152IdStr".equalsIgnoreCase(_type)||"D131IdStr".equals(_type)){//参与人
				if(rs.getDBType().equals("oracle")){
					fromSql=" from meeting t1 ,(select meetingid from Meeting_Member2 where memberid="+fromid+" or ','||othermember||',' like '%,"+fromid+",%') t2";
				}else{
					fromSql=" from meeting t1 ,(select meetingid from Meeting_Member2 where memberid="+fromid+" or ','+othermember+',' like '%,"+fromid+",%') t2";
				}
				sqlWhere=" t1.id=t2.meetingid ";
			}
			 
			sqlWhere=SqlWhere1+" and "+sqlWhere;
			
			String orderby = " t1.enddate,t1.endtime ,t1.id " ;
			 
			String operateString= "";
			String tableString =" <table pageId=\""+PageIdConst.MT_TRANSFER_LIST+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.MT_TRANSFER_LIST,user.getUID())+"\" tabletype=\""+(isHidden?"none":"checkbox")+"\">"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
				operateString+
			"	<head>"+
			" 	    <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(2151,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingName\" otherpara=\"column:id+column:status\" />"+
	        "		<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"meetingstatus\" otherpara=\""+user.getLanguage()+"+column:endDate+column:endTime+column:isdecision\" orderkey=\"meetingstatus\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingStatus\" />"+
		 	"		<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"begindate\"  orderkey=\"begindate,begintime\" otherpara=\"column:begintime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
	 		"		<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"enddate\"  orderkey=\"enddate,endtime\" otherpara=\"column:endtime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
			"	</head>"+
			" </table>";

			StringBuilder _sql = new StringBuilder();
			_sql.append("select ").append(backfields).append(fromSql).append(sqlWhere);
			rs.executeSql("select count(1) as count from (" + _sql.toString() + ") temp");
			long count = 0;
			if (rs.next()){
				count = Long.parseLong(Util.null2String(rs.getString("count"), "0"));
			}
			
			String tempSql = strUtil.encode(_sql.toString());
			_sql.setLength(0);
			_sql.append(tempSql);
			MJson mjson = new MJson(oldJson, true);
			if(mjson.exsit(_type)) {
				selectedstrs = authorityManager.getData("id", strUtil.decode(mjson.getValue(_type)));
				mjson.updateArrayValue(_type, _sql.toString());
			} else {
				if(Boolean.valueOf(isAll).booleanValue()) selectedstrs = authorityManager.getData("id", strUtil.decode(_sql.toString()));
				mjson.putArrayValue(_type, _sql.toString());
			}
 
			String oJson = Tools.getURLEncode(mjson.toString());
			mjson.removeArrayValue(_type);
			String nJson = Tools.getURLEncode(mjson.toString());
		%>
		<script>
			$GetEle("selectAllSql").value = encodeURI("<%=_sql.toString()%>");
		</script>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' selectedstrs="<%=selectedstrs%>" mode="run" /> 
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.close();">
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
	<script type="text/javascript">
		function selectDone(id){
			if(!id){
				id = _xtable_CheckedCheckboxId();
			}
			if(!id){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
				return;
			}
			if(id.match(/,$/)){
				id = id.substring(0,id.length-1);
			}
			//window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>",function(){
			//	if (dialog) {
			//		var data = {
			//			type: '<%=_type%>',
			//			isAll: false,
			//			id: id,
			//			json: '<%=nJson%>'
			//		};
			//		dialog.callback(data);
			//		doCloseDialog();
			//	}
			//});
			if (dialog) {
				var data = {
					type: '<%=_type%>',
					isAll: false,
					id: id,
					json: '<%=nJson%>'
				};
				dialog.callback(data);
				doCloseDialog();
			}
		}

		function selectAll(){
			//window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>",function(){
			//	if (dialog) {
			//		var data = {
			//			type: '<%=_type%>',
			//			isAll: true,
			//			count: <%=count%>,
			//			json: '<%=oJson%>'
			//		};
			//		dialog.callback(data);
			//		doCloseDialog();
			//	}
			//});
			if (dialog) {
				var data = {
					type: '<%=_type%>',
					isAll: true,
					count: <%=count%>,
					json: '<%=oJson%>'
				};
				dialog.callback(data);
				doCloseDialog();
			}
		}
		var diag_vote;
		function closeDialog(){
			diag_vote.close();
		}
		
		function closeDlgARfsh(){
			diag_vote.close();
			doSubmit();
		}
		
		function dataRfsh(){
			doSubmit();
		}

		function view(id)
		{
			if(id!="0" && id !=""){
				if(window.top.Dialog){
					diag_vote = new window.top.Dialog();
				} else {
					diag_vote = new Dialog();
				}
				diag_vote.currentWindow = window;
				diag_vote.Width = 800;
				diag_vote.Height = 550;
				diag_vote.Modal = true;
				diag_vote.maxiumnable = true;
				diag_vote.checkDataChange = false;
				diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>";
				diag_vote.URL = "/meeting/data/ViewMeetingTab.jsp?meetingid="+id;
				diag_vote.show();
			}
		}
		
		function onBtnSearchClick(){
			var name=$("input[name='qname']",parent.document).val();
			$("#names").val(name);
			$('#searchfrm').submit();
		}
		
		function doSubmit(){
			$('#searchfrm').submit();
		} 
 
/**
*清空搜索条件
*/
function resetCondtion1() {
	//清空文本框
	jQuery("#advancedSearchDiv").find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery("#advancedSearchDiv").find(".Browser").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_outScroll .e8_innerShow span").html("");
	//清空下拉框
	jQuery("#timeSag").val("0");
	jQuery("#timeSag").trigger("change");
	jQuery("#timeSag").selectbox("detach");
	jQuery("#timeSag").selectbox("attach");
	
	jQuery("#meetingstatus").val("");
	jQuery("#meetingstatus").trigger("change");
	jQuery("#meetingstatus").selectbox('detach');
	jQuery("#meetingstatus").selectbox('attach');
	//清空日期
	jQuery("#advancedSearchDiv").find(".calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".calendar").siblings("input[type='hidden']").val("");
}
jQuery(document).ready(function () {
	if (typeof onBtnSearchClick != "undefined" && onBtnSearchClick instanceof Function) {
		jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	}
	jQuery(".topMenuTitle td:eq(0)").html(jQuery("#tabDiv").html());
	jQuery("#tabDiv").remove();
	jQuery("#hoverBtnSpan").hoverBtn();


});
function changeDate(obj, id, val) {
	if (val == null) {
		val = "6";
	}
	if (obj.value == val) {
		jQuery("#" + id).show();
	} else {
		jQuery("#" + id).hide();
		jQuery("#" + id).siblings("input[type='hidden']").val("");
	}
}
		
	</script>
	</body>
</html>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
