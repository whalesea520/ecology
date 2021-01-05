<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
if(!HrmUserVarify.checkUserRight("HrmResourceComponentAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>

<jsp:useBean id = "RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id = "RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id = "RecordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id = "SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id = "JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id = "CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<jsp:useBean id = "HrmScheduleDiffComInfo" class = "weaver.hrm.schedule.HrmScheduleDiffComInfo" scope = "page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>

<%
String itemid = Util.null2String(request.getParameter("id")) ;
String subcompanyid = Util.null2String(request.getParameter("subcompanyid")) ;
String error = Util.null2String(request.getParameter("error")) ;
String subids=SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid);
String itemname = "" ;
String itemcode = "" ;
String itemtype = "" ;
String rolelevel=CheckUserRight.getRightLevel("HrmResourceComponentEdit:Edit" , user);
// String personwelfarerate = "" ;
// String companywelfarerate = "" ;
String taxrelateitem = "" ;
String amountecp = "" ;

String feetype = "" ;
String isshow = "" ;
String showorder = "" ;
String ishistory = "" ;
String applyscope="";
String calMode = "" ; //计算方式
String directModify = "" ; //是否可以直接修改工资单
String companyPercent = "" ; //公司百分比
String personalPercent = "" ; //个人百分比
RecordSet.executeSql(" select * from HrmSalaryItem where id = " + itemid  ) ;
if( RecordSet.next() ) {
    itemname = Util.toScreen(RecordSet.getString("itemname"),user.getLanguage());
    itemcode = Util.null2String(RecordSet.getString("itemcode")) ;
    itemtype = Util.null2String(RecordSet.getString("itemtype")) ;
    subcompanyid = Util.null2String(RecordSet.getString("subcompanyid")) ; 
//    personwelfarerate = ""+Util.getIntValue(RecordSet.getString("personwelfarerate"),0) ;
//    companywelfarerate = ""+Util.getIntValue(RecordSet.getString("companywelfarerate"),0) ;
    taxrelateitem = ""+Util.getIntValue(RecordSet.getString("taxrelateitem"),0) ;
    amountecp = Util.null2String(RecordSet.getString("amountecp")) ;
    feetype = ""+Util.getIntValue(RecordSet.getString("feetype"),0) ;
    isshow = ""+Util.getIntValue(RecordSet.getString("isshow"),0) ;
    showorder = ""+Util.getIntValue(RecordSet.getString("showorder"),0) ;
    ishistory = ""+Util.getIntValue(RecordSet.getString("ishistory"),0) ;
    applyscope=""+Util.getIntValue(RecordSet.getString("applyscope"),0) ;
    calMode = "" + Util.getIntValue(RecordSet.getString("calMode") , 0) ;
    directModify = "" + Util.getIntValue(RecordSet.getString("directModify") , 0) ;
    companyPercent = "" + Util.null2String(RecordSet.getString("companyPercent")) ;
    personalPercent = "" + Util.null2String(RecordSet.getString("personalPercent")) ;
}

// if( personwelfarerate.equals("0") ) personwelfarerate = "" ;
// if( companywelfarerate.equals("0") ) companywelfarerate = "" ;
if( taxrelateitem.equals("0") ) taxrelateitem = "" ;
if( feetype.equals("0") ) feetype = "" ;
if( showorder.equals("0") ) showorder = "" ;

if( itemtype.equals("4") ) {
    amountecp = Util.StringReplace(amountecp , "$" , "") ;
}

HashMap schedulediffmap=new HashMap();
HashMap targetmap=new HashMap();
RecordSet3.executeSql("select * from hrmschedulediff where salaryable!=1");
while(RecordSet3.next()){
      schedulediffmap.put(RecordSet3.getString("id"),RecordSet3.getString("diffname"));
}
RecordSet3.executeSql(" select * from hrm_compensationtargetset");
while(RecordSet3.next()){
      targetmap.put(RecordSet3.getString("id"),RecordSet3.getString("targetname"));
}

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=-1;
if(detachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceComponentAdd:Add",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceComponentAdd:Add", user))
        operatelevel=2;
}
if(operatelevel<0){
    		response.sendRedirect("/notice/noright.jsp") ;
    		return ;
}
boolean CanAdd=false;
if(operatelevel>0)
    CanAdd=true;

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(16481,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
/*
if(CanAdd) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(CanAdd) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(itemtype.equals("1") || itemtype.equals("2") ) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(15839,user.getLanguage())+",javascript:doProcess(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/finance/salary/HrmSalaryItemList.jsp?subcompanyid="+subcompanyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;*/
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(error.equals("1")){%><b><font color="red"><%=SystemEnv.getHtmlLabelName(20151,user.getLanguage())%></font></b> <%}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form  name=frmMain method=post action="HrmSalaryItemOperation.jsp" method=post>
<input type="hidden" name="method">
<input type="hidden" name="subcompanyid" value="<%=subcompanyid%>">
<input type="hidden" name="id" value="<%=itemid%>">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361 , user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
    <wea:item><%=itemname%></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(590,user.getLanguage())%></wea:item>
    <wea:item><%=itemcode%>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
    <wea:item> 
        <%if( itemtype.equals("1")) {%><%=SystemEnv.getHtmlLabelName(1804,user.getLanguage())%>
        <%} else if( itemtype.equals("2")) {%><%=SystemEnv.getHtmlLabelName(15825,user.getLanguage())%>
        <%} else if( itemtype.equals("3")) {%><%=SystemEnv.getHtmlLabelName(15826,user.getLanguage())%>
        <%} else if( itemtype.equals("4")) {%><%=SystemEnv.getHtmlLabelName(449,user.getLanguage())%>
        <%} else if( itemtype.equals("5")) {%><%=SystemEnv.getHtmlLabelName(16668,user.getLanguage())%>
        <%} else if( itemtype.equals("6")) {%><%=SystemEnv.getHtmlLabelName(16669,user.getLanguage())%>
        <%} else if( itemtype.equals("7")) {%><%=SystemEnv.getHtmlLabelName(16740,user.getLanguage())%>
        <%} else if( itemtype.equals("9")) {%><%=SystemEnv.getHtmlLabelName(15825 , user.getLanguage())+SystemEnv.getHtmlLabelName(449 , user.getLanguage())%><%}%>
    </wea:item>
    <%if( itemtype.equals("9")) {%>
       <wea:item><%=SystemEnv.getHtmlLabelName(449 , user.getLanguage())+SystemEnv.getHtmlLabelName(599 , user.getLanguage())%></wea:item>
       <wea:item>
           <%if( calMode.equals("1")) {%><%=SystemEnv.getHtmlLabelName(19529 , user.getLanguage())%>
           <%} else if( calMode.equals("2")) {%><%=SystemEnv.getHtmlLabelName(19530,user.getLanguage())%>
           <%}%>
       </wea:item>
    <%}%>
            <%if( itemtype.equals("2")) {%>
            <!-- TR>
                <TD>福利费率</TD>
                <TD class=Field>
                个人 <%// =personwelfarerate%>%&nbsp;&nbsp;
                公司 <%// =companywelfarerate%>%
                </TD>
             </TR -->
             <%}%>
             <%if( itemtype.equals("3")) {%>
                <wea:item><%=SystemEnv.getHtmlLabelName(15827,user.getLanguage())%></wea:item>
                <wea:item>
                    <%=Util.toScreen(SalaryComInfo.getSalaryname(taxrelateitem),user.getLanguage())%>
                </wea:item>

             <%}%>
             <%--<%if( itemtype.equals("4")) {%>
             <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15828,user.getLanguage())%></TD>
                <TD class=Field><%=amountecp%></TD>
             </TR>
             <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
             <%}%>--%>

             <wea:item><%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%></wea:item>
             <wea:item>
                 <%if( isshow.equals("1")) {%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
                 <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
             </wea:item>
            <%if( isshow.equals("1")) {%>
             <wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
             <wea:item><%=showorder%></wea:item>
            <%}%>
	            <wea:item><%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%></wea:item>
	            <wea:item>
              <%if(applyscope.equals("0")){%><%=SystemEnv.getHtmlLabelName(140 , user.getLanguage())%><%}%>
			        <%if(applyscope.equals("1")){%><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%><%}%>
			        <%if(applyscope.equals("2")){%><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18921 , user.getLanguage())%><%}%>
			        </wea:item>
            <%if( itemtype.equals("9")||itemtype.equals("4")) {%>
                <wea:item><%=SystemEnv.getHtmlLabelName(19531,user.getLanguage())%></wea:item>
                <wea:item>
                <%if(directModify.equals("0")){%><%=SystemEnv.getHtmlLabelName(161 , user.getLanguage())%><%}%>
				        <%if(directModify.equals("1")){%><%=SystemEnv.getHtmlLabelName(163 , user.getLanguage())%><%}%>
				        </wea:item>
          	<%}%>
