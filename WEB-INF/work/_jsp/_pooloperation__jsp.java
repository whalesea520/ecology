/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.Properties;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;
import org.logicalcobwebs.proxool.*;
import org.logicalcobwebs.proxool.admin.SnapshotIF;
import java.lang.management.ManagementFactory;
import java.lang.management.ThreadInfo;
import java.lang.management.ThreadMXBean;
import weaver.general.StaticObj;
import weaver.general.BaseBean;
import weaver.hrm.User;

public class _pooloperation__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  private static final String[] SYSTEM_STACK_PREFIX = new String[]{"java.", "com.caucho."};
  private static final String POOL_TIMER_NAME = "_pool_timer_";
  private static final BaseBean baseBean = new BaseBean();


  
  /**
   * \u00e8\u008e\u00b7\u00e5\u008f\u0096\u00e7\u00ba\u00bf\u00e7\u00a8\u008b\u00e5\u00a0\u0086\u00e6\u00a0\u0088\u00e4\u00bf\u00a1\u00e6\u0081\u00af
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
   * \u00e5\u0081\u009c\u00e6\u00ad\u00a2\u00e5\u008d\u0095\u00e4\u00b8\u00aa\u00e7\u00ba\u00bf\u00e7\u00a8\u008b\u00ef\u00bc\u008c\u00e5\u00b9\u00b6\u00e9\u0087\u008a\u00e6\u0094\u00be\u00e8\u00bf\u0099\u00e4\u00b8\u00aa\u00e7\u00ba\u00bf\u00e7\u00a8\u008b\u00e6\u008c\u0081\u00e6\u009c\u0089\u00e7\u009a\u0084\u00e6\u0089\u0080\u00e6\u009c\u0089\u00e8\u00bf\u009e\u00e6\u008e\u00a5
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
   * \u00e9\u0087\u008a\u00e6\u0094\u00be\u00e5\u008d\u0095\u00e4\u00b8\u00aa\u00e8\u00bf\u009e\u00e6\u008e\u00a5
   */
  private boolean release(String alias, long id, boolean force){
  	try{
  		return ProxoolFacade.killConnecton(alias, id, !force);
  	} catch(ProxoolException e){
  	}
  	return false;
  }
  
  /**
   * \u00e9\u0087\u008a\u00e6\u0094\u00be\u00e6\u00b4\u00bb\u00e5\u008a\u00a8\u00e7\u009d\u0080\u00e7\u009a\u0084\u00e7\u00ba\u00bf\u00e7\u00a8\u008b\u00e5\u00a0\u0086\u00e6\u00a0\u0088\u00e8\u00bf\u0090\u00e8\u00a1\u008c\u00e4\u00b8\u00ba\u00e7\u00a9\u00ba\u00e7\u009a\u0084\u00e8\u00bf\u009e\u00e6\u008e\u00a5,\u00e8\u00bf\u0094\u00e5\u009b\u009e\u00e8\u00a2\u00ab\u00e9\u0087\u008a\u00e6\u0094\u00be\u00e7\u009a\u0084\u00e8\u00bf\u009e\u00e6\u008e\u00a5id\u00e6\u0095\u00b0\u00e7\u00bb\u0084
   */
  private List<Long> releaseAllActiveConnOfDummyThread(String alias, long activeTime){
  	try{
  		//\u00e8\u008e\u00b7\u00e5\u008f\u0096\u00e5\u00bf\u00ab\u00e7\u0085\u00a7\u00e5\u008f\u008a\u00e8\u00bf\u009e\u00e6\u008e\u00a5\u00e8\u00af\u00a6\u00e6\u0083\u0085
  		SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias, true);
  		ConnectionInfoIF[] connInfos = snapshot.getConnectionInfos();
  		if(connInfos != null){
  			List<Long> releasedIds = new ArrayList<Long>();
  			Map<String, Boolean> cache = new HashMap<String, Boolean>(); //\u00e7\u00bc\u0093\u00e5\u00ad\u0098 \u00e7\u00ba\u00bf\u00e7\u00a8\u008b\u00e6\u0098\u00af\u00e5\u0090\u00a6\u00e6\u0098\u00af\u00e7\u00a9\u00ba\u00e7\u00ba\u00bf\u00e7\u00a8\u008b\u00e7\u009a\u0084\u00e5\u0088\u00a4\u00e6\u0096\u00ad\u00e7\u00bb\u0093\u00e6\u009e\u009c
  			for(ConnectionInfoIF connInfo : connInfos){
  				//\u00e5\u00a6\u0082\u00e6\u009e\u009c\u00e6\u0098\u00af\u00e6\u00b4\u00bb\u00e5\u008a\u00a8\u00e7\u00ba\u00bf\u00e7\u00a8\u008b
  				if(connInfo.getStatus() == ConnectionInfoIF.STATUS_ACTIVE){
  					long actualActiveTime = 0;
  					if (connInfo.getTimeLastStopActive() > 0) {
  						actualActiveTime = connInfo.getTimeLastStopActive() - connInfo.getTimeLastStartActive();
  	                } else if (connInfo.getTimeLastStartActive() > 0) {
  	                	actualActiveTime = snapshot.getSnapshotDate().getTime() - connInfo.getTimeLastStartActive();
  	                }
  					//\u00e5\u00a6\u0082\u00e6\u009e\u009c\u00e8\u00bf\u009e\u00e6\u008e\u00a5\u00e6\u00b4\u00bb\u00e5\u008a\u00a8\u00e6\u0097\u00b6\u00e9\u0097\u00b4\u00e5\u00a4\u00a7\u00e4\u00ba\u008e\u00e6\u008c\u0087\u00e5\u00ae\u009a\u00e7\u009a\u0084\u00e9\u0098\u0088\u00e5\u0080\u00bc
  					if(actualActiveTime > activeTime){
  						String threadName = connInfo.getRequester();
  						if(threadName != null){
  							//\u00e5\u0088\u00a4\u00e6\u0096\u00ad\u00e6\u0098\u00af\u00e5\u0090\u00a6\u00e6\u0098\u00af\u00e7\u00a9\u00ba\u00e7\u00ba\u00bf\u00e7\u00a8\u008b
  							Boolean isDummy = false; 
  							if(cache.containsKey(threadName)){
  								isDummy = cache.get(threadName);
  							} else {
  								isDummy = isDummyThread(threadName);
  								cache.put(threadName, isDummy);
  							}
  							if(isDummy){
  								//\u00e5\u00a6\u0082\u00e6\u009e\u009c\u00e6\u0098\u00af\u00e7\u00a9\u00ba\u00e7\u00ba\u00bf\u00e7\u00a8\u008b\u00ef\u00bc\u008c\u00e9\u0087\u008a\u00e6\u0094\u00be\u00e8\u00af\u00a5\u00e8\u00bf\u009e\u00e6\u008e\u00a5
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
   * \u00e9\u0087\u008a\u00e6\u0094\u00be\u00e6\u00b4\u00bb\u00e5\u008a\u00a8\u00e7\u009d\u0080\u00e7\u009a\u0084\u00e8\u00bf\u009e\u00e6\u008e\u00a5,\u00e8\u00bf\u0094\u00e5\u009b\u009e\u00e8\u00a2\u00ab\u00e9\u0087\u008a\u00e6\u0094\u00be\u00e7\u009a\u0084\u00e8\u00bf\u009e\u00e6\u008e\u00a5id\u00e6\u0095\u00b0\u00e7\u00bb\u0084
   */
  private List<Long> releaseAllActiveConn(String alias, long activeTime){
  	try{
  		//\u00e8\u008e\u00b7\u00e5\u008f\u0096\u00e5\u00bf\u00ab\u00e7\u0085\u00a7\u00e5\u008f\u008a\u00e8\u00bf\u009e\u00e6\u008e\u00a5\u00e8\u00af\u00a6\u00e6\u0083\u0085
  		SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias, true);
  		ConnectionInfoIF[] connInfos = snapshot.getConnectionInfos();
  		if(connInfos != null){
  			List<Long> releasedIds = new ArrayList<Long>();
  			for(ConnectionInfoIF connInfo : connInfos){
  				//\u00e5\u00a6\u0082\u00e6\u009e\u009c\u00e6\u0098\u00af\u00e6\u00b4\u00bb\u00e5\u008a\u00a8\u00e8\u00bf\u009e\u00e6\u008e\u00a5
  				if(connInfo.getStatus() == ConnectionInfoIF.STATUS_ACTIVE){
  					long actualActiveTime = 0;
  					if (connInfo.getTimeLastStopActive() > 0) {
  						actualActiveTime = connInfo.getTimeLastStopActive() - connInfo.getTimeLastStartActive();
  	                } else if (connInfo.getTimeLastStartActive() > 0) {
  	                	actualActiveTime = snapshot.getSnapshotDate().getTime() - connInfo.getTimeLastStartActive();
  	                }
  					//\u00e5\u00a6\u0082\u00e6\u009e\u009c\u00e8\u00bf\u009e\u00e6\u008e\u00a5\u00e6\u00b4\u00bb\u00e5\u008a\u00a8\u00e6\u0097\u00b6\u00e9\u0097\u00b4\u00e5\u00a4\u00a7\u00e4\u00ba\u008e\u00e6\u008c\u0087\u00e5\u00ae\u009a\u00e7\u009a\u0084\u00e9\u0098\u0088\u00e5\u0080\u00bc
  					if(actualActiveTime > activeTime){
  						String threadName = connInfo.getRequester();
  						if(threadName != null){
  							//\u00e9\u0087\u008a\u00e6\u0094\u00be\u00e8\u00af\u00a5\u00e8\u00bf\u009e\u00e6\u008e\u00a5
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
   * \u00e6\u00a0\u00b9\u00e6\u008d\u00ae\u00e5\u00a0\u0086\u00e6\u00a0\u0088\u00e5\u0088\u00a4\u00e6\u0096\u00ad\u00e7\u00ba\u00bf\u00e7\u00a8\u008b\u00e6\u0098\u00af\u00e5\u0090\u00a6\u00e6\u0098\u00af\u00e7\u00a9\u00ba\u00e7\u00ba\u00bf\u00e7\u00a8\u008b
   */
  private boolean isDummyThread(String threadName){
  	ThreadInfo info = getThreadInfoByName(threadName);
  	if(info != null){
  		//\u00e6\u0089\u0080\u00e6\u009c\u0089\u00e5\u00a0\u0086\u00e6\u00a0\u0088\u00e5\u009d\u0087\u00e4\u00bb\u00a5java. \u00e6\u0088\u0096\u00e8\u0080\u0085 com.caucho. \u00e5\u00bc\u0080\u00e5\u00a4\u00b4
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
   * \u00e5\u0088\u00a4\u00e6\u0096\u00ad\u00e5\u00a0\u0086\u00e6\u00a0\u0088\u00e6\u0098\u00af\u00e5\u0090\u00a6\u00e5\u008c\u0085\u00e5\u0090\u00ab\u00e7\u0094\u00a8\u00e6\u0088\u00b7\u00e8\u00bf\u0090\u00e8\u00a1\u008c\u00e4\u00bb\u00a3\u00e7\u00a0\u0081,\u00e5\u008d\u00b3\u00e6\u0098\u00af\u00e5\u0090\u00a6\u00e5\u008c\u0085\u00e5\u0090\u00ab\u00e4\u00b8\u008d\u00e4\u00bb\u00a5 SYSTEM_STACK_PREFIX \u00e5\u00bc\u0080\u00e5\u00a4\u00b4\u00e7\u009a\u0084\u00e5\u00a0\u0086\u00e6\u00a0\u0088
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
  				//\u00e8\u008e\u00b7\u00e5\u008f\u0096\u00e5\u00bf\u00ab\u00e7\u0085\u00a7\u00e5\u008f\u008a\u00e8\u00bf\u009e\u00e6\u008e\u00a5\u00e8\u00af\u00a6\u00e6\u0083\u0085
  				SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias, true);
  				ConnectionInfoIF[] connInfos = snapshot.getConnectionInfos();
  				if(connInfos != null){
  					for(ConnectionInfoIF connInfo : connInfos){
  						//\u00e5\u00a6\u0082\u00e6\u009e\u009c\u00e6\u0098\u00af\u00e6\u00b4\u00bb\u00e5\u008a\u00a8\u00e7\u00ba\u00bf\u00e7\u00a8\u008b
  						if(connInfo.getStatus() == ConnectionInfoIF.STATUS_ACTIVE){
  							long actualActiveTime = 0;
  							if (connInfo.getTimeLastStopActive() > 0) {
  								actualActiveTime = connInfo.getTimeLastStopActive() - connInfo.getTimeLastStartActive();
  			                } else if (connInfo.getTimeLastStartActive() > 0) {
  			                	actualActiveTime = snapshot.getSnapshotDate().getTime() - connInfo.getTimeLastStartActive();
  			                }
  							//\u00e5\u00a6\u0082\u00e6\u009e\u009c\u00e8\u00bf\u009e\u00e6\u008e\u00a5\u00e6\u00b4\u00bb\u00e5\u008a\u00a8\u00e6\u0097\u00b6\u00e9\u0097\u00b4\u00e5\u00a4\u00a7\u00e4\u00ba\u008e\u00e6\u008c\u0087\u00e5\u00ae\u009a\u00e7\u009a\u0084\u00e9\u0098\u0088\u00e5\u0080\u00bc
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
  

  
  public void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response)
    throws java.io.IOException, javax.servlet.ServletException
  {
    javax.servlet.http.HttpSession session = request.getSession(true);
    com.caucho.server.webapp.WebApp _jsp_application = _caucho_getApplication();
    javax.servlet.ServletContext application = _jsp_application;
    com.caucho.jsp.PageContextImpl pageContext = _jsp_application.getJspApplicationContext().allocatePageContext(this, _jsp_application, request, response, null, session, 8192, true, false);
    javax.servlet.jsp.PageContext _jsp_parentContext = pageContext;
    javax.servlet.jsp.JspWriter out = pageContext.getOut();
    final javax.el.ELContext _jsp_env = pageContext.getELContext();
    javax.servlet.ServletConfig config = getServletConfig();
    javax.servlet.Servlet page = this;
    response.setContentType("text/html");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      
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


      out.write(_jsp_string1, 0, _jsp_string1.length);
    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      _jsp_application.getJspApplicationContext().freePageContext(pageContext);
    }
  }

  private java.util.ArrayList _caucho_depends = new java.util.ArrayList();

  public java.util.ArrayList _caucho_getDependList()
  {
    return _caucho_depends;
  }

  public void _caucho_addDepend(com.caucho.vfs.PersistentDependency depend)
  {
    super._caucho_addDepend(depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  public boolean _caucho_isModified()
  {
    if (_caucho_isDead)
      return true;
    if (com.caucho.server.util.CauchoSystem.getVersionId() != 1886798272571451039L)
      return true;
    for (int i = _caucho_depends.size() - 1; i >= 0; i--) {
      com.caucho.vfs.Dependency depend;
      depend = (com.caucho.vfs.Dependency) _caucho_depends.get(i);
      if (depend.isModified())
        return true;
    }
    return false;
  }

  public long _caucho_lastModified()
  {
    return 0;
  }

  public java.util.HashMap<String,java.lang.reflect.Method> _caucho_getFunctionMap()
  {
    return _jsp_functionMap;
  }

  public void init(ServletConfig config)
    throws ServletException
  {
    com.caucho.server.webapp.WebApp webApp
      = (com.caucho.server.webapp.WebApp) config.getServletContext();
    super.init(config);
    com.caucho.jsp.TaglibManager manager = webApp.getJspApplicationContext().getTaglibManager();
    com.caucho.jsp.PageContextImpl pageContext = new com.caucho.jsp.PageContextImpl(webApp, this);
  }

  public void destroy()
  {
      _caucho_isDead = true;
      super.destroy();
  }

  public void init(com.caucho.vfs.Path appDir)
    throws javax.servlet.ServletException
  {
    com.caucho.vfs.Path resinHome = com.caucho.server.util.CauchoSystem.getResinHome();
    com.caucho.vfs.MergePath mergePath = new com.caucho.vfs.MergePath();
    mergePath.addMergePath(appDir);
    mergePath.addMergePath(resinHome);
    com.caucho.loader.DynamicClassLoader loader;
    loader = (com.caucho.loader.DynamicClassLoader) getClass().getClassLoader();
    String resourcePath = loader.getResourcePathSpecificFirst();
    mergePath.addClassPath(resourcePath);
    com.caucho.vfs.Depend depend;
    depend = new com.caucho.vfs.Depend(appDir.lookup("poolOperation.jsp"), -4072645564567379429L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}