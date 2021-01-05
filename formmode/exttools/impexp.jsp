<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.formmode.exttools.impexp.common.StringUtils"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.formmode.exttools.impexp.exp.service.ProgressStatus"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String modeid = StringUtils.null2String(request.getParameter("id"));//模块id
	String appid = StringUtils.null2String(request.getParameter("appId"));//应用id
	String subCompanyId = StringUtils.null2String(request.getParameter("subCompanyId"));
	String sessionid = session.getId();
	ResourceComInfo resourceComInfo = new ResourceComInfo();
	String appname = "",modename = "";
	RecordSet rs = new RecordSet();
	boolean selectMode = false;
	if(!"".equals(modeid)&&!"null".equals(modeid)){
		selectMode = true;
	}
	if(!"".equals(appid)&&!"null".equals(appid)){
		rs.executeSql("select treefieldname from modetreefield where id='"+appid+"'");
		if(rs.next()){
			appname = StringUtils.null2String(rs.getString(1));
		}
	}
	if(!"".equals(modeid)&&!"null".equals(modeid)){
		rs.executeSql("select modename from modeinfo where id='"+modeid+"'");
		if(rs.next()){
			modename = StringUtils.null2String(rs.getString(1));
		}
	}
	String titlename = "";//appname +" / "+modename;
	String startdate = StringUtils.null2String(request.getParameter("startdate"));
	String enddate = StringUtils.null2String(request.getParameter("enddate"));
	String operateType = StringUtils.null2String(request.getParameter("operateType"));
	String dataType = StringUtils.null2String(request.getParameter("dataType"));
	String objid = StringUtils.null2String(request.getParameter("objid"));
	String operator = StringUtils.null2String(request.getParameter("operator"));
	if(request.getParameter("dataType")==null){
		if(selectMode){
			dataType = "1";
		}else{
			dataType = "0";
		}
	}
	if(request.getParameter("objid")==null){
		if(selectMode){
			objid = "mode_"+modeid;
		}else{
			objid = "app_"+appid;
		}
	}
	if("".equals(modeid)) {
		titlename = "应用:"+appname+" 导入/导出";
	} else {
		titlename = "模块:"+modename+" 导入/导出";
	}
	
	String pageid = "impexp:"+appid+"-"+StringUtils.getIntValue(modeid, 0);
	//titlename = "应用:"+ap+pname+"/模块:"+modename+"导入";
