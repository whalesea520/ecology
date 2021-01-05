<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>


<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ConditionComInfo" class="weaver.datacenter.ConditionComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String outrepid = Util.null2String(request.getParameter("outrepid"));
String userid = "" + user.getUID();
String usertype = user.getLogintype() ;


// 报表基本信息
rs.executeProc("T_OutReport_SelectByOutrepid",""+outrepid);
rs.next() ;

String outrepname = Util.toScreenToEdit(rs.getString("outrepname"),user.getLanguage()) ;
String outrepenname = Util.null2String(rs.getString("outrepenname")) ;
String outrepdesc = Util.toScreenToEdit(rs.getString("outrepdesc"),user.getLanguage()) ;
String outrependesc = Util.null2String(rs.getString("outrependesc")) ;
String outreprow = Util.null2String(rs.getString("outreprow")) ;
String outrepcolumn = Util.null2String(rs.getString("outrepcolumn")) ;
String outrepcategory = Util.null2String(rs.getString("outrepcategory")) ;

// 刘煜 2004 年10月23 日增加模板文件自适应行高和列宽
String autocolumn = Util.null2String(rs.getString("autocolumn")) ;  //列宽
String autorow = Util.null2String(rs.getString("autorow")) ;  //行高



Calendar today = Calendar.getInstance();
String currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
String currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2) ;
String currentday = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String currentdate = currentyear + "-" + currentmonth + "-" + currentday ;

today.add(Calendar.DATE, -1) ;
String lastyear = Util.add0(today.get(Calendar.YEAR), 4) ;
String lastmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2) ;
String lastday = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;



// 该报表的条件

ArrayList  tempfieldnames = new ArrayList() ;

rs.executeProc("T_OutRC_SelectByOutrepid",""+outrepid);
while(rs.next()) {
    String tempconditionid = Util.null2String(rs.getString("conditionid")) ;
    String tempfieldname = ConditionComInfo.getConditionitemfieldnames(tempconditionid) ;
    tempfieldnames.add(tempfieldname) ;
}

ArrayList  conditionids = new ArrayList() ;
ArrayList  issystemdefs = new ArrayList() ;
ArrayList  conditionnames = new ArrayList() ;
ArrayList  fieldnames = new ArrayList() ;
ArrayList  conditiontypes = new ArrayList() ;


rs.beforFirst() ; 
while(rs.next()) {
    String tempconditionid = Util.null2String(rs.getString("conditionid")) ;
    String conditioncnname = Util.null2String(rs.getString("conditioncnname")) ;
    String conditionenname = Util.null2String(rs.getString("conditionenname")) ;

    String issystemdef = Util.null2String(ConditionComInfo.getIssystemdef(tempconditionid)) ;
    String conditionname = Util.toScreen(ConditionComInfo.getConditionname(tempconditionid),user.getLanguage()) ;
    String tempfieldname = ConditionComInfo.getConditionitemfieldnames(tempconditionid) ;
    String tempconditiontype = ConditionComInfo.getConditiontype(tempconditionid) ;

    if(!conditioncnname.equals("")) conditionname = conditioncnname ;
    if(user.getLanguage() == 8 && !conditionenname.equals("")) conditionname = conditionenname ;

    conditionids.add(tempconditionid) ;
    issystemdefs.add(issystemdef) ;
    conditionnames.add(conditionname) ;
    fieldnames.add(tempfieldname) ;
    conditiontypes.add(tempconditiontype) ;
}