</wea:group>
</wea:layout>
<div id=tb_jssm <% if(!itemtype.equals("4")&&!itemtype.equals("9")) {%>style="display:none"<%}%>>
<table  width=100% border=1 bordercolor='black'>
  <tbody>
  <tr>
  <td>
  <%=SystemEnv.getHtmlLabelName(83483 , user.getLanguage())%> <BR>
  <%=SystemEnv.getHtmlLabelName(83487 , user.getLanguage())%> 
  </td></tr>
  </tbody>
</table>
</div>

<%if( itemtype.equals("1") || itemtype.equals("2") ) {%>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(603 , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item attributes="{'isTableList':'true'}">
<TABLE class=ListStyle cellspacing=1  id="oTable_je" cols=4>
  <COLGROUP> 
  <COL width="30%"> 
  <COL width="30%"> 
  <COL width="12%">
  <COL width="12%">
  <COL width="15%"> 
  <TBODY>
  <TR class=HeaderForXtalbe> 
    <TH><%=SystemEnv.getHtmlLabelName(1915 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15831,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15832,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TH>
  </TR>
<%
    String jobactivityid = "" ;
    String jobid = "" ;
    String joblevelfrom = "" ;
    String joblevelto = "" ;
    String amount = "" ;

    RecordSet.executeSql(" select * from HrmSalaryRank where itemid = " + itemid + " order by id " ) ;
    while( RecordSet.next() ) {
        jobactivityid = ""+Util.getIntValue(RecordSet.getString("jobactivityid"),0) ;
        jobid = ""+Util.getIntValue(RecordSet.getString("jobid"),0) ;
        joblevelfrom = ""+Util.getIntValue(RecordSet.getString("joblevelfrom"),0) ;
        joblevelto = ""+Util.getIntValue(RecordSet.getString("joblevelto"),0) ;
        amount = ""+Util.getDoubleValue(RecordSet.getString("amount"),0) ;
        /*
        if( jobactivityid.equals("0") ) jobactivityid = "" ;
        if( jobid.equals("0") ) jobid = "" ;
        if( joblevelfrom.equals("0") ) joblevelfrom = "" ;
        if( joblevelto.equals("0") ) joblevelto = "" ;
        if( amount.equals("0") ) amount = "" ;
        */
%>
  <TR bgcolor="#efefef"> 
    <TD><%=Util.toScreen(JobActivitiesComInfo.getJobActivitiesname(jobactivityid),user.getLanguage())%></TD>
    <TD><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobid),user.getLanguage())%></TD>
    <TD><%=joblevelfrom%></TD>
    <TD><%=joblevelto%></TD>
    <TD><%=amount%></TD>
  </TR>
<%  } %>
  </tbody>
</table>
		</wea:item>
	</wea:group>
</wea:layout>
<%}%>
<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdeptCompensation(deptid,xuhao){
    var ajax=ajaxinit();
    ajax.open("POST", "HrmSalaryDspAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid="+deptid+"&xuhao="+xuhao+"&userid=<%=user.getUID()%>&itemid=<%=itemid%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.all("div"+deptid+"ajax").innerHTML=ajax.responseText;
            }catch(e){
                return false;
            }
        }
    }
}
</script>
<%if( itemtype.equals("1") || itemtype.equals("2") || itemtype.equals("8") ) {%>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33603 , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item attributes="{'isTableList':'true'}">
<table  class = ListStyle>
  <COLGROUP> 
  <COL width = "15%"> 
  <COL width = "15%">
  <COL width = "70%"> 
  <tbody>
  
  <TR class = HeaderForXtalbe> 
    <TH><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(714 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TH>
  </TR>
	<tr>
       <td colspan="3">
  <%
    //  获得所有出勤种类关联的金额
    ArrayList resourceids = new ArrayList() ;
    ArrayList resourcepays = new ArrayList() ;

    RecordSet.executeProc("HrmSalaryResourcePay_SByItemid" , itemid) ; 
    while( RecordSet.next() ) {
        String resourcepay = Util.null2String(RecordSet.getString("resourcepay")) ;
        if( Util.getDoubleValue(resourcepay,0) == 0 ) continue ;
        resourceids.add(Util.null2String(RecordSet.getString("resourceid"))) ;
        resourcepays.add(Util.null2String(RecordSet.getString("resourcepay"))) ;
    }
    if(applyscope.equals("")){
     if(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2")){
     RecordSet.executeSql(" select a.departmentid, count(a.id) from Hrmresource a left join HrmSalaryResourcePay b on a.id=b.resourceid where status in (0,1,2,3) group by a.departmentid") ;
     }else{
     RecordSet.executeSql(" select a.departmentid, count(a.id) from Hrmresource a left join HrmSalaryResourcePay b on a.id=b.resourceid where status in (0,1,2,3) and subcompanyid1="+subcompanyid+" group by a.departmentid") ;
     }
     }else{
        if(applyscope.equals("0")&&(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2"))){
     RecordSet.executeSql(" select a.departmentid, count(a.id) from Hrmresource a  left join HrmSalaryResourcePay b on a.id=b.resourceid where status in (0,1,2,3) group by a.departmentid") ;
     }else if(applyscope.equals("1")){
     RecordSet.executeSql(" select a.departmentid, count(a.id) from Hrmresource a  left join HrmSalaryResourcePay b on a.id=b.resourceid where status in (0,1,2,3) and subcompanyid1="+subcompanyid+" group by a.departmentid") ;
     }else if(applyscope.equals("2")) {
            subids=subcompanyid+","+subids;

    subids=subids.substring(0,subids.length()-1);
    RecordSet.executeSql(" select a.departmentid, count(a.id) from Hrmresource a left join HrmSalaryResourcePay b on a.id=b.resourceid where status in (0,1,2,3) and subcompanyid1 in("+subids+") group by a.departmentid") ;

        }
     }
    int i = 0;
	String scriptStr = "";
	while(RecordSet.next()){ 
		int departmentid_tmp = Util.getIntValue(RecordSet.getString(1), 0);
		int count_tmp = Util.getIntValue(RecordSet.getString(2), 0);
		if(count_tmp>0){
%>
			<div id="div<%=departmentid_tmp%>ajax" style="width:100%"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
<%
			if(itemtype.equals("1")){
%>
		<script>showdeptCompensation("<%=departmentid_tmp%>","<%=i%>");</script>
<%
			}else{
				scriptStr += "showdeptCompensation(\""+departmentid_tmp+"\",\""+i+"\");\n";
			}
%>
	</div>
<%
			i+=count_tmp;
		}
	}
%>
		</td>
	</tr>
  </tbody>
</table>
</wea:item>
</wea:group>
</wea:layout>
<% } %>

<% if(itemtype.equals("2")) {%>
<br>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15833 , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
	<wea:item attributes="{'isTableList':'true'}">
<TABLE class=ListStyle id="oTable_fl" cols=4>
  <COLGROUP> 
  <COL width="33%"> 
  <COL width="33%">
  <COL width="33%">
  <TBODY>
  <TR class=HeaderForXtalbe> 
    <TH><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>(%)</TH>
    <TH><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%>(%)</TH>
  </TR>
  <%
    String ratecityid = "" ;
    String personwelfarerate = "" ;
    String companywelfarerate = "" ;

    RecordSet.executeSql(" select * from HrmSalaryWelfarerate where itemid = " + itemid + " order by id " ) ;
    while( RecordSet.next() ) {
        ratecityid = ""+Util.getIntValue(RecordSet.getString("cityid"),0) ;
        personwelfarerate = ""+Util.getDoubleValue(RecordSet.getString("personwelfarerate"),0) ;
        companywelfarerate = ""+Util.getDoubleValue(RecordSet.getString("companywelfarerate"),0) ;

        if( ratecityid.equals("0") ) ratecityid = "" ;
        if( personwelfarerate.equals("0") ) personwelfarerate = "" ;
        if( companywelfarerate.equals("0") ) companywelfarerate = "" ;
%>
  <TR bgcolor="#efefef"> 
    <TD><%=Util.toScreen(CityComInfo.getCityname(ratecityid),user.getLanguage())%></TD>
    <TD><%=personwelfarerate%>%</TD>
    <TD><%=companywelfarerate%>%</TD>
  </TR>
<%  } %>
  </tbody>
</table>
    </wea:item>
</wea:group>
</wea:layout>
<%}%>

<%if( itemtype.equals("3") ) {%>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15834 , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
	<wea:item attributes="{'isTableList':'true'}">
<TABLE class=ListStyle id="oTable_ss" cols=1>
  <COLGROUP>
  <COL width="100%"> 
  <TBODY>
<%
    String benchid = "" ;
    String cityid = "" ;
    String taxbenchmark = "" ;
    int benchindex = -1 ;

    RecordSet.executeSql(" select * from HrmSalaryTaxbench where itemid = " + itemid + " order by id " ) ;
    while( RecordSet.next() ) {
        benchid = ""+Util.getIntValue(RecordSet.getString("id"),0) ;
        cityid = ""+Util.getIntValue(RecordSet.getString("cityid"),0) ;
        taxbenchmark = ""+Util.getIntValue(RecordSet.getString("taxbenchmark"),0) ;
        if( cityid.equals("0") ) cityid = "" ;
        if( taxbenchmark.equals("0") ) taxbenchmark = "" ;
        benchindex ++ ;
        
        String ranknum = "" ;
        String ranklow = "" ;
        String rankhigh = "" ;
        String taxrate = "" ;
        String subtractnum="";
        int rateindex = 0 ;

        RecordSet2.executeSql(" select * from HrmSalaryTaxscope where benchid = " + benchid ) ;
        String scopetype="";
        String scopename="";
        while(RecordSet2.next()){
             scopetype=Util.null2String(RecordSet2.getString("scopetype"));
             if(scopetype.equals("0"))
             scopename=SystemEnv.getHtmlLabelName(332,user.getLanguage());
             else if(scopetype.equals("1")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
             scopename=SystemEnv.getHtmlLabelName(493,user.getLanguage())+":"+CityComInfo.getCityname(objid) ;
             }else if(scopetype.equals("2")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals(""))
                   scopename+=SystemEnv.getHtmlLabelName(141,user.getLanguage())+":"+SubCompanyComInfo.getSubCompanyname(objid);
                   else
                   scopename+=","+SubCompanyComInfo.getSubCompanyname(objid) ;
             }else if(scopetype.equals("3")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals(""))
                   scopename+=SystemEnv.getHtmlLabelName(18939,user.getLanguage())+":"+DepartmentComInfo.getDepartmentname(objid);
                   else
                   scopename+=","+DepartmentComInfo.getDepartmentname(objid) ;
             }else if(scopetype.equals("4")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals(""))
                   scopename+=SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+ResourceComInfo.getLastname(objid);
                   else
                   scopename+=","+ResourceComInfo.getLastname(objid) ;
             }
        }
        RecordSet2.executeSql(" select * from HrmSalaryTaxrate where benchid = " + benchid + " order by ranknum " ) ;
        if( RecordSet2.next() ) {
            ranknum = ""+Util.getIntValue(RecordSet2.getString("ranknum"),0) ;
            ranklow = ""+Util.getIntValue(RecordSet2.getString("ranklow"),0) ;
            rankhigh = ""+Util.getIntValue(RecordSet2.getString("rankhigh"),0) ;
            taxrate = ""+Util.getIntValue(RecordSet2.getString("taxrate"),0) ;
            subtractnum="" + Util.getIntValue(RecordSet2.getString("subtractnum") , 0) ;
            if( ranknum.equals("0") ) ranknum = "" ;
//            if( ranklow.equals("0") ) ranklow = "" ;
            if( rankhigh.equals("0") ) rankhigh = "" ;
            if( taxrate.equals("0") ) taxrate = "" ;
        }
%>
  <TR><TD>
  <TABLE class=ListStyle id='oTable_ssdetail<%=benchindex%>'name='oTable_ssdetail<%=benchindex%>' cols=7>
    <COLGROUP>
    <COL width='15%'>
    <COL width='18%'> 
    <COL width='7%'>
    <COL width='18%'>
    <COL width='18%'>
    <COL width='10%'>
    <COL width='15%'>
    <TBODY>
    <TR class=HeaderForXtalbe> 
    <TH><%=SystemEnv.getHtmlLabelName(19467,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15835,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15836,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15837,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15838,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15834,user.getLanguage())%>(%)</TH>
    <TH><%=SystemEnv.getHtmlLabelName(19756 , user.getLanguage())%></TH>
    </TR>
    <TR class=DataDark> 
    <TD><%=scopename%></TD>
    <TD><%=taxbenchmark%></TD>
    <TD><%=ranknum%></TD>
    <TD><%=ranklow%></TD>
    <TD><%=rankhigh%></TD>
    <TD><%=taxrate%></TD>
    <TD><%=subtractnum%></TD>
    </TR>
<%
        while( RecordSet2.next() ) {
            ranknum = ""+Util.getIntValue(RecordSet2.getString("ranknum"),0) ;
            ranklow = ""+Util.getIntValue(RecordSet2.getString("ranklow"),0) ;
            rankhigh = ""+Util.getIntValue(RecordSet2.getString("rankhigh"),0) ;
            taxrate = ""+Util.getIntValue(RecordSet2.getString("taxrate"),0) ;
            subtractnum="" + Util.getIntValue(RecordSet2.getString("subtractnum") , 0) ;
            rateindex++ ;

            if( ranknum.equals("0") ) ranknum = "" ;
 //           if( ranklow.equals("0") ) ranklow = "" ;
            if( rankhigh.equals("0") ) rankhigh = "" ;
            if( taxrate.equals("0") ) taxrate = "" ;
%>
    <TR class=DataDark> 
    <TD>&nbsp;</TD>
    <TD>&nbsp;</TD>
    <TD><%=ranknum%></TD>
    <TD><%=ranklow%></TD>
    <TD><%=rankhigh%></TD>
    <TD><%=taxrate%></TD>
    <TD><%=subtractnum%></TD>
    </TR>
<%      }
%>
    </TABLE>
    </TD></TR>
<%
    }
