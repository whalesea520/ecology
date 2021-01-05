
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.hrm.career.domain.HrmCareerApply" %>
<!-- modified by wcd 2014-06-18 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CareerInviteComInfo" class="weaver.hrm.career.CareerInviteComInfo" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="CareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page"/>
<jsp:useBean id="applyManager" class="weaver.hrm.career.manager.HrmCareerApplyManager" scope="page"/>
<% 
	String method = Util.null2String(request.getParameter("method"));
	boolean showPage = method.equals("add") ? HrmUserVarify.checkUserRight("HrmCareerApplyAdd:Add",user) : HrmUserVarify.checkUserRight("HrmCareerApplyEdit:Edit",user);
	if(!showPage) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String cmd = Util.null2String(request.getParameter("cmd"));
	boolean isShow = cmd.equals("show");
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String inviteid = "";
	String jobtitle = "";
	String ischeck = "";
	String ishire = "";
	int picture = 0;
	String pictureshowname = "";

	String firstname = "";/*名*/
	String lastname = "";/*姓*/
	String titleid= "";/*称呼*/
	String sex = "";

	String birthday = "";/*生日*/
	String nationality = "";/*国籍*/
	String defaultlanguage = "";/*口语语言*/
	String maritalstatus = "";

	String marrydate = "";/*结婚日期*/
	String email = "";/*电邮*/
	String homeaddress = "";/*家庭地址*/
	String homepostcode = "";/*家庭邮编*/

	String homephone = "";/*家庭电话*/
	String certificatecategory = "";/**/
	String certificatenum = "";/*证件号码*/
	String nativeplace = "";/*籍贯*/
	String educationlevel = "";/*学历*/
	String bememberdate = "";/*入团日期*/
	String bepartydate = "";/*入党日期*/
	String bedemocracydate = "";/*民主日期*/
	String regresidentplace = "";/*户口所在地*/
	String healthinfo = "";/*健康状况*/
	String residentplace = "";/*现居住地*/
	String policy = "";/*政治面貌*/
	String degree = "";/*学位*/
	String height = "";/*身高*/
	String homepage = "";/*个人主页*/
	String train = "";/*培训及持有证书*/
	String numberid = "";/*培训及持有证书*/

	String contactor = "";/*联系人*/
	String category = "";/*应聘者类别*/
	String major = "";/*专业*/
	String salarynow = "";/*当前年薪*/
	String worktime = "";/*工作年限*/
	String salaryneed = "";/*年薪低限*/
	String reason = "";/**/
	String otherrequest = "";/**/
	String selfcomment = "";/*自荐书*/
	String currencyid = "";/*币种*/

	String informman = "";
	String principalid = "";
	String planid = "";
	
	String applyid = Util.null2String(request.getParameter("applyid"));
	if(applyid.length() > 0){
		HrmCareerApply bean = applyManager.get(applyid);
		if(bean == null){
			bean.init();
		}
	
		inviteid = String.valueOf(bean.getCareerinviteid());
		jobtitle = String.valueOf(bean.getJobtitle());
		ischeck = bean.getIscheck();
		ishire = bean.getIshire();
		
		picture = bean.getPicture();
		pictureshowname = bean.getPictureShowName();

		firstname = Util.toScreen(bean.getFirstname(),user.getLanguage()) ;
		lastname = Util.toScreen(bean.getLastname(),user.getLanguage()) ;
		titleid= String.valueOf(bean.getTitleid());
		sex = Util.toScreen(bean.getSex(),user.getLanguage()) ;

		birthday = Util.toScreen(bean.getBirthday(),user.getLanguage()) ;
		nationality = String.valueOf(bean.getNationality());
		defaultlanguage = String.valueOf(bean.getDefaultlanguage());
		maritalstatus = Util.toScreen(bean.getMaritalstatus(),user.getLanguage()) ;

		marrydate = Util.toScreen(bean.getMarrydate(),user.getLanguage()) ;
		email = Util.toScreen(bean.getEmail(),user.getLanguage()) ;
		homeaddress = Util.toScreen(bean.getHomeaddress(),user.getLanguage()) ;
		homepostcode = Util.toScreen(bean.getHomepostcode(),user.getLanguage()) ;

		homephone = Util.toScreen(bean.getHomephone(),user.getLanguage()) ;
		certificatecategory = Util.toScreen(bean.getCertificatecategory(),user.getLanguage()) ;
		certificatenum = Util.toScreen(bean.getCertificatenum(),user.getLanguage()) ;
		nativeplace = Util.toScreen(bean.getNativeplace(),user.getLanguage()) ;
		educationlevel = String.valueOf(bean.getEducationlevel());
		bememberdate = Util.toScreen(bean.getBememberdate(),user.getLanguage()) ;
		bepartydate = Util.toScreen(bean.getBepartydate(),user.getLanguage()) ;
		bedemocracydate = Util.toScreen(bean.getBedemocracydate(),user.getLanguage()) ;
		regresidentplace = Util.toScreen(bean.getRegresidentplace(),user.getLanguage()) ;
		healthinfo = Util.toScreen(bean.getHealthinfo(),user.getLanguage()) ;
		residentplace = Util.toScreen(bean.getResidentplace(),user.getLanguage()) ;
		policy = Util.toScreen(bean.getPolicy(),user.getLanguage()) ;
		degree = Util.toScreen(bean.getDegree(),user.getLanguage()) ;
		height = String.valueOf(bean.getHeight());
		homepage = Util.toScreen(bean.getHomepage(),user.getLanguage()) ;
		train = Util.toScreen(bean.getTrain(),user.getLanguage()) ;
		numberid = Util.toScreen(bean.getNumberid(),user.getLanguage()) ;

		contactor = Util.toScreen(bean.getOtherInfo().getContactor(),user.getLanguage()) ;
		category = Util.toScreen(bean.getOtherInfo().getCategory(),user.getLanguage()) ;
		major = Util.toScreen(bean.getOtherInfo().getMajor(),user.getLanguage()) ;
		salarynow = Util.toScreen(bean.getOtherInfo().getSalarynow(),user.getLanguage()) ;
		worktime = String.valueOf(bean.getOtherInfo().getWorktime());
		salaryneed = Util.toScreen(bean.getOtherInfo().getSalaryneed(),user.getLanguage()) ;
		reason = Util.toScreen(bean.getOtherInfo().getReason(),user.getLanguage()) ;
		otherrequest = Util.toScreen(bean.getOtherInfo().getOtherrequest(),user.getLanguage()) ;
		selfcomment = Util.toScreen(bean.getOtherInfo().getSelfcomment(),user.getLanguage()) ;
		currencyid = String.valueOf(bean.getOtherInfo().getCurrencyid());
		
		informman = "" ;
		principalid = "" ;
		planid = "" ;
		if( !inviteid.equals("")) {
			rs.executeSql("select a.* from HrmCareerPlan a , HrmCareerInvite b where a.id = b.careerplanid and b.id = "+inviteid);
			if(rs.next()){
			  principalid = Util.null2String(rs.getString("principalid"));
			  informman = Util.null2String(rs.getString("informmanid"));
			  planid = Util.null2String(rs.getString("id"));
			}
		}
	}
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(applyid.length() > 0?93:82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(773,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	boolean isInformer = (Util.getIntValue(informman)==user.getUID());
	boolean isPrincipal = (Util.getIntValue(principalid)==user.getUID());
	boolean isAssessor = applyid.length() > 0 ? CareerApplyComInfo.isAssessor(applyid,user.getUID()) : false;
	boolean isTester = applyid.length() > 0 ? CareerApplyComInfo.isTester(applyid,user.getUID()) : false;
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.closeDialog();
			  dialog.close();
			}else if("<%=isclose%>"=="2"){	
				parentWin.closeDialog();
				parentWin.openDialog("<%=applyid%>");
			}
			function doCheck(){
				return check_form(document.resource,'lastname,jobtitle,careerinvite,worktime,salaryneed,contactor,email,homephone');
			}
			function delpic(){
				if(confirm("<%=SystemEnv.getHtmlLabelName(30952,user.getLanguage())%>")){
					document.resource.operation.value = "delpic";
					document.resource.submit() ;
				}
			}
			function doSave(){
				if(doCheck()){
				var cmd ="";
				if("<%=method%>" == "edit"){
					cmd ="edit";
				}else{
					cmd ="add";
				}
					$.ajax({
						type:"POST",
						url:"careerApplyCheck.jsp",
						data: {lastname:$("#lastname").val(),cmd:cmd,id:"<%=applyid%>"},
           		 		dataType: "json",
						success: function(data){
							if(data > 0){
								window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%>"+$("#lastname").val()+"<%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>"+",<%=SystemEnv.getHtmlLabelName(15382,user.getLanguage())%>",function(){
									document.resource.operation.value = "save";
									document.resource.submit();
								});
							}else{
								document.resource.operation.value = "save";
								document.resource.submit();
							}
						},
						 error:function(data){     
					          window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19327,user.getLanguage())%>"); 
					          return;    
					     }     
								
					});
					
				}
			}
			function doNext(){
				
				if(doCheck()){
					$.ajax({
						type:"POST",
						url:"careerApplyCheck.jsp", 
						data: {lastname:$("#lastname").val(),cmd:"add",id:"<%=applyid%>"},
           		 		dataType: "json",
						success: function(data){
							if(data > 0){
								window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%>"+$("#lastname").val()+"<%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>"+",<%=SystemEnv.getHtmlLabelName(15382,user.getLanguage())%>",function(){
									document.resource.operation.value = "next";
									document.resource.submit();
								});
							}else{
								document.resource.operation.value = "next";
								document.resource.submit();
							}
						},
						 error:function(data){     
					          window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19327,user.getLanguage())%>"); 
					          return;    
					     }     
								
					});
				}
			}
		</script>
	</HEAD>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<iframe id="checkHas" style="display:none"></iframe>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%if(method.equals("add")){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage()) %>" class="e8_btn_top" onclick="doNext()"/>
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM name=resource id=resource action="save.jsp" method=post enctype="multipart/form-data">
			<input class=inputstyle type=hidden name=operation>
			<input class=inputstyle type=hidden name=method value="<%=method%>">
			<input class=inputstyle type=hidden name=applyid value="<%=applyid%>">
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required='<%=lastname.length()==0%>'>
							<INPUT class=inputstyle maxLength=30 size=30 name="lastname" id="lastname" onchange="checkinput('lastname','namespan')" value="<%=lastname%>"/>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<select name="sex" id="sex" class=inputstyle>
								<option value=0 <%if(sex.equals("0") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
								<option value=1 <%if(sex.equals("1") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
							</select>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="jobtitle" browserValue='<%=jobtitle%>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/career/inviteinfo/InviteBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
							completeUrl="/data.jsp?type=inviteinfo" width="60%" browserSpanValue='<%=applyManager.findJobTitleName(jobtitle)%>'>
						</brow:browser>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15675,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<select class=inputstyle id=category name=category>
								<option value=""></option>
								<option value="0" <%if(category.equals("0") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></option>
								<option value="1" <%if(category.equals("1") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1830,user.getLanguage())%></option>
								<option value="2" <%if(category.equals("2") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
								<option value="3" <%if(category.equals("3") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1832,user.getLanguage())%></option>
							</select>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(picture>0){%>
							<a href="/weaver/weaver.file.FileDownload?fileid=<%=picture%>&download=1"><%=pictureshowname%></a>
							<BUTTON class=btnDelete  onClick="delpic()"><%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%></BUTTON>
							<input class=inputstyle type=hidden size=30 name="pictureold" value="<%=picture%>">
						<%}else{%>
							<input class=inputstyle type=file name="picture">
						<%}%>
					</wea:item>
				</wea:group>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1842,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(1843,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="salarynowspan" required="false">
							<input class=inputstyle maxlength=30  size=30 name=salarynow  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("salarynow")' value="<%=salarynow%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="worktimespan" required='<%=worktime.length()==0%>'>
							<input class=inputstyle maxlength=3  size=30 name=worktime  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("worktime");checkinput("worktime","worktimespan")' value="<%=worktime%>" >
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1845,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="salaryneedspan" required='<%=salaryneed.length()==0%>'>
							<input class=inputstyle maxlength=30  size=30 name=salaryneed  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("salaryneed");checkinput("salaryneed","salaryneedspan")' value="<%=salaryneed%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="currencyid" browserValue='<%=currencyid%>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp?type=12" width="60%" browserSpanValue='<%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>'>
						</brow:browser>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1846,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="reasonspan" required="false">
							<textarea class=inputstyle cols=50 rows=4 name="reason" ><%=Util.fromHtmlToEdit(reason)%></textarea>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1847,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="otherrequestspan" required="false">
							<textarea class=inputstyle cols=50 rows=4 name="otherrequest" ><%=Util.fromHtmlToEdit(otherrequest)%></textarea>
						</wea:required>
					</wea:item>
				</wea:group>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(569,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="contactorspan" required='<%=contactor.length()==0%>'>
							<INPUT class=inputstyle maxLength=30 size=30 name="contactor" onchange="checkinput('contactor','contactorspan')" value="<%=contactor%>"/>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="homepostcodespan" required="false">
							<input class=inputstyle maxlength=8 size=30 name=homepostcode onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("homepostcode");' value="<%=homepostcode%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="homeaddressspan" required="false">
							<INPUT class=inputstyle maxLength=100 size=30 name="homeaddress" value="<%=homeaddress%>"/>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="emailspan" required='<%=email.length()==0%>'>
							<input class=inputstyle maxlength=128 size=30  onchange='checkinput_email("email","emailspan")'  name=email value="<%=email%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="homephonespan" required='<%=homephone.length()==0%>'>
							<input class=inputstyle maxlength=15 size=30  onchange='checkinput("homephone","homephonespan")'  name=homephone value="<%=homephone%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1848,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="homepagespan" required="false">
							<input class=inputstyle maxlength=100 size=30 name=homepage value="<%=homepage%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1849,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="selfcommentspan" required="false">
							<textarea class=inputstyle cols=50 rows=4 name="selfcomment" ><%=Util.fromHtmlToEdit(selfcomment)%></textarea>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>
		</FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.closeByHand();">
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
