<%@ page import="weaver.general.Util,
                 java.sql.Timestamp" %>
<jsp:useBean id="SendMail" class="weaver.general.SendMail" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo1" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo1" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo1" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="CostCenterComInfo1" class="weaver.hrm.company.CostCenterComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo1" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ContacterTitleComInfo1" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<jsp:useBean id="hr" class="java.util.Hashtable" scope="page" />

<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int id= Util.getIntValue(request.getParameter("id"),0);
//modified by wcd 2014-07-04 [支持邮件发送多个应聘人]
String applyid=Util.null2String(request.getParameter("applyid"));
String issearch = Util.null2String(request.getParameter("issearch"));
String rid = Util.null2String(request.getParameter("rid"));
int pagenum=Util.getIntValue(request.getParameter("pagenum"),0);  //对员发群件时

String fromPage = Util.null2String(request.getParameter("fromPage")).trim();

int mailid= Util.getIntValue(request.getParameter("mailid"),0);//获得版式id
String selfComment=Util.fromScreen(request.getParameter("selfComment"),user.getLanguage());//用户自输入邮件正文内容

String subject = Util.null2String(request.getParameter("subject"));//邮件subject
String from = Util.null2String(request.getParameter("from"));      //发件人地址

//add by wjy
String nothrmids = Util.null2String(request.getParameter("nothrmids")); //经过选择排除的邮件发送人
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String fromtime = Util.null2String(request.getParameter("fromtime"));

    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

    fromdate = (fromdate.equals("")?CurrentDate:fromdate); //计划发送日期，如果不写则按当前日期
    fromtime = (fromtime.equals("")?CurrentTime:fromtime); //计划发送时间，如果不写则按当前时间
//add end by wjy

// 对群发邮件进行改进， 增加了群发邮件认证部分的工作
String defmailserver = SystemComInfo.getDefmailserver() ;
String defneedauth = SystemComInfo.getDefneedauth() ;
String defmailuser = SystemComInfo.getDefmailuser() ;
String defmailpassword = SystemComInfo.getDefmailpassword() ;

SendMail.setMailServer(defmailserver) ;
if( defneedauth.equals("1") ) {
    SendMail.setNeedauthsend(true) ;
    SendMail.setUsername(defmailuser) ;
    SendMail.setPassword(defmailpassword) ;
}
else SendMail.setNeedauthsend(false) ;
// 对群发邮件进行改进结束

String email = "" ;
String to = "" ;
String cc = "" ;
String bcc = "" ;
int char_set = 3 ;
String priority = "3" ;
String tempto = "";
String tempto2 = "";
String nothrmid = ""; //被排除的邮件发送人

String  nextpageur1 = "" ;
String succeed = "" ;

/* 分为用户自输入邮件正文和采用版式两种方式,每种方式要虑到来自不同的4种情况*/
boolean sendok = false;

