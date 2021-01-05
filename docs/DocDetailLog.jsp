
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.xtable.TableSql" %>
<%
String sessionId=Util.getEncrypt("xTableSql_"+Util.getRandom());

TableSql xTableSql_DocDetail=new TableSql();
xTableSql_DocDetail.setBackfields("id,operatedate,operatetime,operateuserid,operatetype,docid,docsubject,clientaddress,usertype,creatertype");
xTableSql_DocDetail.setSqlform("from DocDetailLog");
xTableSql_DocDetail.setSqlwhere("where docid=");
xTableSql_DocDetail.setSqlisdistinct("true");
xTableSql_DocDetail.setSqlprimarykey("id");

session.setAttribute(sessionId,xTableSql_DocDetail);
%>

<script type="text/javascript">
 function ajaxinit(){
	    var ajax=false;
	    try {
	        ajax = new ActiveXObject("Msxml2.XMLHTTP");
	    } catch (e) {
	        try {
	            ajax = new ActiveXObject("Microsoft.XMLHTTP");
	        } catch (E) {
	            ajax = false;
	        }
	    }
	    if (!ajax && typeof XMLHttpRequest!='undefined') {
	       ajax = new XMLHttpRequest();
	    }
	    return ajax;
 }
	
 function getDocDetailLogPane(docid,width,height,hasTitle){
      var DocDetailLogPane;
	  var colsTableBaseParas=[
							{"para_1":"column:operatedate","para_2":"column:operatetime","para_3":"","hideable":true,"sortable":true,"width":0.2,"dataIndex":"operatedate","header":"<%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>","linkkey":"","linkvaluecolumn":"","column":"operatedate","target":"","transmethod":"weaver.docs.DocDetailLogTransMethod.getDateTime","href":""},
							{"para_1":"column:operateuserid","para_2":"column:usertype","para_3":"","hideable":true,"sortable":true,"width":0.15,"dataIndex":"operateuserid","header":"<%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%>","linkkey":"","linkvaluecolumn":"","column":"operateuserid","target":"","transmethod":"weaver.splitepage.transform.SptmForDoc.getNameOldLink","href":""},
							{"para_1":"column:operatetype","para_2":"<%=user.getLanguage()%>","para_3":"","hideable":true,"sortable":true,"width":0.1,"dataIndex":"operatetype","header":"<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>","linkkey":"","linkvaluecolumn":"","column":"operatetype","target":"","transmethod":"weaver.docs.DocDetailLogTransMethod.getDocStatus","href":""},
							{"para_1":"column:docid","para_2":"","para_3":"","hideable":true,"sortable":false,"width":0.15,"dataIndex":"tag","header":"<%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%>","linkkey":"","linkvaluecolumn":"","column":"tag","target":"","transmethod":"weaver.docs.DocDetailLogTransMethod.getDocId","href":""}
							,{"para_1":"column:docid","para_2":"","para_3":"","hideable":true,"sortable":false,"width":0.3,"dataIndex":"subject","header":"<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>","linkkey":"","linkvaluecolumn":"","column":"subject","target":"","transmethod":"weaver.splitepage.transform.SptmForDoc.getDocName","href":""},
							{"para_1":"","para_2":"","para_3":"","hideable":true,"sortable":true,"width":0.1,"dataIndex":"clientaddress","header":"<%=SystemEnv.getHtmlLabelName(108,user.getLanguage())+SystemEnv.getHtmlLabelName(110,user.getLanguage())%>","linkkey":"","linkvaluecolumn":"","column":"clientaddress","target":"","transmethod":"","href":""}
							];


	  var colsTableBaseParas2=[
	                     	  	{"para_1":"column:operateuserid","para_2":"column:usertype","para_3":"","hideable":true,"sortable":true,"width":1,"dataIndex":"operateuserid","header":"<%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%>","linkkey":"","linkvaluecolumn":"","column":"operateuserid","target":"","transmethod":"weaver.splitepage.transform.SptmForDoc.getName","href":""}								
								,{"para_1":"column:docid","para_2":"","para_3":"","hideable":true,"sortable":false,"width":0.6,"dataIndex":"subject","header":"<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>","linkkey":"","linkvaluecolumn":"","column":"subject","target":"","transmethod":"weaver.splitepage.transform.SptmForDoc.getDocName","href":""}								
								];
	    
	    var TableBaseParas={
	    	    		"sessionId":"<%=sessionId%>_DocDetailLog_"+docid,
					
						"sort":"operatedate,operatetime",
						"operates":[],
						"excerpt":"",
						"sqlisprintsql":"",
					
						"columns":colsTableBaseParas,
						"pageSize":10,					
						"poolname":"","sqlgroupby":"",
						"dir":"desc",
					
						"popedom":{"otherpara":"","otherpara2":"","transmethod":""}
		};

	    var storeDocDetailLogPane = new Ext.data.Store({
			baseParams : {
				TableBaseParas : Ext.util.JSON.encode(TableBaseParas)			
			},		
			proxy : new Ext.data.HttpProxy({
				method : 'POST',			
				url : '/weaver/weaver.common.util.taglib.SplitPageXmlServletNew'
			}),		
			reader : new Ext.data.JsonReader({
				root : 'data',
				totalProperty : 'totalCount',
				//id : 'id',
				fields :['operatedate','operateuserid','operatetype','tag','subject','clientaddress']
			}),		
			remoteSort : true			
		});	

	    var storeDocDetailLogPane_noRead = new Ext.data.Store({
			baseParams : {
				TableBaseParas : Ext.util.JSON.encode(TableBaseParas)			
			},		
			proxy : new Ext.data.HttpProxy({
				method : 'POST',							
				url : '/docs/DocDetailLogNoRead.jsp?docid='+docid
			}),		
			reader : new Ext.data.JsonReader({
				root : 'data',
				totalProperty : 'totalCount',
				//id : 'id',
				fields :['operatedate','operateuserid','operatetype','tag','subject','clientaddress']
			}),		
			remoteSort : true
		});	


	    var storeDocDetailLogPane_all = new Ext.data.Store({
			baseParams : {
				TableBaseParas : Ext.util.JSON.encode(TableBaseParas)			
			},		
			proxy : new Ext.data.HttpProxy({
				method : 'POST',			
				url : '/docs/DocDetailLogAllRead.jsp?docid='+docid
			}),		
			reader : new Ext.data.JsonReader({
				root : 'data',
				totalProperty : 'totalCount',
				//id : 'id',
				fields :['operatedate','operateuserid','operatetype','tag','subject','clientaddress']
			}),		
			remoteSort : true
		});	
		
/** TD12005 打印数据取得 开始*/
        var storeDocDetailLogPane_print = new Ext.data.Store({
            baseParams : {
                TableBaseParas : Ext.util.JSON.encode(TableBaseParas)           
            },      
            proxy : new Ext.data.HttpProxy({
                method : 'POST',                            
                url : '/docs/DocDetailLogPrint.jsp?docid='+docid
            }),     
            reader : new Ext.data.JsonReader({
                root : 'data',
                totalProperty : 'totalCount',
                //id : 'id',
                fields :['operatedate','operateuserid','operatetype','tag','subject','clientaddress']
            }),     
            remoteSort : true
        }); 
/** TD12005 下载数据取得 结束*/
        
/** TD12005 打印数据取得 开始*/
        var storeDocDetailLogPane_download = new Ext.data.Store({
            baseParams : {
                TableBaseParas : Ext.util.JSON.encode(TableBaseParas)           
            },      
            proxy : new Ext.data.HttpProxy({
                method : 'POST',                            
                url : '/docs/DocDetailLogDownload.jsp?docid='+docid
            }),     
            reader : new Ext.data.JsonReader({
                root : 'data',
                totalProperty : 'totalCount',
                //id : 'id',
                fields :['operatedate','operateuserid','operatetype','tag','subject','clientaddress']
            }),     
            remoteSort : true
        }); 
/** TD12005 下载数据取得  结束 */
	
		storeDocDetailLogPane.setDefaultSort(TableBaseParas.sort, TableBaseParas.dir);		

		//var cmDocDetailLogPane = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()].concat(colsTableBaseParas));	
		//cmDocDetailLogPane.defaultSortable = true;
		
		var smDocDetailLogPane = new Ext.grid.RowSelectionModel({handleMouseDown:Ext.emptyFn});
		var _isFirstLog=true;
		var _isFirstLogNoread=true;
		var _isFirstLogAll=true;
        var _isFirstLogPrint=true;//TD12005 打印
        var _isFirstLogDownload=true;//TD12005 下载
        
		var grid_noRead= {
		   		xtype:'grid',
		   		listeners: {
		        	   show  :function(c){
	        	   			//alert(_isFirstLogNoread)
	        	   		   if(_isFirstLogNoread)	{
				        	   this.store.load({
					       			params : {
					   				start:0,
					   				limit:TableBaseParas.pageSize
					   			}
				   				});	
				        	   _isFirstLogNoread=false;
	        	   		   }
		   			   }
			        }   ,			   			
	   			title : '<%=SystemEnv.getHtmlLabelName(21971,user.getLanguage())%>',
	   			store : storeDocDetailLogPane_noRead,
	   			cm : new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()].concat(colsTableBaseParas2)),
	   			trackMouseOver : true,
	   			autoSizeColumns : true,
	   			sm : smDocDetailLogPane,
	   			stripeRows : true,
	   			loadMask : true,
	   			viewConfig : {
	   				forceFit : true,
	   				emptyText : wmsg.grid.noItem
	   			},
	   			bbar : new Ext.PagingToolbar({
	   				pageSize : 10,
	   				store : storeDocDetailLogPane_noRead,
	   				displayInfo : true,
	   				displayMsg : wmsg.grid.gridDisp1 + '{0} - {1}' + wmsg.grid.gridDisp2
	   						+ '{2}' + wmsg.grid.gridDisp3,
	   				emptyMsg : wmsg.grid.noItem			
	   			})
	   		
	   		};

		var grid_all={		   		
		   		xtype:'grid',	
		   	    listeners: {
	   			show  :function(c){
	   			//alert(_isFirstLogAll)
    	   		 	  if(_isFirstLogAll)	{
        	   		 	      
				        	   this.store.load({
					       			params : {
					   				start:0,
					   				limit:TableBaseParas.pageSize
					   			}
				   				});	
				        	   _isFirstLogAll=false;
	        	   		   }
		   			   }
			        }   ,		   			
	   			title : '<%=SystemEnv.getHtmlLabelName(21973,user.getLanguage())%>',
	   			store : storeDocDetailLogPane_all,
	   			cm : new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()].concat(colsTableBaseParas)),
	   			trackMouseOver : true,
	   			autoSizeColumns : true,
	   			sm : smDocDetailLogPane,
	   			stripeRows : true,
	   			loadMask : true,
	   			viewConfig : {
	   				forceFit : true,
	   				emptyText : wmsg.grid.noItem
	   			},
	   			bbar : new Ext.PagingToolbar({
	   				pageSize : TableBaseParas.pageSize,
	   				store : storeDocDetailLogPane_all,
	   				displayInfo : true,
	   				displayMsg : wmsg.grid.gridDisp1 + '{0} - {1}' + wmsg.grid.gridDisp2
	   						+ '{2}' + wmsg.grid.gridDisp3,
	   				emptyMsg : wmsg.grid.noItem			
	   			})	   		
	   		};
