<%@page import="weaver.hrm.definedfield.HrmFieldManager"%>
<%@page import="weaver.hrm.definedfield.HrmDeptFieldManager"%><%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="HrmFieldGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page"/>
<jsp:useBean id="HrmFieldComInfo" class="weaver.hrm.definedfield.HrmFieldComInfo" scope="page" />
<%
String userid =""+user.getUID();
/*权限判断,人力资产管理员以及其所有上级*/
boolean canView = false;
ArrayList allCanView = new ArrayList();
String tempsql ="select resourceid from HrmRoleMembers where roleid in (select roleid from SystemRightRoles where rightid=22)";
RecordSet.executeSql(tempsql);
while(RecordSet.next()){
    String tempid = RecordSet.getString("resourceid");
    allCanView.add(tempid);
}// end while
for (int i=0;i<allCanView.size();i++){
    if(userid.equals((String)allCanView.get(i))){
        canView = true;
    }
}
if(!canView) {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
/*权限判断结束*/
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
	int grouptype=Util.getIntValue(Util.null2String(request.getParameter("grouptype")),-1);

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = "";
	String needfav ="";
	String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:save(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="fieldlabelfrm" id=fieldlabelfrm method=post action="HrmFieldLabel.jsp">
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
<input type="hidden" value="" name="checkitems">

<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
<wea:group context="" attributes="{'groupDisplay':'none'}">
<wea:item attributes="{'isTableList':'true'}">
<TABLE CLASS="ListStyle" valign="top" cellspacing=1 style="position:fixed;z-index:99!important;">
      <colgroup>                           
      <col width="30%">
      <col width="30%">
      <col width="30%">
     <TR class="header">                                
		<TD style="display: none;"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD>
        <TD><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>)</TD>
        <TD><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(English)</TD>     
        <TD><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(33598,user.getLanguage())%>)</TD>
    </TR>
</TABLE>
</wea:item>
</wea:group>
<%    
//遍历分组
HrmFieldGroupComInfo.setTofirstRow();
HrmDeptFieldManager hfm = new HrmDeptFieldManager(grouptype);
while(HrmFieldGroupComInfo.next()){
	int type = Util.getIntValue(HrmFieldGroupComInfo.getType());
	if(grouptype!=type)continue; 
	String groupid = HrmFieldGroupComInfo.getid();
	List lsField = hfm.getLsField(groupid);
	if(lsField.size()==0)continue;
%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(Util.getIntValue(HrmFieldGroupComInfo.getLabel()), user.getLanguage()) %>' attributes="{'groupDisplay':''}">
<wea:item attributes="{'isTableList':'true'}">
<TABLE CLASS="ListStyle" valign="top" cellspacing=1 style="z-index:1!important;">
      <colgroup>                           
      <col width="30%">
      <col width="30%">
      <col width="30%">    
<%
for(int j=0;lsField!=null&&j<lsField.size();j++){
	String fieldid = (String)lsField.get(j);
	String isuse =  HrmFieldComInfo.getIsused(fieldid);
	if(!isuse.equals("1"))continue;
	String fieldname = HrmFieldComInfo.getFieldname(fieldid);
	int fieldlabel = Util.getIntValue(HrmFieldComInfo.getLabel(fieldid));
	String fieldlablename = SystemEnv.getHtmlLabelName(fieldlabel,7);
	String fieldlablenameE = Util.null2String(SystemEnv.getHtmlLabelName(fieldlabel,8));
	String fieldlablenameT = Util.null2String(SystemEnv.getHtmlLabelName(fieldlabel,9));
	String issystem = HrmFieldComInfo.getIssystem(fieldid);
	if(issystem.equals("1")){
	%>
	<tr class="DataLight">
		<td style="display: none;"><%=fieldname%></td>
		<td><%=fieldlablename%></td>
		<td><%=fieldlablenameE%></td>
		<td><%=fieldlablenameT%></td>
	</tr>
	<%}else{ %>
	<tr class="DataLight">
		<td style="display: none;"><%=fieldname%><input type="hidden" name="fieldname" value="<%=fieldname %>"></td>
		<td>
			<input type="text" class=InputStyle style="width:95%;" id="field_<%=fieldid%>_CN" name="field_<%=fieldid%>_CN" value="<%=fieldlablename%>" onchange="checkinput('field_<%=fieldid%>_CN','field_<%=fieldid%>_CN_span');setChange(<%=fieldid%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"><span id=field_<%=fieldid%>_CN_span></span>
		</td>
		<td>
			<input type="text" class=InputStyle style="width:95%;" name="field_<%=fieldid%>_En" value="<%=fieldlablenameE%>" onchange="setChange(<%=fieldid%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)">
		</td>
		<td>
			<input type="text" class=InputStyle style="width:95%;" name="field_<%=fieldid%>_TW" value="<%=fieldlablenameT%>" onchange="setChange(<%=fieldid%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)">
		</td>
	</tr>   
	<%} %> 
	<%} %>
</TABLE>
</wea:item>
</wea:group>
<%}%>
</wea:layout>

</form>

<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#fieldlabelfrm").submit();
}
function setChange(fieldid){
	$G("checkitems").value += "field_"+fieldid+"_CN,"
	var changefieldids = $G("changefieldids").value;
	if(changefieldids.indexOf(fieldid)<0){
		$G("changefieldids").value = changefieldids + fieldid + ",";
	}
}
function save(){
	fieldlabelfrm.action="HrmFieldOperation.jsp";
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
</script>

</body>
</html>
