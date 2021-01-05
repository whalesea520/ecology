
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.* , java.io.* , weaver.general.Util,weaver.file.*" %>
<%@ page import="weaver.general.SendMail" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id="SendMail" class="weaver.general.SendMail" scope="page" />
<jsp:useBean id="HrmKqSystemComInfo" class="weaver.hrm.schedule.HrmKqSystemComInfo" scope="page" />
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />

<%
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;
String result = Util.null2String(request.getParameter("cardData")) ; //打卡机数据
String errMsg = Util.null2String(request.getParameter("cardError")) ; //与打卡机相关的错误代码
String subject = "" ; //邮件的主题（采用ISO8859编码格式）

String countindex = Util.null2String(request.getParameter("countindex")) ;

String defmailserver = Util.null2String(SystemComInfo.getDefmailserver()) ;
String defmailfrom = Util.null2String(SystemComInfo.getDefmailfrom()) ;
String defneedauth = Util.null2String(SystemComInfo.getDefneedauth()) ;
String defmailuser = Util.null2String(SystemComInfo.getDefmailuser()) ;
String defmailpassword = Util.null2String(SystemComInfo.getDefmailpassword()) ;
String tosomeone = Util.null2String(HrmKqSystemComInfo.getTosomeone()) ;



if(!errMsg.equals("")) { //打卡机的错误
    //将errMsg所对应的错误赋给subject
    if(errMsg.equals("-1")){
        subject = SystemEnv.getHtmlLabelName(129098, user.getLanguage()) ; 
    }else if(errMsg.equals("-2")){
        subject = SystemEnv.getHtmlLabelName(129099, user.getLanguage()) ; 
    }else if(errMsg.equals("-3")){ 
        subject = SystemEnv.getHtmlLabelName(129100, user.getLanguage()) ; 
    }else if(errMsg.equals("-4")){ 
        subject = SystemEnv.getHtmlLabelName(129102, user.getLanguage()) ; 
    }else if(errMsg.equals("-5")){ 
        subject = SystemEnv.getHtmlLabelName(129103, user.getLanguage()) ; 
    }else if(errMsg.equals("-6")){ 
        subject = SystemEnv.getHtmlLabelName(129104, user.getLanguage()) ; 
    }else if(errMsg.equals("-7")){ 
        subject = SystemEnv.getHtmlLabelName(129105, user.getLanguage()) ; 
    }else if(errMsg.equals("-8")){ 
        subject = SystemEnv.getHtmlLabelName(129106, user.getLanguage()) ; 
    } else if(errMsg.equals("-9")){ 
        subject = SystemEnv.getHtmlLabelName(129107, user.getLanguage()) ; 
    } else if(errMsg.equals("-10")) { 
        subject = SystemEnv.getHtmlLabelName(129108, user.getLanguage()) ; 
    }else if(errMsg.equals("-11")){ 
        subject = SystemEnv.getHtmlLabelName(129109, user.getLanguage()) ; 
    }else if(errMsg.equals("-12")){ 
        subject = SystemEnv.getHtmlLabelName(129110, user.getLanguage()) ; 
    }else if(errMsg.equals("-13")){ 
        subject = SystemEnv.getHtmlLabelName(129111, user.getLanguage()) ; 
    }else if(errMsg.equals("-14")){ 
        subject = SystemEnv.getHtmlLabelName(129112, user.getLanguage()) ; 
    }else if(errMsg.equals("-15")){
        subject = SystemEnv.getHtmlLabelName(129113, user.getLanguage()) ; 
    }else if(errMsg.equals("-16")){
        subject = SystemEnv.getHtmlLabelName(129114, user.getLanguage()) ; 
    }else if(errMsg.equals("-17")){
        subject = SystemEnv.getHtmlLabelName(129115, user.getLanguage()) ; 
    }

    SendMail.setMailServer(defmailserver) ;
    if( defneedauth.equals("1") ) {
        SendMail.setNeedauthsend(true) ;
        SendMail.setUsername(defmailuser) ;
        SendMail.setPassword(defmailpassword) ;
    }
    else SendMail.setNeedauthsend(false) ;

    if( !tosomeone.equals("") ) {
        String to = tosomeone ; //邮件的收件人 
        String cc = "" ; //邮件的抄送人

        String bcc = "" ; //邮件的暗送人
        String body = SystemEnv.getHtmlLabelName(129116, user.getLanguage()) + subject ; //邮件的正文（采用ISO8859编码格式）
        String priority = "4" ; // 邮件的重要性参数 3：普通 2：重要 4：紧急
        SendMail.send(defmailfrom , to , cc , bcc , subject , body , priority) ; 

        response.sendRedirect("HrmDataCollect.jsp?MSG=ERR&countindex="+countindex) ; 
        return ;
    }

} else {
    // 找出对应用户列表存入缓存
    ArrayList resourceids = new ArrayList() ;
    ArrayList usercodes = new ArrayList() ;

    RecordSet.executeSql("select * from HrmTimecardUser ") ;
    while ( RecordSet.next() ) {
        String resourceid = Util.null2String(RecordSet.getString("resourceid")) ;
        String usercode = Util.null2String(RecordSet.getString("usercode")) ;
        resourceids.add( resourceid ) ;
        usercodes.add( usercode ) ;
    }

    StringTokenizer st = new StringTokenizer(result , ",") ; 
    String s = "" ; 
    boolean issuccess = true ; 
    while(st.hasMoreTokens()){
        s = (st.nextToken()).trim() ;      
        if( s.length() < 28 ) continue ;

        char separator = Util.getSeparator() ; 

        String workshift = s.substring(16 , 17) ; //班组
        String stationid = s.substring(1 , 3) ; //卡钟的台号
        String Cardid = s.substring(23 , 28) ; //卡号

/*        String Cardid = s.substring(24 , 28) ; //卡号
        Cardid = "" + Integer.parseInt( Cardid ,16) ;  // 将16进制转换为10进制  */
        String tempdate = s.substring(3 , 11) ; 
        String temptime = s.substring(11 , 15) ; 

        String carddate = tempdate.substring(0 , 4) + "-" + 
                          tempdate.substring(4 , 6) + "-" +
                          tempdate.substring(6 , 8) ;      //打卡日期，格式：yyyy-mm-dd
       
        String cardtime = temptime.substring(0 , 2) + ":" + 
                          temptime.substring(2 , 4) ;      //打卡时间，格式：hh:nn
        String procedurepara = stationid + separator + carddate + separator + cardtime + separator + workshift + separator + Cardid  ; 

        issuccess = RecordSet.executeProc("HrmCardInfo_Insert" , procedurepara) ; //判断存储过程是否正确执行
        
        int usercodeindex = usercodes.indexOf(Cardid) ;
        if( usercodeindex == -1 ) {
            RecordSet.executeProc("HrmValidateCardInfo_Insert" , procedurepara) ; 
        }
        else {
            
            String resourceid = (String) resourceids.get( usercodeindex ) ;
            procedurepara = resourceid +separator+ carddate +separator+ cardtime +separator + "0" ;
            RecordSet.executeProc("HrmRightCardInfo_Insert",procedurepara);

            /*      
            String resourceid = (String) resourceids.get( usercodeindex ) ;
            procedurepara = resourceid +separator+ carddate +separator+ cardtime +separator+ cardtime ;
            RecordSet.executeProc("HrmTimecardInfo_Update",procedurepara);
            */
        }
    } 

    if(issuccess==true) { 
        response.sendRedirect("HrmDataCollect.jsp?MSG=OK&countindex="+countindex) ; 
        return ;
    } else { //存储过程错误 
      
        SendMail.setMailServer(defmailserver) ;
        if( defneedauth.equals("1") ) {
            SendMail.setNeedauthsend(true) ;
            SendMail.setUsername(defmailuser) ;
            SendMail.setPassword(defmailpassword) ;
        }
        else SendMail.setNeedauthsend(false) ;

        if( !tosomeone.equals("") ) {
            subject = SystemEnv.getHtmlLabelName(129117, user.getLanguage()) ; //邮件的主题（采用ISO8859编码格式）
            String to = tosomeone ; //邮件的收件人 
            String cc = "" ; //邮件的抄送人

            String bcc = "" ; //邮件的暗送人
            String body = SystemEnv.getHtmlLabelName(129116, user.getLanguage()) + subject ; //邮件的正文（采用ISO8859编码格式）
            String priority = "4" ; // 邮件的重要性参数 3：普通 2：重要 4：紧急
            SendMail.send(defmailfrom , to , cc , bcc , subject , body , priority) ; 

            response.sendRedirect("HrmDataCollect.jsp?MSG=ERR&countindex="+countindex) ;
            return ;
        }
    } 
}
%>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<TITLE>数据采集</TITLE>
</HEAD>
<BODY>
<script language=javascript>
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129116, user.getLanguage()) %> <%=subject%> ") ;
    location.href="HrmDataCollect.jsp?MSG=ERR&countindex=<%=countindex%>" ;
</script>
</body>
</html>
