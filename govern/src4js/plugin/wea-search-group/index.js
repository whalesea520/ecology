import {Row, Col, Icon} from 'antd';
// import Row from '../../_antd1.11.2/row'
// import Col from '../../_antd1.11.2/col'
// import Icon from '../../_antd1.11.2/icon'
import './style/index.css'

class SearchGroup extends React.Component {
	constructor(props) {
        super(props);
        this.state = {
            showGroup: props.showGroup ? props.showGroup : false
        }
    }
    componentWillReceiveProps(nextProps) {
        // if (this.props.showGroup !== nextProps.showGroup) {
        //     this.setState({showGroup: nextProps.showGroup});
        // }
    }
	render() {
        const {title,items,needTigger=true,col = 2,customComponent='', children} = this.props;
        const {showGroup} = this.state;
        //console.log("items:",items);
        return (
            <div className={`wea-search-group ${this.props.className || ''}`}>
                <Row className="wea-title">
                    <Col span="19">
                        <div>{title}</div>
                    </Col>
                    {customComponent &&
                        <Col span={4} style={{textAlign:"right",paddingRight:10,fontSize:12}}>
                            {customComponent}
                        </Col>
                    }
                    {needTigger &&
	                    <Col span={customComponent?1:5} style={{textAlign:"right",paddingRight:10,fontSize:12,paddingTop: 5}}>
	                        <i className={showGroup ? 'icon-coms-up' : 'icon-coms-down'} onClick={()=>this.setState({showGroup:!showGroup})}/>
	                    </Col>
                    }
                </Row>
                <Row className="wea-content" style={showGroup ? {} : {display: 'none'}}>
                    {
                        items && items.map((obj)=>{
                            let cellNum = obj.col || col;
                            return (
                                <Col className={`wea-form-cell ${obj.hide? 'wea-hide': ''}`} span={24/cellNum}>
                                    {obj.com}
                                </Col>
                            )
                        })
                    }
                    {
                        children
                    }
                </Row>
            </div>
        )
    }

}

export default SearchGroup