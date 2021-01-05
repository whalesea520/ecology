<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Calendar" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>
<jsp:useBean id="InputCollect" class="weaver.datacenter.InputCollect" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);
/*******Add by Yeriwei! ************/
this.rs=rs;
this.req=request;
Map crmMap=this.getHrmSecurityInfoByUserId(user.getUID(),inprepid);
List fieldsList=(List)crmMap.get("fields");
/**************************/
String fromcheck = Util.null2String(request.getParameter("fromcheck"));
String crmid = Util.null2String(request.getParameter("crmid"));
String inprepname = Util.fromScreen(request.getParameter("inprepname"),user.getLanguage());
String inpreptablename = Util.null2String(request.getParameter("inpreptablename"));
String inprepbugtablename = Util.null2String(request.getParameter("inprepbugtablename"));
String inprepfrequence = Util.null2String(request.getParameter("inprepfrequence"));
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));
String currentyear = Util.null2String(request.getParameter("currentyear"));
String currentmonth = Util.null2String(request.getParameter("currentmonth"));
String currentday = Util.null2String(request.getParameter("currentday"));
String modulefilename = Util.null2String(request.getParameter("modulefilename"));
int helpdocid = Util.getIntValue(request.getParameter("helpdocid"),0);
int iscollect = Util.getIntValue(request.getParameter("iscollect"), 0);

String fieldStr = "" ;
ArrayList fieldStrs = new ArrayList();

String currentdate = Util.null2String(request.getParameter("currentdate"));
String year = Util.null2String(request.getParameter("year"));
String month = Util.null2String(request.getParameter("month"));
String day = Util.null2String(request.getParameter("day"));
String date = Util.null2String(request.getParameter("date"));
String thedate = currentdate;
String dspdate = currentdate ;
String thetable = "" ;
String inputid = "" ;
String inputmodid = "" ;
boolean canedit = true ;
boolean hasvalue = false ;
boolean hasmod = false ;
String seldate=date;
int indx=seldate.indexOf("-");
if(indx>0){
    seldate=seldate.substring(0,indx)+"年"+seldate.substring(indx+1,seldate.length());
}
indx=seldate.indexOf("-");
if(indx>0){
    seldate=seldate.substring(0,indx)+"月"+seldate.substring(indx+1,seldate.length());
}
if(seldate.length()>0) seldate+="日";

if(inprepbudget.equals("1")) thetable = inprepbugtablename ;
else if(inprepbudget.equals("2")) thetable = inpreptablename+"_forecast" ;
else thetable = inpreptablename ;

if(!inprepfrequence.equals("0")) {
	switch (Util.getIntValue(inprepfrequence)) {
		case 1:
			thedate = year + "-01-15" ;
			dspdate = year ;
			break ;
		case 2:
			thedate = year + "-"+month+"-15" ;
			dspdate = year + "-"+month ;
			break ;
		case 3:
			thedate = year + "-"+month+"-"+day ;
			dspdate = year + "-"+month ;
			if(day.equals("05")) dspdate += " 上旬" ;
			if(day.equals("15")) dspdate += " 中旬" ;
			if(day.equals("25")) dspdate += " 下旬" ;
			break ;
        case 4:
            thedate = date;
            Calendar today = Calendar.getInstance();
            today.set(Calendar.YEAR,Util.getIntValue(date.substring(0,4)));
            today.set(Calendar.MONTH,Util.getIntValue(date.substring(5,7))-1);
            today.set(Calendar.DAY_OF_MONTH,Util.getIntValue(date.substring(8)));
            dspdate = Util.add0(today.get(Calendar.YEAR), 4) + " 第" + Util.add0(today.get(Calendar.WEEK_OF_YEAR), 2) + "周";
            break;
		case 5:
			thedate = date ;
			dspdate = date ;
			break ;
        case 6:
            thedate = year + "-"+month+"-15" ;
            dspdate = year;
            if(month.equals("01")) dspdate += " 上半年" ;
			if(month.equals("07")) dspdate += " 下半年" ;
            break;
		case 7:
			thedate = year + "-"+month+"-15" ;
            dspdate = year;
            if(month.equals("01")) dspdate += " 一季度" ;
			if(month.equals("04")) dspdate += " 二季度" ;
            if(month.equals("07")) dspdate += " 三季度" ;
            if(month.equals("10")) dspdate += " 四季度" ;
            break;
    }
	
}

