<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ScheduleDiffComInfo" class="weaver.hrm.schedule.HrmScheduleDiffComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16054,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

Calendar todaycal = Calendar.getInstance ();
String month = Util.add0(todaycal.get(Calendar.MONTH)+1,2);
String year = Util.add0(todaycal.get(Calendar.YEAR),4);


boolean CanAdd = HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add", user);


String resourceidpar = Util.null2String(request.getParameter("resourceid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String diffidpar = Util.null2String(request.getParameter("diffid"));
String manpar = Util.null2String(request.getParameter("manpar"));
String startdatefrom = Util.null2String(request.getParameter("startdatefrom"));
String startdateto = Util.null2String(request.getParameter("startdateto"));
String enddatefrom = Util.null2String(request.getParameter("enddatefrom"));
String enddateto = Util.null2String(request.getParameter("enddateto"));
String starttimefrom = Util.null2String(request.getParameter("starttimefrom"));
String starttimeto = Util.null2String(request.getParameter("starttimeto"));
String endtimefrom = Util.null2String(request.getParameter("endtimefrom"));
String endtimeto = Util.null2String(request.getParameter("endtimeto"));
String isself = Util.null2String(request.getParameter("isself"));

String diffidparstr = "" ;
if(!diffidpar.equals("")) {
    String diffidpars[] = Util.TokenizerString2(diffidpar,",");
    if(diffidpars != null) {
        for( int k=0 ; k < diffidpars.length ; k++ ) {
            String tempdiffid = Util.null2String( diffidpars[k] ) ;
            if( !tempdiffid.equals("") ) {
                if(diffidparstr.equals("")) diffidparstr = ScheduleDiffComInfo.getDiffname(tempdiffid) ;
                else diffidparstr += "," + ScheduleDiffComInfo.getDiffname(tempdiffid) ;
            }
        }
    }
}

String sqlwhere = "";

if(startdatefrom.equals("")&&startdateto.equals("")){
  startdatefrom=year+"-"+month+"-01";
  startdateto=year+"-"+month+"-31";
}

if(isself.equals("1")) {

    int ishead = 1;
    if(!sqlwhere.equals("")) ishead = 1;

    if(!resourceidpar.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where resourceid=" + Util.fromScreen2(resourceidpar,user.getLanguage()) +" ";
        }
        else 
            sqlwhere += " and resourceid =" + Util.fromScreen2(resourceidpar,user.getLanguage()) +" ";
    }


    if(!departmentid.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where resourceid in (select id from HrmResource where departmentid = " + Util.fromScreen2(departmentid,user.getLanguage()) +") ";
        }
        else 
            sqlwhere += " and resourceid in (select id from HrmResource where departmentid = " + Util.fromScreen2(departmentid,user.getLanguage()) +") ";
    }

    if(!diffidpar.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where diffid in (" + Util.fromScreen2(diffidpar,user.getLanguage()) +") ";
        }
        else 
            sqlwhere += " and diffid in (" + Util.fromScreen2(diffidpar,user.getLanguage()) +") ";
    }

    if(!startdatefrom.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where startdate >='" + Util.fromScreen2(startdatefrom,user.getLanguage()) +"' ";
        }
        else 
            sqlwhere += " and startdate >='" + Util.fromScreen2(startdatefrom,user.getLanguage()) +"' ";
    }
    if(!startdateto.equals("")){
        if(ishead==0){
            ishead = 1;
            if(rs.getDBType().equals("oracle")){
            sqlwhere += " where (startdate is not null and startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
            }else{
            sqlwhere += " where (startdate <> '' and startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
            }
        }
        else 
            if(rs.getDBType().equals("oracle")){
            sqlwhere += " and (startdate is not null and startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
            }else{
            sqlwhere += " and (startdate<>'' and startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
            }
    }
    if(!enddatefrom.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where enddate >='" + Util.fromScreen2(enddatefrom,user.getLanguage()) +"' ";
        }
        else 
            sqlwhere += " and enddate >='" + Util.fromScreen2(enddatefrom,user.getLanguage()) +"' ";
    }
    if(!enddateto.equals("")){
        if(ishead==0){
            ishead = 1;
            if(rs.getDBType().equals("oracle")){
            sqlwhere += " where (enddate is not null and enddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
            }else{
            sqlwhere += " where (enddate <> '' and enddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
            }
        }
        else 
            if(rs.getDBType().equals("oracle")){
            sqlwhere += " and (enddate is not null and enddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
            }else{
            sqlwhere += " and (enddate<>'' and enddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
            }
    }

    if(!starttimefrom.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where starttime >='" + Util.fromScreen2(starttimefrom,user.getLanguage()) +"' ";
        }
        else 
            sqlwhere += " and starttime >='" + Util.fromScreen2(starttimefrom,user.getLanguage()) +"' ";
    }
    if(!starttimeto.equals("")){
        if(ishead==0){
            ishead = 1;
            if(rs.getDBType().equals("oracle")){
            sqlwhere += " where (starttime is not null and starttime <='" + Util.fromScreen2(starttimeto,user.getLanguage()) +"') ";
            }else{
            sqlwhere += " where (starttime <> '' and starttime <='" + Util.fromScreen2(starttimeto,user.getLanguage()) +"') ";
            }
        }
        else 
            if(rs.getDBType().equals("oracle")){
            sqlwhere += " and (starttime is not null and starttime <='" + Util.fromScreen2(starttimeto,user.getLanguage()) +"') ";
            }else{
            sqlwhere += " and (starttime<>'' and starttime <='" + Util.fromScreen2(starttimeto,user.getLanguage()) +"') ";
            }
    }
    if(!endtimefrom.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where endtime >='" + Util.fromScreen2(endtimefrom,user.getLanguage()) +"' ";
        }
        else 
            sqlwhere += " and endtime >='" + Util.fromScreen2(endtimefrom,user.getLanguage()) +"' ";
    }
    if(!endtimeto.equals("")){
        if(ishead==0){
            ishead = 1;
            if(rs.getDBType().equals("oracle")){		
            sqlwhere += " where (endtime is not null and endtime <='" + Util.fromScreen2(endtimeto,user.getLanguage()) +"') ";
            }else{
            sqlwhere += " where (endtime <> '' and endtime <='" + Util.fromScreen2(endtimeto,user.getLanguage()) +"') ";
            }
        }
        else 
            if(rs.getDBType().equals("oracle")){			
            sqlwhere += " and (endtime is not null and endtime <='" + Util.fromScreen2(endtimeto,user.getLanguage()) +"') ";
            }else{
            sqlwhere += " and (endtime<>'' and endtime <='" + Util.fromScreen2(endtimeto,user.getLanguage()) +"') ";
        }
    }
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/report/schedulediff/HrmScheduleDiffReport.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=frmmain name=frmmain method=post action="HrmScheduleDiffDetailReport.jsp">
<input type="hidden" name="isself" value="1">

