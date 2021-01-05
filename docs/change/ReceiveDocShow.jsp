
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="SptmForDoc" class="weaver.splitepage.transform.SptmForDoc" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<%
if(!HrmUserVarify.checkUserRight("DocChange:Receive", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String id = Util.null2String(request.getParameter("id"));
String docid = "";
String attid = "";
rs.executeSql("select docid,fileids from DocChangeReceive where id="+id);
if(rs.next()) {
	docid = rs.getString("docid");
	attid = rs.getString("fileids");
}
%>
<iframe src="/docs/docs/DocDsp.jsp?id=<%=docid%>" height="80%" width="100%"></iframe>

<%
if(!attid.equals("")) {
	//attid = attid.substring(0, attid.length()-1);
	String sql = "select t1.id,t3.imagefileid,t3.filesize ";
	sql += "from docdetail t1, docimagefile t2, imagefile t3 ";
	sql += "where t1.id=t2.docid and t2.imagefileid=t3.imagefileid ";
	sql += "and t3.imagefileid in("+attid+")";
	rs.executeSql(sql);
%>
	<script type="text/javascript">
	 	function hideAccPanel2(){
	 		jQuery("div.e8AccListArea").hide();
	 		jQuery("div.e8AccListBtn").show();
	 		jQuery("div.e8AccListArea").data("isClosed",true);
	 	}
	 	
	 	function showAccPanel2(){
	 		jQuery("div.e8AccListArea").show();
	 		jQuery("div.e8AccListBtn").hide();
	 		jQuery("div.e8AccListArea").data("isClosed",false);
	 	}
	 </script>
	<div class="e8AccListBtn" onclick="javascript:showAccPanel2();"></div>
	<div class="e8AccListArea">
		<div class="e8AccListHead">
			<div class="e8AccListHeadLeft">
				<span style="padding-left:10px;"><img src="/images/docs/accTitle_wev8.png" width="16px" height="16px" style="vertical-align:middle;"/></span>
				<span style="padding-left:10px;"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage()) %></span>
			</div>
			<div class="e8AccListHeadRight" onclick="javascript:hideAccPanel2();"></div>
		</div>
		<div class="e8AccListContent">
			<table class="e8AccListTable">
				<colgroup>
					<col width="50%"/>
					<col width="50%"/>
				</colgroup>
				<tbody>
					<%
					while(rs.next()) { 
						String attdocid = rs.getString("id");
						String attimagefileid = rs.getString("imagefileid");
						int size = rs.getInt("filesize")/1024;
					%>
						<tr>
							<td>
								<table style="width:100%;">
									<col width="5%"/>
									<col width="55%"/>
									<col width="15%"/>
									<col width="25%"/>
									<tbody>
										<tr>
											<td><%=SptmForDoc.getDocIcon(rs.getString("id")) %></td>
											<td><a target="_blank" href="/docs/docs/DocDsp.jsp?id=<%=attdocid%>"><%=DocComInfo.getDocname(attdocid)%></a></td>
											<td style="color:#8d8d8d;"><%=size%>KB</td>
											<td>
												<a href="#" onclick="downloads('<%=attimagefileid%>');return false;">
													<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage()) %>
												</a>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
							<td>
					<%
							if(rs.next()){
								attdocid = rs.getString("id");
								attimagefileid = rs.getString("imagefileid");
								size = rs.getInt("filesize")/1024;
					%>
								<table style="width:100%;">
									<col width="5%"/>
									<col width="55%"/>
									<col width="15%"/>
									<col width="25%"/>
									<tbody>
										<tr>
											<td><%=SptmForDoc.getDocIcon(rs.getString("id")) %></td>
											<td><a target="_blank" href="/docs/docs/DocDsp.jsp?id=<%=attdocid%>"><%=DocComInfo.getDocname(attdocid)%></a></td>
											<td style="color:#8d8d8d;"><%=size%>KB</td>
											<td>
												<a href="#" onclick="downloads('<%=attimagefileid%>');return false;">
													<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage()) %>
												</a>
											</td>
										</tr>
									</tbody>
								</table>
							<%} %>
							</td>
						</tr>	
					<%} %>
				</tbody>
			</table>
		</div>
	</div>
<%} %>
<script>
function downloads(id){
	document.location.href="/weaver/weaver.file.FileDownload?fileid="+id+"&download=1";
}
</script>