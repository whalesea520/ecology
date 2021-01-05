<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.formmode.service.ModelInfoService"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSetTrans" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<html>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(125513,user.getLanguage());//二维码配置
String needfav ="";
String needhelp ="";

%>
<head>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<style>
.Line {
	background-color: #B5D8EA;
    background-repeat: repeat-x;
    height: 1px;
}
.Serial {
  margin-left:50px;
  margin-right:30px;
}
</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
ModelInfoService modelInfoService = new ModelInfoService();
int modeId = Util.getIntValue(request.getParameter("id"),0);
if(modeId<=0){
	modeId = Util.getIntValue(request.getParameter("modeId"),0);
}

int isUse = 0;
String targetType = "";
String targetUrl = "";
int w = 120;
int h = 120;
String baseinfo = "";
String levelspacing = "";
String verticalspacing = "";
String numberrows = "";
String numbercols = "";
rs.executeSql("select * from ModeQRCode where modeid="+modeId);
if (rs.next()) {
	isUse = rs.getInt("isuse");
	targetType = rs.getString("targetType");
	targetUrl = rs.getString("targetUrl");
	w = rs.getInt("width");
	h = rs.getInt("height");
	baseinfo = rs.getString("qrCodeDesc");
	levelspacing = Util.null2String(rs.getString("levelspacing"));
	if(!"".equals(levelspacing)){
		levelspacing = Util.getFloatValue(levelspacing, 0.0f) + "";
	}
	verticalspacing = Util.null2String(rs.getString("verticalspacing"));
	if(!"".equals(verticalspacing)){
		verticalspacing = Util.getFloatValue(verticalspacing, 0.0f) + "";
	}
	numberrows = Util.null2String(rs.getString("numberrows"));
	numbercols = Util.null2String(rs.getString("numbercols"));
} 

if ("".equals(targetType)) {
	targetType = "1";
}
if ("".equals(baseinfo)) { //首次给默认模板
	baseinfo = "<table>\r\n" + 
				"<tr>\r\n" + 
				"<td></td>\r\n" + 
				"</tr>\r\n" + 
				"<tr >\r\n" + 
				"<td>#QRCodeImg#</td>\r\n" + 
				"</tr>\r\n" + 
				"</table>";
}
String subCompanyIdsql = "select subCompanyId from modeinfo where id="+modeId;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);

%>

<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="frmCoder" name="frmCoder" method=post action="qrCodeOperation.jsp" >
<INPUT TYPE="hidden" NAME="method">
<INPUT TYPE="hidden" NAME="postValue">
<INPUT TYPE="hidden" NAME="modeId" value="<%=modeId%>">
<wea:layout>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage()) %>" >
		<wea:item><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%><!-- 是否启用 --></wea:item>
		<wea:item><input class="inputStyle" type="checkbox" name="txtUserUse" tzCheckbox="true" value="1" <%if (isUse==1) out.println("checked");%>></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125569,user.getLanguage()) %></wea:item>
		<wea:item>
			<input type=radio name=targetType <%if("1".equals(targetType)){ %>checked<%} %> value="1"/> <%=SystemEnv.getHtmlLabelName(89,user.getLanguage()) %><!-- 显示 -->
        	<input type=radio name=targetType <%if("2".equals(targetType)){ %>checked<%} %> value="2"/> <%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %><!-- 编辑 -->
        	<input type=radio name=targetType <%if("3".equals(targetType)){ %>checked<%} %> value="3"/> <%=SystemEnv.getHtmlLabelName(811,user.getLanguage()) %><!-- 其它 -->
		</wea:item>
		<wea:item attributes="{id:'targetUrlTR'}"><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage()) %><!-- 链接地址 --></wea:item>
		<wea:item>
			<textarea id="targetUrl" name="targetUrl" class="inputstyle" rows="3" style="width:80%;" onblur="checkinput2('targetUrl','targetUrlspan',1)"><%=targetUrl %></textarea>
	        <SPAN id="targetUrlspan">
				<%if ("".equals(targetUrl)) { %>
	               <img align="absMiddle" src="/images/BacoError_wev8.gif"/>
	            <% } %>
			</SPAN>
			<span title='<%=SystemEnv.getHtmlLabelName(82350,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82351,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82352,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82462,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82463,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82464,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82465,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(125568,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(125598,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(382977,user.getLanguage())%>&#10;' id="remind">
				<img align="absMiddle" src="/images/remind_wev8.png">
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(26901,user.getLanguage()) %><!-- 宽 --></wea:item>
		<wea:item>
			<input type="text" id="w" name="w" value="<%=w %>" style="width:100px" onKeyPress="ItemCount_KeyPress()"  onKeyUp='NotWriteZero(this)'/>
	        <font color="red"><%=SystemEnv.getHtmlLabelName(125570,user.getLanguage()) %><!-- (宽必须大于119) --></font>
        </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(27734,user.getLanguage()) %><!-- 高 --></wea:item>
		<wea:item>
			<input type="text" id="h" name="h" value="<%=h %>" style="width:100px" onKeyPress="ItemCount_KeyPress()"  onKeyUp='NotWriteZero(this)'/>
        	<font color="red"><%=SystemEnv.getHtmlLabelName(125571,user.getLanguage()) %><!-- (高必须大于119) --></font>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %><!-- 基本信息 --></wea:item>
		<wea:item>
			<textarea name="baseinfo" class="inputstyle" rows="10" style="width:80%"><%=baseinfo %></textarea>
			<span title='<%=SystemEnv.getHtmlLabelName(82350,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82351,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82352,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82462,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82463,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82464,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82465,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(125568,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(125598,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(382977,user.getLanguage())%>&#10;' id="remind">
				<img align="absMiddle" src="/images/remind_wev8.png">
			</span>
	        <br>
	        <font color="red"><%=SystemEnv.getHtmlLabelName(125572,user.getLanguage())%><!-- 可根据实际情况设计二维码HTML显示样式 --></font>
		</wea:item>
		<wea:item></wea:item>
		<wea:item></wea:item>
	</wea:group>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(26382, user.getLanguage()) %>">
		<wea:item><%=SystemEnv.getHtmlLabelNames("15715,15932", user.getLanguage()) %></wea:item>
		<wea:item><input type="text" id="levelspacing" name="levelspacing" value="<%=levelspacing%>" style="width:100px" onKeyPress="ItemDecimal_KeyPress('levelspacing',15,1)" />cm</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("127995,15932", user.getLanguage()) %></wea:item>
		<wea:item><input type="text" id="verticalspacing" name="verticalspacing" value="<%=verticalspacing%>" style="width:100px" onKeyPress="ItemDecimal_KeyPress('verticalspacing',15,1)" />cm</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("23201", user.getLanguage()) %></wea:item>
		<wea:item><input type="text" id="rows" name="numberrows" value="<%=numberrows%>" style="width:100px" onKeyPress="ItemCount_KeyPress()"  onKeyUp='NotWriteZero(this)'/></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("23202", user.getLanguage()) %></wea:item>
		<wea:item><input type="text" id="cols" name="numbercols" value="<%=numbercols%>" style="width:100px" onKeyPress="ItemCount_KeyPress()"  onKeyUp='NotWriteZero(this)'/></wea:item>
		<wea:item attributes="{colspan:2}">
			<b><%=SystemEnv.getHtmlLabelName(27581, user.getLanguage())%></b><br> <!-- 使用注意事项: -->
			<%=SystemEnv.getHtmlLabelName(125573, user.getLanguage())%><br>
			<%=SystemEnv.getHtmlLabelName(125574, user.getLanguage())%><br>
			<%=SystemEnv.getHtmlLabelName(125575, user.getLanguage())%><br>
			<%=SystemEnv.getHtmlLabelName(125576, user.getLanguage())%><br>
			<%=SystemEnv.getHtmlLabelName(125577, user.getLanguage())%><font color="red"><%=SystemEnv.getHtmlLabelName(125578, user.getLanguage())%></font><br>
			<font color="red"><%=SystemEnv.getHtmlLabelName(125579, user.getLanguage())%></font>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</body>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">

