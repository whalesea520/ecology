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
	int identifierType = Util.getIntValue(request.getParameter("identifierType"),1);//�û�ID���� 1�û���¼ID 2�û�ID 
	String userid = Util.null2String(request.getParameter("userid"));//������û���ʶ
	String lng = Util.null2String(request.getParameter("lng"));//����
	String lat = Util.null2String(request.getParameter("lat"));//γ��
	String addr = Util.null2String(request.getParameter("addr"));//ǩ����ַ
	int signType = Util.getIntValue(request.getParameter("signType"),1);//ǩ������ 1ǩ�� 2ǩ��
	String token = Util.null2String(request.getParameter("token"));//token��֤�û�����
	String clientAddress = Util.null2String(request.getParameter("clientAddress"));//ǩ����ַ
	String deviceid = Util.null2String(request.getParameter("deviceid"));//�豸ID
	int ifLocation = Util.getIntValue(request.getParameter("ifLocation"),1);//�Ƿ����Ƶ���λ�� 1Ϊ����
	String comment = "";
	boolean showSignComment = false;
	if("on".equals(Util.null2String(Prop.getPropValue("signComment","showComment")))){
		showSignComment = true;
		 comment = Util.null2String(request.getParameter("comment"));//ǩ����ע
	}
	
	int status = 0;String msg = "";
	String currentdate = TimeUtil.getCurrentDateString();//��������
	String currenttime = TimeUtil.getOnlyCurrentTimeString();//����ʱ��
	int buttonType = signType;//��ǰӦ����ʾǩ������ǩ�� 1��ǩ�� 2��ǩ�� 3:�ǹ����� 4:û�л�ȡ���û�ID
	if(!userid.equals("")&&!token.equals("")){
		try{
			boolean ifAuth = InterfaceUtil.wxCheckLogin(token);//��֤token
			//boolean ifAuth = true;
			if(ifAuth){
				String nowtime = TimeUtil.getCurrentTimeString();//�������ں�ʱ��
				String signFrom = "wx";//ǩ��ǩ����Դ
				//��ѯ��ǰ�û���Ϣ
				String sql = "select  t1.id,t1.subcompanyid1,t1.departmentid,t1.countryid from hrmresource t1 where ";
				if(identifierType==1){//��������û���¼IDת��Ϊec�е��û�ID
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
	    		
	    		/* //demoϵͳָ���̶��û���¼
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
	    			//��ȡ������ǩ��ǩ�˵Ĺ���ʱ��
					HrmScheduleDiffUtil HrmScheduleDiffUtil = new HrmScheduleDiffUtil();
					HrmScheduleDiffUtil.setUser(user);
					boolean isWorkday = HrmScheduleDiffUtil.getIsWorkday(currentdate);
					if(!isWorkday&&WxInterfaceInit.isIsutf8()){//���첻�ǹ������ж��Ƿ������ڷǹ�����ǩ�� ֻ��E8�����ж�
						rs.executeSql("select * from HrmkqSystemSet");
						if(rs.next()){
							int onlyworkday = Util.getIntValue(rs.getString("onlyworkday"),0);//1��ʾֻ���ڹ�����ǩ�� 
							if(onlyworkday!=1){
								isWorkday = true;
							}
						}
					}
					if(isWorkday){//�ж��Ƿ��ǹ���ʱ��
			    		//��ȡ�����յĿ�ʼʱ��ͽ���ʱ��
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
						boolean ifOpenSecondSignIn = false;//�Ƿ�������ǩ��
						boolean ifSecondSignIn = false;//�Ƿ��ǵڶ���ǩ��
						boolean ifFirstSignOut = false;//�Ƿ��ǵ�һ��ǩ��
						String secondTime = "",secondDate = "";//����ǩ����ʼʱ��͵������ǩ����ʼ������+ʱ��
						if(onDutyAndOffDutyTimeMap.containsKey("signType")){
							String signType2 = Util.null2String((String)onDutyAndOffDutyTimeMap.get("signType"));
							if(signType2.equals("2")){
								ifOpenSecondSignIn = true;
							}
						}
						//����ũ���ж��ο��� zhw 20160219����
						boolean ifSYNSHCustomer = false;
						int scheduletype = 0;//0��ʾ����ǩ����1��ʾ����ǩ�ˣ�2��ʾ����ǩ����3��ʾ����ǩ��
						if(onDutyAndOffDutyTimeMap.containsKey("onDutyTimeAMButton")){//�Ƿ�������ũ���пͻ�
							ifSYNSHCustomer = true;
							String onDutyTimeAMButton = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimeAMButton"))+":00";
							String offDutyTimeAMButton = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimeAMButton"))+":00";
							String onDutyTimePMButton = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimePMButton"))+":00";
							String offDutyTimePMButton = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimePMButton"))+":00";
							//onDutyTimeAMButton = "08:30:00";
							//offDutyTimeAMButton = "12:30:00";
							//onDutyTimePMButton = "12:40:00";
							//offDutyTimePMButton = "18:30:00";
							if(signType==1){//����ǩ������ �ж��Ƿ���ǩ��ʱ�䷶Χ��
								//����ǩ��ʱ��֮ǰ�������°�ʱ�䵽����ǩ��ʱ��֮�� �������°�ʱ��֮�� ������ǩ��
								if(currenttime.compareTo(onDutyTimeAMButton)<0){
									status = 20;
									msg = "��ܰ��ʾ������"+onDutyTimeAMButton+"-"+offDutyTimeAM+"֮��ǩ��";
								}else if(currenttime.compareTo(offDutyTimeAM)>0&&currenttime.compareTo(onDutyTimePMButton)<0){
									status = 20;
									msg = "��ܰ��ʾ������"+onDutyTimePMButton+"-"+offDutyTimePM+"֮��ǩ��";
								}else if(currenttime.compareTo(offDutyTimePM)>0){
									status = 20;
									msg = "��ܰ��ʾ�������ѹ�������ǩ��ʱ��";
								}else{
									if(currenttime.compareTo(onDutyTimePMButton)>=0&&currenttime.compareTo(offDutyTimePM)<=0){
										ifSecondSignIn = true;//��ǰ�ǵڶ���ǩ��
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
										msg = "��ܰ��ʾ�����Ѿ�ǩ������";
									}
								}
							}else{//����ǩ�˶���
								if((currenttime.compareTo(offDutyTimeAM)>0&&currenttime.compareTo(offDutyTimeAMButton)<=0)
										||(currenttime.compareTo(offDutyTimePM)>0&&currenttime.compareTo(offDutyTimePMButton)<=0)){
									if(currenttime.compareTo(offDutyTimeAM)>0&&currenttime.compareTo(offDutyTimeAMButton)<=0){
										ifFirstSignOut = true;//��ǰ�ǵ�һ��ǩ��
										scheduletype = 1;
									}else{
										scheduletype = 3;
									}
								}else{
									if(currenttime.compareTo(offDutyTimeAM)<=0){//�����°�ǰ
										status = 21;
										msg = "��ܰ��ʾ������"+offDutyTimeAM+"-"+offDutyTimeAMButton+"֮��ǩ��";
									}else if(currenttime.compareTo(offDutyTimePM)<=0){//�����°�ǰ
										status = 21;
										msg = "��ܰ��ʾ������"+offDutyTimePM+"-"+offDutyTimePMButton+"֮��ǩ��";
									}else{
										status = 21;
										msg = "��ܰ��ʾ�������ѹ�������ǩ��ʱ��";
									}
								}
								buttonType = 2;
							}
						}else{//��׼���ܴ���
							if(onDutyAndOffDutyTimeMap.containsKey("signStartTime")){
								secondTime = Util.null2String((String)onDutyAndOffDutyTimeMap.get("signStartTime"));
								secondDate = currentdate+" "+secondTime+":00";
								if(ifOpenSecondSignIn&&TimeUtil.timeInterval(secondDate,nowtime)>0){//�����˶���ǩ�����ҵ�ǰʱ���ڵڶ���ǩ��ʱ��֮��
									ifSecondSignIn = true;//��ǰ�ǵڶ���ǩ��
								}
							}
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							String startTime = "",endTime = "";
							try{
								//��ȡECOLOGY�����õĿ���ʱ�䷶Χ ��ʽ09:00-23:00 ֻ��E8�������� E7û�д˹���
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
							//���û�����ÿ���ʱ�䷶Χ ��ô�Ͳ����ƿ���ʱ��
							if(!startTime.equals("")){
								if(TimeUtil.timeInterval(nowtime,startDate)>0||TimeUtil.timeInterval(endDate,nowtime)>0){
									status = 16;
									msg = "����"+startTime+"-"+endTime+"ʱ�䷶Χ�ڽ��п���";
								}
							}
							if(msg.equals("")){
								if(signType==1){//����ǩ������ �ж��Ƿ���ǩ��ʱ�䷶Χ�� �Ƿ�ǩ����
									//�ж��Ƿ�ǩ����
									String signin_sql = "SELECT 1 FROM HrmScheduleSign where userId="+userid+" and signDate='"+currentdate+"' and signType='1' and isInCom = 1";
									if(ifSecondSignIn){//�Ƕ���ǩ��
										signin_sql+=" and signTime >= '"+secondTime+":00'";//�ж���û�н��й��ڶ���ǩ��
									}
									rs.execute(signin_sql);
									if(rs.next()){
										status = 15;
										buttonType = 2;
										msg = "��ܰ��ʾ�����Ѿ�ǩ������";
									}
								}else{
									if(ifOpenSecondSignIn&&TimeUtil.timeInterval(secondDate,nowtime)<=0){//�����˶���ǩ�����ҵ�ǰʱ���ڵڶ���ǩ��ʱ��֮ǰ
										ifFirstSignOut = true;//�ǵ�һ��ǩ��
									}
								}
							}
						}
						//�ж��Ƿ���ǩ������λ�÷�Χ��
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
											if(distance>0){//����Ϊ0��ʾ�����ƾ���
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
							if(!ifSuccess){//�����ϰ汾
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
									msg = "��ܰ��ʾ�����ĵ���λ�þ���ǩ���ص㳬����Сǩ����Χ���Ƶ�"+minDistance+"��";
								}
							}
						}
						if(msg.equals("")&&signType!=1&&!ifSYNSHCustomer){//ִ��ǩ���ж��Ƿ��Ѿ�ǩ��
							rs.execute("SELECT 1 FROM HrmScheduleSign where userId="+userid+" and signDate='"+currentdate+"' and signType='1' and isInCom = 1");
							if(!rs.next()){
								status = 17;
								buttonType = 1;
								msg = "��ܰ��ʾ������û��ǩ��";
							}
						}
						if(msg.equals("")){
							if(signType==1){
								//�ж��Ƿ񳬹�΢��ǩ����������
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
											msg = "������΢��ǩ�����ƴ���Ϊ:"+countLimit+"��,��ǰ��ǩ��:"+count+"��";
										}
									}
								}
								//start***������ ���� ͬһ���豸ÿ��ֻ����һ���˺�ǩ��  
								//if(!"".equals(deviceid)){
								//	String checkDevice_sql = "select count(id) as total from hrmschedulesign where userid<>"+userid+" and eb_deviceid = '"+deviceid+"' and signDate = '"+currentdate+"'";
								//	rs.execute(checkDevice_sql);
								//	if(rs.next()){
								//		int total = rs.getInt("total");
								//		if(total>0){
								//			//ͬһ�豸������˺�ǩ��
								//			status = 30;
								//			msg = "ͬһ̨�豸��ֻ�ܸ�һ���˺ſ��ڣ�";
								//		}
								//	}	
								//}
								//end***������ ���� ͬһ���豸ÿ��ֻ����һ���˺�ǩ�� 
							}
							if(msg.equals("")){
								//�º��� �����жϵ�ǰǩ�����豸ID�����һ��ǩ�����豸ID�Ƿ�һ��
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
								if(ifNewTable){//�ж��Ƿ������ֶ�
									sb.append(",signFrom,LONGITUDE,LATITUDE,ADDR");
								}
								if(ifSYNSHCustomer){
									sb.append(",scheduletype");
								}
								
								//������ ���� ����ѧԺ�ͻ� ���� ǩ����ע �ֶ�
								if(showSignComment){
									sb.append(", comment ");
								}
								sb.append(") values ("+userid+",1,"+signType+",'"+currentdate+"','"+currenttime+"'");
								sb.append(",'"+clientAddress+"',1,'"+addr+"'");
								sb.append(",'"+deviceid+"','"+eb_deviceid_change+"'");
								if(ifNewTable){//�ж��Ƿ������ֶ�
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
									if(signType==1){//���е���ǩ������ �ж��Ƿ�ٵ�
										if(ifSecondSignIn){//�ڶ���ǩ��
											if(!onDutyTimePM.equals("")&&currenttime.compareTo(onDutyTimePM) > 0){
												status = 2;
												msg = "��ܰ��ʾ�����ٵ���";
											}else{
												status = 1;
												msg = "��ܰ��ʾ�����ѳɹ�ǩ��";
											}
											/*if(!ifSYNSHCustomer){
												//�ж��Ƿ���й���һ��ǩ��
												String signin_sql = "SELECT 1 FROM HrmScheduleSign where userId="+userid+" and signDate='"+currentdate+
												"' and signType='1' and isInCom = 1 and signTime < '"+secondTime+":00'";
												rs.executeSql(signin_sql);
												if(rs.next()){//����е�һ��ǩ�� ���Զ�����һ��ǩ�˲���
													StringBuffer sb2 = new StringBuffer();
													sb2.append("insert into HrmScheduleSign(userId,userType,signType,signDate,signTime,clientAddress,isInCom,wxsignaddress,eb_deviceid,eb_deviceid_change");
													if(ifNewTable){//�ж��Ƿ������ֶ�
														sb2.append(",signFrom,LONGITUDE,LATITUDE,ADDR");
													}
													//������ ���� ����ѧԺ�ͻ� ���� ǩ����ע �ֶ�
													if(signComment){
														sb.append(", comment ");
													}
													sb2.append(") values ("+userid+",1,2,'"+currentdate+"','"+secondTime+":00'");
													sb2.append(",'"+clientAddress+"',1,'"+addr+"'");
													sb2.append(",'"+deviceid+"','"+eb_deviceid_change+"'");
													if(ifNewTable){//�ж��Ƿ������ֶ�
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
												msg = "��ܰ��ʾ�����ٵ���";
											}else{
												status = 1;
												msg = "��ܰ��ʾ�����ѳɹ�ǩ��";
											}
										}
										buttonType = 2;//ǩ��
									}else{//���е���ǩ�˶��� �ж��Ƿ�����
										if(ifFirstSignOut){//��һ��ǩ��
											if(!offDutyTimeAM.equals("")&&currenttime.compareTo(offDutyTimeAM) < 0){
												status = 3;
												msg = "��ܰ��ʾ����������";
											}else{
												status = 4;
												msg = "��ܰ��ʾ�����ѳɹ�ǩ��";
											}
										}else{
											if(!offDutyTimePM.equals("")&&currenttime.compareTo(offDutyTimePM) < 0){
												status = 3;
												msg = "��ܰ��ʾ����������";
											}else{
												status = 4;
												msg = "��ܰ��ʾ�����ѳɹ�ǩ��";
											}
										}
										buttonType = 2;//ǩ��
									}
								}else{
									status = 13;
									msg = "��ܰ��ʾ��ִ�в������ʧ��";
								}
							}
						}
					}else{
						status = 12;
						buttonType = 3;
						msg = "��ܰ��ʾ�����첻�ǹ����ղ���Ҫǩ��";
					}
	    		}else{
	    			status = 18;
	    			msg = "��ܰ��ʾ������΢���˺Ű󶨵�Ecology�˺�û���ҵ�";
	    		}
			}else{
				status = 11;
				msg = "��ܰ��ʾ���û���Ϣ��֤ʧ��";
			}
		}catch(Exception e){
			//e.printStackTrace();
			status = 14;
			msg = e.getMessage();
		}
	}else{
		status = 10;
		msg = "��ܰ��ʾ����ز���������";
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