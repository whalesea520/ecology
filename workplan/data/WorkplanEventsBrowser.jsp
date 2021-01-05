
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>

<style type="text/css">
</style>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%

int timeSag = Util.getIntValue(request.getParameter("timeSag"),0);
int timeSagEnd = Util.getIntValue(request.getParameter("timeSagEnd"),0);

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:reset_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnOnOk(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
 
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btnOnCancel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
 
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnOnClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>			 
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="schedule"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage()) %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_top" onclick="btnOnSearch()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<div class="zDialog_div_content">
<FORM id=SearchForm name=SearchForm  method=post >

<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
	<wea:layout type="4col">
	     	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
		      <wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
		      <wea:item>
		      	<INPUT id="planname" class="InputStyle" maxlength="100" size="30" name="planname" >
		      </wea:item>
		      <wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
		      <wea:item>
		        	<SELECT name="urgentlevel" id="urgentlevel" style="width:100px;">
						<OPTION value=""  ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
						<OPTION value="1" ><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></OPTION>
						<OPTION value="2" ><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></OPTION>
						<OPTION value="3" ><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></OPTION>
					</SELECT>
		      </wea:item>
		      
		      <wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
		      <wea:item>
		      	<brow:browser viewType="0" name="createrid" browserValue="" 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' 
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
					browserSpanValue=""></brow:browser>
		      </wea:item>
		      <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		      <wea:item>
		        	<SELECT name="planstatus" id="planstatus" style="width:100px;">
						<OPTION value="" ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
						<OPTION value="0" selected><%=SystemEnv.getHtmlLabelName(16658,user.getLanguage())%></OPTION>
						<OPTION value="1" ><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></OPTION>
						<OPTION value="2" ><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>		
					</SELECT>
		      </wea:item>
		      
		      <wea:item><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%></wea:item>
		      <wea:item>			  		
				  	<INPUT type="hidden" name="receiveType" value="1" />
					<brow:browser viewType="0" name="receiveID" browserValue="" 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' 
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
					browserSpanValue=""></brow:browser>
						
		      </wea:item>
		      <wea:item><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></wea:item>
		      <wea:item>
					<SELECT name="plantype" id="plantype" style="width:100px;">
						<OPTION value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>											
						<%
				  			rs.executeSql("SELECT * FROM WorkPlanType ORDER BY displayOrder ASC");
				  			while(rs.next())
				  			{
				  		%>
				  			<OPTION value="<%= rs.getInt("workPlanTypeID") %>"><%= rs.getString("workPlanTypeName") %></OPTION>
				  		<%
				  			}
				  		%>
					</SELECT>
		      </wea:item>
		      
		       <wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
		       <wea:item attributes="{'colspan':'full'}">
		      		<span>
						<select name="timeSag" id="timeSag" onchange="changeDate(this,'wpbegindate');" style="width:100px;">
							<option value="0" <%=timeSag==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<option value="1" <%=timeSag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
							<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
							<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
							<option value="4" <%=timeSag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
							<option value="5" <%=timeSag==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
							<option value="6" <%=timeSag==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
						</select>
					</span>
					<span id="wpbegindate"  style="<%=timeSag==6?"":"display:none;" %>">
						<button type="button" class="Calendar" id="SelectBeginDate" onclick="getDate(begindatespan,begindate)"></BUTTON> 
					  	<SPAN id="begindatespan"></SPAN> 
				  		<INPUT type="hidden" name="begindate" value="">  
				  		&nbsp;-&nbsp;&nbsp;
				  		<button type="button" class="Calendar" id="SelectEndDate" onclick="getDate(enddatespan,enddate)"></BUTTON> 
				  		<SPAN id="enddatespan"></SPAN> 
					    <INPUT type="hidden" name="enddate" value="">
					</span>
		      </wea:item>
		      
		       <wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
		      <wea:item attributes="{'colspan':'full'}">
		      		<span>
						<select name="timeSagEnd" id="timeSagEnd" onchange="changeDate(this,'wpendate');" style="width:100px;">
							<option value="0" <%=timeSagEnd==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<option value="1" <%=timeSagEnd==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
							<option value="2" <%=timeSagEnd==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
							<option value="3" <%=timeSagEnd==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
							<option value="4" <%=timeSagEnd==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
							<option value="5" <%=timeSagEnd==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
							<option value="6" <%=timeSagEnd==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
						</select>
					</span>
					<span id="wpendate"  style="<%=timeSagEnd==6?"":"display:none;" %>">
						<button type="button" class="Calendar" id="SelectBeginDate2" onclick="getDate(begindatespan2,begindate2)"></BUTTON> 
					  	<SPAN id="begindatespan2"></SPAN> 
				  		<INPUT type="hidden" name="begindate2" value="">  
				  		&nbsp;-&nbsp;&nbsp;
				  		<button type="button" class="Calendar" id="SelectEndDate2" onclick="getDate(enddatespan2,enddate2)"></BUTTON> 
				  		<SPAN id="enddatespan2"></SPAN> 
					    <INPUT type="hidden" name="enddate2" value="">
					</span>
		      </wea:item>
		      
		      </wea:group>
	</wea:layout>	
	</div>
	<div id="dialog">
		<div id='colShow' ></div>
	</div>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" class="zd_btn_submit" accessKey=O  id="btnok" value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
				<input type="button" class="zd_btn_submit" accessKey=2  id="btnclear" value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
				<input type="button" class="zd_btn_cancle" accessKey=T  id="btncancel" value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</BODY>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">

