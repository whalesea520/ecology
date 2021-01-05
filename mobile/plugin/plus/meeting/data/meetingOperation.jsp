<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.general.*"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="weaver.wxinterface.MeetingUtils"%>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.WorkPlan.WorkPlanService" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="weaver.docs.docs.DocImageManager"%>
<%@ page import="weaver.wxinterface.WxModuleInit"%>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%@ page import="weaver.wxinterface.FormatMultiLang"%>
<%@ page import="weaver.wxinterface.Meeting"%>
<%@ page import="weaver.file.Prop"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="MeetingViewer" class="weaver.meeting.MeetingViewer" scope="page"/>
<jsp:useBean id="MeetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="meetingService" class="weaver.mobile.plugin.ecology.service.MeetingService" scope="page"/>
<jsp:useBean id="MeetingTransMethod" class="weaver.meeting.Maint.MeetingTransMethod" scope="page"/>
<%
	int status = 1;String msg = ""; 
	JSONObject json = new JSONObject();
	request.setCharacterEncoding("UTF-8");
	String operate = Util.null2String(request.getParameter("operate"));
	String currentDate = TimeUtil.getCurrentDateString();
	String currentTime = TimeUtil.getOnlyCurrentTimeString();
	String creater = user.getUID()+"";
	try{
		if(operate.equals("getMeetings")){//获取可用会议室列表
			String beginDate = Util.null2String(request.getParameter("beginDate"));
			String endDate = Util.null2String(request.getParameter("endDate"));
			if(!beginDate.equals("")&&!endDate.equals("")
					&&beginDate.length()==16&&endDate.length()==16){
				String sDate = beginDate.substring(0,10);
				String sTime = beginDate.substring(11);
				String eDate = endDate.substring(0,10);
				String eTime = endDate.substring(11);
				JSONArray js = MeetingUtils.getMeetings(sDate, sTime, eDate, eTime, user);
				json.put("js",js);
				json.put("userid", creater);
				json.put("userName", ResourceComInfo.getLastname(creater));
				int roomConflictChk	= 0;//0表示不控制 1表示控制
				int roomConflict	= 0;//1提示不限制 2禁止提交
				rs.executeSql("select roomConflictChk,roomConflict from MeetingSet") ;
				if(rs.next()){
				 	roomConflictChk	= Util.getIntValue(rs.getString("roomConflictChk"),1);
					roomConflict	= Util.getIntValue(rs.getString("roomConflict"), 1);
				}
				json.put("roomConflictChk",roomConflictChk);
				json.put("roomConflict",roomConflict);
				json.put("ifMeetingAddressMulti", WxModuleInit.ifMeetingAddressMulti?1:0);
				json.put("utf8", WxInterfaceInit.isIsutf8()?1:0);
				status = 0;
			}else{
				msg = "日期格式错误";
			}
		}else if(operate.equals("getMeetingType")){//获取会议类型
			if(WxModuleInit.ifMeetingTypeShare){
				 //执行会议类型共享初始化信息开始
			    //String sqll = "select id from meeting_type where id not in(select distinct mtid from MeetingType_share)";
			    //ArrayList<String> noshareids = new ArrayList<String>();
			    //rs.executeSql(sqll);
			    //while(rs.next()){
			    //    noshareids.add(rs.getString("id"));
			    //}
			    //if(noshareids.size()>0){
			    //    for(String idd : noshareids){
			    //    	rs.executeSql("insert into MeetingType_share (mtid,permissiontype,seclevel,seclevelMax) values ("+idd+",3,0,100)"   );
			    //    }
			    //}
			    //执行会议类型共享初始化信息结束
				//是否分权系统，如不是，则不显示框架，直接转向到列表页面
				int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
				int subid=user.getUserSubCompany1();
				if(detachable==1){
				    String subcompanys=SubCompanyComInfo.getSubCompanyTreeStr(""+subid);
				    while(subcompanys.endsWith(",")){
				        subcompanys = subcompanys.substring(0,subcompanys.length()-1);
				    }
				    if(subcompanys.length()>0){
				        String unionSql = "select distinct a.id,a.name,a.subcompanyid,a.desc_n,a.approver from Meeting_Type a,MeetingType_share b where a.subcompanyid in("+subcompanys+","+subid+",0) and   a.id = b.mtid and (((b.departmentid="+
				                user.getUserDepartment()+" and b.deptlevel<="+user.getSeclevel()+" and b.deptlevelMax>="+user.getSeclevel()+") or(b.subcompanyid in ("+
				                user.getUserSubCompany1()+","+user.getUserSubCompany2()+","+user.getUserSubCompany3()+","+user.getUserSubCompany4()+") and b.sublevel<="+user.getSeclevel()+" and b.sublevelMax>="+
				                user.getSeclevel()+")or(b.seclevel<="+ user.getSeclevel()+" and b.seclevelMax>="+user.getSeclevel()+")or(b.userid ="+user.getUID()+"))" +
				                " or ( a.subcompanyid not in("+subcompanys+") and   a.id = b.mtid and ((b.departmentid="+
				                user.getUserDepartment()+ "and b.deptlevel<="+user.getSeclevel()+" and b.deptlevelMax>="+user.getSeclevel()+") or(b.subcompanyid in ("+
				                user.getUserSubCompany1()+","+user.getUserSubCompany2()+","+user.getUserSubCompany3()+","+user.getUserSubCompany4()+") and b.sublevel<="+user.getSeclevel()+
				                " and b.sublevelMax>="+  user.getSeclevel()+")or(b.seclevel<="+ user.getSeclevel()+ "and b.seclevelMax>="+user.getSeclevel()+")or(b.userid ="+user.getUID()+"))) )"+
				                " order by a.id";
				        rs.executeSql(unionSql);
				    }else{
				        String unionSql = "select distinct a.id,a.name,a.subcompanyid,a.desc_n,a.approver from Meeting_Type a,MeetingType_share b where a.subcompanyid in("+subid+",0) and   a.id = b.mtid and (((b.departmentid="+
				                user.getUserDepartment()+" and b.deptlevel<="+user.getSeclevel()+" and b.deptlevelMax>="+user.getSeclevel()+") or(b.subcompanyid in ("+
				                user.getUserSubCompany1()+","+user.getUserSubCompany2()+","+user.getUserSubCompany3()+","+user.getUserSubCompany4()+") and b.sublevel<="+user.getSeclevel()+" and b.sublevelMax>="+
				                user.getSeclevel()+")or(b.seclevel<="+ user.getSeclevel()+" and b.seclevelMax>="+user.getSeclevel()+")or(b.userid ="+user.getUID()+"))" +
				                " or ( a.subcompanyid <>"+user.getUserSubCompany1()+" and   a.id = b.mtid and ((b.departmentid="+
				                user.getUserDepartment()+ "and b.deptlevel<="+user.getSeclevel()+" and b.deptlevelMax>="+user.getSeclevel()+") or(b.subcompanyid in ("+
				                user.getUserSubCompany1()+","+user.getUserSubCompany2()+","+user.getUserSubCompany3()+","+user.getUserSubCompany4()+") and b.sublevel<="+user.getSeclevel()+
				                " and b.sublevelMax>="+  user.getSeclevel()+")or(b.seclevel<="+ user.getSeclevel()+ "and b.seclevelMax>="+user.getSeclevel()+")or(b.userid ="+user.getUID()+"))) )"+
				                " order by a.id";
				        rs.executeSql(unionSql);
				    }
				}else{
				    String sql =  "select distinct a.id,a.name,a.subcompanyid,a.desc_n,a.approver from Meeting_Type a,MeetingType_share b where  a.id = b.mtid and ((b.departmentid="+
				            user.getUserDepartment()+" and b.deptlevel<="+user.getSeclevel()+" and b.deptlevelMax>="+user.getSeclevel()+") or(b.subcompanyid in ("+
				            user.getUserSubCompany1()+","+user.getUserSubCompany2()+","+user.getUserSubCompany3()+","+user.getUserSubCompany4()+") and b.sublevel<="+user.getSeclevel()+" and b.sublevelMax>="+
				            user.getSeclevel()+")or(b.seclevel<="+user.getSeclevel()+"  and b.seclevelMax>="+user.getSeclevel()+")or(b.userid ="+user.getUID()+")) order by a.id";
				    rs.executeSql(sql);
				}
			}else{
				rs.executeSql("select distinct a.id,a.name from Meeting_Type a order by a.id");
			}
			JSONArray js = new JSONArray();
			while(rs.next()){
				String id = Util.null2String(rs.getString("id"));
			    String name = Util.null2String(rs.getString("name"));
			    JSONObject j = new JSONObject();
			    j.put("id",id);
			    j.put("name",name);
			    js.add(j);
			}
			json.put("js",js);
			//zhw20170803 增加获取会议服务数据
			String serviceid = Util.null2String(Prop.getPropValue("QC277738","serviceid"));//客户定制二次开发设置的默认会议服务项目
			JSONArray sItems = new JSONArray();//会议服务列表
			JSONObject item = new JSONObject();//默认需要显示的会议服务
			rs.executeSql("select * from Meeting_Service_Item a order by a.id");
			int i = 0;
			while(rs.next()){
				String id = Util.null2String(rs.getString("id"));
			    String itemname = Util.null2String(rs.getString("itemname"));
			    String hrmids = Util.null2String(rs.getString("hrmids"));
			    if(hrmids.equals("")){
			    	hrmids = user.getUID()+"";
			    }
			    JSONObject j = new JSONObject();
			    j.put("id",id);
			    j.put("itemname",itemname);
			    j.put("hrmids",hrmids);
			    j.put("hrmNames",getHrmNames(hrmids));
			    sItems.add(j);
			    if((serviceid.equals("")&&i==0)||id.equals(serviceid)){//没有设置默认展示的会议服务的话,取第一个
			    	item = j;
			    }
			    i++;
			}
			json.put("sItems",sItems);
			json.put("item",item);
			//zhw 20170810增加获取是否限制会议创建时间
			int maxDay = Util.getIntValue(Prop.getPropValue("QC303688_meeting","maxday"),0);//客户定制二次开发限制会议创建时间
			json.put("maxDay",maxDay);
			status = 0;
		}else if(operate.equals("saveMeeting")){//保存会议
			String address = Util.null2String(request.getParameter("address"));//会议地点
			String meetingtype = Util.null2String(request.getParameter("meetingtype"));//会议类型
			String name = Util.null2String(request.getParameter("name"));//会议名称
			String hrmids02 = Util.null2String(request.getParameter("hrmids02"));//参与人
			String contacter = Util.null2String(request.getParameter("contacter"));//联系人
			String sDate = Util.null2String(request.getParameter("beginDate"));//会议开始时间
			String eDate = Util.null2String(request.getParameter("endDate"));//会议结束时间
			String desc = Util.null2String(request.getParameter("desc"));//会议内容
			if(!"".equals(address)&&!"".equals(meetingtype)&&!"".equals(name)
					&&!"".equals(hrmids02)&&!"".equals(sDate)&&!"".equals(eDate)){
				if(sDate.length()==16&&eDate.length()==16){
					String beginDate = sDate.substring(0,10);//会议开始日期
					String beginTime = sDate.substring(11);//会议开始时间
					String endDate = eDate.substring(0,10);//会议结束日期
					String endTime = eDate.substring(11);//会议结束时间
					String caller = user.getUID()+"";//召集人
					//项目ID,备注,其他参会人员,自定义会议地点
					String projectid="",othermembers="",customizeAddress="";
					String addressdesc = "",description = "";
					String totalmember = "0";
					int remindType = 1;//提醒方式
					int remindBeforeStart =0;  //是否开始前提醒
					int remindBeforeEnd = 0;  //是否结束前提醒
				    int remindTimesBeforeStart = 0;//开始前提醒时间
				    int remindTimesBeforeEnd = 0;//结束前提醒时间
				    
				    boolean canSave = false;
				    int roomConflictChk	= 0;//0表示不控制 1表示控制
					int roomConflict	= 0;//1提示不限制 2禁止提交
					rs.executeSql("select roomConflictChk,roomConflict from MeetingSet") ;
					if(rs.next()){
					 	roomConflictChk	= Util.getIntValue(rs.getString("roomConflictChk"),1);
						roomConflict	= Util.getIntValue(rs.getString("roomConflict"), 1);
					}
					if(roomConflictChk==1&&roomConflict==2){//会议室冲突禁止提交
						if(WxModuleInit.ifMeetingAddressMulti){
							String[] addresses = address.split(",");
							for(String a:addresses){
								if(!"".equals(a)){
									canSave = false;
									Meeting m = MeetingUtils.getMeetingsById(Util.getIntValue(a,0), name, 
											beginDate, beginTime, endDate, endTime);
									if(null!=m&&m.getIfConflict()==1){//存在冲突的会议室
										break;
									}
									canSave = true;
								}
							}
						}else{
							Meeting m = MeetingUtils.getMeetingsById(Util.getIntValue(address,0), name, 
									beginDate, beginTime, endDate, endTime);
							if(null==m||m.getIfConflict()==0){
								canSave = true;
							}
						}
					}else{
						canSave = true;
					}
					if(canSave){
						char flag = 2;
					    String ProcPara = "";
					    String Sql="";
					    String CurrentUser = ""+user.getUID();
					    if(contacter.equals("")){
					    	contacter = creater;
					    }
					    description = "您有会议: "+name+"   会议时间:"+sDate+" 会议地点:"
					    	+MeetingRoomComInfo.getMeetingRoomInfoname(""+address)+customizeAddress;
					    ProcPara =  meetingtype;
						ProcPara += flag + name;
						ProcPara += flag + caller;
						ProcPara += flag + contacter;
						ProcPara += flag + projectid; //加入项目id
						ProcPara += flag + address;
						ProcPara += flag + beginDate;
						ProcPara += flag + beginTime;
						ProcPara += flag + endDate;
						ProcPara += flag + endTime;
						ProcPara += flag + desc;
						ProcPara += flag + CurrentUser;
						ProcPara += flag + currentDate;
						ProcPara += flag + currentTime;
					    ProcPara += flag + totalmember;
					    ProcPara += flag + othermembers;
					    ProcPara += flag + addressdesc;
					    ProcPara += flag + description;
					    ProcPara += flag + ""+remindType;
					    ProcPara += flag + ""+remindBeforeStart;
					    ProcPara += flag + ""+remindBeforeEnd;
					    ProcPara += flag + ""+remindTimesBeforeStart;
					    ProcPara += flag + ""+remindTimesBeforeEnd;
					    ProcPara += flag + customizeAddress;
					    if (rs.getDBType().equals("oracle")){
							rs.executeProc("Meeting_Insert",ProcPara);
							rs.executeProc("Meeting_SelectMaxID","");
						}else{
							rs.executeProc("Meeting_Insert",ProcPara);
						}
						rs.next();
						String MaxID = rs.getString(1);
						
						int roomType = 1;
						int repeatType = Util.getIntValue(request.getParameter("repeatType"),0);//是否是重复会议,0 正常会议.
						//重复策略字段
						int repeatdays = Util.getIntValue(request.getParameter("repeatdays"),0);
						int repeatweeks = Util.getIntValue(request.getParameter("repeatweeks"),0);
						String rptWeekDays=Util.null2String(request.getParameter("rptWeekDays"));
						int repeatmonths = Util.getIntValue(request.getParameter("repeatmonths"),0);
						int repeatmonthdays = Util.getIntValue(request.getParameter("repeatmonthdays"),0);
						int repeatStrategy = Util.getIntValue(request.getParameter("repeatStrategy"),0);
						String remindTypeNew=Util.null2String(request.getParameter("remindTypeNew"));//新的提示方式
						int remindImmediately = Util.getIntValue(request.getParameter("remindImmediately"),0);  //是否立即提醒 
						int remindHoursBeforeStart = Util.getIntValue(request.getParameter("remindHoursBeforeStart"),0);//开始前提醒小时
						int remindHoursBeforeEnd = Util.getIntValue(request.getParameter("remindHoursBeforeEnd"),0);//结束前提醒小时
						String hrmmembers=Util.null2String(request.getParameter("hrmids02"));//参会人员
						String crmmembers=Util.null2String(request.getParameter("crmmembers"));//参会客户
						int crmtotalmember=Util.getIntValue(request.getParameter("crmtotalmember"),0);//参会人数
						String accessorys=Util.null2String(request.getParameter("accessorys"));//系统附件
						
						
						if(WxModuleInit.ifMeetingRepeat){
							String updateSql = "update Meeting set repeatType = " + repeatType 
									+" , repeatdays = "+ repeatdays 
									+" , repeatweeks = "+ repeatweeks 
									+" , rptWeekDays = '"+ rptWeekDays +"' "
									+" , repeatbegindate = '"+ beginDate +"' "
									+" , repeatenddate = '"+ endDate +"' "
									+" , repeatmonths = "+ repeatmonths 
									+" , repeatmonthdays = "+ repeatmonthdays
									+" , repeatStrategy = "+ repeatStrategy
									+" , roomType = "+ roomType
									+" , remindTypeNew = '"+ remindTypeNew+"' "
									+" , remindImmediately = "+ remindImmediately
									+" , remindHoursBeforeStart = "+ remindHoursBeforeStart
									+" , remindHoursBeforeEnd = "+ remindHoursBeforeEnd
									+" , hrmmembers = '"+ hrmmembers+"' "
									+" , crmmembers = '"+ crmmembers+"' "
									+" , crmtotalmember = "+ crmtotalmember
									+" , accessorys = '"+ accessorys+"' "
									+" where id = " + MaxID;
							rs.executeSql(updateSql);
						}
						String[] hrmids01=request.getParameterValues("hrmids01");
						ArrayList arrayhrmids02 = Util.TokenizerString(hrmids02,",");
						if(hrmids01!=null){
							for(int i=0;i<hrmids01.length;i++){
								if(arrayhrmids02.indexOf(hrmids01[i]) == -1) arrayhrmids02.add(hrmids01[i]);
							}
						}
						for(int i=0;i<arrayhrmids02.size();i++){
							ProcPara =  MaxID;
							ProcPara += flag + "1";
							ProcPara += flag + "" + arrayhrmids02.get(i);
							ProcPara += flag + "" + arrayhrmids02.get(i);
							rs.executeProc("Meeting_Member2_Insert",ProcPara);
							//标识会议是否查看过
							StringBuffer stringBuffer = new StringBuffer();
							stringBuffer.append("INSERT INTO Meeting_View_Status(meetingId, userId, userType, status) VALUES(");
							stringBuffer.append(MaxID);
							stringBuffer.append(", ");
							stringBuffer.append(arrayhrmids02.get(i));
							stringBuffer.append(", '");
							stringBuffer.append("1");
							stringBuffer.append("', '");
							if(CurrentUser.equals(arrayhrmids02.get(i))){
							//当前操作用户表示已看
							    stringBuffer.append("1");
							}else{
							    stringBuffer.append("0");
							}
							stringBuffer.append("')");
							rs.executeSql(stringBuffer.toString());
						}
						MeetingViewer.setMeetingShareById(""+MaxID);
						MeetingComInfo.removeMeetingInfoCache();
						
						//触发流程提醒
						String approvewfid = "",formid="";
						int ifForward = 0;
				       
				        if(!meetingtype.equals("")){
				        	if(repeatType>0){//周期会议,查看周期会议审批流程
				        		rs.executeSql("Select approver1,formid From Meeting_Type t1 join workflow_base t2 on t1.approver1=t2.id  where t1.approver1>0 and t1.ID ="+meetingtype);
				        	}else{
				        		rs.executeSql("Select approver,formid From Meeting_Type t1 join workflow_base t2 on t1.approver=t2.id  where t1.approver>0 and t1.ID ="+meetingtype);
				        	}
				            rs.next();
				            approvewfid = rs.getString(1);
				            formid=rs.getString(2);
				        }
				        if(!approvewfid.equals("0")&&!approvewfid.equals("")){
				        	String oldapprovewfid = approvewfid;
				        	try{//增加流程版本控制
				        		Class WorkflowVersion = Class.forName("weaver.workflow.workflow.WorkflowVersion");
				        		Method m = WorkflowVersion.getDeclaredMethod("getActiveVersionWFID",String.class);
				        		approvewfid = (String)m.invoke(WorkflowVersion, approvewfid);
				        		//System.out.println("approvewfid========="+approvewfid);
				        	}catch(Exception e){
				        		//e.printStackTrace();
				        		approvewfid = oldapprovewfid;
				        	}
				        	if("85".equals(formid)){//原系统表单
				        		ifForward = 1;
			            	}else{//新表单,通过Action统一处理
			            		String ClientIP = request.getRemoteAddr();
			            		try{
				            		Class MeetingCreateWFUtil = Class.forName("weaver.meeting.defined.MeetingCreateWFUtil");
				        			Method m = MeetingCreateWFUtil.getDeclaredMethod("createWF",String.class,User.class,String.class,String.class);
				        			m.invoke(MeetingCreateWFUtil, MaxID,user,approvewfid,ClientIP);
			            		}catch(Exception e){
			            			
			            		}
			            	}
				        }else{
				            rs.executeSql("Update Meeting Set meetingstatus = 2 WHERE id="+MaxID);//更新会议状态为正常
				            description = "您有会议: "+name+"   会议时间:"+beginDate
				            	+" 会议地点:"+MeetingRoomComInfo.getMeetingRoomInfoname(""+address)
				            	+customizeAddress;
				            addPlan(name,
				                    MaxID,
				                    beginDate,
				                    beginTime,
				                    endDate,
				                    endTime,
				                    caller,
				                    currentDate,
				                    currentTime,
				                    ""+remindType,
				                    ""+remindBeforeStart,
				                    ""+remindBeforeEnd,
				                    remindTimesBeforeStart,
				                    remindTimesBeforeEnd,
				                    description,
				                    request.getRemoteAddr()
							 );
				            //zhw 20161227 增加判断是否需要发送提醒工作流
				            int createMeetingRemindChk = 1;
				            if(WxModuleInit.ifMeetingRemind){//当前系统支持设置
				            	rs.executeSql("select createMeetingRemindChk from MeetingSet");
				            	if(rs.next()){
				            		createMeetingRemindChk = Util.getIntValue(rs.getString("createMeetingRemindChk"),1);
				            	}
				            }
				            if(createMeetingRemindChk==1){
				            	//触发提醒工作流  Added by Charoes Huang，July 23,2004
								String SWFTitle="";
								String SWFRemark="";
								String SWFSubmiter="";
								String SWFAccepter="";
								String sql="";
								//会议通知
								rs.executeProc("Meeting_Member2_SelectByType",MaxID+flag+"1");
								while(rs.next()){
									SWFAccepter+=","+rs.getString("memberid");
								}
								if(!SWFAccepter.equals("")){
									SWFAccepter=SWFAccepter.substring(1);
									SWFTitle=Util.toScreen("会议通知:",user.getLanguage(),"0"); //文字
									SWFTitle += name;
									SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
									SWFTitle += "-"+currentDate;
									SWFRemark="";
									SWFSubmiter=contacter;
									SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(MaxID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
								}
								//会议服务
								SWFAccepter="";
								sql="select distinct hrmid from Meeting_Service2 where meetingid="+MaxID;
								rs.executeSql(sql);
								while(rs.next()){
									SWFAccepter+=","+rs.getString(1);
								}
								if(!SWFAccepter.equals("")){
									SWFAccepter=SWFAccepter.substring(1);
									SWFTitle=Util.toScreen("会议服务:",user.getLanguage(),"0"); //文字
									SWFTitle += name;
									SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
									SWFTitle += "-"+currentDate;
									SWFRemark="";
									SWFSubmiter=contacter;
									SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(MaxID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
								}
				            }
				        }
				        //zhw 20170804 增加保存会议服务数据
				        try{
					        String serviceItem = Util.null2String(request.getParameter("serviceItem"));//会议服务列表
					        String serviceUser = Util.null2String(request.getParameter("serviceUser"));//会议服务责任人列表
					        String[] serviceItems = serviceItem.split(",");
					        String[] serviceUsers = serviceUser.split("\\|");
					        for(int i=0;i<serviceItems.length;i++){
					        	String item = serviceItems[i];
					        	String itemusers = serviceUsers[i];
					        	rs.executeSql("insert into Meeting_Service_New(meetingid,items,hrmids) values ('"+MaxID+"','"+item+"','"+itemusers+"')");
					        }
				        }catch(Exception e){
				        	
				        }
				        json.put("meetingId", MaxID);
				        json.put("approvewfid", approvewfid);
				        json.put("ifForward", ifForward);
				        status = 0;
					}else{
						msg = "会议室存在冲突,请重新选择";
					}
				}else{
					msg = "开始日期或者结束日期格式错误";
				}
			}else{
				msg = "参数校验失败";
			}
		}else if(operate.equals("saveMeetingFlow")){
			String meetingId = Util.null2String(request.getParameter("meetingId"));//会议类型
			String approvewfid = Util.null2String(request.getParameter("approvewfid"));//会议类型
			//response.sendRedirect("/workflow/request/BillMeetingOperation.jsp?src=submit&iscreate=1&MeetingID="+meetingId+"&approvewfid="+approvewfid+"&viewmeeting=1");
			request.getRequestDispatcher("/workflow/request/BillMeetingOperation.jsp?src=submit&iscreate=1&MeetingID="+meetingId+"&approvewfid="+approvewfid+"&viewmeeting=1").forward(request, response);
			return;
		}else if(operate.equals("getMeetingSummary")){ //获取时间段内每日会议数
			String userid = user.getUID()+"";
			String start = Util.null2String(request.getParameter("start"));
			String end = Util.null2String(request.getParameter("end"));
    		//String membercondition = " exists ( select 1 from Meeting_Member2 where meetingId = meeting.id and (memberId = '"+user.getUID()+"' or othermember = '"+user.getUID()+"' or caller = "+user.getUID() + " or contacter = '" + user.getUID() + "')) ";
			//String rightcondition = " exists (select 1 from Meeting_ShareDetail where meetingId = meeting.id and ((userId = "+user.getUID()+" AND shareLevel in (1,4)) OR (meetingStatus = 2 AND (userId="+user.getUID()+")))) ";
			/* String sql = " select *  from Meeting meeting where (meeting.meetingstatus = 2 or (meeting.meetingstatus in (0,1) and meeting.creater='"+user.getUID()+"')) and meeting.isdecision<>2 "
					+" AND ((beginDate>='"+start+"' AND beginDate <='"+end+"')"
					+" OR (endDate>='"+start+"' AND endDate <='"+end+"')"	
					+" OR (endDate>='"+end+"' AND beginDate <='"+start+"')"
					+" OR ((endDate IS null OR endDate = '') AND beginDate <='"+start+"')"
					+") AND "
					+ "(" + membercondition + " or " + rightcondition + ")" ; */
			
			
			String sql = " select t1.* from Meeting t1"
					+" where exists(select 1 from Meeting_ShareDetail t2"
					+" where ( (t1.id = t2.meetingId) AND "
					//待审批，审批退回的会议，召集人 联系人 创建人  审批人都可以看
				 	+" ((t1.meetingStatus in (1, 3) AND t2.userId in (" + userid + ") AND t2.shareLevel in (1,4))"
					//草稿中的创建人可以看见
					+" OR (t1.meetingStatus = 0 AND (t1.creater in (" + userid + ")) AND (t2.userId in (" + userid + ")) )"
					//正常和取消的会议所有参会人员都可见
					+" OR (t1.meetingStatus IN (2, 4) AND (t2.userId in (" + userid + "))))"
					+")"
					+")"
				
					+" AND ((t1.beginDate>='"+start+"' AND t1.beginDate <='"+end+"')"
					+" OR (t1.endDate>='"+start+"' AND t1.endDate <='"+end+"')"	
					+" OR (t1.endDate>='"+end+"' AND t1.beginDate <='"+start+"')"
					+" OR ((t1.endDate IS null OR t1.endDate = '') AND t1.beginDate <='"+start+"')"
					+")";
			if(WxModuleInit.ifMeetingRepeat){
				sql +=" AND t1.repeatType = 0";
			}
			rs.executeSql(sql);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Map<String, Integer> summaryMap = new TreeMap<String, Integer>( );
			JSONArray selectedList = new JSONArray(); // 返回的结果
			while(rs.next()){
				String beginDate = Util.null2String(rs.getString("begindate"));
				String endDate = Util.null2String(rs.getString("enddate"));
				if(!("".equals(beginDate) && "".equals(endDate)) && endDate.compareTo(beginDate) > 0){
					String[] beginArr =  beginDate.split("-");
					String[] endArr =  endDate.split("-");
					Calendar cBegin = Calendar.getInstance();
					Calendar cEnd = Calendar.getInstance();
					cBegin.set(Integer.valueOf(beginArr[0]), Integer.valueOf(beginArr[1])-1, Integer.valueOf(beginArr[2]));
					cEnd.set(Integer.valueOf(endArr[0]), Integer.valueOf(endArr[1])-1, Integer.valueOf(endArr[2]));
					long cBeginMS = cBegin.getTimeInMillis();
					long cEndMS = cEnd.getTimeInMillis();
					long diffDays = (cEndMS - cBeginMS) / (24 * 60 * 60 * 1000);
					for(int i=0; i<diffDays;i++){ // 添加后面几天
						cBegin.add(Calendar.DATE, 1);
						boolean hasKey = summaryMap.containsKey(sdf.format(cBegin.getTime()));
						String key = sdf.format(cBegin.getTime());
						if(hasKey){
							summaryMap.put(key, summaryMap.get(key) + 1);
						}else{
							summaryMap.put(key, 1);
						}
					}
				}
				boolean hasKey = summaryMap.containsKey(beginDate);
				if(hasKey){
					summaryMap.put(beginDate, summaryMap.get(beginDate) +1);
				}else{
					summaryMap.put(beginDate, 1);
				} 
			}
			JSONObject dayJSON = null;
			for (String key : summaryMap.keySet()) {
				dayJSON = new JSONObject();
				Integer num = summaryMap.get(key);
				dayJSON.put("time",key);
				dayJSON.put("num",num);
				selectedList.add(dayJSON);
			}
			json.put("selectedList",selectedList);
			status = 0;
		}else if("getMeetingWeek".equals(operate)){//获取一周的会议数据
			try{
				String userid = user.getUID()+"";
				String start = Util.null2String(request.getParameter("start"));
				String end = Util.null2String(request.getParameter("end"));
				//String membercondition = " exists ( select 1 from Meeting_Member2 where meetingId = meeting.id and (memberId = '"+user.getUID()+"' or othermember = '"+user.getUID()+"' or caller = "+user.getUID() + " or contacter = '" + user.getUID() + "')) ";
				//String rightcondition = " exists (select 1 from Meeting_ShareDetail where meetingId = meeting.id and ((userId = "+user.getUID()+" AND shareLevel in (1,4)) OR (meetingStatus = 2 AND (userId="+user.getUID()+")))) ";
				//String sql = " select *  from Meeting meeting where (meeting.meetingstatus = 2 or (meeting.meetingstatus in (0,1) and meeting.creater='"+user.getUID()+"')) and meeting.isdecision<>2 ";
				
				String sql = " select t1.* from Meeting t1"
					+" where exists(select 1 from Meeting_ShareDetail t2"
					+" where ( (t1.id = t2.meetingId) AND "
					//待审批，审批退回的会议，召集人 联系人 创建人  审批人都可以看
				 	+" ((t1.meetingStatus in (1, 3) AND t2.userId in (" + userid + ") AND t2.shareLevel in (1,4))"
					//草稿中的创建人可以看见
					+" OR (t1.meetingStatus = 0 AND (t1.creater in (" + userid + ")) AND (t2.userId in (" + userid + ")) )"
					//正常和取消的会议所有参会人员都可见
					+" OR (t1.meetingStatus IN (2, 4) AND (t2.userId in (" + userid + "))))"
					+")"
					+")"
				
					+" AND ((t1.beginDate>='"+start+"' AND t1.beginDate <='"+end+"')"
					+" OR (t1.endDate>='"+start+"' AND t1.endDate <='"+end+"')"	
					+" OR (t1.endDate>='"+end+"' AND t1.beginDate <='"+start+"')"
					+" OR ((t1.endDate IS null OR t1.endDate = '') AND t1.beginDate <='"+start+"')"
					+")";
				if(WxModuleInit.ifMeetingRepeat){
					sql +=" AND t1.repeatType = 0";
				}
				sql += " order by begindate,begintime";
					//+ "(" + membercondition + " or " + rightcondition + ")" ;
				rs.executeSql(sql);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Map<String, JSONArray> weekMap = new TreeMap<String, JSONArray>();
				JSONArray dataList = new JSONArray(); // 返回的结果
				JSONArray wpList = null; //装每天的日程
				Set<String> midList = null;
				try{
					Class mcu = Class.forName("weaver.meeting.MeetingCusUtil");
					Method m = mcu.getMethod("getMeetingFace", new Class[]{String.class,String.class,String.class}); 		
					midList = (Set<String>)m.invoke(mcu, new Object[]{start,end,userid});
				}catch(Exception e){
					//e.printStackTrace();
				}
				while(rs.next()){
					String beginDate = Util.null2String(rs.getString("begindate"));
					String endDate = Util.null2String(rs.getString("enddate"));
					String endTime = Util.null2String(rs.getString("endtime"));
					String id = Util.null2String(rs.getString("id"));
					String name = Util.null2String(rs.getString("name"));
					String meetingtype = Util.null2String(rs.getString("meetingtype"));	
					String meetingstatus = Util.null2String(rs.getString("meetingstatus"));
					String isdecision = Util.null2String(rs.getString("isdecision"));
					String meetingstatusname = MeetingTransMethod.getMeetingStatus(meetingstatus,user.getLanguage()+"+"+endDate+"+"+endTime+"+"+isdecision);
					if("2".equals(meetingstatus)){
						if("2".equals(isdecision)){
							meetingstatus = "5";
						}else{
							if(TimeUtil.timeInterval(endDate+" "+endTime+":00", TimeUtil.getCurrentTimeString())>0){
								meetingstatus = "5";
							}
						}
					}
					if(!"2".equals(meetingstatus)) name = "("+meetingstatusname+")" + name;
					if(!"".equals(beginDate) && !"".equals(endDate) && endDate.compareTo(beginDate) > 0){
						String[] beginArr = beginDate.split("-");
						String[] endArr = endDate.split("-");
						Calendar cBegin = Calendar.getInstance();
						Calendar cEnd = Calendar.getInstance();
						cBegin.set(Integer.valueOf(beginArr[0]), Integer.valueOf(beginArr[1])-1, Integer.valueOf(beginArr[2]));
						cEnd.set(Integer.valueOf(endArr[0]), Integer.valueOf(endArr[1])-1, Integer.valueOf(endArr[2]));
						long cBeginMS = cBegin.getTimeInMillis();
						long cEndMS = cEnd.getTimeInMillis();
						long diffDays = (cEndMS - cBeginMS) / (24 * 60 * 60 * 1000);
						for(int i=0; i<diffDays;i++){ // 添加后面几天
							cBegin.add(Calendar.DATE, 1);
							String key = sdf.format(cBegin.getTime());
							boolean hasKey = weekMap.containsKey(key);
							if(!hasKey){
								wpList = new JSONArray();
								weekMap.put(key, wpList);
							}
							JSONArray oldWpList = weekMap.get(key);
							JSONObject dayJSON = new JSONObject();
							dayJSON.put("id",id);
							dayJSON.put("name",name);
							dayJSON.put("begindate",beginDate);
							dayJSON.put("enddate",endDate);
							dayJSON.put("meetingtype",meetingtype);
							dayJSON.put("meetingstatus",meetingstatus);
							dayJSON.put("meetingstatusname",meetingstatusname);
							if(midList!=null&&midList.contains(id)){
								dayJSON.put("isattend", "1");
							}
							oldWpList.add(dayJSON);
						}
					}
					boolean hasKey = weekMap.containsKey(beginDate);
					if(!hasKey){
						wpList = new JSONArray();
						weekMap.put(beginDate, wpList);
					}
					JSONArray oldWpList = weekMap.get(beginDate);
					JSONObject dayJSON = new JSONObject();
					dayJSON.put("id",id);
					dayJSON.put("name",name);
					dayJSON.put("begindate",beginDate);
					dayJSON.put("enddate",endDate);
					dayJSON.put("meetingtype",meetingtype);
					dayJSON.put("meetingstatus",meetingstatus);
					dayJSON.put("meetingstatusname",meetingstatusname);
					if(midList!=null&&midList.contains(id)){
						dayJSON.put("isattend", "1");
					}
					oldWpList.add(dayJSON);
				}

				Calendar cFirst = Calendar.getInstance();
				Calendar cLast = Calendar.getInstance();
				String[] firstArr =  start.split("-");
				String[] lastArr =  end.split("-");
				cFirst.set(Integer.valueOf(firstArr[0]), Integer.valueOf(firstArr[1])-1, Integer.valueOf(firstArr[2]));
				cLast.set(Integer.valueOf(lastArr[0]), Integer.valueOf(lastArr[1])-1, Integer.valueOf(lastArr[2]));
				long cFirstMS = cFirst.getTimeInMillis();
				long cLastMS = cLast.getTimeInMillis();
				long diffDays = (cLastMS - cFirstMS) / (24 * 60 * 60 * 1000);
				JSONObject dayJSON = null;
				for(int i=0; i<=diffDays;i++){ // 添加每一天的数据
					if(i > 0){
						cFirst.add(Calendar.DATE, 1);
					}
					String key = sdf.format(cFirst.getTime());
					boolean hasKey = weekMap.containsKey(key);
					dayJSON = new JSONObject();
					dayJSON.put("day",key);
					if(hasKey){
						dayJSON.put("wpList", weekMap.get(key));
					}else{
						dayJSON.put("wpList", null);
					}
					dataList.add(dayJSON);
				}
				json.put("data",dataList); 
				status = 0;
			}catch(Exception e){
				msg = "获取周日程数据出错:"+e.getMessage();
			}
		}else if(operate.equals("getDetailById")){ //获取时间段内每日会议数
			String mid = Util.null2String(request.getParameter("mid")); // 会议ID
			if("".equals(mid)){
				json.put("status",status);
				json.put("msg","无效的会议");
				out.print(json.toString());
				return;
			}
			rs.executeSql("SELECT t1.*,t2.name as meetingtypename FROM Meeting t1 left join Meeting_Type t2 on t1.meetingtype=t2.id WHERE t1.id = " + mid);
			if(rs.next()){
				String endDate = Util.null2String(rs.getString("enddate"));
				String endTime = Util.null2String(rs.getString("endtime"));
				String id = Util.null2String(rs.getString("id"));
				String name = Util.null2String(rs.getString("name"));
				String meetingtype = Util.null2String(rs.getString("meetingtype"));	
				String meetingtypename = Util.null2String(rs.getString("meetingtypename"));	
				String meetingstatus = Util.null2String(rs.getString("meetingstatus"));
				String isdecision = Util.null2String(rs.getString("isdecision"));
				String customizeAddress = Util.null2String(rs.getString("customizeAddress"));
				
				JSONObject mJSON = new JSONObject();
				ResourceComInfo rci = new ResourceComInfo();
				mJSON.put("id", id);
				mJSON.put("meetingtype", meetingtype);
				mJSON.put("meetingtypename", meetingtypename);
				mJSON.put("name", name);
				mJSON.put("meetingroom", Util.null2String(meetingService.getMeetingRoom(rs.getString("address"))));
				mJSON.put("customizeAddress", customizeAddress);
				mJSON.put("caller", Util.null2String(rs.getString("caller")));
				mJSON.put("callername", Util.null2String(rci.getLastname(rs.getString("caller"))));
				mJSON.put("contacter", Util.null2String(rs.getString("contacter")));
				mJSON.put("contactername", Util.null2String(rci.getLastname(rs.getString("contacter"))));
				//mJSON.put("hrmmembers", Util.null2String(rs.getString("hrmmembers")));
				RecordSet rs2 = new RecordSet();
				rs2.executeSql("select membermanager from Meeting_Member2 where meetingid = "+id+" and membertype = 1 order by id");
				String hrmmembers = "";
				while(rs2.next()){
					String membermanager = Util.null2String(rs2.getString("membermanager"));
					hrmmembers +=","+membermanager;
				}
				if(!hrmmembers.equals("")){
					hrmmembers = hrmmembers.substring(1);
				}
				mJSON.put("hrmmembers",hrmmembers);
				mJSON.put("hrmmembersname", Util.null2String(this.getHrmNames(hrmmembers)));
				mJSON.put("begindate", Util.null2String(rs.getString("begindate")));
				mJSON.put("begintime", Util.null2String(rs.getString("begintime")));
				mJSON.put("enddate", endDate);
				mJSON.put("endtime", endTime);
				mJSON.put("desc_n", FormatMultiLang.formatByUserid(Util.null2String(rs.getString("desc_n")),creater));
				mJSON.put("creater", Util.null2String(rs.getString("creater")));
				mJSON.put("createName", Util.null2String(rci.getLastname(rs.getString("creater"))));
				mJSON.put("createdate", Util.null2String(rs.getString("createdate")));
				mJSON.put("createtime", Util.null2String(rs.getString("createtime")));
				mJSON.put("meetingstatus", meetingstatus);
				String meetingstatusname = MeetingTransMethod.getMeetingStatus(meetingstatus,user.getLanguage()+"+"+endDate+"+"+endTime+"+"+isdecision);
				mJSON.put("meetingstatusname", meetingstatusname);
				//zhw 20160918 增加变更信息展示（首旅集团使用）
				String bgxx = Util.null2String(rs.getString("bgxx"));
				mJSON.put("bgxx", bgxx);
				//增加获取会议相关附件
				String accessorys = Util.null2String(rs.getString("accessorys"));
				mJSON.put("fj",getFJJsonArray(accessorys,DocImageManager));
				//zhw 增加获取相关附件（首旅集团使用）
				String xgfj = Util.null2String(rs.getString("xgfj"));
				mJSON.put("xgfj",getFJJsonArray(xgfj,DocImageManager));
				//zhw 增加相关交流数据展示（首旅集团使用）
				JSONArray jl_js = new JSONArray();
				
				rs2.executeSql("select * from Exchange_Info where sortid ="+id+" AND type_n='MP' order by createDate desc, createTime desc");
				while(rs2.next()){
					String jl_creater =  rs2.getString("creater");
				  	String createDate = rs2.getString("createDate");
				  	String createTime = rs2.getString("createTime");
					String remark2html = rs2.getString("remark");
					String relateddoc=  Util.null2String(rs2.getString("relateddoc"));
					JSONObject jl = new JSONObject();
					jl.put("name", ResourceComInfo.getResourcename(jl_creater));
					jl.put("userimg", ResourceComInfo.getMessagerUrls(jl_creater));
					jl.put("content", remark2html);
					jl.put("createTime", createDate+" "+createTime);
					jl.put("fj", getFJJsonArray(relateddoc,DocImageManager));
			        jl_js.add(jl);
				}
				mJSON.put("jl",jl_js);
				//会议回执数据返回（E8最新版本标准功能） 首旅集团数据包含在内
				int isattend = -1;
				String isattendName = "";
				String othermember = "";
				String recRemark = "";
				JSONArray hrmList = new JSONArray();
				try{
					String sql = "select membermanager,isattend,";
					if(WxModuleInit.ifMeetingMember){
						sql += "recRemark,";
					}
					sql += "othermember from Meeting_Member2 where meetingid = "+id+" and membertype = 1 order by id";
					//System.out.println(sql);
					int repeattype = Util.getIntValue(rs.getString("repeattype"),0);
			    	rs2.executeSql(sql);
					while(rs2.next()){
						JSONObject hrmJson = new JSONObject();
						String membermanager = Util.null2String(rs2.getString("membermanager"));
						hrmJson.put("hrmName", this.getHrmNames(membermanager));
						String recRemark2 = "";
						if(WxModuleInit.ifMeetingMember){
							recRemark2 = Util.null2String(rs2.getString("recRemark"));
						}
						hrmJson.put("recRemark", recRemark2);
						String othermember2 = this.getHrmNames( Util.null2String(rs2.getString("othermember")));
						hrmJson.put("othermember", othermember2);
						int isattend2 = Util.getIntValue(rs2.getString("isattend"),0);
						String isattendName2 = "未回执";
						if(isattend2==1){//
							isattendName2 = "参加";
						}else if(isattend2==2){
							isattendName2 = "不参加";
						}else if(isattend2==3){
							isattendName2 = "其他人员参加("+othermember2+")";
						}
						hrmJson.put("isattend", isattend2);
						hrmJson.put("attendName", isattendName2);
						
						hrmList.add(hrmJson);
						if(membermanager.equals(user.getUID()+"")){//是当前人员
							//会议状态是正常 并且没有进行会议决议 并且结束日期比当前时间大
							if("2".equals(meetingstatus)&&!isdecision.equals("1") && !isdecision.equals("2")&&repeattype==0
							&&(endDate.compareTo(currentDate)>0||(endDate.compareTo(currentDate)==0&&endTime.compareTo(currentTime)>0))){
								isattend = isattend2;
							}else{
								isattend = 4;//不允许进行回执操作了
							}
							isattendName = isattendName2;
							othermember = othermember2;
							recRemark = recRemark2;
						}
					}
				}catch(Exception e){
					//e.printStackTrace();
				}
				mJSON.put("isattend",isattend);
				mJSON.put("isattendName",isattendName);
				mJSON.put("othermember",othermember);
				mJSON.put("recRemark",recRemark);
				
				mJSON.put("hrmList",hrmList);
				
				json.put("mt",mJSON);
				//增加查看会议记录
				String sql="update Meeting_View_Status set status = 1 where meetingId ="+id +" and userid="+user.getUID();
				rs2.executeSql(sql);
				status = 0;
			}
		}else if(operate.equals("saveMeetingAttend")){//保存会议回执
			String mid = Util.null2String(request.getParameter("mid")); // 会议ID
			if(mid.equals("")){
				status = -1;
				msg = "没有会议ID";
			}else{
				String cuserid = user.getUID()+"";
				int isattend = Util.getIntValue(request.getParameter("isattend"),0);//是否参加
				String othermember = "";
				if(isattend==3){
					othermember = Util.null2String(request.getParameter("othermember"));//其他参会人员
				}
				String recRemark = Util.null2String(request.getParameter("recRemark"));//不参会原因
				boolean ifSlCustomer = false;
				try{
					Class mcu = Class.forName("weaver.meeting.MeetingCusUtil");
					Method m = mcu.getMethod("saveReAndRequest", new Class[]{String.class,String.class,Integer.TYPE,String.class,String.class}); 		
			    	m.invoke(mcu, new Object[]{mid,cuserid,isattend,othermember,recRemark});
			    	ifSlCustomer = true;
			    	status = 0;
				}catch(Exception e){
					//e.printStackTrace();
				}
				//ifSlCustomer = false;
				if(!ifSlCustomer){
					//更新回执情况和其他参会人
					String sql = "update Meeting_Member2 set isattend='"+isattend+"',othermember='"+othermember+"'";
					if(WxModuleInit.ifMeetingMember){
						sql += ",recRemark='"+recRemark+"'";
					}
					sql +=" where meetingid ="+mid+" and membermanager="+user.getUID();
					//System.out.println(sql);
					rs.execute(sql);
					status = 0;
				}
			}
		}
	}catch(Exception e){
		e.printStackTrace();
		msg = e.getMessage();
	}
	json.put("status",status);
	json.put("msg",msg);
	//System.out.println(json.toString());
	out.println(json.toString());
%>
<%!
public void addPlan(String subject,
                    String meetingID,
                    String beginDate,
                    String beginTime,
                    String endDate,
                    String endTime,
                    String caller,
                    String currentDate,
                    String currentTime,
                    String remindType,
                    String remindBeforeStart,
                    String remindBeforeEnd,
                    int remindTimesBeforeStart,
                    int remindTimesBeforeEnd,
                    String description,
					String ip)
{
    if(!meetingID.equals(""))
    {        
        String sqlstr="SELECT DISTINCT memberManager FROM Meeting_Member2 WHERE meetingId = " + meetingID;
        String resourceids ="";
        String para ="";
	    String[] logParams;
	    WorkPlanLogMan logMan = new WorkPlanLogMan();
        char flag1 = Util.getSeparator() ;
        RecordSet rs = new RecordSet();
        rs.executeSql(sqlstr);	
        while(rs.next())
        {
            resourceids += ","+ rs.getString(1);
        }
                        
		if(!"".equals(resourceids))
		{
	        WorkPlan workPlan = new WorkPlan();
	        WorkPlanService workPlanService = new WorkPlanService();
		    
		    workPlan.setCreaterId(Integer.parseInt(caller));
		    //workPlan.setCreateType(Integer.parseInt(user.getLogintype()));

		    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_ConferenceCalendar));        
		    workPlan.setWorkPlanName(subject);    
		    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
		    workPlan.setResourceId(resourceids.substring(1));
		    workPlan.setBeginDate(beginDate);
		    if(null != beginTime && !"".equals(beginTime.trim()))
		    {
		        workPlan.setBeginTime(beginTime);  //开始时间
		    }
		    else
		    {
		        workPlan.setBeginTime(Constants.WorkPlan_StartTime);  //开始时间
		    }	    
		    workPlan.setEndDate(endDate);
		    if(null != endDate && !"".equals(endDate.trim()) && (null == endTime || "".equals(endTime.trim())))
		    {
		        workPlan.setEndTime(Constants.WorkPlan_EndTime);  //结束时间
		    }
		    else
		    {
		        workPlan.setEndTime(endTime);  //结束时间
		    }
		    workPlan.setMeeting(meetingID);
		    //增加提醒
		    workPlan.setRemindType(remindType);  //提醒方式
		    if(!"".equals(remindBeforeStart) && null != remindBeforeStart)
		    {
		        workPlan.setRemindBeforeStart(remindBeforeStart);  //是否开始前提醒
		    }
		    if(!"".equals(remindBeforeEnd) && null != remindBeforeEnd)
		    {
		        workPlan.setRemindBeforeEnd(remindBeforeEnd);  //是否结束前提醒
		    }
		    workPlan.setRemindTimesBeforeStart(remindTimesBeforeStart);  //开始前提醒时间
		    workPlan.setRemindTimesBeforeEnd(remindTimesBeforeEnd);  //结束前提醒时间
		    
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
		    workPlan.setDescription(description);
		    workPlanService.insertWorkPlan(workPlan);  //插入日程
		    
		    //插入日志
            logParams = new String[] {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, caller, ip};
            logMan.writeViewLog(logParams);
		}     
    }
}
public String getHrmNames(String ids){
	String hrmnames = "";
	if(ids!=null && !"".equals(ids)){
		try {
			ResourceComInfo rc = new ResourceComInfo();
			StringBuffer names = new StringBuffer();
			List idList = Util.TokenizerString(ids, ",");
			for (int i = 0; i < idList.size(); i++) {
				names.append("," + rc.getLastname((String)idList.get(i)));
			}
			hrmnames = names.toString();
		} catch (Exception ex) {
			//ex.printStackTrace();
		}
	}
	if(!"".equals(hrmnames)) hrmnames = hrmnames.substring(1);
	return hrmnames;
}
public JSONArray getFJJsonArray(String docids,DocImageManager DocImageManager){
	JSONArray js = new JSONArray();
	if(!docids.equals("")){
		String[] docs = docids.split(",");
		if(null!=docs&&docs.length>0){
			for(String docid:docs){
				if(!docid.equals("")){
					try{
						DocImageManager.resetParameter();
					    DocImageManager.setDocid(Integer.parseInt(docid));
					    DocImageManager.selectDocImageInfo();
					    if(DocImageManager.next()){
					    	String curimgid = DocImageManager.getImagefileid();
					        String curimgname = DocImageManager.getImagefilename();
					        String docFileType = DocImageManager.getDocfiletype();
					        long docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(curimgid));
					        String docImagefilename = Util.null2String(DocImageManager.getImagefilename());
					        String docImagefileSizeStr = "";
					        if(docImagefileSize / (1024 * 1024) > 0) {
					        	docImagefileSizeStr = (docImagefileSize / 1024 / 1024) + "M";
					        } else if(docImagefileSize / 1024 > 0) {
					        	docImagefileSizeStr = (docImagefileSize / 1024) + "K";
					        } else {
					        	docImagefileSizeStr = docImagefileSize + "B";
					        }
					        int idx = docImagefilename.length() - 200;
					        String urlfilename = (idx > 0) ? docImagefilename.substring(idx, docImagefilename.length()) : docImagefilename;
					        urlfilename = java.net.URLEncoder.encode(urlfilename,"UTF-8");
					        JSONObject fj = new JSONObject();
					        fj.put("name", docImagefilename);
					        fj.put("urlfilename", urlfilename);
					        fj.put("size", docImagefileSizeStr);
					        fj.put("fileid", curimgid);
					        js.add(fj);
					    }
					}catch(Exception e){
						
					}
				}
			}
		}
	}
	return js;
}
%>