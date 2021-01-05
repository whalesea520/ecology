<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>
<jsp:useBean id="CostCenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page" />
<jsp:useBean id="CostcenterMainComInfo" class="weaver.hrm.company.CostcenterMainComInfo" scope="page" />
<jsp:useBean id="CostcenterSubComInfo" class="weaver.hrm.company.CostcenterSubComInfo" scope="page" />

<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="IndicatorComInfo" class="weaver.fna.maintenance.IndicatorComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BudgetModuleComInfo" class="weaver.fna.maintenance.BudgetModuleComInfo" scope="page" />
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
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%

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
<%
int id = Util.getIntValue(request.getParameter("id"),0);

int ccmain = Util.getIntValue(request.getParameter("ccmain"),1);

String ccids="\"\"";

int subcompanycount =0;

int cursub = -1;

char flag = 2;
RecordSet.executeProc("HrmCostcenter_SelectByDeptID",""+id+flag+ccmain);

subcompanycount=RecordSet.getCounts();

int clientwidth = 125*subcompanycount;

int top = 210;
int cellHeight = 66;
int cellWidth = 105;
int cellWidth2 = 420;
int lineHeight1 = 7;
int lineHeight2 = 73;
int lineWidth = 5;
int cellSpace = 20;
int linestep = 17;

String fnayear = Util.null2String(request.getParameter("fnayear"));
if(fnayear.equals("")) {
	RecordSet3.executeProc("FnaYearsPeriods_SelectMaxYear","");
	if(RecordSet3.next()) fnayear = RecordSet3.getString("fnayear") ;
	else {
		fnayear = Util.add0(today.get(Calendar.YEAR), 4) ;
	}
}

String periodsidfrom = Util.null2String(request.getParameter("periodsidfrom"));
String periodsidto = Util.null2String(request.getParameter("periodsidto"));
if(periodsidfrom.equals("")|| periodsidfrom.equals("0")) periodsidfrom = "1" ;
if(periodsidto.equals("")) periodsidto = "12" ;
if(Util.getIntValue(periodsidfrom) > Util.getIntValue(periodsidto)) {
	String tempperiods ="" ;
	tempperiods = periodsidfrom ; periodsidfrom = periodsidto ; periodsidto = tempperiods ;
}
String dbperiodsfrom = fnayear + Util.add0(Util.getIntValue(periodsidfrom),2) ;
String dbperiodsto = fnayear + Util.add0(Util.getIntValue(periodsidto),2) ;

String indicator = Util.null2String(request.getParameter("indicator"));
if(indicator.equals("")) {
	RecordSet3.executeProc("FnaIndicator_SelectMinYear","");
	if(RecordSet3.next()) indicator = RecordSet3.getString(1) ;
}

RecordSet3.executeProc("FnaCurrency_SelectByDefault","");
RecordSet3.next();
String defcurrenyid = RecordSet3.getString(1);

String factor = Util.null2String(request.getParameter("factor"));
String compare = Util.null2String(request.getParameter("compare"));
if(compare.equals(""))
	compare = "0";
		
String moduleid = Util.null2String(request.getParameter("moduleid"));


%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HrmCostCenterAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/company/HrmCostcenterAdd.jsp?depid="+id+",_self} " ;
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
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM action="HrmCostcenterChart.jsp" id=Baco method=post>
<DIV id=wait style="filter:alpha(opacity=30); height:100%; width:100%">
<TABLE width="100%" height="100%">
	<TR><TD align=center style="font-size: 36pt;"><%=SystemEnv.getHtmlLabelName(562,user.getLanguage())%>...</TD></TR>
</TABLE>
	<TABLE class="viewForm">
	<COLGROUP>
  	<COL width="16%">
  	<COL width="17%">
  	<COL width="17%">
	<COL width="16%">
  	<COL width="17%">
  	<COL width="17%">
		<TR class="title">
		 <TH colspan="6" ><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
		</TR>
		<TBODY >
		<TR class=spacing><TD colspan="6" class=Sep1></TD></TR>
		<tr>
		<td width=16%><%=SystemEnv.getHtmlLabelName(1872,user.getLanguage())%></td>
      <td class=Field width=17%> 
        <select name="fnayear">
          <%
		RecordSet3.executeProc("FnaYearsPeriods_Select","");
		while(RecordSet3.next()) {
			String thefnayear = RecordSet3.getString("fnayear") ;
		%>
          <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayear)) {%>selected<%}%>><%=thefnayear%></option>
          <%}
		RecordSet3.beforFirst() ;
		%>
        </select>
        </td>
          <td class=Field width=17%> 
        <%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%> 
        <input id=periodsidfrom name=periodsidfrom maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsidfrom")' size="5" value="<%=periodsidfrom%>">
        <%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%> 
        <input id=periodsidto name=periodsidto maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsidto")' size="5" value="<%=periodsidto%>">
      </td>      
      <td width=16%><%=SystemEnv.getHtmlLabelName(1873,user.getLanguage())%></td>
      <td class=field width=17%>
      <select name=indicator>
      <%
      while(IndicatorComInfo.next()){
      		String tmpid1 = IndicatorComInfo.getIndicatorid();
      %>
      <option value="<%=tmpid1%>" <%if(tmpid1.equals(indicator)){%> selected<%}%>><%=IndicatorComInfo.getIndicatorname()%></option>
      <%}%>
      </select>
      </td>
      <td class=field>
