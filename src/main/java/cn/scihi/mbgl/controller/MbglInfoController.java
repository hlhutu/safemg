/**
 * 
 */
package cn.scihi.mbgl.controller;

import cn.scihi.mbgl.ucc.impl.MbglInfoUcc;
import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * @author yove
 *
 */
@Controller
@SysLog(module = "模板详情管理")
@RequestMapping(value = "/jsp/mbgl/mbglInfo")
public class MbglInfoController extends BizController {

	@Resource
	private MbglInfoUcc mbglInfoUcc;

	public void init() {
		super.baseUcc = mbglInfoUcc;
	}
	
	@ResponseBody
	@RequestMapping(value = "/callback.do")
	public String callback(HttpServletRequest request, Map<String, Object> map) throws Exception {
		return request.getParameter("value");
	}
	
	
	@ResponseBody
	@RequestMapping({"/insert.do"})
	@SysLog(module = "模板详情", method = "修改数据")
	public String insert(HttpServletRequest request, Map<String, Object> map) throws Exception {
		map = this.getParameterMap(request, false);
		map.put("datas", mbglInfoUcc.insert(map, request));
		return this.toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/模板
	 * @title 查询模板下的任务项
	 * @description -
	 * @method get
	 * @url /jsp/mbgl/mbglInfo/taskDefs.do
	 * @param glid 是 string 模板id
	 * @param username 是 string 用户名
	 * @param stat 否 String 进度：已完成，未开始，进行中。默认查询全部。
	 * @return {}
	 * @return_param datas Object 返回数据
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = {"/taskDefs.do"}, method = RequestMethod.GET)
	@SysLog(module = "模板详情", method = "查询模板下的任务项")
	public String queryTaskDefs(HttpServletRequest request, String glid, String username, String stat) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("datas", mbglInfoUcc.selectTaskDefs(glid, username, stat));
		return this.toJSONString(map);
	}
	/**
	 * showdoc
	 * @catalog 南充应急/模板
	 * @title 在模板下保存任务项列表
	 * @description 全量保存，保存之前会删除当前模板下所有任务项，然后保存所有任务项。
	 * @method post
	 * @url /jsp/mbgl/mbglInfo/taskDefs.do
	 * @param glid 是 string 模板id
	 * @param mbgl_info_list 是 Map 任务项列表，Map形式的List，元素为单个任务项目。形如：{"0":{...},"1":{...}}
	 * @return {}
	 * @return_param datas Object 返回数据
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = {"/taskDefs.do"}, method = RequestMethod.POST)
	@SysLog(module = "模板详情", method = "在模板下保存任务项列表")
	public String taskdefs(HttpServletRequest request, Map<String, Object> map) throws Exception {
		map = this.getParameterMap(request, false);
		map.put("datas", mbglInfoUcc.insertFirst(map, request));
		return this.toJSONString(map);
	}

	@ResponseBody
	@RequestMapping({"/update.do"})
	@SysLog(module = "模板详情", method = "修改数据")
	public String update(HttpServletRequest request, Map<String, Object> map) throws Exception {
		map = this.getParameterMap(request, false);
		map.put("datas", mbglInfoUcc.update(map, request));
		return this.toJSONString(map);
	}
	
}
