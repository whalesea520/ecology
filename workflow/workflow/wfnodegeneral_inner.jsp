<%@ page import="javax.sound.midi.SoundbankResource" %>
<%@ page import="vba.word.System" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<%

	boolean isNewForm ="true".equals(Util.null2String(request.getParameter("isNewForm")));
 	boolean iscptbill ="true".equals(Util.null2String(request.getParameter("iscptbill")));

 	String isopensapmul = Util.null2String(request.getParameter("isopensapmul"));
	String dtldefault = Util.null2String(request.getParameter("dtldefault"));
	String dtlneed = Util.null2String(request.getParameter("dtlneed"));
	String dtladd = Util.null2String(request.getParameter("dtladd"));
	String dtlhide = Util.null2String(request.getParameter("dtlhide"));
	String defaultrow = Util.null2String(request.getParameter("defaultrow"));
	String dtledit = Util.null2String(request.getParameter("dtledit"));
	String dtldelete = Util.null2String(request.getParameter("dtldelete"));
	String nodetype = Util.null2String(request.getParameter("nodetype"));
	String dtldisabled = Util.null2String(request.getParameter("dtldisabled"));

	int groupid = Util.getIntValue(Util.null2String(request.getParameter("groupid")));
	int formid = Util.getIntValue(Util.null2String(request.getParameter("formid")));

%>

<wea:layout type="2col" needImportDefaultJsAndCss="false">
	<%if(isNewForm){ %>
	<!-- 节点属性字段 - 普通模版 - 明细 start -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())+""+groupid%>'>
		<wea:item type="groupHead"><div class="e8normaltd"></div></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" id="dt_add" name="dtl_add_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtladd%><%}%>>
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="dtl_edit_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtledit%><%}%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="dtl_del_<%=groupid%>" onClick="" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtldelete%><%}%>>
		</wea:item>
		<%
			if(!nodetype.equals("3"))
			{
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" <%=dtladd.equals(" checked")?"":"disabled" %> id="dt_ned" name="dtl_ned_<%=groupid%>" onClick="" <%=dtlneed%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" <%=dtladd.equals(" checked")?"":"disabled" %> id="dt_def"  name="dtl_def_<%=groupid%>" onClick="" <%=dtldefault%>>
			<input type="text" <%=dtladd.equals(" checked")?"":"disabled" %> name="dtl_defrow<%=groupid%>" onkeypress="ItemCount_KeyPress()" onchange="checkcount2(this);" value="<%=defaultrow%>" style="width:30px;">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31592,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" <%=dtladd.equals(" checked")?"":"disabled" %> id="dt_mul" name="dtl_mul_<%=groupid%>" onClick="" <%=isopensapmul%>>
		</wea:item>
		<%} %>
		<wea:item><%=SystemEnv.getHtmlLabelName(22363,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="hide_del_<%=groupid%>" onClick="" <%=dtlhide%>>
		</wea:item>
	</wea:group>
	<%}else{%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())+""+groupid%>'>
		<% if(formid==7||formid==156 || formid==157 || formid==158 || formid==159 || iscptbill){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="dtl_add_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtladd%><%}%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="dtl_edit_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtledit%><%}%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="dtl_del_<%=groupid%>" onClick="" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtldelete%><%}%>>
		</wea:item>
		<%
			if(!nodetype.equals("3"))
			{
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" <%=dtladd.equals(" checked")?"":"disabled" %> id="dt_ned" name="dtl_ned_<%=groupid%>" onClick="" <%=dtlneed%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" <%=dtladd.equals(" checked")?"":"disabled" %> id="dt_def"  name="dtl_def_<%=groupid%>" onClick="" <%=dtldefault%>>
			<input type="text" <%=dtladd.equals(" checked")?"":"disabled" %> name="dtl_defrow<%=groupid%>" onkeypress="ItemCount_KeyPress()" onchange="checkcount2(this);" value="<%=defaultrow %>" style="width:30px;">
		</wea:item>
		<%} %>
		<%} %>
	</wea:group>
	<%} %>
</wea:layout>