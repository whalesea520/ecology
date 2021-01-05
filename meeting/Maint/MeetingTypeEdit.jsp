
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight"
	class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	boolean canedit = false;
	int reloadTb = Util.getIntValue(request.getParameter("reloadTb"));
	String id = Util.null2String(request.getParameter("id"));
	String method = Util.null2String(request.getParameter("method"));
	String from = Util.null2String(request.getParameter("from"));
	String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("meetingdetachable")),0);
	int subcompanyid=-1;
	RecordSet.executeSql("select id, name,desc_n,approver,approver1,subcompanyid,catalogpath,dsporder from Meeting_Type where id = "+ id);
	int approver = -1;
	int approver1=-1;
	String name = "";
	String catalogpathspan = "";
	String catalogpath = "";
	String desc_n = "";
	String dsporder = "0";
	if (RecordSet.next()) {
		name = Util.null2String(RecordSet.getString("name"));
		approver = RecordSet.getInt("approver");
		approver1 = RecordSet.getInt("approver1");
		subcompanyid = RecordSet.getInt("subcompanyid");
		catalogpath = Util.null2String(RecordSet.getString("catalogpath"));
		desc_n = Util.null2String(RecordSet.getString("desc_n"));
		dsporder = Util.getPointValue3(RecordSet.getString("dsporder"), 1, "0");
		
		if(!catalogpath.equals("")){
			try{
				 String[] categoryArr = Util.TokenizerString2(catalogpath,",");
				 /*catalogpathspan += "/"+MainCategoryComInfo.getMainCategoryname(categoryArr[0]);
				 catalogpathspan += "/"+SubCategoryComInfo.getSubCategoryname(categoryArr[1]);*/
				 catalogpathspan += SecCategoryComInfo.getAllParentName(categoryArr[2],true);
			}catch(Exception e){
				catalogpathspan += SecCategoryComInfo.getAllParentName(catalogpath,true);
			}
   		}
	}
	
	int subid=subcompanyid;
	if(subid<0){
	        subid=user.getUserSubCompany1();
	}
	ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"MeetingType:Maintenance");
	
	int operatelevel = CheckSubCompanyRight
			.ChkComRightByUserRightCompanyId(user.getUID(),
					"MeetingType:Maintenance", subid);
	boolean onlyRead=false;
	if (detachable == 1) {
		if (subid != 0 && operatelevel < 0) {
			subid=0;
		} else {
			if(operatelevel==0){//只读
            	onlyRead=true;
			}
			subcompanyid = subid;
			canedit=true;
		}
	} else {
		subcompanyid = subid;
		if (HrmUserVarify.checkUserRight("MeetingType:Maintenance", user)) {
			canedit = true;
		}
	}
	if (!canedit) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	String formids="85";
	RecordSet.execute("select DISTINCT billid from meeting_bill where billid<>85");
	while(RecordSet.next()){
		String billid=RecordSet.getString("billid");
		if(!"".equals(billid)){
			formids+=","+billid;
		}
	}
	String browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+xssUtil.put(" where isbill=1 and formid in("+formids+")");
	String completeUrl="/data.jsp?type=-99991&whereClause="+xssUtil.put(" isbill=1 and formid in("+formids+") and isvalid=1 ");
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css"
			type="text/css" />
		<link rel="stylesheet"
			href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"
			type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<style>
            .add_btn{
                background: url("/wui/theme/ecology8/skins/default/general/browserAdd_wev8.png");
                float:left;
                cursor: pointer;
                width:16px;
                height:17px;
                margin-left:5px;
                margin-top:3px;
            }
            .add_btn:hover{
                background: url("/wui/theme/ecology8/skins/default/general/browserAdd_hover_wev8.png");
            }
        </style>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(780, user
				.getLanguage());
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY style="overflow: hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		if(!onlyRead){//非只读
			if ("edit".equals(method) || "".equals(method)) {
				RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
						+ ",javascript:save(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
				
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javascript:delType("+id +"),_self} ";
				RCMenuHeight += RCMenuHeightStep;

			} else {
				RCMenu += "{" + SystemEnv.getHtmlLabelName(611, user.getLanguage())
						+ ",javascript:add(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
				
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32136, user.getLanguage())+",javascript:delAttr(),_self} ";
				RCMenuHeight += RCMenuHeightStep;

			}
		}
			RCMenu += "{"+SystemEnv.getHtmlLabelName(309, user.getLanguage())+",javascript:closePrtDlgARfsh(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan"
					style="text-align: right; width: 400px !important">
					<%
					if(!onlyRead){//非只读
						if ("edit".equals(method) || "".equals(method)) {
					%>
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="save()" />
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="delType(<%=id %>)" />
					<%
						} else {
					%>
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="add()" />
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>" 
						class="e8_btn_top middle" onclick="delAttr()" />
					<%
						}
					}
					%>
					<span
						title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv">
			<span style="width:10px"></span>
			<span id="hoverBtnSpan" class="hoverBtnSpan"> <span
				id="edit" onclick="location='/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id=<%=id %>&method=edit&from=<%=from %>'"
				class=" <%=("edit".equals(method) || "".equals(method)) ? "selectedTitle"
				: ""%>"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></span>
				<span id="share" onclick="location='/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id=<%=id %>&method=share&from=<%=from %>'"
				class=" <%=("share".equals(method)) ? "selectedTitle"
				: ""%>"><%=SystemEnv.getHtmlLabelName(19910, user.getLanguage())%></span>
				<span id="member" onclick="location='/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id=<%=id %>&method=member&from=<%=from %>'"
				class=" <%=("member".equals(method)) ? "selectedTitle"
				: ""%>"><%=SystemEnv.getHtmlLabelName(2106, user.getLanguage())%></span>
				<span id="caller" onclick="location='/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id=<%=id %>&method=caller&from=<%=from %>'"
				class=" <%=("caller".equals(method)) ? "selectedTitle"
				: ""%>"><%=SystemEnv.getHtmlLabelName(2152, user.getLanguage())%></span>
			</span>
		</div>
		<%
		if ("edit".equals(method) || "".equals(method)) {
		%>
			<div class="zDialog_div_content" id="editDiv" name="editDiv" >
				<FORM id=weaverA name=weaverA action="MeetingTypeOperation.jsp"
					method=post>
					<input type="hidden" value="false" name="hasChanged"
						id="hasChanged">
					<input type="hidden" value="<%=id%>" name="mid"
						id="mid">
					<input type="hidden" value="<%=name%>" name="oldname"
						id="oldname">
					<input class=inputstyle type="hidden" name="method" id="method"
						value="<%=method%>">
					<input type="hidden" value="" name="forwd" id="forwd" />
					<input type="hidden" value="<%=dialog%>" name="dialog"
						id="dialog">
					<wea:layout type="2col">
						<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
							<wea:item><%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%></wea:item>
							<wea:item>
								<input id=name name=name class="InputStyle" style="width:300px;" value="<%=name %>" onblur="onblurCheckName()" onchange='checkinput("name","nameimage")'>
								<SPAN id=nameimage><%if("".equals(name)) {%><IMG src="/images/BacoError_wev8.gif" align="absMiddle"><%} %></SPAN>
								 <SPAN id=checknameinfo style='color:red'>&nbsp;</SPAN>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
						    <wea:item>
						    	<%
								if (detachable == 1) {
								%>
								<brow:browser viewType="0" name="subCompanyId" browserValue='<%=(subcompanyid > 0?(""+subcompanyid):"")%>'
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser4.jsp?rightStr=MeetingType:Maintenance" 
								hasInput="false"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="300px"
								completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
								browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname("" + subcompanyid)%>'></brow:browser>
								<%
								} else {
								%>
								
								<brow:browser viewType="0" name="subCompanyId" browserValue='<%=(subcompanyid > 0?(""+subcompanyid):"")%>' 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids=" 
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="300px"
								completeUrl="/data.jsp?type=164&show_virtual_org=-1" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
								browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname("" + subcompanyid)%>'></brow:browser>
								<%
								}
								%>
						    </wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></wea:item>
							<wea:item>
								<brow:browser viewType="0" name="approver" browserValue='<%=(approver > 0?(""+approver):"")%>' 
								browserOnClick="" browserUrl='<%=browserUrl %>'
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
								completeUrl='<%=completeUrl %>' linkUrl="/workflow/workflow/addwf.jsp?src=editwf&isTemplate=0&wfid=#id#&id=#id#" 
								browserSpanValue='<%=WorkflowComInfo.getWorkflowname(""+approver)%>'></brow:browser>
								<div class="add_btn" onclick="addwf('<%=SystemEnv.getHtmlLabelNames("611,15057",user.getLanguage())%>')"  title='<%=SystemEnv.getHtmlLabelNames("611,15057",user.getLanguage())%>' ></div>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(82441,user.getLanguage())%></wea:item>
							<wea:item>
								<brow:browser viewType="0" name="approver1" browserValue='<%=(approver1 > 0?(""+approver1):"")%>' 
								browserOnClick="" browserUrl='<%=browserUrl %>'
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
								completeUrl='<%=completeUrl %>' linkUrl="/workflow/workflow/addwf.jsp?src=editwf&isTemplate=0&wfid=#id#&id=#id#" 
								browserSpanValue='<%=WorkflowComInfo.getWorkflowname(""+approver1)%>'></brow:browser>
								<div class="add_btn" onclick="addwf('<%=SystemEnv.getHtmlLabelNames("611,82441",user.getLanguage())%>')"  title='<%=SystemEnv.getHtmlLabelNames("611,82441",user.getLanguage())%>' ></div>
							</wea:item>
						    <wea:item><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></wea:item>
						    <wea:item>
						        <brow:browser viewType="0" name="catalogpath" browserValue='<%=catalogpath %>' 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' width="300px"  _callback="showCalaogCallBk" afterDelCallback="showCalaogAftCallBk" _callbackParams="0"
								completeUrl="/data.jsp?type=categoryBrowser" linkUrl="#" 
								browserSpanValue='<%=catalogpathspan %>'></brow:browser>

						    </wea:item>
							<!-- 显示顺序 -->
							<wea:item><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></wea:item>
							<wea:item>
								<input class="InputStyle" type="text" size="10"
									maxlength=6 id='dsporder' name="dsporder" value="<%=dsporder %>"
									onKeyPress="ItemNum_KeyPress(this.name)"
									onchange="setChange()"
									onblur="checknumber('dsporder');checkDigit('dsporder',4,1)"
									style="text-align: right;width:80px;" />
							</wea:item>
						</wea:group>
					</wea:layout>	
				</FORM>
			</div>
			<%
				} else if("share".equals(method)) {
				//共享范围
			%>
			<div class="zDialog_div_content" id="shareDiv" name="shareDiv">
				<%
						String orderby = " id ";
						String tableString = "";
						int perpage = 10;
						String sqlwhere = " mtid = " + id;
						String otherParaobj = "column:departmentid+column:subcompanyid+column:userid+column:roleid+column:rolelevel+"+user.getLanguage()+"+column:jobtitleid+column:joblevel+column:joblevelvalue";
						String otherParalvl = "column:deptlevel+column:deptlevelMax+column:sublevel+column:sublevelMax+column:seclevel+column:seclevelMax+column:roleseclevel+column:roleseclevelMax";
						//System.out.println("[" + sqlwhere + "]");
						String backfields = " id,mtid,permissiontype,departmentid,deptlevel,subcompanyid,sublevel,seclevel,userid,seclevelMax,deptlevelMax,sublevelMax,roleid,rolelevel,roleseclevel,roleseclevelMax,jobtitleid,joblevel,joblevelvalue ";
						String fromSql = " MeetingType_share ";
						tableString = " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""
								+ perpage
								+ "\" >"
								+ " <checkboxpopedom  id=\"checkbox\" popedompara=\"1\" showmethod=\"weaver.meeting.Maint.MeetingTransMethod.getCheckbox\"  />"
								+ "       <sql backfields=\""
								+ backfields
								+ "\" sqlform=\""
								+ fromSql
								+ "\"  sqlwhere=\""
								+ Util.toHtmlForSplitPage(sqlwhere)
								+ "\"  sqlorderby=\""
								+ orderby
								+ "\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"
								+ "       <head>"
								+ "           <col width=\"30%\"  text=\""
								+ SystemEnv.getHtmlLabelName(21956, user.getLanguage())
								+ "\" column=\"permissiontype\" orderkey=\"permissiontype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingPermissiontype\" />"
								+ "           <col width=\"40%\"  text=\""
								+ SystemEnv.getHtmlLabelName(106, user.getLanguage())
								+ "\" column=\"permissiontype\" orderkey=\"permissiontype\" otherpara=\""
								+ otherParaobj
								+ "\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingPermissionObj\" />"
								+ "           <col width=\"20%\"  text=\""
								+ SystemEnv.getHtmlLabelName(683, user.getLanguage())
								+ "\" column=\"permissiontype\" orderkey=\"permissiontype\" otherpara=\""
								+ otherParalvl
								+ "\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingPermissionlevel\" />"
								+ "       </head>";
               if(!onlyRead){
	                 tableString+="		<operates>"+
                                  "		<popedom column=\"id\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.checkRoomPrmOperate\"></popedom> "+
			                      "		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
			                      "		</operates>";
               }
					 tableString+=" </table>";

						//System.out.println(tableString);
				%>
				<input type="hidden" value="<%=id%>" name="mid"
						id="mid">
					<wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
			</div>
			
			<%
				} else if("member".equals(method)) {
				//参会人
			%>
			<div class="zDialog_div_content" id="memberDiv" name="memberDiv">
				<%
						String orderby = " id ";
						String tableString = "";
						int perpage = 10;
						String sqlwhere = " meetingtype = " + id;
						String otherParaobj = "column:departmentid+column:subcompanyid+column:memberid+column:roleid+column:rolelevel+"+user.getLanguage()+"+column:jobtitleid+column:joblevel+column:joblevelvalue";
						String otherParalvl = "column:seclevel+column:seclevelMax";
						//System.out.println("[" + sqlwhere + "]");
						String backfields = " id,meetingtype,membertype,memberid,desc_n,departmentid,subcompanyid,seclevelMax,seclevel,roleid,rolelevel,jobtitleid,joblevel,joblevelvalue ";
						String fromSql = " Meeting_Member ";
						tableString = " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""
								+ perpage
								+ "\" >"
								+ " <checkboxpopedom  id=\"checkbox\" popedompara=\"1\" showmethod=\"weaver.meeting.Maint.MeetingTransMethod.getCheckbox\"  />"
								+ "       <sql backfields=\""
								+ backfields
								+ "\" sqlform=\""
								+ fromSql
								+ "\"  sqlwhere=\""
								+ Util.toHtmlForSplitPage(sqlwhere)
								+ "\"  sqlorderby=\""
								+ orderby
								+ "\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"
								+ "       <head>"
								+ "           <col width=\"20%\"  text=\""
								+ SystemEnv.getHtmlLabelName(21956, user.getLanguage())
								+ "\" column=\"membertype\" orderkey=\"membertype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingMembertype\" />"
								+ "           <col width=\"20%\"  text=\""
								+ SystemEnv.getHtmlLabelName(106, user.getLanguage())
								+ "\" column=\"membertype\" orderkey=\"membertype\" otherpara=\""
								+ otherParaobj
								+ "\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingMemberObj\" />"
								+ "           <col width=\"20%\"  text=\""
								+ SystemEnv.getHtmlLabelName(683, user.getLanguage())
								+ "\" column=\"membertype\" orderkey=\"membertype\" otherpara=\""
								+ otherParalvl
								+ "\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingMemberlevel\" />"
								+"			<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(85,user.getLanguage())+"\" column=\"desc_n\"  />"
								+ "       </head>" ;
			     if(!onlyRead){
			    	 tableString+="		<operates>"+
			                      "		<popedom column=\"id\" otherpara=\"1\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.checkOperate\"></popedom> "+
							      "		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
							      "		</operates>";
				 }
								
			         tableString+=" </table>";

						//System.out.println(tableString);
				%>
				<input type="hidden" value="<%=id%>" name="mid"
						id="mid">
					<wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
			</div>
			<%
				} else if("caller".equals(method)) {
				//召集人
			%>
			<div class="zDialog_div_content" id="callerDiv" name="callerDiv">
				<%
						String orderby = " id ";
						String tableString = "";
						int perpage = 10;
						String sqlwhere = " meetingtype = " + id;
						String otherParaobj = "column:departmentid+column:subcompanyid+column:userid+column:roleid+column:rolelevel+"+user.getLanguage()+"+column:jobtitleid+column:joblevel+column:joblevelvalue";
						String otherParalvl = "column:seclevel+column:seclevelMax";
						//System.out.println("[" + sqlwhere + "]");
						String backfields = " id,meetingtype,callertype,seclevel,departmentid,userid,foralluser,roleid,rolelevel,subcompanyid,seclevelMax,jobtitleid,joblevel,joblevelvalue ";
						String fromSql = " MeetingCaller ";
						tableString = " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""
								+ perpage
								+ "\" >"
								+ " <checkboxpopedom  id=\"checkbox\" popedompara=\"1\" showmethod=\"weaver.meeting.Maint.MeetingTransMethod.getCheckbox\"  />"
								+ "       <sql backfields=\""
								+ backfields
								+ "\" sqlform=\""
								+ fromSql
								+ "\"  sqlwhere=\""
								+ Util.toHtmlForSplitPage(sqlwhere)
								+ "\"  sqlorderby=\""
								+ orderby
								+ "\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"
								+ "       <head>"
								+ "           <col width=\"20%\"  text=\""
								+ SystemEnv.getHtmlLabelName(21956, user.getLanguage())
								+ "\" column=\"callertype\" orderkey=\"callertype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingCallertype\" />"
								+ "           <col width=\"40%\"  text=\""
								+ SystemEnv.getHtmlLabelName(106, user.getLanguage())
								+ "\" column=\"callertype\" orderkey=\"callertype\" otherpara=\""
								+ otherParaobj
								+ "\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingCallerObj\" />"
								+ "           <col width=\"30%\"  text=\""
								+ SystemEnv.getHtmlLabelName(683, user.getLanguage())
								+ "\" column=\"callertype\" orderkey=\"callertype\" otherpara=\""
								+ otherParalvl
								+ "\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingCallerlevel\" />"
								
								+ "       </head>" ;
				 if(!onlyRead){
					 tableString+="		<operates>"+
				                  "		<popedom column=\"id\" otherpara=\"1\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.checkOperate\"></popedom> "+
								  "		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
								  "		</operates>";
				 }
				    tableString+= " </table>";

						//System.out.println(tableString);
				%>
				<input type="hidden" value="<%=id%>" name="mid"
						id="mid">
					<wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
			</div>
			   <%
			} 
			%>
		
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
							id="zd_btn_cancle" class="zd_btn_cancle" onclick="closePrtDlgARfsh()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	</body>
