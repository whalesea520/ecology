
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
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
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
int departmentid = Util.getIntValue(request.getParameter("departmentid"));   // 部门
String jobactivityid = Util.null2String(request.getParameter("jobactivityid")); // 职务
String jobtitle = Util.null2String(request.getParameter("jobtitle"));       // 岗位
String resourceid = Util.null2String(request.getParameter("resourceid"));       // 人力资源
String sent = Util.null2String(request.getParameter("sent"));       // 是否已发送
String yearmonth = Util.null2String(request.getParameter("yearmonth"));       // 工资单年月
int payid = Util.getIntValue(request.getParameter("payid"));       //工资单id
int createerror=Util.getIntValue(request.getParameter("createerror"));//生成工资单错误信息
String qname = Util.null2String(request.getParameter("flowTitle"));

String showname="";
if(departmentid>0){
    subcompanyid=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentid));
    showname=DepartmentComInfo.getDepartmentname(""+departmentid)+SystemEnv.getHtmlLabelName(503,user.getLanguage());
}else{
    showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid)+SystemEnv.getHtmlLabelName(503,user.getLanguage());
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
    String allrightcompany=SubCompanyComInfo.getRightSubCompany(user.getUID(),"Compensation:Manager",-1);
    ArrayList allrightcompanyid=Util.TokenizerString(allrightcompany,",");
    String allrightcompany1=SubCompanyComInfo.getRightSubCompany(user.getUID(),"Compensation:Manager",0);
    ArrayList allrightcompanyid1=Util.TokenizerString(allrightcompany1,",");
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
    sqlstr = " select a.id , a.jobtitle ,c.itemid,c.departmentid,c.salary,c.sent from HrmResource a ,HrmSalarypaydetail c "
        +" where a.id=c.hrmid " + sqlwhere + " order by c.departmentid , c.hrmid " ;
//    ArrayList itemlist=SalaryComInfo.getSubCompanySalary(subcompanyid);
    RecordSet.executeSql(sqlstr);
    ArrayList deptlist=new ArrayList();
    ArrayList deptrows=new ArrayList();
    ArrayList resourcelist=new ArrayList();
    ArrayList jobtitlelist=new ArrayList();
    ArrayList statuslist=new ArrayList();
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
        if(deptlist.indexOf(deptid)<0){
			resourcelist.add(resourceidrs);
			statuslist.add(tmpsent);
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
				statuslist.add(tmpsent);
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

ExcelFile.init() ;
ExcelSheet es = new ExcelSheet();
ExcelRow er = es.newExcelRow () ;
ExcelStyle style = ExcelFile.newExcelStyle("Header") ;
style.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
style.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
style.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
style.setAlign(ExcelStyle.WeaverHeaderAlign) ;
er.addStringValue(SystemEnv.getHtmlLabelName(15390,user.getLanguage()),"Header");
er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()),"Header");
er.addStringValue(SystemEnv.getHtmlLabelName(6086,user.getLanguage()),"Header");
for(int i=0;i<itemlist.size();i++){
    String itemid=(String)itemlist.get(i);
    if(itemid.indexOf("_")>-1){
        itemid=itemid.substring(0,itemid.indexOf("_"));
    }
    String itemname = SalaryComInfo.getSalaryname(itemid);
    String itemtype = SalaryComInfo.getSalaryItemtype(itemid);
    if( !itemtype.equals("9") ) {
        er.addStringValue(itemname,"Header");
    }else{
        i++;
        er.addStringValue(itemname+"("+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+")","Header");
        er.addStringValue(itemname+"("+SystemEnv.getHtmlLabelName(1851,user.getLanguage())+")","Header");
    }
}
er.addStringValue(SystemEnv.getHtmlLabelName(602,user.getLanguage()),"Header");
es.addExcelRow(er);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmmain").submit();
}

