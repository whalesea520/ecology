
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wfShareAuthorization" class="weaver.workflow.request.WFShareAuthorization" scope="page" />
<HTML>
<%
session.removeAttribute("RequestViewResource");
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";
int userid=user.getUID();
String logintype = user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
	usertype = 1;
String seclevel = user.getSeclevel();

String selectedworkflow="";
String isuserdefault="";
boolean issimple = Util.null2String(request.getParameter("issimple")).equals("false")?false:true;
String searchtype = Util.null2String(request.getParameter("searchtype"));
if(searchtype.equals("querytype")){
    response.sendRedirect("/workflow/search/CustomQueryTypeSearch.jsp?issimple="+issimple);
    return;
}
%>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/jquery/jquery_dialog_wev8.js"></script>
  <style>
           .listbox2 ul {
	            margin: 0 0 0 0;
	            padding: 0px;
	            list-style: none;
            }

            .listbox2 {
	            width:99%;
				margin-bottom: 32px;
				margin-right:0px;
             }

            .listbox2 .titleitem{
				height: 26px;
	            line-height: 26px;
	            font-weight: bold;
				border-bottom: 2px solid #e4e4e4;
			}
         
		    .listbox2 ul li a{
			    color: black;
			 	margin-left:8px;
				margin-right:12px;
		    }

          	.listbox2 ul li {
	            height: 30px;
	            line-height: 30px;
				border-bottom:1px dashed #f0f0f0;
			 	padding-left: 0px;
            }
          

			.titlecontent{
				float:left;
				color:#232323;
			}
			.commian{
				float:left;
				color:#232323;
				border-bottom:2px solid #9e17b6;
			}

		    .middlehelper {
					display: inline-block;
					height: 100%;
					vertical-align: middle;
				}

			.chosen{
			   background:#3399ff;
			   color:white;
			   cursor:pointer;
			}

			.agentitem a:hover{
			color:#ffffff !important;
			}

           .menuitem{

		    margin-bottom:5px;
		   
		   }
	
		</style>
		<link href="/css/ecology8/request/requestTypeShow_wev8.css" type="text/css" rel="STYLESHEET">
		<style type="text/css">
			.centerItem{
		  		 line-height: normal;
			}
		</style>
<script language=javascript>
function onSearchRequest(wfid,customid){
//document.subform.action="WFCustomSearchBySimple.jsp?workflowid="+wfid+"&issimple=<%=issimple%>";
document.subform.action="WFSearchsPageFrame.jsp?fromleftmenu=1&wfid="+wfid+"&isfrom=customSearch"+"&customid="+customid;
document.subform.submit();
}
</script>
</head>
<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    //RCMenu += "{" + SystemEnv.getHtmlLabelName(23802, user.getLanguage()) + ",/workflow/search/CustomQueryTypeSearch.jsp?issimple="+issimple+",_self} ";
    //RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name=subform method=post>
