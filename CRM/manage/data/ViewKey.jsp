
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="RecordSetDemand" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetBase" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSetImportant" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetCompetitor" class="weaver.conn.RecordSet" scope="page" />

<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));


String budget="";
String expectedDate="";
String baseSql = "select budget,expecteddate,projectname,hasbuild,company,cost,situation,evaluate,ifpartners from crm_baseinfo where crmid = "+CustomerID+" order by baseinfoid";
RecordSetBase.executeSql(baseSql);
 
if(RecordSetBase.next()){
	 budget = RecordSetBase.getString("budget");
	 expectedDate = RecordSetBase.getString("expecteddate");
}
RecordSetBase.beforFirst();


String demandSql = "select description,ifKeydemand,ifHelpus from crm_demandinfo where crmid = "+CustomerID+" order by demandinfoid";
RecordSetDemand.executeSql(demandSql);


String importantSql = "select role,name,department,post,telephone,mobile,ifagree,point from crm_importantman where crmid = "+CustomerID+" order by importantmanid";
RecordSetImportant.executeSql(importantSql);
String competitorSql = "select oppname,oppadvantage,oppdisadvantage from crm_competitorsinfo where crmid = "+CustomerID+" order by competitorsid";
RecordSetCompetitor.executeSql(competitorSql);
%>

<TABLE  CLASS="ListStyle" cellspacing="1"  valign="top">
            <TR CLASS="Header">
                <TH colspan="4" style="color: #003F7D">客户基础信息表</TH>
             </TR>
		    <TR>
				<td width="15%">客户方预算</td>
				<td class=Field width="35%"><%=budget %></td>
				<td  width="15%">客户希望上线时间</td>
				<TD class=Field width="35%"><%=expectedDate %></TD>
			</TR>            
			<TR>
				<TD colspan="4" style="">
					<TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="tblTask">
			             <colgroup>
			             <col width="15%">
			             <col width="8%">
			             <col width="15%">
			             <col width="10%">
			             <col width="15%">                       
			             <col width="20%">                       
			             <col width="12%">    
			             </colgroup>                   
			             <TR class="Header">
			                 <TD>项目名称</TD>
			                 <TD>是否建设</TD>
			                 <TD>供应商厂商</TD>
			                 <TD>投入费用</TD>
			                 <TD>目前运行情况</TD>
			                 <TD>客户方内部评价</TD>
			                 <TD>是否是我们的合作伙伴</TD>
			             </TR>
			<% while(RecordSetBase.next()){ %>
			             <tr class="DataLight">
			             	<td><%=RecordSetBase.getString("projectname")%></td>
			             	<td>
			             		<%if(RecordSetBase.getString("hasbuild") !=null && "1".equals(RecordSetBase.getString("hasbuild"))){%>
			             			<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
			             		<%}%>
			             		<%if(RecordSetBase.getString("hasbuild") !=null && "0".equals(RecordSetBase.getString("hasbuild"))){%>
			             			<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
			             		<%}%>
			             	</td>
			             	<td style="word-wrap:break-word;word-break:break-all;" valign="bottom" ><%=RecordSetBase.getString("company")%></td>
			             	<td style="word-wrap:break-word;word-break:break-all;"  valign="bottom" ><%=RecordSetBase.getString("cost")%></td>
			             	<td style="word-wrap:break-word;word-break:break-all;"  valign="bottom" ><%=RecordSetBase.getString("situation")%></td>
			             	<td style="word-wrap:break-word;word-break:break-all;"  valign="bottom" ><%=RecordSetBase.getString("evaluate")%></td>
			             	<td style="word-wrap:break-word;word-break:break-all;"  valign="bottom" >
			             		<%if(RecordSetBase.getString("ifpartners") !=null && "1".equals(RecordSetBase.getString("ifpartners"))){%>
			             			<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
			             		<%}%>
			             		<%if(RecordSetBase.getString("ifpartners") !=null && "0".equals(RecordSetBase.getString("ifpartners"))){%>
			             			<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
			             		<%}%>
			             	</td>
			             </tr>
			<% } %>
			         </TABLE>
				</TD>
			</TR>
		 </TABLE>
         
        <TABLE  CLASS="ListStyle" cellspacing="1" valign="top">
        	<colgroup>
                <col width="60%">
                <col width="15%">
                <col width="15%">  
            </colgroup>
            	<TR CLASS="Header">
                	<TH colspan="3">客户需求信息表</TH>
             	</TR>
                <TR CLASS="Header">
                    <TD>需求描述</TD>
                    <TD>是否为客户关键需求</TD>
                    <TD>是否对我们有利</TD>     
                </TR>
