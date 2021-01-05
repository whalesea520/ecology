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
	int identifierType = Util.getIntValue(request.getParameter("identifierType"),1);//�û�ID���� 1�û���¼ID 2�û�ID 
	String userid = Util.null2String(request.getParameter("userid"));//������û���ʶ
	String lng = Util.null2String(request.getParameter("lng"));//����
	String lat = Util.null2String(request.getParameter("lat"));//γ��
	String addr = Util.null2String(request.getParameter("addr"));//ǩ����ַ
	int signType = Util.getIntValue(request.getParameter("signType"),1);//ǩ������ 1ǩ�� 2ǩ��
	String token = Util.null2String(request.getParameter("token"));//token��֤�û�����
	String clientAddress = Util.null2String(request.getParameter("clientAddress"));//ǩ����ַ
	int timeLimit = Util.getIntValue(request.getParameter("timeLimit"),30);//�������ϰ�ʱ��ǰ���ǩ�� ��λ����
	int status = 0;String msg = "";
	if(!userid.equals("")&&!token.equals("")){
		try{
			boolean ifAuth = InterfaceUtil.wxCheckLogin(token);//��֤token
			//boolean ifAuth = true;
			if(ifAuth){
				String currentdate = TimeUtil.getCurrentDateString();//��������
				String currenttime = TimeUtil.getOnlyCurrentTimeString();//����ʱ��
				String nowtime = TimeUtil.getCurrentTimeString();//�������ں�ʱ��
				String signFrom = "wx";//ǩ��ǩ����Դ
				//��ȡ������ǩ��ǩ�˵Ĺ���ʱ��
				HrmScheduleDiffUtil HrmScheduleDiffUtil = new HrmScheduleDiffUtil();
				boolean isWorkday = HrmScheduleDiffUtil.getIsWorkday(currentdate);
				if(isWorkday){//�ж��Ƿ��ǹ���ʱ��
					//��ѯ��ǰ�û���Ϣ
					String sql = "select  t1.id,t1.subcompanyid1,t1.countryid from hrmresource t1 where ";
					if(identifierType==1){//��������û���¼IDת��Ϊec�е��û�ID
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
		    		//��ȡ�����յĿ�ʼʱ��ͽ���ʱ��
					int subCompanyId = user.getUserSubCompany1();
					HrmScheduleDiffUtil.setUser(user);
					Map onDutyAndOffDutyTimeMap = HrmScheduleDiffUtil.getOnDutyAndOffDutyTimeMap(currentdate, subCompanyId);
					String onDutyTimeAM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimeAM"));
					String offDutyTimePM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimePM"));
					
					if(signType==1){//����ǩ������ �ж��Ƿ���ǩ��ʱ�䷶Χ�� �Ƿ�ǩ����
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						Date dutyTimeAm = sdf.parse(currentdate+" "+onDutyTimeAM+":00");
						long time = dutyTimeAm.getTime()-timeLimit*60*1000;
						Date dutyTimeAm2 = new Date(time);
						String onDutyTimeAM2 = sdf.format(dutyTimeAm2);
						//System.out.println("nowtime:"+nowtime+"\nonDutyTimeAM2:"+onDutyTimeAM2);
						if(TimeUtil.timeInterval(nowtime,onDutyTimeAM2)>0){
							status = 16;
							msg = "��û�е���涨��ǩ����ʼʱ��";
						}else{//�ж��Ƿ�ǩ����
							rs.execute("SELECT 1 FROM HrmScheduleSign where userId="+userid+" and signDate='"+currentdate+"' and signType='1'");
							if(rs.next()){
								status = 15;
								msg = "���Ѿ�ǩ������";
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
						if(ifNewTable){//�ж��Ƿ������ֶ�
							sb.append(",signFrom,LONGITUDE,LATITUDE,ADDR");
						}
						sb.append(") values ("+userid+",1,"+signType+",'"+currentdate+"','"+currenttime+"'");
						sb.append(",'"+clientAddress+"',1");
						if(ifNewTable){//�ж��Ƿ������ֶ�
							sb.append(",'"+signFrom+"','"+lng+"','"+lat+"','"+addr+"'");
						}
						sb.append(")");
						//System.out.println(sb.toString());
						boolean flag = rs.execute(sb.toString());
						if(flag){
							if(signType==1){//���е���ǩ������ �ж��Ƿ�ٵ�
								if(currenttime.compareTo(onDutyTimeAM) > 0){
									status = 2;
									msg = "���ٵ���";
								}else{
									status = 1;
									msg = "���ѳɹ�ǩ��";
								}
							}else{//���е���ǩ�˶��� �ж��Ƿ�����
								if(currenttime.compareTo(offDutyTimePM) < 0){
									status = 3;
									msg = "��������";
								}else{
									status = 4;
									msg = "���ѳɹ�ǩ��";
								}
							}
						}else{
							status = 13;
							msg = "ִ�в������ʧ��";
						}
					}
				}else{
					status = 12;
					msg = "���첻�ǹ����ղ���Ҫǩ��";
				}
			}else{
				status = 11;
				msg = "�û���Ϣ��֤ʧ��";
			}
		}catch(Exception e){
			e.printStackTrace();
			status = 14;
			msg = e.getMessage();
		}
	}else{
		status = 10;
		msg = "��ز���������";
	}
	out.print("{status:"+status+",msg:'"+msg+"'}");
%>