%>
  </TBODY>
</TABLE>
    </wea:item>
</wea:group>
</wea:layout>
<%}%>

<%if( itemtype.equals("4") ) {%>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("18125,68" , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item attributes="{'isTableList':'true'}">
<TABLE class=ListStyle id="oTable_ss" cols=1>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
<%
    String benchid = "" ;
    String scopetype = "" ;
    String taxbenchmark = "" ;
    int benchindex = -1 ;

    RecordSet.executeSql(" select * from HrmSalaryCalBench where itemid = " + itemid + " order by id " ) ;
    while( RecordSet.next() ) {
        benchid = ""+Util.getIntValue(RecordSet.getString("id"),0) ;
        scopetype = ""+Util.getIntValue(RecordSet.getString("scopetype"),0) ;


        benchindex ++ ;

        String timescope = "" ;
        String condition = "" ;
        String formular = "" ;
        int rateindex = 0 ;

        RecordSet2.executeSql(" select * from HrmSalaryCalScope where benchid = " + benchid ) ;
        String scopename="";
        if(scopetype.equals("0"))
             scopename=SystemEnv.getHtmlLabelName(332,user.getLanguage());
        while(RecordSet2.next()){
             if(scopetype.equals("0"))
             scopename=SystemEnv.getHtmlLabelName(332,user.getLanguage());
             else if(scopetype.equals("2")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals(""))
                   scopename+=SystemEnv.getHtmlLabelName(141,user.getLanguage())+":"+SubCompanyComInfo.getSubCompanyname(objid);
                   else
                   scopename+=","+SubCompanyComInfo.getSubCompanyname(objid) ;
             }else if(scopetype.equals("3")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals(""))
                   scopename+=SystemEnv.getHtmlLabelName(18939,user.getLanguage())+":"+DepartmentComInfo.getDepartmentname(objid);
                   else
                   scopename+=","+DepartmentComInfo.getDepartmentname(objid) ;
             }else if(scopetype.equals("4")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals(""))
                   scopename+=SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+ResourceComInfo.getLastname(objid);
                   else
                   scopename+=","+ResourceComInfo.getLastname(objid) ;
             }
        }
        RecordSet2.executeSql(" select * from HrmSalaryCalRate where benchid = " + benchid ) ;
        if( RecordSet2.next() ) {
            timescope = ""+Util.getIntValue(RecordSet2.getString("timescope"),0) ;
            condition = ""+Util.null2String(RecordSet2.getString("condition")) ;
            formular = ""+Util.null2String(RecordSet2.getString("formular")) ;
            /*String schedulediff=Util.match(condition,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            condition=Util.replace(condition,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(condition,"@[^@]*@");
            }
            String target=Util.match(condition,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            condition=Util.replace(condition,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(condition,"\\$[^\\$]*\\$");
            }
            //解析公式
            schedulediff=Util.match(formular,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            formular=Util.replace(formular,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(formular,"@[^@]*@");
            }

            target=Util.match(formular,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            formular=Util.replace(formular,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(formular,"\\$[^\\$]*\\$");
            }
            //解析工资项目
            //System.out.println("formular"+formular);
            String item = Util.match(formular, "#[^#]*#");
            while (!item.equals("")) {
                String theitemid = item.substring(1, item.lastIndexOf("#"));
                String theitemcode="";
                if(theitemid.indexOf("_")>0){
                theitemcode=SalaryComInfo.getSalaryCode(theitemid.substring(0,theitemid.indexOf("_")))+theitemid.substring(theitemid.indexOf("_"));
                }else
                theitemcode=SalaryComInfo.getSalaryCode(theitemid);
                //System.out.println("theitemcode"+theitemcode);
                formular = Util.replace(formular, "#[^#]*#", theitemcode, 1);
                item = Util.match(formular, "#[^#]*#");
            }
            formular=Util.replace(formular,"\\^",SystemEnv.getHtmlLabelName(19378,user.getLanguage()),0);*/
        }
