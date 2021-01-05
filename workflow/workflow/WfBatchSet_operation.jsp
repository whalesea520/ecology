<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="java.net.InetAddress"%>
<%@ page import="java.net.UnknownHostException"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"></jsp:useBean>
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page"></jsp:useBean>
<jsp:useBean id="rst" class="weaver.conn.RecordSetTrans" scope="page"></jsp:useBean>
<jsp:useBean id="sqlBuffer" class="StringBuffer" scope="page"></jsp:useBean>
<jsp:useBean id="jsonarray" class="org.json.JSONArray" scope="page"></jsp:useBean>
<%
	String wfids = Util.null2String(request.getParameter("wfids"));
	String checkeddetails = Util.null2String(request.getParameter("checkeddetails"));
	
	sqlBuffer.append("update workflow_base set ");
	List<String> labelids = new ArrayList<String>();
	if(StringUtils.isNotBlank(checkeddetails)){
		String[] checkeditems = checkeddetails.split(",");
		for(int i=0;i<checkeditems.length;i++){
		    //附件上传目录
		    if("docPath".equals(checkeditems[i])){
		        String doPath = Util.null2String(request.getParameter("docPath"));
		        String maincategory= Util.null2String(request.getParameter("maincategory"));
		        String subcategory= Util.null2String(request.getParameter("subcategory"));
		        String seccategory= Util.null2String(request.getParameter("seccategory"));
		        
		        String doccategory =  maincategory+","+subcategory+","+seccategory;
		        sqlBuffer.append("catelogType = 0,").append("docCategory='"+doccategory+"' ,docPath='"+doPath+"'");
		    //提醒设置
		    }else if("remindSet".equals(checkeditems[i])){
		        sqlBuffer.append("messageType = '").append(Util.null2String(request.getParameter("messageType"))).append("',");    
		        sqlBuffer.append("chatsType = '").append(Util.null2String(request.getParameter("chatsType"))).append("',");    
		        sqlBuffer.append("mailMessageType = '").append(Util.null2String(request.getParameter("mailMessageType"))).append("',");    
		        sqlBuffer.append("archiveNoMailAlert = '").append(Util.null2String(request.getParameter("archiveNoMailAlert"))).append("'");   
		    }else if("defaultName".equals(checkeditems[i])){
		        for(String wfid:wfids.split(",")){
		        	rst.executeUpdate("delete from Workflow_SetTitle where workflowid = ?",wfid);
		        	if(rst.getDBType().equals("oracle")){
		        		rst.executeUpdate("insert into Workflow_SetTitle(id,xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,workflowid,trrowid,txtUserUse,showhtml) select WORKFLOW_SETTITLE_SQE.NEXTVAL,xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,"+wfid+",trrowid,txtUserUse,showhtml from Workflow_SetTitle where workflowid = -1");
		        	}else{
		        	    rst.executeUpdate("insert into Workflow_SetTitle(xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,workflowid,trrowid,txtUserUse,showhtml) select xh,fieldtype,fieldvalue,fieldlevle,fieldname,fieldzx,"+wfid+",trrowid,txtUserUse,showhtml from Workflow_SetTitle where workflowid = -1");
		        	}
		        }
		        rst.executeUpdate("delete from Workflow_SetTitle where workflowid = -1");
		        sqlBuffer.append(checkeditems[i]).append("= '").append(Util.null2String(request.getParameter(checkeditems[i]))).append("'");
		    }else{
			    sqlBuffer.append(checkeditems[i]).append("= '").append(Util.null2String(request.getParameter(checkeditems[i]))).append("'");
		    }
		    
		    labelids.add(Util.null2String(request.getParameter(checkeditems[i]+"_name")));
        	sqlBuffer.append((i < checkeditems.length - 1)?",":"");
		}
	}
	sqlBuffer.append(" where id in (").append(wfids).append(")");
	try{
	
		rst.executeUpdate(sqlBuffer.toString());
		
		Calendar today  = Calendar.getInstance();
		String createdate  = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
						  Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
					  	  Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
		String createtime =  Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
						  Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
						  Util.add0(today.get(Calendar.SECOND), 2);
		String ip = "";
	    try {
	         InetAddress netAddress = InetAddress.getLocalHost();
	         ip = netAddress.getHostAddress();
	    } catch (UnknownHostException e) {
	        e.printStackTrace();
	    }
		
		String sqltemp = "insert into workflow_batch_operate_log(createdate,createtime,creator,wfid,operateobj,ip) values(?,?,?,?,?,?)";
		for(String wfid:wfids.split(",")){
		    for(String labelid:labelids){
		        rst.executeUpdate(sqltemp,createdate,createtime,user.getUID(),wfid,SystemEnv.getHtmlLabelNames(labelid,user.getLanguage()),ip);
		    }
		}
		rst.commit();
	}catch(Exception exception){
	    exception.printStackTrace();
	    rst.rollback();
	}
	response.sendRedirect("/workflow/workflow/WfBatchSet_main.jsp");
%>