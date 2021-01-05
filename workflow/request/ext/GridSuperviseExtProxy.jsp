
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.*,weaver.workflow.request.WFWorkflows,weaver.workflow.request.WFWorkflowTypes"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>                
                 
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
User user = HrmUserVarify.getUser (request , response) ;
String method = Util.null2String(request.getParameter("method"));
String objid = Util.null2String(request.getParameter("objid"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
String nodetype = Util.null2String(request.getParameter("nodetype"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
String creatertype = Util.null2String(request.getParameter("creatertype"));
String createrid = Util.null2String(request.getParameter("createrid"));
String requestlevel = Util.null2String(request.getParameter("requestlevel"));
String fromdate2 = Util.null2String(request.getParameter("fromdate2"));
String todate2 = Util.null2String(request.getParameter("todate2"));
String workcode = Util.null2String(request.getParameter("workcode"));
String requestname = Util.null2String(request.getParameter("requestname"));
String sqlwhere="";
boolean isnew=false;
String requestids="";
if (method.equals("type")&&!objid.trim().equals("")) {
    sqlwhere=" b.workflowtype="+objid;
}
if (method.equals("workflow")&&!objid.trim().equals("")) {
    sqlwhere=" b.id="+objid;
}
if (method.equals("request")&&!objid.trim().equals("")) {
    sqlwhere=" b.id="+objid;
    isnew=true;
}
int logintype = Util.getIntValue(user.getLogintype(),1);
int userID = user.getUID();
WFUrgerManager.setLogintype(logintype);
WFUrgerManager.setUserid(userID);
WFUrgerManager.setSqlwhere(sqlwhere);
ArrayList  flowList=Util.TokenizerString(workflowid,",");
ArrayList wftypes=WFUrgerManager.getWrokflowTree();
for(int i=0;i<wftypes.size();i++){
    WFWorkflowTypes wftype=(WFWorkflowTypes)wftypes.get(i);
    ArrayList workflows=wftype.getWorkflows();
    for(int j=0;j<workflows.size();j++){
        WFWorkflows wfworkflow=(WFWorkflows)workflows.get(j);
        String tempWorkflow=wfworkflow.getWorkflowid()+"";
        if("".equals(workflowid)||flowList.contains(tempWorkflow)) {
            ArrayList requests=new ArrayList();
            if(isnew){
                requests=wfworkflow.getNewrequestids();
            }else{
                requests=wfworkflow.getReqeustids();
            }
            for(int k=0;k<requests.size();k++){
                if(requestids.equals("")){
                    requestids=(String)requests.get(k);
                }else{
                    requestids+=","+requests.get(k);
                }
            }
        }
    }
}

String newsql =" where t1.requestid = t2.requestid and (t1.currentnodetype is null or t1.currentnodetype<>'3') ";

if (!workflowid.equals(""))
    newsql += " and t1.workflowid in(" + workflowid + ")";

if (!nodetype.equals(""))
    newsql += " and t1.currentnodetype='" + nodetype + "'";


if (!fromdate.equals(""))
    newsql += " and t1.createdate>='" + fromdate + "'";

if (!todate.equals(""))
    newsql += " and t1.createdate<='" + todate + "'";

if (!fromdate2.equals(""))
    newsql += " and t2.receivedate>='" + fromdate2 + "'";

if (!todate2.equals(""))
    newsql += " and t2.receivedate<='" + todate2 + "'";

if (!workcode.equals(""))
    newsql += " and t1.creatertype= '0' and t1.creater in(select id from hrmresource where workcode like '%" + workcode + "%')";

if (!createrid.equals("")) {
    newsql += " and t1.creater='" + createrid + "'";
    newsql += " and t1.creatertype= '" + creatertype + "' ";
}

if (!requestlevel.equals("")) {
    newsql += " and t1.requestlevel=" + requestlevel;
}
if(!requestname.equals("")){
	if((requestname.indexOf(" ")==-1&&requestname.indexOf("+")==-1)||(requestname.indexOf(" ")!=-1&&requestname.indexOf("+")!=-1)){
		newsql+=" and t1.requestname like '%"+requestname+"%'";
		}else if(requestname.indexOf(" ")!=-1&&requestname.indexOf("+")==-1){
			String orArray[]=Util.TokenizerString2(requestname," ");
			if(orArray.length>0){
				newsql+=" and ( ";
			}
			for(int i=0;i<orArray.length;i++){
				newsql+=" t1.requestname like '%"+orArray[i]+"%'";
				if(i+1<orArray.length){
					newsql+=" or ";
				}
			}
			if(orArray.length>0){
				newsql+=" ) ";
			}
		}else if(requestname.indexOf(" ")==-1&&requestname.indexOf("+")!=-1){
			String andArray[]=Util.TokenizerString2(requestname,"+");
			for(int i=0;i<andArray.length;i++){
				newsql+=" and t1.requestname like '%"+andArray[i]+"%'";
			}
		}
}

String orderby = "t2.receivedate ,t2.receivetime";

RecordSet.executeProc("workflow_RUserDefault_Select",""+user.getUID());
int perpage=10;
if(RecordSet.next()){
   
    perpage= RecordSet.getInt("numperpage");
}else{
    RecordSet.executeProc("workflow_RUserDefault_Select","1");
    if(RecordSet.next()){     
        perpage= RecordSet.getInt("numperpage");
    }
}

String backfields = " t1.requestid, 9 isremark, t1.requestid viewtype, t1.workflowid multiSubmit,t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t1.currentnodeid,t2.receivedate,t2.receivetime ";
String fromSql ="";
if (RecordSet.getDBType().equals("oracle")) {
    fromSql = " from (select requestid,max(receivedate||' '||receivetime) as receivedate,'' as receivetime from workflow_currentoperator group by requestid) t2,workflow_requestbase t1 ";
} else {
    fromSql = " from (select requestid,max(receivedate+' '+receivetime) as receivedate,'' as receivetime from workflow_currentoperator group by requestid) t2,workflow_requestbase t1 ";
}
String sqlWhere = newsql;
String para2 = "column:requestid+column:workflowid+"+userID+"+"+(logintype-1)+"+"+ user.getLanguage();


if (!requestids.equals("")) {
    sqlWhere += " AND t1.requestid in("+requestids+") ";
}else{
    sqlWhere+=" and 1>2 ";
}
String supervise = "supervise";
String tableBaseParas = "";
tableBaseParas = "TableBaseParas={\"multiSubmit\":\""+false+"\",\"gridId\":\""+supervise+"\",\"sqlwhere\":\""+sqlWhere+"\",\"sort\":\""+orderby+"\",\"operates\":[],\"excerpt\":\"\",\"sqlisprintsql\":\"\",\"backfields\":\""+backfields+"\",\"columns\":[],\"pageSize\":"+perpage+",\"poolname\":\"\",\"sqlgroupby\":\"\",\"dir\":\"desc\",\"sqlisdistinct\":\"true\",\"sqlprimarykey\":\"t1.requestid\",\"sqlform\":\""+fromSql+"\",\"popedom\":{\"otherpara\":\"\",\"otherpara2\":\"\",\"transmethod\":\"\"}}";
out.println(tableBaseParas);
return;
	
%>