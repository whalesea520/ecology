<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="java.lang.reflect.Constructor"%>
<%@ page import="weaver.hrm.company.DepartmentComInfo" %>
<%@ page import="weaver.hrm.company.SubCompanyComInfo" %>
<%@ page import="weaver.hrm.job.JobTitlesComInfo" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.hrm.location.LocationComInfo"%>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.wxinterface.InterfaceUtil"%>
<%@ page import="weaver.wxinterface.WxModuleInit"%>
<%@ page import="weaver.wxinterface.FormatMultiLang"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.hrm.group.GroupAction"%>
<%@ page import="weaver.hrm.company.CompanyComInfo" %>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.general.BaseBean"%>
<%!
//增加静态变量 判断是否是光大证券用户(是的话手机号码全部隐藏)
private static int ifgdzq = Util.getIntValue(Prop.getPropValue("wx_hrmbrowser","ifgdzq"),0);
//增加静态变量 判断是否是新农饲料客户(是的话手机号码隐藏中间4位)
private static int ifxnsl = Util.getIntValue(Prop.getPropValue("wx_hrmbrowser","ifxnsl"),0);
//增加静态变量 判断是否是浙江物产料客户(是的话支持手机号、座机、邮箱的隐藏自定义设置)
private static int ifzjwc = Util.getIntValue(Prop.getPropValue("wx_hrmbrowser","ifzjwc"),0);
private Map<String, Object> getHrmMap(String id,String lastname,String status,String subCompanyID,String departmentID,
		String jobTitle,String subCompanyName,String departmentName,String jobTitlesName,String messagerurl,
		String statusname,String managername,String wordaddress,String tel,String mobile,String email,String managerid,
		String belongto,String userkeytype){
	Map<String, Object> hrmMap = null;
    if(status.equals("0") || status.equals("1") || status.equals("2") || status.equals("3")){
    	hrmMap = new HashMap<String, Object>();
		hrmMap.put("id", id);	//id
		hrmMap.put("lastname", lastname);	//姓名
		hrmMap.put("name", lastname);	//姓名
		hrmMap.put("type", "4");
		//hrmMap.put("subCompanyID", subCompanyID);	//分部id
		hrmMap.put("subCompanyName", subCompanyName);	//分部名称
		hrmMap.put("departmentID", departmentID);	//部门id
		hrmMap.put("departmentName", departmentName);	//部门名称
		//hrmMap.put("jobTitle", jobTitle);	//岗位id
		hrmMap.put("jobTitlesName", jobTitlesName);	//岗位名称
		hrmMap.put("messagerurl", messagerurl);	//头像
		hrmMap.put("statusname", statusname);	//状态名称
		hrmMap.put("managername", managername);	//上级名称
		hrmMap.put("wordaddress", wordaddress);	//工作地点
		hrmMap.put("tel", tel);//办公电话
		hrmMap.put("mobile", mobile);//手机
		hrmMap.put("email", email);	//邮箱
		hrmMap.put("managerid", managerid);//上级ID
		hrmMap.put("belongto", belongto);//主账号
		String userkey = id;
		if(!"".equals(belongto)) userkey = belongto;//如果是次账号，则取主账号的ID
		if(userkeytype.equals("loginid")){
			userkey = InterfaceUtil.transUserId(userkey, 1);
		}
		hrmMap.put("userkey", userkey);	//用户唯一标识
    }
    return hrmMap;
}

private Map<String,Integer[]> getHrmMobileShowMap(String deptId){
	Map<String,Integer[]> hrmMobileShowMap = null;
	if(WxModuleInit.ifMobileHide){
		RecordSet rs = new RecordSet();
		hrmMobileShowMap = new HashMap<String,Integer[]>();
		String mstSql = "select id,mobileShowType,seclevel from HrmResource where (status =0 or status =1 or status =2 or status =3)"+
						" and (mobileShowType = 2 or mobileShowType = 3)";
		if(!deptId.equals("")){
			mstSql +=" and departmentid = "+deptId;
		}
		rs.executeSql(mstSql);
		while(rs.next()){
			String id = Util.null2String(rs.getString("id"));
			int mobileShowType = Util.getIntValue(rs.getString("mobileShowType"),0);
			int seclevel = Util.getIntValue(rs.getString("seclevel"),0);
			Integer[] ms = {mobileShowType,seclevel};
			hrmMobileShowMap.put(id, ms);
		}
	}
	return hrmMobileShowMap;
}

