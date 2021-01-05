<%@ page import="weaver.general.Util" %> 
<%@ page import="weaver.file.*" %> 
<%@ page import="java.util.*" %> 

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="HrmCareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="session" />
<jsp:useBean id="CareerInviteComInfo" class="weaver.hrm.career.CareerInviteComInfo" scope="page"/>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="session" />
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<HTML>
<HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<%
String planid = Util.null2String(request.getParameter("plan"));
String sqlwhere="";

sqlwhere=HrmCareerApplyComInfo.FormatSQLSearch(user.getLanguage());

if(!planid.equals("")){

}

String sqlstr = "";
if(sqlwhere.equals("")){           
    if(!planid.equals("")){  
        sqlstr = "select * from HrmCareerApply ,HrmCareerApplyOtherInfo,HrmCareerInvite where HrmCareerApplyOtherInfo.applyid=HrmCareerApply.id and careerinviteid = HrmCareerInvite.id and HrmCareerInvite.careerplanid="+planid;
    }else{
        sqlstr = "select * from HrmCareerApply ,HrmCareerApplyOtherInfo  where HrmCareerApplyOtherInfo.applyid = HrmCareerApply.id";
    }
}else{
    if(!planid.equals("")){
        sqlstr = "select * from HrmCareerApply ,HrmCareerApplyOtherInfo,HrmCareerInvite "+sqlwhere+" and HrmCareerApplyOtherInfo.applyid = HrmCareerApply.id and careerinviteid = HrmCareerInvite.id and HrmCareerInvite.careerplanid="+planid;
    }else{
        sqlstr = "select * from HrmCareerApply ,HrmCareerApplyOtherInfo "+sqlwhere+" and HrmCareerApplyOtherInfo.applyid = HrmCareerApply.id";
    }
}

RecordSet.executeSql(sqlstr);//得出页面记录

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(773,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",/hrm/report/careerapply/HrmRpCareerApplySearch.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
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
<FORM NAME=frmain action="" method=post>
<%   
   ExcelFile.init ();
   String filename = Util.toScreen(""+SystemEnv.getHtmlLabelName(83538,user.getLanguage()),user.getLanguage(),"0");
   ExcelFile.setFilename(""+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(""+filename) ;
   
   ExcelRow er = null ;
   er = et.newExcelRow() ;
   er.addStringValue(SystemEnv.getHtmlLabelName(195,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(15671,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(1844,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(15673,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(15931,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(1855,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(416,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(464,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(15683,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(469,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(818,user.getLanguage()),"Header") ;
   er.addStringValue(SystemEnv.getHtmlLabelName(1837,user.getLanguage()),"Header") ;   
%>   
    <TABLE class=ListStyle cellspacing=1 >
        <TBODY>
        <TR class=Header>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(773,user.getLanguage())%></TH>
        </TR>
        </TBODY>
    </TABLE>
    <TABLE class=ListStyle cellspacing=1 >
        <THEAD>
        <COLGROUP>
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
            <COL width="8%">
        <TR class=Header>        
            <TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(15673,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(15931,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(1855,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></TH>            
            <TH><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></TH>
        </TR>
        <TR class=Line><TD colspan="12" ></TD></TR> 
        </THEAD>
<%
    boolean islight=true;
    int totalline=1;
    while(RecordSet.next()){
        ExcelRow erdep = et.newExcelRow() ;         
        String lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
        String jobtitle = Util.toScreen(JobTitlesComInfo.getJobTitlesname(RecordSet.getString("jobtitle")),user.getLanguage());        
        String worktime = Util.toScreen(RecordSet.getString("worktime"),user.getLanguage());
        String salaryneed = Util.toScreen(RecordSet.getString("salaryneed"),user.getLanguage());
        int category = Util.getIntValue(RecordSet.getString("category"));
        String categorystr = "";
             if(category==0){ 
                categorystr = SystemEnv.getHtmlLabelName(134,user.getLanguage());
             }
             if(category==1){ 
                categorystr = SystemEnv.getHtmlLabelName(1830,user.getLanguage());
             }
             if(category==2){ 
                categorystr = SystemEnv.getHtmlLabelName(1831,user.getLanguage());
             }
             if(category==3){ 
                categorystr = SystemEnv.getHtmlLabelName(1832,user.getLanguage());
             }             
        String createdate = Util.toScreen(RecordSet.getString("createdate"),user.getLanguage());        
        String sex = Util.null2String(RecordSet.getString("sex")) ; 
        String sexstr = "";
        if (sex.equals("0")) sexstr = SystemEnv.getHtmlLabelName(417,user.getLanguage());
        if (sex.equals("1")) sexstr = SystemEnv.getHtmlLabelName(418,user.getLanguage());
        String applydate = Util.null2String(RecordSet.getString("createdate")) ;
        String regresidentplace = Util.toScreen(RecordSet.getString("regresidentplace"),user.getLanguage());
        int MaritalStatus = Util.getIntValue(RecordSet.getString("MaritalStatus"));
        String MaritalStatusstr = "";
        if(MaritalStatus==0){ 
            MaritalStatusstr = SystemEnv.getHtmlLabelName(470,user.getLanguage());
        }
        if(MaritalStatus==1){ 
            MaritalStatusstr = SystemEnv.getHtmlLabelName(471,user.getLanguage());
        }
        String educationlevel = Util.null2String(RecordSet.getString("educationlevel")) ; 
        String edulevel = Util.toScreen(EduLevelComInfo.getEducationLevelname(educationlevel),user.getLanguage());
        String policy = Util.toScreen(RecordSet.getString("policy"),user.getLanguage());
        
        erdep.addStringValue(lastname);
        erdep.addStringValue(jobtitle);
        erdep.addStringValue(worktime);
        erdep.addStringValue(salaryneed);
        erdep.addStringValue(categorystr);
        erdep.addStringValue(createdate);
        erdep.addStringValue(sexstr);
        erdep.addStringValue(applydate);
        erdep.addStringValue(regresidentplace);
        erdep.addStringValue(MaritalStatusstr);
        erdep.addStringValue(edulevel);
        erdep.addStringValue(policy);        
%>
        <tr <%if(islight){%> class=datalight <%}else {%> class=datadark <%}%>>            
            <TD>
                <A HREF="/hrm/career/HrmCareerApplyEdit.jsp?applyid=<%=RecordSet.getString("id")%>"><%=lastname%></A>
            </TD>
            <td><%=jobtitle%></td>
            <td><%=worktime%></td>
            <td><%=salaryneed%></td>
            <td><%=categorystr%></td>
            <td><%=createdate%></td>
            <TD><%=sexstr%></TD>
            <TD><%=applydate%></TD>
            <TD><%=regresidentplace%></TD>
            <TD><%=MaritalStatusstr%></TD>
            <TD><%=edulevel%></TD>
            <TD><%=policy%></TD>            
        </tr>
<%
    islight=!islight;       
    }
%>
</TABLE>
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
</BODY>
</HTML>
