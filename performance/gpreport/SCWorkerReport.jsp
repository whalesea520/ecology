<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ include file="/workrelate/comm/WorkerReportUtil.jsp"%>
<%@ include file="SCUtil.jsp" %>
<%@ include file="/workrelate/reportshare/ReportShareUtil.jsp" %>
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
          
          //得到所有可以查询的分部
          String resourceSql = getAccessResource(user);
          
          int iTotal = 0; 
          int pagesize = 15;
          //得到记录总条数
          iTotal = getTotalRecord(hrmids, subcompanyids, departmentids, cpyincludesub, deptincludesub,resourceSql);
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
          String pageHrmids = getPageHrmids(hrmids, subcompanyids, departmentids, cpyincludesub, deptincludesub, iNextNum,ipageset,pagesize,resourceSql);
          
          %>
          <input type="hidden" id="pagenum" name="pagenum" value="<%=pagenum %>"/>
        <!-- 对月报表统计进行处理 -->
        <div>
            <table id="workerListTable" class="listTable" cellspacing="0" cellpadding="0" style="width:99%;border-collapse:collapse;">
                <%
                 //分数段集合
                 LinkedHashMap<String,LinkedHashMap<String, String>> scoreMap = getScoreSetting();
                 if(scoreMap.size()==0){
                     %>
                     <tr><td>请先在考核设置中对分数段进行设置，再进行查询!</td></tr>
                     <%
                     return ;
                 }
                 %>
                <colgroup>
                    <col style="min-width:60px;width:6%;"/>
                    <col style="min-width:100px;width:17%;"/>
                    <col style="min-width:100px;width:17%;"/>
                </colgroup>
                <thead>
                      <tr style="text-align:center;">
                        <td style="text-align:left;">人员</td>
                        <td style="text-align:left;">分部</td>
                        <td style="text-align:left;">部门</td>
                        <%
                        //分数段数
                        int scoreNum = scoreMap.size();
                        LinkedHashMap<String,String> curMap = null;
                        String gardename = null;
                        String valueSize = null;
                        ListIterator<Map.Entry<String,LinkedHashMap<String,String>>> it=new ArrayList<Map.Entry<String,LinkedHashMap<String,String>>>(scoreMap.entrySet()).listIterator();
                        while(it.hasNext()) {
                            Entry<String,LinkedHashMap<String,String>> obj=it.next();
                            curMap = obj.getValue();
                            gardename = curMap.get("gardename");
                            valueSize = getValueSize(curMap);
                        %>
                        <td title="<%=valueSize %>"><%=gardename %></td>
                    <%}%>
                    </tr>
                </thead>
                <%
                if(isEmpty(pageHrmids)){
                    %>
                   <tr style="background:#fff !important;">
                       <td colspan="9" style="background:#fff !important;text-align:center">无相关数据</td>
                   </tr>
                    <%
                    return;
                }
                String sql = getSearchSql(pageHrmids,year,scoreMap,isSqlServer);
                rs.execute(sql);
                LinkedHashMap<String,LinkedHashMap<String,String>> map= getWorkerResult(rs,year,scoreNum);
                String tempKey = null;
                for (Entry<String,LinkedHashMap<String,String>> obj : map.entrySet()) {
                    curMap = obj.getValue();
                %>
                <tr style="text-align:center;">
                    <td style="text-align:left"><a onclick="pointerXY(event);" href="javascript:openhrm(<%=obj.getKey()%>);"><%=curMap.get("lastname") %></a></td>
                    <td style="text-align:left"><%=curMap.get("subcompanyname") %></td>
                    <td style="text-align:left"><%=curMap.get("departmentname") %></td>
                    <%
                    for(int i=0;i<scoreNum;i++){
                        tempKey = "l" + i;
                    %>
                    <td><%=curMap.get(tempKey) %></td>
                    <%}%>
                </tr>
               <%}%>
               <tr style="background:#fff !important;">
                   <td colspan="<%=scoreNum+3 %>" style="background:#fff !important;text-align:right;border:none;padding:0px;">
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
     * 得到人员id
     * @param hrmids
     * @param subcompanyids
     * @param departmentids
     * @param cpyincludesub
     * @param deptincludesub
     * @param iNextNum
     * @param ipageset
     * @return
     */
    public String getPageHrmids(String hrmids, String subcompanyids, String departmentids, String cpyincludesub, String deptincludesub, int iNextNum, int ipageset, int ipagesize,String resourceSql){
        StringBuffer pageHrmids = new StringBuffer();
        weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
        int iTotal = 0;
        String ids = "";
        String backfields = null;
        String fromSql = null;
        String sqlWhere = null;
        String[] orderbyFields = new String[]{"id"};
        String order = "asc";
        //是否是sql server数据库
        boolean isSqlServer = rs.getDBType().equals("sqlserver");
        
        //如果没有查询条件，则查询所有人的数据
        if(isEmpty(hrmids) && isEmpty(subcompanyids) && isEmpty(departmentids)){
            backfields = "id";
            fromSql = " from HrmResource";
            sqlWhere = " where 1=1 and status<=3 ";
        //如果人员id不为空，则查询指定人员的数据
        }else if(!isEmpty(hrmids)){
            backfields = "id";
            fromSql = " from HrmResource";
            sqlWhere = " where id in("+hrmids+") and status<=3 ";
        //如果部门id不为空，则查询指定部门的数据
        }else if(!isEmpty(departmentids)){
            ids = getDeptIds(departmentids,deptincludesub);
            //如果所查询的部门id为空则返回0
            if(isEmpty(ids)){
                return "";
            }
            backfields = "id";
            fromSql = " from HrmResource";
            sqlWhere = " where departmentid in("+ids+") and status<=3 ";
        //如果分部id不为空，则查询指定分部的数据
        }else if(!isEmpty(subcompanyids)){
            ids = getCpyIds(subcompanyids,cpyincludesub);
            //如果所查询的分部id为空则返回0
            if(isEmpty(ids)){
                return "";
            }
            rs.executeSql("select count(1) from HrmResource where subcompanyid1 in("+ids+") and status<=3 ");
            backfields = "id";
            fromSql = " from HrmResource";
            sqlWhere = " where subcompanyid1 in("+ids+")  and status<=3 ";
        }
        sqlWhere += " AND "+resourceSql;
        String sql = null;
        if(isSqlServer){
            sql = getPageSql(backfields,fromSql, sqlWhere, orderbyFields, order, iNextNum, ipageset);
        }else{
            sql = "select * from (select A.* from (select rownum rn,"+
                                 backfields + fromSql + sqlWhere + getOrderSql(orderbyFields,order) + 
                                 " ) A where rownum<=" + iNextNum +" ) B where rn>" + (iNextNum-ipagesize);
        }
        rs.execute(sql);
        while(rs.next()){
            pageHrmids.append(","+rs.getString("id"));
        }
        return pageHrmids.length()>0?pageHrmids.substring(1):"";
    }
   
    /**
     * 
     * 得到数据总数
     * @param hrmids
     * @param subcompanyids
     * @param departmentids
     * @param cpyincludesub
     * @param deptincludesub
     * @return
     */
    public int getTotalRecord(String hrmids, String subcompanyids, String departmentids, String cpyincludesub, String deptincludesub,String resourceSql){
        weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
        int iTotal = 0;
        String ids = "";
        
        String accessViewSql = " AND "+resourceSql;
        //如果没有查询条件，则查询所有人的数据
        if(isEmpty(hrmids) && isEmpty(subcompanyids) && isEmpty(departmentids)){
            rs.executeSql("select count(1) from HrmResource WHERE status<=3" + accessViewSql);
            if(rs.next()){
                iTotal = rs.getInt(1);
            }
        //如果人员id不为空，则查询指定人员的数据
        }else if(!isEmpty(hrmids)){
            rs.executeSql("select count(1) from HrmResource where id in("+hrmids+") and status<=3" + accessViewSql);
            if(rs.next()){
                iTotal = rs.getInt(1);
            }
        //如果部门id不为空，则查询指定部门的数据
        }else if(!isEmpty(departmentids)){
            ids = getDeptIds(departmentids,deptincludesub);
            //如果所查询的部门id为空则返回0
            if(isEmpty(ids)){
                return 0;
            }
            rs.executeSql("select count(1) from HrmResource where departmentid in("+ids+") AND status<=3" + accessViewSql);
            if(rs.next()){
                iTotal = rs.getInt(1);
            }
        //如果分部id不为空，则查询指定分部的数据
        }else if(!isEmpty(subcompanyids)){
            ids = getCpyIds(subcompanyids,cpyincludesub);
            //如果所查询的分部id为空则返回0
            if(isEmpty(ids)){
                return 0;
            }
            rs.executeSql("select count(1) from HrmResource where subcompanyid1 in("+ids+") AND status<=3" + accessViewSql);
            if(rs.next()){
                iTotal = rs.getInt(1);
            }
        }
        return iTotal;
    }
   
       /**
        * 构建查询sql
        * @param hrmids 人员id
        * @param year 查询年份
        * @param scoreMap 分数段集合
        * @param isSqlServer 是否sqlserver数据库
        * @return 
        */
       public String getSearchSql(String hrmids,String year,LinkedHashMap<String,LinkedHashMap<String, String>> scoreMap,boolean isSqlServer){
           year = "".equals(year)?""+Calendar.getInstance().get(Calendar.YEAR):year;
           String idssql = (hrmids!=null&&!"".equals(hrmids))?"AND hrm.id IN("+hrmids+")":"";
           
           ArrayList<Map.Entry<String,LinkedHashMap<String,String>>> mapList=new ArrayList<Map.Entry<String,LinkedHashMap<String,String>>>(scoreMap.entrySet());
           StringBuffer fieldStrSB = new StringBuffer();
           StringBuffer tableStrSB = new StringBuffer();
           String beginSymbol = null;
           String beginscore = null;
           String endSymbol = null;
           String endscore = null;
           for(int i=0;i<mapList.size();i++){
               Entry<String,LinkedHashMap<String,String>> obj=mapList.get(i);
               LinkedHashMap<String,String> curMap = obj.getValue();
               beginSymbol = getSymbol(curMap.get("beginSymbol"));
               beginscore = curMap.get("beginscore");
               endSymbol = getSymbol(curMap.get("endSymbol"));
               endscore = curMap.get("endscore");
               fieldStrSB.append(", t"+i + ".l"+i);
               //如果是sql server数据库
               if(isSqlServer){
                   tableStrSB.append(" LEFT JOIN ( SELECT  gp.userid , "+
                                          "          COUNT(*) l"+i+
                                          "  FROM    GP_AccessScore gp, "+
                                          "          HrmResource hrm "+
                                          "  WHERE   gp.status = 3 "+
                                          "          AND gp.userid = hrm.id "+
                                          "          AND hrm.status<=3 "+
                                          "          AND gp.year = '"+year+"' "+
                                          "          AND gp.type1 = 1 "+
                                          "          AND gp.result"+beginSymbol+"(" +beginscore +"/5*ISNULL((SELECT ISNULL(bs.scoreSetting,5) FROM GP_BaseSetting bs WHERE bs.resourceid=hrm.subcompanyid1 AND bs.resourcetype=1 AND bs.ismonth=1),5)) "+
                                          "          AND gp.result"+endSymbol+"(" +endscore +"/5*ISNULL((SELECT ISNULL(bs.scoreSetting,5) FROM GP_BaseSetting bs WHERE bs.resourceid=hrm.subcompanyid1 AND bs.resourcetype=1 AND bs.ismonth=1),5)) "+
                                          "  GROUP BY gp.userid "+
                                         ") t"+i+" ON hrm.id = t"+i+".userid");
               }else{
                   tableStrSB.append(" LEFT JOIN ( SELECT  gp.userid , "+
                                          "          COUNT(*) l"+i+
                                          "  FROM    GP_AccessScore gp, "+
                                          "          HrmResource hrm "+
                                          "  WHERE   gp.status = 3 "+
                                          "          AND gp.userid = hrm.id "+
                                          "          AND hrm.status<=3 "+
                                          "          AND gp.year = '"+year+"' "+
                                          "          AND gp.type1 = 1 "+
                                          "          AND gp.result"+beginSymbol+"(" +beginscore +"/5*NVL((SELECT NVL(bs.scoreSetting,5) FROM GP_BaseSetting bs WHERE bs.resourceid=hrm.subcompanyid1 AND bs.resourcetype=1 AND bs.ismonth=1),5)) "+
                                          "          AND gp.result"+endSymbol+"(" +endscore +"/5*NVL((SELECT NVL(bs.scoreSetting,5) FROM GP_BaseSetting bs WHERE bs.resourceid=hrm.subcompanyid1 AND bs.resourcetype=1 AND bs.ismonth=1),5)) "+
                                          "  GROUP BY gp.userid "+
                                         ") t"+i+" ON hrm.id = t"+i+".userid");
               }
           }
           String sql = "SELECT  hrm.id id , "+
                   "         hrm.lastname , "+
                   "         cpy.subcompanyname , "+
                   "         dept.departmentname , "+fieldStrSB.substring(1)+
                   " FROM    HrmSubCompany cpy , "+
                   "         HrmDepartment dept , "+
                   "         HrmResource hrm "+tableStrSB.toString()+
                   " WHERE   hrm.departmentid = dept.id "+
                   "         AND hrm.status<=3 "+
                   "         AND dept.subcompanyid1 = cpy.id " + idssql;
           return sql;
       }
   
       /**
        * 获得用户信息
        * @return 
        */
       private LinkedHashMap<String,LinkedHashMap<String, String>> getWorkerResult(weaver.conn.RecordSet rs,String year,int scoreNum) {
           int yearInt = Integer.parseInt(year);
           LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
           String id = null;
           String lastname = null;
           String subcompanyname = null;
           String departmentname = null;
           String monthName = null;
           String monthValue = null;
           LinkedHashMap<String, String> curValues = null;
           
           int currMonth = Calendar.getInstance().get(Calendar.MONTH)+1;
           HashMap<String, String> workerProgramMap = null;
           Calendar cl = null;
           java.text.SimpleDateFormat format = null;
           String tempKey = null;
           while(rs.next()){
               id = null2String(rs.getString("id"));
               lastname = null2String(rs.getString("lastname"));
               subcompanyname = null2String(rs.getString("subcompanyname"));
               departmentname = null2String(rs.getString("departmentname"));
               curValues = new LinkedHashMap<String, String>();
               for(int i=0;i<scoreNum;i++){
                   tempKey = "l" + i;
                   curValues.put(tempKey,null2String(rs.getString(tempKey),"0"));
               }
               curValues.put("id",id);
               curValues.put("lastname",lastname);
               curValues.put("subcompanyname",subcompanyname);
               curValues.put("departmentname",departmentname);

               map.put(id,curValues);
           }
           return map;
       }
    %>
</HTML>