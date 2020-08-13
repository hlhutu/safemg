/**
 * 
 */
package cn.scihi.mbgl.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.scihi.mbgl.ucc.impl.MbOrgUcc; 
import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation.SysLog;

/**
 * @author wyc
 *
 */
@Controller
@SysLog(module = "模板机构关联管理")
@RequestMapping(value = "/jsp/mbgl/mbOrg")
public class MbOrgController extends BizController {

	@Resource
	private MbOrgUcc mbOrgUcc;

	public void init() {
		super.baseUcc = mbOrgUcc;
	}
	@ResponseBody
	@RequestMapping(value = "/selectCanAddMb.do")
	@SysLog(module = "考勤管理", method = "查询数据")
	public String selectCanAddMb(Map<String,Object> map) throws Exception{
		map = getParameterMap(request, false); 
		map.put("datas", mbOrgUcc.selectCanAddMb(map));
		map.put("resCode", "success");
		return toJSONString(map);
	}
	@ResponseBody
	@RequestMapping(value = "/insertRealtions.do")
	@SysLog(module = "考勤管理", method = "查询数据")
	public String insertRealtions(Map<String,Object> map) throws Exception{ 
		map = getParameterMap(request, true);
		map.put("datas", mbOrgUcc.insertRealtions(map, request));
		return toJSONString(map);
	}
}
