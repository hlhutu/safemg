package cn.scihi.mbgl.controller;

import cn.scihi.mbgl.ucc.impl.StaffUcc;
import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * @author uplus
 *
 */
@Controller
@SysLog(module = "人员")
@RequestMapping("/staff")
public class StaffController extends BizController {

	@Autowired
	private StaffUcc staffUcc;

	public void init() {
		super.setBaseUcc(staffUcc);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/模板
	 * @title 查询我的下级人员列表
	 * @description 只查询我的直接下级
	 * @method get
	 * @url /smg/staff/mydown/{myusername}.do
	 * @param myusername 路径参数 String 当前登陆人的username
	 * @return {}
	 * @return_param datas List 下级人员列表
	 * @return_param username String 账号
	 * @return_param user_alias String 昵称
	 * @return_param user_photo String 头像base64
	 * @return_param role_names String 角色名，多个逗号隔开
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/mydown/{myusername}.do", method = RequestMethod.GET)
	@SysLog(module = "模板管理", method = "查询我的下级人员列表")
	public String myDown(HttpServletRequest request, Map<String, Object> map, @PathVariable String myusername) throws Exception {
		map = getParameterMap(request, false);
		map.put("datas", staffUcc.myDown(myusername));
		return toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/模板
	 * @title 查询用户
	 * @description 根据机构id，角色id查询
	 * @method get
	 * @url /smg/staff/users.do
	 * @param orgId 是 String 机构id
	 * @param roleId 是 String 角色id
	 * @return {}
	 * @return_param datas List 下级人员列表
	 * @return_param username String 账号
	 * @return_param user_alias String 昵称
	 * @return_param user_photo String 头像base64
	 * @return_param mobile_phone String 手机号
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/users.do", method = RequestMethod.GET)
	@SysLog(module = "模板管理", method = "查询我的下级人员列表")
	public String loadUsers(HttpServletRequest request, Map<String, Object> map) throws Exception {
		map = this.getParameterMap(request, false);
		map.put("datas", staffUcc.queryUsersByOrgIdAndRoleId(map));
		return toJSONString(map);
	}
}
