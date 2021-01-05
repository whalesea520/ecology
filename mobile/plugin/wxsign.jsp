<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.wxinterface.InterfaceUtil"%>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil"%>
<%@ page import="net.sf.json.JSONObject"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
	//request.setCharacterEncoding("UTF-8");
	if(!WxInterfaceInit.isIsutf8()){
		request.setCharacterEncoding("GBK");
	}else{
		request.setCharacterEncoding("UTF-8");
	}
	int identifierType = Util.getIntValue(request.getParameter("identifierType"),1);//用户ID类型 1用户登录ID 2用户ID 
	String userid = Util.null2String(request.getParameter("userid"));//传入的用户标识
	String lng = Util.null2String(request.getParameter("lng"));//经度
	String lat = Util.null2String(request.getParameter("lat"));//纬度
	String addr = Util.null2String(request.getParameter("addr"));//签到地址
	int signType = Util.getIntValue(request.getParameter("signType"),1);//签到类型 1签到 2签退
	String token = Util.null2String(request.getParameter("token"));//token验证用户身份
	String clientAddress = Util.null2String(request.getParameter("clientAddress"));//签到地址
	String deviceid = Util.null2String(request.getParameter("deviceid"));//设备ID
	int ifLocation = Util.getIntValue(request.getParameter("ifLocation"),1);//是否限制地理位置 1为限制
	String comment = "";
	boolean showSignComment = false;
	if("on".equals(Util.null2String(Prop.getPropValue("signComment","showComment")))){
		showSignComment = true;
		 comment = Util.null2String(request.getParameter("comment"));//签到备注
	}
	
	int status = 0;String msg = "";
	String currentdate = TimeUtil.getCurrentDateString();//当天日期
	String currenttime = TimeUtil.getOnlyCurrentTimeString();//当天时间
	int buttonType = signType;//当前应该显示签到或者签退 1：签到 2：签退 3:非工作日 4:没有获取到用户ID
	if(!userid.equals("")&&!token.equals("")){
		try{
			boolean ifAuth = InterfaceUtil.wxCheckLogin(token);//验证token
			//boolean ifAuth = true;
			if(ifAuth){
				String nowtime = TimeUtil.getCurrentTimeString();//当天日期和时间
				String signFrom = "wx";//签到签退来源
				//查询当前用户信息
				String sql = "select  t1.id,t1.subcompanyid1,t1.departmentid,t1.countryid from hrmresource t1 where ";
				if(identifierType==1){//将传入的用户登录ID转换为ec中的用户ID
					String mode = Prop.getPropValue(GCONST.getConfigFile() , "authentic");
			    	if(mode!=null&&mode.equals("ldap")){
			    		sql += " account = '"+userid+"' or loginid = '"+userid+"'";
			    	}else{
			    		sql += " loginid = '"+userid+"'";
			    	}
				}else{
					sql +=" id = "+userid;
				}
				rs.executeSql(sql);
				User user = null;
	    		if(rs.next()){
	    			user = new User();
	    			userid = Util.null2String(rs.getString(1));
	    			user.setUid(Integer.parseInt(userid));
					user.setCountryid(rs.getString("countryid"));
					user.setUserSubCompany1(rs.getInt("subcompanyid1"));
					user.setUserDepartment(rs.getInt("departmentid"));
					user.setLogintype("1");
	    		}
	    		
	    		/* //demo系统指定固定用户登录
	    		else{
	    			String demouserid = Util.null2String(Prop.getPropValue("wxinterface", "demouserid"));
	    			if(!"".equals(demouserid)){
	    				rs.executeSql("select t1.id,t1.subcompanyid1,t1.departmentid,t1.countryid from hrmresource t1 where id="+demouserid);
	    				if(rs.next()){
	    	    			user = new User();
	    	    			userid = Util.null2String(rs.getString(1));
	    	    			user.setUid(Integer.parseInt(userid));
	    					user.setCountryid(rs.getString("countryid"));
	    					user.setUserSubCompany1(rs.getInt("subcompanyid1"));
	    					user.setUserDepartment(rs.getInt("departmentid"));
	    					user.setLogintype("1");
	    	    		}
	    			}
	    		} */
	    		
	    		
	    		if(null!=user){
	    			//获取工作日签到签退的工作时间
					HrmScheduleDiffUtil HrmScheduleDiffUtil = new HrmScheduleDiffUtil();
					HrmScheduleDiffUtil.setUser(user);
					boolean isWorkday = HrmScheduleDiffUtil.getIsWorkday(currentdate);
					if(!isWorkday&&WxInterfaceInit.isIsutf8()){//今天不是工作日判断是否允许在非工作日签到 只有E8才做判断
						rs.executeSql("select * from HrmkqSystemSet");
						if(rs.next()){
							int onlyworkday = Util.getIntValue(rs.getString("onlyworkday"),0);//1表示只能在工作日签到 
							if(onlyworkday!=1){
								isWorkday = true;
							}
						}
					}
					if(isWorkday){//判断是否是工作时间
			    		//获取工作日的开始时间和结束时间
						int subCompanyId = user.getUserSubCompany1();
						Map onDutyAndOffDutyTimeMap = HrmScheduleDiffUtil.getOnDutyAndOffDutyTimeMap(currentdate, subCompanyId);
						String onDutyTimeAM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimeAM"));
						String offDutyTimeAM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimeAM"));
						String onDutyTimePM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimePM"));
						String offDutyTimePM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimePM"));
						if(!onDutyTimeAM.equals("")){
							onDutyTimeAM += ":00";
						}
						if(!offDutyTimeAM.equals("")){
							offDutyTimeAM += ":00";
						}
						if(!onDutyTimePM.equals("")){
							onDutyTimePM += ":00";
						}
						if(!offDutyTimePM.equals("")){
							offDutyTimePM += ":00";
						}
						//System.out.println("onDutyTimeAM======"+onDutyTimeAM);
						//System.out.println("offDutyTimeAM======"+offDutyTimeAM);
						//System.out.println("onDutyTimePM======"+onDutyTimePM);
						//System.out.println("offDutyTimePM======"+offDutyTimePM);
						boolean ifOpenSecondSignIn = false;//是否开启两次签到
						boolean ifSecondSignIn = false;//是否是第二次签到
						boolean ifFirstSignOut = false;//是否是第一次签退
						String secondTime = "",secondDate = "";//二次签到开始时间和当天二次签到开始的日期+时间
						if(onDutyAndOffDutyTimeMap.containsKey("signType")){
							String signType2 = Util.null2String((String)onDutyAndOffDutyTimeMap.get("signType"));
							if(signType2.equals("2")){
								ifOpenSecondSignIn = true;
							}
						}
						//射阳农商行二次开发 zhw 20160219增加
						boolean ifSYNSHCustomer = false;
						int scheduletype = 0;//0表示上午签到，1表示上午签退，2表示下午签到，3表示下午签退
						if(onDutyAndOffDutyTimeMap.containsKey("onDutyTimeAMButton")){//是否是射阳农商行客户
							ifSYNSHCustomer = true;
							String onDutyTimeAMButton = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimeAMButton"))+":00";
							String offDutyTimeAMButton = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimeAMButton"))+":00";
							String onDutyTimePMButton = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimePMButton"))+":00";
							String offDutyTimePMButton = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimePMButton"))+":00";
							//onDutyTimeAMButton = "08:30:00";
							//offDutyTimeAMButton = "12:30:00";
							//onDutyTimePMButton = "12:40:00";
							//offDutyTimePMButton = "18:30:00";
							if(signType==1){//进行签到动作 判断是否在签到时间范围内
								//上午签到时间之前、上午下班时间到下午签到时间之间 、下午下班时间之后 不允许签到
								if(currenttime.compareTo(onDutyTimeAMButton)<0){
									status = 20;
									msg = "温馨提示：请在"+onDutyTimeAMButton+"-"+offDutyTimeAM+"之间签到";
								}else if(currenttime.compareTo(offDutyTimeAM)>0&&currenttime.compareTo(onDutyTimePMButton)<0){
									status = 20;
									msg = "温馨提示：请在"+onDutyTimePMButton+"-"+offDutyTimePM+"之间签到";
								}else if(currenttime.compareTo(offDutyTimePM)>0){
									status = 20;
									msg = "温馨提示：今天已过了允许签到时间";
								}else{
									if(currenttime.compareTo(onDutyTimePMButton)>=0&&currenttime.compareTo(offDutyTimePM)<=0){
										ifSecondSignIn = true;//当前是第二次签到
										scheduletype = 2;
									}
									String signin_sql = "SELECT 1 FROM HrmScheduleSign where userId="+userid+" and signDate='"+currentdate+"' and signType='1' and isInCom = 1";
									if(ifSecondSignIn){
										signin_sql +=" and scheduletype = 2";
									}else{
										signin_sql +=" and scheduletype = 0";
									}
									rs.execute(signin_sql);
									if(rs.next()){
										status = 15;
										msg = "温馨提示：您已经签过到了";
									}
								}
							}else{//进行签退动作
								if((currenttime.compareTo(offDutyTimeAM)>0&&currenttime.compareTo(offDutyTimeAMButton)<=0)
										||(currenttime.compareTo(offDutyTimePM)>0&&currenttime.compareTo(offDutyTimePMButton)<=0)){
									if(currenttime.compareTo(offDutyTimeAM)>0&&currenttime.compareTo(offDutyTimeAMButton)<=0){
										ifFirstSignOut = true;//当前是第一次签退
										scheduletype = 1;
									}else{
										scheduletype = 3;
									}
								}else{
									if(currenttime.compareTo(offDutyTimeAM)<=0){//早上下班前
										status = 21;
										msg = "温馨提示：请在"+offDutyTimeAM+"-"+offDutyTimeAMButton+"之间签退";
									}else if(currenttime.compareTo(offDutyTimePM)<=0){//下午下班前
										status = 21;
										msg = "温馨提示：请在"+offDutyTimePM+"-"+offDutyTimePMButton+"之间签退";
									}else{
										status = 21;
										msg = "温馨提示：今天已过了允许签退时间";
									}
								}
								buttonType = 2;
							}
						}else{//标准功能处理
							if(onDutyAndOffDutyTimeMap.containsKey("signStartTime")){
								secondTime = Util.null2String((String)onDutyAndOffDutyTimeMap.get("signStartTime"));
								secondDate = currentdate+" "+secondTime+":00";
								if(ifOpenSecondSignIn&&TimeUtil.timeInterval(secondDate,nowtime)>0){//开启了二次签到并且当前时间在第二次签到时间之后
									ifSecondSignIn = true;//当前是第二次签到
								}
							}
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							String startTime = "",endTime = "";
							try{
								//获取ECOLOGY中设置的考勤时间范围 格式09:00-23:00 只有E8可以设置 E7没有此功能
								if(WxInterfaceInit.isIsutf8()){
									rs.executeSql("select signTimeScope from hrmkqsystemSet where needsign = 1");
									if(rs.next()){
										String signTimeScope = Util.null2String(rs.getString("signTimeScope"));
										if(!"".equals(signTimeScope)){
											startTime = signTimeScope.split("-")[0];
											endTime = signTimeScope.split("-")[1];
										}
									}
								}
							}catch(Exception e){
								//e.printStackTrace();
							}
							String startDate = currentdate+" "+startTime+":00";
							String endDate = currentdate+" "+endTime+":00";
							//如果没有设置考勤时间范围 那么就不限制考勤时间
							if(!startTime.equals("")){
								if(TimeUtil.timeInterval(nowtime,startDate)>0||TimeUtil.timeInterval(endDate,nowtime)>0){
									status = 16;
									msg = "请在"+startTime+"-"+endTime+"时间范围内进行考勤";
								}
							}
							if(msg.equals("")){
								if(signType==1){//进行签到动作 判断是否在签到时间范围内 是否签到过
									//判断是否签到过
									String signin_sql = "SELECT 1 FROM HrmScheduleSign where userId="+userid+" and signDate='"+currentdate+"' and signType='1' and isInCom = 1";
									if(ifSecondSignIn){//是二次签到
										signin_sql+=" and signTime >= '"+secondTime+":00'";//判断有没有进行过第二次签到
									}
									rs.execute(signin_sql);
									if(rs.next()){
										status = 15;
										buttonType = 2;
										msg = "温馨提示：您已经签过到了";
									}
								}else{
									if(ifOpenSecondSignIn&&TimeUtil.timeInterval(secondDate,nowtime)<=0){//开启了二次签到并且当前时间在第二次签到时间之前
										ifFirstSignOut = true;//是第一次签退
									}
								}
							}
						}
						//判断是否在签到地理位置范围内
						if(ifLocation==1&&msg.equals("")){
							boolean isExits = false;
							String selSql = "select * from wx_locations where isenable =1 and ((resourceids like '%,"+
									subCompanyId+",%' and resourcetype = 1) or (resourceids like '%,"+user.getUserDepartment()
									+",%' and resourcetype = 2) or resourcetype=0) order by resourcetype desc";
							rs.execute(selSql);
							boolean ifSuccess = false;
							int minDistance = 0;
							while(rs.next()){
								isExits = true;
								if(!ifSuccess){
									String addressids = Util.null2String(rs.getString("addressids"));
									if(addressids.equals("-1")){
										ifSuccess = true;
										break;
									}
									if(!"".equals(addressids)){
										rs2.executeSql("select * from WX_LocationSetting where id in ("+addressids+")");
										while(rs2.next()){
											int distance = rs2.getInt("distance");
											if(distance>0){//设置为0表示不限制距离
												String lat2 = Util.null2String(rs2.getString("lat"));
												String lng2 = Util.null2String(rs2.getString("lng"));
												if(!"".equals(lat2)&&!"".equals(lng2)){
													double distance2 = getDistance(lng,lat,lng2,lat2);
													if(distance2>distance){
														if(minDistance == 0||distance<minDistance){
															minDistance = distance;
														}
													}else{
														msg = "";
														ifSuccess = true;
														break;
													}
												}
											}else{
												msg = "";
												ifSuccess = true;
												break;
											}
										}
									}
								}else{
									break;
								}
							}
							if(!ifSuccess){//兼容老版本
								rs.execute("select * from WX_LocationSetting where ((resourceids like '%,"+
										subCompanyId+",%' and resourcetype = 1) or (resourceids like '%,"+user.getUserDepartment()
										+",%' and resourcetype = 2) or resourcetype=0) order by resourcetype desc");
								while(rs.next()){
									isExits = true;
									int distance = rs.getInt("distance");
									if(distance>0){
										String lat2 = Util.null2String(rs.getString("lat"));
										String lng2 = Util.null2String(rs.getString("lng"));
										double distance2 = getDistance(lng,lat,lng2,lat2);
										if(distance2>distance){
											if(minDistance == 0||distance<minDistance){
												minDistance = distance;
											}
										}else{
											msg = "";
											ifSuccess = true;
											break;
										}
									}else{
										msg = "";
										ifSuccess = true;
										break;
									}
								}
							}
							if(!ifSuccess){
								if(!isExits){
									msg = "";
								}else{
									status = 19;
									msg = "温馨提示：您的地理位置距离签到地点超过最小签到范围限制的"+minDistance+"米";
								}
							}
						}
						if(msg.equals("")&&signType!=1&&!ifSYNSHCustomer){//执行签退判断是否已经签到
							rs.execute("SELECT 1 FROM HrmScheduleSign where userId="+userid+" and signDate='"+currentdate+"' and signType='1' and isInCom = 1");
							if(!rs.next()){
								status = 17;
								buttonType = 1;
								msg = "温馨提示：您还没有签到";
							}
						}
						if(msg.equals("")){
							if(signType==1){
								//判断是否超过微信签到次数限制
								String sql3 = "select * from WX_SignCountLimit where resourceids like '%,"
										+subCompanyId+",%' or resourceids like '%,"+user.getUserDepartment()+",%'"
										+" order by resourcetype desc,createtime desc";
								//System.out.println("sql3======"+sql3);
								rs.executeSql(sql3);
								int countLimit = 0;
								if(rs.next()){
									countLimit = Util.getIntValue(rs.getString("countlimit"),0);
								}
								if(countLimit!=0){
									String beginDay = this.getMonthBeginDay();
									String endDay = this.getMonthEndDay();
									String sql2 = "select count(*) from HrmScheduleSign where userId="
											+userid+" and signType='1' and isInCom = 1 and signDate>='"+beginDay
											+"' and signDate <='"+endDay+"' and wxsignaddress is not null";
									//System.out.println(sql2);	
									rs.executeSql(sql2);
									if(rs.next()){
										int count = rs.getInt(1);
										if(count>=countLimit){
											msg = "您本月微信签到限制次数为:"+countLimit+"次,当前已签到:"+count+"次";
										}
									}
								}
								//start***冯晓辉 添加 同一个设备每天只允许一个账号签到  
								//if(!"".equals(deviceid)){
								//	String checkDevice_sql = "select count(id) as total from hrmschedulesign where userid<>"+userid+" and eb_deviceid = '"+deviceid+"' and signDate = '"+currentdate+"'";
								//	rs.execute(checkDevice_sql);
								//	if(rs.next()){
								//		int total = rs.getInt("total");
								//		if(total>0){
								//			//同一设备，多个账号签到
								//			status = 30;
								//			msg = "同一台设备，只能给一个账号考勤！";
								//		}
								//	}	
								//}
								//end***冯晓辉 添加 同一个设备每天只允许一个账号签到 
							}
							if(msg.equals("")){
								//章宏武 增加判断当前签到的设备ID和最后一次签到的设备ID是否一样
								String deviceSql = "";
								if(rs.getDBType().equals("oracle")){
									deviceSql = "select eb_deviceid from hrmschedulesign where id = (select max(id) from hrmschedulesign where userId = "+userid+" and eb_deviceid is not null)";
									rs.execute("select 1 from user_tab_cols where lower(table_name)='hrmschedulesign' and lower(column_name)='signfrom'");
								}else{
									deviceSql = "select eb_deviceid from hrmschedulesign where id = (select max(id) from hrmschedulesign where userId = "+userid+" and eb_deviceid is not null and eb_deviceid !='')";
									rs.execute("select 1 from syscolumns where name='signFrom' and id=object_id('HrmScheduleSign')");
								}
								boolean ifNewTable = false;
								if(rs.next()){
									ifNewTable = true;
								}
								String oldDeviceId = "";
								rs.executeSql(deviceSql);
								if(rs.next()){
									oldDeviceId = Util.null2String(rs.getString("eb_deviceid"));
								}
								int eb_deviceid_change = 0;
								if(!oldDeviceId.equals("")&&!deviceid.equals("")&&!deviceid.equals(oldDeviceId)){
									eb_deviceid_change = 1;
								}
								StringBuffer sb = new StringBuffer();
								sb.append("insert into HrmScheduleSign(userId,userType,signType,signDate,signTime,clientAddress,isInCom,wxsignaddress,eb_deviceid,eb_deviceid_change");
								if(ifNewTable){//判断是否有新字段
									sb.append(",signFrom,LONGITUDE,LATITUDE,ADDR");
								}
								if(ifSYNSHCustomer){
									sb.append(",scheduletype");
								}
								
								//冯晓辉 添加 铁道学院客户 增加 签到备注 字段
								if(showSignComment){
									sb.append(", comment ");
								}
								sb.append(") values ("+userid+",1,"+signType+",'"+currentdate+"','"+currenttime+"'");
								sb.append(",'"+clientAddress+"',1,'"+addr+"'");
								sb.append(",'"+deviceid+"','"+eb_deviceid_change+"'");
								if(ifNewTable){//判断是否有新字段
									sb.append(",'"+signFrom+"','"+lng+"','"+lat+"','"+addr+"'");
								}
								if(ifSYNSHCustomer){
									sb.append(","+scheduletype);
								}
								if(showSignComment){
									sb.append(",'"+comment+"'");
								}
								sb.append(")");
								//System.out.println("================"+sb.toString());
								boolean flag = rs.execute(sb.toString());
								if(flag){
									if(signType==1){//进行的是签到动作 判断是否迟到
										if(ifSecondSignIn){//第二次签到
											if(!onDutyTimePM.equals("")&&currenttime.compareTo(onDutyTimePM) > 0){
												status = 2;
												msg = "温馨提示：您迟到了";
											}else{
												status = 1;
												msg = "温馨提示：您已成功签到";
											}
											/*if(!ifSYNSHCustomer){
												//判断是否进行过第一次签到
												String signin_sql = "SELECT 1 FROM HrmScheduleSign where userId="+userid+" and signDate='"+currentdate+
												"' and signType='1' and isInCom = 1 and signTime < '"+secondTime+":00'";
												rs.executeSql(signin_sql);
												if(rs.next()){//如果有第一次签到 则自动补上一次签退操作
													StringBuffer sb2 = new StringBuffer();
													sb2.append("insert into HrmScheduleSign(userId,userType,signType,signDate,signTime,clientAddress,isInCom,wxsignaddress,eb_deviceid,eb_deviceid_change");
													if(ifNewTable){//判断是否有新字段
														sb2.append(",signFrom,LONGITUDE,LATITUDE,ADDR");
													}
													//冯晓辉 添加 铁道学院客户 增加 签到备注 字段
													if(signComment){
														sb.append(", comment ");
													}
													sb2.append(") values ("+userid+",1,2,'"+currentdate+"','"+secondTime+":00'");
													sb2.append(",'"+clientAddress+"',1,'"+addr+"'");
													sb2.append(",'"+deviceid+"','"+eb_deviceid_change+"'");
													if(ifNewTable){//判断是否有新字段
														sb2.append(",'"+signFrom+"','"+lng+"','"+lat+"','"+addr+"'");
													}
													if(signComment){
														sb.append(",'"+comment+"'");
													}
													sb2.append(")");
													rs.executeSql(sb2.toString());
												}
											}*/
										}else{
											if(!onDutyTimeAM.equals("")&&currenttime.compareTo(onDutyTimeAM) > 0){
												status = 2;
												msg = "温馨提示：您迟到了";
											}else{
												status = 1;
												msg = "温馨提示：您已成功签到";
											}
										}
										buttonType = 2;//签退
									}else{//进行的是签退动作 判断是否早退
										if(ifFirstSignOut){//第一次签退
											if(!offDutyTimeAM.equals("")&&currenttime.compareTo(offDutyTimeAM) < 0){
												status = 3;
												msg = "温馨提示：您早退了";
											}else{
												status = 4;
												msg = "温馨提示：您已成功签退";
											}
										}else{
											if(!offDutyTimePM.equals("")&&currenttime.compareTo(offDutyTimePM) < 0){
												status = 3;
												msg = "温馨提示：您早退了";
											}else{
												status = 4;
												msg = "温馨提示：您已成功签退";
											}
										}
										buttonType = 2;//签退
									}
								}else{
									status = 13;
									msg = "温馨提示：执行插入语句失败";
								}
							}
						}
					}else{
						status = 12;
						buttonType = 3;
						msg = "温馨提示：今天不是工作日不需要签到";
					}
	    		}else{
	    			status = 18;
	    			msg = "温馨提示：您的微信账号绑定的Ecology账号没有找到";
	    		}
			}else{
				status = 11;
				msg = "温馨提示：用户信息验证失败";
			}
		}catch(Exception e){
			//e.printStackTrace();
			status = 14;
			msg = e.getMessage();
		}
	}else{
		status = 10;
		msg = "温馨提示：相关参数不完整";
	}
	JSONObject json = new JSONObject();
	json.put("status",status);
	json.put("msg",msg);
	json.put("buttonType",buttonType);
	json.put("currentTime",currentdate+" "+currenttime);
	json.put("comment",comment);
	//System.out.println(json.toString());
	out.print(json.toString());
