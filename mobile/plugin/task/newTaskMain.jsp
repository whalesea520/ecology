<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.gp.util.TaskInfoSearch" %>

<%
	User user = HrmUserVarify.getUser(request, response);
	if(user == null) return;
	
	int pageIndex = Util.getIntValue(request.getParameter("pageIndex"), 1);
	int pageSize = Util.getIntValue(request.getParameter("pageSize"), 5);
	TaskInfoSearch ts = new TaskInfoSearch();
	List<Map<String,Object>> list = ts.getTaskInfoList(user,pageIndex,pageSize);
%>
<style type="text/css">
	#taskContainer{overflow:hidden;}
	#taskContainer .task-data-ul{margin:0;padding:0;list-style:none;}
	#taskContainer .task-data-li{box-sizing:border-box;border-bottom:1px solid #f0f0f0;overflow:hidden;padding: 6px 15px;background: #fff;position: relative;}
	#taskContainer .task-data-li:last-child{border-bottom: none;}
	#taskContainer table {border-collapse: separate;border-spacing: 0px;width: 100%;-webkit-transition: -webkit-transform 0.3s;transition: transform 0.3s;}
	#taskContainer a{text-decoration: none;cursor: pointer;}
	#taskContainer .task-data-date{text-align:right;width:45px;padding:5px 10px 0 10px;color:#08a6f7;white-space:nowrap;font-size:16px;}
	#taskContainer .task-data-year{font-size:14px !important;}
	#taskContainer .task-data-name{padding:5px 20px 0 20px;color:#08a6f7;word-break: keep-all;font-size:16px;
	          white-space: nowrap;overflow: hidden;text-overflow: ellipsis;max-width:188px;display:inline-block;}
	#taskContainer .task-data-imgtd{text-align:right;padding-right:3px;width:24px;}
	#taskContainer .task-data-img{width:12px;height:12px;position:absolute;right:10px;}
	#taskContainer .task-data-duty{padding:5px 10px 0 20px;font-size:12px;color:#7a7a7a;}
	#taskContainer .task-data-status{padding-left:10px;font-size:12px;color:#7a7a7a;}
	#taskContainer .task-data-fbpart{position: absolute;top: 0px;right:2px;font-size:14px;z-index: 10;color: red;}
	#taskContainer .task-data-div{display:inline-block;position:relative;}

</style>
	<div id="taskContainer">
	    <ul id="itemContent" class="task-data-ul">
	        <%Map maps = null;
	          for(int i=0;i<list.size();i++){
	            maps = list.get(i);
	        %>
	            <li class="task-data-li"><a href="/mobile/plugin/task/taskDetail.jsp?taskId=<%=Util.null2String(maps.get("id")) %>">
		            <table><tbody><tr>
		               <td class="task-data-date"><%=Util.null2String(maps.get("date")) %></td>
		               <td><div class="task-data-div"><div class="task-data-name"><%=Util.null2String(maps.get("name")) %></div>
		               <%if(Util.null2String(maps.get("noreadfb")).equals("1") && !Util.null2String(maps.get("fbcount")).equals("0")){%>
		            	   <span class="task-data-fbpart">(<%=Util.null2String(maps.get("fbcount")) %>)</span>
		               <%} %>
		               </div></td>
		               <td rowspan="2" class="task-data-imgtd"><img src="/mobile/plugin/task/images/icon.png" class="task-data-img"></td>
		            </tr><tr>
		            <td class="task-data-date task-data-year"><%=Util.null2String(maps.get("year")) %></td>
		            <td><div class="task-data-duty">责任人:<%=Util.null2String(maps.get("dutyMan")) %>
		            <span class="task-data-status">状态:<%=Util.null2String(maps.get("status")) %></span>
		            </div></td>
		            </tr></tbody></table>
		            
	            </a></li>
	         <%} %>
	    </ul>
	</div>