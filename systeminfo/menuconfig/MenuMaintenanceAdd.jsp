
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.general.GCONST" %>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%
//if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
//    response.sendRedirect("/notice/noright.jsp");
//    return;
//}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
String needfav ="1";
String needhelp ="";    

int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
String type = Util.null2String(request.getParameter("type"));
String closeDialog = Util.null2String(request.getParameter("closeDialog"));
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String selectids = Util.null2String(request.getParameter("selectids"));
int infoId = Util.getIntValue(request.getParameter("id"),0);
int userid=0;
userid=user.getUID();
String navName = "";
if(type.equals("left")){
	navName =  SystemEnv.getHtmlLabelName(33675, user.getLanguage());
}else{
	navName =  SystemEnv.getHtmlLabelName(33676, user.getLanguage());
}
String isclose = Util.null2String(request.getParameter("isclose"));

String openDialog=request.getParameter("openDialog");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
	
	<script type="text/javascript">
	var parentWin = parent.getParentWindow(window);
	var dialog = parent.getDialog(window);
	if("<%=isclose%>"=="1"){
		var url = "";
		if(parentWin.refreshDialog){
			url += "&isdialog=1";
		}
		parentWin.location = url;
		parentWin.closeDialog();	
	}
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>

  </head>
  
  <body  width="100%">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="portal"/>
   <jsp:param name="navName" value="<%=navName %>"/> 
