/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._hrm._area;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import weaver.hrm.*;
import net.sf.json.*;
import weaver.hrm.resource.TreeNode;
import weaver.general.*;
import weaver.file.Prop;
import weaver.hrm.company.*;
import java.util.ArrayList;
import weaver.hrm.resource.ResourceComInfo;
import weaver.conn.RecordSet;
import weaver.hrm.appdetach.AppDetachComInfo;
import weaver.hrm.resource.MutilResourceBrowser;
import weaver.systeminfo.SystemEnv;
import weaver.hrm.country.CountryComInfo;
import weaver.hrm.province.ProvinceComInfo;
import weaver.hrm.city.CityComInfo;
import weaver.hrm.city.CitytwoComInfo;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import com.alibaba.fastjson.JSON;

public class _hrmcountry_0leftxml__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  public  TreeNode getCountryTreeList(TreeNode treeList,String searchStr) throws Exception{
  	List<String> citytwoid = new ArrayList<String>();
  	List<String> citytwoName = new ArrayList<String>();
  	List<String> citytwoPid = new ArrayList<String>();
  	
  	List<String> cityid = new ArrayList<String>();
  	List<String> cityName = new ArrayList<String>();
  	List<String> cityPid = new ArrayList<String>();
  	
  	List<String> proid = new ArrayList<String>();
  	List<String> proName = new ArrayList<String>();
  	List<String> proPid = new ArrayList<String>();
  	
  	List<String> counid = new ArrayList<String>();
  	List<String> counName = new ArrayList<String>();
  	
  	CityComInfo cityCom = new CityComInfo();
  	ProvinceComInfo proCom = new ProvinceComInfo();
  	CountryComInfo conCom = new CountryComInfo();
  	RecordSet recordSet = new RecordSet();
  	recordSet.executeSql("select t.id,t.cityname,t.cityid,c.provinceid,c.countryid from hrmcitytwo t inner join HrmCity c on t.cityid = c.id where (t.canceled  like '' or t.canceled is null) and t.cityname like '%"+searchStr+"%'");
      while (recordSet.next()) {
  	    String id = recordSet.getString("id");
  	    String name = recordSet.getString("cityname");
  	    String pid = recordSet.getString("cityid");
  	    String provinceid = recordSet.getString("provinceid");
  	    String countryid = recordSet.getString("countryid");
  	    citytwoid.add(id);
  	    citytwoName.add(name);
  	    citytwoPid.add(pid);
          if (!cityid.contains(pid)){
          	cityid.add(pid);
          	cityName.add(cityCom.getCityname(pid));
          	cityPid.add(cityCom.getCityprovinceid(pid));
          }
          if (!proid.contains(provinceid)){
          	proid.add(provinceid);
          	proName.add(proCom.getProvincename(provinceid));
          	proPid.add(proCom.getProvincecountryid(provinceid));
          }
          if (!counid.contains(countryid)){
          	counid.add(countryid);
          	counName.add(conCom.getCountryname(countryid));
          }
          
      }
      recordSet.executeSql("select t.id,t.cityname,t.provinceid,t.countryid from HrmCity t where   (t.canceled  like '' or t.canceled is null) and t.cityname like  '%"+searchStr+"%'");
      while (recordSet.next()) {
      	String id = recordSet.getString("id");
  	    String name = recordSet.getString("cityname");
  	    String provinceid = recordSet.getString("provinceid");
  	    String countryid = recordSet.getString("countryid");
  	    if (!cityid.contains(id)){
          	cityid.add(id);
          	cityName.add(name);
          	cityPid.add(provinceid);
          }
          if (!proid.contains(provinceid)){
          	proid.add(provinceid);
          	proName.add(proCom.getProvincename(provinceid));
          	proPid.add(proCom.getProvincecountryid(provinceid));
          }
          if (!counid.contains(countryid)){
          	counid.add(countryid);
          	counName.add(conCom.getCountryname(countryid));
          }
      }
      