//汇总
if (iscollect > 0) {
    InputCollect.setInprepid(inprepid);
    InputCollect.setHrmid(user.getUID());
    InputCollect.setCrmid(Util.getIntValue(crmid));
    InputCollect.setTablename(thetable);
    InputCollect.setYear(year);
    InputCollect.setMonth(month);
    InputCollect.setDspdate(dspdate);
    InputCollect.setReportdate(thedate);
    InputCollect.setInputdate(currentdate);
    InputCollect.RunCollect();
}

ArrayList closeitemids = new ArrayList() ;
ArrayList closeitemvalue = new ArrayList() ;

rs.executeSql("select max(reportdate) from "+ thetable + 
				  " where crmid ="+crmid +" and modtype='0'") ;

if(rs.next()) {
    String maxreportdate = rs.getString(1) ;

    String sql =  "select * from "+ thetable + 
				  " where reportdate ='" +maxreportdate+"' and crmid ="+crmid +" and modtype='0'";

    rs2.executeSql(sql) ;
    rs2.next() ;

    rs.executeSql("select a.itemid , b.itemfieldname from T_InputReportItemClose a , T_InputReportItem b where a.itemid=b.itemid and  a.inprepid ="+inprepid+" and a.crmid="+crmid) ;
    while(rs.next()) {
        closeitemids.add(Util.null2String(rs.getString("itemid"))) ;
        String itemfieldname = Util.null2String(rs.getString("itemfieldname")) ;
        String lastvalue= Util.toScreen(rs2.getString(itemfieldname),user.getLanguage()) ;
        closeitemvalue.add(lastvalue) ;
    }
}
 
String sql =  "select * from "+ thetable + 
				  " where inprepdspdate ='" +dspdate+"' and crmid ="+crmid +" and modtype='0'";
	
rs2.executeSql(sql) ;
if(rs2.next()) {
    String inputstatus = Util.null2String(rs2.getString("inputstatus")) ;
    String reportuserid = Util.null2String(rs2.getString("reportuserid")) ;
    inputid = Util.null2String(rs2.getString("inputid")) ;
    if(!inputstatus.equals("9")) canedit = false ;

    // 因为新亚退回后可以修改，屏蔽
//    if(!reportuserid.equals(user.getTitle())) canedit = false ;
    
    hasvalue = true ;
}

sql =  "select * from "+ thetable + 
				  " where inprepdspdate ='" +dspdate+"' and crmid ="+crmid +" and modtype='1'";

rs4.executeSql(sql) ;
if(rs4.next()) {
    inputmodid = Util.null2String(rs4.getString("inputid")) ;
    //hasmod = true ;
}

// 对于插件， 先设置全部输入的字符串和列表
if( !modulefilename.equals("") ) {
    rs1.executeProc("T_IRItem_SelectByInprepid",""+inprepid);
	while(rs1.next()) {
		String itemfieldname = Util.null2String(rs1.getString("itemfieldname")) ;
        String itemfieldtype = Util.null2String(rs1.getString("itemfieldtype")) ;
        String inputablefact = Util.null2String(rs1.getString("inputablefact")) ; // 实际是否可输入
        String inputablebudg = Util.null2String(rs1.getString("inputablebudg")) ; // 预算是否可输入
        String inputablefore = Util.null2String(rs1.getString("inputablefore")) ; // 预测是否可输入
        String inputable = inputablefact ;
        if(inprepbudget.equals("1")) inputable = inputablebudg ;
        else if(inprepbudget.equals("2")) inputable = inputablefore ;
        
        if(!inputable.equals("1")) continue ;

        fieldStr += itemfieldname + "," ;
        fieldStrs.add(itemfieldname) ;
    }
}

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(15184,user.getLanguage()) + inprepname;
String needfav ="1";
String needhelp ="";


