package cn.scihi.mbgl.ucc.impl;

import cn.scihi.mbgl.bean.Staff;
import cn.scihi.mbgl.service.impl.StaffService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
@Service
public class StaffUcc extends UccAdapter {

	@Autowired
	private StaffService staffService;

	public void init() throws Exception {
		super.setBaseService(staffService);
	}

	public List<Staff> myDown(String myusername) {
		List<Staff> list = staffService.queryMyDown(myusername);
		return list;
	}

    public List<Staff> queryUsersByOrgIdAndRoleId(Map<String, Object> map) {
		return staffService.queryUsersByOrgIdAndRoleId(map);
    }
}
