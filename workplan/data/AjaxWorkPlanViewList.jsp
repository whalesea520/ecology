<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.WorkPlan.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="net.sf.json.JSONArray" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="wpSetInfo" class="weaver.WorkPlan.WorkPlanSetInfo" scope="page" />
<jsp:useBean id="wpvList" class="weaver.WorkPlan.WorkPlanViewList" scope="page" />
<%!
	public String color(int c) {
	  c=c<0?0:c;
	  int i=0;
      String d = "666666888888aaaaaabbbbbbdddddda32929cc3333d96666e69999f0c2c2b1365fdd4477e67399eea2bbf5c7d67a367a994499b373b3cca2cce1c7e15229a36633cc8c66d9b399e6d1c2f029527a336699668cb399b3ccc2d1e12952a33366cc668cd999b3e6c2d1f01b887a22aa9959bfb391d5ccbde6e128754e32926265ad8999c9b1c2dfd00d78131096184cb05288cb8cb8e0ba52880066aa008cbf40b3d580d1e6b388880eaaaa11bfbf4dd5d588e6e6b8ab8b00d6ae00e0c240ebd780f3e7b3be6d00ee8800f2a640f7c480fadcb3b1440edd5511e6804deeaa88f5ccb8865a5aa87070be9494d4b8b8e5d4d47057708c6d8ca992a9c6b6c6ddd3dd4e5d6c6274878997a5b1bac3d0d6db5a69867083a894a2beb8c1d4d4dae54a716c5c8d8785aaa5aec6c3cedddb6e6e41898951a7a77dc4c4a8dcdccb8d6f47b08b59c4a883d8c5ace7dcce";
      return "#" + d.substring(c * 30 + i * 6, c * 30 + (i + 1) * 6);
	}

	public String getItemDiv(WorkPlanViewBean bean,String[] showInfos,String[] tooltipInfos,ResourceComInfo resInfo,boolean isLast,int language){
		String title="1".equals(tooltipInfos[0])?SystemEnv.getHtmlLabelName(740, language)+"："+bean.getBeginDate()+"&nbsp;":"";
			title+="1".equals(tooltipInfos[1])?SystemEnv.getHtmlLabelName(742, language)+"："+bean.getBeginTime():"";
			title+=("1".equals(tooltipInfos[2])||"1".equals(tooltipInfos[3]))?"\n":"";
			title+="1".equals(tooltipInfos[2])?SystemEnv.getHtmlLabelName(741, language)+"："+bean.getEndDate()+"&nbsp;":"";
			title+="1".equals(tooltipInfos[3])?SystemEnv.getHtmlLabelName(743, language)+"："+bean.getEndTime():"";
			title+="1".equals(tooltipInfos[4])?"\n"+SystemEnv.getHtmlLabelName(229, language)+"："+bean.getTitle():"";
			title+="1".equals(tooltipInfos[5])?"\n"+SystemEnv.getHtmlLabelName(882, language)+"："+resInfo.getLastname(""+bean.getCreater()):"";
			title+="1".equals(tooltipInfos[6])?"\n"+SystemEnv.getHtmlLabelName(15525, language)+"："+resInfo.getMulResourcename(bean.getResourceid()).trim():"";
		String str="";	
		str="<div class=\"rb-o drag\" onclick=\"View("+bean.getWorkid()+")\" title=\""+title+"\" style=\""+(isLast?"margin-bottom: 18px;":"")+"\">"+
			 "<div class=\" rb-m\" style=\"background-color:"+color(bean.getColor())+"\">"+
				"<div class=\"rb-i\">"+
			 		"<span style=\"cursor: pointer\">"+
			 		  ("1".equals(showInfos[0])?bean.getBeginTime():"")+
			 		  ("1".equals(showInfos[0])?"1".equals(showInfos[1])?"-"+bean.getEndTime():"":"1".equals(showInfos[1])?bean.getEndTime():"")+
			 		  ("1".equals(showInfos[2])?" &nbsp;"+bean.getTitle():"")+
			 		  ("1".equals(showInfos[3])?" &nbsp;"+resInfo.getLastname(""+bean.getCreater()):"")+
					"</span>"+
				"</div></div></div>";
		return str;
	}
%>
<%
User user = HrmUserVarify.getUser(request,response);
int userSub = user.getUserSubCompany1(); 
Calendar calendar = Calendar.getInstance();
    

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
char flag=2;
String userid=user.getUID()+"" ;
//1: year 2:month 3:week 4:today but the year haven`t been used!
int bywhat = Util.getIntValue(request.getParameter("bywhat"),3);