private int initHrmList(String userid,String deptId,String searchKey,int pageNo,int pageSize,List<Map<String, Object>> hrmList){
	int iTotal = 0;
	try{
		String whereSql = "";//加入分权控制
		try{
			Class pvm = Class.forName("weaver.hrm.appdetach.AppDetachComInfo");
			Method m = pvm.getDeclaredMethod("getScopeSqlByHrmResourceSearch",String.class);
			whereSql = (String)m.invoke(pvm.newInstance(),userid);
		}catch(Exception e){
			//System.out.println("获取查询SQL出错:"+e.getMessage());
			//e.printStackTrace();
		}
		RecordSet rs = new RecordSet();
		Map<String,Integer[]> hrmMobileShowMap = getHrmMobileShowMap(deptId);
		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
		JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
		ResourceComInfo resourceComInfo2 = new ResourceComInfo();
		LocationComInfo lci = new LocationComInfo();
		String userkeytype = InterfaceUtil.getUserkeytype();
		String orderSql = " order by dsporder,id";
		String orderSql2 = " order by dsporder desc,id desc";
		String fromSql = " from HrmResource ";
		String selectField = " ";
		int ifgldc = Util.getIntValue(Prop.getPropValue("wx_hrmbrowser","ifgldc"),0);//是否是格力地产客户
		if(ifgldc==1){
			selectField = ",c.field11,c.field12,c.field13,c.field14,c.field15,c.field16 ";
			fromSql += " left join cus_fielddata c on hrmresource.id = c.id and c.scope = 'HrmCustomFieldByInfoType' and c.scopeid = -1";
		}
		fromSql += " where (status =0 or status =1 or status =2 or status =3)";
		if(!whereSql.equals("")){
			fromSql += " and "+whereSql;
		}
		if(!searchKey.equals("")){
			if(ifgldc==1){
				//移动电话短号   field11 办公室座机外线   field14 办公室座机内线 field15 手机电话    field12 手机电话短号  field13 内线电话field10兼职岗位   field16
				fromSql += " and (pinyinlastname like '%"+searchKey+"%' or lastname like '%"+searchKey
						+"%' or mobile like '%"+searchKey+"%' or telephone like '%"+searchKey
						+"%' or c.field16 like '%"+searchKey+"%' or c.field15 like '%"+searchKey
						+"%' or c.field14 like '%"+searchKey+"%' or c.field13 like '%"+searchKey
						+"%' or c.field12 like '%"+searchKey+"%' or c.field11 like '%"+searchKey+"%' or c.field10 like '%"+searchKey+"%')";
			}else{
				fromSql += " and (pinyinlastname like '%"+searchKey+"%' or lastname like '%"+searchKey
						+"%' or mobile like '%"+searchKey+"%' or telephone like '%"+searchKey+"%')";
			}
		}
		String sql = "";
		if(!deptId.equals("")){//查询部门下的人员时不使用分页
			fromSql += " and departmentid = "+deptId;
			sql = "select hrmresource.*"+selectField+fromSql+" order by hrmresource.dsporder,hrmresource.id";
		}else{
			//过滤掉次账号
			fromSql += " and (accounttype=0 or accounttype is null)";
			rs.executeSql("select count(hrmresource.id) "+fromSql);
			if(rs.next()) iTotal = rs.getInt(1);
			int totalpage = iTotal / pageSize;
			if(iTotal % pageSize >0) totalpage += 1;
			if(pageNo>totalpage) pageNo = 1;
			int iNextNum = pageNo * pageSize;
			int ipageset = pageSize;
			if(iTotal - iNextNum + pageSize < pageSize) ipageset = iTotal - iNextNum + pageSize;
			if(iTotal < pageSize) ipageset = iTotal;
			sql = "select top " + ipageset +" A.* from (select top "+ iNextNum +" hrmresource.*"+selectField+fromSql+ orderSql + ") A "+orderSql2;
			sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderSql;
			if(rs.getDBType().equals("oracle")){
				sql = "select hrmresource.*"+selectField+fromSql+ " order by hrmresource.dsporder,hrmresource.id";
				sql = "select tt2.*,rownum rn from (" + sql + ") tt2 where rownum <= " + iNextNum;
				sql = "select tt3.* from (" + sql + ") tt3 where rn > " + (iNextNum - pageSize);
			}
		}
		//BaseBean bb = new BaseBean();
		//bb.writeLog("通讯录查询的SQL========\n"+sql);
		//System.out.println(sql);
		rs.executeSql(sql);
		List<Map<String, Object>> hrmList2 = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> hrmList3 = new ArrayList<Map<String, Object>>();
		while(rs.next()){
			String id = rs.getString("id");
			//String loginid = rs.getString("loginid");
			String lastname = rs.getString("lastname");
			String status = rs.getString("status");
			String subCompanyID = rs.getString("subcompanyid1");
			String departmentID = rs.getString("departmentid");
			String jobTitle = rs.getString("jobtitle");
			String messagerurl = Util.null2String(rs.getString("messagerurl"));
			String managerid = Util.null2String(rs.getString("managerid"));
			String locationid = Util.null2String(rs.getString("locationid"));
			String tel = Util.null2String(rs.getString("telephone"));
			String mobile = Util.null2String(rs.getString("mobile"));
			String email = Util.null2String(rs.getString("email"));
			String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);//分部名称
			String departmentName = departmentComInfo.getDepartmentname(departmentID);//部门名称
			String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//岗位名称
			String statusname = getStatusName(status);
			String managername = resourceComInfo2.getLastname(managerid);
			String wordaddress = lci.getLocationname(locationid);
			String accounttype = Util.null2String(rs.getString("accounttype"));//账号类型 1为次账号
			String belongto = Util.null2String(rs.getString("belongto"));
			if(!"1".equals(accounttype)) belongto = "";
			Map<String, Object> hrmMap = getHrmMap(id,
					FormatMultiLang.formatByUserid(lastname,userid),
					status,subCompanyID,departmentID,jobTitle,
					FormatMultiLang.formatByUserid(subCompanyName,userid),
					FormatMultiLang.formatByUserid(departmentName,userid),
					FormatMultiLang.formatByUserid(jobTitlesName,userid),
					messagerurl,statusname,managername,wordaddress,
					dealTel(tel,id,userid),
					dealMobile(hrmMobileShowMap,mobile,id,userid),
					dealEmail(email,id,userid),
					managerid,belongto,userkeytype);
			if(null!=hrmMap){
				//格力地产
				if(ifgldc==1){
					String field11 = Util.null2String(rs.getString("field11"));
					String field12 = Util.null2String(rs.getString("field12"));
					String field13 = Util.null2String(rs.getString("field13"));
					String field14 = Util.null2String(rs.getString("field14"));
					String field15 = Util.null2String(rs.getString("field15"));
					String field16 = Util.null2String(rs.getString("field16"));
					hrmMap.put("field11",field11);
					hrmMap.put("field12",field12);
					hrmMap.put("field13",field13);
					hrmMap.put("field14",field14);
					hrmMap.put("field15",field15);
					String f16Name = "";
					if(!"".equals(field16)){
						String f16[] = field16.split(",");
						for(String s:f16){
							f16Name+=jobTitlesComInfo.getJobTitlesname(s)+"&nbsp;";
						}
					}
					hrmMap.put("field16",f16Name);
				}
				if(!deptId.equals("")){
					hrmList2.add(hrmMap);
					hrmList3.add(hrmMap);
				}else{
					hrmList.add(hrmMap);
				}
			}
		}
		if(!deptId.equals("")){//查询部门下的人员时，如果主次账号都存在，则过滤次账号，如果有多个次账号则只显示一个
			for(Map<String, Object> m:hrmList2){
				String id = Util.null2String((String)m.get("id"));
				String belongto =  Util.null2String((String)m.get("belongto"));
				boolean ifAdd = true;
				if(!belongto.equals("")){//当前是次账号
					for(Map<String, Object> m2:hrmList3){
						String id2 = Util.null2String((String)m2.get("id"));
						String belongto2 =  Util.null2String((String)m2.get("belongto"));
						if(!id.equals(id2)){//不是本身
							if(belongto.equals(id2)){//该次账号对应的主账号已经存在
								ifAdd = false;
								break;
							}
						}
					}
					if(ifAdd){//对应主账号不存在
						for(Map<String, Object> m2:hrmList3){
							String id2 = Util.null2String((String)m2.get("id"));
							String belongto2 =  Util.null2String((String)m2.get("belongto"));
							if(!id.equals(id2)){//不是本身
								if(belongto.equals(belongto2)){//该次账号还有重复的次账号
									for(Map<String, Object> m3:hrmList){//判断该次账号是否已经添加过
										String id3 = Util.null2String((String)m3.get("id"));
										String belongto3 =  Util.null2String((String)m3.get("belongto"));
										if(belongto.equals(belongto3)){
											ifAdd = false;
											break;
										}
									}
									if(!ifAdd){
										break;
									}
								}
							}
						}
					}
				}
				if(ifAdd){
					hrmList.add(m);
				}
			}
		}
	}catch(Exception ex){
		//ex.printStackTrace();
		//throw new RuntimeException(ex);
	}
	return iTotal;
}
private List<Map<String, Object>> getSubCompanyByTree(String pid,User user,String alllowsubcompanystr,String alllowdepartmentstr,
		String alllowsubcompanyviewstr,String alllowdepartmentviewstr) throws Exception{
	List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
	SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
	subCompanyComInfo.setTofirstRow();
	while(subCompanyComInfo.next()){
		String supsubcomid = subCompanyComInfo.getSupsubcomid();
		if(supsubcomid==null||supsubcomid==""){
			supsubcomid = "0";
		}
		String canceled = subCompanyComInfo.getCompanyiscanceled();
		if(!supsubcomid.equals(pid) || "1".equals(canceled)){
			continue;
		}
		String id = subCompanyComInfo.getSubCompanyid();
		if((alllowsubcompanystr.length()>0 || alllowsubcompanyviewstr.length()>0)){
			if((","+alllowsubcompanystr+",").indexOf(","+id+",")==-1&&
				(","+alllowsubcompanyviewstr+",").indexOf(","+id+",")==-1) continue;
		}
        String name = subCompanyComInfo.getSubCompanyname();
        
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("id", id);
        map.put("name", FormatMultiLang.formatByUserid(name,user.getUID()+""));
        boolean hasChild = hasChildSubCompany(id,user,alllowsubcompanystr,alllowsubcompanyviewstr) || hasChildDepartment("0", id,user,alllowdepartmentstr,alllowdepartmentviewstr);
        map.put("hasChild", hasChild);
        map.put("type", "2");
        result.add(map);
	}
	return result;
}

