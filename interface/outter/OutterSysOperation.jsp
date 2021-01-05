<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.integration.logging.Logger"%>
<%@ page import="weaver.integration.logging.LoggerFactory"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
}

Logger log = LoggerFactory.getLogger();
 FileUpload fu = new FileUpload(request);
 String urllinkimagid = "";
String urlencodeflag = Util.fromScreen(fu.getParameter("urlencodeflag"),user.getLanguage());
 
String operation = Util.fromScreen(fu.getParameter("operation"),user.getLanguage());

String sysid = Util.fromScreen(fu.getParameter("sysid"),user.getLanguage());
String name = Util.fromScreen(fu.getParameter("name"),user.getLanguage());
String iurl = Util.fromScreen(fu.getParameter("iurl"),user.getLanguage());
String ourl = Util.fromScreen(fu.getParameter("ourl"),user.getLanguage());

String backto = Util.null2String(fu.getParameter("backto"));//返回类型
String isDialog = Util.null2String(fu.getParameter("isdialog"));
if(isDialog.equals("")){
	isDialog=Util.null2String(request.getParameter("isdialog"));
}
String typename = Util.fromScreen(fu.getParameter("typename"),user.getLanguage());//单点登录的类型，1：NC
String requesttype = Util.fromScreen(fu.getParameter("requesttype"),user.getLanguage());//请求类型
String accountcode = Util.fromScreen(fu.getParameter("accountcode"),user.getLanguage());//NC账套
String baseparam1 = Util.fromScreen(fu.getParameter("baseparam1"),user.getLanguage());
String urlparaencrypt1 = Util.fromScreen(fu.getParameter("urlparaencrypt1"),user.getLanguage());
String encryptcode1 = Util.fromScreen(fu.getParameter("encryptcode1"),user.getLanguage());
if(!urlparaencrypt1.equals("1"))
	encryptcode1 = "";
String baseparam2 = Util.fromScreen(fu.getParameter("baseparam2"),user.getLanguage());


String urlparaencrypt2 = Util.fromScreen(fu.getParameter("urlparaencrypt2"),user.getLanguage());
String encryptcode2 = Util.fromScreen(fu.getParameter("encryptcode2"),user.getLanguage());
if(!urlparaencrypt2.equals("1"))
	encryptcode2 = "";
String basetype1 = Util.fromScreen(fu.getParameter("basetype1"),user.getLanguage());
String basetype2 = Util.fromScreen(fu.getParameter("basetype2"),user.getLanguage());
String urlparaencrypt = Util.fromScreen(fu.getParameter("urlparaencrypt"),user.getLanguage());
String encryptcode = Util.fromScreen(fu.getParameter("encryptcode"),user.getLanguage());
if(!urlparaencrypt.equals("1"))
	encryptcode = "";
String encrypttype = Util.fromScreen(fu.getParameter("encrypttype"),user.getLanguage());
String encryptclass = Util.fromScreen(fu.getParameter("encryptclass"),user.getLanguage());
String encryptmethod = Util.fromScreen(fu.getParameter("encryptmethod"),user.getLanguage());
String autologin = Util.fromScreen(fu.getParameter("autologinflag"),user.getLanguage());  //内外网自动登录
String encryptclassId = Util.fromScreen(fu.getParameter("encryptclassId"),user.getLanguage());  //自定义加密
String imagewidth = Util.fromScreen(fu.getParameter("imagewidth"),user.getLanguage());  //宽度
String imageheight = Util.fromScreen(fu.getParameter("imageheight"),user.getLanguage());  //高度
String encodeflag = Util.fromScreen(fu.getParameter("encodeflag"),user.getLanguage());  //登录系统编码方式
if(requesttype.equals("")||requesttype==null){
	requesttype="POST";
}

String client_id = Util.fromScreen(fu.getParameter("client_id"),user.getLanguage());
String client_secret = Util.fromScreen(fu.getParameter("client_secret"),user.getLanguage());

