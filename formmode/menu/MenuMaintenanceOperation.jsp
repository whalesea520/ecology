
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.menuconfig.MenuUtil" %>
<%@ page import="weaver.systeminfo.menuconfig.MenuMaint" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="weaver.file.FileUpload" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
	//if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
	//    response.sendRedirect("/notice/noright.jsp");
	//    return;
	//}
	 
	
	FileUpload fu = new FileUpload(request,false,"images/menu/others");
	String method = Util.null2String(fu.getParameter("method"));	
	String resourceId = Util.null2String(fu.getParameter("resourceId"));	
	String resourceType = Util.null2String(fu.getParameter("resourceType"));	
	String infoId = Util.null2String(fu.getParameter("infoId"));	
	String isCustom = Util.null2String(fu.getParameter("isCustom"));	
	int sync = Util.getIntValue(fu.getParameter("chkSynch"),0);
	String menuflag = Util.null2String(fu.getParameter("menuflag"));//表单建模新增菜单地址
	
	int subCompanyId = Util.getIntValue(fu.getParameter("subCompanyId"),-1);
	if(resourceType.equals("2")){//分部菜单
		subCompanyId = Util.getIntValue(resourceId,-1);
	}
	String type = Util.null2String(fu.getParameter("type"));	


	int userid = user.getUID();
	
	//分权判断
	String subcomStr = "0";
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	//if(detachable==1){
		//取得下级分部
		ArrayList subcomList = new ArrayList();
		subcomList = subCompanyComInfo.getSubCompanyLists(""+subCompanyId,subcomList);
		//for(Iterator sit = subcomList.iterator();sit.hasNext();){
		for(int i=0;i<subcomList.size();i++){
			if(CheckSubCompanyRight.ChkComRightByUserRightCompanyId(userid,"HeadMenu:Maint",Util.getIntValue((String)subcomList.get(i)))>0
			||CheckSubCompanyRight.ChkComRightByUserRightCompanyId(userid,"SubMenu:Maint",Util.getIntValue((String)subcomList.get(i)))>0){
				subcomStr+=",";
				subcomStr+=(String)subcomList.get(i);
			}
		}
	//}
		
	MenuUtil mu=new MenuUtil(type,Util.getIntValue(resourceType),Util.getIntValue(resourceId),user.getLanguage());
	MenuMaint  mm=new MenuMaint(type,Util.getIntValue(resourceType),Util.getIntValue(resourceId),user.getLanguage());

	
	if(method.equalsIgnoreCase("maintenance")){		
		mm.maintance(request);
		response.sendRedirect("/formmode/menu/MenuMaintenanceList.jsp?menuflag="+menuflag+"&isCustom="+isCustom+"&type="+type+"&resourceType="+resourceType+"&resourceId="+resourceId+"&subCompanyId="+subCompanyId);
	} else if (method.equalsIgnoreCase("synchall")){
		//得到所有菜单列表
		ArrayList infoList=mu.getAllMenuList(0,"visible");
		if(sync==1)	mm.synchSubMenuConfig(infoList,subcomStr);
		response.sendRedirect("/formmode/menu/MenuMaintenanceList.jsp?menuflag="+menuflag+"&isCustom="+isCustom+"&type="+type+"&resourceType="+resourceType+"&resourceId="+resourceId+"&subCompanyId="+subCompanyId);
	}else if(method.equalsIgnoreCase("delthisall")){		
		mm.delMenu(Util.getIntValue(infoId),1);			
	} else if(method.equalsIgnoreCase("del")){		
		mm.delMenu(Util.getIntValue(infoId),0);			
	} else 	if(method.equalsIgnoreCase("add")){	

		String targetBase = Util.null2String(fu.getParameter("targetframe"));	
		int parentId = Util.getIntValue(fu.getParameter("parentId"),0);	
		String customMenuName = Util.null2String(fu.getParameter("customMenuName"));	
		String customMenuLink = Util.null2String(fu.getParameter("customMenuLink"));	
		String customName_e = Util.null2String(fu.getParameter("customName_e"));	
		String customName_t = Util.null2String(fu.getParameter("customName_t"));	
		
		
		int customMenuViewIndex=mu.getMaxCustomViewIndex(parentId);
		
		String iconUrl="";
		String tempIconUrl = Util.null2String(fu.uploadFiles("customIconUrl"));
		String topIconUrl = Util.null2String(fu.uploadFiles("topIconUrl"));
		if(tempIconUrl.equals(""))     iconUrl= "/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif";
		else iconUrl=mu.getRealAddr(tempIconUrl);
		
		if(topIconUrl.equals(""))     
			topIconUrl= "";
		else 
			topIconUrl=mu.getRealAddr(topIconUrl);

		int menuLevel = 1;
		if(parentId!=0) menuLevel = 2;
		//增加系统维护菜单
		int currInfoId = mm.addMenu(customMenuName,customMenuLink,customMenuViewIndex,menuLevel,""+parentId,iconUrl,topIconUrl,targetBase,customName_e,customName_t);
		//同步Config
		mm.addMenuConfig(currInfoId,customMenuViewIndex,0,0,0,customMenuName,customName_e,customName_t);			
		//同步下级
		if(sync==1) {					
			mm.synchSubMenuConfig(currInfoId,subcomStr);
		}
		
		List ids = getSuperMenuid(""+currInfoId,type);
		String selectids = "";
		for(int i=ids.size()-1;i>=0;i--)selectids+=","+ids.get(i);
		
		out.println("<input type='hidden' value=\""+customMenuName+"\" id='sText'/>");	
		out.println("<input type='hidden' value=\""+iconUrl+"\" id='sIcon'/>");	
		out.println("<input type='hidden' value=\""+currInfoId+"\" id='curMenuid'/>");	
		out.println("<input type='hidden' value=\""+customMenuLink+"\" id='linkAddress'/>");	
		out.println("<input type='hidden' value=\""+customMenuViewIndex+"\" id='customMenuViewIndex'/>");

		out.println("<script language=javaScript>parent.closeDialogAndRefreshWin(true,'"+selectids+"');</script>");
	} else if(method.equalsIgnoreCase("edit")){
		String targetBase = Util.null2String(fu.getParameter("targetframe"));	
		String parentId = Util.null2String(fu.getParameter("parentId"));	
		String customMenuName = Util.null2String(fu.getParameter("customMenuName"));	
		String customMenuLink = Util.null2String(fu.getParameter("customMenuLink"));	
		String customName_e = Util.null2String(fu.getParameter("customName_e"));	
		String customName_t = Util.null2String(fu.getParameter("customName_t"));
		int customMenuViewIndex=mu.getMaxCustomViewIndex(Util.getIntValue(parentId));

	
		String iconUrl="";
		String tempIconUrl = Util.null2String(fu.uploadFiles("customIconUrl"));
		if(tempIconUrl.equals(""))     iconUrl= "";
		else iconUrl=mu.getRealAddr(tempIconUrl);
		
		String topIconUrl = Util.null2String(fu.uploadFiles("topIconUrl"));
		if(topIconUrl.equals(""))     
			topIconUrl= "";
		else 
			topIconUrl=mu.getRealAddr(topIconUrl);

		
		mm.editMenu(customMenuName,customMenuLink,customMenuViewIndex,Util.getIntValue(infoId),iconUrl,topIconUrl,targetBase,customName_e,customName_t);	
		
		int menuLevel = 1;
		if(!parentId.equals("")) menuLevel = 2;
		//增加系统维护菜单
		int currInfoId = mm.addMenu(customMenuName,customMenuLink,customMenuViewIndex,menuLevel,""+parentId,iconUrl,topIconUrl,targetBase,customName_e,customName_t);
		
		//同步下级
		if(sync==1) {					
			mm.synchSubMenuConfig(Util.getIntValue(infoId),subcomStr);
		}

		out.println("<input type='hidden' value=\""+iconUrl+"\" id='iconUrl'/>");	
		out.println("<input type='hidden' value=\""+customMenuName+"\" id='sText'/>");	
		
		List ids = getSuperMenuid(""+currInfoId,type);
		String selectids = "";
		for(int i=ids.size()-1;i>=0;i--)selectids+=","+ids.get(i);
		
		out.println("<script language=javaScript>parent.closeDialogAndRefreshWin(true,'"+selectids+"');</script>");
		
	} 	else if(method.equalsIgnoreCase("addadvanced")){

		int parentId = Util.getIntValue(fu.getParameter("parentId"),0);		
			
		String customMenuName = Util.null2String(fu.getParameter("customMenuName"));		
		String customName_e = Util.null2String(fu.getParameter("customName_e"));
		String customName_t = Util.null2String(fu.getParameter("customName_t"));
		int customMenuViewIndex=mu.getMaxCustomViewIndex(parentId);
		String iconUrl="";		
		String tempIconUrl = Util.null2String(fu.uploadFiles("customIconUrl"));
		if(tempIconUrl.equals(""))     iconUrl= "/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif";
		else iconUrl=mu.getRealAddr(tempIconUrl);
		
		String topIconUrl = Util.null2String(fu.uploadFiles("topIconUrl"));
		if(topIconUrl.equals(""))     
			topIconUrl= "";
		else 
			topIconUrl=mu.getRealAddr(topIconUrl);
		
		int menuLevel = 1;
		if(parentId!=0) menuLevel = 2;
		
		String customModule = Util.null2String(fu.getParameter("customModule"));//模块
		String customType = Util.null2String(fu.getParameter("customType_"+customModule));//菜单类型
		String displayUsage = "";//默认显示方式
		String customMenuLink = "";//链接地址
		String selectedContent="";
		
		//增加系统维护菜单
		int currInfoId = mm.addMenu(customMenuName,customMenuLink,customMenuViewIndex,menuLevel,""+parentId,iconUrl,topIconUrl,"",customName_e,customName_t);
		
		if("1".equals(customModule)){//文档
			if("1".equals(customType)){//新建文档
				//取得选择文档目录串
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("docdir_ND_M")!=-1||value[i].indexOf("docdir_ND_S")!=-1){
							String addedStr = value[i].substring(10);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/docs/docs/DocList.jsp?fromadvancedmenu=1&infoId="+currInfoId;
			} else if("2".equals(customType)){//我的文档
				displayUsage = Util.null2String(fu.getParameter("displayUsage_2"));
				//取得选择文档目录串
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("docdir_MD_M")!=-1||value[i].indexOf("docdir_MD_S")!=-1){
							String addedStr = value[i].substring(10);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/docs/search/DocView.jsp?fromadvancedmenu=1&infoId="+currInfoId+"&displayUsage="+displayUsage;
			} else if("3".equals(customType)){//最新文档
				displayUsage = Util.null2String(fu.getParameter("displayUsage_3"));
				//取得选择文档目录串
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("docdir_NESTD_M")!=-1||value[i].indexOf("docdir_NESTD_S")!=-1){
							String addedStr = value[i].substring(13);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/docs/search/DocSearchTemp.jsp?fromadvancedmenu=1&infoId="+currInfoId+"&list=all&isNew=yes&loginType=1&containreply=1&displayUsage="+displayUsage;
			} else if("4".equals(customType)){//文档目录
				displayUsage = Util.null2String(fu.getParameter("displayUsage_4"));
				//取得选择文档目录串
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("docdir_DC_M")!=-1||value[i].indexOf("docdir_DC_S")!=-1){
							String addedStr = value[i].substring(10);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/docs/search/DocSummary.jsp?fromadvancedmenu=1&infoId="+currInfoId+"&displayUsage="+displayUsage;
			}
		}
		else if("2".equals(customModule)){//流程
			if("1".equals(customType)){//新建流程
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_NF_T")!=-1||value[i].indexOf("workflow_NF_W")!=-1||value[i].indexOf("workflow_NF_R")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/request/RequestType.jsp?fromadvancedmenu=1&infoId="+currInfoId;
			} else if("2".equals(customType)){//待办事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_PM_T")!=-1||value[i].indexOf("workflow_PM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}

							if(value[i].indexOf("workflow_PM_W")!=-1){
								int t_wfid = Util.getIntValue(addedStr.substring(1), 0);
								if(t_wfid != 0){
									String t_nodeids = fu.getParameter2("workflow_PM_v" + t_wfid);
									String s_nodeName = fu.getParameter("workflow_PM_n" + t_wfid);
									
									if(!"0".equals(t_nodeids) && !"".equals(t_nodeids)){
										selectedContent+="|P"+addedStr+"N"+t_nodeids + "SP^AN" + s_nodeName;
									}
								}
							}

						}
					}
				}
				
				customMenuLink = "/workflow/request/RequestView.jsp?fromadvancedmenu=1&infoId="+currInfoId;
			} else if("3".equals(customType)){//已办事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_HM_T")!=-1||value[i].indexOf("workflow_HM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/request/RequestHandled.jsp?fromadvancedmenu=1&infoId="+currInfoId;
			} else if("4".equals(customType)){//办结事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_CM_T")!=-1||value[i].indexOf("workflow_CM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/request/RequestComplete.jsp?fromadvancedmenu=1&infoId="+currInfoId;
			} else if("5".equals(customType)){//我的请求
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_MR_T")!=-1||value[i].indexOf("workflow_MR_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/request/MyRequestView.jsp?fromadvancedmenu=1&infoId="+currInfoId;
			} else if("6".equals(customType)){//抄送事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_RM_T")!=-1||value[i].indexOf("workflow_RM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&infoId="+currInfoId;
			} else if("7".equals(customType)){//督办事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_SM_T")!=-1||value[i].indexOf("workflow_SM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&infoId="+currInfoId;
			} else if("8".equals(customType)){//超时事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_OM_T")!=-1||value[i].indexOf("workflow_OM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&infoId="+currInfoId;
			} else if("9".equals(customType)){//反馈事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_FM_T")!=-1||value[i].indexOf("workflow_FM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&infoId="+currInfoId;
			}
		}
		else if("3".equals(customModule)){//客户
			if("1".equals(customType)){//新建客户
				customMenuLink = "/CRM/data/AddCustomerExist.jsp";
			}
		}
		else if("4".equals(customModule)){//项目
			if("1".equals(customType)){//新建项目
				//取得选择的项目类型
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("project_P")!=-1){
							String addedStr = value[i].substring(8);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/proj/Templet/ProjTempletSele.jsp?fromadvancedmenu=1&infoId="+currInfoId;
			} else if("2".equals(customType)){//项目执行
				customMenuLink = "/proj/data/MyProject.jsp";
			} else if("3".equals(customType)){//审批项目
				customMenuLink = "/proj/data/ProjectApproval.jsp";
			} else if("4".equals(customType)){//审批任务
				customMenuLink = "/proj/process/ProjectTaskApproval.jsp";
			} else if("5".equals(customType)){//当前任务
				customMenuLink = "/proj/data/CurrentTask.jsp";
			} else if("6".equals(customType)){//超期任务
				customMenuLink = "/proj/data/OverdueTask.jsp";
			}
		}
		//更新菜单高级信息
		mm.updateMenuAdvancedInfo(currInfoId,customMenuLink,"1",customModule,customType,displayUsage,selectedContent);
		//同步Config
		mm.addMenuConfig(currInfoId,customMenuViewIndex,0,0,0,customMenuName,customName_e,customName_t);	
		
		//同步下级
		if(sync==1) mm.synchSubMenuConfig(currInfoId,subcomStr);		

		out.println("<input type='hidden' value=\""+customMenuName+"\" id='sText'/>");	
		out.println("<input type='hidden' value=\""+iconUrl+"\" id='sIcon'/>");	
		out.println("<input type='hidden' value=\""+currInfoId+"\" id='curMenuid'/>");	
		out.println("<input type='hidden' value=\""+customMenuLink+"\" id='linkAddress'/>");	
		out.println("<input type='hidden' value=\""+customMenuViewIndex+"\" id='customMenuViewIndex'/>");

		out.println("<script language=javaScript>parent.addwin.hide()</script>");
	} else if(method.equalsIgnoreCase("editadvanced")){
		String parentId = Util.null2String(fu.getParameter("parentId"));
		String customMenuName = Util.null2String(fu.getParameter("customMenuName"));
		String customName_e = Util.null2String(fu.getParameter("customName_e"));
		String customName_t = Util.null2String(fu.getParameter("customName_t"));
		
		int customMenuViewIndex=mu.getMaxCustomViewIndex(Util.getIntValue(parentId));
		String iconUrl="";
		String tempIconUrl = Util.null2String(fu.uploadFiles("customIconUrl"));
		if(tempIconUrl.equals(""))     iconUrl= "";
		else iconUrl=mu.getRealAddr(tempIconUrl);
        
		String topIconUrl = Util.null2String(fu.uploadFiles("topIconUrl"));
		if(topIconUrl.equals(""))     
			topIconUrl= "";
		else 
			topIconUrl=mu.getRealAddr(topIconUrl);
		
		int menuLevel = 1;
		if(Util.getIntValue(parentId,0)!=0) menuLevel = 2;
		
		String customModule = Util.null2String(fu.getParameter("customModule"));//模块
		String customType = Util.null2String(fu.getParameter("customType_"+customModule));//菜单类型
		String displayUsage = "";//默认显示方式
		String customMenuLink = "";//链接地址
		String selectedContent="";
		
		if("1".equals(customModule)){//文档
			if("1".equals(customType)){//新建文档
				//取得选择文档目录串
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("docdir_ND_M")!=-1||value[i].indexOf("docdir_ND_S")!=-1){
							String addedStr = value[i].substring(10);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/docs/docs/DocList.jsp?fromadvancedmenu=1&infoId="+infoId;
			} else if("2".equals(customType)){//我的文档
				displayUsage = Util.null2String(fu.getParameter("displayUsage_2"));
				//取得选择文档目录串
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("docdir_MD_M")!=-1||value[i].indexOf("docdir_MD_S")!=-1){
							String addedStr = value[i].substring(10);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/docs/search/DocView.jsp?fromadvancedmenu=1&infoId="+infoId+"&displayUsage="+displayUsage;
			} else if("3".equals(customType)){//最新文档
				displayUsage = Util.null2String(fu.getParameter("displayUsage_3"));
				//取得选择文档目录串
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("docdir_NESTD_M")!=-1||value[i].indexOf("docdir_NESTD_S")!=-1){
							String addedStr = value[i].substring(13);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/docs/search/DocSearchTemp.jsp?fromadvancedmenu=1&infoId="+infoId+"&list=all&isNew=yes&loginType=1&containreply=1&displayUsage="+displayUsage;
			} else if("4".equals(customType)){//文档目录
				displayUsage = Util.null2String(fu.getParameter("displayUsage_4"));
				//取得选择文档目录串
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("docdir_DC_M")!=-1||value[i].indexOf("docdir_DC_S")!=-1){
							String addedStr = value[i].substring(10);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/docs/search/DocSummary.jsp?fromadvancedmenu=1&infoId="+infoId+"&displayUsage="+displayUsage;
			}
		}
		else if("2".equals(customModule)){//流程
			if("1".equals(customType)){//新建流程
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_NF_T")!=-1||value[i].indexOf("workflow_NF_W")!=-1||value[i].indexOf("workflow_NF_R")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/request/RequestType.jsp?fromadvancedmenu=1&infoId="+infoId;
			} else if("2".equals(customType)){//待办事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_PM_T")!=-1||value[i].indexOf("workflow_PM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
							if(value[i].indexOf("workflow_PM_W")!=-1){
								int t_wfid = Util.getIntValue(addedStr.substring(1), 0);
								if(t_wfid != 0){
									String t_nodeids = fu.getParameter2("workflow_PM_v" + t_wfid);
									String s_nodeName = fu.getParameter("workflow_PM_n" + t_wfid);
									
									if(!"0".equals(t_nodeids) && !"".equals(t_nodeids)){
										selectedContent+="|P"+addedStr+"N"+t_nodeids + "SP^AN" + s_nodeName;
									}
								}
							}

						}
					}
				}
				
				customMenuLink = "/workflow/request/RequestView.jsp?fromadvancedmenu=1&infoId="+infoId;
			} else if("3".equals(customType)){//已办事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_HM_T")!=-1||value[i].indexOf("workflow_HM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/request/RequestHandled.jsp?fromadvancedmenu=1&infoId="+infoId;
			} else if("4".equals(customType)){//办结事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_CM_T")!=-1||value[i].indexOf("workflow_CM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/request/RequestComplete.jsp?fromadvancedmenu=1&infoId="+infoId;
			} else if("5".equals(customType)){//我的请求
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_MR_T")!=-1||value[i].indexOf("workflow_MR_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/request/MyRequestView.jsp?fromadvancedmenu=1&infoId="+infoId;
			} else if("6".equals(customType)){//抄送事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_RM_T")!=-1||value[i].indexOf("workflow_RM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&infoId="+infoId;
			} else if("7".equals(customType)){//督办事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_SM_T")!=-1||value[i].indexOf("workflow_SM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&infoId="+infoId;
			} else if("8".equals(customType)){//超时事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_OM_T")!=-1||value[i].indexOf("workflow_OM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&infoId="+infoId;
			} else if("9".equals(customType)){//反馈事宜
				//取得选择的工作流
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_FM_T")!=-1||value[i].indexOf("workflow_FM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&infoId="+infoId;
			}
		}
		else if("3".equals(customModule)){//客户
			if("1".equals(customType)){//新建客户
				customMenuLink = "/CRM/data/AddCustomerExist.jsp";
			}
		}
		else if("4".equals(customModule)){//项目
			if("1".equals(customType)){//新建项目
				//取得选择的项目类型
				for(Enumeration En=fu.getParameterNames();En.hasMoreElements();){
					String[] value=fu.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("project_P")!=-1){
							String addedStr = value[i].substring(8);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/proj/Templet/ProjTempletSele.jsp?fromadvancedmenu=1&infoId="+infoId;
			} else if("2".equals(customType)){//项目执行
				customMenuLink = "/proj/data/MyProject.jsp";
			} else if("3".equals(customType)){//审批项目
				customMenuLink = "/proj/data/ProjectApproval.jsp";
			} else if("4".equals(customType)){//审批任务
				customMenuLink = "/proj/process/ProjectTaskApproval.jsp";
			} else if("5".equals(customType)){//当前任务
				customMenuLink = "/proj/data/CurrentTask.jsp";
			} else if("6".equals(customType)){//超期任务
				customMenuLink = "/proj/data/OverdueTask.jsp";
			}
		}
		//更新基本信息
		mm.editMenu(customMenuName,customMenuLink,customMenuViewIndex,Util.getIntValue(infoId),iconUrl,topIconUrl,"",customName_e,customName_t);
		//更新菜单高级信息
		mm.updateMenuAdvancedInfo(Util.getIntValue(infoId),customMenuLink,"1",customModule,customType,displayUsage,selectedContent);	

		if(!"".equals(iconUrl)) out.println("<input type='hidden' value=\""+iconUrl+"\" id='iconUrl'/>");	
		out.println("<input type='hidden' value=\""+customMenuName+"\" id='sText'/>");	
		out.println("<script language=javaScript>parent.editwin.hide()</script>");

	} 
	 
	
%>	

<%!
List selectids = new ArrayList();
List getSuperMenuid(String infoid,String type){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	String sql = "";
	if("left".equals(type)){
		sql = "select parentid from leftmenuinfo where id="+infoid;
	}else if("top".equals(type)){
		sql = "select parentid from mainmenuinfo where id="+infoid;
	}
	rs.executeSql(sql);
	rs.next();
	String parentid = rs.getString("parentid");
	if(!"".equals(parentid)&&!"0".equals(parentid)){
		selectids.add(parentid);
		getSuperMenuid(parentid,type);
	}
	return selectids;
}

void clearSelectids(){
	if(selectids!=null)
		selectids = new ArrayList();
}
%>