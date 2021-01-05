<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
	<head>
		  <link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		  <link href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel="stylesheet">
		  <script language="javascript" src="/js/weaver_wev8.js"></script>
		  <script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		  <script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		  <script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		  <script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		  <link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		  <link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		  <script language="javascript" src="/proj/js/common_wev8.js"></script>
		  <style type="text/css">
			.blankspan{display:inline-block;width:20px;}
		  </style>
		  <script type="text/javascript">
		  	var selectnum = 0;
		 	jQuery(document).ready(function(){
		 		jQuery('.groupHeadHide').find("input[type='checkbox']").each(function(){
		 			var checkboxname = jQuery(this).attr('name');
		 			//点击不同类型时，选择对应的所有选项的选择框
		 			jQuery('#weaver').find("input[name='"+checkboxname+"']").change(function(){
			 			if(jQuery(this).is(":checked")){
			 				jQuery("#weaver").find("input[name^='"+checkboxname+"_']").attr('checked',true);
			 				changeSelectNum(jQuery("#weaver").find("input[name^='"+checkboxname+"_']").length,'+');
			 			}else{
			 				jQuery("#weaver").find("input[name^='"+checkboxname+"_']").attr('checked',false);
			 				jQuery("#weaver").find("input[name^='"+checkboxname+"_']").each(function(){
		 						var _name = jQuery(this).attr('name').replace(checkboxname+"_",'');
	 							var _type = jQuery('#'+_name).attr('type');
	 							resetAll(_type,_name);
			 				});
			 			}
			 		});
			 		
			 		
			 		jQuery('#weaver').find("input[name^='"+checkboxname+"_']").change(function(){
			 			if(!jQuery(this).is(":checked")){
			 				if(jQuery("#weaver").find("input[name^='"+checkboxname+"_']:checked").length === 0){
			 					jQuery("#weaver").find("input[name='"+checkboxname+"']").attr('checked',false);
			 				}
			 			}
			 		});
			 		
			 		
	 				jQuery('#weaver').find("input[name^='"+checkboxname+"_']").each(function(){
	 					var _object = this;
	 					var _name = jQuery(this).attr('name').replace(checkboxname+"_",'');
	 					var _type = jQuery('#'+_name).attr('type');
	 					if(_type === 'checkbox'){
 							remindSetAddFn(_name,_object);
	 					}else{
				 			jQuery('#'+_name).click(function(){
				 				if(!jQuery(_object).attr('checked')){
				 					jQuery(_object).attr('checked',true);
				 					changeSelectNum(1,'+');
				 				}
				 			});
			 			}
			 			
			 			//点击最前面的选择框时清空对应的值
			 			jQuery(this).click(function(){
			 				if(!jQuery(this).is(":checked")){
				 				resetAll(_type,_name);
			 				}else{
			 					changeSelectNum(1,'+');
			 				}
			 			});
					});	
		 		});
		 		
		 		//全选
		 		jQuery('#weaver').find("input[name='selectAll']").change(function(){
		 			if(jQuery(this).is(":checked")){
		 				jQuery('.groupHeadHide').find("input[type='checkbox']").each(function(){
		 					var checkboxname = jQuery(this).attr('name');
		 					jQuery('#weaver').find("input[name='"+checkboxname+"']").attr('checked',true);
		 					jQuery("#weaver").find("input[name^='"+checkboxname+"_']").attr('checked',true);
		 					changeSelectNum(jQuery("#weaver").find("input[name^='"+checkboxname+"_']").length,'+');
		 				});
		 			}else{
		 				jQuery('.groupHeadHide').find("input[type='checkbox']").each(function(){
		 					var checkboxname = jQuery(this).attr('name');
		 					jQuery('#weaver').find("input[name='"+checkboxname+"']").attr('checked',false);
		 					jQuery("#weaver").find("input[name^='"+checkboxname+"_']").attr('checked',false);
		 					jQuery("#weaver").find("input[name^='"+checkboxname+"_']").each(function(){
		 						var _name = jQuery(this).attr('name').replace(checkboxname+"_",'');
	 							var _type = jQuery('#'+_name).attr('type');
	 							resetAll(_type,_name);
			 				});
		 				});
		 			}
		 		});
		 		setTimeout(function(){
		 			jQuery('#saveBtn',parent.document).css('max-width',150);
		 		},200);
		 		
		 	});
		 	
		 	
		 	function changeclickbrowndp(event,datas,name,_callbackParams){
		 		var obj = jQuery('#weaver').find("input[name='corC_newdocpath']");
		 		if(!obj.attr('checked')){
			 		obj.attr('checked',true);
			 		changeSelectNum(1,'+');
		 		}
		 	}
		 	
		 	function changeclickbrowpc(){
		 		var obj = jQuery('#weaver').find("input[name='fuJianD_docPath']");
		 		if(!obj.attr('checked')){
			 		obj.attr('checked',true);
			 		changeSelectNum(1,'+');
		 		}
		 	}
		 	
	 		function remindSetAddFn(_name,_object){
		 		if(_name === 'remindSet'){
		 			jQuery('#remindSet').click(function(){
		 				if(jQuery('#remindSet').attr('checked')){
					 		jQuery('#remindSetDiv').show();			
			 				jQuery(_object).attr('checked',true);
			 				changeSelectNum(1,'+');
		 				}else{
			 				jQuery('#remindSetDiv').hide();
			 				jQuery(_object).attr('checked',false);
			 				changeSelectNum(1,'-');
		 				}
		 			});
			 	}else{
				 	jQuery('#'+_name).click(function(){
				 		if(!jQuery(_object).attr('checked')){
							jQuery(_object).attr('checked',true);
				 			changeSelectNum(1,'+');
				 		}
					});
			 	}
	 		}
	 		
	 		function resetAll(_type,_name){
		 		if(_type === 'checkbox'){
					jQuery('#'+_name).trigger('checked',false);
					if(_name === 'remindSet'){
						jQuery('#remindSetDiv').hide();
					}
				}else if(_type === 'select-one'){
					jQuery('#'+_name).selectbox('change',0);
				}else{
					jQuery('#'+_name).val('');
					jQuery('#'+_name+'span').html('');
				}
				changeSelectNum(1,'-');
	 		}
	 		
	 		function changeSelectNum(selecteds,_d){
	 			if(_d === '+'){
		 			selectnum = selectnum + selecteds;
		 		}else{
		 			selectnum = selectnum - selecteds;
		 		}
	 			
	 			var btntext = jQuery('#saveBtn',parent.document).val();
	 			btntext = btntext.replace(/\(.*?\)/,'('+selectnum+')');
	 			jQuery('#saveBtn',parent.document).val(btntext);
	 		}
	 		
	 		function doSave(){
	 			enableAllmenu();	
	 			var wfids = jQuery(parent.parent.document).contents().find('#leftframe')[0].contentWindow.getSelectedWfids();
	 			if('' === wfids){
	 				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127158,user.getLanguage())%>",function(){
		 				displayAllmenu();
	 				});
	 				return;
	 			}
				var checkeddetails = getSelectedNames();
				if('' === checkeddetails){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127123,user.getLanguage())%>",function(){
						displayAllmenu();
					});
					return;
				}	
	 			jQuery('#wfids').val(wfids);
	 			jQuery('#weaver').find("input[name='checkeddetails']").val(checkeddetails);
	 			weaver.submit();
	 		}
	 		
	 		function getSelectedNames(){
	 			var checkeddetails = '';
	 			jQuery('.groupHeadHide').find("input[type='checkbox']").each(function(){
	 				var checkboxname = jQuery(this).attr('name');
	 				jQuery("#weaver").find("input[name^='"+checkboxname+"_']:checked").each(function(){
						var _name = jQuery(this).attr('name').replace(checkboxname+"_",'');
						checkeddetails += _name+',';
	 				});
	 			});
	 			
	         	if(checkeddetails.length > 0){
	         		checkeddetails = checkeddetails.substring(0,checkeddetails.length - 1);
	         	}
	         	return checkeddetails;
	 		}
	 		
	 		
	 		function onShowCatalog(spanName) {
				var urls = "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";
			    var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.URL = urls;
				dialog.callbackfun = function (paramobj, result) {
					if (result) {
						changeclickbrowpc();
				        if (result.tag>0)  {
				           jQuery('#'+spanName).html("<a href='#"+result.id+"'>"+result.path+"</a>");
				           jQuery('#docPath').val(result.path);
				           jQuery("#maincategory").val(result.mainid);
				           jQuery("#subcategory").val(result.subid);
				           jQuery("#seccategory").val(result.id);
				        }else{
				           jQuery('#'+spanName).html('');
				           jQuery("#docPath").val('');
				           jQuery("#maincategory").val('');
				           jQuery("#subcategory").val('');
				           jQuery("#seccategory").val('');
				        }
				    }
				} ;
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(125058,user.getLanguage()) %>";
				dialog.Width = 550 ;
				dialog.Height = 550 ;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.show();
			}
			
			function openLogDialog(){
				var title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
				var url = "/workflow/selectItem/selectItemMain.jsp?topage=wfbatchsetloglist";
				var diagtemp = new window.top.Dialog();
				diagtemp.currentWindow = window;	
				diagtemp.URL = url;
				diagtemp.Width = 1020;
				diagtemp.Height = 580;
				diagtemp.Title = title
				diagtemp.Drag = true;
				diagtemp.show();	
			}
			
			function ShowFnaHidden2(){
				jQuery('#defaultitle').toggle();
			}
	 		
	 		
	 		function totitletab(){
				if(window.top.Dialog){
					diag_vote = new window.top.Dialog();
				} else {
					diag_vote = new Dialog();
				}
				diag_vote.currentWindow = window;
				diag_vote.Width = 900;
				diag_vote.Height = 650;
				diag_vote.Modal = true;
				diag_vote.maxiumnable = true;
				diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(31844,user.getLanguage())%>";
				diag_vote.URL = "/workflow/workflow/WFTitleCode.jsp?workflowid=-1";
				diag_vote.show();
			}
		  </script>
	</head>
	<%
		String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage())+":";
		
		//是否启用流程明细表通过EXCEL导入配置
		String isOpenWorkflowImportDetail=GCONST.getWorkflowImportDetail();
		String isOpenWorkflowImportDetailShow = "{'display':''}";
		if(!isOpenWorkflowImportDetail.equals("1")) isOpenWorkflowImportDetailShow = "{'display':'none'}";

	%>
	<%!
		private static String appendCheckbox(String name,String checkboxname){
		    return "<input type=\"checkbox\" name=\""+checkboxname+"\" notBeauty=\"true\" value=\"1\"><span class=\"blankspan\"></span>"+name;
		}
	%>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelNames("86,1426,83957",user.getLanguage())+",javascript:doSave(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:openLogDialog(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form name="weaver" id="weaver" method="post" action="WfBatchSet_operation.jsp">
			<input type="hidden" name="checkeddetails" value=""/>
			<input type="hidden" id="wfids" name="wfids" value=""/>
			
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td>
					</td>
					<td class="rightSearchSpan" style="text-align:right; width:500px!important">			
						<input type="button" value="<%=SystemEnv.getHtmlLabelNames("86,1426,83957",user.getLanguage())%>(0)" class="e8_btn_top" id="saveBtn" onclick="doSave();"/>	
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%>" class="e8_btn_top" onclick="openLogDialog();"/>
						<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
					
			<wea:layout type="2col">
				<wea:group context='' attributes="{'groupDisplay':'none'}">
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(332,user.getLanguage()),"selectAll")%></wea:item>
				</wea:group>
				<!-- 基本信息 -->
				<wea:group context='<%=appendCheckbox(SystemEnv.getHtmlLabelName(1361,user.getLanguage()),"basicA")%>'>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(31485,user.getLanguage()),"basicA_isvalid")%></wea:item>
					<wea:item>
					    <select id="isvalid" name="isvalid">
				        	<option value="1"><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
				        	<option value="2"><%=SystemEnv.getHtmlLabelName(25496,user.getLanguage())%></option>
					    </select>
					    <input type="hidden" name="isvalid_name" value="31485">
					</wea:item>
				</wea:group>
				<!-- 提醒设置 -->
				<wea:group context='<%=appendCheckbox(SystemEnv.getHtmlLabelName(21946,user.getLanguage()),"messageB")%>'>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(21946,user.getLanguage()),"messageB_remindSet")%></wea:item>
					<wea:item>
						<input type="checkbox" id="remindSet" name="remindSet" tzCheckbox="true" value="1">
						<input type="hidden" name="remindSet_name" value="21946">
						<div id="remindSetDiv" style="display:none;">
							<div style="padding-top:10px;"><%=SystemEnv.getHtmlLabelName(127126,user.getLanguage())%><span class="blankspan"></span>
								<input type="checkbox" name="messageType" value="1" ><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%><span class="blankspan"></span>
 								<input type="checkbox" name="chatsType" value="1" ><%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%><span class="blankspan"></span>
 								<input type="checkbox" name="mailMessageType" value="1" ><%=SystemEnv.getHtmlLabelName(31488,user.getLanguage())%><span class="blankspan"></span>
							</div>
							<div style="padding-top:10px;">
	 							<span><%=SystemEnv.getHtmlLabelName(32163,user.getLanguage())%></span><span class="blankspan"></span>
	 							<input type="checkbox" id="archiveNoMailAlert" name="archiveNoMailAlert" tzCheckbox="true" value="1">
 							</div>
						</div>
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(31489,user.getLanguage()),"messageB_needaffirmance")%></wea:item>
					<wea:item>
						<input type="checkbox" id="needaffirmance" name="needaffirmance" tzCheckbox="true" value="1">
						<input type="hidden" name="needaffirmance_name" value="31489">
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(31490,user.getLanguage()),"messageB_isShowChart")%></wea:item>
					<wea:item>
						<input type="checkbox" id="isShowChart" name="isShowChart" tzCheckbox="true" value="1">
						<input type="hidden" name="isShowChart_name" value="31490">
					</wea:item>
				</wea:group>
				<!-- 功能设置 -->
				<wea:group context='<%=appendCheckbox(SystemEnv.getHtmlLabelName(32383,user.getLanguage()),"corC")%>'>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(31486,user.getLanguage()),"corC_defaultName")%></wea:item> 
					<wea:item>
						<input type="checkbox" name="defaultName" id="defaultName" tzCheckbox="true"   onclick="ShowFnaHidden2()"   value="1">
						<input type="hidden" name="defaultName_name" value="31486">
						<span class="blankspan"></span><span id="defaultitle" style="display:none;"><a href="#" onclick="totitletab()" style="color:blue;TEXT-DECORATION:none"><%=SystemEnv.getHtmlLabelName(31844,user.getLanguage())%></a></span> 
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(125047,user.getLanguage()),"corC_iscust")%></wea:item>
					<wea:item>
						<input type="checkbox" id="iscust" name="iscust" tzCheckbox="true" value="1" onchange="onchangeiscust(this.value)">
						<input type="hidden" name="iscust_name" value="125047">
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(31491,user.getLanguage()),"corC_multiSubmit")%></wea:item>
					<wea:item>
						<input type="checkbox" id="multiSubmit" name="multiSubmit" tzCheckbox="true" value="1">
						<input type="hidden" name="multiSubmit_name" value="31491">
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(82607,user.getLanguage()),"corC_isshared")%></wea:item>	
					<wea:item>
						<input type="checkbox" id="isshared" name="isshared" tzCheckbox="true" value="1" >
						<input type="hidden" name="isshared_name" value="82607">
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(81778,user.getLanguage()),"corC_isforwardrights")%></wea:item>	
					<wea:item>
						<input type="checkbox" id="isforwardrights" name="isforwardrights" tzCheckbox="true" value="1" >
						<input type="hidden" name="isforwardrights_name" value="81778">
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(31493,user.getLanguage()),"corC_isModifyLog")%></wea:item>
					<wea:item>
						<input type="checkbox" id="isModifyLog" name="isModifyLog" tzCheckbox="true" value="1" >
						<input type="hidden" name="isModifyLog_name" value="31493">
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(31495,user.getLanguage()),"corC_docRightByOperator")%></wea:item>
					<wea:item>
						<input type="checkbox" tzCheckbox="true" id="docRightByOperator" name="docRightByOperator" value="1" >
						<input type="hidden" name="docRightByOperator_name" value="31495">
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(125048,user.getLanguage()),"corC_newdocpath")%></wea:item>
					<wea:item>
						<brow:browser id="newdocpath" name="newdocpath" viewType="0" hasBrowser="true" hasAdd="false" idKey="id" nameKey="path"
						                browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
						                completeUrl="/data.jsp?type=categoryBrowser" _callback="changeclickbrowndp"  width="300px" browserValue='' browserSpanValue='' />
						<input type="hidden" name="newdocpath_name" value="125048">		
					</wea:item>
					<wea:item attributes='<%=isOpenWorkflowImportDetailShow %>'><%=appendCheckbox(SystemEnv.getHtmlLabelName(26254,user.getLanguage()),"corC_isImportDetail")%></wea:item>
					<wea:item attributes='<%=isOpenWorkflowImportDetailShow %>'>
						 <input type="checkbox" tzCheckbox="true" name="isImportDetail" id="isImportDetail" value="1" onclick="isImportDetailChanged();" > 
						 <select id="importDetailType" class="inputstyle" onChange="importDetailTypeChanged();" style="display:none;">
						 	<option value="1"><%=SystemEnv.getHtmlLabelName(33844,user.getLanguage())%></option>
						 	<option value="2"><%=SystemEnv.getHtmlLabelName(33845,user.getLanguage())%></option>
						 </select>
						 <input type="hidden" name="isImportDetail_name" value="26254">
					</wea:item>
				</wea:group>
				<!-- 附件设置 -->
				<wea:group context='<%=appendCheckbox(SystemEnv.getHtmlLabelName(23796,user.getLanguage()),"fuJianD") %>'>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelNames("17616,92",user.getLanguage()),"fuJianD_docPath")%></wea:item>
					<wea:item>
					    <select class="inputstyle" id="catelogType" name="catelogType"  style="float: left;" disabled>
					    	<option value=0 selected><%=SystemEnv.getHtmlLabelName(19213,user.getLanguage())%></option>
					    </select>
						<brow:browser id="docPath" name="docPath" viewType="0" hasBrowser="true" hasAdd="false" 
						                browserOnClick="onShowCatalog('docPathspan')" isMustInput="1" isSingle="true" hasInput="true"
						                completeUrl="/data.jsp?type=categoryBrowser"  width="300px" browserValue='' browserSpanValue='' /> 
					    <input type=hidden id='maincategory' name='maincategory' value="">
					    <input type=hidden id='subcategory' name='subcategory' value="">
					    <input type=hidden id='seccategory' name='seccategory' value="">
					    <input type="hidden" name="docPath_name" value="17616,92">	
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(22944,user.getLanguage()),"fuJianD_candelacc")%></wea:item>
					<wea:item>
						<input type="checkbox" id="candelacc" name="candelacc" tzCheckbox="true" value="1">
						<input type="hidden" name="candelacc_name" value="22944">
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(31494,user.getLanguage()),"fuJianD_isneeddelacc")%></wea:item>
					<wea:item>
						<input type="checkbox" id="isneeddelacc" tzCheckbox="true" name="isneeddelacc" value="1">
						<input type="hidden" name="isneeddelacc_name" value="31494">
				      	<span class="blankspan"></span>
						<span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(28572,user.getLanguage()) %>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>	      	
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(27025,user.getLanguage()),"fuJianD_forbidAttDownload")%></wea:item>
					<wea:item>
						<input type="checkbox" id="forbidAttDownload" name="forbidAttDownload" tzCheckbox="true" value="1" >
						<input type="hidden" name="forbidAttDownload_name" value="27025">
					</wea:item>
				</wea:group>
				<!-- 签字意见 -->
				<wea:group context='<%=appendCheckbox(SystemEnv.getHtmlLabelName(17614,user.getLanguage()),"qianZiE")%>'>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(81648,user.getLanguage()),"qianZiE_orderbytype")%></wea:item>
					<wea:item>
						<select class="inputstyle" id="orderbytype" name="orderbytype" onchange="changeOrderShow()" >
					    	<option value=1><%=SystemEnv.getHtmlLabelName(21604,user.getLanguage())%></option>
					    	<option value=2><%=SystemEnv.getHtmlLabelName(21605,user.getLanguage())%></option>
					    </select><span class="blankspan"></span>
					    <input type="hidden" name="orderbytype_name" value="81648">
						<span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(21604,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(21628,user.getLanguage())+"，"+SystemEnv.getHtmlLabelName(21605,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(21629,user.getLanguage())%>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>	
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(31500,user.getLanguage()),"qianZiE_issignview")%></wea:item>
					<wea:item>
						<input type="checkbox" name="issignview" id="issignview" tzCheckbox="true" value="1">
						<input type="hidden" name="issignview_name" value="31500">
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(34035,user.getLanguage()),"qianZiE_isSignDoc")%></wea:item>
					<wea:item>
						<input type="checkbox" name="isSignDoc" id="isSignDoc" tzCheckbox="true" value="1">
						<input type="hidden" name="isSignDoc_name" value="34035">
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(34034,user.getLanguage()),"qianZiE_isSignWorkflow")%></wea:item>
					<wea:item>
						<input type="checkbox" name="isSignWorkflow" id="isSignWorkflow" tzCheckbox="true" value="1">
						<input type="hidden" name="isSignWorkflow_name" value="34034">
					</wea:item>
					<wea:item><%=appendCheckbox(SystemEnv.getHtmlLabelName(34036,user.getLanguage()),"qianZiE_isannexUpload")%></wea:item>
					<wea:item>
						<input type="checkbox" name="isannexUpload" id="isannexUpload" tzCheckbox="true" value="1">
						<input type="hidden" name="isannexUpload_name" value="34036">
					</wea:item>
				</wea:group>
			</wea:layout>
		</form>
	</body>
</html>