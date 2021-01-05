
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String mode = Util.null2String(request.getParameter("mode"));
String docid = Util.null2String(request.getParameter("docid"));
String secid = Util.null2String(request.getParameter("secid"));
String pagename = Util.null2String(request.getParameter("pagename"));
String operation = Util.null2String(request.getParameter("operation"));
String canShare = Util.null2String(request.getParameter("canShare"));
String requestid = Util.null2String(request.getParameter("requestid"));
String olddocid = Util.null2String(request.getParameter("olddocid"));
String isrequest = Util.null2String(request.getParameter("isrequest"));
String doccreaterid = Util.null2String(request.getParameter("doccreaterid"));
String docCreaterType = Util.null2String(request.getParameter("docCreaterType"));
String ownerid = Util.null2String(request.getParameter("ownerid"));
String ownerType = Util.null2String(request.getParameter("ownerType"));
int language = user.getLanguage();

String sourceParams = "docid:"+docid+"+requestid:"+requestid+"+olddocid:"+olddocid
						+"+isrequest:"+isrequest
						+"+doccreaterid:"+doccreaterid
						+"+docCreaterType:"+docCreaterType
						+"+ownerid:"+ownerid
						+"+ownerType:"+ownerType;
String tableString=""+
	   "<table datasource=\"weaver.docs.docs.DocDataSource.getDocRelationList\" sourceparams=\""+sourceParams+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCRELATION,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
	   "<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"shareId\"  sqlprimarykey=\"shareId\" sqlsortway=\"asc\"  />"+
	   "<head>";
			tableString += "<col width=\"60%\" labelid=\"1341\"  text=\""+SystemEnv.getHtmlLabelName(1341,user.getLanguage())+"\" pkey=\"shareName\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\" linkvaluecolumn=\"shareId\" target=\"_blank\"  column=\"shareName\"  orderkey=\"shareName\"/>";
			tableString += "<col width=\"40%\" labelid=\"18656\"  text=\""+SystemEnv.getHtmlLabelName(18656,user.getLanguage())+"\" column=\"shareRealId\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"shareRealType\"/>";
			tableString += "</head></table>";

%>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DOCRELATION %>"/>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(32991,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<button _show="true" type="button" class="e8_btn_top" id="checkDocSubscribe" name="checkDocSubscribe" onclick="onSubscribe();"><%= SystemEnv.getHtmlLabelName(32121,user.getLanguage())%></button>
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<div id="DocDivAcc" style="width:100%;height:100%;">
				<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
			</div>
		</wea:item>
	</wea:group>
</wea:layout>
</BODY></HTML>
<script type="text/javascript">
	function onSubscribe(){
		var docids = _xtable_CheckedCheckboxId();

		if(docids==""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>");
			return;
		}
		if(docids.match(/,$/)){
			docids = docids.substring(0,docids.length-1);
		}

		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		dialog.URL = "/docs/docsubscribe/DocSubscribeAdd.jsp?isdialog=1&subscribeDocId="+docids+"&from=DocRelation";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(32121,user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 400;
		dialog.Drag = true;
		dialog.show();
	}

</script>