String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));
String objType=Util.null2String(request.getParameter("objType"));
String objIds=Util.null2String(request.getParameter("objIds"));
String workType=Util.null2String(request.getParameter("workPlanType"));
Calendar today = Calendar.getInstance();
Calendar temptoday1 = Calendar.getInstance();
Calendar temptoday2 = Calendar.getInstance();
String nowdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String nowtime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                Util.add0(today.get(Calendar.SECOND), 2);   

if(!currentdate.equals("")) {
	int tempyear = Util.getIntValue(currentdate.substring(0,4)) ;
	int tempmonth = Util.getIntValue(currentdate.substring(5,7))-1 ;
	int tempdate = Util.getIntValue(currentdate.substring(8,10)) ;
	today.set(tempyear,tempmonth,tempdate);
} 

int currentyear=today.get(Calendar.YEAR);
int thisyear=currentyear;
int currentmonth=today.get(Calendar.MONTH);  
int currentday=today.get(Calendar.DATE);

switch(bywhat) {
	case 1:
		today.set(currentyear,0,1) ;
		if(movedate.equals("1")) today.add(Calendar.YEAR,1) ;
		if(movedate.equals("-1")) today.add(Calendar.YEAR,-1) ;
		break ;
	case 2:
		today.set(currentyear,currentmonth,1) ;
		if(movedate.equals("1")) today.add(Calendar.MONTH,1) ;
		if(movedate.equals("-1")) today.add(Calendar.MONTH,-1) ;
		break ;
	case 3:
		Date thedate = today.getTime() ;
		int diffdate = (-1)*thedate.getDay() ;
		today.add(Calendar.DATE,diffdate) ;
		if(movedate.equals("1")) today.add(Calendar.WEEK_OF_YEAR,1) ;
		if(movedate.equals("-1")) today.add(Calendar.WEEK_OF_YEAR,-1) ;
		today.add(Calendar.DATE,1);
		break;
	case 4:
		if(movedate.equals("1")) today.add(Calendar.DATE,1) ;
		if(movedate.equals("-1")) today.add(Calendar.DATE,-1) ;
		break;
}

currentyear=today.get(Calendar.YEAR);
currentmonth=today.get(Calendar.MONTH)+1;  
currentday=today.get(Calendar.DATE); 

currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;
temptoday1.set(currentyear,currentmonth-1,currentday) ;
temptoday2.set(currentyear,currentmonth-1,currentday) ;

calendar.set(currentyear, currentmonth - 1, currentday);
calendar.add(Calendar.MONTH, 1);
calendar.set(Calendar.DATE, 1);
calendar.add(Calendar.DATE, -1);
int daysOfThisMonth = calendar.get(Calendar.DATE);


switch (bywhat) {
	case 1 :
		today.add(Calendar.YEAR,1) ;
		break ;
	case 2:
		today.add(Calendar.MONTH,1) ;
		break ;
	case 3:
		today.add(Calendar.WEEK_OF_YEAR,1) ;
		break;
	case 4:
		today.add(Calendar.DATE,1) ;
		break;
}

currentyear=today.get(Calendar.YEAR);
currentmonth=today.get(Calendar.MONTH)+1;  
currentday=today.get(Calendar.DATE);  


String currenttodate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;
String 	currentWeekEnd = "";
String datenow = "" ;
String cBeginDate="";
String cEndDate="";

