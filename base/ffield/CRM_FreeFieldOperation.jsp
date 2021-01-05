
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.BaseBean" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%> 
<%@page import="weaver.conn.RecordSet"%> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CRMFreeFieldManage" class="weaver.crm.Maint.CRMFreeFieldManage" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />	
<jsp:useBean id="CrmFieldComInfo" class="weaver.crm.util.CrmFieldComInfo" scope="page" />	
<jsp:useBean id="CrmExcelToDB" class="weaver.crm.ExcelToDB.CrmExcelToDB" scope="page" />	
<%
	String usetable = Util.null2String(request.getParameter("usetable"));
	boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
	boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
	boolean issqlserver = (RecordSet.getDBType()).equals("sqlserver") ;
	String method = Util.null2String(request.getParameter("method"));
	int message = 1;
	
	User user = HrmUserVarify.getUser (request , response) ;
	boolean canedit = false;
	if(usetable.equals("CRM_CustomerInfo")){
		canedit = HrmUserVarify.checkUserRight("CustomerAccountFreeFeildEdit:Edit", user);
	}else if(usetable.equals("CRM_CustomerContacter")){
		canedit = HrmUserVarify.checkUserRight("CustomerContactorFreeFeildEdit:Edit", user);
	}else if(usetable.equals("CRM_CustomerAddress")){
		canedit = HrmUserVarify.checkUserRight("CustomerAddressFreeFeildEdit:Edit", user);
	}else if(usetable.equals("CRM_SellChance")){
		canedit = HrmUserVarify.checkUserRight("CustomerAddressFreeFeildEdit:Edit", user);
	}
	if(!canedit){
		response.sendRedirect("/notice/noright.jsp") ;
	}
	
	if(method.equals("savefieldbatch")){
		Map map =new HashMap();
		map.put("CRM_CustomerInfo",5);
		map.put("CRM_CustomerContacter",5);
		map.put("CRM_CustomerAddress",5);
		RecordSetTrans.setAutoCommit(false);
		
		try{
			String maintablename = usetable;
			int recordNum = Util.getIntValue(Util.null2String(request.getParameter("recordNum")),0);//字段行数
		  	String delids = Util.null2String(request.getParameter("delids"));//删除行id集
		  	String changeRowIndexs = Util.null2String(request.getParameter("changeRowIndexs"));//有改变的行id集
		  	String labelidsCache = ",";//更新缓存用
		  	
		  	ArrayList delidsArray = Util.TokenizerString(delids,",");
		  	for(int i=0;i<delidsArray.size();i++){//删除指定的字段
		  		
		  		String fieldnameForDel = "";
		  		String delFieldId = (String)delidsArray.get(i);
		  		
		  		RecordSetTrans.executeSql("select fieldname from CRM_CustomerDefinField where id="+delFieldId);
		  		if(RecordSetTrans.next()) {
		  		   fieldnameForDel = RecordSetTrans.getString("fieldname");//取得字段名
		  		}
		  		
		  		if(isoracle){
		  		   String sql1="select * from ALL_TAB_COLS A  where lower(A.Table_Name) = lower('"+maintablename+"')  and lower(A.COLUMN_NAME)=lower('"+fieldnameForDel+"')";
		  		   RecordSetTrans.executeSql(sql1);
		  		   if(RecordSetTrans.next()) {
		  		     RecordSetTrans.executeSql("alter table "+maintablename+" drop column "+fieldnameForDel);//修改表结构
		  		   } 
		  		}else{
		  		     RecordSetTrans.executeSql("alter table "+maintablename+" drop column "+fieldnameForDel);//修改表结构
		  		}
		  		//清除显示定制列中的数据，清除system_default_col和user_default_col中的显示列
				if("CRM_CustomerInfo".equals(usetable)){
					RecordSet.executeSql("select id from system_default_col where pageid='CRM:CustomerListInfo' and name='"+fieldnameForDel+"'");
					String id = "";
					while(RecordSet.next()){
						if("".equals(id))
							id+=RecordSet.getString("id");
						else
							id+=","+RecordSet.getString("id");
					}
					RecordSet.executeSql("delete from user_default_col where pageid='CRM:CustomerListInfo' and systemid in("+id+")");
					RecordSet.executeSql("delete from system_default_col where pageid='CRM:CustomerListInfo' and name='"+fieldnameForDel+"'");
				}
		  		
		  		RecordSetTrans.executeSql("delete from CRM_CustomerDefinField where id="+delFieldId);//删除字段
		  		RecordSetTrans.executeSql("delete from crm_selectitem where fieldid = "+delFieldId);//删除可能存在的下拉框值
		  	}

		  	ArrayList changeRowIndexsArray = Util.TokenizerString(changeRowIndexs,",");
		  	//System.err.println("changeRowIndexsArray=="+changeRowIndexs);
		  	for(int i=0;i<changeRowIndexsArray.size();i++){//修改有改变的行(包括新增行和编辑行)
		  		String index = (String)changeRowIndexsArray.get(i);
		  		String new_OR_modify = Util.null2String(request.getParameter("modifyflag_"+index));//即数据库CRM_CustomerDefinField的id值
		  		String fieldname = Util.null2String(request.getParameter("itemDspName_"+index));//数据库字段名称
	  			if(fieldname.equals("")) continue;//先添加后删除的
	  			
	            /*************处理标签开始********************/
	            int fieldlabel = 0;//字段显示名标签id
	  			String fieldlabelname = Util.null2String(request.getParameter("itemFieldName_"+index));
	  			fieldlabelname = Util.StringReplace(fieldlabelname, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
	  			if(issqlserver) RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldlabelname+"' collate Chinese_PRC_CS_AI and languageid="+Util.getIntValue(""+user.getLanguage(),7));
			  	else RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldlabelname+"' and languageid="+Util.getIntValue(""+user.getLanguage(),7));
			  	if(RecordSetTrans.next()) fieldlabel = RecordSetTrans.getInt("indexid");//如果字段名称在标签库中存在，取得标签id
			  	else{
			  		fieldlabel = CRMFreeFieldManage.getNewIndexId(RecordSetTrans);//生成新的标签id
				  	if(fieldlabel!=-1){//更新标签库
				  		labelidsCache+=fieldlabel+",";
				  		RecordSetTrans.executeSql("delete from HtmlLabelIndex where id="+fieldlabel);
				  		RecordSetTrans.executeSql("delete from HtmlLabelInfo where indexid="+fieldlabel);
				  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelIndex values("+fieldlabel+",'"+fieldlabelname+"')");
				  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+fieldlabel+",'"+fieldlabelname+"',7)");
				  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+fieldlabel+",'"+fieldlabelname+"',8)");
				  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+fieldlabel+",'"+fieldlabelname+"',9)");
				  	}
				}
			  	/*************处理标签结束********************/
			  	
			  	
			  	String fielddbtype = "";//字段数据库类型
	  			String _fielddbtype = "";//字段数据库类型
	  			String fieldhtmltype = Util.null2String(request.getParameter("itemFieldType_"+index));//字段页面类型
	  			String type = "";//字段详细类型 【子类型】
	  			String viewtype = "0";//viewtype="0"表示主表字段,viewtype="1"表示明细表字段
	  			//String usetable = "";//被使用表名
	  			int textheight = 0;//多行文本框的高度
	  			
	  			int  places=0;
	  			
	  			int imgwidth = Util.getIntValue(request.getParameter("imgwidth_"+index),0);//上传图片的宽度
	            int imgheight = Util.getIntValue(request.getParameter("imgheight_"+index),0);//上传图片的高度
	            String dmlUrl = "";
	
				if(fieldhtmltype.equals("1")){
					
				  	type = Util.null2String(request.getParameter("documentType_"+index));	
				  	if(type.equals("1")){
					  	String strlength = Util.null2String(request.getParameter("itemFieldScale1_"+index));
					  	if(Util.getIntValue(strlength,1)<=1) strlength = "1";
				    	if(isoracle) fielddbtype="varchar2("+strlength+")";
				    	else fielddbtype="varchar("+strlength+")";
				    	
				    	/**************************************************************
				    	if(!new_OR_modify.equals("")){
				    		
				    	    String oldfielddbtype = "";
				    	    RecordSetTrans.executeSql("select fielddbtype from CRM_CustomerDefinField where id="+new_OR_modify);
				    	    if(RecordSetTrans.next()) oldfielddbtype = RecordSetTrans.getString("fielddbtype");
				    	    if(!fielddbtype.equals(oldfielddbtype)){
				    	        if(isoracle) RecordSetTrans.executeSql("ALTER TABLE "+maintablename+" MODIFY "+fieldname+" "+fielddbtype);
				    	        else RecordSetTrans.executeSql("ALTER TABLE "+maintablename+" ALTER COLUMN "+fieldname+" "+fielddbtype);
				    	    }
				    	}
				    	**************************************************************/
					}
				  	if(type.equals("2")){
				   		if(isoracle) fielddbtype="integer";
				   		else fielddbtype="int";
				   	}
					if(type.equals("3")){
						int decimaldigits = Util.getIntValue(request.getParameter("decimaldigits_"+index),2);
						if(isoracle) fielddbtype="number(15,"+decimaldigits+")";
					   	else fielddbtype="decimal(15,"+decimaldigits+")";
						
						/**************************************************************
				   		if(!new_OR_modify.equals("")){
							//对浮点型字段的小数点倍数进行修改时候，需要同时修改表单数据存储表中的字段字义
							String oldfielddbtype = "";
							RecordSetTrans.executeSql("select fielddbtype from CRM_CustomerDefinField where id="+new_OR_modify);
							if(RecordSetTrans.next()) oldfielddbtype = RecordSetTrans.getString("fielddbtype");
							if(!fielddbtype.equals(oldfielddbtype)){
								if(isoracle) RecordSetTrans.executeSql("ALTER TABLE "+maintablename+" MODIFY "+fieldname+" "+fielddbtype);
								else RecordSetTrans.executeSql("ALTER TABLE "+maintablename+" ALTER COLUMN "+fieldname+" "+fielddbtype);
							
							}
				   		}
						**************************************************************/
			 	 	}
					if(type.equals("4")){
				   		if(isoracle) fielddbtype="number(15,2)";
				   		else fielddbtype="decimal(15,2)";
						}
				   	if(type.equals("5")){
				   		int decimaldigits = Util.getIntValue(request.getParameter("decimaldigits_"+index),2);
				   		if(isoracle) fielddbtype="varchar2(30)";
				   		else fielddbtype="varchar(30)";
				   		places=decimaldigits;
					}
				   	
				}
				
				if(fieldhtmltype.equals("2")){
					type = "1";
					if(isoracle) fielddbtype="varchar2(4000)";
					else if(isdb2) fielddbtype="varchar(2000)";
					else fielddbtype="text";
					textheight = Util.getIntValue(Util.null2String(request.getParameter("textheight_"+index)),4);
				}
				
				if(fieldhtmltype.equals("3")){
				  	int temptype = Util.getIntValue(Util.null2String(request.getParameter("broswerType_"+index)),0);
				  	type = ""+temptype;
				  	if(temptype>0)
				  		fielddbtype=BrowserComInfo.getBrowserdbtype(type+"");
				  	if(temptype==118){
				  		if(isoracle) fielddbtype="varchar2(200)";
						else fielddbtype="varchar(200)";
				  	}
					if(temptype==161||temptype==162){
						dmlUrl=Util.null2String(request.getParameter("custombrow_"+index));
						if(temptype==161){
							if(isoracle) _fielddbtype="varchar2(1000)";
							else if(isdb2) _fielddbtype="varchar(1000)";
							else _fielddbtype="varchar(1000)";
						}else{
							if(isoracle) _fielddbtype="varchar2(4000)";
							else if(isdb2) _fielddbtype="varchar(2000)";
							else _fielddbtype="text";
						}
						fielddbtype = _fielddbtype;
					}
					if(temptype==224||temptype==225){
						fielddbtype=Util.null2String(request.getParameter("sapbrowser_"+index));
						if(temptype==224){
							if(isoracle) _fielddbtype="varchar2(1000)";
							else if(isdb2) _fielddbtype="varchar(1000)";
							else _fielddbtype="varchar(1000)";
						}else{
							if(isoracle) _fielddbtype="varchar2(4000)";
							else if(isdb2) _fielddbtype="varchar(2000)";
							else _fielddbtype="text";
						}
					}
					
					if(temptype==226||temptype==227){
						fielddbtype=Util.null2String(request.getParameter("showvalue_"+index));
						if(temptype==226){
							if(isoracle) _fielddbtype="varchar2(1000)";
							else if(isdb2) _fielddbtype="varchar(1000)";
							else _fielddbtype="varchar(1000)";
						}else{
							if(isoracle) _fielddbtype="varchar2(4000)";
							else if(isdb2) _fielddbtype="varchar(2000)";
							else _fielddbtype="text";
						}
					}
					if(temptype==165||temptype==166||temptype==167||temptype==168) 
					  	textheight=Util.getIntValue(Util.null2String(request.getParameter("decentralizationbroswerType_"+index)),0); 
				}
				if(fieldhtmltype.equals("4")){
				  	type = "1";
				  	fielddbtype="char(1)";
				}
				if(fieldhtmltype.equals("5"))	{
				  	type = "1";
				  	if(isoracle) fielddbtype="integer";
				  	else fielddbtype="int";
				}
				if(fieldhtmltype.equals("6"))	{
				  	//type = "" + Util.getIntValue(Util.null2String(request.getParameter("uploadtype_"+index)), 1);
				  	type = "1";
				    if(isoracle) fielddbtype="varchar2(4000)";
					else if(isdb2) fielddbtype="varchar(2000)";
				    else fielddbtype="varchar(2000)";
	                textheight = Util.getIntValue(Util.null2String(request.getParameter("strlength_"+index)), 0);  
				}
				  if(fieldhtmltype.equals("7"))	{
				  	type = Util.null2String(request.getParameter("specialfield_"+index));
				    if(isoracle) fielddbtype="varchar2(4000)";
					else if(isdb2) fielddbtype="varchar(2000)";
				    else fielddbtype="varchar(2000)";
				}	
			
	  			String groupid = Util.null2String(request.getParameter("groupid_"+index));
	  			String isopen = Util.null2String(request.getParameter("isopen_"+index));//是否启用 0-不启用(默认) 1-启用
	  			String ismust = Util.null2String(request.getParameter("ismust_"+index));//是否必填 0-不必填(默认) 1-必填
	  			String issearch = Util.null2String(request.getParameter("issearch_"+index));//是否为搜索条件 0--不作为 1--作为
	  			String isdisplay = Util.null2String(request.getParameter("isdisplay_"+index));//是否为客户列表显示字段 0--不作为 1--作为
	  			String isexport = Util.null2String(request.getParameter("isexport_"+index));//是否为客户导出字段 0--不作为 1--作为
                String isfixed = Util.null2String(request.getParameter("isfixed_"+index));//是否为数据库已存在字段
                if("id".equals(fieldname)&& "1".equals(isfixed)) throw new Exception();
	  			//if(dsporder.equals("")) dsporder="0";
				if(!new_OR_modify.equals("")){//不为空表示是编辑字段，为空表示新添加字段。
				  	String oldfieldname = "";
				  	String oldfielddbtype = "";
				  	RecordSetTrans.executeSql("select fieldname,fielddbtype from CRM_CustomerDefinField where id="+new_OR_modify);
				  	if(RecordSetTrans.next()){
				  	    oldfieldname = RecordSetTrans.getString("fieldname");
				  	    oldfielddbtype = RecordSetTrans.getString("fielddbtype");
				  	}
					String dmlurlstr = "";
					if(dmlUrl != null && !"".equals(dmlUrl))  dmlurlstr = "dmlUrl='"+dmlUrl+"',";
					//如果isdisplay=0，则清除system_default_col和user_default_col中的显示列
					if("CRM_CustomerInfo".equals(usetable)&&!"1".equals(isdisplay)){
						RecordSet.executeSql("select id from system_default_col where pageid='CRM:CustomerListInfo' and name='"+fieldname+"'");
						String id = "";
						while(RecordSet.next()){
							if("".equals(id))
								id+=RecordSet.getString("id");
							else
								id+=","+RecordSet.getString("id");
						}
						RecordSet.executeSql("delete from user_default_col where pageid='CRM:CustomerListInfo' and systemid in("+id+")");
						RecordSet.executeSql("delete from system_default_col where pageid='CRM:CustomerListInfo' and name='"+fieldname+"'");
						
					}
					
					RecordSetTrans.executeSql("update CRM_CustomerDefinField set "+dmlurlstr+" fieldname='"+fieldname+"',fieldlabel="+fieldlabel+",fielddbtype='"+fielddbtype+"',fieldhtmltype="+fieldhtmltype+",type="+type+",viewtype="+viewtype+",usetable='"+usetable+"',textheight="+textheight+",imgwidth="+imgwidth+",imgheight="+imgheight+",isopen='"+isopen+"',ismust='"+ismust+"',issearch='"+issearch+"',isdisplay='"+isdisplay+"',isexport='"+isexport+"',places='"+places+"' , groupid = '"+groupid+"' where id="+new_OR_modify);
				  	//更改列名
				  	if(!oldfieldname.equals(fieldname)){
				  		if(isoracle) RecordSetTrans.execute("alter table "+usetable+" rename colun "+oldfieldname+" to "+fieldname);
				  		else if(issqlserver) RecordSetTrans.execute("exec sp_rename '"+usetable+"."+oldfieldname+"' , '"+fieldname+"' , 'column'");
				  		
				  	}
				  	
				  	
				  	/**************************************************************
				  	if(!fieldname.equals(oldfieldname)||(!fielddbtype.equals(oldfielddbtype) && !"1".equals(fieldhtmltype) && !"".equals(type))){//修改了数据库字段名称或类型
				  		RecordSetTrans.executeSql("select "+oldfieldname+" from "+maintablename + " where " + oldfieldname + " is not NULL");
				  		if(!RecordSetTrans.next()){
				  			RecordSetTrans.executeSql("alter table "+maintablename+" drop column "+oldfieldname);
				  	    	if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))){
				  	        RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
					  	    }else if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225"))){
					  	        RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
					  	    }else if(fieldhtmltype.equals("3")&&(type.equals("226")||type.equals("227"))){
					  	        RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
					  	    }
					  	    else{
					  	        RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+fielddbtype);
					  	    }
				  		}
				  	}
				  	
				  	**************************************************************/
				}else{
					//插入字段信息
					//System.err.println("INSERT INTO CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,usetable,textheight,imgwidth,imgheight,isopen,ismust,places,candel,groupid) "+
					//		  " VALUES ('"+fieldname+"',"+fieldlabel+",'"+fielddbtype+"',"+fieldhtmltype+","+type+","+index+","+viewtype+",'"+usetable+"',"+textheight+","+imgwidth+","+imgheight+",'"+isopen+"','"+ismust+"','"+places+"','y',"+groupid+")");
                    if("1".equals(isfixed))
					RecordSetTrans.executeSql("INSERT INTO CRM_CustomerDefinField(dmlUrl,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,usetable,textheight,imgwidth,imgheight,isopen,ismust,issearch,isdisplay,isexport,places,candel,groupid) "+
					  " VALUES ('"+dmlUrl+"','"+fieldname+"',"+fieldlabel+",'"+fielddbtype+"',"+fieldhtmltype+","+type+","+index+","+viewtype+",'"+usetable+"',"+textheight+","+imgwidth+","+imgheight+",'"+isopen+"','"+ismust+"','"+issearch+"','"+isdisplay+"','"+isexport+"','"+places+"','n',"+groupid+")");
                    else
					RecordSetTrans.executeSql("INSERT INTO CRM_CustomerDefinField(dmlUrl,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,usetable,textheight,imgwidth,imgheight,isopen,ismust,issearch,isdisplay,isexport,places,candel,groupid) "+
					  " VALUES ('"+dmlUrl+"','"+fieldname+"',"+fieldlabel+",'"+fielddbtype+"',"+fieldhtmltype+","+type+","+index+","+viewtype+",'"+usetable+"',"+textheight+","+imgwidth+","+imgheight+",'"+isopen+"','"+ismust+"','"+issearch+"','"+isdisplay+"','"+isexport+"','"+places+"','y',"+groupid+")");

				}
				if(new_OR_modify.equals("")){//新添加字段
                    String actualType = "";
                    String actualLength = "";
                    String checkType = "";
                    String checkLength = "";
				    if("1".equals(isfixed)){
                        if(isoracle) {
                            RecordSetTrans.executeSql("SELECT DATA_TYPE as type,DATA_LENGTH as length FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('"+maintablename+"') and COLUMN_NAME =UPPER('"+fieldname+"')");
                        }
                        else {
                            RecordSetTrans.executeSql("SELECT systy.name as type,syscol.length as length FROM SysColumns syscol left JOIN systypes systy on syscol.xtype =systy.xtype  WHERE syscol.id=Object_Id('"+maintablename+"') and syscol.name='"+fieldname+"'");
                        }
                        if(RecordSetTrans.next()){
                            actualType = Util.null2String(RecordSetTrans.getString("type")).toLowerCase();
                            actualLength = RecordSetTrans.getString("length");
                        }else{
                            message=-2;
                            throw new Exception();
                        }
                        if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))){
                            checkType = (_fielddbtype.indexOf("(")>0)?(_fielddbtype.substring(0, _fielddbtype.indexOf("("))):_fielddbtype;
                            checkLength = (_fielddbtype.indexOf("(")>0)?(_fielddbtype.substring( _fielddbtype.indexOf("(")+1,_fielddbtype.indexOf(")"))):"";
                        }else if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225"))){
                            checkType = (_fielddbtype.indexOf("(")>0)?(_fielddbtype.substring(0, _fielddbtype.indexOf("("))):_fielddbtype;
                            checkLength = (_fielddbtype.indexOf("(")>0)?(_fielddbtype.substring( _fielddbtype.indexOf("(")+1,_fielddbtype.indexOf(")"))):"";
                        }else if(fieldhtmltype.equals("3")&&(type.equals("226")||type.equals("227"))){
                            checkType = (_fielddbtype.indexOf("(")>0)?(_fielddbtype.substring(0, _fielddbtype.indexOf("("))):_fielddbtype;
                            checkLength = (_fielddbtype.indexOf("(")>0)?(_fielddbtype.substring( _fielddbtype.indexOf("(")+1,_fielddbtype.indexOf(")"))):"";
                        }
                        else{
                            checkType = (fielddbtype.indexOf("(")>0)?(fielddbtype.substring(0, fielddbtype.indexOf("("))):fielddbtype;
                            checkLength = (fielddbtype.indexOf("(")>0)?(fielddbtype.substring( fielddbtype.indexOf("(")+1,fielddbtype.indexOf(")"))):"";
                        }
                        if(!actualType.equals(checkType)
				&& actualType.indexOf("varchar")<0 
				&& !"clob".equals(actualType) 
				&& !"text".equals(actualType) 
				&& !( "number".equals(actualType) && "integer".equals(checkType)) ){
                                message=-3;
                                throw new Exception();
                            }
                        else if(checkType.indexOf("char")>=0 && !actualLength.equals(checkLength)){
                            RecordSetTrans.executeSql("update CRM_CustomerDefinField set fielddbtype ='"+checkType+"("+actualLength+")"+"' where id=(select max(id) as id from CRM_CustomerDefinField)");
                        }
				    }
				    else{
						//更新主表结构
						if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))){
							RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
						}else if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225"))){
							RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
						}else if(fieldhtmltype.equals("3")&&(type.equals("226")||type.equals("227"))){
							RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
						}
						else{
							RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+fielddbtype);
						}
				    }
				}
				//设置下拉框选项值
				if(fieldhtmltype.equals("5")){
					String info = Util.null2String(request.getParameter("selectOption_"+index+"_value"));
					
					if(!info.equals("")){
						RecordSetTrans.executeSql("select id from CRM_CustomerDefinField where usetable = '"+maintablename+"' and fieldname = '"+fieldname+"'");
						RecordSetTrans.first();
						String fieldid = RecordSetTrans.getString("id");
						
						RecordSetTrans.execute("SELECT max(selectvalue) FROM crm_selectitem WHERE fieldid = "+fieldid);
						RecordSetTrans.next();
						int num = Util.getIntValue(RecordSetTrans.getString(1),0)+1;
						
						String[] arr = info.split(",,,");
						String ids = "";
						for(int m = 0; m < arr.length ;m++){
							if(m>=1){
								ids += ",";
							}
							ids += arr[m].substring(0,arr[m].indexOf("***"));
						}
						RecordSetTrans.execute("update crm_selectitem set isdel = 1 where fieldid = "+fieldid+" and selectvalue not in ("+ids+")");
						
						for(int m = 0; m < arr.length ;m++){
							String id = arr[m].substring(0,arr[m].indexOf("***"));
							String value = arr[m].substring(arr[m].indexOf("***")+3);
							if(!"-1".equals(id)){
								RecordSetTrans.execute("update crm_selectitem set selectname = '"+value+"' , fieldorder = "+m+" where fieldid = "+fieldid+" and selectvalue ="+id);
							}else{
								String sql = "insert into crm_selectitem(fieldid ,selectvalue,selectname,fieldorder,isdel) values "+
								" ("+fieldid+" , "+num+" , '"+value+"' , "+m+" ,0)";
								RecordSetTrans.execute(sql);
								num++;
							}
						}
						
					}
				}
			}
			//主字段 结束
			//排序
		    String sortnames = Util.null2String(request.getParameter("sortname"));
		    String[] _sortname = Util.TokenizerString2(sortnames,",");
		    for(int i=0;i<_sortname.length;i++)
			{
		    	RecordSetTrans.execute("update CRM_CustomerDefinField set dsporder='"+(i+1)+"' where fieldname='"+_sortname[i]+"' and usetable='"+usetable+"'");
			}
		    RecordSetTrans.commit();
			ArrayList labelidsArray = Util.TokenizerString(labelidsCache,",");
			for(int i=0;i<labelidsArray.size();i++){//添加标签id到缓存
				LabelComInfo.addLabeInfoCache((String)labelidsArray.get(i));
			}    
		}catch(Exception e){
			RecordSetTrans.rollback();
			e.printStackTrace();
            if(message>=0)
                message=-1;
		}finally{
			CrmFieldComInfo.removeFieldCache(usetable);
			if("CRM_CustomerInfo".equals(usetable)){
				CrmExcelToDB.generateExcel();
			}
				
		}  
		if("CRM_CustomerInfo".equals(usetable))
	  		response.sendRedirect("/base/ffield/CRM_FreeFieldInner.jsp?usetable=c1&message="+message);
		else if("CRM_CustomerContacter".equals(usetable))
			response.sendRedirect("/base/ffield/CRM_FreeFieldInner.jsp?usetable=c2&message="+message);
		else if("CRM_CustomerAddress".equals(usetable))
			response.sendRedirect("/base/ffield/CRM_FreeFieldInner.jsp?usetable=c3&message="+message);
		else if("CRM_SellChance".equals(usetable))
			response.sendRedirect("/base/ffield/CRM_FreeFieldInner.jsp?usetable=c4&message="+message);
	}else if(method.equals("editfieldlabel"))
	{
		String changefieldids = Util.null2String(request.getParameter("changefieldids"));
		RecordSetTrans.setAutoCommit(false);
		try{
			ArrayList changefieldidsArray = Util.TokenizerString(changefieldids,",");
			for(int i=0;i<changefieldidsArray.size();i++){
				String fieldid = (String)changefieldidsArray.get(i);
				String fieldnameCN = Util.null2String(request.getParameter("field_"+fieldid+"_CN"));
				String fieldnameEn = Util.null2String(request.getParameter("field_"+fieldid+"_En"));
				String fieldnameTW = Util.null2String(request.getParameter("field_"+fieldid+"_TW"));
				fieldnameCN = Util.StringReplace(fieldnameCN, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
				fieldnameEn = Util.StringReplace(fieldnameEn, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
				fieldnameTW = Util.StringReplace(fieldnameTW, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
				int lableid = 0;
				String sql = "SELECT * FROM HtmlLabelInfo WHERE labelname = '"+fieldnameCN+"' AND languageid = 7 AND indexid IN("+
					 " SELECT indexid FROM HtmlLabelInfo WHERE labelname = '"+fieldnameEn+"' AND languageid = 8 AND indexid IN ("+
					 " SELECT indexid FROM HtmlLabelInfo WHERE labelname = '"+fieldnameTW+"' AND languageid = 9))";
				RecordSetTrans.execute(sql);
				
			  if(RecordSetTrans.next()){
				  	lableid = RecordSetTrans.getInt("indexid");//如果字段名称在标签库中存在，取得标签id,以中文为准。
			  }else{//不存在则生成新的标签id
					lableid = CRMFreeFieldManage.getNewIndexId(RecordSetTrans);
			  }
				if(lableid!=-1){//更新标签库
					RecordSet.executeSql("delete from HtmlLabelIndex where id="+lableid);
					RecordSet.executeSql("delete from HtmlLabelInfo where indexid="+lableid);
					RecordSet.executeSql("INSERT INTO HtmlLabelIndex values("+lableid+",'"+fieldnameCN+"')");
					RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameCN+"',7)");//中文
					RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameEn+"',8)");//英文
					RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameTW+"',9)");//繁体
					LabelComInfo.addLabeInfoCache(""+lableid);//更新缓存
				}
				RecordSetTrans.executeSql("update CRM_CustomerDefinField set fieldlabel="+lableid+" where id="+fieldid);
			}
			RecordSetTrans.commit();
		}catch(Exception exception){
			exception.printStackTrace();
			RecordSetTrans.rollback();
		}finally{
			CrmFieldComInfo.removeFieldCache(usetable);
		} 
		if("CRM_CustomerInfo".equals(usetable))
	  		response.sendRedirect("/base/ffield/CRM_FreeFieldLabelInner.jsp?usetable=c1");
		else if("CRM_CustomerContacter".equals(usetable))
			response.sendRedirect("/base/ffield/CRM_FreeFieldLabelInner.jsp?usetable=c2");
		else if("CRM_CustomerAddress".equals(usetable))
			response.sendRedirect("/base/ffield/CRM_FreeFieldLabelInner.jsp?usetable=c3");
		else if("CRM_SellChance".equals(usetable))
			response.sendRedirect("/base/ffield/CRM_FreeFieldLabelInner.jsp?usetable=c4");
	}else if(method.equals("editGroupInfo")){
		String delids = request.getParameter("delids");
		String changeRowIndexs = request.getParameter("changeRowIndexs");
		String sortInfo = request.getParameter("sortInfo");
		RecordSetTrans.setAutoCommit(false);
		Map indexValueMap = new HashMap();
		ArrayList<String> sortids = new ArrayList<String>(); 
		if(!sortInfo.equals("")){
			String[] arr = Util.TokenizerString2(sortInfo,",");
			for(int i=0 ; i<arr.length ; i++){
				String index = arr[i].substring(0,arr[i].indexOf("-"));
				String id = arr[i].substring(arr[i].indexOf("-")+1);
				indexValueMap.put(index ,id);
				sortids.add(id);
			}
		}
		
		try{
			if(!"".equals(delids) && !",".equals(delids)){
				delids = delids.substring(1,delids.length()-1);
				RecordSetTrans.execute("delete from CRM_CustomerDefinFieldGroup where usetable = '"+usetable+"' and id in ("+delids+")");
			}
			
			ArrayList array = Util.TokenizerString(changeRowIndexs,",");
		  	for(int i=0;i<array.size();i++){//修改有改变的行
		  		int index = Util.getIntValue(array.get(i).toString());
		  		String new_OR_modify = Util.null2String(request.getParameter("modifyflag_"+index));//即数据库CRM_CustomerDefinField的id值
		  		
		  		String fieldnameCN = Util.null2String(request.getParameter("CN_"+index));
				String fieldnameEn = Util.null2String(request.getParameter("EN_"+index));
				String fieldnameTW = Util.null2String(request.getParameter("TW_"+index));
				
				int lableid = 0;
	  			String sql = "SELECT * FROM HtmlLabelInfo WHERE labelname = '"+fieldnameCN+"' AND languageid = 7 AND indexid IN("+
	  						 " SELECT indexid FROM HtmlLabelInfo WHERE labelname = '"+fieldnameEn+"' AND languageid = 8 AND indexid IN ("+
	  						 " SELECT indexid FROM HtmlLabelInfo WHERE labelname = '"+fieldnameTW+"' AND languageid = 9))";
	  		
	  			RecordSetTrans.execute(sql);
	  			if(RecordSetTrans.next()){
			    	lableid = RecordSetTrans.getInt("indexid");//如果字段名称在标签库中存在，取得标签id,以中文为准。
			    }else{//不存在则生成新的标签id
					lableid = CRMFreeFieldManage.getNewIndexId(RecordSetTrans);
				}
				if(lableid!=-1){//更新标签库
					RecordSet.executeSql("delete from HtmlLabelIndex where id="+lableid);
					RecordSet.executeSql("delete from HtmlLabelInfo where indexid="+lableid);
					RecordSet.executeSql("INSERT INTO HtmlLabelIndex values("+lableid+",'"+fieldnameCN+"')");
					RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameCN+"',7)");//中文
					RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameEn+"',8)");//英文
					RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameTW+"',9)");//繁体
					LabelComInfo.addLabeInfoCache(""+lableid);//更新缓存
				}
				
		  		if(new_OR_modify.equals("")){//新增操作
					sql = "insert into  CRM_CustomerDefinFieldGroup(usetable ,grouplabel,dsporder , candel) values ('"+usetable+"' , '"+lableid+"' ,"+index+1+" , 'y')";
					RecordSetTrans.executeSql(sql);
					
					if(!sortInfo.equals("")){
						RecordSetTrans.execute("select max(id) from CRM_CustomerDefinFieldGroup where usetable = '"+usetable+"'");
						RecordSetTrans.next();
						String newId = RecordSetTrans.getString(1);
						sortids.add(newId);
//						indexValueMap.put(index , newId);
					}
					
		  		}else{
		  			sql = "update CRM_CustomerDefinFieldGroup set grouplabel = '"+lableid+"' where id = "+new_OR_modify;
		  			RecordSetTrans.executeSql(sql);
		  		}
		  		
		  	}
		  	
		  	if(!sortInfo.equals("")){
		  		int order = 1;
		  		for(String id : sortids){
		  			RecordSetTrans.execute("update CRM_CustomerDefinFieldGroup set dsporder = "+order+" where id = "+id);
		  			order++;
		  		}
		  	}
		  	
		  	
		    RecordSetTrans.commit();
		}catch(Exception exception){
			RecordSetTrans.rollback();
			exception.printStackTrace();
		}finally{
			CrmFieldComInfo.removeFieldCache(usetable);
		} 
		
		if("CRM_CustomerInfo".equals(usetable))
	  		response.sendRedirect("/base/ffield/CRM_FreeFieldGroupInner.jsp?usetable=c1");
		else if("CRM_CustomerContacter".equals(usetable))
			response.sendRedirect("/base/ffield/CRM_FreeFieldGroupInner.jsp?usetable=c2");
		else if("CRM_CustomerAddress".equals(usetable))
			response.sendRedirect("/base/ffield/CRM_FreeFieldGroupInner.jsp?usetable=c3");
		else if("CRM_SellChance".equals(usetable))
			response.sendRedirect("/base/ffield/CRM_FreeFieldGroupInner.jsp?usetable=c4");
		
	}else if(method.equals("getTableGroupInfo")){
		String rowindex = Util.null2String(request.getParameter("rowindex"));
		
		String selectValue = "";
		if(usetable.equals("CRM_CustomerInfo"))selectValue = "5";
		if(usetable.equals("CRM_CustomerContacter"))selectValue = "7";
		if(usetable.equals("CRM_CustomerAddress"))selectValue = "9";
		
		out.println(CRMFreeFieldManage.getTableGroupInfo(usetable,rowindex,selectValue,user,true)); 
	}else if(method.equals("changeSelectItemInfo")){
		int rownum = Util.getIntValue(request.getParameter("rownum"),0);
		int fieldid = Util.getIntValue(request.getParameter("fieldid"),0);
		String canDeleteP = "";
		String itemName = "";
		int itemNameId;
		String notInId = "";
        for (int i=0;i<rownum;i++){
        	canDeleteP = Util.getIntValue(request.getParameter("canDeleteP_"+i),0)+"";
        	itemNameId = Util.getIntValue(request.getParameter("itemNameId_"+i),0);
            if (canDeleteP.equals("1")){
            	if (notInId.equals("")) 
            		notInId = itemNameId + "";
                else 
                	notInId +="," + itemNameId;
            }
        }
        String strSqlDelAll = "" ;
        if ("".equals(notInId)){
            strSqlDelAll = " delete from crm_selectitem WHERE fieldid ="+ fieldid;            
        } else {
            strSqlDelAll = " delete from crm_selectitem WHERE selectvalue not in("+notInId+") and fieldid ="+ fieldid ;        
        }
		RecordSet.executeSql(strSqlDelAll);
		for (int i=0;i<rownum;i++){
            canDeleteP = Util.fromScreen(request.getParameter("canDeleteP_"+i),user.getLanguage());
            itemName = Util.fromScreen(request.getParameter("itemName_"+i),user.getLanguage());
            itemNameId = Util.getIntValue(request.getParameter("itemNameId_"+i),0);
            if (canDeleteP.equals("0")){
				if (!"".equals(itemName)){
                	String isql = " insert into crm_selectitem (fieldid,selectvalue,selectname,fieldorder,isdel) values ("+fieldid+","+itemNameId+",'"+itemName+"',"+(itemNameId-1)+",0) ";
                	RecordSet.executeSql(isql);
				}
            }else{
            	if (!"".equals(itemName)){
                	String usql = " update crm_selectitem set selectname='"+itemName+"' where fieldid ="+ fieldid +" and selectvalue="+itemNameId;
                	RecordSet.executeSql(usql);
                }
            }
        }
		out.println("<script>parent.getParentWindow(window).onSave('');parent.getParentWindow(window).closeDialog();</script>");
	}
%>