<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.hrm.company.DepartmentComInfo"%>
<jsp:useBean id="cci" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="sci" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="dci" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
User user = HrmUserVarify.getUser(request , response);
if(user == null)  return ;
int o = Util.getIntValue(Util.null2String(request.getParameter("o")));
int ot = Util.getIntValue(Util.null2String(request.getParameter("ot")));

String name = "";
String type = "";
String id = "";
String mobile = "";
String tel = "";
String mail = "";

if(ot==0&&o==0) {
	cci.setTofirstRow();
	cci.next();

	name = cci.getCompanyname();
	type = "0";
	id = cci.getCompanyid();
%>

	<a href="javascript:clickOrg(<%=type%>,<%=id%>);">
	<div style="position:relative;height:38px;filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',endColorstr='#D7E0E5' );background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),to(#D7E0E5) );background: -moz-linear-gradient(top, #FFFFFF, #D7E0E5);" id="t_<%=type%>_<%=id%>" expand=0 isload=0>
		<div id="i_<%=type%>_<%=id%>" style="position:absolute;left:10px;top:10px;right:10p x;height:30px;line-height:30px;"><img src="/mobile/plugin/6/images/icon1_wev8.png"></div>
		<div id="l_<%=type%>_<%=id%>" style="position:absolute;left:40px;top:7px;right:10px;height:30px;line-height:30px;padding-right: 20px;" class="text-ellipsis"><%=name %></div>
		<div style="position:absolute;top:10px;right:10px;height:30px;line-height:30px;"><img src="/mobile/plugin/6/images/icon4_wev8.png"></div>
	</div>
	</a>

	<div style="border-top: solid 1px #C5C5C5;border-bottom: solid 1px #EBEBEB;" id="s_<%=type%>_<%=id%>"></div>

<%
} else if(ot==0&&o>0) {
	
	sci.setTofirstRow();
	while(sci.next()) {
		
		if(Util.getIntValue(sci.getCompanyid())!=o || Util.getIntValue(sci.getSupsubcomid(), 0)!=0 || Util.getIntValue(sci.getCompanyiscanceled())==1) continue;
		
		name = sci.getSubCompanyname();
		type = "1";
		id = sci.getSubCompanyid();

%>

	<div style="position:relative;height:35px;filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#EFEFEF',endColorstr='#FFFFFF' );background: -webkit-gradient(linear, left top, left bottom, from(#EFEFEF),to(#FFFFFF) );background: -moz-linear-gradient(top, #EFEFEF, #FFFFFF);" id="t_<%=type%>_<%=id%>" expand=0 isload=0>
	<a href="javascript:clickOrg(<%=type%>,<%=id%>);">
		<div id="i_<%=type%>_<%=id%>" style="position:absolute;left:10px;top:8px;right:10px;height:30px;line-height:30px;"><img src="/mobile/plugin/6/images/icon1_wev8.png"></div>
		<div id="l_<%=type%>_<%=id%>" style="position:absolute;left:40px;top:5px;right:10px;height:30px;line-height:30px;padding-right: 20px;" class="text-ellipsis"><%=name %></div>
		<div style="position:absolute;top:10px;right:10px;height:30px;line-height:30px;"><img src="/mobile/plugin/6/images/icon4_wev8.png"></div>
	</a>
	</div>

	<div style="border-top: solid 1px #C5C5C5;border-bottom: solid 1px #EBEBEB;" id="s_<%=type%>_<%=id%>"></div>

<%
	}
%>

<%
} else if(ot==1&&o>0) {
%>
<%=getUserList(user,ot,o) %>
<%	
	
	dci.setTofirstRow();
	while(dci.next()) {
		int departmentsupdepid = Util.getIntValue(dci.getDepartmentsupdepid(), 0);
		if(departmentsupdepid > 0) {
			int supdepididx = dci.getIdIndexKey(""+departmentsupdepid);
			if(supdepididx == -1) departmentsupdepid = 0;
		}
		
		if(Util.getIntValue(dci.getSubcompanyid1())!=o || departmentsupdepid!=0 || Util.getIntValue(dci.getDeparmentcanceled())==1) continue;
		
		name = dci.getDepartmentname();
		type = "2";
		id = dci.getDepartmentid();

%>

	<a href="javascript:clickOrg(<%=type%>,<%=id%>);">
	<div style="position:relative;width:100%;height:35px;" id="t_<%=type%>_<%=id%>" expand=0 isload=0>
		<div id="i_<%=type%>_<%=id%>" style="position:absolute;left:10px;top:8px;right:10px;height:30px;line-height:30px;"><img src="/mobile/plugin/6/images/icon2_wev8.png"></div>
		<div id="l_<%=type%>_<%=id%>" style="position:absolute;left:40px;top:5px;right:10px;height:30px;line-height:30px;" class="text-ellipsis"><%=name %></div>
	</div>
	</a>

	<div style="" id="s_<%=type%>_<%=id%>"></div>

<%
	}
	
	sci.setTofirstRow();
	while(sci.next()) {
		
		if(Util.getIntValue(sci.getSupsubcomid())!=o || Util.getIntValue(sci.getSupsubcomid(), 0)==0 || Util.getIntValue(sci.getCompanyiscanceled())==1) continue;
		
		name = sci.getSubCompanyname();
		type = "1";
		id = sci.getSubCompanyid();

%>

	<a href="javascript:clickOrg(<%=type%>,<%=id%>);">
	<div style="position:relative;height:35px;filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#EFEFEF',endColorstr='#FFFFFF' );background: -webkit-gradient(linear, left top, left bottom, from(#EFEFEF),to(#FFFFFF) );background: -moz-linear-gradient(top, #EFEFEF, #FFFFFF);" id="t_<%=type%>_<%=id%>" expand=0 isload=0>
		<div id="i_<%=type%>_<%=id%>" style="position:absolute;left:10px;top:8px;right:10p x;height:30px;line-height:30px;"><img src="/mobile/plugin/6/images/icon1_wev8.png"></div>
		<div id="l_<%=type%>_<%=id%>" style="position:absolute;left:40px;top:5px;right:10px;height:30px;line-height:30px;padding-right: 20px;" class="text-ellipsis"><%=name %></div>
		<div style="position:absolute;top:10px;right:10px;height:30px;line-height:30px;"><img src="/mobile/plugin/6/images/icon4_wev8.png"></div>
	</div>
	</a>

	<div style="border-top: solid 1px #C5C5C5;border-bottom: solid 1px #EBEBEB;" id="s_<%=type%>_<%=id%>"></div>

<%
	}
	
} else if(ot==2&&o>0) {
%>
<%=getUserList(user,ot,o) %>
<%	
	dci.setTofirstRow();
	while(dci.next()) {
		
		if(Util.getIntValue(dci.getDepartmentsupdepid())!=o || Util.getIntValue(dci.getDepartmentsupdepid(), 0)==0 || Util.getIntValue(dci.getDeparmentcanceled())==1) continue;
		
		name = dci.getDepartmentname();
		type = "2";
		id = dci.getDepartmentid();

%>

	<a href="javascript:clickOrg(<%=type%>,<%=id%>);">
	<div style="position:relative;width:100%;height:35px;" id="t_<%=type%>_<%=id%>" expand=0 isload=0>
		<div id="i_<%=type%>_<%=id%>" style="position:absolute;left:10px;top:8px;right:10p x;height:30px;line-height:30px;"><img src="/mobile/plugin/6/images/icon2_wev8.png"></div>
		<div id="l_<%=type%>_<%=id%>" style="position:absolute;left:40px;top:5px;right:10px;height:30px;line-height:30px;" class="text-ellipsis"><%=name %></div>
	</div>
	</a>

	<div style="" id="s_<%=type%>_<%=id%>"></div>

<%
	}
}
%>
<%!
public String getUserList(User user,int type,int pid){
	String html = "";
	try{
		String sql = "";//加入分权控制
		try{
			Class pvm = Class.forName("weaver.hrm.appdetach.AppDetachComInfo");
			Method m = pvm.getDeclaredMethod("getScopeSqlByHrmResourceSearch",String.class);
			sql = (String)m.invoke(pvm.newInstance(),user.getUID()+"");
		}catch(Exception e){
			
		}
		if(sql.equals("")){//没有分权 从缓存获取人员
			ResourceComInfo resourceComInfo = new ResourceComInfo();
			resourceComInfo.setTofirstRow();
			DepartmentComInfo dci = new DepartmentComInfo();
			while(resourceComInfo.next()){
				if(type==1){
					if(Util.getIntValue(resourceComInfo.getSubCompanyID())!=pid||
							dci.getIdIndexKey(resourceComInfo.getDepartmentID())>-1||
							(Util.getIntValue(resourceComInfo.getStatus())!=0&&Util.getIntValue(resourceComInfo.getStatus())!=1&&
							Util.getIntValue(resourceComInfo.getStatus())!=2&&Util.getIntValue(resourceComInfo.getStatus())!=3)) 
						continue;
				}else if(type==2){
					if(Util.getIntValue(resourceComInfo.getDepartmentID())!=pid||
							(Util.getIntValue(resourceComInfo.getStatus())!=0&&Util.getIntValue(resourceComInfo.getStatus())!=1&&
							Util.getIntValue(resourceComInfo.getStatus())!=2&&Util.getIntValue(resourceComInfo.getStatus())!=3)) 
						continue;
				}
				String id = Util.null2String(resourceComInfo.getResourceid());
				String lastname = Util.null2String(resourceComInfo.getLastname());
				String mobile = Util.null2String(resourceComInfo.getMobile()).trim();
				String tel = Util.null2String(resourceComInfo.getTelephone()).trim();
				String mail = Util.null2String(resourceComInfo.getEmail()).trim();
				html+=getUserInfo(3,id,lastname,mobile,tel,mail);
			}
		}else{
			RecordSet rs = new RecordSet();
			String sql2 = "select * from HrmResource where (status =0 or status =1 or status =2 or status =3)";
			if(type==1){
				sql2+=" and subcompanyid1 = "+pid+" and (departmentid = '' or departmentid is null)";
			}else if(type==2){
				sql2+=" and departmentid = "+pid;
			}
			sql2+=" and "+sql;
			rs.executeSql(sql2);
			while(rs.next()){
				String id = Util.null2String(rs.getString("id"));
				String lastname = Util.null2String(rs.getString("lastname"));
				String mobile = Util.null2String(rs.getString("mobile"));
				String tel = Util.null2String(rs.getString("telephone"));
				String mail = Util.null2String(rs.getString("email"));
				html+=getUserInfo(3,id,lastname,mobile,tel,mail);
			}
		}
	}catch(Exception e){
		
	}
	return html;
}

