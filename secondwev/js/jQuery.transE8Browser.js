/**
*jQuery transE8Browser plugin v1  
* author：dky 
* Date:2015/01/06
*/
(function(jQuery){
	jQuery.fn.transE8Browser=function(){
		if(!this) return;
		$this=jQuery(this);//当前节点
		if($this.length>1){
			$this.each(function(){
				jQuery(this).transE8Browser();
			});
			return;
		}
		var thisid = $this.attr("id")?$this.attr("id"):"";
		if(thisid==""){
			if(jQuery&&jQuery.fn&&jQuery.fn.modalDialog){
				jQuery(this).modalDialog();
			} 
			return;
		}
		var _browserUrl = $this.attr("_url")?$this.attr("_url"):"";
		var _param = $this.attr("_param");
		if(_param&&_param!="") _browserUrl += "?"+_param+"=";
		var _completeUrl = "";
		//联想输入类型
		var _type = "";
		//返回内容链接
		var _linkUrl = "";
		if(_browserUrl.indexOf("ResourceBrowser")>-1){//人力资源
			_type = "1";
			_linkUrl = "/hrm/resource/HrmResource.jsp?id=";
		}else if(_browserUrl.indexOf("ProvinceBrowser")>-1){//省份
			_type = "2222";
			_linkUrl = "#";
		}else if(_browserUrl.indexOf("CityBrowser")>-1){//城市
			_type = "58";
			_linkUrl = "#";
		}else if(_browserUrl.indexOf("Subcompany")>-1){//分部
			_type = "164";
			_linkUrl = "/hrm/company/HrmSubCompanyDsp.jsp?id=";
		}else if(_browserUrl.indexOf("Department")>-1){//部门
			_type = "4";
			_linkUrl = "/hrm/company/HrmDepartmentDsp.jsp&id=";
		}else if(_browserUrl.indexOf("Request")>-1){//请求
			_type = "16";
			_linkUrl = "/workflow/request/ViewRequest.jsp?requestid=";
		}else if(_browserUrl.indexOf("CustomerBrowser")>-1){//客户
			_type = "7";
			_linkUrl = "/CRM/data/ViewCustomer.jsp?CustomerID=";
		}else if(_browserUrl.indexOf("ContactBrowser")>-1){//客户联系人
			_type = "67";
			_linkUrl = "/CRM/contacter/ContacterView.jsp?ContacterID=";
		}else if(_browserUrl.indexOf("Doc")>-1){//文档
			_type = "9";
			_linkUrl = "/docs/docs/DocDsp.jsp?id=";
		}else if(_browserUrl.indexOf("HrmRolesBrowser")>-1){//角色
			_type = "65";
			_linkUrl = "#";
		}
		
		var _zDialog = true; 
		var _isAutoComplete = true;
		if(_type!=""){
			_completeUrl = "/data.jsp?type="+_type;
		}else{
			_zDialog = false;
			_isAutoComplete = false;
			/*if(jQuery&&jQuery.fn&&jQuery.fn.modalDialog){
				jQuery(this).modalDialog();
				jQuery(".browser").removeClass("browser Browser").addClass("e8_browflow");
				jQuery("#"+thisid+"Span").css({"float":"left","line-height": "24px","margin": "0 5px"});
			} 
			return;*/
		}
		
		$this.before("<div id='"+thisid+"div' class='browserdiv'></div>");
		var broserValue = $this.attr("_displayText");
		if(broserValue){
			//以html标签开始的则替换><标签中间的空格，不是则替换空格为，
			if(broserValue.indexOf("<") != -1){
				broserValue = broserValue.replace(/>((\s){1,2})</g,">,<");
			}else if(broserValue.indexOf(" ") != -1){
				broserValue = broserValue.replace(/\s/g,",");
			}
			
		}else{
			broserValue = "";
		}
		
		jQuery("#"+thisid+"div").e8Browser({
		   name:thisid,
		   viewType:"0",
		   browserValue:$this.val(),
		   isMustInput:($this.attr("_required")&&$this.attr("_required")=="yes")?"2":"1",
		   browserSpanValue:(broserValue),
		   hasInput:true,
		   linkUrl:_linkUrl,
		   isSingle:(_browserUrl.indexOf("Muti")>-1||_browserUrl.indexOf("Multi")>-1)?false:true,
		   completeUrl:_completeUrl,
		   browserUrl:_browserUrl,
		   width:"",
		   hasAdd:false,
		   needHidden:true,
		   defaultRow: 2,
		   zDialog:_zDialog,
		   isAutoComplete:_isAutoComplete,
		   _callback:($this.attr("_callBack")?$this.attr("_callBack"):""),
		   afterDelCallback:($this.attr("afterDelCallback")?$this.attr("afterDelCallback"):null)
		});
		$this.remove();
	};
})(jQuery);