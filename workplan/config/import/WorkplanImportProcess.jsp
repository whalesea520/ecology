
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell" %>
<%@ page import="java.io.FileNotFoundException" %>
<%@ page import="java.io.IOException" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem" %>
<%@ page import="weaver.general.TimeUtil,weaver.WorkPlan.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="workPlanShare" class="weaver.WorkPlan.WorkPlanShare" scope="page"/>
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="wpSetInfo" class="weaver.WorkPlan.WorkPlanSetInfo" scope="page" />
<%!
private String getExcelColumnLabel(int num) {
	String temp = "";
	double i = Math.floor(Math.log(25.0 * (num) / 26.0 + 1) / Math.log(26)) + 1;
	if (i > 1) {
		double sub = num - 26 * (Math.pow(26, i - 1) - 1) / 25;
		for (double j = i; j > 0; j--) {
			temp = temp + (char) (sub / Math.pow(26, j - 1) + 65);
			sub = sub % Math.pow(26, j - 1);
		}
	} else {
		temp = temp + (char) (num + 65);
	}
	return temp;
}
%>
<%


    FileUploadToPath fu = new FileUploadToPath(request) ;
    String filename = fu.uploadFiles("excelfile");
    String remindBeforeStart = Util.null2String(fu.getParameter("remindBeforeStart"));  //是否开始前提醒
    String remindTimeBeforeStart =      Util.null2String(fu.getParameter("remindTimeBeforeStart"));
    int remindDateBeforeEnd =      Util.getIntValue(fu.getParameter("remindDateBeforeEnd"),0);
    String remindTimeBeforeEnd =  Util.null2String(fu.getParameter("remindTimeBeforeEnd")) ;
    String remindBeforeEnd = Util.null2String(fu.getParameter("remindBeforeEnd"));  //是否结束前提醒
    String remindDateBeforeStart =  Util.null2String(fu.getParameter("remindDateBeforeStart"));
    String workPlanType =  Util.null2String(fu.getParameter("keyField"));  //日程类型
    String remindType =  Util.null2String(fu.getParameter("remindType"));
    String validateType=  Util.null2String(fu.getParameter("validateType"));//验证类型
    String message = "";
    String coutt = "";
    int total=0;
	String sys_begintime=(wpSetInfo.getTimeRangeStart()<10?"0"+wpSetInfo.getTimeRangeStart():wpSetInfo.getTimeRangeStart())+":00";
	String sys_endtime=(wpSetInfo.getTimeRangeEnd()<10?"0"+wpSetInfo.getTimeRangeEnd():wpSetInfo.getTimeRangeEnd())+":59";
	int userId=user.getUID();
	String today=TimeUtil.getCurrentDateString();
	String[] logParams;
	WorkPlanLogMan workPlanLogMan = new WorkPlanLogMan();
    try {
        boolean fff = false;
    // 创建对Excel工作簿文件的引用?

	    HSSFWorkbook wookbook = new HSSFWorkbook(new POIFSFileSystem(new FileInputStream(filename)));
	    // 在Excel文档中，第一张工作表的缺省索引是0
	    // 其语句为：HSSFSheet sheet = workbook.getSheetAt(0);?
	    HSSFSheet sheet = wookbook.getSheetAt(0);
	    //获取到Excel文件中的所有行数?
	    int rows = sheet.getPhysicalNumberOfRows();
	    total=rows-1;
	    //System.out.println("rows:"+rows);
		String reson="";
	    for (int i = 1; i < rows; i++) {
	        // 读取左上端单元格?
	        HSSFRow row = sheet.getRow(i);
	       
	        // 行不为空?
	        if (row != null) {
	        	coutt=""+i;
	            //获取到Excel文件中的所有的列?
	            int cells = row.getPhysicalNumberOfCells();
	            //遍历列?
	            WorkPlan workPlan = new WorkPlan();
	            String beginDate = "";
	            String beginTime = "";
	            String endDate = "";
	            String endTime = "";
	            String memberIDs =    "";
	            String desciption ="";
	            String planName =    "";
	            String  urgentLevel= "";
                Date bd=null;
	            for (short j = 0; j < 8; j++) {
	                //获取到列的值?
	                HSSFCell cell = row.getCell(j);
	                    if(j==0){//标题
	                    	if(cell!=null){
		                        planName = Util.null2String(cell.getStringCellValue());
	                    	}
	                    }else if(j==1){//开始日期
	                    	if(cell!=null){
		                        bd = cell.getDateCellValue() ;
		                    	if(bd==null){
		                    		beginDate=today;
		                    	}else{
			                        beginDate =  TimeUtil.getFormartString(bd,"yyyy-MM-dd") ;
		                    	}
	                    	}else{
	                    		beginDate=today;
	                    	}
	                    } else if(j==2){//开始时间
	                    	if(cell!=null){
		                        bd = cell.getDateCellValue() ;
		                        if(bd!=null){
			                        beginTime =  TimeUtil.getFormartString(bd,"HH:mm") ;
		                        }else{
		                        	beginTime=sys_begintime;
		                        }
	                    	}else{
	                    		beginTime=sys_begintime;
	                    	}
	                    }else if(j==3){//结束日期
	                    	if(cell!=null){
		                        bd = cell.getDateCellValue() ;
		                        if(bd==null){
		                        	endDate=beginDate;
		                    	}else{
		                    		endDate  =TimeUtil.getFormartString(bd,"yyyy-MM-dd") ;
		                    	}
	                        }else{
	                        	endDate=beginDate;
	                        }
	                    }else if(j==4){//结束时间
	                    	if(cell!=null){
		                        bd = cell.getDateCellValue() ;
		                        if(bd!=null){
		                        	endTime =  TimeUtil.getFormartString(bd,"HH:mm") ;
		                        }else{
		                        	endTime=sys_endtime;
		                        }
	                        }else{
	                        	endTime=sys_endtime;
	                        }
	                    }else if(j==5){//接收人
	                    	if(cell!=null){
		                        String resourceids  = Util.null2String(cell.getStringCellValue()) ;
		                        ArrayList<String> memberidArr =  Util.TokenizerString(resourceids,",");
		                        for(int l=0;l<memberidArr.size();l++){
		                        	
		                        	if(validateType.equals("id")){//验证类型为id
				                         if("".equals(memberIDs)){
				                         	memberIDs = memberidArr.get(l).trim();
				                         }else{
				                         	memberIDs += ","+ memberidArr.get(l).trim();
				                         }
		                        	}else{//验证类型为姓名或登录名
		                        		RecordSet.executeSql("select id from hrmresource where "+validateType+" = '"+memberidArr.get(l).trim()+"' ");
		                        		if(RecordSet.next()){
		                        			if("".equals(memberIDs)){
					                         	memberIDs = RecordSet.getString("id");
					                         }else{
					                         	memberIDs += ","+ RecordSet.getString("id");
					                         }
		                        		}
			                        }
		                        }
		                        if("".equals(memberIDs)){
		                        	memberIDs=userId+"";
			                    }
	                        }else{
	                        	memberIDs=userId+"";
	                        }
	                    }else if(j==6){//内容
	                    	if(cell!=null){
		                        desciption=  cell.getStringCellValue() ;
	                    	}else{
	                    		desciption="";
	                    	}
	                    }else if(j==7){//紧急程度
	                    	if(cell!=null){
		                        urgentLevel = String.valueOf((int)cell.getNumericCellValue());
	                    	}else{
	                    		urgentLevel="1";
	                    	}
	                    }
	            }
	            int urgentLevel_int=Util.getIntValue(urgentLevel,1);
	            
	            //校验数据有效性
	            if("".equals(planName)){
	            	message="2";
	            	coutt=""+i;
	            	reson="1";
	                break;
	            }
				if(beginDate.compareTo(endDate)>0){
					message="2";
	            	coutt=""+i;
	            	reson="2";
	                break;
				}
	            if(beginDate.equals(endDate)&&beginTime.compareTo(endTime)>0){
	            	message="2";
	            	coutt=""+i;
	            	reson="3";
	                break;
	            }
				
	
	            workPlan.setWorkPlanName(planName);  //标题
	            workPlan.setUrgentLevel(urgentLevel_int+"");  //紧急程度
	            workPlan.setRemindType(remindType);  //日程提醒方式
	
	
	
	            if(!"".equals(workPlanType) && null != workPlanType)
	            {
	                workPlan.setWorkPlanType(Integer.parseInt(workPlanType));  //日程类型
	            }else{
					workPlanType="0";
		    		workPlan.setWorkPlanType(0);
				}
	
	            if(!"".equals(remindBeforeStart) && null != remindBeforeStart)
	            {
	                workPlan.setRemindBeforeStart(remindBeforeStart);  //是否开始前提醒
	            }else{
					workPlan.setRemindBeforeStart("0");
				}
	            if(!"".equals(remindBeforeEnd) && null != remindBeforeEnd)
	            {
	                workPlan.setRemindBeforeEnd(remindBeforeEnd);  //是否结束前提醒
	            }else{
					workPlan.setRemindBeforeEnd("0");
				}
	
	            if (remindDateBeforeStart != null ) {
	                remindDateBeforeStart = remindDateBeforeStart.trim();
	            }
	            workPlan.setRemindTimesBeforeStart(Util.getIntValue(remindDateBeforeStart,0)*60+Util.getIntValue(remindTimeBeforeStart,0));  //开始前提醒时间
	            workPlan.setRemindTimesBeforeEnd(remindDateBeforeEnd*60+Util.getIntValue(remindTimeBeforeEnd,0));  //结束前提醒时间
	            workPlan.setResourceId(memberIDs);  //系统参与人
	            workPlan.setBeginDate(beginDate);  //开始日期
	            if(!"".equals(beginTime) && null != beginTime)
	            {
	                workPlan.setBeginTime(beginTime);  //开始时间
	            }
	            else
	            {
	            	workPlan.setBeginTime(sys_begintime);  //开始时间
	            }
	            workPlan.setEndDate(endDate);  //结束日期
	            if(endTime!=null&&!"".equals(endTime))
	            {
	                 workPlan.setEndTime(endTime);  //结束时间
	            }
	            else
	            {
	                workPlan.setEndTime(sys_endtime);  //结束时间
	            }
	            workPlan.setDescription(desciption);  //内容
	            workPlan.setCreaterId(userId);
				workPlan.setCreateType(Util.getIntValue(user.getLogintype(),1));
	
	            if(!"".equals(workPlan.getBeginDate()) && null != workPlan.getBeginDate())
	            {
	                List beginDateTimeRemindList = Util.processTimeBySecond(workPlan.getBeginDate(), workPlan.getBeginTime(), workPlan.getRemindTimesBeforeStart() * -1 * 60);
	                workPlan.setRemindDateBeforeStart((String)beginDateTimeRemindList.get(0));  //开始前提醒日期
	                workPlan.setRemindTimeBeforeStart((String)beginDateTimeRemindList.get(1));  //开始前提醒时间
	            }
	            if(!"".equals(workPlan.getEndDate()) && null != workPlan.getEndDate())
	            {
	                List endDateTimeRemindList = Util.processTimeBySecond(workPlan.getEndDate(), workPlan.getEndTime(), workPlan.getRemindTimesBeforeEnd() * -1 * 60);
	                workPlan.setRemindDateBeforeEnd((String)endDateTimeRemindList.get(0));  //结束前提醒日期
	                workPlan.setRemindTimeBeforeEnd((String)endDateTimeRemindList.get(1));  //结束前提醒时间
	            }
	            fff = workPlanService.insertWorkPlan(workPlan);  //插入日程
	            workPlanShare.setDefaultShareDetail(user,String.valueOf(workPlan.getWorkPlanID()),workPlanType);//只在新增的时候设置默认共享
	          //插入日志
		        logParams = new String[]
		        { String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, userId+"", Util.getIpAddr(request) };
		        workPlanLogMan.writeViewLog(logParams);
	            if(fff){
	                message = "1";
	            } else{
	                message = "2";
	                coutt = i+"";
	                break;
	            }
	         }
	    }
        response.sendRedirect("/workplan/config/import/WorkplanImportResult.jsp?reson="+reson+"&total="+(rows-1)+"&message="+message+"&coutt="+coutt);
    } catch (FileNotFoundException e) {
        message = "3";
        e.printStackTrace();
        response.sendRedirect("/workplan/config/import/WorkplanImportResult.jsp?message="+message);
    } catch (IOException e) {
        message = "4";
        e.printStackTrace();
        response.sendRedirect("/workplan/config/import/WorkplanImportResult.jsp?message="+message);
    }catch(NumberFormatException e){
    	message = "2";
    	response.sendRedirect("/workplan/config/import/WorkplanImportResult.jsp?reson=-1&total="+total+"&message="+message+"&coutt="+coutt);
    }catch (Exception e) {
        message = "5";
        e.printStackTrace();
        response.sendRedirect("/workplan/config/import/WorkplanImportResult.jsp?message="+message);
    }




%>


