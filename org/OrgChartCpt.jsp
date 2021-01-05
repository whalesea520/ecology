<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.org.layout.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalCurPrice" class="weaver.cpt.capital.CapitalCurPrice" scope="page" />

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" rel="STYLESHEET" type="text/css">
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<SCRIPT language=VBS>
Sub window_onload()
	wait.style.display="none"
	On Error Resume Next
	Baco.Refresh.focus
End Sub
</SCRIPT>
</HEAD>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
    RecordSet.executeSql("select needupdate from orgchartstate");
    int needupdate = 1;
    if (RecordSet.next())
        needupdate = RecordSet.getInt("needupdate");
    
String fnarightlevel = HrmUserVarify.getRightLevel("FnaTransaction:All",user) ;

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
                                        
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(562,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
int companyid = Util.getIntValue(request.getParameter("companyid"),1);
String direction = Util.null2String(request.getParameter("direction"));
if(direction.equals("")){
	direction = "1";
}
String departids="\"\"";


RecordSet.executeProc("HrmSubCompany_SByCompanyID",""+companyid);

int subcompanycount = RecordSet.getCounts();
int clientwidth = 125*subcompanycount;

int top = 120;
int cellHeight = 66;
int cellWidth = 105;
int cellWidth2 = 420;
int lineHeight1 = 7;
int lineHeight2 = 73;
int lineWidth = 5;
int cellSpace = 20;
int linestep = 17;


String charttype = Util.null2String(request.getParameter("charttype"));


if(charttype.equals(""))
	charttype = "P";

int topMargin = 210;
int leftMargin = 20;
DepLayout dl = DownloadDeptLayoutServlet.readDeptLayout(user.getLanguage(), false, user);
dl.buildObjectRef();
dl.checkAndAutoset(10, 10, 20, 20);
%>
<table width="<%=dl.getMaxPos().x+60%>" height="<%=dl.getMaxPos().y+300%>" border="0" cellspacing="0" cellpadding="0">
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

		<FORM action="OrgChartCpt.jsp" id=Baco Name=Baco method=post>
		<DIV id=wait style="filter:alpha(opacity=30); height:100%; width:100%">
		<TABLE width="100%" height="100%">
			<TR><TD align=center style="font-size: 36pt;"><%=SystemEnv.getHtmlLabelName(562,user.getLanguage())%>...</TD></TR>
		</TABLE>
		</DIV>

		  <TABLE class="ViewForm">
			<TR> 
			  <TD width=50><B><%=SystemEnv.getHtmlLabelName(563,user.getLanguage())%></B></TD>
			  <TD width=100 class="field" align="left"> 
			<SELECT name=charttype onchange="changetype()">
				<OPTION value=D <%if(charttype.equals("D")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></OPTION>
				<OPTION value=H <%if(charttype.equals("H")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION>
		<%if(isgoveproj==0){%>
		<%if(software.equals("ALL") || software.equals("CRM")){%>
				<OPTION value=C <%if(charttype.equals("C")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></OPTION>
				<OPTION value=R <%if(charttype.equals("R")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></OPTION>
		<%}%>
		<%}%>
		<%if(software.equals("ALL") || software.equals("HRM")){%>
				<OPTION value=P <%if(charttype.equals("P")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></OPTION>
		<%}%>
		<%if(isgoveproj==0){%>
		<%if(software.equals("ALL") || software.equals("HRM") || software.equals("CRM")){
				if( fnarightlevel.equals("2") ) { %>
				<OPTION value=F <%if(charttype.equals("F")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></OPTION>
		<%      }
		}%>
		<%}%>
			</SELECT>
			<script language=javascript>
				function changetype(){
				if(document.all("charttype").value=="C") location = "OrgChartCRM.jsp";
				if(document.all("charttype").value=="F") location = "OrgChartFna.jsp";
				if(document.all("charttype").value=="I") location = "OrgChartLgc.jsp";
				if(document.all("charttype").value=="P") location = "OrgChartCpt.jsp";
				if(document.all("charttype").value=="H") location = "OrgChartHRM.jsp";
				if(document.all("charttype").value=="D") location = "OrgChartDoc.jsp";
				if(document.all("charttype").value=="R") location = "OrgChartProj.jsp";
			
			}
			</script>
			</TD>
		<!--      <TD width=10%><B><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></B></TD>
			  <TD width=20%> 
				<SELECT name=companyid>
				  <%
			while(CompanyComInfo.next()){	
				String tmpcompanyid = CompanyComInfo.getCompanyid();
				String isselected="";
				if(Util.getIntValue(tmpcompanyid,0)==companyid)
					isselected=" selected";
			%>
				  <OPTION value="<%=CompanyComInfo.getCompanyid()%>" <%=isselected%>><%=CompanyComInfo.getCompanyname()%></OPTION>
				  <%}%>
				</SELECT>
			  </TD>-->
			  <td width=100 class="field" align="left"> 
				<input  type=radio <%if (direction.equals("1")) {%>CHECKED<%}%> value=1 name=direction>
				<%=SystemEnv.getHtmlLabelName(2019,user.getLanguage())%></td>
			  <td width=100 class="field" align="left"> 
				<input  type=radio <%if (direction.equals("2")) {%>CHECKED<%}%> value=2 name=direction>
				<%=SystemEnv.getHtmlLabelName(2020,user.getLanguage())%></td>
			  <td></td>
		   </TR>
		   <TR><TD class=Line2 colSpan=5></TD></TR> 
		  </TABLE>

			<%
			String sql = "";
			String sqldepre = "";
			String sqldepre2 = "";
			String tempCapitalid = "";
			if (direction.equals("1")){
			sql=" select sum(startprice) sumprice from CptCapital where ((startdate='' or startdate is  null) or startdate <='"+currentdate +"') and ((enddate='' or enddate is  null) or enddate >='" + currentdate+"') ";
			}
			else{
			//计算折旧后的资产总值
			sql=" select sum(startprice) from CptCapital where ((startdate='' or startdate is  null) or startdate <='"+currentdate +"') and ((enddate='' or enddate is  null) or enddate >='" + currentdate+"') ";
			sqldepre=" select * from CptCapital where ((startdate='' or startdate is  null) or startdate <='"+currentdate +"') and ((enddate='' or enddate is  null) or enddate >='" + currentdate+"') ";
			}
			int ishead = 0;
			%>
			

		<div id=oDiv STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=topMargin%>;LEFT:<%=leftMargin%>;height:<%=dl.getMaxPos().y%>;width:<%=dl.getMaxPos().x%>">
		<img src = "<%if(needupdate==0){%>/org/org_wev8.jpg<%}else{%>/weaver/weaver.org.layout.ShowDepLayoutToPicServlet<%}%>" border=0>
		<%
		int curnum = 0;
		for (int i=0;i<dl.departments.size();i++) {
			Department depart = (Department)dl.departments.get(i);
			String tmpnum="";
			double tmpnum2=0.0;

			String tempCurrentprice="";

            String tempsptcount="";
            String tempstartprice="";
            String tempcapitalnum="";
            String tempdeprestartdate="";
            String tempdepreyear="";
            String tempdeprerate="";

			String sqldepretmp="";
			String sqltmp="";
			String sqltmp1="";
			departids +=",\"";
			departids += depart.id;
			departids +="\"";
			curnum += 1;
			
			if (depart.type == Department.TYPE_ZONGBU) {
		%>
			<TABLE onclick="oc_ShowMenu(<%=curnum%>,oc_divMenuTop)" cellpadding=1 cellspacing=1 Class=ChartTop STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=depart.y%>;LEFT:<%=depart.x%>;height:<%=depart.getWidthHeight().y%>;width:<%=depart.getWidthHeight().x%>">
				<TR height=28px><TD colspan=2 Class=ChartTop id=t><%=depart.name%></TD></TR>
				<TR height=14px><TD align=right><%=SystemEnv.getHtmlLabelName(2015,user.getLanguage())%></TD>
				<%
				tmpnum="";
				tmpnum2 = 0;
				tempCurrentprice = "";
				RecordSet2.execute(sql);
				if(RecordSet2.next()){
					tmpnum = RecordSet2.getString(1);
				}
				if(direction.equals("2")){
					RecordSet3.execute(sqldepre);
					while(RecordSet3.next()){
                        tempsptcount=RecordSet3.getString("sptcount");
                        tempstartprice=RecordSet3.getString("startprice");
                        tempcapitalnum=RecordSet3.getString("capitalnum");
                        tempdeprestartdate=RecordSet3.getString("deprestartdate");
                        tempdepreyear=RecordSet3.getString("depreyear");
                        tempdeprerate=RecordSet3.getString("deprerate");
                        CapitalCurPrice.setSptcount(tempsptcount);
                        CapitalCurPrice.setStartprice(tempstartprice);
                        CapitalCurPrice.setCapitalnum(tempcapitalnum);
                        CapitalCurPrice.setDeprestartdate(tempdeprestartdate);
                        CapitalCurPrice.setDepreyear(tempdepreyear);
                        CapitalCurPrice.setDeprerate(tempdeprerate);
                        tempCurrentprice=CapitalCurPrice.getCurPrice();

						tmpnum2+=Double.parseDouble(tempCurrentprice);
					}
					tmpnum2 = ((int)(tmpnum2*100))/100.00;
					tmpnum = ""+tmpnum2;
				}
				%>
				<TD class=ChartCell><%=tmpnum%></TD>
				</TR>
			</TABLE>		
		<%
			} else if (depart.type == Department.TYPE_FENBU) {
				int subcompanyid = depart.id;
		%>
			<TABLE onclick="oc_ShowMenu(<%=curnum%>,oc_divMenuGroup)" cellpadding=1 cellspacing=1 Class=ChartGroup STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=depart.y%>;LEFT:<%=depart.x%>;height:<%=depart.getWidthHeight().y%>;width:<%=depart.getWidthHeight().x%>">
				<TR height=28px><TD colspan=1 TITLE="<%=depart.name%>" id=t><%=depart.name%></TD></TR>
				<TR height=14px>
				<%
				sqltmp=sql;
				sqldepretmp=sqldepre;
				
				String tmpdepids = ",-1";
				sqltmp1 = "select id from HrmDepartment where  subcompanyid1="+subcompanyid+" or  subcompanyid1  in (select id from hrmsubcompany where supsubcomid="+subcompanyid+") " ;
				RecordSet2.execute(sqltmp1);
				while(RecordSet2.next())
				tmpdepids +=","+RecordSet2.getString("id");
				tmpdepids=tmpdepids.substring(1);
				
					if (direction.equals("1")){
						sqltmp += " and departmentid in ("+tmpdepids +")";
					}
					else{
					//计算折旧后的分部资产值
						sqltmp += " and departmentid in ("+tmpdepids +")";
						sqldepretmp+=" and departmentid in ("+tmpdepids +")";
					}
				
				RecordSet2.execute(sqltmp);
				if(RecordSet2.next()){
					tmpnum = RecordSet2.getString(1);
				}
				if(direction.equals("2")&&(!tmpnum.equals(""))){
					RecordSet3.execute(sqldepretmp);
					tmpnum2=0;
					while(RecordSet3.next()){
                        tempsptcount=RecordSet3.getString("sptcount");
                        tempstartprice=RecordSet3.getString("startprice");
                        tempcapitalnum=RecordSet3.getString("capitalnum");
                        tempdeprestartdate=RecordSet3.getString("deprestartdate");
                        tempdepreyear=RecordSet3.getString("depreyear");
                        tempdeprerate=RecordSet3.getString("deprerate");
                        CapitalCurPrice.setSptcount(tempsptcount);
                        CapitalCurPrice.setStartprice(tempstartprice);
                        CapitalCurPrice.setCapitalnum(tempcapitalnum);
                        CapitalCurPrice.setDeprestartdate(tempdeprestartdate);
                        CapitalCurPrice.setDepreyear(tempdepreyear);
                        CapitalCurPrice.setDeprerate(tempdeprerate);
                        tempCurrentprice=CapitalCurPrice.getCurPrice();

						tmpnum2+=Double.parseDouble(tempCurrentprice);
					}
					tmpnum2 = ((int)(tmpnum2*100))/100.00;
					tmpnum = ""+tmpnum2;
					tmpnum2 = 0;	
				}
				%>
				<TD class=ChartCell width=100%><%=tmpnum%></TD>		
				</TR>
			</TABLE>
		<%
			} else if (depart.type == Department.TYPE_COMMON_DEPARTMENT) {
		%>
			<TABLE onclick="oc_ShowMenu(<%=curnum%>,oc_divMenuDivision)" cellpadding=1 cellspacing=1 Class=ChartCompany STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=depart.y%>;LEFT:<%=depart.x%>;height:<%=depart.getWidthHeight().y%>;width:<%=depart.getWidthHeight().x%>">
				<TR height=28px><TD colspan=1 TITLE="<%=depart.name%>" id=t><%=depart.departmentMark%>-<%=depart.name%></TD></TR>
				<TR height=14px>
				<%
				sqltmp=sql;
				sqldepretmp=sqldepre;
				
					if (direction.equals("1")){
						sqltmp += " and ( departmentid="+depart.id+")";
					}
					else{
					//计算折旧后的部门资产值
					sqltmp += " and ( departmentid="+depart.id+")";
					sqldepretmp+= " and ( departmentid="+depart.id+")";
					}
				RecordSet2.execute(sqltmp);
				if(RecordSet2.next()){
					tmpnum = RecordSet2.getString(1);
				}
				if(direction.equals("2")&&(!tmpnum.equals(""))){
					RecordSet3.execute(sqldepretmp);
					tmpnum2=0;
					while(RecordSet3.next()){
                        tempsptcount=RecordSet3.getString("sptcount");
                        tempstartprice=RecordSet3.getString("startprice");
                        tempcapitalnum=RecordSet3.getString("capitalnum");
                        tempdeprestartdate=RecordSet3.getString("deprestartdate");
                        tempdepreyear=RecordSet3.getString("depreyear");
                        tempdeprerate=RecordSet3.getString("deprerate");
                        CapitalCurPrice.setSptcount(tempsptcount);
                        CapitalCurPrice.setStartprice(tempstartprice);
                        CapitalCurPrice.setCapitalnum(tempcapitalnum);
                        CapitalCurPrice.setDeprestartdate(tempdeprestartdate);
                        CapitalCurPrice.setDepreyear(tempdepreyear);
                        CapitalCurPrice.setDeprerate(tempdeprerate);
                        tempCurrentprice=CapitalCurPrice.getCurPrice();

						tmpnum2+=Double.parseDouble(tempCurrentprice);
					}
					tmpnum2 = ((int)(tmpnum2*100))/100.00;
					tmpnum = ""+tmpnum2;
				}
				%>
				<TD class=ChartCell width=100%><%=tmpnum%></TD>
				</TR>
				</TABLE>
				
		<%  } // end of if
		} // end of for
		%>
		</div>
		<DIV style="position:absolute;top:947;left:804;visibility:hidden;width:1;height:1;"></DIV>
		<SCRIPT language=VBScript>
		oc_DivisionList=array(<%=departids%>)



		dim oc_CurrentMenu
		dim oc_CurrentIndex

		Sub oc_ShowMenu(Index,elMenu)
			dim t
			on error resume next
			oc_CurrentMenu.style.visibility="hidden"
			on error goto 0
			Set oc_CurrentMenu=elMenu
			oc_CurrentIndex = Index

			' title
			set elFrom = window.event.srcElement
			do while elFrom.tagName<>"TABLE"
				set elFrom = elFrom.parentElement
			loop
			elMenu.all("t").innerText = elFrom.all("t").innerText

			st = document.body.scrollTop
			oh = document.body.offsetHeight
			t = (st + window.event.clientY) - 2
			l = (document.body.scrollLeft + window.event.clientX) -10
			h = elMenu.clientHeight
			w = elMenu.clientWidth

			if ((l + w) > (document.body.scrollLeft + document.body.offsetWidth)) then l = l - (w-20)
			if ((t + h) > (document.body.scrollTop + document.body.offsetHeight)) then t = t - (h+2)

			elMenu.style.left = l
			elMenu.style.top = t
			elMenu.style.visibility = "visible"
		End Sub

		Sub oc_CurrentMenuOnMouseOut()
			set el = window.event.srcElement
			if (el.tagName = "A") then set el = el.parentElement
			if (el.tagName = "IMG") then set el = el.parentElement
			if (el.tagName = "TD" AND el.className <> "MenuPopupSelected" AND el.className <> "NoHand") then el.className = "MenuPopup"
		End Sub

		Sub oc_CurrentMenuOnMouseOver()
			set el = window.event.srcElement
			if (el.tagName = "A") then set el = el.parentElement
			if (el.tagName = "IMG") then set el = el.parentElement
			if (el.tagName = "TD" AND el.className <> "MenuPopupSelected" AND el.className <> "NoHand") then el.className = "MenuPopupFocus"
		End Sub

		Sub document_onmouseover
			on error resume next
			If window.event.srcElement.tagName = "BODY" Then
				oc_CurrentMenu.style.visibility = "hidden"
			End If
		End Sub

		Sub document_onmouseup
			on error resume next
			If window.event.srcElement.tagName = "BODY" Then
				oc_CurrentMenu.style.visibility = "hidden"
			End If
		End Sub

		Function oc_getAllDivisions(isQuoted)
			oc_getAllDivisions = Null
			For i = 1 To UBound(oc_DivisionList)
				d = oc_DivisionList(i)
				If isQuoted Then d = "'" & d & "'"
				oc_getAllDivisions = oc_getAllDivisions + "," & d
			Next
		End Function
		</SCRIPT>


			<DIV id="oc_divMenuTop" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
			<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuonmouseout()" onmouseover="return oc_CurrentMenuonmouseover()" style="HEIGHT: 79px; WIDTH: 246px">
			<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD>
			</TR>
			
			</TABLE>
			</DIV>
			<DIV id="oc_divMenuGroup" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
			<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuonmouseout()" onmouseover="return oc_CurrentMenuonmouseover()" style="HEIGHT: 79px; WIDTH: 246px">
			<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD></TR>
			
			</TABLE>
			</DIV>
			<DIV id="oc_divMenuDivision" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
			<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuonmouseout()" onmouseover="return oc_CurrentMenuonmouseover()" style="HEIGHT: 79px; WIDTH: 246px">
			<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD></TR>
			
				 <TR id=D1><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD></TR>
			
				 <TR id=D2><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></TD></TR>
			
			</TABLE>
			</DIV>
			<SCRIPT LANGUAGE=VBScript>
			Sub oc_CurrentMenuOnClick
				set el = window.event.srcElement
				if (el.tagName = "A") then set el = el.parentElement
				select case el.parentElement.id
				
					case "D1"
						r="/hrm/company/HrmDepartmentDsp.jsp?id=" & oc_DivisionList(oc_CurrentIndex)
					case "D2"
						r="/Cpt/search/SearchOperation.jsp?departmentid=" & oc_DivisionList(oc_CurrentIndex)
				end select
				oc_CurrentMenu.style.visibility = "hidden"
				if (r <> "") then
					window.event.returnValue = false
					window.location.href = r
				end if
			End Sub
			</SCRIPT>

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

</BODY>
<script language="javascript">
 function onSubmit(){ 	
	document.Baco.submit();
 }
</script>
</HTML>
