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
//是否需要加载树
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
String loadtree = Util.null2String(request.getParameter("loadtree"));
int date2during = Util.getIntValue(request.getParameter("date2during"),0);
String imagefilename = "/images/hdReport_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(1210,user.getLanguage()) +":"+SystemEnv.getHtmlLabelName(367,user.getLanguage());
String needfav ="1";
String needhelp ="";
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
String resourceid=""+user.getUID();
String userID = String.valueOf(user.getUID());
String belongtoshow = "";				
								RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
								if(RecordSet.next()){
									belongtoshow = RecordSet.getString("belongtoshow");
								}
String userIDAll = String.valueOf(user.getUID());
		
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
session.removeAttribute("RequestViewResource");
String logintype = ""+user.getLogintype();
int usertype = 0; 

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
		response.sendRedirect("/workflow/search/WFSearchCustom.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&offical="+offical+"&officalType="+officalType+"&fromadvancedmenu=1&infoId="+infoId+"&selectedContent="+selectedContent+"&menuType="+menuType);
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

if(logintype.equals("2"))
	usertype= 1;

	ArrayList wftypes=new ArrayList();
	ArrayList wftypecounts=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList wftypecountsy=new ArrayList();
	ArrayList workflowcounts=new ArrayList();//未归档的
	ArrayList workflowcountsy=new ArrayList();//归档
	ArrayList newcountslist = new ArrayList();//未读
	ArrayList supedcountslist = new ArrayList();//反馈
	ArrayList overcountslist = new ArrayList();//超时
	
	
	Map workflowcountsMap=new Hashtable();//未归档的数量
	Map workflowcountsyMap=new Hashtable();//归档数量
	Map newcountsMap=new Hashtable();     //未读
	Map supedcountsMap=new Hashtable();//反馈数量
	Map overcountsMap = new Hashtable();	//超时数量
	
	String _viewtype = "";	//
	int totalcount=0;
	int totalcounty=0;
	String currworkflowtype="";
	
	String currworkflowid="";
	String currentnodetype="";
	String _wftypes = "";
	String demoLeftMenus = "";
    if(loadtree.equals("true")){
		
		StringBuffer sqlsb = new StringBuffer();
		sqlsb.append("SELECT wo.typecount,wt.id workflowtype,wb.id workflowid,wo.currentnodetype  FROM workflow_type wt,workflow_base wb,( ");
		sqlsb.append("select count(distinct t1.requestid) typecount, ");
		sqlsb.append("      t2.workflowtype, ");
		sqlsb.append("      t1.workflowid, ");
		sqlsb.append("      t1.currentnodetype ");
		sqlsb.append(" from workflow_requestbase t1, workflow_base t2,workflow_currentoperator t3 ");
			if("1".equals(belongtoshow)){
		sqlsb.append(" where t1.creater in ( ").append(userIDAll);	
			}else{
		sqlsb.append(" where t1.creater in (").append(resourceid);
			}	
		sqlsb.append(") and t1.creatertype = ").append(usertype);
		sqlsb.append("  and t1.workflowid = t2.id ");
		sqlsb.append("  and t1.requestid = t3.requestid ");
		sqlsb.append("  and t3.islasttimes=1 ");
		sqlsb.append("  and (t2.isvalid='1' or t2.isvalid='3') ");
		if(RecordSet.getDBType().equals("oracle"))
		{
			sqlsb.append(" and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ");
		}
		else
		{
			sqlsb.append(" and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ");
		}
		sqlsb.append("  and exists ");
		sqlsb.append("		(select 1 ");
		sqlsb.append("         from workflow_currentoperator ");
		sqlsb.append("        where workflow_currentoperator.islasttimes='1' ");
		if("1".equals(belongtoshow)){
		sqlsb.append("          and workflow_currentoperator.userid in (" + userIDAll + WorkflowComInfo.getDateDuringSql(date2during) +")) ");
		}else{
		sqlsb.append("          and workflow_currentoperator.userid in ( " + resourceid + WorkflowComInfo.getDateDuringSql(date2during) +")) ");
		}
		if(offical.equals("1")){//发文/收文/签报
			if(officalType==1){
				sqlsb.append(" and t1.workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and isvalid=1)");
			}else if(officalType==2){
				sqlsb.append(" and t1.workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and isvalid=1)");
			}
		}
		sqlsb.append(" group by t2.workflowtype, t1.workflowid, t1.currentnodetype ");
		sqlsb.append(" ) wo WHERE wb.id=wo.workflowid AND wt.id=wb.workflowtype ");
		sqlsb.append(" order BY wt.dsporder asc,wt.id ASC ,wb.dsporder asc, wb.workflowname ");
		RecordSet.executeSql(sqlsb.toString());
		//System.out.println("sqlsb.toString():"+sqlsb.toString());
	    //RecordSet.executeProc("workflow_requestbase_MyRequest",resourceid+flag+usertype);
		while (RecordSet.next())
		{
			currworkflowtype = RecordSet.getString("workflowtype");
			currworkflowid = RecordSet.getString("workflowid");
			 
			currworkflowid = WorkflowVersion.getActiveVersionWFID(currworkflowid);
			 
			currentnodetype=RecordSet.getString("currentnodetype");
			_viewtype = RecordSet.getString("viewtype");
			int theworkflowcount=RecordSet.getInt("typecount");
			if(selectedworkflow.indexOf("T"+currworkflowtype+"|")==-1 && fromAdvancedMenu==1) continue;
			if(selectedworkflow.indexOf("W"+currworkflowid+"|")==-1 && fromAdvancedMenu==1) continue;
			int temps=wftypes.indexOf(currworkflowtype);
			if (temps!=-1)
			{
			 	if (currentnodetype.equals("3"))
			 		wftypecountsy.set(temps,""+(Util.getIntValue((String)wftypecountsy.get(temps),0)+theworkflowcount));
			 	else
			  		wftypecounts.set(temps,""+(Util.getIntValue((String)wftypecounts.get(temps),0)+theworkflowcount));
			}
			else
			{
			 	wftypes.add(currworkflowtype);
			 	if (currentnodetype.equals("3"))
			 	{
			 		wftypecountsy.add(""+RecordSet.getString("typecount"));
			 		wftypecounts.add(""+0);
			 	}
			 	else
			 	{
			 		wftypecounts.add(""+RecordSet.getString("typecount"));
			 		wftypecountsy.add(""+0);
			 	}
			}
			temps=workflows.indexOf(currworkflowid);
			if (temps!=-1)
			{
				if (currentnodetype.equals("3"))
			 		workflowcountsy.set(temps,""+(Util.getIntValue((String)workflowcountsy.get(temps),0)+theworkflowcount));	
			 	else
			 		workflowcounts.set(temps,""+(Util.getIntValue((String)workflowcounts.get(temps),0)+theworkflowcount));
			}
			else
			{
			 	workflows.add(currworkflowid);
			 	if (currentnodetype.equals("3"))
			 	{
			 		workflowcountsy.add(""+RecordSet.getString("typecount"));
			 		workflowcounts.add(""+0);
			 	}
			 	else
			 	{
			 		workflowcounts.add(""+RecordSet.getString("typecount"));
			 		workflowcountsy.add(""+0);
			 	}
			}
			 
			if (currentnodetype.equals("3"))
			 	totalcounty+=theworkflowcount;
			else
			 	totalcount+=theworkflowcount;
		}
		
		//左侧树 json 数据生成逻辑
		demoLeftMenus+="[";
		String typeid="";
		String typecount="";	//未归档的type数量
		String typecounty = "";	//已归档的type数量
		String typename="";
		String workflowid="";
		String workflowcount="";	//未归档的数量
		String workflowcounty = "";	//归档的数量

		String wfnewcount = ""; //未读
		String wfrescount = ""; //反馈
		String wfoutcount = ""; //超时
		String workflowname="";
		       				
		       				//System.out.println("wftypes.size():流程类型总数==>"+wftypes.size());	//流程类型总数
		for(int i=0;i<wftypes.size();i++){
			typeid=(String)wftypes.get(i);
			//typecount=(String)wftypecounts.get(i);
			//typecounty = (String)wftypecountsy.get(i);
			typename=WorkTypeComInfo.getWorkTypename(typeid);
		
			demoLeftMenus+="{";
			demoLeftMenus+="\"name\":\""+Util.toScreenForJs(Util.toScreen(typename,user.getLanguage()))+"\",";
			demoLeftMenus+="\"__domid__\":\"__type_"+typeid+"\",";
			demoLeftMenus+="\"isOpen\":\"true\",";
			demoLeftMenus+="\"attr\":{";
			demoLeftMenus+="\"typeid\":"+typeid+",";
			demoLeftMenus+="\"fromAdvancedMenu\":"+fromAdvancedMenu+",";
			demoLeftMenus+="\"infoId\":"+infoId+",";
			demoLeftMenus+="\"selectedContent\":\""+selectedContent+"\",";
			demoLeftMenus+="\"menuType\":\""+menuType+"\",";
			demoLeftMenus+="\"date2during\":\""+date2during+"\"";
			demoLeftMenus+="},";
			demoLeftMenus+="\"submenus\":[";
			List<Map> maps=new ArrayList(0);
			for(int j=0;j<workflows.size();j++){
				workflowid=(String)workflows.get(j);
				String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
				if(!curtypeid.equals(typeid)){
					continue;
				}
				
				workflowcount=(String)workflowcounts.get(j);
				workflowcounty = (String)workflowcountsy.get(j);
				//wfnewcount = (String)newcountslist.get(j);
				//wfrescount = (String)supedcountslist.get(j);
				//wfoutcount = (String)overcountslist.get(j);
				
				Object tempovtimenumObj = newcountsMap.get(workflowid);
				if (tempovtimenumObj != null) {
				    wfnewcount = tempovtimenumObj.toString();
				} else {
				    wfnewcount = "0";
				}
				
				Object tempovtimenumObj2 = supedcountsMap.get(workflowid);
				if (tempovtimenumObj2 != null) {
				    wfrescount = tempovtimenumObj2.toString();
				} else {
				    wfrescount = "0";
				}
				
				Object tempovtimenumObj3 = overcountsMap.get(workflowid);
				if (tempovtimenumObj3 != null) {
				    wfoutcount = tempovtimenumObj3.toString();
				} else {
				    wfoutcount = "0";
				}
				
				
				//把未归档的和已归档的合并起来  modifier Dracula 2014-7-7
				String wfallcount = (Util.getIntValue(workflowcount) + Util.getIntValue(workflowcounty))+"";
				//System.out.println("未归档："+workflowcount+"   已归档："+workflowcounty);
				workflowname=WorkflowComInfo.getWorkflowname(workflowid);
				//System.out.println(workflowname+"   未读流程："+wfnewcount+"反馈流程："+wfrescount);
					Map map=new HashMap();
					map.put("name",Util.toScreenForJs(Util.toScreen(workflowname,user.getLanguage())));
					map.put("workflowid",workflowid);
					map.put("flowAll",Util.toScreen("0",user.getLanguage()));
					map.put("flowNew",Util.toScreen("0",user.getLanguage()));
					map.put("flowResponse",Util.toScreen("0",user.getLanguage()));
					map.put("flowOut",Util.toScreen("0",user.getLanguage()));
					if(workflowcount.equals("")) workflowcount = "0";
					if(workflowcounty.equals("0")) workflowcounty = "0";
					//把未归档的和已归档的合并起来 modifier Dracula 2014-7-7
					if(workflowcount.equals("0") && workflowcounty.equals("0"));
					else{
						maps.add(map);
					}
			}
			int flowAll=0;
			int flowNew=0;
			int flowResponse=0;
			int flowOut=0;
			for(int x=0;x<maps.size();x++){
				Map map=maps.get(x);
				flowAll+=Integer.valueOf(map.get("flowAll")+"");
				flowNew+=Integer.valueOf(map.get("flowNew")+"");
				flowResponse+=Integer.valueOf(map.get("flowResponse")+"");
				flowOut+=Integer.valueOf(map.get("flowOut")+"");
		       							
				demoLeftMenus+="{";	
				demoLeftMenus+="\"name\":\""+map.get("name")+"\",";
				demoLeftMenus+="\"__domid__\":\"__wf_"+map.get("workflowid")+"\",";
				demoLeftMenus+="\"isOpen\":\"true\",";
				demoLeftMenus+="\"attr\":{";
				demoLeftMenus+="\"workflowid\":"+map.get("workflowid")+",";
				demoLeftMenus+="\"date2during\":\""+date2during+"\"";
				demoLeftMenus+="},";
				demoLeftMenus+="\"numbers\":{";
				demoLeftMenus+="\"flowAll\":"+map.get("flowAll")+",";
				demoLeftMenus+="\"flowNew\":"+map.get("flowNew")+",";
				demoLeftMenus+="\"flowResponse\":"+map.get("flowResponse")+",";
				demoLeftMenus+="\"flowOut\":"+map.get("flowOut");
				demoLeftMenus+="}";
				demoLeftMenus+="}";
				demoLeftMenus += (x==maps.size()-1)?"":",";
			}
			demoLeftMenus+="],";
			demoLeftMenus+="\"numbers\":{";
			demoLeftMenus+="\"flowAll\":"+flowAll+",";
			demoLeftMenus+="\"flowNew\":"+flowNew+",";
			demoLeftMenus+="\"flowResponse\":"+flowResponse+",";
			demoLeftMenus+="\"flowOut\":"+flowOut;
			demoLeftMenus+="}";
			demoLeftMenus+="}";
			demoLeftMenus += (i==wftypes.size()-1)?"":",";
			_wftypes += typeid+",";
		}
		
		if(requestutil.getOfsSetting().getIsuse() == 1){
            RecordSet rs = new RecordSet();
            RecordSet rs1 = new RecordSet();
            //查询流程分类数据
            int wftype_count = 0 ;
            rs.executeSql("select sysid,sysshortname,sysfullname from ofs_sysinfo where cancel=0 order by sysid desc ");
            wftype_count = rs.getCounts();
            if(wftype_count >0 ){
                //demoLeftMenus+=",";
            }
            while(rs.next()){
                String _typeid = rs.getString(1);
                String _typename = rs.getString(2);
				if(requestutil.getOfsSetting().getShowsysname().equals("2")){
                    _typename = rs.getString(3);
                }

                RecordSet.executeSql("select 1 from ofs_todo_data where creatorid="+user.getUID()+" and creatorid=userid and islasttimes=1 and sysid="+_typeid);
                int allwfcount = RecordSet.getCounts();
                if(allwfcount==0){
                    continue ;
                }
                if(demoLeftMenus.length()>10){
                    demoLeftMenus +=",{";
                }else{
                    demoLeftMenus +="{";
                }
                demoLeftMenus += "\"name\":\""+_typename+"\",";
                demoLeftMenus+="\"__domid__\":\"__type_"+_typeid+"\",";
                demoLeftMenus += "\"hasChildren\":"+true+",";
                demoLeftMenus += "\"isOpen\":"+true+",";
                demoLeftMenus += "\"submenus\":[";
                int wf_count = 0 ;
                int wfnewcountall = 0 ;
                RecordSet.executeSql("select workflowid,workflowname from ofs_workflow where sysid="+_typeid+" and cancel=0  order by workflowname asc,workflowid desc ");//查询EAS流程
                wf_count = RecordSet.getCounts();
                int wfcountall = 0 ;
                while(RecordSet.next()){
                    String _wfid = RecordSet.getString(1);
                    String _wfname = RecordSet.getString(2);
                    rs1.executeSql("select count(*) from ofs_todo_data where creatorid="+user.getUID()+" and creatorid=userid and islasttimes=1 and workflowid="+_wfid+" and sysid="+_typeid);
                    int wfcount = 0;
                    if(rs1.next()){
                        wfcount = Util.getIntValue(rs1.getString(1),0);
                    }
                    rs1.executeSql("select count(*) from ofs_todo_data where creatorid="+user.getUID()+" and creatorid=userid  and islasttimes=1 and viewtype='0' and workflowid="+_wfid+" and sysid="+_typeid);
                    int _wfnewcount = 0;
                    if(rs1.next()){
                        _wfnewcount = Util.getIntValue(rs1.getString(1),0);
                    }
                    
                    if(wfcount==0){
                        continue ;
                    }
                    wfcountall += wfcount ;
                    wfnewcountall += _wfnewcount ;
                    demoLeftMenus += "{";
                    demoLeftMenus += "\"name\":\""+_wfname+"\",";
                    demoLeftMenus+="\"__domid__\":\"__wf_"+_wfid+"\",";
                    demoLeftMenus += "\"hasChildren\":false,";
                    demoLeftMenus+="\"attr\":{";
                    demoLeftMenus+="\"workflowid\":"+_wfid+",";
                    demoLeftMenus+="\"date2during\":\""+date2during+"\"";
                    demoLeftMenus+="},";
                    demoLeftMenus+="\"numbers\":{";
                    demoLeftMenus+="\"flowAll\":"+wfcount+",";
                    demoLeftMenus+="\"flowNew\":"+_wfnewcount+",";
                    demoLeftMenus+="\"flowResponse\":0,";
                    demoLeftMenus+="\"flowOut\":0";
                    demoLeftMenus+="}";
                    demoLeftMenus += "}";
                    demoLeftMenus += ",";
                }
                if(demoLeftMenus.endsWith(",")){
                    demoLeftMenus = demoLeftMenus.substring(0,demoLeftMenus.length()-1);
                }
                demoLeftMenus += "],";
                demoLeftMenus+="\"attr\":{";
                demoLeftMenus+="\"typeid\":"+_typeid+",";
                demoLeftMenus+="\"fromAdvancedMenu\":"+fromAdvancedMenu+",";
                demoLeftMenus+="\"infoId\":"+infoId+",";
                demoLeftMenus+="\"selectedContent\":\""+selectedContent+"\",";
                demoLeftMenus+="\"menuType\":\""+menuType+"\",";
                demoLeftMenus+="\"date2during\":\""+date2during+"\"";
                demoLeftMenus += "},";

                demoLeftMenus += "\"numbers\":{";
                demoLeftMenus+="\"flowAll\":"+wfcountall+",";
                demoLeftMenus+="\"flowNew\":"+wfnewcountall+",";
                demoLeftMenus+="\"flowResponse\":0,";
                demoLeftMenus+="\"flowOut\":0";
                demoLeftMenus += "}";
                demoLeftMenus += "}";
            }
        }
		
		demoLeftMenus += "]";
		out.clear();
		out.print(demoLeftMenus);
		//System.out.println(demoLeftMenus);
		return;
    }
%>

