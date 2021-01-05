
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.po.CoworkBaseSetComInfo"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.docs.category.CategoryUtil" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

<%
int userid=user.getUID();
if(!HrmUserVarify.checkUserRight("CoWorkAccessory:Maintenance", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
  %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(21274,user.getLanguage());
String needfav ="1";
String needhelp ="";
String itemstate="";
String infostate="";
String coworkstate="";
String dealchangeminute="";

CoworkBaseSetComInfo coworkBaseSetComInfo = new CoworkBaseSetComInfo();

int setcount= coworkBaseSetComInfo.size();//判断是否初次配置
if(coworkBaseSetComInfo.next()) {
    itemstate = coworkBaseSetComInfo.getItemstate();
    infostate = coworkBaseSetComInfo.getInfostate();
    dealchangeminute = coworkBaseSetComInfo.getDealchangeminute();
    coworkstate = coworkBaseSetComInfo.getCoworkstate();
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="collaboration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="submitData()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=mainform name=mainform action="CoworkBaseSettingOperation.jsp" method=post enctype="multipart/form-data">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage()) %>'>
        
        <wea:item><%=SystemEnv.getHtmlLabelName(130172,user.getLanguage()) %></wea:item>
        <wea:item>
            <input type="checkbox" tzCheckbox="true" name="itemstate" id="itemstate" value="1" <%=itemstate.equals("1")?"checked=checked":""%> class="inputstyle"/>
        </wea:item>
        
        <wea:item><%=SystemEnv.getHtmlLabelName(130173,user.getLanguage()) %></wea:item>
        <wea:item>
            <input type="checkbox" tzCheckbox="true" name="infostate" id="infostate" value="1" <%=infostate.equals("1")?"checked=checked":""%> class="inputstyle"/>
        </wea:item>
        
         <wea:item><%=SystemEnv.getHtmlLabelName(130174,user.getLanguage()) %></wea:item>
        <wea:item>
            <input type="checkbox" tzCheckbox="true" name="coworkstate" id="coworkstate" value="1" <%=coworkstate.equals("1")?"checked=checked":""%> class="inputstyle"/>
        </wea:item>
        
        <wea:item><%=SystemEnv.getHtmlLabelName(130175,user.getLanguage()) %></wea:item>
        <wea:item>
           <input  name="dealchangeminute"  id="dealchangeminute" value="<%= (setcount==0)?"10":dealchangeminute%>" maxlength="50" style="width :60px;"  class="InputStyle">
           &nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage()) %>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(130176,user.getLanguage()) %>
        </wea:item>
        
        
	</wea:group>
</wea:layout>
</FORM>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
	<script language=javascript>
		function submitData() {
			jQuery("#mainform").submit();
	
		}
	</script>