private boolean hasChildSubCompany(String pid,User user,String alllowsubcompanystr,String alllowsubcompanyviewstr) throws Exception{
	SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
	subCompanyComInfo.setTofirstRow();
	while(subCompanyComInfo.next()){
		String id = subCompanyComInfo.getSubCompanyid();
		if((alllowsubcompanystr.length()>0 || alllowsubcompanyviewstr.length()>0)){
			if((","+alllowsubcompanystr+",").indexOf(","+id+",")==-1&&
				(","+alllowsubcompanyviewstr+",").indexOf(","+id+",")==-1) continue;
		}
		String supsubcomid = subCompanyComInfo.getSupsubcomid();
		if(supsubcomid==null||supsubcomid==""){
			supsubcomid = "0";
		}
		String canceled = subCompanyComInfo.getCompanyiscanceled();
		if(supsubcomid.equals(pid) && (!"1".equals(canceled))){
			return true;
		}
	}
	return false;
}

private List<Map<String, Object>> getDepartmentByTree(String pid, String _subcompanyid1,User user,String alllowdepartmentstr,String alllowdepartmentviewstr) throws Exception{
	List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
	DepartmentComInfo departmentComInfo = new DepartmentComInfo();
	departmentComInfo.setTofirstRow();
	while(departmentComInfo.next()){
		String supdepid = departmentComInfo.getDepartmentsupdepid();	//上级部门id
		if(supdepid==null||supdepid.equals("")){
			supdepid = "0";
		}
		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//分部id
		String canceled = departmentComInfo.getDeparmentcanceled();
		if(!(supdepid.equals(pid) && (_subcompanyid1 == null || subcompanyid1.equals(_subcompanyid1)))
				|| "1".equals(canceled)){
			continue;
		}
		String id = departmentComInfo.getDepartmentid();
		if((alllowdepartmentstr.length()>0||alllowdepartmentviewstr.length()>0) ){
			if((","+alllowdepartmentstr+",").indexOf(","+id+",")==-1&&
					(","+alllowdepartmentviewstr+",").indexOf(","+id+",")==-1) continue;
		}
        String name = departmentComInfo.getDepartmentname();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("id", id);
        map.put("name", FormatMultiLang.formatByUserid(name,user.getUID()+""));
        boolean hasChild = hasChildDepartment(id, _subcompanyid1,user,alllowdepartmentstr,alllowdepartmentviewstr) || hasChildResource(id,user.getUID()+"");
        map.put("hasChild", hasChild);
        map.put("type", "3");
        result.add(map);
	}
	
	return result;
}

