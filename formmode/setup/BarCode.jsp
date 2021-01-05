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
String titlename = SystemEnv.getHtmlLabelName(125513,user.getLanguage());//条形码配置
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

int isUsed = 0;
String resolution = "";
String size = "";
String codenum = "";
String info = "";
String levelspacing = "";
String verticalspacing = "";
String numberrows = "";
String numbercols = "";
rs.executeSql("select * from mode_barcode where modeid="+modeId);
if (rs.next()) {
	isUsed = rs.getInt("isused");
	resolution = rs.getString("resolution");
	size = rs.getString("codesize");
	codenum = rs.getString("codenum");
	info = rs.getString("info");
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
if ("".equals(info)) { //首次给默认模板
	info = "<table>\r\n" + 
				"<tr>\r\n" + 
				"<td></td>\r\n" + 
				"</tr>\r\n" + 
				"<tr >\r\n" + 
				"<td>#BARCodeImg#</td>\r\n" + 
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
<form id="frmCoder" name="frmCoder" method=post action="BarCodeOperation.jsp" >
<INPUT TYPE="hidden" NAME="method">
<INPUT TYPE="hidden" NAME="postValue">
<INPUT TYPE="hidden" NAME="modeId" value="<%=modeId%>">
<wea:layout>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage()) %>" >
		<wea:item><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%><!-- 是否启用 --></wea:item>
		<wea:item><input class="inputStyle" type="checkbox" name="isused" tzCheckbox="true" value="1" <%if (isUsed==1) out.println("checked");%>></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(126830,user.getLanguage())%>     <!-- 大小/尺寸 --></wea:item>
		<wea:item>
			<input type="text" name="size" value="<%=size %>" style="width:100px" onblur="NotWriteZero(this);" onkeypress="ItemCount_KeyPress();"><!-- 大小/尺寸  -->
	        <font color="red">
				<%=SystemEnv.getHtmlLabelName(126827,user.getLanguage())%><!-- 设置大小/尺寸的范围为0-1 -->
		    </font>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1362,user.getLanguage())%><!-- 条码号 --></wea:item>
		<wea:item>
			<input type="text" name="codenum" style="width:60%;" value="<%=codenum %>" >
	        <SPAN id="targetUrlspan"></SPAN>
			<span title='<%=SystemEnv.getHtmlLabelName(82350,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82351,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82352,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82462,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82463,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82464,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82465,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(125568,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(125598,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(382977,user.getLanguage())%>&#10;' id="remind">
				<img align="absMiddle" src="/images/remind_wev8.png">
			</span><BR>
			<font color="red">
			   <%=SystemEnv.getHtmlLabelName(126828,user.getLanguage())%>  <!-- 动态参数对应的数据库值不能有中文 -->
			</font>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %><!-- 基本信息 --></wea:item>
		<wea:item>
			<textarea name="info" class="inputstyle" rows="10" style="width:80%"><%=info %></textarea>
			<span title='<%=SystemEnv.getHtmlLabelName(82350,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82351,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82352,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82462,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82463,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82464,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82465,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(125568,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(125598,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(382977,user.getLanguage())%>&#10;' id="remind">
				<img align="absMiddle" src="/images/remind_wev8.png">
			</span>
	        <br>
	        <font color="red"><%=SystemEnv.getHtmlLabelName(126689,user.getLanguage())%><!-- 可根据实际情况设计条形码HTML显示样式 --></font>
		</wea:item>
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
			1<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(128115, user.getLanguage()) %><br>
			2<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(128121, user.getLanguage()) %><br>
			3<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(128124, user.getLanguage()) %><br>
			4<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage()) %><font color="red"><%=SystemEnv.getHtmlLabelName(128128, user.getLanguage()) %></font>
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
});

function onSave() {
    enableAllmenu();
   	document.frmCoder.submit();
}

// 判断input框中是否输入的是数字,不包括小数点
function ItemCount_KeyPress()
{
	var evt = getEvent();
	var keyCode = evt.which ? evt.which : evt.keyCode;
 if( !(((keyCode>=48) && (keyCode<=57)) || keyCode == 46 ))
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
	if (parseFloat(obj.value) == 0) obj.value = "";
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
