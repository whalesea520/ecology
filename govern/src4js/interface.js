import * as formAction from './actions/form'
import * as Util from './util/modeUtil'

let __propertyChangeFnArray = {};
jQuery.fn.extend({
    bindPropertyChange: function (funobj) {
        return this.each(function () {
            var thisid = jQuery(this).attr('id');
            var fnArr = __propertyChangeFnArray[thisid];
            if (!!!fnArr) {
                fnArr = new Array();
                __propertyChangeFnArray[thisid] = fnArr;
            }
            fnArr.push(funobj);
        });
    }
});

window.__propertyChangeFnArray = __propertyChangeFnArray;

export const modeForm = {
    setValue: function (field, value) {
        formmodeDoAction(formAction.changeFieldInfo, field, value);
    },
    changeShowAttr: function (field, viewattr) {
        formmodeDoAction(formAction.changeShowAttr, field, viewattr);
    },
    getValue: function (field) {
        try {
            field = field.replace("field", "");
            let drowIndex = null;
            let fid = field
            if (field.indexOf("_") > -1) {
                fid = field.split("_")[0];
                drowIndex = field.split("_")[1];
            }
            return (Util.getFieldValue(field, drowIndex));
        } catch (e) {

        }
    },
    addrow: function (tablename, initialData = {}) {
        formmodeDoAction(formAction.addrow, tablename, initialData);
    },
    delrow: function (tablename) {
        formmodeDoAction(formAction.delrow, tablename);
    },
    delRealRow: function (tablename, indexes) {
        formmodeDoAction(formAction.delRealRow, tablename, indexes);
    },
    changeReplyAttr: function () {
        formmodeDoAction(formAction.changeReplyAttr);
    }

}

window.modeForm = modeForm;