<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.docs.docs.*"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.workrelate.util.*"%>
<%@ page import="weaver.pr.util.RightUtil"%>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="TransUtil" class="weaver.pr.util.TransUtil" scope="page" />
<jsp:useBean id="RightUtil" class="weaver.pr.util.RightUtil" scope="page" />
<%
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	//String currentDate = TimeUtil.getCurrentDateString();
	//String currentTime = TimeUtil.getOnlyCurrentTimeString();
	String sql = "";
	StringBuffer restr = new StringBuffer();
	
	if("save_detail".equals(operation) || "edit_detail".equals(operation)){
		//String currentUserId = user.getUID()+"";
		String plandetailid = Util.null2String(request.getParameter("plandetailid"));
		//String planid = Util.null2String(request.getParameter("planid"));
		//if(!RightUtil.isCanEditPlan(planid,currentUserId)) return;
    	String type = Util.null2String(request.getParameter("type"));
    	String resourceid = Util.null2String(request.getParameter("resourceid"));
    	String name = URLDecoder.decode(Util.null2String(request.getParameter("name")),"utf-8");
    	String cate = URLDecoder.decode(Util.null2String(request.getParameter("cate")),"utf-8");
    	String begindate1 = URLDecoder.decode(Util.null2String(request.getParameter("begindate1")),"utf-8");
    	String enddate1 = URLDecoder.decode(Util.null2String(request.getParameter("enddate1")),"utf-8");
    	String begindate2 = URLDecoder.decode(Util.null2String(request.getParameter("begindate2")),"utf-8");
    	String enddate2 = URLDecoder.decode(Util.null2String(request.getParameter("enddate2")),"utf-8");
    	String days1 = URLDecoder.decode(Util.null2String(request.getParameter("days1")),"utf-8");
    	String days2 = URLDecoder.decode(Util.null2String(request.getParameter("days2")),"utf-8");
    	String finishrate = URLDecoder.decode(Util.null2String(request.getParameter("finishrate")),"utf-8");
    	String target = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("target")),"utf-8"));
    	String result = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("result")),"utf-8"));
    	String custom1 = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("custom1")),"utf-8"));
    	String custom2 = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("custom2")),"utf-8"));
    	String custom3 = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("custom3")),"utf-8"));
    	String custom4 = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("custom4")),"utf-8"));
    	String custom5 = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("custom5")),"utf-8"));
    	String datatype = type.equals("1")?"3":"2";
    	if("save_detail".equals(operation)){
    		sql = "insert into PR_PlanReportDetail(programid,planid,planid2,userid,datatype,name,cate,begindate1,enddate1,begindate2,enddate2,days1,days2,finishrate,target,result,custom1,custom2,custom3,custom4,custom5)"
        		+" values('-1','0','0','"+resourceid+"','"+datatype+"','"+name+"','"+cate+"','"+begindate1+"','"+enddate1+"','"+begindate2+"','"+enddate2+"','"+days1+"','"+days2+"','"+finishrate+"','"+target+"','"+result+"','"+custom1+"','"+custom2+"','"+custom3+"','"+custom4+"','"+custom5+"')";
    		rs.executeSql(sql);
    		rs.executeSql("select max(id) from PR_PlanReportDetail");
    		if(rs.next()) plandetailid = Util.null2String(rs.getString(1));
    	}else{
    		sql = "update PR_PlanReportDetail set name='"+name+"',cate='"+cate+"',begindate1='"+begindate1+"',enddate1='"+enddate1+"',begindate2='"+begindate2+"',enddate2='"+enddate2+"',days1='"+days1+"',days2='"+days2+"',finishrate='"+finishrate+"'"
			+",target='"+target+"',result='"+result+"',custom1='"+custom1+"',custom2='"+custom2+"',custom3='"+custom3+"',custom4='"+custom4+"',custom5='"+custom5+"' where id="+plandetailid;
			rs.executeSql(sql);
    	}
    	restr.append(plandetailid);
	}
	//编辑字段
	else if("edit_field".equals(operation)){
		String plandetailid = Util.fromScreen3(request.getParameter("plandetailid"),user.getLanguage());
		if(!this.isCanEditDetail(plandetailid,user.getUID()+"")) return;
		String fieldname = Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage());
		String fieldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("fieldvalue"),"utf-8"));
		String fieldtype = Util.fromScreen3(request.getParameter("fieldtype"),user.getLanguage());
		//System.out.println("fieldname:"+fieldname);
		//System.out.println("fieldvalue:"+fieldvalue);
		if(fieldname.endsWith("ids") && fieldvalue.equals(",")){
			fieldvalue = "";
		}
		
		if(fieldname.equals("fileids")){//附件
			String oldfileids = "";
			rs.executeSql("select fileids from PR_PlanReportDetail where id="+plandetailid);
			if(rs.next()){
				oldfileids = Util.null2String(rs.getString(1));
			}
			if(fieldtype.equals("del")){
				int docid = Util.getIntValue(fieldvalue); 
				String delfilename = "";
				
				DocImageManager.resetParameter();
	            DocImageManager.setDocid(docid);
	            DocImageManager.selectDocImageInfo();
	            if(DocImageManager.next()) delfilename = DocImageManager.getImagefilename();
				
				DocManager dm = new DocManager();
				dm.setId(docid);
				dm.setUserid(user.getUID());
				dm.DeleteDocInfo();
				
				int index = oldfileids.indexOf(","+fieldvalue+",");
				if(index>-1){
					oldfileids = oldfileids.substring(0,index+1)+ oldfileids.substring(index+fieldvalue.length()+2);
					rs.executeSql("update PR_PlanReportDetail set fileids='"+oldfileids+"'  where id="+plandetailid);
					//记录日志
					//restr.append(this.writeLog(user,4,taskId,"fileids",delfilename,fn)+"$");
				}
			}else{
				fieldvalue = cmutil.cutString(fieldvalue,",",3);
				if(!"".equals(fieldvalue)) {
					if("".equals(oldfileids)) oldfileids = ",";
					oldfileids = oldfileids + fieldvalue + ",";
					rs.executeSql("update PR_PlanReportDetail set fileids='"+oldfileids+"' where id="+plandetailid);
					//记录日志
					//restr.append(this.writeLog(user,9,taskId,"fileids",fieldvalue,fn)+"$");
				}
			}
			List fileidList = Util.TokenizerString(oldfileids,",");
			for(int i=0;i<fileidList.size();i++){
				/**
				restr.append("<div class='txtlink txtlink"+fileidList.get(i)+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>");
				restr.append("<div style='float: left;'>"+cmutil.getFileDoc((String)fileidList.get(i),taskId)+"</div>");
				restr.append("<div class='btn_del' onclick=delItem('fileids','"+fileidList.get(i)+"')></div>");
				restr.append("<div class='btn_wh'></div>");
				restr.append("</div>");
				*/
				
				DocImageManager.resetParameter();
	            DocImageManager.setDocid(Integer.parseInt((String)fileidList.get(i)));
	            DocImageManager.selectDocImageInfo();
	            DocImageManager.next();
	            String docImagefileid = DocImageManager.getImagefileid();
	            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
	            String docImagefilename = DocImageManager.getImagefilename();
				restr.append("<div class='txtlink txtlink"+fileidList.get(i)+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>");
				restr.append("<div style='float: left;'>");
				restr.append("<a href=javaScript:openFullWindowHaveBar('/workrelate/plan/util/ViewDoc.jsp?id=" + fileidList.get(i)+"&plandetailid="+plandetailid+"')>"+docImagefilename+"</a>");
				restr.append("&nbsp;<a href='/workrelate/plan/util/ViewDoc.jsp?id="+fileidList.get(i)+"&plandetailid="+plandetailid+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>");
				restr.append("</div>");
				restr.append("<div class='btn_del' onclick=delItem('fileids','"+fileidList.get(i)+"')></div>");
				restr.append("<div class='btn_wh'></div>");
				restr.append("</div>");
			}
			
		}else{
			if(fieldtype.equals("str")){
				sql = "update PR_PlanReportDetail set "+fieldname+"='"+fieldvalue+"' where id="+plandetailid;
			}else if(fieldtype.equals("int")){
				fieldvalue = Util.null2o(fieldvalue);
				sql = "update PR_PlanReportDetail set "+fieldname+"="+fieldvalue+" where id="+plandetailid;
			}
			//System.out.println(sql);
			rs.executeSql(sql);
			
			/**
			String addvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("addvalue"),"utf-8"));
			String delvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("delvalue"),"utf-8"));
			if(!addvalue.equals("")){
				//记录日志
				restr.append(this.writeLog(user,3,taskId,fieldname,cmutil.cutString(addvalue,",",3),fn));
			}else if(!delvalue.equals("")){
				//记录日志
				restr.append(this.writeLog(user,4,taskId,fieldname,cmutil.cutString(delvalue,",",3),fn));
			}else{
				//记录日志
				restr.append(this.writeLog(user,2,taskId,fieldname,fieldvalue,fn));
			}
			*/
		}
		
	}
	//获取附件
	if("get_file".equals(operation)){
		String plandetailid = Util.fromScreen3(request.getParameter("plandetailid"),user.getLanguage());
		if(!plandetailid.equals("")){
			String fileids = "";
			rs.executeSql("select fileids from PR_PlanReportDetail where id="+plandetailid);
			if(rs.next()){
				fileids = rs.getString(1);
			}
			List fileidList = Util.TokenizerString(fileids,","); 
			for(int i=0;i<fileidList.size();i++){
				restr.append("<div class='txtlink txtlink"+fileidList.get(i)+" onmouseover='showdel(this)' onmouseout='hidedel(this)'>");
				restr.append("<div style='float: left;'>"+cmutil.getFileDoc((String)fileidList.get(i),plandetailid)+"</div>");
				restr.append("<div class='btn_del' onclick=delItem('fileids','"+fileidList.get(i)+"')></div>");
				restr.append("<div class='btn_wh'></div>");
				restr.append("</div>");
			}
		}
	}
	//添加反馈
	if("add_feedback".equals(operation)){
		String currentDate = TimeUtil.getCurrentDateString();
		String currentTime = TimeUtil.getOnlyCurrentTimeString();
		String plandetailid = Util.fromScreen3(request.getParameter("plandetailid"),user.getLanguage());
		if(!this.isCanViewDetail(plandetailid,user.getUID()+"")) return;
		String content = Util.convertInput2DB(URLDecoder.decode(request.getParameter("content"),"utf-8"));
		String docids = cmutil.cutString(request.getParameter("docids"),",",3);
		String wfids = cmutil.cutString(request.getParameter("wfids"),",",3);
		String crmids = cmutil.cutString(request.getParameter("crmids"),",",3);
		String projectids = cmutil.cutString(request.getParameter("projectids"),",",3);
		String meetingids = cmutil.cutString(request.getParameter("meetingids"),",",3);
		String fileids = cmutil.cutString(request.getParameter("fileids"),",",3);
		if(!fileids.equals("")) fileids = "," + fileids + ",";
		if(!plandetailid.equals("") && !content.equals("")){
			sql = "insert into PR_PlanFeedback (plandetailid,remark,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime)"
				+" values("+plandetailid+",'"+content+"',"+user.getUID()+",'"+docids+"','"+wfids+"','"+crmids+"','"+projectids+"','"+meetingids+"','"+fileids+"','"+currentDate+"','"+currentTime+"')";
			rs.executeSql(sql);
			restr.append("<tr><td class='data fbdata' align='center'><div class='feedbackshow'>"
					+"<div class='feedbackinfo'>"+cmutil.getPerson(user.getUID()+"")+" "+currentDate+" "+currentTime+"</div>"
					+"<div class='feedbackrelate'>"
					+"<div style='width:100%'>"+Util.convertDB2Input(content)+"</div>");
			if(!"".equals(docids)){
				restr.append("<div>相关文档："+cmutil.getDocName(docids)+"</div>");
			}
			if(!"".equals(wfids)){
				restr.append("<div>相关流程："+cmutil.getRequestName(wfids)+"</div>");
			}
			if(!"".equals(crmids)){
				restr.append("<div>相关客户："+cmutil.getCustomer(crmids)+"</div>");
			}
			if(!"".equals(projectids)){
				restr.append("<div>相关项目："+cmutil.getProject(projectids)+"</div>");
			}
			if(!"".equals(fileids)){
				restr.append("<div>相关附件："+this.getFileDoc(fileids,plandetailid)+"</div>");
			}
			restr.append("</div></div></td></tr>");
			
			//记录日志
			//restr.append("$"+this.writeLog(user,10,taskId,"","",fn));
		}
	}
	//获取反馈记录
	if("get_feedback".equals(operation)){
		String plandetailid = Util.fromScreen3(request.getParameter("plandetailid"),user.getLanguage());
		if(!this.isCanViewDetail(plandetailid,user.getUID()+"")) return;
		String lastId = Util.fromScreen3(request.getParameter("lastId"),user.getLanguage());
		String viewdate = Util.fromScreen3(request.getParameter("viewdate"),user.getLanguage());
		rs.executeSql("select id,remark,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime from PR_PlanFeedback where plandetailid=" + plandetailid +" and id<"+lastId+" order by createdate desc,createtime desc");
		String docids = "";
		String wfids = "";
		String crmids = "";
		String projectids = "";
		String fileids = "";
		while(rs.next()){
			docids = Util.null2String(rs.getString("docids"));
			wfids = Util.null2String(rs.getString("wfids"));
			crmids = Util.null2String(rs.getString("crmids"));
			projectids = Util.null2String(rs.getString("projectids"));
			fileids = Util.null2String(rs.getString("fileids"));
			restr.append("<tr><td class='data fbdata' align='center'><div class='feedbackshow'>"
					+"<div class='feedbackinfo'>"+cmutil.getPerson(rs.getString("hrmid"))+" "+rs.getString("createdate")+" "+rs.getString("createtime"));
			if(!viewdate.equals("") && !(user.getUID()+"").equals(rs.getString("hrmid")) && TimeUtil.timeInterval(viewdate,Util.null2String(rs.getString("createdate"))+" "+Util.null2String(rs.getString("createtime")))>0){
				restr.append("<font style='color: red;margin-left: 5px;font-style: italic;font-size: 11px;cursor: pointer;' title='新反馈'>new</font>");
			}
			restr.append("</div>");
			restr.append("<div class='feedbackrelate'>");
			restr.append("	<div>"+Util.convertDB2Input(rs.getString("remark"))+"</div>");
			if(!"".equals(docids)){
				restr.append("<div class='relatetitle'>相关文档："+cmutil.getDocName(docids)+"</div>");
			}
			if(!"".equals(wfids)){
				restr.append("<div class='relatetitle'>相关流程："+cmutil.getRequestName(wfids)+"</div>");
			}
			if(!"".equals(crmids)){
				restr.append("<div class='relatetitle'>相关客户："+cmutil.getCustomer(crmids)+"</div>");
			}
			if(!"".equals(projectids)){
				restr.append("<div class='relatetitle'>相关项目："+cmutil.getProject(projectids)+"</div>");
			}
			if(!"".equals(fileids)){
				restr.append("<div class='relatetitle'>相关附件："+this.getFileDoc(fileids,plandetailid)+"</div>");
			}
			restr.append("</div></div></td></tr>");
		}
	}
	//获取更多操作日志
	if("get_more_log".equals(operation)){
		String planid = Util.null2String(request.getParameter("planid"));
		if(!RightUtil.isCanViewPlan(planid,user.getUID()+"")) return;
		
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		
		String orderby1 = " order by operatedate desc,operatetime desc,id desc";
		String orderby2 = " order by operatedate asc,operatetime asc,id asc";
		String orderby3 = " order by operatedate desc,operatetime desc,id desc";
		
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		String querysql = " id,operator,operatedate,operatetime,operatetype from PR_PlanReportLog where planid="+ planid;
		//sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql + orderby3 + ") A "+orderby2;
		//sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		if(rs.getDBType().equals("oracle")){
			sql = "select " + querysql+ orderby3;
			sql = "select A.*,rownum rn from (" + sql + ") A where rownum <= " + (iNextNum);
			sql = "select B.* from (" + sql + ") B where rn > " + (iNextNum - pagesize);
		}else{
			sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
			sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		}
		
		rs.executeSql(sql);
		String logoperator = "";
		String operatetype = "";
		while (rs.next()) {
			logoperator = Util.null2String(rs.getString("operator"));
			operatetype = Util.null2String(rs.getString("operatetype"));
			if(logoperator.equals("0")){
				logoperator = "系统";
			}else{
				logoperator = cmutil.getPerson(logoperator);
			}
%>
	<div style="color: #808080;">
		<%=logoperator %>
		&nbsp;&nbsp;&nbsp;<%=Util.null2String(rs.getString("operatedate")) %>&nbsp;&nbsp;<%=Util.null2String(rs.getString("operatetime")) %>&nbsp;&nbsp;&nbsp;<%=operatetype.equals("0")?"查看":TransUtil.getPlanOperateType(rs.getString("operatetype")) %>
	</div>
<%
		}
	}
	
	out.print(restr.toString());
	//out.close();
