
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>


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
String closeDialog = Util.null2String(request.getParameter("closeDialog"));
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String selectids = Util.null2String(request.getParameter("selectids"));

String _link="/systeminfo/BrowserMain.jsp?url=/homepage/maint/HomepageTabs.jsp?_fromURL=pageContent&menutype=2";
_link+="&infoId="+infoId+"&resourceId="+resourceId+"&resourceType="+resourceType+"&type="+type;

String openDialog=Util.null2String(request.getParameter("openDialog"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18772,user.getLanguage());
if(edit.equals("sub")){
	titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
}
String needfav ="1";
String needhelp ="";


int userid=0;
userid=user.getUID();

String linkAddress="",customName="",iconUrl="",topIconUrl="",customName_e="",customName_t="",selectedContent="",customModule="",customType="";
String topmenuname="";
String topname_e="";
String topname_t="";

int menuLevel=0;
int viewIndex = 0;


MenuUtil mu=new MenuUtil(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());
MenuMaint  mm=new MenuMaint(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());



MenuConfigBean mcb = mm.getMenuConfigBeanByInfoId(infoId);
String targetFrame="";
if(request.getParameter("id") != null){	//页面上查询选取高级菜单内容
	MenuInfoBean minfo = mm.getMenuInfoBean(String.valueOf(infoId));
	selectedContent = minfo.getSelectedContent();
	customModule=  String.valueOf(minfo.getFromModule());
	customType= String.valueOf(minfo.getMenuType());
}

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
	topmenuname = mcb.getTopMenuName();
	topname_e = mcb.getTopName_e();
	topname_t = mcb.getTopName_t();
//	if(mcb.getMenuInfoBean().getIsAdvance()==1)//高级模式菜单   bp:已无用，无需像7.0跳转页面
	//	response.sendRedirect("MenuMaintenanceEditAdvanced.jsp?type="+type+"&id="+infoId+"&resourceId="+resourceId+"&resourceType="+resourceType+"&edit="+edit+"&sync="+sync);
	
}

