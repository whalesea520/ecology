<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@page import="org.json.JSONObject"%> 
<%@page import="org.json.JSONArray"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="requestutil" class="weaver.workflow.request.todo.RequestUtil" scope="page" />
<jsp:useBean id="SystemEnv" class="weaver.systeminfo.SystemEnv" scope="page"/>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	Enumeration em = request.getParameterNames();
	boolean isinit = true;
	while(em.hasMoreElements())
	{
		String paramName = (String)em.nextElement();
		if(!paramName.equals(""))
			isinit = false;
		break;
	}
	String loadtree = Util.null2String(request.getParameter("loadtree"));
	int date2during = Util.getIntValue(request.getParameter("date2during"),0);
    String resourceid= Util.null2String(request.getParameter("resourceid"));
    String logintype = ""+user.getLogintype();
    int usertype = 0;
    String offical = Util.null2String(request.getParameter("offical"));
    int officalType = Util.getIntValue(request.getParameter("officalType"),-1);

    /* edited by wdl 2006-06-14 left menu advanced menu */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    String selectedContent = Util.null2String(request.getParameter("selectedContent"));
    String menuType = Util.null2String(request.getParameter("menuType"));
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);
    if(selectedContent!=null && selectedContent.startsWith("key_")){
		String menuid = selectedContent.substring(4);
		RecordSet.executeSql("select * from menuResourceNode where contentindex = '"+menuid+"'");
		selectedContent = "";
		while(RecordSet.next()){
			String keyVal = RecordSet.getString(2);
			selectedContent += keyVal +"|";
		}
		if(selectedContent.indexOf("|")!=-1)
			selectedContent = selectedContent.substring(0,selectedContent.length()-1);
	}
    if(fromAdvancedMenu == 1){
		response.sendRedirect("/workflow/search/WFSearchCustom.jsp?offical="+offical+"&officalType="+officalType+"&fromadvancedmenu=1&infoId="+infoId+"&selectedContent="+selectedContent+"&menuType="+menuType);
		return;
	}
    String selectedworkflow = "";
    LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
    LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
    if(info!=null){
    	selectedworkflow = info.getSelectedContent();
    }
    if(!"".equals(selectedContent))
    {
    	selectedworkflow = selectedContent;
    }
    selectedworkflow+="|";
    /* edited end */    
    
    if(resourceid.equals("")) {
        resourceid = ""+user.getUID();
        if(logintype.equals("2")) usertype= 1;
        session.removeAttribute("RequestViewResource") ;
    }
    else {
        session.setAttribute("RequestViewResource",resourceid) ;
    }
