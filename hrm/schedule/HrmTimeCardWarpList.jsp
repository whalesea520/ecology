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
String titlename = SystemEnv.getHtmlLabelName(16887,user.getLanguage()) ; 
String needfav ="1";
String needhelp ="";


String resourceidpar = Util.null2String(request.getParameter("resourceid"));
String departmentidpar = Util.null2String(request.getParameter("departmentid"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));

String isself = Util.null2String(request.getParameter("isself"));           // 是否当页搜索

Calendar todaycal = Calendar.getInstance ();
String month = Util.add0(todaycal.get(Calendar.MONTH)+1,2);
String year = Util.add0(todaycal.get(Calendar.YEAR),4);

if(fromdate.equals("") && todate.equals("")) { 
  fromdate = year + "-" + month + "-01" ; 
  todate = year + "-" + month + "-31" ; 
} 

String sqlwhere = "";
ArrayList reesourceshifts = new ArrayList() ;

if(isself.equals("1")) {

    if(!resourceidpar.equals("")) { 
        sqlwhere += " and resourceid =" + Util.fromScreen2(resourceidpar , user.getLanguage()) + "" ; 
    } 

    if(!departmentidpar.equals("")) { 
        sqlwhere += " and resourceid in (select id from HrmResource where departmentid = " + Util.fromScreen2(departmentidpar , user.getLanguage()) +")" ; 
    } 

    if(!fromdate.equals("")) { 
        sqlwhere += " and carddate >='" + fromdate + "'" ; 
    } 

    if(!todate.equals("")) { 
        sqlwhere += " and carddate <='" + todate + "'" ; 
    } 



    // 得到按照排班来管理的所有人员
     
    rs.executeSql("  select resourceid from HrmArrangeShiftSet "  ) ; 
    while( rs.next() ) { 
        String resourceid = Util.null2String(rs.getString("resourceid")) ; 
        reesourceshifts.add( resourceid ) ; 
    } 
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15846,user.getLanguage())+",javascript:recreateData(),_self} " ;
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
<FORM id=frmmain name=frmmain method=post action="HrmTimeCardWarpList.jsp">
<input class=inputstyle type="hidden" name="id">
<input class=inputstyle type="hidden" name="operation">
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
       <BUTTON class=Calendar  type="button" id=selectfromdate onclick="getDate(fromdatespan,fromdate)"></BUTTON> 
       <SPAN id=fromdatespan ><%=fromdate%></SPAN>
       <input class=inputstyle type="hidden" name="fromdate" value="<%=fromdate%>">
       -<BUTTON class=Calendar type="button" id=selecttodate onclick="getDate(todatespan,todate)"></BUTTON> 
       <SPAN id=todatespan ><%=todate%></SPAN> 
       <input class=inputstyle type="hidden" name="todate" value="<%=todate%>">
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

