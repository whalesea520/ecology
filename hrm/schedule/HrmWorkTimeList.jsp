<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("HrmWorktimeWarp:Maintenance", user)){
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
}
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="HrmKqSystemComInfo" class="weaver.hrm.schedule.HrmKqSystemComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16731 , user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String errmsg = Util.null2String(request.getParameter("errmsg"));
String resourceidpar = Util.null2String(request.getParameter("resourceid"));
String departmentidpar = Util.null2String(request.getParameter("departmentid"));
String workdatepar = Util.null2String(request.getParameter("workdate"));
String isself = Util.null2String(request.getParameter("isself"));

if(!resourceidpar.equals("") || !departmentidpar.equals("")) isself = "1" ;


Calendar thedate = Calendar.getInstance ();
if(workdatepar.equals("")) workdatepar = Util.add0(thedate.get(Calendar.YEAR),4) + "-" + Util.add0(thedate.get(Calendar.MONTH)+1,2) ; 


int salaryyear = Util.getIntValue(workdatepar.substring(0 , 4)) ;
int salarymonth = Util.getIntValue(workdatepar.substring(5 , 7)) ;
int salaryendday = Util.getIntValue(HrmKqSystemComInfo.getSalaryenddate(),31) ;

thedate.set( salaryyear , salarymonth-1, salaryendday) ; 
String salaryenddate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 

thedate.set( salaryyear , salarymonth-2, salaryendday) ; 
thedate.add(Calendar.DATE , 1) ; 
String salarybegindate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 


String sql = "" ;
int selectcolcount = 0 ;
int colwidth = 0 ;

ArrayList shiftids = new ArrayList() ; 
ArrayList shiftnames = new ArrayList() ; 
ArrayList reesourceshiftids = new ArrayList() ; 
ArrayList resouceworkcounts = new ArrayList() ; 

if(isself.equals("1")) {

    String sqlwhere1 = "";
    String sqlwhere2 = "";

    if(!resourceidpar.equals("")) { 
        sqlwhere1 += " and resourceid =" + resourceidpar  ; 
        sqlwhere2 += " and id =" + resourceidpar  ; 
    } 

    if(!departmentidpar.equals("")) { 
        sqlwhere1 += " and resourceid in (select id from HrmResource where departmentid = " + departmentidpar +")" ; 
        sqlwhere2 =  " and departmentid = " + departmentidpar ; 
    } 

    if(!workdatepar.equals("")) { 
        sqlwhere1 += " and workdate ='" + workdatepar + "'" ; 
    } 

    sql = " select id from hrmresource where status in (0,1,2,3) " + sqlwhere2 + " order by departmentid " ;


    // 得到所有当前的排班种类，放入缓存
    

    RecordSet.executeSql("select id, shiftname from HrmArrangeShift where ishistory='0' order by id ") ; 
    while ( RecordSet.next() ) { 
        String id = Util.null2String(RecordSet.getString("id")) ; 
        String shiftname = Util.toScreen(RecordSet.getString("shiftname") , user.getLanguage()) ; 

        shiftids.add(id) ; 
        shiftnames.add(shiftname) ; 
    } 

    selectcolcount = shiftids.size() + 3 ;
    colwidth = 65/(shiftids.size()+1) ;

    // 得到选定人力资源范围和时间范围内的所有出勤信息放入缓存，以人力资源加排班类型作为索引
    

    RecordSet.executeSql(" select a.* from HrmWorkTimeCount a , Hrmresource b where a.resourceid = b.id and b.status in ( 0,1,2,3 ) " + sqlwhere1 ) ; 

    while( RecordSet.next() ) { 
        String resourceid = Util.null2String(RecordSet.getString("resourceid")) ; 
        String shiftid = Util.null2String(RecordSet.getString("shiftid")) ; 
        String workcount = Util.null2String(RecordSet.getString("workcount")) ; 
        
        reesourceshiftids.add(resourceid + "_" + shiftid) ; 
        resouceworkcounts.add(workcount) ; 
    } 
}


%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16729,user.getLanguage())+",/hrm/schedule/HrmWorkTimeCreate.jsp?workdate="+workdatepar+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16733,user.getLanguage())+",javascript:editData(),_self} " ;
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

<% if( errmsg.equals("1") ) { %><font color=red><%=SystemEnv.getHtmlLabelName(129119, user.getLanguage())%></font><%}%>

