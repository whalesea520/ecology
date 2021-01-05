
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@page import="java.util.Map.Entry"%>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="ResourceComInfo"
    class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo"
    class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet"
    scope="page" />
<jsp:useBean id="Monitor" class="weaver.workflow.monitor.Monitor" scope="page" />
<%-- xwj for td2104 on 20050802--%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid2=user.getUID();   
    if (user == null)
        return;

    int requestid = Util.getIntValue(request.getParameter("requestid"));
    String workflowid = Util.null2String(request.getParameter("workflowid"));
    String nodeid = Util.null2String(request.getParameter("nodeid"));
    String isbill = Util.null2String(request.getParameter("isbill"));
    String formid = Util.null2String(request.getParameter("formid"));
    int desrequestid = Util.getIntValue(request.getParameter("desrequestid"));

    String userid = new Integer(user.getUID()).toString(); //当前用户id
    String logintype = user.getLogintype(); //当前用户类型  1: 内部用户  2:外部用户
    String isurger = Util.null2String(request.getParameter("isurger"));
    boolean isOldWf_ = false;
    RecordSetOld.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
    while (RecordSetOld.next()) {
        if (RecordSetOld.getString("nodeid") == null || "".equals(RecordSetOld.getString("nodeid")) || "-1".equals(RecordSetOld.getString("nodeid"))) {
            isOldWf_ = true;
        }
    }
    if (isOldWf_) {
        String url = "/workflow/request/WorkflowManageRequestPicture_old.jsp?f_weaver_belongto_userid="+userid2+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid=" + requestid + "&workflowid=" + workflowid + "&nodeid=" + nodeid + "&isbill=" + isbill + "&formid=" + formid;
        response.sendRedirect(url);

    }
%>


<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>


<script type="text/javascript">




document.oncontextmenu = Function("return false;");
function  readCookie(name){  
   var  cookieValue  =  "7";  
   var  search  =  name  +  "=";
   try{
       if(document.cookie.length  >  0) {    
           offset  =  document.cookie.indexOf(search);  
           if  (offset  !=  -1)  
           {    
               offset  +=  search.length;  
               end  =  document.cookie.indexOf(";",  offset);  
               if  (end  ==  -1)  end  =  document.cookie.length;  
               cookieValue  =  unescape(document.cookie.substring(offset,  end))  
           }  
       }  
   }catch(exception){
   }
   return  cookieValue;  
} 
</script>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">

<style>

