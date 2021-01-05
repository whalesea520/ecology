
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.ArrayList" %>

<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.Util" %>

<%@ page import = "weaver.general.TimeUtil"%>

<%
//是否开启新版流程图，开启则跳转至新版显示
weaver.general.BaseBean bb = new weaver.general.BaseBean();
int isuseNewDesign = Util.getIntValue(
        bb.getPropValue("workflowNewDesign", "isusingnewDesign"), 0);

if (isuseNewDesign == 1) {
    request.getRequestDispatcher("/workflow/request/WorkflowRequestNewPictureInner.jsp").forward(request, response);
    return ;
}
%>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSetA" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891 --%>
<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="rsCheckUserCreater" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<%
int isfromdirection = Util.getIntValue(request.getParameter("isfromdirection"), 0);
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String isview = Util.null2String(request.getParameter("isview")) ;
String fromFlowDoc = Util.null2String(request.getParameter("fromFlowDoc")) ;
int modeid = Util.getIntValue(request.getParameter("modeid"),0) ;
int requestid = Util.getIntValue(request.getParameter("requestid")) ;
String workflowid = Util.null2String(request.getParameter("workflowid")) ;
String nodeid = Util.null2String(request.getParameter("nodeid")) ;
String isbill = Util.null2String(request.getParameter("isbill")) ;
String formid = Util.null2String(request.getParameter("formid")) ;
String sql = "" ;
// add by xhheng @20050206 for TD 1544
String userid=new Integer(user.getUID()).toString();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 内部用户  2:外部用户

boolean isOldWf_ = false;
RecordSetOld.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSetOld.next()){
    if(RecordSetOld.getString("nodeid") == null || "".equals(RecordSetOld.getString("nodeid")) || "-1".equals(RecordSetOld.getString("nodeid"))){
            isOldWf_ = true;
    }
}
if(isOldWf_){
String url = "/workflow/request/WorkflowManageRequestPicture_old.jsp?requestid=" + requestid + "&workflowid="+workflowid+"&nodeid="+nodeid+"&isbill="+isbill+"&formid="+formid;
response.sendRedirect(url);
return;

}

%>

<%
/*----added by xwj for td2891 begin-----*/
String sqlTemp = "select nodeid from workflow_flownode where workflowid = "+workflowid+" and nodetype = '0'";
RecordSetA.executeSql(sqlTemp);
RecordSetA.next();
String creatorNodeId = RecordSetA.getString("nodeid");
/*----added by xwj for td2891 end-----*/
String currentnodeid=""+WFLinkInfo.getCurrentNodeidNew(Util.getIntValue(requestid + ""),user.getUID(),Util.getIntValue(logintype,1));
if(currentnodeid.equals("0")) currentnodeid=nodeid;
%>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<TABLE border=0 cellpadding=0 cellspacing=0  width="100%"><TR><TD ID='InnerIMAGETD'>

<script language=javascript src="/js/weaver_wev8.js"></script>

<%if(requestid!= -1){%>
<img id="wfRstPicImg" src="/weaver/weaver.workflow.workflow.ShowWorkFlow?requestid=<%=requestid%>" border=0 >
<%}else{%>
<img id="wfRstPicImg" src="/weaver/weaver.workflow.workflow.ShowWorkFlow?requestid=<%=requestid%>&workflowid=<%=workflowid%>&currentnodeid=<%=currentnodeid%>" border=0 >
<%}%>
<%

int top0 = 16;   // 顶部空间
if(isfromdirection == 1){
    top0 = -10;   // 顶部空间
}
int temptopsize = Util.getIntValue(request.getParameter("temptopsize"),0) ;
if(temptopsize==52){top0=temptopsize;}
if(fromFlowDoc.equals("1")){
   if(isview.equals("1")){
     top0+=10;//top0+=-15;
   }
   else
   top0+=15;//top0+=-10;
}else{
if(isview.equals("1")){
     top0+=10;
}
else
  top0+=15;
}
  

int left0 = 0 ; // 左边空间
int nodexsize = 60;
int nodeysize = 40;
String nownodeids=WFLinkInfo.getNowNodeids(requestid);

String bkcol = "";          // 节点方框颜色
int icount = 0;             // 节点计数
int curnodetype = 0;        // 节点状态  0: 已通过  1: 当前 2:其它

