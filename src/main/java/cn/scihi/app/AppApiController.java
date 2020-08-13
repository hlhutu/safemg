package cn.scihi.app;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.core.MyApiUtils;
import cn.scihi.sdk.util.SysAnnotation.SysLog;

/**
 * @author uplus
 *
 */
@Controller
@SysLog(module = "版本二维码")
@RequestMapping("/api/biz/app")
public class AppApiController extends BizController {

	@Autowired
	private IBaseUcc appUcc;
	@Autowired
	private AppUcc myAppUcc;

	public void init() {
		super.setBaseUcc(appUcc);
	}
	
	@GetMapping("/qrcode.do")
	public void QrCode(HttpServletResponse response,@RequestParam(value="version",required=false) String version) throws Exception{
		String url = MyApiUtils.ups+"/local"+this.myAppUcc.getCodeUrl(version);
		response.sendRedirect(url);
	}
}
