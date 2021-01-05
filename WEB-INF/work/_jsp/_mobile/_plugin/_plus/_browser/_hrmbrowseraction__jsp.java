/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._mobile._plugin._plus._browser;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import weaver.hrm.*;
import weaver.systeminfo.*;
import weaver.general.StaticObj;
import weaver.general.Util;
import weaver.hrm.settings.RemindSettings;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.general.*;
import java.lang.reflect.Method;
import java.lang.reflect.Constructor;
import weaver.hrm.company.DepartmentComInfo;
import weaver.hrm.company.SubCompanyComInfo;
import weaver.hrm.job.JobTitlesComInfo;
import weaver.hrm.resource.ResourceComInfo;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import weaver.wxinterface.WxInterfaceInit;
import weaver.wxinterface.FormatMultiLang;
import weaver.conn.RecordSet;
import weaver.hrm.group.GroupAction;
import weaver.file.Prop;

public class _hrmbrowseraction__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  private Map<String, Object> getHrmMap(String id,String lastname,String status,String subCompanyID,String departmentID,
  		String jobTitle,String subCompanyName,String departmentName,String jobTitlesName, String messagerurl){
  	Map<String, Object> hrmMap = null;
      if(status.equals("0") || status.equals("1") || status.equals("2") || status.equals("3")){
      	hrmMap = new HashMap<String, Object>();
  		hrmMap.put("id", id);	//id
  		hrmMap.put("lastname", lastname);	//\u59d3\u540d
  		hrmMap.put("name", lastname);	//\u59d3\u540d
  		hrmMap.put("type", "4");
  		//hrmMap.put("subCompanyID", subCompanyID);	//\u5206\u90e8id
  		hrmMap.put("subCompanyName", subCompanyName);	//\u5206\u90e8\u540d\u79f0
  		hrmMap.put("departmentID", departmentID);	//\u90e8\u95e8id
  		hrmMap.put("departmentName", departmentName);	//\u90e8\u95e8\u540d\u79f0
  		//hrmMap.put("jobTitle", jobTitle);	//\u5c97\u4f4did
  		hrmMap.put("jobTitlesName", jobTitlesName);	//\u5c97\u4f4d\u540d\u79f0
  		hrmMap.put("messagerurl", messagerurl);	//\u5934\u50cf
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
  //\u83b7\u53d6deptid\u7684\u6240\u6709\u4e0b\u5c5e\u90e8\u95e8
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
  		String whereSql = "";//\u52a0\u5165\u5206\u6743\u63a7\u5236
  		try{
  			Class pvm = Class.forName("weaver.hrm.appdetach.AppDetachComInfo");
  			Method m = pvm.getDeclaredMethod("getScopeSqlByHrmResourceSearch",String.class);
  			whereSql = (String)m.invoke(pvm.newInstance(),userid);
  		}catch(Exception e){
  			//System.out.println("\u83b7\u53d6\u67e5\u8be2SQL\u51fa\u9519:"+e.getMessage());
  			//e.printStackTrace();
  		}
  		RecordSet rs = new RecordSet();
  		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
  		SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
  		JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
  		ResourceComInfo resourceComInfo2 = new ResourceComInfo();
  		String orderSql = " order by dsporder,id";
  		String orderSql2 = " order by dsporder desc,id desc";
  		String fromSql = " from HrmResource";
  		String selectField = " ";
  		int ifLpkj = Util.getIntValue(Prop.getPropValue("wx_hrmbrowser","ifLpkj"),0);//\u662f\u5426\u662f\u96f6\u8dd1\u79d1\u6280
  		int ifBsite = Util.getIntValue(Prop.getPropValue("wx_hrmbrowser","ifBsite"),0);//\u662f\u5426\u662fB\u7ad9\u5ba2\u6237
  		if(ifBsite==1){
  			selectField = ",c.field27 ";
  			fromSql += " left join cus_fielddata c on hrmresource.id = c.id and c.scope = 'HrmCustomFieldByInfoType' and c.scopeid = -1";
  		}
  		fromSql += " where (status =0 or status =1 or status =2 or status =3)";
  		if(!whereSql.equals("")){
  			if(ifLpkj!=1||searchKey.equals("")){
  				fromSql += " and "+whereSql;
  			}
  		}
  		if(!searchKey.equals("")){
  			if(ifBsite==1){//B\u7ad9\u5ba2\u6237
  				//field22 \u59d3\u540d\u5b57\u6bb5 field27 \u59d3\u540d\u5168\u62fc\u5b57\u6bb5 fullpinyinlastname\u6635\u79f0\u5168\u62fc
  				fromSql += " and (pinyinlastname like '%"+searchKey+"%' or lastname like '%"+searchKey
  						+"%' or mobile like '%"+searchKey+"%' or telephone like '%"+searchKey
  						+"%' or fullpinyinlastname like '%"+searchKey
  						+"%' or c.field27 like '%"+searchKey.toLowerCase()+"%')";
  			}else{
  				fromSql += " and (pinyinlastname like '%"+searchKey+"%' or lastname like '%"+searchKey
  						+"%' or mobile like '%"+searchKey+"%' or telephone like '%"+searchKey+"%')";
  			}
  		}
  		if(showSubUser==1){//\u53ea\u67e5\u8be2\u5f53\u524d\u4eba\u5458\u7684\u4e0b\u5c5e\u4eba\u5458
  			fromSql += " and managerstr like '%,"+userid+",%'";
  		}
  		if(issubcompany==1){//\u53ea\u67e5\u8be2\u5f53\u524d\u5206\u90e8\u4e0b\u7684\u4eba\u5458
  			fromSql += " and subcompanyid1 = "+resourceComInfo2.getSubCompanyID(userid);
  		}
  		String sql = "";
  		if(!deptId.equals("")&&deptId.indexOf(",")<0){//\u67e5\u8be2\u90e8\u95e8\u4e0b\u7684\u4eba\u5458\u65f6\u4e0d\u4f7f\u7528\u5206\u9875 \u4f20\u5165\u7684\u662f\u5355\u90e8\u95e8\u7684ID
  			int ifAllDept = Util.getIntValue(Prop.getPropValue("wx_hrmbrowser","ifAllDept"),0);
  			if(ifSameDept&&ifAllDept==1){//\u67e5\u8be2\u8be5\u90e8\u95e8\u9876\u7ea7\u90e8\u95e8\u53ca\u5176\u4e0b\u5c5e\u6240\u6709\u90e8\u95e8\u7684\u4eba\u5458
  				String supIds = this.getAllSupDepartment(deptId+"",null,1);
  				if(supIds.startsWith(","))supIds=supIds.substring(1,supIds.length());
  				if(supIds.endsWith(","))supIds=supIds.substring(0,supIds.length()-1);
  				String supid = "";//\u6700\u9876\u7ea7\u90e8\u95e8
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
  			sql = "select hrmresource.*"+selectField+fromSql+" order by hrmresource.dsporder,hrmresource.id";
  		}else{
  			if(!deptId.equals("")&&deptId.indexOf(",")>-1){
  				fromSql += " and departmentid in ("+deptId+")";
  			}
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
  			String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);//\u5206\u90e8\u540d\u79f0
  			String departmentName = departmentComInfo.getDepartmentname(departmentID);//\u90e8\u95e8\u540d\u79f0
  			String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//\u5c97\u4f4d\u540d\u79f0
  			String managername = resourceComInfo2.getLastname(managerid);
  			String accounttype = Util.null2String(rs.getString("accounttype"));//\u8d26\u53f7\u7c7b\u578b 1\u4e3a\u6b21\u8d26\u53f7
  			String belongto = Util.null2String(rs.getString("belongto"));
  			if(!"1".equals(accounttype)) belongto = "";
  			Map<String, Object> hrmMap = getHrmMap(id, 
  					FormatMultiLang.formatByUserid(lastname,userid),status, subCompanyID, 
  					departmentID,jobTitle, 
  					FormatMultiLang.formatByUserid(subCompanyName,userid), 
  					FormatMultiLang.formatByUserid(departmentName,userid),
  					FormatMultiLang.formatByUserid(jobTitlesName,userid), messagerurl);
  			if(null!=hrmMap){
  				if(ifBsite==1){
  					String field27 = Util.null2String(rs.getString("field27"));
  					hrmMap.put("field27",field27);
  				}
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
  		String supdepid = departmentComInfo.getDepartmentsupdepid();	//\u4e0a\u7ea7\u90e8\u95e8id
  		if(supdepid==null||supdepid.equals("")){
  			supdepid = "0";
  		}
  		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//\u5206\u90e8id
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
  		String supdepid = departmentComInfo.getDepartmentsupdepid();	//\u4e0a\u7ea7\u90e8\u95e8id
  		if(supdepid==null||supdepid.equals("")){
  			supdepid = "0";
  		}
  		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//\u5206\u90e8id
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

  
  public void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response)
    throws java.io.IOException, javax.servlet.ServletException
  {
    javax.servlet.http.HttpSession session = request.getSession(true);
    com.caucho.server.webapp.WebApp _jsp_application = _caucho_getApplication();
    javax.servlet.ServletContext application = _jsp_application;
    com.caucho.jsp.PageContextImpl pageContext = _jsp_application.getJspApplicationContext().allocatePageContext(this, _jsp_application, request, response, null, session, 8192, true, false);
    javax.servlet.jsp.PageContext _jsp_parentContext = pageContext;
    javax.servlet.jsp.JspWriter out = pageContext.getOut();
    final javax.el.ELContext _jsp_env = pageContext.getELContext();
    javax.servlet.ServletConfig config = getServletConfig();
    javax.servlet.Servlet page = this;
    response.setContentType("text/html; charset=GBK");
    request.setCharacterEncoding("GBK");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	Log logger= LogFactory.getLog(this.getClass());
	String isIE = (String)session.getAttribute("browser_isie");

      out.write(_jsp_string1, 0, _jsp_string1.length);
      
//\u5224\u65ad\u7f16\u7801
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
		String towernodeid = Util.null2String(request.getParameter("towernodeid"));
		String toweroperatetype = Util.null2String(request.getParameter("toweroperatetype"));
		
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		int totalSize = 0;
		if(!"".equals(towernodeid)){//20180212 zhw \u4e2d\u56fd\u94c1\u5854\u7528\u6237\u8f6c\u529e\u63a7\u5236\u8303\u56f4
			try{//\u53cd\u5c04\u8c03\u7528\u4eba\u529b\u8d44\u6e90\u63a5\u53e3\u83b7\u53d6\u4eba\u5458
				Class ta = Class.forName("weaver.temple.TempleAction");
				Method m = ta.getDeclaredMethod("initHrmList",String.class,String.class,String.class,int.class,int.class,List.class,String.class);
				totalSize = (Integer)m.invoke(ta.newInstance(),user.getUID()+"",towernodeid,toweroperatetype,pageNo,pageSize,list,searchKey);
				BaseBean bb = new BaseBean();
				//bb.writeLog("===\u53cd\u5c04\u8c03\u7528\u4eba\u529b\u8d44\u6e90\u63a5\u53e3\u83b7\u53d6\u4eba\u5458\u6210\u529f===\u4eba\u5458\u603b\u6570\u3010"+totalSize+"\u3011");
				//bb.writeLog("===\u53cd\u5c04\u8c03\u7528\u4eba\u529b\u8d44\u6e90\u63a5\u53e3\u83b7\u53d6\u4eba\u5458\u6210\u529f===list\u5927\u5c0f\u3010"+list.size()+"\u3011");
			}catch(Exception e){
				new BaseBean().writeLog("===\u53cd\u5c04\u8c03\u7528\u4eba\u529b\u8d44\u6e90\u63a5\u53e3\u83b7\u53d6\u4eba\u5458\u5931\u8d25===\u3010"+e.getMessage()+"\u3011");
				e.printStackTrace();
			}
		}else{
			totalSize = initHrmList(user.getUID()+"",deptids,searchKey,showSubUser,issubcompany,pageNo,pageSize,list,false);
		}
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
			String lastname = resourceComInfo.getLastname(userid);	//\u59d3\u540d
			String subCompanyID = resourceComInfo.getSubCompanyID(userid);	//\u5206\u90e8id
			String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);	//\u5206\u90e8\u540d\u79f0
			String departmentID = resourceComInfo.getDepartmentID(userid);	//\u90e8\u95e8id
			String departmentName = departmentComInfo.getDepartmentname(departmentID);	//\u90e8\u95e8\u540d\u79f0
			String jobTitle = resourceComInfo.getJobTitle(userid);	//\u5c97\u4f4did
			String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//\u5c97\u4f4d\u540d\u79f0
			String messagerurl = this.getMessagerurl(resourceComInfo.getMessagerUrls(userid));//\u5934\u50cf
			JSONObject selectedObj = new JSONObject();
			selectedObj.put("id", userid);	//id
			selectedObj.put("lastname", FormatMultiLang.formatByUserid(lastname,user.getUID()+""));	//\u59d3\u540d
			selectedObj.put("subCompanyName", FormatMultiLang.formatByUserid(subCompanyName,user.getUID()+""));//\u5206\u90e8\u540d\u79f0
			selectedObj.put("departmentName", FormatMultiLang.formatByUserid(departmentName,user.getUID()+""));//\u90e8\u95e8\u540d\u79f0
			selectedObj.put("jobTitlesName", FormatMultiLang.formatByUserid(jobTitlesName,user.getUID()+""));//\u5c97\u4f4d\u540d\u79f0
			selectedObj.put("messagerurl", messagerurl);//\u5934\u50cf
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
		
		String type = Util.null2String(request.getParameter("type"));	//1.\u516c\u53f8 , 2\u5206\u90e8, 3.\u90e8\u95e8, 4.\u4eba\u5458
		String pid = Util.null2String(request.getParameter("pid"));
		List<Map<String, Object>> datas = new ArrayList<Map<String,Object>>();
		//\u5982\u679c\u542f\u7528\u4e86\u5206\u6743 \u6709\u6743\u9650\u7684\u5206\u90e8\u548c\u53ef\u4ee5\u67e5\u770b\u7684\u5206\u90e8  \u6709\u6743\u9650\u7684\u90e8\u95e8\u548c\u53ef\u4ee5\u67e5\u770b\u7684\u90e8\u95e8 \u5b57\u7b26\u4e32\u7528\u9017\u53f7\u5206\u9694
		String alllowsubcompanystr = "",alllowsubcompanyviewstr = "",alllowdepartmentstr = "",alllowdepartmentviewstr = "";
		boolean useAppDetach = false;//\u662f\u5426\u542f\u7528\u5206\u6743
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
		String selectedIds = Util.null2String(request.getParameter("selectedIds")).trim();	//\u9009\u4e2d\u7684id\uff0c\u9017\u53f7\u5206\u9694\uff0c\u5982\uff1a1,2,3
		if(!selectedIds.equals("")){
			ResourceComInfo resourceComInfo = new ResourceComInfo();
			DepartmentComInfo departmentComInfo = new DepartmentComInfo();
			SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
			JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
			
			String[] selectedIdArr = selectedIds.split(",");
			for(String selectedId : selectedIdArr){
				if(!selectedId.trim().equals("")){
					
					String lastname = resourceComInfo.getLastname(selectedId);	//\u59d3\u540d
					String subCompanyID = resourceComInfo.getSubCompanyID(selectedId);	//\u5206\u90e8id
					String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);	//\u5206\u90e8\u540d\u79f0
					
					String departmentID = resourceComInfo.getDepartmentID(selectedId);	//\u90e8\u95e8id
					String departmentName = departmentComInfo.getDepartmentname(departmentID);	//\u90e8\u95e8\u540d\u79f0
					
					String jobTitle = resourceComInfo.getJobTitle(selectedId);	//\u5c97\u4f4did
					String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//\u5c97\u4f4d\u540d\u79f0
					
					String messagerurl = this.getMessagerurl(resourceComInfo.getMessagerUrls(selectedId));//\u5934\u50cf
					
					JSONObject selectedObj = new JSONObject();
					selectedObj.put("id", selectedId);	//id
					selectedObj.put("lastname", FormatMultiLang.formatByUserid(lastname,user.getUID()+""));	//\u59d3\u540d
					selectedObj.put("subCompanyName", FormatMultiLang.formatByUserid(subCompanyName,user.getUID()+""));	//\u5206\u90e8\u540d\u79f0
					selectedObj.put("departmentName", FormatMultiLang.formatByUserid(departmentName,user.getUID()+""));	//\u90e8\u95e8\u540d\u79f0
					selectedObj.put("jobTitlesName", FormatMultiLang.formatByUserid(jobTitlesName,user.getUID()+""));	//\u5c97\u4f4d\u540d\u79f0
					selectedObj.put("messagerurl", messagerurl);	//\u5934\u50cf
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
	    	String lastname = resourceComInfo.getLastname(userid);	//\u59d3\u540d
			String subCompanyID = resourceComInfo.getSubCompanyID(userid);	//\u5206\u90e8id
			String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);	//\u5206\u90e8\u540d\u79f0
			
			String departmentID = resourceComInfo.getDepartmentID(userid);	//\u90e8\u95e8id
			String departmentName = departmentComInfo.getDepartmentname(departmentID);	//\u90e8\u95e8\u540d\u79f0
			
			String jobTitle = resourceComInfo.getJobTitle(userid);	//\u5c97\u4f4did
			String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//\u5c97\u4f4d\u540d\u79f0
			
			String messagerurl = this.getMessagerurl(resourceComInfo.getMessagerUrls(userid));//\u5934\u50cf
			
			JSONObject selectedObj = new JSONObject();
			selectedObj.put("id", userid);	//id
			selectedObj.put("lastname", FormatMultiLang.formatByUserid(lastname,user.getUID()+""));	//\u59d3\u540d
			selectedObj.put("subCompanyName", FormatMultiLang.formatByUserid(subCompanyName,user.getUID()+""));	//\u5206\u90e8\u540d\u79f0
			selectedObj.put("departmentName", FormatMultiLang.formatByUserid(departmentName,user.getUID()+""));	//\u90e8\u95e8\u540d\u79f0
			selectedObj.put("jobTitlesName", FormatMultiLang.formatByUserid(jobTitlesName,user.getUID()+""));	//\u5c97\u4f4d\u540d\u79f0
			selectedObj.put("messagerurl", messagerurl);	//\u5934\u50cf
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

    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      _jsp_application.getJspApplicationContext().freePageContext(pageContext);
    }
  }

  private java.util.ArrayList _caucho_depends = new java.util.ArrayList();

  public java.util.ArrayList _caucho_getDependList()
  {
    return _caucho_depends;
  }

  public void _caucho_addDepend(com.caucho.vfs.PersistentDependency depend)
  {
    super._caucho_addDepend(depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  public boolean _caucho_isModified()
  {
    if (_caucho_isDead)
      return true;
    if (com.caucho.server.util.CauchoSystem.getVersionId() != 1886798272571451039L)
      return true;
    for (int i = _caucho_depends.size() - 1; i >= 0; i--) {
      com.caucho.vfs.Dependency depend;
      depend = (com.caucho.vfs.Dependency) _caucho_depends.get(i);
      if (depend.isModified())
        return true;
    }
    return false;
  }

  public long _caucho_lastModified()
  {
    return 0;
  }

  public java.util.HashMap<String,java.lang.reflect.Method> _caucho_getFunctionMap()
  {
    return _jsp_functionMap;
  }

  public void init(ServletConfig config)
    throws ServletException
  {
    com.caucho.server.webapp.WebApp webApp
      = (com.caucho.server.webapp.WebApp) config.getServletContext();
    super.init(config);
    com.caucho.jsp.TaglibManager manager = webApp.getJspApplicationContext().getTaglibManager();
    com.caucho.jsp.PageContextImpl pageContext = new com.caucho.jsp.PageContextImpl(webApp, this);
  }

  public void destroy()
  {
      _caucho_isDead = true;
      super.destroy();
  }

  public void init(com.caucho.vfs.Path appDir)
    throws javax.servlet.ServletException
  {
    com.caucho.vfs.Path resinHome = com.caucho.server.util.CauchoSystem.getResinHome();
    com.caucho.vfs.MergePath mergePath = new com.caucho.vfs.MergePath();
    mergePath.addMergePath(appDir);
    mergePath.addMergePath(resinHome);
    com.caucho.loader.DynamicClassLoader loader;
    loader = (com.caucho.loader.DynamicClassLoader) getClass().getClassLoader();
    String resourcePath = loader.getResourcePathSpecificFirst();
    mergePath.addClassPath(resourcePath);
    com.caucho.vfs.Depend depend;
    depend = new com.caucho.vfs.Depend(appDir.lookup("mobile/plugin/plus/browser/hrmBrowserAction.jsp"), 2966895543148321205L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/maint/common/initNoCache.jsp"), 3270256153856711871L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string1;
  private final static char []_jsp_string0;
  static {
    _jsp_string1 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
  }
}
