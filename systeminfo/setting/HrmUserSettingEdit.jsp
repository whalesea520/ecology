
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingHandler" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSetting" %>
<%@page import="weaver.systeminfo.setting.HrmUserSettingComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceBelongtoComInfo" class="weaver.hrm.resource.ResourceBelongtoComInfo" scope="page" />
<jsp:useBean id="rtxconfig" class="weaver.rtx.RTXConfig" scope="page" />

<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17627,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid=0;
userid=user.getUID();

HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
String id =userSetting.getId(String.valueOf(userid));

HrmUserSettingHandler handler = new HrmUserSettingHandler();
HrmUserSetting setting = handler.getSetting(user.getUID());
boolean rtxload = setting.isRtxOnload();
String isload = "0";
if(rtxload){
	isload = "1";
}
if(id.equals("")){
	RecordSet.execute("insert into HrmUserSetting(resourceid,rtxOnload,isCoworkHead,skin,cutoverWay,transitionTime,transitionWay) values("+userid+","+isload+",1,'','','','')");
	userSetting.removeHrmUserSettingComInfoCache();
	userSetting=new HrmUserSettingComInfo();
	id =userSetting.getId(String.valueOf(userid));
}	

String rtxOnload=userSetting.getRrxOnload(id);
String isPageAutoWrap = userSetting.getIsPageAutoWrap(id);
String belongtoshow = userSetting.getBelongtoshow(id);
List lsUser = ResourceBelongtoComInfo.getBelongtousers(""+userid);
String isRtxEnable = rtxconfig.getPorp("isusedtx");
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
  </head>
  
  <body>
  
  <table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="onSubmit();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
  
  <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
  <%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

  %>
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="HrmUserSettingOperation.jsp">
	<input type=hidden name=id  value="<%=id%>">
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33396,user.getLanguage())%>'>
			  <%if(isRtxEnable.equals("1")){ %>
				  <wea:item>IM<%=SystemEnv.getHtmlLabelName(24701,user.getLanguage())%></wea:item>
				  <wea:item>
					<input type="checkbox" tzCheckbox="true" name=rtxOnload  value="1" <% if(rtxOnload.equals("1")) {%>checked<%}%>>
				  </wea:item>
				<%} %>
			   <wea:item><%=SystemEnv.getHtmlLabelName(34286,user.getLanguage())%></wea:item>
			  <wea:item>
				<input type="checkbox" tzCheckbox="true" name=isPageAutoWrap  value="1" <% if(isPageAutoWrap.equals("1")) {%>checked<%}%>>
			  </wea:item>
			  <%
			  if(flagaccount&&!user.getAccount_type().equals("1")&& lsUser!=null && lsUser.size()>0 ){ %>
			  <wea:item><%=SystemEnv.getHtmlLabelName(82656,user.getLanguage())%></wea:item>
			  <wea:item>
					<input type="radio" id=belongtoshow name=belongtoshow  value="1" <% if(belongtoshow.equals("1")) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(82657,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" id=belongtoshow name=belongtoshow  value="0" <% if(belongtoshow.equals("0")) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(82658,user.getLanguage())%>
			  </wea:item>
			  <%} %>
		</wea:group>
	</wea:layout>
		
			
</FORM>
<script language="javascript">
function onSubmit()
{
	frmMain.submit();
}
</script>
  </body>
</html>