<table class=ViewForm>
  <tbody>
  <COLGROUP>   
    <COL width="15%">
    <COL width="25%"> 
    <COL width="15%"> 
    <COL width="18%">
    <COL width="10%">
    <COL width="17%">    
  <TR class=Title>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></TH>
  </TR>
  <TR class=Spacing>
    <TD class=line1 colSpan=6 ></TD>
  </TR>
  <tr>
    <td> 
      <%=SystemEnv.getHtmlLabelName(6139,user.getLanguage())%>     
    </td>
    <td class=field>
      <BUTTON class=Browser onclick="onShowScheduleDiff('diffidspan','diffid')"></BUTTON> 
      <SPAN id=diffidspan><%=diffidparstr%></SPAN> 
      <INPUT type=hidden name=diffid value=<%=diffidpar%> >
    </td>    
    <td>
      <%=SystemEnv.getHtmlLabelName(16055,user.getLanguage())%>
    </td>
    <td class=field>
      <BUTTON class=Browser onclick="onShowResourceID()"></BUTTON> 
      <SPAN id=resourceidspan><%=ResourceComInfo.getResourcename(resourceidpar)%></SPAN> 
      <INPUT type=hidden name=resourceid value="<%=resourceidpar%>" >
    </td>
    <td>
      <%=SystemEnv.getHtmlLabelName(16050,user.getLanguage())%>
    </td>
    <td class=field>
      <BUTTON class=Browser onclick="onShowDepartment()"></BUTTON> 
      <SPAN id=departmentidspan><%=DepartmentComInfo.getDepartmentname(departmentid)%></SPAN> 
      <INPUT type=hidden name=departmentid value="<%=departmentid%>" >
    </td>
  </tr>
  <TR><TD class=Line colSpan=6></TD></TR> 
  <tr>
    <td>
      <%=SystemEnv.getHtmlLabelName(16037,user.getLanguage())%>
    </td>
    <td class=field>
       <BUTTON class=Calendar id=selectstartdatefrom onclick="getDate(startdatefromspan,startdatefrom)"></BUTTON> 
       <SPAN id=startdatefromspan ><%=startdatefrom%></SPAN> -
       <BUTTON class=Calendar id=selectstartdateto onclick="getDate(startdatetospan,startdateto)"></BUTTON> 
       <SPAN id=startdatetospan ><%=startdateto%></SPAN> 
       <input type="hidden" name="startdatefrom" value="<%=startdatefrom%>">
       <input type="hidden" name="startdateto" value="<%=startdateto%>">
    </td>
    <td>
      <%=SystemEnv.getHtmlLabelName(16038,user.getLanguage())%>
    </td>
    <td class=field  colspan=3>
       <BUTTON class=Calendar id=selectenddatefrom onclick="getDate(enddatefromspan,enddatefrom)"></BUTTON> 
       <SPAN id=enddatefromspan ><%=enddatefrom%></SPAN> -
       <BUTTON class=Calendar id=selectenddateto onclick="getDate(enddatetospan,enddateto)"></BUTTON> 
       <SPAN id=enddatetospan ><%=enddateto%></SPAN> 
       <input type="hidden" name="enddatefrom" value="<%=enddatefrom%>">
       <input type="hidden" name="enddateto" value="<%=enddateto%>">
    </td>
  </tr>  
  <TR><TD class=Line colSpan=6></TD></TR> 
  <tr>
    <td>
      <%=SystemEnv.getHtmlLabelName(16039,user.getLanguage())%>
    </td>
    <td class=field>
       <BUTTON class=Clock onclick="onShowTime('starttimefromspan','starttimefrom')"></BUTTON> 
       <SPAN id=starttimefromspan ><%=starttimefrom%></SPAN> -
       <BUTTON class=Clock onclick="onShowTime('starttimetospan','starttimeto')"></BUTTON> 
       <SPAN id=starttimetospan ><%=starttimeto%></SPAN> 
       <input type="hidden" name="starttimefrom" value="<%=starttimefrom%>">
       <input type="hidden" name="starttimeto" value="<%=starttimeto%>">
    </td>
    <td>
      <%=SystemEnv.getHtmlLabelName(16040,user.getLanguage())%>
    </td>
    <td class=field colspan=3>
       <BUTTON class=Clock onclick="onShowTime('endtimefromspan','endtimefrom')"></BUTTON> 
       <SPAN id=endtimefromspan ><%=endtimefrom%></SPAN> -
       <BUTTON class=Clock onclick="onShowTime('endtimetospan','endtimeto')"></BUTTON> 
       <SPAN id=endtimetospan ><%=endtimeto%></SPAN> 
       <input type="hidden" name="endtimefrom" value="<%=endtimefrom%>">
       <input type="hidden" name="endtimeto" value="<%=endtimeto%>">
    </td>
  </tr>  
  <TR><TD class=Line colSpan=6></TD></TR> 
  </tbody>
