
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<% if(!HrmUserVarify.checkUserRight("HrmCheckKindAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML>
<%
String id = request.getParameter("id");
String checkitemid = Util.null2String(request.getParameter("checkitemid"));
String jobid = Util.null2String(request.getParameter("jobid"));
String resourceid = Util.null2String(request.getParameter("resourceid"));

String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css" type=text/css rel="stylesheet">
<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language="javascript" src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6118,user.getLanguage());
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM name=hrmcheckkind id=hrmcheckkind action="HrmCheckOperation.jsp" method=post>
<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<input class=inputstyle type=hidden id=trainrownum name=trainrownum>
<input class=inputstyle type=hidden id=rewardrownum name=rewardrownum>
<input class=inputstyle type=hidden id=cerrownum name=cerrownum>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15759,user.getLanguage())%>'>
  	<wea:item><%=SystemEnv.getHtmlLabelName(15755,user.getLanguage())%></wea:item>            
    <wea:item> 
      <input class=inputstyle  maxLength=30 size=30 name="kindname" onchange='checkinput("kindname","kindnamespan")'>
      <SPAN id=kindnamespan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> 
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15756,user.getLanguage())%></wea:item>
    <wea:item> 
      <select class=inputstyle name=checkcycle >
        <option value="1"><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%></option>
        <option value="4"><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></option>
      </select>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15757,user.getLanguage())%></wea:item>
    <wea:item> 
      <input class=inputstyle  maxLength=30 size=5 name="checkexpecd" onchange='checkinput("checkexpecd","checkexpecdspan")' onKeyPress="ItemCount_KeyPress()"><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
      <SPAN id=checkexpecdspan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> 
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15758,user.getLanguage())%></wea:item>
    <wea:item>
      <input class=wuiDate type="hidden" id="checkstartdate" name="checkstartdate" value="" _isrequired="yes">
    </wea:item>
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<div id="trainTable" class="groupmain" style="width:100%"></div>
			<script>
				var items=[
				{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>",itemhtml:"<span class='browser' name='jobid' completeurl='/data.jsp?type=hrmjobtitles' browserurl='/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?selectedids=' hasinput='true' isSingle='false'></span>"},
				/*{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%>",itemhtml:"<span class='browser' name='deptid' completeurl='/data.jsp?type=4' browserurl='/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=' hasinput='true' isSingle='false'></span>"},
				{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>",itemhtml:"<span class='browser' name='subcid' completeurl='/data.jsp?type=164' browserurl='/systeminfo/BrowserMain.jsp?url=/hrm/company/SubCompanyBrowser.jsp?selectedids=' hasinput='true' isSingle='false'></span>"},*/
				{width:"70%",tdclass:"desclass",colname:"",itemhtml:""}];
				var ajaxdata = null;
				var option= {
											openindex:true,
				              navcolor:"#003399",
				              basictitle:"<%=SystemEnv.getHtmlLabelName(17425,user.getLanguage())%>",
				              toolbarshow:true,
				              colItems:items,
				              usesimpledata: true,
				              initdatas: ajaxdata,
				              addrowCallBack:function(obj,tr,entry) {
												jQuery("#trainrownum").val(obj.count);
				              },
				              copyrowsCallBack:function(obj,tr,entry) {
												jQuery("#trainrownum").val(obj.count);
				              },
				             	configCheckBox:true,
				             	checkBoxItem:{"itemhtml":'<input name="check_node" class="groupselectbox" type="checkbox" >',width:"5%"}
				            };
         var group=new WeaverEditTable(option);
         $("#trainTable").append(group.getContainer());
       </script>
		</wea:item>
		<wea:item  attributes="{'isTableList':'true','colspan':'full'}">
    	<div id="cerTable" class="groupmain" style="width:100%"></div>
			<script>	
				var items=[
				{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%>",itemhtml:"<span class='browser' name='checkitemid' completeurl='/data.jsp?type=HrmCheckItem' browserurl='/systeminfo/BrowserMain.jsp?url=/hrm/check/CheckItemBrowser.jsp?selectedids=' hasinput='true' isSingle='false'></span>"},
				{width:"70%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:30%' name='checkitemproportion' onKeyPress='ItemCount_KeyPress()'>%"}];
				var ajaxdata = null;
				var option= {
											openindex:true,
				              navcolor:"#003399",
				              basictitle:"<%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%>",
				              toolbarshow:true,
				              colItems:items,
				              usesimpledata: true,
				              initdatas: ajaxdata,
				              addrowCallBack:function(obj,tr,entry) {
												jQuery("#cerrownum").val(obj.count);
				              },
				              copyrowsCallBack:function(obj,tr,entry) {
												jQuery("#cerrownum").val(obj.count);
				              },
				             	configCheckBox:true,
				             	checkBoxItem:{"itemhtml":'<input name="check_node" class="groupselectbox" type="checkbox" >',width:"5%"}
				            };
         var group=new WeaverEditTable(option);
         $("#cerTable").append(group.getContainer());
       </script> 
		</wea:item>
		<wea:item  attributes="{'isTableList':'true','colspan':'full'}">
		  <div id="rewardTable" class="groupmain" style="width:100%"></div>
			<script>	
				var items=[
				{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>",itemhtml:"<select class=inputstyle name='typeid' onchange='onChangeSharetype(this)'><option value='1'><%=SystemEnv.getHtmlLabelName(15763,user.getLanguage())%></option><option value='2'><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></option><option value='3'><%=SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option><option value='4'><%=SystemEnv.getHtmlLabelName(15764,user.getLanguage())%></option><option value='5'><%=SystemEnv.getHtmlLabelName(15765,user.getLanguage())%></option><option value='6'><%=SystemEnv.getHtmlLabelName(15766,user.getLanguage())%></option><option value='7'><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option></select>"},
				{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>",itemhtml:"<div id='div_browser_#rowIndex#' style='display:none'><span class='browser' name='resourceid' completeurl='/data.jsp' browserurl='/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids=' hasinput='true'  isSingle='true'></span></div>"},
				{width:"40%",colname:"<%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:30%' name='checkproportion' onKeyPress='ItemCount_KeyPress()'>%"}];
				var ajaxdata = null;
				var option= {
											openindex:true,
				              navcolor:"#003399",
				              basictitle:"<%=SystemEnv.getHtmlLabelName(15662,user.getLanguage())%>",
				              toolbarshow:true,
				              colItems:items,
				              usesimpledata: true,
				              initdatas: ajaxdata,
				              addrowCallBack:function(obj,tr,entry) {
												jQuery("#rewardrownum").val(obj.count);
				              },
				              copyrowsCallBack:function(obj,tr,entry) {
												jQuery("#rewardrownum").val(obj.count);
				              },
				             	configCheckBox:true,
				             	checkBoxItem:{"itemhtml":'<input name="check_node" class="groupselectbox" type="checkbox" >',width:"5%"}
				            };
         var group=new WeaverEditTable(option);
         $("#rewardTable").append(group.getContainer());
       </script> 
   	</wea:item>
   </wea:group>
</wea:layout>
</form>
  <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
<script type="text/javascript">
  /**
  *Add by Huang On May 10,2004 ,
  */
  function checkNoZero() {
       var checkValue = hrmcheckkind.checkexpecd.value;
       if(parseInt(checkValue)<=0 || parseInt(checkValue)+""=="NaN") {
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(17408,user.getLanguage())%>");
        return false;
       }
       return true;
  }
  function doSave(){
    if(check_form(document.hrmcheckkind,'kindname,checkexpecd,checkstartdate')&&checkNoZero()){
     document.hrmcheckkind.operation.value="AddCheckKindinfo";
	 		document.hrmcheckkind.submit();
    }
  }

  function doBack(){
	location = "HrmCheckKind.jsp";
  }
  function onChangeSharetype(obj){
    thisvalue=obj.value;
    rewardrowindex=jQuery(obj).attr("name").split("_")[1];
  	if(thisvalue==7){
 			jQuery("#div_browser_"+rewardrowindex).show();
		}
		else{
			jQuery("#div_browser_"+rewardrowindex).hide();
		}
}


</script>

<script language=vbs>
sub onShowResourceID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else
	spanname.innerHtml = "<img src='/images/BacoError_wev8.gif' align=absMiddle>"
	inputname.value=""
	end if
	end if
end sub

sub onShowUsekind()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	usekindspan.innerHtml = id(1)
	resource.usekind.value=id(0)
	else
	usekindspan.innerHtml = ""
	resource.usekind.value=""
	end if
	end if
end sub

sub onShowSpeciality(inputspan,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/speciality/SpecialityBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	inputspan.innerHtml = id(1)
	inputname.value=id(0)
	else
	inputspan.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
sub onShowCheckID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/check/CheckItemBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
    else
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
sub onShowJobID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
    else
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub


</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
