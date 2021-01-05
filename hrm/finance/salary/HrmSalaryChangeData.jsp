
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
request.setCharacterEncoding("UTF-8");
%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
boolean hasright=true;
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=0;
if(detachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Compensation:Manager",Util.getIntValue(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(""+user.getUID()))));
    if(operatelevel<1){
        if(operatelevel<0){
            response.sendRedirect("/notice/noright.jsp");
            return;
        }else{
            hasright=false;
        }
    }
}
String subcompanyids = Util.null2String(request.getParameter("subcompanyids"));
%>
<TABLE class=Shadow>
<tr>
<td valign="top">
<%if(hasright){%>
<FORM id=frmmain name=frmmain action="HrmSalaryOperation.jsp" method=post >
<input class=inputstyle type="hidden" name="method" value="changesalary">
<TABLE class=ViewForm>
  <COLGROUP>
  	<COL width="15%">
  	<COL width="85%">
        <TBODY>
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(15814,user.getLanguage())%></TH>
        </TR>
        <TR class=Spacing style="height:2px">
          <TD class=Line1 colSpan=2></TD>
        </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD> 
		    <TD class=Field>
              <BUTTON class=Browser type=button onClick="onShowResource(multresourceidspan,multresourceid)"></BUTTON> 
              <span id=multresourceidspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span> 
              <input id=multresourceid type=hidden name=multresourceid >
            </TD>
		</TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15815,user.getLanguage())%></TD> 
		    <TD class=Field>
                <button class=Browser type=button id=SelectItemId onClick="onShowItemId(itemidspan,itemid)"></button> 
                <span id=itemidspan><IMG src="/images/BacoError_wev8.gif" 
                align=absMiddle></span> 
                <input id=itemid type=hidden name=itemid>
            </TD>
		 </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TD>
          <TD class=Field>
              <input class=inputstyle type=radio name=changetype value=1 checked><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>
              <input class=inputstyle type=radio name=changetype value=2><%=SystemEnv.getHtmlLabelName(457,user.getLanguage())%>
              <input class=inputstyle type=radio name=changetype value=3><%=SystemEnv.getHtmlLabelName(15816,user.getLanguage())%>
              <INPUT class=inputstyle maxLength=50 size=10 name="salary" onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput("salary","salaryimage")' value="">
              <SPAN id=salaryimage><IMG src="/images/BacoError_wev8.gif" 
                    align=absMiddle></SPAN>
          </TD> 
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1897,user.getLanguage())%></TD>
          <TD class=Field>
              <textarea class=inputstyle id="changeresion" name="changeresion" cols="60" rows="4"></textarea>
          </TD> 
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
  </TBODY>
</TABLE>
</FORM>
<%}%>
<TABLE class=ListStyle cellspacing=1 >
  <colgroup>
  <COL width="10%">
  <COL width="10%">
  <COL width="12%">
  <COL width="9%">
  <COL width="8%">
  <COL width="8%">
  <COL width="9%">
  <COL width="24%">
  <COL width="10%">
  <TBODY>
  <TR class=Header> 
    <TH colspan=9><%=SystemEnv.getHtmlLabelName(15817,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15818,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15819,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15820,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(19603,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15821,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15822,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(19604,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1897,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15823,user.getLanguage())%></th>
  </tr>


<%
    String sql="";
    if(RecordSet.getDBType().equals("oracle")){
        sql="select a.* from HrmSalaryChange a,HrmResource b where a.multresourceid=concat(concat(',',to_char(b.id)),',') and b.subcompanyid1 in("+subcompanyids+") order by a.id desc";
    }else{
        sql="select a.* from HrmSalaryChange a,HrmResource b where a.multresourceid=','+CONVERT(varchar,b.id)+',' and b.subcompanyid1 in("+subcompanyids+") order by a.id desc";
    }
    RecordSet.executeSql(sql);
    boolean isLight = false;
	while(RecordSet.next())
	{
        String multresourceid = Util.null2String(RecordSet.getString("multresourceid")) ;
        String itemid = Util.null2String(RecordSet.getString("itemid")) ;
        String changedate = Util.null2String(RecordSet.getString("changedate")) ;
        String changetype = Util.null2String(RecordSet.getString("changetype")) ;
        String salary = Util.null2String(RecordSet.getString("salary")) ;
        String changeresion = Util.toScreen(RecordSet.getString("changeresion"),user.getLanguage()) ;
        String changeuser = Util.null2String(RecordSet.getString("changeuser")) ;
        String oldsalary = Util.null2String(RecordSet.getString("oldvalue")) ;
        String newsalary = Util.null2String(RecordSet.getString("newvalue")) ;
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD>
        <% if( multresourceid.length() > 2 ) {
                multresourceid = multresourceid.substring(1,multresourceid.length()-1) ;
                String[] multresourceidarr = Util.TokenizerString2( multresourceid , "," ) ;
                for( int i=0 ; i< multresourceidarr.length ; i++) {
        %>
        <%=Util.toScreen(ResourceComInfo.getResourcename(multresourceidarr[i]),user.getLanguage())%> 
        <% 
                }
           }
        %>
        </TD>
        <TD><%=Util.toScreen(SalaryComInfo.getSalaryname(itemid),user.getLanguage())%></TD>
        <TD><%=changedate%></TD>
        <TD align=right><%=oldsalary%></TD>
        <TD>
            <%if(changetype.equals("1")){%><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>
            <%} else if(changetype.equals("2")){%><%=SystemEnv.getHtmlLabelName(457,user.getLanguage())%>
            <%} else if(changetype.equals("3")){%><%=SystemEnv.getHtmlLabelName(15816,user.getLanguage())%><%}%>
        </TD>
		<TD align=right><%=salary%></TD>
        <TD align=right><%=newsalary%></TD>
           <TD><%=changeresion%></TD>
        <TD><%=Util.toScreen(ResourceComInfo.getResourcename(changeuser),user.getLanguage())%></TD>
	</TR>
<%
	}
%>
 </TABLE>
</td>
</tr>
</TABLE>