
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>
<%@page import="weaver.hrm.definedfield.HrmFieldManager"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="SpecialityComInfo" class="weaver.hrm.job.SpecialityComInfo" scope="page" />
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="HrmResourceFile" class="weaver.hrm.tools.HrmResourceFile" scope="page"/>
<jsp:useBean id="HrmFieldGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<%
LinkedHashMap ht = new LinkedHashMap();
 Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
 String id = request.getParameter("id");
 int hrmid = user.getUID();
 AllManagers.getAll(id);
 int isView = Util.getIntValue(request.getParameter("isView"));

 int departmentid = user.getUserDepartment();

 boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
 
 boolean ism = ResourceComInfo.isManager(hrmid,id);
 boolean iss = ResourceComInfo.isSysInfoView(hrmid,id);
 boolean isf = ResourceComInfo.isFinInfoView(hrmid,id);
 boolean isc = ResourceComInfo.isCapInfoView(hrmid,id);
// boolean iscre = ResourceComInfo.isCreaterOfResource(hrmid,id);
 boolean ishe = (hrmid == Util.getIntValue(id));
// boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid));

  int scopeId = 3;
  String sql = "";
  sql = "select * from HrmResource where id = "+id;
  rs.executeSql(sql);
  rs.next();
    String probationenddate = Util.null2String(rs.getString("probationenddate"));
    String workstartdate = Util.null2String(rs.getString("startdate"));
    String workenddate = Util.null2String(rs.getString("enddate"));
    String usekind = Util.null2String(rs.getString("usekind"));
    int status = rs.getInt("status");

%>
<HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
 <style type="text/css">
.InputStyle{width:30%!important;}
.inputstyle{width:30%!important;}
.Inputstyle{width:30%!important;}
.inputStyle{width:30%!important;}
.e8_os{width:30%!important;}
select.InputStyle{width:10%!important;} 
select.inputstyle{width:10%!important;} 
select.inputStyle{width:10%!important;} 
select.Inputstyle{width:10%!important;} 
textarea.InputStyle{width:70%!important;} 
</style>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
    	getLine:1,
    	image:false,
    	needLine:false,
    	needTopTitle:false,
    	needInitBoxHeight:true,
    	needNotCalHeight:true
    });
});

function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(380,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
int operatelevel=-1;
if(hrmdetachable==1){
    String deptid=ResourceComInfo.getDepartmentID(id);
    String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Util.getIntValue(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
        operatelevel=2;
}
boolean isSelf		=	false;
boolean isManager	=	false;
if (id.equals(""+user.getUID()) ){
		isSelf = true;
	}
while(AllManagers.next()){
	String tempmanagerid = AllManagers.getManagerID();
	if (tempmanagerid.equals(""+user.getUID())) {
		isManager = true;
	}
}
if(!((isSelf||isManager||operatelevel>=0)&&HrmListValidate.isValidate(12))){
	response.sendRedirect("/notice/noright.jsp") ;
}
%>
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(status != 10&&operatelevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(dateUtil.dayDiff(today,probationenddate)==3||dateUtil.dayDiff(today,workenddate)==3){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15781,user.getLanguage())+",javascript:info(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(!isfromtab){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewBasicInfo(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(status != 10&&operatelevel>0){ %>
				<input type=button class="e8_btn_top" onclick="edit();" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
			<%}%>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%if(!isfromtab){ %>
<TABLE class=Shadow>
<%}else{ %>
<TABLE width='100%'>
<%} %>
<tr>
<td valign="top">

<FORM name=resourceworkinfo id=resourceworkinfo action="HrmResourceOperation.jsp" method=post >
<wea:layout type="2col">
<%
HrmFieldGroupComInfo.setTofirstRow();
HrmFieldManager hfm = new HrmFieldManager("HrmCustomFieldByInfoType",scopeId);
CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
hfm.getHrmData(Util.getIntValue(id));
cfm.getCustomData(Util.getIntValue(id));
while(HrmFieldGroupComInfo.next()){
	int grouptype = Util.getIntValue(HrmFieldGroupComInfo.getType());
	if(grouptype!=scopeId)continue;
	int grouplabel = Util.getIntValue(HrmFieldGroupComInfo.getLabel());
	int groupid = Util.getIntValue(HrmFieldGroupComInfo.getid());
	hfm.getCustomFields(groupid);
	if(hfm.getGroupCount()==0)continue;
	if(groupid==5 && !HrmListValidate.isValidate(47))continue;
	if(groupid!=5 && !HrmListValidate.isValidate(48))continue;
	%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(grouplabel,user.getLanguage())%>'>	
<%
	while(hfm.next()){
		if(!hfm.isUse())continue;
		int fieldlabel=Util.getIntValue(hfm.getLable());
		String fieldName=hfm.getFieldname();
		int fieldId=hfm.getFieldid();
		int type = hfm.getType();
		String dmlurl = hfm.getDmrUrl();
		int fieldhtmltype = Util.getIntValue(hfm.getHtmlType());
		String fieldValue="";
	
		if(hfm.isBaseField(fieldName)){
			fieldValue = hfm.getHrmData(fieldName);
		}else{
			fieldValue = cfm.getData("field"+hfm.getFieldid());
		}
		String attr = "{}";
		if(hfm.getHtmlType().equals("6")){
			//附件上传页面处理
		}else{
			if(hfm.getHtmlType().equals("3")){
				fieldValue=hfm.getHtmlBrowserFieldvalue(user, dmlurl, fieldId, fieldhtmltype, type, fieldValue , "0");
			}else{
				fieldValue=hfm.getFieldvalue(user, dmlurl, fieldId, fieldhtmltype, type, fieldValue , 0);
			}
		}
		if(hfm.getHtmlType().equals("6")){
  		String[] resourceFile = HrmResourceFile.getResourceFileView(id, scopeId, hfm.getFieldid());
  %>
  <wea:item><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item><%=resourceFile[1]%></wea:item>
	<%}else{ %>
	<wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=attr %>'>
		<%=fieldValue%>
	</wea:item>
	<%}
	}
%>
</wea:group>
<%} %>
</wea:layout>

<jsp:include page="/hrm/resource/HrmResourceWorkViewNew_head.jsp" />

<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
</form>
</td>
</tr>
</TABLE>
<script language=javascript>

  function edit(){
    location = "/hrm/resource/HrmResourceWorkEdit.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }
  function info(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>")){
         document.resourceworkinfo.operation.value="info";
	 document.resourceworkinfo.submit();
    }
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
  function viewFinanceInfo(){
    location = "/hrm/resource/HrmResourceFinanceView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewSystemInfo(){
    location = "/hrm/resource/HrmResourceSystemView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewCapitalInfo(){
    location = "/cpt/search/CptMyCapital.jsp?id=<%=id%>";
  }
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
</HTML>

