<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="FieldManager" class="weaver.workflow.field.FieldManager" scope="session"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetPortal" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
  int textheight=Util.getIntValue(request.getParameter("textheight"),4);//xwj for @td2977 20051107
  String textheight_2 = "";
  String src = Util.null2String(request.getParameter("src"));
  String srcType = Util.null2String(request.getParameter("srcType"));
  int htmltype=Util.getIntValue(request.getParameter("htmltype"),0);
  int htmledit=Util.getIntValue(request.getParameter("htmledit"),0);
  int strlength=Util.getIntValue(request.getParameter("strlength"),0);
  int subCompanyId=Util.getIntValue(request.getParameter("subcompanyid"),-1);
  String cusb = Util.null2String(request.getParameter("cusb"));
  String sapbrowser = Util.null2String(request.getParameter("sapbrowser"));
  String dialog = Util.null2String(request.getParameter("dialog")); //sjh
  //zzl
  String showvalue = Util.null2String(request.getParameter("showvalue"));
  
  String fieldhtmltype=Util.fromScreen(request.getParameter("fieldhtmltype"),user.getLanguage());
  String description = Util.null2String(request.getParameter("description"));//xwj for td2977 20051107
  String fielddbtype="";
  String showprep=Util.null2String(request.getParameter("showprep"));  
  
  String displayname = Util.null2String(request.getParameter("displayname"));//显示名
  String linkaddress = Util.null2String(request.getParameter("linkaddress"));//链接地址
  String descriptivetext = Util.null2String(request.getParameter("descriptivetext"));//描述性文字
  descriptivetext = Util.spacetoHtml(descriptivetext);
  descriptivetext = Util.htmlFilter4UTF8(descriptivetext);
  
  int childfieldid = Util.getIntValue(request.getParameter("childfieldid"),0);
  int imgwidth = Util.getIntValue(request.getParameter("imgwidth"),0);
  int imgheight = Util.getIntValue(request.getParameter("imgheight"),0);
  int decimaldigits = Util.getIntValue(request.getParameter("decimaldigits"),2);
  String locatetype = Util.null2String(request.getParameter("locatetype"));
  //added by pony on 2006-06-14 begin for td4526
  String maincategory = "";
  String subcategory= "";
  String seccategory= "";
  String docPath = "";
  String doccatalog = "";
  //added end.
  boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
  boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
  if(fieldhtmltype.equals("1")){
	  if(htmltype==1)	{
          if(isoracle) fielddbtype="varchar2("+strlength+")";
          else fielddbtype="varchar("+strlength+")";
      }
	  if(htmltype==2)	{
          if(isoracle) fielddbtype="integer";
          else fielddbtype="int";
      }
	  if(htmltype==3)	{
          if(isoracle) fielddbtype="number(15,"+decimaldigits+")";
          else fielddbtype="decimal(15,"+decimaldigits+")";
      }
    if(htmltype==4)	{//added by xwj for td3131 20051115
         if(isoracle) fielddbtype="number(15,2)";
         else fielddbtype="decimal(15,2)";
    }
    if(htmltype==5){
        if(isoracle) fielddbtype="varchar2(30)";
        else fielddbtype="varchar(30)";
    }
  }
  if(fieldhtmltype.equals("3")){
	  htmltype = Util.getIntValue(request.getParameter("browsetbuttonype"),0);
  	if(htmltype>0)
  		fielddbtype=BrowserComInfo.getBrowserdbtype(htmltype+"");
  	if(htmltype==118){
  		if(isoracle) fielddbtype="varchar2(200)";
          else fielddbtype="varchar(200)";
  	}
	if(htmltype==161||htmltype==162)
		fielddbtype=cusb;
	if(htmltype==224||htmltype==225){
		fielddbtype=sapbrowser;
	}
	if(htmltype==226||htmltype==227){
		fielddbtype=showvalue;
	}
	if(htmltype==17){
		if(isoracle){
			fielddbtype="clob";
		}else if(isdb2){
			fielddbtype="varchar(2000)";
		}else{
			fielddbtype="text";
		}
	}
	
    if(htmltype==165||htmltype==166||htmltype==167||htmltype==168) textheight_2=showprep;  
  }
  if(fieldhtmltype.equals("2"))	{
      //if(isoracle) fielddbtype="varchar2(4000)";
	   //else if(isdb2) fielddbtype="varchar(2000)";
      //else fielddbtype="text";
		if (htmledit!=0) htmltype=htmledit;
		if(isoracle) {
			if(htmltype!=0 && htmltype!=1) {
				fielddbtype="clob";
			} else {
				fielddbtype="varchar2(4000)";
			}
		} else if(isdb2) {
			fielddbtype="varchar(2000)";
		} else {
			fielddbtype="text";
		}
  }
  if(fieldhtmltype.equals("4"))	fielddbtype="char(1)";
  if(fieldhtmltype.equals("5"))	{
      if(isoracle) fielddbtype="integer";
      else fielddbtype="int";
  }
  if(fieldhtmltype.equals("6"))	{
	  htmltype=Util.getIntValue(request.getParameter("filehtmltype"),0);
      if(isoracle) fielddbtype="varchar2(4000)";
	  else if(isdb2) fielddbtype="varchar(2000)";
      else fielddbtype="text";
      textheight=strlength;
  }
  if(fieldhtmltype.equals("7"))	{
	  htmltype=Util.getIntValue(request.getParameter("specialhtmltype"),0);
      if(isoracle) fielddbtype="varchar2(4000)";
	  else if(isdb2) fielddbtype="varchar(2000)";
      else fielddbtype="text";
  }
  if(fieldhtmltype.equals("9")){
	if(isoracle) fielddbtype="clob";
	else fielddbtype="text";
  }
