<%@page import="com.weaver.formmodel.util.StringHelper"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.Writer" %>
<%@ page import="weaver.formmode.service.*"%>
<jsp:useBean id="exports" class="weaver.formmode.exports.services.FormmodeDataService" scope="page"/>
<%@ include file="/formmode/pub.jsp"%>
<style>
	html,body{
		height: 100%;
		margin: 0px;
		padding: 0px;
	}
	*{
		font: 12px Microsoft YaHei;
	}
	ul{
		list-style: none;
		margin: 0px;
		padding: 0px;
	}
	.e8_tblForm{
		width: 511px;
		margin: 0 0;
		border-collapse: collapse;
	}
	.e8_tblForm .e8_tblForm_label{
		vertical-align: top;
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 0;
	}
	.e8_tblForm .e8_tblForm_field{
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 7px;
		background-color: #f8f8f8;
		vertical-align: top;
	}
	.e8_label_desc{
		color: #aaa;
	}
	#appTable{
		width: 100%;
		height: 100%;
	}
	#appTable td{
		vertical-align: top;
	}
	#appPart2TD{
		background: url("/formmode/images/border_e9e9e9_wev8.png") no-repeat;
		background-position: right 15px;
	}
	.appPart{
		height: 100%;
		padding-top: 15px;
	}
	#appPart1{
		width: 530px;
	}
	#appPart2{
		width: 280px;
	}
	#appPart3{
		padding-left: 15px;
	}
	.appPart .elementPart{
		padding-left: 0;
	}
	.appPart .elementPart .title{
		font-weight: bold;
		padding-bottom: 2px;
	}
	.appPart .elementPart .content{
		padding-top: 0px;
		padding-bottom: 15px;
	}
	.content .divProgress{
		width: 280px;
		background-color: #e9e9e9;
	}
	.appPart .elementPart .content .component{
		height: 80px;
	}
	.appPart .elementPart .content .component li{
		float: left;
		height: 80px;
		width: 80px;
		margin-right: 6px;
		background-position: center;
		background-repeat: no-repeat;
		position: relative;
		cursor: pointer;
	}
	.appPart .elementPart .content .component li.color1{
		background-color: #99B332;
	}
	.appPart .elementPart .content .component li.color2{
		background-color: #0172C5;
	}
	.appPart .elementPart .content .component li .bottomInfo{
		position: absolute;
		left: 0px;
		bottom: 0px;
		width: 100%;
		padding: 0px; 
		height: 26px;
		background: url('/formmode/images/appbar/appbar_bottom_bg_wev8.png');
		overflow: hidden;
	}
	.appPart .elementPart .content .component li .bottomInfo span{
		
	}
	.appPart .elementPart .content .component li .bottomInfo .label{
		padding-top: 6px;
		padding-left: 8px;
		color: #f1f1f1;
		font-size: 11px;
	}
	.appPart .elementPart .content .component li .bottomInfo .count{
		margin-left: 4px;
		color: #f1f1f1;
		font-size: 11px;
	}
	
	.appPart .elementPart .content .complete{
		background-color: #E9E9E9;
		height: 80px;
		width: 280px;
		color: #FAFAFA;
		padding: 3px 0px 0px 8px;
		position: relative;
	}
	#progressTitle2{
		height:30px;position:absolute;top:42px;left:25px;z-index:999;font-size:12px;color:#f8f8f8;
	}
	#progressVal2{
		position: absolute;
		top:75px;
		left:25px;
		height:30px;
		color:#fff;
		font-size:28px;
		font-weight: bold;
		z-index:999;
	}
	#progressGif2{
		width:280px;height:80px;opacity:0.08;filter:alpha(opacity=8);
	}
	.appPart .elementPart .content .filecontent{
		padding-top: 6px;
		width: 280px;
	}
	.appPart .elementPart .content .desc{
		padding-top: 8px;
	}
	.appPart .elementPart .content .desc ul{
		list-style: none;
		margin: 0px;
		padding: 0px;
	}
	.appPart .elementPart .content .desc ul li{
		padding-left: 2px;
		line-height: 18px;
		color: #666;
		font-size: 11px;
	}
	#appStatistics{
		margin-top: 8px;
		vertical-align:bottom;
	}
	#appStatistics li{
		height: 19px;
		overflow: hidden;
	}
	#appStatistics span{
		display: block;
		height: 15px;
		float: left;
		line-height: 15px;
	}
	#appStatistics .label{
		color: #909090;
		font-size: 11px;
		width: 48px;
		font-style: italic;
	}
	#appStatistics .bar{
		background-color: #E5E5E5;
	}
	#appStatistics .maxValBar{
		background-color: #FF6600;
	}
	#appStatistics .nodata{
		color: #909090;
		font-size: 11px;
		font-style: italic;
	}
	.divBtn{
		width: 100px;
		padding: 5px 0;
		margin: 8px 0;
		/*background-color: #2d89ef;*/
		background-color: #2d89ef;
		color: #fff;
		font-family: Microsoft YaHei;
		font-size: 12px;
		line-height: 18px;
	}
	.divBtnDisabled{
		background-color: #E9E9E9 !important;
	}
	</style>
