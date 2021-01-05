<%@ page language="java" contentType="text/html; charset=GBK" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
	
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%



String name = Util.null2String(request.getParameter("name"));
String engname = Util.null2String(request.getParameter("engname"));
String type = Util.null2String(request.getParameter("type"));
String city = Util.null2String(request.getParameter("City"));
String country1 = Util.null2String(request.getParameter("country1"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String crmManager = Util.null2String(request.getParameter("crmManager"));
String isSecurity = Util.null2String(request.getParameter("isSecurity"));

int reportUserId = Util.getIntValue(request.getParameter("reportUserId"),0);
String isInit = Util.null2String(request.getParameter("isInit"));//是否初始化，1为初始化，0或其它为非初始化
int inprepId = Util.getIntValue(request.getParameter("inprepId"),0);

int ishead = 0;

if(!sqlwhere.equalsIgnoreCase("")) ishead = 1;

String sqlWhereForSearch=sqlwhere;

if(isInit.equals("1")){
	this.rs=RecordSet;
    this.req=request;
    Map inReportHrm=this.getHrmSecurityInfoByUserId(reportUserId,inprepId);
	String theselcrmids="";
	if(inReportHrm!=null){
		theselcrmids=Util.null2String(inReportHrm.get("crmIds").toString());
	}

	if(theselcrmids.trim().equals("")){
	    if(ishead==0){
		    ishead = 1;
		    sqlwhere += " where 1=2 ";
		    sqlWhereForSearch += " where 1=2 ";
	    }else{
			sqlwhere += " and 1=2 ";
		    sqlWhereForSearch += " and 1=2 ";
		}
	}else{
	    if(ishead==0){
		    ishead = 1;
		    sqlwhere += " where t1.id in ("+theselcrmids+") ";
		    sqlWhereForSearch += " where t1.id in ("+theselcrmids+") ";
	    }else{
		    sqlwhere += " and t1.id in ("+theselcrmids+") ";
		    sqlWhereForSearch += " and t1.id in ("+theselcrmids+") ";
		}
	}
}


if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
}
if(!engname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.engname like '%" + Util.fromScreen2(engname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and t1.engname like '%" + Util.fromScreen2(engname,user.getLanguage()) +"%' ";
}
if(!type.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.type = "+ type ;
	}
	else
		sqlwhere += " and t1.type = "+ type;
}
if(!city.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.city = " + city ;
	}
	else
		sqlwhere += " and t1.city = " + city ;
}
if(!country1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.country = "+ country1 ;
	}
	else
		sqlwhere += " and t1.country = "+ country1;
}
if(!departmentid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.department =" + departmentid +" " ;
	}
	else
		sqlwhere += " and t1.department =" + departmentid +" " ;
}
if(!crmManager.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.manager =" + crmManager +" " ;
	}
	else
		sqlwhere += " and t1.manager =" + crmManager +" " ;
}

String sqlstr = "";
if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.id != 0 " ;
}

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);

int	perpage=50;



String temptable = "crmtemptable"+ Util.getNumberRandom() ;
String CRM_SearchSql = "";

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
	    if(isSecurity.equalsIgnoreCase("")){
		      CRM_SearchSql = "create table "+temptable+"  as select * from (select distinct t1.id, t1.name, t1.type, t1.city, t1.country from CRM_CustomerInfo  t1,"+leftjointable+" t2 "+ sqlwhere +" and t1.deleted<>1 and t1.id = t2.relateditemid order by t1.id desc) where rownum<"+ (pagenum*perpage+2);
	    }else{
	      CRM_SearchSql = "create table "+temptable+"  as select * from (select t1.id, t1.name, t1.type, t1.city, t1.country from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 order by t1.id  desc) where rownum<"+ (pagenum*perpage+2);
	    }
	}else{
		CRM_SearchSql = "create table "+temptable+"  as select * from (select t1.id, t1.name, t1.type, t1.city, t1.country from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 order by t1.id  desc) where rownum<"+ (pagenum*perpage+2);
	}
}else{
	if(user.getLogintype().equals("1")){
		if(isSecurity.equalsIgnoreCase(""))
			CRM_SearchSql = "select distinct top "+(pagenum*perpage+1)+" t1.id, t1.name, t1.type, t1.city, t1.country into "+temptable+" from CRM_CustomerInfo  t1,"+leftjointable+" t2 "+ sqlwhere +" and t1.deleted<>1 and t1.id = t2.relateditemid order by t1.id desc";
		else
			CRM_SearchSql = "select top "+(pagenum*perpage+1)+" t1.id, t1.name, t1.type, t1.city, t1.country into "+temptable+" from CRM_CustomerInfo  t1  "+ sqlwhere +" and t1.deleted<>1 order by t1.id desc";
	}else{
		CRM_SearchSql = "select top "+(pagenum*perpage+1)+" t1.id, t1.name, t1.type, t1.city, t1.country into "+temptable+" from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 order by t1.id desc";  
	}
}


//添加判断权限的内容--new*/
RecordSet.executeSql(CRM_SearchSql);
RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by id) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by id";
}
RecordSet.executeSql(sqltemp);

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


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
<jsp:useBean id="xss" class="weaver.filter.XssUtil" scope="page" />
<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="CustomerBrowserForBasicUnit.jsp" method=post>
  <input type="hidden" name="sqlwhere" value='<%=xss.put(sqlWhereForSearch)%>'>
  <input type="hidden" name="pagenum" value=''>
  <input type="hidden" name="crmManager" value="<%=crmManager%>">
  <input type="hidden" name="isSecurity" value="<%=isSecurity%>">
