
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.hrm.common.*" %>
<!-- modified by wcd 2014-06-17 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CareerInviteComInfo" class="weaver.hrm.career.CareerInviteComInfo" scope="page" />
<jsp:useBean id="CareerPlanComInfo" class="weaver.hrm.job.CareerPlanComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<% 
	String method = Util.null2String(request.getParameter("method"));
	boolean isShow = method.equals("show");
	boolean canedit = HrmUserVarify.checkUserRight("HrmCareerInviteEdit:Edit", user) ;
	boolean showPage = method.equals("add") ? HrmUserVarify.checkUserRight("HrmCareerInviteAdd:Add",user) : canedit;
	if(!showPage) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String inviteId = Util.null2String(request.getParameter("id")) ;
	String careerpeople = "";
	String careerage = "";
	String careersex = "";
	String careeredu = "";
	String careermode = "";
	String careername = "";
	String careeraddr = "";
	String careerclass = "";
	String careerdesc = "";
	String careerrequest = "";
	String careerremark = "";
	String planid = Util.null2String(request.getParameter("planid"));
	String cmd = Util.null2String(request.getParameter("cmd"));
	boolean notChangePlan = cmd.equals("notchangeplan");
	String isweb = "";
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(366,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(isShow?221:(inviteId.length() > 0?93:82),user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	if(inviteId.length() > 0){
		rs.executeProc("HrmCareerInvite_SelectById",inviteId);
		rs.next();

		careerpeople = Util.null2String(rs.getString("careerpeople"));
		careerage = Util.null2String(rs.getString("careerage"));
		careersex = Util.null2String(rs.getString("careersex"));
		careeredu = Util.null2String(rs.getString("careeredu"));
		careermode = Util.null2String(rs.getString("careermode"));
		careername = Util.toScreenToEdit(rs.getString("careername"),user.getLanguage());
		careeraddr = Util.toScreenToEdit(rs.getString("careeraddr"),user.getLanguage());
		careerclass = Util.toScreenToEdit(rs.getString("careerclass"),user.getLanguage());
		careerdesc = Util.toScreenToEdit(rs.getString("careerdesc"),user.getLanguage());
		careerrequest = Util.toScreenToEdit(rs.getString("careerrequest"),user.getLanguage());
		careerremark = Util.toScreenToEdit(rs.getString("careerremark"),user.getLanguage());
		planid = Util.null2String(rs.getString("careerplanid"));
		isweb = Util.null2String(rs.getString("isweb"));
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.closeDialog("<%=cmd%>","<%=planid%>");
			}else if("<%=isclose%>"=="2"){
				parentWin.closeDialog();
				parentWin.openDialog("<%=inviteId%>");
			}
			function doSave(){
				if(check_form(document.frmain,"careername")){
					jQuery("#savebt").attr("disabled",true);
					document.frmain.submit();
				}
			}
			function doNext(){
				if(check_form(document.frmain,"careername")){
					document.frmain.operation.value="next";
					document.frmain.submit();
				}
			}
			function doSetValue(event,data,name){
				try{
				var result = eval(ajaxSubmit(encodeURI(encodeURI("/js/hrm/getdata.jsp?cmd=getUseDemand&id="+data.id))));
				if(result && result.length>0){
					for(var i=0;i<result.length;i++){
						document.frmain.careerpeople.value = result[i].demandnum;
						_writeBackData('careername', 2, {id:result[i].demandjobtitle,name:"<a href='#"+result[i].demandjobtitle+"'>"+result[i].jobtitlename+"</a>"},{hasInput:true});
						_writeBackData('careermode', 1, {id:result[i].demandkind,name:"<a href='#"+result[i].demandkind+"'>"+result[i].useKindName+"</a>"},{hasInput:true});
						_writeBackData('careeredu', 1, {id:result[i].leastedulevel,name:"<a href='#"+result[i].leastedulevel+"'>"+result[i].levelName+"</a>"},{hasInput:true});
						document.frmain.careerremark.value = decodeURI(result[i].otherrequest);
					}
				}
				}catch(e){}
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
			if(!isShow){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(!isShow){%>
					<input type="button" id="savebt" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%if(method.equals("add")){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage()) %>" class="e8_btn_top" onclick="doNext()"/>
					<%}}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM name="frmain" action="save.jsp" method="post">
			<input class=inputstyle type="hidden" name="operation" value="<%=method%>">
			<input class=inputstyle type="hidden" name="cmd" value="<%=cmd%>">
			<input class=inputstyle type="hidden" name="inviteId" value="<%=inviteId%>">
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<%if(!isShow){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(6131,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="usedemand" browserValue="" 
				                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/career/usedemand/UseDemandBrowser.jsp"
				                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				                completeUrl="/data.jsp?type=usedemand" width="60%" browserSpanValue="" _callback="doSetValue">
					        </brow:browser>
						</span>
					</wea:item>
					<%}%>
					<wea:item><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<%if(isShow||notChangePlan){out.println(CareerPlanComInfo.getName(planid));if(notChangePlan){out.println("<input class='inputstyle' type='hidden' name='careerplan' value='"+planid+"'>");}}else {%>
							<brow:browser viewType="0" name="careerplan" browserValue='<%=planid%>' 
				                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/career/careerplan/CareerPlanBrowser.jsp"
				                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				                completeUrl="/data.jsp?type=careerplan" width="60%" browserSpanValue='<%=CareerPlanComInfo.getName(planid)%>'>
					        </brow:browser>
							<%}%>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15719,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(isweb.equals("0") ? SystemEnv.getHtmlLabelName(161,user.getLanguage()) : SystemEnv.getHtmlLabelName(163,user.getLanguage()));}else{%>
						<span>
							<select name="isweb" id="isweb" class=inputstyle>
								<option value="0" <% if(isweb.equals("0")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
								<option value="1" <% if(isweb.equals("1")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
							</select>
						</span>
						<%}%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(JobTitlesComInfo.getJobTitlesname(careername));}else{%>
						<brow:browser viewType="0" name="careername" browserValue='<%=careername%>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
							completeUrl="/data.jsp?type=hrmjobtitles" width="60%" browserSpanValue='<%=JobTitlesComInfo.getJobTitlesname(careername)%>'>
						</brow:browser>
						<%}%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(17905,user.getLanguage())+SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(careerpeople);}else{%>
						<wea:required id="namespan" required="false">
							<input class=inputstyle  maxlength=4 size=15 name="careerpeople" value='<%=careerpeople%>' onkeyup="checkPlusnumber1(this)">
						</wea:required>
						<%}%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(UseKindComInfo.getUseKindname(careermode));}else{%>
						<span>
					        <brow:browser viewType="0" name="careermode" browserValue='<%=careermode%>' 
				                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp"
				                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				                completeUrl="/data.jsp?type=usekind" width="60%" browserSpanValue='<%=UseKindComInfo.getUseKindname(careermode)%>'>
					        </brow:browser>
						</span>
						<%}%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(EducationLevelComInfo.getEducationLevelname(careeredu));}else{%>
						<span>
							<brow:browser viewType="0" name="careeredu" browserValue='<%=careeredu%>' 
				                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp"
				                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				                completeUrl="/data.jsp?type=educationlevel" width="60%" browserSpanValue='<%=EducationLevelComInfo.getEducationLevelname(careeredu)%>'>
					        </brow:browser>
						</span>
						<%}%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())+SystemEnv.getHtmlLabelName(18201,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(new SplitPageTagFormat().colFormat(careersex,"{cmd:array["+String.valueOf(user.getLanguage())+";0=417,1=418,2=763]}"));}else{%>
						<span>
							<select class=inputstyle id="careersex" name="careersex">
								<option value="0" <%if (careersex.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
								<option value="1" <%if (careersex.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
								<option value="2" <%if (careersex.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(763,user.getLanguage())%></option>
							</select>
						</span>
						<%}%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())+SystemEnv.getHtmlLabelName(18201,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(careerage);}else{%>
						<wea:required id="namespan" required="false">
							<input class=inputstyle maxlength=20  size=15 name="careerage" value='<%=careerage%>' onkeyup="checkPlusnumber1(this)">
						</wea:required>
						<%}%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(419,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(careeraddr);}else{%>
						<wea:required id="namespan" required="false">
							<input class=inputstyle maxlength=100 size=45 name="careeraddr" value='<%=careeraddr%>'>
						</wea:required>
						<%}%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1858,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(careerdesc);}else{%>
						<wea:required id="namespan" required="false">
							<TEXTAREA class=inputstyle name="careerdesc" rows="6"><%=careerdesc%></TEXTAREA>
						</wea:required>
						<%}%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1868,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(careerrequest);}else{%>
						<wea:required id="namespan" required="false">
							<TEXTAREA class=inputstyle name="careerrequest" rows="6"><%=careerrequest%></TEXTAREA>
						</wea:required>
						<%}%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(careerremark);}else{%>
						<wea:required id="namespan" required="false">
							<textarea class=inputstyle cols=50 rows=4 name="careerremark" ><%=careerremark%></textarea>
						</wea:required>
						<%}%>
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
