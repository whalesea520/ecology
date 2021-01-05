<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%
String tabid = Util.null2String(request.getParameter("tabid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String companyid = Util.null2String(request.getParameter("companyid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String groupid = Util.null2String(request.getParameter("groupid"));
String needsystem = Util.null2String(request.getParameter("needsystem"));    
boolean isoracle = RecordSet.getDBType().equals("oracle");
if(tabid.equals("")) tabid="0";
int uid=user.getUID();
//System.out.println("departmentid"+departmentid);
//System.out.println("tabid"+tabid);
//under Cookie
String rem=(String)session.getAttribute("resourcesingle");
if(rem==null){
	Cookie[] cks= request.getCookies();
	for(int i=0;i<cks.length;i++){
		if(cks[i].getName().equals("resourcesingle"+uid)){
			rem=cks[i].getValue();
			break;
		}
	}
}
if(rem!=null) rem = tabid+rem.substring(1);
else rem=tabid;
if(!nodeid.equals("")) rem = rem.substring(0,1)+"|"+nodeid;
session.setAttribute("resourcesingle",rem);
Cookie ck = new Cookie("resourcesingle"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(tabid.equals("0")&&atts.length>1){
	nodeid=atts[1];
	if(nodeid.indexOf("com")>-1){
		subcompanyid=nodeid.substring(nodeid.indexOf("_")+1);
	}
	else {
		departmentid=nodeid.substring(nodeid.lastIndexOf("_")+1);
	}
}
else if(tabid.equals("1") && atts.length>1) {
	groupid=atts[1];
}
//upper Cookie

String sqlstr="";
String check_per = Util.null2String(request.getParameter("resourceids"));

String resourceids = "" ;
String resourcenames ="";
if(!check_per.equals("")){
	try{
	String strtmp = "select id,lastname,departmentid from HrmResource where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){
        String department = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage());
                        String mark=DepartmentComInfo.getDepartmentmark(department);

                        if(mark.length()>6)
                        mark=mark.substring(0,6);
                        int length=mark.getBytes().length;
                        if(length<12){
                            for(int i=0;i<12-length;i++){
                              mark+=" ";
                            }
                        }
                        String subcid=DepartmentComInfo.getSubcompanyid1(department);
                        String subc= SubCompanyComInfo.getSubCompanyname(subcid);
                        String lastname=RecordSet.getString("lastname");
                        length=lastname.getBytes().length;
                        if(length<8){
                            for(int i=0;i<8-length;i++){
                              lastname+=" ";
                            }
                        }
                        lastname=lastname+" | "+mark+" | "+subc;
        ht.put(RecordSet.getString("id"),lastname);
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}

	StringTokenizer st = new StringTokenizer(check_per,",");

	while(st.hasMoreTokens()){
		String s = st.nextToken();
		resourceids +=","+s;
		resourcenames += ","+ht.get(s).toString();
	}
	}catch(Exception e){

	}
}
String subcomstr=SubCompanyComInfo.getRightSubCompany(user.getUID(),"HrmResourceAdd:Add",0);
Calendar today = Calendar.getInstance();
String lastname = Util.null2String(request.getParameter("lastname"));
String resourcetype = Util.null2String(request.getParameter("resourcetype"));
String resourcestatus = Util.null2String(request.getParameter("resourcestatus"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
 //departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String status = Util.null2String(request.getParameter("status"));

String roleid = Util.null2String(request.getParameter("roleid"));

if(tabid.equals("0")&&departmentid.equals("")&&sqlwhere.equals("")) departmentid=user.getUserDepartment()+"";

if(departmentid.equals("0"))    departmentid="";

if(subcompanyid.equals("0"))    subcompanyid="";
if(resourcestatus.equals(""))   resourcestatus="0" ;
if(resourcestatus.equals("-1"))   resourcestatus="" ;



int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;

    if(sqlwhere.equals("")&&status.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where (status =0 or status = 1  or status = 2 or status = 3) and subcompanyid1 in("+subcomstr+")" ;
        }
        else
            sqlwhere += " and (status =0 or status = 1  or status = 2 or status = 3) and subcompanyid1 in("+subcomstr+")";
    }
    if(sqlwhere.equals("")&&!status.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where  subcompanyid1 in("+subcomstr+")" ;
        }
        else
            sqlwhere += " and  subcompanyid1 in("+subcomstr+")";
    }
if(tabid.equals("1")&&!groupid.equals("")){
    if (ishead == 0) {
        ishead = 1;
        sqlwhere += " where t1.id=t2.userid and t2.groupid="+groupid;
    } else
        sqlwhere += " and t1.id=t2.userid and t2.groupid="+groupid;
sqlstr="select t1.id,t1.lastname,t1.departmentid,t1.jobtitle from hrmresource t1,HrmGroupMembers t2 " +sqlwhere  +" order by t1.dsporder,t1.lastname";
}else if(tabid.equals("0")&&!companyid.equals("")){
    sqlstr="select id,lastname,departmentid,jobtitle from hrmresource   "+ sqlwhere;

    sqlstr+=" order by dsporder,lastname";
}
else if(tabid.equals("0")&&!subcompanyid.equals("")) {
    if (ishead == 0) {
        ishead = 1;
        sqlwhere += " where  subcompanyid1=" + Util.getIntValue(subcompanyid);
    } else
        sqlwhere += " and subcompanyid1=" + Util.getIntValue(subcompanyid);
    sqlstr = "select id,lastname,departmentid,jobtitle from hrmresource " + sqlwhere ;

    sqlstr+=" order by dsporder,lastname";
}
else if(tabid.equals("0")&&!departmentid.equals("")){
    if (ishead == 0) {
        ishead = 1;
        sqlwhere += " where  departmentid=" + Util.getIntValue(departmentid);
    } else
        sqlwhere += " and departmentid=" + Util.getIntValue(departmentid);
    sqlstr="select id,lastname,departmentid,jobtitle from hrmresource "+sqlwhere ;

    sqlstr+=" order by dsporder,lastname";
}else if(tabid.equals("0")){
    sqlstr="select id,lastname,departmentid,jobtitle from hrmresource "+sqlwhere ;

    sqlstr+="  order by dsporder,lastname";
} else if(tabid.equals("2")){
    if(!lastname.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
        }
        else
            sqlwhere += " and lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
    }

    if(!jobtitle.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where jobtitle in (select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
        }
        else
            sqlwhere += " and jobtitle in (select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
    }
    if(!departmentid.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where departmentid =" + departmentid +" " ;
        }
        else
            sqlwhere += " and departmentid =" + departmentid +" " ;
    }
