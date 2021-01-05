<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.file.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.conn.ConnStatement"%>
<%@ page import="weaver.integration.logging.Logger"%>
<%@ page import="weaver.integration.logging.LoggerFactory"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser(request, response);
if(user == null) return;
if(!HrmUserVarify.checkUserRight("intergration:hrsetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}

Logger log = LoggerFactory.getLogger();
FileUpload fu = new FileUpload(request,false);
String operation = Util.null2String(fu.getParameter("operation"));
String isDialog = Util.null2String(fu.getParameter("isdialog"));
String custominterface = "";
List sqlList = new ArrayList();
boolean isimportsuccess = false;
if(operation.equals("import"))
{
	int fileid = 0 ;
	fileid = Util.getIntValue(fu.uploadFiles("filename"),0);

	String sql = "select filerealpath,isaesencrypt,aescode from imagefile where imagefileid = "+fileid;
	rs.executeSql(sql);
	String uploadfilepath="";
	String isaesencrypt = "";
	String aescode = "";
	if(rs.next()){
		uploadfilepath =  rs.getString("filerealpath");
		isaesencrypt =  rs.getString("isaesencrypt");
		aescode =  rs.getString("aescode");
		//System.out.println("isaesencrypt : "+isaesencrypt+" aescode : "+aescode);
	}
	if(!uploadfilepath.equals(""))
	{
		File tempfile = new File(uploadfilepath);
		//System.out.println("tempfile : "+tempfile+"  "+tempfile.getAbsolutePath()+"isaesencrypt "+isaesencrypt );
		if(tempfile.exists()&&tempfile.isFile())
		{
			ArrayList tempsqlList = null;
			if(isaesencrypt.equals("1")){
				File wfxml = new File(uploadfilepath);
				InputStream imagefile = null;
				/*QC308474 [80][90][缺陷]HR同步-Oracle数据库，WebService接口方式， 同步对应字段/XML属性中包含/符号， 导入文件时异常 start */
				/*FileInputStream fis = new FileInputStream(wfxml);
				InputStreamReader reader = new InputStreamReader(fis,"UTF-8");
				BufferedReader bufferedReader = new BufferedReader(reader); 
				StringBuffer buffer = new StringBuffer();  
				String line = "";  
				while ((line = bufferedReader.readLine()) != null){  
				    buffer.append(line);  
				}   
				imagefile=new ByteArrayInputStream(buffer.toString().getBytes()); 
				imagefile = AESCoder.decrypt(imagefile, aescode);
				tempsqlList = CommonUtil.getLineList(imagefile);
				//QC295287 [80][90]HR同步-解决导入同步数据字段有转换sql不能导入的问题  ---start
				if(null!=tempsqlList&&tempsqlList.size()>0)
				{
					rs.executeSql("delete from hrsyncset");
					rs.executeSql("delete from hrsyncsetparam");
					rs.executeSql("delete from wsmethodparamvalue where contenttype in(1,2,3,4)");
					for(int i = 0;i<tempsqlList.size();i++)
					{
						String tempsql = Util.null2String((String)tempsqlList.get(i)).trim();
						if(!"".equals(tempsql)&&!"GO".equalsIgnoreCase(tempsql)&&!"/".equals(tempsql))
						{
							if(tempsql.indexOf("hrsyncset")>-1||tempsql.indexOf("hrsyncsetparam")>-1||tempsql.indexOf("wsmethodparamvalue")>-1)
							{
								rs.executeSql(tempsql);
								isimportsuccess = true;
							}
						}
					}
				}*/
				imagefile = new BufferedInputStream(new FileInputStream(wfxml));
				imagefile = AESCoder.decrypt(imagefile, aescode);
				tempsqlList = CommonUtil.getLineList(imagefile);
			}else{
			/*	File wfxml = new File(uploadfilepath);
				InputStream imagefile = null;
				FileInputStream fis = new FileInputStream(wfxml);
				InputStreamReader reader = new InputStreamReader(fis,"UTF-8");
				BufferedReader bufferedReader = new BufferedReader(reader); 
				StringBuffer buffer = new StringBuffer();  
				String line = "";  
				while ((line = bufferedReader.readLine()) != null){  
				    buffer.append(line);  
				}   
				imagefile=new ByteArrayInputStream(buffer.toString().getBytes()); 
				tempsqlList = CommonUtil.getLineList(imagefile);
				if(null!=tempsqlList&&tempsqlList.size()>0)
				{
					rs.executeSql("delete from hrsyncset");
					rs.executeSql("delete from hrsyncsetparam");
					rs.executeSql("delete from wsmethodparamvalue where contenttype in(1,2,3,4)");
					String tmsql="";
			 
						 tmsql=tempsqlList.get(0).toString();
						 tmsql=tmsql.replaceAll("\\/","###");
						 
						 tmsql=tmsql.replaceAll("GO","###");
						 tmsql=tmsql.replaceAll(";","###");
 
						 String[] tmpsqls=tmsql.split("###");
						 for(int i=0;i<tmpsqls.length;i++){
							 String  tmpsql=tmpsqls[i];
							 if(tmpsql.indexOf("hrsyncset")>-1||tmpsql.indexOf("hrsyncsetparam")>-1||tmpsql.indexOf("wsmethodparamvalue")>-1)
								{
									rs.executeSql(tmpsql);
									isimportsuccess = true;
								}
					 }
				}*/
				tempsqlList = CommonUtil.getLineList(tempfile);
			}
			if(null!=tempsqlList&&tempsqlList.size()>0)
			{
				rs.executeSql("delete from hrsyncset");
				rs.executeSql("delete from hrsyncsetparam");
				rs.executeSql("delete from wsmethodparamvalue where contenttype in(1,2,3,4)");
				for(int i = 0;i<tempsqlList.size();i++)
				{
					String tempsql = Util.null2String((String)tempsqlList.get(i)).trim();
					if(!"".equals(tempsql)&&!"GO".equalsIgnoreCase(tempsql)&&!"/".equals(tempsql))
					{
						if(tempsql.indexOf("hrsyncset")>-1||tempsql.indexOf("hrsyncsetparam")>-1||tempsql.indexOf("wsmethodparamvalue")>-1)
						{
							rs.executeSql(tempsql);
							isimportsuccess = true;
						}
					}
				}
			}
			/*QC308474 [80][90][缺陷]HR同步-Oracle数据库，WebService接口方式， 同步对应字段/XML属性中包含/符号， 导入文件时异常 end */
		}
	}
	//QC295287 [80][90]HR同步-解决导入同步数据字段有转换sql不能导入的问题  ---end
	sql = "select * from hrsyncset";
	rs.executeSql(sql);
	if(rs.next())
	{
		custominterface = rs.getString("custominterface");
	}
}
else
{
	custominterface = Util.fromScreen(fu.getParameter("custominterface"),user.getLanguage());
	String isuselhr = Util.fromScreen(fu.getParameter("isuselhr"),user.getLanguage());
	isuselhr = isuselhr.equals("")?"0":"1";
	String intetype = Util.fromScreen(fu.getParameter("intetype"),user.getLanguage());
	String dbsource = Util.fromScreen(fu.getParameter("dbsource"),user.getLanguage());
	String webserviceurl = Util.fromScreen(fu.getParameter("webserviceurl"),user.getLanguage());
	String invoketype = Util.fromScreen(fu.getParameter("invoketype"),user.getLanguage());
	String customparams = Util.fromScreen(fu.getParameter("customparams"),user.getLanguage());

	String hrmethod = Util.fromScreen(fu.getParameter("hrmethod"),user.getLanguage());
	String TimeModul = Util.fromScreen(fu.getParameter("TimeModul"),user.getLanguage());
	String Frequency = "0";
	String frequencyy = "0";
	String createType = "";
	String createTime = "";
	Frequency=Util.null2String(fu.getParameter("fer_"+TimeModul));
	Frequency=Frequency.equals("0")?"1":Frequency;
	Frequency=Frequency.equals("")?"0":Frequency;
	frequencyy=frequencyy.equals("0")?"1":frequencyy;
	frequencyy=Util.null2String(fu.getParameter("frey"));
	frequencyy=frequencyy.equals("0")?"1":frequencyy;
	frequencyy=frequencyy.equals("")?"0":frequencyy;
	if("3".equals(TimeModul))
	//天
	{
	    createTime = Util.null2String(fu.getParameter("dayTime"));
	}
	else if("0".equals(TimeModul))
	//周
	{
	    createTime = Util.null2String(fu.getParameter("weekTime"));
	}
	else if("1".equals(TimeModul))
	//月
	{
	    createType = Util.null2String(fu.getParameter("monthType"));
	    createTime = Util.null2String(fu.getParameter("monthTime"));
	}
	else if("2".equals(TimeModul))
	//年
	{
	    createType = Util.null2String(fu.getParameter("yearType"));
	    createTime = Util.null2String(fu.getParameter("yearTime"));
	}
	if("".equals(createTime) || null == createTime)
	//如果创建时间为空，则默认为00:00
	{
	    createTime = "00:00";
	}
	String jobtable = Util.fromScreen(fu.getParameter("jobtable"),user.getLanguage());
	String depttable = Util.fromScreen(fu.getParameter("depttable"),user.getLanguage());
	String subcomtable = Util.fromScreen(fu.getParameter("subcomtable"),user.getLanguage());
	String hrmtable = Util.fromScreen(fu.getParameter("hrmtable"),user.getLanguage());
	String jobmothod = Util.fromScreen(fu.getParameter("jobmothod"),user.getLanguage());
	String deptmothod = Util.fromScreen(fu.getParameter("deptmothod"),user.getLanguage());
	String subcommothod = Util.fromScreen(fu.getParameter("subcommothod"),user.getLanguage());
	String hrmmethod = Util.fromScreen(fu.getParameter("hrmmethod"),user.getLanguage());
	String jobparam = Util.fromScreen(fu.getParameter("jobparam"),user.getLanguage());
	String deptparam = Util.fromScreen(fu.getParameter("deptparam"),user.getLanguage());
	String subcomparam = Util.fromScreen(fu.getParameter("subcomparam"),user.getLanguage());
	String hrmparam = Util.fromScreen(fu.getParameter("hrmparam"),user.getLanguage());
	String subcomouternew = Util.fromScreen(fu.getParameter("subcomouternew"),user.getLanguage());
	String deptouternew = Util.fromScreen(fu.getParameter("deptouternew"),user.getLanguage());
	String jobouternew = Util.fromScreen(fu.getParameter("jobouternew"),user.getLanguage());
	String hrmouternew = Util.fromScreen(fu.getParameter("hrmouternew"),user.getLanguage());

	String defaultPwd = Util.fromScreen(fu.getParameter("defaultPwd"),user.getLanguage());//密码默认值
	String pwdSyncType = Util.fromScreen(fu.getParameter("pwdsynctype"),user.getLanguage());//密码同步规则
	//QC271260,hr同步新增一个同步rtx字段
	String issynrtx = Util.fromScreen(fu.getParameter("issynrtx"),user.getLanguage());//同步rtx

	String types[] = fu.getParameterValues("type");
	String oafields[] = fu.getParameterValues("oafield");
	String outfields[] = fu.getParameterValues("outfield");
	String iskeyfields[] = fu.getParameterValues("iskeyfield");
	//String isnewfields[] = fu.getParameterValues("isnewfield");
	String isparentfields[] = fu.getParameterValues("isparentfield");
	String issubcomfields[] = fu.getParameterValues("issubcomfield");
	String isdeptfields[] = fu.getParameterValues("isdeptfield");
	String ishrmdeptfields[] = fu.getParameterValues("ishrmdeptfield");
	String ishrmjobfields[] = fu.getParameterValues("ishrmjobfield");
	String transqls[] = fu.getParameterValues("transql");
	String methodtypes[] = fu.getParameterValues("methodtype");
	String paramnames[] = fu.getParameterValues("paramname");
	String paramtypes[] = fu.getParameterValues("paramtype");
	String isarrays[] = fu.getParameterValues("isarray");
	String paramsplits[] = fu.getParameterValues("paramsplit");
	String paramvalues[] = fu.getParameterValues("paramvalue");
	rs.executeSql("delete from hrsyncset");
	String SQL = "INSERT INTO hrsyncset(subcomouternew,deptouternew,jobouternew,hrmouternew,isuselhr,intetype,dbsource,webserviceurl,invoketype,customparams,custominterface,hrmethod,TimeModul,Frequency,frequencyy,createType,createTime,jobtable,depttable,subcomtable,hrmtable,jobmothod,deptmothod,subcommothod,hrmmethod,jobparam,deptparam,subcomparam,hrmparam,defaultPwd,pwdsynctype,issynrtx) "
				+ " values('"+subcomouternew+"','"+deptouternew+"','"+jobouternew+"','"+hrmouternew+"',"+isuselhr+",'"+intetype+"','"+dbsource+"','"+webserviceurl+"','"+invoketype+"','"+customparams+"','"+custominterface+"','"+hrmethod+"',"+TimeModul+","+Frequency+","+frequencyy+",'"+createType+"','"+createTime+"','"+jobtable+"','"+depttable+"','"+subcomtable+"','"+hrmtable+"','"+jobmothod+"','"+deptmothod+"','"+subcommothod+"','"+hrmmethod+"','"+jobparam+"','"+deptparam+"','"+subcomparam+"','"+hrmparam+"','"+defaultPwd+"','"+pwdSyncType+"','"+issynrtx+"')";
	sqlList.add(SQL);
	rs.executeSql(SQL);
	rs.executeSql("delete from hrsyncsetparam");
	if(types!=null){
		for(int i=0;i<types.length;i++){
			String type=types[i];
			String oafield=oafields[i];
			String outfield=outfields[i];
			String iskeyfield=iskeyfields[i];
			//String isnewfield=isnewfields[i];

			//是否为上级字段，部门，分部，人员中需要使用
		    String isparentfield = isparentfields[i];
		    //部门关键字段，部门所属分部
		    String issubcomfield = issubcomfields[i];
		    //岗位关键字段，岗位所属部门
		    String isdeptfield = isdeptfields[i];
		    //人员关键字段
		    String ishrmdeptfield = ishrmdeptfields[i];
		    String ishrmjobfield = ishrmjobfields[i];
		    String transql = transqls[i];
		    
		    //QC295287  [80][90]HR同步-解决导入同步数据字段有转换sql不能导入的问题   ---START
		    String type_exp=types[i].replaceAll("'","''");
			String oafield_exp=oafields[i].replaceAll("'","''");
			String outfield_exp=outfields[i].replaceAll("'","''");
			String iskeyfield_exp=iskeyfields[i].replaceAll("'","''");
			//String isnewfield=isnewfields[i];

			//是否为上级字段，部门，分部，人员中需要使用
		    String isparentfield_exp = isparentfields[i].replaceAll("'","''");
		    //部门关键字段，部门所属分部
		    String issubcomfield_exp = issubcomfields[i].replaceAll("'","''");
		    //岗位关键字段，岗位所属部门
		    String isdeptfield_exp = isdeptfields[i].replaceAll("'","''");
		    //人员关键字段
		    String ishrmdeptfield_exp = ishrmdeptfields[i].replaceAll("'","''");
		    String ishrmjobfield_exp = ishrmjobfields[i].replaceAll("'","''");
		    String transql_exp = transqls[i].replaceAll("'","''");
			if(!oafield.equals("")&&!outfield.equals("")){
				String dsql = "insert into hrsyncsetparam(type,oafield,outfield,iskeyfield,isnewfield,isparentfield,issubcomfield,isdeptfield,ishrmdeptfield,ishrmjobfield,transql) values('"+type_exp+"','"+oafield_exp+"','"+outfield_exp+"','"+iskeyfield_exp+"','','"+isparentfield_exp+"','"+issubcomfield_exp+"','"+isdeptfield_exp+"','"+ishrmdeptfield_exp+"','"+ishrmjobfield_exp+"','"+transql_exp+"')";
				 //QC295287  [80][90]HR同步-解决导入同步数据字段有转换sql不能导入的问题   ---END
				ConnStatement cs = null;
				try{
					cs = new ConnStatement();
				
				String csql = "insert into hrsyncsetparam(type,oafield,outfield,iskeyfield,isnewfield,isparentfield,issubcomfield,isdeptfield,ishrmdeptfield,ishrmjobfield,transql) values(?,?,?,?,'',?,?,?,?,?,?)";
				cs.setStatementSql(csql);
				cs.setString(1,type);
				cs.setString(2,oafield);
				cs.setString(3,outfield);
				cs.setString(4,iskeyfield);
				cs.setString(5,isparentfield);
				cs.setString(6,issubcomfield);
				cs.setString(7,isdeptfield);
				cs.setString(8,ishrmdeptfield);
				cs.setString(9,ishrmjobfield);
				cs.setString(10,transql);
				cs.executeUpdate();
				
				}catch(Exception e){
					log.error(e);
					e.printStackTrace();
				}finally {
					cs.close();
				}

				sqlList.add(dsql);
			}
		}
			//[80][90]HR同步-解决同步字段保存后重复的问题  -----start
			rs.executeSql("delete from hrsyncsetparam where oafield in(select oafield from hrsyncsetparam where type='1' group by oafield having count(1) >= 2) and id not in (select min(id)from hrsyncsetparam where type='1' group by oafield having count(1) >=2) and type='1'");
	
			rs.executeSql("delete from hrsyncsetparam where oafield in(select oafield from hrsyncsetparam where type='2' group by oafield having count(1) >= 2) and id not in (select min(id)from hrsyncsetparam where type='2' group by oafield having count(1) >=2) and type='2'");
	
			rs.executeSql("delete from hrsyncsetparam where oafield in(select oafield from hrsyncsetparam where type='3' group by oafield having count(1) >= 2) and id not in (select min(id)from hrsyncsetparam where type='3' group by oafield having count(1) >=2) and type='3'");
			
			rs.executeSql("delete from hrsyncsetparam where oafield in(select oafield from hrsyncsetparam where type='4' group by oafield having count(1) >= 2) and id not in (select min(id)from hrsyncsetparam where type='4' group by oafield having count(1) >=2) and type='4'");
			
			//[80][90]HR同步-解决同步字段保存后重复的问题  -----end
	}
	rs.executeSql("delete from wsmethodparamvalue where contenttype in(1,2,3,4)");
	if(methodtypes!=null){
		for(int i=0;i<methodtypes.length;i++){
			//QC295304 [80][90]HR同步-Webservice接口方式，同步接口方法参数值中带有英文单引号保存导致参数被清除问题  ---start
			String methodtype=methodtypes[i].replaceAll("'","''");
			String paramname=paramnames[i].replaceAll("'","''");
			String paramtype=paramtypes[i].replaceAll("'","''");
			String isarray=isarrays[i].replaceAll("'","''");
			String paramsplit=paramsplits[i].replaceAll("'","''");
			String paramvalue=paramvalues[i].replaceAll("'","''");
			//QC295304 [80][90]HR同步-Webservice接口方式，同步接口方法参数值中带有英文单引号保存导致参数被清除问题  ---end
			String methodid = "";
			//System.out.println("methodtype : "+methodtype+" paramname : "+paramname);
			if("1".equals(methodtype))
				methodid = subcommothod;
		    else if("2".equals(methodtype))
				methodid = deptmothod;
			else if("3".equals(methodtype))
				methodid = jobmothod;
			else if("4".equals(methodtype))
				methodid = hrmmethod;
			if("".equals(methodid))
				methodid = "0";
			if(!methodid.equals("")&&!methodtype.equals(""))
			{
				String dsql = "insert into wsmethodparamvalue(contenttype,methodid,paramname,paramtype,isarray,paramsplit,paramvalue) "+
							  "values("+methodtype+","+methodid+",'"+paramname+"','"+paramtype+"','"+isarray+"','"+paramsplit+"','"+paramvalue+"')";
				//new BaseBean().writeLog(dsql);
				
				rs.executeSql(dsql);
				sqlList.add(dsql);
			}
		}
	}
}
String filename = "";
if(operation.equals("export"))
{
	String keypath = "";
	try
	{
			StringBuffer sb = new StringBuffer();
			for(int i = 0;i<sqlList.size();i++)
			{
				String sql = Util.null2String((String)sqlList.get(i));
		        sb.append(sql);

		        sb.append("\n");
		        if(rs.getDBType().equals("oracle"))
		        {
		        	sb.append("/");
		        	sb.append("\n");
		        }
		        else
		        {
		        	sb.append("GO");
		        	sb.append("\n");
		        }
	        }
	        try
	        {
				response.setHeader("Location", "hrsetting.sql");
				response.setHeader("content-disposition", "attachment; filename=\"hrsetting.sql\"");
				response.setContentType("text/plain;charset=utf-8");
				response.setCharacterEncoding("UTF-8");
				String sbs=new String(sb.toString().getBytes("utf-8"),"utf-8");
				out.write(sb.toString());
				out.flush();
			}
			catch(Exception e) {
			    log.error(e);
				//do nothing
			}
			finally {
				if(out!=null) out.flush();
				if(out!=null) out.close();
			}
	}
	catch(Exception e)
	{
	    log.error(e);
	}
}
if(operation.equals("import"))
{
	if("1".equals(isDialog))
    {
    %>
    <script language=javascript >
    try
    {
		var parentWin = parent.getParentWindow(window);
		parentWin.location.href="/integration/hrsetting.jsp?isimportsuccess=<%=isimportsuccess%>"
		parentWin.closeDialog();
	}
	catch(e)
	{
	}
	</script>
    <%
    }
    else
		response.sendRedirect("/integration/hrsetting.jsp?isimportsuccess="+isimportsuccess);
}
else if(!operation.equals("import")&&!operation.equals("export"))
{
	response.sendRedirect("/integration/hrsetting.jsp");
}
%>
