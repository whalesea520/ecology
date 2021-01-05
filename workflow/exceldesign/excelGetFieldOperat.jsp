<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />	
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<jsp:useBean id="FormFieldlabelMainManager" class="weaver.workflow.form.FormFieldlabelMainManager" scope="page" />
<%FormFieldlabelMainManager.resetParameter();%>
<%
	int formid = Util.getIntValue(request.getParameter("formid"),0);
	int fieldid = Util.getIntValue(request.getParameter("fieldid"),0);
	int isbill = Util.getIntValue(request.getParameter("isbill"),0);
	//System.out.println("isbill"+isbill);
	String method = Util.null2String(request.getParameter("method"));
	boolean issqlserver = (RecordSet.getDBType()).equals("sqlserver") ;
	if(method.equals("getfield"))
	{
		if(fieldid>0)
		{
			if(isbill == 0)
			{
				ArrayList langids=new ArrayList();
				FormFieldlabelMainManager.setFormid(formid);
				FormFieldlabelMainManager.selectLanguage();
				while(FormFieldlabelMainManager.next()){
					int curid=FormFieldlabelMainManager.getLanguageid();
					langids.add(""+curid);
				}
				LinkedHashMap map = new LinkedHashMap();
				for (int tmpcount1=0;tmpcount1<langids.size();tmpcount1++)
				{
					String curidlanguage=(String)langids.get(tmpcount1);
					FormFieldlabelMainManager.resetParameter();
					FormFieldlabelMainManager.setFormid(formid);
					FormFieldlabelMainManager.setFieldid(fieldid);
					FormFieldlabelMainManager.setLanguageid(Util.getIntValue(curidlanguage,0));
					FormFieldlabelMainManager.selectSingleFormField();
					if(curidlanguage.equals("7"))
						map.put("_cn",FormFieldlabelMainManager.getFieldlabel());
					else if(curidlanguage.equals("8"))
						map.put("_en",FormFieldlabelMainManager.getFieldlabel());
					else if(curidlanguage.equals("9"))
						map.put("_tw",FormFieldlabelMainManager.getFieldlabel());
				}
				JSONObject reval = JSONObject.fromObject(map);
				//System.out.println(reval);
				response.getWriter().write(reval.toString());
			}else if(isbill == 1)
			{
				if(formid!=0)
					RecordSet.executeSql("select id,fieldname,fieldlabel,viewtype from workflow_billfield where billid="+formid+" and id="+fieldid+"");
				if(RecordSet.next()){//取得表单的所有字段及字段显示名
					int tempFieldLableId = RecordSet.getInt("fieldlabel");
					//System.out.println("select id,fieldname,fieldlabel,viewtype from workflow_billfield where billid="+formid+" and id="+fieldid+"");
					//System.out.println(fieldid);
					String _cn = SystemEnv.getHtmlLabelName(tempFieldLableId,7);
					String _en = SystemEnv.getHtmlLabelName(tempFieldLableId,8);
					String _tw = SystemEnv.getHtmlLabelName(tempFieldLableId,9);
					
					LinkedHashMap map = new LinkedHashMap();
					map.put("_cn",_cn);
					map.put("_en",_en);
					map.put("_tw",_tw);
					JSONObject reval = JSONObject.fromObject(map);
					//System.out.println(reval);
					response.getWriter().write(reval.toString());
				}else if(fieldid < 0)
				{
					
				}
			}
		}
	}else if(method.equals("savefield"))
	{
		if(fieldid > 0)
		{
			String fieldnameCN = Util.null2String(request.getParameter("_cn"));
			String fieldnameEn = Util.null2String(request.getParameter("_en"));
			String fieldnameTW = Util.null2String(request.getParameter("_tw"));
			fieldnameCN = Util.StringReplace(fieldnameCN, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
			fieldnameCN = Util.StringReplace(fieldnameCN, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
			fieldnameEn = Util.StringReplace(fieldnameEn, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
			fieldnameEn = Util.StringReplace(fieldnameEn, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
			fieldnameTW = Util.StringReplace(fieldnameTW, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
			fieldnameTW = Util.StringReplace(fieldnameTW, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
			if(isbill == 0)
			{
				FormFieldlabelMainManager.setFormid(formid);
				FormFieldlabelMainManager.selectLanguage();
				ArrayList langids=new ArrayList();
				while(FormFieldlabelMainManager.next()){
					int curid=FormFieldlabelMainManager.getLanguageid();
					langids.add(""+curid);
				}
				int defaultlang =Util.getIntValue(Util.null2String(request.getParameter("isdefault")));
				for (int tmpcount1=0;tmpcount1<langids.size();tmpcount1++)
				{
					int languageid = Util.getIntValue((String)langids.get(tmpcount1),0);
					String isdef = "0";
					if( languageid < 1)
						break;
					if(languageid == defaultlang)
						isdef = "1";
					FormFieldlabelMainManager.resetParameter();
					FormFieldlabelMainManager.setFormid(formid);
					FormFieldlabelMainManager.setFieldid(fieldid);
					FormFieldlabelMainManager.setLanguageid(languageid);
					String label = "";
					if(languageid == 7)
					{
						label = fieldnameCN;
					}
					else if(languageid == 8)
						label = fieldnameEn;
					else if(languageid == 9)
						label = fieldnameTW;
					FormFieldlabelMainManager.setFieldlabel(label);
					FormFieldlabelMainManager.updataFormfieldlabel();
				}
			}else if(isbill == 1)
			{
				int lableid = 0;
				if(issqlserver) RecordSet.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldnameCN+"' collate Chinese_PRC_CS_AI and languageid=7");
				else RecordSet.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldnameCN+"' and languageid=7");
				if(RecordSet.next()) lableid = RecordSet.getInt("indexid");//如果字段名称在标签库中存在，取得标签id,以中文为准。
				else{//不存在则生成新的标签id
					lableid = -1;
			    	try{
			        //statement = new ConnStatement();
			        //statement.setStatementSql("select min(id) as id from HtmlLabelIndex");	
			        //statement.executeQuery();
			        RecordSet.executeSql("select min(id) as id from HtmlLabelIndex");
			        if(RecordSet.next()){
			        	lableid = RecordSet.getInt("id")-1;
			        	if(lableid > -2) lableid = -2;//从-2开始生成新的labelid
			        }
			    	}catch (Exception e){
			    		lableid = -1;
			    	}
				}
				//System.out.println("labelid"+lableid);
				if(lableid!=-1){//更新标签库
					RecordSet.executeSql("delete from HtmlLabelIndex where id="+lableid);
					RecordSet.executeSql("delete from HtmlLabelInfo where indexid="+lableid);
					RecordSet.executeSql("INSERT INTO HtmlLabelIndex values("+lableid+",'"+fieldnameCN+"')");
					RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameCN+"',7)");//中文
					RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameEn+"',8)");//英文
					RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameTW+"',9)");//繁体
				}
				
				RecordSet.executeSql("update workflow_billfield set fieldlabel="+lableid+" where id="+fieldid);
				
				LabelComInfo.addLabeInfoCache(""+lableid);//更新缓存
				
			}
			response.getWriter().write("true");
		}
	}
%>