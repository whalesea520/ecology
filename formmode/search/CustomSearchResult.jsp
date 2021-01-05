
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="FormModeSearchClause" class="weaver.formmode.search.FormModeSearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
//搜索:请求
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";

String moudle=Util.null2String(request.getParameter("moudle"));
String workflowid = "" ;
String nodetype ="" ;
String fromdate ="" ;
String todate ="" ;
String creatertype ="" ;
String createrid ="" ;
String requestlevel ="" ;
String fromdate2 ="" ;
String todate2 ="" ;
String workcode ="" ;
String tempworkflowids="";
String querys=Util.null2String(request.getParameter("query"));
String fromself =Util.null2String(request.getParameter("fromself"));
String fromselfSql =Util.null2String(request.getParameter("fromselfSql"));
String isfirst =Util.null2String(request.getParameter("isfirst"));
String docids=Util.null2String(request.getParameter("docids"));
String issimple=Util.null2String(request.getParameter("issimple"));
String searchtype=Util.null2String(request.getParameter("searchtype"));
String customid=Util.null2String(request.getParameter("customid"));
String branchid="";
workflowid = Util.null2String(request.getParameter("workflowid"));
String isbill="1";
String formID="0";
String formmodeid="0";
RecordSet.execute("select a.modeid,a.customname,a.customdesc,b.modename,b.formid from mode_customsearch a,modeinfo b where a.modeid = b.id and a.id="+customid);
if(RecordSet.next()){
    formID=Util.null2String(RecordSet.getString("formid"));
    String customname=Util.null2String(RecordSet.getString("customname"));
    titlename = customname;
    formmodeid=Util.null2String(RecordSet.getString("modeid"));
}
String tablename=Util.null2String(request.getParameter("tablename"));
rs.executeSql("select tablename from workflow_bill where id = " + formID);
if (rs.next()){
	tablename = rs.getString("tablename"); 
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//add by xhheng @20050414 for TD 1545
int iswaitdo= Util.getIntValue(request.getParameter("iswaitdo"),0) ;
int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
String isthisWeek = Util.null2String(request.getParameter("isthisWeek"));
String isthisMonth = Util.null2String(request.getParameter("isthisMonth"));
String isthisDep = Util.null2String(request.getParameter("isthisDep"));
String isSelf = Util.null2String(request.getParameter("isSelf"));    
String userID = String.valueOf(user.getUID());
String logintype = ""+user.getLogintype();
int usertype = 0;
String CurrentUser = ""+user.getUID();
if(logintype.equals("2")) {
	usertype= 1;
}
String sqlwhere=FormModeSearchClause.getWhereclause();
String orderby = "t1.id";
int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);
int perpage=10;
//重新搜索
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",CustomSearchBySimple.jsp?isresearch=1&customid="+customid+"&issimple="+issimple+"&searchtype="+searchtype+"&moudle="+moudle+"&iswaitdo="+iswaitdo+",_self}" ;
RCMenuHeight += RCMenuHeightStep ;

%>

