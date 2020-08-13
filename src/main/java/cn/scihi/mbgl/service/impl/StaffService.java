package cn.scihi.mbgl.service.impl;

import cn.scihi.mbgl.bean.Staff;
import cn.scihi.mbgl.mapper.StaffMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;

import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
@Service
public class StaffService extends ServiceAdapter {

	@Autowired
	private StaffMapper staffMapper;

	public void init() throws Exception {
		super.setBaseMapper(staffMapper);
	}

	public List<Staff> queryMyDown(String myusername) {
		List<Staff> list = staffMapper.queryMyDown(myusername);
		return list;
	}

    public List<Staff> queryUsersByOrgIdAndRoleId(Map<String, Object> map) {
		List<Staff> list = staffMapper.queryUsersByOrgIdAndRoleId(map);
		return list;
    }
}
