
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.general.MathUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
boolean hasright=true;
if(!HrmUserVarify.checkUserRight("Compensation:Manager", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="SalaryManager" class="weaver.hrm.finance.SalaryManager" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
int departmentid = Util.getIntValue(request.getParameter("departmentid"));   // 部门
String jobactivityid = Util.null2String(request.getParameter("jobactivityid")); // 职务
String jobtitle = Util.null2String(request.getParameter("jobtitle"));       // 岗位
String resourceid = Util.null2String(request.getParameter("resourceid"));       // 人力资源
String sent = Util.null2String(request.getParameter("sent"));       // 是否已发送
String yearmonth = Util.null2String(request.getParameter("yearmonth"));       // 工资单年月
int payid = Util.getIntValue(request.getParameter("payid"));       //工资单id
String qname = Util.null2String(request.getParameter("flowTitle"));
String showname="";
if(subcompanyid<1 && departmentid>0){
    subcompanyid=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentid));
    showname=DepartmentComInfo.getDepartmentname(""+departmentid)+"   "+SystemEnv.getHtmlLabelName(503,user.getLanguage());
}else{
    showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid)+"   "+SystemEnv.getHtmlLabelName(503,user.getLanguage());
}
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Compensation:Manager",subcompanyid);
    if(operatelevel==-1){
            response.sendRedirect("/notice/noright.jsp");
            return;
    }
    if(operatelevel<1){
        hasright=false;
    }
    }else{
       hasright=false;
    }
}

    String sqlwhere="";
    if( !jobactivityid.equals("") ){
        sqlwhere+=" and exists (select 1 from HrmJobTitles d where d.id=a.jobtitle and d.jobactivityid= " + jobactivityid + " ) " ;
    }
    if( !jobtitle.equals("") ){
        sqlwhere+=" and a.jobtitle = " + jobtitle;
    }
    if( !qname.equals("") && resourceid.length()==0){
    	String tmpresourceids = "";
    	String sql = "select id from hrmresource where lastname like '%"+qname+"%'";
    	rs.executeSql(sql);
    	while(rs.next()){
    		if(tmpresourceids.length()>0)tmpresourceids+=",";
    		tmpresourceids+=rs.getString("id");
    	}
    	sqlwhere+=" and c.hrmid in (" + tmpresourceids+")";
	  }  
    if( !resourceid.equals("") ){
        sqlwhere+=" and c.hrmid in (" + resourceid+")";
    }
    if( !sent.equals("") ) {
        sqlwhere+=" and c.sent = " + sent ;
    }
   
    String subcompanystr="";
    String departmentstr = "";
    String allrightcompany=SubCompanyComInfo.getRightSubCompany(user.getUID(),"Compensation:Manager",0);
    ArrayList allrightcompanyid=Util.TokenizerString(allrightcompany,",");
    if(departmentid<1){
        subcompanystr=SubCompanyComInfo.getRightSubCompanyStr1(""+subcompanyid,allrightcompanyid);
        sqlwhere+=" and a.subcompanyid1 in("+subcompanystr+") and c.departmentid in(select id from HrmDepartment where subcompanyid1 in("+subcompanystr+"))";
    }else{
        departmentstr=SubCompanyComInfo.getDepartmentTreeStr(""+departmentid)+departmentid;
        sqlwhere+=" and c.departmentid in("+departmentstr+")";
    }
    if(payid>0){
        RecordSet.executeSql("select paydate from HrmSalarypay  where id="+payid);
        if(RecordSet.next()){
            yearmonth=RecordSet.getString(1);
        }
    }else{
        if(yearmonth.trim().equals("")){
            if(departmentid<1){
                RecordSet.executeSql("select distinct b.payid,a.paydate from HrmSalarypay a,HrmSalarypaydetail b where a.id=b.payid and exists (select 1 from Hrmdepartment where id=b.departmentid and subcompanyid1 in("+subcompanystr+")) order by a.paydate desc");
            }else{
                RecordSet.executeSql("select distinct b.payid,a.paydate from HrmSalarypay a,HrmSalarypaydetail b where a.id=b.payid and b.departmentid in("+departmentstr+") order by a.paydate desc");
            }
            if(RecordSet.next()){
                payid=RecordSet.getInt(1);
                yearmonth=RecordSet.getString(2);
            }else{
                Calendar thedate = Calendar.getInstance ();
                yearmonth = Util.add0(thedate.get(thedate.YEAR), 4) +"-"+Util.add0(thedate.get(thedate.MONTH) + 1, 2) ;
            }
        }else{
            if(departmentid<1){
                RecordSet.executeSql("select distinct b.payid,a.paydate from HrmSalarypay a,HrmSalarypaydetail b where a.id=b.payid and exists (select 1 from Hrmdepartment where id=b.departmentid and subcompanyid1 in("+subcompanystr+")) and a.paydate='"+yearmonth+"' order by a.paydate desc");
            }else{
                RecordSet.executeSql("select distinct b.payid,a.paydate from HrmSalarypay a,HrmSalarypaydetail b where a.id=b.payid and b.departmentid in("+departmentstr+") and a.paydate='"+yearmonth+"' order by a.paydate desc");
            }
            if(RecordSet.next()){
                payid=RecordSet.getInt(1);
                yearmonth=RecordSet.getString(2);
            }
        }
    }
    showname+="("+yearmonth+")";
    sqlwhere+=" and c.payid="+payid;
    String salarystate=SystemEnv.getHtmlLabelName(309,user.getLanguage());
    String sqlstr = " select distinct status from HrmSalarypaydetail where payid=" + payid ;
    if(departmentid>0){
        sqlstr+=" and departmentid in("+departmentstr+")";
    }else if(subcompanyid>0){
        sqlstr+=" and  exists (select 1 from Hrmdepartment c where c.id=departmentid and c.subcompanyid1 in("+subcompanystr+"))";
    }
    //System.out.println(sqlstr);
    RecordSet.executeSql(sqlstr);
    if(RecordSet.getCounts()<1){
        salarystate=SystemEnv.getHtmlLabelName(360,user.getLanguage());
    }
    while(RecordSet.next()){
        if(RecordSet.getString("status").equals("0")){
            salarystate=SystemEnv.getHtmlLabelName(360,user.getLanguage());
        }
    }
    boolean isclosed=false;
    if(salarystate.equals(SystemEnv.getHtmlLabelName(309,user.getLanguage()))) isclosed=true;
    ArrayList itemlist=new ArrayList();
    ArrayList itemlist1=new ArrayList();
    sqlstr="select distinct d.showorder,c.itemid from HrmResource a,HrmSalaryPaydetail c,hrmsalaryitem d where a.id=c.hrmid and REPLACE(REPLACE(c.itemid,'_1',''),'_2','')=convert(varchar,d.id) and d.isshow='1' " + sqlwhere +" order by d.showorder,c.itemid";
    if("oracle".equalsIgnoreCase(RecordSet.getDBType())){
        sqlstr="select distinct d.showorder,c.itemid from HrmResource a,HrmSalaryPaydetail c,hrmsalaryitem d where a.id=c.hrmid and to_number(REPLACE(REPLACE(c.itemid,'_1',''),'_2',''))=d.id and d.isshow='1' " + sqlwhere +" order by d.showorder,c.itemid";
    }
    RecordSet.executeSql(sqlstr);
    while( RecordSet.next() ) {
        String tmpitemid = RecordSet.getString("itemid") ;
        if(itemlist.indexOf(tmpitemid)==-1){
            itemlist.add(tmpitemid);
        }
    }
	sqlstr="select distinct c.itemid from HrmResource a,HrmSalaryPaydetail c where a.id=c.hrmid and REPLACE(REPLACE(c.itemid,'_1',''),'_2','') not in(select convert(varchar,id) from hrmsalaryitem) " + sqlwhere +" order by c.itemid";
    if("oracle".equalsIgnoreCase(RecordSet.getDBType())){
        sqlstr="select distinct c.itemid from HrmResource a,HrmSalaryPaydetail c where a.id=c.hrmid and to_number(REPLACE(REPLACE(c.itemid,'_1',''),'_2','')) not in(select id from hrmsalaryitem) " + sqlwhere +" order by c.itemid";
    }
    RecordSet.executeSql(sqlstr);
    while( RecordSet.next() ) {
        String tmpitemid = RecordSet.getString("itemid") ;
        if(itemlist1.indexOf(tmpitemid)==-1){
            itemlist1.add(tmpitemid);
        }
        if(itemlist.indexOf(tmpitemid)==-1){
            itemlist.add(tmpitemid);
        }
    }
    if(itemlist.size()<1){
        itemlist=SalaryComInfo.getSubCompanySalary(subcompanyid);
    }
    sqlstr = " select a.id , a.jobtitle ,c.itemid,c.departmentid,c.salary,c.sent,c.status from HrmResource a ,HrmSalarypaydetail c "
        +" where a.id=c.hrmid " + sqlwhere + " order by c.departmentid , c.hrmid " ;
    //System.out.println(sqlstr);
