
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.util.CrmUtil"%> 
<%@page import="java.util.regex.*"%> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<%@ page import="weaver.general.Util, weaver.docs.docs.CustomFieldManager" %>
<jsp:useBean id="SocialManageService" class="weaver.social.manager.SocialManageService" scope="page"/>

<%

if (!HrmUserVarify.checkUserRight("message:manager", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
//抓取单点登录配置信息
RecordSet.execute("select sysid,name from outter_sys");
HashMap<String, String> ssoMap = new HashMap<String, String>();
while(RecordSet.next()){
	ssoMap.put(RecordSet.getString("sysid"), RecordSet.getString("name"));
}
%>
<LINK href="/social/css/manager_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<div id="ssoMapOptions" style="display:none;">
	<% for(Map.Entry<String, String> entry : ssoMap.entrySet()) {%>
	<option value="<%=entry.getKey() %>"><%=entry.getValue() %></option>
	<%} %>
</div>
<TABLE class=ListStyle id="oTable" cols=7  border=0 cellspacing=0>
	<COLGROUP>
		<COL width="7%">
		<COL width="15%">
		<COL width="16%">
		<COL width="16%">
		<COL width="10%">
		<COL width="10%">
		<COL width="26%">
	</COLGROUP>
	<TBODY>
    	<tr class=header>
            <th width="5%"><input name="chkAll" type="checkbox" onclick="formCheckAll(this)"><%=SystemEnv.getHtmlLabelName(556, user.getLanguage())%></th>
		  	<th width="15%"><%=SystemEnv.getHtmlLabelName(21557,user.getLanguage())%></th>
		  	<th width="16%"><%=SystemEnv.getHtmlLabelName(125075,user.getLanguage())%>(18*18)</th>
		  	<th width="16%"><%=SystemEnv.getHtmlLabelName(126765,user.getLanguage())%>(18*18)</th>
		  	<th width="10%"><input name="chkAll" type="checkbox" onclick="formCheckAll1(this)"><%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())%></th>
		  	<th width="10%"><%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%></th>
		  	<th width="26%">URL/<%=SystemEnv.getHtmlLabelName(126766,user.getLanguage())%></th>
          </tr>
          
          <%
			String trClass="DataLight";
			int rowsum=0;
			String icouri = "", hoticouri = "", linkuri = "", ifshowon;
			int fieldid, labelindexid, showindex, uritype, ifsysico;
			boolean ifcandel = true, ifcanedit = true;
			String fieldname = "";
			String sql = "select * from Social_Pc_UrlIcons where icotype = '1' order by showindex";
			RecordSet.executeSql(sql);
			Pattern pattern = Pattern.compile("[0-9]*");
			while(RecordSet.next()){
				fieldid = RecordSet.getInt("id");
				labelindexid = RecordSet.getInt("labelindexid");
                showindex = RecordSet.getInt("showindex");
                uritype = RecordSet.getInt("uritype");
                icouri = RecordSet.getString("icouri");
                hoticouri = RecordSet.getString("hoticouri");
                linkuri = RecordSet.getString("linkuri");
                ifshowon = RecordSet.getString("ifshowon");
                ifsysico = RecordSet.getInt("ifsysico");
                if(labelindexid != 0 && labelindexid != -1){
                	fieldname = SystemEnv.getHtmlLabelName(labelindexid, user.getLanguage());
                }else{
                	fieldname = RecordSet.getString("labeltemp");
                }
			%>
			<TR class=<%=trClass%> forsort="ON">
				<TD>
					<%if(ifcandel && ifsysico != 1){ %>
						<input type='checkbox' name='check_select' value="<%=fieldid%>_<%=rowsum%>">
					    <input type='hidden' name='modifyflag_<%=rowsum%>' value="<%=fieldid%>">
					    <input type="hidden" name="candel_<%=rowsum %>" value="y">
					    <input type="hidden" name="ifsysico" value="<%=ifsysico %>">
				    <%}else{ %>
				    	<input type='hidden' name='check_select' value="<%=fieldid%>_<%=rowsum%>">
					    <input type='hidden' name='modifyflag_<%=rowsum%>' value="<%=fieldid%>">
					    <input type="hidden" name="candel_<%=rowsum %>" value="n">
					    <input type="checkbox" disabled="disabled">
					<%} %>	
					<img moveimg="" src="/CRM/images/move_wev8.png" title="<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage()) %>" >				    
				</TD>
				
				<TD>
					<%if(ifcanedit){ %>
						<input class=Inputstyle type=<%=(!ifcandel)?"hidden":"text" %> id="itemDspName_<%=rowsum%>" name="itemDspName_<%=rowsum%>" style="width:90%"  value="<%=Util.toScreen(fieldname,user.getLanguage())%>" onfocus="checkUriTypeByRow(<%=rowsum%>);" onchange="checkinput('itemDspName_<%=rowsum%>','itemDspName_<%=rowsum%>_span');setChange(<%=rowsum%>)">
				  		<span id="itemDspName_<%=rowsum%>_span"><%=(!ifcandel)?Util.toScreen(fieldname,user.getLanguage()):"" %></span>
				  		<input type="hidden" name="olditemDspName_<%=rowsum%>" value="<%=Util.toScreen(fieldname,user.getLanguage())%>" >
				  		<input type="hidden" name="labelIndexId_<%=rowsum%>" value="<%=labelindexid %>" >
			  		<%}else{%>
			  			<input type="hidden" name="itemDspName_<%=rowsum%>" value="<%=Util.toScreen(fieldname,user.getLanguage())%>">
				  		<span id="itemDspName_<%=rowsum%>_span"><%=Util.toScreen(fieldname,user.getLanguage())%></span>
				  		<input type="hidden" name="olditemDspName_<%=rowsum%>" value="<%=Util.toScreen(fieldname,user.getLanguage())%>" >
				  		<input type="hidden" name="labelIndexId_<%=rowsum%>" value="<%=labelindexid %>" >
			  		<%}%>
				</TD>
				
		    	<TD>
					<%if(ifcanedit && ifsysico != 1){ %>
						<div style="display: inline-block;height: 24px;width: 24px;float: left;text-align: center;">
							<span style="height: 100%;display: inline-block;vertical-align: middle;"></span><img id="navico_<%=rowsum %>" onerror="javascript:this.src='/social/images/pcmodels/ftb_default_wev8.png'"  src="<%=pattern.matcher(icouri).matches()?"/weaver/weaver.file.FileDownload?fileid="+icouri:icouri %>" style="max-width: 24px; max-height: 24px;vertical-align: middle;"/>
						</div>
						<div class="navicobtn" style="position: relative;display: none;margin-left: 20px;">
							<button type = 'button' style="background: #30b5ff;color: #fff; width: 75px;height: 24px;text-align: center;">
								<%=SystemEnv.getHtmlLabelName(126779, user.getLanguage()) %>
				  			</button>
				  			<input id="navicobrowser_<%=rowsum %>" type="file" name="navico_<%=rowsum %>" onchange="checkFileType(this);" target="navico" class="Inputstyle" style="position: absolute;left: 0;top: 0;opacity: 0;width: 75px;heigth: 24px;cursor: pointer;" multiple="false" accept="image/gif, image/jpeg, image/png, image/gif">
				  			<input type="hidden" name="oldnavico_<%=rowsum %>" value="<%=icouri %>"> 
			  			</div>
			  			<div style="clear:both;"></div>
			  		<%}else{%>
			  			<div style="display: inline-block;height: 24px;width: 24px;float: left;text-align: center;">
							<span style="height: 100%;display: inline-block;vertical-align: middle;"></span><img id="navico_<%=rowsum %>" onerror="javascript:this.src='/social/images/pcmodels/ftb_default_wev8.png'"  src="<%=pattern.matcher(icouri).matches()?"/weaver/weaver.file.FileDownload?fileid="+icouri:icouri %>" style="max-width: 24px; max-height: 24px;vertical-align: middle;"/>
						</div>
						<input type="hidden" name="oldnavico_<%=rowsum %>" value="<%=icouri %>">
			  		<%}%>
				</TD>
				
				<TD nowrap = 'nowrap'>
					<%if(ifcanedit && ifsysico != 1){ %>
						<div style="display: inline-block;height: 24px;width: 24px;float: left;text-align: center;">
							<span style="height: 100%;display: inline-block;vertical-align: middle;"></span><img id="navhotico_<%=rowsum %>" onerror="javascript:this.src='/social/images/pcmodels/ftb_default_h_wev8.png'"  src="<%=pattern.matcher(hoticouri).matches()?"/weaver/weaver.file.FileDownload?fileid="+hoticouri:hoticouri %>" style="max-width: 24px; max-height: 24px;"/>
						</div>
						<div class="navhoticobtn" style="position: relative;display: none;margin-left: 20px;">
							<button type = 'button' style="background: #30b5ff;color: #fff; width: 75px;height: 24px;text-align: center;">
								<%=SystemEnv.getHtmlLabelName(126779, user.getLanguage()) %>
				  			</button>
				  			<input id="navhoticobrowser_<%=rowsum %>" type="file" name="navhotico_<%=rowsum %>" onchange="checkFileType(this);" target="navhotico" class="Inputstyle" style="position: absolute;left: 0;top: 0;opacity: 0;width: 75px;heigth: 24px;cursor: pointer;" multiple="false" accept="image/gif, image/jpeg, image/png, image/gif">
			  				<input type="hidden" name="oldnavhotico_<%=rowsum %>" value="<%=hoticouri %>"> 
			  			</div>
			  			<div style="clear:both;"></div>
			  		<%}else{%>
			  			<div style="display: inline-block;height: 24px;width: 24px;float: left;text-align: center;">
							<span style="height: 100%;display: inline-block;vertical-align: middle;"></span><img id="navhotico_<%=rowsum %>" onerror="javascript:this.src='/social/images/pcmodels/ftb_default_h_wev8.png'"  src="<%=pattern.matcher(hoticouri).matches()?"/weaver/weaver.file.FileDownload?fileid="+hoticouri:hoticouri %>" style="max-width: 24px; max-height: 24px;"/>
						</div>
						<input type="hidden" name="oldnavhotico_<%=rowsum %>" value="<%=hoticouri %>">
			  		<%}%>
				</TD>
				
				<TD NOWRAP>
					<input type='checkbox' name='isopen_<%=rowsum%>' value='<%=ifshowon%>' rowindex='<%=rowsum%>' <%if(ifshowon.equals("1")){%>checked<%}%> <%if(!ifcanedit){%>disabled="disabled"<%}%> onchange="checkSelect(this, '<%=rowsum %>');setChange('<%=rowsum %>');">
					<input type='hidden' name='isopen_<%=rowsum%>' value="<%=ifshowon%>">
				</TD>
				
				<TD NOWRAP>
					<!-- 动态链接 -->
					<select name='groupid_<%=rowsum %>' <%if(!ifcanedit || ifsysico == 1){out.print("disabled='true'");}%> onchange='checkUriType(this,"<%=rowsum %>");setChange("<%=rowsum %>")' style='width:100px;'>
						<option <%if(uritype == 0){%>selected<%}%> value='0'><%=SystemEnv.getHtmlLabelName(126788, user.getLanguage()) %></option>
						<option <%if(uritype == 1){%>selected<%}%> value='1'><%=SystemEnv.getHtmlLabelName(126787, user.getLanguage()) %></option>
						<option <%if(uritype == 2){%>selected<%}%> value='2'><%=SystemEnv.getHtmlLabelName(126789, user.getLanguage()) %></option>
					</select>
				</TD>
				
				<TD NOWRAP>
					<%if(ifcanedit && ifsysico != 1){ %>
						<input class=Inputstyle type=<%=(!ifcandel)?"hidden":"text" %> id="itemLinkUri_<%=rowsum%>" name="itemLinkUri_<%=rowsum%>" style="width:90%" value="<%=Util.toScreen(linkuri,user.getLanguage())%>" onfocus="checkUriTypeByRow(<%=rowsum%>);" onchange="checkinput('itemLinkUri_<%=rowsum%>','itemLinkUri_<%=rowsum%>_span');setChange(<%=rowsum%>)">
				  		<!-- 单点登录选择框 -->
				  		<span class="ssoWrap_<%=rowsum%>_span" style="display:none;">
					  		<select name="itemLinkUri_<%=rowsum%>" style="width:160px;" onchange="setChange(<%=rowsum %>)">
					  			<% for(Map.Entry<String, String> entry : ssoMap.entrySet()) { if(entry.getKey().equals(linkuri)){%>
					  			<option selected="selected" value="<%=entry.getKey() %>"><%=entry.getValue() %></option>
					  			<%}else{ %>
					  			<option value="<%=entry.getKey() %>"><%=entry.getValue() %></option>
					  			<%}}%>
					  		</select>
					  	</span>
				  		<span id="itemLinkUri_<%=rowsum%>_span" class="span-ellipsis-211"><%=(!ifcandel)?Util.toScreen(linkuri,user.getLanguage()):"" %></span>
				  		<input type="hidden" name="olditemLinkUri_<%=rowsum%>" value="<%=Util.toScreen(linkuri,user.getLanguage())%>" >
			  		<%}else{%>
			  			<input type="hidden" id="itemLinkUri_<%=rowsum%>" name="itemLinkUri_<%=rowsum%>" value="<%=Util.toScreen(linkuri,user.getLanguage())%>">
				  		<span id="itemLinkUri_<%=rowsum%>_span" class="span-ellipsis-211"><%=Util.toScreen(linkuri,user.getLanguage())%></span>
				  		<input type="hidden" name="olditemLinkUri_<%=rowsum%>" value="<%=Util.toScreen(linkuri,user.getLanguage())%>" >
			  		<%}%>
				</TD>
	    	</TR>	
			<%
				rowsum++;
			} %>
	</TBODY>
</TABLE>
