
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import = "weaver.general.TimeUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.workflow.monitor.Monitor"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(user == null)  return ;

FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid2=user.getUID();   
String requestid = Util.getIntValue(request.getParameter("requestid")) + "" ;
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

String disnodeid = Util.null2String(request.getParameter("disnodeid")) ;
String disresource = Util.null2String(request.getParameter("disresource")) ;
//0: 未查看， 1：未提交， 2：已提交, 3:已查看


String disremark = Util.null2String(request.getParameter("disremark")) ;

%>


<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type="text/javascript">




document.oncontextmenu = Function("return false;");
function  readCookie(name){  
   var  cookieValue  =  "7";  
   var  search  =  name  +  "=";
   try{
       if(document.cookie.length  >  0) {    
           offset  =  document.cookie.indexOf(search);  
           if  (offset  !=  -1)  
           {    
               offset  +=  search.length;  
               end  =  document.cookie.indexOf(";",  offset);  
               if  (end  ==  -1)  end  =  document.cookie.length;  
               cookieValue  =  unescape(document.cookie.substring(offset,  end))  
           }  
       }  
   }catch(exception){
   }
   return  cookieValue;  
} 
</script>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
<TABLE border=0 cellpadding=0 cellspacing=0  width="100%"><TR><TD ID='IMAGETD'>


<%

String sqlWhere = "";
String orderby ="";
String backfields = "";
String fromSql  = "";

rs1.execute(getExecutesql(userid, workflowid, requestid, desrequestid, isurger, 1, disremark, disresource, disnodeid));

Map<String, String> tempmap = new HashMap<String, String>();
while (rs1.next()) {
    tempmap.put(rs1.getString("userid"), rs1.getString("userid"));   
}

rs1.execute(getExecutesql(userid, workflowid, requestid, desrequestid, isurger, 2, disremark, disresource, disnodeid));

Map<String, String> tempmap2 = new HashMap<String, String>();

while (rs1.next()) {
    tempmap2.put(rs1.getString("nodeid") + "_" + rs1.getString("userid"), rs1.getString("operator"));   
}

rs.execute(getExecutesql(userid, workflowid, requestid, desrequestid, isurger, 0, disremark, disresource, disnodeid));

%>

<head>

<script>

jQuery(function () {
    jQuery(".ListStyle tr").hover(function(){
        jQuery(this).addClass("Selected");
    },function(){
        jQuery(this).removeClass("Selected");
        //jQuery(this).hide();
    });
    parent.__hidloaddingblock();
});

</script>

</head>
<bdoy>


