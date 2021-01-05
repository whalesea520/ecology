
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="bean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="PortalDataSource" class="weaver.admincenter.homepage.PortalDataSource" scope="page"/>
<jsp:useBean id="SptmForSystemTemplate" class="weaver.splitepage.transform.SptmForSystemTemplate" scope="page"/>

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage());
String needfav ="1";
String needhelp ="";

if(!HrmUserVarify.checkUserRight("SystemTemplate:Edit", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String url="";
HashMap kv = (HashMap)pack.packageParams(request, HashMap.class);
String _fromURL = Util.null2String((String)kv.get("_fromURL"));
String loginview = Util.null2String((String)kv.get("loginview"));
String templateid = Util.null2String((String)kv.get("id"));
String type=  Util.null2String((String)kv.get("type"));
String subCompanyId = Util.null2String((String)kv.get("subCompanyId"));

String tempatename="";
String templateType = "";
String TemplateTitle = "";
int extendtempletid =0;
String ecology7themeid="";
String skin = "";
String isopen = "0";
String companyid= "";
boolean isSoft = false;
if(type.equals("add")&&templateid.equals("")){
	//templateid = "1";
	templateType="ecology8";
}

rs.executeSql("select * from SystemTemplate where id = "+templateid);
if(rs.next()){
	templateType = rs.getString("templateType");
	TemplateTitle = rs.getString("TemplateTitle");
	tempatename = rs.getString("TemplateName");
	extendtempletid = Util.getIntValue(rs.getString("extendtempletid"),0);
	ecology7themeid = rs.getString("ecology7themeid");
	skin = rs.getString("skin");
	isopen = rs.getString("isopen");
	companyid = rs.getString("companyid");
}

if("".equals(templateType)&&extendtempletid==0){
	templateType = "ecologyBasic";
	skin="default";
	isSoft = true;
}else if("".equals(templateType)&&extendtempletid==1){
	templateType = "ecologyBasic";
	skin="default";
}else if("".equals(templateType)&&extendtempletid==2){
	templateType = "custom";
	skin="default";
}else if("".equals(templateType)&&(extendtempletid==3||extendtempletid==-1)){
	templateType = "ecologyBasic";
	skin="default";
}

if(templateType.equals("ecology8")){
	url="/systeminfo/template/PortalTemplateE8Editor.jsp?init=true&subCompanyId="+subCompanyId+"&templateid="+templateid+"&skin="+skin+"&e="+new Date().getTime();	
}else if(templateType.equals("ecology7")){
	url="/systeminfo/template/PortalTemplateEditor.jsp?init=true&subCompanyId="+subCompanyId+"&templateid="+templateid+"&skin="+skin+"&e="+new Date().getTime();	
}else if(templateType.equals("ecologyBasic")){
	url= "/systeminfo/template/PortalTemplateBasicEditor.jsp?isSoft="+isSoft+"&subCompanyId="+subCompanyId+"&init=true&templateid="+templateid+"&skin="+skin;
}else if(templateType.equals("custom")){
	url= "/portal/plugin/homepage/webcustom/setting.jsp?isSoft="+isSoft+"&subCompanyId="+subCompanyId+"&init=true&templateid="+templateid+"&skin="+skin;
}else if(templateType.equals("office")){
	url= "/wui/theme/office/page/main.jsp?templateid="+templateid;
}

	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script src="/wui/theme/ecology8/jquery/plugin/plupload/js/plupload.full.min_wev8.js"></script>

<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>




</head>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="portal"/>
	   <jsp:param name="navName" value="<%=tempatename %>"/> 
	</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;*/
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doPreview()">
						<%
							if(isopen.equals("0")){
							%>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(32599,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSaveAndEnable()">
							<%	
							}
						%>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="dosubmit()">	
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSaveAs()">						
						<%
							//out.println(isopen+"+"+companyid);
							String canDel = SptmForSystemTemplate.getTemplateDel(isopen+"+"+companyid);
							if(canDel.equals("true")){
						%>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doDel()">						
						<%} %>
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
<div class="zDialog_div_content">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" style="table-layout: fixed;" >
	<tr>
		<td width="177px" style="background: #fafafa">
			<div id="themeList" style="overflow:hidden;position: relative;">
				<div>
				<div class="themetype">
					ecology8<%=SystemEnv.getHtmlLabelName(25025,user.getLanguage())%>
				</div>
				<%
					Map<String,String> para = new HashMap<String,String>();
					para.put("theme","ecology8");
					List ecology8List = PortalDataSource.getEcology7Theme(user,para,request,response);
					for(int i=0;i<ecology8List.size();i++){
						Map<String,String> theme8 = (Map<String,String>)ecology8List.get(i);
						%>
						<div class="themeitem" type="ecology8" skin="<%=theme8.get("id") %>" extendtempletid="0" title="<%=theme8.get("name") %>">
							<div class="themeindex">
								<%=i+1 %>
							</div>
							<div class="themeimg">
							<%
								out.println(theme8.get("div"));
							%>
							</div>
							<div style="clear: both;"></div>
						</div>
						<%
						
					}
				%>
				<div class="themetype">
					ecology7<%=SystemEnv.getHtmlLabelName(25025,user.getLanguage())%>
				</div>
				<%
					
					para.put("theme","ecology7");
					ecology8List = PortalDataSource.getEcology7Theme(user,para,request,response);
					for(int i=0;i<ecology8List.size();i++){
						Map<String,String> theme7 = (Map<String,String>)ecology8List.get(i);
						%>
						<div class="themeitem" type="ecology7" skin="<%=theme7.get("id") %>" extendtempletid="0" title="<%=theme7.get("name") %>">
							<div class="themeindex">
								<%=i+1 %>
							</div>
							<div class="themeimg" >
								<img style="padding-top:5px;padding-left: 5px;" width="118px" height="68px" src="<%=theme7.get("preview") %>">
							
							</div>
							<div style="clear: both;"></div>
						</div>
						<%
						
					}
				%>
				</div>
				
				<div class="themetype">
					ecologyBasic<%=SystemEnv.getHtmlLabelName(25025,user.getLanguage())%>
				</div>
				<%
					
					para.put("theme","ecologyBasic");
					ecology8List = PortalDataSource.getEcology7Theme(user,para,request,response);
					for(int i=0;i<ecology8List.size();i++){
						Map<String,String> theme7 = (Map<String,String>)ecology8List.get(i);
						%>
						<div class="themeitem" type="ecologyBasic" skin="<%=theme7.get("id") %>" extendtempletid="0" title="<%=theme7.get("name") %>">
							<div class="themeindex">
								<%=i+1 %>
							</div>
							<div class="themeimg" >
								<img style="padding-top:5px;padding-left: 5px;" width="118px" height="68px" src="<%=theme7.get("preview") %>">
							
							</div>
							<div style="clear: both;"></div>
						</div>
						<%
						
					}
				%>
				<%
					
					para.put("theme","office");
					ecology8List = PortalDataSource.getEcology7Theme(user,para,request,response);
				
					if(ecology8List!=null&&ecology8List.size()>0){
					%>
					<div class="themetype">
					office<%=SystemEnv.getHtmlLabelName(25025,user.getLanguage())%>
					</div>
					
					<%
					
					
					for(int i=0;i<ecology8List.size();i++){
						Map<String,String> theme7 = (Map<String,String>)ecology8List.get(i);
						%>
						<div class="themeitem" type=office skin="<%=theme7.get("id") %>" extendtempletid="0" title="<%=theme7.get("name") %>">
							<div class="themeindex">
								<%=i+1 %>
							</div>
							<div class="themeimg" >
								<img style="padding-top:5px;padding-left: 5px;" width="118px" height="68px" src="<%=theme7.get("preview") %>">
							
							</div>
							<div style="clear: both;"></div>
						</div>
						<%
						
					}
				%>
				<%
					}
				%>
					<%
				String canCustom = bean.getPropValue("page","portal.custom");
				if("true".equals(canCustom)){
					%>
					<div class="themetype">
						<%=SystemEnv.getHtmlLabelName(33809,user.getLanguage())%>
					</div>
					<div class="themeitem" type="custom"  skin="default" extendtempletid="2" title="">
							<div class="themeindex">
								1
							</div>
							<div class="themeimg" >
								<img style="padding-top:5px;padding-left: 5px;" width="118px" height="68px" src="/images/ecology8/homepage/custemplate_wev8.png">
							
							</div>
							<div style="clear: both;"></div>
					</div>
					<%
					
				}
				%>
				</div>
				
			</div>
		</td>
		<td width="">
			<iframe style='' onload="update();" src="<%=url %>&init=true" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" ></iframe>
		</td>
	</tr>
</table>
	
</div>
</body>
<style type="text/css">
	#themeList{
		padding-left: 10px;
		padding-right: 10px;
	}
	.themetype{
		border-bottom: 1px solid #cbcbcb;
		color: #7d7d7d;
		height: 30px;
		line-height: 40px;
		
	}
	
	.themeitem{
		margin-top: 10px;
		cursor: pointer;
	}
	.themeindex{
		float: left;
		height: 78px;
		line-height: 78px;
		width: 20px;
		text-align: center;
		color:#ffffff;
		background: url(/wui/theme/ecology8/page/images/themeedit/index_wev8.png) center center no-repeat;
		
	}
	
	.themeindexOver{
		
		background: url(/wui/theme/ecology8/page/images/themeedit/indexOver_wev8.png) center center no-repeat!important;
		
	}
		
	.themeimg{
		float:right;
		position: relative;
		height: 78px;
		border: 1px solid #d7d7d8;
		width: 128px;
	}
	
	.themeimgOver{
	
		border: 1px solid #3a93fe!important;
		
	}
</style>
</style>

<div id="saveAsTable" style="display:none">
	<table id="saveAsTable1" name="saveAsTable" width="100%" style="margin-top:30px">
	<tr>
		<td width="60px" style="padding-left:30px">
			<%=SystemEnv.getHtmlLabelName(28050,user.getLanguage()) %>:
		</td>
		<td>
			<input type="text" class="inputstyle styled input" name="saveAsName" id ="saveAsName" style="width:90% !important" onchange="checkinput('saveAsName','saveAsNameSpan')">
			
          <span id="saveAsNameSpan"><img src="/images/BacoError_wev8.gif" align="absMiddle"></span></td>
		
	</tr>
</table>
</div>
</html>

<script language="javascript">
jQuery(function(){
   	
   	//皮肤项缩略效果
	$(".themeimg").find("span:first").css("width","121px")
   
   	$("#themeList").css("height",document.body.clientHeight-60)
    $("#themeList").perfectScrollbar();
    $("td").each(function(){
   		$(this).height($(this).parent().height());
   	})
   	
    $(".themeitem[type='<%=templateType%>'][skin='<%=skin%>']").find(".themeimg").addClass("themeimgOver");
    $(".themeitem[type='<%=templateType%>'][skin='<%=skin%>']").find(".themeindex").addClass("themeindexOver");
    var top = $(".themeitem[type='<%=templateType%>'][skin='<%=skin%>']").offset().top;
  
    $("#themeList").scrollTop(top);
	$("#themeList").perfectScrollbar('update');
	
    $(".themeitem").bind("click",function(){
    	$(".themeindexOver").removeClass("themeindexOver");
    	$(".themeimgOver").removeClass("themeimgOver");
    	$(this).find(".themeimg").addClass("themeimgOver");
    	$(this).find(".themeindex").addClass("themeindexOver");
    
    	var type= $(this).attr("type");
    	var skin = $(this).attr("skin");
    	var extendtempletid = $(this).attr("extendtempletid")
    	var url = "<%=url %>";
    	
    	if(type=="ecologyBasic"){
    		url = "/systeminfo/template/PortalTemplateBasicEditor.jsp?subCompanyId=<%=subCompanyId%>&templateid=<%=templateid%>&skin="+skin+"&e="+new Date().getTime();
    	}else if(type=="ecology8"){
    		url = "/systeminfo/template/PortalTemplateE8Editor.jsp?subCompanyId=<%=subCompanyId%>&templateid=<%=templateid%>&skin="+skin;
    	}else if(type=="ecology7"){
    		url= "/systeminfo/template/PortalTemplateEditor.jsp?subCompanyId=<%=subCompanyId%>&templateid=<%=templateid%>&skin="+skin;
    		
    	}else if(type=="custom"){
    		url= "/portal/plugin/homepage/webcustom/setting.jsp?templateid=<%=templateid%>&subCompanyId=<%=subCompanyId%>"
    	}
    	else if(type=="office"){
    		url= "/wui/theme/office/page/main.jsp"
    	}
    	
    	$.post("/systeminfo/template/SystemTemplateTempOperation.jsp",
		{method:'update',tbname:'SystemTemplate',field:'extendtempletid',value:extendtempletid},
		function(){
			
		});
		
		$.post("/systeminfo/template/SystemTemplateTempOperation.jsp",
		{method:'update',tbname:'SystemTemplate',field:'templatetype',value:$(this).attr('type')},
		function(){
			$("#tabcontentframe").attr("src",url)
		});

    });
    
    
    
    $("#templateTitle").click(
		 function(){
		 	$(this).hide();
		 	$("#templateTitleEditor").show();
		 }
	); 
	$("#templateTitle").hover(
		function(){jQuery(this).css({"border":"1px dashed red","cursor":"pointer"})},
		function(){jQuery(this).css({"border":"0","cursor":"normal"})}
	)
	
    $(".templateType[type='<%=templateType%>']").addClass("select");
    
    $("#templateTitleEditor").find("input").bind("blur",function(){
    	$this = $(this);
    	if($this.val()!=$("#templateTitle").text()){
    		$.get("/systeminfo/template/SystemTemplateTempOperation.jsp",{method:'update',tbname:'SystemTemplate',field:'TemplateTitle',value:$(this).val()},function(){
			
			});
    	}
    	$("#templateTitle").text($this.val())
		$("#templateTitleEditor").hide();
		$("#templateTitle").show();
    	
    });
    
    $("#templatename").bind("change",function(){
    	$this = $(this);
    	$.post("/systeminfo/template/SystemTemplateTempOperation.jsp",{method:'update',tbname:'SystemTemplate',field:'TemplateName',value:$this.val()},function(){
			
		});
    });
    
   $("#changeSubType").bind("change",function(){
   		var type = $(this).val();
   		if(type==0){
   			$("#subCompanySpan").hide();
   			$("#subCompanyid").val("0");
   			$("#subCompanyidspan").text("");
   		}else{
   			$("#subCompanySpan").show();
   		}
   })
});

function showBaseInfo(){
	$("#baseInfo").parent().show();
	$("#baseInfo").show();
	$("#typeInfo").hide();
	$("#winTitle").show();
}

	
function showStyleInfo(){
	$("#baseInfo").parent().show();
	$("#baseInfo").hide();
	$("#typeInfo").show();
	$("#winTitle").show();
	
}

function refreshTab(){
	var f = window.parent.oTd1.style.display;
	if (f != null) {
		if(f==''){
			window.parent.oTd1.style.display='none';
		}else{ 
			window.parent.oTd1.style.display='';
			window.parent.wfleftFrame.setHeight();
		}
	}
}

function doDel(){
    	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			$.post("/systeminfo/template/templateOperation.jsp",
			{operationType:'delete',templateid:'<%=templateid%>'},
			function(){
				top.getDialog(window).currentWindow.document.location.reload();
				dialog = top.getDialog(window);
				dialog.close();
			});
		})
}
    