</html>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	resizeDialog();
});

<%if(reloadTb == 1){%>
    try{
	var parentWin1 = parent.parent.getParentWindow(window.parent);
	parentWin1.tableReload();
	}catch(e){}
<%}%>

var diag_vote;
var dlg;
if(window.top.Dialog){
	dlg = window.top.Dialog;
} else {
    dlg = Dialog;
}
if(<%=dialog%>==1){
	//var bodyheight = document.body.offsetHeight;
	//$(".zDialog_div_content").css("height",bodyheight);
	//var dialog = parent.getDialog(window);
	//var parentWin = parent.getParentWindow(window);
	//function btn_cancle(){
	//	parentWin.closeDialog();
	//}
}

if("<%=isclose%>"==1){
	//var dialog = parent.getDialog(window);
	//var parentWin = parent.getParentWindow(window);
	//parentWin.location="/meeting/Maint/MeetingType_left.jsp?subCompanyId=<%=subcompanyid%>";
	//parentWin.closeDialog();	
}

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	jQuery("#hoverBtnSpan").hoverBtn();
};

function closeDialog(){
	//diag_vote.close();
	diag_vote.closeByHand();
}

function setChange(){
	jQuery("hasChanged").value="true";
}
function onblurCheckName() {
	var tname = $("#name").val();
	var oldname = $("#oldname").val();
	if(tname==null ||tname=="" || tname == "NULL" || tname == "Null" || tname == "null"){
		$("#checknameinfo").hide();
		return;
	}
	if(oldname != tname){
		$.post("/meeting/Maint/MeetingTypeCheck.jsp",{tname:encodeURIComponent(tname)},function(datas){ 							 
			if (datas.indexOf("exist") > 0){
				$("#checknameinfo").show();						 	
				$("#checknameinfo").text("<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%> [ "+tname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
			} else { 
				$("#checknameinfo").hide();
			}
		});
	}
		
}

function delType(id){
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked"))			
				ids = ids +$(this).attr("checkboxId")+",";
		});
	} else {
		ids = id+",";
	}
	if(ids=="") { 
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(32859,user.getLanguage())%>!") ;
	} else {
		Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32860,user.getLanguage())%>？", function (){
					doDeleteType(ids);	
			}, function () {}, 320, 90,false);
	}
}

