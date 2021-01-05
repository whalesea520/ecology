
<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8"%>

<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.general.*,weaver.hrm.*,java.util.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs02" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="DocMouldComInfo1" class="weaver.docs.mouldfile.DocMouldComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<% 
response.setContentType("application/vnd.ms-excel;charset=UTF-8");
response.setHeader("Content-disposition", "attachment;filename=basedata_docexcel.xls");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
if(! HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%!
//根据操作权限，共享下载权限判断最终的下载权限
private String setDLValueInit(String strDLValue, String strOprateValue) {
	String strDLNewValue = "0";
	if (strDLValue != null && !"".equals(strDLValue)) {
		strDLNewValue = strDLValue;
	} else if("1".equals(strOprateValue) || "2".equals(strOprateValue) || "3".equals(strOprateValue)) {
		strDLNewValue = "1";
	} else if("0".equals(strOprateValue)) {
		strDLNewValue = "0";
	}
	return strDLNewValue;
}
/** TD12005 文档下载权限控制   结束 */
%>
<%
int pagepos=Util.getIntValue(Util.null2String(request.getParameter("pagepos")),1);
String type=Util.fromScreen(request.getParameter("type"),user.getLanguage()) ;
String mainid=Util.fromScreen(request.getParameter("mainid"),user.getLanguage()) ;
String subid=Util.fromScreen(request.getParameter("subid"),user.getLanguage()) ;
String secid=Util.fromScreen(request.getParameter("secid"),user.getLanguage()) ;
if(type.equals("main")){
	subid = "";
	secid = "";
}else if(type.equals("sub")){
	secid = "";
}

String wfid=Util.fromScreen(request.getParameter("wfid"),user.getLanguage()) ;
ArrayList list = new ArrayList();
%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<style type="text/css">
	TABLE {
		FONT-SIZE: 9pt; FONT-FAMILY: Verdana
	}
	TABLE.Shadow {
		border: #000000 ;
		width:100% ;
		height:100% ;
		BORDER-color:#ffffff;
		BORDER-TOP: 3px outset #ffffff;
		BORDER-RIGHT: 3px outset #000000;
		BORDER-BOTTOM: 3px outset #000000;
		BORDER-LEFT: 3px outset #ffffff;
		BACKGROUND-COLOR:#FFFFFF;
		table-layout:fixed;
	}
	TABLE.ListStyle {
		width:100% ;
		table-layout:fixed;
		BACKGROUND-COLOR: #FFFFFF ;
		BORDER-Spacing:1pt ; 
	}
	
	TABLE.ListStyle TR.Title TH {
		TEXT-ALIGN: left
	}
	TABLE.ListStyle TR.Spacing {
		HEIGHT: 1px
	}
	TABLE.ListStyle TR.Header {
		COLOR: #003366; BACKGROUND-COLOR: #C8C8C8 ; HEIGHT: 30px ;BORDER-Spacing:1pt
	}
	TABLE.ListStyle TR.Header TD {
		COLOR: #003366;
		TEXT-ALIGN: left;
	}
	TABLE.ListStyle TR.Header TH {
		COLOR: #003366 ;
		TEXT-ALIGN: left;
	}
	
	TABLE.ListStyle TR.DataDark {
		BACKGROUND-COLOR: #F7F7F7 ; HEIGHT: 22px ; BORDER-Spacing:1pt
	}
	TABLE.ListStyle TR.DataDark TD {
		PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
	}
	
	TABLE.ListStyle TR.DataLight {
		BACKGROUND-COLOR: #FFFFFF ; HEIGHT: 22px ; BORDER-Spacing:1pt 
	}
	TABLE.ListStyle TR.DataLight TD {
		PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
	}
	TABLE.ListStyle TR.Selected {
		BACKGROUND-COLOR: #EAEAEA ; HEIGHT: 22px ; BORDER-Spacing:1pt 
	}
	TABLE.ListStyle TR.Selected TD {
		PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
	}
	</style>
	<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top">
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
				<TABLE class=ListStyle cellspacing=1 border="1">
				  <COLGROUP>
				  <COL width="5%"><COL width="9%">
				  <COL width="5%"><COL width="9%">
				  <COL width="5%"><COL width="9%">
				  <COL width="5%"><COL width="9%">
				  <COL width="5%"><COL width="9%">
				  <COL width="5%"><COL width="9%">
				  <COL width="5%"><COL width="9%">
				  <TBODY>
				  <TR class=Header >
				    <TH colspan="14"><%=SystemEnv.getHtmlLabelName(15056,user.getLanguage())%></TH>
				  </TR>
				<%
				int countsize = 0;
				int pagesizes = 0;
				int currentpagestart = 0;
				int currentpageend = 0;
				String tmpmain="" ;
				String tmpsub ="" ;
				String sqlwhere = "";
				if(!mainid.equals(""))  
					sqlwhere += " and t3.id = "+mainid;
				if(!subid.equals(""))  
					sqlwhere += " and t2.id = "+subid;
				if(!secid.equals(""))  
					sqlwhere += " and t1.id = "+secid;
				if(!wfid.equals(""))  
					sqlwhere += " and t1.approveworkflowid = "+wfid;
				String sql = "select count(*) from DocSecCategory t1,DocSubCategory t2,DocMainCategory t3 where t1. subcategoryid = t2.id and t2.maincategoryid = t3.id "+sqlwhere;
				//out.println(sql);
				RecordSet.executeSql(sql);
				if(RecordSet.next())
				{
					countsize = RecordSet.getInt(1);
				}
				pagesizes = countsize%10==0?countsize/10:(countsize/10+1);
				if(pagepos<=0)
				{
					pagepos = 1;
				}
				if(pagepos>=pagesizes)
				{
					pagepos = pagesizes;
				}
				
				currentpagestart = (pagepos-1)*10<0?0:(pagepos-1)*10;
				currentpageend = (pagepos*10>countsize)?countsize:pagepos*10;
				int currentpagesize = currentpageend-currentpagestart;
				//out.println("currentpagestart : "+currentpagestart+"   currentpageend : "+currentpageend);
				if(RecordSet.getDBType().equals("oracle"))
				{
					
					sql = "select * "+
						  "	  from (select rownum as rowno, r.* "+
						  "	          from (select t1.* "+
						  "	                  from DocSecCategory  t1, "+
						  "	                       DocSubCategory  t2, "+
						  "	                       DocMainCategory t3 "+
						  "	                 where t1. subcategoryid = t2.id "+
						  "	                   and t2.maincategoryid = t3.id "+sqlwhere+
						  "	                 order by t3.categoryorder, t2.id) r) c "+
						  "	 where c.rowno <= "+currentpageend+
						  "	   and c.rowno > "+currentpagestart;
						  
				}
				else
				{
					sql = "select top "+currentpagesize+" c.* "+
				  "	  from (select top "+currentpagesize+" r.* "+
				  "	          from (select  t1.*, "+
				  "						   t3.categoryorder "+
				  "	                  from DocSecCategory  t1, "+
				  "	                       DocSubCategory  t2, "+
				  "	                       DocMainCategory t3 "+
				  "	                 where t1. subcategoryid = t2.id "+
				  "	                   and t2.maincategoryid = t3.id "+sqlwhere+
				  "	                  ) r where r.id not in (select top "+(pagepos*10-10)+" t1.id "+
				  "	                  from DocSecCategory  t1, "+
				  "	                       DocSubCategory  t2, "+
				  "	                       DocMainCategory t3 "+
				  "	                 where t1. subcategoryid = t2.id "+
				  "	                   and t2.maincategoryid = t3.id "+sqlwhere+
				  "	                 order by t1.id asc ) "+
				  "  ) c "+
				  "	 order by c.categoryorder asc, c.id asc";
				}
				//out.println(sql);
				RecordSet.executeSql(sql);
				while(RecordSet.next()){
				    String seccategoryid=RecordSet.getString("id");
				    String coder=RecordSet.getString("coder");
				    String seccategoryname=RecordSet.getString("categoryname");
				    String subcategoryid=RecordSet.getString("subcategoryid");
				    String subcategoryname=SubCategoryComInfo.getSubCategoryname(subcategoryid) ;
				    String maincategoryid=SubCategoryComInfo.getMainCategoryid(subcategoryid) ;
				    String maincategoryname=MainCategoryComInfo.getMainCategoryname(maincategoryid) ;
				    String approvewfid=RecordSet.getString("approveworkflowid") ;
				    String publishable=RecordSet.getString("publishable") ;
				    String replyable=RecordSet.getString("replyable") ;
				    String hasasset=RecordSet.getString("hasasset");
				    String assetlabel=RecordSet.getString("assetlabel");
				    String hashrmres=RecordSet.getString("hashrmres");
					String hrmreslabel=RecordSet.getString("hrmreslabel");
					String hascrm=RecordSet.getString("hascrm");
					String crmlabel=RecordSet.getString("crmlabel");
					String hasproject=RecordSet.getString("hasproject");
					String projectlabel=RecordSet.getString("projectlabel");
				    String markable=RecordSet.getString("markable") ;
				    String markAnonymity=RecordSet.getString("markAnonymity") ;
				    int defaultLockedDoc=Util.getIntValue(Util.null2String(RecordSet.getString("defaultLockedDoc")),0);
				    int noDownload = Util.getIntValue(Util.null2String(RecordSet.getString("nodownload")),0);
				    int maxOfficeDocFileSize=Util.getIntValue(Util.null2String(RecordSet.getString("maxOfficeDocFileSize")),8);	
				    int maxUploadFileSize=Util.getIntValue(Util.null2String(RecordSet.getString("maxUploadFileSize")),0);
				    int noRepeatedName = Util.getIntValue(Util.null2String(RecordSet.getString("norepeatedname")),0);
				    int isControledByDir = Util.getIntValue(Util.null2String(RecordSet.getString("iscontroledbydir")),0);
				    int pubOperation = Util.getIntValue(Util.null2String(RecordSet.getString("puboperation")),0);
				    int relationable  = Util.getIntValue(RecordSet.getString("relationable"),0);
				    int childDocReadRemind = Util.getIntValue(Util.null2String(RecordSet.getString("childdocreadremind")),0);
				    String isPrintControl=Util.null2String(RecordSet.getString("isPrintControl"));
				    int printApplyWorkflowId = Util.getIntValue(Util.null2String(RecordSet.getString("printApplyWorkflowId")),0);
				    
				    String isLogControl = Util.null2String(RecordSet.getString("isLogControl"));
				    String defaultDummyCata=Util.null2String(RecordSet.getString("defaultDummyCata"));
				    int useCustomSearch = Util.getIntValue(Util.null2String(RecordSet.getString("useCustomSearch")),0); 
				    float secorder = RecordSet.getFloat("secorder");
				    int isOpenAttachment = Util.getIntValue(Util.null2String(RecordSet.getString("isOpenAttachment")),0);
				    int editionIsOpen = Util.getIntValue(Util.null2String(RecordSet.getString("editionIsOpen")),0);
				    
				    int readOpterCanPrint = Util.getIntValue(Util.null2String(RecordSet.getString("readoptercanprint")),0);
				    int appointedWorkflowId = Util.getIntValue(Util.null2String(RecordSet.getString("appointedWorkflowId")),0); 
				    int logviewtype = Util.getIntValue(RecordSet.getString("logviewtype"),0);
				    String orderable=RecordSet.getString("orderable") ;
				    String shareable=RecordSet.getString("shareable");
				    int allownModiMShareL=Util.getIntValue(Util.null2String(RecordSet.getString("allownModiMShareL")),0);
				    int isSetShare=Util.getIntValue(Util.null2String(RecordSet.getString("isSetShare")),0);
				    String docmouldid=RecordSet.getString("docmouldid") ;
				    int appliedTemplateId = Util.getIntValue(Util.null2String(RecordSet.getString("appliedTemplateId")),0);
				    String appliedTemplateName = "";
				    if(appliedTemplateId>0){
				    	rs.executeSql(" select name from DocSecCategoryTemplate where id = " + appliedTemplateId);
				    	rs.next();
				    	appliedTemplateName = Util.null2String(rs.getString(1));
				    }
				    if(!mainid.equals(""))  
				        if(!mainid.equals(maincategoryid))  continue;
				    if(!subid.equals(""))  
				        if(!subid.equals(subcategoryid))  continue;
				    if(!secid.equals(""))  
				        if(!secid.equals(seccategoryid))  continue;
				    if(!wfid.equals(""))  
				        if(!wfid.equals(approvewfid))  continue;
				%>
				  <TR class=Header>
				    <TD><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TD><!-- 主目录 -->
				    <TD>
				    <%
				    if(!tmpmain.equals("maincategoryid"))
				    {
				        tmpmain=maincategoryid ;   
				    %>
				    <b><%=maincategoryname%></b>
				    <%
				    }
				    else 
				    {%>
				    &nbsp;
				    <%} %>   
				    </TD>
					<TD><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></TD><!-- 分目录 -->
					<TD>
				    <%
				    if(!tmpsub.equals("subcategoryid"))
				    {
				        tmpsub=subcategoryid ;   
				    %>
				    <b><%=subcategoryname%></b>
				    <%
				    } 
				    else 
				    {%>
				    &nbsp;
				    <%} %>   
				    </TD>
				    <TD><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></TD><!-- 子目录 -->
				    <TD><b><%=seccategoryname%></b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(19389,user.getLanguage())%></TD><!-- 子目录编码 -->
				    <TD><b><%=coder %>&nbsp;</b></TD>
				    <td><%=SystemEnv.getHtmlLabelName(19456,user.getLanguage())%></td><!-- 目录模板 -->
				    <TD><b><%=appliedTemplateName%></b></TD>
				    <td> <%=SystemEnv.getHtmlLabelName(19790,user.getLanguage())%></td><!-- 允许设置为新闻 -->
				    <TD><b><%if(publishable.equals("1")){%><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				    <td><%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></td><!-- 允许回复 -->
				    <TD><b><%if(replyable.equals("1")){%><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				  </TR>
				  <TR class=Header>
				  	<TD><%=SystemEnv.getHtmlLabelName(18572,user.getLanguage())%></TD><!-- 允许订阅 -->
				    <TD><b><%if(orderable.equals("1")){%><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				  	<TD><%=SystemEnv.getHtmlLabelName(20449,user.getLanguage())%></TD> <!-- 允许修改共享 -->
				    <TD><b>
				       <%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%>&nbsp;:&nbsp;<%if(allownModiMShareL==1){out.println(SystemEnv.getHtmlLabelName(163,user.getLanguage()));}else{{out.println(SystemEnv.getHtmlLabelName(161,user.getLanguage()));}}%>
				       <br>
				       <%=SystemEnv.getHtmlLabelName(18574,user.getLanguage())%>&nbsp;:&nbsp;<%if(shareable.equals("1")){out.println(SystemEnv.getHtmlLabelName(163,user.getLanguage()));}else{{out.println(SystemEnv.getHtmlLabelName(161,user.getLanguage()));}}%>
				    </b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(19435,user.getLanguage())%></TD><!-- 文档提交时设置共享 -->
				    <TD><b><%if(isSetShare==1){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(18575,user.getLanguage())%></TD><!-- 允许打分 -->
					<TD><b><%if(markable.equals("1")){%><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(18576,user.getLanguage())%></TD><!-- 允许匿名 -->
				    <TD><b><%if(markAnonymity.equals("1")){%><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(18578,user.getLanguage())%></TD><!-- 锁定查看文档 -->
				    <TD><b><%if(defaultLockedDoc==1){%><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(19458,user.getLanguage())%></TD><!-- 禁止文档下载 -->
				    <TD><b><%if(noDownload==1){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				  </tr>
				  <TR class=Header>
				  	<TD><%=SystemEnv.getHtmlLabelName(24024,user.getLanguage())%></TD><!-- Office文档最大 -->
				    <TD><b><%=maxOfficeDocFileSize%></b></TD>
				  	<TD><%=SystemEnv.getHtmlLabelName(18580,user.getLanguage())%></TD><!-- 附件上传最大 -->
				    <TD><b>
				       <%=maxUploadFileSize %>
				    </b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(19449,user.getLanguage())%></TD><!-- 禁止文档重名 -->
				    <TD><b><%if(noRepeatedName==1||noRepeatedName==11){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(19459,user.getLanguage())%></TD><!-- 是否受控目录 -->
					<TD><b><%if(isControledByDir==1){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(19460,user.getLanguage())%></TD><!-- 发布操作 -->
				    <TD><b><%if(pubOperation==1){%><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(22672,user.getLanguage())%></TD><!-- 是否显示相关资源 -->
				    <TD><b><%if(relationable==1){%><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(19461,user.getLanguage())%></TD><!-- 子文档阅读提醒 -->
				    <TD><b><%if(childDocReadRemind==1){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				  </tr>
				  <TR class=Header>
				  	<TD><%=SystemEnv.getHtmlLabelName(21528,user.getLanguage())%></TD><!-- 是否打印控制 -->
				    <TD><b><%if(isPrintControl.equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				  	<TD><%=SystemEnv.getHtmlLabelName(21532,user.getLanguage())%></TD><!-- 打印申请流程 -->
				    <TD><b>
				       <%=WorkflowComInfo.getWorkflowname(""+printApplyWorkflowId)%>
				    </b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(19462,user.getLanguage())%></TD><!-- 允许只读操作人打印 -->
				    <TD><b><%if(readOpterCanPrint==1){%><%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%> <%} else if(readOpterCanPrint==0) {%><%=SystemEnv.getHtmlLabelName(24898,user.getLanguage())%> <%}else if(readOpterCanPrint==2) {%><%=SystemEnv.getHtmlLabelName(19463,user.getLanguage())%><%} %></b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(20997,user.getLanguage())%></TD><!-- 文档日志查看 -->
					<TD><b><%if(logviewtype==0){%><%=SystemEnv.getHtmlLabelName(20998,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(20999,user.getLanguage())%> <%}%></b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(21996,user.getLanguage())%></TD><!-- 文档阅读日志控制 -->
				    <TD><b><%if(isLogControl.equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(20498,user.getLanguage())%></TD><!-- 默认虚拟目录 -->
				    <TD><b><%=DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(defaultDummyCata)%></b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(24000,user.getLanguage())%></TD><!-- 单附件直接打开 -->
				    <TD><b><%if(isOpenAttachment==1){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				  </tr>
				  <TR class=Header>
				  	<TD><%=SystemEnv.getHtmlLabelName(21382,user.getLanguage())%></TD><!-- 新建工作流指定流程 -->
				    <TD><b><%=WorkflowComInfo.getWorkflowname(""+appointedWorkflowId)%></b></TD>
				  	<TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD><!-- 顺序 -->
				    <TD><b>
				       <%=secorder%>
				    </b></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())+SystemEnv.getHtmlLabelName(385,user.getLanguage())%></TD><!-- 创建权限 -->
				    <td>
					<%
					        //创建权限
					        String createdesc="";
					        rs.executeProc("Doc_DirAcl_SByDirID",""+seccategoryid+Util.getSeparator()+AclManager.CATEGORYTYPE_SEC+Util.getSeparator()+AclManager.OPERATION_CREATEDOC);    
					
					        while(rs.next()){
					            //部门 + 安全级别
					            if(rs.getInt("permissiontype")==1)	{
					                 createdesc+=SystemEnv.getHtmlLabelName(124,user.getLanguage())+","+Util.toScreen(DepartmentComInfo.getDepartmentname(rs.getString("departmentid")),user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+Util.toScreen(rs.getString("seclevel"),user.getLanguage());
					            }
					            //角色 + 安全级别 + 级别
					            if(rs.getInt("permissiontype")==2)	{
					                 createdesc+=SystemEnv.getHtmlLabelName(122,user.getLanguage())+","+Util.toScreen(RolesComInfo.getRolesname(rs.getString("roleid")),user.getLanguage())+"/";
					                if(rs.getInt("rolelevel")==0){
					                    createdesc+=SystemEnv.getHtmlLabelName(124,user.getLanguage());
					                }
					                if(rs.getInt("rolelevel")==1){
					                    createdesc+=SystemEnv.getHtmlLabelName(141,user.getLanguage());
					                }
					                if(rs.getInt("rolelevel")==2){
					                    createdesc+=SystemEnv.getHtmlLabelName(140,user.getLanguage());
					                }
					
					                    createdesc+=SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+Util.toScreen(rs.getString("seclevel"),user.getLanguage());
					            }
					            //安全级别
					            if(rs.getInt("permissiontype")==3)	{
					                 createdesc+=SystemEnv.getHtmlLabelName(683,user.getLanguage())+","+SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+Util.toScreen(rs.getString("seclevel"),user.getLanguage());
					            }
					            //用户类型 + 安全级别
					            if(rs.getInt("permissiontype")==4)	{
					                 createdesc+=SystemEnv.getHtmlLabelName(7179,user.getLanguage())+",";
					                 if(rs.getInt("usertype")==0){
					                   createdesc+=SystemEnv.getHtmlLabelName(131,user.getLanguage()).trim();
					                 }
					                 else{
					                   createdesc+=CustomerTypeComInfo.getCustomerTypename(rs.getString("usertype"));
					                 }
					                 createdesc+="/"+SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+Util.toScreen(rs.getString("seclevel"),user.getLanguage());
					
					            }
					            //人力资源
					            if(rs.getInt("permissiontype")==5)	{
					                 createdesc+=SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+Util.toScreen(ResourceComInfo.getResourcename(rs.getString("userid")),user.getLanguage());
					            }
					            createdesc+="<br>" ;
					        }
					        
					%><b><%=createdesc%>&nbsp;</b> 
				    </td>
				    <TD><%=SystemEnv.getHtmlLabelName(77,user.getLanguage())+SystemEnv.getHtmlLabelName(385,user.getLanguage())%></TD><!-- 复制权限 -->
				    <td>
					<%
					        //复制权限
					        String copydesc="";
					        rs.executeProc("Doc_DirAcl_SByDirID",""+seccategoryid+Util.getSeparator()+AclManager.CATEGORYTYPE_SEC+Util.getSeparator()+AclManager.OPERATION_COPYDOC);    
					
					        while(rs.next()){
					            //部门 + 安全级别
					            if(rs.getInt("permissiontype")==1)	{
					                 copydesc+=SystemEnv.getHtmlLabelName(124,user.getLanguage())+","+Util.toScreen(DepartmentComInfo.getDepartmentname(rs.getString("departmentid")),user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+Util.toScreen(rs.getString("seclevel"),user.getLanguage());
					            }
					            //角色 + 安全级别 + 级别
					            if(rs.getInt("permissiontype")==2)	{
					                 copydesc+=SystemEnv.getHtmlLabelName(122,user.getLanguage())+","+Util.toScreen(RolesComInfo.getRolesname(rs.getString("roleid")),user.getLanguage())+"/";
					                if(rs.getInt("rolelevel")==0){
					                    copydesc+=SystemEnv.getHtmlLabelName(124,user.getLanguage());
					                }
					                if(rs.getInt("rolelevel")==1){
					                    copydesc+=SystemEnv.getHtmlLabelName(141,user.getLanguage());
					                }
					                if(rs.getInt("rolelevel")==2){
					                    copydesc+=SystemEnv.getHtmlLabelName(140,user.getLanguage());
					                }
					
					                    copydesc+=SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+Util.toScreen(rs.getString("seclevel"),user.getLanguage());
					            }
					            //安全级别
					            if(rs.getInt("permissiontype")==3)	{
					                 copydesc+=SystemEnv.getHtmlLabelName(683,user.getLanguage())+","+SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+Util.toScreen(rs.getString("seclevel"),user.getLanguage());
					            }
					            //用户类型 + 安全级别
					            if(rs.getInt("permissiontype")==4)	{
					                 copydesc+=SystemEnv.getHtmlLabelName(7179,user.getLanguage())+",";
					                 if(rs.getInt("usertype")==0){
					                   copydesc+=SystemEnv.getHtmlLabelName(131,user.getLanguage()).trim();
					                 }
					                 else{
					                   copydesc+=CustomerTypeComInfo.getCustomerTypename(rs.getString("usertype"));
					                 }
					                 copydesc+="/"+SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+Util.toScreen(rs.getString("seclevel"),user.getLanguage());
					
					            }
					            //人力资源
					            if(rs.getInt("permissiontype")==5)	{
					                 copydesc+=SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+Util.toScreen(ResourceComInfo.getResourcename(rs.getString("userid")),user.getLanguage());
					            }
					            copydesc+="<br>" ;
					        }
					        
					%><b><%=copydesc%>&nbsp;</b>
				    </td>
				    <TD><%=SystemEnv.getHtmlLabelName(78,user.getLanguage())+SystemEnv.getHtmlLabelName(385,user.getLanguage())%></TD><!-- 移动权限 -->
				    <td>
					<%
				        //移动权限
				        String movedesc="";
				        rs.executeProc("Doc_DirAcl_SByDirID",""+seccategoryid+Util.getSeparator()+AclManager.CATEGORYTYPE_SEC+Util.getSeparator()+AclManager.OPERATION_MOVEDOC);    
				
				        while(rs.next()){
				            //部门 + 安全级别
				            if(rs.getInt("permissiontype")==1)	{
				                 movedesc+=SystemEnv.getHtmlLabelName(124,user.getLanguage())+","+Util.toScreen(DepartmentComInfo.getDepartmentname(rs.getString("departmentid")),user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+Util.toScreen(rs.getString("seclevel"),user.getLanguage());
				            }
				            //角色 + 安全级别 + 级别
				            if(rs.getInt("permissiontype")==2)	{
				                 movedesc+=SystemEnv.getHtmlLabelName(122,user.getLanguage())+","+Util.toScreen(RolesComInfo.getRolesname(rs.getString("roleid")),user.getLanguage())+"/";
				                if(rs.getInt("rolelevel")==0){
				                    movedesc+=SystemEnv.getHtmlLabelName(124,user.getLanguage());
				                }
				                if(rs.getInt("rolelevel")==1){
				                    movedesc+=SystemEnv.getHtmlLabelName(141,user.getLanguage());
				                }
				                if(rs.getInt("rolelevel")==2){
				                    movedesc+=SystemEnv.getHtmlLabelName(140,user.getLanguage());
				                }
				
				                    movedesc+=SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+Util.toScreen(rs.getString("seclevel"),user.getLanguage());
				            }
				            //安全级别
				            if(rs.getInt("permissiontype")==3)	{
				                 movedesc+=SystemEnv.getHtmlLabelName(683,user.getLanguage())+","+SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+Util.toScreen(rs.getString("seclevel"),user.getLanguage());
				            }
				            //用户类型 + 安全级别
				            if(rs.getInt("permissiontype")==4)	{
				                 movedesc+=SystemEnv.getHtmlLabelName(7179,user.getLanguage())+",";
				                 if(rs.getInt("usertype")==0){
				                   movedesc+=SystemEnv.getHtmlLabelName(131,user.getLanguage()).trim();
				                 }
				                 else{
				                   movedesc+=CustomerTypeComInfo.getCustomerTypename(rs.getString("usertype"));
				                 }
				                 movedesc+="/"+SystemEnv.getHtmlLabelName(683,user.getLanguage())+":"+Util.toScreen(rs.getString("seclevel"),user.getLanguage());
				
				            }
				            //人力资源
				            if(rs.getInt("permissiontype")==5)	{
				                 movedesc+=SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+Util.toScreen(ResourceComInfo.getResourcename(rs.getString("userid")),user.getLanguage());
				            }
				            movedesc+="<br>" ;
				        }
				        
					%><b><%=movedesc%>&nbsp;</b>
				    </td>
				    <TD><%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%></TD><!-- 默认共享 -->
				    <td>
					<%
				        String sharedesc="" ;
						//求分目录中文档创建者相关的权限
						String PCreater = "3";
						String PCreaterManager = "1";
						String PCreaterJmanager = "1";
						String PCreaterDownOwner = "0";
						String PCreaterSubComp = "0";
						String PCreaterDepart = "0";
						String PCreaterDownOwnerLS = "0";
						String PCreaterSubCompLS = "0";
						String PCreaterDepartLS = "0";
					
						String PCreaterW = "3";
						String PCreaterManagerW = "1";
						String PCreaterJmanagerW = "1";
						
						String PCreaterDL = "1";
						String PCreaterManagerDL = "1";
						String PCreaterSubCompDL = "0";
						String PCreaterDepartDL = "0";
						String PCreaterWDL = "1";
						String PCreaterManagerWDL = "1";
					
						rs.executeSql("select * from secCreaterDocPope where secid = "+seccategoryid);
						if (rs.next()) {
						    PCreater = Util.null2String(rs.getString("PCreater"));
						    PCreaterManager = Util.null2String(rs.getString("PCreaterManager"));
						    PCreaterJmanager = Util.null2String(rs.getString("PCreaterJmanager"));
						    PCreaterDownOwner = Util.null2String(rs.getString("PCreaterDownOwner"));
						    PCreaterSubComp = Util.null2String(rs.getString("PCreaterSubComp"));
						    PCreaterDepart = Util.null2String(rs.getString("PCreaterDepart"));
						    PCreaterDownOwnerLS = Util.null2String(rs.getString("PCreaterDownOwnerLS"));   
						    PCreaterSubCompLS = Util.null2String(rs.getString("PCreaterSubCompLS"));   
						    PCreaterDepartLS = Util.null2String(rs.getString("PCreaterDepartLS"));
						    PCreaterW = Util.null2String(rs.getString("PCreaterW"));
						    PCreaterManagerW = Util.null2String(rs.getString("PCreaterManagerW"));
						    PCreaterJmanagerW = Util.null2String(rs.getString("PCreaterJmanagerW"));
						    
						    /** TD12005 文档下载权限控制    开始 ======数据库添加以下字段========== */
						    PCreaterDL = this.setDLValueInit(Util.null2String(rs.getString("PCreaterDL")), PCreater);
						    PCreaterManagerDL = this.setDLValueInit(Util.null2String(rs.getString("PCreaterManagerDL")), PCreaterManager);
						    PCreaterSubCompDL = this.setDLValueInit(Util.null2String(rs.getString("PCreaterSubCompDL")), PCreaterSubComp);
						    PCreaterDepartDL = this.setDLValueInit(Util.null2String(rs.getString("PCreaterDepartDL")), PCreaterDepart);
						    PCreaterWDL = this.setDLValueInit(Util.null2String(rs.getString("PCreaterWDL")), PCreaterW);
						    PCreaterManagerWDL = this.setDLValueInit(Util.null2String(rs.getString("PCreaterManagerWDL")), PCreaterManagerW);
						    /** TD12005 文档下载权限控制   结束 */
						}
						//默认共享(与文档创建人相关 内部人员)
						if(!"0".equals(PCreater)||!"0".equals(PCreaterManager)||!"0".equals(PCreaterSubComp)||!"0".equals(PCreaterDepart))
							sharedesc+="<span style='color: red;'>"+SystemEnv.getHtmlLabelName(18589,user.getLanguage())+"</span><br>";
						//文档创建人
						if(!"0".equals(PCreater))
							sharedesc+="&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(18582,user.getLanguage())+"/";
				        if("1".equals(PCreater))
				        {
				        	sharedesc+=SystemEnv.getHtmlLabelName(367,user.getLanguage());
				        	if("1".equals(PCreaterDL))
				        	{
				        		sharedesc+=":"+SystemEnv.getHtmlLabelName(23733,user.getLanguage());
				        	}
				        	sharedesc+="<br>";
				        }
				        if("2".equals(PCreater))sharedesc+=SystemEnv.getHtmlLabelName(93,user.getLanguage())+"<br>";
				        if("3".equals(PCreater))sharedesc+=SystemEnv.getHtmlLabelName(17874,user.getLanguage())+"<br>";
				        
				        //创建人直接上级
				        if(!"0".equals(PCreaterManager))
				        	sharedesc+="&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(18583,user.getLanguage())+"/";
				        if("1".equals(PCreaterManager))
				        {
				        	sharedesc+=SystemEnv.getHtmlLabelName(367,user.getLanguage());
				        	if("1".equals(PCreaterManagerDL))
				        	{
				        		sharedesc+=":"+SystemEnv.getHtmlLabelName(23733,user.getLanguage());
				        	}
				        	sharedesc+="<br>";
				        }
				        if("2".equals(PCreaterManager))sharedesc+=SystemEnv.getHtmlLabelName(93,user.getLanguage())+"<br>";
				        if("3".equals(PCreaterManager))sharedesc+=SystemEnv.getHtmlLabelName(17874,user.getLanguage())+"<br>";
				        
				      	//创建人本分部
				      	if(!"0".equals(PCreaterSubComp))
				        	sharedesc+="&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(18584,user.getLanguage())+"/";
				        if("1".equals(PCreaterSubComp))
				        {
				        	sharedesc+=SystemEnv.getHtmlLabelName(367,user.getLanguage());
				        	if("1".equals(PCreaterSubCompDL))
				        	{
				        		sharedesc+=":"+SystemEnv.getHtmlLabelName(23733,user.getLanguage());
				        	}
				        	sharedesc+="<br>";
				        }
				        if("2".equals(PCreaterSubComp))sharedesc+=SystemEnv.getHtmlLabelName(93,user.getLanguage())+"<br>";
				        if("3".equals(PCreaterSubComp))sharedesc+=SystemEnv.getHtmlLabelName(17874,user.getLanguage())+"<br>";
				        
				        //创建人本部门
				        if(!"0".equals(PCreaterDepart))
				        	sharedesc+="&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(15081,user.getLanguage())+"/";
				        if("1".equals(PCreaterDepart))
				        {
				        	sharedesc+=SystemEnv.getHtmlLabelName(367,user.getLanguage());
				        	if("1".equals(PCreaterDepartDL))
				        	{
				        		sharedesc+=":"+SystemEnv.getHtmlLabelName(23733,user.getLanguage());
				        	}
				        	sharedesc+="<br>";
				        }
				        if("2".equals(PCreaterDepart))sharedesc+=SystemEnv.getHtmlLabelName(93,user.getLanguage())+"<br>";
				        if("3".equals(PCreaterDepart))sharedesc+=SystemEnv.getHtmlLabelName(17874,user.getLanguage())+"<br>";
				        
				        //默认共享(与文档创建人相关 外部人员)
				        if(!"0".equals(PCreaterW)||!"0".equals(PCreaterManagerW))
				        	sharedesc+="<span style='color: red;'>"+SystemEnv.getHtmlLabelName(2209,user.getLanguage())+"</span><br>";
				        	
				        //文档创建人
				    	if(!"0".equals(PCreaterW))
				    		sharedesc+="&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(18582,user.getLanguage())+"/";
				        if("1".equals(PCreaterW))
				        {
				        	sharedesc+=SystemEnv.getHtmlLabelName(367,user.getLanguage());
				        	if("1".equals(PCreaterWDL))
				        	{
				        		sharedesc+=":"+SystemEnv.getHtmlLabelName(23733,user.getLanguage());
				        	}
				        	sharedesc+="<br>";
				        }
				        if("2".equals(PCreaterW))sharedesc+=SystemEnv.getHtmlLabelName(93,user.getLanguage())+"<br>"; 
				        if("3".equals(PCreaterW))sharedesc+=SystemEnv.getHtmlLabelName(17874,user.getLanguage())+"<br>";
				        
				        //创建人经理
				        if(!"0".equals(PCreaterManagerW))
				    		sharedesc+="&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(15080,user.getLanguage())+"/";
				        if("1".equals(PCreaterManagerW))
				        {
				        	sharedesc+=SystemEnv.getHtmlLabelName(367,user.getLanguage());
				        	if("1".equals(PCreaterManagerWDL))
				        	{
				        		sharedesc+=":"+SystemEnv.getHtmlLabelName(23733,user.getLanguage());
				        	}
				        	sharedesc+="<br>";
				        }
				        if("2".equals(PCreaterManagerW))sharedesc+=SystemEnv.getHtmlLabelName(93,user.getLanguage())+"<br>";
				        if("3".equals(PCreaterManagerW))sharedesc+=SystemEnv.getHtmlLabelName(17874,user.getLanguage())+"<br>";
				        
				        rs.executeProc("DocSecCategoryShare_SBySecID",seccategoryid);  
				        if(rs.next())
				        {
				        	sharedesc+="<span style='color: red;'>"+SystemEnv.getHtmlLabelName(375,user.getLanguage())+"</span><br>";
				        }
				        rs.beforFirst();
				        while(rs.next()){
				            int sharetype=rs.getInt("sharetype");
				            String userid=rs.getString("userid");
				            int sharelevel=rs.getInt("sharelevel");
				            String departmentid=rs.getString("departmentid");
				            String seclevel=rs.getString("seclevel");
				            String roleid=rs.getString("roleid");
				            int rolelevel=rs.getInt("rolelevel");
				            String strDownload = "";
						        if (noDownload != 1 && Util.getIntValue(Util.null2String(rs.getString("downloadlevel")), 0) == 1) {
						        	strDownload = ":" + SystemEnv.getHtmlLabelName(23733,user.getLanguage());
						        }
				            if(sharetype==1){
				            	sharedesc+="&nbsp;&nbsp;";
				                sharedesc+= SystemEnv.getHtmlLabelName(179,user.getLanguage()) ;
				                sharedesc+=ResourceComInfo.getResourcename(userid)+"/" ;
				                if(sharelevel==1)   sharedesc+= SystemEnv.getHtmlLabelName(367,user.getLanguage())+ strDownload  ; 
				                if(sharelevel==2)   sharedesc+= SystemEnv.getHtmlLabelName(93,user.getLanguage())  ; 
				                sharedesc+="<br>" ;
				            }
				            if(sharetype==3){
				            	sharedesc+="&nbsp;&nbsp;";
				                sharedesc+=DepartmentComInfo.getDepartmentname(departmentid)+":";
				                sharedesc+= SystemEnv.getHtmlLabelName(683,user.getLanguage())+">=" +seclevel +"/" ;
				                if(sharelevel==1)   sharedesc+= SystemEnv.getHtmlLabelName(367,user.getLanguage())+ strDownload  ; 
				                if(sharelevel==2)   sharedesc+= SystemEnv.getHtmlLabelName(93,user.getLanguage())  ; 
				                sharedesc+="<br>" ;
				            }
				            if(sharetype==4){
				            	sharedesc+="&nbsp;&nbsp;";
				                sharedesc+=RolesComInfo.getRolesname(roleid)+":";
				                if(rolelevel==0)    sharedesc+= SystemEnv.getHtmlLabelName(15062,user.getLanguage()) +"/" ; 
				                if(rolelevel==1)    sharedesc+= SystemEnv.getHtmlLabelName(15063,user.getLanguage()) +"/" ;
				                if(rolelevel==2)    sharedesc+= SystemEnv.getHtmlLabelName(15064,user.getLanguage()) +"/" ;
				                if(sharelevel==1)   sharedesc+= SystemEnv.getHtmlLabelName(367,user.getLanguage())+ strDownload ; 
				                if(sharelevel==2)   sharedesc+= SystemEnv.getHtmlLabelName(93,user.getLanguage()) ; 
				                sharedesc+="<br>" ;
				            }
				            if(sharetype==5){
				            	sharedesc+="&nbsp;&nbsp;";
				                sharedesc+= SystemEnv.getHtmlLabelName(1340,user.getLanguage()) +":";
				                sharedesc+= SystemEnv.getHtmlLabelName(683,user.getLanguage())+">=" +seclevel +"/" ;
				                if(sharelevel==1)   sharedesc+= SystemEnv.getHtmlLabelName(367,user.getLanguage())+ strDownload ; 
				                if(sharelevel==2)   sharedesc+= SystemEnv.getHtmlLabelName(93,user.getLanguage()) ; 
				                sharedesc+="<br>" ;
				            }
				            if(sharetype<0){
				            	sharedesc+="&nbsp;&nbsp;";
				                String crmtype= "" + ((-1)*RecordSet.getInt("sharetype")) ;
					    		String crmtypename=CustomerTypeComInfo.getCustomerTypename(crmtype);
				                sharedesc+=crmtypename+":";
				                sharedesc+= SystemEnv.getHtmlLabelName(683,user.getLanguage())+">="+seclevel +"/" ;
				                if(sharelevel==1)   sharedesc+= SystemEnv.getHtmlLabelName(367,user.getLanguage())+ strDownload  ; 
				                if(sharelevel==2)   sharedesc+= SystemEnv.getHtmlLabelName(93,user.getLanguage())  ; 
				                sharedesc+="<br>" ;
				            }
				        }
					%><b><%=sharedesc%>&nbsp;</b>
				    </td>
				    <TD><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19450,user.getLanguage())%></TD><!-- 启用版本管理 -->
				    <TD><b><%if(editionIsOpen==1){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				  </tr>
				   
				  <TR class=Header>
				  	<TD><%=SystemEnv.getHtmlLabelName(19415,user.getLanguage())%></TD><!-- 启用子目录编码规则 -->
				    <TD><b>
				    <%
				    rs.executeSql("select * from codemain where id="+seccategoryid);
				    String isUse = Util.null2String(rs.getString("isUse"));
				    if(isUse.equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b>
				    </TD>
				  	<TD><%=SystemEnv.getHtmlLabelName(506,user.getLanguage())%></TD><!-- 文档模板 -->
				  		
				    <TD>
				    	 <!-- 得到默认的模板名称------------------------- -->
					    <b>
					      <%
			    	    int cMouldType =0;
			  			int cMouldId=0;
			  		    rs02.executeSql("select * from DocSecCategoryMould where secCategoryId = '"+seccategoryid+"'  and isdefault=1");
			  		 	while(rs02.next()){
				  		 	cMouldType = Util.getIntValue(Util.null2o(rs02.getString("mouldType")));
			  		 		 if("1".equals(cMouldType+"")){
			  		 		 		out.println("<span style='color: red;'>"+SystemEnv.getHtmlLabelName(19474, user.getLanguage())+":</span>");
			  		 		 }else  if("2".equals(cMouldType+"")){
			  		 		 		out.println("<span style='color: red;'>"+SystemEnv.getHtmlLabelName(19475, user.getLanguage())+":</span>");
			  		 		 }else  if("3".equals(cMouldType+"")){
			  		 		 		out.println("<span style='color: red;'>"+SystemEnv.getHtmlLabelName(19476, user.getLanguage())+":</span>");
			  		 		 }else  if("4".equals(cMouldType+"")){
			  		 		 		out.println("<span style='color: red;'>"+SystemEnv.getHtmlLabelName(19477, user.getLanguage())+":</span>");
			  		 		 }else  if("5".equals(cMouldType+"")){
			  		 		 		out.println("<span style='color: red;'>"+SystemEnv.getHtmlLabelName(22313, user.getLanguage())+":</span>");
			  		 		 }else  if("6".equals(cMouldType+"")){
			  		 		 		out.println("<span style='color: red;'>"+SystemEnv.getHtmlLabelName(22314, user.getLanguage())+":</span>");
			  		 		 }else  if("7".equals(cMouldType+"")){
			  		 		 		out.println("<span style='color: red;'>"+SystemEnv.getHtmlLabelName(22361, user.getLanguage())+":</span>");
			  		 		 }else  if("8".equals(cMouldType+"")){
			  		 		 		out.println("<span style='color: red;'>"+SystemEnv.getHtmlLabelName(22362, user.getLanguage())+":</span>");
			  		 		 }else  if("9".equals(cMouldType+"")){
			  		 		 		//out.println(SystemEnv.getHtmlLabelName(19474, user.getLanguage())+":");
			  		 		 }else  if("10".equals(cMouldType+"")){
			  		 		 		out.println("<span style='color: red;'>"+SystemEnv.getHtmlLabelName(24546, user.getLanguage())+":</span>");
			  		 		 }
							 cMouldId = Util.getIntValue(Util.null2o(rs02.getString("mouldId")));
			  				 if(cMouldType==1||cMouldType==3||cMouldType==5||cMouldType==7){ 
										    out.println(DocMouldComInfo.getDocMouldname(""+cMouldId)+"<br>");
						      } else {
									out.println(DocMouldComInfo1.getDocMouldname(""+cMouldId)+"<br>");
							 } 
							
					}
				%>
					   </b>
		   				<%
						    	 //子目录id
								rs02.executeProc("Doc_SecCategory_SelectByID",seccategoryid+"");
								rs02.next();
								String isOpenApproveWf=Util.null2String(rs02.getString("isOpenApproveWf"));
								String validityWfId=Util.null2String(rs02.getString("validityApproveWf"));
								String invalidityWfId=Util.null2String(rs02.getString("invalidityApproveWf"));
							    String approveWorkflowId=Util.null2String(rs02.getString("approveWorkflowId"));	
							    String bacthDownload=Util.null2String(rs02.getString("bacthDownload"));	
							    String isAutoExtendInfo=Util.null2String(rs02.getString("isAutoExtendInfo"));	
						     %>
				    </TD>
				    <TD><%=SystemEnv.getHtmlLabelName(1003,user.getLanguage())%></TD><!-- 批准流程-->
				    <TD>
				    <b>
				    	  <%
					         if ("2".equals(isOpenApproveWf)){
					    			out.println(Util.toScreen(WorkflowComInfo.getWorkflowname(approveWorkflowId),user.getLanguage()));    	
					    	}
					     %>
				    </b>
				    
				    </TD>
				    <TD><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20237,user.getLanguage())%></TD><!-- 启用自定义列表 -->
					<TD><b><%if(useCustomSearch==1){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></b></TD>
				    <TD>
				    		<!-- 禁止附件批量下载 -->
    						<%=SystemEnv.getHtmlLabelName(27025,user.getLanguage())%>
				    </TD>
				    <TD>
				    	<b>
				    	<%if(bacthDownload.equals("1")){
					    		out.println(SystemEnv.getHtmlLabelName(30586,user.getLanguage()));
					    	}else{
					    		out.println(SystemEnv.getHtmlLabelName(30587,user.getLanguage()));
					    	}
					    	%>
					    	</b>
				    </TD>
				    <TD>
				    	<!-- 有附件时展开文档附件属性-->
    					<%=SystemEnv.getHtmlLabelName(24417,user.getLanguage())%>
				    </TD>
				    <TD>
				    	<b>
				    	<%if(isAutoExtendInfo.equals("1")){
					    		out.println(SystemEnv.getHtmlLabelName(30586,user.getLanguage()));
					    	}else{
					    		out.println(SystemEnv.getHtmlLabelName(30587,user.getLanguage()));
					    	}
					    	%>
					    	</b>
				    </TD>
				    <TD></TD>
				    <TD></TD>
				  </tr>
				  <tr style="width:100%;">
					  <TD colspan="14">
						  <TABLE class=ListStyle cellspacing=1 border="1">
						       <colgroup>
						       <col width="30%">
						       <col width="30%">
						       <col width="30%">
						       <tr class=header>
						           <td colSpan=14><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage())%></td><!-- 类型 -->
						       </tr>
						       <tr class=header>
						            <td colSpan=5><%=SystemEnv.getHtmlLabelName(15795,user.getLanguage())%></td><!-- 类型名称 -->
						            <td colSpan=4><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td><!-- 操作 -->
						            <td colSpan=5><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></td><!-- 自定义名称 -->
						        </tr>
						       <tr>
						      		<td colSpan=5><%=SystemEnv.getHtmlLabelName(16173,user.getLanguage())%></td>
						      		<td colSpan=4 class=field>
						      		<%
						      		if(hasasset.equals("1"))
						      		{
						      		%>
						      		<%=SystemEnv.getHtmlLabelName(16174,user.getLanguage())%>
						      		<%
						      		}
						      		else if(hasasset.equals("0"))
						      		{
						      		%>
						      		<%=SystemEnv.getHtmlLabelName(16175,user.getLanguage())%>
						      		<%
						      		}
						      		else if(hasasset.equals("2"))
						      		{
						      		%>
						      		<%=SystemEnv.getHtmlLabelName(16176,user.getLanguage())%>
						      		<%
						      		} 
						      		%>
						      		</td>
						      		<td colSpan=5 class=field>
						      			<%=Util.toScreenToEdit(assetlabel,user.getLanguage())%>
						      		</td>
						      	</tr>
						      	<tr>
						      		<td colSpan=5><%=SystemEnv.getHtmlLabelName(16177,user.getLanguage())%></td>
						      		<td colSpan=4 class=field>
							       		<%if(hashrmres.equals("1")){%><%=SystemEnv.getHtmlLabelName(16174,user.getLanguage())%><%}%>
							       		<%if(hashrmres.equals("0")){%><%=SystemEnv.getHtmlLabelName(16175,user.getLanguage())%><%}%>
							       		<%if(hashrmres.equals("2")){%><%=SystemEnv.getHtmlLabelName(16176,user.getLanguage())%><%}%>
						      		</td>
						      		<td colSpan=5 class=field>
						      			<%=Util.toScreenToEdit(hrmreslabel,user.getLanguage())%>
						      		</td>
						      	</tr>
						      	<tr>
						      		<td colSpan=5>CRM<%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></td>
						      		<td colSpan=4 class=field>
							       		<%if(hascrm.equals("1")){%><%=SystemEnv.getHtmlLabelName(16174,user.getLanguage())%><%}%>
							       		<%if(hascrm.equals("0")){%><%=SystemEnv.getHtmlLabelName(16175,user.getLanguage())%><%}%>
							       		<%if(hascrm.equals("2")){%><%=SystemEnv.getHtmlLabelName(16176,user.getLanguage())%><%}%>
						      		</td>
						      		<td colSpan=5 class=field>
						      			<%=Util.toScreenToEdit(crmlabel,user.getLanguage())%>
						      		</td>
						      	</tr>
						      	<tr>
						      		<td colSpan=5><%=SystemEnv.getHtmlLabelName(16178,user.getLanguage())%></td>
						      		<td colSpan=4 class=field>
							       		<%if(hasproject.equals("1")){%><%=SystemEnv.getHtmlLabelName(16174,user.getLanguage())%><%}%>
							       		<%if(hasproject.equals("0")){%><%=SystemEnv.getHtmlLabelName(16175,user.getLanguage())%><%}%>
							       		<%if(hasproject.equals("2")){%><%=SystemEnv.getHtmlLabelName(16176,user.getLanguage())%><%}%>
						      		</td>
						      		<td colSpan=5 class=field>
						      			<%=Util.toScreenToEdit(projectlabel,user.getLanguage())%>
						      		</td>
						      	</tr>
							<TR><TD class=Line colSpan=14></TD></TR>
						  </TABLE>
					  </td>
				  </tr>
				<%
				    }
				%>  
				    </tbody>
				</table>
			</td>
		</tr>
		</TABLE>
		</td>
	</tr>
</table>