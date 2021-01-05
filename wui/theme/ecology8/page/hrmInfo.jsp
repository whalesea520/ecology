
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.Util,weaver.hrm.User,
                 weaver.rtx.RTXExtCom,
                 weaver.hrm.settings.BirthdayReminder,
                 weaver.hrm.settings.RemindSettings,
                 weaver.systeminfo.setting.HrmUserSettingHandler,
                 weaver.systeminfo.setting.HrmUserSetting,
                 weaver.general.TimeUtil,
                 weaver.hrm.report.schedulediff.HrmScheduleDiffUtil,
				 weaver.login.Account" %>
<%@page import="weaver.hrm.common.Tools"%>
<%@page import="java.sql.Timestamp"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="signRs" class="weaver.conn.RecordSet" scope="page"/>

<%@ include file="/wui/common/page/initWui.jsp" %>
<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
  response.sendRedirect("/login/Login.jsp");
  return;
}

int userId=user.getUID();
boolean canMessager=false;
boolean isHaveEMessager=Prop.getPropValue("Messager2","IsUseEMessager").equalsIgnoreCase("1");
boolean isHaveMessager=Prop.getPropValue("Messager","IsUseWeaverMessager").equalsIgnoreCase("1");
int isHaveMessagerRight = PluginUserCheck.checkPluginUserRight("messager",userId+"");
if((isHaveMessager&&userId!=1&&isHaveMessagerRight==1)||isHaveEMessager){
	canMessager=true;
}

String strDepartment=DepartmentComInfo.getDepartmentname(String.valueOf(user.getUserDepartment()));
%>

<%
Map pageConfigKv = getPageConfigInfo(session, user);
String islock = (String)pageConfigKv.get("islock");
%>

<script language=javascript> 
//------------------------------------
//多账号 Start
//------------------------------------
function onCheckTime(obj){
	window.location = "/login/IdentityShift.jsp?shiftid="+obj.value;
}

function changeAccount(obj){
	window.location = "/login/IdentityShift.jsp?shiftid="+$(obj).attr("userid");
}

var firstTime = new Date().getTime();
function setAccountSelect(){
    var nowTime = new Date().getTime();
    if((nowTime-firstTime) < 10000){
    	setTimeout(function(){setAccountSelect();},1000);
    }else{
        try{
            document.getElementById("accountSelect").disabled = false;
            jQuery("#accountText").html(jQuery("#accountSelect").find("option:selected").text());
			jQuery("#accountText").attr("title", jQuery("#accountSelect").find("option:selected").text());
			jQuery("#accountSelect").hide();
			jQuery("#accountText").show();
        }catch(e){}
    }
}
setAccountSelect();

jQuery(document).ready(function () {
	
	if (jQuery("#accountSelect")[0]) {
		jQuery("#leftBlockHrmDep").hover(function () {
			jQuery("#accountText").html("");
			jQuery("#accountText").hide();
			jQuery("#accountSelect").show();
			jQuery("#accountSelect").focus();
		}, function () {
		});
		jQuery("#accountSelect").bind("blur", function () {
			jQuery("#accountText").html(jQuery("#accountSelect").find("option:selected").text());
			jQuery("#accountText").attr("title", jQuery("#accountSelect").find("option:selected").text());
			jQuery("#accountSelect").hide();
			jQuery("#accountText").show();
		});
	}
});

//设置个人头像
var userIconDialog;
function setUserIcon(){
    userIconDialog = new Dialog();
	userIconDialog.Width = 600;
	userIconDialog.Height = 450;
	userIconDialog.Title = "<%=SystemEnv.getHtmlLabelName(28062,user.getLanguage())%>";//设置个人头像
	userIconDialog.Modal  = false;
	userIconDialog.URL = "/messager/GetUserIcon.jsp?loginid=<%=user.getLoginid()%>&requestFrom=homepage";
	userIconDialog.show();
   
}

</script> 