String imagefilename = "/images/hdCRMAccount.gif";
String titlename = "" ;
if(user.getLanguage() == 7 || outrependesc.equals("")) titlename = outrepdesc ; 
else titlename = outrependesc ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15774,user.getLanguage())+",OutReportSelDefine.jsp?outrepid="+outrepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(73,user.getLanguage())+",/datacenter/maintenance/outreport/ReportSearchModule.jsp?outrepid="+outrepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if( outrepcategory.equals("1") || outrepcategory.equals("2") ) {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(16901,user.getLanguage())+",OutReportStat.jsp?outrepid="+outrepid+"&outrepcategory="+outrepcategory+",_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

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


<TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="70%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%></TH></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="3" ></TD></TR> 
<%

String sql=" select * from outrepmodule where outrepid = " + outrepid + " and userid=0 and usertype=0 " ;

//String sql=" select * from outrepmodule where outrepid = " + outrepid + " and userid= "+userid+" and usertype = " + usertype ;

boolean isLight = false;
rs.executeSql(sql);
while(rs.next()){
    String id=Util.null2String(rs.getString("id")) ;
    String modulename=Util.null2String(rs.getString("modulename")) ;
    String moduleenname=Util.null2String(rs.getString("moduleenname")) ;
    if(user.getLanguage() == 8 && !moduleenname.equals("")) modulename = moduleenname ;
    isLight = ! isLight ;
%>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <TD colspan="3" >
    <form id="search<%=id%>" name="search<%=id%>" action="OutReportSearchTemp.jsp" method=post>
    <input type="hidden" name="outrepid" value="<%=outrepid%>">
    <input type="hidden" name="moduleid" value="<%=id%>">
    <input type="hidden" name="modulename" value="<%=modulename%>">
    <input type="hidden" name="outrepcategory" value="<%=outrepcategory%>">
    
    <!-- 刘煜 2004 年10月23 日增加模板文件自适应行高和列宽-->
    <input type="hidden" name="autocolumn" value="<%=autocolumn%>">
    <input type="hidden" name="autorow" value="<%=autorow%>">
    

    <table width=100%>
    <COLGROUP>
    <COL width="20%">
    <COL width="70%">
    <COL width="10%">
    <TBODY>
    <tr>
    <TD><%=modulename%></TD>
    <TD>
    <!--  其它条件设置 -->
    <TABLE class=viewform>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
    <%  
        ArrayList  userdefconditionids = new ArrayList() ;
        rs1.executeSql("select conditionid from modulecondition where moduleid = " + id + " and isuserdefine=1");
        while(rs1.next() ) {
            userdefconditionids.add(Util.null2String(rs1.getString("conditionid"))) ;
        }

        boolean notfromdate = true ;
        boolean nottodate = true ;
        int countcrm = 0 ;    // 如果是客户查询， 只显示一组crm

        for(int k=0 ; k< conditionids.size() ; k++ ) {
            String tempconditionid = (String)conditionids.get(k) ;
            if( userdefconditionids.indexOf(tempconditionid) == -1 ) continue ;
            String issystemdef = (String)issystemdefs.get(k) ;
            String conditionname = (String)conditionnames.get(k) ;
            String tempfieldname = (String)fieldnames.get(k) ;
            String tempconditiontype = (String)conditiontypes.get(k) ;
     
            if(!issystemdef.equals("1")) {
      %>
        <TR>
          <TD><%=conditionname%></TD>
          <TD>
		  <%    if(tempconditiontype.equals("1")) { %>
          <INPUT type=text class="InputStyle" size=50 name="<%=tempfieldname%>">
          <%    } else { %>
		  <select class="InputStyle" name="<%=tempfieldname%>" style="width:30%">
		  <% 
                    rs1.executeProc("T_CDetail_SelectByConditionid",tempconditionid);
                    while(rs1.next()) {
                        String conditiondsp = Util.null2String(rs1.getString("conditiondsp")) ;
                        String conditionendsp = Util.null2String(rs1.getString("conditionendsp")) ;
                        if(user.getLanguage() == 8 && !conditionendsp.equals("")) conditiondsp = conditionendsp ;
                        String conditionvalue = Util.null2String(rs1.getString("conditionvalue")) ;
		  %>
          <option value="<%=conditionvalue%>"><%=conditiondsp%></option>
		  <%        } %>
		  </select>
          <%    } %>
          </td>
        </tr><TR><TD class=Line colSpan=2></TD></TR> 
       <%   } else {              // issystemdef = 1 
                if(tempfieldname.indexOf("crm") == 0) {
                    if( countcrm < 1 ) {
       %>
        <TR>
          <TD><%=conditionname%></TD>
          
          <td> 
            <% if(usertype.equals("2")) { countcrm ++ ; %>
            <%=user.getUsername()%>
            <input type="hidden" name="crm" value="<%=user.getUID()%>">
            <input type="hidden" name="name_crm" value="<%=user.getUsername()%>">
            <%} else {%>
              <button class=Browser onClick="onShowCustomer(span_<%=tempfieldname%>_<%=id%>,<%=tempfieldname%>_<%=id%>,name_<%=tempfieldname%>_<%=id%>)"></button>
              <SPAN id="span_<%=tempfieldname%>_<%=id%>"></SPAN>
            <input type="hidden" id="<%=tempfieldname%>_<%=id%>" name="<%=tempfieldname%>">
            <input type="hidden" id="name_<%=tempfieldname%>_<%=id%>" name="name_<%=tempfieldname%>">
            <%}%></TD>
            </TR><TR><TD class=Line colSpan=2></TD></TR> 
        <%          }
                } 
                else if( notfromdate && (tempfieldname.equals("yearf") || tempfieldname.equals("monthf") || tempfieldname.equals("dayf")) ) {
                    notfromdate = false ;
        %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%></TD>
          <TD>
		<%          if(tempfieldnames.indexOf("yearf")>=0) { 
        %>
		  <select class="InputStyle" name="yearf"> 
		  <%            for(int i=5 ; i>-5;i--) {
                            int tempyear = Util.getIntValue(lastyear) - i ;
                            String selected = "" ;
                            if( i==0) selected = "selected" ;
		  %>
          <option value="<%=tempyear%>" <%=selected%>><%=tempyear%></option>
		  <%            } %>
		  </select><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;
          <%        } 
                    if(tempfieldnames.indexOf("monthf")>=0) { 
          %>
		  <select class="InputStyle" name="monthf">
          <option value="01" <%if(lastmonth.equals("01")) {%>selected<%}%>>1</option>
		  <option value="02" <%if(lastmonth.equals("02")) {%>selected<%}%>>2</option>
		  <option value="03" <%if(lastmonth.equals("03")) {%>selected<%}%>>3</option>
		  <option value="04" <%if(lastmonth.equals("04")) {%>selected<%}%>>4</option>
		  <option value="05" <%if(lastmonth.equals("05")) {%>selected<%}%>>5</option>
		  <option value="06" <%if(lastmonth.equals("06")) {%>selected<%}%>>6</option>
		  <option value="07" <%if(lastmonth.equals("07")) {%>selected<%}%>>7</option>
		  <option value="08" <%if(lastmonth.equals("08")) {%>selected<%}%>>8</option>
		  <option value="09" <%if(lastmonth.equals("09")) {%>selected<%}%>>9</option>
		  <option value="10" <%if(lastmonth.equals("10")) {%>selected<%}%>>10</option>
		  <option value="11" <%if(lastmonth.equals("11")) {%>selected<%}%>>11</option>
		  <option value="12" <%if(lastmonth.equals("12")) {%>selected<%}%>>12</option>
		  </select><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>&nbsp;
          <%        } 
                    if(tempfieldnames.indexOf("dayf")>=0) { 
          %>
		  <select class="InputStyle" name="dayf">
                  <%    for( int i=1 ; i<32; i++) {  %>
                  <option value="<%=Util.add0(i,2)%>" <%if(lastday.equals(Util.add0(i,2))) {%>selected<%}%>><%=i%></option>
                  <%    } %>
		      </select><%=SystemEnv.getHtmlLabelName(16889,user.getLanguage())%>&nbsp;
          <%        } %>
		  </TD>
        </TR><TR><TD class=Line colSpan=2></TD></TR> 
	  <%        } 
                else if(nottodate && (tempfieldname.equals("yeart") || tempfieldname.equals("montht") || tempfieldname.equals("dayt")) ) {
                    nottodate = false ;
        %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%></TD>
          <TD>
		  <%        if(tempfieldnames.indexOf("yeart")>=0) { %>
		  <select class="InputStyle" name="yeart">
		  <%            for(int i=5 ; i>-5;i--) {
                            int tempyear = Util.getIntValue(lastyear) - i ;
                            String selected = "" ;
                            if( i==0) selected = "selected" ;
		  %>
          <option value="<%=tempyear%>" <%=selected%>><%=tempyear%></option>
		  <%            } %>
		  </select><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;
          <%        } 
                    if(tempfieldnames.indexOf("montht")>=0) { %>
		  <select class="InputStyle" name="montht">
          <option value="01" <%if(lastmonth.equals("01")) {%>selected<%}%>>1</option>
		  <option value="02" <%if(lastmonth.equals("02")) {%>selected<%}%>>2</option>
		  <option value="03" <%if(lastmonth.equals("03")) {%>selected<%}%>>3</option>
		  <option value="04" <%if(lastmonth.equals("04")) {%>selected<%}%>>4</option>
		  <option value="05" <%if(lastmonth.equals("05")) {%>selected<%}%>>5</option>
		  <option value="06" <%if(lastmonth.equals("06")) {%>selected<%}%>>6</option>
		  <option value="07" <%if(lastmonth.equals("07")) {%>selected<%}%>>7</option>
		  <option value="08" <%if(lastmonth.equals("08")) {%>selected<%}%>>8</option>
		  <option value="09" <%if(lastmonth.equals("09")) {%>selected<%}%>>9</option>
		  <option value="10" <%if(lastmonth.equals("10")) {%>selected<%}%>>10</option>
		  <option value="11" <%if(lastmonth.equals("11")) {%>selected<%}%>>11</option>
		  <option value="12" <%if(lastmonth.equals("12")) {%>selected<%}%>>12</option>
		  </select><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>&nbsp;
          <%        } 
                    if(tempfieldnames.indexOf("dayt")>=0) { %>
		  <select class="InputStyle" name="dayt">
          <%            for( int i=1 ; i<32; i++) {%>
                  <option value="<%=Util.add0(i,2)%>" <%if(lastday.equals(Util.add0(i,2))) {%>selected<%}%>><%=i%></option>
          <%            } %>
		      </select><%=SystemEnv.getHtmlLabelName(16889,user.getLanguage())%> 
          <%        } %>
		  </TD>
        </TR><TR><TD class=Line colSpan=2></TD></TR> 
	  <%        }
                else if(tempfieldname.equals("modify")) { %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17030,user.getLanguage())%></TD>
          <td> 
           <input type="checkbox" id="modify" name="modify" value=1>
          </TD>
        </TR><TR><TD class=Line colSpan=2></TD></TR> 
        <%      }
                else if(tempfieldname.equals("monthmodify")) { %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17031,user.getLanguage())%></TD>
          <td> 
           <input type="checkbox" id="monthmodify" name="monthmodify" value=1>
          </TD>
        </TR><TR><TD class=Line colSpan=2></TD></TR> 
        <%      }
                else if(tempfieldname.equals("yearmodify")) { %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17032,user.getLanguage())%></TD>
          <td> 
           <input type="checkbox" id="yearmodify" name="yearmodify" value=1>
          </TD>
        </TR><TR><TD class=Line colSpan=2></TD></TR> 
        <%      }
                else if(tempfieldname.equals("isonebyone")) { %>
        <TR>
          <TD>分别汇总</TD>
          <td> 
           <input type="checkbox" id="isonebyone" name="isonebyone" value=1>
          </TD>
        </TR><TR><TD class=Line1 colSpan=2></TD></TR> 
        <%      }
            }
        }
        %>
	  </TBODY>
	 </TABLE>
    </TD>
    <TD><button class=AddDoc type="submit"><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></button></TD>
    </tr>
    </TBODY>
    </table>
    </form>
    </TD>
  </TR>
