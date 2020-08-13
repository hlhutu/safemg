package cn.scihi.emer.controller;

import cn.scihi.emer.ucc.impl.EmerEventUcc;
import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author uplus
 *
 */
@Controller
@SysLog(module = "应急-事件")
@RequestMapping("/emerEvent")
public class EmerEventController extends BizController {

	@Autowired
	private EmerEventUcc emerEventUcc;

	public void init() {
		super.setBaseUcc(emerEventUcc);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/应急
	 * @title 查询应急事件列表
	 * @description -
	 * @method get
	 * @url /smg/emerEvent/select.do
	 * @param begin_date 否 String 开始日期，将会查询改时间之后的所有数据
	 * @return {}
	 * @return_param category String类型
	 * @return_param event_level String 级别
	 * @return_param event_time String 发生时间
	 * @return_param address String 发生地点
	 * @return_param lon String 经度
	 * @return_param lat String 维度
	 * @return_param title String 标题
	 * @return_param description String 描述
	 * @return_param  event_result String 处置结果
	 * @return_param  creator String 创建人
	 * @return_param  created Date 创建时间
	 * @remark
	 * @number 0
	 */
}
