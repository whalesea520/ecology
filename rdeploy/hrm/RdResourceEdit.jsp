<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobtitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="RdeployHrmSetting" class="weaver.rdeploy.hrm.RdeployHrmSetting" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
  	<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
<style>
	.e8_os{
	  height:35px; 
	}
	.e8_innerShowContent{
	  height: 30px;
	  padding: 7px 0 0 7px;
	}
	.e8_spanFloat{
	  padding: 5px 0 0 0;
	}
	.e8_browflow{
		
	}
</style>

</head>

<%

String id = Util.null2String(request.getParameter("id"));
String success = Util.null2String(request.getParameter("success"));

String messageUrl = ResourceComInfo.getMessagerUrls(id);
String name = ResourceComInfo.getLastname(id);
String sex = ResourceComInfo.getSexs(id);
String depId = ResourceComInfo.getDepartmentID(id);
String jobId = ResourceComInfo.getJobTitle(id);
String managerId = ResourceComInfo.getManagerID(id);
String mobile = ResourceComInfo.getMobile(id);
String phone = ResourceComInfo.getTelephone(id);
String email = ResourceComInfo.getEmail(id);

String subcomid = Util.null2String(RdeployHrmSetting.getSettingInfo("subcom"));


String subcomName = SubCompanyComInfo.getSubCompanyname(subcomid);

%>
 <%
if(!success.equals("")){
        
%>
<script type="text/javascript">
jQuery(document).ready(function(){
	window.parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125313,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
	jQuery("#departmentname").val(window.parent.leftmenuframe.getdepName());
	jQuery("#displaysupName").html(window.parent.leftmenuframe.getSupdepName());
});
</script>
<%}%>
<BODY>

<input type=hidden id="oldname" name=oldname value="<%=name %>">
<input type=hidden id="oldMobile" name=oldMobile value="<%=mobile %>">
<FORM id=weaver name=frmMain action="RdResourceOperation.jsp" method=post>
<input type=hidden id="method" name=method value="edit">
<input type=hidden id="id" name=id value="<%=id %>">
<input type=hidden id="operate" name=operate value="1">
<div style="padding-top: 10px;color: #536467;">

