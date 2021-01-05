
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
</head>
<%
String isDialog = Util.null2String(request.getParameter("isdialog"));
int id = Util.getIntValue(Util.null2String((String)request.getParameter("id")),0);
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23663,user.getLanguage());
String needfav ="1";
String needhelp ="";

String tempid = "";
String temppagename = "";
String importlevel = "";
String favouritetype = "";
String action = "add";
if(id>0)
{
	action = "edit";
}
String sql = " select * from sysfavourite where id="+id;
//System.out.println("select sql : "+sql);
rs.executeSql(sql);
if (rs.next())
{
	tempid = rs.getString("id");
	temppagename = rs.getString("pagename");
	importlevel = rs.getString("importlevel");
	favouritetype = rs.getString("favouritetype");
	
}
%>

<BODY>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
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
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/favourite/SysFavouriteOperation.jsp">
	<input type="hidden" id="sysfavouriteid" name="sysfavouriteid" value="<%=tempid %>">
	<input type="hidden" name="isdialog" value="<%=isDialog%>">
	<input type="hidden" name="action1" value="<%=action%>">
	
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		  <wea:item><%=SystemEnv.getHtmlLabelName(22426 ,user.getLanguage()) %></wea:item><!-- 收藏标题 -->
		  <wea:item>
		  	<wea:required id="titlespan" required="true" value='<%=pagename %>'>
		  		<input class="inputstyle" type=text style='width:280px!important;' id="title" maxLength=20 name="title" value='<%=temppagename %>' onChange="checkinput('title','titlespan')">
		  	</wea:required>
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(18178 ,user.getLanguage()) %></wea:item><!-- 重要程度 -->
		  <wea:item>
		  	<wea:required id="importlevelspan" required="true" value='<%=importlevel %>'>
			  	<select name='importlevel' style='width:120px!important;'>
			  		<option></option>
			  		<option value='1' <%if("1".equals(importlevel)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(154 ,user.getLanguage()) %></option><!-- 一般 -->
			  		<option value='2' <%if("2".equals(importlevel)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(22241 ,user.getLanguage()) %></option><!-- 中等 -->
			  		<option value='3' <%if("3".equals(importlevel)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(15533 ,user.getLanguage()) %></option><!-- 重要 -->
			  	</select>
		  	</wea:required>
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(63 ,user.getLanguage()) %></wea:item><!-- 类型 -->
		  <wea:item>
		  	<wea:required id="favouritetypespan" required="true" value='<%=favouritetype %>'>
			  	<select name='favouritetype' style='width:120px!important;'>
			  		<option></option>
			  		<option value='1' <%if("1".equals(favouritetype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(58 ,user.getLanguage()) %></option><!-- 文档 -->
			  		<option value='2' <%if("2".equals(favouritetype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(18015 ,user.getLanguage()) %></option><!-- 流程 -->
			  		<option value='3' <%if("3".equals(favouritetype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(101 ,user.getLanguage()) %></option><!-- 项目 -->
			  		<option value='4' <%if("4".equals(favouritetype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(136 ,user.getLanguage()) %></option><!-- 客户 -->
			  		<option value='0' <%if("0".equals(favouritetype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(375 ,user.getLanguage()) %></option><!-- 其他 -->
			  	</select>
		  	</wea:required>
		  </wea:item>
	
	</wea:group>
	</wea:layout>
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
  </FORM>
  <%if("1".equals(isDialog)){ %>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>	
<%} %>
</BODY>
<script language="javascript">
function onSubmit(){
	//alert("111111111111");
   	if(check_form(frmMain,"title,importlevel,favouritetype")) frmMain.submit();
}
function onBack()
{
	parentWin.closeDialog();
}
</script>

</HTML>