jQuery(document).ready(function(){
<%if(showname.length()>0){%>
 parent.setTabObjName('<%=showname%>');
 <%}%>
 //var scrollHeight = (document.body.scrollHeight-30)+"px";
 //jQuery("#scrollDiv").css("height",scrollHeight);
 var browserName = $.client.browserVersion.browser;             //浏览器名称
  var browserVersion = parseInt($.client.browserVersion.version);//浏览器版本
if(browserName == "IE"&&browserVersion<=8){
	 var scrollHeight = (document.body.scrollHeight-30)+"px";
     jQuery("#scrollDiv").css("height",scrollHeight);
}else{
	 var wHeight= window.parent.innerHeight;
	jQuery('#scrollDiv').css("height",wHeight-100+"px");
}
 //setInterval('var wHeight= window.parent.innerHeight; $("#scrollDiv").css("height",(wHeight-200)+"px");',500);
 ajaxProcessing();
 });
 
 function ajaxProcessing(){
	$.ajax({
			"url":"HrmSalaryOperation.jsp?method=processing",
			"type":"get",
			"dataType":"text",
			"success":function(d){
				var trimData = $.trim(d);
				if(trimData == '1'){
					setTimeout(ajaxProcessing,10*1000);
				}else{
					$('#showdatadiv').hide();
				}
			},
			"error":function(){
				$('#showdatadiv').hide();
			}
		});
}
 
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
function showdeptsalary(deptid,islight,showcheckbox){
    var ajax=ajaxinit();
    ajax.open("post", "HrmDeptSalary.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid="+deptid+"&islight="+islight+"&showcheckbox="+showcheckbox+"&Language=<%=user.getLanguage()%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>");
    
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                $GetEle("div"+deptid).innerHTML=ajax.responseText;
                jQuery("body").jNice();
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

//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

if(hasright){
if(!isclosed){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15845,user.getLanguage())+",javascript:onCreate(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(19575,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(19580,user.getLanguage())+",javascript:onChange(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(15848,user.getLanguage())+",javascript:onSend(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+SystemEnv.getHtmlLabelName(503,user.getLanguage())+",/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(19576,user.getLanguage())+",/hrm/finance/salary/HrmSalaryManageList.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(createerror==1){%>
<font color="red"><%=SystemEnv.getHtmlLabelName(19594,user.getLanguage())%></font>
<%}%>
<div id="showdatadiv" style="height:100%;width:100%;position: absolute;z-index: 10;">
	<div id='message_table_Div' class="xTable_message" style="position: relative;margin: 0 auto;top:30%;width: 170px;">
		<%=SystemEnv.getHtmlLabelName(20204,user.getLanguage())%>
	</div>
</div>
<form id=frmmain name=frmmain method=post action="HrmSalaryManageView.jsp">
<input class=inputstyle type="hidden" name="method" value="">
<input type="hidden" name="subCompanyId" value="<%=subcompanyid%>">
<input type="hidden" name="departmentid" value="<%=departmentid%>">
<input type="hidden" name="payid" value="<%=payid%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(!isclosed){ %>
				<input type=button class="e8_btn_top" onclick="onEdit();" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="onCreate(this);" value="<%=SystemEnv.getHtmlLabelName(15845,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="onSend();" value="<%=SystemEnv.getHtmlLabelName(15848,user.getLanguage())%>"></input>
			<%}%>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(19554,user.getLanguage())%></wea:item>
	  <wea:item>
	    <BUTTON class=calendar type=button id=SelectDate onclick=getSdDate(yearmonthspan,yearmonth)></BUTTON>&nbsp;
      <SPAN id="yearmonthspan" name="yearmonthspan" style="FONT-SIZE: x-small"><%=yearmonth%></SPAN>
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
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="submitData();"/>
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
  <tr class=HeaderForXtalbe>
  <TH width="200"><input type="checkbox"  id="depcb" name="depcb" /><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></TH>
  <TH width="100"><input type="checkbox"  id="namecb" name="namecb" /><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>
  <TH width="150"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
   <%
    for(int i=0;i<itemlist.size();i++) {
        String itemid=(String)itemlist.get(i);
        if(itemid.indexOf("_")>-1) itemid=itemid.substring(0,itemid.indexOf("_"));
        String itemname = SalaryComInfo.getSalaryname(itemid);
        String itemtype = SalaryComInfo.getSalaryItemtype(itemid);
        if( !itemtype.equals("9") ) {
   %>
   <TH width="100"><%=itemname%></TH>
   <%   } else { i++;%>
   <TH  width="100"><%=itemname+"("+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+")"%></TH>
   <TH  width="100"><%=itemname+"("+SystemEnv.getHtmlLabelName(1851,user.getLanguage())+")"%></TH>
   <%   }
    }
   %>
  <TH width="100"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TH>
  </tr>
   <tr>
       <td colspan="<%=itemlist.size()+4%>">
   <%
   boolean isLight = false;
   int nowrows=0;
   int tolrows=0;
   boolean showbox=false;
   String tempsubcompanyid="";
   ArrayList tempitems=new ArrayList();
   for(int i=0;i<deptlist.size();i++){
       String viewdeptid=(String)deptlist.get(i);
       String tempcompanyid=DepartmentComInfo.getSubcompanyid1(viewdeptid);
	   if(!tempcompanyid.equals(tempsubcompanyid)){
		   tempitems=SalaryComInfo.getSubCompanySalary(Util.getIntValue(tempcompanyid));
		   tempsubcompanyid=tempcompanyid;
	   }
       if(allrightcompanyid1.indexOf(tempcompanyid)>-1){
           showbox=true;
       }else{
           showbox=false;
       }
       int resourcenum=Util.getIntValue((String)deptrows.get(i));
       if(i>0){
           nowrows+=Util.getIntValue((String)deptrows.get(i-1));
       }
       isLight=!isLight;
       tolrows++;
       String viewresourceid=(String)resourcelist.get(nowrows);
       String viewjobtitle=(String)jobtitlelist.get(nowrows);
       er = es.newExcelRow() ;
       er.addStringValue(DepartmentComInfo.getDepartmentname(viewdeptid));
       er.addStringValue(ResourceComInfo.getResourcename(viewresourceid));
       er.addStringValue(JobTitlesComInfo.getJobTitlesname(viewjobtitle));
   %>
  <div id="div<%=viewdeptid%>"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
  <script>showdeptsalary("<%=viewdeptid%>","<%=isLight%>","<%=showbox%>");</script>
  </div>
   <%
      String itemeid="";
      for(int k=0;k<itemnums;k++){
          itemeid=(String)itemlist.get(k);
          if(tempitems.indexOf(itemeid)>-1 || itemlist1.indexOf(itemeid)>-1){
              er.addStringValue((String)itemsalarylist[k].get(nowrows));
           }else{
               er.addStringValue("");
           }
      }
       if(((String)statuslist.get(nowrows)).equals("1")){
           er.addStringValue(SystemEnv.getHtmlLabelName(19558,user.getLanguage()));
       }else{
           er.addStringValue(SystemEnv.getHtmlLabelName(19557,user.getLanguage()));
       }
      for(int j=(nowrows+1);j<(nowrows+resourcenum);j++){
          tolrows++;
          viewresourceid=(String)resourcelist.get(j);
          viewjobtitle=(String)jobtitlelist.get(j);
          er = es.newExcelRow() ;
           er.addStringValue(DepartmentComInfo.getDepartmentname(viewdeptid));
           er.addStringValue(ResourceComInfo.getResourcename(viewresourceid));
           er.addStringValue(JobTitlesComInfo.getJobTitlesname(viewjobtitle));
      itemeid="";

      for(int k=0;k<itemnums;k++){
          itemeid=(String)itemlist.get(k);
          if(tempitems.indexOf(itemeid)>-1 || itemlist1.indexOf(itemeid)>-1){
              er.addStringValue((String)itemsalarylist[k].get(j));
           }else{
               er.addStringValue("");
           }
      }
          if(((String)statuslist.get(j)).equals("1")){
              er.addStringValue(SystemEnv.getHtmlLabelName(19558,user.getLanguage()));
          }else{
              er.addStringValue(SystemEnv.getHtmlLabelName(19557,user.getLanguage()));
          }          
      }
   }
   ExcelFile.setFilename(showname) ;
   ExcelFile.addSheet(yearmonth, es) ;
   %>
   </td>
   </tr> 
 </TABLE>
 </div>
 </div>
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
</form>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script language=javascript>
function onCreate(obj){
    var ajax=ajaxinit();
    ajax.open("POST", "HrmSalaryCheck.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&yearmonth="+document.frmmain.yearmonth.value);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            if(ajax.responseText!=1){
            	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(19577,user.getLanguage())%>",function(){
                frmmain.method.value="create";
                frmmain.action="HrmSalaryOperation.jsp";
                frmmain.submit();            		
            	})
            }else{
                var showTableDiv  = document.getElementById('_xTable');
                var message_table_Div = document.createElement("div");
                message_table_Div.id="message_table_Div";
                message_table_Div.className="xTable_message";
                showTableDiv.appendChild(message_table_Div);
                var message_table_Div  = document.getElementById("message_table_Div");
                message_table_Div.style.display="inline";
                message_table_Div.innerHTML="<%=SystemEnv.getHtmlLabelName(19578,user.getLanguage())%>";
                var pTop= document.body.offsetHeight/2-60;
                var pLeft= document.body.offsetWidth/2-100;
                message_table_Div.style.position="absolute";
                message_table_Div.style.posTop=pTop;
                message_table_Div.style.posLeft=pLeft;
                obj.disabled=true;
                document.frmmain.method.value="create";
                document.frmmain.action="HrmSalaryOperation.jsp";
                document.frmmain.submit();
            }
            }catch(e){
                return false;
            }
        }
    }
}

