<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.conn.ConnStatement,weaver.general.BaseBean,weaver.general.Util" %>
<%@ page import="weaver.ldap.LdapUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("intergration:ldapsetting", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
    String method = Util.fromScreen(request.getParameter("method"), user.getLanguage());


    int isuseldap = Util.getIntValue(Util.null2String(request.getParameter("isuseldap")), 0);
    String ldaptype = Util.null2String(request.getParameter("ldaptype"));
    String ldapserverurl = Util.null2String(request.getParameter("ldapserverurl"));
    String ldaparea = Util.null2String(request.getParameter("ldaparea"));
    String ldapuser = Util.null2String(request.getParameter("ldapuser"));
    String ldappasswd = Util.null2String(request.getParameter("ldappasswd"));
    String ldapcondition = Util.null2String(request.getParameter("ldapcondition"));
    String factoryclass = Util.null2String(request.getParameter("factoryclass"));
    String isUac = Util.null2String(request.getParameter("isUac"));
    String uacValue = Util.null2String(request.getParameter("uacValue"));
    String ldaplogin = Util.null2String(request.getParameter("ldaplogin"));
    String TimeModul = Util.null2String(request.getParameter("TimeModul"));

    String encriptpwd = "1";
    //密码加密
    String password = new BaseBean().getPropValue("AESpassword", "pwd");
    if (password.equals("")) {//缺省加密密码
        password = "1";
    }
    String sourceLdappasswd = ldappasswd;//明文密码
    ldappasswd = weaver.general.AES.encrypt(ldappasswd, password);//加密

    String Frequency = "0";
    String frequencyy = "0";
    String createType = "";
    String createTime = "";

    Frequency = Util.null2String(request.getParameter("fer_" + TimeModul));
    Frequency = Frequency.equals("0") ? "1" : Frequency;
    Frequency = Frequency.equals("") ? "0" : Frequency;
    frequencyy = frequencyy.equals("0") ? "1" : frequencyy;
    frequencyy = Util.null2String(request.getParameter("frey"));
    frequencyy = frequencyy.equals("0") ? "1" : frequencyy;
    frequencyy = frequencyy.equals("") ? "0" : frequencyy;
    if ("3".equals(TimeModul))
    //天
    {
        createTime = Util.null2String(request.getParameter("dayTime"));
    } else if ("0".equals(TimeModul))
    //周
    {
        createTime = Util.null2String(request.getParameter("weekTime"));
    } else if ("1".equals(TimeModul))
    //月
    {
        createType = Util.null2String(request.getParameter("monthType"));

        createTime = Util.null2String(request.getParameter("monthTime"));
    } else if ("2".equals(TimeModul))
    //年
    {
        createType = Util.null2String(request.getParameter("yearType"));

        createTime = Util.null2String(request.getParameter("yearTime"));
    }
    if ("".equals(createTime) || null == createTime)
    //如果创建时间为空，则默认为00:00
    {
        createTime = "00:00";
    }
    String ldapattrs[] = request.getParameterValues("ldapattr");
    String userattrs[] = request.getParameterValues("userattr");
    String ldapsubattrs[] = request.getParameterValues("ldapsubattr");
    String subattrs[] = request.getParameterValues("subattr");
    String ldapdepattrs[] = request.getParameterValues("ldapdepattr");
    String depattrs[] = request.getParameterValues("depattr");

    String ouattrs[] = request.getParameterValues("ouattr");
    String companyvals[] = request.getParameterValues("companyval");
    String departmentvals[] = request.getParameterValues("departmentval");

    String subcompanyids[] = request.getParameterValues("subcompanyid");
    String subcompanydomains[] = request.getParameterValues("subcompanydomain");
    String ldapserverurl2 = request.getParameter("ldapserverurl2");
    String needSynOrg = request.getParameter("needSynOrg");
    String needSynPassword = request.getParameter("needSynPassword");
    String keystorepath = request.getParameter("keystorepath");
    String keystorepassword = request.getParameter("keystorepassword");
    String needSynPerson = request.getParameter("needSynPerson");
    String passwordpolicy = request.getParameter("passwordpolicy");
    String ldapSyncMethod = request.getParameter("ldapSyncMethod");
    String passingCert = request.getParameter("passingCert");
    String userblacklist = request.getParameter("userblacklist");
    
    
    ConnStatement connStatement = null;
    try {

        if ("y".equals(needSynOrg) && subcompanyids != null && subcompanyids.length > 0) {
            for (int i = 0; i < subcompanyids.length; i++) {
                String id = subcompanyids[i];
                rs.executeSql("select * from hrmsubcompany where id = " + id + " and (subcompanycode is null or subcompanycode = '')");
                if (rs.next()) {
                    response.sendRedirect("/integration/ldapsetting.jsp?test=false" + "&errormsg=codenull&flage=" + id);
                    return;
                }
            }

        }


        rs.executeSql("delete from ldapset");
        connStatement = new ConnStatement();
        //String SQL = "INSERT INTO ldapset(isuseldap,ldaptype,ldapserverurl,ldaparea,ldapuser,ldappasswd,ldapcondition ,TimeModul,Frequency,frequencyy,createType,createTime,factoryclass,isUac,uacValue,ldaplogin) "
        //			+ " values('"+isuseldap+"','"+ldaptype+"','"+ldapserverurl+"','"+ldaparea+"','"+ldapuser+"','"+ldappasswd+"',
        //		'"+ldapcondition+"',"+TimeModul+","+Frequency+","+frequencyy+",'"+createType+"','"+createTime+"',
        //		'"+factoryclass+"','"+isUac+"','"+uacValue+"','"+ldaplogin+"')";
        String SQL = "INSERT INTO ldapset(isuseldap,ldaptype,ldapserverurl,ldaparea,ldapuser,ldappasswd,ldapcondition ,TimeModul,Frequency,frequencyy,createType,createTime,factoryclass,isUac,uacValue,ldaplogin,ldapserverurl2,needSynOrg,needSynPassword,keystorepath,keystorepassword,needSynPerson,passwordpolicy,encriptpwd,ldapSyncMethod,passingCert,userblacklist) "
                + " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        connStatement.setStatementSql(SQL);
        connStatement.setString(1, "" + isuseldap);
        connStatement.setString(2, ldaptype);
        connStatement.setString(3, ldapserverurl);
        connStatement.setString(4, ldaparea);
        connStatement.setString(5, ldapuser);
        connStatement.setString(6, ldappasswd);
        connStatement.setString(7, ldapcondition);
        connStatement.setInt(8, Util.getIntValue(TimeModul));
        connStatement.setInt(9, Util.getIntValue(Frequency));
        connStatement.setInt(10, Util.getIntValue(frequencyy));
        connStatement.setString(11, createType);
        connStatement.setString(12, createTime);
        connStatement.setString(13, factoryclass);
        connStatement.setString(14, isUac);
        connStatement.setString(15, uacValue);
        connStatement.setString(16, ldaplogin);
        connStatement.setString(17, ldapserverurl2);
        connStatement.setString(18, needSynOrg);
        connStatement.setString(19, needSynPassword);
        connStatement.setString(20, keystorepath);
        connStatement.setString(21, keystorepassword);
        connStatement.setString(22, needSynPerson);
        connStatement.setString(23, passwordpolicy);
        connStatement.setString(24, encriptpwd);
        connStatement.setString(25, ldapSyncMethod);
        connStatement.setString(26, passingCert);
        connStatement.setString(27, userblacklist);
        new BaseBean().writeLog(connStatement.toString());
        connStatement.executeUpdate();

        if (!"1".equals(ldapSyncMethod)) {
            rs.executeSql("update ldapimporttime set usertime = '1970-01-01 00:00:00' where usertime='0'");

        }

        LdapUtil.getInstance().setLdappasswd(sourceLdappasswd);//刷新密码

        //rs.executeSql(SQL);
        rs.executeSql("delete from ldapsetparam");
        if (ldapattrs != null) {
            for (int i = 0; i < ldapattrs.length; i++) {
                String ldapattr = ldapattrs[i];
                String userattr = userattrs[i];
                if (!ldapattr.equals("") && !userattr.equals("")) {
                    //rs.executeSql("insert into ldapsetparam(ldapattr,userattr) values('"+ldapattr+"','"+userattr+"')");
                    SQL = "insert into ldapsetparam(ldapattr,userattr) values(?,?)";
                    connStatement.setStatementSql(SQL);
                    connStatement.setString(1, "" + ldapattr);
                    connStatement.setString(2, userattr);
                    connStatement.executeUpdate();
                }
            }
			//[80][90]Ldap集成-解决同步字段设置重复的问题
			rs.executeSql("delete from ldapsetparam where ldapattr in(select ldapattr from ldapsetparam  group by ldapattr having count(1) >= 2) and id not in (select min(id)from ldapsetparam  group by ldapattr having count(1) >=2)");
        }

        //update ldapsetdetail table
        rs.executeSql("delete from ldapsetdetail");
        if (subcompanyids != null) {
            String executeSql = "";

            for (int j = 0; j < subcompanyids.length; j++) {
                String subcompanyid = subcompanyids[j];
                String subcompanydomain = subcompanydomains[j];
                String subcompanycode = "";
                rs.executeSql("select subcompanycode from hrmsubcompany where id=" + subcompanyid);
                if (rs.next()) {
                    subcompanycode = rs.getString("subcompanycode");
                }
                if (!"".equals(subcompanyid) && !"".equals(subcompanydomain)) {
                    String sql = "select * from ldapsetdetail where subcompanyid = '" + subcompanyid + "'";
                    rs.executeSql(sql);
                    if (rs.next()) {

                        executeSql = "update ldapsetdetail set subcompanydomain='"
                                + subcompanydomain + "',subcompanycode='" + subcompanycode + "' where subcompanyid='" + subcompanyid + "'";
                        rs.executeSql(executeSql);
                    } else {

                        executeSql = "insert into ldapsetdetail(subcompanycode,subcompanydomain,subcompanyid) values (?,?,?)";
                        connStatement.setStatementSql(executeSql);
                        connStatement.setString(1, subcompanycode);
                        connStatement.setString(2, subcompanydomain);
                        connStatement.setString(3, subcompanyid);
                        connStatement.executeUpdate();
                    }
                }
            }
        }

        //the parameter of subcompany field
        rs.executeSql("delete from ldapsetsubparam");
        if (ldapsubattrs != null) {
            for (int i = 0; i < ldapsubattrs.length; i++) {
                String ldapsubattr = ldapsubattrs[i];
                String subattr = subattrs[i];
                if (!"".equals(ldapsubattr) && !"".equals(subattr)) {
                    String insertSql = "insert into ldapsetsubparam(subattr,ldapsubattr) values('" + subattr + "','" + ldapsubattr + "')";
                    rs.executeSql(insertSql);
                }
            }
			//[80][90]Ldap集成-解决同步字段设置重复的问题
			rs.executeSql(" delete from ldapsetsubparam where subattr in(select subattr from ldapsetsubparam  group by subattr having count(1) >= 2) and id not in (select min(id)from ldapsetsubparam  group by subattr having count(1) >=2)");
        }
        //the parameter of department field
        rs.executeSql("delete from ldapsetdepparam");
        if (ldapdepattrs != null) {
            for (int i = 0; i < ldapdepattrs.length; i++) {
                String ldapdepattr = ldapdepattrs[i];
                String depattr = depattrs[i];
                if (!"".equals(ldapdepattr) && !"".equals(depattr)) {
                    String insertSql = "insert into ldapsetdepparam(depattr,ldapdepattr) values('" + depattr + "','" + ldapdepattr + "')";
                    rs.executeSql(insertSql);
                }
            }
			//[80][90]Ldap集成-解决同步字段设置重复的问题
			rs.executeSql("delete from ldapsetdepparam where depattr in(select depattr from ldapsetdepparam  group by depattr having count(1) >= 2) and id not in (select min(id)from ldapsetdepparam  group by depattr having count(1) >=2)");
        }

        //the parameter of outypesetting field
        rs.executeSql("delete from ldapsetoutype");
        if (ouattrs != null) {
            for (int i = 0; i < ouattrs.length; i++) {
                String ouattr = ouattrs[i];
                String companyval = companyvals[i];
                String departmentval = departmentvals[i];
                if (!"".equals(ouattr) && !"".equals(companyval) && !"".equals(departmentval)) {
                    String insertSql = "insert into ldapsetoutype(ouattr,subcompany,department) values('" + ouattr + "','" + companyval + "','" + departmentval + "')";
                    rs.executeSql(insertSql);
                }
            }
        }

        if ("test".equals(method)) {
            String url1 = "";
            String url2 = "";
            String needSynpassword = "";
            String flage = "1";
            rs.executeSql("select * from ldapset");
            if (rs.next()) {
                url1 = rs.getString("ldapserverurl");
                url2 = rs.getString("ldapserverurl2");
                needSynpassword = rs.getString("needSynpassword");

            }
            LdapUtil ldapUtil = LdapUtil.getInstance(true);
            boolean test = ldapUtil.testexport(url1);
            if (test) {

                flage = "2";
                if ("y".equals(needSynpassword)) {

                    test = ldapUtil.testexport(url2);
                }
            }
            String errormsg = ldapUtil.getErrormsg();
            errormsg = java.net.URLEncoder.encode(errormsg, "utf-8");
            response.sendRedirect("/integration/ldapsetting.jsp?test=" + test + "&errormsg=" + errormsg + "&flage=" + flage);
        } else {
            LdapUtil ldapUtil = LdapUtil.getInstance();
            response.sendRedirect("/integration/ldapsetting.jsp");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if(connStatement !=null){
            connStatement.close();
        }
    }		
%>