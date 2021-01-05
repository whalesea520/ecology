
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.Prop,
                 weaver.general.GCONST,
                 weaver.hrm.settings.RemindSettings" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<%
String id = request.getParameter("id");  
int hrmid = user.getUID();
int isView = Util.getIntValue(request.getParameter("isView"));
int departmentid = user.getUserDepartment();

boolean iss = ResourceComInfo.isSysInfoView(hrmid,id);
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
//get login verify mode,xiaofeng
String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
String loginid = "";
String password = "";
String systemlanguage = "";
String email = "";
String seclevel = "";
int status = 0 ;
//needed is a flag which indicate support of usb ,xiaofeng
String needed="" ;
String userUsbType="";
String usbstate="";
int needdynapass_usr=0;
int passwordstate = 1;//动态密码状态，默认为停止1。
int passwordlock = -1;
String tokenKey="";
if(mode!=null&&mode.equals("ldap"))
rs.executeSql("select loginid,password,systemlanguage,email,seclevel,status,needusb,tokenKey,userUsbType,needdynapass,passwordstate,passwordlock,usbstate from HrmResource where id = "+id );
else
rs.executeSql("select loginid,password,systemlanguage,email,seclevel,status,needusb,tokenKey,userUsbType,needdynapass,passwordstate,passwordlock,usbstate from HrmResource where id = "+id );
if(rs.next()){
    loginid = Util.null2String(rs.getString("loginid"));
    password = Util.null2String(rs.getString("password"));
    systemlanguage = Util.null2String(rs.getString("systemlanguage")); 
    email = Util.null2String(rs.getString("email")); 
    seclevel = Util.null2String(rs.getString("seclevel")); 
    status = Util.getIntValue(rs.getString("status"),0);
    needed=String.valueOf(rs.getInt("needusb"));
    userUsbType=Util.null2String(rs.getString("userUsbType"));
    usbstate=Util.null2String(rs.getString("usbstate"));
    needdynapass_usr=rs.getInt("needdynapass");
	passwordstate = rs.getInt("passwordstate");
	passwordlock = rs.getInt("passwordlock");
	tokenKey = Util.null2String(rs.getString("tokenKey")); 
	//System.out.println("00000000000000:"+passwordstate);
	if(passwordstate!=0&&passwordstate!=1&&passwordstate!=2) passwordstate =1;//修改passwordstate的值可实现更改默认状态。0，启动。1，停止。2，网段策略。
	if(!usbstate.equals("0")&&!usbstate.equals("1")&&!usbstate.equals("2")) usbstate ="0";//修改usbstate的值可实现更改默认状态。0，启动。1，停止。2，网段策略。
}
//Start 手机接口功能 by alan
String isMgmsUser = "";
rs.executeSql("SELECT userid FROM workflow_mgmsusers WHERE userid="+id);
if(rs.next()){
	isMgmsUser = "checked";
}
boolean EnableMobile = Util.null2String(Prop.getPropValue("mgms" , "mgms.on")).toUpperCase().equals("Y");
//End 手机接口功能

