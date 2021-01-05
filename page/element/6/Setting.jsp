
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@	page import="weaver.docs.news.DocNewsComInfo"%>
<%@	page import="weaver.docs.docs.DocComInfo"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.docs.category.*"%>
<%--以下为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/page/element/settingCommon_params.jsp"%>
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
<%@ include file="/page/element/settingCommon_dom.jsp"%>

<%--以上，为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>

<%
String srcType="";  

String strSrcType1="";
String strSrcType2=""; 
String strSrcType3="";
String strSrcType4="";
String strSrcType5="";
String strSrcType6="";
String strSrcType7="";

String srcContent="";
String strSrcContent1="0";
String strSrcContent2="0";
String strSrcContent3="0";
String strSrcContent4="0"; 
String strSrcContent5="0"; 
String strSrcContent6="0"; 
String strSrcContent7="0";

String strSrcContentName1="";
String strSrcContentName2="";
String strSrcContentName3="";
String strSrcContentName4="";
String strSrcContentName5="";
String strSrcContentName6="";
String strSrcContentName7="";

String srcReply="0";
String srcReply1="";
String srcReply2="";
String srcReply3="";
String srcReply4=""; 
String srcReply5=""; 
String srcReply6=""; 
String srcReply7=""; 

boolean isNewReply = weaver.docs.docs.reply.DocReplyUtil.isUseNewReply();	//是否启用新的文档回复

ArrayList docSrcList=Util.TokenizerString(strsqlwhere, "|");
if (docSrcList.size()>0) srcType=(String)docSrcList.get(0);
if (docSrcList.size()>1) srcContent=(String)docSrcList.get(1);
if (docSrcList.size()>2) srcReply=(String)docSrcList.get(2);
String initValue="";
if("1".equals(srcType)) {
	DocNewsComInfo dnc=new DocNewsComInfo();
	strSrcType1=" checked ";
	strSrcContent1=srcContent;
	if("1".equals(srcReply)) srcReply1=" checked ";
	if(!"".equals(srcContent)){
		strSrcContentName1="<a href='/docs/news/NewsDsp.jsp?id="+srcContent+"' target='_blank'>"+dnc.getDocNewsname(srcContent)+"</a>";
	}
	initValue="1|"+srcContent+"|"+srcReply; 
} 
else if("2".equals(srcType)) {
	if("1".equals(srcReply)) srcReply2=" checked ";
	strSrcType2=" checked "; 
	strSrcContent2=srcContent;
	SecCategoryComInfo scc=new SecCategoryComInfo();
	ArrayList secidList=Util.TokenizerString(srcContent, ",");
	for(int i=0;i<secidList.size();i++){
		String secid=(String)secidList.get(i);
		String secname=scc.getSecCategoryname(secid);		
		strSrcContentName2+="<a href='/docs/search/DocSummaryList.jsp?showtype=0&displayUsage=0&seccategory="+secid+"'>"+secname+"</a>&nbsp;";
	}
	
	//strSrcContentName2=scc.getPath(srcContent);
	initValue="2|"+srcContent+"|"+srcReply; 
}
else if("3".equals(srcType)) {
	if("1".equals(srcReply)) srcReply3=" checked ";
	strSrcType3=" checked ";
	strSrcContent3=srcContent;
	DocTreeDocFieldComInfo dtfci=new DocTreeDocFieldComInfo();
	strSrcContentName3=dtfci.getMultiTreeDocFieldNameOther(srcContent);
	initValue="3|"+srcContent+"|"+srcReply; 
}
else if("4".equals(srcType)) {
	if("1".equals(srcReply)) srcReply4=" checked ";
	strSrcType4=" checked ";
	strSrcContent4=srcContent;
	DocComInfo dci=new DocComInfo();	 			
	strSrcContentName4=dci.getMuliDocName2(srcContent);
	initValue="4|"+srcContent+"|"+srcReply; 
}else if("5".equals(srcType)) {
	if("1".equals(srcReply)) srcReply5=" checked ";
	strSrcType5=" checked ";
	strSrcContent5=srcContent+"|"+srcReply; 
				
	strSrcContentName5="";
	initValue="5|"+srcContent;
}else if("6".equals(srcType)) {
	if("1".equals(srcReply)) srcReply6=" checked ";
	strSrcType6=" checked "; 
	strSrcContent6=srcContent; 
				
	strSrcContentName6="";
	initValue="6|"+srcContent+"|"+srcReply; 
}else if("7".equals(srcType)) {  //所有文档
	if("1".equals(srcReply)) srcReply7=" checked ";
	strSrcType7=" checked "; 
	strSrcContent7=srcContent; 
				
	strSrcContentName6="";
	initValue="7|"+srcContent+"|"+srcReply; 
}

