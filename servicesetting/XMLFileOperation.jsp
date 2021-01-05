
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.workflow.action.*"%>
<%@ page import="ln.LN"%>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="weaver.workflow.workflow.TestWorkflowCheck" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.systeminfo.setting.*" %>
<%@ page import="weaver.general.Util,weaver.interfaces.datasource.*"%>
<%@ page import="weaver.servicefiles.ResetXMLFileCache"%>
<%@page import="weaver.interfaces.schedule.*"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="org.quartz.CronExpression"%>


<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="SMSXML" class="weaver.servicefiles.SMSXML" scope="page" />
<jsp:useBean id="ActionXML" class="weaver.servicefiles.ActionXML" scope="page" />
<jsp:useBean id="BrowserXML" class="weaver.servicefiles.BrowserXML" scope="page" />
<jsp:useBean id="ScheduleXML" class="weaver.servicefiles.ScheduleXML" scope="page" />
<jsp:useBean id="BaseAction" class="weaver.workflow.action.BaseAction" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;

if(user == null)  return ;


String operation = Util.null2String(request.getParameter("operation"));
String isdialog = Util.null2String(request.getParameter("isdialog"));
String istest = "";
if(operation.equals("datasource")){
	if(!HrmUserVarify.checkUserRight("intergration:datasourcesetting", user)){
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
    String method = Util.null2String(request.getParameter("method"));
	String from = Util.null2String(request.getParameter("from"));
    int dsnums = Util.getIntValue(Util.null2String(request.getParameter("dsnums")),0);
    if(method.equals("add")){
        Hashtable dataHST = new Hashtable();
        String pointid = Util.null2String(request.getParameter("datasource")).trim();
        if(pointid.equals("")){
            response.sendRedirect("datasourcesetting.jsp");
            return;
        }
        
    	String customid = Util.null2String(request.getParameter("customid"));
    	String typename = Util.null2String(request.getParameter("typename"));
        String dbtype = Util.null2String(request.getParameter("dbtype"));
        String iscluster = Util.null2String(request.getParameter("iscluster"));
        if("".equals(iscluster)) {
        	iscluster = "1";
        }
        String url = Util.null2String(request.getParameter("url"));
        String HostIP = Util.null2String(request.getParameter("HostIP"));
        String Port = Util.null2String(request.getParameter("Port"));
        String DBname = Util.null2String(request.getParameter("DBname"));
        String username = Util.null2String(request.getParameter("user"));
        String password = Util.null2String(request.getParameter("password"));
        String minconn = Util.null2String(request.getParameter("minconn"));
		if(minconn.equals("")) minconn = "5";
        String maxconn = Util.null2String(request.getParameter("maxconn"));
		if(maxconn.equals("")) maxconn = "10";
        String iscode = Util.null2String(request.getParameter("iscode"));
        
        if("1".equals(iscode))
        {
        	username = SecurityHelper.encrypt("ecology",username);
        	password = SecurityHelper.encrypt("ecology",password);
        }
        dataHST.put("type",dbtype);
        dataHST.put("datasourcename",pointid);
        dataHST.put("iscluster",iscluster);
        dataHST.put("url",url);
        dataHST.put("host",HostIP);
        dataHST.put("port",Port);
        dataHST.put("dbname",DBname);
        dataHST.put("user",username);
        dataHST.put("password",password);
        dataHST.put("minconn",minconn);
        dataHST.put("maxconn",maxconn);
        dataHST.put("iscode",iscode);
        dataHST.put("typename",typename);
        dataHST.put("customid",customid);
        
        DataSourceXML.writeToDataSourceXMLAdd(pointid,dataHST);
        if(!typename.equals(""))
        {
        	ResetXMLFileCache.resetCache();
	    	response.sendRedirect("/servicesetting/datasourcesettingnew.jsp?typename="+typename);
	    	return;
        }
    }else if(method.equals("edit")){
        ArrayList dspointids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        for(int i=0;i<dsnums;i++){
            Hashtable dataHST = new Hashtable();
            String pointid = Util.null2String(request.getParameter("datasource_"+i)).trim();
            String oldpointid = Util.null2String(request.getParameter("olddatasource_"+i));
            if(pointid.equals("")) continue;
    		
    		String typename = Util.null2String(request.getParameter("typename_"+i));
            String dbtype = Util.null2String(request.getParameter("dbtype_"+i));
            String iscluster = Util.null2String(request.getParameter("iscluster_"+i));
            if("".equals(iscluster)) {
            	iscluster = "1";
            }
            String url = Util.null2String(request.getParameter("url_"+i));
            String HostIP = Util.null2String(request.getParameter("HostIP_"+i));
            String Port = Util.null2String(request.getParameter("Port_"+i));
            String DBname = Util.null2String(request.getParameter("DBname_"+i));
            String username = Util.null2String(request.getParameter("user_"+i));
            String password = Util.null2String(request.getParameter("password_"+i));
            String minconn = Util.null2String(request.getParameter("minconn_"+i));
			if(minconn.equals("")) minconn = "5";
            String maxconn = Util.null2String(request.getParameter("maxconn_"+i));
			if(maxconn.equals("")) maxconn = "10";
            String iscode = Util.null2String(request.getParameter("iscode_"+i));
            
            if("1".equals(iscode))
	        {
	        	username = SecurityHelper.encrypt(SecurityHelper.KEY,username);
	        	password = SecurityHelper.encrypt(SecurityHelper.KEY,password);
	        }
        
            dataHST.put("type",dbtype);
            dataHST.put("datasourcename",pointid);
            dataHST.put("iscluster",iscluster);
        	dataHST.put("url",url);
            dataHST.put("host",HostIP);
            dataHST.put("port",Port);
            dataHST.put("dbname",DBname);
            dataHST.put("user",username);
            dataHST.put("password",password);
            dataHST.put("minconn",minconn);
            dataHST.put("maxconn",maxconn);
            dataHST.put("iscode",iscode);
            dataHST.put("typename",typename);
            
            dspointids.add(pointid);
            dataHSTArr.add(dataHST);
        }
        DataSourceXML.writeToDataSourceXMLEdit(dspointids,dataHSTArr);
        for(int i=0;i<dsnums;i++){
            String pointid = Util.null2String(request.getParameter("datasource_"+i)).trim();
            String oldpointid = Util.null2String(request.getParameter("olddatasource_"+i));
            if(pointid.equals("")||oldpointid.equals("")) continue;
            if(pointid.compareTo(oldpointid)!=0)
            {
            	DataSourceXML.updateDataSourceUsed(oldpointid,pointid);
            }
        }
    }else if(method.equals("delete")){
        for(int i=0;i<dsnums;i++){
            String isdel = Util.null2String(request.getParameter("del_"+i));
            if(isdel.equals("1")) {
                String pointid = Util.null2String(request.getParameter("datasource_"+i)).trim();
                if(pointid.equals("")) continue;
                rs1.execute("delete from datasourcesetting where pointid='"+pointid+"'");
            }
        }
    }
    else if(method.equals("test"))
    {
    	String dbtype = Util.null2String(request.getParameter("dbtype"));
        String iscluster = Util.null2String(request.getParameter("iscluster"));
        String url = Util.null2String(request.getParameter("url"));
        String HostIP = Util.null2String(request.getParameter("HostIP"));
        String Port = Util.null2String(request.getParameter("Port"));
        String DBname = Util.null2String(request.getParameter("DBname"));
        String username = Util.null2String(request.getParameter("user"));
        String password = Util.null2String(request.getParameter("password"));
        String minconn = Util.null2String(request.getParameter("minconn"));
		if(minconn.equals("")) minconn = "5";
        String maxconn = Util.null2String(request.getParameter("maxconn"));
		if(maxconn.equals("")) maxconn = "10";
        
		
		

        if("2".equals(iscluster)){
        	
        	String errormsg="";
        	if(dbtype.toLowerCase().contains("mysql")){
           		 if(!url.toLowerCase().contains("mysql")){
           				 errormsg="7";
           		    	 out.print(errormsg);
         			return;
           		 }

        		 }if(dbtype.toLowerCase().contains("oracle")){
           		 if(!url.toLowerCase().contains("oracle")){
           				 errormsg="7";
           				 out.print(errormsg);
         			return;
           		 }

        		 }
        		 if(dbtype.toLowerCase().contains("sqlserver")){
           		 if(!url.toLowerCase().contains("sqlserver")){
           				 errormsg="7";
           				 out.print(errormsg);
           		    	// System.out.println(errormsg);
        			return;
           		 }

        		 }
        }
        	
		
		
        BaseDataSource BaseDataSource = new BaseDataSource();
        BaseDataSource.setType(dbtype);
        BaseDataSource.setUrl(url);
        BaseDataSource.setHost(HostIP);
        BaseDataSource.setPort(Port);
        BaseDataSource.setDbname(DBname);
        
        BaseDataSource.setUser(username);
        BaseDataSource.setPassword(password);
        BaseDataSource.setIscluster(iscluster);
        //System.out.println("dbtype : "+dbtype+" url : "+url+" HostIP : "+HostIP+" Port : "+Port+" DBname : "+DBname);
        istest = ""+BaseDataSource.testDataSource();
    }
	else if(method.equals("getDataSourceUsed")){//获取数据源已被使用情况
		String pointid = Util.null2String(request.getParameter("pointid"));
		//System.out.println("operation="+operation+", method="+method);
		String datasourceused = Util.null2String(DataSourceXML.getDataSourceUsed(pointid,user)).trim();
		datasourceused = "{\"datasourceused\":\""+datasourceused+"\"}";
		out.print(datasourceused);
		//System.out.println("datasourceused: "+datasourceused);
		return;
	}
	
    if(method.equals("test"))
    {
    	out.print(istest);
    }
    else
    {
	    ResetXMLFileCache.resetCache();
	    if("1".equals(isdialog))
	    {
	    %>
	    <script language=javascript >
	    try
	    {
			//var parentWin = parent.getParentWindow(window);
			var parentWin = parent.parent.getParentWindow(parent);
			if("sms"=="<%=from%>"){
				parentWin.closeRefDialog();
			}else{
				parentWin.location.href="/servicesetting/datasourcesetting.jsp";
				parentWin.closeDialog();
			}
		}
		catch(e)
		{
		}
		</script>
	    <%
	    }
	    else
	    	response.sendRedirect("datasourcesetting.jsp");
    }
}else if(operation.equals("sms")){
    String interfacetype = Util.null2String(request.getParameter("interfacetype"));
    String constructclass = Util.null2String(request.getParameter("constructclass"));
    ArrayList propertyArr = new ArrayList();
    ArrayList valueArr = new ArrayList();
    if(interfacetype.equals("1")){//通用短信接口
        constructclass = "weaver.sms.JdbcSmsService";
        String type = Util.null2String(request.getParameter("type"));
        String host = Util.null2String(request.getParameter("host"));
        String port = Util.null2String(request.getParameter("port"));
        String dbname = Util.null2String(request.getParameter("dbname"));
        String username = Util.null2String(request.getParameter("username"));
        String password = Util.null2String(request.getParameter("password"));
        String sql = Util.null2String(request.getParameter("sql"));
        propertyArr.add("type");
        propertyArr.add("host");
        propertyArr.add("port");
        propertyArr.add("dbname");
        propertyArr.add("username");
        propertyArr.add("password");
        propertyArr.add("sql");
        
        valueArr.add(type);
        valueArr.add(host);
        valueArr.add(port);
        valueArr.add(dbname);
        valueArr.add(username);
        valueArr.add(password);
        valueArr.add(sql);
        
    }else{//自定义短信接口
        int propertynum = Util.getIntValue(Util.null2String(request.getParameter("propertynum")),0);
        for(int i=1;i<=propertynum;i++){
            String propertyS = Util.null2String(request.getParameter("property_"+i));
            if(propertyS.equals("")) continue;
            String valueS = Util.null2String(request.getParameter("value_"+i));
            propertyArr.add(propertyS);
            valueArr.add(valueS);
        }
    }
    
   	SMSXML.writeToSMSXML(constructclass,propertyArr,valueArr);
    
    ResetXMLFileCache.resetCache();
    
    response.sendRedirect("smssetting.jsp");
}else if(operation.equals("action")){
	if(!HrmUserVarify.checkUserRight("intergration:formactionsetting", user)){
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
	String errormsg = "";
    String method = Util.null2String(request.getParameter("method"));
    if(method.equals("add")){
        String actionid = Util.null2String(request.getParameter("actionid"));
        String oldactionid = Util.null2String(request.getParameter("oldactionid"));
        if(actionid.equals("")){
            response.sendRedirect("/integration/formactionlist.jsp");
            return;
        }
        String id = Util.null2String(request.getParameter("id"));
        String classname = Util.null2String(request.getParameter("classname"));
        String actionname = Util.null2String(request.getParameter("actionname"));
        String[] fieldnames = request.getParameterValues("fieldname");
        String[] fieldvalues = request.getParameterValues("fieldvalue");
        String[] isdatasources = request.getParameterValues("isdatasource");
        //QC274140 start [80][90]流程流转集成-自定义接口弹出窗口按Backspace会重复插入一条数据
        int reallyid = Util.getIntValue(id,0);
        String Chinese_PRC_CS_AS_WS = " ";
        if(RecordSet.getDBType().toLowerCase().indexOf("sqlserver") > -1) {
            Chinese_PRC_CS_AS_WS = " collate Chinese_PRC_CS_AS_WS ";
        }
        String sql = "select 1 from actionsetting where actionname " + Chinese_PRC_CS_AS_WS + " = '" + actionid + "' ";
        if(reallyid > 0) {
            sql += " and id <> " + reallyid;
        }
        RecordSet.executeSql(sql);
        if(RecordSet.getCounts() > 0) {
            if("1".equals(isdialog)) {
    %>
            <script language=javascript >
                try {
                    var parentWin = parent.parent.getParentWindow(parent);
                    parentWin.location.href = "/integration/formactionlist.jsp";
                    var dialog = parent.parent.getDialog(parent);
                    dialog.close();
                } catch(e) {
                    
                }
            </script>
    <%
            }
            return;
        }
     //QC274140 end [80][90]流程流转集成-自定义接口弹出窗口按Backspace会重复插入一条数据


        //System.out.println("actionid : "+actionid+"  classname : "+classname+" fieldnames : "+fieldnames+"  fieldvalues : "+fieldvalues);
        ActionXML.writeToActionXMLAdd(oldactionid,actionname,actionid,classname,fieldnames,fieldvalues,isdatasources);
        id = ActionXML.updateAction(actionname,id,actionid,classname,fieldnames,fieldvalues);
        ResetXMLFileCache.resetCache();
        String workflowid = Util.null2String(request.getParameter("workflowid"));
        String nodeid = Util.null2String(request.getParameter("nodeid"));
        String nodelinkid = Util.null2String(request.getParameter("nodelinkid"));
        String ispreoperator = Util.null2String(request.getParameter("ispreoperator"));
        if(!"".equals(workflowid))
        {
	        WorkflowActionManager workflowActionManager = new WorkflowActionManager();
	        workflowActionManager.setActionid(0);
			workflowActionManager.setWorkflowid(Util.getIntValue(workflowid));
			workflowActionManager.setNodeid(Util.getIntValue(nodeid));
			workflowActionManager.setActionorder(0);
			workflowActionManager.setNodelinkid(Util.getIntValue(nodelinkid));
			workflowActionManager.setIspreoperator(Util.getIntValue(ispreoperator));
			workflowActionManager.setActionname(actionname);
			workflowActionManager.setInterfaceid(actionname);
			workflowActionManager.setInterfacetype(3);
			workflowActionManager.setIsused(1);
			workflowActionManager.doSaveWsAction();
		
        }
    	if("1".equals(isdialog))
	    {
			//System.out.println("isdialog : "+isdialog);
	    %>
	    <script language=javascript >
	    try
	    {
			var parentWin = parent.parent.getParentWindow(parent);
			parentWin.doRefresh();
			setTimeout(top.Dialog.close,2);
		}
		catch(e)
		{
		}
		  try
		    {
				var parentWin = parent.parent.getParentWindow(parent);
				parentWin.closeDialogAction();
				parentWin.reloadDMLAtion();
			}
			catch(e)
			{}
		</script>
	    <%
	    }else{
        response.sendRedirect("/servicesetting/actionsettingnew.jsp?urlType=24&isdialog="+isdialog+"&typename=&backto=&fromintegration=1&actionid="+id);
	    }
	    return;
    }else if(method.equals("edit")){
        int atnums = Util.getIntValue(Util.null2String(request.getParameter("atnums")),0);
        ArrayList actionids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        ArrayList datafieldArr = new ArrayList();
        ArrayList datavalueArr = new ArrayList();
        for(int i=0;i<atnums;i++){
            String actionid = Util.null2String(request.getParameter("actionid_"+i));
            if(actionid.equals("")) continue;
            String classname = Util.null2String(request.getParameter("classname_"+i));
            String[] fieldnames = request.getParameterValues("fieldname_"+i);
            String[] fieldvalues = request.getParameterValues("fieldvalue_"+i);
            Hashtable dataHST = new Hashtable();
            dataHST.put("classname",classname);
            
            actionids.add(actionid);
            dataHSTArr.add(dataHST);
            datafieldArr.add(fieldnames);
            datavalueArr.add(fieldvalues);
        }
        ActionXML.writeToActionXMLEdit(actionids,dataHSTArr,datafieldArr,datavalueArr);
		ResetXMLFileCache.resetCache();
		
		if("1".equals(isdialog))
		{
		%>
		<script language=javascript >
		try
		{
			var parentWin = parent.parent.getParentWindow(parent);
			parentWin.location.href="/integration/formactionlist.jsp";
			parentWin.closeDialog();
		}
		catch(e)
		{
		}
		</script>
		<%
		}
		return;
    }else if(method.equals("delete")){
        int atnums = Util.getIntValue(Util.null2String(request.getParameter("atnums")),0);
        ArrayList actionids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        ArrayList datafieldArr = new ArrayList();
        ArrayList datavalueArr = new ArrayList();
        for(int i=0;i<atnums;i++){
            String isdel = Util.null2String(request.getParameter("del_"+i));
            if(isdel.equals("1")) continue;
            String actionid = Util.null2String(request.getParameter("actionid_"+i));
            if(actionid.equals("")) continue;
            
            actionids.add(actionid);
        }
        ActionXML.writeToActionXMLEdit(actionids);
		ResetXMLFileCache.resetCache();
    }
    else if(method.equals("deletesingle")){
    	String id = Util.null2String(request.getParameter("actionid"));
    	if(Util.getIntValue(id,0)>0)
    	{
    		String pointid = "";
    		String sql = "select * from actionsetting where id="+id;
    		rs1.executeSql(sql);
    		if(rs1.next())
    		{
    			pointid = rs1.getString("actionname");
    		}
    		if(!"".equals(pointid))
    		{
    			boolean isused = BaseAction.checkFromActionUsed(""+pointid,"3");
        		if(!isused)
        		{
	    			rs1.executeSql("delete from actionsetting where id="+id);
					rs1.executeSql("delete from actionsettingdetail where actionid="+id);
		    		//ActionXML.writeToActionXMLDelete(pointid);/*QC331430 [80][90][缺陷]流程流转集成-解决删除自定义接口时有对action.xml进行操作的问题*/
					ResetXMLFileCache.resetCache();
        		}
        		else
        		{
        			errormsg = "1";
        		}
    		}
    	}
        response.sendRedirect("/integration/formactionlist.jsp");
        return;
    }
    else if(method.equals("deletesingle1")){
    	String actionid = Util.null2String(request.getParameter("actionid"));
    	if(!"".equals(actionid))
    	{
    		boolean isused = BaseAction.checkFromActionUsed(""+actionid,"3");
    		if(!isused)
    		{
	    		String id = "";
	    		String sql = "select * from actionsetting where actionname='"+actionid+"'";
	    		rs1.executeSql(sql);
	    		if(rs1.next())
	    		{
	    			id = rs1.getString("id");
	    		}
	    		if(!"".equals(id))
	    		{
	    			rs1.executeSql("delete from actionsetting where id="+id);
	    			rs1.executeSql("delete from actionsettingdetail where actionid="+id);
		    		//ActionXML.writeToActionXMLDelete(actionid);/*QC331430 [80][90][缺陷]流程流转集成-解决删除自定义接口时有对action.xml进行操作的问题*/
					ResetXMLFileCache.resetCache();
	    		}
    		}
    		else
    		{
    			errormsg = "1";
    		}
    	}
        
    }
    out.println("<script language=javascript>var parentWin = parent.parent.getParentWindow(parent);parentWin.doRefresh();setTimeout(top.Dialog.close,2);</script>");
}else if(operation.equals("browser")){
	if(!HrmUserVarify.checkUserRight("intergration:datashowsetting", user)){
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
    String method = Util.null2String(request.getParameter("method"));
    if(method.equals("add")){
        String browserid = Util.null2String(request.getParameter("browserid"));
        String oldbrowserid = Util.null2String(request.getParameter("oldbrowserid"));
        String customid = Util.null2String(request.getParameter("customid"));//表单建模中对应浏览框id
        
        String name = Util.null2String(request.getParameter("name"));
        String typename = Util.null2String(request.getParameter("typename"));
        if(browserid.equals("") || "".equals(name)){
            response.sendRedirect("browsersetting.jsp");
            return;
        }
        String ds = "datasource."+Util.null2String(request.getParameter("ds"));
        if("".equals(Util.null2String(request.getParameter("ds"))))
        {
        	ds = "";
        }
        String search = Util.null2String(request.getParameter("search"));
        String searchById = Util.null2String(request.getParameter("searchById"));
        String searchByName = Util.null2String(request.getParameter("searchByName"));
        String nameHeader = Util.null2String(request.getParameter("nameHeader"));
        String descriptionHeader = Util.null2String(request.getParameter("descriptionHeader"));
        String outPageURL = Util.null2String(request.getParameter("outPageURL"));
        String from = Util.null2String(request.getParameter("from"));
        String href = Util.null2String(request.getParameter("href"));
        String showtree = Util.null2String(request.getParameter("showtree"));
        String nodename = Util.null2String(request.getParameter("nodename"));
        String parentid = Util.null2String(request.getParameter("parentid"));
        String ismutil = Util.null2String(request.getParameter("ismutil"));
        
        Hashtable dataHST = new Hashtable();
        dataHST.put("ds",ds);
        dataHST.put("search",search);
        dataHST.put("searchById",searchById);
        dataHST.put("searchByName",searchByName);
        dataHST.put("nameHeader",nameHeader);
        dataHST.put("descriptionHeader",descriptionHeader);
        dataHST.put("outPageURL",outPageURL);
        dataHST.put("from",from);
        dataHST.put("href",href);
        dataHST.put("showtree",showtree);
        dataHST.put("nodename",nodename);
        dataHST.put("parentid",parentid);
        dataHST.put("ismutil",ismutil);
        dataHST.put("name",name);
        dataHST.put("customid",customid);
        
        BrowserXML.writeToBrowserXMLAdd(browserid,dataHST);
       	ResetXMLFileCache.resetCache();
       	
       	BrowserXML.updateData(browserid);
       	boolean isused = BrowserXML.isUsed(oldbrowserid,"1","1");
        if(isused)
        {
        	BrowserXML.updateUseField(""+oldbrowserid,"1","1",browserid,"1","1");
        }
    	
		if("1".equals(isdialog))
		{
		%>
		<script language=javascript >
		try
		{
			var parentWin = parent.parent.getParentWindow(parent);
			parentWin.location.href="/integration/WsShowEditSetList.jsp?typename=<%=typename%>";
			parentWin.closeDialog();
		}
		catch(e)
		{
			console.error(e);
		}
		</script>
		<%
		}else{
			response.sendRedirect("/integration/WsShowEditSetList.jsp?typename="+typename);
		}
    	return;
    }else if(method.equals("edit")){
		String typename = Util.null2String(request.getParameter("typename"));
        int bsnums = Util.getIntValue(Util.null2String(request.getParameter("bsnums")),0);
        ArrayList browserids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        for(int i=0;i<bsnums;i++){
            String browserid = Util.null2String(request.getParameter("browserid_"+i));
            if(browserid.equals("")) continue;
            String ds = "datasource."+Util.null2String(request.getParameter("ds_"+i));
	        if("".equals(Util.null2String(request.getParameter("ds_"+i))))
	        {
	        	ds = "";
	        }
            String search = Util.null2String(request.getParameter("search_"+i));
            String searchById = Util.null2String(request.getParameter("searchById_"+i));
            String searchByName = Util.null2String(request.getParameter("searchByName_"+i));
            String nameHeader = Util.null2String(request.getParameter("nameHeader_"+i));
            String descriptionHeader = Util.null2String(request.getParameter("descriptionHeader_"+i));
            String outPageURL = Util.null2String(request.getParameter("outPageURL_"+i));
            String from = Util.null2String(request.getParameter("from_"+i));
            String href = Util.null2String(request.getParameter("href_"+i));
            
            String showtree = Util.null2String(request.getParameter("showtree_"+i));
            String nodename = Util.null2String(request.getParameter("nodename_"+i));
            String parentid = Util.null2String(request.getParameter("parentid_"+i));
            String ismutil = Util.null2String(request.getParameter("ismutil_"+i));
    
            Hashtable dataHST = new Hashtable();
            dataHST.put("ds",ds);
            dataHST.put("search",search);
            dataHST.put("searchById",searchById);
            dataHST.put("searchByName",searchByName);
            dataHST.put("nameHeader",nameHeader);
            dataHST.put("descriptionHeader",descriptionHeader);
            dataHST.put("outPageURL",outPageURL);
            dataHST.put("from",from);
            dataHST.put("href",href);
            dataHST.put("showtree",showtree);
        	dataHST.put("nodename",nodename);
        	dataHST.put("parentid",parentid);
        	dataHST.put("ismutil",ismutil);
            
            browserids.add(browserid);
            dataHSTArr.add(dataHST);
            
        }
        BrowserXML.writeToBrowserXMLEdit(browserids,dataHSTArr);
		if("1".equals(isdialog))
		{
		%>
		<script language=javascript >
		try
		{
			var parentWin = parent.parent.getParentWindow(parent);
			parentWin.location.href="/integration/WsShowEditSetList.jsp?typename=<%=typename%>";
			parentWin.closeDialog();
		}
		catch(e)
		{
			console.error(e);
		}
		</script>
		<%
		}else{
			response.sendRedirect("/integration/WsShowEditSetList.jsp?typename="+typename);
		}
    	return;
    }else if(method.equals("delete")){
        int bsnums = Util.getIntValue(Util.null2String(request.getParameter("bsnums")),0);
        ArrayList browserids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        for(int i=0;i<bsnums;i++){
            String isdel = Util.null2String(request.getParameter("del_"+i));
            if(isdel.equals("1")) continue;
            String browserid = Util.null2String(request.getParameter("browserid_"+i));
            if(browserid.equals("")) continue;
            String ds = "datasource."+Util.null2String(request.getParameter("ds_"+i));
            if("".equals(Util.null2String(request.getParameter("ds_"+i))))
	        {
	        	ds = "";
	        }
            String search = Util.null2String(request.getParameter("search_"+i));
            String searchById = Util.null2String(request.getParameter("searchById_"+i));
            String searchByName = Util.null2String(request.getParameter("searchByName_"+i));
            String nameHeader = Util.null2String(request.getParameter("nameHeader_"+i));
            String descriptionHeader = Util.null2String(request.getParameter("descriptionHeader_"+i));
            String outPageURL = Util.null2String(request.getParameter("outPageURL_"+i));
            String from = Util.null2String(request.getParameter("from_"+i));
            String href = Util.null2String(request.getParameter("href_"+i));
            String showtree = Util.null2String(request.getParameter("showtree_"+i));
            String nodename = Util.null2String(request.getParameter("nodename_"+i));
            String parentid = Util.null2String(request.getParameter("parentid_"+i));
            String ismutil = Util.null2String(request.getParameter("ismutil_"+i));
    
            Hashtable dataHST = new Hashtable();
            dataHST.put("ds",ds);
            dataHST.put("search",search);
            dataHST.put("searchById",searchById);
            dataHST.put("searchByName",searchByName);
            dataHST.put("nameHeader",nameHeader);
            dataHST.put("descriptionHeader",descriptionHeader);
            dataHST.put("outPageURL",outPageURL);
            dataHST.put("from",from);
            dataHST.put("href",href);
            dataHST.put("showtree",showtree);
        	dataHST.put("nodename",nodename);
        	dataHST.put("parentid",parentid);
        	dataHST.put("ismutil",ismutil);
            
            browserids.add(browserid);
            dataHSTArr.add(dataHST);
        }
        BrowserXML.writeToBrowserXMLEdit(browserids,dataHSTArr);
    }
    else if(method.equals("deletesingle"))
    {
    	String typename = Util.null2String(request.getParameter("typename"));
    	String browserid = Util.null2String(request.getParameter("browserid"));
    	String SQL = "delete from datashowset where showname='"+browserid+"'";
		rs1.executeSql(SQL);
    	BrowserXML.writeToBrowserXMLDel(browserid);
    	ResetXMLFileCache.resetCache();
    	
		if("1".equals(isdialog))
		{
		%>
		<script language=javascript >
		try
		{
			var parentWin = parent.parent.getParentWindow(parent);
			parentWin.location.href="/integration/WsShowEditSetList.jsp?typename=<%=typename%>";
			parentWin.closeDialog();
		}
		catch(e)
		{
			console.error(e);
		}
		</script>
		<%
		}else{
			response.sendRedirect("/integration/WsShowEditSetList.jsp?typename="+typename);
		}
    	return;
    }
    response.sendRedirect("browsersetting.jsp");
}else if(operation.equals("schedule")){
	if(!HrmUserVarify.checkUserRight("intergration:schedulesetting", user)){
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
    String method = Util.null2String(request.getParameter("method"));
    String scheduleStaticKey = "schedule.";
    if(method.equals("add")){
        String scheduleid = Util.null2String(request.getParameter("scheduleid")).trim();
        if(scheduleid.equals("")){
            response.sendRedirect("schedulesetting.jsp");
            return;
        }
        String ClassName = Util.null2String(request.getParameter("ClassName"));
        String CronExpr = Util.null2String(request.getParameter("CronExpr"));
        Hashtable dataHST = new Hashtable();
        dataHST.put("construct",ClassName);
        dataHST.put("cronExpr",CronExpr);
        
        ScheduleXML.writeToScheduleXMLAdd(scheduleid,dataHST);
        ScheduleManage.addJob(scheduleStaticKey+scheduleid,CronExpr);//触发新增的计划任务
    }else if(method.equals("edit")){
        int sdnums = Util.getIntValue(Util.null2String(request.getParameter("sdnums")),0);
        ArrayList scheduleids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        for(int i=0;i<sdnums;i++){
            String scheduleid = Util.null2String(request.getParameter("scheduleid_"+i)).trim();
            if(scheduleid.equals("")) continue;
            String ClassName = Util.null2String(request.getParameter("ClassName_"+i));
            String CronExpr = Util.null2String(request.getParameter("CronExpr_"+i));
            Hashtable dataHST = new Hashtable();
            dataHST.put("construct",ClassName);
            dataHST.put("cronExpr",CronExpr);
            
            scheduleids.add(scheduleid);
            dataHSTArr.add(dataHST);
            
	    	CronJob job = (CronJob) StaticObj.getServiceByFullname(scheduleStaticKey+scheduleid, CronJob.class);
	    	//1:修改了计划任务标识
	    	if(null == job){
	    		ScheduleManage.addJob(scheduleStaticKey+scheduleid,CronExpr);//执行触发新标识名称的计划任务
	    	}
	    	//2:只修改了触发时间
	    	else if(!CronExpr.equals(job.getCronExpr())){
	    		ScheduleManage.modifyJobTime(scheduleStaticKey+scheduleid,CronExpr);//执行更新计划任务触发时间
	    	}
        }
        ScheduleXML.writeToScheduleXMLEdit(scheduleids,dataHSTArr);
        
        
        	//3:删除弃用计划任务标示的对应的计划任务
        	List l = StaticObj.getServiceIds(CronJob.class);
			for (int i = 0; i < l.size(); i++) {
				String schedulename = ((String) l.get(i)).replace(scheduleStaticKey,"");//老的缓存的计划任务标示名称
				if(!scheduleids.contains(schedulename)){
					ScheduleManage.removeJob(scheduleStaticKey+schedulename);//执行移除执行的计划任务
				}
			}
        
    }else if(method.equals("delete")){
        int sdnums = Util.getIntValue(Util.null2String(request.getParameter("sdnums")),0);
        ArrayList scheduleids = new ArrayList();
        //ArrayList dataHSTArr = new ArrayList();
        
        for(int i=0;i<sdnums;i++){
            String isdel = Util.null2String(request.getParameter("del_"+i));
            if(isdel.equals("1")) {
                String scheduleid = Util.null2String(request.getParameter("scheduleid_"+i)).trim();
                scheduleids.add(scheduleid);
	            ScheduleManage.removeJob(scheduleStaticKey+scheduleid);//执行移除执行的计划任务
            }
            /*
            String scheduleid = Util.null2String(request.getParameter("scheduleid_"+i));
            if(scheduleid.equals("")) continue;
            String ClassName = Util.null2String(request.getParameter("ClassName_"+i));
            String CronExpr = Util.null2String(request.getParameter("CronExpr_"+i));
            Hashtable dataHST = new Hashtable();
            dataHST.put("construct",ClassName);
            dataHST.put("cronExpr",CronExpr);
            
            scheduleids.add(scheduleid);
            dataHSTArr.add(dataHST);*/
        }
        ScheduleXML.deleteSchedule(scheduleids);
    }
    else if(method.equals("checkSchedule")){
    	String[] clasz = request.getParameterValues("clasz[]");
    	String[] cron = request.getParameterValues("cron[]");
    	
    	
    	StringBuffer msg = new StringBuffer();
    	Map map = new HashMap();
    	map.put("ok",true);
    	
    	String di =	SystemEnv.getHtmlLabelName(15323,user.getLanguage());
    	String hang =	SystemEnv.getHtmlLabelName(27592,user.getLanguage());
    	String fei =	SystemEnv.getHtmlLabelName(33614,user.getLanguage());
    	String lei =	SystemEnv.getHtmlLabelName(33615,user.getLanguage());
    	String shili =	SystemEnv.getHtmlLabelName(33617,user.getLanguage());
    	String crons =	SystemEnv.getHtmlLabelName(33613,user.getLanguage());
    	
    	
    	for (int i=0;i<clasz.length;i++){
    		String h = clasz.length==1?"":di+(i+1)+hang;
    		
    		try{
    			Class claz = Class.forName(clasz[i]);
        		Object object = claz.newInstance();
        		if(!((object instanceof BaseCronJob) || (object instanceof CronJob))){
        			map.put("ok",false);
        			msg.append(h);
        			msg.append(fei);
        			msg.append(BaseCronJob.class.getName());
        			msg.append(lei.substring(0, lei.length()-1));
        			msg.append("；也未实现weaver.interfaces.schedule.CronJob接口");
        			msg.append("\n");
        		}
    		}catch(Throwable e){
    			map.put("ok",false);
    			msg.append(h);
    			msg.append(shili);
    			msg.append("\n");
    		}
    		
    	  boolean falg = CronExpression.isValidExpression(cron[i]);
    	  if(!falg){
    		map.put("ok",false);
    		msg.append(h);
    		msg.append(crons);
  			msg.append("\n");
    	  }
    	  
    	}
    	map.put("msg",msg.toString());
       
    //	out.clear();
    //	out.write(JSONObject.fromObject(map).toString());
    //	out.close();   	
  	  out.print(JSONObject.fromObject(map).toString());
    	return ;
    }
    ResetXMLFileCache.resetCache();
    if("1".equals(isdialog))
    {
    %>
    <script language=javascript >
    try
    {
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location.href="/servicesetting/schedulesetting.jsp";
		parentWin.closeDialog();
	}
	catch(e)
	{
	}
	</script>
    <%
    }
    else
    	response.sendRedirect("schedulesetting.jsp");
}
%>