if(mailid==0) {   //不采用版式时而在文本框输入信件内容的情况

    if(issearch.equals("1") && applyid.length()==0)  {  //对某类员工发邮件
        nextpageur1="/hrm/HrmTab.jsp?_fromURL=HrmResourceSearchResult&hassql=1";

        if(!rid.equals(""))
            rs.executeSql("select email,id from HrmResource  where id in ("+rid+")");
        else
            rs.executeSql("select email,id from HrmResource "+HrmSearchComInfo.FormatSQLSearch());
        int i=0 ;
        to = "" ;
        String body = selfComment ;
        int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"1") ;
        while(rs.next()){
            tempto = Util.null2String(rs.getString(1)) ;
            nothrmid = Util.null2String(rs.getString(2)) ;
            if(nothrmids.indexOf(nothrmid)!=-1){
                continue;
            }
            if( !tempto.equals("") && Util.isEmail(tempto)){
                to = tempto;

                sendok = SendMail.sendhtmlProxy(temId,to,Util.fromScreen2(subject,user.getLanguage()),body,nothrmid) ;
            }
        }
        response.sendRedirect("HrmMailMerge.jsp?isclose=1");
		return;
	}
	else if(id!=0&&id!=(-1))  {  //对某个员工发邮件
        nextpageur1="/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+id;
        rs.executeSql("select email,id from HrmResource where id="+id);
        if(rs.next()) {
            tempto = Util.null2String(rs.getString(1)) ;
            tempto2 = Util.null2String(rs.getString(2)) ;
        }
        if( !tempto.equals("") && Util.isEmail(tempto)) to = tempto;

        if(to.length()!=0) {
            String body = selfComment ;
            int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"1") ;
            sendok = SendMail.sendhtmlProxy(temId,to,Util.fromScreen2(subject,user.getLanguage()),body,tempto2) ;
            succeed = to ;
        }
	}
    else if(applyid.length() > 0) {   //对某个应聘者发邮件
        nextpageur1="/hrm/career/HrmCareerApplyEdit.jsp?applyid="+applyid;

        rs.executeSql("select email,id from HrmCareerApply where id in ("+applyid+")");
		String body = selfComment ;
        while(rs.next()) {
            tempto = Util.null2String(rs.getString(1)) ;
            tempto2 = Util.null2String(rs.getString(2)) ;
			if( !tempto.equals("") && Util.isEmail(tempto)){ 
				to = tempto;
			}
			if(to.length()!=0) {
				int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"2") ;
				sendok = SendMail.sendhtmlProxy(temId,to,Util.fromScreen2(subject,user.getLanguage()),body,tempto2) ;
				succeed = to ;
			}
        }
		response.sendRedirect("HrmMailMerge.jsp?isclose=1");
		return;
    }
}

