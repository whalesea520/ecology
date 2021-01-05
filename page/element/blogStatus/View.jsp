
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/element/viewCommon.jsp"%>

<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="weaver.blog.BlogReplyVo"%>
<%@page import="java.text.MessageFormat"%>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<%@ include file="common.jsp"%>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<style>
  .blogContent{margin-top: 5px;clear:both;background: #f8f8f8; border-bottom: #dcdcdc 1px solid; border-left: #dcdcdc 1px solid; border-top: #dcdcdc 1px solid; border-right: #dcdcdc 1px solid; padding-bottom: 5px; padding-left: 5px; padding-right: 2px; padding-top: 2px;}
  .blogContent p{margin:0px}
</style>
<%
	String  blog_showNum="10";
	String 	blog_isCreatedate="1";
	String 	blog_isRelatedName="1";
	String sql="select name,value from hpelementsetting where eid='"+eid+"'";
	rs_Setting.execute(sql);
	while(rs_Setting.next()){
		String name=rs_Setting.getString("name");
		if(name.equals("blog_showNum"))
			blog_showNum=rs_Setting.getString("value");
		else if(name.equals("blog_isCreatedate"))
			blog_isCreatedate=rs_Setting.getString("value");
		else if(name.equals("blog_isRelatedName"))
			blog_isRelatedName=rs_Setting.getString("value");
	}
	
	if(!Pattern.matches("^\\d+$",blog_showNum)){
		blog_showNum="10";
	}
	String showType=Util.null2String(request.getParameter("showType"));
	if("".equals(showType))
		showType="all";
	BlogDao blogDao=new BlogDao();    
    List commentList=blogDao.getBlogStatusRemidList(user,"comment",blog_showNum);
    List remindList=blogDao.getBlogStatusRemidList(user,"remind",blog_showNum);
    List updateList=blogDao.getBlogStatusRemidList(user,"update",blog_showNum);
    
    Map map=blogDao.getReindCount(user);
    int commentCount=((Integer)map.get("commentCount")).intValue();
    int remindCount=((Integer)map.get("remindCount")).intValue();
    int updateCount=((Integer)map.get("updateCount")).intValue();
    
    String mainTypes[]={"update","comment","remind"};
    int counts[]={updateCount,commentCount,remindCount};
    
    for (int i = 0; i < counts.length; i++) {    
      for (int j = i + 1; j <counts.length; j++) {    
    	if (counts[i] <counts[j]) {    
    	     int temp = counts[i]; 
    	     counts[i] = counts[j];    
    	     counts[j] = temp;    
    	     
    	     String tempType=mainTypes[i];
    	     mainTypes[i]=mainTypes[j];
    	     mainTypes[j]=tempType;
    	    }    
    	}    
    }    
    
	SimpleDateFormat frm1=new SimpleDateFormat("MM月dd日");
	SimpleDateFormat frm2=new SimpleDateFormat("yyyy-MM-dd");
	
	String selectTab="";
%>
<div id="tabContainer_<%=eid%>"  class="tab2">
   <table height="32px" border="0" cellpadding="0" cellspacing="0">
     <tr>
      <%
      for(int i=0;i<mainTypes.length;i++){
    	String mainType=mainTypes[i];
    	int size=counts[i]; 
    	if(i==0)
    		selectTab=mainType;
      %>
       <%if(mainType.equals("remind")){%>
         <td  onclick="showRemind(this,<%=eid%>,'<%=mainType%>')" <%=i==0?"class='tab2selected'":"class='tab2unselected'"%> id="<%=eid%>_remind"><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%><%=size>0?"("+size+")":""%></td><!-- 提醒 -->
       <%}else if(mainType.equals("comment")){ %>  
         <td onclick="showRemind(this,<%=eid%>,'<%=mainType%>')" <%=i==0?"class='tab2selected'":"class='tab2unselected'"%> id="<%=eid%>_comment"><%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%><%=size>0?"("+size+")":""%></td><!-- 评论 -->
       <%}else if(mainType.equals("update")){ %>  
         <td onclick="showRemind(this,<%=eid%>,'<%=mainType%>')" <%=i==0?"class='tab2selected'":"class='tab2unselected'"%> id="<%=eid%>_update"><%=SystemEnv.getHtmlLabelName(17744,user.getLanguage())%><%=size>0?"("+size+")":""%></td><!-- 更新 -->
       <%} %>
      <% } %>   
     </tr>
   </table>
</div>


<%
   for(int i=0;i<mainTypes.length;i++){
      String mainType=mainTypes[i];
      List resultList=null;
      if(mainType.equals("remind"))
    	  resultList=remindList;
      else if(mainType.equals("comment"))
    	  resultList=commentList;
      else if(mainType.equals("update"))
    	  resultList=updateList;
%>  
<TABLE  class="<%=eid%>_blogStatus_table" width="100%" id='<%=eid+"_table_"+mainType%>' style="display:<%=i==0?"":"none"%>">
<TR vAlign=center>
<TD vAlign=center width=1></TD>
<TD vAlign=top width=* id='<%=eid+"_td_"+mainType%>'>
	<TABLE width="100%">     
<%
	  for(int j=0;j<resultList.size();j++){
		map=(Map)resultList.get(j);  
		String id=(String)map.get("id");  
		String remindType=(String)map.get("remindType");
		String relatedid=(String)map.get("relatedid");
		String createdate=(String)map.get("createdate");
		String remindValue=(String)map.get("remindValue");
	 %>
	 <!-- 关注申请 -->
	  <%if("1".equals(remindType)){%>
		   <TR height=18>
				<TD width=8><IMG name=esymbol src="/page/resource/userfile/image/ecology8/pointer_wev8.png"></TD>
				<TD  width=*>
				    <!-- 向你申请关注 -->
					<A href="javascript:openRemind(<%=eid%>,'<%=mainType%>','sysremind')">
					    <FONT class=font><%=ResourceComInfo.getLastname(relatedid)%><%=SystemEnv.getHtmlLabelName(26988,user.getLanguage())%></FONT>
					</A> 
				</TD>
				<td width="70" style="display:<%=blog_isRelatedName.equals("1")?"":"none"%>"><%=ResourceComInfo.getLastname(relatedid) %></td>
				<td width="76" style="display:<%=blog_isCreatedate.equals("1")?"":"none"%>"><%=createdate%></td>
			</TR>
			<TR class=sparator style="height:1px" height=1 ><TD colSpan=4 style='padding:0px'></TD></TR>
		<%} %>
		<!-- 申请同意 -->
		<%if("2".equals(remindType)){%>
		   <TR height=18>
				<TD width=8><IMG name=esymbol src="/page/resource/userfile/image/ecology8/pointer_wev8.png"></TD>
				<TD  width=*>
				   <!-- 接受了你的关注申请 -->
				   <A href="javascript:openRemind(<%=eid%>,'<%=mainType%>','sysremind')">
					    <FONT class=font><%=ResourceComInfo.getLastname(relatedid)%><%=SystemEnv.getHtmlLabelName(26989,user.getLanguage())%></FONT>
				   </A> 
				</TD>
				<td width="70" style="display:<%=blog_isRelatedName.equals("1")?"":"none"%>"><%=ResourceComInfo.getLastname(relatedid) %></td>
				<td width="76" style="display:<%=blog_isCreatedate.equals("1")?"":"none"%>"><%=createdate%></td>
			</TR>
			<TR class=sparator style="height:1px" height=1 ><TD colSpan=4 style='padding:0px'></TD></TR>
		<%} %>
		<!-- 申请拒绝 -->
		<%if("3".equals(remindType)){%>
		   <TR height=18>
				<TD width=8><IMG name=esymbol src="/page/resource/userfile/image/ecology8/pointer_wev8.png"></TD>
				<TD  width=*>
				   <!-- 拒绝了你的关注申请 -->
				   <A href="javascript:openRemind(<%=eid%>,'<%=mainType%>','sysremind')">
					    <FONT class=font><%=ResourceComInfo.getLastname(relatedid) %><%=SystemEnv.getHtmlLabelName(26991,user.getLanguage())%></FONT>
				   </A> 
				</TD>
				<td width="70" style="display:<%=blog_isRelatedName.equals("1")?"":"none"%>"><%=ResourceComInfo.getLastname(relatedid) %></td>
				<td width="76" style="display:<%=blog_isCreatedate.equals("1")?"":"none"%>"><%=createdate%></td>
			</TR>
			<TR class=sparator style="height:1px" height=1 ><TD colSpan=4 style='padding:0px'></TD></TR>
		<%} %>
		<!-- 关注我的 -->
		<%if("5".equals(remindType)){%>
		   <TR height=18>
				<TD width=8><IMG name=esymbol src="/page/resource/userfile/image/ecology8/pointer_wev8.png"></TD>
				<TD  width=*>
				   <!-- 关注了你 -->
				   <A href="javascript:openRemind(<%=eid%>,'<%=mainType%>','sysremind')">
					    <FONT class=font><%=ResourceComInfo.getLastname(relatedid) %><%=SystemEnv.getHtmlLabelName(26992,user.getLanguage())%></FONT>
				   </A> 
				</TD>
				<td width="70" style="display:<%=blog_isRelatedName.equals("1")?"":"none"%>"><%=ResourceComInfo.getLastname(relatedid) %></td>
				<td width="76" style="display:<%=blog_isCreatedate.equals("1")?"":"none"%>"><%=createdate%></td>
			</TR>
			<TR class=sparator style="height:1px" height=1 ><TD colSpan=4 style='padding:0px'></TD></TR>
		<%} %>
		<!-- 微博更新 -->
		<%if("6".equals(remindType)){
			BlogDiscessVo discussVo= blogDao.getDiscussVo(remindValue);
			
			//如果微博记录不存在，则删除提醒
			if(discussVo==null){
			   RecordSet recordSet=new RecordSet();
			   recordSet.execute("delete from blog_remind where id="+id);
			   continue;	
			}
				
			String workdate=discussVo.getWorkdate();
			try{
				workdate=frm1.format(frm2.parseObject(workdate));
		    }catch(Exception e){
		    	e.printStackTrace();
		    }
			
            String message=SystemEnv.getHtmlLabelName(615,user.getLanguage())+workdate+SystemEnv.getHtmlLabelName(26759,user.getLanguage());
		%>
		   <TR height=18>
				<TD width=8><IMG name=esymbol src="/page/resource/userfile/image/ecology8/pointer_wev8.png"></TD>
				<TD  width=* valign="top">
				    <!-- 提交了{0}工作微博 -->
				    <A href="javascript:openRemind(<%=eid%>,'<%=mainType%>','homepage')">
					    <FONT class=font><%=ResourceComInfo.getLastname(relatedid) %><%=message%></FONT>
				    </A>
				</TD>
				<td width="70" style="display:<%=blog_isRelatedName.equals("1")?"":"none"%>"><%=ResourceComInfo.getLastname(relatedid) %></td>
				<td width="76" style="display:<%=blog_isCreatedate.equals("1")?"":"none"%>"><%=createdate%></td>
			</TR>
			<TR class=sparator style="height:1px" height=1 ><TD colSpan=4 style='padding:0px'></TD></TR>
		<%} %>
		<!-- 未提交提醒 -->
		<%if("7".equals(remindType)){
			if("".equals(remindValue))
				continue;
		    try{
		    	remindValue=frm1.format(frm2.parseObject(remindValue));
		    }catch(Exception e){
		    	e.printStackTrace();
		    }
			
			String message=SystemEnv.getHtmlLabelName(26928,user.getLanguage())+SystemEnv.getHtmlLabelName(615,user.getLanguage())+remindValue+SystemEnv.getHtmlLabelName(26759,user.getLanguage());
		%>
		   <TR height=18>
				<TD width=8><IMG name=esymbol src="/page/resource/userfile/image/ecology8/pointer_wev8.png"></TD>
				<TD  width=*>
				    <!-- 提醒你提交{0}工作微博 -->
				    <A href="javascript:openRemind(<%=eid%>,'<%=mainType%>','sysremind')">
					    <FONT class=font><%=ResourceComInfo.getLastname(relatedid) %><%=message%></FONT>
				    </A>
				</TD>
				<td width="70" style="display:<%=blog_isRelatedName.equals("1")?"":"none"%>"><%=ResourceComInfo.getLastname(relatedid) %></td>
				<td width="76" style="display:<%=blog_isCreatedate.equals("1")?"":"none"%>"><%=createdate%></td>
			</TR>
			<TR class=sparator style="height:1px" height=1 ><TD colSpan=4 style='padding:0px'></TD></TR>
		<%} %>
		<!-- 未提交系统提醒 -->
		<%if("8".equals(remindType)){
			Object object[]=new Object[1];
    		object[0]=remindValue;
			String message = MessageFormat.format(SystemEnv.getHtmlLabelName(26995,user.getLanguage()),object);
		%>
		   <TR height=18>
				<TD width=8><IMG name=esymbol src="/page/resource/userfile/image/ecology8/pointer_wev8.png"></TD>
				<TD width=*>
				    <!-- 提醒你提交{0}工作微博 -->
				    <A href="javascript:openRemind(<%=eid%>,'<%=mainType%>','sysremind')">
					    <FONT class=font><%=message%></FONT>
				    </A>
				</TD>
				<td width="70" style="display:<%=blog_isRelatedName.equals("1")?"":"none"%>"><%=SystemEnv.getHtmlLabelName(15172,user.getLanguage())%></td>
				<td width="76" style="display:<%=blog_isCreatedate.equals("1")?"":"none"%>"><%=createdate%></td>
			</TR>
			<TR class=sparator style="height:1px" height=1 ><TD colSpan=4 style='padding:0px'></TD></TR>
		<%} %>
		<!-- 评论我的  -->
		<%if("9".equals(remindType)){
			
			String[] arrayAemindValue=Util.TokenizerString2(remindValue, "|");
			if(arrayAemindValue.length!=3){
				continue;
			}
			
			String disucssid=arrayAemindValue[0];  //微博id
			String beReplayid=arrayAemindValue[1];   //被评论的评论id
			String replayid=arrayAemindValue[2];//评论id
			
			BlogReplyVo replyVo=blogDao.getReplyById(replayid);
			BlogReplyVo beReplayVo=blogDao.getReplyById(beReplayid);
			
			if(replyVo==null||(!beReplayid.equals("0")&&beReplayVo==null))
				continue;
			
			String workdate=replyVo.getWorkdate();
			try{
				workdate=frm1.format(frm2.parseObject(workdate));
		    }catch(Exception e){
		    	e.printStackTrace();
		    }
			
			String message="";
			if("0".equals(beReplayid)){
				Object object[]=new Object[1];
    		    object[0]=workdate;
				message=MessageFormat.format(SystemEnv.getHtmlLabelName(26996,user.getLanguage()),object); //评论了你{0}工作微博
			}	
			else if(replyVo.getBediscussantid().equals(""+user.getUID())){
				Object object[]=new Object[1];
    		    object[0]=workdate;
				message=MessageFormat.format(SystemEnv.getHtmlLabelName(26997,user.getLanguage()),object); //在你{0}的工作微博中回复了你
			}else{
				Object object[]=new Object[1];
    		    object[0]=ResourceComInfo.getLastname(replyVo.getBediscussantid())+workdate;
				message=MessageFormat.format(SystemEnv.getHtmlLabelName(26998,user.getLanguage()),object); //在{0}的工作微博中回复了你
			}
		%>
		   <TR height=18>
				<TD width=8><IMG name=esymbol src="/page/resource/userfile/image/ecology8/pointer_wev8.png"></TD>
				<TD valign="top"  width=*>
				    <A href="javascript:openRemind(<%=eid%>,'<%=mainType%>','comment')">
					    <FONT class=font><%=ResourceComInfo.getLastname(relatedid) %><%=message%></FONT>
				    </A>
				</TD>
				<td width="70" style="display:<%=blog_isRelatedName.equals("1")?"":"none"%>"><%=ResourceComInfo.getLastname(relatedid) %></td>
				<td width="76" style="display:<%=blog_isCreatedate.equals("1")?"":"none"%>"><%=createdate%></td>
			</TR>
			<TR class=sparator style="height:1px" height=1 ><TD colSpan=4 style='padding:0px'></TD></TR>
		<%} %>
		
	 <%} %>	
 </TABLE> 
</TD>
<TD width=1></TD>
</TR>
</TABLE>
<%} %>

 <script>
    
  changeMore(<%=eid%>,"<%=selectTab%>");
  
  function openRemind(eid,mainType,menuItem){
    openFullWindowHaveBar('/blog/blogView.jsp?menuItem='+menuItem)
    
    jQuery("#"+eid+"_table_"+mainType).html("");
    
    if(mainType=="update")
       tabName="<%=SystemEnv.getHtmlLabelName(17744,user.getLanguage())%>"; //更新
    else if(mainType=="remind")   
       tabName="<%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>"; //提醒
    else if(mainType=="comment")   
       tabName="<%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%>";   //评论
    else if(mainType=="request")   
       tabName="<%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%>";   //请求   
    jQuery("#"+eid+"_"+mainType).html(tabName);
  }
  
  function showRemind(obj,eid,mainType){

     jQuery(obj).parent("tr:first").find(".tab2selected").removeClass("tab2selected").addClass("tab2unselected");
     jQuery(obj).removeClass("tab2unselected").addClass("tab2selected");
     
     jQuery("."+eid+"_blogStatus_table").hide();
     jQuery("#"+eid+"_table_"+mainType).show();
     
     changeMore(eid,mainType);
  }
  
  //修改more页面
  function changeMore(eid,mainType){
    if(mainType=="update")
       $("#more_"+eid).attr("href","javascript:openFullWindowForXtable('/blog/blogView.jsp?menuItem=homepage')")
    else if(mainType=="comment") 
       $("#more_"+eid).attr("href","javascript:openFullWindowForXtable('/blog/blogView.jsp?menuItem=comment')")
    else 
       $("#more_"+eid).attr("href","javascript:openFullWindowForXtable('/blog/blogView.jsp?menuItem=sysremind')")  
  }
  
</script>