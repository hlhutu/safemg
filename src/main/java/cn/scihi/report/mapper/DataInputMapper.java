package cn.scihi.report.mapper;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface DataInputMapper extends IBaseMapper {
    List<Map<String, Object>> queryOrgUsersReport(@Param("p_org_id") String p_org_id);

    List<Map<String, Object>> queryOrgRolesReport(@Param("orgs") List<Map<String, Object>> orgs, @Param("p_org_id") String p_org_id);

    List<Map<String, Object>> queryOrgModelsReport(@Param("orgs") List<Map<String, Object>> orgs, @Param("p_org_id") String p_org_id);
}