      recordSet.executeSql("select t.id,t.provincename,t.countryid from HrmProvince t where   (t.canceled  like '' or t.canceled is null) and t.provincename like   '%"+searchStr+"%'");
      while (recordSet.next()) {
      	String id = recordSet.getString("id");
  	    String name = recordSet.getString("provincename");
  	    String countryid = recordSet.getString("countryid");
          if (!proid.contains(id)){
          	proid.add(id);
          	proName.add(name);
          	proPid.add(countryid);
          }
          if (!counid.contains(countryid)){
          	counid.add(countryid);
          	counName.add(conCom.getCountryname(countryid));
          }
      }
      
      recordSet.executeSql("select t.id,t.countryname from HrmCountry t where (t.canceled  like '' or t.canceled is null) and t.countryname like   '%"+searchStr+"%'");
      while (recordSet.next()) {
      	String id = recordSet.getString("id");
  	    String name = recordSet.getString("countryname");
          if (!counid.contains(id)){
          	counid.add(id);
          	counName.add(name);
          }
      }
       Map<String,TreeNode> citytwoMap = new HashMap<String,TreeNode>();
  	 Map<String,TreeNode> cityMap = new HashMap<String,TreeNode>();
  	 Map<String,TreeNode> provMap = new HashMap<String,TreeNode>();
  	 Map<String,TreeNode> counMap = new HashMap<String,TreeNode>();
  	
