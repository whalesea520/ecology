<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<html>
    <head>
        <link type="text/css" href="/css/Weaver_wev8.css" rel="stylesheet" />
        <script language="javascript" src="../../js/weaver_wev8.js"></script>
        <script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
        <script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
        <script language="javascript" src="/js/datetime_wev8.js"></script>
        <script language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
    </head>
    <%
        // 总体需要，原因暂时不明
        String imagefilename = "/images/hdReport_wev8.gif";
        String titlename = "titlename";
        String needfav = "1";
        String needhelp = "";
        
        if (!HrmUserVarify.checkUserRight("message:manager", user)) {
        	response.sendRedirect("/notice/noright.jsp");
        	return;
        }
        
    %>
    <body>
        <!-- 顶部页面右侧按钮及菜单内容   start -->
        <%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
        <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
        <%
            RCMenu += "{" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + ",javascript:addShare(),_self} ";
            RCMenuHeight += RCMenuHeightStep;
            RCMenu += "{" + SystemEnv.getHtmlLabelName(32136, user.getLanguage()) + ",javascript:delShare(),_self} ";
            RCMenuHeight += RCMenuHeightStep;
        %>
        <table id="topTitle" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                </td>
                <td class="rightSearchSpan">
                    <input type="button" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage()) %>" class="e8_btn_top" onclick="addShare()" /><!-- 添加 -->
                    &nbsp;&nbsp;
                    <input type="button" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage()) %>" class="e8_btn_top" onclick="delShare()" /><!-- 批量删除 -->
                    &nbsp;&nbsp;
                    <span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
                </td>
            </tr>
        </table>
        <!-- 顶部页面右侧按钮及菜单内容   end -->

        <form id="weaver" name="frmmain" method="post" action="SocialForbitLogin.jsp">
            <%
                String language = String.valueOf(user.getLanguage());
                String backFields = " id,permissionType,contents,seclevel,seclevelMax,jobtitleid,joblevel,scopeid ";
                String sqlFrom = " social_imForbitLogin ";
                String sql_page = "select pageSize from ecology_pagesize where pageId = 'SocialForbitLogin' and userId="+user.getUID();
				rs.executeSql(sql_page);
				int perpage =0 ;
				if(rs.next()){
					perpage =Util.getIntValue(rs.getString("pageSize"),10);
				}else{
					perpage =10;
				}
                String whereclause = " where 1 = 1 ";
                
                // 每条右侧工具
                String operateString= "<operates width=\"15%\">";
                operateString += "	<operate href=\"javascript:delShareQuick()\" text=\"删除\" target=\"_self\"  index=\"0\"/>";
                operateString += "</operates>";
                
                String tableString=""+
                			  "<table tabletype=\"checkbox\" pageId=\"SocialForbitLogin\" pagesize=\""+perpage+"\">"+
                			  "  <sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlorderby=\"permissionType\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\"/>"+
                			  "<head>"+                             
                					  "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"permissionType\" orderkey=\"permissionType\" otherpara=\""+language+"\" transmethod=\"weaver.social.manager.SocialTransMethod.getPermissionTypeName\"/>"+
                					  "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\" column=\"contents\" otherpara=\"column:permissionType+"+language+"+column:jobtitleid+column:joblevel+column:scopeid\" transmethod=\"weaver.social.manager.SocialTransMethod.getPermissionValueName\"/>"+
                					  "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" otherpara=\"column:permissionType+"+language+"+column:seclevelMax+column:joblevel+column:scopeid\" transmethod=\"weaver.social.manager.SocialTransMethod.getSecLevelName\"/>"+
                			  "</head>"+operateString+
                			  "</table>";
                %>
                <input type="hidden" name="pageId" id="pageId" value="<%="UserRightGroupChat" %>">
                <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
        </form>

        <!-- 页面右键菜单 -->
        <%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>

        <script type="text/javascript">
            $(document).ready(function(){
            	$("#topTitle").topMenuTitle();
            });
            
            var dialog=null;
            
            function closeDialog(){
            	if(dialog)
            		dialog.close();
            }
            
            function addShare(){
            	dialog = new window.top.Dialog();
            	dialog.currentWindow = window;
            	var url = "/social/manager/SocialForbitLoginAdd.jsp?isfromtab=true&itemtype=2&isfromCrmTab=true";
            	dialog.Title = "<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>";
            	
            	dialog.Width = 420;
            	dialog.Height =300;
            	dialog.Drag = true;
            	dialog.URL = url;
            	dialog.show();
            	document.body.click();	
            }
            
            function addShareCallback(){
            	_table.reLoad();
            	dialog.close();
            }
            
            function delShare(){
            	var id = _xtable_CheckedCheckboxId();
            	if(!id){
            		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22346, user.getLanguage())%>!");
            		return;
            	}
            	id = id.substring(0,id.length-1);
            	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(129890, user.getLanguage())%>",function(){
            		jQuery.post("/social/manager/SocialForbitLoginOperation.jsp",{"method":"batchDelete", "id":id},function(){
            			_xtable_CleanCheckedCheckbox();
            			_table.reLoad();
            		});
            	});
            }
            
            function delShareQuick(id){
            	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(129890, user.getLanguage())%>",function(){
            		jQuery.ajax({
	            		url : "/social/manager/SocialForbitLoginOperation.jsp?method=delete&id="+id,
	            		type : "post",
	            		async : false,
	            		complete : function(xhr,status){
	            			_table.reLoad();
	            		}
	            	});
            	})
            }
        </script>
    </body>
</html>