switch (bywhat) {
	case 1 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4) ;
		break ;
	case 2 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;
		cBeginDate = TimeUtil.getMonthBeginDay(currentdate);
		cEndDate = TimeUtil.getMonthEndDay(currentdate);
		break ;
 	case 3 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		cBeginDate = TimeUtil.getWeekBeginDay(currentdate);
		cEndDate = TimeUtil.getWeekEndDay(currentdate);
		break ;
	case 4 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		cBeginDate = currentdate;
		cEndDate = currentdate;
		break ;
}
String resourceID="";
if("1".equals(objType)){//部门
	if("".equals(objIds)){
		//objIds=user.getUserDepartment()<=0?"":""+user.getUserDepartment();
	}
	if(!"".equals(objIds)){
		if(Util.getIntValue(objIds)>-1){
			rs.executeSql("select id from HrmResource where status in ( 0,1,2,3 ) and departmentid="+objIds+" ORDER BY dsporder");
		}else{
			rs.executeSql("select id from HrmResource where status in ( 0,1,2,3 ) and id in (select resourceid from HrmResourceVirtual where departmentid="+objIds+") ORDER BY dsporder");
		}
	}else{
		rs.executeSql("select id from HrmResource where 1=2");
	}
	
}else if("2".equals(objType)){//分部
	if("".equals(objIds)){
		//objIds=user.getUserSubCompany1()<=0?"":""+user.getUserSubCompany1();
	}
	if(!"".equals(objIds)){
		if(Util.getIntValue(objIds)>-1){
			rs.executeSql("select id from HrmResource where status in ( 0,1,2,3 ) and subcompanyid1="+objIds+" ORDER BY dsporder");
		}else{
			rs.executeSql("select id from HrmResource where status in ( 0,1,2,3 ) and id in(select resourceid from HrmResourceVirtual where subcompanyid="+objIds+") ORDER BY dsporder");
		}
	}else{
		rs.executeSql("select id from HrmResource where 1=2");
	}
}else if("3".equals(objType)){//人力资源
	if("".equals(objIds)){
		//objIds=user.getUID()<=0?"":""+user.getUID();
	}
	if(!"".equals(objIds)){
		String[] objs=objIds.split(",");
		for(int i=0;i<objs.length;i++){
			if("".equals(objs[i])) continue;
			resourceID+="".equals(resourceID)?objs[i]:","+objs[i];
		}
		rs.executeSql("select id,dsporder from HrmResource where id in("+resourceID+")  UNION select id,9999 as dsporder from HrmResourceManager where id in("+resourceID+") ORDER BY dsporder");
	}else{
		rs.executeSql("select id from HrmResource where 1=2");
	}
}
resourceID="";
String rname="";
while(rs.next()){
	resourceID+="".equals(resourceID)?rs.getString("id"):","+rs.getString("id");
}
String[] resourceIDs=resourceID.split(",");
//get the mapping from the select type
Map<String,Map<String,Map<String,List<WorkPlanViewBean>>>> resultMap= wpvList.getMapping(resourceIDs,cBeginDate,cEndDate,user,wpSetInfo,workType);
//out.println(JSONArray.fromObject(resultMap).toString());
boolean amAndPm=wpSetInfo.getAmAndPm()==1;
String showInfo=wpSetInfo.getShowInfo();
String tooltipInfo=wpSetInfo.getTooltipInfo();
String[] showInfos=showInfo.split("\\^");
String[] tooltipInfos=tooltipInfo.split("\\^");
Map<String,Map<String,List<WorkPlanViewBean>>> personMap=null;
Map<String,List<WorkPlanViewBean>> dateMap=null;
List<WorkPlanViewBean> amList=null;
List<WorkPlanViewBean> pmList=null;
String temp_date="";
WorkPlanViewBean bean=null;
String str="";
%>
			<input type="hidden" name="datenow" id="datenow" value="<%=datenow%>" />
			
			<% if(bywhat==2) {%>
  				<!--========== 月报表 ============-->
  				 
  				<div id="tableDataDiv" style="overflow: auto;position: relative;">
				<table class=M1 width="<%=100+135*daysOfThisMonth %>px;" border=0 cellspacing=0 cellpadding=0 Style="font-size:8pt;table-layout:fixed">
				    <COLGROUP>
						<col width="100">
						<col width="">
				    <tr  class="thbgc">
				    	<td class="schtd" align=center style="background:#f7f7f7;BORDER-left: 1px solid #d0d0d0;height:25px; ">
							<%=wpSetInfo.getDataRule()==1?SystemEnv.getHtmlLabelName(882, user.getLanguage()):SystemEnv.getHtmlLabelName(15525, user.getLanguage()) %>
						</td>
						<%if(amAndPm){ %>
						<td class="thcls" align=center style="width:35px;BORDER-left: 0px solid #d0d0d0;">
							&nbsp;
						</td>
						<%} %>
						<%for(int i=0;i<daysOfThisMonth;i++){
							if(i==0){%>
							<td class="thcls" style="BORDER-left: 1px solid #d0d0d0;" width="135px;" align=center><span class="weekclass" val="<%=TimeUtil.dateAdd(cBeginDate,i)%>"></span></td>
							<%}else{ %>
							<td class="thcls" style="BORDER-left: 0px solid #d0d0d0;" width="135px;" align=center><span class="weekclass" val="<%=TimeUtil.dateAdd(cBeginDate,i)%>"></span></td>
						<%	  }
						   }%>
				    </tr>
				   <% 			
				    for(int k=0;k<resourceIDs.length;k++){
				    	resourceID= resourceIDs[k];
				    	if(!resultMap.containsKey(resourceID)) continue;
				    	rname=ResourceComInfo.getLastname(resourceID);	
				    	personMap=resultMap.get(resourceID);
				   %>
				        <tr style="<%=amAndPm?"height:30px":"" %>">
								<td class="roomnames" rowspan="<%=amAndPm?2:1 %>" style="line-height:<%=amAndPm?60:30 %>px;"><div class="tdtxt" title="<%=rname%>">
								<a href="javaScript:openhrm('<%=resourceID %>');" onclick="pointerXY(event);"><%=rname%></a>
								</div></td>
					        <%					        
					        
					        if(amAndPm){
					        %>
					        	<td align=center style="width:35px;BORDER-left: 1px solid #d0d0d0;"><%=user.getLanguage()==8?"AM":SystemEnv.getHtmlLabelName(16689, user.getLanguage()) %></td>
					        <%	for (int p=0 ;p<daysOfThisMonth;p++) {
					        		str="";
					        		temp_date=TimeUtil.dateAdd(cBeginDate,p);
					        		if(personMap!=null){
					        			if(personMap.containsKey(temp_date)){
						        			dateMap=personMap.get(temp_date);
						        			if(dateMap.containsKey(WorkPlanViewList.AM)){
						        				amList=dateMap.get(WorkPlanViewList.AM);
						        				if(amList!=null){
						        					for(int z=0;z<amList.size();z++){
							        					bean=amList.get(z);
							        					str+=getItemDiv(bean,showInfos,tooltipInfos,ResourceComInfo,z+1==amList.size(),user.getLanguage());
							        				}
						        				}
						        				out.println("<td class='tdcls' style=\'color:#fff;vertical-align: text-bottom;\'>"+str+"</td>");
						        			}else{
						        				out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
						        			}
						        		}else{
						        			out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
						        		}
					        		}else{
					        			out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
					        		}
					        	}
					        	out.println("</tr><tr style='height:30px;'><td align=center style=\"width:35px;BORDER-left: 1px solid #d0d0d0;\">"+(user.getLanguage()==8?"PM":SystemEnv.getHtmlLabelName(16690, user.getLanguage()))+"</td>");
					        	for (int p=0 ;p<daysOfThisMonth;p++) {
					        		str="";
					        		temp_date=TimeUtil.dateAdd(cBeginDate,p);
					        		if(personMap!=null){
					        			if(personMap.containsKey(temp_date)){
						        			dateMap=personMap.get(temp_date);
						        			if(dateMap.containsKey(WorkPlanViewList.PM)){
						        				pmList=dateMap.get(WorkPlanViewList.PM);
						        				if(pmList!=null){
						        					for(int z=0;z<pmList.size();z++){
							        					bean=pmList.get(z);
							        					str+=getItemDiv(bean,showInfos,tooltipInfos,ResourceComInfo,z+1==pmList.size(),user.getLanguage());
							        				}
						        				}
						        				out.println("<td class='tdcls' style=\'color:#fff;vertical-align: text-bottom;\'>"+str+"</td>");
						        			}else{
						        				out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
						        			}
						        		}else{
						        			out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
						        		}
					        		}else{
					        			out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
					        		}
					        	}
					        }else{
					        	for (int p=0 ;p<daysOfThisMonth;p++) {
					        		str="";
					        		temp_date=TimeUtil.dateAdd(cBeginDate,p);
					        		if(personMap!=null){
					        			if(personMap.containsKey(temp_date)){
						        			dateMap=personMap.get(temp_date);
						        			if(dateMap.containsKey(WorkPlanViewList.AM)){
						        				amList=dateMap.get(WorkPlanViewList.AM);
						        				for(int z=0;z<amList.size();z++){
						        					bean=amList.get(z);
						        					str+=getItemDiv(bean,showInfos,tooltipInfos,ResourceComInfo,z+1==amList.size(),user.getLanguage());
						        				}
						        				out.println("<td class='tdcls' style=\'color:#fff;vertical-align: text-bottom;\'>"+str+"</td>");
						        			}else{
						        				out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
						        			}
						        		}else{
						        			out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
						        		}
					        		}else{
					        			out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
					        		}
					        	}	 
					        }			
                            %>
						</tr>
				   
					<%  }%>	
				</table>
				</div>
			<%}%>
			
			<% if(bywhat==3||bywhat==4) {
				int day=bywhat==3?7:1;
			%>
				<!--===========日/周报表 ===========-->
				<table class=M1 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
				   <COLGROUP>
						<col width="100">
						<col width="">
				    <tr  class="thbgc">
				    	<td class="schtd" align=center style="background:#f7f7f7;BORDER-left: 1px solid #d0d0d0;height:25px; ">
							<%=wpSetInfo.getDataRule()==1?SystemEnv.getHtmlLabelName(882, user.getLanguage()):SystemEnv.getHtmlLabelName(15525, user.getLanguage()) %>
						</td>
						<%if(amAndPm){ %>
						<td class="thcls" align=center style="width:35px;BORDER-left: 0px solid #d0d0d0;">
							&nbsp;
						</td>
						<%} %>
						<%for(int i=0;i<day;i++){%>
							<%if(i == 0) { %>
								<td class="thcls" style="BORDER-left: 1px solid #d0d0d0;" align=center><span class="weekclass" val="<%=TimeUtil.dateAdd(cBeginDate,i)%>"></span>
								</td>
							<%}else{%>
								<td class="thcls" style="BORDER-LEFT: 0px solid #d0d0d0;" align=center><span class="weekclass" val="<%=TimeUtil.dateAdd(cBeginDate,i)%>"></span>
								</td>
							<%}%>
							
						<%}%>
				    </tr>
				    </table>
				   <div id="tableDataDiv" style="overflow-y: auto;position: relative;width:100%">
				  <table class=M1 width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
				    <COLGROUP>
						<col width="100">
						<col width="">  
				   <% 			
				   for(int k=0;k<resourceIDs.length;k++){
				    	resourceID= resourceIDs[k];
				    	if(!resultMap.containsKey(resourceID)) continue;
				    	rname=ResourceComInfo.getLastname(resourceID);	
				    	personMap=resultMap.get(resourceID);
				   %>
				        <tr style="<%=amAndPm?"height:30px":"" %>">
								<td class="roomnames" rowspan="<%=amAndPm?2:1 %>" style="line-height:<%=amAndPm?60:30 %>px;"><div class="tdtxt" title="<%=rname%>">
								<a href="javaScript:openhrm('<%=resourceID %>');" onclick="pointerXY(event);"><%=rname%></a>
								</div></td>
					        <%					        
					        
					        if(amAndPm){
					        %>
					        	<td align=center style="width:35px;BORDER-left: 1px solid #d0d0d0;"><%=user.getLanguage()==8?"AM":SystemEnv.getHtmlLabelName(16689, user.getLanguage()) %></td>
					        <%	for (int p=0 ;p<day;p++) {
					        		str="";
					        		temp_date=TimeUtil.dateAdd(cBeginDate,p);
					        		if(personMap!=null){
					        			if(personMap.containsKey(temp_date)){
						        			dateMap=personMap.get(temp_date);
						        			if(dateMap.containsKey(WorkPlanViewList.AM)){
						        				amList=dateMap.get(WorkPlanViewList.AM);
						        				if(amList!=null){
						        					for(int z=0;z<amList.size();z++){
							        					bean=amList.get(z);
							        					str+=getItemDiv(bean,showInfos,tooltipInfos,ResourceComInfo,z+1==amList.size(),user.getLanguage());
							        				}
						        				}
						        				out.println("<td class='tdcls' style=\'color:#fff;vertical-align: text-bottom;\'>"+str+"</td>");
						        			}else{
						        				out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
						        			}
						        		}else{
						        			out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
						        		}
					        		}else{
					        			out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
					        		}
					        	}
					        	out.println("</tr><tr style='height:30px;'><td align=center style=\"width:35px;BORDER-left: 1px solid #d0d0d0;\">"+(user.getLanguage()==8?"PM":SystemEnv.getHtmlLabelName(16690, user.getLanguage()))+"</td>");
					        	for (int p=0 ;p<day;p++) {
					        		str="";
					        		temp_date=TimeUtil.dateAdd(cBeginDate,p);
					        		if(personMap!=null){
					        			if(personMap.containsKey(temp_date)){
						        			dateMap=personMap.get(temp_date);
						        			if(dateMap.containsKey(WorkPlanViewList.PM)){
						        				pmList=dateMap.get(WorkPlanViewList.PM);
						        				if(pmList!=null){
						        					for(int z=0;z<pmList.size();z++){
							        					bean=pmList.get(z);
							        					str+=getItemDiv(bean,showInfos,tooltipInfos,ResourceComInfo,z+1==pmList.size(),user.getLanguage());
							        				}
						        				}
						        				out.println("<td class='tdcls' style=\'color:#fff;vertical-align: text-bottom;\'>"+str+"</td>");
						        			}else{
						        				out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
						        			}
						        		}else{
						        			out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
						        		}
					        		}else{
					        			out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
					        		}
					        	}
					        }else{
					        	for (int p=0 ;p<day;p++) {
					        		str="";
					        		temp_date=TimeUtil.dateAdd(cBeginDate,p);
					        		if(personMap!=null){
					        			if(personMap.containsKey(temp_date)){
						        			dateMap=personMap.get(temp_date);
						        			if(dateMap.containsKey(WorkPlanViewList.AM)){
						        				amList=dateMap.get(WorkPlanViewList.AM);
						        				for(int z=0;z<amList.size();z++){
						        					bean=amList.get(z);
						        					str+=getItemDiv(bean,showInfos,tooltipInfos,ResourceComInfo,z+1==amList.size(),user.getLanguage());
						        				}
						        				out.println("<td class='tdcls' style=\'color:#fff;vertical-align: text-bottom;\'>"+str+"</td>");
						        			}else{
						        				out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
						        			}
						        		}else{
						        			out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
						        		}
					        		}else{
					        			out.println("<td class='tdcls' style=\'color:#fff\'>&nbsp;</td>");
					        		}
					        	}
					        	
					        	
					        	 
					        }			
                            %>
						</tr>
				   
						<%  }%>
					</table>
				</div>
			<%}%>


