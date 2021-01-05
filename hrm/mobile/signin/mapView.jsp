<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- Added by wcd 2015-03-25 [移动签到-地图视图] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="resourceInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
 <%
	String imagefilename = "/images/hdHRM_wev8.gif", needfav ="1", needhelp ="";
	String titlename = SystemEnv.getHtmlLabelNames("31726,32559",user.getLanguage());
	String id = strUtil.vString(request.getParameter("id"));
	String uid = strUtil.vString(request.getParameter("uid"), String.valueOf(user.getUID()));
	String uName = resourceInfo.getLastname(uid);
	String thisDate = strUtil.vString(request.getParameter("thisDate"), dateUtil.getCurrentDate());
%>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
		<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
		<script type="text/javascript">
			var common = new MFCommon();
			var hasException = false;
			var btnBg = "btnNBg";
			var curId = "<%=user.getUID()%>";
			var curName = "<%=resourceInfo.getLastname(String.valueOf(user.getUID()))%>";
			
			function setUid(uid){
				var isShow = "true";
				var message = "";
				<%if(!HrmUserVarify.checkUserRight("MobileSignInfo:Manage", user)){%>
					var result = eval(common.ajax("cmd=checkBeforeShowMobileSignData&arg=<%=String.valueOf(user.getUID())%>&id="+uid));
					if(result && result.length > 0){
						for(var i=0;i<result.length;i++){
							isShow = result[i].isShow;
							message = result[i].message;
							break;
						}
					}
				<%}%>
				if(isShow === "true" || message === ""){
					$GetEle("uid").value = uid;
					$GetEle("contentframe").src = "/hrm/mobile/signin/mapViewContent.jsp?id=&thisDate="+$GetEle("thisDate").value+"&uid="+uid;
				} else {
					if(hasException === false) window.top.Dialog.alert(message);
					hasException = true;
				}
			}
			
			function setBtnBg(bg){
				btnBg = bg;
			}
			
			function getBtnBg(){
				return btnBg;
			}
			
			function getUid(){
				return $GetEle("uid").value;
			}
			
			function setSlg(svalue){
				$GetEle("slg").value = svalue;
				showPersonTree($GetEle("currentUser").value);
			}
			
			function getSlg(){
				return $GetEle("slg").value;
			}
			
			function _callBack(event, id1, name, _callbackParams){
				if (id1 && id1.id!=""){
					var id = wuiUtil.getJsonValueByIndex(id1, 0);
					$("#currentUser").val(id);
					setUid(id);
					showPersonTree(id);
				}
			}
			
			function showPersonTree(id){
				$("#persontree").attr("src","/hrm/mobile/signin/subordinateTree.jsp?id="+id+"&slg="+getSlg());
			}
			
			function showMySubordinateTree(){
				setUid(curId);
				showPersonTree(curId);
				setCurrentUser(curId, curName);
			}
			
			function setCurrentUser(userid, username){
				_writeBackData("currentUser",1,{id:userid,name:"<a href='javascript:openhrm("+userid+");' onclick='pointerXY(event);'> "+username+"</a>"},{
					hasInput:true,
					replace:true,
					isSingle:true,
					isedit:true
				});
			}
			
			function btnChange(sId, hId){
				var sObj = $GetEle(sId);
				if(sObj) sObj.style.display = "block";
				var hObj = $GetEle(hId);
				if(hObj) hObj.style.display = "none";
				
				setSlg(sId === "btn_x" ? "c" : "i");
				
				if($GetEle("currentUser").value === "") showMySubordinateTree();
			}
			
			function setThisDate(date){
				$GetEle("thisDate").value = date;
			}
			
			jQuery(document).ready(function(){
				jQuery("#persontree").height(jQuery("#bodyIdTemp").height()-jQuery("#fTr").height()-25);
				window.onresize = function(){
					jQuery("#persontree").height(jQuery("#bodyIdTemp").height()-jQuery("#fTr").height()-25);
				};
			});
		</script>
	</head>
	<body id='bodyIdTemp' style="overflow:none;">
		<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<form name="weaver" method="post">
			<input type="hidden" id="uid" name="uid" value="<%=uid%>">
			<input type="hidden" id="slg" name="slg" value="i">
			<input type="hidden" id="thisDate" name="thisDate" value="<%=thisDate%>">
			<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;">
				<tr>
					<td style="width:80%;">
						<iframe src="/hrm/mobile/signin/mapViewContent.jsp?id=<%=id%>&uid=<%=uid%>&thisDate=<%=thisDate%>" id="contentframe" name="contentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
					</td>
					<td style="width:20%; display:table-cell;border-right:1px solid #BDBDBD;background-color:rgb(245,245,245)!important;">
						<table style="height:100%;width:100%;display: table-cell;border:1px solid #BDBDBD;" cellspacing="0" cellpadding="0">
							<tr id="fTr">
								<td style="vertical-align:top;height:60px;width:100%;position:relative;display:table-cell;border:none;">
									<span style="padding-left:10px;height:30px;line-height:30px;float:left;display:-moz-inline-box;display:inline-block;vertical-align:middle;position:relative;">
										<p style="font-weight:bold;"><%=SystemEnv.getHtmlLabelName(32997,user.getLanguage())%></p>
									</span>
									<span style="padding:5px;height:30px;line-height:30px;float:right;display:-moz-inline-box;display:inline-block;vertical-align:middle;position:relative;">
										<div id="btn_c" name="btn_c" style="padding-left:6px;width:42px;height:24px;line-height:28px;background-color:#BDBDBD;color:#fff;cursor:pointer;position:relative;display:" onclick="btnChange('btn_x','btn_c')">
											<span style="float:left"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></span><span style="float:right;padding:2px 3px 0px 0px"><img border="0" src="/appres/hrm/image/mobile/signin/img008.png"></span>
										</div>
										<div id="btn_x" name="btn_x" style="padding-left:6px;width:42px;height:24px;line-height:28px;background-color:#BDBDBD;color:#fff;cursor:pointer;position:relative;display:none" onclick="btnChange('btn_c','btn_x')">
											<span style="float:left"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></span><span style="float:right;padding:2px 3px 0px 0px"><img border="0" src="/appres/hrm/image/mobile/signin/img007.png"></span>
										</div>
									</span>
									<p style="background-color:#d0d0d0;padding:5px;height:26px;width:96%;font-size:12px;">
										<div style="padding:2px;position:relative;">
											<brow:browser viewType="0" name="currentUser" browserValue='<%=uid%>' temptitle='<%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>'
												browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"%>'
												hasInput="true" isSingle="true" hasBrowser="true" isMustInput='1' width="85%" _callback="_callBack" _callbackParams=""
												completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
												browserSpanValue='<%=uName%>'>
											</brow:browser>
										</div>
										<div style="float:right;height:24px;line-height:28px;color:#fff;cursor: pointer;width:10px;padding-right:12px;position:relative;" title="<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>" onclick="showMySubordinateTree()">
											<img border="0" src="/appres/hrm/image/mobile/signin/img004.png">
										</div>
									</p>
								</td>
							</tr>
							<tr style="background-color:#fff;">
								<td>
									<div id="treediv" style="padding-top:5px;padding-bottom:5px;height:100%;">
										<IFRAME name="persontree" id="persontree" src="/hrm/mobile/signin/subordinateTree.jsp?id=<%=uid%>&slg=i" frameborder='0' style="width:100%;height:100%;overflow:hidden;"></IFRAME>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
