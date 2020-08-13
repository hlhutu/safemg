package cn.scihi.comm.controller;

import cn.scihi.comm.service.CheckcodeService;
import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.core.MyApiUtils;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import com.alibaba.fastjson.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * @author uplus
 *
 */
@Controller
@SysLog(module = "验证码")
@RequestMapping("/checkcode")
public class CheckcodeController extends BizController {

	@Autowired
	private IBaseUcc cycleUcc;

	public void init() {
		super.setBaseUcc(cycleUcc);
	}

	@Autowired
	private CheckcodeService checkcodeService;

	/**
	 * showdoc
	 * @catalog 南充应急/用户
	 * @title 获取验证码
	 * @description 验证码有效期30分钟
	 * @method get
	 * @url /smg/checkcode
	 * @param user_name 否 String 手机号（账号），如不传此字段则是批量验证码，可以重复使用。
	 * @return {}
	 * @return_param datas String 验证码
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "", method = RequestMethod.GET)
	@SysLog(module = "用户", method = "生成验证码")
	public String getCheckcode(HttpServletRequest request, String user_name) throws Exception {
		return checkcodeService.generator(user_name);
	}
}
