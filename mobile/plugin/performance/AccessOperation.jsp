<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.docs.docs.*"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.file.FileUpload"%>
<jsp:useBean id="AccessItemComInfo" class="weaver.gp.cominfo.AccessItemComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RightUtil" class="weaver.gp.util.RightUtil" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.gp.util.TransUtil" scope="page" />
<%
	request.setCharacterEncoding("UTF-8");	
	String currentUserId = user.getUID()+"";
	String msg = "";
	String result_scoreid ="";
	String result_exchange = "";
	
	try{
		FileUpload fu = new FileUpload(request);
		String resourceid = Util.null2String(fu.getParameter("resourceid"));
		String operation = Util.null2String(fu.getParameter("operation")); 
		//保存及提交
		if(operation.equals("save")||operation.equals("submit")){
			String scoreid =  Util.null2String(fu.getParameter("scoreid"));
			//判断是否能考核评分
			rs.executeSql("select userid,year,type1,type2,status,operator,startdate,enddate,auditids from GP_AccessScore where id = "+scoreid);
			if(rs.next()){
				boolean canedit = true;
				String status = Util.null2String(rs.getString("status"));
				String currentoperator = Util.null2String(rs.getString("operator"));
				String startdate = Util.null2String(rs.getString("startdate"));
				String enddate = Util.null2String(rs.getString("enddate"));
				String auditids = Util.null2String(rs.getString("auditids"));
				String currentdate = TimeUtil.getCurrentDateString();
				if(TimeUtil.dateInterval(startdate,currentdate)<0 || TimeUtil.dateInterval(enddate,currentdate)>0){
					canedit = false;
				}
				if(!"0".equals(status)&&!"2".equals(status)){
					canedit = false;
				}
				if(!currentoperator.equals(currentUserId)){
					canedit = false;
				}
				if(!canedit){
					msg = "您暂时无权限查看此信息！";
				}else{
					//更新总分
					String score_result = Util.getDoubleValue(fu.getParameter("score_result"),0)+"";
					rs.executeSql("update GP_AccessScore set result="+score_result+",isinit=0 where id="+scoreid);
					String checkid = "";
					int currentexeorder = 0;
					rs3.executeSql("select id,status,exeorder,userid from GP_AccessScoreCheck where scoreid="+scoreid);
					while(rs3.next()){
						String checkstatus = Util.null2String(rs3.getString("status"));
						int exeorder = Util.getIntValue(rs3.getString("exeorder"),0);
						if(operation.equals("submit")) checkstatus = "2";
						checkid = Util.null2String(rs3.getString(1));
						String exeuserid = Util.null2String(rs3.getString("userid"));
						String s_score = Util.getDoubleValue(fu.getParameter("s_score_"+checkid),0)+"";
						String s_revise = Util.getDoubleValue(fu.getParameter("s_revise_"+checkid),0)+"";
						String s_remark = Util.convertInput2DB(fu.getParameter("s_remark_"+checkid));
						String s_result = Util.getDoubleValue(fu.getParameter("s_result_"+checkid),0)+"";
						String fileids = Util.null2String(fu.getParameter("newrelatedacc")).trim();
						String s_reason = Util.convertInput2DB(fu.getParameter("s_reason_"+checkid));
						
						if(exeuserid.equals(currentUserId)){
							currentexeorder = exeorder;
							String edit_relatedacc=Util.null2String(fu.getParameter("edit_relatedacc")).trim();
							if(edit_relatedacc.endsWith(",")) edit_relatedacc = edit_relatedacc.substring(0,edit_relatedacc.length()-1);
							String delrelatedacc =Util.fromScreen(fu.getParameter("delrelatedacc"),user.getLanguage());  //删除相关附件id
					    	if(!edit_relatedacc.equals("")){
					    		fileids = edit_relatedacc + "," + fileids;//新附件id
					    	}
					   		if(fileids.endsWith(",")) fileids = fileids.substring(0,fileids.length()-1);
					   		if(!fileids.equals("")) fileids = "," + fileids + ",";
					   		//删除附件
					   		if(!delrelatedacc.equals("")){
					   			List delidList = Util.TokenizerString(delrelatedacc,",");
					   			for(int i=0;i<delidList.size();i++){
					   				int docid = Util.getIntValue((String)delidList.get(i),0);
					   				if(docid!=0){
					   					DocManager dm = new DocManager();
										dm.setId(docid);
										dm.setUserid(user.getUID());
										dm.DeleteDocInfo();
					   				}
					   			}
					   		}
							
							//保存人员评分信息
							rs.executeSql("update GP_AccessScoreCheck set score="+s_score+",revise="+s_revise+",remark='"+s_remark+"',result="+s_result+",status="+checkstatus+",fileids='"+fileids+"',reason='"+s_reason+"' where id="+checkid);
							//保存人员评分明细
							String detailid = "";
							String accessitemid = "";
							String target = "";
							String target1 = "";
							String target2 = "";
							String result = "";
							String result1 = "";
							String result2 = "";
							String next = "";
							String next1 = "";
							String next2 = "";
							String d_score = "";
							String d_result = "";
							String d_remark = "";
							rs.executeSql("delete from GP_AccessScoreCheckDetail where scoreid="+scoreid+" and checkid="+checkid);
							rs.executeSql("select t.id,t.accessitemid,t.rate from GP_AccessScoreDetail t where t.scoreid="+scoreid);
							while(rs.next()){
								detailid = Util.null2String(rs.getString("id"));
								accessitemid = Util.null2String(rs.getString("accessitemid"));
								target = Util.null2String(fu.getParameter("target_"+detailid));
								result = Util.null2String(fu.getParameter("result_"+detailid));
								next = Util.null2String(fu.getParameter("next_"+detailid));
								if("1".equals(AccessItemComInfo.getType(accessitemid))){
									target1 = "0";
									target2 = target;
									result1 = "0";
									result2 = result;
									next1 = "0";
									next2 = next;
					        	}else{
					        		target1 = Util.getDoubleValue(target,0)+"";
									target2 = "";
					        		result1 = Util.getDoubleValue(result,0)+"";
					        		result2 = "";
					        		next1 = Util.getDoubleValue(next,0)+"";
					        		next2 = "";
					        	}
								//更新目标值、完成值、下月目标值
								rs2.executeSql("update GP_AccessScoreDetail set target1="+target1+",target2='"+target2+"',result1="+result1+",result2='"+result2+"',next1="+next1+",next2='"+next2+"' where id="+detailid);
								//更新评分明细
								d_score = Util.getDoubleValue(fu.getParameter("d_score_"+detailid+"_"+checkid),0)+"";
								d_result = Util.getDoubleValue(fu.getParameter("d_result_"+detailid+"_"+checkid),0)+"";
								d_remark = Util.convertInput2DB(fu.getParameter("d_remark_"+detailid+"_"+checkid));
								rs2.executeSql("insert into GP_AccessScoreCheckDetail (scoreid,detailid,checkid,score,result,remark)"
										+" values("+scoreid+","+detailid+","+checkid+","+d_score+","+d_result+",'"+d_remark+"')");
							}
						}else{
							//保存人员评分信息
							rs.executeSql("update GP_AccessScoreCheck set score="+s_score+",result="+s_result+" where id="+checkid);
							//更新其他人员的评分明细
							String detailid = "";
							String accessitemid = "";
							String cdid = "";
							String d_score = "";
							String d_result = "";
							//rs.executeSql("delete from GP_AccessScoreCheckDetail where scoreid="+scoreid+" and checkid="+checkid);
							rs.executeSql("select t.id,t.accessitemid,t.rate from GP_AccessScoreDetail t where t.scoreid="+scoreid);
							while(rs.next()){
								detailid = Util.null2String(rs.getString("id"));
								accessitemid = Util.null2String(rs.getString("accessitemid"));
								if(Util.getIntValue(AccessItemComInfo.getFormula(accessitemid),0)!=0){
									//更新评分明细
									d_score = Util.getDoubleValue(fu.getParameter("d_score_"+detailid+"_"+checkid),0)+"";
									d_result = Util.getDoubleValue(fu.getParameter("d_result_"+detailid+"_"+checkid),0)+"";
									cdid = Util.null2String(fu.getParameter("cdid_"+detailid+"_"+checkid));
									if(cdid.equals("")){
										rs2.executeSql("insert into GP_AccessScoreCheckDetail (scoreid,detailid,checkid,score,result,remark)"
												+" values("+scoreid+","+detailid+","+checkid+","+d_score+","+d_result+",'')");
									}else{
										rs2.executeSql("update GP_AccessScoreCheckDetail set score="+d_score+",result="+d_result+" where id="+cdid);
									}
									
								}
							}
						}
					}
					if(operation.equals("save")) {
						OperateUtil.addScoreLog(currentUserId,scoreid,2);
						//增加日志总分记录
						rs.executeSql("select max(id) from GP_AccessScoreLog where operator="+currentUserId+" and scoreid="+scoreid+" and operatetype=2");
						if(rs.next()){
							String logid = Util.null2String(rs.getString(1));
							rs.executeSql("update GP_AccessScoreLog set result="+score_result+" where id="+logid);
						}
					}
					
					//考核提交
				    if(operation.equals("submit")){
				    	//更新主信息是否第一评分人
			    		rs.executeSql("update GP_AccessScore set isfirst=0,status=0 where id="+scoreid);
				    	OperateUtil.addScoreLog(currentUserId,scoreid,3);
				    	//增加日志总分记录
						rs.executeSql("select max(id) from GP_AccessScoreLog where operator="+currentUserId+" and scoreid="+scoreid+" and operatetype=3");
						if(rs.next()){
							String logid = Util.null2String(rs.getString(1));
							rs.executeSql("update GP_AccessScoreLog set result="+score_result+" where id="+logid);
						}
				    	
				    	//判断是否还有考核人
				    	rs.executeSql("select id,userid,status,exeorder from GP_AccessScoreCheck where scoreid="+scoreid+" and exeorder="+(currentexeorder+1));
				    	if(rs.next()){
				    		//更新下一考核人状态
				    		String nextcheckid = Util.null2String(rs.getString("id"));
				    		String nextcheckuser = Util.null2String(rs.getString("userid"));
				    		rs.executeSql("update GP_AccessScoreCheck set status=1 where id="+nextcheckid);
				    		//更新当前评分人ID
				    		rs.executeSql("update GP_AccessScore set operator="+nextcheckuser+" where id="+scoreid);
				    	}else{
				    		//更新当前评分人ID
				    		rs.executeSql("update GP_AccessScore set operator=0 where id="+scoreid);
				    		//提交审批，读取成绩审批人
				    		String accessconfirm = "";
				    		List auditidList = new ArrayList();
					    	rs.executeSql("select accessconfirm from GP_BaseSetting where resourceid=" + ResourceComInfo.getDepartmentID(resourceid) + " and resourcetype=3");
					    	if(rs.next()){
					    		accessconfirm += Util.null2String(rs.getString("accessconfirm"));
					    	}else{
					    		rs.executeSql("select accessconfirm from GP_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2");
					    		if(rs.next()){
					    			accessconfirm += Util.null2String(rs.getString("accessconfirm"));
					    		}
					    	}
					    	List auditidList2 = Util.TokenizerString(auditids,",");
					    	List auditidList3 = Util.TokenizerString(accessconfirm,",");
					    	String auditid = "";
					    	String remindids = "";//需要提醒的审批人
					    	for(int i=0;i<auditidList2.size();i++){
					    		auditid = (String)auditidList2.get(i);
					    		if(auditid.equals("-1")) auditid = ResourceComInfo.getManagerID(ResourceComInfo.getManagerID(resourceid));
					    		if(!"".equals(auditid) && OperateUtil.isWork(auditid) && auditidList.indexOf(auditid)<0){
					    			auditidList.add(auditid);
					    			remindids += "," + auditid;
					    		}
					    	}
					    	for(int i=0;i<auditidList3.size();i++){
					    		auditid = (String)auditidList3.get(i);
					    		if(auditid.equals("-1")) auditid = ResourceComInfo.getManagerID(ResourceComInfo.getManagerID(resourceid));
					    		if(!"".equals(auditid) && OperateUtil.isWork(auditid) && auditidList.indexOf(auditid)<0){
					    			auditidList.add(auditid);
					    		}
					    	}
					    	//更新需提醒的人员id
					    	if(!remindids.equals("")) remindids += ",";
					    	rs.executeSql("update GP_AccessScore set remindids='"+remindids+"' where id="+scoreid);
					    		
					    	if(auditidList.size()==0){
				    			//无审批人则系统自动审批通过
				    			OperateUtil.approveScore(scoreid,"0");
				    		}else{
				    			//更改状态为审批中
				    			rs.executeSql("update GP_AccessScore set status=1 where id="+scoreid);
				    			boolean autoAudit = false;//标记是否要自动审批
				    			for(int i=0;i<auditidList.size();i++){
				    				auditid = (String)auditidList.get(i);
				    				if(!"".equals(auditid)){
				    					if(currentUserId.equals(auditid)) autoAudit = true;//如果审批人中有当前用户则标记需要直接审批
				    					rs.executeSql("insert into GP_AccessScoreAudit (scoreid,userid) values("+scoreid+","+auditid+")");
				    				}
				    			}
				    			if(autoAudit) OperateUtil.approveScore(scoreid,currentUserId);
				    		}	
				    	}
				    }
				    result_scoreid = scoreid;
				}
			}
		}else if(operation.equals("approve")||operation.equals("return")){//批准及退回
			String scoreid = Util.fromScreen3(fu.getParameter("scoreid"),user.getLanguage());
			if(!RightUtil.isCanAuditScore(scoreid,currentUserId)){
				msg = "您暂时无权限查看此信息！";
			}else{
				if(operation.equals("approve")){
					OperateUtil.approveScore(scoreid,currentUserId);
				}else{
					OperateUtil.returnScore(scoreid,currentUserId);
				}
				result_scoreid = scoreid;
			}
		}else if(operation.equals("quick_approve")||operation.equals("quick_return")){
			String scoreids = Util.fromScreen3(fu.getParameter("scoreids"),user.getLanguage());
			List scoreidList = Util.TokenizerString(scoreids,",");
			String scoreid = "";
			for(int i=0;i<scoreidList.size();i++){
				scoreid = (String)scoreidList.get(i);
				if(RightUtil.isCanAuditScore(scoreid,currentUserId)){
					if(operation.equals("quick_approve")){
						OperateUtil.approveScore(scoreid,currentUserId);
					}else{
						OperateUtil.returnScore(scoreid,currentUserId);
					}
				}
			}
		}else if(operation.equals("init")){//重置考核项及结果
			String scoreid = Util.fromScreen3(fu.getParameter("scoreid"),user.getLanguage());
			if(!RightUtil.isCanInitScore(scoreid,currentUserId)){
				msg = "您暂时无权限查看此信息！";
			}else{
				String newscoreid = OperateUtil.resetScore(scoreid,currentUserId);
				result_scoreid = newscoreid;
			}
		}else if(operation.equals("score_return")){//考核中退回
			String scoreid = Util.fromScreen3(fu.getParameter("scoreid"),user.getLanguage());
			if(!RightUtil.isCanScoreReturn(scoreid,currentUserId)){
				msg = "您暂时无权限查看此信息！";
			}else{
				OperateUtil.returnScore(scoreid,currentUserId);
				result_scoreid = scoreid;
			}
		}else if(operation.equals("reset")){//重新考核评分
			String scoreid = Util.fromScreen3(fu.getParameter("scoreid"),user.getLanguage());
			if(!RightUtil.isCanResetScore(scoreid,currentUserId)){
				msg = "您暂时无权限查看此信息！";
			}else{
				rs.executeSql("select t2.id,t2.exeorder from GP_AccessScore t1,GP_AccessScoreCheck t2 where t1.id=t2.scoreid and (t1.status=1 or t1.status=3) and t1.id="+scoreid+" and t2.userid="+currentUserId);
				if(rs.next()){
					String checkid = Util.null2String(rs.getString("id"));
					int exeorder = Util.getIntValue(rs.getString("exeorder"),0);
					int isfirst = 0;
					if(exeorder==0) isfirst = 1;
					rs.executeSql("delete from GP_AccessScoreAudit where scoreid="+scoreid);
					rs.executeSql("update GP_AccessScore set isrescore=1,status=0,isfirst="+isfirst+",operator="+currentUserId+",remindids='' where id="+scoreid);
					rs.executeSql("update GP_AccessScoreCheck set status=1 where scoreid="+scoreid+" and id="+checkid);
					rs.executeSql("update GP_AccessScoreCheck set status=0 where exeorder>"+exeorder+" and scoreid="+scoreid);
					OperateUtil.addScoreLog(currentUserId, scoreid, 6);
					result_scoreid = scoreid;
				}else{
					msg = "您暂时无权限查看此信息！";
				}
			}
		}else if("add_exchange".equals(operation)){//添加交流
			String scoreid = Util.fromScreen3(fu.getParameter("scoreid"),user.getLanguage());
			String content = Util.convertInput2DB(URLDecoder.decode(fu.getParameter("content"),"utf-8"));
			if(!scoreid.equals("") && !content.equals("")){
				//判断是否可查看此考核结果
				String currentuserid = user.getUID()+"";
				if(RightUtil.isCanViewScore(scoreid,currentuserid)){
					StringBuffer restr = new StringBuffer();
					String currentDate = TimeUtil.getCurrentDateString();
					String currentTime = TimeUtil.getOnlyCurrentTimeString();
					String sql = "insert into GP_AccessScoreExchange (scoreid,content,operator,operatedate,operatetime)"
						+" values("+scoreid+",'"+content+"',"+user.getUID()+",'"+currentDate+"','"+currentTime+"')";
					rs.executeSql(sql);
					String userimg = ResourceComInfo.getMessagerUrls(user.getUID()+"");
					restr.append("<tr><td class=\"td_img\"><img src=\""+userimg+"\" class=\"exchange_img\"/></td><td>");
					restr.append("<div class='exchange_title'>"+ResourceComInfo.getResourcename(user.getUID()+"")+"&nbsp;"+currentDate+"&nbsp;"+currentTime+"</div>"
								+"<div class='exchange_content'>"+Util.toHtml(content)+"</div></td></tr>");
					result_exchange = restr.toString();
				}
			}
		}
	}catch(Exception e){
		e.printStackTrace();
		msg= "执行失败，请稍后再试！";
	}
	if(result_exchange!=null && !"".equals(result_exchange)){
		out.print(result_exchange);
	}else{
		JSONObject json = new JSONObject();
		json.put("scoreid",result_scoreid);
		json.put("msg",msg);
		out.print(json.toString());
	}
%>