else   { //采用版式时情况
    if(issearch.equals("1") && applyid.length()==0) {   //对某类员工发邮件
        nextpageur1="/hrm/HrmTab.jsp?_fromURL=HrmResourceSearchResult&hassql=1";
        String subject1 = subject;
        String body = "";

        String sql = "select mouldtext from DocMailMould where id="+mailid ;
        rs.executeSql(sql);
        if(rs.next()){
            body = Util.null2String(rs.getString(1));

        }
        int pos = body.indexOf("<IMG alt=");
        while(pos!=-1){
            pos = body.indexOf("?fileid=",pos);
            int endpos = body.indexOf("\"",pos);
            String tmpid = body.substring(pos+8,endpos);
            int startpos = body.lastIndexOf("\"",pos);
            String servername = request.getServerName();
            String tmpcontent = body.substring(0,startpos+1);
            tmpcontent += "http://"+servername;
            tmpcontent += body.substring(startpos+1);
            body = tmpcontent;
            pos = body.indexOf("<IMG alt=",endpos);
        }

		if(!rid.equals(""))
            rs.executeSql("select * from HrmResource  where id in ("+rid+")");
        else
            rs.executeSql("select * from HrmResource "+HrmSearchComInfo.FormatSQLSearch());
        int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"1") ;
        while(rs.next()){
            tempto = Util.null2String(rs.getString("email")) ;
            tempto2 = Util.null2String(rs.getString("id")) ;
            if( !tempto.equals("") && Util.isEmail(tempto)) {
                to = tempto  ;

                hr.put("HRM_Loginid",""+rs.getString("loginid"));
                hr.put("HRM_Name",""+rs.getString("name"));
                hr.put("HRM_Title",""+ContacterTitleComInfo1.getContacterTitlename(rs.getString("titleid")));
                hr.put("HRM_Birthday",""+rs.getString("birthday"));
                hr.put("HRM_Telephone",""+rs.getString("telephone"));
                hr.put("HRM_Email",""+rs.getString("email"));
                hr.put("HRM_Startdate",""+rs.getString("startdate"));
                hr.put("HRM_Enddate",""+rs.getString("enddate"));
                hr.put("HRM_Contractdate",""+rs.getString("contractdate"));
                hr.put("HRM_Jobtitle",""+JobTitlesComInfo1.getJobTitlesname(rs.getString("jobtitle")));
                hr.put("HRM_Jobgroup",""+JobGroupsComInfo1.getJobGroupsname(rs.getString("jobgroup")));
                hr.put("HRM_Jobactivity",""+JobActivitiesComInfo1.getJobActivitiesname(rs.getString("jobactivity")));
                hr.put("HRM_Jobactivitydesc",""+rs.getString("jobactivitydesc"));
                hr.put("HRM_Joblevel",""+rs.getString("joblevel"));
                hr.put("HRM_Seclevel",""+rs.getString("seclevel"));
                hr.put("HRM_Department",""+DepartmentComInfo1.getDepartmentname(rs.getString("departmentid")));
                hr.put("HRM_Costcenter",""+CostCenterComInfo1.getCostCentername(rs.getString("costcenterid")));
                hr.put("HRM_Manager",""+ResourceComInfo1.getResourcename(rs.getString("managerid")));
                hr.put("HRM_Assistant",""+ResourceComInfo1.getResourcename(rs.getString("assistantid")));

                String tempbody = Util.toScreen(Util.fillValuesToString(body,hr),user.getLanguage()) ;
                String tempsubject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());

                sendok = SendMail.sendhtmlProxy(temId,to,Util.fromScreen2(subject,user.getLanguage()),body,tempto2) ;
                succeed = succeed + to + "," ;

            }
        }
        response.sendRedirect("HrmMailMerge.jsp?isclose=1");
		return;
    }
    else if(id!=0&&id!=(-1))   { //对某个员工发邮件
        nextpageur1="/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+id;
        rs.executeSql("select * from HrmResource where id="+id);
        if(rs.next()) {
            tempto = Util.null2String(rs.getString("email")) ;
            tempto2 = Util.null2String(rs.getString("id")) ;
            if( !tempto.equals("") && Util.isEmail(tempto)) {
                to = tempto;
                hr.put("HRM_Loginid",""+rs.getString("loginid"));
                hr.put("HRM_Name",""+rs.getString("name"));
                hr.put("HRM_Title",""+ContacterTitleComInfo1.getContacterTitlename(rs.getString("titleid")));
                hr.put("HRM_Birthday",""+rs.getString("birthday"));
                hr.put("HRM_Telephone",""+rs.getString("telephone"));
                hr.put("HRM_Email",""+rs.getString("email"));
                hr.put("HRM_Startdate",""+rs.getString("startdate"));
                hr.put("HRM_Enddate",""+rs.getString("enddate"));
                hr.put("HRM_Contractdate",""+rs.getString("contractdate"));
                hr.put("HRM_Jobtitle",""+JobTitlesComInfo1.getJobTitlesname(rs.getString("jobtitle")));
                hr.put("HRM_Jobgroup",""+JobGroupsComInfo1.getJobGroupsname(rs.getString("jobgroup")));
                hr.put("HRM_Jobactivity",""+JobActivitiesComInfo1.getJobActivitiesname(rs.getString("jobactivity")));
                hr.put("HRM_Jobactivitydesc",""+rs.getString("jobactivitydesc"));
                hr.put("HRM_Joblevel",""+rs.getString("joblevel"));
                hr.put("HRM_Seclevel",""+rs.getString("seclevel"));
                hr.put("HRM_Department",""+DepartmentComInfo1.getDepartmentname(rs.getString("departmentid")));
                hr.put("HRM_Costcenter",""+CostCenterComInfo1.getCostCentername(rs.getString("costcenterid")));
                hr.put("HRM_Manager",""+ResourceComInfo1.getResourcename(rs.getString("managerid")));
                hr.put("HRM_Assistant",""+ResourceComInfo1.getResourcename(rs.getString("assistantid")));


                String sql = "select mouldtext from DocMailMould  where id="+mailid;

                String body = "";
                rs.executeSql(sql);
                if(rs.next()){
                    body = Util.null2String(rs.getString(1));
                }
                int pos = body.indexOf("<IMG alt=");
                while(pos!=-1){
                    pos = body.indexOf("?fileid=",pos);
                    int endpos = body.indexOf("\"",pos);
                    String tmpid = body.substring(pos+8,endpos);
                    int startpos = body.lastIndexOf("\"",pos);
                    String servername = request.getServerName();
                    String tmpcontent = body.substring(0,startpos+1);
                    tmpcontent += "http://"+servername;
                    tmpcontent += body.substring(startpos+1);
                    body=tmpcontent;
                    pos = body.indexOf("<IMG alt=",endpos);
                }

                subject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
                body = Util.toScreen(Util.fillValuesToString(body,hr),user.getLanguage());
                int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"1") ;
                sendok = SendMail.sendhtmlProxy(temId,to,Util.fromScreen2(subject,user.getLanguage()),body,tempto2) ;
                succeed = to ;
            }
        }
    }
    else if(applyid.length() > 0) { //对某个应聘者发邮件
        nextpageur1="/hrm/career/HrmCareerApplyEdit.jsp?applyid="+applyid;
        rs.executeSql("select email,id from HrmCareerApply where id="+applyid);
        if(rs.next()) {
            tempto = Util.null2String(rs.getString(1)) ;
            tempto2 = Util.null2String(rs.getString(2)) ;
        }
        if( !tempto.equals("") && Util.isEmail(tempto)) to = tempto;

        if(to.length()!=0) {
            String sql = "select mouldtext from DocMailMould  where id="+mailid;
            String body = "";
            rs.executeSql(sql);
            if(rs.next()){
                body = Util.null2String(rs.getString(1));
            }
            int pos = body.indexOf("<IMG alt=");
            while(pos!=-1){
                pos = body.indexOf("?fileid=",pos);
                int endpos = body.indexOf("\"",pos);
                String tmpid = body.substring(pos+8,endpos);
                int startpos = body.lastIndexOf("\"",pos);
                String servername = request.getServerName();
                String tmpcontent = body.substring(0,startpos+1);
                tmpcontent += "http://"+servername;
                tmpcontent += body.substring(startpos+1);
                body=tmpcontent;
                pos = body.indexOf("<IMG alt=",endpos);
            }
            rs.executeProc("HrmCareerApply_SelectById",""+applyid);
            rs.next();

            hr.put("HRM_Email",""+rs.getString("email"));

            subject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
            body = Util.toScreen(Util.fillValuesToString(body,hr),user.getLanguage()) ;
            int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"2") ;
            sendok = SendMail.sendhtmlProxy(temId,to,Util.fromScreen2(subject,user.getLanguage()),body,tempto2) ;
            succeed = to ;
        }
		response.sendRedirect("HrmMailMerge.jsp?isclose=1");
		return;
    }
}
if(!succeed.equals("")) succeed = succeed.substring(0,succeed.length()-1);
boolean gotoWindowParent = (id!=0&&id!=(-1));
if (sendok) {
%>
<script>
    //alert("系统提示：<%=succeed%>邮件发送成功!");
    if(<%=gotoWindowParent%> && <%=fromPage.length()>0%>){
    	window.location = decodeURIComponent("<%=fromPage%>");
    }else{
    	//window.location = "<%=nextpageur1%>";
		window.close();
    }
</script>
<%
} else {
%>
<script>
    //alert("系统提示：<%=succeed%>邮件发送失败!");
    if(<%=gotoWindowParent%> && <%=fromPage.length()>0%>){
    	window.location = decodeURIComponent("<%=fromPage%>");
    }else{
    	//window.location = "<%=nextpageur1%>";
		window.close();
    }
</script>
<%
}
%>