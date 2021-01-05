<%@page import="java.util.Properties"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Timer"%>
<%@page import="java.util.TimerTask"%>
<%@page import="org.logicalcobwebs.proxool.*"%>
<%@page import="org.logicalcobwebs.proxool.admin.SnapshotIF"%>

<%@page import="java.lang.management.ManagementFactory"%>
<%@page import="java.lang.management.ThreadInfo"%>
<%@page import="java.lang.management.ThreadMXBean"%>


<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.hrm.User"%>


<%!
private static final String[] SYSTEM_STACK_PREFIX = new String[]{"java.", "com.caucho."};
private static final String POOL_TIMER_NAME = "_pool_timer_";
private static final BaseBean baseBean = new BaseBean();
%>

<%!
/**
 * 获取线程堆栈信息
 */
private String getJstackInfo(String threadName) {
	if(threadName == null || threadName.trim().length() == 0){
		return null;
	}
	StringBuilder sb = new StringBuilder();
	ThreadMXBean tb = ManagementFactory.getThreadMXBean();
	long[] tids = tb.getAllThreadIds();
	boolean exist = false;
	for (int i = 0; i < tids.length; i++) {
		long cputime = tb.getThreadCpuTime(tids[i]);
		ThreadInfo info = tb.getThreadInfo(tids[i], Integer.MAX_VALUE);
		if (null == info) {
			continue;
		}
		if(info.getThreadName().equals(threadName)){
			exist = true;
			sb.append("\"").append(info.getThreadName()).append("\"")
			.append("&nbsp;").append("id").append("=\"")
			.append(info.getThreadId()).append("\"&nbsp;")
			.append("CPU_Time=").append(cputime).append("&nbsp;<br/>");
			
			Thread.State state = info.getThreadState();
			sb.append("&nbsp;java.lang.Thread.State:&nbsp;").append(state.name()).append("&nbsp;<br/>");
			StackTraceElement[] stacks = info.getStackTrace();
			if (null != stacks) {
				for (StackTraceElement stack : stacks) {
					sb.append("&nbsp;&nbsp;at&nbsp;").append(stack.toString()).append("<br/>");
				}
				
				//sb.append("isDummy: "+!isCustomerStack(stacks)+"&nbsp;");				
			}
			break;
		}
	}
	if(!exist){
		sb.append("thread " + threadName + " doesn't exist right now!");
	}
	return sb.toString();
}

/**
 * 停止单个线程，并释放这个线程持有的所有连接
 */
private boolean killThread(String threadName){
	if(threadName == null || threadName.trim().length() == 0){
		return false;
	}
	
	try{
		for(String alias : ProxoolFacade.getAliases()){
			SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias, true);
			ConnectionInfoIF[] connInfos = snapshot.getConnectionInfos();
			if(connInfos != null){
				for(ConnectionInfoIF connInfo : connInfos){
					if(threadName.equals(connInfo.getRequester())){
						release(alias, connInfo.getId(), true);
					}
				}
			}
		}
	} catch(ProxoolException e){
	}
	
    ThreadGroup rootGroup = Thread.currentThread().getThreadGroup();
    while (rootGroup.getParent() != null) {
        rootGroup = rootGroup.getParent();
    }

    Thread[] tds = new Thread[3000];
    int tc = rootGroup.enumerate(tds, true);
    for (int i = 0; i < tc; i++) {
        if (tds[i].getName().equals(threadName)) {
            tds[i].stop();
            return true;
        }
    }
    return false;
}

/**
 * 释放单个连接
 */
private boolean release(String alias, long id, boolean force){
	try{
		return ProxoolFacade.killConnecton(alias, id, !force);
	} catch(ProxoolException e){
	}
	return false;
}

/**
 * 释放活动着的线程堆栈运行为空的连接,返回被释放的连接id数组
 */
