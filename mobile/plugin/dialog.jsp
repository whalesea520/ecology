<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@page import="weaver.general.Util,weaver.systeminfo.*"%>
<%@ page import="weaver.general.* "%>
<%@ page import="org.apache.commons.lang.StringUtils "%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>

<!DOCTYPE html>
<html>
<head>
	<title><%=SystemEnv.getHtmlLabelName(18214, user.getLanguage()) %>:</title>
	<script type="text/javascript" src="/mobile/plugin/1/js/jquery-1.6.2.min_wev8.js"></script>
	<script type="text/javascript" src="/js/mylibs/asyncbox/AsyncBox.v1.4_wev8.js"></script>
	<link rel="stylesheet" href="/js/mylibs/asyncbox/skins/ZCMS/asyncbox_wev8.css">
	<style type="text/css">
	.searchText {
		width:100%;
		height:20px;
		margin-left:auto;
		margin-right:auto;
		border: 1px solid #687D97; 
		background:#fff;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px; 
		border-radius:5px;
		-webkit-box-shadow: inset 0px 5px 3px 0px #BCBFC3;
		-moz-box-shadow: inset 0px 5px 3px 0px #BCBFC3;
		box-shadow: inset 0px 5px 3px 0px #BCBFC3;
	}
	
	.operationBt {
			height:26px;
			margin-left:18px;
			line-height:26px;
			font-size:14px;
			color:#fff;
			text-align:center;
			-moz-border-radius: 5px;
			-webkit-border-radius: 5px; 
			border-radius:5px;
			border:1px solid #0084CB;
			background:#0084CB;
			background: -moz-linear-gradient(0, #30B0F5, #0084CB);
			background:-webkit-gradient(linear, 0 0, 0 100%, from(#30B0F5), to(#0084CB));
			overflow:hidden;
			float:left;
	}
	.width50 {
		width:50px;
	}
	
	.blockHead {
		width:100%;
		height:24px;
		line-height:24px;
		font-size:12px;
		font-weight:bold;
		color:#fff;
		border-top:1px solid #0084CB;
		border-left:1px solid #0084CB;
		border-right:1px solid #0084CB;
		-moz-border-top-left-radius: 5px;
		-moz-border-top-right-radius: 5px;
		-webkit-border-top-left-radius: 5px; 
		-webkit-border-top-right-radius: 5px; 
		border-top-left-radius:5px;
		border-top-left-radius:5px;
		background:#0084CB;
		background: -moz-linear-gradient(0, #31B1F6, #0084CB);
		background:-webkit-gradient(linear, 0 0, 0 100%, from(#31B1F6), to(#0084CB));
	}
	
	.m-l-14 {
		margin-left:14px;
	}
	
	
	.tblBlock {
		width:100%;
		border-left:1px solid #C5CACE;
		border-right:1px solid #C5CACE;
		border-bottom:1px solid #C5CACE;
		background:#fff;
		-moz-border-bottom-left-radius: 5px;
		-moz-border-bottom-right-radius: 5px;
		-webkit-border-bottom-left-radius: 5px; 
		-webkit-border-bottom-right-radius: 5px; 
		border-bottom-left-radius:5px;
		border-bottom-left-radius:5px;
	}
	
	#asyncbox_alert_content {
		height:auto!important;
		min-height:10px!important;
	}
	
	#asyncbox_alert{
		min-width: 220px!important;
		max-width: 280px!important;
	}
	</style>
	
	
	<SCRIPT type="text/javascript">
	<%
	String returnShowField = Util.null2String(request.getParameter("returnShowField"));
	String returnIdField = Util.null2String(request.getParameter("returnIdField"));
	boolean isMuti = "1".equals(Util.null2String(request.getParameter("isMuti"))) ? true : false;
	String requestid = Util.null2String(request.getParameter("requestid"));
	String nodeid = Util.null2String(request.getParameter("nodeid"));
	String browserTypeId = Util.null2String(request.getParameter("browserTypeId"));
	String customBrowType = Util.null2String(request.getParameter("customBrowType"));
	String joinFieldParams = Util.null2String(request.getParameter("joinFieldParams"));
	String method = Util.null2String(request.getParameter("method"));
	String linkhref =  Util.null2String(request.getParameter("linkhref"));
	
	int fnaworkflowid = Util.getIntValue(request.getParameter("fnaworkflowid"), -1);
	String fnafieldid = Util.null2String(request.getParameter("fnafieldid"));
	String isFnaSubmitRequest4Mobile = Util.null2String(request.getParameter("isFnaSubmitRequest4Mobile")).trim();
	int orgtype = Util.getIntValue(request.getParameter("orgtype"), -1);
	int orgid = Util.getIntValue(request.getParameter("orgid"), -1);
	int orgtype2 = Util.getIntValue(request.getParameter("orgtype2"), -1);
	int orgid2 = Util.getIntValue(request.getParameter("orgid2"), -1);
	String isFnaRepayRequest4Mobile = Util.null2String(request.getParameter("isFnaRepayRequest4Mobile")).trim();
	int fnaWfRequestid = Util.getIntValue(request.getParameter("fnaWfRequestid"), 0);
	int main_fieldIdSqr_controlBorrowingWf = Util.getIntValue(request.getParameter("main_fieldIdSqr_controlBorrowingWf"), 0);
	int main_fieldIdSqr_val = Util.getIntValue(request.getParameter("main_fieldIdSqr_val"), 0);
	String isFnaRequestApplication4Mobile = Util.null2String(request.getParameter("isFnaRequestApplication4Mobile")).trim();

	String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));//需要增加的代码
	String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));//需要增加的代码
	
	%>
	$(document).ready(function () {

		var returnShowField = "<%=returnShowField%>";
		var returnIdField  = "<%=returnIdField%>";
		
		var returnShowFieObj = parent.document.getElementById(returnShowField);
		var returnIdFieIdsObj = parent.document.getElementById(returnIdField);
		
		$(returnShowFieObj).children("span").each(function(i){
			$('#selectedspans_<%=returnIdField%>').append("<span keyid='"+$(this).attr("keyid")+"'>&nbsp;"+$(this).html()+"</span>");
		});

		var selids = $(returnIdFieIdsObj).val();
		var tmpStr = String(selids);
		while(tmpStr.indexOf(",") == 0){
			tmpStr = tmpStr.substring(1);
		}
		//id值应用于自定义浏览框中的 span标签的keyid值。

		var arrVals = tmpStr.split(",");
		
		if(selids != undefined){
			if(selids.indexOf(",") != 0){
				selids = ","+selids;
			}
			if(selids.lastIndexOf(",") != selids.length - 1){
				selids = selids+",";
			}
			$('#selectedids_<%=returnIdField%>').val(selids);
		}
		
		$(returnShowFieObj).children("a").each(function(i){
			var taghf = $(this).attr("href");
			if(taghf != undefined && taghf != null){
				var tagkeyId = taghf.substring(taghf.indexOf("(") + 1, taghf.lastIndexOf(")"));
				if(tagkeyId == ""){
					   tagkeyId = arrVals[i];
				}
				$('#selectedspans_<%=returnIdField%>').append("<span keyid='" + tagkeyId +"'>&nbsp;" + $(this).html() + "</span>");
			}else{
				taghf = $(this).attr("title");
				if(taghf != undefined && taghf != null){
					$('#selectedspans_<%=returnIdField%>').append("<span keyid='" + arrVals[i] +"'>&nbsp;" + $(this).html() + "</span>");
				}
			}
			
		});
		
		dymHeight($(document.body).children('.page').height() + 'px');
		$(document.body).css("background", "#F0F0F0");
	});
	
	</SCRIPT>
	
