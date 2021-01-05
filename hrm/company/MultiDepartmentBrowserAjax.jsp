
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@	page import="java.net.URLDecoder"%>
<%@	page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@	page import="weaver.general.BaseBean"%>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SplitPageParaBean" %>
<%@ page import="weaver.general.SplitPageUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo,weaver.hrm.appdetach.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String tabid = Util.null2String(request.getParameter("tabid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String isdec = Util.null2String(request.getParameter("isdec"));
String companyid = Util.null2String(request.getParameter("companyid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String virtualtype = Util.null2String(request.getParameter("virtualtype"));
if(virtualtype.length()==0)virtualtype="1";
int showsubdept=Util.getIntValue(request.getParameter("showsubdept"),0);
String departmentmultiOrderstr="departmentmultiOrder";
if(isdec.equals("1")) departmentmultiOrderstr="departmentmultiDecOrder";
if(tabid.equals("")) tabid="0";

int uid=user.getUID();
    String rem = null;
    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        if (cks[i].getName().equals(departmentmultiOrderstr + uid)) {
            rem = cks[i].getValue();
            break;
        }
    }

    if (rem != null)
        rem = tabid + rem.substring(1);
    else
        rem = tabid;
    if (!nodeid.equals(""))
        rem = rem.substring(0, 1) + "|" + nodeid;

Cookie ck = new Cookie(departmentmultiOrderstr+uid,rem);
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(tabid.equals("0")&&atts.length>1){
   nodeid=atts[1];
  if(nodeid.indexOf("com")>-1){
    //subcompanyid=nodeid.substring(nodeid.indexOf("_")+1);
    }
  else{
    //departmentid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    }
}



String check_per = Util.null2String(request.getParameter("selectedids"));
if(check_per.equals(",")){
	check_per = "";
}
if(check_per.equals("")){
	check_per = Util.null2String(request.getParameter("systemIds"));
}
String resourceids = "" ;
String resourcenames ="";
StringTokenizer st = null;
Hashtable ht = null;
if(!check_per.equals("")){
	try{
        while(true){
            if(check_per.substring(0,1).equals(",")){
                check_per = check_per.substring(1);
            }else{
                break;
            }
        }
        while(true){
            if(check_per.substring(check_per.length()-1).equals(",")){
                check_per = check_per.substring(0,check_per.length()-1);
            }else{
                break;
            }
        }
        
	String strtmp = "select id,departmentname,subcompanyid1 from HrmDepartmentAllView where ("+Util.getSubINClause(check_per,"id","in")+")";

	//System.out.print(strtmp);
    RecordSet.executeSql(strtmp);
	ht = new Hashtable();
	//boolean ifhave=false;
	while(RecordSet.next()){
        String subcid = Util.null2String(RecordSet.getString("subcompanyid1"));
        String subc = "";
        if(Util.getIntValue(virtualtype)<-1){
        	subc=SubCompanyVirtualComInfo.getSubCompanyname(subcid);
        }else{
        	subc=SubCompanyComInfo.getSubCompanyname(subcid);
        }
        String lastname = RecordSet.getString("departmentname");
        int length=lastname.getBytes().length;
        if (length < 20) {
            for (int i = 0; i < 20 - length; i++) {
                lastname += " ";
            }
        }
        lastname = lastname + " | " + subc;
        ht.put(RecordSet.getString("id"),lastname);
	}
	st = new StringTokenizer(check_per,",");

	//while(st.hasMoreTokens()){
		//String s = st.nextToken();
		//resourceids +=","+s;
		//resourcenames += ","+Util.StringReplace(ht.get(s).toString(),",","，");
	//}
	}catch(Exception e){
		//resourceids="";
		//resourcenames="";
	}
}
int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
JSONArray jsonArr = new JSONArray();
JSONObject json = new JSONObject();
String id=null;
String departmentname=null;
String subcompanyname=null;
if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件	
	if(st!=null){
		while(st.hasMoreTokens()){
			id = st.nextToken();
			if(Util.getIntValue(id)<-1){
				departmentname = DepartmentVirtualComInfo.getDepartmentname(id);
				if(departmentname==null||departmentname.length()==0) continue;
				String tmp_subcompanyid = DepartmentVirtualComInfo.getSubcompanyid1(id);
				subcompanyname = SubCompanyVirtualComInfo.getSubCompanyname(tmp_subcompanyid);
			}else{
				departmentname = DepartmentComInfo.getDepartmentname(id);
				if(departmentname==null||departmentname.length()==0) continue;
				String tmp_subcompanyid = DepartmentComInfo.getSubcompanyid1(id);
				subcompanyname = SubCompanyComInfo.getSubCompanyname(tmp_subcompanyid);
			}
			JSONObject tmp = new JSONObject();
			tmp.put("id",id);
			tmp.put("departmentname",departmentname);
			tmp.put("subcompanyname",subcompanyname);
			jsonArr.add(tmp);
		}
	}

	int totalPage = jsonArr.size();
	if(totalPage%perpage>0||totalPage==0){
		totalPage++;
	}

	json.put("currentPage", 1);
	json.put("totalPage", 1);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
	return;
}else{//左侧待选择列表的sql条件
String deptname = Util.null2String(request.getParameter("deptname"));
String deptcode = Util.null2String(request.getParameter("deptcode"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

if(tabid.equals("0")&&subcompanyid.equals("")&&departmentid.equals("")&&sqlwhere.equals("")) departmentid=user.getUserDepartment()+"";

if(departmentid.equals("0"))    departmentid="";

if(subcompanyid.equals("0"))    subcompanyid="";

if(sqlwhere.length()==0)sqlwhere += " where 1=1";
if(!deptname.equals("")){
	sqlwhere += " and (departmentname like '%" + Util.fromScreen2(deptname,user.getLanguage()) +"%' or departmentmark like '%"+Util.fromScreen2(deptname,user.getLanguage())+"%') ";
}
if(!deptcode.equals("")){
	sqlwhere += " and departmentcode like '%" + Util.fromScreen2(deptcode,user.getLanguage()) +"%' ";
}

	sqlwhere += " and virtualtype="+virtualtype;

if(!departmentid.equals("")){
    String allsubdepts=departmentid;
    if(Util.getIntValue(departmentid) <-1){
    	if(showsubdept==1) allsubdepts=SubCompanyVirtualComInfo.getDepartmentTreeStr(departmentid)+departmentid;
    }else{
    	if(showsubdept==1) allsubdepts=SubCompanyComInfo.getDepartmentTreeStr(departmentid)+departmentid;
    }
    //sqlwhere += " and id in(" + allsubdepts +") " ;
  	sqlwhere += " and ("+Util.getSubINClause(allsubdepts,"id","in")+")";
}
if(departmentid.equals("")&&!subcompanyid.equals("")){
    String allsubcompanys=subcompanyid;
    if(Util.getIntValue(subcompanyid) <-1){
    	if(showsubdept==1) allsubcompanys=SubCompanyVirtualComInfo.getSubCompanyTreeStr(subcompanyid)+subcompanyid;
    }else{
    	if(showsubdept==1) allsubcompanys=SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid)+subcompanyid;
    }
    //sqlwhere += " and subcompanyid1 in(" + allsubcompanys +") " ;
    sqlwhere += " and ("+Util.getSubINClause(allsubcompanys,"subcompanyid1","in")+")";
}

//屏蔽已选人员
String excludeId = Util.null2String(request.getParameter("excludeId"));
if(excludeId.length()==0)excludeId=check_per;
if(excludeId.length()>0){
	//sqlwhere += " and HrmDepartmentAllView.id not in ("+excludeId+")";
	 sqlwhere += " and ("+Util.getSubINClause(excludeId,"HrmDepartmentAllView.id","not in")+")";
}

String sqlfrom = "HrmDepartmentAllView ";


sqlwhere +=" and (canceled is null or canceled <>'1')";
if(tabid.equals("0")&&!subcompanyid.equals("")){
 	String allsubcompanys=subcompanyid;
  if(Util.getIntValue(virtualtype)<-1){
  	if(showsubdept==1) allsubcompanys=SubCompanyVirtualComInfo.getSubCompanyTreeStr(subcompanyid)+subcompanyid;
  }else{
  	if(showsubdept==1) allsubcompanys=SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid)+subcompanyid;
  }
  
 	sqlwhere += " and ("+Util.getSubINClause(allsubcompanys,"subcompanyid1","in")+")";
}

AppDetachComInfo adci = new AppDetachComInfo();
if(adci.isUseAppDetach()){
	String showId = adci.getScopeIds(user, "department");
	String[] idArray = showId.split(",");
	String ids = "";
	if(virtualtype.equals("1")&&adci.getCustomManager()){
		//客户经理能查看所有纬度
	}else{
		if(idArray != null && showId.length() > 0){
			for(int i=0;i<idArray.length; i++){
				if(adci.checkUserAppDetach(idArray[i], "3", user)==0) continue;
				ids += (ids.length()>0?",":"") +idArray[i];
			}
			if(ids.length()>0){
				sqlwhere += " and ("+Util.getSubINClause(ids,"id","in")+")";
			} else {
				sqlwhere += " and 1 = 2 ";
			}
		} else if(adci.isDetachUser(String.valueOf(user.getUID()))){
			sqlwhere += " and 1 = 2 ";
		}
	}
}


SplitPageParaBean spp = new SplitPageParaBean();
spp.setBackFields(" id,departmentname,subcompanyid1,supdepid,showorder ");
spp.setSqlFrom(sqlfrom);
spp.setSqlWhere(sqlwhere);
spp.setSqlOrderBy("subcompanyid1,supdepid,showorder,id");
spp.setPrimaryKey("id");
spp.setDistinct(false);
spp.setSortWay(spp.ASC);
SplitPageUtil spu = new SplitPageUtil();
spu.setSpp(spp);

int RecordSetCounts = spu.getRecordCount();
int totalPage = RecordSetCounts/perpage;
if(totalPage%perpage>0||totalPage==0){
	totalPage++;
}
rs = spu.getCurrentPageRs(pagenum, perpage);

List<JSONObject> list = new ArrayList<JSONObject>() ;
while(rs.next()) {
	id = rs.getString("id");
	departmentname = rs.getString("departmentname");
  if(Util.getIntValue(id)<-1){
  	subcompanyname = SubCompanyVirtualComInfo.getSubCompanyname(rs.getString("subcompanyid1"));
  }else{
  	subcompanyname = SubCompanyComInfo.getSubCompanyname(rs.getString("subcompanyid1"));
  }
	JSONObject tmp = new JSONObject();
	tmp.put("id",id);
	tmp.put("departmentname",departmentname);
	tmp.put("subcompanyname",subcompanyname);
	jsonArr.add(tmp);
	
}

json.put("noRepeatResp","1");
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
}
%>