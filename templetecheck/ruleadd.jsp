<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.templetecheck.CheckUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>


<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<%!
//替换nbsp;否则会有乱码
public String changenbsp(String content){
	if(content!=null) {
		content  = content.replace("&nbsp;"," ");
	}
	return content;
}
%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String testxpath = basePath+"templetecheck/CheckXpath.jsp";
//判断只有管理员才有权限
int userid = user.getUID();
if(userid!=1) {
	response.sendRedirect("/notice/noright.jsp");
  return;
}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String ruletype="";
String name = "";
String description = "";
String flageid = "";
String content = "";
String replacecontent = "";
String version  = "";
String method = "add";
String configcontent = "";
String tabtype =  Util.null2String(request.getParameter("tabtype"));
String ishtml =  Util.null2String(request.getParameter("ishtml"));
String xpath = "";
String requisite = "";

flageid = Util.null2String(request.getParameter("flageid"));
boolean selectCanUse = true;
if(!"".equals(flageid)) {
	selectCanUse = false;
	method = "edit";
	CheckUtil checkutil = new CheckUtil();
	CheckUtil.Rule rule  = checkutil.getRuleObjById(tabtype,flageid);
	name = changenbsp(rule.getName());
	description = changenbsp(rule.getDescription());
	content = changenbsp(rule.getContent());
	ruletype = changenbsp(rule.getRuletype());
	replacecontent = changenbsp(rule.getReplacecontent());
	version = rule.getVersion();
	xpath = changenbsp(rule.getXpath());
	requisite = rule.getRequisite();
}

if(replacecontent!=null) {
	replacecontent = replacecontent.replaceAll("\\\\n","\\\n");//做一次转换，否则显示的不换行的内容
}
String note = "根据配置输入对应的版本号，如果是KB补丁包请输入补丁包版本，如：KB81001508；如果是非KB补丁包，请输入版本号，如：8.100.0531。";
String note2 = "请输入XPath;XPath的指向的元素，必须是配置项的根节点\n如：/web-app/servlet/servlet-name[text()=&apos;InitServer&apos;]/parent::*；";
note2 = note2 +"\n查询servlet-name=InitServerd的servlet元素。";
note2 = note2 +"\n如果配置项包含多个同层级的元素，指定其中一个元素即可。";
note2 = note2 +"\n如：配置项包含servlet和servlet-mapping，xpath指定到servlet元素即可。";

%>
<script type="text/javascript">

