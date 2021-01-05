<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-09 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmUseDemandEdit:Edit", user)){
	  	response.sendRedirect("/notice/noright.jsp");
	  	return;
	}
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(6131,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(89,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String _status = Util.null2String(request.getParameter("_status"));
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			<%if(isclose.equals("1")){%>
				parentWin._status = "<%=_status%>";
				parentWin.closeDialog();
			<%}%>
		</script>	
	</head>
	<%
		String id = request.getParameter("id");
		
		String jobtitle = "";
		String demandnum = "";
		String otherrequest = "";
		String date = "";
		int status = 0;
		String leastedulevel = "";
		int createkind = 0;
		String demandkind = "";
		
		String referman = "";
		String department = "";
		String referdate = "";
		
		String sql = "select * from HrmUseDemand where id ="+id;
		rs.executeSql(sql); 
		while(rs.next()){
		  	jobtitle = Util.null2String(rs.getString("demandjobtitle"));
		  	demandnum = Util.null2String(rs.getString("demandnum"));
		  	status = Util.getIntValue(rs.getString("status"),0);
		  	leastedulevel = Util.null2String(rs.getString("leastedulevel"));  
		  	date = Util.null2String(rs.getString("demandregdate"));
		  	otherrequest = Util.null2String(rs.getString("otherrequest"));
		  	createkind = Util.getIntValue(rs.getString("createkind"),0);
		  	demandkind = Util.null2String(rs.getString("demandkind"));
		  
		  	referman = Util.null2String(rs.getString("refermandid"));
		  	department = Util.null2String(rs.getString("demanddep"));
		  	referdate = Util.null2String(rs.getString("referdate"));
		}
	%>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doedit();,_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<FORM id=weaver name=frmMain action="UseDemandOperation.jsp" method=post >
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doedit();">
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0"  name="departmentid" browserValue='<%=department %>'
						 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?isedit=1&rightStr=HrmResourceAdd:Add"
					   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
					   completeUrl="/data.jsp?type=4" width="165px"
					   browserSpanValue='<%=DepartmentComInfo.getDepartmentname(department) %>'>
					 </brow:browser>
					</wea:item> 
					<wea:item><%=SystemEnv.getHtmlLabelName(20379,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="jobtitle" browserValue='<%=jobtitle%>' 
				                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
				                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				                completeUrl="/data.jsp?type=hrmjobtitles" width="60%" browserSpanValue='<%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>'>
					        </brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(17905,user.getLanguage())+SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="demandnumspan" required='<%=demandnum.length()==0%>'>
							<input class=inputstyle type=text maxlength="30" name="demandnum" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("demandnum")' onchange='checkinput("demandnum","demandnumspan")' value="<%=demandnum%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<select name="status" id="status" class=inputstyle>
								<option value="0" <% if(status == 0){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(15746,user.getLanguage())%></option>
								<option value="1" <% if(status == 1){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(15747,user.getLanguage())%></option>
								<option value="2" <% if(status == 2){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(15748,user.getLanguage())%></option>
								<option value="3" <% if(status == 3){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(15749,user.getLanguage())%></option>
								<!--<option value="4" <% if(status == 4){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>-->
							</select>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(6153,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="datesspan" required="false">
							<BUTTON class=Calendar type="button" id=selectdate onclick="getDate(datespan,date)"></BUTTON> 
			              	<SPAN id=datespan ><%=date%></SPAN> 
			              	<input class=inputstyle type="hidden" id="date" name="date" value="<%=date%>"> 
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
					        <brow:browser viewType="0" name="demandkind" browserValue='<%=demandkind%>' 
				                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp"
				                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				                completeUrl="/data.jsp?type=usekind" width="60%" browserSpanValue='<%=UseKindComInfo.getUseKindname(demandkind)%>'>
					        </brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="leastedulevel" browserValue='<%=leastedulevel%>' 
				                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp"
				                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				                completeUrl="/data.jsp?type=educationlevel" width="60%" browserSpanValue='<%=EducationLevelComInfo.getEducationLevelname(leastedulevel)%>'>
					        </brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1847,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="otherrequestspan" required="false">
							<textarea class=inputstyle cols=50 rows=4 name="otherrequest" ><%=otherrequest%></textarea>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input type="hidden" name=operation>
			<input type=hidden name=id value="<%=id%>">
			<input type=hidden name="_status" value="<%=_status%>">
		 </form>
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
		<script language=javascript>
			 function doedit(){
			   	if(check_form(document.frmMain,'jobtitle,demandnum,departmentid')){
			   		document.frmMain.operation.value="edit";
			   		document.frmMain.submit();
			   	}
			 }
			 function dodelete(){
			   	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
			     	document.frmMain.operation.value="delete";
			     	document.frmMain.submit();
			   	}
			 }
			 function doclose(){
			   	if(confirm("<%=SystemEnv.getHtmlLabelName(15751,user.getLanguage())%>")){
			     	document.frmMain.operation.value="close";
			     	document.frmMain.submit();
			   	}
			 }
		</script> 
	</BODY>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
