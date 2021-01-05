<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.social.SocialUtil" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	return;
}
String content = Util.null2String(request.getParameter("content")); 
String senderid = Util.null2String(request.getParameter("senderid")); 
String timestart = Util.null2String(request.getParameter("timestart")); 
String timeend = Util.null2String(request.getParameter("timeend")); 
HashMap<String,String> params = new HashMap<String, String>();
params.put("content", content);
params.put("senderid", senderid);
params.put("timestart", timestart);
params.put("timeend", timeend);
params.put("pageindex", "1");
params.put("pagesize", "4");
JSONObject itemObj = null, requestObj;
JSONArray result = SocialIMService.getBroadcastList(user.getUID(), params);
for(int i = 0; i < result.size(); ++i){
	try{
		itemObj = result.getJSONObject(i);
		requestObj = JSONObject.fromObject(itemObj.optString("requestobjs","{}"));
		ArrayList<String> imageidList = Util.TokenizerString(requestObj.optString("imageids", ""), ",");
		ArrayList<String> accidList = Util.TokenizerString(requestObj.optString("accids", ""), ",");
		ArrayList<String> wfidList = Util.TokenizerString(requestObj.optString("wfids", ""), ",");
		ArrayList<String> docidList = Util.TokenizerString(requestObj.optString("docids", ""), ",");
		ArrayList<String> accnameList = Util.TokenizerString(requestObj.optString("accnames", ""), ",");
		ArrayList<String> accsizeList = Util.TokenizerString(requestObj.optString("accsizes", ""), ",");
		ArrayList<String> wfnameList = Util.TokenizerString(requestObj.optString("wfnames", ""), ",");
		ArrayList<String> docnameList = Util.TokenizerString(requestObj.optString("docnames", ""), ",");
%>
<div class="msgItem" broadid="<%=itemObj.optString("id", "-1")%>">
	<div class="msgContent">
		<div class="txtdiv">
			<%=itemObj.optString("plaintext", "").replaceAll("\n","<br>").replaceAll("\r","<br>") %>
		</div>
		<div class="imgdiv">
			<% 
			for(int j = 0; j < imageidList.size(); ++j) {
			%>
				<img onclick="BCHandler.showImgLight(this)" style="width: 70px; height: 70px;" src="/weaver/weaver.file.FileDownload?fileid=<%=imageidList.get(j) %>"/>
			<%} %>
		</div>
		<div class="resdiv">
			<table width="100%" cellpadding="0" cellspacing="0">
				<colgroup><col width="60px"><col width="*"></colgroup>
				<tr class='accList'>
					<%if(accidList.size() > 0) {%>
					<td class="titleHead greycolor">
						<img src='/social/images/broadcast_acc_wev8.png'/>
					</td>
					<td class="titleBody">
						<%
						for(int j = 0; j < accidList.size(); ++j) {
						%>
							<div onclick="downloads(<%=accidList.get(j)%>,'<%=accnameList.get(j)%>',<%=accsizeList.get(j)%>);">
								<a href="javascript:void(0);"><%=accnameList.get(j)+"("+accsizeList.get(j)+")" %></a>
							</div>
						<%} %>
					</td>
					<%} %>
				</tr>
				<tr class='wfList'>
					<%if(wfidList.size() > 0) {%>
					<td class="titleHead greycolor">
						<img src='/social/images/broadcast_wf_wev8.png'/>
					</td>
					<td class="titleBody">
						<%
						for(int j = 0; j < wfidList.size(); ++j) {
						%>
							<div onclick="PcExternalUtils.openUrlByLocalApp('/workflow/request/ViewRequest.jsp?requestid=<%=wfidList.get(j) %>',0);">
								<a href="javascript:void(0);"><%=wfnameList.get(j) %></a>
							</div>
						<%} %>
					</td>
					<%} %>
				</tr>
				<tr class='docList'>
				<%if(docidList.size() > 0) {%>
					<td class="titleHead greycolor">
						<img src='/social/images/broadcast_doc_wev8.png'/>
					</td>
					<td class="titleBody">
						<%
						for(int j = 0; j < docidList.size(); ++j) {
						%>
							<div onclick="PcExternalUtils.openUrlByLocalApp('/docs/docs/DocDsp.jsp?id=<%=docidList.get(j) %>',0);">
								<a href="javascript:void(0);"><%=docnameList.get(j) %></a>
							</div>
						<%} %>
					</td>
					<%} %>
				</tr>
			</table>
		</div>
	</div>
	<div class="msgOpt">
		<span class="sendname"><%=ResourceComInfo.getLastname(itemObj.getString("fromUserId"))%></span>
		<span class="sendtime"><%=SocialUtil.getFormatTimeByMillis(itemObj.getString("sendtime"))%></span>
	</div>
</div>
<%
	}catch(Exception e){
		e.printStackTrace();
		continue;
	}
}
%>