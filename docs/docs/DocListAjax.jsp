
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,org.json.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.rdeploy.portal.PortalUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourcecominfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="jobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%
	boolean isuserdeploy = PortalUtil.isuserdeploy();
	int id = Util.getIntValue(request.getParameter("id"),0);
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(92,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	String categoryname = Util.null2String(request.getParameter("categoryname"));
	boolean isFav = Util.null2String(request.getParameter("isFav")).equals("1");
	boolean isCommon = Util.null2String(request.getParameter("isCommon")).equals("1");
	String queryString = Util.null2String(request.getQueryString());
	queryString = queryString.replaceAll("^id=\\d*[&]?","").replaceAll("&id=\\d*","");
	Map<String,Object> params = new HashMap<String,Object>();
	params.put("createparentid",""+id);
	params.put("onlyCurrentLevel","true");

	String sqlwhere="";
	int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
	int infoId = Util.getIntValue(request.getParameter("infoId"),0);
    String selectedContent = Util.null2String(request.getParameter("selectedContent"));
	String selectArr = "";
	LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
    LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
    if(info!=null){
        selectArr = info.getSelectedContent();
    }
    if(!"".equals(selectedContent))
    {
        selectArr = selectedContent;
    }
	String[] docCategoryArray = null;
	String  advanids="";
	if(fromAdvancedMenu==1){
	docCategoryArray = Util.TokenizerString2(selectArr,"C");	
	if(docCategoryArray!=null&&docCategoryArray.length>0){
		for(int k=0;k<docCategoryArray.length;k++){
			if(advanids.equals("")){
			   advanids=docCategoryArray[k];
			}else{
			  advanids=advanids+","+docCategoryArray[k];
			
			}
			
			

		}
		sqlwhere=" and id in("+advanids+")";
		params.put("sqlwheread",sqlwhere);
		
	 }

    }


	MultiAclManager am = new MultiAclManager();
	MultiCategoryTree tree = null;
	boolean needQuery = true;
	boolean hasRight = false;
	boolean hasOutput = false;
	if(isFav||isCommon){
		needQuery = false;
	}
	if(needQuery){
		tree = am.getPermittedTree(user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), MultiAclManager.OPERATION_CREATEDOC,categoryname,-1,params);
	}
	JSONObject json = null;
	JSONArray subchildren = null;
	int isOpenNewWind =  Util.getIntValue(request.getParameter("isOpenNewWind"),1); //0:表示不重新弹出窗口 1:表示重新弹出窗口
	if(needQuery){
		if(id<=0){
			subchildren = tree.getTreeCategories();
		}else{
			json = tree.getParentCategory(MultiAclManager.PREFIX+id,tree.getTreeCategories());
			if(json!=null){
				hasRight = !json.getString("hasRight").equalsIgnoreCase("N");
				subchildren = json.getJSONArray("submenus");
			}
		}
	}
	List<Integer> favList = new ArrayList<Integer>();
	if(!isCommon){
		rs.execute("select distinct secid from user_favorite_category a where exists(select 1 from DirAccessControlDetail b where b.sourceid = a.secid and ((type=1 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=2 and content in ("+am.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+")) and b.sharelevel=0 ) and a.usertype='"+user.getLogintype()+"' and a.userid='"+user.getUID()+"' order by secid asc");
	}else if(isCommon){
		if(rs.getDBType().equals("oracle")){
			rs.execute("SELECT distinct * FROM (select secid from DocCategoryUseCount a where exists(select 1 from DirAccessControlDetail b where b.sourceid = a.secid and ((type=1 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=2 and content in ("+am.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+")) and b.sharelevel=0 ) and a.userid='"+user.getUID()+"' order by count desc,secid asc ) WHERE ROWNUM <= 12");
		}else{
			rs.execute("select distinct top 12 * from DocCategoryUseCount a where exists(select 1 from DirAccessControlDetail b where b.sourceid = a.secid and ((type=1 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=2 and content in ("+am.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+")) and b.sharelevel=0 ) and a.userid='"+user.getUID()+"' order by count desc,secid asc");
		}
	}
	while(rs.next()){
		favList.add(rs.getInt(1));	
	}
	//out.println(tree.treeCategories);
	
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET></LINK>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript">
     /*-----显示多岗位-----*/
    function display(li) {
      var subNav = li.getElementsByTagName("ul")[0];
     subNav.style.display = "block";
	 
    }
        /*-----隐藏多岗位-----*/
    function hide(li) {
      
      li.style.display = "none";
	  
    }
	function onBtnSearchClick(val){
		//jQuery("#searchfrm").submit();
		if(!val){
			jQuery("div.e8Tree").show();
		}
		jQuery("div.e8Tree").each(function(){
			var e8Tree = jQuery(this);
			if(e8Tree.text().indexOf(val)==-1){
				e8Tree.hide();
			}else{
				e8Tree.show();
			}
		});
	}
	
	function openNewDocWindow(seccategory){
		jQuery.post("/docs/docs/AddSecIdUseCount.jsp",{secid:seccategory});
        var f_weaver_belongto_userid = jQuery("#f_weaver_belongto_userid").val();
		var f_weaver_belongto_usertype = jQuery("#f_weaver_belongto_usertype").val();
		
		
		if (<%=isOpenNewWind%>==1){
			openFullWindowHaveBar("/docs/docs/DocAdd.jsp?secid="+seccategory+"&<%=queryString%>&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype);
		}else{
			parent.location.href="/docs/docs/DocAdd.jsp?secid="+seccategory+"&<%=queryString%>&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
			if(parent.opener){
				parent.opener.__fromRequest = true;
			}
		}
	}

	function openNewDocWindowBelongs(seccategory,belongsid){
		jQuery.post("/docs/docs/AddSecIdUseCount.jsp",{secid:seccategory});
        var f_weaver_belongto_userid = belongsid;
		var f_weaver_belongto_usertype = jQuery("#f_weaver_belongto_usertype").val();
		
		
		if (<%=isOpenNewWind%>==1){
			openFullWindowHaveBar("/docs/docs/DocAdd.jsp?secid="+seccategory+"&<%=queryString%>&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype);
		}else{
			parent.location.href="/docs/docs/DocAdd.jsp?secid="+seccategory+"&<%=queryString%>&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
			if(parent.opener){
				parent.opener.__fromRequest = true;
			}
		}
	}
	
	function expandMenuNav(obj){
		var _top = jQuery("div.e8ParentNavContent:last").position().top;
		if(!!jQuery(obj).data("_expand")){
			jQuery("div.e8MenuNav").height(30);
			jQuery(obj).data("_expand",false);
		}else{
			jQuery("div.e8MenuNav").height(30+_top);
			jQuery(obj).data("_expand",true);
		}
	}
	
	jQuery(function(){
	
		//jQuery(".e8TreeNewBelongs ul li").click(function(){			
        //   if(jQuery(".e8TreeNewBelongs ul li").eq(0)[0] === jQuery(this)[0]){ 
		//	jQuery("#f_weaver_belongto_userid").val(jQuery(this).children("input").val());   
		//	return;
		//	}
		//   jQuery(".e8TreeNewBelongs ul li").first().before(jQuery(this))
		//   jQuery("#f_weaver_belongto_userid").val(jQuery(this).children("input").val());
					
		
		//})
	
		window.setTimeout(function(){
			try{
				var _top = jQuery("div.e8ParentNavContent:last").position().top;
				if(_top){
					jQuery("div.e8Expand").show();
				}
			}catch(e){}
		},100);
		jQuery(".e8Tree").hover(function(){
			jQuery(this).children(".e8TreeFav").show();
		},function(){
			jQuery(this).children(".e8TreeFav").hide();
		});
			


		
		jQuery(".e8TreeNew").hover(function(){
			jQuery(this).html("<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%>");
		},function(){
			jQuery(this).html("");
		});
		try{
			var id = parseInt("<%=id%>");
			if(id>0){
				parent.selectDefaultNode("categoryid",<%=id%>);
			}else{
				parent.cancelSelectedNode();
			}
		}catch(e){
		}
		jQuery(".e8TreeContent").height(jQuery(window).height()-92);
		jQuery(".e8ParentNav").width(jQuery(window).width()-60);
	});
</script>
<style type="text/css">
   

	.tab_box{
		overflow-y:hidden!important;
	}

	.e8MenuNav{
		position:absolute;
		width:100%;
		height:30px;
		overflow:hidden;
		color:#242424;
		background-color:#f5f5f5;
		vertical-align:middle;
		border-bottom:1px solid #dadada;
		top:61px;
		z-index:1;
	}
	.e8MenuNav .e8Home{
		background-repeat:no-repeat;
		background-position:50% 5px;
		background-image:url(/images/ecology8/newdoc/home_wev8.png);
		height:100%;
		width:30px;
		cursor:pointer;
		top:0px;
		left:0px;
		position:absolute;
	}
	
	.e8MenuNav .e8Expand{
		background-repeat:no-repeat;
		background-position:50% 9px;
		background-image:url(/images/ecology8/newdoc/expand_wev8.png);
		height:100%;
		width:30px;
		cursor:pointer;
		top:0px;
		right:0px;
		position:absolute;
		display:none;
	}
	
	.e8MenuNav .e8ParentNav{
		width:100%;
		height:100%;
		padding-left:30px;
	}
	.e8MenuNav .e8ParentNav .e8ParentNavLine{
		background-image:url(/images/ecology8/newdoc/line_wev8.png);
		background-repeat: no-repeat;
		background-position: 50% 50%;
		width: 20px;
		height:30px;
		float:left;
	}
	.e8MenuNav .e8ParentNav .e8ParentNavContent{
		height:30px;
		line-height:30px;
		float:left;
	}
	
	.e8TreeContent{
		width:100%;
		height:100%;
		position:relative;
		overflow:auto;
		margin-bottom:10px;
	}
	
	.e8TreeContent .e8Tree{
		width:181px;
		height:143px;
		border:1px solid #dadada;
		text-align:center;
		background-image:url(/images/ecology8/newdoc/e8dir_wev8.png);
		background-position:50% 30%;
		background-repeat:no-repeat;
		margin-left:10px;
		margin-top:10px;
		cursor:pointer;
		position:relative;
		float:left;
		overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
	}
	
	.e8TreeContent .e8TreeNew{
		border: 1px dotted #dadada;
		font-size:18px;
		color:#018df5;
		width:181px;
		height:143px;
		margin-left:10px;
		margin-top:10px;
		cursor:pointer;
		position:relative;
		float:left;
		line-height:143px;
		text-align:center;
		background-image:url(/images/ecology8/newdoc/newdoc_wev8.png);
		background-position:50% 50%;
		background-repeat:no-repeat;
	}
	
	.e8TreeContent .e8TreeNew:hover{
		border:1px dotted #149fff;
		background-image:none;
	}
	
	.e8TreeContent .e8Tree:hover{
		background-image:url(/images/ecology8/newdoc/e8dir_hover_wev8.png);
		border:1px solid #149fff;
	}
	
	.e8TreeContent .e8TreeNewBelongs{	  
		border: 0px dotted #dadada;
		font-size:18px;
		color:#018df5;
		width:15px;
		height:15px;
		margin-left:-30px;
		margin-top:130px;		
		cursor:pointer;
		position:relative;
		float:left;	
		background-image:url(/images/ecology8/newdoc/mainsubdoc_wev8.png);
		background-position:50% 50%;
		background-repeat:no-repeat;
	}

	.e8TreeContent .e8TreeNewBelongs  ul{display:none;position:absolute;background:#f5f5f5;border:1px solid #c9c9c9; margin-top:26px;margin-left:25px;left:-148px;padding-left:20px;z-index:200;line-height:20px;}
    .e8TreeContent .e8TreeNewBelongs  ul li{list-style:none; font-size:12px; }
    .e8TreeContent .e8TreeNewBelongs  ul li{width:110px;border-top:0px solid #c9c9c9;text-align:left;background:#f5f5f5;}
    .e8TreeContent .e8TreeNewBelongs  ul li a:hover{background:#f5f5f5;color:#f5f5f5;;margin-top:5px}
    .e8TreeContent .e8TreeNewBelongs  li{float:left;}
	.e8TreeContent .e8Tree .e8TreeName{
		width:100%;
		position:absolute;
		bottom:25px;
		text-align:center;
	}
	
	.e8TreeContent .e8Tree .e8TreeFav{
		width:18px;
		height:18px;
		position:absolute;
		right:10px;
		top:10px;
		cursor:pointer;
		background-position:50% 50%;
		background-repeat:no-repeat;
		display:none;
	}
	
	.e8TreeContent .e8Tree .e8TreeAddFav{
		background-image:url(/images/ecology8/newdoc/addfav_wev8.png);
	}
	
	.e8TreeContent .e8Tree .e8TreeCancelFav{
		background-image:url(/images/ecology8/newdoc/cancelfav_wev8.png);
	}
	
</style>
</head>
<body>
<%
String htmlLabelNames=SystemEnv.getHtmlLabelNames("82,30041",user.getLanguage()); 
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="doc"/>
	   <jsp:param name="navName" value="<%=htmlLabelNames %>"/>
	</jsp:include>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<form action="" name="searchfrm" id="searchfrm">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right;">
					<% if(isuserdeploy) {%>
					<div style="float: left;position: absolute;left: 0%;top: 11px;background-image:url(/rdeploy/assets/img/doc/rbackground.png);width: 100px;height: 23px;text-align: center;" class="middle">
					<a href="/rdeploy/doc/RDocListAjax.jsp" class="" style="position: absolute;top: -11px;left: 15px;" target="_parent">
					<font style="color: white;">
					<%=SystemEnv.getHtmlLabelName(127879,user.getLanguage())%>
					</font>
					</a>
					</div>
					<% } %>
					<input type="text" class="searchInput" name="categoryname" id="categoryname"  value="<%=categoryname %>"/>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
	</form>
	<div class="e8MenuNav">
		<div class="e8ParentNav">
			<div class="e8Home" onclick="javascript:window.location.href='/docs/docs/DocListAjax.jsp?<%=queryString %>';"></div>
			<div class="e8Expand" onclick="javascript:expandMenuNav(this);"></div>
			<%
				if(id>0){
					String secid = ""+id;
					int parentid = Util.getIntValue(scc.getParentId(secid));
					String parentName = Util.null2String(scc.getParentName(secid)); 
					String allParentName = "<div class='e8ParentNavContent'><a href='/docs/docs/DocListAjax.jsp?id="+secid+"&"+queryString+"'>"+Util.null2String(scc.getSecCategoryname(""+id))+"</a></div>";
					String allParentNameLinks = allParentName;
					while(parentid>0){
						allParentName = "<div class='e8ParentNavContent'><a href='/docs/docs/DocListAjax.jsp?id="+parentid+"&"+queryString+"'>"+parentName+"</a></div>";
						parentid = Util.getIntValue(scc.getParentId(""+parentid));
						parentName = Util.null2String(scc.getSecCategoryname(""+parentid)); 
						allParentName += "<div class='e8ParentNavLine'></div>";
						allParentNameLinks = allParentName + allParentNameLinks;
					}
					out.println(allParentNameLinks);
				}
			%>
		</div>
		<div style="height:30px;width:30px;float:right;"></div>
	</div>
	<div style="height:31px;width:100%;"></div>
	<div class="e8TreeContent">
		<div style="height:100%;width:100%;">
			<%if(hasRight || ((isFav||isCommon) && favList.contains(id))){ 
				hasOutput = true;
    HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
	String belongtoids = user.getBelongtoids();

	String account_type = user.getAccount_type();
	boolean mainUseCanNew=false;

if (am.hasPermission(id, MultiAclManager.CATEGORYTYPE_SEC, user.getUID(), user.getType(), Integer.parseInt(user.getSeclevel()), MultiAclManager.OPERATION_CREATEDOC)) {
   mainUseCanNew=true;

}
			%>
				<div class="e8TreeNew" onclick="openNewDocWindow(<%=id %>);"></div>
	<%if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		String[] cnaNewids=Util.TokenizerString2(belongtoids,",");
		 HashMap<String,String> subUseCanNew = new HashMap<String,String>();
	     for(int i=0;i<cnaNewids.length;i++){		 
		 if(am.hasPermission(id, MultiAclManager.CATEGORYTYPE_SEC, Util.getIntValue(cnaNewids[i],0), user.getType(), Integer.parseInt(resourcecominfo.getSeclevel(""+cnaNewids[i])), MultiAclManager.OPERATION_CREATEDOC)){
		   subUseCanNew.put("cnaNew_"+cnaNewids[i],cnaNewids[i]);	     
		  }
		 }

 Set<String> key = subUseCanNew.keySet();
 int bchecked=0;
 int hasrigttnum=0;
 String checkedblongs="";
 int closediv=0;
 if(mainUseCanNew){
    checkedblongs=user.getUID()+"";
	hasrigttnum=1;
 }

 for (Iterator<String> it = key.iterator(); it.hasNext();) {
  String fieldname = (String) it.next();
  String fieldvalue = subUseCanNew.get(fieldname);
  hasrigttnum+=1;
  if(bchecked==0&&!mainUseCanNew){
  checkedblongs=fieldvalue;
 
  }
  if((bchecked==0&&hasrigttnum>1)||(bchecked==0&&hasrigttnum==1&&!mainUseCanNew&&it.hasNext())){
   closediv=1;
 %>
	<div id='nav' class='e8TreeNewBelongs' onmouseover='display(this)'  onclick='display(this)'  ><ul onmouseout='hide(this)'><font style="font-size:13px"><%=SystemEnv.getHtmlLabelNames("17747",user.getLanguage()) %><br/><HR width=130  style=" border:none;border-top:1px solid #c9c9c9;margin:5px 0px 5px 0px;"> </font>
<%
  }
  bchecked+=1;
  if(hasrigttnum>1||(hasrigttnum==1&&!mainUseCanNew&&it.hasNext())){
  %>
<li ><a href='#' onclick='openNewDocWindowBelongs(<%=id %>,<%=fieldvalue%>)'><%=departmentComInfo.getDepartmentname(resourcecominfo.getDepartmentID(fieldvalue))%>/<%=jobTitlesComInfo.getJobTitlesname(resourcecominfo.getJobTitle(fieldvalue))%></a><input id="belongsid" name="belongsid" type="hidden" value="<%=fieldvalue%>"></li>
  <%
  }
 }
	%>
<input id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" type="hidden" value="<%=checkedblongs%>"><input id="f_weaver_belongto_usertype" name="f_weaver_belongto_usertype" type="hidden" value="<%=user.getType()%>"></ul>
<%
if(closediv==1)out.println("</div>");
%>
			<%}}
			if(needQuery){
				if(subchildren!=null){
					JSONObject subdata = null;
					for(int i=0;i<subchildren.length();i++){
						subdata = subchildren.getJSONObject(i);
						JSONObject data = null;
						Iterator<String> it = subdata.keys();
						if(it.hasNext()){
							//System.out.println(it.next());
							String key = it.next();
							data = subdata.getJSONObject(key);
						}
						if(data==null)continue;
				%>
					<div id="sectree_<%= data.getInt("categoryid")%>" class="e8Tree" title="<%=data.getString("name")%>" onclick="location.href='/docs/docs/DocListAjax.jsp?id=<%=data.getInt("categoryid") %>&<%=queryString %>'">
						<div class="e8TreeName"><%=data.getString("name")%></div>
						<%if(!data.getString("hasRight").equals("N")){ 
						%>
							<%if(favList.contains(data.getInt("categoryid"))){ %>
								<%if(isFav){ %>
									<div id="sec_<%= data.getInt("categoryid")%>" _from=1 onclick="javascript:parent.addOrRemoveFav(event,this,0,<%=data.getInt("categoryid") %>);return false;" class="e8TreeFav e8TreeCancelFav" title="<%=SystemEnv.getHtmlLabelNames("19133,18030",user.getLanguage()) %>"></div>
								<%} %>
							<%}else{ %>
								<div  id="sec_<%= data.getInt("categoryid")%>" _from=1 onclick="javascript:parent.addOrRemoveFav(event,this,1,<%=data.getInt("categoryid") %>);return false;" class="e8TreeFav e8TreeAddFav" title="<%=SystemEnv.getHtmlLabelNames("193,18030",user.getLanguage()) %>"></div>
							<%} %>
						<%} %>
					</div>
				<%
					}
				} 
			}else{
				for(int i=0;i<favList.size();i++){
					int secid = favList.get(i);
					String name = scc.getSecCategoryname(""+secid);
					if(id>0){
						if(Util.getIntValue(scc.getParentId(""+secid))!=id)continue;
					}
					hasOutput = true;
			%>
					<div id="sectree_<%= secid%>" class="e8Tree" title="<%=name%>" onclick="location.href='/docs/docs/DocListAjax.jsp?isFav=<%=request.getParameter("isFav") %>&isCommon=<%=request.getParameter("isCommon") %>&id=<%=secid%>'">
						<div class="e8TreeName"><%=name%></div>
						<%if(!isCommon){ %>
							<div id="sec_<%= secid%>"  _from=1 onclick="javascript:parent.addOrRemoveFav(event,this,0,<%=secid%>);return false;" class="e8TreeFav e8TreeCancelFav" title="<%=SystemEnv.getHtmlLabelNames("19133,18030",user.getLanguage()) %>"></div>
						<%} %>
					</div>
			<%
				}
				if(!hasOutput){
					int labelid = 33972;
					if(isFav && id>0){
						labelid = 81730;
					}else if(isCommon){
						labelid = 81731;
						if(id>0){
							labelid = 81732;
						}
					}
					out.println("<div style='width:100%;height:30px;text-align:center;line-height:30px;'>"+SystemEnv.getHtmlLabelName(labelid,user.getLanguage())+"</div>");
				}
			} %>
		</div>
	</div>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
</html>