<%
//对不同的模块来说,可以定义自己相关的工作流
String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
//......
String topage = Util.null2String(request.getParameter("topage"));
ArrayList NewWorkflowTypes = new ArrayList();
ArrayList NewWorkflows = new ArrayList();
String sql = "";
    String tempbillworkflowids="";
    String tempfromworkflowids="";
    RecordSet.execute("select * from workflow_custom ");
    while(RecordSet.next()){
        String isbill = Util.null2String(RecordSet.getString("isbill"));
        String formID = Util.null2String(RecordSet.getString("formid"));
        String tempworkflowids = Util.null2String(RecordSet.getString("workflowids"));
        if (tempworkflowids.trim().equals("")) {
            rs.executeSql("select id from workflow_base where isvalid='1' and formid=" + formID + " and isbill='" + isbill + "'");
            while (rs.next()) {
                if (tempworkflowids.trim().equals("")) {
                    tempworkflowids = rs.getString("id");
                } else {
                    tempworkflowids += "," + rs.getString("id");
                }
            }
        }        
        if (!tempworkflowids.trim().equals("")) {
            if (isbill.equals("1")) {
                if (tempbillworkflowids.trim().equals("")) {
                    tempbillworkflowids = tempworkflowids;
                } else {
                    tempbillworkflowids += "," + tempworkflowids;
                }
            } else {
                if (tempfromworkflowids.trim().equals("")) {
                    tempfromworkflowids = tempworkflowids;
                } else {
                    tempfromworkflowids += "," + tempworkflowids;
                }
            }
        }
        
    }
    String tempwfids="";
    if(!tempbillworkflowids.equals("")){
        RecordSet.executeSql("select distinct a.workflowid from workflow_createdoc a,workflow_billfield b where (b.viewtype is null or b.viewtype !='1') and a.flowdocfield=b.id and a.status='1' and a.workflowid in("+tempbillworkflowids+")");
        while(RecordSet.next()){
            String tmpworkflowid=RecordSet.getString("workflowid");
                if(tempwfids.equals("")){
                    tempwfids=tmpworkflowid;
                }else{
                    tempwfids+=","+tmpworkflowid;
                }
            }
    }
    if(!tempfromworkflowids.equals("")){
        RecordSet.executeSql("select distinct c.workflowid from workflow_createdoc c,workflow_formfield a ,workflow_formdict b where a.fieldid=b.id and (a.isdetail is null or a.isdetail !='1') and c.flowdocfield=a.fieldid and c.status='1' and c.workflowid in("+tempfromworkflowids+")");
        while(RecordSet.next()){
            String tmpworkflowid=RecordSet.getString("workflowid");
                if(tempwfids.equals("")){
                    tempwfids=tmpworkflowid;
                }else{
                    tempwfids+=","+tmpworkflowid;
                }
        }
    }
    String sharewfid = "";
	String tempSharewfid = "";
	//获取流程共享信息
    Map<String,String> shareMap = wfShareAuthorization.getRequestShareByUser(user);
	if(!shareMap.isEmpty()){
		for(String key : shareMap.keySet()){
			if(key.equals("wfid")){
				sharewfid = shareMap.get(key);
			}
		}
	}
	if(!"".equals(sharewfid)){
		if(tempSharewfid.equals("")){
            tempSharewfid=sharewfid;
        }else{
            tempSharewfid+=","+sharewfid;
        }
	}    
   //处理拼sql
   StringBuffer sbf = new StringBuffer();

   if(RecordSet.getDBType().equals("oracle")){
       sbf.append("(select t1.id,");
	   sbf.append("       t1.formid,");
	   sbf.append("       t1.isbill,");
	   sbf.append("       t1.querytypeid,");
	   sbf.append("       t1.customname,");
	   sbf.append("       t1.customdesc,");
	   sbf.append("       t2.workflowids1 as workflowids,");
	   sbf.append("       t1.subcompanyid");
	   sbf.append("  from workflow_custom t1");
	   sbf.append("  left join (select workflowids,");
	   sbf.append("                    WM_CONCAT_old(workflowids1) as workflowids1");
	   sbf.append("               from (select t1.workflowids, t2.workflowids as workflowids1");
	   sbf.append("                       from workflow_custom t1,");
	   sbf.append("                            (select t1.id, t2.workflowids");
	   sbf.append("                               from (select *");
	   sbf.append("                                       from workflow_base");
	   sbf.append("                                      where activeversionid is not null) t1");
	   sbf.append("                               left join (select activeversionid,");
	   sbf.append("                                                WM_CONCAT_old(id) as workflowids");
	   sbf.append("                                           from workflow_base");
	   sbf.append("                                          where activeversionid is not null");
	   sbf.append("                                          group by activeversionid) t2 on t1.activeversionid =");
	   sbf.append("                                                                          t2.activeversionid");
	   sbf.append("                             union");
	   sbf.append("                            select id, '' || id as workflowids");
	   sbf.append("                             from workflow_base");
	   sbf.append("                              where (activeversionid is null or");
	   sbf.append("                                    activeversionid = '')) t2");
	   sbf.append("                      where ',' || t1.workflowids || ',' like");
	   sbf.append("                            '%,' || t2.id || ',%')");
	   sbf.append("              group by workflowids) t2 on t1.workflowids = t2.workflowids)");
	   
    }else{
       sbf.append("(select t1.id,t1.formid,t1.isbill,t1.querytypeid,t1.customname,t1.customdesc,isnull(t2.workflowids1,'') as workflowids,t1.subcompanyid from workflow_custom t1 left join ");
	   sbf.append("(");
	   sbf.append("SELECT cast(b.workflowids AS varchar) as workflowids, ");
	   sbf.append("STUFF((SELECT ','+cast(a.workflowids1 AS varchar) FROM");
	   sbf.append("(select t1.workflowids,t2.workflowids as workflowids1");
	   sbf.append("  from workflow_custom t1,");
	   sbf.append("       (select t1.id, t2.workflowids");
	   sbf.append("          from (select * from workflow_base where activeversionid is not null) t1");
	   sbf.append("          left join (SELECT activeversionid,");
	   sbf.append("                           STUFF((SELECT ',' + cast(id AS varchar)");
	   sbf.append("                                   FROM workflow_base a");
	   sbf.append("                                  WHERE b.activeversionid =");
	   sbf.append("                                        a.activeversionid");
	   sbf.append("                                    FOR XML PATH('')),");
	   sbf.append("                                 1,");
	   sbf.append("                                 1,");
	   sbf.append("                                 '') workflowids");
	   sbf.append("                      FROM workflow_base b");
	   sbf.append("                     GROUP BY activeversionid) t2 on t1.activeversionid =");
	   sbf.append("                                                     t2.activeversionid");
	   sbf.append("        union");
	   sbf.append("        select id, cast(id AS varchar) as workflowids");
	   sbf.append("          from workflow_base");
	   sbf.append("         where (activeversionid is null or activeversionid = '')) t2");
	   sbf.append(" where ',' + cast(t1.workflowids AS varchar) + ',' like '%,' + cast(t2.id AS varchar) + ',%') a");
	   sbf.append("  where cast(b.workflowids AS varchar) = cast(a.workflowids AS varchar)");
	   sbf.append(" FOR XML PATH('')),1 ,1, '') workflowids1 FROM workflow_custom b GROUP BY cast(b.workflowids AS varchar)");
	   sbf.append(" ) t2 on cast(t1.workflowids AS varchar)=cast(t2.workflowids AS varchar))");
    }

   if(RecordSet.getDBType().equals("oracle")){
        sql = "select  a.workflowtype,a.id from workflow_base a,"+sbf.toString()+" b where (a.isvalid='1' or a.isvalid='3') and a.formid=b.formid and a.isbill=b.isbill and (b.workflowids is null or ','||to_char(b.workflowids)||',' like '%,'||to_char(a.id)||',%')";
    }else{
        sql = "select  a.workflowtype,a.id from workflow_base a,"+sbf.toString()+" b where (a.isvalid='1' or a.isvalid='3') and a.formid=b.formid and a.isbill=b.isbill and (b.workflowids is null or convert(varchar,b.workflowids) ='' or convert(varchar,b.workflowids) ='' or ','+convert(varchar,b.workflowids)+',' like '%,'+convert(varchar,a.id)+',%')";
    }
    if(!tempSharewfid.equals("")){
        sql+=" and (a.id in("+tempSharewfid+") or exists (select 1 from workflow_currentoperator where workflow_currentoperator.workflowid=a.id and userid="+userid+" and usertype='"+usertype+"' ))  order by  a.workflowtype,a.id ";
    }else{
        sql+=" and exists (select 1 from workflow_currentoperator where workflow_currentoperator.workflowid=a.id and userid="+userid+" and usertype='"+usertype+"' )  order by  a.workflowtype,a.id ";
    }
