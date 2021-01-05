
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<%@ page import = "weaver.general.Util,weaver.file.*,java.util.*" %>
<%@ page import = "" %>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "DepartmentComInfo" class = "weaver.hrm.company.DepartmentComInfo" scope = "page"/>
<jsp:useBean id = "ResourceComInfo" class = "weaver.hrm.resource.ResourceComInfo" scope = "page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<HTML><HEAD>
<LINK href = "/css/Weaver_wev8.css" type = text/css rel = STYLESHEET>
<SCRIPT language = "javascript" src = "/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16673,user.getLanguage()); 
String needfav = "1" ; 
String needhelp = "" ; 

String fromdate = Util.fromScreen(request.getParameter("fromdate") , user.getLanguage()) ; //排班日期从
String enddate = Util.fromScreen(request.getParameter("enddate") , user.getLanguage()) ; //排班日期到
String department = Util.fromScreen(request.getParameter("department") , user.getLanguage()) ; //部门
String status = Util.fromScreen(request.getParameter("status") , user.getLanguage()) ; //人力资源状态
String isself = Util.null2String(request.getParameter("isself"));
int selectcolcount = 0 ;

if( status.equals("") ) status = "8" ;

Calendar thedate = Calendar.getInstance() ; //

// 如果用户选择的开始日期或者结束日期为空，则默认为当天算一周内的时间 
if( fromdate.equals("") || enddate.equals("")) {
    enddate = Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
              Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
              Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 

    thedate.add(Calendar.DATE , -7) ; 
    fromdate = Util.add0(thedate.get(Calendar.YEAR), 4) + "-" + 
               Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
               Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
} 

// 将开始日期到结束日期的每一天及其对应的星期放入缓存
ArrayList selectdates = new ArrayList() ; 
ArrayList selectweekdays = new ArrayList() ; 

// 得到选定人力资源范围和时间范围内的所有打卡信息放入缓存，以人力资源加时间作为索引
ArrayList reesourcetimecarddates = new ArrayList() ; 
ArrayList reesourcetimecardinfos = new ArrayList() ; 
ArrayList reesourcetimecardlegals = new ArrayList() ; 

String sql = "" ;

if(isself.equals("1")) {

    // 将开始日期到结束日期的每一天及其对应的星期放入缓存
    int fromyear = Util.getIntValue(fromdate.substring(0 , 4)) ; 
    int frommonth = Util.getIntValue(fromdate.substring(5 , 7)) ; 
    int fromday = Util.getIntValue(fromdate.substring(8 , 10)) ; 
    String tempdate = fromdate ; 

    thedate.set(fromyear,frommonth - 1 , fromday) ; 

    while( tempdate.compareTo(enddate) <= 0 ) {
        selectdates.add(tempdate) ; 
        selectweekdays.add("" + thedate.get(Calendar.DAY_OF_WEEK)) ; 

        thedate.add(Calendar.DATE , 1) ; 
        tempdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                    Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                    Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
    }

    selectcolcount = selectdates.size() + 1 ; // 列数

    String sqlwhere1="";
    String sqlwhere2="";

    if(status.equals("8")) { 
        sqlwhere1 += " and b.status in (0,1,2,3 ) " ;
        sqlwhere2 += " and status in (0,1,2,3 ) " ;
    } 
    else {
        if( !status.equals("9") )  {
            sqlwhere1 += " and b.status = " + status  ; 
            sqlwhere2 += " and status = " + status  ; 
        }
    }

    if(!fromdate.equals("")) { 
        sqlwhere1 += " and carddate >='" + fromdate + "'" ; 
    } 

    if(!enddate.equals("")) { 
        sqlwhere1 += " and carddate <='" + enddate + "'" ; 
    } 

    if(!department.equals("")) { 
        sqlwhere1 += " and b.departmentid = " + department ; 
        sqlwhere2 +=  " and departmentid = " + department ; 
    } 

    sql = " select id from hrmresource where (accounttype is null or accounttype=0) and status != 10 " + sqlwhere2 + " order by departmentid " ; 


    // 得到选定人力资源范围和时间范围内的所有打卡信息放入缓存，以人力资源加时间作为索引

    RecordSet.executeSql(" select a.* from HrmRightCardInfo a , Hrmresource b where a.resourceid = b.id and b.status != 10 " + sqlwhere1 + " order by a.resourceid , a.carddate , a.cardtime " ) ; 

    while( RecordSet.next() ) { 
        String resourceid = Util.null2String(RecordSet.getString("resourceid")) ; 
        String timecarddate = Util.null2String(RecordSet.getString("carddate")) ; 
        String cardtime = Util.null2String(RecordSet.getString("cardtime")) ; 
        String islegal = Util.null2String(RecordSet.getString("islegal")) ;
        
        int timecardindex = reesourcetimecarddates.indexOf(resourceid + "_" + timecarddate ) ;

        if( timecardindex == -1 ) {
            reesourcetimecarddates.add(resourceid + "_" + timecarddate) ; 
            reesourcetimecardinfos.add( cardtime ) ; 
            reesourcetimecardlegals.add( islegal ) ; 
        }
        else {
            String tempcardtime = (String)reesourcetimecardinfos.get(timecardindex) ;
            tempcardtime += "<br>" + cardtime ;
            reesourcetimecardinfos.set(timecardindex , tempcardtime) ;
        }
    } 
}