//263邮箱参数
String email263_domain = Util.fromScreen(fu.getParameter("email263_domain"),user.getLanguage());
String email263_cid = Util.fromScreen(fu.getParameter("email263_cid"),user.getLanguage());
String email263_key = Util.fromScreen(fu.getParameter("email263_key"),user.getLanguage());


String paramnames[] = fu.getParameterValues("paramnames");
String paramtypes[] = fu.getParameterValues("paramtypes");
String paramvalues[] = fu.getParameterValues("paramvalues");
String labelnames[] = fu.getParameterValues("labelnames");
String paraencrypts[] = fu.getParameterValues("paraencrypts");
String encryptcodes[] = fu.getParameterValues("encryptcodes");
String outternetworks[] = fu.getParameterValues("outternetworks");

String dateStr = "";
String timeStr = "";

if(operation.equals("add")){
	urllinkimagid=Util.null2String(fu.uploadFiles("urllinkimagid"));
	RecordSet.executeSql("select * from outter_sys where sysid='"+sysid+"'");
   	
	if(RecordSet.next()){
         /*QC342902 [80]支持CoreMail集成  start*/             
		 //response.sendRedirect("OutterSysAdd.jsp?isDouble=1&isdialog=1&typename="+typename);
		 response.sendRedirect("OutterSysAdd.jsp?isDouble=1&isdialog=1");
		 return;
		 //response.sendRedirect("OutterSysAdd.jsp?msgid=21011&isdialog=1&typename="+typename);	 
    	//*QC342902 [80]支持CoreMail集成  end*//*
	}
    
    dateStr = TimeUtil.getCurrentDateString();
    timeStr = TimeUtil.getOnlyCurrentTimeString();
    
    RecordSet.executeSql("insert into outter_sys(sysid,name,iurl,ourl,baseparam1,baseparam2,basetype1,basetype2,typename,ncaccountcode,requesttype,urlparaencrypt1,encryptcode1,urlparaencrypt2,encryptcode2,urlparaencrypt,encryptcode,encrypttype,encryptclass,encryptmethod,urlencodeflag,urllinkimagid,autologin,encryptclassId,imagewidth,imageheight,encodeflag,client_id,client_secret"+
    		",email263_domain"+
    		",email263_cid"+
    		",email263_key"+
    		",createdate"+
    		",createtime"+
    		",modifydate"+
    		",modifytime"+
    		") "+
    		"values("+
    		"'"+sysid+"','"+name+"','"+iurl+"','"+ourl+"','"+baseparam1+"','"+baseparam2+"',"+basetype1+","+basetype2+",'"+typename+"','"+accountcode+"','"+requesttype+"','"+urlparaencrypt1+"','"+encryptcode1+"','"+urlparaencrypt2+"','"+encryptcode2+"','"+urlparaencrypt+"','"+encryptcode+"','"+encrypttype+"','"+encryptclass+"','"+encryptmethod+"','"+urlencodeflag+"','"+urllinkimagid+"','"+autologin+"','"+encryptclassId+"','"+imagewidth+"','"+imageheight+"','"+encodeflag+"','"+client_id+"','"+client_secret+
    		"','"+email263_domain+
    		"','"+email263_cid+
    		"','"+email263_key+
    		"','"+dateStr+
    		"','"+timeStr+
    		"','"+dateStr+
    		"','"+timeStr+
    		"')");

	if(paramnames!=null){
		for(int i=0;i<paramnames.length;i++){
			String paramname=paramnames[i];
			String paramvalue=paramvalues[i];
			String paramtype=paramtypes[i];
			String labelname=labelnames[i];
			String tparaencrypt="";
			try
			{
				tparaencrypt=paraencrypts[i];
			}
			catch(Exception e)
			{
			    log.error(e);
			}
			String tencryptcode=encryptcodes[i];
			if(!tparaencrypt.equals("1"))
				tencryptcode = "";
			if(!paramname.equals("")){

				ConnStatement statement = null;
				try{
				statement=new ConnStatement();
				String sql = "";
					sql = "insert into outter_sysparam("+
							"sysid,"+
							"paramname,"+
							"paramvalue,"+
							"labelname,"+
							"paramtype,"+
							"indexid,"+
							"paraencrypt,"+
							"encryptcode"+
							") values("+
							"?,?,?,?,?,?,?,?"+
							")";
					statement.setStatementSql(sql);
					
					statement.setString(1, sysid);
					statement.setString(2, paramname);
					statement.setString(3, paramvalue);
					statement.setString(4, labelname);
					statement.setInt(5,Util.getIntValue(paramtype,0));
					statement.setInt(6,i );
					statement.setString(7, tparaencrypt);
					statement.setString(8, tencryptcode);
					
					
					statement.executeUpdate();
					//RecordSet.executeSql("insert into outter_sysparam(sysid,paramname,paramvalue,labelname,paramtype,indexid,paraencrypt,encryptcode) values('"+sysid+"','"+paramname+"','"+paramvalue+"','"+labelname+"',"+paramtype+","+i+",'"+tparaencrypt+"','"+tencryptcode+"')");
		
			}catch(Exception e){
			    log.error(e);
				
			}finally{
				try{
					statement.close();
				}catch(Exception e){
				    log.error(e);
				}
			}
			
			}
			
		}
	}
	if("1".equals(typename)||"5".equals(typename)) { //如果类型是NC，则新增公司名称
		String paramnames_nc = Util.null2String(fu.getParameter("paramnames_nc"));
		String paramtypes_nc = Util.null2String(fu.getParameter("paramtypes_nc"));
		String labelnames_nc = Util.null2String(fu.getParameter("labelnames_nc"));
		String paraencrypt_nc = Util.null2String(fu.getParameter("paraencrypt_nc"));
		String encryptcode_nc = Util.null2String(fu.getParameter("encryptcode_nc"));
		String paramvalues_nc = Util.null2String(fu.getParameter("paramvalues_nc"));
		
		RecordSet.executeSql("insert into outter_sysparam(sysid,paramname,paramvalue,labelname,paramtype,indexid,paraencrypt,encryptcode) values('"+sysid+"','"+paramnames_nc+"','"+paramvalues_nc+"','"+labelnames_nc+"',"+paramtypes_nc+",0,'"+paraencrypt_nc+"','"+encryptcode_nc+"')");

		//保存共享权限
		RecordSet.executeSql("update  shareoutter set sysid='"+sysid+"' where sysid='-1'");
	}
	//保存网络
	 if(autologin.equals("1")){
	if(outternetworks!=null&&outternetworks.length>0){
		for(int i=0;i<outternetworks.length;i++){
			
			String[] temp=outternetworks[i].split("~");
			String inceptipaddress="";
			String endipaddress="";
			if(temp!=null){
				inceptipaddress=temp[0];
				endipaddress=temp[1];
		      	RecordSet.executeSql("insert into outter_network(inceptipaddress,endipaddress,sysid) values('"+inceptipaddress+"','"+endipaddress+"','"+sysid+"')");
		   }
		}
	}
	}
	//设置默认共享权限为所有人
	String sql="insert into shareoutter (sysid,type,content,seclevel,seclevelmax,sharelevel,jobtitlelevel,jobtitlesharevalue) values  ('"+sysid+"','3','-1','0','100','-1','','')";
	RecordSet.executeSql(sql);
	if("1".equals(isDialog))
    {
    %>
    <script language=javascript >
   
    try
    {
		//var parentWin = parent.getParentWindow(window);
		var parentWin = parent.parent.getParentWindow(parent);
       parentWin.location.href="OutterSys.jsp?backto=<%=backto%>";
		parentWin.closeDialog();
	}
	catch(e)
	{
	}
	</script>
    <%
    }
    else
 		response.sendRedirect("OutterSys.jsp?backto="+backto);
	return;
 }
 