<FORM id=frmmain name=frmmain method=post action="HrmWorkTimeList.jsp">
<input type="hidden" name="isself" id="isself" value="1">
<input class=inputstyle type="hidden" name="operation" value=save>
<input class=inputstyle type="hidden" name="salarybegindate" value="<%=salarybegindate%>">
<input class=inputstyle type="hidden" name="salaryenddate" value="<%=salaryenddate%>">

<table class=Viewform>
  <tbody>
  <COLGROUP>   
    <COL width="20%">
    <COL width="20%"> 
    <COL width="30%">
    <COL width="30%">
    <TR class=Title>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></TH>
  </TR>
  <TR class=Spacing style="height:1px">
    <TD class=Line1 colSpan=6 ></TD>
  </TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td class=field>

      <input class="wuiBrowser" type=hidden name=departmentid value="<%=departmentidpar%>" 
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	  _displayText="<%=DepartmentComInfo.getDepartmentname(departmentidpar)%>">
    </td>
     <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
    <td class=field>
       <BUTTON class=Calendar type="button" id=selectworkdate onclick="getSdDate(workdatespan,workdate)"></BUTTON> 
       <SPAN id=workdatespan ><%=workdatepar%></SPAN>
       <input class=inputstyle type="hidden" name="workdate" value="<%=workdatepar%>">
    </td>
    <td>
 </tr>  
<TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
    <td class=field>

      <input class="wuiBrowser" type=hidden name=resourceid value="<%=resourceidpar%>" 
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	  _displayText="<%=ResourceComInfo.getResourcename(resourceidpar)%>">
    </td>
    <td></td>
    <td></td>
  </tr>  
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  </tbody>
</table>
<br>

<% if(isself.equals("1")) { %>

<TABLE class = ListStyle cellspacing=1>
  <TBODY>
  <TR class = header>
    <TH colspan=<%=selectcolcount%>><%=SystemEnv.getHtmlLabelName(16732,user.getLanguage())%> (<%=salarybegindate%> ~ <%=salaryenddate%>)</TH>
  </TR>
  <!--TR class = separator>
    <TD class = Sep1 colspan=<%=selectcolcount%>></TD>
  </TR-->
  <TR class = Header>
    <TH width="10%"><nobr><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
    <TH width="8%"><nobr><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>
    <TH width="<%=colwidth%>%"><nobr><%=SystemEnv.getHtmlLabelName(16254,user.getLanguage())%></TH>
  <%
    for(int i = 0 ; i < shiftnames.size() ; i++ ) { 
        String shiftname = (String) shiftnames.get(i) ; 
  %>
    <TH width="<%=colwidth%>%"><nobr><%=shiftname%></TH>
  <% } %>
    </TR>
  <%
    boolean isLight = false ; 
    String currentdepartmentid = "" ;
    int shiftindex = 0 ;
    String workcount = "" ;
    RecordSet.executeSql(sql) ; 
    while(RecordSet.next()) { 
        String resourceid = Util.null2String(RecordSet.getString("id")) ;
        String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;
        isLight = !isLight ; 
  %> 
       <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
        <TD>
        <% if( !currentdepartmentid.equals(departmentid) ) {
                currentdepartmentid = departmentid ;
        %>
        <nobr><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>
        <% } %>
        </TD>
        <TD><nobr><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid) , user.getLanguage())%></TD>
        <TD>
        <%  shiftindex = reesourceshiftids.indexOf(resourceid + "_0") ; 
            if( shiftindex != -1 ) workcount = (String) resouceworkcounts.get( shiftindex ) ;
            else workcount = "" ;
        %>
        <%=workcount%>
        </TD>
  <%
        for(int j = 0 ; j < shiftids.size() ; j++ ) {
            String shiftid = (String) shiftids.get(j) ; 
            shiftindex = reesourceshiftids.indexOf(resourceid + "_" + shiftid) ; 
            if( shiftindex != -1 ) workcount = (String) resouceworkcounts.get( shiftindex ) ;
            else workcount = "" ;
        %>
        
        <TD><%=workcount%></TD>
  <%    } %>
     </TR> 
  <% } %>
  </TBODY>
 </TABLE>
<%}%>
</form>
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
function submitData() {
    document.forms[0].submit();
}

function editData() {
    document.forms[0].action= "HrmWorkTimeEdit.jsp" ;
    jQuery("#isself").val("");
    document.forms[0].submit();
}

</script>
<script language=vbs>
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = id(1)
	frmmain.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = ""
	frmmain.resourceid.value=""
	end if
	end if
end sub

sub onShowDepartment(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputname.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
	else
	spanname.innerHtml = ""
	inputname.value=""
	end if	
	end if
end sub
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>