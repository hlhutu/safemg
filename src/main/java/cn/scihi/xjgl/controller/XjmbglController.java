package cn.scihi.xjgl.controller;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import cn.scihi.xjgl.ucc.impl.XjmbglUcc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * @author uplus
 *
 */
@RestController
@SysLog(module = "巡检模板管理")
@RequestMapping("/biz/xjmbgl")
public class XjmbglController extends BizController {

	@Autowired
	private XjmbglUcc xjmbglUcc;

	public void init() {
		super.setBaseUcc(xjmbglUcc);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/巡检
	 * @title 查询巡检模板列表
	 * @description -
	 * @method get
	 * @url /smg/biz/xjmbgl/query.do
	 * @param fxid 否 String 风险点位id
	 * @return {}
	 * @return_param datas List 巡检模板列表
	 * @return_param datas[0].infos List 该模板下的巡检任务项
	 * @remark
	 * @number 0
	 */
	@RequestMapping({"/query.do"})
	@SysLog(module = "巡检", method = "查询巡检模板")
	public String select(HttpServletRequest request, Map<String, Object> map, String fxid) throws Exception {
		map = this.getParameterMap(request, false);
		try{
			map.put("datas", xjmbglUcc.queryByFxId(fxid));
		}catch (Exception e){
			e.printStackTrace();
		}
		return this.toJSONString(map);
	}
}