<div style="position:relative;height:100%">

    <!-- 更换皮肤设置 Start -->
    <div  style="position:absolute;left:63px;top:16px;font-size:12px;height:16px;right:0px;">
       <span style="float:right;">
      
       </span>
    </div>
    <!-- 更换皮肤设置 End -->
    
	<div title="<%=user.getLastname()%>" class="hrminfo_fontcolor leftColor hand" style="max-width:100px;float: left;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;" onclick="window.open('/hrm/HrmTab.jsp?_fromURL=HrmResource','mainFrame')">
	   <%=user.getLastname() %>
	   
	</div>
<%

//多账号
String userid = ""+user.getUID() ;
%>	
<%if(weaver.general.GCONST.getMOREACCOUNTLANDING()){%>
	
	<%List accounts =(List)session.getAttribute("accounts");
    	if(accounts!=null&&accounts.size()>1){
        	Iterator iter=accounts.iterator();
        	int tmpCount = 0;
	%>
		<!-- <select id="accountSelect" name="accountSelect" onchange="onCheckTime(this);"  disabled style="width:100px;height:20px;font-size:11px;">
			
            
        </select>
        -->
      
         <div id="accountChange" class="" style="float:left;position: relative;margin-left:20px" >
			        		
			        		
			        	<img onclick="showAccoutList()" id="accoutImg"  src="/wui/theme/ecology8/page/images/hrminfo/accout_wev8.png" style="position:absolute;top:13px;cursor:pointer;">
		        		
			        	<div class="accoutList" id="accoutList" style="display: none;">
			        		<div style="height:10px;width:15px;z-index:101;top: 0px;position: absolute;background:url(/images/topnarrow.png) no-repeat;"></div>
			        		<div class="accoutListBox" style="max-height: 600px;overflow: hidden;">
			        		<% while(iter.hasNext()){
			        			Account a=(Account)iter.next();
				            	String subcompanyname=SubCompanyComInfo.getSubCompanyname(""+a.getSubcompanyid());
				              	String departmentname=DepartmentComInfo.getDepartmentname(""+a.getDepartmentid());
				            	String jobtitlename=JobTitlesComInfo.getJobTitlesname(""+a.getJobtitleid());  
				            	String userName = ResourceComInfo.getResourcename(""+a.getId());
				            %>
				            
							<div class="accountItem " userid="<%=a.getId() %>" onclick="changeAccount(this)">
									<div class="accountText">
										<font color="#363636" title="<%=userName %>"><%=userName%></font>&nbsp;&nbsp;&nbsp;&nbsp;<font color="#0071ca" title="<%=jobtitlename %>"><%=jobtitlename %></font>
										<br>
										<font color="#868686"  title="<%=subcompanyname +"/"+departmentname %>"><%=subcompanyname +"/"+departmentname %></font>
									</div >
									
									<div class="accountIcon">
									<%if(userid.equals(a.getId()+"")){ %>
										<img style="width: 16px;height: 16px;vertical-align: middle;" src="/images/check.png">
									<%} %>
									</div>
									<div style="clear:both;"></div>
							</div>
							<%if(++tmpCount < accounts.size()) {%>
							<div style="background-color:#d4d4d4;height:1px;width:188px;"></div>
							<%} %>
							<%} %>
							</div>
						</div>
		</div>	
       
	<%}else{%>
	<div id="leftBlockHrmDep"  style="float:left; cursor:default;overflow:hidden;width: 100px;" class="leftBlockHrmDep leftColor" title="<%=strDepartment%>"><%=strDepartment%></a></div>
<%}} else {%>
	<div id="leftBlockHrmDep"  style="float:left;cursor:default;overflow:hidden;width: 100px;" class="leftBlockHrmDep leftColor" title="<%=strDepartment%>"><%=strDepartment%></a></div>
<%} %>
	
		

	<div  style="position:absolute;width:41px;height:41px;left:14px;top:17px;display:none;">
		<%
			boolean isHaveMessagerUrl=false;
			String messagerUrl=ResourceComInfo.getMessagerUrls(""+userId);
			if(messagerUrl.indexOf("dummyContact_wev8.png")==-1) isHaveMessagerUrl=true;
		%>
		<%if(isHaveMessagerUrl){%>
		<img src="<%=ResourceComInfo.getMessagerUrls(""+userId)%>" border="0" width="38" height="37" onclick="setUserIcon()" title="<%=SystemEnv.getHtmlLabelName(28062,user.getLanguage())%>" id="userIcon" style="cursor: pointer;">
		<%}%>
	</div>
	<script type="text/javascript">
	 jQuery(document).ready(function(){
        if("<%=userid%>"=="1"){
        	jQuery(userIcon).removeAttr("onclick");
        	jQuery(userIcon).removeAttr("title");
        }

    });
	</script>
	<div  class="more" style="display:none;">
		<table cellpadding="0px" cellspacing="0px" id="tblHrmToolbr" align="left">
			<tr>
				<!-- 解决因ie6下png透明引起img图片空白显示的bug -->
				<td ><a  href="/newportal/contactslist.jsp"  title='<%=SystemEnv.getHtmlLabelName(1515,user.getLanguage())%>'   target="mainFrame" style><span  class="quickImg" style="background:url(/wui/theme/ecology8/page/images/hrminfo/address_wev8.png) no-repeat;"></span></a></td>
				<td ><a  href="/workflow/request/RequestView.jsp" title='<%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%>'    target="mainFrame" style><span class="quickImg"  style="background:url(/wui/theme/ecology8/page/images/request/unhandle_wev8.png) no-repeat;"></span></a></td>
				
				<td><a  href="#" title='<%=SystemEnv.getHtmlLabelName(27603,user.getLanguage())%>'    target="mainFrame" style><span  class="quickImg"  style="background:url(/wui/theme/ecology8/page/images/email/email_wev8.png) no-repeat;"></span></a></td>
				<td><a  href="#" title='<%=SystemEnv.getHtmlLabelName(26274,user.getLanguage())%>'    target="mainFrame" style><span  class="quickImg"  style="background:url(/wui/theme/ecology8/page/images/theme_wev8.png) no-repeat;"></span></a></td>
				<!--<td width="24px"><a  href="/hrm/resource/HrmResource.jsp?id=<%=userId%>"title='<%=SystemEnv.getHtmlLabelName(16415,user.getLanguage())%>'    target="mainFrame" style><span style="cursor:pointer;height:16px;width:16px;display:block;overflow:hidden;background:url(/wui/theme/ecology8/page/images/hrminfo/card_wev8.png) no-repeat;"></span></a></td>-->
				<td width="24px"><a  href="/hrm/resource/HrmResourcePassword.jsp?id=<%=userId%>" title='<%=SystemEnv.getHtmlLabelName(17993,user.getLanguage())%>'   target="mainFrame" style><span class="quickImg"  style="background:url(/wui/theme/ecology8/page/images/hrminfo/psw_wev8.png) no-repeat;"></span></a></td>
				<%if(canMessager){%>	
				<td ><div class="quickImg" id="tdMessageState" style="cursor:pointer;font-size:11px;color:#666;position:relative;background:url(/wui/theme/ecology8/page/images/request/info_wev8.png) no-repeat;"></div>	</td>
				<%}%>
				<!--<td width="24px"><a  href="/org/OrgChartHRM.jsp" title='<%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%>'  target="mainFrame" style><span style="cursor:pointer;height:16px;width:16px;display:block;overflow:hidden;background:url(/wui/theme/ecology8/page/images/hrminfo/org_wev8.png) no-repeat;"></span></a></td>-->
				<!--  <td width="24px"><a  href="/workplan/data/WorkPlan.jsp" title='<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>'  target="mainFrame" style><img  src="/wui/theme/ecology8/page/images/hrminfo/cal_wev8.gif" border="0"></a></td>-->
				<!--<td  align="left">
					<%if(canMessager){%>					
						<div id="tdMessageState" style="cursor:pointer;font-size:11px;color:#666;position:relative;"></div>	
					<%} else {%>
					&nbsp;
					<%}%>
				</td>-->
			</tr>
		</table>

		
	</div>
</div>


<script type="text/javascript">
	$('.accoutListBox').perfectScrollbar();
</script>

<%!
	private String formatDate(String format, Date date) {
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		Calendar calendar = Calendar.getInstance();
		if (date == null) {
			date = new Date();
		}
		calendar.setTime(date);
		return sdf.format(calendar.getTime());
}
%>