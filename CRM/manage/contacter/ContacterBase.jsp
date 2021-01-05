
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.util.CrmFieldComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<%@ include file="/CRM/data/uploader.jsp" %>
<%
	String userid = user.getUID()+"";
	String contacterid = Util.null2String(request.getParameter("ContacterID"));
	if("2".equals(user.getLogintype())){
		response.sendRedirect("/CRM/data/ViewContacter.jsp?ContacterID="+contacterid);
		return;
	}
	rs.executeProc("CRM_CustomerContacter_SByID", contacterid);
	if (rs.getCounts() <= 0) {
		response.sendRedirect("/base/error/DBError.jsp?type=FindData");
		return;
	}
	rs.first();
	String customerid = rs.getString(2);

	boolean canedit = false;
	if(!customerid.equals("")){
		//判断此客户是否存在
		rs2.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		if(!rs2.next()){
			response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
			return;
		}
		//判断是否有查看该客户商机权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(userid,customerid);
		if(sharelevel<1){
			response.sendRedirect("/notice/noright.jsp") ;
			return;
		}
		//判断是否有编辑该客户商机权限
		if(sharelevel>1){
			canedit = true;
		}
		if(rs2.getInt("status")==7 || rs2.getInt("status")==8){
			canedit = false;
		}
	}
	
	String firstname = Util.toScreenToEdit(rs.getString("firstname"),user.getLanguage());
	
	//int nolog = Util.getIntValue(request.getParameter("nolog"),0);
	
	String Creater =  Util.toScreenToEdit(rs.getString("creater"),user.getLanguage());
	String CreateDate = Util.toScreenToEdit(rs.getString("createdate"),user.getLanguage());
	String CreateTime = Util.toScreenToEdit(rs.getString("createtime"),user.getLanguage());
	if(Creater.equals("") || CreateDate.equals("") || CreateTime.equals("")){
		rs2.executeSql("select top 1 t1.logtype,t1.documentid,t1.logcontent,t1.submitdate,t1.submittime,t1.submiter,t1.clientip,t1.submitertype"
				 +" from CRM_Log t1,CRM_Modify t2"
				 +" where t1.submitdate=t2.modifydate and t1.submittime=t2.modifytime and t1.customerid=t2.customerid"
				 +" and t1.logtype='nc' and t1.customerid="+customerid+" and t2.type="+contacterid);
		if(rs2.next()){
			Creater = Util.null2String(rs2.getString("submiter"));
			CreateDate = Util.null2String(rs2.getString("submitdate"));
			CreateTime = Util.null2String(rs2.getString("submittime"));
		}
	}
	
	String Modifier = "";
	String ModifyDate = "";
	String ModifyTime = "";
	rs2.executeSql("select top 1 t1.logtype,t1.documentid,t1.logcontent,t1.submitdate,t1.submittime,t1.submiter,t1.clientip,t1.submitertype"
			 +" from CRM_Log t1,CRM_Modify t2"
			 +" where t1.submitdate=t2.modifydate and t1.submittime=t2.modifytime and t1.customerid=t2.customerid"
			 +" and t1.logtype='mc' and t1.customerid="+customerid+" and t2.type="+contacterid+" order by t1.submitdate desc,t1.submittime desc");
	if(rs2.next()){
		Modifier = Util.null2String(rs2.getString("submiter"));
		ModifyDate = Util.null2String(rs2.getString("submitdate"));
		ModifyTime = Util.null2String(rs2.getString("submittime"));
	}
	if(Modifier.equals("")) Modifier = Creater;
	if(ModifyDate.equals("")) ModifyDate = CreateDate;
	if(ModifyTime.equals("")) ModifyTime = CreateTime;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>查看联系人-<%=firstname %></title>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min_wev8.js"></script>
		<script language="javascript" src="../js/util_wev8.js"></script>
		<script language="javascript" src="/workrelate/js/relateoperate_wev8.js"></script>
		
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
		
		<link rel="stylesheet" href="../css/Base_wev8.css" />
		<link rel="stylesheet" href="../css/Contact_wev8.css" />
		
		
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<style type="text/css">
			.input_select{width: 98px !important;}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			input{line-height: 180%;}
			.item_input,.other_input{line-height: 20px;}
		</style>
		<![endif]-->
	</head>
	<body>
	
		<wea:layout attributes="{layoutTableId:topTitle}">
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
					<%if(canedit){ %>
						<!-- 
						<input class="e8_btn_top middle" onclick="showLog()" type="button"  value="日志明细"/>
						-->
						<input class="e8_btn_top middle" onclick="doDel()" type="button"  value="删除"/>
					<%}%>	
					<span title="菜单" class="cornerMenu"></span>
				</wea:item>
			</wea:group>
		</wea:layout>
		
		<!-- 
		<table id="main" style="width: 100%;height: 100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center" valign="top">
					
					<div style="width:100%;height: 100%;margin: 0px auto;text-align: left;">
					-->
						<div style="display:none;width: 100%;height: 28px;margin-top: 4px;background: url('../images/title_bg_wev8.gif') repeat-x;color:#666666;border: 1px #CCCCCC solid;">
							<div style="line-height: 28px;margin-left: 10px;font-weight: bold;float: left;">联系人：</div>
							<div style="line-height: 28px;margin-left: 0px;float: left;">
								<%=firstname %>
							</div>
							<div class="logtxt" style="float: right;margin-right: 5px;">
								<%if(!Creater.equals("") && !CreateDate.equals("") && !CreateTime.equals("")){ %>
								<div style="line-height: 28px;margin-left: 40px;float: left;">由 <%=cmutil.getHrm(Creater) %> 于 <%=CreateDate %> <%=CreateTime %> 创建</div>
								<%} %>
								<div id="lastupdate" style="line-height: 28px;margin-left: 20px;float: left;">由 <%=cmutil.getHrm(Modifier) %> 于 <%=ModifyDate %> <%=ModifyTime %> 最后修改</div>
								<%if(canedit){ %>
								<div class="btn_operate" style="" onclick="showLog();">日志明细</div>
								<%
									rs2.executeProc("CRM_Find_CustomerContacter",customerid);
									if(rs2.getCounts()>1) {
								%>
								<div class="btn_operate" style="" onclick="doDel();">删除</div>
								<%	} %>
								<%} %>
							</div>
						</div>
						<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
						<tr>
						<td valign="top" width="*">
						<!-- 左侧商机信息开始 -->
						<div id="leftdiv" style="width: 100%;overflow-x:hidden;" class="scroll1">
							<!-- 基本信息开始 -->
							<table style="width: 100%;margin-top: 0px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="*"/></colgroup>
								<tr>
									<td>
										<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
										
											<%
											rst.execute("select * from CRM_CustomerDefinFieldGroup where usetable = 'CRM_CustomerContacter' order by dsporder asc");
											while(rst.next()){
												String groupid = rst.getString("id");
												CrmFieldComInfo comInfo = new CrmFieldComInfo("CRM_CustomerContacter",groupid) ;
												if(0 == comInfo.getArraySize() && !groupid.equals("6")){
													continue;
												}
												%>
										
												<wea:group context="<%=SystemEnv.getHtmlLabelName(rst.getInt("grouplabel"),user.getLanguage())%>">
													
													<%if(groupid.equals("6")){ %>
														<wea:item>客户名称</wea:item>
														<wea:item>
															<div class="div_show">
																<a href="javascript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?CustomerID=<%=customerid %>')">
																	<%=CustomerInfoComInfo.getCustomerInfoname(customerid) %>
																</a>
															</div>
														</wea:item>
													<%} %>
													
													<%while(comInfo.next()){%>
														
													<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
													<wea:item>
														
														<%if(canedit){%>
															<%=CrmUtil.getHtmlElementSetting(comInfo ,rs.getString(comInfo.getFieldname()) ,user , "edit")%>
														<%}%>
														<%=CrmUtil.getHmtlElementInfo(comInfo ,rs.getString(comInfo.getFieldname()) ,user , canedit?"edit":"info")%>
													</wea:item>
													<%} %>
												</wea:group>
											<%} %>
										</wea:layout>
									</td>
								</tr>
							</table>
							<!-- 基本信息结束 -->
							<!--
							<div style="width: 100%;height: 20px;float: left;"></div>
							 -->
						</div>
						<!-- 左侧商机信息结束 -->
						</td>
						<td id="righttd" valign="top" width="35%">
						<!-- 右侧联系记录开始 -->
						<div id="rightdiv" style="width: 100%;">
							<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
								<col width="*"/></colgroup>
								<tr>
									<td class="" style="width:1px;border-left:1px solid #dadada;"></td>
									<td style="position: relative;">
										<div class="item_title item_title1">客户联系</div>
										<div class="item_line"></div>
										<div id="contactdiv" style="width: 100%;height: auto;">
											<iframe id='contentframe' src='/CRM/data/ViewContactLog.jsp?CustomerID=<%=customerid%>&isfromtab=true&from=base' height=100% width="100%" border=0 frameborder="0" scrolling="auto"></iframe>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<!-- 右侧联系记录结束 -->
						</td>
						</tr>
						</table>
						<!-- 
					</div>
				</td>
			</tr>
		</table>
		 -->
		<%if(canedit){ %>
		<div id="pr_select" style="min-width: 100px;height: auto;overflow: hidden;position: absolute;display: none;background: #fff;
															border: 1px #CACACA solid;padding-left: 0px;padding-right: 0px;
															border-radius: 3px;
															-moz-border-radius: 3px;
															-webkit-border-radius: 3px;
															box-shadow: 0px 0px 3px #CACACA;
															-moz-box-shadow: 0px 0px 3px #CACACA;
															-webkit-box-shadow: 0px 0px 3px #CACACA;">
				<div id="roleitem_项目决策人" class="roletype">项目决策人</div>
				<div id="roleitem_客户高层" class="roletype">客户高层</div>
				<div id="roleitem_内部向导" class="roletype">内部向导</div>
				<div id="roleitem_技术影响人" class="roletype">技术影响人</div>
				<div id="roleitem_需求影响人" class="roletype">需求影响人</div>
				<div id="roleitem_其他" class="roletype">其他</div>
				<div style="width: 100%;text-align: center;height: 22px;line-height: 22px;">
					<a style="width: 50%;text-align: center;" href="javascript:updateRoleType()">确定</a>&nbsp;
					<a style="width: 50%;text-align: center;" href="javascript:cancelRoleType()">取消</a>
				</div>
		</div>
		<div id="ismain_select" class="item_select" _inputid="ismain">
			<div class="item_option" _val="1"><%=SystemEnv.getHtmlLabelName(25104,user.getLanguage())%></div><!-- 是 -->
			<div class="item_option" _val="0"><%=SystemEnv.getHtmlLabelName(25105,user.getLanguage())%></div><!-- 否 -->
		</div>
		<div id="isneedcontact_select" class="item_select" _inputid="isneedcontact">
			<div class="item_option" _val="1"><%=SystemEnv.getHtmlLabelName(25104,user.getLanguage())%></div><!-- 是 -->
			<div class="item_option" _val="0"><%=SystemEnv.getHtmlLabelName(25105,user.getLanguage())%></div><!-- 否 -->
		</div>
		<div id="isperson_select" class="item_select" _inputid="isperson">
			<div class="item_option" _val="1"><%=SystemEnv.getHtmlLabelName(25104,user.getLanguage())%></div><!-- 是 -->
			<div class="item_option" _val="0"><%=SystemEnv.getHtmlLabelName(25105,user.getLanguage())%></div><!-- 否 -->
		</div>
		<div id="attitude_select" class="item_select" _inputid="attitude">
			<div class="item_option" _val="支持我方">支持我方</div>
			<div class="item_option" _val="未表态">未表态</div>
			<div class="item_option" _val="未反对">未反对</div>
			<div class="item_option" _val="未反对">未反对</div>
			<div class="item_option" _val="反对">反对</div>
		</div>
		<div id="status_select" class="item_select" _inputid="status">
			<div class="item_option" _val="1"><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage()) %></div>
			<div class="item_option" _val="0"><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage()) %></div>
			<div class="item_option" _val="2"><%=SystemEnv.getHtmlLabelName(463,user.getLanguage()) %></div>
		</div>
		<div id="language_select" class="item_select" _inputid="language">
			<% 
				while(LanguageComInfo.next()){
			%>
			<div class="item_option" _val="<%=LanguageComInfo.getLanguageid() %>"><%=LanguageComInfo.getLanguagename() %></div>
			<%	} %>
		</div>
		
		<!-- 日志明细开始 -->
		<div id="log_detail" class="scroll2" style="height: 410px;width: 98%;margin: 0px auto;position: relative;display:none;">
			<div id="logmore" class="datamore" style="display: none;text-align: left !important; " 
				onclick="getListLog(this)" _datalist="logtable" 
				_currentpage="0" _pagesize="30" _total="" title="显示更多数据">更多</div>
			<div id="log_load" style="display:none;width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;background: url('../images/loading2_wev8.gif') center no-repeat;"></div>
		</div>
		<!-- 日志明细结束 -->
		<%} %>
		
		<!-- 提示信息 -->
		<div id="warn">
			<div class="title"></div>
		</div>
		
		<style>
			
			.sbHolder{
				display:none;
			}
			
			.browser{
				display:none;
				height:28px;
			}
			.calendar{
				display: none;
			}
			.e8_txt{
				height:28px;
				line-height:28px;
			}
		</style>
		
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
			
			var tempval = "";//用于记录原值
			var foucsobj2 = null;
			
			$(document).ready(function(){
				//绑定附件上传功能
				jQuery("div[name=uploadDiv]").each(function(){
			        bindUploaderDiv($(this),"<%=contacterid%>"); 
			        jQuery(this).find("#uploadspan").append($(this).attr("checkinputImage"));
			        if(jQuery(this).attr("ismust")== 1 && jQuery(this).parent("td").find(".txtlink").length != 0){
		    			jQuery("#"+$(this).attr("fieldNameSpan")).html("");
		    		}
		    	});
		    	
		    	//绑定checkbox事件
				jQuery(".item_checkbox").bind("click",function(){
					exeUpdate(jQuery(this).attr("name"),jQuery(this).is(":checked")?"1":"0","num");
				});
				
				jQuery("#objName").css("font-size","16px");
				<%if(canedit){%>

				$(".item_input").bind("focus",function(){
					$(this).addClass("item_input_focus");
					var _selectid = getVal($(this).attr("_selectid"));
					if(_selectid!=""){
						if($(this).attr("id")=="projectrole"){
							var selectids = $(this).val();
							var ids = selectids.split(",");
							$("div.roletype").removeClass("roletype_select");
							for(var i=0;i<ids.length;i++){
								if(ids[i]!=""){
									$("#roleitem_"+ids[i]).addClass("roletype_select");
								}
							}
						}
						var _top = $(this).offset().top + 26;
						var _left = $(this).offset().left;
						$("#"+_selectid).css({"top":_top,"left":_left}).show();
						$(this).width(100);
					}
					if(this.id=="experience" || this.id=="remark"){
						$(this).height(70);
					}
					tempval = $(this).val();
					foucsobj2 = this;
				}).bind("blur",function(){
					$(this).removeClass("item_input_focus");
					if(this.id=="experience" || this.id=="remark"){
						setRemarkHeight(this.id);
					}
					if(!$(this).hasClass("input_select")){
						doUpdate(this,1);
					}
				});

				//输入添加按钮事件绑定
				$("div.btn_add").bind("click",function(){
					$(this).hide();
					$(this).nextAll("div.btn_browser").hide();
					$(this).prevAll("div.showcon").hide();
					$(this).prevAll("input.add_input").show().focus();
					$(this).prevAll("input.add_input2").show().focus();
					$(this).prevAll("div.btn_select").show();
				});
				
				//表格行背景效果及操作按钮控制绑定
				$("table.LayoutTable").find("td.field").bind("click mouseenter",function(){
					$(".btn_add").hide();$(".btn_browser").hide();
					$(this).addClass("td_hover").prev("td.title").addClass("td_hover");
					$(this).find(".item_input").addClass("item_input_hover");
					//$(this).find(".item_num").width(100);
					
					$(this).find("span.browser").show();
					$(this).find(".calendar").show();
					$(this).find("div.e8_txt").hide();
					
					//对select框进行处理
					$(this).find(".sbHolder").parent().show();
					$(this).find("div.e8_select_txt").hide();
					
					if($(this).find("input.add_input2").css("display")=="none"){
						$(this).find("div.btn_add").show();
						$(this).find("div.btn_browser").show();
					}
					$(this).find("div.btn_add2").show();
					$(this).find("div.btn_browser2").show();

					if($(this).attr("id")=="imcodetd") $("#imcodelink").show();
					//$(this).find("div.upload").show();
				}).bind("mouseleave",function(){
					$(this).removeClass("td_hover").prev("td.title").removeClass("td_hover");
					$(this).find(".item_input").removeClass("item_input_hover");
					//$(this).find(".item_num").width(40);
					
					$(this).find("span.browser").hide();
					$(this).find(".calendar").hide();
					$(this).find("div.e8_txt").show();
					
					//对select框进行处理
					if($(this).find(".sbHolder").length>0){
						var sb=$(this).find("select").attr("sb");
						var e=event?event:window.event;
						if($("#sbOptions_"+sb).parent().is(":hidden")){
							$(this).find(".sbHolder").parent().hide();
							$(this).find("div.e8_select_txt").show();
						}	
					}
					
					if($(this).find("input.add_input2").css("display")=="none"){
						$(this).find("div.btn_add").hide();
						$(this).find("div.btn_browser").hide();
					}
					$(this).find("div.btn_add2").hide();
					$(this).find("div.btn_browser2").hide();
					if($(this).attr("id")=="imcodetd") $("#imcodelink").hide();
					//$(this).find("div.upload").hide();
				});
				
				$(".sbHolder").parent().hide();

				$("div.item_option").bind("mouseover",function(){
					$(this).addClass("item_option_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("item_option_hover");
				}).bind("click",function(){
					var _inputid = $(this).parent().attr("_inputid")
					var obj = $("#"+_inputid);
					tempval = obj.val();
					obj.val($(this).attr("_val"));
					$("#"+_inputid+"name").val($(this).html());
					
					doUpdate(obj,1);
				});

				//联想输入框事件绑定
				$("input.add_input2").bind("focus",function(){
					if($(this).attr("_init")==1){
						$(this).FuzzyQuery({
							url:"/CRM/manage/util/GetData.jsp",
							record_num:5,
							filed_name:"name",
							searchtype:$(this).attr("_searchtype"),
							divwidth: $(this).attr("_searchwidth"),
							updatename:$(this).attr("id"),
							operate:"select",
							updatetype:"str"
						});
						$(this).attr("_init",0);
					}
					foucsobj2 = this;
				}).bind("blur",function(e){
					$(this).val("");
					$(this).hide();
					$(this).nextAll("div.btn_add").show();
					$(this).nextAll("div.btn_browser").show();
					$(this).prevAll("div.showcon").show();
				});

				$("div.datamore").live("mouseover",function(){
					$(this).addClass("datamore_hover");
				}).live("mouseout",function(){
					$(this).removeClass("datamore_hover");
				});

				$("#leftdiv").scroll(function(){
					$(".item_select").hide();
				});


				//页面点击及回车事件绑定
				$(document).bind("click",function(e){
					var target=$.event.fix(e).target;
					if(!$(target).hasClass("item_select")){
						$("div.item_select").hide();
						if($(target).hasClass("input_select")){
							var _selectid = $(target).attr("_selectid");
							$("#"+_selectid).show();
						}
					}
					if($(target).attr("id")!="projectrole" && $(target).parent().attr("id") != "pr_select"){
						$("#pr_select").hide();
				    }
				}).bind("keydown",function(e){
					e = e ? e : event;   
				    if(e.keyCode == 13){
						var target=$.event.fix(e).target;
						if($(target).hasClass("item_input") && $(target).attr("id")!="experience" && $(target).attr("id")!="remark"){
				    		$(foucsobj2).blur();  
				    		$("div.item_select").hide();
				    		$("#pr_select").hide();
				    	}
				    }
				});

				<%}%>

				//关注事件绑定
				$("div.btn_att").bind("click",function() {
					var attobj = $(this);
					var _special = attobj.attr("_special");
					var contacterid =  attobj.attr("_contacterid");
					$.ajax({
						type: "post",
						url: "/CRM/manage/util/Operation.jsp",
					    data:{"operation":"do_attention","operatetype":3,"objid":contacterid,"settype":_special}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
					    	if(_special==1){
								attobj.attr("title","取消关注").attr("_special","0").html("取消关注");
							}else{
								attobj.attr("title","标记关注").attr("_special","1").html("标记关注");
							}
					    	showMsg();
					    }
				    });
				});

				//收缩展开绑定
				$("#btn_center").bind("mouseover",function(){
					$(this).addClass("btn_right");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_right");
				}).bind("click",function(){
					var _status = $(this).attr("_status");
					if(_status==0){
						$(this).attr("_status",1).attr("title","展开").addClass("btn_left");
						$("#righttd").width(0).hide();
						//$("#leftdiv").width("99%");
					}else{
						$(this).attr("_status",0).attr("title","收缩").removeClass("btn_left");
						$("#righttd").width("29%").show();
						//$("#leftdiv").width("70%");
					}
					setPosition();
				});

				$("div.roletype").bind("mouseover",function(){
					$(this).addClass("roletype_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("roletype_hover");
				}).bind("click",function(){
					if($(this).hasClass("roletype_select")){
						$(this).removeClass("roletype_select");
					}else{
						$(this).addClass("roletype_select");
					}
				});

				setPosition();
				setRemarkHeight("experience");
				setRemarkHeight("remark");
			});

			var resizeTimer = null;  
			$(window).resize(function(){
				if(resizeTimer) clearTimeout(resizeTimer);  
				resizeTimer = setTimeout("setPosition()",100);  
			});
			
			
			function onShowDate1(spanname,inputname,mand){
			  tempval = $ele4p(inputname).value;
			  var fieldName = jQuery($ele4p(inputname)).parent("td").find("input").attr("name");
			  var oncleaingFun = function(){
				    if(mand == 1){
					 	$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
					}else{
					  	$ele4p(spanname).innerHTML = '';
					}
					$ele4p(inputname).value = '';
			  }
			  WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
					$dp.$(inputname).value = dp.cal.getDateStr();
					$dp.$(spanname).innerHTML = dp.cal.getDateStr();
				   	if($ele4p(inputname).value!=tempval){
				   		exeUpdate(fieldName,$ele4p(inputname).value,"str");
				   	}
					
			 },oncleared:oncleaingFun});
			   
			   
			   
			   if(mand == 1){
			     var hidename = $ele4p(inputname).value;
				 if(hidename != ""){
					$ele4p(inputname).value = hidename; 
					$ele4p(spanname).innerHTML = hidename;
				 }else{
				   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				 }
			   }
			}
				
			function setPosition(){
					if($(window).width()<800){
						$("#main").width(800);
					}else{
						$("#main").width("100%");
					}
				
					var wh = $(window).height();
					$("#main").height(wh);
					$("#btn_center").height(wh);
					
					var _top = $("#contactdiv").offset().top;
					$("#contactdiv").height(wh-_top-5);
	
					var _top2 = $("#leftdiv").offset().top;
					$("#leftdiv").height(wh-_top2-5);
			}
			function setRemarkHeight(remarkid){
				if($("#"+remarkid).length>0){
					$("#"+remarkid).height("auto");
					var h= document.getElementById(remarkid).scrollHeight; 
					//h = $("#"+remarkid).height();
					//alert(h);alert(document.getElementById(remarkid).clientHeight);
					//alert($("#"+remarkid).val().indexOf("\n"))
					if(h>70){
						$("#"+remarkid).height(70);
						//$("#"+remarkid).height(textarea.scrollHeight);
					}else if(h<20 || ($("#"+remarkid).val().indexOf("\n")<0 && h==34)){
						$("#"+remarkid).height(20);
					}else{
						$("#"+remarkid).height(h);
					}
				}
			}

			//提醒操作
			function doRemind(settype){
				$.ajax({
					type: "post",
					url: "/CRM/manage/util/Operation.jsp",
				    data:{"operation":"do_remind","operatetype":3,"objid":"<%=contacterid%>","settype":settype}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    if(settype==1) showMsg();
				    }
			    });
			}
			function setLastUpdate(){
				
				var currentdate = new Date();
				datestr = currentdate.format("yyyy-MM-dd hh:mm:ss");
				$("#lastupdate").html("由 <a href='/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>' target='_blank'><%=ResourceComInfo.getLastname(user.getUID()+"")%></a> 于 "+datestr+" 最后修改");
				
				showMsg();
			}

			<%if(canedit){%>
			//修改项目角色
			function updateRoleType(){
				var selectnames = "";
				$("div.roletype_select").each(function(){
					selectnames += "," + $(this).html();
				});
				if(selectnames!=""){
					selectnames = selectnames.substring(1);
				}

				var obj = $("#projectrole");
				tempval = obj.val();
				obj.val(selectnames);
				doUpdate(obj,1);
			}
			function cancelRoleType(){
				$("#pr_select").hide();
			}
			function delpic(){
				if(confirm("确定要删除此图片吗？")){
					$.ajax({
						type: "post",
					    url: "Operation.jsp",
					    data:{"operation":"delpic","contacterid":<%=contacterid%>,"customerid":<%=customerid%>}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
					    	$("#picimg").attr("src","");
							$("#picshow").hide();
							$("#picadd").show();
							setLastUpdate();
						}
				    });
			    }
			}
			function setPic(imgid){
				$("#contacterimageid").val("");
				$("#picimg").attr("src","/weaver/weaver.file.FileDownload?fileid="+imgid);
				$("#picshow").show();
				$("#picadd").hide();
				setLastUpdate();
			}
			function savepic(){
				if($("#contacterimageid").val()==""){
					alert("请选择图片！");
					return;
				}
				$("#savepicform").submit();
			}
			//删除操作
			function doDel(){
				if(confirm("确定删除此联系人?")){
					$.ajax({
						type: "post",
					    url: "Operation.jsp",
					    data:{"operation":"delete","contacterid":<%=contacterid%>}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
					    	alert("删除成功!");
					    	window.close();
						}
				    });
				}
			}
			//显示日志
			function showLog(){
					//$("#transbg").show();
					//$("#log_list").show();
					//$("#log_load").show();
					$.ajax({
						type: "post",
					    url: "Operation.jsp",
					    data:{"operation":"get_log_count","contacterid":<%=contacterid%>,"customerid":<%=customerid%>}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
						    var txt = $.trim(data.responseText);
					    	$("#logmore").attr("_total",txt).attr("_currentpage","0").click();
					    	
					    	var dialog = new window.top.Dialog();
							dialog.currentWindow = window;
							dialog.ID="log_detail";
							dialog.InvokeElementId="log_detail";
							dialog.Title="日志明细";
							
							dialog.Width = 600;
							dialog.Height =550;
							dialog.Drag = true;
							dialog.show();
						}
				    });
			}
			
			var dialog;
			function showLog2(){
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.ID="log_detail";
				dialog.InvokeElementId="log_detail";
				
				dialog.Width = 600;
				dialog.Height =550;
				dialog.Drag = true;
				dialog.show();
			}
			
			//关闭日志
			function closeLog(){
				$("#transbg").hide();
				$("#log_list").hide();
				$("div.logitem").remove();
			}
			//读取日志更多记录
			function getListLog(obj){
				var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
				var _pagesize = $(obj).attr("_pagesize");
				var _total = $(obj).attr("_total");
				$(obj).html("<img src='../images/loading3_wev8.gif' align='absMiddle'/>");
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"get_log_list","contacterid":<%=contacterid%>,"customerid":<%=customerid%>,"currentpage":_currentpage,"pagesize":_pagesize,"total":_total}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	var records = $.trim(data.responseText);
				    	$("#log_load").hide();
				    	$("div.logitem").remove();
				    	$(obj).before(records);
				    	if(_currentpage*_pagesize>=_total){
				    		$(obj).hide();
					    }else{
					    	$(obj).attr("_currentpage",_currentpage).html("更多").show();
						}
					}
			    });
			}

			//输入框保存方法
			function doUpdate(obj,type){
				var fieldname = $(obj).attr("id");
				var fieldtype = getVal($(obj).attr("_type"));
				if(fieldtype=="") fieldtype="str";
				var fieldvalue = "";
				if(type==1){
					if($(obj).val()==tempval) return;
					fieldvalue = $(obj).val();
				}
				if(fieldname=="title" || fieldname=="firstname" || fieldname=="jobtitle"){
					if(fieldvalue=="") {
						$(obj).val(tempval);
						return;
					}
				}
				if(fieldname=="email"){
					var emailStr = fieldvalue.replace(" ","");
					if (!checkEmail(emailStr)) {
						$(obj).val(tempval);
						return;
					}
				}
				
				if(obj.nodeName=="SELECT"){
					$("#txtdiv_"+fieldname).html($(obj).find("option[value="+fieldvalue+"]").text()).show();
					var sb=$(obj).attr("sb");
					$("#sbHolderSpan_"+sb).hide();
				}
				
				exeUpdate(fieldname,fieldvalue,fieldtype);
			}
			//删除选择性内容
			function doDelItem(fieldname,fieldvalue,setid){
				$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
				if(fieldname=="principalIds"){
					var vals = ","+$("#"+fieldname+"_val").val()+",";
					var _index = vals.indexOf(","+fieldvalue+",")
					if(_index>-1 && $.trim(fieldvalue)!=""){
						vals = vals.substring(0,_index+1)+vals.substring(_index+(fieldvalue+"").length+2);
						if(vals!="" && vals!=","){
							vals = vals.substring(1,vals.length-1);
						}else{
							vals = "";
						}
						$("#"+fieldname+"_val").val(vals);
						exeUpdate(fieldname,vals,'',fieldvalue);
					}
				}else{
					exeUpdate(fieldname,'0','num');
				}
			}
			function callBackSelectUpdate(event,data,name,oldid){
				doSelectUpdate(name,data.id,data.name,oldid);
			}
			
			function callBackSelectDelete(text,fieldid,params){
				// alert(123);
				// alert(params);
			}
			
			//选择内容后执行更新
			function doSelectUpdate(fieldname,id,name,oldid){
				var addtxt = "";
				var fieldtype = "num";

				if(fieldname=="principalIds"){
					var sumids = "";
					var addids = "";
					var ids = id.split(",");
					var names = name.split(",");
					var vals = $("#"+fieldname+"_val").val();
					for(var i=0;i<ids.length;i++){
						if((","+vals+",").indexOf(","+ids[i]+",")<0 && $.trim(ids[i])!=""){
							addids += "," + ids[i];
							addtxt += doTransName(fieldname,ids[i],names[i]);
						}
					}
					if(addids==""){
						return;
					}else{
						addids = addids.substring(1);
						sumids = addids;
						if(vals!="") sumids = vals+","+addids;
						$("#"+fieldname).before(addtxt);
						$("#"+fieldname+"_val").val(sumids);
						exeUpdate(fieldname,sumids,"","",addids);
					}
				}else{
					tempval = oldid;
					if(tempval==id) return;

					$("#txtdiv_"+fieldname).html(name);
					//addtxt = doTransName(fieldname,id,name);
					//$("#"+fieldname).prev("div.txtlink").remove();
					//$("#"+fieldname).before(addtxt);

					exeUpdate(fieldname,id,"num");
				}
			}
			//执行编辑
			function exeUpdate(fieldname,fieldvalue,fieldtype,delvalue,addvalue,setid){
				if(fieldtype == "attachment"){
					var ismust = jQuery("div[fieldName='"+fieldname+"']").attr("ismust");
		    		if(ismust==1 && jQuery("div[fieldName='"+fieldname+"']").parent("td").find(".txtlink").length == 1){
		    			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
		    			return;
		    		}
				}
				var _tempval = tempval;
				if(fieldname=="ismain") fieldname="main";
				if(typeof(delvalue)=="undefined") delvalue = "";
				if(typeof(addvalue)=="undefined") addvalue = "";
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_contacter_field","contacterid":<%=contacterid%>,"setid":setid,"fieldname":filter(encodeURI(fieldname)),"oldvalue":filter(encodeURI(tempval)),"newvalue":filter(encodeURI(fieldvalue)),"fieldtype":fieldtype,"delvalue":encodeURI(delvalue),"addvalue":encodeURI(addvalue)}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    //var txt = $.trim(data.responseText);
					    setLastUpdate();
					    if(fieldname=="main" && fieldvalue==1){
					    	$("#maintd").html("<div class='div_show'>是</div>");
						}
					    if(fieldname=="imcode"){
							$("#imcodelink").attr("href","tencent://message/?uin="+fieldvalue+"&Site=&Menu=yes");
					    }
					    
					    if(fieldtype == "attachment"){
				    		jQuery(".txtlink"+delvalue).remove();
				    		var ismust = jQuery("div[fieldName='"+fieldname+"']").attr("ismust");
				    		if(ismust==1 && jQuery("div[fieldName='"+fieldname+"']").parent("td").find(".txtlink").length == 0){
				    			var fieldNameSpan = jQuery("div[fieldName='"+fieldname+"']").attr("fieldNameSpan");
				    			jQuery("#"+fieldNameSpan).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
				    		}
				    	}
					}
			    });
				tempval = fieldvalue;
			}
			
			//显示删除按钮
			function showdel(obj){
				$(obj).find("div.btn_del").show();
				$(obj).find("div.btn_wh").hide();
			}
			//隐藏删除按钮
			function hidedel(obj){
				$(obj).find("div.btn_del").hide();
				$(obj).find("div.btn_wh").show();
			}
			function onShowBrowser(fieldname,url){
				var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
			    if (datas) {
				    if(datas.id!=""){
				    	doSelectUpdate(fieldname,datas.id,datas.name);
					}
			    }
			}			
			function mailValid() {
				var emailStr = jQuery("#CEmail").val();
				emailStr = emailStr.replace(" ","");
				if (!checkEmail(emailStr)) {
					alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
					jQuery("#CEmail").focus();
					return;
				}
			}
					
			function doTransName(fieldname,id,name){
				var delname = fieldname;
				if(startWith(fieldname,"_")) fieldname = fieldname.substring(1);
				var restr = "";
				restr += "<div class='txtlink ";
				if(fieldname=="manager" || fieldname=="remarkDoc"){restr += "showcon";}
				restr += " txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
				restr += "<div style='float: left;'>";
					
				if(fieldname=="manager" || fieldname=="principalIds"){
					restr += "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
				}else if(fieldname=="remarkDoc"){
					restr += "<a href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+id+"') >"+name+"</a>";
				}else{
					restr += name;
				}
				
				restr +="</div>";
				if(fieldname!="manager"){
				restr += "<div class='btn_del' onclick=\"doDelItem('"+delname+"','"+id+"')\"></div>"
					   + "<div class='btn_wh'></div>";
				}
				restr += "</div>";
				
				return restr;
			}
			<%}%>
			
		  //消息提醒
		  function showMsg(msg){
		   
			jQuery("#warn").find(".title").html("操作成功！");
			jQuery("#warn").css("display","block");
			setTimeout(function (){
				jQuery("#warn").css("display","none");
			},1500);
			
		  }
		  
		  
			
		</script>
	</body>
</html>