%>

<%!
public double getDistance(String lng1, String lat1, String lng2, String lat2) {
	double s = 1000000;
	try{
		double radLat1 = Double.parseDouble(lat1) * Math.PI / 180.0;
		double radLat2 = Double.parseDouble(lat2) * Math.PI / 180.0;
		double a = radLat1 - radLat2;
		double b = Double.parseDouble(lng1) * Math.PI / 180.0 - Double.parseDouble(lng2) * Math.PI / 180.0;
		s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2) + Math.cos(radLat1) * Math.cos(radLat2) * Math.pow(Math.sin(b / 2), 2)));
		s = s * 6378137;
		s = Math.round(s * 10000) / 10000;
	}catch(Exception e){
		
	}
	return s;
}
public static String getMonthBeginDay()
{
  String str = "";
  Calendar localCalendar = Calendar.getInstance();
  SimpleDateFormat localSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
  localCalendar.set(5, 1);
  Date localDate = localCalendar.getTime();
  str = localSimpleDateFormat.format(localDate);
  return str;
}
public static String getMonthEndDay()
{
  String str = "";
  Calendar localCalendar = Calendar.getInstance();
  SimpleDateFormat localSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
  localCalendar.set(5, 1);
  localCalendar.roll(5, -1);
  Date localDate = localCalendar.getTime();
  str = localSimpleDateFormat.format(localDate);
  return str;
}
%>