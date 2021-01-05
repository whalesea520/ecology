
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.general.GCONST" %>
<%
//if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
//    response.sendRedirect("/notice/noright.jsp");
//    return;
//}

String imagefilename = "/images/hdMaintenance_wev8.gif";
//左侧菜单维护-自定义菜单
String titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
String needfav ="1";
String needhelp ="";    

int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
String type = Util.null2String(request.getParameter("type"));
String menuflag = Util.null2String(request.getParameter("menuflag"));//表单建模新增菜单地址
String menuaddress = Util.null2String((String)session.getAttribute(user.getUID()+"_"+menuflag+"_menuaddress"));//表单建模新增菜单地址
boolean displayAdvanced = true;
if(menuaddress.equals("")){
	displayAdvanced = false;
	menuaddress = "http://www.weaver.com.cn";
}
//out.println("menuaddress:"+menuaddress);

int infoId = Util.getIntValue(request.getParameter("id"),0);
int userid=0;
userid=user.getUID();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
	<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
  </head>
  
  <body  width="100%">
  
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this,event),_self} " ;//保存
  RCMenuHeight += RCMenuHeightStep ;

  if("left".equals(type)&&displayAdvanced){
 	 RCMenu += "{"+SystemEnv.getHtmlLabelName(19048,user.getLanguage())+",javascript:onAdvanced(this),_self} " ;//高级模式
  	 RCMenuHeight += RCMenuHeightStep ;
  }

  %>
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<div class="zDialog_div_content">	
	<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/formmode/menu/MenuMaintenanceOperation.jsp" enctype="multipart/form-data">
	<input name="method" type="hidden" value="add"/>
	<input name="resourceId" type="hidden" value="<%=resourceId%>">
	<input name="resourceType" type="hidden" value="<%=resourceType%>">
	<input name="parentId" type="hidden" value="<%=infoId%>"/>
	<input name="type" type="hidden" value="<%=type%>">
	<input name="menuflag" type="hidden" value="<%=menuflag%>">
	<%-- 图标 --%>
	<INPUT name="customIconUrl" type="hidden" value="<% if(infoId != 0) {%>/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif<%} else {%>/images/folder_wev8.png<%}%>">
<wea:layout type="2Col"><!-- 基本信息 -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
	<wea:item type="groupHead"><!-- 引用此菜单到下级分部 -->
		<%if(!"3".equals(resourceType)){%><div  align="right"><%=SystemEnv.getHtmlLabelName(20827,user.getLanguage())%> &nbsp;<input type="checkbox" value="1" id="chkSynch" name="chkSynch"> &nbsp;</div><%}%>
	</wea:item>	<!-- 菜单名称 -->
	<wea:item><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%></wea:item>
      <wea:item>
        <wea:required id="customMenuNamespan" required="true">
         <INPUT class=InputStyle maxLength=50 name="customMenuName" value="" onchange="checkinput('customMenuName','customMenuNamespan')">
        </wea:required>
      </wea:item><!-- 菜单名称(英文) -->
      <wea:item><%=SystemEnv.getHtmlLabelName(20593,user.getLanguage())%></wea:item>
      <wea:item><INPUT class=InputStyle maxLength=50 name="customName_e" value=""></wea:item>
      <%if(GCONST.getZHTWLANGUAGE()==1){ %><!-- 菜单名称(繁体) -->
      <wea:item><%=SystemEnv.getHtmlLabelName(21864,user.getLanguage())%></wea:item>
      <wea:item><INPUT class=InputStyle maxLength=50 name="customName_t" value=""></wea:item>
      <%} %><!-- 链接地址 -->
      <wea:item><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></wea:item>
      <wea:item>
     	<INPUT class=InputStyle style="width:300px" name="customMenuLink" value="<%=menuaddress %>" title="<%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%>">
		<SPAN id=linkImage></SPAN>
	  </wea:item><!-- 打开位置 -->
      <wea:item><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%></wea:item>
      <wea:item>
      	<select  name="targetframe">
			<option value="" selected><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%></option><!-- 默认窗口 -->
			<option value="_blank"><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option><!-- 弹出窗口 -->
		</select>
	  </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(20592,user.getLanguage())%></wea:item><!-- 菜单图标 -->
      <wea:item><input type="file" name="customIconUrl" onchange="onIcoChange(this)" value="">&nbsp;(16*16)&nbsp;<span id=spanShow></span></wea:item>
      <%if(infoId==0){%>
      <wea:item><%=SystemEnv.getHtmlLabelName(20611,user.getLanguage())%></wea:item><!-- 顶部菜单 -->
      <wea:item><input type="file" name="topIconUrl" value="">&nbsp;(32*32)&nbsp;</wea:item>
      <%}%>
      <wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item><!-- 说明 -->
      <wea:item>
      	1.<%=SystemEnv.getHtmlLabelName(20599,user.getLanguage())%>&nbsp;"Http://"<br/><!-- 如果是外部地址，请在地址前加上 -->
      	2.<%=SystemEnv.getHtmlLabelName(20600,user.getLanguage())%><br/><!-- 图标请使用(16*16)的图片 -->
      	3.<%=SystemEnv.getHtmlLabelName(20601,user.getLanguage())%>&nbsp;<img src="/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif"><br/><!-- 如果不设置图片系统将会默使用图片 -->
      	4.<%=SystemEnv.getHtmlLabelName(20602,user.getLanguage())%><br/>"/images_face/ecologyFace_2/LeftMenuIcon/"<br/><br/><!-- 如果要使用系统图片请访问服务器文件夹 -->
      </wea:item>
	</wea:group>
</wea:layout>	
				
                
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar"><!-- 保存 -->
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="checkSubmit(this,event);"/>
	     <span class="e8_sep_line">|</span><!-- 取消 -->
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
</div>
</body>

<script LANGUAGE="JavaScript">
function checkSubmit(obj,event){
	
	<% if(infoId == 0) { %>
	if(check_form(frmMain,'customMenuName')){
		obj.disabled=true;
		frmMain.submit();	 	
	}
	<% } else { %>
	if(check_form(frmMain,'customMenuName')){
		//window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		event = jQuery.event.fix(event);
		event.target.disabled = true;
		obj.disabled=true;
		frmMain.submit();

	}
	<% } %>
	
}

function onBack(obj){
	location.href="/formmode/menu/MenuMaintenanceList.jsp?type=<%=type%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>";
	obj.disabled=true;
}

function onAdvanced(obj){
	location.href="/formmode/menu/MenuMaintenanceAddAdvanced.jsp?type=<%=type%>&id=<%=infoId%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>";
	obj.disabled=true;
}


function onIcoChange(obj){
	if(this.vlaue!='') spanShow.innerHTML="<img src='"+obj.value+"'>"
}

function onCancel(){
	parent.onCancel();
}
</script>



</html>

