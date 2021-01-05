
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.job.JobTitlesComInfo"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
		<script type="text/javascript" src="/cowork/js/cowork_wev8.js"></script>
	</HEAD>
<%
if(! HrmUserVarify.checkUserRight("collaborationarea:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}

String settype = Util.null2String(request.getParameter("settype"));
String cotypeid = Util.null2String(request.getParameter("cotypeid"));
	
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17718,user.getLanguage())+"：";
String headname = "";
if(settype.equals("manager")){
    titlename += SystemEnv.getHtmlLabelName(2097,user.getLanguage());
    headname = SystemEnv.getHtmlLabelName(2097,user.getLanguage());
}else if(settype.equals("members")){
    titlename +=SystemEnv.getHtmlLabelName(271,user.getLanguage());
    headname =SystemEnv.getHtmlLabelName(271,user.getLanguage());
}
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="doSubmit(this)" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height:398px;">
<FORM name="weaver" action="CoworkTypeShareOption.jsp">												
<INPUT type="hidden" name="method" value="add">
<INPUT type="hidden" name="delid">
<INPUT type="hidden" name="cotypeid" value="<%=cotypeid%>">		
<INPUT type="hidden" name="settype" value="<%=settype%>">
<input type="hidden" name="relatedshareid" id="relatedshareid">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19342,user.getLanguage()) %>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%></wea:item>
		<wea:item>
			<SELECT  class=InputStyle name=sharetype style="width: 120px;">
			  	<OPTION value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION> 
				<OPTION value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION> 
				<OPTION value="3"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION> 
				<OPTION value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></OPTION> 
				<OPTION value="5"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></OPTION> 
				<option value="6"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>
			</SELECT>
		</wea:item>
		
		<wea:item attributes="{'samePair':'showsharetype'}"><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showsharetype'}">
			<div id="resourceDiv">
				<brow:browser viewType="0" name="relatedshareid_1" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp" width="180px" ></brow:browser> 
			</div>
			
			<div id="departmentDiv">
				<brow:browser viewType="0" name="relatedshareid_2" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=57" width="180px;" ></brow:browser> 
			</div>
			
			<div id="subcompanyDiv">
				<brow:browser viewType="0" name="relatedshareid_3" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=164" width="180px" ></brow:browser> 
			</div>
			
			<div id="roleDiv">
				<brow:browser viewType="0" name="relatedshareid_4" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp?selectedids="
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=65" width="180px" ></brow:browser> 
			</div>
			<span id="showjobtitle" style="display:none">
				<brow:browser viewType="0" name="relatedshareid_6" browserValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?resourceids="
					hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
					completeUrl="/data.jsp?type=24" width="60%" browserSpanValue="" >
				</brow:browser>
			</span>			
		</wea:item>
	
		<wea:item attributes="{'samePair':'item_jobtitlelevel'}"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'item_jobtitlelevel'}">
			<SELECT id=jobtitlelevel name=jobtitlelevel onchange="onjobtitlelevelChange()" style="float: left;">
				<option value="0" selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
				<option value="1"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>
				<option value="2"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>
			</SELECT>
			<span id="showjobtitlesubcompany" style="display:none">
				<brow:browser viewType="0" name="jobtitlesubcompany" browserValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
					hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
					completeUrl="/data.jsp?type=164" width="60%" browserSpanValue="">
				</brow:browser>
			</span>
			<span id="showjobtitledepartment" style="display:none">
				<brow:browser viewType="0" name="jobtitledepartment" browserValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
					hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
					completeUrl="/data.jsp?type=4" width="60%" browserSpanValue="">
				</brow:browser>
			</span>
		</wea:item>		
		<wea:item attributes="{'samePair':'showrolelevel'}"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showrolelevel'}">
			<SELECT class=InputStyle  name=rolelevel id="showrolelevel" style="width: 120px;">
			  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
			</SELECT>
		</wea:item>
		
		<wea:item attributes="{'samePair':'showseclevelPair'}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showseclevelPair'}">
			<wea:required id="seclevelimage" required="true">
				<INPUT class=InputStyle maxLength=3 size=5 name=seclevel id="showseclevel" onKeyPress="ItemCount_KeyPress()" 
					onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10" style="width: 68px;">
			</wea:required>
			-
			<wea:required id="seclevelMaximage" required="true">
				<INPUT class=InputStyle maxLength=3 size=5 name=seclevelMax onKeyPress="ItemCount_KeyPress()" 
					onBlur='checknumber("seclevelMax");checkinput("seclevelMax","seclevelMaximage")' value="100" style="width: 68px;">
			</wea:required>
		 </wea:item>
	</wea:group>
