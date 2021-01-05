
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String mode = Util.null2String(request.getParameter("mode"));
String docid = Util.null2String(request.getParameter("docid"));
String pagename = Util.null2String(request.getParameter("pagename"));
String operation = Util.null2String(request.getParameter("operation"));
int maxUploadImageSize = Util.getIntValue(Util.null2String(request.getParameter("maxUploadImageSize")),0);
int bacthDownloadFlag = Util.getIntValue(Util.null2String(request.getParameter("bacthDownloadFlag")),0);
String canShare = Util.null2String(request.getParameter("canShare"));
String doceditionid = Util.null2String(request.getParameter("doceditionid"));
String readerCanViewHistoryEdition = Util.null2String(request.getParameter("readerCanViewHistoryEdition"));
String canEditHis = Util.null2String(request.getParameter("canEditHis"));
int language = user.getLanguage();

String sourceParams = "docid:"+docid+"+doceditionid:"+doceditionid+"+readerCanViewHistoryEdition:"+readerCanViewHistoryEdition+"+canEditHis:"+canEditHis;
String tableString=""+
	   "<table datasource=\"weaver.docs.docs.DocDataSource.getDocVerList\" sourceparams=\""+sourceParams+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCVER,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
	   "<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"versionid\"  sqlprimarykey=\"versionid\" sqlsortway=\"desc\"  />"+
	   "<head>";
			tableString += "<col width=\"40%\" labelid=\"1341\"  text=\""+SystemEnv.getHtmlLabelName(1341,user.getLanguage())+"\" column=\"docsubject\"/>";
			tableString+=	 "<col width=\"10%\" labelid=\"22186\"  text=\""+SystemEnv.getHtmlLabelName(22186,user.getLanguage())+"\" column=\"versionid\" />";
			tableString += "<col width=\"20%\" labelid=\"882\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creator\"/>";
			tableString += "<col width=\"30%\" labelid=\"19521\"  text=\""+SystemEnv.getHtmlLabelName(19521,user.getLanguage())+"\" column=\"doclastmoditime\"/>";
			tableString += "</head></table>";

%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DOCVER %>"/>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19587,user.getLanguage())%>'>
		
		<wea:item attributes="{'isTableList':'true'}">
			<div id="DocDivAcc" style="width:100%;height:100%;">
				<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
			</div>
		</wea:item>
	</wea:group>
</wea:layout>
