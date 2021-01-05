
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page import="weaver.page.maint.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="su" class="weaver.page.style.StyleUtil" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />


<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<%
String styleid =Util.null2String(request.getParameter("styleid"));	
String type = Util.null2String(request.getParameter("type"));
String message = Util.null2String(request.getParameter("message"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22915,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";

StyleMaint sm=new StyleMaint(user);
%>



<html>
 <head>
	<!--Base Css And Js-->
   	<script>
 		var styleid= '<%=styleid%>';
 	</script>
	<!--Base Css And Js-->
   	<link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
	<link href="/page/maint/style/common_wev8.css" type="text/css" rel=stylesheet>
	<link href="/js/jquery/plugins/menu/menuh/menuh_wev8.css" type="text/css" rel=stylesheet>


	<!--For Menu-->
	<SCRIPT language="javascript" src="/js/jquery/plugins/menu/menuh/menuh_wev8.js"></script>

	 <!--For Corner-->
	<SCRIPT type="text/javascript" src="/js/jquery/plugins/corner/jquery.corner_wev8.js"></script>

	<!--For Jquery UI-->
	<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>
	<script type="text/javascript" src="/js/jquery/ui/ui.core_wev8.js"></script>

	<!--For Tab-->
	<SCRIPT language="javascript" src="/js/jquery/ui/ui.tabs_wev8.js"></script>
	
	<!--For Dialog-->
	<script type="text/javascript" src="/js/jquery/ui/ui.draggable_wev8.js"></script>
    <script type="text/javascript" src="/js/jquery/ui/ui.resizable_wev8.js"></script>
    <script type="text/javascript" src="/js/jquery/ui/ui.dialog_wev8.js"></script>



	<!--For Spin Button-->
	<SCRIPT type="text/javascript" src="/js/jquery/plugins/spin/jquery.spin_wev8.js"></script>	

	<!--For File Browser Tree-->
	<SCRIPT type="text/javascript" src="/js/jquery/plugins/filetree/jquery.filetree_wev8.js"></script>	
	
	<link rel="stylesheet" href="/js/ecology8/spectrum/spectrum_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/spectrum/spectrum_wev8.js"></script>
	
	<!--common js-->

	<style id="styleMenu" type="text/css" title="styleMenu">
		<%=mvsc.getCss(styleid)%>
	</style>
	
	
	<style>
	#tab{
		border-bottom: 1px solid #bfc8d6;
		height: 36px;
		margin-bottom: 15px;
		background: #fbfefe;
	}
	
	.tab li{
		float: left;
		width: 112px;
		height: 36px;
		line-height:36px;
		color:#7683a0;
		background: #eff3f7;
		text-align: center;
		list-style: none;
		font-size:14px;
		cursor: pointer;
		
		
		
	}
	.selected{
		background:#ffffff;
		border-top: 2px solid #00a7ff;
	}
	table {
		background: #ebeef0;
	}
	
	.spin{
		width: 25px!important;
	}
</style>
	
 </head>
<body  id="myBody">
<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=Util.toHtml5(mvsc.getTitle(styleid))%>"/> 
		</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
    
	if(!"template".equals(styleid)){
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDel(this),_self} " ;
    	RCMenuHeight += RCMenuHeightStep ;
    }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>	
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="onSave(this);">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="onDel(this);">
						
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>		
		
<form id="frmEdit" name="frmEdit" method="post" action="StyleOprate.jsp">
<input type="hidden" id="styleid" name="styleid" value="<%=styleid%>">
<input type="hidden" id="type" name="type" value="<%=type%>">
<input type="hidden" id="method" name="method" value="edit">
<%
	String msg =Util.null2String(request.getParameter("msg"));
	
	%>