</wea:layout>

<wea:layout type="4col" attributes="{'cw1':'30%','cw2':'30%','cw3':'30%','cw4':'10%'}">
	<wea:group context='<%=headname%>'>
<%
		String sql = "";
		if(settype.equals("manager")) sql = "select * from cotype_sharemanager where cotypeid="+cotypeid+" order by sharetype";
		else if(settype.equals("members")) sql = "select * from cotype_sharemembers where cotypeid="+cotypeid+" order by sharetype";
		rs.executeSql(sql);
		while (rs.next()){
   			String typeid = rs.getString("id");
   			String sharetype = Util.null2String(rs.getString("sharetype"));
   			String sharevalue = Util.null2String(rs.getString("sharevalue"));
   			if(sharevalue.equals("")) continue;
   			String seclevel = Util.null2String(rs.getString("seclevel"));
   			String seclevelMax = Util.null2String(rs.getString("seclevelMax"));
   			String rolelevel = Util.null2String(rs.getString("rolelevel"));
			String jobtitleid = Util.null2String(rs.getString("jobtitleid"));
			String joblevel = Util.null2String(rs.getString("joblevel"));
			String scopeid = Util.null2String(rs.getString("scopeid"));
   			if (sharetype.equals("1")){//人力资源%>
   			
		  		<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
				<wea:item attributes="{'colspan':'2'}">
				<%
					    out.print(Util.toScreen(resourceComInfo.getResourcename(sharevalue),user.getLanguage()));
				%>
				</wea:item>
				<wea:item>
					<A href="javascript:void(0)" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>
				</wea:item>
				
			<%}else if (sharetype.equals("2")){//部门%>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
				<wea:item attributes="{'colspan':'2'}">
					<table width="100%">
						<tr>
							<td width="50%"><%=Util.toScreen(departmentComInfo.getDepartmentname(sharevalue),user.getLanguage()) %></td>
							<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+seclevel+" - "+seclevelMax %></td>
						</tr>
					</table>
				</wea:item>
				<wea:item> 
					<A href="javascript:void(0)" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A> 
				</wea:item>
			<%}else if (sharetype.equals("4")){//角色%>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
				<wea:item attributes="{'colspan':'2'}">
					<%
						String solename=Util.toScreen(rolesComInfo.getRolesRemark(sharevalue), user.getLanguage()) + "/";
						if (rolelevel.equals("0")){
							solename += SystemEnv.getHtmlLabelName(124,user.getLanguage());
						}else if (rolelevel.equals("1")){
							solename += SystemEnv.getHtmlLabelName(141,user.getLanguage());
						}else if (rolelevel.equals("2")){
						    solename += SystemEnv.getHtmlLabelName(140,user.getLanguage());
						}
					%>
					<table width="100%">
						<tr>
							<td width="50%"><%=solename %></td>
							<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+seclevel+" - "+seclevelMax %></td>
						</tr>
					</table>
				</wea:item>
				<wea:item> 
					<A href="javascript:void(0)" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A> 
				</wea:item>
			<%} else if (sharetype.equals("5")){//所有人%>
		  		<wea:item><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></wea:item>
				<wea:item attributes="{'colspan':'2'}"> <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=seclevel+" - "+seclevelMax%></wea:item>
				<wea:item> 
					<A href="javascript:void(0)" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A> 
				</wea:item>
			<%}else if (sharetype.equals("3")){//分部%>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
				<wea:item  attributes="{'colspan':'2'}">
					<table width="100%">
						<tr>
							<td width="50%"><%=Util.toScreen(subCompanyComInfo.getSubCompanyname(sharevalue),user.getLanguage()) %></td>
							<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+seclevel+" - "+seclevelMax %></td>
						</tr>
					</table>					
				</wea:item>
				<wea:item> 
					<A href="javascript:void(0)" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A> 
				</wea:item>
			<%}else if (sharetype.equals("6")){//岗位%>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
				<wea:item  attributes="{'colspan':'2'}">
					<%
						String contents[]=sharevalue.split(",");
						String contentName="";
						String showname = "";
						JobTitlesComInfo job=new JobTitlesComInfo();
						for(int i=0;i<contents.length;i++){
							if(!"".equals(contents[i])) {
								showname = Util.toHtml(job.getJobTitlesname(contents[i]));
								if("1".equals(joblevel)&&!"".equals(scopeid)&&scopeid!=null){
									showname += "/指定部门("+departmentComInfo.getDeptnames(scopeid)+")";
								}
								if("2".equals(joblevel)&&!"".equals(scopeid)&&scopeid!=null){
									showname += "/指定分部("+subCompanyComInfo.getSubcompanynames(scopeid)+")";
								}
								contentName=contentName+","+showname;
							}
						}
						if(contentName.startsWith(","))contentName=contentName.substring(1);
						out.print(contentName);
					%>
				</wea:item>
				<wea:item> 
					<A href="javascript:void(0)" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A> 
				</wea:item>			
			<%} 
		}%>
	</wea:group>
