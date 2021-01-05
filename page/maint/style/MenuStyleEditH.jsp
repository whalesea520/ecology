
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page import="weaver.page.maint.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="su" class="weaver.page.style.StyleUtil" scope="page" />
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
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
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22914,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";

StyleMaint sm=new StyleMaint(user);
%>




<html>
 <head>
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
	
	
	
	<style id="styleMenu">
	<%=mhsc.getCss(styleid)%>
	</style>
 </head>
<body  id="myBody">
<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=Util.toHtml5(mhsc.getTitle(styleid))%>"/> 
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
<div class="zDialog_div_content">
<form id="frmEdit" name="frmEdit" method="post" action="StyleOprate.jsp">
<input type="hidden" id="styleid" name="styleid" value="<%=styleid%>">
<input type="hidden" id="type" name="type" value="<%=type%>">

<input type="hidden" id="method" name="method" value="edit">

<%
	String msg =Util.null2String(request.getParameter("msg"));
	
	%>	

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





<TABLE width=100%  border="0" cellspacing="0">
    <colgroup>
    <col width="10">
    <col width="">
    <col width="10">
    
    <tr>
       
        <td valign="top">
			<table class="Shadow">
				<colgroup>
				
				<col width="">
			
				<tr>
					
					<td valign="top">
								<textarea style="width:90%;height:200px;display:none" id="css" name="css"></textarea>
								<textarea style="width:90%;height:200px;display:none" id="cssBak" name="cssBak">
									<%=mhsc.getCss(styleid)%>
		`						</textarea>
								<div style="width:50%;float:left;background: #fbfefe;padding-right:5px;border-right: 1px solid #bec7d7">
									<div style="margin-left:30px;padding-top: 15px;color:#5f708d">
										<div style="margin-bottom: 5px; color:#5f708d">
											<span><%=SystemEnv.getHtmlLabelName(19621,user.getLanguage())%></span>
											<span style="padding-left:15px;">
												<input type="input" name="title" value="<%=Util.toHtml5(mhsc.getTitle(styleid))%>" style="width:200px;" class="" onchange='checkinput("title","titlespan")'>	
												<input type="hidden" name="oldtitle" value="<%=Util.toHtml5(mhsc.getTitle(styleid))%>">	
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
												<input type="input"  name="desc"  value="<%=Util.toHtml5(mhsc.getDesc(styleid))%>"  style="width:200px" class="">
											</span>
											
										</div>
										
									</div>
									
									
									<div id="tab" style="margin-top:15px;">
										<ul class="tab">											
											<li class="selected" href="#fragment-2"><span><%=SystemEnv.getHtmlLabelName(17597,user.getLanguage())%><!--主菜单--></span></li>
											<li class="" href="#fragment-3"><span><%=SystemEnv.getHtmlLabelName(17613,user.getLanguage())%><!--子菜单--></span></li>
										</ul>	
									</div>
									<div id="fragment-2">
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22977,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='menuhContainer_bgcolor' class='colorblock'  r_id='menuhContainer' r_attr='background-color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input class='filetree'  r_id='menuhContainer' r_attr='background-image'>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(22963,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span class='right2 corner'  pos='top' r_id='menuhContainer'>														
													<input type='radio' name='cornerTop' value='Right'><%=SystemEnv.getHtmlLabelName(22960,user.getLanguage()) %>
										
													<input type='radio' name='cornerTop' value='Round' loc='top'><%=SystemEnv.getHtmlLabelName(22961,user.getLanguage()) %>
													<input type='text' style='width:40px' class='inputstyle radian' name='cornerTopRadian'>
												</span>
											</wea:item>
											
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(22964,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span class='right2 corner'  pos='bottom' r_id='menuhContainer'>														
													<input type='radio' name='cornerBottom' value='Right'><%=SystemEnv.getHtmlLabelName(22960,user.getLanguage()) %>
										
													<input type='radio' name='cornerBottom' value='Round' loc='bottom'><%=SystemEnv.getHtmlLabelName(22961,user.getLanguage()) %>
													<input type='text' style='width:40px' class='inputstyle radian' name='cornerTopRadian'>
												</span>
											</wea:item>
										</wea:group>
									</wea:layout>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='rule1_color' class='colorblock'  r_id='rule1' r_attr='color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16197,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='spin height' type='text'  r_id='rule1' r_attr='font-size'>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='inputstyle_1 height' type='text'    r_id='rule1' r_attr='font-family'>   <IMG  onclick="setFont(this,'rule1')" style='PADDING-BOTTOM: 0px; MARGIN: 0px 0px 0px 5px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; CURSOR: pointer; PADDING-TOP: 0px'  src='/images/ecology8/request/search-input_wev8.png'   width=13 height=14 >
											</wea:item>
										
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(1014,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(23002,user.getLanguage()) %><input type='checkbox' r_id='rule1' r_attr='font-weight' class='font-weight'>	
												<%=SystemEnv.getHtmlLabelName(23003,user.getLanguage()) %><input type='checkbox' r_id='rule1' r_attr='font-style' class='font-style' >	
								
											</wea:item>
										</wea:group>
									</wea:layout>
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22978,user.getLanguage()) %>'>
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
											
											
										</wea:group>
										
									</wea:layout>
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(25272,user.getLanguage()) %>'>
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
										<wea:group context='<%=SystemEnv.getHtmlLabelName(25273,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='rule2_bgcolor' class='colorblock'  r_id='rule2' r_attr='background-color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %>
											</wea:item>
							
											<wea:item>
												<input class='filetree'  r_id='rule2' r_attr='background-image'>
											</wea:item>
										</wea:group>
									</wea:layout>
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22958,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(22256,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='main' r_attr='border-right-style'>
													<input type='radio' name='main_border-right-style' value='none'><%=SystemEnv.getHtmlLabelName(557,user.getLanguage()) %>
													<input type='radio' name='main_border-right-style' value='solid'><%= SystemEnv.getHtmlLabelName(22998,user.getLanguage())%>
													<input type='radio' name='main_border-right-style' value='dotted'><%=SystemEnv.getHtmlLabelName(22999,user.getLanguage()) %>
													<input type='radio' name='main_border-right-style' value='dashed'><%=SystemEnv.getHtmlLabelName(23000,user.getLanguage()) %>
													<input type='radio' name='main_border-right-style' value='double'><%=SystemEnv.getHtmlLabelName(23001,user.getLanguage()) %>
												 </span>
												 
												
											</wea:item>
											<wea:item>
												
											</wea:item>
							
											<wea:item>
												 <input   type='text'   class='spin height' r_id='main' r_attr='border-right-width'>
												<span>&nbsp;</span>
												<span  id='main_border-right-color' class='colorblock' r_id='main' r_attr='border-right-color'></span>
											</wea:item>
										</wea:group>
									</wea:layout>
									
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(811,user.getLanguage()) %>'>
										
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(22982,user.getLanguage())%><!--子菜单图标-->
											</wea:item>
							
											<wea:item>
												<input class='filetree'  r_id='downarrowclass' r_attr='src' name="iconMainDown">
											</wea:item>
											
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(22959,user.getLanguage())%><!--内容边距-->
											</wea:item>
							
											<wea:item>
												  <%=SystemEnv.getHtmlLabelName(22952,user.getLanguage())%><!-- 距上 --><input  class="spin height" type="text"  r_id="main" r_attr="padding-top">	
														  <%=SystemEnv.getHtmlLabelName(22955,user.getLanguage())%><!-- 距下 --><input  class="spin height" type="text"  r_id="main" r_attr="padding-bottom">
														<br>
														 <%=SystemEnv.getHtmlLabelName(22953,user.getLanguage())%><!-- 距左 --><input  class="spin height" type="text"  r_id="main" r_attr="padding-left">
														 <%=SystemEnv.getHtmlLabelName(22954,user.getLanguage())%><!-- 距右 --><input  class="spin height" type="text"  r_id="main" r_attr="padding-right">
													
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
												<span  id='rule3_color' class='colorblock'  r_id='rule3' r_attr='color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16197,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='spin height' type='text'  r_id='rule3' r_attr='font-size'>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='inputstyle_1 height' type='text'    r_id='rule3' r_attr='font-family'>   <IMG  onclick="setFont(this,'rule3')" style='PADDING-BOTTOM: 0px; MARGIN: 0px 0px 0px 5px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; CURSOR: pointer; PADDING-TOP: 0px'  src='/images/ecology8/request/search-input_wev8.png'   width=13 height=14 >
											</wea:item>
										
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(1014,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(23002,user.getLanguage()) %><input type='checkbox' r_id='rule3' r_attr='font-weight' class='font-weight'>	
												<%=SystemEnv.getHtmlLabelName(23003,user.getLanguage()) %><input type='checkbox' r_id='rule3' r_attr='font-style' class='font-style' >	
								
											</wea:item>
										</wea:group>
									</wea:layout>
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22978,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span  id='rule4_color' class='colorblock'  r_id='rule4' r_attr='color'></span>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16197,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='spin height' type='text'  r_id='rule4' r_attr='font-size'>
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<input  class='inputstyle_1 height' type='text'    r_id='rule4' r_attr='font-family'>   <IMG  onclick="setFont(this,'rule4')" style='PADDING-BOTTOM: 0px; MARGIN: 0px 0px 0px 5px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; CURSOR: pointer; PADDING-TOP: 0px'  src='/images/ecology8/request/search-input_wev8.png'   width=13 height=14 >
											</wea:item>
											
											
											
										</wea:group>
										
									</wea:layout>
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(25272,user.getLanguage()) %>'>
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
										<wea:group context='<%=SystemEnv.getHtmlLabelName(25273,user.getLanguage()) %>'>
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
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22958,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(22256,user.getLanguage()) %>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='sub' r_attr='border-bottom-style'>
													<input type='radio' name='sub_border-bottom-style' value='none'><%=SystemEnv.getHtmlLabelName(557,user.getLanguage()) %>
													<input type='radio' name='sub_border-bottom-style' value='solid'><%= SystemEnv.getHtmlLabelName(22998,user.getLanguage())%>
													<input type='radio' name='sub_border-bottom-style' value='dotted'><%=SystemEnv.getHtmlLabelName(22999,user.getLanguage()) %>
													<input type='radio' name='sub_border-bottom-style' value='dashed'><%=SystemEnv.getHtmlLabelName(23000,user.getLanguage()) %>
													<input type='radio' name='sub_border-bottom-style' value='double'><%=SystemEnv.getHtmlLabelName(23001,user.getLanguage()) %>
												 </span>
												 
												
											</wea:item>
											<wea:item>
												
											</wea:item>
							
											<wea:item>
												 <input   type='text'   class='spin height' r_id='sub' r_attr='border-bottom-width'>
												<span>&nbsp;</span>
												<span  id='sub_border-bottom-color' class='colorblock' r_id='sub' r_attr='border-bottom-color'></span>
											</wea:item>
										</wea:group>
									</wea:layout>
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(811,user.getLanguage()) %>'>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(22982,user.getLanguage())%><!--子菜单图标-->
											</wea:item>
											<wea:item>
												<input class='filetree'  r_id='rightarrowclass' r_attr='src' name="iconSubDown">
											</wea:item>
											<wea:item>
												<%=SystemEnv.getHtmlLabelName(22959,user.getLanguage())%><!--内容边距-->
											</wea:item>
							
											<wea:item>
													 <%=SystemEnv.getHtmlLabelName(22952,user.getLanguage())%><!-- 距上 --><input  class="spin height" type="text"  r_id="sub" r_attr="padding-top">	
														  <%=SystemEnv.getHtmlLabelName(22955,user.getLanguage())%><!-- 距下 --><input  class="spin height" type="text"  r_id="sub" r_attr="padding-bottom">
														 <br>
														 <%=SystemEnv.getHtmlLabelName(22953,user.getLanguage())%><!-- 距左 --><input  class="spin height" type="text"  r_id="sub" r_attr="padding-left">
														 <%=SystemEnv.getHtmlLabelName(22954,user.getLanguage())%><!-- 距右 --><input  class="spin height" type="text"  r_id="sub" r_attr="padding-right">
													
											</wea:item>
										</wea:group>
									</wea:layout>
									</div>
									
									
								</div>
								
											  
								<div style="width:49%;float:right;height:100%;position:relative;" id="divPreview">
									
											<div style="color:#394a71;padding-top:15px;"><%=SystemEnv.getHtmlLabelName(22974,user.getLanguage())%><!--预览区--></div>
												<div class="height:60px;">&nbsp;</div>
												<div class="menuhContainer" id="menuhContainer" cornerTop='<%=mhsc.getCornerTop(styleid) %>'  cornerTopRadian='<%=mhsc.getCornerTopRadian(styleid) %>'  cornerBottom='<%=mhsc.getCornerBottomRadian(styleid) %>'  cornerBottomRadian='<%=mhsc.getCornerBottomRadian(styleid) %>'>
												<span id="menuh" class="menuh" >	
													<ul>
														<li><a href="#"   class="main">Menu1</a></li>
														<li><a href="#" class="main">Menu2</a><ul>
														  <li><a href="#" class="sub">Menu2-1</a></li>
														  <li><a href="#" class="sub">Menu2-2</a><ul>
															<li><a href="#" class="sub">Menu2-2-1</a></li>
															<li><a href="#" class="sub">Menu2-2-2</a></li>												
															<li><a href="#" class="sub">Menu2-2-3</a></li>
															</ul>
														  </li>
														  </ul>
														</li>
														<li ><a href="#" class="main">Menu3</a></li>
													</ul>
													<br style="clear: left" />
												</span>
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

</div>
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
		
		function onCancel(){
			var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
			dialog.close();
		}
		
		
		function onSave(obj){
			if(check_form(frmEdit,'title')){
				var titles =[];
				var states = 0;
				<%
				List titlelist = mhsc.getTitleList();
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
				
			menuh.arrowimages.down[1]="<%=mhsc.getIconMainDown(styleid)%>";
			menuh.arrowimages.right[1]="<%=mhsc.getIconSubDown(styleid)%>";

			menuh.init({
				mainmenuid: "menuh", 
				contentsource: "markup"
			})
			
			$('.radian').each(function(){
				var cValue="";
				if(this.name=="cornerTopRadian"){
					cValue="<%=mhsc.getCornerTopRadian(styleid)%>"
				} else if(this.name=="cornerBottomRadian"){
					cValue="<%=mhsc.getCornerBottomRadian(styleid)%>"
				} 

				this.value=cValue;
				
				$(this).bind("blur",function(){
					var prevObj=this.previousSibling.previousSibling.previousSibling ;		
							
					if(prevObj.value=="Right") { //直角
						$("."+(prevObj.parentNode.r_id)).uncornerById(prevObj.loc); 
						
					} else { //圆角
						$("."+(prevObj.parentNode.r_id)).uncornerById(prevObj.loc); 						
						$("."+(prevObj.parentNode.r_id)).corner("Round "+prevObj.loc+" "+this.value,prevObj.loc); 
					}			
				});	
			});
			
			$(".corner").each(function(){
				var cornerTop="<%=mhsc.getCornerTop(styleid)%>"
				var cornerBottom="<%=mhsc.getCornerBottom(styleid)%>"					
				
				var r_id=$(this).attr("r_id");
				var cValue="";
				var cPos="";		
				if($(this).attr("pos")=="top") {
					cValue=cornerTop;
					cPos="top";
				} else {
					cValue=cornerBottom;
					cPos="bottom";
				}
				for(var i=0;i<this.children.length;i++){		
					var child=this.children[i];		
					//alert(child);
					$(child).bind("click",function(){
						$this = $(this).find("input")[0]
						//alert($this.checked)
						
						if($this.checked){
							if($this.value=="Right") { //直角
								$("."+r_id).uncornerById(cPos); 
								
							} else { //圆角
								$("."+r_id).uncornerById(cPos); 
								var cValueRadian=$($this).parent().children("INPUT.radian").val();
								//alert(cValueRadian);
								$("."+r_id).corner(" "+$this.value+" "+cPos+" "+cValueRadian,cPos); 
							}
							changeRadioStatus4tzRadio($this, $this.checked);
						}					
					});
					
					if($(child).find("input").length>0){
						child = $(child).find("input")[0]
						changeRadioStatus4tzRadio(child, child.checked);	
						if(child.value==cValue){
							child.checked=true;
							changeRadioStatus4tzRadio(child, child.checked);
							$(child).trigger("click");
						}
					}
					
				}
			});

			  
		});	
		/*当主菜单和子菜单的图标发生更改时，处理图标的是否显示判断*/
		  $(".downarrowclass").bind('error',function(){
				if($(this).attr("src")==''){
					$(this).hide();
				}
		  })
		  
		  $(".downarrowclass").bind('load',function(){
				if($(this).attr("src")!=''){
					$(this).show();
				}
		  })
		  
		  $(".rightarrowclass").bind('error',function(){
				if($(this).attr("src")==''){
					$(this).hide();
				}
		  })
		  
		  $(".rightarrowclass").bind('load',function(){
				if($(this).attr("src")!=''){
					$(this).show();
				}
		  })
		
		$(".zDialog_div_content").bind("scroll",function(){
			$("#divPreview").css("top",$(this).scrollTop());
		})
		
		function onBack(){
			location.href='/page/maint/style/StyleList.jsp?type=<%=type%>';
		}	
	</script>
	<!--common js-->
	<SCRIPT type="text/javascript" src="/page/maint/style/common_menu_wev8.js"></script>
