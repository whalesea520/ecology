
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>

<%
	String isDetail = Util.null2String(request.getParameter("isDetail"));
	int d_num = Util.getIntValue(Util.null2String(request.getParameter("d_num")));
	int d_identy = Util.getIntValue(Util.null2String(request.getParameter("d_identy")));
	int layouttype = Util.getIntValue(request.getParameter("layouttype"), -1);
%>
<HTML><HEAD>
	
</HEAD>
<BODY>
<div class="excelHeadContent">
	<table class="excelHeadTable s_format" <%=(isDetail.equals("on"))?"style=display:none":""%> cellpadding="0" cellspacing="0">
		<tbody>
			<tr>
				<td class="splitTHead">
					<div title="字体" class="operatDiv" style="width:128px;">
					<select id="fontfamily" name="fontfamily" style="width:100%">
						<option value="SimSun">宋体</option>
						<option value="SimHei">黑体</option>
						<option value="Microsoft YaHei" selected="selected">微软雅黑</option>
						<option value="KaiTi">楷体</option>
						<option value="YouYuan">幼圆</option>
						<option value="FangSong">仿宋</option>
						<option value="仿宋_GB2312">仿宋_GB2312</option>
						<option value="方正黑体_GBK">方正黑体_GBK</option>
						<option value="方正大标宋简体">方正大标宋简体</option>
						<option value="方正小标宋简体">方正小标宋简体</option>
					</select>
					</div>
					<div class="operatDiv" style="width:50px;">
					<select id="fontsize" name="fontsize" style="width:55px">
						<option value="6pt">6</option>
						<option value="8pt">8</option>
						<option value="9pt" selected="selected">9</option>
						<option value="10pt">10</option>
						<option value="11pt">11</option>
						<option value="12pt">12</option>
						<option value="14pt">14</option>
						<option value="16pt">16</option>
						<option value="20pt">20</option>
						<option value="22pt">22</option>
						<option value="24pt">24</option>
						<option value="26pt">26</option>
						<option value="28pt">28</option>
						<option value="32pt">32</option>
						<option value="48pt">48</option>
						<option value="72pt">72</option>
					</select>
					</div>
				</td>
				<td target="mc_hide">
					<div title="顶端对齐" name="topAlign" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/topAlign_wev8.png" border="0"/></div>
					<div title="垂直居中" name="middelAlign" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/middelAlign_wev8.png" border="0"/></div>
					<div title="底部对齐" name="bottomAlign" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/bottomAlign_wev8.png" border="0"/></div>
				</td>
				<td class="splitTHead" target="mc_splithide">
					<div title="增加缩进量" name="leftretract" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/rightretract_wev8.png" border="0"/></div>
				</td>
				<td class="splitTHead" target="mc_hide">
					<div class="operatDiv operatSelect" title="边框类型" >
						<select id="borderline" notBeauty=true name="borderline" style="width:50px;">
							<option value=1 data-image='/formmode/exceldesign/image/border/_thin_wev8.png'></option>
		                    <option value=2 data-image='/formmode/exceldesign/image/border/_medium_wev8.png'></option>
		                    <option value=3 data-image='/formmode/exceldesign/image/border/_dashed_wev8.png'></option>
		                    <!-- <option value=4 data-image='/formmode/exceldesign/image/border/_dotted_wev8.png'></option> -->
		                    <option value=5 data-image='/formmode/exceldesign/image/border/_thick_wev8.png'></option>
		                    <option value=6 data-image='/formmode/exceldesign/image/border/_double_wev8.png'></option>
		                    <option value=7 data-image='/formmode/exceldesign/image/border/_hair_wev8.png'></option>
		                    <option value=8 data-image='/formmode/exceldesign/image/border/_mediumdashed_wev8.png'></option>
		                   <!--  <option value=9 data-image='/formmode/exceldesign/image/border/_dashdot_wev8.png'></option>
		                    <option value=10 data-image='/formmode/exceldesign/image/border/_mediumdashdot_wev8.png'></option>
		                    <option value=11 data-image='/formmode/exceldesign/image/border/_dashdotdot_wev8.png'></option>
		                    <option value=12 data-image='/formmode/exceldesign/image/border/_mediumdashdotdot_wev8.png'></option> -->
	                   	</select>
					</div>
					<div class="operatDiv" title="边框颜色">
						<div class="showforcolor" target="bordercolor">
							<img src="/formmode/exceldesign/image/shortBtn/format/BorderColor_wev8.png" border="0" style="vertical-align: bottom"/>
							<div class='pickcolordiv'>
								<input type=hidden class=bordercolorvalue >
							</div>
						</div>
						<div class="selectforcolor" target="bordercolor"></div>
					</div>
					<div class="operatDiv  operatSelect" title="画边框线">
						<select id="bordertype" name="bordertype" notBeauty=true style="width:35px">
		                    <option value=1 data-image='/formmode/exceldesign/image/shortBtn/format/BorderBottom_wev8.png'>下框线</option> 
		                    <option value=2 data-image='/formmode/exceldesign/image/shortBtn/format/BorderTop_wev8.png'>上框线</option> 
		                    <option value=3 data-image='/formmode/exceldesign/image/shortBtn/format/BorderLeft_wev8.png'>左框线</option>
		                    <option value=4 data-image='/formmode/exceldesign/image/shortBtn/format/BorderRight_wev8.png'>右框线</option>
		                    <option value=5 data-image='/formmode/exceldesign/image/shortBtn/format/BorderRemove_wev8.png'>无框线</option>
		                    <option selected value=6 data-image='/formmode/exceldesign/image/shortBtn/format/BorderAll_wev8.png'>所有框线</option>
		                    <option value=7 data-image='/formmode/exceldesign/image/shortBtn/format/BorderOutline_wev8.png'>外侧框线</option>
		                    <option value=8 data-image='/formmode/exceldesign/image/shortBtn/format/BorderInside_wev8.png'>内侧框线</option>
		                    <option value=9 data-image='/formmode/exceldesign/image/shortBtn/format/BorderHorizontal_wev8.png'>水平内框线</option>
		                    <option value=10 data-image='/formmode/exceldesign/image/shortBtn/format/BorderVertical_wev8.png'>垂直内框线</option>
		            	</select> 
					</div>
				</td>
				<td class="splitTHead">
					<div title="插入行" name="insertrow" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/rowInsert_wev8.png" border="0"/></div>
					<div title="插入列" name="insertcol" class="operatDiv shortBtn " target="mc_hide"><img src="/formmode/exceldesign/image/shortBtn/format/colInsert_wev8.png" border="0"/></div>
				</td>
				<td class="splitTHead" target="mc_hide">
					<div title="财务表头" name="financialhead" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/financeTitle_wev8.png" border="0"/></div>
					<div title="财务表览" name="financialsheet" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/financeBody_wev8.png" border="0"/></div>
				</td>
				<td class="splitTHead" target="mc_splithide">
					<div title="清除内容" name="cleancontent" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/cleanContent_wev8.png" border="0"/></div>
					<div title="清除格式" name="cleanstyle" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/cleanStyle_wev8.png" border="0"/></div>
				</td>
				<td target="mc_hide">
					<div title="显示网格线" name="showgridline" down="on" class="operatDiv shortBtn shortBtnHover"><img src="/formmode/exceldesign/image/shortBtn/format/showgridline_wev8.png" border="0"/></div>
				</td>
			</tr>
			<tr>
				<td class="splitTHead">
				<div title="粗体" name="blodfont" class="operatDiv shortBtn " ><img src="/formmode/exceldesign/image/shortBtn/format/blod_wev8.png" border="0"/></div>
				<div title="斜体" name="italicfont" class="operatDiv shortBtn " style="margin-left:5px;"><img src="/formmode/exceldesign/image/shortBtn/format/italic_wev8.png" border="0"/></div>
				<div class="operatDiv" style="height:23px;width:1px;border-right:#C1D3DC 1px solid;margin-left:5px;"></div> <!-- 分割线 -->
				<div class="operatDiv" title="背景色">
					<div class="showforcolor" target="bgcolor">
						<img src="/formmode/exceldesign/image/shortBtn/format/BackgroundColor_wev8.png" border="0" style="vertical-align: bottom"/>
						<div class='pickcolordiv'>
							<input type=hidden class=bgcolorvalue>
						</div>
					</div>
					<div class="selectforcolor" target="bgcolor"></div>
				</div>
				<div class="operatDiv" title="字体颜色" style="margin-left:5px;">
					<div class="showforcolor" target="fontcolor">
						<img src="/formmode/exceldesign/image/shortBtn/format/fontcolor_wev8.png" border="0" style="vertical-align: bottom"/>
						<div class='pickcolordiv'>
							<input type=hidden class=fontcolorvalue>
						</div>
					</div>
					<div class="selectforcolor" target="fontcolor"></div>
				</div>
				<div title="格式刷" name="formatrush" class="operatDiv shortBtn " style="margin-left:0px;"><img src="/formmode/exceldesign/image/shortBtn/format/formatRush_wev8.png" border="0"/></div>
				</td>
				<td target="mc_hide">
					<div title="左对齐" name="leftAlign" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/leftAlign_wev8.png" border="0"/></div>
					<div title="居中对齐" name="centerAlign" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/centerAlign_wev8.png" border="0"/></div>
					<div title="右对齐" name="rightAlign" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/rightALign_wev8.png" border="0"/></div>
				</td>
				<td class="splitTHead" target="mc_splithide">
					<div title="减少缩进量" name="rightretract" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/leftretract_wev8.png" border="0"/></div>
				</td>
				<td class="splitTHead" target="mc_hide">
					<div title="合并单元格" name="mergenBx" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/MergenBx_wev8.png" border="0"/></div>
					<div title="拆分单元格" name="splitBx"class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/splitBx_wev8.png" border="0"/></div>
					<div class="operatDiv" style="height:23px;width:1px;border-right:#C1D3DC 1px solid;"></div> <!-- 分割线 -->
					<div title="单元格格式" name="excelPro" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/settingBx_wev8.png" border="0"/></div>
					<!-- <div title="自动换行" name="autowrap" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/autowarp_wev8.png" border="0"/></div>  -->	
				</td>
				<td class="splitTHead">
					<div title="删除行" name="deleterow" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/rowDelete_wev8.png" border="0"/></div>
					<div title="删除列" name="deletecol" class="operatDiv shortBtn " target="mc_hide"><img src="/formmode/exceldesign/image/shortBtn/format/colDelete_wev8.png" border="0"/></div>
				</td>
				<td class="splitTHead" target="mc_hide">
					<div title="千分位" name="n_us" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/thousands_wev8.png" border="0"/></div>
					<div title="金额大写" name="financialupper" class="operatDiv shortBtn " ><img src="/formmode/exceldesign/image/shortBtn/format/amountWord_wev8.png" border="0"/></div>
				</td>
				<td class="splitTHead" target="mc_splithide">
					<div title="全部清除" name="cleanall" class="operatDiv shortBtn "><img src="/formmode/exceldesign/image/shortBtn/format/cleanAll_wev8.png" border="0"/></div>
					<div title="清除财务格式" name="cleanfinance" class="operatDiv shortBtn " target="mc_hide"><img src="/formmode/exceldesign/image/shortBtn/format/clearFinance_wev8.png" border="0"/></div>
				</td>
				<td target="mc_hide">
					<div title="显示行列头" name="showthead" down="on" class="operatDiv shortBtn shortBtnHover"><img src="/formmode/exceldesign/image/shortBtn/format/showtitle_wev8.png" border="0"/></div>
				</td>
			</tr>
		</tbody>
	</table>
	<table class="excelHeadTabel s_insert" style="display:none" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<%if(!isDetail.equals("on")){ %>
					<div name="linkcode" class="operatDiv shortBtn bigBtn">
						<img class="insertimg" src="/formmode/exceldesign/image/shortBtn/insert/code_wev8.png" />
						<span>代码块</span>
					</div>
				<%} %>
				<div name="linkpic" class="operatDiv shortBtn bigBtn" target="mc_hide">
					<img class="insertimg" src="/formmode/exceldesign/image/shortBtn/insert/pictrue_wev8.png" />
					<span>图片</span>
				</div>
				<div name="clearBgImg" class="operatDiv shortBtn_disabled bigBtn" target="mc_hide">
					<img class="insertimg" src="/formmode/exceldesign/image/shortBtn/insert/clearBgpic_wev8.png" />
					<span>清除背景</span>
				</div>
				<div name="linktext" class="operatDiv shortBtn bigBtn">
					<img class="insertimg" src="/formmode/exceldesign/image/shortBtn/insert/link_wev8.png" />
					<span>链接</span>
				</div>
				<!-- <div class="operatDiv shortBtn bigBtn">
					<img class="insertimg" src="/formmode/exceldesign/image/shortBtn/insert/flash_wev8.png" />
					<span>Flash</span>
				</div> -->
				<div name="formula" class="operatDiv shortBtn bigBtn" target="mc_hide">
					<img class="insertimg" src="/formmode/exceldesign/image/shortBtn/insert/formula_wev8.png" />
					<span>公式</span>
				</div>
				<%if(!isDetail.equals("on")){ %>
					<div name="formulaClear" class="operatDiv shortBtn bigBtn" target="mc_hide" style="display:none">
						<img class="insertimg" src="/formmode/exceldesign/image/shortBtn/insert/formula_wev8.png" onclick="formulaObj.clearFormulas();" />
						<span>清除全部公式</span>
					</div>
					<div name="tabpage" class="operatDiv shortBtn bigBtn" target="mc_hide">
						<img class="insertimg" src="/formmode/exceldesign/image/shortBtn/insert/tab_wev8.png" />
						<span>标签页</span>
					</div>
					<div name="morecontent" class="operatDiv shortBtn bigBtn" target="mc_hide">
						<img class="insertimg" src="/formmode/exceldesign/image/shortBtn/morecontent/insert_wev8.png" />
						<span>文本</span>
					</div>
					<div name="iframearea" style="width:62px" class="operatDiv shortBtn bigBtn" target="mc_hide">
						<img class="insertimg" src="/formmode/exceldesign/image/shortBtn/insert/iframeArea_wev8.png" />
						<span>Iframe区域</span>
					</div>
					<div name="scancode" style="width:66px" class="operatDiv shortBtn bigBtn" target="mc_hide">
						<img class="insertimg" src="/formmode/exceldesign/image/shortBtn/insert/scanCode_wev8.png" />
						<span>二维/条形码</span>
					</div>
					<div name="portalelm" class="operatDiv shortBtn bigBtn" target="mc_hide">
						<img class="insertimg" src="/formmode/exceldesign/image/shortBtn/insert/portal_wev8.png" />
						<span>门户元素</span>
					</div>
				<%} %>
			</td>
		</tr>
	</table>
	<table class="excelHeadTabel s_filed" style="display:none" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<div name="justread" class="operatDiv shortBtn_disabled bigBtn">
					<img src="/formmode/exceldesign/image/shortBtn/field/read_wev8.png" style="margin-bottom:5px;" border="0"/>
					<span>只读</span>
				</div>
				<div name="canwrite" class="operatDiv shortBtn_disabled bigBtn">
					<img src="/formmode/exceldesign/image/shortBtn/field/edit_wev8.png" style="margin-bottom:5px;" border="0"/>
					<span>编辑</span>
				</div>
				<div name="required" class="operatDiv shortBtn_disabled bigBtn">
					<img src="/formmode/exceldesign/image/shortBtn/field/required_wev8.png" style="margin-bottom:5px;" border="0"/>
					<span>必填</span>
				</div>
				<div name="fieldpro" class="operatDiv shortBtn_disabled bigBtn" title="请单选包含字段的单元格后操作">
					<img src="/formmode/exceldesign/image/shortBtn/field/fieldPro_wev8.png" style="margin-bottom:5px;" border="0"/>
					<span>字段属性</span>
				</div>
				<!-- 
					<div name="morepro" class="operatDiv shortBtn_disabled bigBtn" title="请单选包含字段的单元格后操作">
						<img src="/formmode/exceldesign/image/shortBtn/field/morePro_wev8.png" style="margin-bottom:5px;" border="0"/>
						<span>更多属性</span>
					</div>
				 -->
			</td>
		</tr>
	</table>
	<table class="excelHeadTabel s_detail" <%=(isDetail.equals("on"))?"":"style=display:none"%> cellpadding="0" cellspacing="0">
	<%if(isDetail.equals("on")){ %>
		<tr>
			<td>
				<div class="turnlr turnLeft" onclick="moveDetailUl('left');"></div>
				<div class="detail_all" style="width:<%=76*d_num %>px">
					<ul class="detail_ul">
					<% 
					
					for(int i=0;i<d_num;i++){ 
						String curClass=d_identy==(i+1)?"detail_"+(i%5+1)+"_hot":"detail_"+(i%5+1)+"_dis";
					%>
					<li class="operatDiv bigBtn detail_<%=(i%5+1) %> <%=curClass %>">
						<span style="margin-top:40px">明细<%=i+1 %></span>
					</li>
					<%} %> 
					</ul>
				</div>
				<div class="turnlr turnRight" onclick="moveDetailUl('right');"></div>
				<div name="de_title" class="operatDiv bigBtn shortBtn">
					<img src="/formmode/exceldesign/image/shortBtn/detail/tabTitle_wev8.png" style="margin-bottom:5px;" />
					<span>表头标识</span>
				</div>
				<div name="de_tail" class="operatDiv bigBtn shortBtn">
					<img src="/formmode/exceldesign/image/shortBtn/detail/tabTail_wev8.png" style="margin-bottom:5px;" />
					<span>表尾标识</span>
				</div>
				<div name="de_btn" class="operatDiv bigBtn shortBtn">
					<img src="/formmode/exceldesign/image/shortBtn/detail/addDel_wev8.png" style="margin-bottom:5px;" />
					<span>添加删除</span>
				</div>
				<div name="de_checkall" class="operatDiv bigBtn shortBtn belSeniorSet" style="width:60px">
					<img src="/formmode/exceldesign/image/shortBtn/detail/checkAll_wev8.png" style="margin-bottom:5px;" />
					<span>明细行全选</span>
				</div>
				<div name="de_checksingle" class="operatDiv bigBtn shortBtn belSeniorSet" style="width:60px">
					<img src="/formmode/exceldesign/image/shortBtn/detail/checkSingle_wev8.png" style="margin-bottom:5px;" />
					<span>明细行选中</span>
				</div>
				<div name="de_serialnum" class="operatDiv bigBtn shortBtn belSeniorSet">
					<img src="/formmode/exceldesign/image/shortBtn/detail/serialNum_wev8.png" style="margin-bottom:5px;" />
					<span>行序号</span>
				</div>
			</td>
		</tr>
	<%}else{ %>
		<tr>
			<td>
				<div name="mainDetail" class="operatDiv shortBtn bigBtn">
					<img src="/formmode/exceldesign/image/shortBtn/detail/insertDetail_wev8.png" border="0"/>
					<span style="margin-bottom:-5px;">明细表</span>
					<img src="/formmode/exceldesign/image/shortBtn/nabla_wev8.png" border="0"/>
				</div>
			</td>
		</tr>
	<%} %>
	</table>
	<table class="excelHeadTabel s_style" style="display:none" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<div>
					<div class="typeContainerFather">
						<div id="typeContainer" class="typeContainer" style="top:0px;">
							<div name="e_style_1" class="tylelement" target="sys_1">
								<div name="_label1" style="font-family:宋体!important;width: 23px;float: left;border: 1px solid #90badd;padding-left: 7px;background:#e7f3fc">---</div>
								<div name="_field1" style="font-family:宋体!important;border: 1px solid #90badd;padding-left: 36px;">-------</div>
								<div name="_label1" style="font-family:宋体!important;float: left;width: 23px;border: 1px solid #90badd;padding-left: 7px;margin-top: -1px;background:#e7f3fc;">---</div>
								<div name="_field1" style="font-family:宋体!important;border: 1px solid #90badd;margin-top: -1px;padding-left: 36px;">-------</div>
								<div name="_label1" style="font-family:宋体!important;width: 30px;float: left;border: 1px solid #90badd;padding-left: 10px;background:#e7f3fc;margin-top: -1px;">----</div>
								<div name="_label1" style="font-family:宋体!important;border: 1px solid #90badd;padding-left: 50px;margin-top: -1px;background:#e7f3fc;">----</div>
								<div name="_field1" style="font-family:宋体!important;float: left;width: 30px;border: 1px solid #90badd;padding-left: 10px;margin-top: -1px;">----</div>
								<div name="_field1" style="font-family:宋体!important;border: 1px solid #90badd;margin-top: -1px;padding-left: 50px;">----</div>
								<input name="_css" type="hidden" _border_color="#90badd" _label_background="#e7f3fc"/>
							</div>
						</div>
					</div>
					<div class="morthumn" >
						<div class="moreup">
							<img src="/formmode/exceldesign/image/shortBtn/style/up_wev8.png">
						</div>
						<div class="moredown">
							<img src="/formmode/exceldesign/image/shortBtn/style/down_wev8.png">
						</div>
						<div class="moremore" expand="no">
							<img src="/formmode/exceldesign/image/shortBtn/style/expand_wev8.png">
						</div>
					</div>
					<div class="morenewContaint">
						<div class="morenewBtn" title="新建">
						</div>
					</div>
				</div>
			</td>
		</tr>
	</table>
