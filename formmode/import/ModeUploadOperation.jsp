<%@page import="com.weaver.formmodel.util.StringHelper"%>
<% weaver.filter.ECompatibleSetting.setVersion(weaver.filter.ECompatibleSetting.ECOLOGY_JSP_VERSION_E8,request); %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.imports.SessionContextHolder"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.*,javax.servlet.jsp.JspWriter" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormmodeDataService" class="weaver.formmode.imports.services.FormmodeDataService" scope="page" />
<%
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();

if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
FileUpload fu = new FileUpload(request,false,false);
FileManage fm = new FileManage();

String xmlfilepath="";
int fileid = 0 ;
String remoteAddr = fu.getRemoteAddr();
fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
String filename = FnaCommon.getPrimaryKeyGuid1()+".zip";
List<String> allowTypes = new ArrayList<String>();
allowTypes.add("zip");
String exceptionMsg ="";
if(FileType.validateFileExt(fu.getFileName(), allowTypes)){
String sql = "select filerealpath,isaesencrypt,aescode from imagefile where imagefileid = "+fileid;
RecordSet.executeSql(sql);
String uploadfilepath="";
String isaesencrypt = "";
String aescode = "";
if(RecordSet.next()){
	uploadfilepath =  RecordSet.getString("filerealpath");
	isaesencrypt = Util.null2String(RecordSet.getString("isaesencrypt"));
	aescode = Util.null2String(RecordSet.getString("aescode"));
}
String exceptionMsg ="";
if(!uploadfilepath.equals(""))
{
	try
	{
		xmlfilepath = GCONST.getRootPath()+"formmode"+File.separatorChar+"import"+File.separatorChar+filename ;
		File oldfile = new File(xmlfilepath);
		if(oldfile.exists())
		{
			oldfile.delete();
		}
		fm.copy(uploadfilepath,xmlfilepath);
	}
	catch(Exception e)
	{
		exceptionMsg = SystemEnv.getHtmlLabelName(82340,user.getLanguage());//读取文件失败!
	}
}else{
        exceptionMsg = SystemEnv.getHtmlLabelName(82340,user.getLanguage());//读取文件失败!
}
FormmodeDataService.setRemoteAddr(remoteAddr);
FormmodeDataService.setUser(user);
SessionContextHolder.setSession(session);
int appid=NumberHelper.getIntegerValue(fu.getParameter("appid"),0);
boolean isAppImport=!StringHelper.isEmpty(fu.getParameter("isAppImport"));
Map<String,String> sameformtableMap = FormmodeDataService.importFormmodeByZip(xmlfilepath,appid,isAppImport);
String importFilePath = FormmodeDataService.getImportFilePath();
%>
<HTML>
<HEAD>
	<script type="text/javascript" src="/formmode/js/jquery/jquery-1.8.3.min_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<LINK type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />	<!-- for right menu -->
	<link type="text/css" rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css"/>
	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
	<LINK type="text/css" rel="stylesheet" href="/formmode/css/pub_wev8.css?d=20140616" />
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
		background: url("/formmode/images/border_e9e9e9.png") no-repeat;
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
function importwf(){
	jQuery("#upload_faceico").load(showUploadMessage);
	document.frmMain.submit();
	jQuery("#uploadBtn").attr("disabled","disabled").addClass("divBtnDisabled");
	jQuery("#progressGif2").css("background-image", "url(/formmode/images/animated-overlay_wev8.gif)");
	jQuery("#progressVal2").css("color", "#FD6500");
	doStatus();
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
</head>
<body>
<form action="/formmode/import/ModeImportOperation2.jsp" name="frmMain" method="post" target="upload_faceico">
	<input name="xmlfilepath" type="hidden" value="<%=importFilePath%>">
	<input name="appid" type="hidden" value="<%=appid%>">
	<input name="isAppImport" type="hidden" value="<%=isAppImport?"1":""%>">
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
		<div class="title"><%=isAppImport?SystemEnv.getHtmlLabelName(82208,user.getLanguage()):SystemEnv.getHtmlLabelName(31919,user.getLanguage())%></div><!-- 应用导入:模块导入 -->
		<div class="content">
			<div class="divProgress">
				<div id="progressTitle2">%COMPLETE</div>
				<div id="progressVal2">0%</div>
				<div id="progressGif2"></div>
			</div>
			<div class="filecontent">
				<%
				if(sameformtableMap!=null&&sameformtableMap.size()>0){
				%>
				<%=SystemEnv.getHtmlLabelName(82343,user.getLanguage())%><br/><!-- 导入的表与系统中的表有冲突，请选择解决方案： -->
				<input type="radio" checked="checked" name="tabletype" value="1"><%=SystemEnv.getHtmlLabelName(82344,user.getLanguage())%><!-- 新建表 --><br/> 
				<input type="radio" name="tabletype" value="2"><%=SystemEnv.getHtmlLabelName(82345,user.getLanguage())%><!-- 使用系统中原有的表 -->
				<table class=ListStyle>
					<COLGROUP><COL width='50%'><COL width='50%'></COLGROUP>
					<tr class=header><td><%=SystemEnv.getHtmlLabelName(32673,user.getLanguage())%><!-- 表单ID --></td><td><%=SystemEnv.getHtmlLabelName(30671,user.getLanguage())%><!-- 表名称 --></td></tr>
					<%
					Iterator iterator = sameformtableMap.keySet().iterator();
					boolean islight=true;
					String bgcolorvalue = "";
					while(iterator.hasNext()){
						String formid = Util.null2String(iterator.next());
						String tablename = Util.null2String(sameformtableMap.get(formid));
						if(islight){
	                        bgcolorvalue="#f5f5f5";
	                        islight=!islight;
	                    }else{
	                        bgcolorvalue="#b7e0fe";
	                        islight=!islight;
	                    }
					%>
						<tr>
							<td style="background-color: <%=bgcolorvalue%>;"><%=formid %></td>
							<td style="background-color: <%=bgcolorvalue%>;"><%=tablename %></td>
						</tr>
					<%
					}
					%>
				</table>
				<%}%>
				
			<iframe id="upload_faceico" name="upload_faceico" style="display: none;"></iframe>
			</div>
			<div class="desc">
				<button id="uploadBtn" type="button" class="divBtn" onclick="importwf();"><%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%><!-- 开始导入 --><img src="/formmode/images/downloadCloud_wev8.png" style="vertical-align: bottom;margin:0 0px 2px 4px;"/></button>
			</div>
		</div>
	</div>
</div>
</td>
</tr>
</table>
</form>
</body>
</HTML>