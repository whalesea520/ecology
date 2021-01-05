
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@page import="java.util.Map.Entry"%>

<jsp:useBean id="ResourceComInfo"
    class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo"
    class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Monitor" class="weaver.workflow.monitor.Monitor" scope="page" />
<%-- xwj for td2104 on 20050802--%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
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
        String url = "/workflow/request/WorkflowManageRequestPicture_old.jsp?requestid=" + requestid + "&workflowid=" + workflowid + "&nodeid=" + nodeid + "&isbill=" + isbill + "&formid=" + formid;
        response.sendRedirect(url);

    }
%>


<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>


<script>

jQuery(function () {
    jQuery(".statuscntblock").hover(function () {
        if (jQuery(this).attr("_slt") == "1") {
            return;
        }
        
        var imgsrc = "";
        var sltClass = "";
        var sindex = jQuery(this).attr("_index"); 
        if (sindex == "1") {
            imgsrc = "/images/ecology8/workflow/wfstatus/all_slt_wev8.png";
        } else if (sindex == "2") {
            imgsrc = "/images/ecology8/workflow/wfstatus/submit_slt_wev8.png";
        } else if (sindex == "3") {
            imgsrc = "/images/ecology8/workflow/wfstatus/nosubmit_slt_wev8.png";
        } else if (sindex == "4") {
            imgsrc = "/images/ecology8/workflow/wfstatus/noview_slt_wev8.png";
        } else if (sindex == "5") {
            imgsrc = "/images/ecology8/workflow/wfstatus/view_slt_wev8.png";
        } 
        sltClass = "slt_" + sindex;
        jQuery(this).find("img").attr("src", imgsrc);
        jQuery(this).addClass(sltClass);
    }, function () {
        if (jQuery(this).attr("_slt") == "1") {
            return;
        }
        
        var imgsrc = "";
        var sltClass = "";
        var sindex = jQuery(this).attr("_index"); 
        
        if (sindex == "1") {
            imgsrc = "/images/ecology8/workflow/wfstatus/all_wev8.png";
        } else if (sindex == "2") {
            imgsrc = "/images/ecology8/workflow/wfstatus/submit_wev8.png";
        } else if (sindex == "3") {
            imgsrc = "/images/ecology8/workflow/wfstatus/nosubmit_wev8.png";
        } else if (sindex == "4") {
            imgsrc = "/images/ecology8/workflow/wfstatus/noview_wev8.png";
        } else if (sindex == "5") {
            imgsrc = "/images/ecology8/workflow/wfstatus/view_wev8.png";
        } 
        sltClass = "slt_" + sindex;
        jQuery(this).find("img").attr("src", imgsrc);
        jQuery(this).removeClass(sltClass);
    });
});

</script>

<style>
.statuscntblock {
    margin:0 15px;
    border:1px solid #f1f1f1;
    width:203px;
    height:73px;
    text-align:73px;
    background:#fff;
    display:inline-block;
    cursor:pointer;
}

.slt_1 {
    border:1px solid #1896ff;
}
.slt_2 {
    border:1px solid #8fcd51;
}
.slt_3 {
    border:1px solid #ee7bd1;
}
.slt_4 {
    border:1px solid #ef7a7b;
}
.slt_5 {
    border:1px solid #56ccd5;
}

.rescountnum {
    font-size:32px;
    font-family:arial;
}

.rescountdesc {
    font-size:12px;color:#242424;
}

.fontcolor_1 {
    color:#1896ff;
}
.fontcolor_2 {
    color:#8fcd51;
}
.fontcolor_3 {
    color:#ee7bd1;
}
.fontcolor_4 {
    color:#ef7a7b;
}