<!--	<SELECT name=ccmain>
	<%
	while(CostcenterMainComInfo.next()){	
		String tmpcompanyid = CostcenterMainComInfo.getCostcenterMainid();
		String isselected="";
		if(Util.getIntValue(tmpcompanyid,0)==ccmain)
			isselected=" selected";
	%>
		<OPTION value="<%=CostcenterMainComInfo.getCostcenterMainid()%>" <%=isselected%>><%=CostcenterMainComInfo.getCostcenterMainname()%></OPTION>
	<%}%></SELECT>
-->	
    <%=CostcenterMainComInfo.getCostcenterMainname(""+1)%> 
	</TD>
	
      
      <tr>
      <td width=16%><%=SystemEnv.getHtmlLabelName(1874,user.getLanguage())%></td>
      <td class=field><%=Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrenyid),user.getLanguage())%></td>
      <td class=field>
      <select name=factor>
      <option value="1" <%if(factor.equals("1")){%> selected <%}%>>1</option>
      <option value="100" <%if(factor.equals("100")){%> selected <%}%>>100</option>
      <option value="1000000" <%if(factor.equals("1000000")){%> selected <%}%>>1000000</option>
      </select>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(1875,user.getLanguage())%></td>
      <td class=field>
      <select name=compare>
      <option value="0" <%if(compare.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1876,user.getLanguage())%></option>
      <option value="1" <%if(compare.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></option>
      </select>
      </td>
      <td class=field>
      <select name=moduleid>
        <% while(BudgetModuleComInfo.next(fnayear)) { 
		String tmpbudgetmoduleid = BudgetModuleComInfo.getBudgetModuleid() ;
		String tmpbudgetmodulename = Util.toScreen(BudgetModuleComInfo.getBudgetModulename(), user.getLanguage()) ;
		%>
          <option value=<%=tmpbudgetmoduleid%> <% if(moduleid.equals(tmpbudgetmoduleid)) {%>selected <%}%>><%=tmpbudgetmodulename%></option>
          <%}%>
      </select>
      </td>
      <input type=hidden name=id value="<%=id%>">
      </tr>
		</TBODY>
	</TABLE>	
	
	<%
	String sql= "" ;
    String sql1= "" ;
    String comparesql = "" ;
    String comparesql1 = "" ;

    if((RecordSet.getDBType()).equals("oracle")) {
        sql = "select sum((TO_number(indicatorbalance)*2-3)*(TO_number(tranbalance)*2-3)*tranaccount) as count from FnaIndicatordetail,FnaAccountCostcenter,FnaIndicator where FnaIndicatordetail.ledgerid=FnaAccountCostcenter.ledgerid  and FnaIndicator.id = FnaIndicatordetail.indicatorid ";
        sql1="select sum((TO_number(indicatorbalance)*2-3)*(TO_number(tranbalance)*2-3)*tranaccount) as count from FnaIndicatordetail,FnaAccountCostcenter,FnaIndicator where FnaIndicatordetail.ledgerid=FnaAccountCostcenter.ledgerid  and FnaIndicator.id = FnaIndicatordetail.indicatorid ";
        comparesql="select sum((TO_number(indicatorbalance)*2-3)*(TO_number(tranbalance)*2-3)*tranaccount) as count from FnaIndicatordetail,FnaAccountCostcenter,FnaIndicator where FnaIndicatordetail.ledgerid=FnaAccountCostcenter.ledgerid  and FnaIndicator.id = FnaIndicatordetail.indicatorid ";
        comparesql1="select sum((TO_number(indicatorbalance)*2-3)*(TO_number(tranbalance)*2-3)*tranaccount) as count from FnaIndicatordetail,FnaAccountCostcenter,FnaIndicator where FnaIndicatordetail.ledgerid=FnaAccountCostcenter.ledgerid  and FnaIndicator.id = FnaIndicatordetail.indicatorid ";
    }
    else {
        sql = "select sum((CONVERT(int,indicatorbalance)*2-3)*(CONVERT(int,tranbalance)*2-3)*tranaccount) as count from FnaIndicatordetail,FnaAccountCostcenter,FnaIndicator where FnaIndicatordetail.ledgerid=FnaAccountCostcenter.ledgerid  and FnaIndicator.id = FnaIndicatordetail.indicatorid ";
        sql1="select sum((CONVERT(int,indicatorbalance)*2-3)*(CONVERT(int,tranbalance)*2-3)*tranaccount) as count from FnaIndicatordetail,FnaAccountCostcenter,FnaIndicator where FnaIndicatordetail.ledgerid=FnaAccountCostcenter.ledgerid  and FnaIndicator.id = FnaIndicatordetail.indicatorid ";
        comparesql="select sum((CONVERT(int,indicatorbalance)*2-3)*(CONVERT(int,tranbalance)*2-3)*tranaccount) as count from FnaIndicatordetail,FnaAccountCostcenter,FnaIndicator where FnaIndicatordetail.ledgerid=FnaAccountCostcenter.ledgerid  and FnaIndicator.id = FnaIndicatordetail.indicatorid ";
        comparesql1="select sum((CONVERT(int,indicatorbalance)*2-3)*(CONVERT(int,tranbalance)*2-3)*tranaccount) as count from FnaIndicatordetail,FnaAccountCostcenter,FnaIndicator where FnaIndicatordetail.ledgerid=FnaAccountCostcenter.ledgerid  and FnaIndicator.id = FnaIndicatordetail.indicatorid ";
    }

	if(compare.equals("1")){
		comparesql="select sum(budgetaccount) as count from FnaIndicatordetail,FnaBudgetCostcenter where FnaIndicatordetail.ledgerid=FnaBudgetCostcenter.ledgerid and FnaBudgetCostcenter.budgetmoduleid="+moduleid+ " ";
		comparesql1="select sum(budgetaccount) as count from FnaIndicatordetail,FnaBudgetCostcenter where FnaIndicatordetail.ledgerid=FnaBudgetCostcenter.ledgerid and FnaBudgetCostcenter.budgetmoduleid="+moduleid+ " ";
	}
	
	int ishead = 0;
	String status="";
	
	if(!fnayear.equals("")){
		if(!periodsidfrom.equals("")){
			sql += " and FnaAccountCostcenter.tranperiods >='"+fnayear+Util.add0(Util.getIntValue(periodsidfrom,0),2)+"'";
			sql1 += " and FnaAccountCostcenter.tranperiods >='"+fnayear+Util.add0(Util.getIntValue(periodsidfrom,0),2)+"'";
			if(compare.equals("1")){
				comparesql += " and FnaBudgetCostcenter.budgetperiods >='"+fnayear+Util.add0(Util.getIntValue(periodsidfrom,0),2)+"'";
				comparesql1 += " and FnaBudgetCostcenter.budgetperiods >='"+fnayear+Util.add0(Util.getIntValue(periodsidfrom,0),2)+"'";
			}else{
				int tmpfnayear = Util.getIntValue(fnayear,0);
				comparesql += " and FnaAccountCostcenter.tranperiods >='"+(tmpfnayear-1)+Util.add0(Util.getIntValue(periodsidfrom,0),2)+"'";
				comparesql1 += " and FnaAccountCostcenter.tranperiods >='"+(tmpfnayear-1)+Util.add0(Util.getIntValue(periodsidfrom,0),2)+"'";
			}
		}
		if(!periodsidto.equals("")){
			sql += " and FnaAccountCostcenter.tranperiods <='"+fnayear+Util.add0(Util.getIntValue(periodsidto,0),2)+"'";
			sql1 += " and FnaAccountCostcenter.tranperiods <='"+fnayear+Util.add0(Util.getIntValue(periodsidto,0),2)+"'";
			if(compare.equals("1")){
				comparesql += " and FnaBudgetCostcenter.budgetperiods <='"+fnayear+Util.add0(Util.getIntValue(periodsidto,0),2)+"'";
				comparesql1 += " and FnaBudgetCostcenter.budgetperiods <='"+fnayear+Util.add0(Util.getIntValue(periodsidto,0),2)+"'";
			}else{
				int tmpfnayear = Util.getIntValue(fnayear,0);
				comparesql += " and FnaAccountCostcenter.tranperiods <='"+(tmpfnayear-1)+Util.add0(Util.getIntValue(periodsidto,0),2)+"'";
				comparesql1 += " and FnaAccountCostcenter.tranperiods <='"+(tmpfnayear-1)+Util.add0(Util.getIntValue(periodsidto,0),2)+"'";
			}
			
		}		
	}
	
	
	
	String indicatortype="";
	String indicatorbalance="";
	String haspercent="";
	String indicatoridfirst="";
	String indicatoridlast="";

    if(!indicator.equals("")) {
	    RecordSet2.executeProc("FnaIndicator_SelectByID",indicator);
        if(RecordSet2.next()){
            indicatortype=RecordSet2.getString("indicatortype");
            indicatorbalance=RecordSet2.getString("indicatorbalance");
            haspercent=RecordSet2.getString("haspercent");
            indicatoridfirst=RecordSet2.getString("indicatoridfirst");
            indicatoridlast=RecordSet2.getString("indicatoridlast");
        }
    }
	
	if(indicatortype.equals("0")){
		sql += " and FnaIndicatordetail.indicatorid ="+indicator;
		comparesql += " and FnaIndicatordetail.indicatorid ="+indicator;
	}
	else if(indicatortype.equals("1")){
	   if(RecordSet.getDBType().equals("oracle")){
		sql = " select count(id) from HrmResource where ( startdate<'"+ currentdate+"' or (startdate is  null)) and (enddate>'" + currentdate+ "' or (enddate is  null))";
		comparesql = " select count(id) from HrmResource where ( startdate<'"+ currentdate+"' or (startdate is  null)) and (enddate>'" + currentdate+ "' or (or enddate is  null))";
	   }else{
	        sql = " select count(id) from HrmResource where ( startdate<'"+ currentdate+"' or (startdate='' or startdate is  null)) and (enddate>'" + currentdate+ "' or (enddate='' or enddate is  null))";
		comparesql = " select count(id) from HrmResource where ( startdate<'"+ currentdate+"' or (startdate='' or startdate is  null)) and (enddate>'" + currentdate+ "' or (enddate='' or enddate is  null))";
	   }
	}
	else if(indicatortype.equals("2")){
		
		String tmptype1 = IndicatorComInfo.getIndicatortype(indicatoridfirst);
		if(tmptype1.equals("0")){
			sql += " and FnaIndicatordetail.indicatorid ="+indicatoridfirst;
			comparesql += " and FnaIndicatordetail.indicatorid ="+indicatoridfirst;
		}
		else if(tmptype1.equals("1")){
		  if(RecordSet.getDBType().equals("oracle")){
			sql = " select count(id) from HrmResource where ( startdate<'"+ currentdate+"' or (startdate is  null)) and (enddate>'" + currentdate+ "' or (enddate is  null))";
			comparesql = " select count(id) from HrmResource where ( startdate<'"+ currentdate+"' or (startdate is  null)) and (enddate>'" + currentdate+ "' or (enddate is  null))";
		  }else{
		  	sql = " select count(id) from HrmResource where ( startdate<'"+ currentdate+"' or (startdate='' or startdate is  null)) and (enddate>'" + currentdate+ "' or (enddate='' or enddate is  null))";
			comparesql = " select count(id) from HrmResource where ( startdate<'"+ currentdate+"' or (startdate='' or startdate is  null)) and (enddate>'" + currentdate+ "' or (enddate='' or enddate is  null))";
		  }	
		}
		
		String tmptype2 = IndicatorComInfo.getIndicatortype(indicatoridlast);
		
		if(tmptype2.equals("0")){
			sql1 += " and FnaIndicatordetail.indicatorid ="+indicatoridlast;
			comparesql1 += " and FnaIndicatordetail.indicatorid ="+indicatoridlast;
		}
		else if(tmptype2.equals("1")){
		if(RecordSet.getDBType().equals("oracle")){
			sql1 = " select count(id) from HrmResource where ( startdate<'"+ currentdate+"' or (startdate is  null)) and (enddate>'" + currentdate+ "' or (enddate is  null))";
			comparesql1 = " select count(id) from HrmResource where ( startdate<'"+ currentdate+"' or (startdate is  null)) and (enddate>'" + currentdate+ "' or (enddate is  null))";
		}else{
			sql1 = " select count(id) from HrmResource where ( startdate<'"+ currentdate+"' or (startdate='' or startdate is  null)) and (enddate>'" + currentdate+ "' or (enddate='' or enddate is  null))";
			comparesql1 = " select count(id) from HrmResource where ( startdate<'"+ currentdate+"' or (startdate='' or startdate is  null)) and (enddate>'" + currentdate+ "' or (enddate='' or enddate is  null))";
		}
		}
		
	}
	
//	out.print("sql:"+sql+"$$$$$$$$$$$$$$"+"sql1"+sql1);
	int curnum = 0;
	%>
	
	 <TABLE CLASS=ListShort>
	   <COL WIDTH=10%><COL WIDTH=20%><COL WIDTH=*%>
		
		  <TR class="separator">
			 <TD colspan="10" class="Sep3" ></TD>
		  </TR>
	</TABLE>
			<TABLE onclick="oc_ShowMenu 1,oc_divMenuTop" cellpadding=1 cellspacing=1 Class=ChartTop STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=top%>;LEFT:<%=(clientwidth/2-cellWidth2/2)>0?(clientwidth/2-cellWidth2/2):20%>;height:<%=cellHeight%>;width:<%=cellWidth2%>">
		<COL WIDTH=300px><COL>
		<TR height=28px><TD colspan=2 Class=ChartTop id=t  TITLE="<%=DepartmentComInfo.getDepartmentname(""+id)%>" ><%=DepartmentComInfo.getDepartmentmark(""+id)%>-<%=DepartmentComInfo.getDepartmentname(""+id)%></TD></TR>
		<TR height=14px>
		<TD align=right><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%> <%=fnayear%></TD>
		<%
		String tmpnum="";
		if(!indicatortype.equals("2")){
			RecordSet2.execute(sql);
			if(RecordSet2.next()){
				if(indicatortype.equals("0"))
					tmpnum = ""+(Util.getFloatValue(RecordSet2.getString(1),0))/(Util.getIntValue(factor,1));
				else if(indicatortype.equals("1"))
					tmpnum = ""+Util.getIntValue(RecordSet2.getString(1),0);
			}
			
		}
		else{
			float num1=0;
			float num2=0;
			
			RecordSet2.execute(sql);
			if(RecordSet2.next())
				num1 = Util.getFloatValue(RecordSet2.getString(1),0)/(Util.getIntValue(factor,1));
			RecordSet2.execute(sql1);
			if(RecordSet2.next())
				num2 = Util.getFloatValue(RecordSet2.getString(1),0);
			if(num2!=0){
				if(haspercent.equals("1")){
					num1 = num1/num2;
					num1 = num1*100;
					tmpnum = ""+ num1 +"%";
				}
				else
					tmpnum = ""+ num1/num2;
			}
			else
				tmpnum = ""+num1+":0";			
		}
		%>
		<TD class=ChartCell><%=tmpnum%></TD>
		</TR>
		<TR height=14px><TD align=right>
		<%
		if(compare.equals("0")){
		%>
		<%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%> <%=(Util.getIntValue(fnayear,0)-1)%>
		<%}%>
		<%
		if(compare.equals("1")){
		%>
		<%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%> <%=fnayear%>
		<%}%>
		</TD>
		<%
		
		if(!indicatortype.equals("2")){
			RecordSet2.execute(comparesql);
			if(RecordSet2.next()){
				if(indicatortype.equals("0"))
					tmpnum = ""+(Util.getFloatValue(RecordSet2.getString(1),0))/(Util.getIntValue(factor,1));
				else if(indicatortype.equals("1"))
					tmpnum = ""+Util.getIntValue(RecordSet2.getString(1),0);
			}
			
		}
		else{
			float num1=0;
			float num2=0;
			
			RecordSet2.execute(comparesql);
			if(RecordSet2.next())
				num1 = Util.getFloatValue(RecordSet2.getString(1),0)/(Util.getIntValue(factor,1));
			RecordSet2.execute(comparesql1);
			if(RecordSet2.next())
				num2 = Util.getFloatValue(RecordSet2.getString(1),0);
			if(num2!=0){
				if(haspercent.equals("1")){
					num1 = num1/num2;
					num1 = num1*100;
					tmpnum = ""+ num1 +"%";
				}
				else
					tmpnum = ""+ num1/num2;
			}
			else
				tmpnum = ""+num1+":0";			
		}
		%>
		<TD class=ChartCell><%=tmpnum%></TD>
		</TR>
		</TABLE>

<%if(subcompanycount==0){%>
	<%=SystemEnv.getHtmlLabelName(1877,user.getLanguage())%>
<%}
else{
%>



		<DIV HEIGHT=1 Class=line Style="POSITION:absolute;LEFT:<%=clientwidth/2%>;TOP:<%=top+cellHeight%>;WIDTH:1;HEIGHT:<%=lineHeight1%>"></DIV>
		
		<HR Size=1 style="POSITION:absolute;COLOR:black;BACKGROUND-COLOR:black;BORDER-BOTTOM:black 1;HEIGHT: 1;LEFT:<%=(cellSpace+cellWidth/2)%>;TOP:<%=top+cellHeight+lineHeight1%> ; WIDTH:<%=clientwidth-cellWidth-cellSpace%>;Z-INDEX: 50">
<%}%>		
		<%
		top=top+cellHeight+lineHeight1;
		int subcompanynum = 0;
		while(RecordSet.next()){
			String subcompanyid=RecordSet.getString(1);;
			subcompanynum+=1;
			int leftstep = (subcompanynum-1)*(cellWidth+cellSpace);
		%>
		<DIV Class=line Style="LEFT:<%=(leftstep+cellSpace+cellWidth/2)%>; TOP:<%=top%>; WIDTH:1; HEIGHT:<%=lineHeight1%>"></DIV>
		
		<TABLE onclick="oc_ShowMenu <%=subcompanynum%>,oc_divMenuGroup" cellpadding=1 cellspacing=1 Class=ChartGroup 
		STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=top+lineHeight1%>;LEFT:<%=leftstep+cellSpace%>;height:<%=cellHeight%>;width:<%=cellWidth%>">
		<TR height=28px><TD colspan=1 TITLE="<%=CostcenterSubComInfo.getCostcenterSubname(subcompanyid)%>" id=t><%=CostcenterSubComInfo.getCostcenterSubname(subcompanyid)%></TD></TR>
		<TR height=14px>
		
		<%
		String sqltmp=sql;
		String sqltmp1=sql1;
		
		String tmpdepids = ",-1";
		String sqltmp2 ="select id from HrmCostcenter where ( ccsubcategory1="+subcompanyid + " or ccsubcategory2="+subcompanyid +" or ccsubcategory3="+subcompanyid +" or ccsubcategory4="+subcompanyid +")";
		RecordSet2.execute(sqltmp2);
		while(RecordSet2.next())
		tmpdepids +=","+RecordSet2.getString("id");
		tmpdepids=tmpdepids.substring(1);
		
		if(indicatortype.equals("0"))
			sqltmp += " and FnaAccountCostcenter.costcenterid in ("+tmpdepids +")";
		else if(indicatortype.equals("1")){
			sqltmp += " and costcenterid in("+tmpdepids +")";
		}
		else if(indicatortype.equals("2")){
			String tmptype1 = IndicatorComInfo.getIndicatortype(indicatoridfirst);
			if(tmptype1.equals("0"))
				sqltmp += " and FnaAccountCostcenter.costcenterid in ("+tmpdepids +")";
			else if(tmptype1.equals("1"))
				sqltmp += " and costcenterid in("+tmpdepids +")";
			
			String tmptype2 = IndicatorComInfo.getIndicatortype(indicatoridlast);
			if(tmptype2.equals("0"))
				sqltmp1 += " and FnaAccountCostcenter.costcenterid in ("+tmpdepids +")";
			else if(tmptype2.equals("1"))
				sqltmp1 += " and costcenterid in("+tmpdepids +")";
		}		
		
		if(!indicatortype.equals("2")){
			RecordSet2.execute(sqltmp);
			if(RecordSet2.next()){
				if(indicatortype.equals("0"))
					tmpnum = ""+Util.getFloatValue(RecordSet2.getString(1),0)/(Util.getIntValue(factor,1));
				else if(indicatortype.equals("1"))
					tmpnum = ""+Util.getIntValue(RecordSet2.getString(1),0);
			}
			
		}
		else{
			float num1=0;
			float num2=0;
			
			RecordSet2.execute(sqltmp);
			if(RecordSet2.next())
				num1 = Util.getFloatValue(RecordSet2.getString(1),0)/(Util.getIntValue(factor,1));
			RecordSet2.execute(sqltmp1);
			if(RecordSet2.next())
				num2 = Util.getFloatValue(RecordSet2.getString(1),0);
			if(num2!=0){
				if(haspercent.equals("1")){
					num1 = num1/num2;
					num1 = num1*100;
					tmpnum = ""+ num1 +"%";
				}
				else
					tmpnum = ""+ num1/num2;
			}
			else
				tmpnum = ""+num1+":0";			
		}
		
		%>
		<TD class=ChartCell width=100%><%=tmpnum%></TD>		
		</TR>	
		<TR height=14px>
		<%
		 sqltmp = comparesql;
		 sqltmp1 = comparesql1;
		if(indicatortype.equals("0")){
			if(compare.equals("0"))
				sqltmp += " and FnaAccountCostcenter.costcenterid in ("+tmpdepids +")";
			else
				sqltmp += " and FnaBudgetCostcenter.costcenterid in ("+tmpdepids +")";
		}
		else if(indicatortype.equals("1")){
			sqltmp += " and costcenterid in("+tmpdepids +")";
		}
		else if(indicatortype.equals("2")){
			String tmptype1 = IndicatorComInfo.getIndicatortype(indicatoridfirst);
			if(tmptype1.equals("0")){
				if(compare.equals("0"))
					sqltmp += " and FnaAccountCostcenter.costcenterid in ("+tmpdepids +")";
				else
					sqltmp += " and FnaBudgetCostcenter.costcenterid in ("+tmpdepids +")";
			}
			else if(tmptype1.equals("1"))
				sqltmp += " and costcenterid in("+tmpdepids +")";
			
			String tmptype2 = IndicatorComInfo.getIndicatortype(indicatoridlast);
			if(tmptype2.equals("0")){
				if(compare.equals("0"))
					sqltmp1 += " and FnaAccountCostcenter.costcenterid in ("+tmpdepids +")";
				else
					sqltmp1 += " and FnaBudgetCostcenter.costcenterid in ("+tmpdepids +")";
			}
			else if(tmptype2.equals("1"))
				sqltmp1 += " and costcenterid in("+tmpdepids +")";
		}		
		
		if(!indicatortype.equals("2")){
			RecordSet2.execute(sqltmp);
			if(RecordSet2.next()){
				if(indicatortype.equals("0"))
					tmpnum = ""+Util.getFloatValue(RecordSet2.getString(1),0)/(Util.getIntValue(factor,1));
				else if(indicatortype.equals("1"))
					tmpnum = ""+Util.getIntValue(RecordSet2.getString(1),0);
			}
			
		}
		else{
			float num1=0;
			float num2=0;
			
			RecordSet2.execute(sqltmp);
			if(RecordSet2.next())
				num1 = Util.getFloatValue(RecordSet2.getString(1),0)/(Util.getIntValue(factor,1));
			RecordSet2.execute(sqltmp1);
			if(RecordSet2.next())
				num2 = Util.getFloatValue(RecordSet2.getString(1),0);
			if(num2!=0){
				if(haspercent.equals("1")){
					num1 = num1/num2;
					num1 = num1*100;
					tmpnum = ""+ num1 +"%";
				}
				else
					tmpnum = ""+ num1/num2;
			}
			else
				tmpnum = ""+num1+":0";			
		}
		%><TD class=ChartCell width=100%><%=tmpnum%></TD>		
		</TR>	
		</TABLE>
		<%
		int curtop = top+lineHeight1+cellHeight/2-lineHeight2;
		
		while(CostCenterComInfo.next()){
			String tmpid = CostCenterComInfo.getSubcategoryid1();
/*	         	if(ccmain==1)
	         		tmpid = CostCenterComInfo.getSubcategoryid1();
	         	if(ccmain==2)
	         		tmpid = CostCenterComInfo.getSubcategoryid2();
	         	if(ccmain==3)
	         		tmpid = CostCenterComInfo.getSubcategoryid3();
	         	if(ccmain==4)
	         		tmpid = CostCenterComInfo.getSubcategoryid4();  
*/	         		
	         		
	         	if(!tmpid.equals(subcompanyid)) continue;
	         	String departid = CostCenterComInfo.getDepartmentid();
	         	if((Util.getIntValue(departid,-1)!=id)) continue;
	         	ccids +=",\"";
	         	ccids += CostCenterComInfo.getCostCenterid();
	         	ccids +="\"";
	         	curnum += 1;
	         	curtop += lineHeight2;
	         	
		%>
		
		<DIV class=line style="LEFT:<%=leftstep+cellSpace+linestep%>; TOP:<%=curtop%>; WIDTH:5; HEIGHT:<%=lineHeight2%>"></DIV>
		<TABLE onclick="oc_ShowMenu <%=curnum%>,oc_divMenuDivision" cellpadding=1 cellspacing=1 Class=ChartCompany 
		STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=curtop+lineHeight2-cellHeight/2%>;LEFT:<%=leftstep+cellSpace+linestep+lineWidth%>;height:<%=cellHeight%>;width:<%=cellWidth%>">
		<TR height=28px><TD colspan=2 TITLE="<%=CostCenterComInfo.getCostCentername()%>" id=t><%=CostCenterComInfo.getCostCentername()%></TD></TR>
		<TR height=14px>
		<td align=left width=20%>
		<img src="/images/PeriodOpen_wev8.gif" border=0></img>
		</td>
		<%
		sqltmp=sql;
		sqltmp1=sql1;
		
		if(indicatortype.equals("0"))
			sqltmp += " and FnaAccountCostcenter.costcenterid ="+CostCenterComInfo.getCostCenterid()+"";
		else if(indicatortype.equals("1")){
			sqltmp += " and costcenterid ="+CostCenterComInfo.getCostCenterid()+"";
		}
		else if(indicatortype.equals("2")){
			String tmptype1 = IndicatorComInfo.getIndicatortype(indicatoridfirst);
			if(tmptype1.equals("0"))
				sqltmp += " and FnaAccountCostcenter.costcenterid ="+CostCenterComInfo.getCostCenterid()+"";
			else if(tmptype1.equals("1"))
				sqltmp += " and costcenterid ="+CostCenterComInfo.getCostCenterid()+")";
			
			String tmptype2 = IndicatorComInfo.getIndicatortype(indicatoridlast);
			if(tmptype2.equals("0"))
				sqltmp1 += " and FnaAccountCostcenter.costcenterid ="+CostCenterComInfo.getCostCenterid()+"";
			else if(tmptype2.equals("1"))
				sqltmp1 += " and costcenterid ="+CostCenterComInfo.getCostCenterid()+"";
		}		
		
		if(!indicatortype.equals("2")){
			RecordSet2.execute(sqltmp);
			if(RecordSet2.next()){
				if(indicatortype.equals("0"))
					tmpnum = ""+Util.getFloatValue(RecordSet2.getString(1),0)/(Util.getIntValue(factor,1));
				else if(indicatortype.equals("1"))
					tmpnum = ""+Util.getIntValue(RecordSet2.getString(1),0);
			}
			
		}
		else{
			float num1=0;
			float num2=0;
			
			RecordSet2.execute(sqltmp);
			if(RecordSet2.next())
				num1 = Util.getFloatValue(RecordSet2.getString(1),0)/(Util.getIntValue(factor,1));
			RecordSet2.execute(sqltmp1);
			if(RecordSet2.next())
				num2 = Util.getFloatValue(RecordSet2.getString(1),0);
			if(num2!=0){
				if(haspercent.equals("1")){
					num1 = num1/num2;
					num1 = num1*100;
					tmpnum = ""+ num1 +"%";
				}
				else
					tmpnum = ""+ num1/num2;
			}
			else
				tmpnum = ""+num1+":0";			
		}
		
		%>
		<TD class=ChartCell width=80%><%=tmpnum%></TD>
		
		</TR>
		<TR height=14px>
		<td align=left width=20%>
		<img src="/images/ArrowEqual_wev8.gif" border=0></img>
		</td>
		<%
		sqltmp=comparesql;
		sqltmp1=comparesql1;
		
		if(indicatortype.equals("0")){
			if(compare.equals("0"))
				sqltmp += " and FnaAccountCostcenter.costcenterid ="+CostCenterComInfo.getCostCenterid()+" ";
			else
				sqltmp += " and FnaBudgetCostcenter.costcenterid ="+CostCenterComInfo.getCostCenterid()+" ";
			
		}
		
		else if(indicatortype.equals("1")){
			sqltmp += " and costcenterid ="+CostCenterComInfo.getCostCenterid()+"";
		}
		else if(indicatortype.equals("2")){
			String tmptype1 = IndicatorComInfo.getIndicatortype(indicatoridfirst);
			if(tmptype1.equals("0")){
				if(compare.equals("0"))
					sqltmp += " and FnaAccountCostcenter.costcenterid ="+CostCenterComInfo.getCostCenterid()+" ";
				else
					sqltmp += " and FnaBudgetCostcenter.costcenterid ="+CostCenterComInfo.getCostCenterid()+" ";
			}
			else if(tmptype1.equals("1"))
				sqltmp += " and costcenterid ="+CostCenterComInfo.getCostCenterid()+")";
			
			String tmptype2 = IndicatorComInfo.getIndicatortype(indicatoridlast);
			if(tmptype2.equals("0")){
				if(compare.equals("0"))
					sqltmp1 += " and FnaAccountCostcenter.costcenterid ="+CostCenterComInfo.getCostCenterid()+" ";
				else
					sqltmp1 += " and FnaBudgetCostcenter.costcenterid ="+CostCenterComInfo.getCostCenterid()+" ";
			}
			else if(tmptype2.equals("1"))
				sqltmp1 += " and costcenterid ="+CostCenterComInfo.getCostCenterid()+"";
		}		
		
		if(!indicatortype.equals("2")){
			RecordSet2.execute(sqltmp);
			if(RecordSet2.next()){
				if(indicatortype.equals("0"))
					tmpnum = ""+Util.getFloatValue(RecordSet2.getString(1),0)/(Util.getIntValue(factor,1));
				else if(indicatortype.equals("1"))
					tmpnum = ""+Util.getIntValue(RecordSet2.getString(1),0);
			}
			
		}
		else{
			float num1=0;
			float num2=0;
			
			RecordSet2.execute(sqltmp);
			if(RecordSet2.next())
				num1 = Util.getFloatValue(RecordSet2.getString(1),0)/(Util.getIntValue(factor,1));
			RecordSet2.execute(sqltmp1);
			if(RecordSet2.next())
				num2 = Util.getFloatValue(RecordSet2.getString(1),0);
			if(num2!=0){
				if(haspercent.equals("1")){
					num1 = num1/num2;
					num1 = num1*100;
					tmpnum = ""+ num1 +"%";
				}
				else
					tmpnum = ""+ num1/num2;
			}
			else
				tmpnum = ""+num1+":0";			
		}
		
		%>
		<TD class=ChartCell width=80%><%=tmpnum%></TD>		
		</TR>
		</TABLE>
		
		<%}%>
		<%}%>
		

		<DIV style="position:absolute;top:947;left:804;visibility:hidden;width:1;height:1;"></DIV>
	

<SCRIPT language=VBScript>
oc_DivisionList=array(<%=ccids%>)



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

sub onShowWorkTypeID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	WorkTypespan.innerHtml = id(1)
	Baco.WorkType.value=id(0)
	else 
	WorkTypespan.innerHtml = ""
	Baco.WorkType.value=""
	end if
	end if
end sub
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
	
		 <TR id=D2><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></TD></TR>
	
	</TABLE>
	</DIV>
	<SCRIPT LANGUAGE=VBScript>
	Sub oc_CurrentMenuOnClick
		set el = window.event.srcElement
		if (el.tagName = "A") then set el = el.parentElement
		select case el.parentElement.id
		
			case "D1"
				r="/hrm/company/HrmDepartmentDsp.jsp?id=<%=id%>"
			case "D2"
				r="/hrm/company/HrmCostcenterDsp.jsp?id=" & oc_DivisionList(oc_CurrentIndex)
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
<script language=javascript>  
function submitData() {
 frmMain.submit();
}
</script>

</BODY>
</HTML>