%>
  <TR><TD>
  <TABLE class=ListStyle id='oTable_caldetail<%=benchindex%>'name='oTable_caldetail<%=benchindex%>' cols=4>
    <COLGROUP>
    <COL width='20%'>
    <COL width='20%'>
    <COL width='30%'>
    <COL width='30%'>

    <TBODY>
    <TR class=HeaderForXtalbe>
    <TH><%=SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(19482 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15364 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(18125 , user.getLanguage())%></TH>
    </TR>

    <TR class=DataDark>
    <TD><%=scopename%></TD>
    <TD>
        <%if(timescope.equals("1")){%><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%><%}%>
        <%if(timescope.equals("2")){%><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%><%}%>
        <%if(timescope.equals("3")){%><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%><%}%>
        <%if(timescope.equals("4")){%><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%><%}%>
    </TD>
    <TD><%=Util.null2String(RecordSet2.getString("conditiondsp"))%></TD>
    <TD><%=Util.null2String(RecordSet2.getString("formulardsp"))%></TD>
    </TR>
<%
        while( RecordSet2.next() ) {
            timescope = ""+Util.getIntValue(RecordSet2.getString("timescope"),0) ;
            condition = ""+Util.null2String(RecordSet2.getString("condition")) ;
            formular = ""+Util.null2String(RecordSet2.getString("formular")) ;
            rateindex++ ;
            /*String schedulediff=Util.match(condition,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            condition=Util.replace(condition,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(condition,"@[^@]*@");
            }
            String target=Util.match(condition,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            condition=Util.replace(condition,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(condition,"\\$[^\\$]*\\$");
            }
            //解析公式
            schedulediff=Util.match(formular,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            formular=Util.replace(formular,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(formular,"@[^@]*@");
            }

            target=Util.match(formular,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            formular=Util.replace(formular,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(formular,"\\$[^\\$]*\\$");
            }
            //解析工资项目
            //System.out.println("formular"+formular);
            String item = Util.match(formular, "#[^#]*#");
            while (!item.equals("")) {
                String theitemid = item.substring(1, item.lastIndexOf("#"));
                String theitemcode="";
                if(theitemid.indexOf("_")>0){
                theitemcode=SalaryComInfo.getSalaryCode(theitemid.substring(0,theitemid.indexOf("_")))+theitemid.substring(theitemid.indexOf("_"));
                }else
                theitemcode=SalaryComInfo.getSalaryCode(theitemid);
                //System.out.println("theitemcode"+theitemcode);
                formular = Util.replace(formular, "#[^#]*#", theitemcode, 1);
                item = Util.match(formular, "#[^#]*#");
            }
            formular=Util.replace(formular,"\\^",SystemEnv.getHtmlLabelName(19378,user.getLanguage()),0);*/
%>
    <TR class=DataDark>
    <TD>&nbsp;</TD>
    <TD>
        <%if(timescope.equals("1")){%><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%><%}%>
        <%if(timescope.equals("2")){%><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%><%}%>
        <%if(timescope.equals("3")){%><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%><%}%>
        <%if(timescope.equals("4")){%><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%><%}%>
    </TD>
    <TD><%=Util.null2String(RecordSet2.getString("conditiondsp"))%></TD>
    <TD><%=Util.null2String(RecordSet2.getString("formulardsp"))%></TD>
    </TR>
<%      }
%>
    </TABLE>
    </TD></TR>
<%
    }
