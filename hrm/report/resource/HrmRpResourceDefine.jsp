<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RpResourceDefine" class="weaver.hrm.report.RpResourceDefine" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
int userid = user.getUID();

boolean issys = false;
boolean isfin = false;
boolean ishr  = false;

String sql = "select hrmid from HrmInfoMaintenance where id = 1";
rs.executeSql(sql);
while(rs.next()){
  int hrmid = Util.getIntValue(rs.getString(1));
  if(userid == hrmid){
    issys = true;
    break;
  }
}
sql = "select hrmid from HrmInfoMaintenance where id = 2";
rs.executeSql(sql);
while(rs.next()){
  int hrmid = Util.getIntValue(rs.getString(1));
  if(userid == hrmid){
    isfin = true;
    break;
  }
}
if(HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
  ishr = true;
}

int lastname=0;
int jobtitle    =0;
int jobgroup    =0;
int jobactivity =0;
int costcenterid  =0;
int status      =0;
int subcompanyid1  =0;
int departmentid  =0;
int locationid    =0;
int managerid     =0;
int assistantid   =0;
int roles       =0;
int seclevel    =0;
int joblevel    =0;
int workroom    =0;
int telephone   =0;
int startdate   =0;
int enddate     =0;
int probationenddate=0;
int birthday    =0;
int sex         =0;
int age         =0;

int workcode = 0;
int jobcall = 0;
int mobile = 0;
int mobilecall = 0;
int fax = 0;
int email = 0;
int folk = 0;
int nativeplace = 0;
int regresidentplace = 0;
int maritalstatus = 0;
int certificatenum = 0;
int tempresidentnumber = 0;
int residentplace = 0;
int homeaddress = 0;
int healthinfo = 0;
int height = 0;
int weight = 0;
int educationlevel = 0;
int degree = 0;
int usekind = 0;
int policy = 0;
int bememberdate = 0;
int bepartydate = 0;
int islabouunion = 0;
int bankid1 = 0;
int accountid1 = 0;
int accumfundaccount = 0;
int loginid = 0;
//自定义字段Begin
/*日期型Begin*/
int dff01name =0;
int dff02name =0;
int dff03name =0;
int dff04name =0;
int dff05name =0;

/*日期型End*/

/*数字型Begin*/
int nff01name = 0;
int nff02name = 0;
int nff03name = 0;
int nff04name = 0;
int nff05name = 0;
/*数字型End*/

/*文本型Begin*/
int tff01name = 0;
int tff02name = 0;
int tff03name = 0;
int tff04name = 0;
int tff05name = 0;
/*文本型End*/

/*booleanBegin*/
int bff01name = 0;
int bff02name = 0;
int bff03name = 0;
int bff04name = 0;
int bff05name = 0;
/*booleanEnd*/
//自定义字段End

