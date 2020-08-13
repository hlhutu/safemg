package cn.scihi.report.controller;

import cn.scihi.report.service.DataInputService;
import cn.scihi.sdk.base.controller.BaseController;
import cn.scihi.sdk.util.SysAnnotation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.NotBlank;
import java.util.List;
import java.util.Map;

@Controller
@SysAnnotation.SysLog(module = "数据录入统计")
@RequestMapping("/datainput")
public class DataInputReport extends BaseController {
    @Autowired
    private DataInputService dataInputService;

    @ResponseBody
    @RequestMapping(value = {"/all"}, method = RequestMethod.GET)
    public List<Map<String, Object>> all(HttpServletRequest request, String P_ORG_ID, @NotBlank String P_ORG_ID_) throws Exception {
        if(StringUtils.isEmpty(P_ORG_ID)){
            P_ORG_ID = P_ORG_ID_;
        }
        return dataInputService.allDataInput(P_ORG_ID);
    }
}
