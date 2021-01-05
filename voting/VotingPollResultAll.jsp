<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = Util.toScreen(SystemEnv.getHtmlLabelName(17599,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(84096,user.getLanguage()),user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";

boolean islight=true ;
String userid=user.getUID()+"";
String votingid=Util.fromScreen(request.getParameter("votingid"),user.getLanguage());

RecordSet.executeProc("Voting_SelectByID",votingid);
RecordSet.next();
String subject=RecordSet.getString("subject");
String detail=RecordSet.getString("detail");
String createrid=RecordSet.getString("createrid");
String createdate=RecordSet.getString("createdate");
String createtime=RecordSet.getString("createtime");
String begindate=RecordSet.getString("begindate");
String begintime=RecordSet.getString("begintime");
String enddate=RecordSet.getString("enddate");
String endtime=RecordSet.getString("endtime");
String isanony=RecordSet.getString("isanony");
String docid=RecordSet.getString("docid");
String crmid=RecordSet.getString("crmid");
String projectid=RecordSet.getString("projid");
String requestid=RecordSet.getString("requestid");
int votingcount = RecordSet.getInt("votingcount");
String status = RecordSet.getString("status");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps></DIV>

<form name=frmmain action="VotingPollOperation.jsp" method=post>
<input type=hidden name=method value="polledit">
<input type=hidden name=votingid value="<%=votingid%>">
<div>
<BUTTON class=BtnReset accessKey=B onclick="location.href='VotingPollResult.jsp?votingid=<%=votingid%>'"><U>B</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>
</div>
<table class=form>
<col width=15%><col width=35%><col width=15%><col width=35%>
  <TR class=Section>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
  <TR class=separator>
    <TD class=Sep1 colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(24096,user.getLanguage())%></td>
    <td class=field>
    <%=Util.toScreen(subject,user.getLanguage())%>
    </td>
    <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
    <td class=field><%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%>
    </td>
  </tr>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
    <td class=field>
    <a href="/docs/docs/DocDsp.jsp?id=<%=docid%>" target="_blank"><%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%></a>
    </td>
    <td><%=SystemEnv.getHtmlLabelName(32375,user.getLanguage())%></td>
    <td>
    <input type=checkbox name="useranony" value="1" <%if(isanony.equals("1")){%> checked <%}%>disabled >
    </td>
  </tr>
  <tr>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></td>
    <td class=field colspan=3>
    <%=Util.toScreen(detail,user.getLanguage())%>
    </td>
  </tr>
</table>

<br>

<table class=ListShort>
<col width=25%><col width=55%><col width=10%><col width=10%>
  <TR class=Section>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(18606,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(83698,user.getLanguage())%> <%=votingcount%> <%=SystemEnv.getHtmlLabelNames("18608",user.getLanguage())%>)</TH>
    <th><a href="votingpollremark.jsp?votingid=<%=votingid%>" target="_blank"><%=SystemEnv.getHtmlLabelName(18613,user.getLanguage())%></a></th>
  </TR>
  <TR class=separator>
    <TD class=Sep1 colSpan=4></TD></TR>
<%
RecordSet.executeProc("VotingQuestion_SelectByVoting",votingid);
while(RecordSet.next()){
    String questionid=RecordSet.getString("id");
    String q_subject=RecordSet.getString("subject");
    String q_description=RecordSet.getString("description");
    String q_ismulti=RecordSet.getString("ismulti");
    String q_isother=RecordSet.getString("isother");
    int q_count = RecordSet.getInt("questioncount");
%>
  <tr class=datalight>
    <td colspan=4><b><%=q_subject%></b><%if(!q_description.equals("")){%>(<%=q_description%>)<%}%></td>
  </tr>
<%
    rs.executeProc("VotingOption_SelectByQuestion",questionid);
    int count=1 ;
    while(rs.next()){
        String optionid=rs.getString("id");
        String o_desc=rs.getString("description");
        int o_count = rs.getInt("optioncount");
        float percent=0;
        percent = (float)((o_count*1000)/votingcount)/10 ;
        String classgraph = "";
        if((count%4)==1) classgraph = "redgraph";
        if((count%4)==2) classgraph = "bluegraph";
        if((count%4)==3) classgraph = "greengraph";
        if((count%4)==0) classgraph = "yellowgraph";
%>
  <tr class=datadark>  
    <td>  
    <%=count%>.<%=o_desc%>
    </td>
    <td>
        <%if(percent>0){%>
        <TABLE height="100%" cellSpacing=0 width="100%"><TBODY>
        <TR>
          <TD class=<%=classgraph%> <%if(percent<=1){%>width="1%"<%}else{%>width="<%=percent%>%" <%}%>>&nbsp;</TD>
          <TD>&nbsp;</TD>
        </TR>
        </TBODY></TABLE>
        <%} else {%>
        &nbsp;
        <%}%>
    </td>
    <td><%=percent%>%</td>
    <td><%=o_count%><%=SystemEnv.getHtmlLabelName(18607,user.getLanguage())%></td>
  </tr>     
  <tr class=datalight>
    <td colspan=4>&nbsp;&nbsp;&nbsp;&nbsp;<img border=0 src="/images/ArrowRightBlue_wev8.gif"></img><%=SystemEnv.getHtmlLabelName(18610,user.getLanguage())%>:   
<%   
        String sql="select distinct t1.resourceid,t2.useranony "+
                   "from votingresource t1,votingremark t2 where "+
                   "t1.optionid="+optionid+" and t1.votingid=t2.votingid and t1.resourceid=t2.resourceid";
        rs1.executeSql(sql);
        while(rs1.next()){
            String tmpuserid = rs1.getString("resourceid");
            String tmpanony = rs1.getString("useranony");
%>
  
  <%if(tmpanony.equals("1")){%><%=SystemEnv.getHtmlLabelName(84096,user.getLanguage())%>,<%}%>
  <%if(tmpanony.equals("0")){%><%=ResourceComInfo.getResourcename(tmpuserid)%>,<%}%>
<%            
        }
%>
    </td>  
  </tr>
<%        
        count++;
    }
}
%>
</table>
</form>
</body>
</html>