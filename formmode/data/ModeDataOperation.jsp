
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.formmode.setup.CodeBuild"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="weaver.formmode.task.TaskService"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ModeDataManager" class="weaver.formmode.data.ModeDataManager" scope="page"/>
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page"/>
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ModeViewLog" class="weaver.formmode.view.ModeViewLog" scope="page"/>


<%
FileUpload fu = new FileUpload(request);
String src = Util.null2String(fu.getParameter("src"));
String isopenbyself = Util.null2String(fu.getParameter("isopenbyself"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
String isDialog = Util.null2String(fu.getParameter("isDialog"));
int templateid = Util.getIntValue(fu.getParameter("templateid"),0);
int mainid = Util.getIntValue(fu.getParameter("mainid"),0);
String method = Util.fromScreen(fu.getParameter("method"),user.getLanguage()); // 作为新建文档时候的参数传递
String isMultiDoc = Util.null2String(fu.getParameter("isMultiDoc")); //多文档新建
String lastnodeid =  Util.null2String(fu.getParameter("lastnodeid")); //编辑时获得数的上一次节点
int type = Util.getIntValue(fu.getParameter("type"),0);//0：查看；1：创建；2：编辑；3：监控
int layoutid = Util.getIntValue(fu.getParameter("currentLayoutId"),0);//布局ID
int formmodeid = Util.getIntValue(fu.getParameter("formmodeid"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = 1;
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
String v_billid = Util.null2String(fu.getParameter("billid"));
String operationReplyData = Util.null2String(fu.getParameter("operationReplyData"));
boolean isRight = false;
if(type==1){
	ModeRightInfo.setModeId(formmodeid);
	ModeRightInfo.setType(type);
	ModeRightInfo.setUser(user);
	isRight = ModeRightInfo.checkUserRight(type);
	if(!isRight){
		out.print("<script>wfforward('/notice/noright.jsp');</script>");
	    return ;
	}
}
if( src.equals("") || formid == -1 || isbill == -1 || formmodeid == -1) {
	out.print("<script>wfforward('/notice/noright.jsp');</script>");
    return ;
}
//是否来自导入明细保存
int fromImportDetail = Util.getIntValue(fu.getParameter("fromImportDetail"),0);
int pageexpandid = Util.getIntValue(fu.getParameter("pageexpandid"),0);

String viewfrom = Util.null2String(fu.getParameter("viewfrom"));
int opentype = Util.getIntValue(fu.getParameter("opentype"),0);
int customid = Util.getIntValue(fu.getParameter("customid"),0);
//是否保存并新建
int subnew=Util.getIntValue(fu.getParameter("subnew"),0);
int isfromTab = Util.getIntValue(fu.getParameter("isfromTab"),0);
int tabid = Util.getIntValue(fu.getParameter("tabid"),0);
int istabinline = Util.getIntValue(fu.getParameter("istabinline"),0);
int tabcount = Util.getIntValue(fu.getParameter("tabcount"),0);
String treesupvalue = Util.null2String(fu.getParameter("customTreeDataId"),"");

if(isbill == 1 && VirtualFormHandler.isVirtualForm(formid)){
	Map<String, Object> paramMap = new HashMap<String, Object>();
	paramMap.put("src", src);
	paramMap.put("iscreate", iscreate);
	paramMap.put("formid", formid);
	paramMap.put("isbill", isbill);
	paramMap.put("billid", v_billid);
	paramMap.put("formmodeid", formmodeid);
	paramMap.put("pageexpandid", pageexpandid);
	paramMap.put("fu", fu);
	paramMap.put("user", user);
	Object id = Util.null2String(VirtualFormHandler.handlerSave(paramMap));
	
  //-----------提醒功能-----------
    TaskService taskService = new TaskService();
    taskService.setModeid(formmodeid);
    taskService.setBillid( Util.getIntValue(Util.null2String(id)));
    if(!(src.equals("del"))){
        taskService.setAction("create");
        Thread task = new Thread(taskService);
        task.start();
    }
	if(src.equals("del")){
	    
		%>
		<script language="javascript">
			if("<%=viewfrom%>"=="fromsearchlist"&"<%=opentype%>"=="1"){
				window.parent.parent.location = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=customid%>";
			}else{
				try{
					parent.parent.window.opener._table.reLoad();	
				}catch(e){
					


				}
				window.parent.parent.close();
			}
		</script>
		<%
	}else{
		%>
		<script language="javascript">
			try{
				if(parent && parent.window.opener && parent.window.opener._table){
					parent.window.opener._table.reLoad();	
				}
				if(parent && parent.parent && parent.parent.window.opener && parent.parent.window.opener._table){
					parent.parent.window.opener._table.reLoad();
				}
			}catch(e){
				
			}
			<%if(subnew==1){%>
			window.location.href="/formmode/view/AddFormModeIframe.jsp?modeId=<%=formmodeid%>&formId=<%=formid%>&type=1&istabinline=<%=istabinline%>&tabcount=<%=tabcount%>";
			<%}else{%>
			var url="/formmode/view/AddFormMode.jsp?isfromTab=0&modeId=<%=formmodeid%>&formId=<%=formid%>&type=0&billid=<%=id%>&viewfrom=<%=viewfrom%>&opentype=<%=opentype%>&customid=<%=customid%>&isopenbyself=<%=isopenbyself%>&istabinline=<%=istabinline%>&tabcount=<%=tabcount%>&tabid=<%=tabid%>";
			var isfromTab="<%=isfromTab%>";
			if(isfromTab==1){
				window.parent.parent.location.href=url;
			}else{
				window.parent.location.href=url;
			}
			<%}%>
		</script>
		<%return;}
}
int operateuserid = user.getUID();
String accounttype =  user.getAccount_type();//当前账号类型：0：主账号   1：次账号
List<User> lsUser = ModeRightInfo.getAllUserCountList(user);
boolean isEdit = false;		//是否有编辑权限，主要针对右键按钮是否显示
boolean isDel = false;		//是否有删除权限，主要针对右键按钮是否显示
if(accounttype.equals("0")&&lsUser.size()>1){//主账号
	if(billid > 0 && iscreate.equals("1")){//新建不需要处理
		
	}else if(billid > 0){
		ModeShareManager.setModeId(formmodeid);
		for(int i=0;i<lsUser.size();i++){
			User tempUser = lsUser.get(i);
			String rightStr = ModeShareManager.getShareDetailTableByUser("formmode",tempUser);
			rs.executeSql("select sourceid,max(sharelevel) as sharelevel from "+rightStr+" t where sourceid="+billid+" group by sourceid");
			if(rs.next()){
				int MaxShare = rs.getInt("sharelevel");
				if(MaxShare > 1) {
					isEdit = true;		//有编辑或完全控制权限的出现编辑按钮
					if(MaxShare == 3) isDel = true;		//有完全控制权限的出现删除按钮
				}
			}
			if(src.equals("del")){//删除
				if(isDel==true){
					operateuserid = tempUser.getUID();
					break;
				}
			}else{//编辑
				if(isEdit){
					operateuserid = tempUser.getUID();
					break;
				}
			}
		}
	}
}

FormInfoService formInfoService = new FormInfoService();
List<Map<String, Object>> needlogFieldList = formInfoService.getNeedlogField(formid);
String columnNames = "";
String tableName = "";
if(needlogFieldList.size() > 0){
	for(int i = 0; i < needlogFieldList.size(); i++){
		Map<String, Object> needlogField = needlogFieldList.get(i);
		String fieldname = Util.null2String(needlogField.get("fieldname"));
		columnNames += fieldname;
		if(i != (needlogFieldList.size() - 1)){
			columnNames += ",";
		}
	}
	rs.executeSql("select tablename from workflow_bill where id = " + formid); 
	if (rs.next()){
		tableName = rs.getString("tablename");  
	}
}
Map<String, Object> oldData = new HashMap<String, Object>();
if(needlogFieldList.size() > 0){
	oldData = formInfoService.getTableData(tableName, billid, columnNames);
}

ModeDataManager.setIsMultiDoc(isMultiDoc);
ModeDataManager.setSrc(src);
ModeDataManager.setIscreate(iscreate);
ModeDataManager.setFormid(formid);
ModeDataManager.setIsbill(isbill);
ModeDataManager.setBillid(billid);
ModeDataManager.setFormmodeid(formmodeid);
ModeDataManager.setPageexpandid(pageexpandid);
ModeDataManager.setRequest(fu);
ModeDataManager.setUser(user);
ModeDataManager.setType(type);
ModeDataManager.setLayoutid(layoutid);
if(src.equals("del") && billid > 0){
	//--------------删除文档权限------------------------
	ModeRightInfo.delDocShare(formmodeid,billid);
}
boolean savestatus = ModeDataManager.saveModeData();
billid = ModeDataManager.getBillid();

Map<String, Object> nowData = new HashMap<String, Object>();
if(needlogFieldList.size() > 0){
	nowData = formInfoService.getTableData(tableName, billid, columnNames);
}



//获得树新的父节点id
String tempfield ="";
String tempfield2 ="";
String newsupvalue = "";
String supnode = "";
String treeid = "";
RecordSet2.executeSql("select * from mode_customtreedetail where sourceid="+formmodeid+" and mainid="+mainid);
if(RecordSet2.next()){	
	  treeid = RecordSet2.getString("id");
	  supnode = Util.null2String(RecordSet2.getString("supnode"),"");
	  tempfield2 = Util.null2String(RecordSet2.getString("nodefield"),"");
      tempfield = Util.null2String(RecordSet2.getString("tablesup"),"");
}
String tempSql = "select * from workflow_bill where id="+formid;
RecordSet2.executeSql(tempSql);
String tablename2 = "";
if(RecordSet2.next()){
	  tablename2 = RecordSet2.getString("tablename");
	  RecordSet2.executeSql("select * from "+tablename2+" where id="+billid);
	  if(RecordSet2.next()){			
		  if(!supnode.equals("")){
			  if(!tempfield2.equals("")){
				  String svalue = RecordSet2.getString(tempfield2);
				  if(!svalue.equals("")){
					  newsupvalue = supnode+"_"+svalue;
				  }
			  }
		  }
		  if(newsupvalue.equals("")){
			  if(!tempfield.equals("")){
				  String svalue = RecordSet2.getString(tempfield);
				  if(!svalue.equals("")){
					  newsupvalue = treeid+"_"+svalue;
				  }
			  }
		  }
	  }
} 

if(billid > 0 && iscreate.equals("1")){
	CodeBuild cbuild = new CodeBuild(formmodeid);
	cbuild.setLanguage(user.getLanguage());
	String codeStr = cbuild.getModeCodeStr(formid,billid);//生成编号
	ModeRightInfo.setNewRight(true);
	ModeRightInfo.editModeDataShare(ModeDataManager.getCreater(),formmodeid,billid);//新建的时候添加共享
}else if(billid > 0 && !src.equals("del")){
	ModeRightInfo.rebuildModeDataShareByEdit(ModeDataManager.getCreater(),formmodeid,billid);//编辑时从新生成默认共享
%>
    <script type="text/javascript">  
         if(window.parent.frames['leftframe']){
             window.parent.frames['leftframe'].refreshTree("<%=treesupvalue%>","<%=lastnodeid%>","<%=newsupvalue%>");
         }else if(window.parent.parent.frames['leftframe']){
             window.parent.parent.frames['leftframe'].refreshTree("<%=treesupvalue%>","<%=lastnodeid%>","<%=newsupvalue%>");
         }
    </script>
<%
	//编辑的时候，修改建模主字段权限
	//ModeRightInfo.editModeDataShareForModeField(ModeDataManager.getCreater(),formmodeid,billid);//新建的时候添加共享
	//添加角色受模块字段限制时的权限
	//ModeRightInfo.editModeDataShareForRoleAndField(ModeDataManager.getCreater(),formmodeid,billid);//角色受模块字段限制修改
}

//创建文档，先保存数据，不执行接口	
if("".equals(method)){
	//数据保存成功，执行接口
	if(savestatus&&!src.equals("del")){
		ModeDataManager.changeDocFiled(formmodeid, billid, tablename2);
		//--------------给文档赋权------------------------
		ModeRightInfo.addDocShare(ModeDataManager.getCreater(),formmodeid,billid);
		ModeDataManager.doInterface(pageexpandid);
	}
}
//保存操作日志
String operatetype = "2";//操作的类型： 1：新建 2：修改 3：删除 4：查看
String clientaddress = request.getRemoteAddr();
String operatedesc = SystemEnv.getHtmlLabelName(33797,user.getLanguage());//修改
int relatedid = billid;
String relatedname = "";
if(billid > 0 && iscreate.equals("1")){
	operatetype = "1";
	operatedesc = SystemEnv.getHtmlLabelName(365,user.getLanguage());//新建 
}
if(src.equals("del")){
	operatetype = "3";
	operatedesc = SystemEnv.getHtmlLabelName(23777,user.getLanguage());//删除
}

ModeViewLog.resetParameter();
ModeViewLog.setClientaddress(clientaddress);
ModeViewLog.setModeid(formmodeid);
ModeViewLog.setOperatedesc(operatedesc);
ModeViewLog.setOperatetype(operatetype);
ModeViewLog.setOperateuserid(operateuserid);
ModeViewLog.setRelatedid(relatedid);
ModeViewLog.setRelatedname(relatedname);
int viewlogid = ModeViewLog.setSysLogInfo();

if(needlogFieldList.size() > 0){
	for(int i = 0; i < needlogFieldList.size(); i++){
		Map<String, Object> needlogField = needlogFieldList.get(i);
		String fieldid = Util.null2String(needlogField.get("id"));
		String fieldname = Util.null2String(needlogField.get("fieldname"));
		String oldFieldValue = Util.null2String(oldData.get(fieldname));
		String nowFieldValue = Util.null2String(nowData.get(fieldname));
		if(!oldFieldValue.equals(nowFieldValue)){
			Map<String, Object> logDetailMap = new HashMap<String,	Object>();
			logDetailMap.put("viewlogid", viewlogid);
			logDetailMap.put("fieldid", fieldid);
			logDetailMap.put("fieldvalue", nowFieldValue);
			logDetailMap.put("prefieldvalue", oldFieldValue);
			logDetailMap.put("modeid", formmodeid);
			formInfoService.saveFieldLogDetail(logDetailMap);
		}
	}
}

String messageid = ModeDataManager.getMessageid();//保存出错的错误信息id
String messagecontent = ModeDataManager.getMessagecontent();//保存出错的错误信息内容
session.setAttribute(formmodeid+"_"+billid+"_"+messageid,messagecontent);
//返回到模块页面，返回到查看页面或者列表页面，或者继续新建，或者编辑页面，或者关闭
if(fromImportDetail == 1){//是否来自导入明细保存
	response.sendRedirect("/formmode/view/AddFormModeIframe.jsp?isfromTab="+isfromTab+"&modeId="+formmodeid+"&formId="+formid+"&type=2&billid="+billid+"&fromSave=1&istabinline="+istabinline+"&tabcount="+tabcount);
}else if(src.equals("del")){
%>
<script language="javascript">
	if("<%=viewfrom%>"=="fromsearchlist"&"<%=opentype%>"=="1"){
		var _url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=customid%>";
		if("<%=iscreate%>"=="3"){
			_url += "&viewtype=3";
		}
		if (window.parent.parent) {
			if(window.parent.parent.location.href.indexOf("/wui/main.jsp")>-1){
				window.parent.location = _url;
			}else{
				window.parent.parent.location = _url;
			}
		} else if (window.parent) {
			window.parent.location = _url;
		}
		
	}else{
		try{
			if(parent && parent.parent && parent.parent.window.opener && parent.parent.window.opener._table) {
				parent.parent.window.opener._table.reLoad();
				if(parent.parent.window.opener.parent.parent.frames['leftframe']){
					parent.parent.window.opener.parent.parent.frames['leftframe'].delRefresh();					
				}
				parent.parent.close();
				if(parent.parent.frames['leftframe']){
					window.parent.parent.frames['leftframe'].delRefresh();
				}
			} else if (parent && parent.window.opener && parent.window.opener._table) {
				parent.window.opener._table.reLoad();
				if(parent.window.opener.parent.parent.frames['leftframe']){
					parent.window.opener.parent.parent.frames['leftframe'].delRefresh();
				}	
				parent.close();
			}
			
		}catch(e){
		
		}
		try{
			if(<%=istabinline%>==1){
				if(<%=tabcount%>==0){
					window.parent.location.href=window.parent.location.href;
				}else{
					window.parent.parent.location.href=window.parent.parent.location.href;
				}
			}
		}catch(e){
		
		}
	}
</script>
<%
}else if(src.equals("save")&&!"".equals(method)){
	String adddocfieldid = method.substring(7) ;
    String addMethod=method.substring(0,7) ;
    if(adddocfieldid.indexOf("_")>0)
    {
    	String docrowindex = Util.null2String(ModeDataManager.getDocrowindex());
    	if(!docrowindex.equals(""))
    		adddocfieldid = adddocfieldid.substring(0,adddocfieldid.indexOf("_"))+"_"+docrowindex;
    }
    //将文档字段设置session中
    session.setAttribute(user.getUID()+"_"+billid+"_docfieldid",adddocfieldid);
	String topage = "/formmode/view/AddFormModeIframe.jsp?fromFlowDoc=1&isfromTab="+isfromTab+"&modeId="+formmodeid+"&formId="+formid+"&type=2&billid="+billid+"&opentype=0&customid="+customid+"&adddocfieldid="+adddocfieldid+"&isdialog="+isDialog+"&isclose=1&templateid="+templateid+"&istabinline="+istabinline+"&tabcount="+tabcount+"&customTreeDataId="+treesupvalue;
	topage = URLEncoder.encode(topage);
    out.print("<script>wfforward('/docs/docs/DocList.jsp?&isOpenNewWind=0&topage="+topage+"');</script>");
}else if("1".equals(operationReplyData)){
	int reqModeId = Util.getIntValue(request.getParameter("reqModeId"),0);
	int reqFormId = Util.getIntValue(request.getParameter("reqFormId"),0);
	int reqBillid = Util.getIntValue(request.getParameter("reqBillid"),0);
	int temp_Quotesid = Util.getIntValue(request.getParameter("temp_Quotesid"),0);
	int temp_Commentid = Util.getIntValue(request.getParameter("temp_Commentid"),0);
	int isEditOpt = Util.getIntValue(request.getParameter("isEditOpt"),0);
	if(billid>0){
		int CommentTopid = 0;
		int CommentUsersid = 0;
		int floornum = 0;
		if(isEditOpt==1){
			rs.executeSql("select floornum from uf_Reply where rqid="+reqBillid+" and rqmodeid="+reqModeId+" and id="+billid);
		}else{
			rs.executeSql("select max(floorNum)+1 as floornum from uf_Reply where rqid="+reqBillid+" and rqmodeid="+reqModeId);
		}
		if(rs.next()){
			floornum = NumberHelper.string2Int(rs.getString("floornum"),1);
		}
		if(temp_Commentid!=0){
			floornum = 0;
			CommentTopid = Util.getIntValue(request.getParameter("temp_CommentTopid"),0);
			CommentUsersid = Util.getIntValue(request.getParameter("temp_CommentUsersid"),0);
		}
		StringBuffer sqlStr = new StringBuffer("update uf_Reply set ");
		sqlStr.append("rqid="+reqBillid+",rqmodeid="+reqModeId+",replyor="+user.getUID()+",replydate='"+DateHelper.getCurrentDate()+"',");
		sqlStr.append("quotesid="+temp_Quotesid+",commentid="+temp_Commentid+",replytime='"+DateHelper.getCurrentTime()+"',");
		sqlStr.append("commenttopid="+CommentTopid+",commentusersid="+CommentUsersid+",floornum="+floornum+" where id="+billid);
		rs.executeSql(sqlStr.toString());
	}
%>
	<script language="javascript">
		$(window.parent.document).find("#loading").hide();
		var replyFrameObj = $(window.parent.document).find("#replyFrame");
		replyFrameObj.get(0).src=replyFrameObj.attr("src");
		 //$(window.parent.document).contentWindow.loadFmCommentLayout();
		$(window.parent.document).find("#oTDtype_0").children("a")[0].click();
	</script>
<%}else{
	 
%>
	<script language="javascript">
	
		try{
			if(parent && parent.window.opener && parent.window.opener._table){
				parent.window.opener._table.reLoad();
				parent.window.opener.parent.loadGroup();
				parent.window.opener.parent.parent.frames['leftframe'].refreshTree("<%=treesupvalue%>","<%=lastnodeid%>","<%=newsupvalue%>");
			}
			if(parent && parent.parent && parent.parent.window.opener && parent.parent.window.opener._table){
				parent.parent.window.opener._table.reLoad();	
				parent.parent.window.opener.parent.loadGroup();
				parent.parent.window.opener.parent.parent.frames['leftframe'].refreshTree("<%=treesupvalue%>","<%=lastnodeid%>","<%=newsupvalue%>");			
			}
		}catch(e){
			
		}
		<%
		if(subnew==1){
			String addurl = "";
			if(formid!=0){
				String sql = "select id,fieldname from workflow_billfield where viewtype=0 and billid = " + formid;
				rs.executeSql(sql);
				while(rs.next()){
					String id = Util.null2String(rs.getString("id"));
					String fieldid = "field"+id+"_set";
					String fieldname = Util.null2String(rs.getString("fieldname"));
					String fieldvalue = Util.null2String(request.getParameter(fieldid));
					if(!fieldvalue.equals("")){
						addurl += "&field"+id+"="+fieldvalue;
					}
				}
			}
			%>
			window.location.href="/formmode/view/AddFormModeIframe.jsp?modeId=<%=formmodeid%>&formId=<%=formid%>&type=1<%=addurl %>&mainid=<%=mainid%>&istabinline=<%=istabinline%>&tabcount=<%=tabcount%>&customTreeDataId=<%=treesupvalue%>";
			<%
		}else{
			%>
			var url="/formmode/view/AddFormMode.jsp?isfromTab=0&modeId=<%=formmodeid%>&formId=<%=formid%>&type=0&billid=<%=billid%>&iscreate=<%=iscreate%>&messageid=<%=messageid%>&viewfrom=<%=viewfrom%>&opentype=<%=opentype%>&customid=<%=customid%>&isopenbyself=<%=isopenbyself%>&isdialog=<%=isDialog%>&isclose=1&templateid=<%=templateid%>&mainid=<%=mainid%>&istabinline=<%=istabinline%>&tabcount=<%=tabcount%>&tabid=<%=tabid%>&customTreeDataId=<%=treesupvalue%>";
			if(<%=istabinline%>==1){
				if(<%=tabcount%>==0){
					<%if(billid > 0 && iscreate.equals("1")){%>
						window.parent.location.href=window.parent.location.href;
					<%}else{%>
						window.location.href = url;
					<%}%>
				}else{
					<%if(billid > 0 && iscreate.equals("1")){%>
						window.parent.parent.location.href=window.parent.parent.location.href;
					<%}else{%>
						window.parent.location.href=url;
					<%}%>
				}
			}else{
				var isfromTab="<%=isfromTab%>";
				var tabid = <%=tabid%>;
				if(isfromTab==1){
					//若不是ie为表单加上target属性，避免谷歌浏览器后退按钮后退到form的action的jsp中导致重复数据
					if(navigator.userAgent.indexOf("MSIE") == -1){
						window.parent.parent.location.replace(url);
					}else{
						window.parent.parent.location.href=url;
					}
				}else{
					if(parent.parent.location.href.indexOf("/formmode/view/ViewMode.jsp")!=-1 && tabid==0){
						parent.parent.location.href=url;
					}else{
						//若不是ie为表单加上target属性，避免谷歌浏览器后退按钮后退到form的action的jsp中导致重复数据
						if(navigator.userAgent.indexOf("MSIE") == -1){
							window.parent.location.replace(url);
						}else{
							window.parent.location.href=url;
						}
					}
				}
			}
			<%
		}
		%>
	</script>
	<%
}
%>