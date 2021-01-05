<%@page import="java.text.DecimalFormat"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.general.BrowserElement"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<%
//new LabelComInfo().removeLabelCache();
if (!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user) && !HrmUserVarify.checkUserRight("BudgetManualTransfer:do", user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//通用设置
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

//是否结转设置
boolean ifbudgetmove = false;
boolean mBudgetMove = false;
boolean qBudgetMove = false;
boolean hBudgetMove = false;
int budgetAutoMovePending = 0;//结转时是否结转审批中预算
int timeModul = 0;
int dayTime1 = 1;
int fer = 1;
int dayTime2 = 1;
int autoMoveMinusAmt = 1;//是否结转超额费用

rs.executeSql("select * from FnaSystemSet");
if(rs.next()){
	ifbudgetmove = 1==rs.getInt("ifbudgetmove");
	String movetypes = rs.getString("movetypes");
	if((","+movetypes+",").indexOf(",1,") >= 0){
		mBudgetMove = true;
	}
	if((","+movetypes+",").indexOf(",2,") >= 0){
		qBudgetMove = true;
	}
	if((","+movetypes+",").indexOf(",3,") >= 0){
		hBudgetMove = true;
	}
	budgetAutoMovePending = Util.getIntValue(rs.getString("budgetAutoMovePending"), 0);
	timeModul = Util.getIntValue(rs.getString("timeModul"), 0);
	dayTime1 = Util.getIntValue(rs.getString("dayTime1"), 1);
	fer = Util.getIntValue(rs.getString("fer"), 1);
	dayTime2 = Util.getIntValue(rs.getString("dayTime2"), 1);
	autoMoveMinusAmt = Util.getIntValue(rs.getString("autoMoveMinusAmt"), 0);
}

//FnaBudgetInfoDetail表有脏数据
boolean haveDirtyData_FnaBudgetInfoDetail = false;
String sql = "select count(*) cnt \n" +
" from FnaBudgetInfoDetail a \n" +
" where not EXISTS (select 1 from FnaBudgetInfo b where a.budgetinfoid = b.id)";
rs.executeSql(sql);
if(rs.next() && rs.getInt("cnt")>0){
	haveDirtyData_FnaBudgetInfoDetail = true;
}
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<body style="">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self}";
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post" action="/fna/budget/FnaSystemSetOperation.jsp">
<input id="operation" name="operation" value="FnaJzSetInner" type="hidden" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" 
				class="e8_btn_top" onclick="doSave();"/><!-- 保存 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(82751,user.getLanguage())%>' ><!-- 基础设置 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></wea:item><!-- 启用 -->
			<wea:item>
    			<input id="ifbudgetmove" name="ifbudgetmove" value="1" type="checkbox" tzCheckbox="true" <%=(ifbudgetmove)?"checked":"" %>
    				onclick="ifbudgetmove_onClick();" />
			</wea:item>
			
			<wea:item attributes="{'customAttrs':'id=tD1budgetAutoMovePending'}"><%=SystemEnv.getHtmlLabelNames("126696",user.getLanguage())%></wea:item><!-- 结转审批中费用 -->
			<wea:item attributes="{'customAttrs':'id=tD2budgetAutoMovePending'}">
    			<input id="budgetAutoMovePending" name="budgetAutoMovePending" value="1" type="checkbox" tzCheckbox="true" <%=(budgetAutoMovePending==1)?"checked":"" %> />
			</wea:item>
			
			<wea:item attributes="{'customAttrs':'id=tD1autoMoveMinusAmt'}"><%=SystemEnv.getHtmlLabelNames("128284",user.getLanguage())%></wea:item><!-- 结转超额费用 -->
			<wea:item attributes="{'customAttrs':'id=tD2autoMoveMinusAmt'}">
    			<input id="autoMoveMinusAmt" name="autoMoveMinusAmt" value="1" type="checkbox" tzCheckbox="true" <%=(autoMoveMinusAmt==1)?"checked":"" %> />
			</wea:item>
			
			<wea:item attributes="{'customAttrs':'id=tD1mBudgetMove'}"><%=SystemEnv.getHtmlLabelName(33080,user.getLanguage())%></wea:item><!-- 月度结转 -->
			<wea:item attributes="{'customAttrs':'id=tD2mBudgetMove'}">
    			<input id="mBudgetMove" name="mBudgetMove" value="1" type="checkbox" tzCheckbox="true" <%=(mBudgetMove)?"checked":"" %> />
			</wea:item>
			
			<wea:item attributes="{'customAttrs':'id=tD1qBudgetMove'}"><%=SystemEnv.getHtmlLabelName(33081,user.getLanguage())%></wea:item><!-- 季度结转 -->
			<wea:item attributes="{'customAttrs':'id=tD2qBudgetMove'}">
   				<input id="qBudgetMove" name="qBudgetMove" value="2" type="checkbox" tzCheckbox="true" <%=(qBudgetMove)?"checked":"" %> />
			</wea:item>
			
			<wea:item attributes="{'customAttrs':'id=tD1hBudgetMove'}"><%=SystemEnv.getHtmlLabelName(33082,user.getLanguage())%></wea:item><!-- 半年结转 -->
			<wea:item attributes="{'customAttrs':'id=tD2hBudgetMove'}">
   				<input id="hBudgetMove" name="hBudgetMove" value="3" type="checkbox" tzCheckbox="true" <%=(hBudgetMove)?"checked":"" %> />
			</wea:item>
			
			<wea:item attributes="{'customAttrs':'id=tD1btnBudgetMove'}"><%=SystemEnv.getHtmlLabelName(126695,user.getLanguage())%></wea:item><!-- 自动结转频率 -->
			<wea:item attributes="{'customAttrs':'id=tD2btnBudgetMove'}">
				<span class="itemspan">
				<select id="timeModul" name="timeModul" onchange="timeModul_onchange();">
					<option value="0" <%if(0==timeModul){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(127117,user.getLanguage())%></option><!-- 自定义结转周期 -->
					<option value="1" <%if(1==timeModul){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24625,user.getLanguage())%></option><!-- 每天 -->
					<option value="2" <%if(2==timeModul){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></option><!-- 每月 -->
				</select>
				</span>
				<span id="timeModul0" class="itemspan">
   				<input id="btnBudgetMove" name="btnBudgetMove" value="<%=SystemEnv.getHtmlLabelName(126674,user.getLanguage())%>" 
   					onclick="doFnaZdJz();"
   					type="button" class="e8_btn_top" style="margin-left: 2px;" />
				</span>
				<span id="timeModul1" class="itemspan">
				<select id="dayTime1" name="dayTime1" style="width: 80px !important;">
					<option value="1" <%if(1==dayTime1){%>selected<%}%>>01:00</option>
					<option value="2" <%if(2==dayTime1){%>selected<%}%>>02:00</option>
					<option value="3" <%if(3==dayTime1){%>selected<%}%>>03:00</option>
					<option value="4" <%if(4==dayTime1){%>selected<%}%>>04:00</option>
					<option value="5" <%if(5==dayTime1){%>selected<%}%>>05:00</option>
					<option value="6" <%if(6==dayTime1){%>selected<%}%>>06:00</option>
					<option value="7" <%if(7==dayTime1){%>selected<%}%>>07:00</option>
					<option value="8" <%if(8==dayTime1){%>selected<%}%>>08:00</option>
					<option value="9" <%if(9==dayTime1){%>selected<%}%>>09:00</option>
					<option value="10" <%if(10==dayTime1){%>selected<%}%>>10:00</option>
					<option value="11" <%if(11==dayTime1){%>selected<%}%>>11:00</option>
					<option value="12" <%if(12==dayTime1){%>selected<%}%>>12:00</option>
					<option value="13" <%if(13==dayTime1){%>selected<%}%>>13:00</option>
					<option value="14" <%if(14==dayTime1){%>selected<%}%>>14:00</option>
					<option value="15" <%if(15==dayTime1){%>selected<%}%>>15:00</option>
					<option value="16" <%if(16==dayTime1){%>selected<%}%>>16:00</option>
					<option value="17" <%if(17==dayTime1){%>selected<%}%>>17:00</option>
					<option value="18" <%if(18==dayTime1){%>selected<%}%>>18:00</option>
					<option value="19" <%if(19==dayTime1){%>selected<%}%>>19:00</option>
					<option value="20" <%if(20==dayTime1){%>selected<%}%>>20:00</option>
					<option value="21" <%if(21==dayTime1){%>selected<%}%>>21:00</option>
					<option value="22" <%if(22==dayTime1){%>selected<%}%>>22:00</option>
					<option value="23" <%if(23==dayTime1){%>selected<%}%>>23:00</option>
				</select>
				</span>
				<span id="timeModul2" class="itemspan">
				<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
				<select id="fer" name="fer" style="width: 80px !important;">
					<option value="1" <%if(1==fer){%>selected<%}%>>1</option>
					<option value="2" <%if(2==fer){%>selected<%}%>>2</option>
					<option value="3" <%if(3==fer){%>selected<%}%>>3</option>
					<option value="4" <%if(4==fer){%>selected<%}%>>4</option>
					<option value="5" <%if(5==fer){%>selected<%}%>>5</option>
					<option value="6" <%if(6==fer){%>selected<%}%>>6</option>
					<option value="7" <%if(7==fer){%>selected<%}%>>7</option>
					<option value="8" <%if(8==fer){%>selected<%}%>>8</option>
					<option value="9" <%if(9==fer){%>selected<%}%>>9</option>
					<option value="10" <%if(10==fer){%>selected<%}%>>10</option>
					<option value="11" <%if(11==fer){%>selected<%}%>>11</option>
					<option value="12" <%if(12==fer){%>selected<%}%>>12</option>
					<option value="13" <%if(13==fer){%>selected<%}%>>13</option>
					<option value="14" <%if(14==fer){%>selected<%}%>>14</option>
					<option value="15" <%if(15==fer){%>selected<%}%>>15</option>
					<option value="16" <%if(16==fer){%>selected<%}%>>16</option>
					<option value="17" <%if(17==fer){%>selected<%}%>>17</option>
					<option value="18" <%if(18==fer){%>selected<%}%>>18</option>
					<option value="19" <%if(19==fer){%>selected<%}%>>19</option>
					<option value="20" <%if(20==fer){%>selected<%}%>>20</option>
					<option value="21" <%if(21==fer){%>selected<%}%>>21</option>
					<option value="22" <%if(22==fer){%>selected<%}%>>22</option>
					<option value="23" <%if(23==fer){%>selected<%}%>>23</option>
					<option value="24" <%if(24==fer){%>selected<%}%>>24</option>
					<option value="25" <%if(25==fer){%>selected<%}%>>25</option>
					<option value="26" <%if(26==fer){%>selected<%}%>>26</option>
					<option value="27" <%if(27==fer){%>selected<%}%>>27</option>
					<option value="28" <%if(28==fer){%>selected<%}%>>28</option>
				</select>
				<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
				<select id="dayTime2" name="dayTime2" style="width: 80px !important;">
					<option value="1" <%if(1==dayTime2){%>selected<%}%>>01:00</option>
					<option value="2" <%if(2==dayTime2){%>selected<%}%>>02:00</option>
					<option value="3" <%if(3==dayTime2){%>selected<%}%>>03:00</option>
					<option value="4" <%if(4==dayTime2){%>selected<%}%>>04:00</option>
					<option value="5" <%if(5==dayTime2){%>selected<%}%>>05:00</option>
					<option value="6" <%if(6==dayTime2){%>selected<%}%>>06:00</option>
					<option value="7" <%if(7==dayTime2){%>selected<%}%>>07:00</option>
					<option value="8" <%if(8==dayTime2){%>selected<%}%>>08:00</option>
					<option value="9" <%if(9==dayTime2){%>selected<%}%>>09:00</option>
					<option value="10" <%if(10==dayTime2){%>selected<%}%>>10:00</option>
					<option value="11" <%if(11==dayTime2){%>selected<%}%>>11:00</option>
					<option value="12" <%if(12==dayTime2){%>selected<%}%>>12:00</option>
					<option value="13" <%if(13==dayTime2){%>selected<%}%>>13:00</option>
					<option value="14" <%if(14==dayTime2){%>selected<%}%>>14:00</option>
					<option value="15" <%if(15==dayTime2){%>selected<%}%>>15:00</option>
					<option value="16" <%if(16==dayTime2){%>selected<%}%>>16:00</option>
					<option value="17" <%if(17==dayTime2){%>selected<%}%>>17:00</option>
					<option value="18" <%if(18==dayTime2){%>selected<%}%>>18:00</option>
					<option value="19" <%if(19==dayTime2){%>selected<%}%>>19:00</option>
					<option value="20" <%if(20==dayTime2){%>selected<%}%>>20:00</option>
					<option value="21" <%if(21==dayTime2){%>selected<%}%>>21:00</option>
					<option value="22" <%if(22==dayTime2){%>selected<%}%>>22:00</option>
					<option value="23" <%if(23==dayTime2){%>selected<%}%>>23:00</option>
				</select>
				</span>
			</wea:item>
	    </wea:group>
	</wea:layout>
</form>
<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

function onBtnSearchClick(){}

function doFnaZdJz(){
	//配置计划任务后需重启OA服务才能起效
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127291,user.getLanguage())%>", 
		function(){
			var redirectUrl = "/integration/integrationTab.jsp?urlType=7";
			var width = screen.width ;
			var height = screen.height ;
			if (height == 768 ) height -= 75 ;
			if (height == 600 ) height -= 60 ;
			var szFeatures = "top=0," ;
			szFeatures +="left=0," ;
			szFeatures +="width="+width+"," ;
			szFeatures +="height="+height+"," ;
			szFeatures +="directories=no," ;
			szFeatures +="status=yes," ;
			szFeatures +="menubar=no," ;
			if (height <= 600 ) szFeatures +="scrollbars=yes," ;
			else szFeatures +="scrollbars=no," ;
			szFeatures +="resizable=yes" ; //channelmode
			window.open(redirectUrl,"",szFeatures) ;
		}
	);
}