%>
  </TBODY>
</TABLE>
</wea:item>
</wea:group>
</wea:layout>
<%}%>

<%if( itemtype.equals("9") ) {%>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("18125" , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item attributes="{'isTableList':'true'}">
<TABLE class=ListStyle id="oTable_wel" cols=1>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
<%
    String benchid = "" ;
    String scopetype = "" ;
    String taxbenchmark = "" ;
    int benchindex = -1 ;

    RecordSet.executeSql(" select * from HrmSalaryCalBench where itemid = " + itemid + " order by id " ) ;
    while( RecordSet.next() ) {
        benchid = ""+Util.getIntValue(RecordSet.getString("id"),0) ;
        scopetype = ""+Util.getIntValue(RecordSet.getString("scopetype"),0) ;


        benchindex ++ ;

        String timescope = "" ;
        String condition = "" ;
        String formular = "" ;
        int rateindex = 0 ;

        RecordSet2.executeSql(" select * from HrmSalaryCalScope where benchid = " + benchid ) ;
        String scopename="";
        if(scopetype.equals("0"))
             scopename=SystemEnv.getHtmlLabelName(332,user.getLanguage());
        while(RecordSet2.next()){
             if(scopetype.equals("0"))
             scopename=SystemEnv.getHtmlLabelName(332,user.getLanguage());
             else if(scopetype.equals("2")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals(""))
                   scopename+=SystemEnv.getHtmlLabelName(141,user.getLanguage())+":"+SubCompanyComInfo.getSubCompanyname(objid);
                   else
                   scopename+=","+SubCompanyComInfo.getSubCompanyname(objid) ;
             }else if(scopetype.equals("3")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals(""))
                   scopename+=SystemEnv.getHtmlLabelName(18939,user.getLanguage())+":"+DepartmentComInfo.getDepartmentname(objid);
                   else
                   scopename+=","+DepartmentComInfo.getDepartmentname(objid) ;
             }else if(scopetype.equals("4")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals(""))
                   scopename+=SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+ResourceComInfo.getLastname(objid);
                   else
                   scopename+=","+ResourceComInfo.getLastname(objid) ;
             }
        }
        RecordSet2.executeSql(" select * from HrmSalaryCalRate where benchid = " + benchid ) ;
        if( RecordSet2.next() ) {
            timescope = ""+Util.getIntValue(RecordSet2.getString("timescope"),0) ;
            condition = ""+Util.null2String(RecordSet2.getString("condition")) ;
            formular = ""+Util.null2String(RecordSet2.getString("formular")) ;
            /*String schedulediff=Util.match(condition,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            condition=Util.replace(condition,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(condition,"@[^@]*@");
            }
            String target=Util.match(condition,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            condition=Util.replace(condition,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(condition,"\\$[^\\$]*\\$");
            }
            //解析公式
            schedulediff=Util.match(formular,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            formular=Util.replace(formular,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(formular,"@[^@]*@");
            }

            target=Util.match(formular,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            formular=Util.replace(formular,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(formular,"\\$[^\\$]*\\$");
            }
            //解析工资项目
            //System.out.println("formular"+formular);
            String item = Util.match(formular, "#[^#]*#");
            while (!item.equals("")) {
                String theitemid = item.substring(1, item.lastIndexOf("#"));
                String theitemcode="";
                if(theitemid.indexOf("_")>0){
                theitemcode=SalaryComInfo.getSalaryCode(theitemid.substring(0,theitemid.indexOf("_")))+theitemid.substring(theitemid.indexOf("_"));
                }else
                theitemcode=SalaryComInfo.getSalaryCode(theitemid);
                //System.out.println("theitemcode"+theitemcode);
                formular = Util.replace(formular, "#[^#]*#", theitemcode, 1);
                item = Util.match(formular, "#[^#]*#");
            }
            formular=Util.replace(formular,"\\^",SystemEnv.getHtmlLabelName(19378,user.getLanguage()),0);*/
        }