private List<Long> releaseAllActiveConnOfDummyThread(String alias, long activeTime){
	try{
		//获取快照及连接详情
		SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias, true);
		ConnectionInfoIF[] connInfos = snapshot.getConnectionInfos();
		if(connInfos != null){
			List<Long> releasedIds = new ArrayList<Long>();
			Map<String, Boolean> cache = new HashMap<String, Boolean>(); //缓存 线程是否是空线程的判断结果
			for(ConnectionInfoIF connInfo : connInfos){
				//如果是活动线程
				if(connInfo.getStatus() == ConnectionInfoIF.STATUS_ACTIVE){
					long actualActiveTime = 0;
					if (connInfo.getTimeLastStopActive() > 0) {
						actualActiveTime = connInfo.getTimeLastStopActive() - connInfo.getTimeLastStartActive();
	                } else if (connInfo.getTimeLastStartActive() > 0) {
	                	actualActiveTime = snapshot.getSnapshotDate().getTime() - connInfo.getTimeLastStartActive();
	                }
					//如果连接活动时间大于指定的阈值
					if(actualActiveTime > activeTime){
						String threadName = connInfo.getRequester();
						if(threadName != null){
							//判断是否是空线程
							Boolean isDummy = false; 
							if(cache.containsKey(threadName)){
								isDummy = cache.get(threadName);
							} else {
								isDummy = isDummyThread(threadName);
								cache.put(threadName, isDummy);
							}
							if(isDummy){
								//如果是空线程，释放该连接
								if(release(alias, connInfo.getId(), true)){
									releasedIds.add(connInfo.getId());
								}
							}
						}
					}
				}
			}
			return releasedIds;
		}
		
	} catch(ProxoolException e){
	}
	return null;
}

/**
 * 释放活动着的连接,返回被释放的连接id数组
 */
private List<Long> releaseAllActiveConn(String alias, long activeTime){
	try{
		//获取快照及连接详情
		SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias, true);
		ConnectionInfoIF[] connInfos = snapshot.getConnectionInfos();
		if(connInfos != null){
			List<Long> releasedIds = new ArrayList<Long>();
			for(ConnectionInfoIF connInfo : connInfos){
				//如果是活动连接
				if(connInfo.getStatus() == ConnectionInfoIF.STATUS_ACTIVE){
					long actualActiveTime = 0;
					if (connInfo.getTimeLastStopActive() > 0) {
						actualActiveTime = connInfo.getTimeLastStopActive() - connInfo.getTimeLastStartActive();
	                } else if (connInfo.getTimeLastStartActive() > 0) {
	                	actualActiveTime = snapshot.getSnapshotDate().getTime() - connInfo.getTimeLastStartActive();
	                }
					//如果连接活动时间大于指定的阈值
					if(actualActiveTime > activeTime){
						String threadName = connInfo.getRequester();
						if(threadName != null){
							//释放该连接
							if(release(alias, connInfo.getId(), true)){
								releasedIds.add(connInfo.getId());
							}
						}
					}
				}
			}
			return releasedIds;
		}
		
	} catch(ProxoolException e){
	}
	return null;
}

/**
 * 根据堆栈判断线程是否是空线程
 */
private boolean isDummyThread(String threadName){
	ThreadInfo info = getThreadInfoByName(threadName);
	if(info != null){
		//所有堆栈均以java. 或者 com.caucho. 开头
		StackTraceElement[] stacks = info.getStackTrace();
		if(stacks == null){
			return true;
		}
		if (stacks != null) {
			return !isCustomerStack(stacks);
		}
	}
	return false;
}

private ThreadInfo getThreadInfoByName(String threadName){
	ThreadMXBean tb = ManagementFactory.getThreadMXBean();
	long[] tids = tb.getAllThreadIds();
	ThreadInfo info = null;
	for (int i = 0; i < tids.length; i++) {
		info = tb.getThreadInfo(tids[i], Integer.MAX_VALUE);
		if (null == info) {
			continue;
		} else if(info.getThreadName().equals(threadName)){
			return info;
		}
	}
	return null;
}

/**
 * 判断堆栈是否包含用户运行代码,即是否包含不以 SYSTEM_STACK_PREFIX 开头的堆栈
 */
private boolean isCustomerStack(StackTraceElement[] stacks){
	for (StackTraceElement stack : stacks) {
		String stackstr = stack.toString();
		boolean isSystem = false;
		for(String systemStack : SYSTEM_STACK_PREFIX){
			if(stackstr.startsWith(systemStack)){
				isSystem = true;
				break;
			}
		}
		if(!isSystem){
			return true;
		}
	}
	return false;
}