if(departmentid.equals("")&&!subcompanyid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where subcompanyid1 =" + subcompanyid +" " ;
	}
	else
		sqlwhere += " and subcompanyid1 =" + subcompanyid +" " ;
}
    if(!status.equals("")&&!status.equals("9")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where status =" + status +" " ;
        }
        else
            sqlwhere += " and status =" + status +" " ;
    }
    if(!roleid.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where  HrmResource.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID="+roleid+" ) " ;
        }
        else
            sqlwhere += " and    HrmResource.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID="+roleid+" ) " ;
    }

      sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle "+
                    "from HrmResource  " + sqlwhere ;

    sqlstr+=" order by dsporder,lastname";

}
    //System.out.println("tabid:"+tabid);
    //System.out.println("sqlstr:"+sqlstr);
//add by alan for td:10343
boolean isInit = Util.null2String(request.getParameter("isinit")).equals("");//是否点击过搜索
if((tabid.equals("2") && isInit) ||(tabid.equals("0") && nodeid.equals(""))) sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle from HrmResource WHERE 1=2";
%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>

</HEAD>
<BODY>

<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>	
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>

	<!--########Browser Table Start########-->
<TABLE width=100% class="BroswerStyle"  cellspacing="0" STYLE="margin-top:0">
   <TR width=100% class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
      <TH width=25%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>      
      <TH width=35%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
   </tr>
   <TR width=100% class=Line><TH colspan="4" ></TH></TR>          
   <tr width=100%>
     <td width=100% colspan=4>
       <div style="overflow-y:scroll;width:100%;height:195px">
         <table width=100% ID=BrowseTable class="BroswerStyle">
<%

if( needsystem.equals("1")) {
%>
          <TR width=100% class=DataDark>
	   <TD style="display:none" width=0><A HREF=#>1</A></TD>
	   <TD width=25%><%=SystemEnv.getHtmlLabelName(16139,user.getLanguage())%></TD>
	   <TD width=35%></TD>
	   <TD width=25%></TD>
          </TR>
<%
}
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String lastnames = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
	//String resourcetypes = RecordSet.getString("resourcetype");
	//String startdates = RecordSet.getString("startdate");
	//String enddates = RecordSet.getString("enddate");
	String jobtitlenames = Util.toScreen(JobTitlesComInfo.getJobTitlesname(RecordSet.getString("jobtitle")),user.getLanguage());
	String departmentids = RecordSet.getString("departmentid");
	if(i==0){
		i=1;
%>
         <TR width=100% class=DataLight>
<%
	}else{
		i=0;
%>
         <TR width=100% class=DataDark>
<%
}
%>
	  <TD width=0 style="display:none"><A HREF=#><%=ids%></A></TD>
	  <TD width=25%> <%=lastnames%></TD>
	
	  <TD width=35%><%=jobtitlenames%></TD>
	  <TD width=25%><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentids),user.getLanguage())%></TD>
         </TR>
<%}
%>
      </table>
     </div>
     </td>
     
   </tr>
   <tr width=100% >
    <td height="10" colspan=4></td>
   </tr>
   <tr width=100%>
     <td width=100% align="center" valign="bottom" colspan=4>
     
        <BUTTON class=btnSearch accessKey=S <%if(!tabid.equals("2")){%>style="display:none"<%}%> id=btnsub><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>     
	<BUTTON class=btn accessKey=2  id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <BUTTON class=btnReset accessKey=T  id=btncancel><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
     </td>
  </tr>
</TABLE>
	<!--########//Select Table End########-->
 


 



<SCRIPT LANGUAGE=VBS>

Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
      window.parent.Close
   End If
End Sub
Sub BrowseTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataDark"
      Else
         p.className = "DataLight"
      End If
   End If
End Sub

Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub

Sub btnsub_onclick()
     window.parent.frame1.SearchForm.btnsub.click()
End Sub

Sub btncancel_onclick()
     window.close()
End Sub
</SCRIPT>

</BODY>
</HTML>