if("2".equals(esharelevel)){
%>
<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(20532,user.getLanguage())%></wea:item>
<wea:item><input type="hidden" id="_whereKey_<%=eid %>" name="_whereKey_<%=eid %>" value='<%=initValue%>'>
<TABLE class=viewform bgcolor=#efefef>
<TR>
	<TD>
		<input type=radio  <%=strSrcType2%> onclick=onNewContentCheck(this,<%=eid%>,'cate')  name=rdi_<%=eid%> id=cate_<%=eid%> value='<%=strSrcContent2%>' selecttype=2 >
		<%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%><!--文档目录-->&nbsp;&nbsp;				
		<button type=button class=Browser  onclick=onShowMultiCatalog2(cate_<%=eid%>,spancate_<%=eid%>,<%=eid%>)></BUTTON>
       <SPAN id=spancate_<%=eid%>><%=strSrcContentName2%></SPAN>
       <span style="<%=isNewReply ? "display:none" : "" %>"  >
	    &nbsp;&nbsp;<input id=chkcate_<%=eid%> type=checkbox value=1 <%=srcReply2%> onclick="chkReplyClick(this,'<%=eid%>','cate')"><%=SystemEnv.getHtmlLabelName(20568,user.getLanguage())%>
	   </span>
	</TD>
  </TR> 

  <TR>
	<TD>
	<input type=radio  <%=strSrcType3%> onclick=onNewContentCheck(this,<%=eid%>,'dummy')  name=rdi_<%=eid%> id=dummy_<%=eid%>  value='<%=strSrcContent3%>' selecttype=3 >
		<%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%><!--虚拟目录-->&nbsp;&nbsp;

		<button type=button class=Browser onClick=onShowMutiDummy(dummy_<%=eid%>,spandummy_<%=eid%>,<%=eid%>)></BUTTON>
       <span id=spandummy_<%=eid%> name=spandummy_<%=eid%>><%=strSrcContentName3%></span>
       <span style="<%=isNewReply ? "display:none" : "" %>"  >
     		&nbsp;&nbsp;<input id=chkdummy_<%=eid%> type=checkbox value=1 <%=srcReply3%>  onclick="chkReplyClick(this,'<%=eid%>','dummy')"><%=SystemEnv.getHtmlLabelName(20568,user.getLanguage())%>
     	</span>
	</TD>
  </TR>
  <TR>
	<TD>
		<input type=radio <%=strSrcType7%>  onclick=onNewContentCheck(this,<%=eid%>,'alldocids')  name=rdi_<%=eid%> id=alldocids_<%=eid%>  value='<%=strSrcContent7%>' selecttype=7>
		<%=SystemEnv.getHtmlLabelName(21478,user.getLanguage())%><!--所有文档-->&nbsp;&nbsp;
		<span style="<%=isNewReply ? "display:none" : "" %>"  >
			&nbsp;&nbsp;<input id=chkalldocids_<%=eid%> type=checkbox value=1 <%=srcReply7%>  onclick="chkReplyClick(this,'<%=eid%>','alldocids')"><%=SystemEnv.getHtmlLabelName(20568,user.getLanguage())%>
		</span>
	</TD>
 </TR>
</TABLE>
</wea:item>
<%} %>
	</wea:group>
</wea:layout>