</style>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp"%>
<TABLE border=0 cellpadding=0 cellspacing=0 width="100%">
    <TR>
        <TD ID='IMAGETD'>


            <%
                if (isurger.equals("true") || Monitor.hasMonitor(requestid+"",user.getUID()+"")) {
                    StringBuffer sqlsb = new StringBuffer();
                    sqlsb.append("select * ");
                    sqlsb.append("    from (select a.nodeid, ");
                    sqlsb.append("                 b.nodename, ");
                    sqlsb.append("              a.userid, ");
                    sqlsb.append("              a.isremark, ");
                    sqlsb.append("              a.lastisremark, ");
                    sqlsb.append("              a.usertype, ");
                    sqlsb.append("             a.agentorbyagentid, ");
                    sqlsb.append("             a.agenttype, ");
                    sqlsb.append("             a.receivedate, ");
                    sqlsb.append("             a.receivetime, ");
                    sqlsb.append("             a.operatedate, ");
                    sqlsb.append("             a.operatetime, ");
                    sqlsb.append("             a.viewtype, ");
                    sqlsb.append("             a.nodetype ");
                    sqlsb.append("             ,a.operator ");
                    sqlsb.append("        from (SELECT distinct o.requestid, ");
                    sqlsb.append("                              o.userid, ");
                    sqlsb.append("                              o.workflowid, ");
                    sqlsb.append("                              o.workflowtype, ");
                    sqlsb.append("                              o.isremark, ");
                    sqlsb.append("                              o.lastisremark, ");
                    sqlsb.append("                              o.usertype, ");
                    sqlsb.append("                              o.nodeid, ");
                    sqlsb.append("                              o.agentorbyagentid, ");
                    sqlsb.append("                              o.agenttype, ");
                    sqlsb.append("                              o.receivedate, ");
                    sqlsb.append("                              o.receivetime, ");
                    sqlsb.append("                              o.viewtype, ");
                    sqlsb.append("                              o.iscomplete, ");
                    sqlsb.append("                              o.operatedate, ");
                    sqlsb.append("                              o.operatetime, ");
                    sqlsb.append("                              nodetype ");
                    sqlsb.append("                              ,wr.operator ");
                    sqlsb.append("                FROM workflow_currentoperator o ");
                    
                    sqlsb.append("                left join workflow_requestlog wr");
                    sqlsb.append("                on wr.requestid=o.requestid");
                    sqlsb.append("                and wr.nodeid=o.nodeid");
                    sqlsb.append("                and wr.operator = o.userid");
                    sqlsb.append("                and wr.logtype <> '1'");
                    
                    sqlsb.append("                , workflow_flownode ");
                    
                    
                    
                    sqlsb.append("               where o.nodeid = ");
                    sqlsb.append("                     workflow_flownode.nodeid ");
                    sqlsb.append("                 and o.requestid = " + requestid + ") a, ");
                    sqlsb.append("             workflow_nodebase b ");
                    sqlsb.append("       where a.nodeid = b.id ");
                    sqlsb.append("         and a.requestid = " + requestid + " ");
                    sqlsb.append("         and a.agenttype <> 1 ");
                    sqlsb.append("      union ");
                    sqlsb.append("      select a.nodeid, ");
                    sqlsb.append("             b.nodename, ");
                    sqlsb.append("             a.userid, ");
                    sqlsb.append("             a.isremark, ");
                    sqlsb.append("             a.isremark as lastisremark, ");
                    sqlsb.append("             a.usertype, ");
                    sqlsb.append("             0 as agentorbyagentid, ");
                    sqlsb.append("             '' as agenttype, ");
                    sqlsb.append("             a.receivedate, ");
                    sqlsb.append("             a.receivetime, ");
                    sqlsb.append("             a.operatedate, ");
                    sqlsb.append("             a.operatetime, ");
                    sqlsb.append("             a.viewtype, ");
                    sqlsb.append("             a.nodetype ");
                    sqlsb.append("             ,a.operator ");
                    sqlsb.append("        from (SELECT distinct o.requestid, ");
                    sqlsb.append("                              o.userid, ");
                    sqlsb.append("                              o.workflowid, ");
                    sqlsb.append("                              o.isremark, ");
                    sqlsb.append("                              o.usertype, ");
                    sqlsb.append("                              o.nodeid, ");
                    sqlsb.append("                              o.receivedate, ");
                    sqlsb.append("                              o.receivetime, ");
                    sqlsb.append("                              o.viewtype, ");
                    sqlsb.append("                              o.operatedate, ");
                    sqlsb.append("                              o.operatetime, ");
                    sqlsb.append("                              n.nodetype ");
                    sqlsb.append("                              ,wr.operator ");
                    sqlsb.append("                FROM workflow_otheroperator o");
                    
                    sqlsb.append("                left join workflow_requestlog wr");
                    sqlsb.append("                on wr.requestid=o.requestid");
                    sqlsb.append("                and wr.nodeid=o.nodeid");
                    sqlsb.append("                and wr.operator = o.userid");
                    sqlsb.append("                and wr.logtype <> '1'");
                    
                    sqlsb.append("                , workflow_flownode n");
                    
                    sqlsb.append("               where o.nodeid = n.nodeid ");
                    sqlsb.append("                 and o.requestid = " + requestid + ") a, ");
                    sqlsb.append("             workflow_nodebase b ");
                    sqlsb.append("       where a.nodeid = b.id ");
                    sqlsb.append("         and a.requestid = " + requestid + ") a ");
                    sqlsb.append(" order by a.receivedate, a.receivetime, a.nodetype , a.nodeid ");
    
                    //System.out.println(sqlsb.toString());
                    rs.executeSql(sqlsb.toString());
    
                } else {
                    String viewLogIds = "";
                    ArrayList canViewIds = new ArrayList();
                    String viewNodeId = "-1";
                    String tempNodeId = "-1";
                    String singleViewLogIds = "-1";
                    rs.executeSql("select distinct nodeid from workflow_currentoperator where requestid=" + requestid + " and userid=" + userid);
    
                    while (rs.next()) {
                        viewNodeId = rs.getString("nodeid");
                        rs1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + viewNodeId);
                        if (rs1.next()) {
                            singleViewLogIds = rs1.getString("viewnodeids");
                        }
    
                        if ("-1".equals(singleViewLogIds)) {//全部查看
                            rs1.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid + " and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid=" + requestid + "))");
                            while (rs1.next()) {
                                tempNodeId = rs1.getString("nodeid");
                                if (!canViewIds.contains(tempNodeId)) {
                                    canViewIds.add(tempNodeId);
                                }
                            }
                        } else if (singleViewLogIds == null || "".equals(singleViewLogIds)) {//全部不能查看
    
                        } else {//查看部分
                            String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
                            for (int i = 0; i < tempidstrs.length; i++) {
                                if (!canViewIds.contains(tempidstrs[i])) {
                                    canViewIds.add(tempidstrs[i]);
                                }
                            }
                        }
                    }
    
                    //处理相关流程的查看权限


    
                    if (desrequestid > 0) {
                        //System.out.print("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid="+desrequestid+"  and  a.userid=b.userid)");
                        rs.executeSql("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid=" + requestid + " and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid=" + desrequestid + "  and  a.userid=b.userid)");
                        while (rs.next()) {
                            viewNodeId = rs.getString("nodeid");
                            rs1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + viewNodeId);
                            if (rs1.next()) {
                                singleViewLogIds = rs1.getString("viewnodeids");
                            }
    
                            if ("-1".equals(singleViewLogIds)) {//全部查看
                                rs1.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid + " and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid=" + desrequestid + "))");
                                while (rs1.next()) {
                                    tempNodeId = rs1.getString("nodeid");
                                    if (!canViewIds.contains(tempNodeId)) {
                                        canViewIds.add(tempNodeId);
                                    }
                                }
                            } else if (singleViewLogIds == null || "".equals(singleViewLogIds)) {//全部不能查看
    
                            } else {//查看部分
                                String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
                                for (int i = 0; i < tempidstrs.length; i++) {
                                    if (!canViewIds.contains(tempidstrs[i])) {
                                        canViewIds.add(tempidstrs[i]);
                                    }
                                }
                            }
                        }
                    }
                    if (canViewIds.size() > 0) {
                        for (int a = 0; a < canViewIds.size(); a++) {
                            viewLogIds += (String) canViewIds.get(a) + ",";
                        }
                        viewLogIds = viewLogIds.substring(0, viewLogIds.length() - 1);
                    } else {
                        viewLogIds = "-1";
                    }
                    StringBuffer sqlsb = new StringBuffer();
                    sqlsb.append("select * ");
                    sqlsb.append("    from (select a.nodeid, ");
                    sqlsb.append("             b.nodename, ");
                    sqlsb.append("             a.userid, ");
                    sqlsb.append("             a.isremark, ");
                    sqlsb.append("             a.lastisremark, ");
                    sqlsb.append("             a.usertype, ");
                    sqlsb.append("             a.agentorbyagentid, ");
                    sqlsb.append("             a.agenttype, ");
                    sqlsb.append("             a.receivedate, ");
                    sqlsb.append("             a.receivetime, ");
                    sqlsb.append("             a.operatedate, ");
                    sqlsb.append("             a.operatetime, ");
                    sqlsb.append("             a.viewtype, ");
                    sqlsb.append("             a.nodetype ");
                    sqlsb.append("             ,a.operator ");
                    sqlsb.append("        from (SELECT distinct o.requestid, ");
                    sqlsb.append("                              o.userid, ");
                    sqlsb.append("                              o.workflowid, ");
                    sqlsb.append("                              o.workflowtype, ");
                    sqlsb.append("                              o.isremark, ");
                    sqlsb.append("                              o.lastisremark, ");
                    sqlsb.append("                              o.usertype, ");
                    sqlsb.append("                              o.nodeid, ");
                    sqlsb.append("                              o.agentorbyagentid, ");
                    sqlsb.append("                              o.agenttype, ");
                    sqlsb.append("                              o.receivedate, ");
                    sqlsb.append("                              o.receivetime, ");
                    sqlsb.append("                              o.viewtype, ");
                    sqlsb.append("                              o.iscomplete, ");
                    sqlsb.append("                              o.operatedate, ");
                    sqlsb.append("                              o.operatetime, ");
                    sqlsb.append("                              nodetype ");
                    sqlsb.append("                              ,wr.operator ");
                    sqlsb.append("                FROM workflow_currentoperator o ");
                    sqlsb.append("                left join workflow_requestlog wr");
                    sqlsb.append("                on wr.requestid=o.requestid");
                    sqlsb.append("                and wr.nodeid=o.nodeid");
                    sqlsb.append("                and wr.operator = o.userid");
                    sqlsb.append("                and wr.logtype <> '1'");
                    
                    sqlsb.append("                , workflow_flownode ");
                    
                    
                    sqlsb.append("               where o.nodeid = ");
                    sqlsb.append("                     workflow_flownode.nodeid ");
                    sqlsb.append("                 and o.requestid = " + requestid + ") a, ");
                    sqlsb.append("             workflow_nodebase b ");
                    sqlsb.append("       where a.nodeid = b.id ");
                    sqlsb.append("         and a.requestid = " + requestid + " ");
                    sqlsb.append("         and a.agenttype <> 1 ");
                    sqlsb.append("         and a.nodeid in (" + viewLogIds + ") ");
                    sqlsb.append("      union ");
                    sqlsb.append("      select a.nodeid, ");
                    sqlsb.append("             b.nodename, ");
                    sqlsb.append("             a.userid, ");
                    sqlsb.append("             a.isremark, ");
                    sqlsb.append("             a.isremark as lastisremark, ");
                    sqlsb.append("             a.usertype, ");
                    sqlsb.append("             0 as agentorbyagentid, ");
                    sqlsb.append("             '' as agenttype, ");
                    sqlsb.append("             a.receivedate, ");
                    sqlsb.append("             a.receivetime, ");
                    sqlsb.append("             a.operatedate, ");
                    sqlsb.append("             a.operatetime, ");
                    sqlsb.append("             a.viewtype, ");
                    sqlsb.append("             a.nodetype ");
                    sqlsb.append("             ,a.operator ");
                    sqlsb.append("        from (SELECT distinct o.requestid, ");
                    sqlsb.append("                              o.userid, ");
                    sqlsb.append("                              o.workflowid, ");
                    sqlsb.append("                              o.workflowtype, ");
                    sqlsb.append("                              o.isremark, ");
                    sqlsb.append("                              o.usertype, ");
                    sqlsb.append("                              o.nodeid, ");
                    sqlsb.append("                              o.receivedate, ");
                    sqlsb.append("                              o.receivetime, ");
                    sqlsb.append("                              o.viewtype, ");
                    sqlsb.append("                              o.operatedate, ");
                    sqlsb.append("                              o.operatetime, ");
                    sqlsb.append("                              n.nodetype ");
                    sqlsb.append("                              ,wr.operator ");
                    sqlsb.append("                FROM workflow_currentoperator o");
                    sqlsb.append("                left join workflow_requestlog wr");
                    sqlsb.append("                on wr.requestid=o.requestid");
                    sqlsb.append("                and wr.nodeid=o.nodeid");
                    sqlsb.append("                and wr.operator = o.userid");
                    sqlsb.append("                and wr.logtype <> '1'");
                    
                    sqlsb.append("                , workflow_flownode n");
                    
                    sqlsb.append("               where o.nodeid = n.nodeid ");
                    sqlsb.append("                 and o.requestid = " + requestid + ") a, ");
                    sqlsb.append("             workflow_nodebase b ");
                    sqlsb.append("       where a.nodeid = b.id ");
                    sqlsb.append("         and a.requestid = " + requestid + " ");
                    sqlsb.append("         and a.nodeid in (" + viewLogIds + ")) a ");
                    sqlsb.append(" order by a.receivedate, a.receivetime, a.nodetype , a.nodeid ");
                    rs.executeSql(sqlsb.toString());
                    //rs.executeSql("select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid, a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype from (SELECT distinct t1.id,t1.requestid ,t1.userid ,t1.workflowid ,workflowtype ,isremark ,t1.usertype ,t1.nodeid ,agentorbyagentid ,agenttype  ,receivedate ,receivetime ,viewtype ,iscomplete  ,operatedate ,operatetime,nodetype FROM workflow_currentoperator t1,workflow_flownode t2,(select max(id) id,nodeid,userid,usertype from workflow_currentoperator where requestid="+requestid+" group by nodeid,userid,usertype) t3  where t1.id=t3.id and t1.nodeid=t2.nodeid and t1.requestid = "+requestid+") a,workflow_nodebase b where a.nodeid=b.id and a.requestid="+requestid+" and a.agenttype<>1 and a.nodeid in("+viewLogIds+") order by a.receivedate,a.receivetime,a.nodetype");
                    //System.out.println(sqlsb.toString());
                }
                
                int all_allcnt = 0;
                int all_submitcnt = 0;
                int all_viewcnt = 0;
                int all_noviewcnt = 0;
                
                int all_nosubmit = 0;
                List<Map<String, String>> statuslist = new ArrayList<Map<String, String>>();

                int rscount = rs.getCounts();
                while (rs.next()) {
                    int tmpnodeid = rs.getInt("nodeid");
                    String tmpnodename = rs.getString("nodename");
                        
                        Map<String, String> nodekv = null;
                        
                        if (statuslist.size() == 0) {
                            nodekv = new HashMap<String, String>();
                            statuslist.add(nodekv);
                        } else {
                            Map<String, String> temmap = statuslist.get(statuslist.size()-1);
                            int tnodeid =  Util.getIntValue(temmap.get("nodeid"), 0);
                            if (tnodeid == tmpnodeid) {
                                nodekv = temmap;
                            } else {
                                nodekv = new HashMap<String, String>();
                                statuslist.add(nodekv);
                            }
                        }
                        
                        if (nodekv == null) {
                           
                        }
                        
                    
                        int allcnt = Util.getIntValue(Util.null2String(nodekv.get("allcnt")), 0);
                        int submitcnt = Util.getIntValue(Util.null2String(nodekv.get("submitcnt")), 0);
                        int viewcnt = Util.getIntValue(Util.null2String(nodekv.get("viewcnt")), 0);
                        int noviewcnt = Util.getIntValue(Util.null2String(nodekv.get("noviewcnt")), 0);
                        
                    String tmpuserid = rs.getString("userid");
                    //int     tmpisremark=rs.getInt("isremark");
                    String tmpisremark = Util.null2String(rs.getString("isremark"));
                    if (tmpisremark.equals("")) {
                        tmpisremark = Util.null2String(rs.getString("lastisremark"));
                    }
                    int tmpusertype = rs.getInt("usertype");
                    String tmpagentorbyagentid = rs.getString("agentorbyagentid");
                    int tmpagenttype = rs.getInt("agenttype");
                    String tmpreceivedate = rs.getString("receivedate");
                    String tmpreceivetime = rs.getString("receivetime");
                    String tmpoperatedate = rs.getString("operatedate");
                    String tmpoperatetime = rs.getString("operatetime");
                    String viewtype = rs.getString("viewtype");
                    boolean flags = false;
                    String tmpIntervel = "";
                    
                    String operator = rs.getString("operator");
                    if (operator != null && !"".equals(operator)) {
                        flags = true;
                    }
                   
                    if (tmpisremark.equals("2") && flags) {
                        submitcnt++;
                        all_submitcnt++;
                    } else if (tmpisremark.equals("0") || tmpisremark.equals("1") || tmpisremark.equals("5") || tmpisremark.equals("4") || tmpisremark.equals("8") || tmpisremark.equals("9") || tmpisremark.equals("7") || (tmpisremark.equals("2") && !flags)) {
                        if (viewtype.equals("-2") || (viewtype.equals("-1") && !tmpoperatedate.equals(""))) {
                            viewcnt++;
                            all_viewcnt++;
                        } else if (viewtype.equals("0")) {
                            noviewcnt++;
                            all_noviewcnt++;
                        }
                    } else if (tmpisremark.equals("s")) {
                    } else if (tmpisremark.equals("c")) {
                    } else if (tmpisremark.equals("r")) {
                    }
                    
                    if ((!tmpisremark.equals("2")&&!tmpisremark.equals("4"))||(tmpisremark.equals("4")&&viewtype.equals("0"))) {
                        if (!tmpisremark.equals("s") && !tmpisremark.equals("s") && !tmpisremark.equals("c") && !tmpisremark.equals("r")) {
                            all_nosubmit++;
                        }
                    }
                    allcnt++;
                    all_allcnt++;
                    nodekv.put("nodeid", tmpnodeid + "");
                    nodekv.put("nodename", tmpnodename + "");
                    nodekv.put("allcnt", allcnt + "");
                    nodekv.put("submitcnt", submitcnt + "");
                    nodekv.put("viewcnt", viewcnt + "");
                    nodekv.put("noviewcnt", noviewcnt + "");
                     
                    }
                
            %>
