
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-06-25 [E7 to E8] -->
<%@page import="weaver.hrm.authority.domain.*,weaver.hrm.authority.manager.*"%>
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="HrmTransferSetManager" class="weaver.hrm.authority.manager.HrmTransferSetManager" scope="page" />
<jsp:useBean id="HrmTransferLogManager" class="weaver.hrm.authority.manager.HrmTransferLogManager" scope="page" />
<jsp:useBean id="HrmTransferLogDetailManager" class="weaver.hrm.authority.manager.HrmTransferLogDetailManager" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmRrightTransfer:Tran", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	Map cMap = new HashMap();
	cMap.put("pMember", user.getUID());
	cMap.put("pStatus", "0");
	cMap.put("pType", "0");
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
	String _type = Util.null2String(request.getParameter("type"));
	String numberstr=Tools.getURLDecode(request.getParameter("numberstr"));
	/*if(Tools.isNotNull(numberstr)){
		numberstr = Tools.replace(numberstr,"\"","\\\\\"");
	}*/
	String fromid=Util.null2String(request.getParameter("fromid"));
	if(fromid.length()==0)fromid=Util.null2String(request.getParameter("resourceid"));
	String toid=Util.null2String(request.getParameter("toid"));
	String transferType = Util.null2String(request.getParameter("transferType"),"resource");
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
			}
		}
		if(toname.endsWith(",")) {
			toname = toname.substring(0,toname.length()-1);
		}
	}

	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
	String isDelType = Util.null2String(request.getParameter("isDelType"));
	String needExecuteSql = Util.null2String(request.getParameter("needExecuteSql"));
	String selectAllSql = Tools.getURLDecode(request.getParameter("selectAllSql"));
	MJson mjson = new MJson(jsonSql,true);
	if(isDelType.equals("1")) mjson.removeArrayValue(_type);
	if(needExecuteSql.equals("1")){
		if(mjson.exsit(_type)) {
			mjson.updateArrayValue(_type,selectAllSql);
		} else {
			mjson.putArrayValue(_type,selectAllSql);
		}
	}
	String oldJson = jsonSql = mjson.toString();
	jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");
	
	HrmRightTransferManager transferManager = new HrmRightTransferManager("transfer", mjson, request).loadData();
	HrmRightTransfer bean = (HrmRightTransfer)transferManager.getBean();
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			var dialog = null;
			var dWidth = 700;
			var dHeight = 500;
			
			function onBtnSearchClick(){
				jQuery("#frmmain").submit();
			}
			
			function setFromValue(fromid, toid, cmd){
				clearAll();
				$GetEle("frmmain").action="HrmRightTransfer.jsp?cmd="+cmd+"&fromid="+fromid+"&toid="+toid;
				$GetEle("frmmain").submit();
			}
			
			function clearAll(){
				var codeNames = [
					"T101","T111","T112","T113","T121","T122","T123","T124","T125","T131",
					"T132","T133","T134","T141","T142","T143","T144","T145","T146","T147",
					"T148","T149","T151","T152","T161","T171","T181","T182","T183","T191",
					"T201","T202","T203","T204","T211","T221","T222","T223","T224","T225",
					"T226","T231","T232","T241","T301","T302","T303","T311","T321","T322",
					"T323","T324","T325","T326","T331","T332","T341","T401","T411","T412",
					"T413","T414","T415","T416","T421","T422","T431","T501","T511","T521",
					"T522","T523","T524","T525","T531","T532","T541","Temail001","Temail002"
				];
				for(var i=0;i<codeNames.length;i++){
					clear(codeNames[i]);
				}
			}
			
			function clear(id){
				if($GetEle(id+"Num")){
					$GetEle(id+"IdStr").value = "";
					$GetEle(id+"Num").innerHTML = "0";
					if(id == "T203"){
						$GetEle("init_T203AllNum").innerHTML = "0";
					}
					changeCheckboxStatus($GetEle(id+"All"),false);
				}
			}
			
			function doProcFrom(event,data,name){
				var isLock = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=checkFromid&id="+data.id));
				if(isLock == "1"){
					window.top.Dialog.alert(data.name+"<%=SystemEnv.getHtmlLabelNames("18946,563,25666",user.getLanguage())%>");
					return;
				}else {
					setFromValue(data.id,"<%=toid%>","showContent");
				}
			}
			
			function doProcTo(event,data,name){
				$GetEle("toid").value = data.id;
			}
			
			function delFromCall(text,fieldid,params){
				$GetEle("fromid").value = '';
				setFromValue('',$GetEle("toid").value,'');
			}
			
			function delToCall(text,fieldid,params){
				$GetEle("toid").value = '';
			}
			
			function changeObject(type){
				var types = ["resource","department","subcompany","role"];
				for(var i=0; i<types.length; i++){
					if(types[i] == type){
						$GetEle("showfrom"+type).style.display = "block";
						$GetEle("showto"+type).style.display = "block";
					} else {
						$GetEle("showfrom"+type).style.display = "none";
						$GetEle("showto"+type).style.display = "none";
					}
				}
				$GetEle("fromid").value = "";
				$GetEle("toid").value = "";
				setFromValue("", "", "");
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
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(!isShowMessage){%>
					<input type=button class="e8_btn_top" id="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelNames("530,1338",user.getLanguage())%>"></input>
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id=frmmain name=frmmain method=post action="HrmRightTransferOperation.jsp" >
			<input class=inputstyle type=hidden name="fromid" value="<%=fromid%>">
			<input class=inputstyle type=hidden name="toid" value="<%=toid%>">
			<input class=inputstyle type=hidden name="jsonSql" value="<%=Tools.getURLEncode(oldJson)%>">
			<input class=inputstyle type=hidden name="submitJson" value="<%=Tools.getURLEncode(bean.getSubmitJson().toString())%>">
			<input class=inputstyle type=hidden name="authorityTag" value="transfer">
			<input class=inputstyle type=hidden name="needExecuteSql" value="0">
			<input class=inputstyle type=hidden name="zsESQL" value="0">
			<%out.println(transferManager.getFormInput());%>
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("33508,80,106",user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%></wea:item>
					<wea:item>
						<table style="width:100%"><tr>
						<td style="width:25%">
							<SELECT style="width:80%" name="transferType" onchange="changeObject(this.value)" <%=isShowMessage ? "disabled" : ""%>>
								<option value="resource" <%=transferType.equals("resource")?"selected":""%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
								<option value="department" <%=transferType.equals("department")?"selected":""%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
								<option value="subcompany" <%=transferType.equals("subcompany")?"selected":""%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
								<option value="role" <%=transferType.equals("role")?"selected":""%>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
							</SELECT>
						</td>
						<td style="width:70%">
							<span id="showfromresource" style="display:<%=transferType.equals("resource")?"block":"none"%>">
								<brow:browser viewType="0" name="fromid_resource" browserValue='<%=fromid%>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids="
									hasInput='<%=isShowMessage ? "false" : "true"%>' isSingle="true" hasBrowser = "true" isMustInput='<%=isShowMessage ? "0" : "2"%>'
									completeUrl="/data.jsp" width="70%" browserSpanValue='<%=fromname%>' _callback="doProcFrom" afterDelCallback = "delFromCall">
								</brow:browser>
							</span>
							<span id="showfromdepartment" style="display:<%=transferType.equals("department")?"block":"none"%>">
								<brow:browser viewType="0" name="fromid_department" browserValue='<%=fromid%>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
									hasInput='<%=isShowMessage ? "false" : "true"%>' isSingle="true" hasBrowser = "true" isMustInput='<%=isShowMessage ? "0" : "2"%>'
									completeUrl="/data.jsp?type=4" width="70%" browserSpanValue='<%=fromname%>' _callback="doProcFrom" afterDelCallback = "delFromCall">
								</brow:browser>
							</span>
							<span id="showfromsubcompany" style="display:<%=transferType.equals("subcompany")?"block":"none"%>">
								<brow:browser viewType="0" name="fromid_subcompany" browserValue='<%=fromid%>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
									hasInput='<%=isShowMessage ? "false" : "true"%>' isSingle="true" hasBrowser = "true" isMustInput='<%=isShowMessage ? "0" : "2"%>'
									completeUrl="/data.jsp?type=164" width="70%" browserSpanValue='<%=fromname%>' _callback="doProcFrom" afterDelCallback = "delFromCall">
								</brow:browser>
							</span>
							<span id="showfromrole" style="display:<%=transferType.equals("role")?"block":"none"%>">
								<brow:browser viewType="0" name="fromid_role" browserValue='<%=fromid%>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectids="
									hasInput='<%=isShowMessage ? "false" : "true"%>' isSingle="true" hasBrowser = "true" isMustInput='<%=isShowMessage ? "0" : "2"%>'
									completeUrl="/data.jsp?type=65" width="70%" browserSpanValue='<%=fromname%>' _callback="doProcFrom" afterDelCallback = "delFromCall">
								</brow:browser>
							</span>
						</td>
						</tr></table>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%></wea:item>
					<wea:item>
						<span id="showtoresource" style="display:<%=transferType.equals("resource")?"block":"none"%>">
							<brow:browser viewType="0" name="toid_resource" browserValue='<%=toid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids="
								hasInput='<%=isShowMessage ? "false" : "true"%>' isSingle="true" hasBrowser = "true" isMustInput='<%=isShowMessage ? "0" : "2"%>'
								completeUrl="/data.jsp" width="70%" browserSpanValue='<%=toname%>' _callback="doProcTo" afterDelCallback = "delToCall">
							</brow:browser>
						</span>
						<span id="showtodepartment" style="display:<%=transferType.equals("department")?"block":"none"%>">
							<brow:browser viewType="0" name="toid_department" browserValue='<%=toid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
								hasInput='<%=isShowMessage ? "false" : "true"%>' isSingle="true" hasBrowser = "true" isMustInput='<%=isShowMessage ? "0" : "2"%>'
								completeUrl="/data.jsp?type=4" width="70%" browserSpanValue='<%=toname%>' _callback="doProcTo" afterDelCallback = "delToCall">
							</brow:browser>
						</span>
						<span id="showtosubcompany" style="display:<%=transferType.equals("subcompany")?"block":"none"%>">
							<brow:browser viewType="0" name="toid_subcompany" browserValue='<%=toid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
								hasInput='<%=isShowMessage ? "false" : "true"%>' isSingle="true" hasBrowser = "true" isMustInput='<%=isShowMessage ? "0" : "2"%>'
								completeUrl="/data.jsp?type=164" width="70%" browserSpanValue='<%=toname%>' _callback="doProcTo" afterDelCallback = "delToCall">
							</brow:browser>
						</span>
						<span id="showtorole" style="display:<%=transferType.equals("role")?"block":"none"%>">
							<brow:browser viewType="0" name="toid_role" browserValue='<%=toid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectids="
								hasInput='<%=isShowMessage ? "false" : "true"%>' isSingle="true" hasBrowser = "true" isMustInput='<%=isShowMessage ? "0" : "2"%>'
								completeUrl="/data.jsp?type=65" width="70%" browserSpanValue='<%=toname%>' _callback="doProcTo" afterDelCallback = "delToCall">
							</brow:browser>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>
			<%
				if(isShowMessage) {
			%>
			<div id="messageDiv" style="margin:0 auto;width:400px;height:300px;padding-top:10px;">
				<span id="refresh_span" style="display:none"><%=SystemEnv.getHtmlLabelName(83893,user.getLanguage())%> <strong id="refresh_num"></strong> <%=SystemEnv.getHtmlLabelName(83896,user.getLanguage())%>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="stopRefresh()"><font color="#1E90FF"><%=SystemEnv.getHtmlLabelName(83899,user.getLanguage())%></font></a></span>
				<%
					boolean isP = numberstr.length () == 0;
				out.println(SystemEnv.getHtmlLabelName(83838,user.getLanguage())+Tools.getDateTime(tLog.getPBeginDate())+" "+SystemEnv.getHtmlLabelName(83901,user.getLanguage())+(isFinished ? (SystemEnv.getHtmlLabelName(83903,user.getLanguage())+" "+Tools.getDateTime(tLog.getPFinishDate())+" "+SystemEnv.getHtmlLabelName(83904,user.getLanguage())+Tools.formatTimes(tLog.getPTime(),true)+"。") : (isP?SystemEnv.getHtmlLabelName(83907,user.getLanguage()):SystemEnv.getHtmlLabelName(83908,user.getLanguage())))+(isP||isFinished?"":(Tools.replace(SystemEnv.getHtmlLabelName(33380,user.getLanguage()),"{param}"," "+fromname+" ")+" "+toname+" "+SystemEnv.getHtmlLabelName(83910 ,user.getLanguage()))));
					if(isFinished){
						out.println(Tools.replace(SystemEnv.getHtmlLabelName(33380,user.getLanguage()),"{param}"," <span style='color:#1E90FF'>"+fromname+"</span> ")+" <span style='color:#1E90FF'>"+toname+"</span> "+SystemEnv.getHtmlLabelName(83910,user.getLanguage()));
					}
				%>
				<table style="margin:auto;padding-top:10px;">
					<%
						int countValue = 0;
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
									labelId = HrmTransferSetManager.getTransferLabelId(logDetail.getCodeName());
								%>
									<tr>
										<td width="80%"><%=SystemEnv.getHtmlLabelNames(labelId,user.getLanguage())%>:</td>
										<td width="20%"><span style='color:#1E90FF'><%=value%></span>&nbsp;<%=SystemEnv.getHtmlLabelName(33367,user.getLanguage())%></td>
									</tr>
								<%
								}
							}
						} else {
							if(isP){
								countValue = tLog.getAllNum();
							}else {
								mjson = new MJson(numberstr,true);
								while(mjson.next()){
									key = mjson.getKey();
									value = Tools.parseToInt(mjson.getValue());
									if(value <= 0){
										continue;
									}
									countValue += value;
									labelId = HrmTransferSetManager.getTransferLabelId(key);
								%>
									<tr>
										<td width="80%"><%=SystemEnv.getHtmlLabelNames(labelId,user.getLanguage())%>:</td>
										<td width="20%"><span style='color:#1E90FF'><%=value%></span>&nbsp;<%=SystemEnv.getHtmlLabelName(33367,user.getLanguage())%></td>
									</tr>
								<%
								}
							}
						}
					%>
				</table>
				<div style="padding-top:10px">
					<%out.println(isFinished ? (tLog.getPStatus() == 2 ? ""+SystemEnv.getHtmlLabelName(83912,user.getLanguage()) : (Tools.replace(SystemEnv.getHtmlLabelName(33379,user.getLanguage()),"{param}"," <span style='color:#1E90FF'>"+countValue+"</span> ")+"！")) : (""+SystemEnv.getHtmlLabelName(83930,user.getLanguage())+" <span style='color:#1E90FF'>"+countValue+"</span> "+SystemEnv.getHtmlLabelName(83916,user.getLanguage())));%>
				</div>
			</div>
			<%
				}
			%>
			<div id="contentDiv" style="<%=(cmd.equals("showContent") || (fromid.length() > 0 && !isShowMessage)) ? "" : "display:none"%>">
				<table id="scrollarea" name="scrollarea" width="100%" height="100%" style="zIndex:-1" >
					<tr>
						<td align="center" valign="center">
							<fieldset style="width:30%;margin-top: 30px;"><img src="/images/loading2_wev8.gif" align="top"><%=SystemEnv.getHtmlLabelName(20204,user.getLanguage())%></fieldset>
						</td>
					</tr>
				</table>
			</div>
		</form>
		<script type="text/javascript">
			function check_same(){
				if(check_form($GetEle("frmmain"),'fromid,toid')){
					if($GetEle("fromid").value==$GetEle("toid").value){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("106,26250",user.getLanguage())%>!");
						return false;
					}
					return true;
				}
				return false;
			}
			
			function isSelect(){
				var result = false;
				var codeNames = [
					"T101Num","T111Num","T112Num","T113Num","T121Num","T122Num","T123Num","T124Num","T125Num","T131Num",
					"T132Num","T133Num","T134Num","T141Num","T142Num","T143Num","T144Num","T145Num","T146Num","T147Num",
					"T148Num","T149Num","T151Num","T152Num","T161Num","T171Num","T181Num","T182Num","T183Num","T191Num",
					"T201Num","T202Num","T203Num","T204Num","T211Num","T221Num","T222Num","T223Num","T224Num","T225Num",
					"T226Num","T231Num","T232Num","T241Num","T301Num","T302Num","T303Num","T311Num","T321Num","T322Num",
					"T323Num","T324Num","T325Num","T326Num","T331Num","T332Num","T341Num","T401Num","T411Num","T412Num",
					"T413Num","T414Num","T415Num","T416Num","T421Num","T422Num","T431Num","T501Num","T511Num","T521Num",
					"T522Num","T523Num","T524Num","T525Num","T531Num","T532Num","T541Num","Temail001Num","Temail002Num"
				];
				for(var i=0;i<codeNames.length;i++){
					if($GetEle(codeNames[i]) && $GetEle(codeNames[i]).innerHTML != 0){
						result = true;
						break;
					}
				}
				if(!result){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
				}
				return result;
			}
			
			function transferJob(){
				var isChecked = document.getElementsByName("T202All").checked;
				if(isChecked || ($GetEle("T202Num") && $GetEle("T202Num").innerHTML != 0)) {
					var result = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=getTransferData&fromid=<%=fromid%>&id=T203&isAll="+(isChecked?1:0)+"&idStr="+$GetEle("T202IdStr").value+"&key=T202IdStr&jsonSql="+$GetEle("jsonSql").value));
					if(result > 0){
						var _result = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=jsonRemove&id=T203IdStr&jsonSql="+$GetEle("jsonSql").value));
						$GetEle("jsonSql").value = _result;
						$GetEle("submitJson").value = _result;
						$GetEle("init_T203AllNum").innerHTML = result;
						$GetEle("T203AllNum").value = result;
						$GetEle("T203Num").innerHTML = "0";
						$GetEle("T203IdStr").value = "";
						changeCheckboxStatus($GetEle("T203All"),false);
						showEle("T203");
					} else{
						hideEle("T203");
					}
				} else {
					hideEle("T203");
				}
			}
			
			function submitData() {
				var topDisabled = $GetEle("e8_btn_top").disabled;
				var isLock = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=checkFromid&id=<%=fromid%>"));
				if(isLock == "1"){
					window.top.Dialog.alert("<%=fromname+SystemEnv.getHtmlLabelNames("18946,563,25666",user.getLanguage())%>");
					return;
				}
				if(check_same() && isSelect() && !topDisabled){
					window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("28296,80",user.getLanguage())+"？"%>",function(){
						$GetEle("e8_btn_top").disabled = true;
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
				}
				if(!$GetEle(inputAll).checked&&allNum!=0){
					url += url.indexOf("?") == -1 ? "?" : "&";
					url += "fromid=<%=fromid%>&toid=<%=toid%>&type="+idStr+"&idStr="+$GetEle(idStr).value;
					url += encodeURI("&jsonSql="+$GetEle("jsonSql").value);
					if(idStr == "T203IdStr"){
						url += "&T202IdStr="+$GetEle("T202IdStr").value;
						url += "&T202All="+(document.getElementsByName("T202All").checked?1:0);
					}
					doOpen(url, title, null, null, checkboxSelect, allNum, numSpan, inputAll, idStr);
				}
			}
			function doOpen(url, title, _dWidth, _dHeight, _callBack, allNum, numSpan, inputAll, idStr){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
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
				}
				if (count && count >= allNum) {
					if(allNum > 0){
						$GetEle(numSpan).innerHTML = "<span style='color:#1E90FF'>"+allNum+"</span>";
					}else{
						$GetEle(numSpan).innerHTML = allNum;
					}
					changeCheckboxStatus(jQuery("input[name=\'"+inputAll+"\']"), true);
				} else if ($GetEle(inputAll).checked == true) {
					if(allNum > 0){
						$GetEle(numSpan).innerHTML = "<span style='color:#1E90FF'>"+allNum+"</span>";
					}else{
						$GetEle(numSpan).innerHTML = allNum;
					}
				} else {
					if (count && count > 0) {
						$GetEle(numSpan).innerHTML = "<span style='color:#1E90FF'>" + count + "</span>";
						$GetEle(idStr).value = ids;
					} else {
						var result = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=jsonRemove&id="+idStr+"&jsonSql="+$GetEle("jsonSql").value));
						$GetEle("jsonSql").value = result;
						$GetEle("submitJson").value = result;
						$GetEle(numSpan).innerHTML = "0";
						$GetEle(idStr).value = "";
					}
				}
				if(idStr == "T202IdStr"){
					transferJob();
				}
			}
			
			var refresh_num = "<%=isFinished ? "60" : "30"%>";
			function doRefresh(){
				if(refresh_num == -99){
					$GetEle('refresh_span').style.display = "none";
					return;
				} else if(refresh_num == 0){
					setFromValue('', '', '');
					return;
				} else if(refresh_num == 10){
					$GetEle('refresh_span').style.display = "block";
				}
				$GetEle('refresh_num').innerHTML = refresh_num--;
				setTimeout("doRefresh()",1000);
			}
			
			function stopRefresh(){
				refresh_num = -99;
			}
			
			function showData(){
				var ajax = ajaxinit();
				ajax.open("POST", "HrmRightAuthorityData.jsp", true);
				ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				ajax.send("fromid=<%=fromid%>&toid=<%=toid%>&transferType=<%=transferType%>&authorityTag=transfer&jsonSql=<%=Tools.getURLEncode(oldJson)%>&submitJson=<%=Tools.getURLEncode(bean.getSubmitJson().toString())%>&needExecuteSql=0&zsESQL=0");
				ajax.onreadystatechange = function() {
					if (ajax.readyState == 4 && ajax.status == 200) {
						try{
							document.all("contentDiv").innerHTML=ajax.responseText;
							transferJob();
						}catch(e){
							return false;
						}
					}
				}
			}
			
			jQuery(document).ready(function(){
				if("<%=(cmd.equals("showContent") || (fromid.length() > 0 && !isShowMessage))%>" == "true"){
					showData();
				}
				if("<%=String.valueOf(isShowMessage)%>" == "true"){
					doRefresh();
				}
			});
		</script>
	</body>
</html>