var parentWin = null;
var dialog = null;
var method = null;
try{
	parentWin = parent.getParentWindow(window);
	dialog = parent.getDialog(window);
}catch(e){}
$(document).ready(function(){
	
	method = "<%=method%>";

	if("edit" == method) {
		$("#flageid").attr("disabled","disabled");
	}
	
});
function submitData() {
	if(!check_form(frmMain,"flageid,name,description,content")) {
		return;
	}
	<%
	if("2".equals(ishtml)||"1".equals(ishtml)) {//0--流程模板 1--KB包xml配置文件 2--web.xml 3.其他 4.检测移动引擎HTML模板  5.检测表单建模HTML模板 6.流程自定义页面查询
	%>
	if(!check_form(frmMain,"version,xpath,requisite")) {
		return;
	}
	<%
	}
	%>
	//保存之前先对kb版本做校验
	
	$.ajax({
		url:'ruleoperation.jsp',
		dataType:'json',
		type:'post',
		data:{
			'method':method,
			'name':$("#name").val(),
			'flageid':$("#flageid").val(),
			'description':$("#description").val(),
			'content':$("#content").val(),
			'tabtype':$("#tabtype").val(),
			'version':$("#version").val(),
			'replacecontent':$("#replacecontent").val(),
			'ishtml':"<%=ishtml%>",
			'xpath':$("#xpath").val(),
			'requisite':$("#requisite").val(),
			'ruletype':$("#ruletype").val()
		},
		success:function(data){
			if(data) {
				//var res = eval("("+data+")").status;
				var res = data.status;
				if(res == "ok") {
					parentWin._table.reLoad();//先刷新列表 否则IE先不会刷新
					if(dialog){
						dialog.closeByHand();
					}else{
						parentWin.closeDialog();
					} 
				//parentWin._table.reLoad();//先刷新列表 否则IE先不会刷新
				} else if(res == "updateerror"){
					top.Dialog.alert("更新失败!");
					return;
				} else if(res == "adderror"){
					top.Dialog.alert("标识已存在!");
					return;
				} else if(res == "xmlerror"){
					top.Dialog.alert("配置内容非XML格式");
					return;
					
				} else if(res == "versionerror") {
					top.Dialog.alert("版本号错误");
					return;
				}
			}
		}
	});
}
//当选择接口类型的规则时，隐藏表单中“替换内容”，并修改规则前面的标题内容
function changeRuletype(ruletype){
	if(ruletype=='1'){
		hideEle("wea_replacecontent");
		$("#wea_content_title").text("规则(请输入接口名,如：weaver.templetecheck.ruleinterface.ExampleRule)");
		$("#class-rule-tip").html("&nbsp;&nbsp;&nbsp;&nbsp;<font><b>说明：</b></font> <br/>"+
								  "&nbsp;&nbsp;&nbsp;&nbsp;1.使用自定义接口规则，需要输入接口名，如：weaver.templetecheck.ruleinterface.ExampleRule  <br/>"+
								  "&nbsp;&nbsp;&nbsp;&nbsp;2.该自定义接口类必须实现weaver.templetecheck.ruleinterface.CheckRuleInterface接口  <br/>"+
								  "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;中的checkRule(String filepath)方法和replaceRule(String filepath)方法 <br/>"+
								  "&nbsp;&nbsp;&nbsp;&nbsp;3.replaceRule(String filepath)方法只需对传入路径的对应文件做修改替换保存即可"
						
		);
	}else if(ruletype=='0'){
		showEle("wea_replacecontent");
		$("#wea_content_title").text("规则(请输入正则表达式)");
		$("#class-rule-tip").text("");
	}
} 
</script>
</HEAD>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{保存,javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="check"/>
   <jsp:param name="navName" value="规则"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="保存" class="e8_btn_top" onclick="submitData()"/>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'>高级搜索</span>&nbsp;&nbsp;
			<span title="菜单" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'></div>
<FORM id=weaver name=frmMain action="ruleoperation.jsp" method=post>
<input type="hidden" name="method" id="method" value="<%=method%>">
<input type="hidden" name="tabtype" id="tabtype" value="<%=tabtype%>">
<wea:layout>
	<wea:group context="基本信息">
		<wea:item>规则类型</wea:item>
		<wea:item>
			<select name="ruletype" id="ruletype" onChange="changeRuletype(this.value)" size="1" <% if(!selectCanUse) {%>disabled="disabled"<%} %> >
				<option value="0" <%if("0".equals(ruletype)){ %>selected<%} %>>正则</option>
				<option value="1" <%if("1".equals(ruletype)){ %>selected<%} %>>接口</option>
			</select>
		</wea:item>	
		<wea:item>标识</wea:item>
		<wea:item>
		<wea:required id="flageidimage" required="true" value="<%=flageid %>">
			<input class=inputstyle type="text" style="width:90%" name="flageid" id="flageid" value="<%=flageid %>" onchange='checkinput("flageid","flageidimage")'></input>
		</wea:required>
		</wea:item>
		<wea:item>名称</wea:item>
		<wea:item><wea:required id="nameimage" required="true" value="<%=name %>">
			<input class=inputstyle type="text" style="width:90%" name="name" id="name" value="<%=name %>" onchange='checkinput("name","nameimage")'></input>
		</wea:required></wea:item>
		<wea:item>描述</wea:item>
		<wea:item><wea:required id="descriptionimage" required="true" value="<%=description %>">
			<input class=inputstyle type="text" style="width:90%" name="description" id="description" value="<%=description %>" onchange='checkinput("description","descriptionimage")'></input>
		</wea:required></wea:item>

		<%
			if(!"2".equals(ishtml)&&!"1".equals(ishtml)) {//0--流程模板 1--KB包xml配置文件 2--web.xml 3.其他 4.检测移动引擎HTML模板  5.检测表单建模HTML模板 6.流程自定义页面查询
		%>
		 <%if("1".equals(ruletype)){ %>
			<wea:item><span id="wea_content_title">规则(请输入接口名,如：weaver.templetecheck.ruleinterface)</span></wea:item>
		<%} else{%>
			<wea:item><span id="wea_content_title">规则(请输入正则表达式)</span></wea:item>
		<%}%>
		<wea:item >
			<wea:required id="contentimage" required="true" value="<%=content %>">
			<textarea class=inputstyle style="width:90%" rows='6' id="content" onchange='checkinput("content","contentimage")'><%=content %></textarea>
			</wea:required>
		</wea:item>
		<%if(!"1".equals(ruletype)){ %>
		<wea:item attributes="{'samePair':'wea_replacecontent'}">替换为（内容为空将不进行替换，如果需要删除符合规则的内容可输入空格）</wea:item>
		<wea:item attributes="{'samePair':'wea_replacecontent'}"><textarea class=inputstyle style="width:90%" rows='6' id="replacecontent"><%=replacecontent %></textarea>
		<input class=inputstyle style="width:90%" name="version" id="version" type="hidden"></input></wea:item>
		<%}%>
		<%
			} else {
		%>
				<wea:item>版本</wea:item>
				<wea:item>
				<wea:required id="versionimage" required="true" value="<%=version %>">
					<input class=inputstyle style="width:90%" name="version" id="version" value="<%=version %>" onchange='checkinput("version","versionimage")'></input>
					<SPAN style='CURSOR: hand' id=remind title=''><IMG id=ext-gen124  title='<%=note%>' align=absMiddle src='/images/remind_wev8.png'></SPAN>
				</wea:required>
				</wea:item>
				<wea:item>XPath路径</wea:item>
				<wea:item>
				<wea:required id="xpathimage" required="true" value="<%=xpath %>">
					<textarea class=inputstyle style="width:90%" rows='3' name="xpath" id="xpath" value="<%=xpath %>" onchange='checkinput("xpath","xpathimage")'><%=xpath %></textarea>
				</wea:required>
				<SPAN style='CURSOR: hand' id=remind title=''><IMG id=ext-gen124  title='<%=note2%>' align=absMiddle src='/images/remind_wev8.png'></SPAN>
					<br><span style="color:red"><span><a target="_blank" href="<%=testxpath %>">点击测试XPATH</a>
				</wea:item>
				<wea:item>必须配置</wea:item>
				<wea:item>
				<select name=requisite id="requisite">
					<option value="1" <%if("1".equals(requisite)){ %>selected<%} %>>是</option>
					<option value="2" <%if(!"1".equals(requisite)){ %>selected<%} %>>否</option>
				</select>
				</wea:item>
				<wea:item>配置内容</wea:item>
				<wea:item><textarea class=inputstyle style="width:90%" rows='6' id="replacecontent"><%=replacecontent %></textarea></wea:item>
			
			
		<%} %>
	</wea:group>
</wea:layout>
<span id="class-rule-tip"></span>

</FORM>
</div>
</BODY>
</HTML>