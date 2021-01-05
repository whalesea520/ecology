<%@page import="com.weaver.formmodel.apps.ktree.KtreePermissionService"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

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
<jsp:useBean id="ktreePermissionService" class="com.weaver.formmodel.apps.ktree.KtreePermissionService" scope="page" />
<%
	User user = HrmUserVarify.getUser(request,response);
	if(user == null)  return ;
	RecordSet rs = new RecordSet();
	int userType = ktreePermissionService.getUserType(user);
	String userid=String.valueOf(user.getUID());
	int tabid=Util.getIntValue(request.getParameter("tabid"));
	int versionid=Util.getIntValue(request.getParameter("versionid"));
	int functionid=Util.getIntValue(request.getParameter("functionid"));
	int pagesize = 10;//讨论交流每页显示条数
	int currentpage = Util.getIntValue((String)request.getParameter("currentpage"), 1);
	int prepage=currentpage-1;
	int nextpage=currentpage+1;
	int totalsize =0;
	//查询参数
	String searchStartDate = Util.null2String(request.getParameter("searchStartDate"));
	String searchEndDate = Util.null2String(request.getParameter("searchEndDate"));
	String searchDocStatus = Util.null2String(request.getParameter("searchDocStatus"));
	String sqlwhere="";
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	if(searchStartDate.length()>0){
		long startDate = sdf.parse(searchStartDate).getTime();
		sqlwhere +=" and updatedatetime>="+startDate;
	}
	if(searchEndDate.length()>0){
		long startDate = sdf.parse(searchEndDate).getTime();
		sqlwhere +=" and updatedatetime<="+searchEndDate;
	}
	if(searchDocStatus.length()>0){
		String searchDocStatus1 = searchDocStatus.substring(1);
		sqlwhere +=" and doc_status in ("+searchDocStatus1+")";
	}
	ArrayList list=new ArrayList();
	
	String selSql = "";
	selSql = "select Count(1) from uf_ktree_documentInformality where versionid="+versionid+" and functionid="+functionid+" and tabid="+tabid+" "+sqlwhere;  //没有被回复的讨论才记录总数 replayid=0
	rs.executeSql(selSql);
	if(rs.next()) {
		totalsize = rs.getInt(1);
	}
	int iNextNum = currentpage * pagesize;
	int ipageset = pagesize;
	if(totalsize - iNextNum + pagesize < pagesize) ipageset = totalsize - iNextNum + pagesize;
	if(totalsize < pagesize) ipageset = totalsize;
	selSql = "select top " + iNextNum +" * from uf_ktree_documentInformality where versionid="+versionid+" and functionid="+functionid+" and tabid="+tabid+sqlwhere+" order by id desc";
	selSql = "select top " + ipageset +" t1.* from (" + selSql + ") t1 where t1.tabid=" + tabid + "order by t1.id asc";
	selSql = "select top " + ipageset +" t2.* from (" + selSql + ") t2 where t2.tabid=" + tabid + "order by t2.id desc";
	System.out.println(selSql);
	rs.executeSql(selSql);
	List recordList = new ArrayList();
	while(rs.next()){
		Map map = new HashMap();
		map.put("id", rs.getString("id"));
		map.put("doc_version",rs.getString("doc_version"));
		map.put("digest",rs.getString("digest"));
		map.put("updater",rs.getString("updater"));
		map.put("updatedate",rs.getString("updatedate"));
		map.put("updatetime",rs.getString("updatetime"));
		map.put("doc_status",rs.getString("doc_status"));
		map.put("opttype",rs.getString("opttype"));
		recordList.add(map);
	}
	
	 int totalpage = totalsize / pagesize;
	  if(totalsize - totalpage * pagesize > 0) totalpage = totalpage + 1;
	String flag = ""+versionid+functionid+tabid;
	%>
		<table>
  <tr>
    <td>时间</td>
    <td>
    <input name="searchStartDate" id="searchStartDate" onClick="WdatePicker()" value="<%=searchStartDate%>">
    	-
    <input name="searchEndDate" id="searchEndDate" onClick="WdatePicker()" value="<%=searchEndDate%>"/></td>
    <td>状态</td>
    <td>
    	<!-- selectDocStatus方法 在viewdocument.jsp中 -->
    	申请中<input type="checkbox" <%=searchDocStatus.indexOf(",3")>-1?"checked":"" %> name="c_doc_status" onclick="selectDocStatus(this)" value="3">&nbsp;
    	已通过<input type="checkbox" <%=searchDocStatus.indexOf(",2")>-1?"checked":"" %> name="c_doc_status" onclick="selectDocStatus(this)" value="2">&nbsp;
    	未通过<input type="checkbox" <%=searchDocStatus.indexOf(",4")>-1?"checked":"" %> name="c_doc_status" onclick="selectDocStatus(this)" value="4">&nbsp;
    	<input type="hidden" name="searchDocStatus" id="searchDocStatus" value="<%=searchDocStatus%>"/><!-- ,2,3,4 -->
    </td>
    <td><a href="javascript:searchHistoryDoc()">查询</a></td>
  </tr>