<table class=ListStyle cellspacing=1>
    <COLGROUP>
    <col width="60px">
    <COL width="17%">
    <COL width="17%">
    <COL width="17%">
    <COL width="17%">
    <COL width="17%">
    <COL width="*">
    <tr class=header>
        <td></td>
        <td><b><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></b></td>
        <td><b><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></b></td>
        <td><b><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></b></td>
        <td><b><%=SystemEnv.getHtmlLabelName(18002,user.getLanguage())%></b></td>
        <td><b><%=SystemEnv.getHtmlLabelName(18008,user.getLanguage())%></b></td>
        <td><b><%=SystemEnv.getHtmlLabelName(18003,user.getLanguage())%></b></td>
    </tr>

    <%
    int tmpnodeid_old=-1;
    boolean islight=false;
    int rccnt = rs.getCounts();
    while(rs.next()){
        int     tmpnodeid=rs.getInt("nodeid");
        String  tmpnodename=rs.getString("nodename");
        String  tmpuserid=rs.getString("userid");
        //int     tmpisremark=rs.getInt("isremark");
        String  tmpisremark = Util.null2String(rs.getString("isremark"));
        if(tmpisremark.equals(""))
        {
            tmpisremark = Util.null2String(rs.getString("lastisremark"));
        }
        int     tmpusertype=rs.getInt("usertype");
        String  tmpagentorbyagentid=rs.getString("agentorbyagentid");
        int     tmpagenttype=rs.getInt("agenttype");
        String  tmpreceivedate=rs.getString("receivedate");
        String  tmpreceivetime=rs.getString("receivetime");
        String  tmpoperatedate=rs.getString("operatedate");
        String  tmpoperatetime=rs.getString("operatetime");
        String  viewtype=rs.getString("viewtype");
        boolean flags=false;
        String  tmpIntervel="";
        
        
        //如果tmpisremark=2 判断时候在日志表里有该人（确定是否是由非会签得到的isremark=2）


        //String sql = "select operator from workflow_requestlog where requestid="+requestid+" and logtype <> '1' and nodeid="+tmpnodeid+" and operator="+tmpuserid;
        //rs1.execute(sql);
        
        //if (rs1.next()) flags=true;
        String tempobj2 = tempmap2.get(tmpnodeid + "_" + tmpuserid);
        if (tempobj2 != null && !"".equals(tempobj2)) {
            flags=true;
        }
        
        //抄送（不需提交）查看后计算操作耗时 MYQ修改 开始


        boolean submitflg = false;
        boolean nosubmitflg = false;
        boolean viewflg = false;
        boolean noviewflg = false;
        
        if (tmpisremark.equals("2") && flags) {
            submitflg = true;
        } else if (tmpisremark.equals("0") || tmpisremark.equals("1") || tmpisremark.equals("5") || tmpisremark.equals("4") || tmpisremark.equals("8") || tmpisremark.equals("9") || tmpisremark.equals("7") || (tmpisremark.equals("2") && !flags)) {
            if (viewtype.equals("-2") || (viewtype.equals("-1") && !tmpoperatedate.equals(""))) {
                viewflg = true;
            } else if (viewtype.equals("0")) {
                noviewflg = true;
            }
        } else if (tmpisremark.equals("s")) {
        } else if (tmpisremark.equals("c")) {
        } else if (tmpisremark.equals("r")) {
        }
        
        if ((!tmpisremark.equals("2")&&!tmpisremark.equals("4"))||(tmpisremark.equals("4")&&viewtype.equals("0"))) {
            if (!tmpisremark.equals("s") && !tmpisremark.equals("s") && !tmpisremark.equals("c") && !tmpisremark.equals("r")) {
                nosubmitflg = true;
            }
        }
        //System.out.println("======disremark=" + disremark + ", submitflg=" + submitflg  + ","+ "nosubmitflg=" + nosubmitflg + "," + "viewflg=" + viewflg + "," + "noviewflg=" + noviewflg + ",");
      //0: 未查看， 1：未提交， 2：已提交, 3:已查看


        if ("0".equals(disremark)) {
            if (!noviewflg) {
                continue;
            }
        } else if ("1".equals(disremark)) {
            if (!nosubmitflg) {
                continue;
            }
        } else if ("2".equals(disremark)) {
            if (!submitflg) {
                continue;
            }
        } else if ("3".equals(disremark)) {
            if (!viewflg) {
                continue;
            }
        }
        
        String tempobj = tempmap.get(tmpuserid);
        
        //抄送（不需提交）查看后计算操作耗时 MYQ修改 开始


        /*
        if ("sqlserver".equals((rs1.getDBType()))) {
            rs1.executeSql("select * from workflow_currentoperator a ,workflow_groupdetail b where a.groupdetailid=b.id and b.signorder=3 and a.requestid="+requestid+" and a.userid="+tmpuserid);          
        } else {
            rs1.executeSql("select * from workflow_currentoperator a ,workflow_groupdetail b where a.groupdetailid=b.id and b.signorder='3' and a.requestid="+requestid+" and a.userid="+tmpuserid);
        }
        */
        if(tempobj!=null &&tmpisremark.equals("2")&&tmpoperatedate!=null && !tmpoperatedate.equals("")){
            tmpIntervel=TimeUtil.timeInterval2(tmpreceivedate+" "+tmpreceivetime,tmpoperatedate+" "+tmpoperatetime,user.getLanguage());
        }
       {
        if(tmpisremark.equals("2") &&flags&& tmpoperatedate!=null && !tmpoperatedate.equals("")){
            tmpIntervel=TimeUtil.timeInterval2(tmpreceivedate+" "+tmpreceivetime,tmpoperatedate+" "+tmpoperatetime,user.getLanguage());
        }
    islight=!islight;
    

    if (!islight)
    {%>
    <tr class="">
    <%} else {%>
    <tr class="">
    <% }%>
        <TD>
        </TD>

        <TD>
            <%if(tmpusertype == 0){%>
                <%if(tmpagenttype!=2){%>
                    <A href="javaScript:openhrm(<%=tmpuserid%>);" onclick='pointerXY(event);'>
                        <%=Util.toScreen(ResourceComInfo.getResourcename(tmpuserid),user.getLanguage())%>
                    </A>
                <%}else{%>
                    <A href="javaScript:openhrm(<%=tmpagentorbyagentid%>);" onclick='pointerXY(event);'>
                        <%=Util.toScreen(ResourceComInfo.getResourcename(tmpagentorbyagentid),user.getLanguage())%>
                    </A>->
                    <A href="javaScript:openhrm(<%=tmpuserid%>);" onclick='pointerXY(event);'>
                        <%=Util.toScreen(ResourceComInfo.getResourcename(tmpuserid),user.getLanguage())%>
                    </A>
                <%}%>
            <%}else{%>
             <A  href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpuserid%>">
               <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpuserid),user.getLanguage())%>
            </A>
            <%}%>
        </TD>
        
        <td>
        <%=Util.toScreen(tmpnodename,user.getLanguage())%>
        </td>
        
        
        <TD>
        
        <%
       
        if(tmpisremark.equals("2")&&flags){%>
            <%=SystemEnv.getHtmlLabelName(15176,user.getLanguage())%>
        <%}else if(tmpisremark.equals("0")||tmpisremark.equals("1")||tmpisremark.equals("5")||tmpisremark.equals("4")||tmpisremark.equals("8")||tmpisremark.equals("9")||tmpisremark.equals("7")||(tmpisremark.equals("2")&&!flags)){%>
            <%if(viewtype.equals("-2") || (viewtype.equals("-1") && !tmpoperatedate.equals(""))){%>
                <FONT COLOR="#FF33CC"><%=SystemEnv.getHtmlLabelName(18006,user.getLanguage())%></FONT>
            <%}else{%>
                <FONT COLOR="#FF0000"><%=SystemEnv.getHtmlLabelName(18007,user.getLanguage())%></FONT>
            <%}%>
        <%}else if(tmpisremark.equals("s")){%>
            <%=SystemEnv.getHtmlLabelName(20387,user.getLanguage())%>
         <%}else if(tmpisremark.equals("c")){%>
            <%=SystemEnv.getHtmlLabelName(16210,user.getLanguage())%>
        <%}else if(tmpisremark.equals("r")){%>
            <%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%>
        <%} %>
        </TD>

        <TD>
            <%if(!tmpisremark.equals("s")&&!tmpisremark.equals("c")&&!tmpisremark.equals("r")){ %>
            <%=Util.toScreen(tmpreceivedate,user.getLanguage())%>&nbsp;<%=Util.toScreen(tmpreceivetime,user.getLanguage())%>&nbsp;&nbsp;&nbsp;
            <%} %>
        </TD>

        <TD>
            <%=Util.toScreen(tmpoperatedate,user.getLanguage())%>&nbsp;<%=Util.toScreen(tmpoperatetime,user.getLanguage())%>&nbsp;&nbsp;&nbsp;
        </TD>



        <TD>
            <%=Util.toScreen(tmpIntervel,user.getLanguage())%>
        </TD>
    </TR>
    <tr class="Spacing" style="height:1px!important;"><td colspan="10" class="paddingLeft0Table"><div class="intervalDivClass"></div></td></tr>

    <% }    }   %>
