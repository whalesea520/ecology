
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.license.GetPhysicalAddress"%>
<%@page import="weaver.social.license.MessageLicenseUtil"%>
<%@page import="weaver.file.FileUpload"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%

if (!HrmUserVarify.checkUserRight("message:manager", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String titlename =SystemEnv.getHtmlLabelName(18014,user.getLanguage()); //微博基本设置

int userid=0;
userid=user.getUID();

String maxusernum="";
String company = "";
String exdate = "";
String licenseCode="";
int message=1;
int msgcode=1;
String msg="正常";
BaseBean baseBean = new BaseBean();
try{
	FileUpload fu = new FileUpload(request,false);
	String operation = Util.null2String(fu.getParameter("operation"));
	baseBean.writeLog("@wyw@operation:"+operation);
	if(operation.equals("upload")){
		message=MessageLicenseUtil.uploadLicense("licenseFile",fu);
		baseBean.writeLog("@wyw@upload result:"+operation);
	}
	
	GetPhysicalAddress ga = new GetPhysicalAddress();
	try {
		Map<String, String> msgMap=MessageLicenseUtil.checkLicense();
		baseBean.writeLog("@wyw@checkpoint:1");
		msgcode=Util.getIntValue(msgMap.get("msgCode"));
		new BaseBean().writeLog("msgcode:"+msgcode);
		baseBean.writeLog("@wyw@checkpoint:2 msgcode:"+msgcode);
		if (msgcode==1) {
			licenseCode = MessageLicenseUtil.getLicensecode();
           	company = MessageLicenseUtil.getCompanyname();
			maxusernum = MessageLicenseUtil.getHrmnum();
			exdate = MessageLicenseUtil.getExpiredate();
			baseBean.writeLog("@wyw@checkpoint:3");
		} else {
			if(msgcode==3) msg="license过期";
			if(msgcode==4||msgcode==5) msg="未授权";
			
			licenseCode = ga.getPhysicalAddress();
			baseBean.writeLog("@wyw@checkpoint:4 licenseCode:"+licenseCode);
		}
	} catch (Exception e) {
		licenseCode = ga.getPhysicalAddress(); 
		baseBean.writeLog("@wyw@checkpoint:5");
		baseBean.writeLog(e.toString());
	}
} catch (Exception e) {
	e.printStackTrace();
	baseBean.writeLog("@wyw@checkpoint:6");
	baseBean.writeLog(e.toString());
}

%>
<!DOCTYPE HTML>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
    <SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
	<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>

 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</head>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="social"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(18014,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form action="SocialIMCopyRight.jsp" method="post"  id="mainform" enctype="multipart/form-data">
<input type="hidden" value="upload" name="operation"/> 
<wea:layout>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(18014,user.getLanguage())%>">
		<wea:item>公司名称</wea:item> <!-- 公司名称 -->
		<wea:item>
			<%=company%>
		</wea:item>
		
		<wea:item>用户数</wea:item> <!-- 用户数 -->
		<wea:item>
			<%=maxusernum%>
		</wea:item>
		
		<wea:item>标识码</wea:item> <!-- 标识码 -->
		<wea:item>
			<%=licenseCode%>
		</wea:item>
		
		<wea:item>到期日期</wea:item> <!-- 到期日期 -->
		<wea:item>
			<%=exdate%>
		</wea:item>
		<wea:item>授权状态</wea:item> <!-- 到期日期 -->
		<wea:item>
			<%=msgcode>1?"<span style='color:red'>未授权</span>":"正常"%>
		</wea:item>
		
	</wea:group>
	
	<wea:group context="License提交">
		<wea:item>License</wea:item> <!-- 提交License -->
		<wea:item>
			<input type="file" name="licenseFile" id="licenseFile">
		</wea:item>
	</wea:group>
	
</wea:layout>
</form>  
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
 <script type="text/javascript">
  function doSave(){
  	 if($("#licenseFile").val()==""){
  	 	window.top.Dialog.alert("请选择License文件");
  	 }else{
     	jQuery("#mainform").submit();
     }
  }
  
jQuery(document).ready(function(){
	 var message=<%=message%>;
	 if(message==2){
	 	window.top.Dialog.alert("上传失败");
	 }
});

 </script>
</html>
