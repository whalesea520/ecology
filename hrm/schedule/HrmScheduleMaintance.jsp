<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
if(!HrmUserVarify.checkUserRight("HrmScheduleMaintanceView:View", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ScheduleDiffComInfo" class="weaver.hrm.schedule.HrmScheduleDiffComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6138,user.getLanguage());
String needfav ="1";
String needhelp ="";

Calendar todaycal = Calendar.getInstance ();
String year = Util.add0(todaycal.get(Calendar.YEAR),4);
int month = todaycal.get(Calendar.MONTH)+1;

boolean CanAdd = HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add", user);

String rightlevel = HrmUserVarify.getRightLevel("HrmScheduleMaintanceView:View" , user ) ;

// 进入即可搜索， 刘煜后修改
// String isself = Util.null2String(request.getParameter("isself"));


String isself = "1" ;


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
boolean isoracle = RecordSet.getDBType().equals("oracle") ;

int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
int perpage = 10;
int numcount = 0;
boolean hasnext = false;
String temptable = "" ;

String  sqlwhere ="";

if(sqlwhere.equals("")&&startdatefrom.equals("")&&startdateto.equals("")){
   startdatefrom = year+"-"+Util.add0(month,2)+"-01";
   startdateto = year+"-"+Util.add0(month,2)+"-31";
}

if(isself.equals("1")) {
    


    int ishead = 0;

    if(!sqlwhere.equals("")) ishead = 1;

    if(!resourceidpar.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where t1.resourceid=" + Util.fromScreen2(resourceidpar,user.getLanguage()) +" ";
        }
        else 
            sqlwhere += " and t1.resourceid =" + Util.fromScreen2(resourceidpar,user.getLanguage()) +" ";
    }


    if(!departmentid.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where t1.resourceid in (select id from HrmResource where departmentid = " + Util.fromScreen2(departmentid,user.getLanguage()) +") ";
        }
        else 
            sqlwhere += " and t1.resourceid in (select id from HrmResource where departmentid = " + Util.fromScreen2(departmentid,user.getLanguage()) +") ";
    }

    if(!diffidpar.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where t1.diffid =" + Util.fromScreen2(diffidpar,user.getLanguage()) +" ";
        }
        else 
            sqlwhere += " and t1.diffid =" + Util.fromScreen2(diffidpar,user.getLanguage()) +" ";
    }

    if(!startdatefrom.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where t1.startdate >='" + Util.fromScreen2(startdatefrom,user.getLanguage()) +"' ";
        }
        else 
            sqlwhere += " and t1.startdate >='" + Util.fromScreen2(startdatefrom,user.getLanguage()) +"' ";
    }
    if(!startdateto.equals("")){
        if(ishead==0){
            ishead = 1;
            if(isoracle){
                sqlwhere += " where (t1.startdate is not null and t1.startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
            }else{
                sqlwhere += " where (t1.startdate <> '' and t1.startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
            }
        }
        else 
            if(isoracle){
                sqlwhere += " and (t1.startdate is not null and t1.startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
            }else{
                sqlwhere += " and (t1.startdate<>'' and t1.startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
            }
    }
    if(!enddatefrom.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where t1.enddate >='" + Util.fromScreen2(enddatefrom,user.getLanguage()) +"' ";
        }
        else 
            sqlwhere += " and t1.enddate >='" + Util.fromScreen2(enddatefrom,user.getLanguage()) +"' ";
    }
    if(!enddateto.equals("")){
        if(ishead==0){
            ishead = 1;
            if(isoracle){
                sqlwhere += " where (t1.enddate is not null and t1.enddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
            }else{
                sqlwhere += " where (t1.enddate <> '' and t1.enddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
            }
        }
        else 
            if(isoracle){
                sqlwhere += " and (t1.enddate is not null and t1.enddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
            }else{
                sqlwhere += " and (t1.enddate<>'' and t1.enddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
            }
    }

    if(!starttimefrom.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where t1.starttime >='" + Util.fromScreen2(starttimefrom,user.getLanguage()) +"' ";
        }
        else 
            sqlwhere += " and t1.starttime >='" + Util.fromScreen2(starttimefrom,user.getLanguage()) +"' ";
    }
    if(!starttimeto.equals("")){
        if(ishead==0){
            ishead = 1;
            if(isoracle){
                sqlwhere += " where (t1.starttime is not null and t1.starttime <='" + Util.fromScreen2(starttimeto,user.getLanguage()) +"') ";
            }else{
                sqlwhere += " where (t1.starttime <> '' and t1.starttime <='" + Util.fromScreen2(starttimeto,user.getLanguage()) +"') ";
            }
        }
        else 
            if(isoracle){
                sqlwhere += " and (t1.starttime is not null and t1.starttime <='" + Util.fromScreen2(starttimeto,user.getLanguage()) +"') ";
            }else{
                sqlwhere += " and (t1.starttime<>'' and t1.starttime <='" + Util.fromScreen2(starttimeto,user.getLanguage()) +"') ";
            }
    }
    if(!endtimefrom.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where t1.endtime >='" + Util.fromScreen2(endtimefrom,user.getLanguage()) +"' ";
        }
        else 
            sqlwhere += " and t1.endtime >='" + Util.fromScreen2(endtimefrom,user.getLanguage()) +"' ";
    }
    if(!endtimeto.equals("")){
        if(ishead==0){
            ishead = 1;
            if(isoracle){		
                sqlwhere += " where (t1.endtime is not null and t1.endtime <='" + Util.fromScreen2(endtimeto,user.getLanguage()) +"') ";
            }else{
                sqlwhere += " where (t1.endtime <> '' and t1.endtime <='" + Util.fromScreen2(endtimeto,user.getLanguage()) +"') ";
            }
        }
        else 
            if(isoracle){			
                sqlwhere += " and (t1.endtime is not null and t1.endtime <='" + Util.fromScreen2(endtimeto,user.getLanguage()) +"') ";
            }else{
                sqlwhere += " and (t1.endtime<>'' and t1.endtime <='" + Util.fromScreen2(endtimeto,user.getLanguage()) +"') ";
            }
    }

    if(rightlevel.equals("0") ) {
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where t1.resourceid in (select id from HrmResource where departmentid = " + user.getUserDepartment()  + ") ";
        }
        else 
            sqlwhere += " and t1.resourceid in (select id from HrmResource where departmentid = " + user.getUserDepartment() +") ";
    }
    else if(rightlevel.equals("1") ) {
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where t1.resourceid in (select id from HrmResource where subcompanyid1 = " + user.getUserSubCompany1()  + ") ";
        }
        else 
            sqlwhere += " and t1.resourceid in (select id from HrmResource where subcompanyid1 = " + user.getUserSubCompany1() +") ";
    }


    
    String sqlnum = "select count(id) from HrmScheduleMaintance t1"+sqlwhere;  
    RecordSet.executeSql(sqlnum);
    RecordSet.next();
    numcount = RecordSet.getInt(1);

}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/schedule/HrmScheduleMaintanceAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmScheduleMaintance:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+79+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{-}" ;	
if(pagenum>1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:pageup(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(hasnext){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:pagedown(),_self} " ;
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
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=frmmain name=frmmain method=post action="HrmScheduleMaintance.jsp">
<input type="hidden" name="isself" value="1">
<table class=Viewform>
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
  <TR class=Spacing style="height:2px">
    <TD class=Line1 colSpan=6 ></TD>
  </TR>
  <tr>
    <td> 
      <%=SystemEnv.getHtmlLabelName(6139,user.getLanguage())%>    
    </td>
    <td class=field>

      <input class="wuiBrowser" type=hidden name=diffid value="<%=diffidpar%>"
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp"
	  _displayText="<%=ScheduleDiffComInfo.getDiffname(diffidpar)%>">
    </td>    
    <td>
     <%=SystemEnv.getHtmlLabelName(16055,user.getLanguage())%>
    </td>
    <td class=field>

      <input class="wuiBrowser" type=hidden name=resourceid value="<%=resourceidpar%>" 
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	  _displayTemplate="<A target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
	  _displayText="<%=ResourceComInfo.getResourcename(resourceidpar)%>">
    </td>
    <td>
     <%=SystemEnv.getHtmlLabelName(16050,user.getLanguage())%>
    </td>
    <td class=field>

      <input class="wuiBrowser" type=hidden name=departmentid value="<%=departmentid%>"
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	  _displayText="<%=DepartmentComInfo.getDepartmentname(departmentid)%>">
    </td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
  <tr>
    <td>
      <%=SystemEnv.getHtmlLabelName(16037,user.getLanguage())%>
    </td>
    <td class=field>
       <BUTTON class=Calendar type="button" id=selectstartdatefrom onclick="getDate(startdatefromspan,startdatefrom)"></BUTTON> 
       <SPAN id=startdatefromspan ><%=startdatefrom%></SPAN>
        -&nbsp;
       <BUTTON class=Calendar type="button" id=selectstartdateto onclick="getDate(startdatetospan,startdateto)"></BUTTON> 
       <SPAN id=startdatetospan ><%=startdateto%></SPAN> 
       <input class=inputstyle type="hidden" name="startdatefrom" value="<%=startdatefrom%>">
       <input class=inputstyle type="hidden" name="startdateto" value="<%=startdateto%>">
    </td>
    <td>
      <%=SystemEnv.getHtmlLabelName(16038,user.getLanguage())%>
    </td>
    <td class=field  colspan=3>
       <BUTTON class=Calendar type="button" id=selectenddatefrom onclick="getDate(enddatefromspan,enddatefrom)"></BUTTON> 
       <SPAN id=enddatefromspan ><%=enddatefrom%></SPAN>
        -&nbsp;
       <BUTTON class=Calendar type="button" id=selectenddateto onclick="getDate(enddatetospan,enddateto)"></BUTTON> 
       <SPAN id=enddatetospan ><%=enddateto%></SPAN> 
       <input class=inputstyle type="hidden" name="enddatefrom" value="<%=enddatefrom%>">
       <input class=inputstyle type="hidden" name="enddateto" value="<%=enddateto%>">
    </td>
  </tr>  
  <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
  <tr>
    <td>
      <%=SystemEnv.getHtmlLabelName(16039,user.getLanguage())%>
    </td>
    <td class=field>
       <BUTTON class=Clock type="button" onclick="onShowTime(starttimefromspan,starttimefrom)"></BUTTON> 
       <SPAN id=starttimefromspan ><%=starttimefrom%></SPAN>
        -&nbsp;
       <BUTTON class=Clock type="button" onclick="onShowTime(starttimetospan,starttimeto)"></BUTTON> 
       <SPAN id=starttimetospan ><%=starttimeto%></SPAN> 
       <input class=inputstyle type="hidden" name="starttimefrom" value="<%=starttimefrom%>">
       <input class=inputstyle type="hidden" name="starttimeto" value="<%=starttimeto%>">
    </td>
    <td>
      <%=SystemEnv.getHtmlLabelName(16040,user.getLanguage())%>
    </td>
    <td class=field colspan=3>
       <BUTTON class=Clock type="button" onclick="onShowTime(endtimefromspan,endtimefrom)"></BUTTON> 
       <SPAN id=endtimefromspan ><%=endtimefrom%></SPAN> 
        -&nbsp;
       <BUTTON class=Clock type="button" onclick="onShowTime(endtimetospan,endtimeto)"></BUTTON> 
       <SPAN id=endtimetospan ><%=endtimeto%></SPAN> 
       <input class=inputstyle type="hidden" name="endtimefrom" value="<%=endtimefrom%>">
       <input class=inputstyle type="hidden" name="endtimeto" value="<%=endtimeto%>">
    </td>
  </tr>  
 <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
  </tbody>
</table>

  <% if(isself.equals("1")) { %> 
  	<table class=ListStyle cellspacing=1 > 
  		<tr> <td valign="top">  
  			<%  
  			String  tableString  =  "";  
  			String  backfields  =  "t1.id, t1.resourceid, t2.diffname, t3.lastname, t1.startdate, t1.starttime, t1.enddate, t1.endtime, t1.realdifftime, t1.realcarddifftime"; 
  			String  fromSql  = "from HrmScheduleMaintance t1, HrmScheduleDiff t2, HrmResource t3 ";  
  			String sqlmei = "and t1.diffid = t2.id  and t1.resourceid = t3.id"; 
  			String orderby  =  "t1.id";     
  			if(!sqlwhere.equals("")){      
  				sqlwhere += sqlmei;
  			}  
  			tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+      
  									 "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"t1.id\" sqlsortway=\"asc\"  sqlisdistinct=\"true\"  />"+   
  									 "<head>";   
  			tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(6139,user.getLanguage())+"\"  column=\"diffname\" orderkey=\"diffname\"/>";            
  			tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(16055,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" href=\"/hrm/resource/HrmResource.jsp\" linkkey=\"id\" linkvaluecolumn=\"resourceid\"  target=\"_fullwindow\" />"; 
        tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\"  column=\"startdate\" orderkey=\"t1.startdate\"/>";           
        tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"starttime\" orderkey=\"starttime\"/>";           
        tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(741,user.getLanguage())+"\" column=\"enddate\" orderkey=\"t1.enddate\"/>";  
        tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"endtime\" orderkey=\"endtime\"/>";     
        tableString+="<col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(16719,user.getLanguage())+"\" column=\"realdifftime\" orderkey=\"realdifftime\"/>";
        tableString+="<col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(16720,user.getLanguage())+"\" column=\"realcarddifftime\" orderkey=\"realcarddifftime\"/>";
        tableString+="</head>"; 
				String operateString= "<operates width=\"4%\">";
        operateString+=" <operate href=\"HrmScheduleMaintanceView.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>";
        operateString+="</operates>";
        tableString+=operateString;
	      tableString+="</table>";
        %> 
         
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
		</td>
	</tr>
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
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
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
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<script language=javascript>
function pageup(){
    document.frmmain.pagenum.value="<%=pagenum-1%>";    
    document.frmmain.action="HrmScheduleMaintance.jsp";
    document.frmmain.submit();
}
function pagedown(){
    document.frmmain.pagenum.value="<%=pagenum+1%>";    
    document.frmmain.action="HrmScheduleMaintance.jsp";
    document.frmmain.submit();
}
function submitData() {
    frmmain.submit();
}
</script>
</body>
</html>