if(helpdocid!=0){
    titlename += "&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(275,user.getLanguage())+SystemEnv.getHtmlLabelName(58,user.getLanguage())+": <a href='/docs/docs/DocDsp.jsp?id="+helpdocid+"'>"+ Util.toScreen(DocComInfo.getDocname(""+helpdocid),user.getLanguage())+"</a>" ;
}
%>

<BODY <% if( !modulefilename.equals("") ) { %> onLoad="init()"<%}%>>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>



<% if(canedit) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:dosubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:doDraft(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

//RCMenu += "{"+SystemEnv.getHtmlLabelName(16630,user.getLanguage())+",javascript:doUpload(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>
<%}%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<!--FORM id=frmMain name=frmMain action="InputReportDataConfirm.jsp" method=post-->

<FORM id=frmMain name=frmMain action="InputReportDataTemp.jsp" method=post>
<input type="hidden" name="inprepid" value="<%=inprepid%>">
<input type="hidden" name="inprepname" value="<%=inprepname%>">
<input type="hidden" name="thetable" value="<%=thetable%>">
<input type="hidden" name="thedate" value="<%=thedate%>">
<input type="hidden" name="currentdate" value="<%=currentdate%>">
<input type="hidden" name="dspdate" value="<%=dspdate%>">
<input type="hidden" name="hasvalue" value="<%=hasvalue%>">
<input type="hidden" name="hasmod" value="<%=hasmod%>">
<input type="hidden" name="inputid" value="<%=inputid%>">
<input type="hidden" name="inputmodid" value="<%=inputmodid%>">
<input type="hidden" name="inprepbudget" value="<%=inprepbudget%>">
<input type="hidden" name="crmid" value="<%=crmid%>">
<input type="hidden" name="fromcheck" value="<%=fromcheck%>">
<input type="hidden" name="operation" value="">
<input type="hidden" name="inpreptablename" value="<%=inpreptablename%>">
<input type="hidden" name="inprepbugtablename" value="<%=inprepbugtablename%>">
<input type="hidden" name="inprepfrequence" value="<%=inprepfrequence%>">
<input type="hidden" name="currentyear" value="<%=currentyear%>">
<input type="hidden" name="currentmonth" value="<%=currentmonth%>">
<input type="hidden" name="currentday" value="<%=currentday%>">
<input type="hidden" name="modulefilename" value="<%=modulefilename%>">
<input type="hidden" name="helpdocid" value="<%=helpdocid%>">
<input type="hidden" name="year" value="<%=year%>">
<input type="hidden" name="month" value="<%=month%>">
<input type="hidden" name="day" value="<%=day%>">
<input type="hidden" name="date" value="<%=date%>">


<table width=100% height=97% border="0" cellspacing="0" cellpadding="0">
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

