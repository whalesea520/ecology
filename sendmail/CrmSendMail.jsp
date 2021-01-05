
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 java.sql.Timestamp" %>

<jsp:useBean id="SendMail" class="weaver.general.SendMail" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<jsp:useBean id="hr" class="java.util.Hashtable" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
String CRM_SearchWhere = CRMSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
String CRM_SearchSql =  "";

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

if(user.getLogintype().equals("1")){
    CRM_SearchSql = "select distinct t1.id from CRM_CustomerInfo  t1,"+leftjointable+" t2 "+ CRM_SearchWhere +" and t1.id = t2.relateditemid ";
}else{
    CRM_SearchSql = "select t1.id from CRM_CustomerInfo  t1 "+ CRMSearchComInfo.FormatSQLSearch(user.getLanguage())+" and t1.agent="+user.getUID();
}
String[] choice = request.getParameterValues("choice");
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);  //对客户发群件定位到具体页
int customerid = Util.getIntValue(request.getParameter("customerid"),0);//对某一客户发信时
int mailid = Util.getIntValue(request.getParameter("mailid"),0);//版式ID
int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);//调查种类ID
String selfComment=Util.fromScreen(request.getParameter("selfComment"),user.getLanguage());//用户自输入邮件正文内容
String subject = Util.null2String(request.getParameter("subject")); //主题
String from = Util.null2String(request.getParameter("from"));  //发件人Email地址
String issearch = Util.null2String(request.getParameter("issearch"));
int sendto = Util.getIntValue(request.getParameter("sendto"));//发送到


//add by wjy
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


String sql = "" ;
String to = "" ;               //邮件的收件人参数
String cc = "" ;              //邮件的抄送人参数
String bcc = "" ;            //邮件的暗送人参数
int char_set = 3 ;          //编码方式 1：iso-8859-1 2：big5 3：GBK
String priority = "3" ;    //邮件的重要性参数 3：普通 2：重要 4：紧急
String tempto = "";

String tempto2 = "";    //临时变量，记录收件人的id

boolean sendok = false;
String succeed = "" ;
String tosucceed = "" ;
String  nextpageur1 = "" ;
Calendar todaycal = Calendar.getInstance ();
String reportdate = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
String inprepname = "" ;
String contactid = "" ;
String crmid = "" ;
String contacterid = "" ;
String inpreptablename = "" ;
String inputid = "" ;


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

ArrayList crmids = new ArrayList() ;
ArrayList contacterids = new ArrayList() ;
sql = "select crmid,contacterid from T_FadeBespeak where inprepid="+inprepid ;
rs.executeSql(sql) ;
while(rs.next()){
    crmid = rs.getString("crmid") ;
    contacterid = rs.getString("contacterid") ;
    if(!crmid.equals("")&&!crmid.equals("0"))
    crmids.add(crmid) ;
    if(!contacterid.equals("")&&!contacterid.equals("0"))
    contacterids.add(contacterid) ;
}