/** TD12005 打印选项卡 开始*/
        var grid_print={              
            xtype:'grid',   
            listeners: {
            show  :function(c){
            //alert(_isFirstLogPrint)
                  if(_isFirstLogPrint)    {
                          
                           this.store.load({
                                params : {
                                start:0,
                                limit:TableBaseParas.pageSize
                            }
                            }); 
                           _isFirstLogPrint=false;
                       }
                   }
                }   ,                   
            title : '<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>',
            store : storeDocDetailLogPane_print,
            cm : new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()].concat(colsTableBaseParas)),
            trackMouseOver : true,
            autoSizeColumns : true,
            sm : smDocDetailLogPane,
            stripeRows : true,
            loadMask : true,
            viewConfig : {
                forceFit : true,
                emptyText : wmsg.grid.noItem
            },
            bbar : new Ext.PagingToolbar({
                pageSize : TableBaseParas.pageSize,
                store : storeDocDetailLogPane_print,
                displayInfo : true,
                displayMsg : wmsg.grid.gridDisp1 + '{0} - {1}' + wmsg.grid.gridDisp2
                        + '{2}' + wmsg.grid.gridDisp3,
                emptyMsg : wmsg.grid.noItem         
            })          
        };
/** TD12005 打印选项卡 开始*/
/** TD12005 下载选项卡 开始*/
        var grid_download={              
            xtype:'grid',   
            listeners: {
            show  :function(c){
            //alert(_isFirstLogDownload)
                  if(_isFirstLogDownload)    {
                           this.store.load({
                                params : {
                                start:0,
                                limit:TableBaseParas.pageSize
                            }
                            }); 
                           _isFirstLogDownload=false;
                       }
                   }
                }   ,                   
            title : '<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>',
            store : storeDocDetailLogPane_download,
            cm : new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()].concat(colsTableBaseParas)),
            trackMouseOver : true,
            autoSizeColumns : true,
            sm : smDocDetailLogPane,
            stripeRows : true,
            loadMask : true,
            viewConfig : {
                forceFit : true,
                emptyText : wmsg.grid.noItem
            },
            bbar : new Ext.PagingToolbar({
                pageSize : TableBaseParas.pageSize,
                store : storeDocDetailLogPane_download,
                displayInfo : true,
                displayMsg : wmsg.grid.gridDisp1 + '{0} - {1}' + wmsg.grid.gridDisp2
                        + '{2}' + wmsg.grid.gridDisp3,
                emptyMsg : wmsg.grid.noItem         
            })          
        };