RecordSet.executeSql(sql);
while(RecordSet.next()){
    if(NewWorkflowTypes.indexOf(RecordSet.getString("workflowtype"))==-1)
	NewWorkflowTypes.add(RecordSet.getString("workflowtype"));
    NewWorkflows.add(WorkflowVersion.getActiveVersionWFID(RecordSet.getString("id")));
}
int wftypetotal=NewWorkflowTypes.size();
//int wftotal=WorkflowComInfo.getWorkflowNum();
int rownum=(wftypetotal+2)/3;
%>

<%
 	int i=0;
 	int tdNum=0;
 	int colorindex = 0;
 	String[][] color={{"#166ca5","#953735","#01b0f1"},{"#767719","#f99d52","#cf39a4"}};
 	while(WorkTypeComInfo.next()){	
		
 		String wftypename=WorkTypeComInfo.getWorkTypename();
	
 		String wftypeid = WorkTypeComInfo.getWorkTypeid();
		//out.print(NewWorkflowTypes.indexOf(wftypeid));
 		if (NewWorkflowTypes.indexOf(wftypeid)==-1)    continue;        

	 	%>
	 	<div class="listbox2"  style="width:30%;float:left;padding: 10px;">
	 		<div class='titleitem'>
				<div class="titlecontent main<%=colorindex%>" style="border-bottom:2px solid <%=color[colorindex%2][tdNum]%>;">
					<label><%=Util.toScreen(wftypename,user.getLanguage())%></label>
				</div>
			</div>
	 		<div class='mainItem'>
		 	<%
		 	while(WorkflowComInfo.next()){
				String wfname=WorkflowComInfo.getWorkflowname();
			 	String wfid = WorkflowComInfo.getWorkflowid();
			 	String curtypeid = WorkflowComInfo.getWorkflowtype();
				String isbill = WorkflowComInfo.getIsBill();
				String formid = WorkflowComInfo.getFormId();
		
		        if (NewWorkflows.indexOf(wfid)==-1)    continue;        
		
			 	if(!curtypeid.equals(wftypeid)) continue;
			 	if(!"1".equals(WorkflowComInfo.getIsValid())){
				 	continue;
			 	}
			 	i++;
			 	String customid = "";
			 	RecordSet.execute("select * from workflow_custom where FORMID='"+formid+"' and ISBILL='"+isbill+"'");
			    while(RecordSet.next()){
			    	customid = Util.null2String(RecordSet.getString("ID"));
			    }			 	
			%>
				<div class='centerItem'>
		            <div class='fontItem'>
		        		<img name='esymbol' src="\images\ecology8\request\workflowTitle_wev8.png" style="vertical-align: middle;">
						<a href="javascript:onSearchRequest(<%=wfid%>,<%=customid%>);"><%=Util.toScreen(wfname,user.getLanguage())%></a>
					</div>
				</div>
			<%
				}
				colorindex++;
				WorkflowComInfo.setTofirstRow();
			%>
			</div>
		</div>
	<%
	}
	%>		

</form>
</body>
</html>