function doDeleteType(ids){
	$.post("/meeting/Maint/MeetingTypeCheck.jsp",{checkType:"delete",ids:ids},function(datas){
		var dataObj=null;
		if(datas != ''){
			dataObj=eval("("+datas+")");
		}
		if(wuiUtil.getJsonValueByIndex(dataObj, 0) == "0"){
			$.post("/meeting/Maint/MeetingTypeOperation.jsp",{method:"delete",ids:ids,subid:"<%=subid%>"},function(datas){
				//doSearchsubmit();
				window.parent.closeWinAFrsh();
			});
		} else {
			Dialog.alert(wuiUtil.getJsonValueByIndex(dataObj, 1)) ;
		}
	});
}


function doSave(){
	if(!check_form(weaverA,'name,subCompanyId')){
		return;
	}
	var tname = $("#name").val();
	if(tname==null ||tname=="" || tname == "NULL" || tname == "Null" || tname == "null"){
		$("#checknameinfo").hide();
		check_form(weaverA,"name");
		return;
	}
	var oldname = $("#oldname").val();
	if(oldname != tname){
		$.post("/meeting/Maint/MeetingTypeCheck.jsp",{tname:encodeURIComponent(tname)},function(datas){ 							 
			if (datas.indexOf("exist") > 0){
				dlg.alert("<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%> [ "+tname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>!") ;
			} else {
				$('#weaverA').submit();
			}
		});
	} else {
		$('#weaverA').submit();
	}
}

function save(){
	$('#forwd').val("add");
	doSave();
}


function add(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 500;
	diag_vote.Height = 400;
	diag_vote.Modal = true;
 <% if("share".equals(method)) { %>
   //添加共享范围
    diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(19910, user.getLanguage())%>";
 	//diag_vote.URL = "/meeting/Maint/MeetingTypePrmsnAdd.jsp?dialog=1&attr=<%=method%>&mid=<%=id %>";
  <% } %>
 <% if("member".equals(method)) { %>
  //参会人员
  	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2106, user.getLanguage())%>";
  	//diag_vote.URL = "/meeting/Maint/MeetingTypeMbrAdd.jsp?dialog=1&attr=<%=method%>&mid=<%=id %>";
 <% } %>
 <% if("service".equals(method)) { %>
  //会议服务
    diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2107, user.getLanguage())%>";
    //diag_vote.URL = "/meeting/Maint/MeetingTypeSrvcAdd.jsp?dialog=1&attr=<%=method%>&mid=<%=id %>";
  	
 <% } %>
 <% if("caller".equals(method)) { %>
  //召集人
  	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2152, user.getLanguage())%>";
  	//diag_vote.URL = "/meeting/Maint/MeetingTypeCllrAdd.jsp?dialog=1&attr=<%=method%>&mid=<%=id %>";
 <% } %>
	diag_vote.URL = "/meeting/Maint/MeetingTypeOthAddTab.jsp?dialog=1&attr=<%=method%>&mid=<%=id %>&method=<%=method%>";
	diag_vote.show();
}

