<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.social.service.SocialOpenfireUtil"%>
<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<html>
    <head>
        <link type="text/css" href="/css/Weaver_wev8.css" rel="stylesheet" />
        <script language="javascript" src="/js/weaver_wev8.js"></script>
        <style type="text/css">
            /*遮罩层*/
            #bgAlpha{  
                 display:none;
                 position: absolute;
                 top:0;
                 left: 0;
                 width: 100%;
                 height:100%;
                 -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=30)"; /*IE8*/
                 filter:alpha(opacity=30);  /*IE5、IE5.5、IE6、IE7*/
                 opacity: 0.3;  /*Opera9.0+、Firefox1.5+、Safari、Chrome*/
                 z-index: 100;  /*让其位于in的下面*/
                 background:#fff;
            }
            /*加载样式*/
            #loading{
                position:absolute;
                left:35%;
                background:#ffffff;
                top:40%;
                padding:8px;
                z-index:20001;
                height:auto;
                display:none;
                border:1px solid #ccc;
                font-size: 12px;
            }
        </style>
        
    </head>
    <%
        // 总体需要，原因暂时不明
        String imagefilename = "/images/hdReport_wev8.gif";
        String titlename = "titlename";
        String needfav = "1";
        String needhelp = "";
        String searchName = Util.null2String(request.getParameter("searchName"));
        
        if (!HrmUserVarify.checkUserRight("message:manager", user)) {
        	response.sendRedirect("/notice/noright.jsp");
        	return;
        }
        
    %>
    <body>
        <jsp:include page="/systeminfo/commonTabHead.jsp">
           <jsp:param name="mouldID" value="social"/>
           <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(20536, user.getLanguage()) %>"/>
        </jsp:include>
    
        <!-- 顶部页面右侧按钮及菜单内容   start -->
        <%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
        <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
        <%
            RCMenu += "{" + SystemEnv.getHtmlLabelName(127254, user.getLanguage()) + ",javascript:forcedOffline(true, 1),_self} ";  //全部下线
            RCMenuHeight += RCMenuHeightStep;
            RCMenu += "{" + SystemEnv.getHtmlLabelName(127255, user.getLanguage()) + ",javascript:forcedOffline(false, 1),_self} ";  //指定下线
            RCMenuHeight += RCMenuHeightStep;
            RCMenu += "{" + SystemEnv.getHtmlLabelName(127284, user.getLanguage()) + ",javascript:forcedOffline(true, 0),_self} ";  //全部清理缓存
            RCMenuHeight += RCMenuHeightStep;
            RCMenu += "{" + SystemEnv.getHtmlLabelName(127285, user.getLanguage()) + ",javascript:forcedOffline(false, 0),_self} ";  //指定清理缓存
            RCMenuHeight += RCMenuHeightStep;
        %>
        <table id="topTitle" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                </td>
                <td class="rightSearchSpan">
                    <input type="button" value="<%=SystemEnv.getHtmlLabelName(127254, user.getLanguage()) %>" class="e8_btn_top" onclick="forcedOffline(true, 1)" /><!-- 强制下线 -->
                    &nbsp;&nbsp;
                    <input type="button" value="<%=SystemEnv.getHtmlLabelName(127255, user.getLanguage()) %>" class="e8_btn_top" onclick="forcedOffline(false, 1)" /><!-- 指定下线 -->
                    &nbsp;&nbsp;
                    <input type="button" value="<%=SystemEnv.getHtmlLabelName(127284, user.getLanguage()) %>" class="e8_btn_top" onclick="forcedOffline(true, 0)" /><!-- 全部清理缓存 -->
                    &nbsp;&nbsp;
                    <input type="button" value="<%=SystemEnv.getHtmlLabelName(127285, user.getLanguage()) %>" class="e8_btn_top" onclick="forcedOffline(false, 0)" /><!-- 指定清理缓存 -->
                    &nbsp;&nbsp;
                    <input type="text" class="searchInput"  id="searchName" name="searchName" value="<%=searchName %>" placeholder="姓名/拼音"/>
                     &nbsp;&nbsp;
                    <span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
                </td>
            </tr>
        </table>
        <!-- 顶部页面右侧按钮及菜单内容   end -->

        <form id="weaver" name="frmmain" method="post" action="SocialSysBroadcastList.jsp">
            <%
                String language = String.valueOf(user.getLanguage());
                String backFields = " hr.id, hr.lastname, hr.departmentid, hr.subcompanyid1, hr.telephone, hr.mobile, sisk.loginStatus, sisk.logindate ";
                String sqlFrom = " HrmResource hr, social_IMSessionkey sisk ";
				String sql_page = "select pageSize from ecology_pagesize where pageId = 'SocialOnlineUserList' and userId="+user.getUID();
				rs.executeSql(sql_page);
				int perpage =0 ;
				if(rs.next()){
					perpage =Util.getIntValue(rs.getString("pageSize"),10);
				}else{
					perpage =10;
				}
                String whereclause ="";                
	            String currentTime = TimeUtil.getCurrentTimeString();
	            String updateTime = TimeUtil.timeAdd(currentTime, -6 * 60 * 60);
	            whereclause = " where hr.id = sisk.userid and sisk.loginStatus > 0 and sisk.socketstatus = 1 and sisk.updateTime >= '"+updateTime+"' ";
                if(!"".equals(searchName)){
                	whereclause += " and (hr.lastname like '%"+searchName+"%' or hr.pinyinlastname like '%"+searchName+"%')";
                }
                
                String tableString=""+
                			  "<table tabletype=\"checkbox\" pageId=\"SocialOnlineUserList\" pagesize=\""+perpage+"\">"+
                			  "  <sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"hr.id\" sqlorderby=\"hr.id\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\"/>"+
                			  "<head>"+                             
                			     "<col width=\"10%\" labelid=\"413\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage()) +"\" column=\"lastname\" orderkey=\"lastname\" linkvaluecolumn=\"id\" linkkey=\"id\" href=\"/hrm/resource/HrmResource.jsp?1=1\" target=\"_fullwindow\" />"+
                			     "<col width=\"10%\" labelid=\"141\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage()) +"\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" href=\"/hrm/company/HrmDepartment.jsp\"  linkkey=\"subcompanyid\" target=\"_fullwindow\"/>"+
                			     "<col width=\"10%\" labelid=\"124\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage()) +"\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" href=\"/hrm/company/HrmDepartmentDsp.jsp\" linkkey=\"id\" target=\"_fullwindow\"/>"+
                			     "<col width=\"10%\" labelid=\"421\" text=\""+SystemEnv.getHtmlLabelName(421,user.getLanguage()) +"\" column=\"telephone\" orderkey=\"telephone\"/>"+
                			     "<col width=\"10%\" labelid=\"620\" text=\""+SystemEnv.getHtmlLabelName(620,user.getLanguage()) +"\" column=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMobileShow\" otherpara=\""+user.getUID()+"\" />"+
                			     "<col width=\"10%\" labelid=\"108\" text=\""+SystemEnv.getHtmlLabelName(108,user.getLanguage()) +"\" column=\"loginStatus\" transmethod=\"weaver.social.manager.SocialTransMethod.getClientTypeName\" />"+
                			     "<col width=\"10%\" labelid=\"1276\" text=\""+SystemEnv.getHtmlLabelName(1276,user.getLanguage()) +"\" column=\"logindate\" />"+
                			  "</head>"+
                			  "</table>";
                %>
                <input type="hidden" name="pageId" id="pageId" value="<%="SocialOnlineUserList" %>">
                <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
        </form>

        <!-- 页面右键菜单 -->
        <%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
        
         <!-- 遮罩层 -->
        <div id=bgAlpha></div>
        <div id="loading">  
            <span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
            <span id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(33592, user.getLanguage())%></span><!-- 正在执行，请稍候... -->
        </div>

        <script type="text/javascript">
            $(document).ready(function(){
            	$("#topTitle").topMenuTitle({searchFn:searchName});
				$("#hoverBtnSpan").hoverBtn();
            });
            
            function searchName(){
				var searchName = jQuery("#searchName").val();
				location.href = "SocialOnlineUserList.jsp?searchName="+searchName;
			}
            
            // flag : true:全部下线或全部
            function forcedOffline(flag, clearType){
                var ids = '';
                if(!flag) {
                    var ids = _xtable_CheckedCheckboxId();
                    if(!ids){
                        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25763, user.getLanguage())%>");  // 对不起，请选择人员!
                        return;
                    }
                    ids = ids.substring(0, ids.length-1);
                }
                var msg = '';
                if(clearType == 0) {
                    msg = '<%=SystemEnv.getHtmlLabelName(127283, user.getLanguage())%>';  // 确定要执行清理缓存操作？
                } else if(clearType == 1) {
                    msg = '<%=SystemEnv.getHtmlLabelName(127211, user.getLanguage())%>';  // 确定要执行强制下线操作？
                }
                
                window.top.Dialog.confirm(msg, function(){  
                    showLoading(1);
                    $.post('/social/im/SocialIMOperation.jsp', { operation : 'forcedOfflineUsers', ids : ids, clearType : clearType }, function(data){
                        data = $.trim(data);
                        showLoading(0);
                        if(data == 1) {
                            window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(30700, user.getLanguage())%>', function(){  // 操作成功
                                window.location.reload();
                            });
                        } else {
                            window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(30651, user.getLanguage())%>', function(){  //操作失败
                                window.location.reload();
                            });
                        }
                    });
                });
            	
            	document.body.click();	
            }
            
            // 遮罩层
           function showLoading(isShow){
               if(isShow==1){
                    $("#bgAlpha").show();
                    $("#loading").show();
               }else{
                    $("#bgAlpha").hide();
                    $("#loading").hide();   
               }        
            }
        </script>
    </body>
</html>
