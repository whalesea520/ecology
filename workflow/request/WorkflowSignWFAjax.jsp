<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<jsp:useBean id="rssign" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rssign1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
    int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
    int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);
    int userid = Util.getIntValue(request.getParameter("userid"), 0);
    int languageid = Util.getIntValue(request.getParameter("languageid"), 0);
    String returnstr = "<table class=liststyle cellspacing=1>";
    returnstr += "<colgroup><col width=\"10%\"><col width=\"15%\"> <col width=\"20%\"><col width=\"40%\"> <col width=\"15%\"><tbody><tr class=HeaderForXtalbe>";
    returnstr += "<th>" + SystemEnv.getHtmlLabelName(882, languageid) + "</th>";
    returnstr += "<th>" + SystemEnv.getHtmlLabelName(1339, languageid) + "</th>";
    returnstr += "<th>" + SystemEnv.getHtmlLabelName(259, languageid) + "</th>";
    returnstr += "<th>" + SystemEnv.getHtmlLabelName(23753, languageid) + "</th>";
    returnstr += "<th>" + SystemEnv.getHtmlLabelName(1335, languageid) + "</th></tr>";

    int mainrequestid = 0;
    int mainworkflowid = 0;
    String canviewworkflowid = "-1";
    ArrayList allrequestid = new ArrayList();
    rssign.executeSql("select requestname,mainrequestid from workflow_requestbase where requestid = " + requestid);
    if (rssign.next()) {
        if (rssign.getInt("mainrequestid") > -1) {
            mainrequestid = rssign.getInt("mainrequestid");
            rssign.executeSql("select * from workflow_requestbase where requestid = " + mainrequestid);
            if (rssign.next()) {
                allrequestid.add(mainrequestid + ".main");
            }
        }
    }

    rssign.executeSql("select * from workflow_requestbase where requestid = " + mainrequestid);
    if (rssign.next()) {
        mainworkflowid = rssign.getInt("workflowid");
    }

    rssign.executeSql("select distinct subworkflowid from Workflow_SubwfSet where mainworkflowid in (" + mainworkflowid + "," + workflowid + ") and isread = 1 ");
    while (rssign.next()) {
        canviewworkflowid += "," + rssign.getString("subworkflowid");
    }

    rssign.executeSql("select distinct b.subworkflowid from Workflow_TriDiffWfDiffField a, Workflow_TriDiffWfSubWf b where a.id=b.triDiffWfDiffFieldId and b.isRead=1 and a.mainworkflowid in (" + mainworkflowid + "," + workflowid + ")");
    while (rssign.next()) {
        canviewworkflowid += "," + rssign.getString("subworkflowid");
    }
