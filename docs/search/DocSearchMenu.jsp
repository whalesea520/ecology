
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*,net.sf.json.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="docReplyUtil" class="weaver.docs.docs.reply.DocReplyUtil" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
String belongtoids = user.getBelongtoids();
String account_type = user.getAccount_type();
  if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
			 belongtoids+=","+user.getUID();
  }
String subcompanyId = Util.null2String(request.getParameter("subCompanyId"));
String categoryname = Util.null2String(request.getParameter("categoryname"));





String url = Util.null2String(request.getParameter("url"));
String urlType = Util.null2String(request.getParameter("urlType"));
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
String doccreatedateselect = Util.null2String(request.getParameter("doccreatedateselect"));
Map<String,Object> params = new HashMap<String,Object>();
int operationcode = Util.getIntValue(request.getParameter("operationcode"),-1);
String onlyCount = Util.null2String(request.getParameter("onlyCount"));
JSONArray jsonArr = new JSONArray();
params.put("_url",url);
params.put("urlType",urlType);
params.put("offical",offical);
params.put("officalType",officalType);
params.put("doccreatedateselect",doccreatedateselect);
params.put("subcompanyIdShare",subcompanyId);
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
String selectedContent = "";
int infoId = Util.getIntValue(request.getParameter("infoId"),0);

	LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
    LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
    if(info!=null){
	  selectedContent = info.getSelectedContent();
    }else{
	  selectedContent = Util.null2String(request.getParameter("selectedContent"));
	}
	String[] docCategoryArray = null;
	String  advanids="";
	if(fromAdvancedMenu==1){
	docCategoryArray = Util.TokenizerString2(selectedContent,"C");	
	if(docCategoryArray!=null&&docCategoryArray.length>0){
		for(int k=0;k<docCategoryArray.length;k++){
			if(advanids.equals("")){
			   advanids=docCategoryArray[k];
			}else{
			  advanids=advanids+","+docCategoryArray[k];
			
			}
			
			

		}
		 params.put("sqlwheread"," and id in ("+advanids+")");
		
	 }
	

    }