private boolean hasChildDepartment(String pid, String _subcompanyid1,User user,String alllowdepartmentstr,String alllowdepartmentviewstr) throws Exception{
	DepartmentComInfo departmentComInfo = new DepartmentComInfo();
	departmentComInfo.setTofirstRow();
	while(departmentComInfo.next()){
		String id = departmentComInfo.getDepartmentid();
		if((alllowdepartmentstr.length()>0||alllowdepartmentviewstr.length()>0) ){
			if((","+alllowdepartmentstr+",").indexOf(","+id+",")==-1&&
					(","+alllowdepartmentviewstr+",").indexOf(","+id+",")==-1) continue;
		}
		String supdepid = departmentComInfo.getDepartmentsupdepid();	//上级部门id
		if(supdepid==null||supdepid.equals("")){
			supdepid = "0";
		}
		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//分部id
		String canceled = departmentComInfo.getDeparmentcanceled();
		if((supdepid.equals(pid) && (_subcompanyid1 == null || subcompanyid1.equals(_subcompanyid1)))
				&& (!"1".equals(canceled))){
			return true;
		}
	}
	return false;
}

private List<Map<String, Object>> getResourceByTree(String deptId,String userid) throws Exception{
	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
	initHrmList(userid,deptId,"",0,0,list);
	return list;
}

private boolean hasChildResource(String deptId,String userid) throws Exception{
	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
	initHrmList(userid,deptId,"",0,0,list);
	if(list.size()>0){
		return true;
	}
	return false;
}

