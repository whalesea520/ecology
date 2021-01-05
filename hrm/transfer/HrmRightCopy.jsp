
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- added by wcd 2014-09-18 [权限复制] -->
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
	if(!HrmUserVarify.checkUserRight("HrmRrightCopy:copy", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	Map cMap = new HashMap();
	cMap.put("pMember", user.getUID());
	cMap.put("pStatus", "0");
	cMap.put("pType", "1");
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
	String titlename =SystemEnv.getHtmlLabelName(34031,user.getLanguage());
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
	
	HrmRightTransferManager transferManager = new HrmRightTransferManager("copy", mjson, request).loadData();
	HrmRightCopy bean = (HrmRightCopy)transferManager.getBean();
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
				$GetEle("frmmain").action="HrmRightCopy.jsp?cmd="+cmd+"&fromid="+fromid+"&toid="+toid;
				$GetEle("frmmain").submit();
			}
			
			function clearAll(){
				var codeNames = [
					"C101","C111","C112","C121","C122","C123","C131","C132","C133","C141",
					"C142","C143","C144","C145","C146","C147","C148","C151","C161","C171",
					"C172","C173","C181","C201","C202","C211","C221","C231","C241","C242",
					"C243","C244","C245","C246","C247","C251","C252","C261","C301","C302",
					"C303","C311","C321","C331","C341","C342","C343","C344","C345","C346",
					"C347","C351","C352","C361","C401","C411","C421","C431","C432","C433",
					"C434","C435","C436","C437","C441","C442","C451","C501","C511","C521",
					"C531","C532","C533","C534","C535","C536","C541","C542","C551"
				];
				for(var i=0;i<codeNames.length;i++){
					clear(codeNames[i]);
				}
			}
			
			function clear(id){
				if($GetEle(id+"Num")){
					$GetEle(id+"IdStr").value = "";
					$GetEle(id+"Num").innerHTML = "0";
					if(id == "C302"){
						$GetEle("init_C302AllNum").innerHTML = "0";
					}
					changeCheckboxStatus($GetEle(id+"All"),false);
				}
			}
			
			function doProcFrom(event,data,name){
				var isLock = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=checkFromid&id="+data.id));;
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
			<input class=inputstyle type=hidden name="authorityTag" value="copy">
			<input class=inputstyle type=hidden name="needExecuteSql" value="0">
			<input class=inputstyle type=hidden name="zsESQL" value="0">
			<%out.println(transferManager.getFormInput());%>
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("33508,77,106",user.getLanguage())%>'>
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
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
								hasInput='<%=isShowMessage ? "false" : "true"%>' isSingle="true" hasBrowser = "true" isMustInput='<%=isShowMessage ? "0" : "2"%>'
								completeUrl="/data.jsp" width="70%" browserSpanValue='<%=toname%>' _callback="doProcTo" afterDelCallback = "delToCall">
							</brow:browser>
						</span>
						<span id="showtodepartment" style="display:<%=transferType.equals("department")?"block":"none"%>">
							<brow:browser viewType="0" name="toid_department" browserValue='<%=toid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
								hasInput='<%=isShowMessage ? "false" : "true"%>' isSingle="true" hasBrowser = "true" isMustInput='<%=isShowMessage ? "0" : "2"%>'
								completeUrl="/data.jsp?type=4" width="70%" browserSpanValue='<%=toname%>' _callback="doProcTo" afterDelCallback = "delToCall">
							</brow:browser>
						</span>
						<span id="showtosubcompany" style="display:<%=transferType.equals("subcompany")?"block":"none"%>">
							<brow:browser viewType="0" name="toid_subcompany" browserValue='<%=toid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
								hasInput='<%=isShowMessage ? "false" : "true"%>' isSingle="true" hasBrowser = "true" isMustInput='<%=isShowMessage ? "0" : "2"%>'
								completeUrl="/data.jsp?type=164" width="70%" browserSpanValue='<%=toname%>' _callback="doProcTo" afterDelCallback = "delToCall">
							</brow:browser>
						</span>
						<span id="showtorole" style="display:<%=transferType.equals("role")?"block":"none"%>">
							<brow:browser viewType="0" name="toid_role" browserValue='<%=toid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp?selectids="
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
					out.println(SystemEnv.getHtmlLabelName(83838,user.getLanguage())+Tools.getDateTime(tLog.getPBeginDate())+" "+SystemEnv.getHtmlLabelName(83901,user.getLanguage())+(isFinished ? (SystemEnv.getHtmlLabelName(83903,user.getLanguage())+" "+Tools.getDateTime(tLog.getPFinishDate())+" "+SystemEnv.getHtmlLabelName(83904,user.getLanguage())+Tools.formatTimes(tLog.getPTime(),true)+"。") : (isP?SystemEnv.getHtmlLabelName(83907,user.getLanguage()):SystemEnv.getHtmlLabelName(83908,user.getLanguage())))+(isP||isFinished?"":(Tools.replace(SystemEnv.getHtmlLabelName(34054,user.getLanguage()),"{param}"," "+fromname+" ")+" "+toname+" "+SystemEnv.getHtmlLabelName(83910 ,user.getLanguage()))));
					if(isFinished){
						out.println(Tools.replace(SystemEnv.getHtmlLabelName(34054,user.getLanguage()),"{param}"," <span style='color:#1E90FF'>"+fromname+"</span> ")+" <span style='color:#1E90FF'>"+toname+"</span> "+SystemEnv.getHtmlLabelName(83910,user.getLanguage()));
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
									labelId = HrmTransferSetManager.getCopyLabelId(logDetail.getCodeName());
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
									labelId = HrmTransferSetManager.getCopyLabelId(key);
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
					<%out.println(isFinished ? (tLog.getPStatus() == 2 ? ""+SystemEnv.getHtmlLabelName(83912,user.getLanguage()) : (Tools.replace(SystemEnv.getHtmlLabelName(34033,user.getLanguage()),"{param}"," <span style='color:#1E90FF'>"+countValue+"</span> ")+"！")) : (SystemEnv.getHtmlLabelName(83914,user.getLanguage())+" <span style='color:#1E90FF'>"+countValue+"</span> "+SystemEnv.getHtmlLabelName(83916,user.getLanguage())));%>
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
					"C101Num","C111Num","C112Num","C121Num","C122Num","C123Num","C131Num","C132Num","C133Num","C141Num",
					"C142Num","C143Num","C144Num","C145Num","C146Num","C147Num","C148Num","C151Num","C161Num","C171Num",
					"C172Num","C173Num","C181Num","C201Num","C202Num","C211Num","C221Num","C231Num","C241Num","C242Num",
					"C243Num","C244Num","C245Num","C246Num","C247Num","C251Num","C252Num","C261Num","C301Num","C302Num",
					"C303Num","C311Num","C321Num","C331Num","C341Num","C342Num","C343Num","C344Num","C345Num","C346Num",
					"C347Num","C351Num","C352Num","C361Num","C401Num","C411Num","C421Num","C431Num","C432Num","C433Num",
					"C434Num","C435Num","C436Num","C437Num","C441Num","C442Num","C451Num","C501Num","C511Num","C521Num",
					"C531Num","C532Num","C533Num","C534Num","C535Num","C536Num","C541Num","C542Num","C551Num"
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
				var isChecked = document.getElementsByName("C301All").checked;
				if(isChecked || ($GetEle("C301Num") && $GetEle("C301Num").innerHTML != 0)) {
					var result = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=getTransferData&fromid=<%=fromid%>&id=C302&isAll="+(isChecked?1:0)+"&idStr="+$GetEle("C301IdStr").value+"&key=C301IdStr&jsonSql="+$GetEle("jsonSql").value));
					if(result > 0){
						var _result = ajaxSubmit(encodeURI("/js/hrm/getdata.jsp?cmd=jsonRemove&id=C302IdStr&jsonSql="+$GetEle("jsonSql").value));
						$GetEle("jsonSql").value = _result;
						$GetEle("submitJson").value = _result;
						$GetEle("init_C302AllNum").innerHTML = result;
						$GetEle("C302AllNum").value = result;
						$GetEle("C302Num").innerHTML = "0";
						$GetEle("C302IdStr").value = "";
						changeCheckboxStatus($GetEle("C302All"),false);
						showEle("C302");
					} else{
						hideEle("C302");
					}
				} else {
					hideEle("C302");
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
					window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("28296,77",user.getLanguage())+"？"%>",function(){
						$GetEle("e8_btn_top").disabled = true;
						$GetEle("frmmain").submit();
					});
				}
			}
			
			function openWindow(url, title, allNum, numSpan, inputAll, idStr){
				if(!url||url==""){
					return;
				}
				if(idStr == "C302IdStr"){
					allNum = $GetEle("init_C302AllNum").innerHTML;
				}
				if(!$GetEle(inputAll).checked&&allNum!=0){
					url += url.indexOf("?") == -1 ? "?" : "&";
					url += "fromid=<%=fromid%>&toid=<%=toid%>&type="+idStr+"&idStr="+$GetEle(idStr).value;
					url += encodeURI("&jsonSql="+$GetEle("jsonSql").value);
					if(idStr == "C302IdStr"){
						url += "&C301IdStr="+$GetEle("C301IdStr").value;
						url += "&C301All="+(document.getElementsByName("C301All").checked?1:0);
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
							_callBack(false, data.id.split(','), 0 , allNum, numSpan, inputAll, idStr);
						}
					} catch(ex) {}
				}
				dialog.show();
			}
			
			function checkboxSelect(isAll, ids, count, allNum, numSpan, inputAll, idStr) {
				if (!isAll && ids) {
					count = ids.length;
				}
				if(idStr == "C302IdStr"){
					allNum = $GetEle("init_C302AllNum").innerHTML;
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
				if(idStr == "C301IdStr"){
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
				} else if(refresh_num == 9){
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
				ajax.send("fromid=<%=fromid%>&toid=<%=toid%>&transferType=<%=transferType%>&authorityTag=copy&jsonSql=<%=Tools.getURLEncode(oldJson)%>&submitJson=<%=Tools.getURLEncode(bean.getSubmitJson().toString())%>&needExecuteSql=0&zsESQL=0");
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
