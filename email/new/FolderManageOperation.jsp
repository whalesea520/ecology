<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@page import="weaver.general.*"%>
<%@include file="/page/maint/common/initNoCache.jsp"%>

<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<%
    int editfolderid = Util.getIntValue(request.getParameter("editfolderid"));
    int folderid = Util.getIntValue(request.getParameter("folderid"));
    String folderids = Util.null2o(request.getParameter("folderids"));
    String folderName = Util.null2String(request.getParameter("foldername"));
    String method = Util.null2String(request.getParameter("method"));
    String mailsId = Util.null2String(request.getParameter("mailsId"));
    
    if (method.equals("add")) {
        boolean flag = fms.checkRepeatName(user.getUID(), folderName);
        if (!flag) {
            fms.createFolder(user.getUID(), folderName);
        } else {
            out.clearBuffer();
            out.print("repeat");
        }
    } 
    
    else if (method.equals("edit")) {
        boolean flag = fms.checkRepeatName(user.getUID(), folderName, editfolderid + "");
        if (!flag) {
            fms.updateFolder(user.getUID(), editfolderid, folderName);
        } else {
            out.clearBuffer();
            out.print("repeat");
        }
    } 
    
    else if (method.equals("del")) {
        String[] arr = folderids.split(",");
        for (int i = 0; i < arr.length; i++) {
            if (arr[i].equals("")) {
                continue;
            }
            fms.delFolder(user.getUID(), Util.getIntValue(arr[i]));
        }
    } 
    
    else if (method.equals("clear")) {
        if (folderid == -4) { //清空垃圾箱
            String emlPath = application.getRealPath("") + "email\\eml\\";
            mrs.deleteFolderMail("-3", user.getUID(), emlPath);
            return;
        }
        if (folderid == -5) {//内部邮件
            String sql = "update MailResource set folderId= -3 where isInternal = 1 and resourceid =" + user.getUID();
            rs.execute(sql);
            return;
        }
        if (folderid == -6) {//标星邮件
            String sql = "update MailResource set star = 0 where star = 1 and resourceid =" + user.getUID();
            rs.execute(sql);
            return;
        }
        if (folderid < 5) {
            if (folderid == -1)
                folderid = 0;
            if (folderid == -2)
                folderid = -1;
            if (folderid == -3)
                folderid = -2;
            //			if(folderid == -4) folderid = -3;
            fms.clearFolder(user.getUID(), folderid);
            return;
        }
        fms.clearFolder(user.getUID(), folderid);
    } 
    
    else if (method.equals("removeAll")) {

    } 
    
    else if (method.equals("addandmt")) {
        boolean flag = fms.checkRepeatName(user.getUID(), folderName);
        String newfolderId = "";
        if (!flag) {
            fms.createFolder(user.getUID(), folderName);
            if (rs.execute("select MAX(id) m from MailInboxFolder where userId=" + user.getUID() + "") && rs.next()) {
                newfolderId = rs.getString("m");
            }
            //绑定邮件的id到最新的文件夹里面去
            if (!"".equals(mailsId) && !"".equals(newfolderId)) {
                String szmailsid[] = mailsId.split(",");
                for (int i = 0; i < szmailsid.length; i++) {
                    if (!"".equals(szmailsid[i])) {
                        rs.execute("update mailresource set folderid='" + newfolderId + "' where id='" + szmailsid[i] + "'");
                    }
                }
            }
        } else {
            out.clearBuffer();
            out.print("repeat");
        }
    } 
    // 获得当前用户使用空间
    else if (method.equals("getSize")) {
        rs.execute("select count(*) from mailresource where resourceid = " + user.getUID() + " and canview = 1");
        rs.next();
        int totalSize = Util.getIntValue(rs.getString(1));
        
        rs.execute("select count(*) from mailresource where status = 0 and resourceid = " + user.getUID() + " and canview = 1");
        rs.next();
        int unreadsize = Util.getIntValue(rs.getString(1));

        rs.execute("select totalspace, occupyspace from hrmresource where id = " + user.getUID());
        float totalspace = 0f;
        float occupyspace = 0f;
        if (rs.next()) {
            totalspace = Util.getFloatValue(rs.getString("totalspace"), 0f);
			occupyspace = Util.getFloatValue(rs.getString("occupyspace"), 0f);
        }
        if (0 != rs.getCounts() && occupyspace < 0) {//正常人员，但是没有统计数据
            String sql = "UPDATE HrmResource SET occupySpace = "
                    + " round((select sum(size_n) from MailResource where resourceid = " + user.getUID() + " and canview=1)*1.0/(1024*1024),2)" 
                    + " WHERE id = " + user.getUID();
            rs.execute(sql);

            rs.execute("select totalspace , occupyspace from hrmresource where id = " + user.getUID());
            if (rs.next()) {
                totalspace = Util.getFloatValue(rs.getString("totalspace"), 0f);
   			    occupyspace = Util.getFloatValue(rs.getString("occupyspace"), 0f);
            }
        }
        out.clearBuffer();
        out.println(totalSize + "," + unreadsize + "," + occupyspace + "," + totalspace);
    }
%>