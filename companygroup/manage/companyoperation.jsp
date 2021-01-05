
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cm" class="weaver.company.CompanyManager" scope="page" />
<jsp:useBean id="pro" class="weaver.cpcompanyinfo.ProManageUtil" scope="page" />
<jsp:useBean id="cu" class="weaver.company.CompanyUtil" scope="page" />
<%
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	String xmlContent="";
	out.clear();
	
	User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
	if(user != null)  {
		
		String method = Util.null2String(request.getParameter("method"));
		String groupid = Util.null2String(request.getParameter("groupid"));
		int lanauage=user.getLanguage();
		//groupid = "166";
		if(method.equals("queryCompanyForSelect")){//AB公司-公司来源
			
			String key = Util.null2String(request.getParameter("key"));
			String value = Util.null2String(request.getParameter("value"));
			String ids ="";
			if(key.equals("all")){
				ids = "all";
			}else{
				ids= cm.getGroupHighLights(groupid,key,value);
			}
			String str = cm.getABCompanyIDs(groupid,ids);
			str = str.replaceAll(" ","");
			if(str.length()>0){
				str = str.substring(0,str.length()-1);
				str = "["+str+"]";
			}
			//System.out.println(str);
			out.println(str);
		}else if(method.equals("queryCompanyInfoById")){//查询公司信息
			String xml = cm.getCompanyInfo(Util.null2String(request.getParameter("id")));
			out.println(xml);
			//System.out.println(xml);
			pro.writeCompanylog("4",Util.null2String(request.getParameter("id")),"4",user.getUID()+"","公司信息");
		}else if(method.equals("saveLineInfo")){//存储线条顶点信息
			cm.saveLineInfo(request.getParameter("xml"));
			pro.writeCompanylog("4",Util.null2String(request.getParameter("groupid")),"2",user.getUID()+"","调整连线位置");
		}else if(method.equals("getGroupInfo")){
			//得到需要在flash页面中显示的集团--用于绘画组织架构图
			if(groupid.equals("")){
				groupid = cm.getGroupid(true);
			}
			String xml = cm.getGroupInfo(groupid,"");
			out.println(xml);
			//pro.writeCompanylog("4",groupid,"4",user.getUID()+"","集团信息");
		}else if(method.equals("createVersion")){//创建版本
			
			String no = Util.null2String(request.getParameter("no"));
			String name=Util.null2String(request.getParameter("name"));
			String createdate=Util.null2String(request.getParameter("createdate"));
			String desc = Util.null2String(request.getParameter("desc"));
			cm.saveGroupVerion(groupid,no,name,createdate,desc);
			pro.writeCompanylog("4",Util.null2String(request.getParameter("groupid")),"1",user.getUID()+"","创建版本");
		}else if(method.equals("getVersionList")){//获取版本列表
			//System.out.println(groupid);
			String xml = cm.getGroupVersionList(groupid);
			out.println(xml);
		}else if (method.equals("getVersion")){ // 获取某个版本具体视图显示信息XML
		
			String xml = cm.getGroupVersionOne(Util.null2String(request.getParameter("id")));
			out.println(xml);
			pro.writeCompanylog("4",Util.null2String(request.getParameter("groupid")),"4",user.getUID()+"","查看版本");
			
		}else if(method.equals("getCompanysByKeyWord")){ // 公司查询
			
			
			
			String key = Util.null2String(request.getParameter("key"));
			String value = Util.null2String(request.getParameter("value"));
			String jt_key = Util.null2String(request.getParameter("jt_key"));
			String yw_key = Util.null2String(request.getParameter("yw_key"));
			String gs_key = Util.null2String(request.getParameter("gs_key"));
			
			String xml = cm.getGroupHighLights(groupid,yw_key,gs_key,value,key);
			out.println(xml);
			pro.writeCompanylog("4",Util.null2String(request.getParameter("groupid")),"4",user.getUID()+"","查询公司");
			
			
		}else if(method.equals("getABGroupInfo")){
			String companyA = Util.null2String(request.getParameter("companyA"));
			String companyB = Util.null2String(request.getParameter("companyB"));
			//得到要显示高亮的公司的ids
			String ids = ","+cm.getABGroupIDs(groupid,companyA,companyB);
			String xml = cm.getGroupInfo(groupid,ids);
			out.println(xml);
			pro.writeCompanylog("4",Util.null2String(request.getParameter("groupid")),"4",user.getUID()+"","查看A-B关系");
			//System.out.println(ids+"查询公司关系"+xml);
		}else if(method.equals("getGroupList")){
			//得到集团列表下拉框中的数据
			String str = cm.getGroupid(false);
			if(str.length()>0){
				str = str.substring(0,str.length()-1);
				str = "["+str+"]";
			}
			out.println(str);
		}else if(method.equals("getLogList")){
			//System.out.println(""+Util.getIntValue(request.getParameter("index"),1));
			String xml ="";
			xml = cm.getLogList(Util.getIntValue(request.getParameter("index"),1),Util.getIntValue(request.getParameter("perpage"),10),Util.null2String(request.getParameter("operate")),Util.null2String(request.getParameter("archiveno")),lanauage);
			out.println(xml);
			//System.out.println(xml);
		}else if(method.equals("getGroupidBySearch")){
			String key = Util.null2String(request.getParameter("key"));
			String value = Util.null2String(request.getParameter("value"));
			String jt_key = Util.null2String(request.getParameter("jt_key"));
			String yw_key = Util.null2String(request.getParameter("yw_key"));
			String gs_key = Util.null2String(request.getParameter("gs_key"));
			String xml = cm.getGroupIdsByKeyWord(key,value);
			out.println(xml);
			//pro.writeCompanylog("4",Util.null2String(request.getParameter("groupid")),"4",user.getUID()+"","查询公司");
		}else if(method.equals("getCompanyService")){
				//zzl--得到业务类型下拉框中的数据
				String str = cm.getCompanyService(lanauage);
				//str = str.replaceAll(" ","");
				if(str.length()>0){
					str = str.substring(0,str.length()-1);
					str = "["+str+"]";
				}
				out.println(str);
		}else if(method.equals("getCompanyAttributablekey")){
				String str = cm.getCompanyAttributablekey(lanauage);
				//str = str.replaceAll(" ","");
				if(str.length()>0){
					str = str.substring(0,str.length()-1);
					str = "["+str+"]";
				}
				out.println(str);
		}
		else if(method.equals("getCompanyAttributable")){
				//zzl--得到公司归属下拉框中的数据
				String str = cm.getCompanyAttributable(lanauage);
				//str = str.replaceAll(" ","");
				if(str.length()>0){
					str = str.substring(0,str.length()-1);
					str = "["+str+"]";
				}
				out.println(str);
		}else if(method.equals("getOpenright")){
				String message="";
				if(cu.canOperate(user,"2")){
					//后台维护权限
					message="no";
				}else{
					message="ok";
				}
				out.print(message);
		}
		else if(method.equals("getAB_Time")){
				//得到ab公司关系最后更新时间
				rs.execute("select abtime  from CPCOMPANYINFOAB");
				if(rs.next()){
					out.println(rs.getString("abtime"));
				}
		}else if(method.equals("getUserLanguage")){
				//输出的语言
				out.print(user.getLanguage());
			
		}else if(method.equals("checkVersion")){
				String no = Util.null2String(request.getParameter("no"));
				 if(no.length()>0&&(no.lastIndexOf(".")==(no.length()-1))){
			 		out.println("nook");
		 		 }else{
		 		 	String sql=" select count(*) s from GroupVersionInfo where companyid='"+groupid+"' and no='"+no+"'";
					//System.out.println("执行的语句"+sql);
					if(rs.execute(sql)&&rs.next()){
						if(rs.getInt("s")>0){
							out.println("nook");
						}else{
							out.println("ok");
						}
					}else{
						out.println("ok");
					}
					//验证版本号是否重复
					//System.out.println(groupid+"检查版本好"+no);
		 		 }
		}
	}else{
		//System.out.print("no user!");
		out.println("");	
	}
%>