function onEdit(id){
    
	edtAttr(id);
}

function edtAttr(id){
  <% if("service".equals(method)) { %>
  //会议服务
  	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 500;
	diag_vote.Height = 400;
	diag_vote.Modal = true;
    diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2107, user.getLanguage())%>";
    diag_vote.URL = "/meeting/Maint/MeetingTypeOthAddTab.jsp?dialog=1&method=service&operate=srvcEdit&attr=<%=method%>&mid=<%=id %>&id="+id;
    diag_vote.show();
 <% } %>
 
	
}

function onDel(id){
    
	delAttr(id);
}

function delAttr(id){
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked"))			
				ids = ids +$(this).attr("checkboxId")+",";
		});
	} else {
		ids = id+",";
	}
	
	var noSelectWarn = "";
	var noConfirmWarn = "";
	<% if("share".equals(method)) { %>
      noSelectWarn = "<%=SystemEnv.getHtmlLabelNames("18214,82752",user.getLanguage())%>!";
      noConfirmWarn = "<%=SystemEnv.getHtmlLabelName(33475,user.getLanguage())%>";
  <% } %>
 <% if("member".equals(method)) { %>
  	  noSelectWarn = "<%=SystemEnv.getHtmlLabelName(20118,user.getLanguage())%>";
      noConfirmWarn = "<%=SystemEnv.getHtmlLabelName(33475,user.getLanguage())%>";
 <% } %>
 <% if("service".equals(method)) { %>
      noSelectWarn = "<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>!";
      noConfirmWarn = "<%=SystemEnv.getHtmlLabelName(33475,user.getLanguage())%>";
 <% } %>
 <% if("caller".equals(method)) { %>
  	 noSelectWarn = "<%=SystemEnv.getHtmlLabelNames("18214,2152",user.getLanguage())%>!";
      noConfirmWarn = "<%=SystemEnv.getHtmlLabelName(33475,user.getLanguage())%>";
 <% } %>
	
	if(ids=="") { 
		dlg.alert(noSelectWarn) ;
	} else {
		dlg.confirm(noConfirmWarn, function (){
		doDeleteAttr(ids);
		}, function () {}, 300, 90, true, null, null, null, null, null);
	}
}