</wea:layout>
</FORM>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.closeWin();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  

<SCRIPT language="JavaScript">

jQuery(function(){
  	hideEle("showrolelevel","true");
  	checkinput("seclevel","seclevelimage");
  	checkinput("seclevelMax","seclevelMaximage");
  	
  		hideEle("item_seclevel");
	hideEle("item_jobtitlelevel");
  	
  	jQuery("#resourceDiv").hide();
	jQuery("#subcompanyDiv").hide();
	jQuery("#roleDiv").hide();
	
	jQuery("select[name='sharetype']").live("change",function(){
		onChangeSharetype();
	})
  });
  
  
  
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
  	
	showEle('showseclevel',"true");
	showEle('showsharetype',"true");
	hideEle("showrolelevel","true");
	
	jQuery("#resourceDiv").hide();
	jQuery("#departmentDiv").hide();
	jQuery("#subcompanyDiv").hide();
	jQuery("#roleDiv").hide();
	
	hideEle("item_seclevel");
	hideEle("showrolelevel");
	hideEle("item_jobtitlelevel");
	$GetEle("showjobtitle").style.display='none';
	$GetEle("showjobtitlesubcompany").style.display='none';
	$GetEle("showjobtitledepartment").style.display='none';
		
	if(thisvalue==1){
		hideEle('showseclevel','true');
		jQuery("#resourceDiv").show();
	}
	
	if(thisvalue==2){
 		jQuery("#departmentDiv").show();
	}
	
	if(thisvalue==3){
 		jQuery("#subcompanyDiv").show();
	}
	
	if(thisvalue==4){
 		jQuery("#roleDiv").show();
		showEle("showrolelevel","true");
	}
	if(thisvalue==5){
		hideEle("showsharetype","true");
	}
	if(thisvalue==6){
		hideEle('showseclevel','true');
		$GetEle("showjobtitle").style.display='';
		showEle("item_jobtitlelevel");
	}
	
}


function doSubmit(obj) {
	thisvalue=document.weaver.sharetype.value;
	if(thisvalue==5){
		jQuery("#relatedshareid").val("");
	}else{
		jQuery("#relatedshareid").val(jQuery("#relatedshareid_"+thisvalue).val());
	}
	
	var checkinfo = "relatedshareid,seclevel,seclevelMax";
	if(thisvalue==1){//人力资源
		checkinfo = "relatedshareid";
	}
	if(thisvalue==5){//所有人
		checkinfo = "";
	}
	
    if(check_form(weaver,checkinfo)){
    	enableAllmenu(); //禁用所有按钮
        weaver.submit();
    }
}

function goBack() {
	document.weaver.action = "/workplan/data/WorkPlanDetail.jsp";
	document.weaver.submit();
}

function doDelete(recId) {
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		document.all("delid").value = recId;
		document.weaver.method.value = "delete";
		document.weaver.submit();
	});

}

function onjobtitlelevelChange(){
	$GetEle("showjobtitlesubcompany").style.display='none';
	$GetEle("showjobtitledepartment").style.display='none';
	if(jQuery("#jobtitlelevel").val()=="1"){
		$GetEle("showjobtitledepartment").style.display='';
	}else if(jQuery("#jobtitlelevel").val()=="2"){
		$GetEle("showjobtitlesubcompany").style.display='';
	}
}
</SCRIPT>
</BODY>
</HTML>