ArrayList operatednode = new ArrayList();               // 该工作流的所有已通过的节点
ArrayList operaternode = new ArrayList();               // 所有的非保存操作的操作者
ArrayList operaternode_ = new ArrayList();               // 所有的非保存操作的操作者 added by xwj on 2005-05-15 for td1838
ArrayList viewernode = new ArrayList();                 // 当前节点所有已查看者
ArrayList canoperaternode = new ArrayList();            // 当前节点的所有未操作者

temptopsize = Util.getIntValue(request.getParameter("wfd"),0) ;

if(temptopsize ==1){
    top0 = 40;
    left0 = 10;
}

/*
logtype :
1: 保存
2: 提交
3: 退回
4: 重新打开
5: 删除
6: 激活
9: 转发
*/

// 该工作流的所有已通过的节点 logtype = 2
sql = "select distinct nodeid from workflow_requestLog where (logtype='2' or logtype='0' or logtype='i') and requestid = "+requestid;
rs.executeSql(sql);
while(rs.next())
{
    String nodeid1 = Util.null2String(rs.getString("nodeid"));
    operatednode.add(nodeid1);
}

/*--xwj for td2104 on 20050802 begin--*/
// 当前节点的所有未操作者
//modify by xhheng @20050520 for TD 1725
//modify by xhheng @20050329 for TD 1729
//sql = "select distinct nodeid,userid,usertype, agentorbyagentid, agenttype, showorder from workflow_currentoperator where isremark in ('0','1','4','8','9','7') and requestid = " + requestid + " and nodeid in(" + nownodeids + ") order by showorder asc";
sql = "select distinct nodeid,userid,usertype, agentorbyagentid, agenttype, showorder from workflow_currentoperator where (isremark in ('0','1','4','8','9','7') or lastisremark in ('0','1','4','8','9','7')) and requestid = " + requestid + " and nodeid in(" + nownodeids + ") order by showorder asc";
rs.executeSql(sql);
while(rs.next())
{

  String tnodeid=Util.null2String(rs.getString("nodeid"));
  String operator = Util.null2String(rs.getString("userid"));
    String operatortype = Util.null2String(rs.getString("usertype"));
    String agentorbyagentid = Util.null2String(rs.getString("agentorbyagentid"));
    String agenttype = Util.null2String(rs.getString("agenttype"));
    if(!canoperaternode.contains(tnodeid+"_"+operator+"_"+operatortype+"&"+agentorbyagentid+"@"+agenttype)){
    canoperaternode.add(tnodeid+"_"+operator+"_"+operatortype+"&"+agentorbyagentid+"@"+agenttype);
  }

}
/*--xwj for td2104 on 20050802 END--*/


/*--xwj for td2104 on 20050802 begin--*/
// 所有的非保存操作的操作者
sql = "select distinct nodeid,operator,operatortype, agentorbyagentid, agenttype,showorder from workflow_requestLog where requestid = "+requestid + " and logtype not in('1','s') order by showorder asc" ;
rs.executeSql(sql);
while(rs.next())
{

String nodeid1 = Util.null2String(rs.getString("nodeid"));
    String operator = Util.null2String(rs.getString("operator"));
    String operatortype = Util.null2String(rs.getString("operatortype"));
    String agentorbyagentid = Util.null2String(rs.getString("agentorbyagentid"));
    String agenttype = Util.null2String(rs.getString("agenttype"));
    if(!operaternode.contains(nodeid1+"_"+operator+"_"+operatortype + "&" + agentorbyagentid + "@" + agenttype)){
    //加入所有历史操作人
    operaternode.add(nodeid1+"_"+operator+"_"+operatortype + "&" + agentorbyagentid + "@" + agenttype);
    }

    //operaternode_.add(operator); //added by xwj for td1838 on 2005-05-15
}



/* -----   xwj for td2104 on 20050802   begin---*/

// ----------- Modefied by xwj on 2005-05-15 for td1838   B E G I N  --------------------

// 当前节点所有已查看者

sql = "select distinct nodeid,operator,operatortype, agentorbyagentid, agenttype,showorder from workflow_requestLog where requestid = "+requestid + " and logtype not in('1','s') and nodeid = " + currentnodeid + " order by showorder asc";
rs.executeSql(sql);
while(rs.next()){
operaternode_.add(Util.null2String(rs.getString("operator")));
}


