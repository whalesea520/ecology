<%@ page import="weaver.general.Util,
                 weaver.conn.RecordSet" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%!
    /**
     * Add By Charoes Huang on May 19,2004
     * @param user
     * @param planid
     * @param inviteid
     * @return
     */
    private boolean hasRightToViewDetail(User user,String planid,String inviteid){
        boolean hasRight = false;
        String sqlStr ="";
        sqlStr = "Select Count(*) AS COUNT FROM HrmCareerPlan WHERE id ="+planid+" and (principalid = "+user.getUID()+" or informmanid="+user.getUID()+")";
        RecordSet rs = new RecordSet();
        rs.executeSql(sqlStr);
        if(rs.next()){
            if(rs.getInt("COUNT")>0 ) hasRight = true;
        }
        sqlStr = "Select Count(*) AS COUNT FROM HrmCareerInviteStep WHERE inviteid ="+inviteid+" and assessor ="+user.getUID();
        rs.executeSql(sqlStr);
         if(rs.next()){
            if(rs.getInt("COUNT")>0 ) hasRight = true;
        }
        return hasRight;
    }
%>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

int isplan = Util.getIntValue(request.getParameter("isplan"),0);
String planid = Util.null2String(request.getParameter("plan"));

char separator = Util.getSeparator() ;
boolean canedit = HrmUserVarify.checkUserRight("HrmCareerInviteEdit:Edit", user) ;
String paraid = Util.null2String(request.getParameter("paraid")) ;
String careerinviteid = paraid ;

RecordSet.executeProc("HrmCareerInvite_SelectById",careerinviteid);
RecordSet.next();

String careerpeople = Util.null2String(RecordSet.getString("careerpeople"));
String careerage = Util.null2String(RecordSet.getString("careerage"));
String careersex = Util.null2String(RecordSet.getString("careersex"));
String careeredu = Util.null2String(RecordSet.getString("careeredu"));

String careermode = Util.null2String(RecordSet.getString("careermode"));
String careername = Util.toScreen(RecordSet.getString("careername"),user.getLanguage());
String careeraddr = Util.toScreen(RecordSet.getString("careeraddr"),user.getLanguage());
String careerclass = Util.toScreen(RecordSet.getString("careerclass"),user.getLanguage());

String careerdesc = Util.toScreen(RecordSet.getString("careerdesc"),user.getLanguage());
String careerrequest = Util.toScreen(RecordSet.getString("careerrequest"),user.getLanguage());
String careerremark = Util.toScreen(RecordSet.getString("careerremark"),user.getLanguage());

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(366,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1863,user.getLanguage())+",/hrm/career/HrmCareerApplyAdd.jsp?careerid="+careerinviteid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM name=frmain action=HrmCareerInviteOperation.jsp? method=post>
<input class=inputstyle type="hidden" name="operation" value="editcareerinvite">
<input class=inputstyle type="hidden" name="careerinviteid" value="<%=careerinviteid%>">
  <table class=ViewForm>
    <colgroup> 
    <col width="49%">
    <col width="49%"> 
    <tbody> 
    <tr> 
      <td valign=top> 
        <table width="100%">
          <colgroup> 
    <col width=15%> 
    <col width=85%>
    <tbody> 
          <tr class=Title> 
            <th colspan=2 >
              <div align="left"><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></div>
            </th>
          </tr>
   
          <tr class= Spacing style="height:2px"> 
            <td class=line1 colspan=2></td>
          </tr>
		  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td ><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></td>
            <td class=Field ><%=JobTitlesComInfo.getJobTitlesname(careername)%>
	    </td>
          </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1864,user.getLanguage())%></td>
            <td class=Field> <%=careerpeople%>
            </td>
          </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1865,user.getLanguage())%></td>
            <td class=Field><%=careerclass%>
            </td>
          </tr>
-->          
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></td>
            <td class=Field><%=UseKindComInfo.getUseKindname(careermode)%>
            </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(419,user.getLanguage())%></td>
            <td class=Field> <%=careeraddr%>
            </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
         </tbody> 
        </table>
      </td>
      <td valign=top> 
        <table width="100%" class="ViewForm">
          <colgroup> <col width=15%> <col width=85%> <tbody> 
          <tr class=Title> 
            <th colspan=2>
              <div align="left"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></div>
            </th>
          </tr>
		  <tr class= Spacing style="height:2px"> 
            <td class="Line1" colspan=2></td>
          </tr>
		   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td width><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></td>
      <TD width=35% class=field>
		<%if (careersex.equals("0")){%><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%><%}%>
		<%if (careersex.equals("1")){%><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%><%}%>
		<%if (careersex.equals("2")){%><%=SystemEnv.getHtmlLabelName(763,user.getLanguage())%><%}%>
		</TD>
            </td>
          </tr>
		   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></td>
            <td class=Field> <%=careerage%>
            </td>
          </tr>
		   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></td>
      <TD width=40% class=field>
		<%if (careeredu.equals("0")){%><%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%><%}%>
		<%if (careeredu.equals("1")){%><%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%><%}%>
		<%if (careeredu.equals("2")){%><%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%><%}%>
		<%if (careeredu.equals("3")){%><%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%><%}%>
		<%if (careeredu.equals("4")){%><%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%><%}%>
		<%if (careeredu.equals("5")){%><%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%><%}%>
		<%if (careeredu.equals("6")){%><%=SystemEnv.getHtmlLabelName(763,user.getLanguage())%><%}%>
		</TD>
          </tr>
		   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          </tbody> 
        </table>
      </td>
    </tr>
    <tr> 
      <td  colspan="2"> 
