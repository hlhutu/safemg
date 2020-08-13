package cn.scihi.meeting.mapper;

import cn.scihi.meeting.bean.Meeting;
import cn.scihi.meeting.bean.MeetingCondition;
import cn.scihi.sdk.base.mapper.IBaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
public interface MeetingMapper extends IBaseMapper {
    List<Meeting> selectForBean(MeetingCondition condition);

    List<Map<String, Object>> countByStatus(@Param("year") String year, @Param("month") String month, @Param("username") String username);
}
