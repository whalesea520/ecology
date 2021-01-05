import {Select, Checkbox, Radio} from 'antd';
import './style/index.css'
import trim from 'lodash/trim'
import classNames from 'classnames'
import isEmpty from 'lodash/isEmpty'
import isEqual from 'lodash/isEqual'
import WeaTools from '../wea-tools'

const CheckboxGroup = Checkbox.Group;
const RadioGroup = Radio.Group;

const Option = Select.Option;

class main extends React.Component {
  static defaultProps = {
    widthMatchOptions: false, // select 框的宽度匹配options 的宽度
    dropdownMatchSelectWidth: false,
  }
  constructor(props) {
    super(props);
    this.state = {
      value: props.value || this.getDefaultValue(props.options) || '', // id,id,id
    };
    if (props.detailtype == 1 && !isEmpty(props.options) && props.value) {
      if (props.options.filter((o) => o.key == props.value).length == 0) {
        this.state.value = '';
        this.props.onChange && this.props.onChange('');
      }
    }
    this.setValue = this.setValue.bind(this);
  }
  componentDidMount(){
    const {widthMatchOptions, options} = this.props;
    if (widthMatchOptions) {
      let minWidth = this.getOptionsWidth(options);
      let parentWidth = $(this.refs.wrapper).parent().outerWidth();
      this.setState({minWidth, maxWidth: parentWidth});
    }
  }
  getDefaultValue(options = []) {
    let res = '';
    options.forEach((o)=>{
      if (o.selected) res = o.key;
    });
    return res;
  }
  componentWillReceiveProps(nextProps) {
    if ('value' in nextProps && this.state.value !== nextProps.value) {
      let v = nextProps.value || '';
      const {options} = nextProps;
      if (nextProps.detailtype == 1  && !isEmpty(options)) {
        if (options.filter((o) => o.key == v).length == 0) {
          v = '';
          if (v !== this.props.value) this.props.onChange && this.props.onChange(v);
        }
      }
      this.setState({value: v});
    }
    if ('options' in nextProps && this.props.widthMatchOptions && !isEqual(nextProps.options, this.props.options)) {
      this.setState({minWidth: this.getOptionsWidth(nextProps.options)});
    }
  }
  getOptionsWidth(options) {
    let minWidth = 40;
    if (!isEmpty(options)) {
      options.forEach(o => {
        let textWidth = WeaTools.getTextWidth(o.showname) + 35;
        minWidth = textWidth > minWidth ? textWidth: minWidth;
      })
    }
    const parentWidth = $(this.refs.wrapper).parent().outerWidth();
    if (parentWidth && parentWidth -20 < minWidth) minWidth = parentWidth -20;
    return minWidth;
  }
  shouldComponentUpdate(nextProps, nextState) {
    return nextProps.value !== this.props.value ||
      nextProps.viewAttr !== this.props.viewAttr ||
      nextProps.underline !== this.props.underline ||
      nextProps.hasBorder !== this.props.hasBorder ||
      nextState.value !== this.state.value ||
      nextState.minWidth !== this.state.minWidth ||
      !isEqual(nextProps.options, this.props.options) ||
      nextProps.fieldName !== this.props.fieldName;
  }
  isReadOnly() {
    const {viewAttr} = this.props;
    return viewAttr === 1 || viewAttr === '1';
  }
  render() {
    const {underline, options, layout, style, detailtype = 1, fieldshowtypes, viewAttr,fieldName, isDetail, hasBorder, widthMatchOptions} = this.props;
    const { value } = this.state;
    //detailtype 1: 正常显示,2:checkbox 多选,3:radio 单选
    const verticalStyle = fieldshowtypes == 2 ? {display: 'block'} : {};
    if (detailtype == 4 && viewAttr == '1') {
      return <div className={`wea-select`}> <span className="wea-select-list">
        {
          options && options.map((data)=>{
          return (
            <span className={`wea-select-list-item`}
              title={data.showname}>
            {data.showname}</span>
            )
          })
        }
      </span></div>
    }
    if (this.isReadOnly()) {
      const readonly = classNames({
        'border': hasBorder,
        'underline': underline,
      });
      let v = value.split(',')
      return (
        <span className={`wea-field-readonly ${readonly}`} style={style}>
          {!isEmpty(v) && !isEmpty(options) &&
            options.map(o =>{
              if (v.indexOf(o.key) > -1) {
                return <span className="child-item wdb">{o.showname}</span>
              }
            })
          }
          <input type="hidden" id={fieldName} name={fieldName} value={value} />
        </span>
      )
    }
    const disabled = viewAttr === 1;
    let objArr = [];
    if (!isEmpty(options)) {
      objArr = options.map(o=>{
        o.style = verticalStyle;
        o.label = o.showname;
        o.disabled = disabled;
        o.value = o.value || o.key;
        return o
      });
      objArr = objArr.filter(o => o.value !== '');
    }
    const selectStyle = {...style} || {};
    if (widthMatchOptions) {
      if (selectStyle.minWidth) delete selectStyle.minWidth;
      selectStyle.minWidth = this.state.minWidth;
      selectStyle.maxWidth = this.state.maxWidth -3;
    }
    const cls = classNames({
      'mr12': /^field/.test(fieldName) || (viewAttr == '3' && value.length == 0),
      'wea-field': /^field/.test(fieldName),
    });
    return(
      <div className={`wea-select ${cls}`} ref="wrapper">
        {
          detailtype == 1 &&
          <Select
            ref="select"
            size={'default'}
            disabled={this.props.disabled}
            style={selectStyle}
            getPopupContainer={() => (layout || document.body)}
            dropdownMatchSelectWidth={this.props.dropdownMatchSelectWidth}
            value={value}
            animation=""
            onChange={this.setValue}>
          {
            options && options.map((data)=>{
              return (
                <Option key={data.key} value={data.key} title={data.showname}>{data.showname}</Option>
              )
            })
          }
          </Select>
        }
        {
          detailtype == 2 &&
          <CheckboxGroup options={objArr} value={value ? value.split(',') : []} onChange={this.setValue} />
        }
        {
          detailtype == 3 &&
          <RadioGroup value={value} onChange={this.setValue} >
            {
              objArr.map((data)=>{
                return (
                  <Radio style={data.style} key={data.key} disabled={disabled} value={data.key}>{data.showname}</Radio>
                )
              })
            }
            </RadioGroup>
        }
        {
          detailtype == 4 && <span className="wea-select-list">
            {
              options && options.map((data)=>{
              return (
                  <span className={`wea-select-list-item cursor-pointer ${data.key == value?'active':''}`}
                    onClick={this.setValue.bind(this, data.key)}
                    key={data.key} title={data.showname}>
                  {data.showname}</span>
                )
              })
            }
          </span>
        }
        {
          (viewAttr == '3' || viewAttr == '2') &&
          <span className="wea-required-e9" id={`${this.props.fieldName}span`}>
            {viewAttr == '3' && value.length == 0 &&
            <img src="/images/BacoError_wev9.png" align="middle"/>}
          </span>
        }
        <input type='hidden' name={fieldName} id={fieldName} value={value} />
      </div>
    )
  }
  setValue(value) {
    if(typeof value == 'object' && 'target' in value){
      value = value.target.value == this.state.value ? '' : value.target.value;
    }
    this.setState({value: `${value}`});
    typeof this.props.onChange == 'function' && this.props.onChange(`${value}`);
  }
}

export default main