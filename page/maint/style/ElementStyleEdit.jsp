
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.page.maint.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="su" class="weaver.page.style.StyleUtil" scope="page" />
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<%
String styleid =Util.null2String(request.getParameter("styleid"));	
String type = Util.null2String(request.getParameter("type"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22913,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";

StyleMaint sm=new StyleMaint(user);
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<html>
 <head>
 	<script>
 		var styleid= '<%=styleid%>';
 	</script>
	<!--Base Css And Js-->
   	<link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
	<link href="/page/maint/style/common_wev8.css" type="text/css" rel=stylesheet>



	 <!--For Corner-->
	<SCRIPT type="text/javascript" src="/js/jquery/plugins/corner/jquery.corner_wev8.js"></script>


	<!--For Color-->
	<link rel="stylesheet" href="/js/jquery/plugins/farbtastic/farbtastic_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/jquery/plugins/farbtastic/farbtastic_wev8.js"></script>	

	<!--For Spin Button-->
	<SCRIPT type="text/javascript" src="/js/jquery/plugins/spin/jquery.spin_wev8.js"></script>	

	<!--For File Browser Tree-->
	<SCRIPT type="text/javascript" src="/js/jquery/plugins/filetree/jquery.filetree_wev8.js"></script>	


	<link rel="stylesheet" href="/js/ecology8/spectrum/spectrum_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/spectrum/spectrum_wev8.js"></script>	
	
	<!--common js-->
	<SCRIPT type="text/javascript" src="/page/maint/style/common_wev8.js"></script>
	
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
		background:#ffffff!important;
		border-top: 2px solid #00a7ff;
	}
	.zDialog_div_content {
		background: #ebeef0;
	}
	
	.spin{
		width: 25px!important;
	}
	.title{
	 padding-bottom:5px;
	}
</style>
	
 </head>
<body  id="myBody">
<jsp:include page="/systeminfo/commonTabHead.jsp">
	<jsp:param name="mouldID" value="portal"/>
	<jsp:param name="navName" value="<%=Util.toHtml5(esc.getTitle(styleid))%>"/> 
</jsp:include>
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
<input type="hidden" id="language" name="language" value="<%=user.getLanguage()%>">
<input type="hidden" id="method" name="method" value="edit">
<%
	String msg =Util.null2String(request.getParameter("msg"));
	
	%>
<TABLE width=100% height=100% border="0" cellspacing="0">

   
    <tr>
       
        <td valign="top">
			<table class="Shadow">
				
				<tr>
					
					<td valign="top">
								<textarea style="width:90%;height:200px;display:none" id="css" name="css"></textarea>
								<textarea style="width:90%;height:200px;display:none" id="cssBak" name="cssBak"><%=esc.getCss(styleid)%></textarea>
								<div style="width:48%;float:left;background-color: #fbfefe;border-right: 1px solid #bec7d7">
									<div style="margin-left:30px;padding-top: 15px;color:#5f708d">
										<div style="margin-bottom: 5px; color:#5f708d">
											<span><%=SystemEnv.getHtmlLabelName(19621,user.getLanguage())%></span>
											<span style="padding-left:15px;">
												<input type="input" name="title" value="<%=Util.toHtml5(esc.getTitle(styleid))%>" style="width:200px;" class="" onchange='checkinput("title","titlespan")'>	
												<input type="hidden" name="oldtitle" value="<%=Util.toHtml5(esc.getTitle(styleid))%>">	
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
												<input type="input"  name="desc"  value="<%=Util.toHtml5(esc.getDesc(styleid))%>"  style="width:200px" class="">
											</span>
											
										</div>
										
									</div>
									<%
									//	String style="color:#676767;font-style:normal;font-size:12px;text-decoration:none;";
									%>
											
									<div id="tab" style="margin-top:15px;">
										<ul class="tab">											
											<li class="selected"  href="#fragment-2"><span><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><!-- 标题 --></span></li>
											<li href="#fragment-3"><span><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%><!-- 内容 --></span></li>
											<li href="#fragment-4"><span><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><!-- 其它 --></span></li>
									</ul>	
									</div>								
										<div id="fragment-2" style="width: 100%;">
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(61,user.getLanguage()) %>'><!-- 基本 -->
											<wea:item>
													<span class="left"><%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%><!-- 高度 --></span>
											</wea:item>
											<wea:item>
													<span class="right2"><input  class="spin height" type="text"  r_id="header" r_attr="height"></span>		
											</wea:item>
											<wea:item>
														<span class="left"><%=SystemEnv.getHtmlLabelName(22969,user.getLanguage())%></span>
											</wea:item>
											<wea:item>
														<span class="right2">	
															<input class='filetree'  r_id='iconLogo' r_attr='src' name="iconLogo">
														</span>
											</wea:item>
											<wea:item>
													<span class="left"><%=SystemEnv.getHtmlLabelName(22969,user.getLanguage())%></span>
											</wea:item>
											<wea:item>
													<span class="right2">
														 <%=SystemEnv.getHtmlLabelName(22952,user.getLanguage())%><!-- 距上 --><input  class="spin height" type="text" r_id="icon" r_attr="top">
														 <br />
														 <%=SystemEnv.getHtmlLabelName(22953,user.getLanguage())%><!-- 距左 --><input  class="spin height" type="text"  r_id="icon" r_attr="left">
													</span>			
											</wea:item>
											<wea:item>
													<span class="left"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><!--标题 --></span>
											</wea:item>
											<wea:item>
													<span class="right2">
														<%=SystemEnv.getHtmlLabelName(22952,user.getLanguage())%><!-- 距上 --><input  class="spin height" type="text"  r_id="title" r_attr="top">
														 <br />
														<%=SystemEnv.getHtmlLabelName(22953,user.getLanguage())%><!-- 距左 --><input  class="spin height" type="text"  r_id="title" r_attr="left">
													</span>					
											</wea:item>
											<wea:item>
													<span class="left"><%=SystemEnv.getHtmlLabelName(22956,user.getLanguage())%><!--工具条 --></span>
											</wea:item>
											<wea:item>
													<span class="right2">
														<%=SystemEnv.getHtmlLabelName(22952,user.getLanguage())%><!-- 距上 --><input  class="spin height" type="text"  r_id="toolbar" r_attr="top">
														 <br />
														<%=SystemEnv.getHtmlLabelName(22954,user.getLanguage())%><!-- 距右 --><input  class="spin height" type="text"  r_id="toolbar" r_attr="right">
													</span>		
											</wea:item>
										</wea:group>
									</wea:layout>
											
										<%if(false){ %>											
											<%=sm.getFont("title")%>
										<%} %>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(229,user.getLanguage()) %>'><!-- 标题 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'>
													<span  id='title_color' class='colorblock'  r_id='title' r_attr='color'></span>
												</span>
											</wea:item>
											
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(84136,user.getLanguage())%></span>
											</wea:item>
											<wea:item>
												<span class='right2'>
													<span  id='head_hover' class='colorblock'  r_id='head_hover' r_attr='color'></span>
												</span>
												 
                                                <span style='margin-left: 10px;'><%=SystemEnv.getHtmlLabelName(84137,user.getLanguage())%>&nbsp;:&nbsp;</span><span><input  type='checkbox' name='isbgcolopen' ></span>
											</wea:item>

											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(84139,user.getLanguage())%></span>
											</wea:item>
											<wea:item>
												<span class='right2'>
													<span  id='border_bottom_color' class='colorblock'  r_id='title' r_attr='border-bottom-color'></span>
												</span>
												<span style='margin-left: 10px;'><%=SystemEnv.getHtmlLabelName(84137,user.getLanguage())%>&nbsp;:&nbsp;</span><span><input  type='checkbox' name='isbtcolopen' ></span>
											</wea:item>

											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(16197,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'><input  class='spin height' type='text'  r_id='title' r_attr='font-size'></span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'><input  class='inputstyle_1 height' type='text'    r_id='title' r_attr='font-family'>
												<IMG  onclick="setFont(this,'title')" style='PADDING-BOTTOM: 0px; MARGIN: 0px 0px 0px 5px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; CURSOR: pointer; PADDING-TOP: 0px'  src='/images/ecology8/request/search-input_wev8.png'   width=13 height=14 >  </span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(1014,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'>
													<%=SystemEnv.getHtmlLabelName(23002,user.getLanguage()) %><input type='checkbox' r_id='title' r_attr='font-weight' class='font-weight'>		 
													<%=SystemEnv.getHtmlLabelName(23003,user.getLanguage()) %><input type='checkbox' r_id='title' r_attr='font-style' class='font-style' >	
												</span> 
											</wea:item>
										</wea:group>
									</wea:layout>
											
										<%if(false){ %>		
											<%=sm.getBackground("header")%>
										<%} %>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(334,user.getLanguage()) %>'><!-- 背景 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='center'>
													<input id='header_bgcolor_t' type='checkbox' class='transparent' t_id='header_bgcolor'><%=SystemEnv.getHtmlLabelName(23004,user.getLanguage()) %></span>
												<span class='right'>
													<span  id='header_bgcolor' class='colorblock'  r_id='header' r_attr='background-color'></span>
												</span>			
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %></span>		
											</wea:item>
											<wea:item>
												<span class='right2'><input class='filetree'  r_id='header' r_attr='background-image'></span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(19071,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2  line-style'  r_id='header' r_attr='background-repeat'>
													<input type='radio' value='repeat' name='header_background-repeat'><%=SystemEnv.getHtmlLabelName(23005,user.getLanguage()) %>
													<input type='radio' value='repeat-x' name='header_background-repeat'><%=SystemEnv.getHtmlLabelName(23006,user.getLanguage()) %>
													<input type='radio' value='repeat-y' name='header_background-repeat'><%=SystemEnv.getHtmlLabelName(23007,user.getLanguage()) %>
													<input type='radio' value='no-repeat' name='header_background-repeat'><%=SystemEnv.getHtmlLabelName(23008,user.getLanguage()) %>
												</span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(19072,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='header' r_attr='background-position-x'>
													<input type='radio' value='left' name='header_background-position-x'><%=SystemEnv.getHtmlLabelName(22986,user.getLanguage()) %>
													<input type='radio' value='center' name='header_background-position-x'><%=SystemEnv.getHtmlLabelName(22987,user.getLanguage()) %>
													<input type='radio' value='right' name='header_background-position-x'><%=SystemEnv.getHtmlLabelName(22988,user.getLanguage()) %>
												</span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(19073,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='header' r_attr='background-position-Y'>
													<input type='radio' value='top'  name='header_background-position-y'><%=SystemEnv.getHtmlLabelName(23009,user.getLanguage()) %>
													<input type='radio' value='center'  name='header_background-position-y'><%=SystemEnv.getHtmlLabelName(22987,user.getLanguage()) %>
													<input type='radio' value='bottom'  name='header_background-position-y'><%=SystemEnv.getHtmlLabelName(23010,user.getLanguage()) %>
												</span>
											</wea:item>
										</wea:group>
									</wea:layout>
											
										<%if(false){ %>		
											<%=sm.getBorder("header")%>	
										<%} %>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22994,user.getLanguage()) %>'><!-- 上边框 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='header' r_attr='border-top-style'>
													<input type='radio' name='header_border-top-style' value='none'><%=SystemEnv.getHtmlLabelName(557,user.getLanguage()) %>
													<input type='radio' name='header_border-top-style' value='solid'><%=SystemEnv.getHtmlLabelName(22998,user.getLanguage()) %>
													<input type='radio' name='header_border-top-style' value='dotted'><%=SystemEnv.getHtmlLabelName(22999,user.getLanguage()) %>
													<input type='radio' name='header_border-top-style' value='dashed'><%=SystemEnv.getHtmlLabelName(23000,user.getLanguage()) %>
													<input type='radio' name='header_border-top-style' value='double'><%=SystemEnv.getHtmlLabelName(23001,user.getLanguage()) %>
												 </span>
												 <br />
											 	<span class='left'>&nbsp;</span>
												<input   type='text'   class='spin height' r_id='header' r_attr='border-top-width'>
												 <br />
												<span>&nbsp;</span>
												<span  id='header_border-top-color' class='colorblock' r_id='header' r_attr='border-top-color'></span>
											</wea:item>
										</wea:group>
									</wea:layout>
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22995,user.getLanguage()) %>'><!-- 下边框 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='header' r_attr='border-bottom-style'>
													<input type='radio' name='header_border-bottom-style' value='none'><%=SystemEnv.getHtmlLabelName(557,user.getLanguage()) %>
													<input type='radio' name='header_border-bottom-style' value='solid'><%=SystemEnv.getHtmlLabelName(22998,user.getLanguage()) %>
													<input type='radio' name='header_border-bottom-style' value='dotted'><%=SystemEnv.getHtmlLabelName(22999,user.getLanguage()) %>
													<input type='radio' name='header_border-bottom-style' value='dashed'><%=SystemEnv.getHtmlLabelName(23000,user.getLanguage()) %>
													<input type='radio' name='header_border-bottom-style' value='double'><%=SystemEnv.getHtmlLabelName(23001,user.getLanguage()) %>
												 </span>
												 <br />
											 	<span class='left'>&nbsp;</span>
												<input   type='text'   class='spin height' r_id='header' r_attr='border-bottom-width'>
												 <br />
												<span>&nbsp;</span>
												<span  id='header_border-bottom-color' class='colorblock' r_id='header' r_attr='border-bottom-color'></span>
											</wea:item>
										</wea:group>
									</wea:layout>
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22996,user.getLanguage()) %>'><!-- 左边框 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='header' r_attr='border-left-style'>
													<input type='radio' name='header_border-left-style' value='none'><%=SystemEnv.getHtmlLabelName(557,user.getLanguage()) %>
													<input type='radio' name='header_border-left-style' value='solid'><%=SystemEnv.getHtmlLabelName(22998,user.getLanguage()) %>
													<input type='radio' name='header_border-left-style' value='dotted'><%=SystemEnv.getHtmlLabelName(22999,user.getLanguage()) %>
													<input type='radio' name='header_border-left-style' value='dashed'><%=SystemEnv.getHtmlLabelName(23000,user.getLanguage()) %>
													<input type='radio' name='header_border-left-style' value='double'><%=SystemEnv.getHtmlLabelName(23001,user.getLanguage()) %>
												 </span>
												 <br />
											 	<span class='left'>&nbsp;</span>
												<input   type='text'   class='spin height' r_id='header' r_attr='border-left-width'>
												 <br />
												<span>&nbsp;</span>
												<span  id='header_border-left-color' class='colorblock' r_id='header' r_attr='border-left-color'></span>
											</wea:item>
										</wea:group>
									</wea:layout>
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22997,user.getLanguage()) %>'><!-- 右边框 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='header' r_attr='border-right-style'>
													<input type='radio' name='header_border-right-style' value='none'><%=SystemEnv.getHtmlLabelName(557,user.getLanguage()) %>
													<input type='radio' name='header_border-right-style' value='solid'><%=SystemEnv.getHtmlLabelName(22998,user.getLanguage()) %>
													<input type='radio' name='header_border-right-style' value='dotted'><%=SystemEnv.getHtmlLabelName(22999,user.getLanguage()) %>
													<input type='radio' name='header_border-right-style' value='dashed'><%=SystemEnv.getHtmlLabelName(23000,user.getLanguage()) %>
													<input type='radio' name='header_border-right-style' value='double'><%=SystemEnv.getHtmlLabelName(23001,user.getLanguage()) %>
												 </span>
												 <br />
											 	<span class='left'>&nbsp;</span>
												<input   type='text'   class='spin height' r_id='header' r_attr='border-right-width'>
												 <br />
												<span>&nbsp;</span>
												<span  id='header_border-right-color' class='colorblock' r_id='header' r_attr='border-right-color'></span>
											</wea:item>
										</wea:group>
									</wea:layout>
										</div>
										
										
										<div id="fragment-3" >	
										<%if(false){ %>										
											<%=sm.getFont("font")%>
										<%} %>	
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(229,user.getLanguage()) %>'><!-- 标题 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'>
													<span  id='font_color' class='colorblock'  r_id='font' r_attr='color'></span>
												</span>
											</wea:item>
										    
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(84141,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'>
													<span  id='font_hover' class='colorblock'  r_id='font_hover' r_attr='color'></span>
												</span>
											</wea:item>
											
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(16197,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'><input  class='spin height' type='text'  r_id='font' r_attr='font-size'></span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'><input  class='inputstyle_1 height' type='text'    r_id='font' r_attr='font-family'>
												<IMG  onclick="setFont(this,'font')" style='PADDING-BOTTOM: 0px; MARGIN: 0px 0px 0px 5px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; CURSOR: pointer; PADDING-TOP: 0px'  src='/images/ecology8/request/search-input_wev8.png'   width=13 height=14 >  </span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(1014,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'>
													<%=SystemEnv.getHtmlLabelName(23002,user.getLanguage()) %><input type='checkbox' r_id='font' r_attr='font-weight' class='font-weight'>		 
													<%=SystemEnv.getHtmlLabelName(23003,user.getLanguage()) %><input type='checkbox' r_id='font' r_attr='font-style' class='font-style' >	
												</span> 
											</wea:item>
										</wea:group>
									</wea:layout>
									
										<%if(false){ %>			
											<%=sm.getBackground("content")%>
										<%} %>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(334,user.getLanguage()) %>'><!-- 背景 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='center'>
													<input id='content_bgcolor_t' type='checkbox' class='transparent' t_id='content_bgcolor'><%=SystemEnv.getHtmlLabelName(23004,user.getLanguage()) %></span>
												<span class='right'>
													<span  id='content_bgcolor' class='colorblock'  r_id='content' r_attr='background-color'></span>
												</span>			
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %></span>		
											</wea:item>
											<wea:item>
												<span class='right2'><input class='filetree'  r_id='content' r_attr='background-image'></span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(19071,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2  line-style'  r_id='content' r_attr='background-repeat'>
													<input type='radio' value='repeat' name='content_background-repeat'><%=SystemEnv.getHtmlLabelName(23005,user.getLanguage()) %>
													<input type='radio' value='repeat-x' name='content_background-repeat'><%=SystemEnv.getHtmlLabelName(23006,user.getLanguage()) %>
													<input type='radio' value='repeat-y' name='content_background-repeat'><%=SystemEnv.getHtmlLabelName(23007,user.getLanguage()) %>
													<input type='radio' value='no-repeat' name='content_background-repeat'><%=SystemEnv.getHtmlLabelName(23008,user.getLanguage()) %>
												</span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(19072,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='content' r_attr='background-position-x'>
													<input type='radio' value='left' name='content_background-position-x'><%=SystemEnv.getHtmlLabelName(22986,user.getLanguage()) %>
													<input type='radio' value='center' name='content_background-position-x'><%=SystemEnv.getHtmlLabelName(22987,user.getLanguage()) %>
													<input type='radio' value='right' name='content_background-position-x'><%=SystemEnv.getHtmlLabelName(22988,user.getLanguage()) %>
												</span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(19073,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='content' r_attr='background-position-Y'>
													<input type='radio' value='top'  name='content_background-position-y'><%=SystemEnv.getHtmlLabelName(23009,user.getLanguage()) %>
													<input type='radio' value='center'  name='content_background-position-y'><%=SystemEnv.getHtmlLabelName(22987,user.getLanguage()) %>
													<input type='radio' value='bottom'  name='content_background-position-y'><%=SystemEnv.getHtmlLabelName(23010,user.getLanguage()) %>
												</span>
											</wea:item>
										</wea:group>
									</wea:layout>
									
										<%if(false){ %>			
											<%=sm.getBorder("content")%>	
										<%} %>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22994,user.getLanguage()) %>'><!-- 上边框 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='content' r_attr='border-top-style'>
													<input type='radio' name='content_border-top-style' value='none'><%=SystemEnv.getHtmlLabelName(557,user.getLanguage()) %>
													<input type='radio' name='content_border-top-style' value='solid'><%=SystemEnv.getHtmlLabelName(22998,user.getLanguage()) %>
													<input type='radio' name='content_border-top-style' value='dotted'><%=SystemEnv.getHtmlLabelName(22999,user.getLanguage()) %>
													<input type='radio' name='content_border-top-style' value='dashed'><%=SystemEnv.getHtmlLabelName(23000,user.getLanguage()) %>
													<input type='radio' name='content_border-top-style' value='double'><%=SystemEnv.getHtmlLabelName(23001,user.getLanguage()) %>
												 </span>
												 <br />
											 	<span class='left'>&nbsp;</span>
												<input   type='text'   class='spin height' r_id='content' r_attr='border-top-width'>
												 <br />
												<span>&nbsp;</span>
												<span  id='content_border-top-color' class='colorblock' r_id='content' r_attr='border-top-color'></span>
											</wea:item>
										</wea:group>
									</wea:layout>
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22995,user.getLanguage()) %>'><!-- 下边框 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='content' r_attr='border-bottom-style'>
													<input type='radio' name='content_border-bottom-style' value='none'><%=SystemEnv.getHtmlLabelName(557,user.getLanguage()) %>
													<input type='radio' name='content_border-bottom-style' value='solid'><%=SystemEnv.getHtmlLabelName(22998,user.getLanguage()) %>
													<input type='radio' name='content_border-bottom-style' value='dotted'><%=SystemEnv.getHtmlLabelName(22999,user.getLanguage()) %>
													<input type='radio' name='content_border-bottom-style' value='dashed'><%=SystemEnv.getHtmlLabelName(23000,user.getLanguage()) %>
													<input type='radio' name='content_border-bottom-style' value='double'><%=SystemEnv.getHtmlLabelName(23001,user.getLanguage()) %>
												 </span>
												 <br />
											 	<span class='left'>&nbsp;</span>
												<input   type='text'   class='spin height' r_id='content' r_attr='border-bottom-width'>
												 <br />
												<span>&nbsp;</span>
												<span  id='content_border-bottom-color' class='colorblock' r_id='content' r_attr='border-bottom-color'></span>
											</wea:item>
										</wea:group>
									</wea:layout>
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22996,user.getLanguage()) %>'><!-- 左边框 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='content' r_attr='border-left-style'>
													<input type='radio' name='content_border-left-style' value='none'><%=SystemEnv.getHtmlLabelName(557,user.getLanguage()) %>
													<input type='radio' name='content_border-left-style' value='solid'><%=SystemEnv.getHtmlLabelName(22998,user.getLanguage()) %>
													<input type='radio' name='content_border-left-style' value='dotted'><%=SystemEnv.getHtmlLabelName(22999,user.getLanguage()) %>
													<input type='radio' name='content_border-left-style' value='dashed'><%=SystemEnv.getHtmlLabelName(23000,user.getLanguage()) %>
													<input type='radio' name='content_border-left-style' value='double'><%=SystemEnv.getHtmlLabelName(23001,user.getLanguage()) %>
												 </span>
												 <br />
											 	<span class='left'>&nbsp;</span>
												<input   type='text'   class='spin height' r_id='content' r_attr='border-left-width'>
												 <br />
												<span>&nbsp;</span>
												<span  id='content_border-left-color' class='colorblock' r_id='content' r_attr='border-left-color'></span>
											</wea:item>
										</wea:group>
									</wea:layout>
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22997,user.getLanguage()) %>'><!-- 右边框 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2 line-style'  r_id='content' r_attr='border-right-style'>
													<input type='radio' name='content_border-right-style' value='none'><%=SystemEnv.getHtmlLabelName(557,user.getLanguage()) %>
													<input type='radio' name='content_border-right-style' value='solid'><%=SystemEnv.getHtmlLabelName(22998,user.getLanguage()) %>
													<input type='radio' name='content_border-right-style' value='dotted'><%=SystemEnv.getHtmlLabelName(22999,user.getLanguage()) %>
													<input type='radio' name='content_border-right-style' value='dashed'><%=SystemEnv.getHtmlLabelName(23000,user.getLanguage()) %>
													<input type='radio' name='content_border-right-style' value='double'><%=SystemEnv.getHtmlLabelName(23001,user.getLanguage()) %>
												 </span>
												 <br />
											 	<span class='left'>&nbsp;</span>
												<input   type='text'   class='spin height' r_id='content' r_attr='border-right-width'>
												 <br />
												<span>&nbsp;</span>
												<span  id='content_border-right-color' class='colorblock' r_id='content' r_attr='border-right-color'></span>
											</wea:item>
										</wea:group>
									</wea:layout>
													
									
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(811,user.getLanguage()) %>'><!-- 其它 -->		
											<wea:item>				
														<span class="left"><%=SystemEnv.getHtmlLabelName(22957,user.getLanguage())%><!--行小图标--></span>
											</wea:item>
											<wea:item>
														<span class="right2">													
																<input class='filetree'  r_id='iconEsymbol' r_attr='src' name="iconEsymbol">
														</span>
											</wea:item>
											<wea:item>
														<span class="left"><%=SystemEnv.getHtmlLabelName(22958,user.getLanguage())%><!--分隔线--></span>
											</wea:item>
											<wea:item>
														<span class="right2">		
															<input class='filetree'  r_id='sparator' r_attr='background-image'>		
														</span>
											</wea:item>
											<wea:item>
														<span class="left"><%=SystemEnv.getHtmlLabelName(22959,user.getLanguage())%><!--内容边距--></span>
											</wea:item>
											<wea:item>
														<span class="right2">		
															 <%=SystemEnv.getHtmlLabelName(22952,user.getLanguage())%><!-- 距上 --><input  class="spin height" type="text"  r_id="content" r_attr="padding-top">	
											</wea:item>
											<wea:item>&nbsp;</wea:item>
											<wea:item>
															 <%=SystemEnv.getHtmlLabelName(22955,user.getLanguage())%><!-- 距下 --><input  class="spin height" type="text"  r_id="content" r_attr="padding-bottom">
											</wea:item>
											<wea:item>&nbsp;</wea:item>
											<wea:item>
															<%=SystemEnv.getHtmlLabelName(22953,user.getLanguage())%><!-- 距左 --><input  class="spin height" type="text"  r_id="content" r_attr="padding-left">
											</wea:item>
											<wea:item>&nbsp;</wea:item>
											<wea:item>
															<%=SystemEnv.getHtmlLabelName(22954,user.getLanguage())%><!-- 距右 --><input  class="spin height" type="text"  r_id="content" r_attr="padding-right">
														</span>
											</wea:item>
										</wea:group>
									</wea:layout>
										</div>	
										
										
										<div id="fragment-4">
														<%=SystemEnv.getHtmlLabelName(22976,user.getLanguage())%><!-- *只有具有背景色或者背景图时,才有会圆角效果. *选中圆角效果后,边线将会被隐藏. -->
														
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(61,user.getLanguage()) %>'><!-- 基本 -->	
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(22963,user.getLanguage())%><!--上边角 --></span>
											</wea:item>
											<wea:item>	
														<span class='right2 corner'  pos="top" r_id='header'>															
															<input type='radio' name='cornerTop' value='Right'><%=SystemEnv.getHtmlLabelName(22960,user.getLanguage())%><!-- 直角 -->
															<br>
															<input type='radio' name='cornerTop' value='Round' loc="top"><%=SystemEnv.getHtmlLabelName(22961,user.getLanguage())%><!-- 圆角 --><input type="text" style='width:40px' class='inputstyle radian' name='cornerTopRadian'>
														</span>
											</wea:item>
											<wea:item>	
														<span class="left" ><%=SystemEnv.getHtmlLabelName(22964,user.getLanguage())%><!--下边角 --></span>
											</wea:item>
											<wea:item>	
														<span class='right2 corner'  pos="bottom"   r_id='content'>
															<input type='radio' name='cornerBottom' value='Right'><%=SystemEnv.getHtmlLabelName(22960,user.getLanguage())%><!-- 直角 -->
															<br>
															<input type='radio' name='cornerBottom' value='Round' loc="bottom"><%=SystemEnv.getHtmlLabelName(22961,user.getLanguage())%><!-- 圆角 --><input type="text" style='width:40px' class='inputstyle radian' name='cornerBottomRadian'>
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(22965,user.getLanguage())%><!--标题栏 --></span>
											</wea:item>
											<wea:item>	
														<span class="right2">		
															<input type="radio" value="show"  r_id="header"  name="titleState" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><!-- 显示 -->
															<input type="radio" value="hidden" r_id="header" name="titleState" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><!-- 隐藏 -->
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(22966,user.getLanguage())%><!--设置栏 --></span>
											</wea:item>
											<wea:item>	
														<span class="right2">		
															<input type="radio" value="show"  r_id="toolbar" name="settingState"  class="showOrHidden"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><!-- 显示 -->
															<input type="radio" value="hidden" r_id="toolbar" name="settingState" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><!-- 隐藏 -->
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%><!--刷新 --></span>
											</wea:item>
											<wea:item>	
														<span class="right2">		
															<input type="radio" value="show"  r_id="iconRefresh" name="refreshIconState"  class="showOrHidden"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><!-- 显示 -->
															<input type="radio" value="hidden" r_id="iconRefresh" name="refreshIconState" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><!-- 隐藏 -->
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%><!--设置 --></span>
											</wea:item>
											<wea:item>	
														<span class="right2">		
															<input type="radio" value="show"  r_id="iconSetting" name="settingIconState"  class="showOrHidden"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><!-- 显示 -->
															<input type="radio" value="hidden" r_id="iconSetting" name="settingIconState" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><!-- 隐藏 -->
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%><!--关闭 --></span>
											</wea:item>
											<wea:item>	
														<span class="right2">		
															<input type="radio" value="show"  r_id="iconClose" name="closeIconState"  class="showOrHidden"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><!-- 显示 -->
															<input type="radio" value="hidden" r_id="iconClose" name="closeIconState" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><!-- 隐藏 -->
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%></span>
											</wea:item>
											<wea:item>	
														<span class="right2">		
															<input type="radio" value="title"  r_id="iconMore" name="moreLocal"  class="showOrHidden"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><!--标题 -->
															<input type="radio" value="footer"  r_id="iconMore" name="moreLocal"  class="showOrHidden"><%=SystemEnv.getHtmlLabelName(22433,user.getLanguage())%><!--底部 -->
															<input type="radio" value="hidden" r_id="iconMore" name="moreLocal" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><!-- 隐藏 -->
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(22968,user.getLanguage())%><!--图显 --></span>
											</wea:item>
											<wea:item>	
														<span class="right2">		
																<input type="radio" value="page" class="imgMode" name="imgMode"><%=SystemEnv.getHtmlLabelName(22967,user.getLanguage())%><!--页面 -->
																<input type="radio" value="flash" class="imgMode" name="imgMode">Flash
														</span>
											</wea:item>
										</wea:group>
									</wea:layout>


									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22969,user.getLanguage()) %>'><!-- 图标 -->
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(16213,user.getLanguage())%><!--锁定 --></span>
											</wea:item>
											<wea:item>	
														<span class="right2">													
																<input class='filetree'  r_id='iconLock' r_attr='src' name="iconLock">
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(19446,user.getLanguage())%><!--非锁定--></span>
											</wea:item>
											<wea:item>	
														<span class="right2">													
																<input class='filetree'  r_id='iconUnLock' r_attr='src'  name="iconUnLock">
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%><!--刷新 --></span>
											</wea:item>
											<wea:item>	
														<span class="right2">													
																<input class='filetree'  r_id='iconRefresh' r_attr='src'  name="iconRefresh">
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%><!--设置 --></span>
											</wea:item>
											<wea:item>	
														<span class="right2">													
																<input class='filetree'  r_id='iconSetting' r_attr='src'  name="iconSetting">
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%><!--关闭 --></span>
											</wea:item>
											<wea:item>	
														<span class="right2">													
																<input class='filetree'  r_id='iconClose' r_attr='src'  name="iconClose">
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%><!--更多 --></span>
											</wea:item>
											<wea:item>	
														<span class="right2">													
																<input class='filetree'  r_id='iconMore' r_attr='src'  name="iconMore">
														</span>
											</wea:item>
										</wea:group>
									</wea:layout>


									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelName(22970,user.getLanguage()) %>'><!-- TAB页 -->
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(22971,user.getLanguage())%><!--背景条 --></span>
											</wea:item>
											<wea:item>	
														<span class="right2">		
																<input class='filetree'  r_id='tab2' r_attr='background-image'>
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(22972,user.getLanguage())%><!--选中前--></span>
											</wea:item>
											<wea:item>	
														<span class="right2">													
																<input class='filetree'  r_id='tab2unselected' r_attr='background-image'>
														</span>
											</wea:item>
											<wea:item>	
														<span class="left"><%=SystemEnv.getHtmlLabelName(22973,user.getLanguage())%><!--选中后 --></span>
											</wea:item>
											<wea:item>	
														<span class="right2">													
																<input class='filetree'  r_id='tab2selected' r_attr='background-image'>
														</span>
											</wea:item>
										</wea:group>
									</wea:layout>
											
												<%if(false){ %>	
													<%=sm.getFont("tab2unselected",SystemEnv.getHtmlLabelName(16189,user.getLanguage()))%>
												<%} %>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelNames("22970,16189",user.getLanguage()) %>'><!-- 字体 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'>
													<span  id='tab2unselected_color' class='colorblock'  r_id='tab2unselected' r_attr='color'></span>
												</span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(16197,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'><input  class='spin height' type='text'  r_id='tab2unselected' r_attr='font-size'></span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'><input  class='inputstyle_1 height' type='text'    r_id='tab2unselected' r_attr='font-family'>
												<IMG  onclick="setFont(this,'tab2unselected')" style='PADDING-BOTTOM: 0px; MARGIN: 0px 0px 0px 5px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; CURSOR: pointer; PADDING-TOP: 0px'  src='/images/ecology8/request/search-input_wev8.png'   width=13 height=14 >  </span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(1014,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'>
													<%=SystemEnv.getHtmlLabelName(23002,user.getLanguage()) %><input type='checkbox' r_id='tab2unselected' r_attr='font-weight' class='font-weight'>		 
													<%=SystemEnv.getHtmlLabelName(23003,user.getLanguage()) %><input type='checkbox' r_id='tab2unselected' r_attr='font-style' class='font-style' >	
												</span> 
											</wea:item>
										</wea:group>
									</wea:layout>
									
												<%if(false){ %>	
													<%=sm.getFont("tab2selected",SystemEnv.getHtmlLabelName(22978,user.getLanguage()))%>
												<%} %>
									<wea:layout type="menu2col">
										<wea:group context='<%=SystemEnv.getHtmlLabelNames("22970,22978",user.getLanguage()) %>'><!-- 选中后字体 -->
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'>
													<span  id='tab2selected_color' class='colorblock'  r_id='tab2selected' r_attr='color'></span>
												</span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(16197,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'><input  class='spin height' type='text'  r_id='tab2selected' r_attr='font-size'></span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'><input  class='inputstyle_1 height' type='text'    r_id='tab2selected' r_attr='font-family'>
												<IMG  onclick="setFont(this,'tab2selected')" style='PADDING-BOTTOM: 0px; MARGIN: 0px 0px 0px 5px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; CURSOR: pointer; PADDING-TOP: 0px'  src='/images/ecology8/request/search-input_wev8.png'   width=13 height=14 >  </span>
											</wea:item>
											<wea:item>
												<span class='left'><%=SystemEnv.getHtmlLabelName(1014,user.getLanguage()) %></span>
											</wea:item>
											<wea:item>
												<span class='right2'>
													<%=SystemEnv.getHtmlLabelName(23002,user.getLanguage()) %><input type='checkbox' r_id='tab2selected' r_attr='font-weight' class='font-weight'>		 
													<%=SystemEnv.getHtmlLabelName(23003,user.getLanguage()) %><input type='checkbox' r_id='tab2selected' r_attr='font-style' class='font-style' >	
												</span> 
											</wea:item>
										</wea:group>
									</wea:layout>
									
									</div>
								</div>
								
											  
								<div style="width:50%;float:right;height:100%;position:relative;background-color: #ebeef0;" id="divPreview">
									<div style="color:#394a71;padding-top:15px;"><%=SystemEnv.getHtmlLabelName(22974,user.getLanguage())%><!--预览区--></div>
												<div class="height:60px;">&nbsp;</div>
									<div  style="padding:30px;" id='divContainer'>
										<%=su.getContainerForStyle(styleid)%>
									</div>
								</div>										
								<div style="clear:both"></div>								
					</td>
				</tr>
	    </td>
	</tr>
</TABLE>


</div>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
     			<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
	    	</wea:item>
	    </wea:group>
	</wea:layout>
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
				List titlelist = esc.getTitleList();
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
					//console.log($("#css").val());
					frmEdit.submit();
				}
			}
		}

		function onDel(obj){
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
				frmEdit.method.value="del";
				obj.disabled=true;
				frmEdit.submit();			
			})
		}
		
		function onCancel(){
			var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
			dialog.close();
		}
		
		$(document).ready(function(){


			$("#fragment-3").hide();
			$("#fragment-4").hide();
			$(".tab").find("li").bind("click",function(){
				var currentid = $(".selected").attr("href");
				$($(".selected").attr("href")).hide()
				$(".selected").removeClass("selected");
				$(this).addClass("selected");
				$($(this).attr("href")).show();
				
			})
			resizeDialog(document);
			//以下是元素样式中所特有的js方法
			//圆角弧度
			$('.radian').each(function(){
				var cValue="";
				if(this.name=="cornerTopRadian"){
					cValue="<%=esc.getCornerTopRadian(styleid)%>"
				} else if(this.name=="cornerBottomRadian"){
					cValue="<%=esc.getCornerBottomRadian(styleid)%>"
				} 

				this.value=cValue;
				$(this).bind("blur",function(){
					var prevObj=this.previousSibling.previousSibling.previousSibling ;		
							
					if(prevObj.value=="Right") { //直角
						$("."+(prevObj.parentNode.r_id)).uncorner(); 
					} else { //圆角
						$("."+(prevObj.parentNode.r_id)).uncorner(); 						
						$("."+(prevObj.parentNode.r_id)).corner("Round "+prevObj.loc+" "+this.value); 
					}			
				});	
			});
			
			$(".corner").each(function(){
				var cornerTop="<%=esc.getCornerTop(styleid)%>"
				var cornerBottom="<%=esc.getCornerBottom(styleid)%>"					
				//alert(cornerTop+cornerBottom)
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
				
				for(var i=0;i<$(this).find("input[type=radio]").length;i++){		
					var child=$(this).find("input[type=radio]:eq("+i+")")[0];	
					
					$(child).bind("click",function(){	
						$this = $(this);
						changeRadioStatus4tzRadio($this[0], true);	
						//alert($this.prop('outerHTML'))
						//alert($this.attr("checked"))
						if($this.attr("checked")){
							if($this.val()=="Right") { //直角
								$("."+r_id).uncornerById(cPos); 
							} else { //圆角
								$("."+r_id).uncornerById(cPos); 
								var cValueRadian=$($this).parents(".corner:first").find("input.radian").val();
								//alert(r_id+"1");
								
								$("."+r_id).corner(" "+$this.value+" "+cPos+" "+cValueRadian,cPos); 
							}
						}					
					});
					//alert(child.value+"+"+cValue)
					if(child.value==cValue){
						child.checked=true;
						//alert($(child).attr("name")+"*"+$(child).val())
						changeRadioStatus4tzRadio(child, true);
						
						$(child).trigger("click");
						
					}
					
				}
			});
			 
			//标题栏
			$('.showOrHidden').each(function(){
				var r_id=$(this).attr("r_id");
				var cValue="";
				if(this.name=="titleState") cValue="<%=esc.getTitleState(styleid)%>";
				else if(this.name=="settingState") cValue="<%=esc.getSettingState(styleid)%>";
				else if(this.name=="refreshIconState") cValue="<%=esc.getRefreshIconState(styleid)%>";
				else if(this.name=="settingIconState") cValue="<%=esc.getSettingIconState(styleid)%>";
				else if(this.name=="closeIconState") cValue="<%=esc.getCloseIconState(styleid)%>";
				else if(this.name=="moreLocal") cValue="<%=esc.getMoreLocal(styleid)%>";
				

				$(this).bind("click",function(){
					if(this.value=="hidden"){
						$("."+r_id).hide();
					} else{
						$("."+r_id).show();		
						if(this.name=="moreLocal"){
							var objMore=$(".iconMore")[0].parentNode;
							if(this.value=="title"){
								//alert("title")
								$(".toolbar").children("ul li:last").append($(objMore));
							} else if (this.value=="footer"){
								$(".footer").append($(objMore));
								//alert($(".footer").html())
							}
						}
					}		
				});
				if(this.value==cValue){
					this.checked=true;
					$(this).trigger("click");
					changeRadioStatus4tzRadio(this, this.checked);
					
				
				}
			});
			//图片模式
			$('.imgMode').each(function(){
				if(this.value=="<%=esc.getImgMode(styleid)%>"){
					this.checked=true;		
					changeRadioStatus4tzRadio(this, this.checked);
				}
			});


		});	

		/*当主菜单和子菜单的图标发生更改时，处理图标的是否显示判断*/
		  $(".iconEsymbol").bind('error',function(){
				if($(this).attr("src")==''){
					$(this).hide();
				}
		  })
		  
		  $(".iconEsymbol").bind('load',function(){
				if($(this).attr("src")!=''){
					$(this).show();
				}
		  })
		  
		  $(".toolbar").find("img").bind('error',function(){
				if($(this).attr("src")==''){
					$(this).hide();
				}
		  })
		  
		   $(".toolbar").find("img").bind('load',function(){
				if($(this).attr("src")!=''){
					$(this).show();
				}
		  })
		$(".zDialog_div_content").bind("scroll",function(){
			$("#divPreview").css("top",$(this).scrollTop());
		})
		
		
		function onBack(){
			location.href='/page/maint/style/ElementStyleList.jsp';
		}
	</script>
