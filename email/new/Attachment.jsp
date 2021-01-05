<%@page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.email.service.MailManagerService"%> 
<%@taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<head>
    <LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET />
    <SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
    <style>
        a { cursor: pointer; }
    </style>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(27105,user.getLanguage())+",javascript:batchdownload(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(2029,user.getLanguage())+",javascript:sendmail(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(156,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(426,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
    String basepath = Util.getRequestHost(request);
    String filename = Util.null2String(request.getParameter("filename"));
    String subject = Util.null2String(request.getParameter("subject"));
    String startdate = Util.null2String(request.getParameter("startdate"));
    String enddate = Util.null2String(request.getParameter("enddate"));
    String datetype = Util.null2String(request.getParameter("datetype"));

    String userid=""+user.getUID();
    String resourceids=MailManagerService.getAllResourceids(userid);
    String backfields = "mrf.id , mrf.mailid, mrf.filename ,mrf.filesize filesize , mrf.filerealpath, mr.senddate ,mr.subject , mr.folderId";
    String fromSql ="MailResourceFile mrf LEFT JOIN MailResource mr ON mrf.mailid = mr.id";
    String sqlWhere="mr.resourceid  in ("+resourceids+") and filetype='application/octet-stream' and mr.canview=1";
    if(!"".equals(filename)){
    	sqlWhere += " and mrf.filename like '%"+filename+"%'";
    }
    if(!"".equals(subject)){
    	sqlWhere += " and mr.subject like '%"+subject+"%'";
    }
    
    if(!"".equals(datetype) && !"6".equals(datetype)){
    	sqlWhere += " and senddate >= '"+TimeUtil.getDateByOption(datetype+"","0")+" 00:00:00'";
    	sqlWhere += " and senddate <= '"+TimeUtil.getDateByOption(datetype+"","")+" 00:00:00'";
    }
    
    if("6".equals(datetype) && !"".equals(startdate)){
    	sqlWhere += " and senddate > '"+startdate+" 00:00:00'";
    }
    
    if("6".equals(datetype) && !"".equals(enddate)){
    	sqlWhere += " and senddate < '"+enddate+" 23:59:59'";
    }

    sqlWhere = Util.toHtmlForSplitPage(sqlWhere);
    String orderby = "mr.senddate";
    String tableString =" <table instanceid=\"readinfo\" tabletype='checkbox'  pageId=\""+PageIdConst.Email_Attachment+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_Attachment,user.getUID(),PageIdConst.EMAIL)+"\" >"+ 
           "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+sqlWhere+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"mrf.id\" sqlsortway=\"Desc\"/>"+
           "<head>"+
           "<col width=\"25%\"  text=\""+ SystemEnv.getHtmlLabelName(23752,user.getLanguage()) +"\" column=\"filename\""+
           			" transmethod=\"weaver.email.MailSettingTransMethod.getFileName\" otherpara=\"column:id\"/>"+ 
    	   "<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(344,user.getLanguage()) +"\" column=\"subject\""+
    	   			" transmethod=\"weaver.email.MailSettingTransMethod.getEmailName\" otherpara=\"column:mailid+column:folderId\"/>"+ 
    	   "<col width=\"10%\"  text=\""+ SystemEnv.getHtmlLabelName(2036,user.getLanguage()) +"\" column=\"filesize\""+
    	   		    " transmethod=\"weaver.email.MailSettingTransMethod.getFileSize\" />"+ 
    	   "<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(277,user.getLanguage()) +"\" column=\"senddate\"/>"+
    	   "</head>"+   			
    	   "</table>";			
%>
<%
    int totalAttachmentSize = 50;
    int attachmentCount = 5;
    rs.execute("select * from MailConfigureInfo");
    while(rs.next()){
    	totalAttachmentSize = Util.getIntValue(rs.getString("totalAttachmentSize"),50);
    	attachmentCount = Util.getIntValue(rs.getString("attachmentCount"),5);
    }
    
    float space = totalAttachmentSize;
    rs.execute("select totalSpace , occupySpace from HrmResource where id = "+user.getUID());
    if(rs.next()){
        space =  Util.getFloatValue(rs.getString("totalSpace"), 0f) - Util.getFloatValue(rs.getString("occupySpace"), 0f);
    	space = Math.min(space , totalAttachmentSize);
    }
%>
    <script type="text/javascript">
        $(function(){
        	jQuery("#topTitle").topMenuTitle({searchFn:doSearch});
        	jQuery("#hoverBtnSpan").hoverBtn();
        	
        	if("<%=datetype%>" == 6){
        		jQuery("#dateTd").show();
        	}else{
        		jQuery("#dateTd").hide();
        	}
        });
    	
    	function batchdownload(){
    		var fileid = _xtable_CheckedCheckboxId();
    		if(fileid.split(",").length < 2){
    			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32153,user.getLanguage()) %>");
    			return;
    		}
    	
    		fileid = fileid.substring(0,fileid.length-1);
    		location.href =  "/weaver/weaver.email.FileDownloadLocation?fileid="+fileid+"&download=1";
    		$("body").trigger("click");
    	}
    	
    	function downloadFile(fileid){
    		location.href =  "/weaver/weaver.email.FileDownloadLocation?fileid="+fileid+"&download=1";
    	}
    	
    	function sendmail(){
    		var fileid = _xtable_CheckedCheckboxId();
    		if(<%=space%> < 0){
    			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83075,user.getLanguage()) %>");
    			return;
    		}
    		
    		if(fileid.split(",").length < 2){
    			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32153,user.getLanguage()) %>");
    			return;
    		}
    		
    		if(fileid.split(",").length > <%=attachmentCount+1%>){
    			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83076,user.getLanguage())%><%=attachmentCount%><%=SystemEnv.getHtmlLabelName(83077,user.getLanguage())%>");
    			return;
    		}
    		fileid = fileid.substring(0,fileid.length-1);
    		jQuery.post("AttachmentOperation.jsp",{"operation":"getSize","mailfileid":fileid},function(total){
    			if(total > <%=space * 1024 *1024%>){
    				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83078,user.getLanguage())%>"+(parseFloat(total/1024) - parseFloat(<%=space*1024%>)).toFixed(2)+"KB");
    				return;
    			}
    			var url = "/email/new/MailInBox.jsp?fileid="+fileid+"&opNewEmail=1";
    			openFullWindowHaveBar(url);
    		});
    	}
    	
    	function showDetail(mailid , folderid){
    		var url ="/email/new/MailView.jsp?flag=3&mailid="+mailid+"&folderid=0&loadjquery=1";
    		openFullWindowForXtable("/email/new/MailInBox.jsp?mailid="+mailid);
    	}
    	
    	function doSearch(){
    		$("#filename").val($("#keyword").val());
    		frmmain.submit();
    	}
    	
    	function onChangetype(obj){
    		if(obj.value == 6){
    			jQuery("#dateTd").show();
    		}else{
    			jQuery("#dateTd").hide();
    		}
    	}
    </script>
