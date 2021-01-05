
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page import="weaver.conn.*" %>
<%@page import="java.util.HashMap"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.blog.AppDao"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="java.util.List"%>
<%@page import="oracle.sql.CLOB"%>
<%@page import="java.io.Writer"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.ConnStatement"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cs" class="weaver.conn.ConnStatement" scope="page" />

<%
    boolean isoracle = (cs.getDBType()).equals("oracle");
    HashMap result = new HashMap();
    User user = HrmUserVarify.getUser(request, response);
    if (user == null) {
        result.put("status", "2"); //超时
        JSONObject json = JSONObject.fromObject(result);
        out.println(json);
    } else {

        request.setCharacterEncoding("UTF-8");
        Date today = new Date();
        String userid = "" + user.getUID();
        String curDate = new SimpleDateFormat("yyyy-MM-dd").format(today);//当前日期
        String curTime = new SimpleDateFormat("HH:mm:ss").format(today);//当前时间
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat dateFormat3 = new SimpleDateFormat("yyyy年M月d日 HH:mm");

        String content = Util.null2String(request.getParameter("content")).trim();//日志内容

        String forDate = Util.null2String(request.getParameter("forDate")).trim();
        String appType = Util.null2String(request.getParameter("type"));
        String appItemId = Util.null2String(request.getParameter("appItemId"), "1");
        int discussid = Util.getIntValue(Util.null2String(request.getParameter("discussid")), 0);
        //防止数据传输缺失
        if (content.equals("") || forDate.equals("") || appItemId.equals("0")) {
            result.put("status", "3");
            JSONObject json = JSONObject.fromObject(result);
            out.println(json);

        } else {

            appItemId = appItemId.equals("2") ? appItemId : "1"; //处理心情丢失情况 
            String score = "0";
            String comefrom = "0";

            BlogDao blogDao = new BlogDao();
            String isManagerScore = blogDao.getSysSetting("isManagerScore"); //启用上级评分

            boolean isEdit = discussid != 0 ? true : false; //是否是编辑

            String lastUpdateTime = "" + today.getTime();
            String sql = "";
            AppDao appDao = new AppDao();
            boolean isAppend = false;
            try {
                if (!isEdit) { //如果微博记录id=0 则表示为创建

                    BlogDiscessVo discessVo = blogDao.getDiscussVoByDate(userid, forDate);
                    if (discessVo != null) { //判断是否为新增微薄，discessVo为null为新增，否则当天的内容追加当天内容下：冯广硕

                        if (discessVo.getUserid().equals(userid)) { //防止通过ajax更新他人微博
                            isAppend = true;
                            content = discessVo.getContent() + content;
                            
                            sql = "update blog_discuss set lastUpdatetime=?, content=? where id=?";
                            cs.setStatementSql(sql);
                            cs.setString(1, lastUpdateTime);
                            cs.setCharacterStream(2, content);
                            cs.setString(3, discessVo.getId());
                            
                        }
                    } else {  //新增微薄

                        sql = "insert into blog_discuss (userid, createdate, createtime,content,lastUpdatetime,isReplenish,workdate,score,comefrom)"
                                + " values (?, ?,?,?,?,?,?,?,?)";
                        cs.setStatementSql(sql);
                        cs.setString(1, "" + userid);
                        cs.setString(2, "" + curDate);
                        cs.setString(3, "" + curTime);
                        cs.setCharacterStream(4, content);
                        cs.setString(5, "" + lastUpdateTime);
                        cs.setString(6, "" + (forDate.equals(curDate) ? "0" : "1"));
                        cs.setString(7, "" + forDate);
                        cs.setString(8, "0");
                        cs.setString(9, "0");
                    }

                } else { //更新

                    sql = "update blog_discuss set lastUpdatetime=?,content=? where id=? and userid=?";
                    cs.setStatementSql(sql);
                    cs.setString(1, "" + lastUpdateTime);
                    cs.setCharacterStream(2, content);
                    cs.setInt(3, discussid);
                    cs.setString(4, userid);

                }

                HashMap backData = new HashMap();
                if (cs.executeUpdate() > 0) {
                    cs.close(); //关闭数据库连接

                    //如果是编辑，则取创建时的时间
                    if (isEdit) {
                        BlogDiscessVo discessVo = blogDao.getDiscussVo("" + discussid);
                        curDate = discessVo.getCreatedate();
                        curTime = discessVo.getCreatetime();
                        score = discessVo.getScore();
                        comefrom = discessVo.getComefrom();
                    }
                    //discuss=0表示新建
                    if (!isEdit) {
                        sql = "select id from blog_discuss where userid=? and createdate=? and createtime=?";
                        rs.executeQuery(sql, userid, curDate, curTime);
                        if (rs.next()) {
                            discussid = rs.getInt("id");
                        }
                    }

                    backData.put("id", "" + discussid);
                    backData.put("curDate", curDate);
                    backData.put("curTime", curTime);
                    backData.put("forDate", forDate);

                    String createdatetime = dateFormat3.format(dateFormat.parse(curDate + " " + curTime));
                    backData.put("createdatetime", createdatetime);
                    backData.put("score", score);
                    backData.put("isManagerScore", isManagerScore);

                    backData.put("comefrom", comefrom);

                    backData.put("userName", user.getLastname());
                    backData.put("userid", "" + user.getUID());

                    String type = (!forDate.equals(curDate)) ? "1" : "0"; //是否为补交  1补交 0正常提交
                    backData.put("type", type);

                    result.put("status", "1"); //保存是否成功

                    if (appDao.getAppVoByType("mood").isActive()) {
                        if (!isEdit && !isAppend) {
                            sql = "INSERT INTO blog_appDatas(userid,workDate,createDate,createTime,discussid,appitemId) VALUES('" + user.getUID() + "','" + forDate
                                    + "','" + curDate + "','" + curTime + "','" + discussid + "','" + appItemId + "')";
                        } else {
                            sql = "update blog_appDatas set appitemId=" + appItemId + " where discussid=" + discussid;
                        }
                        rs.executeSql(sql);
                        sql = "SELECT * FROM blog_appDatas LEFT JOIN blog_AppItem ON blog_appDatas.appItemId=blog_AppItem.id WHERE discussid=?";
                        rs.executeQuery(sql, discussid);
                        if (rs.next()) {
                            backData.put("appItemId", appItemId);
                            backData.put("faceImg", rs.getString("face"));
                            backData.put("itemName", SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("itemName")), user.getLanguage()));
                        }
                    }
                    //提交新的微博时给予提醒
                    if (!isEdit && !isAppend) {
                        if(discussid > 0) { //主键值不正确时，无需添加提醒记录
                            //删除阅读记录
                            sql = "DELETE FROM blog_read WHERE blogid=?";
                            rs.executeUpdate(sql, user.getUID());
    
                            //给关注我的人发送微博提交提醒。
                            List attentionMeList = blogDao.getAttentionMe(userid);
                            for (int i = 0; i < attentionMeList.size(); i++) {
                                blogDao.addRemind((String) attentionMeList.get(i), userid, "6", "" + discussid, "0");
                            }
                        }
                    }

                    result.put("backdata", backData);
                    JSONObject json = JSONObject.fromObject(result);

                    out.println(json);

                } else {
                    result.put("status", "0");
                    JSONObject json = JSONObject.fromObject(result);

                    out.println(json);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                cs.close();
            }
        }
    }
%>