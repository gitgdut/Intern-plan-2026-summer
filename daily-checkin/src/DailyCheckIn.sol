// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DailyCheckIn
 * @notice 每日打卡合约 — 每人每天打一次，UTC 0 点自动重置
 *         部署时设定参与人数上限，管理员可后续修改
 */
contract DailyCheckIn {
    address public owner;
    uint256 public maxParticipants;

    struct Record {
        uint256 timestamp;
    }

    /// 每人最后一次打卡的"天编号"（+1 偏移，0 表示从未打过）
    mapping(address => uint256) public lastCheckInDay;
    /// 每人历史累计打卡次数
    mapping(address => uint256) public totalCheckIns;
    /// 每人的打卡记录
    mapping(address => Record[]) private _records;

    uint256 public todayCount;       // 当天已打卡人数
    uint256 private _currentDay;     // 当前天编号（0 = 未初始化）

    // ====================== 事件 ======================

    event CheckedIn(address indexed user, uint256 timestamp);
    event DayReset(uint256 newDay);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // ====================== 构造器 ======================

    constructor(uint256 _maxParticipants) {
        require(_maxParticipants > 0, "Max participants must be > 0");
        owner = msg.sender;
        maxParticipants = _maxParticipants;
    }

    // ====================== 打卡 ======================

    function checkIn() external {
        _initOrReset();

        require(lastCheckInDay[msg.sender] != _currentDay, "Already checked in today");
        require(todayCount < maxParticipants, "Today's quota reached");

        lastCheckInDay[msg.sender] = _currentDay;
        totalCheckIns[msg.sender]++;
        todayCount++;

        _records[msg.sender].push(Record(block.timestamp));

        emit CheckedIn(msg.sender, block.timestamp);
    }

    // ====================== 查询 ======================

    function hasCheckedInToday(address _user) external view returns (bool) {
        return _currentDay > 0 && lastCheckInDay[_user] == _currentDay;
    }

    function getTodayCount() external view returns (uint256) {
        return todayCount;
    }

    function getTotalCheckIns(address _user) external view returns (uint256) {
        return totalCheckIns[_user];
    }

    function getRecords(address _user) external view returns (Record[] memory) {
        return _records[_user];
    }

    function getRecordCount(address _user) external view returns (uint256) {
        return _records[_user].length;
    }

    // ====================== 管理员 ======================

    function setMaxParticipants(uint256 _newMax) external onlyOwner {
        require(_newMax > 0, "Max participants must be > 0");
        maxParticipants = _newMax;
    }

    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        owner = _newOwner;
    }

    // ====================== 内部 ======================

    /// @notice UTC 自然日编号（+1 偏移，避免 day 0 和"未打卡"冲突）
    function _today() private view returns (uint256) {
        return block.timestamp / 1 days + 1;
    }

    /// @notice 首次调用初始化，跨天则重置
    function _initOrReset() private {
        uint256 today = _today();
        if (_currentDay == 0) {
            _currentDay = today;
        } else if (today != _currentDay) {
            _currentDay = today;
            todayCount = 0;
            emit DayReset(today - 1);
        }
    }
}
