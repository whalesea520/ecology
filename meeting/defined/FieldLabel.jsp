<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.meeting.defined.MeetingFieldManager"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<jsp:useBean id="MeetingFieldGroupComInfo" class="weaver.meeting.defined.MeetingFieldGroupComInfo" scope="page"/>

<%
/*权限判断,管理员和有会议自定义卡片权限的人*/
if(!HrmUserVarify.checkUserRight("Meeting:fieldDefined", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
} 
/*权限判断结束*/
int grouptype=Util.getIntValue(request.getParameter("grouptype"),1);
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = "";
	String needfav ="";
	String needhelp ="";
	
	int langSize=LanguageComInfo.getLanguageNum()+1;
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:save(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="fieldlabelfrm" id=fieldlabelfrm method=post action="FieldLabel.jsp">
<input type="hidden" name="grouptype" value="<%=grouptype %>" >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="save();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<input type="hidden" value="save" name="method">
<input type="hidden" value="" name="changefieldids">
<input type="hidden" value="" name="changefieldnames">
<input type="hidden" value="" name="changefieldlabels">
<input type="hidden" value="" name="checkitems">


<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
<wea:group context="" attributes="{'groupDisplay':'none'}">
<wea:item attributes="{'isTableList':'true'}">
<TABLE CLASS="ListStyle" valign="top" cellspacing=1 style="position:fixed;z-index:99!important;">
      <colgroup>
      <col width="<%=100.0/langSize%>%">
      <%for(int i=1;i<langSize;i++){
    	  out.println("<col width='"+(100.0/langSize)+"%'>");
      }
      %>                           
 		
     <TR class="header">                                
		<TD style="display: none;"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD>
		<TD><%=SystemEnv.getHtmlLabelName(81910,user.getLanguage())%></TD>
		<%
		LanguageComInfo.setTofirstRow();
		while(LanguageComInfo.next()){
			out.println("<TD>"+SystemEnv.getHtmlLabelName(15456,user.getLanguage())+"("+LanguageComInfo.getLanguagename()+")</TD>");
		} 
		
		%>
    </TR>
</TABLE>
</wea:item>
</wea:group>

<%    
//遍历分组
MeetingFieldManager hfm = new MeetingFieldManager(grouptype);
List<String> groupList=hfm.getLsGroup();
List<String> fieldList=null;
for(String groupid:groupList){
	fieldList= hfm.getLsField(groupid);
	if(fieldList!=null&&fieldList.size()>0){
		
%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldGroupComInfo.getLabel(groupid)), user.getLanguage()) %>' attributes="{'groupDisplay':''}">
<wea:item attributes="{'isTableList':'true'}">
<TABLE CLASS="ListStyle" valign="top" cellspacing=1 style="z-index:1!important;">
      <colgroup>                           
      <col width="<%=100.0/langSize%>%">
      <%for(int i=1;i<langSize;i++){
    	  out.println("<col width='"+(100.0/langSize)+"%'>");
      }
      %>   
<%
for(String fieldid:fieldList){
	String id = fieldid;
	String fieldname = MeetingFieldComInfo.getFieldname(fieldid);
	int fieldlabel = Util.getIntValue(MeetingFieldComInfo.getLabel(fieldid));
	int sysfieldlabel = Util.getIntValue(MeetingFieldComInfo.getSysLabel(fieldid));
	boolean issystem ="1".equals(MeetingFieldComInfo.getIssystem(fieldid));
	if(issystem&&false){
	%>
	<tr class="DataLight">
		<td style="display: none;"><%=fieldname%></td>
		<td><%=sysfieldlabel!=-1?SystemEnv.getHtmlLabelName(sysfieldlabel,user.getLanguage()):""%></td>
		<%
		LanguageComInfo.setTofirstRow();
		while(LanguageComInfo.next()){
			int langid=Util.getIntValue(LanguageComInfo.getLanguageid());
			out.println("<TD>"+SystemEnv.getHtmlLabelName(fieldlabel,langid)+"</TD>");
		} 
		
		%>
	</tr>
	<%}else{ %>
	<tr class="DataLight editLabelTr">
		<td style="display: none;"><%=fieldname%>
		<input type="hidden" id="fieldname_<%=fieldid %>" name="fieldname" value="<%=fieldname %>">
		<input type="hidden" id="fieldlabel_<%=fieldid %>" name="fieldlabel" value="<%=fieldlabel %>">
		</td>
		<td><%=sysfieldlabel!=-1?SystemEnv.getHtmlLabelName(sysfieldlabel,user.getLanguage()):""%>
		<input type="hidden" id="sysfieldlabel_<%=fieldid %>" name="sysfieldlabel" value="<%=sysfieldlabel %>">
		<%if(sysfieldlabel>0&&sysfieldlabel!=fieldlabel){%>
				<img name="refreshImg" style="float:right;cursor: pointer;display:none" src="/images/ecology8/meeting/refish_wev8.png" title="<%=SystemEnv.getHtmlLabelName(32757,user.getLanguage())%>" onclick='refreshDefault("<%=fieldid %>")'>
		<% } %>
		
		</td>
		
		<%
		LanguageComInfo.setTofirstRow();
		while(LanguageComInfo.next()){
			int langid=Util.getIntValue(LanguageComInfo.getLanguageid());
		%>
			<td>
				<input type="text" class=InputStyle style="width:95%;" id="field_<%=id%>_<%=langid %>" name="field_<%=id%>_<%=langid %>" value="<%=SystemEnv.getHtmlLabelName(fieldlabel,langid)%>" onchange="checkinput('field_<%=id%>_<%=langid %>','field_<%=id%>_<%=langid %>_span');setChange(<%=id%>,<%=langid %>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"><span id=field_<%=id%>_<%=langid %>_span></span>
			</td>
		<%} 
		%>
	</tr>   
	<%} %> 
<%}%> 
</TABLE>
</wea:item>
</wea:group>
<%	}
}%>
</wea:layout>