private String getStatusName(String status){
	String statusname = "";
	if(status.equals("0")) statusname=SystemEnv.getHtmlLabelName(15710,7);
	if(status.equals("1")) statusname=SystemEnv.getHtmlLabelName(15711,7);
	if(status.equals("2")) statusname=SystemEnv.getHtmlLabelName(480,7);
	if(status.equals("3")) statusname=SystemEnv.getHtmlLabelName(15844,7);
	if(status.equals("4")) statusname=SystemEnv.getHtmlLabelName(6094,7);
	if(status.equals("5")) statusname=SystemEnv.getHtmlLabelName(6091,7);
	if(status.equals("6")) statusname=SystemEnv.getHtmlLabelName(6092,7);
	if(status.equals("7")) statusname=SystemEnv.getHtmlLabelName(2245,7);
	if(status.equals("10")) statusname=SystemEnv.getHtmlLabelName(1831,7);
	return statusname;
}

private String dealMobile(Map<String,Integer[]> hrmMobileShowMap,String mobile,String userid,String curUserid){
	if(userid.equals(curUserid)){
		return mobile;
	}
	if(ifzjwc==1){
		try{
			Class rc = Class.forName("weaver.hrm.resource.ResourceComInfo");
			Method m = rc.getMethod("getMobileShow",String.class,String.class); 		
			mobile = (String)m.invoke(rc.newInstance(),userid,curUserid);
		}catch(Exception e){
			e.printStackTrace();
		}
		return mobile;
	}
	try{
		if(mobile.length()>4){
			boolean canShow = true;
			ResourceComInfo resourceComInfo = new ResourceComInfo();
			if(hrmMobileShowMap!=null&&hrmMobileShowMap.containsKey(userid)){
				Integer[] ms = hrmMobileShowMap.get(userid);
				int mobileShowType = ms[0];
				int seclevel = ms[1];
				if(mobileShowType==2){//对所有人保密
					canShow = false;
				}else if(mobileShowType==3){//对低于自身安全级别者保密
					int currentUserSeclevel = Util.getIntValue(resourceComInfo.getSeclevel(curUserid),0);//当前人员的安全级别
					if(seclevel>currentUserSeclevel){
						canShow = false;
					}
				}
			}
			if(!canShow){//zhw 20161206 增加三盛宏业 权限特殊处理
				User user = new User();
				user.setUid(Util.getIntValue(curUserid));
				user.setLogintype("1");
				if(HrmUserVarify.checkUserRight("OpenMobileAuthority:Edit", user)){
					canShow = true;
		  		}
			}
			if(!canShow){
				if(ifgdzq==1){//光大证券客户
					mobile = "***********";
				}else if(ifxnsl==1){//新农饲料客户隐藏中间4位
					mobile = mobile.substring(0,3)+"****"+mobile.substring(mobile.length()-4);
				}else{
					mobile = mobile.substring(0,mobile.length()-4)+"****";
				}
			}
		}
	}catch(Exception e){
		
	}
	return mobile;
}

