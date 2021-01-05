
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page" />
<jsp:useBean id="BrowserXML" class="weaver.servicefiles.BrowserXML" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<TITLE>SystemEnv.getHtmlLabelName(33251,user.getLanguage())+SystemEnv.getHtmlLabelName(83327,user.getLanguage())</TITLE>
	</HEAD>
<%
	String imagefilename = "/images/hdReport_wev8.gif";
	String needfav = "1";
	String needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(83327,user.getLanguage());
	
	//String userRights = shareRights.getUserRights("-1", user);//得到用户查看范围
	//if ("-100".equals(userRights)) {
	    //response.sendRedirect("/notice/noright.jsp");
		//return;
	//}
	//初始化xml到数据库
	BrowserXML.initData();
	
	String name = Util.null2String(request.getParameter("name"));
	String showname = Util.null2String(request.getParameter("showname"));
	int showtype = Util.getIntValue(Util.null2String(request.getParameter("showtype")));
	String backfields = " name, showname, showtype ";
	String fromSQL = " from datashowset a";
	String SqlWhere = " where showclass='1'" ;
	if(!name.isEmpty()){
		SqlWhere += " and name like '%"+name+"%'";
	}
	if(!showname.isEmpty()){
		SqlWhere += " and showname like '%"+showname+"%'";
	}
	
	if(showtype!=-1){
		SqlWhere += " and showtype="+showtype;
	}
	
	
	String tableString = ""+
	"<table pagesize=\"10\" tabletype=\"none\">"+
	"<sql backfields=\""+backfields+"\" showCountColumn=\"false\" sqlform=\""+Util.toHtmlForSplitPage(fromSQL)+"\"  sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\" sqlorderby=\"showname\" sqlprimarykey=\"showname\" sqlsortway=\"asc\" />"+
	"<head>"+							 
			 "<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(33439,user.getLanguage())+"\" column=\"name\" />"+
			 "<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"showname\" />"+
			 "<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(23130,user.getLanguage())+"\" column=\"showtype\" transmethod=\"weaver.general.SplitPageTransmethod.getShowType\" otherpara=\""+user.getLanguage()+"\" />"+
	"</head>"+
	//"<operates>"+
	//"		<operate href=\"javascript:selectData();\" otherpara=\"column:name\" text=\""+SystemEnv.getHtmlLabelName(33251,user.getLanguage())+"\" target=\"_self\"/>"+
	//"</operates>"+      
	"</table>";
%>
	<BODY>

		<!-- start -->
		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="<%=titlename%>" />
		</jsp:include>

		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())
					+ ",javascript:submitData(),_self}";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage())
					+ ",javascript:clearData(),_self}";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" onClick="submitData();" />
					<span
						title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"
						class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="mainDiv">
			<FORM id=frmMain name=frmMain action=UserDefinedBrowserTypeBrowser.jsp method=post>
	            
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(15774, user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(33439, user.getLanguage())%></wea:item>
						<wea:item>
							<input type="text" name="name" value="<%=name %>" />
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></wea:item>
						<wea:item>
							<input type="text" name="showname" value="<%=showname %>" />
						</wea:item>
						
						<wea:item><%=SystemEnv.getHtmlLabelName(23130, user.getLanguage())%></wea:item>
						<wea:item>
							<SELECT class=InputStyle name="showtype">
								<option value="-1"></option>
								<option value="1" <%if(showtype==1)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(19525, user.getLanguage())%></option> <!-- 列表式 -->
								<option value="2" <%if(showtype==2)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(32308, user.getLanguage())%></option><!-- 树形 -->
								<option value="3" <%if(showtype==3)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(32309, user.getLanguage())%></option><!-- 自定义页面 -->
							</SELECT>
						</wea:item>
					</wea:group>

				</wea:layout>
				
				<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
			</FORM>
		</div>

		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
					<wea:item type="toolbar">
				    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" class="zd_btn_submit" onclick="clearData();" style="width: 50px!important;">
				    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 50px!important;">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<!-- end -->

	</BODY>
	<script type="text/javascript">
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}

		function clearData() {
			selectData('', '');
		}

		function selectData(id, name) {
			var returnjson = {id: "browser."+id,name: name};
			if(id == null || id == ""){
			    returnjson = {id: "",name: ""};
			}
			if(dialog){
				try {
					dialog.callback(returnjson);
				} catch(e) {}

				try {
					dialog.close(returnjson);
				} catch(e) {}
			}else{
				window.parent.parent.returnValue = returnjson;
				window.parent.parent.close();
			}
		}

		function submitData() {
			frmMain.submit();
		}
		
		jQuery(function(){
			jQuery("#_xTable").bind("click",BrowseTable_onclick);
		});
		
		function BrowseTable_onclick(e){
		   var e=e||event;
		   var target=e.srcElement||e.target;

			if( target.nodeName =="TD"||target.nodeName =="A"  ){
				var pNode = target.parentNode;
				if(pNode.nodeName!="TR"){
					pNode = pNode.parentNode;
				}

				selectData(jQuery(jQuery(target).parents("tr")[0].cells[2]).text(), jQuery(jQuery(target).parents("tr")[0].cells[1]).text());
			}
		}
	</script>
</HTML>