%>
  <TR><TD>
  <TABLE class=ListStyle id='oTable_weldetail<%=benchindex%>'name='oTable_weldetail<%=benchindex%>' cols=4>
    <COLGROUP>
    <COL width='20%'>
    <COL width='20%'>
    <COL width='30%'>
    <COL width='30%'>

    <TBODY>
    <TR class=HeaderForXtalbe>
    <TH><%=SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(19482 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15364 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(18125 , user.getLanguage())%></TH>
    </TR>

    <TR class=DataDark>
    <TD><%=scopename%></TD>
    <TD><%if(timescope.equals("1")){%><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%><%}%>
        <%if(timescope.equals("2")){%><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%><%}%>
        <%if(timescope.equals("3")){%><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%><%}%>
        <%if(timescope.equals("4")){%><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%><%}%>
    </TD>
    <TD><%=Util.null2String(RecordSet2.getString("conditiondsp"))%></TD>
    <TD><%=Util.null2String(RecordSet2.getString("formulardsp"))%></TD>
    </TR>
<%
        while( RecordSet2.next() ) {
            timescope = ""+Util.getIntValue(RecordSet2.getString("timescope"),0) ;
            condition = ""+Util.null2String(RecordSet2.getString("condition")) ;
            formular = ""+Util.null2String(RecordSet2.getString("formular")) ;
            rateindex++ ;
            /*String schedulediff=Util.match(condition,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            condition=Util.replace(condition,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(condition,"@[^@]*@");
            }
            String target=Util.match(condition,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            condition=Util.replace(condition,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(condition,"\\$[^\\$]*\\$");
            }
            //解析公式
            schedulediff=Util.match(formular,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            formular=Util.replace(formular,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(formular,"@[^@]*@");
            }

            target=Util.match(formular,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            formular=Util.replace(formular,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(formular,"\\$[^\\$]*\\$");
            }
            //解析工资项目
            //System.out.println("formular"+formular);
            String item = Util.match(formular, "#[^#]*#");
            while (!item.equals("")) {
                String theitemid = item.substring(1, item.lastIndexOf("#"));
                String theitemcode="";
                if(theitemid.indexOf("_")>0){
                theitemcode=SalaryComInfo.getSalaryCode(theitemid.substring(0,theitemid.indexOf("_")))+theitemid.substring(theitemid.indexOf("_"));
                }else
                theitemcode=SalaryComInfo.getSalaryCode(theitemid);
                //System.out.println("theitemcode"+theitemcode);
                formular = Util.replace(formular, "#[^#]*#", theitemcode, 1);
                item = Util.match(formular, "#[^#]*#");
            }
            formular=Util.replace(formular,"\\^",SystemEnv.getHtmlLabelName(19378,user.getLanguage()),0);*/

%>
    <TR class=DataDark>
    <TD>&nbsp;</TD>
    <TD>
        <%if(timescope.equals("1")){%><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%><%}%>
        <%if(timescope.equals("2")){%><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%><%}%>
        <%if(timescope.equals("3")){%><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%><%}%>
        <%if(timescope.equals("4")){%><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%><%}%>
    </TD>
    <TD><%=Util.null2String(RecordSet2.getString("conditiondsp"))%></TD>
    <TD><%=Util.null2String(RecordSet2.getString("formulardsp"))%></TD>
    </TR>
<%      }
%>
    </TABLE>
    </TD></TR>
   </TBODY>
    </TABLE>

<%
    }
