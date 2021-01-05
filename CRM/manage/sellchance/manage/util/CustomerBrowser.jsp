
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.crm.Maint.CustomerStatusComInfo"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
</HEAD>
<style>
	select{
		width:100%;
	}
</style>
<%
String name = Util.null2String(request.getParameter("name"));
String engname = Util.null2String(request.getParameter("engname"));

String type = Util.null2String(request.getParameter("type"));

String city = Util.null2String(request.getParameter("City"));
String country1 = Util.null2String(request.getParameter("country1"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String crmManager = Util.null2String(request.getParameter("crmManager"));

String sectorInfo = Util.null2String(request.getParameter("sectorInfo"));
String customerStatus = Util.null2String(request.getParameter("customerStatus"));
String customerDesc = Util.null2String(request.getParameter("customerDesc"));
String customerSize = Util.null2String(request.getParameter("customerSize"));

String customerStatusName = CustomerStatusComInfo.getCustomerStatusname(customerStatus);

String customerDescName = Util.null2String(CustomerDescComInfo.getCustomerDescname(customerDesc));
String customerSizeName =  Util.null2String(request.getParameter("customerSizeName"));
String sectorInfoName = Util.null2String(SectorInfoComInfo.getSectorInfoname(sectorInfo));

int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
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

if(!sectorInfo.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.sector = "+ sectorInfo ;
	}
	else
		sqlwhere += " and t1.sector = "+ sectorInfo;
}
if(!customerStatus.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.status = "+ customerStatus ;
	}
	else
		sqlwhere += " and t1.status = "+ customerStatus;
}
if(!customerDesc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.description = "+ customerDesc ;
	}
	else
		sqlwhere += " and t1.description = "+ customerDesc;
}
if(!customerSize.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.size_n = "+ customerSize ;
	}
	else
		sqlwhere += " and t1.size_n = "+ customerSize;
}

String sqlstr = "";
if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.id != 0 " ;
}

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);

int	perpage=50;

String userid = user.getUID()+"";
String CRM_SearchSql = "";
String temptable1="";
String leftjointable = "";
int userlevel = Util.getIntValue(user.getSeclevel());//用户等级
int userDeptid = Util.getIntValue(user.getUserDepartment()+"",-1);//用户部门id
int usersub = Util.getIntValue(user.getUserSubCompany1()+"",-1);//用户分部id
String rolesql = " 1=2 ";
rs.executeSql("select roleid,rolelevel from HrmRoleMembers where resourceid="+userid);
while(rs.next()){//当前用户的所在的角色
    String roleid = rs.getString("roleid");
    String rolelevel = rs.getString("rolelevel");
    if(rolelevel.equals("0"))//部门级别
    	rolesql += " or (sharetype=3  and contents="+roleid+" and deptorcomid="+userDeptid+" and rolelevel="+rolelevel+" and seclevel<="+userlevel+") ";
    else if(rolelevel.equals("1"))//分部级别
        rolesql += " or (sharetype=3  and contents="+roleid+" and deptorcomid="+usersub+" and rolelevel="+rolelevel+" and seclevel<="+userlevel+") ";
    else
        rolesql += " or (sharetype=3  and contents="+roleid+" and rolelevel="+rolelevel+"  and seclevel<="+userlevel+") ";
}
boolean isSystemManager = false;
rs.executeSql("select 1 from hrmresourcemanager where id="+userid);
if(rs.getCounts()>0) isSystemManager = true;

if(isSystemManager){//系统管理员只在角色共享中查找
	leftjointable = " EXISTS (select relateditemid from CRM_ShareInfo where t1.id=relateditemid and ("+
                    " ("+rolesql+") and seclevel<"+userlevel+" ) )";
}else{
	leftjointable = " EXISTS (select relateditemid from CRM_ShareInfo where t1.id=relateditemid and ("+
                    "(sharetype=1 and contents="+userid+" and sharelevel>1) "+
                    "or (sharetype=2 and contents="+userDeptid+" and seclevel<="+userlevel+" and sharelevel>1) "+
                    "or (("+rolesql+") and sharelevel>1) "+
                    "or (sharetype=4 and contents=1 and seclevel<="+userlevel+" and sharelevel>1) "+
                    "))";
}

