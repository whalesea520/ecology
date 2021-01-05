<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.mobile.plugin.ecology.service.HrmResourceService "%>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.wxinterface.InterfaceUtil"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int identifierType = Util.getIntValue(request.getParameter("identifierType"),1);//用户ID类型 1用户登录ID 2用户ID 
	String userid = Util.null2String(request.getParameter("userid"));//传入的用户标识
	String lng = Util.null2String(request.getParameter("lng"));//经度
	String lat = Util.null2String(request.getParameter("lat"));//纬度
	String addr = Util.null2String(request.getParameter("addr"));//签到地址
	int signType = Util.getIntValue(request.getParameter("signType"),1);//签到类型 1签到 2签退
	String token = Util.null2String(request.getParameter("token"));//token验证用户身份
	String clientAddress = Util.null2String(request.getParameter("clientAddress"));//签到地址
	int timeLimit = Util.getIntValue(request.getParameter("timeLimit"),30);//允许在上班时间前多久签到 单位分钟
	int status = 0;String msg = "";
	if(!userid.equals("")&&!token.equals("")){
		try{
			boolean ifAuth = InterfaceUtil.wxCheckLogin(token);//验证token
			//boolean ifAuth = true;
			if(ifAuth){
				String currentdate = TimeUtil.getCurrentDateString();//当天日期
				String currenttime = TimeUtil.getOnlyCurrentTimeString();//当天时间
				String nowtime = TimeUtil.getCurrentTimeString();//当天日期和时间
				String signFrom = "wx";//签到签退来源
				//获取工作日签到签退的工作时间
				HrmScheduleDiffUtil HrmScheduleDiffUtil = new HrmScheduleDiffUtil();
				boolean isWorkday = HrmScheduleDiffUtil.getIsWorkday(currentdate);
				if(isWorkday){//判断是否是工作时间
					//查询当前用户信息
					String sql = "select  t1.id,t1.subcompanyid1,t1.countryid from hrmresource t1 where ";
					if(identifierType==1){//将传入的用户登录ID转换为ec中的用户ID
						String mode = Prop.getPropValue(GCONST.getConfigFile() , "authentic");
				    	if(mode!=null&&mode.equals("ldap")){
				    		sql += " account = '"+userid+"'";
				    	}else{
				    		sql += " loginid = '"+userid+"'";
				    	}
					}else{
						sql +=" id = "+userid;
					}
					rs.executeSql(sql);
					User user = new User();
		    		if(rs.next()){
		    			userid = Util.null2String(rs.getString(1));
		    			user.setUid(Integer.parseInt(userid));
						user.setCountryid(rs.getString("countryid"));
						user.setUserSubCompany1(rs.getInt("subcompanyid1"));
						user.setLogintype("1");
		    		}
		    		//获取工作日的开始时间和结束时间
					int subCompanyId = user.getUserSubCompany1();
					HrmScheduleDiffUtil.setUser(user);
					Map onDutyAndOffDutyTimeMap = HrmScheduleDiffUtil.getOnDutyAndOffDutyTimeMap(currentdate, subCompanyId);
					String onDutyTimeAM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimeAM"));
					String offDutyTimePM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimePM"));
					
					if(signType==1){//进行签到动作 判断是否在签到时间范围内 是否签到过
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						Date dutyTimeAm = sdf.parse(currentdate+" "+onDutyTimeAM+":00");
						long time = dutyTimeAm.getTime()-timeLimit*60*1000;
						Date dutyTimeAm2 = new Date(time);
						String onDutyTimeAM2 = sdf.format(dutyTimeAm2);
						//System.out.println("nowtime:"+nowtime+"\nonDutyTimeAM2:"+onDutyTimeAM2);
						if(TimeUtil.timeInterval(nowtime,onDutyTimeAM2)>0){
							status = 16;
							msg = "还没有到达规定的签到开始时间";
						}else{//判断是否签到过
							rs.execute("SELECT 1 FROM HrmScheduleSign where userId="+userid+" and signDate='"+currentdate+"' and signType='1'");
							if(rs.next()){
								status = 15;
								msg = "您已经签过到了";
							}
						}
					}
					if(msg.equals("")){
						if(rs.getDBType().equals("oracle")){
							rs.execute("select 1 from user_tab_cols where table_name='HrmScheduleSign' and column_name='signFrom'");
						}else{
							rs.execute("select 1 from syscolumns where name='signFrom' and id=object_id('HrmScheduleSign')");
						}
						boolean ifNewTable = false;
						if(rs.next()){
							ifNewTable = true;
						}
						StringBuffer sb = new StringBuffer();
						sb.append("insert into HrmScheduleSign(userId,userType,signType,signDate,signTime,clientAddress,isInCom");
						if(ifNewTable){//判断是否有新字段
							sb.append(",signFrom,LONGITUDE,LATITUDE,ADDR");
						}
						sb.append(") values ("+userid+",1,"+signType+",'"+currentdate+"','"+currenttime+"'");
						sb.append(",'"+clientAddress+"',1");
						if(ifNewTable){//判断是否有新字段
							sb.append(",'"+signFrom+"','"+lng+"','"+lat+"','"+addr+"'");
						}
						sb.append(")");
						//System.out.println(sb.toString());
						boolean flag = rs.execute(sb.toString());
						if(flag){
							if(signType==1){//进行的是签到动作 判断是否迟到
								if(currenttime.compareTo(onDutyTimeAM) > 0){
									status = 2;
									msg = "您迟到了";
								}else{
									status = 1;
									msg = "您已成功签到";
								}
							}else{//进行的是签退动作 判断是否早退
								if(currenttime.compareTo(offDutyTimePM) < 0){
									status = 3;
									msg = "您早退了";
								}else{
									status = 4;
									msg = "您已成功签退";
								}
							}
						}else{
							status = 13;
							msg = "执行插入语句失败";
						}
					}
				}else{
					status = 12;
					msg = "今天不是工作日不需要签到";
				}
			}else{
				status = 11;
				msg = "用户信息验证失败";
			}
		}catch(Exception e){
			e.printStackTrace();
			status = 14;
			msg = e.getMessage();
		}
	}else{
		status = 10;
		msg = "相关参数不完整";
	}
	out.print("{status:"+status+",msg:'"+msg+"'}");
%>