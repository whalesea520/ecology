
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%

int needchange=0;
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
 String isclose = Util.null2String(request.getParameter("isclose"));
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
<jsp:param name="mouldID" value="worktask"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(119,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSave(this);">						
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name=weaver action="RequestShareOperation.jsp" method=post >
<input type="hidden" name="method" value="add">
<input type="hidden" name="types" value="1">
<input type="hidden" name="wtid" value="<%=wtid%>" >
<input type="hidden" name="requestid" value="<%=requestid%>" >
<!--计划任务状态(审批后)-->
<input type="hidden" name="taskstatus" value="2" >
<!--共享级别-->
<input type="hidden" name="sharelevel" value="0" >

 <wea:layout type="2col">
                    <wea:group context='<%=SystemEnv.getHtmlLabelNames("407,30747",user.getLanguage())%>' >
                        

						<!-- 对象 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(19117, user.getLanguage())%></wea:item>
						<wea:item>
							<SELECT style="width:100px;" class="InputStyle" name="sharetype" id="sharetype" onchange="onChangeShareType()" style="float:left">
							  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
							  <option  value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
							  <option selected  value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							  <option  value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
							  <option  value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
							  <!--<option  value="6"><%=SystemEnv.getHtmlLabelName(18583,user.getLanguage())%></option>
							  <option  value="7"><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></option>
							  <option  value="8"><%=SystemEnv.getHtmlLabelName(18584,user.getLanguage())%></option>
							 
							--></SELECT>
						</wea:item>
						<wea:item attributes="{'samePair':\"objtr\"}" ><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':\"objtr\"}" >	
							<span id="subidsSP" style="float:left;">
							<brow:browser viewType="0" name="subids" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id="departmentidSP" style="float:left;">
							<brow:browser viewType="0" name="departmentid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
							</span>
							 
							<span id="useridSP" style="float:left;">
							<brow:browser viewType="0" name="userid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id="roleidSP" style="float:left;">
							<brow:browser viewType="0" name="roleid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=65" linkUrl="/hrm/roles/HrmRolesShowEdit.jsp?type=0&id=" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id=showrolelevel name=showrolelevel style="float:left;width:130px;margin-left:10px;display:none">
							  <div style="float:left;margin-top:7px;height:17px;line-height:17px;">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>&nbsp;&nbsp;</div>
							  <SELECT class="InputStyle" name="rolelevel" id="rolelevel" style="width:60px;">
							    <option selected value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
							    <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
							    <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
							  </SELECT>
							</span>
						</wea:item>
						<!-- 安全级别 -->
						<wea:item attributes="{'samePair':\"sectr\"}"><%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':\"sectr\"}">
							<span id=showseclevel name=showseclevel style="display:''">
								<INPUT class="InputStyle" style="width:50px;" type=text id=seclevel name=seclevel size=6 value="0" onchange="checkinput('seclevel','seclevelimage')">
							    <SPAN id=seclevelimage></SPAN>
							    
							</span>
						</wea:item>

					</wea:group>
</wea:layout>

</form>  

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

<script language=javascript>

if("<%=isclose%>"=="1"){
    //alert("<%=isclose%>");
	var dialog = parent.getDialog(window);
	dialog.currentWindow.location.reload()
	dialog.close();	
}

function delplan(id){
	if(isdel()){
		location.href="RequestShareOperation.jsp?requestid=<%=requestid%>&wtid=<%=wtid%>&types=0&method=delete&id="+id;
	}
}

function btn_cancle(){
		var dialog = parent.getDialog(window);
		dialog.close();
}

function doSave(obj){
	thisvalue=document.weaver.sharetype.value;
	var checkstr="";
	if (thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4){
		checkstr="relatedshareid";
	}
	if(check_form(document.weaver, checkstr)){
		document.weaver.submit();
		obj.disabled=true;
	}
}
</script>

<script language=javascript>
function onChangeShareType() {
	thisvalue=jQuery("#sharetype").val();
 	//jQuery($GetEle("sectr")).css("display","");
 	//jQuery($GetEle("secline")).css("display","");
	showEle("sectr");
	showEle("objtr");
 	
	if (thisvalue == 1) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		hideEle("sectr", true);
    }
	else if (thisvalue == 2) {
		jQuery($GetEle("subidsSP")).css("display","");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		
		showEle("sectr");
	}
	else if (thisvalue == 3) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		showEle("sectr");
	}
	
	else if (thisvalue == 4) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","");
		jQuery($GetEle("showrolelevel")).css("display","");

	}
	else if (thisvalue == 5) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		showEle("sectr");
		hideEle("objtr", true);
	}
}

//特定应用
function hideTr(attrvalue){
   $('td').each(function(){
	  if($(this).attr('_samepair')){
	     if($(this).attr('_samepair') === attrvalue){
	        $(this).parent("tr").hide();
	        $(this).parent("tr").prev("tr").hide();
	     }
	  }
   })
}

function showTr(attrvalue){
   $('td').each(function(){
	  if($(this).attr('_samepair')){
	     if($(this).attr('_samepair') === attrvalue){
	        $(this).parent("tr").show();
	        $(this).parent("tr").prev("tr").show();
	     }
	  }
   })
}



