<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="java.util.*"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.social.im.SocialIMClient"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<?xml version="1.0" encoding="UTF-8"?>  
<!DOCTYPE html>  
<html>  
<head>  
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />  
    <meta http-equiv="Cache-Control" content="no-cache"/>  
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <meta name="apple-mobile-web-app-capable" content="yes" /> 
    <meta name="apple-mobile-web-app-status-bar-style" content="black" /> 
    <meta name="format-detection" content="telephone=no" />  
    <script>
    	function download(imagefileid, imagefilename){
    		var downloadUrl = "/weaver/weaver.file.FileDownload?fileid="+imagefileid+"&download=1";
    		if(imagefilename){
    			downloadUrl += "&filename="+imagefilename;
    		}
    		document.getElementById("downloadFrame").src = downloadUrl;
    	}
    	function openRes(resourcetype,detailid,from){
    		if(from == 'pc') {
    			var url = "";
    			if(resourcetype == 1) {
    				url = "/workflow/request/ViewRequest.jsp?requestid="+detailid;
    			}else{
    				url = "/docs/docs/DocDsp.jsp?id="+detailid;
    			}
    			window.open(url);
    			return;
    		}
    		var location = (document.location || window.location);
    		if(resourcetype == 1){
    			location.href = "http://emobile/workflow/test.jsp?detailid="+detailid;
    		}else if(resourcetype == 2){
    			location.href = "http://emobile/doc/test.jsp?detailid="+detailid;
    		}
    	}
    </script>
</head>
<body>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
FileUpload fu=new FileUpload(request);
if (user == null) return;

String broadId = Util.null2String(fu.getParameter("broadid"));
String from = Util.null2String(fu.getParameter("from"));


String imageids = null;
String accids = null;
String wfids = null;
String docids = null;
String accnames = null;
String accsizes = null;
String wfnames = null;
String docnames = null;
String senderId = null;
String sendTime = null;
String plainText = null;

String senderName = null;
String sex = null;
String senderHead = null;
String defaultHead = null;

String defaultHeadM = "/messager/images/icon_m_wev8.jpg";
String defaultHeadW = "/messager/images/icon_w_wev8.jpg";

JSONObject requestObj = null;

ArrayList<String> imageidList = null;
ArrayList<String> accidList = null;
ArrayList<String> wfidList = null;
ArrayList<String> docidList = null;
ArrayList<String> accnameList = null;
ArrayList<String> accsizeList = null;
ArrayList<String> wfnameList = null;
ArrayList<String> docnameList = null;
try{
	String extraString = SocialIMClient.BroadcastMap.get(broadId);
	if(extraString != null && !extraString.isEmpty()){
		requestObj = JSONObject.fromObject(extraString);
	}
}catch(Exception e){
	// do Nothing
}