</jsp:include>

  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this,event),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;

 /* if("left".equals(type)){
 	 RCMenu += "{"+SystemEnv.getHtmlLabelName(19048,user.getLanguage())+",javascript:onAdvanced(this),_self} " ;
  	 RCMenuHeight += RCMenuHeightStep ;
  }
*/
  %>
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="160px">
				</td>
				<td class="rightSearchSpan"
					style="text-align: right; width: 500px !important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top"
						onclick="checkSubmit(this,event);" />
					&nbsp;&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>

	<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/systeminfo/menuconfig/MenuMaintenanceOperation.jsp" enctype="multipart/form-data">
	<input name="method" type="hidden" value="add"/>
	<input name="resourceId" type="hidden" value="<%=resourceId%>">
	<input name="resourceType" type="hidden" value="<%=resourceType%>">
	<input name="parentId" type="hidden" value="<%=infoId%>"/>
	<input name="type" type="hidden" value="<%=type%>">
	<input name="subCompanyId" type="hidden" value="<%=subCompanyId%>">
	<input name="selectedContent" id="selectedContent" type="hidden" value="">
	<input name="customModule" id="customModule" type="hidden" value="">
	<input name="customType" id="customType" type="hidden" value="">
	<input name="openDialog"  type="hidden" value="<%=openDialog%>">
	<%-- 图标 --%>
	<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
	<wea:item type="groupHead">
	</wea:item>	
	<wea:item><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%></wea:item>
      <wea:item>
        
         
         <wea:required id="customMenuNamespan" required="true">
         <INPUT class="InputStyle menuname" style="width:200px;" maxLength=50 name="customMenuName" id="customMenuName" value="" onchange='checkinput("customMenuName","customMenuNamespan")'>
         <INPUT class="InputStyle menuname" style="width:200px;display:none" maxLength=50 id="customName_e" name="customName_e" value="" onchange='checkinput("customName_e","customMenuNamespan")'>
         <INPUT class="InputStyle menuname" style="width:200px;display:none" maxLength=50 id="customName_t" name="customName_t" value="" onchange='checkinput("customName_t","customMenuNamespan")'>
         </wea:required>
         
        
      </wea:item>
      <%if(type.equals("left")){ %>
      <wea:item><%=SystemEnv.getHtmlLabelName(33472,user.getLanguage())%></wea:item>
      <wea:item>
        
         <INPUT class="InputStyle topmenuname" style="width:200px;" maxLength=50 name="topMenuName" id="topMenuName" value="" >
         <INPUT class="InputStyle topmenuname" style="width:200px;display:none" maxLength=50 id="topName_e" name="topName_e" value="">
         <INPUT class="InputStyle topmenuname" style="width:200px;display:none" maxLength=50 id="topName_t" name="topName_t" value="">
      </wea:item>
     <%} %>
     
     
			              	
	   <wea:item><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></wea:item>
      <wea:item>
      	<div id="linktypeDiv">
      	<select name="changelinktype" style="width:85px;float:left;" id="changelinktype">
         	<option value="normal"><%=SystemEnv.getHtmlLabelName(18016,user.getLanguage())%></option>
         	<option value="advance"><%=SystemEnv.getHtmlLabelName(19048,user.getLanguage())%></option>
         </select>
     	<INPUT class="InputStyle linktype" style="width:200px;float:left;" id="customMenuLink" name="customMenuLink" value="" title="<%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%>">
     	<brow:browser viewType="0" name="brow_customMenuLink" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/homepage/maint/HomepageTabs.jsp?_fromURL=pageContent&menutype=2" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="200px"
							 linkUrl="/systeminfo/BrowserMain.jsp?url=/homepage/maint/LoginPageBrowser.jsp?menutype=2" 
							browserSpanValue="" _callback='doCallBack'></brow:browser>
		<SPAN>
      		<IMG title='<%=SystemEnv.getHtmlLabelName(20599,user.getLanguage())%>  "Http://"' src="/images/homepage/remind_wev8.png" align=absMiddle ></a>
      	</SPAN>
		</div>	              	
	  </wea:item>     
   
      <wea:item><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%></wea:item>
      <wea:item>
      	<select  name="targetframe" style="width:85px;">
			<option value="" selected><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%></option>
			<option value="_blank"><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option>
		</select>
	  </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(20592,user.getLanguage())%>(16*16)</wea:item>
      <wea:item>
      		<brow:browser viewType="0" name="customIconUrl" browserValue="" 
							browserOnClick="" browserUrl="/docs/DocBrowserMain.jsp?url=/page/maint/common/CustomResourceMaint.jsp?isDialog=1" 
							hasInput="true" browserDialogWidth="850" isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
							
							browserSpanValue="" ></brow:browser>
      </wea:item>
      <%if(type.equals("left")){%>
      <wea:item><%=SystemEnv.getHtmlLabelName(33626,user.getLanguage())%>(32*32)</wea:item>
      <wea:item>
      			<brow:browser viewType="0" name="topIconUrl" browserValue="" 
							browserOnClick="" browserUrl="/docs/DocBrowserMain.jsp?url=/page/maint/common/CustomResourceMaint.jsp?isDialog=1" 
							hasInput="true" browserDialogWidth="850" isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
							
							browserSpanValue="" ></brow:browser>
	
      		
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
				
                
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
</div>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</body>

<script LANGUAGE="JavaScript">

function doCallBack(event,datas,name,_callbackParams){
	var input = name.replace("brow_","");

	if( datas.sel != null && datas.sel != undefined ){
		//重写browser的url跟显示，拼上infoid
		$("#selectedContent").val(datas.sel);
		$("#customModule").val(datas.module);
		$("#customType").val(datas.ctype);
	}else{
		$("#selectedContent").val('');
		$("#customModule").val('');
		$("#customType").val('');
	}
	$("#"+input).val($("#"+name).val())
}


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
	location.href="/page/maint/menu/SystemMenuMaintList.jsp?type=<%=type%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>";
	obj.disabled=true;
}

function onAdvanced(obj){
	location.href="MenuMaintenanceAddAdvanced.jsp?type=<%=type%>&id=<%=infoId%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>";
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
		if($("#"+$(this).val()).val()!=""){
			$("#customMenuNamespan").html("");
		}else{
			$("#customMenuNamespan").html("<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle />");
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
		if(id=="normal"){
			$("#linktypeDiv .e8_os").hide();
			$("#customMenuLink").show();
		}else{
			$("#linktypeDiv .e8_os").show();
			$("#customMenuLink").hide();
		}
	})
	$("#linktypeDiv .e8_os").hide();
	//同步分部
	$('#syncType').change(function(){
	   var sync=$(this).val();
	   if(sync==2){
	       $("#branchDiv").show();
	   }else if(sync==0||sync==1){
	       $("#branchDiv").hide();
	   }
	});
});

</script>
</html>