$(document).ready(function(){
	$(".loading", window.parent.document).hide(); //隐藏加载图片
	targetTypeClickFun();
	$("input[name='targetType']").click(targetTypeClickFun);
});

function targetTypeClickFun(){
	var targetType = jQuery("input[name='targetType']:checked").val();
	var targetUrlTR = jQuery("#targetUrlTR").closest("tr");
	var targetUrlTRLine = targetUrlTR.next();
	if (targetType==1||targetType==2) {
		targetUrlTR.hide();
		targetUrlTRLine.hide();
	} else {
		targetUrlTR.show();
		targetUrlTRLine.show();
	}
}

function onSave() {
   var targetUrlval = document.getElementById("targetUrl").value;
   //if (getByteLen(targetUrlval) > 215) {
        //alert("<%=SystemEnv.getHtmlLabelName(125629,user.getLanguage())%>");//链接地址长度不能超过216个字节长度
   		//return;
   //}
   var w = document.getElementById("w").value;
   var h = document.getElementById("h").value;
   if (w < 120 || h < 120) {
   		alert("<%=SystemEnv.getHtmlLabelName(125580,user.getLanguage())%>");//宽或者高不符合规则
   		return;
   } 
   if($("input[name='targetType']:checked").val() != "3" || ($("input[name='targetType']:checked").val() == "3" && checkFieldValue("targetUrl"))) {
      enableAllmenu();
   	  document.frmCoder.submit();
   }
}

// 判断input框中是否输入的是数字,不包括小数点
function ItemCount_KeyPress()
{
	var evt = getEvent();
	var keyCode = evt.which ? evt.which : evt.keyCode;
 if(!(((keyCode>=48) && (keyCode<=57))))
  {
     if (evt.keyCode) {
     	evt.keyCode = 0;evt.returnValue=false;     
     } else {
     	evt.which = 0;evt.preventDefault();
     } 
  }
}

//不能输入0
function NotWriteZero(obj){
	if (parseInt(obj.value) == 0) obj.value = "";
}

function checkFieldValue(ids){
	var idsArr = ids.split(",");
	for(var i=0;i<idsArr.length;i++){
		var obj = document.getElementById(idsArr[i]);
		if(obj&&obj.value==""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
			return false;
		}
	}
	return true;
}

function getByteLen(val) { 
    var len = 0; 
    for (var i = 0; i < val.length; i++) { 
        if (val[i].match(/[^x00-xff]/ig) != null) //全角 
            len += 2; 
        else
             len += 1; 
    }; 
    return len; 
}

</script>
</html>