//添加判断权限的内容--new*/
//RecordSet.executeSql(CRM_SearchSql);

//RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable1);
if(user.getLogintype().equals("1")){
   temptable1="  CRM_CustomerInfo t1 "+sqlwhere+" and t1.deleted<>1 and "+leftjointable;
}else{
   temptable1="  CRM_CustomerInfo t1 "+sqlwhere+" and t1.deleted<>1 and t1.agent="+user.getUID();
}
RecordSet.executeSql("select count(*) RecordSetCounts from "+temptable1);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}

if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
String sqltemp="";
int iTotal =RecordSetCounts;
int iNextNum = pagenum * perpage;
int ipageset = perpage;
if(iTotal - iNextNum + perpage < perpage) ipageset = iTotal - iNextNum + perpage;
if(iTotal < perpage) ipageset = iTotal;

if(RecordSet.getDBType().equals("oracle")){
	//sqltemp="select * from (select * from  "+temptable1+" order by id) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
	sqltemp=  "select t1.id,t1.name,t1.engname,t1.type,t1.city,t1.country,t1.department,t1.manager,t1.agent,t1.source from "+temptable1+" order by t1.id desc";
	sqltemp = "select t2.*,rownum rn from (" + sqltemp + ") t2 where rownum <= " + iNextNum;
	sqltemp = "select t3.* from (" + sqltemp + ") t3 where rn > " + (iNextNum - perpage);
}else{
	//sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable1+"  order by id";
	sqltemp="select top "+iNextNum+" t1.id,t1.name,t1.engname,t1.type,t1.city,t1.country,t1.department,t1.manager,t1.agent,t1.source from "+temptable1+" order by t1.id desc";
	sqltemp = "select top " + ipageset +" t2.* from (" + sqltemp + ") t2 order by t2.id asc";
	sqltemp = "select top " + ipageset +" t3.* from (" + sqltemp + ") t3 order by t3.id desc";
}

RecordSet.executeSql(sqltemp);

%>
<BODY scroll="auto">
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
		<td valign="top">

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="CustomerBrowser.jsp" method=post>
  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input type="hidden" name="pagenum" value=''>
  	<input type="hidden" name="crmManager" value="<%=crmManager%>">
<DIV align=right style="display:none">

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button"  class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button"  class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button"  class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button"  class=btn accessKey=2 id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
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
</TR><tr style="height:1px;"><td class=Line colspan=4></td></tr>
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
      
              <input class=wuiBrowser  id=CityCode type=hidden name="City" value="<%=city%>" _displayText="<%=CityComInfo.getCityname(city)%>"
              	_url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp"
              	/>
      </TD>
</TR><tr style="height:1px;"><td class=Line colspan=4></td></tr>
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
</TR><tr style="height:1px;"><td class=Line colspan=4></td></tr>
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
</TR><tr style="height:1px;"><td class=Line colspan=4></td></tr>
<%}%>
<tr>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
	<TD width=35% class=field>
		  <input class="wuiBrowser"  id=customerStatus type=hidden name="customerStatus" value="<%=customerStatus%>" _displayText="<%=customerStatusName%>"
		  _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp">
	</td>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
	<TD width=35% class=field>
		  <input class=wuiBrowser  id=customerDesc type=hidden name="customerDesc" value="<%=customerDesc%>" _displayText="<%=customerDescName%>"
		  	_url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp"/>
		  
	</td>
	</tr>
	<tr style="height:1px;"><td class=Line colspan=4></td></tr>
	<tr>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></TD>
	<TD width=35% class=field>
		  <BUTTON type="button" class=Browser id=SelectCustomerSizeID  onclick="onShowCustomerSizeID()"></BUTTON> 
		  <SPAN id=customerSizeSpan STYLE="width=50%"><%=customerSizeName%></SPAN> 
		  <input class=InputStyle  id=customerSize type=hidden name="customerSize" value="<%=customerSize%>">
		  <input class=InputStyle  id=customerSizeName type=hidden name="customerSizeName" value="<%=customerSizeName%>">

	</td>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></TD>
	<TD width=35% class=field>

		  <input class=wuiBrowser  id=sectorInfo type=hidden name="sectorInfo" value="<%=sectorInfo%>" _displayText="<%=sectorInfoName%>"
		  		_url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp">
		 
	</td>
	</tr>
	<TR class=Spacing><TD class=Line1 colspan=4></TD></TR>
