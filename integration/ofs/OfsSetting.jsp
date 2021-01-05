<%@ page import="weaver.general.Util" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("ofs:ofssetting", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
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


<STYLE>
	.vis1	{ visibility:visible }
	.vis2	{ visibility:hidden }
	.vis3   { display:inline}
	.vis4   { display:none }
	
	table.setbutton td
	{
		padding-top:10px; 
	}
	table ul#tabs
	{
		width:85%!important;
	}
</STYLE>
</head>
<%


String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
String needfav ="1";
String needhelp ="";
String tiptitle = "";
//String typename = Util.null2String(request.getParameter("typename"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String isDialog = Util.null2String(request.getParameter("isdialog"));

String isuse = "";
String oashortname = "";
String oafullname = "";
String showsysname = "";
String showdone = "";
String remindoa = "";
String remindim = "";
String remindapp = "";
int messagetypeid = 0;
String appshowsysname = "";

String remindemessage = "";//提醒到emessage
String remindebridge = "";//提醒到云桥
String remindebridgetemplate = "";//提醒到云桥消息模板号

String modifier = "";
String modifydate = "";
String modifytime = "";

RecordSet rs=new RecordSet();
String sql="select * from Ofs_setting ";
rs.executeSql(sql);
if(rs.next()){
	isuse = rs.getString("isuse");
	oashortname =rs.getString("oashortname");
	oafullname = rs.getString("oafullname");
	showsysname = rs.getString("showsysname");
	showdone = rs.getString("showdone");
	remindim = rs.getString("remindim");
	remindapp = rs.getString("remindapp");
	messagetypeid = Util.getIntValue(rs.getString("messagetypeid"),0);
	remindoa = rs.getString("remindoa");
	remindemessage = rs.getString("remindemessage");
	remindebridge = rs.getString("remindebridge");
	remindebridgetemplate = rs.getString("remindebridgetemplate");
}
String messagetypeid1 = messagetypeid+""; //qc276166 解决不符合weblogic文件规范相关程序问题
remindebridge+=""; //qc276166 解决不符合weblogic文件规范相关程序问题
String isusedtx = "";
rs.executeSql("select IsusedRtx from RTXSetting");
if(rs.next()){
    isusedtx = Util.null2String(rs.getString("IsusedRtx"));
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
if(HrmUserVarify.checkUserRight("ofs:ofssetting", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showAllLog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(HrmUserVarify.checkUserRight("ofs:ofssetting", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
			<%}%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<script language=javascript>
<%
if(msgid!=-1){
%>
top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(msgid,user.getLanguage())%>!');
<%}%>
</script>
<FORM id=weaver name=frmMain action="OfsSettingOperation.jsp" method=post >

<input class=inputstyle type=hidden name="backto" value="">
<input class=inputstyle type="hidden" name=operation value="add">
 <wea:layout><!-- 基本信息 -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></wea:item><!--是否启用-->
		<wea:item>
             <input class="inputstyle" type="checkbox" tzCheckbox='true' id="isuse" name="isuse" value="1" <%if(isuse.equals("1"))out.println("checked"); %>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("89,22677",user.getLanguage())%></wea:item><!-- 显示系统名称 -->
		<wea:item>
		 	<select id="showsysname" style='width:120px!important;' name="showsysname">
			  <option value="0" <%if(showsysname.equals("0")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(23857,user.getLanguage())%></option>
			  <option value="1" <%if(showsysname.equals("1")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></option><!-- 简称 -->
			  <option value="2" <%if(showsysname.equals("2")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></option><!-- 全称 -->
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("89,24627",user.getLanguage())%></wea:item><!-- 显示已办 -->
		<wea:item>
           <input class="inputstyle" type="checkbox" tzCheckbox='true' id="showdone" name="showdone" value="1"  <%if(showdone.equals("1"))out.println("checked"); %>>
		</wea:item>
		<wea:item>OA<%=SystemEnv.getHtmlLabelNames("468,399",user.getLanguage())%></wea:item><!--OA系统简称-->
		<wea:item>
            <wea:required id="oashortnameimage" required="true" value='<%=oashortname%>'>
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" id="oashortname" name="oashortname" value ='<%=oashortname%>'  onchange='checkinput("oashortname","oashortnameimage")'>
            </wea:required>
		</wea:item>	
		<wea:item>OA<%=SystemEnv.getHtmlLabelNames("468,15767",user.getLanguage())%></wea:item><!--OA系统全称-->
		<wea:item>
            <wea:required id="oafullnameimage" required="true" value='<%=oafullname%>'>
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" id="oashortname" name="oafullname" value ='<%=oafullname%>'  onchange='checkinput("oafullname","oafullnameimage")'>
            </wea:required>
		</wea:item>	
	</wea:group>
	
	<!-- 提醒设置-->
	 <wea:group context='<%=SystemEnv.getHtmlLabelName(21946,user.getLanguage())%>' attributes="{'samePair':'RemindInfo','groupOperDisplay':'none'}">
	 	<wea:item><%=SystemEnv.getHtmlLabelNames("15148,349",user.getLanguage())%>OA</wea:item><!-- 提醒到OA -->
		<wea:item>
           <input class="inputstyle" type="checkbox" tzCheckbox='true' id="remindoa" name="remindoa" value="1" <%if(remindoa.equals("1"))out.println("checked"); %>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("15148,349",user.getLanguage())%>IM</wea:item><!-- 提醒IM -->
		<wea:item>
           <input class="inputstyle" type="checkbox" tzCheckbox='true' id="remindim" name="remindim" value="1" <%if(remindim.equals("1") && isusedtx.equals("1")){out.println("checked");}if(!isusedtx.equals("1")){%>disabled<%} %> >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(127056,user.getLanguage())%></wea:item><!-- 提醒到手机版 -->
		<wea:item>
            <input class="inputstyle" type="checkbox" tzCheckbox='true' id="remindapp" name="remindapp" value="1" onclick="ShowOrHiddenLable(this,'messagetypeidspan');" <%if(remindapp.equals("1"))out.println("checked"); %>>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <span id="messagetypeidspan" <% if(!remindapp.equals("1")){%>style="display:none;"<%} %>>
            	<%=SystemEnv.getHtmlLabelNames("422,24532,84",user.getLanguage()) %>:&nbsp;&nbsp;
            	<wea:required id="messagetypeidimage" required="true" value="<%=messagetypeid1%>">
					<input class=inputstyle type=text style='width:300px!important;' id="messagetypeid" name="messagetypeid" value="<%=messagetypeid %>" onkeypress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('messagetypeid','messagetypeidimage')">
				</wea:required>
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("15148,349",user.getLanguage())%>emessage</wea:item><!-- 提醒emessage -->
		<wea:item>
           <input class="inputstyle" type="checkbox" tzCheckbox='true' id="remindemessage" name="remindemessage" value="1" <%if(remindemessage.equals("1")){out.println("checked");} %> >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("15148,349,129554",user.getLanguage())%></wea:item><!-- 提醒云桥 -->
		<wea:item>
           <input class="inputstyle" type="checkbox" tzCheckbox='true' id="remindebridge" name="remindebridge" value="1" onclick="ShowOrHiddenLable(this,'remindebridgespan');" <%if(remindebridge.equals("1")){out.println("checked");} %> >
           &nbsp;&nbsp;&nbsp;&nbsp;
           <span id="remindebridgespan" <% if(!remindebridge.equals("1")){%>style="display:none;"<%} %>>
            	<%=SystemEnv.getHtmlLabelNames("129554,24532,31186",user.getLanguage()) %>:&nbsp;&nbsp;
            	<wea:required id="remindebridgeimage" required="true" value="<%=remindebridge%>">
					<input class=inputstyle type=text style='width:300px!important;' id="remindebridgetemplate" name="remindebridgetemplate" _noMultiLang='true' value="<%=remindebridgetemplate %>" onBlur="checkinput('remindebridgetemplate','remindebridgeimage')">
				</wea:required>
			</span>
		</wea:item>
	</wea:group>
</wea:layout>
<br>
 <%if("1".equals(isDialog)){ %>
 <input type="hidden" name="isdialog" value="<%=isDialog%>">
 <%} %>
 </form>

<script language="javascript">
function submitData() {
	var checkvalue = "";
	var isuse = frmMain.isuse.checked;
	var isremindapp = frmMain.remindapp.checked;
	var isremindebridge = frmMain.remindebridge.checked;
	var remindebridgetemplate = frmMain.remindebridgetemplate.value;
	if(isuse){
		checkvalue = "oashortname,oafullname";
		if(isremindapp)
			checkvalue+=",messagetypeid";
		if(isremindebridge)
			checkvalue+=",remindebridgetemplate";
	}
	 if(check_form(frmMain,checkvalue)){
	 	frmMain.submit();
	 }
}
function ShowOrHiddenLable(obj,spanid){
	if(obj.checked){
		jQuery("#"+spanid).show();
	}else{
		jQuery("#"+spanid).hide();
		if(jQuery('#isAutoCommit').attr('checked')){
			jQuery('#isAutoCommit').attr('checked',false);
		}
	}
}
function showAllLog(){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("128366,83",user.getLanguage()) %>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=<%=xssUtil.put("where "+(rs.getDBType().equals("db2")?"int(operateitem)":"operateitem")+"=169")%>";
	dialog.show();
}
</script>

<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
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
</HTML>