if(requestObj != null && !requestObj.isEmpty()){
	imageidList = Util.TokenizerString(requestObj.optString("imageids", ""), ",");
	accidList = Util.TokenizerString(requestObj.optString("accids", ""), ",");
	wfidList = Util.TokenizerString(requestObj.optString("wfids", ""), ",");
	docidList = Util.TokenizerString(requestObj.optString("docids", ""), ",");
	accnameList = Util.TokenizerString(requestObj.optString("accnames", ""), ",");
	accsizeList = Util.TokenizerString(requestObj.optString("accsizes", ""), ",");
	wfnameList = Util.TokenizerString(requestObj.optString("wfnames", ""), ",");
	docnameList = Util.TokenizerString(requestObj.optString("docnames", ""), ",");
	senderId = Util.null2String(requestObj.optString("fromUserId", ""));
	sendTime = Util.null2String(requestObj.optString("sendtime", ""));
	plainText = Util.null2String(requestObj.optString("plaintext", ""));
}else {

	String sql = "select * from social_broadcast where id = '"+broadId+"'";
	rs.execute(sql);
	if(rs.next()){
		String requestString = rs.getString("requestobjs");
		requestObj = JSONObject.fromObject(requestString);
		imageidList = Util.TokenizerString(requestObj.optString("imageids", ""), ",");
		accidList = Util.TokenizerString(requestObj.optString("accids", ""), ",");
		wfidList = Util.TokenizerString(requestObj.optString("wfids", ""), ",");
		docidList = Util.TokenizerString(requestObj.optString("docids", ""), ",");
		accnameList = Util.TokenizerString(requestObj.optString("accnames", ""), ",");
		accsizeList = Util.TokenizerString(requestObj.optString("accsizes", ""), ",");
		wfnameList = Util.TokenizerString(requestObj.optString("wfnames", ""), ",");
		docnameList = Util.TokenizerString(requestObj.optString("docnames", ""), ",");
		
		senderId = rs.getString("fromUserId");
		sendTime = rs.getString("sendtime");
		plainText = rs.getString("plaintext");
	}
}
senderName = ResourceComInfo.getLastname(senderId);
sex = ResourceComInfo.getSexs(senderId);
senderHead = ResourceComInfo.getMessagerUrls(senderId);
defaultHead = "";
if("0".equals(sex)){
	defaultHead = defaultHeadM;
}else{
	defaultHead = defaultHeadW;
}
	%>
	<iframe id="downloadFrame" style="display: none"></iframe>
	<table id='maintb' width=100% cellspacing=0 cellpadding=0>
		<colgroup><col width="80px"><col width="*"></colgroup>
		<tr class='h39'>
			<td rowspan=2 class='center'>
				<img src="<%=Util.null2String(senderHead, defaultHead) %>" class="head60" onerror="this.src='<%=defaultHead %>'"/>
			</td>
			<td class='fcolor0 fbold fsize24 bottom ln28'><%=senderName %></td>
		</tr>
		<tr class='h39 fcolor3 fsize18'>
			<td class='top ln24'><%=SocialUtil.getFormatTimeByMillis(sendTime) %></td>
		</tr>
		<tr>
			<td></td>
			<td class='fcolor0 fsize22'><%=plainText.replaceAll("\n","<br>").replaceAll("\r","<br>")%></td>
		</tr>
		<tr>
			<td></td>
			<td>
				<div class="imgwrap">
				<% 
				for(int j = 0; j < imageidList.size(); ++j) {
				%>
					<img class='squarbox' src="/weaver/weaver.file.FileDownload?fileid=<%=imageidList.get(j) %>" onclick="download(<%=imageidList.get(j) %>, '<%=imageidList.get(j) %>.jpg')"/>
				<%} %>
					<div class='clear'></div>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan=2>
				<table id='reslist' width=100% height=100% cellspacing=0 cellpadding=0 class='bggrey fcolor1 fsize20'>
					<colgroup><col width="58px"><col width="*"></colgroup>
					<%if(accidList.size() > 0) {%>
					<tr>
						<td class='center top'><img style="width: 26px; height: 26px;" src='res/broadcast_acc_wev8.png'/></td>
						<td class='top'>
							<%for(int j = 0; j < accidList.size(); ++j) {
								%>
									<div onclick="download(<%=accidList.get(j) %>, '<%=accnameList.get(j)%>')" <%=j>0?"class='topSplit1 resitem'":"class='resitem'" %>>
										<span class='nameSpan ellipsis'><%=accnameList.get(j)%></span>
										<span class='right5 fcolor2 fsize16'><%=SocialUtil.formateFileSize(accsizeList.get(j)) %></span>
									</div>
								<%} %>
						</td>
					</tr>
					<%} %>
					<%if(wfidList.size() > 0) {%>
					<tr <%=accidList.size() > 0?"class='topSplit0'":"" %>>
						<td class='center top'><img style="width: 26px; height: 26px;" src='res/broadcast_wf_wev8.png'/></td>
						<td class='top'>
							<%for(int j = 0; j < wfidList.size(); ++j) {
								%>
									<div onclick="openRes(1,<%=wfidList.get(j) %>,'<%=from %>')" <%=j>0?"class='topSplit1 resitem'":"class='resitem'" %>>
										<span class='nameSpan ellipsis'><%=wfnameList.get(j) %></span>
									</div>
								<%} %>
						</td>
					</tr>
					<%} %>
					<%if(docidList.size() > 0) {%>
					<tr <%=(accidList.size() > 0 || wfidList.size() > 0)?"class='topSplit0'":""%>>
						<td class='center top'><img style="width: 26px; height: 26px;" src='res/broadcast_doc_wev8.png'/></td>
						<td class='top'>
							<%for(int j = 0; j < docidList.size(); ++j) {
								%>
									<div onclick="openRes(2,<%=docidList.get(j) %>,'<%=from %>')" <%=j>0?"class='topSplit1 resitem'":"class='resitem'" %>>
										<span class='nameSpan ellipsis'><%=docnameList.get(j) %></span>
									</div>
								<%} %>
						</td>
					</tr>
					<%} %>
				</table>
			</td>
		</tr>
	</table>

<style>
	body{margin:0;}
	.clear{
		clear: both;
	}
	.nameSpan{
		width: 230px;
    	display: inline-block; 
	}
	.ellipsis{
		text-overflow: ellipsis;
    	white-space: nowrap;
    	overflow: hidden;
	}
	td.center{
		text-align: center;
	}
	td.middle{
		vertical-align: middle;
	}
	td.top{
		vertical-align: top;
	}
	td.bottom{
		vertical-align: bottom;
	}
	td.ln24{
		line-height: 24px;
	}
	td.ln28{
		line-height: 28px;
	}
	tr.h39{
		height: 39px;
	}
	.head60{
		border-radius: 30px;
    	height: 60px;
    	width: 60px;
    	margin: 6px;
	}
	.squarbox{
		width: 82px; 
		height: 82px;
		float: left;
		margin-top:2px; 
		margin-right:2px;
	}
	.right{
		float: right;
	}
	.right5{
		position: absolute;
		right: 5px;
		top: 14px;
	}
	.bggrey{
		background: #f0f2f4;
	}
	.fcolor0{
		color: #484c50;
	}
	.fcolor1{
		color: #43464a;
	}
	.fcolor2{
		color: #aaafb5;
	}
	.fcolor3{
		color: #a8a8a8;
	}
	.fbold{
		font-weight: bold;
	}
	.fsize16{
		font-size: 16px;
	}
	.fsize18{
		font-size: 18px;
	}
	.fsize20{
		font-size: 20px;
	}
	.fsize22{
		font-size: 22px;
	}
	.fsize24{
		font-size: 24px;
	}
	#reslist{
		border-collapse: collapse;
	}
	#reslist tr{
		height: 60px;
	}
	#reslist tr td{
		padding: 8px 0;
    	padding-top: 20px;
	}
	#reslist .topSplit0{
		border-top: 1px solid #aaafb5;
	}
	#reslist .topSplit1{
		border-top: 2px solid #aaafb5;
	}
	#reslist .resitem{
		position: relative;
		padding: 10px 0;
		top: -6px;
	}
	#maintb .imgwrap{
		max-width: 530px;
		margin: 20px 0;
	}
</style>
</body>
</html>