<style>

</style>


<div id="allrecordblock" style="">
            <table class=ListStyle cellspacing=0 cellpadding="0" width="100%" height="100%">
                <COLGROUP>
                    <COL width="60px">
                    <COL width="17%">
                    <COL width="17%">
                    <COL width="17%">
                    <COL width="17%">
                    <COL width="*">
                <tr class=HeaderForXtalbe>
                    <th  style="cursor:default!important;">
                        <%=SystemEnv.getHtmlLabelName(15486, user.getLanguage())%>
                    </th>
                    <th  style="cursor:default!important;"><%=SystemEnv.getHtmlLabelName(15586, user.getLanguage())%></th>
                    <th  style="cursor:default!important;"><%=SystemEnv.getHtmlLabelName(84645, user.getLanguage())%></th>
                    <th  style="cursor:default!important;"></th>
                    <th  style="cursor:default!important;"></th>
                    <th style="cursor:default!important;text-align:right;" valign="middle">
                        <img src="/images/ecology8/workflow/wfstatus/ex_wev8.png" width="16px" height="16px" style="vertical-align: middle;cursor:pointer;" title="<%=SystemEnv.getHtmlLabelName(84532,user.getLanguage())%>" id="eximg">
                    </th>
                </tr>

                <%
                rs.beforFirst();
                int index = 0;
                for(Iterator<Map<String, String>> it = statuslist.iterator();it.hasNext();){  
                    Map<String, String> nodekv = it.next(); 
                    int fnodeid = Util.getIntValue(nodekv.get("nodeid"));
                    String namename = nodekv.get("nodename");
                    int allcnt = Util.getIntValue(Util.null2String(nodekv.get("allcnt")), 0);
                    int submitcnt = Util.getIntValue(Util.null2String(nodekv.get("submitcnt")), 0);
                    int viewcnt = Util.getIntValue(Util.null2String(nodekv.get("viewcnt")), 0);
                    int noviewcnt = Util.getIntValue(Util.null2String(nodekv.get("noviewcnt")), 0);
                    index++;
                %>

                
                <tr id="nodecnttd_<%=fnodeid %>" class="nodecntclass status_slt" _slt="1" _nodeid="<%=fnodeid + "_" + index %>">
                    <td><%=index%></td>
                    <td><%=Util.toScreen(namename, user.getLanguage())%></td>
                    <td>
                        <%=SystemEnv.getHtmlLabelName(84646, user.getLanguage())%>:<%=allcnt%></td>
                    <td style="<%=submitcnt==0?"":"color: #009933;" %>">
                        <%=SystemEnv.getHtmlLabelName(15176, user.getLanguage())%>:
                        <%=submitcnt%></td>
                    <td style="<%=viewcnt==0 ? "" : "color: #ee7bd1;"%>">
                        <%=SystemEnv.getHtmlLabelName(18006, user.getLanguage())%>:
                        <%=viewcnt%></td>
                    <td style="<%=noviewcnt==0?"" : "color: #ef7a7b;"%>">
                        <%=SystemEnv.getHtmlLabelName(18007, user.getLanguage())%>:
                        <%=noviewcnt%></td>
                </tr>

                <tr class="Spacing" style="height: 1px !important;">
                    <td colspan="10" class="paddingLeft0Table">
                        <div class="intervalDivClass"></div>
                    </td>
                </tr>
                
                <tr style="" id="nodecnttr_<%=fnodeid + "_" + index %>" class="detailinfotr">
                    <td colspan="6" style="padding:0px!important;;">
                    
                    

<style>
.ListStyle_3 tr td {
    /*background-color:#fefde9!important;*/
    background:#f9feff!important;
    border-bottom:#def3ff!important;
}
 
</style>                    

<table class="ListStyle_3" cellspacing=0 cellpadding="0" width="100%">
    <COLGROUP>
    <COL width="60px">
    <COL width="17%">
    <COL width="17%">
    <COL width="17%">
    <COL width="17%">
    <COL width="*">
    <tr>
        <td style="background-color:#f8f8f8!important;"><b></b></td>
        <td style="background-color:#f8f8f8!important;"><b><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></b></td>
        <td style="background-color:#f8f8f8!important;"><b><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></b></td>
        <td style="background-color:#f8f8f8!important;"><b><%=SystemEnv.getHtmlLabelName(18002,user.getLanguage())%></b></td>
        <td style="background-color:#f8f8f8!important;"><b><%=SystemEnv.getHtmlLabelName(18008,user.getLanguage())%></b></td>
        <td style="background-color:#f8f8f8!important;"><b><%=SystemEnv.getHtmlLabelName(18003,user.getLanguage())%></b></td>
    </tr>               
                <tr class="Spacing" style="height:1px!important;"><td colspan="10" class="paddingLeft0Table"><div class="intervalDivClass"></div></td></tr>
    
                <%
                
                int tmpnodeid_old=-1;
    boolean islight=false;
    while(rs.next()){
        int     tmpnodeid=rs.getInt("nodeid");
        
        if (tmpnodeid != fnodeid) {
            rs.previous();
            break;
        }
        
        String  tmpnodename=rs.getString("nodename");
        String  tmpuserid=rs.getString("userid");
        //int     tmpisremark=rs.getInt("isremark");
        String  tmpisremark = Util.null2String(rs.getString("isremark"));
        if(tmpisremark.equals(""))
        {
            tmpisremark = Util.null2String(rs.getString("lastisremark"));
        }
        int     tmpusertype=rs.getInt("usertype");
        String  tmpagentorbyagentid=rs.getString("agentorbyagentid");
        int     tmpagenttype=rs.getInt("agenttype");
        String  tmpreceivedate=rs.getString("receivedate");
        String  tmpreceivetime=rs.getString("receivetime");
        String  tmpoperatedate=rs.getString("operatedate");
        String  tmpoperatetime=rs.getString("operatetime");
        String  viewtype=rs.getString("viewtype");
        boolean flags=false;
        String  tmpIntervel="";
        //如果tmpisremark=2 判断时候在日志表里有该人（确定是否是由非会签得到的isremark=2）


        String operator = rs.getString("operator");
        if (operator != null && !"".equals(operator)) {
            flags = true;
        }
        
        //抄送（不需提交）查看后计算操作耗时 MYQ修改 开始


        if ("sqlserver".equals((rs1.getDBType()))) {
            rs1.executeSql("select 1 from workflow_currentoperator a ,workflow_groupdetail b where a.groupdetailid=b.id and b.signorder=3 and a.requestid="+requestid+" and a.userid="+tmpuserid);          
        } else {
            rs1.executeSql("select 1 from workflow_currentoperator a ,workflow_groupdetail b where a.groupdetailid=b.id and b.signorder='3' and a.requestid="+requestid+" and a.userid="+tmpuserid);
        }
        if(rs1.next()&&tmpisremark.equals("2")&&tmpoperatedate!=null && !tmpoperatedate.equals("")){
            tmpIntervel=TimeUtil.timeInterval2(tmpreceivedate+" "+tmpreceivetime,tmpoperatedate+" "+tmpoperatetime,user.getLanguage());
        }
       {
        if(tmpisremark.equals("2") &&flags&& tmpoperatedate!=null && !tmpoperatedate.equals("")){
            tmpIntervel=TimeUtil.timeInterval2(tmpreceivedate+" "+tmpreceivetime,tmpoperatedate+" "+tmpoperatetime,user.getLanguage());
        }
    islight=!islight;
    
%>
    <tr class="">
        <TD>
        </TD>
        <TD>
            <!-- 
            <img border="0" src="/images/replyDoc/userinfo_wev8.gif" />
             -->
            <%if(tmpusertype == 0){%>
                <%if(tmpagenttype!=2){%>
                    <A href="javaScript:openhrm(<%=tmpuserid%>);" onclick='pointerXY(event);'>
                        <%=Util.toScreen(ResourceComInfo.getResourcename(tmpuserid),user.getLanguage())%>
                    </A>
                <%}else{%>
                    <A href="javaScript:openhrm(<%=tmpagentorbyagentid%>);" onclick='pointerXY(event);'>
                        <%=Util.toScreen(ResourceComInfo.getResourcename(tmpagentorbyagentid),user.getLanguage())%>
                    </A>-><A href="javaScript:openhrm(<%=tmpuserid%>);" onclick='pointerXY(event);'>
                        <%=Util.toScreen(ResourceComInfo.getResourcename(tmpuserid),user.getLanguage())%>
                    </A>
                <%}%>
            <%}else{%>
             <A  href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpuserid%>">
               <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpuserid),user.getLanguage())%>
            </A>
            <%}%>
        </TD>

        <TD>
        
        <%
       
        if(tmpisremark.equals("2")&&flags){%>
            <%=SystemEnv.getHtmlLabelName(15176,user.getLanguage())%>
        <%}else if(tmpisremark.equals("0")||tmpisremark.equals("1")||tmpisremark.equals("5")||tmpisremark.equals("4")||tmpisremark.equals("8")||tmpisremark.equals("9")||tmpisremark.equals("7")||(tmpisremark.equals("2")&&!flags)){%>
            <%if(viewtype.equals("-2") || (viewtype.equals("-1") && !tmpoperatedate.equals(""))){%>
                <FONT COLOR="#FF33CC"><%=SystemEnv.getHtmlLabelName(18006,user.getLanguage())%></FONT>
            <%}else{%>
                <FONT COLOR="#FF0000"><%=SystemEnv.getHtmlLabelName(18007,user.getLanguage())%></FONT>
            <%}%>
        <%}else if(tmpisremark.equals("s")){%>
            <%=SystemEnv.getHtmlLabelName(20387,user.getLanguage())%>
         <%}else if(tmpisremark.equals("c")){%>
            <%=SystemEnv.getHtmlLabelName(16210,user.getLanguage())%>
        <%}else if(tmpisremark.equals("r")){%>
            <%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%>
        <%} %>
        </TD>

        <TD>
            <%if(!tmpisremark.equals("s")&&!tmpisremark.equals("c")&&!tmpisremark.equals("r")){ %>
            <%=Util.toScreen(tmpreceivedate,user.getLanguage())%>&nbsp;<%=Util.toScreen(tmpreceivetime,user.getLanguage())%>&nbsp;&nbsp;&nbsp;
            <%} %>
        </TD>

        <TD>
            <%=Util.toScreen(tmpoperatedate,user.getLanguage())%>&nbsp;<%=Util.toScreen(tmpoperatetime,user.getLanguage())%>&nbsp;&nbsp;&nbsp;
        </TD>



        <TD>
            <%=Util.toScreen(tmpIntervel,user.getLanguage())%>
        </TD>
    </TR>
    
    <tr class="Spacing" style="height:1px!important;"><td colspan="10" class="paddingLeft0Table"><div class="intervalDivClass"></div></td></tr>
    

    <% }    }   %>
                </table>
                
                
                
                
                
                

                <%
                
                }
                %>
                 </td>
                </tr>
            </table>
            <p></p>
        </TD>
    </TR>