else if(operation.equals("edit")){
	urllinkimagid=Util.null2String(fu.uploadFiles("urllinkimagid"));
	String oldurllinkimagid= Util.null2String(fu.getParameter("oldurllinkimagid"));
	if(urllinkimagid.equals("")) urllinkimagid=oldurllinkimagid ;
	
	dateStr = TimeUtil.getCurrentDateString();
    timeStr = TimeUtil.getOnlyCurrentTimeString();
	
	RecordSet.executeSql("update outter_sys set sysid='"+sysid+"',name='"+name+"',iurl='"+iurl+"',ourl='"+ourl+"',baseparam1='"+baseparam1+"',baseparam2='"+baseparam2+"',basetype1="+basetype1+",basetype2="+basetype2+",ncaccountcode='"+accountcode+"',requesttype='"+requesttype+"',urlparaencrypt1='"+urlparaencrypt1+"',encryptcode1='"+encryptcode1+"',urlparaencrypt2='"+urlparaencrypt2+"',encryptcode2='"+encryptcode2+"',urlparaencrypt='"+urlparaencrypt+"',encryptcode='"+encryptcode+"',encrypttype='"+encrypttype+"',encryptclass='"+encryptclass+"',encryptmethod='"+encryptmethod+"',urlencodeflag='"+urlencodeflag+"',urllinkimagid='"+urllinkimagid+"',autologin='"+autologin+"',encryptclassId='"+encryptclassId+"',imagewidth='"+imagewidth+"',imageheight='"+imageheight+"',encodeflag='"+encodeflag+"',client_id='"+client_id+"',client_secret='"+client_secret+"'"+
			 ",email263_domain='"+email263_domain+"'"+
			 ",email263_cid='"+email263_cid+"'"+
			 ",email263_key='"+email263_key+"'"+
			 ",modifydate='"+dateStr+"'"+
			 ",modifytime='"+timeStr+"'"+
			 " where sysid='"+sysid+"'");
	
	RecordSet.executeSql("delete from outter_sysparam where sysid='"+sysid+"' and paramtype<>1");
    //System.out.println(paraencrypts.length);
    if(paramnames!=null && !"".equals(paramnames)){
    	ArrayList<String> paramnameList = new ArrayList<String>();//页面上获得的用户录入其他参数
    	
		for(int i=0;i<paramnames.length;i++){
			String paramname=paramnames[i];
			String paramvalue=paramvalues[i];
			String paramtype=paramtypes[i];
			String labelname=labelnames[i];
			String tparaencrypt="";		
			
			if("1".equals(paramtype)){ //用户录入的其他参数
				paramnameList.add(Util.null2String(paramname));
				continue;
			}
			
			try
			{
				tparaencrypt=paraencrypts[i];
			}
			catch(Exception e)
			{
			    log.error(e);
			}
			String tencryptcode=encryptcodes[i];
			if(!tparaencrypt.equals("1"))
				tencryptcode = "";
			if(!paramname.equals(""))
			{
				ConnStatement statement = null;
				try{
				statement=new ConnStatement();
				String sql = "";
					sql = "insert into outter_sysparam("+
							"sysid,"+
							"paramname,"+
							"paramvalue,"+
							"labelname,"+
							"paramtype,"+
							"indexid,"+
							"paraencrypt,"+
							"encryptcode"+
							") values("+
							"?,?,?,?,?,?,?,?"+
							")";
					statement.setStatementSql(sql);
					
					statement.setString(1, sysid);
					statement.setString(2, paramname);
					statement.setString(3, paramvalue);
					statement.setString(4, labelname);
					statement.setInt(5,Util.getIntValue(paramtype,0));
					statement.setInt(6,i );
					statement.setString(7, tparaencrypt);
					statement.setString(8, tencryptcode);
					
					
					statement.executeUpdate();
				//RecordSet.executeSql("insert into outter_sysparam(sysid,paramname,paramvalue,labelname,paramtype,indexid,paraencrypt,encryptcode) values('"+sysid+"','"+paramname+"','"+paramvalue+"','"+labelname+"',"+paramtype+","+i+",'"+tparaencrypt+"','"+tencryptcode+"')");
				//System.out.println("insert into outter_sysparam(sysid,paramname,paramvalue,labelname,paramtype,indexid,paraencrypt,encryptcode) values('"+sysid+"','"+paramname+"','"+paramvalue+"','"+labelname+"',"+paramtype+","+i+",'"+tparaencrypt+"','"+tencryptcode+"')");
		
			}catch(Exception e){
			    log.error(e);
				
			}finally{
				try{
					statement.close();
				}catch(Exception e){
				    log.error(e);
				}
			}
			}
		}//end for

		/*用户录入的其他参数单独处理 start*/
		if(paramnameList.size() != 0){
			ArrayList<String> paramname_oldList = new ArrayList<String>(); //数据库中原有的用户录入参数
			RecordSet.executeSql("select * from outter_sysparam where sysid='"+sysid+"' and paramtype=1");
			while(RecordSet.next()){
				log.error("数据库中原有参数："+RecordSet.getString("paramname"));
				paramname_oldList.add(Util.null2String(RecordSet.getString("paramname")));
			}

			String param = null;
			ArrayList<String> paramname_sameList = new ArrayList<String>();//二者相同的用户录入参数
			for(int i=0; i<paramnameList.size(); i++){
				param = Util.null2String(paramnameList.get(i));
				for(String p : paramname_oldList){
					if(p.equals(param)){
						paramname_sameList.add(param);
					}
				}
			}//end for outter

			//页面上的用户录入参数与二者相同的用户录入参数进行对比，一致的不处理，不一致的添加
			Iterator<String> itAdd = paramnameList.iterator();
			while(itAdd.hasNext()){
				param = Util.null2String(itAdd.next());
				if(paramname_sameList.size() == 0){
				    break;
				}else{
					for(String p : paramname_sameList){
						if(p.equals(param)){//将不需要处理的参数从添加列表中删除
							itAdd.remove();
						}
					}
				}
			}
			for (String p : paramnameList){//添加参数
				param = Util.null2String(p);
				for(int j=0;j<paramnames.length;j++){
					String paramname=paramnames[j];
					String paramvalue=paramvalues[j];
					String paramtype=paramtypes[j];
					String labelname=labelnames[j];
					String tparaencrypt="";
					if("1".equals(paramtype) && param.equals(paramname)){ //用户录入的其他参数
						log.error("添加参数:"+param);
						try{
							tparaencrypt=paraencrypts[j];
						}catch(Exception e) {
							log.error(e);
						}
						String tencryptcode=encryptcodes[j];
						if(!tparaencrypt.equals("1"))
							tencryptcode = "";
						if(!paramname.equals("")){
							ConnStatement statement = null;
							try{
								statement=new ConnStatement();
								String sql = "";
								sql = "insert into outter_sysparam("+
										"sysid,"+
										"paramname,"+
										"paramvalue,"+
										"labelname,"+
										"paramtype,"+
										"indexid,"+
										"paraencrypt,"+
										"encryptcode"+
										") values("+
										"?,?,?,?,?,?,?,?"+
										")";
								statement.setStatementSql(sql);

								statement.setString(1, sysid);
								statement.setString(2, paramname);
								statement.setString(3, paramvalue);
								statement.setString(4, labelname);
								statement.setInt(5,Util.getIntValue(paramtype,0));
								statement.setInt(6,j);
								statement.setString(7, tparaencrypt);
								statement.setString(8, tencryptcode);

								statement.executeUpdate();
							}catch(Exception e){
								log.error(e);
							}finally{
								try{
									statement.close();
								}catch(Exception e){
									log.error(e);
								}
							}
						}
					}
				}//end for
			}

			//原有的用户录入参数与二者相同的用户录入参数进行对比，一致的不处理，不一致的删除
			Iterator<String> itdel = paramname_oldList.iterator();
			while(itdel.hasNext()){
				param = Util.null2String(itdel.next());
				if(paramname_sameList.size() == 0){
					break;
				}else{
					for(String p : paramname_sameList){
						if(p.equals(param)){//将不需要处理的参数从添加列表中删除
							itdel.remove();
						}
					}
				}
			}
			for (String p : paramname_oldList){//删除参数
				log.error("删除参数:"+p);
				RecordSet.executeSql("delete from outter_sysparam where sysid='"+sysid+"' and paramtype=1 and paramname='"+p+"'");
				RecordSet.executeSql("delete from outter_params where sysid='"+sysid+"' and paramname='"+p+"'");
			}
		}else{
			log.error("删除所有用户录入参数inner");
			RecordSet.executeSql("delete from outter_sysparam where sysid='"+sysid+"' and paramtype=1");
			RecordSet.executeSql("delete from outter_params where sysid='"+sysid+"'");
		}
	}else{
		log.error("删除所有用户录入参数outter");
		RecordSet.executeSql("delete from outter_sysparam where sysid='"+sysid+"' and paramtype=1");
		RecordSet.executeSql("delete from outter_params where sysid='"+sysid+"'");
	}
	/*用户录入的其他参数单独处理 end*/
    
  //保存网络
    RecordSet.executeSql("delete outter_network where sysid='"+sysid+"'");
  if(autologin.equals("1"))
  {
	if(outternetworks!=null&&outternetworks.length>0){
		for(int i=0;i<outternetworks.length;i++){
			
			String[] temp=outternetworks[i].split("~");
			String inceptipaddress="";
			String endipaddress="";
			if(temp!=null){
				inceptipaddress=temp[0];
				endipaddress=temp[1];
		      	RecordSet.executeSql("insert into outter_network(inceptipaddress,endipaddress,sysid) values('"+inceptipaddress+"','"+endipaddress+"','"+sysid+"')");
		   }
		}
	}
  }
    if("1".equals(isDialog))
    {
    %>
    <script language=javascript >
    try
    {
		//var parentWin = parent.getParentWindow(window);
		var parentWin = parent.parent.parent.getParentWindow(parent);
		parentWin.location.href="OutterSys.jsp?backto=<%=backto%>";
		parentWin.closeDialog();
	}
	catch(e)
	{
	}
	</script>
    <%
    }
    else
 		response.sendRedirect("OutterSys.jsp?backto="+backto);
 }
 else if(operation.equals("delete")){
	List ids = Util.TokenizerString(sysid,",");
	if(null!=ids&&ids.size()>0)
	{
		for(int i = 0;i<ids.size();i++)
		{
			String tempsysid = Util.null2String((String)ids.get(i));
			if(!"".equals(tempsysid))
			{
			    RecordSet.executeSql("delete from outter_sys where sysid='"+tempsysid+"'");
				RecordSet.executeSql("delete from outter_sysparam where sysid='"+tempsysid+"'");
				RecordSet.executeSql("delete from outter_account where sysid='"+tempsysid+"'");
				RecordSet.executeSql("delete from outter_params where sysid='"+tempsysid+"'");

				//删除共享权限
		         RecordSet.executeSql("delete  shareoutter  where sysid="+tempsysid);
		         RecordSet.executeSql("delete outter_network where sysid='"+tempsysid+"'");
			}
		}
	}
	
	if("1".equals(isDialog))
    {
    %>
    <script language=javascript >
    try
    {
		//var parentWin = parent.getParentWindow(window);
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location.href="OutterSys.jsp?backto=<%=backto%>";
		parentWin.closeDialog();
	}
	catch(e)
	{
	}
	</script>
    <%
    }
    else
 		response.sendRedirect("OutterSys.jsp?backto="+backto);
 }
 else if(operation.equalsIgnoreCase("delpic")) {
			urllinkimagid=Util.null2String(fu.uploadFiles("urllinkimagid"));
    	  RecordSet.executeSql("update outter_sys set urllinkimagid=''  where sysid='"+sysid+"'");

    	
		response.sendRedirect("/interface/outter/OutterSysEdit.jsp?id="+sysid);
		
    	return ;
      }
%>