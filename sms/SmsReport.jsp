
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.GraphFile" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int timeSag = Util.getIntValue(request.getParameter("timeSag"),5);

//String useridname=ResourceComInfo.getResourcename(userid+"");
String fromdate=Util.null2String(request.getParameter("fromdate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String department=Util.null2String(request.getParameter("department"));
String hrmid=Util.null2String(request.getParameter("hrmid"));
int reportType = 2;//默认按月显示


String sqlwhere=" where t1.id=t2.userid and messagestatus='1' ";

//时间处理
if(timeSag > 0&&timeSag<6){
	String tempfromdate = TimeUtil.getDateByOption(""+timeSag,"0");
	String tempenddate = TimeUtil.getDateByOption(""+timeSag,"1");
	if(!tempfromdate.equals("")){
		sqlwhere += " and t2.finishtime >= '" + tempfromdate + " 00:00:00'";
	}
	if(!tempenddate.equals("")){
		sqlwhere += " and t2.finishtime <= '" + tempenddate + " 23:59:59'";
	}
}else{
	if(timeSag==6){//指定时间
		if (!fromdate.equals("")) {
		    sqlwhere += " and t2.finishtime>='" + fromdate + " 00:00:00'";
		}
		if (!enddate.equals("")) {
		    sqlwhere += " and t2.finishtime<='" + enddate + " 23:59:59'";
		}
	}
}


if(!department.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.departmentid="+department;
	else 	sqlwhere+=" and t1.departmentid="+department;
}
if(!hrmid.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t2.userid="+hrmid;
	else 	sqlwhere+=" and t2.userid="+hrmid;
}

if(timeSag==2||timeSag==3){//本周本月,按日显示
	reportType=1;
}
    //System.out.println("sqlwhere = " + sqlwhere);
String totalSql = "SELECT COUNT(*) AS smscount FROM HrmResource t1, SMS_Message t2 "+sqlwhere;
RecordSet.executeSql(totalSql);
String totalCount = "0";
if(RecordSet.next()){
    totalCount = RecordSet.getString(1);
}

/*
if(user.getLogintype().equals("2")){
	if(sqlwhere.equals(""))	sqlwhere+=" where agentid!='' and  agentid!='0'";
	else 	sqlwhere+=" and  agentid!='' and  agentid!='0'";
}
*/
String sqlstr = "";

if(RecordSet.getDBType().equals("oracle")){
    if(reportType==1){
        sqlstr = "SELECT t2.smsyear,t2.smsmonth,t2.smsday,COUNT(*) AS smscount FROM HrmResource t1, SMS_Message t2 "+ sqlwhere +" GROUP BY t2.smsyear,t2.smsmonth,t2.smsday order by t2.smsyear,t2.smsmonth,t2.smsday";
    }else{
        sqlstr = "SELECT t2.smsyear,t2.smsmonth,COUNT(*) AS smscount FROM HrmResource t1, SMS_Message t2 "+ sqlwhere +" GROUP BY t2.smsyear,t2.smsmonth order by t2.smsyear,t2.smsmonth";
    }

}else{
    if(reportType==1){
        sqlstr = "select t2.smsyear,t2.smsmonth,t2.smsday,COUNT(*) AS smscount FROM HrmResource t1, SMS_Message t2 "+ sqlwhere  + " GROUP BY t2.smsyear,t2.smsmonth,t2.smsday order by t2.smsyear,t2.smsmonth,t2.smsday";
    }else{
        sqlstr = "select t2.smsyear,t2.smsmonth,COUNT(*) AS smscount FROM HrmResource t1, SMS_Message t2 "+ sqlwhere  + " GROUP BY t2.smsyear,t2.smsmonth order by t2.smsyear,t2.smsmonth";
    }
}


	//System.out.println("sqlstr = " + sqlstr);
    RecordSet.executeSql(sqlstr);
    
    
    
    Map map=null;
    Map drillMap=null;
 
    List list=new ArrayList();
    List drilldownlist=new ArrayList();
    List tempList=null;
    List tempList1=null;
    String year="";
    String month="";
    if(reportType==1){//按日显示
    	while(RecordSet.next()){
     		map= new HashMap();
    		map.put("name",RecordSet.getString("smsyear")+"-"+RecordSet.getString("smsmonth")+"-"+RecordSet.getString("smsday"));
    		map.put("y",RecordSet.getInt("smscount"));
    		list.add(map);
    	}
    }else{
   		while(RecordSet.next()){
   			year=RecordSet.getString("smsyear");
   			month=RecordSet.getString("smsmonth");
     		map= new HashMap();
    		map.put("name",year+"-"+month);
    		map.put("y",RecordSet.getInt("smscount"));
    		map.put("drilldown",year+"-"+month);
    		list.add(map);
    		//
    		rs.executeSql("SELECT t2.smsday, COUNT(*) AS smscount FROM HrmResource t1, SMS_Message t2 "+sqlwhere+
    			" and smsyear='"+year+"' and smsmonth='"+month+"' GROUP BY t2.smsday order by t2.smsday");
    		drillMap=new HashMap();
    		drillMap.put("id",year+"-"+month);
    		tempList=new ArrayList();
    		while(rs.next()){
    			tempList1= new ArrayList();
    			tempList1.add(year+"-"+month+"-"+rs.getString("smsday"));
    			tempList1.add(rs.getInt("smscount"));
    			tempList.add(tempList1);
    		}
    		drillMap.put("data",tempList);
    		drilldownlist.add(drillMap);
    	}
    }
    String smsJsonStr=JSONArray.fromObject(list).toString();
    String smsDrillJsonStr=JSONArray.fromObject(drilldownlist).toString();

    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(17009,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    
    String seriesName="";
     if(timeSag==2){
    	seriesName=SystemEnv.getHtmlLabelName(15539,user.getLanguage());
    }else if(timeSag==3){
    	seriesName=SystemEnv.getHtmlLabelName(15541,user.getLanguage());
    }else if(timeSag==4){
    	seriesName=SystemEnv.getHtmlLabelName(21904,user.getLanguage());
    }else if(timeSag==5){
    	seriesName=SystemEnv.getHtmlLabelName(15384,user.getLanguage());
    }else if(timeSag==6){
    	seriesName=SystemEnv.getHtmlLabelName(32530,user.getLanguage());
    }
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;   
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="communicate"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(17009,user.getLanguage()) %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<form name="frmmain" method="post" action="SmsReport.jsp">
<input type="hidden" name="isDelete" value="false">
<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
			<wea:item><%=SystemEnv.getHtmlLabelName(16975,user.getLanguage())%></wea:item>
            <wea:item>
				<brow:browser viewType="0" name="hrmid" browserValue='<%=hrmid%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids=" 
				hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
				browserSpanValue='<%=ResourceComInfo.getLastname(hrmid)%>'></brow:browser>
            </wea:item>

			<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="department" browserValue='<%=department%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" 
				hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  
				completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
				browserSpanValue='<%=DepartmentComInfo.getDepartmentname(department)%>'></brow:browser>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
			<wea:item>
				<span>
                          	<select name="timeSag" id="timeSag" onchange="changeTimeSag(this,'senddate');" style="width:100px;">
                          		<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
                          		<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
                          		<option value="4" <%=timeSag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
                          		<option value="5" <%=timeSag==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
                          		<option value="6" <%=timeSag==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
                          	</select>
                          </span>
                          <span id="senddate"  style="<%=timeSag==6?"":"display:none;" %>">
                          	  <BUTTON class=calendar type=button id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
							  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
							  <input type="hidden" name="fromdate" value=<%=fromdate%>>
							  －&nbsp;&nbsp;<BUTTON type=button class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
							  <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
							  <input type="hidden" name="enddate" value=<%=enddate%>>
						 </span>
			</wea:item>
		</wea:group>
		
		<wea:group context='<%=SystemEnv.getHtmlLabelName(17008, user.getLanguage())+SystemEnv.getHtmlLabelName(33046, user.getLanguage())%>' attributes="{'itemAreaDisplay':'inline-block'}">
			<wea:item attributes="{'colspan':'full'}">
				  <div id="SmsDiv" style="margin: 5 auto;margin-top:10px; min-width: 400px; height: 500px;"></div>
			</wea:item>
		</wea:group>
	</wea:layout>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>

<script type="text/javascript" src="/js/highcharts/highcharts_wev8.js"></script>
<script type="text/javascript" src="/js/highcharts/modules/no-data-to-display_wev8.js"></script>
<script type="text/javascript" src="/js/highcharts/modules/drilldown_wev8.js"></script>
<script language="javascript">
var smsStr='<%=smsJsonStr%>';
var smsData=eval('('+smsStr+')');
var smsDrillStr='<%=smsDrillJsonStr%>';
var smsDrillData=eval('('+smsDrillStr+')');
$(document).ready(function(){
    $('#SmsDiv').highcharts({
        chart: {
            type: 'column',
        },
        lang:{
        	drillUpText:"<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%> {series.name}",
        	noData: "<%=SystemEnv.getHtmlLabelName(26161,user.getLanguage())+SystemEnv.getHtmlLabelName(563,user.getLanguage()) %>" //没有 + 数据
        },
        credits: {
              enabled: false
        },
        title: {
            text: '<%=SystemEnv.getHtmlLabelName(18953,user.getLanguage())%>:<%=totalCount%>'
        },
        xAxis: {
            type: 'category'
        },
        yAxis: {
              min: 0,
              title: {
                  text: ' '
              },
              allowDecimals:false
        },
         tooltip: {
            formatter: function() {
                var point = this.point,
                    s = point.name +' : <b>'+ this.y +'</b><br/>';
                if (point.drilldown) {
                    s += '<%=SystemEnv.getHtmlLabelName(82279,user.getLanguage())%> '+ point.name +' <%=SystemEnv.getHtmlLabelName(22045,user.getLanguage())%>';
                } 
                return s;
            }
        },
        plotOptions: {
            series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: true,
                }
            }
        },
        legend:{
        	enabled:false
        },
        series: [{
            name: "<%=seriesName%>",
            colorByPoint: true,
            data:  smsData
        }],
        drilldown: {
            series: smsDrillData
        }
    })
    
});				

 		
     
function changeTimeSag(obj,spanname){
	if($(obj).val()=="6"){
		$('#'+spanname).show();
	}else{
		$('#'+spanname).hide();
		doSubmit();
	}
}
 
function doSubmit()
{
	document.frmmain.submit();
}
</script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