%>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
  <script>
		var common = new MFCommon();
		function showLog(){
			common.showDialog("/systeminfo/SysMaintenanceLog.jsp?cmd=NOTCHANGE&condition=hidden&sqlwhere=<%=xssUtil.put("where operateitem=421 and relatedid="+id)%>","<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>");
		}
		
		function showSecLog(){
			common.showDialog("/systeminfo/SysMaintenanceLog.jsp?cmd=NOTCHANGE&condition=hidden&sqlwhere=<%=xssUtil.put("where operateitem=89 and relatedid="+id)%>","<%=SystemEnv.getHtmlLabelName(17591,user.getLanguage())%>");
		}
  </script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(468,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
//get the settings about usb,xiaofeng
RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String openPasswordLock = settings.getOpenPasswordLock();
String passwordComplexity = settings.getPasswordComplexity();
String needusb=settings.getNeedusb();
String usbType=settings.getUsbType();
//if(userUsbType.equals("")) userUsbType=usbType;

int needdynapass=settings.getNeeddynapass();
String needusbdefault=settings.getNeedusbdefault();
//added by wcd 2014-12-25 [用户前台设置可在三种辅助校验方式中任选其一] start
int needdynapassdefault = settings.getNeeddynapassdefault();
String needusbHt = settings.getNeedusbHt();
String needusbdefaultHt = settings.getNeedusbdefaultHt();
String needusbDt = settings.getNeedusbDt();
String needusbdefaultDt = settings.getNeedusbdefaultDt();
//added by wcd 2014-12-25 end
//老的分权管理
/*
int detachable=0;
if(session.getAttribute("detachable")!=null){
    detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
}else{
    rs.executeSql("select detachable from SystemSet");
    if(rs.next()){
        detachable=rs.getInt("detachable");
        session.setAttribute("detachable",String.valueOf(detachable));
    }
}
*/
//人力资源模块是否开启了管理分权，如不是，则不显示框架，直接转向到列表页面(新的分权管理)
int hrmdetachable=0;
if(session.getAttribute("hrmdetachable")!=null){
    hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
}else{
	boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
	if(isUseHrmManageDetach){
	   hrmdetachable=1;
	   session.setAttribute("detachable","1");
	   session.setAttribute("hrmdetachable",String.valueOf(hrmdetachable));
	}else{
	   hrmdetachable=0;
	   session.setAttribute("detachable","0");
	   session.setAttribute("hrmdetachable",String.valueOf(hrmdetachable));
	}
}
int operatelevel=-1;
if(hrmdetachable==1){
    String deptid=ResourceComInfo.getDepartmentID(id);
    String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Util.getIntValue(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
        operatelevel=2;
}
//人力资源系统信息权限
int hrmoperatelevel=-1;
if(hrmdetachable==1){
    String deptid=ResourceComInfo.getDepartmentID(id);
    String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
    hrmoperatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"ResourcesInformationSystem:All",Util.getIntValue(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("ResourcesInformationSystem:All", user))
        hrmoperatelevel=2;
}
int userid = user.getUID();
boolean isSelf		=	false;
boolean isSys = ResourceComInfo.isSysInfoView(userid,id);
if (id.equals(""+user.getUID()) ){
	isSelf = true;
}

if(!((isSelf||hrmoperatelevel>=0||isSys)&&HrmListValidate.isValidate(15))){
	response.sendRedirect("/notice/noright.jsp") ;
}

%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(iss || hrmoperatelevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:edit(),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(!isfromtab){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewBasicInfo(),_TOP} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(17591,user.getLanguage())+",javascript:showSecLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %> 
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(iss || hrmoperatelevel>0){ %>
				<input type=button class="e8_btn_top" onclick="edit();" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
			<%}%>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM name=resourcesysteminfo id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<wea:layout type="2col">
<%
String attr = "";
if(!isfromtab)attr="{'groupDisplay':'none'}";
%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%>' attributes="<%=attr %>" >
	<wea:item><%=SystemEnv.getHtmlLabelName(16126,user.getLanguage())%></wea:item>
	<wea:item><%=loginid%> </wea:item>
	<%if("1".equals(openPasswordLock)){%>
	<wea:item><%=SystemEnv.getHtmlLabelName(24706,user.getLanguage())%></wea:item>
	<wea:item><input type=checkbox name=passwordlock value='<%=passwordlock %>' <%if(1==passwordlock){%>checked<%}%> disabled ></wea:item>
	<%}%>
	<%if(needdynapass==1 || "1".equals(needusbHt) || "1".equals(needusbDt) || "1".equals(settings.getNeedca())){%>
	<wea:item><%=SystemEnv.getHtmlLabelName(81629,user.getLanguage())%></wea:item>
	<wea:item>
		<select onchange="" name="userUsbType" id="userUsbType">
			<option value="-1">&nbsp;</option>
			<%if(needdynapass == 1){%>
			<option value="4" <%if("4".equals(userUsbType) || needdynapass_usr == 1){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(32511,user.getLanguage())%></option>
			<%}if("1".equals(needusbHt)){%>
			<option value="2" <%if("2".equals(userUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(21589,user.getLanguage())%></option>
			<%}if("1".equals(needusbDt)){%>
			<option value="3" <%if("3".equals(userUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(32896,user.getLanguage())%></option>
			<%}if("1".equals(settings.getNeedca())){%>
			<option value="21" <%if("21".equals(userUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(381991,user.getLanguage())%></option>
			<%}%>
		</select>
		&nbsp;
		<span id="spanusbstate">
		<select id="usbstate" name="usbstate" onchange="javascript:chooseUsbs(this);" disabled="disabled">
			<option value="0" <%=(usbstate!=null&&usbstate.equals("0"))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
			<option value="1" <%=(usbstate!=null&&usbstate.equals("1"))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>
			<option value="2" <%=(usbstate!=null&&usbstate.equals("2"))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21384,user.getLanguage())%></option>
		</select>
		</span>
	</wea:item>
	<%if("3".equals(userUsbType)&&"1".equals(needusbDt)){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(32897,user.getLanguage())%></wea:item>
		<wea:item><%=tokenKey%></wea:item>
	<%} %>
	<%if("21".equals(userUsbType)&&"1".equals(settings.getNeedca())){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
	<%}} %>
<%if(isMultilanguageOK){%>
	<wea:item><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></wea:item>
	<wea:item><%=LanguageComInfo.getLanguagename(systemlanguage)%></wea:item>
<%}%>
	<wea:item><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></wea:item>
	<wea:item><%=email%></wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
	<wea:item><%=seclevel%></wea:item>
	<%if(EnableMobile){%>
	<wea:item><%=SystemEnv.getHtmlLabelName(23996,user.getLanguage())%></wea:item>
	<wea:item><input type=checkbox name="isMgmsUser" value='<%=id%>' <%=isMgmsUser%> disabled></wea:item>
	<%}%>
</wea:group>
</wea:layout>
</form>

<script language=javascript>
  function edit(){    
    location = "/hrm/resource/HrmResourceSystemEdit.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }
  function viewBasicInfo(){    
    if(<%=isView%> == 0){
      //location = "/hrm/resource/HrmResourceBasicInfo.jsp?id=<%=id%>";
      location = "/hrm/employee/EmployeeManage.jsp?hrmid=<%=id%>";
    }else{
      location = "/hrm/resource/HrmResource.jsp?id=<%=id%>";
    }  
  }
  function viewPersonalInfo(){    
    location = "/hrm/resource/HrmResourcePersonalView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewWorkInfo(){    
    location = "/hrm/resource/HrmResourceWorkView.jsp?id=<%=id%>&isView=<%=isView%>";
  }  
  function viewFinanceInfo(){    
    location = "/hrm/resource/HrmResourceFinanceView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewCapitalInfo(){
    location = "/cpt/search/CptMyCapital.jsp?id=<%=id%>";
  }
  
  jQuery(document).ready(function(){
    jQuery("#userUsbType").selectbox("disable");
    onUserUsbTypeChange();
  })
  
  function onUserUsbTypeChange(){
    jQuery("#spanusbstate").hide();
  	if(jQuery("#userUsbType").val()!=-1){
  		jQuery("#spanusbstate").show();
  	}
  }
  
</script> 

</BODY>
</HTML>