String userID = String.valueOf(user.getUID());
String userIDAll = String.valueOf(user.getUID());
int userid=user.getUID();
String belongtoshow = "";				
		RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
		if(RecordSet.next()){
			belongtoshow = RecordSet.getString("belongtoshow");
		}
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}

	String typeid="";
	String typecount="";
	String typename="";
	String workflowid="";
	String workflowcount="";
    String newremarkwfcount0="";
    String newremarkwfcount="";
	String workflowname="";

    ArrayList wftypes=new ArrayList();
	ArrayList wftypecounts=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList workflowcounts=new ArrayList();//åé¦
    ArrayList newremarkwfcount0s=new ArrayList();//æªè¯»
    ArrayList newremarkwfcounts=new ArrayList();
    int totalcount=0;
    String _wftypes = "";
    String demoLeftMenus = "";
    if(loadtree.equals("true")){
		StringBuffer sqlsb = new StringBuffer();
		sqlsb.append("SELECT wt.id workflowtype,wb.id workflowid,wo.viewtype,wo.workflowcount FROM workflow_type wt,workflow_base wb,( ");
		sqlsb.append("select workflowtype, ");
		sqlsb.append("   workflowid, ");
		sqlsb.append("   viewtype, ");
		if("1".equals(belongtoshow)){
		sqlsb.append("   count(requestid) workflowcount ");
		}else{
		sqlsb.append("   count(distinct requestid) workflowcount ");
		}
		sqlsb.append("  from workflow_currentoperator ");
		sqlsb.append(" where (isremark in('2','4') or (isremark=0 and takisremark =-2)) ");
		sqlsb.append("   and islasttimes = 1 ");
			if("1".equals(belongtoshow)){
		sqlsb.append("	    and userid in (").append(userIDAll);
		}else{
		sqlsb.append("	    and userid in (").append(user.getUID());
		}
		sqlsb.append(" )  and usertype = ").append(usertype).append(WorkflowComInfo.getDateDuringSql(date2during));
		sqlsb.append("	 and exists ");
		sqlsb.append("	  (select 1 ");
		sqlsb.append("	           from workflow_requestbase c ");
		sqlsb.append("	          where (c.deleted <> 1 or c.deleted is null or c.deleted='') and c.workflowid = workflow_currentoperator.workflowid ");
		sqlsb.append("	            and c.requestid = workflow_currentoperator.requestid ");
		if(RecordSet.getDBType().equals("oracle"))
		{
			sqlsb.append(" and (nvl(c.currentstatus,-1) = -1 or (nvl(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
		}
		else
		{
			sqlsb.append(" and (isnull(c.currentstatus,-1) = -1 or (isnull(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
		}
		sqlsb.append(")");
		if(offical.equals("1")){
			if(officalType==1){
				sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and (isvalid=1 or isvalid=3))");
			}else if(officalType==2){
				sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and (isvalid=1 or isvalid=3))");
			}
		}
		sqlsb.append(" group by workflowtype, workflowid, viewtype ");
		//sqlsb.append(" order by workflowtype, workflowid");
		sqlsb.append(" ) wo WHERE wb.id=wo.workflowid AND wt.id=wb.workflowtype ");
		sqlsb.append(" order BY wt.dsporder asc,wt.id ASC ,wb.dsporder asc, wb.workflowname ");
		//RecordSet.executeSql("select workflowtype, workflowid, viewtype, count(distinct requestid) workflowcount from workflow_currentoperator where isremark='2' and iscomplete=0 and islasttimes=1 and userid=" +  resourceid  + " and usertype= " + usertype +" group by workflowtype, workflowid, viewtype order by workflowtype, workflowid " ) ;
		//System.out.println("--219-sqlsb--"+sqlsb.toString());
		RecordSet.executeSql(sqlsb.toString()) ;
		
		while(RecordSet.next()){       
	        String theworkflowid = Util.null2String(RecordSet.getString("workflowid")) ;        
	        String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype")) ;
			int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"),0) ;
			int viewtype = Util.getIntValue(RecordSet.getString("viewtype"),-2) ;  
			
			theworkflowid = WorkflowVersion.getActiveVersionWFID(theworkflowid);
			
	        if(WorkflowComInfo.getIsValid(theworkflowid).equals("1")){
	            /* added by wdl 2006-06-14 left menu advanced menu */
	    	 	if(selectedworkflow.indexOf("T"+theworkflowtype+"|")==-1 && fromAdvancedMenu==1) continue;
	    	 	if(selectedworkflow.indexOf("W"+theworkflowid+"|")==-1 && fromAdvancedMenu==1) continue;
	    	 	/* added end */
	        	
	            int wfindex = workflows.indexOf(theworkflowid) ;
	            if(wfindex != -1) {
	                workflowcounts.set(wfindex,""+(Util.getIntValue((String)workflowcounts.get(wfindex),0)+theworkflowcount)) ;
	                if(viewtype==-1){
	                    newremarkwfcounts.set(wfindex,""+(Util.getIntValue((String)newremarkwfcounts.get(wfindex),0)+theworkflowcount)) ;
	                }
	                	
	            }else{
	                workflows.add(theworkflowid) ;
	                workflowcounts.add(""+theworkflowcount) ;	
	                if(viewtype==-1){
	                    newremarkwfcounts.add(""+theworkflowcount);
	                    newremarkwfcount0s.add(""+0);
	                }else{
	                    newremarkwfcounts.add(""+0);
	                    newremarkwfcount0s.add(""+0);
	                }
	            }
	
	            int wftindex = wftypes.indexOf(theworkflowtype) ;
	            if(wftindex != -1) {
	                wftypecounts.set(wftindex,""+(Util.getIntValue((String)wftypecounts.get(wftindex),0)+theworkflowcount)) ;
	            }
	            else {
	                wftypes.add(theworkflowtype) ;
	                wftypecounts.add(""+theworkflowcount) ;
	            }
	
	            totalcount += theworkflowcount;
	        }
		}
		
		//å·¦ä¾§æ æ¼æ¥ json
		StringBuffer leftMenuStrBuf = new StringBuffer("[");
		//demoLeftMenus="[";
		for(int i=0;i<wftypes.size();i++){
			typeid=(String)wftypes.get(i);
			typecount=(String)wftypecounts.get(i);
			typename=WorkTypeComInfo.getWorkTypename(typeid);
			leftMenuStrBuf.append("{");	
			leftMenuStrBuf.append("\"name\":\"").append(Util.toScreenForJs(Util.toScreen(typename,user.getLanguage()))).append("\",");
			leftMenuStrBuf.append("\"hasChildren\":true,");
			leftMenuStrBuf.append("\"isOpen\":true,");
			leftMenuStrBuf.append("\"__domid__\":\"__type_").append(typeid).append("\",");
			leftMenuStrBuf.append("\"attr\":{");
			leftMenuStrBuf.append("\"typeid\":").append(typeid).append(",");
			leftMenuStrBuf.append("\"fromAdvancedMenu\":").append(fromAdvancedMenu).append(",");
			leftMenuStrBuf.append("\"infoId\":\"").append(infoId).append("\",");
			leftMenuStrBuf.append("\"selectedContent\":\"").append(selectedContent).append("\",");
			leftMenuStrBuf.append("\"menuType\":\"").append(menuType).append("\",");
			leftMenuStrBuf.append("\"date2during\":\"").append(date2during).append("\"");
			leftMenuStrBuf.append("},");
			leftMenuStrBuf.append("\"submenus\":[");
			List<Map> maps=new ArrayList(0);
			for(int j=0;j<workflows.size();j++){
				workflowid=(String)workflows.get(j);
				String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
				if(!curtypeid.equals(typeid)){
					continue;	
				}
				workflowcount=(String)workflowcounts.get(j);
				newremarkwfcount0=(String)newremarkwfcount0s.get(j);
				newremarkwfcount=(String)newremarkwfcounts.get(j);
				workflowname=WorkflowComInfo.getWorkflowname(workflowid);
 				Map map=new HashMap();
 				map.put("name",Util.toScreenForJs(Util.toScreen(workflowname,user.getLanguage())));
 				map.put("workflowid",workflowid);
 				//map.put("flowResponse",Util.toScreen(newremarkwfcount,user.getLanguage()));//
 				//map.put("flowNew",newremarkwfcount0);
 				//map.put("flowAll",Util.toScreen(workflowcount,user.getLanguage()));//
 				map.put("flowResponse","0");//
 				map.put("flowNew","0");
 				map.put("flowAll","0");//
 				maps.add(map);
			}
			int flowNew=0;
			int flowResponse=0;
			int flowAll=0;
			
			for(int x=0;x<maps.size();x++){
				Map map=maps.get(x);
				flowNew+=Integer.valueOf(map.get("flowNew")+"");
				flowResponse+=Integer.valueOf(map.get("flowResponse")+"");
				flowAll+=Integer.valueOf(map.get("flowAll")+"");
				leftMenuStrBuf.append("{");
				leftMenuStrBuf.append("\"name\":\"").append(map.get("name")).append("\",");
				leftMenuStrBuf.append("\"hasChildren\":false,");
				leftMenuStrBuf.append("\"__domid__\":\"__wf_").append(map.get("workflowid")).append("\",");
				leftMenuStrBuf.append("\"isOpen\":false,");
				leftMenuStrBuf.append("\"attr\":{");
				leftMenuStrBuf.append("\"workflowid\":").append(map.get("workflowid")).append(",");
				leftMenuStrBuf.append("\"date2during\":\"").append(date2during).append("\"");
				leftMenuStrBuf.append("},");
				leftMenuStrBuf.append("\"numbers\":{");
				leftMenuStrBuf.append("\"flowNew\":").append(map.get("flowNew")).append(",");
				leftMenuStrBuf.append("\"flowResponse\":").append(map.get("flowResponse")).append(",");
				leftMenuStrBuf.append("\"flowAll\":").append(map.get("flowAll"));
				leftMenuStrBuf.append("}");
				leftMenuStrBuf.append("}");
				leftMenuStrBuf.append((x==maps.size()-1)?"":",");
			}
			leftMenuStrBuf.append("],");
		   					
			leftMenuStrBuf.append("\"numbers\":{");
			leftMenuStrBuf.append("\"flowNew\":").append(flowNew).append(",");
			leftMenuStrBuf.append("\"flowResponse\":").append(flowResponse).append(",");
			leftMenuStrBuf.append("\"flowAll\":").append(flowAll);
			leftMenuStrBuf.append("}");
			leftMenuStrBuf.append("}");
			leftMenuStrBuf.append((i==wftypes.size()-1)?"":",");
			_wftypes += typeid+",";
		}
		
		
		//æ¥è¯¢å¼æç³»ç»æ°æ®
        if(requestutil.getOfsSetting().getIsuse()==1&&requestutil.getOfsSetting().getShowdone().equals("1")) {
            RecordSet rs = new RecordSet();
            RecordSet rs1 = new RecordSet();
            int wftype_count = 0;
            rs.executeSql("select sysid,sysshortname,sysfullname,(select COUNT(requestid) from ofs_todo_data where userid="+user.getUID()+" AND sysid=ofs_sysinfo.sysid and isremark in (2,4) and islasttimes=1 ) as c from ofs_sysinfo where cancel=0 order by sysid desc");
            wftype_count = rs.getCounts();
            while (rs.next()) {
                String _typeid = rs.getString(1);
                String _typename = rs.getString(2);
                int c = rs.getInt("c");
                if(c<=0){
                    continue;
                }
                if(requestutil.getOfsSetting().getShowsysname().equals("2")){
                    _typename = rs.getString(3);
                }
                if (leftMenuStrBuf.toString().length() > 10||demoLeftMenus.length()>10) {
                    demoLeftMenus += ",{";
                } else {
                    demoLeftMenus += "{";
                }
                demoLeftMenus+="\"name\":\""+Util.toScreenForJs(Util.toScreen(_typename,user.getLanguage()))+"\",";
                demoLeftMenus+="\"hasChildren\":true,";
                demoLeftMenus+="\"isOpen\":true,";
                demoLeftMenus+="\"__domid__\":\"__type_"+_typeid+"\",";
                demoLeftMenus+="\"attr\":{";
                demoLeftMenus+="\"typeid\":"+_typeid+",";
                demoLeftMenus+="\"fromAdvancedMenu\":"+fromAdvancedMenu+",";
                demoLeftMenus+="\"infoId\":\""+infoId+"\",";
                demoLeftMenus+="\"selectedContent\":\""+selectedContent+"\",";
                demoLeftMenus+="\"menuType\":\""+menuType+"\",";
                demoLeftMenus+="\"date2during\":\""+date2during+"\"";
                demoLeftMenus+="},";
                demoLeftMenus+="\"submenus\":[";
                int wf_count = 0;
                RecordSet.executeSql("select workflowid,workflowname from ofs_workflow where sysid=" + _typeid + " order by workflowname asc,workflowid desc");//æ¥è¯¢OSæµç¨
                wf_count = RecordSet.getCounts();
                int wfcountall = 0;
                int wfnewcountall = 0;
                while (RecordSet.next()) {
                    String _wfid = RecordSet.getString(1);
                    String _wfname = RecordSet.getString(2);
					wf_count--;
                    rs1.executeSql("select COUNT(requestid) from ofs_todo_data where userid="+user.getUID()+" AND workflowid=" + _wfid + " and isremark in (2,4) and islasttimes=1 ");
                    int wfcount = 0;
                    if (rs1.next()) {
                        wfcount = Util.getIntValue(rs1.getString(1), 0);
                    }
                    if(wfcount==0){
                        continue;
                    }
                    rs1.executeSql("select COUNT(requestid) from ofs_todo_data where userid="+user.getUID()+" AND workflowid=" + _wfid + " and isremark in (2,4) and islasttimes=1 and viewtype=0 ");
                    int wfnewcount = 0;
                    if (rs1.next()) {
                        wfnewcount = Util.getIntValue(rs1.getString(1), 0);
                    }

                    wfcountall += wfcount;
                    wfnewcountall += wfnewcount ;
                    demoLeftMenus += "{";
                    demoLeftMenus+="\"name\":\""+_wfname+"\",";
                    demoLeftMenus+="\"hasChildren\":false,";
                    demoLeftMenus+="\"__domid__\":\"__wf_"+_wfid+"\",";
                    demoLeftMenus+="\"isOpen\":false,";
                    demoLeftMenus+="\"attr\":{";
                    demoLeftMenus+="\"workflowid\":"+_wfid+",";
                    demoLeftMenus+="\"date2during\":\""+date2during+"\"";
                    demoLeftMenus+="},";
                    demoLeftMenus+="\"numbers\":{";
                    demoLeftMenus+="\"flowNew\":"+wfnewcount+",";
                    demoLeftMenus+="\"flowResponse\":0,";
                    demoLeftMenus+="\"flowAll\":"+wfcount;
                    demoLeftMenus+="}";
                    demoLeftMenus+="}";
					if(wf_count>0){
						demoLeftMenus += ",";
					}
                }

                demoLeftMenus+="],";

                demoLeftMenus+="\"numbers\":{";
                demoLeftMenus+="\"flowNew\":"+wfnewcountall+",";
                demoLeftMenus+="\"flowResponse\":0,";
                demoLeftMenus+="\"flowAll\":"+wfcountall;
                demoLeftMenus+="}";
                demoLeftMenus+="}";
            }
            leftMenuStrBuf.append(demoLeftMenus);
        }
		
		leftMenuStrBuf.append("]");
		out.clear();
		out.print(leftMenuStrBuf.toString());
		//System.out.println(demoLeftMenus);
		return;
    }
%>