<DIV align=right style="display:none">

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onClick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=Spacing><TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TD>
<TD width=35% class=field><input class=InputStyle  name=name value="<%=name%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <input class=InputStyle  name=engname value="<%=engname%>">
      </TD>
</TR><tr><td class=Line colspan=4></td></tr>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=InputStyle id=type name=type>
        <option value=""></option>
<%if(!Util.null2String(request.getParameter("sqlwhere")).equals("where t1.type in (3,4)")){%>
       	<%
       	while(CustomerTypeComInfo.next()){
       	%>		  
          <option value="<%=CustomerTypeComInfo.getCustomerTypeid()%>" <%if(type.equalsIgnoreCase(CustomerTypeComInfo.getCustomerTypeid())) {%>selected<%}%>><%=CustomerTypeComInfo.getCustomerTypename()%></option>
        <%}%>
<%}else{%>
       	<%
       	while(CustomerTypeComInfo.next()){
		if(CustomerTypeComInfo.getCustomerTypeid().equals("3") || CustomerTypeComInfo.getCustomerTypeid().equals("4")){
       	%>		  
          <option value="<%=CustomerTypeComInfo.getCustomerTypeid()%>" <%if(type.equalsIgnoreCase(CustomerTypeComInfo.getCustomerTypeid())) {%>selected<%}%>><%=CustomerTypeComInfo.getCustomerTypename()%></option>
        <%}}%>
<%}%>
        </select>

      </TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
      <TD width=35% class=field>
       <BUTTON class=Browser id=SelectCityID onClick="onShowCityID()"></BUTTON> 
              <SPAN id=cityidspan STYLE="width=50%"><%=CityComInfo.getCityname(city)%></SPAN> 
              <input class=InputStyle  id=CityCode type=hidden name="City" value="<%=city%>">
      </TD>
</TR><tr><td class=Line colspan=4></td></tr>
<%if(!user.getLogintype().equals("2")){%>
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
<TD width=35% class=field>
<select class=InputStyle id=country1 name=country1>
        <option value=""></option>
       	<%
       	while(CountryComInfo.next()){
       	%>		  
          <option value="<%=CountryComInfo.getCountryid()%>" <%if(country1.equalsIgnoreCase(CountryComInfo.getCountryid())) {%>selected<%}%>><%=CountryComInfo.getCountryname()%></option>
          <%}%>
        </select>
      </td>
<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=InputStyle id=departmentid name=departmentid>
		<option value=""></option>
		<% while(DepartmentComInfo.next()) {  
			String tmpdepartmentid = DepartmentComInfo.getDepartmentid() ;
		%>
          <option value=<%=tmpdepartmentid%> <% if(tmpdepartmentid.equals(departmentid)) {%>selected<%}%>>
		  <%=Util.toScreen(DepartmentComInfo.getDepartmentname(),user.getLanguage())%></option>
		<% } %>
        </select>
      </TD>
</TR><tr><td class=Line colspan=4></td></tr>
<%}else{%>
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
<TD width=35% class=field>
<select class=InputStyle id=country1 name=country1>
        <option value=""></option>
       	<%
       	while(CountryComInfo.next()){
       	%>		  
          <option value="<%=CountryComInfo.getCountryid()%>" <%if(country1.equalsIgnoreCase(CountryComInfo.getCountryid())) {%>selected<%}%>><%=CountryComInfo.getCountryname()%></option>
          <%}%>
        </select>
      </td>
<TD width=15%></TD>
      <TD width=35% class=field>
        
      </TD>
</TR><tr><td class=Line colspan=4></td></tr>
<%}%>
<TR class=Spacing><TD class=Line1 colspan=4></TD></TR>
</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1>
<TR class=DataHeader>
<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
      <TH><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TH>      
	  <TH><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
      <TH><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TH>
      <TH><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TH>
          </tr><TR class=Line><TH colSpan=4></TH></TR>
<%

int i=0;
int totalline=1;
if(RecordSet.last()){
	do{
	String ids = RecordSet.getString("id");
	String names = Util.toScreen(RecordSet.getString("name"),user.getLanguage());
	String engnames = Util.toScreen(RecordSet.getString("engname"),user.getLanguage());
	String types = RecordSet.getString("type");
	String citys = RecordSet.getString("city");
	String country1s = Util.toScreen(RecordSet.getString("country"),user.getLanguage());
	String departmentids = RecordSet.getString("department");
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<TD style="display:none"><A HREF=#><%=ids%></A></TD>
	<td> <%=names%></TD>
	<TD><%=CustomerTypeComInfo.getCustomerTypename(types)%>
	</TD>
	<TD><%=CityComInfo.getCityname(citys)%></TD>
	<TD><%=CountryComInfo.getCountryname(country1s)%></TD>
</TR>
<%
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
}while(RecordSet.previous());
}
RecordSet.executeSql("drop table "+temptable);
%>
</TABLE>
<table align=right>
<tr style="display:none">
   <td>&nbsp;</td>
   <td>
	   <%if(pagenum>1){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
			<button type=submit class=btn accessKey=P id=prepage onClick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
	   <%}%>
   </td>
   <td>
	   <%if(hasNextPage){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
			<button type=submit class=btn accessKey=N  id=nextpage onClick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
	   <%}%>
   </td>
   <td>&nbsp;</td>
</tr>
</table>
</FORM>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>


<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
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
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub

sub onShowCityID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	cityidspan.innerHtml = id(1)
	SearchForm.City.value=id(0)
	else 
	cityidspan.innerHtml = ""
	SearchForm.City.value=""
	end if
	end if
end sub
</SCRIPT>
