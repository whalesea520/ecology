<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="java.lang.reflect.Constructor"%>
<%@ page import="weaver.hrm.company.DepartmentComInfo" %>
<%@ page import="weaver.hrm.company.SubCompanyComInfo" %>
<%@ page import="weaver.hrm.job.JobTitlesComInfo" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%@ page import="weaver.wxinterface.FormatMultiLang"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.hrm.group.GroupAction"%>
<%@ page import="weaver.file.Prop"%>
<%!
private Map<String, Object> getHrmMap(String id,String lastname,String status,String subCompanyID,String departmentID,
		String jobTitle,String subCompanyName,String departmentName,String jobTitlesName, String messagerurl){
	Map<String, Object> hrmMap = null;
    if(status.equals("0") || status.equals("1") || status.equals("2") || status.equals("3")){
    	hrmMap = new HashMap<String, Object>();
		hrmMap.put("id", id);	//id
		hrmMap.put("lastname", lastname);	//����
		hrmMap.put("name", lastname);	//����
		hrmMap.put("type", "4");
		//hrmMap.put("subCompanyID", subCompanyID);	//�ֲ�id
		hrmMap.put("subCompanyName", subCompanyName);	//�ֲ�����
		hrmMap.put("departmentID", departmentID);	//����id
		hrmMap.put("departmentName", departmentName);	//��������
		//hrmMap.put("jobTitle", jobTitle);	//��λid
		hrmMap.put("jobTitlesName", jobTitlesName);	//��λ����
		hrmMap.put("messagerurl", messagerurl);	//ͷ��
    }
    return hrmMap;
}
private String getAllSupDepartment(String subId,DepartmentComInfo rs,int loopLevel){
    String str = "";
    try{
	    if(rs==null){
	        rs = new DepartmentComInfo();
	    }
	    String depid = rs.getDepartmentsupdepid(subId);
	    if (depid==null||depid.equals("") || depid.equals("0")||depid.equals(subId)
	    		||(","+str).indexOf(","+depid+",")>-1||loopLevel>10000)
	        return str;
	    str += depid + ",";
	    loopLevel++;
	    str += getAllSupDepartment(depid,rs,loopLevel);
	}catch(Exception e){
		
	}
    return str;
}
//��ȡdeptid��������������
private String getAllChildDepartId(String deptid, String ids){
	try{
		StringBuffer sql = new StringBuffer();
		RecordSet rs = new RecordSet();
		String dbType = rs.getDBType();
		if("oracle".equalsIgnoreCase(dbType)){
			sql.setLength(0);
			sql.append(" select id, departmentname, supdepid, subcompanyid1 ").
			append("   from hrmdepartment                                      ").
			append("  where (canceled != 1 or canceled is null)                ").
			append("  start with id = '").append(deptid).append("'").
			append(" connect by prior id = supdepid                         ");
		}else if("sqlserver".equalsIgnoreCase(dbType)){
			sql.setLength(0);
			sql.append(" WITH allsub(id,departmentname,supdepid,subcompanyid1)").
			append(" as ( SELECT id,departmentname ,supdepid,subcompanyid1 FROM hrmdepartment where id=").append(deptid).append("  and (canceled  !=1 or canceled is null)").
			append(" UNION ALL SELECT a.id,a.departmentname,a.supdepid,a.subcompanyid1 FROM hrmdepartment a,allsub b where a.supdepid=b.id and (canceled  !=1 or canceled is null)").
			append(" ) select * from allsub  ");
		}
		rs.executeSql(sql.toString());
		while(rs.next()){
			String depart = rs.getString("id");
			if(depart.equals(deptid)) continue;
			ids += ","+ depart;
		}
	}catch(Exception e){
		
	}
	return ids;
}
private int initHrmList(String userid,String deptId,String searchKey,int showSubUser,int issubcompany,int pageNo,int pageSize,List<Map<String, Object>> hrmList,boolean ifSameDept){
	int iTotal = 0;
	try{
		String whereSql = "";//�����Ȩ����
		try{
			Class pvm = Class.forName("weaver.hrm.appdetach.AppDetachComInfo");
			Method m = pvm.getDeclaredMethod("getScopeSqlByHrmResourceSearch",String.class);
			whereSql = (String)m.invoke(pvm.newInstance(),userid);
		}catch(Exception e){
			//System.out.println("��ȡ��ѯSQL����:"+e.getMessage());
			//e.printStackTrace();
		}
		RecordSet rs = new RecordSet();
		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
		JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
		ResourceComInfo resourceComInfo2 = new ResourceComInfo();
		String orderSql = " order by dsporder,id";
		String orderSql2 = " order by dsporder desc,id desc";
		String fromSql = " from HrmResource where (status =0 or status =1 or status =2 or status =3)";
		if(!whereSql.equals("")){
			fromSql += " and "+whereSql;
		}
		if(!searchKey.equals("")){
			fromSql += " and (pinyinlastname like '%"+searchKey+"%' or lastname like '%"+searchKey
					+"%' or mobile like '%"+searchKey+"%' or telephone like '%"+searchKey+"%')";
		}
		if(showSubUser==1){//ֻ��ѯ��ǰ��Ա��������Ա
			fromSql += " and managerstr like '%,"+userid+",%'";
		}
		if(issubcompany==1){//ֻ��ѯ��ǰ�ֲ��µ���Ա
			fromSql += " and subcompanyid1 = "+resourceComInfo2.getSubCompanyID(userid);
		}
		String sql = "";
		if(!deptId.equals("")&&deptId.indexOf(",")<0){//��ѯ�����µ���Աʱ��ʹ�÷�ҳ ������ǵ����ŵ�ID
			int ifAllDept = Util.getIntValue(Prop.getPropValue("wx_hrmbrowser","ifAllDept"),0);
			if(ifSameDept&&ifAllDept==1){//��ѯ�ò��Ŷ������ż����������в��ŵ���Ա
				String supIds = this.getAllSupDepartment(deptId+"",null,1);
				if(supIds.startsWith(","))supIds=supIds.substring(1,supIds.length());
				if(supIds.endsWith(","))supIds=supIds.substring(0,supIds.length()-1);
				String supid = "";//�������
				if(supIds.equals("")) {
					supid = deptId;
				}else{
					String[] tmp = supIds.split(",");
					supid = tmp[tmp.length-1];
				}
				String allSubIds = "";
				allSubIds = this.getAllChildDepartId(supid,allSubIds);
				if(allSubIds.equals("")) allSubIds=supid;
				if(allSubIds.startsWith(",")){
					allSubIds = supid+allSubIds;
				}
				fromSql += " and departmentid in ("+allSubIds+")";
			}else{
				fromSql += " and departmentid = "+deptId;
			}
			sql = "select * "+fromSql+orderSql;
		}else{
			if(!deptId.equals("")&&deptId.indexOf(",")>-1){
				fromSql += " and departmentid in ("+deptId+")";
			}
			rs.executeSql("select count(id) "+fromSql);
			if(rs.next()) iTotal = rs.getInt(1);
			int totalpage = iTotal / pageSize;
			if(iTotal % pageSize >0) totalpage += 1;
			if(pageNo>totalpage) pageNo = 1;
			int iNextNum = pageNo * pageSize;
			int ipageset = pageSize;
			if(iTotal - iNextNum + pageSize < pageSize) ipageset = iTotal - iNextNum + pageSize;
			if(iTotal < pageSize) ipageset = iTotal;
			sql = "select top " + ipageset +" A.* from (select top "+ iNextNum +" * "+fromSql+ orderSql + ") A "+orderSql2;
			sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderSql;
			if(rs.getDBType().equals("oracle")){
				sql = "select * "+fromSql+ orderSql;
				sql = "select tt2.*,rownum rn from (" + sql + ") tt2 where rownum <= " + iNextNum;
				sql = "select tt3.* from (" + sql + ") tt3 where rn > " + (iNextNum - pageSize);
			}
		}
		//System.out.println(sql);
		rs.executeSql(sql);
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
			String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);//�ֲ�����
			String departmentName = departmentComInfo.getDepartmentname(departmentID);//��������
			String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//��λ����
			String managername = resourceComInfo2.getLastname(managerid);
			String accounttype = Util.null2String(rs.getString("accounttype"));//�˺����� 1Ϊ���˺�
			String belongto = Util.null2String(rs.getString("belongto"));
			if(!"1".equals(accounttype)) belongto = "";
			Map<String, Object> hrmMap = getHrmMap(id, 
					FormatMultiLang.format(lastname,"8"),status, subCompanyID, 
					departmentID,jobTitle, 
					FormatMultiLang.format(subCompanyName,"8"), 
					FormatMultiLang.format(departmentName,"8"),
					FormatMultiLang.format(jobTitlesName,"8"), messagerurl);
			if(null!=hrmMap){
				hrmList.add(hrmMap);
			}
		}
	}catch(Exception ex){}
	return iTotal;
}

