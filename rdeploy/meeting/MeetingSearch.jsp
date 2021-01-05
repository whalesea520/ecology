<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>
<%@ page import="java.sql.Timestamp" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<%@page import="weaver.general.TimeUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.rdeploy.portal.PortalUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingSearchComInfo" class="weaver.meeting.search.SearchComInfo" scope="page" />
<jsp:setProperty name="MeetingSearchComInfo" property="name" param="names"/>
<jsp:setProperty name="MeetingSearchComInfo" property="meetingtype" param="meetingtype"/>
<jsp:setProperty name="MeetingSearchComInfo" property="address" param="address"/>
<jsp:setProperty name="MeetingSearchComInfo" property="begindate" param="begindate"/>
<jsp:setProperty name="MeetingSearchComInfo" property="enddate" param="enddate"/>
<jsp:setProperty name="MeetingSearchComInfo" property="callers" param="callers"/>
<jsp:setProperty name="MeetingSearchComInfo" property="callersDep" param="callersDep"/>
<jsp:setProperty name="MeetingSearchComInfo" property="callersSub" param="callersSub"/>
<jsp:setProperty name="MeetingSearchComInfo" property="contacters" param="contacters"/>
<jsp:setProperty name="MeetingSearchComInfo" property="contactersDep" param="contactersDep"/>
<jsp:setProperty name="MeetingSearchComInfo" property="contactersSub" param="contactersSub"/>
<jsp:setProperty name="MeetingSearchComInfo" property="creaters" param="creaters"/>
<jsp:setProperty name="MeetingSearchComInfo" property="creatersDep" param="creatersDep"/>
<jsp:setProperty name="MeetingSearchComInfo" property="creatersSub" param="creatersSub"/>
<jsp:setProperty name="MeetingSearchComInfo" property="hrmids" param="hrmids"/>
<jsp:setProperty name="MeetingSearchComInfo" property="crmids" param="crmids"/>
<jsp:setProperty name="MeetingSearchComInfo" property="projectid" param="projectid"/>
<jsp:setProperty name="MeetingSearchComInfo" property="timeSag" param="timeSag"/>
<jsp:setProperty name="MeetingSearchComInfo" property="meetingStartdatefrom" param="meetingStartdatefrom"/>
<jsp:setProperty name="MeetingSearchComInfo" property="meetingStartdateto" param="meetingStartdateto"/>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    
    /*用户验证*/
    User user = HrmUserVarify.getUser (request , response) ;
    if(user==null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }
    String userid = ""+user.getUID();
	//是否重复会议
	int isInterval = Util.getIntValue(request.getParameter("isInterval"), 0);
	//是否初次加载
	int isFirst = Util.getIntValue(request.getParameter("isFirst"), 1);
	//重复会议不用判断是否初次加载
	if(isInterval == 1 ){
		isFirst = 0;
	}
	int repeatType = Util.getIntValue(request.getParameter("repeatType"),0);
	int timeSag = Util.getIntValue(request.getParameter("timeSag"),0);
	MeetingSearchComInfo.setTimeSag(timeSag);
	 
	String meetingstatusArray[]=request.getParameterValues("meetingstatus");
	String meetingstatus="";
	String mstatus1="";//用来区分会议状态：正常和结束
	String mstatus2="";
	if(meetingstatusArray != null)
	{
		for(int i=0;i<meetingstatusArray.length;i++)
		{
		   if(!meetingstatusArray[i].equals("5")){
			meetingstatus +=","+meetingstatusArray[i];
		     if(meetingstatusArray[i].equals("2"))
		        mstatus2=meetingstatusArray[i];
		  }else{ 
		   	meetingstatus +=","+2;
			mstatus1=meetingstatusArray[i];
			}
		}
		if(!"".equals(meetingstatus)){
			meetingstatus = meetingstatus.substring(1);
		}
		MeetingSearchComInfo.setmeetingstatus(meetingstatus);
	}
	
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17625, user.getLanguage());
	String needfav ="1";
	String needhelp ="";

    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
    
    String meetingTypename = "";
    
    if(!"".equals(MeetingSearchComInfo.getmeetingtype())){
    	rs.executeSql("select name from Meeting_Type where id in ("+MeetingSearchComInfo.getmeetingtype()+")");
    	while(rs.next()){
    		meetingTypename += Util.null2String(rs.getString("name"))+",";
    	}
    	if(!"".equals(meetingTypename)){
    		meetingTypename = meetingTypename.substring(0,meetingTypename.length() - 1);
    	}
    }
	
	if(isInterval == 1){
		MeetingSearchComInfo.setTimeSag(0);
	}
	
    //构建where语句
    String SqlWhere = MeetingSearchComInfo.FormatSQLSearch(user.getLanguage())  ;  
    String allUser=MeetingShareUtil.getAllUser(user);
    
    if(!SqlWhere.equals(""))
	{
		SqlWhere +=" AND (";
	}
	else
	{
		SqlWhere =" WHERE (";
	}
	if(isInterval != 1){
		SqlWhere +=" (t1.id = t2.meetingId) AND ";
		//待审批，审批退回的会议，召集人 联系人 创建人  审批人都可以看
		SqlWhere +=" ((t1.meetingStatus in (1, 3) AND t2.userId in (" + allUser + ") AND t2.shareLevel in (1,4))" ;
		//草稿中的创建人可以看见
		SqlWhere +=" OR (t1.meetingStatus = 0 AND (t1.creater in (" + allUser + ")) AND (t2.userId in (" + allUser + ")) ) ";
		//正常和取消的会议所有参会人员都可见
		SqlWhere +=" OR (t1.meetingStatus IN (2, 4) AND (t2.userId in (" + allUser + "))))";
		SqlWhere +=")";
	} else {
	   //重复会议只有召集人，创建人，和联系人可以看见
		SqlWhere +="( t1.creater=" + userid + " or ((t1.caller in("+ allUser + ") or t1.contacter  in("+ allUser +")) and t1.meetingStatus = 2 ) ) ";
		SqlWhere +=")";
	}
	
	//过滤重复会议
	if(isInterval == 1){
		if(repeatType > 0){
			SqlWhere +=" and t1.repeatType = "+repeatType;
		} else {
			SqlWhere +=" and t1.repeatType > 0 ";
		}
		//重复会议时间
		if(timeSag > 0&&timeSag<6){
			String doclastmoddatefrom = TimeUtil.getDateByOption(""+timeSag,"0");
			String doclastmoddateto = TimeUtil.getDateByOption(""+timeSag,"1");
			if(!doclastmoddatefrom.equals("")){
				SqlWhere += " and t1.repeatenddate >= '" + doclastmoddatefrom + "'";
			}
			
			if(!doclastmoddateto.equals("")){
				SqlWhere += " and t1.repeatbegindate <= '" + doclastmoddateto + "'";
			}
			
		}else{
			if(timeSag==6){//指定时间
				if(!"".equals(MeetingSearchComInfo.getMeetingStartdatefrom())){
					SqlWhere += " and t1.repeatenddate >= '" + MeetingSearchComInfo.getMeetingStartdatefrom() + "'";
				}
				
				if(!"".equals(MeetingSearchComInfo.getMeetingStartdateto())){
					SqlWhere += " and t1.repeatbegindate <= '" + MeetingSearchComInfo.getMeetingStartdateto() + "'";
				}
				
			}
			
		}
	} else {
		SqlWhere +=" and t1.repeatType = 0 ";
	}
    
    if(mstatus1.equals("5")&&!mstatus2.equals("2")){
      SqlWhere +=" and ( enddate<'"+CurrentDate+"' or (endDate = '"+CurrentDate+"' AND endTime < '"+CurrentTime+"') or isdecision=2) ";
    }
    if(mstatus2.equals("2")&&!mstatus1.equals("5")){
      SqlWhere +=" and ( enddate>'"+CurrentDate+"' or (endDate = '"+CurrentDate+"' AND endTime >= '"+CurrentTime+"')) and isdecision<>2 ";
    }

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">

		<title></title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
		<script type="text/javascript" src="/rdeploy/assets/js/jquery.enplaceholder_wev8.js"></script>
		<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
		<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" rel="stylesheet" type="text/css">
		<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" rel="stylesheet" type="text/css">
		
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
		
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		
		<link rel="stylesheet" type="text/css" href="/js/poshytip-1.2/tip-yellowsimple/tip-yellowsimple_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/search.css" />
		
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
		
		
		<!-- 日历控件 -->
		<link href="/wui/common/jquery/plugin/daterangepicker/bootstrap.min.css" rel="stylesheet">
      	
      	<link rel="stylesheet" type="text/css" media="all" href="/wui/common/jquery/plugin/daterangepicker/daterangepicker-bs3.css" />
	  	<link rel="stylesheet" type="text/css" media="all" href="/wui/common/jquery/plugin/daterangepicker/daterangepicker-bs4.css" />
      	<script type="text/javascript" src="/wui/common/jquery/plugin/daterangepicker/bootstrap.min.js"></script>
      	<script type="text/javascript" src="/wui/common/jquery/plugin/daterangepicker/moment.js"></script>
      	<script type="text/javascript" src="/wui/common/jquery/plugin/daterangepicker/daterangepicker.js"></script>
		
		<script>
			$(function () {
				$("#names")[0].focus();
				//$('input').placeholder({isUseSpan:true});
				__jNiceNamespace__.beautySelect();
				$("span[id^=sbHolderSpan_]").css("max-width", "95%");
				
				$("#date").daterangepicker({separator : " - "}, function(start, end, label) {
                    //console.log(start, end, label);
                    $("#meetingStartdatefrom").val(start);
                    $("#meetingStartdateto").val(end);
                });
                
                $(".rowtitle").on("click", function (e) {
                	var inputobj = $(this).next().children("input");
                	var sltobj = $(this).next().children("span[id^=sbHolderSpan_]").find("[id^=sbToggle_]");
                	var browobj = $(this).next().find("div[id^=inner][id$=div]");
                	if (!!browobj[0]) {
                		browobj[0].click();
                	}
                	inputobj.trigger("focus");
                	sltobj.trigger("click");
                	if (!!inputobj[0]) {
                		inputobj[0].click();
                	}
                	e.stopPropagation();
                });
			});
			
			function doSearch() {
				/*
				if (!checkDateValid("begindate", "enddate")) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(54,user.getLanguage())%>");
					return;
				}
				*/
				document.frmmain.submit();
			}
			
			
			/**
			*清空搜索条件
			*/
			function resetCondtionAVS(){
				$("#meetingStartdatefrom, #meetingStartdateto").val("");
				$("select").val("");
				$("select").trigger("change");
				$("select").selectbox('detach');
				$("select").selectbox('attach');
				$("span[id^=sbHolderSpan_]").css("max-width", "95%");
				//清空文本框
				$("input[type='text']").val("");
				//清空浏览按钮及对应隐藏域
				$(".Browser").siblings("span").html("");
				$(".Browser").siblings("input[type='hidden']").val("");
				$(".e8_os").find("input[type='hidden']").val("");
				$(".e8_outScroll .e8_innerShow span").html("");
				
				$("#names")[0].focus();
				
			}
		</script>
	</head>

	<body style="margin:0px;padding:0px;">
	
	<FORM id="frmmain" name="frmmain" method="post" action="/meeting/search/MeetingSearch.jsp">
		<input type="hidden" name="isFirst" id="isFirst" value="0"/>
		<input type="hidden" name="simpleSearch" id="isFirst" value="1"/>
		<input type="hidden" name="simpleSearch" id="isFirst" value="1"/>
		<input type="hidden" name="timeSag" id="isFirst" value="6"/>
		<div id="content" style="position:absolute;left:50%;width:560px;margin-top:33px;margin-left:-280px;">
			

			<div class="rowbock rowwidth1">
				<span class="rowtitle">会议名称</span>
				<div class="rowinputblock rowinputblockleft2">
					<input type="text" class="rowinputtext" id="names" name="names"  style="width:60%" value="<%=Util.forHtml(MeetingSearchComInfo.getname())%>">
				</div>
			</div>
			<div class="searchline"></div>
			
			<div class="rowbock rowwidth1">
				<span class="rowtitle">会议类型</span>
				<div class="rowinputblock rowinputblockleft2 rowinputblock-brow-ie8">
					<brow:browser viewType="0" name="meetingtype" browserValue="<%=MeetingSearchComInfo.getmeetingtype() %>" 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MutiMeetingTypeBrowser.jsp?forall=1&resourceids="
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px"
					completeUrl="/data.jsp?type=89&forall=1" linkUrl="/meeting/Maint/ListMeetingType.jsp?id=#id#" 
					browserSpanValue="<%=meetingTypename %>"></brow:browser>
				</div>
			</div>
			<div class="searchline"></div>
			
			
			<div class="rowbock rowwidth1">
				<span class="rowtitle">召集人</span>
				<div class="rowinputblock rowinputblockleft4 rowinputblock-brow-ie8">
					<%
				   String callersSpan = "";
				   if(!"".equals(MeetingSearchComInfo.getcallers())){
					ArrayList callersl = Util.TokenizerString(MeetingSearchComInfo.getcallers(),",");
					for(int i=0;i<callersl.size();i++){
					callersSpan +=ResourceComInfo.getResourcename(""+callersl.get(i))+",";
					}}%>
					<brow:browser viewType="0" name="callers" browserValue="<%=MeetingSearchComInfo.getcallers()%>" 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="300px"
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
					browserSpanValue="<%= callersSpan %>"></brow:browser>
				</div>
			</div>
			<div class="searchline"></div>
			
			<div class="rowbock rowwidth1">
				<span class="rowtitle">创建人</span>
				<div class="rowinputblock rowinputblockleft4 rowinputblock-brow-ie8">
					<%
					   String creatersSpan = "";
					   if(!"".equals(MeetingSearchComInfo.getcreaters())){
						ArrayList ids = Util.TokenizerString(MeetingSearchComInfo.getcreaters(),",");
						for(int i=0;i<ids.size();i++){
						//creatersSpan +="<a href=\'javascript:openhrm("+ ids.get(i)+")\' onclick=\'pointerXY(event)\'>"+ResourceComInfo.getResourcename(""+ids.get(i))+"</a>&nbsp";
						creatersSpan +=ResourceComInfo.getResourcename(""+ids.get(i))+",";
						}}%>
						<brow:browser viewType="0" name="creaters" browserValue="<%=MeetingSearchComInfo.getcreaters()%>" 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="300px"
						completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
						browserSpanValue="<%= creatersSpan %>"></brow:browser>
				</div>
			</div>
			<div class="searchline"></div>
			
			<div class="rowbock2cell">
				<table width="100%" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="237px"><col width="20px"><col width="*">
					</colgroup>
					<tr>
						<td>
							<div class="rowbock rowwidth2" style="float:left;">
								<span class="rowtitle" style="cursor:pointer;">会议状态</span>
								<div class="rowinputblock rowinputblockleft2 rowinputblock-brow-ie8">
									<select name="meetingstatus" id="meetingstatus" style="width:100%;">
										<option value="" <%=meetingstatus.equals("")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
										<option value="0" <%=meetingstatus.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
										<option value="1" <%=meetingstatus.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%></option>
										<option value="2" <%=meetingstatus.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
										<option value="3" <%=meetingstatus.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1010,user.getLanguage())%></option>
										<option value="4" <%=meetingstatus.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(20114,user.getLanguage())%></option>
										<option value="5" <%=meetingstatus.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
									</select>
								</div>
							</div>
						</td>
						<td></td>
						<td>
							<div class="rowbock rowwidth2" style="float:left;">
								<span class="rowtitle" style="cursor:pointer;">会议时间</span>
								<div class="rowinputblock rowinputblockleft2">
									<input class="rowinputtext" type="text" id="date" readonly="readonly" style="cursor:pointer;">
									<INPUT type="hidden" name="meetingStartdatefrom" id="meetingStartdatefrom" value="">  
								    <INPUT type="hidden" name="meetingStartdateto" id="meetingStartdateto" value="">
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
			
			
			<div style="width:495px;margin-top:40px;">
				<span class="searchbtn searchbtn_cl" onclick="resetCondtionAVS()">
					重 置
				</span>
				
				<span class="searchbtn searchbtn_rht" onclick="doSearch();">
					搜 索		
				</span>
			</div>
		</div>
		
		</FORM>
		
	</body>
</html>
