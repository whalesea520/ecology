<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String isBrowser = Util.null2String(request.getParameter("isBrowser"));
String id = Util.null2String(request.getParameter("id"));
String name = "";
if(id.length()>0)name = JobTitlesComInfo.getJobTitlesname(id);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6086,user.getLanguage());
String needfav ="1";
String needhelp ="";

if(!HrmUserVarify.checkUserRight("HrmJobTitlesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String jobactivite = Util.null2String(request.getParameter("jobactivite"));  
if(jobactivite.length()==0&&id.length()>0)jobactivite=JobTitlesComInfo.getJobactivityid(id);
String[] strObj = null ;
String errorMsg ="";
if("1".equals(Util.null2String(request.getParameter("message")))){
	try{
		strObj = (String[])request.getSession().getAttribute("JobTitle.error");
		if(strObj != null){
			errorMsg = SystemEnv.getHtmlLabelName(32479,user.getLanguage());
		}
	}catch(Exception e){}
}else{
	request.getSession().removeAttribute("JobTitle.error");
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	if("<%=isBrowser%>" == "1"){
		var returnjson={"id":"<%=id%>","name":"<%=name%>"};
		dialog.callback(returnjson);
	}else{
		parentWin.onBtnSearchClick();
		<%if(id.length()>0){%>
		try{
			parentWin.parent.parent.refreshTreeMain(<%=id%>,<%=jobactivite%>);
		}catch(e){}
		<%}%>
		parentWin.closeDialog();	
	}
}
jQuery(document).ready(function(){
	parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage()) %>");
})
</script>
</head>
<BODY>
 <%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="JobTitlesOperation.jsp" method=post>
<input type="hidden" name=isBrowser value=<%=isBrowser %>>
<%
if(HrmUserVarify.checkUserRight("HrmJobTitlesAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(!"".equals(errorMsg)){%>
		<div><font color="red">
			<%=errorMsg%>
		</font></div>
	<%}%>
		<wea:layout type="2col">
			<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
				<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
				<wea:item>
					<wea:required id="jobtitlemarkspan" required="true">
						<INPUT class=inputstyle type=text  name="jobtitlemark" onchange='checkinput("jobtitlemark","jobtitlemarkspan")'  value="<%=(strObj==null?"":strObj[0])%>">
					</wea:required>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
				<wea:item>
					<wea:required id="jobtitlenamespan" required="true">
						<INPUT class=inputstyle type=text  name="jobtitlename" onchange='checkinput("jobtitlename","jobtitlenamespan")' value="<%=(strObj==null?"":strObj[1])%>">
					</wea:required>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(15855,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="jobactivityid" browserValue="<%=(strObj==null?jobactivite:strObj[2])%>" 
            browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobactivities/JobActivitiesBrowser.jsp?selectedids="
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
            browserSpanValue="<%=JobActivitiesComInfo.getJobActivitiesname((strObj==null?jobactivite:strObj[2])) %>"
            completeUrl="/data.jsp?type=jobactivity" linkUrl="/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id=" width="300px" hasAdd="true"
            addUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobactivities/HrmJobActivitiesAdd.jsp?isdialog=1&isBrowser=1" dialogWidth="500" dialogHeight="300"
            ></brow:browser>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(15856,user.getLanguage())%></wea:item>
				<wea:item><textarea class=inputstyle style="width:95%" rows=4 name="jobresponsibility" ><%=(strObj==null?"":strObj[3])%></textarea></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></wea:item>
				 <wea:item>
			<brow:browser name="jobdoc" viewType="0" hasBrowser="true" hasAdd="false" 
		              browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
		              completeUrl="/data.jsp?type=9"  linkUrl="/docs/docs/DocDsp.jsp?id=" width="300px"  />		
		</wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(895,user.getLanguage())%></wea:item>
			  <wea:item><textarea class=inputstyle style="width:95%" rows=4 name="jobcompetency" ><%=(strObj==null?"":strObj[4])%></textarea></wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
			  <wea:item><TEXTAREA class=inputstyle name=jobtitleremark rows=8 style="width:95%"><%=(strObj==null?"":strObj[5])%></TEXTAREA></wea:item>
			</wea:group>
		</wea:layout>
<input class=inputstyle type="hidden" name=operation value=add>
</form>
 <%if("1".equals(isDialog)){ %>
 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
		    <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
function submitData() {
  if(check_form(frmMain,'jobtitlemark,jobtitlename,jobactivityid')){
  frmMain.submit();
  }
}
function encode(str){
       return escape(str);
    }     
jQuery(document).ready(function(){
	checkinput("jobtitlemark","jobtitlemarkspan");
	checkinput("jobtitlename","jobtitlenamespan");
});
</script>
</BODY>
</HTML>