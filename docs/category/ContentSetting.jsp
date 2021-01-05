
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.conn.RecordSet"%>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="MouldBookMarkComInfo" class="weaver.docs.bookmark.MouldBookMarkComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
int docSecCategoryMouldId = Util.getIntValue(request.getParameter("id"));
int secCategoryId = Util.getIntValue(request.getParameter("seccategory"));
int mouldId = Util.getIntValue(request.getParameter("mould"));
%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSubmit();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM METHOD="POST" name="SearchForm" action="ContentSettingOperation.jsp">
<input type=hidden name="docSecCategoryMouldId" value="<%=docSecCategoryMouldId%>">
<input type=hidden name="seccategory" value="<%=secCategoryId%>">
<input type=hidden name="mould" value="<%=mouldId%>">
<input type=hidden name="operation" value="save">

<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" onclick="onSubmit()" class=btn accessKey=L id=btnsave><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<BUTTON type='button' class=btn accessKey=C onclick="window.close()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
</DIV>

<wea:layout type="table" attributes="{'cols':'2','cw1':'35%','cw2':'65%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19451,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></wea:item>
		<%
		RecordSet rs = new RecordSet();
		RecordSet rs1 = new RecordSet();
		//rs.executeSql("select * from mouldbookmark a left join DocSecCategoryMouldBookMark b on a.id = b.BookMarkId and b.docSecCategoryMouldId = "+docSecCategoryMouldId+" where a.mouldid = "+mouldId);
		rs.executeSql("select * from mouldbookmark a left join DocSecCategoryMouldBookMark b on a.id = b.BookMarkId and b.docSecCategoryMouldId = "+docSecCategoryMouldId+" where a.mouldid = "+mouldId+" order by a.showOrder asc,a.id asc");
		while(rs.next()){
			int bookMarkId = rs.getInt("id");
			String bookmarkName = MouldBookMarkComInfo.getMouldBookMarkName(""+bookMarkId);
			int docSecCategoryDocPropertyId = Util.getIntValue(rs.getString("DocSecCategoryDocPropertyId"),0);
			String docSecCategoryDocPropertyName = Util.null2String((Util.getIntValue(SecCategoryDocPropertiesComInfo.getIsCustom(docSecCategoryDocPropertyId+""))==1||(SecCategoryDocPropertiesComInfo.getCustomName(docSecCategoryDocPropertyId+"",user.getLanguage())!=null&&!"".equals(SecCategoryDocPropertiesComInfo.getCustomName(docSecCategoryDocPropertyId+""))))?SecCategoryDocPropertiesComInfo.getCustomName(docSecCategoryDocPropertyId+"",user.getLanguage()):SystemEnv.getHtmlLabelName(Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(docSecCategoryDocPropertyId+"")), user.getLanguage()));
		%>
			<wea:item><%=bookmarkName%><input type=hidden name="bookMarkId" value='<%=bookMarkId%>'></wea:item>
			<wea:item>
				<span>
				   <%String browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/DocSecCategoryDocPropertyBrowser.jsp?seccategory="+secCategoryId; %>
				   <brow:browser viewType="0" name="docSecCategoryDocPropertyId" idKey="id" nameKey="name" browserValue='<%=docSecCategoryDocPropertyId>0?""+docSecCategoryDocPropertyId:""%>' 
					browserUrl='<%=browserUrl %>'
					hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1" language='<%=""+user.getLanguage() %>'
					completeUrl="/data.jsp" linkUrl="#" temptitle='<%=SystemEnv.getHtmlLabelName(19451,user.getLanguage())%>'
					browserSpanValue='<%= docSecCategoryDocPropertyName%>'></brow:browser>
			</span>	
			</wea:item>
		<%}%>
	</wea:group>
</wea:layout>
</FORM>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
					</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>	
</BODY></HTML>
<script type="text/javascript">

function onBack(){
	location.href="DocSecCategoryEdit.jsp?id=<%=secCategoryId%>&tab=4";
}
function onSubmit(){
	document.SearchForm.submit();
}
</script>


