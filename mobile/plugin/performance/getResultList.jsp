<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.general.*"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.file.FileUpload"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.gp.util.TransUtil" scope="page" />


<%  request.setCharacterEncoding("UTF-8"); 
    List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
    String msg ="";
    int totalpage = 0;//总页数
	try{
		FileUpload fu = new FileUpload(request);
		String currentUserId = user.getUID()+"";
		String currentdate = TimeUtil.getCurrentDateString();
		int pageNum = Util.getIntValue(fu.getParameter("pageNum"),1);//第几页
		String year = Util.null2String(fu.getParameter("year"));
		String type1 = Util.null2String(fu.getParameter("type1"));
		String type2 = Util.null2String(fu.getParameter("type2"));
		String minresult = Util.null2String(fu.getParameter("minresult"));
		String maxresult = Util.null2String(fu.getParameter("maxresult"));
		String hrmname = Util.null2String(fu.getParameter("hrmname"));
		int isreset = Util.getIntValue(fu.getParameter("isreset"),0);
		String statusval = Util.null2String(fu.getParameter("statusval"));
		String hrmids = Util.fromScreen3(fu.getParameter("hrmids"),user.getLanguage());
		String subids = Util.fromScreen3(fu.getParameter("subids"), user.getLanguage());
		String deptids = Util.fromScreen3(fu.getParameter("deptids"), user.getLanguage());
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		if(type2.equals("")){
			if(type1.equals("4") || type1.equals("3")) type2 = "0";
			if(type1.equals("2")) type2 = TimeUtil.getCurrentSeason();
			if(type1.equals("1")) type2 = currentdate.substring(5,7);
		}
		String innerSql = " h.id,h.id as hrmid,h.lastname,hs.subcompanyname,hd.departmentname,h.workcode,h.dsporder,t.id as scoreid,t.scorename,t.year,t.type1,t.type2,t.operator,t.status as s_status,t.result,t.isrescore,t.startdate,t.enddate,h.departmentid,h.subcompanyid1,h.jobtitle ";
		String whereSql = " HrmResource h join HrmSubCompany hs on h.subcompanyid1 = hs.id join HrmDepartment hd on h.departmentid = hd.id join GP_BaseSetting b on h.subcompanyid1=b.resourceid and b.resourcetype=2 left join GP_AccessScore t on h.id=t.userid and t.isvalid=1 and t.year="+year+" and t.type1="+type1+" and t.type2="+type2
		+" where h.status in (0,1,2,3) and h.loginid is not null "+((!"oracle".equals(rs.getDBType()))?" and h.loginid<>''":"")
			+" and (h.id="+currentUserId+" or h.managerstr like '%,"+currentUserId+",%' "
			+" or exists(select 1 from GP_AccessScoreCheck ac where ac.scoreid=t.id and ac.userid="+currentUserId+")"
			+" or exists(select 1 from GP_BaseSetting bs where bs.resourceid=h.subcompanyid1 and bs.resourcetype=2 and (bs.accessconfirm like '%,"+currentUserId+",%' or bs.accessview like '%,"+currentUserId+",%'))"
			+" or exists(select 1 from GP_BaseSetting bs where bs.resourceid=h.departmentid and bs.resourcetype=3 and (bs.accessconfirm like '%,"+currentUserId+",%' or bs.accessview like '%,"+currentUserId+",%'))"
			+" or exists(select 1 from GP_AccessScoreLog l where l.scoreid=t.id and l.operatetype in (4,5) and l.operator="+currentUserId+")"
			+") ";
		String orderSql = " order by h.dsporder,h.id ";	
		String orderSql1 = " order by dsporder desc,id desc";	
		String orderSql2 = " order by dsporder,id";	
		int intyear = Integer.parseInt(year);
		int inttype1 = Integer.parseInt(type1);
		int inttype2 = Integer.parseInt(type2);
		if(inttype1==1){
			whereSql += " and b.ismonth=1 ";
		}else if(inttype1==2){
			whereSql += " and b.isquarter=1 ";
		}else if(inttype1==3){
			whereSql += " and b.ishyear=1 ";
		}else if(inttype1==4){
			whereSql += " and b.isfyear=1 ";
		}
		if(!hrmids.equals("")){
			whereSql += " and h.id in ("+hrmids+")";
		}
		if(!"".equals(subids)){
			whereSql += " and h.subcompanyid1 in ("+subids+")";
		}
		if(!"".equals(deptids)){
			whereSql += " and h.departmentid in ("+deptids+")";
		}
		if(!minresult.equals("")){
			whereSql += " and t.result>="+minresult;
		}
		if(!maxresult.equals("")){
			whereSql += " and t.result<="+maxresult;
		}
		if(isreset==1){
			whereSql += " and t.isrescore=1";
		}
		if(!"".equals(hrmname)){
			whereSql += " and h.lastname like '%"+hrmname+"%'";
		}
		if(statusval.equals("0")){
			whereSql += " and t.startdate<='"+currentdate+"' and t.enddate>='"+currentdate+"' and (t.status=0 or t.status=2)";
		}
		if(statusval.equals("1")){
			whereSql += " and t.startdate<='"+currentdate+"' and t.enddate>='"+currentdate+"' and t.status=1";
		}
		if(statusval.equals("3")){
			whereSql += " and t.startdate<='"+currentdate+"' and t.status=3";
		}
		if(statusval.equals("-1")){
			whereSql += " and t.id is null";
		}
		if(statusval.equals("4")){
			whereSql += " and t.startdate>'"+currentdate+"'";
		}
		if(statusval.equals("5")){
			whereSql += " and t.enddate<'"+currentdate+"' and (t.status=0 or t.status=2 or t.status=1)";
		}
		String countSql = "select count(h.id) total from "+whereSql;
		//System.out.println(countSql);
		rs.executeSql(countSql);
		int iTotal = 0;  //总条数
		if(rs.next()){
			iTotal = rs.getInt("total");
		}
		int _pagesize = 5; //每页显示页数
		if(iTotal>0){
			totalpage = iTotal / _pagesize;
			if(iTotal % _pagesize >0) totalpage += 1;
			int iNextNum = pageNum * _pagesize;
			int ipageset = _pagesize;
			if(iTotal - iNextNum + _pagesize < _pagesize) ipageset = iTotal - iNextNum + _pagesize;
			if(iTotal < _pagesize) ipageset = iTotal;
			String sql = "";
			int dcount = 0;
			if(rs.getDBType().equals("oracle")){
				sql = "select "+innerSql+" from " +whereSql+orderSql;
				sql = "select A.*,rownum rn from (" + sql + ") A where rownum <= " +  (iNextNum-dcount);
				sql = "select B.* from (" + sql + ") B where rn > " + (iNextNum -dcount - _pagesize);
			}else{
				sql = "select top " + ipageset +" A.* from (select top "+ (iNextNum-dcount) + innerSql+" from "+ whereSql+ orderSql+ ") A "+orderSql1;
				sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderSql2;
			}
			//System.out.println(sql);
			rs.executeSql(sql);
			String titlename = cmutil.getYearType(year+"+"+type1+"+"+type2 )+ "考核";
			Map<String,Object> maps = null;
			while(rs.next()){
				maps = new HashMap<String,Object>();
				String lastname = Util.null2String(rs.getString("lastname"));
				String result = Util.null2String(rs.getString("result"));
				String s_status = Util.null2String(rs.getString("s_status"));
				String operator = Util.null2String(rs.getString("operator"));
				String nType1 = Util.null2String(rs.getString("type1"));
				String scoreid = Util.null2String(rs.getString("scoreid"));
				String startdate = Util.null2String(rs.getString("startdate"));
				String enddate = Util.null2String(rs.getString("enddate"));
				String rid = Util.null2String(rs.getString("id"));
				String subname = Util.null2String(rs.getString("subcompanyname"));
				String departmentname = Util.null2String(rs.getString("departmentname"));
				String isrescore = Util.null2String(rs.getString("isrescore"));
				String userimg = resourceComInfo.getMessagerUrls(rid);//人头像
				String stat = cmutil.getMobileScoreStatusDetail(scoreid,("".equals(s_status)?" ":s_status)+"+"+("".equals(operator)?" ":operator)+"+"+("".equals(startdate)?" ":startdate)+"+"+("".equals(enddate)?" ":enddate)+"+"+("".equals(nType1)?" ":nType1)+"+"+("".equals(rid)?" ":rid)+"+"+("".equals(intyear)?" ":intyear)+"+"+("".equals(inttype1)?" ":inttype1)+"+"+("".equals(inttype2)?" ":inttype2));
				String[] aStatus = stat.split(",");
				String linkUrl = "";
				String status = "";
				String info = "";
				String fcolor = "";
				for(int i=0;i<aStatus.length;i++){
					if(i==0){
						status = aStatus[i];
					}
					if(i==1){
						linkUrl = aStatus[i];
					}
					if(i==2){
						fcolor= aStatus[i];
					}
					if(i==3){
						info = aStatus[i];
					}
				}
				maps.put("linkUrl",linkUrl);
				maps.put("userimg",userimg);
				maps.put("lastname",lastname);
				maps.put("titlename",titlename);
				maps.put("result",result);
				maps.put("isrescore",isrescore);
				maps.put("subname",subname);
				maps.put("departmentname",departmentname);
				maps.put("info",info);
				maps.put("fcolor",fcolor);
				maps.put("status",status);
				list.add(maps);
			}
			msg ="0";
		}else{
			msg = "暂无考核成绩";
		}
		
	}catch(Exception e){
		msg = "数据加载失败,请稍后再试";
	}
	JSONObject json = new JSONObject();
	json.put("list",list);
	json.put("msg",msg);
	json.put("totalpage",totalpage);
	out.print(json.toString());
%>