
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<%

request.setCharacterEncoding("UTF-8");
String votingid=request.getParameter("votingid");
String questionid=request.getParameter("questionid");
String subcompanyid=request.getParameter("subid");
// 1 为其他选项
String isother = request.getParameter("isother")+"";
String navname = SystemEnv.getHtmlLabelName(21703,user.getLanguage());
if(!"".equals(isother)){
	navname = SystemEnv.getHtmlLabelName(375,user.getLanguage())+SystemEnv.getHtmlLabelName(33368,user.getLanguage());
}
%>

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="voting"/>
   <jsp:param name="navName" value="<%=navname %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name=frmMain action="VotingTypeOperation.jsp" method=post>

		<%
												
			String sqlWhere = " ";
			
			//获取所有
			if("-1".equals(subcompanyid)){
				sqlWhere = " a.votingid='"+votingid+"' and a.questionid='"+questionid+"' and a.resourceid = b.id ";
			}else if(!"".equals(subcompanyid)){
				sqlWhere = " a.votingid='"+votingid+"' and a.questionid='"+questionid+"' and a.resourceid = b.id  and a.resourceid in (select id from HrmResource where subcompanyid1 in ("+subcompanyid+") ) ";
				String[]  firstsubs=Util.TokenizerString2(subcompanyid,",");  
		        if(Util.getIntValue(firstsubs[0],0)<0){
				sqlWhere = " a.votingid='"+votingid+"' and a.questionid='"+questionid+"' and a.resourceid = b.id  and a.resourceid in (select t1.resourceid from HrmResourceVirtual t1,HrmResource t2 where t1.resourceid=t2.id and t1.subcompanyid in ("+subcompanyid+") ) ";				
				}
			}
			//System.out.println(sqlWhere);
			String tableString=""+
			   "<table instanceid=\"docMouldTable\" pagesize=\"100\"  tabletype=\"none\">"+
			   "<sql backfields=\"a.otherinput,b.lastname,a.useranony\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"VotingResourceRemark a, HrmResource b\" sqlorderby=\"votingid\"  sqlprimarykey=\"votingid\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
			   "<head>"+							 
					 "<col width=\"80%\"    text=\""+SystemEnv.getHtmlLabelName(33368,user.getLanguage())+"\" column=\"otherinput\"/>"+
					 "<col width=\"20%\"    text=\""+SystemEnv.getHtmlLabelName(30042,user.getLanguage())+"\" column=\"lastname\" otherpara=\"column:useranony+"+user.getLanguage()+"\" transmethod=\"weaver.voting.VotingManager.getAnonyUserName\" />"+
			   "</head>"+
			   "</table>";
		%> 
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />

</FORM>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 




</BODY></HTML>

