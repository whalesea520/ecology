<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@page import="weaver.formmode.exttools.impexp.common.StringUtils"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ include file="/systeminfo/init.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
	String modeid = StringUtils.null2String(request.getParameter("id"));
	String appid = StringUtils.null2String(request.getParameter("appId"));//应用id
	RecordSet rs = new RecordSet();
	if(!"".equals(modeid)){
		String sql = "select modetype,modename from modeinfo where id='"+modeid+"'";
		rs.executeSql(sql);
		if(rs.next()){
			appid = StringUtils.null2String(rs.getString("modetype"));
		}
	}
	String sessionid = session.getId();
	ResourceComInfo resourceComInfo = new ResourceComInfo();
	String appname = "",modename = "";
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
	String pageid = "impexp:"+appid+"-"+StringUtils.getIntValue(modeid, 0);
	//System.out.println("---"+objid+"---"+dataType+"---"+selectMode+"---"+appid);
%>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
		<script src="/formmode/js/jquery/form/jquery.form.js"></script>
	    <SCRIPT language="javascript" src="/js/weaver.js"></script>
		<style>
			#loading{
			    position:absolute;
			    left:45%;
			    background:#ffffff;
			    top:40%;
			    padding:8px;
			    z-index:20001;
			    height:auto;
			    border:1px solid #ccc;
			}
		</style>
	</head>
	<%
		String imagefilename = "/images/hdSystem.gif";
		//String titlename = "应用:"+appname+"/模块:"+modename+"导入";//"流程导入";24771
		String titlename ="";
		if("".equals(modeid)) {
			titlename = "应用:"+appname+" 导入/导出";
		} else {
			titlename = "模块:"+modename+" 导入/导出";
		}
		String needhelp = "";
	%>
	<BODY>
	<%@ include file="/systeminfo/TopTitle.jsp"%>
	<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_self} " ;//搜索
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(82176,user.getLanguage())+",javascript:doClear(),_self} " ;//清空条件
		RCMenuHeight += RCMenuHeightStep ;
		if(!"".equals(appname)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+SystemEnv.getHtmlLabelName(25432,user.getLanguage())+",javascript:doExp("+appid+",0),_self} " ;//导出应用
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(!"".equals(modename)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+SystemEnv.getHtmlLabelName(19049,user.getLanguage())+",javascript:doExp("+modeid+",1),_self} " ;//导出模块
			RCMenuHeight += RCMenuHeightStep ;
		}
	%>
	<%@ include file="/systeminfo/RightClickMenu.jsp"%>
		<div id="loading">
			<span><img src="/images/loading2.gif" align="absmiddle"></span>
			<!-- 数据导入中，请稍等... -->
			<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(28210,user.getLanguage())%></span>
		</div>

		<div id="content">
			<table width=100%  border="0" cellspacing="0"
				cellpadding="0">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<FORM style="MARGIN-TOP: 0px" id="frmMain" name=frmMain method=post action="/formmode/exttools/impexpAction.jsp" enctype="multipart/form-data">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
									<TABLE class=ViewForm>
										<COLGROUP>
											<COL width="20%">
											<COL width="80%">
										<TBODY>
											<TR class=Title>
												<TH colSpan=2>
													<!-- 必要信息 -->
													<%=SystemEnv.getHtmlLabelName(25645,user.getLanguage())%>
												</TH>
											</TR>
											<TR class=Spacing style="height:1px;">
												<TD class=Line1 colSpan=2></TD>
											</TR>
											<tr>
												<td>
													<!-- 导入 -->
													<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>
												</td>
												<td class=Field>
													<button id="importbutton" type=BUTTON  class=btnSave onclick="importwf();" title="<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>">
														<!-- 开始导入-->
														<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>
													</button>
													<button id="cancelexpbutton" type=BUTTON  class=btnCancel onclick="cancelExp();" title="取消导出" style="display: none;">
														取消导出
													</button>
												</td>
											</tr>
											<TR class=Spacing style="height:1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
											<tr>
												<td>
													<!-- 文件-->
													XML<%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>
												</td>
												<td class=Field>
													<input class=InputStyle  type=file size=40 name="filename" id="filename" onChange="checkinput('filename','filenamespan')">
													<input type="hidden" id="appid" name="appid" value="<%=appid%>"/>
													<span id="filenamespan"><img src="/images/BacoError.gif" align=absmiddle></span> 
												</td>
											</tr>
											<TR style="height:1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
											
											<TR id=ImportDesc>
												<TD colSpan=2>
													<!-- <br>
													<B>功能说明</B>： -->
													<BR>
													<!-- 有关权限、页面扩展等部分功能由于存在关联性，因此不做导入，有关人力资源等相关设置，请在导入后检查设置-->
													<%=SystemEnv.getHtmlLabelName(82012,user.getLanguage())%>。<BR>
													<%=SystemEnv.getHtmlLabelName(127431,user.getLanguage())%>。<BR>
													3.当前应用如果存在下级模块，导入应用时会导致已经存在的下级模块无法显示，此时不能导入应用。<BR>
													4.要导入的应用中如果存在模块和应用同级，也不能够导入应用，原因同上。<BR>
													5.当前应用中如果存在下级应用，不能再导入模块。<BR>
												</TD>
											</TR>
										</TBODY>
									</TABLE>
								</td>
							</tr>
						</TABLE>
						</FORM>
					</td>
					<td></td>
				</tr>
				<tr>
					<td></td>
					<td>
						<form name="frmSearch" method="post" action="/formmode/exttools/impexp7.jsp">
						<input type="hidden" name="appId" value="<%=appid %>">
						<input type="hidden" name="id" value="<%=modeid %>">
						<table class="ViewForm">
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
								<td><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%><!-- 操作人 --></td>
								<td class="Field">
									<button type="button" class=Browser id=createrSelect onClick="onShowResource(operator,operatorspan)" name=createrSelect></BUTTON>
						  		 	<span id=operatorspan><%=resourceComInfo.getResourcename(operator)%></span>
						  		 	<input type="hidden" name="operator" id="operator" value="<%=operator%>">
								</td>
								<td><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%><!-- 操作类型 --></td>
								<td class="Field">
									<select style="width: 100px;" id="operateType" name="operateType">
										<option></option>
										<option <%if("1".equals(operateType)){%>selected="selected"<%} %> value="1"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage()) %></option>
										<option <%if("0".equals(operateType)){%>selected="selected"<%} %> value="0"><%=SystemEnv.getHtmlLabelName(17416,user.getLanguage())%></option>
									</select>
								</td>
								<td><%=SystemEnv.getHtmlLabelName(125929,user.getLanguage())%><!-- 数据类型 --></td>
								<td class="Field">
									<select style="width: 100px;" id="dataType" name="dataType">
										<option></option>
										<%-- <%if(selectMode){ %> --%>
										<option <%if("1".equals(dataType)){%>selected="selected"<%} %> value="1"><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage()) %></option>
										<option <%if("0".equals(dataType)){%>selected="selected"<%} %> value="0"><%=SystemEnv.getHtmlLabelName(25432,user.getLanguage())%></option>
										<%-- <%}else{ %>
										<option <%if("0".equals(dataType)){%>selected="selected"<%} %> value="0"><%=SystemEnv.getHtmlLabelName(25432,user.getLanguage())%></option>
										<%} %> --%>
									</select>
								</td>
								<td><%=SystemEnv.getHtmlLabelName(19464,user.getLanguage())%><!-- 数据对象 --></td>
								<td class="Field">
									<select style="width: 100px;" id="objid" name="objid">
										<option></option>
										<%if("0".equals(dataType)&&!"".equals(appid)){%>
											<option <%if(objid.equals("app_"+appid)){ %>selected="selected"<%} %> value="app_<%=appid %>"><%=appname %></option>
										<%}else if("1".equals(dataType)&&!"".equals(modeid)){ %>
											<option <%if(objid.equals("mode_"+modeid)){ %>selected="selected"<%} %> value="mode_<%=modeid %>"><%=modename %></option>
										<%} %>
									</select>
								</td>
								<td><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%><!-- 操作时间 --></td>
								<td class="Field">
									<button class="calendar" onclick="gettheDate(startdate,startdate_span)" type="button"></button>
									<input type="hidden" class="calendar" id="startdate" name="startdate" onclick="WdatePicker()" value="<%=startdate %>"/>
									<span id="startdate_span" name="startdate_span"><%=startdate %></span>
									-&nbsp;&nbsp;<button class="calendar" onclick="gettheDate(enddate,enddate_span)" type="button"></button>
									<input type="hidden" class="calendar" id="enddate" name="enddate" onclick="WdatePicker()" value="<%=enddate %>"/>
									<span id="enddate_span" name="enddate_span"><%=enddate %></span>
								</td>
							</tr>
						</table>
						</form>
					</td>
					<td></td>
				</tr>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
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
									"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(127353,user.getLanguage())+SystemEnv.getHtmlLabelName(127354,user.getLanguage())+"\" column=\"id\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.exttools.impexp.log.LogTransferService.getDetail\"/>"+
								"</head>"+
						"</table>";
					%>
					<td>
						<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
					</td>
					<td></td>
				<tr></tr>	
			</table>
			<div id='divshowreceivied'
				style="background: #FFFFFF; padding: 3px; width: 100%; display: none"
				valign='top'>
			</div>
		</div>
	</BODY>
