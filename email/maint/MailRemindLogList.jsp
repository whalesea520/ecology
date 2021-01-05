<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<html>
    <head>
        <link type="text/css" href="/css/Weaver_wev8.css" rel="stylesheet" />
        <script language="javascript" src="/js/weaver_wev8.js"></script>
        <script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
        <script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
        <style type="text/css">
            /*遮罩层*/
            #bgAlpha{position:absolute;top:0;left:0;z-index:100;display:none;width:100%;height:100%;background:#fff;opacity:.3;-ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Opacity=30)";filter:alpha(opacity=30);}
            /*加载样式*/
            #loading{position:absolute;left:35%;background:#fff;top:40%;padding:8px;z-index:20001;height:auto;display:none;border:1px solid #ccc;font-size:12px}
        </style>
    </head>
    <%
        // 总体需要，原因暂时不明
        String imagefilename = "/images/hdReport_wev8.gif";
        String titlename = "titlename";
        String needfav = "1";
        String needhelp = "";
        
        String subject = Util.null2String(request.getParameter("subject"));
        String datetype = Util.null2String(request.getParameter("datetype"));
        String startdate = Util.null2String(request.getParameter("startdate"));
        String enddate = Util.null2String(request.getParameter("enddate"));
        String result = Util.null2String(request.getParameter("result"));
    %>
    <body>
        <!-- 顶部页面右侧按钮及菜单内容   start -->
        <%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
        <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
        <%
        %>
        
        <wea:layout attributes="{layoutTableId:topTitle}">
        	<wea:group context="" attributes="{groupDisplay:none}">
        		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
        			<input class="e8_btn_top middle" onclick="batchDelete()" type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" />
                    <input class="e8_btn_top middle" onclick="emptiedLogs()" type="button" value="<%=SystemEnv.getHtmlLabelName(21434,user.getLanguage()) %>" />
                    <span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
        	        <span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
        		</wea:item>
        	</wea:group>
        </wea:layout>
        
        <!-- 高级搜索 -->
        <div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
         	<form id="weaverForm" name="formmain" method="post" action="MailRemindLogList.jsp">
                <wea:layout type="4col" attributes="{'layoutTableId':'oTable1'}">
                	<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
                        <wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
                        <wea:item>
                            <input type="text" id="subject" name="subject" value="<%=subject%>" style="width: 200px"/>       
                        </wea:item> 
                        
                        <wea:item><%=SystemEnv.getHtmlLabelName(18959,user.getLanguage())%></wea:item>
                        <wea:item>
                            <SELECT name="result" style="width: 100px;">
                              <option value=""  <%if(result.equals("")){%> selected<%}%>>全部</option>
                              <option value="0" <%if(result.equals("0")){%> selected="selected" <%}%>>失败</option>
                              <option value="1" <%if(result.equals("1")){%> selected="selected" <%}%>>成功</option>
                            </SELECT>
                        </wea:item> 
                        
                        <wea:item><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
                        <wea:item>
                            <span>
                                <select id="datetype" name="datetype" onchange="onChangetype(this)" style="width: 100px;">
                                  <option value=""  <%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
                                  <option value="1" <%if(datetype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
                                  <option value="2" <%if(datetype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
                                  <option value="3" <%if(datetype.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
                                  <option value="4" <%if(datetype.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
                                  <option value="5" <%if(datetype.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
                                  <option value="6" <%if(datetype.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
                                </select>     
                            </span>
                            <span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
                                <button class="Calendar" style="height: 16px" type="button" onclick="getDate(startdatespan,startdate)" value="<%=startdate%>"></button>
                                <span id="startdatespan"><%=startdate%></span>
                                <input type="hidden" id="startdate" name="startdate">
                                －
                                <button class="Calendar" style="height: 16px" type="button" onclick="getDate(enddatespan,enddate)" value="<%=enddate%>"></button>
                                <span id="enddatespan"><%=enddate%></span>
                                <input type="hidden" id="enddate" name="enddate">
                            </span>
                        </wea:item>
                     </wea:group>
                     <wea:group context="" attributes="{'Display':'none'}">
                        <wea:item type="toolbar">
                            <input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn"/>
                            <input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
                            <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
                        </wea:item>
                    </wea:group>
                </wea:layout>           
            </form>
        </div>
        <!-- 顶部页面右侧按钮及菜单内容   end -->

        <%
            String language = String.valueOf(user.getLanguage());
            String backFields = " id, result, createtime, sendfrom, sendto, subject, errorInfo ";
            String sqlFrom = " mailWorkRemindLog ";
            String whereclause = " where 1=1 ";
            
            if(!"".equals(subject)){
            	whereclause += " and subject like '%"+subject+"%' ";
            }
            if(!"".equals(startdate)){
            	whereclause += " and createtime >= '" + startdate + "' ";
            }
            if(!"".equals(enddate)){
            	whereclause += " and createtime <= '" + enddate + "' ";
            }
            if(!"".equals(result)){
            	whereclause += " and result = '" + enddate + "' ";
            }
            
            String pageId = "Email:MailRemindLogList";
            
            String operateString = 
                    "<operates width=\"15%\">" + 
        		    "  <popedom transmethod=\"weaver.email.service.EmailWorkRemindService.getMailRemindLogListPopedom\" column=\"id\" otherpara = \"column:result\" ></popedom> " + 
            	    "    <operate href=\"javascript:viewErrorInfo()\" target=\"_self\" text=\"日志详情\" index=\"0\"/>" + 
        		    "</operates>";
            
            String tableString = ""+
            			  "<table tabletype=\"checkbox\" pageId=\""+pageId+"\" pagesize=\""+PageIdConst.getPageSize(pageId, user.getUID(), PageIdConst.EMAIL)+"\">"+
            			  "  <sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlorderby=\"createtime\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\"/>"+
            			  "<head>"+                             
            			     "<col width=\"5%\" text=\"发送结果\" column=\"result\" transmethod=\"weaver.email.service.EmailWorkRemindService.tranResult\" />" + 
            			     "<col width=\"10%\" text=\"发送时间\" column=\"createtime\" orderkey=\"createtime\" />" + 
            			     "<col width=\"10%\" text=\"发件人\" column=\"sendfrom\"  />" + 
            			     "<col width=\"25%\" text=\"收件人\" column=\"sendto\"  />" + 
            			     "<col width=\"30%\" text=\"主题\" column=\"subject\"  />" + 
            			  "</head>" + operateString +
            			  "</table>";
            %>
            <input type="hidden" name="pageId" id="pageId" value="<%=pageId %>">
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>

        <!-- 页面右键菜单 -->
        <%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
        
         <!-- 遮罩层 -->
        <div id="bgAlpha"></div>
        <div id="loading">  
            <span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
            <span id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(33592, user.getLanguage())%></span><!-- 正在执行，请稍候... -->
        </div>

        <script type="text/javascript">
            $(document).ready(function(){
            	$("#topTitle").topMenuTitle({});
				$("#hoverBtnSpan").hoverBtn();
                
                if("<%=datetype%>" == 6){
                    jQuery("#dateTd").show();
                }else{
                    jQuery("#dateTd").hide();
                }
            });
            
            function onChangetype(obj){
                if(obj.value == 6){
                    jQuery("#dateTd").show();
                }else{
                    jQuery("#dateTd").hide();
                }
            }
            
            function viewErrorInfo(id) {
                var dialog = new window.top.Dialog();
                dialog.currentWindow = window;
                dialog.Title = "日志详情";
                dialog.Width = 640;
                dialog.Height = 460;
                dialog.Drag = true;
                dialog.maxiumnable = true;
                dialog.URL = "/email/maint/MailRemindLogOperation.jsp?opt=getErrorInfo&id="+id;
                dialog.show();
            }
            
            function deleteInfo(id){
            	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
                    showLoading(1);
            		jQuery.post("/email/maint/MailRemindLogOperation.jsp?opt=deleteErrorInfo",{"ids":id},function(){
                        showLoading(0);
                        _xtable_CleanCheckedCheckbox(); //重新执行一次，清除之前的选择结果缓存
            			_table.reLoad();
            		});
            	});
            }
            
            function batchDelete(){
            	var id = _xtable_CheckedCheckboxId();
               	if(!id){
            		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>!");
            		return;
            	}
            	if(id.match(/,$/)){
            		id = id.substring(0,id.length-1);
            	}
            	deleteInfo(id);
            }
            
            function emptiedLogs() {
                window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("16631,21434",user.getLanguage())%>?",function(){
                    showLoading(1);
                    jQuery.post("/email/maint/MailRemindLogOperation.jsp?opt=deleteAll",function(){
                        showLoading(0);
                        _xtable_CleanCheckedCheckbox(); //重新执行一次，清除之前的选择结果缓存
                        _table.reLoad();
                    });
                });
            } 
            
            // 遮罩层
           function showLoading(isShow){
               if(isShow==1) {
                    $("#bgAlpha").show();
                    $("#loading").show();
               } else {
                    $("#bgAlpha").hide();
                    $("#loading").hide();   
               }        
            }
        </script>
    </body>
</html>
