<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays "%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="weaver.wxinterface.FlowAndDoc"%>
<%@ page import="weaver.wxinterface.InterfaceUtil"%>
<%@ page import="java.net.URLDecoder"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = HrmUserVarify.getUser(request, response);
	if (user == null) {
		return;
	}
	JSONObject result = new JSONObject();
	request.setCharacterEncoding("UTF-8");
	String operate = Util.null2String(request.getParameter("operate"));
	if(user.getUID()!=1&&!operate.equals("sendMsg")){
		return;
	}
	String nowtime = TimeUtil.getCurrentTimeString();//当天日期和时间
	if ("addmsgrule".equals(operate)) {} 
	else if ("delmsgrule".equals(operate)) {} 
	else if ("getmsgrule".equals(operate)) {} 
	else if ("getMsgTp".equals(operate)) {//获取消息模板列表
		int status = 1;
		JSONArray tplist = InterfaceUtil.getMsgTp();
		
		if (tplist != null) {
			if(tplist.length()>0){
				status = 0;
				result.put("msgtps", tplist);
			}else{
				status = 1;
			}	
		} else {
			status = 2;
		}
		result.put("status", status);
	}else if ("sendMsg".equals(operate)){//发送消息
		int status = 1;
		String msg = "";
		String userids = Util.null2String(request.getParameter("userids"));
		String userNames = URLDecoder.decode(Util.null2String(request.getParameter("userNames")),"utf-8");
		String docids = Util.null2String(request.getParameter("docids"));
		String docNames = URLDecoder.decode(Util.null2String(request.getParameter("docNames")),"utf-8");
		String sendContent = URLDecoder.decode(Util.null2String(request.getParameter("sendContent")),"utf-8");
		String jsonData = URLDecoder.decode(Util.null2String(request.getParameter("jsonData")),"utf-8");
		String msgtps = Util.null2String(request.getParameter("msgtps"));
		int sendType = Util.getIntValue(request.getParameter("sendType"),1);
		int ifSafe = Util.getIntValue(request.getParameter("ifSafe"),0);
		int ifReback = Util.getIntValue(request.getParameter("ifReback"),0);
		try{
			if(!userids.equals("")){
				boolean flag = false;
				List<FlowAndDoc> msgList = WxInterfaceInit.getMsgList();
				String tpids = "";//获取微信集成平台中配置的模板ID
				if(null!=msgList && msgList.size()>0){
					for(FlowAndDoc fad:msgList){
						if(null!=fad){
							if(msgtps.indexOf(","+fad.getId()+",")>-1){
								String msgtpids = fad.getMsgtpids();
								if(null!=msgtpids && !"".equals(msgtpids)){
									String[] mtps = msgtpids.split(",");
									if(null!=mtps && mtps.length>0){
										for(String mtp:mtps){
											if(null!=mtp&&!"".equals(mtp)){
												tpids += "," + mtp;
											}
										}
									}
								}
							}
						}
					}
				}
				if(!tpids.equals("")){
					tpids = tpids.substring(1);
					if(sendType==3){//文字消息推送
						if(!sendContent.equals("")){
							List<String> userList = null;
							if(userids.indexOf("@")>-1){
								userList = new ArrayList<String>();
								userList.add(userids);
							}else{
								String[] us = userids.split(",");
								userList = Arrays.asList(us);
							}
							sendContent += "--"+user.getLastname();
							Map<String,String> msgmap = InterfaceUtil.sendMsg(userList,tpids,"",sendContent,3,null); 
							flag = Util.getIntValue(msgmap.get("msgcode"),-1)==0;
							msg = Util.null2String(msgmap.get("msginfo"));
							if(flag){
								status = 0;
							}
						}else{
							msg = "没有获取到要发送的文字信息";
						}
					}else{//文档类型消息推送
						sendContent = docNames;
						if(!docids.equals("")){
							Map<String,String[]> map = new HashMap<String,String[]>();
							JSONArray ja = new JSONArray(jsonData);
							docids = "";
							for(int i=0;i<ja.length();i++){
								JSONObject jo = ja.getJSONObject(i);
								String docid = jo.getString("docid");
								String newtitle = jo.getString("newtitle");
								String newauthor = jo.getString("newauthor");
								String newdesc = jo.getString("newdesc");
								String newimage = jo.getString("newimage");
								String[] temp = {newtitle,newauthor,newdesc,newimage};
								map.put(docid, temp);
								docids += ","+docid;
							}
							if(!docids.equals("")){
								docids = docids.substring(1);
							}
							msg = InterfaceUtil.sendDocMsg(docids,map,userids,ifSafe,ifReback,tpids,sendType);
							if(msg.equals("")){
								status = 0;
							}
						}else{
							msg = "没有获取到要发送的文档信息";
						}
					}
				}else{
					msg = "没有获取到要发送的模板设置";
				}
			}else{
				msg = "没有获取到要发送的人员信息";
			}
		}catch(Exception e){
			e.printStackTrace();
			msg = "发送消息程序出现异常:"+e.getMessage();
		}finally{
			//记录发送日志
			String sql = "insert into WX_SENDMSGLOG (senduserid,receiveuserids,content,ifsend,errormsg,createtime,sendtype,docids)"+
			" values ("+user.getUID()+",'"+userids+"','"+sendContent+"'";
			if(status==0){
				sql+=",1,''";
			}else{
				sql+=",0,'"+msg+"'";
			}
			sql+=",'"+nowtime+"',"+sendType+",'"+docids+"')";
			//System.out.println("sql===============================\n"+sql);
			rs.execute(sql);
		}
		result.put("status", status);
		result.put("msg", msg);
	}
	out.println(result.toString());
%>
