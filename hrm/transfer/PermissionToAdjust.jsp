<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- Added by wcd 2014-10-14 [权限调整] -->
<%@page import="weaver.hrm.authority.domain.*,weaver.hrm.authority.manager.*,weaver.common.StringUtil"%>
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="HrmTransferSetManager" class="weaver.hrm.authority.manager.HrmTransferSetManager" scope="page" />
<jsp:useBean id="HrmTransferLogManager" class="weaver.hrm.authority.manager.HrmTransferLogManager" scope="page" />
<jsp:useBean id="HrmTransferLogDetailManager" class="weaver.hrm.authority.manager.HrmTransferLogDetailManager" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmRrightTransfer:Tran", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String transferType = Util.null2String(request.getParameter("transferType"),"resource");
	String authorityTag = Util.null2String(request.getParameter("authorityTag"),"transfer");
	Map cMap = new HashMap();
	cMap.put("pMember", user.getUID());
	cMap.put("pStatus", "0");
	cMap.put("pType", authorityTag.equals("transfer")?"0":(authorityTag.equals("copy")?"1":"2"));
	HrmTransferLog tLog = HrmTransferLogManager.get(cMap);
	boolean isFinished = false;
	if(tLog == null){
		cMap.remove("pStatus");
		cMap.put("sql_pStatus", "and t.p_status in (1,2)");
		cMap.put("isRead", "0");
		tLog = HrmTransferLogManager.get(cMap);
		
		if(tLog != null){
			isFinished = true;
			tLog.setIsRead(1);
			tLog.setReadDate(Tools.getToday());
			HrmTransferLogManager.update(tLog);
		}
	}
	boolean isShowMessage = tLog != null;
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelNames("385,80",user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	String cmd = Util.null2String(request.getParameter("cmd"));
	String numberstr = Tools.getURLDecode(request.getParameter("numberstr"));
	boolean isP = numberstr.length() == 0;
	String fromid=Util.null2String(request.getParameter("fromid"));
	if(fromid.length()==0)fromid=Util.null2String(request.getParameter("resourceid"));
	String toid=Util.null2String(request.getParameter("toid"));
	if(tLog != null){
		transferType = tLog.getType();
		fromid = tLog.getFromid();
		toid = tLog.getToid();
	}
	String fromname = "";
	if(fromid.length() > 0){
		if(transferType.equals("resource")) {
			fromname = ResourceComInfo.getResourcename(fromid);
		} else if(transferType.equals("department")) {
			fromname = DepartmentComInfo.getDepartmentname(fromid);
		} else if(transferType.equals("subcompany")) {
			fromname = SubCompanyComInfo.getSubCompanyname(fromid);
		} else if(transferType.equals("role")) {
			fromname = RolesComInfo.getRolesRemark(fromid);
		}	else if(transferType.equals("jobtitle")) {
			fromname = JobTitlesComInfo.getJobTitlesmark(fromid);
		}
	}
	String toname = "";
	if(toid.length() > 0){
		String[] toids = toid.split(",");
		for(String _toid : toids){
			if(transferType.equals("resource")) {
				toname += ResourceComInfo.getResourcename(_toid)+",";
			} else if(transferType.equals("department")) {
				toname += DepartmentComInfo.getDepartmentname(_toid)+",";
			} else if(transferType.equals("subcompany")) {
				toname += SubCompanyComInfo.getSubCompanyname(_toid)+",";
			} else if(transferType.equals("role")) {
				toname += RolesComInfo.getRolesRemark(_toid)+",";
			} else if(transferType.equals("jobtitle")) {
				toname += JobTitlesComInfo.getJobTitlesmark(_toid)+",";
			}
		}
		if(toname.endsWith(",")) {
			toname = toname.substring(0,toname.length()-1);
		}
	}
	String optMemo = "";
	String tIndexId = "";
	String labelIndexId = "";
	int countValue = 0;
	if(authorityTag.equals("transfer")){
		tIndexId = "80";
		labelIndexId = "33379";
		optMemo = SystemEnv.getHtmlLabelName(623,user.getLanguage())+" "+fromname+" <span style='color:#1E90FF'>"+SystemEnv.getHtmlLabelName(80,user.getLanguage())+SystemEnv.getHtmlLabelName(83931,user.getLanguage())+"</span> "+toname;
	} else if(authorityTag.equals("copy")){
		tIndexId = "77";
		labelIndexId = "34033";
		optMemo = SystemEnv.getHtmlLabelName(623,user.getLanguage())+" "+fromname+" <span style='color:#1E90FF'>"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+SystemEnv.getHtmlLabelName(83931,user.getLanguage())+"</span> "+toname;
	} else if(authorityTag.equals("delete")){
		tIndexId = "91";
		labelIndexId = "34240";
		optMemo = "<span style='color:#1E90FF'>"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"</span> " + fromname;
	}
	
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
		<link href="/appres/hrm/css/authority_wev8.css" type="text/css" rel="STYLESHEET">
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script type="text/javascript">
			var opt = "<%=authorityTag%>";
			var isShowMessage = "<%=String.valueOf(isShowMessage)%>";
			var isFinished = "<%=String.valueOf(isFinished)%>";
			
			function setFromValue(fromid, toid, cmd, o){
				clearAll();
				var url = "PermissionToAdjust.jsp?cmd="+cmd+"&fromid="+fromid+"&toid="+toid;
				if(o){
					url += "&authorityTag="+o;
				}
				$GetEle("frmmain").action = url;
				$GetEle("frmmain").submit();
			}
			
			function clearAll(){
				var codeNames;
				if(opt == "transfer"){
					codeNames = [
						"T101","T111","T112","T113","T121","T122","T123","T124","T125","T131",
						"T132","T133","T134","T141","T142","T143","T144","T145","T146","T147",
						"T148","T149","T151","T152","T161","T171","T181","T182","T183","T191",
						"T201","T202","T203","T204","T211","T221","T222","T223","T224","T225",
						"T226","T231","T232","T241","T301","T302","T303","T311","T321","T322",
						"T323","T324","T325","T326","T331","T332","T341","T401","T411","T412",
						"T413","T414","T415","T416","T421","T422","T431","T501","T511","T521",
						"T522","T523","T524","T525","T531","T532","T541","Temail001","Temail002"
					];
				} else if(opt == "copy"){
					codeNames = [
						"C101","C111","C112","C121","C122","C123","C131","C132","C133","C141",
						"C142","C143","C144","C145","C146","C147","C148","C151","C161","C171",
						"C172","C173","C181","C201","C202","C211","C221","C231","C241","C242",
						"C243","C244","C245","C246","C247","C251","C252","C261","C301","C302",
						"C303","C311","C321","C331","C341","C342","C343","C344","C345","C346",
						"C347","C351","C352","C361","C401","C411","C421","C431","C432","C433",
						"C434","C435","C436","C437","C441","C442","C451","C501","C511","C521",
						"C531","C532","C533","C534","C535","C536","C541","C542","C551"
					];
				} else if(opt == "delete"){
					codeNames = [
						"D101","D102","D103","D104","D105","D111","D112","D113","D121","D122",
						"D123","D124","D125","D126","D127","D128","D131","D141","D151","D152",
						"D153","D161","D171","D181","D201","D211","D212","D221","D222","D223",
						"D224","D225","D226","D227","D231","D232","D241","D251","D261","D301",
						"D311","D312","D321","D322","D323","D324","D325","D326","D327","D331",
						"D332","D341","D351","D361","D401","D402","D411","D412","D413","D414",
						"D415","D416","D417","D421","D422","D431","D441","D451","D501","D511",
						"D521","D522","D531","D532","D533","D534","D535","D536","D541","D542",
						"D551"
					];
				}
				if(codeNames){
					for(var i=0;i<codeNames.length;i++){
						clear(codeNames[i]);
					}
				}
				$("#count").html("0");
				$("#updatecount").html("0");
			}
			
			function clear(id){
				if($GetEle(id+"Num")){
					$GetEle(id+"IdStr").value = "";
					$GetEle(id+"Num").innerHTML = "0";
					if(id == "T203"){
						$GetEle("init_T203AllNum").innerHTML = "0";
					} else if(id == "C302"){
						$GetEle("init_C302AllNum").innerHTML = "0";
					}
					$GetEle(id+"All").checked = false;
				}
			}
			
			function doProcFrom(event,data,name){
				var isLock = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=checkFromid&id="+data.id));
				if(isLock == "1"){
					window.top.Dialog.alert(data.name+"<%=SystemEnv.getHtmlLabelNames("18946,563,25666",user.getLanguage())%>");
					return;
				}else {
					opt = $GetEle("authorityTag").value;
					showData();
				}
			}
			
			function delFromCall(text,fieldid,params){
				doChangeType();
			}
			
			function delToCall(text,fieldid,params){
				$GetEle("toid").value = '';
			}
			
			$(function () {
				$("#startExecute").bind("click", function () {
					submitData();
				});
				$("#goBack").bind("click", function () {
					doChange(opt);
				});
				if(!isShowMessage){
					showDiv();
				}
			});
			
			function showBt(obj){
				$(obj).find(".btstyle01").addClass("btstyle02");
			}

			function hiddenBt(obj){
				$(obj).find(".btstyle01").removeClass("btstyle02");
			}
			
			function doChange(o){
				setFromValue("", "", "", o);
			}
			
			function doChangeType(){
				opt = $GetEle("authorityTag").value;
				clearAll();
				_writeBackData('fromid', 2, {id:'',name:''},{hasInput:true});
				_writeBackData('toid', 2, {id:'',name:''},{hasInput:true});
				showDiv();
				hiddenContent();
			}
			
			function hiddenContent(){
				document.all("contentDiv").style.display = "none";
				document.all("contentDiv").innerHTML = "<div class=\"xTable_message\" style=\"top:20%;left:35%\"><%=SystemEnv.getHtmlLabelName(84041, user.getLanguage())%></div>";
			}
			
			function showDiv(){
				document.all("defaultTDiv").style.display = opt == "transfer" ? "block" : "none";
				document.all("defaultCDiv").style.display = opt == "copy" ? "block" : "none";
				document.all("defaultDDiv").style.display = opt == "delete" ? "block" : "none";
			}
			
			function doChangeOpt(){
				opt = $GetEle("authorityTag").value;
				document.all("toDiv").style.display = opt == "delete" ? "none" : "block";
				hiddenContent();
				clearAll();
				showData();
				
			
			}
			
			function getAjaxUrl() {
				var type = $GetEle("transferType").value;
				var value = "1";
				if (type == 'resource') {
					value = "1";
				} else if (type == 'department') {
					value = "4";
				} else if (type == 'subcompany') {
					value = "164";
				} else if (type == 'role') {
					value = "65";
				}	else if (type == 'jobtitle') {
					value = "24";
				}
        		return "/data.jsp?type=" + value;
        	}
			
			function onShowBrowser() {
				var type = $GetEle("transferType").value;
				var url = "";
				if (type == 'resource') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids=";
				} else if (type == 'department') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=";
				} else if (type == 'subcompany') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=";
				} else if (type == 'role') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectids=";
				}	else if (type == 'jobtitle') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?selectids=";
				}
				return url;
			}
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(!isShowMessage){
				RCMenu += "{"+SystemEnv.getHtmlLabelNames("530,1338",user.getLanguage())+",javascript:submitData(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<SCRIPT LANGUAGE="JavaScript">
		<!-- Hide
		function killErrors() {
			return true;
		}
		window.onerror = killErrors;
		// -->
		</SCRIPT>
		<form id=frmmain name=frmmain method=post action="HrmRightTransferOperation.jsp" >
			<input class=inputstyle type=hidden name="jsonSql" value="">
			<input class=inputstyle type=hidden name="submitJson" value="">
			<input class=inputstyle type=hidden name="needExecuteSql" value="0">
			<input class=inputstyle type=hidden name="zsESQL" value="0">
			<div id="top" style="position: absolute!important;width:99.5%;height:118px;border:1px solid #d6dde8;background:#f7f7fa;">
				<div style="display:block;float:left;width:288px;height:101px;border:1px solid #d6dde8;background:#ffffff;margin-top:8px;margin-left:7px;">
					<div id="count" style="float:left;width:77px;height:77px;background:url('/images/ecology8/workflow/permission1_wev8.png');text-align: center;line-height:77px;color:#fff;font-size:22px;margin:0 auto;margin-top:12px;margin-left:20px;">
						0
					</div>
					<div style="float:left;width:129px;height:62px;margin-top:21px;margin-left:30px;">
						<div style="margin:0 auto;">
							<SELECT style="height:28px;width:101px;" name="transferType" onchange="doChangeType()" <%=isShowMessage ? "disabled" : ""%>>
								<option value="resource" <%=transferType.equals("resource")?"selected":""%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
								<option value="department" <%=transferType.equals("department")?"selected":""%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
								<option value="subcompany" <%=transferType.equals("subcompany")?"selected":""%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
								<option value="jobtitle" <%=transferType.equals("jobtitle")?"selected":""%>><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
								<option value="role" <%=transferType.equals("role")?"selected":""%>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
							</SELECT>
						</div>
						<div style="margin:0 auto;margin-top:16px;">
							<brow:browser name="fromid" viewType="0" hasBrowser="true" hasAdd="false" 
								getBrowserUrlFn="onShowBrowser" isMustInput='<%=isShowMessage ? "0" : "2"%>' isSingle="true" hasInput='<%=isShowMessage ? "false" : "true"%>' 
								completeUrl="javascript:getAjaxUrl()" 
								width="129px" browserValue='<%=fromid %>' browserSpanValue='<%=fromname %>' _callback="doProcFrom" afterDelCallback = "delFromCall"/>
						</div>
					</div>
				
				</div>

				<div style="float:left;width:119px;height:101px;margin-top:8px;">
					<div style="width:104px; height:25px;background:url('/images/ecology8/workflow/permissionto_wev8.png');margin:0 auto;margin-top:24px;"></div>
					<div id="operateimages" name="operateimages" class="operateimages0"></div>
				</div>

				<div style="float:left;width:288px;height:101px;border:1px solid #d6dde8;background:#ffffff;margin-top:8px;">
					<div id="updatecount" style="float:left;width:77px;height:77px;background:url('/images/ecology8/workflow/permission2_wev8.png');text-align: center;line-height:70px;color:#fff;font-size:22px;margin:0 auto;margin-top:12px;margin-left:20px;">
						0
					</div>
					<div style="float:left;width:129px;height:62px;margin-top:21px;margin-left:30px;">
						<div style="margin:0 auto;">
							<select id="authorityTag" name="authorityTag" onchange="doChangeOpt()" style="height:28px;width:101px;" <%=isShowMessage ? "disabled" : ""%>>
								<option value="transfer" <%=authorityTag.equals("transfer")?"selected":""%>><%=SystemEnv.getHtmlLabelName(80,user.getLanguage())%></option>
								<option value="copy" <%=authorityTag.equals("copy")?"selected":""%>><%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%></option>
								<option value="delete" <%=authorityTag.equals("delete")?"selected":""%>><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></option>
							</select>
						</div>
						<div id="toDiv" style="margin:0 auto;margin-top:16px;<%=authorityTag.equals("delete")?"display:none":""%>">
							<brow:browser 
								name="toid" viewType="0" hasBrowser="true" hasAdd="false" 
								getBrowserUrlFn="onShowBrowser" isMustInput='<%=isShowMessage ? "0" : "2"%>' isSingle="true" hasInput='<%=isShowMessage ? "false" : "true"%>'
								completeUrl="javascript:getAjaxUrl()" onPropertyChange="" width="129px" 
								browserValue='<%=toid %>' browserSpanValue='<%=toname %>' afterDelCallback = "delToCall"/>
						</div>
					</div>
				</div>
				<div style="float:left;width:90px;height:30px;margin-top:68px;margin-left:30px;">
					<%if(isShowMessage){%>
						<a id="goBack" onmouseover="showBt(this)" onmouseout="hiddenBt(this)"  href="#" style="vertical-align:middle;"><span class="btstyle01"><%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></span></a>
					<%}else{%>
						<a id="startExecute" onmouseover="showBt(this)" onmouseout="hiddenBt(this)"  href="#" style="vertical-align:middle;"><span class="btstyle01"><%=SystemEnv.getHtmlLabelNames("530,1338",user.getLanguage())%></span></a>
					<%}%>
				</div>
			</div>
			<%
				if(isShowMessage) {
			%>
			<div id="messageDiv" style="position:absolute!important;top:120px!important;height:auto!important;position:relative;height:100%;bottom:4px;width:100%;overflow:auto;">
				<div style="margin:0 auto;width:50%;height:100%;padding-top:10px;">
					<div id="refreshDiv" style="display:none;text-align:center">
						<img src="/appres/hrm/image/authority/m01_wev8.png" style="vertical-align:middle;"/><span style="margin-left:10px;color:#73726b;"><%=SystemEnv.getHtmlLabelName(83893,user.getLanguage())%> <strong id="refresh_num" style="color:#1E90FF;font-size:22px;"></strong> <%=SystemEnv.getHtmlLabelName(83896,user.getLanguage())%></span>
						<div style="margin:0 auto;width:90px;height:30px;padding-top:10px;"><a href="javascript:void(0)" onmouseover="showBt(this)" onmouseout="hiddenBt(this)" style="vertical-align:middle;" onclick="stopRefresh()"><span class="btstyle01"><%=SystemEnv.getHtmlLabelName(17581,user.getLanguage())%></span></a></div>
					</div>
					<div>
						<table class="messageBox" cellspacing="0" cellpadding="0">
							<tr style="background:#f8fbfb;" height="38px">
								<td colspan="2" style="padding-left:10px"><%out.println(SystemEnv.getHtmlLabelName(83838,user.getLanguage())+"  <span style='color:#56be9b'>"+Tools.getDateTime(tLog.getPBeginDate())+"</span> "+SystemEnv.getHtmlLabelName(83901,user.getLanguage())+(isFinished ? (SystemEnv.getHtmlLabelName(83903,user.getLanguage())+" <span style='color:#fd5e5b'>"+Tools.getDateTime(tLog.getPFinishDate())+"</span> "+SystemEnv.getHtmlLabelName(83904,user.getLanguage())+" <span style='color:#1E90FF'>"+Tools.formatTimes(tLog.getPTime(),true)+"</span> ") : (isP?SystemEnv.getHtmlLabelName(83907,user.getLanguage()):"")));%></td>
							</tr>
							<tr height="35px">
								<td colspan="2" style="padding-left:10px"><%out.println(optMemo);%></td>
							</tr>
							<%
								String key = "";
								int value = 0;
								String labelId = "";
								if(isFinished){
									cMap.clear();
									cMap.put("logId",tLog.getId());
									cMap.put("sqlorderby","t.code_name");
									List logDetailList = HrmTransferLogDetailManager.find(cMap);
									if(logDetailList != null){
										HrmTransferLogDetail logDetail = null;
										for(int i=0; i<logDetailList.size(); i++){
											logDetail = (HrmTransferLogDetail)logDetailList.get(i);
											value = logDetail.getPNum();
											if(value <= 0){
												continue;
											}
											countValue += value;
											labelId = HrmTransferSetManager.getLabelId(logDetail.getCodeName(), authorityTag);
										%>
											<tr height="35px">
												<td width="40%" style="padding-left:25px;border-right:none;"><%=SystemEnv.getHtmlLabelNames(labelId,user.getLanguage())%>:</td>
												<td width="60%" style="border-left:none;"><span style="color:#4791fd"><%=value%></span>&nbsp;</td>
											</tr>
										<%
										}
									}
								} else {
									if(isP){
										countValue = tLog.getAllNum();
									}else {
										MJson mjson = new MJson(numberstr,true);
										while(mjson.next()){
											key = mjson.getKey();
											value = Tools.parseToInt(mjson.getValue());
											if(value <= 0){
												continue;
											}
											countValue += value;
											labelId = HrmTransferSetManager.getLabelId(key, authorityTag);
										%>
											<tr height="35px">
												<td width="40%" style="padding-left:25px;border-right:none;"><%=SystemEnv.getHtmlLabelNames(labelId,user.getLanguage())%>:</td>
												<td width="60%" style="border-left:none;"><span style="color:#4791fd"><%=value%></span>&nbsp;</td>
											</tr>
										<%
										}
									}
								}
							%>
							<tr style="background:#d7f6e2">
								<td colspan="2" style="padding-left:25px;color:#56be9b;">
									<%out.println(isFinished ? (tLog.getPStatus() == 2 ? SystemEnv.getHtmlLabelName(83912,user.getLanguage()) : (Tools.replace(SystemEnv.getHtmlLabelNames(labelIndexId,user.getLanguage()),"{param}"," <strong>"+countValue+"</strong> ")+"！")) : (SystemEnv.getHtmlLabelName(83933,user.getLanguage())+""+SystemEnv.getHtmlLabelNames(tIndexId,user.getLanguage())+" <strong>"+countValue+"</strong> "+SystemEnv.getHtmlLabelName(83916,user.getLanguage())));%>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
			<%
				}
			%>
			<div id="defaultTDiv" style="position:absolute!important;top:120px!important;height:auto!important;position:relative;height:100%;bottom:4px;width:100%;overflow:auto;display:none">
				<wea:layout type="2col"><wea:group context='<%=SystemEnv.getHtmlLabelNames("80,33368",user.getLanguage())%>'>&nbsp;</wea:group></wea:layout>
			</div>
			<div id="defaultCDiv" style="position:absolute!important;top:120px!important;height:auto!important;position:relative;height:100%;bottom:4px;width:100%;overflow:auto;display:none">
				<wea:layout type="2col"><wea:group context='<%=SystemEnv.getHtmlLabelNames("77,33368",user.getLanguage())%>'>&nbsp;</wea:group></wea:layout>
			</div>
			<div id="defaultDDiv" style="position:absolute!important;top:120px!important;height:auto!important;position:relative;height:100%;bottom:4px;width:100%;overflow:auto;display:none">
				<wea:layout type="2col"><wea:group context='<%=SystemEnv.getHtmlLabelNames("91,33368",user.getLanguage())%>'>&nbsp;</wea:group></wea:layout>
			</div>
			<div id="contentDiv" style="position:absolute!important;top:120px!important;height:auto!important;position:relative;height:100%;bottom:4px;width:100%;overflow:auto;<%=(cmd.equals("showContent") || (fromid.length() > 0 && !isShowMessage)) ? "" : "display:none"%>">
				<div class="xTable_message" style="top:20%;left:35%"><%=SystemEnv.getHtmlLabelName(84041, user.getLanguage())%></div>
			</div>
		</form>
		<script type="text/javascript">
			function check_same(){
				if(opt == "delete"){
					return check_form($GetEle("frmmain"),'fromid');
				}else{
					if(check_form($GetEle("frmmain"),'fromid,toid')){
						if($GetEle("fromid").value==$GetEle("toid").value){
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("106,26250",user.getLanguage())%>!");
							return false;
						}
						return true;
					}
				}
				return false;
			}
			
			function isSelect(){
				if(selectCount() <= 0){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82484,user.getLanguage())%>");
					return false;
				}
				return true;
			}
			
			function selectCount(){
				var result = 0;
				var codeNames;
				if(opt == "transfer"){
					codeNames = [
						"T101Num","T111Num","T112Num","T113Num","T121Num","T122Num","T123Num","T124Num","T125Num","T131Num",
						"T132Num","T133Num","T134Num","T141Num","T142Num","T143Num","T144Num","T145Num","T146Num","T147Num",
						"T148Num","T149Num","T151Num","T152Num","T161Num","T171Num","T181Num","T182Num","T183Num","T191Num",
						"T201Num","T202Num","T203Num","T204Num","T211Num","T221Num","T222Num","T223Num","T224Num","T225Num",
						"T226Num","T231Num","T232Num","T241Num","T301Num","T302Num","T303Num","T311Num","T321Num","T322Num",
						"T323Num","T324Num","T325Num","T326Num","T331Num","T332Num","T341Num","T401Num","T411Num","T412Num",
						"T413Num","T414Num","T415Num","T416Num","T421Num","T422Num","T431Num","T501Num","T511Num","T521Num",
						"T522Num","T523Num","T524Num","T525Num","T531Num","T532Num","T541Num","Temail001Num","Temail002Num"
					];
				} else if(opt == "copy"){
					codeNames = [
						"C101Num","C111Num","C112Num","C121Num","C122Num","C123Num","C131Num","C132Num","C133Num","C141Num",
						"C142Num","C143Num","C144Num","C145Num","C146Num","C147Num","C148Num","C151Num","C161Num","C171Num",
						"C172Num","C173Num","C181Num","C201Num","C202Num","C211Num","C221Num","C231Num","C241Num","C242Num",
						"C243Num","C244Num","C245Num","C246Num","C247Num","C251Num","C252Num","C261Num","C301Num","C302Num",
						"C303Num","C311Num","C321Num","C331Num","C341Num","C342Num","C343Num","C344Num","C345Num","C346Num",
						"C347Num","C351Num","C352Num","C361Num","C401Num","C411Num","C421Num","C431Num","C432Num","C433Num",
						"C434Num","C435Num","C436Num","C437Num","C441Num","C442Num","C451Num","C501Num","C511Num","C521Num",
						"C531Num","C532Num","C533Num","C534Num","C535Num","C536Num","C541Num","C542Num","C551Num"
					];
				} else if(opt == "delete"){
					codeNames = [
						"D101Num","D102Num","D103Num","D104Num","D105Num","D111Num","D112Num","D113Num","D121Num","D122Num",
						"D123Num","D124Num","D125Num","D126Num","D127Num","D128Num","D131Num","D141Num","D151Num","D152Num",
						"D153Num","D161Num","D171Num","D181Num","D201Num","D211Num","D212Num","D221Num","D222Num","D223Num",
						"D224Num","D225Num","D226Num","D227Num","D231Num","D232Num","D241Num","D251Num","D261Num","D301Num",
						"D311Num","D312Num","D321Num","D322Num","D323Num","D324Num","D325Num","D326Num","D327Num","D331Num",
						"D332Num","D341Num","D351Num","D361Num","D401Num","D402Num","D411Num","D412Num","D413Num","D414Num",
						"D415Num","D416Num","D417Num","D421Num","D422Num","D431Num","D441Num","D451Num","D501Num","D511Num",
						"D521Num","D522Num","D531Num","D532Num","D533Num","D534Num","D535Num","D536Num","D541Num","D542Num",
						"D551Num"
					];
				}
				if(codeNames){
					try{
						var numStr;
						for(var i=0;i<codeNames.length;i++){
							if($GetEle(codeNames[i]) && $GetEle(codeNames[i]).innerHTML != 0){
								numStr = $GetEle(codeNames[i]).innerHTML;
								numStr = numStr.toLowerCase();
								numStr = numStr.substring(numStr.indexOf(">")+1,numStr.indexOf("</span>"));
								result = Number(result) + Number(numStr);
							}
						}
					}catch(e){
						result = 0;
					}
				}
				return result;
			}
			
			function transferJob(){//岗位与部门脱离
				return;
				var isChecked = document.getElementsByName("T202All").checked;
				if(isChecked || ($GetEle("T202Num") && $GetEle("T202Num").innerHTML != 0)) {
					var result = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=getTransferData&fromid="+$GetEle("fromid").value+"&id=T203&isAll="+(isChecked?1:0)+"&idStr="+$GetEle("T202IdStr").value+"&key=T202IdStr&jsonSql="+$GetEle("jsonSql").value));
					if(result > 0){
						var _result = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=jsonRemove&id=T203IdStr&jsonSql="+$GetEle("jsonSql").value));
						$GetEle("jsonSql").value = _result;
						$GetEle("submitJson").value = _result;
						$GetEle("init_T203AllNum").innerHTML = result;
						$GetEle("T203AllNum").value = result;
						$GetEle("T203Num").innerHTML = "0";
						$GetEle("T203IdStr").value = "";
						$GetEle("T203All").checked = false;
						showEle("T203");
					} else{
						hideEle("T203");
					}
				} else {
					hideEle("T203");
				}
			}
			
			function copyJob(){
				var isChecked = document.getElementsByName("C301All").checked;
				if(isChecked || ($GetEle("C301Num") && $GetEle("C301Num").innerHTML != 0)) {
					var result = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=getTransferData&fromid="+$GetEle("fromid").value+"&id=C302&isAll="+(isChecked?1:0)+"&idStr="+$GetEle("C301IdStr").value+"&key=C301IdStr&jsonSql="+$GetEle("jsonSql").value));
					if(result > 0){
						var _result = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=jsonRemove&id=C302IdStr&jsonSql="+$GetEle("jsonSql").value));
						$GetEle("jsonSql").value = _result;
						$GetEle("submitJson").value = _result;
						$GetEle("init_C302AllNum").innerHTML = result;
						$GetEle("C302AllNum").value = result;
						$GetEle("C302Num").innerHTML = "0";
						$GetEle("C302IdStr").value = "";
						$GetEle("C302All").checked = false;
						showEle("C302");
					} else{
						hideEle("C302");
					}
				} else {
					hideEle("C302");
				}
			}
			
			function submitData() {
				opt = $GetEle("authorityTag").value;
				var message = "";
				if(opt == "copy"){
					message = "<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%>";
				} else if(opt == "delete"){
					message = "<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>";
				} else {
					message = "<%=SystemEnv.getHtmlLabelName(80,user.getLanguage())%>";
				}
				var topDisabled = $GetEle("startExecute").disabled;
				var isLock = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=checkFromid&id="+$GetEle("fromid").value));
				if(isLock == "1"){
					window.top.Dialog.alert("<%=fromname+SystemEnv.getHtmlLabelNames("18946,563,25666",user.getLanguage())%>");
					return;
				}
				if(check_same() && isSelect() && !topDisabled){
					window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(28296,user.getLanguage())%>"+message+"？",function(){
						$GetEle("startExecute").disabled = true;
						$GetEle("frmmain").submit();
					});
				}
			}
			
			function openWindow(url, title, allNum, numSpan, inputAll, idStr){
				if(!url||url==""){
					return;
				}
				if(idStr == "T203IdStr"){
					allNum = $GetEle("init_T203AllNum").innerHTML;
				} else if(idStr == "C302IdStr"){
					allNum = $GetEle("init_C302AllNum").innerHTML;
				}
				var isAll = $GetEle(inputAll).checked;
				if(allNum!=0){
					url += url.indexOf("?") == -1 ? "?" : "&";
					url += "fromid="+$GetEle("fromid").value+"&toid="+$GetEle("toid").value+"&type="+idStr+"&idStr="+$GetEle(idStr).value+"&isAll="+isAll;
					url += encodeURI("&jsonSql="+$GetEle("jsonSql").value);
					if(idStr == "T203IdStr"){
						url += "&T202IdStr="+$GetEle("T202IdStr").value;
						url += "&T202All="+(document.getElementsByName("T202All").checked?1:0);
					} else if(idStr == "C302IdStr"){
						url += "&C301IdStr="+$GetEle("C301IdStr").value;
						url += "&C301All="+(document.getElementsByName("C301All").checked?1:0);
					}
					doOpen(url, title, null, null, checkboxSelect, allNum, numSpan, inputAll, idStr);
				}
			}
			
			function doOpen(url, title, _dWidth, _dHeight, _callBack, allNum, numSpan, inputAll, idStr){
				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : 700;
				dialog.Height = _dHeight ? _dHeight : 500;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.callback = function(data) {
					try {
						$GetEle("jsonSql").value = data.json;
						$GetEle("submitJson").value = data.json;
						if (data.isAll) {
							_callBack(true, '', data.count, allNum, numSpan, inputAll, idStr);
						} else {
							_callBack(false, data.id.length == 0 ? '' : data.id.split(','), 0 , allNum, numSpan, inputAll, idStr);
						}
					} catch(ex) {}
				}
				dialog.show();
			}
			
			function checkboxSelect(isAll, ids, count, allNum, numSpan, inputAll, idStr) {
				if (!isAll && ids) {
					count = ids.length;
				}
				if(idStr == "T203IdStr"){
					allNum = $GetEle("init_T203AllNum").innerHTML;
				} else if(idStr == "C302IdStr"){
					allNum = $GetEle("init_C302AllNum").innerHTML;
				}
				if (count && count >= allNum) {
					$GetEle(numSpan).innerHTML = allNum > 0 ? ("<span style='color:#1E90FF'>"+allNum+"</span>") : allNum;
					$GetEle(idStr).value = ids;
					$GetEle(inputAll).checked = true;
				} else if (count && count <= allNum && count > 0) {
					$GetEle(numSpan).innerHTML = "<span style='color:#1E90FF'>" + count + "</span>";
					$GetEle(idStr).value = ids;
					$GetEle(inputAll).checked = false;
				} else if ($GetEle(inputAll).checked == true) {
					$GetEle(numSpan).innerHTML = allNum > 0 ? ("<span style='color:#1E90FF'>"+allNum+"</span>") : allNum;
				} else {
					var result = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=jsonRemove&id="+idStr+"&jsonSql="+$GetEle("jsonSql").value));
					$GetEle("jsonSql").value = result;
					$GetEle("submitJson").value = result;
					$GetEle(numSpan).innerHTML = "0";
					$GetEle(idStr).value = "";
				}
				if(idStr == "T202IdStr"){
					transferJob();
				} else if(idStr == "C301IdStr"){
					copyJob();
				}
				$("#count").html(selectCount());
			}
			
			var refresh_num = "<%=isFinished ? StringUtil.random(10,55) : StringUtil.random(10,25)%>";
			function doRefresh(){
				if(refresh_num == -99){
					$GetEle('refreshDiv').style.display = "none";
					return;
				} else if(refresh_num == 0){
					doChange(opt);
					return;
				} else if(refresh_num == 10){
					$GetEle('refreshDiv').style.display = "block";
				}
				$GetEle('refresh_num').innerHTML = refresh_num--;
				setTimeout("doRefresh()",1000);
			}
			
			function stopRefresh(){
				refresh_num = -99;
			}
			
			function showData(){
				document.all("contentDiv").style.display = "block";
				var ajax = ajaxinit();
				ajax.open("POST", "HrmRightAuthorityData.jsp", true);
				ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				ajax.send("fromid="+$GetEle("fromid").value+"&toid="+$GetEle("toid").value+"&transferType="+$GetEle("transferType").value+"&authorityTag="+$GetEle("authorityTag").value+"&jsonSql=&submitJson=&needExecuteSql=0&zsESQL=0");
				ajax.onreadystatechange = function() {
					if (ajax.readyState == 4 && ajax.status == 200) {
						try{
							document.all("contentDiv").innerHTML = ajax.responseText;
							if(opt == "transfer"){
								transferJob();
							} else if(opt == "copy"){
								copyJob();
							}
							disableMonButton();
						}catch(e){
							return false;
						}
					}
				}
			}
			
			function disableMonButton(){
				//流程监控转移和复制时不可以选择只能全部转移和复制
				if(opt=== 'transfer'){
					jQuery("input[name='T132All']").parent().parent().find('button').attr('disabled',true);
				}
				if(opt === 'delete'){
					jQuery("input[name='D112All']").parent().parent().find('button').attr('disabled',true);
				}
			}
			
			jQuery(document).ready(function(){
				if(isShowMessage == "true"){
					doRefresh();
				} else if("<%=String.valueOf(fromid.length() > 0)%>" == "true"){
					showData();
				}
				if(isFinished == "true"){
					$("#updatecount").html("<%=countValue%>");
				}
				disableMonButton();
			});
			
			
		</script>
	</body>
</html>