////得到标记信息
  if(src.equalsIgnoreCase("addfield")){
	FieldManager.reset();
  	FieldManager.setAction("addfield");
  	FieldManager.setFieldname(Util.null2String(request.getParameter("fieldname")));
  	FieldManager.setFielddbtype(fielddbtype);
  	FieldManager.setFieldhtmltype(fieldhtmltype);
  	FieldManager.setType(htmltype);
  	FieldManager.setSubCompanyId2(subCompanyId);
  	FieldManager.setDescription(description);//xwj for td2977 20051107
  	FieldManager.setTextheight(textheight);//xwj for @td2977 20051107
  	FieldManager.setTextheight_2(textheight_2);
  	FieldManager.setChildfieldid(childfieldid);
    FieldManager.setImgwidth(imgwidth);
    FieldManager.setImgheight(imgheight);
    FieldManager.setQfwws(""+decimaldigits);
    FieldManager.setLocatetype(locatetype);
      String message = "";
      if(srcType.equals("mainfield")){
          message = FieldManager.setFieldInfo();
      }else if(srcType.equals("detailfield")){
          message = FieldManager.setDetailFieldInfo();
      }
      if(message.equals("1")){
          response.sendRedirect("addfield.jsp?srcType="+srcType+"&message="+message+"&dialog=1");
          return;
      }
      if(srcType.equals("mainfield")){
          FieldComInfo.removeFieldCache();
      }else if(srcType.equals("detailfield")){
          DetailFieldComInfo.removeFieldCache();
      }


	//操作workflow_selectitem表
	String isAccordToSubComFieldid ="";
	String openrownum="";
	boolean isToEditSubComFieldid=false;
	if(fieldhtmltype.equals("5")){
		int i=0;
		int curvalue=0;
		String isdefault ="n"; //xwj for td2977 20051107
		int rowsum = Util.getIntValue(Util.null2String(request.getParameter("selectsnum")));
		 openrownum= Util.null2String(request.getParameter("openrownum"));
		out.print("rowsum ="+rowsum);
		for(i=0;i<rowsum;i++){
		//added by pony on 2006-06-14 begin for td4526
		doccatalog = Util.null2String(request.getParameter("maincategory"+i));
		docPath = Util.null2String(request.getParameter("pathcategory"+i));
  	    //added end.
      String curorder=Util.fromScreen(request.getParameter("field_count_"+i+"_name"),user.getLanguage());//xwj for td2977 20051107
			String curcheck=Util.fromScreen(request.getParameter("field_checked_"+i+"_name"),user.getLanguage());//xwj for td2977 20051107
			isdefault = ("1".equals(curcheck))?"y":"n";//xwj for td2977 20051107
			String curname=Util.fromScreen(request.getParameter("field_"+i+"_name"),user.getLanguage());
			String childItem = Util.null2String(request.getParameter("childItem"+i));
			String isAccordToSubCom = Util.null2String(request.getParameter("isAccordToSubCom"+i));
			if(isAccordToSubCom.equals("")){
				isAccordToSubCom="0";
			}
			if(isAccordToSubCom.equals("1")){
				isToEditSubComFieldid=true;
			}
			char flag=2;
			if(!curname.equals("")){
				String sql="";
                sql = "select max(id) from workflow_formdict";
                if(srcType.equals("mainfield")){
                    sql = "select max(id) from workflow_formdict";
                }else if(srcType.equals("detailfield")){
                    sql = "select max(id) from workflow_formdictdetail";
                }
				RecordSet.executeSql(sql);
				RecordSet.next();
				String curfieldid=RecordSet.getString(1);
				isAccordToSubComFieldid=curfieldid;
				String para=curfieldid+flag+"0"+flag+""+curvalue+flag+curname+flag+curorder+flag+isdefault;//xwj for td2977 20051107
				RecordSet.executeProc("workflow_SelectItem_Insert",para);
				String docsql = "update workflow_selectItem set docpath='"+docPath+"', docCategory='"+doccatalog+"', childitemid='"+childItem+"', isAccordToSubCom='"+isAccordToSubCom+"' where fieldid="+curfieldid+" and isBill=0 and selectvalue="+curvalue;
				RecordSet.executeSql(docsql);
				curvalue++;
			}
		}
    }

	if(fieldhtmltype.equals("7")){
	  	String sql = "select max(id) from workflow_formdict";
		RecordSet.executeSql(sql);
		RecordSet.next();
		String curfieldid=RecordSet.getString(1);
	
	    if(htmltype==1){
	         sql = "insert into workflow_specialfield(fieldid,displayname,linkaddress,isform,isbill) values("+curfieldid+",'"+displayname+"','"+linkaddress+"',1,0)";    
	    }else{
	         sql = "insert into workflow_specialfield(fieldid,descriptivetext,isform,isbill) values("+curfieldid+",'"+descriptivetext+"',1,0)";    
	    }
		RecordSet.executeSql(sql);	
	}
      if(srcType.equals("mainfield")){

      	  //if("1".equals(dialog)){
			if(fieldhtmltype.equals("5")&&isToEditSubComFieldid){
					response.sendRedirect("addfield.jsp?src=editfield&fieldid="+isAccordToSubComFieldid+"&isused=false&dialog=1&isclose=0&srcType="+srcType+"&openrownum="+openrownum);
			}else{
      	  	response.sendRedirect("addfield.jsp?isclose=1&srcType="+srcType);
			}
      	  //}else{
      	  //	response.sendRedirect("managefield.jsp");
      	  //}
      }else if(srcType.equals("detailfield")){
      	  //if("1".equals(dialog)){
      	  if(fieldhtmltype.equals("5")&&isToEditSubComFieldid){
					response.sendRedirect("addfield.jsp?src=editfield&fieldid="+isAccordToSubComFieldid+"&isused=false&dialog=1&isclose=0&srcType="+srcType+"&openrownum="+openrownum);
			}else{
      	  	response.sendRedirect("addfield.jsp?isclose=1&srcType="+srcType);
			}
      	  //}else{
      	  //	response.sendRedirect("managedetailfield.jsp");
      	  //}
      }

	return;
  }
  else if(src.equalsIgnoreCase("editfield")){
  	int fieldid=Util.getIntValue(Util.null2String(request.getParameter("fieldid")),0);

    //modify by xhheng @ 20041222 for TDID 1230
    String isused=Util.null2String(request.getParameter("isused"));
    if(isused.equals("true") && fieldhtmltype.equals("7") && htmltype == 0){
    	htmltype=Util.getIntValue(request.getParameter("specialhtmltype1"),0);
    }
	FieldManager.reset();
  	FieldManager.setAction("editfield");
  	FieldManager.setFieldid(fieldid);
	FieldManager.setLanguageid(user.getLanguage());
  	FieldManager.setFieldname(Util.null2String(request.getParameter("fieldname")));
  	FieldManager.setFielddbtype(fielddbtype);
  	FieldManager.setFieldhtmltype(fieldhtmltype);
      FieldManager.setType(htmltype);
      FieldManager.setSubCompanyId2(subCompanyId);
      FieldManager.setDescription(description);//xwj for td2977 20051107
      FieldManager.setTextheight(textheight);//xwj for @td2977 20051107
      FieldManager.setTextheight_2(textheight_2);
      FieldManager.setChildfieldid(childfieldid);
      FieldManager.setImgwidth(imgwidth);
    FieldManager.setImgheight(imgheight);
    FieldManager.setQfwws(""+decimaldigits);
    FieldManager.setLocatetype(locatetype);
      String message ="";
      if(srcType.equals("mainfield")){
          message = FieldManager.setFieldInfo();


      }else if(srcType.equals("detailfield")){
          message = FieldManager.setDetailFieldInfo();
      }
      //System.out.println("message = " + message);
      if(message.equals("1")){
        //modify by xhheng @ 20041222 for TDID 1230
        response.sendRedirect("addfield.jsp?srcType="+srcType+"&src=editfield&fieldid="+fieldid+"&message="+message+"&isused="+isused+"&dialog=1");
      }else if(message.equals("2")){
        //modify by xhheng @ 20041222 for TDID 1230
        response.sendRedirect("addfield.jsp?srcType="+srcType+"&src=editfield&fieldid="+fieldid+"&message="+message+"&isused="+isused+"&dialog=1");
      }
      if(srcType.equals("mainfield")){
          FieldComInfo.removeFieldCache();
      }else if(srcType.equals("detailfield")){
          DetailFieldComInfo.removeFieldCache();
      }

    //操作workflow_selectitem表
	if(fieldhtmltype.equals("5")){
		char flag=2;
		String para="";
    /*--------Modified by xwj for td3286 ---------    B E G I N   -----------*/
    int rowsum = Util.getIntValue(Util.null2String(request.getParameter("selectsnum")));
		int i=0;
		int curvalue=0;
		String id = "";
		ArrayList arrids = new ArrayList();
		ArrayList indexs = new ArrayList();
		String isdefault = "n";//xwj for td2977 20051107
		String curname="";
		String curorder="";
		String curcheck="";
		String childItem="";
		String cancel="";
		String isAccordToSubCom="";
		for(int a=0;a<rowsum;a++){
		doccatalog = Util.null2String(request.getParameter("maincategory"+a));
		docPath = Util.null2String(request.getParameter("pathcategory"+a));
		id = Util.fromScreen(request.getParameter("field_id_"+a+"_name"),user.getLanguage());
		if(id!=null && !"".equals(id)){
		arrids.add(id);
		indexs.add(String.valueOf(a));
		curname=Util.fromScreen(request.getParameter("field_"+a+"_name"),user.getLanguage());
		curorder=Util.fromScreen(request.getParameter("field_count_"+a+"_name"),user.getLanguage());
		curcheck=Util.fromScreen(request.getParameter("field_checked_"+a+"_name"),user.getLanguage());
		childItem=Util.null2String(request.getParameter("childItem"+a));
		isAccordToSubCom=Util.null2String(request.getParameter("isAccordToSubCom"+a));
		if(isAccordToSubCom.equals("")){
			isAccordToSubCom="0";
		}
		isdefault = ("1".equals(curcheck))?"y":"n"; 
		cancel=Util.fromScreen(request.getParameter("cancel_"+a+"_name"),user.getLanguage());
		if(cancel!=null && !cancel.equals("") && cancel.equals("1")){
			cancel = "1";
		}else{
			cancel = "0";
		}
		RecordSet.executeSql("update workflow_SelectItem set selectname = '" + curname + "',isdefault = '" + isdefault + "',listorder = " + curorder + ", docPath='" + docPath + "', docCategory='" + doccatalog  + "', cancel='" + cancel + "', childitemid='"+childItem+"' where id = "+id);
		}
		} 
    RecordSet.executeSql("select id from workflow_SelectItem where fieldid = "+fieldid + " and isbill = 0 order by selectvalue desc");
		while(RecordSet.next()){
		id = RecordSet.getString("id");
		if(!arrids.contains(id)){
		RecordSet.executeSql("delete workflow_SelectItem where fieldid = "+fieldid + " and isbill = 0 and id =" + id);
		}
		}
		RecordSet.executeSql("select selectvalue from workflow_SelectItem where fieldid = "+fieldid + " and isbill = 0 order by selectvalue desc");
		if(RecordSet.next()){
		curvalue = RecordSet.getInt("selectvalue") + 1;
		}
		for(i=0;i<rowsum;i++){
				//added by pony on 2006-06-14 begin for td4526
		doccatalog = Util.null2String(request.getParameter("maincategory"+i));
		docPath = Util.null2String(request.getParameter("pathcategory"+i));
  	    //added end.
			curname=Util.fromScreen(request.getParameter("field_"+i+"_name"),user.getLanguage());
			/*---- xwj for td2977 20051107 begin ---*/
			curorder=Util.fromScreen(request.getParameter("field_count_"+i+"_name"),user.getLanguage());
			childItem=Util.null2String(request.getParameter("childItem"+i));
			isAccordToSubCom=Util.null2String(request.getParameter("isAccordToSubCom"+i));
			if(isAccordToSubCom.equals("")){
				isAccordToSubCom="0";
			}
			if("".equals(curorder) || curorder == null){
			curorder = "0";
			}
			curcheck=Util.fromScreen(request.getParameter("field_checked_"+i+"_name"),user.getLanguage());
				cancel=Util.fromScreen(request.getParameter("cancel_"+i+"_name"),user.getLanguage());
			if(cancel!=null && !cancel.equals("") && cancel.equals("1")){
				cancel = "1";
			}else{
				cancel = "0";
			}
			isdefault = ("1".equals(curcheck))?"y":"n";
			if(!curname.equals("") && !indexs.contains(String.valueOf(i))){
				para=""+fieldid+flag+"0"+flag+""+curvalue+flag+curname+flag+curorder+flag+isdefault +flag+cancel;
			/*---- xwj for td2977 20051107 end ---*/
				RecordSet.executeProc("workflow_selectitem_insert_new",para); 
				String docsql1 = "update workflow_selectItem set docpath='"+docPath+"', docCategory='"+doccatalog+"', childitemid='"+childItem+"', isAccordToSubCom='"+isAccordToSubCom+"' where fieldid="+fieldid+" and selectvalue="+curvalue;
		     	RecordSet.executeSql(docsql1);
				 curvalue++;
			}
		}
	}
      /*--------Modified by xwj for td3286 --------- E N D	 -----------*/

	if(fieldhtmltype.equals("7")){
		String sql = "";
		sql = "select fieldid from workflow_specialfield where fieldid = " + fieldid + " and isform = 1";
		RecordSet.executeSql(sql);	
		if(RecordSet.next()){
			if(htmltype==1){
				sql = "update workflow_specialfield set displayname = '"+displayname+"',linkaddress = '"+linkaddress+"' where fieldid = " + fieldid + " and isform = 1";
			}else{
				sql = "update workflow_specialfield set descriptivetext = '"+descriptivetext+"' where fieldid = " + fieldid + " and isform = 1";
			}
		}else{
			if(htmltype==1){
				sql = "insert into workflow_specialfield(fieldid,displayname,linkaddress,isform,isbill) values("+fieldid+",'"+displayname+"','"+linkaddress+"',1,0)";    
			}else{
				sql = "insert into workflow_specialfield(fieldid,descriptivetext,isform,isbill) values("+fieldid+",'"+descriptivetext+"',1,0)";    
			}
		}
		RecordSet.executeSql(sql);
	}

      if(srcType.equals("mainfield")){
          if("1".equals(dialog)){
      	  	response.sendRedirect("addfield.jsp?isclose=1&srcType="+srcType);
      	  }else{
      	  	response.sendRedirect("managefield.jsp");
      	  }
      }else if(srcType.equals("detailfield")){
      	  if("1".equals(dialog)){
      	  	response.sendRedirect("addfield.jsp?isclose=1&srcType="+srcType);
      	  }else{
      	  	response.sendRedirect("managedetailfield.jsp");
      	  }
      }
	return;
  }response.sendRedirect("managefield.jsp");
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">