     	for(int j =0;j<citytwoid.size();j++){
     		   TreeNode citytwoNode = new TreeNode();
             citytwoNode.setId(citytwoid.get(j));
         	   citytwoNode.setName(citytwoName.get(j));
             citytwoNode.setPid(citytwoPid.get(j));
             citytwoNode.setNodeid("citytwo_"+citytwoid.get(j));
             citytwoNode.setType("citytwo");
             TreeNode thiscitynode = cityMap.get(citytwoPid.get(j));
             if (thiscitynode != null){
  	           	thiscitynode.AddChildren(citytwoNode);
  	           	int childrenNo = thiscitynode.getChildren().size();
  	           	if(!"".equals(thiscitynode.getName())&& thiscitynode.getName().indexOf("(")>1){
  		           	thiscitynode.setName(thiscitynode.getName().substring(0,thiscitynode.getName().lastIndexOf("(")+1)+childrenNo+")");
  	           	}else{
  	           		thiscitynode.setName("("+childrenNo+")");
  	           	}
  	           //	cityMap.put(citytwoPid.get(j),thiscitynode);
             }else{
  	           	TreeNode cityNode = new TreeNode();
  	           	cityNode.setId(citytwoPid.get(j));
  	           	cityNode.setNodeid("city_"+citytwoPid.get(j));
  	           	cityNode.setPid(citytwoPid.get(j));
  	       		cityNode.setIsParent("true");
  	       		cityNode.setName(cityCom.getCityname(citytwoPid.get(j))+"(1)");
  	       		cityNode.setType("city");
  	       		cityNode.setOpen("true");
  	       		cityNode.AddChildren(citytwoNode);
  	       		cityMap.put(citytwoPid.get(j),cityNode);
             }
     	}
      try{
      for(int i = 0;i<cityid.size();i++){
      	TreeNode cityNode = cityMap.get(cityid.get(i));
          if (cityNode == null){
          	cityNode = new TreeNode();
          	cityNode.setId(cityid.get(i));
          	cityNode.setNodeid("city_"+cityid.get(i));
          	cityNode.setPid(cityPid.get(i));
      		cityNode.setType("city");
      		cityNode.setName(cityName.get(i));
      		cityMap.put(cityid.get(i),cityNode);
          }
  		TreeNode thisprovnode = provMap.get(cityPid.get(i));
          if (thisprovnode != null){
          	thisprovnode.AddChildren(cityNode);
          	int childrenNo = thisprovnode.getChildren().size();
          	if(!"".equals(thisprovnode.getName())&& thisprovnode.getName().indexOf("(")>1){
  	        	thisprovnode.setName(thisprovnode.getName().substring(0,thisprovnode.getName().lastIndexOf("(")+1)+childrenNo+")");
          	}else{
          		thisprovnode.setName("("+childrenNo+")");
             	}
          	//provMap.put(cityPid.get(i),thisprovnode);
          }else{
          	TreeNode provNode = new TreeNode();
          	provNode.setId(cityPid.get(i));
          	provNode.setNodeid("province_"+cityPid.get(i));
          	provNode.setPid(cityPid.get(i));
      		provNode.setIsParent("true");
      		provNode.setName(proCom.getProvincename(cityPid.get(i))+"(1)");
      		provNode.setType("province");
      		provNode.setOpen("true");
      		provNode.AddChildren(cityNode);
      		provMap.put(cityPid.get(i),provNode);
          }
      }
  	 }catch(Exception e){
  			e.printStackTrace();
  		}
      for(int m = 0;m<proid.size();m++){
      	TreeNode provNode = provMap.get(proid.get(m));
      	
          if (provNode == null){
          	provNode = new TreeNode();
          	provNode.setId(proid.get(m));
          	provNode.setNodeid("province_"+proid.get(m));
          	provNode.setPid(proPid.get(m));
      		provNode.setType("province");
      		provNode.setName(proName.get(m));
      		provMap.put(proid.get(m),provNode);
          }
  		TreeNode thiscounnode = counMap.get(proPid.get(m));
          if (thiscounnode != null){
          	thiscounnode.AddChildren(provNode);
          	int childrenNo = thiscounnode.getChildren().size();
          	if(!"".equals(thiscounnode.getName())&& thiscounnode.getName().indexOf("(")>1){
  	        	thiscounnode.setName(thiscounnode.getName().substring(0,thiscounnode.getName().lastIndexOf("(")+1)+childrenNo+")");
          	}else{
          		thiscounnode.setName("("+childrenNo+")");
             	}
          	//counMap.put(proPid.get(m),thiscounnode);
          }else{
          	TreeNode counNode = new TreeNode();
          	counNode.setId(proPid.get(m));
          	counNode.setNodeid("country_"+proPid.get(m));
          	counNode.setPid("0");
      		counNode.setIsParent("true");
      		counNode.setName(conCom.getCountryname(proPid.get(m))+"(1)");
      		counNode.setType("country");
      		counNode.setOpen("true");
      		counNode.AddChildren(provNode);
      		counMap.put(proPid.get(m),counNode);
          }
      }
      for(int n = 0;n<counid.size();n++){
      	TreeNode counNode = counMap.get(counid.get(n));
          if (counNode == null){
          	counNode = new TreeNode();
          	counNode.setId(counid.get(n));
          	counNode.setNodeid("country_"+counid.get(n));
          	counNode.setPid("0");
      		counNode.setType("country");
      		counNode.setName(counName.get(n));
      		counMap.put(counid.get(n),counNode);
          }
          treeList.AddChildren(counNode);
      }
  	return treeList;
  }
  
  
  public TreeNode getCountryTreeList(TreeNode companyTreeList, String subId, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
  	//getDepartTreeList(companyTreeList, subId, "0",selectedids,isNoAccount, user, sqlwhere);
  	
  	CountryComInfo rs = new CountryComInfo();
  	rs.setTofirstRow();
  	while (rs.next()) {
  		String id = rs.getCountryid();
  		//String supsubcomid = rs.get;
  		//if (supsubcomid.equals(""))supsubcomid = "0";
  		//if (!supsubcomid.equals(subId))continue;
  		String name = rs.getCountryname();
  		 //String canceled = rs.getCountryiscanceled();
  		if(Util.null2String(rs.getCountryiscanceled()).equals("1")){
  			continue;
  		}
  		TreeNode subCompanyNode = new TreeNode();
  		subCompanyNode.setId(id);
  		subCompanyNode.setNodeid("country_"+id);
  		subCompanyNode.setPid(subId);
  		//subCompanyNode.setIcon("/images/treeimages/Home_wev8.gif");
  		subCompanyNode.setNocheck("N");
  		int childNum= hasChild("country",id);
  		if(childNum>0){
  			subCompanyNode.setIsParent("true");
  			subCompanyNode.setName(name+"("+childNum+")");
  		}else{
  			subCompanyNode.setName(name);
  		}
  		subCompanyNode.setType("country");
  		//if(!"1".equals(canceled))
  		companyTreeList.AddChildren(subCompanyNode);
  		//getSubCompanyTreeList(subCompanyNode, id);
  	}
  	return companyTreeList;
  }
  
  public TreeNode getProvinceTreeList(TreeNode departTreeList, String subId, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
  	ProvinceComInfo rs = new ProvinceComInfo();
  	rs.setTofirstRow();
      
     
      //if(departmentId.length()>0){
      	//getResourceTreeList(departTreeList, departmentId,selectedids, isNoAccount, user, sqlwhere);
     // }
      while (rs.next()) {
          //if(departmentId.equals(rsDepartment.getDepartmentid()))continue;
          if (rs.getProvincecountryid().equals(subId) && !"1".equals(rs.getProvinceiscanceled())){
  	        //String supdepid = rsDepartment.getDepartmentsupdepid();
  	       // if (departmentId.equals("0") && supdepid.equals(""))supdepid = "0";
  	        //if (!(rsDepartment.getSubcompanyid1().equals(subId) && (supdepid.equals(departmentId)||(!rsDepartment.getSubcompanyid1(supdepid).equals(subId)&&departmentId.equals("0"))))) continue;
  	
  	        String id = rs.getProvinceid();
  	        String name = rs.getProvincename();
  	        //String canceled = rsDepartment.getDeparmentcanceled();
  	
  	        TreeNode departmentNode = new TreeNode();
  	        departmentNode.setNocheck("Y");
  	        departmentNode.setId(id);
  	        departmentNode.setNodeid("province_"+id);
  	        departmentNode.setPid(subId);
  	        //departmentNode.setIcon("/images/treeimages/subCopany_Colse_wev8.gif");
  	        int childNum= hasChild("province",id);
  			if(childNum>0){
  				departmentNode.setIsParent("true");
  		        departmentNode.setName(name+"("+childNum+")");
  			}else{
  				departmentNode.setName(name);
  			}
  	        departmentNode.setType("province");
  	        //if(!"1".equals(canceled))
          	departTreeList.AddChildren(departmentNode);
          }
      }
  
        return departTreeList;
    }
  
  public TreeNode getCityTreeList(TreeNode treeList, String subId, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
  	CityComInfo rs = new CityComInfo();
  	rs.setTofirstRow();
      
     
      //if(departmentId.length()>0){
      	//getResourceTreeList(departTreeList, departmentId,selectedids, isNoAccount, user, sqlwhere);
     // }
      while (rs.next()) {
          //if(departmentId.equals(rsDepartment.getDepartmentid()))continue;
          if (rs.getCityprovinceid().equals(subId) && !"1".equals(rs.getCitycanceled())){
  	        //String supdepid = rsDepartment.getDepartmentsupdepid();
  	       // if (departmentId.equals("0") && supdepid.equals(""))supdepid = "0";
  	        //if (!(rsDepartment.getSubcompanyid1().equals(subId) && (supdepid.equals(departmentId)||(!rsDepartment.getSubcompanyid1(supdepid).equals(subId)&&departmentId.equals("0"))))) continue;
  	
  	        String id = rs.getCityid();
  	        String name = rs.getCityname();
  	        //String canceled = rsDepartment.getDeparmentcanceled();
  	
  	        TreeNode departmentNode = new TreeNode();
  	        departmentNode.setName(name);
  	        //departmentNode.setNocheck("Y");
  	        departmentNode.setId(id);
  	        departmentNode.setNodeid("city_"+id);
  	        departmentNode.setPid(subId);
  	        //departmentNode.setIcon("/images/treeimages/subCopany_Colse_wev8.gif");
  	        int childNum= hasChild("city",id);
  			if(childNum>0){
  				departmentNode.setIsParent("true");
  		        departmentNode.setName(name+"("+childNum+")");
  			}else{
  				departmentNode.setName(name);
  			}
  	        departmentNode.setType("city");
  	        //if(!"1".equals(canceled))
          	treeList.AddChildren(departmentNode);
          }
      }
  
        return treeList;
    }
  
  public TreeNode getCityTwoTreeList(TreeNode treeList, String subId, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
  	CitytwoComInfo rs = new CitytwoComInfo();
  	rs.setTofirstRow();
      
     
      //if(departmentId.length()>0){
      	//getResourceTreeList(departTreeList, departmentId,selectedids, isNoAccount, user, sqlwhere);
     // }
      while (rs.next()) {
          //if(departmentId.equals(rsDepartment.getDepartmentid()))continue;
          if (rs.getCitypid().equals(subId) && !"1".equals(rs.getCitycanceled())){
  	        //String supdepid = rsDepartment.getDepartmentsupdepid();
  	       // if (departmentId.equals("0") && supdepid.equals(""))supdepid = "0";
  	        //if (!(rsDepartment.getSubcompanyid1().equals(subId) && (supdepid.equals(departmentId)||(!rsDepartment.getSubcompanyid1(supdepid).equals(subId)&&departmentId.equals("0"))))) continue;
  	
  	        String id = rs.getCityid();
  	        String name = rs.getCityname();
  	        //String canceled = rsDepartment.getDeparmentcanceled();
  	
  	        TreeNode departmentNode = new TreeNode();
  	        departmentNode.setName(name);
  	        //departmentNode.setNocheck("Y");
  	        departmentNode.setId(id);
  	        departmentNode.setPid(subId);
  	        departmentNode.setNodeid("citytwo_"+id);
  	        //departmentNode.setIcon("/images/treeimages/subCopany_Colse_wev8.gif");
  	        //if (hasChild("province", id)) {
  	        	//departmentNode.setIsParent("true");
  	        //}
  	        departmentNode.setType("citytwo");
  	        //if(!"1".equals(canceled))
          	treeList.AddChildren(departmentNode);
          }
      }
  
        return treeList;
    }
  
  
  /**
   * \u6307\u5b9a\u8282\u70b9\u4e0b\u662f\u5426\u6709\u5b50\u8282\u70b9
   * @param type  com:\u5206\u90e8;dept:\u90e8\u95e8
   * @param id   \u8282\u70b9id
   * @return  boolean
   * @throws Exception
   */
  private int hasChild(String type, String id) throws Exception {
  	int hasChild = 0;
    if (type.equals("country")) {
  	  ProvinceComInfo rs = new ProvinceComInfo();
  		rs.setTofirstRow();
  		while (rs.next()) {
  			if (rs.getProvincecountryid().equals(id) && !"1".equals(rs.getProvinceiscanceled()))
  				hasChild++;
  		}
  	} else if (type.equals("province")) {
  		CityComInfo rs = new CityComInfo();
  		rs.setTofirstRow();
  		while (rs.next()) {
  			if ( rs.getCityprovinceid().equals(id) && !"1".equals(rs.getCitycanceled()))
  				hasChild++;
  		}
  	}else if (type.equals("city")) {
  		CitytwoComInfo rs = new CitytwoComInfo();
  		rs.setTofirstRow();
  		while (rs.next()) {
  			if ( rs.getCitypid().equals(id) && !"1".equals(rs.getCitycanceled()))
  				hasChild++;
  		}
  	}
  	return hasChild;
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
    response.setContentType("text/html; charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.hrm.resource.MutilResourceBrowser MutilResourceBrowser;
      MutilResourceBrowser = (weaver.hrm.resource.MutilResourceBrowser) pageContext.getAttribute("MutilResourceBrowser");
      if (MutilResourceBrowser == null) {
        MutilResourceBrowser = new weaver.hrm.resource.MutilResourceBrowser();
        pageContext.setAttribute("MutilResourceBrowser", MutilResourceBrowser);
      }
      weaver.hrm.companyvirtual.CompanyVirtualComInfo CompanyVirtualComInfo;
      CompanyVirtualComInfo = (weaver.hrm.companyvirtual.CompanyVirtualComInfo) pageContext.getAttribute("CompanyVirtualComInfo");
      if (CompanyVirtualComInfo == null) {
        CompanyVirtualComInfo = new weaver.hrm.companyvirtual.CompanyVirtualComInfo();
        pageContext.setAttribute("CompanyVirtualComInfo", CompanyVirtualComInfo);
      }
      weaver.hrm.company.CompanyComInfo CompanyComInfo;
      CompanyComInfo = (weaver.hrm.company.CompanyComInfo) pageContext.getAttribute("CompanyComInfo");
      if (CompanyComInfo == null) {
        CompanyComInfo = new weaver.hrm.company.CompanyComInfo();
        pageContext.setAttribute("CompanyComInfo", CompanyComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String id=Util.null2String(request.getParameter("id"));
String type=Util.null2String(request.getParameter("type"));
String virtualtype=Util.null2String(request.getParameter("virtualtype"));
String selectedids=Util.null2String(request.getParameter("selectedids"));
String alllevel=Util.null2String(request.getParameter("alllevel"));
String isNoAccount=Util.null2String(request.getParameter("isNoAccount"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
String cmd=Util.null2String(request.getParameter("cmd"));
String searchStr=Util.null2String(request.getParameter("searchStr"));

selectedids = MutilResourceBrowser.getExcludeSqlWhere(selectedids,alllevel,isNoAccount,user, sqlwhere);

ArrayList selectList = new ArrayList();
if(selectedids.length()>0){
	String[] tmp_selectedids = selectedids.split(",");
	for(String selectedid:tmp_selectedids){
		selectList.add(selectedid);
	}
}
JSONArray jObject = null;
TreeNode envelope=new TreeNode();
if(!searchStr.equals("")){
	TreeNode root1 = new TreeNode();
	String titleName=SystemEnv.getHtmlLabelNames("332,377",user.getLanguage());
	root1.setNodeid("country_"+0);
	root1.setName(titleName);
	root1.setId("0");
	root1.setOpen("true");
	root1.setTarget("_self"); 
  	//root1.setIcon("/images/treeimages/global_wev8.gif");
  	root1.setIconClose("y");
	root1.setType("country");
	//root.AddChildren(root1);
	try{
		getCountryTreeList(root1,searchStr);
		if(root1.getChildren().size() == 0){
			out.println("[]");
		}else{
			out.println(JSON.toJSONString(root1));
		}
	}catch(Exception e){
		e.printStackTrace();
	}
}else{
	if(id.equals("")){
		//\u521d\u59cb\u5316
		//TreeNode root = new TreeNode();
		TreeNode root1 = new TreeNode();
		//String companyname = CompanyComInfo.getCompanyname("1");
		String titleName=SystemEnv.getHtmlLabelNames("332,377",user.getLanguage());
		root1.setNodeid("country_"+0);
		root1.setName(titleName);
		root1.setId("0");
		root1.setOpen("true");
		root1.setTarget("_self"); 
	  	//root1.setIcon("/images/treeimages/global_wev8.gif");
	  	root1.setIconClose("y");
		root1.setType("country");
		//root.AddChildren(root1);
		getCountryTreeList(root1,"0",selectList,isNoAccount, user, sqlwhere);
		jObject = JSONArray.fromObject(root1);
	}else if(type.equals("country")){
		getProvinceTreeList(envelope,id,selectList,isNoAccount, user, sqlwhere);
		ArrayList<TreeNode> lsChild = envelope.getChildren();
		jObject = JSONArray.fromObject(lsChild);		
	}else if(type.equals("province")){
		//DepartmentComInfo DepartmentComInfo = new DepartmentComInfo();
		//String subId = DepartmentComInfo.getSubcompanyid1(id);
		//getProvinceTreeList(envelope,subId,id,selectList,isNoAccount, user, sqlwhere);
		getCityTreeList(envelope,id,selectList,isNoAccount, user, sqlwhere);
		ArrayList<TreeNode> lsChild = envelope.getChildren();
		jObject = JSONArray.fromObject(lsChild);		
	}else if(type.equals("city")){
		//DepartmentComInfo DepartmentComInfo = new DepartmentComInfo();
		//String subId = DepartmentComInfo.getSubcompanyid1(id);
		//getProvinceTreeList(envelope,subId,id,selectList,isNoAccount, user, sqlwhere);
		getCityTwoTreeList(envelope,id,selectList,isNoAccount, user, sqlwhere);
		ArrayList<TreeNode> lsChild = envelope.getChildren();
		jObject = JSONArray.fromObject(lsChild);		
	}
	//System.out.println(jObject.toString());
	out.println(jObject.toString());
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("hrm/area/HrmCountry_leftXml.jsp"), 4135754155590618848L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n\r\n".toCharArray();
  }
}
