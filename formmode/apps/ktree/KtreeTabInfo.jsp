
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="com.weaver.formmodel.apps.ktree.KtreeFunction"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	
	KtreeFunction ktreeFunction = new KtreeFunction();
	String versionid = Util.null2String(request.getParameter("versionid"));
	String functionid = Util.null2String(request.getParameter("functionid"));
	User user = HrmUserVarify.getUser(request,response);
%>
  	 <div class="tabsContainer">
		<div class="tabs">
			<ul>
				<%
					int idx = 0;
					String firstid = "";
					StringBuffer str = new StringBuffer();
					RecordSet.executeSql("select * from uf_ktree_tabinfo where pid=''");
					while(RecordSet.next()){
						idx++;
						String tabid = Util.null2String(RecordSet.getString("id"));
						boolean isnew = ktreeFunction.isnew(versionid,functionid,user.getUID(),tabid);
						if(idx==1){ 
							firstid = tabid;
							str.append("<li href=\"#subtabs-"+idx+"\" _versionId="+versionid+" _functionId="+functionid+" _tabId="+tabid+" defaultSelected=\"true\">");
						}else{
							str.append("<li href=\"#subtabs-"+idx+"\" _versionId="+versionid+" _functionId="+functionid+" _tabId="+tabid+">");
						}
						str.append("<a>"+Util.null2String(RecordSet.getString("tabname"))+"</a>");
						if(isnew){
							str.append("<img src=\"/formmode/apps/ktree/images/BDNew_wev8.png\"/>");
						}
						str.append("</li>");
					}
				%>
					<% out.print(str.toString()); %>
			</ul>
		</div>
			<%
				idx = 0;
				StringBuffer firstDivBuffer = new StringBuffer();
				if(!StringHelper.isEmpty(firstid)){
					RecordSet.executeSql("select * from uf_ktree_tabinfo where pid="+firstid+" ");
					if(RecordSet.getCounts()>0){
						firstDivBuffer.append("<div id=\"subtabs-1\" class=\"subtabs\"><ul>");
						while(RecordSet.next()){
							idx++;
							String tabid = Util.null2String(RecordSet.getString("id"));
							boolean isnew = ktreeFunction.isnew(versionid,functionid,user.getUID(),tabid);
							if(idx==1){
								firstDivBuffer.append("<li onclick=\"changeFrameUrl('"+tabid+"');\" _tabId="+tabid+" defaultSelected=\"true\">");
							}else{
								firstDivBuffer.append("<li onclick=\"changeFrameUrl('"+tabid+"');\" _tabId="+tabid+">");
							}
							firstDivBuffer.append("<a>"+Util.null2String(RecordSet.getString("tabname"))+"</a>");
							if(isnew){
								firstDivBuffer.append("<img src=\"/formmode/apps/ktree/images/BDNew_wev8.png\"/>");
							}
							firstDivBuffer.append("</li>");
						}
						firstDivBuffer.append("</ul></div>");
					}
				}
			%>
			<% out.print(firstDivBuffer.toString()); %>
		</div>
		<div class="frameContainer">
			<iframe id="tabFrame" name="tabFrame" frameborder="0" style="width: 100%;" scrolling="no" src="" onload="whenFrameLoaded();">
					
			</iframe>
		</div>