</head>
  
 <body>
    <form id="frmmain" name="frmmain" action="/email/new/Attachment.jsp" method="post">
         <table id="topTitle" cellpadding="0" cellspacing="0">
        	<tr>
        		<td>
        		</td>
        		<td class="rightSearchSpan" style="text-align:right;">
        			<input type=button class="e8_btn_top" onclick="batchdownload()" value="<%=SystemEnv.getHtmlLabelName(32407, user.getLanguage())%>"></input>
        			<input type=button class="e8_btn_top" onclick="sendmail()" value="<%=SystemEnv.getHtmlLabelName(2029,user.getLanguage())%>"></input>
        		    <input type="text" class="searchInput" name="keyword" id="keyword"  value="<%=filename %>" onchange="setKeyword('flowTitle','subject','frmmain');"/>
             		<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
        			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
        		</td>
        		<td>
        		</td>
        	</tr>
        </table>

        <!-- 高级搜索 -->
        <div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
        	<wea:layout type="4col" attributes="{'layoutTableId':'oTable1'}">
    			<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
    				<wea:item><%=SystemEnv.getHtmlLabelName(23752,user.getLanguage())%></wea:item>
    		        <wea:item>
    		        	<input type="text" id="filename" name="filename" value="<%=filename%>" style="width: 200px"/>       
    		        </wea:item> 
    		        
    		        <wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
    		        <wea:item>
    		        	<input type="text" id="subject" name="subject" value="<%=subject%>" style="width: 200px"/>       
    		        </wea:item> 
    		        
    		        <wea:item><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
    		        <wea:item>
    		        	<span>
    			        	<SELECT  name="datetype" id="datetype" onchange="onChangetype(this)" style="width: 100px;">
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
    						-
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
        </div>
    </form>
        <input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_Attachment%>">	
        <wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" />

    <script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
    <script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</html>
