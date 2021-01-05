
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingHandler" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSetting" %>
<%@page import="weaver.systeminfo.setting.HrmUserSettingComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />
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

int isShowLeftMenu = 1;
String isRemeberTab = "1";
RecordSet.execute("select isshowleftmenu,isremembertab  from PageUserDefault where userid="+user.getUID());
if(RecordSet.next()){
	isShowLeftMenu = RecordSet.getInt("isshowleftmenu");
	isRemeberTab = RecordSet.getString("isremembertab");
}
String isShowLeftMenuChecked="";
String isRemeberTabChecked = "checked";
if(isShowLeftMenu==1){
	isShowLeftMenuChecked="checked";
}
if("0".equals(isRemeberTab)){
	isRemeberTabChecked ="";
}
String rtxOnload=userSetting.getRrxOnload(id);

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
  </head>
  
  <body>
  
  
  <table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">				
				<input id="btnSave" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top" onclick="doSave()" />
				<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
  <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <%
	RCMenu += "{"+ SystemEnv.getHtmlLabelName(86,user.getLanguage()) +",javascript:doSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
  <form id="weaver" name=frmmain action="PageUserDefaultOperation.jsp" method=post >
	
	<input type=hidden name=id  value="<%=id%>">
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(17721,user.getLanguage())%>'>
			  <wea:item><%=SystemEnv.getHtmlLabelName(33676,user.getLanguage())%></wea:item>
			  <wea:item>
					<img class="setting" src="/images/homepage/style/setting_wev8.png" onclick="topMenuCustom(this)" url="/homepage/maint/HomepageTabs.jsp?openDialog=front&_fromURL=hpMenu&type=top&isCustom=true&resourceType=3&resourceId=<%=user.getUID()%>">
			  </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(33675,user.getLanguage())%></wea:item>
			  <wea:item>
					<img class="setting" src="/images/homepage/style/setting_wev8.png" onclick="leftMenuCustom(this)" url="/homepage/maint/HomepageTabs.jsp?openDialog=front&_fromURL=hpMenu&type=left&isCustom=true&resourceType=3&resourceId=<%=user.getUID()%>">
			  </wea:item>
			   <wea:item><%=SystemEnv.getHtmlLabelName(81950,user.getLanguage())%></wea:item>
			  <wea:item>
					<input type="checkbox" tzcheckbox="true"  <%=isShowLeftMenuChecked %> class="InputStyle" name="isshowleftmenu" value="1">
			  </wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33434,user.getLanguage())%>'>
			 <%
		String strHpSql="select id,infoname,subcompanyid from hpinfo where  isuse='1' and Subcompanyid>0 ";
		if(user.getUID()==1) { //系统管理员
			
		} else { //普通管理员及分部管理员
			strHpSql+=" and islocked='0' and id in (" +hpu.getShareHomapage(user)+ ") ";
		}
		//out.println(strHpSql);
		RecordSet.executeSql(strHpSql);
			while (RecordSet.next()){
			String tempId=Util.null2String(RecordSet.getString("id"));
			String tempName=Util.null2String(RecordSet.getString("infoname"));	
			String tempSubcompanyid=Util.null2String(RecordSet.getString("subcompanyid"));	
			String tempUrl="/homepage/maint/HomepageTabs.jsp?_fromURL=ElementSetting&customSetting=true&isSetting=true&from=addElement&hpid="+tempId+"&subCompanyId="+tempSubcompanyid;
			
			
		%>
		 <wea:item><%=tempName%></wea:item>
			  <wea:item>
					<img class="setting" src="/images/homepage/style/setting_wev8.png"  hpname="<%=tempName%>" onclick="homepageCustom(this)" url="<%=tempUrl %>">
			  </wea:item>
			
		<%} %>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(126226,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(126225,user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT type="checkbox" tzCheckbox="true" <%=isRemeberTabChecked %> class=InputStyle name="isRemeberTab" value="1" >
			</wea:item>
		</wea:group>
	</wea:layout>
		
	<script type="text/javascript">
		function leftMenuCustom(obj){
			var theme_imp = new window.top.Dialog();
			theme_imp.currentWindow = window;   //传入当前window
		 	theme_imp.Width = 400;
		 	theme_imp.Height = 500;
		 	theme_imp.maxiumnable=true;
		 	theme_imp.Modal = true;
		 	theme_imp.Title = "<%=SystemEnv.getHtmlLabelName(33675,user.getLanguage())%>"; 
		 	theme_imp.URL = $(obj).attr("url");
		 	theme_imp.show();
			
		}
		function topMenuCustom(obj){
			var theme_imp = new window.top.Dialog();
			theme_imp.currentWindow = window;   //传入当前window
		 	theme_imp.Width = 400;
		 	theme_imp.Height = 500;
		 	theme_imp.maxiumnable=true;
		 	theme_imp.Modal = true;
		 	theme_imp.Title = "<%=SystemEnv.getHtmlLabelName(33676,user.getLanguage())%>";
		 	theme_imp.URL = $(obj).attr("url");
		 	theme_imp.show();
			
		}
		
		function homepageCustom(obj){
			var theme_imp = new window.top.Dialog();
			theme_imp.currentWindow = window;   //传入当前window
		 	theme_imp.Width = top.document.body.clientWidth;
		 	theme_imp.Height = top.document.body.clientHeight;
		 	theme_imp.maxiumnable=true;
		 	theme_imp.Modal = true;
		 	theme_imp.Title = "<%=SystemEnv.getHtmlLabelName(18437,user.getLanguage())%>-"+$(obj).attr("hpname"); 
		 	theme_imp.URL = $(obj).attr("url");
		 	theme_imp.show();
		}
		$(".setting").hover(function(){
				$(this).attr("src","/images/homepage/style/settingOver_wev8.png")
			},function(){
				$(this).attr("src","/images/homepage/style/setting_wev8.png")
			})
			
		function doSave(){
			$("#weaver")[0].submit();
		}
	</script>	
	<style>
		.setting{
			cursor: pointer;
		}
	</style>		

  </body>
</html>
