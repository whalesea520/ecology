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
          String hrmids = Util.null2String(request.getParameter("hrmids"));
          String beginDate = Util.null2String(request.getParameter("beginDate"));
          String endDate = Util.null2String(request.getParameter("endDate"));
          String personType = Util.null2String(request.getParameter("personType"));
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
          //String pageHrmids = getPageHrmids(hrmids, subcompanyids, departmentids, cpyincludesub, deptincludesub, iNextNum,ipageset,pagesize);
          
          String pageHrmsql = getPageHrmSql(hrmids, subcompanyids, departmentids, cpyincludesub, deptincludesub, iNextNum,ipageset,pagesize);
          %>
          <input type="hidden" id="pagenum" name="pagenum" value="<%=pagenum %>"/>
        <!-- 对月报表统计进行处理 -->
        <div>        
            <table id="workerListTable" class="listTable" cellspacing="0" cellpadding="0" style="width:99%;border-collapse:collapse;">
                <colgroup>
                    <col style="min-width:100px;width:16%;"/>
                    <col style="min-width:100px;width:18%;"/>
                    <col style="min-width:100px;width:18%;"/>
                    <col style="min-width:100px;width:12%;"/>
                    <col style="min-width:100px;width:12%;"/>
                    <col style="min-width:100px;width:12%;"/>
                    <col style="min-width:100px;width:12%;"/>
                </colgroup>
                <thead>
                     <tr style="text-align:center;">
                        <td style="text-align:left;">人员</td>
                        <td style="text-align:left;">分部</td>
                        <td style="text-align:left;">部门</td>
                        <td>任务数</td>
                        <td>已超期</td>
                        <td>进行中</td>
                        <td>已完成</td>
                    </tr>
                </thead>
                <%
                if(iTotal==0){
                    %>
                   <tr style="background:#fff !important;">
                       <td colspan="16" style="background:#fff !important;text-align:center">无相关数据</td>
                   </tr>
                    <%
                    return;
                }
                String sql = getSearchSql(pageHrmsql, beginDate, endDate,personType,isSqlServer);
                rs.execute(sql);
                LinkedHashMap<String,LinkedHashMap<String,String>> map= getWorkerResult(rs);
                
                LinkedHashMap<String,String> curMap = null;
                for (Entry<String,LinkedHashMap<String,String>> obj : map.entrySet()) {
                    curMap = obj.getValue();
                %>
                <tr style="text-align:center;">
                    <td style="text-align:left"><a onclick="pointerXY(event);" href="javascript:openhrm(<%=obj.getKey()%>);"><%=curMap.get("lastname") %></a></td>
                    <td style="text-align:left"><%=curMap.get("subcompanyname") %></td>
                    <td style="text-align:left"><%=curMap.get("departmentname") %></td>
                    <td><%=curMap.get("total") %></td>
                    <td><%=curMap.get("overtime") %></td>
                    <td><%=curMap.get("doing") %></td>
                    <td><%=curMap.get("finish") %></td>
                </tr>
               <%}%>
               <tr style="background:#fff !important;">
                   <td colspan="16" style="background:#fff !important;text-align:right;border:none;">
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
     * 获得用户信息
     * @return
     */
    private LinkedHashMap<String,LinkedHashMap<String, String>> getHrmInfo(weaver.conn.RecordSet rs) {
        LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
        String id = null;
        String lastname = null;
        String subcompanyname = null;
        String departmentname = null;
        LinkedHashMap<String, String> curValues = null;
        while(rs.next()){
            id = null2String(rs.getString("id"));
            lastname = null2String(rs.getString("lastname"));
            subcompanyname = null2String(rs.getString("subcompanyname"));
            departmentname = null2String(rs.getString("departmentname"));
            curValues = new LinkedHashMap<String, String>();
            curValues.put("id",id);
            curValues.put("lastname",lastname);
            curValues.put("subcompanyname",subcompanyname);
            curValues.put("departmentname",departmentname);
            map.put(id,curValues);
        }
        return map;
    }
    
    /**
     * 通过查询结果，组合成展示数据
     * @return
     */
    private LinkedHashMap<String,LinkedHashMap<String, String>> getWorkerWeekResult(weaver.conn.RecordSet rs,int weeknum) {
        LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
        String id = null;
        String lastname = null;
        String subcompanyname = null;
        String departmentname = null;
        String week = null;
        LinkedHashMap<String, String> curValues = null;
        while(rs.next()){
            id = null2String(rs.getString("id"));
            lastname = null2String(rs.getString("lastname"));
            subcompanyname = null2String(rs.getString("subcompanyname"));
            departmentname = null2String(rs.getString("departmentname"));

            curValues = new LinkedHashMap<String, String>();
            curValues.put("id",id);
            curValues.put("lastname",lastname);
            curValues.put("subcompanyname",subcompanyname);
            curValues.put("departmentname",departmentname);
            for(int i=1;i<=weeknum;i++){
                week = null2String(rs.getString("week"+i),"n");
                curValues.put("week"+i,week);
            }
            map.put(id,curValues);
        }
        return map;
    }
    
    %>
    
    <%!
       /**
        * 构建查询sql
        * @param beginDate 开始时间
        * @param endDate 结束时间
        * @param personType 人员类型
        * @return 
        */
       public String getSearchSql(String hrmsql,String beginDate,String endDate,String personType,boolean isSqlServer){
           //String idssql = ((hrmids!=null&&!"".equals(hrmids))?"AND hrm.id IN("+hrmids+")":"");
           String idssql = "";
           String personTypeSql = "";
           //人员类型包含责任人
           if(personType.contains("1")){
               personTypeSql += "tm.principalid=hrm.id ";
           //人员类型包含参与人
           }else if(personType.contains("2")){
               personTypeSql += "or hrm.id in( select partnerid from TM_TaskPartner where taskid=tm.id )";
           //人员类型包含创建人
           }else if(personType.contains("3")){
               personTypeSql += "or tm.creater=hrm.id ";
           }
           if(personTypeSql.startsWith("or")){
               personTypeSql = personTypeSql.substring(2);
           }
           if(personTypeSql.length()>0){
               personTypeSql = " AND ("+personTypeSql+")";
           }else{
               personTypeSql = " AND (tm.principalid=hrm.id or tm.creater=hrm.id or hrm.id in( select partnerid from TM_TaskPartner where taskid=tm.id ))";
           }
           personTypeSql += " and (tm.deleted=0 or tm.deleted is null)";
           String sql = null;
           if(isSqlServer){
	           sql="SELECT hrm.id, "+
                  "           hrm.lastname, "+
                  "           cpy.subcompanyname, "+
                  "           dept.departmentname, "+
                  "           Isnull(A.total, 0)    total, "+
                  "           Isnull(B.overtime, 0) overtime, "+
                  "           Isnull(C.finish, 0)   finish, "+
                  "           Isnull(D.doing, 0)    doing "+
                  "    FROM   HrmSubCompany cpy, "+
                  "           HrmDepartment dept, "+
                  "           ("+hrmsql+") hrm "+
                  "           LEFT JOIN (SELECT hrm.id, "+
                  "                             Count(1) total "+
                  "                      FROM   TM_TaskInfo tm,"+
                  "                             HrmResource hrm "+
                  "                      WHERE  tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                  "                             " + personTypeSql +
                  "                             AND hrm.status<=3 "+
                  "                      GROUP  BY hrm.id) A "+
                  "                  ON hrm.id = A.id "+
                  "           LEFT JOIN (SELECT hrm.id, "+
                  "                             Count(1) overtime "+
                  "                      FROM   TM_TaskInfo tm,"+
                  "                             HrmResource hrm "+
                  "                      WHERE  tm.status = 1 "+
                  "                             AND hrm.status<=3 "+
                  "                             AND tm.enddate IS NOT NULL "+
                  "                             AND LEN(tm.enddate) >0 "+
                  "                             AND Cast(tm.enddate AS DATETIME) < Getdate() "+
                  "                             AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                  "                             " + personTypeSql +
                  "                      GROUP  BY hrm.id) B "+
                  "                  ON hrm.id = B.id "+
                  "           LEFT JOIN (SELECT hrm.id, "+
                  "                             Count(1) finish "+
                  "                      FROM   TM_TaskInfo tm,"+
                  "                             HrmResource hrm "+
                  "                      WHERE  tm.status = 2 "+
                  "                             AND hrm.status<=3 "+
                  "                             AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                  "                             " + personTypeSql +
                  "                      GROUP  BY hrm.id) C "+
                  "                  ON hrm.id = C.id "+
                  "           LEFT JOIN (SELECT hrm.id, "+
                  "                             Count(1) doing "+
                  "                      FROM   TM_TaskInfo tm, "+
                  "                             HrmResource hrm "+
                  "                      WHERE  tm.status = 1 "+
                  "                             AND hrm.status<=3 "+
                  "                             AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                  "                             " + personTypeSql +
                  "                      GROUP  BY hrm.id) D "+
                  "                  ON hrm.id = D.id "+
                  "    WHERE  1 = 1 " + idssql +
                  "           AND hrm.departmentid = dept.id"+
                  "           AND dept.subcompanyid1 = cpy.id"+
                  "           AND hrm.status<=3 "+
                  "    ORDER  BY hrm.dsporder ";
           }else{
	           sql="SELECT hrm.id, "+
                  "           hrm.lastname, "+
                  "           cpy.subcompanyname, "+
                  "           dept.departmentname, "+
                  "           NVL(A.total, 0)    total, "+
                  "           NVL(B.overtime, 0) overtime, "+
                  "           NVL(C.finish, 0)   finish, "+
                  "           NVL(D.doing, 0)    doing "+
                  "    FROM   HrmSubCompany cpy, "+
                  "           HrmDepartment dept, "+
                  "           ("+hrmsql+") hrm "+
                  "           LEFT JOIN (SELECT hrm.id, "+
                  "                             Count(1) total "+
                  "                      FROM   TM_TaskInfo tm,"+
                  "                             HrmResource hrm "+
                  "                      WHERE  tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                  "                             " + personTypeSql +
                  "                             AND hrm.status<=3 "+
                  "                      GROUP  BY hrm.id) A "+
                  "                  ON hrm.id = A.id "+
                  "           LEFT JOIN (SELECT hrm.id, "+
                  "                             Count(1) overtime "+
                  "                      FROM   TM_TaskInfo tm,"+
                  "                             HrmResource hrm "+
                  "                      WHERE  tm.status = 1 "+
                  "                             AND hrm.status<=3 "+
                  "                             AND tm.enddate IS NOT NULL "+
                  "                             AND LENGTH(tm.enddate) >0 "+
                  "                             AND tm.enddate < TO_CHAR(SYSDATE,'YYYY-MM-DD') "+
                  "                             AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                  "                             " + personTypeSql +
                  "                      GROUP  BY hrm.id) B "+
                  "                  ON hrm.id = B.id "+
                  "           LEFT JOIN (SELECT hrm.id, "+
                  "                             Count(1) finish "+
                  "                      FROM   TM_TaskInfo tm,"+
                  "                             HrmResource hrm "+
                  "                      WHERE  tm.status = 2 "+
                  "                             AND hrm.status<=3 "+
                  "                             AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                  "                             " + personTypeSql +
                  "                      GROUP  BY hrm.id) C "+
                  "                  ON hrm.id = C.id "+
                  "           LEFT JOIN (SELECT hrm.id, "+
                  "                             Count(1) doing "+
                  "                      FROM   TM_TaskInfo tm, "+
                  "                             HrmResource hrm "+
                  "                      WHERE  tm.status = 1 "+
                  "                             AND hrm.status<=3 "+
                  "                             AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                  "                             " + personTypeSql +
                  "                      GROUP  BY hrm.id) D "+
                  "                  ON hrm.id = D.id "+
                  "    WHERE  1 = 1 " + idssql +
                  "           AND hrm.departmentid = dept.id"+
                  "           AND dept.subcompanyid1 = cpy.id"+
                  "           AND hrm.status<=3 "+
                  "    ORDER  BY hrm.dsporder ";
           }
           return sql;
       }
   
       /**
        * 获得用户信息
        * @return 
        */
       private LinkedHashMap<String,LinkedHashMap<String, String>> getWorkerResult(weaver.conn.RecordSet rs) {
           LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
           String id = null;
           String lastname = null;
           String subcompanyname = null;
           String departmentname = null;
           String total = null;
           String overtime = null;
           String finish = null;
           String doing = null;
           LinkedHashMap<String, String> curValues = null;
           while(rs.next()){
               id = null2String(rs.getString("id"));
               lastname = null2String(rs.getString("lastname"));
               subcompanyname = null2String(rs.getString("subcompanyname"));
               departmentname = null2String(rs.getString("departmentname"));
               total = null2String(rs.getString("total"));
               overtime = null2String(rs.getString("overtime"));
               finish = null2String(rs.getString("finish"));
               doing = null2String(rs.getString("doing"));
               curValues = new LinkedHashMap<String, String>();
               curValues.put("id",id);
               curValues.put("lastname",lastname);
               curValues.put("subcompanyname",subcompanyname);
               curValues.put("departmentname",departmentname);
               curValues.put("total",total);
               curValues.put("overtime",overtime);
               curValues.put("finish",finish);
               curValues.put("doing",doing);
               map.put(id,curValues);
           }
           return map;
       }
    %>
</HTML>