package cn.scihi.xjgl.controller;

import cn.scihi.xjgl.service.impl.XjglService;
import cn.scihi.xjgl.ucc.impl.XjglUcc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.NotBlank;
import java.util.HashMap;
import java.util.Map;

/**
 * @author uplus
 *
 */
@Controller
@SysLog(module = "巡检管理")
@RequestMapping("/biz/xjgl")
public class XjglController extends BizController {

	@Autowired
	private XjglUcc xjglUcc;
	@Autowired
	private XjglService xjglService;

	public void init() {
		super.setBaseUcc(xjglUcc);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/巡检
	 * @title 查询巡检实例列表
	 * @description -
	 * @method get
	 * @url /smg/biz/xjgl/select.do
	 * @param zxr 是 String 执行人user_name
	 * @return {}
	 * @return_param datas List 巡检模板列表
	 * @return_param datas[0].infos List 该模板下的巡检任务项
	 * @remark
	 * @number 0
	 */

	/**
	 * showdoc
	 * @catalog 南充应急/巡检
	 * @title 创建巡检
	 * @description -
	 * @method get
	 * @url /smg/biz/xjgl/create.do
	 * @param fxId 是 String 风险点id
	 * @param req_model_id 否 String 巡检计划id，不选择巡检计划传null
	 * @param username 是 String 执行人user_name
	 * @param pid 否 String 关联的任务id
	 * @return {}
	 * @return_param datas List 巡检模板列表
	 * @return_param datas[0].infos List 该模板下的巡检任务项
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/create.do", method = RequestMethod.POST)
	@SysLog(module = "巡检管理", method = "创建巡检任务")
	public String create(HttpServletRequest request,  @NotBlank String fxId, String req_model_id, @NotBlank String username, String pid) throws Exception {
		Map<String, Object> map = xjglService.newInstance(fxId, req_model_id, username, pid);
		Map<String, Object> result = new HashMap<>();
		result.put("datas", map);
		return toJSONString(result);
	}
}