<%  if( modulefilename.equals("") ) { %>
  <table class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="40%">
  <COL width="40%">
    <tbody> 
    <tr class=header>
      <td colspan=2><nobr><b><%=inprepname%> :<font color="blue"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%> &nbsp; <%=dspdate%></font></b></td>
      <td align=right></td>
    </tr>
	<%
	String itemtypeid = "";
	String itemtypename = "";
	int i = 0 ;
	rs1.executeSql("select a.*,b.itemtypename from T_InputReportItem a,T_InputReportItemtype b where a.itemtypeid=b.itemtypeid and a.inprepid="+inprepid+" order by b.dsporder,a.dsporder");
	while(rs1.next()) {
		String itemid = Util.null2String(rs1.getString("itemid")) ;
		if(!fieldsList.contains(itemid))continue;//跳过不存在的字段.
		String tempitemtypeid = Util.null2String(rs1.getString("itemtypeid")) ;
		String tempitemtypename = Util.toScreen(rs1.getString("itemtypename"),user.getLanguage()) ;

        String itemdspname = Util.toScreen(rs1.getString("itemdspname"),user.getLanguage()) ;
		String itemfieldname = Util.null2String(rs1.getString("itemfieldname")) ;
		String itemfieldtype = Util.null2String(rs1.getString("itemfieldtype")) ;
		String itemfieldscale = Util.null2String(rs1.getString("itemfieldscale")) ;
		String itemexcelsheet = Util.toScreen(rs1.getString("itemexcelsheet"),user.getLanguage()) ;
		String itemexcelrow = Util.null2String(rs1.getString("itemexcelrow")) ;
		String itemexcelcolumn = Util.null2String(rs1.getString("itemexcelcolumn")) ;
        String itemfieldunit = Util.toScreen(rs1.getString("itemfieldunit"),user.getLanguage()) ;
        String inputablefact = Util.null2String(rs1.getString("inputablefact")) ; // 实际是否可输入
        String inputablebudg = Util.null2String(rs1.getString("inputablebudg")) ; // 预算是否可输入
        String inputablefore = Util.null2String(rs1.getString("inputablefore")) ; // 预测是否可输入
        String inputable = inputablefact ;
        if(inprepbudget.equals("1")) inputable = inputablebudg ;
        else if(inprepbudget.equals("2")) inputable = inputablefore ;
        
        if(!inputable.equals("1")) continue ;

//        if(itemfieldtype.equals("5")) continue ;
    if(!itemtypeid.equals(tempitemtypeid)){
        itemtypeid=tempitemtypeid;
        itemtypename=tempitemtypename;
    %>
    <tr class=header>
      <td colspan=3><%=itemtypename%></td>
    </tr>
    <tr class=line>
      <td  colspan=3></td>
    </tr>
    <%
        }
      if(i==0){
  		i=1;
  	%>
    <tr class=datalight> 
      <%}else{
  		i=0;
  	%>
    <tr class=datadark> 
    <% }%>
      <td><%=itemdspname%></td>
      <% 
        int closedindex = closeitemids.indexOf(itemid) ;
        if(closedindex >=0 ) { %>
        <td>
        <%=closeitemvalue.get(closedindex)%>
        <input type=hidden name=<%=itemfieldname%> value='<%=closeitemvalue.get(closedindex)%>'>
        </td><td>&nbsp;</td>
	  <% } else if(canedit) { %>
	    <% if(itemfieldtype.equals("1")) { %>
		<td><input type=text class=inputstyle size=30 maxlength=<%=itemfieldscale%> name=<%=itemfieldname%> <% if(hasvalue) {%> value="<%=Util.toScreenToEdit(rs2.getString(itemfieldname),user.getLanguage())%>"  <%}%>><%=itemfieldunit%></td><td>&nbsp;</td>
		<%} else if(itemfieldtype.equals("2")) { 
                String modfieldname = itemfieldname + "_mod" ;
        %>
		<td><input type=text class=inputstyle size=30 name=<%=itemfieldname%> <%
        if(hasvalue) {%> value="<%=Util.toScreenToEdit(rs2.getString(itemfieldname),user.getLanguage())%>" <%}%> onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'><%=itemfieldunit%></td>

        <!--td><input type=text class=inputstyle size=30 name=<%=modfieldname%> <% if(hasmod && Util.getIntValue(rs4.getString(itemfieldname),0) != 0 ) {%> value="<%=Util.toScreenToEdit(rs4.getString(itemfieldname),user.getLanguage())%>" <%}%> onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>(前次修正)</td-->

		<%} else if(itemfieldtype.equals("3") || itemfieldtype.equals("5")) { 
                String modfieldname = itemfieldname + "_mod" ;
        %>
		<td><input type=text class=inputstyle size=30 name=<%=itemfieldname%> <%
        if(hasvalue) {%> value="<%=Util.toScreenToEdit(rs2.getString(itemfieldname),user.getLanguage())%>" <%}%> onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'><%=itemfieldunit%></td>

        <!--td><input type=text class=inputstyle size=30 name=<%=modfieldname%> <% if(hasmod && Util.getDoubleValue(rs4.getString(itemfieldname),0) != 0 ) {%> value="<%=Util.toScreenToEdit(rs4.getString(itemfieldname),user.getLanguage())%>" <%}%> onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>(前次修正)</td-->

		<%} else if(itemfieldtype.equals("4")) { %>
		<td><select class="InputStyle" name="<%=itemfieldname%>"><%=itemfieldunit%>
		<%	rs3.executeProc("T_IRItemDetail_SelectByItemid",""+itemid);
			while(rs3.next()) {
			String itemdsp = Util.toScreenToEdit(rs3.getString("itemdsp"),user.getLanguage());
			String itemvalue = Util.toScreenToEdit(rs3.getString("itemvalue"),user.getLanguage());
			String selected = "" ;
			if(hasvalue && (Util.toScreen(rs2.getString(itemfieldname),user.getLanguage())).equals( itemvalue)) selected = "selected" ;
		%>
          <option value="<%=itemvalue%>" <%=selected%>><%=itemdsp%></option>
		<%}%>
        </select></td><td>&nbsp;</td>
		<%} else if(itemfieldtype.equals("6")) { %>
        <td><textarea class="InputStyle" name="<%=itemfieldname%>" rows="5" cols=60><% if(hasvalue) {%> <%=Util.toScreenToEdit(rs2.getString(itemfieldname),user.getLanguage())%> <%}%></textarea><%=itemfieldunit%></td><td>&nbsp;</td>
		<%}} else { %>
        <td>
        <%if(hasvalue) {%><%=Util.toScreen(rs2.getString(itemfieldname),user.getLanguage())%><%}%>
        </td>
        <td>
        <% if((itemfieldtype.equals("2") || itemfieldtype.equals("3") || itemfieldtype.equals("5")) && hasmod && Util.getDoubleValue(rs4.getString(itemfieldname),0) != 0 ) {%>
        <%=Util.toScreen(rs4.getString(itemfieldname),user.getLanguage())%>
        <%}%>
       </td>
       <%}%>
    </tr>
	<%}%>
    </tbody>
  </table>
</form>        
<% } else {%>
</form>
    <script language=javascript src="/workflow/mode/chinaexcelobj.js"></script>
    <SCRIPT FOR="ChinaExcel" EVENT="MouseLClick()" LANGUAGE="JavaScript" >
        rightMenu.style.visibility="hidden";
        return false;
    </SCRIPT>
    <SCRIPT FOR="ChinaExcel" EVENT="MouseRClick()" LANGUAGE="JavaScript" >
            rightMenu.style.left=ChinaExcel.offsetLeft+ChinaExcel.GetMousePosX();
            rightMenu.style.top=ChinaExcel.offsetTop+ChinaExcel.GetMousePosY();
            rightMenu.style.visibility="visible";
            return false;
    </SCRIPT>
<%}%>        

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

