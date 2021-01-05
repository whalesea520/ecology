
<%@ page language="java" contentType="text/xml; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="weaver.hrm.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    User user = HrmUserVarify.getUser(request, response);
    if (user == null)
        return;

    String docid = Util.null2String(request.getParameter("docid"));
    if ("".equals(docid))
        return;
    String imagefileid = Util.null2String(request.getParameter("imagefileid"));
    String ipstring = request.getRemoteAddr();
    String userType = user.getLogintype();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String time = format.format(new Date());
    int userid = user.getUID();
    String userName = "";
        if ("1".equals(userType)) { // 如果是内部用户　名称就是　lastName	// 外部则入在　firstName里面
            userName = user.getLastname();
        } else {
            userName = user.getFirstname();
        }
    String sql = "select t2.id,t2.docsubject,t1.imagefilename from DocImageFile t1, DocDetail t2 where t1.docid=t2.id and t1.docfiletype<>1 and t1.imagefileid = " + imagefileid;
        int docidinit = -1;
        String docName = "";
        String imagefilename = "";
    System.out.println("******docid=" + docid);
    RecordSet.executeSql(sql);
        if (RecordSet.next()) {
            docidinit = RecordSet.getInt(1);
            docName = RecordSet.getString(2);
            imagefilename = RecordSet.getString(3);
            sql = "insert into DownloadLog(userid, username, downloadtime, imageid, imagename, docid, docname,clientaddress) values(" + userid + ",'" + Util.toHtml100(userName) + "','" + time + "'," + imagefileid + ",'" + Util.toHtml100(imagefilename) + "'," + docid + ",'"
                    + Util.toHtml100(docName) + "','" + ipstring + "')";
            RecordSet.executeSql(sql);
        }
%>