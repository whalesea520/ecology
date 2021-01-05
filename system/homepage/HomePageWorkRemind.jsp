<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();

Calendar newsnow = Calendar.getInstance();
String today=Util.add0(newsnow.get(Calendar.YEAR), 4) +"-"+
	Util.add0(newsnow.get(Calendar.MONTH) + 1, 2) +"-"+
        Util.add0(newsnow.get(Calendar.DAY_OF_MONTH), 2) ;
int year=newsnow.get(Calendar.YEAR);
int month=newsnow.get(Calendar.MONTH);
int day=newsnow.get(Calendar.DAY_OF_MONTH);
newsnow.clear();
newsnow.add(Calendar.DATE, -1);

String sql="";
int userid=user.getUID();
String resourceid = ""+user.getUID();
boolean islight=true;
%>

<table class=ListStyle id=tblReport cellspacing=1>
    <tbody> 
    <tr class=Header> 
      <th><%=SystemEnv.getHtmlLabelName(1037,user.getLanguage())%></th>
    </tr>
	<tr>
		<td>

		<!--工作提醒-->
	    <table class=ListStyle cellspacing=1>
	        <col width=45%><col width=45%><col width=10%>
		
<%
    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String nowdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String nowtime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
    String now=nowdate+" "+nowtime;
    if((RecordSet.getDBType()).equals("oracle")) {
        sql="select * from bill_HrmTime where ((concat(concat(enddate,' '),endtime)>='"+now+"' and (enddate<>'' and enddate is not null)) "+
                " or ( enddate >='"+nowdate+"' and (endtime='' or endtime is null)))"+
                " and ((wakedate<='"+now+"' and (wakedate<>'' and wakedate is not null))"+
                " or ((wakedate='' or wakedate is null) and  to_char(to_date(concat(concat(enddate,' '),endtime),'YYYY-MM-DD HH24:MI:SS')-1 , 'YYYY-MM-DD HH24:MI:SS')<='"+now+"')"+
                " or ((wakedate='' or wakedate is null) and  to_char(to_date(concat(concat(begindate,' '),begintime),'YYYY-MM-DD HH24:MI:SS')-1 , 'YYYY-MM-DD HH24:MI:SS')<='"+now+"') and concat(concat(begindate,' '),begintime)>='"+now+"')"+
                " and status='0' and concat(concat(',',TO_CHAR(accepterid)),',') like '%"+(","+resourceid+",")+"%'"+
                " and isremind=1"+
                " order by wakedate ,waketime desc" ;
    }
    else {
        sql="select * from bill_HrmTime where (((enddate+' '+endtime)>='"+now+"' and (enddate<>'' and enddate is not null)) "+
                " or ( enddate >='"+nowdate+"' and (endtime='' or endtime is null)))"+
                " and ((wakedate<='"+now+"' and (wakedate<>'' and wakedate is not null))"+
                " or ((wakedate='' or wakedate is null) and dateadd(day,-1,convert(smalldatetime,enddate+' '+endtime))<='"+now+"')"+
                " or ((wakedate='' or wakedate is null) and dateadd(day,-1,convert(smalldatetime,begindate+' '+begintime))<='"+now+"') and (begindate+' '+begintime)>='"+now+"')"+
                " and status='0' and (','+CONVERT(varchar(2000), accepterid)+',') like '%"+(","+resourceid+",")+"%'"+
                " and isremind=1"+
                " order by wakedate ,waketime desc" ;
    }
    islight=true;
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        String tmpid=RecordSet.getString("id");
        String tmprequestid=RecordSet.getString("requestid");
        String tmpbasictype=RecordSet.getString("basictype");
        String tmpdetailtype=RecordSet.getString("detailtype");
        String tmpname=RecordSet.getString("name");
        String tmpenddate=RecordSet.getString("enddate");
        String tmpendtime=RecordSet.getString("endtime");
        String tmpbegindate=RecordSet.getString("begindate");
        String tmpbegintime=RecordSet.getString("begintime");
        String tmptypename="";
        String tmpurl="";
        if(tmpbasictype.equals("3")){
            rs.executeSql("select currentnodetype from workflow_requestbase where requestid="+tmprequestid+" and currentnodetype<>'0'");
            if(!rs.next())  continue;
            tmptypename= SystemEnv.getHtmlLabelName(15090,user.getLanguage()) ;
            tmpurl="<a href='/workflow/request/ViewRequest.jsp?requestid="+tmprequestid+"'  target='mainFrame'>";
        }
        if(tmpbasictype.equals("1")){
            tmptypename= SystemEnv.getHtmlLabelName(841,user.getLanguage()) ;
            tmpurl="<a href='/proj/plan/ViewTask.jsp?taskrecordid"+tmprequestid+"' target='mainFrame'>";
        }
        if(tmpbasictype.equals("5")){
            tmptypename= SystemEnv.getHtmlLabelName(15091,user.getLanguage()) ;
            tmpurl="<a href='/meeting/data/ViewMeeting.jsp?meetingid="+tmprequestid+"' target='mainFrame'>";
        }
