
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.MessageFormat"%>
<%@page import="weaver.blog.AppDao"%>
<%@page import="weaver.blog.AppVo"%>
<%@page import="weaver.blog.AppItemVo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="blogDao" class="weaver.blog.BlogDao"></jsp:useBean>
<%
SimpleDateFormat dateFormat1=new SimpleDateFormat("yyyy-MM-dd");
Date today=new Date();
String curDate=dateFormat1.format(today);
SimpleDateFormat dateFormat2=new SimpleDateFormat("M月dd日");
Map map=blogDao.getNotes(""+user.getUID());
String content=(String)map.get("content");
%>
<div class="reportItem" tid="0" forDate="<%=curDate%>" isToday="true">
				<table width="100%">
					<colgroup>
						<col width="60px;">
					</colgroup>
					<tr>
						<td valign="top">
								<div class="discussView" style="display: none;"></div>
								<div class="editor" style="display:block;margin-top:8px;padding-left:8px;">
									<table style="width:100%"  cellpadding="0" cellspacing="0">
										<tr>
											<td>
											 <textarea name="submitText" id="notepadTextarea" scroll="none" style="border: solid 1px;"><%=content%></textarea>
											</td>
										</tr>
										<tr>
											<td>
												<div class="appItem_bg">
												
												<div style="float:left;vertical-align: middle;margin-right:5px;" >
												 		<button type="button" class="submitButton" onclick="saveNotepad(this)"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
														<button type="button" class="editCancel" onclick="saveAsBlog(this);" value="<%=SystemEnv.getHtmlLabelName(33848,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(33848,user.getLanguage())%></button>
												 </div>
												
										   	    <%
										   	    	AppDao appDao=new AppDao();
											   	    List appVoList=appDao.getAppVoList();
											   	 	List appItemVoList = appDao.getAppItemVoList("mood");
											   	 	String attachmentDir=blogDao.getAttachmentDir(); //附件上传目录
											   	 	for(int i=0;i<appVoList.size();i++){
											   	 		AppVo appVo=(AppVo)appVoList.get(i);
											   	 		if("mood".equals(appVo.getAppType())){
											   	 		if(appItemVoList!=null&&appItemVoList.size()>0){ 
													   		AppItemVo appItemVo1=(AppItemVo)appItemVoList.get(0);
													   		
													   		String itemType1=appItemVo1.getType();
											  				String itemName1=appItemVo1.getItemName();
											  				if(itemType1.equals("mood"));
											  				   itemName1=SystemEnv.getHtmlLabelName(Util.getIntValue(itemName1),user.getLanguage());
												 %>
												   <!-- 心情 -->
												   <div class="optItem" style="width:50px;position: relative;margin-left:5px;">
													  <div id="mood_title" class="opt_mood_title" style="background: url('<%=appItemVo1.getFaceImg()%>') no-repeat left center;"  onclick="show_select('mood_title','mood_items','qty_<%=appItemVo1.getType() %>','mood',event,this)">
													    <a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(26920,user.getLanguage())%></a><!-- 心情 -->
													  </div>
													  <div id="mood_items" style="display:none" class="opt_items">
													  		<%
													  			for(int j=0;j<appItemVoList.size();j++) {
													  				AppItemVo appItemVo= (AppItemVo)appItemVoList.get(j);
													  				String itemType=appItemVo.getType();
													  				String itemName=appItemVo.getItemName();
													  				if(itemType.equals("mood"));
													  				   itemName=SystemEnv.getHtmlLabelName(Util.getIntValue(itemName),user.getLanguage());
													  		%>
														   		<div class='qty_items_out'  val='<%=appItemVo.getId() %>'><img src="<%=appItemVo.getFaceImg() %>" alt="<%=itemName%>" width="16px" align="absmiddle" style="margin-right:3px;margin-left:2px"><%=itemName%></div>
														   <%} %>
													  </div> 
													  <input name="qty_<%=appItemVo1.getType() %>" class="qty" type="hidden" id="qty_<%=appItemVo1.getType() %>" value="<%=appItemVo1.getId() %>" />
												   </div>
													
											   	 <%} 
										   	   }else if("attachment".equals(appVo.getAppType())){
										   	 %>
										   	    <!-- 附件 -->
										   	    <div class="optItem" style="width: 120px;position: relative;">
												  <div id="temp_title" style="width: 120px" class="opt_title" onclick="openApp(this,'')">
												   <%
												   if(attachmentDir!=null&&!attachmentDir.trim().equals("")){ 
													   RecordSet recordSet=new RecordSet();
													   recordSet.executeSql("select maxUploadFileSize from DocSecCategory where id="+attachmentDir);
													   recordSet.next();
													   String maxsize = Util.null2String(recordSet.getString(1));
												   %>
												    <a href="javascript:void(0)"><div class="uploadDiv" mainId="" subId="" secId="<%=attachmentDir%>" maxsize="<%=maxsize%>"></div></a>
												   <%}else{ %>
												    <span style="color: red"><%=SystemEnv.getHtmlLabelName(83157,user.getLanguage()) %></span>
												   <%} %>
												  </div>
											  </div>
										   	 <%}else{ %>
												  <div class="optItem">
													  <div class="title" style="background: url('<%=appVo.getIconPath() %>') no-repeat left center;" class="opt_title" onclick="openApp(this,'<%=appVo.getAppType() %>')">
													    <a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(Integer.parseInt(appVo.getName()),user.getLanguage()) %></a>
													  </div>
										
												  </div>
											  <%}} %>
											  	 <div id="remindSpan" style='float: right;color: red;background: yellow;padding: 3px;display:none;'></div>
												 <div class="clear"></div>
											</div>
									</td>
								</tr>
							</table>			 
						</td>
					</tr>
				</table>
	</div>

	
	
	
	