sql = "select distinct viewer,viewtype,showorder from workflow_requestViewLog where id = "+ requestid + " and currentnodeid = "+currentnodeid + " and ordertype = 1 order by showorder asc";
rs.executeSql(sql);
while(rs.next())
{
    String operator = Util.null2String(rs.getString("viewer"));
    String operatortype = Util.null2String(rs.getString("viewtype"));
    //rs1.executeSql("select nodeid,agentorbyagentid,agenttype from workflow_currentoperator a ,workflow_groupdetail b where a.groupdetailid=b.id and b.signorder=3 and a.isremark=2 and a.requestid="+requestid+" and a.userid="+operator);
    rs1.executeSql("select nodeid,agentorbyagentid,agenttype from workflow_currentoperator a ,workflow_groupdetail b where a.groupdetailid=b.id and b.signorder='3' and (a.isremark=2 or a.lastisremark=2) and a.requestid="+requestid+" and a.userid="+operator);
    if(rs1.next()){//抄送（不提交）查看后记录到已操作组中 MYQ修改
        if(!operaternode.contains(rs1.getString("nodeid")+"_"+operator+"_"+operatortype + "&" + rs1.getString("agentorbyagentid") + "@" + rs1.getString("agenttype"))){
            operaternode.add(rs1.getString("nodeid")+"_"+operator+"_"+operatortype + "&" + rs1.getString("agentorbyagentid") + "@" + rs1.getString("agenttype"));
        }
    }else{
    if(!operaternode_.contains(operator)){
     if(!viewernode.contains(operator+"_"+operatortype)){
     viewernode.add(operator+"_"+operatortype);
   }
  }
  }
}
sql = "select distinct viewer,viewtype,showorder from workflow_requestViewLog where id = "+ requestid + " and currentnodeid = "+currentnodeid + " and ordertype = 2 order by showorder asc";
rs.executeSql(sql);
while(rs.next())
{
    String operator = Util.null2String(rs.getString("viewer"));
    String operatortype = Util.null2String(rs.getString("viewtype"));
    //rs1.executeSql("select nodeid,agentorbyagentid,agenttype from workflow_currentoperator a ,workflow_groupdetail b where a.groupdetailid=b.id and b.signorder=3 and a.isremark=2 and a.requestid="+requestid+" and a.userid="+operator);
    rs1.executeSql("select nodeid,agentorbyagentid,agenttype from workflow_currentoperator a ,workflow_groupdetail b where a.groupdetailid=b.id and b.signorder=3 and (a.isremark=2 or a.lastisremark=2) and a.requestid="+requestid+" and a.userid="+operator);
    if(rs1.next()){//抄送（不提交）查看后记录到已操作组中 MYQ修改
        if(!operaternode.contains(rs1.getString("nodeid")+"_"+operator+"_"+operatortype + "&" + rs1.getString("agentorbyagentid") + "@" + rs1.getString("agenttype"))){
            operaternode.add(rs1.getString("nodeid")+"_"+operator+"_"+operatortype + "&" + rs1.getString("agentorbyagentid") + "@" + rs1.getString("agenttype"));
        }
    }else{
    if(!operaternode_.contains(operator)){
      if(!viewernode.contains(operator+"_"+operatortype)){
     viewernode.add(operator+"_"+operatortype);
  }
  }
  }
}


// ----------- Modefied by xwj on 2005-05-15 for td1838    E N D -------------------------

/*--xwj for td2104 on 20050802 END--*/




// 选出所有的该工作流的节点和坐标信息
sql = "SELECT nodeid , nodename , drawxpos, drawypos FROM workflow_flownode,workflow_nodebase WHERE (workflow_nodebase.IsFreeNode is null or workflow_nodebase.IsFreeNode !='1') and workflow_flownode.nodeid = workflow_nodebase.id and workflow_flownode.workflowid = "+workflowid+" union SELECT nodeid , nodename , drawxpos, drawypos FROM workflow_flownode,workflow_nodebase WHERE workflow_flownode.nodeid = workflow_nodebase.id and workflow_nodebase.IsFreeNode='1' and workflow_flownode.workflowid = "+workflowid+" and workflow_nodebase.requestid="+requestid;
rs.executeSql(sql);
    //System.out.println("sql = " + sql);
    //System.out.println("currentnodeid = " + currentnodeid);

