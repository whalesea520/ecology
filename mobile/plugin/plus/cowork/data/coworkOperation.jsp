<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="java.net.*"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%@ page import="weaver.cowork.CoworkLabelVO"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page"/>
<jsp:useBean id="CoTypeRight" class="weaver.cowork.CoTypeRight" scope="page"/>
<jsp:useBean id="csm" class="weaver.cowork.CoworkShareManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="coworkItemMarkOperation" class="weaver.cowork.CoworkItemMarkOperation" scope="page" />
<jsp:useBean id="coTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<jsp:useBean id="coworkService" class="weaver.mobile.plugin.ecology.service.CoworkService" scope="page" />
<%
	int status = 1;String msg = ""; 
	Map result = new HashMap();
	String userId=user.getUID()+"";
	JSONObject json = new JSONObject();
	request.setCharacterEncoding("UTF-8");
	FileUpload fu = new FileUpload(request);
	//response.setContentType("application/json;charset=UTF-8");
	String operate = Util.null2String(fu.getParameter("operate"));
	String currentDate = TimeUtil.getCurrentDateString();
	String currentTime = TimeUtil.getOnlyCurrentTimeString();
	char flag = 2;
	String Proc="";
	try{
		if(operate.equals("getCoworkType")){//获取协作类型 增加返回当前用户ID和姓名，用于固定负责人
			JSONArray ja = new JSONArray();
			while(CoTypeComInfo.next()){
            	String tmptypeid=CoTypeComInfo.getCoTypeid();
                String typename=CoTypeComInfo.getCoTypename();  
                String isAnonymouss = CoTypeComInfo.getIsAnonymouss();
                int sharelevel = CoTypeRight.getRightLevelForCowork(""+userId,tmptypeid);
                if(sharelevel==0) continue;
                JSONObject jo = new JSONObject();
                jo.put("id", tmptypeid);
                jo.put("name", typename);
                jo.put("isAnonymouss", isAnonymouss);
                ja.put(jo);
	    	}
			json.put("typeList", ja);
			json.put("userid", userId);
			ResourceComInfo rc = new ResourceComInfo();
			json.put("userName", rc.getLastname(userId));
			status = 0;
		}else if(operate.equals("addCowork")){//新增协作
			String creater = userId;//创建人 不需要传
			String name = Util.null2String(fu.getParameter2("name"));//协作名称 必传
			//System.out.println("name1111==="+name);
			//System.out.println("nam222222==="+fu.getParameter("name"));
			name = Util.null2String(new String(name.getBytes("ISO-8859-1"), "utf-8"));
			//System.out.println("name333==="+name);
			String typeid = Util.fromScreen(fu.getParameter("typeid"),user.getLanguage());//协作类型ID 必传
			String principal = Util.null2String(fu.getParameter("txtPrincipal"));//协作负责人 必传
			String begindate = Util.null2String(fu.getParameter("begindate"));//开始日期 必传
			String enddate = Util.null2String(fu.getParameter("enddate"));//结束日期 必传
			if(begindate.equals("")){
				begindate = currentDate;
			}
			if(enddate.equals("")){
				enddate = currentDate;
			}
			String levelvalue = Util.fromScreen(fu.getParameter("levelvalue"),user.getLanguage());//协作紧急程度 非必传
			String beingtime = Util.null2String(fu.getParameter("beingtime"));//开始时间 非必传
			String endtime = Util.null2String(fu.getParameter("endtime"));//结束时间 非必传
			if(beingtime.equals("")){
				beingtime = currentTime.substring(0,5);
			}
			if(endtime.equals("")){
				endtime = currentTime.substring(0,5);
			}
			String relatedprj = Util.fromScreen(fu.getParameter("relatedprj"),user.getLanguage()); //相关项目任务 手机版默认为空
			String relatedcus = Util.fromScreen(fu.getParameter("relatedcus"),user.getLanguage()); //相关客户 手机版默认为空
			String relatedwf = Util.fromScreen(fu.getParameter("relatedwf"),user.getLanguage());   //相关流程 手机版默认为空
			String relateddoc = Util.fromScreen(fu.getParameter("relateddoc"),user.getLanguage()); //相关文档 手机版默认为空
			String relatedacc =Util.fromScreen(fu.getParameter("relatedacc"),user.getLanguage());  //相关附件 手机版默认为空
			String remark = Util.null2String(fu.getParameter2("remark"));//描述 非必传
			String isAnonymouss = Util.null2String(fu.getParameter("isAnonymouss"));//是否允许匿名 0否 1是
			String accessorys = Util.null2String(fu.getParameter("accessorys"));//附件ID
			//System.out.println("accessorys========="+accessorys);
			remark = Util.null2String(new String(remark.getBytes("ISO-8859-1"), "utf-8"));
			String projectIDs = Util.null2String(fu.getParameter("projectIDs"));//相关项目 手机版默认为空
			if(!name.equals("")&&!begindate.equals("")&&!principal.equals("")){
				String tempdocids = "";
				ArrayList docids = new ArrayList();
				docids = Util.TokenizerString(relateddoc,",");
				for(int i=0;i<docids.size();i++){
					tempdocids =tempdocids+docids.get(i).toString()+"|"+userId+",";
				}
				String id = "";
				//添加事务控制，创建异常回滚数据
			    RecordSetTrans rst=new RecordSetTrans();
				rst.setAutoCommit(false);
				try{
					String[] fileids = accessorys.split(",");
					if(fileids.length>0){
						StringBuffer sb = new StringBuffer();
						for(String fileid:fileids){
							if(!"".equals(fileid)){
								sb.append("<img src=\"/weaver/weaver.file.FileDownload?fileid="+fileid+"\" alt=\"\"/><br/>");
							}
						}
						remark = sb.toString()+remark;
					}
					Proc=name+flag+typeid+flag+levelvalue+flag+creater+flag+principal+flag+
						  currentDate+flag+currentTime+flag+begindate+flag+beingtime+flag+enddate+flag+
				          endtime+flag+relatedprj+flag+relatedcus+flag+relatedwf+flag+tempdocids+flag+
				          remark+flag+status+flag+relatedacc+flag+projectIDs+flag+creater;
					rst.executeProc("cowork_items_insert",Proc);
					//获取当前协作id
					while(rst.next()){
						id = rst.getString(1);
					}
					rst.commit();
				}catch(Exception e){
					rst.rollback();
					e.printStackTrace();
					msg = e.getMessage();
				}
				//判断协作是否创建成功不为空表示创建成功
				if(!id.equals("")){
					//添加协作参与人共享表  
					//页面需要有参数shareOperation值为add
					//sharetype：选择某些人值为1,选择所有人 值为5
					//shareid：固定传0
					//relatedshareid:选择某些人 值为用户ID,前后必须加上逗号,比如: ,6,7,8,  选择所有人此参数为空
					//secLevel 安全级别 固定传0
				    csm.addShare(id,creater,principal,fu);
				  	//附件共享
				    if(!"".equals(relatedacc)){
				       csm.addCoworkDocShare(userId,relatedacc,typeid,id,principal);
				    }
				  	//将创建者添加到已读
					rs.execute("insert into cowork_read(coworkid,userid) values("+id+","+userId+")");
					//log here 1-new;2-view;3-edit  协作创建日志
					String ProcPara = id+flag+"1"+flag+currentDate+flag+currentTime+flag+userId+flag+fu.getRemoteAddr();
					rs.executeProc("cowork_log_insert",ProcPara);
					//
					rs.execute("update cowork_items set lastupdatedate='"+currentDate+"',lastupdatetime='"+currentTime+"',isApproval=0,isAnonymous="+isAnonymouss+",accessory='',approvalAtatus=0 where id="+id);
					rs.executeSql("update cowork_items set istop=0,readNum=0,replyNum=0 where id = "+id);
					json.put("id", id);
					status = 0;
				}else{
					msg = "创建协作失败:"+msg;
				}
			}else{
				msg = "相关信息不完整";
			}
		}else if(operate.equals("editCowork")){//编辑协作
			String creater = userId;//创建人 不需要传
			String id = Util.null2String(fu.getParameter("id"));//协作ID
			String name = Util.fromScreen(fu.getParameter("name"),user.getLanguage());//协作名称 必传
			String typeid = Util.fromScreen(fu.getParameter("typeid"),user.getLanguage());//协作类型ID 必传
			String principal = Util.null2String(fu.getParameter("txtPrincipal"));//协作负责人 必传
			String begindate = Util.fromScreen(fu.getParameter("begindate"),user.getLanguage());//开始日期 必传
			String enddate = Util.fromScreen(fu.getParameter("enddate"),user.getLanguage());//结束日期 必传
			String levelvalue = Util.fromScreen(fu.getParameter("levelvalue"),user.getLanguage());//协作紧急程度 非必传
			String beingtime = Util.fromScreen(fu.getParameter("beingtime"),user.getLanguage());//开始时间 非必传
			String endtime = Util.fromScreen(fu.getParameter("endtime"),user.getLanguage());//结束时间 非必传
			String relatedprj = Util.fromScreen(fu.getParameter("relatedprj"),user.getLanguage()); //相关项目任务 手机版默认为空
			String relatedcus = Util.fromScreen(fu.getParameter("relatedcus"),user.getLanguage()); //相关客户 手机版默认为空
			String relatedwf = Util.fromScreen(fu.getParameter("relatedwf"),user.getLanguage());   //相关流程 手机版默认为空
			String relateddoc = Util.fromScreen(fu.getParameter("relateddoc"),user.getLanguage()); //相关文档 手机版默认为空
			String relatedacc =Util.fromScreen(fu.getParameter("relatedacc"),user.getLanguage());  //相关附件 手机版默认为空
			String remark = Util.null2String(fu.getParameter("remark"));//描述 非必传
			String projectIDs = Util.null2String(fu.getParameter("projectIDs"));//相关项目 手机版默认为空
			if(!name.equals("")&&!begindate.equals("")&&!enddate.equals("")&&!principal.equals("")){
				csm.deleteShare(id); //删除原有参与条件
				csm.addShare(id,creater,principal,fu);//添加的新的参与条件 参与条件格式参考新建协作
				Proc=id+flag+name+flag+typeid+flag+levelvalue+flag+principal+flag+
				        projectIDs+flag+begindate+flag+beingtime+flag+enddate+flag+endtime+flag+
				        relatedprj+flag+relatedcus+flag+relatedwf+flag+""+flag+remark+flag+
				        relatedacc;
				rs.executeProc("cowork_items_update",Proc);
				//将当前操作者者添加到已读者中
				rs.executeSql("insert into cowork_read(coworkid,userid) values("+id+","+userId+")");
				//log here 1-new;2-view;3-edit
				String ProcPara = ""+id+flag+"3"+flag+currentDate+flag+currentTime+flag+userId+flag+fu.getRemoteAddr();
				rs.executeProc("cowork_log_insert",ProcPara);
				status = 0;
			}else{
				msg = "相关信息不完整";
			}
		}else if(operate.equals("getCoworkById")){
			
		}
		//获取协作标签
		else if(operate.equals("getCoopLabels")){
			//判断编码
			if(WxInterfaceInit.isIsutf8()){
				response.setContentType("application/json;charset=UTF-8");
			}
			
			User vuser = HrmUserVarify.getUser (request , response) ;
			if(vuser==null) {
				status = 0;
				msg = "用户登录失败";
			} else {
				int userid = user.getUID();
				List<CoworkLabelVO> labels = coworkItemMarkOperation.getLabelList("" + userid, "all");
				JSONArray jArray = new JSONArray();
				JSONObject jObject = null;
				for (CoworkLabelVO label : labels) {
					if (!"1".equals(label.getIsUsed())) {
						continue;
					}
					
					jObject = new JSONObject();
					String labelId = "";
					String labelName = "";
					String labelType = label.getLabelType();
					
					if ("unread".equals(labelType)) {
						labelId = "-1";
					} else if ("important".equals(labelType)) {
						labelId = "-2";
					} else if ("hidden".equals(labelType)) {
						labelId = "-3";
					} else {
						labelId = label.getId();
					}
					
					if ("label".equals(labelType)) {
						labelName = label.getName();
					} else if ("typePlate".equals(labelType)) {
						labelName = coTypeComInfo.getCoTypename(label.getName());
					} else {
						labelName = SystemEnv.getHtmlLabelName(Util.getIntValue(label.getName()), user.getLanguage());
					}
					
					jObject.put("id", labelId);
					jObject.put("name", labelName);
					jObject.put("labelType", labelType);
					jObject.put("labelColor", label.getLabelColor());
					jObject.put("textColor", label.getTextColor());
					jArray.put(jObject);
				}
				result.put("labels", jArray);
				status = 1;
			}
			
			result.put("status", status);
			result.put("msg", msg);
			out.println(new JSONObject(result));
			return;
		}
		//获取协作列表
		else if(operate.equals("getCoworkList")){
			//判断编码
			if(WxInterfaceInit.isIsutf8()){
				response.setContentType("application/json;charset=UTF-8");
			}
			
			User vuser = HrmUserVarify.getUser (request , response) ;
			if(vuser==null) {
				status = 0;
				msg = "用户登录失败";
			} else {
				int userid = user.getUID();
				int labelid = Util.getIntValue(fu.getParameter("labelid"), 0);
				String labeltype = Util.null2String(fu.getParameter("labeltype"));
				int pageIndex = Util.getIntValue(fu.getParameter("pageindex"), 1);
				int pageSize = Util.getIntValue(fu.getParameter("pagesize"), 10);
				String keyword = Util.null2String(fu.getParameter("keyword"));
				keyword = URLDecoder.decode(keyword, "utf-8");
				
				List conditions = new ArrayList();
				if ("typePlate".equals(labeltype)) {
					conditions.add("0");
					conditions.add(" typeid = (select name from cowork_label where id = "+labelid+")");
				} else {
					conditions.add(""+labelid);
				}
				
				if(keyword!=null && !"".equals(keyword)) {
					conditions.add(" (name like '%"+keyword+"%') ");
				}
				
				result = coworkService.getCoworkList(conditions, pageIndex, pageSize, user);
				out.println(new JSONObject(result));
				return;
			}
		}
	}catch(Exception e){
		e.printStackTrace();
		msg = e.getMessage();
	}
	json.put("status",status);
	json.put("msg",msg);
	//System.out.println(json.toString());
	out.println(json.toString());
%>