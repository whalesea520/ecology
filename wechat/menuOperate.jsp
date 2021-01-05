
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.wechat.cache.*"%>
<%@page import="weaver.wechat.bean.*"%>
<%@ page import="weaver.general.Util,java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@page import="weaver.wechat.request.menu.*,weaver.wechat.util.Const.MENU_TYPE"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SysMaintenanceLog"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%!
	private void insertEventLog(SysMaintenanceLog log,User user,String key,String publicid,String ip){
		log.resetParameter();
		log.insSysLogInfo(user,0,key+" 点击事件("+publicid+")","新增菜单点击事件","214","1",0,ip);

	}
%>
<%
	String operate=request.getParameter("operate");
	User user = HrmUserVarify.getUser(request, response);
	String ip=Util.getIpAddr(request);
	if("add".equals(operate)){//添加
		String publicid=request.getParameter("publicid");
		String name=URLDecoder.decode(request.getParameter("name"),"UTF-8");
		String btntype=request.getParameter("btntype");
		String keyurl=URLDecoder.decode(request.getParameter("keyurl"),"UTF-8");
		String parentId=request.getParameter("parentId");
		String level=request.getParameter("level");
		String addPostion=request.getParameter("addPostion");
		String https=request.getParameter("https");
		
		String keyevent=request.getParameter("keyevent");//是否触发事件
		String classname=request.getParameter("classname");//实现类
		 
		Menu menu=MenuCache.getMenu(publicid); 
		List<Button> btns=menu.getButton();
		if("1".equals(level)){
			//忽略parentId
			Button btn=new Button();
			btn.setName(name);
			if(btntype.equals(MENU_TYPE.click.toString())){
				btn.setType(MENU_TYPE.click);
				btn.setKey(keyurl);
				//是否往数据库添加classname
				if("true".equals(keyevent)){//有触发事件
					//先删除
					rs.execute("delete wechat_action where type=2 and publicid='"+publicid+"' and msgtype='event' and eventtype='click' and eventkey='"+keyurl+"'");
					if(classname!=null&&!"".equals(classname)){
						rs.execute("insert into wechat_action(publicid,msgtype,eventtype,eventkey,classname,type) values('"+publicid+"','event','click','"+keyurl+"','"+classname+"',2)");
						insertEventLog(SysMaintenanceLog,user,keyurl,publicid,ip);
					}
				}
			}else{
				btn.setType(MENU_TYPE.view);
				if("true".equals(https)){
					WeChatBean wc=PlatFormCache.getWeChatBeanPublicId(publicid);
					String auth="https://open.weixin.qq.com/connect/oauth2/authorize?appid="+wc.getAppId()+
						"&redirect_uri="+URLEncoder.encode(keyurl,"UTF-8")+"&response_type=code&scope=snsapi_base&state="+publicid+"#wechat_redirect";
					btn.setUrl(auth);
				}else{
					btn.setUrl(keyurl);
				}
			}
			if(addPostion!=null&&!"".equals(addPostion)){
				btns.add((Integer.parseInt(addPostion)+1),btn);
			}else{
				btns.add(btn);
			}
			 
		}else if("2".equals(level)){
			//根据parentId判断是第几个父节点
			int postion=Integer.parseInt(parentId.substring("menu_".length()));
			Button btn=new Button();
			btn.setName(name);
			if(btntype.equals(MENU_TYPE.click.toString())){
				btn.setType(MENU_TYPE.click);
				btn.setKey(keyurl);
				//是否往数据库添加classname
				if("true".equals(keyevent)){//有触发事件
					//先删除
					rs.execute("delete wechat_action where type=2 and publicid='"+publicid+"' and msgtype='event' and eventtype='click' and eventkey='"+keyurl+"'");
					if(classname!=null&&!"".equals(classname)){
						rs.execute("insert into wechat_action(publicid,msgtype,eventtype,eventkey,classname,type) values('"+publicid+"','event','click','"+keyurl+"','"+classname+"',2)");
						insertEventLog(SysMaintenanceLog,user,keyurl,publicid,ip);
					}
				}
			}else{
				btn.setType(MENU_TYPE.view);
				if("true".equals(https)){
					WeChatBean wc=PlatFormCache.getWeChatBeanPublicId(publicid);
					String auth="https://open.weixin.qq.com/connect/oauth2/authorize?appid="+wc.getAppId()+
						"&redirect_uri="+URLEncoder.encode(keyurl,"UTF-8")+"&response_type=code&scope=snsapi_base&state="+publicid+"#wechat_redirect";
					btn.setUrl(auth);
				}else{
					btn.setUrl(keyurl);
				}
			}
			if(addPostion!=null&&!"".equals(addPostion)){
				btns.get(postion).addButton((Integer.parseInt(addPostion)+1),btn);
			}else{
				btns.get(postion).addButton(btn);
			}
			 
		}else{
			out.print(false);
		}
		out.print(true);
	}else if("edit".equals(operate)){//编辑
		String publicid=request.getParameter("publicid");
		String name=URLDecoder.decode(request.getParameter("name"),"UTF-8");
		String btntype=request.getParameter("btntype");
		String keyurl=URLDecoder.decode(request.getParameter("keyurl"),"UTF-8");
		String id=request.getParameter("id");
		String https=request.getParameter("https");
		String keyevent=request.getParameter("keyevent");//是否触发事件
		String classname=request.getParameter("classname");//实现类
		String[] ids=id.split("_");
		Menu menu=MenuCache.getMenu(publicid); 
		List<Button> btns=menu.getButton();
		if(ids.length==2){
			Button btn=btns.get(Integer.parseInt(ids[1])) ;
			btn.setName(name);
			if(btntype.equals(MENU_TYPE.click.toString())){
				btn.setType(MENU_TYPE.click);
				btn.setKey(keyurl);
				//是否往数据库添加classname
				if("true".equals(keyevent)){//有触发事件
					//先删除
					rs.executeSql("delete wechat_action where type=2 and publicid='"+publicid+"' and msgtype='event' and eventtype='click' and eventkey='"+keyurl+"'");
					if(classname!=null&&!"".equals(classname)){
						rs.execute("insert into wechat_action(publicid,msgtype,eventtype,eventkey,classname,type) values('"+publicid+"','event','click','"+keyurl+"','"+classname+"',2)");
						insertEventLog(SysMaintenanceLog,user,keyurl,publicid,ip);
					}
				}
			}else{
				btn.setType(MENU_TYPE.view);
				if("true".equals(https)){
					WeChatBean wc=PlatFormCache.getWeChatBeanPublicId(publicid);
					String auth="https://open.weixin.qq.com/connect/oauth2/authorize?appid="+wc.getAppId()+
						"&redirect_uri="+URLEncoder.encode(keyurl,"UTF-8")+"&response_type=code&scope=snsapi_base&state="+publicid+"#wechat_redirect";
					btn.setUrl(auth);
				}else{
					btn.setUrl(keyurl);
				}
			}
		}else if(ids.length==3){
			Button btn=btns.get(Integer.parseInt(ids[1])).getSub_button().get(Integer.parseInt(ids[2]));
			btn.setName(name);
			if(btntype.equals(MENU_TYPE.click.toString())){
				btn.setType(MENU_TYPE.click);
				btn.setKey(keyurl);
				//是否往数据库添加classname
				if("true".equals(keyevent)){//有触发事件
					//先删除
					rs.execute("delete wechat_action where type=2 and publicid='"+publicid+"' and msgtype='event' and eventtype='click' and eventkey='"+keyurl+"'");
					if(classname!=null&&!"".equals(classname)){
						rs.execute("insert into wechat_action(publicid,msgtype,eventtype,eventkey,classname,type) values('"+publicid+"','event','click','"+keyurl+"','"+classname+"',2)");
						insertEventLog(SysMaintenanceLog,user,keyurl,publicid,ip);
					}
				}
			}else{
				btn.setType(MENU_TYPE.view);
				if("true".equals(https)){
					WeChatBean wc=PlatFormCache.getWeChatBeanPublicId(publicid);
					String auth="https://open.weixin.qq.com/connect/oauth2/authorize?appid="+wc.getAppId()+
						"&redirect_uri="+URLEncoder.encode(keyurl,"UTF-8")+"&response_type=code&scope=snsapi_base&state="+publicid+"#wechat_redirect";
					btn.setUrl(auth);
				}else{
					btn.setUrl(keyurl);
				}
			}
		}else{
			out.print(false);
		}
		out.print(true);
	}else if("del".equals(operate)){//删除
		String publicid=request.getParameter("publicid");
		String id=request.getParameter("id");//当前节点id
		Menu menu=MenuCache.getMenu(publicid); 
		List<Button> btns=menu.getButton();
		String[] ids=id.split("_");
		if(ids.length==2){//删除一级菜单
			btns.remove(Integer.parseInt(ids[1]));
			MenuCache.addMenu(publicid,menu);
		}else if(ids.length==3){//删除二级菜单
			btns.get(Integer.parseInt(ids[1])).getSub_button().remove(Integer.parseInt(ids[2]));
			MenuCache.addMenu(publicid,menu);
		}else{
			out.print(false);
		}
		out.print(true);
	}else if("query".equals(operate)){//查询
		String publicid=request.getParameter("publicid");
		Menu menu=MenuCache.getMenu(publicid);
		out.print(JSONObject.toJSONString(menu));
	}else if("refresh".equals(operate)){
		String publicid=request.getParameter("publicid");
		MenuCache.refresh(publicid);
		out.print(true);
	}else if("update".equals(operate)){
		String publicid=request.getParameter("publicid");
		if(MenuCache.update(publicid)){
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.insSysLogInfo(user,0,publicid,"微信公众平台管理-更新菜单","214","2",0,Util.getIpAddr(request));
			out.print(true);
		}else{
			out.print(false);
		}
	}else if("queryClass".equals(operate)){
		String publicid=request.getParameter("publicid");
		String keyurl=request.getParameter("keyurl");
		rs.execute("select classname from wechat_action where type=2 and publicid='"+publicid+"' and msgtype='event' and eventtype='click' and eventkey='"+keyurl+"'");
		String classname="";
		if(rs.next()){
			classname=rs.getString(1);
		}
		out.print(classname);
	}else if("delMenu".equals(operate)){
		String publicid=request.getParameter("publicid");
		if(MenuCache.delMenu(publicid)){
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.insSysLogInfo(user,0,publicid,"微信公众平台管理-删除菜单","214","3",0,Util.getIpAddr(request));
			out.print(true);
		}else{
			out.print(false);
		}
	}
%>