%>
        <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
            <td><%=tmptypename%></td>
            <td><%=tmpurl%><%=Util.toScreen(tmpname,user.getLanguage())%></a></td>
            <td><%=tmpbegindate%> <%=tmpbegintime%> <%if(tmpbegindate.equals("tmpenddate")){%> - <%=tmpenddate%><%}%> <%=tmpendtime%></td>
            <td><a href="/systeminfo/WorkRemandOperation.jsp?src=delete&type=time&paraid=<%=tmpid%>" 
            onclick="return isdel()"><img src="/images/BacoDelete_wev8.gif" width="16" height="16" border="0"></a></td>
        </tr>        
<%        
    }
    int isfinance=0;
    RecordSet.executeSql("select * from hrmrolemembers where resourceid="+userid+" and roleid=35");
    if(RecordSet.next()){
    	isfinance=1;  //判断当前用户是否为出纳
    }
    if((RecordSet.getDBType()).equals("oracle")) {
        sql="select * from bill_hrmfinance where "+
                " to_char(to_date(returndate,'YYYY-MM-DD')-1 , 'YYYY-MM-DD')<='"+nowdate+"'"+
                " and status='1' and basictype=3 and isremind=1";
    }
    else {
        sql="select * from bill_hrmfinance where "+
                " dateadd(day,-1,convert(smalldatetime,returndate))<='"+nowdate+"'"+
                " and status='1' and basictype=3 and isremind=1";
    }
    if(isfinance==0){
        sql+=" and resourceid="+userid;
    }
    sql+=" order by returndate";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        String tmpid=RecordSet.getString("id");
        String tmprequestid=RecordSet.getString("requestid");
        String tmpbasictype=RecordSet.getString("basictype");
        String tmpdetailtype=RecordSet.getString("detailtype");
        String tmpname=RecordSet.getString("name");
        String tmpreturndate=RecordSet.getString("returndate");
        String tmptypename="";
        String tmpurl="";
        tmptypename= SystemEnv.getHtmlLabelName(15092,user.getLanguage()) ;
        tmpurl="<a href='/workflow/request/ViewRequest.jsp?requestid="+tmprequestid+"'>";
        
%>
        <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
			<td><%=tmpreturndate%></td>
            <td><%=tmpurl%><%=Util.toScreen(tmpname,user.getLanguage())%></a></td>            
            <td><a href="/systeminfo/WorkRemandOperation.jsp?src=delete&type=finance&paraid=<%=tmpid%>" 
            onclick="return isdel()"><img src="/images/BacoDelete_wev8.gif" width="16" height="16" border="0"></a></td>
        </tr>        
<%  
    }
%>
	    </table>	

		</td>
	</tr>
</table>

</body>
</html>