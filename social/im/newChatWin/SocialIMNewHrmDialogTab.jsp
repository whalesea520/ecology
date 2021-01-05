
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.Prop,
                 weaver.login.Account,
				 weaver.hrm.common.*,
				 weaver.login.VerifyLogin,
                 weaver.general.GCONST" %>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerVO"%>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerDAO"%>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="CitytwoComInfo" class="weaver.hrm.city.CitytwoComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
	HashMap<String,String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String(kv.get("_fromURL"));//来源
	String cmd = Util.null2String(kv.get("cmd"));
	String id = Util.null2String(kv.get("id"));
	String method = Util.null2String(kv.get("method"));
	String showpage = Util.null2String(kv.get("showpage"), "1");
	String _type = null;
	ShowTab tab = new ShowTab(rs,user);
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	String mouldid = "resource";
%>
<HTML>
	<HEAD>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
		<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

		<script type="text/javascript">
		function refreshTab(){
			jQuery('.flowMenusTd',parent.document).toggle();
			jQuery('.leftTypeSearch',parent.document).toggle();
		}
		</script>
		<!-- 人力资源弹出框tab页 -->
		<%
			String title = Util.null2String(request.getParameter("title"));
			boolean titleflag = false;
			String url = "";
			if(_fromURL.equals("GetUserIcon")){
                //前端--修改头像
                title = "33471";
                ///social/im/newChatWin/
                url = "/social/im/newChatWin/SocialIMNewGetUserIcon.jsp?requestFrom=homepage&isManager="+request.getParameter("isManager")+"&userId="+request.getParameter("userId")+"&subcompanyid="+request.getParameter("subcompanyid")+"&loginid="+Tools.getURLDecode(request.getParameter("loginid"));
            }
		%>
		<script type="text/javascript">
			jQuery(function(){
				jQuery('.e8_box').Tabs({
					getLine:1,
					iframe:"tabcontentframe",
					mouldID:"<%=MouldIDConst.getID(mouldid)%>",
					staticOnLoad:true,
					objName:"<%=title.length()>0?(titleflag?title:SystemEnv.getHtmlLabelNames(title,user.getLanguage())):"" %>"
				});
			});
		</script>
	</head>
	<BODY scroll="no">
		<div class="e8_box demo2">
			<div class="e8_boxhead">
				<div class="div_e8_xtree" id="div_e8_xtree"></div>
				<div class="e8_tablogo" id="e8_tablogo"></div>
				<div class="e8_ultab">
					<div class="e8_navtab" id="e8_navtab">
						<span id="objName"></span>
					</div>
					<div>
						<ul class="tab_menu">
						<%
							if(_fromURL.equals("HrmCareerPlanEdit")){
								if(!method.equals("finish")){
									tab.add(new TabLi("/hrm/career/careerplan/HrmCareerPlanEdit.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelName(1361,user.getLanguage()),true));
									tab.add(new TabLi("/hrm/career/careerplan/HrmCareerStep.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelName(15745,user.getLanguage())));
									tab.add(new TabLi("/hrm/career/inviteinfo/list.jsp?isdialog=1&cmd=notchangeplan&planid="+id,SystemEnv.getHtmlLabelName(366,user.getLanguage())));
									tab.add(new TabLi("/hrm/career/careerplan/HrmCareerApplyInfo.jsp?isdialog=1&planid="+id,SystemEnv.getHtmlLabelNames("1863,33292",user.getLanguage())));
									//tab.add(new TabLi("/hrm/career/applyinfo/list.jsp?isdialog=1&planid="+id,SystemEnv.getHtmlLabelNames("1863,33292",user.getLanguage())));
									out.println(tab.show());
								}
							}else if(_fromURL.equals("inviteInfo") && !method.equals("showapplyinfo")){
								String planid = Util.null2String(kv.get("planid"));
								tab.add(new TabLi("/hrm/career/inviteinfo/content.jsp?method="+method+"&planid="+planid+"&cmd="+cmd+"&isdialog=1&id="+id,SystemEnv.getHtmlLabelName(1361,user.getLanguage()),true));
								if(method.equals("show")||method.equals("edit")){
									tab.add(new TabLi("/hrm/career/inviteinfo/InviteSchedule.jsp?method="+method+"&planid="+planid+"&isdialog=1&inviteid="+id,SystemEnv.getHtmlLabelName(15720,user.getLanguage())));
								}
								if(method.equals("edit")){
									tab.add(new TabLi("/hrm/career/applyinfo/list.jsp?isdialog=1&planid="+planid+"&inviteid="+id,SystemEnv.getHtmlLabelNames("1863,33292",user.getLanguage())));
								}
								if(!method.equals("show")){
									out.println(tab.show());
								}
							}else if(_fromURL.equals("applyInfo") && method.equals("edit")){
								tab.add(new TabLi("/hrm/career/applyinfo/content.jsp?method="+method+"&isdialog=1&applyid="+id,SystemEnv.getHtmlLabelName(1361,user.getLanguage()),true));
								tab.add(new TabLi("/hrm/career/applyinfo/myinfo.jsp?method="+method+"&isdialog=1&applyid="+id,SystemEnv.getHtmlLabelName(15687,user.getLanguage())));
								tab.add(new TabLi("/hrm/career/applyinfo/workinfo.jsp?method="+method+"&isdialog=1&applyid="+id,SystemEnv.getHtmlLabelName(15688,user.getLanguage())));
								out.println(tab.show());
							}else if(_fromURL.equals("applyInfo") && method.equals("HrmInterviewResult")){
								String planid = Util.null2String(kv.get("planid"));
								String result = Util.null2String(kv.get("result"));
								tab.add(new TabLi("/hrm/career/HrmInterviewResult.jsp?showpage=1&isdialog=1&result="+result+"&planid="+planid+"&id="+id,SystemEnv.getHtmlLabelName(15729,user.getLanguage()),true));
								tab.add(new TabLi("/hrm/career/HrmInterviewResult.jsp?showpage=2&isdialog=1&result="+result+"&planid="+planid+"&id="+id,SystemEnv.getHtmlLabelName(15738,user.getLanguage())));
								tab.add(new TabLi("/hrm/career/HrmInterviewResult1.jsp?showpage=2&isdialog=1&result="+result+"&planid="+planid+"&id="+id,SystemEnv.getHtmlLabelName(15920,user.getLanguage())));
								out.println(tab.show());
							}else if(_fromURL.equals("applyInfo") && method.equals("share")){
								tab.add(new TabLi("/hrm/career/HrmShare.jsp?isdialog=1&showpage=1&applyid="+id,SystemEnv.getHtmlLabelNames("87,119",user.getLanguage()),showpage.equals("1")));
								tab.add(new TabLi("/hrm/career/HrmShare.jsp?isdialog=1&showpage=2&applyid="+id,SystemEnv.getHtmlLabelNames("119,25433",user.getLanguage()),showpage.equals("2")));
								out.println(tab.show());
							}else if(_fromURL.equals("systemRightGroup") && method.equals("edit")){
								tab.add(new TabLi("/systeminfo/systemright/SystemRightGroupEdit.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelNames("492,33361",user.getLanguage()),showpage.equals("1")));
								tab.add(new TabLi("/systeminfo/systemright/SystemRightAuthority.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelNames("385,17463",user.getLanguage()),showpage.equals("2")));
								out.println(tab.show());
							}else if(_fromURL.equals("hrmRoles") && method.equals("HrmRolesEdit")){
								String nShow = Tools.vString(kv.get("nShow"));
								if(!nShow.equals("true")){
									tab.add(new TabLi("/hrm/roles/HrmRolesEdit.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelName(33401,user.getLanguage()),showpage.equals("1")));
									tab.add(new TabLi("/hrm/roles/HrmRolesFucRightSet.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelName(17864,user.getLanguage()),showpage.equals("2")));
									if(detachable == 1){
										tab.add(new TabLi("/hrm/roles/HrmRolesStrRightSet.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelName(17865,user.getLanguage()),showpage.equals("4")));
									}
									tab.add(new TabLi("/hrm/roles/HrmRolesMembers.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelNames("431,320",user.getLanguage()),showpage.equals("3")));
									out.println(tab.show());
								}
							}else if(_fromURL.equals("fnaCurrencies") && (method.equals("FnaCurrenciesEdit") || method.equals("FnaCurrenciesView"))){
								tab.add(new TabLi("/fna/maintenance/FnaCurrenciesEdit.jsp?isdialog=1&showpage=1&id="+id,SystemEnv.getHtmlLabelName(1361,user.getLanguage()),showpage.equals("1")));
								tab.add(new TabLi("/fna/maintenance/FnaCurrenciesView.jsp?isdialog=1&showpage=2&id="+id,SystemEnv.getHtmlLabelNames("588,17463",user.getLanguage()),showpage.equals("2")));
								out.println(tab.show());
							}else if(_fromURL.equals("hrmReport") && cmd.equals("hrmContract") && method.equals("HrmContractReport")){
								url = "/hrm/report/contract/"+method+".jsp?isdialog=1&subcompanyid1="+Util.null2String(request.getParameter("subcompanyid1"));
								tab.add(new TabLi("/hrm/report/contract/"+method+".jsp?showpage=1&isdialog=1&subcompanyid1="+Util.null2String(request.getParameter("subcompanyid1")),(SystemEnv.getHtmlLabelName(124,user.getLanguage())+"－"+SystemEnv.getHtmlLabelName(277,user.getLanguage())),showpage.equals("1")));
								tab.add(new TabLi("/hrm/report/contract/"+method+".jsp?showpage=2&isdialog=1&subcompanyid1="+Util.null2String(request.getParameter("subcompanyid1")),(SystemEnv.getHtmlLabelName(716,user.getLanguage())+"－"+SystemEnv.getHtmlLabelName(277,user.getLanguage())),showpage.equals("2")));
								tab.add(new TabLi("/hrm/report/contract/"+method+".jsp?showpage=3&isdialog=1&subcompanyid1="+Util.null2String(request.getParameter("subcompanyid1")),(SystemEnv.getHtmlLabelName(124,user.getLanguage())+"－"+SystemEnv.getHtmlLabelName(716,user.getLanguage())),showpage.equals("3")));
								out.println(tab.show());
							}else if(_fromURL.equals("showHrmAttProcSet")){
								tab.add(new TabLi("/hrm/attendance/hrmAttProcSet/content.jsp?isdialog=1&subcompanyid="+Util.null2String(kv.get("subcompanyid"))+"&id="+id,SystemEnv.getHtmlLabelName(82826,user.getLanguage()),showpage.equals("1")));
								tab.add(new TabLi("/hrm/attendance/hrmAttProcSet/wfFields.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelNames("15880,82827",user.getLanguage()),showpage.equals("2")));
								if(Tools.parseToInt(kv.get("field006")) == 0) tab.add(new TabLi("/hrm/attendance/hrmAttProcSet/wfSet.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelName(33085,user.getLanguage()),showpage.equals("3")));
								out.println(tab.show());
							}else if(_fromURL.equals("HrmDefaultScheduleTab")){
								String HrmDefaultScheduleUrl = Util.getIntValue(id,-1)<0?"/hrm/schedule/HrmDefaultScheduleAdd.jsp?isdialog=1":"/hrm/schedule/HrmDefaultSchedule.jsp?isdialog=1";
								String HrmOnlineKqUrl = "/hrm/schedule/HrmScheduleOnlineKqSystemSet.jsp?isdialog=1";
								tab.add(new TabLi(HrmDefaultScheduleUrl+"&subcompanyid="+Util.null2String(kv.get("subcompanyid"))+"&id="+id,SystemEnv.getHtmlLabelName(16254,user.getLanguage()),showpage.equals("1")));
								tab.add(new TabLi(HrmOnlineKqUrl+"&id="+id+"&subcompanyid="+Util.null2String(kv.get("subcompanyid")),SystemEnv.getHtmlLabelName(34169,user.getLanguage()),showpage.equals("2")));
								out.println(tab.show());
							}
						%>
						<%if(_fromURL.equals("HrmTrainEdit")){
							//基本信息			培训日程			培训考核			培训考评
							String trainid = request.getParameter("trainid");
						%>
		        <li class="current" onMouseOver="javascript:showSecTabMenu('.e8_box','tabcontentframe');">
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainEditDo.jsp?isdialog=1&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainSchedule.jsp?isdialog=1&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(16150,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainTest.jsp?isdialog=1&trainid=<%=id %>"><%=SystemEnv.getHtmlLabelName(16143,user.getLanguage()) %></a>
						</li>
					  <li>
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainAssess.jsp?isdialog=1&trainid=<%=id %>"><%=SystemEnv.getHtmlLabelName(16144,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmTrainDayAdd")){
		    			String trainid = request.getParameter("trainid");
		        %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu('.e8_box','tabcontentframe');">
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainDayAdd.jsp?isdialog=1&trainid=<%=trainid %>"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainDayActorList.jsp?isdialog=1&id=<%=trainid %>"><%=SystemEnv.getHtmlLabelName(33430,user.getLanguage()) %></a>
						</li>
		        <%} else if(_fromURL.equals("HrmTrainDayEdit")){
		    			String trainid = request.getParameter("trainid");
		        %>
		    		<li class="current" onMouseOver="javascript:showSecTabMenu('.e8_box','tabcontentframe');">
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainDayEdit.jsp?isdialog=1&trainid=<%=trainid %>&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainDayActorList.jsp?isdialog=1&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(33430,user.getLanguage()) %></a>
						</li>
    				<%} else if ("authHandledMatters".equals(_fromURL)) {%>
    					<li id="tab_1" class="current">
							<a href="<%=url%>&eventSearchType=1" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
							</a>
						</li>
						<li id="tab_2">
							<a href="<%=url%>&eventSearchType=2" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(17999,user.getLanguage())%>
							</a>
						</li>
						<li id="tab_3">
							<a href="<%=url%>&eventSearchType=3" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(18800,user.getLanguage())%>
							</a>
						</li>
    				<%}else if(_fromURL.equals("HrmTrainPlanEditDo")){
    				%>
		    		<li class="current" onMouseOver="javascript:showSecTabMenu('.e8_box','tabcontentframe');">
							<a target="tabcontentframe" href="/hrm/train/trainplan/HrmTrainPlanEditDo.jsp?isdialog=1&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/train/trainplan/HrmTrainPlanDayEdit.jsp?isdialog=1&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(16150,user.getLanguage()) %></a>
						</li>
					  <li>
							<a target="tabcontentframe" href="/hrm/train/trainplan/HrmTrainPlanRange.jsp?isdialog=1&planid=<%=id %>"><%=SystemEnv.getHtmlLabelName(6104,user.getLanguage()) %></a>
						</li>
		    	 <%}else if(_fromURL.equals("HrmResourceTrainRecordBasic")){
    				%>
		    		<li class="current" onMouseOver="javascript:showSecTabMenu('.e8_box','tabcontentframe');">
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceTrainRecordBasic.jsp?isdialog=1&paraid=<%=id %>"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceTrainRecordDay.jsp?isdialog=1&paraid=<%=id %>"><%=SystemEnv.getHtmlLabelName(33430,user.getLanguage()) %></a>
						</li>
						<%}else if(_fromURL.equals("hrmGroup")){
		      		if(cmd.equals("edit")){
		    		 		int type = 0;
		    		 		rs.executeSql("select type from hrmgroup where id ="+id);
		    		 		if(rs.next()){
		    		 			type = rs.getInt("type");
		    		 		}
		    		 	%>
	    				<li class="<%=showpage.equals("1")?"current":"" %>" onMouseOver="<%=showpage.equals("1")?"javascript:showSecTabMenu('.e8_box','tabcontentframe');":"" %>">
							<a target="tabcontentframe" href="/hrm/group/HrmGroupBaseAdd.jsp?isdialog=1&showpage=1&groupid=<%=id %>"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
							</li>
			    		<li class="<%=showpage.equals("2")?"current":"" %>" onMouseOver="<%=showpage.equals("1")?"javascript:showSecTabMenu('.e8_box','tabcontentframe');":"" %>">
								<a target="tabcontentframe" href="/hrm/group/HrmGroupMember.jsp?isdialog=1&showpage=2&groupid=<%=id %>"><%=SystemEnv.getHtmlLabelName(431,user.getLanguage()) %></a>
							</li>
							<%if(type==1){ %>
			       	<li class="<%=showpage.equals("3")?"current":"" %>" onMouseOver="<%=showpage.equals("1")?"javascript:showSecTabMenu('.e8_box','tabcontentframe');":"" %>">
								<a target="tabcontentframe" href="/hrm/group/HrmGroupShare.jsp?isdialog=1&showpage=3&groupid=<%=id %>"><%=SystemEnv.getHtmlLabelName(19910,user.getLanguage()) %></a>
							</li>
							<%} %>
				 <%}else if(_fromURL.equals("hrmGroup")&&method.equals("HrmGroupSuggestList")){
		      		//中端--常用组变更提醒
		      		String status = Util.null2String(request.getParameter("status"),"0");
			      	%>
			      	<li class="<%=status.equals("0")?"current":"" %>" onMouseOver="javascript:showSecTabMenu();">
								<a target="tabcontentframe" href="/hrm/group/HrmGroupSuggestList.jsp?status=0&isdialog=1"><%=SystemEnv.getHtmlLabelName(16349,user.getLanguage()) %></a>
							</li>
						  <li class="<%=status.equals("1")?"current":"" %>">
								<a target="tabcontentframe" href="/hrm/group/HrmGroupSuggestList.jsp?status=1&isdialog=1"><%=SystemEnv.getHtmlLabelName(1454,user.getLanguage()) %></a>
							</li>
			     <%}%>
			    	<%}%>
						</ul>
						<div id="rightBox" class="e8_rightBox"></div>
					</div>
				</div>
			</div>
			<div class="tab_box">
				<div>
					<%
       		if(url.endsWith(".jsp")){
       			url +="?fromHrmDialogTab=1";
       		}else{
       			url +="&fromHrmDialogTab=1";
       		}
					%>
				<iframe src="<%=url %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				</div>
			</div>
		</div>
	</body>
</html>