function doPreview(){
	
	url = '/systeminfo/template/templatePreview.jsp?from=edit&id=<%=templateid%>&subcompanyId=<%=subCompanyId%>';
 	var title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>"; 
 	showDialogMax(title,url,700,500,true);
}

function doSaveAs(){
	
	
	var url = "/systeminfo/template/templateSaveAs.jsp?from=edit&id=<%=templateid%>";
 	
	var menuStyle_dialog = new window.top.Dialog();
	menuStyle_dialog.currentWindow = window;   //传入当前window
 	menuStyle_dialog.Width = 350;
 	menuStyle_dialog.Height = 50;
 	menuStyle_dialog.maxiumnable=false;
 	menuStyle_dialog.Modal = true;
 	menuStyle_dialog.Title = "<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"; 
 	menuStyle_dialog.URL =url;
 	menuStyle_dialog.show();
 	
 	/*
	var menuStyle_dialog = new window.top.Dialog();
	menuStyle_dialog.currentWindow = window;   //传入当前window
 	menuStyle_dialog.Width = 350;
 	menuStyle_dialog.Height = 50;
 	menuStyle_dialog.maxiumnable=false;
 	menuStyle_dialog.Modal = true;
 	menuStyle_dialog.Title = "<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"; 
 	menuStyle_dialog.InnerHtml =$("#saveAsTable").html()
 	
 	menuStyle_dialog.ShowButtonRow = true;
 	menuStyle_dialog.OKEvent =function(){
 		var saveAsName = $(menuStyle_dialog.getDialogDiv()).find("#saveAsName").val()
 		
 		$("#saveAsName").val(saveAsName)
 		if($.trim(saveAsName)!=""){
 			$.post("/systeminfo/template/templateOperation.jsp",
			{operationType:'saveAs',saveAsName:saveAsName,from:'edit',subCompanyId:'<%=subCompanyId%>',templateid:'<%=templateid%>'},
			function(){
				menuStyle_dialog.close();
				top.getDialog(window).currentWindow.document.location.reload();
				dialog = top.getDialog(window);
				dialog.close();
			});
 			
 		}
 	}
 	menuStyle_dialog.CancelEvent =function(){
 		menuStyle_dialog.close();
 		$("#saveAsName").val("");
 	}
 	menuStyle_dialog.show();
 	*/
}


