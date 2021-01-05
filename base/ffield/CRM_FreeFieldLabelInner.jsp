
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.crm.util.CrmFieldComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<HTML>
<HEAD>


<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}
function setChange(fieldid){
	$G("checkitems").value += "field_"+fieldid+"_CN,"
	var changefieldids = $G("changefieldids").value;
	if(changefieldids.indexOf(fieldid)<0)
		$G("changefieldids").value = changefieldids + fieldid + ",";
}
function fieldlablesall0(){
	var checks = $G("checkitems").value;
	if(check_form(fieldlabelfrm,checks)){
		fieldlabelfrm.submit();
	}else{
		return;
	}		
}


</script>

</head>
<%

String usetable=Util.null2String(request.getParameter("usetable"));
boolean canedit = false;
if(usetable.equals("c1")){
	usetable = "CRM_CustomerInfo";
	canedit = HrmUserVarify.checkUserRight("CustomerAccountFreeFeildEdit:Edit", user);
}else if(usetable.equals("c2")){
	usetable = "CRM_CustomerContacter";
	canedit = HrmUserVarify.checkUserRight("CustomerContactorFreeFeildEdit:Edit", user);
}else if(usetable.equals("c3")){
	usetable = "CRM_CustomerAddress";
	canedit = HrmUserVarify.checkUserRight("CustomerAddressFreeFeildEdit:Edit", user);
}else if(usetable.equals("c4")){
	usetable = "CRM_SellChance";
	canedit = HrmUserVarify.checkUserRight("CustomerAddressFreeFeildEdit:Edit", user);
}

%>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:fieldlablesall0(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<form name="fieldlabelfrm" id=fieldlabelfrm method=post action="CRM_FreeFieldOperation.jsp">
<input type="hidden" value="editfieldlabel" name="method">
<input type="hidden" value="" name="changefieldids">
<input type="hidden" value="" name="checkitems">
<input type="hidden" value="<%=usetable %>" name="usetable">
<%if(canedit){ %>
	<table id="topTitle" cellpadding="0" cellspacing="0" >
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan">
				<input type=button class="e8_btn_top" onclick="fieldlablesall0();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table> 
<%} %>

	 <wea:layout type="table" attributes="{'cols':'4','cws':'25%,25%,25%,25%'}" >
	 	<wea:group context="" attributes="{'groupDisplay':'none','groupOperDisplay':'none'}">
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>)</wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(English)</wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=LanguageComInfo.getLanguagename("9")%>)</wea:item>
			
		</wea:group>
	 </wea:layout>
		
	<%
	CrmFieldComInfo comInfo = new CrmFieldComInfo() ;
	rs.execute("select t1.*,t2.* from CRM_CustomerDefinFieldGroup t1 left join "+
			"(select groupid,count(groupid) groupcount from CRM_CustomerDefinField where usetable = '"+usetable+"' and isopen=1 group by groupid) t2 "+
			"on t1.id=t2.groupid "+
			"where t1.usetable = '"+usetable+"' and t2.groupid is not null order by t1.dsporder asc");
	while(rs.next()){
		String groupid = rs.getString("id");
		int groupcount = Util.getIntValue(rs.getString("groupcount"),0);
		if(groupcount==0) continue;
	%>
	 <wea:layout type="table" attributes="{'cols':'4','cws':'25%,25%,25%,25%','layoutTableId':'dataTableList'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(rs.getInt("grouplabel"),user.getLanguage())%>'>
			<wea:item></wea:item>
			<wea:item></wea:item>
			<wea:item></wea:item>
			<wea:item></wea:item>
			<% 
				while(comInfo.next()){
					if(usetable.equals(comInfo.getUsetable())&&groupid.equals(comInfo.getGroupid().toString())){
					String id = comInfo.getId();
					String fieldlablename = SystemEnv.getHtmlLabelName(Util.getIntValue(comInfo.getFieldlabel()),7);
					String fieldlablenameE = SystemEnv.getHtmlLabelName(Util.getIntValue(comInfo.getFieldlabel()),8);
					String fieldlablenameT = SystemEnv.getHtmlLabelName(Util.getIntValue(comInfo.getFieldlabel()),9);
			%>
				<wea:item><%=comInfo.getFieldname()%></wea:item>
				<wea:item>
					<%if(comInfo.getCandel().equals("y") && canedit){ %>
					<input type="text" class="inputstyle" style="width:90%;" name="field_<%=id%>_CN" value="<%=fieldlablename%>" onchange="checkinput('field_<%=id%>_CN','field_<%=id%>_CN_span');setChange(<%=id%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"><span id=field_<%=id%>_CN_span></span>
					<%}else{
						out.println(fieldlablename);
					} %>
				</wea:item>
				<wea:item>&nbsp;&nbsp;&nbsp;
				<%if(comInfo.getCandel().equals("y") && canedit){ %>
					<input type="text" class="inputstyle" style="width:90%;" name="field_<%=id%>_En" value="<%=fieldlablenameE%>" onchange="setChange(<%=id%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)">
				<%}else{
					out.println(fieldlablenameE);
				} %>
				</wea:item>
				
				<wea:item>&nbsp;&nbsp;&nbsp;
				<%if(comInfo.getCandel().equals("y") && canedit){ %>
	  				<input type="text" class=inputstyle style="width:90%;" name="field_<%=id%>_TW" value="<%=fieldlablenameT%>" onchange="setChange(<%=id%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)">
				<%}else{
					out.println(fieldlablenameT);
				} %>
				</wea:item>
			<%}}%>	
		</wea:group>
	 </wea:layout>
	<%}%>
</form>

<script type="text/javascript">
jQuery(function(){
	jQuery("table[id='dataTableList']").each(function(){
		jQuery(this).find(".ListStyle tr:eq(0)").hide();
		jQuery(this).find(".ListStyle tr:eq(1)").hide();
	})
})

</script>
</body>

</html>
