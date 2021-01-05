<%@page import="weaver.crm.util.OperateUtil"%>
<%@page import="weaver.crm.data.CustomerModifyLog"%>
<%@page import="weaver.crm.Maint.CustomerContacterComInfo"%>
<%@page import="weaver.secondary.util.TransUtil"%>
<%@page import="weaver.hrm.city.CityComInfo"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="weaver.crm.sellchance.SellstatusComInfo"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.hrm.job.JobTitlesComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.WorkPlan.WorkPlanLogMan"%>
<%@page import="weaver.WorkPlan.WorkPlanService"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.crm.Maint.CustomerInfoComInfo"%>
<%@page import="weaver.Constants"%>
<%@page import="weaver.domain.workplan.WorkPlan"%>
<%@page import="weaver.crm.Maint.ContacterTitleComInfo"%>
<%@page import="weaver.crm.Maint.SectorInfoComInfo"%>
<%@page import="weaver.crm.Maint.CustomerSizeComInfo"%>
<%@page import="weaver.crm.customer.CustomerService"%>
<%@page import="weaver.crm.customer.CustomerLabelVO"%>
<%@page import="weaver.crm.customer.CustomerLabelService"%>
<%@page import="weaver.crm.Maint.CustomerStatusComInfo"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.crm.CrmShareBase"%>
<%@page import="java.io.IOException"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.*"%>
<%@page import="java.util.*"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.crm.sellchance.*"%>
<%@ page import="com.weaver.formmodel.util.DateHelper" %>

<%@page import="com.weaver.formmodel.mobile.utils.MobileUpload"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="java.io.File"%>
<%@page import="weaver.docs.networkdisk.tools.ImageFileUtil"%>
<%!
private boolean isFailStatus(String status){
	return !status.equals("0") && !status.equals("1") && !status.equals("2") && !status.equals("3");
}

private double[] getAround(double lat, double lng, double raidus) {
    
    Double latitude = lat;
    Double lnggitude = lng;

    Double degree = (24901 * 1609) / 360.0;
    double raidusMile = raidus;

    Double dpmLat = 1 / degree;
    Double radiusLat = dpmLat * raidusMile;
    Double minLat = latitude - radiusLat;
    Double maxLat = latitude + radiusLat;

    Double mpdLng = degree * Math.cos(latitude * (Math.PI / 180));
    Double dpmLng = 1 / mpdLng;
    Double radiusLng = dpmLng * raidusMile;
    Double minLng = lnggitude - radiusLng;
    Double maxLng = lnggitude + radiusLng;
    return new double[] { minLat, maxLat, minLng, maxLng };
}

private static final double EARTH_RADIUS = 6378137;
private static double rad(double d){
	return d * Math.PI / 180.0;
}

private static double getDistance(double lng1, double lat1, double lng2, double lat2){
	double radLat1 = rad(lat1);
	double radLat2 = rad(lat2);
	double a = radLat1 - radLat2;
	double b = rad(lng1) - rad(lng2);
	double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a/2),2) + Math.cos(radLat1)*Math.cos(radLat2)*Math.pow(Math.sin(b/2),2)));
	s = s * EARTH_RADIUS;
	s = Math.round(s * 10000) / 10000;
	return s;
}

private void updateLastDate2(String sellchanceIds){
	RecordSet rs = new RecordSet();
	RecordSet rs2 = new RecordSet();
	List sellchanceIdList = Util.TokenizerString(sellchanceIds, ",");
	String sellchanceId = "";
	for(int i=0;i<sellchanceIdList.size();i++){
		sellchanceId = (String)sellchanceIdList.get(i);
		if(!"".equals(sellchanceId)){
			rs2.executeSql("delete from CS_LastSellChanceDate where sellchanceId="+sellchanceId);
			if(rs.getDBType().equals("oracle"))
				rs.executeSql("select id,startDate,startTime from CS_CustomerContactRecord where rownum=1 and sellchanceIds like '%,"+sellchanceId+",%' order by startDate desc,startTime desc");
			else
				rs.executeSql("select top 1 id,startDate,startTime from CS_CustomerContactRecord where sellchanceIds like '%,"+sellchanceId+",%' order by startDate desc,startTime desc");
			if(rs.next()){
				rs2.executeSql("insert into CS_LastSellChanceDate (sellchanceId,recordId,lastDate,lastTime) values("+sellchanceId+","+rs.getString("id")+",'"+rs.getString("startDate")+"','"+rs.getString("startTime")+"')");
			}
		}
	}
}

%>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.print("{\"status\":\"0\", \"errMsg\":\"用户失效,请请重新登录\"}");
	return;
	/*
	ResourceComInfo resourceComInfo = new ResourceComInfo();
	String userid = resourceComInfo.getUserIdByLoginId("ywy");
	user = new User();
	user.setUid(Util.getIntValue(userid));
	String did = resourceComInfo.getDepartmentID(userid);
	user.setUserDepartment(Util.getIntValue(did));
	user.setLastname(resourceComInfo.getLastname(userid));*/
}