%>
<html>
	<head>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT type="text/javascript" src="/formmode/js/WdatePicker/WdatePicker_wev8.js"></script>
		<script src="/formmode/js/jquery/form/jquery.form_wev8.js"></script>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
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
			.e8_label_desc{
				color: #aaa;
			}
			
			#appTable{
				width: 100%;
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
			#progressTitle{
				height:30px;position:absolute;top:42px;left:25px;z-index:999;font-size:12px;color:#f8f8f8;
			}
			#progressVal{
				position: absolute;
				top:75px;
				left:25px;
				height:30px;
				color:#fff;
				font-size:28px;
				font-weight: bold;
				z-index:999;
			}
			#progressContent{
				position: absolute;
				top:60px;
				left:25px;
				height:30px;
				color:blue;
				font-size:12px;
				font-weight: bold;
				z-index:999;
			}
			#progressGif{
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
		<style>
		td.e8_tblForm_label{
			vertical-align: middle !important;
		}
		</style>
	</head>
	<body>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_top} " ;//搜索
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(82176,user.getLanguage())+",javascript:doClear(),_top} " ;//清空条件
		RCMenuHeight += RCMenuHeightStep ;
		if(!"".equals(appname)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+SystemEnv.getHtmlLabelName(25432,user.getLanguage())+",javascript:doExp("+appid+",0),_self} " ;//导出应用
		}
		if(!"".equals(modename)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+SystemEnv.getHtmlLabelName(19049,user.getLanguage())+",javascript:doExp("+modeid+",1),_self} " ;//导出模块
		}
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="appTable">
			<colgroup>
			<col width="*"/>
			</colgroup>
			<tr>
				<td>
					<div id="appPart3" class="appPart">
						<div class="elementPart">
							<div class="title"><%=titlename %><!-- 应用/模块导入 --></div>
							<div class="content">
								<div class="divProgress">
									<div id="progressTitle">%COMPLETE</div>
									<div id="progressVal">0%</div>
									<div id="progressContent"></div>
									<div id="progressGif"></div>
								</div>
								<div class="filecontent">
									<FORM style="MARGIN-TOP: 0px" id="frmMain" name=frmMain method=post action="/formmode/exttools/impexpAction.jsp" enctype="multipart/form-data" target="upload_faceico">
										<input class=InputStyle  type=file  name="filename" id="filename" style="width:280px;background-color:#fff;border:1px solid #eee;outline:none;">
										<input type="hidden" id="appid" name="appid" value="<%=appid%>"/>
									</FORM>
									<iframe id="upload_faceico" name="upload_faceico" style="display: none;"></iframe>
								</div>
								<%-- <div class="desc">
									<INPUT class="inputstyle" type="checkbox" id="isadd" name="isadd" value="1" /><%=SystemEnv.getHtmlLabelNames("83023,1421",user.getLanguage())%>
									<font color="red"><%=SystemEnv.getHtmlLabelName(127432,user.getLanguage())%><!-- 注：此选项勾选后，始终新增数据；不勾选首次导入新增，之后更新。 --></font>
								</div> --%>
								<div class="desc">
									<ul>
										<!-- <li>功能说明：</li> -->
										<li><%=SystemEnv.getHtmlLabelName(82012,user.getLanguage())%><!-- 1.有关人力资源等相关设置，请在导入后检查设置。 --></li>
										<li><%=SystemEnv.getHtmlLabelName(127431,user.getLanguage())%><!-- 2.导入后权限相关设置如果涉及到人力资源、部门等基础数据，可能需要重新配置! --></li>
									</ul>
									<button id="uploadBtn" type="button" class="divBtn" onclick="importwf();"><%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%><img src="/formmode/images/downloadCloud_wev8.png" style="vertical-align: bottom;margin:0 0px 2px 4px;"/></button>
									<button id="cancelExpBtn" type="button" class="divBtn" style="display: none;" onclick="cancelExp();">取消导出<img src="/formmode/images/downloadCloud_wev8.png" style="vertical-align: bottom;margin:0 0px 2px 4px;"/></button>
								</div>
							</div>
						</div>
					</div>
				</td>
			</tr>
		</table>
		<form name="frmSearch" method="post" action="/formmode/exttools/impexp.jsp">
		<input type="hidden" name="appId" value="<%=appid %>">
		<input type="hidden" name="id" value="<%=modeid %>">
		<input type="hidden" name="pageid" value="<%=pageid %>">
		<table class="e8_tblForm">
			<colgroup>
				<col width="6%">
				<col width="14%">
				<col width="6%">
				<col width="14%">
				<col width="6%">
				<col width="14%">
				<col width="6%">
				<col width="14%">
				<col width="6%">
				<col width="14%">
			</colgroup>
			<tr>
				<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%><!-- 操作人 --></td>
				<td class="e8_tblForm_field">
					<brow:browser viewType="0" name="operator" browserValue='<%= ""+operator %>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp" linkUrl="javascript:void($id$)"  width="178px"
						browserDialogWidth="700px"
						browserSpanValue='<%=resourceComInfo.getResourcename(""+operator)%>'
						></brow:browser>
				</td>
				<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%><!-- 操作类型 --></td>
				<td class="e8_tblForm_field">
					<select style="width: 100px;" id="operateType" name="operateType">
						<option></option>
						<option <%if("1".equals(operateType)){%>selected="selected"<%} %> value="1"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage()) %></option>
						<option <%if("0".equals(operateType)){%>selected="selected"<%} %> value="0"><%=SystemEnv.getHtmlLabelName(17416,user.getLanguage())%></option>
					</select>
				</td>
				<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(125929,user.getLanguage())%><!-- 数据类型 --></td>
				<td class="e8_tblForm_field">
					<select style="width: 100px;" id="dataType" name="dataType">
						<option></option>
					<%-- 	<%if(selectMode){ %> --%>
						<option <%if("1".equals(dataType)){%>selected="selected"<%} %> value="1"><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage()) %></option>
						<option <%if("0".equals(dataType)){%>selected="selected"<%} %> value="0"><%=SystemEnv.getHtmlLabelName(25432,user.getLanguage())%></option>
						<%-- <%}else{ %>
						<option <%if("0".equals(dataType)){%>selected="selected"<%} %> value="0"><%=SystemEnv.getHtmlLabelName(25432,user.getLanguage())%></option>
						<%} %> --%>
					</select>
				</td>
				<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(19464,user.getLanguage())%><!-- 数据对象 --></td>
				<td class="e8_tblForm_field">
					<select style="width: 100px;" id="objid" name="objid">
						<option></option>
						<%if("0".equals(dataType)&&!"".equals(appid)){%>
							<option <%if(objid.equals("app_"+appid)){ %>selected="selected"<%} %> value="app_<%=appid %>"><%=appname %></option>
						<%}else if("1".equals(dataType)&&!"".equals(modeid)){ %>
							<option <%if(objid.equals("mode_"+modeid)){ %>selected="selected"<%} %> value="mode_<%=modeid %>"><%=modename %></option>
						<%} %>
					</select>
				</td>
				<td class="e8_tblForm_label" ><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%><!-- 操作时间 --></td>
				<td class="e8_tblForm_field">
					<%=SystemEnv.getHtmlLabelName(83838,user.getLanguage())%>
					<button class="calendar" onclick="onSearchWFQTDate(startdate_span,startdate)" type="button"></button>
					<input type="hidden" class="calendar" id="startdate" name="startdate" onclick="WdatePicker()" value="<%=startdate %>"/>
					<span id="startdate_span" name="startdate_span"><%=startdate %></span>
					<%=SystemEnv.getHtmlLabelName(33973,user.getLanguage())%>
					<button class="calendar" onclick="onSearchWFQTDate(enddate_span,enddate)" type="button"></button>
					<input type="hidden" class="calendar" id="enddate" name="enddate" onclick="WdatePicker()" value="<%=enddate %>"/>
					<span id="enddate_span" name="enddate_span"><%=enddate %></span>
				</td>
			</tr>
		</table>
		</form>
		<%
		String perpage = "10";
		String backFields = "a.id,a.creator,a.createdate,a.createtime,a.type,a.datatype,a.fileid";
		String sqlFrom = "from mode_impexp_log a";
		String SqlWhere = " where 1=1 ";
		if(!"".equals(startdate)){
			SqlWhere += " and a.createdate>='"+startdate+"' ";
		}
		if(!"".equals(enddate)){
			SqlWhere += " and a.createdate<='"+enddate+"' ";
		}
		if(!"".equals(operateType)){
			SqlWhere += " and a.type='"+operateType+"' ";
		}
		if(!"".equals(dataType)){
			SqlWhere += " and a.datatype='"+dataType+"' ";
		}
		if(!"".equals(objid)){
			String objid_v = objid.replace("mode_","").replace("app_","");
			SqlWhere += " and objid='"+objid_v+"' ";
		}
		if(!"".equals(operator)){
			SqlWhere += " and operator='"+operator+"' ";
		}
		String tableString = ""+
			"<table  pagesize=\""+perpage+"\" tabletype=\"none\" >"+
				"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
					"<head>"+ 
						//操作人    
						"<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"\" column=\"creator\" transmethod=\"weaver.formmode.exttools.impexp.log.LogTransferService.getCreator\"/>"+
						//操作类型
						"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15503,user.getLanguage())+"\" column=\"type\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.exttools.impexp.log.LogTransferService.getType\"/>"+
						//数据类型
						"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(125929,user.getLanguage())+"\" column=\"datatype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.exttools.impexp.log.LogTransferService.getDataType\"/>"+
						//数据对象
						"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(19464,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.formmode.exttools.impexp.log.LogTransferService.getObj\"/>"+
						//操作日期
						"<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(21663,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\" />"+
						//操作时间
						"<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(18008,user.getLanguage())+"\" column=\"createtime\" orderkey=\"createtime\" />"+
						//操作
						"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(104,user.getLanguage())+"\" column=\"id\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.exttools.impexp.log.LogTransferService.getOperate\"/>"+
						//操作
						"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("127353,127354",user.getLanguage())+"\" column=\"id\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.exttools.impexp.log.LogTransferService.getDetail\"/>"+
					"</head>"+
			"</table>";
		%>
		<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
	</body>
	<script type="text/javascript">
		$(document).ready(function(){//onload事件
			
			$("#dataType").change(function(){
				var dataType = $("#dataType").val();
				var objid = document.getElementById("objid");
				clearObjid(objid);
				if(dataType=='0'){
					objid.options.add(new Option("",""));
					<%if(!"".equals(appid)){%>
					objid.options.add(new Option("<%=appname%>","app_<%=appid%>"));
					<%}%>
				}else if(dataType=='1'){
					objid.options.add(new Option("",""));
					<%if(!"".equals(modeid)&&!"null".equals(modeid)){%>
					objid.options.add(new Option("<%=modename%>","mode_<%=modeid%>"));
					<%}%>
				}else{
					objid.options.add(new Option("",""));
				}
				jQuery(objid).selectbox("detach");
				beautySelect(objid);
			});
			
			setImpBtnDisable(true);
			jQuery("#progressGif").css("background-image", "url(/formmode/images/animated-overlay_wev8.gif)");
			jQuery("#progressVal").css("color", "#FD6500");
			jQuery("#cancelExpBtn").show();
			$(".loading", window.parent.document).hide(); //隐藏加载图片
			doStatus(1);
		})
		function clearObjid(ctl){
			for(var i=ctl.options.length-1; i>=0; i--){
				ctl.remove(i);
			}
		}
		function doExp(id,ptype){
			//window.open("/formmode/exttools/impexpAction.jsp?id="+id+"&ptype="+ptype+"&type=0");
			setImpBtnDisable(true);
			jQuery("#cancelExpBtn").show();
			jQuery("#progressGif").css("background-image", "url(/formmode/images/animated-overlay_wev8.gif)");
			jQuery("#progressVal").css("color", "#FD6500");
			$.ajax({
				type:"post",
				url:"/formmode/exttools/impexpAction.jsp",
				data:{type:0,id:id,ptype:ptype,pageid:'<%=pageid%>'},
				dataType:"json",
				success:function(data){
					//location.href=data.downloadurl;
					setTimeout(doStatus,200);
				}
			});
		}
		function cancelExp(){
			$.ajax({
				type:"post",
				url:"/formmode/exttools/impexpAction.jsp",
				data:{type:5,pageid:'<%=pageid%>'},
				dataType:"json",
				success:function(data){
					//location.href=data.downloadurl;
					setTimeout(doStatus,200);
				}
			});
		}
		/*设置导入按钮是否禁用*/
		function setImpBtnDisable(f){
			if(f){
				jQuery("#uploadBtn").attr("disabled","disabled").addClass("divBtnDisabled");
			}else{
				jQuery("#uploadBtn").removeAttr("disabled").removeClass("divBtnDisabled");
				
			}
		}
		
		function importwf(){
			setImpBtnDisable(true);
			var filename = $("#filename").val();
			if(filename==null||filename==''){
				alert("请选择文件!");
				setImpBtnDisable(false);
				return;
			}
			var id = $("#appid").val();
			var ptype = $("#ptype").val();
			var isadd = $("#isadd").attr("checked");
			isadd = isadd?"1":"0";
			/*document.frmMain.action = "/formmode/exttools/impexpAction.jsp?id="+id+"&type=1&isadd="+isadd;
			document.frmMain.submit();
			*/
			jQuery("#progressGif").css("background-image", "url(/formmode/images/animated-overlay_wev8.gif)");
			jQuery("#progressVal").css("color", "#FD6500");
			$("#frmMain").ajaxSubmit({
				type:"post",
				url:"/formmode/exttools/impexpAction.jsp?id="+id+"&type=1&isadd="+isadd+"&pageid=<%=pageid%>&subCompanyId=<%=subCompanyId%>",
				enctype:"multipart/form-data",
				dataType:"json",
				success:function(data){
					setTimeout(doStatus,200);
				}
			});
		}
		function onSearchWFQTDate(spanname,inputname){
			var oncleaingFun = function(){
				  $(spanname).innerHTML = '';
				  inputname.value = '';
				}
				WdatePicker({el:spanname,onpicked:function(dp){
					var returnvalue = dp.cal.getDateStr();
					$dp.$(inputname).value = returnvalue;
				},oncleared:oncleaingFun});
		}
		function doClear(){
			$("#operator").val('');
			$("#operatorspan").html('');
			$("#startdate").val('');
			$("#enddate").val('');
			$("#startdate_span").html('');
			$("#enddate_span").html('');
			$(".sbSelector").html('');
			$("#dataType").val('');
			$("#operateType").val('');
			$("#objid").val('');
		}
	
	    function doSubmit(){
	        enableAllmenu();
	        document.frmSearch.submit();
	    }
	    
	    function showDetail(logid,loglevel){
    		var title = "<%=SystemEnv.getHtmlLabelNames("83,17463",user.getLanguage())%>";
			var url="/formmode/exttools/impexplogdetail.jsp?logid="+logid;
			if(loglevel){
				url += "&loglevel="+loglevel;
			}
			diag_vote = new window.top.Dialog();
			diag_vote.currentWindow = window;
			diag_vote.Width = 1000;
			diag_vote.Height = 800;
			diag_vote.Modal = true;
			diag_vote.Title = title;
			diag_vote.URL = url;
			diag_vote.show();
	    }
	    
	    function doStatus(){
	    	$.ajax({
				type:"post",
				url:"/formmode/exttools/impexpAction.jsp",
				data:{type:3,pageid:'<%=pageid%>'},
				dataType:"json",
				success:function(data){
					var inprocess = data.inprocess;
					if(inprocess){
						var error = data.error;
						if(error){
							var logid = data.logid;
							showDetail(logid);
							return;
						}
						var process = data.process;
						var ptype = data.ptype;
						if(process!=100){
							$("#progressVal").html(process+"%");
							if(ptype==0){
								var datatype = data.datatype;
								if(datatype){
									$("#progressContent").html("正在导出"+datatype+"...");
								}else{
									$("#progressContent").html("正在导出...");
								}
							}else if(ptype==1){
								var datatype = data.datatype;
								if(datatype){
									$("#progressContent").html("正在导入"+datatype+"...");
								}else{
									$("#progressContent").html("正在导入...");
								}
								jQuery("#cancelExpBtn").hide();
							}
							setTimeout(doStatus,200);
						}else{
							$("#progressVal").html("0%");
							$("#progressContent").html("");
							jQuery("#progressGif").css("background-image", "");
							jQuery("#progressVal").css("color", "#fff");
							jQuery("#cancelExpBtn").hide();
							jQuery("#filename").val("");
							setImpBtnDisable(false);
							
							if(ptype==0){
								finishStatus();
								var fileid = data.fileid;
								var logid = data.logid;
								var url = "/weaver/weaver.file.FileDownload?fileid=" + fileid + "&download=1";
								location.href = url;
								$("#"+logid+"_caozuo").attr("href",url);
                                $("#"+logid+"_caozuo").attr('onclick','').unbind('click');
							}else{
								finishStatus();
								var logid = data.logid;
								showDetail(logid);
							}
						}
					}else{
						finishStatus();
						$("#progressVal").html("0%");
						$("#progressContent").html("");
						setImpBtnDisable(false);
						jQuery("#cancelExpBtn").hide();
						jQuery("#progressGif").css("background-image", "");
						jQuery("#progressVal").css("color", "#fff");
					}
				}
			});
	    }
	    
	    function finishStatus(){
	    	$.ajax({
				type:"post",
				url:"/formmode/exttools/impexpAction.jsp",
				data:{type:4,pageid:'<%=pageid%>'}
			});
	    }
	    function checkUndown(){
	        top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(4835,user.getLanguage())%>");
	    }
	</script>
</html>