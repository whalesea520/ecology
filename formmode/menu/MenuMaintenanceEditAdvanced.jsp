
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="weaver.general.Util,weaver.general.GCONST,weaver.file.Prop,
                 weaver.docs.category.security.AclManager,
                 weaver.docs.category.CategoryTree,
                 weaver.docs.category.CommonCategory" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page"/>
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page"/>
<jsp:useBean id="InputReportComInfo" class="weaver.datacenter.InputReportComInfo" scope="page" />

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
//左侧菜单维护-自定义菜单
String titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
String needfav ="1";
String needhelp ="";

int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
int infoId = Util.getIntValue(request.getParameter("id"),0);
int sync = Util.getIntValue(request.getParameter("sync"),0);
String type = Util.null2String(request.getParameter("type"));
int userid=0;
userid=user.getUID();
Prop prop = Prop.getInstance();
String hasOvertime = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.overtime"));
String hasChangStatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.changestatus"));
//if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
//    response.sendRedirect("/notice/noright.jsp");
//    return;
//}

MenuUtil mu=new MenuUtil(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());
MenuMaint  mm=new MenuMaint(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());
MenuInfoBean info = mm.getMenuInfoBean(""+infoId);

if(info==null){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String selectArr = "";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
  </head>
  
  <body>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_self} " ;//保存
  RCMenuHeight += RCMenuHeightStep ;

  RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteMenu(this),_self} " ;//删除
  RCMenuHeight += RCMenuHeightStep ;

  RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(this),_self} " ;//返回
  RCMenuHeight += RCMenuHeightStep ;
  %>
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<FORM style="MARGIN-TOP: 0px" name=frmmain method=post action="MenuMaintenanceOperation.jsp"  enctype="multipart/form-data">
	<input name="method" type="hidden" value="editadvanced"/>
	<input name="resourceId" type="hidden" value="<%=resourceId%>">
	<input name="resourceType" type="hidden" value="<%=resourceType%>">
	<input name="infoId" type="hidden" value="<%=infoId%>"/>
	<input name="parentId" type="hidden" value="<%=info.getParentId()%>"/>
	<input name="sync" type="hidden" value="<%=sync%>"/>
	<input name="type" type="hidden" value="<%=type%>">
	<%-- 图标 --%>
	<INPUT name="customIconUrl" type="hidden" value="<%=info.getIconUrl()%>">
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
    <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td ></td>
		<td valign="top">
		
		<TABLE class="Shadow">
			<tr>
				<td valign="top">
				
				
	    <TABLE class=ViewForm>
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			
			<TBODY>
			
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH><!-- 基本信息 -->
				</TR>
				<TR class=Spacing style="height: 1px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>

                <%-- 菜单名称 --%>
                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%></td><!-- 菜单名称 -->
				  <td class=Field>
				  	<INPUT class=InputStyle maxLength=50 name="customMenuName" value="<%=info.getCustomName() %>" onchange="checkinput('customMenuName','Nameimage')">
				  	<SPAN id=Nameimage></SPAN>
				  </td>
				</tr>
				<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				 <tr>
				  <td><%=SystemEnv.getHtmlLabelName(20593,user.getLanguage())%></td><!-- 菜单名称(英文) -->
				  <td class=Field>
					<INPUT class=InputStyle maxLength=50 name="customName_e" value="<%=info.getCustomName_e()%>">				
				  </td>
				</tr>
				<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				<%if(GCONST.getZHTWLANGUAGE()==1){ %>	
				
				 <tr>
				  <td><%=SystemEnv.getHtmlLabelName(21864,user.getLanguage())%></td><!-- 菜单名称(繁体) -->
				  <td class=Field>
					<INPUT class=InputStyle maxLength=50 name="customName_t" value="<%=info.getCustomName_t()%>">				
				  </td>
				</tr>
				<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				<%} %>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(19063,user.getLanguage())%></td><!-- 图标地址 -->
				  <td class=Field>	 
					 <input type="file" name="customIconUrl" onchange="onIcoChange(this)" value="">&nbsp;(16*16)&nbsp;<span id=spanShow><img src="<%=info.getIconUrl()%>"></span>	
				  </td>
				</tr>
				<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				
				<%if(info.getMenuLevel()==1){%>
					<tr><!-- 顶部菜单图标 -->
					  <td><%=SystemEnv.getHtmlLabelName(20611,user.getLanguage())+SystemEnv.getHtmlLabelName(22969,user.getLanguage())%></td>
					  <td class=Field>				  
						<input type="file" name="topIconUrl" value="">&nbsp;(32*32)&nbsp;<span id=topspanShow><%if(!"".equals(info.getTopIconUrl())){%><img src="<%=info.getTopIconUrl()%>"><%}%></span>
					  </td>
					</tr>
					<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				<%} %>		

				<%-- 模块 --%>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%></td>
				  <td class=Field>
					<input type="radio" name="customModule" value="1" onClick="onChangeModule(this);" <%if(info.getFromModule()==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%><!-- 文档 -->
					<input type="radio" name="customModule" value="2" onClick="onChangeModule(this);" <%if(info.getFromModule()==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><!-- 流程 -->
					<input type="radio" name="customModule" value="3" onClick="onChangeModule(this);" <%if(info.getFromModule()==3){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><!-- 客户 -->
					<input type="radio" name="customModule" value="4" onClick="onChangeModule(this);" <%if(info.getFromModule()==4){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><!-- 项目 -->
				  </td>
				</tr>
                <TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>

				<%-- 菜单类型 --%>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(19054,user.getLanguage())%></td>
				  <td class=Field>
				  	<select name="customType_1" style="display:block" onChange="onChangeModuleType(this);">
				  		<option value="1" <%if(info.getFromModule()==1&&info.getMenuType()==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%></option><!-- 新建文档 -->
				  		<option value="2" <%if(info.getFromModule()==1&&info.getMenuType()==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1212,user.getLanguage())%></option><!-- 我的文档 -->
				  		<option value="3" <%if(info.getFromModule()==1&&info.getMenuType()==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16397,user.getLanguage())%></option><!-- 最新文档 -->
				  		<option value="4" <%if(info.getFromModule()==1&&info.getMenuType()==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></option><!-- 文档目录 -->
				  	</select>	
				  	<select name="customType_2" style="display:none" onChange="onChangeModuleType(this);">
				  		<option value="1" <%if(info.getFromModule()==2&&info.getMenuType()==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%></option><!-- 新建流程 -->
				  		<option value="2" <%if(info.getFromModule()==2&&info.getMenuType()==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></option><!-- 待办事宜 -->
				  		<option value="3" <%if(info.getFromModule()==2&&info.getMenuType()==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17991,user.getLanguage())%></option><!-- 已办事宜 -->
				  		<option value="4" <%if(info.getFromModule()==2&&info.getMenuType()==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17992,user.getLanguage())%></option><!-- 办结事宜 -->
						<option value="6" <%if(info.getFromModule()==2&&info.getMenuType()==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21639,user.getLanguage())%></option><!-- 抄送事宜 -->
						<option value="7" <%if(info.getFromModule()==2&&info.getMenuType()==7){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21640,user.getLanguage())%></option><!-- 督办事宜 -->
						<%if(!"".equals(hasOvertime)){%>
						<option value="8" <%if(info.getFromModule()==2&&info.getMenuType()==8){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21641,user.getLanguage())%></option><!-- 超时事宜 -->
						<%}%>
						<%if(!"".equals(hasChangStatus)){%>
						<option value="9" <%if(info.getFromModule()==2&&info.getMenuType()==9){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21643,user.getLanguage())%></option><!-- 反馈事宜 -->
						<%}%>
				  		<option value="5" <%if(info.getFromModule()==2&&info.getMenuType()==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1210,user.getLanguage())%></option><!-- 我的请求 -->
				  	</select>
				  	<select name="customType_3" style="display:none" onChange="onChangeModuleType(this);">
				  		<option value="1" <%if(info.getFromModule()==3&&info.getMenuType()==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15006,user.getLanguage())%></option><!-- 新建客户 -->
				  	</select>
				  	<select name="customType_4" style="display:none" onChange="onChangeModuleType(this);">
				  		<option value="1" <%if(info.getFromModule()==4&&info.getMenuType()==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15007,user.getLanguage())%></option><!-- 新建项目 -->
				  		<option value="2" <%if(info.getFromModule()==4&&info.getMenuType()==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16408,user.getLanguage())%></option><!-- 项目执行 -->
				  		<option value="3" <%if(info.getFromModule()==4&&info.getMenuType()==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16409,user.getLanguage())%></option><!-- 审批项目 -->
				  		<option value="4" <%if(info.getFromModule()==4&&info.getMenuType()==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16410,user.getLanguage())%></option><!-- 审批任务 -->
				  		<option value="5" <%if(info.getFromModule()==4&&info.getMenuType()==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16411,user.getLanguage())%></option><!-- 当前任务 -->
				  		<option value="6" <%if(info.getFromModule()==4&&info.getMenuType()==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16412,user.getLanguage())%></option><!-- 超期任务 -->
				  	</select>
				  </td>
				</tr>
                <TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>

			</TBODY>
		</TABLE>
		<div id="divContent"></div>

				</td>
			</tr>
		</TABLE>
		
		</td>
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	</table>


	
    </FORM>


</body>

<script LANGUAGE="JavaScript">

var menuModule = eval("frmmain.customModule");
for(var i=0;menuModule!=null&&i<menuModule.length;i++){
	if(menuModule[i].value=="<%=info.getFromModule()%>"){
		onChangeModule(menuModule[i]);
		break;
	}
}



function getData(type){
	$("#divContent").html("<img src=/images/loading2_wev8.gif>&nbsp;<%=SystemEnv.getHtmlLabelName(19819,user.getLanguage())%>...");//请稍后
	
	$.get("MenuMaintenanceEditAdvancedGet.jsp",{"searchType":type,type:"<%=type%>",type:"<%=type%>",resourceId:"<%=resourceId%>",
		resourceType:"<%=resourceType%>",sync:1,id:"<%=infoId%>"},
		function(data){
	   	 	$("#divContent").html(data);
		}
	);	
}

var menuModule = eval("frmmain.customModule");
for(var i=0;menuModule!=null&&i<menuModule.length;i++){
	if(menuModule[i].value=="<%=info.getFromModule()%>"){
		onChangeModule(menuModule[i]);
		break;
	}
}
var menuModuleType = eval("frmmain.customType_<%=info.getFromModule()%>");
onChangeModuleType(menuModuleType);

function checkSubmit(obj){
	<% if(infoId == 0) { %>
	if(check_form(frmmain,'customMenuCName')){
		obj.disabled=true;
		frmmain.submit();
	}
	<% } else { %>
	if(check_form(frmmain,'customMenuName,customMenuLink')){
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		obj.disabled=true;
		frmmain.submit();
	}
	<% } %>
	
}

function onBack(obj){
	location.href="MenuMaintenanceList.jsp?resourceId=<%=resourceId%>&resourceType=<%=resourceType%>";
	obj.disabled=true;
}

function onChangeModule(obj){
	for(var i=1;i<=4;i++){
		var typeObj = eval("frmmain.customType_"+i);
		if(typeObj!=null) typeObj.style.display = "none";
	}
	var currTypeObj = eval("frmmain.customType_"+obj.value);
	if(currTypeObj!=null){
		currTypeObj.style.display = "block";
		onChangeModuleType(currTypeObj);
	}
}

function onChangeModuleType(obj){
	var splitname = obj.name;
	var typeObj = null;
	for(var i=1;i<=15;i++){
		typeObj = document.getElementById("customSetting_"+i);
		if(typeObj!=null) typeObj.style.display = "none";
	}
	var splitstrarray = obj.name.split("_");
	var currselect = 0;
	
	if(splitstrarray[1]=="1"&&obj.value=="1"){//新建文档
		getData("adddoc");
	} else if(splitstrarray[1]=="1"&&obj.value=="2"){//我的文档
		getData("mydoc");
	} else if(splitstrarray[1]=="1"&&obj.value=="3"){//最新文档
		getData("newdoc");
	} else if(splitstrarray[1]=="1"&&obj.value=="4"){//文档目录
		getData("doccategory");
	} else if(splitstrarray[1]=="2"&&obj.value=="1"){//新建流程
		getData("addwf");
	} else if(splitstrarray[1]=="2"&&obj.value=="2"){//待办事宜
		getData("waitdowf");
	} else if(splitstrarray[1]=="2"&&obj.value=="3"){//已办事宜
		getData("donewf");
	} else if(splitstrarray[1]=="2"&&obj.value=="4"){//办结事宜
		getData("alreadydowf");
	} else if(splitstrarray[1]=="2"&&obj.value=="5"){//我的请求
		getData("mywf");
	} else if(splitstrarray[1]=="3"&&obj.value=="1"){//新建客户
		getData("addcus");
	} else if(splitstrarray[1]=="4"&&obj.value=="1"){//新建项目
		getData("addproject");
	} else if(splitstrarray[1]=="4"&&obj.value=="2"){//项目执行

	} else if(splitstrarray[1]=="4"&&obj.value=="3"){//审批项目

	} else if(splitstrarray[1]=="4"&&obj.value=="4"){//审批任务

	} else if(splitstrarray[1]=="4"&&obj.value=="5"){//当前任务

	} else if(splitstrarray[1]=="4"&&obj.value=="6"){//超期任务

	} else if(splitstrarray[1]=="2"&&obj.value=="6"){//抄送事宜
		getData("sendwf");
	} else if(splitstrarray[1]=="2"&&obj.value=="7"){//督办事宜
		getData("supervisewf");
	} else if(splitstrarray[1]=="2"&&obj.value=="8"){//超时事宜
		getData("overtimewf");
	} else if(splitstrarray[1]=="2"&&obj.value=="9"){//反馈事宜
		getData("backwf");
	}
	if(currselect>0){
		typeObj = document.getElementById("customSetting_"+currselect);
		if(typeObj!=null) typeObj.style.display = "block";
	}
}
function deleteMenu(obj){
	if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>?")){//您确定删除此记录吗？
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		location.href = "LeftMenuMaintenanceOperation.jsp?type=<%=type%>&method=del&infoId=<%=infoId%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=<%=sync%>";
		obj.disabled=true;
	}
}

function onIcoChange(obj){
	if(this.vlaue!='') spanShow.innerHTML="<img src='"+obj.value+"'>"
}

</script>

</html>