<%
}
%>  
 </TBODY></TABLE>


 <br><br>

 <TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="70%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(73,user.getLanguage())%>)</TH></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="3" ></TD></TR> 
<%

sql=" select * from outrepmodule where outrepid = " + outrepid + " and userid= "+userid+" and usertype = " + usertype ;

isLight = false;
rs.executeSql(sql);
while(rs.next()){
    String id=Util.null2String(rs.getString("id")) ;
    String modulename=Util.null2String(rs.getString("modulename")) ;
    String moduleenname=Util.null2String(rs.getString("moduleenname")) ;
    if(user.getLanguage() == 8 && !moduleenname.equals("")) modulename = moduleenname ;
    isLight = ! isLight ;
%>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <TD colspan="3" >
    <form id="search<%=id%>" name="search<%=id%>" action="OutReportSearchTemp.jsp" method=post>
    <input type="hidden" name="outrepid" value="<%=outrepid%>">
    <input type="hidden" name="moduleid" value="<%=id%>">
    <input type="hidden" name="modulename" value="<%=modulename%>">
    <input type="hidden" name="outrepcategory" value="<%=outrepcategory%>">

    <!-- 刘煜 2004 年10月23 日增加模板文件自适应行高和列宽-->
    <input type="hidden" name="autocolumn" value="<%=autocolumn%>">
    <input type="hidden" name="autorow" value="<%=autorow%>">

    <table width=100%>
    <COLGROUP>
    <COL width="20%">
    <COL width="70%">
    <COL width="10%">
    <TBODY>
    <tr>
    <TD><%=modulename%></TD>
    <TD>
    <!--  其它条件设置 -->
    <TABLE class=viewform>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
    <%  
        ArrayList  userdefconditionids = new ArrayList() ;
        rs1.executeSql("select conditionid from modulecondition where moduleid = " + id + " and isuserdefine=1");
        while(rs1.next() ) {
            userdefconditionids.add(Util.null2String(rs1.getString("conditionid"))) ;
        }

        boolean notfromdate = true ;
        boolean nottodate = true ;
        int countcrm = 0 ;    // 如果是客户查询， 只显示一组crm

        for(int k=0 ; k< conditionids.size() ; k++ ) {
            String tempconditionid = (String)conditionids.get(k) ;
            if( userdefconditionids.indexOf(tempconditionid) == -1 ) continue ;
            String issystemdef = (String)issystemdefs.get(k) ;
            String conditionname = (String)conditionnames.get(k) ;
            String tempfieldname = (String)fieldnames.get(k) ;
            String tempconditiontype = (String)conditiontypes.get(k) ;
     
            if(!issystemdef.equals("1")) {
      %>
        <TR>
          <TD><%=conditionname%></TD>
          <TD>
		  <%    if(tempconditiontype.equals("1")) { %>
          <INPUT type=text class="InputStyle" size=50 name="<%=tempfieldname%>" >
          <%    } else { %>
		  <select class="InputStyle" name="<%=tempfieldname%>" style="width:30%">
		  <% 
                    rs1.executeProc("T_CDetail_SelectByConditionid",tempconditionid);
                    while(rs1.next()) {
                        String conditiondsp = Util.null2String(rs1.getString("conditiondsp")) ;
                        String conditionendsp = Util.null2String(rs1.getString("conditionendsp")) ;
                        if(user.getLanguage() == 8 && !conditionendsp.equals("")) conditiondsp = conditionendsp ;
                        String conditionvalue = Util.null2String(rs1.getString("conditionvalue")) ;
		  %>
          <option value="<%=conditionvalue%>"><%=conditiondsp%></option>
		  <%        } %>
		  </select>
          <%    } %>
          </td>
        </tr><TR><TD class=Line colSpan=2></TD></TR> 
       <%   } else {              // issystemdef = 1 
                if(tempfieldname.indexOf("crm") >= 0) {
                    countcrm ++ ;
       %>
        <TR>
          <TD><%=conditionname%></TD>
          
          <td> 
            <% if(usertype.equals("2") && countcrm < 2 ) {%>
            <%=user.getUsername()%>
            <input type="hidden" name="crm" value="<%=user.getUID()%>">
            <input type="hidden" name="name_crm" value="<%=user.getUsername()%>">
            <%} else {%>
              <button class=Browser onClick="onShowCustomer(span_<%=tempfieldname%>_<%=id%>,<%=tempfieldname%>_<%=id%>,name_<%=tempfieldname%>_<%=id%>)"></button>
              <SPAN id="span_<%=tempfieldname%>_<%=id%>"></SPAN>
            <input type="hidden" id="<%=tempfieldname%>_<%=id%>" name="<%=tempfieldname%>">
            <input type="hidden" id="name_<%=tempfieldname%>_<%=id%>" name="name_<%=tempfieldname%>">
            <%}%></TD>
            </TR><TR><TD class=Line colSpan=2></TD></TR> 
        <%      } 
                else if( notfromdate && (tempfieldname.equals("yearf") || tempfieldname.equals("monthf") || tempfieldname.equals("dayf")) ) {
                    notfromdate = false ;
        %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%></TD>
          <TD>
		<%          if(tempfieldnames.indexOf("yearf")>=0) { 
        %>
		  <select class="InputStyle" name="yearf"> 
		  <%            for(int i=5 ; i>-5;i--) {
                            int tempyear = Util.getIntValue(currentyear) - i ;
                            String selected = "" ;
                            if( i==0) selected = "selected" ;
		  %>
          <option value="<%=tempyear%>" <%=selected%>><%=tempyear%></option>
		  <%            } %>
		  </select><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;
          <%        } 
                    if(tempfieldnames.indexOf("monthf")>=0) { 
          %>
		  <select class="InputStyle" name="monthf">
          <option value="01" <%if(currentmonth.equals("01")) {%>selected<%}%>>1</option>
		  <option value="02" <%if(currentmonth.equals("02")) {%>selected<%}%>>2</option>
		  <option value="03" <%if(currentmonth.equals("03")) {%>selected<%}%>>3</option>
		  <option value="04" <%if(currentmonth.equals("04")) {%>selected<%}%>>4</option>
		  <option value="05" <%if(currentmonth.equals("05")) {%>selected<%}%>>5</option>
		  <option value="06" <%if(currentmonth.equals("06")) {%>selected<%}%>>6</option>
		  <option value="07" <%if(currentmonth.equals("07")) {%>selected<%}%>>7</option>
		  <option value="08" <%if(currentmonth.equals("08")) {%>selected<%}%>>8</option>
		  <option value="09" <%if(currentmonth.equals("09")) {%>selected<%}%>>9</option>
		  <option value="10" <%if(currentmonth.equals("10")) {%>selected<%}%>>10</option>
		  <option value="11" <%if(currentmonth.equals("11")) {%>selected<%}%>>11</option>
		  <option value="12" <%if(currentmonth.equals("12")) {%>selected<%}%>>12</option>
		  </select><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>&nbsp;
          <%        } 
                    if(tempfieldnames.indexOf("dayf")>=0) { 
          %>
		  <select class="InputStyle" name="dayf">
                  <%    for( int i=1 ; i<32; i++) {  %>
                  <option value="<%=Util.add0(i,2)%>" <%if(currentday.equals(Util.add0(i,2))) {%>selected<%}%>><%=i%></option>
                  <%    } %>
		      </select><%=SystemEnv.getHtmlLabelName(16889,user.getLanguage())%>&nbsp;
          <%        } %>
		  </TD>
        </TR><TR><TD class=Line colSpan=2></TD></TR> 
	  <%        } 
                else if(nottodate && (tempfieldname.equals("yeart") || tempfieldname.equals("montht") || tempfieldname.equals("dayt")) ) {
                    nottodate = false ;
        %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%></TD>
          <TD>
		  <%        if(tempfieldnames.indexOf("yeart")>=0) { %>
		  <select class="InputStyle" name="yeart">
		  <%            for(int i=5 ; i>-5;i--) {
                            int tempyear = Util.getIntValue(currentyear) - i ;
                            String selected = "" ;
                            if( i==0) selected = "selected" ;
		  %>
          <option value="<%=tempyear%>" <%=selected%>><%=tempyear%></option>
		  <%            } %>
		  </select><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;
          <%        } 
                    if(tempfieldnames.indexOf("montht")>=0) { %>
		  <select class="InputStyle" name="montht">
          <option value="01" <%if(currentmonth.equals("01")) {%>selected<%}%>>1</option>
		  <option value="02" <%if(currentmonth.equals("02")) {%>selected<%}%>>2</option>
		  <option value="03" <%if(currentmonth.equals("03")) {%>selected<%}%>>3</option>
		  <option value="04" <%if(currentmonth.equals("04")) {%>selected<%}%>>4</option>
		  <option value="05" <%if(currentmonth.equals("05")) {%>selected<%}%>>5</option>
		  <option value="06" <%if(currentmonth.equals("06")) {%>selected<%}%>>6</option>
		  <option value="07" <%if(currentmonth.equals("07")) {%>selected<%}%>>7</option>
		  <option value="08" <%if(currentmonth.equals("08")) {%>selected<%}%>>8</option>
		  <option value="09" <%if(currentmonth.equals("09")) {%>selected<%}%>>9</option>
		  <option value="10" <%if(currentmonth.equals("10")) {%>selected<%}%>>10</option>
		  <option value="11" <%if(currentmonth.equals("11")) {%>selected<%}%>>11</option>
		  <option value="12" <%if(currentmonth.equals("12")) {%>selected<%}%>>12</option>
		  </select><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>&nbsp;
          <%        } 
                    if(tempfieldnames.indexOf("dayt")>=0) { %>
		  <select class="InputStyle" name="dayt">
          <%            for( int i=1 ; i<32; i++) {%>
                  <option value="<%=Util.add0(i,2)%>" <%if(currentday.equals(Util.add0(i,2))) {%>selected<%}%>><%=i%></option>
          <%            } %>
		      </select><%=SystemEnv.getHtmlLabelName(16889,user.getLanguage())%> 
          <%        } %>
		  </TD>
        </TR><TR><TD class=Line colSpan=2></TD></TR> 
	  <%        }
                else if(tempfieldname.equals("modify")) { %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17030,user.getLanguage())%></TD>
          <td> 
           <input type="checkbox" id="modify" name="modify" value=1>
          </TD>
        </TR><TR><TD class=Line colSpan=2></TD></TR> 
        <%      }
                else if(tempfieldname.equals("monthmodify")) { %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17031,user.getLanguage())%></TD>
          <td> 
           <input type="checkbox" id="monthmodify" name="monthmodify" value=1>
          </TD>
        </TR><TR><TD class=Line colSpan=2></TD></TR> 
        <%      }
                else if(tempfieldname.equals("yearmodify")) { %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17032,user.getLanguage())%></TD>
          <td> 
           <input type="checkbox" id="yearmodify" name="yearmodify" value=1>
          </TD>
        </TR><TR><TD class=Line colSpan=2></TD></TR> 
        <%      }
                else if(tempfieldname.equals("isonebyone")) { %>
        <TR>
          <TD>分别汇总</TD>
          <td> 
           <input type="checkbox" id="isonebyone" name="isonebyone" value=1>
          </TD>
        </TR><TR><TD class=Line1 colSpan=2></TD></TR> 
        <%      }
            }
        }
        %>
	  </TBODY>
	 </TABLE>
    </TD>
    <TD><button class=AddDoc type="submit"><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></button></TD>
    </tr>
    </TBODY>
    </table>
    </form>
    </TD>
  </TR>
<%
}
%>  
 </TBODY></TABLE>

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

<script language=vbs>
sub onShowCustomer(tdname,inputename,inputename2)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp")
	if NOT isempty(id) then
        if id(0)<> "" then
		tdname.innerHtml = right(id(1),len(id(1))-1)
		inputename.value = right(id(0),len(id(0))-1)
        inputename2.value = right(id(1),len(id(1))-1)
		else
		tdname.innerHtml = ""
		inputename.value =""
        inputename2.value =""
		end if
	end if
end sub

</script>

</BODY></HTML>
