
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%
					String method=Util.null2String(request.getParameter("method"));
					String  id =Util.null2String(request.getParameter("sid"));
					String delids=Util.null2String(request.getParameter("delids"));
			        String  name=Util.null2String(request.getParameter("name"));
			        String  wfid=Util.null2String(request.getParameter("wfid"));
			        String  sapread=Util.null2String(request.getParameter("sapread"));
			        String  sapwrite =Util.null2String(request.getParameter("sapwrite"));
			        String  wfcreateid=Util.null2String(request.getParameter("wfcreateid"));
			        if("".equals(wfcreateid)){
			        	wfcreateid="1";
			        }
			        String  wftitle  =Util.null2String(request.getParameter("wftitle"));
			        String  wftitleAdd =Util.null2String(request.getParameter("wftitleAdd"));
			        String  wflevel=Util.null2String(request.getParameter("wflevel"));
			        String   isopen=Util.null2String(request.getParameter("isopen"));
			        int  scanInterval=Util.getIntValue(request.getParameter("scanInterval"),60);
			        String  wfmark =Util.null2String(request.getParameter("wfmark"));
			        String 	isbill="";
			        if(!"".equals(wfid)){
							rs.execute("select formid,isbill from workflow_base where id="+wfid+"");
							if(rs.next()){
								isbill=rs.getString("isbill");
							}
					} 
			        String sql="";
			        boolean flag=false;
			        if("new".equals(method)){
			        			sql="insert into sap_thread (name,wfid,sapread,sapwrite,wfcreateid,wftitle,wftitleAdd,wflevel,isopen,scanInterval,wfmark,isbill) "
			        			+"values ('"+name+"','"+wfid+"','"+sapread+"','"+sapwrite+"','"+wfcreateid+"','"+wftitle+"','"+wftitleAdd+"','"+wflevel+"','"+isopen+"','"+scanInterval+"','"+wfmark+"','"+isbill+"')";
			        			flag=rs.execute(sql);
			        			//修正数据
			        			if(flag){
			        				if(!"".equals(sapread)){
				        				rs.execute("select w_fid,isbill,parurl from int_BrowserbaseInfo where mark='"+sapread+"'");
				        				if(rs.next()){
				        					String oldw_fid=rs.getString("w_fid");
				        					String parurl=rs.getString("parurl")+"";
				        					if(!wfid.equals(oldw_fid)){//说明用户切换了流程
				        								parurl=parurl.replace("workflowid="+oldw_fid+"&", "workflowid="+wfid+"&");
				        								rs.execute("update int_BrowserbaseInfo set isbill='"+isbill+"',parurl='"+parurl+"',w_fid='"+wfid+"'  where mark='"+sapread+"'");
				        					}
				        				}
			        				}
			        				if(!"".equals(sapwrite)){
				        				rs.execute("select w_fid,isbill,parurl from int_BrowserbaseInfo where mark='"+sapwrite+"'");
				        				if(rs.next()){
				        					String oldw_fid=rs.getString("w_fid");
				        					String parurl=rs.getString("parurl")+"";
				        					if(!wfid.equals(oldw_fid)){//说明用户切换了流程
				        								parurl=parurl.replace("workflowid="+oldw_fid+"&", "workflowid="+wfid+"&");
				        								rs.execute("update int_BrowserbaseInfo set isbill='"+isbill+"',parurl='"+parurl+"',w_fid='"+wfid+"'  where mark='"+sapwrite+"'");
				        					}
				        				}
			        				}
			        			}
			        }else if("update".equals(method)){
			        			sql="update sap_thread set name='"+name+"',wfid='"+wfid+"',sapread='"+sapread+"',sapwrite='"+sapwrite+"',wfcreateid='"+wfcreateid+"',wftitle='"+wftitle+"',wftitleAdd='"+wftitleAdd+"',wflevel='"+wflevel+"',isopen='"+isopen+"',scanInterval='"+scanInterval+"',wfmark='"+wfmark+"',isbill='"+isbill+"'";
			        			sql+=" where id='"+id+"'";
			        			flag=rs.execute(sql);
			        			//修正数据
			        			    			if(flag){
			        				if(!"".equals(sapread)){
				        				rs.execute("select w_fid,isbill,parurl from int_BrowserbaseInfo where mark='"+sapread+"'");
				        				if(rs.next()){
				        					String oldw_fid=rs.getString("w_fid");
				        					String parurl=rs.getString("parurl")+"";
				        					if(!wfid.equals(oldw_fid)){//说明用户切换了流程
				        								parurl=parurl.replace("workflowid="+oldw_fid+"&", "workflowid="+wfid+"&");
				        								rs.execute("update int_BrowserbaseInfo set isbill='"+isbill+"',parurl='"+parurl+"',w_fid='"+wfid+"'  where mark='"+sapread+"'");
				        					}
				        				}
			        				}
			        				if(!"".equals(sapwrite)){
				        				rs.execute("select w_fid,isbill,parurl from int_BrowserbaseInfo where mark='"+sapwrite+"'");
				        				if(rs.next()){
				        					String oldw_fid=rs.getString("w_fid");
				        					String parurl=rs.getString("parurl")+"";
				        					if(!wfid.equals(oldw_fid)){//说明用户切换了流程
				        								parurl=parurl.replace("workflowid="+oldw_fid+"&", "workflowid="+wfid+"&");
				        								rs.execute("update int_BrowserbaseInfo set isbill='"+isbill+"',parurl='"+parurl+"',w_fid='"+wfid+"' where mark='"+sapwrite+"'");
				        					}
				        				}
			        				}
			        			}
			        }else if("delete".equals(method)){
			        			delids=Util.TrimComma(delids);
			        			if(!"".equals(delids)){
			        				sql="delete  sap_thread  where id in ("+Util.TrimComma(delids)+")";
			        				flag=rs.execute(sql);
			        			}
			        }
		String isDialog=Util.null2String(request.getParameter("isDialog"));
		if("1".equals(isDialog)){
			response.sendRedirect("/integration/Monitoring/WfSystemNew.jsp?closeDialog=close&id="+id);
			return;
		}
%>
<html>
<body>
			<script type="text/javascript">
							var flag="<%=flag%>";
							if(flag=="true"){
								window.alert("<%=SystemEnv.getHtmlLabelName(30700,user.getLanguage()) %>!");
							}else{
								window.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>!");
							}
							window.location.href="/integration/Monitoring/WfSystem.jsp?checkmenu=4";
			</script>
</body>
</html>