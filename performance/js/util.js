function refreshOpener(){
	try{
		if(opener != null && opener.onRefresh != null){
			opener.onRefresh();
		}
	}catch(e){
					
	}
}

//替换ajax传递特殊符号
function filter(str){
	str = str.replace(/\+/g,"%2B");
    str = str.replace(/\&/g,"%26");
	return str;	
}

function Map() {    
    var struct = function(key, value) {    
        this.key = key;    
        this.value = value;    
    }    
     
    var put = function(key, value){    
        for (var i = 0; i < this.arr.length; i++) {    
            if ( this.arr[i].key === key ) {    
                this.arr[i].value = value;    
                return;    
            }    
        }    
        this.arr[this.arr.length] = new struct(key, value);    
    }    
         
    var get = function(key) {    
        for (var i = 0; i < this.arr.length; i++) {    
            if ( this.arr[i].key === key ) {    
                return this.arr[i].value;    
            }    
        }    
        return null;    
    }    
         
    var remove = function(key) {    
        var v;    
        for (var i = 0; i < this.arr.length; i++) {    
            v = this.arr.pop();    
            if ( v.key === key ) {    
                continue;    
            }    
            this.arr.unshift(v);    
        }    
    }    
         
    var size = function() {    
        return this.arr.length;    
    }    
         
    var isEmpty = function() {    
        return this.arr.length <= 0;    
    }    
       
    this.arr = new Array();    
    this.get = get;    
    this.put = put;    
    this.remove = remove;    
    this.size = size;    
    this.isEmpty = isEmpty;    
}
/**
Number.prototype.toFixed=function(len)
{
	var tempNum = 0;
    var s,temp;
    var s1 = this + "";
    
    var start = s1.indexOf(".");
    
    //截取小数点后,0之后的数字，判断是否大于5，如果大于5这入为1

    if(s1.substr(start+len+1,1)>=5)
	   tempNum=1;

    //计算10的len次方,把原数字扩大它要保留的小数位数的倍数
    var temp = Math.pow(10,len);
    //求最接近this * temp的最小数字
    //floor() 方法执行的是向下取整计算，它返回的是小于或等于函数参数，并且与之最接近的整数
    s = Math.floor(this * temp / temp) + tempNum;
    alert(4.52*100);
    return s/temp;
}
*/
Number.prototype.toFixed=function (d) 
{ 

  var s=this+""; 
  if(!d)d=0;     
  if(s.indexOf(".")==-1)s+="."; 
  s+=new Array(d+1).join("0");     
  if(new RegExp("^(-|\\+)?(\\d+(\\.\\d{0,"+(d+1)+"})?)\\d*$").test(s)) 
  { 

    var s="0"+RegExp.$2,pm=RegExp.$1,a=RegExp.$3.length,b=true;       
    if(a==d+2){ 
      a=s.match(/\d/g); 
      if(parseInt(a[a.length-1])>4) 
      { 

        for(var i=a.length-2;i>=0;i--){ 
          a[i]=parseInt(a[i])+1;             
          if(a[i]==10){ 
            a[i]=0; 
            b=i!=1; 

          }else break; 

        } 

      } 
      s=a.join("").replace(new RegExp("(\\d+)(\\d{"+d+"})\\d$"),"$1.$2");         

    }if(b)s=s.substr(1); 
    return (pm+s).replace(/\.$/,""); 

  }return this+"";     

};   