</div>
<%if(isDetail.equals("on")){ %>
	<div class="seniorSetDiv">
		<input type="checkbox" id="openSeniorSet" checked onclick="detailOperate.clickOpenSeniorSetFace();" />
		<span style="position:relative; top:-2px;">启用高级定制</span>
		<span style="position:relative; top:-3px;" class="e8tips" title="启用高级定制后，明细支持折行设置，可自定义设置行头、序号、合计等样式及位置，系统不再根据模板自动生成">
			<img src="/images/tooltip_wev8.png" align="absMiddle">
		</span>
	</div>
	<div class="operatDiv bigBtn detail_return" onclick="formOperate.saveDetailWindowFace('<%=d_identy %>')">
		<span style="margin-top:40px">返回</span>
	</div>
<%}else{ %>
	<ul id="styleRightMenu" class="contextMenu menu2"></ul>		<!-- 样式右键菜单 -->
	<div class="linkhelp" onclick="linkhelp();">
		<img src="/formmode/exceldesign/image/shortBtn/help_wev8.png" />
		<span>帮助</span>
	</div>
	<div id="rightBox" class="e8_rightBox" style="padding-right:15px;">
		<div id="tabcontentframe_box" class="_box" target="mc_hide">
			<input type="button" onclick="checkServer(formOperate.saveLayoutWindowFace,'saveLayout')" value="保存" class="e8_btn_top_first">
			<input type="button" onclick="checkServer(formOperate.saveLayoutWindowFace,'preViewLayout')" value="预览" class="e8_btn_top">
			<span title="菜单" class="cornerMenu middle" style="display:none"></span>
		</div>
	</div>
<%} %>
<div class="excelHeadSplitLine"></div>
<%if(!isDetail.equals("on")){ %>
	<div class="tabdiv" style="display:none">
		<div class="tab_top">
			&nbsp;<input id="tabname" type="text" style="width:140px;"/>
			<span style="margin-left:30px;">标签页区域高度：</span>
			<select id="areaselect" style="width:80px;">
				<option value="1">自适应</option>
				<option value="2">固定高度</option>
			</select>&nbsp;
			<span id="areaheightspan" style="display:none;">
				<input id="areaheight" type="text" style="width:60px;" onkeypress="ItemCount_KeyPress();" />px
			<span>
		</div>
		<div class="tab_bottom">
			<div class="tab_bottomleft">
				<div class="tab_movebtn tab_turnleft"></div>
				<div class="tab_head">
					<div class="t_area xrepeat"></div>
				</div>
				<div class="tab_movebtn tab_turnright"></div>
				<div class="tab_addBtn tab_add"></div>
			</div>
			<div class="tab_bottomright">
				<div class="operBtn changeskin" title="换肤"></div>
				<div class="operBtn canceltab" title="返回"></div>
			</div>
		</div>
		<div id="tab_template" style="display:none">
			<div class="t_sep norepeat"></div>
			<div class="t_unsel">
				<div class="t_unsel_left norepeat"></div>
				<div class="t_unsel_middle xrepeat lineheight30">
					<span></span>
				</div>
				<div class="t_unsel_right norepeat"></div>
			</div>
		</div>
		<input type="hidden" id="tabstyle" />
		<input type="hidden" id="maincellid" />
	</div>
	<div class="tabSplitLine" style="display:none"></div>
<%} %>
<script type="text/javascript">
	jQuery(document).ready(function(){
		//对下拉框特殊处理下，系统自带的下拉框美化太挫了
		var fontsize_sb = $("#fontfamily").attr("sb");
		$("#sbHolderSpan_"+fontsize_sb).css("width","100%");
		var fontsize_sb = $("#fontsize").attr("sb");
		$("#sbHolderSpan_"+fontsize_sb).css("width","100%");
		
		baseOperate.initStyleTabFace();
		$(".moreup").on("click",function(){
		 	var rt = 31.8/(16*3);
        	var py = Math.floor(-120*rt)+1;
        	var oldpy = $(".typeContainerFather").getNiceScroll()[0].getScrollTop();
		 	$(".typeContainerFather").getNiceScroll().doScrollPos(0,oldpy+py);
		});
		$(".moredown").on("click",function(){
		 	var rt = 31.8/(16*3);
        	var py = Math.floor(120*rt);
        	var oldpy = $(".typeContainerFather").getNiceScroll()[0].getScrollTop();
		 	$(".typeContainerFather").getNiceScroll().doScrollPos(0,py+oldpy);
		});
		$(".typeContainerFather").perfectScrollbar({mousescrollstep:31.8});
		$(".typeContainerFather").perfectScrollbar("hide");
		$(".moremore").on("click",function(){
			if($(this).attr("expand") === "on"){
				$(this).attr("expand","no");
				$("div.typeContainerFather").css("height","78px");
				$(".typeContainerFather").perfectScrollbar("hide");
				$(this).children().eq(0).attr("src","/formmode/exceldesign/image/shortBtn/style/expand_wev8.png");
				
			}else{
				$(this).attr("expand","on");
				var _height = Math.ceil($("div.typeContainer").children().length/6)*79;
				$("div.typeContainerFather").css("height",_height+"px");
				var s2 = setTimeout(function(){
			 		$(".typeContainerFather").perfectScrollbar("show");
			 		clearTimeout(s2);
			 	},300)
				$(this).children().eq(0).attr("src","/formmode/exceldesign/image/shortBtn/style/contract_wev8.png");
			}
			var oldpy = $(".typeContainerFather").getNiceScroll()[0].getScrollTop();
			var num = Math.floor(oldpy/79);
			var rt = 31.8/(16*3);
       		var py = Math.floor(120*rt);
			$(".typeContainerFather").getNiceScroll().doScrollPos(0,py*num);
		});
		
	});
	
</script>
  
</BODY>
</HTML>
