
<%@page import="weaver.general.Pinyin4j"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page language="java" contentType="application/json; charset=UTF-8" %> 
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import = "weaver.general.TimeUtil"%>
<%@ page import = "org.json.JSONObject"%>


<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="Monitor" class="weaver.workflow.monitor.Monitor" scope="page" />


<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid2=user.getUID();  
if(user == null)  return ;


int requestid = Util.getIntValue(request.getParameter("requestid")) ;
String workflowid = Util.null2String(request.getParameter("workflowid")) ;
String nodeid = Util.null2String(request.getParameter("nodeid")) ;
String isbill = Util.null2String(request.getParameter("isbill")) ;
String formid = Util.null2String(request.getParameter("formid")) ;
int desrequestid=Util.getIntValue(request.getParameter("desrequestid"));
String userid=new Integer(user.getUID()).toString();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 内部用户  2:外部用户
String isurger=Util.null2String(request.getParameter("isurger"));
boolean isOldWf_ = false;
RecordSetOld.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSetOld.next()){
    if(RecordSetOld.getString("nodeid") == null || "".equals(RecordSetOld.getString("nodeid")) || "-1".equals(RecordSetOld.getString("nodeid"))){
            isOldWf_ = true;
    }
}
if(isOldWf_){
String url = "/workflow/request/WorkflowManageRequestPicture_old.jsp?f_weaver_belongto_userid="+userid2+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid=" + requestid + "&workflowid="+workflowid+"&nodeid="+nodeid+"&isbill="+isbill+"&formid="+formid;
response.sendRedirect(url);

}



