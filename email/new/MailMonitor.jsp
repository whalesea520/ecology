<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML>
<head>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = "" + SystemEnv.getHtmlLabelName(16218,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    
    if(!HrmUserVarify.checkUserRight("Email:monitor",user)){
    	response.sendRedirect("/notice/noright.jsp") ;
    }
%>
    <link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="/js/weaver_wev8.js"></script>
    
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDelete(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(24622,user.getLanguage())+",javascript:showLog(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    
    <style type="text/css">
        /*遮罩层*/
        #bgAlpha{display:none;position:absolute;top:0;left:0;width:100%;height:100%;-ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Opacity=50)";filter:alpha(opacity=50);opacity:.5;z-index:100;background:#fff}
        /*加载样式*/
        #loading{position:absolute;left:35%;background:#fff;top:40%;padding:8px;z-index:20001;height:auto;display:none;border:1px solid #ccc;font-size:12px}
    </style>
    <script type="text/javascript">
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
</head>

<%
    String resource = Util.null2String(request.getParameter("resource"));
    String subject = Util.null2String(request.getParameter("subject"));
    String mailtype = Util.null2String(request.getParameter("mailtype"));
    String startsize = Util.null2String(request.getParameter("startsize"));
    String endsize = Util.null2String(request.getParameter("endsize"));
    String datetype = Util.null2String(request.getParameter("datetype"));
    String startdate = Util.null2String(request.getParameter("startdate"));
    String enddate = Util.null2String(request.getParameter("enddate"));

    String sqlWhere="id !=0 ";
    
    if(!"".equals(resource)){
    	sqlWhere += " and resourceid = '"+resource+"'";
    }
    if(!"".equals(subject)){
    	sqlWhere += " and subject like '%"+subject+"%'";
    }
    if("1".equals(mailtype)){//内部邮件
    	sqlWhere += " and isInternal = 1";
    }
    if("2".equals(mailtype)){//外部邮件
    	sqlWhere += " and (isInternal IS NULL OR  isInternal != 1)";
    }
    if(!"".equals(startsize)){
    	float size = Util.getFloatValue(startsize)*1024*1024;
    	sqlWhere += " and size_n >= "+size;
    }
    if(!"".equals(endsize)){
    	float size = Util.getFloatValue(endsize)*1024*1024;
    	sqlWhere += " and size_n <= "+size;
    }
    if(!"".equals(datetype) && !"6".equals(datetype)){
    	sqlWhere += " and senddate >= '"+TimeUtil.getDateByOption(datetype+"","0")+" 00:00:00'";
    	sqlWhere += " and senddate <= '"+TimeUtil.getDateByOption(datetype+"","")+" 23:59:59'";
    }
    if("6".equals(datetype) && !"".equals(startdate)){
    	sqlWhere += " and senddate >= '"+startdate+" 00:00:00'";
    }
    if("6".equals(datetype) && !"".equals(enddate)){
    	sqlWhere += " and senddate <= '"+enddate+" 23:59:59'";
    }
    sqlWhere +=" and canview=1";
    String backfields = "id , resourceid , senddate , subject , size_n";
    String fromSql ="MailResource";
    
    sqlWhere = Util.toHtmlForSplitPage(sqlWhere);
    String orderby = "id";
    String operateString= "<operates width=\"15%\">";
    	operateString+=" <popedom transmethod=\"weaver.email.MailSettingTransMethod.getMailMonitorPopedom\" column=\"id\"></popedom> ";
        operateString+="     <operate href=\"javascript:deleteInfo()\" target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"   index=\"0\"/>";
    	operateString+="</operates>";
    String tableString =" <table instanceid=\"readinfo\" tabletype='checkbox'  pageId=\""+PageIdConst.Email_Monitor+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_Monitor,user.getUID(),PageIdConst.EMAIL)+"\" >"+ 
           "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+sqlWhere+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\"/>"+
           "<head>"+
           "<col width=\"15%\"  target=\"_blank\" text=\""+ SystemEnv.getHtmlLabelName(83117,user.getLanguage()) +"\" column=\"resourceid\""+
      		" orderkey=\"resourceid\" href=\"/hrm/resource/HrmResource.jsp?1=1\"  linkkey=\"id\"  transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"  />"+
           "<col width=\"50%\"  text=\""+ SystemEnv.getHtmlLabelName(344,user.getLanguage()) +"\" column=\"subject\""+
           " transmethod=\"weaver.email.MailSettingTransMethod.getMailSubject\"/>"+ 
    	   "<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(277,user.getLanguage()) +"\" column=\"senddate\" />"+ 
    	   "<col width=\"15%\"  text=\""+ SystemEnv.getHtmlLabelName(2036,user.getLanguage()) +"\" column=\"size_n\""+
    	   		" transmethod=\"weaver.email.MailSettingTransMethod.getMailSize\"/>"+ 
    	   "</head>"+operateString+   			
    	   "</table>";			
%>

<body>
    <wea:layout attributes="{layoutTableId:topTitle}">
    	<wea:group context="" attributes="{groupDisplay:none}">
    		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
    			<input class="e8_btn_top middle" onclick="batchDelete()" type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
    			<input class="e8_btn_top middle" onclick="showLog()" type="button" value="<%=SystemEnv.getHtmlLabelName(24622,user.getLanguage()) %>"/>
    			<input type="text" class="searchInput"  id="searchName" name="searchName" 
    				value="<%=subject %>" />
    			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
    			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
    		</wea:item>
    	</wea:group>
    </wea:layout>

    <!-- 高级搜索 -->
    <div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
    <form id="frmmain" name="frmmain" action="MailMonitor.jsp" method="post">
    	<wea:layout type="4col" attributes="{'layoutTableId':'oTable1'}">
    			<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
    				<wea:item><%=SystemEnv.getHtmlLabelName(83117,user.getLanguage())%></wea:item>
    		        <wea:item>
    		        	<brow:browser viewType="0" name="resource" 
    			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
    			         browserValue='<%=resource%>' 
    			         browserSpanValue = '<%=ResourceComInfo.getResourcename(resource)%>'
    			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
    			         completeUrl="/data.jsp" width="200px" ></brow:browser>        
    		        </wea:item> 
    		        
    		        <wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
    		        <wea:item>
    		        	<input type="text" id="subject" name="subject" value="<%=subject%>" style="width: 200px"/>       
    		        </wea:item> 
    		        
    		        <wea:item><%=SystemEnv.getHtmlLabelName(18959,user.getLanguage())%></wea:item>
    		        <wea:item>
    		        	<SELECT  name="mailtype"  style="width: 100px;">
    					  <option value="" 	<%if(mailtype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
    					  <option value="1" <%if(mailtype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(24714,user.getLanguage())%></option>
    					  <option value="2" <%if(mailtype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(31139,user.getLanguage())%></option>
    					</SELECT>
    		        </wea:item> 
    		        
    		        <wea:item><%=SystemEnv.getHtmlLabelName(2036,user.getLanguage())%></wea:item>
    		        <wea:item>
    		        	<input type="text" id="startsize" name="startsize" value="<%=startsize%>" style="width: 50px;"/>M 
    		        	－    
    		        	<input type="text" id="endsize" name="endsize" value="<%=endsize%>" style="width: 50px;"/>M   
    		        </wea:item> 
    		        
    		        <wea:item><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
    		        <wea:item>
    		        	<span>
    			        	<SELECT  id="datetype" name="datetype" onchange="onChangetype(this)" style="width: 100px;">
    						  <option value="" 	<%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
    						  <option value="1" <%if(datetype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
    						  <option value="2" <%if(datetype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
    						  <option value="3" <%if(datetype.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
    						  <option value="4" <%if(datetype.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
    						  <option value="5" <%if(datetype.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
    						  <option value="6" <%if(datetype.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
    						</SELECT>     
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
    <input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_Monitor%>">	
    <wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" />
    
    <!-- 遮罩层 -->
    <div id=bgAlpha></div>
    <div id="loading">  
        <span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
        <span id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(33592, user.getLanguage())%></span><!-- 正在执行，请稍候... -->
    </div>

    <script type="text/javascript">
        function deleteInfo(id){
        	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
                showLoading(1);
        		jQuery.post("MailMonitorOperation.jsp",{"ids":id},function(){
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
        
        function searchName(){
        	var searchName = jQuery("#searchName").val();
        	jQuery("#subject").val(searchName);
        	frmmain.submit();
        }	
        
        function onChangetype(obj){
        	if(obj.value == 6){
        		jQuery("#dateTd").show();
        	}else{
        		jQuery("#dateTd").hide();
        	}
        }
        
        function showLog(){
        	dialog = new window.top.Dialog();
        	dialog.currentWindow = window;
        	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("367,31704",user.getLanguage()) %>";
        	dialog.Width = 800;
        	dialog.Height = 630;
        	dialog.Drag = true;
        	dialog.maxiumnable = true;
        	dialog.URL = "/email/new/MailMonitorLog.jsp";
        	dialog.show();
        }
        
        jQuery(function(){
        	jQuery("#topTitle").topMenuTitle({searchFn:searchName});
        	jQuery("#hoverBtnSpan").hoverBtn();
        	if("<%=datetype%>" == 6){
        		jQuery("#dateTd").show();
        	}else{
        		jQuery("#dateTd").hide();
        	}
        });
    </script>
    </body>
        <script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
        <script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
        <script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
        <script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</html>
