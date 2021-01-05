<%@ page import="weaver.general.Util,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-11 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="MailMouldComInfo" class="weaver.docs.mail.MailMouldComInfo" scope="page" />
<jsp:useBean id="CareerPlanComInfo" class="weaver.hrm.career.CareerPlanComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String _status = Util.null2String(request.getParameter("_status"));
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(6132,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(89,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String id = request.getParameter("id");

	boolean isFin = CareerPlanComInfo.isFinish(id);
	boolean canDelete = CareerPlanComInfo.canDelete(id);
	boolean canEdit =  HrmUserVarify.checkUserRight("HrmCareerPlanEdit:Edit", user);

	String topic = "";
	String principalid = "";
	String informmanid = "";
	String startdate = "";
	String budgettype = "";
	String budget = "";
	String emailmould = "";
	String memo = "";

	String sql = "select * from HrmCareerPlan where id ="+id;
	rs.executeSql(sql); 
	while(rs.next()){
	  topic = Util.null2String(rs.getString("topic"));
	  principalid = Util.null2String(rs.getString("principalid"));
	  budgettype = Util.null2String(rs.getString("budgettype"));
	  informmanid = Util.null2String(rs.getString("informmanid"));  
	  startdate = Util.null2String(rs.getString("startdate"));
	  budget = Util.null2String(rs.getString("budget"));
	  emailmould = Util.null2String(rs.getString("emailmould"));
	  memo = Util.toScreenToEdit(rs.getString("memo"),user.getLanguage());
	}

	boolean isPrincipal = false;
	if(principalid.equals(""+user.getUID()))
		isPrincipal = true;
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin._status = "<%=_status%>";
				parentWin.closeDialog();
			}
			function doSave(){
				if(check_form(document.frmMain,'topic')){
					document.frmMain.submit();
				}
			}
			function doClose(){
				if(!<%=isFin%>){
					parent.location="/hrm/HrmDialogTab.jsp?_fromURL=HrmCareerPlanEdit&method=finish&status=<%=_status%>&id=<%=id%>";
				}else{
					parent.location="HrmCareerPlanFinishView.jsp?isdialog=1&_status=<%=_status%>&id=<%=id%>";
				}
			}
			function doInform(obj){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>",function(){
					obj.disabled = true;
					document.location = "/hrm/career/careerplan/CareerPlanInformOperation.jsp?CareerPlanID=<%=id%>&_status=<%=_status%>";
				});
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
		if(!isFin){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(!isFin && (canEdit || isPrincipal)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(405,user.getLanguage())+",javascript:doClose(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(15781,user.getLanguage())+SystemEnv.getHtmlLabelName(15761,user.getLanguage())+",javascript:doInform(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(!isFin){%>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="CareerPlanOperation.jsp" method=post >
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%>'>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<wea:required id="namespan" required='<%=topic.length()==0%>'>
				  			<input class=inputstyle type=text size=30 name="topic" value="<%=topic%>" onchange="checkinput('topic','namespan')">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span>
							<brow:browser viewType="0" name="principalid" browserValue='<%=principalid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp" width="60%" browserSpanValue='<%=ResourceComInfo.getResourcename(principalid)%>'>
							</brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15669,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span>
							<brow:browser viewType="0" name="informmanid" browserValue='<%=informmanid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp" width="60%" browserSpanValue='<%=ResourceComInfo.getResourcename(informmanid)%>'>
							</brow:browser>
						</span>
					</wea:item>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(22168,user.getLanguage())%></wea:item>
				  	<wea:item>
						<wea:required id="selectdatespan" required="false">
							<BUTTON class=Calendar type="button" id=selectdate onclick="getDate(datespan,startdate)"></BUTTON> 
				            <SPAN id=datespan ><%=startdate%></SPAN> 
				            <input class=inputstyle type="hidden" id="startdate" name="startdate" value="<%=startdate%>"> 
						</wea:required>
					</wea:item>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<wea:required id="memospan" required="false">
				  			<textarea class=inputstyle cols=50 rows=4 name="memo" ><%=memo%></textarea>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>
			<input class="inputstyle" type="hidden" name="operation" value="edit">
			<input class="inputstyle" type="hidden" name="id" value="<%=id%>">
			<input class="inputstyle" type="hidden" name="_status" value="<%=_status%>">
			<input class=inputstyle type=hidden name=oldprincipalid value="<%=principalid%>">
			<input class=inputstyle type=hidden name=oldinformmanid value="<%=informmanid%>">
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
	</BODY>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
