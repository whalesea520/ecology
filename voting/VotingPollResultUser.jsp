
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
String votingid=Util.fromScreen(request.getParameter("votingid"),user.getLanguage());
String hrmid=Util.fromScreen(request.getParameter("hrmid"),user.getLanguage());

RecordSet.executeProc("Voting_SelectByID",votingid);
RecordSet.next();
String subject=RecordSet.getString("subject");
String detail=RecordSet.getString("detail");

ArrayList selectoptionids=new ArrayList();
RecordSet.executeSql("select optionid from votingresource where resourceid="+hrmid);
while(RecordSet.next()){
    selectoptionids.add(RecordSet.getString("optionid"));
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps></DIV>
<div>
<BUTTON class=Btn accessKey=C onclick="window.close()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(15033,user.getLanguage())%></BUTTON>
</div>
<table class=form>
<col width=15%><col width=35%><col width=15%><col width=35%>
  <TR class=separator>
    <TD class=Sep1 colSpan=4></TD></TR>
  <tr>
    <td colspan=4 align=center><font size=5 color=blue>
    <%=Util.toScreen(subject,user.getLanguage())%></font>
    </td>
  </tr>
  <tr>
    <td colspan=4>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=Util.toScreen(detail,user.getLanguage())%>
    </td>
  </tr>
</table>
<br>
<table class=ListShort>
<col width=25%><col width=55%><col width=10%><col width=10%>
  <TR class=Section>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(18606,user.getLanguage())%>(<%=ResourceComInfo.getResourcename(hrmid)%>)</TH>
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
  <tr class=datadark>
    <td>
<%
    rs.executeProc("VotingOption_SelectByQuestion",questionid);
    int count=1 ;
    while(rs.next()){
        String optionid=rs.getString("id");
        String o_desc=rs.getString("description");
        int o_count = rs.getInt("optioncount");
        if(selectoptionids.indexOf(optionid)!=-1){
%>
    (<%=count%>)<%=o_desc%>&nbsp;&nbsp;&nbsp;&nbsp;
<%   
        }
        count++;
    }
%>    
    </td>
  </tr> 
<%
    rs.executeSql("select otherinput from votingresourceremark where questionid="+questionid+" and resourceid="+hrmid);
    rs.next();
    String q_remark = rs.getString(1);
    if(!q_remark.equals("")){
%>  
  <tr class=datadark>
    <td>
    <%=SystemEnv.getHtmlLabelName(18603,user.getLanguage())%>:<%=q_remark%>
    </td>
  </tr>
<%
    }
}
%>
</table>
</body>
</html>    