<script language=javascript>

function afterLoadDate(){
	var bywhat = $GetEle("bywhat").value
	var cBeginDate="<%=cBeginDate%>";
	var cEndDate="<%=cEndDate%>";
	var showtime = "";
	var titletime=""; 
	
	<% if(bywhat==2) {%>
		//titletime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))), new Date(Date.parse(cEndDate.replace(/-/g,   "/"))));
		titletime = CalDateShowMonth(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))));
		showtime = titletime;
		$(".weekclass").each(function(){
			var dateStr = new Date(Date.parse($(this).attr("val").replace(/-/g,   "/")));
			$(this).html(dateFormat.call(dateStr, getymformat(dateStr, null, null, true,null, false)));
		});
	<% }else if(bywhat==3){%>
	    //titletime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))), new Date(Date.parse(cEndDate.replace(/-/g,   "/"))), null, true);
	    showtime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))), new Date(Date.parse(cEndDate.replace(/-/g,   "/"))));
		$(".weekclass").each(function(){
			var dateStr = new Date(Date.parse($(this).attr("val").replace(/-/g,   "/")));
			$(this).html(dateFormat.call(dateStr, getymformat(dateStr, null, null, true,null, false)));
		});
	<% }else if(bywhat==4){%>
		//titletime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))), null, null, true)+"&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>";
		showtime = CalDateShow(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))));
		$(".weekclass").each(function(){
			var dateStr = new Date(Date.parse($(this).attr("val").replace(/-/g,   "/")));
			$(this).html(dateFormat.call(dateStr, getymformat(dateStr, null, null, true,null, false)));
		});
	<%}%>
	
	<% String titlestrnow=""; 
	if(bywhat==2) {
		titlestrnow =SystemEnv.getHtmlLabelName( 15541 ,user.getLanguage());
	}else if(bywhat==3){
		titlestrnow=SystemEnv.getHtmlLabelName( 15539 ,user.getLanguage());
	}else if(bywhat==4){
		titlestrnow=SystemEnv.getHtmlLabelName( 15537 ,user.getLanguage()); 
	}%>
	$("#showtodaybtn").attr("title","<%=titlestrnow%>");
	
	

	$("#movedate").val("");
	$("#currentdate").val("<%=currentdate%>");
	$(".thcls").css("border-top","1px solid #d0d0d0");
	$(".schtd").css("border-top","1px solid #d0d0d0");
	$(".thcls").css("border-bottom","1px solid #59b0f2");
	$(".schtd").css("border-bottom","1px solid #59b0f2");
	$(".schtd").css("border-left","0px");
	$(".roomnames").css("border-left","0px");
	$("#txtdatetimeshow").text(showtime);
	setWindowSize(bywhat);
}

</script>


