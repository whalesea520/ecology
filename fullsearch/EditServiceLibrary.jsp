
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<HTML>
<%
	String showTop = Util.null2String(request.getParameter("showTop"));
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = ""
			+ SystemEnv.getHtmlLabelName(571, user.getLanguage()) + ":"
			+ SystemEnv.getHtmlLabelName(93, user.getLanguage());
%>
<head>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
	<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css
		rel=STYLESHEET>
	<script language=javascript
		src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>
<%!
       public String StrFilter(String str){
        
        str = Util.null2String(str);
        if (str.contains("'"))
        {
            str = str.replace("'", "&#39;"); // 
            return str;
        }else if(str.contains("\"")){
            str = str.replace("\"", "\\\"");
            return str;
        }else{
            return str;
        }
    }
    %>
<%
	if(!HrmUserVarify.checkUserRight("eAssistant:server", user)){
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
	String lastname = "";
	String label = "";
	String id = "";
	Map map;
	List list = new ArrayList();
	// 需要编辑的ID
	String serviceId = Util.null2String(request.getParameter("serviceId"));
	// 操作的标识FLG
	String serviceOperType = Util.null2String(request
			.getParameter("serviceOperType"));
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:saveInfo(),_self} ";
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>

<body>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
		<jsp:param name="mouldID" value="eAssistant" />
		<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(128711,user.getLanguage()) %>" />
	</jsp:include>

	<wea:layout attributes="{layoutTableId:topTitle}">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
				<span
					title="<%=SystemEnv.getHtmlLabelName(86, user
										.getLanguage())%>"
					style="font-size: 12px; cursor: pointer;"> <input
						class="e8_btn_top middle" onclick="saveInfo()" type="button"
						value="<%=SystemEnv.getHtmlLabelName(86, user
										.getLanguage())%>" />
				</span>
				<span
					title="<%=SystemEnv.getHtmlLabelName(82753, user
										.getLanguage())%>"
					class="cornerMenu"></span>
			</wea:item>
		</wea:group>
	</wea:layout>
	<form method="post" action="ViewServiceLib.jsp" name="weaver"  onsubmit="javascript:return false;">
	<input type="hidden" name="serviceOperType" value="<%=serviceOperType%>">
	<input type="hidden" name="serviceId" value="<%=serviceId%>">
		<wea:layout
			attributes="{'expandAllGroup':'true'}">
			<wea:group
				context='<%=SystemEnv.getHtmlLabelName(1361, user
									.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelNames("24993", user
										.getLanguage())%></wea:item>
                <wea:item>
					<%
						if ("edit".equals(serviceOperType)) {
									rs.execute("SELECT T1.LABEL, T1.ID, T2.LASTNAME FROM FullSearch_CustomerSerDetail T1, HRMRESOURCE T2 WHERE T1.SERVICEID = T2.ID AND T1.SERVICEID = "+ serviceId);
									while (rs.next()) {
										lastname = rs.getString("LASTNAME");
										label = rs.getString("LABEL");
										id = rs.getString("ID");
									}
					%>
						<a href="/hrm/resource/HrmResource.jsp?id=<%=serviceId%>"
							target="_blank" title="<%=lastname%>"><%=lastname%></a>
					<%
						}else if ("add".equals(serviceOperType)) {
					        rs.execute("SELECT ID, LASTNAME FROM HRMRESOURCE WHERE ID  in ("+ serviceId + ")");
					        while (rs.next()) {
					        	lastname = rs.getString("LASTNAME");
					            id = rs.getString("ID");
					%>
					   <a href="/hrm/resource/HrmResource.jsp?id=<%=id%>"
                            target="_blank" title="<%=lastname%>"><%=lastname%></a>
					<%}%>
					
					    <%label = "";} %>
				</wea:item>

				<wea:item><%=SystemEnv.getHtmlLabelName(176, user
										.getLanguage())%></wea:item>
				<wea:item>
					<input type="text" name="changeLabel" class="inputstyle"
						value='<%=StrFilter(label)%>' >
				</wea:item>
			</wea:group>
		</wea:layout>
	</form>

	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(309, user
										.getLanguage())%>"
						id="zd_btn_cancle" class="zd_btn_cancle"
						onclick="javascript:parentWin.closeDialog();">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</body>
</HTML>
<script language="javascript">
var parentWin = parent.getParentWindow(window);
var doubleClick = false; 
function saveInfo(){
	if(!doubleClick){
		doubleClick = true;
	}else{
		return;
	}
     jQuery.post("ViewServiceLib.jsp",jQuery("form").serialize(),function(){
        parentWin.closeDialog();
     });
}
function onCancel(){
        var dialog = parent.getParentWindow(parent);
        dialog.closeDialog();
}
</script>