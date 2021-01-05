
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.workflow.exceldesign.OthersMethod,java.util.*" %>
<HTML><HEAD>
	<%
		int bxsize = Util.getIntValue(Util.null2String(request.getParameter("bxsize")),1);
		String excelid = Util.null2String(request.getParameter("excelid"));
	%>
	<link type="text/css" href="/workflow/exceldesign/css/formatSetting_wev8.css" rel="stylesheet" />
	<!-- 不能引用jQuery导致美化下拉框不出现竖向滚动条 -->
	<!-- <script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>	-->
	<!-- <script type="text/javascript" src="/workflow/exceldesign/js/jquery-1.8.2.min_wev8.js"></script> -->
	<script type="text/javascript" src="/workflow/exceldesign/js/jquery.msDropDown_wev8.js"></script>
	<link type="text/css" rel="stylesheet" href="/workflow/exceldesign/css/jquery.msDropDown_wev8.css"/>
	<script type="text/javascript" src="/workflow/exceldesign/js/jquery-ui_wev8.js"></script>
	<script type="text/javascript" src="/workflow/exceldesign/js/jquery-ui-1.9.1.custom.min_wev8.js"></script>
	<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
	<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
	<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/spectrum/spectrum_wev8.js"></script>
	<link type="text/css" rel="stylesheet" href="/js/ecology8/spectrum/spectrum_wev8.css"/>
	<!-- 表格 -->
	<script type="text/javascript" src="/workflow/exceldesign/js/baseOperate_wev8.js"></script>
	<script type="text/javascript" src="/workflow/exceldesign/js/designOperate_wev8.js"></script>
	 
	 
	<script type="text/javascript" src="/workflow/exceldesign/js/excelRightClickOperat_wev8.js"></script>
	
	<script type="text/javascript">
		var bxsize = <%=bxsize%>;
		var excelid = "<%=excelid%>";
		var dialog;
		jQuery(document).ready(function(){
			rightClickOperat.initSetFormatPanel();
			dialog = window.top.getDialog(parent);
			$(".bgfillTab").find(".sp-thumb-el").each(function(){
				$(this).click(function (){
					if($(this).is(".sp-thumb-active")) return;
					$(".sp-thumb-active").removeClass("sp-thumb-active");
					$(this).addClass("sp-thumb-active");
					rightClickOperat.onSetBgfillFace($(this));
				});
				
			});
			
			$(".sp-no-color").click(function(){
				if($(this).children("div.sp-thumb-el").is(".sp-thumb-active")) return;
				$(".sp-thumb-active").removeClass("sp-thumb-active");
				$(this).children("div.sp-thumb-el").addClass("sp-thumb-active");
				rightClickOperat.onSetBgfillFace($(this).children("div.sp-thumb-el"));
			});
		});
		
		//父页面上 需要调用此方法 ，iframe 不做src跳转，所以，点击tab页面，直接在子页面（本页面）切换
		function changeTab(type)
		{
			if($("[name='"+type+"']").is(".selected"))
			return;
			jQuery(".formatTab").children("div").hide();
			jQuery(".formatTab").children("div").each(function(){
				$(this).removeClass("selected");
			});
			$("[name='"+type+"']").addClass("selected");
			jQuery(".formatTab").children("div[name='"+type+"']").show();			
		}
		
		//清空 边框
		function onSetBorder_non(obj)
		{
			$("#borderTop,#borderBottom,#borderLeft,#borderRight,#borderHorize,#borderVertic").removeClass("opBtn_down").removeAttr("down").removeAttr("t_value").removeAttr("t_color");
			rightClickOperat.onSetBorderFace(obj);
		}
		
		//外围边框
		function onSetBorder_out(obj)
		{
			$("#borderTop,#borderBottom,#borderLeft,#borderRight").addClass("opBtn_down").attr("down","on").attr("t_value",$(".borderTab .fmlist ul li.current").attr("value"))
				.attr("t_color",$(".borderTab [name=_bordercolor]").val());
			rightClickOperat.onSetBorderFace(obj);
		}
		//内部 边框
		function onSetBorder_inn(obj)
		{
			if($(obj).is(".opBtn_inn_disabled")) return;
			$("#borderHorize,#borderVertic").addClass("opBtn_down").attr("down","on").attr("t_value",$(".borderTab .fmlist ul li.current").attr("value"))
				.attr("t_color",$(".borderTab [name=_bordercolor]").val());
			rightClickOperat.onSetBorderFace(obj);
		}
		
		
	</script>