/**161014 zzw 添加判断 **/
if(mainrequestid>0&&!"-1".equals(canviewworkflowid)){
    rssign.executeSql("select * from workflow_requestbase where mainrequestid = " + mainrequestid + " and workflowid in (" + canviewworkflowid + ")");
    while (rssign.next()) {
        allrequestid.add(rssign.getString("requestid") + ".parallel");
    }
}
if(requestid>0&&!"-1".equals(canviewworkflowid)){
    rssign.executeSql("select * from workflow_requestbase where mainrequestid = " + requestid + " and workflowid in (" + canviewworkflowid + ")");
    while (rssign.next()) {
        allrequestid.add(rssign.getString("requestid") + ".sub");
    }
}	

    int index = allrequestid.indexOf(requestid + ".parallel");
    if (index > -1) {
        allrequestid.remove(index);
    }

    if (mainrequestid > 0) {
        rssign.executeSql("select 1 from Workflow_SubwfSet where mainworkflowid = " + mainworkflowid + " and subworkflowid =" + workflowid + " and isread = 1 union select 1 from Workflow_TriDiffWfDiffField a, Workflow_TriDiffWfSubWf b where a.id=b.triDiffWfDiffFieldId and b.isRead=1 and a.mainworkflowid=" + mainworkflowid + " and b.subWorkflowId=" + workflowid);
        if (rssign.getCounts() == 0 && allrequestid.size() > 0) {
            allrequestid.remove(0);
        }
    }

    String viewLogIds = "-1";
    ArrayList canViewIds = new ArrayList();
    rssign.executeSql("select distinct nodeid from workflow_currentoperator where requestid=" + requestid + " and userid=" + userid);

    while (rssign.next()) {
        String singleViewLogIds = "-1";
        rssign1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + Util.getIntValue(rssign.getString("nodeid")));
        if (rssign1.next()) {
            singleViewLogIds = rssign1.getString("viewnodeids");
        }

        if ("-1".equals(singleViewLogIds)) {//全部查看
            rssign1.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
            while (rssign1.next()) {
                String tempNodeId = rssign1.getString("nodeid");
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
    if (canViewIds.size() > 0) {
        for (int a = 0; a < canViewIds.size(); a++) {
            if (a == 0) {
                viewLogIds = (String) canViewIds.get(a);
            } else {
                viewLogIds += "," + (String) canViewIds.get(a);
            }
        }
    }
    String orderby = "desc";
    ArrayList signwfidlist = new ArrayList();
    rssign.executeSql("select orderbytype from workflow_base where id = " + workflowid);
    if (rssign.next()) {
        if ("2".equals(rssign.getString(1))) orderby = "asc";
    }
    String sql = "select   t1.signworkflowids, t2.nodename from workflow_requestlog t1,workflow_nodebase t2 " +
            " where t1.requestid=" + requestid + " and t1.nodeid=t2.id and t1.logtype != '1' " +
            " and t1.nodeid in (" + viewLogIds + ") and signworkflowids is not null and signworkflowids>' ' order by t1.operatedate " + orderby + ",t1.operatetime " + orderby + ",t1.logtype " + orderby;
    rssign.executeSql(sql);
    while (rssign.next()) {
        String signworkflowids = Util.null2String(rssign.getString("signworkflowids"));
        ArrayList signlist = Util.TokenizerString(signworkflowids, ",");
        for (int i = 0; i < signlist.size(); i++) {
            String tempdoc = (String) signlist.get(i);
            if (tempdoc != null && !"".equals(tempdoc.trim()) && signwfidlist.indexOf(tempdoc) < 0)
                signwfidlist.add(tempdoc);
        }
    }
    for (int j = 0; j < allrequestid.size(); j++) {
        String temp = allrequestid.get(j).toString();
        int tempindex = temp.indexOf(".");
        requestid = Util.getIntValue(temp.substring(0,tempindex),0);
        sql = "select   t1.signworkflowids, t2.nodename from workflow_requestlog t1,workflow_nodebase t2 " +
                " where t1.requestid=" + requestid + " and t1.nodeid=t2.id and t1.logtype != '1' " +
                " and signworkflowids is not null and signworkflowids>' ' order by t1.operatedate " + orderby + ",t1.operatetime " + orderby + ",t1.logtype " + orderby;
        rssign.executeSql(sql);
        while (rssign.next()) {
            String signworkflowids = Util.null2String(rssign.getString("signworkflowids"));
            ArrayList signlist = Util.TokenizerString(signworkflowids, ",");
            for (int i = 0; i < signlist.size(); i++) {
                String tempdoc = (String) signlist.get(i);
                if (tempdoc != null && !"".equals(tempdoc.trim()) && signwfidlist.indexOf(tempdoc) < 0)
                    signwfidlist.add(tempdoc);
            }
        }
    }
    int linknum = -1;
    int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
    for (int k = 0; k < signwfidlist.size(); k++) {
        linknum++;
        String reqid = (String) signwfidlist.get(k);
        String reqname = wfrequestcominfo.getRequestName(reqid);
        String creater=wfrequestcominfo.getCreater(reqid);
        String createtime=wfrequestcominfo.getCreatetime(reqid);
        String status=wfrequestcominfo.getStatus(reqid);
        String tempworkflowid=wfrequestcominfo.getWorkflowId(reqid);
        if(k%2==0){
            returnstr += "<tr class=datalight>";
        }else{
            returnstr += "<tr class=datadark>";
        }
        tempnum++;
        session.setAttribute("resrequestid" + tempnum, "" + signwfidlist.get(k));
        returnstr += "<td><A href='javaScript:openhrm(\"" + creater + "\");' onclick='pointerXY(event);'>" + ResourceComInfo.getLastname(creater) + "</A></td>";
        returnstr += "<td>" + createtime + "</td>";
        returnstr += "<td>" + WorkflowComInfo.getWorkflowname(tempworkflowid)+"</td>";
        returnstr += "<td><A style=\"cursor:hand\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?isrequest=1&requestid=" + reqid + "&wflinkno="+tempnum+"')\">" +reqname + "</A></td>";
        returnstr += "<td>" + status + "</td>";
        returnstr += "</tr>";
    }
    session.setAttribute("slinkwfnum", "" + tempnum);
    session.setAttribute("haslinkworkflow", "1");
    if(signwfidlist.size()<1){
        returnstr+="<tr><td colspan=\"5\">&nbsp;</td></tr>";
    }
    returnstr += "</tbody></table>";
    //System.out.print("returnstrwf:"+returnstr);
    response.setContentType("text/text;charset=UTF-8");//返回的是txt文本文件
    out.print(returnstr);
%>