String navName = "";
if(type.equals("left")){
	navName =  SystemEnv.getHtmlLabelName(33675, user.getLanguage());
}else{
	navName =  SystemEnv.getHtmlLabelName(33676, user.getLanguage());
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>

<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="portal"/>
   <jsp:param name="navName" value="<%=navName %>"/> 
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ; 
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="160px">
				</td>
				<td class="rightSearchSpan"
					style="text-align: right; width: 500px !important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top"
						onclick="checkSubmit(this,event);" />
					&nbsp;&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>

<div class="zDialog_div_content">	
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="MenuMaintenanceOperation.jsp" enctype="multipart/form-data">
<input name="method" id="method" type="hidden" value="edit"/>
<input type="hidden" name="infoId" value="<%=infoId%>"/>
<input type="hidden" name="resourceId" value="<%=resourceId%>"/>
<input type="hidden" name="resourceType" value="<%=resourceType%>"/>
<input name="sync" type="hidden" value="<%=sync%>"/>
<input name="type" type="hidden" value="<%=type%>">
<input name="selectedContent" id="selectedContent" type="hidden" value="<%=selectedContent%>">
<input name="customModule" id="customModule" type="hidden" value="<%=customModule%>">
<input name="customType" id="customType" type="hidden" value="<%=customType%>">
<input name="subCompanyId" type="hidden" value="<%=subCompanyId%>">
<input name="openDialog" type="hidden" value="<%=openDialog%>">
<%-- 图标 --%>
<INPUT name="customIconUrl" type="hidden" value="<%=iconUrl%>">
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
	<wea:item type="groupHead">
	</wea:item>	
	 <wea:item>
       <%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%>
     </wea:item>
     <wea:item>
         
         <wea:required id="customMenuNamespan" required="">
         <INPUT class="InputStyle menuname" style="width:200px;" maxLength=50 name="customMenuName" id="customMenuName" value="<%=customName %>" onchange='checkinput("customMenuName","customMenuNamespan")'>
         </wea:required>
         <INPUT class="InputStyle menuname" style="width:200px;display:none" maxLength=50 id="customName_e" name="customName_e" value="<%=customName_e %>">
         <INPUT class="InputStyle menuname" style="width:200px;display:none" maxLength=50 id="customName_t" name="customName_t" value="<%=customName_t %>">
        
      </wea:item>
	   <%if(type.equals("left")){%>
      <wea:item><%=SystemEnv.getHtmlLabelName(33472,user.getLanguage())%></wea:item>
      <wea:item>
         
         <INPUT class="InputStyle topmenuname" style="width:200px;" maxLength=50 name="topMenuName" id="topMenuName" value="<%=topmenuname %>" >
         <INPUT class="InputStyle topmenuname" style="width:200px;display:none" maxLength=50 id="topName_e" name="topName_e" value="<%=topname_e %>">
         <INPUT class="InputStyle topmenuname" style="width:200px;display:none" maxLength=50 id="topName_t" name="topName_t" value="<%=topname_t %>">
      </wea:item>
     <%} %>
      <%if(edit.equals("sub")){%>
      <wea:item><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></wea:item>
      <wea:item>
      <div id="linktypeDiv">
     	<select name="changelinktype" style="width:85px;float:left;" id="changelinktype">
         	<option value="normal" <%if(mcb.getMenuInfoBean().getIsAdvance()!=1) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(18016,user.getLanguage())%></option>
         	<option value="advance" <%if(mcb.getMenuInfoBean().getIsAdvance()==1) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(19048,user.getLanguage())%></option>
         </select>
     	<INPUT class="InputStyle linktype" style="width:200px;float:left;" id="customMenuLink"  name="customMenuLink"  value=""  title="<%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%>">
     	<brow:browser viewType="0" name="brow_customMenuLink" browserValue='' 
							browserOnClick="" browserUrl="<%=_link%>" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="200px"
							 linkUrl="" 
							browserSpanValue="" _callback='doCallBack'></brow:browser>
		<SPAN>
      		<IMG title='<%=SystemEnv.getHtmlLabelName(20599,user.getLanguage())%>  "Http://"' src="/images/homepage/remind_wev8.png" align=absMiddle ></a>
      	</SPAN>
      </div>
	  </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%></wea:item>
      <wea:item>
      	<select  name="targetframe" style="width:85px;">
			<option value="" <%if("".equals(targetFrame)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%></option>
			<option value="_blank" <%if(!"".equals(targetFrame)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option>
		</select>
	  </wea:item>
	  <%} %>
      <wea:item><%=SystemEnv.getHtmlLabelName(20592,user.getLanguage())%>(16*16)</wea:item>
      <wea:item>
      		<brow:browser viewType="0" name="customIconUrl" browserValue="<%=iconUrl %>" 
							browserOnClick="" browserUrl="/docs/DocBrowserMain.jsp?url=/page/maint/common/CustomResourceMaint.jsp?isDialog=1" 
							hasInput="true" browserDialogWidth="850" isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
							
							browserSpanValue="<%=iconUrl %>" ></brow:browser>
      </wea:item>
      <%if(type.equals("left")){%>
      <wea:item><%=SystemEnv.getHtmlLabelName(33626,user.getLanguage())%>(32*32)</wea:item>
      <wea:item>
      			<brow:browser viewType="0" name="topIconUrl" browserValue="<%=topIconUrl %>" 
							browserOnClick="" browserUrl="/docs/DocBrowserMain.jsp?url=/page/maint/common/CustomResourceMaint.jsp?isDialog=1" 
							hasInput="true" browserDialogWidth="850" isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
							
							browserSpanValue="<%=topIconUrl %>" ></brow:browser>
	
      		
      </wea:item>
            
       
      <%}%>
     <%if(!"3".equals(resourceType)){%> 
     <wea:item>
        <%=SystemEnv.getHtmlLabelName(32333,user.getLanguage())%> 
      </wea:item>
       <wea:item>
           <select id="syncType" name='syncType' style="width:110px;float:left;">
               <option value='0'><%=SystemEnv.getHtmlLabelName(130439,user.getLanguage())%><!--不同步--></option> 
               <option value='1'><%=SystemEnv.getHtmlLabelName(130332,user.getLanguage())%><!--同步到下级分部--></option>
               <option value='2'><%=SystemEnv.getHtmlLabelName(130333,user.getLanguage())%><!--同步到指定分部--></option>
           </select>
            <div id="branchDiv" style="display:none;">
               <brow:browser viewType="0" name="syncBranch" browserValue="" 
               browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=" 
               hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
               completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
               browserSpanValue=""></brow:browser>
            </div>
       </wea:item>
      	<%}%>
	</wea:group>
</wea:layout>
<!--================================================================================-->	
</FORM>

</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
	    </td></tr>
	</table>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

</body>

<script LANGUAGE="JavaScript">
//检查上传的图片格式
$(document).ready(function(){ 
	 var _sp=$('#topIconUrl').parent().html();
	 
	$('#topIconUrl').live("change",function(){
		var _value=$(this).val();
		if(_value&&_value.length>0){
				var _hz=_value.substring(_value.lastIndexOf(".")).toLocaleLowerCase();
				if(_hz==".jpg"||_hz==".png"||_hz==".jpeg"||_hz==".gif"||_hz==".bmp"){
					//alert("是图片");
				}else{
					alert("<%=SystemEnv.getHtmlLabelName(32456,user.getLanguage())%>!");
					$('#topIconUrl').parent().html(_sp);
				}
		}
	});   
	 var _spcustomIconUrl=$('#customIconUrl').parent().html();
	$('#customIconUrl').live("change",function(){
		var _value=$(this).val();
		if(_value&&_value.length>0){
				var _hz=_value.substring(_value.lastIndexOf(".")).toLocaleLowerCase();
				if(_hz==".jpg"||_hz==".png"||_hz==".jpeg"||_hz==".gif"||_hz==".bmp"){
					//alert("是图片");
				}else{
					alert("<%=SystemEnv.getHtmlLabelName(32456,user.getLanguage())%>!");
					$('#customIconUrl').parent().html(_spcustomIconUrl);
				}
		}
	});   
});

function deleteMenu(obj){
	if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>?")){
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		location.href = "LeftMenuMaintenanceOperation.jsp?type=<%=type%>&method=del&infoId=<%=infoId%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=<%=sync%>";
		obj.disabled=true;
	}
}

function checkSubmit(obj){
	if(check_form(frmMain,'customMenuName')){
		frmMain.submit();
		obj.disabled=true;
	}
}

function doCheck_form(obj){
	if(check_form(frmMain,'customMenuName,customIconUrl')){
		frmMain.submit();
		obj.disabled=true;
	}
}

function onBack(obj){
	location.href="/page/maint/menu/SystemMenuMaintList.jsp?type=<%=type%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=<%=sync%>";
	obj.disabled=true;
}

function onIcoChange(obj){
	if(this.vlaue!='') spanShow.innerHTML="<img src='"+obj.value+"'>"
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

jQuery(document).ready(function(){
	resizeDialog(document);
	if("<%=closeDialog%>"=="close"){
		var parentWin = parent.getParentWindow(window); 
		if("<%=openDialog%>"=='front'){
          parentWin.location.href="/page/maint/menu/SystemMenuMaintList.jsp?openDialog=<%=openDialog%>&type=<%=type%>&isCustom=true&resourceType=3&resourceId=<%=user.getUID()%>&mode=visible&subCompanyId=null";
        }else{
		parentWin.location.href="/page/maint/menu/SystemMenuMaintList.jsp?type=<%=type%>&resourceType=<%=resourceType%>&resourceId=<%=resourceId%>&mode=visible&subCompanyId=<%=subCompanyId%>&opend=1&selectids=<%=selectids%>";
		}
		onCancel();
	}
	
	$("#changelang").bind("change",function(){
		$(".menuname").hide();
		if($(this).val()!="customMenuName"){
			$("#customMenuNamespan").hide();
		}else{
			$("#customMenuNamespan").show();
		}
		$("#"+$(this).val()).show();
	})
	
	$("#changetoplang").bind("change",function(){
		$(".topmenuname").hide();
		if($(this).val()!="customMenuName"){
			$("#topMenuNamespan").hide();
		}else{
			$("#topMenuNamespan").show();
		}
		$("#"+$(this).val()).show();
	})
	
	$("select").each(function(){
		//alert($(this).attr("sb"))
		$("#sbHolderSpan_"+$(this).attr("sb")).css("width",$(this).css("width"))
		$("#sbOptions_"+$(this).attr("sb")).css("width","100%");
		
	})
	
	$("#changelinktype").bind("change",function(){
		var id = $(this).val();
		$("#customMenuLink").val('');
		if(id=="normal"){
			$("#linktypeDiv .e8_os").hide();
			$("#customMenuLink").show();
			$("#selectedContent").val('');
			$("#customModule").val('');
			$("#customType").val('');
		}else{
			$("#linktypeDiv .e8_os").show();
			$("#customMenuLink").hide();
		}
	})
	var tmpUrl = '<%=linkAddress %>';
	<%if(mcb.getMenuInfoBean().getIsAdvance()==1) {%>
		$("#customMenuLink").hide();	
		$("#brow_customMenuLink").val(tmpUrl);
		$("#brow_customMenuLinkspan").html('<span class="e8_showNameClass"><a href="'+tmpUrl+'" title="'+tmpUrl+'" target="_blank">'+tmpUrl+'</a></span>');
	<%}else{%>
		$("#linktypeDiv .e8_os").hide();
	<%}%>
	$("#customMenuLink").val(tmpUrl);

	//同步分部
    $('#syncType').change(function(){
       var sync=$(this).val();
       if(sync==2){
           $("#branchDiv").show();
       }else if(sync==0||sync==1){
           $("#branchDiv").hide();
       }
    });
})

function doCallBack(event,datas,name,_callbackParams){
	var input = name.replace("brow_","")

	var infoId = '<%=infoId%>';
	if(infoId != null && infoId != '' && datas.sel != null && datas.sel != undefined ){
		var newUrl = $("#"+name).val() + infoId;
		$("#"+name).val(newUrl);
		$("#"+name+"span").html('<span class="e8_showNameClass"><a href="'+newUrl+'" onclick="return false;" title="'+newUrl+'">'+newUrl+'</a></span>');
		//重写browser的url跟显示，拼上infoid
		$("#selectedContent").val(datas.sel);
		$("#customModule").val(datas.module);
		$("#customType").val(datas.ctype);
	}else{
		$("#selectedContent").val('');
		$("#customModule").val('');
		$("#customType").val('');
	}
	$("#"+input).val($("#"+name).val());	
}
</script>




</html>

