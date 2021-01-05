<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.common.Tools"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<% if(!HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
</head>
<%
String resourceid=Util.null2String(request.getParameter("resourceid"));
if(resourceid.equals("undefined"))resourceid="";
String changedate = Util.null2String(request.getParameter("changedate"));
String changereason = Util.null2String(request.getParameter("changereason"));
String ischangesalary = Util.null2String(request.getParameter("ischangesalary"));
String infoman = Util.null2String(request.getParameter("infoman"));
String newjoblevel = Util.null2String(request.getParameter("newjoblevel"));
String newjobtitle = Util.null2String(request.getParameter("newjobtitle"));
String managerid = Util.null2String(request.getParameter("managerid"));

String sql = "";
//rs.executeSql(sql);
//rs.next();
//String joblevel = rs.getString(1);
//String oldDeptId = Tools.vString(rs.getString(2));
//String loginid = Tools.vString(rs.getString(3));

int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

boolean hasFF = true;
rs.executeProc("Base_FreeField_Select","hr");
if(rs.getCounts()<=0)
	hasFF = false;
else
	rs.first();
	
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6090,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name=resource id=resource action="HrmResourceStatusOperation.jsp" method=post>
<input class=inputstyle type=hidden name=operation value="redeploy">
  <table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="doSave(this);" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
	</table>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
     <wea:item><%=SystemEnv.getHtmlLabelName(16001,user.getLanguage())%></wea:item>
     <wea:item>
		  <%
		  String lastname = "";
		  if(resourceid.length()>0) lastname = ResourceComInfo.getLastnameAllStatus(resourceid);
		  String subcomstr=SubCompanyComInfo.getRightSubCompany(user.getUID(),"HrmResourceAdd:Add",0);
		  String sqlwhere = " (status =0 or status = 1  or status = 2 or status = 3)" ;
		  String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MultiResourceBrowserByRight.jsp?rightStr=HrmResourceAdd:Add&fromHrmStatusChange=HrmResourceRedeploy&sqlwhere="+xssUtil.put(sqlwhere)+"&selectedids=";
			String completeUrl = "/data.jsp?whereClause="+xssUtil.put(" (status =0 or status = 1  or status = 2 or status = 3) and t1.subcompanyid1 in("+subcomstr+")");
		  %>
        <brow:browser viewType="0" name="resourceid" browserValue='<%=resourceid %>' 
             browserUrl='<%=browserUrl %>'
             hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2'
             completeUrl='<%=completeUrl %>' linkUrl="javascript:openhrm($id$)" width="300px"
             _callback="jsSubmit"
             browserSpanValue='<%=lastname %>'>     
        </brow:browser>
     	<!-- 
     	<BUTTON class=Browser type="button" onclick="onShowResourceID(resourceid,assistantidspan)"></BUTTON> 
       <SPAN id=assistantidspan>
         <%=ResourceComInfo.getResourcename(resourceid)%>
         <%if(ResourceComInfo.getResourcename(resourceid).equals("")){%>
          <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
         <%}%>
       </SPAN>
       <input class=inputstyle type=hidden name=resourceid value="<%=resourceid%>" onChange='checkinput("resourceid","assistantidspan")'>
     	 -->
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(6111,user.getLanguage())%></wea:item>
     <wea:item><BUTTON class=Calendar type="button" id=selectcontractdate onclick="getchangedate()"></BUTTON> 
       <SPAN id=changedatespan >               
				<%if(!changedate.equals("")){%>                <%=changedate%><%}else{%>
         <IMG src="/images/BacoError_wev8.gif" align=absMiddle>     <%}%>        
       </SPAN> 
       <input class=inputstyle type="hidden" name="changedate" value="<%=changedate%>" onChange='checkinput("changedate","changedatespan")'>
     </wea:item>
            <wea:item><%=SystemEnv.getHtmlLabelName(6116,user.getLanguage())%></wea:item>
            <wea:item>
              <textarea class=inputstyle rows=5 cols=40 name="changereason" value="<%=changereason%>"><%=changereason%></textarea>
            </wea:item>
            <wea:item><%=SystemEnv.getHtmlLabelNames("21673,124",user.getLanguage())%></wea:item>
            <wea:item>
							<brow:browser viewType="0"  name="departmentid" browserValue=""
							 browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
						   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
						   completeUrl="/data.jsp?type=4" width="165px"
						   browserSpanValue="">
						 </brow:browser>
							<!-- 
							              <INPUT class="wuiBrowser" id=departmentid type=hidden name=departmentid 
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
			  _required="yes">
							 -->
            </wea:item>
            <wea:item><%=SystemEnv.getHtmlLabelName(6113,user.getLanguage())%></wea:item>
            <wea:item>
            <brow:browser viewType="0"  name="newjobtitle" browserValue="" 
					   getBrowserUrlFn="onShowJobtitle"
					   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
					   completeUrl="javascript:getCompleteUrl()" width="165px" browserSpanValue="">
					 	</brow:browser>
            </wea:item>
            <wea:item><%=SystemEnv.getHtmlLabelNames("21673,484",user.getLanguage())%></wea:item>
            <wea:item>
              <input class=inputstyle type=text maxlength=3 size=3 name="newjoblevel" value="<%=newjoblevel%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("newjoblevel")' style="width: 120px;">
            </wea:item>
            <wea:item><%=SystemEnv.getHtmlLabelName(24129,user.getLanguage())%></wea:item>
            <wea:item>