//    ArrayList itemlist=SalaryComInfo.getSubCompanySalary(subcompanyid);
    RecordSet.executeSql(sqlstr);
    ArrayList deptlist=new ArrayList();
    ArrayList deptrows=new ArrayList();
    ArrayList resourcelist=new ArrayList();
    ArrayList jobtitlelist=new ArrayList();
    ArrayList statuslist=new ArrayList();
    ArrayList sendlist=new ArrayList();
    int itemnums=itemlist.size();
    ArrayList[] itemsalarylist=new ArrayList[itemnums];
    for(int j=0;j<itemnums;j++){
        itemsalarylist[j]=new ArrayList();
    }
    int rows=0;
    while(RecordSet.next()){
        String deptid=Util.null2String(RecordSet.getString("departmentid"));
        String resourceidrs = Util.null2String(RecordSet.getString("id")) ;
        String jobtitlers = Util.null2String(RecordSet.getString("jobtitle")) ;
        String tmpitemid=Util.null2String(RecordSet.getString("itemid")) ;
        String tmpsalary=Util.null2String(RecordSet.getString("salary")) ;
        String tmpsent=Util.null2String(RecordSet.getString("sent")) ;
        String tmpstatus=Util.null2String(RecordSet.getString("status")) ;
		if(deptlist.indexOf(deptid)<0){
            resourcelist.add(resourceidrs);
            statuslist.add(tmpstatus);
            sendlist.add(tmpsent);
            jobtitlelist.add(jobtitlers);
            for(int j=0;j<itemnums;j++){
                itemsalarylist[j].add("0.00");
            }
            deptlist.add(deptid);
            deptrows.add("0");
            rows=1;
        }else{
            if(resourcelist.indexOf(resourceidrs)<0){
                rows++;
                resourcelist.add(resourceidrs);
                statuslist.add(tmpstatus);
                sendlist.add(tmpsent);
                jobtitlelist.add(jobtitlers);
                for(int j=0;j<itemnums;j++){
                    itemsalarylist[j].add("0.00");
                }
            }
            deptrows.set(deptlist.size()-1,""+rows);
        }
        if(itemlist.indexOf(tmpitemid)>-1){
            itemsalarylist[itemlist.indexOf(tmpitemid)].set(resourcelist.size()-1,tmpsalary);
        }
    }
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(16263,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client.js"></script>
<script language=javascript>
function onBtnSearchClick(){
  frmmain.action="HrmSalaryManageEdit.jsp";
	jQuery("#frmmain").submit();
}

jQuery(document).ready(function(){
<%if(showname.length()>0){%>
 parent.setTabObjName('<%=showname%>');
 <%}%>
 //var scrollHeight = (document.body.scrollHeight-30)+"px";
// jQuery("#scrollDiv").css("height",scrollHeight);
var browserName = $.client.browserVersion.browser;             //浏览器名称
  var browserVersion = parseInt($.client.browserVersion.version);//浏览器版本
if(browserName == "IE"&&browserVersion<=8){
	 var scrollHeight = (document.body.scrollHeight-30)+"px";
     jQuery("#scrollDiv").css("height",scrollHeight);
}else{
	 var wHeight= window.parent.innerHeight;
	jQuery('#scrollDiv').css("height",wHeight-100+"px");
}

 //setInterval('var wHeight= window.parent.innerHeight; $("#scrollDiv").css("height",(wHeight-100)+"px");',500);
});
 
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
function showEditdeptsalary(deptid,islight){
    var ajax=ajaxinit();
    ajax.open("POST", "HrmEditDeptSalary.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid="+deptid+"&islight="+islight+"&Language=<%=user.getLanguage()%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                $GetEle("div"+deptid).innerHTML=ajax.responseText;
            }catch(e){
                return false;
            }
        }
    }
}
</script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(hasright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id=frmmain name=frmmain method=post action="HrmSalaryOperation.jsp">
<input class=inputstyle type="hidden" name="method" value="edit">
<input type="hidden" name="subCompanyId" value="<%=subcompanyid%>">
<input type="hidden" name="departmentid" value="<%=departmentid%>">
<input type="hidden" name="payid" value="<%=payid%>">
<input type="hidden" name="changeitemids" value="">
<input type="hidden" name="changeids" value="">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(!isclosed){ %>
				<input type=button class="e8_btn_top" onclick="onSearch();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="onBack();" value="<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>"></input>
			<%}%>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
     <wea:item><%=SystemEnv.getHtmlLabelName(19554,user.getLanguage())%></wea:item>
     <wea:item>
       <BUTTON class=calendar type=button id=SelectDate onclick=getSdDate(yearmonthspan,yearmonth)></BUTTON>&nbsp;
       <SPAN id=yearmonthspan style="FONT-SIZE: x-small"><%=yearmonth%></SPAN>
       <input class=inputstyle type="hidden" name="yearmonth" value=<%=yearmonth%>>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
     <wea:item>
	     	<brow:browser viewType="0" name="resourceid" browserValue='<%=resourceid %>' 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
	         hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	         completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)"
	         browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage()) %>'>
	      </brow:browser>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
     <wea:item>
		  	<brow:browser viewType="0" name="jobtitle" browserValue='<%=jobtitle %>'
	      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?selectedids="
	      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	      completeUrl="/data.jsp?type=hrmjobtitles"
	      browserSpanValue='<%=JobTitlesComInfo.getJobTitlesname(jobtitle+"") %>'>
	      </brow:browser>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></wea:item>
     <wea:item>
	      <brow:browser viewType="0" name="jobactivityid" browserValue='<%=jobactivityid %>'
	      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp?selectedids="
	      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	      completeUrl="/data.jsp?type=jobactivity"
	      browserSpanValue='<%=JobActivitiesComInfo.getJobActivitiesname(jobactivityid+"") %>'>
	      </brow:browser>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(19556,user.getLanguage())%></wea:item>
     <wea:item>
         <%=salarystate%>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(19555,user.getLanguage())%></wea:item>
     <wea:item>
       <SELECT class=inputStyle id=sent name=sent>
        <OPTION value="" <% if(sent.equals("")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
        <OPTION value="0" <% if(sent.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19557,user.getLanguage())%></OPTION>
        <OPTION value="1" <% if(sent.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19558,user.getLanguage())%></OPTION>
      </SELECT>
		</wea:item>
	</wea:group>
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<%
    int widthint=550;
    for(int i=0;i<itemlist.size();i++) {
        widthint+=100;
    }
%>
<div id="scrollDiv" style="width:100%; overflow:auto;">
<div style="min-width:<%=widthint%>px;">
<TABLE class=ListStyle width="<%=widthint%>" border="0" cellspacing="1" cellpadding="0">
  <tr class=header style="HEIGHT: 30px ;BORDER-Spacing:1pt">
  <TH  rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle;" width="200"><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></TH>
  <TH  rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle;" width="100"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
  <TH  rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle;" width="150"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
   <%

    for(int i=0;i<itemlist.size();i++) {
        String itemid=(String)itemlist.get(i);
        if(itemid.indexOf("_")>-1) itemid=itemid.substring(0,itemid.indexOf("_"));
        String itemname = SalaryComInfo.getSalaryname(itemid);
        String itemtype = SalaryComInfo.getSalaryItemtype(itemid);
        if( !itemtype.equals("9") ) {
   %>
   <TH  rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle;" width="100"><%=itemname%></TH>
   <%   } else { i++;%>
   <TH colspan=2 style="TEXT-ALIGN:center;" width="200"><%=itemname%></TH>
   <%   }
    }
   %>
  <TH  rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle;" width="100"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TH>
  </tr>
  <tr style=" HEIGHT: 30px ;BORDER-Spacing:1pt">
   <%
    for(int i=0;i<itemlist.size();i++) {
        String itemid=(String)itemlist.get(i);
        if(itemid.indexOf("_")>-1) itemid=itemid.substring(0,itemid.indexOf("_"));
        String itemtype = SalaryComInfo.getSalaryItemtype(itemid);
        if( !itemtype.equals("9") ) continue ;
        i++;
   %>
   <TH  style="TEXT-ALIGN:center;" width="100"><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></TH>
   <TH  style="TEXT-ALIGN:center;" width="100"><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></TH>
   <%
    }
   %>
   </tr>
   <tr>
       <td colspan="<%=itemlist.size()+4%>">
   <%
   boolean isLight = false;
   for(int i=0;i<deptlist.size();i++){
       String viewdeptid=(String)deptlist.get(i);
       isLight=!isLight;
   %>
   <div id="div<%=viewdeptid%>"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
  <script>showEditdeptsalary("<%=viewdeptid%>","<%=isLight%>");</script>
  </div>
   <%
   }
   %>
    </td>
    </tr>
 </TABLE>
  </div>
 </div>
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
<script language=javascript>
function onSearch(){
   frmmain.payid.value="";
   frmmain.action="HrmSalaryManageEdit.jsp";
   frmmain.submit();
}
function submitData() {
    if(frmmain.changeids.value=="" || frmmain.changeitemids.value==""){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19583,user.getLanguage())%>");
    }else{
        frmmain.submit();
    }
}
function onBack() {
    frmmain.payid.value="";
    frmmain.action="HrmSalaryManageView.jsp";
    frmmain.submit();
}
function onShowResource(spanname, inputname) {
    <%if(departmentid>0){%>
        url=escape("/hrm/resource/MutiResourceBrowser.jsp?sqlwhere=where departmentid=<%=departmentid%>");
    <%}else{%>
        url=escape("/hrm/resource/MutiResourceBrowser.jsp?sqlwhere=where subcompanyid1=<%=subcompanyid%>");
    <%}%>
    try {
    	jsid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    } catch(e) {
        return;
    }
    if (jsid != null) {
    	if (jsid.id != "0") {
            spanname.innerHTML = jsid.name;
            inputname.value = jsid.id;
        } else {
            if (ismand == 1)

                spanname.innerHTML = "";
            inputname.value = "";
        }
    }
}
function setchange(theitemname,theitemid,thehrmid){
    var nowvalue=$GetEle(theitemname).value;
    var oldvalue=$GetEle("old"+theitemname).value;
    try{
        nowvalue=parseFloat(nowvalue);
        if(isNaN(nowvalue)){
            nowvalue=0;
        }
    }catch(e){
        nowvalue=0;
    }	
    try{
        oldvalue=parseFloat(oldvalue);
        if(isNaN(oldvalue)){
            oldvalue=0;
        }
    }catch(e){
        oldvalue=0;
    }
    var changeitemids=frmmain.changeitemids.value+",";
    var changeids=frmmain.changeids.value+",";
    //alert(oldvalue+"|"+nowvalue+"|"+changeitemids+"|"+changeids);
    if(nowvalue!=oldvalue){
        if(changeitemids.indexOf(","+theitemid+",")<0){
            changeitemids+=theitemid;
            frmmain.changeitemids.value=changeitemids;
        }
        if(changeids.indexOf(","+thehrmid+",")<0){
            changeids+=thehrmid;
            frmmain.changeids.value=changeids;
        }
    }
    //alert(oldvalue+"|"+nowvalue+"|"+changeitemids+"|"+changeids);
}
</script>

<script language=vbs>
sub onShowJobActivity(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp")
	if Not isempty(id) then
        if id(0)<> 0 then
            spanname.innerHtml = id(1)
            inputname.value=id(0)
        else
            spanname.innerHtml = ""
            inputname.value=""
        end if
	end if
end sub

sub onShowJobtitle(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
        if id(0)<> 0 then
            spanname.innerHtml = id(1)
            inputname.value=id(0)
        else
            spanname.innerHtml = ""
            inputname.value=""
        end if
	end if
end sub
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
