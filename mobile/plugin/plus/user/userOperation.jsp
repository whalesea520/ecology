<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.wxinterface.InterfaceUtil"%>
<%@ page import="weaver.join.hrm.in.processImpl.HrmImportProcess"%>
<%@ page import="weaver.join.hrm.in.HrmResourceVo"%>
<%@ page import="weaver.join.hrm.in.ImportLog"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int userid = Util.getIntValue(request.getParameter("userid"),0);
	String loginid = Util.null2String(request.getParameter("loginid"));
	String token = Util.null2String(request.getParameter("token"));
	String lastname = Util.null2String(request.getParameter("lastname"));
	String mobile = Util.null2String(request.getParameter("mobile"));
	String userStatus = Util.null2String(request.getParameter("userStatus"));
	if("1".equals(userStatus))userStatus="正式";
	int status = 1;String msg = "";
	if(!loginid.equals("")&&!token.equals("")){
		try{
			boolean ifAuth = InterfaceUtil.wxCheckLogin(token);//验证token
			if(ifAuth){
				boolean ifReturn = false;//是否不需要采取操作，直接返回
				String importType = "add";
				if(userid!=0){
					importType = "update";
				}
				rs.executeSql("select id from HrmResource where loginid = '"+loginid+"'");
				if(rs.next()){
					userid = rs.getInt("id");
					status = 0;
					ifReturn = true;
					if(userid!=0){//userid不为0表示要做更新操作，但是更新的loginid已经存在，直接返回错误信息
						msg = "更新成功:该登录账号已经存在，直接返回数据库ID";
					}else{//新增操作判断登录账号是否存在 存在直接返回userid
						msg = "新增成功:该登录账号已经存在,直接返回数据库ID";
					}
				}
				if(!ifReturn){
					String oldloginid = "";
					if(importType.equals("update")){
						rs.executeSql("select loginid from HrmResource where id="+userid);
						if(rs.next()){
							oldloginid = Util.null2String(rs.getString("loginid"));
						}
					}else{
						oldloginid = loginid;
					}
					HrmResourceVo vo = new HrmResourceVo();
					vo.setStatus(userStatus);
					vo.setLoginid(loginid);//登录账号
					vo.setLastname(lastname);//姓名
					vo.setMobile(mobile);//手机号码
					vo.setSubcompanyid1("泛微上海>体验账号");//分部
					vo.setDepartmentid("体验账号");//部门
					vo.setLocationid("上海");//办公地点
					vo.setJobtitle("体验岗位");//岗位
					vo.setJobactivityid("体验账号");//职务
					vo.setJobgroupid("体验账号");//职位类型
					//vo.setPassword(mobile);
					String keyField = "loginid";
					LinkedHashMap hrMap = new LinkedHashMap();
					hrMap.put(oldloginid, vo);
					HrmImportProcess impl = new HrmImportProcess();
					List list = impl.processMap(keyField,hrMap,importType);
					ImportLog log = (ImportLog)list.get(0);
					if(log.getStatus().equals("成功")){
						if(importType.equals("add")){//新增操作 创建完成获取此账号ID
							rs.execute("select id from HrmResource where loginid = '"+loginid+"'");
							if(rs.next()){
								userid = rs.getInt("id");
							}
						}
						status = 0;
					}else{
						msg = log.getReason();
					}
				}
			}else{
				msg = "非法访问";
			}
		}catch(Exception e){
			msg = "创建人员失败:"+e.getMessage();
		}
	}else{
		msg = "相关参数不完整";
	}
	JSONObject json = new JSONObject();
	json.put("status",status);
	json.put("msg",msg);
	json.put("userid",userid+"");
	out.print(json.toString());
%>