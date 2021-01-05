<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<STYLE>
TABLE.PTable {
	WIDTH: 100%
}
TABLE.PTable TD.PLabel {
	WIDTH: 150px
}
</STYLE>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int userid = user.getUID();
String hasassetmark ="";
String hasassetname  ="";
String hasassetcountry ="";
String hasassetassortment ="";
String hasassetstatus ="";
String hasassettype ="";
String hasassetversion ="";
String hasassetattribute ="";
String hasassetsalesprice ="";
String hasdepartment ="";
String hasresource ="";
String hascrm ="";
String perpage="";
String assetcol1 ="";
String assetcol2 ="";
String assetcol3 ="";
String assetcol4 ="";
String assetcol5 ="";
String assetcol6 ="";

RecordSet.executeProc("LgcSearchDefine_SelectByID",""+userid);

if(RecordSet.next()){
       hasassetmark = RecordSet.getString("hasassetmark");
	   hasassetname = RecordSet.getString("hasassetname");
	   hasassetcountry = RecordSet.getString("hasassetcountry");
	   hasassetassortment = RecordSet.getString("hasassetassortment");
	   hasassetstatus = RecordSet.getString("hasassetstatus");
	   hasassettype = RecordSet.getString("hasassettype");
	   hasassetversion = RecordSet.getString("hasassetversion");
	   hasassetattribute = RecordSet.getString("hasassetattribute");
	   hasassetsalesprice = RecordSet.getString("hasassetsalesprice");
	   hasdepartment = RecordSet.getString("hasdepartment");
	   hasresource = RecordSet.getString("hasresource");
	   hascrm = RecordSet.getString("hascrm");
	   perpage= RecordSet.getString("perpage");
	   assetcol1 = RecordSet.getString("assetcol1");
       assetcol2 = RecordSet.getString("assetcol2");
       assetcol3 = RecordSet.getString("assetcol3");
	   assetcol4 = RecordSet.getString("assetcol4");
	   assetcol5 = RecordSet.getString("assetcol5");
	   assetcol6 = RecordSet.getString("assetcol6");
}
else {
	   hasassetmark = "1" ;
	   hasassetname = "1" ;
	   hasassetcountry = "1" ;
	   hasassetassortment = "1" ;
	   hasassetstatus = "1" ;
	   hasassettype = "1" ;
	   hasdepartment = "1" ;
	   hasresource = "1" ;
	   perpage= "20" ;
	   assetcol1 = "714|assetmark";
       assetcol2 = "195|assetname";
       assetcol3 = "179|resourceid";
	   assetcol4 = "63|assettypeid";
	   assetcol5 = "721|salesprice";
	   assetcol6 = "683|seclevel";
}

String imagefilename = "/images/hdLOGSearch_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(343,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


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
		<td valign="top"><FORM name=frmmain action=LgcSearchOperation.jsp method=post>
