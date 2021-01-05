
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
	<%
		//做验证用
		String paramtxt = Util.null2String(request.getParameter("paramtxt"));
		String isDetail = Util.null2String(request.getParameter("isDetail"));
		String detailIdenty = Util.null2String(request.getParameter("detailIdenty"));
	%>
	<script type="text/javascript">
		var currentTableSheetJson = "";
		var currentSelect = "";
		var isDetail = "<%=isDetail%>";
		var formulaSetting = {
			SUM:"<%=SystemEnv.getHtmlLabelName(128992, user.getLanguage())%>",
			AVERAGE:"<%=SystemEnv.getHtmlLabelName(128993, user.getLanguage())%>",
			ABS:"<%=SystemEnv.getHtmlLabelName(128994, user.getLanguage())%>",
			ROUND:"<%=SystemEnv.getHtmlLabelName(128995, user.getLanguage())%>",
			MAX:"<%=SystemEnv.getHtmlLabelName(129568, user.getLanguage()) %>",
			MIN:"<%=SystemEnv.getHtmlLabelName(129569, user.getLanguage()) %>",
			IF:"<%=SystemEnv.getHtmlLabelName(128996, user.getLanguage())%>"
		}
	    $.fn.getCursorPosition = function() {
	        var el = $(this).get(0);
	        var pos = 0;
	        if(document.selection){		//IE浏览器
	         	el.focus();
	         	//不知道why，此方式选中倒数第二个字符就计算结果差一位
	            //var Sel = document.selection.createRange();
	            //var SelLength = document.selection.createRange().text.length;
	            //Sel.moveStart('character', -el.value.length);
	            //pos = Sel.text.length - SelLength;
	            
	            //改用此方式
		　 　 　  var range = document.selection.createRange();
		　 　 　  var stored_range = range.duplicate();
		　 　 　  stored_range.moveToElementText(el);				//stored_range选中textarea全部内容
		　 　 　  stored_range.setEndPoint('EndToEnd', range);	//stored_range的结尾放到range的结尾
			    //alert(stored_range.text+" "+range.text);
			    pos = stored_range.text.length - range.text.length;
	        }else if (el.selectionStart){
	            pos = el.selectionStart;
	        }
	        return pos;
	    }
	    
	    function setFocus(vthis){
	    	//解决IE浏览器下双击公式textarea失去焦点无法定位插入问题
	    	//Chrome下自动会记忆鼠标最后一次焦点，无需处理
	    	if(document.selection){	
	    		 var el = $(vthis).get(0);
	    		 el.focus();
	    	}
	    }
	    
	    var dialog;
	    var parentWin;
		jQuery(document).ready(function(){
			dialog = window.top.getDialog(window);
			$(".formulaul li").click(function () {
				//if($(this).is(".current")) return;
				$(".formulaul .current").removeClass("current");
				$(this).addClass("current");
				$("div[name=report").html(formulaSetting[$(this).attr("target")]);
				
			});
			$(".formulaul li").dblclick(function () {
				var _u8_text = $("#u8_input").val();
				$("#u8_input").focus();
				var set_cursor_p = 0;
				if(!_u8_text){
					$("#u8_input").val("="+$(this).attr("target")+"()");
					set_cursor_p = $(this).attr("target").length+2;
				}else{
					var cursor_p = $("#u8_input").getCursorPosition();
					var f_f = _u8_text.substring(0,cursor_p);
					var l_l = _u8_text.substring(cursor_p,cursor_p.length);
					_u8_text = f_f+$(this).attr("target")+"()"+l_l;
					$("#u8_input").val(_u8_text);
					set_cursor_p = f_f.length+$(this).attr("target").length+1;
				}
				var st = setTimeout(function(){
					clearTimeout(st);
					 	//设置光标需要到的位置
					u8_input.setSelectionRange(set_cursor_p,set_cursor_p);
				},0);
			});
			$(".formulaul .current").trigger("click");
			
			$("img[name=selectcell]").click(function(){
				var cursor_p = $("#u8_input").getCursorPosition();
				var dlgdiv = window.top.getDialog(window).getDialogDiv();
				//$(dlgdiv).hide();
				var s__top = dlgdiv.offsetTop;
				var s__left = dlgdiv.offsetLeft;
				var s__height = dlgdiv.offsetHeight;
				parentWin = window.top.getParentWindow(window);
				if(!currentTableSheetJson){
					currentTableSheetJson = parentWin.baseOperate.getCurrentSheetJsonFace();
					parentWin.baseOperate.setCurrentSheetJsonFace(currentTableSheetJson,true);
				}
				$(window.top.Dialog.getBgdiv()).css("z-index",(parseInt($(window.top.Dialog.getBgdiv()).css("z-index")) - 2)+"");
				var formulaMasking1_height = $(".editor_nav",parentWin.document).height()+$(".excelHeadBG",parentWin.document).height();
				if($(".tabdiv",parentWin.document).css("display") != "none")
					formulaMasking1_height += $(".tabdiv",parentWin.document).height();
				$(parentWin.formulaMasking1).css("height",formulaMasking1_height).attr("target",$(dlgdiv).attr("id")).show();
				$(parentWin.formulaMasking2).css("top",formulaMasking1_height).css("height",$(".excelSet",parentWin.document).height()).show();
				$(".demo2").hide();
				$(dlgdiv).find("iframe").parent().css("height","39px");
				
				var options = {top:100,left:50,height:70 };
		 		$(dlgdiv).animate(options,300,function(){
		 			var selectcellSelect = $("<select id='selectcellSelect' style='height: 24px;border: 1px solid #E9E9E2'; onchange=changeTable(this)></select>");
		 			var isDetail = "<%=isDetail%>";
		 			var detailIdenty = "<%=detailIdenty%>";
		 			selectcellSelect.append("<option value=main><%=SystemEnv.getHtmlLabelName(21778, user.getLanguage())%></option>");
		 			var tablist;
		 			if(isDetail === "on")
		 				tablist = parentWin.parentWin_Main.tabOperate.getTabListFace();
		 			else
		 				tablist = parentWin.tabOperate.getTabListFace();
		 			for(var key in tablist){
		 				selectcellSelect.append("<option value="+key+"><%=SystemEnv.getHtmlLabelName(128091, user.getLanguage())%>-"+tablist[key]+"</option>");
		 			}
		 			if(isDetail === "on"){
		 				selectcellSelect.append("<option value=detail_"+detailIdenty+"><%=SystemEnv.getHtmlLabelName(19325, user.getLanguage())%>"+detailIdenty+"</option>");
		 			}else{
		 				var detailnum = parseInt(window.top.getParentWindow(window).getDetailNum());
 		 				for (var i=0;i<detailnum;i++)
		 					selectcellSelect.append("<option value=detail_"+(i+1)+"><%=SystemEnv.getHtmlLabelName(19325, user.getLanguage())%>"+(i+1)+"</option>");
		 			}
		 			if(!currentSelect)		//多次打开选择窗口不改变select值
		 				currentSelect = parentWin.globalData.getCacheValue("symbol");
		 			selectcellSelect.val(currentSelect);
		 			
		 			var selectcellTxt = $("<input type='text' id='selectcellTxt' />");
		 			var selectcellBtn = $("<input type='button' value='<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>' id='zd_btn_sumbit1' class='e8_btn_top_first' style='height:24px;'/>");
		 			var selectcellDiv = $("<div id='selectcellDiv' style='text-align:left;padding-top:8px;padding-left:1px;'></div>");
		 			selectcellDiv.append(selectcellSelect).append(selectcellTxt).append(selectcellBtn);
		 			$(".demo2").parent().append(selectcellDiv);
		 			selectcellTxt.width(selectcellDiv.width()-selectcellSelect.width()-70);
		 			
		 			selectcellBtn.click(function(){		//恢复公式设置
		 				$(parentWin.formulaMasking1).removeAttr("target").hide();
						$(parentWin.formulaMasking2).hide();
						$(window.top.Dialog.getBgdiv()).css("z-index",(parseInt($(window.top.Dialog.getBgdiv()).css("z-index")) + 2)+"");
		 				var _u8_text = $("#u8_input").val();
		 				var f_f = _u8_text.substring(0,cursor_p);
						var l_l = _u8_text.substring(cursor_p,cursor_p.length);
						var selectcelltxt_val = transformTxtinTable(selectcellTxt.val());
						var _u8_text = f_f+selectcelltxt_val+l_l;
						selectcellDiv.remove();
						$(dlgdiv).find("iframe").parent().css("height",(s__height+32)+"px");
						var _options = {top:s__top,left:s__left,height:s__height};
						var set_cursor_p = cursor_p+selectcelltxt_val.length;
						$(dlgdiv).animate(_options,300,function(){
							$(dlgdiv).find("iframe").show();
							$("#u8_input").val(_u8_text);
							$("#u8_input").focus();
							var st = setTimeout(function(){
								clearTimeout(st);
								 	//设置光标需要到的位置
								u8_input.setSelectionRange(set_cursor_p,set_cursor_p);
							},0);
						});
						$(".demo2").show();
		 			});
		 			
		 			
		 			//beautySelect(selectcellSelect);
		 		});//hide( "slideDown", options, 1000 );
			})
		});
		
		function intToMoreChar(value){
            var rtn = "";
            var iList = new Array();

            //To single Int
            while (parseInt(value / 26) != 0 || parseInt(value % 26) != 0){
                iList.push(parseInt(value % 26));
                value = parseInt(value/26);
            }

            //Change 0 To 26
            for (var j = 0; j < iList.length - 1; j++){
                if (iList[j] == 0){
                    iList[j + 1] -= 1;
                    iList[j] = 26;
                }
            }

            //Remove 0 at last
            if (iList[iList.length - 1] == 0){
                iList.remove(iList[iList.length - 1]);
            }

            //To String
            for (var j = iList.length - 1; j >= 0; j--){
                var c = String.fromCharCode(iList[j] + 64);
                rtn += c;
            }

            return rtn;
        }
		
		var matchStr = /((main|tab_\d+|detail_\d+)\.)?[a-zA-Z]+\d+:((main|tab_\d+|detail_\d+)\.)?[a-zA-Z]+\d+|((main|tab_\d+|detail_\d+)\.)?[a-zA-Z]+\d+/g;
		function transformTxtinTable(selecttxt){
			if(!selecttxt)return "";
			var restr = "";
			var cellrang = selecttxt.match(matchStr);
			if(isDetail !== "on"  && currentSelect.indexOf("detail_") > -1){	//主表设置公式选明细表区域
				for(var i = 0; i < cellrang.length; i++){
					if(cellrang[i].match(/^[a-zA-Z]+\d+:[a-zA-Z]+\d+$/)){
						var cellposition = parentWin.formulaOperate.analyzeCellRangeFace(cellrang[i]);
						var s_cell = cellposition.split(";")[0];
						var e_cell = cellposition.split(";")[1];
						var detail_dataobj = parentWin.globalData.getCacheValue(currentSelect);
						detail_dataobj = JSON.parse("{"+detail_dataobj+"}");
						if(detail_dataobj[currentSelect].ec && detail_dataobj[currentSelect].ec.length > 0)
						for(var x=0;x<=parseInt(e_cell.split(",")[0])-parseInt(s_cell.split(",")[0]);x++){
							for(var y=0;y<=parseInt(e_cell.split(",")[1])-parseInt(s_cell.split(",")[1]);y++){
								var _r = parseInt(s_cell.split(",")[0])+x;
								var _c = parseInt(s_cell.split(",")[1])+y;
								cellid = _r+","+_c;
								for(var j =0; j<detail_dataobj[currentSelect].ec.length;j++){
									if(detail_dataobj[currentSelect].ec[j].etype === "3" && detail_dataobj[currentSelect].ec[j].id === cellid){
										restr += currentSelect+"."+intToMoreChar(_c+1)+(_r+1)+",";
									}
								}
							}
						}
					}else if(cellrang[i].match(/^(main|tab_\d+|detail_\d+)\.[a-zA-Z]+\d+$/)){	//带头部的单个单元格
						restr += cellrang[i]+",";
					}else if(cellrang[i].match(/^[a-zA-Z]+\d+$/)){				//不带头部的单个单元格
						restr += currentSelect+"."+cellrang[i]+",";
					}
				}
			}else{
				var cur_dataobj;
				if(isDetail === "on" && currentSelect.indexOf("detail_") == -1)		//明细设置公式选择主表区域
					cur_dataobj = parentWin.parentWin_Main.globalData.getCacheValue(currentSelect);
				else
					cur_dataobj = parentWin.globalData.getCacheValue(currentSelect);
				for(var i = 0; i < cellrang.length; i++){
					var fStr = getFormatStr(cur_dataobj, currentSelect, cellrang[i]);
					restr += fStr+",";
				}
			}
			if(restr.length>0 && restr.substr(restr.length-1,1) == ",")
				restr = restr.substring(0, restr.length-1);
			return restr;
		}
		
		function getFormatStr(cur_dataobj, cur_head, cellattr){
			if(!cur_dataobj || !cur_dataobj.ecs)
				return "";
			if(cellattr.match(/^[a-zA-Z]+\d+:[a-zA-Z]+\d+$/)){		//区域(不能带头部)
				var fStr = "";
				var cellposition = parentWin.formulaOperate.analyzeCellRangeFace(cellattr);
				var s_cell = cellposition.split(";")[0];
				var e_cell = cellposition.split(";")[1];
				for(var x=0;x<=parseInt(e_cell.split(",")[0])-parseInt(s_cell.split(",")[0]);x++){
					for(var y=0;y<=parseInt(e_cell.split(",")[1])-parseInt(s_cell.split(",")[1]);y++){
						var _r = parseInt(s_cell.split(",")[0])+x;
						var _c = parseInt(s_cell.split(",")[1])+y;
						cellid = _r+","+_c;
						if(cur_dataobj.ecs[cellid] && cur_dataobj.ecs[cellid].etype === "Fcontent")
							fStr += cur_head+"."+intToMoreChar(_c+1)+(_r+1)+",";
					}
				}
				if(fStr.length>0 && fStr.substr(fStr.length-1,1) == ",")
					fStr = fStr.substring(0, fStr.length-1);
				return fStr;
			}else if(cellattr.match(/^(main|tab_\d+|detail_\d+)\.[a-zA-Z]+\d+$/)){	//带头部的单个单元格
				return cellattr;
			}else if(cellattr.match(/^[a-zA-Z]+\d+$/)){				//不带头部的单个单元格
				return cur_head+"."+cellattr;
			}
		}
		
		function clearFormula(){
			$("#u8_input").val("");
		}
		
		function changeTable(obj){
			var cusval = $(obj).val();
			currentSelect = cusval;
			parentWin = window.top.getParentWindow(window);
			parentWin.baseOperate.changeTable4OpFace(cusval, currentTableSheetJson);
			$(obj).parent("div").find("#selectcellTxt").val("");
		}
		
		function setFormula(isset){
			parentWin = window.top.getParentWindow(window);
			parentWin.baseOperate.setCurrentSheetJsonFace(currentTableSheetJson,false);
			if(isset){
				jQuery(".notice").html("");
				var formulaStr = $("#u8_input").val().trim();
				if(!!formulaStr){
					if(formulaStr.substring(0,1) != "="){
						jQuery(".notice").append("<span><%=SystemEnv.getHtmlLabelName(128038, user.getLanguage())%></span></br>");
						return;
					}
					if(!formulaStr.match(matchStr)){
						jQuery(".notice").append("<span><%=SystemEnv.getHtmlLabelName(128039, user.getLanguage())%></span></br>");
						return;
					}
					jQuery(".notice").append("<span><%=SystemEnv.getHtmlLabelName(128040, user.getLanguage())%><span></br>");
					var hasFormatStr = transFormatFormula(formulaStr);
					$("#u8_input").val(hasFormatStr);
					jQuery(".notice").append("<span><%=SystemEnv.getHtmlLabelName(128041, user.getLanguage())%><span></br>");
					window.setTimeout(function(){
						var reJson = {formula:hasFormatStr};
						dialog.close(reJson);
					},500);
				}else{
					dialog.close({formula:""});
				}
			}else{
				dialog.closeByHand();
			}
		}
		
		//公式提交前格式化(单元格选择器选择的都带有标示，针对手动输入的类似A2:C4/D5等需自动加上标示)
		function transFormatFormula(formulaStr){
			var cellrang = formulaStr.match(matchStr);
			var cellrang_new = new Array();
			var cur_symbol = parentWin.globalData.getCacheValue("symbol");
			var cur_dataobj = parentWin.globalData.getCacheValue(cur_symbol);
			//先使用占位符替换，防止例：替换D4时将main.D4已有标示串替换掉
			//match匹配是顺序匹配，故只能replace一次不能全局replace
			for(var i = 0; i < cellrang.length; i++){
				formulaStr = formulaStr.replace(cellrang[i], "placeholder_"+i);
				cellrang_new.push(this.getFormatStr(cur_dataobj, cur_symbol, cellrang[i]));
			}
			if(window.console)	console.log(formulaStr);
			if(window.console)	console.log(cellrang);
			if(window.console)	console.log(cellrang_new);
			//还原占位符，替换一次即可
			for(var i = 0; i < cellrang_new.length; i++){
				formulaStr = formulaStr.replace("placeholder_"+i, cellrang_new[i]);
				//全局替换，且替换串后不能是数字
				//formulaStr = formulaStr.replace(eval("/placeholder_"+i+"(?!\\d)/gi"), cellrang_new[i]);
			}
			if(window.console)	console.log(formulaStr);
			return formulaStr;
		}
	</script>
	<style type="text/css">
		.formulaul li{padding:5px;cursor: pointer;}
		.formulaul li:hover{background: #f1f1f1;}
		.formulaul .current{background: #e1e1e1;}
		.ui-effects-transfer { border: 2px dotted gray; }
		.notice span{color:red; font-size:14px;}
	</style>
</HEAD>
<BODY style="overflow:hidden;">
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(826, user.getLanguage()) + ",javascript:setFormula(true),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage()) + ",javascript:clearFormula(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	%>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow"/>
	   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("30615,18125", user.getLanguage())%>'/>
	</jsp:include>   
	<div class="zDialog_div_content" id="zDialog_div_content" style="overflow:hidden;">   
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				
			      	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table> 	
		<wea:layout type="2col">
		    <wea:group context="" attributes="{groupDisplay:none,groupOperDisplay:none}">
		    	<wea:item>
		    		<div style="float: left;width: 40%;margin-top: 15px;height:222px;">
		    			<span><%=SystemEnv.getHtmlLabelNames("30686,178", user.getLanguage())%></span>
		    			<span>
		    				<select name="formulatype">
		    					<option><%=SystemEnv.getHtmlLabelName(31649, user.getLanguage())%></option>
		    				</select>
		    			</span>
		    			<div style="width: 150px;border: 1px solid #d9d9d9;margin-top: 9px;height:185px;overflow-y:auto;-moz-user-select:none;" onselectstart="return false;">
		    				<ul style="list-style-type: none;" class="formulaul">
								<li target="SUM" class="current">SUM</li>
								<li target="AVERAGE">AVERAGE</li>
								<li target="ABS">ABS</li>
								<li target="ROUND">ROUND</li>
								<li target="MAX">MAX</li>
								<li target="MIN">MIN</li>
								<li target="IF">IF</li>
							</ul>
		    			</div>
		    		</div>
		    		<div style="float:left;width:59%;margin-top:45px;height:172px;overflow-y:auto;">
		    			<span><%=SystemEnv.getHtmlLabelName(125776, user.getLanguage())%></span>
		    			<div name="report"></div>
		    		</div>
		    		<div style="margin-top:8px;margin-bottom:8px;float:left;width:95%;">
		    			<span><%=SystemEnv.getHtmlLabelName(128042, user.getLanguage())%></span>
		    			<span>
		    				<img name="selectcell" src="/workflow/exceldesign/image/shortBtn/style/selectcell_wev8.png" border="0" style="cursor:pointer;position: relative;top: 4px;margin-left: 20px;"/>
		    			</span>
		    			<div style="margin-top:6px;">
		    				<%=SystemEnv.getHtmlLabelName(128043, user.getLanguage())%> =SUM(main.A1,tab_1.A2,detail_1.A1,A2:D3 ......)
		    			<br/><%=SystemEnv.getHtmlLabelName(128998, user.getLanguage())%>
		    			</div>
		    			<div id="u8" style="margin-top:10px;">
        					<textarea id="u8_input" rows=4 style="width:95%" onblur="setFocus(this);"><%=paramtxt %></textarea>
      					</div>
      					<div class="notice" style="margin-top:10px;"></div>
		    		</div>
		    	</wea:item>
		    </wea:group>
		</wea:layout>
		
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" id="zd_btn_sumbit2"  class="zd_btn_submit" onclick="setFormula(true)" title="<%=SystemEnv.getHtmlLabelName(128999, user.getLanguage())%>">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%>" id="zd_btn_clear"  class="zd_btn_cancle" onclick="clearFormula()">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="setFormula(false)">
				</wea:item>
			</wea:group>
		</wea:layout>      
  	</div>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>