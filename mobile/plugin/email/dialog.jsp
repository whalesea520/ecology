
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
	String allid=Util.null2String(request.getParameter("allid"));
	 String emailtype="1";
	//listUser or  listDepartment
	String method = Util.null2String(request.getParameter("method"));
	if("listDepartment".equals(method)){
			emailtype="2";
	}
	%>
	$(document).ready(function () {


		var returnShowField = "<%=returnShowField %>";
		var returnIdField  = "<%=returnIdField %>";
		
		var returnShowFieObj = parent.document.getElementById(returnShowField);
		var returnIdFieIdsObj = parent.document.getElementById(returnIdField);
		
		$(returnShowFieObj).children("span[emailtype=<%=emailtype%>]").each(function(i){
			$('#selectedspans_<%=returnIdField%>').append("<span keyid='"+$(this).attr("keyid")+"' emailtype='<%=emailtype%>'>&nbsp;"+$(this).html()+"</span>");
		});

		var selids = $(returnIdFieIdsObj).val();
		var tmpStr = selids;
		while(tmpStr.startWith(",")){
			tmpStr = tmpStr.substring(1);
		}
		//id值应用于自定义浏览框中的 span标签的keyid值。
		var arrVals = tmpStr.split(",");
		
		selids = selids.startWith(",") ? selids : ","+selids;
		selids = selids.endWith(",") ? selids : selids+",";
		$('#selectedids_<%=returnIdField%>').val(selids);
		
		$(returnShowFieObj).children("a").each(function(i){
			var taghf = $(this).attr("href");
			if(taghf != undefined && taghf != null){
				var tagkeyId = taghf.substring(taghf.indexOf("(") + 1, taghf.lastIndexOf(")"));
				$('#selectedspans_<%=returnIdField%>').append("<span keyid='" + tagkeyId +"'  emailtype='<%=emailtype%>'>&nbsp;" + $(this).html() + "</span>");
			}else{
				taghf = $(this).attr("title");
				if(taghf != undefined && taghf != null){
					$('#selectedspans_<%=returnIdField%>').append("<span keyid='" + arrVals[i] +"' emailtype='<%=emailtype%>'>&nbsp;" + $(this).html() + "</span>");
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
				$.get('/mobile/plugin/browser.jsp?method=<%=method %>&isDis=1',{keyword:keyword,pageno:pageno,requestid:requestid,nodeid:nodeid,browserTypeId:browserTypeId,customBrowType:customBrowType},
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
								if($('#selectedids_<%=returnIdField%>').val().indexOf(","+datas[i].id+",")>-1)
									$('#checkbox_'+i+'_<%=returnIdField%>').val(datas[i].id).attr('checked',true);//.checkboxradio("refresh");
								else
									$('#checkbox_'+i+'_<%=returnIdField%>').val(datas[i].id).attr('checked',false);//.checkboxradio("refresh");
								$('#checklabel1_'+i+'_<%=returnIdField%>').html(datas[i].show1);
								$('#checklabel2_'+i+'_<%=returnIdField%>').html(datas[i].show2);
								$('#checkdiv_'+i+'_<%=returnIdField%>').show();
							} else {
								$('#checkbox_'+i+'_<%=returnIdField%>').val("").attr('checked',false);//.checkboxradio("refresh");
								$('#checklabel1_'+i+'_<%=returnIdField%>').empty();
								$('#checklabel2_'+i+'_<%=returnIdField%>').empty();
								$('#checkdiv_'+i+'_<%=returnIdField%>').hide();
							}
						}
						$('#resultinfo_<%=returnIdField%>').show();

						$('#pageinfo_<%=returnIdField%>').show();
						
						dymHeight(($(document.body).children(".page").height() + 20) + "px");
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
							$('#selectedspans_<%=returnIdField%>').append("<span keyid='"+id+"' emailtype='<%=emailtype%>'>&nbsp;"+name+"</span>");
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
					$('#selectedids_<%=returnIdField%>').val(id);
					$('#selectedspans_<%=returnIdField%>').html("<span keyid='"+id+"' emailtype='<%=emailtype%>'>"+name+"</span>");
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

				var returnShowField = "<%=returnShowField %>";
				var returnIdField  = "<%=returnIdField%>";
				var method = "<%=method %>";
				
				var returnShowFieObj = parent.document.getElementById(returnShowField);
				var returnIdFieIdsObj = parent.document.getElementById(returnIdField);
			
				//解决多人力资源之类的浏览按钮，每天添加人员等之后所显示位置不对齐的问题。
				var returnShowHtml = "";
				var blShowHtml="";
				//<span emailtype="1" keyid="3">熊学武&nbsp;</span>
				$(returnShowFieObj).find("span[emailtype!=<%=emailtype%>]").each(function(){
					blShowHtml+="<span emailtype='"+$(this).attr("emailtype")+"'  keyid="+$(this).attr("keyid")+">"+$(this).html()+"</span>";
					
				});
				$(returnShowFieObj).empty();
				var value = $('#selectedids_<%=returnIdField%>').val();
				
				var count = checkBrowse(value);
			
				

				//人力资源的浏览按钮的特殊处理
				if(method == "listUser"){
						//如果所选人力资源数量小于6则每行显示一个；否则每行显示多个。
						returnShowHtml += "<div style=\"height:10px;overflow:hidden;width:1px;\"></div>";
						var tempStr = "";
						$('#selectedspans_<%=returnIdField%>').children("span").each(function(i){
							tempStr += "<span keyid='"+$(this).attr("keyid")+"' emailtype='<%=emailtype%>'>"+ $(this).html().replace(/&nbsp;/g, "") +"&nbsp;</span>";
						});
						returnShowHtml += tempStr;
					
				//自定义多选框的处理(与页面初始化一致,永远不换行)
				}else {
					$('#selectedspans_<%=returnIdField%>').children("span").each(function(i){
					 	/* if(i!=0){
							returnShowHtml += "<div style=\"height:10px;overflow:hidden;width:1px;\"></div>";
						} */
						if(method=="listDocument") {
							returnShowHtml += "<span style='cursor:hand;color:blue;' onclick='javascript:toDocument("+$(this).attr("keyid")+");' keyid='"+$(this).attr("keyid")+"' emailtype='<%=emailtype%>'>"+ $(this).html().replace(/&nbsp;/g, "") +"&nbsp;</span>";
						} else if(method=="listWorkflowRequest") {
							returnShowHtml += "<span style='cursor:hand;color:blue;' onclick='javascript:toRequest("+$(this).attr("keyid")+");' keyid='"+$(this).attr("keyid")+"' emailtype='<%=emailtype%>'>"+  $(this).html().replace(/&nbsp;/g, "") +"&nbsp;</span>";
						} else {
							returnShowHtml += "<span keyid='"+$(this).attr("keyid")+"' emailtype='<%=emailtype%>'>"+  $(this).html().replace(/&nbsp;/g, "") +"&nbsp;</span>";
						}
					});
					//returnShowHtml = returnShowHtml.replace(/&nbsp;/g, "");
				}
				 $(returnShowFieObj).html(blShowHtml+returnShowHtml);
				 
				if(count > 0){
					$(returnIdFieIdsObj).val(value);
				}else{
					$(returnIdFieIdsObj).val("");
				} 
					//allid--清空所有人的选择框里面的值
				parent.document.getElementById("<%=allid%>").value="";
				browser_doclear_<%=returnIdField%>();
				parent.closeDialog();
			}
			function browser_docancel_<%=returnIdField%>(){
				var returnShowField = "<%=returnShowField %>";
				var returnIdField  = "<%=returnIdField%>";
				
				var returnShowFieObj = parent.document.getElementById(returnShowField);
				var returnIdFieIdsObj = parent.document.getElementById(returnIdField);
				var blShowHtml="";
				//<span emailtype="1" keyid="3">熊学武&nbsp;</span>
				$(returnShowFieObj).find("span[emailtype!=<%=emailtype%>]").each(function(){
					blShowHtml+="<span emailtype='"+$(this).attr("emailtype")+"'  keyid="+$(this).attr("keyid")+">"+$(this).html()+"</span>";
				});
				$(returnShowFieObj).html("").html(blShowHtml);
				$(returnIdFieIdsObj).val("");
				//allid--清空所有人的选择框里面的值
				parent.document.getElementById("<%=allid%>").value="";
				browser_doclear_<%=returnIdField%>();
				parent.closeDialog();
			}
			function browser_doclear_<%=returnIdField%>(){
				$('#resultinfo_<%=returnIdField%>').hide();
				$('#pageinfo_<%=returnIdField%>').hide();
				for(var i=0;i<10;i++){
					$('#checkdiv_'+i+'_<%=returnIdField%>').hide();
					$('#checkbox_'+i+'_<%=returnIdField%>').val("").attr('checked',false);//.checkboxradio("refresh");
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
							$('#selectedspans_<%=returnIdField%>').append("<span keyid='"+keyid+"' emailtype='<%=emailtype%>'>"+$(this).html()+"</span>");
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
		<span style="font-size:12px;">已选择:<span id="selectedspans_<%=returnIdField%>" style="color:blue;"></span></span>

		<center>
			<div data-role="controlgroup" style="width:210px;margin-bottom:10px;margin-top:5px;">
				<div class="operationBt width50" onclick="browser_dook_<%=returnIdField%>();"><%=SystemEnv.getHtmlLabelName(826, user.getLanguage()) %></div>
				<div class="operationBt width50" onclick="browser_docancel_<%=returnIdField%>();"><%=SystemEnv.getHtmlLabelName(311, user.getLanguage()) %></div>
				<div class="operationBt width50" onclick="javascript:parent.closeDialog();"><%=SystemEnv.getHtmlLabelName(201, user.getLanguage()) %></div>
				<div style="clear:both;"></div>
			</div>
		</center>
</div>

</body>
</html>