<table width="590px" style="font-size: 13px;margin-left: 30px;">
  	  <tr >
  	  	<td width="100%" align="center" style="padding: 40px 0 10px 0;" colspan="2">
  	  	  <table width="100%">
  	  	   <tr>
  	  	    <td width="30%" align="right">
  	  		 <img id="imageCon"  src="<%=messageUrl %>" width="80px"/>
  	  		 <input type="hidden" id="imageUrl" name="messageUrl" value="<%=messageUrl %>"/>
  	  		 <div onclick="setUserIcon()"  style="cursor:pointer; background:url('/rdeploy/assets/img/hrm/bighead.png');position: absolute;top:57px;left:128px;height:80px;width:80px;"></div>
  	  	    </td>
  	  	    <td style="padding: 0 0 0 40px;">
  	  	      <table height="100%">
  	  	      	<tr>
			  	  <td  style="height: 36px;"><span style="padding-right: 18px;"  class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%> :</span><INPUT class=rdeploycommoninputclass style="width: 140px;height: 35px;" type=text maxLength=20 size=30 name=name id="name" value="<%=name %>"></td>
			    </tr>
			    <tr>
			      <td style="height: 46px;">
			      	 <table>
			      	 	<tr>
			      	 		<td><span style="padding-right: 18px;"  class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(125291,user.getLanguage())%> :</span></td>
			      	 		<td width="25px;"><input type="radio" id="man" name="sex" checked=""  value="0"/></td>
			      	 		<td width="40px;"><div id="sex" style="color: #526268;background:url('/rdeploy/assets/img/hrm/man.png') no-repeat;width: 24px;height: 24px;"></div></td>
			      	 		<td width="25px;"><input type="radio" id="girl" name="sex" checked=""  value="1"/></td>
			      	 		<td width="30px;"><div id="sex" style="color: #526268;background:url('/rdeploy/assets/img/hrm/lady.png') no-repeat;width: 24px;height: 24px;"></div></td>
			      	 		</tr>
			      	 </table>
				    </td>
				  </tr>
  	  	      </table>
  	  	    </td>
  	  	   </tr>
  	  	  </table>
  	  	</td>
  	  </tr>
  	  
  	  <tr >
  	    <td></td>
  	  </tr>
  	  <tr id="dept" style="">
  	  	<td align="right" style="padding-top: 3px;"  class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> :</td>
  	    <td align="left" style="color: #526268;padding: 12px 0 5px 10px;vertical-align: middle;">
  	    <div style="width: 430px;height:39px;position: absolute;margin-left: 2px;"></div>
  	    	<brow:browser viewType="0"  name="departmentid" browserValue="<%=depId %>"
  	    				   browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
						   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						   completeUrl="/data.jsp?type=4" width="420px" dialogWidth="600px"
						   browserSpanValue="<%=DepartmentComInfo.getDepartmentname(depId)%>">
			</brow:browser>
			<div style="width: 445px;font-size: 24px;padding: 0px 0 0 10px;"><a style="float: right;width: 30px;color: #536467;" href="javascript:addDept()"><img src="/rdeploy/assets/img/hrm/plus.png" width="18px" height="18px" align="absMiddle"><a></div>
  	    </td>
  	  </tr>
  	  <tr>
  	  	<td align="right" style="padding-top: 3px;"  class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%> :</td>
  	    <td align="left" style="color: #526268;padding: 12px 0 5px 10px;">
  	    <div style="width: 430px;height:39px;position: absolute;margin-left: 2px;"></div>
	  	    <brow:browser viewType="0" name="jobtitle" browserValue="<%=jobId%>" 
						   getBrowserUrlFn="onShowJobtitle" dialogWidth="600px"
						   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						   completeUrl="javascript:getCompleteUrl()" width="420px" browserSpanValue="<%=JobtitlesComInfo.getJobTitlesname(jobId)%>">
		    </brow:browser>
		    <div style="width: 445px;font-size: 24px;padding: 0px 0 0 10px;"><a style="float: right;width: 30px;color: #536467;" href="javascript:addJobile()"><img src="/rdeploy/assets/img/hrm/plus.png" width="18px" height="18px" align="absMiddle"><a></div>
  	    </td>
  	  </tr>
  	  <tr id="manager" style="">
  	  	<td align="right" style="padding-top: 3px;"  class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%> :</td>
  	    <td align="left" style="color: #526268;padding: 12px 0 5px 10px;">
  	    <div style="width: 430px;height:39px;position: absolute;margin-left: 2px;"></div>
	  	    <brow:browser viewType="0" name="managerid" browserValue="<%=managerId %>" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp" linkUrl="javascript:" width="420px"
						browserSpanValue="<%=ResourceComInfo.getLastname(managerId)%>"></brow:browser>
  	    </td>
  	  </tr>
  	  <tr id="mob" style="">
	  	<td align="right" style="padding-top: 3px;"  class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(125213,user.getLanguage())%> :</td>
  	    <td align="left" style="color: #526268;padding: 12px 0 5px 10px;">
	  	    <INPUT class=rdeploycommoninputclass style="width: 432px;height: 35px;" type=text maxLength=20 size=30 name=mobilephone id="mobilephone" value="<%=mobile %>"  >
  	    </td>
  	  </tr>
  	  <tr id="pho" style="">
  	    <td align="right" style="padding-top: 3px;"  class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(125214,user.getLanguage())%> :</td>
  	    <td align="left" style="color: #526268;padding: 12px 0 5px 10px;">
  	    	<INPUT class=rdeploycommoninputclass style="width: 432px;height: 35px;" type=text maxLength=20 size=30 name=phone id="phone" value="<%=phone %>"  >
  	    </td>
  	  </tr>
  	  <tr id="eml" style="">
  	    <td align="right" style="padding-top: 3px;"  class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(20869,user.getLanguage())%> :</td>
  	    <td align="left" style="color: #526268;padding: 12px 0 5px 10px;">
  	     <INPUT class=rdeploycommoninputclass type=text style="width: 432px;height: 35px;"  name=email id="email" value="<%=email %>" >
        </td>
  	  </tr>
  	  
  	</table>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_cancel" onclick="doSubmit()">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="e8_btn_cancel" onclick="return_()">
		    			</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
 
</FORM>

<script language=javascript>
var dialog1 = null;

function changeIcon(imgUrl){
	if(imgUrl == ""){
		imgUrl = "/messager/images/icon_m_wev8.jpg";
	}
	$("#imageCon").attr("src",imgUrl);
	$("#imageUrl").val(imgUrl);
}