</HEAD>
<BODY>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
     	RCMenu += "{"+SystemEnv.getHtmlLabelName(826, user.getLanguage())+",javascript:rightClickOperat.onsavesetting(),_top} " ;
     	RCMenuHeight += RCMenuHeightStep;
     	RCMenu += "{"+SystemEnv.getHtmlLabelName(201, user.getLanguage())+",javascript:dialog.close(),_top} " ;
     	RCMenuHeight += RCMenuHeightStep;
	%>
	<div class="zDialog_div_content" id="zDialog_div_content" style="overflow:hidden;">   	
	      		
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
									
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table> 
		<div class="formatTab">
			<div name="number" class="numberTab selected">
				<div class="leftClassify">
					<span><%=SystemEnv.getHtmlLabelName(455, user.getLanguage())%> :</span>
					<div class="fmlist">
						<ul>
							<li target="1" class="current"><%=SystemEnv.getHtmlLabelName(128022, user.getLanguage())%></li>
							<li target="2"><%=SystemEnv.getHtmlLabelName(17639, user.getLanguage())%></li>
							<li target="3"><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%></li>
							<li target="4"><%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%></li>
							<li target="5"><%=SystemEnv.getHtmlLabelName(1464, user.getLanguage())%></li>
							<li target="6"><%=SystemEnv.getHtmlLabelName(128014, user.getLanguage())%></li>
							<li target="7" style="display:none"><%=SystemEnv.getHtmlLabelName(608, user.getLanguage())%></li>
							<li target="8"><%=SystemEnv.getHtmlLabelName(129756, user.getLanguage())%></li>
						</ul>
					</div>
				</div>
				<div class="rightSetting">
					<div class="general numberlist" target="1"><%=SystemEnv.getHtmlLabelName(128015, user.getLanguage())%></div>
					<div class="numerical numberlist" target="2" style="display:none;">
						<div class="eightBtm"><%=SystemEnv.getHtmlLabelName(15212, user.getLanguage())%> : <input id="n_decimals" name="decimals" value="2"></input></div>
						<div class="eightBtm"><input type="checkbox" id="n_us" > <%=SystemEnv.getHtmlLabelName(128977, user.getLanguage())%> ( , )</input></div>
						<span><%=SystemEnv.getHtmlLabelName(128016, user.getLanguage())%> : </span>
						<div class="fmlist" style="width:90%;">
							<ul>
								<li pro_index="1" target="1"><label style="color:red">-1234.01</label></li>
								<li pro_index="2" target="2" class="current"><label style="color:#464646">-1234.01</label></li>
								<li pro_index="3" target="3"><label style="color:#464646">1234.01</label></li>
								<li pro_index="4" target="4"><label style="color:red">1234.01</label></li>
							</ul>
						</div>
					</div>
					<div class="date numberlist" target="3" style="display:none;">
						<span><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%> : </span>
						<div class="fmlist" style="width:90%;">
							<ul>
								<li pro_index="1" target="[$-411]yyyy/m/d" class="current">2013/3/14</li>
								<li pro_index="2" target="[$-411]yyyy-m-d">2013-3-14</li>
								<li pro_index="3" target="[$-411]yyyy年m月d日">2013年3月14日</li>
								<li pro_index="4" target="[$-411]yyyy年m月">2013年3月</li>
								<li pro_index="5" target="[$-411]m月d日">3月14日</li>
								<li pro_index="6" target="[$-F800]dddd">星期三</li>
								<li pro_index="7" target="[DBNum1][$-411] yyyy年m月d日">二〇一三年三月十四日</li>
								<li pro_index="8" target="yyyy/m/d HH:mm tt">2013/3/14 10:13 AM</li>
								<li pro_index="9" target="yyyy/m/d HH:mm">2013/3/14 10:13</li>
							</ul>
						</div>
					</div>
					<div class="time numberlist" target="4" style="display:none;">
						<span><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%> : </span>
						<div class="fmlist" style="width:90%;">
							<ul>
								<li pro_index="1" target="HH:mm:ss" class="current">10:13:25</li>
								<li pro_index="2" target="HH:mm:ss tt">10:13:25 AM</li>
								<li pro_index="3" target="HH:mm">10:13</li>
								<li pro_index="4" target="HH:mm tt">10:13 AM</li>
								<li pro_index="5" target="h时mm分ss秒 ">10时13分25秒 </li>
								<li pro_index="6" target="h时mm分 ">10时13分</li>
								<li pro_index="7" target="h时mm分ss秒 AM/PM">10时13分25秒 AM/PM</li>
								<li pro_index="8" target="h时mm分 AM/PM">10时13分 AM/PM</li>
							</ul>
						</div>
					</div>
					<div class="percent numberlist" target="5" style="display:none;">
						<div class="eightBtm"><%=SystemEnv.getHtmlLabelName(15212, user.getLanguage())%> : <input id="p_decimals" name="decimals" value="2"></input></div>
					</div>
					<div class="science numberlist" target="6" style="display:none;">
						<div class="eightBtm"><%=SystemEnv.getHtmlLabelName(15212, user.getLanguage())%> : <input id="s_decimals" name="decimals" value="2"></input></div>
					</div>
					<div class="textversion numberlist" target="7" style="display:none;margin-right:40px">
						<%=SystemEnv.getHtmlLabelName(128018, user.getLanguage())%>
					</div>
					<div class="special numberlist" target="8" style="display:none;">
						<span><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%> : </span>
						<div class="fmlist" style="width:90%;">
							<ul>
								<li pro_index="1" target="[DBNum1][$-411]General" class="current"><%=SystemEnv.getHtmlLabelName(128978, user.getLanguage())%></li>
								<li pro_index="2" target="[DBNum2][$-411]General"><%=SystemEnv.getHtmlLabelName(128979, user.getLanguage())%></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
			<div name="align" class="alignTab" style="display:none">
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelNames("608,127996,599", user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(128980, user.getLanguage())%></wea:item>
						<wea:item>
							<select id="halign" style="width:120px;">
								<!-- <option value="-1">常规</option>	 -->
								<option value="0"><%=SystemEnv.getHtmlLabelName(23176, user.getLanguage())%></option>
								<option value="1"><%=SystemEnv.getHtmlLabelName(16203, user.getLanguage())%></option>
								<option value="2"><%=SystemEnv.getHtmlLabelName(23177, user.getLanguage())%></option>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(128981, user.getLanguage())%></wea:item>
						<wea:item>
							<select id="valign" style="width:120px;">
								<!-- <option value="-1">常规</option>	-->
								<option value="0"><%=SystemEnv.getHtmlLabelName(128019, user.getLanguage())%></option>
								<option value="1"><%=SystemEnv.getHtmlLabelName(16203, user.getLanguage())%></option>
								<option value="2"><%=SystemEnv.getHtmlLabelName(128020, user.getLanguage())%></option>
							</select>
						</wea:item>
					</wea:group>
					<wea:group context="<%=SystemEnv.getHtmlLabelName(128982, user.getLanguage())%>">
						<%-- 
						<wea:item>自动换行</wea:item>
						<wea:item><input type="checkbox" tzCheckbox="true" class="InputStyle" id="autowrap"> </input></wea:item>
						--%>
						<wea:item><%=SystemEnv.getHtmlLabelName(129058, user.getLanguage())%></wea:item>
						<wea:item>
							<select id="mergeattr" style="width:120px">
								<option value="0"><%=SystemEnv.getHtmlLabelName(129057, user.getLanguage())%></option>
								<option value="1"><%=SystemEnv.getHtmlLabelName(126702, user.getLanguage())%></option>
								<option value="2"><%=SystemEnv.getHtmlLabelName(216, user.getLanguage())%></option>
							</select>
						</wea:item>
					</wea:group>
				</wea:layout>
				
			</div>
			<div name="font" class="fontTab" style="display:none">
				<wea:layout type="2col">
					<wea:group context="<%=SystemEnv.getHtmlLabelName(128983, user.getLanguage())%>">
						<wea:item><%=SystemEnv.getHtmlLabelName(16189, user.getLanguage())%></wea:item>
						<wea:item>
							<select id="fontfamily" onchange="rightClickOperat.onSetFontFace(this)" style="width:120px;">
								<option value="SimSun"><%=SystemEnv.getHtmlLabelName(16190, user.getLanguage())%></option>
								<option value="SimHei"><%=SystemEnv.getHtmlLabelName(16192, user.getLanguage())%></option>
								<option value="Microsoft YaHei" selected="selected"><%=SystemEnv.getHtmlLabelName(84210, user.getLanguage())%></option>
								<option value="KaiTi"><%=SystemEnv.getHtmlLabelName(16195, user.getLanguage())%></option>
								<option value="YouYuan"><%=SystemEnv.getHtmlLabelName(127991, user.getLanguage())%></option>
								<option value="FangSong"><%=SystemEnv.getHtmlLabelName(16196, user.getLanguage())%></option>
								<%for(Map.Entry<String,String> entry: OthersMethod.supportFontfamilyMap.entrySet()){	%>
									<option value="<%=entry.getKey() %>"><%=entry.getValue() %></option>
								<%}%>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(128021, user.getLanguage())%></wea:item>
						<wea:item>
							<select id="fontStyle" onchange="rightClickOperat.onSetFontFace(this)" style="width:120px;">
								<option value="0"><%=SystemEnv.getHtmlLabelName(128022, user.getLanguage())%></option>
								<option value="1"><%=SystemEnv.getHtmlLabelName(23003, user.getLanguage())%></option>
								<option value="2"><%=SystemEnv.getHtmlLabelName(23002, user.getLanguage())%></option>
								<option value="3"><%=SystemEnv.getHtmlLabelName(23003, user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(23002, user.getLanguage())%></option>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(16197, user.getLanguage())%></wea:item>
						<wea:item>
							<select id="fontSize" onchange="rightClickOperat.onSetFontFace(this)" style="width:120px;">
								<option value="6pt">6</option>
								<option value="8pt">8</option>
								<option value="9pt" selected="selected">9</option>
								<option value="10pt">10</option>
								<option value="11pt">11</option>
								<option value="12pt">12</option>
								<option value="14pt">14</option>
								<option value="16pt">16</option>
								<option value="18pt">18</option>
								<option value="20pt">20</option>
								<option value="22pt">22</option>
								<option value="24pt">24</option>
								<option value="26pt">26</option>
								<option value="28pt">28</option>
								<option value="32pt">32</option>
								<option value="48pt">48</option>
								<option value="72pt">72</option>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(495, user.getLanguage())%></wea:item>
						<wea:item>
							<div id="fontcolor" name="colorpick4bx" style="width:44px;height:20px;background:#000;border:1px solid #d9d9d9">
								<input type="hidden" name="_fontcolor" value="#000000" />
							</div>
						</wea:item>
					</wea:group>
					<wea:group context="<%=SystemEnv.getHtmlLabelName(128984, user.getLanguage())%>">
						<wea:item><%=SystemEnv.getHtmlLabelName(16200, user.getLanguage())%></wea:item>
						<wea:item><input type="checkbox" tzCheckbox="true" class="InputStyle" id="underline" onclick="rightClickOperat.onSetFontFace(this)"></input></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(128023, user.getLanguage())%></wea:item>
						<wea:item><input type="checkbox" tzCheckbox="true" class="InputStyle" id="deleteline" onclick="rightClickOperat.onSetFontFace(this)"></input></wea:item>
					</wea:group>
					<wea:group context="<%=SystemEnv.getHtmlLabelName(23690, user.getLanguage())%>">
						<wea:item>
							<div class="fontPreview" id="fontPreview" ><font id="fontshow" style="font-family:Microsoft YaHei!important"><%=SystemEnv.getHtmlLabelName(128024, user.getLanguage())%> AaBbCc</font></div>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
			<div name="border" class="borderTab" style="display:none">
				<div class="leftClassify">
					<span><%=SystemEnv.getHtmlLabelName(128025, user.getLanguage())%> :</span>
					<div class="fmlist" style="margin-bottom:8px;">
						<ul style="height:250px;overflow-y: auto;overflow-x: hidden;">
							<li value="1" target="1px solid" class="current"><img src="/workflow/exceldesign/image/border/_thin_wev8.png" border="0"></img></li>
							<li value="2" target="2px solid"><img src="/workflow/exceldesign/image/border/_medium_wev8.png" border="0"></img></li>
							<li value="3" target="1px dashed"><img src="/workflow/exceldesign/image/border/_dashed_wev8.png" border="0"></img></li>
							<!-- <li target="4"><img src="/workflow/exceldesign/image/border/_dotted_wev8.png" border="0"></img></li> -->
							<li value="5" target="3px solid"><img src="/workflow/exceldesign/image/border/_thick_wev8.png" border="0"></img></li>
							<li value="6" target="3px double"><img src="/workflow/exceldesign/image/border/_double_wev8.png" border="0"></img></li>
							<li value="7" target="1px dotted"><img src="/workflow/exceldesign/image/border/_hair_wev8.png" border="0"></img></li>
							<li value="8" target="2px dashed"><img src="/workflow/exceldesign/image/border/_mediumdashed_wev8.png" border="0"></img></li>
							<!--<li target="9"><img src="/workflow/exceldesign/image/border/_dashdot_wev8.png" border="0"></img></li>
							<li target="10"><img src="/workflow/exceldesign/image/border/_mediumdashdot_wev8.png" border="0"></img></li>
							<li target="11"><img src="/workflow/exceldesign/image/border/_dashdotdot_wev8.png" border="0"></img></li>
							<li target="12"><img src="/workflow/exceldesign/image/border/_mediumdashdotdot_wev8.png" border="0"></img></li>-->
						</ul>
					</div>
					<span style="padding:8px;"><%=SystemEnv.getHtmlLabelName(128985, user.getLanguage())%> :</span>
					<div id="bordercolor" name="colorpick4bx" style="width:44px;height:20px;margin:3px;background:#000;border:1px solid #d9d9d9">
						<input type="hidden" name="_bordercolor" value="#000001" />
					</div>
				</div>
				<div class="rightSetting">
					<div style="padding:8px"><%=SystemEnv.getHtmlLabelName(128027, user.getLanguage())%></div>
					<table style="margin-left:40px;">
						<tr>
							<td>	
								<div class="opBtn" name="nonside" onclick="onSetBorder_non(this)"><img src="/workflow/exceldesign/image/shortBtn/noBorder_wev8.png"></img><br/><span><%=SystemEnv.getHtmlLabelName(83230, user.getLanguage())%></span></div>
								<div class="opBtn" name="outside" onclick="onSetBorder_out(this)"><img src="/workflow/exceldesign/image/shortBtn/outBorder_wev8.png"></img><br/><span><%=SystemEnv.getHtmlLabelName(1995, user.getLanguage())%></span></div>
								<div class="<%=(bxsize > 1)?"opBtn":"opBtn_inn_disabled" %>" name="innside" onclick="onSetBorder_inn(this)"><img src="/workflow/exceldesign/image/shortBtn/inBorder_wev8.png"></img><br/><span><%=SystemEnv.getHtmlLabelName(1994, user.getLanguage())%></span></div>
							</td>
						</tr>
					</table>
					<div style="padding:8px"><%=SystemEnv.getHtmlLabelName(128028, user.getLanguage())%></div>
					<div class="drawBorder">
						<div class="opBtn opBtn_s" id="borderTop" style="top:0px;left:0px;" onclick="rightClickOperat.onSetBorderFace(this)"><img src="/workflow/exceldesign/image/shortBtn/format/BorderTop_wev8.png"></img></div>
						<div class="opBtn opBtn_s" id="borderHorize" style="top:40px;left:-34px;visibility:<%=(bxsize > 1)?"visible;":"hidden;" %>" onclick="rightClickOperat.onSetBorderFace(this)"><img src="/workflow/exceldesign/image/shortBtn/format/BorderHorizontal_wev8.png"></img></div>
						<div class="opBtn opBtn_s" id="borderBottom" style="top:80px;left:-68px;" onclick="rightClickOperat.onSetBorderFace(this)"><img src="/workflow/exceldesign/image/shortBtn/format/BorderBottom_wev8.png"></img></div>
						<div class="opBtn opBtn_s" id="borderLeft" style="top:115px;left:-75px;" onclick="rightClickOperat.onSetBorderFace(this)"><img src="/workflow/exceldesign/image/shortBtn/format/BorderLeft_wev8.png"></img></div>
						<div class="opBtn opBtn_s" id="borderVertic" style="top:115px;left:-20px;visibility:<%=(bxsize > 1)?"visible;":"hidden;" %>" onclick="rightClickOperat.onSetBorderFace(this)"><img src="/workflow/exceldesign/image/shortBtn/format/BorderVertical_wev8.png"></img></div>
						<div class="opBtn opBtn_s" id="borderRight" style="top:115px;left:35px" onclick="rightClickOperat.onSetBorderFace(this)"><img src="/workflow/exceldesign/image/shortBtn/format/BorderRight_wev8.png"></img></div>
						<div class="opDrawShow"  cellpadding="0" cellspacing="0">
							<table>
								<tr>
									<td name="onebx"><%=SystemEnv.getHtmlLabelName(608, user.getLanguage())%></td>
									<%if(bxsize > 1){ %>
									<td name="twobx"><%=SystemEnv.getHtmlLabelName(608, user.getLanguage())%></td>
									<%} %>
								</tr>
							<%if(bxsize > 1){ %>
								<tr>
									<td name="thrbx"><%=SystemEnv.getHtmlLabelName(608, user.getLanguage())%></td>
									<td name="forbx"><%=SystemEnv.getHtmlLabelName(608, user.getLanguage())%></td>
								</tr>
							<%} %>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div name="bgfill" class="bgfillTab" style="display:none">
				<div class="sp-light sp-input-disabled sp-initial-disabled" style="padding:8px;" >
				<div class="sp-no-color sp-palette" style="width:193px;height:20px;margin:3px;border: 1px solid #d0d0d0;cursor: pointer;"><div class=" sp-thumb-el sp-thumb-light" data-color="transparents" style="border:none;"><span class="sp-thumb-inner" style="background-color:rgb(255, 255, 255);"></span></div><div style="padding: 2px;">无颜色</div></div>
				<div class="sp-palette sp-thumb sp-cf">
				<div class="sp-cf sp-palette-row sp-palette-row-0">
					<span title="rgb(0, 0, 0)" data-color="#000001" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(0, 0, 0);"></span></span>
					<span title="rgb(67, 67, 67)" data-color="#434343" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(67, 67, 67);"></span></span>
					<span title="rgb(102, 102, 102)" data-color="#666666" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(102, 102, 102);"></span></span>
					<span title="rgb(153, 153, 153)" data-color="#999999" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(153, 153, 153);"></span></span>
					<span title="rgb(183, 183, 183)" data-color="#b7b7b7" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(183, 183, 183);"></span></span>
					<span title="rgb(204, 204, 204)" data-color="#cccccc" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(204, 204, 204);"></span></span>
					<span title="rgb(217, 217, 217)" data-color="#d9d9d9" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(217, 217, 217);"></span></span>
					<span title="rgb(239, 239, 239)" data-color="#efefef" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(239, 239, 239);"></span></span>
					<span title="rgb(243, 243, 243)" data-color="#f3f3f3" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(243, 243, 243);"></span></span>
					<span title="rgb(255, 255, 255)" data-color="#ffffff" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(255, 255, 255);"></span></span>
				</div>
				<div class="sp-cf sp-palette-row sp-palette-row-1">
					<span title="rgb(152, 0, 0)" data-color="#980000" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(152, 0, 0);"></span></span>
					<span title="rgb(255, 0, 0)" data-color="#ff0000" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(255, 0, 0);"></span></span>
					<span title="rgb(255, 153, 0)" data-color="#ff9900" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(255, 153, 0);"></span></span>
					<span title="rgb(255, 255, 0)" data-color="#ffff00" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(255, 255, 0);"></span></span>
					<span title="rgb(0, 255, 0)" data-color="#00ff00" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(0, 255, 0);"></span></span>
					<span title="rgb(0, 255, 255)" data-color="#00ffff" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(0, 255, 255);"></span></span>
					<span title="rgb(74, 134, 232)" data-color="#4a86e8" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(74, 134, 232);"></span></span>
					<span title="rgb(0, 0, 255)" data-color="#0000ff" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(0, 0, 255);"></span></span>
					<span title="rgb(153, 0, 255)" data-color="#9900ff" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(153, 0, 255);"></span></span>
					<span title="rgb(255, 0, 255)" data-color="#ff00ff" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(255, 0, 255);"></span></span>
				</div>
				<div class="sp-cf sp-palette-row sp-palette-row-2">
					<span title="rgb(230, 184, 175)" data-color="#e6b8af" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(230, 184, 175);"></span></span>
					<span title="rgb(244, 204, 204)" data-color="#f4cccc" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(244, 204, 204);"></span></span>
					<span title="rgb(252, 229, 205)" data-color="#fce5cd" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(252, 229, 205);"></span></span>
					<span title="rgb(255, 242, 204)" data-color="#fff2cc" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(255, 242, 204);"></span></span>
					<span title="rgb(236, 234, 211)" data-color="#ecead3" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(236, 234, 211);"></span></span>
					<span title="rgb(217, 234, 211)" data-color="#d9ead3" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(217, 234, 211);"></span></span>
					<span title="rgb(201, 218, 248)" data-color="#c9daf8" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(201, 218, 248);"></span></span>
					<span title="rgb(207, 226, 243)" data-color="#cfe2f3" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(207, 226, 243);"></span></span>
					<span title="rgb(217, 210, 233)" data-color="#d9d2e9" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(217, 210, 233);"></span></span>
					<span title="rgb(234, 209, 220)" data-color="#ead1dc" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(234, 209, 220);"></span></span>
				</div>
				<div class="sp-cf sp-palette-row sp-palette-row-3">
					<span title="rgb(221, 126, 107)" data-color="#dd7e6b" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(221, 126, 107);"></span></span>
					<span title="rgb(234, 153, 153)" data-color="#ea9999" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(234, 153, 153);"></span></span>
					<span title="rgb(249, 203, 156)" data-color="#f9cb9c" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(249, 203, 156);"></span></span>
					<span title="rgb(255, 229, 153)" data-color="#ffe599" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(255, 229, 153);"></span></span>
					<span title="rgb(182, 215, 168)" data-color="#b6d7a8" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(182, 215, 168);"></span></span>
					<span title="rgb(162, 196, 201)" data-color="#a2c4c9" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(162, 196, 201);"></span></span>
					<span title="rgb(164, 194, 244)" data-color="#a4c2f4" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(164, 194, 244);"></span></span>
					<span title="rgb(159, 197, 232)" data-color="#9fc5e8" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(159, 197, 232);"></span></span>
					<span title="rgb(180, 167, 214)" data-color="#b4a7d6" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(180, 167, 214);"></span></span>
					<span title="rgb(213, 166, 189)" data-color="#d5a6bd" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(213, 166, 189);"></span></span>
				</div>
				<div class="sp-cf sp-palette-row sp-palette-row-4">
					<span title="rgb(204, 65, 37)" data-color="#cc4125" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(204, 65, 37);"></span></span>
					<span title="rgb(224, 102, 102)" data-color="#e06666" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(224, 102, 102);"></span></span>
					<span title="rgb(246, 178, 107)" data-color="#f6b26b" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(246, 178, 107);"></span></span>
					<span title="rgb(255, 217, 102)" data-color="#ffd966" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(255, 217, 102);"></span></span>
					<span title="rgb(147, 196, 125)" data-color="#93c47d" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(147, 196, 125);"></span></span>
					<span title="rgb(118, 165, 175)" data-color="#76a5af" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(118, 165, 175);"></span></span>
					<span title="rgb(109, 158, 235)" data-color="#6d9eeb" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(109, 158, 235);"></span></span>
					<span title="rgb(111, 168, 220)" data-color="#6fa8dc" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(111, 168, 220);"></span></span>
					<span title="rgb(142, 124, 195)" data-color="#8e7cc3" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(142, 124, 195);"></span></span>
					<span title="rgb(194, 123, 160)" data-color="#c27ba0" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(194, 123, 160);"></span></span>
				</div>
				<div class="sp-cf sp-palette-row sp-palette-row-5">
					<span title="rgb(166, 28, 0)" data-color="#a61c00" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(166, 28, 0);"></span></span>
					<span title="rgb(204, 0, 0)" data-color="#cc0000" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(204, 0, 0);"></span></span>
					<span title="rgb(230, 145, 56)" data-color="#e69138" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(230, 145, 56);"></span></span>
					<span title="rgb(241, 194, 50)" data-color="#f1c232" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(241, 194, 50);"></span></span>
					<span title="rgb(106, 168, 79)" data-color="#6aa84f" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(106, 168, 79);"></span></span>
					<span title="rgb(69, 129, 142)" data-color="#45818e" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(69, 129, 142);"></span></span>
					<span title="rgb(60, 120, 216)" data-color="#3c78d8" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(60, 120, 216);"></span></span>
					<span title="rgb(61, 133, 198)" data-color="#3d85c6" class="sp-thumb-el sp-thumb-light"><span class="sp-thumb-inner" style="background-color:rgb(61, 133, 198);"></span></span>
					<span title="rgb(103, 78, 167)" data-color="#674ea7" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(103, 78, 167);"></span></span>
					<span title="rgb(166, 77, 121)" data-color="#a64d79" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(166, 77, 121);"></span></span>
				</div>
				<div class="sp-cf sp-palette-row sp-palette-row-6">
					<span title="rgb(133, 32, 12)" data-color="#85200c" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(133, 32, 12);"></span></span>
					<span title="rgb(153, 0, 0)" data-color="#990000" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(153, 0, 0);"></span></span>
					<span title="rgb(180, 95, 6)" data-color="#b45f06" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(180, 95, 6);"></span></span>
					<span title="rgb(191, 144, 0)" data-color="#bf9000" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(191, 144, 0);"></span></span>
					<span title="rgb(56, 118, 29)" data-color="#38761d" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(56, 118, 29);"></span></span>
					<span title="rgb(19, 79, 92)" data-color="#134f5c" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(19, 79, 92);"></span></span>
					<span title="rgb(17, 85, 204)" data-color="#1155cc" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(17, 85, 204);"></span></span>
					<span title="rgb(11, 83, 148)" data-color="#0b5394" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(11, 83, 148);"></span></span>
					<span title="rgb(53, 28, 117)" data-color="#351c75" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(53, 28, 117);"></span></span>
					<span title="rgb(116, 27, 71)" data-color="#741b47" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(116, 27, 71);"></span></span>
				</div>
				<div class="sp-cf sp-palette-row sp-palette-row-7">
					<span title="rgb(91, 15, 0)" data-color="#5b0f00" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(91, 15, 0);"></span></span>
					<span title="rgb(102, 0, 0)" data-color="#660000" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(102, 0, 0);"></span></span>
					<span title="rgb(120, 63, 4)" data-color="#783f04" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(120, 63, 4);"></span></span>
					<span title="rgb(127, 96, 0)" data-color="#7f6000" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(127, 96, 0);"></span></span>
					<span title="rgb(39, 78, 19)" data-color="#274e13" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(39, 78, 19);"></span></span>
					<span title="rgb(12, 52, 61)" data-color="#0c343d" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(12, 52, 61);"></span></span>
					<span title="rgb(28, 69, 135)" data-color="#1c4587" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(28, 69, 135);"></span></span>
					<span title="rgb(7, 55, 99)" data-color="#073763" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(7, 55, 99);"></span></span>
					<span title="rgb(32, 18, 77)" data-color="#20124d" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(32, 18, 77);"></span></span>
					<span title="rgb(76, 17, 48)" data-color="#4c1130" class="sp-thumb-el sp-thumb-dark"><span class="sp-thumb-inner" style="background-color:rgb(76, 17, 48);"></span></span>
				</div>
				<div class="sp-cf sp-palette-row sp-palette-row-selection"></div>
				</div>
				</div>
			</div>
		</div>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" id="zd_btn_submit" onclick="rightClickOperat.onsavesetting()" class="zd_btn_submit">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
				</wea:item>
			</wea:group>
		</wea:layout>      
	  </div>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>
