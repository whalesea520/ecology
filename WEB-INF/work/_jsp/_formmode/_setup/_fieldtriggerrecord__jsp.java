/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._formmode._setup;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import weaver.systeminfo.*;
import java.util.*;
import oracle.sql.CLOB;
import java.io.BufferedReader;
import java.io.Writer;
import weaver.conn.*;
import weaver.hrm.*;
import weaver.docs.change.*;
import weaver.general.TimeUtil;
import org.json.JSONArray;
import org.json.JSONObject;

public class _fieldtriggerrecord__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  
  public void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response)
    throws java.io.IOException, javax.servlet.ServletException
  {
    javax.servlet.http.HttpSession session = request.getSession(true);
    com.caucho.server.webapp.WebApp _jsp_application = _caucho_getApplication();
    javax.servlet.ServletContext application = _jsp_application;
    com.caucho.jsp.PageContextImpl pageContext = _jsp_application.getJspApplicationContext().allocatePageContext(this, _jsp_application, request, response, null, session, 8192, true, false);
    javax.servlet.jsp.PageContext _jsp_parentContext = pageContext;
    javax.servlet.jsp.JspWriter out = pageContext.getOut();
    final javax.el.ELContext _jsp_env = pageContext.getELContext();
    javax.servlet.ServletConfig config = getServletConfig();
    javax.servlet.Servlet page = this;
    response.setContentType("text/html; charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.workflow.workflow.WorkflowComInfo WorkflowComInfo;
      WorkflowComInfo = (weaver.workflow.workflow.WorkflowComInfo) pageContext.getAttribute("WorkflowComInfo");
      if (WorkflowComInfo == null) {
        WorkflowComInfo = new weaver.workflow.workflow.WorkflowComInfo();
        pageContext.setAttribute("WorkflowComInfo", WorkflowComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.conn.RecordSet rs1;
      rs1 = (weaver.conn.RecordSet) pageContext.getAttribute("rs1");
      if (rs1 == null) {
        rs1 = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs1", rs1);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.docs.mould.MouldManager mouldManager;
      mouldManager = (weaver.docs.mould.MouldManager) pageContext.getAttribute("mouldManager");
      if (mouldManager == null) {
        mouldManager = new weaver.docs.mould.MouldManager();
        pageContext.setAttribute("mouldManager", mouldManager);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
	User user = HrmUserVarify.getUser(request,response);
	if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
		response.sendRedirect("/notice/noright.jsp");
  		return;
	} 
	String src = Util.null2String(request.getParameter("operation"));
	
	if(src.equalsIgnoreCase("getRelateTableInfo")){//\u83b7\u53d6\u5f15\u7528\u6570\u636e\u5e93\u8868
		String dataInputID = Util.null2String(request.getParameter("dataInputID"));
	  	String index = Util.null2String(request.getParameter("index"));
	  	String secIndex = Util.null2String(request.getParameter("secIndex"));
	  	String entryID = Util.null2String(request.getParameter("entryID"));
	  	String datasourcename = Util.null2String(request.getParameter("datasourcename"));
		RecordSet rs2 = new RecordSet();
	  	RecordSet rs3 = new RecordSet();
	  	
		rs2.executeSql("select * from modeDataInputtable where DataInputID="+dataInputID+" order by id");
		JSONArray jsonArray=new JSONArray();
		JSONArray ajaxData=new JSONArray();
		while(rs2.next()){
			jsonArray=new JSONArray();
			String TableName = rs2.getString("TableName");
			String Alias = rs2.getString("Alias");
			String FormId = Util.null2String(rs2.getString("FormId"));
			String tablenamespan = "";
			if(datasourcename.trim().equals("")){
				if(!FormId.equals("") && ("workflow_form".equals(TableName) || "workflow_formdetail".equals(TableName))){
					if(FormId.indexOf("_") < 0){
						rs3.executeSql("select formname from workflow_formbase where id="+FormId);
						if(rs3.next()) tablenamespan = rs3.getString("formname");
						tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";//\u4e3b\u8868
					}else{
						String tempFormId = FormId.substring(0,FormId.indexOf("_"));
						String tempGroupId = FormId.substring(FormId.indexOf("_")+1,FormId.length());
						rs3.executeSql("select formname from workflow_formbase where id="+tempFormId);
						if(rs3.next()) tablenamespan = rs3.getString("formname");
						rs3.executeSql("select distinct groupId from workflow_formfield where formid="+tempFormId+" and isdetail=1 order by groupId");
						int detailIndex = 0;
						while(rs3.next()){
							detailIndex++;
							if(rs3.getString("groupId").equals(tempGroupId)) break;
						}
						tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailIndex+")";//\u660e\u7ec6\u8868
					}
				}else{
	                if("".equals(FormId))   FormId="0";
	                rs3.executeSql("select namelabel from workflow_bill where tablename='"+TableName+"'");
	                if(rs3.next()){
	                    tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
	                    tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
	                }else{
	                    rs3.executeSql("select tabledesc,tabledescen from Sys_tabledict where tablename='"+TableName+"'");
	                    if(rs3.next()){
	                        if(user.getLanguage()==7) tablenamespan = rs3.getString("tabledesc");
	                        if(user.getLanguage()==8) tablenamespan = rs3.getString("tabledescen");
	                        tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
	                    }else{
	                        rs3.executeSql("select billid from Workflow_billdetailtable where tablename='"+TableName+"'");
	                        if(rs3.next()){
	                            String tempBillId = rs3.getString("billid");
	                            rs3.executeSql("select namelabel from workflow_bill where id="+tempBillId);
	                            if(rs3.next()){
	                                tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
	                            }
	                            rs3.executeSql("select tablename from Workflow_billdetailtable where billid="+tempBillId+" order by orderid ");
	                            int detailIndex = 0;
	                            while(rs3.next()){
	                                detailIndex++;
	                                String tempTableName = rs3.getString("tablename");
	                                if(tempTableName.equals(TableName)) break;
	                            }
	                            tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+(detailIndex)+")";
	                        }else{
	                            rs3.executeSql("select namelabel from workflow_bill where detailtablename='"+TableName+"'");
	                            if(rs3.next()){
	                                tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
	                                tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+"1)";
	                            }
	                        }
	                    }
	                }
	            }
			}
			
			JSONObject jsonObject=new JSONObject();
	  		jsonObject.put("name", "id");
	  		jsonObject.put("iseditable", "true");
			jsonObject.put("value", Util.null2String(rs2.getString("id")));
			jsonObject.put("type", "checkbox");
			jsonArray.put(jsonObject);
			
			jsonObject=new JSONObject();
	  		jsonObject.put("name", "formid"+index+secIndex);
			jsonObject.put("value", FormId);
			jsonObject.put("iseditable", "true");
			jsonObject.put("label", tablenamespan);
			jsonObject.put("type", "browser");
			jsonArray.put(jsonObject);
			
			jsonObject=new JSONObject();
	  		jsonObject.put("name", "tablename"+index+secIndex);
			jsonObject.put("value", TableName);
			jsonObject.put("iseditable", "true");
			jsonObject.put("type", "input");
			jsonArray.put(jsonObject);
			
			jsonObject=new JSONObject();
	  		jsonObject.put("name", "tablebyname"+index+secIndex);
			jsonObject.put("value", Alias);
			jsonObject.put("iseditable", "true");
			jsonObject.put("type", "input");
			jsonArray.put(jsonObject);
			
			ajaxData.put(jsonArray);
		}
		//\u5982\u679c\u6ca1\u6709\u6570\u636e\u5219\u6dfb\u52a0\u4e00\u6761\u9ed8\u8ba4\u7684\u503c
		if(ajaxData.length()==0){
			JSONObject jsonObject=new JSONObject();
	  		jsonObject.put("name", "id");
	  		jsonObject.put("iseditable", "true");
			jsonObject.put("value", Util.null2String(rs2.getString("id")));
			jsonObject.put("type", "checkbox");
			jsonArray.put(jsonObject);
			
			jsonObject=new JSONObject();
	  		jsonObject.put("name", "formid"+index+secIndex);
			jsonObject.put("value", "");
			jsonObject.put("iseditable", "true");
			jsonObject.put("label", "");
			jsonObject.put("type", "browser");
			jsonArray.put(jsonObject);
			
			jsonObject=new JSONObject();
	  		jsonObject.put("name", "tablename"+index+secIndex);
			jsonObject.put("value", "");
			jsonObject.put("iseditable", "true");
			jsonObject.put("type", "input");
			jsonArray.put(jsonObject);
			
			jsonObject=new JSONObject();
	  		jsonObject.put("name", "tablebyname"+index+secIndex);
			jsonObject.put("value", "");
			jsonObject.put("iseditable", "true");
			jsonObject.put("type", "input");
			jsonArray.put(jsonObject);
			
			ajaxData.put(jsonArray);
		}
	  	out.println(ajaxData.toString());
	}else if(src.equalsIgnoreCase("getParameterFormModeField")||src.equalsIgnoreCase("getEvaluateFormModeField")){//\u5b57\u6bb5\u8054\u52a8\u4e2d\u83b7\u53d6\u53d6\u503c\u53c2\u6570\u3001\u8d4b\u503c\u53c2\u6570
		String dataInputID = Util.null2String(request.getParameter("dataInputID"));
	  	String index = Util.null2String(request.getParameter("index"));
	  	String secIndex = Util.null2String(request.getParameter("secIndex"));
	  	String entryID = Util.null2String(request.getParameter("entryID"));
	  	String modeId = Util.null2String(request.getParameter("modeId"));
	  	boolean isParameter = "getParameterFormModeField".equalsIgnoreCase(src);//\u662f\u5426\u4e3a\u53d6\u503c\u53c2\u6570
	  	String type = "1";
	  	String namePrefix = "para";
	  	if(!isParameter){
	  		type = "2";
	  		namePrefix = "evaluate";
	  	}
		
		String sql = "select * from modeDataInputmain where entryID="+entryID;
		if(!"".equals(dataInputID)){
			sql += " and id="+dataInputID;
		}
	  	rs.executeSql(sql);
	  	String datasourcename = "";//\u6570\u636e\u6e90
	  	if(rs.next()){
	  		datasourcename = Util.null2String(rs.getString("datasourcename"));
	  	}
	  	String formid = "";
        rs1.executeSql("select formid from modeinfo where id="+modeId );
        if(rs1.next()){
            formid = Util.null2String(rs1.getString("formid"));
        }
	  	
	  	rs.executeSql("select * from modeDataInputfield where Type="+type+" and DataInputID="+dataInputID+" order by pagefieldindex,id");
	  	JSONArray jsonArray=new JSONArray();
		JSONArray ajaxData=new JSONArray();
		RecordSet rs4 = new RecordSet();
    	RecordSet rs3 = new RecordSet();
		while(rs.next()){
			String isdetail = Util.null2String(rs.getString("pagefieldindex")) ;
			jsonArray=new JSONArray();
			JSONObject jsonObject=new JSONObject();
	  		jsonObject.put("name", namePrefix+index+secIndex+"_id");
			jsonObject.put("value", Util.null2String(rs.getString("id")));
			jsonObject.put("iseditable", "true");
			jsonObject.put("type", "checkbox");
			jsonArray.put(jsonObject);
			
			jsonObject=new JSONObject();
			jsonObject.put("name", namePrefix+"wfField"+index+secIndex);
	        
	        String PageFieldName = Util.null2String(rs.getString("PageFieldName"));
	        String tempfieldid = PageFieldName.substring(5,PageFieldName.length()) ;
	        jsonObject.put("value", tempfieldid);
	        
	        String PageFieldNamestr = "";
	        String ptabfix = "";
	        try{
	            String viewtype = "";
	            String detailtable = "";
	            rs4.executeSql("select fieldlabel,viewtype,detailtable from workflow_billfield where billid="+formid+" and id="+tempfieldid+"");
	            if(rs4.next()) {
	                PageFieldNamestr = SystemEnv.getHtmlLabelName(rs4.getInt("fieldlabel"),user.getLanguage());
	                viewtype = rs4.getString("viewtype") ;
	                detailtable = rs4.getString("detailtable") ;
	                if(viewtype.equals("0")){
	                    ptabfix = SystemEnv.getHtmlLabelName(21778,user.getLanguage());
	                }else{
	                    ptabfix = SystemEnv.getHtmlLabelName(19325,user.getLanguage()) ;
	                    rs3.executeSql("select orderid from workflow_billdetailtable where tablename='"+detailtable+"' and billid="+formid);
	                    if(rs3.next()){
	                        ptabfix += rs3.getString(1);
	                    }
	                }
	            }
	        }catch(Exception e){
	            //System.out.println(e.getMessage());
	        }
	        if(!ptabfix.equals("")) ptabfix += ".";
	        jsonObject.put("label", ptabfix+PageFieldNamestr);
	        jsonObject.put("type", "browser");
	        jsonObject.put("iseditable", "true");
	        jsonArray.put(jsonObject);
			
			jsonObject=new JSONObject();
			jsonObject.put("name", "treenodeid"+index+secIndex);
			String treenodeid = Util.null2String(rs.getString("treenodeid"));
			jsonObject.put("value", treenodeid);
			jsonObject.put("type", "select");
			jsonObject.put("iseditable", "true");
			jsonObject.put("fIndex", index);
			jsonObject.put("fsecIndex", secIndex);
			jsonArray.put(jsonObject);
			
			jsonObject=new JSONObject();
	        String DBFieldName = Util.null2String(rs.getString("DBFieldName"));
	        jsonObject.put("name", namePrefix+"fieldname"+index+secIndex);
	        jsonObject.put("value", DBFieldName);
	        String TableID = rs.getString("TableID");
	        String parafieldnamespan = DBFieldName;
	        String FieldTableName = "";
	        String FieldTableFormId = "";
	        String tablefix = "";
	        String aliasname = "";
	        String tablenamespan = "";
	        rs4.executeSql("select TableName,FormId,alias from modeDataInputtable where id="+TableID);
	        if(rs4.next()){
	            FieldTableName = rs4.getString("TableName");
	            FieldTableFormId = Util.null2String(rs4.getString("FormId"));
	            aliasname = Util.null2String(rs4.getString("alias"));
	            if(!FieldTableFormId.equals("")&&FieldTableFormId.indexOf("_")>0) {
	                FieldTableFormId = FieldTableFormId.substring(0,FieldTableFormId.indexOf("_"));
	            }
	            if(FieldTableFormId.equals("")){//E7\u5347\u7ea7E8\u65f6FormId\u4e3a\u7a7a\uff0c\u901a\u8fc7\u8868\u540dtablename\u6765\u83b7\u53d6formid
					String tabSql = "select id from workflow_bill where tablename='"+FieldTableName+"'";
					rs3.executeSql(tabSql);
					if(rs3.next()){
						FieldTableFormId = rs3.getString("id");
					}
				}
	        }
			if(datasourcename.trim().equals("")){
				if(!FieldTableFormId.equals("") && ("workflow_form".equals(FieldTableName) || "workflow_formdetail".equals(FieldTableName))){
					if(FieldTableFormId.indexOf("_") < 0){
						rs3.executeSql("select formname from workflow_formbase where id="+FieldTableFormId);
						if(rs3.next()) tablenamespan = rs3.getString("formname");
						tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";//\u4e3b\u8868
					}else{
						String tempFormId = FieldTableFormId.substring(0,FieldTableFormId.indexOf("_"));
						String tempGroupId = FieldTableFormId.substring(FieldTableFormId.indexOf("_")+1,FieldTableFormId.length());
						rs3.executeSql("select formname from workflow_formbase where id="+tempFormId);
						if(rs3.next()) tablenamespan = rs3.getString("formname");
						rs3.executeSql("select distinct groupId from workflow_formfield where formid="+tempFormId+" and isdetail=1 order by groupId");
						int detailIndex = 0;
						while(rs3.next()){
							detailIndex++;
							if(rs3.getString("groupId").equals(tempGroupId)) break;
						}
						tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailIndex+")";//\u660e\u7ec6\u8868
					}
					
					
					
				}else{
	                if("".equals(FieldTableFormId)){
	                   FieldTableFormId="0";
	                 }
	                rs3.executeSql("select namelabel from workflow_bill where tablename='"+FieldTableName+"'");
	                if(rs3.next()){
	                    tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
	                    tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
	                }else{
	                    rs3.executeSql("select tabledesc,tabledescen from Sys_tabledict where tablename='"+FieldTableName+"'");
	                    if(rs3.next()){
	                        if(user.getLanguage()==7) tablenamespan = rs3.getString("tabledesc");
	                        if(user.getLanguage()==8) tablenamespan = rs3.getString("tabledescen");
	                        tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
	                    }else{
	                        rs3.executeSql("select billid from Workflow_billdetailtable where tablename='"+FieldTableName+"'");
	                        if(rs3.next()){
	                            String tempBillId = rs3.getString("billid");
	                            rs3.executeSql("select namelabel from workflow_bill where id="+tempBillId);
	                            if(rs3.next()){
	                                tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
	                            }
	                            rs3.executeSql("select tablename from Workflow_billdetailtable where billid="+tempBillId+" order by orderid ");
	                            int detailIndex = 0;
	                            while(rs3.next()){
	                                detailIndex++;
	                                String tempTableName = rs3.getString("tablename");
	                                if(tempTableName.equals(FieldTableName)) break;
	                            }
	                            tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+(detailIndex)+")";
	                        }else{
	                            rs3.executeSql("select namelabel from workflow_bill where detailtablename='"+FieldTableName+"'");
	                            if(rs3.next()){
	                                tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
	                                tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+"1)";
	                            }
	                        }
	                    }
	                }
	            }
			
            	int _billid = 0;
                String maintable = "";
                String detailtable = "";
                String detailIndex = "";
                rs4.executeSql("select id,tablename,detailtablename from workflow_bill where tablename='"+FieldTableName+"' or detailtablename='"+FieldTableName+"'");
                if(rs4.next()){
                    _billid = Util.getIntValue(rs4.getString(1),0);
                    maintable = Util.null2String(rs4.getString(2));
                    detailtable = Util.null2String(rs4.getString(3));
                }
                int _isdetail = 0 ;
                if(maintable.equalsIgnoreCase(FieldTableName)){
                    _isdetail = 0 ;
                }else{
                    _isdetail = 1 ;
                }
                rs4.executeSql("select billid as id,orderid from workflow_billdetailtable where tablename='"+FieldTableName+"'");
                if(rs4.next()){
                    _isdetail = 1 ;
                    _billid = Util.getIntValue(rs4.getString("id"),0);
                    detailIndex = Util.null2String(rs4.getString("orderid"));
                }
                if(_billid!=0){
                    if(_isdetail!=1){
                        rs4.executeSql("select fieldlabel from workflow_billfield where billid="+_billid+" and fieldname='"+DBFieldName+"' and viewtype=0");
                    }else{
                        rs4.executeSql("select fieldlabel from workflow_billfield where billid="+_billid+" and fieldname='"+DBFieldName+"' and viewtype=1 and detailtable='"+FieldTableName+"'");
                    }
                    if(rs4.next()) parafieldnamespan = SystemEnv.getHtmlLabelName(rs4.getInt("fieldlabel"),user.getLanguage());
                }else{
               		 if(FieldTableName.equals("workflow_form")){
               		 	String sql4 = "select b.* from workflow_formdict a,workflow_fieldlable b,modedatainputtable c where a.fieldname='"+DBFieldName+"' and b.formid=c.FormId and c.id="+TableID+" and b.fieldid=a.id";
               		 	rs4.executeSql(sql4);
               		 	if(rs4.next()){
               		 		parafieldnamespan = rs4.getString("fieldlable");
               		 	}
               		 } else{
               		 
                   	 	rs4.executeSql("select id from Sys_tabledict where tablename='"+FieldTableName+"'");
                    	if(rs4.next()){
                        	rs4.executeSql("select fielddesc,fielddescen from Sys_fielddict where fieldname='"+DBFieldName+"' and tabledictid="+rs4.getInt("id"));
                        	if(rs4.next()){
                            	if(user.getLanguage()==7) parafieldnamespan = rs4.getString("fielddesc");
                            	if(user.getLanguage()==8) parafieldnamespan = rs4.getString("fielddescen");
                        	}
                    	}
               		 }
                
                }
	        }
	        
	        if(aliasname.equals("")){
	            if(tablenamespan.equals("")||tablenamespan.equalsIgnoreCase("null")){
	                tablefix = FieldTableName+".";
	            }else{
	                tablefix = tablenamespan+".";
	            }
	        }else{
	            tablefix = aliasname+"." ;
	        }
	        jsonObject.put("label",tablefix + parafieldnamespan);
			jsonObject.put("type", "browser");
			jsonObject.put("iseditable", "true");
			jsonArray.put(jsonObject);
			
			jsonObject=new JSONObject();
			jsonObject.put("name", namePrefix+"fieldtablename"+index+secIndex);
	        
	        jsonObject.put("value", FieldTableName);
	        jsonObject.put("type", "input");
	        jsonObject.put("iseditable", "true");
	        jsonArray.put(jsonObject);
	        
	        jsonObject=new JSONObject();
	        if(isParameter){
	        	jsonObject.put("name", "pfieldindex"+index+secIndex);
	        }else{
	        	jsonObject.put("name", "fieldindex"+index+secIndex);
	        }
	        
	        jsonObject.put("value", isdetail);
	        jsonObject.put("type", "input");
	        jsonObject.put("iseditable", "false");
	        jsonArray.put(jsonObject);
			ajaxData.put(jsonArray);
		}
		out.println(ajaxData.toString());
	}

      out.write(_jsp_string2, 0, _jsp_string2.length);
    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      _jsp_application.getJspApplicationContext().freePageContext(pageContext);
    }
  }

  private java.util.ArrayList _caucho_depends = new java.util.ArrayList();

  public java.util.ArrayList _caucho_getDependList()
  {
    return _caucho_depends;
  }

  public void _caucho_addDepend(com.caucho.vfs.PersistentDependency depend)
  {
    super._caucho_addDepend(depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  public boolean _caucho_isModified()
  {
    if (_caucho_isDead)
      return true;
    if (com.caucho.server.util.CauchoSystem.getVersionId() != 1886798272571451039L)
      return true;
    for (int i = _caucho_depends.size() - 1; i >= 0; i--) {
      com.caucho.vfs.Dependency depend;
      depend = (com.caucho.vfs.Dependency) _caucho_depends.get(i);
      if (depend.isModified())
        return true;
    }
    return false;
  }

  public long _caucho_lastModified()
  {
    return 0;
  }

  public java.util.HashMap<String,java.lang.reflect.Method> _caucho_getFunctionMap()
  {
    return _jsp_functionMap;
  }

  public void init(ServletConfig config)
    throws ServletException
  {
    com.caucho.server.webapp.WebApp webApp
      = (com.caucho.server.webapp.WebApp) config.getServletContext();
    super.init(config);
    com.caucho.jsp.TaglibManager manager = webApp.getJspApplicationContext().getTaglibManager();
    com.caucho.jsp.PageContextImpl pageContext = new com.caucho.jsp.PageContextImpl(webApp, this);
  }

  public void destroy()
  {
      _caucho_isDead = true;
      super.destroy();
  }

  public void init(com.caucho.vfs.Path appDir)
    throws javax.servlet.ServletException
  {
    com.caucho.vfs.Path resinHome = com.caucho.server.util.CauchoSystem.getResinHome();
    com.caucho.vfs.MergePath mergePath = new com.caucho.vfs.MergePath();
    mergePath.addMergePath(appDir);
    mergePath.addMergePath(resinHome);
    com.caucho.loader.DynamicClassLoader loader;
    loader = (com.caucho.loader.DynamicClassLoader) getClass().getClassLoader();
    String resourcePath = loader.getResourcePathSpecificFirst();
    mergePath.addClassPath(resourcePath);
    com.caucho.vfs.Depend depend;
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/setup/fieldTriggerRecord.jsp"), 4463833189382172738L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string2;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n".toCharArray();
    _jsp_string1 = "\r\n\r\n".toCharArray();
  }
}