<TABLE width=100% height=100% border="0" cellspacing="0">
    <colgroup>
    
    <tr>
      
        <td valign="top">
			<table class="Shadow">
				
				<tr>
					<td valign="top">
								<textarea style="width:90%;height:200px;display:none" id="css" name="css"></textarea>
								<textarea style="width:90%;height:200px;display:none" id="cssBak" name="cssBak">
									<%=mvsc.getCss(styleid)%>
								</textarea>
								<div style="width:50%;float:left;background: #fbfefe;border-right: 1px solid #bec7d7">
									<div style="margin-left:30px;padding-top: 15px;color:#5f708d">
										<div style="margin-bottom: 5px; color:#5f708d">
											<span><%=SystemEnv.getHtmlLabelName(19621,user.getLanguage())%></span>
											<span style="padding-left:15px;">
												<input type="input" name="title" value="<%=Util.toHtml5(mvsc.getTitle(styleid))%>" style="width:200px;" class="" onchange='checkinput("title","titlespan")'>	
												<input type="hidden" name="oldtitle" value="<%=Util.toHtml5(mvsc.getTitle(styleid))%>">	
												<SPAN id=titlespan>
									               <IMG src="/images/BacoError_wev8.gif" align=absMiddle style="display:none">
									             </SPAN>	
											</span>
												<%
										     	if(!"".equals(msg)){
										    		out.println("<span style='color:red'>"+SystemEnv.getHtmlLabelName(19640,user.getLanguage())+"</span>");
										    	}
										     	%>
										</div>
										<div>
											<span><%=SystemEnv.getHtmlLabelName(19622,user.getLanguage())%></span>
											<span style="padding-left:15px;">
												<input type="input"  name="desc"  value="<%=Util.toHtml5(mvsc.getDesc(styleid))%>"  style="width:200px" class="">
											</span>
											
										</div>
										
									</div>
									
									
									<div id="tab" style="margin-top:15px;">
										<ul class="tab">											
											<li class="selected" href="#fragment-2"><span><%=SystemEnv.getHtmlLabelName(17597,user.getLanguage())%><!--主菜单--></span></li>
											<li class="" href="#fragment-3"><span><%=SystemEnv.getHtmlLabelName(17613,user.getLanguage())%><!--子菜单--></span></li>
										</ul>	
									</div>
									
									<%
										String style="color:#676767;font-style:normal;font-size:12px;text-decoration:none;";
									%>
												
										<div id="fragment-2">	
										
											<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='rule2_color' class='colorblock'  r_id='rule2' r_attr='color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16197,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='spin height' type='text'  r_id='rule2' r_attr='font-size'>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='inputstyle_1 height' type='text'    r_id='rule2' r_attr='font-family'>   <IMG  onclick="setFont(this,'rule2')" style='PADDING-BOTTOM: 0px; MARGIN: 0px 0px 0px 5px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; CURSOR: pointer; PADDING-TOP: 0px'  src='/images/ecology8/request/search-input_wev8.png'   width=13 height=14 >
											</wea:item>
										
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(1014,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(23002,user.getLanguage()) %><input type='checkbox' r_id='rule2' r_attr='font-weight' class='font-weight'>	
												<%=SystemEnv.getHtmlLabelName(23003,user.getLanguage()) %><input type='checkbox' r_id='rule2' r_attr='font-style' class='font-style' >	
								
											</wea:item>
										</wea:group>
									</wea:layout>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22978,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='rule5_color' class='colorblock'  r_id='rule5' r_attr='color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16197,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='spin height' type='text'  r_id='rule5' r_attr='font-size'>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='inputstyle_1 height' type='text'    r_id='rule5' r_attr='font-family'>   <IMG  onclick="setFont(this,'rule5')" style='PADDING-BOTTOM: 0px; MARGIN: 0px 0px 0px 5px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; CURSOR: pointer; PADDING-TOP: 0px'  src='/images/ecology8/request/search-input_wev8.png'   width=13 height=14 >
											</wea:item>
											
											
										</wea:group>
										
									</wea:layout>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22989,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='rule1_bgcolor' class='colorblock'  r_id='rule1' r_attr='background-color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %>
											</wea:item>
							
											<wea:item>
												<input class='filetree'  r_id='rule1' r_attr='background-image'>
											</wea:item>
										</wea:group>
									</wea:layout>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22990,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='rule4_bgcolor' class='colorblock'  r_id='rule4' r_attr='background-color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %>
											</wea:item>
							
											<wea:item>
												<input class='filetree'  r_id='rule4' r_attr='background-image'>
											</wea:item>
										</wea:group>
									</wea:layout>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(25292,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='rule0_bgcolor' class='colorblock'  r_id='rule0' r_attr='background-color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %>
											</wea:item>
							
											<wea:item>
												<input class='filetree'  r_id='rule0' r_attr='background-image'>
											</wea:item>
										</wea:group>
									</wea:layout>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(25293,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='rule3_bgcolor' class='colorblock'  r_id='rule3' r_attr='background-color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %>
											</wea:item>
							
											<wea:item>
												<input class='filetree'  r_id='rule3' r_attr='background-image'>
											</wea:item>
										</wea:group>
									</wea:layout>
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(811,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(22991,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input class='filetree'  r_id='rule8' r_attr='background-image' name="iconCollapsedMain">
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(22992,user.getLanguage()) %>
											</wea:item>
							
											<wea:item>
												<input class='filetree'  r_id='rule2' r_attr='background-image' name="iconExpandMain">
											</wea:item>
										</wea:group>
									</wea:layout>
											
									</div>

										
									<div id="fragment-3" >	
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='rule6_color' class='colorblock'  r_id='rule6' r_attr='color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16197,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='spin height' type='text'  r_id='rule6' r_attr='font-size'>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='inputstyle_1 height' type='text'    r_id='rule6' r_attr='font-family'>   <IMG  onclick="setFont(this,'rule6')" style='PADDING-BOTTOM: 0px; MARGIN: 0px 0px 0px 5px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; CURSOR: pointer; PADDING-TOP: 0px'  src='/images/ecology8/request/search-input_wev8.png'   width=13 height=14 >
											</wea:item>
										
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(1014,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(23002,user.getLanguage()) %><input type='checkbox' r_id='rule6' r_attr='font-weight' class='font-weight'>	
												<%=SystemEnv.getHtmlLabelName(23003,user.getLanguage()) %><input type='checkbox' r_id='rule6' r_attr='font-style' class='font-style' >	
								
											</wea:item>
										</wea:group>
									</wea:layout>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22978,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='rule7_color' class='colorblock'  r_id='rule7' r_attr='color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16197,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='spin height' type='text'  r_id='rule7' r_attr='font-size'>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='inputstyle_1 height' type='text'    r_id='rule7' r_attr='font-family'>   <IMG  onclick="setFont(this,'rule7')" style='PADDING-BOTTOM: 0px; MARGIN: 0px 0px 0px 5px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; CURSOR: pointer; PADDING-TOP: 0px'  src='/images/ecology8/request/search-input_wev8.png'   width=13 height=14 >
											</wea:item>
											
											
										</wea:group>
										
									</wea:layout>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(334,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='rule6_bgcolor' class='colorblock'  r_id='rule6' r_attr='background-color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %>
											</wea:item>
							
											<wea:item>
												<input class='filetree'  r_id='rule6' r_attr='background-image'>
											</wea:item>
										</wea:group>
									</wea:layout>	
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22980,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='rule7_bgcolor' class='colorblock'  r_id='rule7' r_attr='background-color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %>
											</wea:item>
							
											<wea:item>
												<input class='filetree'  r_id='rule7' r_attr='background-image'>
											</wea:item>
										</wea:group>
									</wea:layout>
										</div>											
									
								</div>
								
											  
								<div style="width:40%;float:left;height:100%;position:relative;" id="divPreview">
									
											<div style="color:#394a71;padding-top:15px;padding-left:15px;"><%=SystemEnv.getHtmlLabelName(22974,user.getLanguage())%><!--预览区--></div>
												<div class="height:60px;">&nbsp;</div>
											
												   <div style="float:right" id="menuv" class="sdmenu">
													  <div class="mainBg_top">
														<a  href="#"  class="mainFont">Menu1</a>
														<a href="#" class="sub">Menu1-1</a>
														<a href="#" class="sub">Menu1-2</a>
														<a href="#" class="sub">Menu1-3</a>
													  </div>
													   <div class="mainBg">
														<a  href="#"  class="mainFont">Menu2</a>
														<a href="#" class="sub">Menu2-1</a>
														<a href="#" class="sub">Menu2-2</a>
														<a href="#" class="sub">Menu2-3</a>
													  </div>													
													  <div class="mainBg">
														<a  href="#"  class="mainFont">Menu3</a>
														<a href="#" class="sub">Menu3-1</a>
														<a href="#" class="sub">Menu3-2</a>
														<a href="#" class="sub">Menu3-3</a>   			
													  </div>
													  <div class="mainBg">
													 	 <a  href="#"class="collapsed mainFont">Menu4</a>
														  		
													  </div>
													</div>
											
										</div>										
								
								
								<div style="clear:both"></div>								
					</td>
				</tr>
			</table>
			</form>
	    </td>
		
	</tr>
</TABLE>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<table width="100%">
    <tr><td style="text-align:center;" colspan="3">
     <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
    </td></tr>
</table>
</div>

</body>
</html>
<script language="javascript">

		
		function setFont(obj,classid){
			//var tempid= window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/page/maint/style/FontSelect.jsp");
			var dialog = new window.top.Dialog();
			dialog.currentWindow = window;   //传入当前window
			dialog.Width = 560;
			dialog.Height = 300;
			dialog.maxiumnable=true;
			dialog.callbackfun=doFontback;
			dialog.callbackfunParam={obj:obj,classid:classid};
			dialog.Modal = true;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage())%>"; 
			dialog.URL = "/systeminfo/BrowserMain.jsp?url=/page/maint/style/FontSelect.jsp?isDialog=1";
			dialog.show();
			
		}
		
		function doFontback(json,tempid){
			var obj = json.obj;
			var classid = json.classid;
			if(tempid){
				if(tempid.name){
					$(obj).parent().find("input[r_id='"+classid+"']").val(tempid.name);
					$(obj).parent().find("input[r_id='"+classid+"']").trigger("change");
				}else{
					$(obj).parent().find("input[r_id='"+classid+"']").val("");
					$(obj).parent().find("input[r_id='"+classid+"']").trigger("change");
				}
			}
		}
		
		function onSave(obj){
			if(check_form(frmEdit,'title')){
				var titles =[];
				var states = 0;
				<%
				List titlelist = mvsc.getTitleList();
				for(int i = 0; i < titlelist.size() ; i++){
				%>
					titles[<%=i%>]="<%=titlelist.get(i)%>";
				<%}%>
				for(var i=0; i<titles.length; i++){
					if(titles[i] == frmEdit.title.value)
						states++;
				}
		 		if(frmEdit.title.value != frmEdit.oldtitle.value && states >0){
		 			alert("<%=SystemEnv.getHtmlLabelName(19641,user.getLanguage())%>");
		 		}else{
					generateCss();
					obj.disabled=true;
					frmEdit.submit();
				}
			}
		}

		function onDel(obj){
			
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			var type = '<%=type%>'
			
			jQuery.post("/page/maint/style/MenuStyleOprate.jsp?operate=delStyle&styleid="+styleid+"&type="+type,
			function(data){
				if(data.indexOf("OK")!=-1) {
					var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
					dialog.close();
					parentDialog.currentWindow.location.reload();
				}
				});
		});
		}
		
		function onCancel(){
			var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
			dialog.close();
		}

		$(document).ready(function(){	
			
			$("#fragment-3").hide();
			
			$(".tab").find("li").bind("click",function(){
				var currentid = $(".selected").attr("href");
				$($(".selected").attr("href")).hide()
				$(".selected").removeClass("selected");
				$(this).addClass("selected");
				$($(this).attr("href")).show();
				
			})
		   resizeDialog(document);
		   if("<%=message%>"=="1")
	            alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");	
		});	
		
		
		window.onscroll=function(){
			$("#divPreview").css("top",document.body.scrollTop);
		};
		function onBack(){
		    if(confirm("<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>？"))
			 location.href='/page/maint/style/StyleList.jsp?type=<%=type%>';
		}
		
	</script>
	<SCRIPT type="text/javascript" src="/page/maint/style/common_menu_wev8.js"></script>
	