function doDeleteAttr(ids){
	var methodp = "";
	<% if("share".equals(method)) { %>
      methodp = "prmDelete";
  	<% } %>
 	<% if("member".equals(method)) { %>
  	  methodp = "mbrDelete";
	 <% } %>
 	<% if("service".equals(method)) { %>
      methodp = "srvcDelete";
 	<% } %>
 	<% if("caller".equals(method)) { %>
  	  methodp = "cllrDelete";
 	<% } %>
	$.post("/meeting/Maint/MeetingTypeOperation.jsp",{method:methodp,ids:ids,mid:"<%=id%>"},function(datas){
		location='/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id=<%=id %>&method=<%=method%>';
	});
}

//关闭会议类型编辑页面并刷新列表
function closePrtDlgARfsh(){
	window.parent.closeWinAFrsh();
}

function closeDlgARfsh(){
	diag_vote.close();
	//diag_vote.closeByHand();
	location='/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id=<%=id %>&method=<%=method%>';
}
function addwf(title){
    var parentWin = parent.parent.getParentWindow(window.parent);
    var w= parentWin.document.body.offsetWidth-50;
    var h= parentWin.document.body.offsetHeight-50
    if(window.top.Dialog){
        dlg = new window.top.Dialog();
    } else {
        dlg = new Dialog();
    };
    dlg.currentWindow = window;
    dlg.Width = w;
    dlg.Height = h;
    dlg.Modal = true;
    dlg.Title = title;
    dlg.URL = "/workflow/workflow/addwf.jsp?isTemplate=0&iscreat=1&&isdialog=1";
    dlg.show();
}
</script>