</table>
	<%
	if(recordList.size()>0){
	%>
		<div id="discuss_div_<%=flag%>" class="discuss_div">
	 		<table class="discuss" id="discuss_table_<%=flag%>" cellpadding="0" cellspacing="0">
			     <tr> 
			        <td valign="top" width="*" style="work-break:break-all;padding-left:3px" id="discussContentTd_<%=flag%>">
            			<table cellpadding="0" style="float: left;width: 100%" cellspacing="0" id="discuss_content_<%=flag%>">
            				 <col width="10%"/>
				             <col width="10%"/>
				             <col width="20%"/>
				             <col width="10%"/>
				             <col width="35%"/>
				             <col width="15%"/>
				             <tr>
					             <td>版本</td><td>作者</td>
					             <td>时间</td><td>操作</td>
					             <td>摘要</td><td>&nbsp;</td>
				             </tr>
	
	<%
		for(int k=0;k<recordList.size();k++){
			Map recordMap = (Map)recordList.get(k);
			String id = StringHelper.null2String(recordMap.get("id"));
			String doc_version = StringHelper.null2String(recordMap.get("doc_version"));
			int doc_status = Util.getIntValue(StringHelper.null2String(recordMap.get("doc_status")),0);
			String updater = StringHelper.null2String(recordMap.get("updater"));
			String updatedate = StringHelper.null2String(recordMap.get("updatedate"));
			String updatetime = StringHelper.null2String(recordMap.get("updatetime"));         //回复内容 
			String digest = StringHelper.StringReplace(StringHelper.null2String(recordMap.get("digest")),"\r\n","");
			String opttype = StringHelper.null2String(recordMap.get("opttype"));
			String datetime = updatedate+" "+updatetime;
%>
		
				             <tr>
				             <td style="padding-bottom: 2px">
				             	<%=doc_version %>
								 </td>
				             	<td style="padding-bottom: 2px">
								     <a href="javascript:void(0)" style="text-decoration:none" >
				                      	<%=Util.toScreen(ResourceComInfo.getResourcename(updater),user.getLanguage())%>
				                      </a>
								 </td>
				                  <td style="padding-bottom: 2px">
								     <%=datetime %>
								 </td>
								 <td style="padding-bottom: 2px">
								     <%=opttype.equals("1")?"创建":"编辑" %>
								 </td>
								 <td style="padding-bottom: 2px">
								     <%=digest %>
								 </td>
								 <td style="padding-bottom: 2px">
								 	<a id="A_View_<%=id %>" href="/formmode/apps/ktree/viewdocument.jsp?historyDocumentid=<%=id%>">查看</a>
<!-- 								    <a href="/formmode/apps/ktree/operationKtreeDcoument.jsp" >回滚</a> -->
<!-- 									<a href="/formmode/apps/ktree/operationKtreeDcoument.jsp" >审核通过</a> -->
<!-- 									<a href="/formmode/apps/ktree/operationKtreeDcoument.jsp" >审核不通过</a> -->
									<%if((doc_status==2||doc_status==1)&&userType==3){ %>
										<a id="A_Rollback_<%=id %>" href="/formmode/apps/ktree/operationKtreeDcoument.jsp?action=admin_rollback&documentid=<%=id %>" >回滚</a>
									<%} %>
									<%if(doc_status==3 &&userType==3 ){ %>
										<a id="A_CheckOk_<%=id %>" href="/formmode/apps/ktree/operationKtreeDcoument.jsp?action=admin_checkOK&documentid=<%=id %>" >审核通过</a>
										<a id="A_CheckNoOk_<%=id %>" href="javascript:checkNoOK('<%=id %>')" >审核不通过</a>
									<%} %>
								 </td>
				             </tr>
	          				 <%}%>
            			</table>
            		</td>
			     </tr>
			     
 			</table>
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
				    <A class=pageActive id="firstPage" href='javascript:void(0)' onclick='toPageDoc(1);return false;'><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%></A>
				 <%}else{%>
				    <%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%>
				 <%}%>
				 <%if(totalpage>1&&currentpage!=1){%>
				   <A class=pageActive  id="prePage" href='javascript:void(0)' onclick='toPageDoc(<%=prepage%>);return false;'><%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></A>
				 <%}else{%>
				   <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%>
				 <%}%>
				 <%if(totalpage>1&&currentpage!=totalpage){%>
				   <A class=pageActive  id="nextPage" href='javascript:void(0)' onclick='toPageDoc(<%=nextpage%>);return false;'><%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></A>
                 <%}else{%>
				   <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%>
				 <%}%>
				 <%if(totalpage>1&&currentpage!=totalpage){%>
				   <A  class=pageActive id="lastPage" href='javascript:void(0)' onclick='toPageDoc(<%=totalpage%>);return false;'><%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%></A>
                 <%}else{%>
				   <%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%>
				 <%}%>
		         <input type="button"  onclick="toGoPage(<%=totalpage%>,'topagenum')" value="<%=SystemEnv.getHtmlLabelName(23162,user.getLanguage())%>" style="cursor: pointer;height: 22px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><input type="text" size="2" style="line-height:18px;height: 18px;text-align: right;vertical-align: middle !important;" name='topagenum' id="topagenum" onkeyPress="if(event.keyCode==13){toGoPage(<%=totalpage%>,'topagenum');return false;}" value="<%=currentpage %>"><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%>
		    </td>
		 </tr>
		 <tr><td height="10px"></td></tr>
	</table>
