
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
//    response.sendRedirect("/notice/noright.jsp");
//    return;
//}


int infoId = Util.getIntValue(request.getParameter("id"));
int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
int sync = Util.getIntValue(request.getParameter("sync"),0);
String edit = Util.null2String(request.getParameter("edit"));
String type = Util.null2String(request.getParameter("type"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
//左侧菜单维护-自定义菜单分类
String titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18772,user.getLanguage());
if(edit.equals("sub")){//左侧菜单维护-自定义菜单
	titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
}
String needfav ="1";
String needhelp ="";


int userid=0;
userid=user.getUID();

String linkAddress="",customName="",iconUrl="",topIconUrl="",customName_e="",customName_t="";
int menuLevel=0;
int viewIndex = 0;


MenuUtil mu=new MenuUtil(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());
MenuMaint  mm=new MenuMaint(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());



MenuConfigBean mcb = mm.getMenuConfigBeanByInfoId(infoId);
String targetFrame="";
if(mcb!=null){
	linkAddress = mcb.getMenuInfoBean().getLinkAddress();
	customName = mcb.getName();
	customName_e=mcb.getName_e();
	customName_t = mcb.getName_t();
	viewIndex = mcb.getViewIndex();
	iconUrl = mcb.getMenuInfoBean().getIconUrl();
	topIconUrl=mcb.getMenuInfoBean().getTopIconUrl();
	menuLevel=mcb.getMenuInfoBean().getMenuLevel();
	targetFrame= mcb.getMenuInfoBean().getTargetBase();
	if(mcb.getMenuInfoBean().getIsAdvance()==1)//高级模式菜单
		response.sendRedirect("MenuMaintenanceEditAdvanced.jsp?type="+type+"&id="+infoId+"&resourceId="+resourceId+"&resourceType="+resourceType+"&edit="+edit+"&sync="+sync);
	
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>

<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep ; 

//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteMenu(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">	
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="MenuMaintenanceOperation.jsp" enctype="multipart/form-data">
<input name="method" type="hidden" value="edit"/>
<input type="hidden" name="infoId" value="<%=infoId%>"/>
<input type="hidden" name="resourceId" value="<%=resourceId%>"/>
<input type="hidden" name="resourceType" value="<%=resourceType%>"/>
<input name="sync" type="hidden" value="<%=sync%>"/>
<input name="type" type="hidden" value="<%=type%>">
<%-- 图标 --%>
<INPUT name="customIconUrl" type="hidden" value="<%=iconUrl%>">
<wea:layout type="2Col"><!-- 基本信息 -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
	<wea:item type="groupHead"><!-- 引用此菜单到下级分部 -->
	<%if(!"3".equals(resourceType)){%><div  align="right"><%=SystemEnv.getHtmlLabelName(20827,user.getLanguage())%> &nbsp;<input type="checkbox" value="1" id="chkSynch" name="chkSynch"> &nbsp;</div><%}%>
	</wea:item>	
	<wea:item>
		<%if(edit.equals("sub")){%>
			<%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%><!-- 菜单名称 -->
		<%}else{%>
			<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%><!-- 名称 -->
		<%}%>
	</wea:item>
      <wea:item>
        <wea:required id="customMenuNamespan" required="true"  value='<%=customName%>'>
         <INPUT class=InputStyle maxLength=50 name="customMenuName" value="<%=customName%>" onchange="checkinput('customMenuName','customMenuNamespan')">
        </wea:required>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(20593,user.getLanguage())%></wea:item><!-- 菜单名称(英文) -->
      <wea:item><INPUT class=InputStyle maxLength=50 name="customName_e" value='<%=customName_e%>'></wea:item>
      <%if(GCONST.getZHTWLANGUAGE()==1){ %>
      <wea:item><%=SystemEnv.getHtmlLabelName(21864,user.getLanguage())%></wea:item><!-- 菜单名称(繁体) -->
      <wea:item><INPUT class=InputStyle maxLength=50 name="customName_t" value='<%=customName_t%>'></wea:item>
      <%} %>
      <%if(edit.equals("sub")){%>
      <wea:item><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></wea:item><!-- 链接地址 -->
      <wea:item>
     	<INPUT class=InputStyle style="width:300px" name="customMenuLink" value="<%=linkAddress%>" title="<%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%>">
		<SPAN id=linkImage></SPAN>
	  </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%></wea:item><!-- 打开位置 -->
      <wea:item>
      	<select  name="targetframe">
			<option value="" <%if("".equals(targetFrame)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%></option><!-- 默认窗口 -->
			<option value="_blank" <%if(!"".equals(targetFrame)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option><!-- 弹出窗口 -->
		</select>
	  </wea:item>
	  <%} %>
      <wea:item><%=SystemEnv.getHtmlLabelName(20592,user.getLanguage())%></wea:item><!-- 菜单图标 -->
      <wea:item>
      	<input type="file" name="customIconUrl" onchange="onIcoChange(this)" value="">&nbsp;(16*16)&nbsp;<span id=spanShow><%if(!"".equals(iconUrl)){%><img src="<%=iconUrl%>"><%}%></span>
      </wea:item>
      <%if(menuLevel==1){%>
      <wea:item><%=SystemEnv.getHtmlLabelName(20611,user.getLanguage())%></wea:item><!-- 顶部菜单 -->
      <wea:item>
      	<input type="file" name="topIconUrl" value="">&nbsp;(32*32)&nbsp;<span id=topspanShow><%if(!"".equals(topIconUrl)){%><img src="<%=topIconUrl%>"><%}%></span>
      </wea:item>
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
<!--================================================================================-->	
</FORM>

</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="checkSubmit(this);"><!-- 保存 -->
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"><!-- 取消 -->
	    </td></tr>
	</table>
</div>
</body>

<script LANGUAGE="JavaScript">
function deleteMenu(obj){
	if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")){//您确定删除此记录吗？
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		location.href = "LeftMenuMaintenanceOperation.jsp?type=<%=type%>&method=del&infoId=<%=infoId%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=<%=sync%>";
		obj.disabled=true;
	}
}

function checkSubmit(obj){
	if(check_form(frmMain,'customMenuName')){
		frmMain.submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		obj.disabled=true;
	}
}

function doCheck_form(obj){
	if(check_form(frmMain,'customMenuName,customIconUrl')){
		frmMain.submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		obj.disabled=true;
	}
}

function onBack(obj){
	location.href="MenuMaintenanceList.jsp?type=<%=type%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=<%=sync%>";
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

