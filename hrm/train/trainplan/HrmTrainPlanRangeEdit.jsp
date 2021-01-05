<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML>
<%
if(!HrmUserVarify.checkUserRight("HrmArrangeShiftMaintance:Maintance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16749 , user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
String id = Util.null2String(request.getParameter("id"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
  <script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	var dialog = parent.parent.getDialog(parent);
	if("<%=isclose%>"=="1"){
		parentWin.onBtnSearchClick();
		parentWin.closeDialog();	
	}
  </script>
<script type="text/javascript">
	function jsSharetype(){
		var type = jQuery("#type_n").val();
		jQuery("input[name=resourceid]").val("");
		hideEle("item_subcompany");
		hideEle("item_department");
		hideEle("item_jobactivitie");
		hideEle("item_jobtitle");
		hideEle("item_resource");
		if(type == "5"){
			//分部
			showEle("item_subcompany");
		}else if(type == "1"){
			//部门
			showEle("item_department");
		}else if(type == "2"){
			//职务
			showEle("item_jobactivitie");
		}else if(type == "3"){
			//岗位
			showEle("item_jobtitle");
		}else if(type == "4"){
			//人力资源
			showEle("item_resource");
			hideEle("item_level");
		}
	}
	
	function jsSetRelate(e, data, name) {
		if (data!=""&&data.id != "") {
			jQuery("input[name=resourceid]").val(data.id);
		}
	}
</script>
</HEAD>
<BODY>
<%
String sql = "select type_n, resourceid, seclevel, seclevel_to from HrmTrainPlanRange where id = "+id;
rs.execute(sql);
rs.next();
String sharetype = rs.getString("type_n");
String relatedId = rs.getString("resourceid");
String relatedName = ""; 
if(sharetype.equals("5")){
	relatedName = SubCompanyComInfo.getSubcompanyname(relatedId);
}else if(sharetype.equals("1")){
	relatedName = DepartmentComInfo.getDepartmentname(relatedId);
}else if(sharetype.equals("2")){
	relatedName = JobActivitiesComInfo.getJobActivitiesname(relatedId);
}else if(sharetype.equals("3")){
	relatedName = JobTitlesComInfo.getJobTitlesname(relatedId);
}else if(sharetype.equals("4")){
	relatedName = ResourceComInfo.getLastname(relatedId);
}else if(sharetype.equals("0")){
	relatedName = SystemEnv.getHtmlLabelName(1340,7);
}
%>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=frmmain name=frmmain action="TrainPlanRangeOperation.jsp" method=post>
<input id=id name=id type=hidden value="<%=id %>">
<input id=operation name=operation type=hidden value="">
<input id=resourceid name=resourceid type=hidden value="<%=relatedId %>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361 , user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(106 , user.getLanguage())%></wea:item>
   	<wea:item>
			<select id="type_n" name="type_n" onchange="jsSharetype()">
			  <option value="0" <%=sharetype.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>  
        <option value="5" <%=sharetype.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
        <option value="1" <%=sharetype.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
        <option value="2" <%=sharetype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></option>
        <option value="3" <%=sharetype.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>            
        <option value="4" <%=sharetype.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>  
			</select>
   	</wea:item>
   	<wea:item attributes="{'samePair':'item_subcompany'}"><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></wea:item>
   	<wea:item attributes="{'samePair':'item_subcompany'}">
	  	<brow:browser viewType="0" name="subcompany" browserValue='<%=sharetype.equals("5")?relatedId:"" %>'
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
      completeUrl="/data.jsp?type=164" _callback="jsSetRelate" browserSpanValue='<%=sharetype.equals("5")?relatedName:"" %>'>
      </brow:browser>
   	</wea:item>
   	<wea:item attributes="{'samePair':'item_department'}"><%=SystemEnv.getHtmlLabelName(27511 , user.getLanguage())%></wea:item>
   	<wea:item attributes="{'samePair':'item_department'}">
   		<brow:browser viewType="0"  name="department" browserValue='<%=sharetype.equals("1")?relatedId:"" %>'
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
      completeUrl="/data.jsp?type=4" _callback="jsSetRelate" browserSpanValue='<%=sharetype.equals("1")?relatedName:"" %>'>
      </brow:browser>
   	</wea:item>
   	<wea:item attributes="{'samePair':'item_jobactivitie'}"><%=SystemEnv.getHtmlLabelName(1915 , user.getLanguage())%></wea:item>
   	<wea:item attributes="{'samePair':'item_jobactivitie'}">
   		<brow:browser viewType="0"  name="role" browserValue='<%=sharetype.equals("2")?relatedId:"" %>'
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobactivities/JobActivitiesBrowser.jsp"
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
      completeUrl="/data.jsp?type=jobactivity" _callback="jsSetRelate" browserSpanValue='<%=sharetype.equals("2")?relatedName:"" %>'>
      </brow:browser>
   	</wea:item>
   	<wea:item attributes="{'samePair':'item_jobtitle'}"><%=SystemEnv.getHtmlLabelName(6086 , user.getLanguage())%></wea:item>
   	<wea:item attributes="{'samePair':'item_jobtitle'}">
   		<brow:browser viewType="0"  name="role" browserValue='<%=sharetype.equals("3")?relatedId:"" %>'
      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
      completeUrl="/data.jsp?type=hrmjobtitles" _callback="jsSetRelate" browserSpanValue='<%=sharetype.equals("3")?relatedName:"" %>'>
      </brow:browser>
   	</wea:item>
   	<wea:item attributes="{'samePair':'item_resource'}"><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></wea:item>
   	<wea:item attributes="{'samePair':'item_resource'}">
   		<brow:browser viewType="0"  name="resource" browserValue='<%=sharetype.equals("4")?relatedId:"" %>'
      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
      completeUrl="/data.jsp" _callback="jsSetRelate" browserSpanValue='<%=sharetype.equals("4")?relatedName:"" %>'>
      </brow:browser>
   	</wea:item>
	 	<wea:item attributes="{'samePair':'item_level'}"><%=SystemEnv.getHtmlLabelName(683 , user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'item_level'}">
			<input name="seclevel" type="text" value="<%=rs.getInt("seclevel") %>" style="width: 60px">&nbsp;
			-&nbsp;<input name="seclevel_to" type="text" value="<%=rs.getInt("seclevel_to") %>" style="width: 60px">
		</wea:item>
	</wea:group>
</wea:layout>
 <%if("1".equals(isDialog)){ %>
 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr>
		    <td style="text-align:center;" colspan="3">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
		    </td>
	    </tr>
	</table>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			jsSharetype();
			
		});
	</script>
<%} %>
</FORM>
</BODY>
<script language=javascript>  
function submitData() {
	var type = jQuery("#type_n").val();
	if(type == 0 || (jQuery("#type_n").val()!="" && jQuery("#resourceid").val()!="")){
		frmmain.operation.value="add";
		frmmain.submit();
	}else{
		window.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
	}
}
</script>
</HTML>
