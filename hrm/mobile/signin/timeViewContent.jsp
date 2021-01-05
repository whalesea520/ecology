<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- Added by wcd 2015-03-20 [移动签到-时间视图] -->
<%@ include file="/hrm/header.jsp" %>
<%@ page import="weaver.mobile.sign.MobileSign"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<jsp:useBean id="signIn" class="weaver.hrm.mobile.signin.SignInManager" scope="page" />
<jsp:useBean id="resourceInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	String imagefilename = "/images/hdHRM_wev8.gif", needfav ="1", needhelp ="";
	String titlename = SystemEnv.getHtmlLabelNames("31726,32559",user.getLanguage());
	Map dates = signIn.getDate(strUtil.vString(request.getParameter("cmd")), strUtil.vString(request.getParameter("date")));
	String thisDate = dateUtil.getCurrentDate();
	String beginDate = strUtil.vString(dates.get("beginDate"));
	String endDate = strUtil.vString(dates.get("endDate"));
	String uid = strUtil.vString(request.getParameter("uid"), String.valueOf(user.getUID()));
	//
	String[] uidArr = uid.split(",");
	for(int i=0;i<uidArr.length;i++){
		String departmentid = ResourceComInfo.getDepartmentID(uidArr[i]);
		if(!uidArr[i].equals(""+user.getUID()) && !ResourceComInfo.getManagerID(uidArr[i]).equals(""+user.getUID()) && !HrmUserVarify.checkUserRight("HrmResource:Absense",user,departmentid)) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}
	}
	//
	Map datas = signIn.getData(uid, beginDate+" 00:00:00", endDate+" 23:59:59", 1, 1000);
	List signs = null;
	if(datas != null && !datas.isEmpty()){
		signs = (List)datas.get("list");
		signs = signs == null ? new ArrayList() : signs;
	}
