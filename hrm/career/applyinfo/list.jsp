
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-06-16 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="HrmCareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page" />
<%
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String Name = Util.null2String(request.getParameter("Name"));
	String careerinvite = Util.null2String(request.getParameter("careerinvite"));
	String jobtitle = Util.null2String(request.getParameter("jobtitle"));
	String createdate = Util.null2String(request.getParameter("createdate"));
	String FromDate = Util.null2String(request.getParameter("FromDate"));
	String EndDate = Util.null2String(request.getParameter("EndDate"));
	String CareerAgeFrom = Util.null2String(request.getParameter("CareerAgeFrom"));
	String CareerAgeTo = Util.null2String(request.getParameter("CareerAgeTo"));
	String EducationLevel = Util.null2String(request.getParameter("EducationLevel"));
	String Sex = Util.null2String(request.getParameter("Sex"));
	String Category = Util.null2String(request.getParameter("Category"));
	String MaritalStatus = Util.null2String(request.getParameter("MaritalStatus"));
	String SalaryNowFrom = Util.null2String(request.getParameter("SalaryNowFrom"));
	String SalaryNowTo = Util.null2String(request.getParameter("SalaryNowTo"));
	String RegResidentPlace = Util.null2String(request.getParameter("RegResidentPlace"));
	String WorkTimeFrom = Util.null2String(request.getParameter("WorkTimeFrom"));
	String WorkTimeTo = Util.null2String(request.getParameter("WorkTimeTo"));
	String Major = Util.null2String(request.getParameter("Major"));
	String SalaryNeedFrom = Util.null2String(request.getParameter("SalaryNeedFrom"));
	String SalaryNeedTo = Util.null2String(request.getParameter("SalaryNeedTo"));
	String oldjob = Util.null2String(request.getParameter("oldjob"));
	String Degree = Util.null2String(request.getParameter("Degree"));
	String School = Util.null2String(request.getParameter("School"));
	String Company = Util.null2String(request.getParameter("Company"));
	String Policy = Util.null2String(request.getParameter("Policy"));
	String NativePlace = Util.null2String(request.getParameter("NativePlace"));
	String ResidentPlace = Util.null2String(request.getParameter("ResidentPlace"));
	String HeightFrom = Util.null2String(request.getParameter("HeightFrom"));
	String HeightTo = Util.null2String(request.getParameter("HeightTo"));
	String Train = Util.null2String(request.getParameter("Train"));
	String DefaultLanguage = Util.null2String(request.getParameter("DefaultLanguage"));
	
	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
	int currentyear=today.get(Calendar.YEAR); 
	HrmCareerApplyComInfo.setCareerInvite(careerinvite);
	HrmCareerApplyComInfo.setFromDate(FromDate);
	HrmCareerApplyComInfo.setEndDate(EndDate);
	HrmCareerApplyComInfo.setName(Name) ;	/*??*/
	HrmCareerApplyComInfo.setJobTitle(jobtitle) ;/*????*/
	if (!CareerAgeFrom.equals("")){
		CareerAgeFrom=""+(currentyear-Util.getIntValue(CareerAgeFrom,0))+currentdate.substring(4) ;//???????
		HrmCareerApplyComInfo.setCareerAgeFrom(CareerAgeFrom);
		HrmCareerApplyComInfo.setAgeFrom(Util.getIntValue(CareerAgeFrom,0));
	}
	if (!CareerAgeTo.equals("")){
		CareerAgeTo =""+(currentyear-Util.getIntValue(CareerAgeTo,0))+currentdate.substring(4);//???????
		HrmCareerApplyComInfo.setCareerAgeTo(CareerAgeTo);
		HrmCareerApplyComInfo.setAgeTo(Util.getIntValue(CareerAgeTo,0));
	}
	HrmCareerApplyComInfo.setHeightFrom(HeightFrom);//?????
	HrmCareerApplyComInfo.setHeightTo(HeightTo) ;//?????
	HrmCareerApplyComInfo.setEducationLevel(EducationLevel) ;//??
	HrmCareerApplyComInfo.setSex(Sex) ;//??
	HrmCareerApplyComInfo.setMaritalStatus(MaritalStatus) ;//??
	HrmCareerApplyComInfo.setRegResidentPlace(RegResidentPlace) ;//?????
	HrmCareerApplyComInfo.setCategory(Category);//??
	HrmCareerApplyComInfo.setMajor(Major);//??
	HrmCareerApplyComInfo.setWorkTimeFrom(WorkTimeFrom);
	HrmCareerApplyComInfo.setWorkTimeTo(WorkTimeTo); //????
	HrmCareerApplyComInfo.setDegree(Degree); //??
	HrmCareerApplyComInfo.setSchool(School); //?????
	HrmCareerApplyComInfo.setCompany(Company); //?????
	HrmCareerApplyComInfo.setPolicy(Policy); //????
	HrmCareerApplyComInfo.setNativePlace(NativePlace); //??
	HrmCareerApplyComInfo.setResidentPlace(ResidentPlace); //????
	HrmCareerApplyComInfo.setDefaultLanguage(DefaultLanguage); //????
	HrmCareerApplyComInfo.setTrain(Train); //???????
	HrmCareerApplyComInfo.setSalaryNowFrom(SalaryNowFrom); 
	HrmCareerApplyComInfo.setSalaryNowTo(SalaryNowTo); 
	HrmCareerApplyComInfo.setOldJob(oldjob); 
	HrmCareerApplyComInfo.setSalaryNeedFrom(SalaryNeedFrom); 
	HrmCareerApplyComInfo.setSalaryNeedTo(SalaryNeedTo);  
	
	String status = Util.null2String(request.getParameter("status"));
	String planid = Util.null2String(request.getParameter("planid"));
	String inviteid = Util.null2String(request.getParameter("inviteid"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String cmd = Util.null2String(request.getParameter("cmd"));
	String id = Util.null2String(request.getParameter("id"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(6133,user.getLanguage())+": "+SystemEnv.getHtmlLabelName(773,user.getLanguage());;
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script language="javascript" src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			if('<%=cmd.equals("show")%>' == 'true'){
				doShow("<%=id%>");
			}
			if("<%=resourceid.length() > 0%>" == "true"){
				parent.window.location = "/hrm/HrmTab.jsp?_fromURL=HrmResource&id=<%=resourceid%>";
			}
			
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			function doSendEmail(id){
				if(!id){
					id = _xtable_CheckedCheckboxId();
				}
				if(!id){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31017,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)){
					id = id.substring(0,id.length-1);
				}
				doEmail(id);
			}
			
			var dialog = null;
			var dWidth = 700;
			var dHeight = 500;
			var planid = "<%=planid%>";
			var resourceid = "";
			function closeDialog(){
				if(dialog)
					dialog.close();
				if(!resourceid){
					resourceid = "";
				}
				if(!planid){
					planid = "";
				}
				var status=jQuery("#status").val();
				if(status=="")status=1;
				window.location.href="/hrm/career/applyinfo/list.jsp?status="+status+"&planid="+planid+"&resourceid="+resourceid;
			}
			
			function openDialog(id){
				if(window.top.Dialog){
					dialog = new window.top.Dialog();
				} else {
					dialog = new Dialog();
				}
				dialog.currentWindow = window;
				if(id == null){
					id = "";
				}
				var url = "";
				if(!!id){
					dialog.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(773,user.getLanguage())%>";
					url = "/hrm/HrmDialogTab.jsp?_fromURL=applyInfo&method=edit&isdialog=1&id="+id;
					dialog.Modal = true;
					dialog.maxiumnable = true;
				}else{
					dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(773,user.getLanguage())%>";
					url = "/hrm/HrmDialogTab.jsp?_fromURL=applyInfo&method=add&isdialog=1";
					dialog.Drag = true;
				}
				dialog.Width = 700;
				dialog.Height = 500;
				dialog.URL = url;
				dialog.show();
			}
			
			function todo(url,title,_dWidth,_dHeight){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
			
			function getPlanId(id){
				return ajaxSubmit(encodeURI(encodeURI("/js/hrm/getdata.jsp?cmd=getPlanIdByApplyId&id="+id)));
			}
			
			function doShow(id){
				todo("/hrm/HrmDialogTab.jsp?_fromURL=applyInfo&method=edit&cmd=show&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(773,user.getLanguage())%>",700,500);
			}
			
			function doPrint(id){
				todo("/hrm/career/HrmCareerApplyPrint.jsp?isdialog=1&applyid="+id,"<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>",700,500);
			}

			function doInterview(id){
				var planid = getPlanId(id);
				todo("/hrm/HrmDialogTab.jsp?_fromURL=applyInfo&method=interview&planid="+planid+"&id="+id,"<%=SystemEnv.getHtmlLabelName(6103,user.getLanguage())%>",700,500);
			}
			
			function doPass(id){
				var planid = getPlanId(id);
				todo("/hrm/HrmDialogTab.jsp?_fromURL=applyInfo&method=HrmInterviewResult&result=1&planid="+planid+"&id="+id,"<%=SystemEnv.getHtmlLabelName(15376,user.getLanguage())%>",700,500);
			}

			function doBack(id){
				var planid = getPlanId(id);
				todo("/hrm/HrmDialogTab.jsp?_fromURL=applyInfo&method=HrmInterviewResult&result=2&planid="+planid+"&id="+id,"<%=SystemEnv.getHtmlLabelName(15689,user.getLanguage())%>",700,500);
			}
			
			function doDelete(id){
				var planid = getPlanId(id);
				todo("/hrm/HrmDialogTab.jsp?_fromURL=applyInfo&method=HrmInterviewResult&result=0&planid="+planid+"&id="+id,"<%=SystemEnv.getHtmlLabelName(15690,user.getLanguage())%>",700,500);
			}
			
			function doInterviewAssess(id){
				todo("/hrm/HrmDialogTab.jsp?_fromURL=applyInfo&method=interviewAssess&id="+id,"<%=SystemEnv.getHtmlLabelName(6102,user.getLanguage())%>",700,500);
			}
			
			function doHire(id){
				var planid = getPlanId(id);
				todo("/hrm/HrmDialogTab.jsp?_fromURL=applyInfo&method=hire&planid="+planid+"&id="+id,"<%=SystemEnv.getHtmlLabelName(1853,user.getLanguage())%>",700,500);
			}
			
			function doShare(id){
				todo("/hrm/HrmDialogTab.jsp?_fromURL=applyInfo&method=share&id="+id,"<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%>",700,500);
			}

			function doEmail(id){
				todo("/hrm/HrmDialogTab.jsp?_fromURL=applyInfo&method=email&id="+id,"<%=SystemEnv.getHtmlLabelName(15691,user.getLanguage())%>",700,500);
			}
			
			function onLog(id){
				var appendSql = "";
				if(id){
					appendSql += "and relatedid="+id;
				}
				
				var url = "";
				if(id && id!=""){
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=59 and relatedid=")%>&relatedid="+id;
				}else{
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=59")%>";
				}
	
				todo(url,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
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
			if(inviteid.length() == 0){
				if(HrmUserVarify.checkUserRight("HrmCareerApplyAdd:Add", user)){
					RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
					RCMenuHeight += RCMenuHeightStep;
				}
				RCMenu += "{"+SystemEnv.getHtmlLabelName(15691,user.getLanguage())+",javascript:doSendEmail();,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
				
				if(HrmUserVarify.checkUserRight("HrmCareerApply:log", user)){
					RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog();,_self} " ;
					RCMenuHeight += RCMenuHeightStep;
				}
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<input id="status" name="status" type="hidden" value="<%=status %>">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%
							if(inviteid.length() == 0){
								if(HrmUserVarify.checkUserRight("HrmCareerApplyAdd:Add", user)){ 
						%>
									<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
						<%		} %>
						<input type=button class="e8_btn_top" onclick="doSendEmail();" value="<%=SystemEnv.getHtmlLabelName(15691,user.getLanguage())%>"></input>
						<%	}%>
						<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(1932,user.getLanguage())+SystemEnv.getHtmlLabelName(25034,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="Name" name="Name" class="inputStyle" value=""></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(366,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="careerinvite" browserValue="" 
					                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/career/inviteinfo/InviteBrowser.jsp"
					                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					                completeUrl="/data.jsp?type=inviteinfo" width="80%" browserSpanValue="">
						        </brow:browser>
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="jobtitle" browserValue="" 
					                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
					                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					                completeUrl="/data.jsp?type=hrmjobtitles" width="80%" browserSpanValue="">
						        </brow:browser>
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1855,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<select name="createdate" id="createdate" onchange="changeDate(this,'spancreatedate');" style="width:135px">
									<option value="0" <%=createdate.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
									<option value="6" <%=createdate.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
								</select>
							</span>
							<span id=spancreatedate style="<%=createdate.equals("6")?"":"display:none;" %>">
								<BUTTON class=Calendar type="button" id=selectdate onclick="getDate(createdate_startspan,FromDate)"></BUTTON>
								<SPAN id=createdate_startspan ></SPAN>
								<input class=inputstyle type="hidden" id="FromDate" name="FromDate" value="">－
								<BUTTON class=Calendar type="button" id=selectdate onclick="getDate(createdate_endspan,EndDate)"></BUTTON>
								<SPAN id=createdate_endspan ></SPAN>
								<input class=inputstyle type="hidden" id="EndDate" name="EndDate" value="">
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input type="text" id="CareerAgeFrom" name="CareerAgeFrom" style="width:38%" value="" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'>－<input type="text" id="CareerAgeTo" name="CareerAgeTo" style="width:38%" value="" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'>
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="EducationLevel" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=educationlevel" width="40%" browserSpanValue="">
								</brow:browser>
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<select class=inputstyle id="Sex" name="Sex">
									<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
									<option value="0"><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
									<option value="1"><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
								</select>
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<select class=inputstyle id=Category name=Category>
									<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
									<option value="0"><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></option>
									<option value="1"><%=SystemEnv.getHtmlLabelName(1830,user.getLanguage())%></option>
									<option value="2"><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
									<option value="3"><%=SystemEnv.getHtmlLabelName(1832,user.getLanguage())%></option>
								</select>
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<select name="MaritalStatus" id="MaritalStatus" class=inputstyle>
									<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
									<option value="0"><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%></option>
									<option value="1"><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%></option>
									<option value="2"><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%></option>
								</select>
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input class=inputstyle type=text name=DefaultLanguage value="">
							</wea:required>
						</wea:item>
					</wea:group>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(1843,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input type="text" class=inputstyle maxlength=30  size=30 name="SalaryNowFrom" style="width:38%" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("SalaryNowFrom")' value="">－<input type="text" class=inputstyle maxlength=30  size=30 name="SalaryNowTo" style="width:38%" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("SalaryNowTo")' value="">
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1828,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input class=inputstyle type=text name=RegResidentPlace value="">
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input type="text" class=inputstyle maxlength=3  size=30 name=WorkTimeFrom style="width:38%"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("WorkTimeFrom");checkinput("WorkTimeFrom","namespan")' value="" >－<input type="text" class=inputstyle maxlength=3  size=30 name=WorkTimeTo style="width:38%"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("WorkTimeTo");checkinput("WorkTimeTo","namespan")' value="" >
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="Major" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/speciality/SpecialityBrowser.jsp"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=Major" width="40%" browserSpanValue="">
								</brow:browser>
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1845,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input class=inputstyle type=text maxlength=30  size=30 name=SalaryNeedFrom style="width:38%" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("SalaryNeedFrom");checkinput("SalaryNeedFrom","namespan")' value="">－<input type="text" class=inputstyle maxlength=30  size=30 name=SalaryNeedTo style="width:38%" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("SalaryNeedTo");checkinput("SalaryNeedTo","namespan")' value="">
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(17370,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input class=inputstyle type=text name=oldjob value="">
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input class=inputstyle type=text name=Degree value="">
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1870,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input class=inputstyle type=text name=School value="">
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1871,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input class=inputstyle type=text name=Company value="">
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input class=inputstyle type=text name=Policy value="">
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input class=inputstyle type=text name=NativePlace value="">
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input class=inputstyle type=text name=ResidentPlace value="">
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input type="text" class=inputstyle maxlength=5  size=5 name=HeightFrom style="width:38%" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("HeightFrom")'>－<input type="text" class=inputstyle maxlength=5  size=5 name=HeightTo style="width:38%" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("HeightTo")'>
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1502,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input class=inputstyle type=text name=Train value="">
							</wea:required>
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<%
			String backFields = " a.*,c.jobtitlename,e.status,f.name as stepname,g.informmanid,g.principalid,(case when g.enddate is not null and g.enddate != '' then 1 else 0 end) as isOver,(select count(id) from HrmInterviewResult where resourceid = a.id and result = 2) as isBack ";
			String sqlFrom = "";
			String sqlWhere = "";
			String orderby = " a.id " ;
			String tableString = "";
			String fomatSqlSearch = HrmCareerApplyComInfo.FormatSQLSearch(user.getLanguage(),"a");
			sqlFrom = " from HrmCareerApply a left join HrmCareerInvite b on a.jobtitle = b.id left join HrmJobTitles c on b.careername = c.id left join HrmInterview e on a.nowstep = e.stepid and e.resourceid = a.id left join HrmCareerInviteStep f on a.nowstep = f.id left join HrmCareerPlan g on g.id = b.careerplanid ";
			if(HrmUserVarify.checkUserRight("HrmCareerApplyAdd:Add", user)){
				if(fomatSqlSearch.length() > 0) 
					sqlWhere = fomatSqlSearch;
				else 
					sqlWhere = " where 1 = 1";
			}else{
				sqlFrom += " left join HrmShare d on a.id=d.applyid";
				if(fomatSqlSearch.length() > 0) 
					sqlWhere = fomatSqlSearch;
				else 
					sqlWhere = " where 1 = 1";
				sqlWhere += " and d.hrmid="+user.getUID();
			}
			if(planid.length() > 0){
				sqlWhere += " and b.careerplanid = "+planid;
			}
			if(inviteid.length() > 0){
				sqlWhere += " and b.id = "+inviteid;
			}
			if(qname.length() > 0){
				sqlWhere += " and a.lastname like '%"+qname+"%'";
			}
			if(status.equals("1")){
				sqlWhere += " and a.id not in(select resourceid from HrmInterviewResult where result = 2)";
			}else if(status.equals("2")){
				sqlWhere += " and (select COUNT(id) from HrmInterviewResult where resourceid = a.id and result = 2) > 0 ";
			}
			
			rs.writeLog(backFields+sqlFrom+sqlWhere);
			String operateString= "<operates width=\"20%\">";
			operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\"true:"+HrmUserVarify.checkUserRight("HrmCareerApplyEdit:Edit", user)+":[HrmCareerPlan_info;+column:id+,"+user.getUID()+",+column:isBack+,+column:isOver+]:[HrmCareerPlan_isTester;+column:id+,"+user.getUID()+",+column:isBack+,+column:isOver+]:[HrmCareerPlan_isTester;+column:id+,"+user.getUID()+",+column:isBack+,+column:isOver+]:[HrmCareerPlan_isTester;+column:id+,"+user.getUID()+",+column:isBack+,+column:isOver+]:[HrmCareerPlan_isAssess;+column:id+,"+user.getUID()+",+column:isBack+,+column:isOver+]:[HrmCareerPlan_isHireP;+column:principalid+,"+user.getUID()+","+HrmUserVarify.checkUserRight("HrmCareerApply:Hire", user)+",+column:isOver+]:[HrmCareerPlan_isHireG;+column:id+,+column:principalid+,"+user.getUID()+","+HrmUserVarify.checkUserRight("HrmCareerApply:Hire", user)+",+column:isOver+]:+column:isOver+==0:"+HrmUserVarify.checkUserRight("HrmCareerApply:log", user)+"\"></popedom> ";
 	       	operateString+="     <operate href=\"javascript:doPrint();\" text=\""+SystemEnv.getHtmlLabelName(257,user.getLanguage())+"\" index=\"0\"/>";
			operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"1\"/>";
 	       	operateString+="     <operate href=\"javascript:doInterview();\" text=\""+SystemEnv.getHtmlLabelName(6103,user.getLanguage())+"\" index=\"2\"/>";
			operateString+="     <operate href=\"javascript:doPass();\" text=\""+SystemEnv.getHtmlLabelName(15376,user.getLanguage())+"\" index=\"3\"/>";
			operateString+="     <operate href=\"javascript:doBack();\" text=\""+SystemEnv.getHtmlLabelName(15689,user.getLanguage())+"\" index=\"4\"/>";
			operateString+="     <operate href=\"javascript:doDelete();\" text=\""+SystemEnv.getHtmlLabelName(15690,user.getLanguage())+"\" index=\"5\"/>";
			operateString+="     <operate href=\"javascript:doInterviewAssess();\" text=\""+SystemEnv.getHtmlLabelName(6102,user.getLanguage())+"\" index=\"6\"/>";
			operateString+="     <operate href=\"javascript:doHire();\" text=\""+SystemEnv.getHtmlLabelName(1853,user.getLanguage())+"\" index=\"7\"/>";
			operateString+="     <operate href=\"javascript:doShare();\" text=\""+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"\" index=\"8\"/>";
			operateString+="     <operate href=\"javascript:doEmail();\" text=\""+SystemEnv.getHtmlLabelName(15691,user.getLanguage())+"\" index=\"9\"/>";
 	       	operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"10\"/>";
 	       	operateString+="</operates>";
			
			tableString=""+
				"<table pageId=\""+Constants.HRM_Z_054+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_054,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
					" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"true\" />"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					operateString+
					"<head>"+
						"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("1932,25034",user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"list.jsp?cmd=show\" target=\"_self\"/>"+
						"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15671,user.getLanguage())+"\" column=\"jobtitlename\" orderkey=\"jobtitlename\"/>"+
						"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(416,user.getLanguage())+"\" column=\"sex\" orderkey=\"sex\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=417,1=418,2=763]}\"/>"+
						"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1855,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\" />"+
						"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1929,user.getLanguage())+"\" column=\"stepname\" orderkey=\"stepname\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:append[+ +getValue(+column:status+;"+user.getLanguage()+";0=15706,1=15376,2=15704)]}\"/>"+
						"<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(15705,user.getLanguage())+"\"  column=\"isinform\" orderkey=\"isinform\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=161,1=163]}\"/>"+
					"</head>"+
				"</table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.close();">
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
	</BODY>
</HTML>