private boolean startAutoClean(final String alias, final long activeTime){
	stopAutoClean(alias);
	StaticObj staticObj = StaticObj.getInstance();
	Timer timer = new Timer(POOL_TIMER_NAME + alias);
	final long delay = 3000;
	final long period = activeTime<60000 ? 60000 : activeTime-10000; 
	timer.schedule(new TimerTask() {
		public void run() {
			try{
				baseBean.writeLog("pool.jsp, start check auto release connection, alias: " + alias + ", activeTime: " + (activeTime/1000) + "s, period: " + (period/1000) + "s");
				//获取快照及连接详情
				SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias, true);
				ConnectionInfoIF[] connInfos = snapshot.getConnectionInfos();
				if(connInfos != null){
					for(ConnectionInfoIF connInfo : connInfos){
						//如果是活动线程
						if(connInfo.getStatus() == ConnectionInfoIF.STATUS_ACTIVE){
							long actualActiveTime = 0;
							if (connInfo.getTimeLastStopActive() > 0) {
								actualActiveTime = connInfo.getTimeLastStopActive() - connInfo.getTimeLastStartActive();
			                } else if (connInfo.getTimeLastStartActive() > 0) {
			                	actualActiveTime = snapshot.getSnapshotDate().getTime() - connInfo.getTimeLastStartActive();
			                }
							//如果连接活动时间大于指定的阈值
							if(actualActiveTime > activeTime){
								String threadName = connInfo.getRequester();
								if(threadName != null){
									if(release(alias, connInfo.getId(), true)){
										baseBean.writeLog("pool.jsp, auto release connection success, threadName: " + threadName + ", alias: " + alias + ", connId: " + connInfo.getId() + ", activeTime: " + (activeTime/1000) + "s, actualActiveTime: " + (actualActiveTime/1000) + "s");
									}
								}
							}
						}
					}
				}
				baseBean.writeLog("pool.jsp, end check auto release connection, alias: " + alias + ", activeTime: " + (activeTime/1000) + "s, period: " + (period/1000) + "s");
			} catch(ProxoolException e){
			}
		}
	}, delay, period);
	staticObj.putObject(POOL_TIMER_NAME + alias, timer);
	baseBean.writeLog("pool.jsp, start auto release success, alias: " + alias + ", activeTime: " + (activeTime/1000) + "s, period: " + (period/1000) + "s");
	return true;
}

private boolean stopAutoClean(String alias){
	StaticObj staticObj = StaticObj.getInstance();
	Object obj = staticObj.getObject(POOL_TIMER_NAME + alias);
	if(obj != null && obj instanceof Timer){
		Timer timer = (Timer) obj;
		timer.cancel();
		staticObj.removeObject(POOL_TIMER_NAME + alias);
		baseBean.writeLog("pool.jsp, stop auto release success, alias: " + alias);
		return true;
	}
	return false;
}

private String updateTrace(String alias, Boolean open){
	Properties info = new Properties();
	info.setProperty(ProxoolConstants.TRACE_PROPERTY, open.toString());
	try{
		ProxoolFacade.updateConnectionPool(ProxoolConstants.PROPERTY_PREFIX+alias, info);
		return (open ? "open" : "close") + " trace success, alias: " + alias;		
	} catch (Exception e){
		e.printStackTrace();
		return (open ? "open" : "close") + " trace fail, alias: " + alias + ", error: " + e.getMessage();
	}
}

private String openTrace(String alias){
	return updateTrace(alias, true);
}

private String closeTrace(String alias){
	return updateTrace(alias, false);
}

%>

<%
User user = (User) session.getAttribute("weaver_user@bean");
if(user == null || !"sysadmin".equals(user.getLoginid())){
	out.print("{\"res\":\"auth fail, please contact sysadmin...\"}");
	return;
}

