<%@ page import="weaver.general.Util,weaver.file.*,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ExcelParse" class="weaver.file.ExcelParse" scope="page" />
<jsp:useBean id="FileManage" class="weaver.file.FileManage" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%

// 存放没有对应用户的信息
ArrayList theusercodes = new ArrayList() ;
ArrayList thedates = new ArrayList() ;
ArrayList thecardtimes = new ArrayList() ;


FileUploadToPath fu = new FileUploadToPath(request) ;    // 非压缩上传
String filename = fu.uploadFiles("excelfile") ;


if(!filename.equals("")) {

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

    ExcelParse.init( filename ) ;
    int recordercount = 0 ;
    while( true ) {
        recordercount ++ ;
        String usercode = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "1" ) ).trim() ;
        String date = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "2" ) ).trim() ;
        String thecardtime = Util.null2String( ExcelParse.getValue("1", ""+recordercount , "3" ) ).trim() ;

        //标题行
        if( recordercount == 1 ) continue ;

        if( usercode.equals("") &&  date.equals("") && thecardtime.equals("") ) break ;

        // 对日期进行处理
        String[] reportdates = Util.TokenizerString2(date, "-") ;
        if(reportdates.length!=3) continue ;
        String reportyear = Util.add0(Util.getIntValue(reportdates[0]), 4) ;
        String reportmonth = Util.add0(Util.getIntValue(reportdates[1]), 2) ;
        String reportday = Util.add0(Util.getIntValue(reportdates[2]), 2) ;
        date = reportyear + "-" + reportmonth + "-" + reportday ;

        // 对时间进行处理
        String[] reporttimes = Util.TokenizerString2(thecardtime, ":") ;
        if(reporttimes.length!=2) continue ;
        String reporthour = Util.add0(Util.getIntValue(reporttimes[0]), 2) ;
        String reportmin = Util.add0(Util.getIntValue(reporttimes[1]), 2) ;
        thecardtime = reporthour + ":" + reportmin ;
        
        // 对应的resourceid ， 如果没有， 加入没有对应用户的队列
        int usercodeindex = usercodes.indexOf(usercode) ;
        if( usercodeindex == -1 ) {
            theusercodes.add( usercode ) ;
            thedates.add( date ) ;
            thecardtimes.add( thecardtime ) ;
            continue ;
        }

        String resourceid = (String) resourceids.get( usercodeindex ) ;

        char separator = Util.getSeparator() ;
        String para = resourceid +separator+ date +separator+ thecardtime +separator + "0" ;
        RecordSet.executeProc("HrmRightCardInfo_Insert",para);
    }

    FileManage.DeleteFile( filename ) ;
}

if( theusercodes.size() < 1 ) {
    response.sendRedirect("HrmInTimecard.jsp");
    return;
}
%>
     
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16700,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",HrmInTimecard.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="50%">
  <COL width="30%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(16701,user.getLanguage())%></TH></TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(16702,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(16703,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="3" ></TD></TR>
<% 
boolean isLight = false ; 

for ( int i = 0 ; i< theusercodes.size() ; i++ ) { 
    String	usercode = ( String) theusercodes.get(i) ; 
    String	date = ( String) thedates.get(i) ; 
    String	thecardtime = ( String) thecardtimes.get(i) ; 

    isLight = !isLight ;
%> 
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
       <TD><%=usercode%></TD> 
       <TD><%=date%></TD> 
       <TD><%=thecardtime%></TD> 
      </TR>
<% } %>
</TBODY>
</TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
</BODY>
</HTML>