Map al = RpResourceDefine.getShowOrder(userid);
	
	//add by dongping for TD1102

       workcode    =Util.getIntValue((String)al.get("workcode"),0);
       lastname    =Util.getIntValue((String)al.get("lastname"),0);
       sex         =Util.getIntValue((String)al.get("sex"),0);
       departmentid  =Util.getIntValue((String)al.get("departmentid"),0);

       subcompanyid1  =Util.getIntValue((String)al.get("subcompanyid1"),0);
       costcenterid  =Util.getIntValue((String)al.get("costcenterid"),0);
       status      =Util.getIntValue((String)al.get("status"),0);
       jobtitle    =Util.getIntValue((String)al.get("jobtitle"),0);

       jobgroup    =Util.getIntValue((String)al.get("jobgroup"),0);
       jobactivity =Util.getIntValue((String)al.get("jobactivity"),0);
       jobcall     =Util.getIntValue((String)al.get("jobcall"),0);
       joblevel    =Util.getIntValue((String)al.get("joblevel"),0);

       managerid     =Util.getIntValue((String)al.get("managerid"),0);
       assistantid   =Util.getIntValue((String)al.get("assistantid"),0);
       locationid    =Util.getIntValue((String)al.get("locationid"),0);
       workroom    =Util.getIntValue((String)al.get("workroom"),0);

       telephone   =Util.getIntValue((String)al.get("telephone"),0);
       mobile      =Util.getIntValue((String)al.get("mobile"),0);
       mobilecall  =Util.getIntValue((String)al.get("mobilecall"),0);
       fax         =Util.getIntValue((String)al.get("fax"),0);

       email       =Util.getIntValue((String)al.get("email"),0);
       birthday          =Util.getIntValue((String)al.get("birthday"),0);
       age               =Util.getIntValue((String)al.get("age"),0);
       folk              =Util.getIntValue((String)al.get("folk"),0);

       nativeplace       =Util.getIntValue((String)al.get("nativeplace"),0);
       regresidentplace  =Util.getIntValue((String)al.get("regresidentplace"),0);
       maritalstatus     =Util.getIntValue((String)al.get("maritalstatus"),0);
       certificatenum    =Util.getIntValue((String)al.get("certificatenum"),0);

       tempresidentnumber=Util.getIntValue((String)al.get("tempresidentnumber"),0);
       residentplace     =Util.getIntValue((String)al.get("residentplace"),0);
       homeaddress       =Util.getIntValue((String)al.get("homeaddress"),0);
       healthinfo        =Util.getIntValue((String)al.get("healthinfo"),0);

       height            =Util.getIntValue((String)al.get("height"),0);
       weight            =Util.getIntValue((String)al.get("weight"),0);
       educationlevel    =Util.getIntValue((String)al.get("educationlevel"),0);
       degree            =Util.getIntValue((String)al.get("degree"),0);

       usekind           =Util.getIntValue((String)al.get("usekind"),0);
       policy            =Util.getIntValue((String)al.get("policy"),0);
       bememberdate      =Util.getIntValue((String)al.get("bememberdate"),0);
       bepartydate       =Util.getIntValue((String)al.get("bepartydate"),0);

       roles             =Util.getIntValue((String)al.get("roles"),0);
       islabouunion      =Util.getIntValue((String)al.get("islabouunion"),0);
       startdate         =Util.getIntValue((String)al.get("startdate"),0);
       enddate           =Util.getIntValue((String)al.get("enddate"),0);

       probationenddate  =Util.getIntValue((String)al.get("probationenddate"),0);
       bankid1          =Util.getIntValue((String)al.get("bankid1"),0);
       accountid1       =Util.getIntValue((String)al.get("accountid1"),0);
       accumfundaccount =Util.getIntValue((String)al.get("accumfundaccount"),0);
       
       loginid  =Util.getIntValue((String)al.get("loginid"),0);
       seclevel =Util.getIntValue((String)al.get("seclevel"),0);
       
       dff01name = Util.getIntValue((String)al.get("dff01name"),0);
       dff02name = Util.getIntValue((String)al.get("dff02name"),0);
       dff03name = Util.getIntValue((String)al.get("dff03name"),0);
       dff04name = Util.getIntValue((String)al.get("dff04name"),0);
       dff05name = Util.getIntValue((String)al.get("dff05name"),0);

       nff01name = Util.getIntValue((String)al.get("nff01name"),0);
       nff02name = Util.getIntValue((String)al.get("nff02name"),0);
       nff03name = Util.getIntValue((String)al.get("nff03name"),0);
       nff04name = Util.getIntValue((String)al.get("nff04name"),0);
       nff05name = Util.getIntValue((String)al.get("nff05name"),0);

       tff01name = Util.getIntValue((String)al.get("tff01name"),0);
       tff02name = Util.getIntValue((String)al.get("tff02name"),0);
       tff03name = Util.getIntValue((String)al.get("tff03name"),0);
       tff04name = Util.getIntValue((String)al.get("tff04name"),0);
       tff05name = Util.getIntValue((String)al.get("tff05name"),0);

       bff01name = Util.getIntValue((String)al.get("bff01name"),0);
       bff02name = Util.getIntValue((String)al.get("bff02name"),0);
       bff03name = Util.getIntValue((String)al.get("bff03name"),0);
       bff04name = Util.getIntValue((String)al.get("bff04name"),0);
       bff05name = Util.getIntValue((String)al.get("bff05name"),0);