private void clearCache(){
	/* if(hrmList != null){
		hrmList.clear();
		hrmList = null;
	} */
}

private List<Map<String, Object>> getSubCompanyByTree(String pid,User user,String alllowsubcompanystr,String alllowdepartmentstr,
		String alllowsubcompanyviewstr,String alllowdepartmentviewstr) throws Exception{
	List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
	SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
	subCompanyComInfo.setTofirstRow();
	while(subCompanyComInfo.next()){
		String supsubcomid = subCompanyComInfo.getSupsubcomid();
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
        map.put("name", FormatMultiLang.format(name,"8"));
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
		String supdepid = departmentComInfo.getDepartmentsupdepid();	//�ϼ�����id
		if(supdepid==null||supdepid.equals("")){
			supdepid = "0";
		}
		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//�ֲ�id
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
        map.put("name", FormatMultiLang.format(name,"8"));
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
		String supdepid = departmentComInfo.getDepartmentsupdepid();	//�ϼ�����id
		if(supdepid==null||supdepid.equals("")){
			supdepid = "0";
		}
		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//�ֲ�id
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
	initHrmList(userid,deptId,"",0,0,0,0,list,false);
	return list;
}

private boolean hasChildResource(String deptId,String userid) throws Exception{
	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
	initHrmList(userid,deptId,"",0,0,0,0,list,false);
	if(list.size()>0){
		return true;
	}
	return false;
}
	
private String getMessagerurl(String url){
	url = Util.null2String(url);
	if(url.endsWith("dummyContact_wev8.png") || url.endsWith("dummyContact.png")){
		url = "";
	}
	return url;
}
%>
<%
//�жϱ���
if(WxInterfaceInit.isIsutf8()){
	response.setContentType("application/json;charset=UTF-8");
}
String action = Util.null2String(request.getParameter("action"));
if("getListData".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		String searchKey = "";
		try {
			searchKey = URLDecoder.decode(Util.null2String(request.getParameter("searchKey")), "utf-8");
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		int pageNo = Util.getIntValue(request.getParameter("pageNo"), 1);
		int pageSize = Util.getIntValue(request.getParameter("pageSize"),50);
		int showSubUser = Util.getIntValue(request.getParameter("showSubUser"), 0);
		int issubcompany = Util.getIntValue(request.getParameter("issubcompany"), 0);
		String deptids = Util.null2String(request.getParameter("deptids"));
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		int totalSize = initHrmList(user.getUID()+"",deptids,searchKey,showSubUser,issubcompany,pageNo,pageSize,list,false);
		resultObj.put("totalSize", totalSize);
		resultObj.put("datas", JSONArray.fromObject(list));
		resultObj.put("status", "1");
	} catch (Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
}else if("getDeptData".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		initHrmList(user.getUID()+"",user.getUserDepartment()+"","",0,0,0,0,list,true);
		resultObj.put("datas", JSONArray.fromObject(list));
		resultObj.put("status", "1");
	} catch (Exception ex) {
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
}else if("getLastHrmData".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		RecordSet rs = new RecordSet();
		String sql = "SELECT t.* FROM HrmResourceSelectRecord t,HrmResource h where t.selectid = h.id and t.resourceid = "
				+user.getUID()+" and (h.status =0 or h.status =1 or h.status =2 or h.status =3) order by t.id desc";
		rs.executeSql(sql);
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
		JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
		JSONArray selectedArr = new JSONArray();
		while(rs.next()){
			String userid = Util.null2String(rs.getString("selectid"));
			String lastname = resourceComInfo.getLastname(userid);	//����
			String subCompanyID = resourceComInfo.getSubCompanyID(userid);	//�ֲ�id
			String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);	//�ֲ�����
			String departmentID = resourceComInfo.getDepartmentID(userid);	//����id
			String departmentName = departmentComInfo.getDepartmentname(departmentID);	//��������
			String jobTitle = resourceComInfo.getJobTitle(userid);	//��λid
			String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//��λ����
			String messagerurl = this.getMessagerurl(resourceComInfo.getMessagerUrls(userid));//ͷ��
			JSONObject selectedObj = new JSONObject();
			selectedObj.put("id", userid);	//id
			selectedObj.put("lastname", FormatMultiLang.format(lastname,"8"));	//����
			selectedObj.put("subCompanyName", FormatMultiLang.format(subCompanyName,"8"));//�ֲ�����
			selectedObj.put("departmentName", FormatMultiLang.format(departmentName,"8"));//��������
			selectedObj.put("jobTitlesName", FormatMultiLang.format(jobTitlesName,"8"));//��λ����
			selectedObj.put("messagerurl", messagerurl);//ͷ��
			selectedArr.add(selectedObj);
		}
		resultObj.put("datas", selectedArr);
		resultObj.put("status", "1");
	} catch (Exception ex) {
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
}else if("clearCache".equals(action)){
	try {
		clearCache();
		out.println("Clear Cache Success!");
	} catch (IOException e) {
		e.printStackTrace();
	}
}else if("getTreeData".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		
		String type = Util.null2String(request.getParameter("type"));	//1.��˾ , 2�ֲ�, 3.����, 4.��Ա
		String pid = Util.null2String(request.getParameter("pid"));
		List<Map<String, Object>> datas = new ArrayList<Map<String,Object>>();
		//��������˷�Ȩ ��Ȩ�޵ķֲ��Ϳ��Բ鿴�ķֲ�  ��Ȩ�޵Ĳ��źͿ��Բ鿴�Ĳ��� �ַ����ö��ŷָ�
		String alllowsubcompanystr = "",alllowsubcompanyviewstr = "",alllowdepartmentstr = "",alllowdepartmentviewstr = "";
		boolean useAppDetach = false;//�Ƿ����÷�Ȩ
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
		if(type.equals("1")){
			pid = "0";
			datas.addAll(getSubCompanyByTree(pid,user,alllowsubcompanystr,alllowdepartmentstr,alllowsubcompanyviewstr,alllowdepartmentviewstr));
		}else if(type.equals("2")){
			datas.addAll(getDepartmentByTree("0", pid,user,alllowdepartmentstr,alllowdepartmentviewstr));
			datas.addAll(getSubCompanyByTree(pid,user,alllowsubcompanystr,alllowdepartmentstr,alllowsubcompanyviewstr,alllowdepartmentviewstr));
		}else if(type.equals("3")){
			datas.addAll(getResourceByTree(pid,user.getUID()+""));
			datas.addAll(getDepartmentByTree(pid, null,user,alllowdepartmentstr,alllowdepartmentviewstr));
		}
		
		resultObj.put("datas", JSONArray.fromObject(datas));
		resultObj.put("status", "1");
		
	}  catch (Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
}else if("getSelectedDatas".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		JSONArray selectedArr = new JSONArray();
		String selectedIds = Util.null2String(request.getParameter("selectedIds")).trim();	//ѡ�е�id�����ŷָ����磺1,2,3
		if(!selectedIds.equals("")){
			ResourceComInfo resourceComInfo = new ResourceComInfo();
			DepartmentComInfo departmentComInfo = new DepartmentComInfo();
			SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
			JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
			
			String[] selectedIdArr = selectedIds.split(",");
			for(String selectedId : selectedIdArr){
				if(!selectedId.trim().equals("")){
					
					String lastname = resourceComInfo.getLastname(selectedId);	//����
					String subCompanyID = resourceComInfo.getSubCompanyID(selectedId);	//�ֲ�id
					String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);	//�ֲ�����
					
					String departmentID = resourceComInfo.getDepartmentID(selectedId);	//����id
					String departmentName = departmentComInfo.getDepartmentname(departmentID);	//��������
					
					String jobTitle = resourceComInfo.getJobTitle(selectedId);	//��λid
					String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//��λ����
					
					String messagerurl = this.getMessagerurl(resourceComInfo.getMessagerUrls(selectedId));//ͷ��
					
					JSONObject selectedObj = new JSONObject();
					selectedObj.put("id", selectedId);	//id
					selectedObj.put("lastname", FormatMultiLang.format(lastname,"8"));	//����
					selectedObj.put("subCompanyName", FormatMultiLang.format(subCompanyName,"8"));	//�ֲ�����
					selectedObj.put("departmentName", FormatMultiLang.format(departmentName,"8"));	//��������
					selectedObj.put("jobTitlesName", FormatMultiLang.format(jobTitlesName,"8"));	//��λ����
					selectedObj.put("messagerurl", messagerurl);	//ͷ��
					selectedArr.add(selectedObj);
				}
			}
		}
		resultObj.put("datas", selectedArr);
		resultObj.put("status", "1");
	} catch (Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
}else if("getGroupData".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		GroupAction ga = new GroupAction();
		List groups = ga.getGroupsByUser(user);
		resultObj.put("datas", JSONArray.fromObject(groups));
		resultObj.put("status", "1");
	} catch (Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
}else if("getGroupMembers".equals(action)){
	String groupid = Util.null2String(request.getParameter("groupid"));
	JSONObject resultObj = new JSONObject();
	try {
		RecordSet rs = new RecordSet();
		String sql = "select h1.userid from hrmgroupmembers h1,HrmResource h2 where h1.userid=h2.id and "+
				"(h2.status = 0 or h2.status = 1 or h2.status = 2 or h2.status = 3) and groupid=" +groupid+ 
				" order by h2.dsporder"; 
	    rs.executeSql(sql);
	    ResourceComInfo resourceComInfo = new ResourceComInfo();
		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
		JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
		JSONArray selectedArr = new JSONArray();
	    while(rs.next()){
	    	String userid = Util.null2String(rs.getString("userid"));
	    	String lastname = resourceComInfo.getLastname(userid);	//����
			String subCompanyID = resourceComInfo.getSubCompanyID(userid);	//�ֲ�id
			String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);	//�ֲ�����
			
			String departmentID = resourceComInfo.getDepartmentID(userid);	//����id
			String departmentName = departmentComInfo.getDepartmentname(departmentID);	//��������
			
			String jobTitle = resourceComInfo.getJobTitle(userid);	//��λid
			String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//��λ����
			
			String messagerurl = this.getMessagerurl(resourceComInfo.getMessagerUrls(userid));//ͷ��
			
			JSONObject selectedObj = new JSONObject();
			selectedObj.put("id", userid);	//id
			selectedObj.put("lastname", FormatMultiLang.format(lastname,"8"));	//����
			selectedObj.put("subCompanyName", FormatMultiLang.format(subCompanyName,"8"));	//�ֲ�����
			selectedObj.put("departmentName", FormatMultiLang.format(departmentName,"8"));	//��������
			selectedObj.put("jobTitlesName", FormatMultiLang.format(jobTitlesName,"8"));	//��λ����
			selectedObj.put("messagerurl", messagerurl);	//ͷ��
			selectedArr.add(selectedObj);
	    }
		resultObj.put("datas",selectedArr);
		resultObj.put("status", "1");
	} catch (Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
}
%>