if (mailid==0 && inprepid==0) {     //不采用版式时而在文本框输入信件内容的情况
	if(issearch.equals("1")){
        nextpageur1="/CRM/search/SearchResult.jsp?pagenum="+pagenum;
        if(sendto==1){
            sql= "select distinct t1.id,t1.email from CRM_CustomerInfo  t1,"+leftjointable+" t2 "+ CRM_SearchWhere +" and t1.id = t2.relateditemid";
            rs.executeSql(sql) ;
            int i = 0 ;
            to = "" ;
            String body = selfComment ;
            int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"5") ;
            while(rs.next()){
                customerid = Util.getIntValue(rs.getString(1),0) ;
                if(!Util.contains(choice, ""+customerid))  continue;

                tempto = Util.null2String(rs.getString(2)) ;
                if( !tempto.equals("") && Util.isEmail(tempto)) {
                    to = tempto;
                    sendok = SendMail.sendhtmlProxy(temId,to,Util.fromScreen2(subject,user.getLanguage()),body,customerid+"") ;
                }
            }
        }
        else if(sendto==2){
            sql = " select t1.id,t2.email,t2.id as cid from CRM_CustomerInfo t1,CRM_CustomerContacter t2"+
                  " where t2.main=1 and t1.id in("+CRM_SearchSql+") and t2.customerid = t1.id " ;
            rs.executeSql(sql) ;
            int i = 0 ;
            to = "" ;
            while(rs.next()){
                customerid = Util.getIntValue(rs.getString(1),0) ;
                if(!Util.contains(choice, ""+customerid))  continue;

                tempto = Util.null2String(rs.getString(2)) ;
                tempto2 = Util.null2String(rs.getString(3)) ;

                if( !tempto.equals("") && Util.isEmail(tempto)) {
                    to = tempto;
                    String body = selfComment ;
                    int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"6") ;
                    sendok = SendMail.sendhtmlProxy(temId,to,Util.fromScreen2(subject,user.getLanguage()),body,tempto2) ;
                }
            }
        }
        else if(sendto==3){
            sql=" select t1.id,t2.email,t2.id as cid from CRM_CustomerInfo t1,CRM_CustomerContacter t2"+
                " where t1.id in("+CRM_SearchSql+")and t2.customerid = t1.id " ;
            rs.executeSql(sql) ;
            int i = 0 ;
            to = "" ;
            while(rs.next()){
                customerid = Util.getIntValue(rs.getString(1),0) ;
                if(!Util.contains(choice, ""+customerid))  continue;

                tempto = Util.null2String(rs.getString(2)) ;
                tempto2 = Util.null2String(rs.getString(3)) ;
                if( !tempto.equals("") && Util.isEmail(tempto)) {
                    to = tempto ;
                    String body = selfComment ;
                    int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"6") ;
                    sendok = SendMail.sendhtmlProxy(temId,to,Util.fromScreen2(subject,user.getLanguage()),body,tempto2) ;
                    succeed += to ;
                }
            }
        }
    }
    else if(customerid!=0){
        String toType = "5";
        to = "";
        nextpageur1="/CRM/data/ViewCustomer.jsp?CustomerID="+customerid;
        if(sendto==1){
            sql = "select email,id from CRM_CustomerInfo where id="+customerid ;
            rs.executeSql(sql) ;
            if(rs.next()) {
                tempto = Util.null2String(rs.getString("email")) ;
                tempto2 = Util.null2String(rs.getString("id")) ;
                toType = "5";
            }
            if( !tempto.equals("") && Util.isEmail(tempto)) to = tempto;
		}
        else if(sendto==2){
            sql = " select email,id from CRM_CustomerContacter where customerid ="+customerid+ " and"+       " main=1 " ;
            rs.executeSql(sql) ;
            if(rs.next()) {
                tempto = Util.null2String(rs.getString("email")) ;
                tempto2 = Util.null2String(rs.getString("id")) ;
                toType = "6";
            }
            if( !tempto.equals("") && Util.isEmail(tempto)) to = tempto;
        }
        else if(sendto==3){
            sql=" select email,id from CRM_CustomerContacter where customerid="+customerid ;
            rs.executeSql(sql) ;
            int i = 0 ;
            to = "" ;
            while(rs.next()){
                tempto = Util.null2String(rs.getString(1)) ;
                tempto2 = Util.null2String(rs.getString(2)) ;

                if( !tempto.equals("") && Util.isEmail(tempto)){
                    to = tempto;
                    String body = selfComment ;
                    int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"6") ;
                    sendok = SendMail.sendhtmlProxy(temId,to,Util.fromScreen2(subject,user.getLanguage()),body,tempto2) ;
                }
            }
        }
        if(to.length()!=0) {
            String body = selfComment ;
            int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,toType) ;
            sendok = SendMail.sendhtmlProxy(temId,to,Util.fromScreen2(subject,user.getLanguage()),body,tempto2) ;
            succeed += to ;
        }
	}
}
else if(mailid !=0 && inprepid==0 ){    //采用邮件版式时

    if(issearch.equals("1")){
        nextpageur1="/CRM/search/SearchResult.jsp?pagenum="+pagenum;
        String subject1 = subject;
        String body = "";
        sql = "select mouldtext from DocMailMould where id = "+mailid;
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
        if(sendto != 1){
            if(sendto==2){
                sql = " select t2.* from CRM_CustomerInfo t1,CRM_CustomerContacter t2"+
                      " where t2.main=1 and t1.id in("+CRM_SearchSql+")and t2.customerid = t1.id " ;
                rs.executeSql(sql) ;
            }
            if(sendto==3){
                sql="  select t2.* from CRM_CustomerInfo t1,CRM_CustomerContacter t2"+
                    "  where t1.id in("+CRM_SearchSql+")and t2.customerid = t1.id " ;
                rs.executeSql(sql) ;
            }
            int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"6") ;
            while(rs.next()){
                customerid = Util.getIntValue(rs.getString("customerid"),0) ;
                if(!Util.contains(choice, ""+customerid))  continue;

                tempto = Util.null2String(rs.getString("email")) ;
                tempto2 = Util.null2String(rs.getString("id")) ;
                if( !tempto.equals("") && Util.isEmail(tempto)) {
                    to = tempto ;
                    hr.put("Cont_title",Util.toScreen(ContacterTitleComInfo.getContacterTitlename(rs.getString("title")),user.getLanguage()));
                    hr.put("Cont_language",""+rs.getString("language"));
                    hr.put("Cont_fullname",""+rs.getString("fullname"));
                    hr.put("Cont_jobtitle",""+rs.getString("jobtitle"));
                    hr.put("Cont_email",""+rs.getString("email"));
                    hr.put("Cont_phoneoffice",""+rs.getString("phoneoffice"));
                    hr.put("Cont_phonehome",""+rs.getString("phonehome"));
                    hr.put("Cont_mobilephone",""+rs.getString("mobilephone"));
                    hr.put("Cont_fax",""+rs.getString("fax"));
                    hr.put("Cont_manager",""+rs.getString("manager"));
                    String tempbody = Util.toScreen(Util.fillValuesToString(body,hr),user.getLanguage()) ;
                    String tempsubject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
                    sendok = SendMail.sendhtmlProxy(temId,to,Util.fromScreen2(subject,user.getLanguage()),body,tempto2);
                    if(sendok){
                        succeed = succeed + to + "," ;
                    }
                    else{
                        tosucceed = tosucceed + to + "," ;
                    }

                }
            }
        }
        else  {
            sql= " select distinct t1.* from CRM_CustomerInfo  t1,"+leftjointable+" t2 "+ CRM_SearchWhere +
                 " and t1.id = t2.relateditemid";
            rs.executeSql(sql) ;

            int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"5") ;
            while(rs.next()){
                customerid = Util.getIntValue(rs.getString("id"),0) ;
                if(!Util.contains(choice, ""+customerid))  continue;

                tempto = Util.null2String(rs.getString("email")) ;
                tempto2 = Util.null2String(rs.getString("id")) ;
                if( !tempto.equals("") && Util.isEmail(tempto)) {
                    to = tempto ;
                    hr.put("Cust_name",""+rs.getString("name"));
                    hr.put("Cust_language",""+rs.getString("language"));
                    hr.put("Cust_engname",""+rs.getString("engname"));
                    hr.put("Cust_address1",""+rs.getString("address1"));
                    hr.put("Cust_zipcode",""+rs.getString("zipcode"));
                    hr.put("Cust_city",""+rs.getString("city"));
                    hr.put("Cust_country",""+rs.getString("country"));
                    hr.put("Cust_province",""+rs.getString("province"));
                    hr.put("Cust_county",""+rs.getString("county"));
                    hr.put("Cust_phone",""+rs.getString("phone"));
                    hr.put("Cust_fax",""+rs.getString("fax"));
                    hr.put("Cust_email",""+rs.getString("email"));
                    hr.put("Cust_website",""+rs.getString("website"));
                    hr.put("Cust_source",""+rs.getString("source"));
                    hr.put("Cust_sector",""+rs.getString("sector"));
                    hr.put("Cust_size",""+rs.getString("size"));
                    hr.put("Cust_type",""+rs.getString("type"));
                    hr.put("Cust_description",""+rs.getString("description"));
                    hr.put("Cust_status",""+rs.getString("status"));
                    hr.put("Cust_rating",""+rs.getString("rating"));
                    hr.put("Cust_manager",""+rs.getString("manager"));
                    hr.put("Cust_department",""+rs.getString("department"));
                    hr.put("Cust_agent",""+rs.getString("agent"));
                    hr.put("Cust_parentid",""+rs.getString("parentid"));
                    String tempbody = Util.toScreen(Util.fillValuesToString(body,hr),user.getLanguage()) ;
                    String tempsubject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
                    sendok = SendMail.sendhtmlProxy(temId,to,tempsubject,tempbody,tempto2);
                    if(sendok){
                        succeed = succeed + to + "," ;
                    }
                    else{
                        tosucceed = tosucceed + to + "," ;
                    }
                }
            }
        }
    }
    else if(customerid!=0){
        nextpageur1="/CRM/data/ViewCustomer.jsp?CustomerID="+customerid;
        String subject1 = subject;
        String body = "";
        sql = "select mouldtext from DocMailMould where id = "+mailid;
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
        if(sendto != 1) {
            if(sendto==2){
                sql = "select * from CRM_CustomerContacter where customerid="+customerid+ " and main=1" ;
                rs.executeSql(sql) ;
            }
            if(sendto==3){
                sql = "select * from CRM_CustomerContacter where customerid="+customerid ;
                rs.executeSql(sql) ;
            }
            int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"6") ;
            while(rs.next()){
                tempto = Util.null2String(rs.getString("email")) ;
                tempto2 = Util.null2String(rs.getString("id")) ;
                if( !tempto.equals("") && Util.isEmail(tempto)) {
                    to = tempto ;
                    hr.put("Cont_title",Util.toScreen(ContacterTitleComInfo.getContacterTitlename(rs.getString("title")),user.getLanguage()));
                    hr.put("Cont_language",""+rs.getString("language"));
                    hr.put("Cont_fullname",""+rs.getString("fullname"));
                    hr.put("Cont_jobtitle",""+rs.getString("jobtitle"));
                    hr.put("Cont_email",""+rs.getString("email"));
                    hr.put("Cont_phoneoffice",""+rs.getString("phoneoffice"));
                    hr.put("Cont_phonehome",""+rs.getString("phonehome"));
                    hr.put("Cont_mobilephone",""+rs.getString("mobilephone"));
                    hr.put("Cont_fax",""+rs.getString("fax"));
                    hr.put("Cont_manager",""+rs.getString("manager"));
                    String tempbody = Util.toScreen(Util.fillValuesToString(body,hr),user.getLanguage()) ;
                    String tempsubject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
                    sendok = SendMail.sendhtmlProxy(temId,to,tempsubject,tempbody,tempto2);
                    if(sendok){
                        succeed = succeed + to + "," ;
                    }
                    else{
                        tosucceed = tosucceed + to + "," ;
                    }
                }
            }
        }
        else {
            sql = " select * from CRM_CustomerInfo where id ="+customerid ;
            rs.executeSql(sql) ;
            if(rs.next()) {
                tempto = Util.null2String(rs.getString("email")) ;
                tempto2 = Util.null2String(rs.getString("id")) ;
                if( !tempto.equals("") && Util.isEmail(tempto)) {
                    to = tempto ;
                    hr.put("Cust_name",""+rs.getString("name"));
                    hr.put("Cust_language",""+rs.getString("language"));
                    hr.put("Cust_engname",""+rs.getString("engname"));
                    hr.put("Cust_address1",""+rs.getString("address1"));
                    hr.put("Cust_zipcode",""+rs.getString("zipcode"));
                    hr.put("Cust_city",""+rs.getString("city"));
                    hr.put("Cust_country",""+rs.getString("country"));
                    hr.put("Cust_province",""+rs.getString("province"));
                    hr.put("Cust_county",""+rs.getString("county"));
                    hr.put("Cust_phone",""+rs.getString("phone"));
                    hr.put("Cust_fax",""+rs.getString("fax"));
                    hr.put("Cust_email",""+rs.getString("email"));
                    hr.put("Cust_website",""+rs.getString("website"));
                    hr.put("Cust_source",""+rs.getString("source"));
                    hr.put("Cust_sector",""+rs.getString("sector"));
                    hr.put("Cust_size",""+rs.getString("size"));
                    hr.put("Cust_type",""+rs.getString("type"));
                    hr.put("Cust_description",""+rs.getString("description"));
                    hr.put("Cust_status",""+rs.getString("status"));
                    hr.put("Cust_rating",""+rs.getString("rating"));
                    hr.put("Cust_manager",""+rs.getString("manager"));
                    hr.put("Cust_department",""+rs.getString("department"));
                    hr.put("Cust_agent",""+rs.getString("agent"));
                    hr.put("Cust_parentid",""+rs.getString("parentid"));
                    String tempbody = Util.toScreen(Util.fillValuesToString(body,hr),user.getLanguage()) ;
                    String tempsubject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
                    int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"5") ;
                    sendok = SendMail.sendhtmlProxy(temId,to,tempsubject,tempbody,tempto2);
                    if(sendok){
                        succeed = succeed + to + "," ;
                    }
                    else{
                        tosucceed = tosucceed + to + "," ;
                    }
                }
            }
        }
    }
}
else if(mailid==0 && inprepid !=0 ){   //采用调查表单
    sql = "select mailid from T_SurveyItem where inprepid="+inprepid ;
    rs.executeSql(sql) ;
    if(rs.next()) mailid = Util.getIntValue(rs.getString("mailid"),0) ;
    if(issearch.equals("1")){
        nextpageur1="/CRM/search/SearchResult.jsp?pagenum="+pagenum;
        String subject1 = subject;
        String body = "";
        sql = "select mouldtext from DocMailMould where id = "+mailid;
        rs.executeSql(sql);
        if(rs.next()){
            body = Util.null2String(rs.getString(1));
        }
        int pos = body.indexOf("<IMG");
        while(pos!=-1){
            pos = body.indexOf("src=",pos);
            int endpos = body.indexOf(">",pos);
            String middlestr = body.substring( pos , endpos ) ;
            if ( middlestr.indexOf( "weaver.file.FileDownload" ) != -1 ) {
                String bodycontent = body.substring(0,pos+5);
                bodycontent += "http://"+request.getServerName();
                bodycontent += body.substring(pos+5);
                body = bodycontent ;
                endpos = body.indexOf(">",pos);
            }
            pos = body.indexOf("<IMG",endpos);
        }
        if(sendto != 1){
            if(sendto==2){
                sql = " select t2.* from CRM_CustomerInfo t1,CRM_CustomerContacter t2"+
                      " where t2.main=1 and t1.id in("+CRM_SearchSql+")and t2.customerid = t1.id " ;
                rs.executeSql(sql) ;

            }
            if(sendto==3){
                sql="  select t2.* from CRM_CustomerInfo t1,CRM_CustomerContacter t2"+
                    "  where t1.id in("+CRM_SearchSql+")and t2.customerid = t1.id " ;
                rs.executeSql(sql) ;
            }
            sql = " INSERT INTO T_ResearchTable (inprepid,state) VALUES("+inprepid+",1)" ;
            rs2.executeSql(sql);
            sql = "select max(inputid) from T_ResearchTable where inprepid="+inprepid ;
            rs2.executeSql(sql);
            if(rs2.next())
            inputid = rs2.getString(1) ;


            ArrayList tocrmids = new ArrayList() ;
            ArrayList emails = new ArrayList() ;
            ArrayList tocontacterids = new ArrayList() ;
            int j = 0;
            int b = 0;
            while(rs.next()){
                customerid = Util.getIntValue(rs.getString("customerid"),0) ;
                contactid = rs.getString("id");
                if(!Util.contains(choice, ""+customerid))  continue;
                if(contacterids.size()!=0){
                    int contacteridindex = contacterids.indexOf(""+customerid) ;
                    if( contacteridindex == -1 ) {
                        b++;
                        tempto = Util.null2String(rs.getString("email")) ;
                        if( !tempto.equals("") && Util.isEmail(tempto)) {
                            to = tempto ;
                            tocrmids.add(""+customerid);
                            tocontacterids.add(contactid);
                            emails.add(to);

                            hr.put("Cust_crmid",""+customerid);
                            hr.put("Cust_contactid",""+rs.getString("id"));
                            hr.put("Cust_inputid",inputid);
                            hr.put("Cont_customerid",Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid")),user.getLanguage())) ;
                            hr.put("Cont_title",Util.toScreen(ContacterTitleComInfo.getContacterTitlename(rs.getString("title")),user.getLanguage()));
                            hr.put("Cont_language",""+rs.getString("language"));
                            hr.put("Cont_fullname",""+rs.getString("fullname"));
                            hr.put("Cont_jobtitle",""+rs.getString("jobtitle"));
                            hr.put("Cont_email",""+rs.getString("email"));
                            hr.put("Cont_phoneoffice",""+rs.getString("phoneoffice"));
                            hr.put("Cont_phonehome",""+rs.getString("phonehome"));
                            hr.put("Cont_mobilephone",""+rs.getString("mobilephone"));
                            hr.put("Cont_fax",""+rs.getString("fax"));
                            hr.put("Cont_manager",""+rs.getString("manager"));
                            String tempbody = Util.fromBaseEncoding(Util.fillValuesToString(body,hr),7) ;

                            String tempsubject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
                            int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"0") ;
                            sendok = SendMail.sendhtmlProxy(temId,to,tempsubject,tempbody,"0");
                            if(sendok){
                                succeed = succeed + to + "," ;
                            }
                            else{
                                tosucceed = tosucceed + to + "," ;
                            }
                            if(sendok)
                            j++;
                        }
                    }
                }
                else {
                    b++;
                    tempto = Util.null2String(rs.getString("email")) ;
                    if( !tempto.equals("") && Util.isEmail(tempto)) {
                        to = tempto ;
                        tocrmids.add(""+customerid);
                        tocontacterids.add(contactid);
                        emails.add(to);
                        hr.put("Cust_crmid",""+customerid);
                        hr.put("Cust_contactid",""+rs.getString("id"));
                        hr.put("Cust_inputid",inputid);
                        hr.put("Cont_customerid",Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid")),user.getLanguage())) ; hr.put("Cont_title",Util.toScreen(ContacterTitleComInfo.getContacterTitlename(rs.getString("title")),user.getLanguage()));
                        hr.put("Cont_language",""+rs.getString("language"));
                        hr.put("Cont_fullname",""+rs.getString("fullname"));
                        hr.put("Cont_jobtitle",""+rs.getString("jobtitle"));
                        hr.put("Cont_email",""+rs.getString("email"));
                        hr.put("Cont_phoneoffice",""+rs.getString("phoneoffice"));
                        hr.put("Cont_phonehome",""+rs.getString("phonehome"));
                        hr.put("Cont_mobilephone",""+rs.getString("mobilephone"));
                        hr.put("Cont_fax",""+rs.getString("fax"));
                        hr.put("Cont_manager",""+rs.getString("manager"));

                        String tempbody = Util.fromBaseEncoding(Util.fillValuesToString(body,hr),7) ;
                        String tempsubject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
                        int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"0") ;
                        sendok = SendMail.sendhtmlProxy(temId,to,tempsubject,tempbody,"0");

                        if(sendok){
                            succeed = succeed + to + "," ;
                        }
                        else{
                            tosucceed = tosucceed + to + "," ;
                        }
                        if(sendok)
                        j++;
                    }
                }
            }
             if(sendok ){
                sql = "select inprepname from T_SurveyItem where inprepid="+inprepid ;
                rs2.executeSql(sql) ;
                if(rs2.next()) inprepname = Util.fromScreen2(rs2.getString("inprepname"),user.getLanguage()) ;
                String rsearchname = inprepname +"~"+ reportdate;
                sql = " Update T_ResearchTable set rsearchname='"+rsearchname+"',rsearchdate='"+reportdate+"',countfrom='"+b+"',countemial='"+j+"' where inputid="+inputid ;
                rs2.executeSql(sql);
                for(int i=0; i<tocrmids.size();i++){
                    crmid = (String)tocrmids.get(i);
                    to = (String)emails.get(i);
                    contacterid = (String)tocontacterids.get(i);
                    sql = " INSERT INTO T_InceptForm (inputid,crmid,contacterid,email,state)"+
                          " VALUES ("+inputid+","+crmid+","+contacterid+",'"+to+"',1)" ;
                    rs2.executeSql(sql) ;
                }
            }
        }
        else  {
            sql= " select distinct t1.* from CRM_CustomerInfo  t1,"+leftjointable+" t2 "+ CRM_SearchWhere +
                 " and t1.id = t2.relateditemid";
            rs.executeSql(sql) ;
            int j = 0;
            int b = 0;
            ArrayList tocrmids = new ArrayList() ;
            ArrayList emails = new ArrayList() ;

            sql = " INSERT INTO T_ResearchTable (inprepid,state) VALUES("+inprepid+",0)" ;
            rs2.executeSql(sql);
            sql = "select max(inputid) from T_ResearchTable where inprepid="+inprepid ;
            rs2.executeSql(sql);
            if(rs2.next())
            inputid = rs2.getString(1) ;
            while(rs.next()){
                customerid = Util.getIntValue(rs.getString("id"),0) ;

                if(!Util.contains(choice, ""+customerid))  continue;
                if(crmids.size()!=0){
                    int crmidindex = crmids.indexOf(""+customerid ) ;
                    if( crmidindex == -1 ) {
                        b++;
                        tempto = Util.null2String(rs.getString("email")) ;
                        if( !tempto.equals("") && Util.isEmail(tempto)) {
                            to = tempto ;

                            tocrmids.add(""+customerid);
                            emails.add(to);
                            hr.put("Cust_crmid",""+rs.getString("id"));
                            hr.put("Cust_inputid",inputid);
                            hr.put("Cust_name",""+rs.getString("name"));
                            hr.put("Cust_language",""+rs.getString("language"));
                            hr.put("Cust_engname",""+rs.getString("engname"));
                            hr.put("Cust_address1",""+rs.getString("address1"));
                            hr.put("Cust_zipcode",""+rs.getString("zipcode"));
                            hr.put("Cust_city",""+rs.getString("city"));
                            hr.put("Cust_country",""+rs.getString("country"));
                            hr.put("Cust_province",""+rs.getString("province"));
                            hr.put("Cust_county",""+rs.getString("county"));
                            hr.put("Cust_phone",""+rs.getString("phone"));
                            hr.put("Cust_fax",""+rs.getString("fax"));
                            hr.put("Cust_email",""+rs.getString("email"));
                            hr.put("Cust_website",""+rs.getString("website"));
                            hr.put("Cust_source",""+rs.getString("source"));
                            hr.put("Cust_sector",""+rs.getString("sector"));
                            hr.put("Cust_size",""+rs.getString("size"));
                            hr.put("Cust_type",""+rs.getString("type"));
                            hr.put("Cust_description",""+rs.getString("description"));
                            hr.put("Cust_status",""+rs.getString("status"));
                            hr.put("Cust_rating",""+rs.getString("rating"));
                            hr.put("Cust_manager",""+rs.getString("manager"));
                            hr.put("Cust_department",""+rs.getString("department"));
                            hr.put("Cust_agent",""+rs.getString("agent"));
                            hr.put("Cust_parentid",""+rs.getString("parentid"));
                            String tempbody = Util. fromBaseEncoding(Util.fillValuesToString(body,hr),7) ;
                            String tempsubject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
                            int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"0") ;
                            sendok = SendMail.sendhtmlProxy(temId,to,tempsubject,tempbody,"0");
                            if(sendok){
                            succeed = succeed + to + "," ;
                            }
                            else{
                                tosucceed = tosucceed + to + "," ;
                            }
                            if(sendok)
                            j++;
                        }
                    }
                }
                else {
                    b++;
                    crmid = Util.null2String(rs.getString("id"));
                    tempto = Util.null2String(rs.getString("email")) ;
                    if( !tempto.equals("") && Util.isEmail(tempto)) {
                        to = tempto ;
                        tocrmids.add(crmid);
                        emails.add(to);
                        hr.put("Cust_crmid",""+rs.getString("id"));
                        hr.put("Cust_inputid",inputid);
                        hr.put("Cust_name",""+rs.getString("name"));
                        hr.put("Cust_language",""+rs.getString("language"));
                        hr.put("Cust_engname",""+rs.getString("engname"));
                        hr.put("Cust_address1",""+rs.getString("address1"));
                        hr.put("Cust_zipcode",""+rs.getString("zipcode"));
                        hr.put("Cust_city",""+rs.getString("city"));
                        hr.put("Cust_country",""+rs.getString("country"));
                        hr.put("Cust_province",""+rs.getString("province"));
                        hr.put("Cust_county",""+rs.getString("county"));
                        hr.put("Cust_phone",""+rs.getString("phone"));
                        hr.put("Cust_fax",""+rs.getString("fax"));
                        hr.put("Cust_email",""+rs.getString("email"));
                        hr.put("Cust_website",""+rs.getString("website"));
                        hr.put("Cust_source",""+rs.getString("source"));
                        hr.put("Cust_sector",""+rs.getString("sector"));
                        hr.put("Cust_size",""+rs.getString("size"));
                        hr.put("Cust_type",""+rs.getString("type"));
                        hr.put("Cust_description",""+rs.getString("description"));
                        hr.put("Cust_status",""+rs.getString("status"));
                        hr.put("Cust_rating",""+rs.getString("rating"));
                        hr.put("Cust_manager",""+rs.getString("manager"));
                        hr.put("Cust_department",""+rs.getString("department"));
                        hr.put("Cust_agent",""+rs.getString("agent"));
                        hr.put("Cust_parentid",""+rs.getString("parentid"));
                        String tempbody = Util. fromBaseEncoding(Util.fillValuesToString(body,hr),7) ;

                        String tempsubject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
                        int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"0") ;
                        sendok = SendMail.sendhtmlProxy(temId,to,tempsubject,tempbody,"0");
                        if(sendok){
                            succeed = succeed + to + "," ;
                        }
                        else{
                            tosucceed = tosucceed + to + "," ;
                        }
                        if(sendok)
                        j++;
                    }
                }
            }
            if(sendok ){
                sql = "select inprepname from T_SurveyItem where inprepid="+inprepid ;
                rs2.executeSql(sql) ;
                if(rs2.next()) inprepname = Util.fromScreen2(rs2.getString("inprepname"),user.getLanguage()) ;
                String rsearchname = inprepname +"~"+ reportdate;
                sql = " Update T_ResearchTable set rsearchname='"+rsearchname+"',rsearchdate='"+reportdate+"',countfrom='"+b+"',countemial='"+j+"' where inputid="+inputid ;
                rs2.executeSql(sql);
                for(int i=0; i<tocrmids.size();i++){
                    crmid = (String)tocrmids.get(i);
                    to = (String)emails.get(i);
                    sql = " INSERT INTO T_InceptForm (inputid,crmid,contacterid,email,state)"+
                          " VALUES ("+inputid+","+crmid+",0,'"+to+"',1)" ;
                    rs2.executeSql(sql) ;
                }
            }
        }
    }

    else if(customerid!=0){
        nextpageur1="/CRM/data/ViewCustomer.jsp?CustomerID="+customerid;
        String subject1 = subject;
        String body = "";
        sql = "select mouldtext from DocMailMould where id = "+mailid;
        rs.executeSql(sql);
        if(rs.next()){
            body = Util.null2String(rs.getString(1));
        }


        int pos = body.indexOf("<IMG alt=");
        while(pos!=-1){
           pos = body.indexOf("src=",pos);
            int endpos = body.indexOf(">",pos);
            String middlestr = body.substring( pos , endpos ) ;
            if ( middlestr.indexOf( "weaver.file.FileDownload" ) != -1 ) {
                String bodycontent = body.substring(0,pos+5);
                bodycontent += "http://"+request.getServerName();
                bodycontent += body.substring(pos+5);
                body = bodycontent ;
                endpos = body.indexOf(">",pos);
            }
            pos = body.indexOf("<IMG",endpos);
        }
        if(sendto != 1) {
            if(sendto==2){
                sql = "select * from CRM_CustomerContacter where customerid="+customerid+ " and main=1" ;
                rs.executeSql(sql) ;
            }
            if(sendto==3){
                sql = "select * from CRM_CustomerContacter where customerid="+customerid ;
                rs.executeSql(sql) ;
            }
            ArrayList tocrmids = new ArrayList() ;
            ArrayList emails = new ArrayList() ;
            ArrayList tocontacterids = new ArrayList() ;

            sql = " INSERT INTO T_ResearchTable (inprepid,state) VALUES("+inprepid+",1)" ;
            rs2.executeSql(sql);
            sql = "select max(inputid) from T_ResearchTable where inprepid="+inprepid ;
            rs2.executeSql(sql);
            if(rs2.next())
            inputid = rs2.getString(1) ;

            int j = 0;
            int b = 0;
            while(rs.next()){
                contacterid = Util.null2String(rs.getString("id"));
                if(contacterids.size()!=0){
                    int contacteridindex = contacterids.indexOf(contacterid ) ;
                    if( contacteridindex == -1 ) {
                        b++;
                        tempto = Util.null2String(rs.getString("email")) ;
                        if( !tempto.equals("") && Util.isEmail(tempto)) {
                            to = tempto ;
                            tocrmids.add(""+customerid);
                            tocontacterids.add(contacterid);
                            emails.add(to);
                            hr.put("Cust_crmid",""+customerid);
                            hr.put("Cust_contactid",""+rs.getString("id"));
                            hr.put("Cust_inputid",inputid);
                            hr.put("Cont_customerid",Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid")),user.getLanguage())) ;
                            hr.put("Cont_title",Util.toScreen(ContacterTitleComInfo.getContacterTitlename(rs.getString("title")),user.getLanguage()));
                            hr.put("Cont_language",""+rs.getString("language"));
                            hr.put("Cont_fullname",""+rs.getString("fullname"));
                            hr.put("Cont_jobtitle",""+rs.getString("jobtitle"));
                            hr.put("Cont_email",""+rs.getString("email"));
                            hr.put("Cont_phoneoffice",""+rs.getString("phoneoffice"));
                            hr.put("Cont_phonehome",""+rs.getString("phonehome"));
                            hr.put("Cont_mobilephone",""+rs.getString("mobilephone"));
                            hr.put("Cont_fax",""+rs.getString("fax"));
                            hr.put("Cont_manager",""+rs.getString("manager"));
                            String tempbody = Util. fromBaseEncoding(Util.fillValuesToString(body,hr),7) ;
                            String tempsubject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
                            int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"0") ;
                            sendok = SendMail.sendhtmlProxy(temId,to,tempsubject,tempbody,"0");
                            if(sendok){
                            succeed = succeed + to + "," ;
                            }
                            else{
                                tosucceed = tosucceed + to + "," ;
                            }
                            if(sendok)
                            j++;
                        }
                    }
                }
                else {
                    b++;
                    tempto = Util.null2String(rs.getString("email")) ;
                    if( !tempto.equals("") && Util.isEmail(tempto)) {
                        to = tempto ;
                        tocrmids.add(""+customerid);
                        tocontacterids.add(contacterid);
                        emails.add(to);
                        hr.put("Cust_crmid",""+customerid);
                        hr.put("Cust_contactid",""+rs.getString("id"));
                        hr.put("Cust_inprepid",""+inprepid);
                        hr.put("Cont_customerid",Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid")),user.getLanguage())) ;
                        hr.put("Cont_title",Util.toScreen(ContacterTitleComInfo.getContacterTitlename(rs.getString("title")),user.getLanguage()));
                        hr.put("Cont_language",""+rs.getString("language"));
                        hr.put("Cont_fullname",""+rs.getString("fullname"));
                        hr.put("Cont_jobtitle",""+rs.getString("jobtitle"));
                        hr.put("Cont_email",""+rs.getString("email"));
                        hr.put("Cont_phoneoffice",""+rs.getString("phoneoffice"));
                        hr.put("Cont_phonehome",""+rs.getString("phonehome"));
                        hr.put("Cont_mobilephone",""+rs.getString("mobilephone"));
                        hr.put("Cont_fax",""+rs.getString("fax"));
                        hr.put("Cont_manager",""+rs.getString("manager"));
                        String tempbody = Util. fromBaseEncoding(Util.fillValuesToString(body,hr),7) ;
                        String tempsubject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
                        int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"0") ;
                        sendok = SendMail.sendhtmlProxy(temId,to,tempsubject,tempbody,"0");
                        if(sendok){
                            succeed = succeed + to + "," ;
                        }
                        else{
                            tosucceed = tosucceed + to + "," ;
                        }
                        if(sendok)
                        j++;
                    }
                }
            }
            if(sendok ){
                sql = "select inprepname from T_SurveyItem where inprepid="+inprepid ;
                rs2.executeSql(sql) ;
                if(rs2.next()) inprepname = Util.fromScreen2(rs2.getString("inprepname"),user.getLanguage()) ;
                String rsearchname = inprepname +"~"+ reportdate;
                sql = " Update T_ResearchTable set rsearchname='"+rsearchname+"',rsearchdate='"+reportdate+"',countfrom='"+b+"',countemial='"+j+"' where inputid="+inputid ;
                rs2.executeSql(sql);
                for(int i=0; i<tocrmids.size();i++){
                    crmid = (String)tocrmids.get(i);
                    to = (String)emails.get(i);
                    sql = " INSERT INTO T_InceptForm (inputid,crmid,contacterid,email,state)"+
                          " VALUES ("+inputid+","+crmid+","+contacterid+",'"+to+"',1)" ;
                    rs2.executeSql(sql) ;
                }
            }
        }
        else {
            sql = " select * from CRM_CustomerInfo where id ="+customerid ;
            rs.executeSql(sql) ;
            int j = 0;
            int b = 0;
            ArrayList tocrmids = new ArrayList() ;
            ArrayList emails = new ArrayList() ;
            sql = " INSERT INTO T_ResearchTable (inprepid,state) VALUES("+inprepid+",0)" ;
            rs2.executeSql(sql);
            sql = "select max(inputid) from T_ResearchTable where inprepid="+inprepid ;
            rs2.executeSql(sql);
            if(rs2.next())
            inputid = rs2.getString(1) ;
            if(rs.next()) {
                tempto = Util.null2String(rs.getString("email")) ;
                crmid = Util.null2String(rs.getString("id"));
                if(crmids.size()!=0){
                    int crmidindex = crmids.indexOf(""+customerid) ;
                    if( crmidindex == -1 ) {
                        b++;
                        if( !tempto.equals("") && Util.isEmail(tempto)) {
                            to = tempto ;
                            tocrmids.add(crmid);
                            emails.add(to);
                            hr.put("Cust_crmid",""+rs.getString("id"));
                            hr.put("Cust_inputid",inputid);
                            hr.put("Cust_name",""+rs.getString("name"));
                            hr.put("Cust_language",""+rs.getString("language"));
                            hr.put("Cust_engname",""+rs.getString("engname"));
                            hr.put("Cust_address1",""+rs.getString("address1"));
                            hr.put("Cust_zipcode",""+rs.getString("zipcode"));
                            hr.put("Cust_city",""+rs.getString("city"));
                            hr.put("Cust_country",""+rs.getString("country"));
                            hr.put("Cust_province",""+rs.getString("province"));
                            hr.put("Cust_county",""+rs.getString("county"));
                            hr.put("Cust_phone",""+rs.getString("phone"));
                            hr.put("Cust_fax",""+rs.getString("fax"));
                            hr.put("Cust_email",""+rs.getString("email"));
                            hr.put("Cust_website",""+rs.getString("website"));
                            hr.put("Cust_source",""+rs.getString("source"));
                            hr.put("Cust_sector",""+rs.getString("sector"));
                            hr.put("Cust_size",""+rs.getString("size"));
                            hr.put("Cust_type",""+rs.getString("type"));
                            hr.put("Cust_description",""+rs.getString("description"));
                            hr.put("Cust_status",""+rs.getString("status"));
                            hr.put("Cust_rating",""+rs.getString("rating"));
                            hr.put("Cust_manager",""+rs.getString("manager"));
                            hr.put("Cust_department",""+rs.getString("department"));
                            hr.put("Cust_agent",""+rs.getString("agent"));
                            hr.put("Cust_parentid",""+rs.getString("parentid"));
                            String tempbody = Util. fromBaseEncoding(Util.fillValuesToString(body,hr),7) ;
                            String tempsubject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
                            int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"0") ;
                            sendok = SendMail.sendhtmlProxy(temId,to,tempsubject,tempbody,"0");
                            if(sendok){
                            succeed = succeed + to + "," ;
                            }
                            else{
                                tosucceed = tosucceed + to + "," ;
                            }
                            if(sendok)
                            j++;
                        }
                    }
                }
                else {
                       b++;
                       if( !tempto.equals("") && Util.isEmail(tempto)) {
                        to = tempto ;
                        tocrmids.add(crmid);
                        emails.add(to);
                        hr.put("Cust_crmid",""+rs.getString("id"));
                        hr.put("Cust_inputid",inputid);
                        hr.put("Cust_name",""+rs.getString("name"));
                        hr.put("Cust_language",""+rs.getString("language"));
                        hr.put("Cust_engname",""+rs.getString("engname"));
                        hr.put("Cust_address1",""+rs.getString("address1"));
                        hr.put("Cust_zipcode",""+rs.getString("zipcode"));
                        hr.put("Cust_city",""+rs.getString("city"));
                        hr.put("Cust_country",""+rs.getString("country"));
                        hr.put("Cust_province",""+rs.getString("province"));
                        hr.put("Cust_county",""+rs.getString("county"));
                        hr.put("Cust_phone",""+rs.getString("phone"));
                        hr.put("Cust_fax",""+rs.getString("fax"));
                        hr.put("Cust_email",""+rs.getString("email"));
                        hr.put("Cust_website",""+rs.getString("website"));
                        hr.put("Cust_source",""+rs.getString("source"));
                        hr.put("Cust_sector",""+rs.getString("sector"));
                        hr.put("Cust_size",""+rs.getString("size"));
                        hr.put("Cust_type",""+rs.getString("type"));
                        hr.put("Cust_description",""+rs.getString("description"));
                        hr.put("Cust_status",""+rs.getString("status"));
                        hr.put("Cust_rating",""+rs.getString("rating"));
                        hr.put("Cust_manager",""+rs.getString("manager"));
                        hr.put("Cust_department",""+rs.getString("department"));
                        hr.put("Cust_agent",""+rs.getString("agent"));
                        hr.put("Cust_parentid",""+rs.getString("parentid"));

                        String tempbody = Util. fromBaseEncoding(Util.fillValuesToString(body,hr),7) ;
                        String tempsubject = Util.fromScreen2(Util.fillValuesToString(subject,hr),user.getLanguage());
                        int temId = SendMail.sendhtmlMain(from,cc,bcc,char_set,priority,user,fromdate,fromtime,"0") ;
                        sendok = SendMail.sendhtmlProxy(temId,to,tempsubject,tempbody,"0");
                        if(sendok){
                            succeed = succeed + to + "," ;
                        }
                        else{
                            tosucceed = tosucceed + to + "," ;
                        }
                        if(sendok)
                        j++;
                    }
                }
            }
            if(sendok ){
                sql = "select inprepname from T_SurveyItem where inprepid="+inprepid ;
                rs2.executeSql(sql) ;
                if(rs2.next()) inprepname = Util.fromScreen2(rs2.getString("inprepname"),user.getLanguage()) ;
                String rsearchname = inprepname +"~"+ reportdate;
                sql = " Update T_ResearchTable set rsearchname='"+rsearchname+"',rsearchdate='"+reportdate+"',countfrom='"+b+"',countemial='"+j+"' where inputid="+inputid ;
                rs2.executeSql(sql);
                for(int i=0; i<tocrmids.size();i++){
                    crmid = (String)tocrmids.get(i);
                    to = (String)emails.get(i);
                    sql = " INSERT INTO T_InceptForm (inputid,crmid,contacterid,email,state)"+
                          " VALUES ("+inputid+","+crmid+",0,'"+to+"',1)" ;
                    rs2.executeSql(sql) ;
                }
            }
        }
    }
}
if(!succeed.equals("")) succeed = succeed.substring(0,succeed.length()-1);
if ( sendok) {
%>
<script>
    alert("<%=SystemEnv.getHtmlLabelName(15172,user.getLanguage())%>：<%=succeed%> <%=SystemEnv.getHtmlLabelName(2044,user.getLanguage())%>!");
    window.location = "<%=nextpageur1%>";
</script>
<%
} else {
%>
<script>
     alert("<%=SystemEnv.getHtmlLabelName(15172,user.getLanguage())%>：<%=tosucceed%> <%=SystemEnv.getHtmlLabelName(2045,user.getLanguage())%>!");
     window.location = "<%=nextpageur1%>";
</script>
<%
}
%>