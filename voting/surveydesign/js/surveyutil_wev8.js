/**
 * Created with JetBrains WebStorm.
 * User: Administrator
 * Date: 14-8-18
 * Time: 上午10:36
 * To change this template use File | Settings | File Templates.
 */
function StringBuffer(){
    this.container=[];
}
//添加条目
StringBuffer.prototype.append=function(item){
    this.container.push(item);
}
//用指定的分隔符链接所有的条目
StringBuffer.prototype.join=function(separator){
    return this.container.join(separator);
}