.fontcolor_5 {
    color:#56ccd5;
}
</style>

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
                if (isurger.equals("true") || Monitor.hasMonitor(requestid + "",user.getUID()+"")) {
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
                    sqlsb.append(" order by a.receivedate, a.receivetime, a.nodetype");

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
                    sqlsb.append(" order by a.receivedate, a.receivetime, a.nodetype");
                    rs.executeSql(sqlsb.toString());
                    //rs.executeSql("select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid, a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype from (SELECT distinct t1.id,t1.requestid ,t1.userid ,t1.workflowid ,workflowtype ,isremark ,t1.usertype ,t1.nodeid ,agentorbyagentid ,agenttype  ,receivedate ,receivetime ,viewtype ,iscomplete  ,operatedate ,operatetime,nodetype FROM workflow_currentoperator t1,workflow_flownode t2,(select max(id) id,nodeid,userid,usertype from workflow_currentoperator where requestid="+requestid+" group by nodeid,userid,usertype) t3  where t1.id=t3.id and t1.nodeid=t2.nodeid and t1.requestid = "+requestid+") a,workflow_nodebase b where a.nodeid=b.id and a.requestid="+requestid+" and a.agenttype<>1 and a.nodeid in("+viewLogIds+") order by a.receivedate,a.receivetime,a.nodetype");
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
                    //如果tmpisremark=2 判断时候在日志表里有该人（确定是否是由非会签得到的isremark=2）

                    
                    
                    String operator = rs.getString("operator");
                    if (operator != null && !"".equals(operator)) {
                        flags = true;
                    }
                    //抄送（不需提交）查看后计算操作耗时 MYQ修改 开始

                    
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
.ListStyle_2 {
    
}

</style>

 
<div id="top" style="position: absolute!important;width:100%;height:116px;overflow: auto;">

<div style="width:100%;background:#f1f1f1;padding:19px 0px;">
    <div class="statuscntblock slt_1" _index="1" _slt="1">
        <table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
            <colgroup><col width="20px"><col width="48px"><col width="33px"><col width="*"></colgroup>
            <tr style="height:100%;">
                <td></td><td valign="middle">
                    <img src="/images/ecology8/workflow/wfstatus/all_slt_wev8.png" width="48px" height="48px" style="vertical-align:middle;">           
                </td>
                <td></td><td valign="middle">
                    <div class="rescountnum fontcolor_1" style="">
                    <%=all_allcnt %>
                    </div>
                    <div class="rescountdesc" style="">
                    <%=SystemEnv.getHtmlLabelName(15945,user.getLanguage())%>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    
    
    <div class="statuscntblock" _index="2">
        <table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
            <colgroup><col width="20px"><col width="48px"><col width="33px"><col width="*"></colgroup>
            <tr style="height:100%;">
                <td></td><td valign="middle">
                    <img src="/images/ecology8/workflow/wfstatus/submit_wev8.png" width="48px" height="48px" style="vertical-align:middle;">            
                </td>
                <td></td><td valign="middle">
                    <div class="rescountnum fontcolor_2" style="">
                    <%=all_submitcnt %>
                    </div>
                    <div class="rescountdesc" style="">
                     <%=SystemEnv.getHtmlLabelName(15176,user.getLanguage())%>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    
    <div class="statuscntblock" _index="3">
        <table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
            <colgroup><col width="20px"><col width="48px"><col width="33px"><col width="*"></colgroup>
            <tr style="height:100%;">
                <td></td><td valign="middle">
                    <img src="/images/ecology8/workflow/wfstatus/nosubmit_wev8.png" width="48px" height="48px" style="vertical-align:middle;">          
                </td>
                <td></td><td valign="middle">
                    <div class="rescountnum fontcolor_3" style="">
                    <%=all_nosubmit %>
                    </div>
                    <div class="rescountdesc" style="">
                    <%=SystemEnv.getHtmlLabelName(32555,user.getLanguage())%>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    
    <div class="statuscntblock" _index="5">
        <table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
            <colgroup><col width="20px"><col width="48px"><col width="33px"><col width="*"></colgroup>
            <tr style="height:100%;">
                <td></td><td valign="middle">
                    <img src="/images/ecology8/workflow/wfstatus/view_wev8.png" width="48px" height="48px" style="vertical-align:middle;">          
                </td>
                <td></td><td valign="middle">
                    <div class="rescountnum fontcolor_5" style="">
                    <%=all_viewcnt %>
                    </div>
                    <div class="rescountdesc" style="">
                    <%=SystemEnv.getHtmlLabelName(18006,user.getLanguage())%>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    
    <div class="statuscntblock" _index="4">
        <table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
            <colgroup><col width="20px"><col width="48px"><col width="33px"><col width="*"></colgroup>
            <tr style="height:100%;">
                <td></td><td valign="middle">
                    <img src="/images/ecology8/workflow/wfstatus/noview_wev8.png" width="48px" height="48px" style="vertical-align:middle;">            
                </td>
                <td></td><td valign="middle">
                    <div class="rescountnum fontcolor_4" style="">
                    <%=all_noviewcnt %>
                    </div>
                    <div class="rescountdesc" style="">
                    <%=SystemEnv.getHtmlLabelName(18007,user.getLanguage())%>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</div>

    <span onclick="toggersearchblock()" class="e8_browflow" style="display:inline-block;position:absolute;right:5px;bottom:5px;cursor:pointer;" title="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>">
    &nbsp;
    </span>
</div>

<div id="searchblock" style="position:absolute;top:116px;width:100%;height:36px;border-top:1px solid #dadada;display:none;">
    <table cellpadding="0" cellspacing="0" width="100%" height="100%">
        <tr>
        <%if(8==user.getLanguage()){%>
            <td width="48%">
            <%}else{%>
            <td width="343px">
            <%}%>
                <span style="margin-left:44px;" ><%=SystemEnv.getHtmlLabelName(84657,user.getLanguage())%>&nbsp;&nbsp;</span>
                <select id="nodeselect" onchange="_search(1, this.value)">
                    <option value="">&nbsp;</option>
                    <%
                    List<String> snlist = new ArrayList<String>();
                    for (int i=0; i<statuslist.size(); i++) {
                        Map<String, String> nodemap = (Map<String, String>)statuslist.get(i);
                        String snodeid = nodemap.get("nodeid");
                        String snodename = nodemap.get("nodename");
                        
                        if (snlist.contains(snodeid)) {
                            continue;
                        }
                        
                        snlist.add(snodeid);
                    %>    
                    <option value="<%=snodeid %>"><%=snodename %></option>
                    <%
                    }
                    %>
                </select>
                <span style="margin-left:15PX;">
                <%=SystemEnv.getHtmlLabelName(84658,user.getLanguage())%>&nbsp;&nbsp;
                </span>
            </td>
            <td>
                <brow:browser viewType="0" name="resouce" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="150px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue=""> 
                </brow:browser> 
            </td>
            <td width="*">
            </td>
        </tr>
    </table>
</div>

<div id="contenblock" style="position: absolute!important;top:116px;height:auto!important;position: relative;height:100%;bottom:0px;width:100%;overflow: auto;border-top:1px solid #dadada;">
    <iframe id="content" src="/workflow/request/WorkflowRequestPictureFrame.jsp?<%=request.getQueryString() %>" name="" contentframe" class="flowFrame" frameborder="0" height="100%" width="100%"></iframe>
</div>
<style>
.status_slt td {
    background-color:#f4f8fb!important;
}
.nodecntclass {
    cursor:pointer;
}
</style>
<script>
function __displayloaddingblock() {
    try {
        jQuery("#loading", parent.document).show();     
    } catch (e) {
    }
}
function __hidloaddingblock() {
    try {
        jQuery("#loading", parent.document).hide(); 
    } catch (e) {}
}


jQuery(function () {
    jQuery("#resouce").attr("onPropertyChange", "_search(2, document.getElementById('resouce').value)");
    jQuery("html").live('mouseup', function (e) {
        if (jQuery("#searchblock").is(":visible") && !!!jQuery(e.target).closest("#searchblock")[0]) {
            //jQuery("#searchblock").hide();
            if (!jQuery("#searchblock").is(":visible") == false) {
                toggersearchblock();
            }
        }
        e.stopPropagation();
    });
});

function toggersearchblock() {
    if (jQuery("#searchblock").is(":hidden")) {
        jQuery("#searchblock").show();
        jQuery("#contenblock").css("top", (parseInt(jQuery("#contenblock").css("top")) + jQuery("#searchblock").height()) + "px");
    } else {
        jQuery("#searchblock").hide();
        jQuery("#contenblock").css("top", (parseInt(jQuery("#contenblock").css("top")) - jQuery("#searchblock").height()) + "px");
    }
}
var _nodeselectval = "";
var _resourceval = "";

function _search(type, val) {
    __displayloaddingblock();
    
    var ajaxurl = "";
    var queryString = "<%=request.getQueryString().replaceAll("&disnodeid=[^&]*", "").replaceAll("&disresource=[^&]*", "") %>" 
    ajaxurl = "/workflow/request/WorkflowRequestPictureResult.jsp?_token=" + new Date().getTime() +"&" + queryString;
    
    var frameurl = jQuery("#content").attr("src");
    if (frameurl.indexOf("WorkflowRequestPictureFrame.jsp") != -1) {
    } else {
        ajaxurl = frameurl.replace(/\&disnodeid=[^\&]*/g, "").replace(/\&disresource=[^\&]*/g, "");
    }
    
    var nodeselectval = jQuery("#nodeselect").val();
    var resourceval =  jQuery("#resouce").val();
    
    if (!!!nodeselectval) {
        nodeselectval = "";
    }
    if (!!!resourceval) {
        resourceval = "";
    }
    if (nodeselectval == _nodeselectval && resourceval == _resourceval) {
        return ;
    } else {
        _nodeselectval = nodeselectval;
        _resourceval = resourceval;
    }
    
    ajaxurl += "&disnodeid=" + nodeselectval + "&disresource=" + resourceval;
    /*
    
    jQuery(".statuscntblock").attr("_slt", "0")
    jQuery(".statuscntblock").each(function (){
        var imgsrc = "";
        var sltClass = "";
        var sindex = jQuery(this).attr("_index"); 
        
        if (sindex == "1") {
            imgsrc = "/images/ecology8/workflow/wfstatus/all_wev8.png";
        } else if (sindex == "2") {
            imgsrc = "/images/ecology8/workflow/wfstatus/submit_wev8.png";
        } else if (sindex == "3") {
            imgsrc = "/images/ecology8/workflow/wfstatus/nosubmit_wev8.png";
        } else if (sindex == "4") {
            imgsrc = "/images/ecology8/workflow/wfstatus/noview_wev8.png";
        } 
        sltClass = "slt_" + sindex;
        jQuery(this).find("img").attr("src", imgsrc);
        jQuery(this).removeClass(sltClass);
    });
    
    */
    
    jQuery("#content").attr("src", ajaxurl)
}
jQuery(function () {
    jQuery(".statuscntblock").bind("click", function () {
        //if (jQuery(this).attr("_slt") == "1") {
        //    return;
        //}
        
        
        if (!jQuery("#searchblock").is(":visible") == false) {
            toggersearchblock();
        }
        jQuery("#nodeselect").val("");
        //jQuery("#nodeselect").selectbox("change");
        jQuery(".sbHolder .sbSelector").html("");
        
        jQuery("#resouce").val("");
        jQuery("#resoucespan").html("");
        
        var ajaxurl = "/workflow/request/WorkflowRequestPictureResult.jsp?_token=" + new Date().getTime() +"&<%=request.getQueryString().replace("&disremark", "&disremark_2") %>";
        
        var sindex = jQuery(this).attr("_index"); 
        if (sindex == "1") {
            ajaxurl = "/workflow/request/WorkflowRequestPictureFrame.jsp?_token=" + new Date().getTime() +"&<%=request.getQueryString()%>";
        } else if (sindex == "2") {
            ajaxurl += "&disremark=2";
        } else if (sindex == "3") {
            ajaxurl += "&disremark=1";
        } else if (sindex == "4") {
            ajaxurl += "&disremark=0";
        } else if (sindex == "5") {
            ajaxurl += "&disremark=3";
        } 
        jQuery(".statuscntblock").not(this).attr("_slt", "0")
        jQuery(".statuscntblock").not(this).each(function (){
            var imgsrc = "";
            var sltClass = "";
            var sindex = jQuery(this).attr("_index"); 
            
            if (sindex == "1") {
                imgsrc = "/images/ecology8/workflow/wfstatus/all_wev8.png";
            } else if (sindex == "2") {
                imgsrc = "/images/ecology8/workflow/wfstatus/submit_wev8.png";
            } else if (sindex == "3") {
                imgsrc = "/images/ecology8/workflow/wfstatus/nosubmit_wev8.png";
            } else if (sindex == "4") {
                imgsrc = "/images/ecology8/workflow/wfstatus/noview_wev8.png";
            } else if (sindex == "5") {
                imgsrc = "/images/ecology8/workflow/wfstatus/view_wev8.png";
            } 
            sltClass = "slt_" + sindex;
            jQuery(this).find("img").attr("src", imgsrc);
            jQuery(this).removeClass(sltClass);
        });
        jQuery(this).attr("_slt", 1)
        
        //重置搜索项全局变量的值,否则切换Tab时搜索上一次值会return掉

        _nodeselectval = "";
        _resourceval = "";
        
        jQuery("#content").attr("src", ajaxurl);
        __displayloaddingblock();
    });

    
    
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
});
    
</script>