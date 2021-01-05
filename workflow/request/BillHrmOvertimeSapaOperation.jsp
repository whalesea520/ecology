<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.MathUtil"%>
<%@ page import="weaver.file.FileUpload" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>


<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>


<%
FileUpload fu = new FileUpload(request);
String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));

if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}



RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(isbill) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
RequestManager.setRequest(fu) ;
RequestManager.setUser(user) ;
RequestManager.setMessageType(messageType) ;

boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;


/**/
if(("1").equals(iscreate)){


    int resourceid=0;
    String fromdate="";
    String fromtime="";
	String tilldate="";
    String tilltime="";
    String fromdatetime="";
    String tilldatetime="";

    long timeInterval=0;
    double totalhours=0.0;
    double weekhours=0.0;
    double weekendhours=0.0;
    double holidayhours=0.0;

	//根据requestid查找fromdate、fromtime、tilldate、tilltime信息

    rs.executeSql(" select  resourceid,fromdate,fromtime,tilldate,tilltime from Bill_HrmOvertimeSapa where requestid= "+requestid );
    
    while( rs.next() ) {

        resourceid = rs.getInt("resourceid")  ;
        fromdate = Util.null2String( rs.getString("fromdate") ) ;
        fromtime = Util.null2String( rs.getString("fromtime") ) ;
        tilldate = Util.null2String( rs.getString("tilldate") ) ;
        tilltime = Util.null2String( rs.getString("tilltime") ) ;
    }    	
    //根据fromdate、fromtime、tilldate、tilltime计算totalhours、weekhours、weekendhours、holidayhours的值
    fromdatetime=fromdate+" "+fromtime+":00";
    tilldatetime=tilldate+" "+tilltime+":00";

    timeInterval=TimeUtil.timeInterval(fromdatetime,tilldatetime);
    totalhours=(double)timeInterval*1.0/3600;
    totalhours=MathUtil.round(totalhours,2);

    //针对每一天遍历如下:
	String currentDate="";
	String nextDate="";
    String isHoliday="false";
	String isWeekend="false";
    String hasReachTillDate="false";
    String isHolidaySql="";

	for(currentDate=fromdate;hasReachTillDate.equals("false");){

        isHoliday="false";
        isWeekend="false";

        if(currentDate.equals(tilldate)){
			hasReachTillDate="true";
		}

        isHolidaySql="select id from HrmPubHoliday where countryid="+user.getCountryid()+" and holidaydate='"+currentDate+"' and changetype=1";

        rs.executeSql(isHolidaySql);
        while( rs.next() ) {
			isHoliday="true";
        }  

        if(isHoliday.equals("false")){//如果当前日期不为假日，判断是否周末才有意义
		    //如果个人有排班,则不为休息日
            rs.executeSql("select id  from HrmArrangeShiftInfo where resourceid="+resourceid+" and shiftdate='"+currentDate+"'");
            if( rs.next() ) {
			    isWeekend="false";
            }else{
				//如果为调配工作日,则isWeekend="false"
				rs.executeSql("select id  from HrmPubHoliday where countryid=1 and holidaydate='"+currentDate+"' and changetype=2");
				if( rs.next() ){
					isWeekend="false";
				}else{
					//如果为调配休息日,则isWeekend="true"
					rs.executeSql("select id  from HrmPubHoliday where countryid=1 and holidaydate='"+currentDate+"' and changetype=3");
					if(rs.next()){
						isWeekend="true";
					}else{
						//通过HrmSchedule判断是否为休息日
                        String monstarttime1 = "" ; 
                        String monendtime1 = "" ; 
                        String monstarttime2 = "" ; 
                        String monendtime2 = "" ;  

                        String tuestarttime1 = "" ; 
                        String tueendtime1 = "" ; 
                        String tuestarttime2 = "" ;  
                        String tueendtime2 = "" ; 

                        String wedstarttime1 = "" ;  
                        String wedendtime1 = "" ; 
                        String wedstarttime2 = "" ; 
                        String wedendtime2 = "" ; 

                        String thustarttime1 = "" ; 
                        String thuendtime1 = "" ; 
                        String thustarttime2 = "" ; 
                        String thuendtime2 = "" ;  

                        String fristarttime1 = "" ; 
                        String friendtime1 = "" ; 
                        String fristarttime2 = "" ; 
                        String friendtime2 = "" ; 

                        String satstarttime1 = "" ; 
                        String satendtime1 = "" ; 
                        String satstarttime2 = "" ; 
                        String satendtime2 = "" ; 

                        String sunstarttime1 = "" ; 
                        String sunendtime1 = "" ; 
                        String sunstarttime2 = "" ; 
                        String sunendtime2 = "" ; 

                        List weekrestdays = new ArrayList() ;
                        rs.executeSql("select * from HrmSchedule where validedatefrom <='"+currentDate+"' and validedateto >='"+currentDate+"'") ;
						if(rs.next()){
							monstarttime1 = Util.null2String(rs.getString("monstarttime1")) ;
                            monendtime1 = Util.null2String(rs.getString("monendtime1")) ;
                            monstarttime2 = Util.null2String(rs.getString("monstarttime2")) ;
                            monendtime2 = Util.null2String(rs.getString("monendtime2")) ;

                            tuestarttime1 = Util.null2String(rs.getString("tuestarttime1")) ;
                            tueendtime1 = Util.null2String(rs.getString("tueendtime1")) ;
                            tuestarttime2 = Util.null2String(rs.getString("tuestarttime2")) ;
                            tueendtime2 = Util.null2String(rs.getString("tueendtime2")) ;

                            wedstarttime1 = Util.null2String(rs.getString("wedstarttime1")) ;
                            wedendtime1 = Util.null2String(rs.getString("wedendtime1")) ;
                            wedstarttime2 = Util.null2String(rs.getString("wedstarttime2")) ;
                            wedendtime2 = Util.null2String(rs.getString("wedendtime2")) ;

                            thustarttime1 = Util.null2String(rs.getString("thustarttime1")) ;
                            thuendtime1 = Util.null2String(rs.getString("thuendtime1")) ;
                            thustarttime2 = Util.null2String(rs.getString("thustarttime2")) ;
                            thuendtime2 = Util.null2String(rs.getString("thuendtime2")) ;

                            fristarttime1 = Util.null2String(rs.getString("fristarttime1")) ;
                            friendtime1 = Util.null2String(rs.getString("friendtime1")) ;
                            fristarttime2 = Util.null2String(rs.getString("fristarttime2")) ;
                            friendtime2 = Util.null2String(rs.getString("friendtime2")) ;

                            satstarttime1 = Util.null2String(rs.getString("satstarttime1")) ;
                            satendtime1 = Util.null2String(rs.getString("satendtime1")) ;
                            satstarttime2 = Util.null2String(rs.getString("satstarttime2")) ;
                            satendtime2 = Util.null2String(rs.getString("satendtime2")) ; 

                            sunstarttime1 = Util.null2String(rs.getString("sunstarttime1")) ;
                            sunendtime1 = Util.null2String(rs.getString("sunendtime1")) ;
                            sunstarttime2 = Util.null2String(rs.getString("sunstarttime2")) ;
                            sunendtime2 = Util.null2String(rs.getString("sunendtime2")) ;
						}

                        if( sunstarttime1.equals("") && sunendtime1.equals("") && sunstarttime2.equals("") && sunendtime2.equals("") )   weekrestdays.add("0") ;
                        if( monstarttime1.equals("") && monendtime1.equals("") && monstarttime2.equals("") && monendtime2.equals("") )   weekrestdays.add("1") ;
                        if( tuestarttime1.equals("") && tueendtime1.equals("") && tuestarttime2.equals("") && tueendtime2.equals("") )   weekrestdays.add("2") ;
                        if( wedstarttime1.equals("") && wedendtime1.equals("") && wedstarttime2.equals("") && wedendtime2.equals("") )   weekrestdays.add("3") ;
                        if( thustarttime1.equals("") && thuendtime1.equals("") && thustarttime2.equals("") && thuendtime2.equals("") )   weekrestdays.add("4") ;
                        if( fristarttime1.equals("") && friendtime1.equals("") && fristarttime2.equals("") && friendtime2.equals("") )   weekrestdays.add("5") ;
                        if( satstarttime1.equals("") && satendtime1.equals("") && satstarttime2.equals("") && satendtime2.equals("") )   weekrestdays.add("6") ;

						if(weekrestdays.indexOf(String.valueOf(TimeUtil.dateWeekday(currentDate)))!= -1){
							isWeekend="true";
						}

					}
				}

			}


		}

		//获取下一日期
		nextDate=TimeUtil.dateAdd(currentDate,1);

		if(("true").equals(isHoliday)){//如果当前日期为节假日

		    if(currentDate.equals(tilldate)){//判断当前日期是否是结束日期,如果当前日期是结束日期
			    if(currentDate.equals(fromdate)){//如果当前日期是开始日期,
				//holidayhours+=结束日期结束时间-开始日期开始时间
                    timeInterval=TimeUtil.timeInterval(fromdatetime,tilldatetime);
                    holidayhours+=MathUtil.round((double)timeInterval*1.0/3600,2);
				}else{//否则,当前日期不是结束日期,holidayhours+=结束日期结束时间-当前日期 00:00:00
                    timeInterval=TimeUtil.timeInterval(currentDate+" "+"00:00:00",tilldatetime);
                    holidayhours+=MathUtil.round((double)timeInterval*1.0/3600,2);
				}
			}else{//如果当前日期不是结束日期
			    if(currentDate.equals(fromdate)){//如果当前日期是开始日期,
				//holidayhours+=下一日期 00:00:00-开始日期开始时间
                    timeInterval=TimeUtil.timeInterval(fromdatetime,nextDate+" "+"00:00:00");
                    holidayhours+=MathUtil.round((double)timeInterval*1.0/3600,2);
				}else{//否则,当前日期不是开始日期,holidayhours+=下一日期 00:00:00-当前日期 00:00:00
                    timeInterval=TimeUtil.timeInterval(currentDate+" "+"00:00:00",nextDate+" "+"00:00:00");
                    holidayhours+=MathUtil.round((double)timeInterval*1.0/3600,2);
				}

			}
		}else if(("true").equals(isWeekend)){//如果当前日期为休息日
		    if(currentDate.equals(tilldate)){//判断当前日期是否是结束日期,如果当前日期是结束日期
			    if(currentDate.equals(fromdate)){//如果当前日期是开始日期,
				//weekendhours+=结束日期结束时间-开始日期开始时间
                    timeInterval=TimeUtil.timeInterval(fromdatetime,tilldatetime);
                    weekendhours+=MathUtil.round((double)timeInterval*1.0/3600,2);
				}else{//否则,当前日期不是结束日期,weekendhours+=结束日期结束时间-当前日期 00:00:00
                    timeInterval=TimeUtil.timeInterval(currentDate+" "+"00:00:00",tilldatetime);
                    weekendhours+=MathUtil.round((double)timeInterval*1.0/3600,2);
				}
			}else{//如果当前日期不是结束日期
			    if(currentDate.equals(fromdate)){//如果当前日期是开始日期,
				//weekendhours+=下一日期 00:00:00-开始日期开始时间
                    timeInterval=TimeUtil.timeInterval(fromdatetime,nextDate+" "+"00:00:00");
                    weekendhours+=MathUtil.round((double)timeInterval*1.0/3600,2);
				}else{//否则,当前日期不是结束日期,weekendhours+=下一日期 00:00:00-当前日期 00:00:00
                    timeInterval=TimeUtil.timeInterval(currentDate+" "+"00:00:00",nextDate+" "+"00:00:00");
                    weekendhours+=MathUtil.round((double)timeInterval*1.0/3600,2);
				}

			}
		}
		
		currentDate=nextDate;
	}

    weekhours=totalhours-holidayhours-weekendhours;

	//向数据库更新totalhours、weekhours、weekendhours、holidayhours字段的值

    rs.executeSql(" update  Bill_HrmOvertimeSapa set totalhours="+totalhours+",weekhours="+weekhours+",weekendhours="+weekendhours+",holidayhours="+holidayhours+" where requestid= "+requestid );


}


weaver.general.DateUtil DateUtil=new weaver.general.DateUtil();
if(DateUtil.isCurrendUserid(""+requestid,""+user.getUID())){
	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1');</script>");
}else{
	 out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
}

 



%>