<%
String managername="";
sql = "select lastname from HrmResource where id = "+Util.getIntValue(managerid,-1);
rs2.executeSql(sql);
while(rs2.next()){
	managername = rs2.getString("lastname"); 
}%>
        	  <span> 
	            <brow:browser viewType="0" name="managerid" browserValue="<%=managerid%>" 
	              browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	              hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
	              completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="120px"
	              browserSpanValue="<%=managername%>"></brow:browser>
	         	</span>
<!-- 
                      <INPUT class="wuiBrowser" id=managerid type=hidden name=managerid value="<%=managerid%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			  _displayTemplate="<A target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>">
 -->   
            </wea:item>

            <wea:item><%=SystemEnv.getHtmlLabelName(6157,user.getLanguage())%></wea:item>
            <wea:item>
              <input class=inputstyle type=checkbox name="ischangesalary" value="1" <%if(ischangesalary.equals("1")){%>checked<%}%>>
            </wea:item>
            <wea:item><%=SystemEnv.getHtmlLabelName(16108,user.getLanguage())%></wea:item>
            <wea:item>
	          <span> 
	            <brow:browser viewType="0" name="infoman" browserValue="<%=infoman%>" 
	              browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
	              hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	              completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="240px"
	              browserSpanValue="<%=ResourceComInfo.getMulResourcename(infoman)%>"></brow:browser>
	         	</span>
            <!-- 
              <BUTTON class=Browser type="button" onClick="onShowResource(infoman,infomanspan)">
	      </BUTTON> 
	      <span id=infomanspan>
	        <%=ResourceComInfo.getMulResourcename(infoman)%>
	      </span> 
	      <INPUT class=inputstyle id=organizer type=hidden name=infoman value="<%=infoman%>">            
             -->
            </wea:item>
		</wea:group>
	</wea:layout>
</FORM>
<SCRIPT LANGUAGE="JavaScript">
var common = new MFCommon();
function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
			var names = wuiUtil.getJsonValueByIndex(id, 1).substr(1);

			jQuery(inputname).val(ids);
			var sHtml = "";
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");

			linkurl = ""

			for ( var i = 0; i < ridArray.length; i++) {

				var curid = ridArray[i];
				var curname = rNameArray[i];

				sHtml += "<a tatrget='_blank' href=/hrm/resource/HrmResource.jsp?id=" + curid + ">" + curname + "</a>&nbsp;";
			}

			jQuery(spanname).html(sHtml);
		} else {
			jQuery(inputname).val("")
			jQuery(spanname).html("");
		}
	}
}

