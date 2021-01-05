<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ include file="/workrelate/comm/WorkerReportUtil.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
    <HEAD>
        <title>分部报告</title>

        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        
    </HEAD>
    <BODY style="padding:10px;">
    <%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
        <%
          String year = Util.null2String(request.getParameter("year"));
          String hrmids = Util.null2String(request.getParameter("hrmids"));
          String subcompanyids = Util.null2String(request.getParameter("subcompanyids"));
          String departmentids = Util.null2String(request.getParameter("departmentids"));
          String cpyincludesub = null2String(request.getParameter("cpyincludesub"),"3");
          String deptincludesub = null2String(request.getParameter("deptincludesub"),"3");
          String workerType = null2String(request.getParameter("workerType"),"0");
          //是否是sql server数据库
          boolean isSqlServer = rs.getDBType().equals("sqlserver");
        
          //如果是查询所有下属
          if("3".equals(workerType)){
              int userId = user.getUID();
              rs.execute("select id from HrmResource where managerid="+userId);
              hrmids = "";
              while(rs.next()){
                  hrmids += "," + rs.getInt(1);
              }
              hrmids = hrmids.substring(1);
          //如果是直线下属  
          }else if("2".equals(workerType)){
              int userId = user.getUID();
              rs.execute(" select id from HrmResource where managerstr like '%,"+userId+",%'");
              hrmids = "";
              while(rs.next()){
                  hrmids += "," + rs.getInt(1);
              }
              hrmids = hrmids.substring(1);
          }
          
          int iTotal = 0; 
          int pagesize = 15;
          //得到记录总条数
          iTotal = getTotalRecord(hrmids, subcompanyids, departmentids, cpyincludesub, deptincludesub);
          //总页数
          int totalpage = iTotal / pagesize;
          if(iTotal % pagesize >0){
              totalpage += 1;
          }
          //当前页
          int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
          if(pagenum>totalpage){
              pagenum=1;
          }
          
          //查询数据最大值
          int iNextNum = pagenum * pagesize;
          int ipageset = pagesize;
          if(iTotal - iNextNum < 0){
              ipageset = iTotal - iNextNum + pagesize;
          }
          if(iTotal < pagesize) {
              ipageset = iTotal;
          }
          //得到人员id
          String pageHrmids = getPageHrmids(hrmids, subcompanyids, departmentids, cpyincludesub, deptincludesub, iNextNum,ipageset,pagesize);
          
          %>
          <input type="hidden" id="pagenum" name="pagenum" value="<%=pagenum %>"/>
        <!-- 对月报表统计进行处理 -->
        <div style="width:99%;">
            <div class="icons">
                <img src="/workrelate/images/wrstatus0.png"/><label>考核中</label>
                <img src="/workrelate/images/wrstatus1.png"/><label>审批中</label>
                <img src="/workrelate/images/wrstatus3.png"/><label>已完成</label>
                <img src="/workrelate/images/wrstatus2.png"/><label>已过期</label>
                <img src="/workrelate/images/wrstatus4.png"/><label>未开始</label>
                <img src="/workrelate/images/wrstatus5.png"/><label>无数据</label>
                <img src="/workrelate/images/wrstatus6.png"/><label>无方案</label>
            </div>
            <table id="workerListTable" class="listTable" cellspacing="0" cellpadding="0" style="border-collapse:collapse;">
                <colgroup>
                    <col style="min-width:60px;width:6%;"/>
                    <col style="min-width:100px;width:17%;"/>
                    <col style="min-width:100px;width:17%;"/>
                    <%for(int i=1;i<=12;i++){%>
                        <col style="min-width:50px;width:5%;"/>
                    <%}%>
                </colgroup>
                <thead>
                     <tr style="text-align:center;">
                        <td style="text-align:left;">人员</td>
                        <td style="text-align:left;">分部</td>
                        <td style="text-align:left;">部门</td>
                         <%for(int i=1;i<=12;i++){%>
                            <td><%=i %>月</td>
                        <%}%>
                    </tr>
                </thead>
                <%
                if(isEmpty(pageHrmids)){
                    %>
                   <tr style="background:#fff !important;">
                       <td colspan="16" style="background:#fff !important;text-align:center">无相关数据</td>
                   </tr>
                    <%
                    return;
                }
                String sql = getSearchSql(pageHrmids,year,isSqlServer);
                rs.execute(sql);
                LinkedHashMap<String,LinkedHashMap<String,String>> map= getWorkerResult(rs,year);
                
                LinkedHashMap<String,String> curMap = null;
                for (Entry<String,LinkedHashMap<String,String>> obj : map.entrySet()) {
                    curMap = obj.getValue();
                %>
                <tr style="text-align:center;">
                    <td style="text-align:left"><a onclick="pointerXY(event);" href="javascript:openhrm(<%=obj.getKey()%>);"><%=curMap.get("lastname") %></a></td>
                    <td style="text-align:left"><%=curMap.get("subcompanyname") %></td>
                    <td style="text-align:left"><%=curMap.get("departmentname") %></td>
                    <%
                    String tempMonth = null;
                    for(int i=1;i<=12;i++){
                        tempMonth = "month" + i;
                    %>
                        <td><img src="<%=getStatusImg(curMap.get(tempMonth)) %>"/></td>
                    <%}%>
                </tr>
               <%}%>
               <tr style="background:#fff !important;">
                   <td colspan="16" style="background:#fff !important;text-align:right;border:none;padding:0px;">
                       <table class="pagetable" cellpadding="0" cellspacing="0" border="0" style="margin-top: 4px;float:left;width:100%">
                           <tr style="background:#fff !important;">
                               <td align="right" style="background:#fff !important;">
                                  <div>
                                   &raquo; 共<%=iTotal%>条记录&nbsp&nbsp&nbsp每页<%=pagesize%>条&nbsp&nbsp&nbsp共<%=totalpage%>页&nbsp&nbsp&nbsp当前第<%=pagenum%>页&nbsp&nbsp
                                   <%if(pagenum > 1){%>
                                   <A style="cursor:hand;TEXT-DECORATION:none;" onClick="toPage(1)" >首页</A>
                                   <A style="cursor:hand;TEXT-DECORATION:none;" onClick="toPage('<%=pagenum-1%>')">上一页</A>
                                   <%} else {%>
                                                                                                      首页 上一页 
                                   <%}%>
                                   <%if(pagenum < totalpage){%>
                                       <A style="cursor:hand;TEXT-DECORATION:none;" onClick="toPage('<%=pagenum+1%>')">下一页 </A>
                                       <A style="cursor:hand;TEXT-DECORATION:none;" onClick="toPage('<%=totalpage%>')">尾页</A>
                                   <%} else {%>
                                                                                                      下一页 尾页
                                   <%}%>
                                   &nbsp;<div class="btn1 btn" style="float:none;width:40px;display:inline !important;" onclick="toGoPage()">转到</div>&nbsp;第<input id='topagenum' type="text" value="<%=pagenum%>" size="2" class="text" style="text-align:right"/>页
                                  </div>
                               </td>
                           </tr>
                       </table>
                   </td>
               </tr>
            </table>
        </div>
    </BODY>
    <script type="text/javascript">
        function setWorkerTableColor(){
            $("#workerListTable tbody tr").bind("mouseover",function(){
                $(this).css({"background":"#FAFAFA"});
            }).bind("mouseout",function(){
                $("#workerListTable tbody tr").css({"background":"#FFFFFF"});
            });
        }
        setWorkerTableColor();
        //分页查询
        function toPage(pagenum){
            $("#pagenum").val(pagenum);
            searchWorker();
        }
        //跳转到第几页
        function toGoPage(){
            $("#pagenum").val($("#topagenum").val());
            searchWorker();
        }
    </script>
    <%!
    /**
     * 
     * 得到状态图片src
     * @param status
     * @return
     */
    public String getStatusImg(String status){
        String src = null;
        if("0".equals(status)){//考核中
            src = "wrstatus0.png";
        }else if("1".equals(status)){//审批中
            src = "wrstatus1.png";
        }else if("3".equals(status)){//已完成
            src = "wrstatus3.png";
        }else if("4".equals(status)){//已过期
            src = "wrstatus2.png";
        }else if("-1".equals(status)){//未开始
            src = "wrstatus4.png";
        }else if("n1".equals(status)){//无方案
            src = "wrstatus6.png";
        }else if("n2".equals(status)){//无数据
            src = "wrstatus5.png";
        }
        return "/workrelate/images/"+src;
    }
    
       /**
        * 构建查询sql
        * @param hrmids 人员id
        * @param year 查询年份
        * @param isSqlServer 是否sqlserver数据库
        * @return 
        */
       public String getSearchSql(String hrmids,String year,boolean isSqlServer){
           year = "".equals(year)?""+Calendar.getInstance().get(Calendar.YEAR):year;
           String idssql = (hrmids!=null&&!"".equals(hrmids))?"AND hrm.id IN("+hrmids+")":"";
           //12个月的查询sql
           StringBuffer sb = new StringBuffer();
           //如果是sql server数据库
           if(isSqlServer){
               for(int i=1;i<=12;i++){
                   sb.append("                ,MAX(CASE WHEN type2 = "+i+" "+
                       "                  THEN ( CASE WHEN GETDATE() <= CAST(score.startdate AS DATETIME) THEN -1 "+
                       "                              WHEN status = 0 "+
                       "                                   AND GETDATE() <= CAST(score.enddate AS DATETIME) "+
                       "                              THEN 0 "+
                       "                              WHEN status = 1 "+
                       "                                   AND GETDATE() <= CAST(score.enddate AS DATETIME) "+
                       "                              THEN 1 "+
                       "                              WHEN status = 3 THEN 3 "+
                       "                              WHEN GETDATE() > CAST(score.enddate AS DATETIME) "+
                       "                              THEN 4 "+
                       "                         END ) "+
                       "                         ELSE -2 "+
                       "             END) month"+i+" ");
               }
           }else{
               for(int i=1;i<=12;i++){
                   sb.append("                ,MAX(CASE WHEN type2 = "+i+" "+
                       "                  THEN ( CASE WHEN SYSDATE <= TO_DATE(score.startdate,'yyyy-mm-dd') THEN -1 "+
                       "                              WHEN status = 0 "+
                       "                                   AND SYSDATE <= TO_DATE(score.enddate,'yyyy-mm-dd') "+
                       "                              THEN 0 "+
                       "                              WHEN status = 1 "+
                       "                                   AND SYSDATE <= TO_DATE(score.enddate,'yyyy-mm-dd') "+
                       "                              THEN 1 "+
                       "                              WHEN status = 3 THEN 3 "+
                       "                              WHEN SYSDATE > TO_DATE(score.enddate,'yyyy-mm-dd') "+
                       "                              THEN 4 "+
                       "                         END ) "+
                       "                         ELSE -2 "+
                       "             END) month"+i+" ");
               }
           }
           String monthSql = "SELECT  userid "+sb.toString()+
                   "      FROM    GP_AccessScore score "+
                   "      WHERE   year = '"+year+"'"+
                   "              AND type1 = 1 "+
                   "      GROUP   BY userid ";
           String sql = "SELECT  hrm.id id , "+
                    "        hrm.lastname , "+
                    "        cpy.subcompanyname , "+
                    "        dept.departmentname , "+
                    "        A.* "+
                    "FROM    HrmSubCompany cpy , "+
                    "        HrmDepartment dept , "+
                    "        HrmResource hrm "+
                    "LEFT    JOIN ( "+monthSql+" ) A "+
                    "        ON hrm.id = A.userid "+
                    "WHERE   hrm.departmentid = dept.id "+
                    "        AND hrm.status<=3 "+
                    "        AND dept.subcompanyid1 = cpy.id " + idssql;
           return sql;
       }
   
       /**
        * 获得用户信息
        * @return 
        */
       private LinkedHashMap<String,LinkedHashMap<String, String>> getWorkerResult(weaver.conn.RecordSet rs,String year) {
           int yearInt = Integer.parseInt(year);
           LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
           String id = null;
           String lastname = null;
           String subcompanyname = null;
           String departmentname = null;
           String monthName = null;
           String monthValue = null;
           LinkedHashMap<String, String> curValues = null;
           int currYear = Calendar.getInstance().get(Calendar.YEAR);
           int currMonth = Calendar.getInstance().get(Calendar.MONTH)+1;
           if(Integer.parseInt(year) < currYear){
               currMonth = 12;
           }
           HashMap<String, String> workerProgramMap = null;
           Calendar cl = null;
           java.text.SimpleDateFormat format = null;
           while(rs.next()){
               id = null2String(rs.getString("id"));
               lastname = null2String(rs.getString("lastname"));
               subcompanyname = null2String(rs.getString("subcompanyname"));
               departmentname = null2String(rs.getString("departmentname"));
               curValues = new LinkedHashMap<String, String>();
               //把12个月的值放入集合
               for(int i=1;i<=12;i++){
                   monthName = "month"+i;
                   if(i>currMonth){
                	   monthValue="-1";
                   }else{
	                   monthValue = null2String(rs.getString(monthName));
	                   if(isEmpty(monthValue) || "-2".equals(monthValue)){
	                       if(workerProgramMap == null){
	                           workerProgramMap = getWorkerProgram();
	                           format = new java.text.SimpleDateFormat("yyyy-MM-dd");
	                           cl = Calendar.getInstance();
	                       }
	                       monthValue = getMonthStatus(id,yearInt,i,workerProgramMap,cl,format);
	                   }
                   }
                   curValues.put(monthName,monthValue);
               }
               curValues.put("id",id);
               curValues.put("lastname",lastname);
               curValues.put("subcompanyname",subcompanyname);
               curValues.put("departmentname",departmentname);

               map.put(id,curValues);
           }
           return map;
       }
       
       /**
        * 得到员工计划开始时间集合
        */
       public String getMonthStatus(String userid,int year,int month,HashMap<String, String> workerProgramMap,Calendar cl,java.text.SimpleDateFormat format){
           String status = null;
           String startdate = null;
           if(workerProgramMap.containsKey(userid)){
               startdate = workerProgramMap.get(userid);
               cl.set(Calendar.YEAR, 2014);
               cl.set(Calendar.MONTH, month-1);
               cl.set(Calendar.DAY_OF_MONTH,cl.getActualMaximum(Calendar.DAY_OF_MONTH));
               String currDate = format.format(cl.getTime());
               
               //如果开始时间比结束时间晚，则是无数据
               if(currDate.compareTo(startdate) >= 0){
            	   status = "n2";
               }else{
            	   status = "n1";//无方案
               }
           }else{
               status = "n1";//无方案
           }
           return status;
       }
       
       /**
        * 得到员工计划开始时间集合
        */
       public HashMap<String, String> getWorkerProgram(){
           HashMap<String, String> map = new HashMap<String, String>();
           weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
           //是否是sql server数据库
           boolean isSqlServer = rs.getDBType().equals("sqlserver");
           String sql = getWorkerProgramSql(isSqlServer);
           rs.execute(sql);
           String id = null;
           String startdate = null;
           while(rs.next()){
               id = null2String(rs.getString("id"));
               startdate = null2String(rs.getString("startdate"));
               if(!isEmpty(id) && !isEmpty(startdate)){
                   map.put(id,startdate);
               }
           }
           return map;
       }
       
       /**
        * 得到员工计划开始时间查询sql
        */
       public String getWorkerProgramSql(boolean isSqlServer){
    	   String sql = null;
    	   if(isSqlServer){
               sql = "SELECT  hrm.id , "+
                        "         CASE WHEN bs.mstarttype < 0 "+
                        "             THEN DATEADD(DAY, bs.mstartdays, CAST(ap.startdate AS DATE)) "+
                        "             WHEN bs.mstarttype > 0 "+
                        "             THEN DATEADD(DAY, -bs.mstartdays, CAST(ap.startdate AS DATE)) "+
                        "         END startdate "+
                        "FROM    ( SELECT    userid , "+
                        "                    MIN(startdate) startdate "+
                        "          FROM      GP_AccessProgram "+
                        "          WHERE     status = 3 "+
                        "          GROUP BY  userid "+
                        "        ) ap , "+
                        "        HrmResource hrm "+
                        "        LEFT JOIN GP_BaseSetting bs ON hrm.subcompanyid1 = bs.resourceid "+
                        "WHERE   ap.userid = hrm.id AND hrm.status<=3 ";
    	   }else{
               sql = "SELECT  hrm.id , "+
                        "         CASE WHEN bs.mstarttype < 0 "+
                        "             THEN TO_DATE(ap.startdate,'yyyy-mm-dd')+bs.mstartdays "+
                        "             WHEN bs.mstarttype > 0 "+
                        "             THEN TO_DATE(ap.startdate,'yyyy-mm-dd')-bs.mstartdays "+
                        "         END startdate "+
                        "FROM    ( SELECT    userid , "+
                        "                    MIN(startdate) startdate "+
                        "          FROM      GP_AccessProgram "+
                        "          WHERE     status = 3 "+
                        "          GROUP BY  userid "+
                        "        ) ap , "+
                        "        HrmResource hrm "+
                        "        LEFT JOIN GP_BaseSetting bs ON hrm.subcompanyid1 = bs.resourceid "+
                        "WHERE   ap.userid = hrm.id AND hrm.status<=3 ";
    	   }
           return sql;
       }
    %>
</HTML>