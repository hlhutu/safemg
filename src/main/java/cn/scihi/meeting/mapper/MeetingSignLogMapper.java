package cn.scihi.meeting.mapper;

import cn.scihi.meeting.bean.MeetingSignLog;
import cn.scihi.sdk.base.mapper.IBaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author uplus
 *
 */
public interface MeetingSignLogMapper extends IBaseMapper {
    List<MeetingSignLog> selectForBean(MeetingSignLog condition);

    Integer updateById(@Param("log") MeetingSignLog log, @Param("meetingId") String meetingId);
}