<TABLE class=ViewForm>
          <TBODY> 
          <TR class=Title> 
            <TH><%=SystemEnv.getHtmlLabelName(1858,user.getLanguage())%></TH>
          </TR>
		  <TR class= Spacing style="height:2px"> 
            <TD class="Line1"></TD>
          </TR>
         
		   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
            <TD vAlign=top class="Field"> <%=careerdesc%>
            </TD>
          </TR>
		  <TR style="height:1px"><TD class=Line ></TD></TR> 
          </TBODY> 
        </TABLE>
       <TABLE class=ViewForm>
          <TBODY> 
          <TR class=Title> 
            <TH>
              <p><%=SystemEnv.getHtmlLabelName(1868,user.getLanguage())%></p>
              </TH>
          </TR>
	      <TR class= Spacing style="height:2px"> 
            <TD class="Line1"></TD>
          </TR>
		   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD vAlign=top  class="Field"> <%=careerrequest%>
            </TD>
          </TR>
		  <TR style="height:1px"><TD class=Line ></TD></TR> 
          </TBODY> 
        </TABLE>
		<TABLE class=ViewForm>
          <TBODY> 
          <TR class=Title> 
            <TH><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
          </TR>
	      <TR class= Spacing style="height:2px"> 
            <TD class="Line1"></TD>
          </TR>
		   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD vAlign=top class="Field"> <%=careerremark%>
            </TD>
          </TR>
		  <TR style="height:1px"><TD class=Line ></TD></TR>
          </TBODY>
        </TABLE>

 <%if(hasRightToViewDetail(user,planid,paraid)){%>
        <TABLE class="ListStyle">
            <TR class="Header" align="right">
                <TH colspan=4><%=SystemEnv.getHtmlLabelName(15720,user.getLanguage())%></TH>
            </TR>
            <tr class=Header>
                <td ><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
                <td ><%=SystemEnv.getHtmlLabelName(15722,user.getLanguage())%></td>
                <td ><%=SystemEnv.getHtmlLabelName(15723,user.getLanguage())%></td>
                <td ><%=SystemEnv.getHtmlLabelName(15721,user.getLanguage())%></td>
	        </tr>
          
            <%
                 String sql = "select * from HrmCareerInviteStep where inviteid = "+paraid + " order by id " ;
                 RecordSet.executeSql(sql);
                while(RecordSet.next()){
                    String stepstartdate = Util.null2String(RecordSet.getString("startdate"));
                    String stependdate = Util.null2String(RecordSet.getString("enddate"));
                    String stepname = Util.null2String(RecordSet.getString("name"));
                    String assessor = Util.null2String(RecordSet.getString("assessor"));
                    String assessstartdate = Util.null2String(RecordSet.getString("assessstartdate"));
                    String assessenddate = Util.null2String(RecordSet.getString("assessenddate"));
                    String informdate = Util.null2String(RecordSet.getString("informdate"));
            %>
                 <tr>
                    <TD class=Field>
                        <div>
                           <%=stepname%>
                        </div>
                    </TD>
                       <TD class=Field>
                        <div>
                           <%=stepstartdate%>
                        </div>
                    </TD>
                       <TD class=Field>
                        <div>
                           <%=stependdate%>
                        </div>
                    </TD>
                       <TD class=Field>
                        <div>
                           <%=ResourceComInfo.getResourcename(assessor)%>
                        </div>
                    </TD>
                 </tr>
            <%}%>
        </TABLE>
    <%}%>

      </td>
    </tr>
    </tbody>
  </table>
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>
function doback(){
    if(<%=isplan%>==1){
       location='/hrm/career/careerplan/HrmCareerPlanEdit.jsp?id=<%=planid%>' 
    }else{
        if(<%=isplan%>==2){
            location='/hrm/career/careerplan/HrmCareerPlanEditDo.jsp?id=<%=planid%>' 
        }else{
            location='/hrm/career/HrmCareerInvite.jsp'
        }
    }
}
</script>
</BODY>
</HTML>