MultiAclManager am = new MultiAclManager();
if(operationcode==-1){
	
	String whereclause = "";
	String sql = "";
	String docstatus = "'1','2','5'";
	if(urlType.equals("5")){
		//docstatus += ",'0','3','4','6','7'";
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
	if(urlType.equals("5")){
		doccreaterid = ""+user.getUID();
	}
	%>
	<%@ include file="/docs/common.jsp" %>
	<%
	
	if(!doccreaterid.equals("")&&!doccreaterid.equals("0")){
		if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		whereclause+=" and doccreaterid in("+belongtoids+")";
		}else{
			if(urlType.equals("5")){
			    whereclause+=" and (doccreaterid="+doccreaterid+" or ownerid="+user.getUID()+")";
			}else{
			    whereclause+=" and doccreaterid="+doccreaterid;
			}
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
	if(urlType.equals("0")){
      if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		   belongtoids+=","+user.getUID();
		whereclause+=" and  NOT EXISTS (select 1 from docReadTag where userid in("
							+ belongtoids + ") and usertype=" + logintype + " AND docid=T1.ID)  and t1.doccreaterid not in ( "+belongtoids+")";
	  }else{
		whereclause+=" and  NOT EXISTS (select 1 from docReadTag where userid="
							+ user.getUID() + " and usertype=" + logintype + " AND docid=T1.ID)  and t1.doccreaterid <> "+user.getUID();
	  }
	}
	/* added by wdl 2006-08-28 不显示历史版本 */
	whereclause+=" and (ishistory is null or ishistory = 0) ";
	/* added end */
	if(offical.equals("1")){//发文/收文库
		String _sql = "";
		String secids = "";
		if(officalType==1){
			 _sql = "select distinct secCategoryId from Workflow_DocProp where workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3))";
		}else if(officalType==2){
			_sql = "select distinct secCategoryId from Workflow_DocProp where workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (2))";
		}
		RecordSet.executeSql(_sql);
		while(RecordSet.next()){
			if(secids.equals("")){
				secids = Util.null2String(RecordSet.getString(1));
			}else{
				secids = secids + ","+Util.null2String(RecordSet.getString(1));
			}
		}
		String defaultview=null;
		ArrayList defaultviewList=null;
		String defaultcategory=null;
		if(officalType==1){
			 _sql = "select distinct defaultview from workflow_createdoc where status='1' and wfstatus='1' and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3))";
		}else if(officalType==2){
			_sql = "select distinct defaultview from workflow_createdoc where status='1' and wfstatus='1' and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (2))";
		}
		RecordSet.executeSql(_sql);
		while(RecordSet.next()){
			defaultview=Util.null2String(RecordSet.getString(1));
			defaultviewList=Util.TokenizerString(defaultview,"||");
			if(defaultviewList!=null&&defaultviewList.size()>0){
				defaultcategory=""+defaultviewList.get(2);
			}
			if(!defaultcategory.trim().equals("")&&((","+secids+",").indexOf(","+defaultcategory+",")==-1)){
				if(secids.equals("")){
					secids = defaultcategory;
				}else{
					secids = secids + ","+defaultcategory;
				}
			}
		}
		secids = secids.replaceAll(",{2,}",",");
		if(secids.trim().equals("")){
			secids="-2";
		}
		whereclause += " and seccategory in ("+secids+")";
	}
	
	if(urlType.equals("10")){//批量共享
		whereclause+=" and sharelevel=3 ";
		whereclause+=" and exists(select 1 from DocSecCategory where DocSecCategory.id=t1.secCategory and DocSecCategory.shareable='1') ";	
	}
	Map<String,Integer> secAllCountMap = new HashMap<String,Integer>();
	Map<String,Integer> secNewCountMap = new HashMap<String,Integer>();
	if(logintype.equals("1")){  //内部用户的处理
		 if(urlType.equals("11")){
		 		sql = "select count(t1.id) count,t1.seccategory from DocDetail  t1 where ";
		 } else if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		 		sql = "select count(t1.id) count,t1.seccategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid in("+belongtoids+") or ownerid in ("+belongtoids+") ))) or ";
		 }else{
		 		sql = "select count(t1.id) count,t1.seccategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or ";
		 }
		 
		 if(urlType.equals("5")){
			 sql += "docstatus !=8 and docstatus!=9) and t1.id=t2.sourceid ";
		 } else if(urlType.equals("11")){
		 	 sql += "docstatus in ("+docstatus+") ";
		 } else {
		 	 sql += "docstatus in ("+docstatus+")) and t1.id=t2.sourceid ";
		 }
	    sql+=whereclause;
		//是否启用新版回复
	    if(docReplyUtil.isUseNewReply()){
	    	sql+= "  and (isreply != 1 or isreply is null) ";
	    }else{
			if(dspreply.equals("1")){
				sql+= "   and (t1.isreply is null or t1.isreply='' or t1.isreply=0)";
			}else if(dspreply.equals("2")){
				sql+= "   and t1.isreply=1";
			}
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
	    if(!urlType.equals("11")){
	    	sql += tables+"  t2, ";
	    }
	    sql = sql + " DocDetail  t1 ";
	    sql += " where  ((docstatus = 7 ";
	    if(!urlType.equals("11")){
	    	sql += "and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))";
	    }
	    sql += ") or ";
	    if(urlType.equals("5")){
	    	sql += "docstatus!=8 and docstatus!=9)";	
	    }else{
	    	sql+= "docstatus in ("+docstatus+"))";
	    }
	    if(!urlType.equals("11")){
	    	sql+= "   and t1.id=t2.sourceid";
	    }
	    //是否启用新版回复
	    if(docReplyUtil.isUseNewReply()){
	    	sql+= "  and (isreply != 1 or isreply is null) ";
	    }else{
			if(dspreply.equals("1")){
				sql+= "   and (t1.isreply is null or t1.isreply='' or t1.isreply=0)";
			}else if(dspreply.equals("2")){
				sql+= "   and t1.isreply=1";
			}
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
	   // System.out.println("new Count end------"+new Date().getTime());
	}else{
	
		  sql="select count(t1.id) count,t1.seccategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and t1.id=t2.sourceid ";
		  sql += whereclause;
		  //是否启用新版回复
	    if(docReplyUtil.isUseNewReply()){
	    	sql+= "  and (isreply != 1 or isreply is null) ";
	    }else{
			if(dspreply.equals("1")){
				sql+= "   and (t1.isreply is null or t1.isreply='' or t1.isreply=0)";
			}else if(dspreply.equals("2")){
				sql+= "   and t1.isreply=1";
			}
		}
		  sql += " group by t1.seccategory order by t1.seccategory ";
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
		    //刘煜改为总的子目录 看过的文章 
		    sql = "select count(distinct t1.id) count,t1.seccategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on  t1.id=t2.docid where t1.id=t3.sourceid and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='2')  or ( t2.userid="+user.getUID()+" and t2.usertype=2 ) )" ;
		    sql += whereclause;
		    //是否启用新版回复
	    if(docReplyUtil.isUseNewReply()){
	    	sql+= "  and (isreply != 1 or isreply is null) ";
	    }else{
			if(dspreply.equals("1")){
				sql+= "   and (t1.isreply is null or t1.isreply='' or t1.isreply=0)";
			}else if(dspreply.equals("2")){
				sql+= "   and t1.isreply=1";
			}
		}
		    sql += " group by t1.seccategory order by t1.seccategory ";
		    RecordSet.executeSql(sql);
		    while(RecordSet.next()){
		    	String tempsecid = Util.null2String( RecordSet.getString("seccategory") ) ;
		    	int secidhasread = Util.getIntValue( RecordSet.getString("count") , 0 ) ;
		    	int secallcount = secAllCountMap.get(MultiAclManager.PREFIX+tempsecid) ;
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
}else{
	
	params.put("addDiyDom","true");
	params.put("canSelect","true");
	String myFavorite=Util.null2String(request.getParameter("myFavorite"));
	String myCommonDir=Util.null2String(request.getParameter("myCommonDir"));
	String sqlwhere = "";
	String secids = "";
	params.put("myFavorite",myFavorite);
	if(!"true".equalsIgnoreCase(myCommonDir)){
		
		RecordSet.execute("select distinct secid from user_favorite_category a where exists(select 1 from DirAccessControlDetail b where b.sourceid = a.secid and ((type=1 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=2 and content in ("+am.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+")) and b.sharelevel=0 ) and a.usertype='"+user.getLogintype()+"' and a.userid='"+user.getUID()+"' order by secid asc");
		while(RecordSet.next()){
			if(secids.equals("")){
				secids = ""+RecordSet.getInt("secid");
			}else{
				secids = secids+","+RecordSet.getInt("secid");
			}
		}
		if(secids.equals("")){
			secids="0";
		}
		params.put("hasFavoriteList",secids);
	}
	if("true".equalsIgnoreCase(myFavorite)){
		
		sqlwhere = " id in ("+secids+")";
		params.put("addDiyDom","true");
		params.put("optitle",SystemEnv.getHtmlLabelNames("19133,18030",user.getLanguage()));
	}else if("true".equalsIgnoreCase(myCommonDir)){
		
		if(RecordSet.getDBType().equals("oracle")){
			RecordSet.execute("SELECT distinct * FROM (select secid from DocCategoryUseCount a where exists(select 1 from DirAccessControlDetail b where b.sourceid = a.secid and ((type=1 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=2 and content in ("+am.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+")) and b.sharelevel=0 ) and a.userid='"+user.getUID()+"' order by count desc,secid asc ) WHERE ROWNUM <= 12");
		}else{
			RecordSet.execute("select distinct top 12 * from DocCategoryUseCount a where exists(select 1 from DirAccessControlDetail b where b.sourceid = a.secid and ((type=1 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=2 and content in ("+am.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+")) and b.sharelevel=0 ) and a.userid='"+user.getUID()+"' order by count desc,secid asc");
		}
		while(RecordSet.next()){
			if(secids.equals("")){
				secids = ""+RecordSet.getInt("secid");
			}else{
				secids = secids+","+RecordSet.getInt("secid");
			}
		}
		if(secids.equals("")){
			secids="0";
		}
		sqlwhere = " id in ("+secids+")";
		params.put("myCommonDir",myCommonDir);
		params.put("addDiyDom","false");
		params.put("optitle","");
	}else{
		params.put("optitle",SystemEnv.getHtmlLabelNames("193,18030",user.getLanguage()));
	}

	if(fromAdvancedMenu==1){
	
		sqlwhere+=" and id in("+advanids+")";	
		
		params.put("sqlwheread",sqlwhere);
	}else{
	    params.put("sqlwhere",sqlwhere);
	}
}
if(onlyCount.equals("1")){
	out.println(jsonArr.toString());	
}else{

String hasRightSub = Util.null2String(session.getAttribute("hasRightSub"));
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
int defsub=-1;

if(isUseDocManageDetach&&(urlType.equals("15")||urlType.equals("11"))&&subcompanyId.equals("")){
am.setHasRightSub(hasRightSub);
if(!hasRightSub.equals("")){
	 if(hasRightSub.indexOf(',')>-1){  
	      defsub=Util.getIntValue(hasRightSub.substring(0,hasRightSub.indexOf(',')),-1);
       }else{
          defsub=Util.getIntValue(hasRightSub,-1);
       }
	
}
}
	if(urlType.equals("22")||urlType.equals("23")){//文档回收站，不显示数量，显示的目录为回收站中相关文档的目录
		String secids="";
		String sqlwhere="";
		String recyclesql="";
		if(urlType.equals("23")){
			recyclesql="select distinct seccategory  from recycle_DocDetail  where ishistory!=1 ";
		}else{
			recyclesql="select distinct seccategory  from recycle_DocDetail  where ishistory!=1 and docdeleteuserid="+user.getUID();
		}
		RecordSet.execute(recyclesql);
		while(RecordSet.next()){
			if(secids.equals("")){
				secids = ""+RecordSet.getInt("seccategory");
			}else{
				secids = secids+","+RecordSet.getInt("seccategory");
			}
		}
		if(secids.equals("")){
			secids="0";
		}
		sqlwhere = " id in ("+secids+")";
		params.put("addDiyDom","false");
		params.put("sqlwhere",sqlwhere);
	}
	MultiCategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), operationcode,categoryname,Util.getIntValue(subcompanyId,defsub),params);
	out.println(tree.getTreeCategories().toString());
}
%>
