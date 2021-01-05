
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.general.Util"%>
<%@page import="com.informix.util.stringUtil"%>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
	User user = HrmUserVarify.getUser(request,response);
	if(user == null)  return ;
	RecordSet rs = new RecordSet();
	
	String userid=String.valueOf(user.getUID());
	String versionid = Util.null2String(request.getParameter("versionid"));
	String functionid = Util.null2String(request.getParameter("functionid"));  	
	String tabid=Util.null2String(request.getParameter("tabid"));
	int pagesize = 10;//讨论交流每页显示条数
	int currentpage = Util.getIntValue((String)request.getParameter("currentpage"), 1);
	int prepage=currentpage-1;
	int nextpage=currentpage+1;
	int totalsize =0;
	ArrayList list=new ArrayList();
	
	String selSql = "";
	selSql = "select Count(1) from uf_ktree_discussion where versionid="+versionid+" and functionid="+functionid+" and tabid="+tabid+" ";  //没有被回复的讨论才记录总数 replayid=0
	rs.executeSql(selSql);
	if(rs.next()) {
		totalsize = rs.getInt(1);
	}
	int iNextNum = currentpage * pagesize;
	int ipageset = pagesize;
	if(totalsize - iNextNum + pagesize < pagesize) ipageset = totalsize - iNextNum + pagesize;
	if(totalsize < pagesize) ipageset = totalsize;
	selSql = "select top " + iNextNum +" * from uf_ktree_discussion where versionid="+versionid+" and functionid="+functionid+" and tabid="+tabid+" order by id desc";
	selSql = "select top " + ipageset +" t1.* from (" + selSql + ") t1 where t1.versionid="+versionid+" and t1.functionid="+functionid+" and t1.tabid="+tabid+" order by t1.id asc";
	selSql = "select top " + ipageset +" t2.* from (" + selSql + ") t2 where t2.versionid="+versionid+" and t2.functionid="+functionid+" and t2.tabid="+tabid+" order by t2.id desc";
	rs.executeSql(selSql);
	List recordList = new ArrayList();
	while(rs.next()){
		Map map = new HashMap();
		map.put("id", rs.getString("id"));
		map.put("content",rs.getString("content"));
		map.put("files",rs.getString("files"));
		map.put("creator",rs.getString("creator"));
		map.put("createdate",rs.getString("createdate"));
		map.put("createtime",rs.getString("createtime"));
		map.put("reffiles",rs.getString("files"));
		map.put("floornum",rs.getString("floornum"));
		map.put("replayid",rs.getString("replayid"));
	//	System.out.println("===+"+rs.getString("ceatetime"));
		recordList.add(map);
	}
	
	 int totalpage = totalsize / pagesize;
	  if(totalsize - totalpage * pagesize > 0) totalpage = totalpage + 1;
	  
	if(recordList.size()>0){
		for(int k=0;k<recordList.size();k++){
			Map recordMap = (Map)recordList.get(k);
			String discussid = StringHelper.null2String(recordMap.get("id"));
			String discussant = StringHelper.null2String(recordMap.get("creator"));
			String createdate = StringHelper.null2String(recordMap.get("createdate"));
			String createtime = StringHelper.null2String(recordMap.get("createtime"));
			String reffiles = StringHelper.null2String(recordMap.get("files"));
			String remark2 = StringHelper.null2String(recordMap.get("content"));         //回复内容 
			String remark2html = StringHelper.StringReplace(remark2.trim(),"\r\n",""); 
			String floorNum = StringHelper.null2String(recordMap.get("floornum"));
			String replayid = StringHelper.null2String(recordMap.get("replayid"));
%>


<div style="clear:both;margin:10px 0;padding:0 10px 0 0;">
	<div style="width:65px;float:left;padding:0 0 10px 15px;">
		<img src="/formmode/apps/ktree/images/user_wev8.png" class="discussAvtor"/>
	</div>
	<div style="margin-left:85px;" id="discuss_div_<%=discussid%>">
		<table style="width:100%;margin:5px 0 5px 0;" id="discuss_table_<%=discussid%>" cellspacing="0">
		<tr>
			<td style="border-bottom:1px solid #eee;padding:0 0 5px 0;">
				<!--<%=floorNum%><%=SystemEnv.getHtmlLabelName(25403,user.getLanguage())%>-->
				<a href="javascript:void(0)"><%=Util.toScreen(ResourceComInfo.getResourcename(discussant),user.getLanguage())%></a>
				<!--
				<%if(!replayid.equals("0")){%>
					<img src="/cowork/images/replay_wev8.png" align="absmiddle"/>
				<%}else{ %>
					<img src="/cowork/images/publish_wev8.png" align="absmiddle"/>
				<%}%>
				-->
				<span style="font-style:normal;color:#999;"><%=createdate%> <%=createtime%></span>
			</td>
			<td style="width:200px;text-align:right;border-bottom:1px solid #eee;padding:0 0 5px 0;">
				<a href="javascript:void(0)" onclick="showReplay('<%=discussid%>','<%=floorNum%>');return false;"><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></a>
				<%if(userid.equals(discussant)){%>
					<a href="javascript:void(0)" onclick="editKtreeDiscuss('<%=discussid%>','<%=replayid%>');return false;"><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%></a><!--修改 -->
					<a href="javascript:void(0)" onclick="deleteKtreeDiscuss('<%=discussid%>');return false;"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><!--删除-->
				<%}%>
			</td>
		</tr>
		<tr>
			<td colspan="2" style="border-bottom:0px solid #eee;padding:5px 0 10px 0;color:#444;">
			<%
			if(!"0".equals(replayid)&&!StringHelper.isEmpty(replayid)){
				rs.executeSql("select * from uf_ktree_discussion where id="+replayid);	  
				String preremark = "";
				if(rs.next()){
					preremark = Util.StringReplace(rs.getString("content").trim(),"\n","<br>");
				}
			%>         				 
			<div style="background-color:#f8f8f8;padding:5px;color:#999;">
				<div style="font-size:10px;">
					<%=SystemEnv.getHtmlLabelName(18540,user.getLanguage())%>
					<%=rs.getString("floornum")%><%=SystemEnv.getHtmlLabelName(25403,user.getLanguage())%>
					<a href="javascript:void(0)" style="font-size:10px;"><%=Util.toScreen(ResourceComInfo.getResourcename(rs.getString("creator")),user.getLanguage())%></a>
					<%=rs.getString("createdate")%> <%=rs.getString("createtime")%>
				</div>
				<div style="font-size:10px;"><%=preremark%></div>
			</div>
			<%}%>
			<%=remark2html%>
			</td>
		</tr>
		</table>
		<!--点击回复时显示HTML编辑器-->
		<div id="replay_<%=discussid%>" class="replaydiv">
			<textarea id="replay_content_<%=discussid%>" class="replayContent"  onpropertychange="autoHeight(this,35)"></textarea>
			<div>
			   <button type="button" onclick="doSave('replay_content_<%=discussid%>')" class="btnSubmit"><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></button>
			   <button type="button" onclick="cancelReplay('<%=discussid%>');return false;" class="btnCancel"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></button>
		   </div>
	   </div>
	</div>
</div>

<%}%>
	<table width="98%" cellpadding="0" cellspacing="0" style="margin-top: 5px;">
	    <!-- 分页 -->
		<tr class="pagenav" style="<%if(totalsize==0){ %>display:none<%}%>;" >
		    <td>
		         <%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><span class="totalsize"><%=totalsize%></span><%=SystemEnv.getHtmlLabelName(24683,user.getLanguage())%> <!-- 共62条记录 -->
		         <%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=pagesize%><%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>    <!-- 每页10条 -->
		         <%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><span class="totalpage"><%=totalpage%></span><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%> <!-- 共7页 -->
		         <%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><span class="currentpage"><%=currentpage%></span><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%><!-- 当前第1页 --> 
		          <!-- 首页 上一页 下一页 尾页 --> 
				 <%if(totalpage>1&&currentpage!=1){%>
				    <A class=pageActive id="firstPage" href='javascript:void(0)' onclick='toPage(1);return false;'><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%></A>
				 <%}else{%>
				    <%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%>
				 <%}%>
				 <%if(totalpage>1&&currentpage!=1){%>
				   <A class=pageActive  id="prePage" href='javascript:void(0)' onclick='toPage(<%=prepage%>);return false;'><%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></A>
				 <%}else{%>
				   <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%>
				 <%}%>
				 <%if(totalpage>1&&currentpage!=totalpage){%>
				   <A class=pageActive  id="nextPage" href='javascript:void(0)' onclick='toPage(<%=nextpage%>);return false;'><%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></A>
                 <%}else{%>
				   <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%>
				 <%}%>
				 <%if(totalpage>1&&currentpage!=totalpage){%>
				   <A  class=pageActive id="lastPage" href='javascript:void(0)' onclick='toPage(<%=totalpage%>);return false;'><%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%></A>
                 <%}else{%>
				   <%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%>
				 <%}%>
		         <input type="button"  onclick="toGoPage(<%=totalpage%>,'topagenum')" value="<%=SystemEnv.getHtmlLabelName(23162,user.getLanguage())%>" style="cursor: pointer;height: 22px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><input type="text" size="2" style="line-height:18px;height: 18px;text-align: right;vertical-align: middle !important;" name='topagenum' id="topagenum" onkeyPress="if(event.keyCode==13){toGoPage(<%=totalpage%>,'topagenum');return false;}" value="<%=currentpage %>"><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%>
		    </td>
		 </tr>
		 <tr><td height="10px"></td></tr>
	</table>
<%}%>