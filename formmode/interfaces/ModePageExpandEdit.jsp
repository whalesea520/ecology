<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%@ page import="weaver.general.StaticObj" %>
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DMLActionBase" class="weaver.formmode.interfaces.dmlaction.commands.bases.DMLActionBase" scope="page" />
<jsp:useBean id="wsActionManager" class="weaver.formmode.interfaces.action.WSActionManager" scope="page" />
<jsp:useBean id="sapActionManager" class="weaver.formmode.interfaces.action.SapActionManager" scope="page" />
<jsp:useBean id="baseAction" class="weaver.formmode.interfaces.action.BaseAction" scope="page" />
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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
</HEAD>
<body>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(30090,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());//页面扩展:编辑
	String needfav ="1";
	String needhelp ="";
	
	String sql = "";
	int id = Util.getIntValue(Util.null2String(request.getParameter("id")),0);
	String modeid="";
	String modename = "";
	String expendname = Util.null2String(request.getParameter("expendname"));
	int showtype = Util.getIntValue(request.getParameter("showtype"),1);
	int opentype = Util.getIntValue(request.getParameter("opentype"),1);
	int hreftype = Util.getIntValue(request.getParameter("hreftype"),1);
	String hreftarget = Util.null2String(request.getParameter("hreftarget"));
	String showcondition = Util.null2String(request.getParameter("showcondition"));
	String showconditioncn = Util.null2String(request.getParameter("showconditioncn"));
	String listbatchname = Util.null2String(request.getParameter("listbatchname"));
	int isshow = Util.getIntValue(request.getParameter("isshow"),0);
	int hrefid = Util.getIntValue(request.getParameter("hrefid"),0);
	int issystem = Util.getIntValue(request.getParameter("issystem"),0);
	int issystemflag = Util.getIntValue(request.getParameter("issystemflag"),0);
	int isbatch = Util.getIntValue(request.getParameter("isbatch"),0);
	double showorder = Util.getDoubleValue(request.getParameter("showorder"),0);
	int createpage = Util.getIntValue(request.getParameter("createpage"),0);
	int managepage = Util.getIntValue(request.getParameter("managepage"),0);
	int viewpage = Util.getIntValue(request.getParameter("viewpage"),0);
	int moniterpage = Util.getIntValue(request.getParameter("moniterpage"),0);
	
	int formid = 0;
	sql = "select a.*,b.modename,b.formid from mode_pageexpand a,modeinfo b where a.modeid = b.id and a.id = " + id;
	rs.executeSql(sql);
	while(rs.next()){
		modeid = Util.null2String(rs.getString("modeid"));
		modename = Util.null2String(rs.getString("modename"));
		expendname = Util.null2String(rs.getString("expendname"));
		showtype = Util.getIntValue(rs.getString("showtype"),1);
		opentype = Util.getIntValue(rs.getString("opentype"),1);
		hreftype = Util.getIntValue(rs.getString("hreftype"),1);
		hreftarget = Util.null2String(rs.getString("hreftarget"));
		showcondition = Util.null2String(rs.getString("showcondition"));
		showconditioncn = Util.null2String(rs.getString("showconditioncn"));
		isshow = Util.getIntValue(rs.getString("isshow"),0);
		hrefid = Util.getIntValue(rs.getString("hrefid"),0);
		showorder = Util.getDoubleValue(rs.getString("showorder"),0);
		issystem = Util.getIntValue(rs.getString("issystem"),0);
		formid = Util.getIntValue(rs.getString("formid"),0);
		isbatch = Util.getIntValue(rs.getString("isbatch"),0);
		issystemflag = Util.getIntValue(rs.getString("issystemflag"),0);
		listbatchname = Util.null2String(rs.getString("listbatchname"));
		createpage = Util.getIntValue(rs.getString("createpage"),0);
		managepage = Util.getIntValue(rs.getString("managepage"),0);
		viewpage = Util.getIntValue(rs.getString("viewpage"),0);
		moniterpage = Util.getIntValue(rs.getString("moniterpage"),0);
	}
	boolean issystemmenu = (issystem==1);//是否为系统菜单
	String hrefname = InterfaceTransmethod.getHrefName(String.valueOf(hrefid), String.valueOf(hreftype));
	String showconditionspan=showconditioncn;
	//if(!showcondition.equals("")){
		//showconditionspan = "<img src=\"/images/BacoCheck_wev8.gif\" border=\"0\" complete=\"complete\"/>";
	//}
	
	int istriggerwf = Util.getIntValue(request.getParameter("istriggerwf"),0);
	String interfaceaction = Util.null2String(request.getParameter("interfaceaction"));
	sql = "select mainid,interfacetype,interfacevalue from mode_pageexpanddetail where mainid = " + id;
	rs.executeSql(sql);
	while(rs.next()){
		String interfacetype = Util.null2String(rs.getString("interfacetype"));
		String interfacevalue = Util.null2String(rs.getString("interfacevalue"));
		if(interfacetype.equals("1")){
			istriggerwf =  Util.getIntValue(interfacevalue,0);
		}else if(interfacetype.equals("2")){
			interfaceaction =  interfacevalue;
		}
	}
	
	
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(issystem!=1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDelete(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:doBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
	<form name="frmSearch" method="post" action="/formmode/interfaces/ModePageExpandOperation.jsp">
		<input type="hidden" id="operation" name="operation" value="edit">
		<input type="hidden" id="id" name="id" value="<%=id%>">
		<input type="hidden" id="issystem" name="issystem" value="<%=issystem%>">
		<table class="ViewForm">
			<COLGROUP>
				<COL width="15%">
				<COL width="85%">
			</COLGROUP>
			<TR>
				<TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></B></TD><!-- 基本信息 -->
			</TR>
			<tr style="height:1px"><td colspan=4 class=Line1></td></tr>
		
			<tr>
				<td>
					<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%><!-- 模块名称 -->
				</td>
				<td class="Field">
			  		 <!-- button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></button-->
			  		 <span id=modeidspan><%=modename%></span>
			  		 <input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
				</td>
			</tr>
			<tr style="height:1px"><td colspan=2 class=Line></td></tr>
			<tr>
				<td>
					<!-- 扩展类型 -->
					<%=SystemEnv.getHtmlLabelName(81468,user.getLanguage())%>
				</td>
				<td class=Field>
					<%
						if(issystem==1){
					%>
							<%=SystemEnv.getHtmlLabelName(28119,user.getLanguage())%><!-- 系统默认 -->
					<%
						}else{
					%>
							<%=SystemEnv.getHtmlLabelName(73,user.getLanguage())%><!-- 用户自定义 -->
					<%
						}
					%>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=2 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 扩展用途 -->
					<%=SystemEnv.getHtmlLabelName(81469,user.getLanguage())%>
				</td>
				<td class=Field>
					<%
						if(issystem==1){
							if(isbatch==0){
					%>
								<%=SystemEnv.getHtmlLabelName(81470,user.getLanguage())%><!-- 卡片页面 -->
					<%			
							}else if(isbatch==1){
					%>
								<%=SystemEnv.getHtmlLabelName(81471,user.getLanguage())%><!-- 查询列表(批量操作) -->
					<%
							}else if(isbatch==2){
					%>
								<%=SystemEnv.getHtmlLabelName(81510,user.getLanguage())%><!-- 卡片页面和查询列表 -->
					<%
							}
					%>
							<input type="hidden" id="isbatch" name="isbatch" value="<%=isbatch%>">
					<%
						}else{
					%>
							<select id="isbatch" name="isbatch" onchange="changeIsBatch(this)">
								<option value="0" <%if(isbatch==0)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(81470,user.getLanguage())%></option>
								<option value="1" <%if(isbatch==1)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(81471,user.getLanguage())%></option>
								<option value="2" <%if(isbatch==2)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(81510,user.getLanguage())%></option>
							</select>
					<%
						}
					%>
					<%
						if(issystem!=1){
					%>
							<div id="pageselect">
								<input class="inputstyle" type="checkbox" id="createpage" name="createpage" value="1" <%if(createpage==1)out.println("checked"); %>><%=SystemEnv.getHtmlLabelName(31134,user.getLanguage())%><!-- 新建页面 -->
								<input class="inputstyle" type="checkbox" id="managepage" name="managepage" value="1" <%if(managepage==1)out.println("checked"); %>><%=SystemEnv.getHtmlLabelName(31135,user.getLanguage())%><!-- 编辑页面 -->
								<input class="inputstyle" type="checkbox" id="viewpage" name="viewpage" value="1" <%if(viewpage==1)out.println("checked"); %>><%=SystemEnv.getHtmlLabelName(31136,user.getLanguage())%><!-- 查看页面 -->
							</div>
					<%
						}
					%>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=2 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 扩展名称 -->
					<%=SystemEnv.getHtmlLabelName(30170,user.getLanguage())%>
				</td>
				<td class=Field>
					<input class="inputstyle" id="expendname" name="expendname" type="text" value="<%=expendname%>" size="30" maxlength="100" onblur="checkinput2('expendname','expendnamespan',1)">
					<%=InterfaceTransmethod.getExpandNameNoHref(String.valueOf(issystem),String.valueOf(issystemflag),user.getLanguage())%>
					<span id="expendnamespan">
						<%
							if(expendname.equals("")) {
						%>
								<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
						<%
							}
						%>
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<%
				if(!issystemmenu){
			%>
					<tr>
						<td>
							<!-- 显示样式 -->
							<%=SystemEnv.getHtmlLabelName(23724,user.getLanguage())%>
						</td>
						<td class=Field>
							<select id="showtype" name="showtype" onchange="onShowTypeChange(this)">
								<option value="1" <%if(showtype==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(30171,user.getLanguage())%></option><!-- Tab页面 -->
								<option value="2" <%if(showtype==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(30172,user.getLanguage())%></option><!-- 鼠标右键 -->
							</select>
						</td>
					</tr>
					<tr style="height:1px"><td colspan=4 class=Line></td></tr>
					
					<tr id="opentypetr">
						<td>
							<!-- 打开方式-->
							<%=SystemEnv.getHtmlLabelName(30173,user.getLanguage())%>
						</td>
						<td class=Field>
							<select id="opentype" name="opentype">
								<option value="1" <%if(opentype==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%></option><!-- 默认窗口-->
								<option value="2" <%if(opentype==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option><!-- 弹出窗口-->
								<option value="3" <%if(opentype==3) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option><!-- 其它-->
							</select>
						</td>
					</tr>
					<tr id="opentypelinetr" style="height:1px"><td colspan=4 class=Line></td></tr>
			
					<tr>
						<td>
							<!-- 链接目标来源-->
							<%=SystemEnv.getHtmlLabelName(30174,user.getLanguage())%>
						</td>
						<td class=Field>
							<select id="hreftype" name="hreftype" onchange="onHrefTypeChange(this)">
								<option value="1" <%if(hreftype==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%></option><!-- 模块-->
								<option value="3" <%if(hreftype==3) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(30175,user.getLanguage())%></option><!-- 模块查询列表-->
								<option value="2" <%if(hreftype==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(30176,user.getLanguage())%></option><!-- 手动输入-->
							</select>
						</td>
					</tr>
					<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
					<tr id="hrefidtr">
						<td>
							<!-- 选择链接目标-->
							<%=SystemEnv.getHtmlLabelName(30177,user.getLanguage())%>
						</td>
						<td class=Field>
					  		 <button type="button" class="Browser" id="hrefidSelect" name="hrefidSelect" onClick="onShowHrefTarget(hrefid,hrefidspan)"></BUTTON>
					  		 <input type="hidden" name="hrefid" id="hrefid" value="<%=hrefid%>">
					  		 <span id="hrefidspan"><%=hrefname%></span>
						</td>
					</tr>
					<tr id="hrefidlinetr" style="height:1px"><td colspan=4 class=Line></td></tr>
					
					<tr>
						<td>
							<!-- 链接目标地址-->
							<%=SystemEnv.getHtmlLabelName(30178,user.getLanguage())%>
						</td>
						<td class=Field>
							<textarea id="hreftarget" name="hreftarget" class="inputstyle" rows="10" style="width:70%"><%=hreftarget%></textarea>
							<br>
							<!-- 如果链接目标地址不是手动输入地址，请勿随意修改这个字地址-->
							<%=SystemEnv.getHtmlLabelName(30179,user.getLanguage())%>
						</td>
					</tr>
					<tr style="height:1px"><td colspan=4 class=Line></td></tr>
					
					<tr id="relatedfieldtr">
						<td>
							<!-- 关联字段 -->
							<%=SystemEnv.getHtmlLabelName(30180,user.getLanguage())%>
						</td>
						<td class=Field>
							<span id="relatedfield">
								<a href="javascript:detailSet()"><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%><!-- 设置 --></a>
							</span>
						</td>
					</tr>
					<tr id="relatedfieldtrline" style="height:1px"><td colspan=4 class=Line></td></tr>
			<%
				}else{
			%>
					<tr style="display:none">
						<td>
							<!-- 显示样式 -->
							<input type="hidden" id="showtype" name="showtype" value="<%=showtype%>">
							<!-- 打开方式-->
							<input type="hidden" id="opentype" name="opentype" value="<%=opentype%>">
							<!-- 链接目标来源-->
							<input type="hidden" id="hreftype" name="hreftype" value="<%=hreftype%>">
							<!-- 选择链接目标-->
							<input type="hidden" id="hrefid" name="hrefid" value="<%=hrefid%>">
							<!-- 链接目标地址-->
							<textarea id="hreftarget" name="hreftarget" class="inputstyle" rows="10" style="width:70%"><%=hreftarget%></textarea>
						</td>
					</tr>
			<%
				}
			%>
	
			<tr>
				<td>
					<!-- 是否显示	-->
					<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%>
				</td>
				<td class=Field>
					<input class="inputstyle" type="checkbox" id="isshow" name="isshow" value="1" <%if(isshow==1) out.println("checked");%>>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
	
			<tr>
				<td>
					<!-- 显示条件 -->
					<%=SystemEnv.getHtmlLabelName(19496,user.getLanguage())%>
				</td>
				<td class=Field>
					<button type="button" class="Browser" id="showconditionSelect" name="showconditionSelect" onClick="onShowCondition(showconditionspan)"></BUTTON>
					<span id="showconditionspan"><%=showconditionspan%></span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 显示顺序-->
					<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%>
				</td>
				<td class=Field>
					<input class="inputstyle" type="text" name="showorder" id="showorder" value="<%=showorder%>" size="5" onkeypress="ItemDecimal_KeyPress('showorder',15,2)" onblur="checknumber1(this);">
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<TR>
				<TD colSpan=2>
					<B>
						<!-- 接口动作-->
						<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%>						
					</B>
				</TD>
			</TR>
			<tr style="height:1px"><td colspan=4 class=Line1></td></tr>

			<%
				//if(expendname.indexOf("保存")>-1){
			%>
				<tr>
					<td>
						<%=SystemEnv.getHtmlLabelName(81457,user.getLanguage())%><!-- 是否触发审批工作流  -->
					</td>
					<td class=Field>
						 <input class="inputstyle" type="checkbox" id="istriggerwf" name="istriggerwf" value="1" <%if(istriggerwf==1)out.println("checked"); %>>
					</td>
				</tr>
				<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			<%
				//}
			%>

			<tr>
				<td class="header">
					<%=SystemEnv.getHtmlLabelName(81456,user.getLanguage())%><!-- 外部接口动作 -->
				</td>
				<td class=Field>
					<select id="interfaceaction" name="interfaceaction">
						<option value="" selected></option>
					<%
						String customeraction = "";
					    List l=StaticObj.getServiceIds(Action.class);
						if(!interfaceaction.equals("")){
					%>
						<option value='<%=interfaceaction%>' selected><%=interfaceaction%></option>
					<%
						}
						for(int i=0;i<l.size();i++){
					      	if(l.get(i).equals(interfaceaction)){
								continue;
							}
					%>
							<option value='<%=l.get(i)%>'><%=l.get(i)%></option>
					<%
						}
					%>
					</select>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>

			<tr><td colspan="3">
			<table width="100%" class="liststyle" cellspacing="1"  >
				<COLGROUP>
				<COL width="5%">
				<COL width="35%">
				<COL width="35%">
				<COL width="25%">
				<TR class="Spacing" style="height: 1px;"><TD class="Line1" colspan=5 style="padding: 0px;"></TD></TR>
				<TR>
				<td colSpan="3" width="65%">
					<%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%>：<!-- 其他接口动作 -->
					<select id="actionlist" name="actionlist">
						<option value="1">DML<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
						<!-- 
							<option value="2">WebService<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
							<option value="3">SAP<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
						 -->
					</select>
				</td>
				<TD align="right" width="35%">
				
					<DIV align=right>
					<BUTTON type='button' class=btn_actionList onclick=addRow();><SPAN id=addrowspan><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%></SPAN></BUTTON><!-- 增加 -->
						&nbsp;&nbsp;
					<BUTTON type='button' class=btn_actionList onclick=delRow();><SPAN id=delrowspan><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></SPAN></BUTTON><!-- 删除 -->
					</DIV>
				</TD>
			</TR>
			<TR class="Spacing" style="height: 1px;"><TD class="Line1" colspan=5 style="padding: 0px;"></TD></TR>
			<%
			List actionList = DMLActionBase.getDMLActionByNodeOrLinkId(id,Util.getIntValue(modeid,0));
			boolean islight = false;
			for(int i =0;i<actionList.size();i++)
			{
				List dmlList = (List)actionList.get(i);
				if(dmlList==null||dmlList.size()<3)
				{
					continue;
				}
				String dmlid = (String)dmlList.get(0);
				String dmlactionname = (String)dmlList.get(1);
				String dmltype = (String)dmlList.get(2);
			%>
			<tr class="<%if(islight){ %>datalight<%}else{%>datadark<%} %>">
				<td>
					<input type="checkbox" id="dmlid" name="dmlid" value="<%=dmlid%>">
					<input type="hidden" id="actiontype<%=dmlid%>" name="actiontype<%=dmlid%>" value="0">
				</td>
				<td nowrap>
					<a href="#" onclick="editAction('<%=dmlid %>', 0);"><%=dmlactionname %></a>
				</td>
				<td nowrap>
					DML<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%>
				</td>
				<td>
					<%=dmltype %><%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%><!-- 操作 -->
				</td>
			</tr>
			<%
				islight = islight?false:true;
			}
			//webservice action 列表
			wsActionManager.setActionid(0);
			ArrayList wsActionList = wsActionManager.doSelectWsAction(id,Util.getIntValue(modeid,0));
			for(int i =0;i<wsActionList.size();i++){
				ArrayList wsAction = (ArrayList)wsActionList.get(i);
				int actionid_t = Util.getIntValue((String)wsAction.get(0));
				String actionname_t = Util.null2String((String)wsAction.get(1));
			%>
				<tr class="<%if(islight){ %>datalight<%}else{%>datadark<%} %>">
					<td>
						<input type="checkbox" id="dmlid" name="dmlid" value="<%=actionid_t%>">
						<input type="hidden" id="actiontype<%=actionid_t%>" name="actiontype<%=actionid_t%>" value="1">
					</td>
					<td nowrap>
						<a href="#" onclick="editAction('<%=actionid_t%>', 1);"><%=actionname_t%></a>
					</td>
					<td colspan="2" nowrap>
						WebService<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><!-- 接口动作 -->
					</td>
				</tr>
			<%
				islight = islight?false:true;
			}
			//sap action 列表
			ArrayList sapActionList = sapActionManager.getSapActionSetList(id,Util.getIntValue(modeid,0));
			for(int i =0;i<sapActionList.size();i++){
				ArrayList sapAction = (ArrayList)sapActionList.get(i);
				int actionid_t = Util.getIntValue((String)sapAction.get(0));
				String actionname_t = Util.null2String((String)sapAction.get(1));
			%>
			
			<tr class="<%if(islight){ %>datalight<%}else{%>datadark<%} %>">
				<td>
					<input type="checkbox" id="dmlid" name="dmlid" value="<%=actionid_t%>">
					<input type="hidden" id="actiontype<%=actionid_t%>" name="actiontype<%=actionid_t%>" value="2">
				</td>
				<td nowrap>
					<a href="#" onclick="editAction('<%=actionid_t%>', 2);"><%=actionname_t%></a>
				</td>
				<td colspan="2" nowrap>
					Sap<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><!-- 接口动作 -->
				</td>
			</tr>
			<%
				islight = islight?false:true;
			}
			%>
			</table></td></tr>
			
		</table>
	</form>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<script type="text/javascript">
	function editAction(actionid, actiontype_){
		var addurl = "";
		if(actiontype_ == 0){
			addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/dmlaction/DMLActionSettingEdit.jsp?actionid="+actionid+"&modeid=<%=modeid%>&expandid=<%=id%>");
		}else if(actiontype_ == 1){
			addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/action/WsActionEditSet.jsp?actionid="+actionid+"&modeid=<%=modeid%>&expandid=<%=id%>");
		}else if(actiontype_ == 2){
			addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/action/SapActionEditSet.jsp?actionid="+actionid+"&&modeid=<%=modeid%>&expandid=<%=id%>");
		}
		var id_t = window.showModalDialog(addurl,window,"dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
	}
	function addRow(){
		var addurl = "";
		var actionlist_t = document.getElementById("actionlist").value;
		if(actionlist_t == 1){
			addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/dmlaction/DMLActionSettingAdd.jsp?modeid=<%=modeid%>&expandid=<%=id%>");
		}else if(actionlist_t == 2){
			addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/action/WsActionEditSet.jsp?operate=addws&modeid=<%=modeid%>&expandid=<%=id%>");
		}else if(actionlist_t == 3){
			addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/formmode/interfaces/action/SapActionEditSet.jsp?operate=adsap&modeid=<%=modeid%>&expandid=<%=id%>");
		}
		var id_t = window.showModalDialog(addurl,window,"dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
	}
	function delRow()
	{
		var hasselected = false;
		var dmlids = document.getElementsByName("dmlid");
		if(dmlids&&dmlids.length>0)
		{
			for(var i = 0;i<dmlids.length;i++)
			{
				var dmlid = dmlids[i];
				if(dmlid.checked)
				{
					hasselected = true;
					break;
				}
			}
		}
		if(!hasselected)
		{
			//请先选择需要删除的数据
			alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage())%>!");
			return;
		}
		if (isdel())
		{
			$G("operation").value="deletedmlaction";
	        enableAllmenu();
	        document.frmSearch.submit();
		}
	}
	function reloadDMLAtion()
	{
		location.href = "/formmode/interfaces/ModePageExpandEdit.jsp?id=<%=id%>";
	}

    function doSubmit(){
		if(check_form(document.frmSearch,"modeid,expendname")){
	        enableAllmenu();
	        document.frmSearch.submit();			
		}
    }
    function doBack(){
		enableAllmenu();
        location.href="/formmode/interfaces/ModePageExpand.jsp?modeid=<%=modeid%>";
    }
    function doDelete(){
    	if(isdel()){
        	enableAllmenu();
        	document.frmSearch.operation.value = "del";
        	document.frmSearch.submit();
    	}
    }

	function detailSet(){
		var hreftype = jQuery("select[name=hreftype]").val();
		var hrefid = jQuery("input[name=hrefid]").val();
		var modeid = jQuery("input[name=modeid]").val();
		url = "/formmode/interfaces/ModePageExpandRelatedFieldSet.jsp?modeid="+modeid+"&hreftype="+hreftype+"&hrefid="+hrefid;
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape(url));
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
    
    function onShowModeSelect(inputName, spanName){
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
    }

    function onShowCondition(spanName){
        var url = escape("/formmode/interfaces/showcondition.jsp?isbill=1&formid=<%=formid%>&id=<%=id%>");
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    	if (typeof(datas)!="undefined"){
    	    if(datas!=""){
   		    	//$(spanName).html("<img src=\"/images/BacoCheck_wev8.gif\" border=\"0\" complete=\"complete\"/>");
    	    	$(spanName).html(datas);
    	    }else{
    			$(spanName).html("");
    		}
    	}
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
    
	function getHrefTarget(){
		var hreftype = jQuery("select[name=hreftype]").val();
		var hrefid = jQuery("input[name=hrefid]").val();
		if(hreftype!=""&&hrefid!=""){
			var url = "/formmode/interfaces/ModePageExpandAjax.jsp?hrefid="+hrefid+"&hreftype="+hreftype;
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
			jQuery("#relatedfieldtr").show();
			jQuery("#relatedfieldtrline").show();
		}else if(hreftype=="2"){
			jQuery("#hrefidtr").hide();
			jQuery("#hrefidlinetr").hide();
			jQuery("#hrefid").val("");
			jQuery("#hrefidspan").html("");
			jQuery("#relatedfieldtr").hide();
			jQuery("#relatedfieldtrline").hide();
		}else if(hreftype=="3"){
			jQuery("#relatedfieldtr").show();
			jQuery("#relatedfieldtrline").show();
			jQuery("#hrefidtr").show();
			jQuery("#hrefidlinetr").show();
		}
	}

	function changeIsBatch(obj){
		if(obj.value=='1'){
			jQuery("#pageselect").hide();
			jQuery("#createpage").attr("checked","");
			jQuery("#managepage").attr("checked","");
			jQuery("#viewpage").attr("checked","");
		}else{
			jQuery("#pageselect").show();
		}
	}
	
	$(document).ready(function(){//onload事件
		changeIsBatch(jQuery("#isbatch")[0]);
		onShowTypeChange();
		onHrefTypeChange();
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})
</script>

</BODY>
</HTML>
