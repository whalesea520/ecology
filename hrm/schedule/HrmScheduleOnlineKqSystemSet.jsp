
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id = "SubCompanyComInfo" class = "weaver.hrm.company.SubCompanyComInfo" scope = "page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
if(!HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit" , user)) { 
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
} 
boolean CanEdit = HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit" , user) ; 
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String msg = Util.null2String(request.getParameter("msg"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var parentDialog = parent.parent.getDialog(parent);
var dialog = null;
if("<%=isclose%>"=="1"){
		parentWin.closeDialog();	
		parentWin.onBtnSearchClick();
	}
function closeDialog(){
	if(dialog)
		dialog.close();
}
</script>
</head>
<%
int id = Util.getIntValue(Util.null2String(request.getParameter("id")),0);

String sql = "select needSign, onlyworkday, signTimeScope, signIpScope,relatedid from HrmSchedule where id="+id;
RecordSet.execute(sql);
RecordSet.first();
String needSign = Util.null2String(RecordSet.getString("needSign")) ; //是否启用签到功能
String onlyworkday = Util.null2String(RecordSet.getString("onlyworkday"));//是在工作日显示
String signTimeScope = Util.null2String(RecordSet.getString("signTimeScope"));//是在工作日显示
String signIpScope = Util.null2String(RecordSet.getString("signIpScope")) ; //签到签退ip
int relatedid = Util.getIntValue(RecordSet.getString("relatedid"),0);

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32536,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanEdit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmmain id=frmmain method=post action="HrmScheduleOnlineKqSystemSetOperation.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(CanEdit){ %>
				<input type=button class="e8_btn_top" onclick="onSubmit();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
if("1".equals(msg)){
%>
<div style="font: bold;color: red;"><%=SystemEnv.getHtmlLabelName(126501,user.getLanguage()) %></div>
<%}
 %>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(34169,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(32537,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="needSign" name="needSign" value="1" <%=needSign.equals("1")?"checked":"" %>>			
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(83867,user.getLanguage())%>" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33554,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="onlyworkday" name="onlyworkday" value="1" <%=onlyworkday.equals("1")?"checked":"" %>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(32539,user.getLanguage())%></wea:item>
	  <wea:item>
		<input name=signTimeScope id=signTimeScope value="<%=signTimeScope%>" size=80 maxlength=200  class=InputStyle>
		<br><%=SystemEnv.getHtmlLabelName(15196,user.getLanguage())%>：08:00-12:00&nbsp;<%=SystemEnv.getHtmlLabelName(32541,user.getLanguage())%>
	  </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(32540,user.getLanguage())%></wea:item>
	  <wea:item>
		<input name=signIpScope id=signIpScope onBlur='checkinput("signIpScope","signIpScopeImage")' value="<%=signIpScope%>" size=80 maxlength=1000  class=InputStyle><SPAN id=signIpScopeImage>
		<%if(signIpScope.equals("")){%>					
			<IMG src = "/images/BacoError_wev8.gif" align=absMiddle>
		<%}%>	
		</SPAN>
		<br><%=SystemEnv.getHtmlLabelName(15196,user.getLanguage())%>：10.*.*.*;10.16.0.12;10.16.0.13-10.16.0.18
	  </wea:item>
	  
	  <%
		//只有分部的时候才会显示
		if(relatedid > 0){
	   %>
    <wea:item><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
    <wea:item>
	    <brow:browser viewType="0" name="relatedid" browserValue='<%=""+relatedid %>' 
       browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' 
       browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(""+relatedid) %>'></brow:browser>
    </wea:item>
    <%
    } %>
	</wea:group>
</wea:layout>
<input type="hidden" value="<%=id %>" name="id">
</FORM>
 <%if("1".equals(isDialog)){ %>
 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
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
<script language="javascript">
function onSubmit() {
	//if(check_form(frmmain,"signTimeScope")){
  
  //}
  //document.frmmain.submit();
   if(check_form(document.frmmain,'signIpScope')){
   document.frmmain.submit();
   }    
}

</script>
</BODY>
</HTML>