</head>
<body style="background:#F0F0F0;height:100%;">

<div data-role="page" class="page" style="background:#F0F0F0;margin:0;padding-left:10px;padding-right:10px;padding-top:10px;padding-bottom:10px;">
		<SCRIPT LANGUAGE="JavaScript">
			<!--
			/**
 * 为String增加endWith与startWith方法
 */
String.prototype.endWith=function(s){
	if(s==null||s==""||this.length==0||s.length>this.length)
		return false;
	if(this.substring(this.length-s.length)==s)
		return true;
	else
		return false;
	return true;
}

String.prototype.startWith=function(s){
	if(s==null||s==""||this.length==0||s.length>this.length)
		return false;
	if(this.substr(0,s.length)==s)
		return true;
	else
		return false;
	return true;
}
			function browser_dosearch_<%=returnIdField%>(){
				var keyword = encodeURI($('#keyword_<%=returnIdField%>').val());
				var pageno = $('#pageno_<%=returnIdField%>').val();
				//$.mobile.pageLoading();
				$('#resultinfo_<%=returnIdField%>').hide();
				
				$('#pageinfo_<%=returnIdField%>').hide();
				for(var i=0;i<10;i++) $('#checkdiv_'+i+'_<%=returnIdField%>').hide();
				var requestid = "<%=requestid %>";
				var nodeid = "<%=nodeid %>";
				var browserTypeId = "<%=browserTypeId %>";
				var customBrowType = "<%=customBrowType %>";
				var joinFieldParams = "<%=joinFieldParams%>";

				var fnaworkflowid = "<%=fnaworkflowid%>";
				var fnafieldid = "<%=fnafieldid%>";
				var isFnaSubmitRequest4Mobile = "<%=isFnaSubmitRequest4Mobile%>";
				var orgtype = "<%=orgtype%>";
				var orgid = "<%=orgid%>";
				var orgtype2 = "<%=orgtype2%>";
				var orgid2 = "<%=orgid2%>";
				var isFnaRepayRequest4Mobile = "<%=isFnaRepayRequest4Mobile%>";
				var fnaWfRequestid = "<%=fnaWfRequestid%>";
				var main_fieldIdSqr_controlBorrowingWf = "<%=main_fieldIdSqr_controlBorrowingWf%>";
				var main_fieldIdSqr_val = "<%=main_fieldIdSqr_val%>";
				var isFnaRequestApplication4Mobile = "<%=isFnaRequestApplication4Mobile%>";
				
				$.get('/mobile/plugin/browser.jsp?method=<%=method %>&isDis=1'+
						'&fnaworkflowid='+fnaworkflowid+'&fnafieldid='+fnafieldid+'&isFnaSubmitRequest4Mobile='+isFnaSubmitRequest4Mobile+'&orgtype='+orgtype+
						'&orgid='+orgid+'&orgtype2='+orgtype2+'&orgid2='+orgid2+'&isFnaRepayRequest4Mobile='+isFnaRepayRequest4Mobile+
						'&fnaWfRequestid='+fnaWfRequestid+'&main_fieldIdSqr_controlBorrowingWf='+main_fieldIdSqr_controlBorrowingWf+'&main_fieldIdSqr_val='+main_fieldIdSqr_val+
						'&isFnaRequestApplication4Mobile='+isFnaRequestApplication4Mobile+
						'&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>'
						,{keyword:keyword,pageno:pageno,requestid:requestid,nodeid:nodeid,browserTypeId:browserTypeId,customBrowType:customBrowType,joinFieldParams:joinFieldParams},
					function process(data){
						var page = data;//eval("("+data+")");
						$('#pagenospan_<%=returnIdField%>').html(page.pageNo);
						$('#pagetotalspan_<%=returnIdField%>').html(page.totalPages);
						$('#pageno_<%=returnIdField%>').val(page.pageNo);
						$('#pagetotal_<%=returnIdField%>').val(page.totalPages);
						$('#nextpage_<%=returnIdField%>').val(page.nextPage);
						$('#prepage_<%=returnIdField%>').val(page.prePage);

						//-----------------------------------------
						// 没有数据时的处理 START 
						//-----------------------------------------
						if (parseInt(page.totalPages) == 0) {
							dymHeight($(document.body).children(".page").height() + "px");
							$.alert("没有数据！", "提示");
						}
						//-----------------------------------------
						// 没有数据时的处理 END
						//-----------------------------------------
						
						/**/
						if(page.pageNo!=1) {
							$('#browser_first_<%=returnIdField%>').html('<a style="color:#0000ff;" onclick="browser_dofirst_<%=returnIdField%>();" ><strong><<</strong><%=SystemEnv.getHtmlLabelName(18363, user.getLanguage()) %></a>');
						} else {
							$('#browser_first_<%=returnIdField%>').html('<strong><<</strong><%=SystemEnv.getHtmlLabelName(18363, user.getLanguage()) %>');
						}
						//当前页不等于总页数，而且查询结果不为空，则将最后一页的链接置为可用
						if(page.pageNo!=page.totalPages && page.totalPages > 1) {
							$('#browser_last_<%=returnIdField%>').html('<a style="color:#0000ff;" onclick="browser_dolast_<%=returnIdField%>();" ><%=SystemEnv.getHtmlLabelName(18362, user.getLanguage()) %><strong>>></strong></a>');
						} else {
							$('#browser_last_<%=returnIdField%>').html('<%=SystemEnv.getHtmlLabelName(18362, user.getLanguage()) %><strong>>></strong>');
						}
						if(page.pageNo>page.prePage) {
							$('#browser_previous_<%=returnIdField%>').html('<a style="color:#0000ff;" onclick="browser_doprevious_<%=returnIdField%>();" ><%=SystemEnv.getHtmlLabelName(1258, user.getLanguage()) %></a>');
						} else {
							$('#browser_previous_<%=returnIdField%>').html('<%=SystemEnv.getHtmlLabelName(1258, user.getLanguage()) %>');
						}
						if(page.pageNo<page.nextPage) {
							$('#browser_next_<%=returnIdField%>').html('<a style="color:#0000ff;" onclick="browser_donext_<%=returnIdField%>();" ><%=SystemEnv.getHtmlLabelName(1259, user.getLanguage()) %></a>');
						} else {
							$('#browser_next_<%=returnIdField%>').html('<%=SystemEnv.getHtmlLabelName(1259, user.getLanguage()) %>');
						}
						
						var datas = page.result;
						for(var i=0;i<10;i++){
							if(datas[i]){
								if($('#selectedids_<%=returnIdField%>').val().indexOf(","+datas[i].id+",")>-1){
									$('#checkbox_'+i+'_<%=returnIdField%>').val(datas[i].id).attr('checked',true).attr('data',datas[i].type);//.checkboxradio("refresh");
									$('#checklabel1_'+i+'_<%=returnIdField%>').html(datas[i].show1);
								    $('#checklabel2_'+i+'_<%=returnIdField%>').html(datas[i].show2);
								    $('#checkdiv_'+i+'_<%=returnIdField%>').show();
									try{
								       browser_dochange_<%=returnIdField%>(i);
									}catch(e){}
								}else{
									$('#checkbox_'+i+'_<%=returnIdField%>').val(datas[i].id).attr('checked',false).attr('data',datas[i].type);//.checkboxradio("refresh");
								   $('#checklabel1_'+i+'_<%=returnIdField%>').html(datas[i].show1);
								   $('#checklabel2_'+i+'_<%=returnIdField%>').html(datas[i].show2);
								   $('#checkdiv_'+i+'_<%=returnIdField%>').show();
								}
							} else {
								$('#checkbox_'+i+'_<%=returnIdField%>').val("").attr('checked',false).attr('data','0');//.checkboxradio("refresh");
								$('#checklabel1_'+i+'_<%=returnIdField%>').empty();
								$('#checklabel2_'+i+'_<%=returnIdField%>').empty();
								$('#checkdiv_'+i+'_<%=returnIdField%>').hide();
							}
						}
						$('#resultinfo_<%=returnIdField%>').show();

						$('#pageinfo_<%=returnIdField%>').show();
						
						dymHeight(($(document.body).children(".page").height() + 20) + "px");
						if("exceptionoperators" == "<%=returnIdField%>"){
							parent.dynamicHeight_exceptionPage(($(document.body).children(".page").height() + 100) + "px");
						}
					}
				,'json');
			}
			/**
			 * 同步dialog容器高度
			 */
			function dymHeight(hgt) {
				//同步dialog容器div的高度

				$("#" + parent.getDialogId(), parent.window.document).css("height", hgt)
				//同步dialog容易iframe的高度

				$("#" + parent.getDialogId() + " iframe", parent.window.document).css("height", hgt)
				//同步dialog内部容器body的高度

				$(document.body).css("height", hgt);
			}
			
			function browser_clicksearch_<%=returnIdField%>(){
				$('#pageno_<%=returnIdField%>').val("1");
				browser_dosearch_<%=returnIdField%>();
			}
			function browser_dofirst_<%=returnIdField%>(){
				$('#pageno_<%=returnIdField%>').val("1");
				browser_dosearch_<%=returnIdField%>();
			}
			function browser_doprevious_<%=returnIdField%>(){
				$('#pageno_<%=returnIdField%>').val($('#prepage_<%=returnIdField%>').val());
				browser_dosearch_<%=returnIdField%>();
			}
			function browser_donext_<%=returnIdField%>(){
				$('#pageno_<%=returnIdField%>').val($('#nextpage_<%=returnIdField%>').val());
				browser_dosearch_<%=returnIdField%>();
			}
			function browser_dolast_<%=returnIdField%>(){
				$('#pageno_<%=returnIdField%>').val($('#pagetotal_<%=returnIdField%>').val());
				browser_dosearch_<%=returnIdField%>();
			}
			function browser_dochange_<%=returnIdField%>(index){
				if($('#checkbox_'+index+'_<%=returnIdField%>').length!=0
						&&$('#checklabel1_'+index+'_<%=returnIdField%>').length!=0
						&&$('#checkbox_'+index+'_<%=returnIdField%>').length!=0
						){
					var id = $('#checkbox_'+index+'_<%=returnIdField%>').val();
					var name = $('#checklabel1_'+index+'_<%=returnIdField%>').html();
					var obj = $('#checkbox_'+index+'_<%=returnIdField%>').first();
					var selectids = $('#selectedids_<%=returnIdField%>').val();
					<%
					if (isMuti) {
					%>
					if(obj.attr("checked")=="checked"){
						if(id && id!= "" && selectids.indexOf(","+id+",") == -1){
							$('#selectedids_<%=returnIdField%>').val(selectids + id+",");
							$('#selectedspans_<%=returnIdField%>').append("<span keyid='"+id+"'>&nbsp;"+name+"</span>");
							//TODO rejecttotype_rejectToNodeid
							if('<%=returnIdField%>'=='rejectToNodeid'){
								$('#rejecttotype_<%=returnIdField%>').val(obj.attr("data"));
							}
						}
					} else {
						if(id && id!= "" && selectids.indexOf(","+id+",") > -1){
							$('#selectedids_<%=returnIdField%>').val(selectids.replace(","+id+",",","));
							$('#selectedspans_<%=returnIdField%>').children("span[keyid='"+ id + "']").remove();
						}
					}
					<%
					} else {
					%>
					//$('#selectedids_<%=returnIdField%>').val(id);
					$('#selectedids_<%=returnIdField%>').val(","+id+",");
					$('#selectedspans_<%=returnIdField%>').html("<span keyid='"+id+"'>"+name+"</span>");
					if('<%=returnIdField%>'=='rejectToNodeid'){
						$('#rejecttotype_<%=returnIdField%>').val(obj.attr("data"));
					}
					<%
					}
					%>
				}
			}

			function checkBrowse(value) {
				var tempCheckArray = value.split(",");
				if (tempCheckArray == null || tempCheckArray.length == 0)  {
					return 0;
				}

				var count = 0;
				for (var i=0;i<tempCheckArray.length ;i++ ) {
					if(tempCheckArray[i].replace(/[ ]{1,}/g, "") != "") {
						count++;
					}
				}
				return count;
			}

			function browser_dook_<%=returnIdField%>(){

				var returnShowField = "<%=returnShowField%>";
				var returnIdField  = "<%=returnIdField%>";
				var method = "<%=method %>";
				
				//var returnShowFieObj = parent.document.getElementById(returnShowField);
				var returnShowFieObj = parent.$("td[id="+returnShowField+"]");
				var returnIdFieIdsObj = parent.document.getElementById(returnIdField);

				//解决多人力资源之类的浏览按钮，每天添加人员等之后所显示位置不对齐的问题。

				var returnShowHtml = "";
				$(returnShowFieObj).empty();
				
				var value = $('#selectedids_<%=returnIdField%>').val();
				var count = checkBrowse(value);
				
				//人力资源的浏览按钮的特殊处理
				if(method == "listUser"){
					//如果所选人力资源数量小于6则每行显示一个；否则每行显示多个。

					if (count < 6){
						$('#selectedspans_<%=returnIdField%>').children("span").each(function(i){
							if(i!=0){
								returnShowHtml += "<div style=\"height:10px;overflow:hidden;width:1px;\"></div>";
							}
							returnShowHtml += "<span id=\"field<%=returnIdField%>_span\" name=\"field<%=returnIdField%>_span\" keyid='"+$(this).attr("keyid")+"'>"+ $(this).html()+"</span>";
						});
						returnShowHtml = returnShowHtml.replace(/&nbsp;/g, "");
					} else {
						returnShowHtml += "<div style=\"height:10px;overflow:hidden;width:1px;\"></div>";
						var tempStr = "";
						$('#selectedspans_<%=returnIdField%>').children("span").each(function(i){
							tempStr += "<span id=\"field<%=returnIdField%>_span\" name=\"field<%=returnIdField%>_span\" keyid='"+$(this).attr("keyid")+"'>"+ $(this).html().replace(/&nbsp;/g, "") +"&nbsp;</span>";
						});
						returnShowHtml += tempStr;
					}
				//自定义多选框的处理(与页面初始化一致,永远不换行)
				} else if(method == "listBrowserData") {
					returnShowHtml += "<div style=\"height:10px;overflow:hidden;width:1px;\"></div>";
					var tempStr = "";
					$('#selectedspans_<%=returnIdField%>').children("span").each(function(i){
						 <%if("".equals(linkhref)){%>
						tempStr += "<span id=\"field<%=returnIdField%>_span\" name=\"field<%=returnIdField%>_span\" keyid='"+$(this).attr("keyid")+"'>"+ $(this).html().replace(/&nbsp;/g, "") +"&nbsp;</span>";
						 <%}else if(!"".equals(linkhref)&&linkhref.indexOf("?")==-1){%>
						tempStr += "<span id=\"field<%=returnIdField%>_span\" name=\"field<%=returnIdField%>_span\" keyid='"+$(this).attr("keyid")+"'><a title='' href='<%=linkhref%>' target='_blank'>"+ $(this).html().replace(/&nbsp;/g, "") +"</a>&nbsp;</span>";
						 <%}else{%>
						 tempStr += "<span id=\"field<%=returnIdField%>_span\" name=\"field<%=returnIdField%>_span\" keyid='"+$(this).attr("keyid")+"'><a title='' href='<%=linkhref%>"+$(this).attr("keyid")+"' target='_blank'>"+ $(this).html().replace(/&nbsp;/g, "") +"</a>&nbsp;</span>";
						 <%}%>
					});
					returnShowHtml += tempStr;
				//非人力资源的浏览按钮
				} else {
					$('#selectedspans_<%=returnIdField%>').children("span").each(function(i){
						if(i!=0){
							returnShowHtml += "<div style=\"height:10px;overflow:hidden;width:1px;\"></div>";
						}
	
						if(method=="listDocument") {
							returnShowHtml += "<span id=\"field<%=returnIdField%>_span\" name=\"field<%=returnIdField%>_span\" style='cursor:hand;color:blue;' onclick='javascript:toDocument("+$(this).attr("keyid")+");' keyid='"+$(this).attr("keyid")+"'>"+ $(this).html()+"</span>";
						} else if(method=="listWorkflowRequest") {
							returnShowHtml += "<span id=\"field<%=returnIdField%>_span\" name=\"field<%=returnIdField%>_span\" style='cursor:hand;color:blue;' onclick='javascript:toRequest("+$(this).attr("keyid")+");' keyid='"+$(this).attr("keyid")+"'>"+ $(this).html()+"</span>";
						} else {
							returnShowHtml += "<span id=\"field<%=returnIdField%>_span\" name=\"field<%=returnIdField%>_span\" keyid='"+$(this).attr("keyid")+"'>"+ $(this).html()+"</span>";
						}
					});
					returnShowHtml = returnShowHtml.replace(/&nbsp;/g, "");
				}
				$(returnShowFieObj).html(returnShowHtml);
				 try{
					var returnShowFieldObj = parent.document.getElementById(returnShowField+"_d");
					var isMand ="";
					if(returnShowFieldObj){
					    $(returnShowFieldObj).children("span").each(function(i){
					           if(this.getAttribute("id")&&this.getAttribute("id").indexOf("ismandspan")>=0){
					              returnShowField = returnShowField.replace("_span","");
					              isMand="<span id=\""+returnShowField+"_d_ismandspan\" style=\""+this.getAttribute("style")+"\">!</span>";
					           }
					    });
						$(returnShowFieldObj).html(returnShowHtml+isMand);
                         var groupidStr=returnShowFieldObj.getAttribute("groupid");
						 var rowIdStr=returnShowFieldObj.getAttribute("rowId");
						 var columnIdStr=returnShowFieldObj.getAttribute("columnId");
						 if(groupidStr&&rowIdStr&&columnIdStr){
						      var showObj= parent.document.getElementById("isshow"+groupidStr+"_"+rowIdStr+"_"+columnIdStr);
							  showObj.innerHTML = returnShowHtml;
							  $(showObj).children("span").each(function(i){
							          if(this.getAttribute("onclick")){
							             this.setAttribute("onclick",this.getAttribute("onclick")+";event.stopPropagation();");
							          }
							  });
							  
						 }
						 var returnFieldCount = 0;
						 $(returnShowFieldObj).children("span").each(function(i){
							    returnFieldCount++;
							    if(i>=2){
							       if(this.getAttribute("id")&&this.getAttribute("id").indexOf("ismandspan")>=0){
							            this.setAttribute("style","color: red;font-size: 16pt;float:right;display:none;");
							             returnFieldCount --;
							       }else{
							            this.setAttribute("style","margin-left:30px;");
							            this.removeAttribute("onclick","");
							       }
							    }else{
							       if(this.getAttribute("id")&&this.getAttribute("id").indexOf("ismandspan")>=0){
							          if(returnFieldCount>1){
							            this.setAttribute("style","color: red;font-size: 16pt;float:right;display:none;");
							          }
							          returnFieldCount --;
							       }else{
							          this.setAttribute("style","");
							          this.removeAttribute("onclick","");
							       }
							    }
							 
						 });
						 returnShowFieldObj.setAttribute("style","margin-top:"+(returnFieldCount<=1?"11":"0")+"px");
					}

			    }catch(e){}

                if(count > 0){
					//去除多余的逗号分隔符

					var tmpStr = "";
					var arrVals = value.split(",");
					for(var i = 0; i<arrVals.length; i++){
						if(arrVals[i] == ""){
							continue;
						}
						tmpStr += "," + arrVals[i];
					}
					value = tmpStr.substring(1);
					$(returnIdFieIdsObj).val(value);
					try{
					  var returnIdFieldObj = parent.document.getElementById(returnIdField+"_d");
					  if(returnIdFieldObj){
					     $(returnIdFieldObj).val(value);
					  }
					   var idSplitIdStr =returnIdField+"_d_ismandspan";
					   var ismandObj=parent.document.getElementById(idSplitIdStr);
						var vtype = parent.document.getElementById(returnIdField+"_d").getAttribute("vtype");
						if(vtype==undefined||vtype==null||vtype=="") vtype = -1 ;
                        var ismand = ismandObj.getAttribute("class");
                        var _isedit = 0;
                        if(parent.document.getElementById("oldfieldview"+returnIdField.replace("field",""))){
                            _isedit = parent.document.getElementById("oldfieldview"+returnIdField.replace("field","")).value ;
                        }
                        if(ismandObj){
                            if(window.console) console.log("returnIdField= "+returnIdField+" vtype = "+vtype+" ismand="+ismand+" _isedit="+_isedit);
                            if(vtype==null||vtype==-1||vtype==1||vtype==3){
                                if(ismand=='ismand'||(vtype==-1&&_isedit>2)){
                                        if(returnIdFieldObj.value && returnIdFieldObj.value!=""){
                                                ismandObj.style.display = "none";
                                        }else{
                                                ismandObj.style.display = "block";
                                        }
                                }else{
                                   ismandObj.style.display = "none";
                                }
                            }else if(vtype==2){
                                  if(returnIdFieldObj.value && returnIdFieldObj.value!=""){
                                          ismandObj.style.display = "none";
                                  }else{
                                          ismandObj.style.display = "block";
                                  }
                            }
                            
                        }
					}catch(e){}
				}else{
					$(returnIdFieIdsObj).val("");
					try{
                       var returnIdFieldObj = parent.document.getElementById(returnIdField+"_d");
					  if(returnIdFieldObj){
					     $(returnIdFieldObj).val("");
					  }
					  var idSplitIdStr =returnIdField+"_d_ismandspan";
                      var ismandObj=parent.document.getElementById(idSplitIdStr);
                        var vtype = parent.document.getElementById(returnIdField+"_d").getAttribute("vtype");
                        if(vtype==undefined||vtype==null||vtype=="") vtype = -1 ;
                        var ismand = ismandObj.getAttribute("class");
                        var _isedit = 0;
                        if(parent.document.getElementById("oldfieldview"+returnIdField.replace("field",""))){
                            _isedit = parent.document.getElementById("oldfieldview"+returnIdField.replace("field","")).value ;
                        }
                        
                        if(ismandObj){
                            if(vtype==null||vtype==-1||vtype==1||vtype==3){
                                if(ismand=='ismand'||(vtype==-1&&_isedit>2)){
                                        if(returnIdFieldObj.value && returnIdFieldObj.value!=""){
                                                ismandObj.style.display = "none";
                                        }else{
                                                ismandObj.style.display = "block";
                                        }
                                }else{
                                   ismandObj.style.display = "none";
                                }
                            }else if(vtype==2){
                                  if(returnIdFieldObj.value && returnIdFieldObj.value!=""){
                                          ismandObj.style.display = "none";
                                  }else{
                                          ismandObj.style.display = "block";
                                  }
                            }
                            
                        }
					}catch(e){
					   //if(window.console) console.log(e.message);
					}
				}
				
				//处理字段联动
				var $fieldObj = $(returnIdFieIdsObj);
				if($fieldObj.attr("onchange") != ""){
					$fieldObj.trigger("onchange");
				}
				browser_doclear_<%=returnIdField%>();
				
				closeDialog(returnIdField, true);
			}
			
			function closeDialog(returnIdField, flagSubmit){
				//流程转发功能特殊处理。
				if("forwardresourceids" == returnIdField){
					parent.closeForwardDialog(flagSubmit);
				//选择退回节点特殊处理。

				}else if("forwardresourceids2" == returnIdField){
					parent.closeForwardDialog2(flagSubmit);
				}else if("forwardresourceids3" == returnIdField){
					parent.closeForwardDialog3(flagSubmit);
				}else if("rejectToNodeid" == returnIdField){
					parent.closeRejectDialog(flagSubmit);
				}else if("exceptionoperators" == returnIdField){
					parent.dynamicHeight_exceptionPage("180px");
					parent.closeDialog(returnIdField);
				}else {
					parent.closeDialog(returnIdField);
				}
			}
			
			
			function browser_docancel_<%=returnIdField%>(){
				var returnShowField = "<%=returnShowField %>";
				var returnIdField  = "<%=returnIdField%>";
				
				var returnShowFieObj = parent.document.getElementById(returnShowField);
				var returnIdFieIdsObj = parent.document.getElementById(returnIdField);
				
				if(returnIdFieIdsObj.getAttribute("fieldtype") == 'browse'){
				  $("td[id='"+returnShowField+"']",window.parent.document).html(""); 
				}else{
					$(returnShowFieObj).html("");
				}
				var $fieldObj = $(returnIdFieIdsObj);
				$fieldObj.val("");
				try{
					  
                      var returnIdFieldObj = parent.document.getElementById(returnIdField+"_d");
					  if(returnIdFieldObj){
					     $(returnIdFieldObj).val("");
					  }
                     var returnShowFieldObj = parent.document.getElementById(returnShowField+"_d");
                     var isMand = "";
					if(returnShowFieldObj){
					     $(returnShowFieldObj).children("span").each(function(i){
					          if(this.getAttribute("id") && this.getAttribute("id").indexOf("ismandspan")>=0){
					               returnShowField = returnShowField.replace("_span","");
					               isMand ="<span id=\""+returnShowField+"_d_ismandspan\" style=\"color: red;font-size: 16pt;float:right;display:block;\">!</span>";
					          }
					     });
						$(returnShowFieldObj).html(""+isMand);
                         var groupidStr=returnShowFieldObj.getAttribute("groupid");
						 var rowIdStr=returnShowFieldObj.getAttribute("rowId");
						 var columnIdStr=returnShowFieldObj.getAttribute("columnId");
						 if(groupidStr&&rowIdStr&&columnIdStr){
							  parent.document.getElementById("isshow"+groupidStr+"_"+rowIdStr+"_"+columnIdStr).innerHTML = "";
						 }
					}

					//判断必填的验证
                        /*
					   var idSplitIdStr =returnIdField+"_d_ismandspan";
					   var ismandObj=parent.document.getElementById(idSplitIdStr);
					   if(ismandObj){
						    if(returnIdFieldObj.value && returnIdFieldObj.value!=""){
								   ismandObj.style.display = "none";
							}else{
								  ismandObj.style.display = "block";
							}
						}*/
						var idSplitIdStr =returnIdField+"_d_ismandspan";
                        var ismandObj=parent.document.getElementById(idSplitIdStr);
                        var vtype = parent.document.getElementById(returnIdField+"_d").getAttribute("vtype");
                        if(vtype==undefined||vtype==null||vtype=="") vtype = -1 ;
                        var ismand = parent.jQuery("#"+idSplitIdStr).attr("class"); //ismandObj.getAttribute("class");
                        var _isedit = 0;
                        if(parent.document.getElementById("oldfieldview"+returnIdField.replace("field",""))){
                            _isedit = parent.document.getElementById("oldfieldview"+returnIdField.replace("field","")).value ;
                        }
                        if(ismandObj){
                            if(vtype==null||vtype==-1||vtype==1||vtype==3){
                                
                                if(ismand=='ismand'||(vtype==-1&&_isedit>2)){
                                
                                        if(returnIdFieldObj.value && returnIdFieldObj.value!=""){
                                                ismandObj.style.display = "none";
                                        }else{
                                                ismandObj.style.display = "block";
                                        }
    
                                }else{
                                    ismandObj.style.display = "none";
                                }
                            }else if(vtype==2){
                                  if(returnIdFieldObj.value && returnIdFieldObj.value!=""){
                                          ismandObj.style.display = "none";
                                  }else{
                                          ismandObj.style.display = "block";
                                  }
                            }
                            
                        }
				}catch(e){
				    if(window.console) console.log("browser_docancel_"+returnIdField+" e:= "+e.message);
				}
				//处理字段联动
				if($fieldObj.attr("onchange") != ""){
					$fieldObj.trigger("onchange");
				}
				
				browser_doclear_<%=returnIdField%>();
				
				closeDialog(returnIdField, false);
			}
			function browser_doclear_<%=returnIdField%>(){
				$('#resultinfo_<%=returnIdField%>').hide();
				$('#pageinfo_<%=returnIdField%>').hide();
				for(var i=0;i<10;i++){
					$('#checkdiv_'+i+'_<%=returnIdField%>').hide();
					$('#checkbox_'+i+'_<%=returnIdField%>').val("").attr('checked',false);
					$('#checklabel1_'+i+'_<%=returnIdField%>').empty();
					$('#checklabel2_'+i+'_<%=returnIdField%>').empty();
				}
				$('#pageno_<%=returnIdField%>').val("");
				$('#pagetotal_<%=returnIdField%>').val("");
				$('#nextpage_<%=returnIdField%>').val("");
				$('#prepage_<%=returnIdField%>').val("");
				$('#selectedids_<%=returnIdField%>').val("");
				$('#selectedspans_<%=returnIdField%>').empty();
				
			}
			
			$('div').live('pageshow',function(event, ui){
				browser_loadexisteddata_<%=returnIdField%>();
			});
			function browser_loadexisteddata_<%=returnIdField%>(){

				var returnShowField = "<%=returnShowField %>";
				var returnIdField  = "<%=returnIdField%>";
				
				var returnShowFieObj = parent.document.getElementById(returnShowField);
				var returnIdFieIdsObj = parent.document.getElementById(returnIdField);
				
				var ids = $(returnIdFieIdsObj).val().split(",");
				for(var i=0;ids&&ids.length>0&&i<ids.length;i++){
					var item = ids[i];
					if(item&&$('#selectedids_<%=returnIdField%>').val().indexOf(","+item+",")==-1) {
						$('#selectedids_<%=returnIdField%>').val($('#selectedids_<%=returnIdField%>').val()+","+item+",");
					}
				}

				$(returnShowFieObj).children().each(function(){
					var keyid = $(this).attr('keyid');
					if(keyid&&keyid!="") {
						if($('#selectedspans_<%=returnIdField%>').children("span[keyid='" + keyid + "']").length == 0) {
							$('#selectedspans_<%=returnIdField%>').append("<span keyid='"+keyid+"'>"+$(this).html()+"</span>");
						}
					}
				});
			}
			//-->
		</SCRIPT>
		<table>
			<tr>
				<td width="*">
				<input type="text" name="keyword_<%=returnIdField%>" id="keyword_<%=returnIdField%>" value="" class="searchText" style="width:100% !important;"/>
				</td>
				<td width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width="50px" align="right">
					<div class="operationBt width50" onclick="javascript:browser_clicksearch_<%=returnIdField%>();"><%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %></a></div>
				</td>
			</tr>
		</table>
		<!-- 
	 	<fieldset data-role="controlgroup" id="resultinfo_<%=returnIdField%>" style="display:none;padding:0;" style="">
 		-->
 		
 		<table id="resultinfo_<%=returnIdField%>" style="display:none;margin-top:5px;padding:0;table-layout:fixed;border:1px solid #D8DDE4;" width="100%" rules="rows">
				<%
			for (int i=0; i<10; i++) {
				if (isMuti) {
				%>
			<!-- 
				<div id="checkdiv_<%=i %>_<%=returnIdField%>" style="display:none;padding-bottom:6px;padding-top:6px;background-color:#EFF2F6;border-bottom:1px solid #D8DDE4;">
			 -->
			 	<tr id="checkdiv_<%=i %>_<%=returnIdField%>" style="display:none;">
					<td width="20px">
						<input style="margin-top:auto;margin-bottom:auto;" type="checkbox" name="checkbox_<%=returnIdField%>" id="checkbox_<%=i %>_<%=returnIdField%>" value="" onchange="browser_dochange_<%=returnIdField%>(<%=i %>);"/>
					</td>
					<td width="10px">
					</td>
					<td width="*" style="padding-top:10px;padding-bottom:10px;" onclick="javascript:document.getElementById('checkbox_<%=i %>_<%=returnIdField%>').checked==true ? document.getElementById('checkbox_<%=i %>_<%=returnIdField%>').checked == false : document.getElementById('checkbox_<%=i %>_<%=returnIdField%>').checked == true ;">
						<label for="checkbox_<%=i %>_<%=returnIdField%>">
							<div id="checklabel1_<%=i %>_<%=returnIdField%>" style="font-size:14px;"></div>
							<div id="checklabel2_<%=i %>_<%=returnIdField%>" style="font-size:12px;color:#666666;"></div>
						</label>
					</td>
				</tr>
				<!--
				</div>
				-->
				
				<%} else { %>
				<div id="checkdiv_<%=i %>_<%=returnIdField%>" style="display:none;padding-bottom:6px;padding-top:6px;background-color:#EFF2F6;border-bottom:1px solid #D8DDE4;">
					<div style="float:left;">
						<input type="radio" name="checkbox_<%=returnIdField%>" id="checkbox_<%=i %>_<%=returnIdField%>" value="" onchange="browser_dochange_<%=returnIdField%>(<%=i %>);"/>
					</div>
					<div style="float:left;width:*;" onclick="javascript:document.getElementById('checkbox_<%=i %>_<%=returnIdField%>').click();">
						<label for="checkbox_<%=i %>_<%=returnIdField%>" >
						<div id="checklabel1_<%=i %>_<%=returnIdField%>" style="white-space:normal;width:100%;"></div>
						<div id="checklabel2_<%=i %>_<%=returnIdField%>" style="white-space:normal;width:100%;"></div>
						</label>
					</div>
					<div style="clear:both;"></div>
				</div>
				
				<%} %>				
			<%} %>
		</table>
		
		<!-- 
		</fieldset>
		 -->
		
		<table id="pageinfo_<%=returnIdField%>" style="width:100%;display:none;font-size:16px;" style="">
			<tr>
				<td>
					<%=SystemEnv.getHtmlLabelName(15323, user.getLanguage()) %><span id="pagenospan_<%=returnIdField%>">1</span>页&nbsp;<%=SystemEnv.getHtmlLabelName(18609, user.getLanguage()) %><span id="pagetotalspan_<%=returnIdField%>">1</span>页

				</td>
				<td align="right" valign="middle">
					<span id="browser_first_<%=returnIdField%>"><strong><<</strong><%=SystemEnv.getHtmlLabelName(18363, user.getLanguage()) %></span>
					<span id="browser_previous_<%=returnIdField%>"><%=SystemEnv.getHtmlLabelName(1258, user.getLanguage()) %></span>
					<span id="browser_next_<%=returnIdField%>"><%=SystemEnv.getHtmlLabelName(1259, user.getLanguage()) %></span>
					<span id="browser_last_<%=returnIdField%>"><%=SystemEnv.getHtmlLabelName(18362, user.getLanguage()) %><strong>>></strong></span>
				</td>
			</tr>
		</table>
		
		<input type="hidden" name="pageno_<%=returnIdField%>" id="pageno_<%=returnIdField%>" value=""/>
		<input type="hidden" name="pagetotal_<%=returnIdField%>" id="pagetotal_<%=returnIdField%>" value=""/>
		<input type="hidden" name="nextpage_<%=returnIdField%>" id="nextpage_<%=returnIdField%>" value=""/>
		<input type="hidden" name="prepage_<%=returnIdField%>" id="prepage_<%=returnIdField%>" value=""/>
		<input type="hidden" name="selectedids_<%=returnIdField%>" id="selectedids_<%=returnIdField%>" value=""/>
		<input type="hidden" name="rejecttotype_<%=returnIdField%>" id="rejecttotype_<%=returnIdField%>" value="0"/>
		<span style="font-size:12px;">已选择:<span id="selectedspans_<%=returnIdField%>" style="color:blue;"></span></span>

		<center>