<% if( !modulefilename.equals("") ) { %>

var fieldStr="<%=fieldStr%>";//所有字段

function init()
{
    ChinaExcel.Login("泛微软件","891e490cd34e3e33975b1b7e523e8b32","上海泛微网络技术有限公司");
    ChinaExcel.ReadHttpTabFile("/reportModel/<%=modulefilename%>.tab");
    ChinaExcel.DesignMode=false;
    ChinaExcel.height="100%";
    ChinaExcel.SetProtectFormShowCursor(false);//取消默认光标
	ChinaExcel.SetOnlyShowTipMessage(false);
    ChinaExcel.SetShowPopupMenu(false);
    ChinaExcel.SetPasteType(1);
    ChinaExcel.SetCanAutoSizeHideCols(true);
    ChinaExcel.ShowGrid = false;
    setChinaExcelValue("_inprepname","<%=inprepname%>");//输入报表名称
    setChinaExcelValue("_dspdate","<%=dspdate%>");//输入报表显示时间
    setChinaExcelValue("_crmname","<%=CustomerInfoComInfo.getCustomerInfoname(crmid)%>");//填报单位名称
    setChinaExcelValue("_year","<%=year%>");//填报年
    setChinaExcelValue("_month","<%=month%>");//填报月
    setChinaExcelValue("_day","<%=day%>");//填报日
    setChinaExcelValue("_date","<%=seldate%>");//选择的填报日期
	
    <% if(hasvalue) {%> setValue() ; <% } %>
    <% if(hasmod) {%> setModValue() ; <% } %>
    ChinaExcel.ReCalculate();
    ChinaExcel.RefreshViewSize();
}

function getValue(setKey) //根据字段名获得字段值
{
	var returnValue;
	valueRow=ChinaExcel.GetCellUserStringValueRow(setKey);
	valueCol=ChinaExcel.GetCellUserStringValueCol(setKey);	
	returnValue=ChinaExcel.GetCellValue(valueRow,valueCol);
	return returnValue;
}

function setValue() //
{	
	<% 
    for( int k=0 ; k<fieldStrs.size() ; k++ ) {
        String fieldname = (String)fieldStrs.get(k) ;
        String fieldvalue = Util.toScreenToEdit(rs2.getString(fieldname),user.getLanguage()) ;
    %>
		field="<%=fieldname%>";
		
		valueRow=ChinaExcel.GetCellUserStringValueRow(field);
		valueCol=ChinaExcel.GetCellUserStringValueCol(field);			
		
		ChinaExcel.SetCellVal(valueRow,valueCol,"<%=fieldvalue%>");
	<%}%>
    
    ChinaExcel.Refresh() ;
}


function setModValue() //
{	
	<% 
    for( int k=0 ; k<fieldStrs.size() ; k++ ) {
        String fieldname = (String)fieldStrs.get(k) ;
        String fieldvalue = Util.toScreenToEdit(rs4.getString(fieldname),user.getLanguage()) ;
    %>
		field="<%=fieldname%>"+"_mod";
		
		valueRow=ChinaExcel.GetCellUserStringValueRow(field);
		valueCol=ChinaExcel.GetCellUserStringValueCol(field);			
		
		ChinaExcel.SetCellVal(valueRow,valueCol,"<%=fieldvalue%>");
	<%}%>
    
    ChinaExcel.Refresh() ;
}

function save()
{

	var oDiv;
	var sHtml;
	var tempFieldStr=fieldStr;
	var field;
	while(tempFieldStr!="")
	{
		field=tempFieldStr.substring(0,tempFieldStr.indexOf(","));
		tempFieldStr=tempFieldStr.substring(tempFieldStr.indexOf(",")+1);
		
        fieldValue=getValue(field);
        oDiv = document.createElement("div");
        sHtml = "<input type='hidden' name='"+field+"' value='"+fieldValue+"'>"; 
        oDiv.innerHTML = sHtml;
	    document.frmMain.appendChild(oDiv);

    }
    document.frmMain.submit();
}

<%}%>