%>
<%!
	private String getLink(String field,String value,String taskId){
		CommonTransUtil cmutil = new CommonTransUtil();
		if("principalid".equals(field) || "partnerid".equals(field) || "sharerid".equals(field) || "hrmid".equals(field)){
			return cmutil.getHrm(value);
		}else if("docids".equals(field)){
			return cmutil.getDocName(value);
		}else if("wfids".equals(field)){
			return cmutil.getRequestName(value);
		}else if("crmids".equals(field)){
			return cmutil.getCustomer(value);
		}else if("projectids".equals(field)){
			return cmutil.getProject(value);
		}else if("taskids".equals(field)){
			return cmutil.getTaskName(value);
		}else if("fileids".equals(field)){
			return value;
		}else if("level".equals(field)){
			if("1".equals(value)) return "重要紧急";
			if("2".equals(value)) return "重要";
			if("3".equals(value)) return "紧急";
			if("4".equals(value)) return "不重要不紧急";
			return "";
		}else{
			return value;
		}
	}
	public String getFileDoc(String ids,String plandetailid) throws Exception{
		String returnstr = "";
		String docid = "";
		String docImagefileid = "";
		int docImagefileSize = 0;
		String docImagefilename = "";
		DocImageManager DocImageManager = null;
		if(ids != null && !"".equals(ids)){
			List idList = Util.TokenizerString(ids, ",");
			for (int i = 0; i < idList.size(); i++) {
				docid = Util.null2String((String)idList.get(i));
				if(!docid.equals("")){
					DocImageManager = new DocImageManager();
					DocImageManager.resetParameter();
		            DocImageManager.setDocid(Integer.parseInt((String)idList.get(i)));
		            DocImageManager.selectDocImageInfo();
		            DocImageManager.next();
		            docImagefileid = DocImageManager.getImagefileid();
		            docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
		            docImagefilename = DocImageManager.getImagefilename();
		            returnstr += "<a href=javaScript:openFullWindowHaveBar('/workrelate/plan/util/ViewDoc.jsp?id="+docid+"&plandetailid="+plandetailid+"') >"+docImagefilename+"</a>";
		            returnstr += "&nbsp;<a href='/workrelate/plan/util/ViewDoc.jsp?id="+docid+"&plandetailid="+plandetailid+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>&nbsp;&nbsp;";
				}
			}
		}
		return returnstr;
	}
	private String getHrmLink(String id) throws Exception{
		String returnstr = "";
		if(!"".equals(id) && !"0".equals(id)){
			ResourceComInfo rc = new ResourceComInfo();
			returnstr = "<a href=javascript:searchList("+id+",'"+rc.getLastname(id)+"')>"+rc.getLastname(id)+"</a>";
		}else{
			returnstr = "&nbsp;";
		}
		return returnstr;
	}
	private boolean isCanViewDetail(String plandetailid,String userid){
		boolean canview = false;
		if(!plandetailid.equals("")){
			RecordSet rs = new RecordSet();
			rs.executeSql("select planid,planid2 from PR_PlanReportDetail where id="+plandetailid);
			if(rs.next()){
				RightUtil ru = new RightUtil();
				String planid = Util.null2String(rs.getString("planid"));
				String planid2 = Util.null2String(rs.getString("planid2"));
				if(planid.equals("0") && planid2.equals("0")) return true;
				if(ru.isCanViewPlan(planid,userid)){
					canview = true;
				}else{
					canview = ru.isCanViewPlan(planid2,userid);
				}
			}
		}
		return canview;
	}
	private boolean isCanEditDetail(String plandetailid,String userid){
		boolean canview = false;
		if(!plandetailid.equals("")){
			RecordSet rs = new RecordSet();
			rs.executeSql("select planid,planid2 from PR_PlanReportDetail where id="+plandetailid);
			if(rs.next()){
				String planid = Util.null2String(rs.getString("planid"));
				String planid2 = Util.null2String(rs.getString("planid2"));
				if(planid.equals("0") && planid2.equals("0")) return true;
				if(RightUtil.isCanEditPlan(planid,userid)){
					canview = true;
				}else{
					canview = RightUtil.isCanEditPlan(planid2,userid);
				}
			}
		}
		return canview;
	}
%>
