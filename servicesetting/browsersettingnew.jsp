
<%@page import="weaver.formmode.browser.FormModeBrowserUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="BrowserXML" class="weaver.servicefiles.BrowserXML" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:datashowsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String isDialog = Util.null2String(request.getParameter("isdialog"));

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23661,user.getLanguage());
String needfav ="1";
String needhelp ="";
String browserid=Util.null2String(request.getParameter("browserid"));
String dataid=Util.null2String(request.getParameter("id"));
String backto=Util.null2String(request.getParameter("backto"));
ArrayList pointArrayList = BrowserXML.getPointArrayList();
Hashtable dataHST = BrowserXML.getDataHST();
String thisServiceId = "";
String thisSearch = "";
String thisSearchById = "";
String thisSearchByName = "";
String thisNameHeader = "";
String thisDescriptionHeader = "";
String outPageURL = "";
String href = "";
String from = "";
String showtree = "";
String nodename = "";
String parentid = "";
String ismutil = "";
String name = "";
String customid = "";//表单建模中对应浏览框id
boolean isnew = true;
if(!"".equals(browserid))
{
	for(int i=0;i<pointArrayList.size();i++){
	    String pointid = (String)pointArrayList.get(i);
	    if(!pointid.equals("")&&browserid.equals(pointid))
	    {
	        RecordSet.executeSql("select * from datashowset where id='"+dataid+"' order by id ");
            if(RecordSet.next()){
                thisServiceId =Util.null2String(RecordSet.getString("datasourceid"));
                thisSearch =Util.null2String(RecordSet.getString("sqltext"));
                thisSearchById =Util.null2s(RecordSet.getString("searchById"),Util.null2String(RecordSet.getString("sqltext1")));
                thisSearchByName = Util.null2s(RecordSet.getString("searchByName"),Util.null2String(RecordSet.getString("sqltext2")));
                thisNameHeader =Util.null2String( RecordSet.getString("nameHeader"));
                thisDescriptionHeader =Util.null2String( RecordSet.getString("descriptionHeader"));
                outPageURL = Util.null2String(RecordSet.getString("showpageurl"));
                href = Util.null2String(RecordSet.getString("detailpageurl"));
                from = Util.null2String(RecordSet.getString("browserfrom"));
                showtree = "2".equals(Util.null2String(RecordSet.getString("showtype"))) ? "1" : "0";
                nodename = Util.null2String(RecordSet.getString("showfield"));
                parentid =Util.null2String(RecordSet.getString("parentfield"));
                ismutil ="2".equals(Util.null2String(RecordSet.getString("selecttype"))) ? "1" :"0";
                name =Util.null2String(RecordSet.getString("name"));
                customid = Util.null2String(RecordSet.getString("customid"));
				isnew = false;
		    }
	    }
	}
}
if(name.equals("")&&!"".equals(browserid))
{
	name = browserid;
}
String pointids = ",";
for(int i=0;i<pointArrayList.size();i++){
    String pointid = (String)pointArrayList.get(i);
    if(pointid.equals(browserid)&&!"".equals(browserid))
		continue;
    pointids += pointid+",";
}
thisServiceId = thisServiceId.replaceAll("datasource.","");
ArrayList dsPointArrayList = DataSourceXML.getPointArrayList();
String dsOptions = "";
for(int i=0;i<dsPointArrayList.size();i++){
    String pointid = (String)dsPointArrayList.get(i);
    //out.println("thisServiceId : "+thisServiceId+" pointid : "+pointid);
    String selected = "";
    if(thisServiceId.equals(pointid)){
    	selected = "selected";
    }
    dsOptions += "<option value='"+pointid+"' "+selected+">"+pointid+"</option>";
}
boolean isused = false;
if(!"".equals(browserid))
{
	isused = BrowserXML.isUsed(browserid,""+1,""+1);
	
	// 表单建模浏览框是否被引用检查，不是表单建模浏览框或者没有被引用返回isused
	isused = FormModeBrowserUtil.isReferenced4ModeIgnoreOthers(browserid, isused);
}
%>