String operation = request.getParameter("operation");
if(operation != null){
	String dataType = request.getParameter("dataType");
	if(dataType == null){
		out.print("<div style=\"overflow:auto;height:100%;\">");
		try {
			if(operation.equals("getJstackInfo")){
				String threadName = request.getParameter("threadName");
				String jstackInfo = getJstackInfo(threadName);
				out.print(jstackInfo);
			} else if(operation.equals("killThread")){
				String threadName = request.getParameter("threadName");
				if(killThread(threadName)){
					out.print("killThread " + threadName + " success.");
				} else {
					out.print("thread " + threadName + " doesn't exist right now!");
				}
			} else if(operation.equals("release")){
				String alias = request.getParameter("alias");
				String connId = request.getParameter("connId");
				String force = request.getParameter("force");
				if(release(alias, Long.parseLong(connId), "1".equals(force))){
					out.print("release connection(id: " + connId + ") success.");
				} else {
					out.print("connection(id: " + connId + ") doesn't exist right now!");
				}
			} else if(operation.equals("releaseAllActiveConnOfDummyThread")){
				String alias = request.getParameter("alias");
				long activeTime = Long.parseLong(request.getParameter("activeTime"));
				if(activeTime<=0){
					out.print("releaseAllActiveConnOfDummyThread activeTime must greater than 0ms");
				} else {
					List<Long> releasedIds = releaseAllActiveConnOfDummyThread(alias, activeTime);
					if(releasedIds != null && releasedIds.size() > 0){
						out.print("releaseAllActiveConnOfDummyThread success. alias: "+alias+", activeTime>"+activeTime+"ms.");
						out.print("<br/>");
						out.print(releasedIds.size() + " connections were released.");
						out.print("<br/>");
						out.print("released connections: ");
						for(int i=0;i<releasedIds.size();i++){
							out.print(releasedIds.get(i));
							if(i!=releasedIds.size()-1){
								out.print(", ");
							}
						}		
					} else {
						out.print("no connection was released. alias: "+alias+", activeTime>"+activeTime+"ms.");
					}
				}
			} else if(operation.equals("releaseAllActiveConn")){
				String alias = request.getParameter("alias");
				long activeTime = Long.parseLong(request.getParameter("activeTime"));
				if(activeTime<=0){
					out.print("releaseAllActiveConn activeTime must greater than 0ms");
				} else {
					List<Long> releasedIds = releaseAllActiveConn(alias, activeTime);
					if(releasedIds != null && releasedIds.size() > 0){
						out.print("releaseAllActiveConn success. alias: "+alias+", activeTime>"+activeTime+"ms.");
						out.print("<br/>");
						out.print(releasedIds.size() + " connections were released.");
						out.print("<br/>");
						out.print("released connections: ");
						for(int i=0;i<releasedIds.size();i++){
							out.print(releasedIds.get(i));
							if(i!=releasedIds.size()-1){
								out.print(", ");
							}
						}		
					} else {
						out.print("no connection was released. alias: "+alias+", activeTime>"+activeTime+"ms.");
					}
				}
			} else if(operation.equals("startAutoClean")){
				String alias = request.getParameter("alias");
				long autoCleanActiveTime = Long.parseLong(request.getParameter("autoCleanActiveTime"));
				if(startAutoClean(alias, autoCleanActiveTime)){
					out.print("startAutoClean success, alias: "+alias+", autoCleanActiveTime>"+autoCleanActiveTime+"ms.");
				} else {
					out.print("startAutoClean fail, alias: "+alias+", autoCleanActiveTime>"+autoCleanActiveTime+"ms.");
				}
			} else if(operation.equals("stopAutoClean")){
				String alias = request.getParameter("alias");
				if(stopAutoClean(alias)){
					out.print("stopAutoClean success, alias: "+alias+".");
				} else {
					out.print("stopAutoClean fail, no timer exists, alias: "+alias+".");
				}
			}
		} catch (Exception e){
			out.print(e);
		}
		out.print("</div>");
	} else if("json".equals(dataType)){
		if(operation.equals("openTrace")){
			String alias = request.getParameter("alias");
			//out.print(openTrace(alias));
			String res = openTrace(alias);
			out.print("{\"res\":\""+res+"\"}");
			/*
			if(openTrace(alias)){
				out.print("openTrace success, alias: "+alias+".");
			} else {
				out.print("openTrace fail, alias: "+alias+".");
			}
			*/
		} else if(operation.equals("closeTrace")){
			String alias = request.getParameter("alias");
			String res = closeTrace(alias);
			out.print("{\"res\":\""+res+"\"}");
			/*
			if(closeTrace(alias)){
				out.print("closeTrace success, alias: "+alias+".");
			} else {
				out.print("closeTrace fail, alias: "+alias+".");
			}
			*/
		}
	}
}

%>