</table>
<p></p>
</TD></TR></TABLE>
<%
if (rccnt == 0) {
        %>
        <div style="text-align:center;width:100%;">
            <%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%>
        </div>
        <%
    }
%>
<body>
    
    
<%!

private String getExecutesql(String userid, String workflowid, String requestid, int desrequestid, String isurger, int istype, String disremark, String disresource, String disnodeid) {
    RecordSet rs = new RecordSet();
    RecordSet rs1 = new RecordSet();
    
    StringBuffer sqlsb = new StringBuffer();
    Monitor monitor = new Monitor();

    if (isurger.equals("true") || monitor.hasMonitor(requestid,userid)) {
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
        
        if (istype == 2) {
            sqlsb.append("             ,a.operator ");
        }
        
        sqlsb.append("        from (SELECT distinct o.requestid, ");
        sqlsb.append("                              o.userid, ");
        sqlsb.append("                              o.workflowid, ");
        sqlsb.append("                              o.workflowtype, ");
        sqlsb.append("                              o.isremark, ");
        sqlsb.append("                              o.lastisremark, ");
        sqlsb.append("                              o.usertype, ");
        sqlsb.append("                              o.nodeid, ");
        sqlsb.append("                              o.agentorbyagentid, ");
        sqlsb.append("                              o.agenttype, ");
        sqlsb.append("                              o.receivedate, ");
        sqlsb.append("                              o.receivetime, ");
        sqlsb.append("                              o.viewtype, ");
        sqlsb.append("                              o.iscomplete, ");
        sqlsb.append("                              o.operatedate, ");
        sqlsb.append("                              o.operatetime, ");
        sqlsb.append("                              nodetype ");
        
        if (istype == 2) {
            sqlsb.append("                              ,wr.operator ");
        }
        
        sqlsb.append("                FROM workflow_currentoperator o ");
        
        sqlsb.append("                left join workflow_requestlog wr");
        sqlsb.append("                on wr.requestid=o.requestid");
        sqlsb.append("                and wr.nodeid=o.nodeid");
        sqlsb.append("                and wr.operator = o.userid");
        sqlsb.append("                and wr.logtype <> '1'");
        
        if (istype == 1) {
            sqlsb.append("                inner join workflow_groupdetail wg ");
            sqlsb.append("                on o.groupdetailid=wg.id and wg.signorder='3' ");
        }
        
        sqlsb.append("                , workflow_flownode ");
        
        
        
        sqlsb.append("               where o.nodeid = ");
        sqlsb.append("                     workflow_flownode.nodeid ");


        if (!"".equals(disnodeid)) {
            sqlsb.append("                 and o.nodeid='" + disnodeid + "' ");
        }
        
        if (!"".equals(disresource)) {
            sqlsb.append("                 and o.userid ='" + disresource + "' ");
        }
        
        if (!"".equals(disremark)) {
            if ("2".equals(disremark)) {
                sqlsb.append("                 and o.isremark ='2' ");
                sqlsb.append("                 AND wr.requestid=" + requestid);
            }
            
            if ("0".equals(disremark)) {
                sqlsb.append("                 and o.viewtype='0' ");
            }
            if ("1".equals(disremark)) {
                sqlsb.append("                 and (o.isremark not in ('2','4') ");
                sqlsb.append("                  or (o.isremark='4' and o.viewtype='0')) ");
            }
            
            if ("3".equals(disremark)) {
                sqlsb.append("                 and (o.isremark in ('0', '1', '4', '5', '7', '8', '9') or (o.isremark='2' and (wr.operator is null or wr.operator='')))");
                sqlsb.append("                 and (o.viewtype='-2' or (o.viewtype='-1' ))");
            }
        }


        sqlsb.append("                 and o.requestid = " + requestid + ") a, ");
        sqlsb.append("             workflow_nodebase b ");
        sqlsb.append("       where a.nodeid = b.id ");
        sqlsb.append("         and a.requestid = " + requestid + " ");
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
        
        if (istype == 2) {
            sqlsb.append("             ,a.operator ");
        }
        
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
        
        if (istype == 2) {
            sqlsb.append("                              ,wr.operator ");
        }
        
        sqlsb.append("                FROM workflow_otheroperator o");
        
        sqlsb.append("                left join workflow_requestlog wr");
        sqlsb.append("                on wr.requestid=o.requestid");
        sqlsb.append("                and wr.nodeid=o.nodeid");
        sqlsb.append("                and wr.operator = o.userid");
        sqlsb.append("                and wr.logtype <> '1'");
        
        
        sqlsb.append("                , workflow_flownode n");
        
        sqlsb.append("               where o.nodeid = n.nodeid ");

        if (!"".equals(disnodeid)) {
            sqlsb.append("                 and o.nodeid ='" + disnodeid + "' ");
        }
        
        if (!"".equals(disresource)) {
            sqlsb.append("                 and o.userid ='" + disresource + "' ");
        }
        
        if (!"".equals(disremark)) {
            if ("2".equals(disremark)) {
            sqlsb.append("                 and o.isremark ='2' ");
            sqlsb.append("                 AND wr.requestid=o.requestid");
            sqlsb.append("                 AND wr.nodeid=o.nodeid");
            sqlsb.append("                 AND wr.operator = o.userid");
            sqlsb.append("                 AND wr.logtype <> '1'");
            }
            if ("0".equals(disremark)) {
                sqlsb.append("                 and o.viewtype='0' ");
            }
            if ("1".equals(disremark)) {
                sqlsb.append("                 and o.isremark <> '2' ");
            }
            
            if ("3".equals(disremark)) {
                sqlsb.append("                 and (o.isremark in ('0', '1', '4', '5', '7', '8', '9') or (o.isremark='2' and (wr.operator is null or wr.operator='')))");
                sqlsb.append("                 and (o.viewtype='-2' or (o.viewtype='-1'))");
            }
        }

        sqlsb.append("                 and o.requestid = " + requestid + ") a, ");
        sqlsb.append("             workflow_nodebase b ");
        sqlsb.append("       where a.nodeid = b.id ");
        if (istype == 1) {
            sqlsb.append("     and 1<>1 ");
        }
        sqlsb.append("         and a.requestid = " + requestid + ") a ");
        sqlsb.append(" order by a.receivedate, a.receivetime, a.nodetype");

        //System.out.println(sqlsb.toString());

    } else {
        String viewLogIds = "";
        ArrayList canViewIds = new ArrayList();
        String viewNodeId = "-1";
        String tempNodeId = "-1";
        String singleViewLogIds = "-1";
        rs.executeSql("select distinct nodeid from workflow_currentoperator where requestid=" + requestid + " and userid=" + userid);

        while (rs.next()) {
            viewNodeId = rs.getString("nodeid");
            rs1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + viewNodeId);
            if (rs1.next()) {
                singleViewLogIds = rs1.getString("viewnodeids");
            }

            if ("-1".equals(singleViewLogIds)) {//全部查看
                rs1.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid + " and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid=" + requestid + "))");
                while (rs1.next()) {
                    tempNodeId = rs1.getString("nodeid");
                    if (!canViewIds.contains(tempNodeId)) {
                        canViewIds.add(tempNodeId);
                    }
                }
            } else if (singleViewLogIds == null || "".equals(singleViewLogIds)) {//全部不能查看

            } else {//查看部分
                String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
                for (int i = 0; i < tempidstrs.length; i++) {
                    if (!canViewIds.contains(tempidstrs[i])) {
                        canViewIds.add(tempidstrs[i]);
                    }
                }
            }
        }

        //处理相关流程的查看权限



        if (desrequestid > 0) {
            //System.out.print("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid="+desrequestid+"  and  a.userid=b.userid)");
            rs.executeSql("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid=" + requestid + " and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid=" + desrequestid + "  and  a.userid=b.userid)");
            while (rs.next()) {
                viewNodeId = rs.getString("nodeid");
                rs1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + viewNodeId);
                if (rs1.next()) {
                    singleViewLogIds = rs1.getString("viewnodeids");
                }

                if ("-1".equals(singleViewLogIds)) {//全部查看
                    rs1.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid + " and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid=" + desrequestid + "))");
                    while (rs1.next()) {
                        tempNodeId = rs1.getString("nodeid");
                        if (!canViewIds.contains(tempNodeId)) {
                            canViewIds.add(tempNodeId);
                        }
                    }
                } else if (singleViewLogIds == null || "".equals(singleViewLogIds)) {//全部不能查看

                } else {//查看部分
                    String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
                    for (int i = 0; i < tempidstrs.length; i++) {
                        if (!canViewIds.contains(tempidstrs[i])) {
                            canViewIds.add(tempidstrs[i]);
                        }
                    }
                }
            }
        }
        if (canViewIds.size() > 0) {
            for (int a = 0; a < canViewIds.size(); a++) {
                viewLogIds += (String) canViewIds.get(a) + ",";
            }
            viewLogIds = viewLogIds.substring(0, viewLogIds.length() - 1);
        } else {
            viewLogIds = "-1";
        }
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
        if (istype == 2) {
            sqlsb.append("             ,a.operator ");
        }
        sqlsb.append("        from (SELECT distinct o.requestid, ");
        sqlsb.append("                              o.userid, ");
        sqlsb.append("                              o.workflowid, ");
        sqlsb.append("                              o.workflowtype, ");
        sqlsb.append("                              o.isremark, ");
        sqlsb.append("                              o.lastisremark, ");
        sqlsb.append("                              o.usertype, ");
        sqlsb.append("                              o.nodeid, ");
        sqlsb.append("                              o.agentorbyagentid, ");
        sqlsb.append("                              o.agenttype, ");
        sqlsb.append("                              o.receivedate, ");
        sqlsb.append("                              o.receivetime, ");
        sqlsb.append("                              o.viewtype, ");
        sqlsb.append("                              o.iscomplete, ");
        sqlsb.append("                              o.operatedate, ");
        sqlsb.append("                              o.operatetime, ");
        sqlsb.append("                              nodetype ");
        if (istype == 2) {
            sqlsb.append("                              ,wr.operator ");
        }
        sqlsb.append("                FROM workflow_currentoperator o ");
        sqlsb.append("                left join workflow_requestlog wr");
        sqlsb.append("                on wr.requestid=o.requestid");
        sqlsb.append("                and wr.nodeid=o.nodeid");
        sqlsb.append("                and wr.operator = o.userid");
        sqlsb.append("                and wr.logtype <> '1'");
        
        if (istype == 1) {
            sqlsb.append("                inner join workflow_groupdetail wg ");
            sqlsb.append("                on o.groupdetailid=wg.id and wg.signorder='3' ");
        }
        
        sqlsb.append("                , workflow_flownode ");
        
        
        sqlsb.append("               where o.nodeid = ");
        sqlsb.append("                     workflow_flownode.nodeid ");



        if (!"".equals(disnodeid)) {
            sqlsb.append("                 and workflow_currentoperator.nodeid='" + disnodeid + "' ");
        }
        
        if (!"".equals(disresource)) {
            sqlsb.append("                 and workflow_currentoperator.userid ='" + disresource + "' ");
        }
        
        if (!"".equals(disremark)) {
            if ("2".equals(disremark)) {
                sqlsb.append("                 and o.isremark ='2' ");
                sqlsb.append("                 AND wr.requestid=o.requestid");
                sqlsb.append("                 AND wr.nodeid=o.nodeid");
                sqlsb.append("                 AND wr.operator = o.userid");
                sqlsb.append("                 AND wr.logtype <> '1'");
            }
            if ("0".equals(disremark)) {
                sqlsb.append("                 and o.viewtype='0' ");
            }
            if ("1".equals(disremark)) {
                sqlsb.append("                 and (o.isremark not in ('2','4') ");
                sqlsb.append("                  or (o.isremark='4' and o.viewtype='0')) ");
            }
            
            if ("3".equals(disremark)) {
                sqlsb.append("                 and (o.isremark in ('0', '1', '4', '5', '7', '8', '9') or (o.isremark='2' and (wr.operator is null or wr.operator='')))");
                sqlsb.append("                 and (o.viewtype='-2' or (o.viewtype='-1' ))");
            }
        }


        sqlsb.append("                 and o.requestid = " + requestid + ") a, ");
        sqlsb.append("             workflow_nodebase b ");
        sqlsb.append("       where a.nodeid = b.id ");
        sqlsb.append("         and a.requestid = " + requestid + " ");
        sqlsb.append("         and a.agenttype <> 1 ");
        sqlsb.append("         and a.nodeid in (" + viewLogIds + ") ");
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
        
        if (istype == 2) {
            sqlsb.append("             ,a.operator ");
        }
        sqlsb.append("        from (SELECT distinct o.requestid, ");
        sqlsb.append("                              o.userid, ");
        sqlsb.append("                              o.workflowid, ");
        sqlsb.append("                              o.workflowtype, ");
        sqlsb.append("                              o.isremark, ");
        sqlsb.append("                              o.usertype, ");
        sqlsb.append("                              o.nodeid, ");
        sqlsb.append("                              o.receivedate, ");
        sqlsb.append("                              o.receivetime, ");
        sqlsb.append("                              o.viewtype, ");
        sqlsb.append("                              o.operatedate, ");
        sqlsb.append("                              o.operatetime, ");
        sqlsb.append("                              n.nodetype ");
        if (istype == 2) {
            sqlsb.append("                              ,wr.operator ");
        }
        sqlsb.append("                FROM workflow_currentoperator o");
        sqlsb.append("                left join workflow_requestlog wr");
        sqlsb.append("                on wr.requestid=o.requestid");
        sqlsb.append("                and wr.nodeid=o.nodeid");
        sqlsb.append("                and wr.operator = o.userid");
        sqlsb.append("                and wr.logtype <> '1'");
        
        if (istype == 1) {
            sqlsb.append("                inner join workflow_groupdetail wg ");
            sqlsb.append("                on o.groupdetailid=wg.id and wg.signorder='3' ");
        }
        
        sqlsb.append("                , workflow_flownode n");
        
        sqlsb.append("               where o.nodeid = n.nodeid ");
        sqlsb.append("                 and o.requestid = " + requestid + ") a, ");
        sqlsb.append("             workflow_nodebase b ");
        sqlsb.append("       where a.nodeid = b.id ");

        
        if (!"".equals(disnodeid)) {
            sqlsb.append("                 and o.nodeid ='" + disnodeid + "' ");
        }
        
        if (!"".equals(disresource)) {
            sqlsb.append("                 and o.userid ='" + disresource + "' ");
        }
        
        if (!"".equals(disremark)) {
            if ("2".equals(disremark)) {
                sqlsb.append("                 and o.isremark ='2' ");
                sqlsb.append("                 AND wr.requestid=o.requestid");
                sqlsb.append("                 AND wr.nodeid=o.nodeid");
                sqlsb.append("                 AND wr.operator = o.userid");
                sqlsb.append("                 AND wr.logtype <> '1'");
            }
            if ("0".equals(disremark)) {
                sqlsb.append("                 and o.viewtype='0' ");
            }
            if ("1".equals(disremark)) {
                sqlsb.append("                 and o.isremark <> '2' ");
            }
            
            if ("3".equals(disremark)) {
                sqlsb.append("                 and (o.isremark in ('0', '1', '4', '5', '7', '8', '9') or (o.isremark='2' and (wr.operator is null or wr.operator='')))");
                sqlsb.append("                 and (o.viewtype='-2' or (o.viewtype='-1' ))");
            }
        
        }

        sqlsb.append("         and a.requestid = " + requestid + " ");
        sqlsb.append("         and a.nodeid in (" + viewLogIds + ")) a ");
        sqlsb.append(" order by a.receivedate, a.receivetime, a.nodetype");
        //rs.executeSql("select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid, a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype from (SELECT distinct t1.id,t1.requestid ,t1.userid ,t1.workflowid ,workflowtype ,isremark ,t1.usertype ,t1.nodeid ,agentorbyagentid ,agenttype  ,receivedate ,receivetime ,viewtype ,iscomplete  ,operatedate ,operatetime,nodetype FROM workflow_currentoperator t1,workflow_flownode t2,(select max(id) id,nodeid,userid,usertype from workflow_currentoperator where requestid="+requestid+" group by nodeid,userid,usertype) t3  where t1.id=t3.id and t1.nodeid=t2.nodeid and t1.requestid = "+requestid+") a,workflow_nodebase b where a.nodeid=b.id and a.requestid="+requestid+" and a.agenttype<>1 and a.nodeid in("+viewLogIds+") order by a.receivedate,a.receivetime,a.nodetype");
        //System.out.println(sqlsb.toString());
    }
    return sqlsb.toString();
}
%>