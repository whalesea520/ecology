import {Input, Button} from 'antd';
// import Input from '../../_antd1.11.2/input'
// import Button from '../../_antd1.11.2/button'
import classNames from 'classnames';
const InputGroup = Input.Group;

class WeaInputFocus extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            value: props.value || '',
            focus: false,
        }
    }
    componentWillReceiveProps(nextProps,nextState){
    	nextProps.value !== 'undefined' && nextProps.value !== this.props.value && nextProps.value !== this.state.value && this.setState({value:nextProps.value || ''});
    }
    handleFocusBlur(e) {
        if(typeof this.props.onFocusChange === "function"){
            this.props.onFocusChange(e.target === document.activeElement);
        }
        this.setState({
            focus: e.target === document.activeElement,
        });
    };
    handleInputChange(e) {
        this.setState({
            value: e.target.value,
        });
        if (this.props.onSearchChange) {
            this.props.onSearchChange(e.target.value);
        }
    };
    handleSearch() {
        if (this.props.onSearch) {
            this.props.onSearch(this.state.value);
        }
    };
    enterKeyDown(e){
    	e.keyCode == 13 && this.handleSearch();
    }
    render() {
        const { style, placeholder } = this.props;
        const btnCls = classNames({
            'ant-search-btn': this.state.focus,
        });
        return (
            <div className="wea-input-focus" onKeyDown={this.enterKeyDown.bind(this)} style={style}>
                <Input placeholder={placeholder}
                       value={this.state.value}
                       onFocus={this.handleFocusBlur.bind(this)}
                       onBlur={this.handleFocusBlur.bind(this)}
                       onChange={this.handleInputChange.bind(this)}

                    />
                {this.state.value && <icon className="icon-coms-Clear" onClick={this.clear}/>}
                <Button className={`${btnCls} wea-input-focus-btn`} type="ghost" icon="search"
                        onClick={this.handleSearch.bind(this)}
                    />
            </div>
        )
    }
    clear = () => {
    	this.setState({
    	    value: ''
        });
        if (this.props.onSearchChange) {
            this.props.onSearchChange('');
        }
    }
}
export default WeaInputFocus;