</table>

<% if(isself.equals("1")) { %>

<table class=ListStyle cellspacing=1 >
<colgroup>  
  <col width="17%">
  <col width="13%">
  <col width="15%">
  <col width="10%">
  <col width="15%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
<tbody>
<tr class=header>  
  <td><%=SystemEnv.getHtmlLabelName(6139,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(16055,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(16719,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(16720,user.getLanguage())%></td>
</tr>
<TR class=Line><TD colspan="8" ></TD></TR> 
<%
int line = 0;
   ExcelFile.init ();
   String filename = "Work Info "; 
   filename += startdatefrom+"~"+  startdateto;
   ExcelFile.setFilename(filename) ;
   
   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(filename) ;
   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(8000) ;
   
   ExcelRow erdepType = null ;
   erdepType = et.newExcelRow();
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(6139,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(1867,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(740,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(742,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(741,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(743,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(16719,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(16720,user.getLanguage()), "Header" ) ; 
   
RecordSet.executeProc("HrmScheduleDiff_Select_All","");	
while(RecordSet.next()){
  int first  = 0;
  String diffid = RecordSet.getString("id");
  String diffname =RecordSet.getString("diffname");
  String sql = "select * from HrmScheduleMaintance where diffid = "+diffid+ sqlwhere+" order by startdate desc";  
//  out.println(sql+"<br>");
  rs.executeSql(sql);	
  while(rs.next()){
    ExcelRow erdep = et.newExcelRow() ;
    
    String id = Util.null2String(rs.getString("id"));
    String resourceid = Util.null2String(rs.getString("resourceid"));
    String startdate =   Util.null2String(rs.getString("startdate"));    
    String starttime =   Util.null2String(rs.getString("starttime"));
    String enddate =   Util.null2String(rs.getString("enddate"));
    String endtime =   Util.null2String(rs.getString("endtime"));
    int realdifftime =   Util.getIntValue(rs.getString("realdifftime"),0);
    int realcarddifftime =   Util.getIntValue(rs.getString("realcarddifftime"),0);
    String realdifftimestr = "" ;
    String realcarddifftimestr = "" ;

    if(realdifftime != 0 ) {
        int realcarddiffhour = realdifftime/60 ;
        int realcarddiffmin = realdifftime - realcarddiffhour*60 ;
        realdifftimestr = Util.add0(realcarddiffhour,2) + ":" + Util.add0(realcarddiffmin,2) ;
    }

    if(realcarddifftime != 0 ) {
        int realcarddiffhour = realcarddifftime/60 ;
        int realcarddiffmin = realcarddifftime - realcarddiffhour*60 ;
        realcarddifftimestr = Util.add0(realcarddiffhour,2) + ":" + Util.add0(realcarddiffmin,2) ;
    }

    erdep.addStringValue(Util.toScreen(diffname,user.getLanguage()));
    erdep.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage()));
    erdep.addStringValue(startdate);
    erdep.addStringValue(starttime);
    erdep.addStringValue(enddate);
    erdep.addStringValue(endtime);
    erdep.addStringValue(realdifftimestr);
    erdep.addStringValue(realcarddifftimestr);
    if(line%2==0){ 
      line++; 
%>
    <tr class=datalight>  
<%}else{ line++;%><tr class=datadark> <%}%>      
      <td>
<%if(first == 0){%><a href="/hrm/schedule/HrmScheduleDiffEdit.jsp?id=<%=diffid%>"><%=diffname%></a><%}%>
      </td>
      <td><a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>">
       <%=ResourceComInfo.getResourcename(resourceid)%></a>
      </td>
      <td>
       <%=startdate%>
      </td>
      <td>
       <%=starttime%>
      </td>
      <td>
       <%=enddate%>
      </td>
      <td>
       <%=endtime%>
      </td>
      <td>
       <%=realdifftimestr%>
      </td>
      <td>
       <%=realcarddifftimestr%>
      </td>
    </tr>
<%
  first = 1;
  }
}

%>
</tbody>
</table>
<%}%>
</form>


<script language=vbs>
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = ""
	frmmain.resourceid.value=""
	end if
	end if
end sub

sub onShowScheduleDiff(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmMutiScheduleDiffBrowser.jsp")
	if (Not IsEmpty(id)) then
        if id(0)<> "" then
            document.all(tdname).innerHtml = Mid(id(1),2,len(id(1)))
            document.all(inputename).value=Mid(id(0),2,len(id(0)))
        else 
            document.all(tdname).innerHtml = ""
            document.all(inputename).value=""
	end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentidspan.innerHtml = id(1)
	frmmain.departmentid.value=id(0)
	else
	departmentidspan.innerHtml = ""
	frmmain.departmentid.value=""
	end if	
	end if
end sub
</script>
<script language=javascript>  
function submitData() {
 frmMain.submit();
}
</script>
</body>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>