<TABLE id="tb1" width="100%">
	<tr>
		<td valign="top">                                                                                    
			<%
				String tableString = "";
				if(perpage <2) perpage=10;                                 
				String backfields = " t1.id,t1.formmodeid,t1.modedatacreater,t1.modedatacreatertype,t1.modedatacreatedate,t1.modedatacreatetime ";
				//加上自定以字段
				String showfield="";
				sql = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type,Mode_CustomDspField.showorder,Mode_CustomDspField.istitle" +
                " from workflow_billfield,Mode_CustomDspField,Mode_CustomSearch where Mode_CustomDspField.customid=Mode_CustomSearch.id and Mode_CustomSearch.id="+customid+
                " and Mode_CustomDspField.isshow='1' and workflow_billfield.billid="+formID+"  and   workflow_billfield.id=Mode_CustomDspField.fieldid" +
                " union select Mode_CustomDspField.fieldid as id,'1' as name,2 as label,'3' as dbtype, '4' as httype,5 as type ,Mode_CustomDspField.showorder,Mode_CustomDspField.istitle" +
                " from Mode_CustomDspField ,Mode_CustomSearch where Mode_CustomDspField.customid=Mode_CustomSearch.id and Mode_CustomSearch.id="+customid+
                " and Mode_CustomDspField.isshow='1'  and Mode_CustomDspField.fieldid<0" +
                " order by showorder";
				//out.print(sql);
				RecordSet.execute(sql);
				while (RecordSet.next()){
					if (RecordSet.getInt(1)>0){
						String tempname=Util.null2String(RecordSet.getString("name"));
						String dbtype=Util.null2String(RecordSet.getString("dbtype"));
						if((","+tempname+",").toLowerCase().indexOf(",t1."+tempname.toLowerCase()+",")>-1){
							continue;
						}
						if(dbtype.toLowerCase().equals("text")){
							if(RecordSet.getDBType().equals("oracle")){
								showfield=showfield+","+"to_char(t1."+tempname+") as "+tempname;
							}else{
								showfield=showfield+","+"convert(varchar(4000),t1."+tempname+") as "+tempname;
							}
						}else{
								showfield=showfield+","+"t1."+tempname;
							}
						}
					}
					RecordSet.beforFirst();
					backfields=backfields+showfield;
					ModeShareManager.setModeId(Util.getIntValue(formmodeid,0));
					String rightsql = ModeShareManager.getShareDetailTableByUser("formmode",user);
                    String fromSql  = " from "+tablename+" t1,"+rightsql+" t2 " ;
                    sqlwhere += " and t1.id = t2.sourceid ";
                   	//out.println("select "+backfields+fromSql+sqlwhere);

					tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"  />"+
                                 "			<head>";
					while (RecordSet.next()) {
						if(RecordSet.getString("id").equals("-1")){//创建日期
							tableString+="				<col   text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"modedatacreatedate\" orderkey=\"t1.modedatacreatedate,t1.modedatacreatetime\" otherpara=\"column:modedatacreatetime\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultCreateTime\" />";
						}else if(RecordSet.getString("id").equals("-2")){//创建人
							tableString+="				<col  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"modedatacreater\" orderkey=\"t1.modedatacreater\"  otherpara=\"column:modedatacreatertype\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultName\" />";
						}else{
							String name = RecordSet.getString("name");
							String label = RecordSet.getString("label");
							String htmltype = RecordSet.getString("httype");
							String type = RecordSet.getString("type");
							String id = RecordSet.getString("id");
							String dbtype=RecordSet.getString("dbtype");
							String istitle = RecordSet.getString("istitle");
							String viewtype = "0";
							//http://localhost:8080/formmode/view/addformmode.jsp?type=1&modeId=1&formId=-50
							//type=1&modeId=1&formId=-50
							//type
							//0、查看
							//1、新建
							//2、编辑
							//3、监控
							String para3="column:id+"+id+"+"+htmltype+"+"+type+"+"+user.getLanguage()+"+"+isbill+"+"+dbtype+"+"+istitle+"+"+formmodeid+"+"+formID+"+"+viewtype;
							label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
				 			tableString+="			    <col  text=\""+label+"\"  column=\""+name+"\"  otherpara=\""+para3+"\"  transmethod=\"weaver.formmode.search.FormModeTransMethod.getOthers\"/>";
						}
					}
					tableString+="			</head>"+   			
                                 "</table>";
				%>
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			</td>
		</tr>
	</TABLE>

	<table align=right>
		<tr>
			<td>
				<%	
				    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;//首页
				    RCMenuHeight += RCMenuHeightStep ;
				    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;//上一页
				    RCMenuHeight += RCMenuHeightStep ;
				    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;//下一页
				    RCMenuHeight += RCMenuHeightStep ;
				    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;//尾页
				    RCMenuHeight += RCMenuHeightStep ;
				%>
			</td>
		</tr>
	</TABLE>
	  
</td>
</tr>
</TABLE>
</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
<SCRIPT language="javascript">
function OnChangePage(start){
	document.frmmain.start.value = start;
	document.frmmain.submit();
}
</script>
</html>
