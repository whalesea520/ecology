<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%
	if(!HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
		<style type="text/css">
			td.ntitle{background: #F5F5F5 !important;}
			td.Field{background: none !important;}
			td.Line,td.Line1{background: #D8D8D8 !important;}
			.operator,#javaformula{ padding:0px 10px; margin:4px 4px;}
			.operator ul{list-style:none;margin:15px 0 10px 0; padding:0px;}
			.operator li{display:inline;padding:4px 12px 4px 12px;margin:0px 10px 0px 0px;text-align:center;border-radius:5px;cursor:pointer;border:1px solid #CED7CE;}
			.bg_li{background-color:#f2f2f2;}
		    #selected{margin:4px 15px;padding:0px 10px;height:100px;border-bottom:1px solid #E1E1E1;overflow:auto;width:50%;}
			#selectedul{list-style:none;margin: 5px;}
			#selectedul li{float:left;height:30px;padding:0px 5px;line-height:30px;margin-right:10px;margin-top:5px; position:relative;text-align: center; background-color: #FAFBFA; }
			#selectedul li .remove{position:absolute; right:0;top:0px; width:16px; height:16px; background:url('../images/delete.png'); display:none; cursor: pointer;}
		    #selectedul li input{width: 80px;}
		    #selectedul li:hover{padding:0px 20px 0px 5px; border: 1px solid #e1e1e1;}
		    #selectedul li:hover div{display: block;}
		    #showformula{margin:15px 0 10px 15px;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	<SCRIPT language="javascript" src="/workrelate/js/pointout.js"></script>
	</head>
	<%
		String imagefilename = "/images/hdSystem.gif";
		String titlename = "新建考核指标项";
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitData(this),_self} ";
			RCMenuHeight += RCMenuHeightStep;
				
			RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",AccessItemList.jsp,_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
									<FORM id="weaver" name="frmMain" action="AccessItemOperation.jsp" method="post">
										<input type="hidden" name="operation" value="add"/>
										<TABLE class=ViewForm>
											<COLGROUP>
												<COL width="20%">
												<COL width="80%">
											</COLGROUP>
											<TBODY>
												<TR class=Title>
													<TH colSpan=2>考核指标项</TH>
												</TR>
												<TR class=Spacing style="height: 1px;">
													<TD class=Line1 colSpan=2></TD>
												</TR>
												<TR>
													<TD class=ntitle>指标名称</TD>
													<TD class=Field>
														<input class=inputstyle type=text size=30 maxlength="100" name="itemname"
															onchange='checkinput("itemname","itemnameImage")' />
														<SPAN id=itemnameImage><IMG src="/images/BacoError_wev8.gif" align=absMiddle>
														</SPAN>
													</TD>
												</TR>
												<TR style="height: 1px;">
													<TD class=Line colSpan=2></TD>
												</TR>
												<TR>
													<TD class=ntitle>指标描述</TD>
													<TD class=Field>
														<input class=inputstyle type=text style="width:95%" maxlength="500" name="itemdesc" />
													</TD>
												</TR>
												<TR style="height: 1px;">
													<TD class=Line colSpan=2></TD>
												</TR>
												<TR>
													<TD class=ntitle>指标类型</TD>
													<TD class=Field>
														<select name="itemtype" onchange="changeType(this.value)" id="itemtype">
															<option value="1">定性</option>
															<option value="2">定量</option>
														</select>
													</TD>
												</TR>
												<TR style="height: 1px;">
													<TD class=Line colSpan=2></TD>
												</TR>
												<TR id="unittr" style="display: none;">
													<TD class=ntitle>数值单位</TD>
													<TD class=Field>
														<input class=inputstyle type=text size=30 maxlength="50" name="itemunit" />
													</TD>
												</TR>
												<TR id="unittr2" style="display: none;height: 1px;">
													<TD class=Line colSpan=2></TD>
												</TR>
												<TR id="formulatr" style="display: none;">
													<TD class=ntitle>计算公式</TD>
													<TD class=Field>
														<select name="formula" id="formula">
															<option></option> 
															<option value="1">公式1[完成值/目标值*5]</option>
															<!-- <option value="2">公式2[项目收款]</option>
															<option value="3">公式3[项目验收]</option>
															<option value="4">公式4[技术任务量]</option> -->
															<option value="5">公式5[目标值/完成值*3.5]</option>
															<option value="11">公式[完成值/目标值*最大分制]</option>
															<option value="12">自定义公式</option>
															<option value="13">自定义Java类</option>
														</select>
														<div id="formuladiv" style="display: none;">
															<div class="operator"> 
															  可选择计算因子及运算符<font color="red">(点击进行选择)</font>：	
														        <ul class="operatorul">
														            <li class="ui-widget-content bg_li basekpi" kpiid="gval">目标值</li>
																	<li class="ui-widget-content bg_li basekpi" kpiid="cval">完成值</li>
																	<li class="ui-widget-content bg_li">(</li>
																	<li class="ui-widget-content bg_li">)</li>
																	<li class="ui-widget-content bg_li">+</li>
																	<li class="ui-widget-content bg_li">-</li>
																	<li class="ui-widget-content bg_li">/</li>
																	<li class="ui-widget-content bg_li">*</li>
																	<li class="ui-widget-content bg_li number">数字</li>
														        </ul>
														    </div>
														    <div id="selected" class="ui-widget-content">
																<ul id="selectedul"></ul>
															</div>
															<div id="showformula"></div>
															 <input type="hidden" id="kpiformula" name="kpiformula"/>
														</div>
														<div id="javaformula" style="display: none;">
														   	java全类名:<input type="text" id="javaclass" style="margin-left:10px;" name="javaclass" size=50/>
														   	<div style="margin-top:5px;color:red;">说明：请输入完整类名（包含包名）且不要加.java后缀,如：com.xxxx.xxxx
														   	<br/> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此类必须实现接口：weaver.gp.execution.AccessItemManager
														   	<br/> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;实现方法名为：public double getAccessItemScore(Map map)
														   	<br/> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;参数含义：map中key值  user->User对象,cycle->考核周期,gval->目标值,cval->完成值</div>
														</div>
													</TD>
												</TR>
												<TR id="formulatr2" style="height: 1px;display: none;">
													<TD class=Line colSpan=2></TD>
												</TR>
												<TR>
													<TD class=ntitle>是否启用</TD>
													<TD class=Field>
														<input class=inputstyle type="checkbox" name="isvalid" value="1" checked="checked"/>
													</TD>
												</TR>
												<TR style="height: 1px;">
													<TD class=Line colSpan=2></TD>
												</TR>
											</TBODY>
										</TABLE>
									</form>
								</td>
							</tr>
						</TABLE>
					</td>
					<td></td>
				</tr>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
		</table>
		<script language=javascript>  
			jQuery(document).ready(function(){
				jQuery("input[type=checkbox]").bind("click",function(){
					if(jQuery(this).attr("checked")){
						jQuery(this).val(1);
					}else{
						jQuery(this).val(0);
					}
				});
				$("#selectedul").sortable({stop:showformula});
					
					$('.operatorul li').click(function(){
						var insertHtml = '' 
						if($(this).hasClass("number")){
						   insertHtml = "<li class='ui-state-default bg_li number' ><input type='text' class='numipt' style='ime-mode:disabled;' maxlength='10' value='10' /><div class='remove'></div></li>";
						}else if($(this).hasClass("basekpi")){
						   var $t = $(this).attr('kpiid');
						   insertHtml = "<li class='ui-state-default bg_li basekpi' kpiid='"+$t+"'><span>" + $(this).html() + "</span><div class='remove'></div></li>"; 
						}else{
						   insertHtml = "<li class='ui-state-default bg_li' ><span>" + $(this).html() + "</span><div class='remove'></div></li>"; 
						}
						$("#selected").find('ul').append(insertHtml);
						showformula();
					});
					$('#formula').change(function(){
					   if($(this).val()==12){
					       $('#formuladiv').css('display','block');
					       $('#javaformula').css('display','none');
					   }else if($(this).val()==13){
					       $('#javaformula').css('display','block');
					       $('#formuladiv').css('display','none');
					       $('#kpiformula').val('');
					   }else{
					       $('#formuladiv').css('display','none');
					       $('#kpiformula').val('');
					       $('#javaformula').css('display','none');
					   }
					});
					$('.remove').live('click',function(){
						$(this).parents('li:first').remove();
						showformula();
					});
					$("#selected input.numipt").live('keyup',function(){
				        var tmptxt=$(this).val();       
				        $(this).val(tmptxt.replace(/[^\- \d.]/g,''));
				    }).live('paste',function(){       
				        var tmptxt=$(this).val();       
				        $(this).val(tmptxt.replace(/[^\- \d.]/g,''));       
				    }).live('blur',function(){
				       var tmptxt=$(this).val();
				       if(isNaN(tmptxt)){
				          alertStyle('请输入正确的数字!');
				          $(this).val('');
				          $(this).focus();
				       }
				       showformula();
				    });
				    $('#javaclass').keyup(function(){
				       var tmptxt=$(this).val();
				       $(this).val(tmptxt.replace(/[^a-zA-Z0-9\.]/g,''));
				    }).live('paste',function(){       
				        var tmptxt=$(this).val();
				        $(this).val(tmptxt.replace(/[^a-zA-Z0-9\.]/g,''));    
				    }).css("ime-mode", "disabled");
			});
			function showformula(){
				  var kpiformula = ''; 
				      $('#selectedul li').each(function(i,v){
						var _this = $(v);
						if(_this.hasClass('number')){
							kpiformula += _this.find('input').val();
						}else{
							kpiformula += _this.find('span').html();
						}
					  });
					  if(kpiformula==''){
					    $('#showformula').html('');
					  }else{
					    $('#showformula').html("预览:  "+kpiformula);
					  }
				}
			function submitData(obj) {
			   var formula = $('#formula').val();
			   var itemtype = $('#itemtype').val();
				    if(formula==12 && itemtype==2){
				      var kpiformula = '', string = '', num = 0.11; 
				      $('#selectedul li').each(function(i,v){
						var _this = $(v);
						if(_this.hasClass('basekpi')){
							kpiformula += _this.attr('kpiid');
							string += '('+(num * ( i + 1 ))+')';
						}else if(_this.hasClass('number')){
							kpiformula += _this.find('input').val();
							string += _this.find('input').val();
						}else{
							kpiformula += _this.find('span').html();
							string += _this.find('span').html();
						}
					  });
					  var flag = false;
					  try{
						var result =  eval(string);
						if( isNaN(result) || 'Infinity'.indexOf(result) > -1)
							flag = true;
					  }catch(exception){
						flag = true;
					  }
				      if(flag){
						alertStyle("表达式不正确！请重新配置！");
						return false;
					  }
					  if(kpiformula == ''){
						alertStyle("表达式不正确！请重新配置！");
						return false;
					  }
					  $('#kpiformula').val(kpiformula);
				    }
				if(check_form(frmMain,'itemname')){
				    if(formula!=13 || itemtype!=2){
						$('#javaclass').val('');
					}
				    if(formula==13 && itemtype==2){
				        var javaclass = $.trim($('#javaclass').val());
				        if(javaclass==''){
				           alertStyle("请输入全类名！");
				           return false;
				        }
				        if(javaclass.indexOf('.')==-1){
					         alertStyle("请输入完整的java类名！");
					         return false;
					    }else{
					         if(javaclass.substring(javaclass.lastIndexOf('.'))=='.java'){
					             alertStyle("请不要包含.java后缀！");
					             return false;
					         }
					    }
				    }
				    obj.disabled = true;
					jQuery("#weaver").submit();
			 	}
			}
			function changeType(val){
				if(val==2){
					jQuery("#unittr").show();
					jQuery("#unittr2").show();
					jQuery("#formulatr").show();
					jQuery("#formulatr2").show();
				}else{
					jQuery("#unittr").hide();
					jQuery("#unittr2").hide();
					jQuery("#formulatr").hide();
					jQuery("#formulatr2").hide();
				}
			}
		</script>
	</BODY>
</HTML>