function onShowDept(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$GetEle(inputename).value);
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	      jQuery($GetEle(tdname)).html("<a href='#"+wuiUtil.getJsonValueByIndex(results,0)+"'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowResource(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	  	 jQuery($GetEle(tdname)).html("<a href='javascript:openhrm("+wuiUtil.getJsonValueByIndex(results,0)+")'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
	     jQuery("input[name='"+inputename+"']")[0].value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
	     jQuery("input[name='"+inputename+"']").val("");
	  }
	}
}

function onShowResource1(inputname,spanname){
	disModalDialogRtnM("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp",inputname,spanname);
}

function onShowResourceID(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/browser/redeploy/ResourceBrowser.jsp");
	if (data!=null){
	if (data.id!=""){
	jQuery("#assistantidspan").html("<A href='/hrm/resource/HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>");
	jQuery("input[name=resourceid]").val(data.id);
	}else{
	jQuery("#assistantidspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	jQuery("input[name=resourceid]").val("");
	}
	}
	document.forms[0].action="HrmResourceRedeploy.jsp";
	document.forms[0].submit();
}

function onShowJobtitle1(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp");
	if (data!=null){
		if (data.id != 0 || data.id != "" ){
			jQuery("#newjobtitlespan").html(data.name);
			jQuery("input[name=newjobtitle]").val(data.id);
			jQuery("#newjobtitlespanimg").html("")
		}else{
			jQuery("#newjobtitlespan").html("");
			jQuery("input[name=newjobtitle]").val("");
			jQuery("#newjobtitlespanimg").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>")
		}
	}
}
</SCRIPT>
<!--
<script language=vbs>


sub onShowOldJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	oldjobtitlespan.innerHtml = id(1)
	resource.oldjobtitle.value=id(0)
	else
	jobtitlespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.oldjobtitle.value=""
	end if
	end if
end sub

sub onShowJobtitle1()
  if  (resource.departmentid.value <> "") then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?sqlwhere= where jobdepartmentid="&resource.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	newjobtitlespan.innerHtml = id(1)
	resource.newjobtitle.value=id(0)
	else
	newjobtitlespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.newjobtitle.value=""
	end if
	end if
	else
	window.alert("<%=SystemEnv.getHtmlLabelName(21014,user.getLanguage())%>")
	end if
end sub

sub onShowNewJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	newjobtitlespan.innerHtml = id(1)
	resource.newjobtitle.value=id(0)
	else
	newjobtitlespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.newjobtitle.value=""
	end if
	end if
end sub
sub onShowResource1(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&curid&"')>"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&resourceids&"')>"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else
    	spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    	inputname.value="0"
	end if
	end if
end sub
sub onShowDepartment()

	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&resource.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = resource.departmentid.value then
		issame = true 
	end if
	departmentspan.innerHtml = id(1)
	resource.departmentid.value=id(0)
	else
	departmentspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.departmentid.value=""
	end if
	end if
end sub
sub onShowManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	manageridspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.managerid.value=id(0)
	else
	manageridspan.innerHtml = ""
	resource.managerid.value=""
	end if
	end if
end sub
</script>
-->
<script language=javascript>
function getCompleteUrl(){
	var url= "/data.jsp?type=hrmjobtitles";
  return url;	
}

function onShowJobtitle(){
	url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
	return url;
}

function doSave(obj) {
   if(check_form(document.resource,"resourceid,changedate,newjobtitle,departmentid"))
	{
		var newDeptId = $GetEle("departmentid").value;
		var resourceid = $('#resourceid').val();
		var result = common.ajax("cmd=checkBatchNewDeptUsers&arg="+newDeptId+"&resourceid="+resourceid);
		if(result && result == "true"){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82466,user.getLanguage())%>");
			return false;
		}
	   obj.disabled=true;
		document.resource.submit();
	}

}
function jsSubmit(e,datas,name){
	document.resource.action="HrmResourceRedeploy.jsp";
	document.resource.submit();
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>