// 导出EXCEL 
ExcelFile.init ();
String filename = SystemEnv.getHtmlLabelName(16673,user.getLanguage());
ExcelFile.setFilename(filename+fromdate+"_"+enddate) ;

// 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
es.setAlign(ExcelStyle.WeaverHeaderAlign) ;

ExcelSheet et = ExcelFile.newExcelSheet(filename) ;

// 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
et.addColumnwidth(8000) ;
%>
<BODY>
<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<form id = frmmain name = frmmain method = post action="HrmRpTimecard.jsp">
<input type="hidden" name="operation" value=save>
<input type="hidden" name="isself" value="1">

<table class = viewform>
<tbody>
<TR CLASS = spacing><TD colspan = 6 class = sep2></TD></TR>
<tr>
    <TD width=10%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD class = Field>
    <input class=wuiBrowser id=department type=hidden name=department value="<%=department%>" 
	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	_displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>"
	>
    </TD>
    <td width=10%><%=SystemEnv.getHtmlLabelName(15842,user.getLanguage())%></td>
    <td class = field>
    <SELECT class=inputStyle id=status name=status value="<%=status%>">
       <OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>        
       <OPTION value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></OPTION>
       <OPTION value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></OPTION>
       <OPTION value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
       <OPTION value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></OPTION>
       <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
       <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
       <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
       <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
       <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>                   
     </SELECT>  
    </td>
    <td width=10%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
    <td class = field>
    <BUTTON type=button class = calendar id = SelectDate onclick = getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
    <SPAN id = fromdatespan><%=fromdate%></SPAN>
    <input type = "hidden" name = "fromdate" value=<%=fromdate%>>
    －<BUTTON  type=button class = calendar id = SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=enddate%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
</tr>
</tbody>
</table>

<% if(isself.equals("1")) { %>
<TABLE class = ListStyle cellspacing=1>
  <TBODY>
  <TR class = Header>
    <TH colspan=<%=selectcolcount%>><%=SystemEnv.getHtmlLabelName(16673,user.getLanguage())%><font color=red>(<%=SystemEnv.getHtmlLabelName(18947,user.getLanguage())%>)</font></TH>
  </TR>
  
  <TR class = Header>
    <TH><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>
  <%
  // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
    et.addColumnwidth(8000) ;

    ExcelRow er = null ;
    er = et.newExcelRow() ;
    er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()), "Header" ) ; 
    
    for(int i = 0 ; i < selectdates.size() ; i++ ) { 
        String thetempdate = (String) selectdates.get(i) ; 
        int thetempweekday = Util.getIntValue( (String) selectweekdays.get(i) ) ; 
        // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度
        et.addColumnwidth(4000) ;
  %>
    <TH><%=thetempdate%><br>
        <% if( thetempweekday == 1 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(398,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%>
        <% } else if( thetempweekday == 2 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(392,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%>
        <% } else if( thetempweekday == 3 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(393,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%>
        <% } else if( thetempweekday == 4 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(394,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%>
        <% } else if( thetempweekday == 5 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(395,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%>
        <% } else if( thetempweekday == 6 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(396,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%>
        <% } else if( thetempweekday == 7 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(397,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%>
        <% } %>
    </TH>
  <% } %>
    </TR>

  <%
    boolean isLight = false ; 
    RecordSet.executeSql(sql) ; 
    while(RecordSet.next()) { 	
        er = et.newExcelRow() ;
        String resourceid = Util.null2String(RecordSet.getString("id")) ; 
        er.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(resourceid) , user.getLanguage())) ; 
        isLight = !isLight ;
        
  %> 
       <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
        <TD><nobr><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid) , user.getLanguage())%>
            <input type = hidden name = "selectresource" value="<%=resourceid%>" >
        </TD>
  <%
        for(int j = 0 ; j < selectdates.size() ; j++ ) {
            String thetempdate = (String) selectdates.get(j) ; 
  %>
        <TD>
  <%        String inouttime = "" ; 
            boolean islegaltime = false ;  
            int inouttimeindex = reesourcetimecarddates.indexOf(resourceid + "_" + thetempdate) ; 
            if( inouttimeindex != -1 ) {
                inouttime = (String) reesourcetimecardinfos.get(inouttimeindex) ; 
                islegaltime = ((String)reesourcetimecardlegals.get(inouttimeindex)).equals("2") ; // 非法
            }
            er.addStringValue(inouttime) ;
  %>
      <% if(islegaltime) {%><font color=red><%}%><%=inouttime%><% if(!islegaltime) {%></font><%}%>
     </TD>
  <% } %>
     </TR> 
  <% } %>
  </TBODY>
 </TABLE>
 <%}%>
 </form>
 <BR>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>  
function submitData() {
 jQuery("#frmmain").submit();
}
</script>

<script language = vbs>  
sub onShowDepartment(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputname.value)
	if Not isempty(id) then
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
</HTML>