
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="csm" class="weaver.cowork.CoworkShareManager" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
String coworkid = Util.null2String(request.getParameter("coworkid"));

%>
<div class="lettercontainer">
	     <div class="C  signalletter" style="background:url('/cowork/images/icon_condition_wev8.png') no-repeat;"><%=SystemEnv.getHtmlLabelName(83210,user.getLanguage())%></div>
		 <div class="clear"></div>
		 
		 <div id="weavertabs-condition">		 
			<TABLE id="tbl" class="ListStyle" cellspacing="1" width="100%" style="margin:3px 0 5px 0">
			
					<COL width="20%"/>
					<COL width="50%"/>
					<COL width="30%"/>
					
					<%
						List alist=csm.getShareConditionStrList(""+coworkid);
					    for(int i=0;i<alist.size();i++){
						    HashMap hm=(HashMap)alist.get(i);
						    String type=Util.null2String(hm.get("type"));
							int typelabel=Util.getIntValue((String)hm.get("typeName"));
					%>	
							<tr shareid="<%=hm.get("shareid")%>" class="<%=i%2==0?"DataDark":"DataLight"%>">
								<td><%=SystemEnv.getHtmlLabelName(typelabel, user.getLanguage())%></td>
								<td style='word-break:break-all'>
								   <span class="showrelatedsharename" id="showrelatedsharename_<%=hm.get("shareid")%>" name="showrelatedsharename">
								      <%=hm.get("contentName")%>
								   </span>
								</td>
								<td align="center">
									<%if(!type.equals("1")&&!type.equals("6")){%>
								      <%=hm.get("seclevel")%>-<%=hm.get("seclevelMax")%>
								    <%}%>  
								    <%if(type.equals("6")){%>
								      <%=hm.get("jobsope")%>
								    <%}%>  
								</td>
							</tr>
					<% }%>
			</TABLE>
			</div>
	</div>

	<div class="lettercontainer">
	     <div class="C  signalletter" style="background:url('/cowork/images/icon_join_wev8.png') no-repeat;"><%=SystemEnv.getHtmlLabelName(18605,user.getLanguage())%></div>
		 
		 <div class="clear"></div> 
		 
		 <div id="weavertabs-hrm">
		     <table class="ListStyle" cellspacing="1" width="100%" style="margin:3px 0 5px 0">
		       <colgroup>
		       <col width="20%"/>
		       <col width="80%"/>
		       <tr class="DataLight">
		           <td valign="top"><%=SystemEnv.getHtmlLabelName(17689, user.getLanguage())%></td><!-- 参与者 -->
		           <td>
		               <%
		                List parterids=csm.getShareList("parter",""+coworkid);
						for(int i=0;i<parterids.size()&&i<20;i++){
		                	String resourceid=(String)parterids.get(i);       
						%>
						  <a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>" target="_blank"><%=Util.toScreen(resourceComInfo.getResourcename((String)resourceid),user.getLanguage())%></a>
						<%}
						if(parterids.size()>20){
						%>	
						<button type="button" class="cancelBtn" onclick="$(this).hide().next().show();"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></button>
						<span style="display:none;">
						<%for(int i=20;i<parterids.size();i++){
		                	String resourceid=(String)parterids.get(i); %>
		                	<a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>" target="_blank"><%=Util.toScreen(resourceComInfo.getResourcename((String)resourceid),user.getLanguage())%></a>
						<%}%>
						</span>
						<%}%>
		           </td>
		       </tr>
		       <tr class="DataDark">
		           <td valign="top"><%=SystemEnv.getHtmlLabelName(25472, user.getLanguage())%></td><!-- 关注者 -->
		           <td>
		           <% 
		             List   typemanagerids=csm.getShareList("typemanager",""+coworkid);
		             for(int i=0;i<typemanagerids.size()&&i<20;i++){
		             	String resourceid=(String)typemanagerids.get(i);
		             %>  
						<a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>" target="_blank"><%=Util.toScreen(resourceComInfo.getResourcename((String)resourceid),user.getLanguage())%></a>
					<%} %>
					<%
					if(typemanagerids.size()>20){
					%>	
					<button type="button" class="cancelBtn" onclick="$(this).hide().next().show();"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></button>
					<span style="display:none;">
					<%for(int i=20;i<typemanagerids.size();i++){
	                	String resourceid=(String)typemanagerids.get(i); %>
	                	<a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>" target="_blank"><%=Util.toScreen(resourceComInfo.getResourcename((String)resourceid),user.getLanguage())%></a>
					<%}%>
					</span>
					<%}%>	
			       </td>
		       </tr>
		    </table>
		 </div>
		 
	</div>
	
	<%
		List noReadids=csm.getNoreadUseridList(""+coworkid);
		if(noReadids.size()>0){
	%>
		<div class="lettercontainer">
		     <div class="C  signalletter" style="background:url('/cowork/images/icon_noread_wev8.png') no-repeat;"><%=SystemEnv.getHtmlLabelName(17696,user.getLanguage())%></div>
			 <div class="clear"></div>
			 
			 <div>
			 <table class="ListStyle" cellspacing="1" width="100%" style="margin:3px 0 5px 0">
		       <colgroup>
		       <col width="20%"/>
		       <col width="80%"/>
		       <tr class="DataLight">
		           <td valign="top"><%=SystemEnv.getHtmlLabelName(17696,user.getLanguage())%></td><!-- 参与者 -->
		           <td>
		              <%
							for(int i=0;i<noReadids.size()&&i<20;i++){
							String resourceid=(String)noReadids.get(i);
					  %>
						   <a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>" target="_blank"><%=Util.toScreen(resourceComInfo.getResourcename((String)resourceid),user.getLanguage())%></a>
					  <%}%>	
					  <%
						if(noReadids.size()>20){
					  %>	
						<button type="button" class="cancelBtn" onclick="$(this).hide().next().show();"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></button>
						<span style="display:none;">
						<%for(int i=20;i<noReadids.size();i++){
		                	String resourceid=(String)noReadids.get(i); %>
		                	<a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>" target="_blank"><%=Util.toScreen(resourceComInfo.getResourcename((String)resourceid),user.getLanguage())%></a>
						<%}%>
						</span>
					 <%}%>
		           </td>
		       </tr>
		    </table>
			 	
			 </div>
		</div>
	<%}%>