<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isused)
{
	RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/integration/WsShowEditSetList.jsp?typename="+backto+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
			<%
			if(!isused)
			{
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="deleteData()"/>
			<%
			}
			%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="XMLFileOperation.jsp">
	<input type="hidden" id="operation" name="operation" value="browser">
	<input type="hidden" id="method" name="method" value="add">
	<input type="hidden" id="from" name="from" value="<%=from %>">
	<input type="hidden" id="typename" name="typename" value="<%=backto %>">
	<input type="hidden" id="customid" name="customid" value="<%=customid %>">
	<%if("1".equals(isDialog)){ %>
	<input type="hidden" name="isdialog" value="<%=isDialog%>">
	<%} %>	
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		  <wea:item><%=SystemEnv.getHtmlLabelName(23675,user.getLanguage())%></wea:item>
		  <wea:item>
				<input class="inputstyle" type=text  style='width:200px;<%=(!"".equals(browserid)?"display:none;":"" )%>' id="browserid" name="browserid" _noMultiLang='true' value="<%=browserid %>" onChange="checkinput('browserid','browseridspan')" onblur="isExist(this.value)">
				<span id="browseridspan"><%if("".equals(browserid)){ %><img src="/images/BacoError_wev8.gif" align=absmiddle><%}else{out.print(browserid) ;} %></span>
				<input class="inputstyle" type=hidden id="oldbrowserid" name="oldbrowserid" value="<%=browserid %>">
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(33439,user.getLanguage())%></wea:item>
		  <wea:item>
				<input class="inputstyle" type=text  style='width:200px;' id="name" name="name" value="<%=name %>" onChange="checkinput('name','namespan')" onblur="checkName(this.value)">
				<span id="namespan"><%if("".equals(name)){ %><img src="/images/BacoError_wev8.gif" align=absmiddle><%} %></span>
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
		  <wea:item>
				<select id="ds" name="ds">
				    <option></option>
					<%=dsOptions%>
				</select>
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(23676,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input class="inputstyle" type=text id="search" name="search" value="<%=thisSearch %>" size="80">
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(23677,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input class="inputstyle" type=text id="searchById" name="searchById" value="<%=thisSearchById %>" size="80">
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(23678,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input class="inputstyle" type=text id="searchByName" name="searchByName" value="<%=thisSearchByName %>" size="80">
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(23679,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input class="inputstyle" type=text  style="width:100px;" id="nameHeader" name="nameHeader" value="<%=thisNameHeader %>">
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(23680,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input class="inputstyle" type=text  style="width:100px;" id="descriptionHeader" name="descriptionHeader" value="<%=thisDescriptionHeader %>">
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(28144,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input class="inputstyle" type=text id="outPageURL" name="outPageURL"  _noMultiLang='true' value="<%=outPageURL %>" size="80">
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input class="inputstyle" type=text id="href" name="href" _noMultiLang='true' value="<%=href %>" size="80">
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(32350,user.getLanguage())%></wea:item><!-- 树状显示 -->
		  <wea:item>
		  	<input type="checkbox" id="showtree" name="showtree" value="1" <%if("1".equals(showtree)){ %>checked<%} %> onchange="if(this.checked){this.value=0;}else{this.value=1;}">
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(32351,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input class="inputstyle" type=text id="nodename" style="width:100px;" size="50" name="nodename" value="<%=nodename %>" maxLength="50">
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(32352,user.getLanguage())%></wea:item><!-- 上级字段名 -->
		  <wea:item>
		  	<input class="inputstyle" type=text id="parentid" style="width:100px;" name="parentid" value="<%=parentid %>" size="50" maxLength="50">
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(28627,user.getLanguage())%></wea:item><!-- 多选 -->
		  <wea:item>
		  	<input type="checkbox" id="ismutil" name="ismutil" value="1" <%if("1".equals(ismutil)){ %>checked<%} %> onchange="if(this.checked){this.value=0;}else{this.value=1;}">
		  </wea:item>
		</wea:group>
	</wea:layout>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
		  <wea:item attributes="{'colspan':'2'}">
			1.<%=SystemEnv.getHtmlLabelName(23953,user.getLanguage())%>；
			<BR>
			2.<%=SystemEnv.getHtmlLabelName(23954,user.getLanguage())%>；
			<BR>
			3.<%=SystemEnv.getHtmlLabelName(23955,user.getLanguage())%>；
			<BR>
			4.<%=SystemEnv.getHtmlLabelName(23956,user.getLanguage())%>；
			<BR>
			5.<%=SystemEnv.getHtmlLabelName(23957,user.getLanguage())%>；
			<BR>
			6.<%=SystemEnv.getHtmlLabelName(23958,user.getLanguage())%>；
			<BR>
			7.<%=SystemEnv.getHtmlLabelName(23959,user.getLanguage())%>。
		  </wea:item>
		</wea:group>
	</wea:layout>
  </FORM>
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick="onClose();"></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
</BODY>

<script language="javascript">
function onClose()
{
	parentWin.closeDialog();
}
function onSubmit(){
	if(isExist(document.getElementById("browserid").value))
	{
    if(check_form(frmMain,"browserid,name")) frmMain.submit();
	}
}
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	});
});
function isExist(newvalue){
    var pointids = "<%=pointids%>";
    if(pointids.indexOf(","+newvalue+",")>-1){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23992,user.getLanguage())%>");
        document.getElementById("browserid").value = "";
		return false;
    }
	return isSpecial(newvalue);
}
function doBack()
{
	document.location.href="/integration/WsShowEditSetList.jsp?typename=<%=backto%>";
}
function deleteData(){
    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		document.getElementById("method").value = "deletesingle";
        document.frmMain.submit();
	}, function () {}, 320, 90);
}
//QC330951 [80][90]数据展现集成-补充修改QC292458中漏改的E7样式页面 -start
//name代表页面上的名称
function checkName(name) {
    if(isSpecialChar(name)){
        //标识包含特殊字符，请重新输入！
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131334,user.getLanguage())%>");
        document.getElementById("name").value = "";
        document.getElementById("namespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";

        return false;
    }
    return true;
}
//QC330951 [80][90]数据展现集成-补充修改QC292458中漏改的E7样式页面 -end
//是否包含特殊字符
function isSpecialChar(str){
	var reg = /[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/;
	return reg.test(str);
}
//是否含有中文（也包含日文和韩文）
function isChineseChar(str){   
   var reg = /[\u4E00-\u9FA5\uF900-\uFA2D]/;
   return reg.test(str);
}
//是否含有全角符号的函数
function isFullwidthChar(str){
   var reg = /[\uFF00-\uFFEF]/;
   return reg.test(str);
} 
//是否特殊字符
function isSpecial(newvalue){
	if(<%=isnew%>){
	if(isSpecialChar(newvalue)){
		//标识包含特殊字符，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128458,user.getLanguage())%>");
        document.getElementById("browserid").value = "";
        document.getElementById("browseridspan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        
        return false;
	}
	if(isChineseChar(newvalue)){
		//标识包含中文，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128459,user.getLanguage())%>");
        document.getElementById("browserid").value = "";
        document.getElementById("browseridspan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        
        return false;
	}
	if(isFullwidthChar(newvalue)){
		//标识包含全角符号，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128460,user.getLanguage())%>");
        document.getElementById("browserid").value = "";
        document.getElementById("browseridspan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        
        return false;
	}
	}
	return true;
}
</script>

</HTML>