function ifbudgetmove_onClick(){
	var ifbudgetmove = jQuery("#ifbudgetmove").attr("checked")?true:false;
	var idArray = ["tD2budgetAutoMovePending", "tD2autoMoveMinusAmt", "tD1mBudgetMove", "tD1qBudgetMove", "tD1hBudgetMove", "tD1btnBudgetMove"];
	if(ifbudgetmove){
		for(var i=0;i<idArray.length;i++){
			jQuery("#"+idArray[i]).parent().show();
			jQuery("#"+idArray[i]).parent().next().show();
		}
	}else{
		for(var i=0;i<idArray.length;i++){
			jQuery("#"+idArray[i]).parent().hide();
			jQuery("#"+idArray[i]).parent().next().hide();
		}
	}
}

function timeModul_onchange(){
	//配置计划任务后需重启OA服务才能起效
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127291,user.getLanguage())%>", 
		function(){
			timeModul_onchange2();
		}
	);
}
function timeModul_onchange2(){
	var timeModul = jQuery("#timeModul").val();
	jQuery("#timeModul0").hide();
	jQuery("#timeModul1").hide();
	jQuery("#timeModul2").hide();
	jQuery("#timeModul"+timeModul).show();
}

function doSave(){
	form2.submit();
}
ifbudgetmove_onClick();
timeModul_onchange2();
</script>
</body>
</html>
