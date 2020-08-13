package cn.scihi.mbgl.service.impl;

import cn.scihi.comm.util.Prop;
import cn.scihi.mbgl.mapper.PropMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
@Service
public class PropService extends ServiceAdapter {

	@Autowired
	private PropMapper propMapper;

	public void init() throws Exception {
		super.setBaseMapper(propMapper);
	}

	/**
	 * 保存属性，将会删除相同key下的所有记录，然后重新保存
	 * @param category
	 * @param key_
	 * @param values
	 * @return
	 */
	public boolean save(String category, String key_, String... values){
		this.remove(category, key_);
		this.add(category, key_, values);
		return true;
	}

	/**
	 * 新增属性，不会删除已有记录
	 * @param category
	 * @param key_
	 * @param values
	 * @return
	 */
	public boolean add(String category, String key_, String... values){
		Map<String, Object> bean = new HashMap<>();
		bean.put("category", category);
		bean.put("key_", key_);
		int i=1;
		for (String value : values) {
			bean.put("value"+(i++), value);
		}
		propMapper.insert(bean);
		return true;
	}

	/**
	 * 移除一个属性
	 * @param category
	 * @param key_
	 * @return
	 */
	public boolean remove(String category, String key_){
		Map<String, Object> bean = new HashMap<>();
		bean.put("category", category);
		bean.put("key_", key_);
		propMapper.delete(bean);
		return true;
	}

	public Prop getProp(String category, String key_){
		List<Prop> list = this.getProps(category, key_);
		if(CollectionUtils.isEmpty(list)){
			return null;
		}else{
			return list.get(0);
		}
	}

	public String getPropValue(String category, String key_){
		List<Prop> list = this.getProps(category, key_);
		if(CollectionUtils.isEmpty(list)){
			return null;
		}else{
			return list.get(0).getValue();
		}
	}

	public List<String> getPropValues(String category, String key_){
		List<Prop> list = this.getProps(category, key_);
		if(CollectionUtils.isEmpty(list)){
			return null;
		}else{
			return list.get(0).getValues();
		}
	}

	public List<Prop> getProps(String category, String key_){
		Map<String, Object> bean = new HashMap<>();
		bean.put("category", category);
		bean.put("key_", key_);
		List<Prop> list = propMapper.selectForBean(bean);
		if(CollectionUtils.isEmpty(list)){
			return null;
		}else{
			return list;
		}
	}

	public List<String> getPropListValue(String category, String key_){
		List<Prop> list = this.getProps(category, key_);
		if(CollectionUtils.isEmpty(list)){
			return null;
		}else{
			List<String> result = new ArrayList<>(list.size());
			for (Prop prop : list) {
				result.add(prop.getValue());
			}
			return result;
		}
	}
}
