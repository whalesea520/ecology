//处理收回代理
function  doReadIt(param1,param2,obj)
{

    var diag = new Dialog();

	diag.Width = 300;

	diag.Height = 100;

	diag.Title = "提示框";

	diag.InnerHtml='<div style="text-align:center;font-size:12px;line-height: 100px;">是否确认收回?</div>'

	diag.OKEvent = function(){
	
	  var agentid=param1;
	  var agentInfo=$("input[name='agentInfo']").val();
      var url="/workflow/request/wfAgentManager.jsp?agentback=1&agentInfo="+agentInfo+"&agentid="+agentid;
      var mainframe=$("#mainFrame",parent.parent.parent.document);
      mainframe.attr("src",url); 
	
	};//点击确定后调用的方法

	diag.show();




}

//批量收回代理
function  agentBackByBatch()
{
  var checkitems=$(".ListStyle tbody").find(".jNiceChecked");
  
  if(!checkitems.length  ||  checkitems.length===0)
  {
    var diag = new Dialog();

	diag.Width = 300;

	diag.Height = 100;

	diag.Title = "提示框";

	diag.InnerHtml='<div style="text-align:center;font-size:12px;line-height: 100px;">请勾选至少一条记录!!!</div>'

	diag.OKEvent = function(){
	
	     diag.close();
	
	};//点击确定后调用的方法

	diag.show();
  
  
  }
  else
  {
  
   var diag = new Dialog();

	diag.Width = 300;

	diag.Height = 100;

	diag.Title = "提示框";

	diag.InnerHtml='<div style="text-align:center;font-size:12px;line-height: 100px;">是否确认收回!!!</div>'

	diag.OKEvent = function(){
	
	     var itemvalue;
         var params="";
		 for(var i=0;i<checkitems.length;i++)
		 {
			itemvalue=$(checkitems[i]).prev("input").attr("checkboxid");
			params=params+"agentid="+itemvalue+"&";
		 }
		  params=params.substring(0,params.length-1);
		  var url="/workflow/request/wfAgentManager.jsp?agentback=1&"+params;
		  var mainframe=$("#mainFrame",parent.parent.parent.document);
		  mainframe.attr("src",url); 
	
	};//点击确定后调用的方法

	diag.show();
  }

}


//代理明细信息
//合并表格相邻值相同的行
function weaver_table_rowspan(_w_table_id,_w_table_colnums){

             var  _w_table_colnum;
             var  _w_table_firsttd;
             var  _w_table_currenttd;
            
            for(var i=0;i<_w_table_colnums.length;i++)
			  {


              _w_table_colnum=_w_table_colnums[i];

              _w_table_firsttd = "";

              _w_table_currenttd = "";

               _w_table_Obj = $(_w_table_id + " tr td:nth-child(" + _w_table_colnum + ")");

              _w_table_Obj.each(function(i){

                  if(i==0){

                     _w_table_firsttd = $(this); 

                   }else{

                     _w_table_currenttd = $(this);
                     
                     
                     if(_w_table_colnums.length===2  &&   (_w_table_firsttd.attr("title")==_w_table_currenttd.attr("title"))  &&  (_w_table_firsttd.prev("td").attr("title")==_w_table_currenttd.prev("td").attr("title"))){

                    	  _w_table_currenttd.html("");
                    	 
                      }else
					  if(_w_table_colnums.length===3  &&   (_w_table_firsttd.attr("title")==_w_table_currenttd.attr("title"))  &&  (_w_table_firsttd.prev("td").attr("title")==_w_table_currenttd.prev("td").attr("title"))  && (_w_table_firsttd.prev("td").prev("td").attr("title")==_w_table_currenttd.prev("td").prev("td").attr("title")))
					  {
					      _w_table_currenttd.html("");
					  }
					  else{

                         _w_table_firsttd = $(this);

                     }

                  }

              });
	   }

    }
   


