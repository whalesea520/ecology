
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.general.Util,weaver.hrm.User,
                 weaver.rtx.RTXExtCom,
                 weaver.hrm.settings.BirthdayReminder,
                 weaver.hrm.settings.RemindSettings,
                 weaver.systeminfo.setting.HrmUserSettingHandler,
                 weaver.systeminfo.setting.HrmUserSetting,
                 weaver.general.TimeUtil,
				 weaver.login.Account" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
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
boolean isHaveMessager=Prop.getPropValue("Messager","IsUseWeaverMessager").equalsIgnoreCase("1");
int isHaveMessagerRight = PluginUserCheck.checkPluginUserRight("messager",userId+"");
if(isHaveMessager&&userId!=1&&isHaveMessagerRight==1){
	canMessager=true;
}

String strDepartment=DepartmentComInfo.getDepartmentname(String.valueOf(user.getUserDepartment()));
%>

<%
Map pageConfigKv = getPageConfigInfo(session, user);
String islock = (String)pageConfigKv.get("islock");
%>

<script language=javascript> 

function showSkinListDialog(){
	var diag_xx = new Dialog();
	diag_xx.Width = 500;
	diag_xx.Height = 440;
	
	diag_xx.ShowCloseButton=true;
	diag_xx.Title = "<%=SystemEnv.getHtmlLabelName(27714, user.getLanguage())%>";//"主题中心";
	diag_xx.Modal = false;

	diag_xx.URL = "/wui/theme/ecology7/page/skinList.jsp";
	diag_xx.show();
}

//------------------------------------
//多账号 Start
//------------------------------------
function onCheckTime(obj){
	window.location = "/login/IdentityShift.jsp?shiftid="+obj.value;
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
    <div  style="position:absolute;left:63px;top:5px;font-size:12px;height:16px;right:25px;">
       <span style="float:right;margin-right:2px;">
       <%
       if (islock == null || !"1".equals(islock)) {
       %>
           <img src="/wui/theme/ecology7/page/images/skin/skinSetting_wev8.png" title="<%=SystemEnv.getHtmlLabelName(27714, user.getLanguage())%>" style="height:16px;widht:16px;display:block;" style="cursor:pointer;" onclick="javascript:showSkinListDialog();" id="themeQh"/>
       <%
       }
       %>    
       </span>
    </div>
    <!-- 更换皮肤设置 End -->
    
	<div  style="position:absolute;left:63px;top:16px;font-size:12px;color:#006699;font-weight:bold" class="hrminfo_fontcolor">
	   <%=user.getLastname()%>
	</div>
<%
//多账号
String userid = ""+user.getUID() ;
%>	

<%if(weaver.general.GCONST.getMOREACCOUNTLANDING()){%>
	
	<%List accounts =(List)session.getAttribute("accounts");
    	if(accounts!=null&&accounts.size()>1){
        	Iterator iter=accounts.iterator();
	%>
	<div id="leftBlockHrmDep" style="position:absolute;left:63px;top:37px;font-size:11px;color:#666;cursor:pointer;text-overflow:ellipsis;white-space:nowrap;width:110px;">
		<select id="accountSelect" name="accountSelect" onchange="onCheckTime(this);"  disabled style="width:100px;height:20px;font-size:11px;">
			<% while(iter.hasNext()){Account a=(Account)iter.next();
            String subcompanyname=SubCompanyComInfo.getSubCompanyname(""+a.getSubcompanyid());
            String departmentname=DepartmentComInfo.getDepartmentname(""+a.getDepartmentid());
            String jobtitlename=JobTitlesComInfo.getJobTitlesname(""+a.getJobtitleid());                       
            %>
            <option <%if((""+a.getId()).equals(userid)){%>selected<%}%> value=<%=a.getId()%>><%=subcompanyname+"/"+departmentname+"/"+jobtitlename%></option>
            <%}%>
        </select>
        <div style="height:100%;width:100%;overflow:hidden;display:none;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;" id="accountText">
        </div>
    </div>
	<%}%>
<%} else {%>
	<div id="leftBlockHrmDep" style="position:absolute;left:63px;top:37px;font-size:11px;color:#666;cursor:pointer;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:110px;" title="<%=strDepartment%>"><%=strDepartment%></a></div>
<%} %>
	
	
	<div  style="position:absolute;width:41px;height:41px;left:14px;top:17px;">
		<%
			boolean isHaveMessagerUrl=false;
			String messagerUrl=ResourceComInfo.getMessagerUrls(""+userId);
			if(messagerUrl.indexOf("dummyContact_wev8.png")==-1) isHaveMessagerUrl=true;
		%>
		<%if(isHaveMessagerUrl){%>
		<img src="<%=ResourceComInfo.getMessagerUrls(""+userId)%>" border="0" width="38" height="37" onclick="setUserIcon()" title="<%=SystemEnv.getHtmlLabelName(28062,user.getLanguage())%>" id="userIcon" style="cursor: pointer;">
		<%}%>
	</div>
	<div  style="position:absolute;width:170px;height:18px;left:8px;top:66px;">
		<table width="100%" cellpadding="0px" cellspacing="0px" id="tblHrmToolbr" align="left">
			<tr>
				<!-- 解决因ie6下png透明引起img图片空白显示的bug -->
				<td width="24px"><a  href="/newportal/contactslist.jsp"  title='<%=SystemEnv.getHtmlLabelName(1515,user.getLanguage())%>'   target="mainFrame" style><span style="cursor:pointer;height:16px;width:16px;display:block;overflow:hidden;background:url(/wui/theme/ecology7/page/images/hrminfo/address_wev8.png) no-repeat;"></span></a></td>
				<td width="24px"><a  href="/hrm/resource/HrmResource.jsp?id=<%=userId%>"title='<%=SystemEnv.getHtmlLabelName(16415,user.getLanguage())%>'    target="mainFrame" style><span style="cursor:pointer;height:16px;width:16px;display:block;overflow:hidden;background:url(/wui/theme/ecology7/page/images/hrminfo/card_wev8.png) no-repeat;"></span></a></td>
				<td width="24px"><a  href="/hrm/resource/HrmResourcePassword.jsp?id=<%=userId%>" title='<%=SystemEnv.getHtmlLabelName(17993,user.getLanguage())%>'   target="mainFrame" style><span style="cursor:pointer;height:16px;width:16px;display:block;overflow:hidden;background:url(/wui/theme/ecology7/page/images/hrminfo/psw_wev8.png) no-repeat;"></span></a></td>
				<td width="24px"><a  href="/org/OrgChartHRM.jsp" title='<%=SystemEnv.getHtmlLabelName(25332,user.getLanguage())%>'  target="mainFrame" style><span style="cursor:pointer;height:16px;width:16px;display:block;overflow:hidden;background:url(/wui/theme/ecology7/page/images/hrminfo/org_wev8.png) no-repeat;"></span></a></td>
				<!--  <td width="24px"><a  href="/workplan/data/WorkPlan.jsp" title='<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>'  target="mainFrame" style><img  src="/wui/theme/ecology7/page/images/hrminfo/cal_wev8.gif" border="0"></a></td>-->
				<td width="*" align="left">
					<%if(canMessager){%>					
						<div id="tdMessageState" style="cursor:pointer;font-size:11px;color:#666;position:relative;"></div>	
					<%} else {%>
					&nbsp;
					<%}%>
				</td>
				<td width="3px" align="right">
					&nbsp;
				</td>
			</tr>
		</table>

		
	</div>
</div>