function dosubmit(obj){
    alertstr = "你要提交的是<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%><%=dspdate%>的<%=inprepname%>"
    <% if(inprepbudget.equals("1")) {%> alertstr += "预算版本"; <%}%>
    <% if(inprepbudget.equals("2")) {%> alertstr += "预测版本"; <%}%>
    alertstr += "\n请确认你需要录入的是正确的！" ;
    
    if(confirm(alertstr)) {
        obj.disabled = true ;
        <% if( modulefilename.equals("") ) { %> document.frmMain.submit(); 
        <% } else {%> save() ; <% } %>
    }
}

function doDraft(){
    document.frmMain.action="InputReportDataOperation.jsp";
    document.frmMain.operation.value="draft";
    <% if( modulefilename.equals("") ) { %> document.frmMain.submit(); 
    <% } else {%> save() ; <% } %>
}
function doback(){
    window.location="InputReportDate.jsp?inprepid=<%=inprepid%>";
}

function doUpload() {
    document.frmMain.action="InputReportUpload.jsp" ;
    document.frmMain.submit() ;
}
function setChinaExcelValue(setKey,valueStr)
{
	TitleRow=ChinaExcel.GetCellUserStringValueRow(setKey);
	TitleCol=ChinaExcel.GetCellUserStringValueCol(setKey);
	ChinaExcel.SetCellVal(TitleRow,TitleCol,valueStr);
	ChinaExcel.Refresh();
}
</script>
 
<script language=vbs>
 
sub onShowCustomer()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
		window.location = "InputReportOperation.jsp?operation=addcrm&inprepid=<%=inprepid%>&crmid=" & id(0)
	end if
	end if
end sub

</script>
 

</BODY></HTML>