jQuery(document).ready(function(){
	resizeDialog(document);
	 showMultiDocDialog("");
})
var parentWin = null;
var dialog = null;
try{
	dialog = parent.parent.getDialog(parent);
}catch(ex1){}

var config = null;
function showMultiDocDialog(selectids){
	
	config= rightsplugingForBrowser.createConfig();
    config.srchead=["<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%>"];
    config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;//取消实时保存
    config.srcurl = "/workplan/data/WorkplanEventsBrowserAjax.jsp?src=src";
    config.desturl = "/workplan/data/WorkplanEventsBrowserAjax.jsp?src=dest";
    config.pagesize = 10;
    config.formId = "SearchForm";
    config.searchAreaId = "e8QuerySearchArea";
    config.selectids = selectids;
	try{
		config.dialog = dialog;
	}catch(e){
		alert(e)
	}
   	jQuery("#colShow").html("");
    rightsplugingForBrowser.createRightsPluing(config);
    jQuery("#btnok").bind("click",function(){
    	rightsplugingForBrowser.system_btnok_onclick(config);
    });
    jQuery("#btnclear").bind("click",function(){
    	rightsplugingForBrowser.system_btnclear_onclick(config);
    });
    jQuery("#btncancel").bind("click",function(){
    	rightsplugingForBrowser.system_btncancel_onclick(config);
    });
    jQuery("#btnsearch").bind("click",function(){
    	rightsplugingForBrowser.system_btnsearch_onclick(config);
    });
}

function btnOnSearch(){
	rightsplugingForBrowser.system_btnsearch_onclick(config);
}

function btnOnOk(){
	rightsplugingForBrowser.system_btnok_onclick(config);
}

function btnOnClear(){
	rightsplugingForBrowser.system_btnclear_onclick(config);
}

function btnOnCancel(){
	rightsplugingForBrowser.system_btncancel_onclick(config);
}
 

function reset_onclick(){
	var advancedSearchDiv = "#SearchForm";
	 
	//清空日期
	jQuery(advancedSearchDiv).find(".Calendar").siblings("span").html("");
	jQuery(advancedSearchDiv).find(".Calendar").siblings("input[type='hidden']").val("");
	
	$('#planname').val("");
	
	$('#urgentlevel').val("");
	$("#urgentlevel").selectbox('detach');
	$("#urgentlevel").selectbox('attach');		
	
	$('#createrid').val("");
	$('#createridspan').html("");
	
	$('#planstatus').val("");
	$("#planstatus").selectbox('detach');
	$("#planstatus").selectbox('attach');
	
	$('#receiveID').val("");
	$('#receiveIDspan').html("");
	
	$('#plantype').val("");
	$("#plantype").selectbox('detach');
	$("#plantype").selectbox('attach');
	
	$('#timeSag').val("0");
	$("#timeSag").selectbox('detach');
	$("#timeSag").selectbox('attach');
	$('#wpbegindate').hide();
	
	$('#timeSagEnd').val("0");
	$("#timeSagEnd").selectbox('detach');
	$("#timeSagEnd").selectbox('attach');
	$('#wpendate').hide();
}

</script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