%>

<%if(calMode.equals("1")){%>
   <TABLE class=ListStyle>
       <COLGROUP>
    <COL width = '50%'>
    <COL width = '50%'>

    <TBODY>
    <TR class = HeaderForXtalbe>
    <TH><%=SystemEnv.getHtmlLabelName(6087 , user.getLanguage())+SystemEnv.getHtmlLabelName(1464 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(1851 , user.getLanguage())+SystemEnv.getHtmlLabelName(1464 , user.getLanguage())%></TH>
    </TR>
    <TR class=DataDark>
    <TD><%=personalPercent%>%</TD>
    <TD><%=companyPercent%>%</TD>
    </TR>
   </TABLE>
  </TBODY>
</TABLE>
<%}%>
    </wea:item>
    </wea:group>
    </wea:layout>
<%}%>


<%if( itemtype.equals("5") || itemtype.equals("6") ) {%>
    <wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(603 , user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
    <TABLE class=ListStyle id="oTable_kq" cols=2>
      <COLGROUP> 
      <COL width="5%"> 
      <COL width="95%">
      
      <TBODY>
      <TR class=HeaderForXtalbe> 
        <TH><%=SystemEnv.getHtmlLabelName(16672,user.getLanguage())%></TH>
      </TR>
    <%
        String diffid = "" ;

        RecordSet.executeSql(" select diffid from HrmSalarySchedule where itemid = " + itemid + " order by id " ) ;
        while( RecordSet.next() ) {
            diffid = ""+Util.getIntValue(RecordSet.getString("diffid"),0) ;
            if(diffid.equals("0") ) diffid = "" ;
            
    %>
      <TR bgcolor="#efefef"> 
        <TD><%=Util.toScreen(HrmScheduleDiffComInfo.getDiffname(diffid) , user.getLanguage())%></TD>
      </TR>
    <%  } %>
      </tbody>
    </table>
    </wea:item>
    </wea:group>
    </wea:layout>
<% } %>

<%if( itemtype.equals("7") ) {%>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16740 , user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
<table  class = ListStyle>
  <COLGROUP> 
  <COL width = "15%"> 
  <COL width = "85%"> 
  <tbody>
  <TR class = HeaderForXtalbe> 
    <TH><%=SystemEnv.getHtmlLabelName(16741,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TH>
  </TR>
  <%
    //  获得所有出勤种类关联的金额
    ArrayList shiftids = new ArrayList() ;
    ArrayList shiftpays = new ArrayList() ;

    RecordSet.executeProc("HrmSalaryShiftPay_SByItemid" , itemid) ; 
    while( RecordSet.next() ) {
        String shiftpay = Util.null2String(RecordSet.getString("shiftpay")) ;
        if( Util.getDoubleValue(shiftpay,0) == 0 ) continue ;
        shiftids.add(Util.null2String(RecordSet.getString("shiftid"))) ;
        shiftpays.add(Util.null2String(RecordSet.getString("shiftpay"))) ;
    }
    String shiftpay = "" ;
    int shiftpayindex = shiftids.indexOf("0") ;
    if( shiftpayindex != -1 ) shiftpay = (String) shiftpays.get( shiftpayindex ) ;
  %>
  <TR bgcolor = "#efefef"> 
    <TD><%=SystemEnv.getHtmlLabelName(16254,user.getLanguage())%></TD>
    <TD><%=shiftpay%></TD>
  </TR>
  <%
     RecordSet.executeProc("HrmArrangeShift_SelectAll" , "0") ; 	
	 while(RecordSet.next()){ 
		String shiftid = Util.null2String( RecordSet.getString("id") ) ; 
        String shiftname = Util.null2String( RecordSet.getString("shiftname") ) ; 
        shiftpay = "" ;
        shiftpayindex = shiftids.indexOf(shiftid) ;
        if( shiftpayindex != -1 ) shiftpay = (String) shiftpays.get( shiftpayindex ) ;
  %>
  <TR bgcolor = "#efefef"> 
    <TD><%=shiftname%></TD>
    <TD><%=shiftpay%></TD>
  </TR>
  <% } %>
  </tbody>
</table>
</wea:item>
</wea:group>
</wea:layout>
<% } %>



</form>
<script language=javascript>
function doEdit(obj) {
    document.frmMain.action = "HrmSalaryItemEdit.jsp" ;
    obj.diabled=true;
    document.frmMain.submit() ;
}

function doDelete(obj) {
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.frmMain.action="HrmSalaryItemOperation.jsp"
        document.frmMain.method.value="delete";
        obj.diabled=true;
        document.frmMain.submit();
    }
}

function doProcess(obj) {
    if(confirm("<%=SystemEnv.getHtmlLabelName(15840,user.getLanguage())%>\n<%=SystemEnv.getHtmlLabelName(15841,user.getLanguage())%>?")) {
        document.frmMain.method.value="process";
        obj.diabled=true;
        document.frmMain.submit();
    }
}
</script>
</body>
</html>
