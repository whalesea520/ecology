
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page"/>
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="pm" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23141,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";    

int userId = 0;
userId = user.getUID();
int loginTemplateId = Util.getIntValue(request.getParameter("templateId"));
String saved = Util.null2String(request.getParameter("saved"));
if(!HrmUserVarify.checkUserRight("LoginPageMaint", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>


<%

String canCustom = pm.getConfig().getString("portal.custom");


String loginTemplateName="",loginTemplateTitle="",templateType="",imageId="",isCurrent="",modeid="",menuId="",menuType="",menuTypeId="",floatwidth="",floatheight="",windowwidth="",windowheight="",docId="",docName="",openWindowLink="",defaultshow = "";
String imageId2 = "";
String backgroundColor = "";
int extendloginid=0;
String leftmenuid="";
String leftmenustyleid="";
String sql = "SELECT * FROM SystemLoginTemplateTemp WHERE loginTemplateId="+loginTemplateId;

rs.executeSql(sql);
if(rs.next()){
	loginTemplateName = rs.getString("loginTemplateName");
	loginTemplateTitle = rs.getString("loginTemplateTitle");
	templateType = rs.getString("templateType");
	imageId = rs.getString("imageId");
	isCurrent = rs.getString("isCurrent");
	extendloginid = rs.getInt("extendloginid");
	modeid = rs.getString("modeid");
	menuId = rs.getString("menuid");
	menuType = rs.getString("menutype");
	menuTypeId = rs.getString("menutypeid");
	floatwidth = rs.getString("floatwidth");
	floatheight = rs.getString("floatheight");
	windowwidth = rs.getString("windowwidth");
	windowheight = rs.getString("windowheight");
	docId = rs.getString("docId");
	openWindowLink = rs.getString("openWindowLink");
	defaultshow = rs.getString("defaultshow");
	if("#".equals(defaultshow)){
		defaultshow = "";
	}
	leftmenuid = rs.getString("leftmenuid");
	leftmenustyleid = rs.getString("leftmenustyleid");
	imageId2 = rs.getString("imageId2");
	backgroundColor = rs.getString("backgroundColor");
}

List imageId2List=Util.TokenizerString(imageId2,",");
int imageid2Size=imageId2List.size();

//获取浮动窗口显示文档的名
if(!"".equals(docId))
	docName = DocComInfo.getDocname(docId);


//菜单名称
String menuName = "";
//菜单样式名称
String menuTypeName = "";
//获取菜单样式的链接地址
String tmenuTypeLink = "";
String menuTypeLink = "";


if(!"".equals(menuId))
{
	MenuCenterCominfo.setTofirstRow();
	while (MenuCenterCominfo.next())
	{
		
		String tmenuType = MenuCenterCominfo.getMenutype();
		if(menuId.equals(MenuCenterCominfo.getId()))
		{
			menuName = MenuCenterCominfo.getMenuname();
		}
	}
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<style>input{width:340px} .radio{width:20px}</style>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%" style='display:none'>
	<tr>
		<td width="75px">
							
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>" class="e8_btn_top" onclick="doPreview()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32599,user.getLanguage())%>" class="e8_btn_top" onclick="doSaveAndEnable()" />
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>" class="e8_btn_top" onclick="doSaveAs()" />
			
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave()" />
			<%if(loginTemplateId!=1 && loginTemplateId!=2&&!"1".equals(isCurrent)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doDel()" />
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM style="margin:0" name="frmMain" method="post" enctype="multipart/form-data" action="loginTemplateOperation.jsp">
<input id="operationType" name="operationType" type="hidden" value="editLoginTemplate"/>
<input name="loginTemplateId" type="hidden" value="<%=loginTemplateId%>"/>
<input type="hidden" name="imageIdOld" value="<%=imageId%>"/>
<input type="hidden" name="imageId2Old" id="imageId2Old" value="<%=imageId2%>"/>
<input type="hidden" name="imageId2OldTemp" id="imageId2OldTemp" value="<%=imageId2%>"/>
<input type="hidden" id="isCurrent" name="isCurrent" value="<%=isCurrent%>"/>

<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' >
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(19069,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<input type="hidden" id="oldLoginTemplateName" value="<%=loginTemplateName%>">
			<INPUT class=InputStyle maxLength=50  id="loginTemplateName" name="loginTemplateName" value="<%=loginTemplateName%>" onchange="checkinput('loginTemplateName','loginTemplateNameImage');updateTemp(this)">
			<SPAN id=loginTemplateNameImage></SPAN>
		</wea:item>
		
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(19070,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<INPUT class=InputStyle maxLength=50  name="loginTemplateTitle" value="<%=loginTemplateTitle%>" onchange="updateTemp(this)">
		</wea:item>
		
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(23140,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<wea:required id="modeidRequired" required="true">
				<select name="modeid"  onchange="updateTemp(this);chageModeId(this);" >
						<option value="0"><%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%></option>
						<%
						rs.executeSql("select * from pagetemplate order by id");
						while (rs.next()){
						%>
						<option value="<%=rs.getString("id")%>" <%=rs.getString("id").equals(modeid)?" selected ":""%> ><%=rs.getString("templatename")%></option>
						<%}%>
				</select>
			</wea:required>
		</wea:item>
		
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20611,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<select name="menuId" style="" onchange="updateTemp(this)" >
				<option value="0"><%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%></option>
				<%
				MenuCenterCominfo.setTofirstRow();						
				while(MenuCenterCominfo.next()){
					if(!MenuCenterCominfo.getMenutype().equals("1")){
						continue;
					}
				%>
				<option value="<%=MenuCenterCominfo.getId()%>" <%=MenuCenterCominfo.getId().equals(menuId)?" selected ":""%>><%=MenuCenterCominfo.getMenuname()%></option>
				<%}%>
			</select>
		</wea:item>
		
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(22432,user.getLanguage())+SystemEnv.getHtmlLabelName(22916,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<INPUT id="tempMenuType" type=hidden value="menuh" name="tempMenuType">
				<brow:browser viewType="0" name="menuTypeId" browserValue='<%=menuTypeId %>' 
							browserOnClick="" _callback="updateTempData" browserUrl="/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type=menuh&isDialog=1" 
							hasInput="true" browserDialogWidth="600" isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
							
							browserSpanValue='<%=mhsc.getTitle(menuTypeId) %>' ></brow:browser>
							
		
			
			</SPAN>
		</wea:item>
		
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(17596,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<select name="leftmenuId" style="" onchange="updateTemp(this)">
				<option value="0"><%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%></option>
				<%
				MenuCenterCominfo.setTofirstRow();						
				while(MenuCenterCominfo.next()){
					if(!MenuCenterCominfo.getMenutype().equals("1")){
						continue;
					}
				%>
				<option value="<%=MenuCenterCominfo.getId()%>" <%=MenuCenterCominfo.getId().equals(leftmenuid)?" selected ":""%>><%=MenuCenterCominfo.getMenuname()%></option>
				<%}%>
			</select>	
		</wea:item>
		
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(17596,user.getLanguage())+SystemEnv.getHtmlLabelName(1014,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<INPUT id="lefttempMenuType" type=hidden value="menuv" name="lefttempMenuType">
				
			<brow:browser viewType="0" name="leftmenustyleid" browserValue='<%=leftmenustyleid %>' 
							browserOnClick="" _callback="updateTempData"  browserUrl="/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type=menuv&isDialog=1" 
							hasInput="true" browserDialogWidth="600" isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
							
							browserSpanValue='<%=mvsc.getTitle(leftmenustyleid) %>' ></brow:browser>
		</wea:item>
		
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(23103,user.getLanguage())%>
		</wea:item>
		<wea:item>
			
			<brow:browser viewType="0" name="defaultshow" browserValue='<%=defaultshow %>' 
							browserOnClick="" _callback="updateTempData" browserUrl="/systeminfo/BrowserMain.jsp?url=/homepage/maint/LoginPageBrowser.jsp?menutype=1&isDialog=1" 
							hasInput="true" browserDialogWidth="600" isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
							
							browserSpanValue='<%=defaultshow %>' ></brow:browser>
		</wea:item>
		
		
	</wea:group>
</wea:layout>

</FORM>


</body>
</html>

<script language="javascript">
var saved ="<%=saved%>";

$(document).ready(function(){
	chageModeId()
})
function doPreview(){
	if(!checkRequired()){
		return;
	}
	
	var menuStyle_dialog = new window.top.Dialog();
	menuStyle_dialog.currentWindow = window;   //传入当前window
 	menuStyle_dialog.Width = 700;
 	menuStyle_dialog.Height = 500;
 	menuStyle_dialog.maxiumnable=true;
 	menuStyle_dialog.Modal = true;
 	menuStyle_dialog.Title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>"; 
 	menuStyle_dialog.URL = "/systeminfo/template/loginTemplatePreview.jsp?loginTemplateId=<%=loginTemplateId%>&tmpdata=Temp"
 	menuStyle_dialog.show();
	
}

function doSave(){
	if(!checkRequired()){
		return;
	}
	$.post("/systeminfo/template/loginTemplateTempOperation.jsp",
	{method:'commit',loginTemplateId:'<%=loginTemplateId%>'},function(){
		parent.parent.Dialog.close()
	})
	
}

function doSaveAndEnable(){
	if(!checkRequired()){
		return;
	}
	$.post("/systeminfo/template/loginTemplateTempOperation.jsp",
	{method:'commit&enable',loginTemplateId:'<%=loginTemplateId%>'},function(){
		top.getDialog(parent).currentWindow.document.location.reload();
		parent.parent.Dialog.close()
		
	})
}

function updateTemp(obj){
	var name = $(obj).attr("name");
	var value = $(obj).val();
	doUpdateTempData("SystemLoginTemplate",name,value);
}
function updateTempData(event,datas,name,_callbackParams){
	doUpdateTempData("SystemLoginTemplate",name,datas.id);
}

function doUpdateTempData(tbname,field,value){

	$.post("/systeminfo/template/loginTemplateTempOperation.jsp"
	,{method:'update',tbname:tbname,field:field,value:value},function(data){
	
	})
}


function checkSubmit(e){

	jQuery("input[type=file]").each(function(){
	   if(jQuery(this).val()!=""&&jQuery(this).attr("imageid2temp"))
	       delImg(this);  
	});

	var templateType =  $("input[type=radio][checked]").val();
	var ids = "";
	if(templateType=="site"){
		ids =  "loginTemplateName,modeid"
	}else{
		ids =  "loginTemplateName"
	}
	if(check_form(frmMain,ids)){
		document.frmMain.submit();
		(e.srcElement||e.target).disabled=true;
	}
}


function doSaveAs(){
	var menuStyle_dialog = new window.top.Dialog();
	menuStyle_dialog.currentWindow = window;   //传入当前window
 	menuStyle_dialog.Width = 400;
 	menuStyle_dialog.Height = 150;
 	menuStyle_dialog.maxiumnable=false;
 	menuStyle_dialog.Modal = true;
 	menuStyle_dialog.Title = "<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"; 
 	menuStyle_dialog.URL = "/systeminfo/template/loginTemplateSaveAs.jsp?from=dialog&templateid=<%=loginTemplateId%>";
 	menuStyle_dialog.show();
}


function doDel(e){
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>",function(){
		$.post("/systeminfo/template/loginTemplateTempOperation.jsp"
		,{method:'delete',loginTemplateId:<%=loginTemplateId%>},function(data){
			top.getDialog(parent).currentWindow.document.location.reload();
			dialog = top.getDialog(parent);
			dialog.close();
			
		})
	})
	
}

function deleteBgImage(imgStr){
	if(confirm()){
		document.getElementById("operationType").value = "deleteBgImage";
		document.getElementById("bgImage").value = imgStr;
		document.frmMain.submit();
		this.disabled = true;
	}
}

function changeImgSize(t){
	if(t=="V"){
		tdTypeMsg.innerHTML="<%=SystemEnv.getHtmlLabelName(19074,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(19075,user.getLanguage())%>:489*623)";
		tblTypeContentExtend.style.display="none";
		tblTypeContentCommon.style.display="";
		tblloginTemplateBgSetting.style.display = "none";
	} else if(t=="H"){
        tdTypeMsg.innerHTML="<%=SystemEnv.getHtmlLabelName(19074,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(19075,user.getLanguage())%>:1020*370)";
        tblTypeContentExtend.style.display="none";
        tblTypeContentCommon.style.display="";
        tblloginTemplateBgSetting.style.display = "none";
    } else if(t=="H2"){
        tdTypeMsg.innerHTML="<%=SystemEnv.getHtmlLabelName(19074,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(19075,user.getLanguage())%>:990*610)";
        tblTypeContentExtend.style.display="none";
        tblTypeContentCommon.style.display="";
        tblloginTemplateBgSetting.style.display = "";
	} else if(t=="site"){
		tdTypeMsg.innerHTML="<%=SystemEnv.getHtmlLabelName(20615,user.getLanguage())%>";
		tblTypeContentExtend.style.display="";
		tblTypeContentCommon.style.display="none";
		tblloginTemplateBgSetting.style.display = "none";
	}
}
function clearMenuType(o)
{	
	var menuType = document.getElementById("menuTypeId");
	var spanMenuType = document.getElementById("spanMenuTypeId");
	var tempMenuType = document.getElementById("tempMenuType");
	var mTypes = document.getElementById("menuType");
	menuType.value = "";
	spanMenuType.innerHTML = "";
	tempMenuType.value = o.value;
}

var index=<%=imageid2Size%>+1;
function addImg(){
   index++;
   var htmlstr="<div id='imgIndex"+index+"'><input class='inputstyle' type='file' name='imageId_"+index+"' value=''> <input type='button' style='width:45px;height: 24px;' onclick='delImg(this,"+index+")' value='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>'/></div>";
   jQuery("#addImgBtn").before(htmlstr);
}

function delImg(obj,index){
   var isDel=1;
   var imageid2temp=jQuery(obj).attr("imageid2temp");
   if(index&&imageid2temp){
      if(confirm("<%=SystemEnv.getHtmlLabelName(27748,user.getLanguage())%>")) //确认删除图片
         jQuery("#imgIndex"+index).remove();
      else
         isDel=0 ; 
   }
   
   if(isDel==1){
      var imageId2OldTemp=jQuery("#imageId2OldTemp").val();
      imageId2OldTemp=imageId2OldTemp.replace(imageid2temp,"");
      jQuery("#imageId2OldTemp").val(imageId2OldTemp);
      jQuery("#imgIndex"+index).remove();
   }
}
function checkRequired(){
	if($('select[name=modeid]').val() == 0){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30933,user.getLanguage())%>");
		return false;
	}
	return true;
}
function chageModeId(obj){
	if($('select[name=modeid]').val() == 0){
		$('#modeidRequired').show();
	}else{
		$('#modeidRequired').hide();
	}
}

</script>
<script language=vbs>
	sub onShowModes(input,span)
		id = window.showModalDialog("/systeminfo/template/loginTemplateBrowser.jsp")
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				span.innerHtml = "<a href='/page/maint/template/login/Edit.jsp?id="&id(0)&"' target='_blank'>" & id(1) &"</a>"
				input.value=id(0)
			else 
				span.innerHtml = " <IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
				input.value=""
			end if
		end if
	end sub
	sub onShowDocs(input,span)
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				span.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"' target='_blank'>" & id(1) &"</a>"
				input.value=id(0)
			else 
				span.innerHtml = ""
				input.value="0"
			end if
		end if
	end sub
	sub onShowMenus(input,span)
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/page/maint/menu/MenusBrowser.jsp?menutype=1")
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				if id(0) = "hp" Then
					span.innerHtml = "<a href='/homepage/maint/HomepageLocation.jsp' target='_blank'>" & id(1) &"</a>"
 				ElseIf id(0) = "sys" Then
					span.innerHtml = "<a href='/systeminfo/menuconfig/MenuMaintFrame.jsp?type="&id(0)&"' target='_blank'>" & id(1) &"</a>"
				else
					span.innerHtml = "<a href='/page/maint/menu/MenuEdit.jsp?id="&id(0)&"' target='_blank'>" & id(1) &"</a>"
			    end if 
				input.value=id(0)
			else 
				span.innerHtml = ""
				input.value="0"
			end if
		end if
	end sub

	sub onShowMenuTypes(input,span,menutype)
		menutype = menutype.value
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type="&menutype)
		menulink = ""
		if menutype = "element" then
			menulink = "ElementStyleEdit.jsp"
		ElseIf menutype = "menuh" Then
			menulink = "MenuStyleEditH.jsp"
		else
			menulink = "MenuStyleEditV.jsp"
		end if
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				span.innerHtml = "<a href='/page/maint/style/"&menulink&"?styleid="&id(0)&"&type="&menutype&"&from=list' target='_blank'>"&id(1)&"</a>"
				input.value=id(0)
			else 
				span.innerHtml = ""
				input.value="0"
			end if
		end if
	end sub
sub onShowLoginPages(input,span,eid)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/homepage/maint/LoginPageBrowser.jsp?menutype=1")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			span.innerHtml = "<a href='/homepage/LoginHomepage.jsp?hpid="&id(0)&"' target='_blank'>" & id(1) &"</a>"
			input.value="/homepage/LoginHomepage.jsp?hpid="&id(0)
		else 
			span.innerHtml = ""
			input.value=""
		end if
	end if
end sub

</script>