%>
<html>
	<head>
		<title><%=titlename%></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/Weaver_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/appres/hrm/css/signin_wev8.css" type="text/css" />
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
		<script type="text/javascript">
			function showMap(id, uid, thisDate){
				parent.parent.location.href = "/hrm/HrmTab.jsp?_fromURL=mobileSignIn&showMap=true&id="+id+"&uid="+uid+"&thisDate="+thisDate;
			}
			
			function blowUpImage(obj) {
				hs.graphicsDir = '/js/messagejs/highslide/graphics/';
				hs.outlineType = 'rounded-white';
				hs.fadeInOut = true;
				hs.headingEval = 'this.a.title';
				return hs.expand(obj);
			}
		</script>
	</head>
	<body>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<div id="mainContent" class="mainContent" style="overflow:none;">
			<table style="width: 100%" cellpadding="0" cellspacing="0">
				<tr>
				   <td valign="top" width="*" style="max-width: 800px;">
						<div>
							<div class="reportBody" id="reportBody" style="background-color: inherit !important; ">
								<%
									String curDate = "";
									String operDate = "";
									MobileSign mSign = null;
									boolean isEnd = false;
									String[] uids = uid.split(",");
									for(String startDate=endDate;!isEnd;){
										Map existsMap = new HashMap();
										int dCount = 0;
										if(startDate.equals(beginDate)) isEnd = true;
										if(dateUtil.compDate(startDate, thisDate) >= 0){
										for(int i=0; i<signs.size(); i++){
											mSign = (MobileSign)signs.get(i);
											operDate = mSign.getOperateDate();
											if(!operDate.equals(startDate)) continue;
											else {
												for(int j=0; j<uids.length; j++){
													if(mSign.getOperaterId().equals(uids[j]) && !existsMap.containsKey(uids[j])){
														existsMap.put(uids[j], uids[j]);
													}
												}
												dCount ++;
											}
											if(curDate.length() == 0 || !curDate.equals(operDate)){
												curDate = operDate;
								%>
								<div class="signItem">
									<table width="100%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
										<tbody>
											<tr>
												<td valign="top" width="50px" nowrap="nowrap">
													<div class="dateArea"></div> 
													<div class="time img001"></div>
													<div class="discussline"></div>
												</td>
												<td valign="top" class="img002">
													<div style="margin:1px 0px 0px 15px;color:white;"><%=startDate%></div>
												</td>
											</tr>
											<tr>
												<td valign="top" width="50px" nowrap="nowrap">
													<div class="emptyRow"></div>
													<div class="discussline"></div>
												</td>
												<td valign="top"></td>
											</tr>
										</tbody>
									</table>
								</div>
									<%}%>
								<div class="signItem">
									<table width="100%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
										<tbody>
											<tr>
												<td valign="top" width="50px" nowrap="nowrap">
													<div class="dateArea"></div> 
													<div class="state img003"></div>
													<div class="discussline" style=""></div>
												</td>
												<td valign="top" class="item_td">
													<div class="discussitem">
														<div class="discussView">
															<div class="sortInfo">
															   <div style="float: left;">
																	<div class="name">&nbsp;<a href="javascript:openhrm('<%=mSign.getOperaterId()%>');" onclick="pointerXY(event);"><%=resourceInfo.getResourcename(mSign.getOperaterId())%></a>&nbsp;</div>
																	<div class="left">
																		<img id="moodIcon" style="margin-left: 10px;margin-right: 2px;" width="12px" src="/appres/hrm/image/mobile/signin/img005.png">
																	</div>
																	<div class="name">&nbsp;<%=mSign.getOperateTime()%>&nbsp;</div>
																	<div class="clear"></div>
																</div>
																<div style="color:#007FCB;float:right;margin-right:8px;">
																	<span style="width: 100px; cursor: default;"><%=signIn.getShowName(mSign.getOperateType())%></span>
																</div>
																<div class="clear"></div>
															</div>
															<div class="dotedLine"></div>
															<div class="clear reportContent">
																<div style="margin-left:8px"><%=mSign.getRemark()%></div>
																<div style="margin-left:8px">
																	<%
																		String[] ids = mSign.getAttachmentIds().split(",");
																		int idSize = ids == null ? 0 : ids.length;
																		for(int x=0; x<idSize; x++){
																			if(strUtil.isNull(ids[x])) continue;
																	%>
																	<a href="/weaver/weaver.file.FileDownload?fileid=<%=ids[x]%>" onclick="return blowUpImage(this);"><img src="/weaver/weaver.file.FileDownload?fileid=<%=ids[x]%>" border=0 width="100" height="110"></a>
																	<%
																		}
																	%>
																</div>
															</div>
															<div class="operationdiv" style="padding:5px 0px 8px 8px;">
																<div class="left">
																	<img id="moodIcon" style="margin-left: 10px;margin-right: 2px;" width="16px" src="/appres/hrm/image/mobile/signin/img006.png">
																</div>
																<div class="datetime">&nbsp;<a href="javascript:void(0);" onclick="showMap('<%=mSign.getUniqueId()%>', '<%=mSign.getOperaterId()%>', '<%=mSign.getOperateDate()%>')"><%=mSign.getAddress()%></a>&nbsp;</div>
																<div class="right"></div>
																<div class="clear"></div>
															</div>
														</div>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<%
										}
										if(dCount == 0){
								%>
								<div class="signItem">
									<table width="100%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
										<tbody>
											<tr>
												<td valign="top" width="50px" nowrap="nowrap">
													<div class="dateArea"></div> 
													<div class="time img001"></div>
													<div class="discussline"></div>
												</td>
												<td valign="top" class="img002">
													<div style="margin:1px 0px 0px 15px;color:white;"><%=startDate%></div>
												</td>
											</tr>
											<tr>
												<td valign="top" width="50px" nowrap="nowrap">
													<div class="emptyRow"></div>
													<div class="discussline"></div>
												</td>
												<td valign="top"></td>
											</tr>
										</tbody>
									</table>
								</div>
								<%
										}
										Map nExMap = new HashMap();
										for(int i=0; i<uids.length; i++){
											if(!existsMap.containsKey(uids[i])) nExMap.put(uids[i], uids[i]);
										}
										Iterator it = nExMap.entrySet().iterator();
										while(it.hasNext()){
											Map.Entry entry = (Map.Entry) it.next();
									%>
									<div class="signItem">
										<table width="100%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
											<tbody>
												<tr>
													<td valign="top" width="50px" nowrap="nowrap">
														<div class="dateArea"></div> 
														<div class="state img003" title=""></div>
														<div class="discussline" style=""></div>
													</td>
													<td valign="top" class="item_td">
														<div class="discussitem">
															<div class="discussView">
																<div class="sortInfo" style="height:40px;line-height:40px">
																	<div style="float: left;">
																		<div class="name">&nbsp;<a href="javascript:openhrm('<%=(String)entry.getKey()%>');" onclick="pointerXY(event);"><%=resourceInfo.getResourcename((String)entry.getKey())%></a>&nbsp;</div>
																		<div class="name">&nbsp;<%=SystemEnv.getHtmlLabelNames("557,20032,264",user.getLanguage())%>&nbsp;</div>
																		<div class="clear"></div>
																	</div>
																	<div class="clear"></div>
																</div>
															</div>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
									<%
										}
										}
										startDate = dateUtil.addDate(startDate, -1);
									}
								%>
							</div>
							<div id="loadingdiv" style="position:relative;width: 100%;height: 30px;margin-bottom: 15px;display: none;">
							  <div class='loading' style="position: absolute;top: 10px;left: 50%;">
								 <img src='/images/loadingext_wev8.gif' align="absMiddle"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
							  </div>
							</div>	
						</div>
				   </td>
			   </tr>
			</table>
			<div class="clear"></div>
		</div>
	</body>
</html>