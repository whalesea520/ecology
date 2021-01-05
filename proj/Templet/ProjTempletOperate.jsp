<%@page import="weaver.conn.RecordSetTrans"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="weaver.docs.docs.DocExtUtil" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="PriTemplate" class="weaver.proj.PriTemplate" scope="page" />
<jsp:useBean id="ProjectAccesory" class="weaver.proj.ProjectAccesory" scope="page" />
<jsp:useBean id="CptFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>
<%

User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}
String isdialog=Util.null2String(request.getParameter("isdialog"));
String submittype=Util.null2String(request.getParameter("submittype"));
String currenttab = Util.null2String(request.getParameter("currenttab"));
JSONObject jsonInfo=new JSONObject();
int accessorynum = Util.getIntValue(request.getParameter("accessory_num"),0);
int deleteField_idnum = Util.getIntValue(request.getParameter("field_idnum"),0);

String accdocids=Util.null2String(request.getParameter("accdocids"));


    //多个来源
    String URLFrom = URLDecoder.decode(Util.null2String(request.getParameter("URLFrom")));
        
    String method = Util.null2String(request.getParameter("method"));
    String templetId = Util.null2String(request.getParameter("templetId"));
    //---------项目变量
    int projectType = Util.getIntValue(request.getParameter("prjtype"));  //项目类型
    int workType = Util.getIntValue(request.getParameter("worktype"));     //工作类型
    String hrmId = Util.null2String(request.getParameter("hrmids02"));        //项目成员
    int parentId = Util.getIntValue(request.getParameter("parentid"));     //上级项目
    int envDoc = Util.getIntValue(request.getParameter("envaluedoc"));       //评价书
    int conDoc = Util.getIntValue(request.getParameter("confirmdoc"));       //确认书
    int adviceDoc = Util.getIntValue(request.getParameter("proposedoc"));    //建议书
    int prjManager = Util.getIntValue(request.getParameter("manager"));   //经理
    String isCrmShow = Util.null2String(request.getParameter("managerview"));       //客户可见
    String isMemberShow = Util.null2String(request.getParameter("isblock"));    //成员可见
    String aboutMCrm = Util.null2String(request.getParameter("description"));    //相关客户
    String templetName = Util.null2String(request.getParameter("name"));    //模板名称
    String templetDesc = Util.null2String(request.getParameter("txtTempletDesc"));    //模板描述
   
    //---------项目自定义字段
    String dff01=Util.null2String(request.getParameter("dff01"));
    String dff02=Util.null2String(request.getParameter("dff02"));
    String dff03=Util.null2String(request.getParameter("dff03"));
    String dff04=Util.null2String(request.getParameter("dff04"));
    String dff05=Util.null2String(request.getParameter("dff05"));

    String nff01=Util.null2String(request.getParameter("nff01"));
    if(nff01.equals("")) nff01="0.0";
    String nff02=Util.null2String(request.getParameter("nff02"));
    if(nff02.equals("")) nff02="0.0";
    String nff03=Util.null2String(request.getParameter("nff03"));
    if(nff03.equals("")) nff03="0.0";
    String nff04=Util.null2String(request.getParameter("nff04"));
    if(nff04.equals("")) nff04="0.0";
    String nff05=Util.null2String(request.getParameter("nff05"));
    if(nff05.equals("")) nff05="0.0";

    String tff01=Util.fromScreen(request.getParameter("tff01"),user.getLanguage());
    String tff02=Util.fromScreen(request.getParameter("tff02"),user.getLanguage());
    String tff03=Util.fromScreen(request.getParameter("tff03"),user.getLanguage());
    String tff04=Util.fromScreen(request.getParameter("tff04"),user.getLanguage());
    String tff05=Util.fromScreen(request.getParameter("tff05"),user.getLanguage());

    String bff01=Util.null2String(request.getParameter("bff01"));
    if(bff01.equals("")) bff01="0";
    String bff02=Util.null2String(request.getParameter("bff02"));
    if(bff02.equals("")) bff02="0";
    String bff03=Util.null2String(request.getParameter("bff03"));
    if(bff03.equals("")) bff03="0";
    String bff04=Util.null2String(request.getParameter("bff04"));
    if(bff04.equals("")) bff04="0";
    String bff05=Util.null2String(request.getParameter("bff05"));
    if(bff05.equals("")) bff05="0";

    //---------任务自定义字段
    String[] taskids = request.getParameterValues("templetTaskId");   //任务ID
    String[] rowIndexs = request.getParameterValues("txtRowIndex");   //任务名称
    String[] taskNames = request.getParameterValues("txtTaskName");   //任务名称
    String[] workLongs = request.getParameterValues("txtWorkLong");   //工期
    String[] beginDates = request.getParameterValues("txtBeginDate");  //开始时间
    String[] endDates = request.getParameterValues("txtEndDate");     //结束时间
    String[] beforeTasks = request.getParameterValues("seleBeforeTask"); //前置任务
    String[] budgets = request.getParameterValues("txtBudget");         //预算
    String[] managers = request.getParameterValues("txtManager");       //负责人
    
  	//4E8
    String[] parentRowIndexs = request.getParameterValues("txtParentRowIndex");//父任务索引
    String[] levels = request.getParameterValues("txtLevel");       //任务层级
    String[] realids = request.getParameterValues("realid");       //数据库真实id
    
    String linkXml=Util.null2String(request.getParameter("areaLinkXml"));  //上下级关系的字符串
 PriTemplate.setTempletName(templetName);
 PriTemplate.setTempletDesc(templetDesc);
 PriTemplate.setProjectType(projectType);
 PriTemplate.setWorkType(workType);
 PriTemplate.setHrmId(hrmId);
 PriTemplate.setIsMemberShow(isMemberShow);
 PriTemplate.setAboutMCrm(aboutMCrm);
 PriTemplate.setIsCrmShow(isCrmShow);
 PriTemplate.setParentId(parentId);
 PriTemplate.setEnvDoc(envDoc);
 PriTemplate.setConDoc(conDoc);
 PriTemplate.setAdviceDoc(adviceDoc);
 PriTemplate.setPrjManager(prjManager);
 PriTemplate.setLinkXml(linkXml);
 PriTemplate.setDff01(dff01);
 PriTemplate.setDff02(dff02);
 PriTemplate.setDff03(dff03);
 PriTemplate.setDff04(dff04);
 PriTemplate.setDff05(dff05);
 PriTemplate.setNff01(nff01);
 PriTemplate.setNff02(nff02);
 PriTemplate.setNff03(nff03);
 PriTemplate.setNff04(nff04);
 PriTemplate.setNff05(nff05);
 PriTemplate.setTff01(tff01);
 PriTemplate.setTff02(tff02);
 PriTemplate.setTff03(tff03);
 PriTemplate.setTff04(tff04);
 PriTemplate.setTff05(tff05);
 PriTemplate.setBff01(bff01);
 PriTemplate.setBff02(bff02);
 PriTemplate.setBff03(bff03);
 PriTemplate.setBff04(bff04);
 PriTemplate.setBff05(bff05);
 PriTemplate.setTempletId(templetId);
 
    /*
    项目模板是否需要审批
    modified by hubo,2006-04-21
    */
    String defaultStatus = "1";
	String sqlApprove = "SELECT isNeedAppr,wfid FROM ProjTemplateMaint";
	boolean needApprove=false;
	rs.executeSql(sqlApprove);
	if(rs.next()){
		if(rs.getString("isNeedAppr").equals("1")&&rs.getInt("wfid")>0){
			defaultStatus = "0";//需要审批的项目模板默认为草稿
			needApprove=true;
		}
	}
	
	
	
	int newProjId = 0;
    if ("add".equals(method)){
        try {
            //------项目变量及项目自定义字段的数据的插入
           PriTemplate.setDefaultStatus(defaultStatus);
           //检测项目成员，当任务负责人不在项目成员中时，更新项目成员
           String hrmId111=hrmId+",";
           if(managers!=null&&managers.length>0){
        	   for (int i=0 ;i<managers.length;i++){
        		   hrmId111 += managers[i]+",";
        	   }
           }
           String[] managers111=hrmId111.split(",");
           List<String> list = new ArrayList<String>();
           for (int i = 0; i < managers111.length; i++) {
        	   if(!"".equals(managers111[i])&&!list.contains(managers111[i])){
        		   list.add(managers111[i]); 
        	   }
           }
           String hrmId112="";
		   if(list.size()>0){
 			   for(int m=0;m<list.size();m++){
 				   hrmId112+=list.get(m)+",";
 			   }
 			  hrmId112 = hrmId112.substring(0,hrmId112.length()-1);
 		   }
            PriTemplate.setHrmId(hrmId112);
           PriTemplate.AddPrjTemplateInfo();
            //System.out.println(strInsertSql);
            rs.executeSql("select max(id) from Prj_Template");
            
            if (rs.next()){
                newProjId = Util.getIntValue(rs.getString(1));
            }
            CptFieldManager.updateCusfieldValue(""+newProjId, new FileUpload(request), user,"Prj_Template");
            
          //附件上传开始
	        String tempAccessory = "";
	        if(!"".equals(accdocids)) {
	        	RecordSet.executeSql("update Prj_Template set accessory='"+accdocids+"' where id ="+newProjId );
	    	}
	        //附件上传结束
	        
	        //给项目里面的相关附件赋查看权限开始
	    	if(!"".equals(accdocids)) {
	    	   //ProjectAccesory.addAccesoryShare(accdocids,memberstmp);
	    	}
	    	//给项目里面的相关附件赋查看权限结束
            
            //System.out.println(linkXml);
            //------项目类型自定义字段的值的插入
            ProjTempletUtil.addProjTypeCData(request,newProjId);
        
            if(taskNames!=null&&taskNames.length>0){
            	//------任务的内容的插入
       			HashMap<String,String> taskIndexMap=new HashMap<String,String>();//4E8 存前置任务索引
                for (int i=0 ;i<taskNames.length;i++){
                    int rowIndex = Util.getIntValue(rowIndexs[i]);
                    String taskName = taskNames[i];
                    float workLong = Util.getFloatValue(workLongs[i],0);
                    String beginDate = beginDates[i];
                    String endDate = endDates[i];
                    int beforeTask = Util.getIntValue(beforeTasks[i],0);
                    float budget = Util.getFloatValue(budgets[i],0);
                    String manager =managers[i];

                    //String parentTaskId = ProjTempletUtil.getParentTaskId(linkXml,rowIndex);                  
                    //4E8
                    //System.out.println("rowindex:"+rowIndex+"\tbfindex:"+beforeTask);
    	            if(beforeTask>0){
    	              	taskIndexMap.put(""+rowIndex, ""+beforeTask);
    	            }
                    String parentTaskId=""+Util.getIntValue(parentRowIndexs[i],0);
                    
                    //System.out.println("rowIndex :"+rowIndex+" parentTaskId : "+parentTaskId);
                    String strsqlForTask = "insert into Prj_TemplateTask (templetId,templetTaskId,taskName,taskManager,begindate,enddate,workday,budget,parentTaskId,befTaskId) values("+newProjId+","+rowIndex+",'"+taskName+"','"+manager+"','"+beginDate+"','"+endDate+"',"+workLong+","+budget+","+parentTaskId+","+beforeTask+")";                
                    rs.executeSql(strsqlForTask);          
                 }
                 
                 //前置任务修正
                 //任务在未实际插入数据库前，任务id不确定，此时前置任务保存的id为任务的行号，在任务插入数据库后需要修正实际前置任务id
                 /**
                 rs.executeSql("select id,befTaskId from Prj_TemplateTask where befTaskId!=0 and templetId="+newProjId);
                 while(rs.next()){
                     String id = rs.getString("id");
                     String befTaskId = rs.getString("befTaskId");
                     String realBefTaskId = befTaskId;
                     rs1.executeSql("select id from Prj_TemplateTask where templetTaskId="+befTaskId+" and templetId="+newProjId);
                     if(rs1.next()) realBefTaskId = rs1.getString("id");
                     rs1.executeSql("update Prj_TemplateTask set befTaskId="+realBefTaskId+" where id="+id);
                 }**/
              //4E8
                for(Entry<String,String> entry:taskIndexMap.entrySet()){
               	 String key= entry.getKey();
               	 String val= entry.getValue();
               	 rs.executeSql("update  Prj_TemplateTask set  befTaskId='"+val+"'  where templetTaskId='"+key+"' and  templetId="+templetId);
                }
                 //前置任务修正
            }
            
             
             
             
             
             
             
        } catch (Exception ex) {
            //System.out.println(ex);
        }
        
        %>
        <script type="text/javascript">
        var needApprove='<%=needApprove %>';
        var submittype='<%=submittype %>';
        try{
        	if(needApprove=="true"&&submittype==2){
        		//onApprove(<%=newProjId %>);
        	}
	        parent.window.location.href="/proj/Templet/ProjTempletView.jsp?templetId=<%=newProjId %>&isclose=1&isdialog=<%=isdialog %>";
        }catch(e){}
        </script>

        <%   
        
        /**
        if (!"".equals(URLFrom)){
            response.sendRedirect(URLFrom);
        } else {
            response.sendRedirect("ProjTempletAdd.jsp?isclose=1");        
        }**/
        return ;
    } else if("edit".equals(method)) {
        try {
        	//检测项目成员，当任务负责人不在项目成员中时，更新项目成员

            String hrmId111=hrmId+",";
            if(managers!=null&&managers.length>0){
         	   for (int i=0 ;i<managers.length;i++){
         		   hrmId111 += managers[i]+",";
         	   }
            }
            String[] managers111=hrmId111.split(",");
            List<String> list = new ArrayList<String>();
            for (int i = 0; i < managers111.length; i++) {
         	   if(!"".equals(managers111[i])&&!list.contains(managers111[i])){
         		   list.add(managers111[i]); 
         	   }
            }
            String hrmId112="";
 		   if(list.size()>0){
 			   for(int m=0;m<list.size();m++){
 				   hrmId112+=list.get(m)+",";
 			   }
 			  hrmId112 = hrmId112.substring(0,hrmId112.length()-1);
 		   }
            PriTemplate.setHrmId(hrmId112);
            //------项目变量及项目自定义字段的数据的插入
            PriTemplate.EditPriTemplateInfo();
            CptFieldManager.updateCusfieldValue(templetId, new FileUpload(request), user,"Prj_Template");
            //------项目类型自定义字段的值的编辑
            ProjTempletUtil.editProjTypeCData(request,Util.getIntValue(templetId));
           
            //------任务的内容的编辑
            if(rowIndexs!=null&&rowIndexs.length>0){
                //选删除所有相关的任务,再添加全部的新任务         
    			HashMap<String,String> taskIndexMap=new HashMap<String,String>();//4E8 存前置任务索引
    			HashMap<String,String> taskOrderMap=new HashMap<String,String>();//4E8 存任务显示顺序与任务索引号对应关系
    			taskOrderMap.put("0","0");
                for (int i=0 ;i<rowIndexs.length;i++){
                    int rowIndex = Util.getIntValue(rowIndexs[i]);
                    String taskName = taskNames[i];
                    float workLong = Util.getFloatValue(workLongs[i],0);
                    String beginDate = beginDates[i];
                    String endDate = endDates[i];
                    int beforeTask = 0;
                    int bfindex = Util.getIntValue(beforeTasks[i],0);
                    float budget = Util.getFloatValue(budgets[i],0);
                    String manager =managers[i];
                    //int taskid = Util.getIntValue(taskids[i],-1);
                    //String parentTaskId = ProjTempletUtil.getParentTaskId(linkXml,rowIndex);
                    
                  //4E8
                    //System.out.println("rowindex:"+rowIndex+"\tbfindex:"+bfindex);
                  	taskOrderMap.put(""+rowIndex,""+(i+1));
    	            if(bfindex>0){
    	              	taskIndexMap.put(""+rowIndex, ""+bfindex);
    	            }
                  	int taskid = Util.getIntValue(realids[i],0);
                    String parentTaskId=""+Util.getIntValue(parentRowIndexs[i],0);
                  
                    //System.out.println("rowIndex:"+rowIndex+" parentTaskId: "+parentTaskId+" beforetaskindex: "+bfindex+" taskrealid:"+taskid+"taskName:"+taskName);
                    String strsqlForTask = "";
                    if (taskid>0){
                        strsqlForTask="update Prj_TemplateTask set templetTaskId='"+rowIndex+"',taskName='"+taskName+"',taskManager='"+manager+"',begindate='"+beginDate+"',enddate='"+endDate+"',workday="+workLong+",budget="+budget+",parentTaskId="+parentTaskId+",befTaskId="+beforeTask+" where templetid="+templetId+" and id="+taskid;
                    } else {
                        strsqlForTask = "insert into Prj_TemplateTask (templetId,templetTaskId,taskName,taskManager,begindate,enddate,workday,budget,parentTaskId,befTaskId) values("+templetId+","+rowIndex+",'"+taskName+"','"+manager+"','"+beginDate+"','"+endDate+"',"+workLong+","+budget+","+parentTaskId+","+beforeTask+")"; 
                    }
                    rs.executeSql(strsqlForTask); 
                 }
                 //删除相关的任务 
                 //System.out.println("=======================split line====================");
                 
                 //前置任务修正
                 //任务在未实际插入数据库前，任务id不确定，此时前置任务保存的id为任务的行号，在任务插入数据库后需要修正实际前置任务id
                 /**
                 rs.executeSql("select id,befTaskId from Prj_TemplateTask where befTaskId!=0 and templetId="+templetId);
                 while(rs.next()){
                     String id = rs.getString("id");
                     String befTaskId = rs.getString("befTaskId");
                     String realBefTaskId = befTaskId;
                     rs1.executeSql("select id from Prj_TemplateTask where templetTaskId="+befTaskId+" and templetId="+templetId);
                     if(rs1.next()) realBefTaskId = rs1.getString("id");
                     rs1.executeSql("update Prj_TemplateTask set befTaskId="+realBefTaskId+" where id="+id);
                 }**/
                 //4E8
                 for(Entry<String,String> entry:taskIndexMap.entrySet()){
                	 String key= entry.getKey();
                	 String val= entry.getValue();
                	 rs.executeSql("update  Prj_TemplateTask set  befTaskId='"+val+"'  where templetTaskId='"+key+"' and  templetId="+templetId);
                 }
                 //4E8 重建rowindex
                 RecordSetTrans rst=new RecordSetTrans();
                 rst.setAutoCommit(false);
                 try{
                	 rs.executeSql("select id,templetTaskId,parentTaskId,befTaskId from prj_templatetask where templetId="+templetId+" order by id");
                	 
                	 while(rs.next()){
                		 String id=Util.null2String(rs.getString("id"));
                		 String templetTaskId=Util.null2String(rs.getString("templetTaskId"));
                		 String parentTaskId=Util.null2String(rs.getString("parentTaskId"));
                		 String befTaskId=Util.null2String(rs.getString("befTaskId"));
                		 String sql="update prj_templatetask set templetTaskId='"+taskOrderMap.get(templetTaskId)+"',parentTaskId='"+taskOrderMap.get(parentTaskId)+"',befTaskId='"+taskOrderMap.get(befTaskId)+"' where id='"+id+"' and templetId='"+templetId+"' ";
                		 //System.out.println("sql:"+sql);
                		 rst.executeSql(sql);
                	 }
                	 rst.commit();
                	 
                 }catch(Exception e){
                	 rst.rollback();
                 }
                 //System.out.println("=======================split line2====================");
                 
                 //前置任务修正
            }
            
             
             
             
             
             
           //相关附件操作开始
             String newAccessory = "";
         	RecordSet.executeSql("SELECT accessory FROM Prj_Template WHERE id = " + templetId);
             if(RecordSet.next()){
         		String oldAccessory = Util.null2String(RecordSet.getString(1));
         	    newAccessory = oldAccessory;
         		//删除附件
         		if(deleteField_idnum>0){
         			for(int i=0;i<deleteField_idnum;i++){
         				String field_del_flag = Util.null2String(request.getParameter("field_del_"+i));				
         				if(field_del_flag.equals("1")){
         					String field_del_value = Util.null2String(request.getParameter("field_id_"+i));
         					RecordSet.executeSql("delete DocDetail where id = " + field_del_value);
         					if(newAccessory.indexOf(field_del_value)==0){
         						newAccessory = Util.StringReplace(newAccessory,field_del_value+",","");
         					}else{
         						newAccessory = Util.StringReplace(newAccessory,","+field_del_value,"");
         					}
         				}
         			}
         		}
         		
         	}
             
             if(!"".equals(accdocids)){
         	    RecordSet.executeSql("update Prj_Template set accessory ='"+newAccessory+accdocids+"' where id = "+templetId);    
         	    
         		//给项目里面的相关附件赋查看权限开始
         		
         		//给项目里面的相关附件赋查看权限结束
         		
         	}
             //相关附件操作结束
             
             
             
             
        } catch (Exception ex) {
        	//System.out.println(ex);
        }

        ArrayList rowIndexList = Util.arrayToArrayList(rowIndexs);
        rs.executeSql("select id,templetTaskId from Prj_TemplateTask where templetId="+templetId);
        while (rs.next()){
            String taskId = Util.null2String(rs.getString("id"));
            String templetTaskId = Util.null2String(rs.getString("templetTaskId"));           
            //如果从客户端传过来的数据中不存在此任务的ID则需删掉此任务
            if (rowIndexList.indexOf(templetTaskId)==-1){    
                rs1.executeSql("delete Prj_TemplateTask where id = "+taskId);
            }
        }
        %>
        <script type="text/javascript">
        parent.window.location.href="/proj/Templet/ProjTempletView.jsp?templetId=<%=templetId %>&isdialog=<%=isdialog %>&currenttab=<%=currenttab%>";
        </script>

        <%        
        //response.sendRedirect("ProjTempletView.jsp?templetId="+templetId);        
        return ;
    } else if("delete".equals(method)) {
       if (!"".equals(templetId)) {
             //删除模板本中的数据
             String strDelTemplet = "delete Prj_Template where id="+templetId;
             rs.executeSql(strDelTemplet);
            //删除除任务表中的数据
             String strDelTask = "delete Prj_TemplateTask where templetId="+templetId;
             rs.executeSql(strDelTask);
            //删除自定义表中的数据
             String strDelCdTemplet = "delete prj_fielddata where scope='ProjCustomField'  and id = "+templetId;
             rs.executeSql(strDelCdTemplet);
       }
       
    }else if("batchdelete".equals(method)) {
    	String ids = Util.null2String(request.getParameter("id"));
    	String[] arr= Util.TokenizerString2(ids, ",");
    	for(int i=0;i<arr.length;i++){
    		String id1 = ""+Util.getIntValue( arr[i]);
    		
    		if (!"".equals(id1)) {
                //删除模板本中的数据
                String strDelTemplet = "delete Prj_Template where id="+id1;
                rs.executeSql(strDelTemplet);
               //删除除任务表中的数据
                String strDelTask = "delete Prj_TemplateTask where templetId="+id1;
                rs.executeSql(strDelTask);
               //删除自定义表中的数据
                String strDelCdTemplet = "delete prj_fielddata where scope='ProjCustomField'  and id = "+id1;
                rs.executeSql(strDelCdTemplet);

          	}
    	
    	}
        
        
   }else if("select".equalsIgnoreCase(method) ){//指定模板
	   String strSql ="select 1 from Prj_Template where id="+templetId+" and isSelected=1";
	   rs.executeSql(strSql);
       if(rs.next()){
    	   strSql = "update Prj_Template set isSelected=0 where id = "+templetId;
    	   rs.executeSql(strSql);
       }else{
	   	   int proTypeId=Util.getIntValue(request.getParameter("proTypeId"),0);
    	   strSql = "update Prj_Template set isSelected=0 where proTypeId = "+proTypeId;
           rs.executeSql(strSql);
           strSql = "update Prj_Template set isSelected=1 where id = "+templetId;
           rs.executeSql(strSql);
       }
	   
   }
%>
<script type="text/javascript">
function onApprove(id){
	if(id){
		var url="/proj/Maint/ProjectTypeOperation.jsp?method=approvetemplate&templetId="+id+"&isdialog=1"; 
		var message="你确定要提交审批吗？";
		var message2="正在提交审批,请稍候...";
		if(window.top.Dialog.confirm(message,function(){
			//提示
			var diag_tooltip = new window.top.Dialog();
			diag_tooltip.ShowCloseButton=false;
			diag_tooltip.Width = 300;
			diag_tooltip.Height = 80;
			diag_tooltip.URL = "javascript:void(document.write(\'<span>"+message2+"</span>\'))";
			diag_tooltip.show();
			
			jQuery.ajax({
				url : url,
				type : "post",
				async : true,
				data : "",
				dataType : "html",
				success: function do4Success(msg){
					diag_tooltip.close();
					window.top.Dialog.alert("提交成功!");
					//window.location.reload();
					window.parent._table.reLoad();
				}
			});
		}));
	}
	
}
</script>