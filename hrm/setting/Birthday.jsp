<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList,
                 java.util.Iterator,
                 weaver.general.TimeUtil,
                 weaver.hrm.settings.RemindSettings,
                 weaver.hrm.settings.BirthdayReminder" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
                 <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

String today = TimeUtil.getCurrentDateString();
ArrayList<String[]> birthEmployers=(ArrayList<String[]>)application.getAttribute("birthEmployers");
String themeType=request.getParameter("theme"); //主题类型，用户区分弹出生日提醒是否自动关闭

//生日提醒参数
//RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
BirthdayReminder birth_reminder = new BirthdayReminder();
RemindSettings settings = birth_reminder.getRemindSettings();
int birthdialogstyle = Util.getIntValue(settings.getBirthdialogstyle(),1);//弹窗样式
String birthshowfield = settings.getBirthshowfield();//显示字段
String congratulation=Util.stringReplace4DocDspExt(settings.getCongratulation());
%>
<script>
<%if(!"ecology8".equals(themeType)){%>	
    //setTimeout('parent.closeDialog();',10000);
<%}%>
</script>                 
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(17534, user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#trBoday").height(228-jQuery("#trTitle").height());
	jQuery("#ma_namelist").height(218-jQuery("#trTitle").height());
	
})
</script>
</head>
<%
String url = "";
String url1 = "";
int rowIndex = 0;
rs.executeSql("select docid,docname from HrmResourcefile " 
		+ " where resourceid='0' and scopeId ='-99' and fieldid='-99' order by id");
while(rs.next()){
	rowIndex++;
	if(birthdialogstyle==rowIndex){
		url ="/weaver/weaver.file.FileDownload?fileid="+Util.null2String(rs.getString("docid"));
	}
}
%>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" style="overflow: hidden;">
<table width="499px" cellspacing="0" cellpadding="0" align="center" style ="height:475px;border-collapse:collapse;border-spacing:0;"
background="<%=url.length()==0?"/images_face/ecologyFace_1/BirthdayFace/1/BirthdayBg_3_wev8.jpg":url %>">
  <!--  
  <tr><td align="left" valign="top" height="247px"><img style="display:block;" src="/images_face/ecologyFace_1/BirthdayFace/1/BirthdayBg_1_wev8.jpg"></td></tr>
  -->
  <tr style="height: 247px"><td align="left" valign="top"></td></tr>
  <tr id="trTitle"> 
    <td valign="top"> 
      <table width="100%" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="30px">&nbsp;</td>
          <td align="left" valign="top"><font color="#FFFFFF"><%=congratulation %></font></td>
          <td width="30px">&nbsp;</td>
        </tr>
        <tr>
        	<td width="30px">&nbsp;</td>
        	<td style="text-align: right;"><font color="#FFFFFF"><%=today %></font></td>
        	<td width="30px">&nbsp;</td>
        </tr>
        </table>
       </td>
	</tr>
  <tr id="trBoday">
  	<td valign="top">
        <table width="100%" cellspacing="0" cellpadding="0" border=0> 
        <tr>
          <td width="30">&nbsp;</td>
          <td align="left" valign="top"> 
          	<%
          	 if(birthEmployers!=null && birthEmployers.size()>=6){
          	%>
          	<MARQUEE id="ma_namelist"  style="LINE-HEIGHT: 15px;height: 150px" 
          	onMouseOut="this.start()" onMouseOver="this.stop()"
          	scrollAmount=2 scrollDelay=0 direction="up" style="width:100%;" >
					  <% }%>
          	<p style="left">
           		<table style="width: 100%">
          	<%
              //BirthdayReminder birth_reminder = new BirthdayReminder();
              //birthEmployers = birth_reminder.getBirthEmployerNames(user);
              //out.println(user.getUID()+"==="+user.getUserSubCompany1());
              if(birthEmployers!=null){
              Iterator<String[]> iter=birthEmployers.iterator();
              String[] empInfo = null;
              while(iter.hasNext()){
              	empInfo = iter.next();
              	String comInfo = "";
              	String nameInfo = "";
              	for(int i=1;empInfo!=null&&i<empInfo.length;i++){
              		if(Util.null2String(empInfo[i]).length()==0)continue;
              		if(birthshowfield.indexOf("3")==-1 && i==1)continue;//分部
              		if(birthshowfield.indexOf("2")==-1 && i==2)continue;//部门
              		if(comInfo.length()>0)comInfo+="--";
              		comInfo+=empInfo[i];
              	}
            		nameInfo=empInfo[0];
              %>
              		<tr style="height: 18px">
              			<td style="width: 65px;color: #FFFFFF"><%=nameInfo%></td>
              			<td style="text-align: left;color: #FFFFFF">
              				<%if(comInfo.length()>0){ %><%=comInfo %><%} %>
              			</td>
              		</tr>
              <%}%>
              	</table>
             	</p>
              <%}
              if(birthEmployers!=null && birthEmployers.size()>=6){
              %>
						</MARQUEE>
						<%} %>
          </td>
          <td width="30">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
