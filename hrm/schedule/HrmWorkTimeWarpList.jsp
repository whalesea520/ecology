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

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ScheduleDiffComInfo" class="weaver.hrm.schedule.HrmScheduleDiffComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16688,user.getLanguage()) ; 
String needfav ="1";
String needhelp ="";

String errmsg = Util.null2String(request.getParameter("errmsg"));
String resourceidpar = Util.null2String(request.getParameter("resourceid"));
String departmentidpar = Util.null2String(request.getParameter("departmentid"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String diffrelate = Util.null2String(request.getParameter("diffrelate"));
//xiaofeng
int type=Util.getIntValue(request.getParameter("type"),0);
if( diffrelate.equals("") ) diffrelate = "1" ;

String isself = Util.null2String(request.getParameter("isself"));           // 是否当页搜索



Calendar todaycal = Calendar.getInstance ();
String month = Util.add0(todaycal.get(Calendar.MONTH)+1,2);
String year = Util.add0(todaycal.get(Calendar.YEAR),4);

if(fromdate.equals("") && enddate.equals("")) { 
  fromdate = year + "-" + month + "-01" ; 
  enddate = year + "-" + month + "-31" ; 
} 

String sqlwhere = "";

if(isself.equals("1")) {
   
    int ishead = 0 ; 

    if(!resourceidpar.equals("")) { 
        if(ishead==0) { 
            ishead = 1 ; 
            sqlwhere += " where resourceid=" + Util.fromScreen2(resourceidpar , user.getLanguage()) + "" ; 
        } 
        else 
            sqlwhere += " and resourceid =" + Util.fromScreen2(resourceidpar , user.getLanguage()) + "" ; 
    } 

    if(!departmentidpar.equals("")) { 
        if(ishead==0) { 
            ishead = 1 ; 
            sqlwhere += " where resourceid in (select id from HrmResource where departmentid = " + Util.fromScreen2(departmentidpar , user.getLanguage()) + ")" ; 
        } 
        else 
            sqlwhere += " and resourceid in (select id from HrmResource where departmentid = " + Util.fromScreen2(departmentidpar , user.getLanguage()) +")" ; 
    } 

    if(!fromdate.equals("")) { 
        if(ishead==0) { 
            ishead = 1 ; 
            sqlwhere += " where diffdate >='" + fromdate + "'" ; 
        } 
        else 
            sqlwhere += " and diffdate >='" + fromdate + "'" ; 
        
    } 

    if(!enddate.equals("")) { 
        if(ishead==0) { 
            ishead = 1 ; 
            sqlwhere += " where diffdate <='" + enddate + "'" ; 
        } 
        else 
            sqlwhere += " and diffdate <='" + enddate + "'" ; 
        
    } 


    if(diffrelate.equals("0")) { 
        if(ishead==0) { 
            ishead = 1 ; 
            sqlwhere += " where diffid is not null and diffid != 0 " ; 
        } 
        else 
            sqlwhere += " and diffid is not null and diffid != 0 " ; 
        
    } 

    if(diffrelate.equals("1")) { 
        if(ishead==0) { 
            ishead = 1 ; 
            sqlwhere += " where ( diffid is null or diffid = 0 ) " ; 
        } 
        else 
            sqlwhere += " and ( diffid is null or diffid = 0 ) " ; 
        
    }
    //System.out.println("type:"+type);
    switch(type){
            case 1:
            sqlwhere += " and ( difftype='1' and intime is not null and outtime is not null and intime >theintime  ) " ;
            break;
            case 2: 
            sqlwhere += " and ( difftype='1' and intime is not null and outtime is not null and outtime <theouttime ) " ;
            break;
            case 3:
            sqlwhere += " and (difftype='1' and ((intime is  null and outtime is not null) or (intime is not null and outtime is  null))) " ;
            break;
            case 4:
            sqlwhere += " and (difftype='1' and intime is null and outtime is null ) " ;
            break;
            default:
            break;
    } 
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15413,user.getLanguage())+SystemEnv.getHtmlLabelName(15368,user.getLanguage())+",/hrm/schedule/HrmWorkTimeWarpCreate.jsp,_self} " ;
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

<FORM id=frmmain name=frmmain method=post action="HrmWorkTimeWarpList.jsp">
<input class=inputstyle type="hidden" name="operation" value=save>
<input type="hidden" name="isself" value="1">
<div>
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
  <TR class=Spacing style="height:2px">
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
       <BUTTON class=Calendar type="button" id=selectfromdate onclick="getDate(fromdatespan,fromdate)"></BUTTON> 
       <SPAN id=fromdatespan ><%=fromdate%></SPAN>
       <input class=inputstyle type="hidden" name="fromdate" value="<%=fromdate%>">
       -<BUTTON class=Calendar type="button" id=selectenddate onclick="getDate(enddatespan,enddate)"></BUTTON> 
       <SPAN id=enddatespan ><%=enddate%></SPAN> 
       <input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>">
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
    <td><%=SystemEnv.getHtmlLabelName(16736,user.getLanguage())%></td>
    <td class=field>
       <select class=inputstyle id=diffrelate name=diffrelate onchange="if(this.options[2].selected){frmmain.type.style.display='';} else{frmmain.type.style.display='none';frmmain.type.options[0].selected=true;}">
          <option value="2" <% if( diffrelate.equals("2") ) { %>selected<% } %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
          <option value="0" <% if( diffrelate.equals("0") ) { %>selected<% } %>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
          <option value="1" <% if( diffrelate.equals("1") ) { %>selected<% } %>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
        </select>
        <select class=inputstyle id=type name=type <% if( !diffrelate.equals("1") ) { %>style="display:none"<% } %> >
          <option value="0" <% if( type==0 ) { %>selected<% } %> >------</option>
          <option value="1" <% if( type==1 ) { %>selected<% } %>><%=SystemEnv.getHtmlLabelName(20081, user.getLanguage())%></option>
          <option value="2" <% if( type==2 ) { %>selected<% } %>><%=SystemEnv.getHtmlLabelName(20082, user.getLanguage())%></option>
          <option value="3" <% if( type==3 ) { %>selected<% } %>><%=SystemEnv.getHtmlLabelName(129121, user.getLanguage())%></option>
          <option value="4" <% if( type==4 ) { %>selected<% } %>><%=SystemEnv.getHtmlLabelName(25994, user.getLanguage())%></option>
        </select>
    </td>
  </tr>  
 <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
  </tbody>
</table>

<% if(isself.equals("1")) { %>
<table class=ListStyle cellspacing=1 >
<colgroup>  
  <col width="8%">
  <col width="10%">
  <col width="13%">
  <col width="10%">
  <col width="10%">
  <col width="15%">
  <col width="15%">
  <col width="10%">
  <col width="10%">
<tbody>
<tr class=header>  
  <td><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(16704,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(16705,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelNames("225,16253",user.getLanguage()) %></td>
  <td><%=SystemEnv.getHtmlLabelName(16672,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(16720,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(16719,user.getLanguage())%></td>
</tr>

<%
  int line = 0;
  String sql = "select * from HrmWorkTimeWarp " + sqlwhere + " order by diffdate desc";  
  rs.executeSql(sql);	
  while(rs.next()){
   
    String id = Util.null2String(rs.getString("id"));
    String resourceid = Util.null2String(rs.getString("resourceid"));
    String diffdate =   Util.null2String(rs.getString("diffdate"));
    String difftype =   Util.null2String(rs.getString("difftype"));
    String intime =   Util.null2String(rs.getString("intime"));
    String outtime =   Util.null2String(rs.getString("outtime"));
    String theintime =   Util.null2String(rs.getString("theintime"));
    String theouttime =   Util.null2String(rs.getString("theouttime"));
    String diffid =   Util.null2String(rs.getString("diffid"));
    int counttime =   Util.getIntValue(rs.getString("counttime"),0);
    int diffcounttime =   Util.getIntValue(rs.getString("diffcounttime"),0);

    if( !theouttime.equals("")) theouttime = "-" + theouttime ;

    String difftypeid = "" ;

    int realdiffhour = counttime/60 ;
    int realdiffmin = counttime - realdiffhour*60 ;
    String realdiffhourstr = "" ;
    if(realdiffhour<10) realdiffhourstr = Util.add0(realdiffhour,2)  ;
    else realdiffhourstr = ""+ realdiffhour  ;
    String realdifftimestr = realdiffhourstr + ":" + Util.add0(realdiffmin,2) ;

    int realcarddiffhour = diffcounttime/60 ;
    int realcarddiffmin = diffcounttime - realcarddiffhour*60 ;
    realdiffhourstr = "" ;
    if(realcarddiffhour<10) realdiffhourstr = Util.add0(realcarddiffhour,2)  ;
    else realdiffhourstr = ""+ realcarddiffhour  ;
    String realcarddifftimestr = realdiffhourstr + ":" + Util.add0(realcarddiffmin,2) ;

    rs2.executeSql(" select diffid from HrmScheduleMaintance where id = " + diffid );	
    if(rs2.next()) difftypeid =   Util.null2String(rs2.getString("diffid"));
    String diffname = Util.toScreen(ScheduleDiffComInfo.getDiffname(difftypeid),user.getLanguage()) ;

    String fontcolor = "" ;
    if( difftype.equals("0") ) fontcolor = "blue" ;
    else fontcolor = "red" ;
    
    if(line%2==0){ 
      line++; 
%>
    <tr class=datalight>  
<%}else{ line++;%><tr class=datadark> <%}%>      
      
      <td>
       <font color=<%=fontcolor%>><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></font>
      </td>

      <td>
       <font color=<%=fontcolor%>><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(resourceid)),user.getLanguage())%></font>
      </td>

      <td>
       <font color=<%=fontcolor%>><%=diffdate%></font>
      </td>

      <td>
       <font color=<%=fontcolor%>><%=intime%></font>
      </td>

      <td>
       <font color=<%=fontcolor%>><%=outtime%></font>
      </td>

      <td><nobr>
       <font color=<%=fontcolor%>><%=theintime%><%=theouttime%></font>
      </td>

      <td>
      <%if( diffname.equals("")){%><a href="HrmScheduleMaintanceAdd.jsp?worktimeid=<%=id%>&resourceid=<%=resourceid%>&resourceidpar=<%=resourceidpar%>&counttime=<%=counttime%>&startdate=<%=diffdate%>&enddate=<%=diffdate%>&fromdate=<%=fromdate%>&theenddate=<%=enddate%>&departmentid=<%=departmentidpar%>&isself=<%=isself%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></a><%} else{%> <a href="HrmScheduleMaintanceEdit.jsp?id=<%=diffid%>&fromdate=<%=fromdate%>&theenddate=<%=enddate%>&worktimeid=<%=id%>&resourceidpar=<%=resourceidpar%>&startdate=<%=diffdate%>&enddate=<%=diffdate%>&departmentid=<%=departmentidpar%>&isself=<%=isself%>"><%=diffname%></a><%}%>
      </td>
      <td>
      <%=realdifftimestr%>
      </td>
      <td>
      <%if( !diffname.equals("")){%><%=realcarddifftimestr%><%}%>
      </td>
    </tr>
<%
 
}

%>
</tbody>
</table>
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
 frmmain.submit();
}
</script>
<script language=vbs>
sub onShowResourceID(spanname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputename.value=id(0)
	else 
	spanname.innerHtml = ""
	inputename.value=""
	end if
	end if
end sub

sub onShowDepartment(spanname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputename.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	spanname.innerHtml = id(1)
	inputename.value=id(0)
	else
	spanname.innerHtml = ""
	inputename.value=""
	end if	
	end if
end sub
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>