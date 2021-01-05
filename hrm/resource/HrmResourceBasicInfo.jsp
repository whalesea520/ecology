
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="JobtitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobCallComInfo" class="weaver.hrm.job.JobCallComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<html>
<%
 int hrmid = user.getUID();
 String id = Util.null2String(request.getParameter("id"));
 if(id.equals("")){
   id = ""+hrmid;
 } 
 
 int isView = 0;
 
 int userdepartmentid = user.getUserDepartment();
 
 String sql = "";
 boolean ism = ResourceComInfo.isManager(hrmid,id);
 boolean iss = ResourceComInfo.isSysInfoView(hrmid,id);
 boolean isf = ResourceComInfo.isFinInfoView(hrmid,id);
 boolean isc = ResourceComInfo.isCapInfoView(hrmid,id); 
 boolean issup = ResourceComInfo.isSuperviser(hrmid,id);
// boolean iscre = ResourceComInfo.isCreaterOfResource(hrmid,id);
 boolean ishe = (hrmid == Util.getIntValue(id));
 boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,userdepartmentid)); 
 
 boolean isfin = ResourceComInfo.isFinish(id); 
%>
<head>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(61,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(ishr||ishe){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
 if(ishe||ishr){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewBasicInfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
 }
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

<FORM name=resourcebasicinfo id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<%
   sql = "";
  sql = "select * from HrmResource where id = "+id;  
  rs.executeSql(sql);
  while(rs.next()){
    String workcode = Util.null2String(rs.getString("workcode"));
    String lastname = Util.null2String(rs.getString("lastname"));
    String titleid = Util.null2String(rs.getString("titleid"));
    String sex = Util.null2String(rs.getString("sex"));
    String photoid = Util.null2String(rs.getString("resourceimageid"));    
    String departmentid = Util.null2String(rs.getString("departmentid"));
    String costcenterid = Util.null2String(rs.getString("costcenterid"));
    String jobtitle = Util.null2String(rs.getString("jobtitle"));
    String joblevel = Util.null2String(rs.getString("joblevel"));
    String jobactivitydesc = Util.null2String(rs.getString("jobactivitydesc"));
    String managerid = Util.null2String(rs.getString("managerid"));
    String assistantid = Util.null2String(rs.getString("assistantid"));
    String status = Util.null2String(rs.getString("status"));
    String locationid = Util.null2String(rs.getString("locationid"));
    String workroom = Util.null2String(rs.getString("workroom"));
    String telephone = Util.null2String(rs.getString("telephone"));
    String mobile = Util.null2String(rs.getString("mobile"));
    String mobilecall = Util.null2String(rs.getString("mobilecall"));
    String fax = Util.null2String(rs.getString("fax"));
    String email = Util.null2String(rs.getString("email"));
    String jobcall = Util.null2String(rs.getString("jobcall"));  
    int systemlanguage = Util.getIntValue(rs.getString("systemlanguage"),7);     
%>
<TABLE class=viewForm width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top width="50%"> 
    
  <TABLE class=viewForm>
    <COLGROUP> 
      <COL width="49%"> 
      <COL width=10> 
      <COL width="49%"> <TBODY> 
      <TR> 
      <TD vAlign=top> 
      
        <TABLE width="100%">
          <COLGROUP> 
            <COL width=10%> 
            <COL width=40%><TBODY> 
          <TR class=title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=workcode%>
            </TD>
          </TR>
            <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=lastname%>
            </TD>
          </TR>
            <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
            <TD class=Field>
              <%if(sex.equals("0")){%><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%><%}%>             
              <%if(sex.equals("1")){%><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%><%}%>                           
            </TD>
          </TR>   
         <TR><TD class=Line colSpan=2></TD></TR>                 
          <TR> 
            <TD height=><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
            <TD class=Field >               
              <%=DepartmentComInfo.getDepartmentname(departmentid)%>
            </TD>
          </TR> 
          <TR><TD class=Line colSpan=2></TD></TR> 
<!--                   
          <TR> 
            <TD height=>成本中心</TD>
            <TD class=Field >               
              <%=CostcenterComInfo.getCostCentername(costcenterid)%>
            </TD>
          </TR>
-->          
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
            <TD class=Field>
              <%=JobtitlesComInfo.getJobTitlesname(jobtitle)%>
            </TD>
          </TR>
              <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></TD>
            <TD class=Field>              
              <%=JobCallComInfo.getJobCallname(jobcall)%>
            </TD>
          </TR>    
              <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></td>
            <td class=Field> 
              <%=joblevel%>
            </td>
          </tr>	
              <TR><TD class=Line colSpan=2></TD></TR> 
	  <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15708,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=jobactivitydesc%>
            </TD>
          </TR>
              <TR><TD class=Line colSpan=2></TD></TR> 
	  <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></TD>
<%
 sql = "select lastname from HrmResource where id = "+managerid;
rs2.executeSql(sql);
while(rs2.next()){
%>
            <TD class=Field>             
              <%=rs2.getString(1)%>
            </TD>
<%}%>
          </TR>
          <TR> 
            <TD id=lblAss><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></TD>            
            <TD class=Field>             
<%
 sql = "select lastname from HrmResource where id = "+assistantid;
rs2.executeSql(sql);
while(rs2.next()){
%>            
              <%=rs2.getString(1)%>            
<%}%>
            

            </TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
            <TD class=Field> 
              <%if(status.equals("0")){%><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%><%}%>
              <%if(status.equals("1")){%><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%><%}%>
              <%if(status.equals("2")){%><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%><%}%>
              <%if(status.equals("3")){%><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%><%}%>
              <%if(status.equals("4")){%><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%><%}%>
              <%if(status.equals("5")){%><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%><%}%>
              <%if(status.equals("6")){%><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%><%}%>              
              <%if(status.equals("7")){%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%><%}%>              
            </TD>
          </TR>          
          <TR> 
            <TD id=lblLocation><%=SystemEnv.getHtmlLabelName(16074,user.getLanguage())%></TD>
            <TD class=Field id=txtLocation>
            <%=LocationComInfo.getLocationname(locationid)%>
            </TD>
          </TR>
          <tr> 
            <td id=lblRoom><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></td>
            <td class=Field id=txtRoom> 
              <%=workroom%>
            </td>          
          </tr>
          <TR>             
            <TD><%=SystemEnv.getHtmlLabelName(661,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=telephone%>
            </TD>
          </TR>          
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=mobile%>
            </TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=mobilecall%>
            </TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=fax%>
            </TD>
          </TR> 
<%if(isMultilanguageOK){%>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></TD>
            <TD class=Field>               
                <%=LanguageComInfo.getLanguagename(""+systemlanguage)%>               
            </TD>
          </TR>     
<%}%>				
          </TBODY> 
        </TABLE>
        <TD width="1%"></TD>
        <TD vAlign=top width="49%"> 
        <table width="100%">               
          <TR class=title> 
            <TH><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colspan=1>
           </TD>
           <TR>
            <TD class=Field> 
              <% if(!photoid.equals("") && !photoid.equals("0")) {%>
              <img border=0 width=400 src="/weaver/weaver.file.FileDownload?fileid=<%=photoid%>">
              <% } %>
            </TD>
          </TR> 
       </table>
<%
}
%>        
     </td>
    </TR>
</table>      
</FORM>
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
 <script language=javascript>
  function viewBasicInfo(){        
      location = "/hrm/employee/EmployeeManage.jsp?hrmid=<%=id%>";    
  }
  function viewPersonalInfo(){    
    location = "/hrm/resource/HrmResourcePersonalView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewFinanceInfo(){    
    location = "/hrm/resource/HrmResourceFinanceView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewWorkInfo(){    
    location = "/hrm/resource/HrmResourceWorkView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewSystemInfo(){    
    location = "/hrm/resource/HrmResourceSystemView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewCapitalInfo(){
    location = "/cpt/search/CptMyCapital.jsp?id=<%=id%>";
  }
  function edit(){	  
    if(<%=ishr%>){
      location = "/hrm/resource/HrmResourceBasicEdit.jsp?id=<%=id%>&isView=<%=isView%>";  
    }else{
        if(<%=ishe%> ){
          location = "/hrm/resource/HrmResourceContactEdit.jsp?id=<%=id%>&isView=<%=isView%>";  
        }
    }
  }
  function finish(){
   	if(confirm("<%=SystemEnv.getHtmlLabelName(15810,user.getLanguage())%>")){
   	  if(<%=isfin%>){
        document.resourcebasicinfo.operation.value="finish";
        document.resourcebasicinfo.submit();
      }else{
        if(confirm("<%=SystemEnv.getHtmlLabelName(15811,user.getLanguage())%>")){
          document.resourcebasicinfo.operation.value="finish";
          document.resourcebasicinfo.submit();
        }
      }  
    }
  }
</script> 
</body>
</html>