function check_by_sharetype() {
    var re=/^\d+$/;
    var thisvalue=jQuery("#sharetype").val();
    var seclevel = jQuery("#seclevel").val();
    
    $("#sharetype").val(thisvalue);
    
    if (thisvalue == 1) {
        
        $("#sharevalue").val($("#userid").val());
        return check_form(weaverA, "userid");
        
           
    } else if (thisvalue == 2) {
        if(!re.test(seclevel))  {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        $("#sharevalue").val($("#subids").val());
        $("#formseclevel").val($("#seclevel").val());
        return check_form(weaverA, "subids, seclevel");

    } else if (thisvalue == 3) {
    
        if(!re.test(seclevel))  {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        
        $("#sharevalue").val($("#departmentid").val());
        $("#formseclevel").val($("#seclevel").val());
        
        return check_form(weaverA, "departmentid, seclevel");     
        
        
    } else if (thisvalue == 4) {
    	if(!re.test(seclevel))  {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        
        $("#sharevalue").val($("#roleid").val());
        $("#formseclevel").val($("#seclevel").val());
        $("#formrolelevel").val($("#rolelevel").val());
        return check_form(weaverA, "roleid, rolelevel, seclevel");
    } else if (thisvalue == 5) {
        if(!re.test(seclevel))  {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        
        $("#formseclevel").val($("#seclevel").val());
        return check_form(weaverA, "seclevel");
    } else {
        return false;
    }
}

jQuery(document).ready(function(){
	onChangeShareType();
	
});
</script>

<SCRIPT language=VBS>
sub onShowSubcompany(tdname,inputename)
    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="&inputename.value)
    if NOT isempty(id) then
        if id(0)<> "" then        
        resourceids = id(0)
        resourcename = id(1)
        sHtml = ""
        resourceids = Mid(resourceids,2,len(resourceids))
        resourcename = Mid(resourcename,2,len(resourcename))
        inputename.value = resourceids
        while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
        wend
        sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
        tdname.innerHtml = sHtml

        else
        tdname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
        inputename.value=""
        end if
    end if
end sub

sub onShowDepartment(spanname,inputname)
    linkurl="/hrm/company/HrmDepartmentDsp.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&inputname.value)
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
            sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
        wend
        sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
        spanname.innerHtml = sHtml
    else    
          spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
         inputname.value=""
    end if
    end if
end sub

sub onShowResource(spanname,inputname)
    linkurl="/hrm/resource/HrmResource.jsp?id="
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
            sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
        wend
        sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
         spanname.innerHtml = sHtml
    else    
         spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
         inputname.value=""
    end if
    end if
end sub

sub onShowRole(tdname,inputename)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
    if NOT isempty(id) then
        if id(0)<> "" then
        tdname.innerHtml = id(1)
        inputename.value=id(0)
        else
        tdname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
        inputename.value=""
        end if
    end if
end sub

</SCRIPT>
<script language="javascript">

function openFullWindowHaveBarTmp(url){
	var redirectUrl = url ;
	var width = screen.width ;
	var height = screen.height ;
	var szFeatures = "top=100," ; 
	szFeatures +="left=400," ;
	szFeatures +="width="+width/2+"," ;
	szFeatures +="height="+height/2+"," ; 
	szFeatures +="directories=no," ;
	szFeatures +="status=yes," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	if(typeof(window.dialogArguments) == "object"){
		openobj =  window.dialogArguments;
		openobj.open(redirectUrl,"",szFeatures);
	}else{
		window.open(redirectUrl,"",szFeatures);
	}
}
function OnComeBack(){
	location.href="/worktask/request/ViewWorktask.jsp?requestid=<%=requestid%>";
}

function onShowBrowser(spanname,inputname,browserType){
    var linkurl="";
    var dialogurl="";
    var selectedids=jQuery("#"+inputname).val();
    if(browserType==1){         //人力资源
       linkurl="/hrm/resource/HrmResource.jsp?id=";
       dialogurl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
    }else if(browserType==2){   //分部
       linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
       dialogurl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp";
    }else if(browserType==3){   //部门
       linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
       dialogurl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp";
    }else if(browserType==4){   //角色
       linkurl="";
       dialogurl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp";
    }   
    var results = window.showModalDialog(dialogurl+"?selectedids="+selectedids);
    if(results){
       if(results.id!=""){
          var id ="";
          var name = "";
          if(dialogurl=="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
          {
           	 id=results.id;
             name=results.name;
          }else{
             id=results.id.substr(1);
             name=results.name.substr(1);
          }
          
          var ids=id.split(",");
          var names=name.split(",");
          
          var sHtml="";
          for(var i=0;i<ids.length;i++){
              if(ids[i]!="")
                 sHtml=sHtml+"<a href="+linkurl+ids[i]+" target='blank'>"+names[i]+"</a>&nbsp";
          }
          jQuery("#"+inputname).val(id);
          jQuery("#"+spanname).html(sHtml);
       }else{
          jQuery("#"+inputname).val("");
          jQuery("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
       }
    }
}

</script>
</BODY>
</HTML>
