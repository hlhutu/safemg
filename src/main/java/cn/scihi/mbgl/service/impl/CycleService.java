package cn.scihi.mbgl.service.impl;

import cn.scihi.mbgl.bean.Cycle;
import cn.scihi.mbgl.mapper.CycleMapper;
import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * @author uplus
 *
 */
@Service
public class CycleService extends ServiceAdapter {

	private final String cycle_y = "y";
	private final String cycle_m = "m";
	private final String cycle_d = "d";
	private final String cycle_w = "w";
	private final String cycle_q = "q";
	private final String cycle_hy = "hy";

	@Autowired
	private CycleMapper cycleMapper;

	public void init() throws Exception {
		super.setBaseMapper(cycleMapper);
	}

	/**
	 *
	 * @param taskDefId
	 * @param ids
	 * @return
	 */
	public List<Cycle> getCycleList(String taskDefId, List<String> usernames) {
		return cycleMapper.getCycleList(taskDefId, usernames);
	}

	/**
	 * 判断一个周期是否已经完结，如果完结，会更新到下一个周期
	 * @param myCycle
	 * @return
	 */
	public boolean overVersion(Cycle myCycle, Map<String, Object> taskDef, String username, boolean bool) throws Exception {
		String cycleType = (String) taskDef.get("cycle");
		if(!bool && StringUtils.isEmpty(cycleType)){//不是强制生成的情况下，没有周期的任务不会生成
			return false;
		}
		Date lastVersionStart = this.getLastVersionStart(cycleType);
		if(myCycle==null){//没有生成过，则立即生成记录，并返回true，表示命中周期
			Map<String, Object> insertMap = new HashMap<>();
			insertMap.putAll(taskDef);
			insertMap.remove("id");
			insertMap.put("model_id", taskDef.get("glid"));
			insertMap.put("task_def_id", taskDef.get("id"));
			insertMap.put("username", username);
			insertMap.put("last_version", lastVersionStart);
			this.insert(insertMap);
			return true;
		}
		//Date nextVersionDate = this.getNextVersionStart(myCycle.getLast_version(), cycleType, cycleLong);//获取下一个周期开始时间
		//禁止多个周期
		if(myCycle.getLast_version().before(lastVersionStart)){//如果记录中的周期小于最新周期
			this.updateLastDate(lastVersionStart, myCycle.getId());
			return true;
		}
		return false;
	}

	private Date getLastVersionStart(String cycleType) {
		Calendar lastCal = Calendar.getInstance();
		lastCal.setTime(new Date());//从当前时间开始计算
		lastCal.set(Calendar.HOUR_OF_DAY, 0);
		lastCal.set(Calendar.MINUTE, 0);
		lastCal.set(Calendar.SECOND, 0);
		lastCal.set(Calendar.MILLISECOND, 0);//忽略时分秒
		if(cycle_y.equals(cycleType)){
			lastCal.set(Calendar.MONTH, 0);//移到该年1月1日
			lastCal.set(Calendar.DAY_OF_MONTH, 1);
		}else if(cycle_m.equals(cycleType)){
			lastCal.set(Calendar.DAY_OF_MONTH, 1);//移到到该月1日
		}else if(cycle_w.equals(cycleType)){
			lastCal.set(Calendar.DAY_OF_WEEK, 2);//移到该周第一天
		}else if(cycle_q.equals(cycleType)){
			lastCal.set(Calendar.DAY_OF_MONTH, 1);//移到到该月1日
			int mon = lastCal.get(Calendar.MONTH);
			int step = mon%3;//计算偏移值，即超过0，3，6，9的量
			lastCal.set(Calendar.MONTH, mon-step);
		}else if(cycle_hy.equals(cycleType)){
			lastCal.set(Calendar.DAY_OF_MONTH, 1);//移到到该月1日
			int mon = lastCal.get(Calendar.MONTH);
			int step = mon%6;//计算偏移值，即超过0，6的量
			lastCal.set(Calendar.MONTH, mon-step);
		}
		return lastCal.getTime();
	}

	private void updateLastDate(Date versionDate, String id) {
		Map<String, Object> updateMap = new HashMap<>();
		updateMap.put("id", id);
		updateMap.put("last_version", versionDate);
		cycleMapper.update(updateMap);
	}

	public void deleteByModelId(String modelId) {
		Map<String, Object> updateMap = new HashMap<>();
		updateMap.put("model_id", modelId);
		cycleMapper.delete(updateMap);
	}
}
