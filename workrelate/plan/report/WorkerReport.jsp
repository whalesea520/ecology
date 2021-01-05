<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ include file="/workrelate/comm/WorkerReportUtil.jsp"%>
<%@ include file="WorkerUtil.jsp"%>
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
          String type = Util.null2String(request.getParameter("type"));
          String hrmids = Util.null2String(request.getParameter("hrmids"));
          String subcompanyids = Util.null2String(request.getParameter("subcompanyids"));
          String departmentids = Util.null2String(request.getParameter("departmentids"));
          String cpyincludesub = null2String(request.getParameter("cpyincludesub"),"3");
          String deptincludesub = null2String(request.getParameter("deptincludesub"),"3");
          int currYear = Calendar.getInstance().get(Calendar.YEAR);
          
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
        <%
        if("month".equals(type)){
        %>
        <!-- 对月报表统计进行处理 -->
        <div>        
            <div class="icons">
                <img src="/workrelate/images/wrstatus0.png"/><label>草稿</label>
                <img src="/workrelate/images/wrstatus1.png"/><label>审批中</label>
                <img src="/workrelate/images/wrstatus2.png"/><label>退回</label>
                <img src="/workrelate/images/wrstatus3.png"/><label>已完成</label>
                <img src="/workrelate/images/wrstatus4.png"/><label>未开始</label>
                <img src="/workrelate/images/wrstatus5.png"/><label>无数据</label>
            </div>
            <table id="workerListTable" class="listTable" cellspacing="0" cellpadding="0" style="width:100%;border-collapse:collapse;">
                <colgroup>
                    <col style="min-width:60px;width:6%;"/>
                    <col style="min-width:100px;width:14%;"/>
                    <col style="min-width:100px;width:14%;"/>
                    <%for(int i=1;i<=12;i++){%>
                        <col style="min-width:50px;width:5%;"/>
                    <%}%>
                    <col style="min-width:50px;width:6%;"/>
                </colgroup>
                <thead>
                    <tr style="text-align:center;">
                        <td style="text-align:left">人员</td>
                        <td style="text-align:left">分部</td>
                        <td style="text-align:left">部门</td>
                        <%for(int i=1;i<=12;i++){%>
                            <td><%=i %>月</td>
                        <%}%>
                        <td>完成率</td>
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
                String sql = getSearchSql(year,"week".equals(type)?"2":"1",pageHrmids);
                rs.execute(sql);
                LinkedHashMap<String,LinkedHashMap<String,String>> map= getWorkerResult(rs);
                
                rs.execute("SELECT hrm.id, "+
                        "          hrm.lastname,"+
                        "          cpy.subcompanyname,"+
                        "          dept.departmentname"+
                        "   FROM   HrmResource hrm,"+
                        "          HrmSubCompany cpy,"+
                        "          HrmDepartment dept"+
                        "   WHERE  hrm.departmentid = dept.id"+
                        "          AND status<=3 "+
                        "          AND dept.subcompanyid1 = cpy.id"+
                        "          AND hrm.id in("+pageHrmids+") order by hrm.dsporder");
                //人员信息集合
                LinkedHashMap<String,LinkedHashMap<String,String>> hrmInfoMap = getHrmInfo(rs);
                int currMonth = Calendar.getInstance().get(Calendar.MONTH)+1;
                if(Integer.parseInt(year) < currYear){
                	currMonth = 12;
                }
                //得到展示数据
                setData(map,hrmInfoMap,currMonth);
                LinkedHashMap<String,String> curMap = null;
                for (Entry<String,LinkedHashMap<String,String>> obj : hrmInfoMap.entrySet()) {
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
                        <td>
                        <img style="margin:5px;" src="<%=getStatusImg(curMap.get(tempMonth)) %>"/>
                        </td>
                     <%}%>
                    <td><%=curMap.get("rate") %></td>
                </tr>
               <%}%>
               <tr style="background:#fff !important;">
                   <td colspan="16" style="background:#fff !important;text-align:right;">
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
        <%}else{
        	int currWeek = Calendar.getInstance().get(Calendar.WEEK_OF_YEAR)-1;
        	if(Integer.parseInt(year) < currYear){
        		currWeek = TimeUtil.getMaxWeekNumOfYear(currYear);
        	}
        	String weekSql = getWeekSearchSql(year,currWeek,pageHrmids);
        	rs.execute(weekSql);
        	LinkedHashMap<String,LinkedHashMap<String, String>> map = getWorkerWeekResult(rs,currWeek);
        %>
         <%
        if(isEmpty(pageHrmids)){
            %>
           <div style="background:#fff !important;">
               <div style="background:#fff !important;text-align:center">无相关数据</div>
           </div>
            <%
            return;
        }%>
            <!-- 对周报表统计进行处理 -->
            <div id="dataContainer" style="overflow:hidden;position:relative;width:99%;"> 
	            <div class="icons">
	                <img src="/workrelate/images/wrstatus0.png"/><label>草稿</label>
	                <img src="/workrelate/images/wrstatus1.png"/><label>审批中</label>
	                <img src="/workrelate/images/wrstatus2.png"/><label>退回</label>
	                <img src="/workrelate/images/wrstatus3.png"/><label>已完成</label>
	                <img src="/workrelate/images/wrstatus5.png"/><label>无数据</label>
	            </div>
                <!-- 左边人员基本信息 -->
                <div id="leftContainer" style="float:left;">
                    <table class="listTable" cellspacing="0" cellpadding="0" style="float:left;border-collapse:collapse;">
                        <colgroup>
                            <col style="width:80px;"/>
                            <col style="width:120px;"/>
                            <col style="width:130px;"/>
                        </colgroup>
                        <thead>
                            <tr style="text-align:center;">
                                <td style="text-align:left">人员</td>
                                <td style="text-align:left">分部</td>
                                <td style="text-align:left;">部门</td>
                            </tr>
                        </thead>
                        <% 
                        LinkedHashMap<String,String> curMap = null;
                        for (Entry<String,LinkedHashMap<String,String>> obj : map.entrySet()) {
                            curMap = obj.getValue();
                            %>
                            <tr style="text-align:center;">
                                <td style="text-align:left"><a onclick="pointerXY(event);" href="javascript:openhrm(<%=obj.getKey()%>);"><%=curMap.get("lastname") %></a></td>
                                <td style="text-align:left"><%=curMap.get("subcompanyname") %></td>
                                <td style="text-align:left"><%=curMap.get("departmentname") %></td>
                            </tr>
                        <%}%>
                    </table>
                </div>
                <!-- 右边周报告提交数据信息 -->
               <div id="rightContainer"" style="float:left;overflow-x:scroll;position:relative;">
                    <div style="width:<%=81*currWeek%>px;">
                        <table class="listTable" cellspacing="0" cellpadding="0" style="float:left;border-collapse:collapse;">
                            <colgroup>
                                <%for(int i=currWeek; i>0;i--){%>
                                    <col style="width:80px;"/>
                                <%}%>
                            </colgroup>
                            <thead>
                                <tr style="text-align:center;">
                                    <%
                                    for(int i=currWeek; i>0;i--){%>
                                        <td style='width:70px;<%=i==currWeek?"border-left:none;":""%>'>第<%=i %>周</td>
                                    <%}%>
                                    
                                </tr>
                            </thead>
                             <%for (Entry<String,LinkedHashMap<String,String>> obj : map.entrySet()) {
                                 curMap = obj.getValue();%>
                                <tr style="text-align:center;">
                                    <%
                                    for(int i=currWeek; i>0;i--){%>
                                        <td style="width:70px;"><img style="margin:5px;" src="<%=getStatusImg(curMap.get("week" + i)) %>"/></td>
                                    <%}%>
                                </tr>
                            <%}%>
                        </table>
                    </div>
                </div>
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
            </div>
            <script type="text/javascript">
            //$("#leftContainer tbody tr:odd").css({"background":"#ECECEC"});
            //$("#rightContainer tbody tr:odd").css({"background":"#ECECEC"});
            if(window.navigator.userAgent.indexOf("Chrome") == -1){
                //$("#rightContainer").niceScroll({cursorcolor:"#D0D6DB",cursorwidth:"10px",cursorborder:"0",cursorborderradius:"5px"});
            }
		    $(document).ready(function(){
			    $("#rightContainer").width($("#dataContainer").width()-$("#leftContainer").width()-4);
		    });
		    $(window).resize(function(){
		        $("#rightContainer").width($("#dataContainer").width()-$("#leftContainer").width()-4);
		    });
		    
		    function setContainerColor(){
	            //$("#rightContainer tbody tr:odd").css({"background":"#ECECEC"});
	            //$("#leftContainer tbody tr:odd").css({"background":"#ECECEC"});
	            $("#rightContainer tbody tr").bind("mouseover",function(){
	            	var index = $("#rightContainer tbody tr").index($(this));
	                $(this).css({"background":"#FAFAFA"});
	                $("#leftContainer tbody tr").eq(index).css({"background":"#FAFAFA"});
	            }).bind("mouseout",function(){
	                //$("#rightContainer tbody tr:odd").css({"background":"#ECECEC"});
	                $("#rightContainer tbody tr").css({"background":"#FFFFFF"});
	                //$("#leftContainer tbody tr:odd").css({"background":"#ECECEC"});
                    $("#leftContainer tbody tr").css({"background":"#FFFFFF"});
	            });
                $("#leftContainer tbody tr").bind("mouseover",function(){
                    var index = $("#rightContainer tbody tr").index($(this));
                    $(this).css({"background":"#FAFAFA"});
                    $("#rightContainer tbody tr").eq(index).css({"background":"#FAFAFA"});
                }).bind("mouseout",function(){
//                 	$("#rightContainer tbody tr:odd").css({"background":"#ECECEC"});
                    $("#rightContainer tbody tr").css({"background":"#FFFFFF"});
//                     $("#leftContainer tbody tr:odd").css({"background":"#ECECEC"});
                    $("#leftContainer tbody tr").css({"background":"#FFFFFF"});
                });
	        }
		    setContainerColor();
		    
            </script>
        <%}%>
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
        if("0".equals(status)){//草稿
            src = "wrstatus0.png";
        }else if("1".equals(status)){//审批中
            src = "wrstatus1.png";
        }else if("2".equals(status)){//退回
            src = "wrstatus2.png";
        }else if("3".equals(status)){//已完成
            src = "wrstatus3.png";
        }else if("n".equals(status) || "-1".equals(status)){//无数据
        	src = "wrstatus5.png";
        }else{//未开始
            src = "wrstatus4.png";
        }
        return "/workrelate/images/"+src;
    }
   
    %>
</HTML>