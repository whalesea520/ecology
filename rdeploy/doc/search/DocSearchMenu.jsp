
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*,net.sf.json.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
String belongtoids = user.getBelongtoids();
String account_type = user.getAccount_type();
String subcompanyId = Util.null2String(request.getParameter("subCompanyId"));
String categoryname = Util.null2String(request.getParameter("categoryname"));
String url = Util.null2String(request.getParameter("url"));
String urlType = Util.null2String(request.getParameter("urlType"));
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
String doccreatedateselect = Util.null2String(request.getParameter("doccreatedateselect"));
String searchType = Util.null2String(request.getParameter("searchType"));

Map<String,Object> params = new HashMap<String,Object>();
int operationcode = Util.getIntValue(request.getParameter("operationcode"),-1);
String onlyCount = Util.null2String(request.getParameter("onlyCount"));

JSONArray jsonArr = new JSONArray();
params.put("_url",url);
params.put("urlType",urlType);
params.put("offical",offical);
params.put("officalType",officalType);
params.put("doccreatedateselect",doccreatedateselect);
MultiAclManager am = new MultiAclManager();
if(operationcode==-1){
	
	String whereclause = "";
	String sql = "";
	String docstatus = "'1','2','5'";
	if(searchType.equals("1")){
		docstatus = "";
	}
	String logintype = user.getLogintype();
	String owner=Util.null2String(request.getParameter("owner"));
	String departmentid=Util.null2String(request.getParameter("departmentid"));
	String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
	String todate=Util.fromScreen(request.getParameter("todate"),user.getLanguage());
	String dspreply = Util.null2String(request.getParameter("dspreply"));
	String doccreaterid = Util.null2String(request.getParameter("doccreaterid"));
	String publishtype=Util.fromScreen(request.getParameter("publishtype"),user.getLanguage());
	if(!doccreatedateselect.equals("") && !doccreatedateselect.equals("0")){
		fromdate = TimeUtil.getDateByOption(doccreatedateselect,"0");
		todate = TimeUtil.getDateByOption(doccreatedateselect,"1");
	}
	if(searchType.equals("1")){
		doccreaterid = ""+user.getUID();
	}
	%>
	<%@ include file="/docs/common.jsp" %>
	<%
	
	if(!doccreaterid.equals("")&&!doccreaterid.equals("0")){
		if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		whereclause+=" and doccreaterid in("+belongtoids+")";
		}else{
		whereclause+=" and doccreaterid="+doccreaterid;
		}
	}
	
	if(!owner.equals("")){
		if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		whereclause+=" and ownerid in ("+belongtoids+")";
		}else{
		whereclause+=" and ownerid="+owner;
		}
	}
	if(!departmentid.equals("")){
		whereclause+=" and docdepartmentid="+departmentid;
	}
	if(!fromdate.equals("")){
		whereclause+=" and doccreatedate>='"+fromdate+"'";
	}
	if(!todate.equals("")){
		whereclause+=" and doccreatedate<='"+todate+"'";
	}
	if(!publishtype.equals("")){
		whereclause+=" and docpublishtype='"+publishtype+"'";
	}
	if(searchType.equals("0")){
      if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		   belongtoids+=","+user.getUID();
		whereclause+=" and t1.id not in (select docid from docReadTag where userid in("
							+ belongtoids + ") and usertype=" + logintype + ")  and t1.doccreaterid not in ( "+belongtoids+")";
	  }else{
		whereclause+=" and t1.id not in (select docid from docReadTag where userid="
							+ user.getUID() + " and usertype=" + logintype + ")  and t1.doccreaterid <> "+user.getUID();
	  }
	}
	/* added by wdl 2006-08-28 不显示历史版本 */
	whereclause+=" and (ishistory is null or ishistory = 0) ";
	/* added end */
	
	

	Map<String,Integer> secAllCountMap = new HashMap<String,Integer>();
	Map<String,Integer> secNewCountMap = new HashMap<String,Integer>();
	if(logintype.equals("1")){  //内部用户的处理
		 if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		 sql = "select count(t1.id) count,t1.seccategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid in("+belongtoids+") or ownerid in ("+belongtoids+") ))) or ";
		 }else{
		 sql = "select count(t1.id) count,t1.seccategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or ";
		 }
	
		 if(searchType.equals("1")){
			 sql += "docstatus !=8 and docstatus!=9) and t1.id=t2.sourceid ";
		 }else{
		 	sql += "docstatus in ("+docstatus+")) and t1.id=t2.sourceid ";
		 }
	    sql+=whereclause;
	    if(dspreply.equals("1")){
	    	sql+= "   and (t1.isreply is null or t1.isreply='' or t1.isreply=0)";
	    }else if(dspreply.equals("2")){
	    	sql+= "   and t1.isreply=1";
	    }
	    sql+=" group by t1.seccategory order by t1.seccategory ";
	    //System.out.println("total Count start------"+new Date().getTime());
	
	    RecordSet.executeSql(sql);
	    while(RecordSet.next()){
	    	if(onlyCount.equals("1")){
		    	JSONObject json = new JSONObject();
		    	json.put("__domid__",MultiAclManager.PREFIX+RecordSet.getString("seccategory"));
		    	JSONObject numbers = new JSONObject();
		    	numbers.put("docAll",Util.getIntValue(RecordSet.getString("count"),0));
		    	numbers.put("docNew",Util.getIntValue(RecordSet.getString("count"),0));
		    	json.put("numbers",numbers);
		    	jsonArr.add(json);
	    	}
	    	secAllCountMap.put(MultiAclManager.PREFIX+RecordSet.getString("seccategory"),Util.getIntValue(RecordSet.getString("count"),0));
	    	// 将未读的总数初始化为开始的总数
	    	secNewCountMap.put(MultiAclManager.PREFIX+RecordSet.getString("seccategory"),Util.getIntValue(RecordSet.getString("count"),0));
	    }
	    //System.out.println("total Count end------"+new Date().getTime());
	    //刘煜改为总的目录 看过的文章 
	    sql="select count(t1.id) count,t1.seccategory from ";
	    sql += tables+"  t2, ";
	    sql = sql + " DocDetail  t1 ";
	    sql += " where  ((docstatus = 7 ";
	    if(!urlType.equals("11")){
	    	sql += "and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))";
	    }
	    sql += ") or ";
	    
	    if(searchType.equals("1")){
	    	sql += "docstatus!=8 and docstatus!=9)";	
	    }else{
	    	sql+= "docstatus in ("+docstatus+"))";
	    }
	    
	   sql+= "   and t1.id=t2.sourceid";
	    if(dspreply.equals("1")){
	    	sql+= "   and (t1.isreply is null or t1.isreply='' or t1.isreply=0)";
	    }else if(dspreply.equals("2")){
	    	sql+= "   and t1.isreply=1";
	    }
	    //sql+=" and (t1.id in( select docid from docReadTag where userid=1 and usertype=1 ) or t1.doccreaterid=1 and t1.usertype=1)";
		if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
			  belongtoids+=","+user.getUID();
	    sql+=" and (t1.id in( select docid from docReadTag where userid in("+belongtoids+") and usertype=1 ) or (t1.doccreaterid in("+belongtoids+") and t1.usertype=1))";
        }else{
	    sql+=" and (t1.id in( select docid from docReadTag where userid="+user.getUID()+" and usertype=1 ) or (t1.doccreaterid="+user.getUID()+" and t1.usertype=1))";
		}
		sql+=whereclause;
	    sql+=" group by t1.seccategory order by t1.seccategory ";
	    //System.out.println("new Count start------"+new Date().getTime());
	    RecordSet.executeSql(sql);
	    while(RecordSet.next()){
	    	String tempsecid = Util.null2String( RecordSet.getString("seccategory") ) ;
	    	int secidhasread = Util.getIntValue( RecordSet.getString("count") , 0 ) ;
	    	int secallcount = 0;
			try{
				secallcount = secAllCountMap.get(MultiAclManager.PREFIX+tempsecid) ;
			}catch(Exception e){
				e.printStackTrace();
				continue;
			}
	    	 int secidhasnotread = secallcount - secidhasread ;
	         if(secidhasnotread < 0) secidhasnotread = 0 ;
	         if(onlyCount.equals("1")){
	        	 for(int i=0;i<jsonArr.size();i++){
	        		 JSONObject json = jsonArr.getJSONObject(i);
	        		 String domid = json.getString("__domid__");
	        		 if(domid.equals(MultiAclManager.PREFIX+tempsecid)){
	        			 JSONObject numbers = json.getJSONObject("numbers");
	        			 numbers.put("docNew",secidhasnotread);
	        			 break;
	        		 }
	        	 }
	         }
	         secNewCountMap.put(MultiAclManager.PREFIX+tempsecid,secidhasnotread);
	    }
	}
	params.put("dspreply",dspreply);
	params.put("logintype",logintype);
	params.put("secAllCountMap",secAllCountMap);
	params.put("secNewCountMap",secNewCountMap);
	//params.put("whereclause",whereclause);
	params.put("addDiyDom","true");
}
if(onlyCount.equals("1")){
	out.println(jsonArr.toString());	
}else{
	MultiCategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), operationcode,categoryname,Util.getIntValue(subcompanyId,-1),params);
	out.println(tree.getTreeCategories().toString());
}
%>
