
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%

String method=Util.null2String(request.getParameter("method"));
String from=Util.null2String(request.getParameter("from"));

%>
<HTML><HEAD>
<link rel=stylesheet type="text/css" href="/css/Weaver_wev8.css">
<script language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
//搜索:车辆
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(920,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:onGoSearch(),_self} " ;//查询
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;"><!-- 查询 -->
				<input class="e8_btn_top middle" onclick="javascript:onGoSearch()" type="button" value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name="frmain" action="/car/CarSearchResult.jsp" method=post>
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<input class=inputstyle type="hidden" name="destination" value="no"> 
<input type="hidden" name="from" value="<%=from%>"> 
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(82287,user.getLanguage())%>'><!-- 查询信息 -->
		<wea:item><!-- 车辆类型 -->
			<%=SystemEnv.getHtmlLabelName(920,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<%
				RecordSetCT.executeProc("CarType_Select","");
				while(RecordSetCT.next()){
			%>			
					<input class=inputstyle name="carType" type="checkbox" value="<%=RecordSetCT.getString("id")%>"><%=Util.toScreen(RecordSetCT.getString("name"),user.getLanguage())%>
			<%  }  %>	
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20319,user.getLanguage())%><!-- 车牌号 -->
		</wea:item>
		<wea:item>
			<INPUT type="text" class=Inputstyle name="carNo">
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%><!-- 厂牌型号 -->
		</wea:item>
		<wea:item>
			<INPUT type="text" class=Inputstyle name="factoryNo">
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%><!-- 购置日期 -->
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>&nbsp;&nbsp;<!-- 从 -->
			<input id="startdate" name="startdate" type="hidden" class=wuiDate  ></input> 
				
			<%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>&nbsp;&nbsp;<!-- 到 -->
			<input id="enddate" name="enddate" type="hidden" class=wuiDate />
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%><!-- 司机 -->
		</wea:item>
		<wea:item>
			<brow:browser viewType="0" name="driver" browserValue="" 
  		 				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp" linkUrl=""  width="228px" 
						browserDialogWidth="500px"
						browserSpanValue=""
						></brow:browser>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
<script language=javascript>
function onGoSearch(){
	weaver.destination.value="goSearch";
	weaver.submit();
}
function onClear(){
	$("form input[name='carType']").each(function(){
		changeCheckboxStatus(this,false);
	});
	$('form input[type=text]').val('');
	$('form textarea').val('');
	$('form select').val('');
	$("form input[id='driver']").val('');
	$("form span[id='driverspan']").text('');
	$("form input[id='startdate']").val('');
	$("form span[id^='startdate']").text('');
	$("form input[id='enddate']").val('');
	$("form span[id^='enddate']").text('');
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</HTML>
