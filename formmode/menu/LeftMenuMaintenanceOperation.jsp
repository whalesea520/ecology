
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfigHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfig" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="java.util.ArrayList" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
	
	String method = request.getParameter("method");
	String resourceId = request.getParameter("resourceId");
	String resourceType = request.getParameter("resourceType");
	String infoId = request.getParameter("infoId");
    int sync = Util.getIntValue(request.getParameter("sync"),0);

	int userid = user.getUID();
	
	LeftMenuConfigHandler configHandler = new LeftMenuConfigHandler();
	LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
	
	if(method.equalsIgnoreCase("maintenance")){
	
		String[] maininfoids = request.getParameterValues("main_infoids");
		String[] visibles = request.getParameterValues("chk_visible");
		//修改本分部/总部下所有的菜单是否可以查看
		

		List infoidlist = new ArrayList();
		for(int i=0;maininfoids!=null&&i<maininfoids.length;i++){
			infoidlist.add(maininfoids[i]);
			String mainId = maininfoids[i];
			String visible = "0";
			for(int k=0;visibles!=null&&k<visibles.length;k++){
				if(visibles[k].equals(maininfoids[i])){
					visible = "1";
					break;
				}
			}			
			rs.executeSql("update LeftMenuconfig set visible="+visible+" where resourceType="+resourceType+" and  resourceId="+resourceId+" and infoid="+mainId);
			

			if(Util.getIntValue(mainId)<0){
				mainId = Math.abs(Util.getIntValue(mainId)) + "_neg";
			}
			//子菜单
			String[] subinfoids = request.getParameterValues("sub_infoids_"+mainId);
			String[] subVisibles = request.getParameterValues("chk_visible_"+mainId);

			for(int j=0;subinfoids!=null&&j<subinfoids.length;j++){
				infoidlist.add(subinfoids[j]);
				String subVisible = "0";
				
				for(int k=0;subVisibles!=null&&k<subVisibles.length;k++){
					
					if(subVisibles[k].equals(subinfoids[j])){
						subVisible = "1";
						break;
					}					
				}
				rs.executeSql("update LeftMenuconfig set visible="+subVisible+" where resourceType="+resourceType+" and  resourceId="+resourceId+" and infoid="+subinfoids[j]);
			    
			}


			
			

		}
		if("1".equals(resourceType)||"2".equals(resourceType) && sync==1){
			configHandler.lockedSubLeftMenuConfig(Util.getIntValue(resourceId),resourceType,infoidlist,user,sync);
		}
		response.sendRedirect("LeftMenuMaintenanceList.jsp?saved=true"+"&resourceType="+resourceType+"&resourceId="+resourceId+"&sync="+sync);
	}
	else if(method.equalsIgnoreCase("add")){
		String targetBase=Util.null2String(request.getParameter("targetframe"));
		String parentId = Util.null2String(request.getParameter("parentId"));
		String customMenuName = Util.null2String(request.getParameter("customMenuName"));
		String customMenuLink = Util.null2String(request.getParameter("customMenuLink"));
		int customMenuViewIndex = Util.getIntValue(request.getParameter("customMenuViewIndex"),0);
        String iconUrl = Util.null2String(request.getParameter("customIconUrl"));
		if("".equals(iconUrl))
        	if(!parentId.equals("")) iconUrl="/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif";
        	else iconUrl="/images/folder_wev8.png";
		int menuLevel = 1;
		if(Util.getIntValue(parentId,0)!=0) menuLevel = 2;
		//增加系统维护菜单
		int currInfoId = infoHandler.addLeftMenu(customMenuName,customMenuLink,customMenuViewIndex,menuLevel,(!"".equals(parentId)&&!"0".equals(parentId)?parentId:"null"),iconUrl,targetBase);
		//同步Config
		configHandler.addLeftMenuConfig(Util.getIntValue(resourceId),resourceType,currInfoId,customMenuViewIndex,0,0,0,"");//1,customMenuName);
		//更新显示顺序
		infoHandler.updateViewIndex(currInfoId,Util.getIntValue(resourceId),Util.getIntValue(resourceType),menuLevel,Util.getIntValue(parentId,0),customMenuViewIndex);

		//同步下级
		configHandler.lockedSubLeftMenuConfig(Util.getIntValue(resourceId),resourceType,currInfoId,user,sync);
		response.sendRedirect("LeftMenuMaintenanceList.jsp?saved=true"+"&resourceType="+resourceType+"&resourceId="+resourceId+"&sync="+sync);
	}
	else if(method.equalsIgnoreCase("edit")){
		String targetBase=Util.null2String(request.getParameter("targetframe"));
		String customMenuName = Util.null2String(request.getParameter("customMenuName"));
		String customMenuLink = Util.null2String(request.getParameter("customMenuLink"));
		int customMenuViewIndex = Util.getIntValue(request.getParameter("customMenuViewIndex"),0);
		String iconUrl = Util.null2String(request.getParameter("customIconUrl"));
		LeftMenuInfo info = infoHandler.getLeftMenuInfo(Util.getIntValue(infoId));
		//编辑系统维护菜单
		infoHandler.editLeftMenu(customMenuName,customMenuLink,customMenuViewIndex,Util.getIntValue(infoId),Util.getIntValue(resourceId),resourceType,iconUrl,targetBase);
		//更新显示顺序
		infoHandler.updateViewIndex(Util.getIntValue(infoId),Util.getIntValue(resourceId),Util.getIntValue(resourceType),info.getMenuLevel(),info.getParentId(),customMenuViewIndex);
		response.sendRedirect("LeftMenuMaintenanceList.jsp?saved=true"+"&resourceType="+resourceType+"&resourceId="+resourceId+"&sync="+sync);
	}
	else if(method.equalsIgnoreCase("del")){
		LeftMenuInfo info = infoHandler.getLeftMenuInfo(Util.getIntValue(infoId));
		//删除系统维护菜单
		infoHandler.delLeftMenu(Util.getIntValue(infoId),Util.getIntValue(resourceId),resourceType);
		//更新显示顺序
		infoHandler.updateViewIndex(Util.getIntValue(infoId),Util.getIntValue(resourceId),Util.getIntValue(resourceType),info.getMenuLevel(),info.getParentId(),0);
		response.sendRedirect("LeftMenuMaintenanceList.jsp?saved=true"+"&resourceType="+resourceType+"&resourceId="+resourceId+"&sync="+sync);
	}
	else if(method.equalsIgnoreCase("addadvanced")){
		String parentId = Util.null2String(request.getParameter("parentId"));
		String customMenuName = Util.null2String(request.getParameter("customMenuName"));
		
		int customMenuViewIndex = Util.getIntValue(request.getParameter("customMenuViewIndex"),0);
        String iconUrl = Util.null2String(request.getParameter("customIconUrl"));
		if("".equals(iconUrl))
        	if(!parentId.equals("")) iconUrl="/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif";
        	else iconUrl="/images/folder_wev8.png";
		int menuLevel = 1;
		if(Util.getIntValue(parentId,0)!=0) menuLevel = 2;
		
		String customModule = Util.null2String(request.getParameter("customModule"));//模块
		String customType = Util.null2String(request.getParameter("customType_"+customModule));//菜单类型
		String displayUsage = "";//默认显示方式
		String customMenuLink = "";//链接地址
		String selectedContent="";
		
		//增加系统维护菜单
		int currInfoId = infoHandler.addLeftMenu(customMenuName,customMenuLink,customMenuViewIndex,menuLevel,(!"".equals(parentId)&&!"0".equals(parentId)?parentId:"null"),iconUrl,"");
		
		if("1".equals(customModule)){//文档
			if("1".equals(customType)){//新建文档
				//取得选择文档目录串
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				displayUsage = Util.null2String(request.getParameter("displayUsage_2"));
				//取得选择文档目录串
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				displayUsage = Util.null2String(request.getParameter("displayUsage_3"));
				//取得选择文档目录串
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				displayUsage = Util.null2String(request.getParameter("displayUsage_4"));
				//取得选择文档目录串
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_NF_T")!=-1||value[i].indexOf("workflow_NF_W")!=-1){
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
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_PM_T")!=-1||value[i].indexOf("workflow_PM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/request/RequestView.jsp?fromadvancedmenu=1&infoId="+currInfoId;
			} else if("3".equals(customType)){//已办事宜
				//取得选择的工作流
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
		infoHandler.updateLeftMenuAdvancedInfo(currInfoId,customMenuLink,"1",customModule,customType,displayUsage,selectedContent);
		//同步Config
		configHandler.addLeftMenuConfig(Util.getIntValue(resourceId),resourceType,currInfoId,customMenuViewIndex,0,0,0,"");//1,customMenuName);
		//更新显示顺序
		infoHandler.updateViewIndex(currInfoId,Util.getIntValue(resourceId),Util.getIntValue(resourceType),menuLevel,Util.getIntValue(parentId,0),customMenuViewIndex);
		//同步下级
		configHandler.lockedSubLeftMenuConfig(Util.getIntValue(resourceId),resourceType,currInfoId,user,sync);
		response.sendRedirect("LeftMenuMaintenanceList.jsp?saved=true"+"&resourceType="+resourceType+"&resourceId="+resourceId+"&sync="+sync);

	}
	else if(method.equalsIgnoreCase("editadvanced")){
		String parentId = Util.null2String(request.getParameter("parentId"));
		String customMenuName = Util.null2String(request.getParameter("customMenuName"));
		
		int customMenuViewIndex = Util.getIntValue(request.getParameter("customMenuViewIndex"),0);
        String iconUrl = Util.null2String(request.getParameter("customIconUrl"));
		if("".equals(iconUrl))
        	if(!parentId.equals("")) iconUrl="/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif";
        	else iconUrl="/images/folder_wev8.png";
		int menuLevel = 1;
		if(Util.getIntValue(parentId,0)!=0) menuLevel = 2;
		
		String customModule = Util.null2String(request.getParameter("customModule"));//模块
		String customType = Util.null2String(request.getParameter("customType_"+customModule));//菜单类型
		String displayUsage = "";//默认显示方式
		String customMenuLink = "";//链接地址
		String selectedContent="";
		
		if("1".equals(customModule)){//文档
			if("1".equals(customType)){//新建文档
				//取得选择文档目录串
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				displayUsage = Util.null2String(request.getParameter("displayUsage_2"));
				//取得选择文档目录串
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				displayUsage = Util.null2String(request.getParameter("displayUsage_3"));
				//取得选择文档目录串
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				displayUsage = Util.null2String(request.getParameter("displayUsage_4"));
				//取得选择文档目录串
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_NF_T")!=-1||value[i].indexOf("workflow_NF_W")!=-1){
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
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
					for(int i=0;i<value.length;i++){
						value[i]=Util.null2String(value[i]);
						if(value[i].indexOf("workflow_PM_T")!=-1||value[i].indexOf("workflow_PM_W")!=-1){
							String addedStr = value[i].substring(12);
							if (selectedContent.equals("")){
								selectedContent+=addedStr;
							} else {
								selectedContent+="|"+addedStr;
							}
						}
					}
				}
				customMenuLink = "/workflow/request/RequestView.jsp?fromadvancedmenu=1&infoId="+infoId;
			} else if("3".equals(customType)){//已办事宜
				//取得选择的工作流
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
				for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
					String[] value=request.getParameterValues((String) En.nextElement());
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
		infoHandler.editLeftMenu(customMenuName,customMenuLink,customMenuViewIndex,Util.getIntValue(infoId),Util.getIntValue(resourceId),resourceType,iconUrl,"");
		//更新菜单高级信息
		infoHandler.updateLeftMenuAdvancedInfo(Util.getIntValue(infoId),customMenuLink,"1",customModule,customType,displayUsage,selectedContent);
		//更新显示顺序
		infoHandler.updateViewIndex(Util.getIntValue(infoId),Util.getIntValue(resourceId),Util.getIntValue(resourceType),menuLevel,Util.getIntValue(parentId,0),customMenuViewIndex);
		response.sendRedirect("LeftMenuMaintenanceList.jsp?saved=true"+"&resourceType="+resourceType+"&resourceId="+resourceId+"&sync="+sync);

	}
	
	
%>