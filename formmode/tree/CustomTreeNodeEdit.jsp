<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%@ page import="weaver.general.StaticObj" %>
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomTreeUtil" class="weaver.formmode.tree.CustomTreeUtil" scope="page" />

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
	String titlename = SystemEnv.getHtmlLabelName(30216,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());//树形节点设置:编辑
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
	}
	//out.println(sourceid+"	"+sourcefrom);
	String sourcename = InterfaceTransmethod.getHrefName(String.valueOf(sourceid), String.valueOf(sourcefrom));
	String hrefname = InterfaceTransmethod.getHrefName(String.valueOf(hrefid), String.valueOf(hreftype));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSubmit(),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDel(),_self} " ;//删除
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:doBack(),_self} " ;//返回
RCMenuHeight += RCMenuHeightStep;
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
	<form name="frmSearch" method="post" action="/formmode/tree/CustomTreeNodeOperation.jsp" enctype="multipart/form-data">
		<input type="hidden" id="operation" name="operation" value="edit">
		<input type="hidden" id="id" name="id" value="<%=id%>">
		<input type="hidden" id="mainid" name="mainid" value="<%=mainid%>">
		<table class="ViewForm">
			<COLGROUP>
				<COL width="15%">
				<COL width="85%">
			</COLGROUP>
			<TR>
				<TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></B></TD>
			</TR>
			<tr style="height:1px"><td colspan=4 class=Line1></td></tr>

			<tr>
				<td>
					<!-- 名称 -->
					<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
				</td>
				<td class=Field>
					<input class="inputstyle" id="nodename" name="nodename" type="text" value="<%=nodename%>" size="30" maxlength="100" onblur="checkinput2('nodename','nodenamespan',1)">
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
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 描述 -->
					<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
				</td>
				<td class=Field>
					<input class="inputstyle" id="nodedesc" name="nodedesc" type="text" value="<%=nodedesc%>" size="30" maxlength="2000">
					<span id="nodedescspan">
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 数据来源 -->
					<%=SystemEnv.getHtmlLabelName(28006,user.getLanguage())%>
				</td>
				<td class=Field>
					<select id="sourcefrom" name="sourcefrom" onchange="SourceFromChange()">
						<option value="1" <%if(sourcefrom==1)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%></option>
						<option value="2" <%if(sourcefrom==2)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(30176,user.getLanguage())%></option>
					</select>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr id="sourceidtr">
				<td>
					<!-- 选择数据来源 -->
					<%=SystemEnv.getHtmlLabelName(30223,user.getLanguage())%>
				</td>
				<td class=Field>
					<button type="button" class="Browser" id="sourceidSelect" name="sourceidSelect" onClick="onShowSourceTarget(sourceid,sourceidspan)"></BUTTON>
					<input class="inputstyle" id="sourceid" name="sourceid" type="hidden" value="<%=sourceid%>" size="30" maxlength="2000">
					<span id="sourceidspan"><%=sourcename%>
					</span>
				</td>
			</tr>
			<tr id="sourceidlinetr" style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 表名 -->
					<%=SystemEnv.getHtmlLabelName(21900,user.getLanguage())%>
				</td>
				<td class=Field>
					<input class="inputstyle" id="tablename" name="tablename" type="text" value="<%=tablename%>" size="30" maxlength="50" onblur="checkinput2('tablename','tablenamespan',1)">
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
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 主键 -->
					<%=SystemEnv.getHtmlLabelName(21027,user.getLanguage())%>
				</td>
				<td class=Field>
					<button type="button" class="Browser" id="tablekeySelect" name="tablekeySelect" onClick="onShowHrefField(tablekey,tablekeyspan,1,1)"></BUTTON>
					<input class="inputstyle" id="tablekey" name="tablekey" type="hidden" value="<%=tablekey%>" size="30" maxlength="50">
					<span id="tablekeyspan">
						<%
							if(tablekey.equals("")) {
						%>
								<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
						<%
							}else{
						%>
								<%=CustomTreeUtil.getShowHrefField(tablekey,sourcefrom,sourceid,tablename)%>
						<%								
							}
						%>
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 上级 -->
					<%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%>
				</td>
				<td class=Field>
					<button type="button" class="Browser" id="tablesupSelect" name="tablesupSelect" onClick="onShowHrefField(tablesup,tablesupspan,0,1)"></BUTTON>
					<input class="inputstyle" id="tablesup" name="tablesup" type="hidden" value="<%=tablesup%>" size="30" maxlength="50">
					<span id="tablesupspan">
						<%=CustomTreeUtil.getShowHrefField(tablesup,sourcefrom,sourceid,tablename)%>
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 显示名 -->
					<%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%>
				</td>
				<td class=Field>
					<button type="button" class="Browser" id="showfieldSelect" name="showfieldSelect" onClick="onShowHrefField(showfield,showfieldspan,1,1)"></BUTTON>
					<input class="inputstyle" id="showfield" name="showfield" type="hidden" value="<%=showfield%>" size="30" maxlength="50">
					<span id="showfieldspan">
						<%
							if(showfield.equals("")) {
						%>
								<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
						<%
							}else{
						%>
								<%=CustomTreeUtil.getShowHrefField(showfield,sourcefrom,sourceid,tablename)%>
						<%								
							}
						%>
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			
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
					<br/>
					<%=SystemEnv.getHtmlLabelName(81450,user.getLanguage())%>
				</td>
				<td class=Field>
					<textarea id="hreftarget" name="hreftarget" class="inputstyle" rows="4" style="width:70%" onblur="checkinput2('hreftarget','hreftargetspan',1)"><%=hreftarget%></textarea>
					<span id="hreftargetspan">
						<%
							if(hreftarget.equals("")){
						%>
								<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
						<%
							}
						%>
					</span>
					<br>
					<!-- 如果链接目标地址不是手动输入地址，请勿随意修改这个字地址-->
					<%=SystemEnv.getHtmlLabelName(30179,user.getLanguage())%>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>

			<tr id="hrefrelatefieldtr">
				<td>
					<!-- 链接目标关联字段-->
					<%=SystemEnv.getHtmlLabelName(30222,user.getLanguage())%>
				</td>
				<td class=Field>
					<button type="button" class="Browser" id="hrefrelatefieldSelect" name="hrefrelatefieldSelect" onClick="onShowRelateField(hrefrelatefield,hrefrelatefieldspan)"></BUTTON>
					<input class="inputstyle" id="hrefrelatefield" name="hrefrelatefield" type="hidden" value="<%=hrefrelatefield%>" size="30">
					<span id="hrefrelatefieldspan">
						<%=CustomTreeUtil.getShowHrefRelateField(hrefrelatefield,hreftype,hrefid)%>
					</span>
				</td>
			</tr>
			<tr id="hrefrelatefieldlinetr" style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 链接目标地址字段  -->
					<%=SystemEnv.getHtmlLabelName(81451,user.getLanguage())%>
				</td>
				<td class=Field>
					<button type="button" class="Browser" id="hrefFieldSelect" name="hrefFieldSelect" onClick="onShowHrefField(hrefField,hrefFieldspan,0,4)"></BUTTON>
					<input class="inputstyle" id="hrefField" name="hrefField" type="hidden" value="<%=hrefField%>" size="30" maxlength="50">
					<span id="hrefFieldspan">
						<%=CustomTreeUtil.getShowHrefField(hrefField,sourcefrom,sourceid,tablename)%>
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 图标-->
					<%=SystemEnv.getHtmlLabelName(81442,user.getLanguage())%>
				</td>
				<td class=Field>
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
						<a href="javascript:void(0)" onclick="javascript:delNodeIcon()"><%=SystemEnv.getHtmlLabelName(30227,user.getLanguage())%></a>
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 节点图标字段  -->
					<%=SystemEnv.getHtmlLabelName(81443,user.getLanguage())%>
				</td>
				<td class=Field>
					<button type="button" class="Browser" id="iconFieldSelect" name="iconFieldSelect" onClick="onShowHrefField(iconField,iconFieldspan,0,5)"></BUTTON>
					<input class="inputstyle" id="iconField" name="iconField" type="hidden" value="<%=iconField%>" size="30" maxlength="50">
					<span id="iconFieldspan">
						<%=CustomTreeUtil.getShowHrefField(iconField,sourcefrom,sourceid,tablename)%>
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 数据显示顺序  -->
					<%=SystemEnv.getHtmlLabelName(81444,user.getLanguage())%>
				</td>
				<td class=Field>
					<textarea id="dataorder" name="dataorder" class="inputstyle" maxlength="1000" rows="4" style="width:70%"><%=dataorder%></textarea>
					<span id="dataorderspan">
					</span>
					<br/>
					<%=SystemEnv.getHtmlLabelName(81446,user.getLanguage())%>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 数据显示条件  -->
					<%=SystemEnv.getHtmlLabelName(81445,user.getLanguage())%>
				</td>
				<td class=Field>
					<textarea id="datacondition" name="datacondition" class="inputstyle" maxlength="4000" rows="4" style="width:70%"><%=datacondition%></textarea>
					<span id="dataconditionspan">
					</span>
					<br/>
					<%=SystemEnv.getHtmlLabelName(81447,user.getLanguage())%>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 上级节点 -->
					<%=SystemEnv.getHtmlLabelName(30217,user.getLanguage())%>
				</td>
				<td class=Field>
					<select id="supnode" name="supnode">
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
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 上下级节点关联字段 -->
					<%=SystemEnv.getHtmlLabelName(30218,user.getLanguage())%>
				</td>
				<td class=Field>
					<table>
						<tr>
							<!-- 本节点字段 -->
							<td><%=SystemEnv.getHtmlLabelName(30219,user.getLanguage())%></td>
							<td>
								<button type="button" class="Browser" id="nodefieldSelect" name="nodefieldSelect" onClick="onShowHrefField(nodefield,nodefieldspan,0,1)"></BUTTON>
								<input class="inputstyle" id="nodefield" name="nodefield" type="hidden" value="<%=nodefield%>" size="30" maxlength="2000">
								<span id="nodefieldspan">
									<%=CustomTreeUtil.getShowHrefField(nodefield,sourcefrom,sourceid,tablename)%>
								</span>
							</td>
						</tr>
						<tr>
							<!-- 上级节点字段 -->
							<td><%=SystemEnv.getHtmlLabelName(30220,user.getLanguage())%></td>
							<td>
								<button type="button" class="Browser" id="nodefieldSelect" name="nodefieldSelect" onClick="onShowSupField(supnodefield,supnodefieldspan)"></BUTTON>
								<input class="inputstyle" id="supnodefield" name="supnodefield" type="hidden" value="<%=supnodefield%>" size="30" maxlength="2000">
								<span id="supnodefieldspan">
									<%=CustomTreeUtil.getShowSupField(supnode,supnodefield)%>
								</span>
							</td>
						</tr>
					</table>
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
    function doSubmit(){
		if(check_form(document.frmSearch,"nodename,tablename,tablekey,showfield,hreftarget")){
	        enableAllmenu();
	        document.frmSearch.submit();			
		}
    }
    function doBack(){
        //window.open("","_self").close();
        location.href = "/formmode/tree/CustomTreeView.jsp?id=<%=mainid%>";
    }
    function doDel(){
    	if(isdel()){
        	enableAllmenu();
        	document.frmSearch.operation.value = "del";
        	document.frmSearch.submit();
    	}
    }

    function selectImg(obj){
		if(obj.value==""){
			$("#oldimg").html("");
		}else{
			$("#oldimg").html("<img border=0 src="+obj.value+">");
		}
	}

    function delNodeIcon(){
    	$("#oldimg").html("");
    	$("#oldnodeicon").val("");    	
    	var objFile = document.getElementById('nodeicon');
    	objFile.outerHTML=objFile.outerHTML.replace(/(value=\").+\"/i,"$1\""); 
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

	function getSourceTableName(){
		var sourcefrom = jQuery("select[name=sourcefrom]").val();
		var sourceid = jQuery("input[name=sourceid]").val();
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
	
	$(document).ready(function(){//onload事件
		initload();
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})
</script>

</BODY>
</HTML>