</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
<TR class=DataHeader>
<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
      <TH><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TH>      
	  <TH><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
	  <TH width=0% style="display:none"></TH>
	  <TH width=0% style="display:none"></TH>
	  <TH width=0% style="display:none"></TH>
	  <TH width=0% style="display:none"></TH>
	  <TH width=0% style="display:none"></TH>
	  <TH width=0% style="display:none"></TH>
      <TH><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TH>
      <TH><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TH>
          </tr><TR class=Line style="height:1px;"><TH colSpan=4></TH></TR>
<%

int i=0;
int totalline=1;
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String names = Util.toScreen(RecordSet.getString("name"),user.getLanguage());
	String engnames = Util.toScreen(RecordSet.getString("engname"),user.getLanguage());
	String types = RecordSet.getString("type");
	String citys = RecordSet.getString("city");
	String country1s = Util.toScreen(RecordSet.getString("country"),user.getLanguage());
	String departmentids = RecordSet.getString("department");
	
	String managerid = Util.null2String(RecordSet.getString("manager"));
	String agent = Util.null2String(RecordSet.getString("agent"));
	String source = Util.null2String(RecordSet.getString("source"));
	
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
	<TD style="display:none"><%=managerid%></TD>
	<TD style="display:none"><%=ResourceComInfo.getLastname(managerid)%></TD>
	<TD style="display:none"><%=agent%></TD>
	<TD style="display:none"><%=CustomerInfoComInfo.getCustomerInfoname(agent)%></TD>
	<TD style="display:none"><%=source%></TD>
	<TD style="display:none"><%=ContactWayComInfo.getContactWayname(source)%></TD>
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
}
//RecordSet.executeSql("drop table "+temptable);
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
			<button type=submit class=btn accessKey=P id=prepage onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
	   <%}%>
   </td>
   <td>
	   <%if(hasNextPage){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
			<button type=submit class=btn accessKey=N  id=nextpage onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
<script type="text/javascript">
<!--

$(function(){
	//客户状态
	$("#SelectCustomerStatusID").modalDialog({
		url:"/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp",
		callBack:function(datas,e){
			if(datas){
				if(datas[0]!=0){
					$("#customerStatusSpan").html(datas[1]);
					$("#customerStatus").val(datas[0]);
					$("#customerStatusName").val(datas[1]);
				}else{
					$("#customerStatusSpan").html("");
					$("#customerStatus").val("");
					$("#customerStatusName").val("");
				}
			}
		}
	});
	//所在城市
	$("#SelectCityID").modalDialog({
		url:"/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp",
		callBack:function(datas,e){
			
		}
	});
	//客户描述
	$("#SelectCustomerDescID").modalDialog({url:""});

	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	
});




function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
     window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),
    	     name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),
    	     manager:jQuery(jQuery(target).parents("tr")[0].cells[2]).text(),
    	     managername:jQuery(jQuery(target).parents("tr")[0].cells[3]).text(),
    	     agent:jQuery(jQuery(target).parents("tr")[0].cells[4]).text(),
    	     agentname:jQuery(jQuery(target).parents("tr")[0].cells[5]).text(),
    	     source:jQuery(jQuery(target).parents("tr")[0].cells[6]).text(),
    	     sourcename:jQuery(jQuery(target).parents("tr")[0].cells[7]).text()};
	 window.parent.parent.close();
	}
}

function btnclear_onclick(){
	window.parent.parent.returnValue={id:"",name:"",manager:"",managername:"",agent:"",agentname:"",source:"",sourcename:""};
	window.parent.parent.close();
	
}
function onShowCustomerSizeID(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp");
	if (datas){
		if(datas.id!=""){
			$GetEle("customerSizeSpan").innerHTML = datas.name;
			$GetEle("customerSize").value=datas.id;
			$GetEle("customerSizeName").value=datas.name;
		}else{
			$GetEle("customerSizeSpan").innerHTML = "";
			$GetEle("customerSize").value="";
			$GetEle("customerSizeName").value="";
		}
	}
}
//-->
</script>