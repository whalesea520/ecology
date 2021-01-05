<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%@ page import="weaver.general.StaticObj" %>
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomTreeUtil" class="weaver.formmode.tree.CustomTreeUtil" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>

<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<body>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	//树形节点设置:编辑
	String titlename = SystemEnv.getHtmlLabelName(30216,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String sql = "";
	int mainid = Util.getIntValue(Util.null2String(request.getParameter("mainid")),0);
	int id = Util.getIntValue(Util.null2String(request.getParameter("id")),0);
	String modeid=Util.null2String(request.getParameter("modeid"));
	String nodename = Util.null2String(request.getParameter("nodename"));
	String nodedesc = Util.null2String(request.getParameter("nodedesc"));
	String tablename = Util.null2String(request.getParameter("tablename"));
	String tablekey = Util.null2String(request.getParameter("tablekey"));
	String tablesup = Util.null2String(request.getParameter("tablesup"));
	String showfield = Util.null2String(request.getParameter("showfield"));
	String nodeicon = Util.null2String(request.getParameter("nodeicon"));
	String supnodefield = Util.null2String(request.getParameter("supnodefield"));
	String hrefrelatefield = Util.null2String(request.getParameter("hrefrelatefield"));
	String nodefield = Util.null2String(request.getParameter("nodefield"));
	String iconField = Util.null2String(request.getParameter("iconField"));
	String dataorder = Util.null2String(request.getParameter("dataorder"));
	String datacondition = Util.null2String(request.getParameter("datacondition"));
	String hrefField = Util.null2String(request.getParameter("hrefField"));
	int supnode = Util.getIntValue(Util.null2String(request.getParameter("supnode")),0);
	int hreftype = Util.getIntValue(Util.null2String(request.getParameter("hreftype")),1);
	int hrefid = Util.getIntValue(Util.null2String(request.getParameter("hrefid")),0);
	String hreftarget = Util.null2String(request.getParameter("hreftarget"));
	double showorder = Util.getDoubleValue(request.getParameter("showorder"),1);
	int sourceid = Util.getIntValue(Util.null2String(request.getParameter("sourceid")),0);
	int sourcefrom = Util.getIntValue(Util.null2String(request.getParameter("sourcefrom")),0);
	int isshowrootnode = Util.getIntValue(Util.null2String(request.getParameter("isshowrootnode")),1);
	int iscontainssub = Util.getIntValue(Util.null2String(request.getParameter("iscontainssub")),0);
	String rootids = Util.null2String(request.getParameter("rootids"));
	
	if(id!=0){
		sql = "select * from mode_customtreedetail where id = " + id;
		rs.executeSql(sql);
		while(rs.next()){
			mainid = Util.getIntValue(Util.null2String(rs.getString("mainid")),0);
			modeid=Util.null2String(rs.getString("modeid"));
			nodename = Util.null2String(rs.getString("nodename"));
			nodedesc = Util.null2String(rs.getString("nodedesc"));
			tablename = Util.null2String(rs.getString("tablename"));
			tablekey = Util.null2String(rs.getString("tablekey"));
			tablesup = Util.null2String(rs.getString("tablesup"));
			showfield = Util.null2String(rs.getString("showfield"));
			nodeicon = Util.null2String(rs.getString("nodeicon"));
			supnodefield = Util.null2String(rs.getString("supnodefield"));
			hrefrelatefield = Util.null2String(rs.getString("hrefrelatefield"));
			nodefield = Util.null2String(rs.getString("nodefield"));
			supnode = Util.getIntValue(Util.null2String(rs.getString("supnode")),0);
			hreftype = Util.getIntValue(Util.null2String(rs.getString("hreftype")),1);
			hrefid = Util.getIntValue(Util.null2String(rs.getString("hrefid")),0);
			hreftarget = Util.null2String(rs.getString("hreftarget"));
			showorder = Util.getDoubleValue(rs.getString("showorder"),1);
			sourceid = Util.getIntValue(Util.null2String(rs.getString("sourceid")),0);
			sourcefrom = Util.getIntValue(Util.null2String(rs.getString("sourcefrom")),0);
			iconField = Util.null2String(rs.getString("iconField"));
			dataorder = Util.null2String(rs.getString("dataorder"));
			datacondition = Util.null2String(rs.getString("datacondition"));
			hrefField = Util.null2String(rs.getString("hrefField"));
			rootids = Util.null2String(rs.getString("rootids"));
			isshowrootnode = Util.getIntValue(Util.null2String(rs.getString("isshowrootnode")),1);
			iscontainssub = Util.getIntValue(Util.null2String(rs.getString("iscontainssub")),0);
		}
		
		if(supnode!=0){//存在上级节点时，根节点一律更新为显示
			String updateSql = "update mode_customtreedetail set isshowrootnode=1 where id="+id;
			rs.executeSql(updateSql);
			isshowrootnode = 1;
		}
	}
	//out.println(sourceid+"	"+sourcefrom);
	String sourcename = InterfaceTransmethod.getHrefName(String.valueOf(sourceid), String.valueOf(sourcefrom));
	String hrefname = InterfaceTransmethod.getHrefName(String.valueOf(hrefid), String.valueOf(hreftype));
	
	String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_customtree a,modeTreeField b WHERE a.appid=b.id AND a.id="+mainid;
	RecordSet recordSet = new RecordSet();
	recordSet.executeSql(subCompanyIdsql);
	int subCompanyId = -1;
	if(recordSet.next()){
		subCompanyId = recordSet.getInt("subCompanyId");
	}
	String userRightStr = "FORMMODEAPP:ALL";
	Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
	int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
	subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){//保存
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
String editType = "add";
if(id!=0){
	editType = "edit";
	if(operatelevel>1){//删除
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDel(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:doBack(),_self} " ;//返回
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


	<form name="frmSearch" method="post" action="/formmode/setup/customTreeNodeAction.jsp" enctype="multipart/form-data">
		<input type="hidden" id="operation" name="operation" value="<%=editType %>">
		<input type="hidden" id="id" name="id" value="<%=id%>">
		<input type="hidden" id="mainid" name="mainid" value="<%=mainid%>">
		<table class="e8_tblForm">
			<tr>
				<td class="e8_tblForm_label" width="20%">
					<!-- 名称 -->
					<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<input class="inputstyle" id="nodename" name="nodename" type="text" value="<%=nodename%>" style="width:80%"  maxlength="100" onblur="checkinput2('nodename','nodenamespan',1)">
					<span id="nodenamespan">
						<%
							if(nodename.equals("")) {
						%>
								<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
						<%
							}
						%>
					</span>
				</td>
			</tr>			
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 数据来源 -->
					<%=SystemEnv.getHtmlLabelName(28006,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<select id="sourcefrom" name="sourcefrom" onchange="SourceFromChange()">
						<option value="1" <%if(sourcefrom==1)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%></option><!-- 模块 -->
						<option value="2" <%if(sourcefrom==2)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(30176,user.getLanguage())%></option><!-- 手动输入 -->
					</select>
				</td>
			</tr>
			
			
			<tr id="sourceidtr">
				<td class="e8_tblForm_label">
					<!-- 选择数据来源 -->
					<%=SystemEnv.getHtmlLabelName(30223,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
				<%
					String tempTitle = SystemEnv.getHtmlLabelNames("18214,28006",user.getLanguage());
					String sourceidBrowserValue = sourceid==0?"":""+sourceid;
				%>
					<brow:browser viewType="0" id="sourceid" name="sourceid" browserValue='<%=sourceidBrowserValue%>' 
  		 				browserUrl="/systeminfo/BrowserMain.jsp?othercallback=getSourceTableName&url=/formmode/browser/ModeBrowser.jsp?titleid=1"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="2"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="510px" tempTitle="<%=tempTitle %>"
						browserSpanValue="<%=sourcename %>"
						></brow:browser>
						
				</td>
			</tr>
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 表名 -->
					<%=SystemEnv.getHtmlLabelName(21900,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<input class="inputstyle" id="tablename" name="tablename" type="text" value="<%=tablename%>" style="width:80%" maxlength="50" onblur="checkinput2('tablename','tablenamespan',1)">
					<span id="tablenamespan">
						<%
							if(tablename.equals("")) {
						%>
								<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
						<%
							}
						%>
					</span>
				</td>
			</tr>
			
			<tr <%if(supnode!=0){%>style="display:none;"<%} %>>
				<td class="e8_tblForm_label">
					<%=SystemEnv.getHtmlLabelName(82076,user.getLanguage())%><!-- 根节点主键的值 -->
				</td>
				<td class=e8_tblForm_field>
					<input class="inputstyle" id="rootids" name="rootids" type="text" value="<%=rootids %>" style="width:80%" maxlength="50" >
					<table>
						<tr>
							<td>
								<span title='<%=SystemEnv.getHtmlLabelName(82350,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82351,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82352,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82353,user.getLanguage())%>&#10;' id="remind">
									<img align="absMiddle" src="/images/remind_wev8.png">
								</span>
							</td>
							<td style="padding-left: 5px;">
								<%=SystemEnv.getHtmlLabelName(82077,user.getLanguage())%><!-- 多个值使用英文逗号隔开 -->
							</td>
						</tr>
					</table>
					
				</td>
			</tr>
			<!-- 存在上级节点时，此选项隐藏 -->
			<tr <%if(supnode!=0){%>style="display:none;"<%} %>>
				<td class="e8_tblForm_label">
					<%=SystemEnv.getHtmlLabelName(82078,user.getLanguage())%><!-- 是否显示根节点 -->
				</td>
				<td class=e8_tblForm_field>
				<%if(supnode!=0){%><!-- 存在上级节点时，一律显示根节点 -->
					<input type="hidden" name="isshowrootnode" id="isshowrootnode"  value="1" />
				<%}else{%>
					<input type="checkbox" name="isshowrootnode" id="isshowrootnode" onclick="changeboxVal('isshowrootnode')" value="<%=isshowrootnode %>" <%if(isshowrootnode==1){%>checked<%} %> />
				<%}%>
				</td>
			</tr>
			<tr>
				<td class="e8_tblForm_label">
					<!-- 主键 -->
					<%=SystemEnv.getHtmlLabelName(21027,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<%
					String tablekeSpanStr = "";
						if(!tablekey.equals("")) {
							tablekeSpanStr = CustomTreeUtil.getShowHrefField(tablekey,sourcefrom,sourceid,tablename);
						}
						
				    String antempTitle = SystemEnv.getHtmlLabelNames("18214,21027",user.getLanguage());
					%>
					
					<brow:browser viewType="0" id="tablekey" name="tablekey" browserValue="<%=tablekey%>" 
  		 				browserUrl="'+getShowUrl(1,1)+'"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="2"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="510px" tempTitle="<%=antempTitle %>"
						browserSpanValue="<%=tablekeSpanStr %>"
						></brow:browser>
					<table>
						<tr>
							<td style="padding-left: 5px; padding-top: 5px;">
								<!-- 主键字段内容不能包含中文 -->
								<%=SystemEnv.getHtmlLabelName(125152,user.getLanguage())%>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 上级 -->
					<%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<%
					String tempTitle3 = SystemEnv.getHtmlLabelNames("18214,596",user.getLanguage());
					%>
					<brow:browser viewType="0" id="tablesup" name="tablesup" browserValue="<%=tablesup%>" 
  		 				browserUrl="'+getShowUrl(1,2)+'"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="510px" tempTitle="<%=tempTitle3 %>"
						browserSpanValue="<%=CustomTreeUtil.getShowHrefField(tablesup,sourcefrom,sourceid,tablename) %>"
						></brow:browser>
				</td>
			</tr>
			
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 显示名 -->
					<%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%>
				</td>
				<td class="e8_tblForm_field">
				<%
				String tempTitle4 = SystemEnv.getHtmlLabelNames("18214,606",user.getLanguage());
				%>
					<brow:browser viewType="0" id="showfield" name="showfield" browserValue="<%=showfield%>" 
  		 				browserUrl="'+getShowUrl(1,3)+'"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="2"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="510px" tempTitle="<%=tempTitle4 %>"
						browserSpanValue="<%=CustomTreeUtil.getShowHrefField(showfield,sourcefrom,sourceid,tablename) %>"
						></brow:browser>
				</td>
			</tr>
			
			
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 链接目标来源-->
					<%=SystemEnv.getHtmlLabelName(30174,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<select id="hreftype" name="hreftype" onchange="onHrefTypeChange(this)">
						<option value="1" <%if(hreftype==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%></option><!-- 模块-->
						<option value="3" <%if(hreftype==3) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(30175,user.getLanguage())%></option><!-- 模块查询列表-->
						<option value="2" <%if(hreftype==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(30176,user.getLanguage())%></option><!-- 手动输入-->
					</select>
				</td>
			</tr>
			
	
			<tr id="hrefidtr">
				<td class="e8_tblForm_label">
					<!-- 选择链接目标-->
					<%=SystemEnv.getHtmlLabelName(30177,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
			  		 <%
			  		 	String tempTitle5 = SystemEnv.getHtmlLabelNames("18214,30181",user.getLanguage());
			  		 	String hrefidBrowserValue = hrefid==0?"":""+hrefid;
			  		 %>
			  		 <brow:browser viewType="0" id="hrefid" name="hrefid" browserValue="<%=hrefidBrowserValue%>"
  		 				browserUrl="'+getShowHrefTargetUrl()+'"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="510px" tempTitle="<%=tempTitle5 %>"
						browserSpanValue="<%=hrefname %>"
						></brow:browser>
						
				</td>
			</tr>
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 链接目标地址-->
					<%=SystemEnv.getHtmlLabelName(30178,user.getLanguage())%>
					<br/><!-- （默认地址） -->
					<%=SystemEnv.getHtmlLabelName(81450,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<textarea id="hreftarget" name="hreftarget" class="inputstyle" rows="3" style="width:80%;overflow:auto;" onblur="checkinput2('hreftarget','hreftargetspan',1)"><%=hreftarget%></textarea>
					<span id="hreftargetspan">
						<%
							if(hreftarget.equals("")){
						%>
								<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
						<%
							}
						%>
					</span>
					<table>
						<tr>
							<td>
								<span title='<%=SystemEnv.getHtmlLabelName(82354,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82357,user.getLanguage())%>[{id:0,url:"/a.jsp"},{id:1,url:"/b.jsp",sqlwhere:"id in (2,3)"}]&#10;<%=SystemEnv.getHtmlLabelName(82355,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82356,user.getLanguage())%>&#10;' id="remind">
									<img align="absMiddle" src="/images/remind_wev8.png">
								</span>
							</td>
							<td style="padding-left: 5px;">
								<!-- 如果链接目标地址不是手动输入地址，请勿随意修改这个字地址-->
								<%=SystemEnv.getHtmlLabelName(30179,user.getLanguage())%>
							</td>
						</tr>
					</table>
					
				</td>
			</tr>
			

			<tr id="hrefrelatefieldtr">
				<td class="e8_tblForm_label">
					<!-- 链接目标关联字段-->
					<%=SystemEnv.getHtmlLabelName(30222,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<%
			  		 	String tempTitle6 = SystemEnv.getHtmlLabelNames("18214,30222",user.getLanguage());
			  		 %>
					<brow:browser viewType="0" id="hrefrelatefield" name="hrefrelatefield" browserValue="<%=hrefrelatefield%>" 
  		 				browserUrl="'+getShowRelateFieldUrl()+'"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="510px" tempTitle="<%=tempTitle6 %>"
						browserSpanValue="<%=CustomTreeUtil.getShowHrefRelateField(hrefrelatefield,hreftype,hrefid) %>"
						></brow:browser>
				</td>
			</tr>
			
			<tr id="iscontainssubTr">
				<td class="e8_tblForm_label">
					<!-- 是否包含下级的值-->
					<%=SystemEnv.getHtmlLabelName(84233,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<input type="checkbox" name="iscontainssub" id="iscontainssub" onclick="changeboxVal('iscontainssub')" value="<%=iscontainssub %>" <%if(iscontainssub==1){%>checked<%} %> />
					<br />
					<%=SystemEnv.getHtmlLabelName(84234,user.getLanguage())+SystemEnv.getHtmlLabelName(84235,user.getLanguage())%>
				</td>
			</tr>
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 链接目标地址字段  -->
					<%=SystemEnv.getHtmlLabelName(81451,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<%
						String tempTitle7 = SystemEnv.getHtmlLabelNames("18214,30178,83842",user.getLanguage());
					%>
					<brow:browser viewType="0" id="hrefField" name="hrefField" browserValue="<%=hrefField%>" 
  		 				browserUrl="'+getShowUrl(4,4)+'"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="510px" tempTitle="<%=tempTitle7 %>"
						browserSpanValue="<%=CustomTreeUtil.getShowHrefField(hrefField,sourcefrom,sourceid,tablename) %>"
						></brow:browser>
				</td>
			</tr>
			
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 图标-->
					<%=SystemEnv.getHtmlLabelName(81442,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<input class="inputstyle" id="oldnodeicon" name="oldnodeicon" type="hidden" value="<%=nodeicon%>">
					<input class="inputstyle" id="nodeicon" name="nodeicon" type="file" value="<%=nodeicon%>" size="30" onchange="selectImg(this)">
					(16 * 16)
					<span id="oldimg">
						<%
							if(!nodeicon.equals("")&&!nodeicon.equals("0")) {
						%>
								<img src="/weaver/weaver.file.FileDownload?fileid=<%=nodeicon%>">
						<%
							}
						%>
					</span>
					&nbsp;
					<span id="delspan">
						<a href="javascript:void(0)" onclick="javascript:delNodeIcon()"><%=SystemEnv.getHtmlLabelName(30227,user.getLanguage())%></a><!-- 删除节点图标 -->
					</span>
				</td>
			</tr>
			
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 节点图标字段  -->
					<%=SystemEnv.getHtmlLabelName(81443,user.getLanguage())%>
				</td>
				<td class="e8_tblForm_field">
				<%
					String tempTitle8 = SystemEnv.getHtmlLabelNames("18214,81443",user.getLanguage());
				%>
					<brow:browser viewType="0" id="iconField" name="iconField" browserValue="<%=iconField%>" 
  		 				browserUrl="'+getShowUrl(5,5)+'"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="510px" tempTitle="<%=tempTitle8 %>"
						browserSpanValue="<%=CustomTreeUtil.getShowHrefField(iconField,sourcefrom,sourceid,tablename) %>"
						></brow:browser>
				</td>
			</tr>
			
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 数据显示顺序  -->
					<%=SystemEnv.getHtmlLabelName(81444,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<textarea id="dataorder" name="dataorder" class="inputstyle" maxlength="1000" rows="3" style="width:80%;overflow:auto;"><%=dataorder%></textarea>
					<span id="dataorderspan">
					</span>
					<br/>
					<%=SystemEnv.getHtmlLabelName(81446,user.getLanguage())%><!-- 数据显示顺序格式为：c desc,d asc，其中c,d为表字段名 -->
				</td>
			</tr>
			
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 数据显示条件  -->
					<%=SystemEnv.getHtmlLabelName(81445,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<textarea id="datacondition" name="datacondition" class="inputstyle" maxlength="4000" rows="3" style="width:80%;overflow:auto;"><%=datacondition%></textarea>
					<span id="dataconditionspan">
					</span>
					<table>
						<tr>
							<td>
								<span title='<%=SystemEnv.getHtmlLabelName(82350,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82351,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82352,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82462,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82463,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82464,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82465,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(382960,user.getLanguage())%>&#10;' id="remind">
									<img align="absMiddle" src="/images/remind_wev8.png">
								</span>
							</td>
							<td style="padding-left: 5px;">
								<%=SystemEnv.getHtmlLabelName(81447,user.getLanguage())%><!-- 数据显示条件格式为：a='1' and b='2'，其中a,b为表字段名 -->
							</td>
						</tr>
					</table>
					
				</td>
			</tr>
			
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 上级节点 -->
					<%=SystemEnv.getHtmlLabelName(30217,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<select id="supnode" name="supnode" >
						<option value="0">&nbsp;&nbsp;&nbsp;&nbsp;</option>
						<%
							sql = "select * from mode_customtreedetail where mainid = " + mainid + " and id <> " + id;
							rs.executeSql(sql);
							while(rs.next()){
								int tempid = rs.getInt("id");
								String tempnodename = rs.getString("nodename");
						%>
								<option value="<%=tempid%>" <%if(supnode==tempid)out.println("selected"); %>><%=tempnodename%></option>
						<%		
							}
						%>
					</select>
				</td>
			</tr>
			
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 上下级节点关联字段 -->
					<%=SystemEnv.getHtmlLabelName(30218,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<table>
						<tr>
							<!-- 本节点字段 -->
							<td><%=SystemEnv.getHtmlLabelName(30219,user.getLanguage())%></td>
							<td>
							<%
								String tempTitle9 = SystemEnv.getHtmlLabelNames("18214,30219",user.getLanguage());
							%>
								<brow:browser viewType="0" id="nodefield" name="nodefield" browserValue="<%=nodefield%>" 
			  		 				browserUrl="'+getShowUrl(1,6)+'"
									hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
									completeUrl="/data.jsp" linkUrl=""  width="228px"
									browserDialogWidth="510px" tempTitle="<%=tempTitle9 %>"
									browserSpanValue="<%=CustomTreeUtil.getShowHrefField(nodefield,sourcefrom,sourceid,tablename) %>"
									></brow:browser>
						
							</td>
						</tr>
						<tr>
							<!-- 上级节点字段 -->
							<td><%=SystemEnv.getHtmlLabelName(30220,user.getLanguage())%></td>
							<td>
							<%
								String tempTitle10 = SystemEnv.getHtmlLabelNames("18214,30220",user.getLanguage());
							%>	
								<brow:browser viewType="0" id="supnodefield" name="supnodefield" browserValue="<%=supnodefield%>" 
			  		 				browserUrl="'+getShowSupFieldUrl(7)+'"
									hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
									completeUrl="/data.jsp" linkUrl=""  width="228px"
									browserDialogWidth="510px" tempTitle="<%=tempTitle10 %>"
									browserSpanValue="<%=CustomTreeUtil.getShowSupField(supnode,supnodefield) %>"
									></brow:browser>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 显示顺序-->
					<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<input class="inputstyle" type="text" name="showorder" id="showorder" value="<%=showorder%>" size="5" onkeypress="ItemDecimal_KeyPress('showorder',15,2)" onblur="checknumber1(this);">
				</td>
			</tr>
			
			<tr>
				<td class="e8_tblForm_label">
					<!-- 描述 -->
					<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
				</td>
				<td class=e8_tblForm_field>
					<input class="inputstyle" id="nodedesc" name="nodedesc" type="text" value="<%=nodedesc%>" style="width:80%" maxlength="2000">
					<span id="nodedescspan">
					</span>
				</td>
			</tr>
		</table>
	</form>

<script type="text/javascript">

function checkFieldValue(ids){
	var idsArr = ids.split(",");
	for(var i=0;i<idsArr.length;i++){
		var obj = document.getElementById(idsArr[i]);
		if(obj&&obj.value==""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
			return false;
		}
	}
	return true;
}

    function doSubmit(){
        var supnode = $("#supnode").val();      
        if(supnode != "0"){
           $("#rootids").val("");
        }
		if(checkFieldValue("nodename,tablename,tablekey,showfield,hreftarget")){
	        enableAllmenu();
	        document.frmSearch.operation.value = "<%=editType%>";
	        document.frmSearch.submit();			
		}
    }
    function doBack(){
        location.href = "/formmode/setup/customTreeBase.jsp?id=<%=mainid%>";
    }
    function doDel(){
    	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			enableAllmenu();
        	document.frmSearch.operation.value = "del";
        	document.frmSearch.submit();
		});
    }

    function selectImg(obj){
		if(obj.value==""){
			$("#oldimg").html("");
		}else{
			//$("#oldimg").html("<img border=0 src="+obj.value+">");
		}
	}

    function delNodeIcon(){
    	$("#oldimg").html("");
    	$("#oldnodeicon").val("");   
    	$("#nodeicon").val(""); 	
    	//var objFile = document.getElementById('nodeicon');
    	//objFile.outerHTML=objFile.outerHTML.replace(/(value=\").+\"/i,"$1\""); 
	}

    function onShowSourceTarget(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
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
    	getSourceTableName();
    }
    
    function getShowUrl(from,titleid){
    	var url = "";
		var sourcefrom = jQuery("select[name=sourcefrom]").val();
		var sourceid = jQuery("input[name=sourceid]").val();
		var tablename = jQuery("input[name=tablename]").val();
		url = "/formmode/tree/ModeFieldBrowser.jsp?sourcefrom="+sourcefrom+"&sourceid="+sourceid+"&tablename="+tablename+"&from="+from+"&titleid="+titleid;
		url = "/systeminfo/BrowserMain.jsp?url="+escape(url);
		return url;
    }

    function onShowHrefField(inputName, spanName,ismand,from){
        var url = "";
		var sourcefrom = jQuery("select[name=sourcefrom]").val();
		var sourceid = jQuery("input[name=sourceid]").val();
		var tablename = jQuery("input[name=tablename]").val();
		url = "/formmode/tree/ModeFieldBrowser.jsp?sourcefrom="+sourcefrom+"&sourceid="+sourceid+"&tablename="+tablename+"&&from="+from;
		url = "/systeminfo/BrowserMain.jsp?url="+escape(url);
    	var datas = window.showModalDialog(url);
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
   		    	$(spanName).html(datas.name);
    	    }else{
    		    $(inputName).val("");
    		    if(ismand=="1"){
    				$(spanName).html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\"/>");
    		    }else{
    		    	$(spanName).html("");
				}
    		}
    	} 
    }
    
    function getShowRelateFieldUrl(){
    	var url = "";
		var hreftype = jQuery("select[name=hreftype]").val();
		var hrefid = jQuery("input[name=hrefid]").val();
		if(hreftype=="1"){//模块
			url = "/formmode/tree/ModeFieldBrowser.jsp?hreftype="+hreftype+"&hrefid="+hrefid+"&from=2"+"&titleid=8";
			url = "/systeminfo/BrowserMain.jsp?url="+escape(url);
		}else if(hreftype=="3"){//模块查询列表
			url = "/formmode/tree/ModeFieldBrowser.jsp?hreftype="+hreftype+"&hrefid="+hrefid+"&from=2"+"&titleid=8";
			url = "/systeminfo/BrowserMain.jsp?url="+escape(url);
		}
		return url;
    }

    function onShowRelateField(inputName, spanName){
        var url = "";
		var hreftype = jQuery("select[name=hreftype]").val();
		var hrefid = jQuery("input[name=hrefid]").val();
		if(hreftype=="1"){//模块
			url = "/formmode/tree/ModeFieldBrowser.jsp?hreftype="+hreftype+"&hrefid="+hrefid+"&from=2";
			url = "/systeminfo/BrowserMain.jsp?url="+escape(url);
		}else if(hreftype=="3"){//模块查询列表
			url = "/formmode/tree/ModeFieldBrowser.jsp?hreftype="+hreftype+"&hrefid="+hrefid+"&from=2";
			url = "/systeminfo/BrowserMain.jsp?url="+escape(url);
		}
    	var datas = window.showModalDialog(url);
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
   		    	$(spanName).html(datas.name);
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }
    
    function getShowSupFieldUrl(titleid){
    	var url = "";
		var supnode = jQuery("select[name=supnode]").val();
		url = "/formmode/tree/ModeFieldBrowser.jsp?supnode="+supnode+"&from=3"+"&titleid="+titleid;
		url = "/systeminfo/BrowserMain.jsp?url="+escape(url);
		return url;
    }

    function onShowSupField(inputName, spanName){
        var url = "";
		var supnode = jQuery("select[name=supnode]").val();
		url = "/formmode/tree/ModeFieldBrowser.jsp?supnode="+supnode+"&from=3";
		url = "/systeminfo/BrowserMain.jsp?url="+escape(url);
    	var datas = window.showModalDialog(url);
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
   		    	$(spanName).html(datas.name);
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }

	function getSourceTableName(json){
		var sourceid = jQuery("input[name=sourceid]").val();
		if(json&&json.id!=""){
			sourceid = json.id;
		}
		var sourcefrom = jQuery("select[name=sourcefrom]").val();
		if(sourcefrom!=""&&sourceid!=""){
			var url = "/formmode/tree/CustomTreeNodeAjax.jsp?sourcefrom="+sourcefrom+"&sourceid="+sourceid;
			jQuery.ajax({
				url : url,
				type : "post",
				processData : false,
				data : "",
				dataType : "text",
				async : true,
				success: function do4Success(msg){
					var tablename = jQuery.trim(msg);
					jQuery("#tablename").val(tablename);
					if(tablename==""){
						jQuery("#tablenamespan").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\"/>");
					}else{
						jQuery("#tablenamespan").html("");
					}
				}
			});
		}else{
			jQuery("#tablename").val("");
			jQuery("#tablenamespan").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\"/>");
		}
	}
	
	function getShowHrefTargetUrl(){
		var url = "/systeminfo/BrowserMain.jsp?othercallback=getHrefTarget&url=/formmode/browser/ModeBrowser.jsp?titleid=2";
		var hreftype = jQuery("select[name=hreftype]").val();
		var hrefid = jQuery("input[name=hrefid]").val();
		if(hreftype=="1"){//模块
			url = "/systeminfo/BrowserMain.jsp?othercallback=getHrefTarget&url=/formmode/browser/ModeBrowser.jsp?titleid=2";
		}else if(hreftype=="3"){//模块查询列表
			url = "/systeminfo/BrowserMain.jsp?othercallback=getHrefTarget&url=/formmode/search/CustomSearchBrowser.jsp";
		} 
		return url;
	}

    function onShowHrefTarget(inputName, spanName){
        var url = "/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp";
		var hreftype = jQuery("select[name=hreftype]").val();
		var hrefid = jQuery("input[name=hrefid]").val();
		if(hreftype=="1"){//模块
			url = "/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp";
		}else if(hreftype=="3"){//模块查询列表
			url = "/systeminfo/BrowserMain.jsp?url=/formmode/search/CustomSearchBrowser.jsp";
		} 
    	var datas = window.showModalDialog(url);
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
   		    	$(spanName).html(datas.name);
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	    getHrefTarget();
    	} 
    }
    
	function getHrefTarget(json){
		var hreftype = jQuery("select[name=hreftype]").val();
		var hrefid = jQuery("input[name=hrefid]").val();
		if(json&&json.id!=""){
			hrefid = json.id;
		}
		if(hreftype!=""&&hrefid!=""){
			var url = "/formmode/tree/CustomTreeUrlAjax.jsp?hrefid="+hrefid+"&hreftype="+hreftype;
			jQuery.ajax({
				url : url,
				type : "post",
				processData : false,
				data : "",
				dataType : "text",
				async : true,
				success: function do4Success(msg){
					var returnurl = jQuery.trim(msg);
					jQuery("#hreftarget").val(returnurl);
					if(returnurl==""){
						jQuery("#hreftargetspan").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\"/>");
					}else{
						jQuery("#hreftargetspan").html("");
					}
				}
			});
		}else{
			jQuery("#hreftarget").val("");
			jQuery("#hreftargetspan").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\"/>");
		}
	}
	
	function onShowTypeChange(){
		var showtype = jQuery("#showtype").val();
		var hreftype = jQuery("#hreftype").val();
		if(showtype=="1"){
			jQuery("#opentype").hide();
			jQuery("#opentypetr").hide();
			jQuery("#opentypelinetr").hide();
			jQuery("#relatedfieldtr").show();
			jQuery("#relatedfieldtrline").show();
		}else if(showtype=="2"){
			jQuery("#opentype").show();
			jQuery("#opentypetr").show();
			jQuery("#opentypelinetr").show();
			if(hreftype=="2"){
				jQuery("#relatedfieldtr").hide();
				jQuery("#relatedfieldtrline").hide();
			}
		}
	}
	
	function onHrefTypeChange(){
		var hreftype = jQuery("#hreftype").val();
		if(hreftype=="1"){
			jQuery("#hrefidtr").show();
			jQuery("#hrefidlinetr").show();
			jQuery("#hrefrelatefieldtr").show();
			jQuery("#hrefrelatefieldlinetr").show();
		}else if(hreftype=="2"){
			jQuery("#hrefidtr").hide();
			jQuery("#hrefidlinetr").hide();
			jQuery("#hrefid").val("");
			jQuery("#hrefidspan").html("");
			jQuery("#hrefrelatefield").val("");
			jQuery("#hrefrelatefieldtr").hide();
			jQuery("#hrefrelatefieldlinetr").hide();
		}else if(hreftype=="3"){
			jQuery("#hrefidtr").show();
			jQuery("#hrefidlinetr").show();
			jQuery("#hrefrelatefieldtr").show();
			jQuery("#hrefrelatefieldlinetr").show();
		}
		jQuery("#hrefid").val("");
		jQuery("#hrefidspan").html("");
		jQuery("#hreftarget").val("");
		jQuery("#hreftargetspan").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\"/>");
	}

	function SourceFromChange(){
		jQuery("#sourceid").val("");
		jQuery("#tablename").val("");
		jQuery("#sourceidspan").html("");
		jQuery("#tablenamespan").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\"/>");
		var sourcefrom = jQuery("select[name=sourcefrom]").val();
		if(sourcefrom==1){
			jQuery("#sourceidtr").show();
			jQuery("#sourceidlinetr").show();
		}else{
			jQuery("#sourceidtr").hide();
			jQuery("#sourceidlinetr").hide();
		}
	}

	function initload(){
		var sourcefrom = jQuery("select[name=sourcefrom]").val();
		if(sourcefrom==2){
			jQuery("#sourceidtr").hide();
			jQuery("#sourceidlinetr").hide();
		}

		var hreftype = jQuery("select[name=hreftype]").val();
		if(hreftype==2){
			jQuery("#hrefidtr").hide();
			jQuery("#hrefidlinetr").hide();
			jQuery("#hrefrelatefieldtr").hide();
			jQuery("#hrefrelatefieldlinetr").hide();
		}		
	}
	
	function changeboxVal(id){
		var checked = jQuery("#"+id).attr("checked");
		if(checked){
			jQuery("#"+id).val("1");
		}else{
			jQuery("#"+id).val("0");
		}
	}

	
	$(document).ready(function(){//onload事件
		initload();
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})
</script>

</BODY>
</HTML>
