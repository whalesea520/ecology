<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.conn.RecordSet"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%	
	FileUpload fu = new FileUpload(request); 
	String operation = Util.null2String(fu.getParameter("operation"));
	int status = 1;String msg = "";
	JSONObject result = new JSONObject();
	if(operation.equals("findUserBydetId")){  //根据部门或分部id 获取OA人员
		JSONArray ja = new JSONArray();
		try{
			boolean isldap = "ldap".equals(Prop.getPropValue(GCONST.getConfigFile() , "authentic")) ? true : false;
			String resourcetype = Util.null2String(fu.getParameter("resourcetype"));  //选择了分部还是部门
			String resourceids = Util.null2String(fu.getParameter("resourceids")); //部门或分部id
			if(resourceids.startsWith(",")){
				resourceids = resourceids.substring(1);
			}
			if(resourceids.endsWith(",")){
				resourceids = resourceids.substring(0,resourceids.length()-1);
			}
			StringBuffer sql = new StringBuffer();
			sql.append("select t1.id,t1.loginid,t1.account from HrmResource t1 where t1.status in (0,1,2,3) and t1.loginid is not null");
			if(resourcetype.equals("1")){
				sql.append(" and t1.subcompanyid1 in ("+resourceids+")");
			}else if(resourcetype.equals("2")){
				sql.append(" and t1.departmentid in ("+resourceids+")");
			}
			rs.executeSql(sql.toString());
			JSONObject jo = null;
			String loginid = "";
			while(rs.next()){
				jo = new JSONObject();
				jo.put("userid",Util.null2String(rs.getString("id")));
				if(isldap){//域登录
					loginid = Util.null2String(rs.getString("account"));
	        		if("".equals(loginid)) loginid = Util.null2String(rs.getString("loginid"));
	        	}else{
	        		loginid = Util.null2String(rs.getString("loginid"));
	        	}
				jo.put("loginid",loginid);
				ja.add(jo);
			}
			result.put("userList", ja);
			status = 0;
		}catch(Exception e){
			msg = "获取人员失败:"+e.getMessage();
		}
	}else if(operation.equals("savePunchRecord")){   //打卡人员数据入库
		String param = Util.null2String(fu.getParameter("param"));
		String cptype = Util.null2String(fu.getParameter("cptype"));
		
		String startDate = Util.null2String(fu.getParameter("startDate")); //打卡开始时间
		String endDate = Util.null2String(fu.getParameter("endDate")); //打卡结束时间
		String LYtype = Util.null2String(fu.getParameter("LYtype"));   //类型，是定时打卡还是初始 
		
		JSONArray ja = new JSONArray();
		if(!param.equals("")){
			try{
				BaseBean bb = new BaseBean();
				JSONArray array = JSONArray.fromObject(param);
				
				//插入数据之前 先删除今天 已经同步的数据
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				String currentDate = sdf.format(new Date());
				bb.writeLog("【"+currentDate+"】考勤同步数据钉钉返回结果:\n"+param);
				StringBuffer sb = new StringBuffer();
				
				if(null != LYtype && LYtype.equals("2")){
					sb.append("delete from hrmschedulesign  where signDate >='"+startDate+"' and signDate <='"+endDate+"'");
				}else{
					sb.append("delete from hrmschedulesign  where signDate='"+currentDate+"'");
				}
				if("2".equals(cptype)){
					sb.append(" and signFrom = 'from_dd'");
				}else if("13".equals(cptype)) {
					sb.append(" and signFrom = 'from_wx'");
				}
				rs.executeSql(sb.toString());
				SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				for(int i=0;array!=null&&i<array.size();i++) {
					JSONObject json = array.getJSONObject(i);
					String gmtModified = Util.null2String(json.getString("gmtModified"));  //修改时间
					String isLegal = Util.null2String(json.getString("isLegal")); // 是否合法
					String baseCheckTime = Util.null2String(json.getString("baseCheckTime")); //计算迟到和早退，基准时间
					String id = Util.null2String(json.getString("id")); //唯一标示ID
					String userAddress = Util.convertInput2DB(json.getString("userAddress")); //用户打卡地址
					String userId = Util.null2String(json.getString("userId")); // 用户ID
					String checkType = Util.null2String(json.getString("checkType")); // 考勤类型（OnDuty：上班，OffDuty：下班）
					String timeResult = Util.null2String(json.getString("timeResult")); // 时间结果（Normal:正常;Early:早退; Late:迟到;SeriousLate:严重迟到；NotSigned:未打卡）
					String deviceId = Util.null2String(json.getString("deviceId")); //   设备id
					String corpId = Util.null2String(json.getString("corpId")); // 
					String sourceType = Util.null2String(json.getString("sourceType")); //数据来源 （ATM:考勤机;BEACON:IBeacon;DING_ATM:钉钉考勤机;APP_USER:用户打卡;APP_BOSS:老板改签;APP_APPROVE:审批系统;SYSTEM:考勤系统;APP_AUTO_CHECK:自动打卡）
					String workDate = Util.null2String(json.getString("workDate")); // 工作日
					String planCheckTime = Util.null2String(json.getString("planCheckTime")); //排班打卡时间
					String gmtCreate = Util.null2String(json.getString("gmtCreate")); //创建时间
					String locationMethod = Util.null2String(json.getString("locationMethod")); //定位方法
					String locationResult = Util.null2String(json.getString("locationResult")); //位置结果（Normal:范围内；Outside:范围外）
					String userLongitude = Util.null2String(json.getString("userLongitude")); //用户打卡经度
					String planId = Util.null2String(json.getString("planId")); //排班ID
					String groupId = Util.null2String(json.getString("groupId")); //考勤组ID
					String userAccuracy = Util.null2String(json.getString("userAccuracy")); //用户打卡定位精度
					String userCheckTime = Util.null2String(json.getString("userCheckTime")); //实际打卡时间
					String userLatitude = Util.null2String(json.getString("userLatitude")); //用户打卡经度
					String procInstId = Util.null2String(json.getString("procInstId")); //关联的审批实例id，可以审批数据获取接口配合使用
					
					String signFrom = Util.null2String(json.getString("signFrom")); // 信息来源
					String cdate = "",ctime = "";
					if(!userCheckTime.equals("")){
						try{
							Date date = new Date(Long.parseLong(userCheckTime));
							userCheckTime = sdf2.format(date);
							String[] cc = userCheckTime.split(" ");
							if(null!=cc&&cc.length==2){
								cdate = cc[0];
								ctime = cc[1];
							}
						}catch(Exception e){
							
						}
					}
					//插入数据
                    String sql = "insert into hrmschedulesign (userId,userType,signType,signDate,signTime,isInCom,"
							+"signFrom,LONGITUDE,LATITUDE,ADDR,wxsignaddress,eb_deviceid,eb_deviceid_change) values "
                    		+"('"+userId+"','1','"+checkType+"','"+cdate+"','"+ctime+"','1','"+signFrom+"','"+userLongitude
                    		+"','"+userLatitude+"','"+userAddress+"','"+userAddress+"','"+deviceId+"','0')";
					rs.executeSql(sql);
				}
				status = 0;
			}catch(Exception e){
				e.printStackTrace();
				msg = "保存数据到OA程序异常:"+e.getMessage();
			}
		}else{
			msg = "未获取到数据";
		}
	}
	result.put("status", status);
	result.put("msg", msg);
	out.println(result);
%>