private String dealTel(String tel,String userid,String curUserid){
	if(userid.equals(curUserid)){
		return tel;
	}
	if(ifzjwc==1){
		try{
			Class rc = Class.forName("weaver.hrm.resource.ResourceComInfo");
			Method m = rc.getMethod("getTelephoneShow",String.class,String.class); 		
			tel = (String)m.invoke(rc.newInstance(),userid,curUserid);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	return tel;
}
private String dealEmail(String email,String userid,String curUserid){
	if(userid.equals(curUserid)){
		return email;
	}
	if(ifzjwc==1){
		try{
			Class rc = Class.forName("weaver.hrm.resource.ResourceComInfo");
			Method m = rc.getMethod("getEmailShow",String.class,String.class); 		
			email = (String)m.invoke(rc.newInstance(),userid,curUserid);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	return email;
}
%>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json;charset=UTF-8");
String operation = Util.null2String(request.getParameter("operation"));
int status = 1;String msg = "";
JSONObject jo = new JSONObject();
try{
	if("getHrmList".equals(operation)){
		String keyword = Util.null2String(request.getParameter("keyword"));
		int pageNo = Util.getIntValue(request.getParameter("pageNo"), 1);
		int pageSize = Util.getIntValue(request.getParameter("pageSize"),50);
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		int totalSize = initHrmList(user.getUID()+"","",keyword,pageNo,pageSize,list);
		jo.put("totalSize", totalSize);
		jo.put("hrmList", JSONArray.fromObject(list));
		status = 0;
	}else if("getTreeData".equals(operation)){
		String type = Util.null2String(request.getParameter("type"));//1.公司 , 2分部, 3.部门, 4.人员
		String pid = Util.null2String(request.getParameter("pid"));
		List<Map<String, Object>> datas = new ArrayList<Map<String,Object>>();
		//如果启用了分权 有权限的分部和可以查看的分部  有权限的部门和可以查看的部门 字符串用逗号分隔
		String alllowsubcompanystr = "",alllowsubcompanyviewstr = "",alllowdepartmentstr = "",alllowdepartmentviewstr = "";
		boolean useAppDetach = false;//是否启用分权
		try{
			Class pvm = Class.forName("weaver.hrm.appdetach.AppDetachComInfo");
			Constructor constructor = pvm.getConstructor(User.class);
			Object AppDetachComInfo = constructor.newInstance(user);
			Method m = pvm.getDeclaredMethod("isUseAppDetach");
			useAppDetach = (Boolean)m.invoke(AppDetachComInfo);
			if(useAppDetach){
				Method m1 = pvm.getDeclaredMethod("getAlllowsubcompanyviewstr");
				alllowsubcompanyviewstr = (String)m1.invoke(AppDetachComInfo);
				Method m2 = pvm.getDeclaredMethod("getAlllowdepartmentviewstr");
				alllowdepartmentviewstr = (String)m2.invoke(AppDetachComInfo);
				Method m3 = pvm.getDeclaredMethod("getAlllowsubcompanystr");
				alllowsubcompanystr = (String)m3.invoke(AppDetachComInfo);
				Method m4 = pvm.getDeclaredMethod("getAlllowdepartmentstr");
				alllowdepartmentstr = (String)m4.invoke(AppDetachComInfo);
			}
		}catch(Exception e){
			//e.printStackTrace();
		}
		//System.out.println("useAppDetach========="+useAppDetach);
		//System.out.println("alllowsubcompanystr========="+alllowsubcompanystr);
		//System.out.println("alllowsubcompanyviewstr========="+alllowsubcompanyviewstr);
		//System.out.println("alllowdepartmentstr========="+alllowdepartmentstr);
		//System.out.println("alllowdepartmentviewstr========="+alllowdepartmentviewstr);
		if(type.equals("1")){
			pid = "0";
			CompanyComInfo companyComInfo = new CompanyComInfo();
			String companyname = companyComInfo.getCompanyname("1");//公司名称
			jo.put("companyname", FormatMultiLang.formatByUserid(companyname,user.getUID()+""));
			datas.addAll(getSubCompanyByTree(pid,user,alllowsubcompanystr,alllowdepartmentstr,alllowsubcompanyviewstr,alllowdepartmentviewstr));
		}else if(type.equals("2")){
			datas.addAll(getDepartmentByTree("0", pid,user,alllowdepartmentstr,alllowdepartmentviewstr));
			datas.addAll(getSubCompanyByTree(pid,user,alllowsubcompanystr,alllowdepartmentstr,alllowsubcompanyviewstr,alllowdepartmentviewstr));
		}else if(type.equals("3")){
			datas.addAll(getResourceByTree(pid,user.getUID()+""));
			datas.addAll(getDepartmentByTree(pid, null,user,alllowdepartmentstr,alllowdepartmentviewstr));
		}
		status = 0;
		//System.out.println(JSONArray.fromObject(datas));
		jo.put("orgList", JSONArray.fromObject(datas));
	}else if("getGroupData".equals(operation)){
		try {
			GroupAction ga = new GroupAction();
			List groups = ga.getGroupsByUser(user);
			jo.put("datas", JSONArray.fromObject(groups));
			status = 0;
		} catch (Exception ex) {
			msg = "当前Ecology版本不支持";
		}
	}else if("getGroupMembers".equals(operation)){
		String groupid = Util.null2String(request.getParameter("groupid"));
		try {
			RecordSet rs = new RecordSet();
			Map<String,Integer[]> hrmMobileShowMap = getHrmMobileShowMap("");
			String sql = "select h1.userid from hrmgroupmembers h1,HrmResource h2 where h1.userid=h2.id and "+
					"(h2.status = 0 or h2.status = 1 or h2.status = 2 or h2.status = 3) and groupid=" +groupid+ 
					" order by h2.dsporder"; 
			int ifgldc = Util.getIntValue(Prop.getPropValue("wx_hrmbrowser","ifgldc"),0);//是否是格力地产客户
			if(ifgldc==1){
				sql = "select h1.userid,c.field11,c.field12,c.field13,c.field14,c.field15,c.field16"+
					" from hrmgroupmembers h1,HrmResource h2"+
					" left join cus_fielddata c on h2.id = c.id and c.scope = 'HrmCustomFieldByInfoType' and c.scopeid = -1"+
					" where h1.userid=h2.id and (h2.status = 0 or h2.status = 1 or h2.status = 2 or h2.status = 3)"+
					" and groupid=" +groupid+ " order by h2.dsporder";
			}
		    rs.executeSql(sql);
		    ResourceComInfo resourceComInfo = new ResourceComInfo();
			DepartmentComInfo departmentComInfo = new DepartmentComInfo();
			SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
			JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
			LocationComInfo lci = new LocationComInfo();
			JSONArray selectedArr = new JSONArray();
			String userkeytype = InterfaceUtil.getUserkeytype();
		    while(rs.next()){
		    	String userid = Util.null2String(rs.getString("userid"));
		    	JSONObject selectedObj = getUserJson(userid,resourceComInfo,departmentComInfo,subCompanyComInfo,
		    			jobTitlesComInfo,lci,hrmMobileShowMap,user.getUID()+"",userkeytype);
		    	if(ifgldc==1){
					String field11 = Util.null2String(rs.getString("field11"));
					String field12 = Util.null2String(rs.getString("field12"));
					String field13 = Util.null2String(rs.getString("field13"));
					String field14 = Util.null2String(rs.getString("field14"));
					String field15 = Util.null2String(rs.getString("field15"));
					String field16 = Util.null2String(rs.getString("field16"));
					selectedObj.put("field11",field11);
					selectedObj.put("field12",field12);
					selectedObj.put("field13",field13);
					selectedObj.put("field14",field14);
					selectedObj.put("field15",field15);
					String f16Name = "";
					if(!"".equals(field16)){
						String f16[] = field16.split(",");
						for(String s:f16){
							f16Name+=jobTitlesComInfo.getJobTitlesname(s)+"&nbsp;";
						}
					}
					selectedObj.put("field16",f16Name);
				}
				selectedArr.add(selectedObj);
		    }
			jo.put("groupList",selectedArr);
			status = 0;
		}catch (Exception ex) {
			msg = "获取数据失败:"+ex.getMessage();
		}
	}else if("getLastContract".equals(operation)){
		String searchKey = Util.null2String(request.getParameter("keyword"));
		RecordSet rs = new RecordSet();
		String sql = "select t.selectid from HrmResourceSelectRecord t,HrmResource h where t.selectid = h.id and t.resourceid = "
					+user.getUID()+" and (h.status =0 or h.status =1 or h.status =2 or h.status =3)";
		int ifgldc = Util.getIntValue(Prop.getPropValue("wx_hrmbrowser","ifgldc"),0);//是否是格力地产客户
		if(ifgldc==1){
			sql = "select t.selectid,c.field11,c.field12,c.field13,c.field14,c.field15,c.field16"+
				" from HrmResourceSelectRecord t,HrmResource h"+
				" left join cus_fielddata c on h.id = c.id and c.scope = 'HrmCustomFieldByInfoType' and c.scopeid = -1"+
				" where t.selectid = h.id and t.resourceid = "+user.getUID()+
				" and (h.status =0 or h.status =1 or h.status =2 or h.status =3)";
		}
		if(!searchKey.equals("")){
			sql += " and (h.pinyinlastname like '%"+searchKey+"%' or h.lastname like '%"+searchKey+"%' or h.mobile like '%"+searchKey+"%')";
		}
		sql += " order by t.id desc";
		//System.out.println(sql);
		rs.executeSql(sql);
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
		JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
		LocationComInfo lci = new LocationComInfo();
		Map<String,Integer[]> hrmMobileShowMap = getHrmMobileShowMap("");
		JSONArray selectedArr = new JSONArray();
		String userkeytype = InterfaceUtil.getUserkeytype();
		while(rs.next()){
			String userid = Util.null2String(rs.getString("selectid"));
			JSONObject selectedObj = getUserJson(userid,resourceComInfo,departmentComInfo,subCompanyComInfo,
	    			jobTitlesComInfo,lci,hrmMobileShowMap,user.getUID()+"",userkeytype);
			if(ifgldc==1){
				String field11 = Util.null2String(rs.getString("field11"));
				String field12 = Util.null2String(rs.getString("field12"));
				String field13 = Util.null2String(rs.getString("field13"));
				String field14 = Util.null2String(rs.getString("field14"));
				String field15 = Util.null2String(rs.getString("field15"));
				String field16 = Util.null2String(rs.getString("field16"));
				selectedObj.put("field11",field11);
				selectedObj.put("field12",field12);
				selectedObj.put("field13",field13);
				selectedObj.put("field14",field14);
				selectedObj.put("field15",field15);
				String f16Name = "";
				if(!"".equals(field16)){
					String f16[] = field16.split(",");
					for(String s:f16){
						f16Name+=jobTitlesComInfo.getJobTitlesname(s)+"&nbsp;";
					}
				}
				selectedObj.put("field16",f16Name);
			}
			selectedArr.add(selectedObj);
		}
		jo.put("groupList",selectedArr);
		status = 0;
	}else if("getUserDetail".equals(operation)){
		String userid = Util.null2String(request.getParameter("userid"));
		if("".equals(userid)) userid = user.getUID()+"";
		if(!"".equals(userid)){
			ResourceComInfo resourceComInfo = new ResourceComInfo();
			DepartmentComInfo departmentComInfo = new DepartmentComInfo();
			SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
			JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
			LocationComInfo lci = new LocationComInfo();
			String userkeytype = InterfaceUtil.getUserkeytype();
			Map<String,Integer[]> hrmMobileShowMap = getHrmMobileShowMap("");
			JSONObject userJson = getUserJson(userid,resourceComInfo,departmentComInfo,subCompanyComInfo,
	    			jobTitlesComInfo,lci,hrmMobileShowMap,user.getUID()+"",userkeytype);
			jo.put("user", userJson);
			status = 0;
		}else{
			msg = "没有获取到用户信息";
		}
	}else if("getUserDetailEn".equals(operation)){
		String userid = Util.null2String(request.getParameter("userid"));
		if("".equals(userid)) userid = user.getUID()+"";
		if(!"".equals(userid)){
			JSONObject selectedObj = new JSONObject();
			selectedObj.put("id", userid);	//id
			ResourceComInfo resourceComInfo = new ResourceComInfo();
			DepartmentComInfo departmentComInfo = new DepartmentComInfo();
			SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
			String lastname = resourceComInfo.getLastname(userid);	//姓名
			String subCompanyID = resourceComInfo.getSubCompanyID(userid);	//分部id
			String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);	//分部名称
			String departmentID = resourceComInfo.getDepartmentID(userid);	//部门id
			String departmentName = departmentComInfo.getDepartmentname(departmentID);	//部门名称
			String messageurls = Util.null2String(resourceComInfo.getMessagerUrls(userid));//头像
			selectedObj.put("lastname", FormatMultiLang.format(lastname,"8"));	//姓名
			selectedObj.put("subCompanyName", FormatMultiLang.format(subCompanyName,"8"));//分部名称
			selectedObj.put("departmentName", FormatMultiLang.format(departmentName,"8"));//部门名称
			selectedObj.put("messagerurl", messageurls);	//头像
			jo.put("user", selectedObj);
			status = 0;
		}else{
			msg = "没有获取到用户信息";
		}
	}
}catch(Exception e){
	msg = "操作失败:"+e.getMessage();
}
jo.put("ifLastContract", WxModuleInit.ifLastContract);
jo.put("status", status);
jo.put("msg", msg);
out.print(jo.toString());
%>
<%!
public JSONObject getUserJson(String userid,ResourceComInfo resourceComInfo,DepartmentComInfo departmentComInfo,
		SubCompanyComInfo subCompanyComInfo,JobTitlesComInfo jobTitlesComInfo,LocationComInfo lci,
		Map<String,Integer[]> hrmMobileShowMap,String curUserid,String userkeytype){
	String lastname = resourceComInfo.getLastname(userid);	//姓名
	String subCompanyID = resourceComInfo.getSubCompanyID(userid);	//分部id
	String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);	//分部名称
	String departmentID = resourceComInfo.getDepartmentID(userid);	//部门id
	String departmentName = departmentComInfo.getDepartmentname(departmentID);	//部门名称
	String jobTitle = resourceComInfo.getJobTitle(userid);	//岗位id
	String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//岗位名称
	String messageurls = Util.null2String(resourceComInfo.getMessagerUrls(userid));//头像
	String statusname = getStatusName(resourceComInfo.getStatus(userid));
	String managername = resourceComInfo.getLastname(resourceComInfo.getManagerID(userid));
	String managerid = resourceComInfo.getManagerID(userid);
	String wordaddress = lci.getLocationname(resourceComInfo.getLocationid(userid));
	String tel = resourceComInfo.getTelephone(userid);
	String mobile = resourceComInfo.getMobile(userid);
	String email = resourceComInfo.getEmail(userid);
	JSONObject selectedObj = new JSONObject();
	selectedObj.put("id", userid);	//id
	selectedObj.put("lastname", FormatMultiLang.formatByUserid(lastname,curUserid));	//姓名
	selectedObj.put("subCompanyName", FormatMultiLang.formatByUserid(subCompanyName,curUserid));//分部名称
	selectedObj.put("departmentName", FormatMultiLang.formatByUserid(departmentName,curUserid));//部门名称
	selectedObj.put("jobTitlesName", FormatMultiLang.formatByUserid(jobTitlesName,curUserid));//岗位名称
	selectedObj.put("messagerurl", messageurls);	//头像
	selectedObj.put("statusname", statusname);	//状态名称
	selectedObj.put("managername", managername);	//上级名称
	selectedObj.put("wordaddress", wordaddress);	//工作地点
	selectedObj.put("tel", dealTel(tel,userid,curUserid));//办公电话
	selectedObj.put("mobile", dealMobile(hrmMobileShowMap,mobile,userid,curUserid));//手机
	selectedObj.put("email", dealEmail(email,userid,curUserid));	//邮箱
	selectedObj.put("managerid", managerid);//上级ID
	String userkey = userid;
	if(userkeytype.equals("loginid")){
		userkey = InterfaceUtil.transUserId(userkey, 1);
	}
	selectedObj.put("userkey", userkey);//用户唯一标识
	return selectedObj;
}
%>