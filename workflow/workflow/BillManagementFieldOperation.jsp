
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />
<jsp:useBean id="WorkflowSubwfFieldManager" class="weaver.workflow.field.WorkflowSubwfFieldManager" scope="page" />

<%
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

    String displayname = Util.null2String(request.getParameter("displayname"));//显示名
    String linkaddress = Util.null2String(request.getParameter("linkaddress"));//链接地址
    String descriptivetext = Util.null2String(request.getParameter("descriptivetext"));//描述性文字
    descriptivetext = Util.spacetoHtml(descriptivetext);
	String actionType = Util.null2String(request.getParameter("actionType")) ;
	String fieldIds = Util.null2String(request.getParameter("fieldIds")) ;
	int billId = Util.getIntValue(request.getParameter("billId"),0) ;
	int childfieldid = Util.getIntValue(request.getParameter("childfieldid"),0);
    int textheight=Util.getIntValue(request.getParameter("textheight"),0);//xwj for @td2977 20051107
    String textheight_2 = ""; //分权 级别 
    int imgwidth = Util.getIntValue(request.getParameter("imgwidth"),0);
    int imgheight = Util.getIntValue(request.getParameter("imgheight"),0);
	String sql = "" ;
	String tableName = "" ;
	String fieldName = "" ;
	int fieldId = 0;
	boolean isSqlServer=false;
	boolean isOracle=false;
	boolean isDB2=false;
	if("sqlserver".equals(RecordSet.getDBType()))
		 isSqlServer=true;
	else if("oracle".equals(RecordSet.getDBType()))
		 	isOracle=true;
		 else if("db2".equals(RecordSet.getDBType()))
		 	isDB2=true;
	
	//获得表名
	sql = "select tablename from  workflow_bill where id = " + billId ;	
	RecordSet.execute(sql) ;
	if(RecordSet.next()){
		tableName = RecordSet.getString("tablename" ) ;		
	}
	
	if(actionType.equals("add")){		
		int htmltype=Util.getIntValue(request.getParameter("htmltype"),0);
	    int strlength=Util.getIntValue(request.getParameter("strlength"),0);
	    String fieldhtmltype=Util.null2String(request.getParameter("fieldhtmltype"));
	    String fieldViewName=Util.null2String(request.getParameter("fieldname"));
		int htmledit=Util.getIntValue(request.getParameter("htmledit"),0);
	    fieldViewName=fieldViewName.trim();
	    float orderNum=Util.getFloatValue(request.getParameter("orderNum"),0);
	    int fieldLabelId = 0;
	    boolean addSuccess = true ; 
	    String fieldDBType = "" ;
	    String fieldDBType1 = "";
	    fieldViewName = Util.StringReplace(fieldViewName, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
	    fieldViewName = Util.StringReplace(fieldViewName, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
	    //获取字段显示名的标签id
	    if(isSqlServer) RecordSet.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldViewName+"' collate Chinese_PRC_CS_AI and languageid="+Util.getIntValue(""+user.getLanguage(),7));
		  else RecordSet.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldViewName+"' and languageid="+Util.getIntValue(""+user.getLanguage(),7));
	    //sql="select id from HtmlLabelInfo where indexdesc='"+fieldViewName+"'";
	    //RecordSet.execute(sql);
	    if(RecordSet.next()){
		    fieldLabelId = Util.getIntValue(RecordSet.getString("indexid"),0);
	    }else{
	    	sql="select min(id) id from HtmlLabelIndex";
		    RecordSet.execute(sql);
		    if(RecordSet.next())
		    	fieldLabelId = Util.getIntValue(RecordSet.getString("id"),0);	
		    if(fieldLabelId>0) 
		    	fieldLabelId = -1;	
		    fieldLabelId-=1;		    	
		    sql="INSERT INTO HtmlLabelIndex values("+fieldLabelId+",'"+fieldViewName+"')"; 
		    RecordSet.execute(sql);
			sql="INSERT INTO HtmlLabelInfo VALUES("+fieldLabelId+",'"+fieldViewName+"',7)";
			RecordSet.execute(sql);		
			LabelComInfo.addLabeInfoCache(String.valueOf(fieldLabelId));
		}
	    
	    //随机产生字段名
	    fieldName = "field_" + Util.getNumberRandom();
	    
	    //增加字段
	    
    	switch (Integer.parseInt(fieldhtmltype)){
        case 1:  //单行文本框
        	switch (htmltype){
        	case 1:  //文本
            	if(isSqlServer) fieldDBType = "varchar("+strlength+")";
            	if(isOracle) fieldDBType = "varchar2("+strlength+")";
            	if(isDB2) fieldDBType = "varchar("+strlength+")";
            	break;  
            case 2:  //整数
            	if(isSqlServer) fieldDBType = "int";
            	if(isOracle) fieldDBType = "integer";
            	if(isDB2) fieldDBType = "integer";
            	break;  
            case 3:  //浮点数
            	if(isSqlServer) fieldDBType= "decimal(15,3)";
            	if(isOracle) fieldDBType = "number(15,3)";
            	if(isDB2) fieldDBType= "decimal(15,3)";
            	break;  
            case 5:  //金额千分位
            	if(isSqlServer) fieldDBType= "varchar(30)";
            	if(isOracle) fieldDBType = "varchar2(30)";
            	if(isDB2) fieldDBType= "varchar(30)";
            	break;
            default:    
            	break;   
            }
            break;  
        case 2:  //多行文本框
            //if(isSqlServer) fieldDBType = "text"; 
            //if(isOracle) fieldDBType = "varchar2(3000)";
            //if(isDB2) fieldDBType = "varchar(3000)";
            if(textheight<1) textheight=4;
			if (htmledit!=0) htmltype=htmledit;
			if(isOracle) {
				if(htmledit!=0 && htmledit!=1) {
					fieldDBType="clob";
				} else {
					fieldDBType="varchar2(4000)";
				}
			} else if(isDB2) {
				fieldDBType="varchar(3000)";
			} else {
				fieldDBType="text";
			}
            break; 
        case 3:  //浏览按钮
        	sql = " select fielddbtype from workflow_browserurl where id = " + htmltype ;
        	RecordSet.execute(sql);
        	if(RecordSet.next()){
	            fieldDBType = RecordSet.getString("fielddbtype"); 
	            fieldDBType = fieldDBType.trim() ;
	            fieldDBType = fieldDBType.toLowerCase();
		        if(isOracle) {
		        	if(fieldDBType.indexOf("int")!=-1) fieldDBType = "integer";
		        	if(fieldDBType.indexOf("text")!=-1) fieldDBType = "varchar2(3000)";
		        	if(fieldDBType.indexOf("varchar")!=-1) fieldDBType = "varchar2" + fieldDBType.substring(fieldDBType.indexOf("("));
		        	if("".equals(fieldDBType)) fieldDBType = "varchar2(200)";
		        }
		        if(isDB2) {
		        	if(fieldDBType.indexOf("int")!=-1) fieldDBType = "integer";
		        	if(fieldDBType.indexOf("text")!=-1) fieldDBType = "varchar(3000)";
		        	if("".equals(fieldDBType)) fieldDBType = "varchar(200)";
		        }
		        if(htmltype==165 || htmltype==166 || htmltype==167 || htmltype==168){
			    	textheight_2 = Util.null2String(request.getParameter("decentralizationbroswerType"));
			    }

		        if(isSqlServer&&"".equals(fieldDBType)) fieldDBType = "varchar(200)";
	        }
	        //TD15999
	        String cusb = Util.null2String(request.getParameter("cusb"));
			if(htmltype==161 || htmltype==162) {
				fieldDBType1=cusb;
	            if(isSqlServer) fieldDBType = "text"; 
	            if(isOracle) fieldDBType = "varchar2(3000)";
	            if(isDB2) fieldDBType = "varchar(3000)";
			}
            break; 
        case 4:  //Check框
            fieldDBType = "char(1)";
            break; 
        case 5:  //选择框
            if(isSqlServer) fieldDBType = "int";
            if(isOracle) fieldDBType = "integer";
            if(isDB2) fieldDBType = "integer";
            break; 
        case 6:  //附件上传
            if(isSqlServer) fieldDBType = "text"; 
            if(isOracle) fieldDBType = "varchar2(3000)";
            if(isDB2) fieldDBType = "varchar(3000)";
            break; 
        case 7:  //附件上传
            if(isSqlServer) fieldDBType = "text"; 
            if(isOracle) fieldDBType = "varchar2(3000)";
            if(isDB2) fieldDBType = "varchar(3000)";

            break;
        default:    
            break;   
        } 
        if("".equals(fieldDBType)) 
        	addSuccess=false;
		else {
			sql = "alter table " + tableName + " ADD " + fieldName + " " + fieldDBType;
			addSuccess=RecordSet.execute(sql);
		}
		//td15999
	    if(!"".equals(fieldDBType1)) fieldDBType = fieldDBType1;
	    
	    if(addSuccess){
			sql="INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,fromUser,textheight,textheight_2,childfieldid,imgwidth,imgheight,detailtable) VALUES ("+billId+",'"+fieldName+"',"+fieldLabelId+",'"+fieldDBType+"',"+fieldhtmltype+","+htmltype+","+orderNum+",0,'0',"+textheight+",'"+textheight_2+"',"+childfieldid+","+imgwidth+","+imgheight+",'')";;
			addSuccess=RecordSet.execute(sql);				
		}
		
		String wfid = "-1";//xwj for td3399 20060303
		ArrayList arr = new ArrayList();
		if(addSuccess){
			sql="select id from workflow_billfield where billid = " + billId + " and fieldname='" + fieldName + "'" ;
			RecordSet.execute(sql);	
			if(RecordSet.next()){//xwj for td3399 20060303
				fieldId = Util.getIntValue(RecordSet.getString("id"),0);
					RecordSet1.executeSql("select id from workflow_base where formid = " + billId + " and isbill = 1");
					while(RecordSet1.next()){
					  wfid = wfid + "," + Util.null2String(RecordSet1.getString("id"));
					}
					if(!wfid.equals("")){
					RecordSet1.executeSql("select nodeid from workflow_flownode where workflowid in (" + wfid + ")");
					while(RecordSet1.next()){
					   arr.add(RecordSet1.getString("nodeid"));
					}
					for(int h=0; h < arr.size(); h++){
					RecordSet1.executeSql("insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory,orderid) values("+(String)arr.get(h)+","+fieldId+",'1','1','0',"+ orderNum + ")");
				  }
					}
				
				}
		}
		//操作workflow_selectitem表
		if(fieldhtmltype.equals("5")){
			int i=0;
			int curvalue=0;
			int rowsum = Util.getIntValue(Util.null2String(request.getParameter("selectsnum")));
			char flag=2;
			String curname="";
			for(i=0;i<rowsum;i++){	
				curname=Util.fromScreen(request.getParameter("field_"+i+"_name"),user.getLanguage());				
					String	cancel=Util.fromScreen(request.getParameter("cancel_"+i),user.getLanguage());
				if(cancel!=null && !cancel.equals("") && cancel.equals("1")){
					cancel = "1";
				}else{
					cancel = "0";
				}
				if(!curname.equals("")){
						String para=""+fieldId+flag+"1"+flag+""+curvalue+flag+curname+flag+0+flag+"n"+flag+cancel;//xwj for td3399 20060303
					RecordSet.executeProc("workflow_selectitem_insert_new",para);
				String childItem = Util.null2String(request.getParameter("childItem"+i));
						rs.execute("update workflow_selectitem set childitemid='"+childItem+"',cancel='"+cancel+"' where fieldid="+fieldId+" and isbill=1 and selectvalue="+curvalue); 
					curvalue++;
				}
			}
	    }
		//操作workflow_specialfield表
		if(fieldhtmltype.equals("7")){
	      if(htmltype==1){
	         sql = "insert into workflow_specialfield(fieldid,displayname,linkaddress,isform,isbill) values("+fieldId+",'"+displayname+"','"+linkaddress+"',0,1)";    
	      }else{
	         sql = "insert into workflow_specialfield(fieldid,descriptivetext,isform,isbill) values("+fieldId+",'"+descriptivetext+"',0,1)";    
	      }
		  RecordSet.executeSql(sql);
	    }
		//该段代码不会执行，现屏蔽 TD9786
	    //if(addSuccess){%>	    
	    	<script language="javascript">
	    		//alert("字段添加成功!");
	    	</script>
	    <%//}else{%>
		    <script language="javascript">
		    	//alert("字段添加失败!");
		    </script>
	    <%//}

	    response.sendRedirect("/workflow/workflow/BillManagementDetail.jsp?billId=" + billId) ;
		return;	  
	}else if(actionType.equals("edit")){//TD 9786 chujun
		fieldId = Util.getIntValue(request.getParameter("fieldid"), 0);
		int htmltype=Util.getIntValue(request.getParameter("htmltype"),0);
	    int strlength=Util.getIntValue(request.getParameter("strlength"),0);
	    String fieldhtmltype=Util.null2String(request.getParameter("fieldhtmltype"));
	    String fieldViewName=Util.null2String(request.getParameter("fieldname"));
		int htmledit=Util.getIntValue(request.getParameter("htmledit"),0);
	    fieldViewName=fieldViewName.trim();
	    float orderNum = Util.getFloatValue(request.getParameter("orderNum"),0);
	    int fieldLabelId = 0;
	    boolean addSuccess = true ; 
	    String fieldDBType = "" ;
	    fieldViewName = Util.StringReplace(fieldViewName, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
	    fieldViewName = Util.StringReplace(fieldViewName, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
	    //获取字段显示名的标签id
	    sql="select id from HtmlLabelIndex where indexdesc='"+fieldViewName+"'";
	    RecordSet.execute(sql);
	    if(RecordSet.next()){
		    fieldLabelId = Util.getIntValue(RecordSet.getString("id"),0);
	    }else{
	    	sql="select min(id) id from HtmlLabelIndex";
		    RecordSet.execute(sql);
		    if(RecordSet.next())
		    	fieldLabelId = Util.getIntValue(RecordSet.getString("id"),0);	
		    if(fieldLabelId>0) 
		    	fieldLabelId = -1;	
		    fieldLabelId-=1;		    	
		    sql="INSERT INTO HtmlLabelIndex values("+fieldLabelId+",'"+fieldViewName+"')"; 
		    RecordSet.execute(sql);
			sql="INSERT INTO HtmlLabelInfo VALUES("+fieldLabelId+",'"+fieldViewName+"',7)";
			RecordSet.execute(sql);		
			LabelComInfo.addLabeInfoCache(String.valueOf(fieldLabelId));
		}
        if(fieldhtmltype.equals("2")){
            if(textheight<1) textheight=4;
        }
        if("3".equals(fieldhtmltype) && (htmltype==165 || htmltype==166 || htmltype==167 || htmltype==168)){
        	textheight_2 = Util.null2String(request.getParameter("decentralizationbroswerType"));
        }
	    //修改显示名称和顺序
	    if(addSuccess){
			sql="update workflow_billfield set fieldlabel="+fieldLabelId+", dsporder="+orderNum+",childfieldid="+childfieldid+",textheight="+textheight+",textheight_2='"+textheight_2+"',imgwidth="+imgwidth+",imgheight="+imgheight+" where id="+fieldId;
			addSuccess = RecordSet.execute(sql);				
		}
		
		//操作workflow_selectitem表
		if(fieldhtmltype.equals("5")){
			sql = "delete from workflow_SelectItem where fieldid="+fieldId;
			RecordSet.execute(sql);
			int i=0;
			int curvalue=0;
			int rowsum = Util.getIntValue(Util.null2String(request.getParameter("selectsnum")));
			char flag=2;
			String curname="";
			for(i=0;i<rowsum;i++){	
				curname=Util.fromScreen(request.getParameter("field_"+i+"_name"),user.getLanguage());				
				if(!curname.equals("")){
						String	cancel=Util.fromScreen(request.getParameter("cancel_"+i),user.getLanguage());
					if(cancel!=null && !cancel.equals("") && cancel.equals("1")){
						cancel = "1";
					}else{
						cancel = "0";
					}
					String para=""+fieldId+flag+"1"+flag+""+curvalue+flag+curname+flag+0+flag+"n"+flag+cancel;//xwj for td3399 20060303
					RecordSet.executeProc("workflow_selectitem_insert_new",para);
					String childItem = Util.null2String(request.getParameter("childItem"+i));
					rs.execute("update workflow_selectitem set childitemid='"+childItem+"',cancel='"+cancel+"' where fieldid="+fieldId+" and isbill=1 and selectvalue="+curvalue);
					curvalue++;
				}
			}
	    }
		//操作workflow_specialfield表
		if(fieldhtmltype.equals("7")){
			if(htmltype==1){
				//sql = "insert into workflow_specialfield(fieldid,displayname,linkaddress,isform,isbill) values("+fieldId+",'"+displayname+"','"+linkaddress+"',0,1)";
				sql = "update workflow_specialfield set displayname='"+displayname+"', linkaddress='"+linkaddress+"', isform=0, isbill=1, descriptivetext='' where fieldid="+fieldId;
			}else{
				//sql = "insert into workflow_specialfield(fieldid,descriptivetext,isform,isbill) values("+fieldId+",'"+descriptivetext+"',0,1)";
				sql = "update workflow_specialfield set displayname='', linkaddress='', isform=0, isbill=1, descriptivetext='"+descriptivetext+"' where fieldid="+fieldId;
			}
			RecordSet.executeSql(sql);
	    }
	    response.sendRedirect("/workflow/workflow/BillManagementDetail.jsp?billId=" + billId) ;
		return;	  
	}
	else if(actionType.equals("delete")){
		
		ArrayList idS = Util.TokenizerString(fieldIds,",");			
		boolean delSuccess = true ; 	
		int fieldHtmlType = 0 ;
		String nodeLinkIdS = "";
		//出口条件检测
		for(int i=0;i<idS.size();i++){
			fieldId = Integer.parseInt((String)idS.get(i));			
			//获得字段名
			sql = "select fieldname from  workflow_billfield where id = " + fieldId ;	
			RecordSet.execute(sql) ;
			if(RecordSet.next()){
				fieldName = RecordSet.getString("fieldname") ;	
			}
			sql="select t1.id from workflow_nodelink t1, workflow_base t2 where t1.wfrequestid is null and t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + billId + " and t1.condition like '%"+fieldName+"%'";
			RecordSet.execute(sql);
			while(RecordSet.next()){
				nodeLinkIdS += RecordSet.getString("id") + "," ;
			}
		}
		if(!nodeLinkIdS.equals("")){
			nodeLinkIdS = nodeLinkIdS.substring(0,nodeLinkIdS.lastIndexOf(","));
			response.sendRedirect("/workflow/workflow/BillManagementFieldDelCheck.jsp?actionType="+actionType+"&billId=" + billId+"&fieldIds="+fieldIds) ;
			return;		
		}else{

			//出口条件检测通过开始删除
			for(int i=0;i<idS.size();i++){
				fieldId = Integer.parseInt((String)idS.get(i));

		        if(WorkflowSubwfFieldManager.hasSubWfSettingForBill(fieldId,1)){
					response.sendRedirect("/workflow/workflow/BillManagementDetail.jsp?billId="+ billId+"&errorcode=2") ;
		            return;
		        }				

				//获得字段名
				sql = "select fieldname , fieldhtmltype from  workflow_billfield where id = " + fieldId ;	
				RecordSet.execute(sql) ;
				if(RecordSet.next()){
					fieldName = RecordSet.getString("fieldname") ;	
					fieldHtmlType = Util.getIntValue(RecordSet.getString("fieldhtmltype"),0) ;	
				}
				
				
				//删除节点附加操作
				
				if(delSuccess){
					sql = "delete from  workflow_addinoperate where isnode=1 and objid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + billId + ") and (fieldid =" + fieldId + " or fieldop1id = " + fieldId + " or fieldop2id = " + fieldId + ")" ;
					delSuccess = RecordSet.execute(sql) ;
				}
				
				//删除出口附加操作
				
				if(delSuccess){
					sql = "delete from  workflow_addinoperate where isnode=0 and objid in (select t1.id from  workflow_nodelink t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + billId + ") and (fieldid =" + fieldId + " or fieldop1id = " + fieldId + " or fieldop2id = " + fieldId + ")" ;
					delSuccess = RecordSet.execute(sql) ;
				}
						
	
				
				//删除由自定义字段产生的操作人，主要是由浏览框带来的
				/*
				*5：人力资源字段本人
				*6：人力资源字段经理 
				*31：人力资源字段下属 
				*32：人力资源字段本分部+ 安全级别
				*7：人力资源字段本部门 + 安全级别
				*38：人力资源字段上级部门+ 安全级别	
				*42：部门
				*43：角色
				*8：文档字段所有者，选择的文档字段对应值所代表的文档的所有者
				*33：文档字段分部+ 安全级别
				*9：文档字段部门+ 安全级别
				*10：项目字段经理，选择的项目字段对应值所代表的项目的经理
				*47：项目字段经理的经理
				*34：项目字段分部+ 安全级别
				*11：项目字段部门+ 安全级别
				*12：项目字段成员+ 安全级别
				*13：资产字段管理员
				*35：资产字段分部+ 安全级别
				*14：资产字段部门+ 安全级别
				*15：客户字段经理 ，选择的客户字段对应值所代表的客户的经理
				*44：客户字段经理的经理
				*45：客户字段分部
				*46：客户字段部门
				*16：客户字段联系人经理 	
				*/
				if(delSuccess){
					sql = "delete from  workflow_groupdetail where type in(5,6,31,32,7,38,42,43,8,33,9,10,47,34,11,12,13,35,14,15,44,45,46,16) and groupid in(select id from workflow_nodegroup where nodeid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + billId + ")) and objid=" + fieldId;
					delSuccess = RecordSet.execute(sql) ;	
				}
				
				//删除节点上哪些字段可视、可编辑、必输的信息
				if(delSuccess){
					sql = "delete from  workflow_nodeform where nodeid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + billId + ") and fieldid= " + fieldId ;	
					delSuccess = RecordSet.execute(sql) ;	
				}
				
				//删除字段类型为选择框的所有选择项信息
				if(delSuccess && (fieldHtmlType==5)){
					sql = "delete from  workflow_selectitem where isbill=1 and fieldid =" + fieldId ;
					delSuccess = RecordSet.execute(sql) ;
					//可能是子字段，删除作为子字段信息
					sql = "update workflow_billfield set childfieldid=0 where childfieldid="+fieldId;
					rs.execute(sql);
				}

				//删除特殊字段的信息
				if(delSuccess && (fieldHtmlType==7)){
					sql = "delete from workflow_specialfield where isbill=1 and fieldid =" + fieldId ;
					delSuccess = RecordSet.execute(sql) ;
				}
				
				//删除记录单据字段信息
				if(delSuccess){
					sql = "delete from  workflow_billfield where id = " + fieldId ;		
					delSuccess = RecordSet.execute(sql) ;
				}
				
				//真正删除表字段
				if(delSuccess&&!isDB2){
					sql = "ALTER TABLE " + tableName + " DROP COLUMN " + fieldName ;
					delSuccess = RecordSet.execute(sql);
				}
			}
		}
		if(delSuccess){%>	    
	    	<script language="javascript">
	    		alert("<%=SystemEnv.getHtmlLabelName(129429, user.getLanguage())%>");
	    	</script>
	    <%}else{%>
		    <script language="javascript">
		    	alert("<%=SystemEnv.getHtmlLabelName(129430, user.getLanguage())%>");
		    </script>
	    <%}	
		response.sendRedirect("/workflow/workflow/BillManagementDetail.jsp?billId=" + billId) ;
		return;		
	}


%>


	