<% //如果是选择退回节点，则不显示清除按钮。

   if("rejectToNodeid".equals(returnIdField)){ %>		
			<div data-role="controlgroup" style="width:150px;margin-bottom:10px;margin-top:5px;">
				<div class="operationBt width50" onclick="browser_dook_<%=returnIdField%>();"><%=SystemEnv.getHtmlLabelName(826, user.getLanguage()) %></div>
				<div class="operationBt width50" onclick="javascript:closeDialog('<%=returnIdField%>', false);"><%=SystemEnv.getHtmlLabelName(201, user.getLanguage()) %></div>
				<div style="clear:both;"></div>
			</div>
<% }else{ %>
			<div data-role="controlgroup" style="width:210px;margin-bottom:10px;margin-top:5px;">
				<div class="operationBt width50" onclick="browser_dook_<%=returnIdField%>();"><%=SystemEnv.getHtmlLabelName(826, user.getLanguage()) %></div>
				<div class="operationBt width50" onclick="browser_docancel_<%=returnIdField%>();"><%=SystemEnv.getHtmlLabelName(311, user.getLanguage()) %></div>
				<div class="operationBt width50" onclick="javascript:closeDialog('<%=returnIdField%>', false);"><%=SystemEnv.getHtmlLabelName(201, user.getLanguage()) %></div>
				<div style="clear:both;"></div>
			</div>
<% }       %>
		</center>
</div>
</body></html>
<% //如果是选择退回节点，页面初次加载时候就显示搜索结果。

   if("rejectToNodeid".equals(returnIdField)){ %>
<script>
	jQuery(function(){
		browser_dosearch_rejectToNodeid();
	});
</script>
<% } %>