<% if(isself.equals("1")) { %>
<table class=ListStyle cellspacing=1 >
<colgroup>  
  <col width="20%">
  <col width="20%">
  <col width="35%">
  <col width="25%">
<tbody>
<tr class=header>  
  <td><%=SystemEnv.getHtmlLabelName(16703,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(16886,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(15090,user.getLanguage())%></td>
</tr>

<%
  boolean isLight = false ;
  String theresourcecardate = "" ;  // 判断是否是新的一个人一天
  String thecardtime = "" ;  // 一个人一天的所有打卡记录 ，多个用<br> 分开
  String theshiftname = "" ;
  String id = "" ;
  String resourceid = "" ;
  String carddate =   "" ;
  String cardtime =   "" ;
  String tempresourcecardate = "" ;
  
  String sql = "select * from HrmRightCardInfo where islegal = 2 and workout=0 " + sqlwhere + " order by carddate desc , resourceid , cardtime  ";  
  
  rs.executeSql(sql);	
  while(rs.next()){
  
    id = Util.null2String(rs.getString("id"));
    resourceid = Util.null2String(rs.getString("resourceid"));
    carddate =   Util.null2String(rs.getString("carddate"));
    cardtime =   Util.null2String(rs.getString("cardtime"));
    tempresourcecardate = resourceid+"_"+ carddate ;

    if( theresourcecardate.equals("") ) theresourcecardate = tempresourcecardate ;

    if( !tempresourcecardate.equals(theresourcecardate) ) {
        if( !thecardtime.equals("") ) {
            String theresourcecardates[] = Util.TokenizerString2(theresourcecardate , "_" ) ;
            String oldresourceid = theresourcecardates[0] ;
            String oldcarddate = theresourcecardates[1] ;
            int shiftindex = reesourceshifts.indexOf(oldresourceid) ; 
            if( shiftindex != -1 ) {
                rs2.executeSql( "select shiftname from HrmArrangeShift a , HrmArrangeShiftInfo b where a.id = b.shiftid and b.resourceid = " + oldresourceid + " and shiftdate = '" + oldcarddate +"' " ) ;
                while(rs2.next()) {
                    String tempshiftname = Util.toScreen(rs2.getString("shiftname") , user.getLanguage()) ; 
                    if( theshiftname.equals("") ) theshiftname = tempshiftname ;
                    else theshiftname += "<br>" + tempshiftname ;
                }
            }
            else theshiftname = SystemEnv.getHtmlLabelName(16687,user.getLanguage()) ;
            isLight = !isLight ; 
%>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
      <td><%=oldcarddate%></td>
      <td><%=Util.toScreen(ResourceComInfo.getResourcename(oldresourceid),user.getLanguage())%></td>
      <td><%=thecardtime%></td>
      <td><%=theshiftname%></td>
    </tr>
<%
        }
        // 不同人天初始化
        theresourcecardate = tempresourcecardate ;
        theshiftname = "" ;
        thecardtime = cardtime + "&nbsp;&nbsp;<a onclick='doDelete("+id+")' style='CURSOR:HAND'>"+ SystemEnv.getHtmlLabelName(91,user.getLanguage()) +"</a>&nbsp;&nbsp;&nbsp;&nbsp;<a onclick='doWorkOut("+id+")' style='CURSOR:HAND'>"+ SystemEnv.getHtmlLabelName(6151,user.getLanguage()) +"</a>" ;
    }
    else {
        if( thecardtime.equals("") ) { 
            thecardtime = cardtime + "&nbsp;&nbsp;<a onclick='doDelete("+id+")' style='CURSOR:HAND'>"+ SystemEnv.getHtmlLabelName(91,user.getLanguage()) +"</a>&nbsp;&nbsp;&nbsp;&nbsp;<a onclick='doWorkOut("+id+")' style='CURSOR:HAND'>"+ SystemEnv.getHtmlLabelName(6151,user.getLanguage()) +"</a>" ;
        }
        else {
            thecardtime += "<br><br>" + cardtime + "&nbsp;&nbsp;<a onclick='doDelete("+id+")' style='CURSOR:HAND'>"+ SystemEnv.getHtmlLabelName(91,user.getLanguage()) +"</a>&nbsp;&nbsp;&nbsp;&nbsp;<a onclick='doWorkOut("+id+")' style='CURSOR:HAND'>"+ SystemEnv.getHtmlLabelName(6151,user.getLanguage()) +"</a>" ;
        }
    }
  }
  if( !tempresourcecardate.equals("") ) {
      isLight = !isLight ; 
      int shiftindex = reesourceshifts.indexOf(resourceid) ; 
      if( shiftindex != -1 ) {
          rs2.executeSql( "select shiftname from HrmArrangeShift a , HrmArrangeShiftInfo b where a.id = b.shiftid and b.resourceid = " + resourceid + " and shiftdate = '" + carddate +"' " ) ;
          while(rs2.next()) {
              String tempshiftname = Util.toScreen(rs2.getString("shiftname") , user.getLanguage()) ; 
              if( theshiftname.equals("") ) theshiftname = tempshiftname ;
              else theshiftname += "<br>" + tempshiftname ;
          }
      }
      else theshiftname = SystemEnv.getHtmlLabelName(16687,user.getLanguage()) ;
%>
<TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
  <td><%=carddate%></td>
  <td><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></td>
  <td><%=thecardtime%></td>
  <td><%=theshiftname%></td>
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
<td height="10" colspan="3"></td>
</tr>
</table>
<script language=javascript>  
function doDelete(theid){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7 , user.getLanguage())%>")) {
        document.frmmain.isself.value="<%=isself%>";
        document.frmmain.operation.value = "delete" ;
        document.frmmain.action = "HrmTimeCardWarpOperation.jsp" ; 
		document.frmmain.id.value = theid ; 
		document.frmmain.submit() ; 
	} 
} 

function doWorkOut(theid){
	if(confirm("<%=SystemEnv.getHtmlLabelName(83872,user.getLanguage())%>")) {
        document.frmmain.isself.value="<%=isself%>";
        document.frmmain.operation.value = "workout" ;
        document.frmmain.action = "HrmTimeCardWarpOperation.jsp" ; 
		document.frmmain.id.value = theid ; 
		document.frmmain.submit() ; 
	} 
} 

function recreateData() {
    document.frmmain.isself.value="<%=isself%>";
    document.frmmain.action = "HrmTimeCardWarpCreate.jsp" ; 
    document.frmmain.submit();
}


function submitData() {
  document.frmmain.submit();
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