function showDialogMax(title,url,width,height,showMax){
	var Show_dialog = new window.top.Dialog();
	Show_dialog.currentWindow = window;   //传入当前window
 	Show_dialog.Width = width;
 	Show_dialog.Height = height;
 	Show_dialog.maxiumnable = showMax;
 	Show_dialog.Modal = true;
 	Show_dialog.DefaultMax = true;
 	Show_dialog.Title = title;
 	Show_dialog.URL = url;
 	Show_dialog.show();
}

function dosubmit(){
	var templatetype = $(".themeindexOver").parent().attr("type")
	var skin = $(".themeindexOver").parent().attr("skin")
	$this = $(this);
	$.post("/systeminfo/template/SystemTemplateTempOperation.jsp",
		{method:'commit',id:<%=templateid%>},
		function(){
			$("#tabcontentframe").attr("src",url)
	});
   	$.post("/systeminfo/template/PortalTemplateOperation.jsp",{method:'updateThemeInfo',templatetype:templatetype,skin:skin,id:<%=templateid%>},function(){
		var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
		dialog.close();
	});
}


function doSaveAndEnable(){
	var templatetype = $(".themeindexOver").parent().attr("type")
	var skin = $(".themeindexOver").parent().attr("skin")
	$this = $(this);
	$.post("/systeminfo/template/SystemTemplateTempOperation.jsp",
		{method:'commit',id:<%=templateid%>},
		function(){
			$("#tabcontentframe").attr("src",url)
	});
   	$.post("/systeminfo/template/PortalTemplateOperation.jsp",{method:'updateThemeInfoandenable',templatetype:templatetype,skin:skin,id:<%=templateid%>},function(){
		top.getDialog(window).currentWindow.document.location.reload();
		
		var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
		dialog.close();
	});
}



function getLoginTemplateName(){
	return $("#templatename").val();
}
</script>

<style>
	.templateType{
		position:absolute;
		height:75px;
		width:125px;
		top:5px;
		text-align:center;
		cursor:pointer;
		padding:3px;
	}
	
	.select{
		background:#2690e3;
	}
	
	#templateTitle{
		cursor:text;
	}
</style>