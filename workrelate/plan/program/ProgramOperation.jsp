<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="net.sf.json.*"%>
<jsp:useBean id="RightUtil" class="weaver.pr.util.RightUtil" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.pr.util.OperateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
	String sql = "";
	String currentUserId = user.getUID()+"";
	String operation = Util.fromScreen3(request.getParameter("operation"),user.getLanguage());
	String resourceid = Util.fromScreen3(request.getParameter("resourceid"),user.getLanguage());
	String resourcetype = Util.fromScreen3(request.getParameter("resourcetype"),user.getLanguage());
	
	//保存及提交
	if(operation.equals("save")){
		if(RightUtil.getProgramRight(resourceid,user,resourcetype)<2){
			response.sendRedirect("../util/Message.jsp?type=1");
			return;
		}
		String programid = Util.fromScreen3(request.getParameter("programid"),user.getLanguage());
		String programtype = Util.fromScreen3(request.getParameter("programtype"),user.getLanguage());
		String auditids = Util.fromScreen3(request.getParameter("auditids"),user.getLanguage());
		String shareids = Util.fromScreen3(request.getParameter("shareids"),user.getLanguage());
		if(!shareids.equals("")){
			if(!shareids.startsWith(",")) shareids = "," + shareids;
			if(!shareids.endsWith(",")) shareids += ",";
		}
		if(!programid.equals("0")){
			if(!programid.equals("")){
				sql = "update PR_PlanProgram set auditids='"+auditids+"',shareids='"+shareids+"' where id="+programid;
				rs.executeSql(sql);
				if(operation.equals("save")) OperateUtil.addProgramLog(currentUserId,programid,2);
			}else{
				sql = "insert into PR_PlanProgram(userid,resourcetype,programtype,auditids,shareids) values("+resourceid+","+resourcetype+","+programtype+",'"+auditids+"','"+shareids+"')";
				boolean flag = rs.executeSql(sql);
				if(flag){
					rs.executeSql("select max(id) from PR_PlanProgram t where t.userid = "+resourceid+" and t.programtype = "+programtype);
					if(rs.next()){
						programid = Util.null2String(rs.getString(1));
						OperateUtil.addProgramLog(currentUserId,programid,1);
					}
				}else{
					response.sendRedirect("../util/Message.jsp?type=3") ;
					return;
				}
			}
		}
		//保存显示列设置明细
		rs.executeSql("delete from PR_PlanProgramDetail where programid = "+programid);
		int rownum1 = Util.getIntValue(request.getParameter("index"),0);
	    String fieldname = "";
	    String showname = "";
	    String customname = "";
	    int isshow = 0;
	    double showorder = 0;
	    int showwidth = 0;
	    int isshow2 = 0;
	    double showorder2 = 0;
	    int showwidth2 = 0;
	    int ismust = 0;
	    int ismust2 = 0;
	    for(int i = 0;i<rownum1;i++){
	    	fieldname = Util.fromScreen3(request.getParameter("fieldname_"+i),user.getLanguage());
	    	showname = Util.fromScreen3(request.getParameter(fieldname+"_showname"),user.getLanguage());
	    	customname = Util.fromScreen3(request.getParameter(fieldname+"_customname"),user.getLanguage());
	    	isshow = Util.getIntValue(request.getParameter(fieldname+"_isshow"),0);
	    	showorder = Util.getDoubleValue(request.getParameter(fieldname+"_showorder"),0);
	    	showwidth = Util.getIntValue(request.getParameter(fieldname+"_showwidth"),0);
	    	isshow2 = Util.getIntValue(request.getParameter(fieldname+"_isshow2"),0);
	    	showorder2 = Util.getDoubleValue(request.getParameter(fieldname+"_showorder2"),0);
	    	showwidth2 = Util.getIntValue(request.getParameter(fieldname+"_showwidth2"),0);
	    	ismust = Util.getIntValue(request.getParameter(fieldname+"_ismust"),0);
	    	ismust2 = Util.getIntValue(request.getParameter(fieldname+"_ismust2"),0);
	    	if(fieldname.equals("name")){ isshow = 1;isshow2 = 1;ismust=1;ismust2=1;}
	    	sql = "insert into PR_PlanProgramDetail(programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2,ismust,ismust2)"
        		+" values("+programid+",'"+showname+"','"+fieldname+"','"+customname+"','"+isshow+"','"+showorder+"','"+showwidth+"','"+isshow2+"','"+showorder2+"','"+showwidth2+"','"+ismust+"','"+ismust2+"')";
			rs.executeSql(sql);
	  	}
	  	//保存默认计划工作内容
		rs.executeSql("delete from PR_PlanReportDetail where programid = "+programid);
		int rownum2 = Util.getIntValue(request.getParameter("indexnum"),0);
	    String name = "",cate="",begindate1="",enddate1="",begindate2="",enddate2="",days1="",days2="",finishrate="",target="",result="",custom1="",custom2="",custom3="",custom4="",custom5="";
	    for(int i = 0;i<rownum2;i++){
	    	name = Util.fromScreen3(request.getParameter("name_value_"+i),user.getLanguage());
	    	cate = Util.fromScreen3(request.getParameter("cate_value_"+i),user.getLanguage());
	    	begindate1 = Util.fromScreen3(request.getParameter("begindate1_value_"+i),user.getLanguage());
	    	enddate1 = Util.fromScreen3(request.getParameter("enddate1_value_"+i),user.getLanguage());
	    	begindate2 = Util.fromScreen3(request.getParameter("begindate2_value_"+i),user.getLanguage());
	    	enddate2 = Util.fromScreen3(request.getParameter("enddate2_value_"+i),user.getLanguage());
	    	days1 = Util.fromScreen3(request.getParameter("days1_value_"+i),user.getLanguage());
	    	days2 = Util.fromScreen3(request.getParameter("days2_value_"+i),user.getLanguage());
	    	finishrate = Util.fromScreen3(request.getParameter("finishrate_value_"+i),user.getLanguage());
	    	target = Util.convertInput2DB(request.getParameter("target_value_"+i));
	    	result = Util.convertInput2DB(request.getParameter("result_value_"+i));
	    	custom1 = Util.convertInput2DB(request.getParameter("custom1_value_"+i));
	    	custom2 = Util.convertInput2DB(request.getParameter("custom2_value_"+i));
	    	custom3 = Util.convertInput2DB(request.getParameter("custom3_value_"+i));
	    	custom4 = Util.convertInput2DB(request.getParameter("custom4_value_"+i));
	    	custom5 = Util.convertInput2DB(request.getParameter("custom5_value_"+i));
	        if(!"".equals(name)){
	        	sql = "insert into PR_PlanReportDetail(programid,planid,planid2,userid,name,cate,begindate1,enddate1,begindate2,enddate2,days1,days2,finishrate,target,result,custom1,custom2,custom3,custom4,custom5)"
	        		+" values('"+programid+"',-1,-1,'"+resourceid+"','"+name+"','"+cate+"','"+begindate1+"','"+enddate1+"','"+begindate2+"','"+enddate2+"','"+days1+"','"+days2+"','"+finishrate+"','"+target+"','"+result+"','"+custom1+"','"+custom2+"','"+custom3+"','"+custom4+"','"+custom5+"')";
				rs.executeSql(sql);
	        }
	  	}
	    if(programid.equals("0")){
	    	response.sendRedirect("ProgramView.jsp?isrefresh=1&resourcetype="+resourcetype+"&programid="+programid+"&programtype="+programtype);
	    }else{
	    	response.sendRedirect("ProgramView.jsp?isrefresh=1&resourceid="+resourceid+"&resourcetype="+resourcetype+"&programid="+programid+"&programtype="+programtype);
	    }
	    return;
	}else if(operation.equals("delete")){
		String programid = Util.fromScreen3(request.getParameter("programid"),user.getLanguage());
		String programtype = Util.fromScreen3(request.getParameter("programtype"),user.getLanguage());
		if(RightUtil.getProgramRight(resourceid,user,resourcetype)<2){
			response.sendRedirect("../util/Message.jsp?type=1");
			return;
		}
		rs.executeSql("delete from PR_PlanReportDetail where planid=-1 and programid="+programid);
		rs.executeSql("delete from PR_PlanProgramDetail where programid="+programid);
		rs.executeSql("delete from PR_PlanProgram where id="+programid);
		response.sendRedirect("ProgramView.jsp?isrefresh=1resourceid="+resourceid+"&programtype="+programtype);
	    return;
	}else if(operation.equals("doReference")){
		String programid = Util.fromScreen3(request.getParameter("programid"),user.getLanguage());
		String ids = Util.fromScreen3(request.getParameter("ids"),user.getLanguage());
		String names = Util.fromScreen3(request.getParameter("names"),user.getLanguage());
		String subCompanyids_refence = Util.fromScreen3(request.getParameter("subCompanyids_refence"),user.getLanguage());
		String programtype = Util.fromScreen3(request.getParameter("programtype"),user.getLanguage());
		String msg = "";
		try{
			if(!programid.equals("")&&!ids.equals("")&&!"".equals(subCompanyids_refence)&&!"".equals(programtype)){
				String idss[] = ids.split(",");
				String namess[] = names.split(",");
				String auditids = "";
				rs.executeSql("select * from PR_PlanProgram where id ="+programid);
				if(rs.next()){
					auditids = Util.null2String(rs.getString("auditids"));
					rs.executeSql("select * from PR_PlanProgramDetail where programid="+programid);
					List<String[]> list = new ArrayList<String[]>();//保存当前被复制的模板的内容
					while(rs.next()){
						String showname = Util.null2String(rs.getString("showname"));
						String fieldname = Util.null2String(rs.getString("fieldname"));
						String customname = Util.null2String(rs.getString("customname"));
						String isshow = Util.null2String(rs.getString("isshow"));
						String showorder = Util.null2String(rs.getString("showorder"));
						String showwidth = Util.null2String(rs.getString("showwidth"));
						String isshow2 = Util.null2String(rs.getString("isshow2"));
						String showorder2 = Util.null2String(rs.getString("showorder2"));
						String showwidth2 = Util.null2String(rs.getString("showwidth2"));
						String ismust = Util.null2String(rs.getString("ismust"));
						String ismust2 = Util.null2String(rs.getString("ismust2"));
						String[] columns = new String[11];
						columns[0] = showname;
						columns[1] = fieldname;
						columns[2] = customname;
						columns[3] = isshow;
						columns[4] = showorder;
						columns[5] = showwidth;
						columns[6] = isshow2;
						columns[7] = showorder2;
						columns[8] = showwidth2;
						columns[9] = ismust;
						columns[10]= ismust2;
						list.add(columns);
					}
					rs.executeSql("select * from PR_PlanReportDetail where programid="+programid);
					List<String[]> list2 = new ArrayList<String[]>();//保存当前被复制的模板的自定义计划内容
					while(rs.next()){
						String name = Util.null2String(rs.getString("name"));
						String cate = Util.null2String(rs.getString("cate"));
						String begindate1 = Util.null2String(rs.getString("begindate1"));
						String enddate1 = Util.null2String(rs.getString("enddate1"));
						String begindate2 = Util.null2String(rs.getString("begindate2"));
						String enddate2 = Util.null2String(rs.getString("enddate2"));
						String days1 = Util.null2String(rs.getString("days1"));
						String days2 = Util.null2String(rs.getString("days2"));
						String finishrate = Util.null2String(rs.getString("finishrate"));
						String target = Util.null2String(rs.getString("target"));
						String result = Util.null2String(rs.getString("result"));
						String custom1 = Util.null2String(rs.getString("custom1"));
						String custom2 = Util.null2String(rs.getString("custom2"));
						String custom3 = Util.null2String(rs.getString("custom3"));
						String custom4 = Util.null2String(rs.getString("custom4"));
						String custom5 = Util.null2String(rs.getString("custom5"));
						String[] columns = new String[16];
						columns[0] = name;
						columns[1] = cate;
						columns[2] = begindate1;
						columns[3] = enddate1;
						columns[4] = begindate2;
						columns[5] = enddate2;
						columns[6] = days1;
						columns[7] = days2;
						columns[8] = finishrate;
						columns[9] = target;
						columns[10] = result;
						columns[11] = custom1;
						columns[12] = custom2;
						columns[13] = custom3;
						columns[14] = custom4;
						columns[15] = custom5;
						list2.add(columns);
					}
					for(int i=0;i<idss.length;i++){
						String id = idss[i];
						String name = namess[i];
						if(!id.equals("")){
							//获取这个账号所在的分部
							String subcompanyid = ResourceComInfo.getSubCompanyID(id);
							if(subCompanyids_refence.indexOf(","+subcompanyid+",")>-1){
								//判断该用户是否保存过计划模板有的话先删除原来的
								rs.executeSql("select id from PR_PlanProgram where userid="+id
										+" and resourcetype=4 and programtype="+programtype);
								if(rs.next()){
									String oldId = Util.null2String(rs.getString("id"));
									rs.executeSql("delete from PR_PlanProgram where id="+oldId);
									rs.executeSql("delete from PR_PlanProgramDetail where programid="+oldId);
								}
								String pgid = "";
								boolean flag = rs.executeSql("insert into PR_PlanProgram(userid,resourcetype,programtype,auditids,shareids) values("+
									id+",4,"+programtype+",'"+auditids+"','')");
								if(flag){
									rs.executeSql("select max(id) from PR_PlanProgram t where t.userid = "+id+" and t.programtype ="+programtype);
									if(rs.next()){
										pgid = Util.null2String(rs.getString(1));
										OperateUtil.addProgramLog(currentUserId,pgid,1);
									}
								}else{
									msg += "用户["+name+"]同步失败:执行插入语句失败\n";
								}
								if(!"".equals(pgid)){//针对当前人插入明细数据
									for(String[] columns:list){
										if(null!=columns&&columns.length==11){
											String sql_pd = "insert into PR_PlanProgramDetail(programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2,ismust,ismust2)"
									        		+" values("+pgid+",'"+columns[0]+"','"+columns[1]+"','"+columns[2]+"','"+columns[3]+"','"+columns[4]+"','"+columns[5]+"','"+columns[6]+"','"+columns[7]+"','"+columns[8]+"','"+columns[9]+"','"+columns[10]+"')";
											rs.executeSql(sql_pd);
										}
									}
									for(String[] columns:list2){
										if(null!=columns&&columns.length==16){
											String sql_rp = "insert into PR_PlanReportDetail(programid,planid,planid2,userid,name,cate,begindate1,enddate1,begindate2,enddate2,days1,days2,finishrate,target,result,custom1,custom2,custom3,custom4,custom5)"
									        		+" values('"+pgid+"',-1,-1,'"+id+"','"+columns[0]+"','"+columns[1]+"','"+columns[2]+"','"+columns[3]+"','"+columns[4]+"','"+columns[5]+"','"+columns[6]+"','"+columns[7]+"','"+columns[8]+"','"+columns[9]+"','"+columns[10]+"','"+columns[11]+"','"+columns[12]+"','"+columns[13]+"','"+columns[14]+"','"+columns[15]+"')";
											rs.executeSql(sql_rp);
										}
									}
									msg +="用户["+name+"]同步成功\n";
								}
							}else{
								msg +="用户["+name+"]同步失败:您没有权限更改此人计划报告模板\n";
							}
						}else if(!name.equals("")){
							msg +="用户["+name+"]同步失败:没有获取到其ID\n";
						}
					}
				}else{
					msg = "没有找到引用的模板";
				}
			}else{
				msg = "参数不正确";
			}
		}catch(Exception e){
			e.printStackTrace();
			msg = "同步操作失败:"+e.getMessage();
		}
		JSONObject json = new JSONObject();
		json.put("msg", msg);
		out.print(json.toString());
	}
%>