</form>

<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#fieldlabelfrm").submit();
}

function setChange(fieldid,langid){
	$G("checkitems").value += "field_"+fieldid+"_7,"
	var changefieldids = $G("changefieldids").value;
	var changefieldnames = $G("changefieldnames").value;
	var changefieldlabels = $G("changefieldlabels").value;
	if(changefieldids.indexOf(fieldid)<0){
		$G("changefieldids").value = changefieldids + fieldid + ",";
		var fieldname = jQuery("#fieldname_"+fieldid).val();
		var fieldlabel = jQuery("#fieldlabel_"+fieldid).val();
		$G("changefieldnames").value = changefieldnames + fieldname + ",";
		$G("changefieldlabels").value = changefieldlabels + fieldlabel + ",";
	}
}

function save(){
	fieldlabelfrm.action="FieldLabelOperation.jsp";
	var checks = $G("checkitems").value;
	if(check_form(fieldlabelfrm,checks)){
		fieldlabelfrm.submit();
	}else{
		return;
	}		
}
$(function(){
	//高亮搜索
	$("#topTitle").topMenuTitle({});
});

$(document).ready(function(){
	jQuery(".editLabelTr").hover(function(){
		if($(this).find("img[name='refreshImg']").length>0){
			$(this).find("img[name='refreshImg']").show();
		} 
	},function(){
		 if($(this).find("img[name='refreshImg']").length>0){
			$(this).find("img[name='refreshImg']").hide();
		} 
	});
	jQuery("img[name='refreshImg']").hover(function(){
		 $(this).attr('src','/images/ecology8/meeting/refish_s_wev8.png');
	},function(){
		$(this).attr('src','/images/ecology8/meeting/refish_wev8.png');
	});
});

function refreshDefault(fieldid){
	fieldlabelfrm.action="FieldLabelOperation.jsp";
	$G("method").value="refreshLabel";
	$G("changefieldids").value=fieldid;
	fieldlabelfrm.submit();
}
</script>

</body>
</html>
