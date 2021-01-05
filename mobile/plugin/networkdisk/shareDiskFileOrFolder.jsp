<%@ page language="java" pageEncoding="utf-8"%>

<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map"%>
<%@ page import="weaver.file.*" %>
<%@page import="weaver.general.TimeUtil"%>
<jsp:useBean id="ps"
	class="weaver.mobile.plugin.ecology.service.PluginServiceImpl"
	scope="page" />
<%@ page import="org.json.JSONObject"%>
<%@page import="weaver.conn.RecordSet"%>

<%
	FileUpload fu = new FileUpload(request);
    String sessionkey = fu.getParameter("sessionkey");
	RecordSet rs = new RecordSet();
    User user = HrmUserVarify.getUser(request, response);
    if (user == null) {
        Map result = ps.getCurrUser(sessionkey);
        user = new User();
        user.setUid(Util.getIntValue(result.get("id").toString()));
        user.setLastname(result.get("name").toString());
    }
	
    JSONObject json = new JSONObject();
    String userids = Util.null2String(fu.getParameter("userids"));
    String groupids = Util.null2String(fu.getParameter("groupids"));
    String folderids = Util.null2String(fu.getParameter("folderid"));
    String fileids = Util.null2String(fu.getParameter("fileid"));
	String msgid = Util.null2String(fu.getParameter("msgid"));
    String date = TimeUtil.getCurrentDateString();
    String time = TimeUtil.getOnlyCurrentTimeString();
    if (!fileids.isEmpty()) {
        if (!userids.isEmpty()) {
            for (String fileid : fileids.split(",")) {
                if (fileid.isEmpty())
                    continue;
				
                for (String userid : userids.split(",")) {
                    if (userid.isEmpty())
                        continue;
                    rs.executeSql("insert into Networkfileshare(fileid,sharerid,tosharerid,sharedate,sharetime,sharetype,filetype,msgId) values(" + fileid + "," + user.getUID() + ",'" + userid + "','" + date + "','" + time + "',1,1,'" + msgid + "')");
                }
            }
        }
        if (!groupids.isEmpty()) {
            for (String fileid : fileids.split(",")) {
                if (fileid.isEmpty())
                    continue;
                for (String groupid : groupids.split(",")) {
                    if (groupid.isEmpty())
                        continue;
                    rs.executeSql("insert into Networkfileshare(fileid,sharerid,tosharerid,sharedate,sharetime,sharetype,filetype,msgId) values(" + fileid + "," + user.getUID() + ",'" + groupid + "','" + date + "','" + time + "',2,1,'" + msgid + "')");
                }
            }
        }
    } else if (!folderids.isEmpty()) {
        if (!userids.isEmpty()) {
            for (String fid : folderids.split(",")) {
                if (fid.isEmpty())
                    continue;
                for (String userid : userids.split(",")) {
                    if (userid.isEmpty())
                        continue;
                    rs.executeSql("insert into Networkfileshare(fileid,sharerid,tosharerid,sharedate,sharetime,sharetype,filetype,msgId) values(" + fid + "," + user.getUID() + ",'" + userid + "','" + date + "','" + time + "',1,2,'" + msgid + "')");
                }
            }
        }
        if (!groupids.isEmpty()) {
            for (String fid : folderids.split(",")) {
                if (fid.isEmpty())
                    continue;
                for (String groupid : groupids.split(",")) {
                    if (groupid.isEmpty())
                        continue;
                    rs.executeSql("insert into Networkfileshare(fileid,sharerid,tosharerid,sharedate,sharetime,sharetype,filetype,msgId) values(" + fid + "," + user.getUID() + ",'" + groupid + "','" + date + "','" + time + "',2,2,'" + msgid + "')");
                }
            }
        }
    }
    json.put("flag", 1);
    out.println(json);
%>