<% while(RecordSetDemand.next()){ %>
                <tr>
	                <td  style="word-wrap:break-word;word-break:break-all;"  valign="bottom"><%=RecordSetDemand.getString("description")%></td>
	                <td>
	             		<%if(RecordSetDemand.getString("ifKeydemand") !=null && "1".equals(RecordSetDemand.getString("ifKeydemand"))){%>
	             			<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	             		<%}%>
	             		<%if(RecordSetDemand.getString("ifKeydemand") !=null && "0".equals(RecordSetDemand.getString("ifKeydemand"))){%>
	             			<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	             		<%}%>
	                </td>
	                <td>
	             		<%if(RecordSetDemand.getString("ifHelpus") !=null && "1".equals(RecordSetDemand.getString("ifHelpus"))){%>
	             			<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	             		<%}%>
	             		<%if(RecordSetDemand.getString("ifHelpus") !=null && "0".equals(RecordSetDemand.getString("ifHelpus"))){%>
	             			<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	             		<%}%>
	                </td>
                </tr>
<%} %>
            </TABLE>
        <TABLE  CLASS="ListStyle" cellspacing="1"  valign="top">
        	<colgroup>
                <col width="14%">
                <col width="8%">
                <col width="10%">
                <col width="10%">
                <col width="8%">                       
                <col width="10%">                       
                <col width="10%">                       
                <col width="30%">
            </colgroup>      
            	<TR CLASS="Header">
                	<TH colspan="8">关键人信息</TH>
             	</TR>
                <TR class="Header">
                    <TD>项目中的角色</TD>
                    <TD>人名</TD>
                    <TD>部门</TD>
                    <TD>职务</TD>
                    <TD>办公电话</TD>
                    <TD>手机</TD>
                    <TD>是否已加入我们</TD>
                    <TD>他们每一个人的关注点</TD>     
                </TR>
<% while(RecordSetImportant.next()){ %>
                <tr class="DataLight">
                    <td style="word-wrap:break-word;word-break:break-all;" valign="bottom"><%=RecordSetImportant.getString("role")%></td>
                    <td style="word-wrap:break-word;word-break:break-all;" valign="bottom"><%=RecordSetImportant.getString("name")%></td>
                    <td style="word-wrap:break-word;word-break:break-all;" valign="bottom"><%=RecordSetImportant.getString("department")%></td>
                    <td style="word-wrap:break-word;word-break:break-all;" valign="bottom"><%=RecordSetImportant.getString("post")%></td>
                    <td style="word-wrap:break-word;word-break:break-all;" valign="bottom"><%=RecordSetImportant.getString("telephone")%></td>
                    <td style="word-wrap:break-word;word-break:break-all;" valign="bottom"><%=RecordSetImportant.getString("mobile")%></td>
                    <td> 
	             		<%if(RecordSetImportant.getString("ifagree") !=null && "1".equals(RecordSetImportant.getString("ifagree"))){%>
	             			<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	             		<%}%>
	             		<%if(RecordSetImportant.getString("ifagree") !=null && "0".equals(RecordSetImportant.getString("ifagree"))){%>
	             			<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	             		<%}%>
                    </td>
                    <td style="word-wrap:break-word;word-break:break-all;" valign="bottom"><%=RecordSetImportant.getString("point")%></td>     
                </tr>
<%} %>
            </TABLE>
	       <TABLE  CLASS="ListStyle" cellspacing="1"  valign="top">
	       		 <colgroup>
	               <col width="20%">
	               <col width="40%">
	               <col width="40%">   
	             </colgroup>
	           	 <TR CLASS="Header">
	               <TH colspan="3">竞争对手动态跟进</TH>
	           	 </TR>
	               <tr class="Header">
	                   <TD>对手名称</TD>
	                   <TD>竞争对手优势</TD>
	                   <TD>竞争对手劣势</TD>     
	               </tr>
<% while(RecordSetCompetitor.next()){ %>
	                <tr>
		                <td style="word-wrap:break-word;word-break:break-all;" valign="bottom"><%=RecordSetCompetitor.getString("oppname")%></td>
		                <td style="word-wrap:break-word;word-break:break-all;" valign="bottom"><%=RecordSetCompetitor.getString("oppadvantage")%></td>
		                <td style="word-wrap:break-word;word-break:break-all;" valign="bottom"><%=RecordSetCompetitor.getString("oppdisadvantage")%></td>
	                </tr>   
<%} %>
	           </TABLE>
</body>
</html>


