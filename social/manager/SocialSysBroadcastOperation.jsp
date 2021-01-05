<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.conn.BatchRecordSet"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
    String id = Util.null2String(request.getParameter("id"));
    String method = Util.null2String(request.getParameter("method"));
    String permissionType = Util.null2String(request.getParameter("permissionType"));
    String relatedshareid = Util.null2String(request.getParameter("relatedshareid"));
    String seclevel = Math.min(Util.getIntValue(request.getParameter("seclevel")), Util.getIntValue(request.getParameter("seclevelMax"))) + "";
    String seclevelMax = Math.max(Util.getIntValue(request.getParameter("seclevel")), Util.getIntValue(request.getParameter("seclevelMax"))) + "";
    String seclevelto = Util.null2String(request.getParameter("seclevelto"));

    String jobtitlelevel = Util.null2String(request.getParameter("jobtitlelevel"));
    String jobtitlesubcompany = Util.null2String(request.getParameter("jobtitlesubcompany"));
    String jobtitledepartment = Util.null2String(request.getParameter("jobtitledepartment"));
    String scopeid = "0";
    if (jobtitlelevel.equals("1")) {
        scopeid = jobtitledepartment;
    } else if (jobtitlelevel.equals("2")) {
        scopeid = jobtitlesubcompany;
    }
    scopeid = "," + scopeid + ",";

    String jobtitleid = "-1";

    String CurrentUser = "" + user.getUID();
    String SubmiterType = "" + user.getLogintype();

    boolean isfromtab = Util.null2String(request.getParameter("isfromtab")).equals("true") ? true : false;
    String userid = "0";
    String departmentid = "0";
    String roleid = "0";
    String foralluser = "0";
    String subcompanyid = "0";
    if (permissionType.equals("1"))
        userid = relatedshareid;
    if (permissionType.equals("2"))
        departmentid = relatedshareid;
    if (permissionType.equals("3"))
        roleid = relatedshareid;
    if (permissionType.equals("4"))
        foralluser = "1";
    if (permissionType.equals("6"))
        jobtitleid = relatedshareid;

    jobtitleid = "," + jobtitleid + ",";

    /* 执行方法 */
    // 删除
    if ("delete".equals(method)) {
        RecordSet.executeSql("delete from Social_IMSysBroadcast where id = " + id);
        response.sendRedirect("/social/manager/SocialSysBroadcastList.jsp");
        return;
    }

    // 批量删除
    else if ("batchDelete".equals(method)) {
        RecordSet.executeSql("delete from Social_IMSysBroadcast where id in (" + id + ")");
        response.sendRedirect("/social/manager/SocialSysBroadcastList.jsp");
        return;
    }

    // 添加
    else if ("add".equals(method)) {
        String[] shaveVauesList = Util.TokenizerString2(relatedshareid, ",");
        List<String> paraList = new ArrayList<String>();
        char flag = Util.getSeparator();
		String para = "";
        
        RecordSet recordSet = new RecordSet();
        String wherejob = " and scopeid = '" + scopeid + "'";
        if (jobtitleid != null && !"".equals(jobtitleid))
            wherejob += " and jobtitleid = '" + jobtitleid + "'";
        if (jobtitlelevel != null && !"".equals(jobtitlelevel))
            wherejob += " and joblevel = " + jobtitlelevel;
        
        String minSeclevel = seclevel;
        String maxSeclevel = seclevelMax;

        for (String shaveVaue : shaveVauesList) {
            if (shaveVaue.equals("")) {
                continue;
            }

            para = shaveVaue + flag + permissionType + flag + minSeclevel
                    + flag + maxSeclevel + flag + jobtitleid + flag
                    + jobtitlelevel + flag + scopeid;
            RecordSet reSet = new RecordSet();
            String minSeclevelwhere = " seclevel = " + minSeclevel;
            if (minSeclevel == null || "".equals(minSeclevel))
                minSeclevelwhere = " seclevel is null ";
            String selsql = "select id from Social_IMSysBroadcast where contents = '" + shaveVaue + "' and permissionType = "
                    + permissionType + " and " + minSeclevelwhere + " and seclevelMax = "
                    + maxSeclevel + wherejob;
            reSet.execute(selsql);
            if (!reSet.next()) {
                paraList.add(para);
            }
        }

        new BatchRecordSet().executeSqlBatch("insert into Social_IMSysBroadcast(contents,permissionType,seclevel,seclevelMax,jobtitleid,joblevel,scopeid)"
                                + " values (?,?,?,?,?,?,?)", paraList);

        if (!isfromtab) {
            RecordSet.executeSql("delete from Social_IMSysBroadcast where id in (" + id + ")");
        } else {
            out.print("<script>parent.getParentWindow(window).addShareCallback();</script>");
        }
        return;
    }
%>