</TABLE>
</div>
<style>
.status_slt td {
    /*background-color:#f4f8fb!important;*/
    background:#def3ff!important;
    border-bottom:1px solid #9fd6ff!important;
    border-top:1px solid #9fd6ff!important;
}
.nodecntclass {
    cursor:pointer;
}
</style>
<script>

jQuery(function () {
    parent.__hidloaddingblock();
    jQuery(".nodecntclass").bind("click", function () {
        var _this = jQuery(this); 
        var attrstatus = _this.attr("_slt");
        var attrid = _this.attr("_nodeid");
        if (attrstatus == "1") {
            _this.removeClass("status_slt");
            jQuery("#nodecnttr_" + attrid).hide();
            _this.attr("_slt", "0");
        } else {
            _this.addClass("status_slt");
            _this.attr("_slt", "1");
            jQuery("#nodecnttr_" + attrid).show();
        }
    });
    
    
    jQuery("#eximg").bind("click", function () {
        var _this = jQuery(this); 
        var attrstatus = _this.attr("_slt");
        if (attrstatus == "1") {
            jQuery(".detailinfotr").show();
            _this.attr("_slt", "0");
            jQuery(".nodecntclass").addClass("status_slt");
            jQuery(this).attr("title", "<%=SystemEnv.getHtmlLabelName(84532,user.getLanguage())%>");
        } else {
            _this.attr("_slt", "1");
            jQuery(".detailinfotr").hide();
            jQuery(".nodecntclass").removeClass("status_slt");
            jQuery(this).attr("title", "<%=SystemEnv.getHtmlLabelName(84533,user.getLanguage())%>");
        }
    });
});

</script>