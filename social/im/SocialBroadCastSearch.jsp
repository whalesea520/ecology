<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	String content = Util.null2String(request.getParameter("content"), "");
%>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>
<body  style="background-color:transparent">
<div id="maincontent">
	<table style="width:100%; padding: 10px;" align="center">
		<colgroup>
			<col width="10%"/>
			<col width="40%"/>
			<col width="10%"/>
			<col width="40%"/>
		</colgroup>
		<tr style="height:45px;">
			<td><%=SystemEnv.getHtmlLabelName(131685, user.getLanguage()) %></td> <!-- 广播内容 -->
			<td>
				<input id='broadcontent' name='broadcontent' class="InputStyle" value="<%=content %>">
			</td>
			<td><%=SystemEnv.getHtmlLabelName(131687, user.getLanguage()) %></td> <!-- 发送人 -->
			<td>
				<brow:browser viewType="0" name="sender" browserValue=""  
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp" width="80%" 
						browserSpanValue="">
				</brow:browser>
			</td>
		</tr>
		
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(131688, user.getLanguage()) %></td> <!-- 发送时间 -->
			<td>
				<select onchange='BCS.setDateRange(this)'>
					<option value='0'><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %></option> <!-- 全部 -->
					<option value='1'><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage()) %></option> <!-- 今天 -->
					<option value='2'><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage()) %></option> <!-- 本周 -->
					<option value='3'><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage()) %></option> <!-- 本月 -->
					<option value='4'><%=SystemEnv.getHtmlLabelName(21904 , user.getLanguage()) %></option> <!-- 本季 -->
					<option value='5'><%=SystemEnv.getHtmlLabelName(15384 , user.getLanguage()) %></option> <!-- 本年 -->
					<option value='6'><%=SystemEnv.getHtmlLabelName(32530, user.getLanguage()) %></option> <!-- 指定日期范围 -->
				</select>
				<input type='hidden' id='_begindate' name='begindate'>
				<input type='hidden' id='_enddate' name='enddate'>
			</td>
			<td colspan=2>
				<span class='dateSpanWrap'>
					<input type="text" name="begindate" readonly="readonly" class="inputStyle middle dateSpan" id="begindate" value="" onclick="BCS.wrachOuter(1);onShowDate('begindate','begindate')"/>
					<BUTTON type="button" class="SCalendar middle" onclick="BCS.wrachOuter(1);onShowDate('begindate','begindate')"></BUTTON>
					<input type="text" name="enddate" readonly="readonly" class="inputStyle middle dateSpan" id="enddate" value="" onclick="BCS.wrachOuter(1);onShowDate('enddate','enddate')"/>
					<BUTTON type="button" class="SCalendar middle" onclick="BCS.wrachOuter(1);onShowDate('enddate','enddate')"></BUTTON>
				</span>
			</td>
			<td>
				
			</td>
		</tr>
	
	</table>
	<!-- 按钮 -->
	<div class="btnToolbar">
		<div id="btnSearch" class="btn" onclick="BCS.doSearch();"><%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %></div> <!-- 搜索 -->
		<div id="btnReset" class="btn" onclick="BCS.doReset();"><%=SystemEnv.getHtmlLabelName(2022, user.getLanguage()) %></div>
		<div id="btnCancel" class="btn" onclick="BCS.doCancel();"><%=SystemEnv.getHtmlLabelName(201, user.getLanguage()) %></div><!-- 取消 -->
	</div>
</div>

 <style>
 	* {
 		padding: 0;
		margin: 0;
		font-size:12px;
		color:#374660;
		overflow: hidden;
 	}
 	#maincontent{
 		height: 134px;
 		background: #fff;
 		border-bottom: 1px solid #d0d3d8; 
 	}
 	.btn {
		border: 1px solid #e3e3e3;
   		display: inline-block;
	}
	.btnToolbar {
		text-align: center;
	}
	.SCalendar {
   		background: url(/social/images/calendar_wev8.png) no-repeat;
   		width: 16px;
   		height: 16px;
	}
	.dateSpan {
   		width: 120px;
	}
	.dateSpanWrap {
   		display: none;
	}
	.selOptionGroup{
		position: absolute;
		
	}
 </style>
 
 <script>
 	$(function(){
 		beautySelect();
 		var searchMain = $("#searchFitPane",parent.document);
 		searchMain.css({'background': 'transparent','height': 'auto'});
 		parent.IMUtil.shutLoading();
 		searchMain.attr('loaded','loaded');
 		BCS.wrachOuter(1);
 		$(document).bind('click', function(e){
 			var parentDivObj = $((e.target || e.srcElement)).closest('div');
 			if(parentDivObj.length <= 0){
 				searchMain.toggleClass('isopen');
 				searchMain.slideToggle();
 			}
 		});
 	});
 	var BCS = {
 		wrachOuter: function(action){
 			var searchMain = $("#searchFitPane",parent.document);
 			if(action){
 				searchMain.css('bottom', '0');
 			}else{
 				searchMain.css('bottom', 'unset');
 			}
 			return true;
 		},
 		packParams: function(){
 			var content = $('#broadcontent').val();
 			var senderid = $('#sender').val();
 			var timestart = $('#_begindate').val();
 			var timeend = $('#_enddate').val();
 			if(timestart==''&&timeend==''){
 				timestart = $('#begindate').val();
 				timeend = $('#enddate').val();
 			}
 			return {
 				content: content,
 				senderid: senderid,
 				timestart: timestart,
 				timeend: timeend
 			};
 		},
 		setDateRange: function(obj){
			var optValue = $(obj).val();
			console.log(optValue);
			if(optValue == 6){
				$('.dateSpanWrap').show();
			}else{
				$('.dateSpanWrap').hide();
			}
			var IMDateUtil = parent.IMDateUtil;
			var start = $('#_begindate');
			var end = $('#_enddate');
			switch(optValue){
			case '1':
				var d = IMDateUtil.getFormat(new Date());
				start.val(d);
				end.val(d);
			break;
			case '2':
				start.val(IMDateUtil.getWeekStartDate());
				end.val(IMDateUtil.getWeekEndDate());
			break;
			case '3':
				start.val(IMDateUtil.getMonthStartDate());
				end.val(IMDateUtil.getMonthEndDate());
			break;
			case '4':
				start.val(IMDateUtil.getQuarterStartDate());
				end.val(IMDateUtil.getQuarterEndDate());
			break;
			case '5':
				start.val(IMDateUtil.getYearStartDate());
				end.val(IMDateUtil.getYearEndDate());
			break;
			default:
				start.val('');
				end.val('');
			}
			console.log('start:'+start.val(),'end:'+end.val());
		},
		doSearch: function(){
			var params = this.packParams();
			var BC = parent.BCHandler;
			if(BC){
				BC.loadMsgList(params, function(){
					BC.showEmptyBg();
				});
			}
			this.wrachOuter(0);
		},
		doReset: function(){
			$('#broadcontent').val('');
 			$('#sender').val('');
 			$('#_begindate').val('');
 			$('#_enddate').val('');
 			$('#begindate').val('');
 			$('#enddate').val('');
		},
		doCancel: function(){
			this.doReset();
			var searchMain = $("#searchFitPane",parent.document);
			searchMain.toggleClass('isopen');
			searchMain.slideToggle();
		}
 	};
 
 </script>
 </body>