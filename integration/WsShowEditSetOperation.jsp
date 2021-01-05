
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.servicefiles.ResetXMLFileCache"%>
<%@ page import="weaver.integration.logging.Logger"%>
<%@ page import="weaver.integration.logging.LoggerFactory"%>
<%@ page import="weaver.formmode.excel.ModeCacheManager"%>
<jsp:useBean id="BrowserXML" class="weaver.servicefiles.BrowserXML" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("intergration:datashowsetting", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
Logger log = LoggerFactory.getLogger();
String operator = Util.fromScreen(request.getParameter("operator"),user.getLanguage());
String isDialog = Util.null2String(request.getParameter("isdialog"));
String backto = Util.fromScreen(request.getParameter("backto"),user.getLanguage());
String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
String showname = Util.null2String(request.getParameter("showname"));
String name = Util.null2String(request.getParameter("name"));
String typename = Util.null2String(request.getParameter("typename"));
int showclass = Util.getIntValue(Util.null2String(request.getParameter("showclass")),0);
int showclass1 = Util.getIntValue(Util.null2String(request.getParameter("showclass1")),0);
if(Util.null2String(request.getParameter("showclass")).equals(""))
	showclass = showclass1;
int datafrom = Util.getIntValue(Util.null2String(request.getParameter("datafrom")),0);
String datasourceid = Util.null2String(request.getParameter("datasourceid"));
String sqltext = Util.null2String(request.getParameter("sqltext"));
String searchById = Util.null2String(request.getParameter("searchById"));

String wsurl = Util.null2String(request.getParameter("wsurl"));//web service地址
String wsworkname = Util.null2String(request.getParameter("wsworkname"));//调用的web service的空间名
String customhref = Util.null2String(request.getParameter("customhref"));//自定义页面地址

String wsoperation = Util.null2String(request.getParameter("wsoperation"));//调用的web service的方法
String xmltext = Util.null2String(request.getParameter("xmltext"));
String inpara = Util.null2String(request.getParameter("inpara"));
int showtype = Util.getIntValue(Util.null2String(request.getParameter("showtype")));

String keyfield = Util.null2String(request.getParameter("keyfield"));
String parentfield = Util.null2String(request.getParameter("parentfield"));
String showfield = Util.null2String(request.getParameter("showfield"));
String detailpageurl = Util.null2String(request.getParameter("detailpageurl"));

String selecttype = Util.null2String(request.getParameter("selecttype"));
String showpageurl = Util.null2String(request.getParameter("showpageurl"));

String methodtypes[] = request.getParameterValues("methodtype");
String paramnames[] = request.getParameterValues("paramname");
String paramtypes[] = request.getParameterValues("paramtype");
String isarrays[] = request.getParameterValues("isarray");
String paramsplits[] = request.getParameterValues("paramsplit");
String paramvalues[] = request.getParameterValues("paramvalue");

if("save".equals(operator))
{
	String oldpointid = "";
	String oldshowclass = "";
	String oldshowtype = "";
	if(Util.getIntValue(id,0)>0)
	{
		String sql = "select * from datashowset where id="+id;
		rs.executeSql(sql);
		if(rs.next())
		{
			oldpointid = rs.getString("showname");
			oldshowclass = rs.getString("showclass");
			oldshowtype = rs.getString("showtype");
		}
	}
	String operatetype = "";
	if(!"1".equals(oldshowclass))
	{
		if(1==showclass)
		{
			operatetype = "add";
		}
	}
	else
	{
		if(1!=showclass)
		{
			operatetype = "delete";
		}
		else
		{
			operatetype = "edit";
		}
	}
	Hashtable dataHST = new Hashtable();
    
	if(1==showclass && false)
	{
		String sql = "select 1 from datashowset where showname=? and showclass=?";
		if(Util.getIntValue(id)>0)
		{
			sql = "select 1 from datashowset where showname=? and showclass=? and id!=?";
		}
		ConnStatement connst = null;
		try{
			
		connst = new ConnStatement();
		connst.setStatementSql(sql);
		connst.setString(1,showname);
		connst.setString(2,"1");
		if(Util.getIntValue(id)>0)
		{
			connst.setInt(3,Util.getIntValue(id));
		}
		connst.executeQuery();
		//rs.executeSql(sql);
		if(connst.next())
		{
			connst.close();
			request.getRequestDispatcher("/integration/WsShowEditSet.jsp?msg=1").forward(request,response);
			return;
		}
		
		}catch(Exception e){
			log.error(e);
			e.printStackTrace();
		}finally {
			connst.close();
		}
		
		ArrayList pointArrayList = BrowserXML.getPointArrayList();
		for(int i=0;i<pointArrayList.size();i++){
		    String pointid = (String)pointArrayList.get(i);
		    if(pointid.equals("")) continue;
		    Hashtable thisDetailHST = (Hashtable)dataHST.get(pointid);
		    if(thisDetailHST!=null){
		        String from = Util.null2String((String)thisDetailHST.get("from"));
			    if(showname.equalsIgnoreCase(pointid)&&!"2".equals(from))
			    {
			    	request.getRequestDispatcher("/integration/WsShowEditSet.jsp?msg=1").forward(request,response);
					return;
			    }
		    }
		}
		
		if(!"3".equals(showtype))
		{
			if(datafrom==1)
			{
		    	dataHST.put("search",sqltext);
		    	dataHST.put("ds",datasourceid);
		    }
		    else if(datafrom==0)
		    {
		    	dataHST.put("search",wsurl);
		    	dataHST.put("ds","");
		    }
			else
			{
				dataHST.put("search",customhref);
		    	dataHST.put("ds","");
			}
			dataHST.put("name",name);
		    dataHST.put("searchById",searchById);
		    dataHST.put("searchByName","");
		    dataHST.put("nameHeader","");
		    dataHST.put("descriptionHeader","");
		    dataHST.put("outPageURL",showpageurl);
		    dataHST.put("from","2");
		    dataHST.put("href",detailpageurl);
		    dataHST.put("showtree",(2==showtype)?"1":"0");
		    dataHST.put("nodename",showfield);
		    dataHST.put("parentid",parentfield);
		    dataHST.put("ismutil","2".equals(selecttype)?"1":"0");
	    }
	    else
	    {
	    	dataHST.put("search","");
	    	dataHST.put("ds","");
	    	dataHST.put("name",name);
		    dataHST.put("searchById","");
		    dataHST.put("searchByName","");
		    dataHST.put("nameHeader","");
		    dataHST.put("descriptionHeader","");
		    dataHST.put("outPageURL",showpageurl);
		    dataHST.put("from","2");
		    dataHST.put("href",detailpageurl);
		    dataHST.put("showtree","0");
		    dataHST.put("nodename","");
		    dataHST.put("parentid","");
		    dataHST.put("ismutil","0");
	    }
	}
	//System.out.println("operatetype : "+operatetype+"  oldpointid : "+oldpointid+" showname : "+showname);
	/*
    if("delete".equals(operatetype))
    {
    	BrowserXML.writeToBrowserXMLDel(oldpointid);
    }
    else if("add".equals(operatetype))
    {
    	BrowserXML.writeToBrowserXMLAdd(showname,dataHST);
    }
    else if("edit".equals(operatetype))
    {
    	//先删除
    	BrowserXML.writeToBrowserXMLDel(oldpointid);
    	//再添加
    	BrowserXML.writeToBrowserXMLAdd(showname,dataHST);
    }
	*/
	String currentDateString = weaver.general.TimeUtil.getCurrentTimeString();
	String operatedate = currentDateString.substring(0,10);
	String operatetime = currentDateString.substring(11);
		
	//System.out.println("Util.getIntValue(id) : "+Util.getIntValue(id));
	if(Util.getIntValue(id)>0)
	{
		//判断标识是否已经存在
		 weaver.conn.RecordSet cs = new weaver.conn.RecordSet();
		 String check="select * from datashowset  where id='"+id+"'";
		 cs.executeSql(check);
		 if(cs.next()){
			   String oldshowname=cs.getString("showname");
			   //System.out.println("oldshowname:"+oldshowname+",showname:"+showname);
			   if(!showname.equals(oldshowname)){
				   String sqls="select * from datashowset  where showname='"+showname+"'";
				   cs.executeSql(sqls);
				   if(cs.next()){
					   request.getRequestDispatcher("/integration/WsShowEditSet.jsp?msg=1").forward(request,response);
						return;
				   }
			   }
		 }
		String SQL = "update datashowset set showname=?,name=?,typename=?,showclass=?,datafrom=?,datasourceid=?,sqltext=?,wsurl=?,wsoperation=?,xmltext=?,inpara=?,showtype=?,parentfield=?,showfield=?,keyfield=?,detailpageurl=?,selecttype=?,showpageurl=?,browserfrom=?,customhref=?,wsworkname=?,searchById=?,modifydate=?,modifytime=? where id=?";
		
		ConnStatement connst = null;
		try
        {
			connst = new ConnStatement();
	        connst.setStatementSql(SQL);
	        connst.setString(1, showname);
	        connst.setString(2, name);
	        connst.setString(3, typename);
	        connst.setString(4, ""+showclass);
	        connst.setString(5, ""+datafrom);
	        connst.setString(6, ""+datasourceid);
	        connst.setString(7, sqltext);
	        connst.setString(8, wsurl);
	        connst.setString(9, wsoperation);
	        connst.setString(10, xmltext);
	        connst.setString(11, inpara);
	        connst.setString(12, ""+showtype);
	        connst.setString(13, parentfield);
	        connst.setString(14, showfield);
	        connst.setString(15, keyfield);
	        connst.setString(16, detailpageurl);
	        connst.setString(17, selecttype);
	        connst.setString(18, showpageurl);
	        connst.setInt(19, 2);
	        connst.setString(20, customhref);
			connst.setString(21, wsworkname);
	        connst.setString(22, searchById);
			connst.setString(23, operatedate);//修改日期
			connst.setString(24, operatetime);//修改时间
	        connst.setInt(25, Util.getIntValue(id));
	        connst.executeUpdate();
	        
	        boolean isused = BrowserXML.isUsed(oldpointid,oldshowclass,oldshowtype);
	        if(isused)
	        {
	        	BrowserXML.updateUseField(""+oldpointid,""+oldshowclass,""+oldshowtype,""+showname,""+showclass,""+showtype);
	        }
			
        }catch(Exception e){
            log.error(e);
    		e.printStackTrace();
        }finally {
			connst.close();
		}
	}
	else
	{
		//判断标识是否已经存在
		 weaver.conn.RecordSet cs = new weaver.conn.RecordSet();
		 String check="select * from datashowset  where showname='"+showname+"'";
		 cs.executeSql(check);
		 if(cs.next()){
				request.getRequestDispatcher("/integration/WsShowEditSet.jsp?msg=1").forward(request,response);
				return;
		 }
		String SQL = "INSERT INTO datashowset(showname,name,typename,showclass,datafrom,datasourceid,sqltext,wsurl,wsoperation,xmltext,inpara,showtype,parentfield,showfield,keyfield,detailpageurl,selecttype,showpageurl,browserfrom,customhref,wsworkname,searchById,createdate,createtime,modifydate,modifytime) "
					+ " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
					
		ConnStatement connst = null;
		try
        {
			connst = new ConnStatement();
	        connst.setStatementSql(SQL);
	        connst.setString(1, showname);
	        connst.setString(2, name);
	        connst.setString(3, typename);
	        connst.setString(4, ""+showclass);
	        connst.setString(5, ""+datafrom);
	        connst.setString(6, ""+datasourceid);
	        connst.setString(7, sqltext);
	        connst.setString(8, wsurl);
	        connst.setString(9, wsoperation);
	        connst.setString(10, xmltext);
	        connst.setString(11, inpara);
	        connst.setString(12, ""+showtype);
	        connst.setString(13, parentfield);
	        connst.setString(14, showfield);
	        connst.setString(15, keyfield);
	        connst.setString(16, detailpageurl);
	        connst.setString(17, selecttype);
	        connst.setString(18, showpageurl);
	        connst.setInt(19, 2);
	        connst.setString(20, customhref);
		  	connst.setString(21, wsworkname);
	        connst.setString(22, searchById);
			connst.setString(23, operatedate);//创建日期
			connst.setString(24, operatetime);//创建时间
			connst.setString(25, operatedate);//修改日期
			connst.setString(26, operatetime);//修改时间
	        connst.executeUpdate();
			
			connst.setStatementSql("select max(id) from datashowset where showname=?");
			connst.setString(1, showname);
			connst.executeQuery();
			id = "";
			if(connst.next()){
				id = connst.getString(1);
			}
        }
        catch(Exception e)
        {
            log.error(e);
    		e.printStackTrace();
        }finally {
			connst.close();
		}
        
	}
	
	if(Util.getIntValue(id)>0)
	{
		String fieldname1s[] = request.getParameterValues("fieldname1");
		String searchname1s[] = request.getParameterValues("searchname1");
		String fieldtype1s[] = request.getParameterValues("fieldtype");
		String wokflowfieldnames[] = request.getParameterValues("wokflowfieldname");
		
		rs.executeSql("delete from datasearchparam where mainid="+id);
		if(fieldname1s!=null){
			
			
				
			for(int i=0;i<fieldname1s.length;i++){
				String fieldname=fieldname1s[i];
				String searchname=searchname1s[i];
				String fieldtype=fieldtype1s[i];
				String wokflowfieldname=wokflowfieldnames[i];
				if(!(fieldname.trim().equals(""))&&!(searchname.trim().equals("")))
				{
					String tempsql = "insert into datasearchparam(mainid,fieldname,searchname,fieldtype,wokflowfieldname) values(?,?,?,?,?)";
					ConnStatement connst = null;
					try{
						connst = new ConnStatement();
				        connst.setStatementSql(tempsql);
				        connst.setInt(1, Util.getIntValue(id));
				        connst.setString(2, fieldname);
				        connst.setString(3, searchname);
				        connst.setString(4, ""+fieldtype);
				        connst.setString(5, ""+wokflowfieldname);
				        connst.executeUpdate();
					}catch(Exception e){
						log.error(e);
						e.printStackTrace();
					}finally {
						connst.close();
					}
				}
			}
		}
		
		String fieldname2s[] = request.getParameterValues("fieldname2");
		String searchname2s[] = request.getParameterValues("searchname2");
		String isshownames[] = request.getParameterValues("isshowname");
		String transqls[] = request.getParameterValues("transql");
		
		rs.executeSql("delete from datashowparam where mainid="+id);
		if(fieldname2s!=null){
			
			
				
			for(int i=0;i<fieldname2s.length;i++){
				String fieldname=fieldname2s[i];
				String searchname=searchname2s[i];
				String transql=transqls[i];
				String isshowname=""+Util.getIntValue(isshownames[i],0);
				if(!fieldname.equals("")&&!searchname.equals(""))
				{
					String tempsql = "insert into datashowparam(mainid,fieldname,searchname,transql,isshowname) values(?,?,?,?,?)";
					ConnStatement connst = new ConnStatement();
					try{
						connst = new ConnStatement();
					
				        connst.setStatementSql(tempsql);
				        connst.setInt(1, Util.getIntValue(id));
				        connst.setString(2, fieldname);
				        connst.setString(3, searchname);
				        connst.setString(4, ""+transql);
				        connst.setString(5, ""+isshowname);
				        connst.executeUpdate();
						
					}catch(Exception e){
						log.error(e);
						e.printStackTrace();
					}finally {
						connst.close();
					}
			    }
			}
		}
		
		rs.executeSql("delete from wsmethodparamvalue where contenttype=6 and contentid="+id);
		if(methodtypes!=null){
			for(int i=0;i<methodtypes.length;i++){
				String methodtype=methodtypes[i];
				String paramname=paramnames[i];
				String paramtype=paramtypes[i];
				String isarray=isarrays[i];
				String paramsplit=paramsplits[i];
				String paramvalue=paramvalues[i];
				paramvalue=paramvalue.replace("'","''");//qc:295327 [80][90]数据展现集成-数据来源为Webservice时，方法参数值带有英文单引号保存导致参数被清除问题
				String methodid = "";
				//System.out.println("methodtype : "+methodtype+" paramname : "+paramname);
				methodid = wsoperation;
				if("".equals(methodid))
					methodid = "0";
				if(!methodid.equals("")&&!methodtype.equals(""))
				{
					String dsql = "insert into wsmethodparamvalue(contenttype,contentid,methodid,paramname,paramtype,isarray,paramsplit,paramvalue) "+
								  "values(6,"+id+","+methodid+",'"+paramname+"','"+paramtype+"','"+isarray+"','"+paramsplit+"','"+paramvalue+"')";
					rs.executeSql(dsql);
				}
			}
		}
	}
	ResetXMLFileCache.resetCache();
	ModeCacheManager.getInstance().reloadBrowser(showname);
	if("1".equals(isDialog)){
%>
<script language=javascript >
    try{
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location.href="/integration/WsShowEditSetList.jsp?typename=<%=typename%>";
		parentWin.closeDialog();
	}catch(e){
		
	}
</script>
<%
    }else{
 		response.sendRedirect("/integration/WsShowEditSet.jsp?backto="+backto+"&typename="+typename+"&id="+id);
	}
}
else if("delete".equals(operator))
{
	String errormsg = "";
	List idlist = Util.TokenizerString(id,",");
	if(null!=idlist&&idlist.size()>0)
	{
		for(int i = 0;i<idlist.size();i++)
		{
			String tempid = Util.null2String((String)idlist.get(i));
			if(!"".equals(tempid))
			{
				if(Util.getIntValue(tempid)>0)
				{
					String oldpointid = "";
					String oldshowclass = "";
					String oldshowtype = "";
					if(Util.getIntValue(tempid,0)>0)
					{
						String sql = "select * from datashowset where id="+tempid;
						rs.executeSql(sql);
						if(rs.next())
						{
							oldpointid = rs.getString("showname");
							showname = oldpointid;
							oldshowclass = rs.getString("showclass");
							oldshowtype = rs.getString("showtype");
							
						}
						if("1".equals(oldshowclass)&&("1".equals(oldshowtype)||"2".equals(oldshowtype)))
				 		{
							//先删除
							boolean isused = BrowserXML.isUsed(oldpointid,oldshowclass,oldshowtype);
							
							if(!isused)
							{
								BrowserXML.writeToBrowserXMLDel(oldpointid);
								String SQL = "delete from datashowset where id="+tempid;
								rs.executeSql(SQL);
								rs.executeSql("delete from datasearchparam where mainid="+tempid);
								rs.executeSql("delete from datashowparam where mainid="+tempid);
							}
							else
							{
								errormsg = "1";
							}
				 		}
						else
						{
							String SQL = "delete from datashowset where id="+tempid;
							rs.executeSql(SQL);
							rs.executeSql("delete from datasearchparam where mainid="+tempid);
							rs.executeSql("delete from datashowparam where mainid="+tempid);
						}
					}
				}
			}
		}
	}
	ResetXMLFileCache.resetCache();
	ModeCacheManager.getInstance().reloadBrowser(showname);
	
	if("1".equals(isDialog)){
%>
<script language=javascript >
    try{
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location.href="/integration/WsShowEditSetList.jsp";
		parentWin.closeDialog();
	}catch(e){
		
	}
</script>
<%
    }else{
 		response.sendRedirect("/integration/WsShowEditSetList.jsp?backto="+backto+"&errormsg="+errormsg);
	}
}
%>