String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(343,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/report/resource/HrmRpResource.jsp,_self} " ;
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
<FORM id=weaver name=frmMain action="DefineOperation.jsp" method=post>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top width="84%">
        <TABLE class=Form width="100%">
          <COLGROUP> <COL width="40%"> <COL width="30%"> <COL width="30%"> <TBODY> 
          <TR class=Title> 
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing> 
            <TD class=Line1 colSpan=3></TD>
          </TR>
          <TR> 
            <TD vAlign=top > 
              <TABLE>          
                <tr> 
                  <td  class=Field><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
                  <td>                   
                    <input class=inputstyle type=text size=2 maxlength=2 name=workcode value=<%=workcode%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("workcode")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
                  <td>                   
                    <input class=inputstyle type=text size=2 maxlength=2 name=lastname value=<%=lastname%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("lastname")'>
                  </td>
                </tr>
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=sex value=<%=sex%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("sex")'>
                  </td>
                </tr>                
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=departmentid value=<%=departmentid%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("departmentid")'>
                  </td>
                </tr>     
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=subcompanyid1 value=<%=subcompanyid1%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("subcompanyid1")'>
                  </td>
                </tr>
                <TR><TD class=Line colSpan=2></TD></TR> 
                 <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=costcenterid value=<%=costcenterid%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("costcenterid")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=status value=<%=status%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("status")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR> 
                <%
                String dff01use = "";
                String dff02use = "";
                String dff03use = "";
                String dff04use = "";
                String dff05use = "";
                String tff01use = "";
                String tff02use = "";
                String tff03use = "";
                String tff04use = "";
                String tff05use = "";
                String nff01use = "";
                String nff02use = "";
                String nff03use = "";
                String nff04use = "";
                String nff05use = "";
                String bff01use = "";
                String bff02use = "";
                String bff03use = "";
                String bff04use = "";
                String bff05use = "";

                boolean hasFF = true;
                rs2.executeProc("Base_FreeField_Select","hr");
                if(rs2.getCounts()<=0){
                	hasFF = false;
                }else{
                	rs2.first();
                	dff01use=rs2.getString("dff01use");
                	dff02use=rs2.getString("dff02use");
                	dff03use=rs2.getString("dff03use");
                	dff04use=rs2.getString("dff04use");
                	dff05use=rs2.getString("dff05use");
                	tff01use=rs2.getString("tff01use");
                	tff02use=rs2.getString("tff02use");
                	tff03use=rs2.getString("tff03use");
                	tff04use=rs2.getString("tff04use");
                	tff05use=rs2.getString("tff05use");
                	bff01use=rs2.getString("bff01use");
                	bff02use=rs2.getString("bff02use");
                	bff03use=rs2.getString("bff03use");
                	bff04use=rs2.getString("bff04use");
                	bff05use=rs2.getString("bff05use");
                	nff01use=rs2.getString("nff01use");
                	nff02use=rs2.getString("nff02use");
                	nff03use=rs2.getString("nff03use");
                	nff04use=rs2.getString("nff04use");
                	nff05use=rs2.getString("nff05use");
                	
                }
                if(hasFF){
                	if(dff01use.equals("1")){
                %>
                	<tr> 
                  <td class=Field><%=rs2.getString("dff01name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=dff01name value=<%=dff01name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("dff01name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(dff02use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("dff02name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=dff02name value=<%=dff02name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("dff02name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(dff03use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("dff03name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=dff03name value=<%=dff03name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("dff03name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(dff04use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("dff04name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=dff04name value=<%=dff04name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("dff04name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(dff05use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("dff05name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=dff05name value=<%=dff05name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("dff05name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(tff01use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("tff01name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=tff01name value=<%=tff01name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("tff01name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(tff02use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("tff02name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=tff02name value=<%=tff02name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("tff02name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(tff03use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("tff03name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=tff03name value=<%=tff03name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("tff03name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(tff04use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("tff04name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=tff04name value=<%=tff04name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("tff04name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(tff05use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("tff05name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=tff05name value=<%=tff05name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("tff05name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(bff01use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("bff01name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=bff01name value=<%=bff01name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("bff01name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(bff02use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("bff02name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=bff02name value=<%=bff02name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("bff02name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(bff03use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("bff03name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=bff03name value=<%=bff03name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("bff03name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(bff04use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("bff04name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=bff04name value=<%=bff04name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("bff04name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(bff05use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("bff05name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=bff05name value=<%=bff05name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("bff05name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(nff01use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("nff01name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=nff01name value=<%=nff01name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff01name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(nff02use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("nff02name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=nff02name value=<%=nff02name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff02name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(nff03use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("nff03name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=nff03name value=<%=nff03name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff03name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(nff04use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("nff04name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=nff04name value=<%=nff04name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff04name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%	
                	}
                	if(nff05use.equals("1")){
                %>
                	 <tr> 
                  <td class=Field><%=rs2.getString("nff05name")%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=nff05name value=<%=nff05name%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff05name")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR>
                <%
                	}
                }
                %>
                </TBODY> 
              </TABLE>
            </TD>
            <TD valign="top" > 
              <table> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=jobtitle value=<%=jobtitle%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("jobtitle")'>
                  </td>
                </tr>     
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(15854,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=jobgroup value=<%=jobgroup%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("jobgroup")'>
                  </td>
                </tr>
                <TR><TD class=Line colSpan=2></TD></TR> 
                 <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=jobactivity value=<%=jobactivity%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("jobactivity")'>
                  </td>
                </tr>    
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=jobcall value=<%=jobcall%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("jobcall")'>
                  </td>
                </tr>                
                </tr>
                <TR><TD class=Line colSpan=2></TD></TR> 
                 <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=joblevel value=<%=joblevel%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevel")'>
                  </td>
                </tr>         
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=managerid value=<%=managerid%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("managerid")'>
                  </td>
                </tr>
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=assistantid value=<%=assistantid%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("assistantid")'>
                  </td>
                 <colgroup> <col width="40%"> <col width="60%"> <tbody> </tbody> 
              </table>
            </TD>
            <%
            if(HrmUserVarify.checkUserRight("HrmResourceSearch:Private", user)){
            %>
            <TD vAlign=top align=left > 
            <%}else{%>
            <TD vAlign=top align=left  style="display:none"> 
            <%}%>
              <TABLE>
                <COLGROUP> <COL width="80%"> <COL width="20%"> <TBODY> 
                 <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=locationid value=<%=locationid%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("locationid")'>
                  </td>
                </tr>     
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=workroom value=<%=workroom%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("workroom")'>
                  </td>
                </tr>             
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=telephone value=<%=telephone%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("telephone")'>
                  </td>
                </tr>
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=mobile value=<%=mobile%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("mobile")'>
                  </td>
                </tr>         
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=mobilecall value=<%=mobilecall%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("mobilecall")'>
                  </td>
                </tr>            
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=fax value=<%=fax%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("fax")'>
                  </td>
                </tr>
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field>E-mail</td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=email value=<%=email%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("email")'>
                  </td>
                </tr>            
                <TR><TD class=Line colSpan=2></TD></TR> 
                 </TBODY> 
              </TABLE>
            </TD>
          </TR>
<%
  if(ishr){
%>          
          <tr class=Title> 
            <th colspan=3><%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%></th>
          </tr>
          <tr class=Spacing> 
            <td class=Sep3 colspan=3></td>
          </tr>
          <tr> 
            <td valign=top align=left > 
              <table>
                <colgroup> <col width="40%"> <col width="60%"><tbody> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2  name=birthday value=<%=birthday%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("birthday")'>
                  </td>
                </tr>             
               <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2   name=age value=<%=age%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("age")'>
                  </td>
                </tr>   
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2   name=folk value=<%=folk%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("folk")'>
                  </td>
                </tr>
               <TR><TD class=Line colSpan=2></TD></TR>  
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=nativeplace value=<%=nativeplace%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nativeplace")'>
                  </td>
                </tr>
              <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=regresidentplace value=<%=regresidentplace%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("regresidentplace")'>
                  </td>
                </tr>
              <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=maritalstatus value=<%=maritalstatus%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("maritalstatus")'>
                  </td>
                </tr>         
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=certificatenum value=<%=certificatenum%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("certificatenum")'>
                  </td>
                </tr>    
               <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(15685,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=tempresidentnumber value=<%=tempresidentnumber%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("tempresidentnumber")'>
                  </td>
                </tr>
               <TR><TD class=Line colSpan=2></TD></TR>
              <%
                  CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",1);
                  cfm.getCustomFields();
                  while(cfm.next()){
                  %>
                  <tr>
                  <td class=Field><%=cfm.getLable()%></td>
                  <td>
                    <input class=inputstyle type=text size=2 maxlength=2 name=<%="field"+cfm.getId()%> value=<%=Util.getIntValue((String)al.get("field"+cfm.getId()),0)%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("probationenddate")'>
                  </td>
                </tr>
                 <% }
              %>
              <TR><TD class=Line colSpan=2></TD></TR> 
                </tbody> 
              </table>
            </td>
            <td  valign="top"> 
              <table >
                <colgroup> <col width="40%"> <col width="60%"> <tbody> 
                 <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=residentplace value=<%=residentplace%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("residentplace")'>
                  </td>
                </tr>
               <TR><TD class=Line colSpan=2></TD></TR> 
              <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(16018,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=homeaddress value=<%=homeaddress%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("homeaddress")'>
                  </td>
                </tr>
              <TR><TD class=Line colSpan=2></TD></TR> 
               <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=healthinfo value=<%=healthinfo%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("healthinfo")'>
                  </td>
                </tr>
               <TR><TD class=Line colSpan=2></TD></TR> 
		         <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=height value=<%=height%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("height")'>
                  </td>
                </tr>
                <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(15674,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=weight value=<%=weight%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("weight")'>
                  </td>
                </tr>     
              <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=educationlevel value=<%=educationlevel%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("educationlevel")'>
                  </td>
                </tr>     
              <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=degree value=<%=degree%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("degree")'>
                  </td>
                </tr>     
               <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=usekind value=<%=usekind%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("usekind")'>
                  </td>
                </tr>
               <TR><TD class=Line colSpan=2></TD></TR> 
                </tbody> 
              </table>
            </td>
            <td  valign="top"> 
              <table >
                <colgroup> <col width="40%"> <col width="60%"> <tbody> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=policy	 value=<%=policy%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("policy")'>
                  </td>
                </tr>
            <TR><TD class=Line colSpan=2></TD></TR> 
                 <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=bememberdate value=<%=bememberdate%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("bememberdate")'>
                  </td>
                </tr>        
              <TR><TD class=Line colSpan=2></TD></TR> 
               <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=bepartydate value=<%=bepartydate%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("bepartydate")'>
                  </td>
                </tr>                
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=roles value=<%=roles%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("roles")'>
                  </td>
                </tr>                
              <TR><TD class=Line colSpan=2></TD></TR>   
               <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(15684,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=islabouunion value=<%=islabouunion%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("islabouunion")'>
                  </td>
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=startdate value=<%=startdate%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("startdate")'>
                  </td>
                </tr>
              <TR><TD class=Line colSpan=2></TD></TR> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=enddate value=<%=enddate%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("enddate")'>
                  </td>
                </tr>
                <TR><TD class=Line colSpan=2></TD></TR> 
               <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(15778,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=probationenddate value=<%=probationenddate%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("probationenddate")'>
                  </td>
                </tr>
                </tbody> 
              </table>
            </td>            
            <td width="21%">&nbsp; </td>
          </tr>
<%
}
%>
<%
  if(ishr || isfin){
%>          
          <tr class=Title> 
            <th colspan=3><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%></th>
          </tr>
          <tr class=Spacing> 
            <td class=Sep3 colspan=3></td>
          </tr>
          <tr> 
            <td valign=top align=left > 
              <table >
                <colgroup> <col width="40%"> <col width="60%"> <tbody> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=bankid1 value=<%=bankid1%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("bankid1")'>
                  </td>
                </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
                </tbody> 
              </table>
            </td>
            <td  valign="top"> 
              <table >
                <colgroup> <col width="40%"> <col width="60%"> <tbody> 
               <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(16016,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=accountid1 value=<%=accountid1%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("accountid1")'>
                  </td>
                </tr>
                </tbody> 
              </table>
            </td>
            <td  valign="top"> 
              <table >
                <colgroup> <col width="40%"> <col width="60%"> <tbody> 
               <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(1939,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=accumfundaccount value=<%=accumfundaccount%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("accumfundaccount")'>
                  </td>
                </tr>
             <TR><TD class=Line colSpan=2></TD></TR> 
                </tbody> 
              </table>
            </td>            
            <td width="21%">&nbsp; </td>
          </tr>
<%
}
%>
<%
  if(issys || ishr){
%>          
          
          <tr class=Title> 
            <th colspan=3><%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%></th>
          </tr>
          <tr class=Spacing> 
            <td class=Sep3 colspan=3></td>
          </tr>
          <tr> 
            <td valign=top align=left > 
              <table >
                <colgroup> 
                  <col width="40%"> 
                  <col width="60%"> <tbody> 
                <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=seclevel value=<%=seclevel%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel")'>
                  </td>
                </tr>    
              <TR><TD class=Line colSpan=2></TD></TR> 
              </table>
            </td>
            <td  valign="top"> 
              <table >
                <colgroup> <col width="40%"> <col width="60%"> <tbody> 
               <tr> 
                  <td class=Field><%=SystemEnv.getHtmlLabelName(16017,user.getLanguage())%></td>
                  <td> 
                    <input class=inputstyle type=text size=2 maxlength=2 name=loginid value=<%=loginid%> onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("loginid")'>
                  </td>
                </tr>
                 
                </tbody> 
              </table>
            </td>                        
          </tr>
<%
}
%>          
          </TBODY> 
        </TABLE>
      </TD></TR></TBODY></TABLE>
 <input class=inputstyle type=hidden name=userid value="<%=userid%>">
 <input class=inputstyle type=hidden name=returnurl value='<%=Util.null2String(request.getParameter("returnurl"))%>'>
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
function submitData() {
 frmMain.submit();
}
</script>
</BODY>
</HTML>