</HTML>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
<script type="text/javascript">
	function doSubmit(){
        hideAllButton();
        document.frmSearch.submit();
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
	jQuery(document).ready(function(){
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
		});
		//jQuery("#loading").hide();
		//jQuery("#cancelexpbutton").show();
		doStatus();
	})
	function clearObjid(ctl){
		for(var i=ctl.options.length-1; i>=0; i--){
			ctl.remove(i);
		}
	}
	function doExp(id,ptype){
		//window.open("/formmode/exttools/impexpAction.jsp?id="+id+"&ptype="+ptype+"&type=0");
		jQuery("#loading-msg").html("数据导出中，请稍等...");
		hideAllButton();
		jQuery("#cancelexpbutton").show();
		//var oldhtml = jQuery("#loading-msg").html();
		//jQuery("#loading-msg").html("数据导出中，请稍等...");
		//jQuery("#loading").show();
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
						finishStatus();
						showAllButton();
						jQuery("#cancelexpbutton").hide();
						var logid = data.logid;
						showDetail(logid);
						return;
					}
					var process = data.process;
					var ptype = data.ptype;
					if(process!=100){
						hideAllButton();
						setTimeout(doStatus,200);
						if(ptype == 0) {
							jQuery("#cancelexpbutton").show();
							jQuery("#loading-msg").html("数据导出中，请稍等...");
						}
					}else{
						if(ptype==0){
							finishStatus();
							showAllButton();
							jQuery("#cancelexpbutton").hide();
							var fileid = data.fileid;
							var url = "/weaver/weaver.file.FileDownload?fileid=" + fileid + "&download=1";
							location.href = url;
						}else{
							finishStatus();
							showAllButton();
							var logid = data.logid;
							showDetail(logid);
						}
					}
				}else{
					finishStatus();
					showAllButton();
					jQuery("#cancelexpbutton").hide();
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
    function showDetail(logid,loglevel){
   		var title = "<%=SystemEnv.getHtmlLabelName(83, user.getLanguage())+ SystemEnv.getHtmlLabelName(17463, user.getLanguage())%>";
		var url="/formmode/exttools/impexplogdetail7.jsp?logid="+logid;
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
    function importwf(){
		var filename = $("#filename").val();
		if(filename==null||filename==''){
			alert("请选择文件!");
			return;
		}
		var id = $("#appid").val();
		var isadd = $("#isadd").attr("checked");
		var version = "7";
		isadd = isadd?"1":"0";
		/*document.frmMain.action = "/formmode/exttools/impexpAction.jsp?id="+id+"&type=1&isadd="+isadd;
		document.frmMain.submit();
		*/
		//setTimeout(doStatus,200);
		jQuery("#cancelexpbutton").hide();
		jQuery("#loading-msg").html("数据导入中，请稍等...");
		hideAllButton();
		$("#frmMain").ajaxSubmit({
			type:"post",
			url:"/formmode/exttools/impexpAction.jsp?id="+id+"&type=1&isadd="+isadd+"&version="+version+"&pageid=<%=pageid%>",
			enctype:"multipart/form-data",
			dataType:"json",
			success:function(data){
				setTimeout(doStatus,200);
			}
		});
	}
	function showAllButton(){
		displayAllmenu();
		jQuery("#loading").hide();
		$("#importbutton").attr("disabled",false);
	}
	function hideAllButton(){
		enableAllmenu();
		jQuery("#loading").show();
		$("#importbutton").attr("disabled",true);
	}
	 function onShowResource(inputName, spanName) {
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }
</script>