function onSend(){
	var flag = false;
	jQuery(":checkbox").each(function(){
		if(this.checked){
			flag = true;
		}
	});
	
	if(!flag){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25763 ,user.getLanguage())%>");
		return false;
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(19586,user.getLanguage())%>",function(){
    document.frmmain.method.value="send";
    document.frmmain.action="HrmSalaryOperation.jsp";
    document.frmmain.submit();
	})
}
function onEdit(){
    document.frmmain.action="HrmSalaryManageEdit.jsp";
    document.frmmain.submit();
}
function onChange(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(19581,user.getLanguage())%>",function(){
    document.frmmain.method.value="change";
    document.frmmain.action="HrmSalaryOperation.jsp";
    document.frmmain.submit();
	})
}

function onClose(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(20805,user.getLanguage())%>\n\n<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%><%=showname%>?",function(){
    document.frmmain.method.value="close";
    document.frmmain.action="HrmSalaryOperation.jsp";
    document.frmmain.submit();
	})
}

function submitData() {
    document.frmmain.payid.value="";
    document.frmmain.submit();
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
            spanname.innerHTML = jsid.name.substring(1);
            inputname.value = jsid.id.substring(1);
        } else {
            if (ismand == 1)

                spanname.innerHTML = "";
            inputname.value = "";
        }
    }
}
function CheckAll(haschecked,thedeptid) {
    len = document.frmmain.elements.length;
    var resourcename="chkresourceid_"+thedeptid;
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name==resourcename) {
            document.frmmain.elements[i].checked=(haschecked==true?true:false);
            if(haschecked == true){
            	changeCheckboxStatus( jQuery("input[name="+resourcename+"]"),true);
            }else{
            	changeCheckboxStatus( jQuery("input[name="+resourcename+"]"),false);
            }
        }
    }
}