/** TD12005 下载选项卡 结束*/
		
   			DocDetailLogPane=new Ext.TabPanel({		
				width: width,
		        height: height,
		        id : 'DocDetailLog',
		        title:'<%=SystemEnv.getHtmlLabelName(21990,user.getLanguage())%>',
		        activeTab: 0,
		        items:[	{		          
				   		xtype:'grid',	
				   		listeners: {
				        	   show  :function(c){
			        	   			//alert(TableBaseParas.pageSize)
			        	   		   if(_isFirstLog)	{
						        	   this.store.load({
							       			params : {
							   				start:0,
							   				limit:TableBaseParas.pageSize
							   			}
						   				});	
						        	   _isFirstLog=false;
			        	   		   }
				   			   }
					        }   ,			   			
			   			title : '<%=SystemEnv.getHtmlLabelName(21972,user.getLanguage())%>',
			   			store : storeDocDetailLogPane,
			   			cm : new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()].concat(colsTableBaseParas)),
			   			trackMouseOver : true,
			   			autoSizeColumns : true,
			   			sm : smDocDetailLogPane,
			   			stripeRows : true,
			   			loadMask : true,
			   			viewConfig : {
			   				forceFit : true,
			   				emptyText : wmsg.grid.noItem
			   			},
			   			bbar : new Ext.PagingToolbar({
			   				pageSize : TableBaseParas.pageSize,
			   				store : storeDocDetailLogPane,
			   				displayInfo : true,
			   				displayMsg : wmsg.grid.gridDisp1 + '{0} - {1}' + wmsg.grid.gridDisp2
			   						+ '{2}' + wmsg.grid.gridDisp3,
			   				emptyMsg : wmsg.grid.noItem			
			   			})			   		
			   		}
				]
		});
         
         var doclogFlag = false;
         var ajax=ajaxinit();
	     ajax.open("POST", "/docs/DocDetailLogOperate.jsp", true);
		 ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		 ajax.send("docid="+docid);
    	 ajax.onreadystatechange = function() {
		  if (ajax.readyState == 4 && ajax.status == 200) {
			try{
				if(ajax.responseText == 1){
				   DocDetailLogPane.add(grid_noRead);
			       DocDetailLogPane.add(grid_all);
                   DocDetailLogPane.add(grid_print);//TD12005 打印
                   DocDetailLogPane.add(grid_download);//TD12005 下载
				}	  
			}catch(e){
				return false;
			}
	      }
		 }
		
		return DocDetailLogPane;
}
</script>