String userid = String.valueOf(user.getUID());
String action = Util.null2String(request.getParameter("action"));
if("getCustomerList".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		String searchKey = "";
		try {
			searchKey = URLDecoder.decode(Util.null2String(request.getParameter("searchKey")), "utf-8");
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		int pageNo = Util.getIntValue(request.getParameter("pageNo"), 1);
		int pageSize = Util.getIntValue(request.getParameter("pageSize"), 10);
		String opt = Util.null2String(request.getParameter("opt"));	//my.我的客户 
		String manager = Util.null2String(request.getParameter("manager")).trim();	//客户经理
		String managerType = Util.null2String(request.getParameter("managerType")).trim();	//类型    my.仅本人    my_under.含下属    under.仅下属
		String status = Util.null2String(request.getParameter("status")).trim();	//客户状态
		String sector = Util.null2String(request.getParameter("sector")).trim();	//客户行业
		String label = Util.null2String(request.getParameter("label")).trim();	//标签
		String type = Util.null2String(request.getParameter("type")).trim();	//客户类型  crm_list.客户 crm_partner.伙伴 crm_people.人脉  
		CrmShareBase crmShareBase = new CrmShareBase();
		String leftjointable = crmShareBase.getTempTable(userid);

		String primarykey = "t1.id";
		//联系记录
		//String contactColumn = ",(select top 1 createdate from WorkPlan a where a.crmid = t1.id and a.createrType='1' and a.type_n=3 and a.createdate is not null and a.createdate<>'' and a.createrid<>1 order by a.createdate desc) as contactdate";
		//String backfields = "t1.id,t1.name,t1.status,t1.manager,t1.phone,t1.sector,address1" + contactColumn; //,lat1,lng1
		String backfields = "t1.id,t1.name,t1.status,t1.manager,t1.phone,t1.sector,address1,t3.customerid1"; //,lat1,lng1
		String tableSql = "select t.id,t.name,t.status,t.manager,t.phone,t.sector,t.address1,t.type,t.lat1,t.lng1 from CRM_CustomerInfo t where t.deleted<>1 ";
		String sqlwhere = "t1.id = t2.relateditemid";
		
		if(opt.equals("my")){	//我的客户
			if(manager.equals("")){
				manager = userid;
			}
			if(managerType.equals("")){
				managerType = "my";
			}
			if(managerType.equals("my")){ //仅本人客户
				tableSql += " and t.manager="+manager;
			}else if(managerType.equals("my_under")){ //包含下属
				CustomerService customerService = new CustomerService();
				String subResourceid = customerService.getSubResourceid(manager); //所有下属
				if(!subResourceid.equals("")){
					tableSql += " and (t.manager="+manager+" or t.manager in ("+subResourceid+"))";
				}else{
					tableSql += " and t.manager="+manager;
				}
			}else if(managerType.equals("under")){ //仅下属
				CustomerService customerService = new CustomerService();
				String subResourceid = customerService.getSubResourceid(manager); //所有下属
				if(!subResourceid.equals("")){
					tableSql += " and t.manager in ("+subResourceid+")";
				}else{
					tableSql += " and 1=2";
				}
			}
		}
		if(opt.equals("attention")){
			sqlwhere += " and t3.customerid1 is not null";
		}
		double latD = 0;
		double lngD = 0;
		if(opt.equals("around")){
			backfields += ",lat1,lng1";
			double raidus = Util.getDoubleValue(request.getParameter("raidus"),0.0);
			String lat = Util.null2String(request.getParameter("lat"));
			String lng = Util.null2String(request.getParameter("lng"));
			
			latD = Util.getDoubleValue(lat,0);
			lngD = Util.getDoubleValue(lng,0);
			double[] dd = this.getAround(latD, lngD, raidus*1000);
			tableSql += " and (t.lat1>="+dd[0]+" and t.lat1<="+dd[1]+" and t.lng1>="+dd[2]+" and t.lng1<="+dd[3] + ")";
			
			String aroundCrm = Util.null2String(request.getParameter("aroundCrm"));
			if(!aroundCrm.equals("")){
				tableSql += " and t.id <> '"+aroundCrm+"'";
			}
		}
		if(!searchKey.equals("")){
			tableSql += " and (t.name like '%"+searchKey+"%' OR address1 like '%"+searchKey+"%')" ;
		    boolean sep = "true".equals(Util.null2String(request.getParameter("sep")));
		    if(sep){
				if(searchKey.length()>4){
					tableSql += " or t.name like '%"+searchKey.substring(2,4) +"%' or t.name like '%"+searchKey.substring(3,5) +"%' ";
				}else if(searchKey.length()==4){
					tableSql += " or t.name like '%"+searchKey.substring(2,4) +"%' ";
				}else if(searchKey.length()==3){
					tableSql += " or t.name like '%"+searchKey.substring(1,3) +"%' ";
				}
			}

		}
		if(!status.equals("")){
			tableSql += " and t.status='"+status+"'";
		}
		if(!sector.equals("")){
			tableSql += " and t.sector='"+sector+"'";
		}

		String sqlfrom = "from ("+tableSql+") t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid";
		sqlfrom += " left join (select customerid customerid1 from CRM_Attention where resourceid = '"+userid+"') t3 on t1.id=t3.customerid1";
		if(!label.equals("")){
			sqlfrom += " left join (select customerid from CRM_Customer_label where labelid="+label+") t4 on t1.id=t4.customerid";
			sqlwhere += " and t1.id=t4.customerid";
		}
		String orderBy = "t1.id";
		SplitPageParaBean spp = new SplitPageParaBean();
		SplitPageUtil spu = new SplitPageUtil();
		spp.setBackFields(backfields);
		spp.setSqlFrom(sqlfrom);
		spp.setPrimaryKey(primarykey);
		spp.setSqlOrderBy(orderBy);
		spp.setSortWay(spp.DESC);
		spp.setSqlWhere(sqlwhere);
		spu.setSpp(spp);
		int totalSize = spu.getRecordCount();
		RecordSet rs = spu.getCurrentPageRs(pageNo, pageSize);
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		CustomerStatusComInfo customerStatusComInfo = new CustomerStatusComInfo();
		JSONArray datas = new JSONArray();
		while(rs.next()){
			String _id = Util.null2String(rs.getString("id"));
			String _name = Util.null2String(rs.getString("name"));
			String _manager = Util.null2String(rs.getString("manager"));
			String _address = Util.null2String(rs.getString("address1"));
			String _status = Util.null2String(rs.getString("status"));
			//String _contactdate = Util.null2String(rs.getString("contactdate"));
			String _customerid = Util.null2String(rs.getString("customerid1"));
			
			JSONObject d = new JSONObject();
			d.put("id", _id);
			d.put("name", _name);
			d.put("manager", resourceComInfo.getLastname(_manager));
			//d.put("address", _address);
			d.put("statusId", _status);
			d.put("status", customerStatusComInfo.getCustomerStatusname(_status));
			d.put("attention", _customerid.trim().equals("")? "0" : "1");
			
			/*
			d.put("contactdate", _contactdate);
			int days = -1;
			if(!"".equals(_contactdate)){
				days = TimeUtil.dateInterval(_contactdate, TimeUtil.getCurrentDateString());
			}
			d.put("days", days);
			*/
			if(opt.equals("around")){
				double latCrm = Util.getDoubleValue(rs.getString("lat1"), 0);
				double lngCrm = Util.getDoubleValue(rs.getString("lng1"), 0);
				/*
				System.out.println("---------------------"); 
				System.out.println("lngD:" + lngD);
				System.out.println("latD:" + latD);
				System.out.println("lngCrm:" + lngCrm);
				System.out.println("latCrm:" + latCrm);*/
				int distance = (int)getDistance(lngD, latD, lngCrm, latCrm);
				d.put("distance", distance);
			}
			datas.add(d);
		}
		
		if(opt.equals("around")){
			Collections.sort(datas, new Comparator<JSONObject>() {
				@Override
				public int compare(JSONObject o, JSONObject o2) {
					int distance = Util.getIntValue(Util.null2String(o.get("distance")));
					int distance2 = Util.getIntValue(Util.null2String(o2.get("distance")));
					return distance - distance2;
				}
			});
		}
		
		resultObj.put("totalSize", totalSize);
		resultObj.put("datas", datas);
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
}else if("getLastContactRecord".equals(action)){
    JSONObject resultObj = new JSONObject();
    try {
        JSONObject data = new JSONObject();
        String customerid = Util.null2String(request.getParameter("id"));
        RecordSet rs = new RecordSet();
        if(rs.getDBType().equals("oracle"))
            rs.executeSql("select createdate as contactdate from (select  *  from WorkPlan where crmid = '"+customerid+"' and createrType='1' and type_n=3 and createdate is not null and createrid<>1 order by createdate desc) t1 where rownum=1" );
        else
            rs.executeSql("select top 1 createdate as contactdate from WorkPlan a where a.crmid = '"+customerid+"' and a.createrType='1' and a.type_n=3 and a.createdate is not null and a.createdate<>'' and a.createrid<>1 order by a.createdate desc");
        String _contactdate = "";
        int days = -1;
        if(rs.next()){
            _contactdate = Util.null2String(rs.getString("contactdate"));
            if(!"".equals(_contactdate)){
                days = TimeUtil.dateInterval(_contactdate, TimeUtil.getCurrentDateString());
            }
        }
        data.put("contactdate", _contactdate);
        data.put("days", days);
        resultObj.put("data", data);
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
}else if("getContactRecordList".equals(action)){
     JSONObject resultObj = new JSONObject();
    try {
        int pageNo = Util.getIntValue(request.getParameter("pageNo"), 1);
        int pageSize = Util.getIntValue(request.getParameter("pageSize"), 10);
        String customerid = Util.null2String(request.getParameter("id"));
        String contacterid = Util.null2String(request.getParameter("contacterid"));
        String primarykey = "wp.id";
        String sellchanceColumn = ",(select subject from CRM_SellChance where id = wp.sellchanceid) as sellchance";
        String contacterColumn = ",(select fullname from CRM_CustomerContacter where id = wp.contacterid) as contacter";
        String backfields = "wp.id,wp.description,wp.begindate,wp.begintime,wp.createrid,wp.docid,wp.requestid,wp.taskid,wp.createdate,wp.createtime,wp.relateddoc,wp.crmid,wp.sellchanceid,wp.contacterid" + sellchanceColumn + contacterColumn; 
        String sqlfrom = "from WorkPlan wp   ";
        String sqlwhere = "wp.type_n=3 and wp.createrType='1' and wp.crmid='"+customerid+"'";
        if (!"".equals(contacterid)) {
            sqlwhere += " and wp.contacterid='" + contacterid + "'";
        }
        String orderBy = "wp.createdate,wp.createtime";
        //Thread.sleep(500);  
        SplitPageParaBean spp = new SplitPageParaBean();
        SplitPageUtil spu = new SplitPageUtil();
        spp.setBackFields(backfields);
        spp.setSqlFrom(sqlfrom);
        spp.setPrimaryKey(primarykey);
        spp.setSqlOrderBy(orderBy);
        spp.setSortWay(spp.DESC);
        spp.setSqlWhere(sqlwhere);
        spu.setSpp(spp);
        int totalSize = spu.getRecordCount();
        RecordSet rs = spu.getCurrentPageRs(pageNo, pageSize);
        ResourceComInfo resourceComInfo = new ResourceComInfo();
        CustomerStatusComInfo customerStatusComInfo = new CustomerStatusComInfo();
        JSONArray datas = new JSONArray();
        RecordSet rsimg = new RecordSet();
        RecordSet rsFile = new RecordSet();
        while(rs.next()){
            String _id = Util.null2String(rs.getString("id"));
            String _createrid = Util.null2String(rs.getString("createrid"));
            String _createdate = Util.null2String(rs.getString("createdate"));
            _createdate = _createdate.replaceAll("-", "/").replaceAll("/0", "/");
            String _createtime = Util.null2String(rs.getString("createtime"));
            //联系记录附件处理
            String _relateddoc = Util.null2String(rs.getString("relateddoc"));
            String imgFormat = "bmp,jpg,png,jpeg,tiff,gif,pcx,tga,exif,fpx,svg,psd,cdr,pcd,dxf,ufo,eps,ai,raw,wmf";
            //图片附件
            String imgFile="";
            //其他附件
            String otheFile="";
            if(!_relateddoc.equals("")){
                rsFile.execute("select * from imagefile where imagefileid in("+_relateddoc+")");
                while(rsFile.next()){
                    String fid = Util.null2String(rsFile.getString("imagefileid"));
                    String fname = Util.null2String(rsFile.getString("imagefilename"));
                    //String fsize = Util.null2String(rsFile.getString("filesize"));
                    if(fname.contains(".")) {
                        String str1 = fname.split("\\.")[1];
                        if(imgFormat.contains(str1)) {
                            imgFile+=fid+",";
                        }else {
                            otheFile+=fid+"-"+fname+","; 
                        }
                    }else {
                        otheFile+=fid+"-"+fname+","; 
                    }
                    
                }
                if(imgFile!="") {
                    imgFile=imgFile.substring(0,imgFile.length()-1);
                }
                if(otheFile!="") {
                    otheFile=otheFile.substring(0,otheFile.length()-1);
                }
            }
            if(!_createtime.equals("")){
                String[] timeArr = _createtime.split(":");
                if(timeArr.length == 3){
                    _createtime = timeArr[0] + ":" + timeArr[1];
                }
            }
            String _description = Util.toHtml(Util.convertDB2Input(rs.getString("description")));
            String _sellchance = Util.null2String(rs.getString("sellchance"));
            String _contacter = Util.null2String(rs.getString("contacter"));
            //查询联系记录上传的图片
            String _imageurl="";  
            
            JSONObject d = new JSONObject();
            d.put("id", _id);
            d.put("creater", resourceComInfo.getLastname(_createrid));
            d.put("avator", resourceComInfo.getMessagerUrls(_createrid));
            d.put("createdate", _createdate);
            d.put("createtime", _createtime);
            d.put("description", _description);
            d.put("sellchance", _sellchance);
            d.put("contacter", _contacter);
            d.put("imageurl", _imageurl);
            d.put("imgFile", imgFile);
            d.put("otheFile", otheFile);
            d.put("userid", user.getLoginid());
            datas.add(d);
        }
        
        resultObj.put("totalSize", totalSize);
        resultObj.put("datas", datas);
        resultObj.put("status", "1");
        //new weaver.general.BaseBean().writeLog("data888:::::::"+resultObj.toString());
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
}else if("getContacts".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		String customerid = Util.null2String(request.getParameter("id"));
		ContacterTitleComInfo contacterTitleComInfo = new ContacterTitleComInfo();
		String sql = "select id,fullname,title,JobTitle,mobilephone,email from CRM_CustomerContacter where customerid='"+customerid+"' order by id";
		RecordSet rs = new RecordSet();
		rs.executeSql(sql);
		int totalSize = rs.getCounts();
		JSONArray datas = new JSONArray();
		while(rs.next()){
			String id = Util.null2String(rs.getString("id"));
			String fullname = Util.null2String(rs.getString("fullname"));
			String _title = Util.null2String(rs.getString("title"));
			String title = contacterTitleComInfo.getContacterTitlename(_title);
			String jobTitle = Util.null2String(rs.getString("JobTitle"));
			String mobilephone = Util.null2String(rs.getString("mobilephone"));
			String email = Util.null2String(rs.getString("email"));
			JSONObject d = new JSONObject();
			d.put("id", id);
			d.put("fullname", fullname);
			d.put("title", title);
			d.put("jobTitle", jobTitle);
			d.put("mobilephone", mobilephone);
			d.put("email", email);
			datas.add(d);
		}
		resultObj.put("totalSize", totalSize);
		resultObj.put("datas", datas);
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
}else if("getCustomer".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		JSONObject data = new JSONObject();
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		CustomerStatusComInfo customerStatusComInfo = new CustomerStatusComInfo();
		CustomerSizeComInfo customerSizeComInfo = new CustomerSizeComInfo();
		SectorInfoComInfo sectorInfoComInfo = new SectorInfoComInfo();
		RecordSet rs = new RecordSet();
		String customerid = Util.null2String(request.getParameter("id"));
		rs.executeProc("CRM_CustomerInfo_SelectByID", customerid);
		if(rs.next()){
			data.put("name", rs.getString("name"));
			String managerid = rs.getString("manager");
			String manager = resourceComInfo.getLastname(managerid);
			data.put("manager", manager);
			data.put("managerid", managerid);
			String address = rs.getString("address1");
			data.put("address", address);
			String statusid = rs.getString("status");
			String status = customerStatusComInfo.getCustomerStatusname(statusid);
			data.put("status", status);
			String rating = rs.getString("rating");	//级别
			data.put("rating", rating);
			String size_n = customerSizeComInfo.getCustomerSizedesc(Util.toScreen(rs.getString("size_n"),user.getLanguage()));
			data.put("size_n", size_n);	//规模
			String sector = sectorInfoComInfo.getSectorInfoname(rs.getString("sector"));	
			data.put("sector", sector);	//行业
		}
		//商机
		rs.executeSql("select id,subject from CRM_SellChance where customerid="+customerid+" order by selltype,id");
		String sellChance = "";
		int sellChanceCount = rs.getCounts();
		while(rs.next()){
			sellChance += Util.toScreen(rs.getString("subject"), user.getLanguage()) + "，";
		}
		if(!sellChance.equals("")){
			sellChance = sellChance.substring(0, sellChance.length() - 1);
		}
		data.put("sellChance", sellChance);
		data.put("sellChanceCount", sellChanceCount);
		//联系人
		rs.executeSql("select fullname,JobTitle from CRM_CustomerContacter where customerid='"+customerid+"' order by id");
		String contacter = "";
		int contacterCount = rs.getCounts();
		int i = 0;
		while(rs.next() && i < 4){
			contacter += Util.toScreen(rs.getString("fullname"), user.getLanguage());
			String jobTitle = Util.toScreen(rs.getString("JobTitle"),user.getLanguage());
			if(!jobTitle.equals("")){
				contacter += "<span class=\"jobTitle\">("+jobTitle+")</span>";
			}
			contacter += " ";
			i++;
		}
		if(!contacter.equals("")){
			contacter = contacter.substring(0, contacter.length() - 1);
		}
		if(contacterCount > 4){
			contacter += "...";
		}
		data.put("contacter", contacter);
		data.put("contacterCount", contacterCount);
		
		resultObj.put("data", data);
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
}else if("getSimpeCustomer".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		JSONObject data = new JSONObject();
		/*
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		CustomerStatusComInfo customerStatusComInfo = new CustomerStatusComInfo();
		CustomerSizeComInfo customerSizeComInfo = new CustomerSizeComInfo();
		SectorInfoComInfo sectorInfoComInfo = new SectorInfoComInfo();
		*/
		RecordSet rs = new RecordSet();
		String customerid = Util.null2String(request.getParameter("id"));
		rs.executeProc("CRM_CustomerInfo_SelectByID", customerid);
		if(rs.next()){
			data.put("id", rs.getString("name"));
			data.put("name", rs.getString("name"));
			data.put("lat1", rs.getString("lat1"));
			data.put("lng1", rs.getString("lng1"));
		}
		resultObj.put("data", data);
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
}else if("getContactsAndSellChance".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		JSONObject data = new JSONObject();
		RecordSet rs = new RecordSet();
		String customerid = Util.null2String(request.getParameter("id"));
		//商机
		JSONArray sellChanceDatas = new JSONArray();
		rs.executeSql("select id,subject from CRM_SellChance where customerid="+customerid+" order by selltype,id");
		while(rs.next()){
			JSONObject d = new JSONObject();
			d.put("id", rs.getString("id"));
			d.put("subject", Util.toScreen(rs.getString("subject"), user.getLanguage()));
			sellChanceDatas.add(d);			
		}
		data.put("sellChanceDatas", sellChanceDatas);
		
		//联系人
		JSONArray contactsDatas = new JSONArray();
		rs.executeSql("select id,fullname from CRM_CustomerContacter where customerid='"+customerid+"' order by id");
		while(rs.next()){
			JSONObject d = new JSONObject();
			d.put("id", rs.getString("id"));
			d.put("fullname", Util.toScreen(rs.getString("fullname"), user.getLanguage()));
			contactsDatas.add(d);
		}
		data.put("contactsDatas", contactsDatas);
		
		resultObj.put("data", data);
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
}else if("saveContactRecord".equals(action)){
    JSONObject resultObj = new JSONObject();
    try {
        
        FileUpload fileUpload = new FileUpload(request, "UTF-8", false);
        
        int imageCount = Util.getIntValue(fileUpload.getParameter("imageCountCommentImg"), 0);
        
        JSONObject data = new JSONObject();
        RecordSet rs = new RecordSet();
        String customerid = Util.null2String(fileUpload.getParameter("customerid"));
        String contacterid = Util.null2String(fileUpload.getParameter("contacts")); //相关联系人
        String sellchanceid = Util.null2String(fileUpload.getParameter("sellchance"));  //相关商机
        String description = Util.null2String(fileUpload.getParameter("description"));  //内容
        String imgfileid = Util.null2String(fileUpload.getParameter("imgfileid"));  //imgfileid
        Map<String,String> imgmap = new HashMap<String,String>();
        if(!imgfileid.equals("")) {
            String[] imgarr = imgfileid.split(",");    
            for(int i=0;i<imgarr.length;i++) {
                String img = imgarr[i];
                imgmap.put(img.split("_")[1],img.split("_")[0]);
            }
        }
        String relateddoc = "";
        String relatedwf = "";
        String relatedcus = customerid;
        String relatedprj = "";
        String relatedfile = "";
        
        String currDate = TimeUtil.getCurrentDateString();
        String currTime = TimeUtil.getOnlyCurrentTimeString().substring(0, 5);
        
        CustomerInfoComInfo customerInfoComInfo = new CustomerInfoComInfo();
        WorkPlanService workPlanService = new WorkPlanService();
        
        WorkPlan workPlan = new WorkPlan();
        workPlan.setCreaterId(user.getUID());
        workPlan.setCreateType(Integer.parseInt(user.getLogintype()));
        workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_CustomerContact));        
        workPlan.setWorkPlanName(customerInfoComInfo.getCustomerInfoname(customerid) + "-" + SystemEnv.getHtmlLabelName(6082, user.getLanguage()));    
        workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
        workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
        workPlan.setResourceId(String.valueOf(user.getUID()));
        workPlan.setBeginDate(currDate);  //开始日期
        workPlan.setBeginTime(currTime);  //开始时间  
        workPlan.setDocument(relateddoc);
        workPlan.setDescription(description);
        workPlan.setStatus(Constants.WorkPlan_Status_Archived);  //直接归档
        workPlan.setCustomer(relatedcus);
        workPlan.setWorkflow(relatedwf);
        workPlan.setTask(relatedprj);
        workPlanService.insertWorkPlan(workPlan);  //插入日程
        String workplanid = workPlan.getWorkPlanID()+"";
        for (int i = 1; i <= imageCount; i++) {
            String uploadname = Util.null2String(fileUpload.getParameter("uploadname_CommentImg_" + i));
            if (!uploadname.equals("")) {
                imgmap.get(i+"");
                relatedfile+= imgmap.get(i+"")+",";
            }
        }
        if(relatedfile!="") {
            relatedfile=relatedfile.substring(0,relatedfile.length()-1);
        }
        //添加相关附件
        if(!relatedfile.equals("")){
            rs.executeSql("update WorkPlan set relateddoc='"+relatedfile+"' where id="+workplanid);
        }
        //插入日志
        String[] logParams = new String[]{workplanid,
                                    WorkPlanLogMan.TP_CREATE,
                                    userid,
                                    request.getRemoteAddr()};
        WorkPlanLogMan logMan = new WorkPlanLogMan();
        logMan.writeViewLog(logParams);
        //商机
        if(!sellchanceid.equals("")){
            rs.executeSql("update WorkPlan set sellchanceid="+sellchanceid+" where id="+workplanid);
            
            //如果有相应的客服销售机会则自动添加客服联系记录
            rs.executeSql("select id from CS_CustomerSellChance where sellchanceid="+sellchanceid);
            if(rs.next()){
                String chanceid = Util.null2String(rs.getString(1));
                if(!chanceid.equals("")){
                    chanceid = "," + chanceid + ",";
                    //保存联系记录
                    char separator = Util.getSeparator();
                    StringBuffer para = new StringBuffer();
                    para.append(customerInfoComInfo.getCustomerInfoname(customerid)+"("+currDate+" "+currTime+")" + separator);
                    para.append(customerid + separator);
                    para.append(contacterid + separator);
                    para.append(user.getUID()+"" + separator);
                    para.append(currDate + separator);
                    para.append(currTime + separator);
                    para.append(currDate + separator);
                    para.append(currTime + separator);
                    para.append("1" + separator);
                    para.append(description + separator);
                    para.append("" + separator);
                    para.append("" + separator);
                    para.append(chanceid + separator);
                    para.append("" + separator);
                    para.append("");

		    		rs.executeProc("CS_CustomerContactRecord_Insert", para.toString());
		    		if (rs.next()) {
		    			String recordId = Util.null2String(rs.getString(1));
		    			
		    			//增加联系记录缓存
		    			//ContactRecordComInfo.addContactRecordComInfo(recordId);

		    			//保存联系记录与联系内容关联
		    			rs.executeProc("CS_ContactRecordContent_Insert", recordId + separator + "27");
		    			
		    			String currentdate = TimeUtil.getCurrentDateString();
		    			String currenttime = TimeUtil.getOnlyCurrentTimeString();
		    			para = new StringBuffer();
		    			para.append(recordId + separator);
		    			para.append(currentdate + separator);
		    			para.append(currenttime + separator);
		    			para.append("" + user.getUID() + separator);
		    			para.append(user.getLoginip() + separator);
		    			para.append("1");//新增

		    			rs.executeProc("CS_CustomerContactRecordLog_Insert", para.toString());
		    			
		    			//记录相关销售机会的最后日期
		    			updateLastDate2(chanceid);
		    		}
	    		}
	    	}
	    }
	  	
	    if(!contacterid.equals("")){
	    	rs.executeSql("update WorkPlan set contacterid="+contacterid+" where id="+workplanid);
	    }
	    
		resultObj.put("data", data);
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
}else if("saveFiles".equals(action)){
    JSONObject resultObj = new JSONObject();
    JSONObject data = new JSONObject();
    try {
        
        FileUpload fileUpload = new FileUpload(request, "UTF-8", false);
        int imageCount = Util.getIntValue(fileUpload.getParameter("imageCountCommentImg"), 0);
        String customerid = Util.null2String(fileUpload.getParameter("customerid"));
        //附件id
        String relatedfile = "";
        for (int i = 1; i <= imageCount; i++) {
            String uploaddata = Util.null2String(fileUpload.getParameter("uploaddata_CommentImg_" + i)).trim();
            if (!uploaddata.equals("")) {
                String uploadname = Util.null2String(fileUpload.getParameter("uploadname_CommentImg_" + i));
                if(uploadname.endsWith("jpeg")){
                    uploadname = uploadname.replaceAll("jpeg", "jpg");
                }
                int imagefileid = ImageFileUtil.createImageFileForMobile(uploaddata,uploadname);
                relatedfile+=imagefileid+"_"+i+",";
            }
        }
        if(relatedfile!="") {
            relatedfile=relatedfile.substring(0,relatedfile.length()-1);
        }
        resultObj.put("data", relatedfile);
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
    
}else if("getUnder".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		JSONArray datas = new JSONArray();
		String pid = Util.null2String(request.getParameter("pid"));
		ResourceComInfo comInfo = new ResourceComInfo();
		while(comInfo.next()){
			if(isFailStatus(comInfo.getStatus())){continue;}
			String managerid = comInfo.getManagerID();
			if(pid.equals(managerid)){
				JSONObject d = new JSONObject();
				String id = comInfo.getResourceid();
				d.put("id", id);
				d.put("name", comInfo.getLastname());
				String hasChild = "0";
				ResourceComInfo comInfo2 = new ResourceComInfo();
				while(comInfo2.next()){
					if(isFailStatus(comInfo2.getStatus())){continue;}
					String managerid2 = comInfo2.getManagerID();
					if(id.equals(managerid2)){
						hasChild = "1";
						break;
					}
				}
				d.put("hasChild", hasChild);
				datas.add(d);
			}
		}
		resultObj.put("datas", datas);
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
}else if("getLabel".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		JSONArray datas = new JSONArray();
		CustomerLabelService labelService = new CustomerLabelService();
		List labelList = labelService.getLabelList(userid, "all");
		for(int i = 0; i < labelList.size(); i++){ 
            CustomerLabelVO labelVO = (CustomerLabelVO)labelList.get(i);
            String id = labelVO.getId();
            String name = labelVO.getName();
            JSONObject d = new JSONObject();
			d.put("id", id);
			d.put("name", name);
			datas.add(d);
		}
		resultObj.put("datas", datas);
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
}else if("getCrmShare".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		JSONArray datas = new JSONArray();
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
		JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
		CustomerInfoComInfo customerInfoComInfo = new CustomerInfoComInfo();
		RolesComInfo rolesComInfo = new RolesComInfo();
		RecordSet rs = new RecordSet();
		String customerid = Util.null2String(request.getParameter("id"));
		rs.executeProc("CRM_ShareInfo_SbyRelateditemid",customerid);
		int totalSize = rs.getCounts();
		while(rs.next()){
			int id = rs.getInt("id");
			int sharelevel = rs.getInt("sharelevel");
			String sharelevelName = "";
			if(sharelevel == 1){
				sharelevelName = "查看";
			}else if(sharelevel >= 2){
				sharelevelName = "编辑";
			}
			int shareType = rs.getInt("sharetype");
			String isImg = "0";	//图片还是文字
			String flag = "";	//标示
			String shareTypeName = "";
			String title = "";
			if(shareType==1){
				shareTypeName = "人力资源";
				isImg = "1";
				String uid = rs.getString("contents");
				flag = resourceComInfo.getMessagerUrls(uid);
				title = resourceComInfo.getLastname(uid) + " / " + sharelevelName;
			}else if(shareType==2){
				shareTypeName = "部门";
				flag = "部门";
				String depid = rs.getString("contents");
				String depName = departmentComInfo.getDepartmentname(depid);
				title = depName + " / " + "安全级别:" + rs.getString("seclevel") + " / " + sharelevelName;
			}else if(shareType==3){
				shareTypeName = "角色";
				flag = "角色";
				String roleid = rs.getString("contents");
				String roleName = rolesComInfo.getRolesRemark(roleid);
				int rolelevel = rs.getInt("rolelevel");
				String rolelevelName = "";
				if(rolelevel == 0){
					rolelevelName = "部门";
				}else if(rolelevel == 1){
					rolelevelName = "分部";
				}else if(rolelevel == 2){
					rolelevelName = "总部";
				}
				title = roleName + " / " + rolelevelName + " / " + "安全级别:" + rs.getString("seclevel") + " / " + sharelevelName;
			}else if(shareType==4){
				shareTypeName = "所有人";
				flag = "所有";
				title = "安全级别:" + rs.getString("seclevel") + " / " + sharelevelName;
			}else if(shareType==5){
				shareTypeName = "分部";
				flag = "分部";
				String subcompanyid = rs.getString("contents");
				String subcomName = subCompanyComInfo.getSubCompanyname(subcompanyid);
				title = subcomName + " / " + "安全级别:" + rs.getString("seclevel") + " / " + sharelevelName;
			}else if(shareType == 6){
				shareTypeName = "岗位";
				flag = "岗位";
				String jobtitleid = rs.getString("contents");
				String jobTitleName = jobTitlesComInfo.getJobTitlesname(jobtitleid);
				title = jobTitleName + " / " + "安全级别:" + rs.getString("seclevel") + " / " + sharelevelName;
			}else if(shareType == 9){
				shareTypeName = "客户";
				flag = "客户";
				String customer = rs.getString("contents");
				String customerName = customerInfoComInfo.getCustomerInfoname(customer);
				title = customerName + " / " + "安全级别:" + rs.getString("seclevel") + " / " + sharelevelName;
			}
			JSONObject d = new JSONObject();
			d.put("isImg", isImg);
			d.put("flag", flag);
			d.put("title", title);
			d.put("shareTypeName", shareTypeName);
			datas.add(d);
		}
		resultObj.put("totalSize", totalSize);
		resultObj.put("datas", datas);
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
}else if("saveCrmShare".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		char flag = 2;
		String ProcPara = "";
		String CustomerID = Util.null2String(request.getParameter("customerid")); 
		String relatedshareid = Util.null2String(request.getParameter("relatedshareid"));
		String sharetype = Util.null2String(request.getParameter("sharetype")); 
		String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
		rolelevel="0";
		String seclevel = Util.null2String(request.getParameter("seclevel"), "0");
		String sharelevel = Util.null2String(request.getParameter("sharelevel"));
		String CurrentUser = ""+user.getUID();
		String ClientIP = request.getRemoteAddr();
		String SubmiterType = ""+user.getLogintype();
		Date newdate = new Date() ;
		long datetime = newdate.getTime() ;
		Timestamp timestamp = new Timestamp(datetime) ;
		String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
		String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
		String _userid = "0" ;
		String departmentid = "0" ;
		String roleid = "0" ;
		String foralluser = "0" ;
		RecordSet rs = new RecordSet();
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		CrmShareBase crmShareBase = new CrmShareBase();
		String[] relatedshareids=relatedshareid.split(",");
		for(int i=0;i<relatedshareids.length;i++){
			if(relatedshareids[i].equals("")) continue;
			String sharevalue=relatedshareids[i];
		    if(sharetype.equals("4")) 
		    	sharevalue = "1" ;
		    if(sharetype.equals("1")) _userid = sharevalue ;
		    if(sharetype.equals("2")) departmentid = sharevalue ;
		    if(sharetype.equals("3")) roleid = sharevalue ;
		    if(sharetype.equals("4")) foralluser = "1" ;
		    
		    String sql="INSERT INTO CRM_ShareInfo ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser,contents )"+ 
		    			"VALUES ("+CustomerID+" ,"+sharetype+" ,"+seclevel+" , "+rolelevel+" , "+sharelevel+", "+_userid+", "+departmentid+", "+roleid+", "+foralluser+", "+sharevalue+")";
			if(rs.execute(sql)){
				String shareid = "";
				rs.execute("select max(id) as id from CRM_ShareInfo where relateditemid="+CustomerID+"  and contents="+sharevalue);
				if(rs.next()){
					shareid = rs.getString("id");
				}
				if(sharetype.equals("3")){
				    String crm_manager = "";
				    rs.executeSql("select manager from crm_customerinfo where id="+CustomerID);
				    if(rs.next()) crm_manager = rs.getString("manager");
				    int crm_manager_dept = Util.getIntValue(resourceComInfo.getDepartmentID(crm_manager),-1);//部门id
				    int crm_manager_com = Util.getIntValue(resourceComInfo.getSubCompanyID(crm_manager),-1);//分部id
				    if(rolelevel.equals("0"))
				    	rs.executeSql("update CRM_ShareInfo set deptorcomid="+crm_manager_dept+" where relateditemid="+CustomerID+" and id="+shareid);
				    else if(rolelevel.equals("1"))
				    	rs.executeSql("update CRM_ShareInfo set deptorcomid="+crm_manager_com+" where relateditemid="+CustomerID+" and id="+shareid);
				}
			}
			//打印日志
			String Remark="sharetype:"+sharetype+"seclevel:"+seclevel+"rolelevel:"+rolelevel+"sharelevel:"+sharelevel+"userid:"+_userid+"departmentid:"+departmentid+"roleid:"+roleid+"foralluser:"+foralluser;
			ProcPara = CustomerID;
			ProcPara += flag+"ns";
			ProcPara += flag+"0";
			ProcPara += flag+Remark;
			ProcPara += flag+CurrentDate;
			ProcPara += flag+CurrentTime;
			ProcPara += flag+CurrentUser;
			ProcPara += flag+SubmiterType;
			ProcPara += flag+ClientIP;
			rs.executeProc("CRM_Log_Insert",ProcPara);
			//CrmViewer.setCrmShareByCrm(""+CustomerID);
			rs.executeSql("select max(id) as shareobjid from CRM_ShareInfo where relateditemid="+CustomerID+"  and contents="+sharevalue);
			rs.next();
			String shareobjid = rs.getString("shareobjid");
			crmShareBase.setCRM_WPShare_newCRMShare(""+CustomerID,shareobjid);
		}
		
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
}else if("getBusinessList".equalsIgnoreCase(action)){
	JSONObject resultObj = new JSONObject();
	try {
		String searchKey = "";
		try {
			searchKey = URLDecoder.decode(Util.null2String(request.getParameter("searchKey")), "utf-8");
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		int pageNo = Util.getIntValue(request.getParameter("pageNo"), 1);
		int pageSize = Util.getIntValue(request.getParameter("pageSize"), 10);
		String opt = Util.null2String(request.getParameter("opt"));	//my.我的客户  attention.我的关注 reminder.到期提醒 
		String customerId = Util.null2String(request.getParameter("customerid"));	//客户Id
		CrmShareBase crmShareBase = new CrmShareBase();
		String leftjointable = crmShareBase.getTempTable(userid);
		String primarykey = "t1.id";
		String backfields = "t1.id,t1.subject,t1.customerid,t1.creater,t1.sellstatusid,t1.preyield,t1.probability,t3.name";
		String sqlfrom = "from CRM_SellChance t1,"+leftjointable+" t2,CRM_CustomerInfo t3 ";
		String sqlwhere = "(t3.deleted=0 or t3.deleted is null) and t1.customerid = t2.relateditemid and t1.customerid=t3.id";
		if(opt.equalsIgnoreCase("my")){//我的商机
			sqlwhere += " and t1.creater="+userid;
		}else if(opt.equalsIgnoreCase("attention")){
			sqlfrom += " ,(select sellchanceid from CRM_SellchanceAtt where resourceid = '"+userid+"') t4 ";
			sqlwhere += " and t1.id=t4.sellchanceid and t4.sellchanceid is not null";
		}else if(opt.equalsIgnoreCase("expire")){
			String date=TimeUtil.getCurrentDateString();//currentdate
			String date1= TimeUtil.dateAdd(date,-30);//currentdate-30
			sqlwhere +=" and t1.predate >= '"+date1+"' and t1.predate <= '"+date+"'";
		}
		if(!searchKey.equals("")){
			sqlwhere += " and t1.subject like '%"+searchKey+"%'" ;
		}
		if(!customerId.equals("")){
			sqlwhere += " and t1.customerid="+customerId;
		}
		String orderBy = "t1.id";
		
		SplitPageParaBean spp = new SplitPageParaBean();
		SplitPageUtil spu = new SplitPageUtil();
		spp.setBackFields(backfields);
		spp.setSqlFrom(sqlfrom);
		spp.setPrimaryKey(primarykey);
		spp.setSqlOrderBy(orderBy);
		spp.setSortWay(spp.DESC);
		spp.setSqlWhere(sqlwhere);
		spu.setSpp(spp);
		int totalSize = spu.getRecordCount();
		RecordSet rs = spu.getCurrentPageRs(pageNo, pageSize);
		RecordSet rs2 = new RecordSet();
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		SellstatusComInfo sellstatusComInfo = new SellstatusComInfo();
		JSONArray datas = new JSONArray();
		while(rs.next()){
			String _id = Util.null2String(rs.getString("id"));
			String _subject = Util.null2String(rs.getString("subject"));
			String _customerid = Util.null2String(rs.getString("customerid"));
			String _creater = Util.null2String(rs.getString("creater"));
			String _sellstatusid = Util.null2String(rs.getString("sellstatusid"));
			double _preyield = Util.getDoubleValue(rs.getString("preyield"), 0)/10000;
			
			String _customername = Util.null2String(rs.getString("name"));
			double probability = Util.getDoubleValue(rs.getString("probability"),0)*100;
			
			String attention;
			if(opt.equalsIgnoreCase("attention")){
				attention = "1";
			}else{
				rs2.executeSql("select count(1) as count from CRM_SellchanceAtt a where resourceid = '"+userid+"' and sellchanceid='"+_id+"'");
				int count = 0;
				if(rs2.next()){
					count = rs2.getInt("count");
				}
				attention = (count > 0) ? "1" : "0";
			}
			JSONObject d = new JSONObject();
			d.put("id", _id);
			d.put("subject", _subject);
			d.put("creater", resourceComInfo.getLastname(_creater));
			d.put("sellstatus", sellstatusComInfo.getSellStatusname(_sellstatusid));
			d.put("sellstatusid", _sellstatusid);
			d.put("preyield", _preyield);
			d.put("customername", _customername);
			d.put("probability", probability);
			d.put("attention", attention);
			datas.add(d);
		}
		resultObj.put("totalSize", totalSize);
		resultObj.put("datas", datas);
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
}else if("getBusiness".equalsIgnoreCase(action)){
	JSONObject resultObj = new JSONObject();
	try {
		String id = Util.null2String(request.getParameter("id"));
		RecordSet rs = new RecordSet();
		rs.executeSql("select creater,subject,customerid,selltypesid,sellstatusid,predate,preyield,probability,sufactor"
				+" from CRM_SellChance"
				+" where id="+id);
		CustomerInfoComInfo customerInfoComInfo = new CustomerInfoComInfo();
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		SelltypesComInfo selltypesComInfo = new SelltypesComInfo();
		SellstatusComInfo sellstatusComInfo = new SellstatusComInfo();
		JSONObject d = new JSONObject();
		String customerid = "";
		boolean flag = true;//是否有权限
		if(rs.next()){
			String manager = resourceComInfo.getLastname(Util.null2String(rs.getString("creater")));
			d.put("manager", manager);
			String subject = Util.null2String(rs.getString("subject"));
			d.put("subject", subject);
			customerid = Util.null2String(rs.getString("customerid"));
			d.put("customerid", customerid);
			String customername = customerInfoComInfo.getCustomerInfoname(customerid);
			d.put("customername", customername);
			String selltypesid = Util.null2String(rs.getString("selltypesid"));
			String sellteypesname = selltypesComInfo.getSellTypesname(selltypesid);
			d.put("selltype", sellteypesname);
			String sellstatusid = Util.null2String(rs.getString("sellstatusid"));
			String sellstatusname = sellstatusComInfo.getSellStatusname(sellstatusid);
			d.put("sellstatus", sellstatusname);
			String predate = Util.null2String(rs.getString("predate"));
			d.put("predate", predate);
			double preyield = Util.getDoubleValue(rs.getString("preyield"), 0)/10000;
			d.put("preyield", preyield);
			double probability = Util.getDoubleValue(rs.getString("probability"),0)*100;
			d.put("probability", probability);
			String sufactor = Util.null2String(rs.getString("sufactor"));
			d.put("sufactor", sufactor);
			
		}
		if(!customerid.equals("")){
			//判断此客户是否存在
			rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
			if(rs.next()){
				//判断是否有查看该客户商机权限
				CrmShareBase crmShareBase = new CrmShareBase();
				int sharelevel = crmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
				if(sharelevel < 1){
					flag = false;
				}else{
					//联系人
					rs.executeSql("select fullname,JobTitle from CRM_CustomerContacter where customerid='"+customerid+"' order by id");
					String contacter = "";
					int contacterCount = rs.getCounts();
					while(rs.next()){
						contacter += Util.toScreen(rs.getString("fullname"), user.getLanguage());
						String jobTitle = Util.toScreen(rs.getString("JobTitle"),user.getLanguage());
						if(!jobTitle.equals("")){
							contacter += "<span class=\"jobTitle\">("+jobTitle+")</span>";
						}
						contacter += "，";
					}
					if(!contacter.equals("")){
						contacter = contacter.substring(0, contacter.length() - 1);
					}
					d.put("contacter", contacter);
					d.put("contacterCount", contacterCount);
				}
			}
		}
		if(flag){
			resultObj.put("data", d);
			resultObj.put("status", "1");
		}else{
			resultObj.put("status", "-1");
			resultObj.put("errMsg", "无权限查看");
		}
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
}else if("doAttention".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		String objid = Util.null2String(request.getParameter("id")); 
		String settype = Util.null2String(request.getParameter("settype"));//1为添加 否则为取消
		String operatetype = Util.null2String(request.getParameter("operatetype"));//1为客户	2为商机
		String tableName = "1".equals(operatetype)?"CRM_Attention":"CRM_SellchanceAtt";
		String relatedName = "1".equals(operatetype)?"customerid":"sellchanceid";
		if(!objid.equals("")){
			RecordSet rs = new RecordSet();
			rs.executeSql("delete from "+tableName+" where resourceid= "+userid+" and "+relatedName+" = "+objid);
			if(settype.equals("1")){
				rs.executeSql("insert into "+tableName+" (resourceid,"+relatedName+") values("+userid+","+objid+")");
			}
		}
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
}else if("changeCrmManager".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		//判断是否有客户编辑权限
		String customerid = Util.null2String(request.getParameter("customerid"));
		String newvalue = Util.null2String(request.getParameter("newmanagerid"));
		String oldvalue = Util.null2String(request.getParameter("oldmanagerid"));
		CrmShareBase crmShareBase = new CrmShareBase(); 
		int sharelevel = crmShareBase.getRightLevelForCRM(userid,customerid);
		if(sharelevel<2){
			return;
		}
		if(!newvalue.equals("") && !newvalue.equals(oldvalue)){
			RecordSet rs = new RecordSet();
			boolean success = rs.executeSql("update CRM_CustomerInfo set manager="+newvalue+" where id="+customerid);
			if(success){
				String operators = newvalue;
				rs.executeSql("delete from CRM_shareinfo where contents="+operators+" and sharetype=1 and relateditemid="+customerid);
				
				//修改客户经理重置客户共享
				crmShareBase.setCRM_WPShare_newCRMManager(customerid);
				//添加新客户标记
				CustomerModifyLog customerModifyLog = new CustomerModifyLog(); 
				customerModifyLog.modify(customerid,oldvalue,newvalue);
				//创建提醒流程
				OperateUtil operateUtil = new OperateUtil();
				//operateUtil.createRemindRequest("", customerid, "", user.getUID()+"", newvalue, "", "");
				
				//重置缓存
				CustomerInfoComInfo customerInfoComInfo = new CustomerInfoComInfo();
				customerInfoComInfo.updateCustomerInfoCache(customerid);
				
				//记录日志
				String currentdate = TimeUtil.getCurrentDateString();
				String currenttime = TimeUtil.getOnlyCurrentTimeString();
				char flag = 2; 
				String ProcPara = customerid+flag+"1"+flag+"0"+flag+"0";
				ProcPara += flag+"客户经理"+flag+currentdate+flag+currenttime+flag+oldvalue+flag+newvalue;
				ProcPara += flag+(user.getUID()+"")+flag+(user.getLogintype()+"")+flag+request.getRemoteAddr();
				rs.executeProc("CRM_Modify_Insert",ProcPara);
				
				ProcPara = customerid;
				ProcPara += flag+"m";
				ProcPara += flag+"";
				ProcPara += flag+"";
				ProcPara += flag+currentdate;
				ProcPara += flag+currenttime;
				ProcPara += flag+(user.getUID()+"");
				ProcPara += flag+(user.getLogintype()+"");
				ProcPara += flag+request.getRemoteAddr();
				rs.executeProc("CRM_Log_Insert",ProcPara);
			}
		}
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
}else if("getExistCrm".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		String name = Util.null2String(request.getParameter("name")); 
		JSONArray crms = new JSONArray();
		if(!name.equals("")){
			String sql = "select * from CRM_CustomerInfo where deleted<>1 and name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%'";
			RecordSet rs = new RecordSet();
			rs.executeSql(sql);
			ResourceComInfo resourceComInfo = new ResourceComInfo();
			while(rs.next()){
				String _id = Util.null2String(rs.getString("id"));
				String _name = Util.null2String(rs.getString("name"));
				String _manager = Util.null2String(rs.getString("manager"));
				JSONObject d = new JSONObject();
				d.put("id", _id);
				d.put("name", _name);
				d.put("manager", resourceComInfo.getLastname(_manager));
				crms.add(d);
			}
		}
		
		resultObj.put("status", "1");
		resultObj.put("crms", crms);
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
}else if("saveCustomer".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		RecordSet rs = new RecordSet();
		Date newdate = new Date() ;
		long datetime = newdate.getTime() ;
		Timestamp timestamp = new Timestamp(datetime) ;
		String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
		String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
		String CurrentUser = ""+user.getUID();
		String SubmiterType = ""+user.getLogintype();
		String ClientIP = request.getRemoteAddr();
		String Name=Util.fromScreen3(request.getParameter("name"),user.getLanguage());//
		String crmCode = Util.fromScreen3(request.getParameter("crmcode"),user.getLanguage());
		String Abbrev=Util.fromScreen3(request.getParameter("engname"),user.getLanguage());//
		String Address1=Util.fromScreen3(request.getParameter("address1"),user.getLanguage());//
		String Address2=Util.fromScreen3(request.getParameter("Address2"),user.getLanguage());
		String Address3=Util.fromScreen3(request.getParameter("Address3"),user.getLanguage());
		String Zipcode=Util.fromScreen3(request.getParameter("Zipcode"),user.getLanguage());
		String City=Util.fromScreen3(request.getParameter("City"),user.getLanguage());
		String citytwoCode=Util.fromScreen3(request.getParameter("citytwoCode"),user.getLanguage());
		String Country=Util.fromScreen3(request.getParameter("Country"),user.getLanguage());
		CityComInfo cityComInfo = new CityComInfo();
		String Province=cityComInfo.getCityprovinceid(City);
		String county=Util.fromScreen3(request.getParameter("citytwoCode"),user.getLanguage());
		String Language=Util.null2s(Util.fromScreen3(request.getParameter("Language"),user.getLanguage()),"7");
		String Phone=Util.fromScreen3(request.getParameter("phone"),user.getLanguage());//
		String Fax=Util.fromScreen3(request.getParameter("Fax"),user.getLanguage());
		String Email=Util.fromScreen3(request.getParameter("email"),user.getLanguage());
		String Website=Util.fromScreen3(request.getParameter("Website"),user.getLanguage());
		String bankName=Util.fromScreen3(request.getParameter("bankname"),user.getLanguage());//
		String accountName = Util.fromScreen3(request.getParameter("accountname"),user.getLanguage());//
		String accounts=Util.fromScreen3(request.getParameter("accounts"),user.getLanguage());
		String introduction= Util.fromScreen3(request.getParameter("introduction"),user.getLanguage());
		// added by lupeng 2004-8-9 for TD826.
		if (Province.equals(""))
			Province = "0";
		// end.
		if(Website.indexOf(":")==-1){
		   Website="http://"+Website.trim();
		}else{
		   Website=Util.StringReplace(Website,"\\","/");
		}
		String principalIds = Util.fromScreen3(request.getParameter("principalIds"),user.getLanguage());
		String exploiterIds = Util.fromScreen3(request.getParameter("exploiterIds"),user.getLanguage());
		String CustomerStatus=Util.null2String(request.getParameter("status"));//
		String Type=Util.null2String(request.getParameter("type")); //
		String TypeFrom=CurrentDate;
		String Description=Util.fromScreen3(request.getParameter("description"),user.getLanguage());//
		String Size=Util.fromScreen3(request.getParameter("size_n"),user.getLanguage());//
		String Source=Util.fromScreen3(request.getParameter("source"),user.getLanguage());//
		String Sector=Util.fromScreen3(request.getParameter("sector"),user.getLanguage());//
		String Manager=Util.fromScreen3(request.getParameter("manager"),user.getLanguage());//
		//部门由人力资源表中选出该经理的部门
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		String Department=resourceComInfo.getDepartmentID(Manager);
		String Subcompanyid1=departmentComInfo.getSubcompanyid1(Department);
		String Agent=Util.fromScreen3(request.getParameter("Agent"),user.getLanguage());
		String Parent=Util.fromScreen3(request.getParameter("Parent"),user.getLanguage());
		String Document=Util.fromScreen3(request.getParameter("Document"),user.getLanguage());
		String seclevel=Util.fromScreen3(request.getParameter("seclevel"),user.getLanguage());
		String Photo=Util.fromScreen3(request.getParameter("Photo"),user.getLanguage());
		String introductionDocid=Util.fromScreen3(request.getParameter("introductionDocid"),user.getLanguage());
		String CreditAmount=Util.fromScreen3(request.getParameter("CreditAmount"),user.getLanguage());
		String CreditTime=Util.fromScreen3(request.getParameter("CreditTime"),user.getLanguage());
		String Remark=Util.fromScreen3(request.getParameter("Remark"),user.getLanguage());
		String RemarkDoc=Util.fromScreen3(request.getParameter("RemarkDoc"),user.getLanguage());
		String customerimageid = "";//联系人照片
		String creditLevel = "0";
		if(CreditAmount!=null&&!CreditAmount.trim().equals("")){
			rs.executeProc("Sales_CRM_CreditInfo_Select" , CreditAmount+"");
			if (rs.next()){
				creditLevel = rs.getString(1);
			}
		}
		if(introductionDocid.equals("")) introductionDocid = "0";
		if(Photo.equals("")) Photo = "0";
		String dff01=Util.null2String(request.getParameter("dff01"));
		String dff02=Util.null2String(request.getParameter("dff02"));
		String dff03=Util.null2String(request.getParameter("dff03"));
		String dff04=Util.null2String(request.getParameter("dff04"));
		String dff05=Util.null2String(request.getParameter("dff05"));
		boolean isOracle = (rs.getDBType()).equals("oracle");
		String nff01=Util.null2String(request.getParameter("nff01"));
		if(nff01.equals(""))
			if (isOracle)
				nff01="0";
			else
				nff01="0.0";
		String nff02=Util.null2String(request.getParameter("nff02"));
		if(nff02.equals(""))
			if (isOracle)
				nff02="0";
			else
				nff02="0.0";
		String nff03=Util.null2String(request.getParameter("nff03"));
		if(nff03.equals(""))
			if (isOracle)
				nff03="0";
			else
				nff03="0.0";
		String nff04=Util.null2String(request.getParameter("nff04"));
		if(nff04.equals(""))
			if (isOracle)
				nff04="0";
			else
				nff04="0.0";
		String nff05=Util.null2String(request.getParameter("nff05"));
		if(nff05.equals(""))
			if (isOracle)
				nff05="0";
			else
				nff05="0.0";
		String tff01=Util.fromScreen3(request.getParameter("tff01"),user.getLanguage());
		String tff02=Util.fromScreen3(request.getParameter("tff02"),user.getLanguage());
		String tff03=Util.fromScreen3(request.getParameter("tff03"),user.getLanguage());
		String tff04=Util.fromScreen3(request.getParameter("tff04"),user.getLanguage());
		String tff05=Util.fromScreen3(request.getParameter("tff05"),user.getLanguage());
		String bff01=Util.null2String(request.getParameter("bff01"));
		if(bff01.equals("")) bff01="0";
		String bff02=Util.null2String(request.getParameter("bff02"));
		if(bff02.equals("")) bff02="0";
		String bff03=Util.null2String(request.getParameter("bff03"));
		if(bff03.equals("")) bff03="0";
		String bff04=Util.null2String(request.getParameter("bff04"));
		if(bff04.equals("")) bff04="0";
		String bff05=Util.null2String(request.getParameter("bff05"));
		if(bff05.equals("")) bff05="0";
		char flag = 2; 
		String ProcPara = Name;
		ProcPara += flag+Language;
		ProcPara += flag+Abbrev;
		ProcPara += flag+Address1;
		ProcPara += flag+Address2;
		ProcPara += flag+Address3;
		ProcPara += flag+Zipcode;
		ProcPara += flag+City;
		ProcPara += flag+Country;
		ProcPara += flag+Province;
		ProcPara += flag+citytwoCode;
		ProcPara += flag+Phone;
		ProcPara += flag+Fax;
		ProcPara += flag+Email;
		ProcPara += flag+Website;
		ProcPara += flag+Source;
		ProcPara += flag+Sector;
		ProcPara += flag+Size;
		ProcPara += flag+Manager;
		ProcPara += flag+Agent;
		ProcPara += flag+Parent;
		ProcPara += flag+Department;
		ProcPara += flag+Subcompanyid1;
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+creditLevel;
		ProcPara += flag+"0";
		ProcPara += flag+"100";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+Document;
		ProcPara += flag+seclevel;
		ProcPara += flag+Photo;
		ProcPara += flag+Type;
		ProcPara += flag+TypeFrom;
		ProcPara += flag+Description;
		ProcPara += flag+CustomerStatus;//status
		ProcPara += flag+"0";//rating
		ProcPara += flag+introductionDocid;
		ProcPara += flag+CreditAmount;
		ProcPara += flag+CreditTime;
		ProcPara += flag+dff01;
		ProcPara += flag+dff02;
		ProcPara += flag+dff03;
		ProcPara += flag+dff04;
		ProcPara += flag+dff05;
		ProcPara += flag+nff01;
		ProcPara += flag+nff02;
		ProcPara += flag+nff03;
		ProcPara += flag+nff04;
		ProcPara += flag+nff05;
		ProcPara += flag+tff01;
		ProcPara += flag+tff02;
		ProcPara += flag+tff03;
		ProcPara += flag+tff04;
		ProcPara += flag+tff05;
		ProcPara += flag+bff01;
		ProcPara += flag+bff02;
		ProcPara += flag+bff03;
		ProcPara += flag+bff04;
		ProcPara += flag+bff05;
		ProcPara += flag+CurrentDate;
	    ProcPara += flag+bankName;
		ProcPara += flag+accountName;
	    ProcPara += flag+accounts;
	    ProcPara += flag+crmCode;
	    ProcPara += flag+introduction;//介绍的参数
	    String CustomerID = "";
	    CustomerInfoComInfo customerInfoComInfo = new CustomerInfoComInfo();
	    boolean insertSuccess = false ;
		insertSuccess = rs.executeProc("CRM_CustomerInfo_Insert",ProcPara);
		rs.execute("select max(id) from CRM_CustomerInfo where manager = "+Manager+" and createdate = '"+CurrentDate+"'");
		if (insertSuccess && rs.next()) {
			CustomerID = rs.getString(1);
			customerInfoComInfo.addCustomerInfoCache(CustomerID);
			//客户与客服负责人关联
			//CustomerOperationUtil.saveCustomerPrincipal(CustomerID,principalIds);
			//客户与开拓人员关联
			//CustomerOperationUtil.saveCustomerExploiter(CustomerID,exploiterIds);
			//通知客户经理的经理
			String operators = resourceComInfo.getManagerID(Manager);
		    //modify by xhheng @20050221 for TD 1373
		    if(operators!=null && !operators.equals("0")){
		    		/**
					SWFAccepter=operators;
					SWFTitle=SystemEnv.getHtmlLabelName(15006,user.getLanguage());
					SWFTitle += Name;
					SWFTitle += "-"+CurrentUserName;
					SWFTitle += "-"+CurrentDate;
					SWFRemark="";
					SWFSubmiter=CurrentUser;
					SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
					*/
					//系统触发流程会给客户经理的经理一个对该客户的查看权限，与下面的CrmShareBase.setDefaultShare(""+CustomerID);重复。
					rs.executeSql("delete from CRM_shareinfo where relateditemid="+CustomerID);
		    }

			ProcPara = CustomerID;
			ProcPara += flag+"n";
			ProcPara += flag+RemarkDoc;
			ProcPara += flag+Remark;
			ProcPara += flag+CurrentDate;
			ProcPara += flag+CurrentTime;
			ProcPara += flag+CurrentUser;
			ProcPara += flag+SubmiterType;
			ProcPara += flag+ClientIP;
			rs.executeProc("CRM_Log_Insert",ProcPara);

	    	String Title=Util.fromScreen3(request.getParameter("title"),user.getLanguage());//
			String LastName=Util.fromScreen3(request.getParameter("LastName"),user.getLanguage());
			String FirstName=Util.fromScreen3(request.getParameter("firstname"),user.getLanguage());//
			String JobTitle=Util.fromScreen3(request.getParameter("jobtitle"),user.getLanguage());//
			String CEmail=Util.fromScreen3(request.getParameter("contacteremail"),user.getLanguage());//
			String PhoneOffice=Util.fromScreen3(request.getParameter("phoneoffice"),user.getLanguage());//
			String PhoneHome=Util.fromScreen3(request.getParameter("PhoneHome"),user.getLanguage());
			String Mobile=Util.fromScreen3(request.getParameter("mobilephone"),user.getLanguage());//
			String interest=Util.fromScreen3(request.getParameter("interest"),user.getLanguage());
			String hobby=Util.fromScreen3(request.getParameter("hobby"),user.getLanguage());
			String managerstr=Util.fromScreen3(request.getParameter("managerstr"),user.getLanguage());
			String subordinate=Util.fromScreen3(request.getParameter("subordinate"),user.getLanguage());
			String strongsuit=Util.fromScreen3(request.getParameter("strongsuit"),user.getLanguage());
			String age=Util.fromScreen3(request.getParameter("age"),user.getLanguage());
			String birthday=Util.fromScreen3(request.getParameter("birthday"),user.getLanguage());
			String home=Util.fromScreen3(request.getParameter("home"),user.getLanguage());
			String school=Util.fromScreen3(request.getParameter("school"),user.getLanguage());
			String speciality=Util.fromScreen3(request.getParameter("speciality"),user.getLanguage());
			String nativeplace=Util.fromScreen3(request.getParameter("nativeplace"),user.getLanguage());
			String experience=Util.fromScreen3(request.getParameter("experience"),user.getLanguage());

			ProcPara = CustomerID;
			ProcPara += flag+Title;
			ProcPara += flag+FirstName;
			ProcPara += flag+LastName;
			ProcPara += flag+FirstName;
			ProcPara += flag+JobTitle;
			ProcPara += flag+CEmail;
			ProcPara += flag+PhoneOffice;
			ProcPara += flag+PhoneHome;
			ProcPara += flag+Mobile;
			ProcPara += flag+"";
			ProcPara += flag+Language;
			ProcPara += flag+Manager;
			ProcPara += flag+"1";
			ProcPara += flag+"0";
			ProcPara += flag+interest;
			ProcPara += flag+hobby;
			ProcPara += flag+managerstr;
			ProcPara += flag+subordinate;
			ProcPara += flag+strongsuit;
			ProcPara += flag+age;
			ProcPara += flag+birthday;
			ProcPara += flag+home;
			ProcPara += flag+school;
			ProcPara += flag+speciality;
			ProcPara += flag+nativeplace;
			ProcPara += flag+experience;
			ProcPara += flag+"";
			ProcPara += flag+"";
			ProcPara += flag+"";
			ProcPara += flag+"";
			ProcPara += flag+"";
			ProcPara += flag+"0.0";
			ProcPara += flag+"0.0";
			ProcPara += flag+"0.0";
			ProcPara += flag+"0.0";
			ProcPara += flag+"0.0";
			ProcPara += flag+"";
			ProcPara += flag+"";
			ProcPara += flag+"";
			ProcPara += flag+"";
			ProcPara += flag+"";
			ProcPara += flag+"0";
			ProcPara += flag+"0";
			ProcPara += flag+"0";
			ProcPara += flag+"0";
			ProcPara += flag+"0";
			ProcPara += flag+""+flag+""+flag+"";
			ProcPara += flag+Util.fromScreen3(request.getParameter("imcode"),user.getLanguage());
			ProcPara += flag+Util.fromScreen3(request.getParameter("status"),user.getLanguage());
			ProcPara += flag+Util.fromScreen3(request.getParameter("isneedcontact"),user.getLanguage());
			ProcPara += flag+Util.fromScreen3(request.getParameter("projectrole"),user.getLanguage());
			ProcPara += flag+Util.fromScreen3(request.getParameter("attitude"),user.getLanguage());
			ProcPara += flag+Util.fromScreen3(request.getParameter("attention"),user.getLanguage());
			//rs.executeProc("CRM_CustomerContacter_Insert",ProcPara);//联系人部分
			String contacter_sql = "INSERT INTO CRM_CustomerContacter ( customerid, title, fullname, lastname, firstname, jobtitle, email, phoneoffice, phonehome, mobilephone, language)";
			contacter_sql += " values('"+CustomerID+"','"+Title+"','"+FirstName+"','"+LastName+"','"+FirstName+"','"+JobTitle+"','"+CEmail+"','"+PhoneOffice+"','"+PhoneHome+"','"+Mobile+"','"+Language+"')";
			rs.executeSql(contacter_sql);
			rs.executeSql("SELECT MAX(id) as id from CRM_CustomerContacter");
			String ContacterID = "";
			if(rs.next()){
				ContacterID = rs.getString("id");
			}
			
			/**添加客户联系人相片**/
			if(!"".equals(customerimageid)){
				rs.executeSql("update CRM_CustomerContacter set contacterimageid = "+customerimageid+" where customerid = "+CustomerID);
			}
			ProcPara = CustomerID;
			ProcPara += flag + "1";
			ProcPara += flag + "30";
			ProcPara += flag + "0";
			rs.executeProc("CRM_ContacterLog_R_Insert",ProcPara);

			ProcPara = CustomerID;
			ProcPara += flag+"0";
			ProcPara += flag+CurrentUser;
			ProcPara += flag+"0";
			ProcPara += flag+"0";
			ProcPara += flag+"3";
			ProcPara += flag+"Create";
			ProcPara += flag+"0";
			ProcPara += flag+CurrentDate;
			ProcPara += flag+CurrentTime;
			ProcPara += flag+CurrentDate;
			ProcPara += flag+CurrentTime;
			ProcPara += flag+"";
			ProcPara += flag+"0";
			ProcPara += flag+CurrentDate;
			ProcPara += flag+CurrentTime;
			ProcPara += flag+"0";
			ProcPara += flag+"0";
			ProcPara += flag+"1";

			rs.executeProc("CRM_ContactLog_Insert",ProcPara);//客户联系信息

			//RecordSet.executeProc("CRM_ShareInfo_Update",Type+flag+CustomerID);
			//CRM_ShareInfo
			CustomerModifyLog customerModifyLog = new CustomerModifyLog();
			customerModifyLog.modify(CustomerID,user.getUID()+"",Manager);
			//CrmViewer.setCrmShareByCrm(""+CustomerID);
			//在新的方式下添加客户默认共享，新建客户默认共享给客户经理及所有上级，客户管理员角色。
			CrmShareBase crmShareBase = new CrmShareBase();
			crmShareBase.setDefaultShare(""+CustomerID);
			
			CustomerContacterComInfo customerContacterComInfo = new CustomerContacterComInfo(); 
			customerContacterComInfo.addContacterInfoCache(ContacterID);
			
			
			//对坐标进行查询
			try{
				
				String updateCoordinateSql = "UPDATE CRM_CustomerInfo SET ";
		        String adrsParmSql = "";
		        String lnglat = Util.null2String(request.getParameter("lnglat"));
		        if(!"".equals(Address1)&&"".equals(lnglat)){
		           //查询坐标
		        	Map<String,String> map = TransUtil.getCoordinateByAddress(Address1);
		           	if(map.size()==2){
		               	String lng = map.get("lng");
		               	String lat = map.get("lat");
		               	lnglat = lng+","+lat;
		           	}
		        }
		        if(!"".equals(lnglat)){
	        	   String[] lnglats = lnglat.split(",");
	        	   String lng = lnglats[0];
	        	   String lat = lnglats[1];
	        	   adrsParmSql += ",lng1='"+lng+"'";
	               adrsParmSql += ",lat1='"+lat+"'";
				}
		        if(!"".equals(adrsParmSql)) rs.execute(updateCoordinateSql + adrsParmSql.substring(1) + " WHERE id="+CustomerID);
			}catch(Exception e){}
			
		}
		
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
}else if("saveContacter".equals(action)){
	JSONObject resultObj = new JSONObject();
		try {
		RecordSet rs = new RecordSet();
		String customerid = Util.null2String(request.getParameter("customerid"));
//		CrmShareBase crmShareBase = new CrmShareBase();
//		//判断是否有查看该客户权限
//		int sharelevel = crmShareBase.getRightLevelForCRM(userid, customerid);
//		if(sharelevel <= 1){
//			resultObj.put("status", "1");
//			resultObj.put("errMsg", "您没有权限新建联系人！");
//		}else{
			String title = Util.null2String(request.getParameter("title"));
			String firstname = Util.null2String(request.getParameter("firstname"));	
			String jobtitle = Util.null2String(request.getParameter("jobtitle"));
			String mobilephone = Util.null2String(request.getParameter("mobilephone"));
			String phoneoffice = Util.null2String(request.getParameter("phoneoffice"));
			String contacteremail = Util.null2String(request.getParameter("contacteremail"));
			if(!"".equals(customerid)){
				String sql = "select manager from CRM_CustomerInfo where id="+customerid;
				String manager = "";
				rs.executeSql(sql);
				if(rs.next()){
					manager = rs.getString("manager");
				}
				sql = "insert into CRM_CustomerContacter (customerid,title,firstname,jobtitle,mobilephone,phoneoffice,email,fullname,language,manager) "+
				" values ('"+customerid+"','"+title+"','"+firstname+"','"+jobtitle+"','"+mobilephone+"','"+phoneoffice+"','"+contacteremail+"','"+firstname+"','"+user.getLanguage()+"','"+manager+"')";
				rs.executeSql(sql);
				resultObj.put("status", "1");
			}else{
				resultObj.put("status", "0");
				resultObj.put("errMsg", "无客户信息！");
			}
//		}
	}catch(Exception ex) {
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
}else if("getContacterList".equals(action)) {
	JSONObject resultObj = new JSONObject();
	try {
		String searchKey = "";
		try {
			searchKey = URLDecoder.decode(Util.null2String(request.getParameter("searchKey")), "utf-8");
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		int pageNo = Util.getIntValue(request.getParameter("pageNo"), 1);
		int pageSize = Util.getIntValue(request.getParameter("pageSize"), 10);
		String opt = Util.null2String(request.getParameter("opt"));    // all.全部 hadContact.最近联系 my.我的联系人
		String customerid = Util.null2String(request.getParameter("customerid")).trim(); //客户
		String mobilePhone = Util.null2String(request.getParameter("mobilePhone")).trim();   //移动电话
		CrmShareBase crmShareBase = new CrmShareBase();
		String leftjointable = crmShareBase.getTempTable(userid);
		String primarykey = "t1.id";
		String backfields = "t1.id,t1.jobtitle,t1.fullname,t1.mobilephone,t1.customerid,t3.name";
		String sqlfrom = "CRM_CustomerContacter t1,"+leftjointable+" t2,CRM_CustomerInfo t3";
		String sqlwhere = "t1.customerid=t2.relateditemid and t1.customerid=t3.id";
		String orderBy = "";
		if (opt.equals("all")){
		    orderBy = "t1.id";
		}else if (opt.equals("my")){
			//sqlfrom += " ,crm_common_attention t4";
			//sqlwhere += " and t1.id=t4.objid and t4.operator="+userid+" and operatetype=3";
			//orderBy = " t4.operatedate,t4.operatetime";
			sqlwhere += " and t3.manager="+userid;
			orderBy = "t1.id";
		}else if (opt.equals("hadContact")) {
			String dateStart = DateHelper.dayMove(DateHelper.getCurrentDate(),-365);
			sqlfrom += " ,(SELECT contacterid,MAX(id) workplanid FROM WorkPlan WHERE contacterid IS NOT NULL and createdate>='"+dateStart+"' GROUP BY contacterid) t4";
			sqlwhere += " and t1.id=t4.contacterid";
			orderBy = " t4.workplanid";
//			sqlwhere += " and EXISTS(SELECT 1 FROM WorkPlan WHERE createdate>='"+yearStart+"' and contacterid=t1.id)";
//			orderBy = "(select max(id) from WorkPlan WHERE contacterid=t1.id)";
		}
		if (!searchKey.equals("")) {
			sqlwhere += " and t1.fullname like '%" + searchKey + "%'";
		}
		if (!customerid.equals("")) {
			sqlwhere += " and t1.customerid="+customerid+"";
		}
		if (!mobilePhone.equals("")) {
			sqlwhere += " and t1.mobilephone like '%" + mobilePhone + "%'";
		}
		SplitPageParaBean spp = new SplitPageParaBean();
		spp.setBackFields(backfields);
		spp.setSqlFrom(sqlfrom);
		spp.setPrimaryKey(primarykey);
		spp.setSqlOrderBy(orderBy);
		spp.setSortWay(spp.DESC);
		spp.setSqlWhere(sqlwhere);

		SplitPageUtil spu = new SplitPageUtil();
		spu.setSpp(spp);
		RecordSet rs = spu.getCurrentPageRs(pageNo, pageSize);
		JSONArray datas = new JSONArray();
		while (rs.next()) {
			String _id = Util.null2String(rs.getString("id"));
			String _jobtitle = Util.null2String(rs.getString("jobtitle"));
			String _fullname = Util.null2String(rs.getString("fullname"));
			String _mobilephone = Util.null2String(rs.getString("mobilephone"));
			if(_mobilephone.length() == 11){
			    _mobilephone = _mobilephone.substring(0, 3) + "-" + _mobilephone.substring(3, 7) + "-" + _mobilephone.substring(7, 11);
			}
			String _name = Util.null2String(rs.getString("name"));
			JSONObject d = new JSONObject();
			d.put("id", _id);
			d.put("jobtitle", _jobtitle);
			d.put("fullname", _fullname);
			d.put("mobilephone", _mobilephone);
			d.put("customerName", _name);

			datas.add(d);
		}
		resultObj.put("datas", datas);
		resultObj.put("status", "1");
	} catch (Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	} finally {
		try {
			out.print(resultObj.toString());
			out.flush();
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}
}else if("getCustomerListForBrowser".equals(action)){
	JSONObject resultObj = new JSONObject();
	CrmShareBase crmShareBase = new CrmShareBase();
	String leftjointable = crmShareBase.getTempTable(userid);
	RecordSet rs = new RecordSet();
	String sql = "";
	String customerName = "";
	try {
		customerName = URLDecoder.decode(Util.null2String(request.getParameter("customerName")), "utf-8");
	} catch (Exception e1) {
		e1.printStackTrace();
	}
	if(customerName.equals("")){
		sql = "SELECT t1.id,t1.name FROM " + leftjointable + " t2 left join CRM_CustomerInfo t1 on t1.id=t2.relateditemid WHERE t1.deleted<>1  order by t1.id";
	}else{
		sql = "SELECT t1.id,t1.name FROM " + leftjointable + " t2 left join CRM_CustomerInfo t1 on t1.id=t2.relateditemid WHERE t1.deleted<>1 and t1.name like '%"+customerName+"%' order by t1.id";
	}
	rs.executeQuery(sql);
	JSONArray datas = new JSONArray();
	while (rs.next()) {
		String id = rs.getString("id");
		String name = rs.getString("name");
		JSONObject d = new JSONObject();
		d.put("id", id);
		d.put("name", name);
		datas.add(d);
	}
	resultObj.put("datas", datas);
	resultObj.put("status", "1");
	out.print(resultObj.toString());
}else if ("getContacter".equals(action)) {
	JSONObject resultObj = new JSONObject();
	try {
		JSONObject data = new JSONObject();
		RecordSet rs = new RecordSet();
		String id = Util.null2String(request.getParameter("id"));
		rs.executeQuery("SELECT t1.title as titleid,t1.fullname,t1.jobtitle,t2.name customerName,t3.fullname title,t1.mobilephone,t1.phoneoffice,t1.email,t1.department,t2.address1 FROM CRM_CustomerContacter t1 INNER JOIN CRM_CustomerInfo t2 ON t1.customerid=t2.id LEFT JOIN CRM_ContacterTitle t3 ON t1.title=t3.id WHERE t1.id=?",id);
		if (rs.next()) {
			String fullname = Util.null2String(rs.getString("fullname"));
			String lastname = fullname.length() >= 1 ? fullname.substring(0,1) : "";
			String title = rs.getString("title");
			String titleid = rs.getString("titleid");
			String jobtitle = rs.getString("jobtitle");
			String mobilephone = rs.getString("mobilephone");
			String phoneoffice = rs.getString("phoneoffice");
			String email = rs.getString("email");
			String customerName = rs.getString("customerName");
			String department = rs.getString("department");
			String customerAddress = rs.getString("address1");

			data.put("fullname", fullname);
			data.put("lastname", lastname);
			data.put("title", title);
			data.put("titleid", titleid);
			data.put("jobtitle", jobtitle);
			data.put("mobilephone", mobilephone);
			data.put("phoneoffice", phoneoffice);
			data.put("email", email);
			data.put("customerName", customerName);
			data.put("department", department);
			data.put("customerAddress", customerAddress);
		}
	resultObj.put("data", data);
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
}else if ("updateContacter".equals(action)) {
	JSONObject resultObj = new JSONObject();
	try {
		RecordSet rs = new RecordSet();
		String customerid = Util.null2String(request.getParameter("customerid"));
		CrmShareBase crmShareBase = new CrmShareBase();
		int sharelevel = crmShareBase.getRightLevelForCRM(userid, customerid);
		if(sharelevel <= 1){
			resultObj.put("status", "1");
			resultObj.put("errMsg", "您没有权限编辑联系人！");
		}else{
			String id = Util.null2String(request.getParameter("id"));
			String title = Util.null2String(request.getParameter("title"));
			String fullname = Util.null2String(request.getParameter("fullname"));
			String jobtitle = Util.null2String(request.getParameter("jobtitle"));
			String department = Util.null2String(request.getParameter("department"));
			String mobilephone = Util.null2String(request.getParameter("mobilephone"));
			String phoneoffice = Util.null2String(request.getParameter("phoneoffice"));
			String contacteremail = Util.null2String(request.getParameter("contacteremail"));
			if (!"".equals(id)) {
				String sql = "UPDATE CRM_CustomerContacter SET title="+title+",fullname='"+fullname+"',jobtitle='"+jobtitle+"',department='"+department+"',mobilephone='"+mobilephone+"',phoneoffice='"+phoneoffice+"',email='"+contacteremail+"' WHERE id="+id;
				rs.executeSql(sql);
				resultObj.put("status", "1");
			} else {
				resultObj.put("status", "0");
				resultObj.put("errMsg", "无联系人信息！");
			}
		}
	} catch (Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	} finally {
		try {
			out.print(resultObj.toString());
			out.flush();
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}
}else if ("deleteContacter".equals(action)) {
	JSONObject resultObj = new JSONObject();
	try {
		RecordSet rs = new RecordSet();
		String customerid = Util.null2String(request.getParameter("customerid"));
		CrmShareBase crmShareBase = new CrmShareBase();
		int sharelevel = crmShareBase.getRightLevelForCRM(userid, customerid);
		if(sharelevel <= 1){
			resultObj.put("status", "1");
			resultObj.put("errMsg", "您没有权限编辑联系人！");
		}else{
			String id = Util.null2String(request.getParameter("id"));
			if (!"".equals(id)) {
				String sql = "delete from CRM_CustomerContacter WHERE id="+id;
				rs.executeSql(sql);
				resultObj.put("status", "1");
			} else {
				resultObj.put("status", "0");
				resultObj.put("errMsg", "无联系人信息！");
			}
		}
	}catch(Exception ex) {
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