function CheckChanage(obj,thedeptid){
    len = document.frmmain.elements.length;
    var i=0;
    var haschecked=false;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name==obj.name) {
            if(document.frmmain.elements[i].checked==true){
                haschecked=true;
                break;
            }
        }
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=="chkdeptid") {
            if(document.frmmain.elements[i].value==thedeptid){
                document.frmmain.elements[i].checked=haschecked;
                break;
            }
        }
    }
}

//部门全选
jQuery(document).ready(function() {
  jQuery("#depcb").click(function(){
   if(jQuery(this).attr("checked") == true){ 
     jQuery("input[name='chkdeptid']").each(function(){
     changeCheckboxStatus(this,true);
     len = document.frmmain.elements.length;
     var resourcename="chkresourceid_"+jQuery(this).val();
     var i=0;
     for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name==resourcename) {
            document.frmmain.elements[i].checked=(jQuery(this).attr("checked")==true?true:false);
        }
      }
    });
   }else{
    jQuery("input[name='chkdeptid']").each(function(){
      changeCheckboxStatus(this,false);
      len = document.frmmain.elements.length;
      var resourcename="chkresourceid_"+jQuery(this).val();
      var i=0;
      for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name==resourcename) {
            document.frmmain.elements[i].checked=(jQuery(this).attr("checked")==true?true:false);
        }
      }
    });
   }
  });
  
  
//姓名全选
  jQuery("#namecb").click(function(){
   if(jQuery(this).attr("checked") == true){ 
     jQuery("input[name^='chkresourceid_']").each(function(){
     changeCheckboxStatus(this,true);
     len = document.frmmain.elements.length;
     var i=0;
     var haschecked=true;
     for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name==jQuery(this).attr("name")) {
            if(document.frmmain.elements[i].checked==true){
                haschecked=true;
                break;
            }
        }
     }
     for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=="chkdeptid") {
        var chkdeptid = document.getElementsByName("chkdeptid");
        for(var j=0; j<chkdeptid.length;j++){
        	if(document.frmmain.elements[i].value==chkdeptid[j].value){
                document.frmmain.elements[i].checked=haschecked;
                break;
            }
          }
        }
     }
    });
   }else{
     jQuery("input[name^='chkresourceid_']").each(function(){
     changeCheckboxStatus(this,false);
     len = document.frmmain.elements.length;
     var i=0;
     var haschecked=false;
     for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=="chkdeptid") {
        var chkdeptid = document.getElementsByName("chkdeptid");
        for(var j=0; j<chkdeptid.length;j++){
        	if(document.frmmain.elements[i].value==chkdeptid[j].value){
                document.frmmain.elements[i].checked=haschecked;
                break;
            }
          }
        }
   	  }
    });
   }
  });
 }
 );
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