while(rs.next()){
    icount ++;
    String tnownodeid=Util.null2String(rs.getString("nodeid"));
    if((","+nownodeids+",").indexOf(","+tnownodeid+",")>-1){     // 当前节点
        if(currentnodeid.equals(rs.getString("nodeid"))){
            curnodetype = 1;
            bkcol = "#ff0000";
        }else{
            curnodetype = 1;
            bkcol = "#005979";
        }
    }
    else if(operatednode.indexOf(tnownodeid)!=-1){  // 已经通过的节点
        curnodetype = 0;
        bkcol = "#0079A4";
    }
    else {
        bkcol = "#00BDFF";          // 其它节点
        curnodetype =2;
    }

    int drawxpos = rs.getInt("drawxpos");
    int drawypos = rs.getInt("drawypos");
    String nodename = Util.toScreen(rs.getString("nodename"),user.getLanguage());
%>

<style>
 *{
   font-family: "宋体" !important;
   font-size: 12px;
 }

</style>

<TABLE cellpadding=1 cellspacing=1 Class=ChartCompany STYLE="table-layout : fixed;POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=drawypos-nodeysize+top0 - 2%>;LEFT:<%=drawxpos-nodexsize+left0%>; height:<%=nodeysize*2 - 2%>!important;width:<%=nodexsize*2%>" LANGUAGE=javascript 
        onclick="return oc_CurrentMenuOnClick(<%=icount%>)" onMouseOut="if(isMouseLeaveOrEnter(event, this)) { oc_CurrentMenuOnMouseOut(<%=icount%>)}" >
    <tr height=15px>
    <TD VALIGN=TOP style="padding-left:2px;background-color:<%=bkcol%>;color:white;border:1px solid black">
    <B><%=nodename%></B></TD>
    </TR><TR>
    <%
        if((","+nownodeids+",").indexOf(","+Util.null2String(rs.getString("nodeid"))+",")>-1){
    %>
    <TD VALIGN=TOP align=left style="background-color:#F5F5F5;border:4px solid red;padding-left:2px; position:relative;">
    <%
        }else{
    %>
    <TD VALIGN=TOP align=left style="background-color:#F5F5F5;border:1px solid black;padding-left:2px;position:relative;">
    <%
        }
    %>
        <%if(curnodetype==0){%>
    <img src="/images/iconemp_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>">
        <%
            for(int i=0;i<operaternode.size();i++){

                String tmp = ""+operaternode.get(i);
                //System.out.println(tmp);
                if((tmp).startsWith(""+rs.getString("nodeid")+"_"))
                {
                     /* ----------    xwj for td2104 on 20050802   begin   ----------*/
                    String tmptype = tmp.substring(tmp.lastIndexOf("_")+1,tmp.indexOf("&"));
                    String tmpid = tmp.substring(tmp.indexOf("_")+1,tmp.lastIndexOf("_"));
                    String byagentid = tmp.substring(tmp.lastIndexOf("&")+1,tmp.indexOf("@"));
                    String agenttype = tmp.substring(tmp.indexOf("@")+1);
                    String tmpnodeid = tmp.substring(0,tmp.indexOf("_"));//added by xwj for td2891


                if(tmptype.equals("0")){
                  if("0".equals(agenttype) || "-".equals(agenttype)){%>
                           <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
                    <%}
                    /* --------- xwj for td2891 begin ----*/
                    else if("2".equals(agenttype)){

                     if(!creatorNodeId.equals(tmpnodeid)){
                    %>
                           <a href="javaScript:openhrm(<%=byagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(byagentid),user.getLanguage())%></A>
                           ->
                           <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>

                   <%}
                     else{

                           String agentCheckSql = " select * from workflow_agentConditionSet where workflowId="+ workflowid +" and bagentuid=" + byagentid +
                                                     " and agenttype = '1' " +
                                                     " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" +
                                                     " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
                                                     " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" +
                                                     " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" +
                                                     " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
                                                     " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null) order by agentbatch asc  ,id asc ";
                           RecordSetlog3.executeSql(agentCheckSql);
                           if(!RecordSetlog3.next()){%>
                           <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
                         <%}
                       else{
                             String isCreator = RecordSetlog3.getString("isCreateAgenter");
                          if(!isCreator.equals("1")){%>

                              <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
                            <%}
                              else{

                                 int userLevelUp = -1;
                                 int uesrLevelTo = -1;
                                 int secLevel = -1;
                                 rsCheckUserCreater.executeSql("select seclevel from HrmResource where id= " + tmpid);
                                 if(rsCheckUserCreater.next()){
                                 secLevel = rsCheckUserCreater.getInt("seclevel");
                                 }
                                 else{
                                 rsCheckUserCreater.executeSql("select seclevel from HrmResourceManager where id= " + tmpid);
                                 if(rsCheckUserCreater.next()){
                                 secLevel = rsCheckUserCreater.getInt("seclevel");
                                 }
                                 }
                               //是否有此流程的创建权限
                                 boolean haswfcreate = shareManager.hasWfCreatePermission(user, Integer.parseInt(workflowid));
                            
                                 if(byagentid ==null || byagentid ==""){
                                 %>
                                 <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></a>
                                 <%}
                                 else{%>
                                   <a href="javaScript:openhrm(<%=byagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(byagentid),user.getLanguage())%></a>
                                    ->
                                   <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></a>
                                 <%}

                               }
                          }

                       }

                  }
                  /* --------- xwj for td2891 end ----*/
                  else{
                  }
                }

                /* ----------  xwj for td2104 on 20050802   end     ----------*/

                    else if(tmptype.equals("1")){
    %>
    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
    <%
                    }else{
    %>
    <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
    <%
                    }
                    break;
                }
            }               //  end of for
    %>
    <div align=right style="position:absolute;bottom:2px;right:2px;">
    >>>
    </div>
    <%
        } else if(curnodetype==1){
    %>
    <img src="/images/imgPersonHead_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>">
    <%
      //modify by xhheng @20050206 for TD 1544
    if(requestid != -1) {
            for(int i=0;i<canoperaternode.size();i++){

                String tmp = ""+canoperaternode.get(i);
                int tempindx=tmp.indexOf("_");
                if(tempindx>-1){
                String tmpnodeid=tmp.substring(0,tempindx);
                if(!tnownodeid.equals(tmpnodeid)) continue;
                tmp=tmp.substring(tempindx+1);
                String tmptype = tmp.substring(tmp.lastIndexOf("_")+1,tmp.indexOf("&"));//xwj for td2104 on 20050802
                String tmpid = tmp.substring(0,tmp.indexOf("_"));
                String byagentid = tmp.substring(tmp.lastIndexOf("&")+1,tmp.indexOf("@"));//xwj for td2104 on 20050802
                String agenttype = tmp.substring(tmp.indexOf("@")+1);//xwj for td2104 on 20050802

                /* ---------- xwj for td2104 on 20050802 begin----------*/
                if(tmptype.equals("0")){
                  if("0".equals(agenttype) || "-".equals(agenttype)){%>
                           <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
                    <%}
                    else if("2".equals(agenttype)){%>
                           <a href="javaScript:openhrm(<%=byagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(byagentid),user.getLanguage())%></A>
                           ->
                           <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
                  <%}
                  else{
                  }
                }

                /* ---------- xwj for td2104 on 20050802 end----------*/

                else if(tmptype.equals("1")){
    %>
    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
    <%
                } else {
    %>
    <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
    <%
                }
                break;
            }
        }// end of for
    }else{
      //requestid==-1 ,直接显示当前操作者
                if(logintype.equals("1")){
    %>
    <a href="javaScript:openhrm(<%=userid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(userid),user.getLanguage())%></A>
    <%
                } else if(logintype.equals("2")){
    %>
    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=userid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(userid),user.getLanguage())%></a>
    <%
                }
    }
    %>
    <div align=right style="position:absolute;bottom:2px;right:2px;">
    >>>
    </div>
    <%
        }else if(curnodetype==2){
    %>
    <img src="/images/imgPersonHead_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>">
    <%
            sql = " select id , groupname from workflow_nodegroup where nodeid = " + rs.getString("nodeid");
            rs1.executeSql(sql);
            if(rs1.next()){
    %>
    <a href="/workflow/workflow/editoperatorgroup.jsp?isview=1&formid=<%=formid%>&isbill=<%=isbill%>&id=<%=rs1.getString("id")%>"><%=Util.toScreen(rs1.getString("groupname"),user.getLanguage())%></a>
    <%
            }
    %>
    
    <div align=right style="position:absolute;bottom:2px;right:2px;">
    >>>
    </div>
    <%
        }
    %>

    </TD></TR></TABLE>

    <DIV id="oc_divMenuDivision<%=icount%>" name="oc_divMenuDivision<%=icount%>"
    style="visibility:hidden; LEFT:<%=drawxpos%>; POSITION:absolute; TOP:<%=drawypos+top0%>; WIDTH:240px; Z-INDEX: 200">
    <TABLE cellpadding=2 cellspacing=0 class="MenuPopUp"  LANGUAGE=javascript
        onMouseOut="return oc_CurrentMenuOnMouseOut(<%=icount%>)" onMouseOver="return oc_CurrentMenuOnClick(<%=icount%>)" style="HEIGHT: 79px; WIDTH: 246px;background-color:#4A96EB">
    <%
         if(curnodetype==0){
    %>
     <TR id=D3><TD class=MenuPopup><img src="/images/iconemp_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>">
    <%
            for(int i=0;i<operaternode.size();i++){
                String tmp = ""+operaternode.get(i);
                if((tmp).startsWith(""+rs.getString("nodeid")+"_"))
                {
                    String tmptype = tmp.substring(tmp.lastIndexOf("_")+1,tmp.indexOf("&"));
                    String tmpid = tmp.substring(tmp.indexOf("_")+1,tmp.lastIndexOf("_"));
              String byagentid = tmp.substring(tmp.lastIndexOf("&")+1,tmp.indexOf("@"));//xwj for td2104 on 20050802
                String agenttype = tmp.substring(tmp.indexOf("@")+1);//xwj for td2104 on 20050802
                String tmpnodeid = tmp.substring(0,tmp.indexOf("_"));//added by xwj for td2891

                /* ---------- xwj for td2104 on 20050802 begin----------*/
                if(tmptype.equals("0")){
                  if("0".equals(agenttype) || "-".equals(agenttype)){%>
                           <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
                    <%}

                    /* --------- xwj for td2891 begin ----*/
                    else if("2".equals(agenttype)){

                     if(!creatorNodeId.equals(tmpnodeid)){
                    %>
                           <a href="javaScript:openhrm(<%=byagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(byagentid),user.getLanguage())%></A>
                           ->
                           <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>

                   <%}
                     else{

                           String agentCheckSql = " select * from workflow_Agent where workflowId="+ workflowid +" and beagenterId=" + byagentid +
                                                     " and agenttype = '1' " +
                                                     " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" +
                                                     " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
                                                     " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" +
                                                     " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" +
                                                     " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
                                                     " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null)";
                           RecordSetlog3.executeSql(agentCheckSql);
                           if(!RecordSetlog3.next()){%>
                           <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
                         <%}
                       else{
                             String isCreator = RecordSetlog3.getString("isCreateAgenter");
                          if(!isCreator.equals("1")){%>

                              <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
                            <%}
                              else{

                                 int userLevelUp = -1;
                                 int uesrLevelTo = -1;
                                 int secLevel = -1;
                                 rsCheckUserCreater.executeSql("select seclevel from HrmResource where id= " + tmpid);
                                 if(rsCheckUserCreater.next()){
                                 secLevel = rsCheckUserCreater.getInt("seclevel");
                                 }
                                 else{
                                 rsCheckUserCreater.executeSql("select seclevel from HrmResourceManager where id= " + tmpid);
                                 if(rsCheckUserCreater.next()){
                                 secLevel = rsCheckUserCreater.getInt("seclevel");
                                 }
                                 }
                               //是否有此流程的创建权限
                                 boolean haswfcreate = shareManager.hasWfCreatePermission(user, Integer.parseInt(workflowid));
                                 if(byagentid=="" || byagentid==null){
                                 %>
                                 <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></a>
                                 <%}
                                 else{%>
                                   <a href="javaScript:openhrm(<%=byagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(byagentid),user.getLanguage())%></a>
                                    ->
                                   <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></a>
                                 <%}

                               }
                          }

                       }

                  }
                  /* --------- xwj for td2891 end ----*/

                  else{
                  }
                }

                /* ---------- xwj for td2104 on 20050802 end----------*/

                    else if(tmptype.equals("1")){
    %>
    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
    <%
                    } else{
    %>
    <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
    <%
                    }
    %>
    &nbsp
    <%
                }
            }               // end of for
    %>
    &nbsp
    </TD></TR>
    <%
      //modify by xhheng @20050106 for TD 1544
        } else if(curnodetype==1 && requestid != -1){
    %>
    <TR id=D1><TD class=MenuPopup><img src="/images/imgPersonHead_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>">
    <%
            for(int i=0;i<canoperaternode.size();i++){
                String tmp = ""+canoperaternode.get(i);
                int tempindx=tmp.indexOf("_");
                if(tempindx>-1){
                String tmpnodeid=tmp.substring(0,tempindx);
                if(!tnownodeid.equals(tmpnodeid)) continue;
                tmp=tmp.substring(tempindx+1);
                String tmptype = tmp.substring(tmp.lastIndexOf("_")+1,tmp.indexOf("&"));//xwj for td2104 on 20050802
                String tmpid = tmp.substring(0,tmp.indexOf("_"));
                String byagentid = tmp.substring(tmp.lastIndexOf("&")+1,tmp.indexOf("@"));//xwj for td2104 on 20050802
                String agenttype = tmp.substring(tmp.indexOf("@")+1);//xwj for td2104 on 20050802

                /* ---------- xwj for td2104 on 20050802 begin----------*/
                if(tmptype.equals("0")){
                  if("0".equals(agenttype) || "-".equals(agenttype)){%>
                           <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
                    <%}
                    else if("2".equals(agenttype)){%>
                           <a href="javaScript:openhrm(<%=byagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(byagentid),user.getLanguage())%></A>
                           ->
                           <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
                  <%}
                  else{
                  }
                }
                /* ---------- xwj for td2104 on 20050802 end----------*/


                else if(tmptype.equals("1")){
    %>
    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
    <%
                } else{
    %>
    <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
    <%
                }
    %>
    &nbsp
    <%
            }
        }// end of for
    %>
    &nbsp
    </TD></TR>
    <TR id=D2><TD class=MenuPopup><img src="/images/icon_resource_flat_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16355,user.getLanguage())%>">
    <%
        if(tnownodeid.equals(currentnodeid)){
        for(int i=0;i<viewernode.size();i++){
            String tmp = ""+viewernode.get(i);
            String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
            String tmpid = tmp.substring(0,tmp.indexOf("_"));
            if(tmptype.equals("0")){
    %>
    <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
    <%
            } else if(tmptype.equals("1")){
    %>
    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
    <%
            } else{
    %>
    <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
    <%
            }
    %>
    &nbsp
    <%
        }           // end of for
        }
    %>
    &nbsp
    </TD></TR>
    <TR id=D3><TD class=MenuPopup><img src="/images/iconemp_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>">
    <%
        for(int i=0;i<operaternode.size();i++){
            String tmp = ""+operaternode.get(i);
            if((tmp).startsWith(""+rs.getString("nodeid")+"_"))
            {
                String tmptype = tmp.substring(tmp.lastIndexOf("_")+1,tmp.indexOf("&"));
                String tmpid = tmp.substring(tmp.indexOf("_")+1,tmp.lastIndexOf("_"));
                  String byagentid = tmp.substring(tmp.lastIndexOf("&")+1,tmp.indexOf("@"));//xwj for td2104 on 20050802
                String agenttype = tmp.substring(tmp.indexOf("@")+1);//xwj for td2104 on 20050802
                String tmpnodeid = tmp.substring(0,tmp.indexOf("_"));//added by xwj for td2891

                /* ---------- xwj for td2104 on 20050802 begin----------*/
                if(tmptype.equals("0")){
                  if("0".equals(agenttype) || "-".equals(agenttype)){%>
                           <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
                    <%}

                       /* --------- xwj for td2891 begin ----*/
                    else if("2".equals(agenttype)){

                     if(!creatorNodeId.equals(tmpnodeid)){
                    %>
                           <a href="javaScript:openhrm(<%=byagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(byagentid),user.getLanguage())%></A>
                           ->
                           <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>

                   <%}
                     else{

                           String agentCheckSql = " select * from workflow_Agent where workflowId="+ workflowid +" and beagenterId=" + byagentid +
                                                     " and agenttype = '1' " +
                                                     " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" +
                                                     " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
                                                     " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" +
                                                     " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" +
                                                     " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
                                                     " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null)";
                           RecordSetlog3.executeSql(agentCheckSql);
                           if(!RecordSetlog3.next()){%>
                           <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
                         <%}
                       else{
                             String isCreator = RecordSetlog3.getString("isCreateAgenter");
                          if(!isCreator.equals("1")){%>

                              <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
                            <%}
                              else{

                                 int userLevelUp = -1;
                                 int uesrLevelTo = -1;
                                 int secLevel = -1;
                                 rsCheckUserCreater.executeSql("select seclevel from HrmResource where id= " + tmpid);
                                 if(rsCheckUserCreater.next()){
                                 secLevel = rsCheckUserCreater.getInt("seclevel");
                                 }
                                 else{
                                 rsCheckUserCreater.executeSql("select seclevel from HrmResourceManager where id= " + tmpid);
                                 if(rsCheckUserCreater.next()){
                                 secLevel = rsCheckUserCreater.getInt("seclevel");
                                 }
                                 }
                                 //是否有此流程的创建权限
                                 boolean haswfcreate = shareManager.hasWfCreatePermission(user, Integer.parseInt(workflowid));
                                 if(byagentid==null || byagentid==""){
                                 %>
                                 <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></a>
                                 <%}
                                 else{%>
                                   <a href="javaScript:openhrm(<%=byagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(byagentid),user.getLanguage())%></a>
                                    ->
                                   <a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></a>
                                 <%}

                               }
                          }

                       }

                  }
                  /* --------- xwj for td2891 end ----*/

                  else{
                  }
                }

                /* ---------- xwj for td2104 on 20050802 end----------*/
                else if(tmptype.equals("1")){
    %>
    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
    <%
                } else{
    %>
    <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
    <%
                }
    %>
    &nbsp
    <%
            }
        }           //  end of for
    %>
    &nbsp
    </TD></TR>
    <%
      //add by xhheng @20050106 for TD 1544，将新建流程时的创建节点作特殊处理
        } else if(curnodetype==1 && requestid != -1){
      %>
         <TR id=D4><TD class=MenuPopup><img src="/images/iconemp_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>">
      <%
      //requestid==-1 ,直接显示当前操作者
                if(logintype.equals("1")){
    %>
    <a href="javaScript:openhrm(<%=userid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(userid),user.getLanguage())%></A>
    <%
                } else if(logintype.equals("2")){
    %>
    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=userid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(userid),user.getLanguage())%></a>
    &nbsp
    <%
            }
    %>
    </TD></TR>
    <%
        }else if(curnodetype==2){
    %>
    <TR id=D1><TD class=MenuPopup><img src="/images/imgPersonHead_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>">
    <%
            sql = " select id, groupname from workflow_nodegroup where nodeid = " + rs.getString("nodeid");
            rs1.executeSql(sql);
            while(rs1.next()){
    %>
    <a href="/workflow/workflow/editoperatorgroup.jsp?isview=1&formid=<%=formid%>&isbill=<%=isbill%>&id=<%=rs1.getString("id")%>"><%=Util.toScreen(rs1.getString("groupname"),user.getLanguage())%></a>
    &nbsp
    <%
            }
    %>
    </TD></TR>
    <%
        }
    %>
</TABLE>
</DIV>

<%
}       // end of the max while
%>

<p></p>
</TD></TR></TABLE>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
<script type="text/javascript">
if(window.parent.document.getElementById("divWfPic")) {
    //jQuery("#divWfPic", window.parent.document).html(jQuery("#InnerIMAGETD").html());
}

function oc_CurrentMenuOnMouseOut(icount) {
    document.all("oc_divMenuDivision" + icount).style.visibility = "hidden"
}

function oc_CurrentMenuOnClick(icount) {
    document.all("oc_divMenuDivision" + icount).style.visibility = ""
}

</script>