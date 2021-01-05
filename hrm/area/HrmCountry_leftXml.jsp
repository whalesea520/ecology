<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.hrm.resource.TreeNode"%>
<%@ page import="weaver.general.*,weaver.file.Prop" %>
<%@ page import="weaver.hrm.company.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<%@page import="weaver.hrm.resource.MutilResourceBrowser"%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@page import="weaver.hrm.country.CountryComInfo"%>
<%@page import="weaver.hrm.province.ProvinceComInfo"%>
<%@page import="weaver.hrm.city.CityComInfo"%>
<%@page import="weaver.hrm.city.CitytwoComInfo"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.alibaba.fastjson.JSON"%>
<jsp:useBean id="MutilResourceBrowser" class="weaver.hrm.resource.MutilResourceBrowser" scope="page" /><jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%!
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
 * 指定节点下是否有子节点
 * @param type  com:分部;dept:部门
 * @param id   节点id
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

%>
<%
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
		//初始化
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
%>