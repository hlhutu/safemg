package cn.scihi.mbgl.ucc.impl;

import cn.scihi.mbgl.service.impl.ReportService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
@Service
public class ReportUcc extends UccAdapter {

	@Autowired
	private ReportService reportService;

	public void init() throws Exception {
		super.setBaseService(reportService);
	}

	public List<Map<String, Object>> lvzhi1(String year, String month, String org_id) {
		return reportService.lvzhi1(year, month, org_id);
	}

	public List<Map<String, Object>> lvzhi2(String year, String month, String org_id) {
		return reportService.lvzhi2(year, month, org_id);
	}

	public Map<String, Object> zhifa(String year, String month, String org_id) {
		Map<String, Object> map = new HashMap<>();
		if(month!=null){
			map.put("month", reportService.zhifaByMonth(year, month, org_id));
		}
		map.put("year", reportService.zhifaByYear(year, org_id));
		return map;
	}

    public Map<String, Object> zaihailevel(String year, String month, String org_id) {
		return reportService.zaihailevel(year, month, org_id);
    }

	public List<Map<String, Object>> zaihaiqushi(String year, String org_id) throws ParseException {
		return reportService.zaihaiqushi(year, org_id);
	}
}