<script type="text/javascript">
function importwf()
{
	var parastr="filename";
	var filename = document.frmMain.filename.value;
	var pos = filename.length-4;
	if(filename==null||filename==''){
		alert("<%=SystemEnv.getHtmlLabelName(81991,user.getLanguage())%>");//选择文件！
	}else{
		if(filename.lastIndexOf(".zip")==pos)
		{
			jQuery("#upload_faceico").load(showUploadMessage);
			document.frmMain.submit();
			jQuery("#uploadBtn").attr("disabled","disabled").addClass("divBtnDisabled");
			jQuery("#progressGif2").css("background-image", "url(/formmode/images/animated-overlay_wev8.gif)");
			jQuery("#progressVal2").css("color", "#FD6500");
			doStatus();
		}
		else
		{
			alert("<%=SystemEnv.getHtmlLabelName(81992,user.getLanguage())%>");//选择文件格式不正确,请选择xml文件25644
			return;
		}
	}
}

function doStatus(){
	var url = "/formmode/import/ProcessOperation.jsp?action=doStatus";
	FormmodeUtil.doAjaxDataLoad(url, function(res){
		if(jQuery.isEmptyObject(res)){
			setTimeout("doStatus()",200);//定时调用
		}else{
			var isfinish=res.isfinish;
			var total=res.total;
			var successNum=res.successNum;
			var percentComplete=parseInt(successNum*100/total);
			$("#progressVal2").html(percentComplete+"%");
			if(isfinish!=1){
				setTimeout("doStatus()",200);//定时调用
			}else{
				jQuery("#uploadBtn").removeAttr("disabled").removeClass("divBtnDisabled");
				jQuery("#progressGif2").css("background-image", "");
				jQuery("#progressVal2").css("color", "#fff");
			}
		}
	});
}

var uploadMessageDlg;
function showUploadMessage(){
	var uploadFrame = document.getElementById("upload_faceico");
	var uploadFrameDoc = uploadFrame.contentWindow.document;
	var msg=uploadFrameDoc.body.innerHTML;
	uploadMessageDlg = top.createTopDialog();//定义Dialog对象
	uploadMessageDlg.Model = true;
	uploadMessageDlg.Width = 960;//定义长度
	uploadMessageDlg.Height = 650;
	uploadMessageDlg.URL = "/formmode/setup/upload_faceico.jsp";
	uploadMessageDlg.Title = "<%=SystemEnv.getHtmlLabelName(82207,user.getLanguage())%>";//应用导入信息
	uploadMessageDlg.appImportMsg = msg;
	uploadMessageDlg.show();
}
</script>
<%
if (!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String pAppid = StringHelper.null2String(request.getParameter("appid"));

AppInfoService appInfoService = new AppInfoService();
Map<String, Object> appInfo = appInfoService.getAppInfoById(Util.getIntValue(pAppid));
String userRightStr = "FORMMODEAPP:ALL";
int subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subCompanyId")),-1);
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable ,subCompanyId,"",request,response,session);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
%>
<table id="appTable">
<colgroup>
<col width="130px"/>
<col width="80px"/>
<col width="*"/>
</colgroup>
<tr>
<td>
<div id="appPart3" class="appPart">
	<div class="elementPart">
		<div class="title"><%=SystemEnv.getHtmlLabelName(82208,user.getLanguage())%><!-- 应用导入 --></div>
		<div class="content">
			<div class="divProgress">
				<div id="progressTitle2">%COMPLETE</div>
				<div id="progressVal2">0%</div>
				<div id="progressGif2"></div>
			</div>
			<div class="filecontent">
				<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/formmode/import/ModeImportOperation.jsp" enctype="multipart/form-data" target="upload_faceico">
					<input <%if(operatelevel<1){%>disabled<%} %> class=InputStyle  type=file  name="filename" id="filename" style="width:280px;background-color:#fff;border:1px solid #eee;outline:none;">
					<input type="hidden" id="appid" name="appid" value="<%=pAppid%>"/>
					<input type="hidden" id="isAppImport" name="isAppImport" value="1"/>
				</FORM>
				<iframe id="upload_faceico" name="upload_faceico" style="display: none;"></iframe>
			</div>
			<div class="desc">
				<ul>
					<!-- <li>功能说明：</li> -->
					<li><%=SystemEnv.getHtmlLabelName(82012,user.getLanguage())%><!-- 有关人力资源等相关设置，请在导入后检查设置。 --></li>
				</ul>
				<%if(operatelevel>0){%>
					<button id="uploadBtn" type="button" class="divBtn" onclick="importwf();"><%=SystemEnv.getHtmlLabelName(32937,user.getLanguage())%><!-- 开始上传 --><img src="/formmode/images/downloadCloud_wev8.png" style="vertical-align: bottom;margin:0 0px 2px 4px;"/></button>
				<%}else{%>
					<%=SystemEnv.getHtmlLabelName(82209,user.getLanguage())%><!-- 不具有该应用的导入权限！ -->
				<%} %>
			</div>
		</div>
	</div>
</div>
</td>
</tr>
</table>