jQuery(document).ready(function(){
	jQuery('body').jNice(); 
	<% if("0".equals(sex)){ %>
		jQuery("#man").trigger("checked",true);
	<%}else if("1".equals(sex)){ %>
		jQuery("#girl").trigger("checked",true);
	<%}%>
});
var languageid = "<%=user.getLanguage()%>";

function onDepartmentDel(text,fieldid,params){
	_writeBackData('jobtitle','1',{'id':'','name':''},{'hasInput':true});
	jQuery("#job").hide();
}

function onDepartmentAdd(e,datas,name){
		_writeBackData('jobtitle','1',{'id':'','name':''},{'hasInput':true});
	if(datas.id==""){
		jQuery("#job").hide();
	}
	else {
		jQuery("#job").show();
	} 
}

function onShowJobtitle(){
	var url="/hrm/jobtitles/JobTitlesBrowser.jsp?fromPage=add";
	url="/systeminfo/BrowserMain.jsp?url="+url;
	return url;
}

function getCompleteUrl(){
	var url= "/data.jsp?type=hrmjobtitles";
  return url;	
}

var dialog1 = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);	
var dialog = null; 

function doSubmit(operate) {
	
	var name = $("#name").val().trim();
	var mobilephone = $("#mobilephone").val().trim();
	
	
	if(name == ""){
		window.parent.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125311,user.getLanguage())%>");
		return;
	}
	if(jQuery("input[name=departmentid]").val() != "" && jQuery("input[name=jobtitle]").val() == ""){
		window.parent.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125314,user.getLanguage())%>");
		return;
	}
	if(mobilephone == ""){
		window.parent.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125312,user.getLanguage())%>");
		return;
	}
    var myreg = /^1\d{10}$/g; 
    if(!myreg.test(mobilephone)) 
     { 
       window.parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125253,user.getLanguage())%>'); 
       return; 
     } 
     $("#operate").val(operate);
     var dataP = {"nameStr":"","mobile":""};
     if($("#oldname").val() != name ){
     	dataP.nameStr = name;
     
     }
     if($("#oldMobile").val() != mobilephone ){
     	dataP.mobile = mobilephone;
     }
     if(dataP != null){
		$.ajax({
			 data:dataP,
			 type: "post",
			 cache:false,
			 url:"checkdatas.jsp",
			 dataType: 'json',
			 success:function(data){
			 	if(data.mobileExist == "1"){
			 	 	 window.parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125267,user.getLanguage())%>');
			 	 	 return;
		 	 	}
				 if(data.success == "0"){
					   $("#dosubmit").attr('disabled',"true");
					   frmMain.submit();
				 }else{
				 	 window.parent.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21445,user.getLanguage())%>!",function(){
				 	 	 frmMain.submit();
				 	 });
				 }
			}	
	   });
     }else{
     	frmMain.submit();
     }
}

function setUserIcon(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=GetUserIcon1&id=<%=id%>&imgurl_="+$("#imageUrl").val()+"&imageid=";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(28062,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function addJobile(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "hrm/RdAddJob.jsp?deptid="+jQuery("input[name=departmentid]").val();
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125302 ,user.getLanguage())%>";
	dialog.normalDialog = false;
	dialog.Width = 400;
	dialog.Height = 223;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function setJobId(id,name){
	_writeBackData('jobtitle','1',{'id':id,'name':name},{'hasInput':true});
}

function return_(){
  window.parent.Dialog.close();
}

function back()
{
	window.history.back(-1);
}

function addDept(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = "/rdeploy/hrm/RdDeptAdd.jsp?supName=<%=subcomName%>&subcompanyid1=<%=subcomid %>&supdepid=0&method=add&from=1";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125303,user.getLanguage())%>";
	dialog.normalDialog = false;
	dialog.Width = 400;
	dialog.Height = 223;
	dialog.Drag = true;
	dialog.show();
}


	var depName ="";
	var supDepName = "<%=subcomName%>";

function getdepName(){
	return depName;
}
function setdepName(name){
	depName=name;
}
function getSupdepName(){
	return supDepName;
}

function getNewDeptId(id,name){
  _writeBackData('departmentid','1',{'id':id,'name':name},{'hasInput':true});
}

</script>




</BODY></HTML>