if(isurger.equals("true")|| Monitor.hasMonitor(requestid+"",user.getUID()+"")){
   StringBuffer sqlsb = new StringBuffer();
    sqlsb.append("select * ");
    sqlsb.append("    from (select a.nodeid, ");
    sqlsb.append("                 b.nodename, ");
    sqlsb.append("              a.userid, ");
    sqlsb.append("              a.isremark, ");
    sqlsb.append("              a.lastisremark, ");
    sqlsb.append("              a.usertype, ");
    sqlsb.append("             a.agentorbyagentid, ");
    sqlsb.append("             a.agenttype, ");
    sqlsb.append("             a.receivedate, ");
    sqlsb.append("             a.receivetime, ");
    sqlsb.append("             a.operatedate, ");
    sqlsb.append("             a.operatetime, ");
    sqlsb.append("             a.viewtype, ");
    sqlsb.append("             a.nodetype ");
    sqlsb.append("        from (SELECT distinct requestid, ");
    sqlsb.append("                              userid, ");
    sqlsb.append("                              workflow_currentoperator.workflowid, ");
    sqlsb.append("                              workflowtype, ");
    sqlsb.append("                              isremark, ");
    sqlsb.append("                              lastisremark, ");
    sqlsb.append("                              usertype, ");
    sqlsb.append("                              workflow_currentoperator.nodeid, ");
    sqlsb.append("                              agentorbyagentid, ");
    sqlsb.append("                              agenttype, ");
    sqlsb.append("                              receivedate, ");
    sqlsb.append("                              receivetime, ");
    sqlsb.append("                              viewtype, ");
    sqlsb.append("                              iscomplete, ");
    sqlsb.append("                              operatedate, ");
    sqlsb.append("                              operatetime, ");
    sqlsb.append("                              nodetype ");
    sqlsb.append("                FROM workflow_currentoperator, workflow_flownode ");
    sqlsb.append("               where workflow_currentoperator.nodeid = ");
    sqlsb.append("                     workflow_flownode.nodeid ");
    sqlsb.append("                 and requestid = "+requestid+") a, ");
    sqlsb.append("             workflow_nodebase b ");
    sqlsb.append("       where a.nodeid = b.id ");
    sqlsb.append("         and a.requestid = "+requestid+" ");
    sqlsb.append("         and a.agenttype <> 1 ");
    sqlsb.append("      union ");
    sqlsb.append("      select a.nodeid, ");
    sqlsb.append("             b.nodename, ");
    sqlsb.append("             a.userid, ");
    sqlsb.append("             a.isremark, ");
    sqlsb.append("             a.isremark as lastisremark, ");
    sqlsb.append("             a.usertype, ");
    sqlsb.append("             0 as agentorbyagentid, ");
    sqlsb.append("             '' as agenttype, ");
    sqlsb.append("             a.receivedate, ");
    sqlsb.append("             a.receivetime, ");
    sqlsb.append("             a.operatedate, ");
    sqlsb.append("             a.operatetime, ");
    sqlsb.append("             a.viewtype, ");
    sqlsb.append("             a.nodetype ");
    sqlsb.append("        from (SELECT distinct o.requestid, ");
    sqlsb.append("                              o.userid, ");
    sqlsb.append("                              o.workflowid, ");
    sqlsb.append("                              o.isremark, ");
    sqlsb.append("                              o.usertype, ");
    sqlsb.append("                              o.nodeid, ");
    sqlsb.append("                              o.receivedate, ");
    sqlsb.append("                              o.receivetime, ");
    sqlsb.append("                              o.viewtype, ");
    sqlsb.append("                              o.operatedate, ");
    sqlsb.append("                              o.operatetime, ");
    sqlsb.append("                              n.nodetype ");
    sqlsb.append("                FROM workflow_otheroperator o, workflow_flownode n ");
    sqlsb.append("               where o.nodeid = n.nodeid ");
    sqlsb.append("                 and o.requestid = "+requestid+") a, ");
    sqlsb.append("             workflow_nodebase b ");
    sqlsb.append("       where a.nodeid = b.id ");
    sqlsb.append("         and a.requestid = "+requestid+") a ");
       //add by liaodong for qc76119 in 2013-10-09 start
    sqlsb.append(" order by a.nodetype,case when a.operatedate is null then 1 else 0 end,a.operatetime,a.receivedate, a.receivetime ");
    //end 
   rs.executeSql(sqlsb.toString());
   
}else{
    String viewLogIds = "";
    ArrayList canViewIds = new ArrayList();
    String viewNodeId = "-1";
    String tempNodeId = "-1";
    String singleViewLogIds = "-1";
    rs.executeSql("select distinct nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+userid);

    while(rs.next()){
        viewNodeId = rs.getString("nodeid");
        rs1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
        if(rs1.next()){
            singleViewLogIds = rs1.getString("viewnodeids");
        }
    
        if("-1".equals(singleViewLogIds)){//全部查看
            rs1.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
            while(rs1.next()){
                tempNodeId = rs1.getString("nodeid");
                if(!canViewIds.contains(tempNodeId)){
                    canViewIds.add(tempNodeId);
                }
            }
        }
        else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看
    
        }
        else{//查看部分
            String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
            for(int i=0;i<tempidstrs.length;i++){
                if(!canViewIds.contains(tempidstrs[i])){
                    canViewIds.add(tempidstrs[i]);
                }
            }
        }
    }

//处理相关流程的查看权限


    if(desrequestid>0)
    {
        //System.out.print("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid="+desrequestid+"  and  a.userid=b.userid)");
        rs.executeSql("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid="+desrequestid+"  and  a.userid=b.userid)");
        while(rs.next()){
            viewNodeId = rs.getString("nodeid");
            rs1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
            if(rs1.next()){
                singleViewLogIds = rs1.getString("viewnodeids");
            }
        
            if("-1".equals(singleViewLogIds)){//全部查看
                rs1.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+desrequestid+"))");
                while(rs1.next()){
                    tempNodeId = rs1.getString("nodeid");
                    if(!canViewIds.contains(tempNodeId)){
                        canViewIds.add(tempNodeId);
                    }
                }
            }
            else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看
        
            }
            else{//查看部分
                String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
                for(int i=0;i<tempidstrs.length;i++){
                    if(!canViewIds.contains(tempidstrs[i])){
                        canViewIds.add(tempidstrs[i]);
                    }
                }
            }
        }
    }
    if(canViewIds.size()>0){
        for(int a=0;a<canViewIds.size();a++)
        {
            viewLogIds += (String)canViewIds.get(a) + ",";
        }
        viewLogIds = viewLogIds.substring(0,viewLogIds.length()-1);
    }
    else{
        viewLogIds = "-1";
    }
    StringBuffer sqlsb = new StringBuffer();
    sqlsb.append("select * ");
    sqlsb.append("    from (select a.nodeid, ");
    sqlsb.append("             b.nodename, ");
    sqlsb.append("             a.userid, ");
    sqlsb.append("             a.isremark, ");
    sqlsb.append("             a.lastisremark, ");
    sqlsb.append("             a.usertype, ");
    sqlsb.append("             a.agentorbyagentid, ");
    sqlsb.append("             a.agenttype, ");
    sqlsb.append("             a.receivedate, ");
    sqlsb.append("             a.receivetime, ");
    sqlsb.append("             a.operatedate, ");
    sqlsb.append("             a.operatetime, ");
    sqlsb.append("             a.viewtype, ");
    sqlsb.append("             a.nodetype ");
    sqlsb.append("        from (SELECT distinct requestid, ");
    sqlsb.append("                              userid, ");
    sqlsb.append("                              workflow_currentoperator.workflowid, ");
    sqlsb.append("                              workflowtype, ");
    sqlsb.append("                              isremark, ");
    sqlsb.append("                              lastisremark, ");
    sqlsb.append("                              usertype, ");
    sqlsb.append("                              workflow_currentoperator.nodeid, ");
    sqlsb.append("                              agentorbyagentid, ");
    sqlsb.append("                              agenttype, ");
    sqlsb.append("                              receivedate, ");
    sqlsb.append("                              receivetime, ");
    sqlsb.append("                              viewtype, ");
    sqlsb.append("                              iscomplete, ");
    sqlsb.append("                              operatedate, ");
    sqlsb.append("                              operatetime, ");
    sqlsb.append("                              nodetype ");
    sqlsb.append("                FROM workflow_currentoperator, workflow_flownode ");
    sqlsb.append("               where workflow_currentoperator.nodeid = ");
    sqlsb.append("                     workflow_flownode.nodeid ");
    sqlsb.append("                 and requestid = "+requestid+") a, ");
    sqlsb.append("             workflow_nodebase b ");
    sqlsb.append("       where a.nodeid = b.id ");
    sqlsb.append("         and a.requestid = "+requestid+" ");
    sqlsb.append("         and a.agenttype <> 1 ");
    sqlsb.append("         and a.nodeid in ("+viewLogIds+") ");
    sqlsb.append("      union ");
    sqlsb.append("      select a.nodeid, ");
    sqlsb.append("             b.nodename, ");
    sqlsb.append("             a.userid, ");
    sqlsb.append("             a.isremark, ");
    sqlsb.append("             a.isremark as lastisremark, ");
    sqlsb.append("             a.usertype, ");
    sqlsb.append("             0 as agentorbyagentid, ");
    sqlsb.append("             '' as agenttype, ");
    sqlsb.append("             a.receivedate, ");
    sqlsb.append("             a.receivetime, ");
    sqlsb.append("             a.operatedate, ");
    sqlsb.append("             a.operatetime, ");
    sqlsb.append("             a.viewtype, ");
    sqlsb.append("             a.nodetype ");
    sqlsb.append("        from (SELECT distinct o.requestid, ");
    sqlsb.append("                              o.userid, ");
    sqlsb.append("                              o.workflowid, ");
    //sqlsb.append("                              o.workflowtype, ");
    sqlsb.append("                              o.isremark, ");
    sqlsb.append("                              o.usertype, ");
    sqlsb.append("                              o.nodeid, ");
    sqlsb.append("                              o.receivedate, ");
    sqlsb.append("                              o.receivetime, ");
    sqlsb.append("                              o.viewtype, ");
    sqlsb.append("                              o.operatedate, ");
    sqlsb.append("                              o.operatetime, ");
    sqlsb.append("                              n.nodetype ");
    sqlsb.append("                FROM workflow_otheroperator o, workflow_flownode n ");
    sqlsb.append("               where o.nodeid = n.nodeid ");
    sqlsb.append("                 and o.requestid = "+requestid+") a, ");
    sqlsb.append("             workflow_nodebase b ");
    sqlsb.append("       where a.nodeid = b.id ");
    sqlsb.append("         and a.requestid = "+requestid+" ");
    sqlsb.append("         and a.nodeid in ("+viewLogIds+")) a ");
     //add by liaodong for qc76119 in 2013-10-09 start
    sqlsb.append(" order by a.nodetype,case when a.operatedate is null then 1 else 0 end,a.operatetime,a.receivedate, a.receivetime ");
    //end 
    rs.executeSql(sqlsb.toString());
    //rs.executeSql("select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid, a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype from (SELECT distinct t1.id,t1.requestid ,t1.userid ,t1.workflowid ,workflowtype ,isremark ,t1.usertype ,t1.nodeid ,agentorbyagentid ,agenttype  ,receivedate ,receivetime ,viewtype ,iscomplete  ,operatedate ,operatetime,nodetype FROM workflow_currentoperator t1,workflow_flownode t2,(select max(id) id,nodeid,userid,usertype from workflow_currentoperator where requestid="+requestid+" group by nodeid,userid,usertype) t3  where t1.id=t3.id and t1.nodeid=t2.nodeid and t1.requestid = "+requestid+") a,workflow_nodebase b where a.nodeid=b.id and a.requestid="+requestid+" and a.agenttype<>1 and a.nodeid in("+viewLogIds+") order by a.receivedate,a.receivetime,a.nodetype");

}



    int tmpnodeid_old=-1;
    boolean islight=false;

    ArrayList<Map<String,String>>  operators = new ArrayList<Map<String,String>>();

    Map<String,String>  operator;

    List<String>  operatorflag=new ArrayList<String>();

    while(rs.next()){
        int     tmpnodeid=rs.getInt("nodeid");
        String  tmpnodename=rs.getString("nodename");
        String  tmpuserid=rs.getString("userid");
        String  tmpagentorbyagentid=rs.getString("agentorbyagentid");
        //int     tmpisremark=rs.getInt("isremark");
        String  tmpisremark = Util.null2String(rs.getString("isremark"));
        
        if (tmpnodeid_old != tmpnodeid) {
            tmpnodeid_old = tmpnodeid;
            operatorflag = new ArrayList<String>();
        }
        
        operator=new HashMap<String,String>();
        
        if(tmpisremark.equals(""))
        {
            tmpisremark = Util.null2String(rs.getString("lastisremark"));
        }

        int     tmpusertype=rs.getInt("usertype");
        int     tmpagenttype=rs.getInt("agenttype");

        

       if(tmpusertype == 0){
           if(!operatorflag.contains(tmpuserid)) {
               operator.put("uid",tmpuserid);
               
               String username = Util.toScreen(ResourceComInfo.getResourcename(tmpuserid),user.getLanguage());
               operator.put("data", username);
               operator.put("nodeid", tmpnodeid + "");
               operator.put("nodename", tmpnodename);
               
               operator.put("datapy", Pinyin4j.spell(username));
               if(tmpisremark.equals("2"))
                  operator.put("handed","1");
                else
                    operator.put("handed","0");
                operators.add(operator);
                operatorflag.add(tmpuserid); 
            }
            if(tmpagenttype==2){
                     
                if(!operatorflag.contains(tmpuserid))
                {
                    operator=new HashMap<String,String>();
                    operator.put("uid",tmpagentorbyagentid);
                    String username = Util.toScreen(ResourceComInfo.getResourcename(tmpagentorbyagentid),user.getLanguage());
                    operator.put("data", username);
                    
                    operator.put("nodeid", tmpnodeid + "");
                    operator.put("nodename", tmpnodename);
                    operator.put("datapy", Pinyin4j.spell(username));
                    
                    if(tmpisremark.equals("2"))
                        operator.put("handed","1");
                    else
                        operator.put("handed","0");
                    operators.add(operator);    
                    operatorflag.add(tmpuserid); 
                }
                        
           }
          } 
                 
     }

     StringBuffer sb=new StringBuffer("[");
     JSONObject  jsonitem;
     for(Map<String,String>  item:operators)
     {
          jsonitem=new JSONObject(item); 
          sb.append(jsonitem.toString()).append(",");
     }
     String rsdata="";
     if(operators.size()>0)
     {
     rsdata=sb.substring(0,sb.length()-1)+"]";
     }
     else
     rsdata=sb.toString()+"]";
     //System.out.println(rsdata);
     out.println(rsdata);
     return;
     %>