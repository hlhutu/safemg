package cn.scihi.mbgl.service.impl;

import cn.scihi.mbgl.mapper.ReportMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author uplus
 *
 */
@Service
public class ReportService extends ServiceAdapter {

	@Autowired
	private ReportMapper reportMapper;

	public void init() throws Exception {
		super.setBaseMapper(reportMapper);
	}

	public List<Map<String, Object>> lvzhi1(String year, String month, String org_id) {
		return reportMapper.lvzhi1(year, month, org_id);
	}

	public List<Map<String, Object>> lvzhi2(String year, String month, String org_id) {
		return reportMapper.lvzhi2(year, month, org_id);
	}

	public Map<String, Object> zhifaByMonth(String year, String month, String org_id) {
		return reportMapper.zhifaByMonth(year, month, org_id);
	}

	public Map<String, Object> zhifaByYear(String year, String org_id) {
		return reportMapper.zhifaByMonth(year, null, org_id);
	}

	public Map<String, Object> zaihailevel(String year, String month, String org_id) {
		List<Map<String, Object>> list = reportMapper.zaihailevel(year, month, org_id);//本期
		List<Map<String, Object>> oldList = reportMapper.zaihailevel(String.valueOf(Integer.valueOf(year)-1), month, org_id);//同比期
		if(CollectionUtils.isEmpty(list)){
			return new HashMap<>();
		}
		for (Map<String, Object> stringObjectMap : list) {
			stringObjectMap.put("ctold", 0L);//去年同期值为0
		}
		if(!CollectionUtils.isEmpty(oldList)){
			for (Map<String, Object> stringObjectMap : list) {
				String key = (String) stringObjectMap.get("tname");
				if(key==null){
					continue;
				}
				for (Map<String, Object> objectMap : oldList) {
					if(key.equals(objectMap.get("tname"))){
						stringObjectMap.put("ctold", objectMap.get("ct"));
					}
				}
			}
		}
		Map<String, Object> map = new HashMap<>(list.size());
		Long total, oldTotal;
		for (Map<String, Object> stringObjectMap : list) {
			String key = (String) stringObjectMap.get("tname");
			if(key==null){
				continue;
			}
			total = (Long) stringObjectMap.get("ct");
			oldTotal = (Long) stringObjectMap.get("ctold");
			if(oldTotal==0){
				stringObjectMap.put("tongbi", 0);
			}else{
				stringObjectMap.put("tongbi", (total-oldTotal)/oldTotal);
			}
			map.put(key, stringObjectMap);
		}
		return map;
	}

	public List<Map<String, Object>> zaihaiqushi(String year, String org_id) throws ParseException {
		String dateStr = new SimpleDateFormat("yyyy").format(new Date())+"-01-01";
		Date nowYear = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
		Calendar nowYearCal = Calendar.getInstance();
		nowYearCal.setTime(nowYear);
		nowYearCal.add(Calendar.YEAR, -5);//向前移5年
		return reportMapper.zaihaiqushi(org_id, nowYearCal.getTime());
	}
}