public String getUserInfo(int type,String id,String name,String mobile,String tel,String mail){
	String userInfo = "<div style='position:relative;width:100%;height:150px;' id='t_"+type+"_"+id+"' expand=0 isload=0>"+
	"<div id='b_"+type+"_"+id+"' style='position:absolute;left:10px;top:0px;right:10px;height:135px;border:solid 1px #C6C6C6;border-radius:5px;background:#F2F2F2;'>"+
	"<div style='position:absolute;left:40px;top:-10px;height:6px;display:block;'><img src='/mobile/plugin/6/images/userinfoflag_wev8.png'></div>"+
	"<div style='position:absolute;left:20px;top:10px;right:10px;height:20px;line-height:30px;'><img src='/mobile/plugin/6/images/icon3_wev8.png'></div>"+
	"<div style='position:absolute;left:50px;top:5px;right:10px;height:30px;line-height:30px;' class='text-ellipsis'>"+name+"</div>";
	if(!"".equals(mobile)) { 
		userInfo+="<a href='tel:"+mobile+"'>"+
		"<div style='position:absolute;left:45px;top:35px;right:10px;height:20px;line-height:30px;'>"+
		"<img src='/mobile/plugin/6/images/mobile_wev8.png'></div>"+
		"<div style='position:absolute;left:70px;top:29px;right:10px;height:20px;line-height:30px;'>:&nbsp;&nbsp;"+mobile+"</div>"+
		"</a>";
	} else {
		userInfo+="<div style='position:absolute;left:45px;top:35px;right:10px;height:20px;line-height:30px;'>"+
		"<img src='/mobile/plugin/6/images/mobile_wev8.png'></div>"+
		"<div style='position:absolute;left:70px;top:29px;right:10px;height:20px;line-height:30px;'>:</div>";
	} 
	if(!"".equals(mobile)){
		userInfo+="<a href='sms:"+mobile+"'>"+
		"<div style='position:absolute;left:45px;top:60px;right:10px;height:20px;line-height:30px;'>"+
		"<img src='/mobile/plugin/6/images/sms_wev8.png'></div>"+
		"<div style='position:absolute;left:70px;top:52px;right:10px;height:20px;line-height:30px;'>:&nbsp;&nbsp;发送短信</div>"+
		"</a>";
	} else {
		userInfo+="<div style='position:absolute;left:45px;top:60px;right:10px;height:20px;line-height:30px;'>"+
		"<img src='/mobile/plugin/6/images/sms_wev8.png'></div>"+
		"<div style='position:absolute;left:70px;top:52px;right:10px;height:20px;line-height:30px;'>:</div>";
	}
	if(!"".equals(tel)) {
		userInfo+="<a href='tel:"+tel+"'>"+
		"<div style='position:absolute;left:45px;top:85px;right:10px;height:20px;line-height:30px;'>"+
		"<img src='/mobile/plugin/6/images/tel_wev8.png'></div>"+
		"<div style='position:absolute;left:70px;top:79px;right:10px;height:20px;line-height:30px;'>:&nbsp;&nbsp;"+tel+"</div>"+
		"</a>";
	} else {
		userInfo+="<div style='position:absolute;left:45px;top:85px;right:10px;height:20px;line-height:30px;'>"+
		"<img src='/mobile/plugin/6/images/tel_wev8.png'></div>"+
		"<div style='position:absolute;left:70px;top:79px;right:10px;height:20px;line-height:30px;'>:</div>";
	}
	if(!"".equals(mail)) {
		userInfo+="<a href='mailto:"+mail+"'>"+
		"<div style='position:absolute;left:45px;top:110px;right:10px;height:20px;line-height:30px;'>"+
		"<img src='/mobile/plugin/6/images/mail_wev8.png'></div>"+
		"<div style='position:absolute;left:70px;top:104px;right:10px;height:30px;line-height:30px;' class='text-ellipsis'>:&nbsp;&nbsp;"+mail+"</div>"+
		"</a>";
	} else {
		userInfo+="<div style='position:absolute;left:45px;top:110px;right:10px;height:20px;line-height:30px;'>"+
		"<img src='/mobile/plugin/6/images/mail_wev8.png'></div>";
	}
	userInfo+="</div></div>";
	return userInfo;
}
%>