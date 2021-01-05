<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="org.json.JSONObject"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TransUtil" class="weaver.wxinterface.TransUtil" scope="page" />
<%
JSONObject json = new JSONObject();
int status = 1;String msg = "";
try{
	User user = HrmUserVarify.getUser (request , response);
	if(user!=null&&user.getUID()==1){
		String operation = Util.null2String(request.getParameter("operation"));
		String nowtime = TimeUtil.getCurrentTimeString();//当天日期和时间
		if("addCountLimit".equals(operation)){
			int resourcetype = Util.getIntValue(request.getParameter("resourcetype"),1);
			int countlimit = Util.getIntValue(request.getParameter("countlimit"),0);
			String resourceids = Util.null2String(request.getParameter("resourceids"));
			int clid = Util.getIntValue(request.getParameter("clid"),0);
			String sql = "";
			if(clid==0){
				sql = "insert into WX_SignCountLimit (resourcetype,resourceids,countlimit,createtime) values "
					  + "("+resourcetype+",'"+resourceids+"',"+countlimit+",'"+nowtime+"')";
			}else{
				sql = "update WX_SignCountLimit set resourcetype="+resourcetype+",resourceids='"+resourceids+"'"
					  +",countlimit="+countlimit+" where id ="+clid;
			}
			if(rs.executeSql(sql)){
				status = 0;
			}else{
				msg = "执行SQL语句出现错误";
			}
		}else if("delCl".equals(operation)){
			String ids = Util.null2String(request.getParameter("ids"));
			if (!"".equals(ids)) {
				String sql = "delete from WX_SignCountLimit where id in (" + ids + ")";
				boolean flag = rs.execute(sql);
				if (flag) {
					status = 0;
				} else {
					msg = "执行删除SQL失败";
				}
			} else {
				msg = "相关参数不完整";
			}
		}else if("getCl".equals(operation)){
			String id = Util.null2String(request.getParameter("id"));
			if(!id.equals("")){
				rs.execute("select * from WX_SignCountLimit where id = "+id);
				if(rs.next()){
					json.put("id", id);
					json.put("resourcetype", rs.getString("resourcetype"));
					json.put("resourceids", rs.getString("resourceids"));
					json.put("countlimit", rs.getString("countlimit"));
					json.put("resourcenames", TransUtil.getResourceNames(Util.null2String(rs.getString("resourcetype")),Util.null2String(rs.getString("resourceids"))));
					status = 0;
				}else{
					msg = "没有查询到相关数据";
				}
			}else{
				msg = "没有获取到ID";
			}
		}
	}else{
		msg = "您没有权限设置";
	}
}catch(Exception e){
	msg = "操作程序出现异常:"+e.getMessage();
}
json.put("status", status);
json.put("msg", msg);
out.print(json.toString());
%>