<INPUT type=hidden name=operation value="searchdefine"> 
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
      <TD width="84%">
        <!-- Buttons -->
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
        <TABLE class=ViewForm cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR >
          <TD>
              <TABLE class=PTable>
                <!-- Section 1 -->
                <TBODY> <tr><td class=Line1 colspan=3></td></tr>
                <TR> 
                  <TD class=PLabel>编号</TD>
                  <TD> 
                    <INPUT type=checkbox name=hasassetmark value="1" <% if(hasassetmark.equals("1")) {%> checked <%}%>>
                  </TD>
                </TR><tr><td class=Line colspan=3></td></tr>
                <tr> 
                  <td class=PLabel>名称</td>
                  <td> 
                    <input type=checkbox name=hasassetname value="1" <% if(hasassetname.equals("1")) {%> checked <%}%>>
                  </td>
                </TR><tr><td class=Line colspan=3></td></tr>
                <TR> 
                  <TD class=PLabel>国家</TD>
                  <TD> 
                    <INPUT type=checkbox name=hasassetcountry value="1" <% if(hasassetcountry.equals("1")) {%> checked <%}%> >
                  </TD>
                </TR><tr><td class=Line colspan=3></td></tr>
                <tr> 
                  <td class=PLabel>种类</td>
                  <td> 
                    <input type=checkbox name=hasassetassortment  value="1" <% if(hasassetassortment.equals("1")) {%> checked <%}%>>
                  </td>
                </TR><tr><td class=Line colspan=3></td></tr>
                <TR> 
                  <TD class=PLabel>状况</TD>
                  <TD> 
                    <INPUT type=checkbox name=hasassetstatus value="1" <% if(hasassetstatus.equals("1")) {%> checked <%}%>>
                  </TD>
                </TR><tr><td class=Line colspan=3></td></tr>
                <tr> 
                  <td class=PLabel>类型</td>
                  <td> 
                    <input type=checkbox name=hasassettype value="1" <% if(hasassettype.equals("1")) {%> checked <%}%>>
                  </td>
                </TR><tr><td class=Line colspan=3></td></tr>
                <tr> 
                  <td class=PLabel>版本</td>
                  <td> 
                    <input type=checkbox name=hasassetversion  value="1" <% if(hasassetversion.equals("1")) {%> checked <%}%>>
                  </td>
                </TR><tr><td class=Line colspan=3></td></tr>
                <tr> 
                  <td class=PLabel>属性</td>
                  <td> 
                    <input type=checkbox name=hasassetattribute  value="1" <% if(hasassetattribute.equals("1")) {%> checked <%}%>>
                  </td>
                </TR><tr><td class=Line colspan=3></td></tr>
                </TBODY> 
              </TABLE>
            </TD></TR>

          <TR>
          <TD>
            <TABLE class=PTable>
              <TBODY>
              <TR>
                <TD class=PLabel>销售价</TD>
                <TD><INPUT type=checkbox name=hasassetsalesprice  value="1" <% if(hasassetsalesprice.equals("1")) {%> checked <%}%>>
                  </TD>
                </TR><tr><td class=Line colspan=3></td></tr></TBODY></TABLE></TD></TR>

        <TR>
          <TD vAlign=top>
            <TABLE cellSpacing=0 cellPadding=0 width="100%">
              <TBODY>
              <TR>
                <TD vAlign=top width="50%">
                    <TABLE class=PTable>
                      <TBODY> 
                      <TR> 
                        <TD class=PLabel>部门</TD>
                        <TD> 
                          <INPUT type=checkbox name=hasdepartment  value="1" <% if(hasdepartment.equals("1")) {%> checked <%}%>>
                        </TD>
                      </TR><tr><td class=Line colspan=3></td></tr>
                      <TR> 
                        <TD class=PLabel>人力资源</TD>
                        <TD> 
                          <INPUT type=checkbox name=hasresource  value="1" <% if(hasresource.equals("1")) {%> checked <%}%>>
                        </TD>
                      </TR><tr><td class=Line colspan=3></td></tr>
                      <TR> 
                        <TD class=PLabel>CRM</TD>
                        <TD> 
                          <INPUT type=checkbox name=hascrm  value="1" <% if(hascrm.equals("1")) {%> checked <%}%>>
                        </TD>
                      </TR><tr><td class=Line colspan=3></td></tr>
                      </TBODY> 
                    </TABLE>
                  </TD>
                  <TD vAlign=top width="50%">&nbsp; </TD>
                </TR></TBODY></TABLE></TD></TR>

          <TR>
          <TD>
              <TABLE class=PTable width="102%">
                <TBODY> 
                <TR>
                  <TD class=PLabel>每页记录</TD>
                <TD>
                    <input class=InputStyle size=4 name=perpage value="<%=perpage%>">
                  </TD></TR><tr><td class=Line colspan=3></td></tr></TBODY></TABLE></TD></TR>

				</TBODY></TABLE>
        <table width="100%" class=ViewForm>
          <tbody> 
          <tr> 
            <td colspan=3>结果</td>
          </TR><tr><td class=Line1 colspan=3></td></tr>
          <tr> 
            <td width="33%">
              <select class=InputStyle   style="WIDTH: 98%" id=assetcol1  name=assetcol1>
			<option value="" ></option>
                <option value="714|assetmark" <% if(assetcol1.equals("714|assetmark")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
				<option value="195|assetname" <% if(assetcol1.equals("195|assetname")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></option>
				<option value="124|departmentid" <% if(assetcol1.equals("124|departmentid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
				<option value="179|resourceid" <% if(assetcol1.equals("179|resourceid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				<option value="377|assetcountyid" <% if(assetcol1.equals("377|assetcountyid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></option>
				<option value="717|startdate" <% if(assetcol1.equals("717|startdate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></option>
				<option value="718|enddate" <% if(assetcol1.equals("718|enddate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></option>
				<option value="406|currencyid" <% if(assetcol1.equals("406|currencyid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></option>
				<option value="719|costprice" <% if(assetcol1.equals("719|costprice")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(719,user.getLanguage())%></option>
				<option value="721|salesprice" <% if(assetcol1.equals("721|salesprice")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(721,user.getLanguage())%></option>
				<option value="74|assetimageid" <% if(assetcol1.equals("74|assetimageid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></option>
				<option value="63|assettypeid" <% if(assetcol1.equals("63|assettypeid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></option>
				<option value="271|createrid" <% if(assetcol1.equals("271|createrid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></option>
				<option value="722|createdate" <% if(assetcol1.equals("722|createdate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></option>
				<option value="424|lastmoderid" <% if(assetcol1.equals("424|lastmoderid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(424,user.getLanguage())%></option>
				<option value="723|lastmoddate" <% if(assetcol1.equals("723|lastmoddate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></option>
				<option value="454|assetremark" <% if(assetcol1.equals("454|assetremark")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></option>
				<option value="683|seclevel" <% if(assetcol1.equals("683|seclevel")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
                <option value="705|assetunitid" <% if(assetcol1.equals("705|assetunitid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></option>
			  </select>
            </td>
            <td width="33%">
              <select class=InputStyle   style="WIDTH: 98%" id=assetcol2  name=assetcol2>
                <option value="" ></option>
                <option value="714|assetmark" <% if(assetcol2.equals("714|assetmark")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
                <option value="195|assetname" <% if(assetcol2.equals("195|assetname")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></option>
				<option value="124|departmentid" <% if(assetcol2.equals("124|departmentid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                <option value="179|resourceid" <% if(assetcol2.equals("179|resourceid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
                <option value="377|assetcountyid" <% if(assetcol1.equals("377|assetcountyid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></option>
				<option value="717|startdate" <% if(assetcol2.equals("717|startdate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></option>
                <option value="718|enddate" <% if(assetcol2.equals("718|enddate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></option>
                <option value="406|currencyid" <% if(assetcol2.equals("406|currencyid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></option>
                <option value="719|costprice" <% if(assetcol2.equals("719|costprice")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(719,user.getLanguage())%></option>
                <option value="721|salesprice" <% if(assetcol2.equals("721|salesprice")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(721,user.getLanguage())%></option>
                <option value="74|assetimageid" <% if(assetcol2.equals("74|assetimageid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></option>
                <option value="63|assettypeid" <% if(assetcol2.equals("63|assettypeid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></option>
                <option value="271|createrid" <% if(assetcol2.equals("271|createrid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></option>
                <option value="722|createdate" <% if(assetcol2.equals("722|createdate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></option>
                <option value="424|lastmoderid" <% if(assetcol2.equals("424|lastmoderid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(424,user.getLanguage())%></option>
                <option value="723|lastmoddate" <% if(assetcol2.equals("723|lastmoddate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></option>
                <option value="454|assetremark" <% if(assetcol2.equals("454|assetremark")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></option>
                <option value="683|seclevel" <% if(assetcol2.equals("683|seclevel")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
                <option value="705|assetunitid" <% if(assetcol2.equals("705|assetunitid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></option>
			  </select>
            </td>
            <td width="33%"> 
              <select class=InputStyle   style="WIDTH: 98%" id=assetcol3  name=assetcol3>
                <option value="" ></option>
                <option value="714|assetmark" <% if(assetcol3.equals("714|assetmark")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
                <option value="195|assetname" <% if(assetcol3.equals("195|assetname")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></option>
				<option value="124|departmentid" <% if(assetcol3.equals("124|departmentid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                <option value="179|resourceid" <% if(assetcol3.equals("179|resourceid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
                <option value="377|assetcountyid" <% if(assetcol1.equals("377|assetcountyid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></option>
				<option value="717|startdate" <% if(assetcol3.equals("717|startdate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></option>
                <option value="718|enddate" <% if(assetcol3.equals("718|enddate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></option>
                <option value="406|currencyid" <% if(assetcol3.equals("406|currencyid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></option>
                <option value="719|costprice" <% if(assetcol3.equals("719|costprice")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(719,user.getLanguage())%></option>
                <option value="721|salesprice" <% if(assetcol3.equals("721|salesprice")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(721,user.getLanguage())%></option>
                <option value="74|assetimageid" <% if(assetcol3.equals("74|assetimageid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></option>
                <option value="63|assettypeid" <% if(assetcol3.equals("63|assettypeid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></option>
                <option value="271|createrid" <% if(assetcol3.equals("271|createrid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></option>
                <option value="722|createdate" <% if(assetcol3.equals("722|createdate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></option>
                <option value="424|lastmoderid" <% if(assetcol3.equals("424|lastmoderid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(424,user.getLanguage())%></option>
                <option value="723|lastmoddate" <% if(assetcol3.equals("723|lastmoddate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></option>
                <option value="454|assetremark" <% if(assetcol3.equals("454|assetremark")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></option>
                <option value="683|seclevel" <% if(assetcol3.equals("683|seclevel")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
                <option value="705|assetunitid" <% if(assetcol3.equals("705|assetunitid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></option>
			  </select>
            </td>
            
          </TR><tr><td class=Line colspan=3></td></tr>
          <tr> 
            <td width="33%">
              <select class=InputStyle   style="WIDTH: 98%" id=assetcol4  name=assetcol4>
                <option value="" ></option>
                <option value="714|assetmark" <% if(assetcol4.equals("714|assetmark")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
                <option value="195|assetname" <% if(assetcol4.equals("195|assetname")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></option>
				<option value="124|departmentid" <% if(assetcol4.equals("124|departmentid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                <option value="179|resourceid" <% if(assetcol4.equals("179|resourceid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
                <option value="377|assetcountyid" <% if(assetcol1.equals("377|assetcountyid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></option>
				<option value="717|startdate" <% if(assetcol4.equals("717|startdate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></option>
                <option value="718|enddate" <% if(assetcol4.equals("718|enddate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></option>
                <option value="406|currencyid" <% if(assetcol4.equals("406|currencyid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></option>
                <option value="719|costprice" <% if(assetcol4.equals("719|costprice")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(719,user.getLanguage())%></option>
                <option value="721|salesprice" <% if(assetcol4.equals("721|salesprice")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(721,user.getLanguage())%></option>
                <option value="74|assetimageid" <% if(assetcol4.equals("74|assetimageid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></option>
                <option value="63|assettypeid" <% if(assetcol4.equals("63|assettypeid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></option>
                <option value="271|createrid" <% if(assetcol4.equals("271|createrid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></option>
                <option value="722|createdate" <% if(assetcol4.equals("722|createdate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></option>
                <option value="424|lastmoderid" <% if(assetcol4.equals("424|lastmoderid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(424,user.getLanguage())%></option>
                <option value="723|lastmoddate" <% if(assetcol4.equals("723|lastmoddate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></option>
                <option value="454|assetremark" <% if(assetcol4.equals("454|assetremark")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></option>
                <option value="683|seclevel" <% if(assetcol4.equals("683|seclevel")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
                <option value="705|assetunitid" <% if(assetcol4.equals("705|assetunitid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></option>
			  </select>
            </td>
            <td width="33%"> 
              <select class=InputStyle   style="WIDTH: 98%" id=assetcol5  name=assetcol5>
                <option value="" ></option>
                <option value="714|assetmark" <% if(assetcol5.equals("714|assetmark")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
                <option value="195|assetname" <% if(assetcol5.equals("195|assetname")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></option>
				<option value="124|departmentid" <% if(assetcol5.equals("124|departmentid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                <option value="179|resourceid" <% if(assetcol5.equals("179|resourceid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
                <option value="377|assetcountyid" <% if(assetcol1.equals("377|assetcountyid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></option>
				<option value="717|startdate" <% if(assetcol5.equals("717|startdate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></option>
                <option value="718|enddate" <% if(assetcol5.equals("718|enddate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></option>
                <option value="406|currencyid" <% if(assetcol5.equals("406|currencyid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></option>
                <option value="719|costprice" <% if(assetcol5.equals("719|costprice")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(719,user.getLanguage())%></option>
                <option value="721|salesprice" <% if(assetcol5.equals("721|salesprice")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(721,user.getLanguage())%></option>
                <option value="74|assetimageid" <% if(assetcol5.equals("74|assetimageid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></option>
                <option value="63|assettypeid" <% if(assetcol5.equals("63|assettypeid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></option>
                <option value="271|createrid" <% if(assetcol5.equals("271|createrid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></option>
                <option value="722|createdate" <% if(assetcol5.equals("722|createdate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></option>
                <option value="424|lastmoderid" <% if(assetcol5.equals("424|lastmoderid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(424,user.getLanguage())%></option>
                <option value="723|lastmoddate" <% if(assetcol5.equals("723|lastmoddate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></option>
                <option value="454|assetremark" <% if(assetcol5.equals("454|assetremark")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></option>
                <option value="683|seclevel" <% if(assetcol5.equals("683|seclevel")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
                <option value="705|assetunitid" <% if(assetcol5.equals("705|assetunitid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></option>
			  </select>
            </td>
            <td width="33%"> 
              <select class=InputStyle   style="WIDTH: 98%" id=assetcol6  name=assetcol6>
                <option value="" ></option>
                <option value="714|assetmark" <% if(assetcol6.equals("714|assetmark")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
                <option value="195|assetname" <% if(assetcol6.equals("195|assetname")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></option>
				<option value="124|departmentid" <% if(assetcol6.equals("124|departmentid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                <option value="179|resourceid" <% if(assetcol6.equals("179|resourceid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
                <option value="377|assetcountyid" <% if(assetcol1.equals("377|assetcountyid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></option>
				<option value="717|startdate" <% if(assetcol6.equals("717|startdate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></option>
                <option value="718|enddate" <% if(assetcol6.equals("718|enddate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></option>
                <option value="406|currencyid" <% if(assetcol6.equals("406|currencyid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></option>
                <option value="719|costprice" <% if(assetcol6.equals("719|costprice")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(719,user.getLanguage())%></option>
                <option value="721|salesprice" <% if(assetcol6.equals("721|salesprice")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(721,user.getLanguage())%></option>
                <option value="74|assetimageid" <% if(assetcol6.equals("74|assetimageid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></option>
                <option value="63|assettypeid" <% if(assetcol6.equals("63|assettypeid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></option>
                <option value="271|createrid" <% if(assetcol6.equals("271|createrid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></option>
                <option value="722|createdate" <% if(assetcol6.equals("722|createdate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></option>
                <option value="424|lastmoderid" <% if(assetcol6.equals("424|lastmoderid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(424,user.getLanguage())%></option>
                <option value="723|lastmoddate" <% if(assetcol6.equals("723|lastmoddate")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></option>
                <option value="454|assetremark" <% if(assetcol6.equals("454|assetremark")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></option>
                <option value="683|seclevel" <% if(assetcol6.equals("683|seclevel")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
				<option value="705|assetunitid" <% if(assetcol6.equals("705|assetunitid")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></option>
              </select>
            </td>
           
          </TR><tr><td class=Line colspan=3></td></tr>
          <tr></tr>
          </tbody>
        </table>
      </TD></TR></TBODY></TABLE></FORM>
      
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
      </BODY></HTML>
